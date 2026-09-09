&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tCcbCDocu NO-UNDO LIKE CcbCDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
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

DEF PARAMETER BUFFER bCcbcdocu FOR Ccbcdocu.
DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

pError = "Operación cancelada".     /* Valor por defecto */

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'FAC' NO-UNDO.
DEF VAR s-nroser AS INTE NO-UNDO.
DEF VAR s-TpoFac AS CHAR INIT "A" NO-UNDO.      /* Factura de anticipo */
DEF VAR cSeries AS CHAR NO-UNDO.

DEF NEW SHARED VAR s-coddiv AS CHAR.
s-CodDiv = bCcbcdocu.coddiv.

FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDiv = s-coddiv AND
    LOOKUP(Faccorre.coddoc, 'FAC,BOL') > 0 AND
    FacCorre.FlgEst = YES NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    pError = "Correlativo de FAC y BOL no configurado".
    RETURN.
END.

DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tCcbCDocu

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog tCcbCDocu.CodCli tCcbCDocu.NomCli ~
tCcbCDocu.RucCli tCcbCDocu.CodAnt tCcbCDocu.DirCli tCcbCDocu.NroOrd ~
tCcbCDocu.FmaPgo tCcbCDocu.CodVen tCcbCDocu.Glosa tCcbCDocu.CodMon ~
tCcbCDocu.TpoCmb tCcbCDocu.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-D-Dialog tCcbCDocu.CodAnt ~
tCcbCDocu.NroOrd tCcbCDocu.CodVen tCcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES-IN-QUERY-D-Dialog tCcbCDocu
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-D-Dialog tCcbCDocu
&Scoped-define QUERY-STRING-D-Dialog FOR EACH tCcbCDocu SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH tCcbCDocu SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog tCcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog tCcbCDocu


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tCcbCDocu.CodAnt tCcbCDocu.NroOrd ~
tCcbCDocu.CodVen tCcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES tCcbCDocu
&Scoped-define FIRST-ENABLED-TABLE tCcbCDocu
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 C-CodDoc C-NroSer ~
Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-FIELDS tCcbCDocu.CodCli tCcbCDocu.NomCli ~
tCcbCDocu.RucCli tCcbCDocu.CodAnt tCcbCDocu.DirCli tCcbCDocu.NroOrd ~
tCcbCDocu.FmaPgo tCcbCDocu.CodVen tCcbCDocu.Glosa tCcbCDocu.CodMon ~
tCcbCDocu.TpoCmb tCcbCDocu.ImpTot 
&Scoped-define DISPLAYED-TABLES tCcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE tCcbCDocu
&Scoped-Define DISPLAYED-OBJECTS C-CodDoc C-NroSer F-CndVta f-NomVen 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE VARIABLE C-CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "FAC" 
     LABEL "Seleccione el Comprobante" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "FAC","BOL" 
     DROP-DOWN-LIST
     SIZE 7.14 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE C-NroSer AS CHARACTER FORMAT "X(3)":U INITIAL "0" 
     LABEL "Seleccione el # de Serie" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 6.72 BY 1
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .81 NO-UNDO.

