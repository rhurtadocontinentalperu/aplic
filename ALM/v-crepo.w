&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-DREPO LIKE almdrepo
       FIELD SolStkAct AS DEC
       FIELD SolStkCom AS DEC
       FIELD SolStkDis AS DEC
       FIELD SolStkMax AS DEC
       FIELD SolStkTra AS DEC
       FIELD DesStkAct AS DEC
       FIELD DesStkCom AS DEC
       FIELD DesStkDis AS DEC
       FIELD DesStkMax AS DEC
       FIELD PorcReposicion AS DEC
       FIELD FSGrupo AS DEC
       FIELD GrpStkDis AS DEC
       FIELD ControlDespacho AS LOG INITIAL NO
       FIELD VtaGrp30 AS DEC
       FIELD VtaGrp60 AS DEC
       FIELD VtaGrp90 AS DEC
       FIELD VtaGrp30y AS DEC
       FIELD DesCmpTra AS DEC
       FIELD VtaGrp60y AS DEC
       FIELD VtaGrp90y AS DEC
       FIELD DesStkTra AS DEC
       FIELD ClfGral AS CHAR
       FIELD ClfMayo AS CHAR
       FIELD ClfUtil AS CHAR
       FIELD SolCmpTra AS DEC
       FIELD CodZona AS CHAR
       FIELD CodUbi  AS CHAR
       FIELD DesMat  AS CHAR
       .



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

DEF SHARED VARIABLE lh_handle AS HANDLE.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-tipmov AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.

DEF SHARED VAR s-nroser AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR x-VtaPuntual LIKE almcrepo.VtaPuntual NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES almcrepo
&Scoped-define FIRST-EXTERNAL-TABLE almcrepo


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR almcrepo.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS almcrepo.VtaPuntual almcrepo.FchVto ~
almcrepo.Glosa almcrepo.MotReposicion almcrepo.Fecha 
&Scoped-define ENABLED-TABLES almcrepo
&Scoped-define FIRST-ENABLED-TABLE almcrepo
&Scoped-Define DISPLAYED-FIELDS almcrepo.VtaPuntual almcrepo.NroSer ~
almcrepo.NroDoc almcrepo.FchDoc almcrepo.AlmPed almcrepo.FchVto ~
almcrepo.Usuario almcrepo.FchApr almcrepo.Glosa almcrepo.HorApr ~
almcrepo.MotReposicion almcrepo.UsrApr almcrepo.Fecha 
&Scoped-define DISPLAYED-TABLES almcrepo
&Scoped-define FIRST-DISPLAYED-TABLE almcrepo
&Scoped-Define DISPLAYED-OBJECTS x-Estado x-Situacion FILL-IN-Usuario ~
x-NomAlm FILL-IN-Fecha FILL-IN-NroOTR 

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
DEFINE VARIABLE FILL-IN-Fecha AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fecha y hora" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroOTR AS CHARACTER FORMAT "X(256)":U 
     LABEL "OTR" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Usuario AS CHARACTER FORMAT "X(256)":U 
     LABEL "Modificado por" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .81
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE x-NomAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE x-Situacion AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     almcrepo.VtaPuntual AT ROW 1.19 COL 120 WIDGET-ID 66
          LABEL "URGENTE"
          VIEW-AS TOGGLE-BOX
          SIZE 12 BY .77
     almcrepo.NroSer AT ROW 1.27 COL 15 COLON-ALIGNED WIDGET-ID 50
          LABEL "Numero"
          VIEW-AS FILL-IN 
          SIZE 3.57 BY .81
     almcrepo.NroDoc AT ROW 1.27 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     x-Estado AT ROW 1.27 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     x-Situacion AT ROW 1.27 COL 42 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     almcrepo.FchDoc AT ROW 1.27 COL 86 COLON-ALIGNED WIDGET-ID 42
          LABEL "Fecha de Digitación"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FILL-IN-Usuario AT ROW 1.96 COL 118 COLON-ALIGNED WIDGET-ID 68
     almcrepo.AlmPed AT ROW 2.08 COL 15 COLON-ALIGNED WIDGET-ID 38
          LABEL "Almacén Despacho"
          VIEW-AS FILL-IN 
          SIZE 3.57 BY .81
     x-NomAlm AT ROW 2.08 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     almcrepo.FchVto AT ROW 2.08 COL 86 COLON-ALIGNED WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FILL-IN-Fecha AT ROW 2.73 COL 118 COLON-ALIGNED WIDGET-ID 70
     almcrepo.Usuario AT ROW 2.88 COL 15 COLON-ALIGNED WIDGET-ID 54
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     almcrepo.FchApr AT ROW 2.88 COL 86 COLON-ALIGNED WIDGET-ID 40
          LABEL "Fecha Aprobacion/Rechazo"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     almcrepo.Glosa AT ROW 3.69 COL 15 COLON-ALIGNED WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 44 BY .81
     almcrepo.HorApr AT ROW 3.69 COL 86 COLON-ALIGNED WIDGET-ID 46
          LABEL "Hora Aprobacion/Rechazo"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     almcrepo.MotReposicion AT ROW 3.69 COL 103 COLON-ALIGNED WIDGET-ID 72
          LABEL "Motivo"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Sin Motivo"," ",
                     "Item 1","Item 1"
          DROP-DOWN-LIST
          SIZE 35 BY 1
     almcrepo.UsrApr AT ROW 4.5 COL 86 COLON-ALIGNED WIDGET-ID 52
          LABEL "Aprobado/Rechazado por"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-NroOTR AT ROW 4.5 COL 103 COLON-ALIGNED WIDGET-ID 74
     almcrepo.Fecha AT ROW 4.62 COL 15.14 COLON-ALIGNED WIDGET-ID 64
          LABEL "Fecha Entrega" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.almcrepo
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: T-DREPO T "SHARED" ? INTEGRAL almdrepo
      ADDITIONAL-FIELDS:
          FIELD SolStkAct AS DEC
          FIELD SolStkCom AS DEC
          FIELD SolStkDis AS DEC
          FIELD SolStkMax AS DEC
          FIELD SolStkTra AS DEC
          FIELD DesStkAct AS DEC
          FIELD DesStkCom AS DEC
          FIELD DesStkDis AS DEC
          FIELD DesStkMax AS DEC
          FIELD PorcReposicion AS DEC
          FIELD FSGrupo AS DEC
          FIELD GrpStkDis AS DEC
          FIELD ControlDespacho AS LOG INITIAL NO
          FIELD VtaGrp30 AS DEC
          FIELD VtaGrp60 AS DEC
          FIELD VtaGrp90 AS DEC
          FIELD VtaGrp30y AS DEC
          FIELD DesCmpTra AS DEC
          FIELD VtaGrp60y AS DEC
          FIELD VtaGrp90y AS DEC
          FIELD DesStkTra AS DEC
          FIELD ClfGral AS CHAR
          FIELD ClfMayo AS CHAR
          FIELD ClfUtil AS CHAR
          FIELD SolCmpTra AS DEC
          FIELD CodZona AS CHAR
          FIELD CodUbi  AS CHAR
          FIELD DesMat  AS CHAR
          
      END-FIELDS.
   END-TABLES.
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
         HEIGHT             = 6.85
         WIDTH              = 147.
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

