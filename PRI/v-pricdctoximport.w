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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR lh_handle AS HANDLE.

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
&Scoped-define EXTERNAL-TABLES PriCDctoxImport
&Scoped-define FIRST-EXTERNAL-TABLE PriCDctoxImport


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR PriCDctoxImport.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS PriCDctoxImport.Inactivo ~
PriCDctoxImport.Descripcion PriCDctoxImport.Desde PriCDctoxImport.CodMon ~
PriCDctoxImport.Hasta PriCDctoxImport.Importe[1] ~
PriCDctoxImport.Descuento[1] PriCDctoxImport.Importe[2] ~
PriCDctoxImport.Descuento[2] PriCDctoxImport.Importe[3] ~
PriCDctoxImport.Descuento[3] PriCDctoxImport.Importe[4] ~
PriCDctoxImport.Descuento[4] PriCDctoxImport.Importe[5] ~
PriCDctoxImport.Descuento[5] 
&Scoped-define ENABLED-TABLES PriCDctoxImport
&Scoped-define FIRST-ENABLED-TABLE PriCDctoxImport
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 RECT-4 
&Scoped-Define DISPLAYED-FIELDS PriCDctoxImport.Id PriCDctoxImport.Inactivo ~
PriCDctoxImport.FchCreacion PriCDctoxImport.HoraCreacion ~
PriCDctoxImport.UsrCreacion PriCDctoxImport.Descripcion ~
PriCDctoxImport.FchModificacion PriCDctoxImport.HoraModificacion ~
PriCDctoxImport.UsrModificacion PriCDctoxImport.Desde ~
PriCDctoxImport.FchAnulacion PriCDctoxImport.HoraAnulacion ~
PriCDctoxImport.UsrAnulacion PriCDctoxImport.CodMon PriCDctoxImport.Hasta ~
PriCDctoxImport.Importe[1] PriCDctoxImport.Descuento[1] ~
PriCDctoxImport.Importe[2] PriCDctoxImport.Descuento[2] ~
PriCDctoxImport.Importe[3] PriCDctoxImport.Descuento[3] ~
PriCDctoxImport.Importe[4] PriCDctoxImport.Descuento[4] ~
PriCDctoxImport.Importe[5] PriCDctoxImport.Descuento[5] 
&Scoped-define DISPLAYED-TABLES PriCDctoxImport
&Scoped-define FIRST-DISPLAYED-TABLE PriCDctoxImport


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
DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15 BY 4.58.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15 BY 1.08.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13 BY 1.08.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13 BY 4.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     PriCDctoxImport.Id AT ROW 1.27 COL 11 COLON-ALIGNED WIDGET-ID 32
          LABEL "# de Control"
          VIEW-AS FILL-IN 
          SIZE 7.86 BY .81
     PriCDctoxImport.Inactivo AT ROW 1.27 COL 27 NO-LABEL WIDGET-ID 56
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Inactivo", yes,
"Activo", no
          SIZE 19 BY .81
     PriCDctoxImport.FchCreacion AT ROW 1.27 COL 85 COLON-ALIGNED WIDGET-ID 78
          LABEL "Fecha Creación"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     PriCDctoxImport.HoraCreacion AT ROW 1.27 COL 97 COLON-ALIGNED NO-LABEL WIDGET-ID 86
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     PriCDctoxImport.UsrCreacion AT ROW 1.27 COL 108 COLON-ALIGNED NO-LABEL WIDGET-ID 92 FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     PriCDctoxImport.Descripcion AT ROW 2.08 COL 11 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 58.57 BY .81
     PriCDctoxImport.FchModificacion AT ROW 2.08 COL 85 COLON-ALIGNED WIDGET-ID 82
          LABEL "Fecha Modificación"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     PriCDctoxImport.HoraModificacion AT ROW 2.08 COL 97 COLON-ALIGNED NO-LABEL WIDGET-ID 88
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     PriCDctoxImport.UsrModificacion AT ROW 2.08 COL 108 COLON-ALIGNED NO-LABEL WIDGET-ID 94 FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     PriCDctoxImport.Desde AT ROW 2.88 COL 11 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     PriCDctoxImport.FchAnulacion AT ROW 2.88 COL 85 COLON-ALIGNED WIDGET-ID 80
          LABEL "Fecha Inactivación"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     PriCDctoxImport.HoraAnulacion AT ROW 2.88 COL 97 COLON-ALIGNED NO-LABEL WIDGET-ID 84
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     PriCDctoxImport.UsrAnulacion AT ROW 2.88 COL 108 COLON-ALIGNED NO-LABEL WIDGET-ID 90 FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     PriCDctoxImport.CodMon AT ROW 3.15 COL 48 NO-LABEL WIDGET-ID 60
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 14 BY .81
     PriCDctoxImport.Hasta AT ROW 3.69 COL 11 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     PriCDctoxImport.Importe[1] AT ROW 5.31 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     PriCDctoxImport.Descuento[1] AT ROW 5.31 COL 54 COLON-ALIGNED NO-LABEL WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     PriCDctoxImport.Importe[2] AT ROW 6.12 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     PriCDctoxImport.Descuento[2] AT ROW 6.12 COL 54 COLON-ALIGNED NO-LABEL WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     PriCDctoxImport.Importe[3] AT ROW 6.92 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     PriCDctoxImport.Descuento[3] AT ROW 6.92 COL 54 COLON-ALIGNED NO-LABEL WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     PriCDctoxImport.Importe[4] AT ROW 7.73 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     PriCDctoxImport.Descuento[4] AT ROW 7.73 COL 54 COLON-ALIGNED NO-LABEL WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     PriCDctoxImport.Importe[5] AT ROW 8.54 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     PriCDctoxImport.Descuento[5] AT ROW 8.54 COL 54 COLON-ALIGNED NO-LABEL WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     "A partir de" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 4.23 COL 43 WIDGET-ID 64
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 3.31 COL 41 WIDGET-ID 76
     "% Descuento" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 4.23 COL 55 WIDGET-ID 66
     RECT-1 AT ROW 5.04 COL 39 WIDGET-ID 68
     RECT-2 AT ROW 3.96 COL 39 WIDGET-ID 70
     RECT-3 AT ROW 3.96 COL 54 WIDGET-ID 72
     RECT-4 AT ROW 5.04 COL 54 WIDGET-ID 74
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.PriCDctoxImport
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
         HEIGHT             = 10.77
         WIDTH              = 134.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN PriCDctoxImport.FchAnulacion IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PriCDctoxImport.FchCreacion IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PriCDctoxImport.FchModificacion IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PriCDctoxImport.HoraAnulacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN PriCDctoxImport.HoraCreacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN PriCDctoxImport.HoraModificacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN PriCDctoxImport.Id IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN PriCDctoxImport.UsrAnulacion IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN PriCDctoxImport.UsrCreacion IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN PriCDctoxImport.UsrModificacion IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


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
  {src/adm/template/row-list.i "PriCDctoxImport"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "PriCDctoxImport"}

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
  DEF VAR x-Llave AS CHAR NO-UNDO.
  x-Llave = STRING(PriCDctoxImport.CodCia) + '|' +
      STRING(PriCDctoxImport.Id) + '|' +
      STRING(PriCDctoxImport.Inactivo) + '|' +
      STRING(PriCDctoxImport.Desde) + '|' +
      STRING(PriCDctoxImport.Hasta) + '|' +
      STRING(PriCDctoxImport.CodMon) + '|' +
      STRING(PriCDctoxImport.Importe[1]) + '|' +
      STRING(PriCDctoxImport.Descuento[1]) + '|' +
      STRING(PriCDctoxImport.Importe[2]) + '|' +
      STRING(PriCDctoxImport.Descuento[2]) + '|' +
      STRING(PriCDctoxImport.Importe[3]) + '|' +
      STRING(PriCDctoxImport.Descuento[3]) + '|' +
      STRING(PriCDctoxImport.Importe[4]) + '|' +
      STRING(PriCDctoxImport.Descuento[4]) + '|' +
      STRING(PriCDctoxImport.Importe[5]) + '|' +
      STRING(PriCDctoxImport.Descuento[5])
      .

  ASSIGN
      PriCDctoxImport.CodCia = s-codcia.

  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      PriCDctoxImport.FchCreacion = TODAY.
      PriCDctoxImport.HoraCreacion = STRING(TIME,'HH:MM:SS').
      PriCDctoxImport.UsrCreacion = s-user-id.
      RUN lib/logtabla ("PriCDctoxImport", x-Llave, "CREATE").   
  END.
  ELSE DO:
      IF PriCDctoxImport.Inactivo = YES THEN DO:
          PriCDctoxImport.FchAnulacion = TODAY.
          PriCDctoxImport.UsrAnulacion = s-user-id.
          PriCDctoxImport.HoraAnulacion = STRING(TIME,'HH:MM:SS').
          RUN lib/logtabla ("PriCDctoxImport", x-Llave, "DELETE").   
      END.
      ELSE DO:
          PriCDctoxImport.FchModificacion = TODAY.
          PriCDctoxImport.UsrModificacion = s-user-id.
          PriCDctoxImport.HoraModificacion = STRING(TIME,'HH:MM:SS').
          RUN lib/logtabla ("PriCDctoxImport", x-Llave, "UPDATE").   
      END.
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
      PriCDctoxImport.Id = NEXT-VALUE(Pri_Dcto_Import).

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
  MESSAGE 'NO se puede elimiar el regisro' SKIP
      'Debe INACTIVARLO' VIEW-AS ALERT-BOX INFORMATION.
  RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Enable-Browse').

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
  RUN Procesa-Handle IN lh_handle ('Disable-Browse').

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
  {src/adm/template/snd-list.i "PriCDctoxImport"}

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
   /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CAMPO.
         RETURN "ADM-ERROR".   
   
      END.
   */

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

