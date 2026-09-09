&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 07/14/95 -  7:08 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions -------------------------------------------- */

&IF "{&NEW}" = "" &THEN
    DEFINE INPUT PARAMETER x-CodCta AS CHARACTER.
    DEFINE INPUT PARAMETER y-codcia AS INTEGER.
    DEFINE INPUT PARAMETER x-NivMax AS INTEGER.
    DEFINE INPUT PARAMETER x-moneda AS CHARACTER.
&ELSE
    DEFINE VARIABLE x-CodCta AS CHARACTER INITIAL "10423".
    DEFINE VARIABLE y-codcia AS INTEGER INITIAL 0.
    DEFINE VARIABLE x-NivMax AS INTEGER INITIAL 5.
    DEFINE VARIABLE x-moneda AS CHARACTER INITIAL "D¢lares".
&ENDIF

/* Local Variable Definitions ---------------------------------------- */

DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INITIAL 1.
DEFINE {&NEW} SHARED VARIABLE s-periodo    AS INTEGER INITIAL 1995.
DEFINE {&NEW} SHARED VARIABLE s-NroMes    AS INTEGER INITIAL 0.
DEFINE {&NEW} SHARED VARIABLE s-user-id AS CHARACTER INITIAL "MASTER".

DEFINE VARIABLE x-GloDoc    AS CHARACTER.
DEFINE VARIABLE x-total     AS DECIMAL.
DEFINE VARIABLE RECID-stack AS RECID.
DEFINE VARIABLE RegAct      AS RECID.
DEFINE VARIABLE pto1        AS LOGICAL.
DEFINE VARIABLE pto         AS LOGICAL.
pto = SESSION:SET-WAIT-STATE("").

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES cb-dmov cb-ctas

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 cb-dmov.Codope cb-dmov.Nroast ~
cb-dmov.Fchdoc cb-dmov.Coddoc cb-dmov.Nrodoc (X-GloDoc) cb-dmov.TpoMov ~
(IF ( x-moneda = "Soles" ) THEN  (integral.cb-dmov.ImpMn1 )  ELSE  ( integral.cb-dmov.ImpMn2 ))  *  (IF (cb-dmov.TpoMov) THEN (-1) ELSE (1)) ~
cb-dmov.Fchvto cb-dmov.CodDiv 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-2
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH cb-dmov ~
      WHERE cb-dmov.CodCia = s-codcia ~
 AND cb-dmov.Codcta = x-CodCta ~
 AND cb-dmov.Periodo = s-periodo  ~
 AND cb-dmov.NroMes = s-NroMes NO-LOCK ~
    BY cb-dmov.Fchdoc ~
       BY cb-dmov.Codope ~
        BY cb-dmov.Nroast INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 cb-dmov
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 cb-dmov


/* Definitions for DIALOG-BOX DIALOG-1                                  */
&Scoped-define FIELDS-IN-QUERY-DIALOG-1 cb-ctas.Codcta cb-ctas.Nomcta 
&Scoped-define OPEN-BROWSERS-IN-QUERY-DIALOG-1 ~
    ~{&OPEN-QUERY-BROWSE-2}
&Scoped-define OPEN-QUERY-DIALOG-1 OPEN QUERY DIALOG-1 FOR EACH cb-ctas SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-DIALOG-1 cb-ctas
&Scoped-define FIRST-TABLE-IN-QUERY-DIALOG-1 cb-ctas


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 BROWSE-2 RECT-5 B-continuar B-salir 
&Scoped-Define DISPLAYED-FIELDS cb-ctas.Codcta cb-ctas.Nomcta 
&Scoped-Define DISPLAYED-OBJECTS x-nombre 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-continuar 
     LABEL "&Continuar" 
     SIZE 13 BY 1.

DEFINE BUTTON B-salir AUTO-END-KEY 
     LABEL "&Atrás" 
     SIZE 13 BY 1.

DEFINE VARIABLE x-nombre AS CHARACTER FORMAT "X(8)":U 
     VIEW-AS FILL-IN 
     SIZE 15 BY .69
     BGCOLOR 8 FONT 11 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 86.29 BY 2
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 86.14 BY 2
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      cb-dmov SCROLLING.

