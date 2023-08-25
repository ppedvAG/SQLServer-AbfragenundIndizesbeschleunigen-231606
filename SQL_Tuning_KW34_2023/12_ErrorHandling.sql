/*
- TRY/CATCH
- RAISERROR
- THROW
*/

--Idee: Procedure die 2 Updates durchf�hrt; beide sollen fehlerfrei laufen, oder beide rollback:
CREATE PROC spWhatever @var1 int
AS
BEGIN TRAN
UPDATE Links
SET Werte = 1
UPDATE Rechts
SET Werte = 3
COMMIT
--Funktioniert so nicht; das Update ohne Fehler wird auf diese Art trotzdem commited!


--L�sung �ber TRY & CATCH Bl�cke; treten immer als "Paar" auf:
--Wenn TRY Block einen Fehler auswirft, geht Programmsteuerung an den zugeh�rigen CATCH Block �ber
--Wenn kein Fehler, dann wird CATCH Block �bersprungen/ignoriert

CREATE PROC spWhatever @var1 int = 1
AS

BEGIN TRAN

BEGIN TRY --�ffnet den TRY Block
UPDATE Links
SET Werte = 1

UPDATE Rechts
SET Werte = 3
--COMMIT auch hier g�ltig
END TRY --schlie�t den TRY Block


BEGIN CATCH --�ffnet CATCH Block
RAISERROR()
ROLLBACK
END CATCH --schlie�t CATCH Block

COMMIT


--RAISERROR: Gibt einen Systemfehler, oder eine custom Fehlermessage aus

RAISERROR(50003, 1, 1) --(FehlerID, Severity, Ebene)

SELECT * FROM sys.messages --Fehlerkatalog des SQL Servers; hier k�nnen auch Custommessages abgelegt werden

EXEC sp_addmessage --SysProcedure um neue Fehlermeldung hinzuzuf�gen

/*
Severity = Schweregrad des Fehlers; 
1 - 10 "nicht schwerwiegender Fehler": Gibt Fehlermeldung aus, aber stoppt Skript nicht
11 - 18 "Critical Error": Stoppt das Skript
19 - 25 Error der geloggt wird
*/
RAISERROR(50003,25, 1) WITH LOG --WITH LOG nur sysAdmin und nur bei Severity 19-25


--THROW: �hnlich wie RAISERROR; Funktioniert nur innerhalb eines CATCH Blocks;
--Severity ist immer auf 16 (Critical Error); Kann nicht angepasst werden.

THROW 