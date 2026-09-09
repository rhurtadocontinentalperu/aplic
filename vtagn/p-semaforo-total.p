&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.



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

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pMonVta AS INT.
DEF INPUT PARAMETER TABLE FOR ITEM.
DEF OUTPUT PARAMETER pForeground AS INT.
DEF OUTPUT PARAMETER pBackground AS INT.

/* Valores por defecto */
ASSIGN
    pForeground = ?
    pBackground = ?.

DEF SHARED VAR s-codcia AS INT.

FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
    gn-divi.coddiv = pCodDiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN RETURN.

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
   Temp-Tables and Buffers:
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.62
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF VAR f-Factor AS DEC NO-UNDO.
DEF VAR x-Costo AS DEC NO-UNDO.
DEF VAR x-Margen AS DEC NO-UNDO.
DEF VAR pCosto AS DEC NO-UNDO.
DEF VAR pImpLin AS DEC NO-UNDO.
DEF VAR pMargen AS DEC NO-UNDO.
/*
FOR EACH ITEM NO-LOCK:
    MESSAGE "codmat " ITEM.codmat SKIP
        "candped " ITEM.canped.
END.
    */
FOR EACH ITEM NO-LOCK,
    FIRST Almmmatg OF ITEM NO-LOCK,
    FIRST Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = ITEM.UndVta NO-LOCK:
    ASSIGN
        X-COSTO = 0     /* Incluido el IGV */
        X-MARGEN = 0.
    f-Factor = Almtconv.Equival.
    IF pMonVta = 1 THEN DO:
        IF Almmmatg.MonVta = 1 THEN 
            ASSIGN X-COSTO = (Almmmatg.Ctotot).
        ELSE
            ASSIGN X-COSTO = (Almmmatg.Ctotot) * Almmmatg.TpoCmb.     /*pTpoCmb.*/
    END.
    IF pMonVta = 2 THEN DO:
        IF Almmmatg.MonVta = 2 THEN
            ASSIGN X-COSTO = (Almmmatg.Ctotot).
        ELSE
            ASSIGN X-COSTO = (Almmmatg.Ctotot) / Almmmatg.TpoCmb.     /*pTpoCmb .*/
    END.
    ASSIGN
        pCosto = pCosto + (x-Costo * f-Factor * ITEM.CanPed)
        pImpLin = pImpLin + ITEM.ImpLin.
END.
pMargen = ROUND( ((pImpLin - pCosto) / pCosto) * 100, 2).

FIND FacTabla WHERE FacTabla.CodCia = s-Codcia AND
    FacTabla.Tabla = 'GRUPO_DIVGG' AND
    FacTabla.Codigo = GN-DIVI.Grupo_Divi_GG 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacTabla THEN RETURN.
CASE TRUE:
    WHEN pMargen <= FacTabla.Valor[1] THEN DO:
        ASSIGN
            pForeground = 12    /* Rojo */
            pBackground = 12.
    END.
    WHEN pMargen <= FacTabla.Valor[2] THEN DO:
        ASSIGN
            pForeground = 14    /* Amarillo */
            pBackground = 14.
    END.
    WHEN pMargen <= FacTabla.Valor[3] THEN DO:
        ASSIGN
            pForeground = 10    /* Verde */
            pBackground = 10.
    END.
    OTHERWISE DO:
        ASSIGN
            pForeground = 0    /* Negro */
            pBackground = 0.
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


