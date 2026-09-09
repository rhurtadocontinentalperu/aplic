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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.

DEFINE        VAR C-OP     AS CHAR.
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
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6 SKIP
    Fi-Mensaje NO-LABEL FONT 6 SKIP     
    WITH CENTERED OVERLAY KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 
        TITLE "Procesando ..." FONT 7.
DEFINE BUFFER T-MATE FOR Almmmate.

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
&Scoped-Define ENABLED-OBJECTS RECT-57 Zona-D Zona-H DesdeC HastaC D-FchInv ~
I-TipIng Btn_OK Btn_Cancel Btn_Cancel-2 
&Scoped-Define DISPLAYED-OBJECTS Zona-D F-DesZonD Zona-H F-DesZonH DesdeC ~
F-DesMatD HastaC F-DesMatH D-FchInv I-TipIng 

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

DEFINE BUTTON Btn_Cancel-2 
     IMAGE-UP FILE "img\excel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5 TOOLTIP "Detallado por material y todos los almacenes"
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE D-FchInv AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha del Inventario" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Articulo Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesMatD AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesMatH AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesZonD AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesZonH AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .69 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Articulo Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE Zona-D AS CHARACTER FORMAT "X(256)":U 
     LABEL "Zona Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE Zona-H AS CHARACTER FORMAT "X(256)":U 
     LABEL "Zona Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE I-TipIng AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Por  Responsable", 1,
"Todos en General", 2
     SIZE 36.72 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 68 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 8.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Zona-D AT ROW 2.5 COL 16.86 COLON-ALIGNED
     F-DesZonD AT ROW 2.5 COL 27.86 COLON-ALIGNED NO-LABEL
     Zona-H AT ROW 3.31 COL 16.86 COLON-ALIGNED
     F-DesZonH AT ROW 3.31 COL 27.86 COLON-ALIGNED NO-LABEL
     DesdeC AT ROW 4.12 COL 16.86 COLON-ALIGNED
     F-DesMatD AT ROW 4.12 COL 27.86 COLON-ALIGNED NO-LABEL
     HastaC AT ROW 4.88 COL 16.86 COLON-ALIGNED
     F-DesMatH AT ROW 4.88 COL 27.86 COLON-ALIGNED NO-LABEL
     D-FchInv AT ROW 5.65 COL 16.86 COLON-ALIGNED
     I-TipIng AT ROW 6.5 COL 18.86 NO-LABEL
     Btn_OK AT ROW 10.31 COL 34.14
     Btn_Cancel AT ROW 10.31 COL 45.72
     Btn_Cancel-2 AT ROW 10.35 COL 57.29 WIDGET-ID 2
     "Criterio de Selección" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     RECT-57 AT ROW 1.23 COL 1.57
     RECT-46 AT ROW 10.23 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.43 BY 10.96
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
         TITLE              = "Productos no Inventariados"
         HEIGHT             = 10.96
         WIDTH              = 69.43
         MAX-HEIGHT         = 10.96
         MAX-WIDTH          = 69.43
         VIRTUAL-HEIGHT     = 10.96
         VIRTUAL-WIDTH      = 69.43
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN F-DesMatD IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesMatH IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesZonD IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesZonH IN FRAME F-Main
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
ON END-ERROR OF W-Win /* Productos no Inventariados */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Productos no Inventariados */
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


&Scoped-define SELF-NAME Btn_Cancel-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel-2 W-Win
ON CHOOSE OF Btn_Cancel-2 IN FRAME F-Main /* Cancelar */
DO:
  RUN Asigna-Variables.
  SESSION:SET-WAIT-STATE("GENERAL").
    RUN Excel.
  SESSION:SET-WAIT-STATE("").

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


