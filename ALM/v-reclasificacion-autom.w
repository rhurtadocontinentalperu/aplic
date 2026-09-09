&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CMOV FOR Almcmov.
DEFINE SHARED TEMP-TABLE T-DDESP LIKE FacDdesp.



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

DEF SHARED VAR s-adm-new-record AS CHAR.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NROSER  AS INTEGER.
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VARIABLE s-FchDoc AS DATE.
DEFINE        VAR F-TPOCMB AS DECIMAL NO-UNDO.
DEFINE SHARED VAR s-status-almacen AS LOG.

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
&Scoped-define EXTERNAL-TABLES Almcmov Almtdocm
&Scoped-define FIRST-EXTERNAL-TABLE Almcmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almcmov, Almtdocm.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almcmov.Observ 
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define DISPLAYED-FIELDS Almcmov.NroRf1 Almcmov.FchDoc ~
Almcmov.usuario Almcmov.Observ 
&Scoped-define DISPLAYED-TABLES Almcmov
&Scoped-define FIRST-DISPLAYED-TABLE Almcmov
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Salida FILL-IN-Estado ~
FILL-IN-Entrada 

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
DEFINE VARIABLE FILL-IN-Entrada AS CHARACTER FORMAT "XXX-XXXXXXX":U 
     LABEL "Entrada" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 16 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Salida AS CHARACTER FORMAT "XXX-XXXXXXX":U 
     LABEL "Salida" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Salida AT ROW 1 COL 11 COLON-ALIGNED WIDGET-ID 24
     Almcmov.NroRf1 AT ROW 1 COL 39 COLON-ALIGNED WIDGET-ID 26
          LABEL "Referencia" FORMAT "XXX-XXXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     FILL-IN-Estado AT ROW 1 COL 79 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     Almcmov.FchDoc AT ROW 1 COL 119 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FILL-IN-Entrada AT ROW 1.81 COL 11 COLON-ALIGNED WIDGET-ID 22
     Almcmov.usuario AT ROW 1.81 COL 119 COLON-ALIGNED WIDGET-ID 20
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     Almcmov.Observ AT ROW 2.62 COL 11 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 56 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.Almcmov,INTEGRAL.Almtdocm
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CMOV B "?" ? INTEGRAL Almcmov
      TABLE: T-DDESP T "SHARED" ? INTEGRAL FacDdesp
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
         HEIGHT             = 3.23
         WIDTH              = 140.
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

/* SETTINGS FOR FILL-IN Almcmov.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Entrada IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Salida IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf1 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN Almcmov.usuario IN FRAME F-Main
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
  {src/adm/template/row-list.i "Almcmov"}
  {src/adm/template/row-list.i "Almtdocm"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almcmov"}
  {src/adm/template/row-find.i "Almtdocm"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Detalle V-table-Win 
PROCEDURE Borra-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR r-Rowid AS ROWID NO-UNDO.

  RLOOP:
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      /* SALIDAS */
      FOR EACH Almdmov OF Almcmov EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
          ASSIGN 
              R-ROWID = ROWID(Almdmov).
          /* RUN ALM\ALMCGSTK (R-ROWID). /* Ingresa al Almacen */ */
          RUN alm/almacstk (R-ROWID).
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.

          RUN ALM\ALMACPR1 (R-ROWID,"D").
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.

          /* RHC 03.04.04 BLOQUEADO, SE ACTUALIZA EN LA NOCHE
          RUN ALM\ALMACPR2 (R-ROWID,"D").
          *************************************************** */
          DELETE Almdmov.
      END.
      /* INGRESOS */
      FOR EACH Almdmov OF B-CMOV EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
          ASSIGN R-ROWID = ROWID(Almdmov).
          RUN ALM\ALMDCSTK (R-ROWID).      /* Descarga del Almacen */
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
          RUN ALM\ALMACPR1 (R-ROWID,"D").        
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.     
          /* RHC 03.04.04 BLOQUEADO, SE ACTUALIZA EN LA NOCHE 
          RUN ALM\ALMACPR2 (R-ROWID,"D").
          *************************************************** */
          DELETE Almdmov.
      END.
      /* DIGITADO */
