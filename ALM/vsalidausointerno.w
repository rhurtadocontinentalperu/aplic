&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
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
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODALM  AS CHAR.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NROSER  AS INTEGER.
DEFINE SHARED VAR CB-CODCIA AS INT.

DEFINE        VAR I-CODMON AS INTEGER NO-UNDO.
DEFINE        VAR R-ROWID  AS ROWID   NO-UNDO.
DEFINE        VAR F-TPOCMB AS DECIMAL NO-UNDO.

DEFINE        VAR S-ITEM   AS INTEGER INIT 0.
DEFINE        VAR F-DIRTRA AS CHAR FORMAT "X(50)" INIT "".
DEFINE        VAR F-RUCTRA AS CHAR FORMAT "X(8)"  INIT "". 
DEFINE        VAR F-DESCRI AS CHAR FORMAT "X(60)" INIT "".
DEFINE        VAR F-EMISO1 AS CHAR FORMAT "X(12)" INIT "".
DEFINE        VAR F-EMISO2 AS CHAR FORMAT "X(12)" INIT "".
DEFINE        VAR C-RUCREF AS CHAR FORMAT "X(12)"  INIT "".
DEFINE        VAR C-DESALM AS CHAR     NO-UNDO.
DEFINE        VAR C-DIRPRO AS CHAR     NO-UNDO.
DEFINE        VAR C-DIRALM AS CHAR FORMAT "X(60)" INIT "".
DEFINE        VAR F-NOMPRO AS CHAR FORMAT "X(50)" INIT "".
DEFINE        VAR S-TOTPES AS DECIMAL.
DEFINE        VAR L-CREA   AS LOGICAL  NO-UNDO.

DEFINE STREAM Reporte.
DEFINE BUFFER TDOCM FOR Almtdocm.
DEFINE BUFFER CMOV  FOR Almcmov.
DEFINE SHARED TEMP-TABLE ITEM LIKE almdmov.
DEFINE SHARED VARIABLE s-status-almacen AS LOG.

DEF VAR pMensaje AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS Almcmov.CodRef Almcmov.NroRef Almcmov.CodMon ~
Almcmov.cco Almcmov.Observ Almcmov.NroRf1 Almcmov.NroRf2 
&Scoped-define ENABLED-TABLES Almcmov
&Scoped-define FIRST-ENABLED-TABLE Almcmov
&Scoped-Define DISPLAYED-FIELDS Almcmov.FchDoc Almcmov.CodRef ~
Almcmov.NroRef Almcmov.CodMon Almcmov.cco Almcmov.usuario Almcmov.Observ ~
Almcmov.NroRf1 Almcmov.NroRf2 
&Scoped-define DISPLAYED-TABLES Almcmov
&Scoped-define FIRST-DISPLAYED-TABLE Almcmov
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_NroDoc F-Estado F-Situacion ~
FILL-IN-NomAux 

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
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE F-Situacion AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomAux AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroDoc AS CHARACTER FORMAT "XXX-XXXXXXX" 
     LABEL "No. documento" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .81
     FONT 6.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN_NroDoc AT ROW 1.19 COL 12 COLON-ALIGNED
     F-Estado AT ROW 1.19 COL 29 COLON-ALIGNED NO-LABEL
     F-Situacion AT ROW 1.19 COL 47 COLON-ALIGNED NO-LABEL
     Almcmov.FchDoc AT ROW 1.19 COL 72 COLON-ALIGNED FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10.14 BY .81
     Almcmov.CodRef AT ROW 1.96 COL 12 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     Almcmov.NroRef AT ROW 1.96 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 6 FORMAT "X(20)"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     Almcmov.CodMon AT ROW 1.96 COL 74 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .81
     Almcmov.cco AT ROW 2.73 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FILL-IN-NomAux AT ROW 2.73 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     Almcmov.usuario AT ROW 2.73 COL 72 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almcmov.Observ AT ROW 3.5 COL 12 COLON-ALIGNED FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 50 BY .81
     Almcmov.NroRf1 AT ROW 4.27 COL 12 COLON-ALIGNED
          LABEL "Referencia 1"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     Almcmov.NroRf2 AT ROW 4.27 COL 72 COLON-ALIGNED
          LABEL "Referencia 2"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     "Moneda :" VIEW-AS TEXT
          SIZE 6.57 BY .69 AT ROW 1.96 COL 67.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Almcmov,integral.Almtdocm
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
         HEIGHT             = 4.77
         WIDTH              = 89.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
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

