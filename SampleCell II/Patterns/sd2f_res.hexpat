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

enum loop_type_e: u16
{
    fwd = 117,
    alt
};

struct loop_t
{
    u32 start;
    u32 end;
    u16 idx;
    loop_type_e type;
    u16 channel;
};

struct sdLL_t
{
    u32 size;
    u16 version;
    u16 hscale;
    u16 vscale;
    u16 loop_cnt;
    loop_t loops[loop_cnt];
};

enum marker_type_e: u16
{
    num = 1,
    text
};

struct marker_t
{
    marker_type_e type;
    marker_type_e type_dupe;
    u32 pos;
    u32 text;
    u16 cursor_ID;
    u16 marker_ID;
    u32 txt_len;
    char actual_text[txt_len];
};

struct sdML_t
{
    u32 size;
    u16 version;
    u32 off;
    u16 cnt;
    marker_t markers[cnt];
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
    u32 data_off; //from header's res_data_addr
    u8 unknown[4];
    
    name_t name @ header.second_header_addr + second_section_meta.name_sec_off + name_off;
    
    match(parent.name)
    {
        ("STR "): STR_t data @ header.res_data_addr + data_off;
        ("sdLL"): sdLL_t data @ header.res_data_addr + data_off;
        ("sdML"): sdML_t data @ header.res_data_addr + data_off;
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

//actual value is this +1
u16 type_cnt @ header.second_header_addr + second_section_meta.type_sec_off; 
type_t types[type_cnt + 1] @ header.second_header_addr + second_section_meta.type_sec_off + 2;