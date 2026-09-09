&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME    DIALOG-1
&Scoped-define FRAME-NAME     DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 07/24/95 -  5:48 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

&IF "{&NEW}" = "" &THEN
    DEFINE INPUT PARAMETER RegAct   AS RECID.
    DEFINE INPUT PARAMETER y-codcia AS INTEGER.
&ELSE
    DEFINE VARIABLE RegAct AS RECID.
    DEFINE VARIABLE y-codcia AS INTEGER INITIAL 0.
&ENDIF

/* Local Variable Definitions ---                                       */

DEFINE {&NEW} SHARED VARIABLE s-periodo AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  DIALOG-1
&Scoped-define BROWSE-NAME BROWSE-2

/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 integral.cb-dmov.Nroitm ~
integral.cb-dmov.Codcta integral.cb-dmov.Nrodoc ~
integral.cb-dmov.Fchdoc integral.cb-dmov.Glodoc ~
integral.cb-dmov.TpoMov integral.cb-dmov.ImpMn1 ~
integral.cb-dmov.ImpMn2 
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH integral.cb-dmov WHERE integral.cb-dmov.CodCia = integral.cb-cmov.Codcia AND ~
integral.cb-dmov.Periodo = integral.cb-cmov.Periodo AND ~
integral.cb-dmov.NroMes = integral.cb-cmov.Nromes AND ~
integral.cb-dmov.Codope = integral.cb-cmov.Codope AND ~
integral.cb-dmov.Nroast = integral.cb-cmov.Nroast NO-LOCK.
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 integral.cb-dmov
&Scoped-define TABLES-IN-QUERY-BROWSE-2 integral.cb-dmov 

/* Definitions for DIALOG-BOX DIALOG-1                                  */
&Scoped-define FIELDS-IN-QUERY-DIALOG-1 integral.cb-cmov.Nroast ~
integral.cb-cmov.Fchast integral.cb-cmov.Usuario ~
integral.cb-cmov.Nrovou integral.cb-cmov.Tpocmb ~
integral.cb-cmov.Notast integral.cb-cmov.GloAst ~
integral.cb-cmov.DbeMn1 integral.cb-cmov.HbeMn1 ~
integral.cb-cmov.DbeMn2 integral.cb-cmov.HbeMn2 
&Scoped-define ENABLED-FIELDS-IN-QUERY-DIALOG-1 
&Scoped-define OPEN-BROWSERS-IN-QUERY-DIALOG-1 ~
    ~{&OPEN-QUERY-BROWSE-2}
&Scoped-define OPEN-QUERY-DIALOG-1 OPEN QUERY DIALOG-1 FOR EACH integral.cb-cmov ~
      WHERE RECID(cb-cmov) = RegAct SHARE-LOCK.
&Scoped-define FIRST-TABLE-IN-QUERY-DIALOG-1 integral.cb-cmov
&Scoped-define TABLES-IN-QUERY-DIALOG-1 integral.cb-cmov 

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-salir AUTO-END-KEY 
     LABEL "&Atr s" 
     SIZE 11.72 BY 1.08.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "IMG/print"
     LABEL "Button 2" 
     SIZE 6 BY 1.69.

DEFINE VARIABLE s-nomcia AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .88
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE R-maestro1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 89.86 BY 13.96
     BGCOLOR 8 .

DEFINE RECTANGLE R-maestro2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 89.86 BY 2.5
     BGCOLOR 8 .


/* Query definitions                                                    */
DEFINE QUERY BROWSE-2 FOR integral.cb-dmov SCROLLING.
DEFINE QUERY DIALOG-1 FOR integral.cb-cmov SCROLLING.

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2 QUERY BROWSE-2 NO-LOCK DISPLAY 
      integral.cb-dmov.Nroitm COLUMN-LABEL "Item"
      integral.cb-dmov.Codcta
      integral.cb-dmov.Nrodoc
      integral.cb-dmov.Fchdoc
      integral.cb-dmov.Glodoc
      integral.cb-dmov.TpoMov
      integral.cb-dmov.ImpMn1
      integral.cb-dmov.ImpMn2
    WITH SEPARATORS SIZE 87 BY 4.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     integral.cb-cmov.Nroast AT ROW 1.5 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 1 FGCOLOR 15 
     s-nomcia AT ROW 1.5 COL 53 COLON-ALIGNED NO-LABEL
     integral.cb-cmov.Fchast AT ROW 2.5 COL 11 COLON-ALIGNED HELP
          "Ingrese la fecha del asiento"
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .81
          BGCOLOR 1 FGCOLOR 15 
     integral.cb-cmov.Usuario AT ROW 2.5 COL 72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
          BGCOLOR 1 FGCOLOR 15 
     integral.cb-cmov.Nrovou AT ROW 3.5 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.43 BY .81
          BGCOLOR 1 FGCOLOR 15 
     integral.cb-cmov.Tpocmb AT ROW 3.5 COL 72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
          BGCOLOR 1 FGCOLOR 15 
     integral.cb-cmov.Notast AT ROW 4.5 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 52.86 BY .81
          BGCOLOR 1 FGCOLOR 15 
     integral.cb-cmov.GloAst AT ROW 5.5 COL 13 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 53 BY 2
          BGCOLOR 1 FGCOLOR 15 
     BROWSE-2 AT ROW 7.69 COL 2
     integral.cb-cmov.DbeMn1 AT ROW 12.5 COL 37 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY 1
          BGCOLOR 1 FGCOLOR 15 
     integral.cb-cmov.HbeMn1 AT ROW 12.5 COL 70 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY 1
          BGCOLOR 1 FGCOLOR 15 
     integral.cb-cmov.DbeMn2 AT ROW 13.69 COL 37 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY 1
          BGCOLOR 1 FGCOLOR 15 
     integral.cb-cmov.HbeMn2 AT ROW 13.69 COL 70 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY 1
          BGCOLOR 1 FGCOLOR 15 
     BUTTON-2 AT ROW 15.38 COL 65
     b-salir AT ROW 15.69 COL 76
     R-maestro1 AT ROW 1 COL 1
     R-maestro2 AT ROW 15 COL 1
     SPACE(0.01) SKIP(0.01)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         TITLE "Diario General".

 


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

