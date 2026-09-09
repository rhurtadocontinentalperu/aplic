&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME    F-Maestro
&Scoped-define FRAME-NAME     F-Maestro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS F-Maestro 
/*------------------------------------------------------------------------

  File:               PRESUCON.W   

  Description:        CONSULTA DE PRESUPUESTO

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:   VALMIESA - Dpto.de TECNOLOGIA
            Jorge L. Infante B.

  Created: 05/09/95 -  9:50 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


DEFINE {&NEW} SHARED VARIABLE s-codcia AS INTEGER INIT 1.
/*
DEFINE  VARIABLE s-periodo    AS INTEGER INIT 1995.
*/
DEFINE VARIABLE RECID-stack AS RECID NO-UNDO.
DEFINE VARIABLE RECID-tmp   AS RECID NO-UNDO.
DEFINE VARIABLE pto         AS LOGICAL.
pto = SESSION:SET-WAIT-STATE(""). /* Para borrar Reloj de Arena del Mouse o Puntero */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  F-Maestro
&Scoped-define BROWSE-NAME BROWSE-9

/* Custom List Definitions                                              */
&Scoped-define LIST-1 
&Scoped-define LIST-2 
&Scoped-define LIST-3 

/* Definitions for BROWSE BROWSE-9                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-9 integral.Cjapresu.Anopre ~
integral.Cjapresu.Codflj integral.Cjapresu.Imppre[1] ~
integral.Cjapresu.Imppre[2] integral.Cjapresu.Imppre[3] ~
integral.Cjapresu.Imppre[4] integral.Cjapresu.Imppre[5] ~
integral.Cjapresu.Imppre[6] integral.Cjapresu.Imppre[7] ~
integral.Cjapresu.Imppre[8] integral.Cjapresu.Imppre[9] ~
integral.Cjapresu.Imppre[10] integral.Cjapresu.Imppre[11] ~
integral.Cjapresu.Imppre[12] 
&Scoped-define OPEN-QUERY-BROWSE-9 OPEN QUERY BROWSE-9 FOR EACH integral.Cjaconce WHERE integral.Cjaconce.CodCia = integral.Cjapresu.CodCia AND integral.Cjaconce.Codflj = integral.Cjapresu.Codflj ~
      AND integral.Cjaconce.CodCia = s-codcia ~
 AND integral.Cjaconce.Tipflj = TRUE ~
  NO-LOCK.
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-9 integral.Cjaconce
&Scoped-define TABLES-IN-QUERY-BROWSE-9 integral.Cjaconce 

/* Definitions for DIALOG-BOX F-Maestro                                 */
&Scoped-define FIELDS-IN-QUERY-F-Maestro 
&Scoped-define ENABLED-FIELDS-IN-QUERY-F-Maestro 
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Maestro ~
    ~{&OPEN-QUERY-BROWSE-9}
&Scoped-define OPEN-QUERY-F-Maestro OPEN QUERY F-Maestro FOR EACH integral.Cjapresu SHARE-LOCK.
&Scoped-define FIRST-TABLE-IN-QUERY-F-Maestro integral.Cjapresu
&Scoped-define TABLES-IN-QUERY-F-Maestro integral.Cjapresu 

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE s-periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "A¤o Presupuesto" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 7.5
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 8
     BGCOLOR 8 .


/* Query definitions                                                    */
DEFINE QUERY BROWSE-9 FOR integral.Cjaconce SCROLLING.
DEFINE QUERY F-Maestro FOR integral.Cjapresu SCROLLING.

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-9 QUERY BROWSE-9 NO-LOCK DISPLAY 
      integral.Cjapresu.Anopre COLUMN-LABEL "   A¤o"
      integral.Cjapresu.Codflj
      integral.Cjapresu.Imppre[1] COLUMN-LABEL "Enero"
      integral.Cjapresu.Imppre[2] COLUMN-LABEL "Febrero"
      integral.Cjapresu.Imppre[3] COLUMN-LABEL "Marzo"
      integral.Cjapresu.Imppre[4] COLUMN-LABEL "Abril"
      integral.Cjapresu.Imppre[5] COLUMN-LABEL "Mayo"
      integral.Cjapresu.Imppre[6] COLUMN-LABEL "Junio"
      integral.Cjapresu.Imppre[7] COLUMN-LABEL "Julio"
      integral.Cjapresu.Imppre[8] COLUMN-LABEL "Agosto"
      integral.Cjapresu.Imppre[9] COLUMN-LABEL "Setiembre"
      integral.Cjapresu.Imppre[10] COLUMN-LABEL "Octubre"
      integral.Cjapresu.Imppre[11] COLUMN-LABEL "Noviembre"
      integral.Cjapresu.Imppre[12] COLUMN-LABEL "Diciembre"
    WITH SIZE 70 BY 6.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Maestro
     s-periodo AT ROW 2 COL 22 COLON-ALIGNED
     BROWSE-9 AT ROW 5 COL 11
     RECT-1 AT ROW 1 COL 1
     "Ingresos" VIEW-AS TEXT
          SIZE 21 BY 1.5 AT ROW 1.5 COL 64
          FONT 11
     RECT-2 AT ROW 8.5 COL 1
     "Egresos" VIEW-AS TEXT
          SIZE 21 BY 1.5 AT ROW 9 COL 63
          FONT 11
     SPACE(7.71) SKIP(7.22)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         TITLE "Consulta de PRESUPUESTO".

 


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN 
       FRAME F-Maestro:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-9
