#pragma pattern_limit 1048576
#pragma endian little

u32 S770_AUDIO_DATA_ADDR = 0x2B5800;
u32 S760_AUDIO_DATA_ADDR = 0x3B6000;

u32 audio_data_addr;

enum media_type_t: u8
{
    HDD, //also used for CDs
	HDD_with_OS = 0x20,
	DSDD_SYS_770 = 0x31,
	DSHD_diskette,
	DSDD_diskette,
	HDD_with_OS_S760 = 0x40,
	DSHD_SYS_760 = 0x50
};

struct Header
{
    padding[4];
    char machine_name[10];
    padding[1];
    media_type_t media_type;
    char sys_version[80];
    
    if(media_type == media_type_t::HDD_with_OS
    || media_type == media_type_t::HDD_with_OS_S760)
    {
        u8 S7XX_OS_data[0x80000] @ 0x800;
    }
};

struct TOC
{
    char name[16];
    u32 block_count;
    u16 volume_cnt;
    u16 performance_cnt;
    u16 patch_cnt;
    u16 partial_cnt;
    u16 sample_cnt;
    padding[2];
};

struct FAT_t
{
    u16 psycho_killer; //0xFFFA
    u16 free_segments;
    u16 FAT[65524];
    u8 unused[20];
};

enum ElementType: u8
{
    volume = 0x40,
    performance,
    patch,
    partial,
    sample
};

struct ListEntryBase
{
    char name[16];
    ElementType type;
};

struct GenericListEntry: ListEntryBase
{
    u8 data[15];
};

struct Volume_list_entry: ListEntryBase
{
    u8 unknown[10];
    u8 program_num;
    u8 unused[2];
    u16 segment_cnt;
};

struct PatchListEntry: ListEntryBase
{
    u8 unknown[13];
    u16 segment_cnt;
};

struct PartialListEntry: ListEntryBase
{
    u8 unknown[13];
    u16 segment_cnt;
};

struct SampleListEntry: ListEntryBase
{
    u8 unknown[11];
    u16 start_segment;
    u16 segment_cnt;
};

struct Volume
{
    char name[16];
    padding[16];
    u16 performance_indices[112];
};

bitfield Enable_Volume
{
    volume: 7;
    enable: 1;
};

struct Extra_perf_params //S-760 only?
{
    s8 output_high_gain[8];
    s8 output_high_freq[8]; //0 = 6K
    s8 output_low_gain[8];
    s8 output_low_freq[8]; //0 = 120
    u8 part_output_map[32];
    s8 part_pan[32];
    u16 pan_filter;
    u16 pan_filter2;
};

struct Performance
{
    char name[16];
    u8 part_patch_map[32];
    u8 part_chan_map[16];
    Enable_Volume part_volume[32];
    u8 part_low_note[32];
    u8 part_high_note[32];
    u8 part_low_fade_width[32];
    u8 part_high_fade_width[32];
    u16 prog_change_filter;
    u16 pitch_bend_filter;
    u16 modulation_filter;
    u16 hold_filter;
    u16 phase_lock;
    u16 volume_filter;
    u16 aftertouch_filter;
    u16 aftertouch_filter2;
    u8 velo_curve_type[16];
    u16 abs_patch_indices[32];
    
    u8 unused[63];
    u8 ex_perf_params_flag;
        
    if(ex_perf_params_flag == 0)
    {
        Extra_perf_params ex_perf_params;
        u8 unused2[28];
    }
    else u8 unused2[128];
};

enum SMT_csel_t: u8
{
    pitch_bend,
    aftertouch,
    modulation,
    control_change,
    off = 255
};

struct Patch
{
    char name[16];
    u8 patch_num;
    u8 unknown;
    s8 pan;
    u8 volume;
    u8 special_mono_out;
    bool priority;
    s8 cutoff;
    s8 velocity;
    s8 octave_shift;
    s8 coarse_tune;
    s8 fine_tune;
    SMT_csel_t SMT_csel;
    s8 SMT_csense;
    u8 mono_out;
    u8 analog_feel;
    u8 output_abs;
    u8 key_partial_map[88];
    u8 unknown2[8];
    u8 key_group_map[88];
    u8 unknown3[8];
    u8 p_bend_up_range; //semitones
    u8 p_bend_down_range; //semitones
    s8 bend_to_TVA_level;
    s8 bend_to_TVF_freq;
    s8 aftertouch_to_pitch; //semitones
    s8 aftertouch_to_TVA_level;
    s8 aftertouch_to_TVF_freq;
    s8 aftertouch_to_LFO_rate;
    s8 aftertouch_to_LFO_depth; //a.k.a. aftertouch
    s8 aftertouch_to_LFO_to_TVA; //LFO to TVA level depth
    s8 aftertouch_to_LFO_to_TVF; //LFO to TVF freq depth
    s8 mod_to_LFO_rate;
    s8 mod_to_LFO_depth; //a.k.a. modulation
    s8 mod_to_LFO_to_TVA; //LFO to TVA level depth
    s8 mod_to_LFO_to_TVF; //LFO to TVF freq depth
    s8 resonance;
    u8 ctrl_sel;
    s8 control_to_pitch;
    s8 control_to_TVA_level;
    s8 control_to_TVF_freq;
    s8 control_to_LFO_rate;
    s8 control_to_LFO_depth;
    s8 control_to_LFO_to_TVA; //LFO to TVA level depth
    s8 control_to_LFO_to_TVF; //LFO to TVF freq depth
    s8 attack;
    s8 release;
    s8 aftertouch_to_LFO_to_pan; //S-760 V2
    s8 mod_to_LFO_to_pan; //S-760 V2
    s8 control_to_LFO_to_pan; //S-760 V2
    bool oneshot; //S-760 V2
    u8 unknown4[2];
    u16 abs_partial_indices[128];
};

