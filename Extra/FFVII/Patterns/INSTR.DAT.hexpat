#pragma endian little

enum Env_mode_t: u8
{
	linear_inc = 1,
	linear_dec = 3,
	exponential_inc = 5,
	exponential_dec = 7
};

struct AKAO_instr
{
	u32 start;
	u32 loop_start;
	u8 attack_rate;
	u8 decay_rate;
	u8 sustain_level;
	u8 sustain_rate;
	u8 release_rate;
	Env_mode_t attack_mode; //default 1
	Env_mode_t sustain_mode; //default 3
	Env_mode_t release_mode; //default 3
	u32 pitch[12];
};

AKAO_instr akaoinstr[93] @ 0x00;
