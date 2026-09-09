&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATE FOR Almmmate.
DEFINE BUFFER B-MATG FOR Almmmatg.
DEFINE NEW SHARED TEMP-TABLE ITEM LIKE Almdmov.



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
DEFINE SHARED VARIABLE s-codcia AS INT.
DEFINE SHARED VARIABLE s-codalm AS CHAR.

DEFINE NEW SHARED VARIABLE S-TPOMOV AS CHAR INIT 'S'.   /* Salidas */
DEFINE NEW SHARED VARIABLE C-CODMOV AS CHAR INIT '16'.  /* Reclasificación UTILEX */
DEFINE NEW SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE NEW SHARED VARIABLE lh_Handle AS HANDLE.
DEFINE NEW SHARED VARIABLE L-NROSER AS CHAR.    /* Nº Serie Válidos */
DEFINE NEW SHARED VARIABLE s-adm-new-record AS CHAR.
DEFINE NEW SHARED VARIABLE s-FchDoc AS DATE.
DEFINE NEW SHARED VARIABLE S-MOVVAL AS LOGICAL.
DEFINE NEW SHARED VARIABLE s-NroRf3 LIKE Almcmov.NroRf3 INIT " ".   /* Aprovechamos esta llave */

/* CONSISTENCIA DE MOVIMIENTOS */
FIND Almtdocm WHERE Almtdocm.CodCia = s-codcia
    AND Almtdocm.CodAlm = s-codalm
    AND Almtdocm.TipMov = 'I'
    AND Almtdocm.CodMov = INTEGER (c-codmov)
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtdocm THEN DO:
    MESSAGE 'Movimiento de entrada' c-codmov 'NO configurado en el almacén' s-codalm
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
FIND Almtdocm WHERE Almtdocm.CodCia = s-codcia
    AND Almtdocm.CodAlm = s-codalm
    AND Almtdocm.TipMov = 'S'
    AND Almtdocm.CodMov = INTEGER (c-codmov)
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtdocm THEN DO:
    MESSAGE 'Movimiento de entrada' c-codmov 'NO configurado en el almacén' s-codalm
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

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
&Scoped-Define ENABLED-OBJECTS RECT-4 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-reclasificacion-03 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv05 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-alcmov-01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-salida-01 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-reclasificacion-03 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-movmto AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-reclasificacion-03 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "CARGA AUTOMATICA" 
     SIZE 29 BY 1.12.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 100 BY 2.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 15.54 COL 2 WIDGET-ID 4
     RECT-4 AT ROW 3.96 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 126.86 BY 15.88 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 2
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-MATE B "?" ? INTEGRAL Almmmate
      TABLE: B-MATG B "?" ? INTEGRAL Almmmatg
      TABLE: ITEM T "NEW SHARED" ? INTEGRAL Almdmov
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "RECLASIFICACION"
         HEIGHT             = 15.88
         WIDTH              = 126.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 142
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 142
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

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* RECLASIFICACION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* RECLASIFICACION */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* CARGA AUTOMATICA */
DO:
  RUN Carga-Automatica.
  RUN dispatch IN h_t-reclasificacion-03('open-query').
  FIND FIRST ITEM NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ITEM THEN MESSAGE 'No hay productos a reclasificar'
      VIEW-AS ALERT-BOX WARNING.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

