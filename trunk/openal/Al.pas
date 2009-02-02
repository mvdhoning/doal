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
{ The original Pascal code is: Al.pas 	                             }
{ The initial developer of the Pascal code is Tom Nuydens            }
{                                                                    }
{                                                                    }
{ Portions created by Tom Nuydens are    	  			                   }
{ Copyright (C) 2001 Tom Nuydens  (delphi3d@gamedeveloper.org)       }
{                                                                    }
{                                                                    }
{ Portions created by Dean Ellis are    	  			                   }
{ Copyright (C) 2001 Dean Ellis (dean.ellis@sxmedia.co.uk)           }
{                                                                    }
{ Portions created by Amresh Ramachandran are    	  			           }
{ Copyright (C) 2001 Amresh Ramachandran (amreshr@hotmail.com)       }
{                                                                    }
{                                                                    }
{ Portions created by Pranav Joshi are    	  			                 }
{ Copyright (C) 2001 Pranav Joshi  (pranavjosh@yahoo.com)            }
{                                                                    }
{ Contributor(s): Tom Nuydens                                        }
{ 			          Dean Ellis                                         }
{                 Pranav Joshi                                       }
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

unit Al;
{***************************************************************
 *
 * Unit Name         : Al
 * Purpose           :
 *  This is an interface unit for the use of OpenAL from within Delphi and
 *  contains the translations of al.h
 * Author            : Pranav Joshi pranavjosh@yahoo.com
 * - first translation from Tom Nuydens and Dean Ellis.
 * - previous versions from Amresh Ramachandran and Pranav Joshi
 * - Amresh Ramachandran
 * Project name      : OpenAL Delphi Translation
 * Created           : 12-Oct-2001
 * History           :
 * Saturday, October 20, 2001 16:17
 * Included this header
 *
 ****************************************************************}

interface

uses
	AlTypes;

const
	AL32                                  = 'OpenAL32.dll';

procedure alInit(argc: PAlint; argv: PAluByte); cdecl; external AL32;
procedure alExit; cdecl; external AL32;
(**
 * OpenAL Maintenance Functions
 * State Management and Query.
 * Error Handling.
 * Extension Support.
 *)

(** Renderer State management. *)
procedure alEnable(capability: TALenum); cdecl; external AL32;
procedure alDisable(capability: TALenum); cdecl; external AL32;
function alIsEnabled(capability: TALenum): TALboolean; cdecl; external AL32;

(** Application preferences for driver performance choices. *)
procedure alHint(target, mode: TALenum); cdecl; external AL32;

(** State retrieval. *)
function alGetBoolean(param: TALenum): TALboolean; cdecl; external AL32;
function alGetInteger(param: TALenum): TALint; cdecl; external AL32;
function alGetFloat(param: TALenum): TALfloat; cdecl; external AL32;
function alGetDouble(param: TALenum): TALdouble; cdecl; external AL32;
procedure alGetBooleanv(param: TALenum; data: PALboolean); cdecl; external AL32;
procedure alGetIntegerv(param: TALenum; data: PALint); cdecl; external AL32;
procedure alGetFloatv(param: TALenum; data: PALfloat); cdecl; external AL32;
procedure alGetDoublev(param: TALenum; data: PALdouble); cdecl; external AL32;
function alGetString(param: TALenum): PALubyte; cdecl; external AL32;

(**
 * Error support.
 * Obtain the most recent error generated in the AL state machine.
 *)
function alGetError: TALenum; cdecl; external AL32;

(**
 * Error support.
 * Obtain a constant string that describes the given error token.
 *)
//function alGetErrorString(error: TALenum): PALubyte; cdecl; external AL32;
 (**
 * Extension support.
 * Obtain the address of a function (usually an extension)
 *  with the name fname. All addresses are context-independent.
 *)
function alIsExtensionPresent(fname: PChar): TALboolean; cdecl; external AL32;

