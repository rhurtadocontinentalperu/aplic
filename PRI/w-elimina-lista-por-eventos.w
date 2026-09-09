&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME W-Win
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

DEF NEW SHARED VAR lh_handle AS HANDLE.

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
&Scoped-Define ENABLED-OBJECTS RECT-16 RECT-17 BUTTON-10 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-consulta-precios-eventos AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-div-expo-listas AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-lineas-comerciales AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-10 
     LABEL "ELIMINAR LINEAS SELECCIONADAS DE LA LISTA DE PRECIOS" 
     SIZE 65 BY 1.12.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 102 BY 23.15.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 74 BY 23.15.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-10 AT ROW 18.23 COL 106 WIDGET-ID 10
     "Seleccione una lista de precios" VIEW-AS TEXT
          SIZE 27 BY .62 AT ROW 1.27 COL 4 WIDGET-ID 4
          BGCOLOR 9 FGCOLOR 15 FONT 6
     "Seleccione una o mas líneas comerciales" VIEW-AS TEXT
          SIZE 35 BY .62 AT ROW 1.27 COL 106 WIDGET-ID 6
          BGCOLOR 9 FGCOLOR 15 FONT 6
     RECT-16 AT ROW 1.54 COL 2 WIDGET-ID 2
     RECT-17 AT ROW 1.54 COL 104 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 178.72 BY 24.27 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ELIMINAR LISTA DE PRECIOS POR EVENTOS"
         HEIGHT             = 24.27
         WIDTH              = 178.72
         MAX-HEIGHT         = 24.27
         MAX-WIDTH          = 178.72
         VIRTUAL-HEIGHT     = 24.27
         VIRTUAL-WIDTH      = 178.72
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ELIMINAR LISTA DE PRECIOS POR EVENTOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ELIMINAR LISTA DE PRECIOS POR EVENTOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 W-Win
ON CHOOSE OF BUTTON-10 IN FRAME F-Main /* ELIMINAR LINEAS SELECCIONADAS DE LA LISTA DE PRECIOS */
DO:
  DEF VAR x-Lineas AS CHAR NO-UNDO.
  DEF VAR pCodDiv AS CHAR NO-UNDO.

  RUN Captura-Lineas IN h_b-lineas-comerciales ( OUTPUT x-Lineas /* CHARACTER */).
  IF TRUE <> (x-Lineas > '') THEN DO:
      MESSAGE 'Debe seleccionar al menos una línea' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  RUN Devuelve-Lista IN h_b-div-expo-listas ( OUTPUT pCodDiv /* CHARACTER */).
  IF TRUE <> (pCodDiv > '') THEN DO:
      MESSAGE 'No hay una Lista de Precios seleccionada' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  MESSAGE 'Se va a proceder a eliminar:' SKIP
      '- Lista de Precios, descuentos promocionales y por volumen' SKIP
      '- Descuentos x Volumen por División y SubLíneas' SKIP
      '- Descuentos x Volumen por Saldos - SOLO EVENTOS' SKIP(1)
      'Relacionados a la lista' pCodDiv SKIP
      'y a las líneas:' x-Lineas SKIP(1)
      'Continuamos con el proceso?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN Eliminar-Lista (pCodDiv, x-Lineas).
  RUN dispatch IN h_b-lineas-comerciales ('open-query':U).
  RUN Aplicar-Filtro IN h_b-consulta-precios-eventos ( INPUT '' /* CHARACTER */).
  RUN dispatch IN h_b-consulta-precios-eventos ('open-query':U).
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
             INPUT  'aplic/gn/b-div-expo-listas.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-div-expo-listas ).
       RUN set-position IN h_b-div-expo-listas ( 2.08 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-div-expo-listas ( 6.69 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pri/b-lineas-comerciales.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-lineas-comerciales ).
       RUN set-position IN h_b-lineas-comerciales ( 2.08 , 106.00 ) NO-ERROR.
       RUN set-size IN h_b-lineas-comerciales ( 15.88 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pri/b-consulta-precios-eventos.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-consulta-precios-eventos ).
       RUN set-position IN h_b-consulta-precios-eventos ( 9.08 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-consulta-precios-eventos ( 15.08 , 94.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-consulta-precios-eventos. */
       RUN add-link IN adm-broker-hdl ( h_b-div-expo-listas , 'Record':U , h_b-consulta-precios-eventos ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-div-expo-listas ,
             BUTTON-10:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-lineas-comerciales ,
             h_b-div-expo-listas , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-consulta-precios-eventos ,
             h_b-lineas-comerciales , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Filtro W-Win 
PROCEDURE Captura-Filtro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Lineas AS CHAR NO-UNDO.
SESSION:SET-WAIT-STATE('GENERAL').
RUN Captura-Lineas IN h_b-lineas-comerciales ( OUTPUT x-Lineas /* CHARACTER */).
RUN Aplicar-Filtro IN h_b-consulta-precios-eventos ( INPUT x-Lineas /* CHARACTER */).
SESSION:SET-WAIT-STATE('').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Eliminar-Lista W-Win 
PROCEDURE Eliminar-Lista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pLineas AS CHAR.

DEF BUFFER B-FacTabla FOR FacTabla.

DEF VAR k AS INTE NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    FOR EACH VtaListaMay EXCLUSIVE-LOCK WHERE VtaListaMay.CodCia = s-CodCia
        AND VtaListaMay.CodDiv = pCodDiv,
        FIRST Almmmatg OF VtaListaMay NO-LOCK WHERE LOOKUP(Almmmatg.CodFam, pLineas) > 0:
        /* Eliminamos los descuentos promocionales */
        FOR EACH VtaDctoProm EXCLUSIVE-LOCK WHERE VtaDctoProm.CodCia = VtaListaMay.CodCia
            AND VtaDctoProm.CodDiv = VtaListaMay.CodDiv
            AND VtaDctoProm.CodMat = VtaListaMay.CodMat:
            DELETE VtaDctoProm.
        END.
        DELETE VtaListaMay.
    END.
    /* Descuento por volumen por division y linea-sublinea */
    DO k = 1 TO NUM-ENTRIES(pLineas):
        FOR EACH FacTabla EXCLUSIVE-LOCK WHERE FacTabla.codcia = s-codcia
            AND FacTabla.Tabla = "DVXDSF"
            AND FacTabla.Codigo BEGINS TRIM(pCodDiv) + "|" + ENTRY(k,pLineas):
            DELETE FacTabla.
        END.
    END.
    /* Descuento por volumen x lista de precios x saldos */
    FOR EACH FacTabla EXCLUSIVE-LOCK WHERE FacTabla.CodCia = s-CodCia
        AND FacTabla.Codigo BEGINS pCodDiv
        AND FacTabla.Tabla = "EDVXSALDOC":
        FOR EACH B-FacTabla EXCLUSIVE-LOCK WHERE B-FacTabla.codcia = FacTabla.codcia
            AND B-FacTabla.tabla = "EDVXSALDOD"
            AND B-FacTabla.codigo BEGINS FacTabla.codigo,
            FIRST Almmmatg WHERE Almmmatg.CodCia = B-FacTabla.CodCia
            AND Almmmatg.codmat = B-FacTabla.Campo-C[1]
            AND LOOKUP(Almmmatg.CodFam, pLineas) > 0:
            DELETE B-FacTabla.
        END.
        IF NOT CAN-FIND(FIRST B-FacTabla WHERE B-FacTabla.codcia = FacTabla.codcia
                        AND B-FacTabla.tabla = "EDVXSALDOD"
                        AND B-FacTabla.codigo BEGINS FacTabla.codigo
                        NO-LOCK)
            THEN DELETE FacTabla.
    END.
END.
SESSION:SET-WAIT-STATE('').

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
  ENABLE RECT-16 RECT-17 BUTTON-10 
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

