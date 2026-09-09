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

DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR pv-codcia AS INT.

DEF SHARED VAR s-Create-Record AS LOG.
DEF SHARED VAR s-Write-Record AS LOG.
DEF SHARED VAR s-Delete-Record AS LOG.
DEF SHARED VAR s-Confirm-Record AS LOG.

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
&Scoped-define EXTERNAL-TABLES gn-prov
&Scoped-define FIRST-EXTERNAL-TABLE gn-prov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gn-prov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gn-prov.Ruc gn-prov.Flgsit gn-prov.Persona ~
gn-prov.CodPro gn-prov.TpoPro gn-prov.ApePat gn-prov.ApeMat gn-prov.Nombre ~
gn-prov.Telfnos[1] gn-prov.NomPro gn-prov.LocPro gn-prov.Telfnos[2] ~
gn-prov.clfpro gn-prov.E-Mail gn-prov.Telfnos[3] gn-prov.Girpro ~
gn-prov.FaxPro gn-prov.CndCmp gn-prov.Libre_c05 
&Scoped-define ENABLED-TABLES gn-prov
&Scoped-define FIRST-ENABLED-TABLE gn-prov
&Scoped-Define DISPLAYED-FIELDS gn-prov.Ruc gn-prov.Flgsit gn-prov.Persona ~
gn-prov.Libre_c01 gn-prov.CodPro gn-prov.TpoPro gn-prov.Libre_c02 ~
gn-prov.ApePat gn-prov.ApeMat gn-prov.Libre_c03 gn-prov.Nombre ~
gn-prov.Telfnos[1] gn-prov.NomPro gn-prov.LocPro gn-prov.Telfnos[2] ~
gn-prov.clfpro gn-prov.E-Mail gn-prov.Telfnos[3] gn-prov.Girpro ~
gn-prov.FaxPro gn-prov.CndCmp gn-prov.Libre_c05 
&Scoped-define DISPLAYED-TABLES gn-prov
&Scoped-define FIRST-DISPLAYED-TABLE gn-prov
&Scoped-Define DISPLAYED-OBJECTS F-DesCnd 

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
DEFINE VARIABLE F-DesCnd AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     gn-prov.Ruc AT ROW 1.27 COL 11 COLON-ALIGNED WIDGET-ID 58
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     gn-prov.Flgsit AT ROW 1.27 COL 28 NO-LABEL WIDGET-ID 102
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Activo", "A":U,
"Cesado", "C":U
          SIZE 9.14 BY 1.62
     gn-prov.Persona AT ROW 1.27 COL 63 NO-LABEL WIDGET-ID 64
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Jurídica", "J":U,
"Natural", "N":U
          SIZE 20 BY .81
     gn-prov.Libre_c01 AT ROW 1.27 COL 103 NO-LABEL WIDGET-ID 78
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", "Si":U,
"No", "No":U
          SIZE 11 BY .81
     gn-prov.CodPro AT ROW 2.08 COL 11 COLON-ALIGNED WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     gn-prov.TpoPro AT ROW 2.08 COL 63 NO-LABEL WIDGET-ID 74
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Nacional", "N":U,
"Extranjero", "E":U
          SIZE 20.86 BY .81
     gn-prov.Libre_c02 AT ROW 2.08 COL 103 NO-LABEL WIDGET-ID 82
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", "Si":U,
"No", "No":U
          SIZE 11 BY .81
     gn-prov.ApePat AT ROW 2.88 COL 11 COLON-ALIGNED WIDGET-ID 110
          LABEL "Ap. Paterno"
          VIEW-AS FILL-IN 
          SIZE 22 BY .81
     gn-prov.ApeMat AT ROW 2.88 COL 44 COLON-ALIGNED WIDGET-ID 108
          LABEL "Ap. Materno"
          VIEW-AS FILL-IN 
          SIZE 22 BY .81
     gn-prov.Libre_c03 AT ROW 2.88 COL 103 NO-LABEL WIDGET-ID 86
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", "Si":U,
"No", "No":U
          SIZE 11 BY .81
     gn-prov.Nombre AT ROW 3.69 COL 11 COLON-ALIGNED WIDGET-ID 112
          VIEW-AS FILL-IN 
          SIZE 22 BY .81
     gn-prov.Telfnos[1] AT ROW 4.23 COL 98 COLON-ALIGNED WIDGET-ID 68
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     gn-prov.NomPro AT ROW 4.5 COL 11 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .81
     gn-prov.LocPro AT ROW 4.5 COL 61 COLON-ALIGNED WIDGET-ID 116
          LABEL "Nombre Corto" FORMAT "x(20)"
          VIEW-AS FILL-IN 
          SIZE 29 BY .81
     gn-prov.Telfnos[2] AT ROW 5.04 COL 98 COLON-ALIGNED WIDGET-ID 70
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     gn-prov.clfpro AT ROW 5.31 COL 11 COLON-ALIGNED WIDGET-ID 106
          LABEL "Clasificacion"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "A","B","C" 
          DROP-DOWN-LIST
          SIZE 5.29 BY 1
     gn-prov.E-Mail AT ROW 5.31 COL 61 COLON-ALIGNED WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     gn-prov.Telfnos[3] AT ROW 5.85 COL 98 COLON-ALIGNED WIDGET-ID 72
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     gn-prov.Girpro AT ROW 6.12 COL 11 COLON-ALIGNED WIDGET-ID 118
          LABEL "Giro Empr." FORMAT "X(8)"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "NO DEFINIDO"," ",
                     "AGENCIA DE TRANSPORTE","AGT",
                     "TRANSPORTISTA","TRA",
                     "OTROS","OTROS"
          DROP-DOWN-LIST
          SIZE 24 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     gn-prov.FaxPro AT ROW 6.12 COL 61 COLON-ALIGNED WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     gn-prov.CndCmp AT ROW 6.92 COL 11 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     F-DesCnd AT ROW 6.92 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 98
     gn-prov.Libre_c05 AT ROW 6.92 COL 61 COLON-ALIGNED WIDGET-ID 56
          LABEL "Codigo EAN" FORMAT "x(13)"
          VIEW-AS FILL-IN 
          SIZE 25 BY .81
     "Agente de Percepción:" VIEW-AS TEXT
          SIZE 16 BY .5 AT ROW 2.88 COL 86 WIDGET-ID 94
     "Origen:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 2.27 COL 57 WIDGET-ID 96
     "Buen Contribuyente:" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 2.08 COL 88 WIDGET-ID 90
     "Persona:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 1.38 COL 56 WIDGET-ID 114
     "Agente de Retención:" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 1.27 COL 87 WIDGET-ID 92
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.gn-prov
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
         HEIGHT             = 7.27
         WIDTH              = 141.43.
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

