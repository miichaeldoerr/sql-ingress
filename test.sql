USE pokemonDatabase;
GO

EXEC dbo.pokemonIngress @File = N'C:/Users/doerr/projects/t-sql_ingress/data/Pokemon.json';

-- SELECT * FROM Pokemon
-- SELECT * FROM pType
-- SELECT * FROM Pokemon_Type
-- SELECT * FROM Pokemon_Temp

-- DROP PROCEDURE dbo.pokemonIngress;
-- GO

-- DROP TABLE Pokemon_Temp
-- DROP TABLE Pokemon_Type
-- DROP TABLE Pokemon
-- DROP TABLE pType