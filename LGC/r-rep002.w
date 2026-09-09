&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*------------------------------------------------------------------------------
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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.

DEF TEMP-TABLE DETALLE LIKE Almmmatg
    FIELD CanxMes-1 AS DEC EXTENT 4
    FIELD CanxMes-2 AS DEC EXTENT 4    
    FIELD CanxMes-3 AS DEC EXTENT 4
    FIELD StkAct    AS DEC.

DEF VAR pv-codcia AS INT NO-UNDO.

FIND Empresa WHERE Empresa.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

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
&Scoped-Define ENABLED-OBJECTS x-CodPro BUTTON-1 x-Periodo-1 BUTTON-3 ~
Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS x-CodPro x-NomPro F-Division x-Periodo-1 ~
x-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Salir" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Imprimir" 
     SIZE 15 BY 1.54.

DEFINE VARIABLE F-Division AS CHARACTER FORMAT "X(100)":U INITIAL "00001,00002,00003,00000,00014,00005,00009,00011,00012,00015,00016" 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 66 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE x-CodPro AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE x-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 69 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81 NO-UNDO.

DEFINE VARIABLE x-Periodo-1 AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodPro AT ROW 1.77 COL 9 COLON-ALIGNED
     x-NomPro AT ROW 1.77 COL 22 COLON-ALIGNED NO-LABEL
     F-Division AT ROW 2.73 COL 9 COLON-ALIGNED
     BUTTON-1 AT ROW 2.73 COL 80
     x-Periodo-1 AT ROW 3.69 COL 9 COLON-ALIGNED
     x-Mensaje AT ROW 4.85 COL 6 COLON-ALIGNED NO-LABEL
     BUTTON-3 AT ROW 6.19 COL 5
     Btn_Done AT ROW 6.19 COL 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 84.86 BY 17
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
         TITLE              = "REPORTE DE PROYECCION DE COMPRAS"
         HEIGHT             = 8.04
         WIDTH              = 85.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 85.14
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 85.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN F-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE PROYECCION DE COMPRAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE PROYECCION DE COMPRAS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Salir */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:
  DEF VAR x-Divisiones AS CHAR.
  x-Divisiones = f-Division:SCREEN-VALUE.
  RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
  f-Division:SCREEN-VALUE = x-Divisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Imprimir */
DO:
  ASSIGN
    F-Division x-CodPro x-Periodo-1.
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Division W-Win
ON LEAVE OF F-Division IN FRAME F-Main /* Division */
DO:
    ASSIGN F-Division.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPro W-Win
