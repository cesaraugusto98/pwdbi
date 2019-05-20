DROP DATABASE YELLOCLETA;

CREATE DATABASE YELLOCLETA;

USE YELLOCLETA; 

CREATE TABLE [EST_ESTOQUE]
( 
	[EST_ID]             integer  NOT NULL  IDENTITY ,
	[LOC_ID]             integer  NOT NULL ,
	[PRO_ID]             integer  NOT NULL ,
	[EST_QTD]            integer  NULL ,
	[FUN_ID_COLOCOU]     integer  NULL ,
	[FUN_ID_RETIROU]     integer  NULL ,
)
go

ALTER TABLE [EST_ESTOQUE]
	ADD CONSTRAINT [XPKEST_ESTOQUE] PRIMARY KEY  CLUSTERED ([EST_ID] ASC,[PRO_ID] ASC,[LOC_ID] ASC)
go

CREATE TABLE [FUN_FUNCIONARIO]
( 
	[FUN_ID]             integer  NOT NULL  IDENTITY ,
	[FUN_MATRICULA]      char(50)  NULL ,
	[FUN_NOME]           char(50)  NULL ,
	[FUN_SALARIO]        float  NULL ,
	[FUN_SETOR]          char(50)  NULL ,
	[FUN_CARGO]          char(50)  NULL 
)
go

ALTER TABLE [FUN_FUNCIONARIO]
	ADD CONSTRAINT [XPKFUN_FUNCIONARIO] PRIMARY KEY  CLUSTERED ([FUN_ID] ASC)
go

CREATE TABLE [LOC_LOCAL]
( 
	[LOC_ID]             integer  NOT NULL  IDENTITY ,
	[LOC_ZONA]           char(50)  NULL ,
	[LOC_ESTANTE]        char(50)  NULL ,
	[LOC_PRATELEIRA]     char(50)  NULL ,
	[LOC_GAVETA]         char(50)  NULL 
)
go

ALTER TABLE [LOC_LOCAL]
	ADD CONSTRAINT [XPKLOC_LOCAL] PRIMARY KEY  CLUSTERED ([LOC_ID] ASC)
go

CREATE TABLE [MAT_MATERIA_PRIMA]
( 
	[MAT_ID]             integer  NOT NULL  IDENTITY ,
	[MAT_NOME]           char(50)  NULL ,
	[MAT_QUALIDADE]      char(50)  NULL 
)
go

ALTER TABLE [MAT_MATERIA_PRIMA]
	ADD CONSTRAINT [XPKMAT_MATERIA_PRIMA] PRIMARY KEY  CLUSTERED ([MAT_ID] ASC)
go

CREATE TABLE [PRO_PRODUTO]
( 
	[PRO_ID]             integer  NOT NULL  IDENTITY ,
	[PRO_TIPO]           char(50)  NULL ,
	[PRO_NOME]           char(50)  NULL ,
	[PRO_CUSTO]          float  NULL ,
	[PRO_VALOR]          float  NULL ,
	[MAT_ID]             integer  NOT NULL 
)
go

ALTER TABLE [PRO_PRODUTO]
	ADD CONSTRAINT [XPKPRO_PRODUTO] PRIMARY KEY  CLUSTERED ([PRO_ID] ASC,[MAT_ID] ASC)
go


