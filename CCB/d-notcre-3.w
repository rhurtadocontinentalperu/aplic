&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-DMvto FOR CcbDMvto.
DEFINE SHARED TEMP-TABLE T-ADOCU NO-UNDO LIKE CcbDMvto.
DEFINE TEMP-TABLE T-DMvto-1 NO-UNDO LIKE CcbDMvto.
DEFINE TEMP-TABLE T-DMvto-2 NO-UNDO LIKE CcbDMvto.



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

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcli AS CHAR.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codmon AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-nrodoc AS CHAR.

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
&Scoped-define INTERNAL-TABLES T-DMvto-1 T-DMvto-2

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 T-DMvto-1.NroMes T-DMvto-1.CodRef ~
T-DMvto-1.NroRef T-DMvto-1.ImpDoc T-DMvto-1.ImpInt T-DMvto-1.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH T-DMvto-1 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH T-DMvto-1 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 T-DMvto-1
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 T-DMvto-1


/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 T-DMvto-2.NroMes T-DMvto-2.CodRef ~
T-DMvto-2.NroRef T-DMvto-2.ImpDoc T-DMvto-2.ImpInt T-DMvto-2.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH T-DMvto-2 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH T-DMvto-2 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 T-DMvto-2
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 T-DMvto-2


/* Definitions for DIALOG-BOX gDialog                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-gDialog ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-Fecha-1 x-Fecha-2 x-PorReb BUTTON-2 ~
BROWSE-2 BROWSE-3 BUTTON-3 BUTTON-4 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS x-CodCli x-NomCli x-Fecha-1 x-Fecha-2 ~
x-PorReb F-ImpTot 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.15.

DEFINE BUTTON BUTTON-2 
     LABEL "FILTRAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-3 
     LABEL ">>" 
     SIZE 7 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON-4 
     LABEL "<<" 
     SIZE 7 BY 1.12
     FONT 6.

DEFINE VARIABLE F-ImpTot AS DECIMAL FORMAT "ZZZ,ZZ9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 6.

DEFINE VARIABLE x-CodCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-Fecha-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Emitidos desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-Fecha-2 AS DATE FORMAT "99/99/99":U 
     LABEL "hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58 BY .81 NO-UNDO.

DEFINE VARIABLE x-PorReb AS DECIMAL FORMAT ">>9.99":U INITIAL 2 
     LABEL "% Rebade" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      T-DMvto-1 SCROLLING.

DEFINE QUERY BROWSE-3 FOR 
      T-DMvto-2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 gDialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      T-DMvto-1.NroMes COLUMN-LABEL "Item" FORMAT ">>9":U
      T-DMvto-1.CodRef FORMAT "x(3)":U
      T-DMvto-1.NroRef FORMAT "X(9)":U WIDTH 10.57
      T-DMvto-1.ImpDoc COLUMN-LABEL "Importe" FORMAT ">>>,>>9.99":U
      T-DMvto-1.ImpInt COLUMN-LABEL "% Rebade" FORMAT ">>9.99":U
      T-DMvto-1.ImpTot COLUMN-LABEL "Importe Rebade" FORMAT ">>>,>>9.99":U
            WIDTH 9.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 50 BY 13.19
         FONT 4
         TITLE "DOCUMENTOS ACEPTADOS" ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 gDialog _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      T-DMvto-2.NroMes COLUMN-LABEL "Item" FORMAT ">>9":U
      T-DMvto-2.CodRef FORMAT "x(3)":U
      T-DMvto-2.NroRef FORMAT "X(9)":U WIDTH 10.57
      T-DMvto-2.ImpDoc COLUMN-LABEL "Importe" FORMAT ">>>,>>9.99":U
      T-DMvto-2.ImpInt COLUMN-LABEL "% Rebade" FORMAT ">>9.99":U
      T-DMvto-2.ImpTot COLUMN-LABEL "Importe Rebade" FORMAT ">>>,>>9.99":U
            WIDTH 9.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 50 BY 13.19
         FONT 4
         TITLE "DOCUMENTOS RECHAZADOS" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     x-CodCli AT ROW 1.54 COL 12 COLON-ALIGNED WIDGET-ID 2
     x-NomCli AT ROW 1.54 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     x-Fecha-1 AT ROW 2.62 COL 12 COLON-ALIGNED WIDGET-ID 6
     x-Fecha-2 AT ROW 2.62 COL 29 COLON-ALIGNED WIDGET-ID 8
     x-PorReb AT ROW 3.69 COL 12 COLON-ALIGNED WIDGET-ID 10
     BUTTON-2 AT ROW 2.62 COL 51 WIDGET-ID 12
     BROWSE-2 AT ROW 5.31 COL 3 WIDGET-ID 200
     BROWSE-3 AT ROW 5.31 COL 69 WIDGET-ID 300
     BUTTON-3 AT ROW 7.46 COL 58 WIDGET-ID 14
     BUTTON-4 AT ROW 9.08 COL 58 WIDGET-ID 16
     Btn_OK AT ROW 20.38 COL 3
     Btn_Cancel AT ROW 20.38 COL 19
     F-ImpTot AT ROW 18.77 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     SPACE(75.28) SKIP(2.29)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "ASIGNAR DOCUMENTOS PARA REBADE"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: B-DMvto B "?" ? INTEGRAL CcbDMvto
      TABLE: T-ADOCU T "SHARED" NO-UNDO INTEGRAL CcbDMvto
      TABLE: T-DMvto-1 T "?" NO-UNDO INTEGRAL CcbDMvto
      TABLE: T-DMvto-2 T "?" NO-UNDO INTEGRAL CcbDMvto
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   NOT-VISIBLE FRAME-NAME Custom                                        */
/* BROWSE-TAB BROWSE-2 BUTTON-2 gDialog */
/* BROWSE-TAB BROWSE-3 BROWSE-2 gDialog */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-ImpTot IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-CodCli IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCli IN FRAME gDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.T-DMvto-1"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-DMvto-1.NroMes
"T-DMvto-1.NroMes" "Item" ">>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.T-DMvto-1.CodRef
     _FldNameList[3]   > Temp-Tables.T-DMvto-1.NroRef
