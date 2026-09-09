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
/* 1. Cabecera o Detalle */
DEF INPUT PARAMETER pTabla AS CHAR.
IF NOT LOOKUP(pTabla, 'Almcmov,Almdmov') > 0 THEN RETURN.
/* 
C: Cabecera 
D: Detalle 
*/
/* 2. Ubicación del Registro */
DEF INPUT PARAMETER pRowid AS ROWID.
/* 3. Evento por defecto */
DEF INPUT PARAMETER pFlagEvento AS CHAR.
/* 
C: Create
U: Update
D: Delete
*/

DEF VAR xFlagEvento AS CHAR NO-UNDO.
IF pFlagEvento > '' THEN xFlagEvento = pFlagEvento.

/* Buscamos movimiento base */
CASE pTabla:
    WHEN "Almcmov" THEN DO:
        FIND Almcmov WHERE ROWID(Almcmov) = pRowid NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almcmov THEN RETURN.
        /* Definimos el evento si es que no viene por defecto */
        IF TRUE <> (xFlagEvento > '') THEN DO:
            /* Buscamos movimiento en Open */
            FIND FIRST OOAlmcmov WHERE OOAlmcmov.CodCia = Almcmov.codcia
                AND OOAlmcmov.CodAlm = Almcmov.codalm
                AND OOAlmcmov.TipMov = Almcmov.tipmov
                AND OOAlmcmov.CodMov = Almcmov.codmov
                AND OOAlmcmov.NroSer = Almcmov.nroser
                AND OOAlmcmov.NroDoc = Almcmov.nrodoc
                NO-LOCK NO-ERROR.
            xFlagEvento = "C".  /* CREATE */
            IF AVAILABLE OOAlmcmov THEN xFlagEvento = "U".  /* UPDATE */
            IF Almcmov.FlgEst = "A" THEN xFlagEvento = "D". /* DELETE */
        END.
        CREATE OOAlmcmov.
        BUFFER-COPY Almcmov TO OOAlmcmov
            ASSIGN
            OOAlmcmov.FlagEvento = xFlagEvento
            OOAlmcmov.FlagFecha  = TODAY.
    END.
    WHEN "Almdmov" THEN DO:
        FIND Almdmov WHERE ROWID(Almdmov) = pRowid NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almdmov THEN RETURN.
        FIND FIRST Almcmov OF Almdmov NO-LOCK NO-ERROR.
        IF TRUE <> (xFlagEvento > '') THEN DO:
            /* Buscamos movimiento en Open */
            FIND FIRST OOAlmdmov WHERE OOAlmdmov.CodCia = Almdmov.codcia
                AND OOAlmdmov.CodAlm = Almdmov.codalm
                AND OOAlmdmov.TipMov = Almdmov.tipmov
                AND OOAlmdmov.CodMov = Almdmov.codmov
                AND OOAlmdmov.NroSer = Almdmov.nroser
                AND OOAlmdmov.NroDoc = Almdmov.nrodoc
                AND OOAlmdmov.CodMat = Almdmov.codmat
                NO-LOCK NO-ERROR.
            xFlagEvento = "C".  /* CREATE */
            IF AVAILABLE OOAlmdmov THEN xFlagEvento = "U".  /* UPDATE */
            IF AVAILABLE Almcmov AND Almcmov.FlgEst = "A" THEN xFlagEvento = "D". /* DELETE */
        END.
        CREATE OOAlmdmov.
        BUFFER-COPY Almdmov TO OOAlmdmov
            ASSIGN
            OOAlmdmov.FlagEvento = xFlagEvento
            OOAlmdmov.FlagFecha  = TODAY.
    END.
END CASE.

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
         HEIGHT             = 4.08
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