/* SETTINGS FOR FILL-IN almcrepo.AlmPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN almcrepo.FchApr IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN almcrepo.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN almcrepo.Fecha IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-Fecha IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroOTR IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Usuario IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN almcrepo.HorApr IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR COMBO-BOX almcrepo.MotReposicion IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN almcrepo.NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN almcrepo.NroSer IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN almcrepo.UsrApr IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN almcrepo.Usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX almcrepo.VtaPuntual IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN x-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Situacion IN FRAME F-Main
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
  {src/adm/template/row-list.i "almcrepo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "almcrepo"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-DREPO:
    DELETE T-DREPO.
END.

FOR EACH almdrepo OF almcrepo NO-LOCK:
    CREATE T-DREPO.
    BUFFER-COPY almdrepo TO T-DREPO.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir V-table-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR RB-REPORT-LIBRARY AS CHAR NO-UNDO.
DEF VAR RB-REPORT-NAME AS CHAR NO-UNDO.
DEF VAR RB-INCLUDE-RECORDS AS CHAR NO-UNDO.
DEF VAR RB-FILTER AS CHAR NO-UNDO.
DEF VAR RB-OTHER-PARAMETERS AS CHAR NO-UNDO.
    
    IF almcrepo.FlgEst = 'A' THEN DO:
        MESSAGE 'Documento Anulado'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN 'adm-error'.
    END.
        

    /* RHC 24/085/2017 Como hay problemas con el reporte se va a hacer un artificio */
    DEF VAR s-Task-No LIKE w-report.Task-No NO-UNDO.

    REPEAT:
        s-Task-No = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.Task-No = s-Task-No NO-LOCK)
            THEN LEAVE.
    END.
    CREATE w-report.
    ASSIGN
        w-report.Task-No = s-Task-No
        w-report.Llave-I = almcrepo.CodCia 
        w-report.Llave-C = almcrepo.CodAlm + ',' + almcrepo.TipMov
        w-report.Campo-I[1] = almcrepo.NroSer
        w-report.Campo-I[2] = almcrepo.NroDoc 
        w-report.Campo-C[1] = almcrepo.AlmPed
        w-report.Campo-C[2] = almcrepo.Glosa
        w-report.Campo-C[3] = almcrepo.HorApr
        w-report.Campo-C[4] = almcrepo.UsrApr
        w-report.Campo-D[1] = almcrepo.FchDoc
        w-report.Campo-D[2] = almcrepo.FchVto
        w-report.Campo-D[3] = almcrepo.FchApr
        .

    GET-KEY-VALUE SECTION 'STARTUP' KEY 'BASE' VALUE RB-REPORT-LIBRARY.
    ASSIGN
        RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "ALM\RBALM.PRL"
        RB-INCLUDE-RECORDS = "O"
        RB-FILTER = "w-report.Task-No = " + STRING(s-Task-No)
