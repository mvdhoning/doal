unit wmpu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, OpenAL, oooal, thdtimer;

type
  TForm1 = class(TForm)
    LoadButton: TButton;
    OpenDialog: TOpenDialog;
    InstrumentGroup: TGroupBox;
    InstrumentList: TListBox;
    SongName: TLabel;
    TrackOrderGroup: TGroupBox;
    TrackOrderList: TListBox;
    TrackGroup: TGroupBox;
    TrackDataC1: TListBox;
    TrackDataC2: TListBox;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    TrackDataC3: TListBox;
    Splitter3: TSplitter;
    TrackDataC4: TListBox;
    PlaySampleButton: TButton;
    NowPlaying: TLabel;
    PlaySongButton: TButton;
    np2: TLabel;
    Timer: TLabel;
    np3: TLabel;
    np4: TLabel;
    ModType: TLabel;
    ThreadedTimer1: TThreadedTimer;
    Volume: TLabel;
    Chan_Teller: TLabel;
    Chan_Teller_Effect: TLabel;
    stopsongbutton: TButton;
//    ThreadedTimer1: TThreadedTimer;
    procedure LoadButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TrackOrderListMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure PlaySampleButtonClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PlaySongButtonClick(Sender: TObject);
    procedure stopsongbuttonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  listenerpos: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0);
  listenervel: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0);
  listenerori: array [0..5] of TALfloat= ( 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);

  sourcepos1: array [0..2] of TALfloat= ( -1.0, 0.0, 0.0 );
  sourcepos2: array [0..2] of TALfloat= ( 1.0, 0.0, 0.0 );

  chan_volume: array [0..7] of word;
  chan_freq: array [0..7] of word;
  eff_tick: array [0..7] of integer;

implementation

{$R *.DFM}

uses loadmod;

const

 e_0 ='Arpeggio';
 e_1 ='Porta Up';
 e_2 ='Porta Down';
 e_3 ='Porta To Note';
 e_4 ='Vibrato';
 e_5 ='Porta + Vol Slide';
 e_6 ='Vibrato + Vol Slide';
 e_7 ='Tremolo';
 e_8 ='Pan';
 e_9 ='Sample Offset';
 e_A ='Volume Slide';
 e_B ='Jump To Pattern';
 e_C ='Set Volume';
 e_D ='Pattern Break';
 e_F ='Set Speed';
 (*
 E0x (Set Filter)
 E1x (Fine Porta Up)
 E2x (Fine Porta Down)
 E3x (Glissando Control)
 E4x (Set Vibrato Waveform)
 E5x (Set Finetune)
 E6x (Pattern Loop)
 E7x (Set Tremolo WaveForm)
 E8x (Unused)
 E9x (Retrig Note)
 EAx (Fine Volume Slide Up)
 EBx (Fine Volume Slide Down)
 ECx (Cut Note)
 EDx (Delay Note)
 EEx (Pattern Delay)
 EFx (Invert Loop)
 *)

var
   sampleprev : TalObject;
   modchan: array [0..7] of TalObject;
   modsample: array [1..31] of TAlBuffer; //a buffer is actualy something like a sample (a sound texture)

   current_pattern, current_pos, sel_track: integer;
   speed : integer = 6;
   ticks : integer;
   arpcounter : integer;

   portaup: array [0..7] of integer;
   portadown: array [0..7] of integer;
   volslide: array [0..7] of integer;
   volslidebool: array [0..7] of boolean;
   arp: array [0..7] of word;
   cs: array [0..7]of integer;
   arp_note: array [0..7] of integer;
   now_note: array [0..7] of integer;

function geteffect(effect: integer): string;
begin
 case effect of
  0: result:=e_0;
  1: result:=e_1;
  2: result:=e_2;
  3: result:=e_3;
  4: result:=e_4;
  5: result:=e_5;
  6: result:=e_6;
  7: result:=e_7;
  8: result:=e_8;
  9: result:=e_9;
  10: result:=e_a;
  11: result:=e_b;
  12: result:=e_c;
  13: result:=e_d;
  15: result:=e_f;
 else
  result:='none';
 end;
