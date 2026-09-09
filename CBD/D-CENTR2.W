&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral          PROGRESS
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
{cbd/cbglobal.i}
SESSION:DATE-FORMAT = "dmy".

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INTEGER.
DEFINE VAR x-periodo AS INTEGER NO-UNDO.
DEFINE VAR x-nromes  AS INTEGER NO-UNDO.
DEFINE VAR x-reg     AS RAW     NO-UNDO.
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE TEMP-TABLE T-CMOV LIKE T-CB-CMOV.
DEFINE TEMP-TABLE T-DMOV LIKE T-CB-DMOV.
DEFINE BUFFER DETALLE FOR CB-DMOV.

FIND FIRST cb-cfga WHERE cb-cfga.CodCia = cb-codcia AND cb-cfga.CodCfg = 1
   NO-LOCK  NO-ERROR.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(60)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
     WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
          SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
          BGCOLOR 15 FGCOLOR 0 
          TITLE "Procesando ..." FONT 7.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME B-Local

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-cfgt

/* Definitions for BROWSE B-Local                                       */
&Scoped-define FIELDS-IN-QUERY-B-Local cb-cfgt.Local cb-cfgt.DesLoc ~
cb-cfgt.CodDiv cb-cfgt.Codope 
&Scoped-define ENABLED-FIELDS-IN-QUERY-B-Local 
&Scoped-define FIELD-PAIRS-IN-QUERY-B-Local
&Scoped-define OPEN-QUERY-B-Local OPEN QUERY B-Local FOR EACH cb-cfgt ~
      WHERE cb-cfgt.Codcia = s-codcia SHARE-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-B-Local cb-cfgt
&Scoped-define FIRST-TABLE-IN-QUERY-B-Local cb-cfgt


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-B-Local}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-43 Btn_OK F-Desde F-Hasta Btn_Cancel ~
B-Local 
&Scoped-Define DISPLAYED-OBJECTS F-Desde F-Hasta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "OK" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE F-Desde AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Fecha Inicial" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-Hasta AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Final" 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 66.57 BY 1.62.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY B-Local FOR 
      cb-cfgt SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE B-Local
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS B-Local D-Dialog _STRUCTURED
  QUERY B-Local SHARE-LOCK NO-WAIT DISPLAY
      cb-cfgt.Local COLUMN-LABEL "Local" FORMAT "X(5)"
      cb-cfgt.DesLoc FORMAT "X(20)"
      cb-cfgt.CodDiv COLUMN-LABEL "Divisionaria" FORMAT "x(30)"
      cb-cfgt.Codope COLUMN-LABEL "Operaci¢n" FORMAT "X(30)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS MULTIPLE SIZE 66.43 BY 5
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn_OK AT ROW 8 COL 20.86
     F-Desde AT ROW 6.62 COL 17.29 COLON-ALIGNED
     F-Hasta AT ROW 6.65 COL 37 COLON-ALIGNED
     Btn_Cancel AT ROW 8 COL 35
     B-Local AT ROW 1.12 COL 1
     RECT-43 AT ROW 6.19 COL 1
     SPACE(0.00) SKIP(1.87)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Centralizaci¢n".

 

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
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE B-Local
/* Query rebuild information for BROWSE B-Local
     _TblList          = "integral.cb-cfgt"
     _Options          = "SHARE-LOCK INDEXED-REPOSITION"
     _Where[1]         = "integral.cb-cfgt.Codcia = s-codcia"
     _FldNameList[1]   > integral.cb-cfgt.Local
"cb-cfgt.Local" "Local" "X(5)" "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > integral.cb-cfgt.DesLoc
"cb-cfgt.DesLoc" ? "X(20)" "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > integral.cb-cfgt.CodDiv
"cb-cfgt.CodDiv" "Divisionaria" "x(30)" "character" ? ? ? ? ? ? no ?
     _FldNameList[4]   > integral.cb-cfgt.Codope
"cb-cfgt.Codope" "Operaci¢n" "X(30)" "character" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE B-Local */
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
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Centralizaci¢n */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
  ASSIGN
     F-Desde F-Hasta.
  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS = 0 THEN DO:
     MESSAGE 'No se encuetra seleccionado ningun local' VIEW-AS ALERT-BOX.
     APPLY 'ENTRY':U TO B-Local.
     RETURN NO-APPLY.
  END.
  RUN Transferencia.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME B-Local
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
  DISPLAY F-Desde F-Hasta 
      WITH FRAME D-Dialog.
  ENABLE RECT-43 Btn_OK F-Desde F-Hasta Btn_Cancel B-Local 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Automatica D-Dialog 
