/*

Eine Tabelle ohne (gruppierten) Index nennt man "Heap" (Haufen)
Sinnbildlich eine Schublade, in die unsortiert alle Datens�tze geworfen werden
--> einzelne Datens�tze zu finden nicht m�glich, ohne die gesamte Schublade (Table) zu durchsuchen!

*/

SELECT * FROM Speicher2
SELECT * FROM Speicher

SET STATISTICS TIME, IO ON

SELECT * FROM Speicher2
WHERE ID = 50 --Trotzdem ALLE Seiten gelesen --> schlecht

SELECT * FROM Speicher
WHERE ID = 50


/*

- Ausf�hrungspl�ne werden von rechts nach links gelesen
- Interessanteste Stats: 
Gesch�tzt vs. tats�chlich 
Kosten in sog. "SQL Dollar" (=interne Vergleichsgr��e ohne Realbezug)

- Scan = ganze Tabelle/Index wird gelesen; grunds�tzlich "schlecht"
- Seek = "SQL Server wei�, wo die gew�nschten Ergebnisse zu finden sind"; grunds�tzlich "gut"

Seeks k�nnen durch Indexes gew�hrleistet werden, es gibt mehrere Arten von Indexes

*/

/*

1. Clustered Index/gruppierter Index

- sortiert die Datens�tze physisch (im Datafile) neu an auf den Seiten, 
nach der Spalte/den Spalten die indiziert wurden
--> genau 1 pro Tabelle, weil nur eine physische Sortierung gleichzeitig m�glich ist

- Wenn es noch keinen CIX gibt, und ein Primary Key vergeben wird, wird f�r die PK Spalte ebenfalls ein CIX angelegt
--> in den meisten F�llen w�nschenswert, da wir die ID Spalte sowieso mit einem CIX versehen wollen

*/

CREATE CLUSTERED INDEX CIX_Speicher_ID ON Speicher (ID)

CREATE TABLE IndexVielleicht (
ID int identity PRIMARY KEY,
Kram varchar(50) )

INSERT INTO IndexVielleicht
VALUES ('xyz')
GO 1000

SELECT * FROM IndexVielleicht
WHERE ID = 50

--DROP CLUSTERED INDEX 


SELECT * FROM Speicher
WHERE ID = 50

SELECT * FROM Customers

/*

Regeln f�r die Indizierung, die fast immer sinnvoll sind:
1. CIX auf PK Spalte (bzw. auf die ID Spalte)
2. In Tabellen mit vielen Writes, NCIX eher hinderlich
--> auf Tabellen mit vielen Reads dagegen meistens sehr gut
3. NCIX gute Kandidaten f�r Spalten �ber die gejoint wird (Foreign Keys)

*/
