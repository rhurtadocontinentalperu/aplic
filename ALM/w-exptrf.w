&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-CMOV NO-UNDO LIKE INTEGRAL.Almcmov.


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
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

DEF FRAME F-Mensaje
    " Procesando informacion "
    " Un momento por favor "
    WITH NO-LABELS CENTERED OVERLAY VIEW-AS DIALOG-BOX WIDTH 30 TITLE "Mensaje".

DEF VAR s-Button-1 AS LOGICAL INIT TRUE.
DEF VAR s-Button-2 AS LOGICAL INIT FALSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-CMOV

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 T-CMOV.NroSer T-CMOV.NroDoc ~
T-CMOV.NroRf1 T-CMOV.FchDoc T-CMOV.Observ 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-2
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH T-CMOV NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 T-CMOV
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 T-CMOV


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 BUTTON-1 COMBO-BOX-AlmDes ~
COMBO-BOX-NroSer COMBO-BOX-CodMov BUTTON-3 FILL-IN-FchDoc-1 ~
FILL-IN-FchDoc-2 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodAlm FILL-IN-AlmOri ~
COMBO-BOX-AlmDes FILL-IN-AlmDes COMBO-BOX-NroSer COMBO-BOX-CodMov ~
FILL-IN-DesMov FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\proces":U
     IMAGE-INSENSITIVE FILE "adeicon\stop-u":U
     LABEL "Button 1" 
     SIZE 11 BY 1.73 TOOLTIP "Generar Temporal".

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "adeicon\rbuild%":U
     IMAGE-INSENSITIVE FILE "adeicon\stop-u":U
     LABEL "Button 2" 
     SIZE 11 BY 1.73 TOOLTIP "Exportar".

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "adeicon\exit-au":U
     LABEL "Button 3" 
     SIZE 11 BY 1.73 TOOLTIP "Salir".

DEFINE VARIABLE COMBO-BOX-AlmDes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen Destino" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-CodMov AS CHARACTER FORMAT "99":U 
     LABEL "Movimiento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-NroSer AS CHARACTER FORMAT "999":U INITIAL "0" 
     LABEL "Nº de Serie" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-AlmDes AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-AlmOri AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen Origen" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesMov AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde el día" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchDoc-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta el día" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 74 BY 6.35.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      T-CMOV SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 DISPLAY
      T-CMOV.NroSer COLUMN-LABEL "Nº de Serie"
      T-CMOV.NroDoc COLUMN-LABEL "Nº del Documento"
      T-CMOV.NroRf1
      T-CMOV.FchDoc COLUMN-LABEL "Fecha del Documento"
      T-CMOV.Observ
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 86 BY 10
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodAlm AT ROW 1.38 COL 14 COLON-ALIGNED
     FILL-IN-AlmOri AT ROW 1.38 COL 22 COLON-ALIGNED NO-LABEL
     BUTTON-1 AT ROW 1.58 COL 77
     COMBO-BOX-AlmDes AT ROW 2.35 COL 14 COLON-ALIGNED
     FILL-IN-AlmDes AT ROW 2.35 COL 22 COLON-ALIGNED NO-LABEL
     COMBO-BOX-NroSer AT ROW 3.31 COL 14 COLON-ALIGNED
     BUTTON-2 AT ROW 3.31 COL 77
     COMBO-BOX-CodMov AT ROW 4.27 COL 14 COLON-ALIGNED
     FILL-IN-DesMov AT ROW 4.27 COL 22 COLON-ALIGNED NO-LABEL
     BUTTON-3 AT ROW 5.04 COL 77
     FILL-IN-FchDoc-1 AT ROW 5.23 COL 14 COLON-ALIGNED
     FILL-IN-FchDoc-2 AT ROW 6.19 COL 14 COLON-ALIGNED
     BROWSE-2 AT ROW 7.54 COL 2
     RECT-1 AT ROW 1 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 88.86 BY 17
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-CMOV T "?" NO-UNDO INTEGRAL Almcmov
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Exportación de Transferencias entre Almacenes"
         HEIGHT             = 17.15
         WIDTH              = 88.86
         MAX-HEIGHT         = 17.31
         MAX-WIDTH          = 98.14
         VIRTUAL-HEIGHT     = 17.31
         VIRTUAL-WIDTH      = 98.14
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   L-To-R                                                               */
/* BROWSE-TAB BROWSE-2 FILL-IN-FchDoc-2 F-Main */
/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-AlmDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-AlmOri IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesMov IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.T-CMOV"
     _FldNameList[1]   > Temp-Tables.T-CMOV.NroSer
