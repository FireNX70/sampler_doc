#pragma endian little

#define PRESET_OFFSETS_ADDRESS 0x17CA
#define SAMPLE_OFFSETS_ADDRESS 0x1BD2
#define SAMPLE_OFFSET_OFFSET 0x400000
#define PRESET_SECTION_ADDRESS 0x2B72

struct Header
{
    char magic[16];
    char name[16];
    u32 obj_cnt;
    padding [12];
    u32 next_preset;
    u32 next_sample;
    u32 parameters[5];
    char name_copy[16];
    u32 selected_preset;
    u32 more_parameters[3];
};

struct PresetNoteZone
{
    u8 unknown[2];
    u8 primary_zone;
    u8 secondary_zone;
};

enum LFOShape: u8
{
    triangle,
    sine,
    sawtooth,
    square
};

enum VCFType: u8
{
    two_pole_lowpass,
    four_pole_lowpass,
    six_pole_lowpass,
	second_ord_hipass,
	fourth_ord_hipass,
	second_ord_bandpass,
	fourth_ord_bandpass,
	contrary_bandpass,
	swept_EQ_1_oct,
	swept_EQ_2_1,
	swept_EQ_3_1,
	phaser_1,
	phaser_2,
	bat_phaser,
	flanger_lite,
	vocal_ah_ay_ee,
	vocal_oo_ah,
	bottom_feeder,
	ESi_E3x_lowpass,
	unknown
};

bitfield VCFTypeLFOShape
{
    LFOShape LFO_shape: 3;
    VCFType VCF_type: 5;
};

struct ZoneParameters
{
    u8 root_note;
    u16 sample_ID;
    u8 parameter_a;
    u8 VCA_env[5];
    char parameters_b[2];
    u8 LFO_variation;
    u8 cutoff;
    u8 resonance;
    u8 VCF_env_amount;
    u8 VCF_env[5];
    u8 AUX_env[5];
    u8 AUX_env_amount;
    u8 AUX_env_dest;
    u8 vel_to_VCA_level;
    u8 vel_to_VCA_attack;
    u8 vel_to_VCF_cutoff;
    u8 vel_to_pitch;
    u8 vel_to_AUX_env;
    u8 vel_to_VCF_resonance;
    u8 vel_to_VCF_attack;
    u8 vel_to_sample_start;
    u8 vel_to_VCA_pan;
    u8 LFO_to_pitch;
    u8 LFO_to_VCA;
    u8 LFO_to_cutoff;
    u8 LFO_to_pan;
    u8 VCA_level;
    u8 unknown[3];
    u8 VCA_pan;
    VCFTypeLFOShape VCF_type_LFO_shape;
    u8 end[2];
};

struct Preset
{
    char name[16];
    u8 rt_controls[12];
    u8 unknown[16];
    u8 bend_range;
    u8 unknown2[8];
    u8 zone_cnt;
    u8 zone_map[88];
    PresetNoteZone note_zones[zone_cnt];
    ZoneParameters zone_parameters[zone_cnt];
};

bitfield SampleFormat
{
    dunno: 16;
    bool loop: 1;
    dunno2: 2;
    bool loop_release: 1;
    dunno3: 2;
    bool stereo: 1;
    dunno4: 9;
};

struct Sample
{
    char name[16];
    u32 unknown;
    u32 left_channel_offset;
    u32 right_channel_offset;
    u32 left_channel_end_offset;
    u32 right_channel_end_offset;
    u32 left_channel_loop_offset;
    u32 right_channel_loop_offset;
    u32 left_channel_loop_end_offset;
    u32 right_channel_loop_end_offset;
    u32 sample_rate;
    SampleFormat sample_format;
    u32 more_parameters[8];
};

Header header @ 0x00;
u32 preset_offsets[256] @ PRESET_OFFSETS_ADDRESS;
u32 sample_block_offset @ 0x1BCA;
u32 sample_offsets[999] @ SAMPLE_OFFSETS_ADDRESS;
u32 next_sample_offset @ 0x2B6E;
Preset preset @ PRESET_SECTION_ADDRESS;
Sample sample @ PRESET_SECTION_ADDRESS + sample_block_offset + 1;
Sample sample2 @ PRESET_SECTION_ADDRESS + sample_block_offset + 1 + sample_offsets[1] - SAMPLE_OFFSET_OFFSET;