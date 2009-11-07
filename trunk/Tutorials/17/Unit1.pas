unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, OpenAL, efxutil,
  StdCtrls;

type
  TForm1 = class(TForm)
    Play: TButton;
    Stop: TButton;
    Pause: TButton;
    SelectDevice: TComboBox;
    SetDevice: TButton;
    EffectEnabled2: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure PlayClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure PauseClick(Sender: TObject);
    procedure SetDeviceClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  buffer : TALuint;
  source : TALuint;
  sourcepos: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0 );
  sourcevel: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0 );
  listenerpos: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0);
  listenervel: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0);
  listenerori: array [0..5] of TALfloat= ( 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
  Context: PALCcontext;
  Device: PALCdevice;

  //efx
  uiEffectSlot: TALuint;
  uiEffect: TALuint;
  bEffectCreated: TALboolean;
  efxReverb: EFXEAXREVERBPROPERTIES;
  eaxBathroom: EAXREVERBPROPERTIES;

implementation

{$R *.DFM}

function CreateAuxEffectSlot(var uiAuxEffectSlot: TALuint): TALboolean;
var
  bReturn: TALboolean;
begin
	bReturn := false;

	// Clear AL Error state
	alGetError();

	// Generate an Auxiliary Effect Slot
	alGenAuxiliaryEffectSlots(1, @uiAuxEffectSlot);
	if (alGetError() = AL_NO_ERROR) then
		bReturn := true;

	result := bReturn;
end;

function CreateEffect(var uiEffect: TALuint; eEffectType: TALenum): TALboolean;
var
  bReturn: TALboolean;
begin
	bReturn := false;

		// Clear AL Error State
		alGetError();

		// Generate an Effect
		alGenEffects(1, @uiEffect);
		if (alGetError() = AL_NO_ERROR) then
		begin
			// Set the Effect Type
			alEffecti(uiEffect, AL_EFFECT_TYPE, eEffectType );
			if (alGetError() = AL_NO_ERROR) then
				bReturn := true
			else
				alDeleteEffects(1, @uiEffect);
		end;

	result := bReturn;
end;

function SetEFXEAXReverbProperties( pEFXEAXReverb: PEFXEAXREVERBPROPERTIES;  uiEffect: TALuint): TALboolean;
var
  bReturn: TALboolean;
begin
	bReturn := false;

//	if (pEFXEAXReverb) then
//	begin
		// Clear AL Error code
		alGetError();

		alEffectf(uiEffect, AL_EAXREVERB_DENSITY, pEFXEAXReverb.flDensity);
		alEffectf(uiEffect, AL_EAXREVERB_DIFFUSION, pEFXEAXReverb.flDiffusion);
		alEffectf(uiEffect, AL_EAXREVERB_GAIN, pEFXEAXReverb.flGain);
		alEffectf(uiEffect, AL_EAXREVERB_GAINHF, pEFXEAXReverb.flGainHF);
		alEffectf(uiEffect, AL_EAXREVERB_GAINLF, pEFXEAXReverb.flGainLF);
		alEffectf(uiEffect, AL_EAXREVERB_DECAY_TIME, pEFXEAXReverb.flDecayTime);
		alEffectf(uiEffect, AL_EAXREVERB_DECAY_HFRATIO, pEFXEAXReverb.flDecayHFRatio);
		alEffectf(uiEffect, AL_EAXREVERB_DECAY_LFRATIO, pEFXEAXReverb.flDecayLFRatio);
		alEffectf(uiEffect, AL_EAXREVERB_REFLECTIONS_GAIN, pEFXEAXReverb.flReflectionsGain);
		alEffectf(uiEffect, AL_EAXREVERB_REFLECTIONS_DELAY, pEFXEAXReverb.flReflectionsDelay);
		alEffectfv(uiEffect, AL_EAXREVERB_REFLECTIONS_PAN, @pEFXEAXReverb.flReflectionsPan);
		alEffectf(uiEffect, AL_EAXREVERB_LATE_REVERB_GAIN, pEFXEAXReverb.flLateReverbGain);
		alEffectf(uiEffect, AL_EAXREVERB_LATE_REVERB_DELAY, pEFXEAXReverb.flLateReverbDelay);
		alEffectfv(uiEffect, AL_EAXREVERB_LATE_REVERB_PAN, @pEFXEAXReverb.flLateReverbPan);
		alEffectf(uiEffect, AL_EAXREVERB_ECHO_TIME, pEFXEAXReverb.flEchoTime);
		alEffectf(uiEffect, AL_EAXREVERB_ECHO_DEPTH, pEFXEAXReverb.flEchoDepth);
		alEffectf(uiEffect, AL_EAXREVERB_MODULATION_TIME, pEFXEAXReverb.flModulationTime);
		alEffectf(uiEffect, AL_EAXREVERB_MODULATION_DEPTH, pEFXEAXReverb.flModulationDepth);
		alEffectf(uiEffect, AL_EAXREVERB_AIR_ABSORPTION_GAINHF, pEFXEAXReverb.flAirAbsorptionGainHF);
		alEffectf(uiEffect, AL_EAXREVERB_HFREFERENCE, pEFXEAXReverb.flHFReference);
		alEffectf(uiEffect, AL_EAXREVERB_LFREFERENCE, pEFXEAXReverb.flLFReference);
		alEffectf(uiEffect, AL_EAXREVERB_ROOM_ROLLOFF_FACTOR, pEFXEAXReverb.flRoomRolloffFactor);
		alEffecti(uiEffect, AL_EAXREVERB_DECAY_HFLIMIT, pEFXEAXReverb.iDecayHFLimit);

		if (alGetError() = AL_NO_ERROR) then
			bReturn := true;
//	end;

	result := bReturn;
end;


procedure TForm1.FormCreate(Sender: TObject);
var
  devicelist, defaultdevice: PAnsiChar;
  devices: TStringList;
  loop: integer;

begin
  InitOpenAL;

  //enumerate devices
  defaultDevice := '';
  deviceList := '';
  if alcIsExtensionPresent(nil,'ALC_ENUMERATION_EXT') = TRUE then
  begin
   defaultDevice := alcGetString(nil, ALC_DEFAULT_DEVICE_SPECIFIER);
   deviceList := alcGetString(nil, ALC_DEVICE_SPECIFIER);
  end;
  devices:=TStringList.Create;

  //make devices tstringlist
  if devicelist<>'' then
  begin
  devices.Add(ansistring(devicelist));
  for loop:=0 to 12 do
  begin
    StrCopy(Devicelist, @Devicelist[strlen(pchar(devices.text))-(loop+1)]);
    if length(DeviceList)<=0 then break; //exit loop if no more devices are found
    devices.Add(string(Devicelist));
  end;

  end;

  //fill the combobox
  SelectDevice.Items.Add('Default ('+defaultDevice+')');
  SelectDevice.ItemIndex:=0;
  SelectDevice.Items.AddStrings(devices);

  //clean up devices tstringlist
  devices.Free;
end;

procedure TForm1.PlayClick(Sender: TObject);
begin
  if EffectEnabled2.Checked then
    alSource3i(source, AL_AUXILIARY_SEND_FILTER, uiEffectSlot, 0, AL_FILTER_NULL)
  else
    alSource3i(source, AL_AUXILIARY_SEND_FILTER, AL_EFFECTSLOT_NULL, 0, AL_FILTER_NULL);

  AlSourcePlay(source);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin

  //clean up after the efx effect

  // Remove Effect Send from Source
  alSource3i(source, AL_AUXILIARY_SEND_FILTER, AL_EFFECTSLOT_NULL, 0, AL_FILTER_NULL);

  // Load NULL Effect into Effect Slot
  alAuxiliaryEffectSloti(uiEffectSlot, AL_EFFECTSLOT_EFFECT, AL_EFFECT_NULL);

  // Delete Effect
  alDeleteEffects(1, @uiEffect);

  // Delete Auxiliary Effect Slot
  alDeleteAuxiliaryEffectSlots(1, @uiEffectSlot);

  //end clean up after the efx effect

  AlDeleteBuffers(1, @buffer);
  AlDeleteSources(1, @source);

  //Free Context and Device

  //Get active context
  Context:=alcGetCurrentContext();
  //Get device for active context
  Device:=alcGetContextsDevice(Context);
  //Release context(s)
  alcDestroyContext(Context);
  //Close device
  alcCloseDevice(Device);



end;

procedure TForm1.StopClick(Sender: TObject);
begin
  AlSourceStop(source);
end;

procedure TForm1.PauseClick(Sender: TObject);
begin
  AlSourcePause(source);
end;

procedure TForm1.SetDeviceClick(Sender: TObject);
var
  data : Array[0..1000] OF Byte;
  loop : Integer;

begin
  //Open (selected) device
  if SelectDevice.itemindex = 0 then
    Device := alcOpenDevice(nil) // this is supposed to select the "preferred device"
  else
    Device := alcOpenDevice(pchar(SelectDevice.Items[SelectDevice.itemindex])); //use the chosen one

  //Create context(s)
  Context := alcCreateContext(Device,nil);

  //Set active context
  alcMakeContextCurrent(Context);

  //Clear Error Code
  alGetError();

  //Create Buffers
  AlGenBuffers(1, @buffer);
  For Loop:=0 to 1000 do
    data[loop] := Round(50*sin(loop*(5*pi)/50.0)+128);
  alBufferData(buffer, AL_FORMAT_MONO8, @data, length(data)-1, 11024);

  //Create Sources
  AlGenSources(1, @source);
  AlSourcei ( source, AL_BUFFER, buffer);
  AlSourcef ( source, AL_PITCH, 1.0 );
  AlSourcef ( source, AL_GAIN, 1.0 );
  AlSourcefv ( source, AL_POSITION, @sourcepos);
  AlSourcefv ( source, AL_VELOCITY, @sourcevel);
  AlSourcei ( source, AL_LOOPING, AL_TRUE);

  //Create Listener
  AlListenerfv ( AL_POSITION, @listenerpos);
  AlListenerfv ( AL_VELOCITY, @listenervel);
  AlListenerfv ( AL_ORIENTATION, @listenerori);

  //Update Form
  selectdevice.Enabled:=false;
  setdevice.Enabled:=false;
  play.Enabled:=true;
  stop.Enabled:=true;
  pause.Enabled:=true;

  //Read Extension functions
  ReadOpenALExtensions;
  ReadOpenALEFXUtil;

  //Now we are ready to create the effect
  bEffectCreated := false;

  //EAX bathroom effect
  eaxbathroom.ulEnvironment:=3;
  eaxbathroom.flEnvironmentSize:=1.4;
  eaxbathroom.flEnvironmentDiffusion:=1.000;
  eaxbathroom.lRoom:=-1000;
  eaxbathroom.lRoomHF:=-1200;
  eaxbathroom.lRoomLF:=0;
  eaxbathroom.flDecayTime:=1.49;
  eaxbathroom.flDecayHFRatio:=0.54;
  eaxbathroom.flDecayLFRatio:=1.00;
  eaxbathroom.lReflections:=-370;
  eaxbathroom.flReflectionsDelay:=0.007;
  eaxbathroom.vReflectionsPan.x:=0.0;
  eaxbathroom.vReflectionsPan.y:=0.0;
  eaxbathroom.vReflectionsPan.z:=0.0;
  eaxbathroom.lReverb:=1030;
  eaxbathroom.flReverbDelay:=0.011;
  eaxbathroom.vReverbPan.x:=0.00;
  eaxbathroom.vReverbPan.y:=0.00;
  eaxbathroom.vReverbPan.z:=0.00;
  eaxbathroom.flEchoTime:=0.250;
  eaxbathroom.flEchoDepth:=0.000;
  eaxbathroom.flModulationTime:=0.250;
  eaxbathroom.flModulationDepth:=0.000;
  eaxbathroom.flAirAbsorptionHF:=-5.0;
  eaxbathroom.flHFReference:=5000.0;
  eaxbathroom.flLFReference:=250.0;
  eaxbathroom.flRoomRolloffFactor:=0.00;
  eaxbathroom.ulFlags:=$3f;

  // The EFX Extension includes support for global effects, such as Reverb.  To use a global effect,
  // you need to create an Auxiliary Effect Slot to store the Effect ...
	if (CreateAuxEffectSlot(uiEffectSlot)) then
	begin
		// Once we have an Auxiliary Effect Slot, we can generate an Effect Object, set its Type
		// and Parameter Values, and then load the Effect into the Auxiliary Effect Slot ...
		if (CreateEffect(uiEffect, AL_EFFECT_EAXREVERB)) then
		begin
			bEffectCreated := true;
		end
	end;

  // Reverb Preset is stored in legacy format, use helper function to convert to EFX EAX Reverb
  ConvertReverbParameters(@eaxBathroom, @efxReverb);

  // Set the Effect parameters
	SetEFXEAXReverbProperties(@efxReverb, uiEffect);

  // Load Effect into Auxiliary Effect Slot
  alAuxiliaryEffectSloti(uiEffectSlot, AL_EFFECTSLOT_EFFECT, uiEffect);


end;

end.
