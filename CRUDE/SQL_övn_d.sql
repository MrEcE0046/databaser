IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Elements2')
BEGIN
    SELECT * INTO Elements2 FROM Elements;
END