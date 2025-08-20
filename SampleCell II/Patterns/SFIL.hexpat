#pragma endian big

/*SoundDesigner I files*/

struct pstring_t
{
    u8 len;
    char text[len];
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
    u8 unknown[180];
    u32 audio_size; //@ 0xB8
    u8 unknown2[66];
    pstring_t filename; //@ 0xFE
    padding[64 - filename.len];
    u8 unknown3[433];
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
