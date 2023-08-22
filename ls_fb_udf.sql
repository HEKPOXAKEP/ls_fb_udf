/*/\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//
//                                                   //
//           UDF для InterBase (FireBird)            //
//   Copyright (c) 2001-2023 Lagodrom Solutions Ltd  //
//              All rights reserved                  //
//                                                   //
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\/*/

/******************************************************************
Инициализация модуля ls_fb_udf
Вернет: 1=OK, 0=FAIL
******************************************************************/
declare external function udfInitUDFs
returns
  integer by value
entry_point 'InitUDFs'
module_name 'ls_fb_udf';

/******************************************************************
Вернет версию ls_fb_udf
******************************************************************/
declare external function udfLibVer
returns
  CString(33) free_it
entry_point 'GetLibVer'
module_name 'ls_fb_udf';

/******************************************************************
Инициализация менеджера событий

OUTPUT: 1=Ok; 0=Error
******************************************************************/
declare external function udfInitEvents
returns
  integer by value
entry_point 'InitEvents'
module_name 'ls_fb_udf';

/******************************************************************
Включает ли строка атрибутов объекта ObjA заданные в ChkA атрибуты
Вернет: 0 - не включает; >0 - включает

NOTES: атрибуты в ObjA и ChkA должны быть отсортированы в Asc-порядке
******************************************************************/
declare external function udfObjHasAttrs
  CString(4096),     /* Objs.A */
  CString(4096)      /* атрибуты, вхожесть которых в ObjA нужно проверить */
returns
  integer by value
entry_point 'ObjHasAttrs'
module_name 'ls_fb_udf';

/******************************************************************
Инкрементирует переданный двухсимвольный Id

NOTES: если переполнение - вернет пустую строку
******************************************************************/
declare external function udfIncAttrId
  CString(3)
returns
  CString(3) free_it
entry_point 'IncAttrId'
module_name 'ls_fb_udf';

/******************************************************************
Возвращает текущие дату и время в формате DOUBLE
******************************************************************/
declare external function udfNow
returns
  double precision by value
entry_point 'GetNow'
module_name 'ls_fb_udf';

/******************************************************************
Возвращает текущую дату в формате INTEGER (yyyymmdd)
******************************************************************/
declare external function udfTodayInt
returns
  integer by value
entry_point 'GetTodayInt'
module_name 'ls_fb_udf';

/******************************************************************
Возвращает текущие дату и время в виде строки по формату yyyymmddhhnnss
******************************************************************/
declare external function udfGetDateTime
returns
  CString(32) free_it
entry_point 'GetDateTime'
module_name 'ls_fb_udf';

/******************************************************************
Преобразует дату из tDateTime (DOUBLE) в INTEGER (yyyymmdd)
******************************************************************/
declare external function udfDate2Int
  double precision
returns
  integer by value
entry_point 'Date2Int'
module_name 'ls_fb_udf';

/******************************************************************
Преобразует дату из INTEGER (yyyymmdd) в tDateTime (DOUBLE)
******************************************************************/
declare external function udfInt2Date
  integer
returns
  double precision by value
entry_point 'Int2Date'
module_name 'ls_fb_udf';

/******************************************************************
Номер дня недели: 1=Пн...7=Вс (дата в INTEGER)
******************************************************************/
declare external function udfDOW
  integer
returns
  integer by value
entry_point 'GetDOW'
module_name 'ls_fb_udf';

/******************************************************************
Номер дня недели: 1=Пн...7=Вс (дата в tDateTime)
******************************************************************/
declare external function udfDOWdt
  double precision
returns
  integer by value
entry_point 'GetDOWdt'
module_name 'ls_fb_udf';

/******************************************************************
Является ли заданный год високосным: 0=год НЕ високосный; <>0=год високосный
******************************************************************/
declare external function udfIsLeapYear
  integer         /* дата (YYYYMMDD) для которой нужно проверить високосность года */
returns
  integer by value
entry_point 'IsLeapYear'
module_name 'ls_fb_udf';

/******************************************************************
К-во дней в заданном месяце указанного года
******************************************************************/
declare external function udfDaysInMonth
  integer         /* дата (YYYYMMDD) для месяца которой нужно узнать к-во дней */
returns
  integer by value
entry_point 'DaysInMonth'
module_name 'ls_fb_udf';

