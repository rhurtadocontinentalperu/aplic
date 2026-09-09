&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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

{src/adm2/widgetprto.i}

    IF NOT connected('cissac')
        /*THEN CONNECT -db integral -ld cissac -N TCP -S 65030 -H 192.168.100.210 NO-ERROR.*/
        THEN CONNECT -db integral -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP
          'NO podemos capturar el stock (2)'
          VIEW-AS ALERT-BOX WARNING.
    END.


    DEF SHARED VAR s-codcia AS INT.
    DEF SHARED VAR s-coddiv AS CHAR.
    DEF SHARED VAR pv-codcia AS INT.

    DEF VAR cFami AS CHARACTER.

    DEF VAR x-codfam AS CHARACTER.

    DEF TEMP-TABLE Detalle LIKE integral.Almmmatg
        FIELD StockConti   AS DEC EXTENT 50
        FIELD StockCissac  AS DEC EXTENT 50
        FIELD CtoUniConti  AS DEC 
        FIELD CtoUniCissac AS DEC    
    /*RD01- Stock Comprometido*/
        FIELD StockComp    AS DEC EXTENT 20
        FIELD MndCosto     AS CHAR
        FIELD CtoLista     LIKE integral.almmmatg.ctolis.

    DEF VAR x-AlmConti AS CHAR NO-UNDO.
    DEF VAR x-AlmCissac AS CHAR NO-UNDO.

    ASSIGN
        /*
        x-AlmConti = '10,10a,11,21,21s,21f,22,17,18,03,04,05,27,83b,35,35a,500,501,502,85,34,35e'
        x-AlmCissac = '11,21,21s,21f,22,27,85'.
       
        x-AlmConti = '10,10a,11,11e,11t,21,21e,21s,21f,22,17,18,03,03a,04,04a,05,05a,27,28,83b,35,35a,500,501,502,85,34,34e,35e'
        x-AlmCissac = '11,21,21s,21f,22,27,85'.
        */
        x-AlmConti = '11,11e,32,38,39,34,34e,35,35e,21,21e,03,03a,04,04a,05,05a,11t,17,18,28,35a,83b,22,21s,10,10a,27,500,501,502,503,504,505,85,21f,21t,60' .
        x-AlmCissac = '11,21,21s,21f,22,27,85,21t'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES INTEGRAL.Almtfami

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 INTEGRAL.Almtfami.desfam ~
INTEGRAL.Almtfami.codfam 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH INTEGRAL.Almtfami ~
      WHERE INTEGRAL.Almtfami.CodCia = 1 NO-LOCK ~
    BY INTEGRAL.Almtfami.desfam INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH INTEGRAL.Almtfami ~
      WHERE INTEGRAL.Almtfami.CodCia = 1 NO-LOCK ~
    BY INTEGRAL.Almtfami.desfam INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 INTEGRAL.Almtfami
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 INTEGRAL.Almtfami


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 BUTTON-2 BtnDone BUTTON-5 
&Scoped-Define DISPLAYED-OBJECTS f-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 15 BY 1.65.

DEFINE BUTTON BUTTON-5 
     LABEL "Seleccionar Todos" 
     SIZE 18 BY 1.12.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      INTEGRAL.Almtfami SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      INTEGRAL.Almtfami.desfam FORMAT "X(30)":U WIDTH 55.43
      INTEGRAL.Almtfami.codfam FORMAT "X(3)":U WIDTH 10.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 70 BY 11.04 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BROWSE-2 AT ROW 1.58 COL 5 WIDGET-ID 200
     f-Mensaje AT ROW 13.12 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     BUTTON-2 AT ROW 15.27 COL 45 WIDGET-ID 2
     BtnDone AT ROW 15.27 COL 62 WIDGET-ID 4
     BUTTON-5 AT ROW 15.54 COL 4 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 17
         WIDTH              = 80
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 1 fMain */
/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.Almtfami"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.Almtfami.desfam|yes"
     _Where[1]         = "INTEGRAL.Almtfami.CodCia = 1"
     _FldNameList[1]   > INTEGRAL.Almtfami.desfam