(**
 * Extension support.
 * Obtain the address of a function (usually an extension)
 *  with the name fname. All addresses are context-independent.
 *)
function alGetProcAddress(fname: PALuByte): Pointer; cdecl; external AL32;

(**
 * Extension support.
 * Obtain the integer value of an enumeration (usually an extension) with the name ename.
 *)
function alGetEnumValue(ename: PALuByte): TALenum; cdecl; external AL32;

(**
 * LISTENER
 * Listener is the sample position for a given context.
 *  The multi-channel (usually stereo) output stream generated
 *  by the mixer is parametrized by this Listener object:
 *  its position and velocity relative to Sources, within
 *  occluder and reflector geometry.
 *)
{**
 *
 * Listener Environment:  default 0.
 *}
procedure alListeneri(param: TAlenum; value: TALint); cdecl; external AL32;
(**
 *
 * Listener Gain:  default 1.0f.
 *)
procedure alListenerf(param: TALenum; value: TALfloat); cdecl; external AL32;

(**
 *
 * Listener Position.
 * Listener Velocity.
 *)
procedure alListener3f(param: TALenum; f1: TALfloat; f2: TALfloat; f3: TALfloat);
  cdecl; external
AL32;

(**
 *
 * Listener Position:        TALfloat[3]
 * Listener Velocity:        TALfloat[3]
 * Listener Orientation:     TALfloat[6]  forward and up vector.
 * *)
procedure alListenerfv(param: TALenum; values: PALfloat); cdecl; external AL32;

(*
 Retrieve listener information
 *)
procedure alGetListeneriv(param: TALenum; values: PALint); cdecl; external AL32;
procedure alGetListenerfv(param: TALenum; values: PALfloat); cdecl; external
  AL32;

(**
 * SOURCE
 * Source objects are by default localized. Sources
 *  take the PCM data provided in the specified Buffer,
 *  apply Source-specific modifications, and then
 *  submit them to be mixed according to spatial
 *  arrangement etc.
 *)

(** Create Source objects. *)
procedure alGenSources(n: TALsizei; sources: PALuint); cdecl; external
AL32;

(** Delete Source objects. *)
procedure alDeleteSources(n: TALsizei; sources: PALuint); cdecl; external AL32;

(** Verify a handle is a valid Source. *)
function alIsSource(id: TALuint): TALboolean; cdecl; external AL32;

(** Set an integer parameter for a Source object. *)
procedure alSourcei(source: TALuint; param: TALenum; value: TALint); cdecl; external
  AL32;
procedure alSourcef(source: TALuint; param: TALenum; value: TALfloat); cdecl;
  external AL32;
procedure alSource3f(source: TALuint; param: TALenum; v1: TALfloat; v2: TALfloat;
  v3: TALfloat); cdecl; external AL32;
procedure alSourcefv(source: TALuint; param: TALenum; values: PALfloat); cdecl;
  external AL32;

(** Get an integer parameter for a Source object. *)
procedure alGetSourcei(source: TALuint; param: TALenum; value: PALint); cdecl;
  external AL32;
procedure alGetSourcef(source: TALuint; param: TALenum; value: PALfloat); cdecl;
  external AL32;
procedure alGetSource3f(source: TALuint; param: TALenum; v1: PALfloat; v2:
  PALfloat; v3: PALfloat); cdecl; external AL32;
procedure alGetSourcefv(source: TALuint; param: TALenum; values: PALfloat); cdecl;
  external AL32;

procedure alSourcePlayv(n: TALsizei; sources: PALuint); cdecl; external AL32;
procedure alSourceStopv(n: TALsizei; sources: PALuint); cdecl; external AL32;
procedure alSourceRewindv(n: TALsizei; sources: PALuint); cdecl; external AL32;
procedure alSourcePausev(n: TALsizei; sources: PALuint); cdecl; external AL32;

(** Activate a source, start replay. *)
procedure alSourcePlay(source: TALuint); cdecl; external AL32;

