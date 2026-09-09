&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE DOCU LIKE CcbCDocu.
DEFINE SHARED TEMP-TABLE MVTO LIKE CcbDMvto.



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
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-doccje AS CHAR.
DEF SHARED VAR s-nroser AS INT.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR. 
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE SHARED VARIABLE S-TPOCMB   AS DECIMAL.
DEFINE SHARED VAR lh_handle AS HANDLE.

DEFINE BUFFER B-CMvto FOR CcbCMvto.

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
&Scoped-define EXTERNAL-TABLES CcbCMvto
&Scoped-define FIRST-EXTERNAL-TABLE CcbCMvto


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCMvto.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCMvto.CodCli CcbCMvto.CodMon ~
CcbCMvto.Glosa CcbCMvto.TpoCmb 
&Scoped-define ENABLED-TABLES CcbCMvto
&Scoped-define FIRST-ENABLED-TABLE CcbCMvto
&Scoped-Define DISPLAYED-FIELDS CcbCMvto.NroDoc CcbCMvto.Usuario ~
CcbCMvto.FchDoc CcbCMvto.CodCli CcbCMvto.FchApr CcbCMvto.CodMon ~
CcbCMvto.Glosa CcbCMvto.TpoCmb 
&Scoped-define DISPLAYED-TABLES CcbCMvto
&Scoped-define FIRST-DISPLAYED-TABLE CcbCMvto
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Estado FILL-IN-NomCli 

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
DEFINE VARIABLE FILL-IN-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81
     BGCOLOR 12 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre" 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCMvto.NroDoc AT ROW 1.19 COL 11 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-Estado AT ROW 1.19 COL 32 COLON-ALIGNED WIDGET-ID 34
     CcbCMvto.Usuario AT ROW 1.19 COL 53 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCMvto.FchDoc AT ROW 1.19 COL 83 COLON-ALIGNED WIDGET-ID 20
          LABEL "Fecha de Canje"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCMvto.CodCli AT ROW 1.96 COL 11 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCMvto.FchApr AT ROW 1.96 COL 83 COLON-ALIGNED WIDGET-ID 18
          LABEL "Fecha de Aprobación"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-NomCli AT ROW 2.73 COL 11 COLON-ALIGNED WIDGET-ID 32
     CcbCMvto.CodMon AT ROW 2.73 COL 85 NO-LABEL WIDGET-ID 36
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "SOLES", 1,
"DOLARES", 2
          SIZE 18 BY .77
     CcbCMvto.Glosa AT ROW 3.5 COL 11 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 55 BY .81
     CcbCMvto.TpoCmb AT ROW 3.5 COL 83 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     "Moneda de Canje:" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 2.92 COL 71 WIDGET-ID 40
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.CcbCMvto
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: DOCU T "SHARED" ? INTEGRAL CcbCDocu
      TABLE: MVTO T "SHARED" ? INTEGRAL CcbDMvto
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
         HEIGHT             = 4.85
         WIDTH              = 105.86.
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

/* SETTINGS FOR FILL-IN CcbCMvto.FchApr IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CcbCMvto.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.Usuario IN FRAME F-Main
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

&Scoped-define SELF-NAME CcbCMvto.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.CodCli V-table-Win
ON LEAVE OF CcbCMvto.CodCli IN FRAME F-Main /* Cliente */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.

    RUN vtagn/p-gn-clie-01 (SELF:SCREEN-VALUE, s-CodDoc).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    s-CodCli = SELF:SCREEN-VALUE.
    FIND gn-clie WHERE gn-clie.codcia  = cl-codcia
        AND gn-clie.codcli = s-codcli
        NO-LOCK.
    DISPLAY 
        gn-clie.NomCli @ FILL-IN-NomCli
        WITH FRAME {&FRAME-NAME}.
    SELF:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.CodMon V-table-Win
ON VALUE-CHANGED OF CcbCMvto.CodMon IN FRAME F-Main /* Moneda */
DO:
   S-CodMon = INTEGER(CcbCMvto.CodMon:SCREEN-VALUE).
   RUN Procesa-Handle IN lh_Handle ('Browse-Docu').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.TpoCmb V-table-Win