ASSIGN 
       BROWSE-2:NUM-LOCKED-COLUMNS IN FRAME DIALOG-1 = 2.

/* SETTINGS FOR FILL-IN integral.cb-cmov.DbeMn1 IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN integral.cb-cmov.DbeMn2 IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN integral.cb-cmov.Fchast IN FRAME DIALOG-1
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR EDITOR integral.cb-cmov.GloAst IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN integral.cb-cmov.HbeMn1 IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN integral.cb-cmov.HbeMn2 IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN integral.cb-cmov.Notast IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN integral.cb-cmov.Nroast IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN integral.cb-cmov.Nrovou IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN integral.cb-cmov.Tpocmb IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN integral.cb-cmov.Usuario IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-nomcia IN FRAME DIALOG-1
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "integral.cb-dmov WHERE integral.cb-cmov  ..."
     _Options          = "NO-LOCK"
     _OrdList          = ""
     _JoinCode[1]      = "integral.cb-dmov.CodCia = integral.cb-cmov.Codcia AND
integral.cb-dmov.Periodo = integral.cb-cmov.Periodo AND
integral.cb-dmov.NroMes = integral.cb-cmov.Nromes AND
integral.cb-dmov.Codope = integral.cb-cmov.Codope AND
integral.cb-dmov.Nroast = integral.cb-cmov.Nroast"
     _Where[1]         = ?
     _FldNameList[1]   = integral.cb-dmov.Nroitm
     _FldLabelList[1]  = "Item"
     _FldNameList[2]   = integral.cb-dmov.Codcta
     _FldNameList[3]   = integral.cb-dmov.Nrodoc
     _FldNameList[4]   = integral.cb-dmov.Fchdoc
     _FldNameList[5]   = integral.cb-dmov.Glodoc
     _FldNameList[6]   = integral.cb-dmov.TpoMov
     _FldNameList[7]   = integral.cb-dmov.ImpMn1
     _FldNameList[8]   = integral.cb-dmov.ImpMn2
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX DIALOG-1
/* Query rebuild information for DIALOG-BOX DIALOG-1
     _TblList          = "integral.cb-cmov"
     _Options          = "SHARE-LOCK"
     _OrdList          = ""
     _JoinCode[1]      = ?
     _Where[1]         = "RECID(cb-cmov) = RegAct"
     _Query            is OPENED
*/  /* DIALOG-BOX DIALOG-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.

    FIND Empresas WHERE Empresas.CodCia = cb-cmov.CodCia NO-LOCK NO-ERROR.
    FIND cb-oper WHERE cb-oper.CodCia = y-Codcia AND
        cb-oper.CodOpe = cb-cmov.CodOpe NO-LOCK NO-ERROR.
    IF AVAILABLE cb-oper THEN DO:
        RUN bin/_mes.p ( INPUT cb-cmov.NroMes , 1,  OUTPUT s-nomcia ).
        s-nomcia = cb-oper.NomOpe + "  " + s-nomcia + ", " + 
            STRING( s-periodo , "9999" ).
        FRAME DIALOG-1:TITLE = s-nomcia.
    END.
    s-nomcia = Empresas.NomCia.
    DISPLAY s-nomcia WITH FRAME DIALOG-1.

    WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1 _DEFAULT-DISABLE
PROCEDURE disable_UI :
/* --------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
   -------------------------------------------------------------------- */
  /* Hide all frames. */
  HIDE FRAME DIALOG-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DIALOG-1 _DEFAULT-ENABLE
PROCEDURE enable_UI :
/* --------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
   -------------------------------------------------------------------- */

  {&OPEN-QUERY-DIALOG-1}
  GET FIRST DIALOG-1.
  DISPLAY s-nomcia 
      WITH FRAME DIALOG-1.
  IF AVAILABLE integral.cb-cmov THEN 
    DISPLAY integral.cb-cmov.Nroast integral.cb-cmov.Fchast 
          integral.cb-cmov.Usuario integral.cb-cmov.Nrovou 
          integral.cb-cmov.Tpocmb integral.cb-cmov.Notast 
          integral.cb-cmov.GloAst integral.cb-cmov.DbeMn1 
          integral.cb-cmov.HbeMn1 integral.cb-cmov.DbeMn2 
          integral.cb-cmov.HbeMn2 
      WITH FRAME DIALOG-1.
  ENABLE R-maestro1 BROWSE-2 R-maestro2 BUTTON-2 b-salir 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE BROWSE-NAME
&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME
