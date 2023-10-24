#pragma endian little

struct Header
{
    padding[4];
    char machine_name[10];
    padding[2];
    char sys_version[80];
};

struct TOC
{
    char name[16];
    u32 unknown;
    u16 volume_cnt;
    u16 performance_cnt;
    u16 patch_cnt;
    u16 partial_cnt;
    u16 sample_cnt;
    padding[2];
};

enum ElementType: u8
{
    volume = 0x40,
    performance,
    patch,
    partial,
    sample
};

struct ListEntryBase
{
    char name[16];
    ElementType type;
};

struct GenericListEntry: ListEntryBase
{
    u8 data[15];
};

struct PatchListEntry: ListEntryBase
{
    u8 unknown[13];
    u16 segment_cnt;
};

struct PartialListEntry: ListEntryBase
{
    u8 unknown[13];
    u16 segment_cnt;
};

struct SampleListEntry: ListEntryBase
{
    u8 unknown[11];
    u16 start_segment;
    u16 segment_cnt;
};

struct Volume
{
    char name[16];
    padding[16];
    u16 performance_indices[112];
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
    u8 data[96];
    u16 patch_indices[128];
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
    u16 partial_indices[128];
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

Header header @ 0x0;
TOC toc @ 0x100;
GenericListEntry volume_list[toc.volume_cnt] @ 0xA0800;
GenericListEntry performance_list[toc.performance_cnt] @ 0xA1800;
PatchListEntry patch_list[toc.patch_cnt] @ 0xA5800;
PartialListEntry partial_list[toc.partial_cnt] @ 0xAD800;
SampleListEntry sample_list[toc.sample_cnt] @ 0xCD800;
Volume volumes[toc.volume_cnt] @ 0x10D800;
Performance performances[toc.performance_cnt] @ 0x115800;
Patch patches[toc.patch_cnt] @ 0x155800;
Partial partials[toc.partial_cnt] @ 0x1D5800;
SampleParameters sample_parameters[toc.sample_cnt] @ 0x255800;
u8 start_of_sample_data @ 0x2B5800;