DEFINE VARIABLE f-NomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.62.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 9.69.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.62.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      tCcbCDocu SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     C-CodDoc AT ROW 1.54 COL 7.57 WIDGET-ID 56
     C-NroSer AT ROW 1.54 COL 37.57 WIDGET-ID 58
     tCcbCDocu.CodCli AT ROW 2.88 COL 19 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     tCcbCDocu.NomCli AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 14 FGCOLOR 0 
     tCcbCDocu.RucCli AT ROW 4.5 COL 19 COLON-ALIGNED WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     tCcbCDocu.CodAnt AT ROW 5.31 COL 19 COLON-ALIGNED WIDGET-ID 24
          LABEL "DNI" FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
          BGCOLOR 11 FGCOLOR 0 
     tCcbCDocu.DirCli AT ROW 6.12 COL 19 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 14 FGCOLOR 0 
     tCcbCDocu.NroOrd AT ROW 6.92 COL 19 COLON-ALIGNED WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
          BGCOLOR 11 FGCOLOR 0 
     tCcbCDocu.FmaPgo AT ROW 7.73 COL 19 COLON-ALIGNED WIDGET-ID 30
          LABEL "Condición de venta"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     F-CndVta AT ROW 7.73 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 42
     tCcbCDocu.CodVen AT ROW 8.54 COL 19 COLON-ALIGNED WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
          BGCOLOR 11 FGCOLOR 0 
     f-NomVen AT ROW 8.54 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     tCcbCDocu.Glosa AT ROW 9.35 COL 19 COLON-ALIGNED WIDGET-ID 32
          LABEL "Glosa"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 11 FGCOLOR 0 
     tCcbCDocu.CodMon AT ROW 10.15 COL 21 NO-LABEL WIDGET-ID 44
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 13 BY .81
     tCcbCDocu.TpoCmb AT ROW 10.15 COL 49 COLON-ALIGNED WIDGET-ID 54
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     tCcbCDocu.ImpTot AT ROW 10.96 COL 19 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
          BGCOLOR 14 FGCOLOR 0 
     Btn_OK AT ROW 12.58 COL 5
     Btn_Cancel AT ROW 12.58 COL 21
     "Moneda:" VIEW-AS TEXT
          SIZE 6.43 BY .5 AT ROW 10.31 COL 14 WIDGET-ID 48
     RECT-1 AT ROW 1 COL 2 WIDGET-ID 60
     RECT-2 AT ROW 2.62 COL 2 WIDGET-ID 62
     RECT-3 AT ROW 12.31 COL 2 WIDGET-ID 64
     SPACE(1.42) SKIP(0.79)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "FACTURA DE ANTICIPO"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tCcbCDocu T "?" NO-UNDO INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE
       FRAME D-Dialog:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR COMBO-BOX C-CodDoc IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX C-NroSer IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN tCcbCDocu.CodAnt IN FRAME D-Dialog
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN tCcbCDocu.CodCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET tCcbCDocu.CodMon IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tCcbCDocu.DirCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomVen IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tCcbCDocu.FmaPgo IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN tCcbCDocu.Glosa IN FRAME D-Dialog
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tCcbCDocu.ImpTot IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tCcbCDocu.NomCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tCcbCDocu.RucCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tCcbCDocu.TpoCmb IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "Temp-Tables.tCcbCDocu"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* FACTURA DE ANTICIPO */
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

  /* Validaciones */
  IF s-CodDoc = "FAC" AND tCcbcdocu.RucCli:SCREEN-VALUE = '' THEN DO:
      MESSAGE "El Cliente NO tiene R.U.C." VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.      
  /* VALIDACION DEL VENDEDOR */
  IF tCcbcdocu.CodVen:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de Vendedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO tCcbcdocu.CodVen.
      RETURN NO-APPLY.
  END.
  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
      AND  gn-ven.CodVen = tCcbcdocu.CodVen:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-ven THEN DO:
      MESSAGE "Codigo de Vendedor no existe" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO tCcbcdocu.CodVen.
      RETURN NO-APPLY.
  END.
  ELSE DO:
      IF gn-ven.flgest = "C" THEN DO:
          MESSAGE "Codigo de Vendedor Cesado" VIEW-AS ALERT-BOX ERROR.
          APPLY "ENTRY" TO tCcbcdocu.CodVen.
          RETURN NO-APPLY.
      END.
  END.
  /* Solo lo modificado */
  ASSIGN 
      tCcbCDocu.CodAnt tCcbCDocu.CodVen tCcbCDocu.DirCli 
      tCcbCDocu.Glosa tCcbCDocu.NomCli tCcbCDocu.NroOrd 
      tCcbCDocu.TpoCmb
      .
  
  RUN Genera-Comprobante (OUTPUT pError).
  IF RETURN-VALUE = "ADM-ERROR" THEN DO:
      IF TRUE <> (pError > '') THEN pError = "NO se pudo generar el comprobante por Anticipo".
  END.
  ELSE pError = "".      /* Sin errores */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-CodDoc D-Dialog
ON VALUE-CHANGED OF C-CodDoc IN FRAME D-Dialog /* Seleccione el Comprobante */
DO:
  IF INDEX(cSeries, SELF:SCREEN-VALUE) = 0 THEN DO:
      MESSAGE 'NO hay correlativos configurados para el comprobante' SELF:SCREEN-VALUE
          VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  /* Cargamos series */
  ASSIGN c-CodDoc.

  DEF VAR i AS INTE NO-UNDO.
  DEF VAR c AS CHAR NO-UNDO.

  c-NroSer:DELETE(c-NroSer:LIST-ITEMS).
  DO i = 1 TO NUM-ENTRIES(cSeries,":"):
      c = ENTRY(i,cSeries,":").     /* FAC,001 */
      IF ENTRY(1,c) = c-CodDoc THEN DO:
          c-NroSer:ADD-LAST(ENTRY(2,c)).
          c-NroSer = ENTRY(2,c).
      END.
  END.
  DISPLAY c-NroSer WITH FRAME {&FRAME-NAME}.
  IF c-CodDoc = "BOL" THEN
      ASSIGN
      tCcbCDocu.DirCli:SENSITIVE = YES
      tCcbCDocu.NomCli:SENSITIVE = YES.
  ELSE ASSIGN
      tCcbCDocu.DirCli:SENSITIVE = NO
      tCcbCDocu.NomCli:SENSITIVE = NO
      tCcbCDocu.DirCli:SCREEN-VALUE = bCcbCDocu.DirCli
      tCcbCDocu.NomCli:SCREEN-VALUE = bCcbCDocu.NomCli
    .
  S-CODDOC = C-CODDOC.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-NroSer D-Dialog
