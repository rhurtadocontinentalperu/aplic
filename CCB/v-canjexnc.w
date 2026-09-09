&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE MVTO LIKE CcbDMvto.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.



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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR s-coddoc AS CHAR.
DEFINE SHARED VAR s-nroser AS INT.
DEFINE SHARED VAR S-CODCLI   AS CHAR. 
DEFINE SHARED VAR S-CODMON   AS INTEGER.
DEFINE SHARED VAR S-TPOCMB   AS DECIMAL.
DEFINE SHARED VAR lh_handle AS HANDLE.

/* Nro de serie de la nueva N/C */
DEFINE VAR x-NroSerNC  LIKE FacCorre.Correlativo NO-UNDO.
DEFINE VAR x-NroSerFAC LIKE FacCorre.Correlativo NO-UNDO.
DEFINE VAR x-Concepto AS CHAR NO-UNDO.
DEFINE VAR x-Mensaje-Error AS CHAR NO-UNDO.

DEFINE VAR s-PorIgv AS DEC NO-UNDO.
DEFINE VAR s-CndCre AS CHAR INIT 'N' NO-UNDO.
DEFINE VAR s-TpoFac AS CHAR INIT '' NO-UNDO.
ASSIGN s-TpoFac = s-coddoc.

DEF TEMP-TABLE ITEM NO-UNDO LIKE Ccbddocu.  /* Detalle de la FAC */

DEF BUFFER B-CDOCU FOR Ccbcdocu.
DEF BUFFER B-DMVTO FOR Ccbdmvto.

DEF TEMP-TABLE Reporte LIKE Ccbcdocu.

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
&Scoped-define EXTERNAL-TABLES CcbCMvto
&Scoped-define FIRST-EXTERNAL-TABLE CcbCMvto


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCMvto.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCMvto.NroDoc CcbCMvto.FchDoc ~
CcbCMvto.CodCli CcbCMvto.Usuario CcbCMvto.Glosa 
&Scoped-define ENABLED-TABLES CcbCMvto
&Scoped-define FIRST-ENABLED-TABLE CcbCMvto
&Scoped-Define DISPLAYED-FIELDS CcbCMvto.NroDoc CcbCMvto.FchDoc ~
CcbCMvto.CodCli CcbCMvto.Usuario CcbCMvto.Glosa 
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
     CcbCMvto.NroDoc AT ROW 1.19 COL 10 COLON-ALIGNED WIDGET-ID 22
          LABEL "Numero" FORMAT "XXX-XXXXXXXX"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     FILL-IN-Estado AT ROW 1.19 COL 32 COLON-ALIGNED WIDGET-ID 34
     CcbCMvto.FchDoc AT ROW 1.19 COL 71 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCMvto.CodCli AT ROW 2.15 COL 10 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     CcbCMvto.Usuario AT ROW 2.15 COL 71 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FILL-IN-NomCli AT ROW 3.12 COL 10 COLON-ALIGNED WIDGET-ID 26
     CcbCMvto.Glosa AT ROW 4.08 COL 10 COLON-ALIGNED WIDGET-ID 20
          LABEL "Glosa"
          VIEW-AS FILL-IN 
          SIZE 55 BY .81
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
      TABLE: MVTO T "SHARED" ? INTEGRAL CcbDMvto
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
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
         HEIGHT             = 4.96
         WIDTH              = 119.57.
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

/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.Glosa IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.NroDoc IN FRAME F-Main
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

&Scoped-define SELF-NAME CcbCMvto.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.CodCli V-table-Win
ON LEAVE OF CcbCMvto.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  RUN vtagn/p-gn-clie-01 (SELF:SCREEN-VALUE, s-CodDoc).
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
  s-CodCli = SELF:SCREEN-VALUE.
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = s-codcli
      NO-LOCK.
  DISPLAY 
      gn-clie.NomCli @ FILL-IN-NomCli
      WITH FRAME {&FRAME-NAME}.
  SELF:SENSITIVE = NO.
  RUN Carga-Saldos.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancela-Comprobantes V-table-Win 
