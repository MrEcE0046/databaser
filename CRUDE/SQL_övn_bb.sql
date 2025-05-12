SELECT 
	firstname,
	lastname,
	lower(concat(left(firstname, 2), left(lastname, 2))) AS 'UserName' 
FROM 
	users2;