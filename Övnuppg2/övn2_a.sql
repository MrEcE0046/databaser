-- Övning 2 a

SELECT 
    Period, 
    MIN([Group]) AS [from], 
    MAX([group]) AS [to], 
    ROUND(AVG(CONVERT(FLOAT, Stableisotopes)), 2) AS [Average isotopes],
    STRING_AGG(Symbol, ', ') AS Symbols
FROM elements4
GROUP BY period;

SELECT * FROM elements;

-- Övning 2 b   
SELECT 
    Region, 
    Country, 
    City, 
    COUNT(ContactName) AS Customers
FROM company.Customers
GROUP BY Region, Country, City
HAVING COUNT(ContactName) > 1;

SELECT * FROM company.Customers;

-- Övning 2 c

DECLARE @GoT NVARCHAR(MAX) = '';

SELECT @GoT +=
    'Säsong ' + CAST(Season AS VARCHAR) + ' sändes från ' + 
    FORMAT(MIN([Original air date]), 'MMMM', 'sv') + ' till ' + 
    FORMAT(MAX([Original air date]), 'MMMM yyyy', 'sv') +
    '. Totalt sändes ' + CAST(MAX(EpisodeInSeason) AS VARCHAR) + ' avsnitt, som i genomsnitt sågs av '
    + CAST(AVG([U.S. viewers(millions)]) AS VARCHAR) + ' miljoner människor i USA.' + CHAR(13) + CHAR(10)
FROM GameOfThrones
GROUP BY Season;

PRINT @GoT;

SELECT * FROM GameOfThrones;

-- Övning 2 d

SELECT
    (FirstName + ' ' + LastName) AS Namn,
    -- id AS ID, -- ID 500101-5001
	-- left(ID, 6) AS ID6, ID 500101
	-- convert(date, left(ID, 6)) AS ID6date, 
	floor((datediff(day, convert(date, left(ID, 6)), getdate())) / 365.25) AS Ålder,
    CASE
        WHEN SUBSTRING(RIGHT(ID, 2), 1, 1) % 2 = 0 THEN 'Kvinna' -- Tar ut de två tecken från höger sen kontrollerar om den vänstra av de två är jämn eller inte.
        ELSE 'Man'
    END AS Kön
FROM Users
ORDER BY FirstName, LastName;

SELECT * FROM Users;

-- Övning 2 e

SELECT * INTO #Countries FROM Countries;
SELECT * FROM #Countries;


SELECT 
    DISTINCT Region,
    COUNT(Country) AS Länder,
    SUM(CAST(Population AS BIGINT)) AS [Total Befolkning],
    SUM(CAST([Area (sq# mi#)] AS BIGINT)) AS Area,
    ROUND(SUM(CONVERT(BIGINT, Population)) / SUM(CONVERT(BIGINT, [Area (sq# mi#)])), 2) AS Befolkningstäthet,
    ROUND(SUM(CONVERT(FLOAT, REPLACE([Infant mortality (per 1000 births)], ',', '.'))), 0) * 1000 AS [Average Infant Mortality]
FROM #Countries
GROUP BY Region;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Countries';

-- Övning 2 f

SELECT * INTO #Airports FROM Airports;
SELECT * FROM #Airports;

SELECT
    RIGHT(RTRIM([Location served]), CHARINDEX(',', REVERSE(RTRIM([Location served]))+',')-2) AS Land,
    COUNT(IATA) AS [Antal flygplatser],
    SUM(CASE WHEN ICAO IS NULL THEN 1 ELSE 0 END) AS [Saknar ICAO],
    FORMAT(SUM(CASE WHEN ICAO IS NULL THEN 1 ELSE 0 END) / CAST(COUNT(IATA) AS FLOAT), 'p') AS [Saknar ICAO i %]
FROM #Airports
GROUP BY RIGHT(RTRIM([Location served]), CHARINDEX(',', REVERSE(RTRIM([Location served]))+',')-2);