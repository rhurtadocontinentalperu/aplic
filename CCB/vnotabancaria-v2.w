&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
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
DEF SHARED VAR cb-codcia AS INT.
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-nroser AS INT.

DEFINE SHARED VARIABLE S-CODCLI AS CHAR. 
DEFINE SHARED VARIABLE S-CODMON AS INTEGER.
DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.
DEFINE SHARED VARIABLE s-codcta AS CHAR.
DEFINE SHARED VAR lh_handle AS HANDLE.

DEFINE BUFFER B-CMvto FOR CcbCMvto.
DEFINE BUFFER B-trazabilidad-mov FOR trazabilidad-mov.

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
&Scoped-Define ENABLED-FIELDS CcbCMvto.CodCta CcbCMvto.FchCbd ~
CcbCMvto.Libre_chr[1] CcbCMvto.Libre_dec[1] CcbCMvto.CodMon ~
CcbCMvto.Libre_chr[2] CcbCMvto.Libre_dec[2] CcbCMvto.TpoCmb CcbCMvto.Glosa 
&Scoped-define ENABLED-TABLES CcbCMvto
&Scoped-define FIRST-ENABLED-TABLE CcbCMvto
&Scoped-Define DISPLAYED-FIELDS CcbCMvto.NroDoc CcbCMvto.Usuario ~
CcbCMvto.FchDoc CcbCMvto.CodCta CcbCMvto.FchCbd CcbCMvto.Libre_chr[1] ~
CcbCMvto.Libre_dec[1] CcbCMvto.CodMon CcbCMvto.Libre_chr[2] ~
CcbCMvto.Libre_dec[2] CcbCMvto.TpoCmb CcbCMvto.Glosa 
&Scoped-define DISPLAYED-TABLES CcbCMvto
&Scoped-define FIRST-DISPLAYED-TABLE CcbCMvto
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Estado FILL-IN_Banco 

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

DEFINE VARIABLE FILL-IN_Banco AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCMvto.NroDoc AT ROW 1.19 COL 12 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-Estado AT ROW 1.19 COL 32 COLON-ALIGNED WIDGET-ID 34
     CcbCMvto.Usuario AT ROW 1.19 COL 53 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCMvto.FchDoc AT ROW 1.19 COL 83 COLON-ALIGNED WIDGET-ID 20
          LABEL "Fecha de Registro"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCMvto.CodCta AT ROW 1.96 COL 12 COLON-ALIGNED WIDGET-ID 46
          LABEL "Banco" FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN_Banco AT ROW 1.96 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     CcbCMvto.FchCbd AT ROW 1.96 COL 83 COLON-ALIGNED WIDGET-ID 54
          LABEL "Fecha de N/B"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCMvto.Libre_chr[1] AT ROW 2.73 COL 12 COLON-ALIGNED WIDGET-ID 56
          LABEL "Cuenta Ingresos"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCMvto.Libre_dec[1] AT ROW 2.73 COL 38 COLON-ALIGNED WIDGET-ID 60
          LABEL "Importe Ingresos" FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCMvto.CodMon AT ROW 2.73 COL 85 NO-LABEL WIDGET-ID 36
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "SOLES", 1,
"DOLARES", 2
          SIZE 18 BY .77
     CcbCMvto.Libre_chr[2] AT ROW 3.5 COL 12 COLON-ALIGNED WIDGET-ID 58
          LABEL "Cuenta Egresos"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCMvto.Libre_dec[2] AT ROW 3.5 COL 38 COLON-ALIGNED WIDGET-ID 62
          LABEL "Importe Egresos" FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCMvto.TpoCmb AT ROW 3.5 COL 83 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCMvto.Glosa AT ROW 4.27 COL 12 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 55 BY .81
     "Moneda del Banco:" VIEW-AS TEXT
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