ON LEAVE OF x-CodPro IN FRAME F-Main /* Proveedor */
DO:
  x-NomPro:SCREEN-VALUE = ''.
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND Gn-prov WHERE Gn-prov.codcia = pv-codcia
    AND Gn-prov.codpro = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-prov THEN x-NomPro:SCREEN-VALUE = Gn-prov.nompro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Periodo-2 AS INT NO-UNDO.
  DEF VAR x-Periodo-3 AS INT NO-UNDO.
  DEF VAR x-NroFch-1 AS INT NO-UNDO.
  DEF VAR x-NroFch-2 AS INT NO-UNDO.
  
  ASSIGN
    x-Periodo-2 = x-Periodo-1 - 1
    x-Periodo-3 = x-Periodo-1 - 2.

  FOR EACH DETALLE:
    DELETE DETALLE.
  END.
  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codpr1 BEGINS x-CodPro:
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Procesando: ' + Almmmatg.codmat.
    CREATE DETALLE.
    BUFFER-COPY Almmmatg TO DETALLE.
    FOR EACH Gn-divi NO-LOCK WHERE Gn-divi.codcia = s-codcia
            AND LOOKUP(Gn-divi.coddiv, F-Division) > 0 :
        /* VENTAS DE ENERO A MARZO PERIODO 1 */
        ASSIGN
            x-NroFch-1 = x-Periodo-1 * 100 + 01
            x-NroFch-2 = x-Periodo-1 * 100 + 04.
        FOR EACH Evtarti NO-LOCK WHERE EvtArti.CodCia = s-codcia
                AND EvtArti.coddiv = gn-divi.coddiv
                AND EvtArti.codmat = Almmmatg.codmat
                AND EvtArti.Nrofch >= x-NroFch-1
                AND EvtArti.NroFch <= x-NroFch-2:
            CASE Evtarti.CodMes:
                WHEN 01 THEN DETALLE.CanxMes-1[1] = DETALLE.CanxMes-1[1] + EvtArti.CanxMes.
                WHEN 02 THEN DETALLE.CanxMes-1[2] = DETALLE.CanxMes-1[2] + EvtArti.CanxMes.
                WHEN 03 THEN DETALLE.CanxMes-1[3] = DETALLE.CanxMes-1[3] + EvtArti.CanxMes.
                WHEN 04 THEN DETALLE.CanxMes-1[4] = DETALLE.CanxMes-1[4] + EvtArti.CanxMes.
            END.
        END.    
        /* VENTAS DE ENERO A MARZO PERIODO 2 */
        ASSIGN
            x-NroFch-1 = x-Periodo-2 * 100 + 01
            x-NroFch-2 = x-Periodo-2 * 100 + 04.
        FOR EACH Evtarti NO-LOCK WHERE EvtArti.CodCia = s-codcia
                AND EvtArti.coddiv = gn-divi.coddiv
                AND EvtArti.codmat = Almmmatg.codmat
                AND EvtArti.Nrofch >= x-NroFch-1
                AND EvtArti.NroFch <= x-NroFch-2:
            CASE Evtarti.CodMes:
                WHEN 01 THEN DETALLE.CanxMes-2[1] = DETALLE.CanxMes-2[1] + EvtArti.CanxMes.
                WHEN 02 THEN DETALLE.CanxMes-2[2] = DETALLE.CanxMes-2[2] + EvtArti.CanxMes.
                WHEN 03 THEN DETALLE.CanxMes-2[3] = DETALLE.CanxMes-2[3] + EvtArti.CanxMes.
                WHEN 04 THEN DETALLE.CanxMes-2[4] = DETALLE.CanxMes-2[4] + EvtArti.CanxMes.
            END.
        END.    
        /* VENTAS DE ENERO A MARZO PERIODO 3 */
        ASSIGN
            x-NroFch-1 = x-Periodo-3 * 100 + 01
            x-NroFch-2 = x-Periodo-3 * 100 + 04.
        FOR EACH Evtarti NO-LOCK WHERE EvtArti.CodCia = s-codcia
                AND EvtArti.coddiv = gn-divi.coddiv
                AND EvtArti.codmat = Almmmatg.codmat
                AND EvtArti.Nrofch >= x-NroFch-1
                AND EvtArti.NroFch <= x-NroFch-2:
            CASE Evtarti.CodMes:
                WHEN 01 THEN DETALLE.CanxMes-3[1] = DETALLE.CanxMes-3[1] + EvtArti.CanxMes.
                WHEN 02 THEN DETALLE.CanxMes-3[2] = DETALLE.CanxMes-3[2] + EvtArti.CanxMes.
                WHEN 03 THEN DETALLE.CanxMes-3[3] = DETALLE.CanxMes-3[3] + EvtArti.CanxMes.
                WHEN 04 THEN DETALLE.CanxMes-3[4] = DETALLE.CanxMes-3[4] + EvtArti.CanxMes.
            END.
        END.    
    END.
    /* Stock Actual */
    FOR EACH Almacen NO-LOCK WHERE LOOKUP(Almacen.coddiv, F-Division) > 0:
        FOR EACH Almmmate OF Almmmatg NO-LOCK WHERE Almmmate.codalm = Almacen.codalm:
            DETALLE.StkAct = DETALLE.StkAct + Almmmate.StkAct.
        END.
    END.
  END.
  x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
  
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
  DISPLAY x-CodPro x-NomPro F-Division x-Periodo-1 x-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-CodPro BUTTON-1 x-Periodo-1 BUTTON-3 Btn_Done 
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
  DEF VAR x-Moneda AS CHAR FORMAT 'x(3)' NO-UNDO.
  
  DEFINE FRAME F-Cab
    DETALLE.CodMat          FORMAT 'x(6)'
    DETALLE.DesMat          FORMAT 'x(40)'
    DETALLE.DesMar          FORMAT 'x(20)'
    DETALLE.UndBas          FORMAT 'x(6)'
    DETALLE.TipArt          FORMAT 'x(8)'
    DETALLE.CanEmp          FORMAT '>>>9.99'
    x-Moneda                
    DETALLE.CtoTot          FORMAT '>>>>,>>9.99'
    DETALLE.CanxMes-1[1]    FORMAT '->>>>>9.99'
    DETALLE.CanxMes-1[2]    FORMAT '->>>>>9.99'
    DETALLE.CanxMes-1[3]    FORMAT '->>>>>9.99'
    DETALLE.CanxMes-1[4]    FORMAT '->>>>>9.99'
    DETALLE.CanxMes-2[1]    FORMAT '->>>>>9.99'
    DETALLE.CanxMes-2[2]    FORMAT '->>>>>9.99'
    DETALLE.CanxMes-2[3]    FORMAT '->>>>>9.99'
    DETALLE.CanxMes-2[4]    FORMAT '->>>>>9.99'
    DETALLE.CanxMes-3[1]    FORMAT '->>>>>9.99'
    DETALLE.CanxMes-3[2]    FORMAT '->>>>>9.99'
    DETALLE.CanxMes-3[3]    FORMAT '->>>>>9.99'
    DETALLE.CanxMes-3[4]    FORMAT '->>>>>9.99'
    DETALLE.StkACt          FORMAT '->>>>>9.99'
    HEADER
        S-NOMCIA FORMAT 'X(50)' SKIP
        "PROYECCION DE COMPRAS" AT 30
        "Pag.  : " AT 120 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Fecha : " AT 120 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP(1)
    "Divisiones:" F-Division
    "Codigo Descripcion                              Marca                Unidad Rotacion Empaque Mon Costo c/Igv" +
    "   Ene " + STRING(x-Periodo-1, '9999') +
    "   Feb " + STRING(x-Periodo-1, '9999') +
    "   Mar " + STRING(x-Periodo-1, '9999') +
    "   Abr " + STRING(x-Periodo-1, '9999') +
    "   Ene " + STRING(x-Periodo-1 - 1, '9999') +
    "   Feb " + STRING(x-Periodo-1 - 1, '9999') +
    "   Mar " + STRING(x-Periodo-1 - 1, '9999') + 
    "   Abr " + STRING(x-Periodo-1 - 1, '9999') +
    "   Ene " + STRING(x-Periodo-1 - 2, '9999') +
    "   Feb " + STRING(x-Periodo-1 - 2, '9999') +
    "   Mar " + STRING(x-Periodo-1 - 2, '9999') + 
    "   Abr " + STRING(x-Periodo-1 - 2, '9999') + ' Stock' FORMAT 'x(320)' SKIP
    "===========================================================================================================================================================================================================================================================" SKIP