/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Situacion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-NomAux IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almcmov.NroRf1 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.NroRf2 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN Almcmov.Observ IN FRAME F-Main
   EXP-FORMAT                                                           */
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Almcmov.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.CodMon V-table-Win
ON ENTRY OF Almcmov.CodMon IN FRAME F-Main /* Cod!mon */
DO:
  IF I-CODMON <> 3 OR Almtdocm.TipMov = "S" THEN DO:
     IF Almtdocm.TipMov = "S" THEN ASSIGN Almcmov.CodMon:SCREEN-VALUE = "1".
     ELSE ASSIGN Almcmov.CodMon:SCREEN-VALUE = STRING(I-CODMON,'9').
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almcmov.FchDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almcmov.FchDoc V-table-Win
ON LEAVE OF Almcmov.FchDoc IN FRAME F-Main /* Fecha */
DO:
  FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= INPUT Almcmov.FchDoc NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN F-TPOCMB = gn-tcmb.compra.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_NroDoc V-table-Win
ON LEAVE OF FILL-IN_NroDoc IN FRAME F-Main /* No. documento */
DO:
  ASSIGN FILL-IN_NroDoc.
  /* Caso de ingreso manual, verifica que no exista el documento */
  DO WITH FRAME {&FRAME-NAME} :
     FIND Almcmov WHERE Almcmov.CodCia = s-codcia 
                   AND  Almcmov.CodAlm = Almtdocm.CodAlm 
                   AND  Almcmov.TipMov = Almtdocm.TipMov 
                   AND  Almcmov.CodMov = Almtdocm.CodMov 
                   AND  Almcmov.NroSer = INTEGER(SUBSTRING(FILL-IN_NroDoc,1,3)) 
                   AND  Almcmov.NroDoc = INTEGER(SUBSTRING(FILL-IN_NroDoc,4,6)) 
                  NO-LOCK NO-ERROR.
     IF AVAILABLE Almcmov THEN DO:
        MESSAGE 'Documento se encuentra registrado' VIEW-AS ALERT-BOX.
        APPLY 'ENTRY':U TO FILL-IN_NroDoc.
        RETURN NO-APPLY.
     END.
     IF S-NROSER <> INTEGER(SUBSTRING(FILL-IN_NroDoc,1,3)) THEN DO:
        MESSAGE 'Documento no corresponde al numero de serie' VIEW-AS ALERT-BOX.
        APPLY 'ENTRY':U TO FILL-IN_NroDoc.
        RETURN NO-APPLY.
     END.
  END.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-ITEM V-table-Win 
PROCEDURE Actualiza-ITEM :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ITEM.
IF NOT L-CREA THEN DO:
   FOR EACH Almdmov OF Almcmov NO-LOCK :
       CREATE ITEM.
       RAW-TRANSFER Almdmov TO ITEM.
   END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Solicitud V-table-Win 
PROCEDURE Actualiza-Solicitud :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND AlmCDocu WHERE AlmCDocu.codcia = s-codcia
        AND AlmCDocu.codllave = Almcmov.cco
        AND AlmCDocu.coddoc = Almcmov.codref
        AND AlmCDocu.nrodoc = Almcmov.nroref
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE AlmCDocu THEN DO:
        pMensaje = "No se pudo bloquear la Solicitud de Uso Interno".
        RETURN "ADM-ERROR".
    END.
    FOR EACH almdmov OF almcmov NO-LOCK:
        FIND AlmDDocu OF AlmCDocu WHERE AlmDDocu.codigo = Almdmov.codmat
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE AlmDDocu THEN DO:
            pMensaje = "No se pudo bloquear el detalle de la Solicitud de Uso Interno".
            UNDO, RETURN "ADM-ERROR".
        END.
        AlmDDocu.Libre_d03 = AlmDDocu.Libre_d03 + Almdmov.candes.
    END.
    FIND FIRST AlmDDocu OF AlmCDocu WHERE AlmDDocu.Libre_d02 > AlmDDocu.Libre_d03
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE AlmDDocu 
    THEN AlmCDocu.FlgEst = 'C'.     /* Atendido */
    ELSE AlmCDocu.FlgEst = 'P'.     /* Pendiente */
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  FOR EACH Almdmov OF Almcmov EXCLUSIVE-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-Solicitud V-table-Win 
PROCEDURE Extorna-Solicitud :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND AlmCDocu WHERE AlmCDocu.codcia = s-codcia
        AND AlmCDocu.codllave = Almcmov.cco
        AND AlmCDocu.coddoc = Almcmov.codref
        AND AlmCDocu.nrodoc = Almcmov.nroref
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE AlmCDocu THEN DO:
        pMensaje = "No se pudo bloquear la Solicitud de Uso Interno".
        RETURN "ADM-ERROR".
    END.
    FOR EACH almdmov OF almcmov NO-LOCK:
        FIND AlmDDocu OF AlmCDocu WHERE AlmDDocu.codigo = Almdmov.codmat
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE AlmDDocu THEN DO:
            pMensaje = "No se pudo bloquear el detalle de la Solicitud de Uso Interno".
            UNDO, RETURN "ADM-ERROR".
        END.
        AlmDDocu.Libre_d03 = AlmDDocu.Libre_d03 - Almdmov.candes.
    END.
    FIND FIRST AlmDDocu OF AlmCDocu WHERE AlmDDocu.Libre_d02 > AlmDDocu.Libre_d03
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE AlmDDocu 
    THEN AlmCDocu.FlgEst = 'C'.     /* Atendido */
    ELSE AlmCDocu.FlgEst = 'P'.     /* Pendiente */
