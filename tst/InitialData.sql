/*
  Заносим начальные данные
*/
insert into SimpleTbl(
  Id,Name,PHash
)
values(
  0,'simple',(select oHash from strToHash('pimple'))
);
