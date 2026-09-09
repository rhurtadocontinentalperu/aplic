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
DEFINE SHARED VARIABLE S-FLGUBI AS CHAR.
DEFINE SHARED VARIABLE S-FLGSIT AS CHAR.

DEFINE SHARED VARIABLE S-CODCLI AS CHAR. 
DEFINE SHARED VARIABLE S-CODMON AS INTEGER.
DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.
DEFINE SHARED VARIABLE s-codcta AS CHAR.
DEFINE SHARED VAR lh_handle AS HANDLE.

DEFINE BUFFER B-CMvto FOR CcbCMvto.

DEF STREAM txt-file.

DEFINE TEMP-TABLE tt-interbak
    FIELD   tnrodoc     AS  CHAR    FORMAT 'x(20)'      COLUMN-LABEL "Numero de Documento"
    FIELD   ttipodoc    AS  CHAR    FORMAT 'x(3)'       COLUMN-LABEL "Tipo de Doc."
    FIELD   tnroiden    AS  CHAR    FORMAT 'x(15)'      COLUMN-LABEL "Nro.Doc.Identidad"
    FIELD   trazonsoc   AS  CHAR    FORMAT 'x(80)'      COLUMN-LABEL "Razon Social / Nombre"
    FIELD   tapell1     AS  CHAR    FORMAT 'x(60)'      COLUMN-LABEL "Apellido 1"
    FIELD   tapell2     AS  CHAR    FORMAT 'x(60)'      COLUMN-LABEL "Apellido 2"
    FIELD   tdirecc     AS  CHAR    FORMAT 'x(100)'     COLUMN-LABEL "Direccion"
    FIELD   tdistrito   AS  CHAR    FORMAT 'x(100)'     COLUMN-LABEL "Distrito"
    FIELD   tprovincia  AS  CHAR    FORMAT 'x(100)'     COLUMN-LABEL "Provincia"
    FIELD   tdeparta    AS  CHAR    FORMAT 'x(100)'     COLUMN-LABEL "Departamento"
    FIELD   ttdapostal  AS  CHAR    FORMAT 'x(100)'     COLUMN-LABEL "Tienda Postal"
    FIELD   timptot     AS  DEC     FORMAT '>>,>>>,>>9.99'   COLUMN-LABEL "Importe Total"
    FIELD   tfchvto     AS  DATE    COLUMN-LABEL "Fecha de Vcto".

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
&Scoped-Define ENABLED-FIELDS CcbCMvto.CodCta CcbCMvto.CodMon ~
CcbCMvto.CodAge CcbCMvto.TpoCmb CcbCMvto.CodDpto CcbCMvto.Glosa 
&Scoped-define ENABLED-TABLES CcbCMvto
&Scoped-define FIRST-ENABLED-TABLE CcbCMvto
&Scoped-Define ENABLED-OBJECTS btnExcel 
&Scoped-Define DISPLAYED-FIELDS CcbCMvto.NroDoc CcbCMvto.Usuario ~
CcbCMvto.FchDoc CcbCMvto.CodCta CcbCMvto.CodMon CcbCMvto.CodAge ~
CcbCMvto.TpoCmb CcbCMvto.CodDpto CcbCMvto.Glosa 
&Scoped-define DISPLAYED-TABLES CcbCMvto
&Scoped-define FIRST-DISPLAYED-TABLE CcbCMvto
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Estado FILL-IN_Banco ~
FILL-IN-Agencia 

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
DEFINE BUTTON btnExcel 
     LABEL "Excel" 
     SIZE 11 BY 1.

DEFINE VARIABLE FILL-IN-Agencia AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

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
     CcbCMvto.CodCta AT ROW 1.96 COL 11 COLON-ALIGNED WIDGET-ID 46
          LABEL "Banco" FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN_Banco AT ROW 1.96 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     CcbCMvto.CodMon AT ROW 2.54 COL 85 NO-LABEL WIDGET-ID 36
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "SOLES", 1,
"DOLARES", 2
          SIZE 18 BY .77
     CcbCMvto.CodAge AT ROW 2.73 COL 11 COLON-ALIGNED WIDGET-ID 44
          LABEL "Agencia" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-Agencia AT ROW 2.73 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     CcbCMvto.TpoCmb AT ROW 3.31 COL 83 COLON-ALIGNED WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCMvto.CodDpto AT ROW 3.5 COL 11 COLON-ALIGNED WIDGET-ID 48
          LABEL "Plaza" FORMAT "X(2)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     CcbCMvto.Glosa AT ROW 4.27 COL 11 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 55 BY .81
     btnExcel AT ROW 4.42 COL 81.72 WIDGET-ID 54
     "Moneda del Banco:" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 2.73 COL 71 WIDGET-ID 40
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

/* SETTINGS FOR FILL-IN CcbCMvto.CodAge IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCMvto.CodCta IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCMvto.CodDpto IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCMvto.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN-Agencia IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Banco IN FRAME F-Main
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

&Scoped-define SELF-NAME btnExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnExcel V-table-Win
ON CHOOSE OF btnExcel IN FRAME F-Main /* Excel */
DO:

    /* Ic - 18Ene2018, considerar Interbank */
    /*
           Cobranza Libre M.N.  10416100
           Cobranza Libre M.E.  10416110
           Descuento M.N.       45511170
           Descuento M.E.       45511180    
    */
    DEFINE VAR x-cuentas-ibk AS CHAR.

    x-cuentas-ibk = "10416100,10416110,45511170,45511180,10411100".
    x-cuentas-ibk = "10416100,10416110,45511170,45511180".

    IF LOOKUP(CcbCMvto.codcta,x-cuentas-ibk) > 0 THEN DO:
        /* Es cta Interbank */
        /*RUN ue-excel-interbank.*/
        RUN ue-txt-interbank.
    END.
    ELSE DO:
        RUN ue-excel.
    END.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCMvto.CodAge
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCMvto.CodAge V-table-Win
ON LEAVE OF CcbCMvto.CodAge IN FRAME F-Main /* Agencia */
DO:
    FIND gn-agbco WHERE gn-agbco.codcia = s-codcia 
        AND  gn-agbco.codbco = INTEGRAL.CcbCMvto.CodCta:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
        AND gn-agbco.codage = SELF:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-agbco THEN 
        FILL-IN-Agencia:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-agbco.nomage.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

