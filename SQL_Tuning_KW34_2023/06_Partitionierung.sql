USE Northwind
GO

/*

1. Tabelle als Kandidat für Partitionierung? Wenn ja welche Grenzen sind sinnvoll?

2. Files & Filegroups erstellen

3. Partitionsfunktion erstellen die unsere Grenzen definiert

4. Partitionsschema erstellen

5. Tabelle endgültig partitionieren

*/

--Beispieltabelle erstellen:

CREATE TABLE SalesGesamt (
ID int identity PRIMARY KEY,
BestellDatum date,
BestellWert decimal (10,2) )

INSERT INTO SalesGesamt
SELECT 
CAST(getdate()-365*4 + (365*4*RAND()) as date),
CAST(RAND() * 10 + 5  as decimal(10,2))
GO 10000

SELECT MAX(Bestelldatum), MIN(Bestelldatum) FROM SalesGesamt

--Files & Filegroups:

ALTER DATABASE Northwind
ADD FILEGROUP Filegroupname

ALTER DATABASE Northwind
ADD FILE (
	NAME = Filenamen,
	FILENAME = 'C:\\...',
	SIZE = 100,
	AUTOGROWTH = 64
	)
	TO FILEGROUP Filegroupname


--Partitionsfunktion erstellen:

CREATE PARTITION FUNCTION fSalesNachJahr (date)
AS
RANGE LEFT FOR VALUES
	('20191231', '20201231', '20211231', '20221231', '20231231')


--Partitionsschema erstellen:

CREATE PARTITION SCHEME psSalesNachJahr
AS PARTITION fSalesNachJahr
TO ('Sales2019', 'Sales2020', 'Sales2021', 'Sales2022', 'Sales2023', 'PRIMARY') --TO Filegroup, nicht File
--Immer eine Filegroup mehr als Grenzen in der Function ("Notfall")


--Funktion erstellt Grenzen --> Schema prüft Datensätze auf die Grenzen der Funktion, und teilt eine Filegroup zu
-->Filegroup weist den Datensätzen das jeweilige File an

--Für neue Tabelle:
CREATE TABLE diesdas (
id int,
whatever varchar(5))
ON psSalesNachJahr (whatever)


--Für vorhandene Tabelle: Clustered Inde löschen und neu erstellen:

ALTER TABLE SalesGesamt
DROP CONSTRAINT [PK__SalesGes__3214EC2747A935EC] 

CREATE CLUSTERED INDEX CIX_SalesGesamt 
ON SalesGesamt (ID)
ON psSalesNachJahr (BestellDatum)


--Partitionsnummer der Datensätze prüfen:

SELECT $PARTITION.fSalesNachJahr(Bestelldatum), * FROM SalesGesamt
WHERE BestellDatum BETWEEN '20191230' AND '20200102'
ORDER BY BestellDAtum


SELECT DISTINCT o.name as table_name, rv.value as partition_range, fg.name as file_groupName, p.partition_number, p.rows as number_of_rows
FROM sys.partitions p
INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
INNER JOIN sys.objects o ON p.object_id = o.object_id
INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id
INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id
INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id 
LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id
WHERE o.object_id = OBJECT_ID('SalesGesamt');

