UPDATE Airports2
SET 
    time = '-',
    dst = '-'
WHERE time IS NULL AND dst IS NULL;