&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEF OUTPUT PARAMETER pCodAlm AS CHAR.
DEF OUTPUT PARAMETER pNroCot AS CHAR.

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codalm AS CHAR.
/*DEF SHARED VAR s-TpoPed AS CHAR.*/

DEF VAR s-coddoc AS CHAR INIT "COT".
DEF VAR s-flgest AS CHAR INIT "P".

ASSIGN
    pCodAlm = ""
    pNroCot = "".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacCPedi

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 FacCPedi.CodDoc FacCPedi.NroPed ~
FacCPedi.FchPed FacCPedi.fchven FacCPedi.CodCli FacCPedi.NomCli ~
FacCPedi.ImpTot FacCPedi.ordcmp 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH FacCPedi ~
      WHERE FacCPedi.CodCia = s-codcia ~
 AND FacCPedi.CodDoc = s-coddoc ~
 AND FacCPedi.CodDiv = s-coddiv ~
 AND FacCPedi.FlgEst = s-flgest ~
 AND (FILL-IN-CodCli = '' OR FacCPedi.CodCli = FILL-IN-CodCli) ~
 AND (FILL-IN-NomCli = '' OR INDEX(FacCPedi.NomCli, FILL-IN-NomCli) > 0) ~
 AND (txtOrdenCompra = '' or Faccpedi.ordcmp begins txtOrdenCompra) ~
 NO-LOCK ~
    BY FacCPedi.FchPed DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH FacCPedi ~
      WHERE FacCPedi.CodCia = s-codcia ~
 AND FacCPedi.CodDoc = s-coddoc ~
 AND FacCPedi.CodDiv = s-coddiv ~
 AND FacCPedi.FlgEst = s-flgest ~
 AND (FILL-IN-CodCli = '' OR FacCPedi.CodCli = FILL-IN-CodCli) ~
 AND (FILL-IN-NomCli = '' OR INDEX(FacCPedi.NomCli, FILL-IN-NomCli) > 0) ~
 AND (txtOrdenCompra = '' or Faccpedi.ordcmp begins txtOrdenCompra) ~
 NO-LOCK ~
    BY FacCPedi.FchPed DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 FacCPedi


/* Definitions for DIALOG-BOX gDialog                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-gDialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-52 RECT-53 COMBO-BOX-CodAlm ~
txtOrdenCompra FILL-IN-CodCli FILL-IN-NomCli BROWSE-2 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodAlm txtOrdenCompra ~
FILL-IN-CodCli FILL-IN-NomCli 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.62.

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE COMBO-BOX-CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Seleccione el almacén de despacho" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Filtrar por Código del cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Filtrar por Nombre del Cliente" 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE txtOrdenCompra AS CHARACTER FORMAT "X(15)":U 
     LABEL "Filtrar por O/C Sup.Mercados Peruanos" 
     VIEW-AS FILL-IN 
     SIZE 13.86 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-52
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 100 BY 1.88
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-53
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 100 BY 2.15
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 gDialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      FacCPedi.CodDoc COLUMN-LABEL "Doc" FORMAT "x(3)":U
      FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U WIDTH 8.29
      FacCPedi.FchPed COLUMN-LABEL "Fecha de Emision" FORMAT "99/99/9999":U
            WIDTH 12.43
      FacCPedi.fchven COLUMN-LABEL "Fecha Vencimiento" FORMAT "99/99/9999":U
            WIDTH 13.43
      FacCPedi.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U WIDTH 10.43
      FacCPedi.NomCli FORMAT "x(50)":U
      FacCPedi.ImpTot FORMAT "->>,>>>,>>9.99":U
      FacCPedi.ordcmp FORMAT "X(15)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 100 BY 9.42
         FONT 4
         TITLE "SELECCIONE LA COTIZACION" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     COMBO-BOX-CodAlm AT ROW 1.81 COL 33 COLON-ALIGNED WIDGET-ID 2
     txtOrdenCompra AT ROW 3.35 COL 66.14 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-CodCli AT ROW 3.42 COL 26 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-NomCli AT ROW 4.23 COL 26 COLON-ALIGNED WIDGET-ID 10
     BROWSE-2 AT ROW 5.31 COL 3 WIDGET-ID 200
     Btn_OK AT ROW 14.96 COL 4
     Btn_Cancel AT ROW 14.96 COL 19
     RECT-52 AT ROW 1.27 COL 3 WIDGET-ID 6
     RECT-53 AT ROW 3.15 COL 3 WIDGET-ID 12
     SPACE(2.56) SKIP(12.11)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "SELECCIONE LA COTIZACION Y EL ALMACEN DE DESPACHO"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 FILL-IN-NomCli gDialog */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.FacCPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.FacCPedi.FchPed|no"
     _Where[1]         = "FacCPedi.CodCia = s-codcia
 AND FacCPedi.CodDoc = s-coddoc
 AND FacCPedi.CodDiv = s-coddiv
 AND FacCPedi.FlgEst = s-flgest
 AND (FILL-IN-CodCli = '' OR FacCPedi.CodCli = FILL-IN-CodCli)
 AND (FILL-IN-NomCli = '' OR INDEX(FacCPedi.NomCli, FILL-IN-NomCli) > 0)
 AND (txtOrdenCompra = '' or Faccpedi.ordcmp begins txtOrdenCompra)
