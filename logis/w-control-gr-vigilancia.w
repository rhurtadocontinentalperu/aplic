&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-FacCPedi NO-UNDO LIKE FacCPedi.
DEFINE TEMP-TABLE t-loggrvigilancia NO-UNDO LIKE loggrvigilancia.



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
DEF SHARED VAR s-coddiv AS CHAR.

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

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_f-encendido-apagado AS HANDLE NO-UNDO.
DEFINE VARIABLE h_f-grabar-cancelar AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12g AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-control-gr-vigilancia AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-control-gr-vigilancia-resume AS HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 64.72 BY 23.88
         BGCOLOR 15 FGCOLOR 0  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 3
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-FacCPedi T "?" NO-UNDO INTEGRAL FacCPedi
      TABLE: t-loggrvigilancia T "?" NO-UNDO INTEGRAL loggrvigilancia
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 23.88
         WIDTH              = 64.72
         MAX-HEIGHT         = 23.88
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 23.88
         VIRTUAL-WIDTH      = 80
         MAX-BUTTON         = no
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
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
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

    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/gn/f-encendido-apagado.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-encendido-apagado ).
       RUN set-position IN h_f-encendido-apagado ( 9.08 , 11.00 ) NO-ERROR.
       /* Size in UIB:  ( 5.92 , 44.00 ) */

    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12g.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = Multiple-Records':U ,
             OUTPUT h_p-updv12g ).
       RUN set-position IN h_p-updv12g ( 1.27 , 2.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12g ( 1.42 , 63.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/t-control-gr-vigilancia.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-control-gr-vigilancia ).
       RUN set-position IN h_t-control-gr-vigilancia ( 2.88 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-control-gr-vigilancia ( 18.04 , 63.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/gn/f-grabar-cancelar.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_f-grabar-cancelar ).
       RUN set-position IN h_f-grabar-cancelar ( 21.19 , 5.00 ) NO-ERROR.
       /* Size in UIB:  ( 2.42 , 51.00 ) */

       /* Links to SmartBrowser h_t-control-gr-vigilancia. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12g , 'TableIO':U , h_t-control-gr-vigilancia ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-control-gr-vigilancia ,
             h_p-updv12g , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_f-grabar-cancelar ,
             h_t-control-gr-vigilancia , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/logis/t-control-gr-vigilancia-resumen.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-control-gr-vigilancia-resume ).
       RUN set-position IN h_t-control-gr-vigilancia-resume ( 1.27 , 2.00 ) NO-ERROR.
       RUN set-size IN h_t-control-gr-vigilancia-resume ( 22.35 , 63.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
    END. /* Page 3 */

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
  VIEW FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Informacion W-Win 
PROCEDURE Graba-Informacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH t-loggrvigilancia NO-LOCK:
    CREATE loggrvigilancia.
    BUFFER-COPY t-loggrvigilancia TO loggrvigilancia.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Botones W-Win 
PROCEDURE Procesa-Botones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pParam AS CHAR.

CASE pParam:
    WHEN 'ENCENDIDO' THEN DO:
        RUN select-page('2').
    END.
    WHEN 'APAGADO' THEN DO:
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN NO-APPLY.
    END.
    WHEN 'ACEPTAR' THEN DO:
        MESSAGE 'Confirme grabación' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN.
        /* Consistencia */
        RUN Captura-temporal IN h_t-control-gr-vigilancia ( OUTPUT TABLE t-loggrvigilancia).
        /* Buscamos la O/D y OTR relacionadas */
        DEF VAR x-CodRef AS CHAR NO-UNDO.
        DEF VAR x-NroRef AS CHAR NO-UNDO.
        /* Resumimos las O/D y las OTR */
        EMPTY TEMP-TABLE t-FacCPedi.
        FOR EACH t-loggrvigilancia NO-LOCK BREAK BY t-loggrvigilancia.CodRef BY t-loggrvigilancia.NroRef:
            FIND FIRST t-FacCPedi WHERE t-FacCPedi.coddoc = t-loggrvigilancia.CodRef AND
                t-FacCPedi.nroped = t-loggrvigilancia.NroRef
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE t-FacCPedi THEN DO:
                CREATE t-FacCPedi.
                ASSIGN
                    t-FacCPedi.coddoc = t-loggrvigilancia.CodRef
                    t-FacCPedi.nroped = t-loggrvigilancia.NroRef
                    t-FacCPedi.codcli = t-loggrvigilancia.CodCli.
                /* Contador de Bultos */
                FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = s-codcia AND
                    CcbCBult.CodDoc = t-FacCPedi.coddoc AND
                    CcbCBult.NroDoc = t-FacCPedi.nroped:
                    ASSIGN
                        t-FacCPedi.Libre_d01 = t-FacCPedi.Libre_d01 + CcbCBult.Bultos.
                END.
            END.
            /* Contador de Guias */
            ASSIGN
                t-FacCPedi.Libre_d02 = t-FacCPedi.Libre_d02 + 1.
        END.
        /* Contamos Cantidad de G/R */
        DEF VAR s-coddoc AS CHAR INIT 'G/R' NO-UNDO.
        DEF VAR s-tipmov AS CHAR INIT 'S' NO-UNDO.
        DEF VAR s-codmov AS INT  INIT 03  NO-UNDO.      /* Salida por transferencia */

        FOR EACH t-FacCPedi:
            CASE t-FacCPedi.CodDoc:
                WHEN "O/D" THEN DO:
                    FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia AND
                        Ccbcdocu.coddiv = s-coddiv AND
                        Ccbcdocu.codcli = t-FacCPedi.CodCli AND
                        Ccbcdocu.coddoc = s-coddoc AND
                        Ccbcdocu.flgest <> "A" AND
                        Ccbcdocu.libre_c01 = t-FacCPedi.CodDoc AND
                        Ccbcdocu.libre_c02 = t-FacCPedi.NroPed:
                        ASSIGN
                            t-FacCPedi.Items = t-FacCPedi.Items + 1.
                    END.
                END.
                WHEN "OTR" THEN DO:
                    FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = s-codcia AND
                        Almacen.CodDiv = s-coddiv:
                        FOR EACH almcmov NO-LOCK WHERE almcmov.codcia = s-codcia
                            AND almcmov.codalm = Almacen.codalm
                            AND almcmov.tipmov = s-tipmov 
                            AND almcmov.codmov = s-codmov
/*                             AND almcmov.nroser = INTEGER(SUBSTRING(t-FacCPedi.NroPed,1,3)) */
/*                             AND almcmov.nrodoc = INTEGER(SUBSTRING(t-FacCPedi.NroPed,4))   */
                            AND almcmov.codref = t-FacCPedi.CodDoc
                            AND almcmov.nroref = t-FacCPedi.NroPed
                            AND almcmov.flgest <> 'A':
                            ASSIGN
                                t-FacCPedi.Items = t-FacCPedi.Items + 1.
                        END.
                    END.
                END.
            END CASE.
        END.
        /* Chequeamos contra lo registrado */
        DEF VAR k AS INTE NO-UNDO.
        FOR EACH t-FacCPedi NO-LOCK:
            k = 0.
            FOR EACH t-loggrvigilancia NO-LOCK WHERE t-loggrvigilancia.CodRef = t-FacCPedi.CodDoc AND
                t-loggrvigilancia.NroRef = t-FacCPedi.NroPed:
                k = k + 1.
            END.
            IF t-FacCPedi.Items <> k THEN DO:
                MESSAGE 'Faltan registrar guías para la' t-FacCPedi.CodDoc t-FacCPedi.NroPed
                    t-FacCPedi.Items k
                    VIEW-AS ALERT-BOX ERROR.
                RETURN.
            END.
        END.
        /*MESSAGE 'todo ok'. RETURN.*/
        /* Grabación */
        RUN Graba-Informacion.
        RUN Limpia-Temporal IN h_t-control-gr-vigilancia.
        RUN select-page('3').
        RUN Captura-Temporal IN h_t-control-gr-vigilancia-resume( INPUT TABLE t-FacCPedi).
    END.
    WHEN 'CANCELAR' THEN DO:
        RUN select-page('1').
    END.
END CASE.


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

DEF INPUT PARAMETER pParam AS CHAR NO-UNDO.

CASE pParam:
    WHEN 'Disable-Buttons' THEN DO:
        RUN adm-disable IN h_f-grabar-cancelar.
    END.
    WHEN 'Enable-Buttons' THEN DO:
        RUN adm-enable IN h_f-grabar-cancelar.
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