END.
RETURN "OK".

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
  DEF VAR pComprometido AS DEC.
  
  FOR EACH ITEM WHERE ITEM.codmat <> "" ON ERROR UNDO, RETURN "ADM-ERROR":
      /* Consistencia final: Verificamos que aún exista stock disponible */
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = s-codalm
          AND Almmmate.codmat = ITEM.codmat
          NO-LOCK.
/*       RUN vta2/stock-comprometido (ITEM.codmat, s-codalm, OUTPUT pComprometido). */
      RUN vta2/stock-comprometido-v2 (ITEM.codmat, s-codalm, OUTPUT pComprometido).
      IF ITEM.CanDes > (Almmmate.stkact - pComprometido) THEN DO:
          MESSAGE 'NO hay stock para el código' ITEM.codmat SKIP
              'Stock actual:' Almmmate.stkact SKIP
              'Stock comprometido:' pComprometido
              VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
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
          Almdmov.codmat = ITEM.codmat
          Almdmov.CanDes = ITEM.CanDes
          Almdmov.CodUnd = ITEM.CodUnd
          Almdmov.Factor = ITEM.Factor
          Almdmov.ImpCto = ITEM.ImpCto
          Almdmov.PreUni = ITEM.PreUni
          Almdmov.NroItm = N-Itm
          Almdmov.CodAjt = ''
          Almdmov.HraDoc = almcmov.HorSal
          R-ROWID = ROWID(Almdmov).
      RUN alm/almdcstk (R-ROWID).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      RUN ALM\ALMACPR1 (R-ROWID,"U").
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  END.
  RUN Procesa-Handle IN lh_Handle ('browse').
   
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
  DEF VAR pComprometido AS DEC.
  DEF VAR x-Stock-Disponible AS DEC NO-UNDO.
  
  IF s-status-almacen = NO THEN DO:
      MESSAGE 'Almacén INACTIVO' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

  /* CONTROL DE SERIES */
  IF Almtmovm.ReqGuia THEN DO:
    FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = "G/R"    
      AND FacCorre.CodAlm = S-CODALM
      AND FacCorre.CodDiv = S-CODDIV 
      AND FacCorre.NroSer = S-NROSER 
      NO-LOCK NO-ERROR.
    IF AVAILABLE FacCorre THEN DO:
      IF FacCorre.FlgEst = NO THEN DO:
          MESSAGE 'NO puede hacer movimientos con la serie' s-NroSer 
              VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
      FILL-IN_NroDoc = STRING(S-NROSER,"999") + STRING(FacCorre.Correlativo,"9999999").
    END.
    ELSE DO:
          MESSAGE 'Error en la serie' s-NroSer
              VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
    END.
  END.
  ELSE DO:
      FIND Almacen WHERE Almacen.CodCia = S-CODCIA 
          AND Almacen.CodAlm = Almtdocm.CodAlm 
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almacen THEN DO:
          MESSAGE 'Error en la serie' s-NroSer
              VIEW-AS ALERT-BOX ERROR.
          RETURN 'ADM-ERROR'.
      END.
      FILL-IN_NroDoc = STRING(S-NROSER,"999") + STRING(Almacen.CorrSal,"9999999").
  END.
  /* Buscamos Solicitudes Pendientes */
  ASSIGN
      input-var-1 = "SUI"
      input-var-2 = "P"
      input-var-3 = s-codalm
      output-var-1 = ?.
  RUN lkup/c-usointernoxalm ("Solicitudes para Uso Interno").
  IF output-var-1 = ? THEN RETURN "ADM-ERROR".
  FIND Almcdocu WHERE ROWID(Almcdocu) = output-var-1 NO-LOCK NO-ERROR.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  L-CREA = YES.
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY 
         FILL-IN_NroDoc
         TODAY @ Almcmov.FchDoc
         Almcdocu.coddoc @  Almcmov.CodRef 
         Almcdocu.nrodoc @ Almcmov.NroRef
         Almcdocu.codllave @ Almcmov.cco.
     FIND LAST gn-tcmb NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN F-TPOCMB = gn-tcmb.compra.
     FIND cb-auxi WHERE cb-auxi.codcia = cb-codcia
         AND cb-auxi.clfaux = "CCO"
         AND cb-auxi.codaux = Almcdocu.codllave
         NO-LOCK NO-ERROR.
     IF AVAILABLE cb-auxi THEN DISPLAY cb-auxi.nomaux @  FILL-IN-NomAux.
     EMPTY TEMP-TABLE ITEM.
     FOR EACH Almddocu OF Almcdocu NO-LOCK WHERE Almddocu.Libre_d02 > 0 AND
         Almddocu.Libre_d02 - Almddocu.Libre_d03 > 0:
         FIND Almmmate WHERE Almmmate.CodCia = Almddocu.CodCia  
             AND  Almmmate.CodAlm = s-CodAlm 
             AND  Almmmate.CodMat = Almddocu.Codigo
             NO-LOCK NO-ERROR. 
         IF NOT AVAILABLE Almmmate THEN DO:
             MESSAGE 'Material' Almddocu.codigo 'NO asignado al almacén' s-codalm
                 VIEW-AS ALERT-BOX WARNING.
             NEXT.
         END.