DEFINE QUERY DIALOG-1 FOR 
      cb-ctas SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 DIALOG-1 _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      cb-dmov.Codope COLUMN-LABEL "Opera-!ci¢n"
      cb-dmov.Nroast COLUMN-LABEL "Compro-!bante"
      cb-dmov.Fchdoc COLUMN-LABEL "Fecha!Docum."
      cb-dmov.Coddoc COLUMN-LABEL "C¢digo!Docum"
      cb-dmov.Nrodoc COLUMN-LABEL "Nro. de!Documento"
      (X-GloDoc) COLUMN-LABEL "D E T A L L E" FORMAT "X(30)"
      cb-dmov.TpoMov
      (IF ( x-moneda = "Soles" ) THEN  (integral.cb-dmov.ImpMn1 )  ELSE  ( integral.cb-dmov.ImpMn2 ))  *  (IF (cb-dmov.TpoMov) THEN (-1) ELSE (1)) COLUMN-LABEL "Importe" FORMAT "(>>>,>>>,>>9.99)"
      cb-dmov.Fchvto COLUMN-LABEL "Fecha!Vcto."
      cb-dmov.CodDiv COLUMN-LABEL "C¢digo!Division."
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 85.29 BY 11.35
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     cb-ctas.Codcta AT ROW 1.65 COL 1 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8 BY .69
          BGCOLOR 1 FGCOLOR 15 
     BROWSE-2 AT ROW 3.27 COL 1.57
     cb-ctas.Nomcta AT ROW 1.65 COL 10 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 57 BY .69
          BGCOLOR 1 FGCOLOR 15 
     B-continuar AT ROW 15.27 COL 21.14
     B-salir AT ROW 15.27 COL 51.29
     x-nombre AT ROW 1.65 COL 69 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 1 COL 1
     RECT-5 AT ROW 14.77 COL 1.14
     SPACE(0.00) SKIP(0.10)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Consulta".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
                                                                        */
/* BROWSE-TAB BROWSE-2 Codcta DIALOG-1 */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

ASSIGN 
       BROWSE-2:NUM-LOCKED-COLUMNS IN FRAME DIALOG-1 = 1.

/* SETTINGS FOR FILL-IN cb-ctas.Codcta IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cb-ctas.Nomcta IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-nombre IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "integral.cb-dmov"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "integral.cb-dmov.Fchdoc|yes,integral.cb-dmov.Codope|yes,integral.cb-dmov.Nroast|yes"
     _Where[1]         = "cb-dmov.CodCia = s-codcia
 AND cb-dmov.Codcta = x-CodCta
 AND cb-dmov.Periodo = s-periodo 
 AND cb-dmov.NroMes = s-NroMes"
     _FldNameList[1]   > integral.cb-dmov.Codope
"cb-dmov.Codope" "Opera-!ci¢n" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > integral.cb-dmov.Nroast
"cb-dmov.Nroast" "Compro-!bante" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[3]   > integral.cb-dmov.Fchdoc
"cb-dmov.Fchdoc" "Fecha!Docum." ? "date" ? ? ? ? ? ? no ?
     _FldNameList[4]   > integral.cb-dmov.Coddoc
"cb-dmov.Coddoc" "C¢digo!Docum" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[5]   > integral.cb-dmov.Nrodoc
"cb-dmov.Nrodoc" "Nro. de!Documento" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[6]   > "_<CALC>"
"(X-GloDoc)" "D E T A L L E" "X(30)" ? ? ? ? ? ? ? no ?
     _FldNameList[7]   = integral.cb-dmov.TpoMov
     _FldNameList[8]   > "_<CALC>"
"(IF ( x-moneda = ""Soles"" ) THEN  (integral.cb-dmov.ImpMn1 )  ELSE  ( integral.cb-dmov.ImpMn2 ))  *  (IF (cb-dmov.TpoMov) THEN (-1) ELSE (1))" "Importe" "(>>>,>>>,>>9.99)" ? ? ? ? ? ? ? no ?
     _FldNameList[9]   > integral.cb-dmov.Fchvto
"cb-dmov.Fchvto" "Fecha!Vcto." ? "date" ? ? ? ? ? ? no ?
     _FldNameList[10]   > integral.cb-dmov.CodDiv
"cb-dmov.CodDiv" "C¢digo!Division." ? "character" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX DIALOG-1
/* Query rebuild information for DIALOG-BOX DIALOG-1
     _TblList          = "integral.cb-ctas"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX DIALOG-1 */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-continuar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-continuar DIALOG-1
