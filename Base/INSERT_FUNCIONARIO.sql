/****** Script do comando SelectTopNRows de SSMS  ******/
INSERT INTO YELLOCLETA.DBO.FUN_FUNCIONARIO
SELECT TOP 1000 [FUN_MATRICULA]
      ,[FUN_NOME]
      ,CAST(REPLACE([FUN_SALARIO],'$','') AS FLOAT)
      ,[FUN_SETOR]
      ,[FUN_CARGO]
  FROM [BASE].[dbo].[Base_funcionario]