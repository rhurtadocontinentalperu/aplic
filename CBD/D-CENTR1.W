&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
&ANALYZE-RESUME
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

/* Verifica conecci¢n con el Local Central                              */
IF NOT CONNECTED('integral') THEN CONNECT -pf integral.pf.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INTEGER.
DEFINE SHARED VAR s-nomcia AS CHAR.
DEFINE VAR x-periodo AS INTEGER NO-UNDO.
DEFINE VAR x-nromes  AS INTEGER NO-UNDO.
DEFINE VAR x-reg     AS RAW     NO-UNDO.
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE TEMP-TABLE T-CMOV LIKE T-CB-CMOV.
DEFINE TEMP-TABLE T-DMOV LIKE T-CB-DMOV.
DEFINE BUFFER DETALLE FOR T-CB-DMOV.

FIND FIRST cb-cfga WHERE cb-cfga.CodCia = cb-codcia AND cb-cfga.CodCfg = 1
   NO-LOCK  NO-ERROR.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(50)" .

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
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS B-Carga F-Desde F-Hasta RECT-17 RECT-19 
&Scoped-Define DISPLAYED-OBJECTS F-Local F-Descri F-Divisionaria ~
F-Operacion F-Desde F-Hasta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Carga 
     IMAGE-UP FILE "img\auditor":U
     LABEL "Button 1" 
     SIZE 6.29 BY 1.5.

DEFINE BUTTON B-Imprimir 
     IMAGE-UP FILE "img\climnu3":U
     LABEL "Button 2" 
     SIZE 6.29 BY 1.5.

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\climnu1":U
     LABEL "OK" 
     SIZE 6.29 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE F-Descri AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29.43 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-Desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Inicial" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .81 NO-UNDO.

DEFINE VARIABLE F-Divisionaria AS CHARACTER FORMAT "X(256)":U 
     LABEL "Divisionarias" 
     VIEW-AS FILL-IN 
     SIZE 29 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-Hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Final" 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .81 NO-UNDO.

DEFINE VARIABLE F-Local AS CHARACTER FORMAT "xx":U 
     LABEL "Local" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-Operacion AS CHARACTER FORMAT "X(256)":U 
     LABEL "Operaciones" 
     VIEW-AS FILL-IN 
     SIZE 29.14 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43.57 BY 3.42.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43.57 BY 1.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     B-Carga AT ROW 1.15 COL 46.57
     B-Imprimir AT ROW 2.81 COL 46.57
     Btn_OK AT ROW 4.62 COL 46.57
     F-Local AT ROW 1.38 COL 7.29 COLON-ALIGNED
     F-Descri AT ROW 1.38 COL 12.86 COLON-ALIGNED NO-LABEL
     F-Divisionaria AT ROW 2.38 COL 13 COLON-ALIGNED
     F-Operacion AT ROW 3.27 COL 13 COLON-ALIGNED
     F-Desde AT ROW 4.96 COL 10.43 COLON-ALIGNED
     F-Hasta AT ROW 4.96 COL 28.72 COLON-ALIGNED
     "Carga" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 1.42 COL 55.29
     "Temporal" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 1.92 COL 54.29
     "Imprimir" VIEW-AS TEXT
          SIZE 5.86 BY .5 AT ROW 3.54 COL 54.57
     "Grabar" VIEW-AS TEXT
          SIZE 5.29 BY .5 AT ROW 4.88 COL 54.86
     "Temporal" VIEW-AS TEXT
          SIZE 7.72 BY .5 AT ROW 5.46 COL 54.57
     RECT-17 AT ROW 1 COL 1.43
     RECT-19 AT ROW 4.58 COL 1.43
     SPACE(17.29) SKIP(0.21)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Transferencia al Local Central".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON B-Imprimir IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON Btn_OK IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Descri IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Divisionaria IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Local IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Operacion IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Transferencia al Local Central */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Carga
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Carga D-Dialog
ON CHOOSE OF B-Carga IN FRAME D-Dialog /* Button 1 */
DO:
  ASSIGN
     F-Descri F-Desde F-Divisionaria F-Hasta F-Local F-Operacion.
  IF F-Operacion = '' THEN DO:
     MESSAGE 'Operaciones a transferir no han sido configuradas' VIEW-AS ALERT-BOX.
     RETURN NO-APPLY.
  END.
  IF F-Divisionaria = '' THEN DO:
     MESSAGE 'Divisionarias no han sido configuradas' VIEW-AS ALERT-BOX.
     RETURN NO-APPLY.
  END.
  B-Imprimir:SENSITIVE = FALSE.
  Btn_OK:SENSITIVE = FALSE.
  RUN Transferencia.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-Imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-Imprimir D-Dialog