/******************************************************************
Возвращает дату начала след.периода в формате YYYYMMDD
******************************************************************/
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

/******************************************************************
Предыдущая дата от заданной (INTEGER)
******************************************************************/
declare external function udfPredDate
  integer
returns
  integer by value
entry_point 'PredDate'
module_name 'ls_fb_udf';

/******************************************************************
Порядковый номер интервала в который попадает заданная дата

NOTE: Даты в формате YYYYMMDD
******************************************************************/
declare external function udfNumOfInterval
  integer,          /* дата: Dat */
  integer,          /* дата начала периода: FrmDat */
  CString(2)        /* тип интервала: 'D','W','M','Q','Y' */
returns
  integer by value
entry_point 'NumOfInterval'
module_name 'ls_fb_udf';

/******************************************************************
Порядковый номер интервала в который попадает заданная дата

NOTE: Даты в формате Interbase timestamp
******************************************************************/
declare external function udfNumOfInterval_TS
  timestamp,        /* дата: Dat */
  timestamp,        /* дата начала периода: FrmDat */
  CString(2)        /* тип интервала: 'D','W','M','Q','Y' */
returns
  integer by value
entry_point 'NumOfInterval_TS'
module_name 'ls_fb_udf';

/******************************************************************
Дату INTEGER -> в строку
******************************************************************/
declare external function udfIntDate2Str
  integer
returns
  CString(11) free_it
entry_point 'IntDate2Str'
module_name 'ls_fb_udf';

/******************************************************************
Из составляющих в дату INTEGER (YYYYMMDD)
******************************************************************/
declare external function udfYMD2IntDate
  integer,     /* год */
  integer,     /* месяц */
  integer      /* год */
returns
  integer by value
entry_point 'YMD2IntDate'
module_name 'ls_fb_udf';

/******************************************************************
Вернет день из YYYYMMDD
******************************************************************/
declare external function udfXtractDay
  integer
returns
  integer by value
entry_point 'XtractDay'
module_name 'ls_fb_udf';

/******************************************************************
Вернет месяц из YYYYMMDD
******************************************************************/
declare external function udfXtractMonth
  integer
returns
  integer by value
entry_point 'XtractMonth'
module_name 'ls_fb_udf';

/******************************************************************
Вернет год из YYYYMMDD
******************************************************************/
declare external function udfXtractYear
  integer
returns
  integer by value
entry_point 'XtractYear'
module_name 'ls_fb_udf';

/******************************************************************
Заменит день, месяц, год в дате типа YYYYMMDD

NOTE: Те состовляющие, кот. <0 не изменяются
******************************************************************/
declare external function udfUpdIntDate
  integer,     /* изменяемая дата */
  integer,     /* год */
  integer,     /* месяц */
  integer      /* день */
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
Возвращает зашифрованный пароль в виде строкового представления HEX(crc32)
******************************************************************/
declare external function udfEncryptPwd
  CString(40)
returns
  CString(40) free_it
entry_point 'EncryptPwd'
module_name 'ls_fb_udf';

/******************************************************************
Проверяет пароль зашифрованный функцией EncryptPwd
Вернет: 0-пароль неверен; <>0-пароль верен
******************************************************************/
declare external function udfCheckPwd
  CString(40),      /* пароль */
  CString(40)       /* зашифрованный пароль */
returns
  integer by value
entry_point 'CheckPwd'
module_name 'ls_fb_udf';

/******************************************************************
Вернет случайное число в интервале от L до H
******************************************************************/
declare external function udfRnd
  integer,        /* нижняя граница */
  integer         /* верхняя граница */
returns
  integer by value
entry_point 'GetRnd'
module_name 'ls_fb_udf';

/******************************************************************
Результат бинарной операции AND
******************************************************************/
declare external function udfAnd
  integer,
  integer
returns
  integer by value
entry_point 'GetAnd'
module_name 'ls_fb_udf';

/******************************************************************
Результат бинарной операции OR
******************************************************************/
declare external function udfOr
  integer,
  integer
returns
  integer by value
entry_point 'GetOr'
module_name 'ls_fb_udf';

/******************************************************************
Результат бинарной операции XOR
******************************************************************/
declare external function udfXor
  integer,
  integer
returns
  integer by value
entry_point 'GetXor'
module_name 'ls_fb_udf';

