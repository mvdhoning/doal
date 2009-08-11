unit EFXutil;

interface

uses OpenAL;

const
  cefxutillibname='efx-util.dll';

type
  _EAXVECTOR= packed record
	  x: single;
	  y: single;
	  z: single;
  end;
  EAXVector= _EAXVECTOR;

  _EAXREVERBPROPERTIES = packed record
    ulEnvironment: Cardinal;
    flEnvironmentSize: single;
    flEnvironmentDiffusion: single;
    lRoom: longint;
    lRoomHF: longint;
    lRoomLF: longint;
    flDecayTime: single;
    flDecayHFRatio: single;
    flDecayLFRatio: single;
    lReflections: longint;
    flReflectionsDelay: single;
    vReflectionsPan: EAXVECTOR;
    lReverb: longint;
    flReverbDelay: single;
    vReverbPan: EAXVECTOR;
    flEchoTime: single;
    flEchoDepth: single;
    flModulationTime: single;
    flModulationDepth: single;
    flAirAbsorptionHF: single;
    flHFReference: single;
    flLFReference: single;
    flRoomRolloffFactor: single;
    ulFlags: Cardinal;
    end;
  EAXREVERBPROPERTIES = _EAXREVERBPROPERTIES;
  PEAXREVERBPROPERTIES = ^EAXREVERBPROPERTIES;

  _EAXOBSTRUCTIONPROPERTIES = packed record
    lObstruction: longint;
    flObstructionLFRatio: single;
  end;
  EAXOBSTRUCTIONPROPERTIES = _EAXOBSTRUCTIONPROPERTIES;
  PEAXOBSTRUCTIONPROPERTIES = ^_EAXOBSTRUCTIONPROPERTIES;

  _EAXOCCLUSIONPROPERTIES = packed record
    lOcclusion: longint;
    flOcclusionLFRatio: single;
    flOcclusionRoomRatio: single;
    flOcclusionDirectRatio: single;
  end;
  EAXOCCLUSIONPROPERTIES = _EAXOCCLUSIONPROPERTIES;
  PEAXOCCLUSIONPROPERTIES = ^_EAXOCCLUSIONPROPERTIES;

  _EAXEXCLUSIONPROPERTIES = packed record
    lExclusion: longint;
    flExclusionLFRatio: single;
  end;
  EAXEXCLUSIONPROPERTIES = _EAXEXCLUSIONPROPERTIES;
  PEAXEXCLUSIONPROPERTIES = ^_EAXEXCLUSIONPROPERTIES;

var
  //EFX-util functions (not yet availble due to .lib file)
  ConvertReverbParameters: procedure(pEAXProp: PEAXREVERBPROPERTIES; pEFXEAXReverb: PEFXEAXREVERBPROPERTIES); cdecl;
  ConvertObstructionParameters: procedure(pObProp: PEAXOBSTRUCTIONPROPERTIES; pDirectLowPassFilter: PEFXLOWPASSFILTER); cdecl;
  ConvertExclusionParameters: procedure(pExProp: PEAXEXCLUSIONPROPERTIES; pSendLowPassFilter: PEFXLOWPASSFILTER); cdecl;
  ConvertOcclusionParameters: procedure(pOcProp: PEAXOCCLUSIONPROPERTIES; pDirectLowPassFilter: PEFXLOWPASSFILTER; pSendLowPassFilter: PEFXLOWPASSFILTER); cdecl;

  //EAX Reverb Presets in legacy format - use ConvertReverbParameters() to convert to
  //EFX EAX Reverb Presets for use with the OpenAL Effects Extension.
  //Not converted to avoid clutter will be available in eaxreverbpresets.pas

procedure ReadOpenALEFXUtil;

implementation

uses sysutils, windows;

procedure ReadOpenALEFXUtil;
begin
  if EFXUtilLibHandle<>0 then FreeLibrary(EFXUtilLibHandle);
  EFXUtilLibHandle    := LoadLibrary(PChar(CEFXUtilLibName));

  if (EFXUtilLibHandle <> 0) then
  begin
    ConvertReverbParameters := GetProcAddress(EFXUtilLibHandle, 'ConvertReverbParameters');
    ConvertObstructionParameters := GetProcAddress(EFXUtilLibHandle, 'ConvertObstructionParameters');
    ConvertExclusionParameters := GetProcAddress(EFXUtilLibHandle, 'ConvertExclusionParameters');
    ConvertOcclusionParameters := GetProcAddress(EFXUtilLibHandle, 'ConvertOcclusionParameters');
  end;
end;

end.
