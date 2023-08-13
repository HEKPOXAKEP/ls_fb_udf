/*/\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//
//                                                   //
//           UDF ��� InterBase (FireBird)            //
//   Copyright (c) 2001-2023 Lagodrom Solutions Ltd  //
//              All rights reserved                  //
//                                                   //
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\/*/

/******************************************************************
������������� ������ ad_UDF
������: 1=OK, 0=FAIL
******************************************************************/
declare external function udfInitUDFs
returns
  integer by value
entry_point 'InitUDFs'
module_name 'ls_fb_udf';

/******************************************************************
������ ������ ad_UDF
******************************************************************/
declare external function udfLibVer
returns
  CString(33) free_it
entry_point 'GetLibVer'
module_name 'ls_fb_udf';

/******************************************************************
������������� ��������� �������

OUTPUT: 1=Ok; 0=Error
******************************************************************/
declare external function udfInitEvents
returns
  integer by value
entry_point 'InitEvents'
module_name 'ls_fb_udf';

/******************************************************************
�������� �� ������ ��������� ������� ObjA �������� � ChkA ��������
������: 0 - �� ��������; >0 - ��������

NOTES: �������� � ObjA � ChkA ������ ���� ������������� � Asc-�������
******************************************************************/
declare external function udfObjHasAttrs
  CString(4096),     /* Objs.A */
  CString(4096)      /* ��������, �������� ������� � ObjA ����� ��������� */
returns
  integer by value
entry_point 'ObjHasAttrs'
module_name 'ls_fb_udf';

/******************************************************************
�������������� ���������� �������������� Id

NOTES: ���� ������������ - ������ ������ ������
******************************************************************/
declare external function udfIncAttrId
  CString(3)
returns
  CString(3) free_it
entry_point 'IncAttrId'
module_name 'ls_fb_udf';

/******************************************************************
���������� ������� ���� � ����� � ������� DOUBLE
******************************************************************/
declare external function udfNow
returns
  double precision by value
entry_point 'GetNow'
module_name 'ls_fb_udf';

/******************************************************************
���������� ������� ���� � ������� INTEGER (yyyymmdd)
******************************************************************/
declare external function udfTodayInt
returns
  integer by value
entry_point 'GetTodayInt'
module_name 'ls_fb_udf';

/******************************************************************
���������� ������� ���� � ����� � ���� ������ �� ������� yyyymmddhhnnss
******************************************************************/
declare external function udfGetDateTime
returns
  CString(32) free_it
entry_point 'GetDateTime'
module_name 'ls_fb_udf';

/******************************************************************
����������� ���� �� tDateTime (DOUBLE) � INTEGER (yyyymmdd)
******************************************************************/
declare external function udfDate2Int
  double precision
returns
  integer by value
entry_point 'Date2Int'
module_name 'ls_fb_udf';

/******************************************************************
����������� ���� �� INTEGER (yyyymmdd) � tDateTime (DOUBLE)
******************************************************************/
declare external function udfInt2Date
  integer
returns
  double precision by value
entry_point 'Int2Date'
module_name 'ls_fb_udf';

/******************************************************************
����� ��� ������: 1=��...7=�� (���� � INTEGER)
******************************************************************/
declare external function udfDOW
  integer
returns
  integer by value
entry_point 'GetDOW'
module_name 'ls_fb_udf';

/******************************************************************
����� ��� ������: 1=��...7=�� (���� � tDateTime)
******************************************************************/
declare external function udfDOWdt
  double precision
returns
  integer by value
entry_point 'GetDOWdt'
module_name 'ls_fb_udf';

/******************************************************************
�������� �� �������� ��� ����������: 0=��� �� ����������; <>0=��� ����������
******************************************************************/
declare external function udfIsLeapYear
  integer         /* ���� (YYYYMMDD) ��� ������� ����� ��������� ������������ ���� */
returns
  integer by value
entry_point 'IsLeapYear'
module_name 'ls_fb_udf';

/******************************************************************
�-�� ���� � �������� ������ ���������� ����
******************************************************************/
declare external function udfDaysInMonth
  integer         /* ���� (YYYYMMDD) ��� ������ ������� ����� ������ �-�� ���� */
returns
  integer by value
entry_point 'DaysInMonth'
module_name 'ls_fb_udf';

/******************************************************************
���������� ���� ������ ����.������� � ������� YYYYMMDD
******************************************************************/
declare external function udfNextDay
  integer,         /* �� ����� ���� ������� */
  CString(2),      /* ��� ���������:
                       'D'=day
                       'W'=week
                       'M'=month
                       'Q'=quarter
                       'Y'=year */
  integer          /* �� ����� ���� ������� */
returns
  integer by value
entry_point 'NextDay'
module_name 'ls_fb_udf';

/******************************************************************
���������� ���� �� �������� (INTEGER)
******************************************************************/
declare external function udfPredDate
  integer
returns
  integer by value
entry_point 'PredDate'
module_name 'ls_fb_udf';

/******************************************************************
���������� ����� ��������� � ������� �������� �������� ����

NOTE: ���� � ������� YYYYMMDD
******************************************************************/
declare external function udfNumOfInterval
  integer,          /* ����: Dat */
  integer,          /* ���� ������ �������: FrmDat */
  CString(2)        /* ��� ���������: 'D','W','M','Q','Y' */
returns
  integer by value
entry_point 'NumOfInterval'
module_name 'ls_fb_udf';

/******************************************************************
���������� ����� ��������� � ������� �������� �������� ����

NOTE: ���� � ������� Interbase timestamp
******************************************************************/
declare external function udfNumOfInterval_TS
  timestamp,        /* ����: Dat */
  timestamp,        /* ���� ������ �������: FrmDat */
  CString(2)        /* ��� ���������: 'D','W','M','Q','Y' */
returns
  integer by value
entry_point 'NumOfInterval_TS'
module_name 'ls_fb_udf';

/******************************************************************
���� INTEGER -> � ������
******************************************************************/
declare external function udfIntDate2Str
  integer
returns
  CString(11) free_it
entry_point 'IntDate2Str'
module_name 'ls_fb_udf';

/******************************************************************
�� ������������ � ���� INTEGER (YYYYMMDD)
******************************************************************/
declare external function udfYMD2IntDate
  integer,     /* ��� */
  integer,     /* ����� */
  integer      /* ��� */
returns
  integer by value
entry_point 'YMD2IntDate'
module_name 'ls_fb_udf';

/******************************************************************
������ ���� �� YYYYMMDD
******************************************************************/
declare external function udfXtractDay
  integer
returns
  integer by value
entry_point 'XtractDay'
module_name 'ls_fb_udf';

/******************************************************************
������ ����� �� YYYYMMDD
******************************************************************/
declare external function udfXtractMonth
  integer
returns
  integer by value
entry_point 'XtractMonth'
module_name 'ls_fb_udf';

/******************************************************************
������ ��� �� YYYYMMDD
******************************************************************/
declare external function udfXtractYear
  integer
returns
  integer by value
entry_point 'XtractYear'
module_name 'ls_fb_udf';

/******************************************************************
������� ����, �����, ��� � ���� ���� YYYYMMDD

NOTE: �� ������������, ���. <0 �� ����������
******************************************************************/
declare external function udfUpdIntDate
  integer,     /* ���������� ���� */
  integer,     /* ��� */
  integer,     /* ����� */
  integer      /* ���� */
returns
  integer by value
entry_point 'UpdIntDate'
module_name 'ls_fb_udf';

/******************************************************************
IB timestamp -> YYYYMMDD
******************************************************************/
declare external function udfTimeStamp2IntDate
  timestamp
returns
  integer by value
