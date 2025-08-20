#pragma endian big

/*Yes, the Windows data is big-endian.*/

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
u32 entry_base;

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

struct KeyS_entry_t
{
	entry_base = $;
	u8 unknown[3];
	u8 ID; //Starts at 0. Stereo samples only increment this once.
	u8 unknown2[5];
	u8 channel; //1 left, 2 right?
	u8 unknown3[4];
	u32 sample_cnt;
	u8 name_len;
	char name[name_len];
	padding[31 - name_len]; //name padding
	u32 start_offset;
	u16 sample_fine_tune;
	u8 unknown4; //loop upper?
	bool loop;
	u16 loop_fine_tune;
	u8 unknown5; //rel_loop upper?
	bool rel_loop;
	u16 release_loop_fine_tune;
};

struct KeyS_chunk_t: IFF_chunk_t
{
	cur_base = $;
	u32 count;
	u32 entry_size;
	u32 total_sample_data_size;
	KeyS_entry_t entries[count];
};

struct vel_zone_t
{
	u32 keys_idx; //Mono. Also left?
	u32 keys_idx_2; //Stereo only. Right?
	u16 low_vel;
	u16 level;
	u8 unknown;
	bool direction; //for loop?
	u16 fine_start_off;
	u16 root_note;
};

struct keygroup_t
{
	u16 high_note;
	s16 keygrp_pan; //+-99
	u16 inner_cnt;
	vel_zone_t zones[inner_cnt];
};

struct KeyP_chunk_t: IFF_chunk_t
{
	u16 entry_cnt;
	u8 data[4];
	keygroup_t keygroups[entry_cnt];
};

struct GenP_chunk_t: IFF_chunk_t
{
	u8 data[2]; //I think this is the card number
	u16 MIDI_channel; //even though banks also keep it
	u16 low_note;
	u16 high_note;
	s16 octave_shift;
	s16 coarse_tune; //A.K.A. pitch semitone
	s16 fine_tune; //A.K.A. detune
	u8 unknown;
	bool equal_detune;
	u8 unknown2;
	bool key_track;
	u8 unknown3;
	bool mono;
	u16 sound_priority; //default 0 (low)
	u16 overlap_amount; //default 10
	u8 unknown4;
	bool velocity_xfade;
	u8 data4[12];
	s16 pan; //also redundant with banks
	u16 out1; //redundant with banks, but stored separately here
	u16 out2; //redundant with banks, but stored separately here
	u8 data5[2];
	u16 gain; //also also redundant
	u8 unknown5;
	u8 MIDI_ctrlr_A; //0 - 120
	u8 unknown6;
	u8 MIDI_ctrlr_B; //0 - 120
	s16 pitch_wheel;
	s16 velocity; //default 30
	u8 unknown7;
	bool disable_MIDI_vol_pan;
	u16 filter_freq; //0-255 mapped to 13-20135 (non-linear)
};

struct Inst_chunk_t: IFF_chunk_t
{
	u16 entry_cnt;
	u16 entry_size;
};

struct EnvP_entry_t
{
	u8 unknown;
	u8 atk_rate;
	u8 unknown2;
	u8 decay_rate;
	u8 unknown3;
	u8 sus_level;
	u8 unknown4;
	u8 sus_rate;
	u8 unknown5;
	u8 rel_rate;
	u8 unknown6;
	u8 gate_time;
	u8 unknown7;
	bool key_track;
	u16 amount;
};

struct EnvP_chunk_t: Inst_chunk_t
{
	EnvP_entry_t entries[entry_cnt];
};

enum LFO_mode_e: u16
{
	free_run,
	sync,
	trig,
	sync_and_trig
};

enum LFO_shape_e: u16
{
	sine,
	triangle,
	upsaw,
	dwnsaw,
	square,
	random,
	noise
};

struct LFOP_entry_t
{
	u8 unknown; //0
	u8 rate;
	u8 unknown2;
	u8 depth;
	LFO_mode_e mode;
	LFO_shape_e shape;
};

struct LFOP_chunk_t: Inst_chunk_t
{
	LFOP_entry_t entries[entry_cnt];
};

struct Ramp_chunk_t: IFF_chunk_t
{
	//Shared LFO data
	u8 data[4]; //entry_cnt and entry_size?
	u16 ramp_time; //another 0 - 99 range
};

enum ModP_src_e: u16
{
	key,
	vel,
	release_vel,
	pressure,
	mod_wheel,
	pitch_wheel,
	sus_pedal,
	env1,
	env2,
	env3,
	LFO1,
	LFO2,
	ramp_gen,
	tracking_gen1,
	rand_gen,
	MIDI_ctrlr_A,
	MIDI_ctrlr_B,
	tracking_gen2,
	none
};

struct TrkP_entry_t
{
	ModP_src_e source;
	u16 levels[9];
};

struct TrkP_chunk_t: Inst_chunk_t
{
	TrkP_entry_t entries[entry_cnt];
};

enum ModP_dst_e: u16
{
	pitch,
	pan,
	vol,
	sample_sel = 5,
	sample_start_off,
	env1_atk,
	env1_dec,
	env1_sus,
	env1_rel,
	env1_depth,
	env2_atk,
	env2_dec,
	env2_sus,
	env2_rel,
	env2_depth,
	env3_atk,
	env3_dec,
	env3_sus,
	env3_rel,
	env3_depth,
	LFO1_rate,
	LFO1_depth,
	LFO2_rate,
	LFO2_depth,
	filter,
	none
};

struct ModP_entry_t
{
	u8 unknown;
	bool gated;
	ModP_src_e src;
	ModP_dst_e dst;
	s16 depth; //+-99
};

struct ModP_chunk_t: Inst_chunk_t
{
	ModP_entry_t entries[entry_cnt];
};

struct IFF_root_t: IFF_chunk_t
{
	char magic[4]; //SCsd = single-sample mono
					//SCss = single-sample stereo
					//SCin = multi-sample mono
					//SCsi = multi-sample stereo
	FVER_chunk_t fver;
	ANNO_chunk_t anno;
	FILP_chunk_t filp;
	KeyS_chunk_t keys;
	KeyP_chunk_t keyp;
	GenP_chunk_t genp;

	if(magic == "SCin" || magic == "SCsi")
	{
		EnvP_chunk_t envp;
		LFOP_chunk_t lfop;
		Ramp_chunk_t ramp;
		TrkP_chunk_t trkp;
		ModP_chunk_t modp;
	}
};

IFF_root_t root_chunk @ 0;