PROCEDURE Cancela-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH Ccbdmvto NO-LOCK WHERE CcbDMvto.CodCia =  CcbCMvto.CodCia 
    AND CcbDMvto.CodDiv = CcbCMvto.CodDiv 
    AND CcbDMvto.CodDoc = CcbCMvto.CodDoc 
    AND CcbDMvto.NroDoc = CcbCMvto.NroDoc
    AND CcbDMvto.TpoRef = "O",  /* OJO */
    FIRST Ccbcdocu WHERE Ccbcdocu.codcia = Ccbdmvto.codcia
    AND Ccbcdocu.coddoc = Ccbdmvto.codref
    AND Ccbcdocu.nrodoc = Ccbdmvto.nroref
    ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CREATE Ccbdcaja.
    ASSIGN
        CcbDCaja.CodCia = Ccbdmvto.codcia
        CcbDCaja.CodDiv = Ccbdmvto.coddiv
        CcbDCaja.CodDoc = Ccbdmvto.coddoc
        CcbDCaja.NroDoc = Ccbdmvto.nrodoc
        CcbDCaja.CodCli = Ccbcdocu.codcli
        CcbDCaja.CodRef = Ccbcdocu.coddoc
        CcbDCaja.NroRef = Ccbcdocu.nrodoc
        CcbDCaja.FchDoc = Ccbcmvto.fchdoc
        CcbDCaja.ImpTot = CcbDMvto.ImpTot   /* OJO */
        CcbDCaja.CodMon = Ccbcdocu.codmon
        CcbDCaja.TpoCmb = Ccbcdocu.tpocmb.
    ASSIGN
        Ccbcdocu.sdoact = Ccbcdocu.sdoact - Ccbdcaja.imptot.
    IF Ccbcdocu.sdoact <= 0 THEN Ccbcdocu.flgest = "C".
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Saldos V-table-Win 
PROCEDURE Carga-Saldos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE MVTO.
FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.codcli = s-codcli
    AND Ccbcdocu.flgest = 'P'
    AND Ccbcdocu.imptot = Ccbcdocu.sdoact   /* Incólumes */
    AND Ccbcdocu.coddoc = 'FAC':
    CREATE MVTO.
    BUFFER-COPY Ccbcdocu TO MVTO
        ASSIGN
        MVTO.CodRef = Ccbcdocu.coddoc
        MVTO.NroRef = Ccbcdocu.nrodoc
        MVTO.FchEmi = Ccbcdocu.fchdoc
        MVTO.FchVto = Ccbcdocu.fchvto
        MVTO.FlgCbd = NO
        MVTO.ImpDoc = Ccbcdocu.imptot
        MVTO.ImpTot = Ccbcdocu.sdoact
        MVTO.TpoRef = "O".  /* OJO */
END.
RUN Procesa-Handle IN lh_handle ("browse-docu").

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-Cancelacion V-table-Win 
PROCEDURE Extorna-Cancelacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH Ccbdmvto NO-LOCK WHERE CcbDMvto.CodCia =  CcbCMvto.CodCia 
    AND CcbDMvto.CodDiv = CcbCMvto.CodDiv 
    AND CcbDMvto.CodDoc = CcbCMvto.CodDoc 
    AND CcbDMvto.NroDoc = CcbCMvto.NroDoc
    AND CcbDMvto.TpoRef = "O",  /* OJO */
    FIRST Ccbcdocu WHERE Ccbcdocu.codcia = Ccbdmvto.codcia
    AND Ccbcdocu.coddoc = Ccbdmvto.codref
    AND Ccbcdocu.nrodoc = Ccbdmvto.nroref
    ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND Ccbdcaja WHERE CcbDCaja.CodCia = Ccbdmvto.codcia
        AND CcbDCaja.CodDiv = Ccbdmvto.coddiv
        AND CcbDCaja.CodDoc = Ccbdmvto.coddoc
        AND CcbDCaja.NroDoc = Ccbdmvto.nrodoc
        AND CcbDCaja.CodRef = Ccbcdocu.coddoc
        AND CcbDCaja.NroRef = Ccbcdocu.nrodoc
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbdcaja THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        Ccbcdocu.sdoact = Ccbcdocu.sdoact + Ccbdcaja.imptot
        Ccbcdocu.flgest = "P".
    DELETE Ccbdcaja.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-NC V-table-Win 
PROCEDURE Extorna-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH Ccbdmvto NO-LOCK WHERE Ccbdmvto.CodCia = Ccbcmvto.codcia
    AND Ccbdmvto.CodDiv = Ccbcmvto.coddiv
    AND Ccbdmvto.CodDoc = Ccbcmvto.coddoc
    AND Ccbdmvto.NroDoc = Ccbcmvto.nrodoc
    AND Ccbdmvto.TpoRef = "L"
    AND Ccbdmvto.CodRef = "N/C",
    FIRST Ccbcdocu WHERE Ccbcdocu.CodCia = Ccbdmvto.codcia
    AND Ccbcdocu.CodDoc = Ccbdmvto.codref
    AND Ccbcdocu.NroDoc = Ccbdmvto.nroref
    TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR' :
    ASSIGN
        CcbCDocu.FlgEst = "A"
        CcbCDocu.UsuAnu = s-user-id
        CcbCDocu.FchAnu = TODAY.
    /* Control de asignación de la N/C */
    FIND Ccbdmov WHERE CCBDMOV.CodCia = Ccbcdocu.codcia
        AND CCBDMOV.CodDiv = Ccbcdocu.coddiv
        AND CCBDMOV.CodDoc = Ccbcdocu.coddoc
        AND CCBDMOV.NroDoc = Ccbcdocu.nrodoc
        AND CCBDMOV.CodRef = Ccbcmvto.coddoc    /* El Canje */
        AND CCBDMOV.NroRef = Ccbcmvto.nrodoc
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbdmov THEN DO:
        UNDO, RETURN 'ADM-ERROR'.
    END.
    DELETE Ccbdmov.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-Nueva-FAC V-table-Win 
