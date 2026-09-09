&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE DOCU LIKE CcbCDocu.
DEFINE TEMP-TABLE VENCIDA NO-UNDO LIKE CcbCDocu
       INDEX Llave01 CodCia NroOrd.
DEFINE TEMP-TABLE VIGENTE NO-UNDO LIKE CcbCDocu
       INDEX Llave01 CodCia NroOrd.



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

DEF SHARED VAR s-codcia AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES VIGENTE VENCIDA

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 VIGENTE.NroOrd VIGENTE.SdoAct 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH VIGENTE NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH VIGENTE NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 VIGENTE
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 VIGENTE


/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 VENCIDA.NroOrd VENCIDA.SdoAct 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH VENCIDA NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH VENCIDA NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 VENCIDA
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 VENCIDA


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_Done RECT-1 x-Division BROWSE-1 BUTTON-2 ~
BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS x-Division x-TpoCmb x-SdoAct-1 x-SdoAct-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-BROWSE-1 
       MENU-ITEM m_Documentos1  LABEL "Documentos"    
       MENU-ITEM m_Clientes1    LABEL "Clientes"      .

DEFINE MENU POPUP-MENU-BROWSE-2 
       MENU-ITEM m_Documentos2  LABEL "Documentos"    
       MENU-ITEM m_Clientes2    LABEL "Clientes"      .


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\exit":U
     LABEL "&Done" 
     SIZE 7 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 11 BY 1.88.

DEFINE VARIABLE x-Division AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 54 BY 1 NO-UNDO.

DEFINE VARIABLE x-SdoAct-1 AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "TOTAL >>>" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .81
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE x-SdoAct-2 AS DECIMAL FORMAT "(ZZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "TOTAL >>>" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .81
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE x-TpoCmb AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "Tipo de Cambio" 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13 BY 2.42.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      VIGENTE SCROLLING.

DEFINE QUERY BROWSE-2 FOR 
      VENCIDA SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 DISPLAY
      VIGENTE.NroOrd COLUMN-LABEL "Dias" FORMAT "x(10)":U
      VIGENTE.SdoAct COLUMN-LABEL "Saldo Soles" FORMAT "(>>>,>>>,>>9.99)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 32 BY 5.19
         FONT 2
         TITLE "CARTERA VIGENTE".

DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 DISPLAY
      VENCIDA.NroOrd COLUMN-LABEL "Dias" FORMAT "x(10)":U
      VENCIDA.SdoAct COLUMN-LABEL "Saldo Soles" FORMAT "(>>>,>>>,>>9.99)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 32 BY 5.38
         FONT 2
         TITLE "CARTERA VENCIDA".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn_Done AT ROW 1 COL 2
     x-Division AT ROW 2.15 COL 15 COLON-ALIGNED
     x-TpoCmb AT ROW 3.12 COL 15 COLON-ALIGNED
     BROWSE-1 AT ROW 5.42 COL 14
     BUTTON-2 AT ROW 6.38 COL 59 WIDGET-ID 4
     x-SdoAct-1 AT ROW 10.81 COL 30 COLON-ALIGNED
     BROWSE-2 AT ROW 12.54 COL 14
     x-SdoAct-2 AT ROW 18.12 COL 30 COLON-ALIGNED
     "NOTA: NO incluye FILIALES" VIEW-AS TEXT
          SIZE 26 BY .77 AT ROW 4.46 COL 5
          BGCOLOR 15 FGCOLOR 12 FONT 1
     "Seleccione un registro luego pulse botón derecho para que aparesca un menú" VIEW-AS TEXT
          SIZE 54 BY .5 AT ROW 19.08 COL 7
          BGCOLOR 1 FGCOLOR 15 
     RECT-1 AT ROW 6.12 COL 58 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 76 BY 18.92
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: DOCU T "NEW SHARED" ? INTEGRAL CcbCDocu
      TABLE: VENCIDA T "?" NO-UNDO INTEGRAL CcbCDocu
      ADDITIONAL-FIELDS:
          INDEX Llave01 CodCia NroOrd
      END-FIELDS.
      TABLE: VIGENTE T "?" NO-UNDO INTEGRAL CcbCDocu
      ADDITIONAL-FIELDS:
          INDEX Llave01 CodCia NroOrd
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "POSICION ACTUAL DE LA CARTERA DE CLIENTES"
         HEIGHT             = 18.92
         WIDTH              = 76
         MAX-HEIGHT         = 19.15
         MAX-WIDTH          = 97.72
         VIRTUAL-HEIGHT     = 19.15
         VIRTUAL-WIDTH      = 97.72
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-1 x-TpoCmb F-Main */
/* BROWSE-TAB BROWSE-2 x-SdoAct-1 F-Main */
ASSIGN 
       BROWSE-1:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-BROWSE-1:HANDLE.