entry_point 'TimeStamp2IntDate'
module_name 'ls_fb_udf';

/******************************************************************
YYYYMMDD -> IB timestamp
******************************************************************/
declare external function udfIntDate2TimeStamp
  integer,
  timestamp
returns
  parameter 2
entry_point 'IntDate2TimeStamp'
module_name 'ls_fb_udf';

/******************************************************************
���������� ������������� ������ � ���� ���������� ������������� HEX(crc32)
******************************************************************/
declare external function udfEncryptPwd
  CString(40)
returns
  CString(40) free_it
entry_point 'EncryptPwd'
module_name 'ls_fb_udf';

/******************************************************************
��������� ������ ������������� �������� EncryptPwd
������: 0-������ �������; <>0-������ �����
******************************************************************/
declare external function udfCheckPwd
  CString(40),      /* ������ */
  CString(40)       /* ������������� ������ */
returns
  integer by value
entry_point 'CheckPwd'
module_name 'ls_fb_udf';

/******************************************************************
������ ��������� ����� � ��������� �� L �� H
******************************************************************/
declare external function udfRnd
  integer,        /* ������ ������� */
  integer         /* ������� ������� */
returns
  integer by value
entry_point 'GetRnd'
module_name 'ls_fb_udf';

/******************************************************************
��������� �������� �������� AND
******************************************************************/
declare external function udfAnd
  integer,
  integer
returns
  integer by value
entry_point 'GetAnd'
module_name 'ls_fb_udf';

/******************************************************************
��������� �������� �������� OR
******************************************************************/
declare external function udfOr
  integer,
  integer
returns
  integer by value
entry_point 'GetOr'
module_name 'ls_fb_udf';

/******************************************************************
��������� �������� �������� XOR
******************************************************************/
declare external function udfXor
  integer,
  integer
returns
  integer by value
entry_point 'GetXor'
module_name 'ls_fb_udf';

/******************************************************************
��������� - ����������� ����� ������
******************************************************************/
declare external function udfShr
  integer,           /* ���������� ����� */
  integer            /* �� ������� ����� */
returns
  integer by value
entry_point 'GetShr'
module_name 'ls_fb_udf';

/******************************************************************
��������� - ����������� ����� �����
******************************************************************/
declare external function udfShl
  integer,           /* ���������� ����� */
  integer            /* �� ������� ����� */
returns
  integer by value
entry_point 'GetShl'
module_name 'ls_fb_udf';

/******************************************************************
������ ����� ������ St
******************************************************************/
declare external function udfLen
  CString(32700)
returns
  integer by value
entry_point 'GetLen'
module_name 'ls_fb_udf';

/******************************************************************
������ ��������� �� St � i1 �� i2 �������

NOTES: ������� ���������� � 1
       StrLen() - ����� ��� ����� null-terminator
----------------------------
******************************************************************/
declare external function udfSubStr
  CString(32700),     /* ������ */
  integer,            /* ��������� ������� */
  integer             /* �������� ������� */
returns
  CString(32700) free_it
entry_point 'SubStr'
module_name 'ls_fb_udf';

/******************************************************************
���������� ������ � �������� ��������
******************************************************************/
declare external function udfUpper
  CString(32700)
returns
  CString(32700) free_it
entry_point 'GetUpper'
module_name 'ls_fb_udf';

/******************************************************************
���������� ������ � ������� ��������
******************************************************************/
declare external function udfLower
  CString(32700)
returns
  CString(32700) free_it
entry_point 'GetLower'
module_name 'ls_fb_udf';

/******************************************************************
�������� �������� �������
******************************************************************/
declare external function udfTrimTrail
  CString(32700)
returns
  CString(32700) free_it
entry_point 'GetTrimTrail'
module_name 'ls_fb_udf';

/******************************************************************
�������� ��������� �������
******************************************************************/
declare external function udfTrimLead
  CString(32700)