&Scoped-define SELF-NAME D-FchInv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-FchInv W-Win
ON LEAVE OF D-FchInv IN FRAME F-Main /* Fecha del Inventario */
DO:
    ASSIGN D-FchInv.
    
    IF D-FchInv = ? THEN RETURN.
    
     FIND InvConfig WHERE InvConfig.CodCia = S-CODCIA 
                     AND  InvConfig.CodAlm = S-CODALM 
                     AND  InvConfig.FchInv = D-FchInv
                    NO-LOCK NO-ERROR.
     IF NOT AVAILABLE InvConfig THEN DO:
        MESSAGE "Fecha de Inventario no existe"
                VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
     END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Articulo Desde */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
                      Almmmatg.CodMat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  DISPLAY Almmmatg.DesMat @ F-DesMatD WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC W-Win
ON LEAVE OF HastaC IN FRAME F-Main /* Articulo Hasta */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
                      Almmmatg.CodMat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.  
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  DISPLAY Almmmatg.DesMat @ F-DesMatH WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-TipIng
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-TipIng W-Win
ON VALUE-CHANGED OF I-TipIng IN FRAME F-Main
DO:
  ASSIGN I-TipIng.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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
  ASSIGN DesdeC HastaC D-FchInv I-TipIng Zona-D Zona-H.
  
  IF HastaC = "" THEN HastaC = "999999".
  IF Zona-H = "" THEN Zona-H = "ZZZZZZZZZZZ".

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
  DISPLAY Zona-D F-DesZonD Zona-H F-DesZonH DesdeC F-DesMatD HastaC F-DesMatH 
          D-FchInv I-TipIng 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 Zona-D Zona-H DesdeC HastaC D-FchInv I-TipIng Btn_OK 
         Btn_Cancel Btn_Cancel-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 4.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Header del Excel */
cRange = "B" + '2'.
chWorkSheet:Range(cRange):Value = "PRODUCTOS NO INVENTARIADOS".
cRange = "A" + '1'.
chWorkSheet:Range(cRange):Value = "Al".
cRange = "A" + '1'.
chWorkSheet:Range(cRange):Value = d-FchInv.
cRange = "E" + '2'.
chWorkSheet:Range(cRange):Value = "Fecha".
cRange = "F" + '2'.
chWorkSheet:Range(cRange):Value = TODAY.
cRange = "E" + '3'.
chWorkSheet:Range(cRange):Value = "Hora:".
cRange = "F" + '3'.
chWorkSheet:Range(cRange):Value = TIME.

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".

/* set the column names for the Worksheet */
cColumn = STRING(t-Column).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Código".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion                        ".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Marca                      ".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Und. Stock".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Almacén".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Stock".

FIND InvConfig WHERE InvConfig.CodCia = S-CODCIA 
               AND  InvConfig.CodAlm = S-CODALM 
               AND  InvConfig.FchInv = D-FchInv
               NO-LOCK NO-ERROR.

IF NOT AVAILABLE InvConfig THEN DO:
   MESSAGE "No existe la configuracion de inventario" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.

