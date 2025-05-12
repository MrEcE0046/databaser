-- SELECT * FROM [servernamn].[databasnamn].[tabellnamn]
-- SELECT top 10 FirstName as 'Förnamn', LastName, ID, 'Fredrik' as 'Fredrik', FirstName + ' ' + LastName as 'Fullt namn' FROM users;
/*
Block kommentar
*/

SELECT * 
FROM users 
WHERE FirstName <> 'Frida';

-- SELECT top 2 * FROM users WHERE FirstName LIKE '[abc]%' ORDER BY FirstName;
SELECT * FROM GameOfThrones;