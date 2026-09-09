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

FIND LAST InvConfig WHERE InvConfig.CodCia = S-CODCIA 
    AND InvConfig.CodAlm = S-CODALM 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE InvConfig THEN DO:
    MESSAGE 'No está configurado el inventario' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

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

DEF VAR s-SubTit AS CHAR NO-UNDO.

DEF TEMP-TABLE T-Ajuste
    FIELD CodCia LIKE Almmmatg.codcia
    FIELD CodAlm LIKE Almdmov.Codalm
    FIELD CodMat LIKE Almmmatg.CodMat
    FIELD DesMat LIKE Almmmatg.CodMat
    FIELD DesMar LIKE Almmmatg.DesMar
    FIELD UndStk LIKE Almmmatg.CodMat
    FIELD CodFam LIKE Almmmatg.CodFam    
    FIELD CodUbi LIKE Almmmate.CodUbi
    FIELD StkAct LIKE Almmmate.StkAct
    FIELD StkSub LIKE Almdmov.CanDes
    FIELD Dife   LIKE Almdmov.CanDes
    FIELD TipMov LIKE Almdmov.TipMov
    FIELD TipInv LIKE Almdmov.TipMov
    FIELD CtoUni AS DEC
    INDEX Idx01 IS UNIQUE PRIMARY CodAlm CodMat.

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
&Scoped-Define ENABLED-OBJECTS x-codalm BUTTON-1 x-FchInv Btn_OK Btn_Cancel ~
Btn_Cancel-2 
&Scoped-Define DISPLAYED-OBJECTS x-codalm x-FchInv x-mensaje 

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

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE VARIABLE x-codalm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 47 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-FchInv AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Inventario" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 69 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-codalm AT ROW 3.15 COL 12 COLON-ALIGNED WIDGET-ID 30
     BUTTON-1 AT ROW 3.15 COL 61.86 WIDGET-ID 32
     x-FchInv AT ROW 4.77 COL 26 COLON-ALIGNED WIDGET-ID 34
     x-mensaje AT ROW 7.46 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     Btn_OK AT ROW 10.42 COL 34
     Btn_Cancel AT ROW 10.42 COL 45.43
     Btn_Cancel-2 AT ROW 10.42 COL 57 WIDGET-ID 2
     "Criterio de Selección" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1.38 COL 5.43
          FONT 6
     RECT-46 AT ROW 10.23 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 70.14 BY 11.12
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
         TITLE              = "DIFERENCIA RAPIDA VALORIZADA"
         HEIGHT             = 11.12
         WIDTH              = 70.14
         MAX-HEIGHT         = 11.12
         MAX-WIDTH          = 70.14
         VIRTUAL-HEIGHT     = 11.12
         VIRTUAL-WIDTH      = 70.14
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
/* SETTINGS FOR RECTANGLE RECT-46 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* DIFERENCIA RAPIDA VALORIZADA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* DIFERENCIA RAPIDA VALORIZADA */
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
  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.  
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
  DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEF VAR x-Almacenes AS CHAR.
    x-Almacenes = x-CodAlm:SCREEN-VALUE.
    RUN alm/d-repalm (INPUT-OUTPUT x-Almacenes).
    x-CodAlm:SCREEN-VALUE = x-Almacenes.
    
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
    ASSIGN
        x-codalm
        x-FchInv.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-StkSub AS DEC NO-UNDO.
  DEF VAR x-CanInv AS DEC NO-UNDO.
  DEF VAR x-Dife   AS DEC NO-UNDO.
  DEF VAR x-CodUbi AS CHAR NO-UNDO.
    
  FOR EACH T-Ajuste:
    DELETE T-Ajuste.
  END.

  FOR EACH AlmCInv WHERE AlmCInv.CodCia = s-codcia
      AND LOOKUP(AlmCInv.CodAlm,x-codalm) > 0 
      AND AlmCInv.NomCia = "CONTI" 
      AND DATE(AlmCInv.FecUpdate) <= x-FchInv NO-LOCK:
      X-CanInv = 0.
      X-StkSub = 0.  
      FOR EACH AlmDInv OF AlmCInv NO-LOCK,
          FIRST almmmatg OF almdinv NO-LOCK:
          DISPLAY "PROCESANDO: " + Almmmatg.codmat + "-" + Almmmatg.DesMat @ x-mensaje 
              WITH FRAME {&FRAME-NAME}.
          IF AVAIL AlmDInv THEN DO:
              X-StkSub = AlmDInv.QtyFisico.
              X-CanInv = AlmDInv.libre_d01.
          END.
          X-Dife = X-CanInv - X-StkSub.
          IF X-Dife <> 0 
              THEN DO:
              CREATE T-Ajuste.
              ASSIGN 
                  T-Ajuste.CodMat = Almmmatg.CodMat
                  T-Ajuste.DesMat = Almmmatg.DesMat
                  T-Ajuste.DesMar = Almmmatg.DesMar
                  T-Ajuste.UndStk = Almmmatg.UndStk
                  T-Ajuste.CodFam = Almmmatg.CodFam
                  T-Ajuste.CodAlm = AlmCInv.CodAlm
                  T-Ajuste.CodUbi = AlmDInv.CodUbi
                  T-Ajuste.StkAct = x-StkSub
                  T-Ajuste.StkSub = x-CanInv
                  T-Ajuste.Dife   = X-Dife.
            FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia
                AND AlmStkGe.codmat = Almmmatg.codmat
                /*
                AND AlmStkGe.fecha <= x-FchInv
                */
                AND AlmStkGe.fecha <= AlmDInv.Libre_f01
                NO-LOCK NO-ERROR.
            IF AVAILABLE AlmStkGe THEN T-Ajuste.CtoUni = AlmStkge.CtoUni. 
          END.
      END.
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
  DISPLAY x-codalm x-FchInv x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-codalm BUTTON-1 x-FchInv Btn_OK Btn_Cancel Btn_Cancel-2 
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

