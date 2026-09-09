&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR CB-CODCIA AS INTEGER.
DEFINE SHARED VAR S-PERIODO AS INTEGER.
DEFINE SHARED VAR S-NROMES  AS INTEGER.
DEFINE SHARED VAR s-user-id AS CHARACTER.
DEFINE SHARED VAR cl-codcia AS INTEGER.
DEFINE SHARED VAR pv-codcia AS INTEGER.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VARIABLE X-NROAST AS INTEGER NO-UNDO.
DEFINE VARIABLE X-NroItm AS INTEGER NO-UNDO.
DEFINE VARIABLE R-ROWID  AS ROWID NO-UNDO.
DEFINE VARIABLE R-ANTCPO AS ROWID NO-UNDO.   /* para el control de anticipos */
DEFINE VARIABLE C-AUXCCH AS CHAR NO-UNDO.    /* PARA EL CONTROL DE CAJA CHICA */
DEFINE VARIABLE L-CREA   AS LOGICAL NO-UNDO.
DEFINE VARIABLE F-NroDoc AS CHAR NO-UNDO.
DEFINE VARIABLE X-NOMAUX AS CHAR FORMAT "X(60)" NO-UNDO.
DEFINE VARIABLE X-Condic AS CHAR FORMAT "X(30)" NO-UNDO.
DEFINE VARIABLE F-DesOpe AS CHAR FORMAT "X(30)" NO-UNDO.
DEFINE VARIABLE x-difer  AS DECIMAL NO-UNDO.

DEFINE VARIABLE O-TIPO AS INTEGER.
DEFINE VARIABLE O-PAR1 AS DECIMAL.
     
DEFINE VARIABLE x-DbeSol AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-HbeSol AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-SdoSol AS DECIMAL NO-UNDO.

DEFINE VARIABLE x-DbeDol AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-HbeDol AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-SdoDol AS DECIMAL NO-UNDO.

DEFINE VARIABLE L-MesCie AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE L-MesPre AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE x-codcta AS CHAR    NO-UNDO.

DEFINE VARIABLE x-totafe1 AS DECIMAL NO-UNDO. /* Control de ingresos de almacen  S/. */
DEFINE VARIABLE x-totexo1 AS DECIMAL NO-UNDO. /* Control de ingresos de almacen  S/. */
DEFINE VARIABLE x-totafe2 AS DECIMAL NO-UNDO. /* Control de ingresos de almacen  US$ */
DEFINE VARIABLE x-totexo2 AS DECIMAL NO-UNDO. /* Control de ingresos de almacen  US$ */
DEFINE VARIABLE x-guialm  AS CHAR    NO-UNDO. /* Control de ingresos de almacen      */

FIND cb-peri WHERE  
     cb-peri.CodCia  = s-codcia  AND
     cb-peri.Periodo = s-periodo NO-LOCK.
IF AVAILABLE cb-peri THEN DO:
   L-MesCie = cb-peri.MesCie[s-NroMes + 1].
   L-MesPre = cb-peri.MesPre[s-NroMes + 1].
END.

FIND cb-cfga WHERE cb-cfga.CodCia = cb-codcia AND 
                   cb-cfga.CodCfg = 01 NO-LOCK  NO-ERROR.
IF NOT AVAILABLE cb-cfga THEN DO:
   MESSAGE "No se encuentra registradas las Configuraciones Generales "
           VIEW-AS ALERT-BOX INFORMATION.
   RETURN.        
END.                   

DEFINE TEMP-TABLE RMOV NO-UNDO LIKE cb-dmov.
DEFINE BUFFER DETALLE  FOR RMOV.
DEFINE BUFFER ASTOS    FOR CBDASTOS.
DEFINE STREAM REPORT.

DEFINE VARIABLE CTAS-REDONDEO AS CHAR.
FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
     cb-cfgg.Codcfg = "RND" NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfgg THEN
   FIND cb-cfgg WHERE cb-cfgg.CodCia = S-CodCia AND
        cb-cfgg.Codcfg = "RND" NO-LOCK NO-ERROR.
CTAS-REDONDEO = cb-cfgg.codcta[1] + "," + cb-cfgg.codcta[2].

DEFINE VARIABLE CTAS-Diferencia AS CHAR.
FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
        cb-cfgg.Codcfg = "C01" NO-LOCK NO-ERROR.
IF NOT AVAILABLE cb-cfgg THEN
   FIND cb-cfgg WHERE cb-cfgg.CodCia = S-CodCia AND
        cb-cfgg.Codcfg = "C01" NO-LOCK NO-ERROR.