FOR EACH MVTO:
    CREATE CcbDMvto.
    ASSIGN 
        CcbDMvto.CodCia = CcbCMvto.CodCia 
        CcbDMvto.CodDiv = CcbCMvto.CodDiv
        CcbDMvto.CodDoc = CcbCMvto.CodDoc 
        CcbDMvto.NroDoc = CcbCMvto.NroDoc
        CcbDMvto.CodRef = MVTO.CodRef
        CcbDMvto.NroRef = MVTO.NroRef
        CcbDMvto.NroDep  = MVTO.NroDep.

    /* Ic Validacion */
    FIND CcbCDocu WHERE CcbCDocu.codcia = Ccbdmvto.codcia 
        AND CcbCDocu.CodDoc = Ccbdmvto.codref 
        AND CcbCDocu.NroDoc = Ccbdmvto.Nroref NO-LOCK NO-ERROR.

    IF NOT AVAILABLE Ccbcdocu THEN DO:
        MESSAGE " No existe Coddoc(" + Ccbdmvto.codref + "), NroDoc(" + Ccbdmvto.Nroref + ")".
        UNDO, RETURN 'ADM-ERROR'.
    END.

    FIND CcbCDocu WHERE CcbCDocu.codcia = Ccbdmvto.codcia 
        AND CcbCDocu.CodDoc = Ccbdmvto.codref 
        AND CcbCDocu.NroDoc = Ccbdmvto.Nroref EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        CcbCDocu.FlgUbiA = CcbCDocu.FlgUbi
        CcbCDocu.FchUbiA = CcbCDocu.FchUbi 
        CcbCDocu.FlgSitA = CcbCDocu.FlgSit
        CcbCDocu.FchUbi  = TODAY 
        CcbCDocu.FlgSit  = S-FLGSIT
        CcbCDocu.FlgUbi  = S-FLGUBI
        CcbCDocu.CodCta  = CcbCMvto.CodCta
        CcbCDocu.CodAge  = CcbCMvto.CodAge
        CcbCDocu.NroSal  = CcbDMvto.NroDep.
END.
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
  {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}
  ASSIGN 
      CcbCMvto.CodCia = S-CODCIA
      CcbCMvto.CodDiv = S-CODDIV
      CcbCMvto.CodDoc = S-CODDOC
      CcbCMvto.FchDoc = TODAY
      CcbCMvto.FlgEst = "E"
      CcbCMvto.NroDoc = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
      CcbCMvto.usuario = S-USER-ID
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
  RUN Genera-Detalle.
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".

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
      MESSAGE 'Ya se encuentra anulado...' VIEW-AS ALERT-BOX INFORMATION.
      RETURN 'ADM-ERROR'.
   END.  

   IF s-user-id <> 'ADMIN' THEN DO:
       MESSAGE 'Acceso Denegado' SKIP(1) 'Debe hacer la devolución de la letra' VIEW-AS ALERT-BOX WARNING.
       RETURN 'ADM-ERROR'.
   END.

   RUN Verifica-Anulacion.
   IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

   PRINCIPAL:
   DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
       FOR EACH CcbDMvto NO-LOCK WHERE CcbDMvto.CodCia = CcbCMvto.CodCia 
           AND CcbDMvto.CodDiv = CcbCMvto.CodDiv
           AND CcbDMvto.CodDoc = CcbCMvto.CodDoc 
           AND CcbDMvto.NroDoc = CcbCMvto.NroDoc:
           FIND CcbCDocu WHERE CcbCDocu.codcia = CcbDMvto.codcia 
               AND CcbCDocu.CodDoc = CcbDMvto.codref 
               AND CcbCDocu.NroDoc = CcbDMvto.Nroref EXCLUSIVE-LOCK NO-ERROR.
           IF NOT AVAILABLE Ccbcdocu THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
           ASSIGN
               CcbCDocu.FlgUbi  = CcbCDocu.FlgUbiA
               CcbCDocu.FchUbi  = CcbCDocu.FchUbiA
               CcbCDocu.FlgSit  = CcbCDocu.FlgSitA
               CcbCDocu.FlgSitA = ''  
               CcbCDocu.FchUbiA = ?
               CcbCDocu.FlgUbiA = ''
               CcbCDocu.CodCta  = ''
               CcbCDocu.CodAge  = ''. 
       END.
       FIND B-CMVTO WHERE ROWID(B-CMVTO) = ROWID(CcbCMvto) EXCLUSIVE-LOCK NO-ERROR.
       IF NOT AVAILABLE B-CMVTO THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
       ASSIGN 
           CcbCMvto.FlgEst = "A" 
           CcbCMvto.Glosa  = '**** Documento Anulado ****'
           CcbCMvto.ImpTot = 0
           CcbCMvto.ImpDoc = 0.
       RELEASE B-CMVTO.
       IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
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
      FIND gn-agbco WHERE gn-agbco.CodCia = s-codcia 
          AND gn-agbco.codbco = cb-ctas.codbco 
          AND gn-agbco.codage = CcbCMvto.CodAge NO-LOCK NO-ERROR.
      IF AVAILABLE gn-agbco THEN DISPLAY gn-agbco.nomage @ FILL-IN-Agencia.
      CASE Ccbcmvto.flgest:
          WHEN 'E' THEN FILL-IN-Estado:SCREEN-VALUE = 'APROBADO'.
          WHEN 'A' THEN FILL-IN-Estado:SCREEN-VALUE = 'ANULADO'.
          OTHERWISE FILL-IN-Estado:SCREEN-VALUE = Ccbcmvto.flgest.
      END CASE.

      ENABLE btnExcel WITH FRAME {&FRAME-NAME}.

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
      CcbCMvto.TpoCmb:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

      DISABLE btnExcel WITH FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel V-table-Win 
PROCEDURE ue-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
    Numero : ccbcmvto.nrodoc        Fecha Canje : CcbCMvto.Fchdoc
    Banco  : CcbCMvto.codcta                 Moneda : CcbCMvto.codMon
    Agencia : CcbCMvto.CodAge       Tipo Cambio : CcbCMvto.tpocmb
    Plaza : CcbCMvto.CodDpto
    Observaciones : CcbCMvto.Glosa
    
    ccbcdocu.nomcli 
*/

