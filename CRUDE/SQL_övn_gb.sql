select *,
Integer * 0.01 AS Float, -- konverterat alla int till float
dateadd(minute, integer, dateadd(day, Integer, '2018-12-31 09:00')) AS DateTime, -- Lägger till int till datum och tid
Integer % 2 AS Bool -- kollar om det är jämnt eller ojämnt
from Types2;