"Almtfami.desfam" ? ? "character" ? ? ? ? ? ? no ? no no "55.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almtfami.codfam
"Almtfami.codfam" ? ? "character" ? ? ? ? ? ? no ? no no "10.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone wWin
ON CHOOSE OF BtnDone IN FRAME fMain /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 wWin
ON CHOOSE OF BUTTON-2 IN FRAME fMain /* Button 2 */
DO:
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 wWin
ON CHOOSE OF BUTTON-5 IN FRAME fMain /* Seleccionar Todos */
DO:
    IF BUTTON-5:LABEL = "Seleccionar Todos" THEN DO :
        {&BROWSE-NAME}:SELECT-ALL().
        BUTTON-5:LABEL = "Ninguno".
    END.
    ELSE DO:
        {&BROWSE-NAME}:DESELECT-ROWS().
        BUTTON-5:LABEL = "Seleccionar Todos".
    END.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal wWin 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Orden AS INT NO-UNDO INIT 1.
  DEF VAR x-CanPed AS DEC NO-UNDO.

  DEF VAR pComprometido AS DECIMAL NO-UNDO.
  DEF VAR cCodAlm1 AS CHAR NO-UNDO.
  DEF VAR cCodAlm2 AS CHAR NO-UNDO.
  DEF VAR cCodAlm3 AS CHAR NO-UNDO.
  DEF VAR cCodAlm4 AS CHAR NO-UNDO.
  DEF VAR cCodAlm5 AS CHAR NO-UNDO.
  DEF VAR cCodAlm6 AS CHAR NO-UNDO.
  DEF VAR cCodAlm7 AS CHAR NO-UNDO.
  DEF VAR cCodAlm8 AS CHAR NO-UNDO.  /* Comas */
  DEF VAR cCodAlm9 AS CHAR NO-UNDO.  
  DEF VAR cCodAlm10 AS CHAR NO-UNDO.  
  DEF VAR cCodAlm11 AS CHAR NO-UNDO.  
  DEF VAR cCodAlm12 AS CHAR NO-UNDO.  

  /*Caso expolibreria*/
  /*
  cCodAlm1 = "40".
  cCodAlm2 = "45".
  cCodAlm3 = "35a".
  cCodAlm4 = "35".
  cCodAlm5 = "11".
  cCodAlm6 = "22".
  cCodAlm7 = "21".
  cCodAlm8 = "34".
  cCodAlm9 = "11e".
  cCodAlm10 = "21e".
  cCodAlm11 = "3e4".
  cCodAlm12 = "35e".
    */
  cCodAlm1 = "11".
  cCodAlm2 = "11e".
  cCodAlm3 = "34".
  cCodAlm4 = "34e".
  cCodAlm5 = "35".
  cCodAlm6 = "35e".
  cCodAlm7 = "21".
  cCodAlm8 = "21e".
  cCodAlm9 = "22".
  cCodAlm10 = "40".
  cCodAlm11 = "45".
  cCodAlm12 = "35a".


  IF NOT connected('cissac')
      THEN CONNECT -db integral -ld cissac -N TCP -S IN_ON_ST -H inf210 NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE 'NO se ha podido conectar la base de datos de STANDFORD' SKIP
        'NO podemos capturar el stock'
        VIEW-AS ALERT-BOX WARNING.
  END.
  
  EMPTY TEMP-TABLE detalle.
  /* STOCKS CONTI */
  DO x-Orden = 1 TO NUM-ENTRIES(x-AlmConti):
      FOR EACH integral.almmmate NO-LOCK WHERE integral.almmmate.codcia = s-codcia
          AND integral.almmmate.codalm = ENTRY(x-Orden, x-AlmConti)
          AND integral.almmmate.stkact <> 0,
          /*FIRST integral.almmmatg OF integral.almmmate NO-LOCK WHERE integral.almmmatg.codfam = x-codfam: */
          FIRST integral.almmmatg OF integral.almmmate NO-LOCK WHERE lookup(integral.almmmatg.codfam,x-codfam) > 0:
          f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Conti >> ' +
              integral.almmmatg.codmat + ' ' +
              integral.almmmatg.desmat.
          FIND detalle OF integral.almmmatg EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE detalle THEN DO: 
              CREATE detalle.
              BUFFER-COPY integral.almmmatg TO detalle.
              FIND integral.gn-prov WHERE integral.gn-prov.codcia = pv-codcia
                  AND integral.gn-prov.codpro = integral.almmmatg.codpr1
                  NO-LOCK NO-ERROR.
              IF AVAILABLE integral.gn-prov THEN detalle.codpr1 = integral.gn-prov.codpro + ' ' + integral.gn-prov.nompro.
          END.
          ASSIGN 
          Detalle.StockConti[x-Orden] = integral.Almmmate.stkact + Detalle.StockConti[x-Orden]
          Detalle.CtoLista            = integral.Almmmatg.CtoLis.
          IF integral.almmmatg.monvta = 1 THEN Detalle.MndCosto = "S/.".
          ELSE Detalle.MndCosto = "$".
      END.
  END.
  /* STOCKS CISSAC */
  DO x-Orden = 1 TO NUM-ENTRIES(x-AlmCissac):
      FOR EACH cissac.almmmate NO-LOCK WHERE cissac.almmmate.codcia = s-codcia
          AND cissac.almmmate.codalm = ENTRY(x-Orden, x-AlmCissac)
          AND cissac.almmmate.stkact <> 0,
          /*FIRST cissac.almmmatg OF cissac.almmmate NO-LOCK WHERE cissac.almmmatg.codfam = x-codfam: */
          FIRST cissac.almmmatg OF cissac.almmmate NO-LOCK WHERE lookup(cissac.almmmatg.codfam,x-codfam) > 0 :
          f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Cissac >> ' +
              cissac.almmmatg.codmat + ' ' +
              cissac.almmmatg.desmat.
          FIND detalle OF cissac.almmmatg EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE detalle THEN DO:
              CREATE detalle.
              BUFFER-COPY cissac.almmmatg TO detalle.
              FIND cissac.gn-prov WHERE cissac.gn-prov.codcia = pv-codcia
                  AND cissac.gn-prov.codpro = cissac.almmmatg.codpr1
                  NO-LOCK NO-ERROR.
              IF AVAILABLE cissac.gn-prov THEN detalle.codpr1 = cissac.gn-prov.codpro + ' ' + cissac.gn-prov.nompro.
          END.
          ASSIGN 
              Detalle.StockCissac[x-Orden] = cissac.Almmmate.stkact + Detalle.StockCissac[x-Orden] .

          IF Detalle.CtoLista <= 0 THEN DO:
              ASSIGN Detalle.CtoLista  = cissac.Almmmatg.CtoLis.
              IF cissac.almmmatg.monvta = 1 THEN Detalle.MndCosto = "S/.".
              ELSE Detalle.MndCosto = "$".
          END.
      END.
  END.
  /* COSTO PROMEDIO */
  FOR EACH Detalle:
      f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Costo Promedio >> ' +
              detalle.codmat + ' ' +
              detalle.desmat.
      FIND LAST integral.almstkge WHERE integral.almstkge.codcia = s-codcia
          AND integral.almstkge.codmat = detalle.codmat
          AND integral.almstkge.fecha <= TODAY
          NO-LOCK NO-ERROR.
      IF AVAILABLE integral.almstkge THEN detalle.ctouniconti = INTEGRAL.AlmStkge.CtoUni.
      FIND LAST cissac.almstkge WHERE cissac.almstkge.codcia = s-codcia
          AND cissac.almstkge.codmat = detalle.codmat
          AND cissac.almstkge.fecha <= TODAY
          NO-LOCK NO-ERROR.
      IF AVAILABLE cissac.almstkge THEN detalle.ctounicissac = cissac.AlmStkge.CtoUni.
      /*Calculo Stock Comprometido*/
      RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm1, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[1] = pComprometido.

      RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm2, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[2] = pComprometido.

      RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm3, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[3] = pComprometido.

      RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm4, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[4] = pComprometido.

      RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm5, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[5] = pComprometido.

      RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm6, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[6] = pComprometido.

      RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm7, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[7] = pComprometido.

      RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm8, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[8] = pComprometido.

      RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm9, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[9] = pComprometido.
      RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm10, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[10] = pComprometido.
      RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm11, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[11] = pComprometido.
      RUN vta2/stock-comprometido (Detalle.codmat, cCodAlm12, OUTPUT pComprometido).
      ASSIGN Detalle.StockComp[12] = pComprometido.

  END.
  
  f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY f-Mensaje 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BROWSE-2 BUTTON-2 BtnDone BUTTON-5 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel wWin 
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
DEFINE VARIABLE t-Column                AS INTEGER.
DEFINE VARIABLE t-Letra                 AS INTEGER.
DEFINE VARIABLE cLetra                  AS CHAR.
DEFINE VARIABLE cLetra2                 AS CHAR.
DEFINE VARIABLE xOrden                  AS INT.

