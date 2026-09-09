&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
/*
    COBR : Cobranzas
    MVTAS : Movimiento de documento de ventas            
*/

/* Local Variable Definitions ---                                       */

DEFINE SHARED VAR s-codcia AS INT.

FIND FIRST factabla WHERE factabla.codcia = s-codcia AND
                            factabla.tabla = 'REBATE' NO-LOCK NO-ERROR.

IF NOT AVAILABLE factabla THEN DO:
    MESSAGE "Aun no se han creado el/los proceso(s) de Rebate"
        VIEW-AS ALERT-BOX INFORMATION.
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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-procesos COMBO-BOX-motivo ~
FILL-IN-desde FILL-IN-hasta BUTTON-grabar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-titulo COMBO-BOX-procesos ~
COMBO-BOX-motivo FILL-IN-desde FILL-IN-hasta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-grabar 
     LABEL "Grabar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-motivo AS CHARACTER FORMAT "X(256)":U INITIAL "COBR" 
     LABEL "Motivo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Cobranza de documentos","COBR",
                     "Documentos de Campaña","MVTAS",
                     "Documentos otras campañas","MVTAS1"
     DROP-DOWN-LIST
     SIZE 45.57 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-procesos AS CHARACTER FORMAT "X(256)":U 
     LABEL "Procesos" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 45.57 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha : Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-titulo AS CHARACTER FORMAT "X(50)":U INITIAL "  Rango de fechas de Proceso/Motivo" 
     VIEW-AS FILL-IN 
     SIZE 62.72 BY 1.23
     BGCOLOR 9 FGCOLOR 15 FONT 11 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-titulo AT ROW 1.12 COL 2.14 NO-LABEL WIDGET-ID 16
     COMBO-BOX-procesos AT ROW 2.81 COL 12.43 COLON-ALIGNED WIDGET-ID 2
     COMBO-BOX-motivo AT ROW 3.96 COL 12.43 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-desde AT ROW 5.35 COL 22 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-hasta AT ROW 6.58 COL 22 COLON-ALIGNED WIDGET-ID 14
     BUTTON-grabar AT ROW 7.96 COL 43 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 64.86 BY 8.62 WIDGET-ID 100.


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
         TITLE              = "Configuracion - Rango de fecha de cobranza"
         HEIGHT             = 8.62
         WIDTH              = 64.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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
/* SETTINGS FOR FILL-IN FILL-IN-titulo IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Configuracion - Rango de fecha de cobranza */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Configuracion - Rango de fecha de cobranza */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-grabar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-grabar W-Win
ON CHOOSE OF BUTTON-grabar IN FRAME F-Main /* Grabar */
DO:

    DEFINE VAR x-proceso AS CHAR.
    DEFINE VAR x-motivo AS CHAR.

    ASSIGN fill-in-desde fill-in-hasta combo-box-procesos combo-box-motivo.

    IF fill-in-desde = ? OR fill-in-hasta = ? THEN DO:
        MESSAGE "Ingrese la fechas correctamente" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    IF fill-in-desde > fill-in-hasta THEN DO:
        MESSAGE "Rango de fechas estan erradas" VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    x-proceso = combo-box-procesos.
    x-motivo = combo-box-motivo.

    DO WITH FRAME {&FRAME-NAME}:
        IF NOT (TRUE <> (x-proceso > "")) THEN DO:

                MESSAGE 'Seguro de GRABAR ?' VIEW-AS ALERT-BOX QUESTION
                        BUTTONS YES-NO UPDATE rpta AS LOG.
                IF rpta = NO THEN RETURN NO-APPLY.
    
            FIND FIRST rbte_fecha_movimiento WHERE rbte_fecha_movimiento.codcia = s-codcia AND
                                      rbte_fecha_movimiento.codproceso = x-proceso AND 
                                      rbte_fecha_movimiento.codrazon = x-motivo EXCLUSIVE-LOCK NO-ERROR.

            IF NOT AVAILABLE rbte_fecha_movimiento THEN DO:
                CREATE rbte_fecha_movimiento.
                    ASSIGN rbte_fecha_movimiento.codcia = s-codcia
                            rbte_fecha_movimiento.codproceso = x-proceso
                            rbte_fecha_movimiento.codrazon = x-motivo
                            rbte_fecha_movimiento.campo-d[1] = TODAY
                            rbte_fecha_movimiento.campo-c[1] = STRING(TIME,"HH:MM:SS")
                            rbte_fecha_movimiento.campo-c[3] = USERID("DICTDB")
                            .
            END.
            ASSIGN rbte_fecha_movimiento.fchdesde = fill-in-desde
                    rbte_fecha_movimiento.fchhasta = fill-in-hasta 
                    rbte_fecha_movimiento.campo-d[2] = TODAY
                    rbte_fecha_movimiento.campo-c[2] = STRING(TIME,"HH:MM:SS") 
                    rbte_fecha_movimiento.campo-c[4] = USERID("DICTDB") NO-ERROR.

            RELEASE rbte_fecha_movimiento.

            IF ERROR-STATUS:ERROR = YES THEN DO:

                MESSAGE "Hubo problemas a intentar grabar los datos " SKIP
                        "ERROR : " + ERROR-STATUS:GET-MESSAGE(1)
                         VIEW-AS ALERT-BOX INFORMATION.
            END.
            ELSE DO:
                MESSAGE "Se grabar OK los datos" VIEW-AS ALERT-BOX INFORMATION.
            END.
        END.        
        ELSE DO:
            MESSAGE "No ha seleccionado PROCESO" VIEW-AS ALERT-BOX INFORMATION.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-motivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-motivo W-Win