/* SETTINGS FOR FILL-IN CcbCMvto.CodCta IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCMvto.FchCbd IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Banco IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.Libre_chr[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.Libre_chr[2] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCMvto.Libre_dec[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCMvto.Libre_dec[2] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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

&Scoped-define SELF-NAME CcbCMvto.CodCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.CodCta V-table-Win
ON LEAVE OF CcbCMvto.CodCta IN FRAME F-Main /* Banco */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia 
        AND cb-ctas.Codcta = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cb-ctas THEN DO:
       MESSAGE 'Cuenta contable no existe' VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    DISPLAY cb-ctas.Nomcta @ FILL-IN_Banco WITH FRAME {&FRAME-NAME}.
    ASSIGN
        s-codmon = cb-ctas.codmon
        s-codcta = cb-ctas.codcta
        CcbCMvto.CodMon:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(cb-ctas.codmon, '9')
        SELF:SENSITIVE = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.CodMon V-table-Win
ON VALUE-CHANGED OF CcbCMvto.CodMon IN FRAME F-Main /* Moneda */
DO:
   S-CodMon = INTEGER(CcbCMvto.CodMon:SCREEN-VALUE).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar V-table-Win 
PROCEDURE Aprobar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Ccbcmvto OR Ccbcmvto.flgest <> "X" THEN RETURN.

MESSAGE '¿Procedemos a APROBAR la Nota Bancaria?'
    VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR pCuenta AS INTE NO-UNDO.

SESSION:SET-WAIT-STATE("GENERAL").

RLOOP:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    FIND CURRENT Ccbcmvto EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
        SESSION:SET-WAIT-STATE("").
        UNDO, LEAVE.
    END.
    ASSIGN
        CcbCMvto.FchApr = TODAY
        CcbCMvto.FlgEst = "P".  /* OJO */
    FOR EACH Ccbdmvto NO-LOCK WHERE CcbDMvto.CodCia = CcbCMvto.CodCia 
        AND CcbDMvto.CodDoc = CcbCMvto.CodDoc 
        AND CcbDMvto.NroDoc = CcbCMvto.NroDoc:
        FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
            AND Ccbcdocu.coddoc = CcbDMvto.codref
            AND Ccbcdocu.nrodoc = CcbDMvto.nroref
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            SESSION:SET-WAIT-STATE("").
            UNDO RLOOP, LEAVE RLOOP.
        END.
        ASSIGN
            Ccbcdocu.sdoact = Ccbcdocu.sdoact - CcbDMvto.imptot.
        ASSIGN
            Ccbcdocu.flgest = (IF Ccbcdocu.sdoact <= 0 THEN 'C' ELSE 'P')
            Ccbcdocu.fchcan = (IF Ccbcdocu.sdoact <= 0 THEN Ccbcmvto.FchCbd ELSE ?).
        INSERT INTO CcbDCaja ( CodCia, CodDiv, CodDoc, NroDoc, 
                               CodRef, NroRef, ImpTot, FchDoc, 
                               CodCli, CodMon, TpoCmb )
            VALUES ( Ccbcmvto.CodCia, Ccbcmvto.CodDiv, Ccbcmvto.CodDoc, Ccbcmvto.NroDoc, 
                     Ccbcdocu.coddoc , Ccbcdocu.nrodoc, CcbDMvto.ImpTot, Ccbcmvto.FchCbd, 
                     Ccbcdocu.CodCli, Ccbcdocu.CodMon, CcbCMvto.TpoCmb ).
    END.

    /*
        04Mar2024, quedo sin efecto trazabilidad por esto:
        
    /* Todas las cancelaciones en donde uso el LPA o A/R (trazabilidad-mov-del-lpa) */
    FOR EACH x-ccbccaja WHERE x-ccbccaja.codcia = s-codcia and x-ccbccaja.tipo = 'CANCELACION' and 
                            x-ccbccaja.coddoc = 'I/C' and x-ccbccaja.codbco[7] = x-coddoc AND
                            x-ccbccaja.voucher[7] = x-nrodoc AND x-ccbccaja.flgest <> 'A' NO-LOCK:        
    
    Se demora un monton
    *------------------------------------------------------------------------
    
    /* Ic - 19Abr2021 - Trazabilidad */
    RUN trazabilidad(OUTPUT pMensaje).
    IF NOT (TRUE <> (pMensaje > "")) THEN DO:
        SESSION:SET-WAIT-STATE("").
        UNDO RLOOP, LEAVE RLOOP.
    END.
    */