/******************************************************************
Результат - циклический сдвиг вправо
******************************************************************/
declare external function udfShr
  integer,           /* сдвигаемое число */
  integer            /* на сколько битов */
returns
  integer by value
entry_point 'GetShr'
module_name 'ls_fb_udf';

/******************************************************************
Результат - циклический сдвиг влево
******************************************************************/
declare external function udfShl
  integer,           /* сдвигаемое число */
  integer            /* на сколько битов */
returns
  integer by value
entry_point 'GetShl'
module_name 'ls_fb_udf';

/******************************************************************
Вернет длину строки St
******************************************************************/
declare external function udfLen
  CString(32700)
returns
  integer by value
entry_point 'GetLen'
module_name 'ls_fb_udf';

/******************************************************************
Вернет подстроку от St с i1 по i2 позицию

NOTES: позиции нумеруются с 1
       StrLen() - длина без учета null-terminator
----------------------------
******************************************************************/
declare external function udfSubStr
  CString(32700),     /* строка */
  integer,            /* начальная позиция */
  integer             /* конечная позиция */
returns
  CString(32700) free_it
entry_point 'SubStr'
module_name 'ls_fb_udf';

/******************************************************************
Приведение строки к ВЕРХНЕМУ регистру
******************************************************************/
declare external function udfUpper
  CString(32700)
returns
  CString(32700) free_it
entry_point 'GetUpper'
module_name 'ls_fb_udf';

/******************************************************************
Приведение строки к НИЖНЕМУ регистру
******************************************************************/
declare external function udfLower
  CString(32700)
returns
  CString(32700) free_it
entry_point 'GetLower'
module_name 'ls_fb_udf';

/******************************************************************
Отрезает КОНЕЧНЫЕ пробелы
******************************************************************/
declare external function udfTrimTrail
  CString(32700)
returns
  CString(32700) free_it
entry_point 'GetTrimTrail'
module_name 'ls_fb_udf';

/******************************************************************
Отрезает НАЧАЛЬНЫЕ пробелы
******************************************************************/
declare external function udfTrimLead
  CString(32700)
returns
  CString(32700) free_it
entry_point 'GetTrimLead'
module_name 'ls_fb_udf';

/******************************************************************
Отрезает НАЧАЛЬНЫЕ и КОНЕЧНЫЕ пробелы
******************************************************************/
declare external function udfTrim
  CString(32700)
returns
  CString(32700) free_it
entry_point 'GetTrim'
module_name 'ls_fb_udf';

/******************************************************************
Формирует строку из символов C длиной N
******************************************************************/
declare external function udfMkStr
  CString(3),
  integer
returns
  CString(32700) free_it
entry_point 'MkStr'
module_name 'ls_fb_udf';

/******************************************************************
Дополняет строку St символами C слева до длины N

NOTES:  StrLen() - длина без учета null-terminator
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
Дополняет строку St символами C справа до длины N

NOTES:  StrLen() - длина без учета null-terminator
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
Центрирует строку St по ширине N

NOTES:  StrLen() - длина без учета null-terminator
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
Вернет к-во слов во входной строке S разделенных символами из строки Z
******************************************************************/
declare external function udfWordCount
  CString(32700),      /* строка: S */
  CString(255)         /* разделители: Z */
returns
  integer by value
entry_point 'WordCount'
module_name 'ls_fb_udf';

/******************************************************************
Вернет начальную позицию N-го слова в строке S, разделенного
делимитерами из строки Z
Если такого слова нет, вернет -1
******************************************************************/
declare external function udfWordPos
  integer,             /* номер слова в строке: N */
  CString(32700),      /* строка: S */
  CString(255)         /* разделители: Z */
returns
  integer by value
entry_point 'WordPos'
module_name 'ls_fb_udf';

/******************************************************************
Вернет слово номер N из строки S, разделители в Z
******************************************************************/
declare external function udfExtractWord
  integer,             /* номер слова в строке: N */
  CString(32700),      /* строка: S */
  CString(255)         /* разделители: Z */
returns
  CString(32700) free_it
entry_point 'ExtractWord'
module_name 'ls_fb_udf';

/******************************************************************
Вернет символ с кодом N
******************************************************************/
declare external function udfChar
  integer             /* код символа N */
returns
  CString(10) free_it