returns
  CString(32700) free_it
entry_point 'GetTrimLead'
module_name 'ls_fb_udf';

/******************************************************************
�������� ��������� � �������� �������
******************************************************************/
declare external function udfTrim
  CString(32700)
returns
  CString(32700) free_it
entry_point 'GetTrim'
module_name 'ls_fb_udf';

/******************************************************************
��������� ������ �� �������� C ������ N
******************************************************************/
declare external function udfMkStr
  CString(3),
  integer
returns
  CString(32700) free_it
entry_point 'MkStr'
module_name 'ls_fb_udf';

/******************************************************************
��������� ������ St ��������� C ����� �� ����� N

NOTES:  StrLen() - ����� ��� ����� null-terminator
******************************************************************/
declare external function udfLeftPad
  CString(2),
  CString(32700),
  integer
returns
  CString(32700) free_it
entry_point 'LeftPad'
module_name 'ls_fb_udf';

/******************************************************************
��������� ������ St ��������� C ������ �� ����� N

NOTES:  StrLen() - ����� ��� ����� null-terminator
******************************************************************/
declare external function udfRightPad
  CString(2),
  CString(32700),
  integer
returns
  CString(32700) free_it
entry_point 'RightPad'
module_name 'ls_fb_udf';

/******************************************************************
���������� ������ St �� ������ N

NOTES:  StrLen() - ����� ��� ����� null-terminator
******************************************************************/
declare external function udfCenterStr
  CString(32700),
  integer,
  CString(2)
returns
  CString(32700) free_it
entry_point 'CenterStr'
module_name 'ls_fb_udf';

/******************************************************************
������ �-�� ���� �� ������� ������ S ����������� ��������� �� ������ Z
******************************************************************/
declare external function udfWordCount
  CString(32700),      /* ������: S */
  CString(255)         /* �����������: Z */
returns
  integer by value
entry_point 'WordCount'
module_name 'ls_fb_udf';

/******************************************************************
������ ��������� ������� N-�� ����� � ������ S, ������������
������������ �� ������ Z
���� ������ ����� ���, ������ -1
******************************************************************/
declare external function udfWordPos
  integer,             /* ����� ����� � ������: N */
  CString(32700),      /* ������: S */
  CString(255)         /* �����������: Z */
returns
  integer by value
entry_point 'WordPos'
module_name 'ls_fb_udf';

/******************************************************************
������ ����� ����� N �� ������ S, ����������� � Z
******************************************************************/
declare external function udfExtractWord
  integer,             /* ����� ����� � ������: N */
  CString(32700),      /* ������: S */
  CString(255)         /* �����������: Z */
returns
  CString(32700) free_it
entry_point 'ExtractWord'
module_name 'ls_fb_udf';

/******************************************************************
������ ������ � ����� N
******************************************************************/
declare external function udfChar
  integer             /* ��� ������� N */
returns
  CString(10) free_it
entry_point 'GetChar'
module_name 'ls_fb_udf';

/******************************************************************
������ ������ ���������, � ������� ������� %1..%9 ��������
�� ��������� �� ������ A
��������� � ������ A ������ ���� ��������� �������� � ����� #3
******************************************************************/
declare external function udfTransStr
  CString(32700),      /* ���������: S */
  CString(32700)       /* ���������: A */
returns
  CString(32700) free_it
entry_point 'TransStr'
module_name 'ls_fb_udf';

/******************************************************************
������ �������� ����������, ��� ������� � V
������ ������� ������ S:
 - ����� ����� ���������� - 2 +[0..1]
 - ��� ���������� - �������, ������� ������� � �����
 - ����� �������� ���������� - 3
 - �������� ���������� - �������, ������� ������� � �����

���� ���������� �� ������� - ������ ������ ������
============ ���� ==========
select '>'||udfGetVar(
 '03aBc003***'||'04aabc006�����!',
 'aAbC'
)||'<' from rdb$database
******************************************************************/
declare external function udfGetVar
  CString(32700),      /* ������: S */
  CString(32700)       /* ��� ����������: V */