ON CHOOSE OF B-Imprimir IN FRAME D-Dialog /* Button 2 */
DO:
  RUN Pre-Impresion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
  RUN Graba-Datos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Desde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Desde D-Dialog
ON LEAVE OF F-Desde IN FRAME D-Dialog /* Fecha Inicial */
DO:
  ASSIGN F-Desde.
  IF MONTH(F-Desde) <> s-nromes THEN DO:
     MESSAGE 'La fecha debe corresponder al mes del sistema' VIEW-AS ALERT-BOX ERROR.
     APPLY 'ENTRY':U TO F-Desde.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Hasta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Hasta D-Dialog
ON LEAVE OF F-Hasta IN FRAME D-Dialog /* Final */
DO:
  ASSIGN F-Hasta.
  IF MONTH(F-Hasta) <> s-nromes THEN DO:
     MESSAGE 'La fecha debe corresponder al mes del sistema' VIEW-AS ALERT-BOX ERROR.
     APPLY 'ENTRY':U TO F-Hasta.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY F-Local F-Descri F-Divisionaria F-Operacion F-Desde F-Hasta 
      WITH FRAME D-Dialog.
  ENABLE B-Carga F-Desde F-Hasta RECT-17 RECT-19 
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

    FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = cb-codcia AND
         integral.cb-ctas.CodCta = t-cb-dmov.CodCta NO-LOCK NO-ERROR.
       
    DO i = 1 TO NUM-ENTRIES( integral.cb-cfga.GenAut9 ):

        IF t-cb-dmov.CodCta BEGINS ENTRY( i, integral.cb-cfga.GenAut9 ) 
        THEN DO:
            IF ENTRY( i, integral.cb-cfga.GenAut9) <> ""
            THEN DO:
                x-GenAut = 1.
                LEAVE.
            END.                                              
        END.
    END.
    /* Verificamos si la Cuenta genera automaticas de Clase 6 */
    DO i = 1 TO NUM-ENTRIES( integral.cb-cfga.GenAut6 ):
        IF t-cb-dmov.CodCta BEGINS ENTRY( i, integral.cb-cfga.GenAut6 ) 
        THEN DO:
            IF ENTRY( i, integral.cb-cfga.GenAut6) <> ""
            THEN DO:
                x-GenAut = 2.
                LEAVE.
            END.
       END.
    END.
    /* Verificamos si la Cuenta genera automaticas de otro tipo */
    DO i = 1 TO NUM-ENTRIES( integral.cb-cfga.GenAut ):
        IF t-cb-dmov.CodCta BEGINS ENTRY( i, integral.cb-cfga.GenAut )
        THEN DO:
            IF ENTRY( i, integral.cb-cfga.GenAut) <> ""
            THEN DO:
                x-GenAut = 3.
                LEAVE.
            END.
       END.
    END.
    ASSIGN t-cb-dmov.CtaAut = ""
           t-cb-dmov.CtrCta = "".
    
    CASE x-GenAut:
        /* Genera Cuentas Clase 9 */
        WHEN 1 THEN DO:
             ASSIGN t-cb-dmov.CtrCta    = integral.cb-ctas.Cc1Cta.
             IF integral.cb-ctas.CLFAUX = "@CT" THEN 
                t-cb-dmov.CtaAut = t-cb-dmov.CodAux.
             ELSE
                t-cb-dmov.CtaAut = integral.cb-ctas.An1Cta.
             IF t-cb-dmov.CtrCta = ""  THEN t-cb-dmov.CtrCta = integral.cb-cfga.Cc1Cta9.
             
        END.
        /* Genera Cuentas Clase 6 */
        WHEN 2 THEN DO:
                        ASSIGN t-cb-dmov.CtaAut = integral.cb-ctas.An1Cta
                               t-cb-dmov.CtrCta = integral.cb-ctas.Cc1Cta.
                        IF t-cb-dmov.CtrCta = ""
                        THEN t-cb-dmov.CtrCta = integral.cb-cfga.Cc1Cta6.
                    END.
        WHEN 3 THEN DO:
                        ASSIGN t-cb-dmov.CtaAut = integral.cb-ctas.An1Cta
                               t-cb-dmov.CtrCta = integral.cb-ctas.Cc1Cta.
                    END.
    END CASE.