/*          RUN vta2/stock-comprometido (Almddocu.codigo, s-CodAlm, OUTPUT pComprometido). */
         RUN vta2/stock-comprometido-v2 (Almddocu.codigo, s-CodAlm, OUTPUT pComprometido).
         IF (Almmmate.stkact - pComprometido) <= 0 THEN DO:
             MESSAGE 'NO alcanza el stock para despachar este pedido' SKIP
                 '     Articulo:' Almddocu.codigo SKIP
                 'Stock almacén:' Almmmate.stkact SKIP
                 ' Comprometido:' pComprometido
                 VIEW-AS ALERT-BOX WARNING.
             NEXT.
         END.
         x-Stock-Disponible = MINIMUM ( (Almmmate.stkact - pComprometido), 
                                        (Almddocu.libre_d02 - Almddocu.libre_d03) ).
         FIND Almmmatg WHERE Almmmatg.CodCia = Almddocu.CodCia  
             AND Almmmatg.CodMat = Almddocu.Codigo
             NO-LOCK NO-ERROR. 
         /* GENERAMOS MOVIMIENTO PARA ALMACEN ORIGEN */
         CREATE ITEM.
         ASSIGN 
             ITEM.CodCia = Almtdocm.CodCia
             ITEM.CodAlm = Almtdocm.CodAlm
             ITEM.CodMat = Almddocu.Codigo
             ITEM.CodAjt = ""
             ITEM.Factor = 1
             ITEM.CodUnd = Almmmatg.UndStk
             ITEM.CanDes = x-Stock-Disponible
             ITEM.StkAct = (Almddocu.libre_d02 - Almddocu.libre_d03).  /* OJO: TOPE */
     END.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').

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
  DEF VAR LocalCounter AS INTEGER INITIAL 0 NO-UNDO.
  DEF VAR cMsgs AS CHARACTER NO-UNDO.
  DEF VAR ix AS INTEGER NO-UNDO.
  DEF VAR x-NroDoc LIKE Almcmov.nrodoc INIT 0 NO-UNDO.
  
  FIND Almtmovm WHERE 
       Almtmovm.CodCia = Almtdocm.CodCia AND
       Almtmovm.Tipmov = Almtdocm.TipMov AND
       Almtmovm.Codmov = Almtdocm.CodMov 
       NO-LOCK NO-ERROR.
  IF Almtmovm.ReqGuia = YES THEN DO:
      GetLock:
      REPEAT ON STOP UNDO GetLock, RETRY GetLock ON ERROR UNDO GetLock, LEAVE GetLock:
          IF RETRY THEN DO:
              LocalCounter = LocalCounter + 1.
              IF LocalCounter = 5 THEN LEAVE GetLock.    /* 5 intentos máximo */
          END.
          FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA
              AND FacCorre.CodDoc = "G/R"
              AND FacCorre.CodDiv = S-CODDIV
              AND FacCorre.NroSer = S-NROSER EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE FacCorre THEN LEAVE.
          IF AMBIGUOUS FacCorre OR ERROR-STATUS:ERROR THEN DO:      /* Llave Duplicada o No existe*/
              IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
                  cMsgs = ERROR-STATUS:GET-MESSAGE(1).
                  DO ix = 2 TO ERROR-STATUS:NUM-MESSAGES:
                      cMsgs = cMsgs + CHR(10) + ERROR-STATUS:GET-MESSAGE(ix).
                  END.
                  MESSAGE cMsgs VIEW-AS ALERT-BOX ERROR BUTTONS OK.
              END.
              LEAVE GetLock.
          END.
      END.
      IF LocalCounter = 5 OR NOT AVAILABLE FacCorre THEN UNDO, RETURN "ADM-ERROR".
  END.
  ELSE DO:
      GetLock:
      REPEAT ON STOP UNDO GetLock, RETRY GetLock ON ERROR UNDO GetLock, LEAVE GetLock:
          IF RETRY THEN DO:
              LocalCounter = LocalCounter + 1.
              IF LocalCounter = 5 THEN LEAVE GetLock.    /* 5 intentos máximo */
          END.
          FIND Almacen WHERE Almacen.CodCia = Almtdocm.CodCia
              AND Almacen.CodAlm = Almtdocm.CodAlm
              EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE Almacen THEN LEAVE.
          IF AMBIGUOUS Almacen OR ERROR-STATUS:ERROR THEN DO:      /* Llave Duplicada o No existe*/
              IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
                  cMsgs = ERROR-STATUS:GET-MESSAGE(1).
                  DO ix = 2 TO ERROR-STATUS:NUM-MESSAGES:
                      cMsgs = cMsgs + CHR(10) + ERROR-STATUS:GET-MESSAGE(ix).
                  END.
                  MESSAGE cMsgs VIEW-AS ALERT-BOX ERROR BUTTONS OK.
              END.
              LEAVE GetLock.
          END.
      END.
      IF LocalCounter = 5 OR NOT AVAILABLE Almacen THEN UNDO, RETURN "ADM-ERROR".
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF L-CREA THEN DO:
      ASSIGN 
          Almcmov.CodCia = Almtdocm.CodCia 
          Almcmov.CodAlm = Almtdocm.CodAlm 
          Almcmov.TipMov = Almtdocm.TipMov
          Almcmov.CodMov = Almtdocm.CodMov
          Almcmov.NroSer = S-NROSER
          Almcmov.HorSal = STRING(TIME,"HH:MM:SS").
      /* RHC 30.03.2011 Control de VB del Administrador */
      IF AVAILABLE Almtmovm AND Almtmovm.Indicador[2] = YES THEN Almcmov.FlgEst = "X".
      /* NUEVO CONTROL DE CORRELATIVOS */
      IF Almtmovm.ReqGuia THEN DO:
          REPEAT:
              ASSIGN
                  x-NroDoc = FacCorre.Correlativo.
              IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia 
                              AND Almcmov.codalm = Almtdocm.CodAlm
                              AND Almcmov.tipmov = Almtdocm.TipMov
                              AND Almcmov.codmov = Almtdocm.CodMov
                              AND Almcmov.nroser = s-NroSer
                              AND Almcmov.nrodoc = x-NroDoc
                              NO-LOCK)
                  THEN LEAVE.
              ASSIGN
                  FacCorre.Correlativo = FacCorre.Correlativo + 1.
          END.
      END.
      ELSE DO:
          REPEAT:
              ASSIGN
                  x-NroDoc = Almacen.CorrSal.
              IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia 
                              AND Almcmov.codalm = Almtdocm.CodAlm
                              AND Almcmov.tipmov = Almtdocm.TipMov
                              AND Almcmov.codmov = Almtdocm.CodMov
                              AND Almcmov.nroser = s-NroSer
                              AND Almcmov.nrodoc = x-NroDoc
                              NO-LOCK)
                  THEN LEAVE.
              ASSIGN
                  x-NroDoc = Almacen.CorrSal
                  Almacen.CorrSal = Almacen.CorrSal + 1.
          END.
      END.
      ASSIGN 
          Almcmov.NroDoc = x-NroDoc.
  END.
  ASSIGN 
      Almcmov.usuario = S-USER-ID
      Almcmov.TpoCmb  = F-TPOCMB.

  /* ELIMINAMOS EL DETALLE ANTERIOR */
  IF NOT L-CREA THEN DO:
      RUN Restaura-Solicitud.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      RUN Borra-Detalle.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.

  RUN Genera-Detalle.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN Actualiza-Solicitud.     /* Actualizamos pedido automático */
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* DESBLOQUEA CORRELATIVOS */
  RELEASE FacCorre.
  RELEASE Almacen.

  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('Browse').
         
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF s-user-id <> 'ADMIN' THEN DO:
      RUN valida-update.
      IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

      /* consistencia de la fecha del cierre del sistema */
      DEF VAR dFchCie AS DATE.
      RUN gn/fecha-de-cierre (OUTPUT dFchCie).
      IF almcmov.fchdoc <= dFchCie THEN DO:
          MESSAGE 'NO se puede anular ningun documento antes del' (dFchCie + 1)
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
      /* fin de consistencia */
  END.
  /* Eliminamos el detalle */
  /* Solo marcamos el FlgEst como Anulado */
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR':
      FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia 
          AND  CMOV.CodAlm = Almcmov.CodAlm 
          AND  CMOV.TipMov = Almcmov.TipMov 
          AND  CMOV.CodMov = Almcmov.CodMov 
          AND  CMOV.NroSer = Almcmov.NroSer 
          AND  CMOV.NroDoc = Almcmov.NroDoc 
          EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
      
      RUN Extorna-Solicitud.     /* Actualizamos pedido automático */
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      RUN Borra-Detalle.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.  

      ASSIGN 
          CMOV.FlgEst = 'A'
          CMOV.Observ = "      A   N   U   L   A   D   O       "
          CMOV.Usuario = S-USER-ID.
      RELEASE CMOV.
  END.
  /* refrescamos los datos del viewer */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  /* refrescamos los datos del browse */
  RUN Procesa-Handle IN lh_Handle ('browse').

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

  /* Buscamos en la tabla de movimientos y pedimos datos segun lo configurado*/
  FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almtdocm.CodCia 
                       AND  Almtmovm.Tipmov = Almtdocm.TipMov 
                       AND  Almtmovm.Codmov = Almtdocm.CodMov 
                      NO-LOCK NO-ERROR.
  IF AVAILABLE Almtmovm THEN DO WITH FRAME {&FRAME-NAME}:
     ASSIGN 
         Almcmov.NroRf1:VISIBLE = Almtmovm.PidRef1
         Almcmov.NroRf2:VISIBLE = Almtmovm.PidRef2
         I-CODMON = Almtmovm.CodMon
         Almcmov.cco:VISIBLE = Almtmovm.PidCCt.
     IF Almtmovm.CodMon <> 3 THEN DO:
         ASSIGN Almcmov.CodMon:SCREEN-VALUE = STRING(Almtmovm.CodMon,'9').
     END.
     IF Almtmovm.PidRef1 THEN ASSIGN Almcmov.NroRf1:LABEL = Almtmovm.GloRf1.
     IF Almtmovm.PidRef2 THEN ASSIGN Almcmov.NroRf2:LABEL = Almtmovm.GloRf2.
     IF Almtdocm.TipMov = "S" THEN DO:
        ASSIGN Almcmov.CodMon:SCREEN-VALUE = '1'.
     END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Almcmov THEN DO WITH FRAME {&FRAME-NAME}:
     FILL-IN_NroDoc:SCREEN-VALUE = STRING(Almcmov.NroSer,"999") + 
                                   STRING(Almcmov.NroDoc,"9999999").
     F-Estado:SCREEN-VALUE = "".
     CASE Almcmov.FlgEst:
         WHEN "A" THEN F-Estado:SCREEN-VALUE = "ANULADO".
         WHEN "X" THEN F-Estado:SCREEN-VALUE = "FALTA VºBº".
         WHEN "C" THEN F-Estado:SCREEN-VALUE = "CON VºBº".
     END CASE.
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
          Almcmov.cco:SENSITIVE = NO
          Almcmov.CodRef:SENSITIVE = NO
          Almcmov.NroRef:SENSITIVE = NO
          Almcmov.CodMon:SENSITIVE = NO.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND Almtmovm WHERE 
       Almtmovm.CodCia = Almtdocm.CodCia AND
       Almtmovm.Tipmov = Almtdocm.TipMov AND
       Almtmovm.Codmov = Almtdocm.CodMov 
       NO-LOCK NO-ERROR.
  IF NOT Almtmovm.ReqGuia THEN DO :
     RUN ALM\R-IMPFMT (ROWID(Almcmov)).
     RETURN.
  END.

  /* Definimos impresoras */
  IF Almcmov.Codmov = 26 OR Almcmov.Codmov = 17 THEN DO:
     RUN ALM\R-ImpConv(ROWID(Almcmov)).
     RETURN.
  END.
  IF Almcmov.Codmov = 28  THEN DO:
     RUN ALM\R-ImpConv(ROWID(Almcmov)).
     RETURN.
  END.
  IF Almcmov.Codmov = 10 OR Almcmov.Codmov = 11 THEN DO:
     RUN ALM\R-ImpMue2(ROWID(Almcmov)).
     RETURN.
  END.

