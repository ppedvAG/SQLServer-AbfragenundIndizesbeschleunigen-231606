/*

Eine Tabelle ohne (gruppierten) Index nennt man "Heap" (Haufen)
Sinnbildlich eine Schublade, in die unsortiert alle Datensätze geworfen werden
--> einzelne Datensätze zu finden nicht möglich, ohne die gesamte Schublade (Table) zu durchsuchen!

*/

SELECT * FROM Speicher2
SELECT * FROM Speicher

SET STATISTICS TIME, IO ON

SELECT * FROM Speicher2
WHERE ID = 50 --Trotzdem ALLE Seiten gelesen --> schlecht

SELECT * FROM Speicher
WHERE ID = 50


/*

- Ausführungspläne werden von rechts nach links gelesen
- Interessanteste Stats: 
Geschätzt vs. tatsächlich 
Kosten in sog. "SQL Dollar" (=interne Vergleichsgröße ohne Realbezug)

- Scan = ganze Tabelle/Index wird gelesen; grundsätzlich "schlecht"
- Seek = "SQL Server weiß, wo die gewünschten Ergebnisse zu finden sind"; grundsätzlich "gut"

Seeks können durch Indexes gewährleistet werden, es gibt mehrere Arten von Indexes

*/

/*

1. Clustered Index/gruppierter Index

- sortiert die Datensätze physisch (im Datafile) neu an auf den Seiten, 
nach der Spalte/den Spalten die indiziert wurden
--> genau 1 pro Tabelle, weil nur eine physische Sortierung gleichzeitig möglich ist

- Wenn es noch keinen CIX gibt, und ein Primary Key vergeben wird, wird für die PK Spalte ebenfalls ein CIX angelegt
--> in den meisten Fällen wünschenswert, da wir die ID Spalte sowieso mit einem CIX versehen wollen

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

Regeln für die Indizierung, die fast immer sinnvoll sind:
1. CIX auf PK Spalte (bzw. auf die ID Spalte)
2. In Tabellen mit vielen Writes, NCIX eher hinderlich
--> auf Tabellen mit vielen Reads dagegen meistens sehr gut
3. NCIX gute Kandidaten für Spalten über die gejoint wird (Foreign Keys)

*/
