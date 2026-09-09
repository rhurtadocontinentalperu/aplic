&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}
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

/* Ejemplo de pasar un temporal como parámetro
DEFINE TEMP-TABLE Reporte NO-UNDO
    FIELDS CodCia LIKE CcbCDocu.CodCia
    FIELDS CodDoc LIKE CcbCDocu.CodDoc
    FIELDS NroDoc LIKE CcbCDocu.Nrodoc.

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR Reporte.
* */

DEF OUTPUT PARAMETER pOptions AS CHAR.
DEF OUTPUT PARAMETER pArchivo AS CHAR.

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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-FileType Btn-archivos Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-FileType RADIO-SET-Grid ~
RADIO-SET-Labels FILL-IN-archivo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-archivos 
     IMAGE-UP FILE "img\pvpegar":U
     LABEL "&Arc..." 
     SIZE 3.57 BY 1.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "IMG/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.62.

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "IMG/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE FILL-IN-archivo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Archivo" 
     VIEW-AS FILL-IN 
     SIZE 67 BY .81
     BGCOLOR 15 FGCOLOR 0 FONT 2 NO-UNDO.

DEFINE VARIABLE RADIO-SET-FileType AS CHARACTER INITIAL "TXT" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "TXT", "TXT"
     SIZE 10 BY 1.08 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Grid AS CHARACTER INITIAL "ver" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "No", "No",
"Horizontal", "hor",
"Vertical", "ver",
"Ambos", "true"
     SIZE 39 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Labels AS CHARACTER INITIAL "yes" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Si", "yes",
"No", "false"
     SIZE 14 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     RADIO-SET-FileType AT ROW 1.54 COL 24 NO-LABEL WIDGET-ID 8
     RADIO-SET-Grid AT ROW 2.62 COL 57 NO-LABEL WIDGET-ID 14
     RADIO-SET-Labels AT ROW 3.42 COL 57 NO-LABEL WIDGET-ID 32
     FILL-IN-archivo AT ROW 5.31 COL 22 COLON-ALIGNED WIDGET-ID 40
     Btn-archivos AT ROW 5.31 COL 91 WIDGET-ID 38
     Btn_OK AT ROW 6.92 COL 70
     Btn_Cancel AT ROW 6.92 COL 85
     "Etiquetas:" VIEW-AS TEXT
          SIZE 9 BY .62 AT ROW 3.42 COL 48 WIDGET-ID 36
     "Seleccione el formato:" VIEW-AS TEXT
          SIZE 20 BY .62 AT ROW 1.54 COL 4 WIDGET-ID 12
     "Cuadrícula:" VIEW-AS TEXT
          SIZE 10 BY .62 AT ROW 2.62 COL 47 WIDGET-ID 20
     "Opciones solo para formato TXT" VIEW-AS TEXT
          SIZE 29 BY .62 AT ROW 1.54 COL 45 WIDGET-ID 22
          BGCOLOR 1 FGCOLOR 15 
     SPACE(27.13) SKIP(6.83)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "EXPORTAR A FORMATO TEXTO"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
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
   FRAME-NAME                                                           */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-archivo IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET-Grid IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET-Labels IN FRAME gDialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* EXPORTAR A FORMATO TEXTO */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-archivos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-archivos gDialog
ON CHOOSE OF Btn-archivos IN FRAME gDialog /* Arc... */
DO:
    ASSIGN RADIO-SET-FileType.
    DEF VAR OKpressed AS LOG.

    SYSTEM-DIALOG GET-FILE FILL-IN-archivo
        FILTERS "Archivo (":U + LC(RADIO-SET-FileType) + ")":U "*.":U + LC(RADIO-SET-FileType)
        ASK-OVERWRITE 
        CREATE-TEST-FILE
        DEFAULT-EXTENSION LC(".":U + RADIO-SET-FileType)
        /*RETURN-TO-START-DIR */
        SAVE-AS
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = TRUE THEN FILL-IN-archivo:SCREEN-VALUE = FILL-IN-archivo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel gDialog
ON CHOOSE OF Btn_Cancel IN FRAME gDialog /* Cancel */
DO:
  pOptions = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* OK */
DO:
  ASSIGN
       RADIO-SET-FileType RADIO-SET-Grid RADIO-SET-Labels FILL-IN-archivo.
  IF FILL-IN-archivo = '' THEN DO:
      MESSAGE 'Debe definir el archivo de salida' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  ASSIGN
      pOptions = "FileType:" + TRIM(RADIO-SET-FileType) + CHR(1) + ~
            "Grid:" + TRIM(RADIO-SET-Grid) + CHR(1) + ~ 
            "ExcelAlert:false" + CHR(1) + ~
            "ExcelVisible:false" + CHR(1) + ~
            "Labels:" + TRIM(RADIO-SET-Labels)
      pArchivo = FILL-IN-archivo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-archivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-archivo gDialog
ON ANY-PRINTABLE OF FILL-IN-archivo IN FRAME gDialog /* Archivo */
DO:
    IF R-INDEX( "abcdefghijklmn¤opqrstuvwxyz1234567890:./\\" ,
        CAPS( CHR( LASTKEY ) ) ) = 0 THEN DO:  
        BELL.
        RETURN NO-APPLY.
    END.
    APPLY CAPS(CHR(LASTKEY)).
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-FileType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-FileType gDialog
ON VALUE-CHANGED OF RADIO-SET-FileType IN FRAME gDialog
DO:
  FILL-IN-archivo:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY RADIO-SET-FileType RADIO-SET-Grid RADIO-SET-Labels FILL-IN-archivo 
      WITH FRAME gDialog.
  ENABLE RADIO-SET-FileType Btn-archivos Btn_OK Btn_Cancel 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

