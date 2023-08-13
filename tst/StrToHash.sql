/*
  ��������� ��� �� ������ ������ �� ��������� ELF Hash
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

  oHash=hash(aStr||'����� �� ��� ���� ������ ����������� ����� �� ����� �����');

  suspend;
end^

set term ; ^
