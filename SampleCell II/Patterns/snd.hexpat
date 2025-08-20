#pragma endian big

bool streamed_audio = false;

enum opcode_e: u16
{
    buffer = 0x8051
};

enum audio_header_encoding_e: u8
{
    std,
    cmp = 0xFE,
    ext = 0xFF
};

enum comp_e: u8
{
    none,
    MACE3 = 3,
    MACE6
};

enum synth_ID_e: u16
{
    square = 1,
    wavetable = 3,
    sample = 5,
    MACE3 = 11,
    MACE6 = 13
};

struct format1_audio_header_t
{
    u32 offset;
    u32 size; //in bytes. Chan count if extended or compressed.
    u32 sample_rate; //Fixed-point.
    u32 loop_start;
    u32 loop_end;
    audio_header_encoding_e encoding;
    u8 root_note;
    
    if(encoding == audio_header_encoding_e::ext)
    {
        u32 frame_cnt;
        u8 AIFF_sample_rate[10];
        u32 mark_chunk_ptr;
        u32 inst_chunk_ptr;
        u32 aes_chunk_ptr;
        u16 sample_size; //in bits
        u16 reserved;
        u32 reserved2[3];
    }
    else if(encoding == audio_header_encoding_e::cmp)
    {
        u32 frame_cnt;
        u8 AIFF_sample_rate[10];
        u32 mark_chunk_ptr;
        u32 reserved[2];
        u32 state_var_ptr;
        u32 leftover_ptr;
        u8 comp_ID_hi; //unused
        comp_e comp_ID_lo;
        u16 packet_size;
        u16 synth_ID;
        u16 sample_size;
    }
};

struct cmd_t
{
    opcode_e opcode;
    u16 param1;
    u32 param2;
    
    if(u16(opcode) & 0x8000)
    {
        match(opcode)
        {
            (opcode_e::buffer):
                format1_audio_header_t audio_header @ param2;
            
            (_): u8 data @ param2;
        }
    }
};

enum chans_e: u8
{
    left = 2, //left-only, for sample synth
    right, //right-only, for sample synth
    chan0, //for wavetable. 4 may also mean no interp.
    chan1, //for wavetable.
    chan2, //for wavetable.
    chan3, //for wavetable.
    no_drop,
    mono = 0x80, //for sample synth
    stereo = 0xC0 //for sample synth
};

bitfield stream_synth_params_t //u32
{
    unknown: 16;//& 0xFFFF0000
    comp_e comp: 8;//& 0xFF00
    chans_e chans: 8; //& 0xFF
};

struct format1_header_t
{
    u16 synth_cnt;
    synth_ID_e first_synth_ID;
    
    streamed_audio = first_synth_ID == synth_ID_e::sample;
    
    if(streamed_audio) stream_synth_params_t synth_init;
    else u32 synth_init;
    u16 cmd_cnt;
    cmd_t commands[cmd_cnt];
};

struct format2_header_t
{
    u16 ref_cnt;
    u16 cmd_cnt;
    cmd_t commands[cmd_cnt];
};

struct header_t
{
    u16 format;
    
    match(format)
    {
        (1): format1_header_t header;
        (2): format2_header_t header;
    }
};

header_t header @ 0;