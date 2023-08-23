/*

2. Non Clustered Index/nicht-gruppierten Index

- soviele pro Tabelle wie gew�nscht (bzw. max. ca. 1000)
- ist quasi eine Kopie der Tabelle (bzw. des CIX), aber nur mit den Spalten die auch indiziert wurden
- die indizierten Datens�tze haben einen "Querverweis" auf den gesamten zugeh�rigen Datensatz im CIX (Lookup)

*/



--Test Tabelle vorbereiten:
SELECT * INTO Customers2 FROM Customers


INSERT INTO Customers2
SELECT * FROM Customers2
GO 12

SELECT * FROM Customers2

SET STATISTICS TIME, IO ON

CREATE CLUSTERED INDEX CIX_Customers2_CustomerID ON Customers2 (CustomerID)



SELECT * FROM Customers2
WHERE CustomerID = 'ALFKI'
-- CPU-Zeit = 249 ms, verstrichene Zeit = 427 ms.; Anzahl von �berpr�fungen: 9, logische Lesevorg�nge: 12096
--, CPU-Zeit = 0 ms, verstrichene Zeit = 285 ms.;  Anzahl von �berpr�fungen: 1, logische Lesevorg�nge: 136,


SELECT CompanyName, ContactName FROM Customers2
WHERE Country = 'France'
--, CPU-Zeit = 312 ms, verstrichene Zeit = 422 ms.

CREATE NONCLUSTERED INDEX NCIX_Customers2_Country ON Customers2 (Country) INCLUDE (CompanyName, ContactName)
-- CPU-Zeit = 16 ms, verstrichene Zeit = 403 ms.

DROP INDEX NCIX_Customers2_Country ON Customers2 

CREATE NONCLUSTERED INDEX NCIX_Customers2_Country ON Customers2 (Country) INCLUDE (CompanyName)

SELECT CompanyName, ContactName FROM Customers2
WHERE Country = 'France'
--(Bei mir) trotzdem lieber CIX Scan statt NCIX Seek-->Lookup



--Systemviews f�r Indizes:

SELECT * FROM sys.dm_db_index_physical_stats(db_id(), object_id('customers2'), NULL, NULL, 'detailed')

SELECT * FROM sys.dm_db_index_usage_stats

--Tools f�r Index Wartung und Hilfestellung:

--Ola Hallengren Skript
--sp_Blitz von Brent Ozar


-- ColumnStore Index (sp�ter mehr)

