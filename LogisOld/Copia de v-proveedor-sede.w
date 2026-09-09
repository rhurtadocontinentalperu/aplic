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
&Scoped-define EXTERNAL-TABLES gn-provd gn-prov
&Scoped-define FIRST-EXTERNAL-TABLE gn-provd


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gn-provd, gn-prov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gn-provd.Sede gn-provd.DomFiscal ~
gn-provd.CodDept gn-provd.TipoZona gn-provd.NomZona gn-provd.CodProv ~
gn-provd.TipoVia gn-provd.NomVia gn-provd.CodDist gn-provd.Nro ~
gn-provd.Codpos gn-provd.Km gn-provd.Latitud gn-provd.Mza gn-provd.Longitud ~
gn-provd.Inter gn-provd.Dpto gn-provd.Lote gn-provd.Referencias 
&Scoped-define ENABLED-TABLES gn-provd
&Scoped-define FIRST-ENABLED-TABLE gn-provd
&Scoped-Define DISPLAYED-FIELDS gn-provd.Sede gn-provd.DomFiscal ~
gn-provd.DirPro gn-provd.CodDept gn-provd.TipoZona gn-provd.NomZona ~
gn-provd.CodProv gn-provd.TipoVia gn-provd.NomVia gn-provd.CodDist ~
gn-provd.Nro gn-provd.Codpos gn-provd.Km gn-provd.Latitud gn-provd.Mza ~
gn-provd.Longitud gn-provd.Inter gn-provd.Dpto gn-provd.Lote ~
gn-provd.Referencias 
&Scoped-define DISPLAYED-TABLES gn-provd
&Scoped-define FIRST-DISPLAYED-TABLE gn-provd
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-DEP FILL-IN-PROV FILL-IN-DIS ~
FILL-IN-POS 

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
DEFINE VARIABLE FILL-IN-DEP AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-DIS AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-POS AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-PROV AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     gn-provd.Sede AT ROW 1 COL 12 COLON-ALIGNED WIDGET-ID 66
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     gn-provd.DomFiscal AT ROW 1 COL 37 NO-LABEL WIDGET-ID 76
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "SI", yes,
"NO", no
          SIZE 12 BY .81
     gn-provd.DirPro AT ROW 2.62 COL 12 COLON-ALIGNED WIDGET-ID 124
          VIEW-AS FILL-IN 
          SIZE 83 BY .81
     gn-provd.CodDept AT ROW 3.42 COL 12 COLON-ALIGNED WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-DEP AT ROW 3.42 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     gn-provd.TipoZona AT ROW 3.42 COL 48 COLON-ALIGNED WIDGET-ID 116
          LABEL "TipoZona" FORMAT "x(20)"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "item","item"
          DROP-DOWN-LIST
          SIZE 23 BY 1
     gn-provd.NomZona AT ROW 3.42 COL 72 COLON-ALIGNED NO-LABEL WIDGET-ID 122
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .81
     gn-provd.CodProv AT ROW 4.23 COL 12 COLON-ALIGNED WIDGET-ID 48
          LABEL "Provincia"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-PROV AT ROW 4.23 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     gn-provd.TipoVia AT ROW 4.23 COL 48 COLON-ALIGNED WIDGET-ID 118
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "item","item"
          DROP-DOWN-LIST
          SIZE 23 BY 1
     gn-provd.NomVia AT ROW 4.23 COL 72 COLON-ALIGNED NO-LABEL WIDGET-ID 120
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .81
     gn-provd.CodDist AT ROW 5.04 COL 12 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-DIS AT ROW 5.04 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 86
     gn-provd.Nro AT ROW 5.04 COL 48 COLON-ALIGNED WIDGET-ID 110
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     gn-provd.Codpos AT ROW 5.85 COL 12 COLON-ALIGNED WIDGET-ID 46
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-POS AT ROW 5.85 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 88
     gn-provd.Km AT ROW 5.85 COL 48 COLON-ALIGNED WIDGET-ID 104
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     gn-provd.Latitud AT ROW 6.65 COL 12 COLON-ALIGNED WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     gn-provd.Mza AT ROW 6.65 COL 48 COLON-ALIGNED WIDGET-ID 108
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     gn-provd.Longitud AT ROW 7.46 COL 12 COLON-ALIGNED WIDGET-ID 58
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     gn-provd.Inter AT ROW 7.46 COL 48 COLON-ALIGNED WIDGET-ID 102
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     gn-provd.Dpto AT ROW 8.27 COL 48 COLON-ALIGNED WIDGET-ID 100
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     gn-provd.Lote AT ROW 9.08 COL 48 COLON-ALIGNED WIDGET-ID 106
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     gn-provd.Referencias AT ROW 9.88 COL 14 NO-LABEL WIDGET-ID 82
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 60 BY 2.42
     "Domicilio Fiscal:" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 1.12 COL 26 WIDGET-ID 126
     "Referencias:" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 9.88 COL 5 WIDGET-ID 94
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.gn-provd,INTEGRAL.gn-prov
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
         HEIGHT             = 11.5
         WIDTH              = 97.14.
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