end;

procedure TForm1.LoadButtonClick(Sender: TObject);
var
   teller,teller2: integer;
   pat_pos:word;
   cur_chan: word;
begin
 if OpenDialog.Execute then
 begin
  LoadButton.Enabled:=False;
  PlaySampleButton.Enabled:=True;
  // load the module
  Load_Module(OpenDialog.FileName);
  // write the song name
  SongName.Caption:=Module_Name;
  ModType.Caption:=Module_Type;
  // write the instrument (sample) names
  For teller := 1 to 31 do
  begin
    InstrumentList.Items.Add(Sample_Name[teller]);
  end;


  //make buffers with sample data
  for teller:=1 to 31 do
  begin
   modsample[teller]:=TalBuffer.Create;
   modsample[teller].Size:=Sample_Size[teller];

   //special for sample with a loop
   If Sample_LoopStart[teller] > 0 then
   If Sample_LoopLength[teller] > 0 then
   modsample[teller].Size:=Sample_LoopLength[teller];

   modsample[teller].Format:=AL_FORMAT_MONO8;
   modsample[teller].InitSampleRate:=44800;

   //looped samples should be handled with quebuffers...
   //now misses the intro part for a looped sample (also the size of the pointer is wrong for a looped sample)
   if Sample_Size[teller] >0 then
      if Sample_LoopStart[teller] > 0 then
         modsample[teller].LoadFromPointer( @TSample(Sample_Data[teller]^)[Sample_LoopStart[teller]] )
      else
         modsample[teller].LoadFromPointer( Sample_Data[teller] ); //the normal way for a non looped sample (is OK)



   //set if sample is looped
   modsample[teller].loop:=AL_True;
   if Sample_LoopStart[teller] = 0 then
   modsample[teller].loop:=AL_False;
   if Sample_LoopLength[teller] = 0 then
   modsample[teller].loop:=AL_False;
  end;

  // write the track order
  For teller := 0 to Song_Length-1 do
  Begin
    TrackOrderList.Items.Add(IntToStr(Order[teller]));
  End;
  For Teller := 0 to {Number_Of_Patterns}0 Do       { Get all patterns }
  Begin
    pat_pos:=0;
    cur_chan:=1;
    For Teller2 := 1 to 64*Channels do            { Process entire pattern}
    Begin
     case cur_chan of
     1: TrackDataC1.Items.Add(IntTostr((teller2 div Channels)+1)+' Sample('+IntToStr(Patterns[teller]^[Pat_Pos])+') Note('+IntToStr(Patterns[teller]^[Pat_Pos+1])+') Effect('+GetEffect(Patterns[teller]^[Pat_Pos+2])+') Param('+IntToStr(Patterns[teller]^[Pat_Pos+3])+')');
     2: TrackDataC2.Items.Add(IntTostr((teller2 div Channels)+1)+' Sample('+IntToStr(Patterns[teller]^[Pat_Pos])+') Note('+IntToStr(Patterns[teller]^[Pat_Pos+1])+') Effect('+GetEffect(Patterns[teller]^[Pat_Pos+2])+') Param('+IntToStr(Patterns[teller]^[Pat_Pos+3])+')');
     3: TrackDataC3.Items.Add(IntTostr((teller2 div Channels)+1)+' Sample('+IntToStr(Patterns[teller]^[Pat_Pos])+') Note('+IntToStr(Patterns[teller]^[Pat_Pos+1])+') Effect('+GetEffect(Patterns[teller]^[Pat_Pos+2])+') Param('+IntToStr(Patterns[teller]^[Pat_Pos+3])+')');
     4: TrackDataC4.Items.Add(IntTostr((teller2 div Channels)+1)+' Sample('+IntToStr(Patterns[teller]^[Pat_Pos])+') Note('+IntToStr(Patterns[teller]^[Pat_Pos+1])+') Effect('+GetEffect(Patterns[teller]^[Pat_Pos+2])+') Param('+IntToStr(Patterns[teller]^[Pat_Pos+3])+')');
     end;
     cur_chan:=cur_chan+1;
     if cur_chan > 4 then cur_chan:=1;
     Inc(Pat_Pos,4); //4 items in note                          { Increase pointer }
    End;
  end;
 end;



