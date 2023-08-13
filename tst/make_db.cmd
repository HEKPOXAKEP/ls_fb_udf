@echo off
@del rez
echo Creating database...
"C:\Program Files (x86)\Firebird_2_5\bin\isql.exe" -i Main.sql -o rez -q -m -u SYSDBA -p masterkey
echo Done.
echo Renaming database...
ren "TEST-DB.FDB" "test-db.fdb"
echo Done.