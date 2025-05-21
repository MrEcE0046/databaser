-- 1. Av 77 produkter, hur stor andel har gått till London?
select
	count(distinct(od.ProductId)) as NbrProd,
	count(distinct(od.ProductId)) / 77.0 as Ratio,
	count(distinct(od.ProductId)) / cast((select count(*) from company.products) as float) as Ratio
from
	company.order_details od
	inner join company.orders o on od.OrderId = o.Id
where
	o.ShipCity = 'London';

-- 2. Vilken stad har fått flest produkter?
SELECT 
    Top 1 ShipCity,
    count(distinct(ProductID)) as 'Number of unique Products'
FROM company.customers cc
JOIN company.orders co ON cc.Id = co.CustomerId
JOIN company.order_details cod ON co.Id = cod.OrderId
JOIN company.products cp ON cod.ProductId = cp.Id
GROUP BY ShipCity
ORDER BY 'Number of unique Products' DESC;

-- 3. Summan av försäljning i Tyskland.
SELECT 
    ShipCountry AS Country,
    SUM((cp.UnitPrice * cod.Quantity) - (cp.UnitPrice * cod.Quantity * cod.Discount)) AS TotalSales
FROM company.products cp
JOIN company.order_details cod ON cp.Id = cod.ProductId
JOIN company.orders co ON cod.OrderId = co.Id
WHERE 
    ShipCountry = 'Germany' AND
    cp.Discontinued = 1
GROUP BY ShipCountry;

-- 4. Lagervärde?
SELECT 
    company.categories.CategoryName AS Category,
    SUM(UnitsInStock * UnitPrice) AS Value
FROM company.products
JOIN company.categories ON company.products.CategoryID = company.categories.Id
GROUP BY company.categories.CategoryName
ORDER BY [Value] DESC;

-- 5. Leverantör som sålt mest?
SELECT 
    company.suppliers.CompanyName,
    SUM(company.order_details.Quantity) AS TotalQuantity
FROM company.suppliers
JOIN company.products ON company.suppliers.Id = company.products.supplierId
JOIN company.order_details ON company.products.Id = company.order_details.ProductId
JOIN company.orders ON company.order_details.OrderId = company.orders.Id
WHERE company.orders.OrderDate > '2013-06-01' AND company.orders.OrderDate < '2013-08-30'
GROUP BY company.suppliers.CompanyName
ORDER BY [TotalQuantity] DESC;

-- Heavy Metal
-- artists 

DECLARE @playlists VARCHAR(MAX) = 'Heavy Metal Classic';

SELECT
    music.genres.Name AS Genre,
    music.artists.Name AS Artist,
    music.albums.Title AS Album,
    music.tracks.Name AS Track,
    RIGHT('0' + CAST((music.tracks.Milliseconds / 60000) AS VARCHAR), 2) + ':' +
    RIGHT('0' + CAST((music.tracks.Milliseconds % 60000) / 1000 AS VARCHAR), 2) AS LengthFormatted,
    concat(format(Bytes / power(1024.0, 2), 'N1'), ' MiB') as 'Size',
    music.tracks.Composer 
FROM music.genres
JOIN music.tracks ON music.genres.GenreId = music.tracks.GenreId
JOIN music.albums ON music.tracks.AlbumId = music.albums.AlbumId
JOIN music.artists ON music.albums.ArtistId = music.artists.ArtistId
JOIN music.playlist_track ON music.tracks.TrackId = music.playlist_track.TrackId
JOIN music.playlists ON music.playlist_track.PlaylistId = music.playlists.PlaylistId
WHERE music.playlists.Name = @playlists
order by
	music.genres.Name, music.artists.Name, music.albums.Title, music.tracks.Name;

-- 1. Längst speltid?
SELECT 
    music.artists.Name AS Artist,
    SUM(music.tracks.Milliseconds)/1000 AS Len
FROM music.tracks
JOIN 
music.albums ON music.tracks.AlbumId = music.albums.AlbumId
JOIN music.artists ON music.albums.ArtistId = music.artists.ArtistId
WHERE music.tracks.mediatypeid <> 3
GROUP BY music.artists.Name
ORDER BY Len DESC;

-- 2. Genomsnitt
SELECT 
    music.artists.Name AS Artist,
    -- SUM(music.tracks.Milliseconds)/1000 AS Len
    AVG(music.tracks.Milliseconds)/1000 AS AvgLenOfTrack
FROM music.tracks
JOIN music.albums ON music.tracks.AlbumId = music.albums.AlbumId
JOIN music.artists ON music.albums.ArtistId = music.artists.ArtistId
WHERE music.tracks.mediatypeid <> 3 AND music.artists.Name = 'Iron Maiden'
GROUP BY music.artists.Name
ORDER BY AvgLenOfTrack DESC;

-- Alt lösning
DECLARE @Playtime TABLE (
	name nvarchar(max),
	playtime int
)
 
INSERT INTO @Playtime
	SELECT ar.Name, avg(tr.Milliseconds)/1000
	FROM music.tracks tr
		left join music.albums al on tr.AlbumId = al.AlbumId
		left join music.artists ar on al.ArtistId = ar.ArtistId
	WHERE MediaTypeId<>3 and ar.name = 'Iron maiden'
	GROUP BY ar.Name
 
SELECT  Avg (playtime) as 'Average playtime, s'
FROM @Playtime

-- 3. Filstorlek
SELECT 
    CONCAT(FORMAT(SUM(CAST(Bytes AS FLOAT)) / POWER(1024.0, 3), 'N1'), ' GB') AS TotalSize
FROM music.tracks
WHERE music.tracks.MediaTypeId = 3

select top 1
	mpl.PlaylistId,
	mpl.Name,
	count(distinct(mal.ArtistId)) as 'Number of Artists on playlist'
	into #ArtistsPerPlaylist
from 
	music.playlists mpl
	left join music.playlist_track mpt on mpl.PlaylistId = mpt.PlaylistId
	left join music.tracks mt on mt.TrackId = mpt.TrackId
	left join music.albums mal on mal.AlbumId=mt.AlbumId
	left join music.artists mar on mar.ArtistId = mal.ArtistId
group by mpl.PlaylistId, mpl.Name

SELECT * FROM music.albums;
SELECT * FROM music.tracks;
SELECT * FROM music.playlists;
SELECT * FROM music.playlist_track;
SELECT * FROM music.artists;
SELECT * FROM music.genres;
SELECT * FROM music.albums;

