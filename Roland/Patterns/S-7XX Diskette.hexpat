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
    u8 unknown2[104];
    u8 unknown3[2]; //related to pitch_bend?
    u8 unknown4[6];
    u8 aftertouch;
    u8 unknown5[3];
    u8 modulation;
    u8 unknown6[19];
};

struct PartialSampleEntry
{
    u16 sample_index;
    u8 key_shift;
    u8 volume;
    s8 pan;
    s8 coarse_tune;
    u8 fine_tune;
    u8 vel_low;
    u8 unknown3;
    u8 vel_high;
    u8 unknown4[6];
};

struct Partial
{
    char name[16];
    PartialSampleEntry sample_entries[4];
    u8 filter_env_vel;
    u8 unknown;
    u8 other_data[46];
};

enum Looping: u8
{
    Fwd,
    Off = 2,
    Other = 4
};

enum SampleRate: u8
{
    FourtyEight_KHz,
    FourtyFour_Point_One_KHz,
    TwentyFour_KHz,
    Unknown,
    TwentyTwo_Point_OhFive_KHz
};

bitfield Format
{
    SampleRate sample_rate: 3;
    padding: 1;
    unknown: 1;
    padding: 3;
};

struct SampleParameters
{
    char name[16];
    u8 unknown;
    u24 start_offset;
    u8 unknown2;
    u24 loop_start;
    u8 unknown3;
    u24 loop_end;
    u8 unknown4;
    u24 length_minus_four;
    u8 unknown5;
    u24 length;
    Looping looping;
    u8 unknown6[3];
    u8 start_segment;
    u8 disk_index;
    u8 segment_cnt;
    u8 unknown8;
    Format format;
    u8 root_note;
    u8 unknown9[2];
};

struct SampleParameterSection
{
    SampleParameters sample_parameters[10];
    padding[32];
};

Header header @ 0x00;

u8 disk_index @ 0x100;
u8 multi_disk_cnt @ 0x101;
u8 unknown[4] @ 0x102;
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