ON VALUE-CHANGED OF COMBO-BOX-motivo IN FRAME F-Main /* Motivo */
DO:

    RUN carga-valores.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-procesos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-procesos W-Win
ON VALUE-CHANGED OF COMBO-BOX-procesos IN FRAME F-Main /* Procesos */
DO:
    RUN carga-valores.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-procesos W-Win 
PROCEDURE carga-procesos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-nombre AS CHAR INIT "".

  DO WITH FRAME {&FRAME-NAME} :

      IF NOT (TRUE <> (COMBO-BOX-procesos:LIST-ITEM-PAIRS > "")) THEN COMBO-BOX-procesos:DELETE(COMBO-BOX-procesos:LIST-ITEM-PAIRS).

      FOR EACH factabla WHERE factabla.codcia = s-codcia AND
                                factabla.tabla = "REBATE" NO-LOCK:
          COMBO-BOX-procesos:ADD-LAST(factabla.nombre, factabla.codigo).
          IF TRUE <> (COMBO-BOX-procesos:SCREEN-VALUE > "") THEN DO:

            x-nombre = factabla.codigo.
            ASSIGN COMBO-BOX-procesos:SCREEN-VALUE = x-nombre.
          END.

      END.

      APPLY 'VALUE-CHANGED':U TO COMBO-BOX-procesos.
      
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-valores W-Win 
PROCEDURE carga-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR x-proceso AS CHAR.
  DEFINE VAR x-motivo AS CHAR.

  DO WITH FRAME {&FRAME-NAME}:
      fill-in-desde:SCREEN-VALUE = ?    /*STRING(TODAY - 90,"99/99/9999")*/.
      fill-in-hasta:SCREEN-VALUE = ?    /*STRING(TODAY,"99/99/9999")*/.

      x-proceso = combo-box-procesos:SCREEN-VALUE.
      x-motivo = combo-box-motivo:SCREEN-VALUE.

      DISABLE button-grabar.

      IF NOT (TRUE <> (x-proceso > "")) THEN DO:
          FIND FIRST rbte_fecha_movimiento WHERE rbte_fecha_movimiento.codcia = s-codcia AND
                                    rbte_fecha_movimiento.codproceso = x-proceso AND
                                    rbte_fecha_movimiento.codrazon = x-motivo NO-LOCK NO-ERROR.
          IF AVAILABLE rbte_fecha_movimiento THEN DO:
                fill-in-desde:SCREEN-VALUE = STRING(rbte_fecha_movimiento.fchdesde,"99/99/9999").
                fill-in-hasta:SCREEN-VALUE = STRING(rbte_fecha_movimiento.fchhasta,"99/99/9999").
          END.
          ENABLE button-grabar.
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
  DISPLAY FILL-IN-titulo COMBO-BOX-procesos COMBO-BOX-motivo FILL-IN-desde 
          FILL-IN-hasta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-procesos COMBO-BOX-motivo FILL-IN-desde FILL-IN-hasta 
         BUTTON-grabar 
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
  COMBO-BOX-procesos:DELETE(COMBO-BOX-procesos:NUM-ITEMS) IN FRAME {&FRAME-NAME}.

  RUN carga-procesos.
  RUN carga-valores.


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

