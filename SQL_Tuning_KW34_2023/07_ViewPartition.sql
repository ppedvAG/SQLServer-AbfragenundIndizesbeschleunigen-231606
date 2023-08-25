USE Northwind
GO

--Beispieltabellen erstellen (Wir haben unsere große Sales Tabelle in kleinere gesplittet):

CREATE TABLE Sales2022 (
ID int identity PRIMARY KEY,
Datum date,
Summe decimal(10,2))

CREATE TABLE Sales2023 (
ID int identity PRIMARY KEY,
Datum date,
Summe decimal(10,2))

INSERT INTO Sales2022 
VALUES 
('20220101', 14.50),
('20220401', 301.99),
('20221231', 76.00)

INSERT INTO Sales2023 
VALUES 
('20230101', 9.99),
('20230401', 10.90),
('20231231', 99.99)



SELECT * FROM Sales2022
SELECT * FROM Sales2023

--"Kombinierte" (partitionierte) View über alle Geschäftsjahre:

DROP VIEW vSalesAll
DROP TABLE Sales2022
DROP TABLE Sales2023

CREATE VIEW vSalesAll
AS
SELECT * FROM Sales2022
UNION ALL
SELECT * FROM Sales2023

SELECT * FROM vSalesAll
WHERE Datum BETWEEN '20220101' AND '20221231'


--CHECK CONSTRAINTS nach Datum auf unsere einzelnen Tabellen:

ALTER TABLE Sales2022
ADD CONSTRAINT CHK_Sales2022 CHECK (YEAR(Datum) = 2022)
ALTER TABLE Sales2023
ADD CONSTRAINT CHK_Sales2023 CHECK (YEAR(Datum) = 2023)

SELECT * FROM vSalesAll
WHERE Datum BETWEEN '20220101' AND '20221231'

INSERT INTO Sales2022
VALUES ('20230501', 100)

--CHECK Constraint funktioniert zwar, aber Aufruf der View immer noch in beiden Tabellen...

--Lösung: CHECK Constraint OHNE Funktion!

ALTER TABLE Sales2022
ADD CONSTRAINT CHK_Sales2022 CHECK (Datum BETWEEN '20220101' AND '20221231')
ALTER TABLE Sales2023
ADD CONSTRAINT CHK_Sales2023 CHECK (Datum BETWEEN '20230101' AND '20231231')


SELECT * FROM vSalesAll
WHERE Datum BETWEEN '20220101' AND '20221231'