"T-DMvto-1.NroRef" ? ? "character" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-DMvto-1.ImpDoc
"T-DMvto-1.ImpDoc" "Importe" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-DMvto-1.ImpInt
"T-DMvto-1.ImpInt" "% Rebade" ">>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-DMvto-1.ImpTot
"T-DMvto-1.ImpTot" "Importe Rebade" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.T-DMvto-2"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.T-DMvto-2.NroMes
"T-DMvto-2.NroMes" "Item" ">>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.T-DMvto-2.CodRef
     _FldNameList[3]   > Temp-Tables.T-DMvto-2.NroRef
"T-DMvto-2.NroRef" ? ? "character" ? ? ? ? ? ? no ? no no "10.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-DMvto-2.ImpDoc
"T-DMvto-2.ImpDoc" "Importe" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-DMvto-2.ImpInt
"T-DMvto-2.ImpInt" "% Rebade" ">>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-DMvto-2.ImpTot
"T-DMvto-2.ImpTot" "Importe Rebade" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
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
ON WINDOW-CLOSE OF FRAME gDialog /* ASIGNAR DOCUMENTOS PARA REBADE */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* OK */
DO:
  DEF VAR x-Item AS INT INIT 1 NO-UNDO.

  FOR EACH T-ADOCU:
      DELETE T-ADOCU.
  END.
  FOR EACH T-DMVTO-1 BY T-DMVTO-1.NroMes:
      CREATE T-ADOCU.
      BUFFER-COPY T-DMVTO-1 TO T-ADOCU
          ASSIGN
            T-ADOCU.NroMes = x-Item.
      x-Item = x-Item + 1.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 gDialog
ON CHOOSE OF BUTTON-2 IN FRAME gDialog /* FILTRAR */
DO:
  ASSIGN
      x-Fecha-1 x-Fecha-2 x-PorReb.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Filtrar.
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 gDialog
ON CHOOSE OF BUTTON-3 IN FRAME gDialog /* >> */
DO:
  IF AVAILABLE T-Dmvto-1 THEN DO:
      CREATE T-Dmvto-2.
      BUFFER-COPY T-Dmvto-1 TO T-Dmvto-2.
      DELETE T-Dmvto-1.
      {&OPEN-QUERY-BROWSE-2}
      {&OPEN-QUERY-BROWSE-3}
          RUN Imp-Total.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 gDialog
ON CHOOSE OF BUTTON-4 IN FRAME gDialog /* << */
DO:
    IF AVAILABLE T-Dmvto-2 THEN DO:
        CREATE T-Dmvto-1.
        BUFFER-COPY T-Dmvto-2 TO T-Dmvto-1.
        DELETE T-Dmvto-2.
        {&OPEN-QUERY-BROWSE-2}
        {&OPEN-QUERY-BROWSE-3}
            RUN Imp-Total.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-PorReb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-PorReb gDialog