"T-CMOV.NroSer" "Nº de Serie" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[2]   > Temp-Tables.T-CMOV.NroDoc
"T-CMOV.NroDoc" "Nº del Documento" ? "integer" ? ? ? ? ? ? no ?
     _FldNameList[3]   = Temp-Tables.T-CMOV.NroRf1
     _FldNameList[4]   > Temp-Tables.T-CMOV.FchDoc
"T-CMOV.FchDoc" "Fecha del Documento" ? "date" ? ? ? ? ? ? no ?
     _FldNameList[5]   = Temp-Tables.T-CMOV.Observ
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Exportación de Transferencias entre Almacenes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Exportación de Transferencias entre Almacenes */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  IF s-Button-1 = YES
  THEN DO:
    VIEW FRAME F-Mensaje.
    FOR EACH T-CMOV:
      DELETE T-CMOV.
    END.
    FOR EACH AlmCMov WHERE almcmov.codcia = s-codcia
            AND almcmov.codalm = INPUT FILL-IN-CodAlm
            AND almcmov.tipmov = "S"
            AND almcmov.codmov = INTEGER(INPUT COMBO-BOX-CodMov)
            AND almcmov.nroser = INTEGER(INPUT COMBO-BOX-NroSer)
            AND almcmov.flgest <> 'A'
            AND almcmov.fchdoc >= INPUT FILL-IN-FchDoc-1
            AND almcmov.fchdoc <= INPUT FILL-IN-FchDoc-2
            NO-LOCK:
        CREATE T-CMOV.
        BUFFER-COPY almcmov TO T-CMOV.
    END.            
    HIDE FRAME F-Mensaje.           
    {&OPEN-QUERY-{&BROWSE-NAME}}
    BUTTON-1:LOAD-IMAGE-UP('adeicon/stop-u').
    ASSIGN
        COMBO-BOX-AlmDes:SENSITIVE = NO
        COMBO-BOX-CodMov:SENSITIVE = NO
        FILL-IN-CodAlm:SENSITIVE = NO
        FILL-IN-FchDoc-1:SENSITIVE = NO
        FILL-IN-FchDoc-2:SENSITIVE = NO
        COMBO-BOX-NroSer:SENSITIVE = NO
        BUTTON-2:SENSITIVE = YES
        s-Button-1 = NO
        s-Button-2 = YES.
  END.
  ELSE DO:
    BUTTON-1:LOAD-IMAGE-UP('img/proces').
    ASSIGN
        COMBO-BOX-AlmDes:SENSITIVE = YES
        COMBO-BOX-CodMov:SENSITIVE = YES
        FILL-IN-CodAlm:SENSITIVE = YES
        FILL-IN-FchDoc-1:SENSITIVE = YES
        FILL-IN-FchDoc-2:SENSITIVE = YES
        COMBO-BOX-NroSer:SENSITIVE = YES
        BUTTON-2:SENSITIVE = NO
        s-Button-1 = YES
        s-Button-2 = NO.
    APPLY 'ENTRY':U TO COMBO-BOX-AlmDes.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN Exporta.
  IF RETURN-VALUE = 'ADM-ERROR':U
  THEN RETURN NO-APPLY.
  ASSIGN
    COMBO-BOX-AlmDes:SENSITIVE = YES
    COMBO-BOX-CodMov:SENSITIVE = YES
    FILL-IN-CodAlm:SENSITIVE = YES
    FILL-IN-FchDoc-1:SENSITIVE = YES
    FILL-IN-FchDoc-2:SENSITIVE = YES
    COMBO-BOX-NroSer:SENSITIVE = YES
    BUTTON-2:SENSITIVE = NO
    s-Button-1 = YES
    s-Button-2 = NO.
  BUTTON-1:LOAD-IMAGE-UP('img/proces').
  APPLY 'ENTRY':U TO COMBO-BOX-AlmDes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-CodAlm FILL-IN-AlmOri COMBO-BOX-AlmDes FILL-IN-AlmDes 
          COMBO-BOX-NroSer COMBO-BOX-CodMov FILL-IN-DesMov FILL-IN-FchDoc-1 
          FILL-IN-FchDoc-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 BUTTON-1 COMBO-BOX-AlmDes COMBO-BOX-NroSer COMBO-BOX-CodMov 
         BUTTON-3 FILL-IN-FchDoc-1 FILL-IN-FchDoc-2 BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta W-Win 