DEF VAR x-CtoPos AS DEC NO-UNDO.
s-SubTit = 'ALMACEN(ES) ' + x-codalm.
RUN Carga-Temporal.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Header*/
cRange = "A" + '2'.
chWorkSheet:Range(cRange):Value = s-NomCia.
cRange = "C" + '2'.
chWorkSheet:Range(cRange):Value = "DIFERENCIA RAPIDA DE INVENTARIO".
/* chWorkSheet:FONT:Bold = TRUE. */
cRange = "A" + '3'.
chWorkSheet:Range(cRange):Value = s-SubTit.
cRange = "H" + '3'.
chWorkSheet:Range(cRange):Value = "Fecha: ".
cRange = "I" + '3'.
chWorkSheet:Range(cRange):Value = TODAY.

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("B"):NumberFormat = "@".

/* set the column names for the Worksheet */
 cColumn = STRING(t-Column).
 cRange = "A" + cColumn.
 chWorkSheet:Range(cRange):Value = "Almc".
 cRange = "B" + cColumn.
 chWorkSheet:Range(cRange):Value = "Código".
 cRange = "C" + cColumn.
 chWorkSheet:Range(cRange):Value = "Descripción                        ".
 cRange = "D" + cColumn.
 chWorkSheet:Range(cRange):Value = "Marca                    ".
 cRange = "E" + cColumn.
 chWorkSheet:Range(cRange):Value = "Unidad    ".
 cRange = "F" + cColumn.
 chWorkSheet:Range(cRange):Value = "Sistema   ".
 cRange = "G" + cColumn.
 chWorkSheet:Range(cRange):Value = "Conteo    ".
 /*
 cRange = "G" + cColumn.
 chWorkSheet:Range(cRange):Value = "Diferencia (+)".
 cRange = "H" + cColumn.
 chWorkSheet:Range(cRange):Value = "Diferencia (-)".
 cRange = "I" + cColumn.
 chWorkSheet:Range(cRange):Value = "Zona      ".
 cRange = "J" + cColumn.
 chWorkSheet:Range(cRange):Value = "Importe (+)".
 cRange = "K" + cColumn.
 chWorkSheet:Range(cRange):Value = "Importe (-)".
 */
 cRange = "H" + cColumn.
 chWorkSheet:Range(cRange):Value = "Diferencia".
 cRange = "I" + cColumn.
 chWorkSheet:Range(cRange):Value = "Zona      ".
 cRange = "J" + cColumn.
 chWorkSheet:Range(cRange):Value = "Importe".

