USE Northwind 
GO

/*

Jede Abfrage ist eine Transaction; Transactions "verhängen" Locks auf die Ressourcen die sie ansprechen.
--> Locks verhindern das andere Transactions gleichzeitig auf diese Ressource zugreifen können
--> Kann in Wait Time resultieren (Blocking)

*/

SELECT @@TRANCOUNT

BEGIN TRANSACTION
BEGIN TRAN

UPDATE Customers
SET City = 'Burghausen'
WHERE CustomerID = 'ALFKI'

COMMIT
ROLLBACK

SELECT * FROM Customers

--WITH (NOLOCK): Umgeht Locks für SELECT Anweisungen (Achtung: u.U. falsche/veraltete Daten lesen)



--Deadlocks: 2 Transactions blockieren sich gegenseitig; Die Situation kann nicht von alleine gelöst werden

USE Northwind
GO

DROP TABLE IF EXISTS Links
DROP TABLE IF EXISTS Rechts
GO

--Für Anschaulichkeit unter "Fenster - Neue vertikale Registerkartengruppe" 2. Session erstellen

--Beispieltabellen erstellen & befüllen:

CREATE TABLE Links (
ID int identity PRIMARY KEY,
Werte varchar(10) )
GO

INSERT INTO Links
SELECT 'Links'
GO 10

CREATE TABLE Rechts (
ID int identity PRIMARY KEY,
Werte varchar(10) )
GO

INSERT INTO Rechts
SELECT 'Rechts'
GO 10

--Transaktionsskripte vorbereiten (in Session "links"):

BEGIN TRAN

UPDATE Links
SET Werte = 'LinksNeu'

UPDATE Rechts
SET Werte = 'RechtsNeu'

ROLLBACK

--Transaktionsskripte vorbereiten (in Session "rechts"):

BEGIN TRAN

UPDATE Rechts
SET Werte = 'RechtsNeu'
WHERE ID = 2

UPDATE Links
SET Werte = 'LinksNeu'
WHERE ID = 2

ROLLBACK

/*
Transaktionen Schritt für Schritt abwechselnd in beiden Sessions ausführen
um Deadlock Szenario zu simulieren
*/


/* 
Deadlocks verhindern:
- Retry on Error 1205
- Auf "Programmierfluss" achten
- Nur wenn unbedingt nötig, mehr als ein DML Statement in eine Transaction packen!
*/
