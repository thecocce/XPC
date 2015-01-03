{
	XPC_PascalPreProcessor.pas
  Copyright (c) 2015 by Sergio Flores <relfos@gmail.com>

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
}
Unit XPC_PascalPreProcessor;

{$I terra.inc}

Interface
Uses XPC_Lexer, TERRA_Utils, TERRA_OS, TERRA_IO, TERRA_Error, TERRA_FileIO, TERRA_Collections;

Const
  MaxStates = 128;
  


const INITIAL = 2;
const XCOMMENT1 = 4;
const XCOMMENT2 = 6;
const XNOTDEF = 8;


  
Type
  PascalPreProcessor = Class(CustomLexer)
    Protected            
      Procedure yyaction ( yyruleno : Integer ); Override;

    Public
      Constructor Create(Source:Stream);
      Destructor Destroy; Override;

      Property CurrentLine:Integer Read yylineno;
      Property CurrentRow:Integer Read yycolno;
      
      Function Parse: integer; Override;
  End;

Implementation

{ PascalPreProcessor }

Procedure PascalPreProcessor.yyaction(yyruleno : Integer );
  (* local definitions: *)


begin
  (* actions: *)
  case yyruleno of
  1:
      				Begin End;
  2:
  					Begin yypushstate(XCOMMENT1); End;
  3:
    				Begin yypushstate(XCOMMENT2); End;

  4:
             		{ yypopstate(); End;
  5:
               		{ yypopstate(); End;

  6:
                    		Begin End;
  7:
                 			Begin End;
  8:
               				Begin CheckSourceNewline(); End;
  9:
            				Begin End;
  10:
      			Begin throw new PreprocessorException(yyline, "Unterminated comment"); End;}


  11:
                    		Begin End;
  12:
                 			Begin End;
  13:
               				Begin CheckSourceNewline(); End;
  14:
            				Begin End;
  15:
        			Begin throw new PreprocessorException(yyline, "Unterminated comment"); End;}

	{ PreProcessor - process compiler directives }
	
	
	{ includes }
  16:
             		Begin
						string ifile = GetDirectiveArg("i");
						string inctext = FetchInclude(ifile);
						
						if (inctext == null)
						Begin
                            pperror("Include file " + ifile + " not found");
							break;
						End;

						StringReader sr = new StringReader(inctext);
						yypushStream(sr);
						yydebug("Pushed stream from " + ifile + "");
					End;

	{ defines }
  17:
                  	Begin	AddDefine(GetDirectiveArg("define"));	End;

  18:
                 	Begin	RemoveDefine(GetDirectiveArg("undef"));	End;

	{ ifdefs }
  19:
                 	Begin	
                        if (!IsDefinedDir("ifdef")) Then
                            yypushstate(XNOTDEF);
					End;

  20:
                 	Begin
                        if (!IsDefinedDir("ifopt"))
							yypushstate(XNOTDEF);
					End;

  21:
                  	Begin
                        Boolean defined = IsDefined(GetDirectiveArg("ifndef"));
						defines.Push(!defined);
						if (defined)
							yypushstate(XNOTDEF);
					End;

  22:
               		Begin
                        // currently in a defined section, switch to non-defined
						defines.Pop();
						defines.Push(false);
						yypushstate(XNOTDEF);
					End;

  23:
                	Begin defines.Pop(); End;


  24:
  Other compiler directives: ignored for now }
  25:
          			Begin End;

	/* not-defined code section */
  26:
               				Begin End;
  27:
           					Begin yypushstate(XCOMMENT1); End;
  28:
             				Begin yypushstate(XCOMMENT2); End;
 
					/* push true to signal that these defines are within a non-defined section */
  29:
                          	Begin defines.Push(true); End;

  30:
                          	Begin defines.Push(true); End;

  31:
                           	Begin defines.Push(true); End;

  32:
                        	Begin	if (defines.Peek() == false)	// at the non-def section start, must leave
                                Begin	yypopstate();
							defines.Pop();
							defines.Push(true);
                                End; // else, leave the top def as true
					End;

  33:
                         	Begin	Boolean def = defines.Pop(); 
						if (def == false)
							yypopstate();
					End;
 
  34:
                   			Begin { chomp up as much as possible in one match} End;
  35:
             				Begin CheckSourceNewline(); End;
  36:
          					Begin  { ignore everything in a non-def section } End;


  37:
          			Begin outBuilder.Append(zzBuffer, zzStartRead, zzMarkedPos-zzStartRead); End;

  38:
                  	Begin
                        if (zzBuffer[zzMarkedPos-1] != '\'')	// if last char not quote
							pperror("Unterminated string");
						else
							outBuilder.Append(zzBuffer, zzStartRead, zzMarkedPos-zzStartRead);
					End;

  39:
        			Begin outBuilder.Append(yycharat(0)); End;
  40:
    				Begin CheckSourceNewline(); End;

  41:
 					Begin pperror("Unknown char: " + text + " (ASCII " + ((int) text[0]) +")"); End

  end;
end(*yyaction*);

(* DFA table: *)

type YYTRec = record
                cc : set of Char;
                s  : Integer;
              end;

const

yynmarks   = 148;
yynmatches = 148;
yyntrans   = 260;
yynstates  = 156;

