unit loadmod;

interface

Type TSample = Array[0..65528] of {ShortInt}Byte;       { One sample }
     TPattern = Array[0..2047] of {ShortInt}Byte;          { One pattern (8 channels) }
Type PSample = ^TSample;

Const
      Note_Size    = 4;                         { Note = smp_nr,eff_nr etc }
      Period_Table: Array[0..(12*3*16)] of Word =
      { Tuning 0, Normal }
      (0,856,808,762,720,678,640,604,570,538,508,480,453, { C-1 to B-1 }
       428,404,381,360,339,320,302,285,269,254,240,226,   { C-2 to B-2 }
       214,202,190,180,170,160,151,143,135,127,120,113,   { C-3 to B-3 }
      { Tuning 1 }
       850,802,757,715,674,637,601,567,535,505,477,450,   { Same as above }
       425,401,379,357,337,318,300,284,268,253,239,225,   { but with }
       213,201,189,179,169,159,150,142,134,126,119,113,   { finetune +1 }
      { Tuning 2 }
       844,796,752,709,670,632,597,563,532,502,474,447,
       422,398,376,355,335,316,298,282,266,251,237,224,
       211,199,188,177,167,158,149,141,133,125,118,112,
      { Tuning 3 }
       838,791,746,704,665,628,592,559,528,498,470,444,
       419,395,373,352,332,314,296,280,264,249,235,222,
       209,198,187,176,166,157,148,140,132,125,118,111,
      { Tuning 4 }
       832,785,741,699,660,623,588,555,524,495,467,441,
       416,392,370,350,330,312,294,278,262,247,233,220,
       208,196,185,175,165,156,147,139,131,124,117,110,
      { Tuning 5 }
       826,779,736,694,655,619,584,551,520,491,463,437,
       413,390,368,347,328,309,292,276,260,245,232,219,
       206,195,184,174,164,155,146,138,130,123,116,109,
      { Tuning 6 }
       820,774,730,689,651,614,580,547,516,487,460,434,
       410,387,365,345,325,307,290,274,258,244,230,217,
       205,193,183,172,163,154,145,137,129,122,115,109,
      { Tuning 7 }
       814,768,725,684,646,610,575,543,513,484,457,431,
       407,384,363,342,323,305,288,272,256,242,228,216,
       204,192,181,171,161,152,144,136,128,121,114,108,
      { Tuning -8 }
       907,856,808,762,720,678,640,604,570,538,508,480,
       453,428,404,381,360,339,320,302,285,269,254,240,
       226,214,202,190,180,170,160,151,143,135,127,120,
      { Tuning -7 }
       900,850,802,757,715,675,636,601,567,535,505,477,
       450,425,401,379,357,337,318,300,284,268,253,238,
       225,212,200,189,179,169,159,150,142,134,126,119,
      { Tuning -6 }
       894,844,796,752,709,670,632,597,563,532,502,474,
       447,422,398,376,355,335,316,298,282,266,251,237,
       223,211,199,188,177,167,158,149,141,133,125,118,
      { Tuning -5 }
       887,838,791,746,704,665,628,592,559,528,498,470,
       444,419,395,373,352,332,314,296,280,264,249,235,
       222,209,198,187,176,166,157,148,140,132,125,118,
      { Tuning -4 }
       881,832,785,741,699,660,623,588,555,524,494,467,
       441,416,392,370,350,330,312,294,278,262,247,233,
       220,208,196,185,175,165,156,147,139,131,123,117,
      { Tuning -3 }
       875,826,779,736,694,655,619,584,551,520,491,463,
       437,413,390,368,347,328,309,292,276,260,245,232,
       219,206,195,184,174,164,155,146,138,130,123,116,
      { Tuning -2 }
       868,820,774,730,689,651,614,580,547,516,487,460,
       434,410,387,365,345,325,307,290,274,258,244,230,
       217,205,193,183,172,163,154,145,137,129,122,115,
      { Tuning -1 }
       862,814,768,725,684,646,610,575,543,513,484,457,
       431,407,384,363,342,323,305,288,272,256,242,228,
       216,203,192,181,171,161,152,144,136,128,121,114);

       Sine_Table: Array[1..32] of Byte =        { Sine table for Vibrato/Tremor }
      (0, 24, 49, 74, 97,120,141,161,
       180,197,212,224,235,244,250,253,
       255,253,250,244,235,224,212,197,
       180,161,141,120, 97, 74, 49, 24);


