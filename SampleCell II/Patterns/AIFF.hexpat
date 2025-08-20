#pragma endian big

#include <std/mem.pat>

bool is_AIFF_C;

struct pstring_t
{
    u8 length;
    char text[length];
    
    if(!(length % 2))
        padding[1]; //pstrings are padded to make total size even.
};

enum comp_type_e: u32
{
    NONE = 0x4E4F4E45,
    sowt = 0x736F7774, //LE PCM, uncompressed
    FL32 = 0x464C3332, //IEEE
    fl32 = 0x666C3332, //IEEE
    fl64 = 0x666C3634, //IEEE
    ACE2 = 0x41434532,
    ACE8 = 0x41434538,
    MAC3 = 0x4D414333,
    MAC6 = 0x4D414336,
    ALAW = 0x414C4157,
    alaw = 0x616C6177,
    ULAW = 0x554C4157,
    ulaw = 0x756C6177
};

struct COMM_chunk_t //Common chunk. Required, max 1.
{
    s16 channel_cnt; //spec says it's signed
    u32 frame_cnt;
    s16 sample_size; //Spec says it's signed. Bits, not bytes.
    u8 sample_rate[10]; //IEEE 80-bit float
    
    if(is_AIFF_C)
    {
        comp_type_e comp_type;
        pstring_t comp_name;
    }
};

struct SSND_chunk_t
{
    u32 offset; //Start offset. In bytes.
    u32 block_size;
    u8 audio[parent.size - 8]; //Linear, signed (2's complement).
};

struct MARK_entry_t
{
    s16 ID; //spec says it's signed
    u32 mark;
    pstring_t name;
};

struct MARK_chunk_t //Optional. Max 1 per file.
{
    u16 mark_cnt;
    MARK_entry_t marks[mark_cnt];
};

enum loop_mode_e: u16
{
    none,
    fwd,
    alt
};

struct loop_t
{
    loop_mode_e mode;
    s16 start_marker_ID;
    s16 end_marker_ID;
};

struct INST_chunk_t //Optional. Max 1 per file.
{
    s8 root_note; //spec says it's signed
    s8 fine_tune;
    s8 low_note;
    s8 high_note;
    s8 low_velo;
    s8 high_velo;
    s16 gain; //in dB
    loop_t sus_loop;
    loop_t rel_loop;
};

struct comment_t
{
    u32 timestamp; //Epoch is 1-1-1904
    s16 marker_ID;
    u16 length;
    char text[length];
    
    if(length % 2)
        padding[1];
};

struct COMT_chunk_t //Optional. Max 1 per file.
{
    u16 count;
    comment_t comments[count];
};

struct bext_chunk_t //From the BWF spec. SampleCell Editor adds these.
{
    char desc[256];
    char originator[32];
    char originator_ref[32];
    char origination_date[10]; //yyyy:mm:dd
    char origination_time[8]; //hh:mm:ss
    u32 time_ref_low;
    u32 time_ref_high;
    u16 version;
    u8 UMID[64]; //SMPTE UMID data
    u16 loudness_val; //in LUFS
    u16 loudness_range; //in LU
    u16 max_true_peak_level; //in dBTP
    u16 max_momentary_loudness; //in LUFS
    u16 max_short_term_loudness; //in LUFS
    u8 reserved[180];
    char coding_history[];
};

struct IFF_chunk_t
{
    char four_cc[4];
    u32 size;
    
    match (four_cc)
    {
        ("COMM"): COMM_chunk_t comm_data;
        ("SSND"): SSND_chunk_t ssnd_data;
        ("MARK"): MARK_chunk_t mark_data;
        ("INST"): INST_chunk_t inst_data;
        ("MIDI"): u8 data[size]; //SysEx
        ("AESD"): u8 data[size]; //AES chan. status
        ("COMT"): COMT_chunk_t comt_data;
        ("bext"): bext_chunk_t bext_data;
        ("FVER"): u8 data[size]; //AIFF-C only, required. Should be 0xA2805140.
        (_): u8 data[size];
    }
};

struct IFF_file_t
{
    char magic[4]; //FORM
    u32 size;
    char four_cc[4]; //AIFF
};

IFF_file_t file @ 0;

is_AIFF_C = file.four_cc == "AIFC";

IFF_chunk_t chunk[while (!std::mem::eof())] @ $;
