/*

2. Non Clustered Index/nicht-gruppierten Index

- soviele pro Tabelle wie gew�nscht (bzw. max. ca. 1000)
- ist quasi eine Kopie der Tabelle (bzw. des CIX), aber nur mit den Spalten die auch indiziert wurden
- die indizierten Datens�tze haben einen "Querverweis" auf den gesamten zugeh�rigen Datensatz im CIX (Lookup)

*/

SELECT * FROM Customers