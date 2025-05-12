--MoonMIssions
-----------------------------------------------------------------------
GO
SELECT 
    Spacecraft, 
    [Launch date], 
    [Carrier rocket], 
    Operator, 
    [Mission type]
INTO #SuccessfulMissions
FROM MoonMissions
WHERE outcome = 'Successful';
GO 
SELECT * FROM #SuccessfulMissions;
GO
UPDATE #SuccessfulMissions
SET Operator = REPLACE(Operator, ' ', '');
GO 
UPDATE #SuccessfulMissions
SET Spacecraft = LEFT(Spacecraft, CHARINDEX('(', Spacecraft) - 1) -- charindex söker efter vänstra parantesen, left -1 tar bort allt från höger till parantesen. 
WHERE CHARINDEX('(', Spacecraft) > 0; -- Säkerställer att endast rader med som innehåller en parantes uppdateras.
GO
SELECT * FROM #SuccessfulMissions;
GO
SELECT 
    Operator, 
    [Mission type],
    COUNT(*) AS [Mission count]
FROM #SuccessfulMissions
GROUP BY Operator, [Mission type]
HAVING COUNT(*) > 1
ORDER BY Operator, [Mission type];
GO

-- USERS
-----------------------------------------------------------------------
SELECT 
    ID,
    UserName,
    Password,
    (FirstName+ ' ' + LastName) AS Name,
    CASE
        WHEN SUBSTRING(RIGHT(ID, 2), 1, 1) % 2 = 0 THEN 'Female' -- Tar ut de två tecken från höger sen kontrollerar om den vänstra av de två är jämn eller inte.
        ELSE 'Male'
    END AS Gender,
    Email,
    Phone
INTO #NewUsers
FROM Users;
GO
SELECT * FROM #NewUsers;
GO
SELECT 
    UserName,
    COUNT(*) AS [Num of dups]    
FROM #NewUsers
GROUP BY UserName
HAVING COUNT(*) > 1; -- Visar enbart de UN som förekommer fler än en gång.
GO 
ALTER TABLE #NewUsers
ALTER COLUMN UserName NVARCHAR(MAX);
WITH CTE AS ( 
    SELECT 
        ROW_NUMBER() OVER(PARTITION BY UserName ORDER BY UserName) AS ROWNUMBER, 
        UserName 
    FROM #NewUsers 
) 
UPDATE CTE 
SET UserName = CONCAT(UserName, '', (ROWNUMBER - 1)) 
WHERE ROWNUMBER > 1;
GO
SELECT * FROM #NewUsers;
GO
DELETE FROM #NewUsers
WHERE Gender = 'Female' AND LEFT(ID, 2) < 70;
GO
INSERT INTO #NewUsers VALUES ('860528-5116', 'emiedm', 'emilisbest123', 'Emil Edman', 'Male', 'Emil.Edman@gmeail.com', '0739-719096');
GO
SELECT
    Gender,
    AVG(YEAR(GETDATE()) - LEFT(ID, 2) - 1900) AS [Average Age]
FROM #NewUsers
GROUP BY Gender;
GO
SELECT * FROM #NewUsers;
GO

-- COMPANY
-----------------------------------------------------------------------
GO
SELECT 
    cc.Id,
    ProductName,
    CompanyName,
    CategoryName
FROM company.products cc
JOIN company.categories ON CategoryId = company.categories.Id
JOIN company.suppliers ON SupplierId = company.suppliers.Id;
GO
SELECT
    RegionDescription AS Region,
    COUNT(DISTINCT company.employees.Id) AS [Number of employees]
FROM company.regions
JOIN company.territories ON company.regions.Id = company.territories.RegionId
JOIN company.employee_territory ON company.territories.Id = company.employee_territory.TerritoryId
JOIN company.employees ON company.employee_territory.EmployeeId = company.employees.Id
GROUP BY RegionDescription;
GO
SELECT
    e.Id,
    e.TitleOfCourtesy + ' ' + e.FirstName + ' ' + e.LastName AS Name,
    CASE
    WHEN e.ReportsTo IS NULL THEN 'Nobody!'
    ELSE m.TitleOfCourtesy + ' ' + m.FirstName + ' ' + m.LastName 
    END AS ReportsTo
FROM company.employees e
LEFT JOIN company.employees m ON e.ReportsTo = m.Id;
GO