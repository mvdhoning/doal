unit oooal;

interface

uses al, altypes, alut, sysutils, classes;

type
        TAlBuffer = class
        private
          _buffer: TALuint;
          _format: TALenum;
          _size: TAlSizei;
          _initsamplerate: TALSizei;
          _loop: TALInt;
        protected
        public
          constructor Create; //create sound buffer
          destructor Destroy; override; //destroy sound buffer
          property buffer: TALuInt read _buffer; //get the buffer id
          property format: TAlEnum read _format write _format; //the format of the buffer
          property size: TAlSizei read _size write _size; //the size of the buffer
          property initsamplerate: TALSizei read _initsamplerate write _initsamplerate; //sets the initial sample rate (used by set newsamplerate)
          property loop: TALInt read _loop write _loop; //is the sound object looped?
          procedure LoadFromFile(filename: string); //loads sample data from a wav file
          procedure LoadFromStream(stream: tmemorystream); //loads sample data from a stream
          procedure LoadFromPointer(data: pointer); //loads sample data from a pointer
        end;

        TAlSource = class
        private
          _source: TALuint;
        protected
        public
          constructor Create; //create sound source
          destructor Destroy; override; //destroy sound source
          property source: TALuInt read _source; //get the source id
          procedure AssignBuffer(value: TALuint); //assign a buffer to a source
        end;

        TAlObject = class
        private
          _pos: array [0..2] of TALFloat;
          _vel: array [0..2] of TALFloat;
          _buffer: TAlBuffer;
          _source: TAlSource;
          _pitch: TALFloat;
          _samplerate: TALSizei;
          _gain: TALFloat;
          _playing: boolean;
          _name: string;
          _id: TAlInt;
          procedure SetNewSampleRate(Value: TAlSizei);
        protected
        public
          constructor Create; //create sound object
          destructor Destroy; override; //destroy sound object
          procedure Update; //passes changes in object to openal
          procedure Play; //tells openal to play the sound object
          procedure Pause; //tells openal to pause the sound object
          procedure Stop;  //tells openal to stop the sound object
          property xpos: TALFloat read _pos[0] write _pos[0]; //position in 3d space
          property ypos: TALFloat read _pos[1] write _pos[1]; //position in 3d space
          property zpos: TALFloat read _pos[2] write _pos[2]; //position in 3d space
          property xvel: TALFloat read _vel[0] write _vel[0]; //movement
          property yvel: TALFloat read _vel[1] write _vel[1]; //movement
          property zvel: TALFloat read _vel[2] write _vel[2]; //movement
          property pitch: TALFloat read _pitch write _pitch; //make the sound object play higher or lower
          property samplerate: TALSizei read _samplerate write SetNewSampleRate; //sets a new sample rate (does so by changing pitch)
          property gain: TALFloat read _gain write _gain; //the volume at what the sound object is played
          property playing: boolean read _playing write _playing; //is the sound object currently playing?
          property name: string read _name write _name; //the name of the sound object
          property id: TALInt read _id write _id; //an id for the sound object?
          property buffer: TAlBuffer read _buffer write _buffer;
          property source: TAlSource read _source write _source;
        end;

implementation

constructor TalBuffer.Create;
begin
  alGetError; //clear any previous error
  // create a buffer
  AlGenBuffers(1, @_buffer);
  if alGetError <> AL_NO_ERROR then raise Exception.Create('Cannot create Buffer');
end;

destructor TalBuffer.Destroy;
begin
  alGetError; //clear error
  //delete the buffer
  AlDeleteBuffers(1, @_buffer);
  if alGetError <> AL_NO_ERROR then raise Exception.Create('Cannot delete Buffer');
end;

procedure TalBuffer.LoadFromFile(filename: string);
var
  data: TALVoid;

begin
  alGetError; //clear any previous error
  //load the wavedata from the file
  AlutLoadWavFile(filename, _format, data, _size, _initsamplerate, _loop);
  //assign the wavedata to the buffer
  AlBufferData(_buffer, _format, data, _size, _initsamplerate);
  if alGetError <> AL_NO_ERROR then raise Exception.Create('Cannot assign wave data to buffer');
  //remove the wavedata from memory
  AlutUnloadWav(_format, data, _size, _initsamplerate);
end;

procedure TalBuffer.LoadFromStream(stream: tmemorystream);
var
  data: TALVoid;

begin
  alGetError; //clear any previous error
  //load the wavedata from the file
  AlutLoadWavStream(stream, _format, data, _size, _initsamplerate, _loop);
  //assign the wavedata to the buffer
  AlBufferData(_buffer, _format, data, _size, _initsamplerate);
  if alGetError <> AL_NO_ERROR then raise Exception.Create('Cannot assign wave data to buffer');
  //remove the wavedata from memory
  AlutUnloadWav(_format, data, _size, _initsamplerate);
end;

procedure TalBuffer.LoadFromPointer(data: pointer);
begin
  alGetError; //clear any previous error
  //assign the wavedata to the buffer
  AlBufferData(_buffer, _format, data, _size, _initsamplerate);
  if alGetError <> AL_NO_ERROR then raise Exception.Create('Cannot assign wave data to buffer');
end;

constructor TalSource.Create;
begin
  alGetError; //clear any previous error
  //create a source
  AlGenSources(1, @_source);
  if alGetError <> AL_NO_ERROR then raise Exception.Create('Cannot create Source');
end;

destructor TalSource.Destroy;
begin
  alGetError; //clear any previous error
  //delete the source
  AlDeleteSources(1, @_source);
  if alGetError <> AL_NO_ERROR then raise Exception.Create('Cannot delete Source');
end;

procedure TalSource.AssignBuffer(value: TALuint);
begin
  //assign the buffer to the source
  AlSourcei ( _source, AL_BUFFER, value);
end;

constructor TalObject.Create;
begin

  _buffer:=TAlBuffer.Create;
  _source:=TALSource.Create;

  // set default values
  gain := 1.0;
  pitch := 1.0;
  xpos := 0.0;
  ypos := 0.0;
  zpos := 0.0;
  xvel := 0.0;
  yvel := 0.0;
  zvel := 0.0;
  _buffer.loop := AL_FALSE;

  playing := false;
  _buffer.initsamplerate:=44800;

end;

destructor TalObject.Destroy;
begin
  //for the lazy among us
  if _playing then stop;

  alSourceUnqueueBuffers(_source.source, 1, @_buffer.buffer);

  //deassign the buffer from the source (solves a potential memory leak)
  AlSourcei ( _source.source, AL_BUFFER, 0);

  if _buffer <> nil then _buffer.Free;
  if _source <> nil then _source.Free;

  inherited destroy;
end;

Procedure TalObject.SetNewSamplerate(Value: TAlSizeI);
begin
_samplerate:=Value;
_pitch:=Value / _buffer.initsamplerate;
end;

Procedure TalObject.Update;
var
        processed: integer;
begin
 //pass the 'changed' values on to openal
 AlSourcef ( _source.source, AL_PITCH, _pitch );
 AlSourcef ( _source.source, AL_GAIN, _gain );
 AlSourcefv ( _source.source, AL_POSITION, @_pos);
 AlSourcefv ( _source.source, AL_VELOCITY, @_vel);
 AlSourcei ( _source.source, AL_LOOPING, _buffer.loop);

end;

Procedure TalObject.Play;
begin
  AlSourcePlay(_source.source);
  playing:=true;
end;

Procedure TalObject.Stop;
begin
  playing:=false;
  AlSourceStop(_source.source);
end;

Procedure TalObject.Pause;
begin
  AlSourcePause(_source.source);
end;

end.
