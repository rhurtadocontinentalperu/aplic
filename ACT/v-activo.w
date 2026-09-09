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
DEF SHARED VAR pv-codcia AS INT.

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
&Scoped-define EXTERNAL-TABLES AC-PARTI
&Scoped-define FIRST-EXTERNAL-TABLE AC-PARTI


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR AC-PARTI.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS AC-PARTI.DesPar AC-PARTI.Observaciones ~
AC-PARTI.Marca AC-PARTI.Modelo AC-PARTI.Serie AC-PARTI.CodPro ~
AC-PARTI.NroFacCmp AC-PARTI.FchComp AC-PARTI.NroG_R AC-PARTI.NroO_C ~
AC-PARTI.MonCmp AC-PARTI.FchDepr AC-PARTI.ValCmpMn1 AC-PARTI.ValCmpMn2 
&Scoped-define ENABLED-TABLES AC-PARTI
&Scoped-define FIRST-ENABLED-TABLE AC-PARTI
&Scoped-Define DISPLAYED-FIELDS AC-PARTI.FchIngr AC-PARTI.DesPar ~
AC-PARTI.Observaciones AC-PARTI.Marca AC-PARTI.Modelo AC-PARTI.Serie ~
AC-PARTI.CodPro AC-PARTI.NroFacCmp AC-PARTI.FchComp AC-PARTI.NroG_R ~
AC-PARTI.NroO_C AC-PARTI.MonCmp AC-PARTI.FchDepr AC-PARTI.ValCmpMn1 ~
AC-PARTI.ValCmpMn2 
&Scoped-define DISPLAYED-TABLES AC-PARTI
&Scoped-define FIRST-DISPLAYED-TABLE AC-PARTI
&Scoped-Define DISPLAYED-OBJECTS x-CodPar-1 x-CodPar-2 x-CodPar-3 ~
x-CodPar-4 x-NomPro 

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
DEFINE VARIABLE x-CodPar-1 AS CHARACTER FORMAT "9(4)":U 
     LABEL "Código" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE x-CodPar-2 AS CHARACTER FORMAT "XX":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE x-CodPar-3 AS CHARACTER FORMAT "9(4)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE x-CodPar-4 AS CHARACTER FORMAT "9(5)":U 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE x-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodPar-1 AT ROW 1 COL 18 COLON-ALIGNED WIDGET-ID 76
     x-CodPar-2 AT ROW 1 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     x-CodPar-3 AT ROW 1 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 80
     x-CodPar-4 AT ROW 1 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 82
     AC-PARTI.FchIngr AT ROW 1 COL 69 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     AC-PARTI.DesPar AT ROW 1.81 COL 18 COLON-ALIGNED WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 69 BY .81
     AC-PARTI.Observaciones AT ROW 2.62 COL 20 NO-LABEL WIDGET-ID 60
          VIEW-AS EDITOR MAX-CHARS 200 SCROLLBAR-VERTICAL
          SIZE 60 BY 4
     AC-PARTI.Marca AT ROW 6.65 COL 18 COLON-ALIGNED WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 49 BY .81
     AC-PARTI.Modelo AT ROW 7.46 COL 18 COLON-ALIGNED WIDGET-ID 46
          VIEW-AS FILL-IN 
          SIZE 48 BY .81
     AC-PARTI.Serie AT ROW 8.27 COL 18 COLON-ALIGNED WIDGET-ID 54
          VIEW-AS FILL-IN 
          SIZE 19 BY .81
     AC-PARTI.CodPro AT ROW 9.08 COL 18 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     x-NomPro AT ROW 9.08 COL 32 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     AC-PARTI.NroFacCmp AT ROW 9.88 COL 18 COLON-ALIGNED WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     AC-PARTI.FchComp AT ROW 9.88 COL 69 COLON-ALIGNED WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     AC-PARTI.NroG_R AT ROW 10.69 COL 18 COLON-ALIGNED WIDGET-ID 72
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     AC-PARTI.NroO_C AT ROW 10.69 COL 69 COLON-ALIGNED WIDGET-ID 74
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     AC-PARTI.MonCmp AT ROW 11.5 COL 20 NO-LABEL WIDGET-ID 66
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 15 BY .81
     AC-PARTI.FchDepr AT ROW 11.5 COL 69 COLON-ALIGNED WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     AC-PARTI.ValCmpMn1 AT ROW 12.58 COL 18 COLON-ALIGNED WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     AC-PARTI.ValCmpMn2 AT ROW 13.38 COL 18 COLON-ALIGNED WIDGET-ID 58
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     "Observaciones:" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 2.62 COL 9 WIDGET-ID 62
     "Moneda de compra:" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 11.5 COL 6 WIDGET-ID 70
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.AC-PARTI
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
         HEIGHT             = 16.12
         WIDTH              = 95.86.
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

/* SETTINGS FOR FILL-IN AC-PARTI.FchIngr IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-CodPar-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-CodPar-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-CodPar-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-CodPar-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME AC-PARTI.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL AC-PARTI.CodPro V-table-Win
ON LEAVE OF AC-PARTI.CodPro IN FRAME F-Main /* Proveedor */
DO:
    FIND gn-prov WHERE codcia = pv-codcia
        AND codpro = AC-PARTI.CodPro:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN x-nompro:SCREEN-VALUE = gn-prov.nompro.
    ELSE x-nompro:SCREEN-VALUE = ''.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPar-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPar-1 V-table-Win
