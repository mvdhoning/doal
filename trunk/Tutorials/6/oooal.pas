unit oooal;

interface

uses OpenAL, sysutils;

type
        TAlObject = class
        private
          fpos: array [0..2] of TALFloat;
          fvel: array [0..2] of TALFloat;
          fbuffer: TALuint;
          fsource: TALuint;
          fpitch: TALFloat;
          fgain: TALFloat;
          floop: TALInt;
          fplaying: boolean;
        protected
        public
          constructor Create;
          destructor Destroy; override;
          procedure LoadFromFile(filename: string);
          procedure Update;
          procedure Play;
          procedure Pause;
          procedure Stop;
          property xpos: TALFloat read fpos[0] write fpos[0];
          property ypos: TALFloat read fpos[1] write fpos[1];
          property zpos: TALFloat read fpos[2] write fpos[2];
          property xvel: TALFloat read fvel[0] write fvel[0];
          property yvel: TALFloat read fvel[1] write fvel[1];
          property zvel: TALFloat read fvel[2] write fvel[2];
          property pitch: TALFloat read fpitch write fpitch;
          property gain: TALFloat read fgain write fgain;
          property loop: TALInt read floop write floop;
          property playing: boolean read fplaying write fplaying;
        end;

implementation

constructor TalObject.Create;
begin
  // create a buffer
  AlGenBuffers(1, @fbuffer);
  if alGetError <> AL_NO_ERROR then raise Exception.Create('Cannot create Buffer');
  // create a source
  AlGenSources(1, @fsource);
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
  if fplaying then stop;

  //first delete the source
  AlDeleteSources(1, @fsource);
  if alGetError <> AL_NO_ERROR then raise Exception.Create('Cannot delete Source');

  //then delete the buffer
  AlDeleteBuffers(1, @fbuffer);
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
  AlBufferData(fbuffer, format, data, size, freq);
  if alGetError <> AL_NO_ERROR then raise Exception.Create('Cannot assign wave data to buffer');
  //remove the wavedata from memory
  AlutUnloadWav(format, data, size, freq);
  loop := floop;
  //assign the buffer to the source
  AlSourcei ( fsource, AL_BUFFER, fbuffer);
end;

Procedure TalObject.Update;
begin
 //pass the 'changed' values on to openal
 AlSourcef ( fsource, AL_PITCH, fpitch );
 AlSourcef ( fsource, AL_GAIN, fgain );
 AlSourcefv ( fsource, AL_POSITION, @fpos);
 AlSourcefv ( fsource, AL_VELOCITY, @fvel);
 AlSourcei ( fsource, AL_LOOPING, floop);
end;

Procedure TalObject.Play;
begin
  AlSourcePlay(fsource);
  Update;
  playing:=true;
end;

Procedure TalObject.Stop;
begin
  playing:=false;
  AlSourceStop(fsource);
end;

Procedure TalObject.Pause;
begin
  AlSourcePause(fsource);
end;

end.
