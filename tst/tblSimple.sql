/*
  Тестовая таблица
*/
create table SimpleTbl(
  Id integer not null,
  Name varchar(32),
  PHash bigint not null,
  MDate timestamp,
  Z smallint default 1,
--
  constraint pk_SimpleTbl primary key(Id),
  constraint ix_Simple_Name_Asc unique (Name)
);

create generator gen_SimpleTbl_Id;
set generator gen_SimpleTbl_Id to 0;

set term ^ ;

create trigger bi_SimpleTbl for SimpleTbl
active before insert position 0
as
begin
  if (new.Id is null) then
    new.Id=gen_id(gen_SimpleTbl_Id,1);

  if (new.PHash is null) then
    execute procedure strToHash('')
    returning_values(new.PHash);

  if (new.MDate is null) then
    new.MDate=current_timestamp;
end^

set term ; ^