end;

procedure TForm1.FormDestroy(Sender: TObject);
var
   teller: integer;
begin
    //stop playing the mod
    ThreadedTimer1.Enabled:=False;

    //remove modchan
    for teller:=0 to 7 do
    begin
    If ModChan[teller]<>nil then
    begin
     If ModChan[teller].playing then ModChan[teller].Stop;
     ModChan[teller].source.AssignBuffer(0);
     ModChan[teller].buffer:=nil;
     ModChan[teller].Free;
    end;
    end;

  for teller:=1 to 31 do
  begin
   if modsample[teller]<>nil then
    begin
     modsample[teller].Free;
    end;
  end;

    //remove sample preview
    If SamplePrev<>nil then
    begin
     If SamplePrev.playing then SamplePrev.Stop;
     SamplePrev.Free;
    end;

    //remove mod data
    If Mod_Loaded then Free_Module;

    //close openal
    AlutExit();
end;

procedure TForm1.TrackOrderListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   teller,teller2: integer;
   pat_pos:word;
   cur_chan: word;
   sel_track: integer;
begin
TrackDataC1.Items.Clear;
TrackDataC2.Items.Clear;
TrackDataC3.Items.Clear;
TrackDataC4.Items.Clear;
sel_track:=StrToInt(TrackOrderList.Items[TrackOrderList.ItemIndex]);
TrackGroup.Caption:='Track #'+IntToStr(sel_track);
For Teller := sel_track to {Number_Of_Patterns}sel_track Do       { Get all patterns }
  Begin
    pat_pos:=0;
    cur_chan:=1;
    For Teller2 := 1 to 64*Channels do            { Process entire pattern}
    Begin
     case cur_chan of
     1: TrackDataC1.Items.Add(IntTostr((teller2 div Channels)+1)+' Sample('+IntToStr(Patterns[teller]^[Pat_Pos])+') Note('+IntToStr(Patterns[teller]^[Pat_Pos+1])+') Effect('+IntToStr(Patterns[teller]^[Pat_Pos+2])+') Param('+IntToStr(Patterns[teller]^[Pat_Pos+3])+')');
     2: TrackDataC2.Items.Add(IntTostr((teller2 div Channels)+1)+' Sample('+IntToStr(Patterns[teller]^[Pat_Pos])+') Note('+IntToStr(Patterns[teller]^[Pat_Pos+1])+') Effect('+IntToStr(Patterns[teller]^[Pat_Pos+2])+') Param('+IntToStr(Patterns[teller]^[Pat_Pos+3])+')');
     3: TrackDataC3.Items.Add(IntTostr((teller2 div Channels)+1)+' Sample('+IntToStr(Patterns[teller]^[Pat_Pos])+') Note('+IntToStr(Patterns[teller]^[Pat_Pos+1])+') Effect('+IntToStr(Patterns[teller]^[Pat_Pos+2])+') Param('+IntToStr(Patterns[teller]^[Pat_Pos+3])+')');
     4: TrackDataC4.Items.Add(IntTostr((teller2 div Channels)+1)+' Sample('+IntToStr(Patterns[teller]^[Pat_Pos])+') Note('+IntToStr(Patterns[teller]^[Pat_Pos+1])+') Effect('+IntToStr(Patterns[teller]^[Pat_Pos+2])+') Param('+IntToStr(Patterns[teller]^[Pat_Pos+3])+')');
     end;
     cur_chan:=cur_chan+1;
     if cur_chan > 4 then cur_chan:=1;
     Inc(Pat_Pos,4); //4 items in note                          { Increase pointer }
    End;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  teller, t: integer;
  argv: array of PAlByte;
