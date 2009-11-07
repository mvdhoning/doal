unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, OpenAL, oooal, StdCtrls;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Play: TButton;
    Stop: TButton;
    GroupBox2: TGroupBox;
    Pause2: TButton;
    Play2: TButton;
    Stop2: TButton;
    xpos: TEdit;
    ypos: TEdit;
    zpos: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Update2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure PlayClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure Pause2Click(Sender: TObject);
    procedure Play2Click(Sender: TObject);
    procedure Stop2Click(Sender: TObject);
    procedure Update2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  sound1 : TalObject;
  sound2 : TalObject;
  listenerpos: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0);
  listenervel: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0);
  listenerori: array [0..5] of TALfloat= ( 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
  argv: array of PAlByte;

begin
  InitOpenAL;
  DecimalSeparator:='.';

  AlutInit(nil,argv);

  Sound1:=TalObject.Create;
  Sound1.LoadFromFile('../Media/ding.wav');
  Sound1.Update;

  Sound2:=TalObject.Create;
  Sound2.LoadFromFile('../Media/phaser.wav');
  Sound2.loop:=AL_TRUE;
  Sound2.Gain:=0.5;
  Sound2.Update;

  AlListenerfv ( AL_POSITION, @listenerpos);
  AlListenerfv ( AL_VELOCITY, @listenervel);
  AlListenerfv ( AL_ORIENTATION, @listenerori);

end;

procedure TForm1.PlayClick(Sender: TObject);
begin
  Sound1.Play;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  If Sound1.playing then Sound1.Stop;
  Sound1.Destroy;

  If Sound2.playing then Sound2.Stop;
  Sound2.Destroy;

  AlutExit();
end;

procedure TForm1.StopClick(Sender: TObject);
begin
  Sound1.Stop;
end;

procedure TForm1.Pause2Click(Sender: TObject);
begin
  Sound2.Pause;
end;

procedure TForm1.Play2Click(Sender: TObject);
begin
  Sound2.Play;
end;

procedure TForm1.Stop2Click(Sender: TObject);
begin
  Sound2.Stop;
end;

procedure TForm1.Update2Click(Sender: TObject);
begin
  Sound2.xpos:=StrToFloat(xpos.text);
  Sound2.ypos:=StrToFloat(ypos.text);
  Sound2.zpos:=StrToFloat(zpos.text);
  If Sound2.playing then Sound2.Update;
end;

end.