/* SETTINGS FOR FILL-IN gn-provd.CodProv IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-provd.DirPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DEP IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DIS IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-POS IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-PROV IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX gn-provd.TipoZona IN FRAME F-Main
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

&Scoped-define SELF-NAME gn-provd.CodDept
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-provd.CodDept V-table-Win
ON LEAVE OF gn-provd.CodDept IN FRAME F-Main /* Departamento */
DO:
  FILL-IN-DEP:SCREEN-VALUE = ''.
  FIND TabDepto WHERE TabDepto.CodDepto = gn-provd.CodDept:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE TabDepto THEN FILL-IN-DEP:SCREEN-VALUE = TabDepto.NomDepto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-provd.CodDist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-provd.CodDist V-table-Win
ON LEAVE OF gn-provd.CodDist IN FRAME F-Main /* Distrito */
DO:
  FILL-IN-DIS:SCREEN-VALUE = ''.
  FIND TabDistr WHERE TabDistr.CodDepto = gn-provd.CodDept:SCREEN-VALUE AND 
      TabDistr.CodProvi = gn-provd.CodProv:SCREEN-VALUE AND 
      TabDistr.CodDistr = gn-provd.CodDist:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE TabDistr THEN DO:
      FILL-IN-DIS:SCREEN-VALUE = TabDistr.NomDistr.
      IF TRUE <> (gn-provd.Codpos > '') THEN DO:
          gn-provd.Codpos:SCREEN-VALUE = TabDistr.CodPos.
          APPLY 'LEAVE':U TO gn-provd.Codpos.
      END.
  END.
      
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-provd.Codpos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-provd.Codpos V-table-Win
ON LEAVE OF gn-provd.Codpos IN FRAME F-Main /* Postal */
DO:
  FILL-IN-POS:SCREEN-VALUE = ''.
  FIND almtabla WHERE almtabla.Tabla = "CP" AND
      almtabla.Codigo = gn-provd.Codpos:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE almtabla THEN FILL-IN-POS:SCREEN-VALUE = almtabla.Nombre.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-provd.CodProv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-provd.CodProv V-table-Win
