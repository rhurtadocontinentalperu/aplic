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
     Fi-Mensaje FORMAT 'x(30)' NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEF TEMP-TABLE DETALLE LIKE Almmmatg
    FIELD Stk22  AS DEC FORMAT '->>>,>>9.99'    
    FIELD Stk22A AS DEC FORMAT '->>>,>>9.99'    
    FIELD Stk151 AS DEC FORMAT '->>>>,>>9.99'    
    FIELD Stk139 AS DEC FORMAT '->>>,>>9.99'    
    FIELD Stk143 AS DEC FORMAT '->>>>,>>9.99'    
    FIELD StkOtr AS DEC FORMAT '->>>,>>9.99'    
    FIELD CtoUni AS DEC FORMAT '->>>>,>>9.99'
    INDEX DETA01 AS PRIMARY CodCia CodMat.

DEF VAR s-SubTit AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-57 DFecha cCategoria DesdeC HastaC ~
RADIO-SET-1 R-Costo Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS DFecha cCategoria FILL-IN-Nombre DesdeC ~
HastaC RADIO-SET-1 R-Costo 

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

DEFINE VARIABLE cCategoria AS CHARACTER FORMAT "X(3)":U 
     LABEL "Categoria Contable" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(9)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE DFecha AS DATE FORMAT "99/99/9999":U 
     LABEL "Al dia" 
     VIEW-AS FILL-IN 
     SIZE 10.14 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN-Nombre AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .81 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(9)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE R-Costo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Promedio", 1,
"Reposición", 2
     SIZE 20 BY .96 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Detallado por material", 1,
"Detallado y agrupado por clasificación contable", 3
     SIZE 36 BY 1.92 NO-UNDO.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 80 BY 1.69
     BGCOLOR 7 FGCOLOR 0 .

DEFINE RECTANGLE RECT-57
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.86 BY 8.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     DFecha AT ROW 2.15 COL 18 COLON-ALIGNED
     cCategoria AT ROW 2.92 COL 18 COLON-ALIGNED
     FILL-IN-Nombre AT ROW 2.92 COL 28 COLON-ALIGNED NO-LABEL
     DesdeC AT ROW 3.69 COL 18 COLON-ALIGNED
     HastaC AT ROW 3.69 COL 33 COLON-ALIGNED
     RADIO-SET-1 AT ROW 4.65 COL 20 NO-LABEL
     R-Costo AT ROW 6.77 COL 20 NO-LABEL
     Btn_OK AT ROW 10.35 COL 53.72
     Btn_Cancel AT ROW 10.35 COL 66.14
     "Criterio de Selección" VIEW-AS TEXT
          SIZE 17.72 BY .5 AT ROW 1 COL 5.43
          FONT 6
     "Valorización:" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 6.96 COL 11
     "Formato:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 4.85 COL 14
     RECT-57 AT ROW 1.19 COL 1.14
     RECT-46 AT ROW 10.23 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 11.5
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
         TITLE              = "ANEXO VALORIZACION DEL STOCK LOGISTICO POR ALMACEN"
         HEIGHT             = 10.92
         WIDTH              = 80
         MAX-HEIGHT         = 11.5
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 11.5
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-Nombre IN FRAME F-Main
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
ON END-ERROR OF W-Win /* ANEXO VALORIZACION DEL STOCK LOGISTICO POR ALMACEN */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ANEXO VALORIZACION DEL STOCK LOGISTICO POR ALMACEN */
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


&Scoped-define SELF-NAME cCategoria
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cCategoria W-Win
ON LEAVE OF cCategoria IN FRAME F-Main /* Categoria Contable */
DO:
  FILL-IN-Nombre:SCREEN-VALUE = ''.
  FIND Almtabla WHERE almtabla.tabla = 'CC'
    AND almtabla.codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Almtabla THEN FILL-IN-Nombre:SCREEN-VALUE = almtabla.nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC W-Win
