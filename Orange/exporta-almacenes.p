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
DEF INPUT PARAMETER pRaw AS RAW.

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
DEF TEMP-TABLE t-Almcmov LIKE Almcmov.
DEF TEMP-TABLE t-Almdmov LIKE Almdmov.

CASE pTabla:
    WHEN "Almcmov" THEN DO:
        /* Definimos el evento si es que no viene por defecto */
        IF TRUE <> (xFlagEvento > '') THEN DO:
            xFlagEvento = "C".  /* CREATE */
        END.
        CREATE t-Almcmov.
        RAW-TRANSFER pRaw TO t-Almcmov.
        CREATE OOAlmcmov.
        BUFFER-COPY t-Almcmov TO OOAlmcmov.
        ASSIGN
            OOAlmcmov.FlagEvento = xFlagEvento
            OOAlmcmov.FlagFecha  = TODAY
            OOAlmcmov.FlagHora   = STRING(TIME,'HH:MM:SS')
            OOAlmcmov.FlagNumero = INTEGER(RECID(OOAlmcmov)).
    END.
    WHEN "Almdmov" THEN DO:
        IF TRUE <> (xFlagEvento > '') THEN DO:
            xFlagEvento = "C".  /* CREATE */
        END.
        CREATE t-Almdmov.
        RAW-TRANSFER pRaw TO t-Almdmov.
        CREATE OOAlmdmov.
        BUFFER-COPY t-Almdmov TO OOAlmdmov.
        ASSIGN
            OOAlmdmov.FlagEvento = xFlagEvento
            OOAlmdmov.FlagFecha  = TODAY
            OOAlmdmov.FlagHora   = STRING(TIME,'HH:MM:SS')
            OOAlmdmov.FlagNumero = INTEGER(RECID(OOAlmdmov)).
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
         HEIGHT             = 4.1
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