(*
 * Pause a source,
 *  temporarily remove it from the mixer list.
 *)
procedure alSourcePause(source: TALuint); cdecl; external AL32;

(*
 * Stop a source,
 *  temporarily remove it from the mixer list,
 *  and reset its internal state to pre-Play.
 * To remove a Source completely, it has to be
 *  deleted following Stop, or before Play.
 *)
procedure alSourceStop(source: TALuint); cdecl; external AL32;

(**
 * Rewinds a source,
 *  temporarily remove it from the mixer list,
 *  and reset its internal state to pre-Play.
 *)
procedure alSourceRewind(source: TALuint); cdecl; external AL32;

(*
 * BUFFER
 * Buffer objects are storage space for sample data.
 * Buffers are referred to by Sources. There can be more than
 *  one Source using the same Buffer data. If Buffers have
 *  to be duplicated on a per-Source basis, the driver has to
 *  take care of allocation, copying, and deallocation as well
 *  as propagating buffer data changes.
 *)

(** Buffer object generation. *)
procedure alGenBuffers(n: TALsizei; buffers: PALuint); cdecl; external AL32;
procedure alDeleteBuffers(n: TALsizei; buffers: PALuint); cdecl; external AL32;
function alIsBuffer(buffer: TALuint): TALboolean; cdecl; external AL32;

(**
 * Specify the data to be filled into a buffer.
 *)
procedure alBufferData(buffer: TALuint; format: TALenum; data: Pointer; size,
  freq: TALsizei); cdecl; external AL32;

(**
 * Specify data to be filled into a looping buffer.
 * This takes the current position at the time of the
 *  call, and returns the number of samples written.
 *)
//function alBufferAppendData(buffer: TALuint; format: TALenum; data: Pointer; size,
//                            freq: TALsizei): TALsizei; cdecl; external AL32;

procedure alGetBufferi(buffer: TALuint; param: TALenum; value: PALint); cdecl;
external AL32;
procedure alGetBufferf(buffer: TALuint; param: TALenum; value: PALfloat); cdecl;
external AL32;

(*
 * Frequency Domain Filters are band filters.
 *  Attenuation in Media (distance based)
 *  Reflection Material
 *  Occlusion Material (separating surface)
 *
 * Temporal Domain Filters:
 *  Early Reflections
 *  Late Reverb
 *
 *)

(*
 * EXTENSION: IASIG Level 2 Environment.
 * Environment object generation.
 * This is an EXTension that describes the Environment/Reverb
 *  properties according to IASIG Level 2 specifications.
 *)

(*
 * Allocate n environment ids and store them in the array environs.
 * Returns the number of environments actually allocated.
 *)
function alGenEnvironmentIASIG(n: TALsizei; environs: PALuint): TALsizei; cdecl;
external AL32;
procedure alDeleteEnvironmentIASIG(n: TALsizei; environs: PALuint); cdecl;
external AL32;
function alIsEnvironmentIASIG(environ: TALuint): TALboolean; cdecl; external AL32;
procedure alEnvironmentiIASIG(eid: TALuint; param: TALenum; value: TALint); cdecl;
external AL32;
procedure alEnvironmentfIASIG(eid: TALuint; param: TALenum; value: TALfloat);
cdecl; external AL32;

(*
 * Queue stuff
 *)
procedure alSourceQueueBuffers(source: TALuint; n: TALsizei; buffers: PALuint);
  cdecl; external AL32;
procedure alSourceUnqueueBuffers(source: TALuint; n: TALsizei; buffers: PALuint);
  cdecl; external AL32;
procedure alQueuei(source: TALuint; n: TALsizei; buffers: PALuint); cdecl; external
  AL32;
(*
 * Knobs and dials
 *)
procedure alDistanceModel(value: TALenum); cdecl; external AL32;
procedure alDopplerFactor(value: TALfloat); cdecl; external AL32;
procedure alDopplerVelocity(value: TALfloat); cdecl; external AL32;

implementation

end.
