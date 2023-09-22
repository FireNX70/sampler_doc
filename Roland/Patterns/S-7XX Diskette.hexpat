#pragma endian little

struct Header
{
    padding[4];
    char machine_name[10];
    padding[2];
    char sys_version[80];
    padding[160];
};

struct ListEntry
{
    char name[16];
};

struct Performance
{
    char name[16];
    u8 part_patch_map[16];
    u8 unknown[64];
    u8 part_low_note[16];
    u8 part_low_fade[16];
    u8 part_high_note[16];
    u8 part_high_fade[16];
    u8 unknown2[96];
};

struct Patch
{
    char name[16];
    u8 patch_num;
    u8 unknown[15];
    u8 partial_map[88];
    u8 unknown2[136];
};

struct PartialSampleEntry
{
    u16 sample_index;
    u8 unknown[14];
};

struct Partial
{
    char name[16];
    PartialSampleEntry sample_entries[4];
    u8 other_data[48];
};

struct SampleParameters
{
    char name[16];
    u8 data[32];
};

struct SampleParameterSection
{
    SampleParameters sample_parameters[10];
    padding[32];
};

Header header @ 0x00;

u8 unknown[6] @ 0x100;
u16 volume_cnt @ 0x106;
u16 perfrm_cnt @ 0x108;
u16 patch_cnt @ 0x10A;
u16 partial_cnt @ 0x10C;
u16 sample_cnt @ 0x10E;

ListEntry volume_name @ 0x180;
ListEntry performance_list[perfrm_cnt] @ 0x1200;
ListEntry patch_list[patch_cnt] @ 0x1600;
ListEntry partial_list[partial_cnt] @ 0x1E00;
ListEntry sample_list[sample_cnt] @ 0x2E00;

Performance performances[perfrm_cnt] @ 0x4E00;
Patch patches[patch_cnt] @ 0x8E00;
Partial partials[partial_cnt] @ 0x10E00;
SampleParameterSection samples[sample_cnt / 10 + ((sample_cnt % 10) > 0)] @ 0x18E00;
u16 audio[672768] @ 0x1F800;