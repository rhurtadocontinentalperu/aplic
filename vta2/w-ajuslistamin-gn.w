&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-Lista LIKE VtaListaMinGn.



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


DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR x-CodFam LIKE almmmatg.codfam  NO-UNDO.
DEF VAR x-SubFam LIKE almmmatg.subfam  NO-UNDO.

DEF VAR x-NewOfi LIKE VtaListaMinGn.PreOfi.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv NO-LOCK.
/* LISTAS DE PRECIOS */
IF gn-divi.VentaMinorista = 2 THEN DO:
    MESSAGE 'Acceso denegado' SKIP
        'Tiene que usar la LISTA MINORISTA POR DIVISION - ACTUALIZACION DE PRECIOS EN BLOQUE'
        VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.

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
&Scoped-define INTERNAL-TABLES T-Lista Almmmatg

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 T-Lista.codmat Almmmatg.DesMat ~
Almmmatg.DesMar Almmmatg.codfam Almmmatg.subfam T-Lista.MonVta ~
T-Lista.Chr__01 T-Lista.PreOfi ~
IF (COMBO-BOX-Tipo = 'Incremento') THEN (T-Lista.PreOfi * ( 1 + FILL-IN-Tasa / 100)) ELSE (T-Lista.PreOfi * ( 1 - FILL-IN-Tasa / 100))  @ x-NewOfi 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH T-Lista NO-LOCK, ~
      EACH Almmmatg OF T-Lista NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH T-Lista NO-LOCK, ~
      EACH Almmmatg OF T-Lista NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 T-Lista Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 T-Lista
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-Calcular BtnDone COMBO-BOX-CodFam ~
COMBO-BOX-SubFam FILL-IN-Marca FILL-IN-CodPro FILL-IN-Tasa COMBO-BOX-Tipo ~
BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje COMBO-BOX-CodFam ~
COMBO-BOX-SubFam FILL-IN-Marca FILL-IN-CodPro FILL-IN-NomPro FILL-IN-Tasa ~
COMBO-BOX-Tipo 

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
     SIZE 7 BY 1.65 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-Calcular 
     IMAGE-UP FILE "img/gear.ico":U
     IMAGE-INSENSITIVE FILE "img/delete.ico":U
     LABEL "Button 7" 
     SIZE 7 BY 1.62 TOOLTIP "Calcular Nuevos Precios".

DEFINE BUTTON BUTTON-Grabar 
     IMAGE-UP FILE "img/tick.ico":U
     IMAGE-INSENSITIVE FILE "img/delete.ico":U
     LABEL "Button 9" 
     SIZE 7 BY 1.62 TOOLTIP "Grabar los Nuevos Precios".

DEFINE BUTTON BUTTON-Modificar 
     IMAGE-UP FILE "img/plus.ico":U
     IMAGE-INSENSITIVE FILE "img/delete.ico":U
     LABEL "Button 10" 
     SIZE 7 BY 1.62 TOOLTIP "Modificar Filtros".

