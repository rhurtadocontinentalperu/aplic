&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-NC FOR CcbCDocu.
DEFINE TEMP-TABLE DOCU LIKE CcbCDocu.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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

  Description: from BROWSER.W - Basic SmartBrowser Object Template

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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF SHARED VAR s-cndcre AS CHAR.
DEF SHARED VAR s-tpofac AS CHAR.
DEF SHARED VAR s-tipo   AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES DOCU

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table DOCU.NroDoc DOCU.CodRef DOCU.NroRef ~
DOCU.FchDoc DOCU.FchVto DOCU.ImpTot DOCU.SdoAct DOCU.Libre_d01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table DOCU.Libre_d01 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table DOCU
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table DOCU
&Scoped-define QUERY-STRING-br_table FOR EACH DOCU WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH DOCU WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table DOCU
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DOCU


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Importe 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-Importe AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "TOTAL" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81
     BGCOLOR 9 FGCOLOR 15 FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      DOCU SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      DOCU.NroDoc COLUMN-LABEL "Anticipo" FORMAT "X(12)":U
      DOCU.CodRef COLUMN-LABEL "Doc" FORMAT "x(8)":U
      DOCU.NroRef FORMAT "X(15)":U WIDTH 14.86
      DOCU.FchDoc COLUMN-LABEL "Fecha de Emisión" FORMAT "99/99/9999":U
            WIDTH 16.43
      DOCU.FchVto COLUMN-LABEL "Fecha de Vencimiento" FORMAT "99/99/9999":U
            WIDTH 18.43
      DOCU.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 12.43
      DOCU.SdoAct COLUMN-LABEL "Saldo Actual" FORMAT "->>,>>>,>>9.99":U
            WIDTH 11.43
      DOCU.Libre_d01 COLUMN-LABEL "Importe N/C" FORMAT ">>>,>>>,>>9.99":U
            WIDTH 9 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
  ENABLE
      DOCU.Libre_d01
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 109 BY 6.69
         FONT 4
         TITLE "SELECCIONE EL ANTICIPO DE CAMPAÑA A CANJEAR" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-Importe AT ROW 7.73 COL 93 COLON-ALIGNED WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: b-NC B "?" ? INTEGRAL CcbCDocu
      TABLE: DOCU T "?" ? INTEGRAL CcbCDocu
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 8.15
         WIDTH              = 124.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Importe IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.DOCU"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.DOCU.NroDoc
"NroDoc" "Anticipo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.DOCU.CodRef
"CodRef" "Doc" "x(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.DOCU.NroRef
"NroRef" ? "X(15)" "character" ? ? ? ? ? ? no ? no no "14.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.DOCU.FchDoc
"FchDoc" "Fecha de Emisión" ? "date" ? ? ? ? ? ? no ? no no "16.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.DOCU.FchVto
"FchVto" "Fecha de Vencimiento" ? "date" ? ? ? ? ? ? no ? no no "18.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.DOCU.ImpTot
"ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.DOCU.SdoAct
"SdoAct" "Saldo Actual" ? "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.DOCU.Libre_d01
"Libre_d01" "Importe N/C" ">>>,>>>,>>9.99" "decimal" 11 0 ? ? ? ? yes ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main /* SELECCIONE EL ANTICIPO DE CAMPAÑA A CANJEAR */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* SELECCIONE EL ANTICIPO DE CAMPAÑA A CANJEAR */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* SELECCIONE EL ANTICIPO DE CAMPAÑA A CANJEAR */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
ON 'TAB':U OF DOCU.Libre_d01
DO:
    APPLY 'RETURN':U.
    RETURN NO-APPLY.
END.


&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION B-table-Win 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pCodDoc AS CHAR.    /* N/C */
DEF INPUT PARAMETER pNroSer AS INT.
DEF INPUT PARAMETER pConcepto AS CHAR.
DEF OUTPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR x-Saldo-Actual AS DEC.
DEF VAR x-Monto-Aplicar AS DEC.
DEF VAR x-Importe-NC AS DEC.
DEF VAR x-Saldo-Adelanto AS DEC.
DEF VAR x-Saldo AS DEC.
DEF VAR i AS INT.
DEF VAR x-TpoCmb-Compra AS DEC INIT 1 NO-UNDO.
DEF VAR x-TpoCmb-Venta  AS DEC INIT 1 NO-UNDO.
DEF VAR x-ImpMn AS DEC NO-UNDO.
DEF VAR x-ImpMe AS DEC NO-UNDO.

FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.
IF NOT AVAILABLE Gn-tccja THEN DO:
    pMensaje = 'NO se ha registrado el T.C. de Caja'.
    RETURN "ADM-ERROR".