PROCEDURE Genera-Automatica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR x-GenAut AS INTEGER.
    DEFINE VAR i        AS INTEGER INIT 1.
    /* Grabamos datos para la generaci¢n de Cuentas Autom ticas */
    x-GenAut  = 0.

    FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia AND
                       cb-ctas.CodCta = cb-dmov.CodCta NO-LOCK NO-ERROR.
       
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut9 ):

        IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut9 ) 
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut9) <> ""
            THEN DO:
                x-GenAut = 1.
                LEAVE.
            END.                                              
        END.
    END.
    /* Verificamos si la Cuenta genera automaticas de Clase 6 */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut6 ):
        IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut6 ) 
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut6) <> ""
            THEN DO:
                x-GenAut = 2.
                LEAVE.
            END.
       END.
    END.
    /* Verificamos si la Cuenta genera automaticas de otro tipo */
    DO i = 1 TO NUM-ENTRIES( cb-cfga.GenAut ):
        IF cb-dmov.CodCta BEGINS ENTRY( i, cb-cfga.GenAut )
        THEN DO:
            IF ENTRY( i, cb-cfga.GenAut) <> ""
            THEN DO:
                x-GenAut = 3.
                LEAVE.
            END.
       END.
    END.
    ASSIGN cb-dmov.CtaAut = ""
           cb-dmov.CtrCta = "".
    
    CASE x-GenAut:
        /* Genera Cuentas Clase 9 */
        WHEN 1 THEN DO:
             ASSIGN cb-dmov.CtrCta    = cb-ctas.Cc1Cta.
             IF cb-ctas.CLFAUX = "@CT" THEN 
                cb-dmov.CtaAut = cb-dmov.CodAux.
             ELSE
                cb-dmov.CtaAut = cb-ctas.An1Cta.
             IF cb-dmov.CtrCta = ""  THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta9.
             
        END.
        /* Genera Cuentas Clase 6 */
        WHEN 2 THEN DO:
                        ASSIGN cb-dmov.CtaAut = cb-ctas.An1Cta
                               cb-dmov.CtrCta = cb-ctas.Cc1Cta.
                        IF cb-dmov.CtrCta = ""
                        THEN cb-dmov.CtrCta = cb-cfga.Cc1Cta6.
                    END.
        WHEN 3 THEN DO:
                        ASSIGN cb-dmov.CtaAut = cb-ctas.An1Cta
                               cb-dmov.CtrCta = cb-ctas.Cc1Cta.
                    END.
    END CASE.

