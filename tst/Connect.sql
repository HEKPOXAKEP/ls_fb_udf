/*
 Соединение со старой базой и удаление оной
*/
connect 'test-db.fdb';
drop database;

/* создание новой БД */
create database 'test-db.fdb'
--user 'SYSDBA' password 'masterkey'
page_size 8192
default character set Win1251 collation Win1251;

/* соединение с созаной БД */
connect 'test-db.fdb';

/* запоминаем изменения БД */
commit;
