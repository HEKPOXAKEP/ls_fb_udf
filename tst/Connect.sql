/*
 ���������� �� ������ ����� � �������� ����
*/
connect 'test-db.fdb';
drop database;

/* �������� ����� �� */
create database 'test-db.fdb'
--user 'SYSDBA' password 'masterkey'
page_size 8192
default character set Win1251 collation Win1251;

/* ���������� � ������� �� */
connect 'test-db.fdb';

/* ���������� ��������� �� */
commit;