ASSIGN 
       BROWSE-2:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-BROWSE-2:HANDLE.

/* SETTINGS FOR FILL-IN x-SdoAct-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-SdoAct-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-TpoCmb IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.VIGENTE"
     _FldNameList[1]   > Temp-Tables.VIGENTE.NroOrd
"VIGENTE.NroOrd" "Dias" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.VIGENTE.SdoAct
"VIGENTE.SdoAct" "Saldo Soles" "(>>>,>>>,>>9.99)" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.VENCIDA"
     _FldNameList[1]   > Temp-Tables.VENCIDA.NroOrd
"VENCIDA.NroOrd" "Dias" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.VENCIDA.SdoAct
"VENCIDA.SdoAct" "Saldo Soles" "(>>>,>>>,>>9.99)" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* POSICION ACTUAL DE LA CARTERA DE CLIENTES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* POSICION ACTUAL DE LA CARTERA DE CLIENTES */
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
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Done */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Clientes1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Clientes1 W-Win
ON CHOOSE OF MENU-ITEM m_Clientes1 /* Clientes */
DO:
  DEF VAR x-CodDiv LIKE Gn-Divi.CodDiv NO-UNDO.
  IF x-Division = 'Todas'
  THEN x-CodDiv = ''.
  ELSE x-CodDiv = SUBSTRING(x-Division,1,INDEX(x-Division, ' ') - 1).
  RUN ccb/r-con002 (s-CodCia, x-CodDiv, 'VI', VIGENTE.NroOrd).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Clientes2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Clientes2 W-Win
ON CHOOSE OF MENU-ITEM m_Clientes2 /* Clientes */
DO:
  DEF VAR x-CodDiv LIKE Gn-Divi.CodDiv NO-UNDO.
  IF x-Division = 'Todas'
  THEN x-CodDiv = ''.
  ELSE x-CodDiv = SUBSTRING(x-Division,1,INDEX(x-Division, ' ') - 1).
  RUN ccb/r-con002 (s-CodCia, x-CodDiv, 'VE', VENCIDA.NroOrd).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Documentos1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Documentos1 W-Win
ON CHOOSE OF MENU-ITEM m_Documentos1 /* Documentos */
DO:
  DEF VAR x-CodDiv LIKE Gn-Divi.CodDiv NO-UNDO.
  IF x-Division = 'Todas'
  THEN x-CodDiv = ''.
  ELSE x-CodDiv = SUBSTRING(x-Division,1,INDEX(x-Division, ' ') - 1).
  RUN ccb/r-con001 (s-CodCia, x-CodDiv, 'VI', VIGENTE.NroOrd).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Documentos2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Documentos2 W-Win
ON CHOOSE OF MENU-ITEM m_Documentos2 /* Documentos */
DO:
  DEF VAR x-CodDiv LIKE Gn-Divi.CodDiv NO-UNDO.
  IF x-Division = 'Todas'
  THEN x-CodDiv = ''.
  ELSE x-CodDiv = SUBSTRING(x-Division,1,INDEX(x-Division, ' ') - 1).
  RUN ccb/r-con001 (s-CodCia, x-CodDiv, 'VE', VENCIDA.NroOrd).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Division W-Win
