IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Users2')
BEGIN
    SELECT * INTO Users2 FROM Users;
END