lh_handle = THIS-PROCEDURE.

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
             INPUT  'aplic/alm/v-movmto.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-movmto ).
       RUN set-position IN h_v-movmto ( 1.00 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.27 , 58.29 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 2.35 , 23.00 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.35 , 18.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv05.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv05 ).
       RUN set-position IN h_p-updv05 ( 2.35 , 41.00 ) NO-ERROR.
       RUN set-size IN h_p-updv05 ( 1.42 , 57.86 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'v-reclasificacion-03.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-reclasificacion-03 ).
       RUN set-position IN h_v-reclasificacion-03 ( 4.23 , 3.00 ) NO-ERROR.
       /* Size in UIB:  ( 2.42 , 80.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/q-salida-01.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-salida-01 ).
       RUN set-position IN h_q-salida-01 ( 1.00 , 61.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.50 , 7.72 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'q-alcmov-01.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-alcmov-01 ).
       RUN set-position IN h_q-alcmov-01 ( 2.35 , 2.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.12 , 20.29 ) */

       /* Links to SmartViewer h_v-movmto. */
       RUN add-link IN adm-broker-hdl ( h_q-salida-01 , 'Record':U , h_v-movmto ).

       /* Links to SmartViewer h_v-reclasificacion-03. */
       RUN add-link IN adm-broker-hdl ( h_p-updv05 , 'TableIO':U , h_v-reclasificacion-03 ).
       RUN add-link IN adm-broker-hdl ( h_q-alcmov-01 , 'Record':U , h_v-reclasificacion-03 ).

       /* Links to SmartQuery h_q-alcmov-01. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-alcmov-01 ).
       RUN add-link IN adm-broker-hdl ( h_q-salida-01 , 'Record':U , h_q-alcmov-01 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-movmto ,
             BUTTON-1:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             h_v-movmto , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv05 ,
             h_p-navico , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-reclasificacion-03 ,
             h_p-updv05 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-alcmov-01 ,
             BUTTON-1:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'b-reclasificacion-03.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-reclasificacion-03 ).
       RUN set-position IN h_b-reclasificacion-03 ( 7.19 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-reclasificacion-03 ( 8.08 , 100.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-reclasificacion-03 ,
             h_v-reclasificacion-03 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  't-reclasificacion-03.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-reclasificacion-03 ).
       RUN set-position IN h_t-reclasificacion-03 ( 7.19 , 1.00 ) NO-ERROR.
       RUN set-size IN h_t-reclasificacion-03 ( 8.08 , 126.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-reclasificacion-03 ,
             h_v-reclasificacion-03 , 'AFTER':U ).
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Automatica W-Win 
PROCEDURE Carga-Automatica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR N-Itm AS INT.

DO TRANSACTION ON ERROR UNDO, RETURN ON STOP UNDO, RETURN:
    EMPTY TEMP-TABLE ITEM.
    N-Itm = 0.
    FOR EACH AlmMatEqu NO-LOCK WHERE AlmMatEqu.codcia = s-codcia,
        FIRST Almmmatg OF Almmatequ NO-LOCK,
        FIRST B-MATG WHERE B-MATG.codcia = s-codcia
        AND B-MATG.codmat =  AlmMatEqu.codmat2,
        EACH B-MATE NO-LOCK WHERE B-MATE.codcia = s-codcia
        AND B-MATE.codalm = s-codalm
        AND B-MATE.codmat = AlmMatEqu.codmat
        AND B-MATE.stkact < 0:
        /* ************************** DETALLE ************************** */
        /* SALIDAS */
        N-Itm = N-Itm + 1.
        CREATE ITEM.
        ASSIGN 
            ITEM.CodCia = s-CodCia 
            ITEM.CodAlm = s-CodAlm 
            ITEM.TipMov = "S"
            ITEM.CodMov = INTEGER(c-CodMov)
            ITEM.CodMon = 1
            /*ITEM.TpoCmb = Almcmov.TpoCmb*/
            ITEM.codmat = AlmMatEqu.codmat2
            ITEM.codant = AlmMatEqu.codmat   /* OJO */
            ITEM.CanDes = ABSOLUTE(B-MATE.StkAct) *  AlmMatEqu.Factor
            ITEM.CanDev = ABSOLUTE(B-MATE.StkAct)
            ITEM.CodUnd = B-MATG.UndStk
            ITEM.Factor = 1
            ITEM.NroItm = N-Itm
            ITEM.CodAjt = ''.
        ASSIGN
            ITEM.NroItm = N-Itm
            ITEM.CodCia = s-codcia.
    END.
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
  ENABLE RECT-4 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER L-Handle AS CHAR.
CASE L-Handle:
    WHEN "browse" THEN DO:
        IF h_b-reclasificacion-03 <> ? THEN RUN dispatch IN h_b-reclasificacion-03 ('open-query').
        IF h_t-reclasificacion-03 <> ? THEN RUN dispatch IN h_t-reclasificacion-03 ('open-query').
    END.
    WHEN "Carga-Series" THEN RUN Carga-Series IN h_q-salida-01.
    WHEN "Pagina1"  THEN DO:
          RUN select-page(1).
          RUN dispatch IN h_b-reclasificacion-03 ('open-query').
          BUTTON-1:VISIBLE IN FRAME {&FRAME-NAME} = NO.
          BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
      END.
    WHEN "Pagina2"  THEN DO:
          RUN select-page(2).
          RUN dispatch IN h_t-reclasificacion-03 ('open-query').
      END.
    WHEN "Disable" THEN DO:
        RUN dispatch IN h_p-updv05 ('disable').
        RUN dispatch IN h_q-alcmov-01 ('disable').
    END.
    WHEN "Enable" THEN DO:
        RUN dispatch IN h_p-updv05 ('enable').
        RUN dispatch IN h_q-alcmov-01 ('enable').
    END.
    WHEN 'Activa-Boton' THEN DO:
        BUTTON-1:VISIBLE IN FRAME {&FRAME-NAME} = YES.
        BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    END.
END CASE.

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

