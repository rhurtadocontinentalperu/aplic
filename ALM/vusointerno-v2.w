&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE DDOCU LIKE AlmDDocu.



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
DEF SHARED VAR cb-codcia AS INT.
/*DEF SHARED VAR s-coddiv AS CHAR.*/
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-nroser AS INT.
DEF SHARED VAR lh_Handle AS HANDLE.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-adm-new-record AS CHAR.
DEF SHARED VAR s-Cco AS CHAR.

/* VARIABLES PARA EL EXCEL */
DEFINE VARIABLE chExcelApplication  AS COM-HANDLE.
DEFINE VARIABLE chWorkbook          AS COM-HANDLE.
DEFINE VARIABLE chWorksheet         AS COM-HANDLE.
DEFINE VARIABLE cRange          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCountLine      AS INTEGER      NO-UNDO.
DEFINE VARIABLE iTotalColumn    AS INTEGER      NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
/*DEFINE VARIABLE t-Column        AS INTEGER INIT 1.*/
DEFINE VARIABLE t-Row           AS INTEGER INIT 1.

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
&Scoped-define EXTERNAL-TABLES AlmCDocu
&Scoped-define FIRST-EXTERNAL-TABLE AlmCDocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR AlmCDocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS AlmCDocu.FchDoc AlmCDocu.UsrCreacion ~
AlmCDocu.Libre_c05 AlmCDocu.Libre_c02 AlmCDocu.Libre_c01 
&Scoped-define ENABLED-TABLES AlmCDocu
&Scoped-define FIRST-ENABLED-TABLE AlmCDocu
&Scoped-Define DISPLAYED-FIELDS AlmCDocu.FchDoc AlmCDocu.UsrCreacion ~
AlmCDocu.Libre_c05 AlmCDocu.Libre_c02 AlmCDocu.Libre_c01 
&Scoped-define DISPLAYED-TABLES AlmCDocu
&Scoped-define FIRST-DISPLAYED-TABLE AlmCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_NroDoc F-Estado FILL-IN-NomUsr ~
FILL-IN-NomAlm 

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
DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "ESTADO" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomUsr AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroDoc AS INTEGER FORMAT "99999999" INITIAL 0 
     LABEL "Numero" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN_NroDoc AT ROW 1 COL 13 COLON-ALIGNED WIDGET-ID 8
     F-Estado AT ROW 1 COL 33 COLON-ALIGNED WIDGET-ID 114
     AlmCDocu.FchDoc AT ROW 1 COL 66 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     AlmCDocu.UsrCreacion AT ROW 1.81 COL 13 COLON-ALIGNED WIDGET-ID 10
          LABEL "Solicitado por" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     FILL-IN-NomUsr AT ROW 1.81 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 116
     AlmCDocu.Libre_c05 AT ROW 2.62 COL 13 COLON-ALIGNED WIDGET-ID 124
          LABEL "Centro de Costo" FORMAT "x(8)"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Item 1","Item 1"
          DROP-DOWN-LIST
          SIZE 51 BY 1
     AlmCDocu.Libre_c02 AT ROW 3.42 COL 13 COLON-ALIGNED WIDGET-ID 120
          LABEL "Almacén" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     FILL-IN-NomAlm AT ROW 3.42 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 122
     AlmCDocu.Libre_c01 AT ROW 4.23 COL 13 COLON-ALIGNED WIDGET-ID 6
          LABEL "Observaciones" FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 51 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.AlmCDocu
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: DDOCU T "SHARED" ? INTEGRAL AlmDDocu
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
         WIDTH              = 86.43.
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
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomUsr IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN AlmCDocu.Libre_c01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN AlmCDocu.Libre_c02 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR COMBO-BOX AlmCDocu.Libre_c05 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN AlmCDocu.UsrCreacion IN FRAME F-Main
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