ON VALUE-CHANGED OF C-NroSer IN FRAME D-Dialog /* Seleccione el # de Serie */
DO:
  ASSIGN C-NroSer.
  S-NROSER = INTEGER(c-NroSer).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tCcbCDocu.CodVen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tCcbCDocu.CodVen D-Dialog
ON LEAVE OF tCcbCDocu.CodVen IN FRAME D-Dialog /* Vendedor */
DO:
  F-NomVen:SCREEN-VALUE = "".
  IF SELF:SCREEN-VALUE = "" THEN RETURN.

  FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
      AND  gn-ven.CodVen = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-ven THEN DO:
      MESSAGE "Vendedor NO válido" VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = "".
      RETURN NO-APPLY.
  END.
  F-NomVen:SCREEN-VALUE = gn-ven.NomVen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tCcbCDocu.CodVen D-Dialog
ON LEFT-MOUSE-DBLCLICK OF tCcbCDocu.CodVen IN FRAME D-Dialog /* Vendedor */
DO:
  ASSIGN
      input-var-1 = ''
      input-var-2 = ''
      input-var-3 = ''.
  RUN lkup/c-vende ('Vendedor').
  IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tCcbCDocu.DirCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tCcbCDocu.DirCli D-Dialog
ON LEAVE OF tCcbCDocu.DirCli IN FRAME D-Dialog /* Direccion */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tCcbCDocu.NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tCcbCDocu.NomCli D-Dialog
ON LEAVE OF tCcbCDocu.NomCli IN FRAME D-Dialog /* Nombre */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
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
  DISPLAY C-CodDoc C-NroSer F-CndVta f-NomVen 
      WITH FRAME D-Dialog.
  IF AVAILABLE tCcbCDocu THEN 
    DISPLAY tCcbCDocu.CodCli tCcbCDocu.NomCli tCcbCDocu.RucCli tCcbCDocu.CodAnt 
          tCcbCDocu.DirCli tCcbCDocu.NroOrd tCcbCDocu.FmaPgo tCcbCDocu.CodVen 
          tCcbCDocu.Glosa tCcbCDocu.CodMon tCcbCDocu.TpoCmb tCcbCDocu.ImpTot 
      WITH FRAME D-Dialog.
  ENABLE RECT-1 RECT-2 RECT-3 C-CodDoc C-NroSer tCcbCDocu.CodAnt 
         tCcbCDocu.NroOrd tCcbCDocu.CodVen tCcbCDocu.Glosa Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Comprobante D-Dialog 
PROCEDURE Genera-Comprobante :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.

DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* ********************************************************************************** */
    /* 1ra PARTE: Generación del comprobante */
    /* ********************************************************************************** */
    {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}
    CREATE Ccbcdocu.
    BUFFER-COPY tCcbcdocu TO Ccbcdocu
        ASSIGN
        Ccbcdocu.CodDiv = s-coddiv
        Ccbcdocu.CodDoc = s-coddoc 
        CcbCDocu.NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) 
        Ccbcdocu.TpoFac = s-TpoFac
        CcbCDocu.Tipo   = "CREDITO"
        CcbCDocu.TipVta = "2"
        CcbCDocu.usuario = S-USER-ID
        CcbCDocu.HorCie = STRING(TIME, 'HH:MM')
        CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
        CcbCDocu.PorIgv = FacCfgGn.PorIgv
        Ccbcdocu.FlgCbd = YES     /* AFECTO */
        Ccbcdocu.ImpDto = 0
        Ccbcdocu.ImpDto2 = 0
        Ccbcdocu.ImpIgv = 0
        Ccbcdocu.ImpIsc = 0
        Ccbcdocu.ImpExo = 0
        Ccbcdocu.ImpVta = ROUND(Ccbcdocu.ImpTot / ( 1 + Ccbcdocu.PorIgv / 100 ), 2)
        Ccbcdocu.ImpIgv = Ccbcdocu.ImpTot - Ccbcdocu.ImpVta
        Ccbcdocu.ImpBrt = Ccbcdocu.ImpVta
        Ccbcdocu.SdoAct = 0     /* NACE CANCELADO */
        Ccbcdocu.FlgEst = "C"
        CcbCDocu.CodRef = bCcbcdocu.coddoc      /* BD */
        CcbCDocu.NroRef = bCcbcdocu.nrodoc
        NO-ERROR.
        .
    IF ERROR-STATUS:ERROR THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pError"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    RELEASE FacCorre.

    FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
        AND gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie  THEN DO:
        ASSIGN 
            CcbCDocu.CodDpto = gn-clie.CodDept 
            CcbCDocu.CodProv = gn-clie.CodProv 
            CcbCDocu.CodDist = gn-clie.CodDist.
    END.

    /* CREAMOS UN REGISTRO FALSO PARA LA IMPRESION */
    DEF VAR cCodMat AS CHAR NO-UNDO INIT '035866'.
    CREATE Ccbddocu.
    BUFFER-COPY Ccbcdocu 
        TO Ccbddocu
        ASSIGN
        Ccbddocu.codmat = cCodMat
        Ccbddocu.undvta = "UNI"
        Ccbddocu.candes = 1
        Ccbddocu.factor = 1
        Ccbddocu.preuni = Ccbcdocu.imptot
        Ccbddocu.implin = Ccbcdocu.imptot
        Ccbddocu.aftigv = Ccbcdocu.flgcbd
        Ccbddocu.impigv = Ccbcdocu.impigv.
    /* ****************************************************************************************** */
    /* Importes SUNAT */
    /* ****************************************************************************************** */
    DEF VAR hProc AS HANDLE NO-UNDO.
    RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
    RUN tabla-ccbcdocu IN hProc (INPUT Ccbcdocu.CodDiv,
                                 INPUT Ccbcdocu.CodDoc,
                                 INPUT Ccbcdocu.NroDoc,
                                 OUTPUT pError).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
    DELETE PROCEDURE hProc.
    /* ****************************************************************************************** */
    /* GENERACION DE INFORMACION PARA SUNAT */
    RUN sunat\progress-to-ppll-v3( INPUT Ccbcdocu.coddiv,
                                   INPUT Ccbcdocu.coddoc,
                                   INPUT Ccbcdocu.nrodoc,
                                   INPUT-OUTPUT TABLE T-FELogErrores,
                                   OUTPUT pError ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pError = "" THEN pError = "ERROR: No se pudo generar el comprobante" .
        UNDO, RETURN 'ADM-ERROR'.
    END.
    IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
        IF pError = "" THEN pError = "ERROR: No se pudo confirmar el comprobante" .
        ASSIGN Ccbcdocu.FlgEst = "A".
    END.
    /* ********************************************************************************** */
    /* 2da PARTE: Generación de la cancelación */
    /* ********************************************************************************** */
    CREATE Ccbdcaja.
    ASSIGN
        CcbDCaja.CodCia = s-codcia
        CcbDCaja.CodCli = Ccbcdocu.codcli
        CcbDCaja.CodDiv = Ccbcdocu.coddiv
        CcbDCaja.CodDoc = bCcbcdocu.CodDoc      /* BD */
        CcbDCaja.NroDoc = bCcbcdocu.nrodoc
        CcbDCaja.CodMon = Ccbcdocu.codmon
        CcbDCaja.CodRef = Ccbcdocu.coddoc       /* FAC */
        CcbDCaja.NroRef = Ccbcdocu.nrodoc
        CcbDCaja.FchCbd = TODAY
        CcbDCaja.FchDoc = TODAY
        CcbDCaja.ImpTot = Ccbcdocu.imptot
        CcbDCaja.TpoCmb = Ccbcdocu.tpocmb
        .
    CREATE Ccbdmov.
    ASSIGN
        CCBDMOV.CodCia = s-codcia
        CCBDMOV.CodDiv = s-coddiv
        CCBDMOV.CodDoc = bCcbcdocu.CodDoc       /* BD */
        CCBDMOV.NroDoc = bCcbcdocu.NroDoc
        CCBDMOV.FchDoc = TODAY
        CCBDMOV.CodRef = Ccbcdocu.CodDoc        /* FAC */
        CCBDMOV.NroRef = Ccbcdocu.NroDoc
        CCBDMOV.CodMon = bCcbcdocu.CodMon
        CCBDMOV.ImpTot = bCcbcdocu.ImpTot
        CCBDMOV.CodCli = bCcbcdocu.CodCli
        CCBDMOV.TpoCmb = bCcbcdocu.TpoCmb
        CCBDMOV.usuario = s-user-id
        CCBDMOV.FchMov = TODAY
        CCBDMOV.HraMov = STRING(TIME,'HH:MM:SS')
        .

    /* ********************************************************************************** */
    /* 3ra PARTE: Generación del A/C */
    /* ********************************************************************************** */
    RUN ccb/p-ctrl-fac-adel ( ROWID(Ccbcdocu), "C" ).
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        pError = "NO se pudo generar el A/C".
        UNDO, RETURN "ADM-ERROR".
    END.

    /* ********************************************************************************** */
    IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
    IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
    IF AVAILABLE(Ccbdcaja) THEN RELEASE Ccbdcaja.
    IF AVAILABLE(Ccbdmov) THEN RELEASE Ccbdmov.
END.
RETURN "OK".

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
  DO TRANSACTION WITH FRAME {&FRAME-NAME}:
      CREATE tCcbcdocu.
      /* Copiamos información de la BD */
      BUFFER-COPY bCcbcdocu TO tCcbcdocu
          ASSIGN
          tCcbcdocu.fchdoc = TODAY
          tCcbcdocu.fchvto = TODAY
          tCcbcdocu.usuario = s-user-id.
      /* Completamos información */
      FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND
          gn-clie.codcli = tCcbcdocu.codcli
          NO-LOCK NO-ERROR NO-WAIT.
      IF AVAILABLE gn-clie THEN
          ASSIGN
          tCcbCDocu.CodAnt = gn-clie.dni
          tCcbCDocu.CodVen = gn-clie.codven
          tCcbCDocu.DirCli = gn-clie.dircli
          tCcbCDocu.NomCli = gn-clie.nomcli
          tCcbCDocu.RucCli = gn-clie.ruc
          .
      FIND gn-clied OF gn-clie WHERE gn-clied.sede = "@@@" NO-LOCK NO-ERROR NO-WAIT.
      IF AVAILABLE gn-clied THEN tCcbCDocu.DirCli = Gn-ClieD.DirCli.
      FIND gn-convt WHERE gn-convt.Codig = tCcbcdocu.FmaPgo NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN F-CndVta = gn-convt.Nombr.
      FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA 
          AND gn-ven.CodVen = tCcbcdocu.CodVen NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ven THEN F-NomVen = gn-ven.NomVen.

      FIND FIRST FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.
      tCcbcdocu.TpoCmb = FacCfgGn.Tpocmb[1].

      /* Buscamos series activas */
      cSeries = "".
      FOR EACH FacCorre NO-LOCK WHERE Faccorre.codcia = s-codcia AND
          Faccorre.flgest = YES AND
          Faccorre.coddiv = s-coddiv AND
          LOOKUP(Faccorre.coddoc, 'FAC,BOL') > 0:
          cSeries = cSeries + 
              (IF TRUE <> (cSeries > '') THEN '' ELSE ':' ) +
              FacCorre.coddoc + "," + STRING(FacCorre.nroser,'999').
      END.
      /* Cargamos 1ro las facturas si es que hubieran */
      DEF VAR i AS INTE NO-UNDO.
      DEF VAR c AS CHAR NO-UNDO.
      IF INDEX(cSeries, 'FAC') > 0 THEN DO:
          c-CodDoc = "FAC".
          DO i = 1 TO NUM-ENTRIES(cSeries,":"):
              c = ENTRY(i,cSeries,":").     /* FAC,001 */
              IF ENTRY(1,c) = "FAC" THEN DO:
                  c-NroSer:ADD-LAST(ENTRY(2,c)).
                  c-NroSer = ENTRY(2,c).
              END.
          END.
      END.
      ELSE DO:
          c-CodDoc = "BOL".
          DO i = 1 TO NUM-ENTRIES(cSeries,":"):
              c = ENTRY(i,cSeries,":").     /* FAC,001 */
              IF ENTRY(1,c) = "BOL" THEN DO:
                  c-NroSer:ADD-LAST(ENTRY(2,c)).
                  c-NroSer = ENTRY(2,c).
              END.
          END.
      END.
      s-NroSer = INTEGER(c-NroSer).
  END.
  FIND FIRST tCcbcdocu NO-ERROR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      IF c-CodDoc = "BOL" THEN
          ASSIGN
          tCcbCDocu.DirCli:SENSITIVE = YES
          tCcbCDocu.NomCli:SENSITIVE = YES.
  END.

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tCcbCDocu"}

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

