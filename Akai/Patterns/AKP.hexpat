#pragma endian little

struct RIFFChunkBase
{
    char fourCC[4];
    u32 size;
};

struct prg_chunk: RIFFChunkBase
{
    u8 unknown;
    u8 prg_num; //0 = off
    u8 keygrp_cnt;
    u8 unknown2[size - 3];
};

struct out_chunk: RIFFChunkBase
{
    u8 unknown;
    u8 level;
    u8 amp_mod1;
    u8 amp_mod2;
    u8 pan_mod1;
    u8 pan_mod2;
    u8 pan_mod3;
    s8 vel_sens;
    u8 unknown2[size - 8];
};

enum bend_mode_t: u8
{
    normal,
    held
};

struct tune_chunk: RIFFChunkBase
{
    u8 unknown;
    s8 coarse_tune;
    s8 fine_tune;
    s8 c_detune;
    s8 csh_detune;
    s8 d_detune;
    s8 eft_detune;
    s8 e_detune;
    s8 f_detune;
    s8 fsh_detune;
    s8 g_detune;
    s8 gsh_detune;
    s8 a_detune;
    s8 bft_detune;
    s8 b_detune;
    u8 pitch_bend_up;
    u8 pitch_bend_down;
    bend_mode_t bend_mode;
    s8 aftertouch;
    u8 data[size - 19];
};

enum waveform_t: u8
{
    sine,
    triangle,
    square,
    square_pls,
    square_mns,
    saw_bi,
    saw_up,
    saw_dw,
    rand
};

struct lfo_chunk: RIFFChunkBase
{
    u8 unknown;
    waveform_t waveform;
    u8 rate;
    u8 delay;
    u8 depth;
    bool sync; //lfo1 only
    bool retrigger; //lfo2 only
    u8 modwheel; //lfo1 only
    u8 aftertouch; //lfo1 only
    s8 mod_rate;
    s8 mod_delay;
    s8 mod_depth;
    u8 data[size - 12];
};

enum mod_src_t: u8
{
    no_source,
    modwheel,
    bend,
    aftertouch,
    external,
    velocity,
    keyboard,
    lfo1,
    lfo2,
    amp_env,
    filt_env,
    aux_env,
    d_modwheel,
    d_bend,
    d_external
};

struct keygrp_mods_entry
{
    mod_src_t pitch_mod1_srsc;
    u8 unknown;
    mod_src_t pitch_mod2_src;
    u8 unknown2;
    mod_src_t amp_mod_src;
    u8 unknown3;
    mod_src_t filt_mod_src1;
    u8 unknown4;
    mod_src_t filt_mod_src2;
    u8 unknown5;
    mod_src_t flit_mod_src3;
};

struct mods_chunk: RIFFChunkBase
{
    u8 unknown[5];
    mod_src_t amp_mod1_src;
    u8 unknown2;
    mod_src_t amp_mod2_src;
    u8 unknown3;
    mod_src_t pan_mod1_src;
    u8 unknown4;
    mod_src_t pan_mod2_src;
    u8 unknown5;
    mod_src_t pan_mod3_src;
    u8 unknown6;
    mod_src_t lfo1_rate_mod_src;
    u8 unknown7;
    mod_src_t lfo1_delay_mod_src;
    u8 unknown8;
    mod_src_t lfo1_depth_mod_src;
    u8 unknown9;
    mod_src_t lfo2_rate_mod_src;
    u8 unknown10;
    mod_src_t lfo2_delay_mod_src;
    u8 unknown11;
    mod_src_t lfo2_depth_mod_src;
    u8 unknown12;
    keygrp_mods_entry keygrp_mods[1];
    u8 data[size - 27 - sizeof(keygrp_mods_entry) * 1];
};

enum FX_override_t: u8
{
    off,
    fx1,
    fx2,
    rv3,
    rv4
};

struct kloc_chunk: RIFFChunkBase
{
    u8 unknown[4];
    u8 low_note;
    u8 high_note;
    s8 coarse_tune;
    s8 fine_tune;
    FX_override_t FX_override;
    u8 fx_send_lv;
    s8 pitch_mod1;
    s8 pitch_mod2;
    s8 amp_mod;
    bool zone_xfade;
    u8 mute_group;
    u8 unknown2;
    u8 unknown3[size - 16];
};

struct env_chunk: RIFFChunkBase
{
    u8 unknown;
    u8 atk; //aux rate1
    u8 rate2; //aux only
    u8 dec; //aux rate3
    u8 rel; //aux rate4
    u8 level1; //aux only
    u8 level2; //aux only
    u8 sus; //aux level3
    u8 level4; //aux only
    s8 depth; //filt only
    s8 vel_to_atk; //aux vel_to_rate1
    u8 unknown2;
    s8 key_scale; //aux keybd_to_r2_r4
    u8 unknown3;
    s8 on_vel_to_rel;
    s8 off_vel_to_rel;
    s8 vel_to_level;
    u8 unknown4;
    u8 data[size - 18];
};

enum filter_mode_t: u8
{
    two_pole_lp,
    four_pole_lp,
    two_pole_lp_pls,
    two_pole_bp,
    four_pole_bp,
    two_pole_bp_pls,
    one_pole_hp,
    two_pole_hp,
    one_pole_ho_pls,
    lo_hi,
    lo_band,
    band_hi,
    notch,
    notch2,
    notch3,
    wide_notch,
    bi_notch,
    peak1,
    peak2,
    peak3,
    wide_peak,
    bi_peak,
    phaser1,
    phaser2,
    bi_phase,
    voweliser
};

struct filt_chunk: RIFFChunkBase
{
    u8 unknown;
    filter_mode_t filter_mode;
    u8 cutoff;
    u8 resonance;
    s8 keytrck;
    s8 mod_input1;
    s8 mod_input2;
    s8 mod_input3;
    u8 headroom;
    u8 unknown2;
    u8 data[size - 10];
};

enum loop_mode_t: u8
{
    no_loop,
    oneshot,
    loop_in_rel,
    loop_until_rel,
    as_sample
};

enum output_t: u8
{
    multi,
    one_two,
    three_four,
    five_six,
    seven_eight,
    nine_ten,
    eleven_twelve,
    thirteen_fourteen,
    fifteen_sixteen,
    one,
    two,
    three,
    four,
    five,
    six,
    seven,
    eight,
    nine,
    ten,
    eleven,
    twelve,
    thirteen,
    fourteen,
    fifteen,
    sixteen
};

struct zone_chunk: RIFFChunkBase
{
    u8 unknown;
    u8 sample_name_len;
    char sample_name[20];
    u8 unknown2[12];
    u8 low_vel;
    u8 high_vel;
    s8 fine_tune;
    s8 coarse_tune;
    s8 filter;
    s8 pan;
    loop_mode_t loop_mode;
    output_t output;
    s8 level;
    bool keytrck;
    s16 vel_to_start;
    u8 data[size - 46];
};

struct kgrp_chunk: RIFFChunkBase
{
    //u8 data[size];
    kloc_chunk kloc;
    env_chunk env[3];
    filt_chunk filt;
    zone_chunk zones[4];
};

struct APRG: RIFFChunkBase
{
    char type[4];
    prg_chunk prg;
    out_chunk outch;
    tune_chunk tune;
    lfo_chunk lfos[2];
    mods_chunk mods;
    kgrp_chunk kgrp[prg.keygrp_cnt];
};

APRG aprg_at_0x00 @ 0x00;