loopREP:
FOR EACH Almmmate WHERE Almmmate.CodCia = S-CODCIA
                   AND  Almmmate.CodAlm = S-CODALM
                   AND  (Almmmate.CodMat >= DesdeC
                   AND   Almmmate.CodMat <= HastaC)
                   AND  (Almmmate.CodUbi >= Zona-D
                   AND   Almmmate.CodUbi <= Zona-H
                   AND   Almmmate.CodUbi <> "") 

                  BREAK BY Almmmate.CodCia
                        BY Almmmate.CodAlm
                        BY Almmmate.CodUbi
                        BY Almmmate.CodMat:

      DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(8)" WITH FRAME F-Proceso.
      
    
    /* VEAMOS SI TIENE STOCK A LA FECHA */
    FIND LAST Almstkal WHERE AlmStkal.CodCia = s-codcia
        AND AlmStkal.CodAlm = Almmmate.codalm 
        AND AlmStkal.codmat = Almmmate.codmat
        AND AlmStkal.Fecha <= d-FchInv
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almstkal AND AlmStkal.StkAct = 0 THEN NEXT.
    IF NOT AVAILABLE Almstkal THEN NEXT.

    /* UBICAMOS EL CONTEO Y RECONTEO */
    FIND InvConteo WHERE InvConteo.CodCia = Almmmate.CodCia
                    AND  InvConteo.FchInv = D-FCHINV
                    AND  InvConteo.CodAlm = Almmmate.CodAlm 
                    AND  InvConteo.CodMat = Almmmate.CodMat 
                   NO-LOCK NO-ERROR.
    FIND InvRecont WHERE InvRecont.CodCia = Almmmate.CodCia 
                    AND  InvRecont.CodAlm = Almmmate.CodAlm 
                    AND  InvConteo.FchInv = D-FCHINV
                    AND  InvRecont.CodMat = Almmmate.CodMat 
                   NO-LOCK NO-ERROR.
    IF (AVAILABLE InvConteo ) OR (AVAILABLE InvRecont ) THEN NEXT.
    
    IF FIRST-OF(Almmmate.CodUbi) THEN DO:
        FIND almtubic WHERE almtubic.CodCia = S-CODCIA
             AND  almtubic.CodAlm = S-CODALM
             AND  almtubic.CodUbi = Almmmate.CodUbi 
             NO-LOCK NO-ERROR.
             t-Column = t-Column + 1.
             cColumn = STRING(t-Column).
             cRange = "A" + cColumn.
             chWorkSheet:Range(cRange):Value = Almmmate.CodMat.
             cRange = "B" + cColumn.
             chWorkSheet:Range(cRange):Value = almtubic.DesUbi.             
    END. /*IF FIRST-OF....*/

    FIND Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia 
         AND  Almmmatg.CodMat = Almmmate.CodMat NO-LOCK NO-ERROR.
    
    IF AVAIL Almmmatg THEN DO:
          t-Column = t-Column + 1.
          cColumn = STRING(t-Column).
          cRange = "A" + cColumn.
          chWorkSheet:Range(cRange):Value = Almmmate.CodMat.
          cRange = "B" + cColumn.
          chWorkSheet:Range(cRange):Value = Almmmatg.desmat.
          cRange = "C" + cColumn.
          chWorkSheet:Range(cRange):Value = Almmmatg.desMar.
          cRange = "D" + cColumn.
          chWorkSheet:Range(cRange):Value = Almmmatg.undstk.
          cRange = "E" + cColumn.
          chWorkSheet:Range(cRange):Value = Almmmate.codalm.
          cRange = "F" + cColumn.
          chWorkSheet:Range(cRange):Value = Almmmate.stkact.
          IF LAST-OF(Almmmate.CodUbi) THEN t-Column = t-Column + 2.        
    END.    
END.

HIDE FRAME f-Proceso.

/* launch Excel so it is visible to the user */
 chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
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
  DEFINE FRAME F-REPORTE
        Almmmate.CodMat  
        Almmmatg.desmat
        Almmmatg.DesMar
        Almmmatg.undstk
        Almmmate.codalm
        Almmmate.stkact 
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
         HEADER
       /*  {&Prn2} + {&Prn7A} + {&Prn6A} +*/ S-NOMCIA /*+ {&Prn7B} + {&Prn6A} + {&Prn3}*/ FORMAT "X(50)" AT 1 SKIP
         "PRODUCTOS NO INVENTARIADOS" AT 45 FORMAT 'X(40)'
         "Pagina :" TO 114 PAGE-NUMBER(REPORT) TO 126 FORMAT "ZZZZZ9" SKIP
         "Al " AT 47 d-FchInv FORMAT '99/99/9999' 
         "Fecha :" TO 114 TODAY TO 126 FORMAT "99/99/9999" SKIP
         "Hora :"  TO 114 STRING(TIME,"HH:MM") TO 126 SKIP
         "------------------------------------------------------------------------------------------------------------------------------" SKIP
         "                                                                                    UND  COD           STOCK     " SKIP
         "CODIGO DESCRIPCION                                  MARCA                           STK  ALM                     " SKIP
         "------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 