entry_point 'GetChar'
module_name 'ls_fb_udf';

/******************************************************************
Вернет строку сообщения, в которой макросы %1..%9 заменены
на аргументы из строки A
Аргументы в строке A должны быть разделены символом с кодом #3
******************************************************************/
declare external function udfTransStr
  CString(32700),      /* сообщение: S */
  CString(32700)       /* аргументы: A */
returns
  CString(32700) free_it
entry_point 'TransStr'
module_name 'ls_fb_udf';

/******************************************************************
Вернет значение переменной, имя которой в V
Формат входной строки S:
 - длина имени переменной - 2 +[0..1]
 - имя переменной - столько, сколько указано в длине
 - длина значения переменной - 3
 - значение переменной - столько, сколько указано в длине

Если переменная не найдена - вернет пустую строку
============ тест ==========
select '>'||udfGetVar(
 '03aBc003***'||'04aabc006сучка!',
 'aAbC'
)||'<' from rdb$database
******************************************************************/
declare external function udfGetVar
  CString(32700),      /* строка: S */
  CString(32700)       /* имя переменной: V */
returns
  CString(255) free_it
entry_point 'GetVar'
module_name 'ls_fb_udf';

/******************************************************************
Из целого в строку, дополняя резкльтат слева '0' до 10 символов
******************************************************************/
declare external function udfInt2Str0
  integer
returns
  CString(12) free_it
entry_point 'Int2Str0'
module_name 'ls_fb_udf';

/******************************************************************
Дублирует заданную строку N раз
******************************************************************/
declare external function udfDupStr
  CString(255),      /* строка, кот. нужно отдублировать: S */
  CString(2),        /* разделитель: Z */
  integer            /* к-во повторений: N */
returns
  CString(32700) free_it
entry_point 'DupStr'
module_name 'ls_fb_udf';

/******************************************************************
Складывает две строки чисел (сложение в столбик)

ВХОД: две строки чисел в символьном представлении (as double precision)
      разделенные символами, указанными в третьем параметре

ВЫХОД: строка, содержащая суммы чисел в символьном представлении,
       разделенные первым из символов, указанных в третьем параметре
******************************************************************/
declare external function udfAddStrCols
  CString(32700),    /* первое слагаемое: A1 */
  CString(32700),    /* второе слагаемое: A2 */
  CString(255)       /* строка разделителей: Z */
returns
  CString(32700) free_it
entry_point 'AddStrCols'
module_name 'ls_fb_udf';

/******************************************************************
Вычитает из первой строки чисел вторую (вычитание в столбик)
******************************************************************/
declare external function udfSubStrCols
  CString(32700),    /* уменьшаемое: A */
  CString(32700),    /* вычитаемое: S */
  CString(255)       /* строка разделителей: Z */
returns
  CString(32700) free_it
entry_point 'SubStrCols'
module_name 'ls_fb_udf';

/******************************************************************
Суммирование всех чисел в строке

NOTES:  StrLen() - длина без учета null-terminator
******************************************************************/
declare external function udfSumStrCols
  CString(32700),      /* строка чисел: S */
  CString(255)         /* символы-разделители чисел: Z */
returns
  CString(32700) free_it
entry_point 'SumStrCols'
module_name 'ls_fb_udf';

/******************************************************************
Чередует числа, взятые из первого и второго параметра
******************************************************************/
declare external function udfMixStrCols
  CString(32700),      /* строка слов #1: S1 */
  CString(32700),      /* строка слов #2: S2 */
  CString(255)         /* символы-разделители чисел: Z */
returns
  CString(32700) free_it
entry_point 'MixStrCols'
module_name 'ls_fb_udf';

/******************************************************************
Вернет подстроку от BLOB с i1 по i2 позицию

NOTES: позиции нумеруются с 1
******************************************************************/
declare external function udfBlobSubStr
  blob,               /* строка */
  integer,            /* начальная позиция */
  integer             /* конечная позиция */
returns
  CString(32700) free_it
entry_point 'BlobSubStr'
module_name 'ls_fb_udf';

/******************************************************************
Вернет длину BLOB`а
******************************************************************/
declare external function udfBlobLen
  blob
returns
  integer by value
entry_point 'BlobLen'
module_name 'ls_fb_udf';