ON CHOOSE OF B-continuar IN FRAME DIALOG-1 /* Continuar */
DO:
    IF RECID( cb-dmov ) = ?
    THEN DO:
        BELL.
        MESSAGE "Registro no seleccionado" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    FIND cb-dmov WHERE RECID( cb-dmov ) = RegAct NO-LOCK NO-ERROR.
    FIND cb-cmov WHERE cb-cmov.CodCia  = cb-dmov.CodCia AND
                       cb-cmov.Periodo = cb-dmov.Periodo AND
                       cb-cmov.NroMes  = cb-dmov.NroMes AND
                       cb-cmov.CodOpe  = cb-dmov.CodOpe AND
                       cb-cmov.NroAst  = cb-dmov.NroAst NO-LOCK NO-ERROR.
    IF NOT AVAIL cb-cmov THEN DO:
        BELL.
        MESSAGE "Registro cabecera no existe" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    RegAct = RECID( cb-cmov ).
    RUN cbd/cbdcons3.w( RegAct, y-codcia ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 DIALOG-1
ON MOUSE-SELECT-DBLCLICK OF BROWSE-2 IN FRAME DIALOG-1
DO:
    RegAct = RECID( integral.cb-dmov ).
    APPLY "CHOOSE" TO B-continuar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 DIALOG-1
ON RETURN OF BROWSE-2 IN FRAME DIALOG-1
DO:
    RegAct = RECID( integral.cb-dmov ).
    APPLY "CHOOSE" TO B-continuar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 DIALOG-1
ON VALUE-CHANGED OF BROWSE-2 IN FRAME DIALOG-1
DO:
    RegAct = RECID( integral.cb-dmov ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.
ON FIND OF integral.cb-dmov
DO:
    x-glodoc = integral.cb-dmov.glodoc.
    IF x-glodoc = "" THEN DO:
        FIND cb-cmov WHERE cb-cmov.CodCia  = cb-dmov.CodCia AND
                           cb-cmov.Periodo = cb-dmov.Periodo AND
                           cb-cmov.NroMes  = cb-dmov.NroMes AND
                           cb-cmov.CodOpe  = cb-dmov.CodOpe AND
                           cb-cmov.NroAst  = cb-dmov.NroAst NO-LOCK NO-ERROR.
        IF AVAIL cb-cmov THEN x-glodoc = cb-cmov.notast.
    END.
END.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    RUN enable_UI.
    find cb-ctas WHERE cb-ctas.CodCia = y-CodCia AND
        cb-ctas.CodCta = x-CodCta NO-LOCK NO-ERROR.
    IF AVAIL integral.cb-ctas THEN
        DISPLAY integral.cb-ctas.Codcta integral.cb-ctas.Nomcta WITH FRAME DIALOG-1.
    x-nombre:SCREEN-VALUE = x-moneda.
    {&OPEN-QUERY-{&BROWSE-NAME}}
    WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1 _DEFAULT-DISABLE
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
  HIDE FRAME DIALOG-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DIALOG-1 _DEFAULT-ENABLE
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

  {&OPEN-QUERY-DIALOG-1}
  GET FIRST DIALOG-1.
  DISPLAY x-nombre 
      WITH FRAME DIALOG-1.
  IF AVAILABLE cb-ctas THEN 
    DISPLAY cb-ctas.Codcta cb-ctas.Nomcta 
      WITH FRAME DIALOG-1.
  ENABLE RECT-2 BROWSE-2 RECT-5 B-continuar B-salir 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


