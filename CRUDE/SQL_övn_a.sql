SELECT 
    title,
    format(Season, 'S0#') + format(EpisodeInSeason, 'E0#') AS 'Episode'
FROM dbo.GameOfThrones;