/******************************************************************
Вернет содержимое BLOB в виде CString(32700)

NOTE: проверка на размер BLOB отсутствует
******************************************************************/
declare external function udfBlobAsPChar
  blob
returns
  CString(32700) free_it
entry_point 'BlobAsPChar'
module_name 'ls_fb_udf';

/******************************************************************
Запихивает строку S в BLOB
******************************************************************/
declare external function udfStrToBlob
  CString(32700),
  blob
returns
  parameter 2
entry_point 'StrToBlob'
module_name 'ls_fb_udf';

/******************************************************************
Вернет слово номер N из строки BLOB, разделители в Z
******************************************************************/
declare external function udfBlobExtractWord
  integer,             /* номер слова в строке: N */
  blob,                /* строка: BLOB */
  CString(32700)       /* разделители: Z */
returns
  CString(32700) free_it
entry_point 'BlobExtractWord'
module_name 'ls_fb_udf';

/******************************************************************
Вернет начальную позицию N-го слова в строке BLOB, разделенного
делимитерами из строки Z
Если такого слова нет, вернет -1

NOTES:  StrLen() - длина без учета null-terminator
******************************************************************/
declare external function udfBlobWordPos
  integer,             /* номер слова в строке: N */
  blob,                /* строка: Blob */
  CString(32700)       /* разделители: Z */
returns
  integer by value
entry_point 'BlobWordPos'
module_name 'ls_fb_udf';

/******************************************************************
Вернет к-во слов во входной строке BLOB разделенных символами из строки Z

NOTES:  StrLen() - длина без учета null-terminator
******************************************************************/
declare external function udfBlobWordCount
  blob,                /* строка: BLOB */
  CString(32700)       /* разделители: Z */
returns
  integer by value
entry_point 'BlobWordCount'
module_name 'ls_fb_udf';

/******************************************************************
Вернет целую часть числа (без округления)
******************************************************************/
declare external function udfTrunc
  double precision
returns
  integer by value
entry_point 'GetTrunc'
module_name 'ls_fb_udf';

/******************************************************************
Вернет целую часть числа (с округлением)
******************************************************************/
declare external function udfRound
  double precision
returns
  integer by value
entry_point 'GetRound'
module_name 'ls_fb_udf';

/******************************************************************
Вернет результат crc32 от входного параметра (строки)
******************************************************************/
declare external function udfCrc32
  CString(300)
returns
  integer by value
entry_point 'SCrc32'
module_name 'ls_fb_udf';

/******************************************************************
Вернет абсолютное (без знака) значение от входного параметра
******************************************************************/
declare external function udfAbs
  integer
returns
  integer by value
entry_point 'GetAbs'
module_name 'ls_fb_udf';

/******************************************************************
Вернет -1, если входной пареметр <0;
       иначе вернет 1
******************************************************************/
declare external function udfSign
  integer
returns
  integer by value
entry_point 'GetSign'
module_name 'ls_fb_udf';

/******************************************************************
Целочисленное деление X/Y
Если Y==0 результат:=0
******************************************************************/
declare external function udfDiv
  integer,              /* делимое */
  integer               /* делитель */
returns
  integer by value
entry_point 'GetDiv'
module_name 'ls_fb_udf';

/******************************************************************
Остаток от деления X/Y
(из хелпа DELPHI4:  x mod y и x-(x div y)*y)
Если Y==0 результат:=0
******************************************************************/
declare external function udfMod
  integer,             /* делимое */
  integer              /* делитель */
returns
  integer by value
entry_point 'GetMod'
module_name 'ls_fb_udf';

/******************************************************************
Увеличивает элемент структуры

Таблица символов для структуры:
  ! (33)  .. ~ (126)
  А (192) .. я (255)

NOTES: если переполнение - вернет пустую строку '  '
******************************************************************/
declare external function udfIncStruct
  CString(3)
returns
  CString(3) free_it
entry_point 'IncStruct'
module_name 'ls_fb_udf';

/******************************************************************
Вернет общего родителя для структур s1 и s2

NOTES: Уровень структуры == 2 символа
******************************************************************/
declare external function udfGetCommonParent
  CString(40),
  CString(40)
returns
  CString(40) free_it
entry_point 'GetCommonParent'
module_name 'ls_fb_udf';

/*
---------------------- Это все. Не ожидали? ----------------------
*/

commit;
