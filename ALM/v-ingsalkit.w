&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CMOV FOR Almcmov.
DEFINE SHARED TEMP-TABLE T-INGKIT NO-UNDO LIKE Almdmov.
DEFINE SHARED TEMP-TABLE T-SALKIT NO-UNDO LIKE Almdmov.



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
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR S-NROSER AS INTEGER.
DEF SHARED VAR S-TIPMOV AS CHAR.
DEF SHARED VAR S-MOVING AS INT.
DEF SHARED VAR S-MOVSAL AS INT.
DEF SHARED VAR lh_handle AS HANDLE.
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
&Scoped-define EXTERNAL-TABLES Almcmov
&Scoped-define FIRST-EXTERNAL-TABLE Almcmov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Almcmov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Almcmov.Observ 
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define DISPLAYED-FIELDS Almcmov.NroDoc Almcmov.FchDoc ~
Almcmov.usuario Almcmov.Observ Almcmov.NroRf3 
&Scoped-define DISPLAYED-TABLES Almcmov
&Scoped-define FIRST-DISPLAYED-TABLE Almcmov


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
     Almcmov.NroDoc AT ROW 1 COL 12 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     Almcmov.FchDoc AT ROW 1 COL 73 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almcmov.usuario AT ROW 1.81 COL 73 COLON-ALIGNED WIDGET-ID 24
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almcmov.Observ AT ROW 2.62 COL 12 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 50 BY .81
     Almcmov.NroRf3 AT ROW 2.62 COL 73 COLON-ALIGNED WIDGET-ID 26
          LABEL "Referencia" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.Almcmov
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CMOV B "?" ? INTEGRAL Almcmov
      TABLE: T-INGKIT T "SHARED" NO-UNDO INTEGRAL Almdmov
      TABLE: T-SALKIT T "SHARED" NO-UNDO INTEGRAL Almdmov
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
         WIDTH              = 93.57.
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
/* SETTINGS FOR FILL-IN Almcmov.NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf3 IN FRAME F-Main
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

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Almcmov"}

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

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
    /* INGRESOS */
    FOR EACH Almdmov OF Almcmov:
        ASSIGN R-ROWID = ROWID(Almdmov).
        RUN ALM\ALMDCSTK (R-ROWID).      /* Descarga del Almacen */
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        RUN ALM\ALMACPR1 (R-ROWID,"D").        
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.     
        /* RHC 03.04.04 BLOQUEADO, SE ACTUALIZA EN LA NOCHE 
        RUN ALM\ALMACPR2 (R-ROWID,"D").
        *************************************************** */
        DELETE Almdmov.
    END.

    /* SALIDAS */
    FOR EACH Almdmov OF B-cmov:
      ASSIGN R-ROWID = ROWID(Almdmov).
      /* RUN ALM\ALMCGSTK (R-ROWID). /* Ingresa al Almacen */ */
      RUN alm/almacstk (R-ROWID).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      RUN ALM\ALMACPR1 (R-ROWID,"D").
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      /* RHC 03.04.04 BLOQUEADO, SE ACTUALIZA EN LA NOCHE
      RUN ALM\ALMACPR2 (R-ROWID,"D").
      *************************************************** */
      DELETE Almdmov.
    END.
END.


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

FOR EACH T-INGKIT:
    DELETE T-INGKIT.
END.
FOR EACH T-SALKIT:
    DELETE T-SALKIT.
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
RUN Borra-Temporal.

FOR EACH Almdmov OF Almcmov NO-LOCK:
    CREATE T-INGKIT.
    BUFFER-COPY Almdmov TO T-INGKIT.
END.
FOR EACH Almdmov WHERE Almdmov.codcia = s-codcia
    AND Almdmov.codalm = s-codalm
    AND Almdmov.tipmov = 'S'
    AND Almdmov.codmov = s-MovSal
    AND Almdmov.nroser = INTEGER(SUBSTRING(almcmov.nrorf3,1,3))
    AND Almdmov.nrodoc = INTEGER(SUBSTRING(Almcmov.nrorf3,4))
    NO-LOCK:
    CREATE T-SALKIT.
    BUFFER-COPY Almdmov TO T-SALKIT.
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
DEFINE VAR r-Rowid AS ROWID NO-UNDO.
DEF VAR x-NroItm LIKE Almdmov.nroitm NO-UNDO.
DEF VAR x-Importe AS DEC NO-UNDO.