begin
  InitOpenAL;
  //activate openal
  AlutInit(nil,argv);

  //set up listener
  AlListenerfv ( AL_POSITION, @listenerpos);
  AlListenerfv ( AL_VELOCITY, @listenervel);
  AlListenerfv ( AL_ORIENTATION, @listenerori);

    t:=0;
  for teller:=0 to 7 do
  begin
   modchan[teller]:=TAlObject.Create;
   modchan[teller].buffer.Free; //stupid but has to be
   modchan[teller].gain:=1.0;
   modchan[teller].pitch:=1.0;
   modchan[teller].buffer.loop:=AL_FALSE;
   if t=0 then
      begin
       modchan[teller].xpos:=sourcepos1[0];
       modchan[teller].ypos:=sourcepos1[1];
       modchan[teller].zpos:=sourcepos1[2];
      end
   else
      begin
       modchan[teller].xpos:=sourcepos2[0];
       modchan[teller].ypos:=sourcepos2[1];
       modchan[teller].zpos:=sourcepos2[2];
      end;
  chan_volume[teller]:=40;
  t:=t+1;
  if t>2 then t:=0;
  end;

  Mod_Loaded := False;

end;

procedure TForm1.PlaySampleButtonClick(Sender: TObject);
var
 cur_sample: integer;
begin
  cur_sample:=InstrumentList.ItemIndex+1;
  if cur_sample <= 0 then cur_sample:=1;
  if Sample_Size[cur_sample] >0 then
  begin
   if sampleprev<>nil then sampleprev.free;
   sampleprev:=TalObject.Create;
   sampleprev.buffer.format:=AL_FORMAT_MONO8;
   sampleprev.buffer.size:=Sample_Size[cur_sample];
   sampleprev.buffer.initsamplerate:=44800;
   sampleprev.buffer.LoadFromPointer( Sample_Data[cur_sample] );
   sampleprev.source.AssignBuffer(sampleprev.buffer.buffer);
   sampleprev.samplerate:=11200;
   sampleprev.Update;
   sampleprev.play;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var cur_sample, cur_sample1,cur_sample2, cur_sample3, cur_sample4: integer;
    cur_note, cur_note1, cur_note2, cur_note3, cur_note4: longint;
    effect, effect1, effect2, effect3, effect4: integer;
    param, param1, param2, param3, param4: integer;
    cur_channel: byte;
    add_pos: integer;
    cur_volume: single;

    teller: byte;
    oldfreq, freq: integer;
    arpfreq: talfloat;

begin
//this actualy plays the mod

