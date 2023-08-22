/*

2. Non Clustered Index/nicht-gruppierten Index

- soviele pro Tabelle wie gewünscht (bzw. max. ca. 1000)
- ist quasi eine Kopie der Tabelle (bzw. des CIX), aber nur mit den Spalten die auch indiziert wurden
- die indizierten Datensätze haben einen "Querverweis" auf den gesamten zugehörigen Datensatz im CIX (Lookup)

*/

SELECT * FROM Customers