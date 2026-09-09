&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
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

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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
DEF SHARED VAR s-Tabla AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES VtaCTabla
&Scoped-define FIRST-EXTERNAL-TABLE VtaCTabla


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaCTabla.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS VtaCTabla.Llave VtaCTabla.Estado ~
VtaCTabla.Descripcion VtaCTabla.FechaInicial VtaCTabla.FechaFinal ~
VtaCTabla.Libre_l01 VtaCTabla.Libre_c01 VtaCTabla.Libre_d03 ~
VtaCTabla.Libre_d01 VtaCTabla.Libre_l02 VtaCTabla.Libre_l04 ~
VtaCTabla.Libre_d02 VtaCTabla.Libre_l03 VtaCTabla.Libre_d04 ~
VtaCTabla.Libre_l05 
&Scoped-define ENABLED-TABLES VtaCTabla
&Scoped-define FIRST-ENABLED-TABLE VtaCTabla
&Scoped-Define DISPLAYED-FIELDS VtaCTabla.Llave VtaCTabla.Estado ~
VtaCTabla.UsrCreacion VtaCTabla.FchCreacion VtaCTabla.Descripcion ~
VtaCTabla.UsrModificacion VtaCTabla.FchModificacion VtaCTabla.FechaInicial ~
VtaCTabla.FechaFinal VtaCTabla.Libre_l01 VtaCTabla.Libre_c01 ~
VtaCTabla.Libre_d03 VtaCTabla.Libre_d01 VtaCTabla.Libre_l02 ~
VtaCTabla.Libre_l04 VtaCTabla.Libre_d02 VtaCTabla.Libre_l03 ~
VtaCTabla.Libre_d04 VtaCTabla.Libre_l05 
&Scoped-define DISPLAYED-TABLES VtaCTabla
&Scoped-define FIRST-DISPLAYED-TABLE VtaCTabla


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     VtaCTabla.Llave AT ROW 1.19 COL 13 COLON-ALIGNED WIDGET-ID 12
          LABEL "# Encarte"
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
          BGCOLOR 11 FGCOLOR 0 
     VtaCTabla.Estado AT ROW 1.19 COL 32 NO-LABEL WIDGET-ID 18
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Activa", "A":U,
"Inactiva", "I":U
          SIZE 20 BY .81
          BGCOLOR 11 FGCOLOR 0 
     VtaCTabla.UsrCreacion AT ROW 1.19 COL 71 COLON-ALIGNED WIDGET-ID 14
          LABEL "Creado por"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaCTabla.FchCreacion AT ROW 1.19 COL 84 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     VtaCTabla.Descripcion AT ROW 1.96 COL 13 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
          BGCOLOR 11 FGCOLOR 0 
     VtaCTabla.UsrModificacion AT ROW 1.96 COL 71 COLON-ALIGNED WIDGET-ID 16
          LABEL "Modificado por"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     VtaCTabla.FchModificacion AT ROW 1.96 COL 84 COLON-ALIGNED NO-LABEL WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     VtaCTabla.FechaInicial AT ROW 2.73 COL 13 COLON-ALIGNED WIDGET-ID 10
          LABEL "Válida desde"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     VtaCTabla.FechaFinal AT ROW 2.73 COL 31 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 0 
     VtaCTabla.Libre_l01 AT ROW 2.73 COL 58 WIDGET-ID 26
          LABEL "Aplicamos el mejor descuento"
          VIEW-AS TOGGLE-BOX
          SIZE 29 BY .77
          BGCOLOR 11 FGCOLOR 0 
     VtaCTabla.Libre_c01 AT ROW 2.73 COL 98 COLON-ALIGNED WIDGET-ID 42
          LABEL "Kit Promocional" FORMAT "x(6)"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
          BGCOLOR 14 
     VtaCTabla.Libre_d03 AT ROW 2.73 COL 111 COLON-ALIGNED WIDGET-ID 38
          LABEL "Tope" FORMAT ">9"
          VIEW-AS FILL-IN 
          SIZE 4 BY .81
          BGCOLOR 14 
     VtaCTabla.Libre_d01 AT ROW 3.5 COL 31 COLON-ALIGNED WIDGET-ID 30
          LABEL "% de Descuento General" FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
          BGCOLOR 11 FGCOLOR 0 
     VtaCTabla.Libre_l02 AT ROW 3.5 COL 58 WIDGET-ID 28
          LABEL "Solo para productos SIN promociones"
          VIEW-AS TOGGLE-BOX
          SIZE 29 BY .77
          BGCOLOR 11 FGCOLOR 0 
     VtaCTabla.Libre_l04 AT ROW 4.15 COL 88.43 WIDGET-ID 46
          LABEL "Requiere Codigo Trabajador"
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .77
          BGCOLOR 11 
     VtaCTabla.Libre_d02 AT ROW 4.27 COL 31 COLON-ALIGNED WIDGET-ID 32
          LABEL "Tope de Descuento en S/." FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
          BGCOLOR 11 FGCOLOR 0 
     VtaCTabla.Libre_l03 AT ROW 4.27 COL 58 WIDGET-ID 36
          LABEL "Solicita DNI"
          VIEW-AS TOGGLE-BOX
          SIZE 29 BY .77
          BGCOLOR 11 FGCOLOR 0 
     VtaCTabla.Libre_d04 AT ROW 5.04 COL 31 COLON-ALIGNED WIDGET-ID 48
          LABEL "Mínimo de Venta S/." FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
          BGCOLOR 10 FGCOLOR 0 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     VtaCTabla.Libre_l05 AT ROW 5.04 COL 58 HELP
          "" WIDGET-ID 52
          LABEL "Acumula Descuentos"
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .77
          BGCOLOR 14 FGCOLOR 0 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.VtaCTabla
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 5.42
         WIDTH              = 122.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN VtaCTabla.FchCreacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCTabla.FchModificacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCTabla.FechaInicial IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCTabla.Libre_c01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN VtaCTabla.Libre_d01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN VtaCTabla.Libre_d02 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN VtaCTabla.Libre_d03 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN VtaCTabla.Libre_d04 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR TOGGLE-BOX VtaCTabla.Libre_l01 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX VtaCTabla.Libre_l02 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX VtaCTabla.Libre_l03 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX VtaCTabla.Libre_l04 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX VtaCTabla.Libre_l05 IN FRAME F-Main
   EXP-LABEL EXP-HELP                                                   */
