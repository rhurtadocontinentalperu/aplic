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
DEFINE SHARED VAR s-acceso-total  AS LOG.   /* Control GRE */

/* Local Variable Definitions ---                                       */

DEFINE NEW SHARED VAR lh_handle AS HANDLE.

DEFINE NEW SHARED VARIABLE s-numero     AS INTEGER.

DEFINE VAR lGRE_ONLINE AS LOG.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-phr BUTTON-refrescar ~
BUTTON-generar-pre-gre BUTTON-Invalidar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-phr FILL-IN-titulo FILL-IN-texto ~
FILL-IN-regs-selecteds FILL-IN-max-old 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-genera-gre-desde-cmpte AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-generar-pre-gre 
     LABEL "Generar la PRE-GRE" 
     SIZE 23 BY 1.12.

DEFINE BUTTON BUTTON-Invalidar 
     LABEL "INVALIDAR REGISTRO(S)" 
     SIZE 26 BY 1.12.

DEFINE BUTTON BUTTON-refrescar 
     LABEL "Refrescar data" 
     SIZE 15 BY .88.

DEFINE VARIABLE FILL-IN-max-old AS CHARACTER FORMAT "X(25)":U 
      VIEW-AS TEXT 
     SIZE 6 BY .96
     BGCOLOR 15 FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE FILL-IN-phr AS CHARACTER FORMAT "X(15)":U 
     LABEL "# PHR" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .96 NO-UNDO.

DEFINE VARIABLE FILL-IN-regs-selecteds AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 34 BY .62
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-texto AS CHARACTER FORMAT "X(50)":U INITIAL "Acepta MULTISELECCION (maximo nn regs)" 
      VIEW-AS TEXT 
     SIZE 37.14 BY .5
     BGCOLOR 15 FGCOLOR 9 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-titulo AS CHARACTER FORMAT "X(256)":U INITIAL "GENERAR PRE-GRE APARTIR DE COMPROBANTES ELECTRONICOS EMITIDOS" 
      VIEW-AS TEXT 
     SIZE 77 BY .85
     FGCOLOR 9 FONT 11 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-phr AT ROW 1.12 COL 86.57 COLON-ALIGNED WIDGET-ID 20
     BUTTON-refrescar AT ROW 1.15 COL 105.72 WIDGET-ID 12
     BUTTON-generar-pre-gre AT ROW 20.65 COL 2.57 WIDGET-ID 6
     BUTTON-Invalidar AT ROW 21 COL 60 WIDGET-ID 18
     FILL-IN-titulo AT ROW 1.19 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     FILL-IN-texto AT ROW 21 COL 90.29 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-regs-selecteds AT ROW 21.69 COL 92.14 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-max-old AT ROW 21.88 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     "del cmpte para generar la PGRE" VIEW-AS TEXT
          SIZE 26 BY .62 AT ROW 21.19 COL 30 WIDGET-ID 26
          FGCOLOR 4 FONT 6
     "Maximo dias de antiguedad" VIEW-AS TEXT
          SIZE 23 BY .62 AT ROW 20.65 COL 31.43 WIDGET-ID 24
          FGCOLOR 4 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 129.57 BY 22.12 WIDGET-ID 100.


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
         TITLE              = "Generacion de GRE apartir de comprobante"
         HEIGHT             = 22.23
         WIDTH              = 129.57
         MAX-HEIGHT         = 24.69
         MAX-WIDTH          = 137.43
         VIRTUAL-HEIGHT     = 24.69
         VIRTUAL-WIDTH      = 137.43
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
/* SETTINGS FOR FILL-IN FILL-IN-max-old IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-regs-selecteds IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-texto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-titulo IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Generacion de GRE apartir de comprobante */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Generacion de GRE apartir de comprobante */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-generar-pre-gre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-generar-pre-gre W-Win
ON CHOOSE OF BUTTON-generar-pre-gre IN FRAME F-Main /* Generar la PRE-GRE */
DO:
  RUN generar-pgre IN h_b-genera-gre-desde-cmpte.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Invalidar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Invalidar W-Win
ON CHOOSE OF BUTTON-Invalidar IN FRAME F-Main /* INVALIDAR REGISTRO(S) */
DO:
  MESSAGE 'Se a proceder a INVALIDAR el/los registro(s) seleccionado(s)' SKIP
      'Continuamos con el proceso?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  DEF VAR pMensaje AS CHAR NO-UNDO.
  RUN Invalidar IN h_b-genera-gre-desde-cmpte ( OUTPUT pMensaje /* CHARACTER */).
  IF RETURN-VALUE = 'ADM-ERROR' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
  RUN dispatch IN h_b-genera-gre-desde-cmpte ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-refrescar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-refrescar W-Win
ON CHOOSE OF BUTTON-refrescar IN FRAME F-Main /* Refrescar data */
DO:
    ASSIGN fill-in-phr.
  RUN refrescar IN h_b-genera-gre-desde-cmpte(fill-in-phr).
  /*RUN dispatch IN h_b-genera-gre-desde-cmpte ('open-query':U).*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE actualizar-estado-sunat W-Win 
PROCEDURE actualizar-estado-sunat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
             INPUT  'aplic/gre/b-genera-gre-desde-cmpte.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-genera-gre-desde-cmpte ).
       RUN set-position IN h_b-genera-gre-desde-cmpte ( 2.15 , 1.72 ) NO-ERROR.
       RUN set-size IN h_b-genera-gre-desde-cmpte ( 18.31 , 128.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-genera-gre-desde-cmpte ,
             BUTTON-refrescar:HANDLE IN FRAME F-Main , 'AFTER':U ).
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
  DISPLAY FILL-IN-phr FILL-IN-titulo FILL-IN-texto FILL-IN-regs-selecteds 
          FILL-IN-max-old 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-phr BUTTON-refrescar BUTTON-generar-pre-gre BUTTON-Invalidar 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  s-numero = 25.    /* Default */
  
  RUN gre/get-correlativos-config-gre("CONFIG-GRE","TOPE-SELECCION","MAX-REGS","",INPUT-OUTPUT s-numero).

  fill-in-texto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Acepta MULTISELECCION (maximo " + STRING(s-numero) + " regs)".

DEFINE VAR cTabla AS CHAR.
DEFINE VAR cLlave_c1 AS CHAR.
DEFINE VAR cLlave_c2 AS CHAR.
DEFINE VAR cLlave_c3 AS CHAR.
DEFINE VAR iDiasPermitidosGenerarPGRE AS INT INIT 5.

cTabla = "CONFIG-GRE".
cLlave_c1 = "PARAMETRO".
cLlave_c2 = "GENERACION_PGRE_DESDE_CMPTE".
cLlave_c3 = "DIAS".

FIND FIRST vtatabla WHERE vtatabla.codcia = 1 AND vtatabla.tabla = cTabla AND
                            vtatabla.llave_c1 = cLlave_c1 AND vtatabla.llave_c2 = cLlave_C2 AND
                            vtatabla.llave_c3 = cLlave_c3 NO-LOCK NO-ERROR.
IF AVAILABLE vtatabla THEN DO:
    iDiasPermitidosGenerarPGRE = vtatabla.valor[1].
END.

fill-in-max-old:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(iDiasPermitidosGenerarPGRE).

RUN refrescar IN h_b-genera-gre-desde-cmpte("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostrar-registros-seleccionados W-Win 
PROCEDURE mostrar-registros-seleccionados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER iRowsSelecteds AS INT.

fill-in-regs-selecteds:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(iRowsSelecteds) + " registro(s) seleccionado(s)".

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

