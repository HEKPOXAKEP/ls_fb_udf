/*
  ќбъ€вление хранимых процедур (interface)
*/
set term ^ ;

create procedure strToHash(
  aStr varchar(32))
returns(
  oHash bigint)
as begin
  suspend;
end^

set term ; ^
