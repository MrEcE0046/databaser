IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Elements3')
BEGIN
    SELECT * INTO Elements3 FROM Elements;
END