/* SETTINGS FOR FILL-IN VtaCTabla.Llave IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCTabla.UsrCreacion IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN VtaCTabla.UsrModificacion IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME VtaCTabla.Llave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCTabla.Llave V-table-Win
ON LEAVE OF VtaCTabla.Llave IN FRAME F-Main /* # Encarte */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "VtaCTabla"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaCTabla"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          VtaCTabla.Estado:SCREEN-VALUE = "I".
      DISPLAY
          TODAY @ VtaCTabla.FechaFinal 
          TODAY @ VtaCTabla.FechaInicial.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      VtaCTabla.CodCia = s-codcia
      VtaCTabla.Tabla = s-tabla.
  /*VtaCTabla.Llave*/
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = "YES" THEN
      ASSIGN
      VtaCTabla.FchCreacion = TODAY
      VtaCTabla.UsrCreacion = s-user-id
      VtaCTabla.Libre_c02 = "OR"
      VtaCTabla.Libre_c03 = "OR"
      VtaCTabla.Libre_c04 = "OR"
      VtaCTabla.Libre_c05 = "OR".

  ELSE ASSIGN
      VtaCTabla.FchModificacion = TODAY
      VtaCTabla.UsrModificacion = s-user-id.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      VtaCTabla.CodCia = s-codcia
      VtaCTabla.Tabla = s-tabla.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  MESSAGE 'NO se puede anular un ENCARTE' SKIP
      'Marquelo como INACTIVO'
      VIEW-AS ALERT-BOX ERROR.
  RETURN 'ADM-ERROR'.

  FOR EACH Vtadtabla OF Vtactabla:
      DELETE Vtadtabla.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN VtaCTabla.Llave:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "VtaCTabla"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.
  
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME} :
/*     IF DECIMAL(VtaCTabla.Libre_d01:SCREEN-VALUE) = 0 THEN DO:          */
/*         MESSAGE 'Ingrese la cantidad/importe' VIEW-AS ALERT-BOX ERROR. */
/*         APPLY "ENTRY":U TO VtaCTabla.Libre_d01.                        */
/*         RETURN "ADM-ERROR".                                            */
/*     END.                                                               */

    IF INPUT VtaCTabla.FechaInicial > INPUT VtaCTabla.FechaFinal THEN DO:
        MESSAGE "Ingrese correctamente las fechas" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO VtaCTabla.FechaInicial.
        RETURN "ADM-ERROR".
    END.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

