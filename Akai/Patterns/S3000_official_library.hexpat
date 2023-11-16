#pragma endian little

u16 BLOCK_SIZE = 8192;
u16 PART1_MAX_FAT_SIZE = 15606;
u16 PARTN_MAX_FAT_SIZE = 18678;

struct Header
{
    u16 part_size; //blocks
    u8 unknown[196];
    u8 checksum;
    u8 checksum2;
    u8 unknown2[2]; //probably padding
};

enum ElementType: u8
{
    unused,
    S1000,
    S3000 = 3
};

struct VolumeEntry
{
    char name[12];
    ElementType type;
    u8 unknown;
    u16 start_block;
};

enum FATType: u16
{
    free,
    reserved_info = 0x4000,
    reserved_other = 0x8000,
    end_of_file = 0xC000,
};

struct PartitionTable
{
    u8 part_cnt;
    u8 unknown;
    u16 part_sizes[part_cnt]; //blocks
    u16 total_disk_size; //also blocks
};

enum FileType: u8
{
    drum = 0x64,
    S1000_program = 0x70,
    cue_list,
    S1000_sample = 0x73,
    take_list,
    effect = 0x78,
    S3000_program = 0xF0,
    S3000_sample = 0xF3
};

struct FileEntry
{
    char name[12];
    u8 unknown[4];
    FileType type;
    u24 size;
    u16 start;
    u8 unknown2[2];
};

struct S1000VelocityZone
{
    char sample_name[12];
    u8 low_vel;
    u8 high_vel;
    u16 tuning;
    s8 level;
    s8 filter_freq;
    s8 pan;
    u8 loop_in_release;
    u8 unknown[4];
};

struct S1000KeyGroup
{
    u8 keygrp_id;
    u16 nx_keygrp_addr; //block
    u8 low_note;
    u8 high_note;
    s8 fine_tune;
    s8 coarse_tune;
    u8 filter_freq;
    u8 key_to_filter_freq;
    u8 vel_to_filter_freq;
    u8 pressure_to_filter_freq;
    u8 env_to_filter_freq;
    u8 amp_env[4]; //ADSR
    u8 vel_to_amp_atk;
    u8 vel_to_amp_rel;
    u8 off_vel_to_amp_rel;
    u8 key_to_amp_dec_and_rel;
    u8 filter_env[4]; //ADSR
    u8 vel_to_filter_atk;
    u8 vel_to_filter_rel;
    u8 off_vel_to_filter_rel;
    u8 key_to_filter_dec_and_rel;
    u8 vel_to_filter_env_amnt;
    u8 filter_env_to_pitch;
    bool vel_zone_xfade;
    u8 vel_zone_cnt; //max 4
    u8 unknown[2];
    S1000VelocityZone zones[vel_zone_cnt];
    s8 fixed_rate_detune;
    bool atk_hold_until_loop;
    bool const_pitch_for_zones[vel_zone_cnt];
    bool out_offset_for_zones[vel_zone_cnt];
    s16 vel_to_sample_start[vel_zone_cnt];
    s8 vel_to_level;
    u8 unknown2;
};

struct S1000Program
{
    u8 index; //1 based?
    u16 first_keygroup_addr;
    char name[12]; //AKAI's encoding
    u8 MIDI_patch_num;
    u8 MIDI_chan; //or maybe part?
    u8 polyphony; //voice count?
    u8 priority;
    u8 low_note;
    u8 high_note;
    s8 key_shift;
    u8 output;
    u8 stereo_level; //for main stereo out
    s8 pan;
    u8 program_level; //for the patch itself
    u8 vel_to_level;
    u8 key_to_level; //for aftertouch?
    u8 pressure_to_level; //also sounds like aftertouch
    u8 pan_LFO_rate;
    u8 pan_depth;
    u8 pan_LFO_delay;
    u8 key_to_pan_pos;
    u8 LFO_rate;
    u8 LFO_depth;
    u8 LFO_delay;
    u8 modwh_to_depth;
    u8 pressure_to_depth;
    u8 vel_to_depth;
    u8 bendwh_to_pitch;
    u8 pressure_to_pitch;
    bool keygrp_xfade;
    u8 keygrp_cnt;
    u8 temp_prog_num;
    u8 key_temperament[12]; //I don't even know
    bool fx_out; //to enable fx routing?
    u8 modwh_pan_amnt;
    bool sample_start_coherence; //dunno, called stereo coherence on Paul Kellett's doc
    bool LFO_desync;
    u8 pitch_law;
    u8 voice_steal_type;
    u8 sft_pdl_lv_reduction;
    u8 sft_pdl_atk_stretch;
    u8 sft_pdl_filter_close;
    s8 fine_tune;
    s8 coarse_tune;
    u8 key_to_LFO_rate;
    u8 key_to_LFO_depth;
    u8 key_to_LFO_delay;
    u8 voice_output_scale;
    u8 stereo_output_scale;
    u8 unknown[78];
    S1000KeyGroup key_groups[keygrp_cnt];
};