/* Generando las cuentas autom ticas */
IF t-cb-dmov.CtrCta <> "" THEN DO:
    FIND integral.cb-ctas WHERE integral.cb-ctas.CodCia = cb-codcia
        AND integral.cb-ctas.CodCta = t-cb-dmov.CodCta
        NO-LOCK NO-ERROR.
        IF t-cb-dmov.CtaAut <> ""
        THEN DO:
            CREATE DETALLE.
            ASSIGN DETALLE.CodCia   = t-cb-dmov.CodCia
                   DETALLE.Periodo  = t-cb-dmov.Periodo
                   DETALLE.NroMes   = t-cb-dmov.NroMes
                   DETALLE.CodOpe   = t-cb-dmov.CodOpe
                   DETALLE.NroAst   = t-cb-dmov.NroAst
                   DETALLE.TpoItm   = "A"
                   DETALLE.Relacion = RECID(t-cb-dmov)
                   DETALLE.CodMon   = t-cb-dmov.CodMon
                   DETALLE.TpoCmb   = t-cb-dmov.TpoCmb
                   DETALLE.NroItm   = t-cb-dmov.nroitm + 1
                   DETALLE.Codcta   = t-cb-dmov.CtaAut
                   DETALLE.CodDiv   = t-cb-dmov.CodDiv
                   DETALLE.ClfAux   = t-cb-dmov.ClfAux
                   DETALLE.CodAux   = t-cb-dmov.CodCta
                   DETALLE.NroRuc   = t-cb-dmov.NroRuc
                   DETALLE.CodDoc   = t-cb-dmov.CodDoc
                   DETALLE.NroDoc   = t-cb-dmov.NroDoc
                   DETALLE.GloDoc   = t-cb-dmov.GloDoc
                   DETALLE.CodMon   = t-cb-dmov.CodMon
                   DETALLE.TpoCmb   = t-cb-dmov.TpoCmb
                   DETALLE.TpoMov   = t-cb-dmov.TpoMov
                   DETALLE.NroRef   = t-cb-dmov.NroRef
                   DETALLE.FchDoc   = t-cb-dmov.FchDoc
                   DETALLE.FchVto   = t-cb-dmov.FchVto
                   DETALLE.ImpMn1   = t-cb-dmov.ImpMn1
                   DETALLE.ImpMn2   = t-cb-dmov.ImpMn2
                   DETALLE.ImpMn3   = t-cb-dmov.ImpMn3
                   DETALLE.Tm       = t-cb-dmov.Tm
                   DETALLE.CCO      = t-cb-dmov.CCO.
        END.
         
    CREATE DETALLE.
    ASSIGN DETALLE.CodCia   = t-cb-dmov.CodCia
           DETALLE.Periodo  = t-cb-dmov.Periodo
           DETALLE.NroMes   = t-cb-dmov.NroMes
           DETALLE.CodOpe   = t-cb-dmov.CodOpe
           DETALLE.NroAst   = t-cb-dmov.NroAst
           DETALLE.TpoItm   = "A"
           DETALLE.Relacion = RECID(t-cb-dmov)
           DETALLE.CodMon   = t-cb-dmov.CodMon
           DETALLE.TpoCmb   = t-cb-dmov.TpoCmb
           DETALLE.NroItm   = t-cb-dmov.nroitm + 2
           DETALLE.Codcta   = t-cb-dmov.Ctrcta
           DETALLE.CodDiv   = t-cb-dmov.CodDiv
           DETALLE.ClfAux   = t-cb-dmov.ClfAux
           DETALLE.CodAux   = t-cb-dmov.CodCta
           DETALLE.NroRuc   = t-cb-dmov.NroRuc
           DETALLE.CodDoc   = t-cb-dmov.CodDoc
           DETALLE.NroDoc   = t-cb-dmov.NroDoc
           DETALLE.GloDoc   = t-cb-dmov.GloDoc
           DETALLE.CodMon   = t-cb-dmov.CodMon
           DETALLE.TpoCmb   = t-cb-dmov.TpoCmb
           DETALLE.TpoMov   = NOT t-cb-dmov.TpoMov
           DETALLE.ImpMn1   = t-cb-dmov.ImpMn1
           DETALLE.ImpMn2   = t-cb-dmov.ImpMn2
           DETALLE.ImpMn3   = t-cb-dmov.ImpMn3
           DETALLE.NroRef   = t-cb-dmov.NroRef
           DETALLE.FchDoc   = t-cb-dmov.FchDoc
           DETALLE.FchVto   = t-cb-dmov.FchVto
           DETALLE.Tm       = t-cb-dmov.Tm
           DETALLE.CCO      = t-cb-dmov.CCO.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Datos D-Dialog 
