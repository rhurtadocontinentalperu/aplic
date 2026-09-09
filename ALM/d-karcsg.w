&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE        VAR C-OP     AS CHAR.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE        VAR F-PESALM AS DECIMAL NO-UNDO.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

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
DEFINE BUFFER T-MATE FOR Almmmate.

/*******/
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.

/* Local Variable Definitions ---                                       */
DEFINE VAR F-Ingreso AS DECIMAL FORMAT "(>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-TotIng  AS DECIMAL FORMAT "(>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-Salida  AS DECIMAL FORMAT "(>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-Ventas  AS DECIMAL FORMAT "(>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-TotSal  AS DECIMAL FORMAT "(>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-Saldo   AS DECIMAL FORMAT "(>>>,>>9.99)" NO-UNDO.
DEFINE VAR F-STKGEN  AS DECIMAL FORMAT "(>>>,>>9.99)" NO-UNDO.

DEFINE VAR S-SUBTIT  AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VAR F-SPeso   AS DECIMAL FORMAT "(>,>>>,>>9.99)" NO-UNDO.

DEFINE BUFFER DMOV FOR Almdmov. 

DEFINE VAR I-NROITM  AS INTEGER.

DEFINE TEMP-TABLE  tmp-report LIKE w-report.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS F-CodFam F-SubFam DesdeC HastaC DesdeF ~
HastaF R-Tipo Btn_OK Btn_Cancel RECT-57 
&Scoped-Define DISPLAYED-OBJECTS F-CodFam F-SubFam DesdeC HastaC DesdeF ~
HastaF nCodMon R-Tipo F-DesFam F-DesSub 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesSub AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .69 NO-UNDO.

DEFINE VARIABLE F-SubFam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sub-linea" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(9)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 19.43 BY .46 NO-UNDO.

DEFINE VARIABLE R-Tipo AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Activados", "A",
"Desactivados", "D",
"Ambos", ""
     SIZE 12.72 BY 1.73 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.86 BY 8.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-CodFam AT ROW 1.85 COL 18 COLON-ALIGNED
     F-SubFam AT ROW 2.62 COL 18 COLON-ALIGNED
     DesdeC AT ROW 4.12 COL 18 COLON-ALIGNED
     HastaC AT ROW 4.12 COL 47 COLON-ALIGNED
     DesdeF AT ROW 4.81 COL 18 COLON-ALIGNED
     HastaF AT ROW 4.81 COL 47 COLON-ALIGNED
     nCodMon AT ROW 6.58 COL 20 NO-LABEL
     R-Tipo AT ROW 7.38 COL 20 NO-LABEL
     F-DesFam AT ROW 1.85 COL 24.29 COLON-ALIGNED NO-LABEL
     F-DesSub AT ROW 2.62 COL 24.29 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 10.38 COL 53.86
     Btn_Cancel AT ROW 10.38 COL 66.29
     "Estado" VIEW-AS TEXT
          SIZE 6.86 BY .69 AT ROW 7.46 COL 12.14
          FONT 1
     "Moneda" VIEW-AS TEXT
          SIZE 6.86 BY .58 AT ROW 6.54 COL 12.14
          FONT 6
     "Criterio de Seleccion" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     RECT-46 AT ROW 10.23 COL 1
     RECT-57 AT ROW 1.19 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 10.92
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Registro de Consignaciones"
         HEIGHT             = 10.92
         WIDTH              = 80
         MAX-HEIGHT         = 10.92
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 10.92
         VIRTUAL-WIDTH      = 80
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT W-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN F-DesFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesSub IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET nCodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Registro de Consignaciones */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Registro de Consignaciones */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Articulo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodFam W-Win
ON LEAVE OF F-CodFam IN FRAME F-Main /* Linea */
DO:
   ASSIGN F-CodFam.
   FIND Almtfami WHERE Almtfami.CodCia = S-CODCIA 
                  AND  Almtfami.codfam = F-CodFam 
                 NO-LOCK NO-ERROR.
   IF AVAILABLE Almtfami THEN 
      DISPLAY Almtfami.desfam @ F-DesFam WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-SubFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-SubFam W-Win
ON LEAVE OF F-SubFam IN FRAME F-Main /* Sub-linea */
DO:
   ASSIGN F-CodFam.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   IF F-CodFam = "" THEN DO:
      SELF:SCREEN-VALUE = "".
      RETURN.
   END.
   FIND AlmSFami WHERE AlmSFami.CodCia = S-CODCIA 
                  AND  AlmSFami.codfam = F-CodFam 
                  AND  AlmSFami.subfam = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF AVAILABLE AlmSFami THEN 
      DISPLAY AlmSFami.dessub @ F-DesSub WITH FRAME {&FRAME-NAME}.
   ELSE DO:
      MESSAGE "Codigo de Sub-Familia no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC W-Win
ON LEAVE OF HastaC IN FRAME F-Main /* A */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                 AND  Almmmatg.CodMat = SELF:SCREEN-VALUE 
                NO-LOCK NO-ERROR.  
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */

{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN DesdeC DesdeF F-CodFam F-DesFam HastaC HastaF nCodMon R-Tipo.

  IF HastaC <> "" THEN 
    S-SUBTIT = "Materiales del " + DesdeC + " al " + HastaC .
  ELSE 
    S-SUBTIT = "".

  IF HastaC = "" THEN HastaC = "999999999".
    
  S-SUBTIT = "Periodo del " + STRING(DesdeF) + " al " + STRING(HastaF).


  IF HastaC = "" THEN HastaC = "999999".
  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY F-CodFam F-SubFam DesdeC HastaC DesdeF HastaF nCodMon R-Tipo F-DesFam 
          F-DesSub 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE F-CodFam F-SubFam DesdeC HastaC DesdeF HastaF R-Tipo Btn_OK Btn_Cancel 
         RECT-57 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE S-CODMOV AS CHAR NO-UNDO. 
  DEFINE VARIABLE x-codpro LIKE Almcmov.codpro NO-UNDO.
  DEFINE VARIABLE x-codcli LIKE Almcmov.codcli NO-UNDO.
  DEFINE VARIABLE x-nrorf1 LIKE Almcmov.nrorf1 NO-UNDO.
  DEFINE VARIABLE x-nrorf2 LIKE Almcmov.nrorf2 NO-UNDO.
  DEFINE VARIABLE x-codmov LIKE Almcmov.codmov NO-UNDO.
  DEFINE VARIABLE x-FchRef AS DATE NO-UNDO.
  DEFINE VARIABLE x-SerRef AS CHAR NO-UNDO.
  DEFINE VARIABLE x-NroRef AS CHAR NO-UNDO.
  DEFINE VARIABLE x-NomPro AS CHAR NO-UNDO.
  DEFINE VARIABLE x-NroSer AS CHAR NO-UNDO.
  DEFINE VARIABLE x-NroDoc AS CHAR NO-UNDO.

  DEFINE VARIABLE x-inggen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-salgen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-totgen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-codmon LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-tpocmb LIKE Almdmov.candes NO-UNDO.

  DEFINE VARIABLE x-total AS DECIMAL.
  /* Tipo de movimiento de la salida por G/R */
  
  DEFINE FRAME F-REPORTE
         Almdmov.CodAlm FORMAT "X(3)"
         S-CODMOV       FORMAT "X(3)"
         Almdmov.FchDoc FORMAT "99/99/9999"
         x-FchRef       FORMAT "99/99/9999"
         x-SerRef       FORMAT "x(4)"
         x-NroRef       FORMAT "x(8)"
         x-CodPro       FORMAT "x(11)"
         x-NomPro       FORMAT "x(35)"
         x-NroSer       FORMAT "x(3)"
         x-NroDoc       FORMAT "x(6)"
         F-Ingreso      FORMAT ">>,>>>,>>9.99"
         F-Salida       FORMAT ">>,>>>,>>9.99"
         F-Ventas       FORMAT ">>,>>>,>>9.99"
         F-SALDO        FORMAT "(>>,>>>,>>9.99)"
  WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
                
  DEFINE FRAME F-HEADER
         HEADER
         S-NOMCIA FORMAT "X(50)" AT 1 SKIP
         "REGISTRO DE CONSIGNACIONES" AT 50
         "Pagina :" TO 150 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
         S-SUBTIT AT 1       SKIP
         "----------------------------------------------------------------------------------------------------------------------------------------------------------------"SKIP
         "Cod Cod Fecha de   Fecha de   Nº de G/R     RUC                                             Doc. Venta                    U  N  I  D  A  D  E  S                " SKIP
         "Alm Mov Operacion  G.Remision Serie Numero  Proveedor   Razon Social                      Serie Numero     Recibidos     Devueltos      Vendidos         Saldo  " SKIP
         "----------------------------------------------------------------------------------------------------------------------------------------------------------------"SKIP
/*
          123 123 99/99/9999 99/99/9999 1234 12345678 12345678901 12345678901234567890123456789012345 123 123456 >>,>>>,>>9.99 >>,>>>,>>9.99 >>,>>>,>>9.99 (>>,>>>,>>9.99)
*/
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
       
  ASSIGN
     x-inggen = 0
     x-salgen = 0
     x-totgen = 0  
     x-total  = 0.
  FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= DesdeF NO-LOCK NO-ERROR.
  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
                             AND  Almmmatg.CodMat >= DesdeC  
                             AND  Almmmatg.CodMat <= HastaC  
                             AND  Almmmatg.codfam BEGINS F-CodFam 
                             AND  Almmmatg.TpoArt BEGINS R-Tipo
                             AND Almmmatg.catconta[1] = 'CR' ,
      EACH Almdmov NO-LOCK USE-INDEX ALMD02 WHERE Almdmov.CodCia = Almmmatg.CodCia 
                            AND  Almdmov.codmat = Almmmatg.CodMat 
                            AND  Almdmov.FchDoc >= DesdeF 
                            AND  Almdmov.FchDoc <= HastaF                             
                           BREAK BY Almmmatg.CodCia 
                                 BY Almmmatg.CodMat
                                 BY Almdmov.FchDoc:
      DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(11)" 
              WITH FRAME F-Proceso.
              
      VIEW STREAM REPORT FRAME F-HEADER.
            
      IF FIRST-OF(Almmmatg.CodMat) THEN DO:
         /* BUSCAMOS SI TIENE MOVIMIENTOS ANTERIORES A DesdeF */
         FIND LAST AlmStkGe WHERE AlmstkGe.Codcia = Almmmatg.Codcia AND
                                AlmstkGe.CodMat = Almmmatg.CodMat AND
                                AlmstkGe.Fecha < DesdeF
                                NO-LOCK NO-ERROR.
         F-STKGEN = 0.
         F-SALDO  = 0.
     
         IF AVAILABLE AlmStkGe THEN DO:
            F-STKGEN = AlmStkGe.StkAct.
            F-SALDO  = AlmStkGe.StkAct.
         END.
         
         PUT STREAM REPORT 
            SPACE(1) SKIP
            Almmmatg.CodMat AT 002 FORMAT "X(9)"
            Almmmatg.DesMat AT 014 FORMAT "X(50)"
            Almmmatg.DesMar        FORMAT "x(30)"
            Almmmatg.UndStk        FORMAT "X(4)" 
            F-Saldo         AT 145 FORMAT "->>>,>>>,>>9.99".
         DOWN STREAM REPORT WITH FRAME F-REPORTE.
        ASSIGN
            x-FchRef = ?
            x-SerRef = ''
            x-NroRef = ''
            x-CodPro = ''
            x-NomPro = ''
            x-NroSer = ''
            x-NroDoc = ''.
      END.
      FIND Almtmovm WHERE Almtmovm.Codcia = Almdmov.Codcia AND
                          Almtmovm.TipMov = Almdmov.TipMov AND
                          Almtmovm.Codmov = Almdmov.Codmov
                          NO-LOCK NO-ERROR.
      IF AVAILABLE Almtmovm AND Almtmovm.Movtrf THEN NEXT.                          
      FIND Almacen WHERE Almacen.Codcia = S-CODCIA AND
                         Almacen.Codalm = Almdmov.Codalm 
                         NO-LOCK NO-ERROR.
      IF Almdmov.Codmov = 03 THEN NEXT.                   
      IF AVAILABLE Almacen and NOT Almacen.FlgRep  THEN NEXT.
      IF AVAILABLE Almacen and Almacen.AlmCsg  THEN NEXT.

      FIND Almcmov WHERE Almcmov.CodCia = Almdmov.codcia 
                    AND  Almcmov.CodAlm = Almdmov.codalm 
                    AND  Almcmov.TipMov = Almdmov.tipmov 
                    AND  Almcmov.CodMov = Almdmov.codmov 
                    AND  Almcmov.NroDoc = Almdmov.nrodoc 
                   NO-LOCK NO-ERROR.

      IF AVAILABLE Almcmov THEN DO:
        IF Almcmov.tipmov = 'I' /*AND Almcmov.codmov = 26*/
        THEN ASSIGN
                x-codpro = Almcmov.codpro
                x-fchref = Almcmov.fchcbd
                x-serref = SUBSTRING(Almcmov.nrorf2, 1, INDEX(Almcmov.nrorf2, '-') - 1)
                x-nroref = SUBSTRING(Almcmov.nrorf2, INDEX(Almcmov.nrorf2, '-') + 1).
        ASSIGN                
            x-nroser = SUBSTRING(Almcmov.nroref,1,3)
            x-nrodoc = SUBSTRING(Almcmov.nroref,4).
        FIND gn-prov WHERE gn-prov.codcia = pv-codcia
            AND gn-prov.codpro = x-codpro NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov
        THEN ASSIGN
                x-codpro = gn-prov.Ruc
                x-nompro = gn-prov.nompro.
        IF Almcmov.codref = 'G/R' THEN DO:
            ASSIGN
                x-nroser = ''
                x-nrodoc = ''.
            FIND LAST ccbcdocu WHERE ccbcdocu.codcia = s-codcia
                AND ccbcdocu.codref = almcmov.codref
                AND ccbcdocu.nroref = almcmov.nroref
                AND ccbcdocu.flgest <> 'A' NO-LOCK NO-ERROR.
            IF AVAILABLE ccbcdocu THEN DO:
                ASSIGN
                    x-nroser = SUBSTRING(ccbcdocu.nrodoc,1,3)
                    x-nrodoc = SUBSTRIN(ccbcdocu.nrodoc,4).
            END.
        END.
        IF Almcmov.tipmov = 'S' AND Almcmov.codmov = 26
        THEN ASSIGN
                x-serref = STRING(Almcmov.nroser, '999')
                x-nroref = STRING(Almcmov.nrodoc, '999999')
                x-codpro = ''
                x-nompro = ''.
        IF Almcmov.tipmov = 'S' AND Almcmov.codmov = 02
        THEN ASSIGN
                x-codpro = ''
                x-nompro = ''.
      END.
                  
      S-CODMOV  = Almdmov.TipMov + STRING(Almdmov.CodMov,"99"). 

      F-Ingreso = IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
      F-Salida  = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 AND Almdmov.codmov = 26 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
      F-Ventas  = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 AND Almdmov.codmov <> 26 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
      F-Saldo   = Almdmov.StkAct.

      DISPLAY STREAM REPORT 
         Almdmov.CodAlm 
         S-CODMOV       
         Almdmov.FchDoc 
         x-fchref       /*WHEN Almdmov.tipmov = 'I'*/
         x-SerRef       /*WHEN Almdmov.tipmov = 'I'*/
         x-NroRef       /*WHEN Almdmov.tipmov = 'I'*/
         x-CodPro       
         x-NomPro       
         x-NroSer       
         x-NroDoc       
         F-Ingreso      WHEN F-Ingreso <> 0
         F-Salida       WHEN F-Salida <> 0
         F-Ventas       WHEN F-Ventas <> 0
         F-SALDO        
        WITH FRAME F-REPORTE.


  END.    
  HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita W-Win 
PROCEDURE Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ENABLE ALL EXCEPT F-DesFam F-DesSub.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime W-Win 
PROCEDURE Imprime :
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
     s-print-file = SESSION:TEMP-DIRECTORY + "report.prn".
  
  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.

  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

  RUN Formato.
  
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/W-README.R(s-print-file).
  END CASE. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inhabilita W-Win 
PROCEDURE Inhabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    DISABLE ALL.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Variables W-Win 
PROCEDURE Inicializa-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN DesdeC DesdeF F-CodFam F-DesFam HastaC HastaF nCodMon R-Tipo.
  
  IF HastaC <> "" THEN HastaC = "".
  IF DesdeF <> ?  THEN DesdeF = ?.
  IF HastaF <> ?  THEN HastaF = ?.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN DesdeF = TODAY  + 1 - DAY(TODAY).
            HastaF = TODAY.
            R-Tipo = ''.
     DISPLAY DesdeF HastaF R-Tipo.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
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
        WHEN "F-Subfam" THEN ASSIGN input-var-1 = F-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        WHEN "F-marca1" OR WHEN "F-marca2" THEN ASSIGN input-var-1 = "MK".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _Header W-Win 
PROCEDURE _Header :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
titulo = "REPORTE DE MOVIMIENTOS POR DIA".

mens1 = "TIPO Y CODIGO DE MOVIMIENTO : " + C-TipMov + "-" + STRING(I-CodMov, "99") + " " + D-Movi:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
mens2 = "MATERIAL : " + DesdeC + " A: " + HastaC .
mens3 = "FECHA : " + STRING(F-FchDes, "99/99/9999") + " A: " + STRING(F-FchHas, "99/99/9999").

titulo = S-NomCia + fill(" ", (INT((90 - length(titulo)) / 2)) - length(S-NomCia)) + titulo.
mens1 = fill(" ", INT((90 - length(mens1)) / 2)) + mens1.
mens2 = fill(" ", INT((90 - length(mens2)) / 2)) + mens2.
mens3 = C-condicion:SCREEN-VALUE + fill(" ", INT((90 - length(mens3)) / 2) - LENGTH(C-condicion:SCREEN-VALUE)) + mens3.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