/* SETTINGS FOR FILL-IN gn-prov.ApeMat IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-prov.ApePat IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX gn-prov.clfpro IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-DesCnd IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX gn-prov.Girpro IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR RADIO-SET gn-prov.Libre_c01 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET gn-prov.Libre_c02 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET gn-prov.Libre_c03 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-prov.Libre_c05 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-prov.LocPro IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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

&Scoped-define SELF-NAME gn-prov.ApeMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.ApeMat V-table-Win
ON LEAVE OF gn-prov.ApeMat IN FRAME F-Main /* Ap. Materno */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  gn-prov.NomPro:SCREEN-VALUE = TRIM(gn-prov.ApePat:SCREEN-VALUE) + ' ' +
                                TRIM(gn-prov.ApeMat:SCREEN-VALUE) + ', ' +
                                gn-prov.Nombre:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-prov.ApePat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.ApePat V-table-Win
ON LEAVE OF gn-prov.ApePat IN FRAME F-Main /* Ap. Paterno */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  gn-prov.NomPro:SCREEN-VALUE = TRIM(gn-prov.ApePat:SCREEN-VALUE) + ' ' +
                                TRIM(gn-prov.ApeMat:SCREEN-VALUE) + ', ' +
                                gn-prov.Nombre:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-prov.CndCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.CndCmp V-table-Win
ON LEAVE OF gn-prov.CndCmp IN FRAME F-Main /* Condicion */
DO:
    IF gn-prov.CndCmp:SCREEN-VALUE <> "" THEN DO:
        FIND cb-tabl WHERE
            cb-tabl.Tabla = "20" AND
            cb-tabl.Codigo = gn-prov.CndCmp:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF AVAILABLE cb-tabl THEN 
            F-DesCnd:SCREEN-VALUE = cb-tabl.Nombre.
        ELSE
            F-DesCnd:SCREEN-VALUE = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-prov.Nombre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.Nombre V-table-Win
ON LEAVE OF gn-prov.Nombre IN FRAME F-Main /* Nombres */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  gn-prov.NomPro:SCREEN-VALUE = TRIM(gn-prov.ApePat:SCREEN-VALUE) + ' ' +
                                TRIM(gn-prov.ApeMat:SCREEN-VALUE) + ', ' +
                                gn-prov.Nombre:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-prov.Persona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.Persona V-table-Win