PROCEDURE Graba-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN Limpia-Tmp.

FOR EACH T-CMOV:
   FI-MENSAJE = "*TRANSFERENCIA*  Operacion : " + t-cmov.codope + " Nro.Ast.: " + 
                t-cmov.nroast.
   DISPLAY FI-MENSAJE WITH FRAME F-PROCESO.
   CREATE T-cb-cmov.
   RAW-TRANSFER t-cmov TO T-cb-cmov.
   
   FIND integral.cb-cmov WHERE integral.cb-cmov.Codcia = s-codcia AND
        integral.cb-cmov.Periodo = t-cmov.periodo AND 
        integral.cb-cmov.Nromes = t-cmov.nromes AND
        integral.cb-cmov.Codope = t-cmov.codope AND
        integral.cb-cmov.Nroast = t-cmov.nroast NO-ERROR.
   IF AVAILABLE integral.cb-cmov THEN 
      ASSIGN
         integral.cb-cmov.flgtra = TRUE.
END.

FOR EACH T-DMOV:
   FI-MENSAJE = "** TRANSFERENCIA **  Operacion : " + t-dmov.codope + " Nro.Asiento : " + 
                t-dmov.nroast.
   DISPLAY FI-MENSAJE WITH FRAME F-PROCESO.
   CREATE T-cb-dmov.
   RAW-TRANSFER t-dmov TO T-cb-dmov.
   RUN Genera-Automatica.
END.
HIDE FRAME F-PROCESO.

FIND FIRST integral.cb-cfgt WHERE integral.cb-cfgt.codcia = s-codcia NO-ERROR.
IF AVAILABLE integral.cb-cfgt THEN DO:
   ASSIGN 
      integral.cb-cfgt.fchtra = IF integral.cb-cfgt.fchtra <= F-Hasta THEN 
                               integral.cb-cfgt.fchtra ELSE F-Hasta.
   RELEASE integral.cb-cfgt.
END.
MESSAGE 'Proceso Concluido....' VIEW-AS ALERT-BOX.
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
DEFINE VAR I-nroitm  AS INTEGER NO-UNDO.
DEFINE VAR x-nommes  AS CHAR    NO-UNDO.
DEFINE VAR x-codmon  AS CHAR    NO-UNDO.
RUN _mes.p(s-nromes, 1, OUTPUT x-nommes).

DEFINE FRAME F-Header
    HEADER
    {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN3} + {&PRN6B} FORMAT "X(45)" 
    "Fecha  : " AT 99 TODAY SKIP(1)
    {&PRN6A} + "MOVIMIENTOS CONTABLES " + {&PRN6B} + {&PRND} AT 60 FORMAT "X(45)" SKIP(1)
    "Local          : " cb-cfgt.local SPACE(3) cb-cfgt.desloc FORMAT 'X(40)' SKIP
    "Divisionarias  : " cb-cfgt.coddiv FORMAT 'X(30)' SKIP
    "Mes            : " x-nommes FORMAT 'X(20)'   SPACE(10)
    "Fecha Inicial  : " F-Desde   SPACE(15)  "Fecha Final    : " F-Hasta SKIP
    "------------------------------------------------------------------------------------------------------------------------------------------" SKIP
    "    COD   NRO.                                                                         S O L E S                     D O L A R E S        " SKIP
    "ITM OPE ASIENTO       G L O S A                         MON          T/C           DEBE          HABER           DEBE           HABER     " SKIP
    "------------------------------------------------------------------------------------------------------------------------------------------" SKIP
    WITH PAGE-TOP NO-LABELS NO-BOX STREAM-IO WIDTH 200. 
  
