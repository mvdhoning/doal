unit oooal;

interface

uses al, altypes, alut, sysutils;

type
        TAlObject = class
        private
          _pos: array [0..2] of TALFloat;
          _vel: array [0..2] of TALFloat;
          _buffer: TALuint;
          _source: TALuint;
          _pitch: TALFloat;
          _gain: TALFloat;
          _loop: TALInt;
          _playing: boolean;
        protected
        public
          constructor Create;
          destructor Destroy; override;
          procedure LoadFromFile(filename: string);
          procedure Update;
          procedure Play;
          procedure Pause;
          procedure Stop;
          property xpos: TALFloat read _pos[0] write _pos[0];
          property ypos: TALFloat read _pos[1] write _pos[1];
          property zpos: TALFloat read _pos[2] write _pos[2];
          property xvel: TALFloat read _vel[0] write _vel[0];
          property yvel: TALFloat read _vel[1] write _vel[1];
          property zvel: TALFloat read _vel[2] write _vel[2];
          property pitch: TALFloat read _pitch write _pitch;
          property gain: TALFloat read _gain write _gain;
          property loop: TALInt read _loop write _loop;
          property playing: boolean read _playing write _playing;
        end;

implementation

constructor TalObject.Create;
begin
  // create a buffer
  AlGenBuffers(1, @_buffer);
  if alGetError <> AL_NO_ERROR then raise Exception.Create('Cannot create Buffer');
  // create a source
  AlGenSources(1, @_source);
  if alGetError <> AL_NO_ERROR then raise Exception.Create('Cannot create Source');
  // set default values
  gain := 1.0;
  pitch := 1.0;
  xpos := 0.0;
  ypos := 0.0;
  zpos := 0.0;
  xvel := 0.0;
  yvel := 0.0;
  zvel := 0.0;
end;

destructor TalObject.Destroy;
begin
  //for the lazy among us
  if _playing then stop;

  //first delete the source
  AlDeleteSources(1, @_source);
  if alGetError <> AL_NO_ERROR then raise Exception.Create('Cannot delete Source');

  //then delete the buffer
  AlDeleteBuffers(1, @_buffer);
  if alGetError <> AL_NO_ERROR then raise Exception.Create('Cannot delete Buffer');

  inherited destroy;
end;

procedure TalObject.LoadFromFile(filename: string);
var
  format: TALEnum;
  size: TALSizei;
  freq: TALSizei;
  floop: TALInt;
  data: TALVoid;

begin
  //load the wavedata from the file
  AlutLoadWavFile(filename, format, data, size, freq, floop);
  //assign the wavedata to the buffer
  AlBufferData(_buffer, format, data, size, freq);
  if alGetError <> AL_NO_ERROR then raise Exception.Create('Cannot assign wave data to buffer');
  //remove the wavedata from memory
  AlutUnloadWav(format, data, size, freq);
  loop := floop;
  //assign the buffer to the source
  AlSourcei ( _source, AL_BUFFER, _buffer);
end;

Procedure TalObject.Update;
begin
 //pass the 'changed' values on to openal
 AlSourcef ( _source, AL_PITCH, _pitch );
 AlSourcef ( _source, AL_GAIN, _gain );
 AlSourcefv ( _source, AL_POSITION, @_pos);
 AlSourcefv ( _source, AL_VELOCITY, @_vel);
 AlSourcei ( _source, AL_LOOPING, _loop);
end;

Procedure TalObject.Play;
begin
  AlSourcePlay(_source);
  Update;
  playing:=true;
end;

Procedure TalObject.Stop;
begin
  playing:=false;
  AlSourceStop(_source);
end;

Procedure TalObject.Pause;
begin
  AlSourcePause(_source);
end;

end.