&Scoped-define SELF-NAME AlmCDocu.Libre_c02
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL AlmCDocu.Libre_c02 V-table-Win
ON LEAVE OF AlmCDocu.Libre_c02 IN FRAME F-Main /* Almacén */
DO:
    FIND almacen WHERE almacen.codcia = s-codcia
        AND almacen.codalm = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE almacen THEN FILL-IN-NomAlm:SCREEN-VALUE = almacen.descrip.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME AlmCDocu.UsrCreacion
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL AlmCDocu.UsrCreacion V-table-Win
ON LEAVE OF AlmCDocu.UsrCreacion IN FRAME F-Main /* Solicitado por */
DO:
  FIND _User WHERE _User._UserId = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE _User THEN FILL-IN-NomUsr:SCREEN-VALUE = _User._User-name.
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
  {src/adm/template/row-list.i "AlmCDocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "AlmCDocu"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Pedido V-table-Win 
PROCEDURE Borra-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FOR EACH AlmDDocu OF AlmCDocu TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' 
      ON STOP UNDO, RETURN 'ADM-ERROR':
      DELETE AlmDDocu.
  END.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal V-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE DDOCU.

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

EMPTY TEMP-TABLE DDOCU.

FOR EACH AlmDDocu OF AlmCDocu NO-LOCK:
    CREATE DDOCU.
    BUFFER-COPY AlmDDocu TO DDOCU.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Copia-Temporal V-table-Win 
PROCEDURE Copia-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE DDOCU.

FOR EACH AlmDDocu OF AlmCDocu NO-LOCK:
    CREATE DDOCU.
    ASSIGN
        DDOCU.CodCia = Almddocu.codcia
        DDOCU.Codigo = Almddocu.codigo
        DDOCU.Libre_d01 = Almddocu.libre_d01
        DDOCu.Tipo   = "A"    /* Artículos */
        DDOCU.NroItm = Almddocu.NroItm.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK.
  FIND VtaTabla WHERE VtaTabla.codcia = s-codcia
      AND VtaTabla.tabla = s-coddoc
      AND VtaTabla.llave_c1 = s-user-id
      NO-LOCK.
  ASSIGN
      s-adm-new-record = "YES".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY 
          "" @ F-Estado
          TODAY @ AlmCDocu.FchDoc
          s-user-id @ INTEGRAL.AlmCDocu.UsrCreacion
          VtaTabla.llave_c4 @ AlmCDocu.Libre_c02.
      AlmCDocu.Libre_c05:SCREEN-VALUE = ENTRY(1,s-Cco).
      RUN Borra-Temporal.
      RUN Procesa-Handle IN lh_Handle ('Pagina2').
      APPLY 'LEAVE':U TO AlmCDocu.UsrCreacion.
      APPLY 'LEAVE':U TO AlmCDocu.Libre_c02.
      APPLY 'ENTRY':U TO AlmCDocu.Libre_c01.
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
  DEFINE VARIABLE I-NroDoc AS INTEGER NO-UNDO.
  DEFINE VARIABLE C-NroDoc AS CHAR NO-UNDO.
  DEFINE VARIABLE I-NDDOCU AS INTEGER NO-UNDO INIT 0.

  DEF BUFFER B-CDOCU FOR Almcdocu.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      ASSIGN
          AlmCDocu.CodLlave = S-USER-ID.    /* OJO */
      /* El correlativo va a ser armado */
      FIND LAST B-CDOCU USE-INDEX llave01 WHERE B-CDOCU.codcia = s-codcia
          AND B-CDOCU.CodLlave = Almcdocu.CodLlave
          AND B-CDOCU.coddoc = s-coddoc
          AND B-CDOCU.nrodoc BEGINS Almcdocu.CodLlave + STRING(YEAR(TODAY), '9999')
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CDOCU THEN I-NroDoc = 1.
      ELSE I-NroDoc = INTEGER(SUBSTRING(B-CDOCU.nrodoc, LENGTH(Almcdocu.CodLlave) + 4 + 1)).
      REPEAT:
          C-NroDoc = Almcdocu.CodLlave + STRING(YEAR(TODAY), '9999') + STRING(I-NroDoc, '9999').
          IF NOT CAN-FIND(FIRST Almcdocu WHERE Almcdocu.codcia = s-codcia
                          AND AlmCDocu.CodLlave = Almcdocu.CodLlave
                          AND Almcdocu.coddoc = s-coddoc
                          AND Almcdocu.nrodoc = C-NroDoc NO-LOCK)
              THEN LEAVE.
          I-NroDoc = I-NroDoc + 1.
      END.
      /*{vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}*/
      ASSIGN 
          AlmCDocu.CodCia = S-CODCIA
          AlmCDocu.CodDoc = s-coddoc 
          AlmCDocu.FchDoc = TODAY 
          AlmCDocu.NroDoc = C-NroDoc
          AlmCDocu.FlgEst = "T".    /* EN REVISION */
      ASSIGN 
          AlmCDocu.UsrCreacion = S-USER-ID.
  END.
  ELSE DO:
      RUN Borra-Pedido.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.

  FOR EACH DDOCU BY DDOCU.NroItm: 
      I-NDDOCU = I-NDDOCU + 1.
      CREATE AlmDDocu.
      BUFFER-COPY DDOCU 
          TO AlmDDocu
          ASSIGN
              AlmDDocu.CodCia = AlmCDocu.CodCia
              AlmDDocu.CodLlave = AlmCDocu.CodLlave
              AlmDDocu.coddoc = AlmCDocu.coddoc
              AlmDDocu.NroDoc = AlmCDocu.NroDoc
              AlmDDocu.Libre_d02 = AlmDDocu.Libre_d01   /* Aprobado = Solicitado */
              AlmDDocu.NroItm = I-NDDOCU.
  END.
  IF AVAILABLE(AlmDDocu) THEN RELEASE AlmDDocu.

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
  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('Browse').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK.
  FIND VtaTabla WHERE VtaTabla.codcia = s-codcia
      AND VtaTabla.tabla = s-coddoc
      AND VtaTabla.llave_c1 = s-user-id
      NO-LOCK.
  ASSIGN
      s-adm-new-record = "YES".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY 
          "" @ F-Estado
          TODAY @ AlmCDocu.FchDoc
          s-user-id @ AlmCDocu.UsrCreacion
      AlmCDocu.Libre_c05:SCREEN-VALUE = ENTRY(1,s-Cco).
      RUN Copia-Temporal.
      RUN Procesa-Handle IN lh_Handle ('Pagina2').
      APPLY 'LEAVE':U TO AlmCDocu.UsrCreacion.
      APPLY 'ENTRY':U TO AlmCDocu.Libre_c01.
  END.

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
  IF NOT AVAILABLE AlmCDocu THEN RETURN "ADM-ERROR".
  IF LOOKUP(AlmCDocu.FlgEst,"T") = 0 THEN DO:
      MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND CURRENT AlmCDocu EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE AlmCDocu THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN                 
          AlmCDocu.UsrAnulacion = s-user-id
          AlmCDocu.FchAnulacion = TODAY
          AlmCDocu.FlgEst = 'A'
          AlmCDocu.Libre_c01 = "ANULADO POR: " + TRIM (s-user-id) + " EL DIA: " + STRING(TODAY) + " " + STRING(TIME, 'HH:MM').
      FIND CURRENT AlmCDocu NO-LOCK.
      RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
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
  IF AVAILABLE AlmCDocu THEN DO WITH FRAME {&FRAME-NAME}:
      DISPLAY INTEGER(SUBSTRING(AlmCDocu.nrodoc, LENGTH(Almcdocu.CodLlave) + 1))
          @ FILL-IN_NroDoc.
      RUN vta2/p-faccpedi-flgest (AlmCDocu.flgest, AlmCDocu.coddoc, OUTPUT f-Estado).
      DISPLAY f-Estado.
      FIND _User WHERE _User._UserId = AlmCDocu.UsrCreacion NO-LOCK NO-ERROR.
      IF AVAILABLE _User THEN FILL-IN-NomUsr:SCREEN-VALUE = _User._User-name.
      FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia
          AND cb-auxi.clfaux = "CCO"
          AND cb-auxi.codaux = AlmCDocu.CodLlave NO-LOCK NO-ERROR.
      /*IF AVAILABLE cb-auxi THEN FILL-IN-NomAux:SCREEN-VALUE = cb-auxi.nomaux.*/
      FIND almacen WHERE almacen.codcia = s-codcia
          AND almacen.codalm = AlmCDocu.Libre_c02 NO-LOCK NO-ERROR.
      IF AVAILABLE almacen THEN FILL-IN-NomAlm:SCREEN-VALUE = almacen.descrip.
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
      ASSIGN
          AlmCDocu.UsrCreacion:SENSITIVE = NO
          AlmCDocu.FchDoc:SENSITIVE = NO
          /*AlmCDocu.CodLlave:SENSITIVE = NO*/
          AlmCDocu.Libre_c02:SENSITIVE = NO.
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
  DEF VAR k AS INT NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
      /* RHC 10/03/17 Cargamos Centros de Costo */
      AlmCDocu.Libre_c05:DELETE(AlmCDocu.Libre_c05:LIST-ITEM-PAIRS).
      DO k = 1 TO NUM-ENTRIES(s-Cco):
          FIND Cb-auxi WHERE Cb-auxi.codcia = cb-codcia
              AND Cb-auxi.clfaux = 'CCO'
              AND Cb-auxi.codaux = ENTRY(k,s-Cco)
              NO-LOCK NO-ERROR.
          IF AVAILABLE Cb-auxi THEN AlmCDocu.Libre_c05:ADD-LAST(Cb-auxi.nomaux,Cb-auxi.codaux).
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
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  {src/adm/template/snd-list.i "AlmCDocu"}

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

  DEFINE VARIABLE F-TOT AS DECIMAL INIT 0 NO-UNDO.
  DEFINE VARIABLE F-BOL AS DECIMAL INIT 0 NO-UNDO.

  DO WITH FRAME {&FRAME-NAME} :
     /* VALIDACION DE DDOCUS */
     FOR EACH DDOCU NO-LOCK:
         F-Tot = F-Tot + 1.
     END.
     IF F-Tot = 0 THEN DO:
        MESSAGE "NO hay items registrados" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO AlmCDocu.Libre_c01.
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

DEFINE VAR RPTA AS CHAR.

IF NOT AVAILABLE AlmCDocu THEN RETURN "ADM-ERROR".
IF LOOKUP(AlmCDocu.FlgEst,"T") = 0 THEN DO:
    MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
ASSIGN
    s-adm-new-record = "NO".

RUN Carga-Temporal.

RUN Procesa-Handle IN lh_Handle ('Pagina2').
RUN Procesa-Handle IN lh_Handle ('browse').

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