END.

SESSION:SET-WAIT-STATE("").

RELEASE ccbcdocu NO-ERROR.
RELEASE b-trazabilidad-mov NO-ERROR.

IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH CcbDMvto EXCLUSIVE-LOCK WHERE CcbDMvto.CodCia = CcbCMvto.CodCia 
        AND CcbDMvto.CodDiv = CcbCMvto.CodDiv
        AND CcbDMvto.CodDoc = CcbCMvto.CodDoc 
        AND CcbDMvto.NroDoc = CcbCMvto.NroDoc:
        DELETE CcbDMvto.
    END.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Documento V-table-Win 
PROCEDURE Borra-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = CcbCMvto.CodCia 
    AND CcbDMvto.CodDiv = CcbCMvto.CodDiv
    AND CcbDMvto.CodDoc = CcbCMvto.CodDoc 
    AND CcbDMvto.NroDoc = CcbCMvto.NroDoc:
    FIND CcbCDocu WHERE CcbCDocu.codcia = Ccbdmvto.codcia 
        AND CcbCDocu.CodDoc = Ccbdmvto.codref 
        AND CcbCDocu.NroDoc = Ccbdmvto.Nroref EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        CcbCDocu.FlgUbi = CcbCDocu.FlgUbiA
        CcbCDocu.FchUbi = CcbCDocu.FchUbiA 
        CcbCDocu.FlgSit = CcbCDocu.FlgSitA.
    DELETE CcbDMvto.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle V-table-Win 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE MVTO.

    FOR EACH CcbDMvto NO-LOCK WHERE CcbDMvto.CodCia = CcbCMvto.CodCia 
        AND CcbDMvto.CodDiv = CcbCMvto.CodDiv
        AND CcbDMvto.CodDoc = CcbCMvto.CodDoc 
        AND CcbDMvto.NroDoc = CcbCMvto.NroDoc:
        CREATE MVTO.
        BUFFER-COPY CcbDMvto TO MVTO.
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

DEF VAR XfImport AS DEC NO-UNDO.

FOR EACH MVTO ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CREATE CcbDMvto.
    ASSIGN 
        CcbDMvto.CodCia = CcbCMvto.CodCia 
        CcbDMvto.CodDiv = CcbCMvto.CodDiv
        CcbDMvto.CodDoc = CcbCMvto.CodDoc 
        CcbDMvto.NroDoc = CcbCMvto.NroDoc
        CcbDMvto.CodRef = MVTO.CodRef
        CcbDMvto.NroRef = MVTO.NroRef
        CcbDMvto.NroDep = MVTO.NroDep
        CcbDMvto.ImpTot = MVTO.ImpTot.
    XfImport = XfImport + MVTO.ImpTot.
END.
ASSIGN
    CcbCMvto.ImpTot = XfImport + CcbCMvto.Libre_dec[1] - CcbCMvto.Libre_dec[2]
    CcbCMvto.ImpDoc = XfImport + CcbCMvto.Libre_dec[1] - CcbCMvto.Libre_dec[2].

