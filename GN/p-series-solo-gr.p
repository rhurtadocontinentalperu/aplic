&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description : Rutina que devuelve los números de serie solicitados

    Author(s)   :
    Created     :
    Notes       : Solamente para G/R
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pUso AS CHAR.
DEF INPUT PARAMETER pEstado AS LOG.
DEF OUTPUT PARAMETER pSeries AS CHAR.

/* Parámetros:
pUso = VENTAS, TRANSFERENCIAS, ITINERANTES y TODOS
pEstado = YES solo activas, NO solo inactivas, ? Todas

pSeries = Series solicitadas separadas por comas

*/

IF LOOKUP(pUso,"VENTAS,TRANSFERENCIAS,ITINERANTES,TODOS,?") = 0  THEN RETURN ERROR.

DEF SHARED VAR s-codcia AS INTE.

DEF VAR pCodDoc AS CHAR INIT 'G/R' NO-UNDO.

pSeries = ''.
/* Valor especial para pUso */
IF pUso = "?" THEN RETURN.

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
         HEIGHT             = 3.77
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* Nota: La serie 000 se usa como serie para transferencia interna */

FOR EACH FacCorre NO-LOCK WHERE FacCorre.CodCia = s-codcia AND
    FacCorre.CodDiv = pCodDiv AND
    FacCorre.CodDoc = pCodDoc AND
    FacCorre.NroSer <> 000:         /* No tomarla en cuenta */
    /* Si la serie está definida para uso TODOS entonces SIEMPRE va,
        no importa cual es el parámetro pUso */
    IF FacCorre.CodPro <> "TODOS" THEN DO:
        IF FacCorre.CodPro <> pUso THEN NEXT.
    END.
    IF pEstado <> ? AND FacCorre.FlgEst <> pEstado THEN NEXT.
    pSeries = pSeries + ( IF TRUE <> (pSeries > '') THEN '' ELSE ',' ) +
        STRING(FacCorre.NroSer,'999').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


