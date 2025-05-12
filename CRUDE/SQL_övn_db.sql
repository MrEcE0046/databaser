SELECT * FROM Elements2
DELETE FROM Elements2
WHERE name LIKE '[dkmou]%' OR name IN ('Erbium', 'Helium', 'Nitrogen', 'Platinum', 'Selenium');
-- Tar bort rader där ämnen i Name som börjar på d,k,m,o,u och även specifika ämnen.