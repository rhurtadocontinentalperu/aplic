&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER CDOCU FOR CcbCDocu.
DEFINE BUFFER DDocu FOR CcbDDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'N/C'.
DEF VAR s-coddoc-2 AS CHAR INIT 'N/D'.
DEF VAR L-NROSER AS CHAR NO-UNDO.
DEF VAR S-NROSER AS INTEGER.
DEF VAR S-NROSER-2 AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 BUTTON-1 c-NroSer x-Concepto ~
c-NroSer-2 x-Concepto-2 
&Scoped-Define DISPLAYED-OBJECTS c-NroSer FILL-IN-1 x-Mensaje x-Concepto ~
x-NomCon c-NroSer-2 FILL-IN-2 x-Concepto-2 x-NomCon-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-nc-nd-mr-sunat AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bncxhojatrabajo-02 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "GENERAR NOTA DE CREDITO Y/O DEBITO" 
     SIZE 43 BY 1.12.

DEFINE VARIABLE c-NroSer AS CHARACTER FORMAT "X(3)":U 
     LABEL "Nº Serie N/C" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE c-NroSer-2 AS CHARACTER FORMAT "X(3)":U 
     LABEL "Nº Serie N/D" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "XXX-XXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "XXX-XXXXXX":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE x-Concepto AS CHARACTER FORMAT "x(8)" 
     LABEL "Concepto" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81.

DEFINE VARIABLE x-Concepto-2 AS CHARACTER FORMAT "x(8)" 
     LABEL "Concepto" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81.

DEFINE VARIABLE x-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCon AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCon-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 93 BY 2.31.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 93 BY 2.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1.19 COL 96 WIDGET-ID 90
     c-NroSer AT ROW 1.38 COL 13 COLON-ALIGNED WIDGET-ID 72
     FILL-IN-1 AT ROW 1.38 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 74
     x-Mensaje AT ROW 1.38 COL 42 COLON-ALIGNED NO-LABEL WIDGET-ID 86
     x-Concepto AT ROW 2.35 COL 13 COLON-ALIGNED WIDGET-ID 82
     x-NomCon AT ROW 2.35 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 88
     c-NroSer-2 AT ROW 3.69 COL 13 COLON-ALIGNED WIDGET-ID 92
     FILL-IN-2 AT ROW 3.69 COL 21 COLON-ALIGNED NO-LABEL WIDGET-ID 94
     x-Concepto-2 AT ROW 4.65 COL 13 COLON-ALIGNED WIDGET-ID 96
     x-NomCon-2 AT ROW 4.65 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 98
     RECT-1 AT ROW 1.19 COL 2 WIDGET-ID 100
     RECT-2 AT ROW 3.5 COL 2 WIDGET-ID 102
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 139.14 BY 25.15 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: DDocu B "?" ? INTEGRAL CcbDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "GENERACION NOTAS DE CREDITO Y/O DEBITO MESA REDONDA"
         HEIGHT             = 25.15
         WIDTH              = 139.14
         MAX-HEIGHT         = 25.15
         MAX-WIDTH          = 139.14
         VIRTUAL-HEIGHT     = 25.15
         VIRTUAL-WIDTH      = 139.14
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomCon-2 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* GENERACION NOTAS DE CREDITO Y/O DEBITO MESA REDONDA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* GENERACION NOTAS DE CREDITO Y/O DEBITO MESA REDONDA */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* GENERAR NOTA DE CREDITO Y/O DEBITO */
DO:
    ASSIGN
        c-NroSer x-Concepto x-NomCon
        c-NroSer-2 x-Concepto-2 x-NomCon-2.
    MESSAGE 'Se van a generar los comprobantes' SKIP(1)
        'N/C N° de Serie:' c-NroSer SKIP
        'Concepto:' x-Concepto x-NomCon SKIP
        'N/D N° de Serie:' c-NroSer-2 SKIP
        'Concepto:' x-Concepto-2 x-NomCon-2 SKIP
        'Continuamos con la generación?'
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
        UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
    RUN Generar-NC.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-NroSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-NroSer W-Win
ON VALUE-CHANGED OF c-NroSer IN FRAME F-Main /* Nº Serie N/C */
DO:
  FIND Faccorre WHERE codcia = s-codcia
      AND coddoc = s-coddoc
      AND nroser = INTEGER(SELF:SCREEN-VALUE)
      NO-LOCK.
  FILL-IN-1:SCREEN-VALUE = STRING(Faccorre.nroser,'999') + STRING(Faccorre.correlativo, '999999').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-NroSer-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-NroSer-2 W-Win
ON VALUE-CHANGED OF c-NroSer-2 IN FRAME F-Main /* Nº Serie N/D */
DO:
  FIND Faccorre WHERE codcia = s-codcia
      AND coddoc = s-coddoc-2
      AND nroser = INTEGER(SELF:SCREEN-VALUE)
      NO-LOCK.
  FILL-IN-2:SCREEN-VALUE = STRING(Faccorre.nroser,'999') + STRING(Faccorre.correlativo, '999999').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Concepto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Concepto W-Win
ON LEAVE OF x-Concepto IN FRAME F-Main /* Concepto */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia AND 
        CcbTabla.Tabla  = s-coddoc AND 
        CcbTabla.Codigo = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CcbTabla THEN DO:
        MESSAGE 'Concepto no registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    x-NomCon:SCREEN-VALUE = CcbTabla.nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Concepto W-Win
