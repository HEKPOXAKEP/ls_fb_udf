//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//
//                                              //
//         UDF для InterBase (FireBird)         //
//            Version 0.01.03/g0811             //
//  Copyright 2001-2023 Lagodrom Solutions Ltd  //
//            All rights reserved               //
//                                              //
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//

{$I-}

library ls_fb_udf;

uses
  Windows,
  SysUtils,
  ib_util,
  //StrUtils,
  //DateUtil,
  LS_BlobFunc;

const
  sLibVer='0.01.03/g0811(2023)';

const
  Crc32Table:array[0..255] of cardinal=(
    $00000000,$77073096,$ee0e612c,$990951ba,$076dc419,$706af48f,$e963a535,
    $9e6495a3,$0edb8832,$79dcb8a4,$e0d5e91e,$97d2d988,$09b64c2b,$7eb17cbd,
    $e7b82d07,$90bf1d91,$1db71064,$6ab020f2,$f3b97148,$84be41de,$1adad47d,
    $6ddde4eb,$f4d4b551,$83d385c7,$136c9856,$646ba8c0,$fd62f97a,$8a65c9ec,
    $14015c4f,$63066cd9,$fa0f3d63,$8d080df5,$3b6e20c8,$4c69105e,$d56041e4,
    $a2677172,$3c03e4d1,$4b04d447,$d20d85fd,$a50ab56b,$35b5a8fa,$42b2986c,
    $dbbbc9d6,$acbcf940,$32d86ce3,$45df5c75,$dcd60dcf,$abd13d59,$26d930ac,
    $51de003a,$c8d75180,$bfd06116,$21b4f4b5,$56b3c423,$cfba9599,$b8bda50f,
    $2802b89e,$5f058808,$c60cd9b2,$b10be924,$2f6f7c87,$58684c11,$c1611dab,
    $b6662d3d,$76dc4190,$01db7106,$98d220bc,$efd5102a,$71b18589,$06b6b51f,
    $9fbfe4a5,$e8b8d433,$7807c9a2,$0f00f934,$9609a88e,$e10e9818,$7f6a0dbb,
    $086d3d2d,$91646c97,$e6635c01,$6b6b51f4,$1c6c6162,$856530d8,$f262004e,
    $6c0695ed,$1b01a57b,$8208f4c1,$f50fc457,$65b0d9c6,$12b7e950,$8bbeb8ea,
    $fcb9887c,$62dd1ddf,$15da2d49,$8cd37cf3,$fbd44c65,$4db26158,$3ab551ce,
    $a3bc0074,$d4bb30e2,$4adfa541,$3dd895d7,$a4d1c46d,$d3d6f4fb,$4369e96a,
    $346ed9fc,$ad678846,$da60b8d0,$44042d73,$33031de5,$aa0a4c5f,$dd0d7cc9,
    $5005713c,$270241aa,$be0b1010,$c90c2086,$5768b525,$206f85b3,$b966d409,
    $ce61e49f,$5edef90e,$29d9c998,$b0d09822,$c7d7a8b4,$59b33d17,$2eb40d81,
    $b7bd5c3b,$c0ba6cad,$edb88320,$9abfb3b6,$03b6e20c,$74b1d29a,$ead54739,
    $9dd277af,$04db2615,$73dc1683,$e3630b12,$94643b84,$0d6d6a3e,$7a6a5aa8,
    $e40ecf0b,$9309ff9d,$0a00ae27,$7d079eb1,$f00f9344,$8708a3d2,$1e01f268,
    $6906c2fe,$f762575d,$806567cb,$196c3671,$6e6b06e7,$fed41b76,$89d32be0,
    $10da7a5a,$67dd4acc,$f9b9df6f,$8ebeeff9,$17b7be43,$60b08ed5,$d6d6a3e8,
    $a1d1937e,$38d8c2c4,$4fdff252,$d1bb67f1,$a6bc5767,$3fb506dd,$48b2364b,
    $d80d2bda,$af0a1b4c,$36034af6,$41047a60,$df60efc3,$a867df55,$316e8eef,
    $4669be79,$cb61b38c,$bc66831a,$256fd2a0,$5268e236,$cc0c7795,$bb0b4703,
    $220216b9,$5505262f,$c5ba3bbe,$b2bd0b28,$2bb45a92,$5cb36a04,$c2d7ffa7,
    $b5d0cf31,$2cd99e8b,$5bdeae1d,$9b64c2b0,$ec63f226,$756aa39c,$026d930a,
    $9c0906a9,$eb0e363f,$72076785,$05005713,$95bf4a82,$e2b87a14,$7bb12bae,
    $0cb61b38,$92d28e9b,$e5d5be0d,$7cdcefb7,$0bdbdf21,$86d3d2d4,$f1d4e242,
    $68ddb3f8,$1fda836e,$81be16cd,$f6b9265b,$6fb077e1,$18b74777,$88085ae6,
    $ff0f6a70,$66063bca,$11010b5c,$8f659eff,$f862ae69,$616bffd3,$166ccf45,
    $a00ae278,$d70dd2ee,$4e048354,$3903b3c2,$a7672661,$d06016f7,$4969474d,
    $3e6e77db,$aed16a4a,$d9d65adc,$40df0b66,$37d83bf0,$a9bcae53,$debb9ec5,
    $47b2cf7f,$30b5ffe9,$bdbdf21c,$cabac28a,$53b39330,$24b4a3a6,$bad03605,
    $cdd70693,$54de5729,$23d967bf,$b3667a2e,$c4614ab8,$5d681b02,$2a6f2b94,
    $b40bbe37,$c30c8ea1,$5a05df1b,$2d02ef8d
  );

type
  tIBDate=integer;
  tIBTime=cardinal;

  tIBTimeStamp=packed record
    Date:tIBDate;
    Time:tIBTime;
  end;

  pIBDate=^tIBDate;
  pIBTime=^tIBTime;

  pIBTimeStamp=^tIBTimeStamp;

(*************** Внутренние вспомогательные функции **************)

type
  TCharSet=TSysCharSet;

function pEmpty:pChar;
{ вернет пустую строку pChar }
begin
  Result:=ib_util_malloc(1); Result[0]:=#0;
end;