S-TOTPES = 0.

DEFINE VAR s-printer-list AS CHAR.
DEFINE VAR s-port-list AS CHAR.
DEFINE VAR s-port-name AS CHAR format "x(20)".
DEFINE VAR s-printer-count AS INTEGER.
DEF VAR I-NroSer AS INTEGER .

/*MLR* ***
RUN aderb/_prlist.p(
    OUTPUT s-printer-list,
    OUTPUT s-port-list,
    OUTPUT s-printer-count).
*MLR* ***/

I-NroSer = S-NROSER.

DEFINE VAR W-REFERENCIA AS CHAR INIT "TRANSFERENCIA".

IF AVAILABLE Almcmov AND Almcmov.FlgEst <> "A" THEN DO :
     
  S-ITEM = 0.
  
  FIND Almacen WHERE Almacen.CodCia = Almcmov.CodCia 
                AND  Almacen.CodAlm = Almcmov.CodAlm 
               NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN DO:
     C-DIRPRO = Almacen.Descripcion.
  END.     
  
  /******** Verifica el Tipo de Movimiento *******/
  
  IF Almcmov.Codmov = 15 OR Almcmov.Codmov = 16 THEN W-REFERENCIA = "CAMBIO".
  IF Almcmov.Codmov = 20 OR Almcmov.Codmov = 25 OR Almcmov.Codmov = 09 THEN W-REFERENCIA = "DEVOLUCION".
  IF Almcmov.Codmov = 23 THEN W-REFERENCIA = "TRANSFORMACION".
  IF Almcmov.Codmov = 23 OR Almcmov.Codmov = 20 OR Almcmov.Codmov = 25 OR Almcmov.Codmov = 15 OR Almcmov.Codmov = 16 THEN DO:
  END.  
  ELSE DO :
     FIND Almacen WHERE Almacen.CodCia = Almcmov.CodCia 
                   AND  Almacen.CodAlm = Almcmov.AlmDes 
                  NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN DO:
        F-DESCRI = Almacen.Descripcion.
        C-DIRALM = Almacen.DirAlm.
        IF Almcmov.Almdes = "T07" THEN DO:
           F-EMISO1 = "EMISOR ".
           F-EMISO2 = "ITINERANTE".
           C-RUCREF = "V A R I O S".
        END.   
        ELSE C-RUCREF = "10027462".
     END.   
  END.     

  DEFINE FRAME F-FMT
         S-Item             AT  1   FORMAT "ZZ9"
         Almdmov.CodMat     AT  6   FORMAT "X(8)"
         Almmmatg.DesMat    AT  18  FORMAT "X(50)"
         Almmmatg.Desmar    AT  70  FORMAT "X(20)"
         Almdmov.CanDes     AT  92  FORMAT ">>>,>>9.99" 
         Almdmov.CodUnd     AT  103 FORMAT "X(4)"          
         HEADER
         SKIP(9)
         F-DESCRI AT 15 FORMAT "X(60)"  Almcmov.FchDoc AT 106 SKIP
         C-DIRALM AT 15 FORMAT "X(60)"  Almcmov.NroRf1 AT 106 SKIP
         C-RUCREF AT 15 FORMAT "X(12)"  SKIP
         {&PRN2} + {&PRN7A} + {&PRN6A} + W-REFERENCIA + {&PRN7B} + {&PRN3} + {&PRN6B} AT 90 FORMAT "X(40)"
         {&PRND} + Almcmov.Observ + {&PRN6B} AT 15 FORMAT "X(55)"  
         " Partida : " + C-DIRPRO AT 75 FORMAT "X(60)" SKIP(2)
         WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 160 STREAM-IO DOWN.         
         
