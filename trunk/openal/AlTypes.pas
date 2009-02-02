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
{ The original Pascal code is: ALTypes.pas                           }
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
{                 Amresh Ramachandran                                }
{                 Pranav Joshi                                       }
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

unit ALTypes;
{***************************************************************
 *
 * Unit Name         : ALTypes
 * Purpose           :
 *  This is an interface unit for the use of OpenAL from within Delphi and
 *  contains the translations of altypes.h
 * Author            : Amresh Ramachandran amreshr@hotmail.com
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

type
	//** OpenAL boolean type.
	TALboolean = Boolean;
	PALboolean = ^TALboolean;
	//** OpenAL 8bit signed byte.
	TALbyte = ShortInt;
	PALbyte = ^TALbyte;
	//** OpenAL 8bit unsigned byte.
	TALuByte = Char;
	PALuByte = PChar;
	//** OpenAL 16bit signed short integer type.
	TALshort = SmallInt;
	PALshort = ^TALshort;
	//** OpenAL 16bit unsigned short integer type.
	TALushort = Word;
	PALushort = ^TALushort;
	//** OpenAL 32bit unsigned integer type.
	TALuint = Cardinal;
	PALuint = ^TALuint;
	//** OpenAL 32bit signed integer type.
	TALint = Integer;
	PALint = ^TALint;
	//** OpenAL 32bit floating point type.
	TALfloat = Single;
	PALfloat = ^TALfloat;
	//** OpenAL 64bit double point type.
	TALdouble = Double;
	PALdouble = ^TALdouble;
	//** OpenAL 32bit type.
	TALsizei = Cardinal;
	PALsizei = ^TALsizei;
	//** OpenAL void type
	TALvoid = Pointer;
	PALvoid = ^TALvoid;
	PPALvoid = ^PALvoid;
	//** OpenAL enumerations.
	TALenum = Integer;
	PALenum = ^TALenum;
	//** OpenAL bitfields.
	TALbitfield = Cardinal;
	PALbitfield = ^TALbitfield;
	//** OpenAL clamped float.
	TALclampf = TALfloat;
	PALclampf = ^TALclampf;
	//** Openal clamped double. */
	TALclampd = TALdouble;
	PALclampd = ^TALclampd;

const
	// Bad value.
	AL_INVALID                            = -1;
	// Disable value
	AL_NONE                               = 0;
	// Boolean False.
	AL_FALSE                              = 0;
	// Boolean True.
	AL_TRUE                               = 1;

	(**
	* Indicate the type of AL_SOURCE.
	* Sources can be spatialized
	*)
	AL_SOURCE_TYPE                        = $200;
	// Indicate Source has absolute coordinates.
	AL_SOURCE_ABSOLUTE                    = $201;
  // Indicate Source has listener relative coordinates.
  AL_SOURCE_RELATIVE                    = $202;

  (**
  * Multichannel Sources bypass OpenAl completely, and get
  *  handled by the hardware. No other source type will handle 2
  *  or more channel sounds, although stereo sound samples
  *  can get mixed into mono for simplicity.
  *)
  AL_SOURCE_MULTICHANNEL                = $204;

  (**
  * Aureal's Area source, oh my....
  *)
  AL_SOURCE_POINT                       = $205;

  (**
  * Directional source, inner cone angle, in degrees.
  * Range:    [0-360]
  * Default:  360
  *)
  AL_CONE_INNER_ANGLE                   = $1001;

  (**
  * Directional source, outer cone angle, in degrees.
  * Range:    [0-360]
  * Default:  360
  *)
  AL_CONE_OUTER_ANGLE                   = $1002;

  (**
  * Specify the pitch to be applied, either at source,
  *  or on mixer results, at listener.
  * Range:   [0.5-2.0]
  * Default: 1.0
  *)
  AL_PITCH                              = $1003;

  (**
  * Specify the current location in three dimensional space.
  * OpenAL, like OpenGL, uses a right handed coordinate system,
  *  where in a frontal default view X (thumb) points right,
  *  Y points up (index finger), and Z points towards the
  *  viewer/camera (middle finger).
  * To switch from a left handed coordinate system, flip the
  *  sign on the Z coordinate.
  * Listener position is always in the world coordinate system.
  *)
  AL_POSITION                           = $1004;

  (** Specify the current direction as forward vector. *)
  AL_DIRECTION                          = $1005;

  (** Specify the current velocity in three dimensional space. *)
  AL_VELOCITY                           = $1006;

  (**
  * Indicate whether source is looping.
  * Type: ALboolean?
  * Range:   [AL_TRUE, AL_FALSE]
  * Default: FALSE.
  *)
  AL_LOOPING                            = $1007;

  (**
  * Indicate whether source is meant to be streaming.
  * Type: ALboolean?
  * Range:   [AL_TRUE, AL_FALSE]
  * Default: FALSE.
  *)
  AL_STREAMING                          = $1008;

  (**
  * Indicate the rolloff factor for the source.
  * Type: ALfloat
  * Range:    [0.0 - ]
  * Default:  1.0
  AL_ROLLOFF_FACTOR	= $1008;
  *)

  (**
  * Indicate the buffer to provide sound samples.
  * Type: ALuint.
  * Range: any valid Buffer id.
  *)
  AL_BUFFER                             = $1009;

  (**
  * Indicate the gain (volume amplification) applied.
  * Type:   ALfloat.
  * Range:  ]0.0-  ]
  * A value of 1.0 means un-attenuated/unchanged.
  * Each division by 2 equals an attenuation of -6dB.
  * Each multiplicaton with 2 equals an amplification of +6dB.
  * A value of 0.0 is meaningless with respect to a logarithmic
  *  scale; it is interpreted as zero volume - the channel
  *  is effectively disabled.
  *)
  AL_GAIN                               = $100A;

  (**
  * Indicate Source is ambient (not localized by application).
  * It is up to the driver how it wants to handle this case.
  * Ideally, the (human) listener should be unable to localize
  *  this one. Easy :-).
  *)
  AL_SOURCE_AMBIENT                     = $100B;

  (* byte offset into source (in canon format).  -1 if source
  * is not playing.  Don't set this, get this.
  *
  * Type:  ALint
  * Range: -1 - +inf
  *)
  AL_BYTE_LOKI                          = $100C;

  (*
  * Indicate minimum source attenuation
  * Type: ALfloat
  * Range:  [0.0 - 1.0]
  *
  * Logarthmic
  *)
  AL_MIN_GAIN                           = $100D;
  (**
  * Indicate maximum source attenuation
  * Type: ALfloat
  * Range:  [0.0 - 1.0]
  *
  * Logarthmic
  *)
  AL_MAX_GAIN                           = $100E;
  (**
  * Indicate listener orientation.
  *
  * at/up
  *)
  AL_ORIENTATION                        = $100F;

  (*  {**
   * Indicate the environment to apply the source/listener.
   * Type: ALuint.
   * Range: any valid Environment id.
   *}
   AL_ENVIRONMENT_IASIG          = $100C;

   AL_DIRECT_IASIG				= $100D;
   AL_DIRECT_HIGH_FREQUENCY_IASIG= $100E;
   AL_ROOM_IASIG					= $100F;

   AL_ROOM_HIGH_FREQUENCY_IASIG	= $1010;

   {**
   * Indicate the source priority
   * Type: ALfloat
   * Range:   [0.0-1.0]
   * Default: 0.5
   *}
   AL_PRIORITY					= $1011;
  *)

   (**
   * Source state information.
   *)
  AL_SOURCE_STATE                       = $1010;
  AL_INITIAL                            = $1011;
  AL_PLAYING                            = $1012;
  AL_PAUSED                             = $1013;
  AL_STOPPED                            = $1014;
  (**
  * Buffer Queue params
  *)
  AL_BUFFERS_QUEUED                     = $1015;
  AL_BUFFERS_PROCESSED                  = $1016;

  // Sound buffers: format specifier.
  AL_FORMAT_MONO8                       = $1100;
  AL_FORMAT_MONO16                      = $1101;
  AL_FORMAT_STEREO8                     = $1102;
  AL_FORMAT_STEREO16                    = $1103;

  (**
  * source specific reference distance
  * Type: ALfloat
  * Range:  0.0 - +inf
  *
  * At 0.0, no distance attenuation occurs.  Default is
  * 1.0.
  *)
  AL_REFERENCE_DISTANCE                 = $1020;
  (**
  * source specific rolloff factor
  * Type: ALfloat
  * Range:  0.0 - +inf
  *
  *)
  AL_ROLLOFF_FACTOR                     = $1021;
  (**
  * Directional source, outer cone gain.
  *
  * Default:  0.0
  * Range:    [0.0 - 1.0]
  * Logarithmic
  *)
  AL_CONE_OUTER_GAIN                    = $1022;
  (**
  * Indicate distance above which sources are not
  * attenuated using the inverse clamped distance model.
  *
  * Default: +inf
  * Type: ALfloat
  * Range:  0.0 - +inf
  *)
  AL_MAX_DISTANCE                       = $1023;

  (**
  * Sound buffers: frequency, in units of Hertz [Hz].
  * This is the number of samples per second. Half of the
  *  sample frequency marks the maximum significant
  *  frequency component.
  *)
  AL_FREQUENCY                          = $2001;
  AL_BITS                               = $2002;
  AL_CHANNELS                           = $2003;
  AL_SIZE                               = $2004;
  AL_DATA                               = $2005;

  (**
  * Buffer state.
  *
  * Not supported for public use (yet).
  *)
  AL_UNUSED                             = $2010;
  AL_PENDING                            = $2011;
  AL_CURRENT                            = $2012;

  (** Errors: No Error. *)
  AL_NO_ERROR                           = AL_FALSE;

  (**
  * Illegal name passed as an argument to an AL call.
  *)
  AL_INVALID_NAME                       = $A001;
  (**
  * Illegal enum passed as an argument to an AL call.
  *)
  AL_INVALID_ENUM                       = $A002;
  (**
  * Illegal value passed as an argument to an AL call.
  * Applies to parameter values, but not to enumerations.
  *)
  AL_INVALID_VALUE                      = $A003;
  (**
  * A function was called at inappropriate time,
  *  or in an inappropriate way, causing an illegal state.
  * This can be an incompatible ALenum, object ID,
  *  and/or function.
  *)
  AL_INVALID_OPERATION                  = $A004;
  (**
  * A function could not be completed,
  * because there is not enough memory available.
  *)
  AL_OUT_OF_MEMORY                      = $A005;

  (** Context strings: Vendor Name. *)
  AL_VENDOR                             = $B001;
  AL_VERSION                            = $B002;
  AL_RENDERER                           = $B003;
  AL_EXTENSIONS                         = $B004;

  (** Global tweakage. *)

  (**
  * Doppler scale.  Default 1.0
  *)
  AL_DOPPLER_FACTOR                     = $C000;
  (**
  * Tweaks speed of propagation.
  *)
  AL_DOPPLER_VELOCITY                   = $C001;
  (**
  * Distance scaling
  *)
  AL_DISTANCE_SCALE                     = $C002;
  (**
  * Distance models
  *
  * used in conjunction with DistanceModel
  *
  * implicit: NONE, which disances distance attenuation.
  *)
  AL_DISTANCE_MODEL                     = $D000;
  AL_INVERSE_DISTANCE                   = $D001;
  AL_INVERSE_DISTANCE_CLAMPED           = $D002;

  (**
   * enables
   *)
  (* #define AL_SOME_ENABLE                            0xE000 *)

 (**
  * Specify the channel mask. (Creative)
  * Type:	 ALuint
  * Range:	 [0 - 255]
  *)
  AL_CHANNEL_MASK                       = $3000;

  (** IASIG Level 2 Environment. *)

  (**
  * Parameter:  IASIG ROOM  blah
  * Type:       intgeger
  * Range:      [-10000, 0]
  * Default:    -10000
  *)
  AL_ENV_ROOM_IASIG                     = $3001;

  (**
  * Parameter:  IASIG ROOM_HIGH_FREQUENCY
  * Type:       integer
  * Range:      [-10000, 0]
  * Default:    0
  *)
  AL_ENV_ROOM_HIGH_FREQUENCY_IASIG      = $3002;

  (**
  * Parameter:  IASIG ROOM_ROLLOFF_FACTOR
  * Type:       float
  * Range:      [0.0, 10.0]
  * Default:    0.0
  *)
  AL_ENY_ROOM_ROLLOFF_FACTOR_IASIG      = $3003;

  (**
  * Parameter:  IASIG  DECAY_TIME
  * Type:       float
  * Range:      [0.1, 20.0]
  * Default:    1.0
  *)
  AL_ENV_DECAY_TIME_IASIG               = $3004;

  (**
  * Parameter:  IASIG DECAY_HIGH_FREQUENCY_RATIO
  * Type:       float
  * Range:      [0.1, 2.0]
  * Default:    0.5
  *)
  AL_ENV_DECAY_HIGH_FREQUENCY_RATIO_IASIG = $3005;

  (**
  * Parameter:  IASIG REFLECTIONS
  * Type:       integer
  * Range:      [-10000, 1000]
  * Default:    -10000
  *)
  AL_ENV_REFLECTIONS_IASIG              = $3006;

  (**
  * Parameter:  IASIG REFLECTIONS_DELAY
  * Type:       float
  * Range:      [0.0, 0.3]
  * Default:    0.02
  *)
  AL_ENV_REFLECTIONS_DELAY_IASIG        = $3006;

  (**
  * Parameter:  IASIG REVERB
  * Type:       integer
  * Range:      [-10000,2000]
  * Default:    -10000
  *)
  AL_ENV_REVERB_IASIG                   = $3007;

  (**
  * Parameter:  IASIG REVERB_DELAY
  * Type:       float
  * Range:      [0.0, 0.1]
  * Default:    0.04
  *)
  AL_ENV_REVERB_DELAY_IASIG             = $3008;

  (**
  * Parameter:  IASIG DIFFUSION
  * Type:       float
  * Range:      [0.0, 100.0]
  * Default:    100.0
  *)
  AL_ENV_DIFFUSION_IASIG                = $3009;

  (**
  * Parameter:  IASIG DENSITY
  * Type:       float
  * Range:      [0.0, 100.0]
  * Default:    100.0
  *)
  AL_ENV_DENSITY_IASIG                  = $300A;

  (**
  * Parameter:  IASIG HIGH_FREQUENCY_REFERENCE
  * Type:       float
  * Range:      [20.0, 20000.0]
  * Default:    5000.0
  *)
  AL_ENV_HIGH_FREQUENCY_REFERENCE_IASIG = $300B;

  (**
  * Parameter:  IASIG LISTENER_ENVIORNMENT
  * Type:		 integer
  * Range:
  * Default:
  *)
  AL_ENV_LISTENER_ENVIRONMENT_IASIG     = $300C;

  (**
  * Parameter:  IASIG SOURCE_ENVIORNMENT
	* Type:		 integer
  * Range:
  * Default:
  *)
  AL_ENV_SOURCE_ENVIRONMENT_IASIG       = $300D;

implementation

end.
