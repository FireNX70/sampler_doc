#pragma endian little

enum loop_mode_t: u8
{
    no_looping,
    oneshot,
    loop_in_rel,
    loop_until_rel
};

struct S5000_manufacturer_data
{
    u8 unknown[2];
    u8 root_note;
    s8 coarse_tune;
    s8 fine_tune;
    u8 unknown2;
    loop_mode_t loop_mode;
    u8 unknown3[3];
    u32 start_point;
    u32 end_point;
};

S5000_manufacturer_data s5000_manufacturer_data_at_0x76 @ 0x76;