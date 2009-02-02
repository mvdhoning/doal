unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, al, altypes, alut,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Play: TButton;
    Stop: TButton;
    Pause: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure PlayClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure PauseClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  buffer : TALuint;
  source : TALuint;
  sourcepos: array [0..2] of TALfloat= ( -5.0, 0.0, -5.0 );
  sourcevel: array [0..2] of TALfloat= ( 0.5, 0.0, 0.5 );
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

begin
  AlutInit(nil,argv);

  AlGenBuffers(1, @buffer);
  AlutLoadWavFile('footsteps.wav', format, data, size, freq, loop);
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
end;

procedure TForm1.PlayClick(Sender: TObject);
begin
  AlSourcePlay(source);
  Timer1.Enabled:=True;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  AlDeleteBuffers(1, @buffer);
  AlDeleteSources(1, @source);
  AlutExit();
end;

procedure TForm1.StopClick(Sender: TObject);
begin
  Timer1.Enabled:=False;
  AlSourceStop(source);
end;

procedure TForm1.PauseClick(Sender: TObject);
begin
  AlSourcePause(source);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  SourcePos[0] := SourcePos[0] + SourceVel[0];
  SourcePos[1] := SourcePos[1] + SourceVel[1];
  SourcePos[2] := SourcePos[2] + SourceVel[2];
  If SourcePos[0] >= 5 then SourcePos[0]:=-5;
  If SourcePos[2] >= 5 then SourcePos[2]:=-5;
  alSourcefv(source, AL_POSITION, @SourcePos);
end;

end.