//timing
if ticks = speed then
begin
 //play
 for cur_channel:=0 to channels-1 do
 begin

 //set the lookup for the current position for a channel
 add_pos:=cur_channel*4;

 //see if there is an effect with or without a param
 effect:=Patterns[sel_track]^[current_pos+add_pos+2];
 param:=Abs(Patterns[sel_track]^[current_pos+add_pos+3]);

 //porta up/down
 portaup[cur_channel]:=0;
 portadown[cur_channel]:=0;

 if effect = 1 then
 begin
  portaup[cur_channel]:=param;
 end;

 if effect = 2 then
 begin
  portadown[cur_channel]:=param;
 end;

 //if effect = 3 then portaup[cur_channel]:=portaup[cur_channel]+param;

 //set speed
 //set only once for a set of channel, otherwise take onme mod plays to fast (and others also)
 if effect = 15 then
 begin
 if param <= 32 then speed:=param;
 if param > 32 then
  Begin
   timer.Caption:='timer1: '+IntToStr(1000 div ((param shl 1) div 5))+'ms';
   ThreadedTimer1.Interval:=1000 div ((param shl 1) div 5);
  end;
 end;

 //pattern jump
 if effect = 11 then
 begin
  current_pos:=0;
  if current_pattern<number_of_patterns then
     sel_track:=StrToInt(TrackOrderList.Items[param])
  else
     sel_track:=StrToInt(TrackOrderList.Items[number_of_patterns]);
  current_pattern:=param;
 end;

 //pattern break
 if effect = 13 then
 begin
  current_pos:=param;
  //mind: if last pattern then back to first
  if current_pattern<number_of_patterns then
     begin
      sel_track:=StrToInt(TrackOrderList.Items[current_pattern+1]);
      current_pattern:=current_pattern+1;
     end
  else
     begin
      sel_track:=StrToInt(TrackOrderList.Items[0]);
      current_pattern:=0;
     end;
 end;

 //read in the note value
 cur_note:=Period_Table[Patterns[sel_track]^[current_pos+add_pos+1]{+portaup[cur_channel]-portadown[cur_channel]}];
 now_note[cur_channel]:=cur_note;

 //arpegio effect
 arp[cur_channel]:=0;

 if effect = 0 then
 begin
   //shr 4 and 15
   if cur_note > 0 then
   if param>0 then arp[cur_channel]:=param else arp[cur_channel]:=0;
   arp_note[cur_channel]:=cur_note;
 end;

 //do remember the last set intrument
 if Patterns[sel_track]^[current_pos+add_pos]> 0 then
 if modchan[cur_channel].id<>Patterns[sel_track]^[current_pos+add_pos] then
 begin
  cur_sample:=Patterns[sel_track]^[current_pos+add_pos];

  if modchan[cur_channel].playing then modchan[cur_channel].stop;
  modchan[cur_channel].id:=Cur_Sample;
  modchan[cur_channel].buffer:=modsample[cur_sample];
  modchan[cur_channel].source.AssignBuffer(modsample[cur_sample].buffer);
  modchan[cur_channel].update;

  cs[cur_channel]:=cur_sample;
 end;

 //only reset volume if an instrument is set
 if Patterns[sel_track]^[current_pos+add_pos]<>0 then
  begin
   ModChan[cur_channel].gain:=1.0;
   chan_volume[cur_channel]:=40;
  end;

 //only reset sample if there is a note
 If cur_note > 0 then
  begin
    ModChan[cur_channel].samplerate:=Round(7159090.5 / (cur_note*2));
    ModChan[cur_channel].Update;
    ModChan[cur_channel].Play;
  end;

 //set volume
 if effect = 12 then
 begin
  ModChan[cur_channel].gain:=param/40;
  chan_volume[cur_channel]:=param;
  volume.caption:=''+floattostr(param/40);
 end;

 //set negative for no volslide
 volslide[cur_channel]:=-1;

 //porta + volume slide
 if effect = 5 then
 begin
     volslidebool[cur_channel]:=true;
     volslide[cur_channel]:=param;
 end;

 //vibrato + volume slide
 if effect = 6 then
 begin
     volslidebool[cur_channel]:=true;
     volslide[cur_channel]:=param;
 end;

 //volume slide
 if effect = 10 then
 begin
     volslidebool[cur_channel]:=true;
     volslide[cur_channel]:=param;
     chan_teller.caption:=IntToStr(volslide[cur_channel]);
 end;

 ModChan[cur_channel].Update;

end;


  //feedback on form
 NowPlaying.Caption:='Now: '+ IntToStr(sel_track)+ ' ' +
 'Sample('+IntToStr(Patterns[sel_track]^[current_pos])+
 ')Note('+IntToStr(Patterns[sel_track]^[current_pos+1])+
 ')Effect('+GetEffect(Patterns[sel_track]^[current_pos+2])+
 ')Param('+IntToStr(Patterns[sel_track]^[current_pos+3])+
 ')';

 NP2.Caption:='Now: '+
 'Sample('+IntToStr(Patterns[sel_track]^[current_pos+4])+
 ')Note('+IntToStr(Patterns[sel_track]^[current_pos+5])+
 ')Effect('+GetEffect(Patterns[sel_track]^[current_pos+6])+
 ')Param('+IntToStr(Patterns[sel_track]^[current_pos+7])+
 ')';

  NP3.Caption:='Now: '+
 'Sample('+IntToStr(Patterns[sel_track]^[current_pos+8])+
 ')Note('+IntToStr(Patterns[sel_track]^[current_pos+9])+
 ')Effect('+GetEffect(Patterns[sel_track]^[current_pos+10])+
 ')Param('+IntToStr(Patterns[sel_track]^[current_pos+11])+
 ')';

  NP4.Caption:='Now: '+
 'Sample('+IntToStr(Patterns[sel_track]^[current_pos+12])+
 ')Note('+IntToStr(Patterns[sel_track]^[current_pos+13])+
 ')Effect('+GetEffect(Patterns[sel_track]^[current_pos+14])+
 ')Param('+IntToStr(Patterns[sel_track]^[current_pos+15])+
 ')';

 //advance mod to next position in pattern data
 current_pos:=current_pos+4*channels;
 if current_pos > (64*(4*channels))-1 then
 begin
        current_pattern:=current_pattern+1;
        if current_pattern >= TrackOrderList.Items.Count then current_pattern:=0;
        current_pos:=0;
        sel_track:=StrToInt(TrackOrderList.Items[current_pattern]);
 end;
 ticks:=0;