/* INGRESOS */
x-NroItm = 1.
FOR EACH T-INGKIT WHERE T-INGKIT.codmat <> "" BY T-INGKIT.NroItm
        ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
    CREATE almdmov.
    BUFFER-COPY T-INGKIT TO almdmov.
    ASSIGN 
        Almdmov.CodCia = Almcmov.CodCia 
        Almdmov.CodAlm = Almcmov.CodAlm 
        Almdmov.TipMov = Almcmov.TipMov 
        Almdmov.CodMov = Almcmov.CodMov 
        Almdmov.NroSer = Almcmov.NroSer 
        Almdmov.NroDoc = Almcmov.NroDoc 
        Almdmov.CodMon = Almcmov.CodMon 
        Almdmov.FchDoc = Almcmov.FchDoc 
        Almdmov.HraDoc = Almcmov.HorRcp
        Almdmov.TpoCmb = Almcmov.TpoCmb
        R-ROWID = ROWID(Almdmov)
        Almdmov.NroItm = x-NroItm.
    FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almcmov.CodCia 
        AND  Almtmovm.Tipmov = Almcmov.TipMov 
        AND  Almtmovm.Codmov = Almcmov.CodMov 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtmovm AND Almtmovm.PidPCo 
    THEN ASSIGN Almdmov.CodAjt = "A".
    ELSE ASSIGN Almdmov.CodAjt = ''.
    RUN ALM\ALMACSTK (R-ROWID).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    RUN ALM\ALMACPR1 (R-ROWID,"U").
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. 
    /* RHC 03.04.04 BLOQUEADO, SE ACTUALIZA EN LA NOCHE
    RUN ALM\ALMACPR2 (R-ROWID,"U").
    *************************************************** */
    /* VALORIZACION DEL KIT */
    x-Importe = 0.
    FOR EACH Almdkits WHERE Almdkits.codcia = s-codcia
        AND Almdkits.codmat = Almdmov.codmat NO-LOCK,
        FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = Almdkits.codmat2 NO-LOCK:
        FIND LAST Almstkge WHERE Almstkge.codcia = s-codcia
            AND Almstkge.codmat = Almmmatg.codmat
            AND Almstkge.fecha <= Almdmov.fchdoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almstkge THEN DO:
            x-Importe = x-Importe + ( AlmDKits.Cantidad  * Almdmov.candes * AlmStkge.CtoUni ).
        END.
    END.
    ASSIGN
        Almdmov.PreUni = x-Importe / Almdmov.candes
        Almdmov.ImpCto = x-Importe.
    /* ******************** */
    RELEASE Almdmov.
    x-NroItm = x-NroItm + 1.
END.