ON VALUE-CHANGED OF gn-prov.Persona IN FRAME F-Main /* Persona */
DO:
  CASE SELF:SCREEN-VALUE:
    WHEN 'J' 
        THEN ASSIGN
                gn-prov.ApeMat:SENSITIVE = NO
                gn-prov.ApePat:SENSITIVE = NO
                gn-prov.Nombre:SENSITIVE = NO
                gn-prov.NomPro:SENSITIVE = YES
                gn-prov.ApeMat:SCREEN-VALUE = ''
                gn-prov.ApePat:SCREEN-VALUE = ''
                gn-prov.Nombre:SCREEN-VALUE = ''.
    WHEN 'N' 
        THEN ASSIGN
                gn-prov.ApeMat:SENSITIVE = YES
                gn-prov.ApePat:SENSITIVE = YES
                gn-prov.Nombre:SENSITIVE = YES
                gn-prov.NomPro:SENSITIVE = NO
                gn-prov.NomPro:SCREEN-VALUE = TRIM(gn-prov.ApePat:SCREEN-VALUE) + ' ' +
                                            TRIM(gn-prov.ApeMat:SCREEN-VALUE) + ', ' +
                                            gn-prov.Nombre:SCREEN-VALUE.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-prov.Ruc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.Ruc V-table-Win
ON LEAVE OF gn-prov.Ruc IN FRAME F-Main /* Ruc */
DO:
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN 
      gn-prov.CodPro:SCREEN-VALUE = SUBSTRING(gn-prov.Ruc:SCREEN-VALUE,3,8).
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
  {src/adm/template/row-list.i "gn-prov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gn-prov"}

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
  IF s-Create-Record = NO THEN DO:
      MESSAGE 'Usted no está autorizado para agregar el registro' VIEW-AS ALERT-BOX INFORMATION.
      RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      gn-prov.Flgsit:SCREEN-VALUE = "C".
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
       gn-prov.CodCia = pv-CodCia.


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
  IF s-Delete-Record = NO THEN DO:
      MESSAGE 'Usted no está autorizado para eliminar el registro' VIEW-AS ALERT-BOX INFORMATION.
      RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE gn-prov THEN DO WITH FRAME {&FRAME-NAME}:
      FIND cb-tabl WHERE cb-tabl.Tabla = "20" AND
          cb-tabl.Codigo = gn-prov.CndCmp NO-LOCK NO-ERROR.
      IF AVAILABLE cb-tabl THEN F-DesCnd = cb-tabl.Nombre.
      DISPLAY F-DesCnd.
  END.

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
  DO WITH FRAME {&FRAME-NAME}:
      DISABLE gn-prov.CodPro.
/*       DISABLE gn-prov.CodPro gn-prov.ApeMat gn-prov.ApePat gn-prov.Nombre. */
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'NO' THEN DISABLE gn-prov.Ruc.
      ELSE ENABLE gn-prov.Ruc.
      IF s-Confirm-Record = YES THEN ENABLE gn-prov.Flgsit WITH FRAME {&FRAME-NAME}.
      ELSE DISABLE gn-prov.Flgsit WITH FRAME {&FRAME-NAME}.
  END.

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
        WHEN "CndCmp"  THEN ASSIGN input-var-1 = "20".
        WHEN "Girpro"  THEN ASSIGN input-var-1 = "GN".
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
  {src/adm/template/snd-list.i "gn-prov"}

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

    DEFINE VAR x-ruc-valida AS CHAR.
    
    DO WITH FRAME {&FRAME-NAME}:
        /*Valida Codigo*/
        IF gn-prov.CodPro:SCREEN-VALUE = "" THEN DO:
            MESSAGE "Codigo Registro en Blanco"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            APPLY 'Entry':U TO gn-prov.codpro.
            RETURN 'ADM-ERROR'.            
        END.
        IF LENGTH(gn-prov.CodPro:SCREEN-VALUE) <> 8 THEN DO:
            MESSAGE "El codigo debe tener 8 digitos"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            APPLY 'Entry':U TO gn-prov.codpro.
            RETURN 'ADM-ERROR'.            
        END.
        /* Persona Juridica */
        IF gn-prov.tpopro:SCREEN-VALUE = 'J' THEN DO:
            IF LENGTH(gn-prov.ruc:SCREEN-VALUE) <> 11 THEN DO:
                MESSAGE
                    "Proveedor Nacional debe regitrar R.U.C. correcto"
                    VIEW-AS ALERT-BOX ERROR.
                APPLY 'Entry':U TO gn-prov.ruc.
                RETURN 'ADM-ERROR'.
            END.
            /* Validar estructura del RUC */            
            RUN lib/_valruc.r(gn-prov.ruc:SCREEN-VALUE, OUTPUT x-ruc-valida).
            IF x-ruc-valida = "ERROR" THEN DO:
                MESSAGE
                    "El R.U.C. no tiene la estructura CORRECTA"
                    VIEW-AS ALERT-BOX ERROR.
                APPLY 'Entry':U TO gn-prov.ruc.
                RETURN 'ADM-ERROR'.
            END.
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

  IF s-Write-Record = NO THEN DO:
      MESSAGE 'Usted no está autorizado para modificar el registro' VIEW-AS ALERT-BOX INFORMATION.
      RETURN 'ADM-ERROR'.
  END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