yyk : array [1..yynmarks] of Integer = (
  { 0: }
  { 1: }
  { 2: }
  { 3: }
  { 4: }
  { 5: }
  { 6: }
  { 7: }
  { 8: }
  { 9: }
  { 10: }
  39,
  41,
  { 11: }
  2,
  24,
  41,
  { 12: }
  39,
  41,
  { 13: }
  37,
  41,
  { 14: }
  41,
  { 15: }
  39,
  41,
  { 16: }
  40,
  41,
  { 17: }
  40,
  { 18: }
  41,
  { 19: }
  9,
  39,
  41,
  { 20: }
  2,
  9,
  24,
  41,
  { 21: }
  9,
  39,
  41,
  { 22: }
  4,
  9,
  41,
  { 23: }
  6,
  9,
  37,
  41,
  { 24: }
  6,
  7,
  9,
  37,
  41,
  { 25: }
  7,
  9,
  39,
  41,
  { 26: }
  8,
  9,
  40,
  41,
  { 27: }
  8,
  40,
  { 28: }
  9,
  41,
  { 29: }
  7,
  9,
  41,
  { 30: }
  14,
  39,
  41,
  { 31: }
  2,
  14,
  24,
  41,
  { 32: }
  14,
  39,
  41,
  { 33: }
  11,
  12,
  14,
  37,
  41,
  { 34: }
  11,
  14,
  37,
  41,
  { 35: }
  12,
  14,
  39,
  41,
  { 36: }
  13,
  14,
  40,
  41,
  { 37: }
  13,
  40,
  { 38: }
  14,
  41,
  { 39: }
  12,
  14,
  41,
  { 40: }
  36,
  39,
  41,
  { 41: }
  2,
  24,
  27,
  36,
  41,
  { 42: }
  36,
  39,
  41,
  { 43: }
  34,
  36,
  37,
  41,
  { 44: }
  35,
  36,
  40,
  41,
  { 45: }
  35,
  40,
  { 46: }
  36,
  41,
  { 47: }
  36,
  41,
  { 48: }
  36,
  39,
  41,
  { 49: }
  1,
  { 50: }
  { 51: }
  { 52: }
  3,
  { 53: }
  37,
  { 54: }
  { 55: }
  38,
  { 56: }
  38,
  { 57: }
  5,
  { 58: }
  1,
  26,
  { 59: }
  { 60: }
  3,
  28,
  { 61: }
  34,
  37,
  { 62: }
  { 63: }
  { 64: }
  { 65: }
  { 66: }
  { 67: }
  { 68: }
  { 69: }
  { 70: }
  { 71: }
  { 72: }
  { 73: }
  { 74: }
  { 75: }
  25,
  { 76: }
  { 77: }
  { 78: }
  { 79: }
  { 80: }
  { 81: }
  { 82: }
  { 83: }
  { 84: }
  { 85: }
  { 86: }
  { 87: }
  { 88: }
  { 89: }
  { 90: }
  { 91: }
  { 92: }
  { 93: }
  { 94: }
  { 95: }
  { 96: }
  { 97: }
  { 98: }
  10,
  { 99: }
  { 100: }
  16,
  { 101: }
  { 102: }
  { 103: }
  { 104: }
  { 105: }
  { 106: }
  { 107: }
  { 108: }
  { 109: }
  { 110: }
  { 111: }
  { 112: }
  { 113: }
  { 114: }
  { 115: }
  { 116: }
  { 117: }
  { 118: }
  { 119: }
  22,
  { 120: }
  { 121: }
  { 122: }
  { 123: }
  { 124: }
  22,
  32,
  { 125: }
  { 126: }
  15,
  { 127: }
  { 128: }
  { 129: }
  { 130: }
  { 131: }
  { 132: }
  23,
  { 133: }
  { 134: }
  { 135: }
  { 136: }
  23,
  33,
  { 137: }
  { 138: }
  { 139: }
  { 140: }
  { 141: }
  { 142: }
  { 143: }
  { 144: }
  { 145: }
  19,
  { 146: }
  20,
  { 147: }
  { 148: }
  { 149: }
  18,
  { 150: }
  19,
  29,
  { 151: }
  20,
  30,
  { 152: }
  { 153: }
  21,
  { 154: }
  17,
  { 155: }
  21,
  31
);

yym : array [1..yynmatches] of Integer = (
{ 0: }
{ 1: }
{ 2: }
{ 3: }
{ 4: }
{ 5: }
{ 6: }
{ 7: }
{ 8: }
{ 9: }
{ 10: }
  39,
  41,
{ 11: }
  2,
  24,
  41,
{ 12: }
  39,
  41,
{ 13: }
  37,
  41,
{ 14: }
  41,
{ 15: }
  39,
  41,
{ 16: }
  40,
  41,
{ 17: }
  40,
{ 18: }
  41,
{ 19: }
  9,
  39,
  41,
{ 20: }
  2,
  9,
  24,
  41,
{ 21: }
  9,
  39,
  41,
{ 22: }
  4,
  9,
  41,
{ 23: }
  6,
  9,
  37,
  41,
{ 24: }
  6,
  7,
  9,
  37,
  41,
{ 25: }
  7,
  9,
  39,
  41,
{ 26: }
  8,
  9,
  40,
  41,
{ 27: }
  8,
  40,
{ 28: }
  9,
  41,
{ 29: }
  7,
  9,
  41,
{ 30: }
  14,
  39,
  41,
{ 31: }
  2,
  14,
  24,
  41,
{ 32: }
  14,
  39,
  41,
{ 33: }
  11,
  12,
  14,
  37,
  41,
{ 34: }
  11,
  14,
  37,
  41,
{ 35: }
  12,
  14,
  39,
  41,
{ 36: }
  13,
  14,
  40,
  41,
{ 37: }
  13,
  40,
{ 38: }
  14,
  41,
{ 39: }
  12,
  14,
  41,
{ 40: }
  36,
  39,
  41,
{ 41: }
  2,
  24,
  27,
  36,
  41,
{ 42: }
  36,
  39,
  41,
{ 43: }
  34,
  36,
  37,
  41,
{ 44: }
  35,
  36,
  40,
  41,
{ 45: }
  35,
  40,
{ 46: }
  36,
  41,
{ 47: }
  36,
  41,
{ 48: }
  36,
  39,
  41,
{ 49: }
  1,
{ 50: }
{ 51: }
{ 52: }
  3,
{ 53: }
  37,
{ 54: }
{ 55: }
  38,
{ 56: }
  38,
{ 57: }
  5,
{ 58: }
  1,
  26,
{ 59: }
{ 60: }
  3,
  28,
{ 61: }
  34,
  37,
{ 62: }
{ 63: }
{ 64: }
{ 65: }
{ 66: }
{ 67: }
{ 68: }
{ 69: }
{ 70: }
{ 71: }
{ 72: }
{ 73: }
{ 74: }
{ 75: }
  25,
{ 76: }
{ 77: }
{ 78: }
{ 79: }
{ 80: }
{ 81: }
{ 82: }
{ 83: }
{ 84: }
{ 85: }
{ 86: }
{ 87: }
{ 88: }
{ 89: }
{ 90: }
{ 91: }
{ 92: }
{ 93: }
{ 94: }
{ 95: }
{ 96: }
{ 97: }
{ 98: }
  10,
{ 99: }
{ 100: }
  16,
{ 101: }
{ 102: }
{ 103: }
{ 104: }
{ 105: }
{ 106: }
{ 107: }
{ 108: }
{ 109: }
{ 110: }
{ 111: }
{ 112: }
{ 113: }
{ 114: }
{ 115: }
{ 116: }
{ 117: }
{ 118: }
{ 119: }
  22,
{ 120: }
{ 121: }
{ 122: }
{ 123: }
{ 124: }
  22,
  32,
{ 125: }
{ 126: }
  15,
{ 127: }
{ 128: }
{ 129: }
{ 130: }
{ 131: }
{ 132: }
  23,
{ 133: }
{ 134: }
{ 135: }
{ 136: }
  23,
  33,
{ 137: }
{ 138: }
{ 139: }
{ 140: }
{ 141: }
{ 142: }
{ 143: }
{ 144: }
{ 145: }
  19,
{ 146: }
  20,
{ 147: }
{ 148: }
{ 149: }
  18,
{ 150: }
  19,
  29,
{ 151: }
  20,
  30,
{ 152: }
{ 153: }
  21,
{ 154: }
  17,
{ 155: }
  21,
  31
);