/* SALIDAS */
x-NroItm = 1.
FOR EACH T-SALKIT WHERE T-SALKIT.codmat <> "" BY T-SALKIT.NroItm
        ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
    CREATE almdmov.
    BUFFER-COPY T-SALKIT TO almdmov.
    ASSIGN 
        Almdmov.CodCia = B-cmov.CodCia 
        Almdmov.CodAlm = B-cmov.CodAlm 
        Almdmov.TipMov = B-cmov.TipMov 
        Almdmov.CodMov = B-cmov.CodMov 
        Almdmov.NroSer = B-cmov.NroSer 
        Almdmov.NroDoc = B-cmov.NroDoc 
        Almdmov.CodMon = B-cmov.CodMon 
        Almdmov.FchDoc = B-cmov.FchDoc 
        Almdmov.HraDoc = B-cmov.HorRcp
        Almdmov.TpoCmb = B-cmov.TpoCmb
        Almdmov.CodAjt = ''
        R-ROWID = ROWID(Almdmov)
        Almdmov.NroItm = x-NroItm.
    /* RUN ALM\ALMDGSTK (R-ROWID). */
    RUN alm/almdcstk (R-ROWID).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    RUN ALM\ALMACPR1 (R-ROWID,"U").
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    /* RHC 03.04.04 BLOQUEADO, SE ACTUALIZA EN LA NOCHE
    RUN ALM\ALMACPR2 (R-ROWID,"U").
    *************************************************** */
    RELEASE Almdmov.
    x-NroItm = x-NroItm + 1.
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
  RUN Borra-Temporal.
  DO WITH FRAME {&FRAME-NAME}:
      FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
          AND Almacen.CodAlm = s-CodAlm 
          NO-LOCK NO-ERROR.
      DISPLAY
          TODAY @ Almcmov.FchDoc 
          Almacen.corring @ Almcmov.NroDoc
          s-User-Id @ Almcmov.usuario.
  END.
  RUN Procesa-handle IN lh_handle ('pagina2').

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
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO :
      FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
          AND  Almacen.CodAlm = s-CodAlm 
          EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
      /* MOVIMIENTO DE INGRESO */
      ASSIGN 
          Almcmov.NroDoc  = Almacen.CorrIng
          Almacen.CorrIng = Almacen.CorrIng + 1
          Almcmov.CodCia  = s-CodCia 
          Almcmov.CodAlm  = s-CodAlm 
          Almcmov.TipMov  = s-TipMov
          Almcmov.CodMov  = s-MovIng
          Almcmov.NroSer  = s-NroSer
          Almcmov.FchDoc  = TODAY
          Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS").
      /* MOVIMIENTO DE SALIDA */
      CREATE B-cmov.
      ASSIGN 
          B-cmov.NroDoc  = Almacen.CorrSal
          Almacen.CorrSal = Almacen.CorrSal + 1
          B-cmov.CodCia  = s-CodCia 
          B-cmov.CodAlm  = s-CodAlm 
          B-cmov.TipMov  = 'S'
          B-cmov.CodMov  = s-MovSal
          B-cmov.NroSer  = s-NroSer
          B-cmov.FchDoc  = TODAY
          B-cmov.HorRcp  = STRING(TIME,"HH:MM:SS")
          B-cmov.Observ  = Almcmov.Observ.
      /* RELACION CRUZADA */
      ASSIGN
          Almcmov.NroRf3 = STRING(B-cmov.nroser, '999') + STRING(B-cmov.nrodoc, '999999')
          B-cmov.NroRf3 = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '999999').
  END.
  ELSE DO:
      FIND B-cmov WHERE B-cmov.codcia = Almcmov.codcia
          AND B-cmov.codalm = Almcmov.codalm
          AND B-cmov.tipmov = 'S'
          AND B-cmov.codmov = s-MovSal
          AND B-cmov.nroser = INTEGER(SUBSTRING(Almcmov.nrorf3,1,3))
          AND B-cmov.nrodoc = INTEGER(SUBSTRING(Almcmov.nrorf3,4))
          EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
          MESSAGE 'No se pudo bloquear el movimiento de salida' s-MovSal Almcmov.nrorf3
              VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      RUN Borra-Detalle.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  ASSIGN 
      Almcmov.usuario = S-USER-ID
      B-cmov.usuario = S-USER-ID.

  /* GENERAMOS NUEVO DETALLE */
  RUN Genera-Detalle.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RELEASE Almacen.

  RUN dispatch IN THIS-PROCEDURE ('display-fields').
  RUN Procesa-handle IN lh_handle ('pagina1').

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
  RUN Procesa-handle IN lh_handle ('pagina1').

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
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
/*   RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */
  /* Solo marcamos el FlgEst como Anulado */
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND B-cmov WHERE B-cmov.codcia = Almcmov.codcia
          AND B-cmov.codalm = Almcmov.codalm
          AND B-cmov.tipmov = 'S'
          AND B-cmov.codmov = s-MovSal
          AND B-cmov.nroser = INTEGER(SUBSTRING(Almcmov.nrorf3,1,3))
          AND B-cmov.nrodoc = INTEGER(SUBSTRING(Almcmov.nrorf3,4))
          EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
          MESSAGE 'No se pudo bloquear el movimiento de salida' s-MovSal Almcmov.nrorf3
              VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      RUN Borra-Detalle.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      FIND CURRENT Almcmov EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
          MESSAGE 'No se pudo bloquear el movimiento de ingreso'
              VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      ASSIGN 
          Almcmov.FlgEst = 'A'
          Almcmov.Observ = "      A   N   U   L   A   D   O       "
          Almcmov.Usuario = S-USER-ID.
      ASSIGN 
          B-cmov.FlgEst = 'A'
          B-cmov.Observ = "      A   N   U   L   A   D   O       "
          B-cmov.Usuario = S-USER-ID.
      RELEASE B-cmov.
     FIND CURRENT Almcmov NO-LOCK.
  END.
  RUN Procesa-Handle IN lh_handle ('pagina1').
  RUN dispatch IN THIS-PROCEDURE ('display-fields').

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
  RUN Carga-Temporal.
  RUN Procesa-handle IN lh_handle ('browse').

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
  {src/adm/template/snd-list.i "Almcmov"}

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
      RUN Procesa-Handle IN lh_Handle ('pagina2').
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
DEF VAR pComprometido AS DEC NO-UNDO.
DEF VAR pStkACt LIKE Almmmate.stkact NO-UNDO.