DEFINE FRAME F-Detalle
    I-NroItm       AT 1   FORMAT ">>9" 
    t-cmov.codope
    t-cmov.nroast
    t-cmov.notast FORMAT 'X(40)'
    x-codmon      FORMAT 'X(3)'
    t-cmov.tpocmb FORMAT '>>>9.99'
    t-cmov.DbeMn1 FORMAT ">>>>,>>>,>>9.99" 
    t-cmov.HbeMn1 FORMAT ">>>>,>>>,>>9.99" 
    t-cmov.DbeMn2 FORMAT ">>>>,>>>,>>9.99" 
    t-cmov.HbeMn2 FORMAT ">>>>,>>>,>>9.99" 
    WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 200 STREAM-IO DOWN. 

 CASE s-salida-impresion:
       WHEN 1 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
       WHEN 2 THEN OUTPUT TO PRINTER VALUE(s-port-name) PAGED PAGE-SIZE 62. /* Impresora */
       WHEN 3 THEN OUTPUT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
 END CASE.
 PUT CONTROL {&PRN0} {&PRN5A} CHR(66) {&PRN3}.

I-NroItm = 0.
FOR EACH t-cmov BREAK BY t-cmov.tipo BY t-cmov.codope BY t-cmov.nroast:
    VIEW FRAME F-Header.
    IF FIRST-OF(t-cmov.codope) THEN DO:
       FIND cb-oper WHERE cb-oper.CodCia = cb-codcia AND
            cb-oper.Codope = t-cmov.codope NO-LOCK NO-ERROR.
       IF AVAILABLE cb-oper THEN DO:
          DOWN 1 WITH FRAME F-Detalle.
          PUT CONTROL '    OPERACION : ' + t-cmov.codope + '  ' + cb-oper.nomope.
          DOWN 1 WITH FRAME F-Detalle.
          PUT CONTROL '    ----------'.
          DOWN 1 WITH FRAME F-Detalle.
       END.
       I-Nroitm = 0.
    END.
    I-Nroitm = I-Nroitm + 1.
    IF t-cmov.codmon = 1 THEN x-codmon = 'S/.'.
    ELSE x-codmon = 'US$'.
    ACCUMULATE t-cmov.DbeMn1 (SUB-TOTAL BY t-cmov.codope).
    ACCUMULATE t-cmov.HbeMn1 (SUB-TOTAL BY t-cmov.codope).
    ACCUMULATE t-cmov.DbeMn2 (SUB-TOTAL BY t-cmov.codope).
    ACCUMULATE t-cmov.HbeMn2 (SUB-TOTAL BY t-cmov.codope).
    DISPLAY 
        I-NroItm       AT 1   FORMAT ">>9" 
        t-cmov.codope
        t-cmov.nroast
        t-cmov.notast
        x-codmon      FORMAT 'X(3)'
        t-cmov.tpocmb FORMAT '>>>9.99'
        t-cmov.DbeMn1 FORMAT ">>>>,>>>,>>9.99" 
        t-cmov.HbeMn1 FORMAT ">>>>,>>>,>>9.99" 
        t-cmov.DbeMn2 FORMAT ">>>>,>>>,>>9.99" 
        t-cmov.HbeMn2 FORMAT ">>>>,>>>,>>9.99" 
        WITH FRAME F-Detalle.
    IF LAST-OF(t-cmov.codope) THEN DO:
        UNDERLINE 
            t-cmov.DbeMn1 
            t-cmov.HbeMn1 
            t-cmov.DbeMn2 
            t-cmov.HbeMn2 
            WITH FRAME F-Detalle.
        DISPLAY 
            "   TOTAL "    @ x-codmon
            ACCUM SUB-TOTAL BY t-cmov.codope t-cmov.DbeMn1 @ t-cmov.DbeMn1 
            ACCUM SUB-TOTAL BY t-cmov.codope t-cmov.HbeMn1 @ t-cmov.HbeMn1
            ACCUM SUB-TOTAL BY t-cmov.codope t-cmov.DbeMn2 @ t-cmov.DbeMn2 
            ACCUM SUB-TOTAL BY t-cmov.codope t-cmov.HbeMn2 @ t-cmov.HbeMn2
            WITH FRAME F-Detalle.
        DOWN 2  WITH FRAME F-Detalle.
    END.
    IF LAST-OF(t-cmov.tipo) THEN DO:
       DOWN 1 WITH FRAME F-Detalle.
       PUT CONTROL FILL(' ', 40) + '-----------------------' + FILL(' ', 30) + '-----------------------'.
       DOWN 1 WITH FRAME F-Detalle.
       PUT CONTROL FILL(' ', 40) + '  VoBo Administraci¢n  ' + FILL(' ', 30) + '     VoBo Operador     '.
    END.