/*       FOR EACH FacDdesp EXCLUSIVE-LOCK WHERE FacDdesp.CodCia = Almcmov.codcia AND */
/*           FacDdesp.CodAlm = Almcmov.codalm AND                                    */
/*           FacDdesp.TipMov = Almcmov.tipmov AND                                    */
/*           FacDdesp.CodMov = Almcmov.codmov AND                                    */
/*           FacDdesp.NroSer = Almcmov.nroser AND                                    */
/*           FacDdesp.NroDoc = Almcmov.nrodoc:                                       */
/*           DELETE FacDdesp.                                                        */
/*       END.                                                                        */
  END.
                                

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

EMPTY TEMP-TABLE T-DDESP.

FOR EACH Facddesp OF Almcmov NO-LOCK:
    CREATE T-DDESP.
    BUFFER-COPY Facddesp TO T-DDESP.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE N-Itm AS INTEGER NO-UNDO.
  DEF VAR r-Rowid AS ROWID NO-UNDO.
  DEF VAR pComprometido AS DEC.

  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      /* DETALLADO */
      FOR EACH T-DDESP:
          CREATE FacDdesp.
          BUFFER-COPY T-DDESP TO FacDdesp
              ASSIGN
              FacDdesp.CodCia = Almcmov.CodCia 
              FacDdesp.CodAlm = Almcmov.CodAlm 
              FacDdesp.TipMov = Almcmov.TipMov 
              FacDdesp.CodMov = Almcmov.CodMov 
              FacDdesp.NroSer = Almcmov.NroSer 
              FacDdesp.NroDoc = Almcmov.NroDoc.
      END.
      /* SALIDAS ACUMULADAS */
      N-Itm = 0.
      FOR EACH T-DDESP WHERE BY T-DDESP.NroItm:
          FIND Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia 
              AND Almdmov.CodAlm = Almcmov.CodAlm 
              AND Almdmov.TipMov = Almcmov.TipMov 
              AND Almdmov.CodMov = Almcmov.CodMov 
              AND Almdmov.NroSer = Almcmov.NroSer 
              AND Almdmov.NroDoc = Almcmov.NroDoc 
              AND Almdmov.codmat = T-DDESP.codmat
              NO-ERROR.
          IF NOT AVAILABLE Almdmov THEN DO:
              N-Itm = N-Itm + 1.
              CREATE almdmov.
              ASSIGN 
                  Almdmov.CodCia = Almcmov.CodCia 
                  Almdmov.CodAlm = Almcmov.CodAlm 
                  Almdmov.TipMov = Almcmov.TipMov 
                  Almdmov.CodMov = Almcmov.CodMov 
                  Almdmov.NroSer = Almcmov.NroSer 
                  Almdmov.NroDoc = Almcmov.NroDoc 
                  Almdmov.CodMon = Almcmov.CodMon 
                  Almdmov.FchDoc = Almcmov.FchDoc 
                  Almdmov.TpoCmb = Almcmov.TpoCmb
                  Almdmov.codmat = T-DDESP.codmat
                  Almdmov.CodUnd = T-DDESP.CodUnd
                  Almdmov.Factor = 1    /* T-DDESP.Factor*/
                  Almdmov.NroItm = N-Itm
                  Almdmov.CodAjt = ''
                  Almdmov.HraDoc = almcmov.HorSal
                  R-ROWID = ROWID(Almdmov).
          END.
          ASSIGN
              Almdmov.CanDes = Almdmov.CanDes + T-DDESP.CanDes
              Almdmov.ImpCto = Almdmov.ImpCto + T-DDESP.ImpCto
              Almdmov.PreUni = (Almdmov.ImpCto / Almdmov.CanDes).

          RUN alm/almdcstk (R-ROWID).
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

          RUN ALM\ALMACPR1 (R-ROWID,"U").
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      END.
      /* ENTRADAS ACUMULADAS */
      N-Itm = 0.
      FOR EACH T-DDESP WHERE BY T-DDESP.NroItm:
          FIND Almdmov WHERE Almdmov.codcia = B-CMOV.codcia
              AND Almdmov.codalm = B-CMOV.codalm
              AND Almdmov.tipmov = B-CMOV.tipmov
              AND Almdmov.codmov = B-CMOV.codmov
              AND Almdmov.nroser = B-CMOV.nroser
              AND Almdmov.nrodoc = B-CMOV.nrodoc
              AND Almdmov.codmat = T-DDESP.codant
              NO-ERROR.
          IF NOT AVAILABLE Almdmov THEN DO:
              N-Itm = N-Itm + 1.
              CREATE almdmov.
              ASSIGN 
                  Almdmov.CodCia = B-CMOV.CodCia 
                  Almdmov.CodAlm = B-CMOV.CodAlm 
                  Almdmov.TipMov = B-CMOV.TipMov 
                  Almdmov.CodMov = B-CMOV.CodMov 
                  Almdmov.NroSer = B-CMOV.NroSer 
                  Almdmov.NroDoc = B-CMOV.NroDoc 
                  Almdmov.CodMon = B-CMOV.CodMon 
                  Almdmov.FchDoc = B-CMOV.FchDoc 
                  Almdmov.TpoCmb = B-CMOV.TpoCmb
                  Almdmov.codmat = T-DDESP.codant      /* OJO */
                  Almdmov.CodUnd = T-DDESP.CodUnd
                  Almdmov.Factor = T-DDESP.PreBas      /* OJO */
                  Almdmov.NroItm = N-Itm
                  Almdmov.CodAjt = 'A'
                  Almdmov.HraDoc = B-CMOV.HorRcp
                  R-ROWID = ROWID(Almdmov).
          END.
          ASSIGN
              Almdmov.CanDes = Almdmov.CanDes + T-DDESP.CanDes
              Almdmov.ImpCto = Almdmov.ImpCto + T-DDESP.ImpCto
              Almdmov.PreUni = (Almdmov.ImpCto / Almdmov.CanDes).
          /* fin de valorizaciones */
          FIND FIRST Almtmovm WHERE Almtmovm.CodCia = B-CMOV.CodCia 
              AND  Almtmovm.Tipmov = B-CMOV.TipMov 
              AND  Almtmovm.Codmov = B-CMOV.CodMov 
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almtmovm AND Almtmovm.PidPCo 
              THEN ASSIGN Almdmov.CodAjt = "A".
          ELSE ASSIGN Almdmov.CodAjt = ''.
          RUN ALM\ALMACSTK (R-ROWID).
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
          RUN ALM\ALMACPR1 (R-ROWID,"U").
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. 
      END.
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
  IF s-status-almacen = NO THEN DO:
      MESSAGE 'Almacén INACTIVO' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
          AND Almacen.CodAlm = Almtdocm.CodAlm 
          NO-LOCK NO-ERROR.
      FILL-IN-Salida = STRING(s-NroSer,"999") + STRING(Almacen.CorrSal,"9999999").
      FILL-IN-Entrada = STRING(s-NroSer,"999") + STRING(Almacen.CorrIng,"9999999").
      DISPLAY 
          TODAY @ Almcmov.FchDoc
          FILL-IN-Salida
          FILL-IN-Entrada.
      FIND LAST gn-tcmb NO-LOCK.
      f-TPOCMB = gn-tcmb.compra.
      /* Borramos Temporal */
      EMPTY TEMP-TABLE T-DDESP.
      /* ***************** */
      RUN Procesa-Handle IN lh_handle ('Pagina2').
      RUN Procesa-Handle IN lh_handle ('Activa-Boton').
      s-adm-new-record = 'YES'.
      s-FchDoc = TODAY.
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
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN DO:
      FIND B-CMOV WHERE B-CMOV.codcia = s-codcia
          AND B-CMOV.codalm = s-codalm
          AND B-CMOV.tipmov = "I"
          AND B-CMOV.codmov = Almtdocm.codmov
          AND B-CMOV.nroser = INTEGER(SUBSTRING(Almcmov.nroref,1,3))
          AND B-CMOV.nrodoc = INTEGER(SUBSTRING(Almcmov.nroref,4))
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CMOV THEN UNDO, RETURN "ADM-ERROR".
      RUN Borra-Detalle.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN 
      Almcmov.usuario = S-USER-ID.

  RUN Genera-Detalle.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* DESBLOQUEA CORRELATIVOS */
  RELEASE Almacen.

  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('Browse').
  s-adm-new-record = 'NO'.

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
  s-adm-new-record = 'NO'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Pagina1').

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
  /* BLOQUEAMOS Almacen hasta 5 intentos */
  {lib/lock-generico.i &Tabla=Almacen &Condicion="Almacen.CodCia = s-CodCia ~
  AND Almacen.CodAlm = s-CodAlm" ~
  &Bloqueo=EXCLUSIVE-LOCK NO-WAIT ~
  &Accion=RETRY ~
  &Mensaje=YES ~
  &TipoError=""ADM-ERROR""}
  
    /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /* Buscamos un correlativo válido */
  DEF VAR x-CorrSal LIKE Almacen.CorrSal NO-UNDO.
  DEF VAR x-CorrIng LIKE Almacen.CorrIng NO-UNDO.

  SALIDAS:
  REPEAT:
      ASSIGN
          x-CorrSal = Almacen.CorrSal.
      IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia 
                      AND Almcmov.codalm = Almtdocm.CodAlm
                      AND Almcmov.tipmov = "S"
                      AND Almcmov.codmov = Almtdocm.CodMov
                      AND Almcmov.nroser = s-NroSer
                      AND Almcmov.nrodoc = x-CorrSal
                      NO-LOCK)
          THEN LEAVE.
      ASSIGN
          Almacen.CorrSal = Almacen.CorrSal + 1.
  END.
  INGRESOS:
  REPEAT:
      ASSIGN
          x-CorrIng = Almacen.CorrIng.
      IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia 
                      AND Almcmov.codalm = Almtdocm.CodAlm
                      AND Almcmov.tipmov = "I"
                      AND Almcmov.codmov = Almtdocm.CodMov
                      AND Almcmov.nroser = s-NroSer
                      AND Almcmov.nrodoc = x-CorrIng
                      NO-LOCK)
          THEN LEAVE.
      ASSIGN
          Almacen.CorrIng = Almacen.CorrIng + 1.
  END.
  /* MOVIMIENTO DE SALIDA */
  ASSIGN 
      Almcmov.CodCia = Almtdocm.CodCia 
      Almcmov.CodAlm = Almtdocm.CodAlm 
      Almcmov.TipMov = Almtdocm.TipMov
      Almcmov.CodMov = Almtdocm.CodMov
      Almcmov.NroSer = S-NROSER
      Almcmov.Nrodoc  = Almacen.CorrSal
      Almcmov.HorSal = STRING(TIME,"HH:MM:SS")
      Almcmov.TpoCmb  = F-TPOCMB.
  /* MOVIMIENTO DE ENTRADA */
  CREATE B-CMOV.
  BUFFER-COPY Almcmov 
      TO B-CMOV
      ASSIGN
      B-CMOV.TipMov = "I"
      B-CMOV.Nrodoc = Almacen.CorrIng
      B-CMOV.NroRef = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '9999999').
  ASSIGN 
      Almcmov.NroRef = STRING(B-CMOV.nroser, '999') + STRING(B-CMOV.nrodoc, '9999999')
      Almacen.CorrSal = Almacen.CorrSal + 1
      Almacen.CorrIng = Almacen.CorrIng + 1.

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
  RUN valida-update.
  RUN Procesa-Handle IN lh_handle ('Pagina1').
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