enum Pan_special_values: s8
{
    rnd = 33,
    key_plus,
    key_minus,
    LFO_plus,
    LFO_minus,
    alt
};

union Partial_sample_entry_pan
{
    s8 value;
    Pan_special_values special;
};

struct PartialSampleEntry
{
    u16 sample_index;
    s8 key_shift; //normal = 8
    u8 volume;
    Partial_sample_entry_pan pan;
    s8 coarse_tune;
    s8 fine_tune;
    u8 low_vel;
    u8 low_fade;
    u8 high_vel;
    u8 high_fade;
};

enum Filter_mode_t: u8
{
    low_pass,
    band_pass,
    high_pass,
    off = 0xFF
};

enum LFO_waveform_t: u8
{
    sine,
    tri,
    saw_up,
    saw_down,
    square,
    rnd,
    bend_up,
    bend_down
};

struct Partial
{
    char name[16];
    PartialSampleEntry sample_entry1;
    u8 unknown;
    u8 output_mono;
    u8 unknown2;
    u8 volume;
    u8 special_mono_out; //likely related to outputs
    PartialSampleEntry sample_entry2;
    u8 unknown3;
    s8 pan;
    s8 coarse_tune;
    s8 fine_tune;
    bool SMT_vctrl;
    PartialSampleEntry sample_entry3;
    u8 unknown4;
    u8 output_abs;
    u8 unknown5[3];
    PartialSampleEntry sample_entry4;
    Filter_mode_t filter_mode;
    u8 filter_cutoff;
    u8 resonance;
    u8 TVF_vel_curve;
    s8 TVF_csens;
    s8 TVF_time_vel_sens;
    s8 TVF_env_vel_sens;
    u8 TVF_env_release_cutoff;
    u8 TVF_env_attack_cutoff;
    u8 TVF_env_decay_cutoff;
    u8 TVF_env_sustain_cutoff;
    u8 TVF_env_attack_time;
    u8 TVF_env_decay_time;
    u8 TVF_env_sustain_time;
    u8 TVF_env_release_time;
    s8 TVF_env_TVF_depth;
    s8 TVF_env_pitch_depth;
    u8 TVF_KF_point; //MIDI keynum
    s8 TVF_time_KF;
    u8 unknown6;
    s8 TVF_cutoff_KF; //see manual
    u8 TVA_vel_curve;
    u8 TVA_csens;
    s8 TVA_time_vel_sens;
    u8 unknown7;
    u8 TVA_env_attack_level;
    u8 TVA_env_decay_level;
    u8 TVA_env_sustain_level;
    u8 TVA_env_attack_time;
    u8 TVA_env_decay_time;
    u8 TVA_env_sustain_time;
    u8 TVA_env_release_time;
    u8 unknown8;
    u8 TVA_KF_point;
    s8 TVA_time_KF;
    u8 unknown9;
    s8 TVA_level_KF;
    LFO_waveform_t LFO_waveform;
    u8 LFO_rate;
    bool LFO_key_sync;
    u8 LFO_delay;
    u8 LFO_delay_KF;
    u8 LFO_rate_detune;
    u8 LFO_pitch_depth;
    u8 LFO_TVF_depth;
    u8 LFO_TVA_depth;
    u8 LFO_pan_depth;
    s8 TVF_rls_vel_sens;
    s8 TVA_rls_vel_sens;
    u8 unknown10[4];
};

enum Looping: u8
{
    fwd,
    fwd_rls,
    off, //oneshot
    fwd_plus_one,
    alt,
    rev_one,
    rev
};

enum SampleRate: u8
{
    FourtyEight_KHz,
    FourtyFour_Point_One_KHz,
    TwentyFour_KHz,
    TwentyTwo_Point_OhFive_KHz,
    Thirty_KHz,
    Fifteen_KHz,
    ThirtyTwo_KHz,
    Sixteen_KHz
};

bitfield Format
{
    SampleRate sample_rate: 3;
    padding: 1;
    unknown: 1;
    padding: 3;
};

struct SampleParameters
{
    char name[16];
    u8 unknown;
    u24 start_offset;
    u8 loop_fine_start;
    u24 loop_start;
    u8 unknown3;
    u24 loop_end;
    u8 release_loop_fine_start;
    u24 release_loop_start;
    u8 unknown5;
    u24 release_loop_end;
    Looping looping;
    u8 unknown6;
    s8 loop_tune;
    s8 release_loop_tune;
    u8 start_segment;
    u8 disk_index;
    u16 segment_cnt;
    Format format;
    u8 root_note;
    u8 unknown9[2];
};

Header header @ 0x0;

if(header.media_type == 0x40) audio_data_addr = S760_AUDIO_DATA_ADDR;
else audio_data_addr = S770_AUDIO_DATA_ADDR;

TOC toc @ 0x100;
FAT_t FAT @ 0x80800;
Volume_list_entry volume_list[toc.volume_cnt] @ 0xA0800;
GenericListEntry performance_list[toc.performance_cnt] @ 0xA1800;
PatchListEntry patch_list[toc.patch_cnt] @ 0xA5800;
PartialListEntry partial_list[toc.partial_cnt] @ 0xAD800;
SampleListEntry sample_list[toc.sample_cnt] @ 0xCD800;
Volume volumes[toc.volume_cnt] @ 0x10D800;
Performance performances[toc.performance_cnt] @ 0x115800;
Patch patches[toc.patch_cnt] @ 0x155800;
Partial partials[toc.partial_cnt] @ 0x1D5800;
SampleParameters sample_parameters[toc.sample_cnt] @ 0x255800;
u8 start_of_sample_data @ audio_data_addr;
