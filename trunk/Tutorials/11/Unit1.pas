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

  SR: integer;                   //sample rate
  L: integer;                    //lenth of sample
  F: single;                    //frequency of sample
  Hz: integer;                   //frequency in hertz of sample (cycles per second)
  A: integer;                    //amplitude
  O: Array[0..1000] OF SmallInt; //output sample (1000=L) signed 16-bit
  O1: Array[0..1000] OF SmallInt; //output sample (1000=L) signed 16-bit
  O2: Array[0..1000] OF SmallInt; //output sample (1000=L) signed 16-bit
  T: integer;
  FB: single;

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
  argv: PChar;
  format: TALEnum;
  size: TALSizei;
  freq: TALSizei;
  loop: TALInt;
  data: TALVoid;
  oggext: TAlBoolean;
  oggfile: Tmemorystream;

begin
  AlutInit(nil,argv);

  //calculate the sine waveform
  Hz := 440; //440
  L := 1000;  //be carefull when changing this value as we use a static array O
  A := 32760; //maximum amplitude value for 16bit
  SR := 22000;
  F :=(2*pi*Hz)/SR;
  For T:=0 to L do
  begin
    O[T]:=Round(A*sin(F*T));
  end;

  (*
  //sample O1
  Hz:=800;
  F :=(2*pi*Hz)/SR;
  For T:=0 to L do
  begin
    O1[T]:=round(A*sin(F*T));
  end;
  //sample O2
  Hz:=1200;
  F :=(2*pi*Hz)/SR;
  For T:=0 to L do
  begin
    O2[T]:=round(A*sin(F*T));
  end;
  //combine sample O1 & O2 into O
  For T:=0 to L do
  begin
    O[T]:=(O1[T]+O2[T]) div 2;
  end;

  //sample O feedback
  Hz:=440;
  F :=(2*pi*Hz)/SR;
  FB := 10 / ( A*25); //keep the value 10 between 0 and 100
  For T:=0 to L do
  begin
    O[T]:=round(A*(sin(F*T)+(FB*O[T])));
  end;
  *)

  //load sind waveform into buffer
  AlGenBuffers(1, @buffer);
  alBufferData(buffer, AL_FORMAT_MONO16, @O, L, SR);


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