loopREP:
FOR EACH T-Ajuste, FIRST Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
    AND Almtfami.codfam = T-Ajuste.codfam
    BREAK BY T-Ajuste.codcia 
        BY T-Ajuste.CodAlm 
        BY T-Ajuste.CodFam 
        BY T-Ajuste.desmat:

    IF FIRST-OF(T-Ajuste.CodFam) THEN DO:
        t-Column = t-Column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = T-Ajuste.CodFam.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = Almtfami.desfam.        
    END.
    
    ASSIGN
        x-CtoPos = 0.
        
    x-CtoPos = T-Ajuste.Dife * T-Ajuste.CtoUni.
    
    ACCUMULATE x-CtoPos (TOTAL BY T-Ajuste.CodCia BY T-Ajuste.CodFam).    
    ACCUMULATE x-CtoPos (TOTAL BY T-Ajuste.CodCia BY T-Ajuste.CodAlm).    

    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Ajuste.CodAlm.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Ajuste.CodMat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Ajuste.desmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Ajuste.desmar.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Ajuste.undstk.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Ajuste.stkact.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Ajuste.stksub.
    /*
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = x-DifPos.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = x-DifNeg.    
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Ajuste.CodUbi.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = x-CtoPos.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = x-CtoNeg.
    */

    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Ajuste.Dife.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Ajuste.CodUbi.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Ajuste.Dife * T-Ajuste.CtoUni.

    IF LAST-OF(T-Ajuste.CodFam) THEN DO:
        t-Column = t-Column + 1.
        cColumn = STRING(t-Column).
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = "SUBTOTAL FAM: " + T-Ajuste.CodFam.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY T-Ajuste.CodFam x-CtoPos.
    END.
    IF LAST-OF(T-Ajuste.CodAlm) THEN DO:
        t-Column = t-Column + 1.
        cColumn = STRING(t-Column).
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = "SUBTOTAL ALM: " + T-Ajuste.CodAlm.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY T-Ajuste.CodAlm x-CtoPos.
    END.
    IF LAST-OF(T-Ajuste.codcia) THEN DO:
        t-Column = t-Column + 1.
        cColumn = STRING(t-Column).
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = "TOTAL : ".
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY T-Ajuste.CodCia x-CtoPos.
    END.