PROCEDURE Extorna-Nueva-FAC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH Ccbdmvto NO-LOCK WHERE Ccbdmvto.CodCia = Ccbcmvto.codcia
    AND Ccbdmvto.CodDiv = Ccbcmvto.coddiv
    AND Ccbdmvto.CodDoc = Ccbcmvto.coddoc
    AND Ccbdmvto.NroDoc = Ccbcmvto.nrodoc
    AND Ccbdmvto.TpoRef = "L"
    AND Ccbdmvto.CodRef = "FAC",
    FIRST Ccbcdocu WHERE Ccbcdocu.CodCia = Ccbdmvto.codcia
    AND Ccbcdocu.CodDoc = Ccbdmvto.codref
    AND Ccbcdocu.NroDoc = Ccbdmvto.nroref
    TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR' :
    /* CONSISTENCIA DE CANJE POR LETRA EN TRAMITE */
    IF Ccbcdocu.FlgSit = "X" THEN DO:
        x-Mensaje-Error = "La " + ccbcdocu.coddoc + ccbcdocu.nrodoc 
            + " tiene un CANJE por LETRA en trámite".
        UNDO, RETURN "ADM-ERROR".
    END.
    IF NOT (Ccbcdocu.flgest = 'P' AND Ccbcdocu.imptot = Ccbcdocu.sdoact) 
        THEN DO:
        UNDO, RETURN "ADM-ERROR".
    END.
    /* ****************************************** */
    ASSIGN
        CcbCDocu.FlgEst = "A"
        CcbCDocu.UsuAnu = s-user-id
        CcbCDocu.FchAnu = TODAY.
END.
RETURN 'OK'.

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

    /* PRIMERO LOS DOCUMENTOS A CANJEAR */
    ASSIGN
        CcbCMvto.ImpTot = 0.
    FOR EACH MVTO WHERE MVTO.Tporef = "O" AND MVTO.FlgCbd = YES,
        FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = MVTO.codref
        AND Ccbcdocu.nrodoc = MVTO.nroref:
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
        /* OJO con estos valores */
        ASSIGN
            CcbCMvto.CodMon = Ccbcdocu.CodMon
            CcbCMvto.ImpTot = CcbCMvto.ImpTot + MVTO.ImpTot.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-NC V-table-Win 
PROCEDURE Genera-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Se va a genera 1 x cada factura */

DEF VAR s-CodDoc AS CHAR INIT 'N/C' NO-UNDO.    /* OJO */
/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