ON LEAVE OF DesdeC IN FRAME F-Main /* Articulo */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
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


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC W-Win
ON LEAVE OF HastaC IN FRAME F-Main /* A */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
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
    ASSIGN DesdeC HastaC DFecha RADIO-SET-1 cCategoria R-Costo.
    IF HastaC = "" THEN HastaC = "999999".
    IF DesdeC = ""
    THEN DO:
        FIND FIRST Almmmatg WHERE almmmatg.codcia = s-codcia NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmatg THEN DesdeC = ALmmmatg.codmat.
    END.
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
  DEF VAR F-Saldo  AS DEC NO-UNDO.
  DEF VAR F-CtoUni AS DEC NO-UNDO.
  DEF VAR x-Total  AS DEC NO-UNDO.
  
  FOR EACH DETALLE:
    DELETE DETALLE.
  END.

  FOR EACH Almmmatg WHERE Almmmatg.codcia = s-codcia 
        AND Almmmatg.codmat >= DesdeC
        AND Almmmatg.codmat <= HastaC 
        AND Almmmatg.catconta[1] BEGINS cCategoria
        NO-LOCK:
    DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
        FORMAT "X(8)" WITH FRAME F-Proceso.
    FIND DETALLE OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE DETALLE 
    THEN CREATE DETALLE.
    BUFFER-COPY Almmmatg TO DETALLE.
    /* Saldo Logistico */
    FOR EACH Almacen WHERE almacen.codcia = s-codcia
            AND almacen.flgrep = YES NO-LOCK:
        IF Almacen.AlmCsg = YES THEN NEXT.
        ASSIGN
            F-Saldo  = 0.
        FIND LAST AlmStkAl WHERE almstkal.codcia = s-codcia
            AND almstkal.codalm = almacen.codalm
            AND almstkal.codmat = almmmatg.codmat
            AND almstkal.fecha <= DFecha
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almstkal THEN F-Saldo = almstkal.stkact.
        CASE Almacen.codalm:
            WHEN '03' THEN .
            WHEN '04' THEN .
            WHEN '05' THEN .
            WHEN '11' THEN .
            WHEN '12' THEN .
            WHEN '83' THEN .
            WHEN '22'  THEN DETALLE.Stk22  = F-Saldo.
            WHEN '22A' THEN DETALLE.Stk22A = F-Saldo.
            WHEN '151' THEN DETALLE.Stk151 = F-Saldo.
            WHEN '139' THEN DETALLE.Stk139 = F-Saldo.
            WHEN '143' THEN DETALLE.Stk143 = F-Saldo.
            OTHERWISE DETALLE.StkOtr = DETALLE.StkOtr + F-Saldo.
        END CASE.
    END.
    x-Total = ABSOLUTE(detalle.stk22) + ABSOLUTE(detalle.stk22A) +
                ABSOLUTE(detalle.stk151) + 
                ABSOLUTE(detalle.stk139) + ABSOLUTE(detalle.stk143) +
                ABSOLUTE(detalle.stkotr).
    IF x-Total = 0   THEN DO:
        DELETE DETALLE.
        NEXT.
    END.
    DETALLE.CtoTot = x-Total.
    /* COSTO */
    IF R-Costo = 1 THEN DO:     /* Promedio */
        FIND LAST Almstkge WHERE Almstkge.codcia = s-codcia
            AND Almstkge.codmat = Almmmatg.codmat
            AND Almstkge.fecha <= DFecha
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almstkge THEN DETALLE.ctouni = AlmStkge.CtoUni.
    END.
    IF R-Costo = 2 THEN DO:     /* Reposicion */
        IF DETALLE.MonVta = 2 
        THEN DETALLE.CtoUni = DETALLE.CtoLis * DETALLE.TpoCmb.
        ELSE DETALLE.CtoUni = DETALLE.CtoLis.
    END.
  END.
  HIDE FRAME F-Proceso.
  
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
  DISPLAY DFecha cCategoria FILL-IN-Nombre DesdeC HastaC RADIO-SET-1 R-Costo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-57 DFecha cCategoria DesdeC HastaC RADIO-SET-1 R-Costo Btn_OK 
         Btn_Cancel 
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
  DEFINE FRAME F-DETALLE
    DETALLE.codmat      COLUMN-LABEL "Codigo"
    DETALLE.desmat      COLUMN-LABEL "Descripcion"          FORMAT 'X(35)'
    DETALLE.desmar      COLUMN-LABEL "Marca"                FORMAT 'X(10)'
    DETALLE.catconta[1] COLUMN-LABEL "CC"                   FORMAT 'X(2)'
    DETALLE.undbas      COLUMN-LABEL "Und"                  FORMAT 'X(7)'       
    DETALLE.ctouni      COLUMN-LABEL "Costo"                
    DETALLE.stk22       COLUMN-LABEL "Stock!22"        
    DETALLE.stk22a       COLUMN-LABEL "Stock!22A"    
    DETALLE.stk151       COLUMN-LABEL "Stock!151"
    DETALLE.stk139       COLUMN-LABEL "Stock!139"
    DETALLE.stk143       COLUMN-LABEL "Stock!143"
    DETALLE.stkOtr      COLUMN-LABEL "Stock!Otros"
    DETALLE.CtoTot      COLUMN-LABEL "Total"                FORMAT '->>>>,>>9.99'
  WITH WIDTH 210 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
    HEADER
    {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} + {&Prn4} FORMAT "X(50)" AT 1 SKIP
    "ANEXO - VALORIZACION DEL STOCK LOGISTICO POR ALMACEN" AT 20 
    "Pagina :" TO 140 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
    "Fecha :" TO 140 TODAY FORMAT "99/99/9999" SKIP
    "Hora :"  TO 140 STRING(TIME,"HH:MM") SKIP
    "DESDE EL CODIGO" DesdeC "HASTA EL CODIGO" HastaC "HASTA EL" DFecha SKIP
    s-SubTit FORMAT 'x(50)' SKIP
  WITH PAGE-TOP WIDTH 210 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  FOR EACH DETALLE BREAK BY DETALLE.codcia BY DETALLE.catconta[1] BY DETALLE.desmat:
    VIEW STREAM REPORT FRAME F-HEADER.
    DISPLAY STREAM REPORT 
        DETALLE.codmat      
        DETALLE.desmat      
        DETALLE.desmar
        DETALLE.catconta[1] 
        DETALLE.undbas
        DETALLE.ctouni
        DETALLE.stk22       
        DETALLE.stk22a       
        DETALLE.stk151       
        DETALLE.stk139       
        DETALLE.stk143       
        DETALLE.stkOtr      
        DETALLE.CtoTot      
        WITH FRAME F-DETALLE.
    ACCUMULATE DETALLE.ctotot (TOTAL BY DETALLE.codcia).
    IF LAST-OF(DETALLE.codcia)
    THEN DO:
        UNDERLINE STREAM REPORT
            DETALLE.CtoTot      
            WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            "TOTAL GENERAL >>>" @ DETALLE.desmat
            ACCUM TOTAL BY DETALLE.codcia DETALLE.CtoTot @ DETALLE.ctotot
            WITH FRAME F-DETALLE.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-3 W-Win 
