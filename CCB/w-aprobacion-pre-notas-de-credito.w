&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE PEDI LIKE FacDPedi.



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

/* Parametros de entrada */
DEF INPUT PARAMETER pParametros AS CHAR.
/* 
Sintaxis:
    run ccb/waprobarncotros.r(NC|N|)
    run ccb/waprobarncotros.r(NC|N|REBATE)
    run ccb/waprobarncotros.r(ND|N|)
Parámetros:
    s-CodDoc:   "ND" Nota de Debito "NC" Nota de Credito
    s-FlgCon:   "N"  Otras N/C N/D
    s-TpoFac:   ""   Otras N/C N/D
                "REBATE" N/C
                "ADELANTO" N/C
*/

IF NUM-ENTRIES(pParametros,'|') = 0 THEN RETURN ERROR.
IF LOOKUP(ENTRY(1,pParametros,'|'), 'ND,NC') = 0 THEN RETURN.

DEF NEW SHARED VAR s-CodDoc AS CHAR.
DEF NEW SHARED VAR s-CndCre AS CHAR INIT "N".
DEF NEW SHARED VAR s-TpoFac AS CHAR INIT "".
DEF NEW SHARED VAR s-NroSer AS INT.
DEF NEW SHARED VAR lh_handle AS HANDLE.
DEF NEW SHARED VAR s-Tabla AS CHAR.
DEFINE NEW SHARED VARIABLE s-Sunat-Activo AS LOG.
DEFINE SHARED VAR lFiltrarxDiv AS LOG INIT NO.

DEFINE SHARED VAR s-codcia AS INT.

ASSIGN
    s-CodDoc = ENTRY(1,pParametros,'|').
CASE TRUE:
    WHEN LOOKUP(s-CodDoc, 'NC,ND') > 0 THEN s-CodDoc = SUBSTRING(s-CodDoc,1,1) + '/' + SUBSTRING(s-CodDoc,2).
END CASE.
IF NUM-ENTRIES(pParametros,'|') > 1 THEN ASSIGN s-CndCre = ENTRY(2,pParametros,'|').
IF NUM-ENTRIES(pParametros,'|') > 2 THEN ASSIGN s-TpoFac = ENTRY(3,pParametros,'|').

DEF NEW SHARED VAR s-permiso-anulacion AS LOG.
s-permiso-anulacion = NO.

DEFINE BUFFER y-ccbcdocu FOR ccbcdocu.

DEFINE NEW SHARED VAR x-es-find AS LOG INIT NO.

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
&Scoped-Define ENABLED-OBJECTS BtnDone 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-aprobacion-pre-notas-de-cr-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-divisiones AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-listado-pnc-dif-precio-ind-d AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-pre-ncredito-dif-precio-refe AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vnotacreditodebito AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "APROBAR" 
     SIZE 15 BY 1.54.

DEFINE BUTTON BUTTON-2 
     LABEL "RECHAZAR" 
     SIZE 15 BY 1.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-2 AT ROW 19.85 COL 156
     BUTTON-1 AT ROW 21.96 COL 156
     BtnDone AT ROW 25.23 COL 151 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.04
         SIZE 189.14 BY 28.04
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDI T "NEW SHARED" ? INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 24.92
         WIDTH              = 188.86
         MAX-HEIGHT         = 29.85
         MAX-WIDTH          = 192
         VIRTUAL-HEIGHT     = 29.85
         VIRTUAL-WIDTH      = 192
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON BUTTON-1 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-1:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-2:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* APROBAR */
DO:
    /*
    
    OBSOLETO
    
  MESSAGE '¿Confirma APROBACION?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta-1 AS LOG.
  IF rpta-1 = Yes THEN DO:
    /*RUN Aprobacion IN h_baprobarncndotrosv2.*/
  END.
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* RECHAZAR */
DO:
    /*
    
    
    OBSOLETO
    
  MESSAGE '¿Confirma RECHAZO?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta-1 AS LOG.
  IF rpta-1 = Yes THEN DO:
    /*RUN Rechazo IN h_baprobarncndotrosv2.*/
  END.
  
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
/*{src/adm/template/cntnrwin.i}*/

lh_handle = THIS-PROCEDURE.

CASE s-CodDoc:
    /*
    WHEN "N/C" THEN {&WINDOW-NAME}:TITLE = "APROBACION/RECHAZO DE NOTAS DE CREDITO POR OTROS CONCEPTOS".
    WHEN "N/D" THEN {&WINDOW-NAME}:TITLE = "APROBACION/RECHAZO DE NOTAS DE DEBITO".
    */
    WHEN "N/C" THEN {&WINDOW-NAME}:TITLE = "APROBACION DE PNC DETALLADO POR ARTICULO - JEFES DE LINEA".
    WHEN "N/D" THEN {&WINDOW-NAME}:TITLE = "APROBACION/RECHAZO DE NOTAS DE DEBITO".

