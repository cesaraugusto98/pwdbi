/****** Script do comando SelectTopNRows de SSMS  ******/
INSERT INTO YELLOCLETA.DBO.PRO_PRODUTO
SELECT TOP 1000 
	[PRO_TIPO]
      ,[PRO_NOME]
      ,[PRO_CUSTO]
      ,[PRO_VALOR]
      ,[MAT_ID]
  FROM [BASE].[dbo].[Base_produto]