USE Northwind
GO

--Views verhalten sich manchmal etwas komisch...


--Beispieltabelle & View erstellen:

CREATE TABLE StadtLandFluss (
ID int,
Stadt int,
Land int )

INSERT INTO StadtLandFluss
VALUES 
(1, 10, 100),
(2, 20, 200),
(3, 30, 300)

SELECT * FROM StadtLandFluss

CREATE VIEW vStadtLandFluss
AS
SELECT * FROM StadtLandFluss
Go

SELECT * FROM StadtLandFluss
SELECT * FROM vStadtLandFluss


--Tabelle eine neue Column hinzuf�gen und bef�llen:
ALTER TABLE StadtLAndFluss
ADD Fluss int

UPDATE StadtLandFluss
SET Fluss = ID * 1000

--View hat neue Column nicht dabei:
SELECT * FROM StadtLandFluss
SELECT * FROM vStadtLandFluss


--L�schen einer Column in der Tabelle:
ALTER TABLE StadtLandFluss
DROP COLUMN Land

--View macht komisches Zeug :O :
SELECT * FROM StadtLandFluss
SELECT * FROM vStadtLandFluss


--View WITH SCHEMABINDING: Garantiert (zumindestens bei DROP COLUMN), dass die View nicht ver�ndert wird:

DROP TABLE StadtLandFluss
DROP VIEW vStadtLandFluss

CREATE VIEW vStadtLandFluss WITH SCHEMABINDING
AS
SELECT [ID], [Stadt], [Land] FROM dbo.StadtLandFluss

--Spalten m�ssen explizit angegeben werden. Quelltabellen m�ssen mit DB Schema angegeben werden

