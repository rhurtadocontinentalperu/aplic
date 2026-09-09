&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pRowid AS ROWID.

FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.

DEF VAR x-CodigoEncarte AS CHAR NO-UNDO.   /* OJO: Código del ENCARTE */

IF Faccpedi.FlgSit = "CD" THEN x-CodigoEncarte = Faccpedi.Libre_c05.    /* Por Defecto */

IF TRUE <> (x-CodigoEncarte > "") THEN RETURN.

FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

IF Faccpedi.CodCli BEGINS 'SYS' THEN DO:
    FIND FIRST Vtactabla WHERE Vtactabla.codcia = Faccpedi.codcia
        AND VtaCTabla.Tabla = "UTILEX-ENCARTE"
        AND VtaCTabla.Estado = "A"      /* Activa */
        AND VtaCTabla.llave = x-CodigoEncarte    /* Cupón de descuento */
        NO-LOCK NO-ERROR.
END.
ELSE DO:
    FIND FIRST Vtactabla WHERE Vtactabla.codcia = Faccpedi.codcia
        AND VtaCTabla.Tabla = "UTILEX-ENCARTE"
        AND VtaCTabla.Estado = "A"      /* Activa */
        AND TODAY >= VtaCTabla.FechaInicial
        AND TODAY <= VtaCTabla.FechaFinal
        AND VtaCTabla.llave = x-CodigoEncarte    /* Cupón de descuento */
        NO-LOCK NO-ERROR.
END.
IF NOT AVAILABLE VtaCTabla THEN RETURN.

IF TRUE <> (Faccpedi.Libre_c01 > '') THEN RETURN.

FIND FIRST AlmCKits WHERE AlmCKits.CodCia = Vtactabla.codcia
    AND AlmCKits.codmat = Vtactabla.libre_c01
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE AlmCKits THEN RETURN.

DEF TEMP-TABLE Detalle   NO-UNDO LIKE Facdpedi.
DEF TEMP-TABLE Detalle-2 NO-UNDO LIKE Facdpedi.
FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c05 <> 'OF':
    CREATE Detalle.
    BUFFER-COPY Facdpedi TO Detalle.
END.
/* Armamos kits */
rloop:
REPEAT:
    FOR EACH Almdkits OF Almckits NO-LOCK:
        FIND FIRST Detalle WHERE Detalle.codmat = AlmDKits.codmat2 NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Detalle THEN LEAVE rloop.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


