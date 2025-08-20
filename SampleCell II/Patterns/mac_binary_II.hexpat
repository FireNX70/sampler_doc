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
    char magic[4]; //mBIN. Added in MBIII?
    u8 unknown[10];
    u32 unpack_size; //0 if single file
    u16 sec_header_size;
    u8 macbinII_ver; //min 129
    u8 macbinII_min_ver;
    u16 CRC;
    padding [2];
};

u8 size_rem;

struct file_t
{
    header_t header;
    
    u8 sec_header[header.sec_header_size];
        
    size_rem = header.sec_header_size % 128;
    
    if(size_rem)
        padding [128 - size_rem];
    
    u8 data[header.data_size];
    
    size_rem = header.data_size % 128;
    
    if(size_rem)
        padding [128 - size_rem];
        
    u8 res[header.res_size];
    
    size_rem = header.res_size % 128;
    
    if(size_rem)
        padding [128 - size_rem];
        
    u8 comment[header.comment_length];
    
    size_rem = header.comment_length % 128;
    
    if(size_rem)
        padding [128 - size_rem];
};

file_t file @ 0;