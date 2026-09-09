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
/* DEF INPUT PARAMETER pCodMat AS CHAR. */
/* DEF INPUT PARAMETER pCodAlm AS CHAR. */

DEF VAR pParam AS CHAR NO-UNDO.

pParam = SESSION:PARAMETER.
DEF VAR pCodMat AS CHAR NO-UNDO.
DEF VAR pCodAlm AS CHAR NO-UNDO.
ASSIGN
    pCodMat = ENTRY(1,pParam,'|')
    pCodAlm = ENTRY(2,pParam,'|').

DEFINE TEMP-TABLE tmp-tabla
    FIELD t-CodAlm LIKE Almacen.codalm  FORMAT 'x(3)'
    FIELD t-CodDoc LIKE FacDPedi.CodDoc FORMAT "XXX"
    FIELD t-Nroped LIKE FacDPedi.NroPed FORMAT "XXX-XXXXXXXX"
    FIELD t-CodDiv LIKE FacCPedi.CodDiv FORMAT 'x(5)'
    FIELD t-FchPed LIKE FacDPedi.FchPed
    FIELD t-NomCli LIKE FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
    FIELD t-CodMat LIKE FacDPedi.codmat
    FIELD t-Canped LIKE FacDPedi.CanPed.

DEF NEW SHARED VAR s-CodCia AS INTE INIT 001.
DEF VAR pContado AS LOG INIT YES NO-UNDO.
DEF VAR pComprometido AS DECI NO-UNDO.

FIND w-report WHERE w-report.Task-No = 0 AND
    w-report.Llave-C = pCodMat AND
    w-report.Campo-C[1] = pCodAlm
    EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
IF NOT AVAILABLE w-report THEN CREATE w-report.
ASSIGN
    w-report.Task-No = 0 
    w-report.Llave-C = pCodMat 
    w-report.Campo-C[1] = pCodAlm
    w-report.Llave-D = TODAY
    w-report.Campo-C[2] = STRING(TIME,'HH:MM:SS').

FIND Almmmate WHERE Almmmate.CodCia = s-codcia AND
    Almmmate.CodAlm = pCodAlm AND 
    Almmmate.codmat = pCodMat 
    NO-LOCK NO-ERROR.
IF AVAILABLE Almmmate THEN ASSIGN w-report.Campo-F[1] = Almmmate.StkAct.

RUN d:\newsie\on_in_co\aplic\gn\stock-comprometido-v2.p (INPUT pCodMat,
                                INPUT pCodAlm,
                                INPUT pContado,
                                OUTPUT pComprometido).
ASSIGN w-report.Campo-F[2] = pComprometido.

RUN d:\newsie\on_in_co\aplic\alm\p-articulo-en-transito (s-CodCia,
                                pCodAlm,
                                pCodMat,
                                INPUT-OUTPUT TABLE tmp-tabla,
                                OUTPUT pComprometido).
ASSIGN w-report.Campo-F[3] = pComprometido.

FIND OOComPend WHERE OOComPend.CodAlm = pCodAlm
    AND OOComPend.CodMat = pCodMat
    NO-LOCK NO-ERROR.
IF AVAILABLE OOComPend THEN w-report.Campo-F[4] =  (OOComPend.CanPed - OOComPend.CanAte).

QUIT.

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
         HEIGHT             = 4.54
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