function StrIsEmpty(s:pChar):boolean;
{ проверит S на пустую строку }
begin
  Result:=(s =nil) or (s[0] =#0);
end;

function PCharToCharSet(const cp:pChar):TCharSet;
var
  i:integer;
  s:string;

begin
  Result:=[];

  if cp =nil then
    exit;

  s:=cp;

  for i:=1 to Length(s) do
    Include(Result,s[i]);
end;
 
function CharSetToPChar(const Chars:TCharSet):string;
var
  i:integer;

begin
  Result:='';

  for i:=0 to 255 do
    if Chr(i) in Chars then
      Result:=Result+Chr(i);
end;

function WordPosition_S(const N:integer; const S:string; const WordDelims:tCharSet):integer;
var
 Count,i:integer;
 
begin
  Count:=0;
  i:=1;
  Result:=0;

  while (i <=Length(S)) and (Count <>N) do begin
    { skip over delimiters }
    while (i <=Length(S)) and (S[i] in WordDelims) do Inc(i);
    { if we're not beyond end of S, we're at the start of a word }
    if i <=Length(S) then Inc(Count);
    { if not finished, find the end of the current word }
    if Count <>N then
      while (i <=Length(S)) and not (S[i] in WordDelims) do Inc(i)
    else
      Result:=i;
  end;
end;

function ExtractWord_S(N:integer; const S:string; const WordDelims:tCharSet):string;
var
  i:integer;
  l:integer;

begin
  l:=0;
  i:=WordPosition_S(N,S,WordDelims);

  if i <>0 then
    { find the end of the current word }
    while (i <=Length(S)) and not(S[i] in WordDelims) do begin
      { add the I'th character to result }
      Inc(l);
      SetLength(Result,l);
      Result[l]:=S[i];
      Inc(i);
    end;

  SetLength(Result,l);
end;

function IncDay(aDate:tDateTime; Delta:integer):tDateTime;
{ увеличивает дату на задданое к-во дней }
begin
  Result:=aDate+Delta;
end;

procedure IntDate2YMD(const di:integer; var Y,M,D:integer);
{ из даты INTEGER (yyyymmdd) в составляющие }
begin
  Y:=di div 10000;
  M:=(di div 100) mod 100;
  D:=di mod 100;
end;

function YMD2IntDate_(const Y,M,D:integer):integer;
{ Из составляющих в дату INTEGER (YYYYMMDD)
  ДЛЯ ВНУТРЕННЕГО ИСПОЛЬЗОВАНИЯ }
begin
  Result:=Y*10000+M*100+D;
end;

function EncodeIBDate(y,m,d:integer):tIBDate;
{ The IBEncodeDate function is based in nday() function of gds.cpp (FireBird API) }
var
  Century,ShortYear:integer;

begin
  if m >2 then
    m:=m-3
  else begin
    m:=m+9;
    y:=y-1;
  end;

  Century:=y div 100;
  ShortYear:=y-100*Century;

  Result:=
    (146097*Century) div 4+
    (1461*ShortYear) div 4+
    (153*m+2) div 5+d+1721119-2400001;
end;

// ! ===============  Далее идут экспортируемые функции ============ !

(******************************************************************
Из составляющих в дату INTEGER (YYYYMMDD)
----------------------------
declare external function udfYMD2IntDate
  integer,     /* год */
  integer,     /* месяц */
  integer      /* день */
returns
  integer by value
entry_point 'YMD2IntDate'
module_name 'ls_fb_udf';
******************************************************************)
function YMD2IntDate(var Y,M,D:integer):integer; cdecl; export;
begin
  Result:=Y*10000+M*100+D;
end;

(******************************************************************
Вернет день из YYYYMMDD
----------------------------
declare external function udfXtractDay
  integer
returns
  integer by value
entry_point 'XtractDay'
module_name 'ls_fb_udf';
******************************************************************)
function XtractDay(var di:integer):integer; cdecl; export;
var
  y,m:integer;

begin
  IntDate2YMD(di, y,m,Result);
end;

(******************************************************************
Вернет месяц из YYYYMMDD
----------------------------
declare external function udfXtractMonth
  integer
returns
  integer by value
entry_point 'XtractMonth'
module_name 'ls_fb_udf';
******************************************************************)
function XtractMonth(var di:integer):integer; cdecl; export;
var
  y,d:integer;

begin
  IntDate2YMD(di, y,Result,d);
end;

(******************************************************************
Вернет год из YYYYMMDD
----------------------------
declare external function udfXtractYear
 integer
returns
 integer by value
entry_point 'XtractYear'
module_name 'ls_fb_udf';
******************************************************************)
function XtractYear(var di:integer):integer; cdecl; export;
var
  d,m:integer;

begin
  IntDate2YMD(di, Result,m,d);
end;

(******************************************************************
Заменит день, месяц, год в дате типа YYYYMMDD

NOTE: Те состовляющие, кот. <0 не изменяются
----------------------------
declare external function udfUpdIntDate
  integer,     /* изменяемая дата */
  integer,     /* год */
  integer,     /* месяц */
  integer      /* день */
returns
  integer by value
entry_point 'UpdIntDate'
module_name 'ls_fb_udf';
******************************************************************)
function UpdIntDate(var di, y,m,d:integer):integer; cdecl; export;
var
  dd,mm,yy:integer;

begin
  IntDate2YMD(di, yy,mm,dd);
  if (y >0) then yy:=y;
  if (m >0) then mm:=m;
  if (d >0) then dd:=d;
  Result:=YMD2IntDate(yy,mm,dd);
end;

(******************************************************************
IB timestamp -> YYYYMMDD
----------------------------
declare external function udfTimeStamp2IntDate
  timestamp
returns
  integer by value
entry_point 'TimeStamp2IntDate'
module_name 'ls_fb_udf';
******************************************************************)
function TimeStamp2IntDate(var ts:tIBTimeStamp):integer; cdecl; export;
{ Алгоритм извлечения даты из timestamp выдран из tbudf.ibutil.IBDecodeDate }
{ Based on ndate() function of gds.cpp (FireBird API) }
var
  ibd:tIBDate;
  c,                 // century
  y,m,d:integer;     // year,month,day

begin
  ibd:=ts.Date-(1721119-2400001);
  c:=(4*ibd-1) div 146097;
  ibd:=4*ibd-1-146097*c;
  d:=ibd div 4;
  ibd:=(4*d+3) div 1461;
  d:=4*d+3-1461*ibd;
  d:=(d+4) div 4;
  m:=(5*d-3) div 153;
  d:=5*d-3-153*m;
  d:=(d+5) div 5;
  y:=100*c+ibd;

  if m <10 then
    m:=m+3
  else begin
    m:=m-9;
    y:=y+1;
  end;

  // складываем все в YYYYMMDD
  Result:=YMD2IntDate(y,m,d);
end;

(******************************************************************
YYYYMMDD -> IB timestamp
----------------------------
declare external function udfIntDate2TimeStamp
  integer,
  timestamp
returns
  parameter 2
entry_point 'IntDate2TimeStamp'
module_name 'ls_fb_udf';
******************************************************************)
procedure IntDate2TimeStamp(
  var dd:integer;
  var ts:tIBTimeStamp
); cdecl; export;

var
  d,m,y:integer;

begin
  IntDate2YMD(dd, y,m,d);
  with ts do begin
    Date:=EncodeIBDate(y,m,d);
    Time:=0;
  end;
end;

(******************************************************************
Инициализация модуля ad_UDF
Вернет: 1=OK, 0=FAIL
----------------------------
declare external function udfInitUDFs
returns
  integer by value
entry_point 'InitUDFs'
module_name 'ls_fb_udf';
******************************************************************)
function InitUDFs:integer; cdecl; export;
begin
  Randomize;
  Result:=1;
end;

(******************************************************************
Вернет версию ad_UDF
----------------------------
declare external function udfLibVer
returns
  CString(33) free_it
entry_point 'GetLibVer'
module_name 'ls_fb_udf';
******************************************************************)
function GetLibVer:pChar; cdecl; export;
begin
  Result:=ib_util_malloc(33);
  StrPCopy(Result,sLibVer);
end;

(******************************************************************
Включает ли строка атрибутов объекта ObjA заданные в ChkA атрибуты
Вернет: 0 - не включает; >0 - включает

NOTES: атрибуты в ObjA и ChkA должны быть отсортированы в Asc-порядке
----------------------------
declare external function udfObjHasAttrs
 CString(4096),     /* Objs.A */
 CString(4096)      /* атрибуты, вхожесть которых в ObjA нужно проверить */
returns
 integer by value
entry_point 'ObjHasAttrs'
module_name 'ls_fb_udf';
******************************************************************)
function ObjHasAttrs(
  ObjA:pChar;        // Objs.A
  ChkA:pChar         // атрибуты, вхожесть которых в ObjA нужно проверить
):integer; cdecl; export;

var
  ObjALen,ChkALen,
  PosObjA,PosChkA:integer;
  oA,cA:string[2];

begin
  Result:=0;

  ObjALen:=Length(ObjA); PosObjA:=1;
  ChkALen:=Length(ChkA); PosChkA:=1;

  cA:=Copy(ChkA,1,2);
  oA:=Copy(ObjA,1,2);

  while true do begin
    if cA <oA then exit;   // false

    if cA =oA then begin
      if (PosChkA+2) >=ChkALen then begin
        Result:=1;
        exit;                // true
      end
      else begin
        Inc(PosChkA,2);
        cA:=Copy(ChkA,PosChkA,2);
      end;
    end;

    if (PosObjA+2) >ObjALen then exit;   // false

    Inc(PosObjA,2);
    oA:=Copy(ObjA,PosObjA,2);
  end;
end;

(******************************************************************
Инкрементирует переданный двухсимвольный Id

NOTES: если переполнение - вернет пустую строку
----------------------------
declare external function udfIncAttrId
  CString(3)
returns
  CString(3) free_it
entry_point 'IncAttrId'
module_name 'ls_fb_udf';
******************************************************************)
function IncAttrId(
  At:pChar
):pChar; cdecl; export;

begin
  if At[1] ='я' then begin
    if At[0] ='я' then
      // переполнение
      Result:=pEmpty
    else begin
      Result:=ib_util_malloc(3);
      Result[0]:=char(ord(At[0])+1);
      Result[1]:='A';   // lat 'A'
      Result[3]:=#0;
    end
  end
  else begin
    Result:=ib_util_malloc(3);
    Move(At[0],Result[0],3);
    Result[1]:=char(ord(Result[1])+1);
  end;
end;

function BufCrc32(var buf; crc:cardinal; BufSize:integer):cardinal; assembler;
asm
  push esi
  mov esi,Buf
@1:
  movzx eax,byte ptr [esi]
  inc ESI
  xor al,dl
  shr edx,8
  xor edx,dword ptr [Crc32Table+eax*4]
  Loop @1
  mov eax,edx
  pop esi
end;

(******************************************************************
Вернет результат crc32 от входного параметра (строки)
----------------------------
declare external function udfCrc32
  CString(300)
returns
  integer by value
entry_point 'SCrc32'
module_name 'ls_fb_udf';
******************************************************************)
function SCrc32(s:pChar):cardinal; cdecl; export;
begin
  if (s <>nil) and (s[0] <>#0) then begin
    Result:=BufCrc32(s^,$FFFFFFFF,Length(s));
    Result:=((Result and $FF000000) shr 24) or ((Result and $FF) shl 24) or
            ((Result and $00FF0000) shr 8) or ((Result and $FF00) shl 8);
  end
  else
    Result:=$FFFFFFFF;
end;

(******************************************************************
Возвращает зашифрованный пароль в виде строкового представления HEX(crc32)
----------------------------
declare external function udfEncryptPwd
  CString(40)
returns
  CString(40) free_it
entry_point 'EncryptPwd'
module_name 'ls_fb_udf';
******************************************************************)
function EncryptPwd(
  inPwd:pChar
):pChar; cdecl; export;

var
  Code:cardinal;

begin
  Code:=SCrc32(inPwd);
  Result:=ib_util_malloc(9);
  StrPCopy(Result,IntToHex(Code,8));
end;

(******************************************************************
Проверяет пароль зашифрованный функцией EncryptPwd
Вернет: 0-пароль неверен; <>0-пароль верен
----------------------------
declare external function udfCheckPwd
  CString(40),      /* пароль */
  CString(40)       /* зашифрованный пароль */
returns
  integer by value
entry_point 'CheckPwd'
module_name 'ls_fb_udf';
******************************************************************)
function CheckPwd(
  Pwd:pChar;
  Crypted:pChar
):integer; cdecl; export;

var
  Code:cardinal;

begin
  Code:=SCrc32(Pwd);
  if AnsiStrComp(pChar(IntToHex(Code,8)),Crypted) =0 then
    Result:=1     // пароль верен
  else
    Result:=0;    // пароль НЕ верен
end;

(******************************************************************
Вернет случайное число в интервале от L до H
----------------------------
declare external function udfRnd
  integer,        /* нижняя граница */
  integer         /* верхняя граница */
returns
  integer by value
entry_point 'GetRnd'
module_name 'ls_fb_udf';
******************************************************************)
function GetRnd(
  var L:integer;        // нижняя граница
  var H:integer         // верхняя граница
):integer; cdecl; export;

begin
  if H <=L then Result:=H
  else Result:=Random(H)+L;
end;

(******************************************************************
Результат бинарной операции AND
----------------------------
declare external function udfAnd
  integer,
  integer
returns
  integer by value
entry_point 'GetAnd'
module_name 'ls_fb_udf';
******************************************************************)
function GetAnd(
  var Int1:integer;
  var Int2:integer
):integer; cdecl; export;

begin
  Result:=Int1 and Int2;
end;

(******************************************************************
Результат бинарной операции OR
----------------------------
declare external function udfOr
  integer,
  integer
returns
  integer by value
entry_point 'GetOr'
module_name 'ls_fb_udf';
******************************************************************)
function GetOr(
  var Int1:integer;
  var Int2:integer
):integer; cdecl; export;

begin
  Result:=Int1 or Int2;
end;

(******************************************************************
Результат бинарной операции XOR
----------------------------
declare external function udfXor
  integer,
  integer
returns
  integer by value
entry_point 'GetXor'
module_name 'ls_fb_udf';
******************************************************************)
function GetXor(
  var Int1:integer;
  var Int2:integer
):integer; cdecl; export;

begin
  Result:=Int1 xor Int2;
end;

(******************************************************************
Результат - циклический сдвиг вправо
----------------------------
declare external function udfShr
  integer,           /* сдвигаемое число */
  integer            /* на сколько битов */
returns
  integer by value
entry_point 'GetShr'
module_name 'ls_fb_udf';
******************************************************************)
function GetShr(
  var Value:integer;
  var Cnt:integer
):integer; cdecl; export;

begin
  Result:=Value shr Cnt;
end;

(******************************************************************
Результат - циклический сдвиг влево
----------------------------
declare external function udfShl
  integer,           /* сдвигаемое число */
  integer            /* на сколько битов */
returns
  integer by value
entry_point 'GetShl'
module_name 'ls_fb_udf';
******************************************************************)
function GetShl(
  var Value:integer;
  var Cnt:integer
):integer; cdecl; export;

begin
  Result:=Value shl Cnt;
end;

(******************************************************************
Вернет длину строки St

NOTES:  StrLen() - длина без учета null-terminator
----------------------------
declare external function udfLen
 CString(32700)
returns
 integer by value
entry_point 'GetLen'
module_name 'ls_fb_udf';
******************************************************************)
function GetLen(
  St:pChar
):integer; cdecl; export;

begin
  Result:=StrLen(St);
end;

(******************************************************************
Вернет подстроку от St с i1 по i2 позицию

NOTES: позиции нумеруются с 1
       StrLen() - длина без учета null-terminator
----------------------------
declare external function udfSubStr
  CString(32700),     /* строка */
  integer,            /* начальная позиция */
  integer             /* конечная позиция */
returns
  CString(32700) free_it
entry_point 'SubStr'
module_name 'ls_fb_udf';
******************************************************************)
function SubStr(
  St:pChar;           // строка
  var i1:integer;     // начальная позиция
  var i2:integer      // конечная позиция
):pChar; cdecl; export;

var
  SLen:integer;    // длина исходной строки
  RLen:integer;    // длина вычленяемой подстроки

begin
  if (St =nil) or (i1 >i2) then SLen:=0
  else SLen:=StrLen(St);

  if i1 >SLen then
    SLen:=0
  else
    if i2 >SLen then i2:=SLen;

  if SLen =0 then
    Result:=pEmpty
  else begin
    RLen:=i2-i1+1;

    Result:=ib_util_malloc(RLen+1);
    Move(St[i1-1],Result[0],RLen);
    Result[RLen]:=#0;
  end
end;

(******************************************************************
Приведение строки к ВЕРХНЕМУ регистру

NOTES: StrLen() - длина без учета null-terminator
----------------------------
declare external function udfUpper
  CString(32700)
returns
  CString(32700) free_it
entry_point 'GetUpper'
module_name 'ls_fb_udf';
******************************************************************)
function GetUpper(
  St:pChar
):pChar; cdecl; export;

var
  l,i:integer;

begin
  i:=0;

  if St =nil then
    Result:=ib_util_malloc(1)
  else begin
    l:=StrLen(St);
    Result:=ib_util_malloc(l+1);
    while i <=l do begin
      if St[i] in ['a'..'z',#224..#255] then
        Result[i]:=char(ord(St[i])-32)
      else
        Result[i]:=St[i];

      Inc(i);   // след.символ
    end;
  end;

  Result[i]:=#0;  // null-terminator
end;

(******************************************************************
Приведение строки к НИЖНЕМУ регистру

NOTES: StrLen() - длина без учета null-terminator
----------------------------
declare external function udfLower
  CString(32700)
returns
  CString(32700) free_it
entry_point 'GetLower'
module_name 'ls_fb_udf';
******************************************************************)
function GetLower(
  St:pChar
):pChar; cdecl; export;

var
  l,i:integer;

begin
  i:=0;

  if St =nil then
    Result:=ib_util_malloc(1)
  else begin
    l:=StrLen(St);
    Result:=ib_util_malloc(l+1);
    while i <=l do begin
      if St[i] in ['A'..'Z',#192..#223] then
        Result[i]:=char(ord(St[i])+32)
      else
        Result[i]:=St[i];

      Inc(i);
    end;
  end;

  Result[i]:=#0;  // null-terminator
end;

(******************************************************************
Отрезает КОНЕЧНЫЕ пробелы

NOTES:  StrLen() - длина без учета null-terminator
----------------------------
declare external function udfTrimTrail
  CString(32700)
returns
  CString(32700) free_it
entry_point 'GetTrimTrail'
module_name 'ls_fb_udf';
******************************************************************)
function GetTrimTrail(
  St:pChar
):pChar; cdecl; export;

var
  l:integer;

begin
  if St =nil then
    Result:=pEmpty
  else begin
    l:=StrLen(St);

    while (l >0) do begin
      if St[l-1] <>' ' then begin
        // усе - нашли непробел
        Result:=ib_util_malloc(l+1);
        Move(St[0],Result[0],l);
        Result[l]:=#0;
        exit;
      end;

      Dec(l);
    end;
    // если мы сюда попали, значит вся строка сосит из пробелов
    Result:=pEmpty;
  end;
end;

(******************************************************************
Отрезает НАЧАЛЬНЫЕ пробелы

NOTES:  StrLen() - длина без учета null-terminator
----------------------------
declare external function udfTrimLead
  CString(32700)
returns
  CString(32700) free_it
entry_point 'GetTrimLead'
module_name 'ls_fb_udf';
******************************************************************)
function GetTrimLead(
  St:pChar
):pChar; cdecl; export;

var
  l,i:integer;

begin
  if St =nil then
    Result:=pEmpty
  else begin
    l:=StrLen(St);
    i:=0;

    while (i <l) do begin
      if St[i] <>' ' then begin
        Result:=ib_util_malloc((l-i)+1);
        Move(St[i],Result[0],(l-i)+1);
        exit;
      end;

      Inc(i);
    end;
    // если мы сюда попали, значит вся строка сосит из пробелов
    Result:=pEmpty;
  end;
end;

(******************************************************************
Отрезает НАЧАЛЬНЫЕ и КОНЕЧНЫЕ пробелы

NOTES:  StrLen() - длина без учета null-terminator
----------------------------
declare external function udfTrim
  CString(32700)
returns
  CString(32700) free_it
entry_point 'GetTrim'
module_name 'ls_fb_udf';
******************************************************************)
function GetTrim(
  St:pChar
):pChar; cdecl; export;

var
  SLen,l,r:integer;

begin
  if St =nil then
    Result:=pEmpty
  else begin
    SLen:=StrLen(St);

    { ищем первый непробельный символ СКОНЦА строки }
    r:=SLen;
    while r >0 do begin
      if St[r-1] <>' ' then begin
        // нашли непробел в позиции r-1
        { ищем первый непробельный символ СНАЧАЛА строки }
        l:=0;
        while l <r do begin
          if St[l] <>' ' then begin
            // нашли непробел в позиции l - будем коцать строку
            Result:=ib_util_malloc(r-l+1);
            Move(St[l],Result[0],r-l);
            Result[r-l]:=#0;
            exit;
          end; (* if St[l] <>' ' *)
          // следующий
          Inc(l);
        end; (* while St[l] <>' ' *)
        // выходим из цикла поиска первого непробела и из функции
        break;
      end; (* if St[r-1] <>' ' *)
      // предыдущий
      Dec(r);
    end; (* while r >0 *)
    // если мы сюда попали, значит, строка состоит из одних пробелов
    Result:=pEmpty;
  end; (* St <>NIL *)
end;

(******************************************************************
Формирует строку из символов C длиной N
----------------------------
declare external function udfMkStr
  CString(3),
  integer
returns
  CString(32700) free_it
entry_point 'MkStr'
module_name 'ls_fb_udf';
******************************************************************)
function MkStr(
  C:pChar;
  var N:integer
):pChar; cdecl; export;

begin
  if C =nil then
    Result:=pEmpty
  else begin
    Result:=ib_util_malloc(N+1);
    FillChar(Result[0],N,C[0]);
    Result[N]:=#0;
  end;
end;

(******************************************************************
Дополняет строку St символами C слева до длины N

NOTES:  StrLen() - длина без учета null-terminator
----------------------------
declare external function udfLeftPad
  CString(2),
  CString(32700),
  integer
returns
  CString(32700) free_it
entry_point 'LeftPad'
module_name 'ls_fb_udf';
******************************************************************)
function LeftPad(
  C:pChar;
  St:pChar;
  var N:integer
):pChar; cdecl; export;

var
  sLen:integer;
  cc:char;

begin
  if (St =nil) or (St[0] =#0) or (N <=0) then
    Result:=pEmpty
  else begin
    sLen:=StrLen(St);

    if (sLen >=N) then begin
      Result:=ib_util_malloc(sLen+1);
      Move(St[0],Result[0],sLen+1);
    end
    else begin
      Result:=ib_util_malloc(N+1); Result[N]:=#0;

      if C =nil then cc:=' '
      else cc:=C[0];

      FillChar(Result[0],N,cc);
      Move(St[0],Result[N-sLen],sLen);
    end;
  end;
end;

(******************************************************************
Дополняет строку St символами C справа до длины N

NOTES:  StrLen() - длина без учета null-terminator
----------------------------
declare external function udfRightPad
  CString(2),
  CString(32700),
  integer
returns
  CString(32700) free_it
entry_point 'RightPad'
module_name 'ls_fb_udf';
******************************************************************)
function RightPad(
  C:pChar;
  St:pChar;
  var N:integer
):pChar; cdecl; export;

var
  sLen:integer;
  cc:char;

begin
  if (St =nil) or (St[0] =#0) or (N <=0) then
    Result:=pEmpty
  else begin
    sLen:=StrLen(St);

    if (sLen >=N) then begin
      Result:=ib_util_malloc(sLen+1);
      Move(St[0],Result[0],sLen+1);
    end
    else begin
      Result:=ib_util_malloc(N+1);
      Result[N]:=#0;

      if C =nil then cc:=' '
      else cc:=C[0];

      FillChar(Result[0],N,cc);
      Move(St[0],Result[0],sLen);
    end;
  end;
end;

(******************************************************************
Центрирует строку St по ширине N

NOTES:  StrLen() - длина без учета null-terminator
----------------------------
declare external function udfCenterStr
  CString(32700),
  integer,
  CString(2)
returns
  CString(32700) free_it
entry_point 'CenterStr'
module_name 'ls_fb_udf';
******************************************************************)
function CenterStr(
  St:pChar;
  var N:integer;
  C:pChar
):pChar; cdecl; export;

var
  sLen:integer;
  cc:char;

begin
  if (St =nil) or (St[0] =#0) or (N <=0) then
    Result:=pEmpty
  else begin
    sLen:=StrLen(St);

    if (sLen >=N) then begin
      Result:=ib_util_malloc(sLen+1);
      Move(St[0],Result[0],sLen+1);
    end
    else begin
      Result:=ib_util_malloc(N+1);
      Result[N]:=#0;

      if C =nil then cc:=' '
      else cc:=C[0];

      FillChar(Result[0],N,cc);
      Move(St[0],Result[(N-sLen) shr 1],sLen);
    end;
  end;
end;

(* проверяет есть ли символ C в строке S (L-длина строки S без /0) *)
function IsChIn(C:char; S:pChar; L:integer):boolean;
var
  i:integer;

begin
  Result:=true;

  for i:=0 to pred(l) do if c =s[i] then exit;

  Result:=false;
end;

(******************************************************************
Вернет к-во слов во входной строке S разделенных символами из строки Z

NOTES:  StrLen() - длина без учета null-terminator
----------------------------
declare external function udfWordCount
  CString(32700),      /* строка: S */
  CString(255)         /* разделители: Z */
returns
  integer by value
entry_point 'WordCount'
module_name 'ls_fb_udf';
******************************************************************)
function WordCount(
  S:pChar;
  Z:pChar
):integer; cdecl; export;

var
  i,sLen,zLen:integer;

begin
  Result:=0;

  if (S =nil) or (Z =nil) then
    exit
  else begin
    sLen:=StrLen(s); zLen:=StrLen(z);
    if (sLen =0) or (zLen =0) then
      exit
    else begin
      i:=0;
      while i <sLen do begin
        while (i <sLen) and (IsChIn(s[i],z,zLen)) do Inc(i);
        if i <sLen then Inc(Result);
        while (i <sLen) and not (IsChIn(s[i],z,zLen)) do Inc(i);
      end;
    end;
  end;
end;

(******************************************************************
Вернет начальную позицию N-го слова в строке S, разделенного
делимитерами из строки Z
Если такого слова нет, вернет -1

NOTES:  StrLen() - длина без учета null-terminator
----------------------------
declare external function udfWordPos
  integer,             /* номер слова в строке: N */
  CString(32700),      /* строка: S */
  CString(255)         /* разделители: Z */
returns
  integer by value
entry_point 'WordPos'
module_name 'ls_fb_udf';
******************************************************************)
function WordPos(
  var N:integer;
  S:pChar;
  Z:pChar
):integer; cdecl; export;

var
  Cnt,i,
  sLen,zLen:integer;

begin
  Result:=-1;
  sLen:=StrLen(s); zLen:=StrLen(z);
  Cnt:=0; i:=0;

  while (i  <sLen) and (Cnt <>n) do begin
    { скипаем разделители }
    while (i <sLen) and (IsChIn(s[i],z,zLen)) do Inc(i);
    { если мы не вышли за пределы строки, мы на начале нужного слова }
    if i <sLen then Inc(Cnt);
    { если не закончили - найдем конец текущего слова }
    if Cnt <>n then
      while (i <sLen) and not (IsChIn(s[i],z,zLen)) do Inc(i)
    else
      Result:=i;
  end;
end;

(******************************************************************
Вернет слово номер N из строки S, разделители в Z

NOTES:  StrLen() - длина без учета null-terminator
----------------------------
declare external function udfExtractWord
  integer,             /* номер слова в строке: N */
  CString(32700),      /* строка: S */
  CString(255)         /* разделители: Z */
returns
  CString(32700) free_it
entry_point 'ExtractWord'
module_name 'ls_fb_udf';
******************************************************************)
function ExtractWord(
  var N:integer;
  S:pChar;
  Z:pChar
):pChar; cdecl; export;

var
  wp:integer;
  sLen,zLen,rLen:integer;
  rPos:integer;

begin
  wp:=WordPos(n,s,z);
  if wp =-1 then
    Result:=pEmpty
  else begin
    rPos:=wp;
    sLen:=StrLen(s); zLen:=StrLen(z);
    { ищем конец слова }
    while (rPos <sLen) and not (IsChIn(s[rPos],z,zLen)) do begin
      Inc(rPos);
    end;
    { копируем найденное слово в Result }
    rLen:=rPos-wp;
    Result:=ib_util_malloc(succ(rLen));
    Move(s[wp],Result[0],rLen);
    Result[rLen]:=#0;
  end;
end;

(******************************************************************
Вернет символ с кодом N
----------------------------
declare external function udfChar
 integer             /* код символа N */
returns
 CString(10) free_it
entry_point 'GetChar'
module_name 'ls_fb_udf';
******************************************************************)
function GetChar(
  var N:integer
):pChar; cdecl; export;

begin
  Result:=ib_util_malloc(2);
  Result[0]:=chr(N); Result[1]:=#0;
end;

(******************************************************************
Вернет строку сообщения, в которой макросы %1..%9 заменены
на аргументы из строки A
Аргументы в строке A должны быть разделены символом с кодом #3
----------------------------
declare external function udfTransStr
 CString(32700),      /* сообщение: S */
 CString(32700)       /* аргументы: A */
returns
 CString(32700) free_it
entry_point 'TransStr'
module_name 'ls_fb_udf';
******************************************************************)
function TransStr(
  S:pChar;
  A:pChar
):pChar; cdecl; export;

var
  sLen:integer;     // длина входной строки S
  sS,               // строка сообщения, превращенная в Pascal-string
  sA,               // строка аргументов, превращенная в Pascal-string
  sRes:string;      // строка, которая пойдет в Result
  i,z:integer;

begin
  sS:=S; sA:=A; sRes:='';
  sLen:=Length(sS); i:=1;

  while i <=sLen do begin
    if sS[i] ='%' then begin
      Inc(i);
      z:=StrToIntDef(Copy(sS,i,1),-666);
      if z =-666 then begin
        sRes:=sRes+sS[pred(i)];
      end
      else begin
        sRes:=sRes+ExtractWord_S(z,sA,[#3]);
        Inc(i);
      end;
    end
    else begin
      sRes:=sRes+sS[i];
      Inc(i);
    end;
  end;

  Result:=ib_util_malloc(succ(Length(sRes)));
  StrPCopy(Result,sRes);
end;

(******************************************************************
Вернет значение переменной, имя которой в V
Формат входной строки S:
 - длина имени переменной - 2 +[0..1]
 - имя переменной - столько, сколько указано в длине
 - длина значения переменной - 3
 - значение переменной - столько, сколько указано в длине

Если переменная не найдена - вернет пустую строку

NOTES:  StrLen() - длина без учета null-terminator
----------------------------
declare external function udfGetVar
  CString(32700),      /* строка: S */
  CString(32700)       /* имя переменной: V */
returns
  CString(255) free_it
entry_point 'GetVar'
module_name 'ls_fb_udf';
******************************************************************)
function GetVar(
  S:pChar;
  V:pChar
):pChar; cdecl; export;

var
  sLen:integer;
  vLen:integer;
  i:integer;
  sStr:string;
  vStr:string;
  VarLen:integer;
  s1:string;

begin
  // какой-то из входных параметров NULL
  if (S =nil) or (V =nil) then begin
    Result:=pEmpty;
    exit;
  end;

  // берем длины входных строк
  sLen:=StrLen(S); vLen:=StrLen(V);

  // какая-то из входных строк - пустая
  if (sLen <5) or (vLen <2) then begin
    Result:=pEmpty;
    exit;
  end;

  // приводим имя искомой переменной к нижнему регистру
  CharLower(V);

  // превращаем входные параметры в pascal string
  sStr:=StrPas(S); vStr:=StrPas(V);

  i:=1;

  while i <sLen do begin
    // берем длину имени переменной
    VarLen:=StrToInt(Copy(sStr,i,2));
    // берем имя переменной
    s1:=LowerCase(Copy(sStr,i+2,VarLen));

    Inc(i,2+Varlen);  // перемещаем указатель

    // берем длину значения
    VarLen:=StrToInt(Copy(sStr,i,3));

    if s1 =vStr then begin
      // нашли переменную - берем значение
      Result:=ib_util_malloc(VarLen+1);
      StrPCopy(Result,Copy(sStr,i+3,VarLen));
      exit;
    end;

    // это не та переменная - переместим указатель на след.элемент
    Inc(i,3+VarLen);
  end;

  // нет такой переменной
  Result:=pEmpty;
end;

(******************************************************************
Из целого в строку, дополняя резкльтат слева '0' до 10 символов
----------------------------
declare external function udfInt2Str0
  integer
returns
  CString(12) free_it
entry_point 'Int2Str0'
module_name 'ls_fb_udf';
******************************************************************)
function Int2Str0(
  var aInt:integer
):pChar; cdecl; export;

var
  s:string;
  n:integer;

begin
  n:=10;
  Result:=MkStr('0',n);

  if aInt <>0 then begin
    if aInt <0 then begin
      s:=IntToStr(-aInt);
      Result[0]:='-';
    end
    else
      s:=IntToStr(aInt);
    Move(s[1],Result[10-Length(s)],Length(s));
  end;
end;

(******************************************************************
Дублирует заданную строку N раз
----------------------------
declare external function udfDupStr
  CString(255),      /* строка, кот. нужно отдублировать: S */
  CString(2),        /* разделитель: Z */
  integer            /* к-во повторений: N */
returns
  CString(32700) free_it
entry_point 'DupStr'
module_name 'ls_fb_udf';
******************************************************************)
function DupStr(
  S:pChar;
  Z:pChar;
  var N:integer
):pChar; cdecl; export;

var
  ss:string;
  i:integer;

begin
  ss:='';

  for i:=1 to N do
    ss:=ss+Z[0]+S;

  Result:=ib_util_malloc(Length(ss)+1);
  StrPCopy(Result,ss);
end;

(******************************************************************
Складывает две строки чисел

ВХОД: две строки чисел в символьном представлении (as double precision)
      разделенные символами, указанными в третьем параметре

ВЫХОД: строка, содержащая суммы чисел в символьном представлении,
       разделенные первым из символов, указанных в третьем параметре
----------------------------
declare external function udfAddStrCols
  CString(32700),    /* первое слагаемое: A1 */
  CString(32700),    /* второе слагаемое: A2 */
  CString(255)       /* строка разделителей: Z */
returns
  CString(32700) free_it
entry_point 'AddStrCols'
module_name 'ls_fb_udf';
******************************************************************)
function AddStrCols(
  A1:pChar;
  A2:pChar;
  Z:pChar
):pChar; cdecl; export;

var
  l1,l2:integer;   // к-во чисел в слагаемых
  sA1,sA2:string;  // временные строки из A1 и A2
  i,iMin,iMax:integer;
  s:string;
  p1,p2:string;
  csZ:TCharSet;

begin
  l1:=WordCount(A1,Z);    // к-во элементов в первой строке
  l2:=WordCount(A2,Z);    // к-во элементов во второй строке

  if l1 >=l2 then begin
    // в первой строке больше элементов (или в обоих одинаково)
    iMax:=l1;
    iMin:=l2;
  end
  else begin
    // во второй строке больше элементов
    iMax:=l2;
    iMin:=l1;
  end;

  sA1:=A1; sA2:=A2; csZ:=PCharToCharSet(Z);

  s:=''; i:=1;

  while i <=iMax do begin
    if i >iMin then begin
      // вышли за пределы строки меньшей длины - просто переносим
      // в результирующую строку числа из строки большей длины
      if l1 >=l2 then
        p1:=ExtractWord_S(i,sA1,csZ)    // первая строка длинее
      else
        p1:=ExtractWord_S(i,sA2,csZ);   // вторая строка длинее

      s:=s+Z[0]+p1;
    end
    else begin
      // ни одна из строк еще не закончилась - продолжаем суммировать
      p1:=ExtractWord_S(i,sA1,csZ);
      p2:=ExtractWord_S(i,sA2,csZ);

      s:=s+Z[0]+FloatToStr(StrToFloat(p1)+StrToFloat(p2));
    end;

    Inc(i);  // след. элемент
  end; (*WHILE*)

  Result:=ib_util_malloc(Length(s)+1);
  StrPCopy(Result,s);
end;

(******************************************************************
Вычитает из первой строки чисел вторую
----------------------------
declare external function udfSubStrCols
  CString(32700),    /* уменьшаемое: A */
  CString(32700),    /* вычитаемое: S */
  CString(255)       /* строка разделителей: Z */
returns
  CString(32700) free_it
entry_point 'SubStrCols'
module_name 'ls_fb_udf';
******************************************************************)
function SubStrCols(
  A:pChar;
  S:pChar;
  Z:pChar
):pChar; cdecl; export;

begin
  Result:=nil;
end;

(******************************************************************
Суммирование всех чисел в строке

NOTES:  StrLen() - длина без учета null-terminator
----------------------------
declare external function udfSumStrCols
  CString(32700),      /* строка чисел: S */
  CString(255)         /* символы-разделители чисел: Z */
returns
  CString(32700) free_it
entry_point 'SumStrCols'
module_name 'ls_fb_udf';
******************************************************************)
function SumStrCols(
  S:pChar;
  Z:pChar
):pChar; cdecl; export;

var
  i,ii:integer;
  p:string;
  d:double;
  ss:string;
  csZ:TCharSet;

begin
  ii:=WordCount(S,Z);
  d:=0;

  if ii =0 then begin
    Result:=ib_util_malloc(2);
    StrPCopy(Result,'0');
    exit;
  end;

  csZ:=PCharToCharSet(Z);

  i:=1;
  while i <=ii do begin
    p:=ExtractWord_S(i,S,csZ);
    d:=d+StrToFloat(p);
    Inc(i);
  end;

  i:=StrLen(S);

  if S[i-1] <>Z[0] then
    ss:=Z[0]+FloatToStr(d)
  else
    ss:=FloatToStr(d);

  Inc(i,Length(ss));

  Result:=ib_util_malloc(i+1);
  StrCopy(Result,S);
  StrCat(Result,pChar(ss));
end;

(******************************************************************
Чередует числа, взятые из первого и второго параметра
----------------------------
declare external function udfMixStrCols
  CString(32700),      /* строка слов #1: S1 */
  CString(32700),      /* строка слов #2: S2 */
  CString(255)         /* символы-разделители чисел: Z */
returns
  CString(32700) free_it
entry_point 'MixStrCols'
module_name 'ls_fb_udf';
******************************************************************)
function MixStrCols(
  S1:pChar;
  S2:pChar;
  Z:pChar
):pChar; cdecl; export;

var
  l1,l2:integer;      // длины первой и второй строки
  i,ii,iMin:integer;
  s:string;
  csZ:TCharSet;
  p1,p2:string;

begin
  l1:=WordCount(S1,Z);
  l2:=WordCount(S2,Z);

  if l1 >l2 then begin
    ii:=l1;
    iMin:=l2;
  end
  else begin
    ii:=l2;
    iMin:=l1;
  end;

  i:=1; s:='';
  csZ:=PCharToCharSet(Z);

  while i <=ii do begin
    if i >iMin then begin
      // перешли границу короткой строки
      if l1 >l2 then begin  // ПЕРВАЯ строка длиннее
        p1:=ExtractWord_S(i,S1,csZ);
        s:=s+Z[0]+p1+Z[0]+'0';
      end
      else begin            // ВТОРАЯ строка длиннее
        p1:=ExtractWord_S(i,S2,csZ);
        s:=s+Z[0]+'0'+Z[0]+p1;
      end;
    end
    else begin
      // пока обе строки равны
      p1:=ExtractWord_S(i,S1,csZ);
      p2:=ExtractWord_S(i,S2,csZ);

      s:=s+Z[0]+p1+Z[0]+p2;
    end;

    Inc(i);
  end;

  // теперь s содержит строку смикшированную из S1 и S2

  Result:=ib_util_malloc(Length(s)+1);
  StrPCopy(Result,s);
end;

(******************************************************************
Вернет подстроку от BLOB с i1 по i2 позицию

NOTES: позиции нумеруются с 1
----------------------------
declare external function udfBlobSubStr
  blob,               /* строка */
  integer,            /* начальная позиция */
  integer             /* конечная позиция */
returns
 CString(32700) free_it
entry_point 'BlobSubStr'
module_name 'ls_fb_udf';
******************************************************************)
function BlobSubStr(
  Blob:pBlob;         // строка
  var i1:integer;     // начальная позиция
  var i2:integer      // конечная позиция
):pChar; cdecl; export;

var
  s:string;
  l:integer;

begin
  if (i1 <1) or (i2 <i1) then
    Result:=pEmpty
  else begin
    s:=BlobAsString(Blob);
    l:=succ(i2-i1);
    Result:=ib_util_malloc(l+1);
    StrPCopy(Result,Copy(s,i1,l));
  end;
end;

(******************************************************************
Вернет слово номер N из строки BLOB, разделители в Z
----------------------------
declare external function udfBlobExtractWord
  integer,             /* номер слова в строке: N */
  blob,                /* строка: BLOB */
  CString(32700)       /* разделители: Z */
returns
  CString(32700) free_it
entry_point 'BlobExtractWord'
module_name 'ls_fb_udf';
******************************************************************)
function BlobExtractWord(
  var N:integer;
  Blob:pBlob;
  Z:pChar
):pChar; cdecl; export;

var
  s:string;

begin
  s:=BlobAsString(Blob);
  Result:=ExtractWord(N,pChar(s),Z);
end;

(******************************************************************
Вернет начальную позицию N-го слова в строке BLOB, разделенного
делимитерами из строки Z
Если такого слова нет, вернет -1
----------------------------
declare external function udfBlobWordPos
  integer,             /* номер слова в строке: N */
  blob,                /* строка: Blob */
  CString(32700)       /* разделители: Z */
returns
  integer by value
entry_point 'BlobWordPos'
module_name 'ls_fb_udf';
******************************************************************)
function BlobWordPos(
  var N:integer;
  Blob:pBlob;
  Z:pChar
):integer; cdecl; export;

var
  s:string;

begin
  s:=BlobAsString(Blob);
  Result:=WordPos(N,pChar(s),Z);
end;

(******************************************************************
Вернет к-во слов во входной строке BLOB разделенных символами из строки Z
----------------------------
declare external function udfBlobWordCount
  blob,                /* строка: BLOB */
  CString(32700)       /* разделители: Z */
returns
  integer by value
entry_point 'BlobWordCount'
module_name 'ls_fb_udf';
******************************************************************)
function BlobWordCount(
  Blob:pBlob;
  Z:pChar
):integer; cdecl; export;

var
  s:string;

begin
  s:=BlobAsString(Blob);
  Result:=WordCount(pChar(s),Z);
end;

(******************************************************************
Вернет целую часть числа (без округления)
----------------------------
declare external function udfTrunc
  double precision
returns
  integer by value
entry_point 'GetTrunc'
module_name 'ls_fb_udf';
******************************************************************)
function GetTrunc(
  var aNum:double
):integer; cdecl; export;

begin
  Result:=Trunc(aNum);
end;

(******************************************************************
Вернет целую часть числа (с округлением)
----------------------------
declare external function udfRound
  double precision
returns
  integer by value
entry_point 'GetRound'
module_name 'ls_fb_udf';
******************************************************************)
function GetRound(
  var aNum:double
):integer; cdecl; export;

begin
  Result:=Round(aNum);
end;

(******************************************************************
Вернет абсолютное (без знака) значение от входного параметра
----------------------------
declare external function udfAbs
  integer
returns
  integer by value
entry_point 'GetAbs'
module_name 'ls_fb_udf';
******************************************************************)
function GetAbs(var i:integer):integer; cdecl; export;
begin
  if i <0 then Result:=-i
  else Result:=i;
end;

(******************************************************************
Вернет -1, если входной пареметр <0;
       иначе вернет 1
----------------------------
declare external function udfSign
  integer
returns
  integer by value
entry_point 'GetSign'
module_name 'ls_fb_udf';
******************************************************************)
function GetSign(var i:integer):integer; cdecl; export;
begin
  if i <0 then Result:=-1
  else Result:=1;
end;

(******************************************************************
Целочисленное деление X/Y
Если Y==0 результат:=0
----------------------------
declare external function udfDiv
  integer,              /* делимое */
  integer               /* делитель */
returns
  integer by value
entry_point 'GetDiv'
module_name 'ls_fb_udf';
******************************************************************)
function GetDiv(var x,y:integer):integer; cdecl; export;
begin
  if y =0 then Result:=0
  else Result:=x div y;
end;

(******************************************************************
Остаток от деления X/Y
(из хелпа DELPHI4:  x mod y Ё x-(x div y)*y)
Если Y==0 результат:=0
----------------------------
declare external function udfMod
  integer,             /* делимое */
  integer              /* делитель */
returns
  integer by value
entry_point 'GetMod'
module_name 'ls_fb_udf';
******************************************************************)
function GetMod(var x,y:integer):integer; cdecl; export;
begin
  if x =0 then Result:=0
  else Result:=x mod y;
end;

(******************************************************************
Возвращает текущие дату и время в формате DOUBLE
----------------------------
declare external function udfNow
returns
  double precision by value
entry_point 'GetNow'
module_name 'ls_fb_udf';
******************************************************************)
function GetNow:tDateTime; cdecl; export;
begin
  Result:=Now;
end;

(******************************************************************
Возвращает текущую дату в формате INTEGER (yyyymmdd)
----------------------------
declare external function udfTodayInt
returns
  integer by value
entry_point 'GetTodayInt'
module_name 'ls_fb_udf';
******************************************************************)
function GetTodayInt:integer; cdecl; export;
var
  y,m,d:word;

begin
  DecodeDate(Now,y,m,d);
  Result:=y*10000+m*100+d;
end;

(******************************************************************
Возвращает текущие дату и время в виде строки по формату yyyymmddhhnnss
----------------------------
declare external function udfGetDateTime
returns
  CString(32) free_it
entry_point 'GetDateTime'
module_name 'ls_fb_udf';
******************************************************************)
function GetDateTime:pChar; cdecl; export;

var
  s:string;

begin
  Result:=ib_util_malloc(17);
  s:=FormatDateTime('yyyymmddhhnnss',Now);
  StrPCopy(Result,s);
end;

(******************************************************************
Преобразует дату из tDateTime (DOUBLE) в INTEGER (yyyymmdd)
----------------------------
declare external function udfDate2Int
  double precision
returns
  integer by value
entry_point 'Date2Int'
module_name 'ls_fb_udf';
******************************************************************)
function Date2Int(var dt:tDateTime):integer; cdecl; export;
var
  d,m,y:word;

begin
  DecodeDate(dt, y,m,d);
  Result:=y*10000+m*100+d;
end;

(******************************************************************
Преобразует дату из INTEGER (yyyymmdd) в tDateTime (DOUBLE)
----------------------------
declare external function udfInt2Date
  integer
returns
  double precision by value
entry_point 'Int2Date'
module_name 'ls_fb_udf';
******************************************************************)
function Int2Date(var di:integer):tDateTime; cdecl; export;
begin
  Result:=EncodeDate(di div 10000,(di div 100) mod 100,di mod 100);
end;

(******************************************************************
Номер дня недели: 1=Пн...7=Вс (дата в INTEGER)
----------------------------
declare external function udfDOW
  integer
returns
  integer by value
entry_point 'GetDOW'
module_name 'ls_fb_udf';
******************************************************************)
function GetDOW(var di:integer):integer; cdecl; export;
begin
  Result:=pred(DayOfWeek(Int2Date(di)));
  if Result =0 then Result:=7;
end;

(******************************************************************
Номер дня недели: 1=Пн...7=Вс (дата в tDateTime)
----------------------------
declare external function udfDOWdt
  double precision
returns
  integer by value
entry_point 'GetDOWdt'
module_name 'ls_fb_udf';
******************************************************************)
function GetDOWdt(var dt:tDateTime):integer; cdecl; export;
begin
  Result:=pred(DayOfWeek(dt));
  if Result =0 then Result:=7;
end;

(******************************************************************
Является ли заданный год високосным: 0=год НЕ високосный; <>0=год високосный
----------------------------
declare external function udfIsLeapYear
  integer         /* дата (YYYYMMDD) для которой нужно проверить високосность года */
returns
  integer by value
entry_point 'IsLeapYear'
module_name 'ls_fb_udf';
******************************************************************)
function IsLeapYear(var di:integer):integer; cdecl; export;
var
  y:integer;

begin
  y:=di div 10000;

  if (y mod 4 =0) and (y mod 4000 <>0) and
     ((y mod 100 <>0) or (y mod 400 =0)) then
    Result:=1
  else
    Result:=0;
end;

(******************************************************************
К-во дней в заданном месяце указанного года
----------------------------
declare external function udfDaysInMonth
  integer         /* дата (YYYYMMDD) для месяца которой нужно узнать к-во дней */
returns
  integer by value
entry_point 'DaysInMonth'
module_name 'ls_fb_udf';
******************************************************************)
function DaysInMonth(var di:integer):integer; cdecl; export;
var
  m:integer;

begin
  m:=(di div 100) mod 100;

  case m of
    1,3,5,7,8,10,12: DaysInMonth:=31;
    4,6,9,11: DaysInMonth:=30;
    2: DaysInMonth:=28+Ord(IsLeapYear(di));
  else
    DaysInMonth:=0;
  end;
end;

(******************************************************************
Возвращает дату начала след.периода в формате YYYYMMDD
----------------------------
declare external function udfNextDay
  integer,         /* от какой даты считать */
  CString(2),      /* тип интервала:
                       'D'=day
                       'W'=week
                       'M'=month
                       'Q'=quarter
                       'Y'=year */
  integer          /* по какую дату считать */
returns
  integer by value
entry_point 'NextDay'
module_name 'ls_fb_udf';
******************************************************************)
function NextDay(
  var FrmDat:integer;
  IntType:pChar;
  var ToDat:integer
):integer; cdecl; export;

var
  y,m,d:integer;
  dt1,dt2:tDateTime;

begin
  if FrmDat >=ToDat then begin
    Result:=ToDat;
    exit;
  end;

  case IntType[0] of
    'D','d': begin
       dt1:=Int2Date(FrmDat);

       dt1:=IncDay(dt1,1);
       Result:=Date2Int(dt1);
    end;

    'W','w': begin
       dt1:=Int2Date(FrmDat);
       dt2:=Int2Date(ToDat);

       dt1:=IncDay(dt1,8-GetDOWdt(dt1));
       if dt1 >dt2 then Result:=Date2Int(dt2)
       else Result:=Date2Int(dt1);
    end;

    'M','m': begin
       IntDate2YMD(FrmDat, y,m,d);
       d:=1;  // первый день любого месяца
       if m <12 then
         Inc(m)
       else begin
          m:=1;
          Inc(y);
       end;
       Result:=YMD2IntDate(y,m,d);
       if Result >ToDat then Result:=ToDat;
    end;

    'Q','q': begin
       IntDate2YMD(FrmDat, y,m,d);
       case m of
         1..3: Result:=YMD2IntDate_(y,4,1);
         4..6: Result:=YMD2IntDate_(y,7,1);
         7..9: Result:=YMD2IntDate_(y,10,1);
       else {10..12:}
         Result:=YMD2IntDate_(y+1,1,1);
       end;
       if Result >ToDat then Result:=ToDat;
    end;

  else (* year *)
    Result:=YMD2IntDate_(XtractYear(FrmDat)+1,1,1);
    if Result >ToDat then Result:=ToDat;
  end; (*CASE*)
end;

(******************************************************************
Предыдущая дата от заданной (INTEGER)
----------------------------
declare external function udfPredDate
  integer
returns
  integer by value
entry_point 'PredDate'
module_name 'ls_fb_udf';
******************************************************************)
function PredDate(var di:integer):integer; cdecl; export;
var
  dt:tDateTime;

begin
  dt:=IncDay(Int2Date(di),-1);
  Result:=Date2Int(dt);
end;

(******************************************************************
Порядковый номер интервала в который попадает заданная дата

NOTE: Даты в формате YYYYMMDD
----------------------------
declare external function udfNumOfInterval
  integer,          /* дата: Dat */
  integer,          /* дата начала периода: FrmDat */
  CString(2)        /* тип интервала: 'D','W','M','Q','Y' */
returns
  integer by value
entry_point 'NumOfInterval'
module_name 'ls_fb_udf';
******************************************************************)
function NumOfInterval(
  var Dat:integer;
  var FrmDat:integer;
  it:pChar
):integer; cdecl; export;

var
  d,d1,dd:integer;

begin
  if Dat <FrmDat then
    Result:=-1
  else begin
    Result:=1;
    d:=FrmDat;
    dd:=21351118;
    d1:=NextDay(d,it,dd); d1:=PredDate(d1);

    while not ((Dat >=d) and (Dat <=d1)) do begin
      Inc(Result);
      d:=NextDay(d,it,dd);
      d1:=NextDay(d,it,dd); d1:=PredDate(d1);
    end;
  end;
end;

(******************************************************************
Порядковый номер интервала в который попадает заданная дата

NOTE: Даты в формате Interbase timestamp
----------------------------
declare external function udfNumOfInterval_TS
  timestamp,        /* дата: Dat */
  timestamp,        /* дата начала периода: FrmDat */
  CString(2)        /* тип интервала: 'D','W','M','Q','Y' */
returns
  integer by value
entry_point 'NumOfInterval_TS'
module_name 'ls_fb_udf';
******************************************************************)
function NumOfInterval_TS(
  var Dat:tIBTimeStamp;
  var FrmDat:tIBTimeStamp;
  it:pChar
):integer; cdecl; export;

var
  iDat,iFrmDat:integer;

begin
  iDat:=TimeStamp2IntDate(Dat);
  iFrmDat:=TimeStamp2IntDate(FrmDat);
  Result:=NumOfInterval(iDat,iFrmDat,it);
end;

(******************************************************************
Дату INTEGER -> в строку
----------------------------
declare external function udfIntDate2Str
  integer
returns
  CString(11) free_it
entry_point 'IntDate2Str'
module_name 'ls_fb_udf';
******************************************************************)
function IntDate2Str(var di:integer):pChar; cdecl; export;
begin
  Result:=ib_util_malloc(11);
  StrPCopy(Result,FormatDateTime('dd.mm.yyyy',Int2Date(di)));
end;

(* =================================================================
     Работа с элементами структуры деревьев

     Таблица символов для структуры:
       ! (33)  .. ~ (126)
       А (192) .. я (255)
   ================================================================= *)

function IncStructChr(c:char):char;
begin
  if c ='я' then
    Result:=' '   // 'я' последний символ в наборе
  else
    if c ='~' then
      // конец первой группы, переходим на вторую
      Result:='А'   // русская 'А' начинает вторую группу
    else
      // след символ
      Result:=char(ord(c)+1);
end;

(******************************************************************
Увеличивает элемент структуры

NOTES: если переполнение - вернет пустую строку '  '
----------------------------
declare external function udfIncStruct
  CString(3)
returns
  CString(3) free_it
entry_point 'IncStruct'
module_name 'ls_fb_udf';
******************************************************************)
function IncStruct(
  aSt:pChar
):pChar; cdecl; export;

var
  St:string;
  c1,c2:char;

begin
  St:=aSt;
  Result:=ib_util_malloc(3);

  c2:=IncStructChr(aSt[1]);

  if c2 =' ' then begin
    // если вернулся ПРОБЕЛ, значит второй символ был 'я'
    c1:=IncStructChr(aSt[0]);

    if c1 =' ' then
      // первый символ тоже 'я' - структура заполнена!
      StrPCopy(Result,'  ')  // возвращаем пробел, а что ещё возвращать-то? :-|
    else begin
      Result[0]:=c1; Result[1]:='!'; Result[2]:=#0;
    end;
  end
  else begin
    // второй символ увеличился, первый остаётся прежним
    Result[0]:=aSt[0]; Result[1]:=c2; Result[2]:=#0;
  end;
end;

(******************************************************************
Вернет общего родителя для структур s1 и s2

NOTES: Уровень структуры == 2 символа
       StrLen() - длина без учета null-terminator
----------------------------
declare external function udfGetCommonParent
  CString(40),
  CString(40)
returns
  CString(40) free_it
entry_point 'GetCommonParent'
module_name 'ls_fb_udf';
******************************************************************)
function GetCommonParent(
  s1:pChar;
  s2:pChar
):pChar; cdecl; export;
var
  i:integer;
  l:integer;

begin
  if (s1 =nil) or (s2 =nil) or
     (s1[0] =#0) or (s2[0] =#0) then begin
    Result:=pEmpty;
    exit;
  end;

  if StrLen(s1) <StrLen(s2) then l:=StrLen(s1)
  else l:=StrLen(s2);

  i:=0;

  while i <l do begin
    if (s1[i] <>s2[i]) or (s1[i+1] <>s2[i+1]) then begin
      Result:=ib_util_malloc(i+1);
      StrLCopy(Result,s1,i);
      Result[i]:=#0;
      exit;
    end;

    Inc(i,2);
  end;

  // структуры полностью совпадают
  Result:=ib_util_malloc(l+1);
  StrCopy(Result,s1);
end;

(* ================================================================= *)

exports
  { --- инициализация --- }
  InitUDFs,

  { --- булевы функции и работа с битами --- }
  GetAnd,        // Логическое И
  GetOr,         // Логическое ИЛИ
  GetXor,        // Логическое ИСКЛЮЧАЮЩЕЕ ИЛИ
  GetShr,        // Сдвиг ВПРАВО
  GetShl,        // Сдвиг ВЛЕВО

  { --- строковые функции --- }
  GetLen,        // Длина строки
  SubStr,        // Вернет подстроку от St с i1 по i2 позицию
                 // NOTES: позиции нумеруются с 1
  GetUpper,      // Переводит строку в ВЕРХНИЙ регистр
  GetLower,      // Переводит строку в НИЖНИЙ регистр
  GetTrim,       // Отрезает И начальные И конечные пробелы
  GetTrimLead,   // Отрезает начальные пробелы
  GetTrimTrail,  // Отрезает конечные пробелы
  MkStr,         // Формирует строку из символов C длиной N
  LeftPad,       // Дополненит строку St слева символом C до длины N
  RightPad,      // Дополненит строку St справа символом C до длины N
  CenterStr,     // Центрирует строку St по ширине N
  WordCount,     // К-во слов в строке
  WordPos,       // Позиция N-ного слова
  ExtractWord,   // Вернет N-нное слово
  GetChar,       // Вернет символ с кодом N
  TransStr,
  GetVar,        // Вернет значение переменной, имя которой в V
  Int2Str0,      // Из целого в строку, дополняя резкльтат слева '0' до 10 символов
  DupStr,        // Дублирует заданную строку N раз
  // --- Строковая арифметика в столбик ---
  AddStrCols,    // Складывает две строки чисел
  SubStrCols,    // Вычитает из первой строки чисел вторую
  SumStrCols,    // Суммирование всех чисел в строке
  MixStrCols,    // Чередует слова, взятые из первого и второго параметра
  // --- БЛОБы как строки ---
  BlobLen,         // Вернет размер BLOB`а
  BlobAsPChar,     // Вернет содержимое BLOB в виде CString(32700)
  StrToBlob,       // Запихнет строку S в BLOB
  BlobSubStr,      // Вернет подстроку от BLOB с i1 по i2 позицию
  BlobWordCount,   // К-во слов в строке
  BlobWordPos,     // Позиция N-ного слова
  BlobExtractWord, // Вернет N-нное слово

  { --- работа с числами --- }
  GetRnd,        // Вернет случайное число в заданном интервале
  GetTrunc,      // Вернет целую часть числа (без округления)
  GetRound,      // Вернет целую часть числа (с округлением)
  SCrc32,        // Вернет результат crc32 от входного параметра (строки)
  GetAbs,        // Вернет абсолютное (без знака) значение от входного параметра
  GetSign,       // Вернет -1, если входной пареметр <0; иначе вернет 1
  GetDiv,        // Целочисленное деление X/Y; Если Y==0 результат:=0
  GetMod,        // Остаток от деления X/Y

  { --- работа с датой и временем --- }
  GetNow,        // Возвращает текущие дату и время в формате DOUBLE
  GetTodayInt,   // Возвращает текущую дату в формате INTEGER (yyyymmdd)
  GetDateTime,   // Возвращает текущие дату и время в виде СТРОКИ по формату yyyymmddhhnnss
  Date2Int,      // Преобразует дату из tDateTime (DOUBLE) в INTEGER (yyyymmdd)
  Int2Date,      // Преобразует дату из INTEGER (yyyymmdd) в tDateTime (DOUBLE)
  GetDOW,        // Номер дня недели: 1=Пн...7=Вс (дата в INTEGER)
  GetDOWdt,      // Номер дня недели: 1=Пн...7=Вс (дата в tDateTime)
  IsLeapYear,    // Является ли заданный год високосным
  DaysInMonth,   // К-во дней в заданном месяце указанного года
  NextDay,       // Возвращает дату начала след.периода в формате INTEGER (yyyymmdd)
  PredDate,      // Предыдущая дата от заданной (INTEGER)
  IntDate2Str,   // Дату INTEGER -> в строку dd.mm.yy
  YMD2IntDate,   // Из дня, месяца, года в дату YYYYMMDD
  XtractDay,     // Вернет день из YYYYMMDD
  XtractMonth,   // Вернет месяц из YYYYMMDD
  XtractYear,    // Вернет год из YYYYMMDD
  UpdIntDate,    // Заменит день, месяц, год в дате типа YYYYMMDD
  TimeStamp2IntDate,  // IB timestamp -> YYYYMMDD
  IntDate2TimeStamp,  // YYYYMMDD -> IB timestamp
  NumOfInterval, // Порядковый номер интервала в который попадает заданная дата (YYYYMMDD)
  NumOfInterval_TS,  // Порядковый номер интервала в который попадает заданная дата (timestamp)

  { --- работа с элементами структуры деревьев --- }
  IncStruct,     // Уверичивает элемент структуры
  GetCommonParent,  // Вернет общего родителя для двух структур
  { --- специфические функции --- }
  GetLibVer,     // Вернет версию ad_UDF
  ObjHasAttrs,
  IncAttrId,
  EncryptPwd,    // Возвращает зашифрованный пароль в виде строкового представления HEX(crc32)
  CheckPwd;      // Проверяет пароль зашифрованный функцией EncryptPwd
                 // Вернет: 0-пароль неверен; <>0-пароль верен

begin
 IsMultiThread:=true;
 DecimalSeparator:='.';
end.
