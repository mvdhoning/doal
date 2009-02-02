{********************************************************************}
{*                                                                   }
{*  EAX.H - DirectSound3D Environmental Audio Extensions version 2.0 }
{*  Updated July 8, 1999                                             }
{*                                                                   }
{********************************************************************}

{********************************************************************}
{                                                                    }
{       Borland Delphi Runtime Library                               }
{       Copyright (c) 1995,2001 Borland International                }
{       Created by Project JEDI                                      }
{                                                                    }
{ The original Pascal code is: Eax.pas 	                             }
{ The initial developer of the Pascal code is Amresh Ramachandran    }
{                                                                    }
{ Portions created by Amresh Ramachandran are    	  	     }
{ Copyright (C) 2001 Amresh Ramachandran (amreshr@hotmail.com)       }
{                                                                    }
{ Contributor(s): Amresh Ramachandran, M van der Honing              }
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
{ http://www.mozilla.org/MPL/MPL-1.1.html 	                     }
{                                                                    }
{ Software distributed under the License is distributed on an 	     }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or     }
{ implied. See the License for the specific language governing       }
{ rights and limitations under the License. 			     }
{                                                                    }
{********************************************************************}


unit Eax;

{***************************************************************
 *
 * Unit Name         : Eax
 * Purpose           : This is an interface unit for the use of Eax OpenAL
 *                     extentions from within Delphi and contains the
 *                     translations of eax.h
 * Author            : Amresh Ramachandran amreshr@hotmail.com
 *                   : M van der Honing mvdhoning@noeska.com
 * Project name      : OpenAL EAX2.0 Extension for OpenAL
 * Created           : 12-Oct-2001
 * History           :
 * Thursday, October 17, 2001 11:42
 * -Fixed missing $ENDIF
 * -Fixed parameter list in EaxSet and EaxGet
 * -Added const AL32 since EaxSet and EaxGet are located in OpenAL32.dll
 * Friday, April 30, 2004
 * -Removed all $IF structures left in only the openal parts
 * -Removed const to AL32 EAXGet and EAXSet are now dynamic
 *
 ****************************************************************}

interface

uses
	Windows, ALTypes, AL;

