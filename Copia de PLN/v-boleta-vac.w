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
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-periodo AS INT.
DEF SHARED VAR s-nromes AS INT.
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
&Scoped-define EXTERNAL-TABLES pl-boleta-vac
&Scoped-define FIRST-EXTERNAL-TABLE pl-boleta-vac


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR pl-boleta-vac.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS pl-boleta-vac.Periodo pl-boleta-vac.NroMes ~
pl-boleta-vac.NroDoc pl-boleta-vac.FchDoc pl-boleta-vac.CodPer ~
pl-boleta-vac.Desde pl-boleta-vac.Hasta pl-boleta-vac.Libre_c01 
&Scoped-define ENABLED-TABLES pl-boleta-vac
&Scoped-define FIRST-ENABLED-TABLE pl-boleta-vac
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 
&Scoped-Define DISPLAYED-FIELDS pl-boleta-vac.Periodo pl-boleta-vac.Usuario ~
pl-boleta-vac.NroMes pl-boleta-vac.Fecha pl-boleta-vac.NroDoc ~
pl-boleta-vac.FchDoc pl-boleta-vac.CodPer pl-boleta-vac.Desde ~
pl-boleta-vac.Hasta pl-boleta-vac.Dias pl-boleta-vac.Libre_c01 
&Scoped-define DISPLAYED-TABLES pl-boleta-vac
&Scoped-define FIRST-DISPLAYED-TABLE pl-boleta-vac
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NomPer FILL-IN-Cargo ~
FILL-IN-Seccion 

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
DEFINE VARIABLE FILL-IN-Cargo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cargo" 
     VIEW-AS FILL-IN 
     SIZE 65 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPer AS CHARACTER FORMAT "X(256)":U 
     LABEL "Apellidos y Nombres" 
     VIEW-AS FILL-IN 
     SIZE 65 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Seccion AS CHARACTER FORMAT "X(256)":U 
     LABEL "Sección" 
     VIEW-AS FILL-IN 
     SIZE 65 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 92 BY 5.92.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 92 BY 9.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     pl-boleta-vac.Periodo AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 6 BY 1
     pl-boleta-vac.Usuario AT ROW 2.08 COL 69 COLON-ALIGNED WIDGET-ID 14
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 12.43 BY 1
     pl-boleta-vac.NroMes AT ROW 3.15 COL 19 COLON-ALIGNED WIDGET-ID 20
          LABEL "Mes"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Enero",01,
                     "Febrero",02,
                     "Marzo",03,
                     "Abril",04,
                     "Mayo",05,
                     "Junio",06,
                     "Julio",07,
                     "Agosto",08,
                     "Setiembre",09,
                     "Octubre",10,
                     "Noviembre",11,
                     "Diciembre",12
          DROP-DOWN-LIST
          SIZE 16 BY 1
     pl-boleta-vac.Fecha AT ROW 3.15 COL 69 COLON-ALIGNED WIDGET-ID 28
          LABEL "Fecha de digitación" FORMAT "99/99/9999 HH:MM"
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     pl-boleta-vac.NroDoc AT ROW 4.23 COL 19 COLON-ALIGNED WIDGET-ID 12
          LABEL "Papeleta N°"
          VIEW-AS FILL-IN 
          SIZE 8.29 BY 1
     pl-boleta-vac.FchDoc AT ROW 5.31 COL 19 COLON-ALIGNED WIDGET-ID 8
          LABEL "Fecha de ingreso"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY 1
     pl-boleta-vac.CodPer AT ROW 7.73 COL 24 COLON-ALIGNED WIDGET-ID 2
          LABEL "Código del Trabajador"
          VIEW-AS FILL-IN 
          SIZE 13 BY 1
     FILL-IN-NomPer AT ROW 8.81 COL 24 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-Cargo AT ROW 9.88 COL 24 COLON-ALIGNED WIDGET-ID 30
     FILL-IN-Seccion AT ROW 10.96 COL 24 COLON-ALIGNED WIDGET-ID 32
     pl-boleta-vac.Desde AT ROW 12.04 COL 24 COLON-ALIGNED WIDGET-ID 4
          LABEL "Fecha de Inicio"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY 1
     pl-boleta-vac.Hasta AT ROW 13.12 COL 24 COLON-ALIGNED WIDGET-ID 10
          LABEL "Fecha de Término"
          VIEW-AS FILL-IN 
          SIZE 12.86 BY 1
     pl-boleta-vac.Dias AT ROW 14.19 COL 24 COLON-ALIGNED WIDGET-ID 6
          LABEL "Total Dias"
          VIEW-AS FILL-IN 
          SIZE 6 BY 1
     pl-boleta-vac.Libre_c01 AT ROW 15.27 COL 24 COLON-ALIGNED WIDGET-ID 36
          LABEL "Observaciones"
          VIEW-AS FILL-IN 
          SIZE 61.43 BY 1
     "Datos del movimiento del personal" VIEW-AS TEXT
          SIZE 32 BY .62 AT ROW 6.92 COL 4 WIDGET-ID 26
          BGCOLOR 1 FGCOLOR 15 
     "Datos del Registro de la Papeleta" VIEW-AS TEXT
          SIZE 30 BY .62 AT ROW 1.27 COL 3 WIDGET-ID 22
          BGCOLOR 1 FGCOLOR 15 
     RECT-1 AT ROW 1.27 COL 2 WIDGET-ID 24
     RECT-2 AT ROW 7.19 COL 2 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.pl-boleta-vac
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
         HEIGHT             = 15.96
         WIDTH              = 95.14.
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