FOR EACH B-DMVTO NO-LOCK WHERE B-DMVTO.CodCia = Ccbcmvto.codcia
    AND B-DMVTO.CodDiv = Ccbcmvto.coddiv
    AND B-DMVTO.CodDoc = Ccbcmvto.coddoc
    AND B-DMVTO.NroDoc = Ccbcmvto.nrodoc
    AND B-DMVTO.TpoRef = "O",
    FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.CodCia = B-DMVTO.codcia
    AND B-CDOCU.CodDoc = B-DMVTO.codref
    AND B-CDOCU.NroDoc = B-DMVTO.nroref
    TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR' :
    /* Bloqueamos correlativo */
    {lib/lock-genericov2.i ~
        &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = s-codcia ~
        AND FacCorre.CodDiv = s-coddiv ~
        AND FacCorre.CodDoc = s-coddoc ~
        AND FacCorre.NroSer = x-NroSerNC" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="RETURN 'ADM-ERROR'" ~
        }
    CREATE Ccbcdocu.
    ASSIGN 
        CcbCDocu.CodCia = S-CODCIA
        CcbCDocu.CodDiv = S-CODDIV
        CcbCDocu.CodDoc = s-CodDoc
        /*CcbCDocu.NroDoc = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")*/
        CcbCDocu.NroDoc = STRING(FacCorre.NroSer, ENTRY(1,x-Formato,'-')) +
                            STRING(FacCorre.Correlativo, ENTRY(2,x-Formato,'-'))
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.FchVto = ADD-INTERVAL (TODAY, 1, 'years')
        CcbCDocu.CodCli = Ccbcmvto.codcli
        CcbCDocu.NomCli = gn-clie.nomcli
        CcbCDocu.RucCli = gn-clie.Ruc
        CcbCDocu.DirCli = gn-clie.dircli
        /* Referencia */
        CcbCDocu.codref = B-CDOCU.coddoc
        CcbCDocu.nroref = B-CDOCU.nrodoc
        CcbCDocu.codmon = B-CDOCU.codmon
        CcbCDocu.fmapgo = B-CDOCU.fmapgo
        CcbCDocu.ImpTot = B-DMVTO.ImpTot    /* OJO */
        
        CcbCDocu.CodCta = x-Concepto
        CcbCDocu.PorIgv = FacCfgGn.PorIgv
        CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
        CcbCDocu.CndCre = s-CndCre     /* POR OTROS */
        CcbCDocu.TpoFac = s-TpoFac
        /*CcbCDocu.Tipo   = "OFICINA"*/
        CcbCDocu.usuario = S-USER-ID
        CcbCDocu.Tipo   = "CREDITO"     /* SUNAT */
        CcbCDocu.CodCaja= "".
    CREATE Reporte.
    BUFFER-COPY Ccbcdocu TO Reporte.
    /* Detalle */
    ASSIGN 
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia 
        AND CcbTabla.Tabla  = s-coddoc
        AND CcbTabla.Codigo = x-Concepto
        NO-LOCK.
    CREATE CcbDDocu.
    ASSIGN
        CcbDDocu.CodCia = CcbCDocu.CodCia 
        CcbDDocu.CodDiv = CcbCDocu.CodDiv 
        CcbDDocu.CodDoc = CcbCDocu.CodDoc 
        CcbDDocu.NroDoc = CcbCDocu.NroDoc 
        CcbDDocu.FchDoc = CcbCDocu.FchDoc
        CcbDDocu.CodCli = CcbCDocu.CodCli 
        CcbDDocu.codmat = x-Concepto
        CcbDDocu.CanDes = 1
        CcbDDocu.AftIsc = NO
        CcbDDocu.Factor = 1
        CcbDDocu.ImpLin = B-DMVTO.ImpTot
        CcbDDocu.NroItm = 1
        CcbDDocu.PreBas = B-DMVTO.ImpTot
        CcbDDocu.PreUni = B-DMVTO.ImpTot
        CcbDDocu.UndVta= 'UNI'.
    IF CcbTabla.Afecto THEN
        ASSIGN
        CcbDDocu.AftIgv = Yes
        CcbDDocu.ImpIgv = (CcbDDocu.CanDes * CcbDDocu.PreUni) * ((FacCfgGn.PorIgv / 100) / (1 + (FacCfgGn.PorIgv / 100))).
    ELSE
        ASSIGN
            CcbDDocu.AftIgv = No
            CcbDDocu.ImpIgv = 0.

    RUN Graba-Totales-NC.

    /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
