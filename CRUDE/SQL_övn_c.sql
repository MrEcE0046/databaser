IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Airports2')
BEGIN
    SELECT * INTO Airports2 FROM Airports;
END