const

  DSPROPSETID_EAX20_ListenerProperties     : TGuid = '{0306A6A8-B224-11d2-99E5-0000E8D8C722}';
  DSPROPSETID_EAX20_BufferProperties       : TGuid = '{0306A6A7-B224-11d2-99E5-0000E8D8C722}';

  //TODO: ???
  // For compatibility with future EAX versions:
  //DSPROPSETID_EAX_ListenerProperties = DSPROPSETID_EAX20_ListenerProperties;
  //DSPROPSETID_EAX_SourceProperties = DSPROPSETID_EAX20_BufferProperties;

  //Enumerations DSPROPERTY_EAX_LISTENERPROPERTY
  DSPROPERTY_EAXLISTENER_NONE              = 0;
  DSPROPERTY_EAXLISTENER_ALLPARAMETERS     = 1;
  DSPROPERTY_EAXLISTENER_ROOM              = 2;
  DSPROPERTY_EAXLISTENER_ROOMHF            = 3;
  DSPROPERTY_EAXLISTENER_ROOMROLLOFFFACTOR = 4;
  DSPROPERTY_EAXLISTENER_DECAYTIME         = 5;
  DSPROPERTY_EAXLISTENER_DECAYHFRATIO      = 6;
  DSPROPERTY_EAXLISTENER_REFLECTIONS       = 7;
  DSPROPERTY_EAXLISTENER_REFLECTIONSDELAY  = 8;
  DSPROPERTY_EAXLISTENER_REVERB            = 9;
  DSPROPERTY_EAXLISTENER_REVERBDELAY       = 10;
  DSPROPERTY_EAXLISTENER_ENVIRONMENT       = 11;
  DSPROPERTY_EAXLISTENER_ENVIRONMENTSIZE   = 12;
  DSPROPERTY_EAXLISTENER_ENVIRONMENTDIFFUSION = 13;
  DSPROPERTY_EAXLISTENER_AIRABSORPTIONHF   = 14;
  DSPROPERTY_EAXLISTENER_FLAGS             = 15;

  // OR these flags with property id
  DSPROPERTY_EAXLISTENER_IMMEDIATE         = $00000000;
  // changes take effect immediately
  DSPROPERTY_EAXLISTENER_DEFERRED          = DWORD($80000000);
  DSPROPERTY_EAXLISTENER_COMMITDEFERREDSETTINGS = (DSPROPERTY_EAXLISTENER_NONE or
                                                   DSPROPERTY_EAXLISTENER_IMMEDIATE);

  // used by DSPROPERTY_EAXLISTENER_ENVIRONMENT
  //Enummetation
  EAX_ENVIRONMENT_GENERIC                  = 0;
  EAX_ENVIRONMENT_PADDEDCELL               = 1;
  EAX_ENVIRONMENT_ROOM                     = 2;
  EAX_ENVIRONMENT_BATHROOM                 = 3;
  EAX_ENVIRONMENT_LIVINGROOM               = 4;
  EAX_ENVIRONMENT_STONEROOM                = 5;
  EAX_ENVIRONMENT_AUDITORIUM               = 6;
  EAX_ENVIRONMENT_CONCERTHALL              = 7;
  EAX_ENVIRONMENT_CAVE                     = 8;
  EAX_ENVIRONMENT_ARENA                    = 9;
  EAX_ENVIRONMENT_HANGAR                   = 10;
  EAX_ENVIRONMENT_CARPETEDHALLWAY          = 11;
  EAX_ENVIRONMENT_HALLWAY                  = 12;
  EAX_ENVIRONMENT_STONECORRIDOR            = 13;
  EAX_ENVIRONMENT_ALLEY                    = 14;
  EAX_ENVIRONMENT_FOREST                   = 15;
  EAX_ENVIRONMENT_CITY                     = 16;
  EAX_ENVIRONMENT_MOUNTAINS                = 17;
  EAX_ENVIRONMENT_QUARRY                   = 18;
  EAX_ENVIRONMENT_PLAIN                    = 19;
  EAX_ENVIRONMENT_PARKINGLOT               = 20;
  EAX_ENVIRONMENT_SEWERPIPE                = 21;
  EAX_ENVIRONMENT_UNDERWATER               = 22;
  EAX_ENVIRONMENT_DRUGGED                  = 23;
  EAX_ENVIRONMENT_DIZZY                    = 24;
  EAX_ENVIRONMENT_PSYCHOTIC                = 25;
  EAX_ENVIRONMENT_COUNT                    = 26;

  // Used by DSPROPERTY_EAXLISTENER_FLAGS
  //
  // Note: The number and order of flags may change in future EAX versions.
  //       It is recommended to use the flag defines as follows:
  //              myFlags = EAXLISTENERFLAGS_DECAYTIMESCALE | EAXLISTENERFLAGS_REVERBSCALE;
  //       instead of:
  //              myFlags = 0x00000009;
  //
  // These flags determine what properties are affected by environment size.
  EAXLISTENERFLAGS_DECAYTIMESCALE          = $00000001;
  // reverberation decay time
  EAXLISTENERFLAGS_REFLECTIONSSCALE        = $00000002; // reflection level
  EAXLISTENERFLAGS_REFLECTIONSDELAYSCALE   = $00000004;
  // initial reflection delay time
  EAXLISTENERFLAGS_REVERBSCALE             = $00000008; // reflections level
  EAXLISTENERFLAGS_REVERBDELAYSCALE        = $00000010;
  // late reverberation delay time

  // This flag limits high-frequency decay time according to air absorption.
  EAXLISTENERFLAGS_DECAYHFLIMIT            = $00000020;
  EAXLISTENERFLAGS_RESERVED                = $FFFFFFC0; // reserved future use

  // property ranges and defaults:
  EAXLISTENER_MINROOM                      = -10000;
  EAXLISTENER_MAXROOM                      = 0;
  EAXLISTENER_DEFAULTROOM                  = -1000;

  EAXLISTENER_MINROOMHF                    = -10000;
  EAXLISTENER_MAXROOMHF                    = 0;
  EAXLISTENER_DEFAULTROOMHF                = -100;

  EAXLISTENER_MINROOMROLLOFFFACTOR         = 0.0;
  EAXLISTENER_MAXROOMROLLOFFFACTOR         = 10.0;
  EAXLISTENER_DEFAULTROOMROLLOFFFACTOR     = 0.0;

  EAXLISTENER_MINDECAYTIME                 = 0.1;
  EAXLISTENER_MAXDECAYTIME                 = 20.0;
  EAXLISTENER_DEFAULTDECAYTIME             = 1.49;

  EAXLISTENER_MINDECAYHFRATIO              = 0.1;
  EAXLISTENER_MAXDECAYHFRATIO              = 2.0;
  EAXLISTENER_DEFAULTDECAYHFRATIO          = 0.83;

  EAXLISTENER_MINREFLECTIONS               = -10000;
  EAXLISTENER_MAXREFLECTIONS               = 1000;
  EAXLISTENER_DEFAULTREFLECTIONS           = -2602;

  EAXLISTENER_MINREFLECTIONSDELAY          = 0.0;
  EAXLISTENER_MAXREFLECTIONSDELAY          = 0.3;
  EAXLISTENER_DEFAULTREFLECTIONSDELAY      = 0.007;

  EAXLISTENER_MINREVERB                    = -10000;
  EAXLISTENER_MAXREVERB                    = 2000;
  EAXLISTENER_DEFAULTREVERB                = 200;

  EAXLISTENER_MINREVERBDELAY               = 0.0;
  EAXLISTENER_MAXREVERBDELAY               = 0.1;
  EAXLISTENER_DEFAULTREVERBDELAY           = 0.011;

  EAXLISTENER_MINENVIRONMENT               = 0;
  EAXLISTENER_MAXENVIRONMENT               = EAX_ENVIRONMENT_COUNT - 1;
  EAXLISTENER_DEFAULTENVIRONMENT           = EAX_ENVIRONMENT_GENERIC;

  EAXLISTENER_MINENVIRONMENTSIZE           = 1.0;
  EAXLISTENER_MAXENVIRONMENTSIZE           = 100.0;
  EAXLISTENER_DEFAULTENVIRONMENTSIZE       = 7.5;

  EAXLISTENER_MINENVIRONMENTDIFFUSION      = 0.0;
  EAXLISTENER_MAXENVIRONMENTDIFFUSION      = 1.0;
  EAXLISTENER_DEFAULTENVIRONMENTDIFFUSION  = 1.0;

  EAXLISTENER_MINAIRABSORPTIONHF           = -100.0;
  EAXLISTENER_MAXAIRABSORPTIONHF           = 0.0;
  EAXLISTENER_DEFAULTAIRABSORPTIONHF       = -5.0;

  EAXLISTENER_DEFAULTFLAGS                 = EAXLISTENERFLAGS_DECAYTIMESCALE or
                                             EAXLISTENERFLAGS_REFLECTIONSSCALE or
  	                                     EAXLISTENERFLAGS_REFLECTIONSDELAYSCALE or
		                             EAXLISTENERFLAGS_REVERBSCALE or
		                             EAXLISTENERFLAGS_REVERBDELAYSCALE or
		                             EAXLISTENERFLAGS_DECAYHFLIMIT;

  // For compatibility with future EAX versions:
  //DSPROPSETID_EAX_BufferProperties = DSPROPSETID_EAX20_BufferProperties;

  //Enumeration DSPROPERTY_EAX_BUFFERPROPERTY
  DSPROPERTY_EAXBUFFER_NONE                = 0;
  DSPROPERTY_EAXBUFFER_ALLPARAMETERS       = 1;
  DSPROPERTY_EAXBUFFER_DIRECT              = 2;
  DSPROPERTY_EAXBUFFER_DIRECTHF            = 3;
  DSPROPERTY_EAXBUFFER_ROOM                = 4;
  DSPROPERTY_EAXBUFFER_ROOMHF              = 5;
  DSPROPERTY_EAXBUFFER_ROOMROLLOFFFACTOR   = 6;
  DSPROPERTY_EAXBUFFER_OBSTRUCTION         = 7;
  DSPROPERTY_EAXBUFFER_OBSTRUCTIONLFRATIO  = 8;
  DSPROPERTY_EAXBUFFER_OCCLUSION           = 9;
  DSPROPERTY_EAXBUFFER_OCCLUSIONLFRATIO    = 10;
  DSPROPERTY_EAXBUFFER_OCCLUSIONROOMRATIO  = 11;
  DSPROPERTY_EAXBUFFER_OUTSIDEVOLUMEHF     = 12;
  DSPROPERTY_EAXBUFFER_AIRABSORPTIONFACTOR = 13;
  DSPROPERTY_EAXBUFFER_FLAG                = 14;

  // OR these flags with property id
  DSPROPERTY_EAXBUFFER_IMMEDIATE           = $00000000;
  // changes take effect immediately
  DSPROPERTY_EAXBUFFER_DEFERRED            = DWORD($80000000);
  DSPROPERTY_EAXBUFFER_COMMITDEFERREDSETTINGS = DSPROPERTY_EAXBUFFER_NONE or
  DSPROPERTY_EAXBUFFER_IMMEDIATE;

  // Used by DSPROPERTY_EAXBUFFER_FLAGS
  //    TRUE:    value is computed automatically - property is an offset
  //    FALSE:   value is used directly
  //
  // Note: The number and order of flags may change in future EAX versions.
  //       To insure future compatibility, use flag defines as follows:
  //              myFlags = EAXBUFFERFLAGS_DIRECTHFAUTO | EAXBUFFERFLAGS_ROOMAUTO;
  //       instead of:
  //              myFlags = 0x00000003;
  //
  EAXBUFFERFLAGS_DIRECTHFAUTO              = $00000001;
  // affects DSPROPERTY_EAXBUFFER_DIRECTHF
  EAXBUFFERFLAGS_ROOMAUTO                  = $00000002;
  // affects DSPROPERTY_EAXBUFFER_ROOM
  EAXBUFFERFLAGS_ROOMHFAUTO                = $00000004;
  // affects DSPROPERTY_EAXBUFFER_ROOMHF

  EAXBUFFERFLAGS_RESERVED                  = $FFFFFFF8; // reserved future use

  // property ranges and defaults:
  EAXBUFFER_MINDIRECT                      = -10000;
  EAXBUFFER_MAXDIRECT                      = 1000;
  EAXBUFFER_DEFAULTDIRECT                  = 0;

  EAXBUFFER_MINDIRECTHF                    = -10000;
  EAXBUFFER_MAXDIRECTHF                    = 0;
  EAXBUFFER_DEFAULTDIRECTHF                = 0;

  EAXBUFFER_MINROOM                        = -10000;
  EAXBUFFER_MAXROOM                        = 1000;
  EAXBUFFER_DEFAULTROOM                    = 0;

  EAXBUFFER_MINROOMHF                      = -10000;
  EAXBUFFER_MAXROOMHF                      = 0;
  EAXBUFFER_DEFAULTROOMHF                  = 0;

  EAXBUFFER_MINROOMROLLOFFFACTOR           = 0.0;
  EAXBUFFER_MAXROOMROLLOFFFACTOR           = 10.;
  EAXBUFFER_DEFAULTROOMROLLOFFFACTOR       = 0.0;

  EAXBUFFER_MINOBSTRUCTION                 = -10000;
  EAXBUFFER_MAXOBSTRUCTION                 = 0;
  EAXBUFFER_DEFAULTOBSTRUCTION             = 0;

  EAXBUFFER_MINOBSTRUCTIONLFRATIO          = 0.0;
  EAXBUFFER_MAXOBSTRUCTIONLFRATIO          = 1.0;
  EAXBUFFER_DEFAULTOBSTRUCTIONLFRATIO      = 0.0;

  EAXBUFFER_MINOCCLUSION                   = -10000;
  EAXBUFFER_MAXOCCLUSION                   = 0;
  EAXBUFFER_DEFAULTOCCLUSION               = 0;

  EAXBUFFER_MINOCCLUSIONLFRATIO            = 0.0;
  EAXBUFFER_MAXOCCLUSIONLFRATIO            = 1.0;
  EAXBUFFER_DEFAULTOCCLUSIONLFRATIO        = 0.25;

  EAXBUFFER_MINOCCLUSIONROOMRATIO          = 0.0;
  EAXBUFFER_MAXOCCLUSIONROOMRATIO          = 10.0;
  EAXBUFFER_DEFAULTOCCLUSIONROOMRATIO      = 0.5;

  EAXBUFFER_MINOUTSIDEVOLUMEHF             = -10000;
  EAXBUFFER_MAXOUTSIDEVOLUMEHF             = 0;
  EAXBUFFER_DEFAULTOUTSIDEVOLUMEHF         = 0;

  EAXBUFFER_MINAIRABSORPTIONFACTOR         = 0.0;
  EAXBUFFER_MAXAIRABSORPTIONFACTOR         = 10.0;
  EAXBUFFER_DEFAULTAIRABSORPTIONFACTOR     = 1.0;

  EAXBUFFER_DEFAULTFLAGS                   = EAXBUFFERFLAGS_DIRECTHFAUTO or
  EAXBUFFERFLAGS_ROOMAUTO or
  EAXBUFFERFLAGS_ROOMHFAUTO;

  // Material transmission presets
  // 3 values in this order:
  //     1: occlusion (or obstruction)
  //     2: occlusion LF Ratio (or obstruction LF Ratio)
  //     3: occlusion Room Ratio

  // Single window material preset
  EAX_MATERIAL_SINGLEWINDOW                = -2800;
  EAX_MATERIAL_SINGLEWINDOWLF              = 0.71;
  EAX_MATERIAL_SINGLEWINDOWROOMRATIO       = 0.43;

  // Double window material preset
  EAX_MATERIAL_DOUBLEWINDOW                = -5000;
  EAX_MATERIAL_DOUBLEWINDOWHF              = 0.40;
  EAX_MATERIAL_DOUBLEWINDOWROOMRATIO       = 0.24;

  // Thin door material preset
  EAX_MATERIAL_THINDOOR                    = -1800;
  EAX_MATERIAL_THINDOORLF                  = 0.66;
  EAX_MATERIAL_THINDOORROOMRATIO           = 0.66;

  // Thick door material preset
  EAX_MATERIAL_THICKDOOR                   = -4400;
  EAX_MATERIAL_THICKDOORLF                 = 0.64;
  EAX_MATERIAL_THICKDOORROOMRTATION        = 0.27;

  // Wood wall material preset
  EAX_MATERIAL_WOODWALL                    = -4000;
  EAX_MATERIAL_WOODWALLLF                  = 0.50;
  EAX_MATERIAL_WOODWALLROOMRATIO           = 0.30;

  // Brick wall material preset
  EAX_MATERIAL_BRICKWALL                   = -5000;
  EAX_MATERIAL_BRICKWALLLF                 = 0.60;
  EAX_MATERIAL_BRICKWALLROOMRATIO          = 0.24;

  // Stone wall material preset
  EAX_MATERIAL_STONEWALL                   = -6000;
  EAX_MATERIAL_STONEWALLLF                 = 0.68;
  EAX_MATERIAL_STONEWALLROOMRATIO          = 0.20;

  // Curtain material preset
  EAX_MATERIAL_CURTAIN                     = -1200;
  EAX_MATERIAL_CURTAINLF                   = 0.15;
  EAX_MATERIAL_CURTAINROOMRATIO            = 1.00;