/* SETTINGS FOR FILL-IN pl-boleta-vac.CodPer IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN pl-boleta-vac.Desde IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN pl-boleta-vac.Dias IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN pl-boleta-vac.FchDoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN pl-boleta-vac.Fecha IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FILL-IN-Cargo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPer IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Seccion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN pl-boleta-vac.Hasta IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN pl-boleta-vac.Libre_c01 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN pl-boleta-vac.NroDoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX pl-boleta-vac.NroMes IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN pl-boleta-vac.Usuario IN FRAME F-Main
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

&Scoped-define SELF-NAME pl-boleta-vac.CodPer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pl-boleta-vac.CodPer V-table-Win
ON LEAVE OF pl-boleta-vac.CodPer IN FRAME F-Main /* Código del Trabajador */
DO:
  RUN Pinta-Datos-Personal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pl-boleta-vac.CodPer V-table-Win
ON LEFT-MOUSE-DBLCLICK OF pl-boleta-vac.CodPer IN FRAME F-Main /* Código del Trabajador */
DO:
  RUN lkup/c-pl-pers ('Maestro de Personal').
  IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pl-boleta-vac.Desde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pl-boleta-vac.Desde V-table-Win
ON LEAVE OF pl-boleta-vac.Desde IN FRAME F-Main /* Fecha de Inicio */
DO:
  DISPLAY
      (INPUT pl-boleta-vac.hasta - INPUT pl-boleta-vac.desde + 1) @ pl-boleta-vac.dias
      WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pl-boleta-vac.Hasta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pl-boleta-vac.Hasta V-table-Win
ON LEAVE OF pl-boleta-vac.Hasta IN FRAME F-Main /* Fecha de Término */
DO:
    DISPLAY
        (INPUT pl-boleta-vac.hasta - INPUT pl-boleta-vac.desde + 1) @ pl-boleta-vac.dias
        WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pl-boleta-vac.NroMes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pl-boleta-vac.NroMes V-table-Win
ON VALUE-CHANGED OF pl-boleta-vac.NroMes IN FRAME F-Main /* Mes */
DO:
  RUN Pinta-Datos-Personal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pl-boleta-vac.Periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pl-boleta-vac.Periodo V-table-Win
ON LEAVE OF pl-boleta-vac.Periodo IN FRAME F-Main /* Año */
DO:
  RUN Pinta-Datos-Personal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

CASE s-coddoc:
    WHEN "VAC" THEN {&WINDOW-NAME}:TITLE = "PAPELETA DE VACACIONES".
    WHEN "LIC" THEN {&WINDOW-NAME}:TITLE = "LICENCIA SIN GOCE DE HABER".