/*
    IF LAST-OF(T-Ajuste.CodFam) THEN DO:
        t-Column = t-Column + 1.
        cColumn = STRING(t-Column).
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY T-Ajuste.CodFam x-CtoPos.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY T-Ajuste.CodFam x-CtoNeg.                
    END.
    IF LAST-OF(T-Ajuste.codcia) THEN DO:
        t-Column = t-Column + 1.
        cColumn = STRING(t-Column).
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY T-Ajuste.CodCia x-CtoPos.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = ACCUM TOTAL BY T-Ajuste.CodCia x-CtoNeg.                
    END.
*/    
  END.

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
  DEF VAR x-DifPos AS DEC NO-UNDO.
  DEF VAR x-DifNeg AS DEC NO-UNDO.
  DEF VAR x-CtoPos AS DEC NO-UNDO.
  DEF VAR x-CtoNeg AS DEC NO-UNDO.
  DEFINE FRAME F-DETALLE
    T-Ajuste.CodAlm     COLUMN-LABEL "Almc"          
    T-Ajuste.CodMat     COLUMN-LABEL "Codigo"          
    T-Ajuste.desmat     COLUMN-LABEL "Descripcion"      FORMAT 'X(45)'
    T-Ajuste.desmar     COLUMN-LABEL "Marca"            FORMAT 'X(10)'
    T-Ajuste.undstk     COLUMN-LABEL "Unidad"           FORMAT 'X(5)'
    T-Ajuste.stkact     COLUMN-LABEL "Sistema"          FORMAT '->>>>,>>9.99'
    T-Ajuste.stksub     COLUMN-LABEL "Conteo"           FORMAT '->>>>,>>9.99'
    x-DifPos            COLUMN-LABEL "Diferencia "      FORMAT '->>>>,>>9.99'
    /*x-DifNeg            COLUMN-LABEL "Diferencia -"     FORMAT '->>>>,>>9.99'*/
    T-Ajuste.CodUbi     COLUMN-LABEL "Zona"             FORMAT 'x(10)'
    x-CtoPos            COLUMN-LABEL "Importe "         FORMAT '->>>>,>>9.99'
    /*x-CtoNeg            COLUMN-LABEL "Importe -"        FORMAT '->>>>,>>9.99'*/
  WITH WIDTH 320 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
    HEADER
    S-NOMCIA FORMAT "X(50)" AT 1 SKIP
    "DIFERENCIA RAPIDA DE INVENTARIO" AT 20 
    "Pagina :" TO 100 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
    "Fecha :" TO 100 TODAY FORMAT "99/99/9999" SKIP
    s-SubTit FORMAT 'x(50)' SKIP
  WITH PAGE-TOP WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  FOR EACH T-Ajuste, FIRST Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia
        AND Almtfami.codfam = T-Ajuste.codfam
        BREAK BY T-Ajuste.codcia 
            BY T-Ajuste.CodAlm 
            BY T-Ajuste.CodFam 
            BY T-Ajuste.desmat:
    VIEW STREAM REPORT FRAME F-HEADER.
    IF FIRST-OF(T-Ajuste.CodFam) THEN DO:
        DISPLAY STREAM REPORT
            T-Ajuste.CodFam @ T-Ajuste.CodMat
            Almtfami.desfam @ T-Ajuste.DesMat
            WITH FRAME F-DETALLE.
        UNDERLINE STREAM REPORT
            T-Ajuste.CodMat
            T-Ajuste.DesMat
            WITH FRAME F-DETALLE.
        DOWN STREAM REPORT WITH FRAME F-DETALLE.
    END.
    ASSIGN
        x-DifPos = 0
        x-CtoPos = 0
        x-DifNeg = 0
        x-CtoNeg = 0.

    x-DifPos = T-Ajuste.Dife.
    x-CtoPos = T-Ajuste.Dife * T-Ajuste.CtoUni.    
    ACCUMULATE x-CtoPos (TOTAL BY T-Ajuste.CodCia BY T-Ajuste.CodFam).
    ACCUMULATE x-CtoPos (TOTAL BY T-Ajuste.CodCia BY T-Ajuste.CodAlm).

    /*
    IF T-Ajuste.Dife >= 0
    THEN ASSIGN
            x-DifPos = T-Ajuste.Dife
            x-CtoPos = T-Ajuste.Dife * T-Ajuste.CtoUni.
    ELSE ASSIGN
            x-DifNeg = T-Ajuste.Dife
            x-CtoNeg = T-Ajuste.Dife * T-Ajuste.CtoUni.
    ACCUMULATE x-CtoPos (TOTAL BY T-Ajuste.CodCia BY T-Ajuste.CodFam).
    ACCUMULATE x-CtoNeg (TOTAL BY T-Ajuste.CodCia BY T-Ajuste.CodFam).
    */

    DISPLAY STREAM REPORT 
        T-Ajuste.CodAlm     
        T-Ajuste.CodMat     
        T-Ajuste.desmat     
        T-Ajuste.desmar     
        T-Ajuste.undstk     
        T-Ajuste.stkact     
        T-Ajuste.stksub     
        x-DifPos
        /*x-DifNeg*/
        T-Ajuste.CodUbi     
        x-CtoPos
        /*x-CtoNeg*/
        WITH FRAME F-DETALLE.
    IF LAST-OF(T-Ajuste.CodFam) THEN DO:
        UNDERLINE STREAM REPORT x-CtoPos WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            "SUBTOTAL FAM: " + T-Ajuste.CodFam      @ x-CtoPos
            ACCUM TOTAL BY T-Ajuste.CodFam x-CtoPos @ x-CtoPos
            /*ACCUM TOTAL BY T-Ajuste.CodFam x-CtoNeg @ x-CtoNeg*/
            WITH FRAME F-DETALLE.
    END.
    IF LAST-OF(T-Ajuste.CodAlm) THEN DO:
        UNDERLINE STREAM REPORT x-CtoPos WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            "SUBTOTAL ALM: " + T-Ajuste.CodAlm      @ x-CtoPos
            ACCUM TOTAL BY T-Ajuste.CodAlm x-CtoPos @ x-CtoPos
            /*ACCUM TOTAL BY T-Ajuste.CodFam x-CtoNeg @ x-CtoNeg*/
            WITH FRAME F-DETALLE.
    END.
    IF LAST-OF(T-Ajuste.codcia) THEN DO:
        UNDERLINE STREAM REPORT x-CtoPos WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            "TOTAL : "                              @ x-CtoPos
            ACCUM TOTAL BY T-Ajuste.CodCia x-CtoPos @ x-CtoPos
            /*ACCUM TOTAL BY T-Ajuste.CodCia x-CtoNeg @ x-CtoNeg*/
            WITH FRAME F-DETALLE.
    END.
  END.

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
    ENABLE ALL EXCEPT x-mensaje .
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

    RUN Carga-Temporal.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    s-SubTit = 'ALMACEN(ES) ' + x-codalm.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
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
  /*
  DEF VAR l-FchInv LIKE InvConfig.FchInv.
  l-FchInv = InvConfig.FchInv.
  */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN x-FchInv = TODAY.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /*
  DO WITH FRAME {&FRAME-NAME}:
    x-FchInv:DELETE(1).
    FOR EACH InvConfig WHERE InvConfig.CodCia = S-CODCIA 
            AND InvConfig.CodAlm = S-CODALM NO-LOCK:
        x-FchInv:ADD-LAST(STRING(InvConfig.FchInv, '99/99/99')).
    END.            
    x-fchinv:SCREEN-VALUE  = STRING(l-FchInv, '99/99/99').
  END.
  */

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

