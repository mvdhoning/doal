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

const
  numbuffers = 2;

var
  Form1: TForm1;

  buffer : array [0..numbuffers] of TALuint;
  source : TALuint;
  sourcepos: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0 );
  sourcevel: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0 );
  listenerpos: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0);
  listenervel: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0);
  listenerori: array [0..5] of TALfloat= ( 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);

  processed: integer;
  bufferid: TALInt;
  finished: boolean;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
  argv: array of PalByte;
  format: TALEnum;
  size: TALSizei;
  freq: TALSizei;
  loop: TALInt;
  data: TALVoid;

begin
  InitOpenAL();
  AlutInit(nil,argv);

  AlGenBuffers(numbuffers, @buffer);
  AlutLoadWavFile('..\Media\ding.wav', format, data, size, freq, loop);
  AlBufferData(buffer[0], format, data, size, freq);
  AlutUnloadWav(format, data, size, freq);
  AlutLoadWavFile('..\Media\phaser.wav', format, data, size, freq, loop);
  AlBufferData(buffer[1], format, data, size, freq);
  AlutUnloadWav(format, data, size, freq);

  AlGenSources(1, @source);
  alSourceQueueBuffers(source, numbuffers, @buffer);
  AlSourcef ( source, AL_PITCH, 1.0 );
  AlSourcef ( source, AL_GAIN, 1.0 );
  AlSourcefv ( source, AL_POSITION, @sourcepos);
  AlSourcefv ( source, AL_VELOCITY, @sourcevel);
  AlSourcei ( source, AL_LOOPING, AL_FALSE);

  AlListenerfv ( AL_POSITION, @listenerpos);
  AlListenerfv ( AL_VELOCITY, @listenervel);
  AlListenerfv ( AL_ORIENTATION, @listenerori);
end;

procedure TForm1.PlayClick(Sender: TObject);
begin
  finished:=false;
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
  finished:=true;
  AlSourceStop(source);
end;

procedure TForm1.PauseClick(Sender: TObject);
begin
  AlSourcePause(source);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if not finished then
  begin
    alGetSourcei(source, AL_BUFFERS_PROCESSED, @processed);
    if processed = 2 then
    begin
      alsourceplay(source);
    end;
  end else
  begin
    alsourcestop(source);
  end;
end;

end.
