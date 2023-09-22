#pragma endian big

u16 SAMPLES_PER_SEGMENT = 12288;

struct Header
{
    padding[4];
    char machine_name[8];
    padding[4];
    char text[112];
    padding[384];
};

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
    ROM_A,
    ROM_B,
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
    //these are 12-bit samples
    //thus 3/2 (1.5) bytes per sample
    //this only actually works fine
    //because we have an even number
    //of samples per segment
    u8 data[SAMPLES_PER_SEGMENT * 3 / 2];
};

struct Disk
{
    Header header;
    u8 other_data[54784];
    ToneParameters tone_parameters_W30[64];
    ToneListEntry tone_list_W30[64];
    Patch patches[16];
    FunctionParameters function_parameters;
    MidiParameters midi_parameters;
    ToneParameters tone_parameters[32];
    ToneListEntry tone_list[32];
    SampleSegment sample_bank_A[18];
    SampleSegment sample_bank_B[18];
};

Disk disk @ 0x0;
//Header header @ 0x0;
//ToneParameters tone_parameters_W30[64] @ 0xD800;
//ToneListEntry tone_list_W30[64] @ 0xF800;
//Patch patches[16] @ 0xFC00;
//FunctionParameters function_parameters  @ 0x10C00;
//MidiParameters midi_parameters @ 0x10D00;
//ToneParameters tone_parameters[32] @ 0x10E00;
//ToneListEntry tone_list[32] @ 0x11E00;
//SampleSegment sample_bank_A[18] @ 0x12000;
//SampleSegment sample_bank_B[18] @ 0x63000;