program fpcopenaldemo;

//compile with fpc -Sd fpcopenaldemo.pas

uses openal;

var
  buffer : TALuint;
  source : TALuint;
  sourcepos: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0 );
  sourcevel: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0 );
  listenerpos: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0);
  listenervel: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0);
  listenerori: array [0..5] of TALfloat= ( 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
  Context: PALCcontext;
  Device: PALCdevice;

  data : Array[0..1000] OF Byte;
  loop : Integer;

begin
  writeln('hello world!');

  //init openal library
  if InitOpenAL('libopenal.so') then
    writeln('OpenAl lib found')
  else
    begin
      writeln('Oops OpenAL not found')
      //halt;
    end;

  //Open (selected) device
  Device := alcOpenDevice(nil); // this is supposed to select the "preferred device"

  writeln('Open Device');

  //Create context(s)
  Context := alcCreateContext(Device,nil);

  //Set active context
  alcMakeContextCurrent(Context);

  //Clear Error Code
  //alGetError();

  writeln('init done');

  //Create Buffers
  AlGenBuffers(1, @buffer);
  For Loop:=0 to 1000 do
    data[loop] := Round(50*sin(loop*(5*pi)/50.0)+128);
  alBufferData(buffer, AL_FORMAT_MONO8, @data, 1001, 11024);

  //Create Sources
  AlGenSources(1, @source);
  AlSourcei ( source, AL_BUFFER, buffer);
  AlSourcef ( source, AL_PITCH, 1.0 );
  AlSourcef ( source, AL_GAIN, 1.0 );
  AlSourcefv ( source, AL_POSITION, @sourcepos);
  AlSourcefv ( source, AL_VELOCITY, @sourcevel);
  AlSourcei ( source, AL_LOOPING, AL_TRUE);

  //Create Listener
  AlListenerfv ( AL_POSITION, @listenerpos);
  AlListenerfv ( AL_VELOCITY, @listenervel);
  AlListenerfv ( AL_ORIENTATION, @listenerori);

  //start playing sound
  AlSourcePlay(source);

  //wait
  Writeln('Press [ENTER] to stop playing sound');
  Readln;

  //stop playing sound
  AlSourceStop(source);

  //exit
  AlDeleteBuffers(1, @buffer);
  AlDeleteSources(1, @source);

  //Free Context and Device

  //Get active context
  Context:=alcGetCurrentContext();
  //Get device for active context
  Device:=alcGetContextsDevice(Context);
  //Release context(s)
  alcDestroyContext(Context);
  //Close device
  alcCloseDevice(Device);

end.