"
     _FldNameList[1]   > INTEGRAL.FacCPedi.CodDoc
"FacCPedi.CodDoc" "Doc" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "8.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Fecha de Emision" ? "date" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.fchven
"FacCPedi.fchven" "Fecha Vencimiento" "99/99/9999" "date" ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.FacCPedi.NomCli
     _FldNameList[7]   = INTEGRAL.FacCPedi.ImpTot
     _FldNameList[8]   > INTEGRAL.FacCPedi.ordcmp
"FacCPedi.ordcmp" ? "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* SELECCIONE LA COTIZACION Y EL ALMACEN DE DESPACHO */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 gDialog
ON VALUE-CHANGED OF BROWSE-2 IN FRAME gDialog /* SELECCIONE LA COTIZACION */
DO:
    DEF VAR j AS INT.
    DEF VAR x-codalm AS CHAR.

    /* los almacenes de despacho salen de la cotizacion */
    IF NOT AVAILABLE Faccpedi THEN RETURN.
    IF FacCPedi.TpoPed = "R"  THEN x-CodAlm = Faccpedi.CodAlm.  /* SOLO REMATES */
    ELSE DO:
        FOR EACH VtaAlmDiv NO-LOCK WHERE Vtaalmdiv.codcia = s-codcia
             AND Vtaalmdiv.coddiv = s-coddiv,
             FIRST Almacen OF Vtaalmdiv NO-LOCK WHERE Almacen.Campo-C[3] <> 'Si'
             BY VtaAlmDiv.Orden:
             IF x-CodAlm = "" THEN x-CodAlm = TRIM(VtaAlmDiv.CodAlm).
             ELSE x-CodAlm = x-CodAlm + "," + TRIM(VtaAlmDiv.CodAlm).
         END.
    END.
    IF Faccpedi.coddiv = '00018' AND Faccpedi.Libre_c01 = '80015' THEN x-codalm = '60'.
    CASE TRUE:
        WHEN Faccpedi.coddiv = '00018' AND Faccpedi.Libre_c01 = '80015' THEN x-codalm = '60'.
        WHEN Faccpedi.Usuario = 'VTA-403' AND Faccpedi.Libre_c01 = '40015' THEN x-codalm = '03,35'.
        WHEN Faccpedi.Usuario = 'VTA-404' AND Faccpedi.Libre_c01 = '40015' THEN x-codalm = '04,35'.
        WHEN Faccpedi.Usuario = 'VTA-405' AND Faccpedi.Libre_c01 = '40015' THEN x-codalm = '05,35'.
        WHEN Faccpedi.coddiv = '00018' AND Faccpedi.Libre_c01 = '00065' THEN x-codalm = '65'.
        WHEN Faccpedi.LugEnt2 <> '' AND CAN-FIND(Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
                                                 AND ALmacen.codalm = Faccpedi.LugEnt2) THEN x-codalm = Faccpedi.LugEnt2.
    END CASE.
    /* RHC 15/11/2016 La Cotización va a generar una OTR */
    FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-codcia
        AND VtaTabla.Tabla = 'EXPOCOT'
        AND VtaTabla.Llave_c1 = Faccpedi.Libre_c01
        AND VtaTabla.Llave_c2 = Faccpedi.coddoc
        AND VtaTabla.LLave_c3 = Faccpedi.nroped
        AND VtaTabla.Llave_c4 = Faccpedi.coddiv
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN x-CodAlm = VtaTabla.Llave_c5.
    /* ************************************************* */

    /* LOS almacen SE ORDENAN DE ACUERDO AL ORDEN DE PRIORIDAD */
    DO WITH FRAME {&FRAME-NAME}:
        COMBO-BOX-CodAlm:DELETE(COMBO-BOX-CodAlm:LIST-ITEMS).
        DO j = 1 TO NUM-ENTRIES(x-codalm):
            FIND almacen WHERE almacen.codcia = s-codcia
                AND almacen.codalm = ENTRY(j, x-codalm)
                NO-LOCK NO-ERROR.
            IF AVAILABLE almacen THEN COMBO-BOX-CodAlm:ADD-LAST(almacen.codalm + ' - ' + INTEGRAL.Almacen.Descripcion)
                IN FRAME {&FRAME-NAME}.
            IF j = 1 THEN COMBO-BOX-CodAlm = almacen.codalm + ' - ' + INTEGRAL.Almacen.Descripcion.
            IF Faccpedi.LugEnt2 <> '' AND LOOKUP(Faccpedi.LugEnt2, x-CodAlm) > 0
                AND AVAILABLE Almacen AND Faccpedi.LugEnt2 = Almacen.CodAlm 
                THEN COMBO-BOX-CodAlm = almacen.codalm + ' - ' + INTEGRAL.Almacen.Descripcion.
        END.
        DISPLAY COMBO-BOX-CodAlm.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* OK */