END.    
OUTPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpia-Tmp D-Dialog 
PROCEDURE Limpia-Tmp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR i AS INTEGER NO-UNDO.
DEFINE VAR y AS DATE    NO-UNDO.

DO y = F-Desde TO F-Hasta:
   DO i = 1 TO NUM-ENTRIES(F-Operacion):
      FOR EACH T-CB-CMOV WHERE T-cb-cmov.tipo = F-LOCAL AND
          T-cb-cmov.codcia  = s-codcia AND
          T-cb-cmov.periodo = s-periodo AND
          T-cb-cmov.nromes  = s-nromes AND
          T-cb-cmov.codope  = ENTRY(i,F-Operacion) AND 
          T-cb-cmov.fchast  = y :
          FOR EACH T-cb-dmov WHERE T-cb-dmov.codcia  = T-cb-cmov.codcia AND
              T-cb-dmov.periodo = T-cb-cmov.periodo AND
              T-cb-dmov.nromes  = T-cb-cmov.nromes AND
              T-cb-dmov.codope  = T-cb-cmov.codope AND 
              T-cb-dmov.nroast  = T-cb-cmov.nroast :
              DELETE T-CB-DMOV.
          END.
          DELETE T-CB-CMOV.
      END.
   END.
END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit D-Dialog 
PROCEDURE local-exit :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'exit':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
/*  IF CONNECTED('integral') THEN
     DISCONNECT integral.*/

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
        DISPLAY 
           cb-cfgt.local  @ F-Local
           cb-cfgt.DesLoc @ F-Descri
           cb-cfgt.CodDiv @ F-Divisionaria
           cb-cfgt.Codope @ F-Operacion.
        IF cb-cfgt.fchtra = TODAY OR cb-cfgt.fchtra = ? THEN
           DISPLAY 
              TODAY @ F-Desde
              TODAY @ F-Hasta.
        ELSE
           DISPLAY   
              cb-cfgt.fchtra + 1 @ F-Desde
              TODAY @ F-Hasta.
     END.
  ELSE DO:
     MESSAGE 'Configuracion no existe' VIEW-AS ALERT-BOX.
     RUN dispatch IN THIS-PROCEDURE ('exit':U).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pre-Impresion D-Dialog 
PROCEDURE Pre-Impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
   
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").
   
  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".
   
  RUN Imprimir.
  
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/D-README.R(s-print-file). 
  END CASE.   
     
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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
DEFINE VAR ok AS LOGICAL NO-UNDO.
DEFINE VAR i AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VAR y AS DATE    NO-UNDO.

FOR EACH T-CMOV:
   DELETE T-CMOV.
END.

FOR EACH T-DMOV:
   DELETE T-DMOV.
END.

/* Verificar si la informaci¢n ha sido transferida anteriormente        */
IF F-Hasta <= integral.cb-cfgt.fchtra THEN DO:
   MESSAGE 'Movimiento Contable ha sido trasladado' SKIP
           '       Desea reprocesarlo?' VIEW-AS ALERT-BOX QUESTION
           BUTTONS YES-NO TITLE '' UPDATE s-resp AS LOGICAL.
   IF s-resp = No THEN RETURN.
END.

