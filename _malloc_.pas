
unit _malloc_;

interface

function malloc(Size:integer):pChar; cdecl; external 'msvcrt.dll';
procedure free(ptr:pChar); cdecl; external 'msvcrt.dll';

implementation
 
end.