DEF VAR cComa AS CHARACTER.
DEF VAR iCont AS INT INIT 0.
DEF VAR iTCont AS INT INIT 0.


  /* Familias Seleccionadas */
  x-codfam = "".
  cComa = "".
  DO WITH FRAME {&FRAME-NAME}:
    /*DO iCont = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:*/
    iTCont = {&BROWSE-NAME}:NUM-SELECTED-ROWS.
    DO iCont = 1 TO iTCont :
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(icont) THEN DO:
                cFami = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Codfam.
                X-codfam = x-codfam + cComa + cFami.
                cComa = ",".
        END.
    END.
  END.

  IF x-codfam = "" THEN DO:
      MESSAGE "Seleccione Alguna Familia..." VIEW-AS ALERT-BOX.
      RETURN "ADM-ERROR".
  END.

RUN Carga-Temporal.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A2"):Value = "Material".
chWorkSheet:Range("B2"):Value = "Descripcion".
chWorkSheet:Range("C2"):Value = "Marca".
chWorkSheet:Range("D2"):Value = "Unidad".
chWorkSheet:Range("E2"):Value = "Linea".
chWorkSheet:Range("F2"):Value = "Sub-linea".
chWorkSheet:Range("G2"):Value = "Proveedor".
chWorkSheet:Range("H2"):Value = "Peso".
chWorkSheet:Range("I2"):Value = "Volumen".

