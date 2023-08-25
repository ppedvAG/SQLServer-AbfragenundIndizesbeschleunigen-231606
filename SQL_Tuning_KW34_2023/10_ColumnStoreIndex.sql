/*

3. Columnstore Index

- Speichert Daten spaltenweise
- Dadurch sehr gutes Komprimierungspotential (bis zu 10X besser als rowstore)
--> sehr viel weniger I/O
- Aggregatbildungen dementsprechend sehr performant
--> Datawarehouse bzw. generell OLAP Systeme sehr gut geeignet!

--Clustered COLIX 
*/

CREATE TABLE ColTEst (
ID int identity,
Zeugs varchar(50),
Umsatz int )

INSERT INTO ColTEst
SELECT 'abcdefg', 15
GO 1000

CREATE CLUSTERED COLUMNSTORE INDEX COLIX_Name ON ColTEst 


SELECT * FROM Bestellungen
SELECT * FROM Bestellungen2

SELECT * FROM sys.dm_db_index_physical_stats(db_ID('Northwind'), OBJECT_ID('Bestellungen'), NULL, NULL, 'detailed')
SELECT * FROM sys.dm_db_index_physical_stats(db_ID('Northwind'), OBJECT_ID('Bestellungen2'), NULL, NULL, 'detailed')

SELECT --size_in_bytes/8000, 
* FROM sys.dm_db_column_store_row_group_physical_stats
SELECT * FROM sys.dm_db_column_store_row_group_operational_stats

SELECT * FROM Bestellungen

SET STATISTICS TIME, IO ON

SELECT ProduktID, SUM(BestellWert) FROM Bestellungen2
WHERE ID BETWEEN 5000 AND 20000
GROUP BY ProduktID

--PRIMARY KEY auf Columnstore Tabelle legen: (alternativ über unique Constraint)
ALTER TABLE Bestellungen2
ADD CONSTRAINT PK_iwas PRIMARY KEY (Id)