/*     RUN sunat\progress-to-ppll ( INPUT ROWID(Ccbcdocu), OUTPUT x-Mensaje-Error ). */
    RUN sunat\progress-to-ppll-v3 ( INPUT Ccbcdocu.coddiv,
                                    INPUT Ccbcdocu.coddoc,
                                    INPUT Ccbcdocu.nrodoc,
                                    INPUT-OUTPUT TABLE T-FELogErrores,
                                    OUTPUT pMensaje ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    /* *********************************************************** */

    ASSIGN
        CcbCDocu.SdoAct = 0     /* OJO */
        CcbCDocu.FlgEst = "C".  /* OJO Las N/C nacen APLICADAS */
    /* Control de asignación de la N/C */
    CREATE Ccbdmov.
    ASSIGN
        CCBDMOV.CodCia = Ccbcdocu.codcia
        CCBDMOV.CodDiv = Ccbcdocu.coddiv
        CCBDMOV.CodDoc = Ccbcdocu.coddoc
        CCBDMOV.NroDoc = Ccbcdocu.nrodoc
        CCBDMOV.CodRef = Ccbcmvto.coddoc    /* El Canje */
        CCBDMOV.NroRef = Ccbcmvto.nrodoc
        CCBDMOV.CodCli = Ccbcdocu.codcli
        CCBDMOV.CodMon = Ccbcdocu.codmon
        CCBDMOV.FchDoc = Ccbcdocu.fchdoc
        CCBDMOV.FchMov = Ccbcdocu.fchdoc
        CCBDMOV.HraMov = STRING(TIME,'HH:MM:SS')
        CCBDMOV.ImpTot = Ccbcdocu.imptot
        CCBDMOV.TpoCmb = Ccbcdocu.tpocmb
        CCBDMOV.usuario = Ccbcdocu.usuario.
    /* Control en el canje */
    FIND CURRENT Ccbcdocu NO-LOCK.
    CREATE Ccbdmvto.
    ASSIGN 
        CcbDMvto.CodCia = CcbCMvto.CodCia 
        CcbDMvto.CodDiv = CcbCMvto.CodDiv
        CcbDMvto.CodDoc = CcbCMvto.CodDoc 
        CcbDMvto.NroDoc = CcbCMvto.NroDoc
        CcbDMvto.CodCli = CcbCMvto.CodCli
        CcbDMvto.TpoRef = "L"
        CcbDMvto.CodRef = Ccbcdocu.coddoc
        CcbDMvto.NroRef = Ccbcdocu.nrodoc
        CcbDMvto.ImpTot = Ccbcdocu.imptot.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Nueva-FAC V-table-Win 
PROCEDURE Genera-Nueva-FAC PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE s-CodDoc AS CHAR INIT 'FAC' NO-UNDO.
DEFINE VARIABLE s-FmaPgo AS CHAR NO-UNDO.
DEFINE VARIABLE s-CodMon AS INT NO-UNDO.
DEFINE VARIABLE s-DivOri LIKE Ccbcdocu.divori.
DEFINE VARIABLE s-CodAlm LIKE Ccbcdocu.codalm.
/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

DEFINE VARIABLE lCreaHeader AS LOGICAL NO-UNDO.
DEFINE VARIABLE iCountGuide AS INTEGER NO-UNDO.
DEFINE VARIABLE iCountItem AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE lItemOk AS LOGICAL NO-UNDO.

EMPTY TEMP-TABLE ITEM.
FOR EACH Ccbdmvto NO-LOCK WHERE Ccbdmvto.CodCia =  CcbCMvto.CodCia 
    AND Ccbdmvto.CodDiv = CcbCMvto.CodDiv 
    AND Ccbdmvto.CodDoc = CcbCMvto.CodDoc 
    AND Ccbdmvto.NroDoc = CcbCMvto.NroDoc
    AND Ccbdmvto.TpoRef = "O",  /* OJO */
    FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Ccbdmvto.codcia
    AND Ccbcdocu.coddoc = Ccbdmvto.codref
    AND Ccbcdocu.nrodoc = Ccbdmvto.nroref,
    EACH Ccbddocu OF Ccbcdocu NO-LOCK,
    FIRST Almmmatg OF Ccbddocu NO-LOCK:
    FIND ITEM WHERE ITEM.codmat = Ccbddocu.codmat NO-ERROR.
    IF NOT AVAILABLE ITEM THEN CREATE ITEM.
    ASSIGN
        ITEM.codcia = s-codcia
        ITEM.codmat = Ccbddocu.codmat
        ITEM.factor = 1
        ITEM.candes = ITEM.candes + (Ccbddocu.candes * Ccbddocu.factor)
        ITEM.undvta = Almmmatg.undstk
        ITEM.implin = ITEM.implin + (Ccbddocu.implin - Ccbddocu.impdto2)
        ITEM.preuni = ROUND(ITEM.implin / ITEM.candes, 4).
    ASSIGN
        s-FmaPgo = Ccbcdocu.fmapgo
        s-CodMon = Ccbcdocu.codmon
        s-DivOri = Ccbcdocu.divori
        s-CodAlm = Ccbcdocu.codalm.
END.
FIND FIRST ITEM NO-LOCK NO-ERROR.
IF NOT AVAILABLE ITEM THEN RETURN 'ADM-ERROR'.
trloop:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Bloqueamos correlativo */
    {lib/lock-genericov2.i ~
        &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = s-codcia ~
        AND FacCorre.CodDiv = s-coddiv ~
        AND FacCorre.CodDoc = s-coddoc ~
        AND FacCorre.NroSer = x-NroSerFAC" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="RETURN 'ADM-ERROR'" ~
        }

    iCountGuide = 0.
    lCreaHeader = TRUE.
    lItemOk = FALSE.

    FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK BREAK BY ITEM.CodCia BY ITEM.CodMat:
        IF lCreaHeader = YES THEN DO:
            /* Cabecera de Guía */
            CREATE Ccbcdocu.
            ASSIGN
                CcbCDocu.CodCia = s-codcia
                CcbCDocu.CodDiv = s-coddiv
                CcbCDocu.CodDoc = s-coddoc
                CcbCDocu.NroDoc = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999") 
                CcbCDocu.NroDoc = STRING(FacCorre.NroSer, ENTRY(1,x-Formato,'-')) +
                                    STRING(FacCorre.Correlativo, ENTRY(2,x-Formato,'-'))
                CcbCDocu.CodCli = gn-clie.codcli
                CcbCDocu.NomCli = gn-clie.nomcli
                CcbCDocu.DirCli = gn-clie.dircli
                CcbCDocu.RucCli = gn-clie.ruc
                CcbCDocu.CodDiv = s-CodDiv
                CcbCDocu.DivOri = s-DivOri    /* OJO: division de estadisticas */
                CcbCDocu.CodAlm = s-CodAlm
                CcbCDocu.FchDoc = TODAY
                CcbCDocu.CodRef = Ccbcmvto.coddoc
                CcbCDocu.NroRef = Ccbcmvto.nrodoc
                CcbCDocu.FchVto = TODAY
                CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
                CcbCDocu.FlgEst = "P"
                CcbCDocu.TpoFac = "CR"                  /* CREDITO */
                CcbCDocu.Tipo   = "CREDITO"
                CcbCDocu.usuario = S-USER-ID
                CcbCDocu.HorCie = STRING(TIME,'hh:mm')
                CcbCDocu.FlgCbd = YES
                CcbCDocu.FmaPgo = s-FmaPgo
                CcbCDocu.CodMon = s-CodMon
                CcbCDocu.PorIgv = FacCfgGn.PorIgv
                CcbCDocu.Tipo   = "CREDITO"     /* SUNAT */
                CcbCDocu.CodCaja= "".
            ASSIGN
                FacCorre.Correlativo = FacCorre.Correlativo + 1.
            FIND gn-convt WHERE gn-convt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
            IF AVAILABLE gn-convt THEN DO:
                CcbCDocu.TipVta = IF gn-ConVt.TotDias = 0 THEN "1" ELSE "2".
                CcbCDocu.FchVto = CcbCDocu.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(gn-ConVt.Vencmtos),gn-ConVt.Vencmtos)).
            END.
            IF AVAILABLE gn-clie  THEN DO:
                ASSIGN
                    CcbCDocu.CodDpto = gn-clie.CodDept 
                    CcbCDocu.CodProv = gn-clie.CodProv 
                    CcbCDocu.CodDist = gn-clie.CodDist.
            END.
            ASSIGN
                iCountGuide = iCountGuide + 1
                lCreaHeader = FALSE.
            CREATE Reporte.
            BUFFER-COPY Ccbcdocu TO Reporte.
        END.
        CREATE CcbDDocu.
        BUFFER-COPY ITEM TO CcbDDocu
        ASSIGN
            CcbDDocu.CodCia = CcbCDocu.CodCia
            CcbDDocu.CodDiv = CcbcDocu.CodDiv
            CcbDDocu.Coddoc = CcbCDocu.Coddoc
            CcbDDocu.NroDoc = CcbCDocu.NroDoc 
            CcbDDocu.FchDoc = CcbCDocu.FchDoc
            CcbDDocu.CodCli = CcbCDocu.CodCli
            CcbDDocu.NroItm = iCountItem
            CcbDDocu.Pesmat = Almmmatg.Pesmat * (CcbDDocu.Candes * CcbDDocu.Factor)
            Ccbddocu.AftIgv = Almmmatg.AftIgv
            Ccbddocu.AftIsc = Almmmatg.AftIsc
            Ccbddocu.AlmDes = s-CodAlm.
        /* CORREGIMOS IMPORTES */
        IF Ccbddocu.AftIsc 
            THEN Ccbddocu.ImpIsc = ROUND(Ccbddocu.PreBas * Ccbddocu.CanDes * (Almmmatg.PorIsc / 100),4).
        ELSE Ccbddocu.ImpIsc = 0.
             IF Ccbddocu.AftIgv 
                 THEN Ccbddocu.ImpIgv = Ccbddocu.ImpLin - ROUND( Ccbddocu.ImpLin  / ( 1 + (Ccbcdocu.PorIgv / 100) ), 4 ).
             ELSE Ccbddocu.ImpIgv = 0.
        iCountItem = iCountItem + 1.
        IF iCountItem > FacCfgGn.Items_Factura OR LAST-OF(ITEM.CodCia)  THEN DO:
            RUN Graba-Totales-FAC.

            /* GENERACION DE CONTROL DE PERCEPCIONES */
            RUN vta2/control-percepcion-cargos (ROWID(Ccbcdocu)) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN 'ADM-ERROR'.
            /* ************************************* */
            /* RHC 12.07.2012 limpiamos campos para G/R */
            ASSIGN
                Ccbcdocu.codref = ""
                Ccbcdocu.nroref = "".
            /* RHC 30-11-2006 Transferencia Gratuita */
            IF Ccbcdocu.FmaPgo = '900' THEN Ccbcdocu.sdoact = 0.
            IF Ccbcdocu.sdoact <= 0 
            THEN ASSIGN
                    Ccbcdocu.fchcan = TODAY
                    Ccbcdocu.flgest = 'C'.
            /* *********************************************************** */
            /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