END.
ASSIGN
    x-TpoCmb-Compra = Gn-Tccja.Compra
    x-TpoCmb-Venta  = Gn-Tccja.Venta.
/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT pCodDoc, OUTPUT x-Formato).
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* SALDO ACTUAL DEL ADELANTO (POR APLICAR) */
    ASSIGN
        x-Saldo-Adelanto = DOCU.Libre_d01.   /* OJO */
    ASSIGN
        x-Importe-NC = x-Saldo-Adelanto.
    /* CREACION DE LA NOTA DE CREDITO */
    /* Bloqueamos el correlativo de N/C */
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Condicion="FacCorre.codcia = s-codcia ~
        AND FacCorre.coddoc = pCodDoc ~
        AND FacCorre.nroser = pNroSer"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    /* Cabecera */
    CREATE B-NC.
    BUFFER-COPY Ccbcdocu TO B-NC
        ASSIGN
        B-NC.codcia = s-codcia
        B-NC.coddiv = s-coddiv
        B-NC.coddoc = pCodDoc
        B-NC.nrodoc = STRING(FacCorre.nroser, ENTRY(1,x-Formato,'-')) +
                             STRING(Faccorre.correlativo, ENTRY(2,x-Formato,'-'))
        B-NC.tpocmb = (IF Ccbcdocu.codmon = 1 THEN x-TpoCmb-Compra ELSE x-TpoCmb-Venta)
        B-NC.fchdoc = TODAY
        B-NC.fchvto = ADD-INTERVAL (TODAY, 1, 'years')
        B-NC.usuario = s-user-id
        B-NC.imptot = x-Importe-NC
        B-NC.sdoact = x-Importe-NC
        B-NC.fchcan = TODAY
        B-NC.flgest = "P"   /* APROBADO */
        B-NC.tpofac = s-TpoFac
        B-NC.cndcre = s-CndCre
        B-NC.Tipo   = s-Tipo     /* SUNAT */
        B-NC.CodCaja= ""
        B-NC.CodCta = pConcepto
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = 'Error al grabar la N/C: ' + STRING(FacCorre.nroser, '999') + ' '  + 
            STRING(Faccorre.correlativo, ENTRY(2,x-Formato,'-')).
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* Control de Aprobación de N/C */
    RUN lib/LogTabla ("ccbcdocu",
                      B-NC.coddoc + ',' + B-NC.nrodoc,
                      "APROBADO").
  /* **************************** */
    FIND GN-VEN WHERE GN-VEN.codcia = s-codcia AND GN-VEN.codven = B-NC.codven NO-LOCK NO-ERROR.
    IF AVAILABLE GN-VEN THEN B-NC.cco = GN-VEN.cco.
    ASSIGN
        Faccorre.correlativo = Faccorre.correlativo + 1.
    RELEASE FacCorre.
    /* Detalle */
    CREATE Ccbddocu.
    BUFFER-COPY B-NC TO Ccbddocu
        ASSIGN
        Ccbddocu.nroitm = 1
        Ccbddocu.codmat = pConcepto
        Ccbddocu.candes = 1
        Ccbddocu.preuni = B-NC.imptot
        Ccbddocu.implin = B-NC.imptot
        Ccbddocu.factor = 1.
    FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia
        AND CcbTabla.Tabla = pCodDoc
        AND CcbTabla.Codigo = Ccbddocu.codmat NO-LOCK.
    IF CcbTabla.Afecto THEN
        ASSIGN
            Ccbddocu.AftIgv = Yes
            Ccbddocu.ImpIgv = Ccbddocu.implin * ((B-NC.PorIgv / 100) / (1 + (B-NC.PorIgv / 100))).
    ELSE
        ASSIGN
            Ccbddocu.AftIgv = No
            Ccbddocu.ImpIgv = 0.
    /* Totales */
    ASSIGN
        B-NC.ImpExo = (IF Ccbddocu.AftIgv = No  THEN Ccbddocu.implin ELSE 0)
        B-NC.ImpIgv = Ccbddocu.ImpIgv
        B-NC.ImpVta = B-NC.ImpTot - B-NC.ImpIgv
        B-NC.ImpBrt = B-NC.ImpVta.
    IF B-NC.CodMon = 1
        THEN ASSIGN
        x-ImpMn = B-NC.ImpTot
        x-ImpMe = B-NC.ImpTot / B-NC.TpoCmb.
    ELSE ASSIGN
        x-ImpMn = B-NC.ImpTot * B-NC.TpoCmb
        x-ImpMe = B-NC.ImpTot.
    MESSAGE 'dos'.
    RUN proc_AplicaDoc-2 (
        B-NC.CodDoc,    /* N/C */
        B-NC.NroDoc,
        DOCU.nrodoc,
        B-NC.tpocmb,
        x-ImpMn,
        x-ImpMe,
        OUTPUT pMensaje
        ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        pRowid = ROWID(B-NC).
    MESSAGE 'tres'.
    /* ****************************** */
    /* Ic - 16Nov2021 - Importes Arimetica de SUNAT */
    /* ****************************** */
    {vtagn/i-total-factura-sunat.i &Cabecera="B-NC" &Detalle="Ccbddocu"}

    DEF VAR hxProc AS HANDLE NO-UNDO.
    RUN sunat/sunat-calculo-importes.r PERSISTENT SET hxProc.
    RUN tabla-ccbcdocu IN hxProc (INPUT B-NC.CodDiv,
                                  INPUT B-NC.CodDoc,
                                  INPUT B-NC.NroDoc,
                                  OUTPUT pMensaje).
    DELETE PROCEDURE hxProc.
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
    /* ****************************** */
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-NC B-table-Win 
PROCEDURE Genera-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroSer AS INT.
DEF INPUT PARAMETER pConcepto AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR pRowid AS ROWID NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK.

/* Validación */
IF NOT AVAILABLE DOCU THEN RETURN "ADM-ERROR".

/* Que no supere el limite - Ic 07Jun2021 */
DEFINE VAR hxProc AS HANDLE NO-UNDO.            /* Handle Libreria */

RUN ccb\libreria-ccb.r PERSISTENT SET hxProc.
                                                 
DEFINE VAR x-impte AS DEC.

RUN sumar-imptes-nc_ref-cmpte IN hxProc (INPUT "*",     /* Algun concepto o todos */
                                        INPUT Docu.CodDoc, 
                                        INPUT Docu.NroDoc,
                                        OUTPUT x-impte).

DELETE PROCEDURE hxProc.                        /* Release Libreria */

IF (x-impte + Docu.sdoact) > DOCU.imptot THEN DO:
    MESSAGE "Existen N/Cs emitidas referenciando al comprobante" SKIP 
            CDocu.CodDoc + " " + CDocu.NroDoc + " y cuya suma de sus importes" SKIP
            "superan a dicho comprobante" VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.

MESSAGE 'Se va a generar la Nota de Crédito' SKIP(1)
    'Confirme la generación'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN "ADM-ERROR".

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* Bloqueamos la A/C */
    {lib/lock-genericov3.i
        &Tabla="Ccbcdocu"
        &Alcance="FIRST"
        &Condicion="Ccbcdocu.codcia = DOCU.codcia ~
        AND Ccbcdocu.coddiv = DOCU.coddiv ~
        AND Ccbcdocu.coddoc = DOCU.coddoc ~
        AND Ccbcdocu.nrodoc = DOCU.nrodoc" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TxtError="UNDO, RETURN 'ADM-ERROR'"
        }
    IF NOT AVAILABLE Ccbcdocu THEN DO:
        pMensaje = 'No se pudo bloquear el adelanto'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    IF Ccbcdocu.FlgEst <> "P" THEN DO:
        pMensaje = 'El '  + Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc + ' ya NO está pendiente'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    RUN FIRST-TRANSACTION (INPUT pCodDoc,       /* N/C */
                           INPUT pNroSer, 
                           INPUT pConcepto, 
                           OUTPUT pRowid, 
                           OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    RUN SECOND-TRANSACTION (INPUT pRowid, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */
        UNDO, RETURN 'ADM-ERROR'.
    END.
    RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */
END.
IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Temp-FeLogErrores B-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-Temp-Table B-table-Win 
PROCEDURE Import-Temp-Table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER TABLE FOR DOCU.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importe-Total B-table-Win 
PROCEDURE Importe-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER bDOCU FOR DOCU.

FILL-IN-Importe = 0.

FOR EACH bDOCU NO-LOCK:
    FILL-IN-Importe = FILL-IN-Importe + bDOCU.Libre_d01.
END.
DISPLAY FILL-IN-Importe WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Importe-Total.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Importe-Total.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
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
  RUN Importe-Total.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
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
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AplicaDoc-2 B-table-Win 
PROCEDURE proc_AplicaDoc-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_CodDoc LIKE CcbCDocu.CodDoc.    /* N/C */
    DEFINE INPUT PARAMETER para_NroDoc LIKE CcbDMov.NroDoc.
    DEFINE INPUT PARAMETER para_NroDocCja LIKE CcbDMov.NroDoc.    
    DEFINE INPUT PARAMETER para_TpoCmb LIKE CCBDMOV.TpoCmb.
    DEFINE INPUT PARAMETER para_ImpNac LIKE CcbDMov.ImpTot.
    DEFINE INPUT PARAMETER para_ImpUSA LIKE CcbDMov.ImpTot.
    DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    DEFINE BUFFER B-CDocu FOR CcbCDocu.

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Busca Documento */
        FIND FIRST B-CDocu WHERE B-CDocu.CodCia = s-codcia 
            AND B-CDocu.CodDoc = para_CodDoc 
            AND B-CDocu.NroDoc = para_NroDoc
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-CDocu THEN DO:
            pMensaje = "DOCUMENTO " + para_CodDoc + ' ' + para_NroDoc + " NO REGISTRADO".
            RETURN "ADM-ERROR".
        END.
        /* Crea Detalle de la Aplicación */
        CREATE CCBDMOV.
        ASSIGN
            CCBDMOV.CodCia = s-CodCia
            CCBDMOV.CodDiv = s-CodDiv
            CCBDMOV.CodDoc = "A/C"
            CCBDMOV.NroDoc = para_NroDocCja
            CCBDMOV.CodRef = B-CDocu.CodDoc     /* N/C */
            CCBDMOV.NroRef = B-CDocu.NroDoc
            CCBDMOV.CodMon = B-CDocu.CodMon
            CCBDMOV.CodCli = B-CDocu.CodCli
            CCBDMOV.FchDoc = B-CDocu.FchDoc
            CCBDMOV.HraMov = STRING(TIME,"HH:MM:SS")
            CCBDMOV.TpoCmb = para_tpocmb
            CCBDMOV.usuario = s-User-ID.
        IF B-CDocu.CodMon = 1 THEN
            ASSIGN CCBDMOV.ImpTot = para_ImpNac.
        ELSE ASSIGN CCBDMOV.ImpTot = para_ImpUSA.

        /* Actualizamo saldo del A/C */
        ASSIGN
            CcbCDocu.SdoAct = CcbCDocu.SdoAct - Ccbdmov.imptot.
        IF CcbCDocu.SdoAct <= 0 THEN
            ASSIGN
            CcbCDocu.flgest = 'C'
            CcbCDocu.fchcan = TODAY.

        RELEASE B-CDocu.
        RELEASE Ccbdmov.
    END. /* DO TRANSACTION... */
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SECOND-TRANSACTION B-table-Win 
PROCEDURE SECOND-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER pRowid AS ROWID.                                                              
    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
    EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */
    RUN sunat\progress-to-ppll-v3 ( INPUT B-NC.coddiv,
                                    INPUT B-NC.coddoc,
                                    INPUT B-NC.nrodoc,
                                    INPUT-OUTPUT TABLE T-FELogErrores,
                                    OUTPUT pMensaje ).
    IF RETURN-VALUE <> 'OK' THEN DO:
        CASE TRUE:
            WHEN RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
            WHEN RETURN-VALUE = 'ERROR-EPOS' THEN DO:
                /* Anulamos la N/C */
                ASSIGN
                    B-NC.FlgEst = "A"
                    B-NC.UsuAnu = s-user-id
                    B-NC.FchAnu = TODAY.
                /* Extornamos la A/C */
                FIND FIRST Ccbdmov WHERE CCBDMOV.CodCia = s-CodCia
                    AND CCBDMOV.CodDiv = s-CodDiv
                    AND CCBDMOV.CodDoc = "A/C"
                    AND CCBDMOV.NroDoc = Ccbcdocu.nrodoc
                    AND CCBDMOV.CodRef = B-NC.CodDoc     /* N/C */
                    AND CCBDMOV.NroRef = B-NC.NroDoc
                    EXCLUSIVE-LOCK NO-ERROR.
                IF AVAILABLE Ccbdmov THEN DO:
                    /* Actualizamo saldo del A/C */
                    ASSIGN
                        CcbCDocu.SdoAct = CcbCDocu.SdoAct + Ccbdmov.imptot.
                    ASSIGN
                        CcbCDocu.flgest = 'P'
                        CcbCDocu.fchcan = ?.
                    DELETE Ccbdmov.
                END.
                RETURN 'ERROR-EPOS'.
            END.
        END CASE.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "DOCU"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
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
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF DECIMAL(DOCU.Libre_d01:SCREEN-VALUE IN BROWSE {&browse-name}) <= 0 THEN DO:
    MESSAGE 'Importe NO puede ser cero' VIEW-AS ALERT-BOX WARNING.
    APPLY 'ENTRY':U TO DOCU.Libre_d01.
    RETURN 'ADM-ERROR'.
END.
IF DECIMAL(DOCU.Libre_d01:SCREEN-VALUE IN BROWSE {&browse-name}) > DOCU.SdoAct THEN DO:
    MESSAGE 'Importe NO puede ser mayor al saldo' VIEW-AS ALERT-BOX WARNING.
    APPLY 'ENTRY':U TO DOCU.Libre_d01.
    RETURN 'ADM-ERROR'.
END.
RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
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

