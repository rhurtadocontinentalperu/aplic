&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.
DEF VAR s-task-no AS INT INITIAL 0 NO-UNDO.
DEF VAR s-titulo AS CHAR NO-UNDO.
DEF VAR s-subtit AS CHAR NO-UNDO.
DEF VAR s-horcie AS CHAR NO-UNDO.
DEF VAR s-divi   AS CHAR NO-UNDO.
DEF VAR s-dcefes AS DECI NO-UNDO.
DEF VAR s-dcefed AS DECI NO-UNDO.
DEF VAR s-dcchqs AS DECI NO-UNDO. 
DEF VAR s-dcchqd AS DECI NO-UNDO. 
DEF VAR s-dcchqds AS DECI NO-UNDO. 
DEF VAR s-dcchqdd AS DECI NO-UNDO. 
DEF VAR s-dcdeps AS DECI NO-UNDO. 
DEF VAR s-dcdepd AS DECI NO-UNDO. 
DEF VAR s-dctars AS DECI NO-UNDO. 
DEF VAR s-dctard AS DECI NO-UNDO.
DEF VAR s-dcpers AS DECI NO-UNDO. 
DEF VAR s-dcperd AS DECI NO-UNDO.
DEF VAR xtpocmb  AS DECI NO-UNDO.



/* VARIABLES A USAR */
/* Variables compartidas */
DEFINE new SHARED VAR s-pagina-final AS INTEGER.
DEFINE new SHARED VAR s-pagina-inicial AS INTEGER.
DEFINE new SHARED VAR s-salida-impresion AS INTEGER.
DEFINE new SHARED VAR s-printer-name AS CHAR.
DEFINE new SHARED VAR s-print-file AS CHAR.
DEFINE new SHARED VAR s-nro-copias AS INTEGER.
DEFINE new SHARED VAR s-orientacion AS INTEGER.

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "aplic/ccb/rbccb.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Pre-cierre de caja3".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* capturamos ruta inicial */
DEF VAR S-REPORT-LIBRARY AS CHAR.
GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.
RB-REPORT-LIBRARY = s-report-library + "ccb\rbccb.prl".
DEF TEMP-TABLE TEMPO FIELD TIPO   AS CHAR
                     FIELD TOTSOL AS DECI INIT 0
                     FIELD TOTDOL AS DECI INIT 0
                     FIELD TOTSOLND AS DECI INIT 0
                     FIELD TOTDOLND AS DECI INIT 0
                     FIELD TOTSOLCR AS DECI INIT 0
                     FIELD TOTDOLCR AS DECI INIT 0
                     FIELD TOTSOLCE AS DECI INIT 0
                     FIELD TOTDOLCE AS DECI INIT 0
                     FIELD CAJA   AS DECI EXTENT 10 INIT 0
                     FIELD NRODOC AS CHAR 
                     FIELD CODDOC AS CHAR
                     FIELD GLOSA AS CHAR
                     INDEX TEMPO TIPO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CcbCierr

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 CcbCierr.FchCie CcbCierr.HorCie ~
CcbCierr.usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-2
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH CcbCierr ~
      WHERE CcbCierr.CodCia = s-codcia ~
 AND CcbCierr.FchCie = x-fchcie NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 CcbCierr
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 CcbCierr


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 X-FchCie Btn_OK ~
Btn_Cancel BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS X-FchCie 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Ca&ncelar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "&Aceptar" 
     SIZE 12 BY 1.08
     BGCOLOR 8 .

DEFINE VARIABLE X-FchCie AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de cierre" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37.43 BY 6.19.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37.43 BY 1.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 14.86 BY 7.58.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      CcbCierr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _STRUCTURED
  QUERY BROWSE-2 DISPLAY
      CcbCierr.FchCie COLUMN-LABEL "Fecha de cierre"
      CcbCierr.HorCie
      CcbCierr.usuario COLUMN-LABEL "          Cajero" FORMAT "x(15)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 33.72 BY 4.5
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     X-FchCie AT ROW 1.38 COL 14.57 COLON-ALIGNED
     Btn_OK AT ROW 3.04 COL 40.14
     Btn_Cancel AT ROW 4.23 COL 40.14
     BROWSE-2 AT ROW 2.77 COL 2.72
     RECT-1 AT ROW 2.46 COL 1.14
     RECT-2 AT ROW 1.04 COL 1.14
     RECT-3 AT ROW 1.15 COL 38.86
     "Haga ~"click~" en o los cajeros a imprimir" VIEW-AS TEXT
          SIZE 33.43 BY .5 AT ROW 7.69 COL 2.86
          FONT 6
     SPACE(17.70) SKIP(0.54)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Reporte de Cierre de caja"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   Custom                                                               */