t-Letra = ASC('J').
t-column = 2.
cLetra2 = ''.

DO xOrden = 1 TO NUM-ENTRIES(x-AlmConti):
    cColumn = STRING(t-Column).
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + ENTRY(xOrden, x-AlmConti).
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
END.

cColumn = STRING(t-Column).
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Cto. Prom. Conti".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.

DO xOrden = 1 TO NUM-ENTRIES(x-AlmCissac):
    cColumn = STRING(t-Column).
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + ENTRY(xOrden, x-AlmCissac).
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
END.

cColumn = STRING(t-Column).
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Cto. Prom. Cissac".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.

cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 11".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.

cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 11e".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.

cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 34".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.

cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 34e".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.

cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 35".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.

cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 35e".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.

cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 21".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
/**/
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 21e".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
/**/
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 22".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
/**/
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 40".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
/**/
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 45".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
/**/
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Comp Alm 35a".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.
/**/
cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Mnd".
t-Letra = t-Letra + 1.
IF t-Letra > ASC('Z') THEN DO:
    t-Letra = ASC('A').
    IF cLetra2 = '' 
    THEN cLetra2 = 'A'.
    ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
END.

cLetra  = CHR(t-Letra).
cRange = cLetra2 + cLetra + cColumn.
chWorkSheet:Range(cRange):Value = "Costo (Sin I.G.V)".