PROCEDURE Exporta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Archivo AS CHAR NO-UNDO.
  
  FIND FIRST T-CMOV NO-ERROR.
  IF NOT AVAILABLE T-CMOV
  THEN DO:
    MESSAGE "No hay transferencias que exportar" VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR':U.
  END.

  /* CABECERA */  
  x-Archivo = 'c:\tmp\talmcmov.txt'.
  OUTPUT TO VALUE(x-Archivo).
  FOR EACH T-CMOV:
    EXPORT T-CMOV.
  END.
  OUTPUT CLOSE.

  /* DETALLE */
  x-Archivo = 'c:\tmp\talmdmov.txt'.
  OUTPUT TO VALUE(x-Archivo).
  FOR EACH T-CMOV,  
        EACH almdmov OF T-CMOV NO-LOCK:
    EXPORT almdmov.
  END.
  OUTPUT CLOSE.

  FOR EACH T-CMOV:
    DELETE T-CMOV.
  END.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  MESSAGE "Proceso Terminado" SKIP
    "Se ha generado el archivo en c:\tmp\talmcmov.txt y c:\tmp\talmdmov.txt"
    VIEW-AS ALERT-BOX WARNING.

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
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        FILL-IN-CodAlm = s-codalm
        FILL-IN-FchDoc-1 = TODAY
        FILL-IN-FchDoc-2 = TODAY.
    FIND almacen WHERE codcia = s-codcia
        AND codalm = s-codalm NO-LOCK.
    FILL-IN-AlmOri = almacen.Descripcion.

    FOR EACH almacen WHERE codcia = s-codcia 
            AND codalm <> FILL-IN-CodAlm NO-LOCK:
        COMBO-BOX-AlmDes:ADD-LAST(almacen.codalm).
    END.
    COMBO-BOX-AlmDes = ENTRY(1,COMBO-BOX-AlmDes:LIST-ITEMS).

    FIND almacen WHERE codcia = s-codcia 
        AND codalm = COMBO-BOX-AlmDes NO-LOCK NO-ERROR.
    FILL-IN-AlmDes   = Almacen.Descripcion.
    FOR EACH almtmovm WHERE almtmovm.codcia = s-codcia
           AND almtmovm.tipmov = 'S'
           AND almtmovm.movtrf = YES NO-LOCK:
        COMBO-BOX-CodMov:ADD-LAST(STRING(almtmovm.codmov, '99')).          
    END.
    COMBO-BOX-CodMov = ENTRY(1, COMBO-BOX-CodMov:LIST-ITEMS).
    FIND almtmovm WHERE almtmovm.codcia = s-codcia
        AND almtmovm.tipmov = 'S'
         AND almtmovm.codmov = INTEGER(COMBO-BOX-CodMov) NO-LOCK NO-ERROR.
    FILL-IN-DesMov   = Almtmovm.Desmov.

    FOR EACH FacCorre WHERE FacCorre.CodCia = S-CODCIA 
            AND FacCorre.CodDoc = "G/R"    
            AND FacCorre.CodDiv = S-CODDIV 
            AND FacCorre.CodAlm = S-CODALM NO-LOCK:
        COMBO-BOX-NroSer:ADD-LAST(STRING(FacCorre.NroSer,"999")).
    END.
    COMBO-BOX-NroSer = ENTRY(1, COMBO-BOX-NroSer:LIST-ITEMS).
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "T-CMOV"}

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


