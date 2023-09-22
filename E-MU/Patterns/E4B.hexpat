#pragma endian big

struct IFFChunkBase
{
    char four_cc[4];
    u32 size;
};

struct E4BChunkBase: IFFChunkBase
{
    u16 index;
};

struct TOCEntry: IFFChunkBase
{
    u32 address;
    u16 index;
    char name[16];
    padding[2];
};

struct TOC1: IFFChunkBase
{
    TOCEntry entries[size / sizeof(TOCEntry)];
};

enum Submix: u8
{
    main,
    sub1,
    sub2,
    sub3,
    voice = 255
};

struct MultimapEntry
{
    u16 preset_idx;
    u8 vol;
    u8 pan;
    Submix submix;
    u8 unknown[3];
};

struct E4Ma: E4BChunkBase
{
    MultimapEntry entries[32];
};

struct AADDRREnvelope
{
    u8 atk1_rate;
    u8 atk1_level;
    u8 atk2_rate;
    u8 atk2_level;
    u8 dec1_rate;
    u8 dec1_level;
    u8 dec2_rate;
    u8 dec2_level;
    u8 rel1_rate;
    u8 rel1_level;
    u8 rel2_rate;
    u8 rel2_level;
};

enum Filter: u8
{
    lowpass_4_pole,
    lowpass_2_pole,
    lowpass_6_pole,
    highpass_2nd_ord = 8,
    highpass_4th_ord,
    bandpass_2nd_ord = 16,
    bandpass_4th_ord,
    bandpass_contrary,
    swept_eq_1_octave = 32,
    swept_eq_2_1_octave,
    swept_eq_3_1_octave,
    phaser1 = 64,
    phaser2,
    bat_phaser,
    flanger_lite = 72,
    vocal_ah_ay_ee = 80,
    vocal_oo_ah,
    dual_eq_morph = 96,
    dual_eq_lowpass_morph,
    dual_eq_morph_xpressn,
    peak_shelf_morph = 104
};

enum Shape: u8
{
    triangle,
    sine,
    sawtooth,
    square,
    pulse_33,
    pulse_25,
    pulse_16,
    pulse_12,
    octaves,
    fifth_oct,
    sus4_trip,
    neener,
    sine_1_2,
    sine_1_3_5,
    sine_noise,
    hemi_quaver,
    random = 255
};

enum Sync: u8
{
    keysync,
    freerun
};

struct LFO
{
    u8 rate;
    Shape shape;
    u8 delay;
    u8 variation;
    Sync sync;
};

enum SoloMode: u8
{
    off,
    multiple_trigger,
    melody_last,
    melody_low,
    melody_high,
    synth_last,
    synth_low,
    synth_high,
    fingered_glide
};

enum AssignGroup: u8
{
    poly_all,
    poly_16A,
    poly_16B,
    poly_8A,
    poly_8B,
    poly_8C,
    poly_8D,
    poly_4A,
    poly_4B,
    poly_4C,
    poly_4D,
    poly_2A,
    poly_2B,
    poly_2C,
    poly_2D,
    monoA,
    monoB,
    monoC,
    monoD,
    monoE,
    monoF,
    monoG,
    monoH,
    monoI
};

enum Source: u8
{
    off,
    xfade_rnd = 4,
    key_add = 8,
    key_to_zero,
    vel_add,
    vel_to_zero,
    vel_sub,
    release_vel,
    gate,
    pitch_wheel = 16,
    mod_wheel,
    pressure,
    pedal,
    MIDI_A,
    MIDI_B,
    foot_sw1,
    foot_sw2,
    foot_sw1_flip_flop,
    foot_sw2_flip_flop,
    MIDI_vol,
    MIDI_pan,
    MIDI_C = 32,
    MIDI_D,
    MIDI_E,
    MIDI_F,
    MIDI_G,
    MIDI_H,
    thumb,
    thumb_flip_flop,
    key_glide = 48,
    vol_env_add = 72,
    vol_env_to_zero,
    vol_env_sub,
    fil_env_add = 80,
    fil_env_to_zero,
    fil_env_sub,
    aux_env_add = 88,
    aux_env_to_zero,
    aux_env_sub,
    lfo1_to_zero = 96,
    lfo1_add,
    white_noise,
    pink_noise,
    k_rand1,
    k_rand2,
    lfo2_to_zero = 104,
    lfo2_add,
    lag0_in,
    lag0,
    lag1_in,
    lag1,
    clock_double = 144,
    clock,
    clock_half,
    clock_quarter,
    clock_eigth,
    clock_sixteenth,
    dc_offset = 160,
    sum_amp,
    switch,
    abs_val,
    diode,
    flip_flop,
    quantizer,
    gain_4x
};

