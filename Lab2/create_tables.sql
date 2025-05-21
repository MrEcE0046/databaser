SELECT
    fk.name AS ForeignKey,
    OBJECT_SCHEMA_NAME(fk.parent_object_id) AS SchemaName,
    OBJECT_NAME(fk.parent_object_id) AS ReferencingTable
FROM sys.foreign_keys AS fk
WHERE fk.referenced_object_id = OBJECT_ID('dbo.BöckerOchFörfattare');

SELECT
    pk.name AS PrimaryKey,
    OBJECT_SCHEMA_NAME(pk.parent_object_id) AS SchemaName,
    OBJECT_NAME(pk.parent_object_id) AS ReferencingTable
FROM sys.foreign_keys AS pk
WHERE pk.referenced_object_id = OBJECT_ID('dbo.BöckerOchFörfattare');

ALTER TABLE dbo.butiker
DROP CONSTRAINT PK__Böcker__Författa__398D8EEE;

DROP TABLE dbo.BokGenre;
------------------------------------------------------------------------------
--SELECT * FROM [Författare]
CREATE TABLE [Författare](
    ID INT PRIMARY KEY,
    Förnamn NVARCHAR(20),
    Efternamn NVARCHAR(20),
    Födelsedatum DATE
);
----------------------------------------------------------------------------------------------
-- SELECT * FROM [BöckerOchFörfattare]
CREATE TABLE [BöckerOchFörfattare](
    BokId VARCHAR(13) NOT NULL,
    FörfattareId INT NOT NULL,
    PRIMARY KEY (BokId, FörfattareId),
    FOREIGN KEY (BokId) REFERENCES [Böcker](ISBN13),
    FOREIGN KEY (FörfattareId) REFERENCES [Författare](ID)
);
----------------------------------------------------------------------------------------------
--SELECT * FROM [Böcker]
CREATE TABLE [Böcker](
    ISBN13 VARCHAR(13) NOT NULL PRIMARY KEY,
    Titel NVARCHAR(100),
    Språk NVARCHAR(50),
    Pris FLOAT,
    Utgivningsdatum NVARCHAR(50)
);
----------------------------------------------------------------------------------------------
--SELECT * FROM Butiker
CREATE TABLE Butiker(
    ID INT PRIMARY KEY,
    Butiksnamn VARCHAR(50),
    Adress VARCHAR(50),
    Stad VARCHAR(50)
);
----------------------------------------------------------------------------------------------
-- SELECT * FROM LagerSaldo
CREATE TABLE LagerSaldo (
    ButiksId INT NOT NULL,
    ISBN VARCHAR(13) NOT NULL,
    Saldo INT,
    FOREIGN KEY (ButiksId) REFERENCES Butiker(ID),
    FOREIGN KEY (ISBN) REFERENCES Böcker(ISBN13)
);
-----------------------------------------------------------------------------------------------
-- SELECT * FROM [Förlag]
CREATE TABLE [Förlag] (
    Förlagsnamn VARCHAR(50),
    Adress VARCHAR(50),
    Telefon VARCHAR(50),
    ISBN VARCHAR(13) NOT NULL,
    PRIMARY KEY (Förlagsnamn, ISBN),
    FOREIGN KEY (ISBN) REFERENCES Böcker(ISBN13)
);
----------------------------------------------------------------------------------------------
-- SELECT * FROM Genre
CREATE TABLE Genre (
    GenreId INT NOT NULL PRIMARY KEY,
    Genre VARCHAR(50)
);
----------------------------------------------------------------------------------------------
-- SELECT * FROM BokGenre
CREATE TABLE BokGenre(
    ISBN13 VARCHAR(13) NOT NULL,
    GenreId INT NOT NULL,
    PRIMARY KEY (ISBN13, GenreId),
    FOREIGN KEY (ISBN13) REFERENCES Böcker(ISBN13),
    FOREIGN KEY (GenreId) REFERENCES Genre(GenreId)
);
------------------------------------------------------------------------------------------------
-- SELECT * FROM [Försäljning]
CREATE TABLE [Försäljning](
    FörsäljningId INT NOT NULL PRIMARY KEY,
    Butik INT NOT NULL,
    BokId VARCHAR(13) NOT NULL,
    KundId INT NOT NULL,
    Datum DATE NOT NULL,
    FOREIGN KEY (Butik) REFERENCES Butiker(ID),
    FOREIGN KEY (BokId) REFERENCES Böcker(ISBN13),
    FOREIGN KEY (KundId) REFERENCES Kund(KundId)
);
------------------------------------------------------------------------------------------------
-- SELECT * FROM Kund;
CREATE TABLE Kund(
    KundId INT PRIMARY KEY,
    Förnamn VARCHAR(50),
    Efternamn VARCHAR(50),
    Adress VARCHAR(50),
    Postnr INT,
    Ort VARCHAR(50)
);