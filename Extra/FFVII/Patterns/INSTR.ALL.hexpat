#pragma endian little

struct INSTR_ALL
{
    u32 addr;
    u32 size;
    padding[8];
    u8 data[size]; //ADPCM audio data
};

INSTR_ALL akao_sample_at_0x00 @ 0x00;