DEFINE VARIABLE COMBO-BOX-CodFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-SubFam AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Sub-linea" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Tipo AS CHARACTER FORMAT "X(256)":U INITIAL "Incremento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Incremento","Decremento" 
     DROP-DOWN-LIST
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Tasa AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Tasa en %" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      T-Lista, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 wWin _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      T-Lista.codmat COLUMN-LABEL "Codigo!Articulo" FORMAT "X(6)":U
            WIDTH 7.43
      Almmmatg.DesMat FORMAT "X(45)":U
      Almmmatg.DesMar FORMAT "X(30)":U
      Almmmatg.codfam FORMAT "X(3)":U
      Almmmatg.subfam FORMAT "X(3)":U
      T-Lista.MonVta COLUMN-LABEL "Moneda!de Venta" FORMAT "9":U
            VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "Soles",1,
                                      "Dolares",2
                      DROP-DOWN-LIST 
      T-Lista.Chr__01 COLUMN-LABEL "Unidad" FORMAT "X(8)":U
      T-Lista.PreOfi FORMAT ">,>>>,>>9.9999":U WIDTH 14.29
      IF (COMBO-BOX-Tipo = 'Incremento') THEN (T-Lista.PreOfi * ( 1 + FILL-IN-Tasa / 100)) ELSE (T-Lista.PreOfi * ( 1 - FILL-IN-Tasa / 100))
 @ x-NewOfi COLUMN-LABEL "Nuevo Precio Oficina" FORMAT ">,>>>,>>9.9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 121 BY 12.38
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     BUTTON-Calcular AT ROW 1 COL 2 WIDGET-ID 48
     BUTTON-Modificar AT ROW 1 COL 9 WIDGET-ID 54
     BUTTON-Grabar AT ROW 1 COL 16 WIDGET-ID 52
     BtnDone AT ROW 1 COL 23 WIDGET-ID 50
     FILL-IN-Mensaje AT ROW 1.27 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     COMBO-BOX-CodFam AT ROW 2.88 COL 13 COLON-ALIGNED WIDGET-ID 36
     COMBO-BOX-SubFam AT ROW 3.69 COL 13 COLON-ALIGNED WIDGET-ID 38
     FILL-IN-Marca AT ROW 4.5 COL 13 COLON-ALIGNED WIDGET-ID 40
     FILL-IN-CodPro AT ROW 5.31 COL 13 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-NomPro AT ROW 5.31 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     FILL-IN-Tasa AT ROW 6.12 COL 13 COLON-ALIGNED WIDGET-ID 46
     COMBO-BOX-Tipo AT ROW 6.12 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     BROWSE-2 AT ROW 7.19 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 124.29 BY 18.81
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: T-Lista T "?" ? INTEGRAL VtaListaMinGn
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "LISTA MINORISTA GENERAL - ACTUALIZACION DE PRECIOS EN BLOQUE"
         HEIGHT             = 18.81
         WIDTH              = 124.29
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
/* BROWSE-TAB BROWSE-2 COMBO-BOX-Tipo fMain */
/* SETTINGS FOR BUTTON BUTTON-Grabar IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-Modificar IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.T-Lista,INTEGRAL.Almmmatg OF Temp-Tables.T-Lista"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > Temp-Tables.T-Lista.codmat
"T-Lista.codmat" "Codigo!Articulo" ? "character" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.Almmmatg.DesMat
     _FldNameList[3]   = INTEGRAL.Almmmatg.DesMar
     _FldNameList[4]   = INTEGRAL.Almmmatg.codfam
     _FldNameList[5]   = INTEGRAL.Almmmatg.subfam
     _FldNameList[6]   > Temp-Tables.T-Lista.MonVta
"T-Lista.MonVta" "Moneda!de Venta" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "Soles,1,Dolares,2" 5 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-Lista.Chr__01
"T-Lista.Chr__01" "Unidad" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-Lista.PreOfi
"T-Lista.PreOfi" ? ? "decimal" ? ? ? ? ? ? no ? no no "14.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"IF (COMBO-BOX-Tipo = 'Incremento') THEN (T-Lista.PreOfi * ( 1 + FILL-IN-Tasa / 100)) ELSE (T-Lista.PreOfi * ( 1 - FILL-IN-Tasa / 100))
 @ x-NewOfi" "Nuevo Precio Oficina" ">,>>>,>>9.9999" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* LISTA MINORISTA GENERAL - ACTUALIZACION DE PRECIOS EN BLOQUE */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* LISTA MINORISTA GENERAL - ACTUALIZACION DE PRECIOS EN BLOQUE */
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


&Scoped-define SELF-NAME BUTTON-Calcular
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Calcular wWin
ON CHOOSE OF BUTTON-Calcular IN FRAME fMain /* Button 7 */
DO:
  ASSIGN
      COMBO-BOX-CodFam COMBO-BOX-SubFam FILL-IN-CodPro FILL-IN-Marca FILL-IN-Tasa
      COMBO-BOX-Tipo.
  IF FILL-IN-Tasa = 0 THEN DO:
      MESSAGE 'Ingrese el % de Incremento' VIEW-AS ALERT-BOX WARNING.
      APPLY 'entry':u TO FILL-IN-Tasa.
      RETURN NO-APPLY.
  END.
   RUN Carga-Temporal.
   ASSIGN
       BUTTON-Grabar:SENSITIVE = YES
       BUTTON-Modificar:SENSITIVE = YES
       BUTTON-Calcular:SENSITIVE = NO.
   RUN Deshabilita-Campos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Grabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Grabar wWin
ON CHOOSE OF BUTTON-Grabar IN FRAME fMain /* Button 9 */
DO:
    MESSAGE 'Actualizamos la lista de precios MINORISTA?'
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
     RUN Grabar-Precios.
    ASSIGN
        BUTTON-Grabar:SENSITIVE = NO
        BUTTON-Modificar:SENSITIVE = NO
        BUTTON-Calcular:SENSITIVE = YES.
    RUN Habilita-Campos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Modificar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Modificar wWin
ON CHOOSE OF BUTTON-Modificar IN FRAME fMain /* Button 10 */
DO:
    ASSIGN
        BUTTON-Grabar:SENSITIVE = NO
        BUTTON-Modificar:SENSITIVE = NO
        BUTTON-Calcular:SENSITIVE = YES.
    RUN Habilita-Campos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodFam wWin
ON VALUE-CHANGED OF COMBO-BOX-CodFam IN FRAME fMain /* Linea */
DO:
    COMBO-BOX-SubFam:DELETE(COMBO-BOX-SubFam:LIST-ITEMS).
    COMBO-BOX-SubFam:ADD-LAST('Todos').
    COMBO-BOX-SubFam:SCREEN-VALUE = 'Todos'.
    IF SELF:SCREEN-VALUE <> 'Todos' THEN DO:
        FOR EACH Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia
            AND Almsfami.codfam = ENTRY(1, SELF:SCREEN-VALUE, ' - '):
            COMBO-BOX-SubFam:ADD-LAST(Almsfami.subfam + ' - '+ AlmSFami.dessub).
        END.
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

ASSIGN
    x-CodFam = ''
    x-SubFam = ''.
