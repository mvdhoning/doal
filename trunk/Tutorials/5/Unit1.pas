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
    Error: TLabel;
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

begin
  InitOpenAL;

  Play.Enabled:=False;
  Stop.Enabled:=False;
  Pause.Enabled:=False;

  AlutInit(nil,argv);

  AlGenBuffers(1, @buffer);
  if alGetError = AL_NO_ERROR then

  begin
    AlutLoadWavFile('../Media/ding.wav', format, data, size, freq, loop);

    AlBufferData(buffer, format, data, size, freq);
    if alGetError = AL_NO_ERROR then
    begin
      AlutUnloadWav(format, data, size, freq);

      AlGenSources(1, @source);
      if alGetError = AL_NO_ERROR then
      begin
        AlSourcei ( source, AL_BUFFER, buffer);
        AlSourcef ( source, AL_PITCH, 1.0 );
        AlSourcef ( source, AL_GAIN, 1.0 );
        AlSourcefv ( source, AL_POSITION, @sourcepos);
        AlSourcefv ( source, AL_VELOCITY, @sourcevel);
        AlSourcei ( source, AL_LOOPING, AL_TRUE);

        AlListenerfv ( AL_POSITION, @listenerpos);
        AlListenerfv ( AL_VELOCITY, @listenervel);
        AlListenerfv ( AL_ORIENTATION, @listenerori);

        Play.Enabled:=True;
        Stop.Enabled:=True;
        Pause.Enabled:=True;
      End
      Else
      begin
        Error.Caption:='Could not create a source';
      end;
    End
    Else
    Begin
        Error.Caption:='Could not load wave data to buffer';
        AlutUnloadWav(format, data, size, freq);
    End;
  End
  Else
  Begin
    Error.Caption:='Could not create a buffer.'
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
