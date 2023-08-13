/*
  √енераци€ базы SimpleDbTree
*/
set sql dialect 3;
set names Win1251;

input 'Connect.sql';
input '..\ls_fb_udf.sql';      -- подключаем udf
input 'StoredProcs.decl.sql';  -- объ€влени€ процедур (create)
input 'Tables.sql';            -- таблицы, генераторы, триггеры
input 'StoredProcs.impl.sql';  -- хранимые процедуры (alter)

commit;

/* создаем начальные данные */
input 'InitialData.sql';

commit work;