/* BLOQUEADO 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
****************** */  

  /* Code placed here will execute AFTER standard behavior.    */
  /* Solo marcamos el FlgEst como Anulado */
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND CURRENT Almcmov EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN 
          Almcmov.FlgEst = 'A'
          Almcmov.Observ = "      A   N   U   L   A   D   O       "
          Almcmov.Usuario = S-USER-ID.
      /* RHC 12/02/2018 Cambiamos el estado del I-03 de referencia */
      IF Almcmov.NroRf1 > '' THEN DO:
          FIND B-CMOV WHERE B-CMOV.codcia = Almcmov.codcia
              AND B-CMOV.codalm = Almcmov.codalm
              AND B-CMOV.tipmov = "I"
              AND B-CMOV.codmov = 03
              AND B-CMOV.nroser = INTEGER(SUBSTRING(Almcmov.nrorf1,1,3))
              AND B-CMOV.nrodoc = INTEGER(SUBSTRING(Almcmov.nrorf1,4))
              EXCLUSIVE-LOCK NO-ERROR.
          IF ERROR-STATUS:ERROR THEN DO:
              RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
              UNDO, RETURN 'ADM-ERROR'.
          END.
          ASSIGN
              B-CMOV.FlgEst = "".
          RELEASE B-CMOV.
      END.
      FIND B-CMOV WHERE B-CMOV.codcia = Almcmov.codcia
          AND B-CMOV.codalm = Almcmov.codalm
          AND B-CMOV.tipmov = "I"
          AND B-CMOV.codmov = Almcmov.codmov
          AND B-CMOV.nroser = INTEGER(SUBSTRING(Almcmov.nroref,1,3))
          AND B-CMOV.nrodoc = INTEGER(SUBSTRING(Almcmov.nroref,4))
          EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN 
          B-CMOV.FlgEst = 'A'
          B-CMOV.Observ = "      A   N   U   L   A   D   O       "
          B-CMOV.Usuario = S-USER-ID.
      RUN Borra-Detalle.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.  
      FIND CURRENT Almcmov NO-LOCK.
      RELEASE B-CMOV.
      /* refrescamos los datos del viewer */
      RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
      /* refrescamos los datos del browse */
      RUN Procesa-Handle IN lh_Handle ('browse').
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
  IF AVAILABLE almcmov THEN DO WITH FRAME {&FRAME-NAME}:
      DISPLAY
          STRING(almcmov.nroser, '999') + STRING(almcmov.nrodoc, '9999999') @ FILL-IN-Salida
          almcmov.nroref @ fill-in-Entrada.
      RUN Carga-Temporal.
      CASE Almcmov.FlgEst:
          WHEN "A" THEN FILL-IN-Estado:SCREEN-VALUE = "ANULADO".
          OTHERWISE FILL-IN-Estado:SCREEN-VALUE = "".
      END CASE.
      RUN Procesa-Handle IN lh_handle ('browse').
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
  {src/adm/template/snd-list.i "Almcmov"}
  {src/adm/template/snd-list.i "Almtdocm"}

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
  IF s-status-almacen = NO THEN DO:
      MESSAGE 'Almacén INACTIVO' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

  DEFINE VAR RPTA AS CHAR.

  IF NOT AVAILABLE Almcmov THEN  RETURN "ADM-ERROR".
  IF Almcmov.FlgEst = 'A' THEN DO:
    MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
  END.
  /* RHC 12/02/18 Viene de una reclasificación automática de kit slista express */
  IF Almcmov.NroRf1 > '' THEN DO:
      MESSAGE "Acceso Denegado" VIEW-AS ALERT-BOX WARNING.
      RETURN "ADM-ERROR".
  END.
  /* consistencias */
  IF s-user-id <> "ADMIN" THEN DO:
      RUN alm/p-ciealm-01 (Almcmov.FchDoc, Almcmov.CodAlm).
      IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN "ADM-ERROR".
      FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
        AND Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
      RUN ALM/D-CLAVE.R(Almacen.Clave,OUTPUT RPTA).
      IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
      /* consistencia de la fecha del cierre del sistema */
      DEF VAR dFchCie AS DATE.
      RUN gn/fecha-de-cierre (OUTPUT dFchCie).
      IF almcmov.fchdoc <= dFchCie THEN DO:
          MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.
  /* fin de consistencia */

  F-TPOCMB = Almcmov.TpoCmb.
  s-adm-new-record = 'NO'.
  s-FchDoc = Almcmov.FchDoc.
  RUN Carga-Temporal.
  RUN Procesa-Handle IN lh_handle ('Pagina2').
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

