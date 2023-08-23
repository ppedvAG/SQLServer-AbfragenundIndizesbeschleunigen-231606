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

--Erste Ausführung:
EXEC spSniffing2 A

--Zweite Ausführung:
EXEC spSniffing2 C

--Der zweite Aufruf erwartet nur 10 Zeilen, es sind aber tatsächlich 10000!
--> Zu wenig bereitgestellte Ressourcen für die Abfrage --> Performance leidet


CREATE PROCEDURE spSniffing3 @Buchstabe varchar(5)
AS
SELECT ID FROM Sniffing
WHERE Buchstabe = @Buchstabe
GO

--Erste Ausführung:
EXEC spSniffing3 C

--Zweite Ausführung:
EXEC spSniffing3 B

--Der zweite Aufruf erwartet 10000 Zeilen, es sind aber tatsächlich nur 10!
--> Zu viele bereitgestellte Ressourcen für die Abfrage --> Performance leidet u.U. bei anderen Abfragen (Memory starvation)


--"Lösung":

--OPTIMIZE FOR HINT: Optimiert den Abfrageplan für einen gewissen Parameterwert, unabhängig vom ersten Aufruf

CREATE PROCEDURE spSniffing4 @Buchstabe varchar(5)
AS
SELECT ID FROM Sniffing
WHERE Buchstabe = @Buchstabe
OPTION (OPTIMIZE FOR (@Buchstabe = 'C'))
GO

--WITH RECOMPILE HINT: Erzwingt neuen Abfrageplan bei jeder Ausführung

--Erste Ausführung:
EXEC spSniffing3 C WITH RECOMPILE

--Zweite Ausführung:
EXEC spSniffing3 B WITH RECOMPILE


--Parameter Sniffing kann grundsätzlich auch ausgeschaltet werden (nicht unbedingt zu empfehlen)