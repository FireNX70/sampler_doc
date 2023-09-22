#pragma endian big
#define BLOCK_SIZE 512

struct Header
{
    char magic[16];
    padding[16];
    char text[224];
};

struct Directory
{
    char name[16];
    u32 block_num;
    u32 block_cnt;
    u8 unknown[2];
    u8 file_cnt;
    padding[5];
};

struct DiskListEntry
{
    char name[48];
    u32 block_num;
    u32 block_cnt;
    u8 unknown;
    u8 instrument_group_idx;
    padding[6];
};

struct InstrumentGroupEntry
{
    char name[32];
};

u16 SAMPLES_PER_SEGMENT = 12288;

struct Patch
{	
    char patchName[12];
	u8 bendRange;
	u8 dummy1[1];
	u8 afterTouchSense;
	u8 keyMode;
	u8 velocitySwThreshold;
	u8 toneToKey1[109];
	u8 toneToKey2[109];
	u8 copySource;
	u8 octaveShift;
	u8 outputLevel;
	u8 dummy2[1];
	u8 detune;
	u8 velocityMixRatio;
	u8 afterTouchAssign;
	u8 keyAssign;
	u8 outputAssign;
	u8 dummy3[12];
};

struct FunctionParameters
{
    u8 masterTune;
	u8 dummy1[13];
	u8 audioTrig;
	u8 dummy2[1];
	u8 voiceMode;
	u8 multiMidiRxCh[8];
	u8 multiPatchNumber[8];
	u8 dummy3[9];
	u8 keyboardDisplay;
	u8 multiLevel[8];
	u8 diskLabel[60];
	u8 dummy4[4];
	u8 externalController;
	u8 dummy5[140];
};

struct MidiParameters
{	
    u8 dummy1[32];
	u8 rxChannel[8];
	u8 rxProgramChange[8];
	u8 rxBender[8];
	u8 rxModulation[8];
	u8 rxHold[8];
	u8 rxAfterTouch[8];
	u8 rxVolume[8];
	u8 rxBendRange[8];
	u8 dummy2[1];
	u8 systemExclusive;
	u8 deviceId;
	u8 dummy3[1];
	u8 rxProgramChangeNumber[32];
	u8 dummy4[124];
};

enum SampleRate: u8
{
    Thirty_KHz,
    Fifteen_KHz
};

enum BankSelect: u8
{
    Bank_A,
    Bank_B,
    Unused
};

struct ToneParameters
{
    char toneName[8];
	u8 output;
	u8 parent_tone;
	bool subtone;
	SampleRate sample_rate;
	u8 original_key;
	BankSelect bank;
	u8 start_segment;
	u8 segment_cnt;
	u24 startPoint;
	u24 endPoint;
	u24 loopPoint;
	u8 loopMode;
	u8 tvaLfoDepth;
	u8 dummy1[1];
	u8 lfoRate;
	u8 lfoSync;
	u8 lfoDelay;
	u8 dummy2[1];
	u8 lfoMode;
	u8 oscLfoDepth;
	u8 lfoPolarity;
	u8 lfoOffset;
	u8 transpose;
	u8 fineTune;
	u8 tvfCutOff;
	u8 tvfResonance;
	u8 tvfKeyFollow;
	u8 dummy3[1];
	u8 tvfLfoDepth;
	u8 tvfEgDepth;
	u8 tvfEgPolarity;
	u8 tvfLevelCurve;
	u8 tvfKeyRateFollow;
	u8 tvfVelocityRateFollow;
	u8 dummy4[1];
	u8 tvfSwitch;
	u8 benderSwitch;
	u8 tvaEnvSustainPoint;
	u8 tvaEnvEndPoint;
	u8 tvaEnvLevel1;
	u8 tvaEnvRate1;
	u8 tvaEnvLevel2;
	u8 tvaEnvRate2;
	u8 tvaEnvLevel3;
	u8 tvaEnvRate3;
	u8 tvaEnvLevel4;
	u8 tvaEnvRate4;
	u8 tvaEnvLevel5;
	u8 tvaEnvRate5;
	u8 tvaEnvLevel6;
	u8 tvaEnvRate6;
	u8 tvaEnvLevel7;
	u8 tvaEnvRate7;
	u8 tvaEnvLevel8;
	u8 tvaEnvRate8;
	u8 dummy5[1];
	u8 tvaEnvKeyRate;
	u8 level;
	u8 envVelRate;
	u8 recThreshold;
	u8 recPreTrigger;
	u8 recSamplingFrequency;
	u24 recStartPoint;
	u24 recEndPoint;
	u24 recLoopPoint;
	u8 zoomT;
	u8 zoomL;
	u8 copySource;
	u8 loopTune;
	u8 tvaLevelCurve;
	u8 dummy6[12];
	u24 loopLength;
	u8 pitchFollow;
	u8 envZoom;
	u8 tvfEnvSustainPoint;
	u8 tvfEnvEndPoint;
 	u8 tvfEnvLevel1;
	u8 tvfEnvRate1;
	u8 tvfEnvLevel2;
	u8 tvfEnvRate2;
	u8 tvfEnvLevel3;
	u8 tvfEnvRate3;
	u8 tvfEnvLevel4;
	u8 tvfEnvRate4;
	u8 tvfEnvLevel5;
	u8 tvfEnvRate5;
	u8 tvfEnvLevel6;
	u8 tvfEnvRate6;
	u8 tvfEnvLevel7;
	u8 tvfEnvRate7;
	u8 tvfEnvLevel8;
	u8 tvfEnvRate8;
	u8 afterTouchSwitch;
	u8 dummy7[2];
};

struct ToneListEntry
{	char toneName[8];
	u8 output;
	u8 parent_tone;
	bool subtone;
	SampleRate sample_rate;
	u8 original_key;
	BankSelect bank;
	u8 start_segment;
	u8 segment_cnt;
};

struct SampleSegment
{
    //these aren't actually 16-bit
    //samples but mangled 12-bit
    //samples
    u16 data[SAMPLES_PER_SEGMENT];
};

struct Footer
{
    char image_name[48];
    u8 unknown[4];
    u32 block_cnt;
    u8 unknown2[8];
    padding[960];
};

struct Area
{
    Patch patches[16];
    FunctionParameters function_parameters;
    MidiParameters midi_parameters;
    ToneParameters tone_parameters[32];
    ToneListEntry tone_list[32];
    SampleSegment sample_bank_A[18];
    SampleSegment sample_bank_B[18];
    Footer footer;
};

Header header @ 0x0;
Directory instr_group @ 0x100;
Directory sound_directory @ 0x120;
Directory map @ 0x140;

InstrumentGroupEntry instrument_group_list[instr_group.file_cnt] @ instr_group.block_num * BLOCK_SIZE;
DiskListEntry disk_list[sound_directory.file_cnt] @ sound_directory.block_num * BLOCK_SIZE;
u16 map1[map.file_cnt] @ map.block_num * BLOCK_SIZE;

Area areas[24] @ disk_list[0].block_num * BLOCK_SIZE;