/*         RB-FILTER = "Almcrepo.CodCia = " + STRING(s-codcia) +                    */
/*                     " AND Almcrepo.CodAlm = '" + STRING(almcrepo.CodAlm) + "'" + */
/*                     " AND Almcrepo.TipMov = '" + STRING(almcrepo.TipMov) + "'" + */
/*                     " AND Almcrepo.NroSer = " + string(almcrepo.NroSer) +        */
/*                     " AND Almcrepo.NroDoc = " + string(almcrepo.NroDoc)          */
        .
    RB-OTHER-PARAMETERS = "s-nomcia = " + s-nomcia.  
    /*RB-REPORT-NAME = "Ped Reposicion Automatica".*/
    RB-REPORT-NAME = "Ped Reposicion Automatica v2".
    
    RUN lib/_Imprime2(
        RB-REPORT-LIBRARY,
        RB-REPORT-NAME,
        RB-INCLUDE-RECORDS,
        RB-FILTER,
        RB-OTHER-PARAMETERS).

    FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.Task-No = s-Task-No:
        DELETE w-report.
    END.

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
  RUN Procesa-Handle IN lh_handle ('Pagina2').
  x-VtaPuntual = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       SOLO se puede modificar 
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FOR EACH almdrepo OF almcrepo:
      DELETE almdrepo.
  END.
  DEF VAR x-Item AS INT INIT 0 NO-UNDO.
  FOR EACH T-DREPO, 
      FIRST Almmmatg OF T-DREPO NO-LOCK BY Almmmatg.DesMar BY Almmmatg.DesMat:
      x-Item = x-Item + 1.
      CREATE almdrepo.
      BUFFER-COPY T-DREPO 
          TO almdrepo
          ASSIGN
            almdrepo.ITEM   = x-Item    /* OJO */
            almdrepo.CodCia = almcrepo.codcia
            almdrepo.NroSer = almcrepo.nroser
            almdrepo.NroDoc = almcrepo.nrodoc
            almdrepo.CodAlm = almcrepo.codalm
            almdrepo.TipMov = almcrepo.tipmov.
      ASSIGN
          T-DREPO.ITEM = x-Item.
  END.
  /* Venta Puntual */
  IF x-VtaPuntual <> almcrepo.VtaPuntual THEN DO:
      ASSIGN
          almcrepo.Libre_c01 = s-user-id + '|' + 
            STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS').
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      almcrepo.MotReposicion:SCREEN-VALUE = almcrepo.MotReposicion.
  END.
  RUN Procesa-Handle IN lh_handle ('Pagina1').

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
  DEF VAR s-coddoc AS CHAR INIT "R/A" NO-UNDO.

  IF NOT AVAILABLE almcrepo THEN RETURN 'ADM-ERROR'.
  IF almcrepo.flgest <> 'P' THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  /*IF almcrepo.flgsit <> 'P' THEN DO:*/
  IF LOOKUP(almcrepo.flgsit, 'P,G') = 0 THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  FIND FIRST Almdrepo OF Almcrepo WHERE almdrepo.CanAten > 0 NO-LOCK NO-ERROR.
  IF AVAILABLE Almdrepo THEN DO:
      MESSAGE 'Algunos materiales ya fueron atendidos' SKIP
          'Acceso denegado' VIEW-AS ALERT-BOX WARNING.
      RETURN "ADM-ERROR".
  END.

  {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}