/* Query rebuild information for BROWSE BROWSE-9
     _TblList          = "integral.Cjaconce WHERE integral.Cjapresu <external> ..."
     _Options          = "NO-LOCK"
     _OrdList          = ""
     _JoinCode[1]      = "integral.Cjaconce.CodCia = integral.Cjapresu.CodCia AND integral.Cjaconce.Codflj = integral.Cjapresu.Codflj"
     _Where[1]         = "integral.Cjaconce.CodCia = s-codcia
 AND integral.Cjaconce.Tipflj = TRUE
 "
     _FldNameList[1]   = integral.Cjapresu.Anopre
     _FldLabelList[1]  = "   A¤o"
     _FldNameList[2]   = integral.Cjapresu.Codflj
     _FldNameList[3]   = integral.Cjapresu.Imppre[1]
     _FldLabelList[3]  = "Enero"
     _FldNameList[4]   = integral.Cjapresu.Imppre[2]
     _FldLabelList[4]  = "Febrero"
     _FldNameList[5]   = integral.Cjapresu.Imppre[3]
     _FldLabelList[5]  = "Marzo"
     _FldNameList[6]   = integral.Cjapresu.Imppre[4]
     _FldLabelList[6]  = "Abril"
     _FldNameList[7]   = integral.Cjapresu.Imppre[5]
     _FldLabelList[7]  = "Mayo"
     _FldNameList[8]   = integral.Cjapresu.Imppre[6]
     _FldLabelList[8]  = "Junio"
     _FldNameList[9]   = integral.Cjapresu.Imppre[7]
     _FldLabelList[9]  = "Julio"
     _FldNameList[10]   = integral.Cjapresu.Imppre[8]
     _FldLabelList[10]  = "Agosto"
     _FldNameList[11]   = integral.Cjapresu.Imppre[9]
     _FldLabelList[11]  = "Setiembre"
     _FldNameList[12]   = integral.Cjapresu.Imppre[10]
     _FldLabelList[12]  = "Octubre"
     _FldNameList[13]   = integral.Cjapresu.Imppre[11]
     _FldLabelList[13]  = "Noviembre"
     _FldNameList[14]   = integral.Cjapresu.Imppre[12]
     _FldLabelList[14]  = "Diciembre"
     _Query            is OPENED
*/  /* BROWSE BROWSE-9 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX F-Maestro
/* Query rebuild information for DIALOG-BOX F-Maestro
     _TblList          = "integral.Cjapresu"
     _Options          = "SHARE-LOCK"
     _OrdList          = ""
     _Query            is OPENED
*/  /* DIALOG-BOX F-Maestro */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME s-periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s-periodo F-Maestro
ON LEAVE OF s-periodo IN FRAME F-Maestro /* A¤o Presupuesto */
DO:
  {&OPEN-QUERY-F-Maestro}
  GET FIRST F-Maestro.
  DISPLAY s-periodo 
      WITH FRAME F-Maestro.
  ENABLE RECT-1 s-periodo BROWSE-9 RECT-2 
      WITH FRAME F-Maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-Maestro} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK F-Maestro 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI F-Maestro _DEFAULT-DISABLE
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
  HIDE FRAME F-Maestro.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI F-Maestro _DEFAULT-ENABLE
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

  {&OPEN-QUERY-F-Maestro}
  GET FIRST F-Maestro.
  DISPLAY s-periodo 
      WITH FRAME F-Maestro.
  ENABLE RECT-1 s-periodo BROWSE-9 RECT-2 
      WITH FRAME F-Maestro.
  {&OPEN-BROWSERS-IN-QUERY-F-Maestro}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE BROWSE-NAME
&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME
