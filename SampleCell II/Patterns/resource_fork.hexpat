#pragma endian big

struct header_t
{
    u32 res_data_addr;
    u32 second_header_addr;
    u32 res_data_size;
    u32 second_section_size; //incl. second header
};

struct name_t
{
    u8 size;
    char name[size];
};

struct data_t
{
    u32 size;
    u8 data[size];
};

struct STR_t
{
    u32 size;
    u8 len; //should be size - 1
    char string[len];
};

struct second_section_meta_t
{
    u16 type_sec_off;
    u16 name_sec_off;
};

struct res_meta_t
{
    u16 ID;
    u16 name_off;
    u8 unknown;
    u24 data_off; //from header's res_data_addr
    u8 unknown2[4];
    
    if(name_off != 0xFFFF)
        name_t name @ header.second_header_addr + second_section_meta.name_sec_off + name_off;
    
    match(parent.name)
    {
        ("STR "): STR_t data @ header.res_data_addr + data_off;
        (_): data_t data @ header.res_data_addr + data_off;
    }   
};

struct type_t
{
    char name[4];
    u16 cnt; //actual value is this +1
    u16 meta_off; //from after name_section_off
    
    res_meta_t resources[cnt + 1] @ header.second_header_addr + second_section_meta.type_sec_off + meta_off;
};

header_t header @ 0;
header_t second_header @ header.second_header_addr;
second_section_meta_t second_section_meta  @ header.second_header_addr + sizeof(header_t) + 8;

//Actual value is this +1. 0xFFFF if none.
u16 type_cnt @ header.second_header_addr + second_section_meta.type_sec_off; 
type_t types[type_cnt + 1] @ header.second_header_addr + second_section_meta.type_sec_off + 2;