loopREP:
FOR EACH Detalle BY Detalle.CodMat:
    t-column = t-column + 1.
    /* DATOS DEL PRODUCTO */    
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.CodMat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.DesMat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.DesMar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.UndBas.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.CodFam.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.SubFam.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + Detalle.CodPr1.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.pesmat.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.libre_d02.
    
    t-Letra = ASC('J').
    cLetra2 = ''.
    xOrden = 1.
    DO xOrden = 1 TO NUM-ENTRIES(x-AlmConti):
        cColumn = STRING(t-Column).
        cLetra  = CHR(t-Letra).
        cRange = cLetra2 + cLetra + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.StockConti[xOrden].
        t-Letra = t-Letra + 1.
        IF t-Letra > ASC('Z') THEN DO:
            t-Letra = ASC('A').
            IF cLetra2 = '' 
            THEN cLetra2 = 'A'.
            ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
        END.
    END.
    cColumn = STRING(t-Column).
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CtoUniConti.
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.

    DO xOrden = 1 TO NUM-ENTRIES(x-AlmCissac):
        cColumn = STRING(t-Column).
        cLetra  = CHR(t-Letra).
        cRange = cLetra2 + cLetra + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.StockCissac[xOrden].
        t-Letra = t-Letra + 1.
        IF t-Letra > ASC('Z') THEN DO:
            t-Letra = ASC('A').
            IF cLetra2 = '' 
            THEN cLetra2 = 'A'.
            ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
        END.
    END.

    cColumn = STRING(t-Column).
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CtoUniCissac.
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[1].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[2].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[3].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[4].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[5].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[6].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    /**/
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[7].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    /**/
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.StockComp[8].
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
        /**/
        cLetra  = CHR(t-Letra).
        cRange = cLetra2 + cLetra + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.StockComp[9].
        t-Letra = t-Letra + 1.
        IF t-Letra > ASC('Z') THEN DO:
            t-Letra = ASC('A').
            IF cLetra2 = '' 
            THEN cLetra2 = 'A'.
            ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
        END.
        /**/
        cLetra  = CHR(t-Letra).
        cRange = cLetra2 + cLetra + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.StockComp[10].
        t-Letra = t-Letra + 1.
        IF t-Letra > ASC('Z') THEN DO:
            t-Letra = ASC('A').
            IF cLetra2 = '' 
            THEN cLetra2 = 'A'.
            ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
        END.
        /**/
        cLetra  = CHR(t-Letra).
        cRange = cLetra2 + cLetra + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.StockComp[11].
        t-Letra = t-Letra + 1.
        IF t-Letra > ASC('Z') THEN DO:
            t-Letra = ASC('A').
            IF cLetra2 = '' 
            THEN cLetra2 = 'A'.
            ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
        END.
        /**/
        cLetra  = CHR(t-Letra).
        cRange = cLetra2 + cLetra + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.StockComp[12].
        t-Letra = t-Letra + 1.
        IF t-Letra > ASC('Z') THEN DO:
            t-Letra = ASC('A').
            IF cLetra2 = '' 
            THEN cLetra2 = 'A'.
            ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
        END.
        /**/

    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.MndCosto.
    t-Letra = t-Letra + 1.
    IF t-Letra > ASC('Z') THEN DO:
        t-Letra = ASC('A').
        IF cLetra2 = '' 
        THEN cLetra2 = 'A'.
        ELSE cLetra2 = CHR(ASC(cLetra2) + 1).
    END.
    cLetra  = CHR(t-Letra).
    cRange = cLetra2 + cLetra + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CtoLista.


END.    
iCount = iCount + 2.

HIDE FRAME f-mensajes NO-PAUSE.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