PROCEDURE Formato-3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE FRAME F-DETALLE
    DETALLE.catconta[1] COLUMN-LABEL "CC"                   FORMAT 'X(2)'
    DETALLE.codmat      COLUMN-LABEL "Codigo"
    DETALLE.desmat      COLUMN-LABEL "Descripcion"          FORMAT 'X(35)'
    DETALLE.desmar      COLUMN-LABEL "Marca"                FORMAT 'X(10)'
    DETALLE.undbas      COLUMN-LABEL "Und"                  FORMAT 'X(7)'
    DETALLE.stk22       COLUMN-LABEL "Stock!22"
    DETALLE.stk22a       COLUMN-LABEL "Stock!22A"
    DETALLE.stk151       COLUMN-LABEL "Stock!151"
    DETALLE.stk139       COLUMN-LABEL "Stock!139"
    DETALLE.stk143       COLUMN-LABEL "Stock!143"
    DETALLE.stkOtr      COLUMN-LABEL "Stock!Otros"
    DETALLE.CtoTot      COLUMN-LABEL "Total"                FORMAT '->>>>,>>9.99'
  WITH WIDTH 210 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME F-HEADER
    HEADER
    {&Prn2} + {&Prn7A} + {&Prn6A} + S-NOMCIA + {&Prn7B} + {&Prn6A} + {&Prn4} FORMAT "X(50)" AT 1 SKIP
    "VALORIZACION DEL STOCK LOGISTICO POR ALMACEN" AT 20 
    "Pagina :" TO 140 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
    "Fecha :" TO 140 TODAY FORMAT "99/99/9999" SKIP
    "Hora :"  TO 140 STRING(TIME,"HH:MM") SKIP
    "DESDE EL CODIGO" DesdeC "HASTA EL CODIGO" HastaC "HASTA EL" DFecha SKIP
    s-SubTit FORMAT 'x(50)' SKIP
  WITH PAGE-TOP WIDTH 210 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN. 
  
  FOR EACH DETALLE BREAK BY DETALLE.codcia BY DETALLE.catconta[1]:
    VIEW STREAM REPORT FRAME F-HEADER.
    DISPLAY STREAM REPORT 
        DETALLE.catconta[1] 
        DETALLE.codmat      
        DETALLE.desmat      
        DETALLE.desmar
        DETALLE.undbas
        DETALLE.stk22       
        DETALLE.stk22a       
        DETALLE.stk151       
        DETALLE.stk139       
        DETALLE.stk143       
        DETALLE.stkOtr      
        DETALLE.CtoTot      
        WITH FRAME F-DETALLE.
    ACCUMULATE DETALLE.ctotot (TOTAL BY DETALLE.codcia BY DETALLE.catconta[1]).
    IF LAST-OF(DETALLE.catconta[1])
    THEN DO:
        UNDERLINE STREAM REPORT
            DETALLE.CtoTot      
            WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            ("SUB-TOTAL CATEGORIA " + DETALLE.catconta[1] + " >>>") @ DETALLE.desmat
            ACCUM TOTAL BY DETALLE.catconta[1] DETALLE.CtoTot @ DETALLE.ctotot
            WITH FRAME F-DETALLE.
        PUT STREAM REPORT " " SKIP.
    END.
    IF LAST-OF(DETALLE.codcia)
    THEN DO:
        UNDERLINE STREAM REPORT
            DETALLE.CtoTot      
            WITH FRAME F-DETALLE.
        DISPLAY STREAM REPORT
            "TOTAL GENERAL >>>" @ DETALLE.desmat
            ACCUM TOTAL BY DETALLE.codcia DETALLE.CtoTot @ DETALLE.ctotot
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
    ENABLE ALL EXCEPT FILL-IN-Nombre.
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

    s-SubTit = IF R-COSTO = 1 THEN
        'EN NUEVOS SOLES AL COSTO PROMEDIO'
    ELSE
        'EN NUEVOS SOLES AL VALOR DE MERCADO'.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        CASE RADIO-SET-1:
            WHEN 1 THEN RUN Formato.
            WHEN 3 THEN RUN Formato-3.
        END CASE.
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
    ASSIGN DesdeC HastaC DFecha cCategoria RADIO-SET-1.
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
  ASSIGN
    DFecha = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
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

