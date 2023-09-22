#pragma endian little

#define BLOCK_SIZE 512
#define MIN_CLUSTER_SIZE_SHIFT 15

struct Header
{
    char magic[4];
    u32 block_cnt;
    u32 start_root_block;
    u32 root_block_cnt;
    u32 start_dir_content_block;
    u32 dir_content_block_cnt;
    u32 start_cluster_list_block;
    u32 cluster_list_block_cnt;
    u32 start_data_block;
    u32 cluster_cnt;
    u8 cluster_size_shift;
    u8 unknown;
    u32 block_cnt_copy; //maybe?
    u8 unknown2[10];
};

enum FileType: u8
{
    DEL,
    SYS = 0x80,
    STD,
    UPD = 0x83
};

struct File
{
    char name[16];
    u8 unknown;
    u8 ID;
    u16 start_cluster;
    u16 cluster_cnt;
    u16 block_cnt;
    u16 byte_cnt;
    FileType type;
    u8 properties[5];
};

struct Directory
{
    char name[16];
    u8 unknown;
    u8 ID;
    u16 block_list[7];
};

Header header @ 0x00;
u16 cluster_list[header.cluster_list_block_cnt * BLOCK_SIZE / 2] @ header.start_cluster_list_block * BLOCK_SIZE;
Directory dirs[header.root_block_cnt * BLOCK_SIZE / sizeof(Directory)] @ header.start_root_block * BLOCK_SIZE;
File files[header.dir_content_block_cnt * BLOCK_SIZE / sizeof(File)] @ header.start_dir_content_block * BLOCK_SIZE;