DO:
  ASSIGN
      COMBO-BOX-CodAlm.
  IF {&browse-name}:NUM-SELECTED-ROWS = 0 THEN DO:
      MESSAGE 'Seleccione una cotización' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  ASSIGN
      pCodAlm = ENTRY(1, COMBO-BOX-CodAlm, " - ")
      pNroCot = Faccpedi.NroPed.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli gDialog
ON LEAVE OF FILL-IN-CodCli IN FRAME gDialog /* Filtrar por Código del cliente */
OR RETURN OF FILL-IN-CodCli
    DO:
    IF SELF:SCREEN-VALUE = {&self-name} THEN RETURN.
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
    APPLY 'VALUE-CHANGED' TO {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NomCli gDialog
ON LEAVE OF FILL-IN-NomCli IN FRAME gDialog /* Filtrar por Nombre del Cliente */
OR RETURN OF FILL-IN-NomCli
    DO:
    IF SELF:SCREEN-VALUE = {&self-name} THEN RETURN.
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
    APPLY 'VALUE-CHANGED' TO {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txtOrdenCompra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txtOrdenCompra gDialog
ON LEAVE OF txtOrdenCompra IN FRAME gDialog /* Filtrar por O/C Sup.Mercados Peruanos */
OR RETURN OF FILL-IN-CodCli
    DO:
    IF SELF:SCREEN-VALUE = {&self-name} THEN RETURN.
    ASSIGN {&self-name}.
    {&OPEN-QUERY-{&BROWSE-NAME}}
    APPLY 'VALUE-CHANGED' TO {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-CodAlm txtOrdenCompra FILL-IN-CodCli FILL-IN-NomCli 
      WITH FRAME gDialog.
  ENABLE RECT-52 RECT-53 COMBO-BOX-CodAlm txtOrdenCompra FILL-IN-CodCli 
         FILL-IN-NomCli BROWSE-2 Btn_OK Btn_Cancel 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR j AS INT.
  DEF VAR x-codalm AS CHAR.

  /* LOS almacen SE ORDENAN DE ACUERDO AL ORDEN DE PRIORIDAD */
  RUN vtagn/p-alm-despacho (s-coddiv, TRUE, "" , OUTPUT x-codalm). 
  DO j = 1 TO NUM-ENTRIES(x-codalm):
      FIND almacen WHERE almacen.codcia = s-codcia
          AND almacen.codalm = ENTRY(j, x-codalm)
          NO-LOCK NO-ERROR.
      IF AVAILABLE almacen THEN COMBO-BOX-CodAlm:ADD-LAST(almacen.codalm + ' - ' + INTEGRAL.Almacen.Descripcion)
          IN FRAME {&FRAME-NAME}.
      IF j = 1 THEN COMBO-BOX-CodAlm = almacen.codalm + ' - ' + INTEGRAL.Almacen.Descripcion.
  END.

  /* FIN DE CARGA DE almacen */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY 'VALUE-CHANGED':U TO {&BROWSE-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros gDialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros gDialog 
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
        WHEN "" THEN .
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