SESSION:SET-WAIT-STATE('GENERAL').

        DEFINE VARIABLE lFileXls                 AS CHARACTER.
        DEFINE VARIABLE lNuevoFile               AS LOG.
        define VARIABLE cValue as char.
        

        lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
        lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */
        

        {lib\excel-open-file.i}

        chExcelApplication:Visible = NO.

        lMensajeAlTerminar = NO. /*  */
        lCerrarAlTerminar = NO. /* Si permanece abierto el Excel luego de concluir el proceso */


        chWorkSheet = chExcelApplication:Sheets:Item(1).

        iColumn = 2.
    cRange = "A" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "Numero :".
    cRange = "B" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "'" + ccbcmvto.nrodoc.
    cRange = "C" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "Estado :".

    cValue = Ccbcmvto.flgest.
    IF Ccbcmvto.flgest = 'E' THEN cValue = 'APROBADO'.
    IF Ccbcmvto.flgest = 'A' THEN cValue = 'ANULADO'.
    cRange = "D" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = cValue.
    cRange = "E" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "Usuario :".
    cRange = "F" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = ccbcmvto.usuario.
    cRange = "G" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "Fecha de Canje".
    cRange = "H" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = ccbcmvto.fchdoc.

    iColumn = 2.
    cRange = "A" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "Banco :".
    cRange = "B" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "'" + ccbcmvto.codcta.

    FIND cb-ctas WHERE cb-ctas.CodCia = cb-codcia 
        AND cb-ctas.codcta = CcbCMvto.CodCta NO-LOCK NO-ERROR.
    IF AVAILABLE cb-ctas THEN DO:
        cRange = "C" + TRIM(STRING(iColumn)).
        chWorkSheet:Range(cRange):VALUE = cb-ctas.nomcta.
    END.

    iColumn = 3.         
    cRange = "A" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "Agencia :".
    cRange = "B" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "'" + CcbCMvto.CodAge NO-ERROR.
    cRange = "G" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "Moneda del Banco :".
    cRange = "H" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = IF(ccbcmvto.codmon = 1) THEN "SOLES" ELSE "DOLARES".
        
    iColumn = 4.
    cRange = "A" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "Plaza :".
    cRange = "B" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "'" + CcbCMvto.CodDpto NO-ERROR.
    cRange = "G" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "Tipo de Cambio :".
    cRange = "H" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = CcbCMvto.tpocmb.

    iColumn = 5.
    cRange = "A" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "Observaciones :".
    cRange = "B" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = CcbCMvto.Glosa.

    iColumn = 6.
    cRange = "A" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "CodCliente".
    cRange = "B" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "Nombre / Razon Social".
    cRange = "C" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "Apellido Paterno".
    cRange = "D" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "Apellido Materno".
    cRange = "E" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "Numero Documento de Identidad".
    cRange = "F" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "Numero letra / factura".
    cRange = "G" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "Fecha Vencimiento".
    cRange = "H" + TRIM(STRING(iColumn)).
    chWorkSheet:Range(cRange):VALUE = "Importe".

    iColumn = 7.

    FOR EACH ccbdmvto WHERE ccbdmvto.codcia = ccbcmvto.codcia AND 
                            ccbdmvto.coddoc = ccbcmvto.coddoc AND 
                            ccbdmvto.nrodoc = ccbcmvto.nrodoc NO-LOCK:
        FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = ccbcmvto.codcia AND
                                ccbcdocu.coddoc = ccbdmvto.codref AND 
                                ccbcdocu.nrodoc = ccbdmvto.nroref NO-LOCK NO-ERROR.

        cRange = "F" + TRIM(STRING(iColumn)).
        chWorkSheet:Range(cRange):VALUE = "'" + ccbdmvto.codref + " - " + ccbdmvto.nroref.

        IF AVAILABLE ccbcdocu THEN DO:

            FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND 
                gn-clie.codcli = ccbcdocu.codcli NO-LOCK NO-ERROR.

            cRange = "A" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'" + ccbcdocu.codcli.

            cRange = "B" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = ccbcdocu.nomcli.

            IF AVAILABLE gn-clie THEN DO:
                cRange = "C" + TRIM(STRING(iColumn)).
                chWorkSheet:Range(cRange):VALUE = gn-clie.apepat.
                cRange = "D" + TRIM(STRING(iColumn)).
                chWorkSheet:Range(cRange):VALUE = gn-clie.apemat.
                cRange = "B" + TRIM(STRING(iColumn)).
                chWorkSheet:Range(cRange):VALUE = gn-clie.nombre.
                cRange = "E" + TRIM(STRING(iColumn)).
                chWorkSheet:Range(cRange):VALUE = gn-clie.ruc.
                IF TRUE <> (gn-clie.apepat > '') AND
                    TRUE <> (gn-clie.apemat > '') AND
                    TRUE <> (gn-clie.nombre > '') THEN DO:
                    cRange = "C" + TRIM(STRING(iColumn)).
                    chWorkSheet:Range(cRange):VALUE = gn-clie.NomCli.
                END.
            END.
            cRange = "G" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = ccbcdocu.fchvto.
            cRange = "H" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = ccbcdocu.imptot.           
        END.
        iColumn = iColumn + 1.
    END.

    chExcelApplication:Visible = TRUE.

    {lib\excel-close-file.i} 

SESSION:SET-WAIT-STATE('').

    MESSAGE "Proceso Concluido".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel-interbank V-table-Win 
PROCEDURE ue-excel-interbank :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*    
    Se cambio a ue-txt-interbank
*/

RETURN "OK".

/*
Ingreso de Documentos - Letras de Descuento y Cobranza
Cuenta corriente:
Moneda:
Producto:
Documento:
Interés Moratorio:
Protesto:

       Cobranza Libre M.N.  10416100
       Cobranza Libre M.E.  10416110
       Descuento M.N.       45511170
       Descuento M.E.       45511180    
*/

DEFINE VAR lDirectorio AS CHAR.
DEFINE VAR rpta AS LOG.
DEFINE VAR w-xlsx-filename AS CHAR.
DEFINE VAR x-codcta AS CHAR.
/*
SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Excel (*.xls)' '*.xls,*.xlsx'
    DEFAULT-EXTENSION '.xls'
    RETURN-TO-START-DIR
    TITLE 'Directorio dondeeeeee'
    UPDATE rpta.
IF rpta = NO OR x-Archivo = '' THEN RETURN.
*/

lDirectorio = "".

SYSTEM-DIALOG GET-DIR lDirectorio  
   RETURN-TO-START-DIR 
   TITLE 'Elija el Directorio donde grabar el Excel'.
IF lDirectorio = "" THEN RETURN.

DEFINE VAR x-docclie AS CHAR.