ALTER TABLE [EST_ESTOQUE]
	ADD CONSTRAINT [R_2] FOREIGN KEY ([PRO_ID]) REFERENCES [PRO_PRODUTO]([PRO_ID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [EST_ESTOQUE]
	ADD CONSTRAINT [R_7] FOREIGN KEY ([LOC_ID]) REFERENCES [LOC_LOCAL]([LOC_ID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [PRO_PRODUTO]
	ADD CONSTRAINT [R_4] FOREIGN KEY ([MAT_ID]) REFERENCES [MAT_MATERIA_PRIMA]([MAT_ID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

"""
CREATE TRIGGER tD_EST_ESTOQUE ON EST_ESTOQUE FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on EST_ESTOQUE */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* LOC_LOCAL  EST_ESTOQUE on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002a342", PARENT_OWNER="", PARENT_TABLE="LOC_LOCAL"
    CHILD_OWNER="", CHILD_TABLE="EST_ESTOQUE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="LOC_ID" */
    IF EXISTS (SELECT * FROM deleted,LOC_LOCAL
      WHERE
        /* %JoinFKPK(deleted,LOC_LOCAL," = "," AND") */
        deleted.LOC_ID = LOC_LOCAL.LOC_ID AND
        NOT EXISTS (
          SELECT * FROM EST_ESTOQUE
          WHERE
            /* %JoinFKPK(EST_ESTOQUE,LOC_LOCAL," = "," AND") */
            EST_ESTOQUE.LOC_ID = LOC_LOCAL.LOC_ID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last EST_ESTOQUE because LOC_LOCAL exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* PRO_PRODUTO  EST_ESTOQUE on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PRO_PRODUTO"
    CHILD_OWNER="", CHILD_TABLE="EST_ESTOQUE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="PRO_ID""MAT_ID" */
    IF EXISTS (SELECT * FROM deleted,PRO_PRODUTO
      WHERE
        /* %JoinFKPK(deleted,PRO_PRODUTO," = "," AND") */
        deleted.PRO_ID = PRO_PRODUTO.PRO_ID AND
        deleted.MAT_ID = PRO_PRODUTO.MAT_ID AND
        NOT EXISTS (
          SELECT * FROM EST_ESTOQUE
          WHERE
            /* %JoinFKPK(EST_ESTOQUE,PRO_PRODUTO," = "," AND") */
            EST_ESTOQUE.PRO_ID = PRO_PRODUTO.PRO_ID AND
            EST_ESTOQUE.MAT_ID = PRO_PRODUTO.MAT_ID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last EST_ESTOQUE because PRO_PRODUTO exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_EST_ESTOQUE ON EST_ESTOQUE FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on EST_ESTOQUE */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insEST_ID integer, 
           @insLOC_ID integer, 
           @insPRO_ID integer, 
           @insMAT_ID integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* LOC_LOCAL  EST_ESTOQUE on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002ce18", PARENT_OWNER="", PARENT_TABLE="LOC_LOCAL"
    CHILD_OWNER="", CHILD_TABLE="EST_ESTOQUE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="LOC_ID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(LOC_ID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,LOC_LOCAL
        WHERE
          /* %JoinFKPK(inserted,LOC_LOCAL) */
          inserted.LOC_ID = LOC_LOCAL.LOC_ID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update EST_ESTOQUE because LOC_LOCAL does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* PRO_PRODUTO  EST_ESTOQUE on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="PRO_PRODUTO"
    CHILD_OWNER="", CHILD_TABLE="EST_ESTOQUE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="PRO_ID""MAT_ID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(PRO_ID) OR
    UPDATE(MAT_ID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,PRO_PRODUTO
        WHERE
          /* %JoinFKPK(inserted,PRO_PRODUTO) */
          inserted.PRO_ID = PRO_PRODUTO.PRO_ID and
          inserted.MAT_ID = PRO_PRODUTO.MAT_ID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update EST_ESTOQUE because PRO_PRODUTO does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_LOC_LOCAL ON LOC_LOCAL FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on LOC_LOCAL */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* LOC_LOCAL  EST_ESTOQUE on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0001120f", PARENT_OWNER="", PARENT_TABLE="LOC_LOCAL"
    CHILD_OWNER="", CHILD_TABLE="EST_ESTOQUE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="LOC_ID" */
    IF EXISTS (
      SELECT * FROM deleted,EST_ESTOQUE
      WHERE
        /*  %JoinFKPK(EST_ESTOQUE,deleted," = "," AND") */
        EST_ESTOQUE.LOC_ID = deleted.LOC_ID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete LOC_LOCAL because EST_ESTOQUE exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_LOC_LOCAL ON LOC_LOCAL FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on LOC_LOCAL */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insLOC_ID integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* LOC_LOCAL  EST_ESTOQUE on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00012136", PARENT_OWNER="", PARENT_TABLE="LOC_LOCAL"
    CHILD_OWNER="", CHILD_TABLE="EST_ESTOQUE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="LOC_ID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(LOC_ID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,EST_ESTOQUE
      WHERE
        /*  %JoinFKPK(EST_ESTOQUE,deleted," = "," AND") */
        EST_ESTOQUE.LOC_ID = deleted.LOC_ID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update LOC_LOCAL because EST_ESTOQUE exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_MAT_MATERIA_PRIMA ON MAT_MATERIA_PRIMA FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on MAT_MATERIA_PRIMA */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* MAT_MATERIA_PRIMA  PRO_PRODUTO on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00011b28", PARENT_OWNER="", PARENT_TABLE="MAT_MATERIA_PRIMA"
    CHILD_OWNER="", CHILD_TABLE="PRO_PRODUTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="MAT_ID" */
    IF EXISTS (
      SELECT * FROM deleted,PRO_PRODUTO
      WHERE
        /*  %JoinFKPK(PRO_PRODUTO,deleted," = "," AND") */
        PRO_PRODUTO.MAT_ID = deleted.MAT_ID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete MAT_MATERIA_PRIMA because PRO_PRODUTO exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_MAT_MATERIA_PRIMA ON MAT_MATERIA_PRIMA FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on MAT_MATERIA_PRIMA */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insMAT_ID integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* MAT_MATERIA_PRIMA  PRO_PRODUTO on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00013591", PARENT_OWNER="", PARENT_TABLE="MAT_MATERIA_PRIMA"
    CHILD_OWNER="", CHILD_TABLE="PRO_PRODUTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="MAT_ID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(MAT_ID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,PRO_PRODUTO
      WHERE
        /*  %JoinFKPK(PRO_PRODUTO,deleted," = "," AND") */
        PRO_PRODUTO.MAT_ID = deleted.MAT_ID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update MAT_MATERIA_PRIMA because PRO_PRODUTO exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_PRO_PRODUTO ON PRO_PRODUTO FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on PRO_PRODUTO */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* PRO_PRODUTO  EST_ESTOQUE on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00027916", PARENT_OWNER="", PARENT_TABLE="PRO_PRODUTO"
    CHILD_OWNER="", CHILD_TABLE="EST_ESTOQUE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="PRO_ID""MAT_ID" */
    IF EXISTS (
      SELECT * FROM deleted,EST_ESTOQUE
      WHERE
        /*  %JoinFKPK(EST_ESTOQUE,deleted," = "," AND") */
        EST_ESTOQUE.PRO_ID = deleted.PRO_ID AND
        EST_ESTOQUE.MAT_ID = deleted.MAT_ID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete PRO_PRODUTO because EST_ESTOQUE exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* MAT_MATERIA_PRIMA  PRO_PRODUTO on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="MAT_MATERIA_PRIMA"
    CHILD_OWNER="", CHILD_TABLE="PRO_PRODUTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="MAT_ID" */
    IF EXISTS (SELECT * FROM deleted,MAT_MATERIA_PRIMA
      WHERE
        /* %JoinFKPK(deleted,MAT_MATERIA_PRIMA," = "," AND") */
        deleted.MAT_ID = MAT_MATERIA_PRIMA.MAT_ID AND
        NOT EXISTS (
          SELECT * FROM PRO_PRODUTO
          WHERE
            /* %JoinFKPK(PRO_PRODUTO,MAT_MATERIA_PRIMA," = "," AND") */
            PRO_PRODUTO.MAT_ID = MAT_MATERIA_PRIMA.MAT_ID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last PRO_PRODUTO because MAT_MATERIA_PRIMA exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_PRO_PRODUTO ON PRO_PRODUTO FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on PRO_PRODUTO */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insPRO_ID integer, 
           @insMAT_ID integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* PRO_PRODUTO  EST_ESTOQUE on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0002b80c", PARENT_OWNER="", PARENT_TABLE="PRO_PRODUTO"
    CHILD_OWNER="", CHILD_TABLE="EST_ESTOQUE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="PRO_ID""MAT_ID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(PRO_ID) OR
    UPDATE(MAT_ID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,EST_ESTOQUE
      WHERE
        /*  %JoinFKPK(EST_ESTOQUE,deleted," = "," AND") */
        EST_ESTOQUE.PRO_ID = deleted.PRO_ID AND
        EST_ESTOQUE.MAT_ID = deleted.MAT_ID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update PRO_PRODUTO because EST_ESTOQUE exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* MAT_MATERIA_PRIMA  PRO_PRODUTO on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="MAT_MATERIA_PRIMA"
    CHILD_OWNER="", CHILD_TABLE="PRO_PRODUTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="MAT_ID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(MAT_ID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,MAT_MATERIA_PRIMA
        WHERE
          /* %JoinFKPK(inserted,MAT_MATERIA_PRIMA) */
          inserted.MAT_ID = MAT_MATERIA_PRIMA.MAT_ID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update PRO_PRODUTO because MAT_MATERIA_PRIMA does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


"""