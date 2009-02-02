unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, openal, 
  StdCtrls;

type
  TForm1 = class(TForm)
    Play: TButton;
    Stop: TButton;
    Pause: TButton;
    SelectDevice: TComboBox;
    SetDevice: TButton;
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

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
  devicelist, defaultdevice: PALCubyte;
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
  devices.Add(string(devicelist));
  for loop:=0 to 12 do
  begin
    StrCopy(Devicelist, @Devicelist[strlen(pchar(devices.text))-(loop+1)]);
    if length(DeviceList)<=0 then break; //exit loop if no more devices are found
    devices.Add(string(Devicelist));
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
  AlSourcePlay(source);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
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
  alBufferData(buffer, AL_FORMAT_MONO8, @data, length(data), 11024);

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
end;

end.
