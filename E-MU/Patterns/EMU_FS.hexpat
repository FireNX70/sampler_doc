#pragma endian little

#define BLOCK_SIZE 512
#define MIN_CLUSTER_SIZE_SHIFT 15

u32 start_offset = 0x00;

struct Header
{
    char magic[4];
    u32 block_cnt;
    u32 dir_list_block_addr;
    u32 dir_list_block_cnt;
    u32 file_list_block_addr;
    u32 file_list_block_cnt;
    u32 FAT_block_addr;
    u32 FAT_block_cnt;
    u32 start_data_block;
    u32 cluster_cnt;
    u8 cluster_size_shift; //actual value is this + 15
    u8 unknown;
    u32 block_cnt_copy; //maybe?
    u8 unknown2[10];
    padding[454];
    u16 checksum;
};

enum FileType: u8
{
    DEL, //free
    //PADDING = 0x42,
    SYS = 0x80,
    STD,
    UPD = 0x83
};

struct File
{
    char name[16];
    u8 unknown; //seems unused
    u8 bank_num; //must be unique
    u16 start_cluster;
    u16 cluster_cnt;
    u16 block_cnt;
    u16 byte_cnt;
    FileType type;
    u8 properties[5];
};

enum Dir_type: u8
{
    FREE,
    //PADDING = 0x23,
    LAST = 0x40,
    //PADDING = 0x6C,
    NORMAL = 0x80
};

struct Directory
{
    char name[16];
    u8 unknown;
    Dir_type dir_type;
    u16 block_list[7];
};

Header header @ start_offset;
u16 next_file_list_block @ start_offset + 0x200;
u16 FAT[header.FAT_block_cnt * BLOCK_SIZE / 2] @ start_offset + header.FAT_block_addr * BLOCK_SIZE;
Directory dirs[header.dir_list_block_cnt * BLOCK_SIZE / sizeof(Directory)] @ start_offset + header.dir_list_block_addr * BLOCK_SIZE;
File files[header.file_list_block_cnt * BLOCK_SIZE / sizeof(File)] @ start_offset + header.file_list_block_addr * BLOCK_SIZE;
u8 data_start @ header.start_data_block * BLOCK_SIZE;
