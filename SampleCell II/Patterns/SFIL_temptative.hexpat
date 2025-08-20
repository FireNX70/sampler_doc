#pragma endian big

/*SoundDesigner I files*/

struct pstring_t
{
    u8 len;
    char text[len];
};

struct zoom_t
{
    s16 v;
    s32 h;
};

struct scale_t
{
    s32 v_factor;
    u8 v_scale_type;
    padding[1];
    pstring_t v_scale_name;
    padding[32 - v_scale_name.len];
    padding[1];
    s32 h_factor;
    u8 h_scale_type;
    padding[1];
    pstring_t h_scale_name;
    padding[32 - h_scale_name.len];
};

struct marker_t
{
    bool free;
    
    if(free) padding[39];
    else
    {
        padding[1];
        s32 pos;
        pstring_t name;
        padding[32 - name.len + 1];
    }
};

enum loop_type_e: u8
{
    fwd = 1,
    alt
};

struct header_t
{
    s16 header_size; //Should be 1336
    s16 version; //Seen 0x15
    u8 unknown[52];
    zoom_t zoom;
    scale_t scale;
    u8 unknown1[43];
    u32 audio_size; //@ 0xB8
    u8 unknown2[66];
    pstring_t filename; //@ 0xFE
    padding[64 - filename.len];
    u8 unknown3[29];
    marker_t markers[10];
    s32 marker_off;
    s32 loop1_start;
    s32 loop1_end;
    u8 unknown4[260];
    s32 sample_rate;
    s32 sample_period; //in usec
    s16 sample_size; //in bits
    pstring_t code_type;
    padding[32 - code_type.len];
    u8 unknown5[261];
    s32 loop2_start;
    s32 loop2_end;
    loop_type_e loop1_type;
    loop_type_e loop2_type;
    s16 user4; //Marked as "DO NOT USE"
};

header_t header @ 0;