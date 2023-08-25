--Data Compression: Komprimieren der Speichergröße (Seitenbefüllung) auf einer Tabelle "anschalten"
--Es gibt 2 Kompressionsmodi, Page & Row; Nur eine der beiden Modi kann angewendet werden.

--Systemprozeduren die uns Komprimierungspotential ausgeben:

EXEC sp_estimate_data_compression_savings dbo, Speicher, NULL, NULL, ROW
EXEC sp_estimate_data_compression_savings dbo, Speicher, NULL, NULL, PAGE

--Compression auf Tabelle einstellen:
ALTER TABLE Speicher
REBUILD PARTITION = ALL --alternativ PartitionsID angeben
WITH (DATA_COMPRESSION = ROW) --oder PAGE

INSERT INTO Speicher
SELECT 'xyz                                           eqrqr'
GO 10000


ALTER TABLE Speicher
REBUILD PARTITION = ALL --alternativ PartitionsID angeben
WITH (DATA_COMPRESSION = PAGE) 

--CPU Zeit zum decompressen geht hoch, aber weniger I/O, daher CPU Zeit wieder weniger; Hält sich die Waage
--> Aufgrund geringerer Dateigröße fast immer sinnvoll zu compressen!

SET STATISTICS TIME, IO ON

SELECT * FROM Speicher