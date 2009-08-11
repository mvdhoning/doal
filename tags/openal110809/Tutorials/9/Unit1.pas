unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, al, altypes, alut,
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
  argv: array of PChar;
  format: TALEnum;
  size: TALSizei;
  freq: TALSizei;
  loop: TALInt;
  data: TALVoid;
  oggext: TAlBoolean;
  oggfile: Tmemorystream;

begin
  AlutInit(nil,argv);

  AlGenBuffers(1, @buffer);

  oggext:=alIsExtensionPresent('AL_EXT_vorbis'); //check on the vorbis extension (also inits ogg vorbis support)
  if oggext=true then
  begin
   label1.Caption:='Vorbis extension available'; //load and use ogg file
   oggfile:=TMemoryStream.Create;
   oggfile.LoadFromFile('boom.ogg');
   AlBufferData(buffer, AL_FORMAT_VORBIS_EXT, oggfile.Memory, oggfile.Size, 44800);
   oggfile.Free;
  end
  else
  begin
   label1.Caption:='Vorbis extension not available'; //do things the old way
   AlutLoadWavFile('ding.wav', format, data, size, freq, loop);
   AlBufferData(buffer, format, data, size, freq);
   AlutUnloadWav(format, data, size, freq);
  end;

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