FIND InvConfig WHERE InvConfig.CodCia = S-CODCIA 
               AND  InvConfig.CodAlm = S-CODALM 
               AND  InvConfig.FchInv = D-FchInv
               NO-LOCK NO-ERROR.

IF NOT AVAILABLE InvConfig THEN DO:
   MESSAGE "No existe la configuracion de inventario" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.


FOR EACH Almmmate WHERE Almmmate.CodCia = S-CODCIA
                   AND  Almmmate.CodAlm = S-CODALM
                   AND  (Almmmate.CodMat >= DesdeC
                   AND   Almmmate.CodMat <= HastaC)
                   AND  (Almmmate.CodUbi >= Zona-D
                   AND   Almmmate.CodUbi <= Zona-H
                   AND   Almmmate.CodUbi <> "") 

                  BREAK BY Almmmate.CodCia
                        BY Almmmate.CodAlm
                        BY Almmmate.CodUbi
                        BY Almmmate.CodMat:

      DISPLAY Almmmate.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
              FORMAT "X(8)" WITH FRAME F-Proceso.
      VIEW STREAM REPORT FRAME F-HEADER.
    
    /* VEAMOS SI TIENE STOCK A LA FECHA */
    FIND LAST Almstkal WHERE AlmStkal.CodCia = s-codcia
        AND AlmStkal.CodAlm = Almmmate.codalm 
        AND AlmStkal.codmat = Almmmate.codmat
        AND AlmStkal.Fecha <= d-FchInv
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almstkal AND AlmStkal.StkAct = 0 THEN NEXT.
    IF NOT AVAILABLE Almstkal THEN NEXT.

    /* UBICAMOS EL CONTEO Y RECONTEO */
    FIND InvConteo WHERE InvConteo.CodCia = Almmmate.CodCia
                    AND  InvConteo.FchInv = D-FCHINV
                    AND  InvConteo.CodAlm = Almmmate.CodAlm 
                    AND  InvConteo.CodMat = Almmmate.CodMat 
                   NO-LOCK NO-ERROR.
    FIND InvRecont WHERE InvRecont.CodCia = Almmmate.CodCia 
                    AND  InvRecont.CodAlm = Almmmate.CodAlm 
                    AND  InvConteo.FchInv = D-FCHINV
                    AND  InvRecont.CodMat = Almmmate.CodMat 
                   NO-LOCK NO-ERROR.
    IF (AVAILABLE InvConteo ) OR (AVAILABLE InvRecont ) THEN NEXT.
    
    IF FIRST-OF(Almmmate.CodUbi) THEN DO:
        FIND almtubic WHERE almtubic.CodCia = S-CODCIA
                       AND  almtubic.CodAlm = S-CODALM
                       AND  almtubic.CodUbi = Almmmate.CodUbi 
                      NO-LOCK NO-ERROR.
        DISPLAY STREAM REPORT 
            Almmmate.CodUbi @ Almmmate.CodMat  
            almtubic.DesUbi WHEN AVAILABLE Almtubic @ Almmmatg.desmat 
           WITH FRAME F-REPORTE.
        UNDERLINE STREAM REPORT 
            Almmmate.CodMat  
            Almmmatg.desmat
           WITH FRAME F-REPORTE.
    END.    
      FIND Almmmatg WHERE Almmmatg.CodCia = Almmmate.CodCia 
                     AND  Almmmatg.CodMat = Almmmate.CodMat 
                    NO-LOCK NO-ERROR.
      IF AVAIL Almmmatg THEN DO:
        DISPLAY STREAM REPORT 
            Almmmate.CodMat  
            Almmmatg.desmat
            Almmmatg.desMar
            Almmmatg.undstk
            Almmmate.codalm
            Almmmate.stkact 
           WITH FRAME F-REPORTE.
        DOWN STREAM REPORT WITH FRAME F-REPORTE.
      END.          

    IF LAST-OF(Almmmate.CodUbi) THEN DO:
        DOWN 2 STREAM REPORT WITH FRAME F-REPORTE.
    END.    