ON LEAVE OF gn-provd.CodProv IN FRAME F-Main /* Provincia */
DO:
  FILL-IN-PROV:SCREEN-VALUE = ''.
  FIND TabProvi WHERE TabProvi.CodDepto = gn-provd.CodDept:SCREEN-VALUE AND 
      TabProvi.CodProvi = gn-provd.CodProv:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE TabProvi THEN FILL-IN-PROV:SCREEN-VALUE = TabProvi.NomProvi.
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
  {src/adm/template/row-list.i "gn-provd"}
  {src/adm/template/row-list.i "gn-prov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gn-provd"}
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
  /* Armamos la dirección */
  DEF VAR x-Direccion AS CHAR NO-UNDO.
  IF gn-provd.NomVia > '' THEN DO:
      FIND PL-TABLA WHERE PL-TABLA.CodCia = 000 AND
          PL-TABLA.Tabla = "05" AND
          PL-TABLA.Codigo = gn-provd.TipoVia NO-LOCK NO-ERROR.
      IF AVAILABLE PL-TABLA THEN x-Direccion = x-Direccion + 
          (IF TRUE <> (x-Direccion > '') THEN '' ELSE ' ') +
          PL-TABLA.Nombre + ' ' + gn-provd.NomVia.
  END.
  IF gn-provd.Nro > '' THEN x-Direccion = x-Direccion + 
          (IF TRUE <> (x-Direccion > '') THEN '' ELSE ' ') +
          'NRO. ' + gn-provd.Nro.
  IF gn-provd.Km > '' THEN x-Direccion = x-Direccion + 
      (IF TRUE <> (x-Direccion > '') THEN '' ELSE ' ') +
      'KM. ' + gn-provd.Km.
  IF gn-provd.Mza > '' THEN x-Direccion = x-Direccion + 
      (IF TRUE <> (x-Direccion > '') THEN '' ELSE ' ') +
      'MZA. ' + gn-provd.Mza.
  IF gn-provd.Inter > '' THEN x-Direccion = x-Direccion + 
      (IF TRUE <> (x-Direccion > '') THEN '' ELSE ' ') +
      'INTER. ' + gn-provd.Inter.
  IF gn-provd.Dpto > '' THEN x-Direccion = x-Direccion + 
      (IF TRUE <> (x-Direccion > '') THEN '' ELSE ' ') +
      'DPTO. ' + gn-provd.Dpto.
  IF gn-provd.Lote > '' THEN x-Direccion = x-Direccion + 
      (IF TRUE <> (x-Direccion > '') THEN '' ELSE ' ') +
      'LOTE ' + gn-provd.Lote.
  IF gn-provd.NomZona > '' THEN DO:
      FIND PL-TABLA WHERE PL-TABLA.CodCia = 000 AND
          PL-TABLA.Tabla = "06" AND
          PL-TABLA.Codigo = gn-provd.TipoZona NO-LOCK NO-ERROR.
      IF AVAILABLE PL-TABLA THEN x-Direccion = x-Direccion + 
          (IF TRUE <> (x-Direccion > '') THEN '' ELSE ' ') +
          PL-TABLA.Nombre + ' ' + gn-provd.NomZona.
  END.
  gn-provd.DirPro = CAPS(x-Direccion).
  IF gn-provd.Sede <> '@@@' THEN gn-provd.DomFiscal = NO.
  ELSE DO:  /* actualizamos los datos en el maestro de clientes */
      FIND CURRENT gn-prov EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-prov THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN
          gn-prov.CodDept = gn-provd.CodDept 
          gn-prov.CodDist = gn-provd.CodDist 
          gn-prov.CodProv = gn-provd.CodProv 
          gn-prov.Codpos  = gn-provd.Codpos 
          gn-prov.DirPro  = gn-provd.DirPro.
      FIND CURRENT gn-prov NO-LOCK.
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
      gn-provd.CodCia = gn-prov.CodCia
      gn-provd.CodPro = gn-prov.CodPro.

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
  IF AVAILABLE gn-provd AND gn-provd.sede = '@@@' THEN DO:
      MESSAGE 'NO puede eliminar la dirección fiscal' SKIP 'Proceso abortado'
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.

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
  RUN Procesa-Handle IN lh_handle('enable-fields').

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
  DO WITH FRAME {&FRAME-NAME}:
      APPLY 'LEAVE':U TO gn-provd.CodDept.
      APPLY 'LEAVE':U TO gn-provd.CodDist.
      APPLY 'LEAVE':U TO gn-provd.Codpos.
      APPLY 'LEAVE':U TO gn-provd.CodProv.
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
      DISABLE gn-provd.DomFiscal.
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'NO' THEN DO WITH FRAME {&FRAME-NAME}:
          IF gn-provd.Sede = '@@@' THEN DO:
              DISABLE gn-provd.Sede.
          END.
      END.
      RUN Procesa-Handle IN lh_handle('disable-fields').
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      /* TIPO ZONA */
      gn-provd.TipoZona:DELETE(1).
      FOR EACH PL-TABLA NO-LOCK WHERE PL-TABLA.CodCia = 000 AND
          PL-TABLA.Tabla = "06":
          gn-provd.TipoZona:ADD-LAST(PL-TABLA.Nombre, PL-TABLA.Codigo).
      END.
      /* TIPO VIA */
      gn-provd.TipoVia:DELETE(1).
      FOR EACH PL-TABLA NO-LOCK WHERE PL-TABLA.CodCia = 000 AND
          PL-TABLA.Tabla = "05":
          gn-provd.TipoVia:ADD-LAST(PL-TABLA.Nombre, PL-TABLA.Codigo).
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "gn-provd"}
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

DO WITH FRAME {&FRAME-NAME}:
    IF TRUE <> (gn-provd.Sede:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Ingrese la sede' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO gn-provd.Sede.
        RETURN 'ADM-ERROR'.
    END.
    IF NOT CAN-FIND(TabDepto WHERE TabDepto.CodDepto = gn-provd.CodDept:SCREEN-VALUE NO-LOCK)
        THEN DO:
        MESSAGE 'Error en el código del Departamento' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO gn-provd.CodDept.
        RETURN 'ADM-ERROR'.
    END.
    IF NOT CAN-FIND(TabProvi WHERE TabProvi.CodDepto = gn-provd.CodDept:SCREEN-VALUE AND 
                    TabProvi.CodProvi = gn-provd.CodProv:SCREEN-VALUE NO-LOCK)
        THEN DO:
        MESSAGE 'Error en el código de Provincia' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO gn-provd.CodProv.
        RETURN 'ADM-ERROR'.
    END.
    IF NOT CAN-FIND(TabDistr WHERE TabDistr.CodDepto = gn-provd.CodDept:SCREEN-VALUE AND 
                    TabDistr.CodProvi = gn-provd.CodProv:SCREEN-VALUE AND 
                    TabDistr.CodDistr = gn-provd.CodDist:SCREEN-VALUE NO-LOCK)
        THEN DO:
        MESSAGE 'Error en el código de Distrito' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO gn-provd.CodDist.
        RETURN 'ADM-ERROR'.
    END.
    IF NOT CAN-FIND(almtabla WHERE almtabla.Tabla = "CP" AND
                    almtabla.Codigo = gn-provd.Codpos:SCREEN-VALUE NO-LOCK)
        THEN DO:
        MESSAGE 'Error en el código Postal' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO gn-provd.CodPos.
        RETURN 'ADM-ERROR'.
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