END CASE.

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
             INPUT  'aplic/gn/b-divisiones.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-divisiones ).
       RUN set-position IN h_b-divisiones ( 1.00 , 1.14 ) NO-ERROR.
       RUN set-size IN h_b-divisiones ( 5.38 , 50.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/b-aprobacion-pre-notas-de-credito-hdr.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-aprobacion-pre-notas-de-cr-3 ).
       RUN set-position IN h_b-aprobacion-pre-notas-de-cr-3 ( 1.19 , 52.00 ) NO-ERROR.
       RUN set-size IN h_b-aprobacion-pre-notas-de-cr-3 ( 5.19 , 117.57 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/vnotacreditodebito.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_vnotacreditodebito ).
       RUN set-position IN h_vnotacreditodebito ( 6.31 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 8.92 , 115.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/b-pre-ncredito-dif-precio-referencias.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-pre-ncredito-dif-precio-refe ).
       RUN set-position IN h_b-pre-ncredito-dif-precio-refe ( 6.38 , 115.72 ) NO-ERROR.
       RUN set-size IN h_b-pre-ncredito-dif-precio-refe ( 4.46 , 74.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/b-listado-pnc-dif-precio-ind-detalle.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-listado-pnc-dif-precio-ind-d ).
       RUN set-position IN h_b-listado-pnc-dif-precio-ind-d ( 15.19 , 1.29 ) NO-ERROR.
       RUN set-size IN h_b-listado-pnc-dif-precio-ind-d ( 10.58 , 135.29 ) NO-ERROR.

       /* Links to SmartBrowser h_b-aprobacion-pre-notas-de-cr-3. */
       RUN add-link IN adm-broker-hdl ( h_b-divisiones , 'Record':U , h_b-aprobacion-pre-notas-de-cr-3 ).

       /* Links to SmartViewer h_vnotacreditodebito. */
       RUN add-link IN adm-broker-hdl ( h_b-aprobacion-pre-notas-de-cr-3 , 'Record':U , h_vnotacreditodebito ).

       /* Links to SmartBrowser h_b-listado-pnc-dif-precio-ind-d. */
       RUN add-link IN adm-broker-hdl ( h_b-aprobacion-pre-notas-de-cr-3 , 'Record':U , h_b-listado-pnc-dif-precio-ind-d ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-divisiones ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-aprobacion-pre-notas-de-cr-3 ,
             h_b-divisiones , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_vnotacreditodebito ,
             h_b-aprobacion-pre-notas-de-cr-3 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-pre-ncredito-dif-precio-refe ,
             h_vnotacreditodebito , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-listado-pnc-dif-precio-ind-d ,
             h_b-pre-ncredito-dif-precio-refe , 'AFTER':U ).
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
  ENABLE BtnDone 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
  
  RUN refrescar-hdr.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refrescar-hdr W-Win 
PROCEDURE refrescar-hdr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN refrescar IN h_b-aprobacion-pre-notas-de-cr-3.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refrescar-notas-creditos W-Win 
PROCEDURE refrescar-notas-creditos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pxCoddoc AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pxNrodoc AS CHAR NO-UNDO.

DEFINE VAR x-rowid AS ROWID.
DEFINE VAR x-concepto AS CHAR INIT "****".

DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.

x-coddoc = TRIM(pxCoddoc).
x-nrodoc = TRIM(pxNrodoc).

/*
MESSAGE s-codcia SKIP
       x-CodDoc + "XXX" SKIP
        x-NroDOc + "YYYYY".

*/
x-es-find = YES.

FIND FIRST y-ccbcdocu WHERE y-ccbcdocu.codcia = s-codcia AND
                            y-ccbcdocu.coddoc = x-CodDoc AND
                            y-ccbcdocu.nrodoc = x-NroDoc NO-LOCK NO-ERROR.
IF (AVAILABLE y-ccbcdocu) THEN DO:
    /*MESSAGE "SI esta".*/
    x-rowid = ROWID(y-ccbcdocu).
    x-concepto = y-ccbcdocu.codcta.
END.
ELSE DO:
    /*MESSAGE "NO esta".*/
END.

x-es-find = NO.

RUN refrescar IN h_b-pre-ncredito-dif-precio-refe (INPUT x-rowid, INPUT x-concepto).

/*RUN refrescar IN h_vnotacreditodebito (INPUT x-coddoc, INPUT x-nrodoc).*/


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