/*   FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA       */
/*       AND FacCorre.CodDoc = "G/R"                            */
/*       AND FacCorre.CodDiv = S-CODDIV                         */
/*       AND FacCorre.NroSer = S-NROSER                         */
/*       NO-LOCK NO-ERROR.                                      */
/*   RUN lib/_port-name (FacCorre.Printer, OUTPUT s-port-name). */
/*   IF s-port-name = '' THEN RETURN.                           */
/*   {lib/_printer-stream-to.i 60 REPORTE PAGED}                */
          
  DEF VAR l-Ok AS LOG NO-UNDO.
  SYSTEM-DIALOG PRINTER-SETUP UPDATE l-Ok.
  IF l-Ok = NO THEN RETURN.
  OUTPUT STREAM REPORTE TO PRINTER PAGED PAGE-SIZE 60.

  FIND FIRST Almdmov WHERE Almdmov.CodCia = Almcmov.CodCia 
                      AND  Almdmov.CodAlm = Almcmov.CodAlm 
                      AND  Almdmov.TipMov = Almcmov.TipMov 
                      AND  Almdmov.CodMov = Almcmov.CodMov 
                      AND  Almdmov.NroDoc = Almcmov.NroDoc 
                     USE-INDEX Almd01 NO-LOCK NO-ERROR.
  IF AVAILABLE Almdmov THEN DO:
     PUT STREAM Reporte CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN3}.     
     REPEAT WHILE  AVAILABLE  AlmDMov      AND Almdmov.CodAlm = Almcmov.CodAlm AND
           Almdmov.TipMov = Almcmov.TipMov AND Almdmov.CodMov = Almcmov.CodMov AND
           Almdmov.NroSer = Almcmov.NroSer AND Almdmov.NroDoc = Almcmov.NroDoc:
           FIND Almmmatg WHERE Almmmatg.CodCia = Almdmov.CodCia 
                          AND  Almmmatg.CodMat = Almdmov.CodMat 
                         NO-LOCK NO-ERROR.
           S-TOTPES = S-TOTPES + ( Almdmov.Candes * Almmmatg.Pesmat ).
           S-Item = S-Item + 1.
           DISPLAY STREAM Reporte 
                   S-Item 
                   Almdmov.CodMat 
                   Almdmov.CanDes 
                   Almdmov.CodUnd 
                   Almmmatg.DesMat 
                   Almmmatg.Desmar 
                   WITH FRAME F-FMT.
           DOWN STREAM Reporte WITH FRAME F-FMT.
           FIND NEXT Almdmov USE-INDEX Almd01.
     END.
  END.
  DO WHILE LINE-COUNTER(Reporte) < PAGE-SIZE(Reporte) - 7 :
     PUT STREAM Reporte "" skip.
  END.
  PUT STREAM Reporte f-nompro  AT 15 "X" AT 80 SKIP.
  PUT STREAM Reporte f-dirtra  AT 15 SKIP.
  PUT STREAM Reporte f-ructra  AT 15 SKIP.
  PUT STREAM Reporte f-emiso1  AT 93 SKIP.
  PUT STREAM Reporte f-emiso2  AT 93 SKIP(1).
  PUT STREAM Reporte "HORA : " + STRING(TIME,"HH:MM:SS") AT 1 FORMAT "X(20)" 
  "TOTAL KILOS :" AT 30 S-TOTPES AT 44 FORMAT ">>,>>9.99" 
  " ** ALMACEN ** " AT 100 SKIP.
  OUTPUT STREAM Reporte CLOSE.

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
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
  
  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  pMensaje = ''.
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ).
  IF pMensaje <> '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.

  /* Code placed here will execute AFTER standard behavior.    */
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").
  
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
        WHEN "Cco" THEN 
            ASSIGN
                input-var-1 = "CCO"
                input-var-2 = ""
                input-var-3 = "".
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Restaura-Solicitud V-table-Win 
PROCEDURE Restaura-Solicitud :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND AlmCDocu WHERE AlmCDocu.codcia = s-codcia
        AND AlmCDocu.coddoc = Almcmov.codref
        AND AlmCDocu.nrodoc = Almcmov.nroref
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE AlmCDocu THEN DO:
        MESSAGE 'No se pudo bloquear la Solicitud por Uso Interno'
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    FOR EACH almdmov OF almcmov NO-LOCK:
        FIND AlmDDocu OF AlmCDocu WHERE AlmDDocu.codigo = Almdmov.codmat EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE AlmDDocu THEN DO:
            MESSAGE 'No se pudo bloquear el detalle de la Solicitud por Uso Interno'
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN "ADM-ERROR".
        END.
        AlmDDocu.Libre_d03 = AlmDDocu.Libre_d03 - Almdmov.candes.
    END.
    ASSIGN
        AlmCDocu.FlgEst = 'P'.
