unit mp3stream;

interface 

uses 
  Windows, SysUtils, OpenAL, Classes, mpg123;

const
  BufferSize = 4096*8;

type
  TMP3 = class(TThread)
  private
    Buffers   : array[0..1] of TALUInt;
    Source    : TALUInt;
    Format    : TALEnum;
    FFileName : string;
    Fhandle   : Pmpg123_handle;
    Frate     : Integer;
    Fchannels : Integer;
    Fencoding : Integer;
    function initmpg123: Boolean;
    procedure updatebuffer;
    procedure prebuffer;
    procedure Stream(Buffer : TALUInt);
  public
    procedure Play;
    procedure Stop;
    procedure Execute; override;
    constructor Create(const filepath: string);
    destructor Destroy; override;
end;

implementation

{ TMP3 }

constructor TMP3.Create(const filepath: string);
begin
  inherited Create(True);
  FFileName := filepath;
  Priority := tpTimeCritical;
  if FileExists(FFileName) then
    initmpg123;
  Format := AL_FORMAT_STEREO16; //TODO: this should be determined from mp3 file
  alGenBuffers(2, @Buffers);
  alGenSources(1, @Source);
  alSource3f(source, AL_POSITION, 0, 0, 0);
  alSource3f(source, AL_VELOCITY, 0, 0, 0);
  alSource3f(source, AL_DIRECTION, 0, 0, 0);
  alSourcef(source, AL_ROLLOFF_FACTOR, 0);
  alSourcei(source, AL_SOURCE_RELATIVE, AL_TRUE);
end;

destructor TMP3.Destroy;
begin
  alSourceStop(source);
  alDeleteSources(1, @source);
  alDeleteBuffers(1, @Buffers);
  mpg123_close(Fhandle);
  mpg123_exit;
  inherited;
end;

procedure TMP3.Execute;
var
  critical : RTL_CRITICAL_SECTION;
begin
  while not terminated do
  begin
    InitializeCriticalSection(critical);
    EnterCriticalSection(critical);
    updatebuffer;
    LeaveCriticalSection(critical);
    DeleteCriticalSection(critical);
    sleep(50); //TODO: are there better ways to do this?
  end;
end;

function TMP3.initmpg123: Boolean;
begin
  Result := False;
  if mpg123_init <> 0 then Exit;
  Fhandle := mpg123_new('MMX', nil); //TODO: make this a property. MMX is common
  if Fhandle = nil then Exit;
  mpg123_open(Fhandle, PChar(FFileName));
  mpg123_getformat(Fhandle, @Frate, @Fchannels, @Fencoding);
  mpg123_format_none(Fhandle);
  mpg123_format(Fhandle, Frate, Fchannels, Fencoding);
end;

procedure TMP3.prebuffer;
begin
  Stream(Buffers[0]);
  Stream(Buffers[1]);
  alSourceQueueBuffers(Source, 2, @Buffers);
end;

procedure TMP3.Play;
begin
  prebuffer;
  resume;
  alSourcePlay(Source);
end;

procedure TMP3.Stop;
begin
  Suspend;
  alSourceStop(source);
end;

procedure TMP3.Stream(Buffer : TALUInt);
var
  data: PByte;
  d: Cardinal;
begin
  getmem(data, BufferSize);
  mpg123_read(Fhandle, data, BufferSize, @d);
  alBufferData(Buffer, Format, data, BufferSize, FRate);
  freemem(data);
end;

procedure TMP3.UpdateBuffer();
var
 Processed : Integer;
 Buffer    : TALUInt;
begin
  //TODO: detect end of mp3
  alGetSourcei(Source, AL_BUFFERS_PROCESSED, @Processed);
  if Processed > 0 then
    repeat
      alSourceUnqueueBuffers(source, 1, @Buffer);
      Stream(Buffer);
      alSourceQueueBuffers(source, 1, @Buffer);
      dec(Processed);
    until Processed <= 0;
end;

end.

