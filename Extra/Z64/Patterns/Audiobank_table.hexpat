#pragma endian big

struct Bank_entry_t
{
	u32 start_addr;
	u32 size;
	u8 unknown[4];
	u8 inst_cnt;
	u8 drum_cnt;
	u16 sfx_cnt;
};

u8 bank_count @ 0x1;
Bank_entry_t audiobank_TOC[bank_count] @ 0x10;
