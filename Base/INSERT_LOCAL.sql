/****** Script do comando SelectTopNRows de SSMS  ******/
INSERT INTO YELLOCLETA.DBO.LOC_LOCAL
SELECT TOP 1000 [LOC_ZONA]
      ,[LOC_ESTANTE]
      ,[LOC_PRATELEIRA]
      ,[LOC_GAVETA]
  FROM [BASE].[dbo].[Base_local]