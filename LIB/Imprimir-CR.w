&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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

/*
DEFINE INPUT PARAMETER pcFile AS CHARACTER NO-UNDO.        /* Reporte */
DEFINE INPUT PARAMETER pcParam AS CHARACTER NO-UNDO.       /* Parámtros del reporte */

DEFINE INPUT PARAMETER pcServername AS CHARACTER NO-UNDO.  /* Servicio ODBC */
DEFINE INPUT PARAMETER pcDbname AS CHARACTER NO-UNDO.      /* Nombre B.D. de la base */
DEFINE INPUT PARAMETER pcUserid AS CHARACTER NO-UNDO.      /* Usuario */
DEFINE INPUT PARAMETER pcPassword AS CHARACTER NO-UNDO.    /* Password */
*/

DEFINE VARIABLE pcFile AS CHARACTER NO-UNDO.        /* Reporte */
DEFINE VARIABLE pcParam AS CHARACTER NO-UNDO.       /* Parámtros del reporte */
DEFINE VARIABLE pcServername AS CHARACTER NO-UNDO.  /* Servicio ODBC */
DEFINE VARIABLE pcDbname AS CHARACTER NO-UNDO.      /* Nombre B.D. de la base */
DEFINE VARIABLE pcUserid AS CHARACTER NO-UNDO.      /* Usuario */
DEFINE VARIABLE pcPassword AS CHARACTER NO-UNDO.    /* Password */

DEFINE VARIABLE crApplication AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE crReport AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE crParams AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE crParflds AS COM-HANDLE NO-UNDO.

DEFINE VARIABLE iNbrParam AS INTEGER NO-UNDO.
DEFINE VARIABLE fDate AS DATE NO-UNDO.
DEFINE VARIABLE iInd AS INTEGER NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Borrar */
pcFile = "D:\sie\clientes.rpt".
pcParam = "11|11".
pcServername = "integral".
pcDbname = "integral".
pcUserid = "sysprogress".
pcPassword = "sysprogress".
/* Borrar */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_Cancel Btn_OK RECT-8 IMAGE-1 ~
RADIO-salida 
&Scoped-Define DISPLAYED-OBJECTS RADIO-salida 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY  NO-FOCUS
     LABEL "&Cancelar" 
     SIZE 12 BY .88
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO  NO-FOCUS
     LABEL "&Aceptar" 
     SIZE 12 BY .88
     BGCOLOR 8 .

DEFINE IMAGE IMAGE-1
     FILENAME "img\continental":U
     SIZE 48 BY 3.65.

DEFINE VARIABLE RADIO-salida AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Pantalla", 1,
"Impresora", 2,
"Exportar a archivo", 3
     SIZE 16 BY 2.42 NO-UNDO.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47 BY 3.23.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Btn_Cancel AT ROW 6.65 COL 31
     Btn_OK AT ROW 5.58 COL 31
     RADIO-salida AT ROW 5.04 COL 7 NO-LABEL
     " Salida a:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 4.5 COL 4
     RECT-8 AT ROW 4.77 COL 2
     IMAGE-1 AT ROW 1 COL 1
     SPACE(0.85) SKIP(3.80)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 FONT 4
         TITLE "Imprimir"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON GO OF FRAME D-Dialog /* Imprimir */
DO:

    iNbrParam = NUM-ENTRIES(pcParam,"|":U).

    crloop:
    DO:

        /* Verifica si el archivo .rpt existe */
        FILE-INFO:FILE-NAME = pcFile.
        IF FILE-INFO:FULL-PATHNAME = "" OR
            FILE-INFO:FULL-PATHNAME = ? THEN DO:
            MESSAGE
                "Archivo" pcFile "no encontrado"
                VIEW-AS ALERT-BOX ERROR.
            LEAVE crloop.
        END.

        /* Ejecuta Crystal Report */
        CREATE "CrystalRuntime.Application" crApplication NO-ERROR.
        IF ERROR-STATUS:ERROR = TRUE THEN DO:
            MESSAGE
                "Crystal report no disponible"
                VIEW-AS ALERT-BOX ERROR.
            LEAVE crloop.
        END.

        CREATE "CrystalRuntime.Report" crReport NO-ERROR.
        IF ERROR-STATUS:ERROR = TRUE THEN DO:
            MESSAGE
                "Crystal report no disponible"
                VIEW-AS ALERT-BOX ERROR.
            LEAVE crloop.
        END.

        crReport = crApplication:OpenReport(pcFile,1) NO-ERROR.
        IF ERROR-STATUS:ERROR = TRUE THEN DO:
            MESSAGE
                "Crystal report no puede abrir el fichero:" SKIP
                pcFile
                VIEW-AS ALERT-BOX ERROR.
            LEAVE crloop.
        END.

        /* Conexion */
        DO iInd = 1 TO crReport:DATABASE:tables:COUNT:
            crReport:DATABASE:Tables(iInd):SetLogOnInfo(
                pcServername,
                pcDbname,
                pcUserid,
                pcPassword).
        END.

        /* Initialisation des paramètres */
        crParams = crReport:ParameterFields.

        /* Si existen parámatros */
        IF crParams:COUNT > 0 THEN DO:

            /* Compara parámetros definidos */
            IF iNbrParam <> crParams:COUNT THEN DO:
                MESSAGE
                    "Número de parámetros no coincidentes"
                    VIEW-AS ALERT-BOX ERROR.
                LEAVE crloop.
            END.

            /* Deshabilita Prompt de Parámatros */
            crReport:EnableParameterPrompting = FALSE.


            /* Blanquea los Parámatros */
            DO iInd = 1 TO crParams:COUNT:
                crParflds = crParams:ITEM(iInd).
                NO-RETURN-VALUE crParflds:ClearCurrentValueAndRange().
            END.

            DO iInd = 1 TO iNbrParam:
                crParflds = crParams:ITEM(iInd).
                ASSIGN fDate = DATE(ENTRY(iInd,pcParam,"|":U)) NO-ERROR.
                IF ERROR-STATUS:ERROR = FALSE AND
                    INDEX(ENTRY(iInd,pcParam,"|":U),"/":U)<> 0 THEN DO:
                    NO-RETURN-VALUE crParflds:AddCurrentValue(DATE(ENTRY(iInd,pcParam,"|":U))).
                END.
                ELSE DO:
                    NO-RETURN-VALUE crParflds:AddCurrentValue(ENTRY(iInd,pcParam,"|":U)).
                END.
            END.

        END.

        CASE RADIO-salida:
            WHEN 1 THEN RUN lib/wviewCR(crReport).  /* Pantalla */
            WHEN 2 THEN crReport:PrintOut().        /* Impresora */
            WHEN 3 THEN crReport:EXPORT().          /* Exporta a archivos */
        END CASE.
  
    END.

    RELEASE OBJECT crApplication NO-ERROR.
    RELEASE OBJECT crReport NO-ERROR.
    RELEASE OBJECT crParams NO-ERROR.
    RELEASE OBJECT crParflds NO-ERROR.

    ASSIGN
        crApplication = ?
        crReport = ?
        crParams = ?
        crParflds = ?.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Imprimir */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:

    ASSIGN RADIO-salida.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY RADIO-salida 
      WITH FRAME D-Dialog.
  ENABLE Btn_Cancel Btn_OK RECT-8 IMAGE-1 RADIO-salida 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