ON LEAVE OF CcbCMvto.TpoCmb IN FRAME F-Main /* Tipo de cambio */
DO:
  s-TpoCmb = INPUT {&self-name}.
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
  {src/adm/template/row-list.i "CcbCMvto"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCMvto"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Cancelaciones V-table-Win 
PROCEDURE Borra-Cancelaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

PRINCIPAL:
DO ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FOR EACH CcbDMvto NO-LOCK WHERE CcbDMvto.CodCia = CcbCMvto.CodCia 
        AND CcbDMvto.CodDoc = CcbCMvto.CodDoc 
        AND CcbDMvto.NroDoc = CcbCMvto.NroDoc
        AND CcbDMvto.TpoRef = "O":
        FIND CcbCDocu WHERE CcbCDocu.CodCia = CcbDMvto.CodCia 
            AND CcbCDocu.CodDoc = CcbDMvto.CodRef 
            AND CcbCDocu.NroDoc = CcbDMvto.NroRef EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Ccbcdocu THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        IF CcbCDocu.CodMon = CcbCMvto.CodMon THEN CcbCDocu.SdoAct = CcbCDocu.SdoAct + CcbDMvto.ImpTot.
        ELSE DO:
           IF CcbCDocu.CodMon = 1 THEN CcbCDocu.SdoAct = CcbCDocu.SdoAct + (CcbDMvto.ImpTot * CcbCMvto.TpoCmb).
           ELSE  CcbCDocu.SdoAct = CcbCDocu.SdoAct + (CcbDMvto.ImpTot / CcbCMvto.TpoCmb).
        END.
        ASSIGN
            CcbCDocu.SdoAct = IF CcbCDocu.SdoAct <= 0 THEN 0 ELSE CcbCDocu.SdoAct
            CcbCDocu.FlgEst = IF CcbCDocu.SdoAct = 0 THEN 'C' ELSE 'P'.
    END.
    /* Eliminar el documento cancelado en caja */
    FOR EACH CcbDCaja WHERE CcbDCaja.CodCia = CcbCMvto.CodCia 
        AND CcbDCaja.CodDoc = CcbCMvto.CodDoc 
        AND CcbDCaja.NroDoc = CcbCMvto.NroDoc:
        DELETE CcbDCaja.
    END.
    FOR EACH Ccbdmov WHERE Ccbdmov.codcia = CcbCMvto.CodCia 
        AND Ccbdmov.coddiv = CcbCMvto.CodDiv
        AND Ccbdmov.coddoc = "N/C"
        AND Ccbdmov.codref = Ccbcmvto.coddoc
        AND Ccbdmov.nroref = Ccbcmvto.nrodoc:
        DELETE Ccbdmov.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Deta V-table-Win 
PROCEDURE Borra-Deta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE MVTO.
    EMPTY TEMP-TABLE DOCU.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Deta V-table-Win 
PROCEDURE Carga-Deta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE DOCU.
FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Ccbcmvto.codcia
    AND Ccbcdocu.coddiv = Ccbcmvto.coddiv
    AND Ccbcdocu.coddoc = s-DocCje
    AND Ccbcdocu.codref = Ccbcmvto.coddoc
    AND Ccbcdocu.nroref = Ccbcmvto.nrodoc:
    CREATE DOCU.
    BUFFER-COPY Ccbcdocu TO DOCU.
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

DEF INPUT PARAMETER pFlag AS CHAR.

/* Hay dos escenarios:
pFlag = "CREATE"    Se crean nuevas letras
pFlag = "UPDATE"    Se actualizan las ya existentes
*/
IF LOOKUP(pFlag, "CREATE,UPDATE") = 0 THEN RETURN "ADM-ERROR".

/*DEF VAR LocalCodDoc AS CHAR INIT "LET" NO-UNDO.*/
DEF VAR LocalNroSer AS INT NO-UNDO.

PRINCIPAL:
DO TRANSACTION ON STOP UNDO, RETURN "ADM-ERROR" ON ERROR UNDO, RETURN "ADM-ERROR":
    CASE pFlag:
        WHEN "CREATE" THEN DO:
            /* PRIMERO LOS DOCUMENTOS A CANJEAR */
            FOR EACH MVTO WHERE MVTO.Tporef = "O":
                FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
                    AND Ccbcdocu.coddoc = MVTO.codref
                    AND Ccbcdocu.nrodoc = MVTO.nroref
                    EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE Ccbcdocu THEN DO:
                    MESSAGE 'No se pudo bloquear la' MVTO.codref MVTO.nroref
                        VIEW-AS ALERT-BOX ERROR.
                    UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
                END.
                CREATE CcbDMvto.
                ASSIGN 
                    CcbDMvto.CodCia = CcbCMvto.CodCia 
                    CcbDMvto.CodDiv = CcbCMvto.CodDiv
                    CcbDMvto.CodDoc = CcbCMvto.CodDoc 
                    CcbDMvto.NroDoc = CcbCMvto.NroDoc
                    CcbDMvto.CodCli = CcbCMvto.CodCli
                    CcbDMvto.TpoRef = MVTO.TpoRef
                    CcbDMvto.CodRef = MVTO.CodRef
                    CcbDMvto.NroRef = MVTO.NroRef
                    CcbDMvto.ImpTot = MVTO.ImpTot.
                ASSIGN
                    Ccbcdocu.FlgSitA = Ccbcdocu.FlgSit
                    Ccbcdocu.FlgSit = 'X'.   /* Canje pendiente */
            END.
            /* SEGUNDO GENERAMOS LOS CANJES POR APROBAR */
            /* Buscamos si hay una serie activa para las letras */
            FIND FIRST DOCU.
            LocalNroSer = INTEGER(SUBSTRING(DOCU.NroDoc,1,3)).
            FIND FIRST FacCorre WHERE FacCorre.codcia = s-codcia
                AND FacCorre.coddiv = s-coddiv
                AND FacCorre.coddoc = s-DocCje      /*LocalCodDoc*/
                AND FacCorre.nroser = LocalNroSer
                AND FacCorre.FlgEst = TRUE
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE FacCorre THEN DO:
                MESSAGE "NO hay una serie activa para el documento" s-DocCje        /*LocalCodDoc*/
                    VIEW-AS ALERT-BOX ERROR.
                UNDO PRINCIPAL, RETURN "ADM-ERROR".
            END.
            /*{vtagn/i-faccorre-01.i &Codigo = LocalCodDoc &Serie = LocalNroSer}*/
            {vtagn/i-faccorre-01.i &Codigo = s-DocCje &Serie = LocalNroSer}
            FOR EACH DOCU WHERE DOCU.ImpTot > 0:
                CREATE Ccbcdocu.
                BUFFER-COPY DOCU
                    TO Ccbcdocu
                    ASSIGN
                    CcbCDocu.CodCia = s-codcia
                    CcbCDocu.CodDiv = s-coddiv
                    CcbCDocu.CodDoc = s-DocCje      /*LocalCodDoc*/
                    CcbCDocu.NroDoc = STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999')
                    CcbCDocu.CodCli = CcbCMvto.CodCli
                    CcbCDocu.CodMon = CcbCMvto.CodMon 
                    CcbCDocu.CodRef = CcbCMvto.CodDoc  
                    CcbCDocu.NroRef = CcbCMvto.NroDoc 
                    CcbCDocu.SdoAct = CcbCDocu.ImpTot
                    CcbCDocu.FlgEst = 'X'   /* POR APROBAR */
                    CcbCDocu.FlgUbi = 'C'   /* CARTERA */
                    CcbCDocu.FlgSit = ""
                    CcbCDocu.CodDpto = CcbCMvto.CodDpto
                    CcbCDocu.CodProv = CcbCMvto.CodProv
                    CcbCDocu.CodDist = CcbCMvto.CodDist
                    CcbCDocu.usuario = s-user-id
                    NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    MESSAGE 'Ha ocurrido un error al generar los canjes' SKIP
                        'Revise los correlativos' SKIP
                        'Proceso abortado'
                        VIEW-AS ALERT-BOX ERROR.
                    UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
                END.
                FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
                    AND gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clie THEN  
                    ASSIGN
                        CcbCDocu.NomCli = gn-clie.NomCli
                        CcbCDocu.RucCli = gn-clie.Ruc.
                ASSIGN
                    FacCorre.Correlativo = FacCorre.Correlativo + 1.
            END.
        END.
        WHEN "UPDATE" THEN DO:
            FOR EACH DOCU:
                FIND Ccbcdocu OF DOCU EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE Ccbcdocu THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
                BUFFER-COPY DOCU TO Ccbcdocu.
            END.
        END.
    END CASE.
END.

RETURN "OK".

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
  /* buscamos si hay series activas para las letras */
  FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDiv = s-CodDiv
      AND FacCorre.CodDoc = "LET"
      AND FacCorre.FlgEst = YES
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN DO:
      MESSAGE 'NO hay series activas para las letras en esta división' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.

  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.

  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY 
          TODAY @ CcbCMvto.FchDoc
          FacCfgGn.Tpocmb[1] @ CcbCMvto.TpoCmb
          STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999") @ CcbCMvto.NroDoc.
      ASSIGN
          s-tpocmb = FacCfgGn.Tpocmb[1]
          s-codmon = INTEGER(CcbCMvto.CodMon:SCREEN-VALUE).
  END.
  RUN Borra-Deta.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" THEN DO:
      {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}
      ASSIGN 
          CcbCMvto.CodCia = S-CODCIA
          CcbCMvto.CodDiv  = S-CODDIV
          CcbCMvto.CodDoc = S-CODDOC
          CcbCMvto.Libre_chr[10] = s-DOCCJE     /* OJO */
          CcbCMvto.FchDoc = TODAY
          CcbCMvto.FlgEst = "P"
          CcbCMvto.NroDoc = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
          CcbCMvto.usuario = S-USER-ID
          FacCorre.Correlativo = FacCorre.Correlativo + 1.
      FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
          AND  gn-clie.CodCli = CcbCMvto.CodCli 
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-clie 
          THEN ASSIGN 
                CcbCMvto.CodDpto = gn-clie.CodDept 
                CcbCMvto.CodProv = gn-clie.CodProv 
                CcbCMvto.CodDist = gn-clie.CodDist.
      RUN Genera-Detalle ("CREATE"). 
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN
           CcbCMvto.ImpTot = 0.
      FOR EACH DOCU:
          Ccbcmvto.ImpTot = Ccbcmvto.ImpTot + DOCU.ImpTot.
      END.
  END.
  ELSE DO:
      /* SOLO MODIFICAMOS LAS LETRAS */
      RUN Genera-Detalle ("UPDATE"). 
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.

  IF AVAILABLE (ccbcdocu) THEN RELEASE ccbcdocu.
  IF AVAILABLE (ccbdmvto) THEN RELEASE ccbdmvto.
  IF AVAILABLE (faccorre) THEN RELEASE faccorre.

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

   IF CcbCMvto.FlgEst = "A" THEN DO:
      MESSAGE 'El canje se encuentra anulado...' VIEW-AS ALERT-BOX INFORMATION.
      RETURN 'ADM-ERROR'.
   END.  
   IF CcbCMvto.FlgEst = 'E' THEN DO:    /* CANJE APROBADO */
      RUN Verifica-Anulacion.
      IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
   END.
   /* consistencia de la fecha del cierre del sistema */
/*    DEF VAR dFchCie AS DATE.                                                            */
/*    RUN gn/fecha-de-cierre (OUTPUT dFchCie).                                            */
/*    IF ccbcmvto.fchdoc <= dFchCie THEN DO:                                              */
/*        MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1) */
/*            VIEW-AS ALERT-BOX WARNING.                                                  */
/*        RETURN 'ADM-ERROR'.                                                             */
/*    END.                                                                                */
   /* fin de consistencia */

   PRINCIPAL:
   DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
       /* En caso de estar aprobado el canje */
       IF CcbCMvto.FlgEst = "E" THEN DO:
           RUN Borra-Cancelaciones.
           IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       END.
       /* Extornamos documentos */
       FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = CcbCMvto.CodCia 
           AND CcbDMvto.CodDoc = CcbCMvto.CodDoc 
           AND CcbDMvto.NroDoc = CcbCMvto.NroDoc
           AND Ccbdmvto.TpoRef = 'O':
           FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
               AND Ccbcdocu.coddoc = Ccbdmvto.codref
               AND Ccbcdocu.nrodoc = Ccbdmvto.nroref
               EXCLUSIVE-LOCK NO-ERROR.
           IF NOT AVAILABLE Ccbcdocu THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
           ASSIGN
               Ccbcdocu.FlgSit = Ccbcdocu.FlgSitA
               Ccbcdocu.FlgSitA = ''.
       END.
       /* Anulamos letras */
       FOR EACH Ccbcdocu WHERE Ccbcdocu.codcia = Ccbcmvto.codcia
           AND Ccbcdocu.coddiv = Ccbcmvto.coddiv
           AND Ccbcdocu.coddoc = CcbCMvto.Libre_chr[10]     /* OJO */
           AND Ccbcdocu.codref = Ccbcmvto.coddoc
           AND Ccbcdocu.nroref = Ccbcmvto.nrodoc:
           ASSIGN
               Ccbcdocu.flgest = "A"
               CcbCDocu.FchAnu = TODAY
               CcbCDocu.UsuAnu = s-user-id.
       END.

       FIND B-CMVTO WHERE ROWID(B-CMVTO) = ROWID(CcbCMvto) EXCLUSIVE-LOCK NO-ERROR.
       IF NOT AVAILABLE B-CMVTO THEN UNDO, RETURN 'ADM-ERROR'.
       IF AVAILABLE B-CMVTO 
       THEN ASSIGN 
           B-CMVTO.FlgEst = "A"
           B-CMVTO.Glosa  = '**** Documento Anulado ****'
           B-CMVTO.ImpTot = 0
           B-CMVTO.ImpDoc = 0.
       IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
       IF AVAILABLE(Ccbdmvto) THEN RELEASE Ccbdmvto.
       IF AVAILABLE(Ccbdcaja) THEN RELEASE ccbdcaja.
       IF AVAILABLE(B-CMVTO)  THEN RELEASE B-CMVTO.
   END.
   RUN Procesa-Handle IN lh_Handle ('Browse').
   RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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
  IF AVAILABLE CcbCMvto THEN DO WITH FRAME {&FRAME-NAME}:
      FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
          AND gn-clie.CodCli = CcbCMvto.CodCli NO-LOCK NO-ERROR.
      IF AVAILABLE gn-clie THEN DISPLAY gn-clie.NomCli @ FILL-IN-NomCli.
      CASE Ccbcmvto.flgest:
          WHEN 'P' THEN FILL-IN-Estado:SCREEN-VALUE = 'POR APROBAR'.
          WHEN 'E' THEN FILL-IN-Estado:SCREEN-VALUE = 'APROBADO'.
          WHEN 'A' THEN FILL-IN-Estado:SCREEN-VALUE = 'ANULADO'.
          OTHERWISE FILL-IN-Estado:SCREEN-VALUE = '???'.
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
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'NO' THEN
      ASSIGN
      CcbCMvto.CodCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      CcbCMvto.CodMon:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      CcbCMvto.TpoCmb:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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
  IF CCBCMVTO.FLGEST <> "A" THEN RUN ccb/rcanjexletra (ROWID(CCBCMVTO)).

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
  RUN Procesa-Handle IN lh_Handle ('Pagina1').

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
  {src/adm/template/snd-list.i "CcbCMvto"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel V-table-Win 
PROCEDURE ue-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pFila AS INT.    
DEFINE INPUT PARAMETER chWorkSheet AS COM-HANDLE.
DEFINE OUTPUT PARAMETER pFilaRet AS INT.

DEFINE VAR iColumn AS INT.
DEFINE VAR CColumn AS CHAR.
DEFINE VAR cRange AS CHAR.

iColumn = pFila.
cColumn = STRING(iColumn).

cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "DATOS DEL CANJE".

iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Numero :".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "'" + ccbcmvto.Nrodoc.
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Estado :".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = FILL-IN-estado:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Usuario :".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = ccbcmvto.usuario.
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Fecha de Canje :".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = ccbcmvto.fchdoc.

iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Cliente :".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "'" + ccbcmvto.codcli.
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Fecha de Aprobacion :".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = ccbcmvto.fchApr.

iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Nombre :".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = FILL-IN-Nomcli:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Moneda de Canje :".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = IF (ccbcmvto.CodMon = 1) THEN "SOLES" ELSE "DOLARES".

iColumn = iColumn + 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Observaciones :".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = ccbcmvto.glosa.
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Tipo de cambio :".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = ccbcmvto.TpoCmb.

iColumn = iColumn + 1.
pFilaRet = iColumn.

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

DEF VAR s-impori AS DEC NO-UNDO.
DEF VAR s-implet AS DEC NO-UNDO.
DEF VAR x-sdoact AS DEC NO-UNDO.

DO WITH FRAME {&FRAME-NAME} :
    IF CcbCMvto.CodCli:SCREEN-VALUE = "" THEN DO:
       MESSAGE 'Codigo de Cliente en blanco' VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY":U TO CcbCMvto.CodCli.
       RETURN 'ADM-ERROR'.
    END.
    DEF VAR pClienteOpenOrange AS LOG NO-UNDO.
    RUN gn/clienteopenorange (cl-codcia, CcbCMvto.CodCli:SCREEN-VALUE, s-coddoc, OUTPUT pClienteOpenOrange).
    IF pClienteOpenOrange = YES THEN DO:
        MESSAGE "Cliente NO se puede antender por Continental" SKIP
            "Solo se le puede antender por OpenOrange"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO CcbCMvto.CodCli.
        RETURN "ADM-ERROR".   
    END.

    /* Veamos si hay letras */
    FIND FIRST DOCU NO-LOCK NO-ERROR.
    IF NOT AVAILABLE DOCU THEN DO:
        MESSAGE 'NO hay canjes que generar' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    /* Verificamos Importes de Canje */
    ASSIGN
        s-impori = 0
        s-implet = 0.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO:
        /* CREACION: Consistencia de importes */
        FOR EACH MVTO WHERE MVTO.TpoRef = "O",
            FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddoc = MVTO.codref
            AND Ccbcdocu.nrodoc = MVTO.nroref:
            /* NO DEBE SER AL CONTADO */
            IF LOOKUP(Ccbcdocu.fmapgo, "000,001,002,003") > 0 THEN DO:
                MESSAGE 'Comprobante' ccbcdocu.coddoc ccbcdocu.nrodoc SKIP
                    'no puede ser' SKIP
                    'Su condición de venta es 000,001,002 ó 003'
                    VIEW-AS ALERT-BOX ERROR.
                RUN Procesa-Handle IN lh_Handle ('Browse-Docu').
                RETURN "ADM-ERROR".
            END.
/*             IF s-codmon = Ccbcdocu.codmon THEN x-sdoact = Ccbcdocu.sdoact.        */
/*             ELSE IF s-codmon = 1 THEN x-sdoact = Ccbcdocu.sdoact * s-tpocmb.      */
/*                 ELSE x-sdoact = Ccbcdocu.sdoact / s-tpocmb.                       */
/*                      MESSAGE ccbcdocu.coddoc ccbcdocu.nrodoc SKIP                 */
/*                          mvto.imptot x-sdoact SKIP                                */
/*                          s-codmon.                                                */
/*             IF MVTO.imptot > x-sdoact THEN DO:                                    */
/*                 MESSAGE 'El importe a canjear supera el saldo del documento' SKIP */
/*                     MVTO.codref MVTO.nroref                                       */
/*                     VIEW-AS ALERT-BOX ERROR.                                      */
/*                 MVTO.ImpTot = x-SdoAct.                                           */
/*                 RUN Procesa-Handle IN lh_Handle ('Browse-Docu').                  */
/*                 RETURN "ADM-ERROR".                                               */
/*             END.                                                                  */
            /* No debe estar en otro canje */
            FIND FIRST B-CMVTO WHERE B-CMVTO.codcia = s-codcia
                AND B-CMVTO.coddoc = s-coddoc
                AND B-CMVTO.flgest = 'P'
                AND B-CMVTO.codcli = CcbCMvto.CodCli:SCREEN-VALUE
                AND CAN-FIND(FIRST Ccbdmvto WHERE Ccbdmvto.codcia = B-CMVTO.codcia
                             AND Ccbdmvto.coddoc = B-CMVTO.coddoc
                             AND Ccbdmvto.coddiv = B-CMVTO.coddiv
                             AND Ccbdmvto.nrodoc = B-CMVTO.nrodoc
                             AND Ccbdmvto.codref = Ccbcdocu.coddoc
                             AND Ccbdmvto.nroref = Ccbcdocu.nrodoc
                             NO-LOCK)
                NO-LOCK NO-ERROR.
            IF AVAILABLE B-CMVTO THEN DO:
                MESSAGE 'El comprobante' Ccbcdocu.coddoc Ccbcdocu.nrodoc SKIP
                    'se encuentra registrado en el canje por aprobar' B-CMVTO.nrodoc
                    VIEW-AS ALERT-BOX ERROR.
                RUN Procesa-Handle IN lh_Handle ('Browse-Docu').
                RETURN "ADM-ERROR".
            END.
            ASSIGN
                s-impori = s-impori + MVTO.ImpTot * (IF MVTO.codref = 'N/C' THEN -1 ELSE 1).
        END.
    END.
    ELSE DO:
        /* MODIFICACION: Solo acumulamos importe */
        FOR EACH Ccbdmvto NO-LOCK WHERE Ccbdmvto.codcia = Ccbcmvto.codcia
            AND Ccbdmvto.coddoc = Ccbcmvto.coddoc
            AND Ccbdmvto.nrodoc = Ccbcmvto.nrodoc
            AND Ccbdmvto.TpoRef = "O":
            s-impori = s-impori + Ccbdmvto.ImpTot * (IF Ccbdmvto.codref = 'N/C' THEN -1 ELSE 1).
        END.
    END.
    FOR EACH DOCU:
        s-implet = s-implet + DOCU.imptot.
    END.
    IF s-impori <> s-implet THEN DO:
       MESSAGE 'Verificar el importe total de los canjes' VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY":U TO CcbCMvto.Glosa.
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

IF Ccbcmvto.FlgEst <> "P" THEN DO:
    MESSAGE "Acceso Denegado" VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Ccbcmvto.codcia
    AND Ccbcdocu.coddiv = Ccbcmvto.coddiv
    AND Ccbcdocu.coddoc = "LET"
    AND Ccbcdocu.codref = Ccbcmvto.coddoc
    AND Ccbcdocu.nroref = Ccbcmvto.nrodoc:
    IF Ccbcdocu.flgest <> "X" THEN DO:
        MESSAGE "Hay un error en la letra" Ccbcdocu.nrodoc SKIP
            'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
END.
ASSIGN
    S-CODCLI = Ccbcmvto.codcli
    S-CODMON = Ccbcmvto.codmon
    S-TPOCMB = Ccbcmvto.tpocmb.
RUN Carga-Deta.
RUN Procesa-Handle IN lh_Handle ('Pagina3').
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Anulacion V-table-Win 
PROCEDURE Verifica-Anulacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* VERIFICAMOS EL ESTADO DE LA LETRA */
FOR EACH CcbCDocu NO-LOCK WHERE CcbCDocu.CodCia = CcbCMvto.CodCia 
    AND CcbCDocu.CodDiv = CcbCMvto.CodDiv
    AND CcbCDOcu.CodDoc = "LET"
    AND CcbCDocu.CodRef = CcbCMvto.CodDoc 
    AND CcbCDocu.NroRef = CcbCMvto.NroDoc:
    IF Ccbcdocu.FlgEst <> 'P' THEN DO:
        MESSAGE 'La letra' Ccbcdocu.nrodoc 'NO está pendiente'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF NOT (CcbCDocu.FlgEst = 'P' AND CcbCDocu.FlgUbi = 'C') THEN DO:
        MESSAGE 'La letra' Ccbcdocu.nrodoc 'NO está en cartera'
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