struct VelocityZone
{
    char sample_name[12];
    u8 low_vel;
    u8 high_vel;
    u16 tuning;
    u8 level;
    u8 filter_freq;
    u8 pan;
    u8 loop_in_release;
    u8 low_vel_xfade;
    u8 high_vel_xfade;
    u16 sample_start_block;
};

struct KeyGroup
{
    u8 keygrp_id;
    u16 nx_keygrp_addr; //block
    u8 low_note;
    u8 high_note;
    u16 tune_offset;
    u8 filter_freq;
    u8 key_to_filter_freq;
    u8 vel_to_filter_freq;
    u8 pressure_to_filter_freq;
    u8 env_to_filter_freq;
    u8 amp_env[4]; //ADSR
    u8 vel_to_amp_atk;
    u8 vel_to_amp_rel;
    u8 off_vel_to_amp_rel;
    u8 key_to_amp_dec_and_rel;
    u8 filter_env[4]; //ADSR
    u8 vel_to_filter_atk;
    u8 vel_to_filter_rel;
    u8 off_vel_to_filter_rel;
    u8 key_to_filter_dec_and_rel;
    u8 vel_to_filter_env_amnt;
    u8 filter_env_to_pitch;
    bool vel_zone_xfade;
    u8 vel_zone_cnt; //max 4
    u8 unknown[2];
    VelocityZone zones[vel_zone_cnt];
    u8 fixed_rate_detune;
    u8 atk_hold_until_loop;
    u8 const_pitch_for_zones[vel_zone_cnt];
    u8 out_offset_for_zones[vel_zone_cnt];
    u16 vel_to_sample_start[vel_zone_cnt];
    u8 vel_to_level;
    u8 unknown2[43];
};

struct Program
{
    u8 index; //1 based?
    u16 first_keygroup_addr;
    char name[12]; //AKAI's encoding
    u8 MIDI_patch_num;
    u8 MIDI_chan; //or maybe part?
    u8 polyphony; //voice count?
    u8 priority;
    u8 low_note;
    u8 high_note;
    s8 key_shift;
    u8 output;
    u8 stereo_level; //for main stereo out
    s8 pan;
    u8 program_level; //for the patch itself
    u8 vel_to_level;
    u8 key_to_level; //for aftertouch?
    u8 pressure_to_level; //also sounds like aftertouch
    u8 pan_LFO_rate;
    u8 pan_depth;
    u8 pan_LFO_delay;
    u8 key_to_pan_pos;
    u8 LFO_rate;
    u8 LFO_depth;
    u8 LFO_delay;
    u8 modwh_to_depth;
    u8 pressure_to_depth;
    u8 vel_to_depth;
    u8 bendwh_to_pitch;
    u8 pressure_to_pitch;
    bool keygrp_xfade;
    u8 keygrp_cnt;
    u8 temp_prog_num;
    u8 key_temperament[12]; //I don't even know
    bool echo_out_level; //it's called a level but it's marked as a bool
    u8 modwh_pan_amnt;
    bool sample_start_coherence; //dunno
    bool LFO_desync;
    u8 pitch_law;
    u8 voice_steal_type;
    u8 sft_pdl_lv_reduction;
    u8 sft_pdl_atk_stretch;
    u8 sft_pdl_filter_close;
    u16 tune_offset;
    u8 key_to_LFO_rate;
    u8 key_to_LFO_depth;
    u8 key_to_LFO_delay;
    u8 voice_output_scale;
    u8 stereo_output_scale;
    u8 unknown[120];
    KeyGroup key_groups[keygrp_cnt];
};

