&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-DOCU FOR CcbCDocu.



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

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-CodFac FILL-IN-NroFac ~
FILL-IN-FchFac FILL-IN-NroGui FILL-IN-FchGui BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodFac FILL-IN-NroFac ~
FILL-IN-FchFac FILL-IN-RefFac FILL-IN-CliFac FILL-IN-CodGui FILL-IN-NroGui ~
FILL-IN-FchGui FILL-IN-RefGui FILL-IN-CliGui FILL-IN-CodAlm FILL-IN-NroSal ~
FILL-IN-FchAlm 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "CORREGIR FACTURA" 
     SIZE 31 BY 1.12.

DEFINE VARIABLE COMBO-BOX-CodFac AS CHARACTER FORMAT "X(256)":U INITIAL "FAC" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "FAC","BOL","TCK" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CliFac AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CliGui AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Salida de Almacén" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodGui AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchAlm AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchFac AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchGui AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroFac AS CHARACTER FORMAT "X(9)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroGui AS CHARACTER FORMAT "X(9)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroSal AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-RefFac AS CHARACTER FORMAT "X(256)":U 
     LABEL "Referencia" 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-RefGui AS CHARACTER FORMAT "X(256)":U 
     LABEL "Referencia" 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     COMBO-BOX-CodFac AT ROW 2.08 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     FILL-IN-NroFac AT ROW 2.08 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     FILL-IN-FchFac AT ROW 2.08 COL 49 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-RefFac AT ROW 3.15 COL 49 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-CliFac AT ROW 4.23 COL 49 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-CodGui AT ROW 6.38 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     FILL-IN-NroGui AT ROW 6.38 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-FchGui AT ROW 6.38 COL 49 COLON-ALIGNED WIDGET-ID 26
     FILL-IN-RefGui AT ROW 7.46 COL 49 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-CliGui AT ROW 8.54 COL 49 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-CodAlm AT ROW 9.62 COL 49 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-NroSal AT ROW 9.62 COL 57 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-FchAlm AT ROW 9.62 COL 72 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     BUTTON-1 AT ROW 10.69 COL 11 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 102.72 BY 12 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: B-DOCU B "?" ? INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "CORREGIR FECHA DE FACTURA (SOLO PARA SISTEMAS)"
         HEIGHT             = 12
         WIDTH              = 102.72
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
/* SETTINGS FOR FILL-IN FILL-IN-CliFac IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CliGui IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodAlm IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodGui IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchAlm IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroSal IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-RefFac IN FRAME fMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-RefGui IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* CORREGIR FECHA DE FACTURA (SOLO PARA SISTEMAS) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* CORREGIR FECHA DE FACTURA (SOLO PARA SISTEMAS) */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 wWin
ON CHOOSE OF BUTTON-1 IN FRAME fMain /* CORREGIR FACTURA */
DO:
    MESSAGE 'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
    ASSIGN
        COMBO-BOX-CodFac 
        FILL-IN-CodGui 
        FILL-IN-FchFac 
        FILL-IN-FchGui 
        FILL-IN-NroFac 
        FILL-IN-NroGui.
    FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
      AND Ccbcdocu.coddoc = COMBO-BOX-CodFac
      AND Ccbcdocu.nrodoc = FILL-IN-NroFac 
      EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE Ccbcdocu THEN DO:
        ASSIGN
            Ccbcdocu.fchdoc = FILL-IN-FchFac.
        FOR EACH ccbddocu OF ccbcdocu:
            ccbddocu.fchdoc = ccbcdocu.fchdoc.
        END.
        MESSAGE 'FACTURA OK' VIEW-AS ALERT-BOX INFORMATION.
        FIND B-DOCU WHERE B-DOCU.codcia = s-codcia
            AND B-DOCU.coddoc = FILL-IN-CodGui 
            AND B-DOCU.nrodoc = FILL-IN-NroGui
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE B-DOCU THEN DO:
            ASSIGN
                B-DOCU.fchdoc = FILL-IN-FchGui.
            FOR EACH ccbddocu OF B-DOCU:
                ccbddocu.fchdoc = B-DOCU.fchdoc.
            END.
            MESSAGE 'GUIA REMISION OK' VIEW-AS ALERT-BOX INFORMATION.
            FIND Almcmov WHERE Almcmov.codcia = s-codcia
                AND Almcmov.codalm = B-DOCU.codalm
                AND Almcmov.tipmov = 'S'
                AND Almcmov.codmov = 02
                AND Almcmov.nrodoc = INTEGER(B-DOCU.nrosal)
                EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE Almcmov THEN DO:
                ASSIGN
                    Almcmov.fchdoc = FILL-IN-FchGui.
                FOR EACH almdmov OF almcmov:
                    almdmov.fchdoc = almcmov.fchdoc.
                END.
                MESSAGE 'KARDEX OK' VIEW-AS ALERT-BOX INFORMATION.
            END.
        END.
   END.
   RELEASE Ccbcdocu.
   RELEASE B-DOCU.
   RELEASE Almcmov.
   RELEASE Almdmov.
   RELEASE Ccbddocu.
   DISPLAY
       "" @ FILL-IN-FchFac 
       "" @ FILL-IN-FchGui 
       "" @ FILL-IN-NroFac 
       "" @ FILL-IN-NroGui
       "" @ FILL-IN-CliFac
       "" @ FILL-IN-CliGui
       "" @ FILL-IN-NroSal
       "" @ FILL-IN-FchAlm
       "" @ FILL-IN-RefFac
       "" @ FILL-IN-RefGui
       WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FchFac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FchFac wWin
