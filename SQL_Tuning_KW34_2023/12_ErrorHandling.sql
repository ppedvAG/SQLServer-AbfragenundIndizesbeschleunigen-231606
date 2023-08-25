/*
- TRY/CATCH
- RAISERROR
- THROW
*/

--Idee: Procedure die 2 Updates durchführt; beide sollen fehlerfrei laufen, oder beide rollback:
CREATE PROC spWhatever @var1 int
AS
BEGIN TRAN
UPDATE Links
SET Werte = 1
UPDATE Rechts
SET Werte = 3
COMMIT
--Funktioniert so nicht; das Update ohne Fehler wird auf diese Art trotzdem commited!


--Lösung über TRY & CATCH Blöcke; treten immer als "Paar" auf:
--Wenn TRY Block einen Fehler auswirft, geht Programmsteuerung an den zugehörigen CATCH Block über
--Wenn kein Fehler, dann wird CATCH Block übersprungen/ignoriert

CREATE PROC spWhatever @var1 int = 1
AS

BEGIN TRAN

BEGIN TRY --öffnet den TRY Block
UPDATE Links
SET Werte = 1

UPDATE Rechts
SET Werte = 3
--COMMIT auch hier gültig
END TRY --schließt den TRY Block


BEGIN CATCH --öffnet CATCH Block
RAISERROR()
ROLLBACK
END CATCH --schließt CATCH Block

COMMIT


--RAISERROR: Gibt einen Systemfehler, oder eine custom Fehlermessage aus

RAISERROR(50003, 1, 1) --(FehlerID, Severity, Ebene)

SELECT * FROM sys.messages --Fehlerkatalog des SQL Servers; hier können auch Custommessages abgelegt werden

EXEC sp_addmessage --SysProcedure um neue Fehlermeldung hinzuzufügen

/*
Severity = Schweregrad des Fehlers; 
1 - 10 "nicht schwerwiegender Fehler": Gibt Fehlermeldung aus, aber stoppt Skript nicht
11 - 18 "Critical Error": Stoppt das Skript
19 - 25 Error der geloggt wird
*/
RAISERROR(50003,25, 1) WITH LOG --WITH LOG nur sysAdmin und nur bei Severity 19-25


--THROW: Ähnlich wie RAISERROR; Funktioniert nur innerhalb eines CATCH Blocks;
--Severity ist immer auf 16 (Critical Error); Kann nicht angepasst werden.

THROW 