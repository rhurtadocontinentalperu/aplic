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

DEF INPUT PARAMETER pInputValues AS CHAR.
/* Sintaxis 
[path,] Programa [,Parameters]
*/

{alm/windowalmacen.i}

/* Programa de Control de Ingresos por Transferencia NO Recepcionadas */
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN alm/almacen-library.p PERSISTENT SET hProc.
RUN TRF_INg_Transf_Pend IN hProc (INPUT s-CodDiv,
                                  INPUT NOW).
DELETE PROCEDURE hProc.
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN ERROR.

/* Armamos el programa */
DEF VAR pPrograma AS CHAR NO-UNDO.

IF NUM-ENTRIES(pInputValues,'|') = 1 THEN pPrograma = pInputValues.
IF NUM-ENTRIES(pInputValues,'|') > 1 THEN DO:
    pPrograma = ENTRY(1,pInputValues,'|') + '/' + ENTRY(2,pInputValues,'|').
END.

DEF VAR pParametros AS CHAR NO-UNDO.
IF NUM-ENTRIES(pInputValues,'|') > 2 THEN DO:
    pParametros = ENTRY(3,pInputValues,'|').    /* Valores separados por comas */
    CASE NUM-ENTRIES(pParametros):
        WHEN 1 THEN RUN VALUE(pPrograma) ( ENTRY(1,pParametros) ).
    END CASE.
END.
ELSE RUN VALUE(pPrograma).

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
         HEIGHT             = 5.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


