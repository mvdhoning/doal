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
{ The original Pascal code is: Alc.pas 	                             }
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

unit Alc;

interface
{***************************************************************
 *
 * Unit Name         : Alc
 * Purpose           :
 *  This is an interface unit for the use of OpenAL from within Delphi and
 *  contains the translations of alc.h
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

uses
	ALCtypes;

const
	AL32                                  = 'OpenAL32.dll';

type
	PALCcontext = ^TALCcontext;
	TALCcontext = TALCvoid;

	PALCdevice = ^TALCdevice;
	TALCdevice = TALCvoid;

function alcGetString(device: TALCdevice; param: TALCenum): PALCubyte; cdecl;
external AL32;
procedure alcGetIntegerv(device: TALCdevice; param: TALCenum; size: TALCsizei;
	data: PALCint); cdecl; external AL32;

function alcOpenDevice(deviceName: PALCuByte): TALCdevice; cdecl; external AL32;
procedure alcCloseDevice(device: TALCdevice); cdecl; external AL32;

function alcCreateContext(device: TALCdevice; attrlist: PALCint): TALCcontext;
cdecl; external AL32;
function alcMakeContextCurrent(context: TALCcontext): TALCenum; cdecl; external
AL32;
procedure alcProcessContext(context: TALCcontext); cdecl; external AL32;
function alcGetCurrentContext: TALCcontext; cdecl; external AL32;
function alcGetContextsDevice(context: TALCcontext): TALCdevice; cdecl; external
AL32;
procedure alcSuspendContext(context: TALCcontext); cdecl; external AL32;
procedure alcDestroyContext(context: TALCcontext); cdecl; external AL32;

function alcGetError(device: TALCdevice): TALCenum; cdecl; external AL32;

function alcIsExtensionPresent(device: TALCdevice; extName: PALCubyte):
	TALCboolean; cdecl; external AL32;
function alcGetProcAddress(device: TALCdevice; funcName: PALCubyte): TALCvoid;
cdecl; external AL32;
function alcGetEnumValue(device: TALCdevice; enumName: PALCubyte): TALCenum;
cdecl; external AL32;

implementation

end.
