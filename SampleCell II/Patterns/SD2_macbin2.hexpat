#pragma endian big

struct header_t
{
    u8 version; //should be 0
    u8 fname_len; //1 - 63
    char fname[fname_len];
    padding [63 - fname_len];
    char ftype[4];
    char fcreat[4];
    u8 flags;
    padding [1]; //should be 0
    u16 vpos;
    u16 hpos;
    u16 win_ID;
    bool protected;
    padding [1]; //should be 0
    u32 data_size;
    u32 res_size;
    u32 ctime;
    u32 mtime;
    u16 comment_length;
    u8 flags_upper;
    char magic[4]; //mBIN
    u8 unknown[10];
    u32 unpack_size; //0 if single file
    u16 sec_header_size;
    u8 macbinII_ver; //min 129
    u8 macbinII_min_ver;
    u16 CRC;
    padding [2];
};

u64 res_frk_base;
u64 res_meta_base;
u64 res_data_base;
u64 res_name_base;

struct res_frk_header_t
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
    
    
    if(name_off < 0xFFFF)
        name_t name @ res_name_base + name_off;
    
    match(parent.name)
    {
        ("STR "): STR_t data @ res_data_base + data_off;
        ("sdLL"): sdLL_t data @ res_data_base + data_off;
        ("sdML"): sdML_t data @ res_data_base + data_off;
        (_): data_t data @ res_data_base + data_off;
    }   
};

struct type_t
{
    char name[4];
    u16 cnt; //actual value is this +1
    u16 meta_off; //from after name_section_off
    
    res_meta_t resources[cnt + 1] @ addressof(parent.type_cnt) + meta_off;
};

struct res_frk_t
{
    res_frk_header_t header;
    
    res_frk_base = addressof(header);
    res_meta_base = res_frk_base + header.second_header_addr;
    res_data_base = res_frk_base + header.res_data_addr;
    
    res_frk_header_t header_copy @ res_meta_base;
    second_section_meta_t second_section_meta @ res_meta_base + 0x18;
    
    res_name_base = res_meta_base + second_section_meta.name_sec_off;
    
    u16 type_cnt @ res_meta_base + second_section_meta.type_sec_off;
    type_t types[type_cnt + 1] @ addressof(type_cnt) + 2;
};

u8 size_rem;

struct file_t
{
    header_t header;
    
    if(header.sec_header_size)
    {
        u8 sec_header[header.sec_header_size];
        
        size_rem = header.sec_header_size % 128;
    
        if(size_rem)
            padding [128 - size_rem];
    }
    
    u8 data[header.data_size];
    
    size_rem = header.data_size % 128;
    
    if(size_rem)
        padding [128 - size_rem];
        
    res_frk_t res_frk;
    
    size_rem = header.res_size % 128;
    
    if(size_rem)
        padding [128 - size_rem];
};

file_t file @ 0;