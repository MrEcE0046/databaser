SELECT 
'#' + 
RIGHT('0' + CONVERT(VARCHAR(2), FORMAT(Red, 'X2')), 2) +
RIGHT('0' + CONVERT(VARCHAR(2), FORMAT(Green, 'X2')), 2) +
RIGHT('0' + CONVERT(VARCHAR(2), FORMAT(Blue, 'X2')), 2) AS Code, Red, Green, Blue, Name
FROM Colors2;