end
else
begin

 //update effects... inbetween the actual pattern data
 for cur_channel:=0 to channels-1 do
 begin
  if volslide[cur_channel]<>-1 then
  begin
   param:=volslide[cur_channel];
   Chan_Teller_Effect.Caption:=IntToStr(param);
   cur_volume:=ModChan[cur_channel].Gain;
   if param shr 4>0 then
   begin
     ModChan[cur_channel].gain:=cur_volume+{chan_volume[cur_channel]+}((param shr 4)/40);
     chan_volume[cur_channel]:=chan_volume[cur_channel]+((param shr 4));
     volume.caption:=''+floattostr((param shr 4)/40);
   end;
   if param and 15>0 then
    begin
     ModChan[cur_channel].gain:=cur_volume-{chan_volume[cur_channel]-}((param and 15)/40);
     chan_volume[cur_channel]:=chan_volume[cur_channel]-((param and 15));
     volume.caption:=''+floattostr((param and 15)/40);
    end;
  param:=0;
 end;

 cur_sample:=cs[cur_channel];

 //porta up
 if portaup[cur_channel]>0 then
 begin
  if Period_Table[portaup[cur_channel]] > 0 then ModChan[cur_channel].samplerate:=Round({ModChan[cur_channel].buffer.initsamplerate-}(7159090.5 / (Period_Table[portaup[cur_channel]]*2)));
 end; //end set porta up

 //porta down
 if portadown[cur_channel]>0 then
 begin
  if Period_Table[portadown[cur_channel]] >0 then ModChan[cur_channel].samplerate:=Round({ModChan[cur_channel].buffer.initsamplerate-}(7159090.5 / (Period_Table[portadown[cur_channel]]*2)));
 end; // end set porta down

 //arpegio
 if arp[cur_channel]>0 then
 begin
  if Period_Table[arp_note[cur_channel]] > 0 then arpfreq:=7159090.5 / ((Period_Table[arp_note[cur_channel]])*2);

  arpcounter:=arpcounter+1;
  if arpcounter =1 then if Period_Table[arp[cur_channel] shr 4]>0 then arpfreq:=arpfreq+(7159090.5 / ((Period_Table[arp[cur_channel] shr 4])*2));
  if arpcounter =2 then if Period_Table[arp[cur_channel] and 15]>0 then arpfreq:=arpfreq+(7159090.5 / ((Period_Table[arp[cur_channel] and 15])*2));
  if arpcounter =2 then arpcounter:=0;

  modchan[cur_channel].samplerate:=Round(arpfreq);
 end; //end arp

 if  eff_tick[cur_channel]>=Sample_Size[cur_sample]then eff_tick[cur_channel]:=0;

 ModChan[cur_channel].Update;

 end;

end;

ticks:=ticks+1;
for cur_channel:=0 to 7 do
eff_tick[cur_channel]:=eff_tick[cur_channel]+1;
end;

procedure TForm1.PlaySongButtonClick(Sender: TObject);
var
        teller: integer;
        t: integer;
begin

current_pos:=0;
current_pattern:=0;
sel_track:=StrToInt(TrackOrderList.Items[current_pattern]);

//how to convert from hz to ms?
timer.Caption:='timer1: '+IntToStr(1000 div ((125 shl 1) div 5))+'ms';
ThreadedTimer1.Interval:=1000 div ((125 shl 1) div 5);
ThreadedTimer1.Enabled:=True; //start playing

end;

procedure TForm1.stopsongbuttonClick(Sender: TObject);
begin
  ThreadedTimer1.Enabled:=False; //stop playing
end;

end.