ok = TRUE.
DO y = F-Desde TO F-Hasta:
   DO i = 1 TO NUM-ENTRIES(F-Operacion):
      FOR EACH integral.cb-cmov WHERE integral.cb-cmov.Codcia = s-codcia AND 
          integral.cb-cmov.Periodo = s-periodo AND
          integral.cb-cmov.Nromes = s-nromes AND 
          integral.cb-cmov.Codope = ENTRY(i,F-Operacion) AND
          integral.cb-cmov.Fchast = y NO-LOCK:
          FI-MENSAJE = "*VERIFICANDO*  Operacion : " + integral.cb-cmov.codope + " Nro.Ast.: " + 
                       integral.cb-cmov.nroast.
          DISPLAY FI-MENSAJE WITH FRAME F-PROCESO.
          IF cb-cmov.flgtra THEN DO:
             MESSAGE 'Movimiento seleccionado no puede ser reprocesado' VIEW-AS ALERT-BOX ERROR.
             HIDE FRAME F-PROCESO.
.            RETURN.
          END.
          IF INTEGER(SUBSTRING(integral.cb-cmov.nroast,3,4)) < integral.cb-cfgt.corini OR 
             INTEGER(SUBSTRING(integral.cb-cmov.nroast,3,4)) > integral.cb-cfgt.corfin THEN DO:
             MESSAGE 'Numero de Asiento no corresponde al rango asignado' SKIP 
                     integral.cb-cmov.codope + '-' + integral.cb-cmov.nroast VIEW-AS ALERT-BOX ERROR.
             OK = FALSE.
             HIDE FRAME F-PROCESO.