/* Generando las cuentas autom ticas */
IF cb-dmov.CtrCta <> "" THEN DO:
    FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = cb-codcia
        AND integral.cb-ctas.CodCta = cb-dmov.CodCta
        NO-LOCK NO-ERROR.
        IF cb-dmov.CtaAut <> ""
        THEN DO:
            CREATE DETALLE.
            ASSIGN DETALLE.CodCia   = cb-dmov.CodCia
                   DETALLE.Periodo  = cb-dmov.Periodo
                   DETALLE.NroMes   = cb-dmov.NroMes
                   DETALLE.CodOpe   = cb-dmov.CodOpe
                   DETALLE.NroAst   = cb-dmov.NroAst
                   DETALLE.TpoItm   = "A"
                   DETALLE.Relacion = RECID(cb-dmov)
                   DETALLE.CodMon   = cb-dmov.CodMon
                   DETALLE.TpoCmb   = cb-dmov.TpoCmb
                   DETALLE.NroItm   = cb-dmov.nroitm + 1
                   DETALLE.Codcta   = cb-dmov.CtaAut
                   DETALLE.CodDiv   = cb-dmov.CodDiv
                   DETALLE.ClfAux   = cb-dmov.ClfAux
                   DETALLE.CodAux   = cb-dmov.CodCta
                   DETALLE.NroRuc   = cb-dmov.NroRuc
                   DETALLE.CodDoc   = cb-dmov.CodDoc
                   DETALLE.NroDoc   = cb-dmov.NroDoc
                   DETALLE.GloDoc   = cb-dmov.GloDoc
                   DETALLE.CodMon   = cb-dmov.CodMon
                   DETALLE.TpoCmb   = cb-dmov.TpoCmb
                   DETALLE.TpoMov   = cb-dmov.TpoMov
                   DETALLE.NroRef   = cb-dmov.NroRef
                   DETALLE.FchDoc   = cb-dmov.FchDoc
                   DETALLE.FchVto   = cb-dmov.FchVto
                   DETALLE.ImpMn1   = cb-dmov.ImpMn1
                   DETALLE.ImpMn2   = cb-dmov.ImpMn2
                   DETALLE.ImpMn3   = cb-dmov.ImpMn3
                   DETALLE.Tm       = cb-dmov.Tm
                   DETALLE.CCO      = cb-dmov.CCO.
                   RUN cbd/cb-acmd.p(RECID(detalle), YES ,YES).
        END.
         
    CREATE DETALLE.
    ASSIGN DETALLE.CodCia   = cb-dmov.CodCia
           DETALLE.Periodo  = cb-dmov.Periodo
           DETALLE.NroMes   = cb-dmov.NroMes
           DETALLE.CodOpe   = cb-dmov.CodOpe
           DETALLE.NroAst   = cb-dmov.NroAst
           DETALLE.TpoItm   = "A"
           DETALLE.Relacion = RECID(cb-dmov)
           DETALLE.CodMon   = cb-dmov.CodMon
           DETALLE.TpoCmb   = cb-dmov.TpoCmb
           DETALLE.NroItm   = cb-dmov.nroitm + 2
           DETALLE.Codcta   = cb-dmov.Ctrcta
           DETALLE.CodDiv   = cb-dmov.CodDiv
           DETALLE.ClfAux   = cb-dmov.ClfAux
           DETALLE.CodAux   = cb-dmov.CodCta
           DETALLE.NroRuc   = cb-dmov.NroRuc
           DETALLE.CodDoc   = cb-dmov.CodDoc
           DETALLE.NroDoc   = cb-dmov.NroDoc
           DETALLE.GloDoc   = cb-dmov.GloDoc
           DETALLE.CodMon   = cb-dmov.CodMon
           DETALLE.TpoCmb   = cb-dmov.TpoCmb
           DETALLE.TpoMov   = NOT cb-dmov.TpoMov
           DETALLE.ImpMn1   = cb-dmov.ImpMn1
           DETALLE.ImpMn2   = cb-dmov.ImpMn2
           DETALLE.ImpMn3   = cb-dmov.ImpMn3
           DETALLE.NroRef   = cb-dmov.NroRef
           DETALLE.FchDoc   = cb-dmov.FchDoc
           DETALLE.FchVto   = cb-dmov.FchVto
           DETALLE.Tm       = cb-dmov.Tm
           DETALLE.CCO      = cb-dmov.CCO.
           RUN cbd/cb-acmd.p(RECID(detalle), YES ,YES).
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
  /* Por cada local remoto existir  un registro que identifica las
     caracteristicas del local                                 */
  FIND FIRST cb-cfgt WHERE cb-cfgt.codcia = s-codcia NO-LOCK NO-ERROR.
  IF AVAILABLE cb-cfgt THEN
     DO WITH FRAME {&FRAME-NAME}:
        IF cb-cfgt.fchcen = ? THEN
           DISPLAY 
              TODAY @ F-Desde
              TODAY @ F-Hasta.
        ELSE
           DISPLAY 
              cb-cfgt.fchcen + 1 @ F-Desde
              cb-cfgt.fchcen + 1 @ F-Hasta.
     END.
  ELSE DO:
     MESSAGE 'Configuracion no existe' VIEW-AS ALERT-BOX.
     RUN dispatch IN THIS-PROCEDURE ('exit':U).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