ON LEAVE OF x-PorReb IN FRAME gDialog /* % Rebade */
DO:
  IF INPUT {&self-name} = 0 THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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
  DISPLAY x-CodCli x-NomCli x-Fecha-1 x-Fecha-2 x-PorReb F-ImpTot 
      WITH FRAME gDialog.
  ENABLE x-Fecha-1 x-Fecha-2 x-PorReb BUTTON-2 BROWSE-2 BROWSE-3 BUTTON-3 
         BUTTON-4 Btn_OK Btn_Cancel 
      WITH FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Filtrar gDialog 
PROCEDURE Filtrar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-Item AS INT INIT 1 NO-UNDO.

FOR EACH T-Dmvto-1:
    DELETE T-Dmvto-1.
END.
FOR EACH T-Dmvto-2:
    DELETE T-Dmvto-2.
END.

FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
    AND ( ccbcdocu.coddoc = 'FAC' OR ccbcdocu.coddoc = 'BOL' )
    AND ccbcdocu.codcli = s-codcli
    AND ccbcdocu.fchdoc >= x-fecha-1
    AND ccbcdocu.fchdoc <= x-fecha-2
    AND ccbcdocu.flgest <> 'A'
    AND ccbcdocu.codmon = s-codmon
    AND LOOKUP ( ccbcdocu.tpofac, 'A,S') = 0:
    FIND FIRST b-dmvto WHERE b-dmvto.codcia = s-codcia
        AND b-dmvto.coddoc = s-coddoc
        AND b-dmvto.nrodoc <> s-nrodoc
        AND b-dmvto.codref = ccbcdocu.coddoc
        AND b-dmvto.nroref = ccbcdocu.nrodoc
        NO-LOCK NO-ERROR.
    IF AVAILABLE b-dmvto THEN NEXT.
    CREATE T-Dmvto-1.
    ASSIGN
        T-DMvto-1.NroMes = x-Item
        T-DMvto-1.CodCia = ccbcdocu.codcia
        T-DMvto-1.CodCli = ccbcdocu.codcli
        T-DMvto-1.CodDiv = ccbcdocu.coddiv
        T-DMvto-1.CodRef = ccbcdocu.coddoc
        T-DMvto-1.NroRef = ccbcdocu.nrodoc
        T-DMvto-1.ImpDoc = ccbcdocu.imptot
        T-DMvto-1.ImpInt = x-porreb
        T-DMvto-1.ImpTot = ccbcdocu.imptot *  x-porreb / 100.
    x-Item = x-Item + 1.
END.
{&OPEN-QUERY-BROWSE-2}
{&OPEN-QUERY-BROWSE-3}
    RUN Imp-Total.

END PROCEDURE.

/*
RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'YES' THEN DO:
    IF CAN-FIND(T-ADOCU WHERE T-ADOCU.codref = T-ADocu.CodRef:SCREEN-VALUE IN BROWSE {&browse-name}
                AND T-ADocu.NroRef = T-ADOCU.NroRef:SCREEN-VALUE IN BROWSE {&browse-name}
                NO-LOCK) THEN DO:
        MESSAGE 'Documento YA registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO T-ADocu.CodRef.
        RETURN 'ADM-ERROR'.
    END.
    FIND FIRST b-dmvto WHERE b-dmvto.codcia = s-codcia
        AND b-dmvto.coddoc = s-coddoc
        AND b-dmvto.nrodoc <> s-nrodoc
        AND b-dmvto.codref = T-ADocu.CodRef:SCREEN-VALUE IN BROWSE {&browse-name}
        AND b-dmvto.nroref = T-ADOCU.NroRef:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
    IF AVAILABLE b-dmvto THEN DO:
        MESSAGE 'Documento YA registrado en la' s-coddoc b-dmvto.nrodoc VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO T-ADocu.CodRef.
        RETURN 'ADM-ERROR'.
    END.
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-Total gDialog 
PROCEDURE Imp-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN
    F-ImpTot = 0.
FOR EACH  T-DMVTO-1:
    f-ImpTot = f-ImpTot + T-DMvto-1.ImpTot. 
END.
DISPLAY
    f-ImpTot WITH FRAME {&FRAME-NAME}.

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
  ASSIGN
      x-Fecha-1 = TODAY - DAY(TODAY) + 1
      x-Fecha-2 = TODAY
      x-CodCli = s-codcli.
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = s-codcli
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN x-nomcli = gn-clie.nomcli.

  FOR EACH T-ADOCU:
      CREATE T-Dmvto-1.
      BUFFER-COPY T-ADOCU TO T-DMVTO-1.
  END.
  RUN Imp-Total.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

