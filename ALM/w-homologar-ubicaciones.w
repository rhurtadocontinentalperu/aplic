&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-Almmmate FOR Almmmate.
DEFINE BUFFER c-Almmmate FOR Almmmate.



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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 BUTTON-Homologar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-almacen-principal AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-almacen-secundario AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Homologar 
     LABEL "HOMOLOGAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 88 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 7.27.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 7.27.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Homologar AT ROW 2.88 COL 74 WIDGET-ID 10
     FILL-IN-Mensaje AT ROW 16.88 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     "Seleccione un almacén" VIEW-AS TEXT
          SIZE 20 BY .62 AT ROW 1.27 COL 4 WIDGET-ID 2
          BGCOLOR 9 FGCOLOR 15 FONT 6
     "Seleccione uno o más almacenes" VIEW-AS TEXT
          SIZE 28 BY .62 AT ROW 9.08 COL 4 WIDGET-ID 6
          BGCOLOR 9 FGCOLOR 15 FONT 6
     RECT-1 AT ROW 1.54 COL 3 WIDGET-ID 4
     RECT-2 AT ROW 9.35 COL 3 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 95.57 BY 17 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: b-Almmmate B "?" ? INTEGRAL Almmmate
      TABLE: c-Almmmate B "?" ? INTEGRAL Almmmate
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "HOMOLOGACION DE UBICACIONES"
         HEIGHT             = 17
         WIDTH              = 95.57
         MAX-HEIGHT         = 39.12
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 39.12
         VIRTUAL-WIDTH      = 274.29
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
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* HOMOLOGACION DE UBICACIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* HOMOLOGACION DE UBICACIONES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Homologar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Homologar W-Win
ON CHOOSE OF BUTTON-Homologar IN FRAME F-Main /* HOMOLOGAR */
DO:

  MESSAGE 'Procedemos con la homologación?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  DEF VAR pOrigen AS CHAR NO-UNDO.
  DEF VAR pDestino AS CHAR NO-UNDO.
  DEF VAR pMensaje AS CHAR NO-UNDO.

  RUN Captura-Almacen IN h_b-almacen-principal
    ( OUTPUT pOrigen /* CHARACTER */).
  RUN Captura-Almacenes IN h_b-almacen-secundario
    ( OUTPUT pDestino /* CHARACTER */).

  IF TRUE <> (pOrigen > '') THEN DO:
      MESSAGE 'NO hay un almacén principal seleccionado' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF TRUE <> (pDestino > '') THEN DO:
      MESSAGE 'Debe serleccionar al menos 1 almacén secundario' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  RUN MASTER-TRANSACTION (INPUT pOrigen,
                          INPUT pDestino,
                          OUTPUT pMensaje).
