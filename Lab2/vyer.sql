-- Obligatorisk vy
SELECT top 1
    Författare.Förnamn + ' ' + Författare.Efternamn AS Namn,
    CAST(FLOOR(DATEDIFF(DAY, Författare.Födelsedatum, GETDATE()) / 365.25) AS VARCHAR(3)) + 'år' AS [Ålder],
    COUNT(DISTINCT BöckerOchFörfattare.BokId) AS [Titlar],
    CAST(SUM([Böcker].Pris * LagerSaldo.Saldo) AS VARCHAR(10)) + 'kr' AS [Lagervärde]
FROM Författare
JOIN BöckerOchFörfattare ON Författare.ID = BöckerOchFörfattare.FörfattareId
JOIN Böcker ON Böcker.ISBN13 = BöckerOchFörfattare.BokId
JOIN LagerSaldo ON LagerSaldo.ISBN = Böcker.ISBN13
GROUP BY Författare.Förnamn, Författare.Efternamn, Författare.Födelsedatum
ORDER BY [Lagervärde] DESC;

-- Vilka böcker har fler än ett författare
WITH BöckerMedFleraFörfattare AS (
    SELECT
        b.ISBN13,
        b.Titel
    FROM
        Böcker b
    JOIN
        BöckerOchFörfattare bf ON b.ISBN13 = bf.BokId
    GROUP BY
        b.ISBN13,
        b.Titel
    HAVING
        COUNT(bf.FörfattareId) > 1
)
SELECT
    bmf.ISBN13,
    bmf.Titel,
    STRING_AGG(f.Förnamn + ' ' + f.Efternamn, ', ') AS Författare,
    COUNT(bf.FörfattareId) AS AntalFörfattare
FROM
    BöckerMedFleraFörfattare bmf
JOIN
    BöckerOchFörfattare bf ON bmf.ISBN13 = bf.BokId
JOIN
    Författare f ON bf.FörfattareId = f.ID
GROUP BY
    bmf.ISBN13,
    bmf.Titel
ORDER BY
    bmf.Titel;
   
--Vilka titlar som sålt mest
SELECT TOP 3
    b.Titel,
    SUM(s.Saldo) AS TotaltSålda
FROM
    LagerSaldo s
JOIN
    Böcker b ON s.ISBN = b.ISBN13
GROUP BY
    b.Titel
ORDER BY
    TotaltSålda DESC;

/*
Vilka butiker som sålt mest.
Kan vara intressant för ledningen att ha en översikt om det är någon butik som underpresterar eller motsvarande.
*/
SELECT TOP 3
    bt.Butiksnamn,
    bt.Stad,
    SUM(s.Saldo * Böcker.Pris) AS [TotaltSålda(Kr)]
FROM
    LagerSaldo s
JOIN Butiker bt ON s.ButiksId = bt.ID
JOIN Böcker ON s.ISBN = Böcker.ISBN13
GROUP BY
    bt.Butiksnamn, bt.Stad
ORDER BY
    [TotaltSålda(Kr)] DESC;
/*
Kartlägga kunders köpbeteender.
Vilka kunder köper vilka titlar och genrer i vilka butiker? Datan kan visa om man ska rikta
reklam till kunderna. 
*/
WITH DistinktaGenrer AS (
    SELECT DISTINCT
        f.KundId,
        g.Genre
    FROM Försäljning f
    JOIN Böcker b ON f.BokId = b.ISBN13
    JOIN BokGenre bg ON b.ISBN13 = bg.ISBN13
    JOIN Genre g ON bg.GenreId = g.GenreId
)
SELECT
    k.KundId,
    k.Förnamn + ' ' + k.Efternamn AS Namn,
    (
        SELECT STRING_AGG(Genre, ', ')
        FROM DistinktaGenrer dg
        WHERE dg.KundId = k.KundId
    ) AS Genrer,
    COUNT(*) AS AntalKöp,
    ISNULL(SUM(CASE WHEN f.Butik = 1 THEN 1 ELSE 0 END), 0) AS Bookstore,
    ISNULL(SUM(CASE WHEN f.Butik = 2 THEN 1 ELSE 0 END), 0) AS BokAffären,
    ISNULL(SUM(CASE WHEN f.Butik = 3 THEN 1 ELSE 0 END), 0) AS [Affären med böcker]

FROM Försäljning f
JOIN Kund k ON f.KundId = k.KundId
GROUP BY
    k.KundId, k.Förnamn, k.Efternamn
ORDER BY
    k.KundId;