IF NOT COMBO-BOX-CodFam BEGINS 'Todos' THEN x-CodFam = ENTRY(1, COMBO-BOX-CodFam, ' - ').
IF NOT COMBO-BOX-SubFam BEGINS 'Todos' THEN x-SubFam = ENTRY(1, COMBO-BOX-SubFam, ' - ').

EMPTY TEMP-TABLE T-Lista.

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** UN MOMENTO POR FAVOR **'.
FOR EACH VtaListaMinGn NO-LOCK WHERE VtaListaMinGn.codcia = s-codcia,
    FIRST Almmmatg OF VtaListaMinGn NO-LOCK WHERE Almmmatg.desmar BEGINS FILL-IN-Marca
    AND Almmmatg.codpr1 BEGINS FILL-IN-CodPro
    AND Almmmatg.codfam BEGINS x-codfam
    AND Almmmatg.subfam BEGINS x-subfam:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** PROCESANDO ' + VtaListaMinGn.codmat + ' **'.
    CREATE T-Lista.
    BUFFER-COPY VtaListaMinGn
        TO T-Lista
        ASSIGN T-Lista.CanEmp = VtaListaMinGn.PreOfi * ( 1 + FILL-IN-Tasa / 100).
END.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
{&OPEN-QUERY-{&BROWSE-NAME}}
              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Deshabilita-Campos wWin 
PROCEDURE Deshabilita-Campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        COMBO-BOX-CodFam:SENSITIVE = NO
        COMBO-BOX-SubFam:SENSITIVE = NO
        FILL-IN-CodPro:SENSITIVE = NO
        FILL-IN-Marca:SENSITIVE = NO
        FILL-IN-Tasa:SENSITIVE = NO
        COMBO-BOX-Tipo:SENSITIVE = NO.
END.

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
  DISPLAY FILL-IN-Mensaje COMBO-BOX-CodFam COMBO-BOX-SubFam FILL-IN-Marca 
          FILL-IN-CodPro FILL-IN-NomPro FILL-IN-Tasa COMBO-BOX-Tipo 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE BUTTON-Calcular BtnDone COMBO-BOX-CodFam COMBO-BOX-SubFam 
         FILL-IN-Marca FILL-IN-CodPro FILL-IN-Tasa COMBO-BOX-Tipo BROWSE-2 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar-Precios wWin 
PROCEDURE Grabar-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-CToTot AS DEC NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** UN MOMENTO POR FAVOR **'.
FOR EACH VtaListaMinGn EXCLUSIVE-LOCK WHERE VtaListaMinGn.codcia = s-codcia,
    FIRST Almmmatg OF VtaListaMinGn NO-LOCK WHERE Almmmatg.desmar BEGINS FILL-IN-Marca
    AND Almmmatg.codpr1 BEGINS FILL-IN-CodPro
    AND Almmmatg.codfam BEGINS x-codfam
    AND Almmmatg.subfam BEGINS x-subfam:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** ACTUALIZANDO ' + VtaListaMinGn.codmat + ' **'.
    ASSIGN
        VtaListaMinGn.codfam = Almmmatg.codfam
        VtaListaMinGn.DesMar = Almmmatg.desmar
        VtaListaMinGn.DesMat = Almmmatg.desmat
        VtaListaMinGn.subfam = Almmmatg.subfam
        VtaListaMinGn.FchAct  = TODAY
        VtaListaMinGn.usuario = s-user-id
        VtaListaMinGn.PreOfi = IF (COMBO-BOX-Tipo = 'Incremento') 
            THEN (VtaListaMinGn.PreOfi * ( 1 + FILL-IN-Tasa / 100)) 
            ELSE (VtaListaMinGn.PreOfi * ( 1 - FILL-IN-Tasa / 100)).
    IF Almmmatg.monvta = VtaListaMinGn.monvta THEN x-CtoTot = Almmmatg.CtoTot.
    ELSE IF VtaListaMinGn.monvta = 1 THEN x-CtoTot = Almmmatg.ctotot *  Almmmatg.tpocmb.
    ELSE x-CtoTot = Almmmatg.ctotot /  Almmmatg.tpocmb.
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = VtaListaMinGn.Chr__01
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN DO:
        F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
    END.  
    ASSIGN
        VtaListaMinGn.Dec__01 = ( (VtaListaMinGn.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100. 
END.
IF AVAILABLE(VtaListaMinGn) THEN RELEASE VtaListaMinGn.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.
EMPTY TEMP-TABLE T-Lista.
{&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita-Campos wWin 
PROCEDURE Habilita-Campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        COMBO-BOX-CodFam:SENSITIVE = YES
        COMBO-BOX-SubFam:SENSITIVE = YES
        FILL-IN-CodPro:SENSITIVE = YES
        FILL-IN-Marca:SENSITIVE = YES
        FILL-IN-Tasa:SENSITIVE = YES
        COMBO-BOX-Tipo:SENSITIVE = YES.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FOR EACH Almtfami NO-LOCK WHERE Almtfami.CodCia = s-codcia:
      COMBO-BOX-CodFam:ADD-LAST(Almtfami.codfam + ' - ' + Almtfami.desfam) IN FRAME {&FRAME-NAME}.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

