/*
  Вычисляет хэш из строки пароля по алгоритму ELF Hash
*/
set term ^ ;

alter procedure strToHash (
  aStr varchar(32))
returns (
  oHash bigint)
as
begin
  if (aStr is null) then
    aStr='';

  oHash=hash(aStr||'Съешь же ещё этих мягких французских булок да выпей кофию');

  suspend;
end^

set term ; ^