type
  DSPROPERTY_EAX_LISTENERPROPERTY = DWORD;
  DSPROPERTY_EAX_BUFFERPROPERTY = DWORD;

  // Use this structure for DSPROPERTY_EAXLISTENER_ALLPARAMETERS
  // - all levels are hundredths of decibels
  // - all times are in seconds
  // - the reference for high frequency controls is 5 kHz
  //
  // NOTE: This structure may change in future EAX versions.
  //       It is recommended to initialize fields by name:
  //              myListener.lRoom = -1000;
  //              myListener.lRoomHF = -100;
  //              ...
  //              myListener.dwFlags = myFlags /* see EAXLISTENERFLAGS below */ ;
  //       instead of:
  //              myListener = { -1000, -100, ... , 0x00000009 };
  //       If you want to save and load presets in binary form, you
  //       should define your own structure to insure future compatibility.
  //
  PEaxListenerProperties = ^TEaxListenerProperties;
  TEaxListenerProperties = packed record
    lRoom: integer; // room effect level at low frequencies
    lRoomHF: integer;
    // room effect high-frequency level re. low frequency levelimplementation
    flRoomRolloffFactor: double; // like DS3D flRolloffFactor but for room effect
    flDecayTime: double; // reverberation decay time at low frequenciesend.
    flDecayHFRatio: double; // high-frequency to low-frequency decay time ratio
    lReflections: integer; // early reflections level relative to room effect
    flReflectionsDelay: double; // initial reflection delay time
    lReverb: integer; // late reverberation level relative to room effect
    flReverbDelay: double;
    // late reverberation delay time relative to initial reflection
    dwEnvironment: cardinal; // sets all listener properties
    flEnvironmentSize: double; // environment size in meters
    flEnvironmentDiffusion: double; // environment diffusion
    flAirAbsorptionHF: double; // change in level per meter at 5 kHz
    dwFlags: cardinal; // modifies the behavior of properties
  end;

  // Use this structure for DSPROPERTY_EAXBUFFER_ALLPARAMETERS
  // - all levels are hundredths of decibels
  //
  // NOTE: This structure may change in future EAX versions.
  //       It is recommended to initialize fields by name:
  //              myBuffer.lDirect = 0;
  //              myBuffer.lDirectHF = -200;
  //              ...
  //              myBuffer.dwFlags = myFlags /* see EAXBUFFERFLAGS below */ ;
  //       instead of:
  //              myBuffer = { 0, -200, ... , 0x00000003 };
  //
  PEaxBufferProperties = ^TEaxBufferProperties;
  TEaxBufferProperties = packed record
    lDirect: integer; // direct path level
    lDirectHF: integer; // direct path level at high frequencies
    lRoom: integer; // room effect level
    lRoomHF: integer; // room effect level at high frequencies
    flRoomRolloffFactor: double; // like DS3D flRolloffFactor but for room effect
    lObstruction: integer;
    // main obstruction control (attenuation at high frequencies)
    flObstructionLFRatio: double;
    // obstruction low-frequency level re. main control
    lOcclusion: integer;
    // main occlusion control (attenuation at high frequencies)
    flOcclusionLFRatio: double; // occlusion low-frequency level re. main control
    flOcclusionRoomRatio: double; // occlusion room effect level re. main control
    lOutsideVolumeHF: integer; // outside sound cone level at high frequencies
    flAirAbsorptionFactor: double;
    // multiplies DSPROPERTY_EAXLISTENER_AIRABSORPTIONHF
    dwFlags: Cardinal; // modifies the behavior of properties
  end;

  var
    EAXSet: Function(const Guid: TGUID; ALuint1: TALuint; ALuint2: TALuint; point: Pointer; ALuint3: TALuint): TALenum; stdcall; {$EXTERNALSYM EAXSet}
    EAXGet: Function(const Guid: TGUID; ALuint1: TALuint; ALuint2: TALuint; point: Pointer; ALuint3: TALuint): TALenum; stdcall; {$EXTERNALSYM EAXGet}


implementation

end.