RETURN 'OK'.

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
  FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      DISPLAY 
          TODAY @ CcbCMvto.FchDoc
          TODAY @ CcbCMvto.FchCbd
          gn-tcmb.compra @ CcbCMvto.TpoCmb      /*FacCfgGn.Tpocmb[1] @ CcbCMvto.TpoCmb*/
          STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999") @ CcbCMvto.NroDoc
          "77221100" @ CcbCMvto.Libre_chr[1]
          "96673613" @ CcbCMvto.Libre_chr[2].
      ASSIGN
          s-tpocmb = gn-tcmb.compra     /*FacCfgGn.Tpocmb[1]*/
          s-codcta = ''
          s-codmon = 0.     /* SIN VALOR */
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
  Notes:       NO se puede modificar
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}
      /* Por defecto FlgEst = "X" POR APROBAR */
      ASSIGN 
          CcbCMvto.CodCia = S-CODCIA
          CcbCMvto.CodDiv = S-CODDIV
          CcbCMvto.CodDoc = S-CODDOC
          CcbCMvto.FchDoc = TODAY
          CcbCMvto.FlgEst = "X"     /* "P" */
          CcbCMvto.NroDoc = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
          FacCorre.Correlativo = FacCorre.Correlativo + 1.
  END.
  ELSE DO:
      RUN Borra-Detalle.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  ASSIGN
      CcbCMvto.usuario = S-USER-ID.
  RUN Genera-Detalle.
  IF RETURN-VALUE = "ADM-ERROR" THEN DO:
      MESSAGE 'NO se pudo grabar el detalle' SKIP
          'Grabación abortada' VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN "ADM-ERROR".
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

  /* CHEQUEAMOS LAS LETRAS SI ES QUE SE PUEDE ANULAR             */
  IF CcbCMvto.FlgEst = "A" THEN DO:
     MESSAGE "DOCUMENTO HA SIDO ANULADO ANTERIORMENTE" SKIP 'Proceso abortado'
         VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".   
  END.
  IF CcbCMvto.FlgEst = "P" THEN DO:
     MESSAGE "DOCUMENTO HA SIDO APROBADO " SKIP 'Proceso abortado'
         VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".   
  END.
  IF s-user-id <> 'ADMIN' THEN DO:
      /* Verificamos el cierre contable */
      DEF VAR pFchCie AS DATE NO-UNDO.
      RUN gn/fFChCieCbd ("CREDITOS", OUTPUT pFchCie).
      IF pFchCie <> ? AND Ccbcmvto.FchDoc < pFchCie THEN DO:
          MESSAGE 'NO se puede anular documentos antes del' pFchCie SKIP
              'Consultar con CONTABILIDAD' VIEW-AS ALERT-BOX WARNING.
          RETURN 'ADM-ERROR'.
      END.
  END.
  
  DEF VAR pMensaje AS CHAR NO-UNDO.
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      FIND FIRST B-CMVTO WHERE B-CMVTO.CodCia = CCbCMvto.CodCia 
          AND B-CMVTO.CodDiv = CCbCMvto.CodDiv
          AND B-CMVTO.CodDoc = CCbCMvto.CodDoc 
          AND B-CMVTO.NroDoc = CCbCMvto.NroDoc EXCLUSIVE NO-ERROR NO-WAIT.
      IF ERROR-STATUS:ERROR = YES THEN DO:
          {lib/mensaje-de-error.i &MensajeError="pMensaje" }
          MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      ASSIGN 
          B-CMVTO.FlgEst = "A"
          B-CMVTO.Glosa  = "  * * * A N U L A D O * * *  POR " + s-User-Id + " " + STRING(today).
      RELEASE B-CMVTO.
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
      FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia 
          AND cb-ctas.codcta = CcbCMvto.CodCta NO-LOCK NO-ERROR.
      IF AVAILABLE cb-ctas THEN DISPLAY cb-ctas.nomcta @ FILL-IN_Banco.
      CASE Ccbcmvto.flgest:
          WHEN 'X' THEN FILL-IN-Estado:SCREEN-VALUE = 'POR APROBAR'.
          WHEN 'P' THEN FILL-IN-Estado:SCREEN-VALUE = 'APROBADO'.
          WHEN 'A' THEN FILL-IN-Estado:SCREEN-VALUE = 'ANULADO'.
          OTHERWISE FILL-IN-Estado:SCREEN-VALUE = Ccbcmvto.flgest.
      END CASE.

      /* Totales */
      RUN ue-calcula-totales.

      RUN Procesa-Botones IN lh_handle (CcbCMvto.FlgEst).
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
  ASSIGN
      CcbCMvto.CodMon:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      CcbCMvto.TpoCmb:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      CcbCMvto.Libre_chr[1]:SENSITIVE IN FRAME {&FRAME-NAME} = NO
      CcbCMvto.Libre_chr[2]:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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
  IF Ccbcmvto.flgest <> 'A' THEN RUN ccb/r-notban (ROWID(ccbcmvto)). 

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
        WHEN "CodAge" THEN 
            ASSIGN input-var-1 = CcbCMvto.CodCta:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        WHEN "CodCta" THEN 
            ASSIGN input-var-1 = "104".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trazabilidad V-table-Win 