FOR EACH ccbdmvto WHERE ccbdmvto.codcia = ccbcmvto.codcia AND 
                        ccbdmvto.coddoc = ccbcmvto.coddoc AND 
                        ccbdmvto.nrodoc = ccbcmvto.nrodoc NO-LOCK:
    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = ccbcmvto.codcia AND
                            ccbcdocu.coddoc = ccbdmvto.codref AND 
                            ccbcdocu.nrodoc = ccbdmvto.nroref NO-LOCK NO-ERROR.

    IF AVAILABLE ccbcdocu THEN DO:

        FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND 
                                gn-clie.codcli = ccbcdocu.codcli NO-LOCK NO-ERROR.

        CREATE tt-interbak.
            ASSIGN tnrodoc = ccbcdocu.nrodoc.

        IF ccbcdocu.ruccli = "" OR ccbcdocu.ruccli = ? THEN DO:
            ASSIGN ttipodoc = "1" .
            ASSIGN tnroiden = ccbcdocu.codcli.
            x-docclie = "".
        END.
        ELSE DO:            
            ASSIGN ttipodoc = "3" .
            ASSIGN tnroiden = ccbcdocu.ruccli.
            x-docclie = TRIM(ccbcdocu.ruccli).
        END.
        IF x-docclie="" OR SUBSTRING(x-docclie,1,2) = '10' THEN DO:            
            ASSIGN trazonsoc = SUBSTRING(gn-clie.nombre,1,40)
                   tapell1 = SUBSTRING(gn-clie.apePat,1,20)
                    tapell2 = SUBSTRING(gn-clie.ApeMat,1,20).
        END.
        ELSE DO:
            ASSIGN trazonsoc = SUBSTRING(ccbcdocu.nomcli,1,40).
        END.
        ASSIGN tdirecc = SUBSTRING(gn-clie.dircli,1,70).
        ASSIGN timptot = ccbcdocu.imptot
                tfchvto = ccbcdocu.fchvto.

        /* Postal */
        IF AVAILABLE gn-clie THEN DO:
            FIND FIRST tabdepto WHERE tabdepto.coddepto = gn-clie.coddept NO-LOCK NO-ERROR.
            FIND FIRST tabprovi WHERE tabprovi.coddepto = gn-clie.coddept AND
                                        tabprovi.codprovi = gn-clie.codprov
                                        NO-LOCK NO-ERROR.
            FIND FIRST tabdistr WHERE tabdistr.coddepto = gn-clie.coddept AND
                                        tabdistr.codprovi = gn-clie.codprov AND 
                                        tabdistr.coddistr = gn-clie.coddist
                                        NO-LOCK NO-ERROR.

            IF AVAILABLE tabdistr THEN DO:
                ASSIGN tdistrito = tabdistr.nomdistr.
                IF SUBSTRING(tabdistr.codpos,1,1)='L' OR SUBSTRING(tabdistr.codpos,1,1)='C' THEN DO:
                    ASSIGN ttdapostal = SUBSTRING(tabdistr.nomdistr,1,40).
                END.
            END.
            IF AVAILABLE tabprov THEN DO:
                ASSIGN tprovincia = tabprovi.nomprovi.
            END.
            IF AVAILABLE tabdepto THEN DO:
                ASSIGN tdeparta = tabdepto.nomdepto.
            END.

        END.

    END.
    
END.

SESSION:SET-WAIT-STATE('').


w-xlsx-filename = "".

x-codcta = CCBCmvto.codcta:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

IF x-codcta ="10416100" THEN w-xlsx-filename = w-xlsx-filename + "Cobranza_Libre_MN_10416100".
IF x-codcta ="10416110" THEN w-xlsx-filename = w-xlsx-filename + "Cobranza_Libre_ME_10416110".
IF x-codcta ="45511170" THEN w-xlsx-filename = w-xlsx-filename + "Descuento_MN_45511170".
IF x-codcta ="45511180" THEN w-xlsx-filename = w-xlsx-filename + "Descuento_ME_45511180".
IF x-codcta ="10411100" THEN w-xlsx-filename = w-xlsx-filename + "Prueba_para_interbank".

w-xlsx-filename = w-xlsx-filename + "_" + STRING(NOW,"9999-99-99 HH:MM:SS").
w-xlsx-filename = REPLACE(w-xlsx-filename,":","-").
w-xlsx-filename = REPLACE(w-xlsx-filename," ","_").

w-xlsx-filename = lDirectorio + "\" + w-xlsx-filename + ".xlsx".


DEFINE VAR hProc AS HANDLE NO-UNDO.
def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

RUN lib\Tools-to-excel PERSISTENT SET hProc.

c-xls-file = w-xlsx-filename.

