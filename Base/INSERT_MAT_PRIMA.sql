/****** Script do comando SelectTopNRows de SSMS  ******/
INSERT INTO YELLOCLETA.DBO.MAT_MATERIA_PRIMA
SELECT TOP 1000
      [MAT_NOME]
      ,[MAT_QUALIDADE]
  FROM [BASE].[dbo].[Base_materia_prima]