PROCEDURE trazabilidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pRetVal AS CHAR.

DEFINE VAR hProc AS HANDLE NO-UNDO.             /* Handle Libreria */

RUN ccb\libreria-ccb.r PERSISTENT SET hProc.
/*
RUN trazabilidad-notas-bancarias IN hProc (INPUT CcbCMvto.CodDoc, INPUT CcbCMvto.NroDoc, 
                                                  OUTPUT pRetVal).
*/
RUN trazabilidad-inicial IN hProc (INPUT CcbCMvto.CodDoc, 
                                   INPUT CcbCMvto.NroDoc, 
                                   OUTPUT pRetVal).

DELETE PROCEDURE hProc.                 /* Release Libreria */

IF pRetVal <> "OK" THEN DO:
    RETURN "ADM-ERROR".
END.
ELSE DO:
    pRetVal = "".
    RETURN "OK".
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-calcula-totales V-table-Win 
PROCEDURE ue-calcula-totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-desde-excel V-table-Win 
PROCEDURE ue-desde-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF CcbCMvto.CodCta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:
  MESSAGE "Codigo de cuenta no puede se blanco " VIEW-AS ALERT-BOX ERROR.
  APPLY "ENTRY":U TO CcbCMvto.CodCta.
  RETURN "ADM-ERROR".
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-pinta-ingresos V-table-Win 
PROCEDURE ue-pinta-ingresos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pSumaIntereses AS DEC    NO-UNDO.

ccbcmvto.libre_dec[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(pSumaIntereses,">>,>>>,>>9.99").

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
    IF INPUT CcbCMvto.FchCbd > INPUT CcbCMvto.FchDoc THEN DO:
        MESSAGE 'La fecha de la N/B errada' VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO CcbCMvto.FchCbd.
        RETURN 'ADM-ERROR'.
    END.
    /* Verificamos el cierre contable */
    DEF VAR pFchCie AS DATE NO-UNDO.
    RUN gn/fFChCieCbd ("CREDITOS", OUTPUT pFchCie).
    IF pFchCie <> ? AND INPUT Ccbcmvto.FchCbd < pFchCie THEN DO:
        MESSAGE 'La fecha de la N/B no puede ser menor al' pFchCie VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO CcbCMvto.FchCbd.
        RETURN 'ADM-ERROR'.
    END.

    IF CcbCMvto.CodCta:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Codigo de cuenta no puede se blanco " VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY":U TO CcbCMvto.CodCta.
        RETURN "ADM-ERROR".
    END.
    FIND FIRST MVTO NO-LOCK NO-ERROR.
    IF NOT AVAILABLE MVTO THEN DO:
        MESSAGE 'NO ha ingresado ninguna letra' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.

    IF INPUT CcbCMvto.Libre_dec[1] <= 0 
        OR INPUT CcbCMvto.Libre_dec[2] <= 0 THEN DO:
        MESSAGE 'El importe de ingresos y/o de egresos es cero' SKIP
            'Continuamos con la grabación' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN DO:
            APPLY 'ENTRY':U TO CcbCMvto.Libre_dec[1].
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

IF AVAILABLE CcbCMvto AND CcbCMvto.FlgEst <> "X" THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.

 RUN Carga-Detalle.

 ASSIGN
     s-codmon = cb-ctas.codmon
     s-codcta = cb-ctas.codcta.

 RUN Procesa-Handle IN lh_handle ('Pagina2').
 RUN Procesa-Handle IN lh_handle ('browse').

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