ON LEAVE OF FILL-IN-FchFac IN FRAME fMain /* Fecha */
DO:
  DISPLAY DATE (SELF:SCREEN-VALUE) @  FILL-IN-FchGui WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroFac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroFac wWin
ON LEAVE OF FILL-IN-NroFac IN FRAME fMain
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
      AND Ccbcdocu.coddoc = COMBO-BOX-CodFac:SCREEN-VALUE
      AND Ccbcdocu.nrodoc = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE Ccbcdocu THEN DO:
      DISPLAY
          Ccbcdocu.fchdoc @ FILL-IN-FchFac
          Ccbcdocu.codref + ' ' + Ccbcdocu.nroref @ FILL-IN-RefFac
          Ccbcdocu.nomcli @ FILL-IN-CliFac
          WITH FRAME {&FRAME-NAME}.
      FIND B-DOCU WHERE B-DOCU.codcia = s-codcia
          AND B-DOCU.coddoc = Ccbcdocu.codref
          AND B-DOCU.nrodoc = ENTRY(1, Ccbcdocu.nroref)
          NO-LOCK NO-ERROR.
      IF AVAILABLE B-DOCU THEN DO:
          DISPLAY
              B-DOCU.coddoc @ FILL-IN-CodGui
              B-DOCU.nrodoc @ FILL-IN-NroGui
              B-DOCU.fchdoc @ FILL-IN-FchGui
              B-DOCU.codref + ' ' + B-DOCU.nroref @ FILL-IN-RefGui
              B-DOCU.nomcli @ FILL-IN-CliGui
              B-DOCU.codalm @ FILL-IN-CodAlm
              B-DOCU.nrosal @ FILL-IN-NroSal
              WITH FRAME {&FRAME-NAME}.
          FIND Almcmov WHERE Almcmov.codcia = s-codcia
              AND Almcmov.codalm = B-DOCU.codalm
              AND Almcmov.tipmov = 'S'
              AND Almcmov.codmov = 02
              AND Almcmov.nrodoc = INTEGER(B-DOCU.nrosal)
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almcmov THEN
              DISPLAY Almcmov.fchdoc @ FILL-IN-FchAlm WITH FRAME {&FRAME-NAME}.
      END.
  END.
  ELSE DO: 
      MESSAGE 'Doc. NO registrado' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroGui
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroGui wWin
ON LEAVE OF FILL-IN-NroGui IN FRAME fMain
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND B-DOCU WHERE B-DOCU.codcia = s-codcia
        AND B-DOCU.coddoc = FILL-IN-CodGui:SCREEN-VALUE
        AND B-DOCU.nrodoc = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE B-DOCU THEN DO:
        DISPLAY
            B-DOCU.nrodoc @ FILL-IN-NroGui
            B-DOCU.fchdoc WHEN (INPUT FILL-IN-FchGui = ?) @ FILL-IN-FchGui
            B-DOCU.codref + ' ' + B-DOCU.nroref @ FILL-IN-RefGui
            B-DOCU.nomcli @ FILL-IN-CliGui
            B-DOCU.codalm @ FILL-IN-CodAlm
            B-DOCU.nrosal @ FILL-IN-NroSal
            WITH FRAME {&FRAME-NAME}.
        FIND Almcmov WHERE Almcmov.codcia = s-codcia
            AND Almcmov.codalm = B-DOCU.codalm
            AND Almcmov.tipmov = 'S'
            AND Almcmov.codmov = 02
            AND Almcmov.nrodoc = INTEGER(B-DOCU.nrosal)
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almcmov THEN
            DISPLAY Almcmov.fchdoc @ FILL-IN-FchAlm WITH FRAME {&FRAME-NAME}.
    END.
    ELSE DO:
        MESSAGE 'Documento NO registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY COMBO-BOX-CodFac FILL-IN-NroFac FILL-IN-FchFac FILL-IN-RefFac 
          FILL-IN-CliFac FILL-IN-CodGui FILL-IN-NroGui FILL-IN-FchGui 
          FILL-IN-RefGui FILL-IN-CliGui FILL-IN-CodAlm FILL-IN-NroSal 
          FILL-IN-FchAlm 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE COMBO-BOX-CodFac FILL-IN-NroFac FILL-IN-FchFac FILL-IN-NroGui 
         FILL-IN-FchGui BUTTON-1 
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

