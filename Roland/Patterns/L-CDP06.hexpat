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

struct ListEntry
{
    char name[16];
    u8 data[16];
};

struct Volume
{
    char name[16];
    padding[16];
    u8 data[6];
    padding[218];
};

struct Performance
{
    char name[16];
    u8 data[496];
};

struct Patch
{
    char name[16];
    u8 data[496];
};

struct Partial
{
    char name[16];
    u8 data[112];
};

struct SampleParameters
{
    char name[16];
    u8 data[32];
};

Header header @ 0x0;
TOC toc @ 0x100;
ListEntry volume_list[toc.volume_cnt] @ 0xA0800;
ListEntry performance_list[toc.performance_cnt] @ 0xA1800;
ListEntry patch_list[toc.performance_cnt] @ 0xA5800;
ListEntry partial_list[toc.partial_cnt] @ 0xAD800;
ListEntry sample_list[toc.sample_cnt] @ 0xCD800;
Volume volumes[toc.volume_cnt] @ 0x10D800;
Performance performances[toc.performance_cnt] @ 0x115800;
Patch patches[toc.performance_cnt] @ 0x155800;
Partial partials[toc.partial_cnt] @ 0x1D5800;
SampleParameters sample_parameters[toc.sample_cnt] @ 0x255800;
u8 start_of_sample_data @ 0x2B5800;