END.
RETURN "OK".

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

  IF p-state = 'update-begin':U THEN RUN valida-update.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN ERROR.
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  IF p-state = 'update-begin':U THEN DO:
     L-CREA = NO.
     RUN Actualiza-ITEM.
     RUN Procesa-Handle IN lh_Handle ('Pagina2').
     RUN Procesa-Handle IN lh_Handle ('browse').
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE N-ITEM AS DECIMAL NO-UNDO INIT 0.
DO WITH FRAME {&FRAME-NAME} :
   FOR EACH ITEM WHERE ITEM.Candes <> 0 NO-LOCK:
       N-ITEM = N-ITEM + 1 . /*ITEM.CanDes.*/
   END.
   IF N-ITEM = 0 THEN DO:
      MESSAGE "No existen ITEMS a generar" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO Almcmov.Observ.
      RETURN "ADM-ERROR".
   END.

  /* CONTROL DE ITEMS SOLO SI S-NROSER <> 000 */  
  IF s-NroSer <> 000 THEN DO:
    FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
    IF N-ITEM >  FacCfgGn.Items_Guias THEN DO:
        MESSAGE "Numero de Items Mayor al Configurado para el Tipo de Documento " 
            SKIP "Items Por Guia : " +  STRING(FacCfgGn.Items_Guias,"999") 
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN "ADM-ERROR".
    END. 
  END.
  
   IF Almcmov.Cco:VISIBLE THEN DO:      /* CENTRO DE COSTO */
        FIND CB-AUXI WHERE cb-auxi.codcia = cb-codcia
            AND cb-auxi.clfaux = 'CCO'
            AND cb-auxi.codaux = Almcmov.Cco:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE CB-AUXI
        THEN DO:
            MESSAGE 'Centro de costo no registrado' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO almcmov.cco.
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

  /* CONTROL DE SERIES */
  FIND FIRST FacCorre WHERE FacCorre.CodCia = Almcmov.CodCia
    AND FacCorre.CodDoc = "G/R"    
    AND FacCorre.CodAlm = Almcmov.CodAlm
    AND FacCorre.CodDiv = s-CodDiv
    AND FacCorre.NroSer = Almcmov.NroSer
    NO-LOCK NO-ERROR.
  IF AVAILABLE FacCorre AND FacCorre.FlgEst = NO 
  THEN DO:
    MESSAGE 'La serie' s-NroSer 'está Inactiva'
            VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

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
  /* fin de consistencia */

  F-TPOCMB = Almcmov.TpoCmb.
  RETURN "OK".
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