/*
     Codigo Descripcion                              Marca                Unidad Rotacion Empaque Mon Costo c/Igv Ene 1234
     12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
     123456 1234567890123456789012345678901234567890 12345678901234567890 123456 12345678 >>>9.99 123 >>>>,>>9.99 ->>>>>9.99 ->>>>>9.99 ->>>>>9.99 ->>>>>9.99 ->>>>>9.99 ->>>>>9.99 ->>>>>9.99 ->>>>>9.99 ->>>>>9.99 ->>>>>9.99 ->>>>>9.99 ->>>>>9.99 >>>>9.99
*/
        
    WITH WIDTH 320 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.         
  
  FOR EACH DETALLE:
    x-Moneda = IF DETALLE.monvta = 2 THEN 'US$' ELSE 'S/.'.
    DISPLAY STREAM REPORT
        DETALLE.CodMat 
        DETALLE.DesMat 
        DETALLE.DesMar 
        DETALLE.UndBas 
        DETALLE.TipArt 
        DETALLE.CanEmp          
        x-Moneda                
        DETALLE.CtoTot          
        DETALLE.CanxMes-1[1]    
        DETALLE.CanxMes-1[2]    
        DETALLE.CanxMes-1[3]    
        DETALLE.CanxMes-1[4]    
        DETALLE.CanxMes-2[1]    
        DETALLE.CanxMes-2[2]    
        DETALLE.CanxMes-2[3]    
        DETALLE.CanxMes-2[4]    
        DETALLE.CanxMes-3[1]    
        DETALLE.CanxMes-3[2]    
        DETALLE.CanxMes-3[3]    
        DETALLE.CanxMes-3[4]    
        DETALLE.StkAct 
        WITH FRAME F-Cab.    
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    RUN Carga-Temporal.

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
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM REPORT CLOSE.
    END.
    OUTPUT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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
  x-Periodo-1 = YEAR(TODAY).

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