/* BROWSE-TAB BROWSE-2 Btn_Cancel D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "integral.CcbCierr"
     _Where[1]         = "integral.CcbCierr.CodCia = s-codcia
 AND integral.CcbCierr.FchCie = x-fchcie"
     _FldNameList[1]   > integral.CcbCierr.FchCie
"CcbCierr.FchCie" "Fecha de cierre" ? "date" ? ? ? ? ? ? no ?
     _FldNameList[2]   = integral.CcbCierr.HorCie
     _FldNameList[3]   > integral.CcbCierr.usuario
"CcbCierr.usuario" "          Cajero" "x(15)" "character" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Reporte de Cierre de caja */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0
  THEN DO:
    MESSAGE "Marque el o los cajeros a imprimir" VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME X-FchCie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-FchCie D-Dialog
ON LEAVE OF X-FchCie IN FRAME D-Dialog /* Fecha de cierre */
OR "RETURN" OF X-FchCie
DO:
  ASSIGN {&SELF-NAME}.
  OPEN QUERY {&BROWSE-NAME} FOR EACH CcbCierr
    WHERE CcbCierr.CodCia = s-codcia
    AND CcbCierr.FchCie = x-fchcie SHARE-LOCK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR XNOMBRE AS CHAR.
  DEF VAR i AS INT NO-UNDO.
  s-subtit = "CAJERO(S)      : ".
  s-horcie = "HORA DE CIERRE : ".
  s-divi   = "DIVISION       : ".
   
  DO WITH FRAME D-Dialog:
    DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) 
        THEN DO:
            s-subtit = s-subtit + ccbcierr.Usuario + ",".
            s-horcie = s-horcie + ccbcierr.horcie + ",".
            FIND FACUSERS WHERE FACUSERS.CODCIA = S-CODCIA AND
                                FACUSERS.USUARIO = CCBCIERR.USUARIO NO-LOCK NO-ERROR.
            IF AVAILABLE FACUSERS THEN DO:
              FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA AND
                                 GN-DIVI.CodDiv = FACUSERS.CODDIV  NO-LOCK NO-ERROR.
              IF AVAILABLE GN-DIVI THEN s-divi = s-divi + GN-DIVI.CodDiv + " " + GN-DIVI.DesDiv + " " .

            END.                                
            FIND CCBDECL WHERE CCBDECL.CODCIA = S-CODCIA AND
                               CCBDECL.USUARIO = CCBCIERR.USUARIO AND
                               CCBDECL.FCHCIE  = CCBCIERR.FCHCIE  AND
                               CCBDECL.HORCIE  = CCBCIERR.HORCIE NO-LOCK.
            IF AVAILABLE CCBDECL THEN DO:
            
              FIND TEMPO where tempo.tipo = "DECS" NO-LOCK NO-ERROR.
             
              IF NOT AVAILABLE TEMPO THEN DO:
               CREATE TEMPO.
               ASSIGN TEMPO.TIPO = "DECS" .
              END.
                               
                 CAJA[1] = CAJA[1] + CCBDECL.ImpNac[1] .
                 CAJA[2] = CAJA[2] + CCBDECL.ImpNac[2] .
                 CAJA[3] = CAJA[3] + CCBDECL.ImpNac[3] .
                 CAJA[4] = CAJA[4] + CCBDECL.ImpNac[4] .
                 CAJA[5] = CAJA[5] + CCBDECL.ImpNac[5] .
                 CAJA[6] = CAJA[6] + CCBDECL.ImpNac[6] .
                 CAJA[7] = CAJA[7] + CCBDECL.ImpNac[7] .
                 CAJA[10] = CAJA[10] + CCBDECL.ImpNac[1] .

                            
              FIND TEMPO where tempo.tipo = "DECD" NO-LOCK NO-ERROR.
              IF NOT AVAILABLE TEMPO THEN DO:
               CREATE TEMPO.
               ASSIGN TEMPO.TIPO = "DECD" .
              END.
              
                  CAJA[1] = CAJA[1] + CCBDECL.ImpUsa[1] .
                  CAJA[2] = CAJA[2] + CCBDECL.ImpUsa[2] .
                  CAJA[3] = CAJA[3] + CCBDECL.ImpUsa[3] .
                  CAJA[4] = CAJA[4] + CCBDECL.ImpUsa[4] .
                  CAJA[5] = CAJA[5] + CCBDECL.ImpUsa[5] .
                  CAJA[6] = CAJA[6] + CCBDECL.ImpUsa[6] .
                  CAJA[7] = CAJA[7] + CCBDECL.ImpUsa[7] .
                  CAJA[10] = CAJA[10] + CCBDECL.ImpUsa[1] .
                         
            
              S-DCEFES = S-DCEFES + CCBDECL.IMPNAC[1].
              S-DCCHQS = S-DCCHQS + CCBDECL.IMPNAC[2].
              S-DCCHQDS = S-DCCHQDS + CCBDECL.IMPNAC[3].
              S-DCTARS = S-DCTARS + CCBDECL.IMPNAC[4].
              S-DCDEPS = S-DCDEPS + CCBDECL.IMPNAC[5].
              S-DCPERS = S-DCPERS + CCBDECL.IMPNAC[7].
              S-DCEFED = S-DCEFED + CCBDECL.IMPUSA[1].
              S-DCCHQD = S-DCCHQD + CCBDECL.IMPUSA[2].
              S-DCCHQDD = S-DCCHQDD + CCBDECL.IMPUSA[3].
              S-DCTARD = S-DCTARD + CCBDECL.IMPUSA[4].
              S-DCDEPD = S-DCDEPD + CCBDECL.IMPUSA[5].
              S-DCPERD = S-DCPERD + CCBDECL.IMPUSA[7].
             
            END.                    
            FOR EACH ccbccaja WHERE ccbccaja.codcia = s-codcia 
                               AND  LOOKUP(ccbccaja.coddoc, "I/C,E/C") NE 0 
                               AND  ccbccaja.flgcie = "C" 
                               AND  ccbccaja.fchcie = ccbcierr.fchcie 
                               AND  ccbccaja.horcie = ccbcierr.horcie 
                               AND  ccbccaja.flgest NE "A" 
                               AND  ccbccaja.usuario = ccbcierr.Usuario 
                               NO-LOCK:
              


              XTPOCMB = ccbccaja.Tpocmb.
              
              FIND TEMPO where tempo.tipo = "CJAS" NO-LOCK NO-ERROR.
             
              IF NOT AVAILABLE TEMPO THEN DO:
               CREATE TEMPO.
               ASSIGN TEMPO.TIPO = "CJAS" .
              END.
              
                  
                 CAJA[1] = CAJA[1] + ( ccbccaja.ImpNac[1] * IF ccbccaja.coddoc = "E/C" THEN -1 ELSE 1 ) - ccbccaja.VueNac.
                 CAJA[2] = CAJA[2] + ccbccaja.ImpNac[2] * IF ccbccaja.coddoc = "E/C" THEN -1 ELSE 1.
                 CAJA[3] = CAJA[3] + ccbccaja.ImpNac[3] * IF ccbccaja.coddoc = "E/C" THEN -1 ELSE 1.
                 CAJA[4] = CAJA[4] + ccbccaja.ImpNac[4] * IF ccbccaja.coddoc = "E/C" THEN -1 ELSE 1.
                 CAJA[5] = CAJA[5] + ccbccaja.ImpNac[5] * IF ccbccaja.coddoc = "E/C" THEN -1 ELSE 1.
                 CAJA[6] = CAJA[6] + ccbccaja.ImpNac[6] * IF ccbccaja.coddoc = "E/C" THEN -1 ELSE 1.
                 CAJA[7] = CAJA[7] + ccbccaja.ImpNac[7] * IF ccbccaja.coddoc = "E/C" THEN -1 ELSE 1.
                 CAJA[10] = CAJA[10] + ( ccbccaja.ImpNac[1] * IF ccbccaja.coddoc = "E/C" THEN -1 ELSE 1 ) - ccbccaja.VueNac.
                 CAJA[9] = CAJA[9] + ccbccaja.VueNac    * IF ccbccaja.coddoc = "E/C" THEN -1 ELSE 1.
                            
              FIND TEMPO where tempo.tipo = "CJAD" NO-LOCK NO-ERROR.
              IF NOT AVAILABLE TEMPO THEN DO:
               CREATE TEMPO.
               ASSIGN TEMPO.TIPO = "CJAD" .
              END.
              
                  CAJA[1] = CAJA[1] + ( ccbccaja.ImpUsa[1] * IF ccbccaja.coddoc = "E/C" THEN -1 ELSE 1 ) - ccbccaja.VueUsa.
                  CAJA[2] = CAJA[2] + ccbccaja.ImpUsa[2] * IF ccbccaja.coddoc = "E/C" THEN -1 ELSE 1.
                  CAJA[3] = CAJA[3] + ccbccaja.ImpUsa[3] * IF ccbccaja.coddoc = "E/C" THEN -1 ELSE 1.
                  CAJA[4] = CAJA[4] + ccbccaja.ImpUsa[4] * IF ccbccaja.coddoc = "E/C" THEN -1 ELSE 1.
                  CAJA[5] = CAJA[5] + ccbccaja.ImpUsa[5] * IF ccbccaja.coddoc = "E/C" THEN -1 ELSE 1.
                  CAJA[6] = CAJA[6] + ccbccaja.ImpUsa[6] * IF ccbccaja.coddoc = "E/C" THEN -1 ELSE 1.
                  CAJA[7] = CAJA[7] + ccbccaja.ImpUsa[7] * IF ccbccaja.coddoc = "E/C" THEN -1 ELSE 1.
                  CAJA[10] = CAJA[10] + ( ccbccaja.ImpUsa[1] * IF ccbccaja.coddoc = "E/C" THEN -1 ELSE 1 ) - ccbccaja.VueUsa .
                  CAJA[9] = CAJA[9] + ccbccaja.VueUsa    * IF ccbccaja.coddoc = "E/C" THEN -1 ELSE 1.
              
              
              FIND TEMPO where tempo.tipo = ccbccaja.tipo NO-LOCK NO-ERROR. 
              IF NOT AVAILABLE TEMPO OR  ccbccaja.tipo = "REMESAS" OR
                                         ccbccaja.tipo = "DEVO" OR 
                                         ccbccaja.tipo = "CAMB" THEN DO:
               CREATE TEMPO.
               ASSIGN TEMPO.TIPO   = ccbccaja.tipo
                      TEMPO.CODDOC = ccbccaja.coddoc
                      TEMPO.NRODOC = ccbccaja.nrodoc
                      TEMPO.GLOSA  = ccbccaja.glosa.     
              END.
              /*********** Solo por Compra/Venta Dolares**********/
              IF ccbccaja.tipo = "CAMB" THEN DO:
                TEMPO.TOTDOL = Ccbccaja.Importe.
                TEMPO.TIPO   = IF ccbccaja.CODMON = 1 THEN "CAMB1"  ELSE "CAMB2". 

              END.
              /**********************************************/
              FOR EACH ccbdcaja of ccbccaja: 
                  IF TEMPO.TIPO = "CAFA" OR TEMPO.TIPO = "CABO" THEN DO:
                    FIND CCBCDOCU WHERE CCBCDOCU.CODCIA = 1 AND
                                        CCBCDOCU.CODDOC = CCBDCAJA.CODREF AND
                                        CCBCDOCU.NRODOC = CCBDCAJA.NROREF NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE CCBCDOCU OR CCBCDOCU.FLGEST = "A" THEN NEXT.                                           
                  END.
                  TEMPO.TOTSOL = TEMPO.TOTSOL + IF ccbdcaja.CODMON = 1 THEN ccbdcaja.imptot ELSE 0. 
                  TEMPO.TOTDOL = TEMPO.TOTDOL + IF ccbdcaja.CODMON = 2 THEN ccbdcaja.imptot ELSE 0. 
                  
                  IF TEMPO.TIPO = "CFAC" THEN DO:
                     IF CCBDCAJA.CODREF = "N/D" THEN DO:
                       TEMPO.TOTSOLND = TEMPO.TOTSOLND + IF ccbdcaja.CODMON = 1 THEN ccbdcaja.imptot ELSE 0. 
                       TEMPO.TOTDOLND = TEMPO.TOTDOLND + IF ccbdcaja.CODMON = 2 THEN ccbdcaja.imptot ELSE 0. 
                     END.
                     IF CCBDCAJA.CODREF = "LET" OR 
                        CCBDCAJA.CODREF = "FAC" OR
                        CCBDCAJA.CODREF = "BOL" THEN DO:
                       FIND CCBCDOCU WHERE CCBCDOCU.CODCIA = 1 AND
                                           CCBCDOCU.CODDOC = CCBDCAJA.CODREF AND
                                           CCBCDOCU.NRODOC = CCBDCAJA.NROREF NO-LOCK NO-ERROR.
                        IF AVAILABLE CCBCDOCU THEN DO:                                           
                           IF LOOKUP(TRIM(CCBCDOCU.FMAPGO), "000,001,002") > 0 THEN DO:
                               TEMPO.TOTSOLCE = TEMPO.TOTSOLCE + IF ccbdcaja.CODMON = 1 THEN ccbdcaja.imptot ELSE 0. 
                               TEMPO.TOTDOLCE = TEMPO.TOTDOLCE + IF ccbdcaja.CODMON = 2 THEN ccbdcaja.imptot ELSE 0. 
                           END.
                           ELSE DO:
                               TEMPO.TOTSOLCR = TEMPO.TOTSOLCR + IF ccbdcaja.CODMON = 1 THEN ccbdcaja.imptot ELSE 0. 
                               TEMPO.TOTDOLCR = TEMPO.TOTDOLCR + IF ccbdcaja.CODMON = 2 THEN ccbdcaja.imptot ELSE 0.                       
                           END.
                       END.
                     END.
                  END.
              END.
            END.
         END.
    END.
  END.
  FOR EACH TEMPO:
      xnombre = "Otros    ".
      CASE TEMPO.TIPO:
       WHEN "CFAC" THEN xnombre = "Cobranzas Creditos".
       WHEN "CAFA" THEN xnombre = "Facturas          ".
       WHEN "CABO" THEN xnombre = "Boletas        ".
       WHEN "REMESAS" THEN xnombre = "Remesas     ".
       WHEN "DEVO" THEN xnombre = "Devoluciones  ".
       WHEN "CAMB1" THEN xnombre = "Venta ME ".
       WHEN "CAMB2" THEN xnombre = "Compra ME ".
      END CASE.
      IF s-task-no = 0
        THEN REPEAT:
        s-task-no = RANDOM(1, 999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no 
                                        AND  w-report.Llave-C = s-user-id 
                                        NO-LOCK)
                                        THEN LEAVE.
      END.
      CREATE w-report.
      ASSIGN
          w-report.Task-No = s-task-no
          w-report.Llave-C = s-user-id
          w-report.Campo-C[1] = TEMPO.TIPO 
          w-report.Campo-C[2] = TEMPO.CODDOC
          w-report.Campo-C[3] = XNOMBRE
          w-report.Campo-F[1] = TEMPO.CAJA[1]
          w-report.Campo-F[2] = TEMPO.CAJA[2]
          w-report.Campo-F[3] = TEMPO.CAJA[3]
          w-report.Campo-F[4] = TEMPO.CAJA[4]
          w-report.Campo-F[5] = TEMPO.CAJA[5]
          w-report.Campo-F[6] = TEMPO.CAJA[6]
          w-report.Campo-F[7] = TEMPO.CAJA[7]
          w-report.Campo-F[10] = IF TEMPO.TIPO = "DECD" OR TEMPO.TIPO = "CJAD" THEN TEMPO.CAJA[10] * XTPOCMB ELSE TEMPO.CAJA[10] 
          w-report.Campo-F[9] = TEMPO.CAJA[9]
          w-report.Campo-F[11] = IF TEMPO.TIPO <> "CFAC" THEN TEMPO.TOTSOL ELSE TEMPO.TOTSOLCR
          w-report.Campo-F[12] = IF TEMPO.TIPO <> "CFAC" THEN TEMPO.TOTDOL ELSE TEMPO.TOTDOLCR.
          IF TEMPO.TIPO = "REMESAS" THEN  w-report.Campo-C[4] = TEMPO.CODDOC + " " + TEMPO.NRODOC + " " + TEMPO.GLOSA.
          IF TEMPO.TIPO = "CFAC" THEN DO :
             IF TEMPO.TOTSOLCE + TEMPO.TOTDOLCE <> 0 THEN DO:
               xnombre = "Cobranzas C/Entrega".
               CREATE w-report.
               ASSIGN
                w-report.Task-No = s-task-no
                w-report.Llave-C = s-user-id
                w-report.Campo-C[1] = TEMPO.TIPO 
                w-report.Campo-C[2] = "I/C" 
                w-report.Campo-C[3] = XNOMBRE
                w-report.Campo-F[11] = TEMPO.TOTSOLCE
                w-report.Campo-F[12] = TEMPO.TOTDOLCE.
             END.
             IF TEMPO.TOTSOLND + TEMPO.TOTDOLND <> 0 THEN DO:
               xnombre = "Cobranzas N/Debito".
               CREATE w-report.
               ASSIGN
                w-report.Task-No = s-task-no
                w-report.Llave-C = s-user-id
                w-report.Campo-C[2] = "I/C" 
                w-report.Campo-C[1] = TEMPO.TIPO 
                w-report.Campo-C[3] = XNOMBRE
                w-report.Campo-F[11] = TEMPO.TOTSOLND
                w-report.Campo-F[12] = TEMPO.TOTDOLND.
             END.


          END. 
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY X-FchCie 
      WITH FRAME D-Dialog.
  ENABLE RECT-1 RECT-2 RECT-3 X-FchCie Btn_OK Btn_Cancel BROWSE-2 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir D-Dialog 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
  /* LOGICA PRINCIPAL */
  /* Pantalla general de parametros de impresion */
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.

  RUN Carga-Temporal.
  FIND FIRST w-report WHERE w-report.task-no = s-task-no 
                       AND  w-report.Llave-C = s-user-id 
                      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE w-report
  THEN DO:
      MESSAGE "Fin de archivo" VIEW-AS ALERT-BOX WARNING.
      RETURN.
  END.
  /* test de impresion */
  s-titulo = "REPORTE DE CIERRE DE CAJA DEL " + STRING(X-FchCie,"99/99/9999").
  RB-INCLUDE-RECORDS = "O".
  RB-FILTER = "w-report.task-no = " + STRING(s-task-no) +
                " AND w-report.Llave-C = '" + s-user-id + "'".  
  RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia +
                        "~ns-titulo = " + s-titulo +
                        "~ns-subtit = " + s-subtit +
                        "~ns-horcie = " + s-horcie + 
                        "~ns-divi   = " + s-divi   +
                        "~ns-dcefes = " + string(s-dcefes,">,>>>,>>9.99") + 
                        "~ns-dcefed = " + string(s-dcefed,">,>>>,>>9.99") + 
                        "~ns-dcchqs = " + string(s-dcchqs,">,>>>,>>9.99") + 
                        "~ns-dcchqd = " + string(s-dcchqd,">,>>>,>>9.99") + 
                        "~ns-dcchqds = " + string(s-dcchqds,">,>>>,>>9.99") + 
                        "~ns-dcchqdd = " + string(s-dcchqdd,">,>>>,>>9.99") + 
                        "~ns-dcdeps = " + string(s-dcdeps,">,>>>,>>9.99") + 
                        "~ns-dcdepd = " + string(s-dcdepd,">,>>>,>>9.99") + 
                        "~ns-dctars = " + string(s-dctars,">,>>>,>>9.99") + 
                        "~ns-dctard = " + string(s-dctard,">,>>>,>>9.99") + 
                        "~ns-dcpers = " + string(s-dcpers,">,>>>,>>9.99") + 
                        "~ns-dcperd = " + string(s-dcperd,">,>>>,>>9.99") + 
                        "~nxtpocmb  = " + string(xtpocmb,">>,>>9.9999").
  /* Captura parametros de impresion */
  ASSIGN
      RB-BEGIN-PAGE = s-pagina-inicial
      RB-END-PAGE = s-pagina-final
      RB-PRINTER-NAME = s-printer-name
      RB-OUTPUT-FILE = s-print-file
      RB-NUMBER-COPIES = s-nro-copias.
  CASE s-salida-impresion:
      WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
      WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
      WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
  END CASE.
  
  RUN aderb/_printrb (RB-REPORT-LIBRARY,
                      RB-REPORT-NAME,
                      RB-DB-CONNECTION,
                      RB-INCLUDE-RECORDS,
                      RB-FILTER,
                      RB-MEMO-FILE,
                      RB-PRINT-DESTINATION,
                      RB-PRINTER-NAME,
                      RB-PRINTER-PORT,
                      RB-OUTPUT-FILE,
                      RB-NUMBER-COPIES,
                      RB-BEGIN-PAGE,
                      RB-END-PAGE,
                      RB-TEST-PATTERN,
                      RB-WINDOW-TITLE,
                      RB-DISPLAY-ERRORS,
                      RB-DISPLAY-STATUS,
                      RB-NO-WAIT,
                      RB-OTHER-PARAMETERS).    
    
  FOR EACH w-report WHERE w-report.task-no = s-task-no 
      AND  w-report.Llave-C = s-user-id:
      DELETE w-report.                  
  END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN x-fchcie:SCREEN-VALUE IN FRAME D-Dialog = STRING(TODAY).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "CcbCierr"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


