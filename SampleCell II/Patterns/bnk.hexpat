#include <std/string>
#include <std/math>

#include <std/io>

#pragma endian big

/*Yes, the Windows bnk data is big-endian.*/

struct IFF_chunk_t
{
	char four_cc[4];
	u32 size;
};

struct FVER_chunk_t: IFF_chunk_t
{
	//four_cc = FVER
	//size should be 4
	char data[size]; //Should be "Monk"
};

struct ANNO_chunk_t: IFF_chunk_t
{
	//four_cc = ANNO
	//size is variable
	char text[size];
};

u32 cur_base;

struct FILP_entry_t
{
	cur_base = $;
	u8 vol_name_len;
	char vol_name[vol_name_len];
	padding[31 - vol_name_len]; //volume name padding
	u8 file_name_len;
	char file_name[file_name_len];
	padding[31 - file_name_len]; //file name padding
	char ftype[4]; //file four_cc

	if(parent.entry_size > 68)
	{
		u16 some_cnt; //maybe?
		char path[]; //null-terminated string
		padding[parent.entry_size - ($ - cur_base)]; //path padding
	}
};

struct FILP_chunk_t: IFF_chunk_t
{
	//four_cc = FILP
	//size should be 8 or more
	u32 count;
	u32 entry_size;
	FILP_entry_t entries[count];
};

enum output_e: u8
{
	one_two,
	three_four,
	five_six,
	seven_eight
};

enum solo_mute_e: u8
{
	none,
	mute,
	mute_induced, //forced by solo
	solo
};

struct InsP_entry_t
{
	cur_base = $;
	u8 unknown;
	u8 gain; //Default and max is 99.
	s16 pan; //+- 99
	u8 unknown3;
	output_e output;
	u8 unknown4;
	solo_mute_e solo_mute;
	u8 unknown5;
	u8 MIDI_channel;
	u8 unknown6;
	u8 low_note;
	u8 unknown7;
	u8 high_note;
	u8 leftover[parent.entry_size - ($ - cur_base)];
};

struct InsP_chunk_t: IFF_chunk_t
{
	//four_cc = InsP
	//size should be 8 or more
	u32 count;
	u32 entry_size;
	InsP_entry_t entries[count];
};

struct PRNT_chunk_t: IFF_chunk_t
{
	//four_cc = PRNT
	//size is variable?
	u8 data[size];
};

struct WinI_chunk_t: IFF_chunk_t
{
	//four_cc = WinI
	//size is variable?
	u8 data[size];
};

struct IFF_root_t: IFF_chunk_t
{
	char magic[4]; //MixD for bank
	FVER_chunk_t fver;
	ANNO_chunk_t anno;
	FILP_chunk_t filp;
	InsP_chunk_t insp;
	PRNT_chunk_t prnt;
	WinI_chunk_t wini;
};

IFF_root_t root_chunk @ 0;
