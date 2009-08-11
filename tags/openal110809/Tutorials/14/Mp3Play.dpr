program Mp3Play;

{$APPTYPE CONSOLE}

uses
  SysUtils, OpenAL, mp3stream;

var
  sourcepos: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0 );
  sourcevel: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0 );
  listenerpos: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0);
  listenervel: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0);
  listenerori: array [0..5] of TALfloat= ( 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
  argv: array of PalByte;
  mp3: TMP3;

begin
  IsMultiThread := True;
  InitOpenAL;
  alutInit(nil,argv);
  AlListenerfv ( AL_POSITION, @listenerpos);
  AlListenerfv ( AL_VELOCITY, @listenervel);
  AlListenerfv ( AL_ORIENTATION, @listenerori);
  mp3 := TMP3.Create('test.mp3');
  mp3.Play;
  sleep(1000 * 60 * 1); //play for x period of time
  mp3.Stop;
  mp3.Free;
  alutExit;
end.