CTAS-Diferencia = cb-cfgg.codcta[1] + "," + cb-cfgg.codcta[2].

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CBDASTOS cb-cmdlo
&Scoped-define FIRST-EXTERNAL-TABLE CBDASTOS


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CBDASTOS, cb-cmdlo.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CBDASTOS.Notast CBDASTOS.Fchast ~
CBDASTOS.Tpocmb CBDASTOS.Codaux CBDASTOS.Codmon CBDASTOS.cco ~
CBDASTOS.Nroruc CBDASTOS.Coddoc CBDASTOS.serdoc CBDASTOS.Nrodoc ~
CBDASTOS.Fchdoc CBDASTOS.Codref CBDASTOS.SerRef CBDASTOS.plazo ~
CBDASTOS.Nroref CBDASTOS.OrdCmp CBDASTOS.Fchvto CBDASTOS.CndCmp ~
CBDASTOS.DisCCo CBDASTOS.C1 CBDASTOS.C2 CBDASTOS.C3 CBDASTOS.C4 CBDASTOS.C5 ~
CBDASTOS.C6 CBDASTOS.V1 CBDASTOS.V2 CBDASTOS.V3 CBDASTOS.V4 CBDASTOS.V5 ~
CBDASTOS.V6 CBDASTOS.V7 CBDASTOS.V8 CBDASTOS.V9 CBDASTOS.V0 
&Scoped-define ENABLED-TABLES CBDASTOS
&Scoped-define FIRST-ENABLED-TABLE CBDASTOS
&Scoped-Define ENABLED-OBJECTS RECT-11 RECT-10 RECT-4 RECT-1 
&Scoped-Define DISPLAYED-FIELDS CBDASTOS.Nroast CBDASTOS.Notast ~
CBDASTOS.Fchast CBDASTOS.CodDiv CBDASTOS.Tpocmb cb-cmdlo.Referencia[7] ~
CBDASTOS.Codaux CBDASTOS.Codmon cb-cmdlo.Referencia[8] CBDASTOS.cco ~
CBDASTOS.Nroruc CBDASTOS.Coddoc CBDASTOS.serdoc CBDASTOS.Nrodoc ~
CBDASTOS.Fchdoc cb-cmdlo.Referencia[9] CBDASTOS.Codref CBDASTOS.SerRef ~
CBDASTOS.plazo CBDASTOS.Nroref cb-cmdlo.Referencia[10] CBDASTOS.OrdCmp ~
CBDASTOS.Fchvto CBDASTOS.CndCmp CBDASTOS.DisCCo cb-cmdlo.Referencia[1] ~
CBDASTOS.C1 cb-cmdlo.Referencia[2] CBDASTOS.C2 cb-cmdlo.Referencia[3] ~
CBDASTOS.C3 cb-cmdlo.Referencia[4] CBDASTOS.C4 cb-cmdlo.Referencia[5] ~
CBDASTOS.C5 cb-cmdlo.Referencia[6] CBDASTOS.C6 cb-cmdlo.Concepto[1] ~
CBDASTOS.V1 cb-cmdlo.Concepto[2] CBDASTOS.V2 cb-cmdlo.Concepto[3] ~
CBDASTOS.V3 cb-cmdlo.Concepto[4] CBDASTOS.V4 cb-cmdlo.Concepto[5] ~
CBDASTOS.V5 cb-cmdlo.Concepto[6] CBDASTOS.V6 cb-cmdlo.Concepto[7] ~
CBDASTOS.V7 cb-cmdlo.Concepto[8] CBDASTOS.V8 cb-cmdlo.Concepto[9] ~
CBDASTOS.V9 cb-cmdlo.Concepto[10] CBDASTOS.V0 
&Scoped-define DISPLAYED-TABLES CBDASTOS cb-cmdlo
&Scoped-define FIRST-DISPLAYED-TABLE CBDASTOS
&Scoped-define SECOND-DISPLAYED-TABLE cb-cmdlo
&Scoped-Define DISPLAYED-OBJECTS F-DesDiv F-NOMAUX F-DesCCt F-DesCon 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD VALOR-C V-table-Win 
FUNCTION VALOR-C RETURNS CHARACTER
  ( INPUT I-PAR AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD VALOR-F V-table-Win 
FUNCTION VALOR-F RETURNS DECIMAL
  ( INPUT O-TIPO AS INTEGER,
    INPUT FORMULA AS CHAR  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD VALOR-SCREEN V-table-Win 
FUNCTION VALOR-SCREEN RETURNS DECIMAL
  ( INPUT I-PAR AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD VALOR-V V-table-Win 
FUNCTION VALOR-V RETURNS DECIMAL
  ( INPUT I-PAR AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE F-DesCCt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30.14 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesCon AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesDiv AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-NOMAUX AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.29 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 2.54.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 6.42.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 12.29 BY .69.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81 BY 3.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CBDASTOS.Nroast AT ROW 1.19 COL 12 COLON-ALIGNED
          LABEL "Numero Asiento"
          VIEW-AS FILL-IN 
          SIZE 7.29 BY .69
     CBDASTOS.Notast AT ROW 1.19 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 33.29 BY .69
     CBDASTOS.Fchast AT ROW 1.19 COL 66.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CBDASTOS.CodDiv AT ROW 1.96 COL 12 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7.29 BY .69
     F-DesDiv AT ROW 1.96 COL 22 COLON-ALIGNED NO-LABEL
     CBDASTOS.Tpocmb AT ROW 1.96 COL 66.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     cb-cmdlo.Referencia[7] AT ROW 2.69 COL 1.57 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     CBDASTOS.Codaux AT ROW 2.69 COL 12 COLON-ALIGNED NO-LABEL FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     F-NOMAUX AT ROW 2.69 COL 22 COLON-ALIGNED NO-LABEL
     CBDASTOS.Codmon AT ROW 2.81 COL 69.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.43 BY .5
     cb-cmdlo.Referencia[8] AT ROW 3.65 COL 1.57 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     CBDASTOS.cco AT ROW 3.65 COL 12 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6.29 BY .69
     F-DesCCt AT ROW 3.65 COL 19.86 COLON-ALIGNED NO-LABEL
     CBDASTOS.Nroruc AT ROW 3.65 COL 66 COLON-ALIGNED FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .69
     CBDASTOS.Coddoc AT ROW 4.42 COL 12 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .69
     CBDASTOS.serdoc AT ROW 4.42 COL 21.86 COLON-ALIGNED FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 4.14 BY .69
     CBDASTOS.Nrodoc AT ROW 4.42 COL 30 COLON-ALIGNED
          LABEL "No." FORMAT "x(20)"
          VIEW-AS FILL-IN 
          SIZE 17 BY .69
     CBDASTOS.Fchdoc AT ROW 4.42 COL 66 COLON-ALIGNED
          LABEL "Fecha de Documento"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     cb-cmdlo.Referencia[9] AT ROW 5.19 COL 1.57 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     CBDASTOS.Codref AT ROW 5.19 COL 12 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .69
     CBDASTOS.SerRef AT ROW 5.19 COL 21.86 COLON-ALIGNED FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 4.14 BY .69
     CBDASTOS.plazo AT ROW 5.19 COL 66 COLON-ALIGNED
          LABEL "Dias"
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .69
     CBDASTOS.Nroref AT ROW 5.23 COL 32 NO-LABEL FORMAT "X(30)":U
          VIEW-AS FILL-IN 
          SIZE 18.72 BY .69
     cb-cmdlo.Referencia[10] AT ROW 5.96 COL 1.57 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .69
     CBDASTOS.OrdCmp AT ROW 5.96 COL 12 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     CBDASTOS.Fchvto AT ROW 5.96 COL 66 COLON-ALIGNED
          LABEL "Fecha de Vencimiento"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     CBDASTOS.CndCmp AT ROW 6.73 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .69
     F-DesCon AT ROW 6.73 COL 19 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     CBDASTOS.DisCCo AT ROW 6.73 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.14 BY .69
     cb-cmdlo.Referencia[1] AT ROW 7.54 COL 2.43 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     CBDASTOS.C1 AT ROW 7.54 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .69
     cb-cmdlo.Referencia[2] AT ROW 7.54 COL 40.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     CBDASTOS.C2 AT ROW 7.54 COL 62.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .69
     cb-cmdlo.Referencia[3] AT ROW 8.27 COL 2.43 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     CBDASTOS.C3 AT ROW 8.27 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .69
     cb-cmdlo.Referencia[4] AT ROW 8.27 COL 40.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     CBDASTOS.C4 AT ROW 8.27 COL 62.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .69
     cb-cmdlo.Referencia[5] AT ROW 8.96 COL 2.43 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     CBDASTOS.C5 AT ROW 8.96 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .69
     cb-cmdlo.Referencia[6] AT ROW 8.96 COL 40.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     CBDASTOS.C6 AT ROW 8.96 COL 62.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .69
     cb-cmdlo.Concepto[1] AT ROW 10.08 COL 2.43 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     CBDASTOS.V1 AT ROW 10.08 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .69
     cb-cmdlo.Concepto[2] AT ROW 10.08 COL 40.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     CBDASTOS.V2 AT ROW 10.08 COL 62.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .69
     cb-cmdlo.Concepto[3] AT ROW 10.77 COL 2.43 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     CBDASTOS.V3 AT ROW 10.77 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .69
     cb-cmdlo.Concepto[4] AT ROW 10.77 COL 40.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     CBDASTOS.V4 AT ROW 10.77 COL 62.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .69
     cb-cmdlo.Concepto[5] AT ROW 11.46 COL 2.43 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     CBDASTOS.V5 AT ROW 11.46 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .69
     cb-cmdlo.Concepto[6] AT ROW 11.46 COL 40.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     CBDASTOS.V6 AT ROW 11.46 COL 62.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .69
     cb-cmdlo.Concepto[7] AT ROW 12.15 COL 2.43 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     CBDASTOS.V7 AT ROW 12.15 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .69
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     cb-cmdlo.Concepto[8] AT ROW 12.15 COL 40.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     CBDASTOS.V8 AT ROW 12.15 COL 62.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .69
     cb-cmdlo.Concepto[9] AT ROW 12.88 COL 2.43 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     CBDASTOS.V9 AT ROW 12.88 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .69
     cb-cmdlo.Concepto[10] AT ROW 12.88 COL 40.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .69
     CBDASTOS.V0 AT ROW 12.88 COL 62.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 15 BY .69
     "Tipo de Cambio" VIEW-AS TEXT
          SIZE 10.86 BY .5 AT ROW 2.08 COL 57.57
     "Moneda :" VIEW-AS TEXT
          SIZE 6.86 BY .5 AT ROW 2.81 COL 61.57
     "No." VIEW-AS TEXT
          SIZE 3 BY .5 AT ROW 5.42 COL 28.72
     "Division :" VIEW-AS TEXT
          SIZE 6.86 BY .69 AT ROW 1.96 COL 7
     "Cod.Doc. :" VIEW-AS TEXT
          SIZE 7.72 BY .69 AT ROW 4.42 COL 5.43
     RECT-11 AT ROW 2.69 COL 68.57
     RECT-10 AT ROW 3.46 COL 1
     RECT-4 AT ROW 9.88 COL 1
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.CBDASTOS,integral.cb-cmdlo
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 12.92
         WIDTH              = 81.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CBDASTOS.cco IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CBDASTOS.Codaux IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CBDASTOS.CodDiv IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CBDASTOS.Coddoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CBDASTOS.Codref IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cmdlo.Concepto[10] IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmdlo.Concepto[1] IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN cb-cmdlo.Concepto[2] IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmdlo.Concepto[3] IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN cb-cmdlo.Concepto[4] IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmdlo.Concepto[5] IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN cb-cmdlo.Concepto[6] IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmdlo.Concepto[7] IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN cb-cmdlo.Concepto[8] IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmdlo.Concepto[9] IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-DesCCt IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesCon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NOMAUX IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CBDASTOS.Fchdoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CBDASTOS.Fchvto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CBDASTOS.Nroast IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CBDASTOS.Nrodoc IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CBDASTOS.Nroref IN FRAME F-Main
   ALIGN-L EXP-LABEL EXP-FORMAT                                         */
/* SETTINGS FOR FILL-IN CBDASTOS.Nroruc IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CBDASTOS.OrdCmp IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CBDASTOS.plazo IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN cb-cmdlo.Referencia[10] IN FRAME F-Main
   NO-ENABLE ALIGN-L EXP-LABEL                                          */
/* SETTINGS FOR FILL-IN cb-cmdlo.Referencia[1] IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN cb-cmdlo.Referencia[2] IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmdlo.Referencia[3] IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN cb-cmdlo.Referencia[4] IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmdlo.Referencia[5] IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN cb-cmdlo.Referencia[6] IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-cmdlo.Referencia[7] IN FRAME F-Main
   NO-ENABLE ALIGN-L EXP-LABEL                                          */
/* SETTINGS FOR FILL-IN cb-cmdlo.Referencia[8] IN FRAME F-Main
   NO-ENABLE ALIGN-L EXP-LABEL                                          */
/* SETTINGS FOR FILL-IN cb-cmdlo.Referencia[9] IN FRAME F-Main
   NO-ENABLE ALIGN-L EXP-LABEL                                          */
/* SETTINGS FOR FILL-IN CBDASTOS.serdoc IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CBDASTOS.SerRef IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CBDASTOS.Tpocmb IN FRAME F-Main
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME CBDASTOS.cco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CBDASTOS.cco V-table-Win
ON LEAVE OF CBDASTOS.cco IN FRAME F-Main /* C.Costo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND cb-auxi WHERE cb-auxi.CodCia = 0 AND
       cb-auxi.ClfAux = "CCO" AND
       cb-auxi.CodAux = CBDASTOS.cco:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-auxi THEN
  FIND cb-auxi WHERE cb-auxi.CodCia = S-CODCIA AND
       cb-auxi.ClfAux = "CCO" AND
       cb-auxi.CodAux = CBDASTOS.cco:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE CB-AUXI THEN DO:
     MESSAGE "Centro de Costos no registrado" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  DISPLAY cb-auxi.NomAux @ F-DesCCt WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CBDASTOS.CndCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CBDASTOS.CndCmp V-table-Win
ON LEAVE OF CBDASTOS.CndCmp IN FRAME F-Main /* Condicion */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND cb-tabl WHERE cb-tabl.Tabla = "20" AND
       cb-tabl.Codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-tabl THEN DO:
     MESSAGE "Codigo  no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  DISPLAY cb-tabl.Nombre @ F-DesCon WITH FRAME {&FRAME-NAME}.
  x-Condic = F-DesCon:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CBDASTOS.Codaux
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CBDASTOS.Codaux V-table-Win
ON LEAVE OF CBDASTOS.Codaux IN FRAME F-Main /* Aux. */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  CASE cb-cmdlo.ClfAux:
       WHEN "@PV" THEN DO:
            FIND gn-prov WHERE gn-prov.CodCia = 0 AND
                 gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-prov THEN
               FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA AND
                    gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-prov THEN DO:
               MESSAGE "Codigo de auxiliar no registrado" VIEW-AS ALERT-BOX ERROR.
               RETURN NO-APPLY.
            END.
            DISPLAY gn-prov.NomPro @ F-NOMAUX WITH FRAME {&FRAME-NAME}.
            IF gn-prov.RUC <> "" THEN
            DISPLAY gn-prov.RUC @ CBDASTOS.Nroruc WITH FRAME {&FRAME-NAME}.
       END.
       WHEN "@CL" THEN DO:
            FIND gn-clie WHERE gn-clie.CodCia = 0 AND
                 gn-clie.CodCli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-clie THEN
               FIND gn-clie WHERE gn-clie.CodCia = S-CODCIA AND
                    gn-clie.CodCli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-clie THEN DO:
               MESSAGE "Codigo de auxiliar no registrado" VIEW-AS ALERT-BOX ERROR.
               RETURN NO-APPLY.
            END.
            DISPLAY  gn-clie.NomCli @ F-NOMAUX WITH FRAME {&FRAME-NAME}.
            IF gn-clie.Ruc <> "" THEN
            DISPLAY  gn-clie.Ruc @ CBDASTOS.Nroruc WITH FRAME {&FRAME-NAME}.
       END.
       WHEN "@CT"  THEN DO:
            FIND CB-CTAS WHERE CB-CTAS.CodCia = 0 AND
                 CB-CTAS.CodCta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE CB-CTAS THEN 
               FIND CB-CTAS WHERE CB-CTAS.CodCia = S-CODCIA AND
                    CB-CTAS.CodCta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE CB-CTAS THEN DO:
               MESSAGE "Codigo de auxiliar no registrado" VIEW-AS ALERT-BOX ERROR.
               RETURN NO-APPLY.
            END.
            DISPLAY CB-CTAS.NomCta @ F-NOMAUX  WITH FRAME {&FRAME-NAME}.
       END.  
       OTHERWISE DO:
            FIND cb-auxi WHERE cb-auxi.CodCia = 0 AND
                 cb-auxi.ClfAux = cb-cmdlo.ClfAux AND
                 cb-auxi.CodAux = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE cb-auxi THEN
               FIND cb-auxi WHERE cb-auxi.CodCia = S-CODCIA AND
                    cb-auxi.ClfAux = cb-cmdlo.ClfAux AND
                    cb-auxi.CodAux = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE CB-AUXI THEN DO:
               MESSAGE "Codigo de auxiliar no registrado" VIEW-AS ALERT-BOX ERROR.
               RETURN NO-APPLY.
            END.
            DISPLAY cb-auxi.NomAux @ F-NomAux WITH FRAME {&FRAME-NAME}.
       END.
  END CASE.
  X-NOMAUX  = F-NomAux:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CBDASTOS.Codaux V-table-Win
ON MOUSE-SELECT-DBLCLICK OF CBDASTOS.Codaux IN FRAME F-Main /* Aux. */
OR F8 OF CBDASTOS.CodAux
DO:
  output-var-1 = ?.
  output-var-2 = "".
  CASE cb-cmdlo.Clfaux:
       WHEN "@PV" THEN DO:
            RUN CBD\C-PROVEE("Maestro de Proveedores").
       END.
       WHEN "@CL" THEN DO:
            RUN CBD\C-CLIENT("Maestro de Clientes").
       END.
       OTHERWISE DO:
            input-var-1 = cb-cmdlo.Clfaux.
            RUN CBD\C-AUXIL("Maestro de Auxiliares").
       END.
  END CASE.
  IF output-var-1 NE ?  THEN
     DISPLAY output-var-2 @ CBDASTOS.CodAux WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CBDASTOS.CodDiv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CBDASTOS.CodDiv V-table-Win
ON LEAVE OF CBDASTOS.CodDiv IN FRAME F-Main /* Div. */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA AND
       GN-DIVI.CodDiv = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE GN-DIVI THEN DO:
     MESSAGE "Punto de Venta no Registrado" VIEW-AS ALERT-BOX.
     SELF:SCREEN-VALUE = "".
     RETURN NO-APPLY.
  END.
  DISPLAY GN-DIVI.DesDiv @ F-DesDiv WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CBDASTOS.Coddoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CBDASTOS.Coddoc V-table-Win
ON LEAVE OF CBDASTOS.Coddoc IN FRAME F-Main /* Cod!Doc */
DO:
  IF CBDASTOS.CodDoc:SCREEN-VALUE = "" THEN RETURN.
  FIND cb-tabl WHERE cb-tabl.Tabla = "02" AND
       cb-tabl.Codigo = CBDASTOS.CodDoc:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-tabl THEN DO:
     MESSAGE "Codigo de documento no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CBDASTOS.Codref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CBDASTOS.Codref V-table-Win
ON LEAVE OF CBDASTOS.Codref IN FRAME F-Main /* Cod!Ref */
DO:
  IF CBDASTOS.CodRef:SCREEN-VALUE = "" THEN DO:
     CBDASTOS.SerRef:SENSITIVE = NO.
     CBDASTOS.NroRef:SENSITIVE = NO.
     RETURN.
  END.
  CBDASTOS.SerRef:SENSITIVE = YES.
  CBDASTOS.NroRef:SENSITIVE = YES.
  FIND cb-tabl WHERE cb-tabl.Tabla = "02" AND
       cb-tabl.Codigo = CBDASTOS.CodRef:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-tabl THEN DO:
     MESSAGE "Codigo de documento no existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  IF CBDASTOS.C1:VISIBLE = YES AND 
     (cb-cmdlo.codmod = 150 OR Cb-cmdlo.codmod = 151) THEN
     DISPLAY 
        CBDASTOS.CodRef:SCREEN-VALUE @ CBDASTOS.C1 WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CBDASTOS.Fchast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CBDASTOS.Fchast V-table-Win
ON LEAVE OF CBDASTOS.Fchast IN FRAME F-Main /* Fecha */
DO:
  IF INPUT CBDASTOS.FchAst = ? THEN RETURN.
  IF INPUT CBDASTOS.Fchdoc = ? THEN DO:
     FIND gn-tcmb WHERE gn-tcmb.FECHA = INPUT CBDASTOS.FchAst NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN DO :
        IF cb-oper.TpoCmb = 1 THEN 
           DISPLAY gn-tcmb.Compra @ CBDASTOS.TpoCmb WITH FRAME {&FRAME-NAME}.
        ELSE DISPLAY gn-tcmb.Venta @ CBDASTOS.TpoCmb WITH FRAME {&FRAME-NAME}.
     END.
     ELSE MESSAGE "Tipo de cambio no registrado" VIEW-AS ALERT-BOX WARNING.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CBDASTOS.Fchdoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CBDASTOS.Fchdoc V-table-Win
ON LEAVE OF CBDASTOS.Fchdoc IN FRAME F-Main /* Fecha de Documento */
DO:
  IF INPUT CBDASTOS.FchDoc = ? THEN RETURN.
  CBDASTOS.FchVto:SCREEN-VALUE = SELF:SCREEN-VALUE.
  FIND gn-tcmb WHERE gn-tcmb.FECHA = INPUT CBDASTOS.FchDoc NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN DO :
     IF cb-oper.TpoCmb = 1 THEN 
          DISPLAY gn-tcmb.Compra @ CBDASTOS.TpoCmb WITH FRAME {&FRAME-NAME}.
     ELSE DISPLAY gn-tcmb.Venta @ CBDASTOS.TpoCmb WITH FRAME {&FRAME-NAME}.
  END.
  ELSE DO:
       MESSAGE "Tipo de cambio no registrado" VIEW-AS ALERT-BOX WARNING.
       RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CBDASTOS.Nrodoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CBDASTOS.Nrodoc V-table-Win
ON LEAVE OF CBDASTOS.Nrodoc IN FRAME F-Main /* No. */
DO:
  IF CBDASTOS.CodDoc:SCREEN-VALUE NE "" AND SELF:SCREEN-VALUE = "" THEN RETURN NO-APPLY.
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  F-NroDoc = TRIM (CBDASTOS.SerDoc:SCREEN-VALUE) + "-" +
             CBDASTOS.NroDoc:SCREEN-VALUE.
  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" THEN DO:
      FIND FIRST cb-dmov WHERE cb-dmov.CodCia = S-CODCIA AND
          cb-dmov.Periodo = s-Periodo AND 
          cb-dmov.Clfaux = cb-cmdlo.ClfAux AND
          cb-dmov.Codaux = CBDASTOS.CodAux:SCREEN-VALUE AND
          cb-dmov.Coddoc = CBDASTOS.CodDoc:SCREEN-VALUE AND
          cb-dmov.Nrodoc = F-NroDoc NO-LOCK NO-ERROR.
  END.
  ELSE DO:
      FIND FIRST cb-dmov WHERE cb-dmov.CodCia = S-CODCIA AND
          cb-dmov.Periodo = s-Periodo AND 
          cb-dmov.Clfaux = cb-cmdlo.ClfAux AND
          cb-dmov.Codaux = CBDASTOS.CodAux:SCREEN-VALUE AND
          cb-dmov.Coddoc = CBDASTOS.CodDoc:SCREEN-VALUE AND
          cb-dmov.Nrodoc = F-NroDoc AND
          cb-dmov.CodOpe <> CBDASTOS.CodOpe AND
          cb-dmov.NroMes <> CBDASTOS.NroMes AND
          cb-dmov.NroAst <> CBDASTOS.NroAst
          NO-LOCK NO-ERROR.
  END.
  IF AVAILABLE cb-dmov THEN DO:
     IF NOT L-CREA AND AVAILABLE CBDASTOS AND 
            F-NroDoc = TRIM (CBDASTOS.SerDoc) + "-" +
                       CBDASTOS.NroDoc THEN RETURN.
     MESSAGE "Documento ya fue registrado en " SKIP
             "Operacion : " cb-dmov.CodOpe SKIP
             "  Voucher : " cb-dmov.NroAst VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CBDASTOS.Nroref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CBDASTOS.Nroref V-table-Win
ON LEAVE OF CBDASTOS.Nroref IN FRAME F-Main /* Referencia */
DO:
   IF CBDASTOS.C3:VISIBLE = YES AND 
      (cb-cmdlo.codmod = 150 OR Cb-cmdlo.codmod = 151) THEN
      DISPLAY 
          CBDASTOS.SerRef:SCREEN-VALUE + CBDASTOS.NroRef:SCREEN-VALUE @ CBDASTOS.C3 WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CBDASTOS.plazo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CBDASTOS.plazo V-table-Win
ON LEAVE OF CBDASTOS.plazo IN FRAME F-Main /* Dias */
DO:
  CBDASTOS.FchVto:SCREEN-VALUE = STRING(INPUT CBDASTOS.FchDoc + INPUT CBDASTOS.Plazo).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CBDASTOS.serdoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CBDASTOS.serdoc V-table-Win
ON LEAVE OF CBDASTOS.serdoc IN FRAME F-Main /* Serie */
DO:
  IF CBDASTOS.CodDoc:SCREEN-VALUE NE "" AND SELF:SCREEN-VALUE = "" THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CBDASTOS.SerRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CBDASTOS.SerRef V-table-Win
ON LEAVE OF CBDASTOS.SerRef IN FRAME F-Main /* Serie */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "CBDASTOS"}
  {src/adm/template/row-list.i "cb-cmdlo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CBDASTOS"}
  {src/adm/template/row-find.i "cb-cmdlo"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Detalle V-table-Win 
PROCEDURE Borra-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
     FOR EACH cb-dmov WHERE cb-dmov.CodCia  = CBDASTOS.CodCia  AND
                            cb-dmov.Periodo = CBDASTOS.Periodo AND
                            cb-dmov.NroMes  = CBDASTOS.NroMes  AND
                            cb-dmov.CodOpe  = CBDASTOS.CodOpe  AND
                            cb-dmov.NroAst  = CBDASTOS.NroAst :
         /* Des-actulizando saldos acumulados */ 
         RUN cbd/cb-acmd.p(RECID(cb-dmov), NO , YES).
         /* Borrando el detalle del Documento */ 
         DELETE cb-dmov.
     END.                
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Campos-Visibles V-table-Win 
PROCEDURE Campos-Visibles :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF AVAILABLE cb-cmdlo THEN DO WITH FRAME {&FRAME-NAME}:
    cb-cmdlo.Referencia[1]:VISIBLE = NOT (cb-cmdlo.Referencia[1] = "").
    CBDASTOS.C1:VISIBLE = NOT (cb-cmdlo.Referencia[1] = "").
    cb-cmdlo.Referencia[2]:VISIBLE = NOT (cb-cmdlo.Referencia[2] = "").
    CBDASTOS.C2:VISIBLE = NOT (cb-cmdlo.Referencia[2] = "").
    cb-cmdlo.Referencia[3]:VISIBLE = NOT (cb-cmdlo.Referencia[3] = "").
    CBDASTOS.C3:VISIBLE = NOT (cb-cmdlo.Referencia[3] = "").
    cb-cmdlo.Referencia[4]:VISIBLE = NOT (cb-cmdlo.Referencia[4] = "").
    CBDASTOS.C4:VISIBLE = NOT (cb-cmdlo.Referencia[4] = "").
    cb-cmdlo.Referencia[5]:VISIBLE = NOT (cb-cmdlo.Referencia[5] = "").
    CBDASTOS.C5:VISIBLE = NOT (cb-cmdlo.Referencia[5] = "").
    cb-cmdlo.Referencia[6]:VISIBLE = NOT (cb-cmdlo.Referencia[6] = "").
    CBDASTOS.C6:VISIBLE = NOT (cb-cmdlo.Referencia[6] = "").
    cb-cmdlo.Referencia[9]:VISIBLE = NOT (cb-cmdlo.Referencia[9] = "").
    CBDASTOS.Codref:VISIBLE = NOT (cb-cmdlo.Referencia[9] = "").
    CBDASTOS.SerRef:VISIBLE = NOT (cb-cmdlo.Referencia[9] = "").
    CBDASTOS.Nroref:VISIBLE = NOT (cb-cmdlo.Referencia[9] = "").
    cb-cmdlo.Referencia[10]:VISIBLE = NOT (cb-cmdlo.Referencia[10] = "").
    CBDASTOS.OrdCmp:VISIBLE = NOT (cb-cmdlo.Referencia[10] = "").
    cb-cmdlo.Concepto[1]:VISIBLE = NOT (cb-cmdlo.Concepto[1] = "").
    CBDASTOS.V1:VISIBLE  = NOT (cb-cmdlo.Concepto[1] = "").
    cb-cmdlo.Concepto[2]:VISIBLE = NOT (cb-cmdlo.Concepto[2] = "").
    CBDASTOS.V2:VISIBLE  = NOT (cb-cmdlo.Concepto[2] = "").
    cb-cmdlo.Concepto[3]:VISIBLE = NOT (cb-cmdlo.Concepto[3] = "").
    CBDASTOS.V3:VISIBLE  = NOT (cb-cmdlo.Concepto[3] = "").
    cb-cmdlo.Concepto[4]:VISIBLE = NOT (cb-cmdlo.Concepto[4] = "").
    CBDASTOS.V4:VISIBLE  = NOT (cb-cmdlo.Concepto[4] = "").
    cb-cmdlo.Concepto[5]:VISIBLE = NOT (cb-cmdlo.Concepto[5] = "").
    CBDASTOS.V5:VISIBLE  = NOT (cb-cmdlo.Concepto[5] = "").
    cb-cmdlo.Concepto[6]:VISIBLE = NOT (cb-cmdlo.Concepto[6] = "").
    CBDASTOS.V6:VISIBLE  = NOT (cb-cmdlo.Concepto[6] = "").
    cb-cmdlo.Concepto[7]:VISIBLE = NOT (cb-cmdlo.Concepto[7] = "").
    CBDASTOS.V7:VISIBLE  = NOT (cb-cmdlo.Concepto[7] = "").
    cb-cmdlo.Concepto[8]:VISIBLE = NOT (cb-cmdlo.Concepto[8] = "").
    CBDASTOS.V8:VISIBLE  = NOT (cb-cmdlo.Concepto[8] = "").
    cb-cmdlo.Concepto[9]:VISIBLE = NOT (cb-cmdlo.Concepto[9] = "").
    CBDASTOS.V9:VISIBLE  = NOT (cb-cmdlo.Concepto[9] = "").
    cb-cmdlo.Concepto[10]:VISIBLE = NOT (cb-cmdlo.Concepto[10] = "").
    CBDASTOS.V0:VISIBLE  = NOT (cb-cmdlo.Concepto[10] = "").
    FIND FIRST cb-dmdlo WHERE cb-dmdlo.CodMod = cb-cmdlo.CodMod AND
               cb-dmdlo.Codcta BEGINS "60" NO-LOCK NO-ERROR.
    CBDASTOS.DisCCo:VISIBLE = NOT AVAILABLE cb-dmdlo.
    cb-cmdlo.Referencia[8]:VISIBLE = NOT (cb-cmdlo.Referencia[8] = "") AND NOT AVAILABLE cb-dmdlo.
    CBDASTOS.cco:VISIBLE = NOT (cb-cmdlo.Referencia[8] = "") AND NOT AVAILABLE cb-dmdlo.
    F-DesCCt:VISIBLE = NOT (cb-cmdlo.Referencia[8] = "") AND NOT AVAILABLE cb-dmdlo.
  END.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR C-VALOR AS CHAR.
DEFINE VAR F-VALOR AS DECIMAL.
DEFINE VAR x-rowid AS ROWID.

FOR EACH RMOV: 
    DELETE RMOV.
END.

x-DbeSol = 0.
x-HbeSol = 0.
x-DbeDol = 0.
x-HbeDol = 0.
X-NroItm = 0.
R-ANTCPO = ?.
C-AUXCCH = "".

FOR EACH cb-dmdlo WHERE cb-dmdlo.CodMod = cb-cmdlo.CodMod :
    F-VALOR = VALOR-F(1, cb-dmdlo.Importe).
    IF F-VALOR <= 0 THEN NEXT.    
    CREATE RMOV.    
    X-NroItm = X-NroItm + 1.
    C-VALOR = VALOR-C(cb-dmdlo.CodCta).
    IF INDEX(C-VALOR,"X") > 0 THEN DO:
       C-VALOR = SUBSTRING(C-VALOR,1,INDEX(C-VALOR,"X") - 1) +
                 STRING(CBDASTOS.CodMon,"9") +
                 SUBSTRING(C-VALOR,INDEX(C-VALOR,"X") + 1).
    END.
    x-codcta = C-VALOR.
    
    ASSIGN RMOV.Codcta = C-VALOR.
    
    ASSIGN RMOV.Clfaux = ""
           RMOV.Codaux = ""
           RMOV.Coddoc = ""
           RMOV.Nrodoc = ""
           RMOV.CodRef = ""
           RMOV.Nroref = ""
           RMOV.cco    = ""
           RMOV.DisCCo = 0
           RMOV.NroItm = X-NroItm
           RMOV.CodDiv = CBDASTOS.CodDiv
           RMOV.OrdCmp = CBDASTOS.OrdCmp
           RMOV.TpoMov = cb-dmdlo.TpoMov
           RMOV.tm     = cb-dmdlo.tm
           RMOV.TpoCmb = CBDASTOS.TpoCmb
           RMOV.CodMon = CBDASTOS.CodMon.
    
    C-VALOR = VALOR-C(cb-dmdlo.TpoItm).
    
    ASSIGN RMOV.TpoItm = C-VALOR.
    
    FIND cb-cfga WHERE cb-cfga.CodCia = cb-codcia AND cb-cfga.CodCfg = cb-codcia
    NO-LOCK NO-ERROR.
    
    FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                       cb-ctas.CodCta = RMOV.CodCta NO-LOCK NO-ERROR.
    
    IF cb-ctas.PidAux THEN DO:
       C-VALOR = VALOR-C(cb-dmdlo.Clfaux).
       IF C-VALOR = "" THEN ASSIGN RMOV.Clfaux = cb-ctas.ClfAux.
       ELSE ASSIGN RMOV.Clfaux = C-VALOR.
       
       C-VALOR = VALOR-C(cb-dmdlo.Codaux).
       IF C-VALOR = "" THEN ASSIGN RMOV.Codaux = CBDASTOS.Codaux.
       ELSE ASSIGN RMOV.Codaux = C-VALOR.
       ASSIGN RMOV.Nroruc = CBDASTOS.Nroruc.
       IF RMOV.ClfAux = "CCH" THEN C-AUXCCH = RMOV.CodAux.
    END.
    
    ASSIGN RMOV.Fchdoc = CBDASTOS.Fchdoc 
           RMOV.Fchvto = CBDASTOS.Fchvto.
    IF cb-ctas.PidDoc THEN DO:
       C-VALOR = VALOR-C(cb-dmdlo.Coddoc).
       IF C-VALOR = "" THEN ASSIGN RMOV.Coddoc = CBDASTOS.Coddoc.
       ELSE ASSIGN RMOV.Coddoc = C-VALOR.
       
       C-VALOR = VALOR-C(cb-dmdlo.NroDoc).
       IF C-VALOR = "" THEN 
            ASSIGN RMOV.Nrodoc = TRIM (CBDASTOS.serdoc) + "-" + CBDASTOS.NroDoc.
       ELSE ASSIGN RMOV.Nrodoc = C-VALOR.
       
       ASSIGN RMOV.CndCmp = CBDASTOS.CndCmp
              RMOV.Fchdoc = CBDASTOS.Fchdoc 
              RMOV.Fchvto = CBDASTOS.Fchvto.
       IF NOT RMOV.CodCta BEGINS "4011" AND RMOV.TpoMov THEN 
          ASSIGN R-ANTCPO = ROWID(RMOV).
    END.
    
    IF cb-ctas.PidRef THEN DO:
       C-VALOR = VALOR-C(cb-dmdlo.CodRef).
       IF C-VALOR = "" THEN ASSIGN RMOV.CodRef = CBDASTOS.CodRef.
       ELSE ASSIGN RMOV.CodRef = C-VALOR.
       
       C-VALOR = VALOR-C(cb-dmdlo.Nroref).
       IF C-VALOR = "" THEN ASSIGN RMOV.Nroref = CBDASTOS.SerRef + CBDASTOS.NroRef.
       ELSE ASSIGN RMOV.Nroref = C-VALOR.
    END.
    
    F-VALOR = VALOR-F(1, cb-dmdlo.Importe).
    IF CBDASTOS.CodMon = 1 THEN DO:
       ASSIGN RMOV.ImpMn1 = F-VALOR.
       IF CBDASTOS.TpoCmb > 0 THEN ASSIGN RMOV.ImpMn2 = ROUND(F-VALOR / CBDASTOS.TpoCmb,2).
       ELSE ASSIGN RMOV.ImpMn2 = 0.
    END.
    ELSE DO:
        ASSIGN RMOV.ImpMn1 = ROUND(F-VALOR * CBDASTOS.TpoCmb,2).
               RMOV.ImpMn2 = F-VALOR.
    END.
    
    IF cb-ctas.Pidcco THEN DO:
       C-VALOR = VALOR-C(cb-dmdlo.cco).
       IF C-VALOR = "" THEN ASSIGN RMOV.cco    = CBDASTOS.cco.
       ELSE ASSIGN RMOV.cco    = C-VALOR.
       
       C-VALOR = VALOR-C(cb-dmdlo.DisCCo).
       IF C-VALOR = "" THEN ASSIGN RMOV.DisCCo = CBDASTOS.DisCCo.
       ELSE ASSIGN RMOV.DisCCo = INTEGER(C-VALOR).
    END.
    
    CASE RMOV.clfaux:
         WHEN "@CL" THEN DO:
              FIND gn-clie WHERE gn-clie.CodCia = cl-CodCia
                   AND gn-clie.codcli = RMOV.codaux NO-LOCK NO-ERROR.
              IF NOT AVAILABLE gn-clie THEN 
                 FIND gn-clie WHERE gn-clie.CodCia = S-CODCIA
                      AND gn-clie.codcli = RMOV.codaux NO-LOCK NO-ERROR.
              IF AVAILABLE gn-clie THEN ASSIGN RMOV.GloDoc = gn-clie.nomcli.
         END.
         WHEN "@PV" THEN DO:
              FIND gn-prov WHERE gn-prov.CodCia = pv-CodCia
                   AND gn-prov.codpro = RMOV.codaux NO-LOCK NO-ERROR.
              IF NOT AVAILABLE gn-prov THEN 
                 FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA
                      AND gn-prov.codpro = RMOV.codaux NO-LOCK NO-ERROR.
              IF AVAILABLE gn-prov THEN ASSIGN RMOV.GloDoc = gn-prov.nompro.
         END.
         WHEN "@CT" THEN DO:              
              FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia
                   AND cb-ctas.codcta = RMOV.codaux NO-LOCK NO-ERROR.                      
              IF NOT AVAILABLE cb-ctas THEN 
                 FIND cb-ctas WHERE cb-ctas.CodCia = S-CODCIA
                      AND cb-ctas.codcta = RMOV.codaux NO-LOCK NO-ERROR.                      
              IF AVAILABLE cb-ctas THEN ASSIGN RMOV.GloDoc  = cb-ctas.nomcta.
         END.
         OTHERWISE DO:
              FIND cb-auxi WHERE cb-auxi.CodCia = cb-codcia
                   AND cb-auxi.clfaux = RMOV.clfaux
                   AND cb-auxi.codaux = RMOV.codaux NO-LOCK NO-ERROR.                      
              IF NOT AVAILABLE cb-auxi THEN 
                 FIND cb-auxi WHERE cb-auxi.CodCia = S-CODCIA 
                      AND cb-auxi.clfaux = RMOV.clfaux
                      AND cb-auxi.codaux = RMOV.codaux NO-LOCK NO-ERROR.                      
              IF AVAILABLE cb-auxi THEN ASSIGN RMOV.GloDoc = cb-auxi.nomaux.
         END.
    END CASE.
    
    IF RMOV.GloDoc = "" THEN DO:
       ASSIGN RMOV.GloDoc = CBDASTOS.Notast:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    END.
    
    IF RMOV.TpoMov THEN x-HbeSol = x-HbeSol + RMOV.ImpMn1.
    ELSE x-DbeSol = x-DbeSol + RMOV.ImpMn1.        
    IF RMOV.TpoMov THEN x-HbeDol = x-HbeDol + RMOV.ImpMn2.
    ELSE x-DbeDol = x-DbeDol + RMOV.ImpMn2.        
    
    RUN GENERA-AUTOMATICA.
END.

/* Calculamos Diferencia por redondeo en Soles */
IF ROUND(ABSOLUTE(x-DbeSol - x-HbeSol),2) > 0 THEN DO:
   RUN Genera-Redondeo(1).   
END.

/* Calculamos Diferencia por redondeo en Dolares */
IF ROUND(ABSOLUTE(x-DbeDol - x-HbeDol),2) > 0 THEN DO:
   RUN Genera-Redondeo(2).
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Automatica V-table-Win 
PROCEDURE Genera-Automatica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND cb-cfga WHERE cb-cfga.CodCia = cb-codcia AND 
                       cb-cfga.CodCfg = 01 NO-LOCK  NO-ERROR.
    
    FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                       cb-ctas.CodCta = RMOV.CodCta NO-LOCK NO-ERROR.

                 
    DEFINE VAR x-GenAut AS INTEGER.
    DEFINE VAR i        AS INTEGER INIT 1.
    /* Grabamos datos para la generación de Cuentas Automáticas */
    x-GenAut  = 0.
       
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ) :
       IF RMOV.CodCta BEGINS ENTRY( i, cb-cfga.GenAut9 ) THEN DO:
          IF ENTRY( i, cb-cfga.GenAut9) <> "" THEN DO:
             x-GenAut = 1.
             LEAVE.
           END.                                              
        END.
    END.
    /* Verificamos si la Cuenta genera automaticas de Clase 6 */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
       IF RMOV.CodCta BEGINS ENTRY( i, cb-cfga.GenAut6 ) THEN DO:
          IF ENTRY( i, cb-cfga.GenAut6) <> "" THEN DO:
             x-GenAut = 2.
             LEAVE.
          END.
       END.
    END.
    /* Verificamos si la Cuenta genera automaticas de otro tipo */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
       IF RMOV.CodCta BEGINS ENTRY( i, cb-cfga.GenAut ) THEN DO:
          IF ENTRY( i, cb-cfga.GenAut) <> "" THEN DO:
             x-GenAut = 3.
             LEAVE.
          END.
       END.
    END.
    ASSIGN RMOV.CtaAut = ""
           RMOV.CtrCta = "".
    
    CASE x-GenAut:
        /* Genera Cuentas Clase 9 */
        WHEN 1 THEN DO:
             ASSIGN RMOV.CtrCta = cb-ctas.Cc1Cta.
             IF cb-ctas.ClfAux = "@CT" THEN DO :
                IF LENGTH(TRIM(RMOV.CodAux)) <= 2 THEN DO :                
                   RMOV.CtaAut = TRIM(RMOV.CodAux) + SUBSTRING(RMOV.CodCta,1,4).
                   RMOV.CodAux = TRIM(RMOV.CodAux) + SUBSTRING(RMOV.CodCta,1,4).
                END.                      
                ELSE
                   RMOV.CtaAut = RMOV.CodAux.   
             END.   
             ELSE RMOV.CtaAut = cb-ctas.An1Cta.
             IF RMOV.CtrCta = ""  THEN RMOV.CtrCta = cb-cfga.Cc1Cta9.             
        END.
        /* Genera Cuentas Clase 6 */
        WHEN 2 THEN DO:
             ASSIGN RMOV.CtrCta = cb-ctas.Cc1Cta.
             IF cb-ctas.CLFAUX = "@CT" THEN RMOV.CtaAut = RMOV.CodAux.
             ELSE RMOV.CtaAut = cb-ctas.An1Cta.
             IF RMOV.CtrCta = ""  THEN RMOV.CtrCta = cb-cfga.Cc1Cta6.
        END.
           
        WHEN 3 THEN DO:
             ASSIGN RMOV.CtaAut = cb-ctas.An1Cta
                    RMOV.CtrCta = cb-ctas.Cc1Cta.
                     
        END.
    END CASE.

/* Generando las cuentas autom ticas */
IF RMOV.CtrCta <> "" THEN DO:   
   IF RMOV.CtaAut <> "" THEN DO:
      CREATE DETALLE.
      X-NroItm = X-NroItm + 1.
      ASSIGN DETALLE.CodCia   = RMOV.CodCia
             DETALLE.Periodo  = RMOV.Periodo
             DETALLE.NroMes   = RMOV.NroMes
             DETALLE.CodOpe   = RMOV.CodOpe
             DETALLE.NroAst   = RMOV.NroAst
             DETALLE.TpoItm   = "A"
             DETALLE.CodMon   = RMOV.CodMon
             DETALLE.TpoCmb   = RMOV.TpoCmb
             DETALLE.NroItm   = X-NroItm
             DETALLE.Codcta   = RMOV.CtaAut
             DETALLE.CodDiv   = RMOV.CodDiv
             DETALLE.ClfAux   = RMOV.ClfAux
             DETALLE.CodAux   = RMOV.CodCta
             DETALLE.NroRuc   = RMOV.NroRuc
             DETALLE.CodDoc   = RMOV.CodDoc
             DETALLE.NroDoc   = RMOV.NroDoc
             DETALLE.GloDoc   = RMOV.GloDoc
             DETALLE.CodMon   = RMOV.CodMon
             DETALLE.TpoCmb   = RMOV.TpoCmb
             DETALLE.TpoMov   = RMOV.TpoMov
             DETALLE.NroRef   = RMOV.NroRef
             DETALLE.FchDoc   = RMOV.FchDoc
             DETALLE.FchVto   = RMOV.FchVto
             DETALLE.ImpMn1   = RMOV.ImpMn1
             DETALLE.ImpMn2   = RMOV.ImpMn2
             DETALLE.ImpMn3   = RMOV.ImpMn3
             DETALLE.Tm       = RMOV.Tm
             DETALLE.CCO      = RMOV.CCO.
      IF DETALLE.TpoMov THEN x-HbeSol = x-HbeSol + DETALLE.ImpMn1.
         ELSE x-DbeSol = x-DbeSol + DETALLE.ImpMn1.
         
      IF DETALLE.TpoMov THEN x-HbeDol = x-HbeDol + DETALLE.ImpMn2.
         ELSE x-DbeDol = x-DbeDol + DETALLE.ImpMn2.
         
   END.
         
   CREATE DETALLE.
   X-NroItm = X-NroItm + 1.
   ASSIGN DETALLE.CodCia   = RMOV.CodCia
           DETALLE.Periodo  = RMOV.Periodo
           DETALLE.NroMes   = RMOV.NroMes
           DETALLE.CodOpe   = RMOV.CodOpe
           DETALLE.NroAst   = RMOV.NroAst
           DETALLE.TpoItm   = "A"
           DETALLE.CodMon   = RMOV.CodMon
           DETALLE.TpoCmb   = RMOV.TpoCmb
           DETALLE.NroItm   = X-NroItm
           DETALLE.Codcta   = RMOV.Ctrcta
           DETALLE.CodDiv   = RMOV.CodDiv
           DETALLE.ClfAux   = RMOV.ClfAux
           DETALLE.CodAux   = RMOV.CodCta
           DETALLE.NroRuc   = RMOV.NroRuc
           DETALLE.CodDoc   = RMOV.CodDoc
           DETALLE.NroDoc   = RMOV.NroDoc
           DETALLE.GloDoc   = RMOV.GloDoc
           DETALLE.CodMon   = RMOV.CodMon
           DETALLE.TpoCmb   = RMOV.TpoCmb
           DETALLE.TpoMov   = NOT RMOV.TpoMov
           DETALLE.ImpMn1   = RMOV.ImpMn1
           DETALLE.ImpMn2   = RMOV.ImpMn2
           DETALLE.ImpMn3   = RMOV.ImpMn3
           DETALLE.NroRef   = RMOV.NroRef
           DETALLE.FchDoc   = RMOV.FchDoc
           DETALLE.FchVto   = RMOV.FchVto
           DETALLE.Tm       = RMOV.Tm
           DETALLE.CCO      = RMOV.CCO.
    IF DETALLE.TpoMov THEN x-HbeSol = x-HbeSol + DETALLE.ImpMn1.
       ELSE x-DbeSol = x-DbeSol + DETALLE.ImpMn1.        
       
    IF DETALLE.TpoMov THEN x-HbeDol = x-HbeDol + DETALLE.ImpMn2.
       ELSE x-DbeDol = x-DbeDol + DETALLE.ImpMn2.        
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Cabecera V-table-Win 
PROCEDURE Genera-Cabecera :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF L-CREA THEN CREATE cb-cmov.
ELSE DO:
     FIND cb-cmov WHERE cb-cmov.Codcia  = cbdastos.Codcia AND
          cb-cmov.periodo = cbdastos.periodo AND
          cb-cmov.Nromes  = cbdastos.Nromes AND
          cb-cmov.Codope  = cbdastos.Codope AND
          cb-cmov.Nroast  = cbdastos.Nroast NO-ERROR.
END.
IF AVAILABLE cb-cmov THEN DO:
    ASSIGN cb-cmov.Codcia  = cbdastos.Codcia
           cb-cmov.Periodo = cbdastos.periodo
           cb-cmov.Nromes  = cbdastos.Nromes
           cb-cmov.Codope  = cbdastos.Codope
           cb-cmov.Nroast  = cbdastos.Nroast
           cb-cmov.Codmon  = cbdastos.CodMon
           cb-cmov.Fchast  = cbdastos.FchAst
           cb-cmov.Flgest  = ""
           cb-cmov.GloAst  = cbdastos.Notast
           cb-cmov.Tpocmb  = cbdastos.TpoCmb
           cb-cmov.Usuario = cbdastos.Usuario
           cb-cmov.CodDiv  = cbdastos.CodDiv
           cb-cmov.DBEMN1  = x-DbeSol
           cb-cmov.DBEMN2  = x-DbeDol
           cb-cmov.HBEMN1  = x-HbeSol
           cb-cmov.HBEMN2  = x-HbeDol
           cb-cmov.Notast  = "Registro de Doc." + cbdastos.CodDoc + " No. " + 
                            cbdastos.SerDoc + "-" + cbdastos.NroDoc + " - " 
                            + X-NOMAUX
           R-ROWID = ROWID(cb-cmov).
END.
RELEASE  cb-cmov.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR j AS INTEGER.
j = 0.

FOR EACH RMOV : 
   j = j + 1.
   CREATE cb-dmov.
   Cb-dmov.CodCia  = cbdastos.CodCia. 
   Cb-dmov.Periodo = cbdastos.PERIODO.
   Cb-dmov.NroMes  = cbdastos.NroMes. 
   Cb-dmov.Codope  = cbdastos.CodOpe.
   Cb-dmov.Nroast  = cbdastos.NroAst.
   Cb-dmov.Tpocmb  = RMOV.TpoCmb. 
   Cb-dmov.C-Fcaja = RMOV.c-FCaja.
   Cb-dmov.cco     = RMOV.cco.
   Cb-dmov.Clfaux  = RMOV.ClfAux.
   Cb-dmov.Codaux  = RMOV.CodAux. 
   Cb-dmov.Codcta  = RMOV.CodCta. 
   Cb-dmov.CodDiv  = RMOV.CodDiv.
   Cb-dmov.Codmon  = RMOV.CodMon. 
   Cb-dmov.CtaAut  = RMOV.CtaAut. 
   Cb-dmov.CtrCta  = RMOV.CtrCta. 
   Cb-dmov.flgact  = YES.
   cb-dmov.TpoItm  = RMOV.TpoItm.
   Cb-dmov.Glodoc  = RMOV.GloDoc. 
   Cb-dmov.ImpMn1  = RMOV.ImpMn1. 
   Cb-dmov.ImpMn2  = RMOV.ImpMn2. 
   Cb-dmov.ImpMn3  = RMOV.IMpMn3.
   Cb-dmov.Coddoc  = RMOV.CodDoc. 
   Cb-dmov.Nrodoc  = RMOV.NroDoc. 
   Cb-dmov.Fchdoc  = RMOV.FchDoc. 
   Cb-dmov.Fchvto  = RMOV.FchVto. 
   Cb-dmov.CodRef  = RMOV.CodRef. 
   Cb-dmov.Nroref  = RMOV.NroRef. 
   Cb-dmov.Nroruc  = RMOV.NroRuc. 
   Cb-dmov.tm      = RMOV.Tm.
   Cb-dmov.TpoMov  = RMOV.TpoMov.
   cb-dmov.CndCmp  = RMOV.CndCmp.
   cb-dmov.DisCCo  = RMOV.DisCCo.
   cb-dmov.NroItm  = RMOV.NroItm.
   cb-dmov.OrdCmp  = RMOV.OrdCmp.   
   RUN cbd/cb-acmd.p(RECID(cb-dmov), YES, YES).   
   
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Dif-Cambio V-table-Win 
PROCEDURE Genera-Dif-Cambio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   FIND cb-cfgg WHERE cb-cfgg.CodCia = 0 AND
        cb-cfgg.Codcfg = "C01" NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-cfgg THEN
      FIND cb-cfgg WHERE cb-cfgg.CodCia = S-CodCia AND
           cb-cfgg.Codcfg = "C01" NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-cfgg THEN RETURN.
   
   DEFINE VARIABLE CtaDif AS CHAR NO-UNDO.
   IF (x-DbeSol - x-HbeSol) < 0 THEN CtaDif = cb-cfgg.codcta[1].  /* PERDIDA */
   ELSE CtaDif = cb-cfgg.codcta[2].                               /* GANANCIA */
   
   FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                      cb-ctas.CodCta = CtaDif NO-LOCK NO-ERROR.

   
   X-NroItm = X-NroItm + 1.
   CREATE RMOV.
   RMOV.CodCia  = S-CodCia. 
   RMOV.NroMes  = S-NroMes. 
   RMOV.Periodo = S-PERIODO.
   RMOV.Codope  = CBDASTOS.Codope.
   RMOV.Codcta  = CtaDif.
   RMOV.CodDiv  = CBDASTOS.CodDiv.
   RMOV.Codmon  = 1.
   RMOV.TpoItm  = "A".
   RMOV.flgact  = YES.
   RMOV.ClfAux  = cb-ctas.ClfAux.
   IF CtaDif = cb-cfgg.codcta[2] THEN DO :
      RMOV.CodAux  = cb-cfgg.codAux[2]. 
      RMOV.CCo     = cb-cfgg.Cco[2].
      RMOV.Glodoc  = "* Ganancia por Diferencia de Cambio".       
   END.   
   ELSE DO :
      RMOV.CodAux  = cb-cfgg.codAux[1]. 
      RMOV.CCo     = cb-cfgg.Cco[1].
      RMOV.Glodoc  = "* Perdida por Diferencia de Cambio". 
   END.   
   RMOV.Tpocmb  = 0.
   RMOV.ImpMn1  = ABSOLUTE(x-DbeSol - x-HbeSol). 
   RMOV.ImpMn2  = 0. 
   RMOV.ImpMn3  = 0.
   RMOV.TpoMov  = (x-DbeSol > x-HbeSol).
   RMOV.NroItm  = X-NroItm.

   IF RMOV.TpoMov THEN x-HbeSol = x-HbeSol + RMOV.ImpMn1.
   ELSE x-DbeSol = x-DbeSol + RMOV.ImpMn1.
   IF RMOV.TpoMov THEN x-HbeDol = x-HbeDol + RMOV.ImpMn2.
   ELSE x-DbeDol = x-DbeDol + RMOV.ImpMn2.
            
   RUN Genera-Automatica.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Reclamo-Terceros V-table-Win 
PROCEDURE Genera-Reclamo-Terceros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER x-impor1 AS DECIMAL.
   DEFINE INPUT PARAMETER x-impor2 AS DECIMAL.
   DEFINE INPUT PARAMETER x-codmon AS INTEGER.

   IF x-impor1 = x-impor2 THEN RETURN.

   DEFINE VARIABLE CtaRec AS CHAR NO-UNDO.  /* Cuenta de reclamos */

   FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
        cb-cfgg.Codcfg = "REC" NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-cfgg THEN
      FIND cb-cfgg WHERE cb-cfgg.CodCia = S-CodCia AND
           cb-cfgg.Codcfg = "REC" NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-cfgg THEN RETURN.
  
   IF NOT (x-impor1 - x-impor2) < 0 THEN DO:
      IF CBDASTOS.Codmon = 1 THEN CtaRec = cb-cfgg.codcta[1].  /* PERDIDA */
      ELSE CtaRec = cb-cfgg.codcta[3].
      END.
   ELSE DO:
      IF CBDASTOS.Codmon = 1 THEN CtaRec = cb-cfgg.codcta[2]. /* GANANCIA */
      ELSE CtaRec = cb-cfgg.codcta[4].
   END.
   
   /* Grabaci¢n de la cuenta segun ingreso de almacen */
   IF RMOV.TpoMov THEN x-HbeSol = x-HbeSol - RMOV.ImpMn1.
   ELSE x-DbeSol = x-DbeSol - RMOV.ImpMn1.
   IF RMOV.TpoMov THEN x-HbeDol = x-HbeDol - RMOV.ImpMn2.
   ELSE x-DbeDol = x-DbeDol - RMOV.ImpMn2.
             
   IF RMOV.CodMon = 1 THEN DO:
      ASSIGN RMOV.ImpMn1 = x-impor2.
      IF RMOV.TpoCmb > 0 THEN ASSIGN RMOV.ImpMn2 = ROUND(x-impor2 / RMOV.TpoCmb,2).
      ELSE ASSIGN RMOV.ImpMn2 = 0.
   END.
   ELSE DO:
       ASSIGN RMOV.ImpMn1 = ROUND(x-impor2 * RMOV.TpoCmb,2).
              RMOV.ImpMn2 = x-impor2.
   END.
           
   IF RMOV.TpoMov THEN x-HbeSol = x-HbeSol + RMOV.ImpMn1.
   ELSE x-DbeSol = x-DbeSol + RMOV.ImpMn1.
   IF RMOV.TpoMov THEN x-HbeDol = x-HbeDol + RMOV.ImpMn2.
   ELSE x-DbeDol = x-DbeDol + RMOV.ImpMn2.
              
   X-NroItm = X-NroItm + 1.
   FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                      cb-ctas.CodCta = CtaRec  NO-LOCK NO-ERROR.
   /* GENERAMOS LA CUENTA DE RECLAMOS   */
   
   CREATE RMOV.
   RMOV.CodCia  = S-CodCia. 
   RMOV.NroMes  = S-NroMes. 
   RMOV.Periodo = S-PERIODO.
   RMOV.Codope  = CBDASTOS.Codope.
   RMOV.Codcta  = CtaRec.
   RMOV.CodDiv  = CBDASTOS.CodDiv.
   RMOV.Codmon  = x-codmon.
   RMOV.Clfaux  = cb-ctas.ClfAux.
   RMOV.Codaux  = CBDASTOS.Codaux. 
   RMOV.Coddoc  = CBDASTOS.Coddoc. 
   RMOV.Nrodoc  = CBDASTOS.serdoc + CBDASTOS.NroDoc.
   RMOV.Codref  = CBDASTOS.Codref.
   RMOV.Nroref  = CBDASTOS.SerRef + CBDASTOS.NroRef. 
   RMOV.Fchdoc  = CBDASTOS.Fchdoc. 
   RMOV.Fchvto  = CBDASTOS.Fchvto. 
   RMOV.Glodoc  = CBDASTOS.Notast.
   RMOV.TpoItm  = "".
   RMOV.flgact  = YES.
   RMOV.tm      = cb-dmdlo.tm.
   IF (x-impor1 - x-impor2) > 0 THEN 
        RMOV.Glodoc  = "Reclamo de Terceros". 
   ELSE RMOV.Glodoc  = "Reclamo a Terceros". 
   RMOV.Tpocmb  = CBDASTOS.TpoCmb.
   IF RMOV.Codmon = 1 THEN 
      ASSIGN RMOV.ImpMn1  = ABSOLUTE(x-impor1 - x-impor2)
             RMOV.ImpMn2  = ROUND(RMOV.ImpMn1 / RMOV.TpoCmb, 2).
   ELSE 
      ASSIGN RMOV.ImpMn2  = ABSOLUTE(x-impor1 - x-impor2)
             RMOV.ImpMn1  = ROUND(RMOV.ImpMn2 * RMOV.TpoCmb, 2).
   RMOV.TpoMov  = NOT (x-impor1 > x-impor2).
   RMOV.ImpMn3  = 0.
   
   RMOV.NroItm  = X-NroItm.

   IF RMOV.TpoMov THEN x-HbeSol = x-HbeSol + RMOV.ImpMn1.
   ELSE x-DbeSol = x-DbeSol + RMOV.ImpMn1.
   IF RMOV.TpoMov THEN x-HbeDol = x-HbeDol + RMOV.ImpMn2.
   ELSE x-DbeDol = x-DbeDol + RMOV.ImpMn2.
      
   FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                      cb-ctas.CodCta = RMOV.CodCta NO-LOCK NO-ERROR.

   RUN Genera-Automatica.

   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Redondeo V-table-Win 
PROCEDURE Genera-Redondeo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER I-Mon AS INTEGER.
   DEFINE VARIABLE CtaRnd AS CHAR NO-UNDO.
   
   FIND cb-cfgg WHERE cb-cfgg.CodCia = cb-codcia AND
        cb-cfgg.Codcfg = "RND" NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-cfgg THEN
      FIND cb-cfgg WHERE cb-cfgg.CodCia = S-CodCia AND
           cb-cfgg.Codcfg = "RND" NO-LOCK NO-ERROR.
   IF NOT AVAILABLE cb-cfgg THEN RETURN.
   
   IF (x-DbeSol - x-HbeSol) < 0 THEN CtaRnd = cb-cfgg.codcta[1].  /* PERDIDA  */
   ELSE CtaRnd = cb-cfgg.codcta[2].                               /* GANANCIA */
   
   FIND cb-ctas WHERE cb-ctas.CodCia = cb-CodCia AND
                      cb-ctas.CodCta = CtaRnd NO-LOCK NO-ERROR.
                      
   IF NOT AVAILABLE cb-ctas THEN RETURN.
   
   X-NroItm = X-NroItm + 1.
   CREATE RMOV.
   RMOV.CodCia  = S-CodCia. 
   RMOV.NroMes  = S-NroMes. 
   RMOV.Periodo = S-PERIODO.
   RMOV.Codope  = CBDASTOS.Codope.
   RMOV.Codcta  = CtaRnd.
   RMOV.CodDiv  = CBDASTOS.CodDiv.
   RMOV.Codmon  = I-Mon.
   RMOV.TpoItm  = "R".
   RMOV.flgact  = YES.
   RMOV.ClfAux  = cb-ctas.ClfAux.
   RMOV.TM      = cb-ctas.TM.
   IF CtaRnd = cb-cfgg.codcta[2] THEN DO :
      RMOV.Glodoc  = "Ganancia por Redondeo". 
      RMOV.CodAux  = cb-cfgg.codAux[2]. 
      RMOV.CCo     = cb-cfgg.Cco[2].
   END.     
   ELSE DO :
      RMOV.Glodoc  = "Perdida por Redondeo". 
      RMOV.CodAux  = cb-cfgg.codAux[1]. 
      RMOV.CCo     = cb-cfgg.Cco[1].      
   END.   
   RMOV.Tpocmb  = 0.
   IF I-Mon = 1 THEN 
        ASSIGN RMOV.ImpMn1  = ABSOLUTE(x-DbeSol - x-HbeSol)
               RMOV.ImpMn2  = 0
               RMOV.TpoMov  = (x-DbeSol > x-HbeSol).
   ELSE ASSIGN RMOV.ImpMn2  = ABSOLUTE(x-DbeDol - x-HbeDol)
               RMOV.ImpMn1  = 0
               RMOV.TpoMov  = (x-DbeDol > x-HbeDol).
   RMOV.ImpMn3  = 0.
   
   RMOV.NroItm  = X-NroItm.

   IF RMOV.TpoMov THEN x-HbeSol = x-HbeSol + RMOV.ImpMn1.
   ELSE x-DbeSol = x-DbeSol + RMOV.ImpMn1.
   IF RMOV.TpoMov THEN x-HbeDol = x-HbeDol + RMOV.ImpMn2.
   ELSE x-DbeDol = x-DbeDol + RMOV.ImpMn2.
      
   FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                      cb-ctas.CodCta = RMOV.CodCta NO-LOCK NO-ERROR.
   
   RUN Genera-Automatica.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Voucher V-table-Win 
PROCEDURE Imprime-Voucher :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND FIRST cb-cmov WHERE cb-cmov.Codcia  = cbdastos.Codcia  AND
     cb-cmov.periodo = cbdastos.periodo AND
     cb-cmov.Nromes  = cbdastos.Nromes  AND
     cb-cmov.Codope  = cbdastos.Codope  AND
     cb-cmov.Nroast  = cbdastos.Nroast NO-LOCK NO-ERROR.

IF NOT AVAILABLE cb-cmov THEN RETURN.
IF cb-cmov.FlgEst = "A" THEN RETURN.

DEFINE var X-PAG AS CHAR FORMAT "999". 
DEFINE VARIABLE X-NomCta   AS CHAR.   
DEFINE VARIABLE X-Mon      AS CHAR.   
DEFINE VARIABLE x-debe     AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
DEFINE VARIABLE x-haber    AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
DEFINE VARIABLE x-codmon   AS INTEGER INITIAL 1.
DEFINE VARIABLE x-nom-ope  AS CHARACTER FORMAT "x(40)".
DEFINE VARIABLE pinta-mes  AS CHARACTER FORMAT "X(40)".
DEFINE VARIABLE x-TotDeb   AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
DEFINE VARIABLE x-TotHab   AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)".
DEFINE VARIABLE X-Monto    AS CHAR EXTENT 10 FORMAT "X(41)" INIT "".
DEFINE VARIABLE X-Refer    AS CHAR EXTENT 10 FORMAT "X(41)" INIT "".
DEFINE VARIABLE F-DIGIT    AS INTEGER INIT 0.

IF cb-cmdlo.Referencia[1] NE "" THEN
   X-Refer[1] = STRING(cb-cmdlo.Referencia[1],"X(19)") + ": " + cbdastos.C1.
IF cb-cmdlo.Referencia[2] NE "" THEN
   X-Refer[2] = STRING(cb-cmdlo.Referencia[2],"X(19)") + ": " + cbdastos.C2. 
IF cb-cmdlo.Referencia[3] NE "" THEN
   X-Refer[3] = STRING(cb-cmdlo.Referencia[3],"X(19)") + ": " + cbdastos.C3. 
IF cb-cmdlo.Referencia[4] NE "" THEN
   X-Refer[4] = STRING(cb-cmdlo.Referencia[4],"X(19)") + ": " + cbdastos.C4. 
IF cb-cmdlo.Referencia[5] NE "" THEN
   X-Refer[5] = STRING(cb-cmdlo.Referencia[5],"X(19)") + ": " + cbdastos.C5. 
IF cb-cmdlo.Referencia[6] NE "" THEN
   X-Refer[6] = STRING(cb-cmdlo.Referencia[6],"X(19)") + ": " + cbdastos.C6.
IF cb-cmdlo.Referencia[10] NE "" THEN
   X-Refer[10] = STRING(cb-cmdlo.Referencia[10],"X(19)") + ": " + cbdastos.OrdCmp.

IF cb-cmdlo.Concepto[1] NE "" THEN 
   X-Monto[1] = STRING(cb-cmdlo.Concepto[1],"X(19)") + ": " + STRING(cbdastos.V1,">>,>>>,>>9.99").
IF cb-cmdlo.Concepto[2] NE "" THEN 
   X-Monto[2] = STRING(cb-cmdlo.Concepto[2],"X(19)") + ": " + STRING(cbdastos.V2,">>,>>>,>>9.99").
IF cb-cmdlo.Concepto[3] NE "" THEN 
   X-Monto[3] = STRING(cb-cmdlo.Concepto[3],"X(19)") + ": " + STRING(cbdastos.V3,">>,>>>,>>9.99").
IF cb-cmdlo.Concepto[4] NE "" THEN 
   X-Monto[4] = STRING(cb-cmdlo.Concepto[4],"X(19)") + ": " + STRING(cbdastos.V4,">>,>>>,>>9.99").
IF cb-cmdlo.Concepto[5] NE "" THEN 
   X-Monto[5] = STRING(cb-cmdlo.Concepto[5],"X(19)") + ": " + STRING(cbdastos.V5,">>,>>>,>>9.99").
IF cb-cmdlo.Concepto[6] NE "" THEN 
   X-Monto[6] = STRING(cb-cmdlo.Concepto[6],"X(19)") + ": " + STRING(cbdastos.V6,">>,>>>,>>9.99").
IF cb-cmdlo.Concepto[7] NE "" THEN 
   X-Monto[7] = STRING(cb-cmdlo.Concepto[7],"X(19)") + ": " + STRING(cbdastos.V7,">>,>>>,>>9.99").
IF cb-cmdlo.Concepto[8] NE "" THEN 
   X-Monto[8] = STRING(cb-cmdlo.Concepto[8],"X(19)") + ": " + STRING(cbdastos.V8,">>,>>>,>>9.99").
IF cb-cmdlo.Concepto[9] NE "" THEN 
   X-Monto[9] = STRING(cb-cmdlo.Concepto[9],"X(19)") + ": " + STRING(cbdastos.V9,">>,>>>,>>9.99").
IF cb-cmdlo.Concepto[10] NE "" THEN 
   X-Monto[10] = STRING(cb-cmdlo.Concepto[10],"X(19)") + ": " + STRING(cbdastos.V0,">>,>>>,>>9.99").

x-nom-ope = "VOUCHER DE " + F-DesOpe.
F-DIGIT = ( 42 - LENGTH(x-nom-ope)) / 2.
x-nom-ope = FILL(" ",F-DIGIT) + x-nom-ope.

RUN bin/_mes.p ( INPUT s-NroMes , 1,  OUTPUT pinta-mes ).
pinta-mes = pinta-mes + " DE " + STRING( s-periodo , "9,999" ).
x-codmon = cb-cmov.codmon.
IF x-CodMon = 1 THEN  x-Mon = "S/.".
ELSE x-Mon = "US$".

DEFINE FRAME f-cab
  cb-dmov.codcta 
  cb-dmov.cco    AT 15
  X-NomCta       FORMAT "X(50)" AT 22
  x-debe         AT 97
  x-haber        AT 117 
  HEADER
       S-nomcia
       x-nom-ope AT 45 FORMAT "X(42)" 
       "FECHA : " TO 119 cb-cmov.fchast FORMAT "99/99/9999" SKIP 
       "    Modelo : " cbdastos.CodMod
       "ASIENTO No: " AT 55 cb-cmov.codope "-" cb-cmov.nroast 
                "HORA : " TO 119 STRING(TIME, "HH:MM AM") SKIP(1)
       "  Division : " cbdastos.CodDiv
       "CONDICION " AT 49 X-Condic 
       "No.Anticipo : " TO 119 CBDASTOS.NoAntcpo SKIP
       "       RUC : " cbdastos.NroRuc X-NomAux "MONEDA : " TO 119 x-Mon SKIP
       " DOCUMENTO : " cbdastos.CodDoc "-" cbdastos.SerDoc "-" cbdastos.NroDoc
       "FECHA DOC. : " AT 57 cbdastos.FchDoc FORMAT "99/99/9999" 
       "VENCIMIENTO : " TO 119 cbdastos.FchVto FORMAT "99/99/9999" SKIP
       "REFERENCIA : " cbdastos.CodRef "-" cbdastos.SerRef "-" 
       cbdastos.NroRef VIEW-AS TEXT FORMAT "X(15)"
       "COD.DISTR. : " AT 57 CBDASTOS.DisCCo
       "TIPO CAMBIO : " TO 119 cbdastos.TpoCmb FORMAT ">,>>9.9999" SKIP
       X-Refer[1]   X-Refer[2] AT 43   X-Refer[3] AT 86 SKIP
       X-Refer[4]   X-Refer[5] AT 43   X-Refer[6] AT 86 SKIP
       X-Refer[10]  SKIP
       X-Monto[1]   X-Monto[2] AT 43   X-Monto[3] AT 86 SKIP
       X-Monto[4]   X-Monto[5] AT 43   X-Monto[6] AT 86 SKIP
       X-Monto[7]   X-Monto[8] AT 43   X-Monto[9] AT 86 SKIP
       X-Monto[10] AT 86 SKIP
       "----------------------------------------------------------------------------------------------------------------------------------" SKIP
       " Cuenta     C.Cos    Descripcion                                                                         Cargos            Abonos " SKIP
       "----------------------------------------------------------------------------------------------------------------------------------" SKIP

  WITH WIDTH 130 NO-BOX NO-LABEL NO-UNDERLINE STREAM-IO DOWN.

  /*     "     Glosa : " cb-cmov.gloast  FORMAT "X(80)" SKIP */

/*OUTPUT STREAM report TO C:\TMP\PRUEBA.PRN PAGED PAGE-SIZE 33.    */
OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 33.   
PUT STREAM report CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(33) .
 
PUT STREAM report CONTROL "~033x" NULL "~017~033P".

FOR EACH cb-dmov NO-LOCK WHERE cb-dmov.codcia = cb-cmov.codcia
                AND cb-dmov.periodo = cb-cmov.periodo
                AND cb-dmov.nromes  = cb-cmov.NroMes
                AND cb-dmov.codope  = cb-cmov.codope
                AND cb-dmov.nroast  = cb-cmov.nroast
    BREAK BY cb-dmov.nroast 
          BY cb-dmov.tpomov 
    ON ERROR UNDO, LEAVE:
/*    IF cb-dmov.tpoitm = "A" AND LOOKUP(cb-dmov.CodCta,CTAS-REDONDEO) = 0 AND 
       NOT (LOOKUP(cb-dmov.CodCta,CTAS-Diferencia) <> 0 AND CBDASTOS.NoAntcpo <> "") THEN NEXT.*/

    IF (cb-dmov.tpoitm = "A" AND (LOOKUP(cb-dmov.CodCta,CTAS-REDONDEO) = 0 AND 
       LOOKUP(cb-dmov.CodCta,CTAS-Diferencia) = 0)) AND SUBSTRING(cb-dmov.codcta,1,2) <> '42'  THEN NEXT.

    x-NomCta = "".
    FIND cb-ctas WHERE cb-ctas.CodCia = 0 AND
         cb-ctas.codcta = cb-dmov.CodCta NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN 
       FIND cb-ctas WHERE cb-ctas.CodCia = S-CODCIA AND
            cb-ctas.codcta = cb-dmov.CodCta NO-LOCK NO-ERROR.
    IF AVAILABLE cb-ctas THEN x-NomCta  = cb-ctas.nomcta.
    CASE x-codmon:
        WHEN 2 THEN DO:
            x-NomCta = x-NomCta + " (US$" + STRING(ImpMn2) + ")".
        END.
    END CASE.
    IF cb-dmov.tpomov THEN DO:
        x-debe  = 0.
        x-haber = ImpMn1.
    END.
    ELSE DO:
        x-debe  = ImpMn1.
        x-haber = 0.
    END.
    DISPLAY STREAM report 
            cb-dmov.codcta
            cb-dmov.cco   
            x-NomCta
            x-debe WHEN (x-debe > 0)
            x-haber WHEN (x-haber > 0) WITH FRAME f-cab.
    X-TotDeb = X-TotDeb + x-debe.
    X-TotHab = X-TotHab + x-Haber.
END.
PUT STREAM report SKIP.
PUT STREAM report "----------------" AT 97  "----------------" AT 115 SKIP.
PUT STREAM report X-TotDeb AT 97    X-TotHab AT 115 SKIP.
PUT STREAM report "----------------" AT 97  "----------------" AT 115 SKIP.
PUT STREAM report SKIP.

DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 5 :
   PUT STREAM report "" skip.
END.
PUT STREAM report "                         -----------------       -----------------       -----------------      "  AT 20 SKIP.
PUT STREAM report "                              HECHO                   REVISADO.           Vo.Bo.GERENCIA        "  AT 20 SKIP.
PUT STREAM report pinta-mes.
OUTPUT STREAM report CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF L-MESPRE THEN DO:
     MESSAGE " MES PRE-CIERRE " VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  
  IF L-MESCIE THEN DO:
     MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  FIND LAST gn-tcmb  NO-LOCK NO-ERROR.
 
  FIND cb-oper WHERE cb-oper.CodCia = CBDASTOS.CodCia AND
       cb-oper.Codope = cb-cmdlo.CodOpe NO-LOCK NO-ERROR.
  IF NOT AVAILABLE cb-oper THEN 
     FIND cb-oper WHERE cb-oper.CodCia = 0 AND
          cb-oper.Codope = cb-cmdlo.CodOpe NO-LOCK NO-ERROR.
  
  IF AVAILABLE gn-tcmb THEN DO :
     IF cb-oper.TpoCmb = 1 THEN 
          DISPLAY gn-tcmb.Compra @ CBDASTOS.TpoCmb WITH FRAME {&FRAME-NAME}.
     ELSE DISPLAY gn-tcmb.Venta @ CBDASTOS.TpoCmb WITH FRAME {&FRAME-NAME}.
  END.
  L-CREA = YES.
  DISPLAY TODAY @ CBDASTOS.Fchast 
          TODAY @ CBDASTOS.Fchdoc 
          TODAY @ CBDASTOS.Fchvto WITH FRAME {&FRAME-NAME}.
          
  FIND FIRST gn-divi WHERE gn-divi.codcia = S-CODCIA NO-LOCK NO-ERROR.
  IF AVAILABLE gn-divi THEN 
     DISPLAY gn-divi.CodDiv @ CBDASTOS.CodDiv WITH FRAME {&FRAME-NAME}.
  
  x-totafe1 = 0.
  x-totexo1 = 0.
  x-totafe2 = 0.
  x-totexo2 = 0.
  x-guialm  = ''.

  IF cb-cmdlo.ClfAux = "" THEN CBDASTOS.CodAux:SENSITIVE = NO.
     ELSE CBDASTOS.CodAux:SENSITIVE = YES.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  IF L-CREA THEN DO:
     RUN cbd/cbdnast.p(cb-codcia, s-codcia, s-periodo, s-NroMes, cb-cmdlo.CodOpe, OUTPUT x-nroast).
     ASSIGN CBDASTOS.Codcia  = S-CODCIA
            CBDASTOS.Periodo = S-PERIODO
            CBDASTOS.Nromes  = S-NROMES
            CBDASTOS.Codope  = cb-cmdlo.CodOpe
            CBDASTOS.Nroast  = STRING(X-NroAst,"999999")
            CBDASTOS.CodMod  = cb-cmdlo.CodMod.
     DISPLAY X-NROAST @ CBDASTOS.Nroast WITH FRAME {&FRAME-NAME}.
  END.
  ASSIGN CBDASTOS.Nrodoc = STRING(DECIMAL(CBDASTOS.Nrodoc))
         CBDASTOS.serdoc = STRING(INTEGER(CBDASTOS.Serdoc),"999")
         cbdastos.Usuario = S-USER-ID.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO TRANSACTION:
     FIND FIRST cb-cmov WHERE cb-cmov.Codcia  = cbdastos.Codcia  AND
          cb-cmov.periodo = cbdastos.periodo AND
          cb-cmov.Nromes  = cbdastos.Nromes  AND
          cb-cmov.Codope  = cbdastos.Codope  AND
          cb-cmov.Nroast  = cbdastos.Nroast NO-ERROR.
     IF AVAILABLE cb-cmov THEN 
        ASSIGN cb-cmov.Flgest = "A"
               cb-cmov.Notast = "A   N   U   L   A   D   O".
     /* RUN Borra-Flag-Almacen.           */
  END.
  RUN Borra-Detalle.

  IF cb-cmdlo.codmod = 1 OR cb-cmdlo.codmod = 2 THEN RUN Borra-Flag-Almacen.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN Campos-Visibles.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  IF AVAILABLE cb-cmdlo AND AVAILABLE CBDASTOS THEN DO WITH FRAME {&FRAME-NAME}:
     FIND cb-oper WHERE cb-oper.CodCia = CBDASTOS.CodCia AND
          cb-oper.Codope = cb-cmdlo.CodOpe NO-LOCK NO-ERROR.
     IF NOT AVAILABLE cb-oper THEN 
        FIND cb-oper WHERE cb-oper.CodCia = 0 AND
             cb-oper.Codope = cb-cmdlo.CodOpe NO-LOCK NO-ERROR.
     IF AVAILABLE cb-oper THEN F-DesOpe = cb-oper.Nomope.
     FIND GN-DIVI WHERE GN-DIVI.CodCia = CBDASTOS.CodCia AND
          GN-DIVI.CodDiv = CBDASTOS.CodDiv NO-LOCK NO-ERROR.
     IF AVAILABLE GN-DIVI THEN 
        DISPLAY GN-DIVI.DesDiv @ F-DesDiv.
     ELSE DISPLAY "" @ F-DesDiv.
     
     IF cb-cmdlo.Referencia[8]:VISIBLE THEN DO:
        DISPLAY cb-cmdlo.Referencia[8].
        FIND cb-auxi WHERE cb-auxi.CodCia = 0 AND
             cb-auxi.ClfAux = "CCO" AND
             cb-auxi.CodAux = CBDASTOS.cco NO-LOCK NO-ERROR.
        IF NOT AVAILABLE cb-auxi THEN
           FIND cb-auxi WHERE cb-auxi.CodCia = S-CODCIA AND
                cb-auxi.ClfAux = "CCO" AND
                cb-auxi.CodAux = CBDASTOS.cco NO-LOCK NO-ERROR.
        IF AVAILABLE CB-AUXI THEN 
           DISPLAY cb-auxi.NomAux @ F-DesCCt.
        ELSE DISPLAY "" @ F-DesCCt.
     END.
     FIND cb-tabl WHERE cb-tabl.Tabla = "20" AND
          cb-tabl.Codigo = CBDASTOS.CndCmp NO-LOCK NO-ERROR.
     IF AVAILABLE cb-tabl THEN 
        DISPLAY cb-tabl.Nombre @ F-DesCon.
     ELSE DISPLAY "" @ F-DesCon.
     x-Condic = F-DesCon:SCREEN-VALUE.
     CASE cb-cmdlo.ClfAux:
       WHEN "@PV" THEN DO:
            FIND gn-prov WHERE gn-prov.CodCia = 0 AND
                 gn-prov.CodPro = CBDASTOS.Codaux NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-prov THEN
               FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA AND
                    gn-prov.CodPro = CBDASTOS.Codaux NO-LOCK NO-ERROR.
            IF AVAILABLE gn-prov THEN 
               DISPLAY gn-prov.NomPro @ F-NOMAUX. 
            ELSE DISPLAY "" @ F-NOMAUX. 
       END.
       WHEN "@CL" THEN DO:
            FIND gn-clie WHERE gn-clie.CodCia = 0 AND
                 gn-clie.CodCli = CBDASTOS.Codaux NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-clie THEN
               FIND gn-clie WHERE gn-clie.CodCia = S-CODCIA AND
                    gn-clie.CodCli = CBDASTOS.Codaux NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN 
               DISPLAY  gn-clie.NomCli @ F-NOMAUX.
            ELSE DISPLAY "" @ F-NOMAUX. 
       END.
       WHEN "@CT"  THEN DO:
            FIND CB-CTAS WHERE CB-CTAS.CodCia = 0 AND
                 CB-CTAS.CodCta = CBDASTOS.Codaux NO-LOCK NO-ERROR.
            IF NOT AVAILABLE CB-CTAS THEN 
               FIND CB-CTAS WHERE CB-CTAS.CodCia = S-CODCIA AND
                    CB-CTAS.CodCta = CBDASTOS.Codaux NO-LOCK NO-ERROR.
            IF AVAILABLE CB-CTAS THEN 
               DISPLAY CB-CTAS.NomCta @ F-NOMAUX.
            ELSE DISPLAY "" @ F-NOMAUX. 
       END.  
       OTHERWISE DO:
            FIND cb-auxi WHERE cb-auxi.CodCia = 0 AND
                 cb-auxi.ClfAux = cb-cmdlo.ClfAux AND
                 cb-auxi.CodAux = CBDASTOS.Codaux NO-LOCK NO-ERROR.
            IF NOT AVAILABLE cb-auxi THEN
               FIND cb-auxi WHERE cb-auxi.CodCia = S-CODCIA AND
                    cb-auxi.ClfAux = cb-cmdlo.ClfAux AND
                    cb-auxi.CodAux = CBDASTOS.Codaux NO-LOCK NO-ERROR.
            IF AVAILABLE CB-AUXI THEN 
               DISPLAY cb-auxi.NomAux @ F-NomAux.
            ELSE DISPLAY "" @ F-NOMAUX. 
       END.
     END CASE.
     X-NOMAUX  = F-NomAux:SCREEN-VALUE.

     DISPLAY cb-cmdlo.Referencia[1]
             cb-cmdlo.Referencia[2]
             cb-cmdlo.Referencia[3]
             cb-cmdlo.Referencia[4]
             cb-cmdlo.Referencia[5]
             cb-cmdlo.Referencia[6]
             cb-cmdlo.Referencia[7]
             cb-cmdlo.Referencia[9]
             cb-cmdlo.Referencia[10]
             cb-cmdlo.Concepto[1]
             cb-cmdlo.Concepto[2]
             cb-cmdlo.Concepto[3]
             cb-cmdlo.Concepto[4]
             cb-cmdlo.Concepto[5]
             cb-cmdlo.Concepto[6]
             cb-cmdlo.Concepto[7]
             cb-cmdlo.Concepto[8]
             cb-cmdlo.Concepto[9]
             cb-cmdlo.Concepto[10].
     CBDASTOS.Nroref:SCREEN-VALUE = CBDASTOS.Nroref.
  END.
/*  x-totafe1 = 0.
  x-totexo1 = 0.
  x-totafe2 = 0.
  x-totexo2 = 0. */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  DEFINE VARIABLE answer AS LOGICAL NO-UNDO.
  SYSTEM-DIALOG PRINTER-SETUP UPDATE answer.
  IF NOT answer THEN RETURN.
  RUN Imprime-Voucher.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
        
  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  L-CREA = (RETURN-VALUE = "YES").
            
  /* Dispatch standard ADM method.                             */
     RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  RUN Carga-Temporal.
            
  IF RETURN-VALUE NE "ADM-ERROR" THEN DO:
     
     IF NOT L-Crea THEN RUN Borra-Detalle.
     RUN Genera-Cabecera.
     RUN Genera-Detalle.
                                   
     /* RUN dispatch IN THIS-PROCEDURE ('imprime':U). */      
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "cco"    THEN ASSIGN input-var-1 = "CCO".
        WHEN "CodDoc" THEN ASSIGN input-var-1 = "02".
        WHEN "CodRef" THEN ASSIGN input-var-1 = "02".
        WHEN "DisCCo" THEN ASSIGN input-var-1 = "15".
        WHEN "CndCmp" THEN ASSIGN input-var-1 = "20".
        WHEN "NoAntcpo" THEN ASSIGN input-var-1 = CBDASTOS.Codaux:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        /*
            ASSIGN
                input-var-1 = ""
                input-var-2 = ""
                input-var-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "CBDASTOS"}
  {src/adm/template/snd-list.i "cb-cmdlo"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
     IF L-MESCIE THEN DO:
        MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
     END.
     cbdastos.CodMon:SENSITIVE = YES.
     FIND cb-oper WHERE cb-oper.CodCia = S-CODCIA AND
          cb-oper.Codope = cb-cmdlo.CodOpe NO-LOCK NO-ERROR.
     IF NOT AVAILABLE cb-oper THEN
        FIND cb-oper WHERE cb-oper.CodCia = 0 AND
             cb-oper.Codope = cb-cmdlo.CodOpe NO-LOCK NO-ERROR.
     IF AVAILABLE cb-oper AND cb-oper.Codmon < 3 THEN DO:
        cbdastos.CodMon:SENSITIVE = NO.
     END.
     L-CREA = NO.
     
     x-guialm  = ''.
     
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE F-IMP AS DECIMAL EXTENT 2.
DEFINE VARIABLE F-VAL AS DECIMAL.
DEFINE VARIABLE crpta AS LOGICAL NO-UNDO.
x-DbeSol = 0.
x-HbeSol = 0.
x-DbeDol = 0.
x-HbeDol = 0.
DO WITH FRAME {&FRAME-NAME} :
   IF L-MESCIE THEN DO:
      MESSAGE ".. MES CERRADO .." VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
   END.
   FIND GN-DIVI WHERE GN-DIVI.CodCia = S-CODCIA AND
        GN-DIVI.CodDiv = CBDASTOS.CodDiv:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF NOT AVAILABLE GN-DIVI THEN DO:
      MESSAGE "Codigo de division no Registrado" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CBDASTOS.CodDiv.
      RETURN "ADM-ERROR".
   END.
   
   FOR EACH cb-dmdlo WHERE cb-dmdlo.CodMod = cb-cmdlo.CodMod:
       CASE cb-dmdlo.Importe:
            WHEN "V1" THEN F-VAL = DECIMAL(CBDASTOS.V1:SCREEN-VALUE).
            WHEN "V2" THEN F-VAL = DECIMAL(CBDASTOS.V2:SCREEN-VALUE).
            WHEN "V3" THEN F-VAL = DECIMAL(CBDASTOS.V3:SCREEN-VALUE).
            WHEN "V4" THEN F-VAL = DECIMAL(CBDASTOS.V4:SCREEN-VALUE).
            WHEN "V5" THEN F-VAL = DECIMAL(CBDASTOS.V5:SCREEN-VALUE).
            WHEN "V6" THEN F-VAL = DECIMAL(CBDASTOS.V6:SCREEN-VALUE).
            WHEN "V7" THEN F-VAL = DECIMAL(CBDASTOS.V7:SCREEN-VALUE).
            WHEN "V8" THEN F-VAL = DECIMAL(CBDASTOS.V8:SCREEN-VALUE).
            WHEN "V9" THEN F-VAL = DECIMAL(CBDASTOS.V9:SCREEN-VALUE).
            WHEN "V0" THEN F-VAL = DECIMAL(CBDASTOS.V0:SCREEN-VALUE).
            OTHERWISE F-VAL = VALOR-F ( 2, cb-dmdlo.Importe ).
       END CASE.
       IF F-VAL <= 0 THEN NEXT.
       IF INTEGER(CBDASTOS.CodMon:SCREEN-VALUE) = 1 THEN DO:
          ASSIGN F-IMP[1] = F-VAL.
          IF DECIMAL(CBDASTOS.TpoCmb:SCREEN-VALUE) > 0 THEN 
             ASSIGN F-IMP[2] = ROUND(F-VAL / DECIMAL(CBDASTOS.TpoCmb:SCREEN-VALUE),2).
          ELSE ASSIGN F-IMP[2] = 0.
       END.
       ELSE DO:
           ASSIGN F-IMP[1] = ROUND(F-VAL * DECIMAL(CBDASTOS.TpoCmb:SCREEN-VALUE),2).
                  F-IMP[2] = F-VAL.
       END.
       IF cb-dmdlo.TpoMov THEN x-HbeSol = x-HbeSol + F-IMP[1].
       ELSE x-DbeSol = x-DbeSol + F-IMP[1].        
       IF cb-dmdlo.TpoMov THEN x-HbeDol = x-HbeDol + F-IMP[2].
       ELSE x-DbeDol = x-DbeDol + F-IMP[2].        
   END.

   IF (cb-cmdlo.codmod = 1 OR cb-cmdlo.codmod = 2) AND (x-totafe1 > 0 OR x-totafe2 > 0 OR
      x-totexo1 > 0 OR x-totexo2 > 0) THEN 
      IF INPUT CBDASTOS.codmon = 1 THEN DO:
         IF ABSOLUTE(DECIMAL(CBDASTOS.V1:SCREEN-VALUE) - x-totafe1) > 1  THEN DO:
            MESSAGE 'Existe diferencia con el Total Afecto de Ingreso en Almacen' SKIP
                    'S/. ' ABSOLUTE(DECIMAL(CBDASTOS.V1:SCREEN-VALUE) - x-totafe1) SKIP
                    'Desea aceptar la diferencia ?' 
                    VIEW-AS ALERT-BOX QUESTION BUTTONS Yes-No TITLE ' '
                    UPDATE crpta .        
            IF NOT crpta  THEN DO:
               APPLY "ENTRY" TO CBDASTOS.V1.
               RETURN "ADM-ERROR".
            END.
         END.
         IF ABSOLUTE(DECIMAL(CBDASTOS.V2:SCREEN-VALUE) - x-totexo1) > 1  THEN DO:
            MESSAGE 'Existe diferencia con el Total Exonerado de Ingreso en Almacen' SKIP
                    'S/. ' ABSOLUTE(DECIMAL(CBDASTOS.V2:SCREEN-VALUE) - x-totexo1) SKIP
                    'Desea aceptar la diferencia?'
                    VIEW-AS ALERT-BOX QUESTION BUTTONS Yes-No TITLE ' '
                    UPDATE crpta.        
            IF NOT crpta THEN DO:
               APPLY "ENTRY" TO CBDASTOS.V2.
               RETURN "ADM-ERROR".
            END.
         END.
         END.
      ELSE DO:
         IF ABSOLUTE(DECIMAL(CBDASTOS.V1:SCREEN-VALUE) - x-totafe2) > 1  THEN DO:
            MESSAGE 'Existe diferencia con el Total Afecto de Ingreso en Almacen' SKIP
                    'US$ ' ABSOLUTE(DECIMAL(CBDASTOS.V1:SCREEN-VALUE) - x-totafe2)
                    'Desea aceptar la diferencia ?' 
                    VIEW-AS ALERT-BOX QUESTION BUTTONS Yes-No TITLE ' '
                    UPDATE crpta .        
            IF NOT crpta  THEN DO:
               APPLY "ENTRY" TO CBDASTOS.V1.
               RETURN "ADM-ERROR".
            END.
         END.
         IF ABSOLUTE(DECIMAL(CBDASTOS.V2:SCREEN-VALUE) - x-totexo2) > 1  THEN DO:
            MESSAGE 'Existe diferencia con el Total Exonerado de Ingreso en Almacen' SKIP
                    'US$ ' ABSOLUTE(DECIMAL(CBDASTOS.V2:SCREEN-VALUE) - x-totexo2)
                    'Desea aceptar la diferencia ?' 
                    VIEW-AS ALERT-BOX QUESTION BUTTONS Yes-No TITLE ' '
                    UPDATE crpta .
            IF NOT crpta  THEN DO:
               APPLY "ENTRY" TO CBDASTOS.V2.
               RETURN "ADM-ERROR".
            END.
         END.
      END.

   IF (ABSOLUTE(x-DbeSol - x-HbeSol) > 0 AND 
      INTEGER(CBDASTOS.CodMon:SCREEN-VALUE) = 1) OR
      (ABSOLUTE(x-DbeDol - x-HbeDol) > 0 AND 
      INTEGER(CBDASTOS.CodMon:SCREEN-VALUE) = 2) THEN DO:
      IF INTEGER(CBDASTOS.CodMon:SCREEN-VALUE) = 1 THEN
         MESSAGE "Movimiento des-balanceado " SKIP
                 "S/. " ABSOLUTE(x-DbeSol - x-HbeSol) VIEW-AS ALERT-BOX ERROR.
      ELSE
         MESSAGE "Movimiento des-balanceado " SKIP
                 "US$ " ABSOLUTE(x-DbeDol - x-HbeDol) VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CBDASTOS.Notast.
      RETURN "ADM-ERROR".
   END.
   IF ABSOLUTE(x-DbeSol - x-HbeSol) > .05 OR
      ABSOLUTE(x-DbeDol - x-HbeDol) > .05  THEN DO:
      MESSAGE "Movimiento des-balanceado" SKIP
               "S/. " ABSOLUTE(x-DbeSol - x-HbeSol) SKIP
               "US$ " ABSOLUTE(x-DbeDol - x-HbeDol) VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CBDASTOS.Notast.
      RETURN "ADM-ERROR".
   END.
   IF ((x-DbeSol + x-HbeSol) = 0 AND INTEGER(CBDASTOS.CodMon:SCREEN-VALUE) = 1) OR
      ((x-DbeDol + x-HbeDol) = 0 AND INTEGER(CBDASTOS.CodMon:SCREEN-VALUE) = 2) THEN DO:
      MESSAGE "Movimiento con importes en cero" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO CBDASTOS.Notast.
      RETURN "ADM-ERROR".
   END.
   X-NomAux = F-NOMAUX:SCREEN-VALUE.
   x-Condic = F-DesCon:SCREEN-VALUE.

END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION VALOR-C V-table-Win 
FUNCTION VALOR-C RETURNS CHARACTER
  ( INPUT I-PAR AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR O-PAR AS CHAR NO-UNDO.

CASE I-PAR:
     WHEN "C1" THEN O-PAR = CBDASTOS.C1.
     WHEN "C2" THEN O-PAR = CBDASTOS.C2.
     WHEN "C3" THEN O-PAR = CBDASTOS.C3.
     WHEN "C4" THEN O-PAR = CBDASTOS.C4.
     WHEN "C5" THEN O-PAR = CBDASTOS.C5.
     WHEN "C6" THEN O-PAR = CBDASTOS.C6.
     OTHERWISE O-PAR = I-PAR.
END CASE.

  RETURN O-PAR.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION VALOR-F V-table-Win 
FUNCTION VALOR-F RETURNS DECIMAL
  ( INPUT O-TIPO AS INTEGER,
    INPUT FORMULA AS CHAR  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VAR VALOR-C AS CHAR.
DEFINE VAR VALOR-N AS DECIMAL.
DEFINE VAR VALOR-CA AS DECIMAL.
DEFINE VAR PROCESA AS LOGICAL.
DEFINE VAR S-SIGNO AS CHAR.
DEFINE VAR I AS INTEGER.

VALOR-N = 0.
S-SIGNO = "".
PROCESA = FALSE.
DO i = 1 TO NUM-ENTRIES(FORMULA," " ) :
   VALOR-C = ENTRY(i, FORMULA, " " ).   
   IF VALOR-C BEGINS "V" THEN DO :
      IF O-TIPO = 1 THEN VALOR-N = VALOR-V(VALOR-C).
         ELSE VALOR-N = VALOR-SCREEN(VALOR-C).
   END.   
   ELSE DO :
       IF LOOKUP(VALOR-C,"+,-,*,/") > 0 THEN S-SIGNO = VALOR-C.   
           ELSE VALOR-N = DECIMAL(VALOR-C). 
   END.  
   IF I = 1 THEN VALOR-CA = VALOR-N.   
   IF PROCESA THEN DO :         
      CASE S-SIGNO :     
           WHEN "+" THEN VALOR-CA = ( VALOR-CA + VALOR-N ).
           WHEN "-" THEN VALOR-CA = ( VALOR-CA - VALOR-N ).
           WHEN "*" THEN VALOR-CA = ( VALOR-CA * VALOR-N ).
           WHEN "/" THEN VALOR-CA = ( VALOR-CA / VALOR-N ).
      END CASE.           
   END.       
   
   IF LOOKUP(VALOR-C,"+,-,*,/") > 0 THEN PROCESA = TRUE.
      ELSE PROCESA = FALSE.         
END.

  RETURN VALOR-CA.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION VALOR-SCREEN V-table-Win 
FUNCTION VALOR-SCREEN RETURNS DECIMAL
  ( INPUT I-PAR AS CHAR ) :  
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VAR F-REL AS DECIMAL.
DO WITH FRAME {&FRAME-NAME} :
    CASE I-PAR:
         WHEN "V1" THEN F-REL = DECIMAL(CBDASTOS.V1:SCREEN-VALUE).
         WHEN "V2" THEN F-REL = DECIMAL(CBDASTOS.V2:SCREEN-VALUE).
         WHEN "V3" THEN F-REL = DECIMAL(CBDASTOS.V3:SCREEN-VALUE).
         WHEN "V4" THEN F-REL = DECIMAL(CBDASTOS.V4:SCREEN-VALUE).
         WHEN "V5" THEN F-REL = DECIMAL(CBDASTOS.V5:SCREEN-VALUE).
         WHEN "V6" THEN F-REL = DECIMAL(CBDASTOS.V6:SCREEN-VALUE).
         WHEN "V7" THEN F-REL = DECIMAL(CBDASTOS.V7:SCREEN-VALUE).
         WHEN "V8" THEN F-REL = DECIMAL(CBDASTOS.V8:SCREEN-VALUE).
         WHEN "V9" THEN F-REL = DECIMAL(CBDASTOS.V9:SCREEN-VALUE).
         WHEN "V0" THEN F-REL = DECIMAL(CBDASTOS.V0:SCREEN-VALUE).
         OTHERWISE F-REL = 0.
    END CASE.
END.
RETURN F-REL.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION VALOR-V V-table-Win 
FUNCTION VALOR-V RETURNS DECIMAL
  ( INPUT I-PAR AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VAR O-PAR AS DECIMAL NO-UNDO.
CASE I-PAR:
     WHEN "V1" THEN O-PAR = CBDASTOS.V1.
     WHEN "V2" THEN O-PAR = CBDASTOS.V2.
     WHEN "V3" THEN O-PAR = CBDASTOS.V3.
     WHEN "V4" THEN O-PAR = CBDASTOS.V4.
     WHEN "V5" THEN O-PAR = CBDASTOS.V5.
     WHEN "V6" THEN O-PAR = CBDASTOS.V6.
     WHEN "V7" THEN O-PAR = CBDASTOS.V7.
     WHEN "V8" THEN O-PAR = CBDASTOS.V8.
     WHEN "V9" THEN O-PAR = CBDASTOS.V9.
     WHEN "V0" THEN O-PAR = CBDASTOS.V0.
     OTHERWISE O-PAR = 0.
END CASE.

  RETURN O-PAR.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