enum Dest: u8
{
    off,
    key_sust = 8,
    fine_pitch = 47,
    pitch,
    glide,
    chorus_amount,
    chorus_position_ITD,
    sample_start,
    sample_loop,
    sample_retrigger,
    filter_freq = 56,
    filter_reso,
    amp_vol = 64,
    amp_pan,
    amp_xfd,
    vol_env_rates = 72,
    vol_env_atk,
    vol_env_dcy,
    vol_env_rls,
    fil_env_rates = 80,
    fil_env_atk,
    fil_env_dcy,
    fil_env_rls,
    fil_env_trggr = 86,
    aux_env_rates = 88,
    aux_env_atk,
    aux_env_dcy,
    aux_env_rls,
    aux_env_trggr = 94,
    lfo1_rate = 96,
    lfo1_trigger,
    lfo2_rate = 104,
    lfo2_trigger,
    lag0_in,
    lag1_in = 108,
    amp_sum = 161,
    switch,
    abs_val,
    diode,
    flip_flop,
    quantizer,
    gain_4x,
    cord0_amount,
    cord1_amount,
    cord2_amount,
    cord3_amount,
    cord4_amount,
    cord5_amount,
    cord6_amount,
    cord7_amount,
    cord8_amount,
    cord9_amount,
    cord10_amount,
    cord11_amount,
    cord12_amount,
    cord13_amount,
    cord14_amount,
    cord15_amount,
    cord16_amount,
    cord17_amount,
    cord18_amount,
    cord19_amount,
    cord20_amount,
    cord21_amount,
    cord22_amount,
    cord23_amount
};

struct Cord
{
    Source source;
    Dest dest;
    s8 amount;
    u8 unknown;
};

struct SampleZone
{
    u8 low_note;
    u8 low_note_fade;
    u8 high_note_fade;
    u8 high_note;
    u8 low_velo;
    u8 low_velo_fade;
    u8 high_velo_fade;
    u8 high_velo;
    u16 sample_idx;
    s16 fine_tune;
    u8 root_note;
    s8 volume;
    s8 pan;
    u8 unknown2[7];
};

enum LinkMIDIFlags: u24
{
    none,
    pitch = 1,
    mod = 2,
    pressure = 4,
    pedal = 8,
    controller_A = 16,
    controller_B = 32,
    controller_C = 64,
    controller_D = 128,
    foot_switch1 = 4096,
    foot_switch2 = 8192,
    thumby_button = 262144
};

struct E4Voice
{
    u16 size;
    u8 sample_cnt;
    u8 group_num;
    u8 unknown1[8];
    u8 low_note;
    u8 low_note_fade;
    u8 high_note_fade;
    u8 high_note;
    u8 low_velo;
    u8 low_velo_fade;
    u8 high_velo_fade;
    u8 high_velo;
    u8 low_rt;
    u8 low_rt_fade;
    u8 high_rt_fade;
    u8 high_rt;
    bool link;
    AssignGroup assign_group;
    u16 delay;
    u16 link_preset_idx;
    u8 unknown2;
    u8 delay_start_offset;
    s8 transpose;
    s8 coarse_tune;
    s8 fine_tune;
    u8 glide_rate;
    bool non_transpose;
    SoloMode solo_mode;
    u8 unknown3;
    s8 chorus_stereo_width;
    u8 chorus_amount; //0 = Off
    u8 unknown4;
    s8 chorus_initial_ITD;
    u8 unknown5[2];
    u24 link_MIDI_flags;
    bool latch_mode;
    u8 unknown6[2];
    u8 glide_curve;
    s8 volume;
    s8 pan;
    Submix submix;
    u8 amp_env_depth;
    Filter filter;
    u8 unknown7;
    u8 filter_param_1; //cutoff
    u8 filter_param_2; //resonance
    u8 unknown8[2];
    u8 filter_param_3; //filter_EQ1_low
    u8 filter_param_4; //filter_EQ1_high
    u8 filter_param_5; //filter_EQ1_gain
    u8 filter_param_6; //filter_EQ2_low
    u8 filter_param_7; //filter_EQ2_high
    u8 filter_param_8; //filter_EQ2_gain
    u8 unknown9[40];
    AADDRREnvelope amp_env;
    u8 unknown10[2];
    AADDRREnvelope filter_env;
    u8 unknown11[2];
    AADDRREnvelope lfo_env;
    u8 unknown12[2];
    LFO lfo1;
    u8 unknown13[3];
    LFO lfo2;
    u8 unknown14[2];
    u8 lag1;
    u8 unknown15;
    u8 lag2;
    u8 unknown16[20];
    Cord cords[24];
    SampleZone samples[sample_cnt];
};

struct FXEntry
{
    u8 effect_num;
    u8 param1;
    u8 param2;
    u8 param3; //FX_B_to_FX_A
    u8 main_fx_send;
    u8 sub1_fx_send;
    u8 sub2_fx_send;
    u8 sub3_fx_send;
};

struct E4P1: E4BChunkBase
{
    char name[16];
    u8 unknown[3];
    u8 num_voices;
    u8 unknown2[4];
    s8 transpose;
    s8 volume;
    u8 unknown3[28];
    u8 controllers[4]; //FF = Off
    FXEntry master_fx_A;
    FXEntry master_fx_B;
    u8 unknown4[8];
    E4Voice voices[num_voices];
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

struct E3S1: E4BChunkBase
{
    char name[16];
    u32 unknown;
    le u32 left_channel_offset;
    le u32 right_channel_offset;
    le u32 left_channel_end_offset;
    le u32 right_channel_end_offset;
    le u32 left_channel_loop_offset;
    le u32 right_channel_loop_offset;
    le u32 left_channel_loop_end_offset;
    le u32 right_channel_loop_end_offset;
    le u32 sample_rate;
    SampleFormat sample_format;
    u32 more_parameters[8];
    u8 data[size - 2 - 16 - (4 * 19)];
};

struct FORM: IFFChunkBase
{
    char file_type[4];
};

FORM form @ 0x00;