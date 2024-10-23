#pragma endian big

#define SOUNDFONT_0_SIZE 0x81C0
#define SOUNDFONT_1_SIZE 0x36D0
#define SOUNDFONT_2_SIZE 0xCE0
#define SOUNDFONT_3_SIZE 0x15D0

#define SOUNDFONT_0_INST_CNT 122
#define SOUNDFONT_0_DRUM_CNT 16
#define SOUNDFONT_0_SFX_CNT 452

#define SOUNDFONT_1_INST_CNT 126
#define SOUNDFONT_1_DRUM_CNT 4
#define SOUNDFONT_1_SFX_CNT 88

#define SOUNDFONT_2_INST_CNT 22
#define SOUNDFONT_2_DRUM_CNT 0
#define SOUNDFONT_2_SFX_CNT 0

#define SOUNDFONT_3_INST_CNT 18
#define SOUNDFONT_3_DRUM_CNT 64
#define SOUNDFONT_3_SFX_CNT 0

#define SOUNDFONT_4_INST_CNT 14
#define SOUNDFONT_4_DRUM_CNT 64
#define SOUNDFONT_4_SFX_CNT 0

u8 inst_cnt;
u8 drum_cnt;
u16 sfx_cnt;
u32 offset;

struct Loop_t
{
    u32 start;
    u32 loopEnd; // numSamples position into the sample where the loop ends
    u32 count; // The number of times the loop is played before the sound completes. Setting count to -1 indicates that the loop should play indefinitely.
    u32 sampleEnd; // total number of s16-samples in the sample audio clip
    
    if(count != 0)
        s16 predictorState[16]; // only exists if count != 0. 8-byte aligned
};

struct Book_t
{
    s32 order;
    s32 num_predictors;
    s16 codeBook[order * num_predictors * 8]; // a table of prediction coefficients that the coder selects from to optimize sound quality.
};

enum Sample_codec_t: u8
{
    ADPCM4,  //4b per sample
    S8, // 16 2-byte samples (32 bytes) compressed into 8-bit samples (16 bytes)
    S16_INMEMORY,
    ADPCM2,  //2b per sample
    REVERB,
    S16,
    UNK,
    UNK2 //treated as uncompressed
};

enum Sample_medium_t: u8
{
    RAM,
    UNK,
    CART,
    DISK_DRIVE,
    RAM_UNLOADED = 5
};

bitfield Sample_format_t
{
    unknown: 1;
    Sample_codec_t codec: 3;
    Sample_medium_t medium: 2;
    unknown2: 1;
    is_relocated: 1;
};

struct Sample_t
{
    Sample_format_t format;
    u24 size; //compressed data size?
    u32 sample_addr; //Offset from the start of the sample bank or absolute address to either rom or ram
    u32 loop_addr; //Offset from the start of the sound font / pointer to ram
    u32 book_addr; //Offset from the start of the sound font / pointer to ram
    
    Loop_t loop @ loop_addr + offset;
    Book_t book @ book_addr + offset;
};

struct Envelope_point_t
{
    s16 delay;
    s16 arg;
};

struct Tuned_sample_t
{
    u32 sample_addr;
    float tuning;
    
    if(sample_addr != 0)
        Sample_t sample @ sample_addr + offset;
};

struct Instrument_t
{
    u8 is_relocated;
    u8 normal_range_low;
    u8 normal_range_high;
    u8 ADSR_decay_idx;
    u32 env_point_addr;
    Tuned_sample_t low_pitch_sample;
    Tuned_sample_t normal_pitch_sample;
    Tuned_sample_t high_pitch_sample;
    
    Envelope_point_t envelope_point[4] @ env_point_addr + offset;
};

struct Drum_t
{
    u8 ADSR_decay_idx;
    u8 pan;
    u8 is_relocated;
    padding[1];
    Tuned_sample_t sample;
    u32 env_point_addr;
    
    Envelope_point_t envelope_point[4] @ env_point_addr + offset;
};

struct SFX_t
{
    //Effects are just samples
    Tuned_sample_t sample;
};

struct Inst_ptr_t
{
    u32 inst_ptr;
    
    if(inst_ptr)
        Instrument_t inst @ inst_ptr + offset;
};

struct Drum_ptr_t
{
    u32 drum_ptr;
    
    if(drum_ptr)
        Drum_t drum @ drum_ptr + offset;
};

struct SFX_ptr_t
{
    u32 sfx_ptr;
    
    if(sfx_ptr)
        SFX_t sfx[sfx_cnt] @ sfx_ptr + offset;
};

struct Bank_t
{
    u32 drum_offset_list_offset;
    u32 SFX_offset;
    Inst_ptr_t inst_offsets[inst_cnt]; //val 0 = empty
    
    if(drum_offset_list_offset)
        Drum_ptr_t drum_offsets[drum_cnt] @ drum_offset_list_offset + offset;
    
    if(SFX_offset)
        SFX_t sfx_entries[sfx_cnt] @ SFX_offset + offset;
};

inst_cnt = SOUNDFONT_0_INST_CNT;
drum_cnt = SOUNDFONT_0_DRUM_CNT;
sfx_cnt = SOUNDFONT_0_SFX_CNT;
offset = 0;

Bank_t bank0 @ offset;

inst_cnt = SOUNDFONT_1_INST_CNT;
drum_cnt = SOUNDFONT_1_DRUM_CNT;
sfx_cnt = SOUNDFONT_1_SFX_CNT;
offset = SOUNDFONT_0_SIZE;

Bank_t bank1 @ offset;

inst_cnt = SOUNDFONT_2_INST_CNT;
drum_cnt = SOUNDFONT_2_DRUM_CNT;
sfx_cnt = SOUNDFONT_2_SFX_CNT;
offset += SOUNDFONT_1_SIZE;

Bank_t bank2 @ offset;

inst_cnt = SOUNDFONT_3_INST_CNT;
drum_cnt = SOUNDFONT_3_DRUM_CNT;
sfx_cnt = SOUNDFONT_3_SFX_CNT;
offset += SOUNDFONT_2_SIZE;

Bank_t bank3 @ offset;

inst_cnt = SOUNDFONT_4_INST_CNT;
drum_cnt = SOUNDFONT_4_DRUM_CNT;
sfx_cnt = SOUNDFONT_4_SFX_CNT;
offset += SOUNDFONT_3_SIZE;

Bank_t bank4 @ offset;