END CASE.

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
  {src/adm/template/row-list.i "pl-boleta-vac"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "pl-boleta-vac"}

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
          pl-boleta-vac.NroMes:SCREEN-VALUE = STRING(s-NroMes, '99')
          pl-boleta-vac.Periodo:SCREEN-VALUE = STRING(s-Periodo, '9999').
      DISPLAY
          TODAY @ pl-boleta-vac.fchdoc
          TODAY @ pl-boleta-vac.desde
          TODAY @ pl-boleta-vac.hasta.
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
      pl-boleta-vac.CodCia = s-codcia
      pl-boleta-vac.CodDoc = s-coddoc
      pl-boleta-vac.Fecha = DATETIME(TODAY, MTIME)
      pl-boleta-vac.Usuario = s-user-id
      pl-boleta-vac.dias = pl-boleta-vac.hasta - pl-boleta-vac.desde + 1
      NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
       RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
       UNDO, RETURN "ADM-ERROR".
  END.

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
      ASSIGN
          FILL-IN-Cargo = ''
          FILL-IN-NomPer = ''
          FILL-IN-Seccion = ''.
      FIND PL-FLG-MES WHERE PL-FLG-MES.codcia =  pl-boleta-vac.CodCia
          AND PL-FLG-MES.periodo = pl-boleta-vac.Periodo
          AND PL-FLG-MES.nromes = pl-boleta-vac.NroMes
          AND PL-FLG-MES.codper = pl-boleta-vac.CodPer
          NO-LOCK NO-ERROR.
      IF AVAILABLE PL-FLG-MES 
          THEN ASSIGN
                    FILL-IN-Cargo = PL-FLG-MES.Cargo
                    FILL-IN-Seccion = PL-FLG-MES.Seccion.
      FIND PL-PERS WHERE PL-PERS.codper = pl-boleta-vac.codper
          NO-LOCK NO-ERROR.
      IF AVAILABLE PL-PERS THEN FILL-IN-NomPer = TRIM(PL-PERS.patper) + ' ' +
          TRIM(PL-PERS.matper) + ', ' + PL-PERS.nomper.
      DISPLAY
          FILL-IN-Cargo FILL-IN-NomPer FILL-IN-Seccion.
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
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta-Datos-Personal V-table-Win 
PROCEDURE Pinta-Datos-Personal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        FILL-IN-Cargo = ""
        FILL-IN-NomPer = ""
        FILL-IN-Seccion = "".
    FIND LAST pl-flg-mes WHERE pl-flg-mes.codcia = s-codcia
        AND pl-flg-mes.periodo <= INPUT pl-boleta-vac.Periodo
        AND pl-flg-mes.nromes <= INPUT pl-boleta-vac.NroMes
        AND pl-flg-mes.codper = INPUT pl-boleta-vac.CodPer
        NO-LOCK NO-ERROR.
    IF AVAILABLE pl-flg-mes THEN
        ASSIGN
            FILL-IN-Cargo = pl-flg-mes.cargo
            FILL-IN-Seccion = pl-flg-mes.seccion.
    FIND pl-pers WHERE pl-pers.codper = INPUT pl-boleta-vac.codper
        NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN FILL-IN-NomPer = TRIM(pl-pers.patper) + ' ' +
        TRIM(pl-pers.matper) + ', ' + pl-pers.nomper.
    DISPLAY 
        FILL-IN-Cargo 
        FILL-IN-NomPer
        FILL-IN-Seccion.
END.

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
  {src/adm/template/snd-list.i "pl-boleta-vac"}

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
    IF INPUT pl-boleta-vac.nrodoc = 0 THEN DO:
        MESSAGE 'Ingrese correctamente el número de la papeleta'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO pl-boleta-vac.nrodoc.
        RETURN "ADM-ERROR".
    END.
    FIND pl-pers WHERE pl-pers.codper = INPUT pl-boleta-vac.codper
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE pl-pers THEN DO:
        MESSAGE 'Ingrese correctamente el código del personal'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO pl-boleta-vac.codper.
        RETURN "ADM-ERROR".
    END.
    IF INPUT pl-boleta-vac.Desde > INPUT pl-boleta-vac.Hasta THEN DO:
        MESSAGE 'Ingrese correctamente el rango de fechas'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO pl-boleta-vac.desde.
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