Var F: File;
    Module_Header: Array[0..1083] of Byte;   { Total module header }
    Module_Name: String[20];                 { Name of mod }
    Module_Type: String[4];                  { Module type }
    Channels: Byte;                          { # of channels }
    Song_Length: Byte;                       { Total # of patterns }
    Number_Of_Samples: Byte;
    Number_Of_Patterns: Byte;                { # of physical patterns }
    Order: Array[0..127] of Byte;            { Order to play patterns }
    Patterns       : Array[0..255] of ^TPattern; { Pattern data }
    Modfile: String;                         { Physical file (path/name) }
    Mod_Loaded: Boolean;                     { True if .mod was loaded }
    Key: Char;                               { For intercepting a keypress }
    Pattern_Size       : Word;                  { Size of 1 pattern }
    Track_Size         : Byte;                  { Size of 1 track }

    Sample_Data: Array[1..31] of ^TSample;    { Pointers to actual sample data }
    Sample_Size: Array[1..31] of Word;       { Samples sizes }
    Sample_Name: Array[1..31] of String[22]; { Names of samples }
    Sample_Loopstart: Array[1..31] of Word;  { Loop start of samples }
    Sample_Looplength: Array[1..31] of Word; { Loop length of samples }
    Sample_Volume: Array[1..31] of Byte;     { Volume of samples }
    Sample_Ftune: Array[1..31] of Shortint;  { Finetune of samples }

    Procedure Load_Module(Module: String);   { Loads a .mod into memory }
    Procedure Free_Module;                   { Frees a .mod from memory }

implementation

Uses SysUtils;                               { Used units }

Function ConvertAmigaWord(w: Word): Word; Assembler;  { Converts Amiga word }
Asm
  mov ax,w
  xchg ah,al
End;

(* Procedure Error(Exit_String: String);             { Quit on error }
Begin
  Writeln(Exit_String);
  Close(F);
  Halt(1);
End; *)

Procedure Get_Sample_Info;                        { Gets sample info }
Var Loop1,Offset: Word;
    S_Name: String[22];
    S_Length: Word;
    F_Tune: Shortint;
    Volume: Byte;
    L_Start: Word;
    L_Length: Word;
Begin
  Offset := 20;                                   { Point to sample 1 }
  For Loop1 := 1 to number_of_samples do
  Begin
    S_Name[0] := #22;
    Move(Module_Header[Offset],S_Name[1], 22);    { Get sample name }
    Move(Module_Header[Offset+22],S_Length,2);
    S_Length := ConvertAmigaWord(S_Length) shl 1;     { Get sample length }
    Move(Module_Header[Offset+24],F_Tune,1);      { Get fine tune }
    If F_Tune > 7 then Dec(F_Tune,16);
    Move(Module_Header[Offset+25],Volume,1);      { Get sample volume }
    Move(Module_Header[Offset+26],L_Start,2);
    L_Start := ConvertAmigaWord(L_Start) shl 1;       { Get loop start }
    Move(Module_Header[Offset+28],L_Length,2);
    L_Length := ConvertAmigaWord(L_Length) shl 1;     { Get loop length }

    Sample_Size[Loop1] := S_Length;               { Store in arrays }
    Sample_Name[Loop1] := S_Name;
    Sample_Loopstart[Loop1] := L_Start;
    Sample_Looplength[Loop1] := L_Length;
    Sample_Volume[Loop1] := Volume;
    Sample_Ftune[Loop1] := F_Tune;

    Inc(Offset,30);                               { Point to next sample }
  End;
End;

Procedure Get_Patterns;
Var Loop1,Loop2: Word;
    Pat_Pos,Temp, Counter: Word;
    Note: Array[1..4] of Byte;
Begin
  For Loop1 := 0 to Number_Of_Patterns Do       { Get all patterns }
  Begin
//    If MaxAvail < Pattern_Size then Error('Not enough free memory to load patterns!');
    Getmem(Patterns[Loop1],Pattern_Size);       { Setup memory }
    Fillchar(Patterns[Loop1]^,Pattern_Size,0);  { Clear memory }

    Pat_Pos := 0;
    For Loop2 := 1 to 64*Channels do            { Process entire pattern }
    Begin
      Blockread(F,Note[1],4);                   { Read a note (4 bytes) }
      {sample nr}
      Patterns[Loop1]^[Pat_Pos] := (Note[1] and 240) + (Note[3] shr 4);
      {note value}
      Temp := ((Note[1] and 15) shl 8) + Note[2];
      If Temp <> 0 then                         { Convert to note number }
      Begin
        Counter := 1;
        While (Temp <> Period_Table[Counter]) do
        begin
        If counter > 128 then break;
        Inc(Counter);
        end;
{        If Counter < 12*3*16 then} Patterns[Loop1]^[Pat_Pos+1] := Counter;
      End;
      {effect nr}
      Patterns[Loop1]^[Pat_Pos+2] := Note[3] and 15;
      {effect parameter}
      Patterns[Loop1]^[Pat_Pos+3] := Note[4];
      Inc(Pat_Pos,4);                           { Increase pointer }
    End;
  End;
End;

Procedure Get_Samples;
Var Loop1,Loop2: {Word}Integer;
    P: Pointer;
Begin
  For Loop1 := 1 to number_of_samples Do                         { Get actual samples }
  Begin
    If Sample_Size[Loop1] > 0 then                { Only if data exists }
    Begin
      Getmem(P,Sample_Size[Loop1]);               { Read and convert sample }
      Blockread(F, P^, Sample_Size[Loop1]);
      For Loop2 := 0 to Sample_Size[Loop1] do
       begin
        //Inc(Sample(P^)[Loop2],128); { Add 128 to every byte! }
        TSample(P^)[Loop2]:=(TSample(P^)[Loop2]+128){shl 8};
       end;
      Sample_Data[Loop1] := P;                    { Store the pointer }
    End;
  End;
End;

Procedure Load_Module(Module: String);            { Loads a .mod into memory }
Var Loop1: Byte;
Begin
  If not (FileExists(Module)) then                 { File does not exist? }
  Begin
    Writeln('File does not exist!');
    Halt(1);                                      { Then quit }
  End;

  Modfile := Module;
  Assign(F, Module);                              { Else open file }
  Filemode:=0;
  Reset(F,1);
  Blockread(F, Module_Header, 1084);              { Read entire header }

  Module_Name[0] := #20;
  Move(Module_Header[0],Module_Name[1],20);       { Store module name }

  Move(Module_Header[950],Song_length,1);         { Store # of different patterns }
  Move(Module_Header[952],Order[0],128);          { Store playing order }
  Number_Of_Patterns := 0;
  //For Loop1 := 0 to 127 do                        { Store total # of patterns to play }
  //   If (Order[Loop1] > Number_Of_Patterns) then Number_Of_Patterns := Loop1;

  For Loop1 := 0 to 127 do                        { Store total # of patterns to play }
    If (Order[Loop1] > Number_Of_Patterns) then Number_Of_Patterns := Order[Loop1];


  Channels:=4;
  Number_Of_Samples:=16;

  Module_Type[0] := #4;
  Move(Module_Header[1080],Module_Type[1],4);     { Store module type }
  If (Module_Type = 'M.K.') or
     (Module_Type = 'FLT4') or
     (Module_Type = 'M!K!') or
     (Module_Type = '4CHN') then
     Begin
     Channels := 4;    { Set # of channels }
     Number_Of_Samples:=31;
     End;
  If (Module_Type = '6CHN') then
     Begin
     Channels := 6;
     Number_Of_Samples:=31;
     End;
  If (Module_Type = 'FLT8') or
     (Module_Type = '8CHN') then
     Begin
     Channels := 8;
     Number_Of_Samples:=31;
     End;
  //else Error('Unsupported file format!');



  Get_Sample_Info;                                { Store sample information }

  Track_Size := Note_Size * Channels;
  Pattern_Size := Track_Size * 64 *4 ;

  Get_Patterns;                                   { Store pattern data }
  Get_Samples;                                    { Store the actual samples }

  Mod_Loaded := True;                             { Memory allocated }
  Close(F);
End;

Procedure Free_Module;                            { Free memory used by .mod }
Var Loop1: Word;
Begin
  For Loop1 := 0 to Number_Of_Patterns Do Freemem(Patterns[Loop1],1024);
  For Loop1 := 1 to 31 Do If Sample_Size[Loop1] > 0 then Freemem(Sample_Data[Loop1],Sample_Size[Loop1]);
  Mod_Loaded := False;                            { Module unloaded }
End;

Procedure Show_Mod_Info;
Var Loop1: Byte;
Begin
  Write('Module name       : '); Writeln(Module_Name:20);
  Write('Filename          : '); Writeln(Modfile);
  Write('Module type       : '); Writeln(Module_Type);
  Write('Channels          : '); Writeln(Channels);
  Write('Patterns to play  : '); Writeln(Song_Length);
  Write('Physical patterns : '); Writeln(Number_of_Patterns);
  Writeln;
  Write('Playing order: ');
  For Loop1 := 0 to Song_Length-1 do
  Begin
    Write(Order[Loop1]);
    If Loop1 < Song_Length then Write(',');
  End;
  Writeln;
  Writeln;
  Write('Press ENTER to exit...');
End;

end.