ON VALUE-CHANGED OF x-Division IN FRAME F-Main /* Division */
DO:
  ASSIGN {&SELF-NAME}.
  RUN Carga-Resumenes.
  {&OPEN-QUERY-BROWSE-1}
  {&OPEN-QUERY-BROWSE-2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Resumenes W-Win 
PROCEDURE Carga-Resumenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-CodDiv LIKE Gn-Divi.CodDiv NO-UNDO.
  
  IF x-Division = 'Todas'
  THEN x-CodDiv = ''.
  ELSE x-CodDiv = SUBSTRING(x-Division,1,INDEX(x-Division, ' ') - 1).

  FOR EACH VIGENTE:
    DELETE VIGENTE.
  END.
  FOR EACH VENCIDA:
    DELETE VENCIDA.
  END.

  FOR EACH DOCU WHERE DOCU.CodDiv BEGINS x-CodDiv:
    IF DOCU.FlgEst = 'VI' THEN DO:
        FIND VIGENTE WHERE VIGENTE.CodCia = DOCU.CodCia
            AND VIGENTE.NroOrd = DOCU.NroOrd
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE VIGENTE THEN CREATE VIGENTE.
        ASSIGN
            VIGENTE.CodCia = DOCU.CodCia
            VIGENTE.NroOrd = DOCU.NroOrd
            VIGENTE.FlgEst = DOCU.FlgEst.
        IF DOCU.CodMon = 1
        THEN VIGENTE.SdoAct = VIGENTE.SdoAct + DOCU.SdoAct.
        ELSE VIGENTE.SdoAct = VIGENTE.SdoAct + DOCU.SdoAct * x-TpoCmb.
    END.
    IF DOCU.FlgEst = 'VE' THEN DO:
        FIND VENCIDA WHERE VENCIDA.CodCia = DOCU.CodCia
            AND VENCIDA.NroOrd = DOCU.NroOrd
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE VENCIDA THEN CREATE VENCIDA.
        ASSIGN
            VENCIDA.CodCia = DOCU.CodCia
            VENCIDA.NroOrd = DOCU.NroOrd
            VENCIDA.FlgEst = DOCU.FlgEst.
        IF DOCU.CodMon = 1
        THEN VENCIDA.SdoAct = VENCIDA.SdoAct + DOCU.SdoAct.
        ELSE VENCIDA.SdoAct = VENCIDA.SdoAct + DOCU.SdoAct * x-TpoCmb.
    END.
  END.
  
  /* TOTALES */
  ASSIGN
    x-SdoAct-1 = 0
    x-SdoAct-2 = 0.
  FOR EACH VIGENTE:
    x-SdoAct-1 = x-SdoAct-1 + VIGENTE.SdoAct.
  END.
  FOR EACH VENCIDA:
    x-SdoAct-2 = x-SdoAct-2 + VENCIDA.SdoAct.
  END.
  DISPLAY
    x-SdoAct-1 x-SdoAct-2 WITH FRAME {&FRAME-NAME}.

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
  DEF VAR x-Dias AS DEC NO-UNDO.
  DEF VAR x-Rango AS CHAR NO-UNDO.
  
  DISPLAY
    'Cargando información' SKIP
    'Un momento por favor...' SKIp
    WITH FRAME f-Mensaje CENTERED OVERLAY VIEW-AS DIALOG-BOX.
  FOR EACH FacDocum NO-LOCK WHERE codcia = s-codcia
        AND TpoDoc <> ?
        AND LOOKUP(FacDocum.CodDoc, 'FAC,BOL,N/D,N/C,CHQ,LET,A/R,A/C,BD') > 0:
    FOR EACH CcbCDocu NO-LOCK WHERE CcbCDocu.codcia = s-codcia
            AND FlgEst = 'P'
            AND CcbCDocu.CodDoc = FacDocum.CodDoc:
        /*
        IF LOOKUP(CcbCDocu.CodCli, '20511358907,20503843812') > 0 THEN NEXT.    /* NO Filiales */
        */
        /* Vencimiento */
        x-Dias = TODAY - FchVto.
        IF ABSOLUTE(x-Dias) <= 15 THEN x-Rango = '0  - 15'.
        IF ABSOLUTE(x-Dias) > 15 AND ABSOLUTE(x-Dias) <= 30 THEN x-Rango = '16 - 30'.
        IF ABSOLUTE(x-Dias) > 31 AND ABSOLUTE(x-Dias) <= 60 THEN x-Rango = '31 - 60'.
        IF ABSOLUTE(x-Dias) > 61 AND ABSOLUTE(x-Dias) <= 90 THEN x-Rango = '61 - 90'.
        IF ABSOLUTE(x-Dias) > 90 THEN x-Rango = '90 >'.
        CREATE DOCU.
        BUFFER-COPY CcbCDocu TO DOCU
            ASSIGN
                DOCU.NroOrd = x-Rango
                DOCU.SdoAct = CcbCDocu.SdoAct * (IF FacDocum.TpoDoc = NO THEN -1 ELSE 1)
                DOCU.ImpTot = CcbCDocu.ImpTot * (IF FacDocum.TpoDoc = NO THEN -1 ELSE 1)
                DOCU.Libre_c05 = CcbCDocu.FlgEst.

        /*RDP - Estado Letras*/
        IF CcbCDocu.CodDoc = 'LET' THEN DO:
            CASE CcbCDocu.FlgUbi:
                WHEN 'C' THEN DOCU.Libre_c04 = 'En Cartera'.
                WHEN 'B' THEN DO: 
                    IF CcbCDocu.FlgSit = 'C' THEN DOCU.Libre_c04 = 'En Cobranza'.
                    IF CcbCDocu.FlgSit = 'D' THEN DOCU.Libre_c04 = 'En Descuento'.
                END.
            END CASE.
        END.

        IF x-Dias  > 0 THEN DOCU.FlgEst = 'VE'.     /* Vencida */
        IF x-Dias <= 0 THEN DOCU.FlgEst = 'VI'.     /* Vigente */

        /*RDP - Estado Factura y Boletas*/
        IF DOCU.FlgEst = 'VE' THEN DOCU.Libre_c04 = 'Vencida'.        
    END.            
  END.
  HIDE FRAME f-Mensaje.
  
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
  DISPLAY x-Division x-TpoCmb x-SdoAct-1 x-SdoAct-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE Btn_Done RECT-1 x-Division BROWSE-1 BUTTON-2 BROWSE-2 
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

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

DEFINE VARIABLE cMon                    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDivi                   AS CHARACTER   NO-UNDO.
/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* /* Titulos */                                              */
chWorkSheet:Range("A1"):VALUE = "Division".
chWorkSheet:Range("B1"):VALUE = "Estado".
chWorkSheet:Range("C1"):VALUE = "Orden".
chWorkSheet:Range("D1"):VALUE = "Fecha Doc".
chWorkSheet:Range("E1"):VALUE = "Fecha Vto".
chWorkSheet:Range("F1"):VALUE = "Cod Doc".
chWorkSheet:Range("G1"):VALUE = "Nro Doc".
chWorkSheet:Range("H1"):VALUE = "Cliente".
chWorkSheet:Range("I1"):VALUE = "Razon Social".
chWorkSheet:Range("J1"):VALUE = "Moneda".
chWorkSheet:Range("K1"):VALUE = "Importe".
chWorkSheet:Range("L1"):VALUE = "Saldo".
chWorkSheet:Range("M1"):VALUE = "Mensaje".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:COLUMNS("C"):NumberFormat = "@".
chWorkSheet:COLUMNS("G"):NumberFormat = "@".
chWorkSheet:COLUMNS("H"):NumberFormat = "@".

chWorkSheet = chExcelApplication:Sheets:Item(1).

IF x-division = 'Todas' THEN cDivi = ''.
ELSE cDivi = SUBSTRING(x-division,1,5).

FOR EACH DOCU WHERE DOCU.CodCia = s-codcia 
    AND docu.coddiv BEGINS cDivi
    AND docu.flgest <> "P" NO-LOCK
    BREAK BY docu.nroord:
    IF docu.codmon = 1 THEN cMon = "S/.". ELSE cMon = "$".
        
    t-Row = t-Row + 1.
    t-column = 0.
    /*MESSAGE t-row SKIP docu.nroord.*/
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = docu.coddiv.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = docu.flgest.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = docu.nroord.

    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = docu.fchdoc.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = docu.fchvto.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = docu.coddoc.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = docu.nrodoc.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = docu.codcli.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = docu.nomcli.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = cMon.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = docu.imptot.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = docu.sdoact.
    t-column = t-column + 1.
    chWorkSheet:Cells(t-Row, t-Column) = docu.libre_C04.

END.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

SESSION:SET-WAIT-STATE('').


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
  /* Tipo de Cambio */
  FIND LAST Gn-Tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-Tcmb 
  THEN x-TpoCmb = gn-tcmb.venta.
  ELSE x-TpoCmb = 0.
  /* Temporales */
  RUN Carga-Temporal.
  RUN Carga-Resumenes.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH Gn-Divi NO-LOCK WHERE codcia = s-codcia:
        x-Division:ADD-LAST(Gn-Divi.coddiv + ' ' + Gn-divi.desdiv).
    END.
  END.

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "VENCIDA"}
  {src/adm/template/snd-list.i "VIGENTE"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