struct Loop
{
    u32 loop_end;
    u16 loop_len_fine;
    u32 loop_len_coarse;
    u16 loop_time;
};

struct S1000Sample
{
    //Hiroyuki Ohsaki's documentation claims the first
    //byte follows the ElementType enum; but I've only
    //ever seen a value of 3 even on S1000 libraries,
    //which matches Paul Kellett's doc
    u8 three; 
    u8 bandwidth;
    u8 root_note;
    char name[12];
    u8 unknown;
    u8 loop_cnt;
    u8 unknown2[2];
    u8 loop_type;
    u8 fine_tune;
    u8 coarse_tune;
    u8 unknown3[4];
    u32 audio_length;
    u32 audio_start_offset;
    u32 audio_end_offset;
    Loop loops[8];
    u8 unknown4[2];
    u16 stereo_partner_idx;
    u16 sample_rate;
    u8 hold_loop_tuning;
    u8 unknown5[9];
    u8 audio_data[audio_length * 2];
};

struct Sample
{
    ElementType type;
    u8 bandwidth;
    u8 root_note;
    char name[12];
    u8 unknown;
    u8 loop_cnt;
    u8 first_loop;
    u8 unknown2;
    u8 loop_type;
    u8 fine_tune;
    u8 coarse_tune;
    u32 audio_start_addr;
    u32 audio_length;
    u32 audio_start_offset;
    u32 audio_end_offset;
    Loop loops[8];
    u8 unknown5[2];
    u16 stereo_partner_idx;
    u16 sample_rate;
    u8 hold_loop_tuning;
    u8 unknown6[51];
    u8 audio_data[audio_length * 2];
};

struct PartitionBase
{
    Header header;
    VolumeEntry volume_list[100];
    FATType fat[header.part_size];
};

struct FirstPartition: PartitionBase
{
    u8 leftover_FAT_space[PART1_MAX_FAT_SIZE - header.part_size * 2];
    u8 unknown2[256]; //probably leftover space for the FAT
    PartitionTable partition_table; //seems to always be at 0x4500
    u8 unknown3[256 - 4 - 2 * partition_table.part_cnt]; //part padding, part I-don't-know
    u8 unknown4[2560]; //might usually be taken up by the FAT
    u8 unknown5[384]; //dunno
    u8 unknown6[3712]; //might be padding
};

struct NormalPartition: PartitionBase
{
    u8 leftover_FAT_space[PARTN_MAX_FAT_SIZE - header.part_size * 2];
    u8 unknown[384]; //dunno
    u8 unknown2[3712]; //might be padding
};

FirstPartition partition @ 0x0;

FileEntry file_list[51] @ 0x31FE000;

Program program_at_0x3202000 @ 0x3202000;
Program program_at_0x3204000 @ 0x3204000;
Sample sample_at_0x3220000 @ 0x3220000;

Program program @ 0x3882000;

NormalPartition partition2 @ 0x3C00000;
NormalPartition partition9 @ 0x1E000000;

FileEntry sample_name @ 0xD4823F0;
char sample_name2[16] @ 0xD49A622;
char sample_name3[16] @ 0xD49C622;
char sample_name4[16] @ 0xD49E622;
char sample_name5[16] @ 0xD4A0622;
char sample_name6[16] @ 0xD4A2622;
char sample_name7[16] @ 0xD4A4622;
char other_sample_name[16] @ 0xD482360;
char other_sample_name2[16] @ 0xD49A622;
char other_sample_name3[16] @ 0xD49C622;
char other_sample_name4[16] @ 0xD49E622;
char other_sample_name5[16] @ 0xD4A0622;
char other_sample_name6[16] @ 0xD4A2622;
char other_sample_name7[16] @ 0xD4A4622;
//char sample_name8[16] @ 0xD5AC003;
Sample sample_params @ 0xD5AC000;
Sample other_sample_params @ 0xD562000;