/*   RUN valida-update.                                     */
/*   IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'. */

  /* Solo marcamos el documento como anulado ********************
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  ************************************************************ */

  /* Code placed here will execute AFTER standard behavior.    */
  FIND CURRENT almcrepo EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE almcrepo THEN RETURN 'ADM-ERROR'.
  ASSIGN
      almcrepo.flgest = 'A'
      almcrepo.usract = s-user-id
      almcrepo.fecact = TODAY
      almcrepo.horact = STRING(TIME, 'HH:MM:SS').
  FIND CURRENT almcrepo NO-LOCK NO-ERROR.

  RUN local-display-fields.

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
  IF AVAILABLE almcrepo THEN DO WITH FRAME {&FRAME-NAME}:
      CASE almcrepo.flgest:
          WHEN 'P' THEN x-Estado:SCREEN-VALUE = 'PENDIENTE'.
          WHEN 'C' THEN x-Estado:SCREEN-VALUE = 'CON OTR'.
          WHEN 'A' THEN x-Estado:SCREEN-VALUE = 'ANULADO'.
          WHEN 'M' THEN x-Estado:SCREEN-VALUE = 'CIERRE MANUAL'.
          WHEN 'R' THEN x-Estado:SCREEN-VALUE = 'RECHAZADO'.
          WHEN 'V' THEN x-Estado:SCREEN-VALUE = 'VENCIDO'.
          OTHERWISE x-Estado:SCREEN-VALUE = '¿?'.
      END CASE.
      CASE almcrepo.flgsit:
          WHEN 'G' THEN x-Situacion:SCREEN-VALUE = 'POR AUTORIZAR'.
          WHEN 'P' THEN x-Situacion:SCREEN-VALUE = 'POR APROBAR'.
          WHEN 'A' THEN x-Situacion:SCREEN-VALUE = 'APROBADO'.
          WHEN 'R' THEN x-Situacion:SCREEN-VALUE = 'RECHAZADO'.
          OTHERWISE x-situacion:SCREEN-VALUE = '¿?'.
      END CASE.
      x-NomAlm:SCREEN-VALUE = ''.
      FIND almacen WHERE almacen.codcia = almcrepo.codcia
          AND almacen.codalm = almcrepo.almped
          NO-LOCK NO-ERROR.
      IF AVAILABLE almacen THEN x-NomAlm:SCREEN-VALUE = Almacen.Descripcion.
      /* Venta Puntual */
      IF NUM-ENTRIES(almcrepo.Libre_c01,'|') > 1 THEN
          DISPLAY
            ENTRY(1,almcrepo.Libre_c01,'|') @ FILL-IN-Usuario
            ENTRY(2,almcrepo.Libre_c01,'|') @ FILL-IN-Fecha.
      /* OTR */
      FILL-IN-NroOTR:SCREEN-VALUE = ''.
      FIND LAST Faccpedi USE-INDEX Llave07 WHERE Faccpedi.codcia = s-codcia
          AND Faccpedi.coddoc = 'OTR'
          AND Faccpedi.codref = 'R/A'
          AND Faccpedi.nroref = STRING(almcrepo.NroSer,'999') + STRING(almcrepo.NroDoc,'999999')
          NO-LOCK NO-ERROR.
      IF AVAILABLE Faccpedi THEN FILL-IN-NroOTR:SCREEN-VALUE = Faccpedi.nroped.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      almcrepo.MotReposicion:DELETE(2).
/*       almcrepo.MotReposicion:ADD-LAST('Sin Motivo', ' '). */
      FOR EACH FacTabla NO-LOCK WHERE FacTabla.CodCia = s-codcia
          AND FacTabla.Tabla = 'REPOMOTIVO':
          almcrepo.MotReposicion:ADD-LAST(FacTabla.Nombre, FacTabla.Codigo).
      END.
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
  RUN Procesa-Handle IN lh_handle ('Pagina1').

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
  {src/adm/template/snd-list.i "almcrepo"}

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

  IF p-state = 'update-begin':U THEN DO:
      RUN Carga-Temporal.
      RUN Procesa-Handle IN lh_handle ('Pagina2').
      RUN Procesa-Handle IN lh_handle ('Browse').
  END.

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

DEF VAR x-Items AS INT NO-UNDO.

DO WITH FRAME {&FRAME-NAME} :
    x-Items = 0.
    FOR EACH T-DREPO NO-LOCK:
        x-Items = x-Items + 1.
    END.
    IF x-Items > 52 THEN DO:
        MESSAGE 'NO puede haber más de 52 items' VIEW-AS ALERT-BOX ERROR.
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
  DEF VAR s-coddoc AS CHAR INIT "R/A" NO-UNDO.

  IF NOT AVAILABLE almcrepo THEN RETURN 'ADM-ERROR'.

 IF almcrepo.flgest <> 'P' THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  /*IF almcrepo.flgsit <> 'P' THEN DO:*/
  IF LOOKUP(almcrepo.flgsit, 'P,G') = 0 THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  FIND FIRST Almdrepo OF Almcrepo WHERE almdrepo.CanAten > 0 NO-LOCK NO-ERROR.
  IF AVAILABLE Almdrepo THEN DO:
      MESSAGE 'Algunos materiales ya fueron atendidos' SKIP
          'Acceso denegado' VIEW-AS ALERT-BOX WARNING.
      RETURN "ADM-ERROR".
  END.

  x-VtaPuntual = Almcrepo.VtaPuntual.

  {adm/i-DocPssw.i s-CodCia s-CodDoc ""UPD""}

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