DO WITH FRAME {&FRAME-NAME} :
    FOR EACH T-SALKIT:
        FIND Almmmate WHERE Almmmate.codcia = s-codcia
            AND Almmmate.codalm = s-codalm
            AND Almmmate.codmat = T-SALKIT.codmat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN DO:
            MESSAGE 'Artículo' T-SALKIT.codmat 'no registrado en el almacén' s-codalm
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        RUN gn/stock-comprometido (Almmmate.codmat, Almmmate.codalm, OUTPUT pComprometido).
        pStkAct = Almmmate.StkAct.
        RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
        IF RETURN-VALUE = 'NO' THEN DO:
            FIND Almdmov WHERE Almdmov.codcia = s-codcia
                AND Almdmov.codalm = s-codalm
                AND Almdmov.codmat = T-SALKIT.codmat
                AND Almdmov.tipmov = 'S'
                AND Almdmov.codmov = s-MovSal
                AND Almdmov.nroser = INTEGER(SUBSTRING(Almcmov.nrorf3,1,3))
                AND Almdmov.nrodoc = INTEGER(SUBSTRING(Almcmov.nrorf3,4))
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almdmov THEN pStkAct = pStkAct  + ( Almdmov.candes * Almdmov.factor).
        END.
        IF (T-SALKIT.CanDes * T-SALKIT.Factor) > (pStkAct - pComprometido) THEN DO:
            MESSAGE 'NO se puede transferir mas de' (pStkAct - pComprometido) SKIP
                'Código:' T-SALKIT.codmat
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
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

DEFINE VAR RPTA AS CHAR.

IF NOT AVAILABLE Almcmov THEN  RETURN "ADM-ERROR".

IF Almcmov.FlgEst = 'A' THEN DO:
   MESSAGE "Documento Anulado" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.

RUN alm/p-ciealm-01 (Almcmov.FchDoc, s-CodAlm).
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN "ADM-ERROR".

/* consistencia de la fecha del cierre del sistema */
DEF VAR dFchCie AS DATE.
RUN gn/fecha-de-cierre (OUTPUT dFchCie).
IF almcmov.fchdoc <= dFchCie THEN DO:
    MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
        VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
/* fin de consistencia */
IF Almcmov.fchdoc <> TODAY  THEN DO:
    FIND Almacen WHERE Almacen.CodCia = S-CODCIA
        AND Almacen.CodAlm = S-CODALM
        NO-LOCK NO-ERROR.
    RUN ALM/D-CLAVE.R(Almacen.Clave,OUTPUT RPTA).
    IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