ON LEAVE OF x-CodPar-1 IN FRAME F-Main /* Código */
DO:
  FIND ac-copar WHERE ac-copar.Codcia = s-codcia
      AND ac-copar.codcta = x-codpar-1:SCREEN-VALUE
      AND ac-copar.ccosto = x-CodPar-2:SCREEN-VALUE
      AND ac-copar.periodo = INTEGER (x-CodPar-3:SCREEN-VALUE)
      NO-LOCK NO-ERROR.
  IF AVAILABLE ac-copar THEN x-CodPar-4:SCREEN-VALUE = string(ac-copar.correlativo, '99999').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPar-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPar-2 V-table-Win
ON LEAVE OF x-CodPar-2 IN FRAME F-Main
DO:
    FIND ac-copar WHERE ac-copar.Codcia = s-codcia
        AND ac-copar.codcta = x-codpar-1:SCREEN-VALUE
        AND ac-copar.ccosto = x-CodPar-2:SCREEN-VALUE
        AND ac-copar.periodo = INTEGER (x-CodPar-3:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE ac-copar THEN x-CodPar-4:SCREEN-VALUE = string(ac-copar.correlativo, '99999').

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPar-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPar-3 V-table-Win
ON LEAVE OF x-CodPar-3 IN FRAME F-Main
DO:
    FIND ac-copar WHERE ac-copar.Codcia = s-codcia
        AND ac-copar.codcta = x-codpar-1:SCREEN-VALUE
        AND ac-copar.ccosto = x-CodPar-2:SCREEN-VALUE
        AND ac-copar.periodo = INTEGER (x-CodPar-3:SCREEN-VALUE)
        NO-LOCK NO-ERROR.
    IF AVAILABLE ac-copar THEN x-CodPar-4:SCREEN-VALUE = string(ac-copar.correlativo, '99999').
  
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
  {src/adm/template/row-list.i "AC-PARTI"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "AC-PARTI"}

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
      x-CodPar-3:SCREEN-VALUE = STRING(YEAR(TODAY)).
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
      AC-PARTI.CodCia = s-codcia
      AC-PARTI.FchIngr = TODAY.
  /* correlativo */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO WITH FRAME {&FRAME-NAME}:
      FIND ac-copar WHERE ac-copar.Codcia = s-codcia
          AND ac-copar.codcta = x-codpar-1:SCREEN-VALUE
          AND ac-copar.ccosto = x-CodPar-2:SCREEN-VALUE
          AND ac-copar.periodo = INTEGER (x-CodPar-3:SCREEN-VALUE)
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE ac-copar THEN DO:
          CREATE ac-copar.
          ASSIGN
              ac-copar.codcia = s-codcia
              ac-copar.codcta = x-codpar-1:SCREEN-VALUE
              ac-copar.ccosto = x-codpar-2:SCREEN-VALUE
              ac-copar.periodo = INTEGER (x-CodPar-3:SCREEN-VALUE)
              ac-copar.correlativo = 1.
      END.
      ac-parti.codpar = TRIM (ac-copar.codcta) + 
                        TRIM (ac-copar.ccosto) +
                        STRING(ac-copar.periodo, '9999') +
                        STRING(ac-copar.correlativo, '99999').
      ac-copar.correlativo = ac-copar.correlativo + 1.
      AC-PARTI.UbiAct = '@@'.       /* EN TRANSITO */
  END.
  RELEASE ac-copar.

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
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          x-CodPar-1:SENSITIVE = NO
          x-CodPar-2:SENSITIVE = NO
          x-CodPar-3:SENSITIVE = NO.
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
  IF AVAILABLE ac-parti THEN DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        x-CodPar-1 = SUBSTRING(AC-PARTI.CodPar,1,4)
        x-CodPar-2 = SUBSTRING(AC-PARTI.CodPar,5,2)
        x-CodPar-3 = SUBSTRING(AC-PARTI.CodPar,7,4)
        x-CodPar-4 = SUBSTRING(AC-PARTI.CodPar,11).
    DISPLAY
        x-codpar-1 x-codpar-2 x-codpar-3 x-codpar-4.
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = AC-PARTI.CodPro
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN x-nompro:SCREEN-VALUE = gn-prov.nompro.
    ELSE x-nompro:SCREEN-VALUE = ''.
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
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'YES' 
      THEN ASSIGN
          x-CodPar-1:SENSITIVE = YES
          x-CodPar-2:SENSITIVE = YES
          x-CodPar-3:SENSITIVE = YES.
      ELSE ASSIGN
          x-CodPar-1:SENSITIVE = NO
          x-CodPar-2:SENSITIVE = NO
          x-CodPar-3:SENSITIVE = NO.
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
  RUN adm-display-fields.

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
  {src/adm/template/snd-list.i "AC-PARTI"}

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
    /* consistencia del codigo */
    FIND ac-tabl WHERE ac-tabl.codcia = s-codcia
        AND ac-tabl.ctabla = 'CB'
        AND ac-tabl.ccodigo = x-CodPar-1:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ac-tabl THEN DO:
        MESSAGE 'Código de cuenta no registrado'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO x-CodPar-1.
        RETURN 'ADM-ERROR'.
    END.
    FIND ac-tabl WHERE ac-tabl.codcia = s-codcia
        AND ac-tabl.ctabla = 'CC'
        AND ac-tabl.ccodigo = x-CodPar-2:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ac-tabl THEN DO:
        MESSAGE 'Código de centro de costo no registrado'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO x-CodPar-2.
        RETURN 'ADM-ERROR'.
    END.

    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND codpro = AC-PARTI.CodPro:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-prov THEN DO:
        MESSAGE 'Proveedor NO registrado'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO AC-PARTI.CodPro.
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