.            RETURN.
          END.
          IF LOOKUP(integral.cb-cmov.coddiv, F-Divisionaria) = 0 THEN DO:
             MESSAGE 'Divisionaria no configurada...' SKIP 
                     integral.cb-cmov.codope + '-' + integral.cb-cmov.nroast VIEW-AS ALERT-BOX ERROR.
             OK = FALSE.
          END.
          CREATE T-cmov.
          ASSIGN
             t-cmov.C-Fcaja = integral.cb-cmov.C-Fcaja 
             t-cmov.Codaux = integral.cb-cmov.Codaux 
             t-cmov.Codcia = integral.cb-cmov.Codcia 
             t-cmov.CodDiv = integral.cb-cmov.CodDiv 
             t-cmov.Coddoc = integral.cb-cmov.Coddoc 
             t-cmov.Codmon = integral.cb-cmov.Codmon 
             t-cmov.Codope = integral.cb-cmov.Codope 
             t-cmov.Ctacja = integral.cb-cmov.Ctacja 
             t-cmov.DbeMn1 = integral.cb-cmov.DbeMn1 
             t-cmov.DbeMn2 = integral.cb-cmov.DbeMn2 
             t-cmov.DbeMn3 = integral.cb-cmov.DbeMn3 
             t-cmov.Fchast = integral.cb-cmov.Fchast 
             t-cmov.FchMod = integral.cb-cmov.FchMod 
             t-cmov.Flgest = integral.cb-cmov.Flgest 
             t-cmov.FlgTra = integral.cb-cmov.FlgTra 
             t-cmov.Girado = integral.cb-cmov.Girado 
             t-cmov.GloAst = integral.cb-cmov.GloAst 
             t-cmov.HbeMn1 = integral.cb-cmov.HbeMn1 
             t-cmov.HbeMn2 = integral.cb-cmov.HbeMn2 
             t-cmov.HbeMn3 = integral.cb-cmov.HbeMn3 
             t-cmov.Impchq = integral.cb-cmov.Impchq 
             t-cmov.Notast = integral.cb-cmov.Notast 
             t-cmov.Nroast = integral.cb-cmov.Nroast 
             t-cmov.Nrochq = integral.cb-cmov.Nrochq 
             t-cmov.Nromes = integral.cb-cmov.Nromes 
             t-cmov.NroTra = integral.cb-cmov.NroTra 
             t-cmov.Nrovou = integral.cb-cmov.Nrovou 
             t-cmov.Periodo = integral.cb-cmov.Periodo 
             t-cmov.Totitm = integral.cb-cmov.Totitm 
             t-cmov.Tpocmb = integral.cb-cmov.Tpocmb 
             t-cmov.Usuario = integral.cb-cmov.Usuario
             t-cmov.tipo   = F-Local
             t-cmov.flgtra = FALSE.
          FOR EACH integral.cb-dmov WHERE integral.cb-dmov.CodCia = s-codcia AND
              integral.cb-dmov.Periodo = integral.cb-cmov.periodo AND 
              integral.cb-dmov.NroMes = integral.cb-cmov.nromes AND
              integral.cb-dmov.Codope = integral.cb-cmov.codope AND
              integral.cb-dmov.Nroast = integral.cb-cmov.nroast AND 
              integral.cb-dmov.tpoitm <> 'A' EXCLUSIVE:
              IF LOOKUP(integral.cb-dmov.coddiv, F-Divisionaria) = 0 THEN DO:
                 MESSAGE 'Divisionaria no configurada...' SKIP 
                         integral.cb-dmov.codope + '-' + integral.cb-dmov.nroast + ' ' + integral.cb-dmov.codcta
                         VIEW-AS ALERT-BOX ERROR.
                 OK = FALSE.
              END.
              CREATE T-dmov.
              ASSIGN
                 t-dmov.C-Fcaja = integral.cb-dmov.C-Fcaja 
                 t-dmov.cco     = integral.cb-dmov.cco 
                 t-dmov.Clfaux = integral.cb-dmov.Clfaux 
                 t-dmov.CndCmp = integral.cb-dmov.CndCmp 
                 t-dmov.Codaux = integral.cb-dmov.Codaux 
                 t-dmov.CodBco = integral.cb-dmov.CodBco 
                 t-dmov.CodCia = integral.cb-dmov.CodCia 
                 t-dmov.Codcta = integral.cb-dmov.Codcta 
                 t-dmov.CodDiv = integral.cb-dmov.CodDiv 
                 t-dmov.Coddoc = integral.cb-dmov.Coddoc 
                 t-dmov.Codmon = integral.cb-dmov.Codmon 
                 t-dmov.Codope = integral.cb-dmov.Codope 
                 t-dmov.Codref = integral.cb-dmov.Codref 
                 t-dmov.CtaAut = integral.cb-dmov.CtaAut 
                 t-dmov.CtrCta = integral.cb-dmov.CtrCta 
                 t-dmov.DisCCo = integral.cb-dmov.DisCCo 
                 t-dmov.Fchdoc = integral.cb-dmov.Fchdoc 
                 t-dmov.Fchvto = integral.cb-dmov.Fchvto 
                 t-dmov.flgact = integral.cb-dmov.flgact 
                 t-dmov.Glodoc = integral.cb-dmov.Glodoc 
                 t-dmov.ImpMn1 = integral.cb-dmov.ImpMn1 
                 t-dmov.ImpMn2 = integral.cb-dmov.ImpMn2 
                 t-dmov.ImpMn3 = integral.cb-dmov.ImpMn3 
                 t-dmov.Nroast = integral.cb-dmov.Nroast 
                 t-dmov.Nrodoc = integral.cb-dmov.Nrodoc 
                 t-dmov.Nroitm = integral.cb-dmov.Nroitm 
                 t-dmov.NroMes = integral.cb-dmov.NroMes 
                 t-dmov.Nroref = integral.cb-dmov.Nroref 
                 t-dmov.Nroruc = integral.cb-dmov.Nroruc 
                 t-dmov.OrdCmp = integral.cb-dmov.OrdCmp 
                 t-dmov.Periodo = integral.cb-dmov.Periodo 
                 t-dmov.rel-ac-cb = integral.cb-dmov.rel-ac-cb 
                 t-dmov.Relacion = integral.cb-dmov.Relacion 
                 t-dmov.tm     = integral.cb-dmov.tm 
                 t-dmov.Tpocmb = integral.cb-dmov.Tpocmb 
                 t-dmov.TpoItm = integral.cb-dmov.TpoItm 
                 t-dmov.TpoMov = integral.cb-dmov.TpoMov
                 t-dmov.tipo = F-Local.                 
          END.
      END.
   END.
END.
HIDE FRAME F-PROCESO.

IF ok THEN DO WITH FRAME {&FRAME-NAME}:
   B-Imprimir:SENSITIVE = TRUE.
   Btn_OK:SENSITIVE = TRUE.
END.

MESSAGE 'Carga del Temporal ha finalizado....' VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