yyt : array [1..yyntrans] of YYTrec = (
{ 0: }
  ( cc: [ #1..#8,#11,#12,#14..#31,'"','%','?','`','|'..#255 ]; s: 18),
  ( cc: [ #9,' ','!','#','$','&','*'..'.','0'..'>',
            '@'..'_','a'..'z' ]; s: 13),
  ( cc: [ #10 ]; s: 17),
  ( cc: [ #13 ]; s: 16),
  ( cc: [ '''' ]; s: 14),
  ( cc: [ '(' ]; s: 12),
  ( cc: [ ')' ]; s: 15),
  ( cc: [ '/' ]; s: 10),
  ( cc: [ '{' ]; s: 11),
{ 1: }
  ( cc: [ #1..#8,#11,#12,#14..#31,'"','%','?','`','|'..#255 ]; s: 18),
  ( cc: [ #9,' ','!','#','$','&','*'..'.','0'..'>',
            '@'..'_','a'..'z' ]; s: 13),
  ( cc: [ #10 ]; s: 17),
  ( cc: [ #13 ]; s: 16),
  ( cc: [ '''' ]; s: 14),
  ( cc: [ '(' ]; s: 12),
  ( cc: [ ')' ]; s: 15),
  ( cc: [ '/' ]; s: 10),
  ( cc: [ '{' ]; s: 11),
{ 2: }
  ( cc: [ #1..#8,#11,#12,#14..#31,'"','%','?','`','|'..#255 ]; s: 18),
  ( cc: [ #9,' ','!','#','$','&','*'..'.','0'..'>',
            '@'..'_','a'..'z' ]; s: 13),
  ( cc: [ #10 ]; s: 17),
  ( cc: [ #13 ]; s: 16),
  ( cc: [ '''' ]; s: 14),
  ( cc: [ '(' ]; s: 12),
  ( cc: [ ')' ]; s: 15),
  ( cc: [ '/' ]; s: 10),
  ( cc: [ '{' ]; s: 11),
{ 3: }
  ( cc: [ #1..#8,#11,#12,#14..#31,'"','%','?','`','|'..#255 ]; s: 18),
  ( cc: [ #9,' ','!','#','$','&','*'..'.','0'..'>',
            '@'..'_','a'..'z' ]; s: 13),
  ( cc: [ #10 ]; s: 17),
  ( cc: [ #13 ]; s: 16),
  ( cc: [ '''' ]; s: 14),
  ( cc: [ '(' ]; s: 12),
  ( cc: [ ')' ]; s: 15),
  ( cc: [ '/' ]; s: 10),
  ( cc: [ '{' ]; s: 11),
{ 4: }
  ( cc: [ #1..#8,#11,#12,#14..#31,'"','%','?','`','|',
            '~'..#255 ]; s: 28),
  ( cc: [ #9,' ','!','#','$','&','+'..'.','0'..'>',
            '@'..'_','a'..'z' ]; s: 23),
  ( cc: [ #10 ]; s: 27),
  ( cc: [ #13 ]; s: 26),
  ( cc: [ '''' ]; s: 29),
  ( cc: [ '(' ]; s: 21),
  ( cc: [ ')' ]; s: 25),
  ( cc: [ '*' ]; s: 24),
  ( cc: [ '/' ]; s: 19),
  ( cc: [ '{' ]; s: 20),
  ( cc: [ '}' ]; s: 22),
{ 5: }
  ( cc: [ #1..#8,#11,#12,#14..#31,'"','%','?','`','|',
            '~'..#255 ]; s: 28),
  ( cc: [ #9,' ','!','#','$','&','+'..'.','0'..'>',
            '@'..'_','a'..'z' ]; s: 23),
  ( cc: [ #10 ]; s: 27),
  ( cc: [ #13 ]; s: 26),
  ( cc: [ '''' ]; s: 29),
  ( cc: [ '(' ]; s: 21),
  ( cc: [ ')' ]; s: 25),
  ( cc: [ '*' ]; s: 24),
  ( cc: [ '/' ]; s: 19),
  ( cc: [ '{' ]; s: 20),
  ( cc: [ '}' ]; s: 22),
{ 6: }
  ( cc: [ #1..#8,#11,#12,#14..#31,'"','%','?','`','|'..#255 ]; s: 38),
  ( cc: [ #9,' ','!','#','$','&','+'..'.','0'..'>',
            '@'..'_','a'..'z' ]; s: 34),
  ( cc: [ #10 ]; s: 37),
  ( cc: [ #13 ]; s: 36),
  ( cc: [ '''' ]; s: 39),
  ( cc: [ '(' ]; s: 32),
  ( cc: [ ')' ]; s: 35),
  ( cc: [ '*' ]; s: 33),
  ( cc: [ '/' ]; s: 30),
  ( cc: [ '{' ]; s: 31),
{ 7: }
  ( cc: [ #1..#8,#11,#12,#14..#31,'"','%','?','`','|'..#255 ]; s: 38),
  ( cc: [ #9,' ','!','#','$','&','+'..'.','0'..'>',
            '@'..'_','a'..'z' ]; s: 34),
  ( cc: [ #10 ]; s: 37),
  ( cc: [ #13 ]; s: 36),
  ( cc: [ '''' ]; s: 39),
  ( cc: [ '(' ]; s: 32),
  ( cc: [ ')' ]; s: 35),
  ( cc: [ '*' ]; s: 33),
  ( cc: [ '/' ]; s: 30),
  ( cc: [ '{' ]; s: 31),
{ 8: }
  ( cc: [ #1..#8,#11,#12,#14..#31,'"','%','?','`','|'..#255 ]; s: 46),
  ( cc: [ #9,' ','!','#','$','&','*'..'.','0'..'>',
            '@'..'_','a'..'z' ]; s: 43),
  ( cc: [ #10 ]; s: 45),
  ( cc: [ #13 ]; s: 44),
  ( cc: [ '''' ]; s: 47),
  ( cc: [ '(' ]; s: 42),
  ( cc: [ ')' ]; s: 48),
  ( cc: [ '/' ]; s: 40),
  ( cc: [ '{' ]; s: 41),
{ 9: }
  ( cc: [ #1..#8,#11,#12,#14..#31,'"','%','?','`','|'..#255 ]; s: 46),
  ( cc: [ #9,' ','!','#','$','&','*'..'.','0'..'>',
            '@'..'_','a'..'z' ]; s: 43),
  ( cc: [ #10 ]; s: 45),
  ( cc: [ #13 ]; s: 44),
  ( cc: [ '''' ]; s: 47),
  ( cc: [ '(' ]; s: 42),
  ( cc: [ ')' ]; s: 48),
  ( cc: [ '/' ]; s: 40),
  ( cc: [ '{' ]; s: 41),
{ 10: }
  ( cc: [ '/' ]; s: 49),
{ 11: }
  ( cc: [ '$' ]; s: 51),
  ( cc: [ '<' ]; s: 50),
{ 12: }
  ( cc: [ '*' ]; s: 52),
{ 13: }
  ( cc: [ #9,' ','!','#','$','&','*'..'.','0'..'>',
            '@'..'_','a'..'z' ]; s: 53),
{ 14: }
  ( cc: [ #1..#9,#11,#12,#14..'&','('..#255 ]; s: 54),
  ( cc: [ #10,'''' ]; s: 55),
  ( cc: [ #13 ]; s: 56),
{ 15: }
{ 16: }
  ( cc: [ #10 ]; s: 17),
{ 17: }
{ 18: }
{ 19: }
  ( cc: [ '/' ]; s: 49),
{ 20: }
  ( cc: [ '$' ]; s: 51),
  ( cc: [ '<' ]; s: 50),
{ 21: }
  ( cc: [ '*' ]; s: 52),
{ 22: }
{ 23: }
  ( cc: [ #9,' ','!','#','$','&','*'..'.','0'..'>',
            '@'..'_','a'..'z' ]; s: 53),
{ 24: }
  ( cc: [ #9,' ','!','#','$','&','*'..'.','0'..'>',
            '@'..'_','a'..'z' ]; s: 53),
{ 25: }
{ 26: }
  ( cc: [ #10 ]; s: 27),
{ 27: }
{ 28: }
{ 29: }
  ( cc: [ #1..#9,#11,#12,#14..'&','('..#255 ]; s: 54),
  ( cc: [ #10,'''' ]; s: 55),
  ( cc: [ #13 ]; s: 56),
{ 30: }
  ( cc: [ '/' ]; s: 49),
{ 31: }
  ( cc: [ '$' ]; s: 51),
  ( cc: [ '<' ]; s: 50),
{ 32: }
  ( cc: [ '*' ]; s: 52),
{ 33: }
  ( cc: [ #9,' ','!','#','$','&','*'..'.','0'..'>',
            '@'..'_','a'..'z' ]; s: 53),
  ( cc: [ ')' ]; s: 57),
{ 34: }
  ( cc: [ #9,' ','!','#','$','&','*'..'.','0'..'>',
            '@'..'_','a'..'z' ]; s: 53),
{ 35: }
{ 36: }
  ( cc: [ #10 ]; s: 37),
{ 37: }
{ 38: }
{ 39: }
  ( cc: [ #1..#9,#11,#12,#14..'&','('..#255 ]; s: 54),
  ( cc: [ #10,'''' ]; s: 55),
  ( cc: [ #13 ]; s: 56),
{ 40: }
  ( cc: [ '/' ]; s: 58),
{ 41: }
  ( cc: [ '$' ]; s: 59),
  ( cc: [ '<' ]; s: 50),
{ 42: }
  ( cc: [ '*' ]; s: 60),
{ 43: }
  ( cc: [ #9,' ','!','#','$','&','*'..'.','0'..'>',
            '@'..'_','a'..'z' ]; s: 61),
{ 44: }
  ( cc: [ #10 ]; s: 45),
{ 45: }
{ 46: }
{ 47: }
  ( cc: [ #1..#9,#11,#12,#14..'&','('..#255 ]; s: 54),
  ( cc: [ #10,'''' ]; s: 55),
  ( cc: [ #13 ]; s: 56),
{ 48: }
{ 49: }
  ( cc: [ #1..#9,#11..#255 ]; s: 49),
{ 50: }
  ( cc: [ '<' ]; s: 63),
  ( cc: [ 'E' ]; s: 62),
{ 51: }
  ( cc: [ #1..'c','f'..'h','j'..'t','v'..'|','~'..#255 ]; s: 68),
  ( cc: [ 'd' ]; s: 65),
  ( cc: [ 'e' ]; s: 67),
  ( cc: [ 'i' ]; s: 64),
  ( cc: [ 'u' ]; s: 66),
{ 52: }
{ 53: }
  ( cc: [ #9,' ','!','#','$','&','*'..'.','0'..'>',
            '@'..'_','a'..'z' ]; s: 53),
{ 54: }
  ( cc: [ #1..#9,#11,#12,#14..'&','('..#255 ]; s: 54),
  ( cc: [ #10,'''' ]; s: 55),
  ( cc: [ #13 ]; s: 56),
{ 55: }
{ 56: }
  ( cc: [ #10 ]; s: 55),
{ 57: }
{ 58: }
  ( cc: [ #1..#9,#11..#255 ]; s: 58),
{ 59: }
  ( cc: [ #1..'c','f'..'h','j'..'t','v'..'|','~'..#255 ]; s: 68),
  ( cc: [ 'd' ]; s: 65),
  ( cc: [ 'e' ]; s: 70),
  ( cc: [ 'i' ]; s: 69),
  ( cc: [ 'u' ]; s: 66),
{ 60: }
{ 61: }
  ( cc: [ #9,' ','!','#','$','&','*'..'.','0'..'>',
            '@'..'_','a'..'z' ]; s: 61),
{ 62: }
  ( cc: [ 'O' ]; s: 71),
{ 63: }
  ( cc: [ 'E' ]; s: 72),
{ 64: }
  ( cc: [ ' ' ]; s: 73),
  ( cc: [ 'f' ]; s: 74),
  ( cc: [ '}' ]; s: 75),
{ 65: }
  ( cc: [ 'e' ]; s: 76),
  ( cc: [ '}' ]; s: 75),
{ 66: }
  ( cc: [ 'n' ]; s: 77),
  ( cc: [ '}' ]; s: 75),
{ 67: }
  ( cc: [ 'l' ]; s: 78),
  ( cc: [ 'n' ]; s: 79),
  ( cc: [ '}' ]; s: 75),
{ 68: }
  ( cc: [ '}' ]; s: 75),
{ 69: }
  ( cc: [ ' ' ]; s: 73),
  ( cc: [ 'f' ]; s: 80),
  ( cc: [ '}' ]; s: 75),
{ 70: }
  ( cc: [ 'l' ]; s: 81),
  ( cc: [ 'n' ]; s: 82),
  ( cc: [ '}' ]; s: 75),
{ 71: }
  ( cc: [ 'F' ]; s: 83),
{ 72: }
  ( cc: [ 'O' ]; s: 84),
{ 73: }
  ( cc: [ #1..'|','~'..#255 ]; s: 85),
{ 74: }
  ( cc: [ 'd' ]; s: 86),
  ( cc: [ 'n' ]; s: 88),
  ( cc: [ 'o' ]; s: 87),
{ 75: }
{ 76: }
  ( cc: [ 'f' ]; s: 89),
{ 77: }
  ( cc: [ 'd' ]; s: 90),
{ 78: }
  ( cc: [ 's' ]; s: 91),
{ 79: }
  ( cc: [ 'd' ]; s: 92),
{ 80: }
  ( cc: [ 'd' ]; s: 93),
  ( cc: [ 'n' ]; s: 95),
  ( cc: [ 'o' ]; s: 94),
{ 81: }
  ( cc: [ 's' ]; s: 96),
{ 82: }
  ( cc: [ 'd' ]; s: 97),
{ 83: }
  ( cc: [ '>' ]; s: 98),
{ 84: }
  ( cc: [ 'F' ]; s: 99),
{ 85: }
  ( cc: [ #1..'|','~'..#255 ]; s: 85),
  ( cc: [ '}' ]; s: 100),
{ 86: }
  ( cc: [ 'e' ]; s: 101),
{ 87: }
  ( cc: [ 'p' ]; s: 102),
{ 88: }
  ( cc: [ 'd' ]; s: 103),
{ 89: }
  ( cc: [ 'i' ]; s: 104),
{ 90: }
  ( cc: [ 'e' ]; s: 105),
{ 91: }
  ( cc: [ 'e' ]; s: 106),
{ 92: }
  ( cc: [ 'i' ]; s: 107),
{ 93: }
  ( cc: [ 'e' ]; s: 108),
{ 94: }
  ( cc: [ 'p' ]; s: 109),
{ 95: }
  ( cc: [ 'd' ]; s: 110),
{ 96: }
  ( cc: [ 'e' ]; s: 111),
{ 97: }
  ( cc: [ 'i' ]; s: 112),
{ 98: }
{ 99: }
  ( cc: [ '>' ]; s: 113),
{ 100: }
{ 101: }
  ( cc: [ 'f' ]; s: 114),
{ 102: }
  ( cc: [ 't' ]; s: 115),
{ 103: }
  ( cc: [ 'e' ]; s: 116),
{ 104: }
  ( cc: [ 'n' ]; s: 117),
{ 105: }
  ( cc: [ 'f' ]; s: 118),
{ 106: }
  ( cc: [ #1..'|','~'..#255 ]; s: 106),
  ( cc: [ '}' ]; s: 119),
{ 107: }
  ( cc: [ 'f' ]; s: 120),
{ 108: }
  ( cc: [ 'f' ]; s: 121),
{ 109: }
  ( cc: [ 't' ]; s: 122),
{ 110: }
  ( cc: [ 'e' ]; s: 123),
{ 111: }
  ( cc: [ #1..'|','~'..#255 ]; s: 111),
  ( cc: [ '}' ]; s: 124),
{ 112: }
  ( cc: [ 'f' ]; s: 125),
{ 113: }
  ( cc: [ '>' ]; s: 126),
{ 114: }
  ( cc: [ ' ' ]; s: 127),
{ 115: }
  ( cc: [ ' ' ]; s: 128),
{ 116: }
  ( cc: [ 'f' ]; s: 129),
{ 117: }
  ( cc: [ 'e' ]; s: 130),
{ 118: }
  ( cc: [ ' ' ]; s: 131),
{ 119: }
{ 120: }
  ( cc: [ #1..'|','~'..#255 ]; s: 120),
  ( cc: [ '}' ]; s: 132),
{ 121: }
  ( cc: [ ' ' ]; s: 133),
{ 122: }
  ( cc: [ ' ' ]; s: 134),
{ 123: }
  ( cc: [ 'f' ]; s: 135),
{ 124: }
{ 125: }
  ( cc: [ #1..'|','~'..#255 ]; s: 125),
  ( cc: [ '}' ]; s: 136),
{ 126: }
{ 127: }
  ( cc: [ #1..'|','~'..#255 ]; s: 137),
{ 128: }
  ( cc: [ #1..'|','~'..#255 ]; s: 138),
{ 129: }
  ( cc: [ ' ' ]; s: 139),
{ 130: }
  ( cc: [ ' ' ]; s: 140),
{ 131: }
  ( cc: [ #1..'|','~'..#255 ]; s: 141),
{ 132: }
{ 133: }
  ( cc: [ #1..'|','~'..#255 ]; s: 142),
{ 134: }
  ( cc: [ #1..'|','~'..#255 ]; s: 143),
{ 135: }
  ( cc: [ ' ' ]; s: 144),
{ 136: }
{ 137: }
  ( cc: [ #1..'|','~'..#255 ]; s: 137),
  ( cc: [ '}' ]; s: 145),
{ 138: }
  ( cc: [ #1..'|','~'..#255 ]; s: 138),
  ( cc: [ '}' ]; s: 146),
{ 139: }
  ( cc: [ #1..'|','~'..#255 ]; s: 147),
{ 140: }
  ( cc: [ #1..'|','~'..#255 ]; s: 148),
{ 141: }
  ( cc: [ #1..'|','~'..#255 ]; s: 141),
  ( cc: [ '}' ]; s: 149),
{ 142: }
  ( cc: [ #1..'|','~'..#255 ]; s: 142),
  ( cc: [ '}' ]; s: 150),
{ 143: }
  ( cc: [ #1..'|','~'..#255 ]; s: 143),
  ( cc: [ '}' ]; s: 151),
{ 144: }
  ( cc: [ #1..'|','~'..#255 ]; s: 152),
{ 145: }
{ 146: }
{ 147: }
  ( cc: [ #1..'|','~'..#255 ]; s: 147),
  ( cc: [ '}' ]; s: 153),
{ 148: }
  ( cc: [ #1..'|','~'..#255 ]; s: 148),
  ( cc: [ '}' ]; s: 154),
{ 149: }
{ 150: }
{ 151: }
{ 152: }
  ( cc: [ #1..'|','~'..#255 ]; s: 152),
  ( cc: [ '}' ]; s: 155)
{ 153: }
{ 154: }
{ 155: }
);

yykl : array [0..yynstates-1] of Integer = (
{ 0: } 1,
{ 1: } 1,
{ 2: } 1,
{ 3: } 1,
{ 4: } 1,
{ 5: } 1,
{ 6: } 1,
{ 7: } 1,
{ 8: } 1,
{ 9: } 1,
{ 10: } 1,
{ 11: } 3,
{ 12: } 6,
{ 13: } 8,
{ 14: } 10,
{ 15: } 11,
{ 16: } 13,
{ 17: } 15,
{ 18: } 16,
{ 19: } 17,
{ 20: } 20,
{ 21: } 24,
{ 22: } 27,
{ 23: } 30,
{ 24: } 34,
{ 25: } 39,
{ 26: } 43,
{ 27: } 47,
{ 28: } 49,
{ 29: } 51,
{ 30: } 54,
{ 31: } 57,
{ 32: } 61,
{ 33: } 64,
{ 34: } 69,
{ 35: } 73,
{ 36: } 77,
{ 37: } 81,
{ 38: } 83,
{ 39: } 85,
{ 40: } 88,
{ 41: } 91,
{ 42: } 96,
{ 43: } 99,
{ 44: } 103,
{ 45: } 107,
{ 46: } 109,
{ 47: } 111,
{ 48: } 113,
{ 49: } 116,
{ 50: } 117,
{ 51: } 117,
{ 52: } 117,
{ 53: } 118,
{ 54: } 119,
{ 55: } 119,
{ 56: } 120,
{ 57: } 121,
{ 58: } 122,
{ 59: } 124,
{ 60: } 124,
{ 61: } 126,
{ 62: } 128,
{ 63: } 128,
{ 64: } 128,
{ 65: } 128,
{ 66: } 128,
{ 67: } 128,
{ 68: } 128,
{ 69: } 128,
{ 70: } 128,
{ 71: } 128,
{ 72: } 128,
{ 73: } 128,
{ 74: } 128,
{ 75: } 128,
{ 76: } 129,
{ 77: } 129,
{ 78: } 129,
{ 79: } 129,
{ 80: } 129,
{ 81: } 129,
{ 82: } 129,
{ 83: } 129,
{ 84: } 129,
{ 85: } 129,
{ 86: } 129,
{ 87: } 129,
{ 88: } 129,
{ 89: } 129,
{ 90: } 129,
{ 91: } 129,
{ 92: } 129,
{ 93: } 129,
{ 94: } 129,
{ 95: } 129,
{ 96: } 129,
{ 97: } 129,
{ 98: } 129,
{ 99: } 130,
{ 100: } 130,
{ 101: } 131,
{ 102: } 131,
{ 103: } 131,
{ 104: } 131,
{ 105: } 131,
{ 106: } 131,
{ 107: } 131,
{ 108: } 131,
{ 109: } 131,
{ 110: } 131,
{ 111: } 131,
{ 112: } 131,
{ 113: } 131,
{ 114: } 131,
{ 115: } 131,
{ 116: } 131,
{ 117: } 131,
{ 118: } 131,
{ 119: } 131,
{ 120: } 132,
{ 121: } 132,
{ 122: } 132,
{ 123: } 132,
{ 124: } 132,
{ 125: } 134,
{ 126: } 134,
{ 127: } 135,
{ 128: } 135,
{ 129: } 135,
{ 130: } 135,
{ 131: } 135,
{ 132: } 135,
{ 133: } 136,
{ 134: } 136,
{ 135: } 136,
{ 136: } 136,
{ 137: } 138,
{ 138: } 138,
{ 139: } 138,
{ 140: } 138,
{ 141: } 138,
{ 142: } 138,
{ 143: } 138,
{ 144: } 138,
{ 145: } 138,
{ 146: } 139,
{ 147: } 140,
{ 148: } 140,
{ 149: } 140,
{ 150: } 141,
{ 151: } 143,
{ 152: } 145,
{ 153: } 145,
{ 154: } 146,
{ 155: } 147
);

yykh : array [0..yynstates-1] of Integer = (
{ 0: } 0,
{ 1: } 0,
{ 2: } 0,
{ 3: } 0,
{ 4: } 0,
{ 5: } 0,
{ 6: } 0,
{ 7: } 0,
{ 8: } 0,
{ 9: } 0,
{ 10: } 2,
{ 11: } 5,
{ 12: } 7,
{ 13: } 9,
{ 14: } 10,
{ 15: } 12,
{ 16: } 14,
{ 17: } 15,
{ 18: } 16,
{ 19: } 19,
{ 20: } 23,
{ 21: } 26,
{ 22: } 29,
{ 23: } 33,
{ 24: } 38,
{ 25: } 42,
{ 26: } 46,
{ 27: } 48,
{ 28: } 50,
{ 29: } 53,
{ 30: } 56,
{ 31: } 60,
{ 32: } 63,
{ 33: } 68,
{ 34: } 72,
{ 35: } 76,
{ 36: } 80,
{ 37: } 82,
{ 38: } 84,
{ 39: } 87,
{ 40: } 90,
{ 41: } 95,
{ 42: } 98,
{ 43: } 102,
{ 44: } 106,
{ 45: } 108,
{ 46: } 110,
{ 47: } 112,
{ 48: } 115,
{ 49: } 116,
{ 50: } 116,
{ 51: } 116,
{ 52: } 117,
{ 53: } 118,
{ 54: } 118,
{ 55: } 119,
{ 56: } 120,
{ 57: } 121,
{ 58: } 123,
{ 59: } 123,
{ 60: } 125,
{ 61: } 127,
{ 62: } 127,
{ 63: } 127,
{ 64: } 127,
{ 65: } 127,
{ 66: } 127,
{ 67: } 127,
{ 68: } 127,
{ 69: } 127,
{ 70: } 127,
{ 71: } 127,
{ 72: } 127,
{ 73: } 127,
{ 74: } 127,
{ 75: } 128,
{ 76: } 128,
{ 77: } 128,
{ 78: } 128,
{ 79: } 128,
{ 80: } 128,
{ 81: } 128,
{ 82: } 128,
{ 83: } 128,
{ 84: } 128,
{ 85: } 128,
{ 86: } 128,
{ 87: } 128,
{ 88: } 128,
{ 89: } 128,
{ 90: } 128,
{ 91: } 128,
{ 92: } 128,
{ 93: } 128,
{ 94: } 128,
{ 95: } 128,
{ 96: } 128,
{ 97: } 128,
{ 98: } 129,
{ 99: } 129,
{ 100: } 130,
{ 101: } 130,
{ 102: } 130,
{ 103: } 130,
{ 104: } 130,
{ 105: } 130,
{ 106: } 130,
{ 107: } 130,
{ 108: } 130,
{ 109: } 130,
{ 110: } 130,
{ 111: } 130,
{ 112: } 130,
{ 113: } 130,
{ 114: } 130,
{ 115: } 130,
{ 116: } 130,
{ 117: } 130,
{ 118: } 130,
{ 119: } 131,
{ 120: } 131,
{ 121: } 131,
{ 122: } 131,
{ 123: } 131,
{ 124: } 133,
{ 125: } 133,
{ 126: } 134,
{ 127: } 134,
{ 128: } 134,
{ 129: } 134,
{ 130: } 134,
{ 131: } 134,
{ 132: } 135,
{ 133: } 135,
{ 134: } 135,
{ 135: } 135,
{ 136: } 137,
{ 137: } 137,
{ 138: } 137,
{ 139: } 137,
{ 140: } 137,
{ 141: } 137,
{ 142: } 137,
{ 143: } 137,
{ 144: } 137,
{ 145: } 138,
{ 146: } 139,
{ 147: } 139,
{ 148: } 139,
{ 149: } 140,
{ 150: } 142,
{ 151: } 144,
{ 152: } 144,
{ 153: } 145,
{ 154: } 146,
{ 155: } 148
);

yyml : array [0..yynstates-1] of Integer = (
{ 0: } 1,
{ 1: } 1,
{ 2: } 1,
{ 3: } 1,
{ 4: } 1,
{ 5: } 1,
{ 6: } 1,
{ 7: } 1,
{ 8: } 1,
{ 9: } 1,
{ 10: } 1,
{ 11: } 3,
{ 12: } 6,
{ 13: } 8,
{ 14: } 10,
{ 15: } 11,
{ 16: } 13,
{ 17: } 15,
{ 18: } 16,
{ 19: } 17,
{ 20: } 20,
{ 21: } 24,
{ 22: } 27,
{ 23: } 30,
{ 24: } 34,
{ 25: } 39,
{ 26: } 43,
{ 27: } 47,
{ 28: } 49,
{ 29: } 51,
{ 30: } 54,
{ 31: } 57,
{ 32: } 61,
{ 33: } 64,
{ 34: } 69,
{ 35: } 73,
{ 36: } 77,
{ 37: } 81,
{ 38: } 83,
{ 39: } 85,
{ 40: } 88,
{ 41: } 91,
{ 42: } 96,
{ 43: } 99,
{ 44: } 103,
{ 45: } 107,
{ 46: } 109,
{ 47: } 111,
{ 48: } 113,
{ 49: } 116,
{ 50: } 117,
{ 51: } 117,
{ 52: } 117,
{ 53: } 118,
{ 54: } 119,
{ 55: } 119,
{ 56: } 120,
{ 57: } 121,
{ 58: } 122,
{ 59: } 124,
{ 60: } 124,
{ 61: } 126,
{ 62: } 128,
{ 63: } 128,
{ 64: } 128,
{ 65: } 128,
{ 66: } 128,
{ 67: } 128,
{ 68: } 128,
{ 69: } 128,
{ 70: } 128,
{ 71: } 128,
{ 72: } 128,
{ 73: } 128,
{ 74: } 128,
{ 75: } 128,
{ 76: } 129,
{ 77: } 129,
{ 78: } 129,
{ 79: } 129,
{ 80: } 129,
{ 81: } 129,
{ 82: } 129,
{ 83: } 129,
{ 84: } 129,
{ 85: } 129,
{ 86: } 129,
{ 87: } 129,
{ 88: } 129,
{ 89: } 129,
{ 90: } 129,
{ 91: } 129,
{ 92: } 129,
{ 93: } 129,
{ 94: } 129,
{ 95: } 129,
{ 96: } 129,
{ 97: } 129,
{ 98: } 129,
{ 99: } 130,
{ 100: } 130,
{ 101: } 131,
{ 102: } 131,
{ 103: } 131,
{ 104: } 131,
{ 105: } 131,
{ 106: } 131,
{ 107: } 131,
{ 108: } 131,
{ 109: } 131,
{ 110: } 131,
{ 111: } 131,
{ 112: } 131,
{ 113: } 131,
{ 114: } 131,
{ 115: } 131,
{ 116: } 131,
{ 117: } 131,
{ 118: } 131,
{ 119: } 131,
{ 120: } 132,
{ 121: } 132,
{ 122: } 132,
{ 123: } 132,
{ 124: } 132,
{ 125: } 134,
{ 126: } 134,
{ 127: } 135,
{ 128: } 135,
{ 129: } 135,
{ 130: } 135,
{ 131: } 135,
{ 132: } 135,
{ 133: } 136,
{ 134: } 136,
{ 135: } 136,
{ 136: } 136,
{ 137: } 138,
{ 138: } 138,
{ 139: } 138,
{ 140: } 138,
{ 141: } 138,
{ 142: } 138,
{ 143: } 138,
{ 144: } 138,
{ 145: } 138,
{ 146: } 139,
{ 147: } 140,
{ 148: } 140,
{ 149: } 140,
{ 150: } 141,
{ 151: } 143,
{ 152: } 145,
{ 153: } 145,
{ 154: } 146,
{ 155: } 147
);

yymh : array [0..yynstates-1] of Integer = (
{ 0: } 0,
{ 1: } 0,
{ 2: } 0,
{ 3: } 0,
{ 4: } 0,
{ 5: } 0,
{ 6: } 0,
{ 7: } 0,
{ 8: } 0,
{ 9: } 0,
{ 10: } 2,
{ 11: } 5,
{ 12: } 7,
{ 13: } 9,
{ 14: } 10,
{ 15: } 12,
{ 16: } 14,
{ 17: } 15,
{ 18: } 16,
{ 19: } 19,
{ 20: } 23,
{ 21: } 26,
{ 22: } 29,
{ 23: } 33,
{ 24: } 38,
{ 25: } 42,
{ 26: } 46,
{ 27: } 48,
{ 28: } 50,
{ 29: } 53,
{ 30: } 56,
{ 31: } 60,
{ 32: } 63,
{ 33: } 68,
{ 34: } 72,
{ 35: } 76,
{ 36: } 80,
{ 37: } 82,
{ 38: } 84,
{ 39: } 87,
{ 40: } 90,
{ 41: } 95,
{ 42: } 98,
{ 43: } 102,
{ 44: } 106,
{ 45: } 108,
{ 46: } 110,
{ 47: } 112,
{ 48: } 115,
{ 49: } 116,
{ 50: } 116,
{ 51: } 116,
{ 52: } 117,
{ 53: } 118,
{ 54: } 118,
{ 55: } 119,
{ 56: } 120,
{ 57: } 121,
{ 58: } 123,
{ 59: } 123,
{ 60: } 125,
{ 61: } 127,
{ 62: } 127,
{ 63: } 127,
{ 64: } 127,
{ 65: } 127,
{ 66: } 127,
{ 67: } 127,
{ 68: } 127,
{ 69: } 127,
{ 70: } 127,
{ 71: } 127,
{ 72: } 127,
{ 73: } 127,
{ 74: } 127,
{ 75: } 128,
{ 76: } 128,
{ 77: } 128,
{ 78: } 128,
{ 79: } 128,
{ 80: } 128,
{ 81: } 128,
{ 82: } 128,
{ 83: } 128,
{ 84: } 128,
{ 85: } 128,
{ 86: } 128,
{ 87: } 128,
{ 88: } 128,
{ 89: } 128,
{ 90: } 128,
{ 91: } 128,
{ 92: } 128,
{ 93: } 128,
{ 94: } 128,
{ 95: } 128,
{ 96: } 128,
{ 97: } 128,
{ 98: } 129,
{ 99: } 129,
{ 100: } 130,
{ 101: } 130,
{ 102: } 130,
{ 103: } 130,
{ 104: } 130,
{ 105: } 130,
{ 106: } 130,
{ 107: } 130,
{ 108: } 130,
{ 109: } 130,
{ 110: } 130,
{ 111: } 130,
{ 112: } 130,
{ 113: } 130,
{ 114: } 130,
{ 115: } 130,
{ 116: } 130,
{ 117: } 130,
{ 118: } 130,
{ 119: } 131,
{ 120: } 131,
{ 121: } 131,
{ 122: } 131,
{ 123: } 131,
{ 124: } 133,
{ 125: } 133,
{ 126: } 134,
{ 127: } 134,
{ 128: } 134,
{ 129: } 134,
{ 130: } 134,
{ 131: } 134,
{ 132: } 135,
{ 133: } 135,
{ 134: } 135,
{ 135: } 135,
{ 136: } 137,
{ 137: } 137,
{ 138: } 137,
{ 139: } 137,
{ 140: } 137,
{ 141: } 137,
{ 142: } 137,
{ 143: } 137,
{ 144: } 137,
{ 145: } 138,
{ 146: } 139,
{ 147: } 139,
{ 148: } 139,
{ 149: } 140,
{ 150: } 142,
{ 151: } 144,
{ 152: } 144,
{ 153: } 145,
{ 154: } 146,
{ 155: } 148
);

yytl : array [0..yynstates-1] of Integer = (
{ 0: } 1,
{ 1: } 10,
{ 2: } 19,
{ 3: } 28,
{ 4: } 37,
{ 5: } 48,
{ 6: } 59,
{ 7: } 69,
{ 8: } 79,
{ 9: } 88,
{ 10: } 97,
{ 11: } 98,
{ 12: } 100,
{ 13: } 101,
{ 14: } 102,
{ 15: } 105,
{ 16: } 105,
{ 17: } 106,
{ 18: } 106,
{ 19: } 106,
{ 20: } 107,
{ 21: } 109,
{ 22: } 110,
{ 23: } 110,
{ 24: } 111,
{ 25: } 112,
{ 26: } 112,
{ 27: } 113,
{ 28: } 113,
{ 29: } 113,
{ 30: } 116,
{ 31: } 117,
{ 32: } 119,
{ 33: } 120,
{ 34: } 122,
{ 35: } 123,
{ 36: } 123,
{ 37: } 124,
{ 38: } 124,
{ 39: } 124,
{ 40: } 127,
{ 41: } 128,
{ 42: } 130,
{ 43: } 131,
{ 44: } 132,
{ 45: } 133,
{ 46: } 133,
{ 47: } 133,
{ 48: } 136,
{ 49: } 136,
{ 50: } 137,
{ 51: } 139,
{ 52: } 144,
{ 53: } 144,
{ 54: } 145,
{ 55: } 148,
{ 56: } 148,
{ 57: } 149,
{ 58: } 149,
{ 59: } 150,
{ 60: } 155,
{ 61: } 155,
{ 62: } 156,
{ 63: } 157,
{ 64: } 158,
{ 65: } 161,
{ 66: } 163,
{ 67: } 165,
{ 68: } 168,
{ 69: } 169,
{ 70: } 172,
{ 71: } 175,
{ 72: } 176,
{ 73: } 177,
{ 74: } 178,
{ 75: } 181,
{ 76: } 181,
{ 77: } 182,
{ 78: } 183,
{ 79: } 184,
{ 80: } 185,
{ 81: } 188,
{ 82: } 189,
{ 83: } 190,
{ 84: } 191,
{ 85: } 192,
{ 86: } 194,
{ 87: } 195,
{ 88: } 196,
{ 89: } 197,
{ 90: } 198,
{ 91: } 199,
{ 92: } 200,
{ 93: } 201,
{ 94: } 202,
{ 95: } 203,
{ 96: } 204,
{ 97: } 205,
{ 98: } 206,
{ 99: } 206,
{ 100: } 207,
{ 101: } 207,
{ 102: } 208,
{ 103: } 209,
{ 104: } 210,
{ 105: } 211,
{ 106: } 212,
{ 107: } 214,
{ 108: } 215,
{ 109: } 216,
{ 110: } 217,
{ 111: } 218,
{ 112: } 220,
{ 113: } 221,
{ 114: } 222,
{ 115: } 223,
{ 116: } 224,
{ 117: } 225,
{ 118: } 226,
{ 119: } 227,
{ 120: } 227,
{ 121: } 229,
{ 122: } 230,
{ 123: } 231,
{ 124: } 232,
{ 125: } 232,
{ 126: } 234,
{ 127: } 234,
{ 128: } 235,
{ 129: } 236,
{ 130: } 237,
{ 131: } 238,
{ 132: } 239,
{ 133: } 239,
{ 134: } 240,
{ 135: } 241,
{ 136: } 242,
{ 137: } 242,
{ 138: } 244,
{ 139: } 246,
{ 140: } 247,
{ 141: } 248,
{ 142: } 250,
{ 143: } 252,
{ 144: } 254,
{ 145: } 255,
{ 146: } 255,
{ 147: } 255,
{ 148: } 257,
{ 149: } 259,
{ 150: } 259,
{ 151: } 259,
{ 152: } 259,
{ 153: } 261,
{ 154: } 261,
{ 155: } 261
);

yyth : array [0..yynstates-1] of Integer = (
{ 0: } 9,
{ 1: } 18,
{ 2: } 27,
{ 3: } 36,
{ 4: } 47,
{ 5: } 58,
{ 6: } 68,
{ 7: } 78,
{ 8: } 87,
{ 9: } 96,
{ 10: } 97,
{ 11: } 99,
{ 12: } 100,
{ 13: } 101,
{ 14: } 104,
{ 15: } 104,
{ 16: } 105,
{ 17: } 105,
{ 18: } 105,
{ 19: } 106,
{ 20: } 108,
{ 21: } 109,
{ 22: } 109,
{ 23: } 110,
{ 24: } 111,
{ 25: } 111,
{ 26: } 112,
{ 27: } 112,
{ 28: } 112,
{ 29: } 115,
{ 30: } 116,
{ 31: } 118,
{ 32: } 119,
{ 33: } 121,
{ 34: } 122,
{ 35: } 122,
{ 36: } 123,
{ 37: } 123,
{ 38: } 123,
{ 39: } 126,
{ 40: } 127,
{ 41: } 129,
{ 42: } 130,
{ 43: } 131,
{ 44: } 132,
{ 45: } 132,
{ 46: } 132,
{ 47: } 135,
{ 48: } 135,
{ 49: } 136,
{ 50: } 138,
{ 51: } 143,
{ 52: } 143,
{ 53: } 144,
{ 54: } 147,
{ 55: } 147,
{ 56: } 148,
{ 57: } 148,
{ 58: } 149,
{ 59: } 154,
{ 60: } 154,
{ 61: } 155,
{ 62: } 156,
{ 63: } 157,
{ 64: } 160,
{ 65: } 162,
{ 66: } 164,
{ 67: } 167,
{ 68: } 168,
{ 69: } 171,
{ 70: } 174,
{ 71: } 175,
{ 72: } 176,
{ 73: } 177,
{ 74: } 180,
{ 75: } 180,
{ 76: } 181,
{ 77: } 182,
{ 78: } 183,
{ 79: } 184,
{ 80: } 187,
{ 81: } 188,
{ 82: } 189,
{ 83: } 190,
{ 84: } 191,
{ 85: } 193,
{ 86: } 194,
{ 87: } 195,
{ 88: } 196,
{ 89: } 197,
{ 90: } 198,
{ 91: } 199,
{ 92: } 200,
{ 93: } 201,
{ 94: } 202,
{ 95: } 203,
{ 96: } 204,
{ 97: } 205,
{ 98: } 205,
{ 99: } 206,
{ 100: } 206,
{ 101: } 207,
{ 102: } 208,
{ 103: } 209,
{ 104: } 210,
{ 105: } 211,
{ 106: } 213,
{ 107: } 214,
{ 108: } 215,
{ 109: } 216,
{ 110: } 217,
{ 111: } 219,
{ 112: } 220,
{ 113: } 221,
{ 114: } 222,
{ 115: } 223,
{ 116: } 224,
{ 117: } 225,
{ 118: } 226,
{ 119: } 226,
{ 120: } 228,
{ 121: } 229,
{ 122: } 230,
{ 123: } 231,
{ 124: } 231,
{ 125: } 233,
{ 126: } 233,
{ 127: } 234,
{ 128: } 235,
{ 129: } 236,
{ 130: } 237,
{ 131: } 238,
{ 132: } 238,
{ 133: } 239,
{ 134: } 240,
{ 135: } 241,
{ 136: } 241,
{ 137: } 243,
{ 138: } 245,
{ 139: } 246,
{ 140: } 247,
{ 141: } 249,
{ 142: } 251,
{ 143: } 253,
{ 144: } 254,
{ 145: } 254,
{ 146: } 254,
{ 147: } 256,
{ 148: } 258,
{ 149: } 258,
{ 150: } 258,
{ 151: } 258,
{ 152: } 260,
{ 153: } 260,
{ 154: } 260,
{ 155: } 260
);


Function PascalPreProcessor.Parse():Integer;
var yyn : Integer;

label start, scan, action;

begin

start:

  (* initialize: *)

  yynew;

scan:

  (* mark positions and matches: *)

  for yyn := yykl[yystate] to     yykh[yystate] do yymark(yyk[yyn]);
  for yyn := yymh[yystate] downto yyml[yystate] do yymatch(yym[yyn]);

  if yytl[yystate]>yyth[yystate] then goto action; (* dead state *)

  (* get next character: *)

  yyscan;

  (* determine action: *)

  yyn := yytl[yystate];
  while (yyn<=yyth[yystate]) and not (yyactchar in yyt[yyn].cc) do inc(yyn);
  if yyn>yyth[yystate] then goto action;
    (* no transition on yyactchar in this state *)

  (* switch to new state: *)

  yystate := yyt[yyn].s;

  goto scan;

action:

  (* execute action: *)

  if yyfind(yyrule) then
    begin
      yyaction(yyrule);
      if yyreject then goto action;
    end
  else if not yydefault and yywrap then
    begin
      yyclear;
      return(0);
    end;

  if not yydone then goto start;

  Result := yyretval;

end(*yylex*);

End.