END.
HIDE FRAME F-PROCESO.

END PROCEDURE.




/*IF I-TipIng = 2 THEN DO:
 *     FOR EACH InvConteo WHERE InvConteo.CodCia = S-CODCIA
 *                         AND  InvConteo.CodAlm = S-CODALM
 *                         AND  InvConteo.FchInv = D-FCHINV NO-LOCK,
 *         EACH InvRecont WHERE InvRecont.CodCia = InvConteo.CodCia
 *                         AND  InvRecont.CodAlm = InvConteo.CodAlm
 *                         AND  InvRecont.FchInv = InvConteo.FchInv
 *                         AND  InvRecont.codmat = InvConteo.codmat NO-LOCK,
 *         EACH Almmmatg OF InvConteo NO-LOCK.
 *     END.      
 * END.
 * ELSE DO:
 *     FOR EACH InvConteo WHERE InvConteo.CodCia = S-CODCIA
 *                         AND  InvConteo.CodAlm = S-CODALM
 *                         AND  InvConteo.FchInv = D-FCHINV
 *                         AND  InvConteo.Responsable = S-USER-ID NO-LOCK,
 *         EACH InvRecont WHERE InvRecont.CodCia = InvConteo.CodCia
 *                         AND  InvRecont.CodAlm = InvConteo.CodAlm
 *                         AND  InvRecont.FchInv = InvConteo.FchInv
 *                         AND  InvRecont.codmat = InvConteo.codmat NO-LOCK,
 *         EACH Almmmatg OF InvConteo NO-LOCK.
 *     END.    
 * END.*/


/*    /* UBICAMOS EL STOCK GENERAL */
 *     FIND LAST Almdmov WHERE Almdmov.CodCia = Almmmate.CodCia 
 *                        AND  Almdmov.CodMat = Almmmate.CodMat 
 *                        AND  Almdmov.fchdoc <= InvConfig.FchInv 
 *                       USE-INDEX Almd02 NO-LOCK NO-ERROR.
 *     IF AVAILABLE Almdmov THEN 
 *         F-STKGEN = Almdmov.StkAct.
 *     ELSE 
 *         F-STKGEN = 0.
 *         
 *     IF AVAILABLE Almdmov AND ICodMon = 1 THEN F-VALCTO = Almdmov.VctoMn1.
 *     IF AVAILABLE Almdmov AND ICodMon = 2 THEN F-VALCTO = Almdmov.VctoMn2.
 *     
 *     /* UBICAMOS EL STOCK DE ALMACEN */
 *     FIND LAST Almdmov WHERE Almdmov.CodCia = Almmmate.CodCia 
 *                        AND  Almdmov.CodAlm = Almmmate.CodAlm 
 *                        AND  Almdmov.CodMat = Almmmate.CodMat 
 *                        AND  Almdmov.fchdoc <= InvConfig.FchInv 
 *                       USE-INDEX Almd03 NO-LOCK NO-ERROR.
 *     IF AVAILABLE Almdmov THEN 
 *         F-STKALM = Almdmov.StkSub.
 *     ELSE 
 *         F-STKALM = 0.*/

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
    ENABLE ALL EXCEPT F-DesMatD F-DesMatH F-DesZonD F-DesZonH.
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

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn3}.
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
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
  ASSIGN DesdeC HastaC D-FchInv I-TipIng Zona-D Zona-H.
  
  IF HastaC <> "" THEN HastaC = "".
  IF Zona-H <> "" THEN Zona-H = "".

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
     FIND LAST InvConfig WHERE InvConfig.CodCia = S-CODCIA 
                          AND  InvConfig.CodAlm = S-CODALM 
                         NO-LOCK NO-ERROR.
     IF AVAILABLE InvConfig THEN D-FchInv = InvConfig.FchInv.
     DISPLAY D-FchInv.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
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
/*        WHEN "F-Subfam" THEN ASSIGN input-var-1 = F-CodFam:SCREEN-VALUE IN FRAME {&FRAME-NAME}.*/
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