PROCEDURE Procesa-Parametros :
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
PROCEDURE Recoge-Parametros :
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
        WHEN "" THEN ASSIGN input-var-1 = "".
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

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
  {src/adm/template/snd-list.i "cb-cfgt"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Transferencia D-Dialog 
PROCEDURE Transferencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR i       AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VAR x-fecha AS DATE NO-UNDO.
DEFINE VAR y       AS DATE NO-UNDO.

DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
   IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i)THEN 
      IF F-Desde > cb-cfgt.FchCen OR cb-cfgt.FchCen = ? THEN DO:
        DO y = F-Desde TO F-Hasta:
           DO i = 1 TO NUM-ENTRIES(cb-cfgt.codope):
              FOR EACH t-cb-cmov WHERE t-cb-cmov.Codcia = s-codcia AND 
                  t-cb-cmov.Periodo = s-periodo AND
                  t-cb-cmov.Nromes = s-nromes AND 
                  t-cb-cmov.Codope = ENTRY(i,cb-cfgt.codope) AND
                  t-cb-cmov.Fchast = y AND
                  t-cb-cmov.Tipo   = cb-cfgt.local AND
                  t-cb-cmov.flgtra = FALSE :
                  FI-MENSAJE = "     Operacion : " + t-cb-cmov.codope + " Nro.Asiento : " + 
                               t-cb-cmov.nroast.
                  DISPLAY FI-MENSAJE WITH FRAME F-PROCESO.
                  CREATE cb-cmov.
                  ASSIGN
                     cb-cmov.C-Fcaja = t-cb-cmov.C-Fcaja 
                     cb-cmov.Codaux = t-cb-cmov.Codaux 
                     cb-cmov.Codcia = t-cb-cmov.Codcia 
                     cb-cmov.CodDiv = t-cb-cmov.CodDiv 
                     cb-cmov.Coddoc = t-cb-cmov.Coddoc 
                     cb-cmov.Codmon = t-cb-cmov.Codmon 
                     cb-cmov.Codope = t-cb-cmov.Codope 
                     cb-cmov.Ctacja = t-cb-cmov.Ctacja 
                     cb-cmov.DbeMn1 = t-cb-cmov.DbeMn1 
                     cb-cmov.DbeMn2 = t-cb-cmov.DbeMn2 
                     cb-cmov.DbeMn3 = t-cb-cmov.DbeMn3 
                     cb-cmov.Fchast = t-cb-cmov.Fchast 
                     cb-cmov.FchMod = t-cb-cmov.FchMod 
                     cb-cmov.Flgest = t-cb-cmov.Flgest 
                     cb-cmov.FlgTra = t-cb-cmov.FlgTra 
                     cb-cmov.Girado = t-cb-cmov.Girado 
                     cb-cmov.GloAst = t-cb-cmov.GloAst 
                     cb-cmov.HbeMn1 = t-cb-cmov.HbeMn1 
                     cb-cmov.HbeMn2 = t-cb-cmov.HbeMn2 
                     cb-cmov.HbeMn3 = t-cb-cmov.HbeMn3 
                     cb-cmov.Impchq = t-cb-cmov.Impchq 
                     cb-cmov.Notast = t-cb-cmov.Notast 
                     cb-cmov.Nroast = t-cb-cmov.Nroast 
                     cb-cmov.Nrochq = t-cb-cmov.Nrochq 
                     cb-cmov.Nromes = t-cb-cmov.Nromes 
                     cb-cmov.NroTra = t-cb-cmov.NroTra 
                     cb-cmov.Nrovou = t-cb-cmov.Nrovou 
                     cb-cmov.Periodo = t-cb-cmov.Periodo 
                     cb-cmov.Totitm = t-cb-cmov.Totitm 
                     cb-cmov.Tpocmb = t-cb-cmov.Tpocmb 
                     cb-cmov.Usuario = t-cb-cmov.Usuario.
                  FOR EACH t-cb-dmov WHERE t-cb-dmov.CodCia = s-codcia AND
                      t-cb-dmov.Periodo = t-cb-cmov.periodo AND 
                      t-cb-dmov.NroMes = t-cb-cmov.nromes AND
                      t-cb-dmov.Codope = t-cb-cmov.codope AND
                      t-cb-dmov.Nroast = t-cb-cmov.nroast AND 
                      t-cb-dmov.tpoitm <> 'A' EXCLUSIVE:
                      CREATE cb-dmov.
                      ASSIGN
                         cb-dmov.C-Fcaja = t-cb-dmov.C-Fcaja 
                         cb-dmov.cco     = t-cb-dmov.cco 
                         cb-dmov.Clfaux = t-cb-dmov.Clfaux 
                         cb-dmov.CndCmp = t-cb-dmov.CndCmp 
                         cb-dmov.Codaux = t-cb-dmov.Codaux 
                         cb-dmov.CodBco = t-cb-dmov.CodBco 
                         cb-dmov.CodCia = t-cb-dmov.CodCia 
                         cb-dmov.Codcta = t-cb-dmov.Codcta 
                         cb-dmov.CodDiv = t-cb-dmov.CodDiv 
                         cb-dmov.Coddoc = t-cb-dmov.Coddoc 
                         cb-dmov.Codmon = t-cb-dmov.Codmon 
                         cb-dmov.Codope = t-cb-dmov.Codope 
                         cb-dmov.Codref = t-cb-dmov.Codref 
                         cb-dmov.CtaAut = t-cb-dmov.CtaAut 
                         cb-dmov.CtrCta = t-cb-dmov.CtrCta 
                         cb-dmov.DisCCo = t-cb-dmov.DisCCo 
                         cb-dmov.Fchdoc = t-cb-dmov.Fchdoc 
                         cb-dmov.Fchvto = t-cb-dmov.Fchvto 
                         cb-dmov.flgact = t-cb-dmov.flgact 
                         cb-dmov.Glodoc = t-cb-dmov.Glodoc 
                         cb-dmov.ImpMn1 = t-cb-dmov.ImpMn1 
                         cb-dmov.ImpMn2 = t-cb-dmov.ImpMn2 
                         cb-dmov.ImpMn3 = t-cb-dmov.ImpMn3 
                         cb-dmov.Nroast = t-cb-dmov.Nroast 
                         cb-dmov.Nrodoc = t-cb-dmov.Nrodoc 
                         cb-dmov.Nroitm = t-cb-dmov.Nroitm 
                         cb-dmov.NroMes = t-cb-dmov.NroMes 
                         cb-dmov.Nroref = t-cb-dmov.Nroref 
                         cb-dmov.Nroruc = t-cb-dmov.Nroruc 
                         cb-dmov.OrdCmp = t-cb-dmov.OrdCmp 
                         cb-dmov.Periodo = t-cb-dmov.Periodo 
                         cb-dmov.rel-ac-cb = t-cb-dmov.rel-ac-cb 
                         cb-dmov.Relacion = t-cb-dmov.Relacion 
                         cb-dmov.tm     = t-cb-dmov.tm 
                         cb-dmov.Tpocmb = t-cb-dmov.Tpocmb 
                         cb-dmov.TpoItm = t-cb-dmov.TpoItm 
                         cb-dmov.TpoMov = t-cb-dmov.TpoMov.
                         RUN cbd/cb-acmd.p(RECID(CB-DMOV),YES,YES).
                         RUN Genera-Automatica.
                  END.
                  ASSIGN
                     t-cb-cmov.flgtra = TRUE.
              END.
           END.
        END.
        ASSIGN
           cb-cfgt.fchcen = F-Hasta.
        END.
     ELSE DO:
        MESSAGE 'Local : ' + cb-cfgt.local + ' ' + cb-cfgt.desloc SKIP
                'Fecha de Proceso ' + STRING(F-Desde ) SKIP
                'debe ser mayor a ' + STRING(cb-cfgt.fchcen) VIEW-AS ALERT-BOX.
     END.
END.
HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


