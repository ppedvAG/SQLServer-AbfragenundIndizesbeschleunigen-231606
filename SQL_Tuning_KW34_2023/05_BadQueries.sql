/*
Manchmal "verhalten" sich Abfragen anders als wir das erwarten

SARGABLE = Search ARgument ABLE 

1. Keine Funktionen/Berechnungen auf indizierte Spalten im WHERE
2. Direkte Vergleiche statt Funktionen
*/

--Beispieltabelle vorbereiten:
CREATE TABLE Sales (
ID int identity PRIMARY KEY,
Datum date,
Käufer varchar(10),
Umsatz decimal(10,2) )
GO

INSERT INTO Sales
SELECT
CAST(getdate()-365*4 + (365*4*RAND()) as date),
LEFT(CAST(NEWID() as varchar(255)), 6),
CAST(RAND()*90 + 10  as decimal(10,2))
GO 30000

SELECT RAND()
SELECT NEWID()

SELECT * FROM Sales

CREATE NONCLUSTERED INDEX NCIX_Datum ON Sales (Datum)
GO
CREATE NONCLUSTERED INDEX NCIX_Käufer ON Sales (Käufer)
GO

--Alle "Datum" aus 2021:

--Bad Query (Scan):
SELECT Datum FROM Sales
WHERE YEAR(Datum) = 2021

SELECT Datum FROM Sales
WHERE DATEPART(YEAR, Datum) = 2021

--Good Query (Seek):
SELECT Datum FROM Sales
WHERE Datum BETWEEN '20210101' AND '20211231'


--Alle Käufer deren Namen mit 'AAA' beginnt

--Bad Query (Scan):
SELECT Käufer FROM Sales
WHERE SUBSTRING(Käufer, 1, 3) = 'AAA'
SELECT Käufer FROM Sales
WHERE LEFT(Käufer, 3) = 'AAA'

--Good Query (Seek):
SELECT Käufer FROM Sales
WHERE Käufer LIKE 'AAA%'


--Alle "Datum" seit 6 Monaten bis heute:

--Bad Query (Scan):
SELECT Datum FROM Sales
WHERE DATEDIFF(MONTH, Datum, GETDATE()) <= 6

--Good Query (Seek):
SELECT Datum FROM Sales
WHERE Datum >= DATEADD(MONTH, -6, GETDATE())


/****************************************/

--LEGACY PROBLEM:

--Schlecht:
SELECT * FROM Sales
WHERE ID IN (3,4)

--Besser:
SELECT * FROM Sales
WHERE ID = 3
UNION
SELECT * FROM Sales
WHERE ID = 4