/*   IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                              */
/*       IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR. */
/*   END.                                                                */
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
  RUN dispatch IN h_b-almacen-secundario ('open-query':U).
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
             INPUT  'aplic/alm/b-almacen-principal.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-almacen-principal ).
       RUN set-position IN h_b-almacen-principal ( 1.81 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-almacen-principal ( 6.69 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/b-almacen-secundario.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-almacen-secundario ).
       RUN set-position IN h_b-almacen-secundario ( 9.62 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-almacen-secundario ( 6.69 , 66.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-almacen-secundario. */
       RUN add-link IN adm-broker-hdl ( h_b-almacen-principal , 'Record':U , h_b-almacen-secundario ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-almacen-principal ,
             BUTTON-Homologar:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-almacen-secundario ,
             BUTTON-Homologar:HANDLE IN FRAME F-Main , 'AFTER':U ).
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
  DISPLAY FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 BUTTON-Homologar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION W-Win 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER lUbic AS CHAR.                            
DEF INPUT  PARAMETER lRowid AS ROWID.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR x-CodUbiIni AS CHAR NO-UNDO.
DEF VAR x-CodUbiFin AS CHAR NO-UNDO.


/* Grabo la ZONA en el almacen DESTINO */
{lib/lock-genericov3.i ~
    &Tabla="b-almmmate" ~
    &Condicion="ROWID(b-almmmate) = lRowid" ~
    &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
    &Accion="RETRY" ~
    &Mensaje="YES" ~
    &txtMensaje="pMensaje" ~
    &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    
ASSIGN
    x-CodUbiIni = b-almmmate.CodUbi
    x-CodUbiFin = lUbic.

ASSIGN 
    b-almmmate.codubi = lUbic.

/* 11/08/2022
{alm/i-logubimat-01.i &iAlmmmate="b-almmmate"}
*/

RELEASE b-almmmate.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION W-Win 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pOrigen AS CHAR.
DEF INPUT PARAMETER pDestino AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* Grabar ZONAS DE UN ALMACEN A OTRO Ejm 11 al 11e */
DEFINE VAR lUbic AS CHAR.
DEFINE VAR lAlm AS CHAR.
DEFINE VAR lRowid AS ROWID.

DEFINE VAR lSec AS INT.

DEFINE VAR lAlmWrk AS CHAR.
DEFINE VAR lAlm-a-cambiar AS CHAR.
DEFINE VAR lAlmOrigen AS CHAR.
        
lAlmOrigen = pOrigen.                      /* De que almacen se va jalar la ZONA - ORIGEN */
lAlm-a-cambiar = pDestino.     /* Los almacenes que se va cambiar la ZONA - DESTINO*/

SESSION:SET-WAIT-STATE('GENERAL').
/* Barremos todos los almacenes destino */
REPEAT lSec = 1 TO NUM-ENTRIES(lAlm-a-cambiar,",") : 
    lAlm    = lAlmOrigen.                       /* Almacén Origen */
    lAlmWrk = ENTRY(lSec,lAlm-a-cambiar,",").   /* Almacén Destino */
    /* Barremos todos los articulos del Almacen DESTINO */
    FOR EACH almmmate NO-LOCK WHERE almmmate.codcia = s-codcia 
        AND almmmate.codalm = lAlmWrk:
        lRowid = ROWID(almmmate).           /*  */
        /* Ubico su ZONA en el ORIGEN */
        FIND FIRST c-almmmate WHERE c-almmmate.codcia = almmmate.codcia AND 
            c-almmmate.codalm = lAlm AND
            c-almmmate.codmat = almmmate.codmat NO-LOCK NO-ERROR.
        lUbic = 'G-0'.  /* DEFAULT */
        IF AVAILABLE c-almmmate THEN DO:
            lUbic = c-almmmate.codubi.      /* La nueva ubicacion segun el almacen de ORIGEN */
        END.    
        ELSE DO:
            /* lo dejo en su misma Zona o caso contrario preguntar si lo cambiamos a G-0 */
            lUbic = almmmate.codubi.
        END.
        IF almmmate.codubi = lUbic THEN NEXT.
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
            "Procesando almacén: " + almmmate.codalm + "  " +
            "Artículo: " + almmmate.codmat.
        /* Grabo la ZONA en el almacen DESTINO */
        RUN FIRST-TRANSACTION (INPUT lUbic,
                               INPUT lRowid,
                               OUTPUT pMensaje).
        /* Si devuelve error dejamos que pase al siguiente registro */
    END.
END.
SESSION:SET-WAIT-STATE('').
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

END PROCEDURE.


/*
DEF INPUT PARAMETER pOrigen AS CHAR.
DEF INPUT PARAMETER pDestino AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* Grabar ZONAS DE UN ALMACEN A OTRO Ejm 11 al 11e */
DEFINE BUFFER b-almmmate  FOR almmmate.
DEFINE BUFFER c-almmmate  FOR almmmate.

DEFINE VAR lUbic AS CHAR.
DEFINE VAR lAlm AS CHAR.
DEFINE VAR lRowid AS ROWID.

DEFINE VAR lSec AS INT.

DEFINE VAR lAlmWrk AS CHAR.
DEFINE VAR lAlm-a-cambiar AS CHAR.
DEFINE VAR lAlmOrigen AS CHAR.
        
lAlmOrigen = pOrigen.                      /* De que almacen se va jalar la ZONA - ORIGEN */
lAlm-a-cambiar = pDestino.     /* Los almacenes que se va cambiar la ZONA - DESTINO*/

SESSION:SET-WAIT-STATE('GENERAL').
/* Barremos todos los almacenes destino */
REPEAT lSec = 1 TO NUM-ENTRIES(lAlm-a-cambiar,",") : 
    lAlm    = lAlmOrigen.                       /* Almacén Origen */
    lAlmWrk = ENTRY(lSec,lAlm-a-cambiar,",").   /* Almacén Destino */
    /* Barremos todos los articulos del Almacen DESTINO */
    FOR EACH almmmate NO-LOCK WHERE almmmate.codcia = s-codcia 
        AND almmmate.codalm = lAlmWrk:
        lRowid = ROWID(almmmate).           /*  */
        /* Ubico su ZONA en el ORIGEN */
        FIND FIRST c-almmmate WHERE c-almmmate.codcia = almmmate.codcia AND 
            c-almmmate.codalm = lAlm AND
            c-almmmate.codmat = almmmate.codmat NO-LOCK NO-ERROR.
        lUbic = 'G-0'.  /* DEFAULT */
        IF AVAILABLE c-almmmate THEN DO:
            lUbic = c-almmmate.codubi.      /* La nueva ubicacion segun el almacen de ORIGEN */
        END.    
        ELSE DO:
            /* lo dejo en su misma Zona o caso contrario preguntar si lo cambiamos a G-0 */
            lUbic = almmmate.codubi.
        END.
        IF almmmate.codubi = lUbic THEN NEXT.
        /* Grabo la ZONA en el almacen DESTINO */
        {lib/lock-genericov3.i ~
            &Tabla="b-almmmate" ~
            &Condicion="ROWID(b-almmmate) = lRowid" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="YES" ~
            &txtMensaje="pMensaje" ~
            &TipoError="UNDO, NEXT"}
        ASSIGN 
            b-almmmate.codubi = lUbic.
    END.
END.
SESSION:SET-WAIT-STATE('').

RELEASE b-almmmate.
RELEASE c-almmmate.

*/

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