/*             RUN sunat\progress-to-ppll ( INPUT ROWID(Ccbcdocu), OUTPUT pMensaje ). */
            RUN sunat\progress-to-ppll-v3( INPUT Ccbcdocu.coddiv,
                                           INPUT Ccbcdocu.coddoc,
                                           INPUT Ccbcdocu.nrodoc,
                                           INPUT-OUTPUT TABLE T-FELogErrores,
                                           OUTPUT pMensaje ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
            /* *********************************************************** */

            /* Registro de control */
            CREATE Ccbdmvto.
            ASSIGN 
                CcbDMvto.CodCia = CcbCMvto.CodCia 
                CcbDMvto.CodDiv = CcbCMvto.CodDiv
                CcbDMvto.CodDoc = CcbCMvto.CodDoc 
                CcbDMvto.NroDoc = CcbCMvto.NroDoc
                CcbDMvto.CodCli = CcbCMvto.CodCli
                CcbDMvto.TpoRef = "L"
                CcbDMvto.CodRef = Ccbcdocu.coddoc
                CcbDMvto.NroRef = Ccbcdocu.nrodoc
                CcbDMvto.ImpTot = Ccbcdocu.imptot.

        END.
        /* RHC 11/11/2013 QUEBRAMOS POR ZONA */
        IF iCountItem > FacCfgGn.Items_Factura THEN DO:
            iCountItem = 1.
            lCreaHeader = TRUE.
            lItemOk = FALSE.
        END.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Temp-FeLogErrores V-table-Win 
PROCEDURE Graba-Temp-FeLogErrores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-FeLogErrores:
    CREATE FeLogErrores.
    BUFFER-COPY T-FeLogErrores TO FeLogErrores NO-ERROR.
    DELETE T-FeLogErrores.
END.
IF AVAILABLE(FeLogErrores) THEN RELEASE FeLogErrores.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales-FAC V-table-Win 
PROCEDURE Graba-Totales-FAC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {vta2/graba-totales-factura-cred.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales-NC V-table-Win 
PROCEDURE Graba-Totales-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta/graba-totales-abono.i}

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
          STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999") @ CcbCMvto.NroDoc.
      ASSIGN
          s-tpocmb = FacCfgGn.Tpocmb[1]
          s-codmon = 1
          s-porigv = FacCfgGn.PorIgv.
  END.
  EMPTY TEMP-TABLE MVTO.
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
  EMPTY TEMP-TABLE Reporte.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}
  ASSIGN 
      CcbCMvto.CodCia = S-CODCIA
      CcbCMvto.CodDiv = S-CODDIV
      CcbCMvto.CodDoc = S-CODDOC
      CcbCMvto.NroDoc = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
      CcbCMvto.FchDoc = TODAY
      CcbCMvto.FlgEst = "E"     /* Aprobado */
      CcbCMvto.usuario = S-USER-ID.
  ASSIGN
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
  FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
      AND  gn-clie.CodCli = CcbCMvto.CodCli 
      NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie 
      THEN ASSIGN 
            CcbCMvto.CodDpto = gn-clie.CodDept 
            CcbCMvto.CodProv = gn-clie.CodProv 
            CcbCMvto.CodDist = gn-clie.CodDist.
  
  RUN Genera-Detalle.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      RUN Unlock-Tables.
      x-Mensaje-Error = 'NO se pudo generar el detalle del canje'.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  RUN Genera-NC.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      RUN Unlock-Tables.
      IF x-Mensaje-Error = '' THEN x-Mensaje-Error = 'NO se pudo generar la nota de crédito'.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  RUN Cancela-Comprobantes.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      RUN Unlock-Tables.
      x-Mensaje-Error = 'NO se pudo cancelar los comprobantes'.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  RUN Genera-Nueva-FAC.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      RUN Unlock-Tables.
      x-Mensaje-Error = 'NO se pudo generar la nueva factura'.
      UNDO, RETURN 'ADM-ERROR'.
  END.


  RUN Unlock-Tables.

  /* GENERACION DE INFORMACION PARA SUNAT */
  FOR EACH Reporte NO-LOCK,
      FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.CodCia = Reporte.CodCia 
      AND B-CDOCU.CodDoc = Reporte.CodDoc 
      AND B-CDOCU.NroDoc = Reporte.NroDoc:
      /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
