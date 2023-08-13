////////////////////////////////////////////////////////
//                                                    //
//           General prupose BLOB functions           //
//     Copyright 2004-2023 Lagodrom Solutions Ltd     //
//    Portion copyright 1997,1998 Gregory H. Deatz    //
//                All rights reserved                 //
//                                                    //
////////////////////////////////////////////////////////

unit LS_BlobFunc;

interface

uses
  Windows,
  SysUtils,
  ib_util;

type
  Int   =longint;  // 32 bit signed
  Long  =longint;  // 32 bit signed
  uShort=word;     // 16 bit unsigned
  { --- pointer types --- }
  pInt    =^Int;
  pInteger=^integer;


type
  tISC_BlobGetSegment=function(BlobHandle:pInt;
                               Buffer:pChar;
                               BufferSize:uShort;
                               var ResultLength:uShort):short; cdecl;

  tISC_BlobPutSegment=procedure(BlobHandle:pInt;
                                Buffer:pChar;
                                BufferLength:short); cdecl;
  pBlob=^tBlob;
  tBlob=record
   GetSegment         :tISC_BlobGetSegment;
   BlobHandle         :pInt;
   SegmentCount       :long;
   MaxSegmentLength   :long;
   TotalSize          :long;
   PutSegment         :tISC_BlobPutSegment;
  end;

(******************************************************************
Вернет содержимое BLOB в виде CString(32700)

NOTE: проверка на размер BLOB отсутствует
----------------------------
declare external function udfBlobAsPChar
  blob
returns
  CString(32700) free_it
entry_point 'BlobAsPChar'
module_name 'ad_UDF';
******************************************************************)
function BlobAsPChar(Blob:pBlob):pChar; cdecl; export;

(******************************************************************
Запихивает строку S в BLOB
----------------------------
declare external function udfStrToBlob
 CString(32700),
 blob
returns
 parameter 2
entry_point 'StrToBlob'
module_name 'ad_UDF';
******************************************************************)
function StrToBlob(s:pChar; Blob:pBlob):pBlob; cdecl; export;

(******************************************************************
Вернет длину BLOB`а
----------------------------
declare external function udfBlobLen
 blob
returns
 integer by value
entry_point 'BlobLen'
module_name 'ad_UDF';
******************************************************************)
function BlobLen(Blob:pBlob):integer; cdecl; export;

function BlobAsString(Blob:pBlob):string;
{ returns BLOB as STRING }

implementation

function BlobAsPChar(Blob:pBlob):pChar; cdecl; export;
var
  Bytes_Read,BufSize:uShort;
  Total_Bytes_Read:long;
  res:short;

begin
  Result:=nil;

  if (not Assigned(Blob)) or
     (not Assigned(Blob^.BlobHandle)) then exit;

  with Blob^ do begin
    // bytes_left:=TotalSize;         // I have TotalSize bytes to read.
    BufSize:=MaxSegmentLength;        // char and varchar can't handle more bytes;
    if (TotalSize =0) then exit;      // if I've nothing to copy, exit.
    //SetString(st,nil,TotalSize);
    Result:=ib_util_malloc(TotalSize);  // read whole blob
    Total_Bytes_Read:=0;                // total bytes read is 0.

    repeat
      // Using BlobHandle, store at most "bytes_left" bytes in
      // the buffer starting where I last left off
      res:=GetSegment(BlobHandle,@Result[Total_Bytes_Read],BufSize,Bytes_Read);
      // Increment Total_Bytes_Read by the number of bytes actually read.
      Inc(Total_Bytes_Read,Bytes_Read);
    until TotalSize <=Total_Bytes_Read;
  end;
end;

function StrToBlob(s:pChar; Blob:pBlob):pBlob; cdecl; export;
begin
  Result:=Blob;
  if Assigned(Blob) and Assigned(Blob^.BlobHandle) then
    Blob^.PutSegment(Blob^.BlobHandle,s,StrLen(s));
end;

function BlobAsString(Blob:pBlob):string;
{ returns BLOB as STRING }
var
  Bytes_Read,BufSize:uShort;
  Total_Bytes_Read:long;
  res:short;

begin
  Result:='';

  if (not Assigned(Blob)) or
     (not Assigned(Blob^.BlobHandle)) then exit;

  with Blob^ do begin
    if (TotalSize =0) then exit;      // if I've nothing to copy, exit.

    BufSize:=MaxSegmentLength;        // char and varchar can't handle more bytes;
    SetString(Result,nil,TotalSize);
    
    Total_Bytes_Read:=0;              // total bytes read is 0.

    repeat
      // Using BlobHandle, store at most "bytes_left" bytes in
      // the buffer starting where I last left off
      res:=GetSegment(BlobHandle,@Result[Total_Bytes_Read+1],BufSize,Bytes_Read);
      // Increment Total_Bytes_Read by the number of bytes actually read.
      Inc(Total_Bytes_Read,Bytes_Read);
     until TotalSize <=Total_Bytes_Read;
  end;
end;

function BlobLen(Blob:pBlob):integer; cdecl; export;
begin
  if Assigned(Blob) and Assigned(Blob^.BlobHandle) then
    Result:=Blob^.TotalSize
  else
    Result:=0;
end;

end.
