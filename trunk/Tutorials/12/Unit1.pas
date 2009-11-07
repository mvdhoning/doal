unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, OpenAL,
  StdCtrls;

type
  TForm1 = class(TForm)
    Play: TButton;
    Stop: TButton;
    Pause: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure PlayClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure PauseClick(Sender: TObject);
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

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
  argv: array of PAlByte;
  format: TALEnum;
  size: TALSizei;
  freq: TALSizei;
  loop: TALInt;
  data: TALVoid;

  FnName: PALubyte;
  Env: TAluInt;

begin
  InitOpenAL;
  ReadOpenALExtensions; //eax functions are now available in the openal unit

  AlutInit(nil,argv);

  AlGenBuffers(1, @buffer);
  AlutLoadWavFile('../Media/footsteps.wav', format, data, size, freq, loop);
  AlBufferData(buffer, format, data, size, freq);
  AlutUnloadWav(format, data, size, freq);

  AlGenSources(1, @source);
  AlSourcei ( source, AL_BUFFER, buffer);
  AlSourcef ( source, AL_PITCH, 1.0 );
  AlSourcef ( source, AL_GAIN, 1.0 );
  AlSourcefv ( source, AL_POSITION, @sourcepos);
  AlSourcefv ( source, AL_VELOCITY, @sourcevel);
  AlSourcei ( source, AL_LOOPING, AL_TRUE);

  AlListenerfv ( AL_POSITION, @listenerpos);
  AlListenerfv ( AL_VELOCITY, @listenervel);
  AlListenerfv ( AL_ORIENTATION, @listenerori);

  Label1.Caption := 'No EAX';

  // Check for EAX 2.0 support
  if alIsExtensionPresent('EAX2.0') then
  begin
    Label1.Caption := 'EAX2.0 available';

    //set the effect
    Env := EAX_ENVIRONMENT_BATHROOM;
    eaxSet(DSPROPSETID_EAX20_ListenerProperties,
         DSPROPERTY_EAXLISTENER_ENVIRONMENT or
         DSPROPERTY_EAXLISTENER_DEFERRED,
         0, @Env, sizeof(TALuint));

    // Commit settings on source 0
    eaxSet(DSPROPSETID_EAX20_BufferProperties,
         DSPROPERTY_EAXBUFFER_COMMITDEFERREDSETTINGS,
         source, nil, 0);

    // Commit Listener settings
    eaxSet(DSPROPSETID_EAX20_ListenerProperties,
         DSPROPERTY_EAXLISTENER_COMMITDEFERREDSETTINGS, 0, nil, 0);

  end;

end;

procedure TForm1.PlayClick(Sender: TObject);
begin
  AlSourcePlay(source);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  AlDeleteBuffers(1, @buffer);
  AlDeleteSources(1, @source);
  AlutExit();
end;

procedure TForm1.StopClick(Sender: TObject);
begin
  AlSourceStop(source);
end;

procedure TForm1.PauseClick(Sender: TObject);
begin
  AlSourcePause(source);
end;

end.