/*       RUN sunat\progress-to-ppll-v21 ( INPUT ROWID(B-CDOCU),            */
/*                                      INPUT-OUTPUT TABLE T-FELogErrores, */
/*                                      OUTPUT pMensaje ).                 */
      RUN sunat\progress-to-ppll-v3 ( INPUT B-CDOCU.coddiv,
                                      INPUT B-CDOCU.coddoc,
                                      INPUT B-CDOCU.nrodoc,
                                      INPUT-OUTPUT TABLE T-FELogErrores,
                                      OUTPUT pMensaje ).
      /* *********************************************************** */
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
  RUN Unlock-Tables.

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

  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* ********************************************* */
  /* Inicio de actividades facturación electrónica */
  /* ********************************************* */
  DEF VAR pStatus AS LOG.
  RUN sunat\p-inicio-actividades (INPUT Ccbcmvto.fchdoc, OUTPUT pStatus).
  IF pStatus = YES THEN DO:     /* Ya iniciaron las actividades */
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.
  /* ********************************************* */

  IF Ccbcmvto.flgest = "A" THEN DO:
      MESSAGE 'YA está anulado' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  /* consistencia de la fecha del cierre del sistema */
  IF s-user-id <> 'ADMIN' THEN DO:
      DEF VAR dFchCie AS DATE.
      RUN gn/fecha-de-cierre (OUTPUT dFchCie).
      IF Ccbcmvto.fchdoc <= dFchCie THEN DO:
          MESSAGE 'NO se puede anular/modificar ningun documento antes del' (dFchCie + 1)
              VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  x-Mensaje-Error = ''.
  RUN my-local-delete-record.
  FIND CURRENT Ccbcmvto NO-LOCK NO-ERROR.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF x-Mensaje-Error <> '' THEN MESSAGE x-Mensaje-Error VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
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
  IF AVAILABLE Ccbcmvto THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          FILL-IN-NomCli = ''.
      FIND gn-clie WHERE gn-clie.codcia = cl-codcia
          AND gn-clie.codcli = Ccbcmvto.codcli
          NO-LOCK NO-ERROR.
      IF AVAILABLE gn-clie THEN FILL-IN-NomCli = gn-clie.nomcli.
      DISPLAY FILL-IN-NomCli.
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
  DO WITH FRAME {&FRAME-NAME}:
      DISABLE CcbCMvto.Usuario CcbCMvto.FchDoc CcbCMvto.NroDoc.
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
  RUN ccb\d-canjexnc ( OUTPUT x-NroSerNC, OUTPUT x-Concepto, OUTPUT x-NroSerFAC).
  IF x-NroSerNC = 0 OR x-NroSerFAC = 0 THEN RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */
  x-Mensaje-Error = ''.
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF x-Mensaje-Error <> '' THEN MESSAGE x-Mensaje-Error VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina1').


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE my-local-delete-record V-table-Win 
PROCEDURE my-local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND CURRENT Ccbcmvto EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Ccbcmvto THEN RETURN 'ADM-ERROR'.
      ASSIGN
          CcbCMvto.FlgEst = "A"
          CcbCMvto.Libre_chr[1] = s-user-id + '|' + STRING(DATETIME(TODAY,MTIME)).

      /* Anulamos la N/C */
      RUN Extorna-NC.
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          RUN Unlock-Tables.
          x-Mensaje-Error = 'NO se pudo extornar las N/C'.
          UNDO, RETURN 'ADM-ERROR'.
      END.

      RUN Extorna-Cancelacion.
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          RUN Unlock-Tables.
          x-Mensaje-Error = 'NO se pudo extornar las cancelaciones'.
          UNDO, RETURN 'ADM-ERROR'.
      END.

      RUN Extorna-Nueva-FAC.
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          RUN Unlock-Tables.
          IF x-Mensaje-Error = '' THEN x-Mensaje-Error = 'NO se pudo extornar la nueva factura'.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      RUN Unlock-Tables.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Unlock-Tables V-table-Win 
PROCEDURE Unlock-Tables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF AVAILABLE(ccbcdocu) THEN RELEASE ccbcdocu.
  IF AVAILABLE(ccbddocu) THEN RELEASE ccbddocu.
  IF AVAILABLE(ccbdmvto) THEN RELEASE ccbdmvto.
  IF AVAILABLE(faccorre) THEN RELEASE faccorre.
  IF AVAILABLE(ccbdmov)  THEN RELEASE ccbdmov.
  IF AVAILABLE(B-CDOCU) THEN RELEASE B-CDOCU.
  IF AVAILABLE(B-DMVTO) THEN RELEASE B-DMVTO.

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
    FIND FIRST MVTO WHERE MVTO.FlgCbd = YES NO-LOCK NO-ERROR.
    IF NOT AVAILABLE MVTO THEN DO:
        MESSAGE 'Debe seleccionar al menos 1 comprobante' VIEW-AS ALERT-BOX ERROR.
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

MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

