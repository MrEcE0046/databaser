SELECT symbol, name,
CASE WHEN LEFT(name, LEN(symbol)) = symbol THEN 'Yes' ELSE 'No'
END AS MATCH
FROM Elements3;