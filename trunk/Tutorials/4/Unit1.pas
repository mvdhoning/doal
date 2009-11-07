unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, OpenAL,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Play: TButton;
    Stop: TButton;
    Pause: TButton;
    Timer1: TTimer;
    PlayWalk2: TButton;
    StopWalk2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure PlayClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure PauseClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PlayWalk2Click(Sender: TObject);
    procedure StopWalk2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  numbuffers = 3;
  numsources = 4;
  walk = 0;
  ding = 1;
  zap = 2;
  walk2 = 3;

var
  Form1: TForm1;

  buffer : array [0..numbuffers] of TALuint;
  source : array [0..numsources] of TALuint;
  sourcepos: array [0..2] of TALfloat= ( -5.0, 0.0, -5.0 );
  sourcevel: array [0..2] of TALfloat= ( 0.5, 0.0, 0.5 );
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
  AlutInit(nil,argv);

  AlGenBuffers(numbuffers, @buffer);
  AlutLoadWavFile('../Media/footsteps.wav', format, data, size, freq, loop);
  AlBufferData(buffer[walk], format, data, size, freq);
  AlutUnloadWav(format, data, size, freq);

  AlutLoadWavFile('../Media/ding.wav', format, data, size, freq, loop);
  AlBufferData(buffer[ding], format, data, size, freq);
  AlutUnloadWav(format, data, size, freq);

  AlutLoadWavFile('../Media/phaser.wav', format, data, size, freq, loop);
  AlBufferData(buffer[zap], format, data, size, freq);
  AlutUnloadWav(format, data, size, freq);

  AlGenSources(numsources, @source);
  AlSourcei ( source[walk], AL_BUFFER, buffer[walk]);
  AlSourcef ( source[walk], AL_PITCH, 1.0 );
  AlSourcef ( source[walk], AL_GAIN, 1.5 );
  AlSourcefv ( source[walk], AL_POSITION, @sourcepos);
  AlSourcefv ( source[walk], AL_VELOCITY, @sourcevel);
  AlSourcei ( source[walk], AL_LOOPING, AL_TRUE);

  SourcePos[0] := 8.0;
  SourcePos[1] := 1.0;
  SourcePos[2] := -8.0;
  AlSourcei ( source[ding], AL_BUFFER, buffer[ding]);
  AlSourcef ( source[ding], AL_PITCH, 1.0 );
  AlSourcef ( source[ding], AL_GAIN, 0.2 );
  AlSourcefv ( source[ding], AL_POSITION, @sourcepos);
  AlSourcefv ( source[ding], AL_VELOCITY, @sourcevel);
  AlSourcei ( source[ding], AL_LOOPING, AL_TRUE);

  SourcePos[0] := -8.0;
  SourcePos[1] := 1.0;
  SourcePos[2] := 8.0;
  AlSourcei ( source[zap], AL_BUFFER, buffer[zap]);
  AlSourcef ( source[zap], AL_PITCH, 1.0 );
  AlSourcef ( source[zap], AL_GAIN, 0.2 );
  AlSourcefv ( source[zap], AL_POSITION, @sourcepos);
  AlSourcefv ( source[zap], AL_VELOCITY, @sourcevel);
  AlSourcei ( source[zap], AL_LOOPING, AL_TRUE);

  SourcePos[0] := 0.0;
  SourcePos[1] := 0.0;
  SourcePos[2] := 0.0;
  AlSourcei ( source[walk2], AL_BUFFER, buffer[walk]);
  AlSourcef ( source[walk2], AL_PITCH, 1.0 );
  AlSourcef ( source[walk2], AL_GAIN, 1.0 );
  AlSourcefv ( source[walk2], AL_POSITION, @sourcepos);
  AlSourcefv ( source[walk2], AL_VELOCITY, @sourcevel);
  AlSourcei ( source[walk2], AL_LOOPING, AL_TRUE);

  AlListenerfv ( AL_POSITION, @listenerpos);
  AlListenerfv ( AL_VELOCITY, @listenervel);
  AlListenerfv ( AL_ORIENTATION, @listenerori);
end;

procedure TForm1.PlayClick(Sender: TObject);
begin
  AlSourcePlay(source[walk]);
  AlSourcePlay(source[ding]);
  AlSourcePlay(source[zap]);
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
  AlSourceStop(source[walk]);
  AlSourceStop(source[ding]);
  AlSourceStop(source[zap]);
end;

procedure TForm1.PauseClick(Sender: TObject);
begin
  AlSourcePause(source[walk]);
  AlSourcePause(source[ding]);
  AlSourcePause(source[zap]);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  SourcePos[0] := SourcePos[0] + SourceVel[0];
  SourcePos[1] := SourcePos[1] + SourceVel[1];
  SourcePos[2] := SourcePos[2] + SourceVel[2];
  If SourcePos[0] >= 5 then SourcePos[0]:=-5;
  If SourcePos[2] >= 5 then SourcePos[2]:=-5;
  alSourcefv(source[walk], AL_POSITION, @SourcePos);
end;

procedure TForm1.PlayWalk2Click(Sender: TObject);
begin
  AlSourcePlay(source[walk2]);
end;

procedure TForm1.StopWalk2Click(Sender: TObject);
begin
  AlSourceStop(source[walk2]);
end;

end.
