/*
Procedures sind toll, da der Abfrageplan immer wieder verwendet werden kann, ohne neu zu kompilieren!
Aber: Manchmal auch hinderlich, bspw. bei stark ungleich verteilten Werten:
*/

--Adhoc Abfragen generieren bei jedem Aufruf einen neuen Plan:
SELECT CompanyName FROM Customers


--Test Tabelle vorbereiten:
CREATE TABLE Sniffing (
ID int identity,
Buchstabe varchar(5) )

INSERT INTO Sniffing
VALUES ('A')
GO 10

INSERT INTO Sniffing
VALUES ('B')
GO 10

INSERT INTO Sniffing
VALUES ('C')
GO 10000


CREATE CLUSTERED INDEX CIX_Sniffing_ID ON Sniffing (ID)
CREATE NONCLUSTERED INDEX NCIX_Sniffing_Buchstaben ON Sniffing (Buchstabe)


--Procedures bekommen ihren Abfrageplan beim ERSTEN Aufruf (erster Execute):

CREATE PROCEDURE spSniffing2 @Buchstabe varchar(5)
AS
SELECT ID FROM Sniffing
WHERE Buchstabe = @Buchstabe
GO

--Erste Ausf�hrung:
EXEC spSniffing2 A

--Zweite Ausf�hrung:
EXEC spSniffing2 C

--Der zweite Aufruf erwartet nur 10 Zeilen, es sind aber tats�chlich 10000!
--> Zu wenig bereitgestellte Ressourcen f�r die Abfrage --> Performance leidet


CREATE PROCEDURE spSniffing3 @Buchstabe varchar(5)
AS
SELECT ID FROM Sniffing
WHERE Buchstabe = @Buchstabe
GO

--Erste Ausf�hrung:
EXEC spSniffing3 C

--Zweite Ausf�hrung:
EXEC spSniffing3 B

--Der zweite Aufruf erwartet 10000 Zeilen, es sind aber tats�chlich nur 10!
--> Zu viele bereitgestellte Ressourcen f�r die Abfrage --> Performance leidet u.U. bei anderen Abfragen (Memory starvation)


--"L�sung":

--OPTIMIZE FOR HINT: Optimiert den Abfrageplan f�r einen gewissen Parameterwert, unabh�ngig vom ersten Aufruf

CREATE PROCEDURE spSniffing4 @Buchstabe varchar(5)
AS
SELECT ID FROM Sniffing
WHERE Buchstabe = @Buchstabe
OPTION (OPTIMIZE FOR (@Buchstabe = 'C'))
GO

--WITH RECOMPILE HINT: Erzwingt neuen Abfrageplan bei jeder Ausf�hrung

--Erste Ausf�hrung:
EXEC spSniffing3 C WITH RECOMPILE

--Zweite Ausf�hrung:
EXEC spSniffing3 B WITH RECOMPILE


--Parameter Sniffing kann grunds�tzlich auch ausgeschaltet werden (nicht unbedingt zu empfehlen)