returns
  CString(255) free_it
entry_point 'GetVar'
module_name 'ls_fb_udf';

/******************************************************************
�� ������ � ������, �������� ��������� ����� '0' �� 10 ��������
******************************************************************/
declare external function udfInt2Str0
  integer
returns
  CString(12) free_it
entry_point 'Int2Str0'
module_name 'ls_fb_udf';

/******************************************************************
��������� �������� ������ N ���
******************************************************************/
declare external function udfDupStr
  CString(255),      /* ������, ���. ����� �������������: S */
  CString(2),        /* �����������: Z */
  integer            /* �-�� ����������: N */
returns
  CString(32700) free_it
entry_point 'DupStr'
module_name 'ls_fb_udf';

/******************************************************************
���������� ��� ������ ����� (�������� � �������)

����: ��� ������ ����� � ���������� ������������� (as double precision)
      ����������� ���������, ���������� � ������� ���������

�����: ������, ���������� ����� ����� � ���������� �������������,
       ����������� ������ �� ��������, ��������� � ������� ���������
******************************************************************/
declare external function udfAddStrCols
  CString(32700),    /* ������ ���������: A1 */
  CString(32700),    /* ������ ���������: A2 */
  CString(255)       /* ������ ������������: Z */
returns
  CString(32700) free_it
entry_point 'AddStrCols'
module_name 'ls_fb_udf';

/******************************************************************
�������� �� ������ ������ ����� ������ (��������� � �������)
******************************************************************/
declare external function udfSubStrCols
  CString(32700),    /* �����������: A */
  CString(32700),    /* ����������: S */
  CString(255)       /* ������ ������������: Z */
returns
  CString(32700) free_it
entry_point 'SubStrCols'
module_name 'ls_fb_udf';

/******************************************************************
������������ ���� ����� � ������

NOTES:  StrLen() - ����� ��� ����� null-terminator
******************************************************************/
declare external function udfSumStrCols
  CString(32700),      /* ������ �����: S */
  CString(255)         /* �������-����������� �����: Z */
returns
  CString(32700) free_it
entry_point 'SumStrCols'
module_name 'ls_fb_udf';

/******************************************************************
�������� �����, ������ �� ������� � ������� ���������
******************************************************************/
declare external function udfMixStrCols
  CString(32700),      /* ������ ���� #1: S1 */
  CString(32700),      /* ������ ���� #2: S2 */
  CString(255)         /* �������-����������� �����: Z */
returns
  CString(32700) free_it
entry_point 'MixStrCols'
module_name 'ls_fb_udf';

/******************************************************************
������ ��������� �� BLOB � i1 �� i2 �������

NOTES: ������� ���������� � 1
******************************************************************/
declare external function udfBlobSubStr
  blob,               /* ������ */
  integer,            /* ��������� ������� */
  integer             /* �������� ������� */
returns
  CString(32700) free_it
entry_point 'BlobSubStr'
module_name 'ls_fb_udf';

/******************************************************************
������ ����� BLOB`�
******************************************************************/
declare external function udfBlobLen
  blob
returns
  integer by value
entry_point 'BlobLen'
module_name 'ls_fb_udf';

/******************************************************************
������ ���������� BLOB � ���� CString(32700)

NOTE: �������� �� ������ BLOB �����������
******************************************************************/
declare external function udfBlobAsPChar
  blob
returns
  CString(32700) free_it
entry_point 'BlobAsPChar'
module_name 'ls_fb_udf';

/******************************************************************
���������� ������ S � BLOB
******************************************************************/
declare external function udfStrToBlob
  CString(32700),
  blob
returns
  parameter 2
entry_point 'StrToBlob'
module_name 'ls_fb_udf';

