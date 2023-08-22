/*

Allgemeines:

Daten in SQL werden auf sog. Pages/Seiten gespeichert

1 Page ca. 8kb Speicherplatz (Rest ist reserviert f�r Header mit Metadaten)
(8 Pages nennt man 1 Block)

Ein Datensatz muss vollst�ndig auf eine Seite passen.
Wenn Seite voll ist, oder n�chster Datensatz nicht mehr drauf passt --> neue Seite

Datentypen & Anzahl der Spalten nehmen daher Einfluss auf die Anzahl an Datens�tzen pro Seite
Bspw.:
1 Byte: tinyint
2 Byte: smallint
4 Byte: int 
8 Byte: bigint

Wenn Datens�tze gr��er als 8kb werden, m�ssen wir LOB Datentypen (Bspw: varchar(MAX), (text = Legacy)) verwenden
--> diese werden auf sog. LOB Pages gespeichert

*/

USE Northwind
GO

CREATE TABLE Speicher (
ID int identity,
Zeugs char(4100) )

INSERT INTO Speicher
VALUES ('abc')
GO 100 --(GO X wiederholt die Batchanweisung X mal)

SELECT * FROM Speicher

dbcc showcontig('Speicher') 
--gibt Metadatenauskunft �ber einen Table (Anz. Seiten, Seitendichte, freier Speicherplatz pro Seite usw.)

/*
"Faustregel":
- Seitendichte von �ber 70% erstrebenswert; ab 80% gut, ab 90% sehr gut
*/

dbcc showcontig('Orders')

CREATE TABLE Speicher2 (
ID int identity,
Zeugs varchar(4100) )

INSERT INTO Speicher2
VALUES ('abc')
GO 300

dbcc showcontig('Speicher2')

CREATE TABLE Speicher3 (
ID int identity,
Zeugs varchar(4100) )

INSERT INTO Speicher3
VALUES ('abcdefg')
GO 300

dbcc showcontig('Speicher3')

--Mit SET STASTICS XY ON/OFF k�nnen gewisse Messwerte bei einer Abfrage ausgegeben werden
--TIME: vergangene Zeit bis Ergebnis & Zeit die die CPU gebraucht hat
--IO: IN/OUT Lesevorg�nge 

SET STATISTICS TIME, IO ON

SET STATISTICS TIME, IO OFF

SELECT * FROM Speicher