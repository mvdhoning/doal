{********************************************************************}
{ OpenAL cross platform audio library                                }
{ Copyright (C) 1999-2000 by authors.                                }
{ This library is free software; you can redistribute it and/or      }
{  modify it under the terms of the GNU Library General Public       }
{  License as published by the Free Software Foundation; either      }
{  version 2 of the License, or (at your option) any later version.  }
{                                                                    }
{ This library is distributed in the hope that it will be useful,    }
{  but WITHOUT ANY WARRANTY; without even the implied warranty of    }
{  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU }
{  Library General Public License for more details.                  }
{                                                                    }
{ You should have received a copy of the GNU Library General Public  }
{  License along with this library; if not, write to the             }
{  Free Software Foundation, Inc., 59 Temple Place - Suite 330,      }
{  Boston, MA  02111-1307, USA.                                      }
{ Or go to http://www.gnu.org/copyleft/lgpl.html                     }
{                                                                    }
{********************************************************************}

{********************************************************************}
{                                                                    }
{       Borland Delphi Runtime Library                               }
{       Copyright (c) 1995,2001 Borland International                }
{       Created by Project JEDI                                      }
{                                                                    }
{ The original Pascal code is: ALut.pas 	                           }
{ The initial developer of the Pascal code is Dominique Louis        }
{                                                                    }
{                                                                    }
{ Portions created by Dominique Louis are    	  			               }
{ Copyright (C) 2001 Dominique Louis (Dominique@SavageSoftware.com.au}
{                                                                    }
{ Portions created by Amresh Ramachandran are    	  			           }
{ Copyright (C) 2001 Amresh Ramachandran (amreshr@hotmail.com)       }
{                                                                    }
{ Contributor(s): Dominique Louis                                    }
{                 Amresh Ramachandran                                }
{                                                                    }
{       Obtained through:                                            }
{                                                                    }
{       Joint Endeavour of Delphi Innovators (Project JEDI)          }
{                                                                    }
{ You may retrieve the latest version of this file at the Project    }
{ JEDI home page, located at http://delphi-jedi.org                  }
{                                                                    }
{ The contents of this file are used with permission, subject to     }
{ the Mozilla Public License Version 1.1 (the "License"); you may    }
{ not use this file except in compliance with the License. You may   }
{ obtain a copy of the License at                                    }
{ http://www.mozilla.org/MPL/MPL-1.1.html 	                         }
{                                                                    }
{ Software distributed under the License is distributed on an 	     }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or     }
{ implied. See the License for the specific language governing       }
{ rights and limitations under the License. 				                 }
{                                                                    }
{********************************************************************}

unit ALut;
{***************************************************************
 *
 * Unit Name         : ALut
 * Purpose           :
 *  This is an interface unit for the use of OpenAL from within Delphi and
 *  contains the translations of alut.h and alut.c.
 * Author            : Amresh Ramachandran amreshr@hotmail.com
 * Project name      : OpenAL Delphi Translation
 * Created           : 12-Oct-2001
 * History           :
 * - first translation from Dominique Louis.
 * - previous versions from Amresh Ramachandran
 * - Amresh Ramachandran
 * - Saturday, October 20, 2001 16:12
 * Made a change in the division coz I was not able to read the full data. It
 * is not correct but now the whole wave file is read instead of only a portion
 * :)
 * Friday, October 19, 2001 16:16
 * - Finally got alutLoadWAVFile to work! Yeah! baby let's rock!
 * but it loads only half the file.
 * Thursday, October 18, 2001 15:16
 * - Changed if (not CompareMem(...)) to if (CompareMem(...))
 *  This loads data, but I still am not able to hear anything
 *  The orginal version always returned a nil pointer in data
 * - FillChar fixed (I think)
 *
 ****************************************************************}

interface

uses
	ALtypes, Classes;

const
	AL32 = 'OpenAL32.dll';

type
	TWAVFileHdr_Struct = packed record // WAV File-header
		Id: array[0..3] of TALubyte;
		Size: TALsizei;
		type_: array[0..3] of TALubyte;
	end;

	TWAVFmtHdr_Struct = packed record // WAV Fmt-header
		Format: TALushort;
		Channels: TALushort;
		SamplesPerSec: TALuint;
		BytesPerSec: TALuint;
		BlockAlign: TALushort;
		BitsPerSample: TALushort;
	end;

	TWAVFmtExHdr_Struct = packed record // WAV FmtEx-header
		Size: TALushort;
		SamplesPerBlock: TALushort;
	end;

	TLoop = packed record
		Identifier: TALuint;
		Type_: TALuint;
		Start: TALuint;
		End_: TALuint;
		Fraction: TALuint;
		Count: TALuint;
	end;

	TWAVSmplHdr_Struct = packed record // WAV Smpl-header
		Manufacturer: TALuint;
		Product: TALuint;
		SamplePeriod: TALuint;
		Note: TALuint;
		FineTune: TALuint;
		SMPTEFormat: TALuint;
		SMPTEOffest: TALuint;
		Loops: TALuint;
		SamplerData: TALuint;
		Loop: TLoop;
	end;

	TWAVChunkHdr_Struct = packed record // WAV Chunk-header
		Id: array[0..3] of TALubyte;
		Size: TALuint;
	end;

	TALutMemoryStream = class(TMemoryStream);

procedure alutInit(argc: PALint; argv: array of PChar);

procedure alutExit;

procedure alutLoadWAVFile(fname: string; var format: TALenum; var data:
	TALvoid;
	var size: TALsizei; var freq: TALsizei; var loop: TALint);

procedure alutLoadWAVMemory(memory: PALbyte; var format: TALenum; var data:
	TALvoid; var size: TALsizei; var freq: TALsizei; var loop: TALint);

procedure alutUnloadWAV(format: TALenum; data: TALvoid; size: TALsizei; freq:
	TALsizei);

implementation

uses SysUtils, Alc;

procedure alutInit(argc: PALint; argv: array of PChar);
var
  Context: PALCcontext;
  Device: PALCdevice;
begin

 //Open device
  Device := alcOpenDevice('DirectSound3D');
 //Create context(s)
  Context := alcCreateContext(Device, nil);
 //Set active context
  alcMakeContextCurrent(Context);
 //Register extensions
end;

procedure alutExit;
var
  Context: PALCcontext;
  Device: PALCdevice;
begin
 //Unregister extensions

 //Get active context
  Context := alcGetCurrentContext;
 //Get device for active context
  Device := alcGetContextsDevice(Context);
 //Release context(s)
  alcDestroyContext(Context);
 //Close device
  alcCloseDevice(Device);
end;

procedure alutLoadWAVFile(fname: string; var format: TALenum; var data:
  TALvoid; var size: TALsizei; var freq: TALsizei; var loop: TALint);
var
  ChunkHdr: TWAVChunkHdr_Struct;
  FmtExHdr: TWAVFmtExHdr_Struct;
	FileHdr: TWAVFileHdr_Struct;
	SmplHdr: TWAVSmplHdr_Struct;
	FmtHdr: TWAVFmtHdr_Struct;
	Stream: TFileStream;
begin
	format := AL_FORMAT_MONO16;
	data := nil;
	size := 0;
	freq := 22050;
	loop := AL_FALSE;
	if (fname <> '') then
	begin
		Stream := TFileStream.Create(fname, fmOpenRead);
		try
			if (Stream <> nil) then
			begin
				Stream.Read(FileHdr, sizeof(TWAVFileHdr_Struct));
				FileHdr.Size := ((FileHdr.Size + 1) xor 1) - 4;
				while ((FileHdr.Size <> 0) and
					(Stream.Read(ChunkHdr, sizeof(TWAVChunkHdr_Struct)) <> 0)) do
				begin
					if (CompareMem(@ChunkHdr.Id, PChar('fmt '), 4)) then
					begin
						Stream.Read(FmtHdr, sizeof(TWAVFmtHdr_Struct));
						if (FmtHdr.Format = $0001) then
						begin
							if FmtHdr.Channels = 1 then
							begin
								if FmtHdr.BitsPerSample = 8 then
									format := AL_FORMAT_MONO8
								else
									format := AL_FORMAT_MONO16;
							end
							else if FmtHdr.BitsPerSample = 8 then
								format := AL_FORMAT_STEREO8
							else
								format := AL_FORMAT_STEREO16;
							freq := FmtHdr.SamplesPerSec;
							Stream.Seek(ChunkHdr.Size - sizeof(TWAVFmtHdr_Struct),
								soFromCurrent);
						end
						else
						begin
							Stream.Read(FmtExHdr, sizeof(TWAVFmtExHdr_Struct));
							Stream.Seek(ChunkHdr.Size - sizeof(TWAVFmtHdr_Struct) - sizeof(
								TWAVFmtExHdr_Struct), soFromCurrent);
						end;
					end
					else if (CompareMem(@ChunkHdr.Id, PChar('data'), 4)) then
					begin
						if (FmtHdr.Format = $0001) then
						begin
							size := ChunkHdr.Size;
							data := AllocMem(ChunkHdr.Size + 31);
							if (data <> nil) then
								Stream.Read(data^, Round(ChunkHdr.Size {/ FmtHdr.BlockAlign}));
							FillChar(PByteArray(data)[ChunkHdr.Size], 31, 0);
						end
						else if (FmtHdr.Format = $0011) then
						begin
			 //IMA ADPCM
						end
						else if (FmtHdr.Format = $0055) then
						begin
			 //MP3 WAVE
						end;
					end
//					else if (not CompareMem(@ChunkHdr.Id, PChar('smpl'), 4)) then
					else if (CompareMem(@ChunkHdr.Id, PChar('smpl'), 4)) then
					begin
						Stream.Read(SmplHdr, sizeof(TWAVSmplHdr_Struct));
						if SmplHdr.Loops <> 0 then
							loop := AL_TRUE
						else
							loop := AL_FALSE;
						Stream.Seek(ChunkHdr.Size - sizeof(TWAVSmplHdr_Struct), soFromCurrent
							);
					end
					else
						Stream.Seek(ChunkHdr.Size, soFromCurrent);
					Stream.Seek(ChunkHdr.Size and 1, soFromCurrent);
					FileHdr.Size := FileHdr.Size - (((ChunkHdr.Size + 1) and not 1) + 8
						);
				end;

			end;
		finally
			Stream.Free;
		end;
	end;
end;

procedure alutLoadWAVMemory(memory: PALbyte; var format: TALenum; var data:
	TALvoid; var size: TALsizei; var freq: TALsizei; var loop: TALint);
var
	ChunkHdr: TWAVChunkHdr_Struct;
	FmtExHdr: TWAVFmtExHdr_Struct;
	FileHdr: TWAVFileHdr_Struct;
	SmplHdr: TWAVSmplHdr_Struct;
	FmtHdr: TWAVFmtHdr_Struct;
	Stream: TMemoryStream;
begin
	// Start : not yet tested
	format := AL_FORMAT_MONO16;
	data := nil;
	size := 0;
	freq := 22050;
	loop := AL_FALSE;

	if (memory <> nil) then
	begin
		Stream := TMemoryStream.Create;
		TALutMemoryStream(Stream).SetPointer(memory, sizeof(memory^)); //???
		try
			if (Stream <> nil) then
			begin
				Stream.Read(FileHdr, sizeof(TWAVFileHdr_Struct));
				Stream.Seek(sizeof(TWAVFileHdr_Struct), soFromCurrent);
				FileHdr.Size := ((FileHdr.Size + 1) xor 1) - 4;
				while ((FileHdr.Size <> 0) and
					(Stream.Read(ChunkHdr, sizeof(TWAVChunkHdr_Struct)) <> 0)) do
				begin
					Stream.Seek(sizeof(TWAVChunkHdr_Struct), soFromCurrent);
					if CompareMem(@ChunkHdr.Id, PChar('fmt '), 4) then
					begin
						Stream.Read(FmtHdr, sizeof(TWAVFmtHdr_Struct));
						if (FmtHdr.Format = $0001) then
						begin
							if FmtHdr.Channels = 1 then
							begin
								if FmtHdr.BitsPerSample = 8 then
									format := AL_FORMAT_MONO8
								else
									format := AL_FORMAT_MONO16;
							end
							else if FmtHdr.BitsPerSample = 8 then
								format := AL_FORMAT_STEREO8
							else
								format := AL_FORMAT_STEREO16;
							freq := FmtHdr.SamplesPerSec;
							Stream.Seek(ChunkHdr.Size, soFromCurrent);
						end
						else
						begin
							Stream.Read(FmtExHdr, sizeof(TWAVFmtExHdr_Struct));
							Stream.Seek(ChunkHdr.Size, soFromCurrent);
						end;
					end
					else if (CompareMem(@ChunkHdr.Id, PChar('data'), 4)) then
					begin
						if (FmtHdr.Format = $0001) then
						begin
							size := ChunkHdr.Size;
							data := AllocMem(ChunkHdr.Size + 31);
							if (data <> nil) then
								Stream.Read(data, ChunkHdr.Size);
							FillChar(PChar(data)[ChunkHdr.Size], 31, 0);
							Stream.Seek(ChunkHdr.Size, soFromCurrent);
						end
						else if (FmtHdr.Format = $0011) then
						begin
							//IMA ADPCM
						end
						else if (FmtHdr.Format = $0055) then
						begin
							//MP3 WAVE
						end
					end
					else if (CompareMem(@ChunkHdr.Id, PChar('smpl'), 4)) then
					begin
						Stream.Read(SmplHdr, sizeof(TWAVSmplHdr_Struct));
						if SmplHdr.Loops <> 0 then
							loop := AL_TRUE
						else
							loop := AL_FALSE;
						Stream.Seek(ChunkHdr.Size, soFromCurrent);
					end
					else
						Stream.Seek(ChunkHdr.Size, soFromCurrent);
					Stream.Seek(ChunkHdr.Size and 1, soFromCurrent);
					FileHdr.Size := FileHdr.Size - (((ChunkHdr.Size + 1) and not 1) + 8);
				end;
			end;
		finally
			Stream.Free;
		end;
	end;
end;

procedure alutUnloadWAV(format: TALenum; data: TALvoid; size: TALsizei; freq:
	TALsizei);
begin
	if assigned(data) then
	begin
		Data := nil;
		Dispose(data);
	end;
end;

end.