run pi-crea-archivo-csv IN hProc (input  buffer tt-interbak:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-interbak:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

/*

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.
DEFINE VAR w-xlsx-filename AS CHAR.

DEFINE VAR xCaso AS CHAR.
DEFINE VAR x-valida AS INT INIT 0.
DEFINE VAR x-codcta AS CHAR.

lFileXls = x-archivo.           /* Nombre el archivo a abrir o crear, vacio solo para nuevos */
lNuevoFile = NO.                            /* Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

chExcelApplication:Visible = NO.

/* Validar si el Excel es de Interbank */
xCaso = chWorkSheet:Range("G2"):TEXT.
IF LOWER(trim(xCaso))="ingreso de documentos - letras de descuento y cobranza"  THEN x-valida = x-valida + 1.
xCaso = chWorkSheet:Range("C7"):TEXT.
IF LOWER(trim(xCaso))="cuenta corriente:"  THEN x-valida = x-valida + 1.
xCaso = chWorkSheet:Range("C8"):TEXT.
IF LOWER(trim(xCaso))="moneda:"  THEN x-valida = x-valida + 1.
xCaso = chWorkSheet:Range("C9"):TEXT.
IF LOWER(trim(xCaso))="producto:"  THEN x-valida = x-valida + 1.
xCaso = chWorkSheet:Range("C10"):TEXT.
IF LOWER(trim(xCaso))="documento:"  THEN x-valida = x-valida + 1.
xCaso = chWorkSheet:Range("C11"):TEXT.
IF LOWER(trim(xCaso))="interés moratorio:"  THEN x-valida = x-valida + 1.
xCaso = chWorkSheet:Range("C12"):TEXT.
IF LOWER(trim(xCaso))="protesto:"  THEN x-valida = x-valida + 1.

IF x-valida <> 7 THEN DO:
    {lib\excel-close-file.i}
    MESSAGE "Archivo Excel no Pertenece a Interbank".
    RETURN.
END.


DEFINE VAR lLinea AS INT.
DEFINE VAR x-docclie AS CHAR.

iColumn = 20.
lLinea = 1.
FOR EACH ccbdmvto WHERE ccbdmvto.codcia = ccbcmvto.codcia AND 
                        ccbdmvto.coddoc = ccbcmvto.coddoc AND 
                        ccbdmvto.nrodoc = ccbcmvto.nrodoc NO-LOCK:
    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = ccbcmvto.codcia AND
                            ccbcdocu.coddoc = ccbdmvto.codref AND 
                            ccbcdocu.nrodoc = ccbdmvto.nroref NO-LOCK NO-ERROR.

    IF AVAILABLE ccbcdocu THEN DO:

        FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND 
                                gn-clie.codcli = ccbcdocu.codcli NO-LOCK NO-ERROR.

        cRange = "C" + TRIM(STRING(iColumn)).
        chWorkSheet:Range(cRange):VALUE = "'" + ccbcdocu.nrodoc.

        IF ccbcdocu.ruccli = "" OR ccbcdocu.ruccli = ? THEN DO:
            cRange = "F" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'1" .
            cRange = "G" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'" + ccbcdocu.codcli.
            x-docclie = "".
        END.
        ELSE DO:
            cRange = "F" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'3" .
            cRange = "G" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'" + ccbcdocu.ruccli.
            x-docclie = TRIM(ccbcdocu.ruccli).
        END.
        IF x-docclie="" OR SUBSTRING(x-docclie,1,2) = '10' THEN DO:
            cRange = "H" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'" + SUBSTRING(gn-clie.nombre,1,40).
            cRange = "J" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'" + SUBSTRING(gn-clie.apePat,1,20).
            cRange = "K" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'" + SUBSTRING(gn-clie.ApeMat,1,20).

        END.
        ELSE DO:
            cRange = "H" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'" + SUBSTRING(ccbcdocu.nomcli,1,40).
        END.
        cRange = "L" + TRIM(STRING(iColumn)).
        chWorkSheet:Range(cRange):VALUE = "'" + SUBSTRING(ccbcdocu.dircli,1,70).
        cRange = "Q" + TRIM(STRING(iColumn)).
        chWorkSheet:Range(cRange):VALUE = ccbcdocu.imptot.
        cRange = "R" + TRIM(STRING(iColumn)).
        chWorkSheet:Range(cRange):VALUE = ccbcdocu.fchvto.
        
        /* Postal */
        IF AVAILABLE gn-clie THEN DO:
            FIND FIRST tabdepto WHERE tabdepto.coddepto = gn-clie.coddept NO-LOCK NO-ERROR.
            FIND FIRST tabprovi WHERE tabprovi.coddepto = gn-clie.coddept AND
                                        tabprovi.codprovi = gn-clie.codprov
                                        NO-LOCK NO-ERROR.
            FIND FIRST tabdistr WHERE tabdistr.coddepto = gn-clie.coddept AND
                                        tabdistr.codprovi = gn-clie.codprov AND 
                                        tabdistr.coddistr = gn-clie.coddist
                                        NO-LOCK NO-ERROR.

            IF AVAILABLE tabdistr THEN DO:
                cRange = "M" + TRIM(STRING(iColumn)).
                chWorkSheet:Range(cRange):VALUE = tabdistr.nomdistr.
                IF SUBSTRING(tabdistr.codpos,1,1)='L' OR SUBSTRING(tabdistr.codpos,1,1)='C' THEN DO:
                    cRange = "P" + TRIM(STRING(iColumn)).
                    /*chWorkSheet:Range(cRange):VALUE = SUBSTRING(tabdistr.codpos,1,3).*/
                    chWorkSheet:Range(cRange):VALUE = SUBSTRING(tabdistr.nomdistr,1,40).
                END.
            END.
            IF AVAILABLE tabprov THEN DO:
                cRange = "N" + TRIM(STRING(iColumn)).
                chWorkSheet:Range(cRange):VALUE = tabprovi.nomprovi.
            END.
            IF AVAILABLE tabdepto THEN DO:
                cRange = "O" + TRIM(STRING(iColumn)).
                chWorkSheet:Range(cRange):VALUE = tabdepto.nomdepto.
            END.

        END.
        
    END.
    iColumn = iColumn + 1.
END.
/*
       Cobranza Libre M.N.  10416100
       Cobranza Libre M.E.  10416110
       Descuento M.N.       45511170
       Descuento M.E.       45511180    
*/
w-xlsx-filename = SUBSTRING(x-archivo,1,R-INDEX(x-archivo, "\")).  

x-codcta = CCBCmvto.codcta:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

IF x-codcta ="10416100" THEN w-xlsx-filename = w-xlsx-filename + "Cobranza_Libre_MN_10416100.xls".
IF x-codcta ="10416110" THEN w-xlsx-filename = w-xlsx-filename + "Cobranza_Libre_ME_10416110.xls".
IF x-codcta ="45511170" THEN w-xlsx-filename = w-xlsx-filename + "Descuento_MN_45511170.xls".
IF x-codcta ="45511180" THEN w-xlsx-filename = w-xlsx-filename + "Descuento_ME_45511180.xls".
IF x-codcta ="10411100" THEN w-xlsx-filename = w-xlsx-filename + "Prueba_para_interbank.xls".

/*chWorkBook:SaveAs(w-xlsx-filename, -4143,,,,,,, FALSE).*/
chWorkbook:SaveAs(w-xlsx-filename,52,,,,,).

/*
w-xlsx-filename = STRING(NOW,"9999-99-99 HH:MM:SS").
w-xlsx-filename = REPLACE(w-xlsx-filename,":","-").
w-xlsx-filename = REPLACE(w-xlsx-filename," ","_").
*/

{lib\excel-close-file.i}

SESSION:SET-WAIT-STATE('').
*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-txt-interbank V-table-Win 
PROCEDURE ue-txt-interbank :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
Ingreso de Documentos - Letras de Descuento y Cobranza
Cuenta corriente:
Moneda:
Producto:
Documento:
Interés Moratorio:
Protesto:

       Cobranza Libre M.N.  10416100
       Cobranza Libre M.E.  10416110
       Descuento M.N.       45511170
       Descuento M.E.       45511180    
*/

DEFINE VAR lDirectorio AS CHAR.
DEFINE VAR rpta AS LOG.
DEFINE VAR w-xlsx-filename AS CHAR.
DEFINE VAR x-codcta AS CHAR.
DEFINE VAR x-ctacte AS CHAR.

lDirectorio = "".
x-ctacte = "".

SYSTEM-DIALOG GET-DIR lDirectorio  
   RETURN-TO-START-DIR 
   TITLE 'Elija el Directorio donde grabar el Excel'.
IF lDirectorio = "" THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VAR x-docclie AS CHAR.
DEFINE VAR x-linea-txt AS CHAR.
DEFINE VAR x-tot-docs AS INT.
DEFINE VAR x-imp-tot-docs AS DEC.

DEFINE VAR x-postal AS CHAR.
DEFINE VAR x-distr  AS CHAR.
DEFINE VAR x-prov AS CHAR.
DEFINE VAR x-dpto AS CHAR.

DEFINE VAR x-hdr AS LOG.

w-xlsx-filename = "".

x-codcta = CCBCmvto.codcta:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

/*x-codcta = "10416100".*/

IF x-codcta ="10416100" THEN DO:
    w-xlsx-filename = w-xlsx-filename + "Cobranza_Libre_MN_10416100".
    x-ctacte = "1007000010460".
END.  
IF x-codcta ="10416110" THEN DO:
    w-xlsx-filename = w-xlsx-filename + "Cobranza_Libre_ME_10416110".
    x-ctacte = "1007000010494".
END.   
IF x-codcta ="45511170" THEN DO:
    w-xlsx-filename = w-xlsx-filename + "Descuento_MN_45511170".
    x-ctacte = "1007000010460".
END.    
IF x-codcta ="45511180" THEN DO:
    w-xlsx-filename = w-xlsx-filename + "Descuento_ME_45511180".
    x-ctacte = "1007000010494".
END.    
IF x-codcta ="10411100" THEN DO:
    w-xlsx-filename = w-xlsx-filename + "Prueba_para_interbank".
    x-ctacte = "1007000010460".
END.
    

w-xlsx-filename = w-xlsx-filename + "_" + STRING(NOW,"9999-99-99 HH:MM:SS").
w-xlsx-filename = REPLACE(w-xlsx-filename,":","-").
w-xlsx-filename = REPLACE(w-xlsx-filename," ","_").

w-xlsx-filename = lDirectorio + "\" + w-xlsx-filename + ".txt".

OUTPUT STREAM txt-file TO VALUE(w-xlsx-filename).

x-linea-txt = "".                   
x-tot-docs = 0.
x-imp-tot-docs = 0.

FOR EACH ccbdmvto WHERE ccbdmvto.codcia = ccbcmvto.codcia AND 
                        ccbdmvto.coddoc = ccbcmvto.coddoc AND 
                        ccbdmvto.nrodoc = ccbcmvto.nrodoc NO-LOCK:
    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = ccbcmvto.codcia AND
                            ccbcdocu.coddoc = ccbdmvto.codref AND 
                            ccbcdocu.nrodoc = ccbdmvto.nroref NO-LOCK NO-ERROR.

    IF AVAILABLE ccbcdocu THEN DO:
        x-tot-docs = x-tot-docs + 1.
        x-imp-tot-docs = x-imp-tot-docs + ccbcdocu.imptot.
    END.
    
END.

/**/
x-hdr = NO.

FOR EACH ccbdmvto WHERE ccbdmvto.codcia = ccbcmvto.codcia AND 
                        ccbdmvto.coddoc = ccbcmvto.coddoc AND 
                        ccbdmvto.nrodoc = ccbcmvto.nrodoc NO-LOCK:
    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = ccbcmvto.codcia AND
                            ccbcdocu.coddoc = ccbdmvto.codref AND 
                            ccbcdocu.nrodoc = ccbdmvto.nroref NO-LOCK NO-ERROR.

    IF AVAILABLE ccbcdocu THEN DO:

        FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND 
                                gn-clie.codcli = ccbcdocu.codcli NO-LOCK NO-ERROR.

        /* Registro de Cabecera */
        IF x-hdr = NO THEN DO:
            x-linea-txt = FILL(" ",7).          /* En Blanco */
            x-linea-txt = x-linea-txt + SUBSTRING(x-ctacte + FILL(" ",13),1,13).     /* Cuenta Girador */
            IF SUBSTRING(x-codcta,1,6) = "104161" THEN DO:
                x-linea-txt = x-linea-txt + "2".
            END.
            IF SUBSTRING(x-codcta,1,6) = "455111" THEN DO:
                x-linea-txt = x-linea-txt + "1".
            END.
            IF LOOKUP(x-codcta,"10416100,45511170") > 0 THEN DO:
                x-linea-txt = x-linea-txt + "01".
            END.
            IF LOOKUP(x-codcta,"10416110,45511180") > 0 THEN DO:
                x-linea-txt = x-linea-txt + "10".
            END.
            x-linea-txt = x-linea-txt + "1".        /* Letras comunes */
            x-linea-txt = x-linea-txt + "1".        /* Protestar */
            x-linea-txt = x-linea-txt + "1".        /* Si, interes moratorio */
            x-linea-txt = x-linea-txt + STRING(x-tot-docs,"9999999999").    /* Tot docs */
            x-linea-txt = x-linea-txt + REPLACE(STRING(x-imp-tot-docs,"99999999999999.99"),".","").   /* impte Total docs */

            PUT STREAM txt-file x-linea-txt FORMAT 'x(412)' SKIP.
            x-hdr = YES.
        END.

        /* Linea de Detalle */
        x-linea-txt = SUBSTRING(TRIM(ccbcdocu.nrodoc) + FILL(" ",10),1,10).

        IF gn-clie.libre_c01 <> "J"  THEN DO:
            x-linea-txt = x-linea-txt + "1".
            x-linea-txt = x-linea-txt + SUBSTRING(SUBSTRING(ccbcdocu.codcli,3,8) + FILL(" ",15),1,15).
            x-docclie = "".
        END.
        ELSE DO:            
            x-linea-txt = x-linea-txt + "3".
            x-linea-txt = x-linea-txt + SUBSTRING(TRIM(ccbcdocu.ruccli) + FILL(" ",15),1,15).
            x-docclie = TRIM(ccbcdocu.ruccli).
        END.
        IF x-docclie="" THEN DO:            
            x-linea-txt = x-linea-txt + SUBSTRING(TRIM(gn-clie.nombre) + FILL(" ",40),1,40).
            x-linea-txt = x-linea-txt + FILL(" ",20).
            x-linea-txt = x-linea-txt + SUBSTRING(TRIM(gn-clie.apePat) + FILL(" ",20),1,20).
            x-linea-txt = x-linea-txt + SUBSTRING(TRIM(gn-clie.ApeMat) + FILL(" ",20),1,20).
        END.
        ELSE DO:
            x-linea-txt = x-linea-txt + SUBSTRING(TRIM(ccbcdocu.nomcli) + FILL(" ",40),1,40).
            x-linea-txt = x-linea-txt + FILL(" ",20).
            x-linea-txt = x-linea-txt + FILL(" ",20).
            x-linea-txt = x-linea-txt + FILL(" ",20).
        END.

        x-postal = FILL(" ",40).
        x-distr = FILL(" ",40).
        x-prov = FILL(" ",40).
        x-dpto = FILL(" ",40).

        /* Postal */
        IF AVAILABLE gn-clie THEN DO:
            FIND FIRST tabdepto WHERE tabdepto.coddepto = gn-clie.coddept NO-LOCK NO-ERROR.
            FIND FIRST tabprovi WHERE tabprovi.coddepto = gn-clie.coddept AND
                                        tabprovi.codprovi = gn-clie.codprov
                                        NO-LOCK NO-ERROR.
            FIND FIRST tabdistr WHERE tabdistr.coddepto = gn-clie.coddept AND
                                        tabdistr.codprovi = gn-clie.codprov AND 
                                        tabdistr.coddistr = gn-clie.coddist
                                        NO-LOCK NO-ERROR.

            IF AVAILABLE tabdistr THEN DO:
                x-distr = SUBSTRING(TRIM(tabdistr.nomdistr) + FILL(" ",40),1,40).
                IF SUBSTRING(tabdistr.codpos,1,1)='L' OR SUBSTRING(tabdistr.codpos,1,1)='C' THEN DO:
                    x-postal = SUBSTRING(TRIM(tabdistr.codpos) + FILL(" ",40),1,40).
                END.
                ELSE DO:
                    x-postal = SUBSTRING(TRIM(tabdistr.coddepto) + TRIM(tabdistr.codprovi) + TRIM(tabdistr.coddistr) + FILL(" ",40),1,40).
                END.
            END.
            IF AVAILABLE tabprov THEN DO:
                x-prov = SUBSTRING(TRIM(tabprovi.nomprovi) + FILL(" ",40),1,40).
            END.
            IF AVAILABLE tabdepto THEN DO:
                x-dpto = SUBSTRING(TRIM(tabdepto.nomdepto) + FILL(" ",40),1,40).
            END.
        END.
        x-linea-txt = x-linea-txt + x-postal.
        x-linea-txt = x-linea-txt + REPLACE(STRING(ccbcdocu.imptot,"99999999999999.99"),".","").
        x-linea-txt = x-linea-txt + STRING(ccbcdocu.fchvto,"99/99/9999").
        x-linea-txt = x-linea-txt + "  ".             /* Nro Cuota */
        x-linea-txt = x-linea-txt + FILL(" ",10).    /* Fecha Cuota */
        x-linea-txt = x-linea-txt + FILL(" ",16).    /* Nro Cuota */
        x-linea-txt = x-linea-txt + SUBSTRING(TRIM(gn-clie.dircli) + FILL(" ",70),1,70).
        x-linea-txt = x-linea-txt + x-distr.
        x-linea-txt = x-linea-txt + x-prov.
        x-linea-txt = x-linea-txt + x-dpto.

        PUT STREAM txt-file x-linea-txt FORMAT 'x(410)' SKIP.

    END.
    
END.

OUTPUT STREAM txt-file CLOSE.

SESSION:SET-WAIT-STATE('').

/*

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.
DEFINE VAR w-xlsx-filename AS CHAR.

DEFINE VAR xCaso AS CHAR.
DEFINE VAR x-valida AS INT INIT 0.
DEFINE VAR x-codcta AS CHAR.

lFileXls = x-archivo.           /* Nombre el archivo a abrir o crear, vacio solo para nuevos */
lNuevoFile = NO.                            /* Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

chExcelApplication:Visible = NO.

/* Validar si el Excel es de Interbank */
xCaso = chWorkSheet:Range("G2"):TEXT.
IF LOWER(trim(xCaso))="ingreso de documentos - letras de descuento y cobranza"  THEN x-valida = x-valida + 1.
xCaso = chWorkSheet:Range("C7"):TEXT.
IF LOWER(trim(xCaso))="cuenta corriente:"  THEN x-valida = x-valida + 1.
xCaso = chWorkSheet:Range("C8"):TEXT.
IF LOWER(trim(xCaso))="moneda:"  THEN x-valida = x-valida + 1.
xCaso = chWorkSheet:Range("C9"):TEXT.
IF LOWER(trim(xCaso))="producto:"  THEN x-valida = x-valida + 1.
xCaso = chWorkSheet:Range("C10"):TEXT.
IF LOWER(trim(xCaso))="documento:"  THEN x-valida = x-valida + 1.
xCaso = chWorkSheet:Range("C11"):TEXT.
IF LOWER(trim(xCaso))="interés moratorio:"  THEN x-valida = x-valida + 1.
xCaso = chWorkSheet:Range("C12"):TEXT.
IF LOWER(trim(xCaso))="protesto:"  THEN x-valida = x-valida + 1.

IF x-valida <> 7 THEN DO:
    {lib\excel-close-file.i}
    MESSAGE "Archivo Excel no Pertenece a Interbank".
    RETURN.
END.


DEFINE VAR lLinea AS INT.
DEFINE VAR x-docclie AS CHAR.

iColumn = 20.
lLinea = 1.
FOR EACH ccbdmvto WHERE ccbdmvto.codcia = ccbcmvto.codcia AND 
                        ccbdmvto.coddoc = ccbcmvto.coddoc AND 
                        ccbdmvto.nrodoc = ccbcmvto.nrodoc NO-LOCK:
    FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = ccbcmvto.codcia AND
                            ccbcdocu.coddoc = ccbdmvto.codref AND 
                            ccbcdocu.nrodoc = ccbdmvto.nroref NO-LOCK NO-ERROR.

    IF AVAILABLE ccbcdocu THEN DO:

        FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND 
                                gn-clie.codcli = ccbcdocu.codcli NO-LOCK NO-ERROR.

        cRange = "C" + TRIM(STRING(iColumn)).
        chWorkSheet:Range(cRange):VALUE = "'" + ccbcdocu.nrodoc.

        IF ccbcdocu.ruccli = "" OR ccbcdocu.ruccli = ? THEN DO:
            cRange = "F" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'1" .
            cRange = "G" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'" + ccbcdocu.codcli.
            x-docclie = "".
        END.
        ELSE DO:
            cRange = "F" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'3" .
            cRange = "G" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'" + ccbcdocu.ruccli.
            x-docclie = TRIM(ccbcdocu.ruccli).
        END.
        IF x-docclie="" OR SUBSTRING(x-docclie,1,2) = '10' THEN DO:
            cRange = "H" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'" + SUBSTRING(gn-clie.nombre,1,40).
            cRange = "J" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'" + SUBSTRING(gn-clie.apePat,1,20).
            cRange = "K" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'" + SUBSTRING(gn-clie.ApeMat,1,20).

        END.
        ELSE DO:
            cRange = "H" + TRIM(STRING(iColumn)).
            chWorkSheet:Range(cRange):VALUE = "'" + SUBSTRING(ccbcdocu.nomcli,1,40).
        END.
        cRange = "L" + TRIM(STRING(iColumn)).
        chWorkSheet:Range(cRange):VALUE = "'" + SUBSTRING(ccbcdocu.dircli,1,70).
        cRange = "Q" + TRIM(STRING(iColumn)).
        chWorkSheet:Range(cRange):VALUE = ccbcdocu.imptot.
        cRange = "R" + TRIM(STRING(iColumn)).
        chWorkSheet:Range(cRange):VALUE = ccbcdocu.fchvto.
        
        /* Postal */
        IF AVAILABLE gn-clie THEN DO:
            FIND FIRST tabdepto WHERE tabdepto.coddepto = gn-clie.coddept NO-LOCK NO-ERROR.
            FIND FIRST tabprovi WHERE tabprovi.coddepto = gn-clie.coddept AND
                                        tabprovi.codprovi = gn-clie.codprov
                                        NO-LOCK NO-ERROR.
            FIND FIRST tabdistr WHERE tabdistr.coddepto = gn-clie.coddept AND
                                        tabdistr.codprovi = gn-clie.codprov AND 
                                        tabdistr.coddistr = gn-clie.coddist
                                        NO-LOCK NO-ERROR.

            IF AVAILABLE tabdistr THEN DO:
                cRange = "M" + TRIM(STRING(iColumn)).
                chWorkSheet:Range(cRange):VALUE = tabdistr.nomdistr.
                IF SUBSTRING(tabdistr.codpos,1,1)='L' OR SUBSTRING(tabdistr.codpos,1,1)='C' THEN DO:
                    cRange = "P" + TRIM(STRING(iColumn)).
                    /*chWorkSheet:Range(cRange):VALUE = SUBSTRING(tabdistr.codpos,1,3).*/
                    chWorkSheet:Range(cRange):VALUE = SUBSTRING(tabdistr.nomdistr,1,40).
                END.
            END.
            IF AVAILABLE tabprov THEN DO:
                cRange = "N" + TRIM(STRING(iColumn)).
                chWorkSheet:Range(cRange):VALUE = tabprovi.nomprovi.
            END.
            IF AVAILABLE tabdepto THEN DO:
                cRange = "O" + TRIM(STRING(iColumn)).
                chWorkSheet:Range(cRange):VALUE = tabdepto.nomdepto.
            END.

        END.
        
    END.
    iColumn = iColumn + 1.
END.
/*
       Cobranza Libre M.N.  10416100
       Cobranza Libre M.E.  10416110
       Descuento M.N.       45511170
       Descuento M.E.       45511180    
*/
w-xlsx-filename = SUBSTRING(x-archivo,1,R-INDEX(x-archivo, "\")).  

x-codcta = CCBCmvto.codcta:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

IF x-codcta ="10416100" THEN w-xlsx-filename = w-xlsx-filename + "Cobranza_Libre_MN_10416100.xls".
IF x-codcta ="10416110" THEN w-xlsx-filename = w-xlsx-filename + "Cobranza_Libre_ME_10416110.xls".
IF x-codcta ="45511170" THEN w-xlsx-filename = w-xlsx-filename + "Descuento_MN_45511170.xls".
IF x-codcta ="45511180" THEN w-xlsx-filename = w-xlsx-filename + "Descuento_ME_45511180.xls".
IF x-codcta ="10411100" THEN w-xlsx-filename = w-xlsx-filename + "Prueba_para_interbank.xls".

/*chWorkBook:SaveAs(w-xlsx-filename, -4143,,,,,,, FALSE).*/
chWorkbook:SaveAs(w-xlsx-filename,52,,,,,).

/*
w-xlsx-filename = STRING(NOW,"9999-99-99 HH:MM:SS").
w-xlsx-filename = REPLACE(w-xlsx-filename,":","-").
w-xlsx-filename = REPLACE(w-xlsx-filename," ","_").
*/

{lib\excel-close-file.i}

SESSION:SET-WAIT-STATE('').
*/


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
   IF CcbCMvto.CodCta:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de cuenta no puede se blanco " VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY":U TO CcbCMvto.CodCta.
      RETURN "ADM-ERROR".
   END.
   IF CcbCMvto.CodAge:SCREEN-VALUE <> "" THEN DO:
       FIND gn-agbco WHERE gn-agbco.codcia = s-codcia 
           AND gn-agbco.codbco = CcbCMvto.CodCta:SCREEN-VALUE
           AND gn-agbco.codage = CcbCMvto.CodAge:SCREEN-VALUE 
           NO-LOCK NO-ERROR.
       IF NOT AVAILABLE gn-agbco THEN  DO:
           MESSAGE "Codigo de agencia no registrada en este banco" VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY":U TO CcbCMvto.CodAge.
           RETURN "ADM-ERROR".
       END.
   END.
   FIND FIRST MVTO NO-LOCK NO-ERROR.
   IF NOT AVAILABLE MVTO THEN DO:
       MESSAGE 'NO ha ingresado ninguna letra' VIEW-AS ALERT-BOX ERROR.
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

MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
RETURN "ADM-ERROR".

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
FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = CcbCMvto.CodCia 
    AND CcbDMvto.CodDiv = CcbCMvto.CodDiv
    AND CcbDMvto.CodDoc = CcbCMvto.CodDoc 
    AND CcbDMvto.NroDoc = CcbCMvto.NroDoc:
    FIND CcbCDocu WHERE CcbCDocu.codcia = CcbDMvto.codcia 
        AND CcbCDocu.CodDoc = CcbDMvto.codref 
        AND CcbCDocu.NroDoc = CcbDMvto.Nroref NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN DO:
        MESSAGE 'NO se encuentra la ' Ccbdmvto.codref Ccbdmvto.nroref
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF NOT (Ccbcdocu.flgest = 'P' AND Ccbcdocu.flgsit = s-FlgSit AND Ccbcdocu.flgubi = s-FlgUbi) THEN DO:
        MESSAGE 'Las letra' Ccbcdocu.nrodoc 'registra amortizaciones' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
END.
/* Verificamos el cierre contable */
DEF VAR pFchCie AS DATE NO-UNDO.
RUN gn/fFChCieCbd ("CREDITOS", OUTPUT pFchCie).
IF pFchCie <> ? AND Ccbcmvto.FchDoc < pFchCie THEN DO:
    MESSAGE 'NO se puede anular documentos antes del' pFchCie SKIP
        'Consultar con CONTABILIDAD' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

