# databaser

1NF
- Alla attribut ska innehålla atomära (odelbara) värden, och varje fält ska innehålla endast ett värde.
- Att använda radordning för att förmedla information är inte tillåtet 
- Inte blanda types i samma kolumn, tex inga strings i en type INT
- Måste finnas en primary key
- Repetera inte grupper i samma cell

2NF 
-- Deletion anomaly
-- Update anomaly

2NF: Varje icke nyckel atribut måste depend o nthe entire primary key.

3NF
-- Must not Dependency of a non key atribute on another non key attribute
-- Every non key attribute in a table should depend on the key, the whole key, and nothing but the key.