-- SQL Written By: Michael Robert Doerr

-- change 'pokemonDatabase' to a database of your choice.
USE pokemonDatabase;
GO

CREATE PROCEDURE pokemonIngress (@File VARCHAR(MAX))
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PokemonExists INT;
    DECLARE @PTypeExists INT;
    DECLARE @PokemonTypeExists INT;

    SET @PokemonExists = 0;
    SET @PTypeExists = 0;
    SET @PokemonTypeExists = 0;

    IF NOT (EXISTS (SELECT * 
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = 'dbo'
        AND TABLE_NAME = 'Pokemon_Temp'))
        BEGIN
            PRINT N'Importing JSON data into a temporary table for querying...'
            DECLARE @SQL VARCHAR(MAX) = '
                SELECT Pokemon.*
                INTO Pokemon_Temp
                FROM OPENROWSET(BULK N' + CHAR(39) +  @File + CHAR(39) + ', SINGLE_CLOB) AS JSON_POKEMON
                    CROSS APPLY OPENJSON(bulkColumn)
                WITH
                (
                    Code	CHAR(3), 
                    [Type]	VARCHAR(50),
                    Hex		CHAR(6),
                    Pokemon	NVARCHAR(MAX) AS JSON 
                )AS Pokemon;
            '
            EXEC(@SQL)
            PRINT N'DONE'
        END
    ELSE
        BEGIN
            PRINT N'Something went wrong. Removing an old temporary table. Please try 
                    again or speak to you data administrator.'
            DROP TABLE Pokemon_Temp
            RETURN
        END

    IF NOT (EXISTS (SELECT *
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = 'dbo'
        AND TABLE_NAME = 'PType'))
        BEGIN
            PRINT N'Generating the pType table and loading the data...'
            SELECT Code AS ptCode, [Type] AS ptName, Hex AS ptHex
            INTO PType
            FROM Pokemon_Temp
            PRINT N'DONE'
        END
    ELSE
        BEGIN TRY
            PRINT N'Loading the data to PType...'
            SET @PTypeExists = 1;
            INSERT INTO PType
            SELECT Code AS ptCode, [Type] AS ptName, Hex AS ptHex
            FROM Pokemon_Temp
            PRINT N'DONE'
        END TRY
        BEGIN CATCH
            PRINT N'A duplicate may have occured, dropping temporary table. If 
                    this is a mistake, please speak to your system administrator.'
            DROP TABLE Pokemon_Temp
            RETURN
        END CATCH

    IF NOT (EXISTS (SELECT *
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = 'dbo'
        AND TABLE_NAME = 'Pokemon'))
        BEGIN
            PRINT N'Generating the Pokemon table and loading the data...'
            SELECT DISTINCT Pokemon_Data.*
            INTO Pokemon
            FROM Pokemon_Temp
                CROSS APPLY OPENJSON(Pokemon)
            WITH
            (
                pokDexNo		CHAR(3)			'$.DexNo',
                pokName			VARCHAR(50)		'$.Name',
                pokHeight		DECIMAL(5,2)	'$.Height',
                pokWeight		DECIMAL(6,2)	'$.Weight'
            )AS Pokemon_Data
            PRINT N'DONE'
        END
    ELSE
        BEGIN TRY
            PRINT N'Loading the data to Pokemon...'
            SET @PokemonExists = 1;
            INSERT INTO Pokemon
            SELECT DISTINCT Pokemon_Data.*
            FROM Pokemon_Temp
                CROSS APPLY OPENJSON(Pokemon)
            WITH
            (
                pokDexNo		CHAR(3)			'$.DexNo',
                pokName			VARCHAR(50)		'$.Name',
                pokHeight		DECIMAL(5,2)	'$.Height',
                pokWeight		DECIMAL(6,2)	'$.Weight'
            )AS Pokemon_Data
            PRINT N'DONE'
        END TRY
        BEGIN CATCH
            PRINT N'A duplicate may have occured, dropping temporary table. If 
                    this is a mistake, please speak to your system administrator.'
            DROP TABLE Pokemon_Temp
            RETURN
        END CATCH

    IF NOT (EXISTS (SELECT *
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = 'dbo'
        AND TABLE_NAME = 'Pokemon_Type'))
        BEGIN
            PRINT N'Generating the Pokemon_Type bridge table...'
            SELECT Pokemon_Temp.Code AS ptCode, pokDexNo
            INTO Pokemon_Type
            FROM Pokemon_Temp
                CROSS APPLY OPENJSON(Pokemon)
            WITH
            (
                pokDexNo		CHAR(3)			'$.DexNo'
                
            )AS Pokemon
            PRINT N'DONE'
        END
    ELSE
        BEGIN TRY
            PRINT N'Loading the data to Pokemon_Type...'
            SET @PokemonTypeExists = 1;
            INSERT INTO Pokemon_Type
            SELECT Pokemon_Temp.Code AS ptCode, pokDexNo
            FROM Pokemon_Temp
                CROSS APPLY OPENJSON(Pokemon)
            WITH
            (
                pokDexNo		CHAR(3)			'$.DexNo'
                
            )AS Pokemon
            PRINT N'DONE'
        END TRY
        BEGIN CATCH
            PRINT N'A duplicate may have occured, dropping temporary table. If 
                    this is a mistake, please speak to your system administrator.'
            DROP TABLE Pokemon_Temp
            RETURN
        END CATCH
        

    IF NOT @PTypeExists = 1
        BEGIN
            PRINT N'Make ptCode in the table pType NOT NULL for primary and foreign keys...'
            ALTER TABLE pType
            ALTER COLUMN ptCode CHAR(3) NOT NULL
            PRINT N'DONE'
        END
    IF NOT @PokemonExists = 1
        BEGIN
            PRINT N'Make pokDexNo in the table Pokemon NOT NULL for primary and foreign keys...'
            ALTER TABLE Pokemon
            ALTER COLUMN pokDexNo CHAR(3) NOT NULL
            PRINT N'DONE'
        END

    IF NOT @PTypeExists = 1
        BEGIN
            PRINT N'Add the primary key constraint pk_pType_ptCode/ptCode to table pType...'
            ALTER TABLE pType
            ADD CONSTRAINT pk_pType_ptCode PRIMARY KEY(ptCode)
            PRINT N'DONE'
        END

    IF NOT @PokemonExists = 1
        BEGIN
            PRINT N'Add the primary key constraint pk_pokemon_pokDexNo/pokDexNo to table Pokemon...'
            ALTER TABLE Pokemon
            ADD CONSTRAINT pk_pokemon_pokDexNo PRIMARY KEY(pokDexNo)
            PRINT N'DONE'
        END

    IF NOT @PokemonTypeExists = 1
        BEGIN
            PRINT N'Add the foreign key constraint fk_pokemonType_Pokemon/pokDexNo to table Pokemon_Type...'
            ALTER TABLE Pokemon_Type
            ADD CONSTRAINT fk_pokemonType_Pokemon FOREIGN KEY(pokDexNo)
                REFERENCES Pokemon(pokDexNo)
            PRINT N'DONE'

            PRINT N'Add the foreign key constraint fk_pokemonType_pType/ptCode to table Pokemon_Type...'
            ALTER TABLE Pokemon_Type
            ADD CONSTRAINT fk_pokemonType_pType FOREIGN KEY(ptCode)
                REFERENCES PType(ptCode)
            PRINT N'DONE'
        END

    BEGIN
        PRINT N'Drop the temporary table...'
        DROP TABLE Pokemon_Temp
        PRINT N'DONE'
    END
END
GO