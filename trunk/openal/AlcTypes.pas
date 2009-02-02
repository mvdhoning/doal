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
{ The original Pascal code is: ALCTypes.pas                          }
{ The initial developer of the Pascal code is Amresh Ramachandran    }
{                                                                    }
{ Portions created by Amresh Ramachandran are    	  			           }
{ Copyright (C) 2001 Amresh Ramachandran (amreshr@hotmail.com)       }
{                                                                    }
{ Portions created by Pranav Joshi are    	  			                 }
{ Copyright (C) 2001 Pranav Joshi  (pranavjosh@yahoo.com)            }
{                                                                    }
{ Contributor(s): Amresh Ramachandran                                }
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
unit ALCTypes;

interface
{***************************************************************
 *
 * Unit Name         : ALCTypes
 * Purpose           :
 *  This is an interface unit for the use of OpenAL from within Delphi and
 *  contains the translations of alctypes.h
 * Author            : Amresh Ramachandran amreshr@hotmail.com
 * - first translation from Amresh Ramachandran.
 * - previous versions from Pranav Joshi.
 * Project name      : OpenAL Delphi Translation
 * Created           : 12-Oct-2001
 * History           :
 * Saturday, October 20, 2001 16:17
 * Included this header
 *
 ****************************************************************}

type
	//* ALC boolean type. */
	TALCboolean = boolean;
	PALCboolean = ^TALCboolean;

	//* ALC 8bit signed byte. */
	TALCbyte = ShortInt;
	PALCbyte = ^TALCbyte;

	//* ALC 8bit unsigned byte. */
	TALCubyte = Char;
	PALCubyte = PChar;

	//* ALC 16bit signed short integer type. */
	TALCshort = smallint;
	PALCshort = ^TALCshort;

	//* ALC 16bit unsigned short integer type. */
	TALCushort = Word;
	PALCushort = ^TALCushort;

	//* ALC 32bit unsigned integer type. */
	TALCuint = Cardinal;
	PALCuint = ^TALCuint;

	//* ALC 32bit signed integer type. */
	TALCint = integer;
	PALCint = ^TALCint;

	//* ALC 32bit floating point type. */
	TALCfloat = single;
	PALCfloat = ^TALCfloat;

	//* ALC 64bit double point type. */
	TALCdouble = double;
	PALCdouble = ^TALCdouble;

	//* ALC 32bit type. */
	TALCsizei = integer;
	PALCsizei = ^TALCsizei;

	//** ALC enumerations. */
	TALCenum = integer;
	PALCenum = ^TALCenum;

	//** ALC void type */
	TALCvoid = Pointer;
	PALCvoid = ^TALCvoid;
const
	//* bad value */
  ALC_INVALID                           = -1;

  //* Boolean False */
  ALC_FALSE                             = 0;

  //* Boolean False */
  ALC_TRUE                              = 1;

  //** Errors: No Error. */
  ALC_NO_ERROR                          = ALC_FALSE;

  ALC_MAJOR_VERSION                     = $1000;
  ALC_MINOR_VERSION                     = $1001;
  ALC_ATTRIBUTES_SIZE                   = $1002;
  ALC_ALL_ATTRIBUTES                    = $1003;

  ALC_DEFAULT_DEVICE_SPECIFIER          = $1004;
  ALC_DEVICE_SPECIFIER                  = $1005;
  ALC_EXTENSIONS                        = $1006;

  ALC_FREQUENCY                         = $1007;
  ALC_REFRESH                           = $1008;
  ALC_SYNC                              = $1009;

  (**
   * The device argument does not name a valid dvice.
   *)
  ALC_INVALID_DEVICE                    = $A001;

  (**
   * The context argument does not name a valid context.
   *)
  ALC_INVALID_CONTEXT                   = $A002;

  (**
   * A function was called at inappropriate time,
   *  or in an inappropriate way, causing an illegal state.
   * This can be an incompatible ALenum, object ID,
   *  and/or function.
   *)
  ALC_INVALID_ENUM                      = $A003;

  (**
   * Illegal value passed as an argument to an AL call.
   * Applies to parameter values, but not to enumerations.
   *)
  ALC_INVALID_VALUE                     = $A004;

  (**
   * A function could not be completed,
   * because there is not enough memory available.
   *)
  ALC_OUT_OF_MEMORY                     = $A005;
implementation

end.