/******************************************************************
������ ����� ����� N �� ������ BLOB, ����������� � Z
******************************************************************/
declare external function udfBlobExtractWord
  integer,             /* ����� ����� � ������: N */
  blob,                /* ������: BLOB */
  CString(32700)       /* �����������: Z */
returns
  CString(32700) free_it
entry_point 'BlobExtractWord'
module_name 'ls_fb_udf';

/******************************************************************
������ ��������� ������� N-�� ����� � ������ BLOB, ������������
������������ �� ������ Z
���� ������ ����� ���, ������ -1

NOTES:  StrLen() - ����� ��� ����� null-terminator
******************************************************************/
declare external function udfBlobWordPos
  integer,             /* ����� ����� � ������: N */
  blob,                /* ������: Blob */
  CString(32700)       /* �����������: Z */
returns
  integer by value
entry_point 'BlobWordPos'
module_name 'ls_fb_udf';

/******************************************************************
������ �-�� ���� �� ������� ������ BLOB ����������� ��������� �� ������ Z

NOTES:  StrLen() - ����� ��� ����� null-terminator
******************************************************************/
declare external function udfBlobWordCount
  blob,                /* ������: BLOB */
  CString(32700)       /* �����������: Z */
returns
  integer by value
entry_point 'BlobWordCount'
module_name 'ls_fb_udf';

/******************************************************************
������ ����� ����� ����� (��� ����������)
******************************************************************/
declare external function udfTrunc
  double precision
returns
  integer by value
entry_point 'GetTrunc'
module_name 'ls_fb_udf';

/******************************************************************
������ ����� ����� ����� (� �����������)
******************************************************************/
declare external function udfRound
  double precision
returns
  integer by value
entry_point 'GetRound'
module_name 'ls_fb_udf';

/******************************************************************
������ ��������� crc32 �� �������� ��������� (������)
******************************************************************/
declare external function udfCrc32
  CString(300)
returns
  integer by value
entry_point 'SCrc32'
module_name 'ls_fb_udf';

/******************************************************************
������ ���������� (��� �����) �������� �� �������� ���������
******************************************************************/
declare external function udfAbs
  integer
returns
  integer by value
entry_point 'GetAbs'
module_name 'ls_fb_udf';

/******************************************************************
������ -1, ���� ������� �������� <0;
       ����� ������ 1
******************************************************************/
declare external function udfSign
  integer
returns
  integer by value
entry_point 'GetSign'
module_name 'ls_fb_udf';

/******************************************************************
������������� ������� X/Y
���� Y==0 ���������:=0
******************************************************************/
declare external function udfDiv
  integer,              /* ������� */
  integer               /* �������� */
returns
  integer by value
entry_point 'GetDiv'
module_name 'ls_fb_udf';

/******************************************************************
������� �� ������� X/Y
(�� ����� DELPHI4:  x mod y � x-(x div y)*y)
���� Y==0 ���������:=0
******************************************************************/
declare external function udfMod
  integer,             /* ������� */
  integer              /* �������� */
returns
  integer by value
entry_point 'GetMod'
module_name 'ls_fb_udf';

/******************************************************************
����������� ������� ���������

������� �������� ��� ���������:
  ! (33)  .. ~ (126)
  � (192) .. � (255)

NOTES: ���� ������������ - ������ ������ ������ '  '
******************************************************************/
declare external function udfIncStruct
  CString(3)
returns
  CString(3) free_it
entry_point 'IncStruct'
module_name 'ls_fb_udf';

/******************************************************************
������ ������ �������� ��� �������� s1 � s2

NOTES: ������� ��������� == 2 �������
******************************************************************/
declare external function udfGetCommonParent
  CString(40),
  CString(40)
returns
  CString(40) free_it
entry_point 'GetCommonParent'
module_name 'ls_fb_udf';

/*
---------------------- ��� ���. �� �������? ----------------------
*/

commit;