ON LEFT-MOUSE-DBLCLICK OF x-Concepto IN FRAME F-Main /* Concepto */
OR F8 OF x-Concepto
DO:
    ASSIGN
        input-var-1 = s-coddoc
        input-var-2 = ""
        input-var-3 = "".
    RUN LKUP\C-ABOCAR-2 ('Conceptos para Notas de Crédito').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Concepto-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Concepto-2 W-Win
ON LEAVE OF x-Concepto-2 IN FRAME F-Main /* Concepto */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia AND 
        CcbTabla.Tabla  = s-coddoc-2 AND 
        CcbTabla.Codigo = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE CcbTabla THEN DO:
        MESSAGE 'Concepto no registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    x-NomCon-2:SCREEN-VALUE = CcbTabla.nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Concepto-2 W-Win
ON LEFT-MOUSE-DBLCLICK OF x-Concepto-2 IN FRAME F-Main /* Concepto */
OR F8 OF x-Concepto
DO:
    ASSIGN
        input-var-1 = s-coddoc-2
        input-var-2 = ""
        input-var-3 = "".
    RUN LKUP\C-ABOCAR-2 ('Conceptos para Notas de Débito').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'Sunat/b-nc-nd-mr-sunat.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-nc-nd-mr-sunat ).
       RUN set-position IN h_b-nc-nd-mr-sunat ( 5.81 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-nc-nd-mr-sunat ( 6.69 , 125.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'CCB/bncxhojatrabajo-02.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bncxhojatrabajo-02 ).
       RUN set-position IN h_bncxhojatrabajo-02 ( 12.54 , 2.00 ) NO-ERROR.
       RUN set-size IN h_bncxhojatrabajo-02 ( 13.27 , 134.00 ) NO-ERROR.

       /* Links to SmartBrowser h_bncxhojatrabajo-02. */
       RUN add-link IN adm-broker-hdl ( h_b-nc-nd-mr-sunat , 'Record':U , h_bncxhojatrabajo-02 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-nc-nd-mr-sunat ,
             x-NomCon-2:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bncxhojatrabajo-02 ,
             h_b-nc-nd-mr-sunat , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Series W-Win 
PROCEDURE Carga-Series :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* N/C */
  L-NROSER = "".
  FOR EACH Faccorre NO-LOCK WHERE 
           Faccorre.CodCia = S-CODCIA AND
           Faccorre.CodDoc = S-CODDOC AND
           Faccorre.CodDiv = S-CODDIV AND
           Faccorre.FlgEst = YES:
      IF L-NROSER = "" THEN L-NROSER = STRING(Faccorre.NroSer,"999").
      ELSE L-NROSER = L-NROSER + "," + STRING(Faccorre.NroSer,"999").
  END.
  DO WITH FRAME {&FRAME-NAME}:
     C-NroSer:LIST-ITEMS = L-NROSER.
     S-NROSER = INTEGER(ENTRY(1,C-NroSer:LIST-ITEMS)).
     C-NROSER = ENTRY(1,C-NroSer:LIST-ITEMS).
     DISPLAY C-NROSER.
  END.
  /* N/D */
  L-NROSER = "".
  FOR EACH Faccorre NO-LOCK WHERE 
           Faccorre.CodCia = S-CODCIA AND
           Faccorre.CodDoc = S-CODDOC-2 AND
           Faccorre.CodDiv = S-CODDIV AND
           Faccorre.FlgEst = YES:
      IF L-NROSER = "" THEN L-NROSER = STRING(Faccorre.NroSer,"999").
      ELSE L-NROSER = L-NROSER + "," + STRING(Faccorre.NroSer,"999").
  END.
  DO WITH FRAME {&FRAME-NAME}:
     C-NroSer-2:LIST-ITEMS = L-NROSER.
     S-NROSER-2 = INTEGER(ENTRY(1,C-NroSer-2:LIST-ITEMS)).
     C-NROSER-2 = ENTRY(1,C-NroSer-2:LIST-ITEMS).
     DISPLAY C-NROSER-2.
  END.

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
  DISPLAY c-NroSer FILL-IN-1 x-Mensaje x-Concepto x-NomCon c-NroSer-2 FILL-IN-2 
          x-Concepto-2 x-NomCon-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 BUTTON-1 c-NroSer x-Concepto c-NroSer-2 x-Concepto-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-NC W-Win 
PROCEDURE Generar-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** GENERANDO NOTAS DE CREDITO **'.
RUN Genera-NC IN h_b-nc-nd-mr-sunat
    ( INPUT s-coddoc /* CHARACTER */,
      INPUT s-nroser /* INTEGER */,
      INPUT x-Concepto /* CHARACTER */,
      INPUT s-coddoc-2 /* CHARACTER */,
      INPUT s-nroser-2 /* INTEGER */,
      INPUT x-Concepto-2 /* CHARACTER */ )
    NO-ERROR.
IF ERROR-STATUS:ERROR THEN MESSAGE 'Proceso abortado' VIEW-AS ALERT-BOX WARNING.
x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** PROCESO TERMINADO **'.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Carga-Series.
  APPLY 'VALUE-CHANGED' TO c-NroSer IN FRAME {&FRAME-NAME}.
  APPLY 'VALUE-CHANGED' TO c-NroSer-2 IN FRAME {&FRAME-NAME}.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

