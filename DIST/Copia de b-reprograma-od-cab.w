&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE TEMP-TABLE DETA LIKE CcbDDocu.
DEFINE TEMP-TABLE T-CDOCU NO-UNDO LIKE CcbCDocu.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.


DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.

DEF VAR pMensaje AS CHAR NO-UNDO.

DEFINE TEMP-TABLE T-DPEDI  LIKE Facdpedi.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.
DEFINE TEMP-TABLE Reporte 
    FIELD CodCia LIKE CcbCDocu.CodCia
    FIELD CodDiv LIKE CcbCDOcu.CodDiv 
    FIELD CodDoc LIKE CcbCDocu.CodDoc
    FIELD NroDoc LIKE CcbCDocu.Nrodoc
    INDEX Llave01 codcia coddiv coddoc nrodoc.

DEF BUFFER B-ADocu FOR CcbADocu.
DEF BUFFER OD_ORIGINAL  FOR Faccpedi.
DEF BUFFER PED_ORIGINAL FOR Faccpedi.
DEF BUFFER ORDEN        FOR Faccpedi.
DEF BUFFER PEDIDO       FOR Faccpedi.

DEF VAR iSerieNC AS INT NO-UNDO.        /* Serie de la N/C que el usuario va a elegir */
DEF VAR fFchEnt  AS DATE NO-UNDO.
DEF VAR fFchEntOri AS DATE NO-UNDO.

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
&Scoped-define INTERNAL-TABLES AlmCDocu FacCPedi almtabla

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table AlmCDocu.FchDoc AlmCDocu.CodDoc ~
AlmCDocu.NroDoc AlmCDocu.Libre_c02 FacCPedi.CodCli FacCPedi.NomCli ~
AlmCDocu.Libre_d01 AlmCDocu.Libre_d02 AlmCDocu.Libre_d03 almtabla.Nombre 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH AlmCDocu WHERE ~{&KEY-PHRASE} ~
      AND AlmCDocu.CodCia = s-CodCia ~
 AND AlmCDocu.CodLlave = s-CodDiv ~
 AND AlmCDocu.CodDoc = "O/D" ~
 AND AlmCDocu.FlgEst = "P" NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = AlmCDocu.CodCia ~
  AND FacCPedi.CodDoc = AlmCDocu.CodDoc ~
  AND FacCPedi.NroPed = AlmCDocu.NroDoc NO-LOCK, ~
      FIRST almtabla WHERE almtabla.Codigo = AlmCDocu.Libre_c03 ~
      AND almtabla.Tabla = "HR" ~
 AND almtabla.NomAnt = "N" OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH AlmCDocu WHERE ~{&KEY-PHRASE} ~
      AND AlmCDocu.CodCia = s-CodCia ~
 AND AlmCDocu.CodLlave = s-CodDiv ~
 AND AlmCDocu.CodDoc = "O/D" ~
 AND AlmCDocu.FlgEst = "P" NO-LOCK, ~
      FIRST FacCPedi WHERE FacCPedi.CodCia = AlmCDocu.CodCia ~
  AND FacCPedi.CodDoc = AlmCDocu.CodDoc ~
  AND FacCPedi.NroPed = AlmCDocu.NroDoc NO-LOCK, ~
      FIRST almtabla WHERE almtabla.Codigo = AlmCDocu.Libre_c03 ~
      AND almtabla.Tabla = "HR" ~
 AND almtabla.NomAnt = "N" OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table AlmCDocu FacCPedi almtabla
&Scoped-define FIRST-TABLE-IN-QUERY-br_table AlmCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define THIRD-TABLE-IN-QUERY-br_table almtabla


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

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
NroDoc|y||INTEGRAL.AlmCDocu.NroDoc|yes
NomCli|||INTEGRAL.FacCPedi.NomCli|yes
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = "':U + 'NroDoc,NomCli' + '",
     SortBy-Case = ':U + 'NroDoc').

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).

/* This SmartObject is a valid SortBy-Target. */
&IF '{&user-supported-links}':U ne '':U &THEN
  &Scoped-define user-supported-links {&user-supported-links},SortBy-Target
&ELSE
  &Scoped-define user-supported-links SortBy-Target
&ENDIF

/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      AlmCDocu, 
      FacCPedi
    FIELDS(FacCPedi.CodCli
      FacCPedi.NomCli), 
      almtabla
    FIELDS(almtabla.Nombre) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      AlmCDocu.FchDoc COLUMN-LABEL "Fecha Cierre" FORMAT "99/99/9999":U
      AlmCDocu.CodDoc FORMAT "x(3)":U
      AlmCDocu.NroDoc FORMAT "X(12)":U
      AlmCDocu.Libre_c02 COLUMN-LABEL "Hoja de Ruta" FORMAT "x(12)":U
      FacCPedi.CodCli FORMAT "x(11)":U WIDTH 12
      FacCPedi.NomCli FORMAT "x(50)":U
      AlmCDocu.Libre_d01 COLUMN-LABEL "Importe" FORMAT ">>>,>>9.99":U
      AlmCDocu.Libre_d02 COLUMN-LABEL "Peso" FORMAT ">>>,>>9.99":U
      AlmCDocu.Libre_d03 COLUMN-LABEL "Volumen" FORMAT ">>>,>>9.99":U
      almtabla.Nombre COLUMN-LABEL "Motivo" FORMAT "x(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 139 BY 6.69
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: B-DDOCU B "?" ? INTEGRAL CcbDDocu
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: DETA T "?" ? INTEGRAL CcbDDocu
      TABLE: T-CDOCU T "?" NO-UNDO INTEGRAL CcbCDocu
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
         HEIGHT             = 6.85
         WIDTH              = 143.72.
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

ASSIGN 
       br_table:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.AlmCDocu,INTEGRAL.FacCPedi WHERE INTEGRAL.AlmCDocu ...,INTEGRAL.almtabla WHERE INTEGRAL.AlmCDocu ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST USED, FIRST OUTER USED"
     _Where[1]         = "AlmCDocu.CodCia = s-CodCia
 AND AlmCDocu.CodLlave = s-CodDiv
 AND AlmCDocu.CodDoc = ""O/D""
 AND AlmCDocu.FlgEst = ""P"""
     _JoinCode[2]      = "FacCPedi.CodCia = AlmCDocu.CodCia
  AND FacCPedi.CodDoc = AlmCDocu.CodDoc
  AND FacCPedi.NroPed = AlmCDocu.NroDoc"
     _JoinCode[3]      = "INTEGRAL.almtabla.Codigo = AlmCDocu.Libre_c03"
     _Where[3]         = "almtabla.Tabla = ""HR""
 AND almtabla.NomAnt = ""N"""
     _FldNameList[1]   > INTEGRAL.AlmCDocu.FchDoc
"AlmCDocu.FchDoc" "Fecha Cierre" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.AlmCDocu.CodDoc
     _FldNameList[3]   > INTEGRAL.AlmCDocu.NroDoc
"AlmCDocu.NroDoc" ? "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.AlmCDocu.Libre_c02
"AlmCDocu.Libre_c02" "Hoja de Ruta" "x(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.FacCPedi.NomCli
     _FldNameList[7]   > INTEGRAL.AlmCDocu.Libre_d01
"AlmCDocu.Libre_d01" "Importe" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.AlmCDocu.Libre_d02
"AlmCDocu.Libre_d02" "Peso" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.AlmCDocu.Libre_d03
"AlmCDocu.Libre_d03" "Volumen" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.almtabla.Nombre
"almtabla.Nombre" "Motivo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON START-SEARCH OF br_table IN FRAME F-Main
DO:
    DEFINE VARIABLE hSortColumn  AS WIDGET-HANDLE.
    DEFINE VARIABLE hQueryHandle AS HANDLE     NO-UNDO.

    hSortColumn = BROWSE {&BROWSE-NAME}:CURRENT-COLUMN.
    CASE hSortColumn:NAME:
        WHEN "NroDoc" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'NroDoc').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
        WHEN "NomCli" THEN DO:
            RUN set-attribute-list ('SortBy-Case = ':U + 'NomCli').
            RUN dispatch IN THIS-PROCEDURE ('open-query-cases':U).
        END.
    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
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

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

  RUN get-attribute ('SortBy-Case':U).
  CASE RETURN-VALUE:
    WHEN 'NroDoc':U THEN DO:
      &Scope SORTBY-PHRASE BY AlmCDocu.NroDoc
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    WHEN 'NomCli':U THEN DO:
      &Scope SORTBY-PHRASE BY FacCPedi.NomCli
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END.
    OTHERWISE DO:
      &Undefine SORTBY-PHRASE
      {&OPEN-QUERY-{&BROWSE-NAME}}
    END. /* OTHERWISE...*/
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Eliminar B-table-Win 
PROCEDURE Eliminar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEF VAR x-Rowid AS ROWID NO-UNDO.

IF NOT AVAILABLE Almcdocu THEN RETURN 'ADM-ERROR'.

/* Llaves de Control */
ASSIGN
    x-Rowid = ROWID(AlmCDocu).

/* BLOQUEAMOS EL REGISTRO DE CONTROL */
{lib/lock-genericov3.i ~
    &Tabla="AlmCDocu" ~
    &Condicion="ROWID(AlmCDocu) = x-Rowid" ~
    &Bloqueo="EXCLUSIVE-LOCK" ~
    &Accion="RETRY" ~
    &Mensaje="YES" ~
    &txtMensaje="pMensaje" ~
    &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    
ASSIGN
    AlmCDocu.FchAnulacion = TODAY
    AlmCDocu.FlgEst = "A"
    AlmCDocu.UsrAnulacion = s-user-id.
DELETE Almcdocu.    /* RHC 21/05/2018: va a ser necesario eliminarla completamente */
RELEASE Almcdocu.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION B-table-Win 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Solo genera una N/C a la vez
------------------------------------------------------------------------------*/

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* BLOQUEAMOS LA O/D (BUFFER B-CPEDI) */
    {lib/lock-genericov3.i ~
        &Tabla="B-CPEDI" ~
        &Condicion="B-CPEDI.codcia = AlmCDocu.CodCia ~
        AND B-CPEDI.coddoc = AlmCDocu.CodDoc ~      /* O/D */
        AND B-CPEDI.nroped = AlmCDocu.NroDoc" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    /* GENERAMOS LA NOTA DE CREDITO Y EL INGRESO POR DEVOLUCION DE MERCADERIA */    
    RUN Genera-NC (INPUT iSerieNC).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo generar la N/C para la " +
            B-CDOCU.coddoc + " " + B-CDOCU.nrodoc.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* CREAMOS EL NUEVO PED Y LA NUEVA O/D */
    RUN Genera-PED-OD.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo generar el PEDIDO y la ORDEN DE DESPACHO".
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle B-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR i AS INT NO-UNDO.

/* POR CADA ITEM DE LA FAC CREA UNO SIMILAR EN LA N/C */
EMPTY TEMP-TABLE DETA.
FOR EACH Ccbddocu OF B-CDOCU NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
    /* Recalculamos Precios */
    CREATE DETA.
    BUFFER-COPY Ccbddocu
        TO DETA
        ASSIGN
        DETA.CanDes = Ccbddocu.candes
        DETA.CanDev = Ccbddocu.candes
        DETA.PreUni = ( Ccbddocu.ImpLin - Ccbddocu.ImpDto2 ) / Ccbddocu.CanDes
        DETA.ImpLin = ROUND (DETA.CanDes * DETA.PreUni, 2).
    IF DETA.AftIgv = YES THEN DETA.ImpIgv = ROUND(DETA.ImpLin / ( 1 + B-CDOCU.PorIgv / 100) * B-CDOCU.PorIgv / 100, 2).
END.
IF NOT CAN-FIND(FIRST DETA NO-LOCK) THEN DO:
    pMensaje = "El Comprobante: " + B-CDOCU.CodDoc + " " + B-CDOCU.NroDoc + CHR(10) +
        "YA tiene devoluciones en el almacén. NO se puede generar la N/C".
    RETURN 'ADM-ERROR'.
END.

i = 1.
FOR EACH DETA ON STOP UNDO, RETURN 'ADM-ERROR' ON ERROR UNDO, RETURN 'ADM-ERROR' BY DETA.NroItm:
    CREATE CcbDDocu.
    ASSIGN 
        CcbDDocu.NroItm = i
        CcbDDocu.CodCia = CcbCDocu.CodCia 
        CcbDDocu.Coddiv = CcbCDocu.Coddiv 
        CcbDDocu.CodDoc = CcbCDocu.CodDoc 
        CcbDDocu.NroDoc = CcbCDocu.NroDoc
        CcbDDocu.CodMat = DETA.codmat 
        CcbDDocu.PreUni = DETA.PreUni 
        CcbDDocu.CanDes = DETA.CanDes 
        CcbDDocu.Factor = DETA.Factor 
        CcbDDocu.ImpIsc = DETA.ImpIsc
        CcbDDocu.ImpIgv = DETA.ImpIgv 
        CcbDDocu.ImpLin = DETA.ImpLin
        CcbDDocu.AftIgv = DETA.AftIgv
        CcbDDocu.AftIsc = DETA.AftIsc
        CcbDDocu.UndVta = DETA.UndVta
        CcbDDocu.ImpCto = DETA.ImpCto
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    /* Actualizamos control de devoluciones en el detalle de la FAC o BOL */
    {lib/lock-genericov3.i ~
        &Tabla="Ccbddocu" ~
        &Alcance="FIRST" ~
        &Condicion="CcbDDocu.CodCia = B-CDOCU.CodCia ~
        AND CcbDDocu.CodDiv = B-CDOCU.CodDiv ~
        AND CcbDDocu.CodDoc = B-CDOCU.CodDoc ~
        AND CcbDDocu.NroDoc = B-CDOCU.NroDoc ~
        AND Ccbddocu.CodMat = DETA.CodMat" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    ASSIGN
        Ccbddocu.candev = Ccbddocu.candev + DETA.candes.
    i = i + 1.
END.

DEF VAR f-Des AS DEC NO-UNDO.
DEF VAR f-Dev AS DEC NO-UNDO.
DEF VAR c-Sit AS CHAR NO-UNDO.

FOR EACH CcbDDocu OF CcbCDocu NO-LOCK:
    F-Des = F-Des + CcbDDocu.CanDes.
    F-Dev = F-Dev + CcbDDocu.CanDev. 
END.
IF F-Dev > 0 THEN C-SIT = "P".
IF F-Des = F-Dev THEN C-SIT = "D".
ASSIGN 
    CcbCDocu.FlgCon = C-SIT.

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

/* La serie es seleccionada por el usuario */
DEF INPUT PARAMETER s-NroSer AS INT.

/* Consistencia */
DEF VAR s-Sunat-Activo AS LOG INIT NO.
DEF VAR s-CodDoc AS CHAR INIT 'N/C' NO-UNDO.
DEF VAR s-codalm AS CHAR NO-UNDO.

FIND gn-divi WHERE GN-DIVI.CodCia = s-codcia AND GN-DIVI.CodDiv = s-coddiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pMensaje = 'NO está configurada la división ' + s-coddiv.
    RETURN 'ADM-ERROR'.
END.
s-Sunat-Activo = gn-divi.campo-log[10].

FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
    AND FacCorre.CodDiv = S-CODDIV
    AND FacCorre.CodDoc = S-CODDOC 
    AND FacCorre.NroSer = s-NroSer
    AND FacCorre.FlgEst = YES   /* Debe estar activa */
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   pMensaje = "Serie " + s-CodDoc + ": " + STRING(s-NroSer, '999') + " no configurado para la división " + s-CodDiv.
   RETURN 'ADM-ERROR'.
END.
RUN sunat/p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).
ASSIGN
    s-CodAlm = B-CDOCU.CodAlm.
FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCfgGn THEN DO:
    pMensaje = "NO configurada la configuración general" .
    RETURN 'ADM-ERROR'.
END.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="FacCorre" ~
        &Condicion="FacCorre.CodCia = S-CODCIA ~
                    AND FacCorre.CodDiv = S-CODDIV ~
                    AND FacCorre.CodDoc = S-CODDOC ~
                    AND FacCorre.NroSer = s-NroSer" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    
    CREATE Ccbcdocu.
    BUFFER-COPY B-CDOCU     /* La FAC o BOL */
        EXCEPT B-CDOCU.Glosa B-CDOCU.NroOrd
        TO CcbCDocu
        ASSIGN 
        CcbCDocu.CodCia = S-CODCIA
        CcbCDocu.CodDiv = S-CODDIV
        CcbCDocu.CodDoc = S-CODDOC          /* N/C */
        CcbCDocu.NroDoc = STRING(FacCorre.NroSer, ENTRY(1, x-Formato, '-')) +
                            STRING(FacCorre.Correlativo, ENTRY(2, x-Formato, '-'))
        CcbCDocu.CodRef = B-CDOCU.CodDoc    /* FAC o BOL */
        CcbCDocu.NroRef = B-CDOCU.NroDoc
        CcbCDocu.FchDoc = TODAY
        CcbCDocu.FchVto = ADD-INTERVAL (TODAY, 1, 'years')
        CcbCDocu.FlgEst = "P"
        CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
        CcbCDocu.TpoFac = ""
        CcbCDocu.CndCre = 'D'
        CcbCDocu.Tipo   = "CREDITO"
        CcbCDocu.CodCaja= ''    /*s-CodTer*/
        CcbCDocu.usuario = S-USER-ID
        CcbCDocu.SdoAct = B-CDOCU.ImpTot
        CcbCDocu.ImpTot2 = 0
        CcbCDocu.ImpDto2 = 0
        CcbCDocu.CodMov = 09     /* INGRESO POR DEVOLUCION DEL CLIENTE */
        CcbCDocu.CodAlm = s-CodAlm
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "NO se pudo generar la N/C para la " + B-CDOCU.coddoc + " " + B-CDOCU.nrodoc.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    
    /* ************************ */
    /* Control de N/C generadas */
    /* ************************ */
    CREATE Reporte.
    BUFFER-COPY Ccbcdocu TO Reporte.
    /* ************************ */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.

    /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
    FIND GN-VEN WHERE gn-ven.codcia = s-codcia AND gn-ven.codven = B-CDOCU.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE GN-VEN THEN Ccbcdocu.cco = gn-ven.cco.

    RUN Genera-Detalle.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN
            pMensaje = "NO se pudo generar el detalle de la N/C para la " +
            B-CDOCU.coddoc + " " + B-CDOCU.nrodoc.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    
    /* Generamos el movimiento de almacén por devolución de mercadería */
    RUN vta2/ing-devo-utilex (ROWID(Ccbcdocu)).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = "NO se pudo generar el ingreso por devolución de la " + B-CDOCU.coddoc + " " + B-CDOCU.nrodoc.
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    
    RUN Graba-Totales.
    
    /* GENERACION DE CONTROL DE PERCEPCIONES */
    RUN vta2/control-percepcion-abonos (ROWID(Ccbcdocu)) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    /* ************************************* */
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-PED-OD B-table-Win 
PROCEDURE Genera-PED-OD :
/*----------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Generamos el PEDIDO y la ORDEN en ese orden */
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND OD_ORIGINAL WHERE OD_ORIGINAL.codcia = Almcdocu.codcia
        AND OD_ORIGINAL.coddoc = Almcdocu.coddoc   /* O/D */
        AND OD_ORIGINAL.nroped = Almcdocu.nrodoc
        NO-LOCK NO-ERROR.
    FIND PED_ORIGINAL WHERE PED_ORIGINAL.codcia = OD_ORIGINAL.codcia
        AND PED_ORIGINAL.coddoc = OD_ORIGINAL.codref     /* PED */
        AND PED_ORIGINAL.nroped = OD_ORIGINAL.nroref
        EXCLUSIVE-LOCK NO-ERROR.
    /* *************************************************************** */
    /* *************************************************************** */
    CREATE PEDIDO.
    BUFFER-COPY ORDEN
        TO PEDIDO
        ASSIGN
        PEDIDO.CodDiv = PED_ORIGINAL.CodDiv
        PEDIDO.CodDoc = "PED"
        PEDIDO.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        PEDIDO.CodRef = PED_ORIGINAL.CodRef
        PEDIDO.NroRef = PED_ORIGINAL.NroRef
        .

END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales B-table-Win 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {vta/graba-totales-abono.i}

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION B-table-Win 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Rowid AS ROWID NO-UNDO.
DEF VAR x-CodPed AS CHAR NO-UNDO.
DEF VAR x-NroPed AS CHAR NO-UNDO.
DEF VAR x-CodO_D AS CHAR NO-UNDO.
DEF VAR x-NroO_D AS CHAR NO-UNDO.
DEF VAR x-Ok AS LOG NO-UNDO.

IF NOT AVAILABLE Almcdocu THEN DO:
    MESSAGE 'No hay registros seleccionados' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

/* Parámetros de generación de N/C */
/*fFchEnt = Faccpedi.FchEnt.*/
fFchEnt = TODAY + 1.
fFchEntOri = Faccpedi.FchEnt.
RUN dist/d-reprograma-od (OUTPUT iSerieNC, INPUT-OUTPUT fFchEnt) NO-ERROR.
IF ERROR-STATUS:ERROR OR iSerieNC = 0 THEN RETURN 'ADM-ERROR'.

/* Llaves de Control */
ASSIGN
    x-CodPed = Faccpedi.CodRef
    x-NroPed = Faccpedi.NroRef
    x-CodO_D = Faccpedi.CodDoc
    x-NroO_D = Faccpedi.NroPed
    x-Rowid = ROWID(AlmCDocu).
/* NO debe haber ningun comprobante amortizado */
x-Ok = YES.
EMPTY TEMP-TABLE T-CDOCU.
FOR EACH B-CDOCU EXCLUSIVE-LOCK WHERE B-CDOCU.codcia = s-CodCia
    AND LOOKUP(B-CDOCU.coddoc, 'FAC,BOL') > 0   /* OJO: Solo FAC y BOL */
    AND B-CDOCU.CodPed = x-CodPed     /* PED */
    AND B-CDOCU.NroPed = x-NroPed
    AND B-CDOCU.Libre_c01 = x-CodO_D  /* O/D */
    AND B-CDOCU.Libre_c02 = x-NroO_D:
    IF B-CDOCU.FlgEst <> "P" THEN x-Ok = NO.
    IF B-CDOCU.ImpTot <> B-CDOCU.SdoAct THEN x-Ok = NO.
    CREATE T-CDOCU.
    BUFFER-COPY B-CDOCU TO T-CDOCU.
END.
IF x-Ok = NO THEN DO:
    MESSAGE 'Hay un comprobante que presenta amortizaciones' SKIP
        'Proceso abortado' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.

RLOOP:
/* NOTA: Barremos todas las FAC o BOL relacionadas a la O/D */
/* NOTA: Barremos todas las FAC o BOL relacionadas a la O/D */
FOR EACH T-CDOCU NO-LOCK, 
    FIRST B-CDOCU OF T-CDOCU EXCLUSIVE-LOCK 
    BREAK BY B-CDOCU.CodCia     /* Artificio para verificar el último registro */
    ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* BLOQUEAMOS EL REGISTRO DE CONTROL */
    {lib/lock-genericov3.i ~
        &Tabla="AlmCDocu" ~
        &Condicion="ROWID(AlmCDocu) = x-Rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, LEAVE" }
    /* ******************************************************************************************** */
    /* 1ra. TRANSACCION: N/C, ING AL ALMACEN, ACTUALIZA SALDO O/D */
    /* ******************************************************************************************** */
    /* LIMPIAMOS EL REGISTRO DE CONTROL DE N/C */
    EMPTY TEMP-TABLE Reporte.       /* Aquí guardamos las N/C generada */
    RUN FIRST-TRANSACTION.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        /* NOTA:
            Se va a extornar el último cambio pero se mantiene los que sí han completado el ciclo
            */
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo generar el comprobante".
        UNDO RLOOP, LEAVE RLOOP.
    END.
    /* ******************************************************************************************** */
    /* 2da. TRANSACCION: E-POS en base al Reporte */
    /* ******************************************************************************************** */
    EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */
    RUN SECOND-TRANSACTION.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo generar el comprobante" .
        UNDO RLOOP, LEAVE RLOOP.
    END.
    IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR: No se pudo confirmar el comprobante" .
        RUN THIRD-TRANSACTION.  /* EXTORNO */
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            pMensaje = pMensaje + CHR(10) +
                        "AVISO IMPORTANTE: HAY UN ERROR EN EL EXTORNO DE LOS COMPROBANTES. AVISAR A SISTEMAS.".
        END.
        LEAVE RLOOP.
    END.
    /* ******************************************************************************************** */
    /* 3ro. GRABACIONES FINALES:  Cierra el registro de control solamente si estamos en el último registro */
    /* ******************************************************************************************** */
    IF LAST-OF(B-CDOCU.CodCia) THEN
        ASSIGN
        AlmCDocu.FchAprobacion = TODAY
        AlmCDocu.UsrAprobacion = s-user-id 
        AlmCDocu.FlgEst = "C".
    
END.
/* liberamos tablas */
RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */
IF AVAILABLE(CcbDCaja) THEN RELEASE CcbDCaja.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
IF AVAILABLE(B-CDOCU) THEN RELEASE B-CDocu.
IF AVAILABLE(Ccbdmov) THEN RELEASE Ccbdmov.
IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
IF AVAILABLE(Ccbccaja) THEN RELEASE Ccbccaja.

IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
ELSE MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Nueva-OD B-table-Win 
PROCEDURE Nueva-OD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pRowid AS ROWID.

DEF BUFFER B-Vtaddocu   FOR Vtaddocu.
DEF BUFFER B-ControlOD  FOR ControlOD.
DEF BUFFER B-CcbCBult   FOR CcbCBult.
DEF BUFFER B-CcbADocu   FOR CcbADocu.

DEF VAR s-CodDoc AS CHAR NO-UNDO.
DEF VAR s-NroSer AS INT NO-UNDO.

s-CodDoc = "O/D".
s-NroSer = INTEGER(SUBSTRING(OD_ORIGINAL.NroPed,1,3)).
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* 1ro. La Nueva Orden de Despacho */
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Alcance="FIRST"
        &Condicion="Faccorre.codcia = s-codcia ~
        AND Faccorre.coddoc = s-coddoc ~
        AND Faccorre.nroser = s-nroser"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    CREATE ORDEN.
    BUFFER-COPY OD_ORIGINAL
        TO ORDEN
        ASSIGN
        ORDEN.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        ORDEN.FchPed = TODAY
        ORDEN.FlgEst = "P"
        ORDEN.FlgSit = "C"
        .
    ASSIGN
        pRowid = ROWID(ORDEN).
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* TRACKING */
    RUN vtagn/pTracking-04 (s-CodCia,
                            s-CodDiv,
                            ORDEN.CodDoc,
                            ORDEN.NroPed,
                            s-User-Id,
                            'GNP',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            ORDEN.CodDoc,
                            ORDEN.NroPed,
                            ORDEN.CodRef,
                            ORDEN.NroRef).
    EMPTY TEMP-TABLE T-DPEDI.
    FOR EACH Facdpedi OF OD_ORIGINAL NO-LOCK:
        CREATE T-DPEDI.
        BUFFER-COPY Facdpedi TO T-DPEDI.
    END.
    FOR EACH T-DPEDI NO-LOCK:
        CREATE Facdpedi.
        BUFFER-COPY T-DPEDI TO Facdpedi
            ASSIGN
            Facdpedi.coddiv = ORDEN.coddiv
            Facdpedi.coddoc = ORDEN.coddoc
            Facdpedi.nroped = ORDEN.nroped
            Facdpedi.FlgEst  = 'P'
            Facdpedi.canate = 0.
    END.
    /* *************************************************************** */
    /* RHC 21/11/2016 DATOS DEL CIERRE DE LA OTR EN LA DIVISION ORIGEN */
    /* *************************************************************** */
    FOR EACH Vtaddocu NO-LOCK WHERE VtaDDocu.CodCia = OD_ORIGINAL.CodCia
        AND VtaDDocu.CodDiv = OD_ORIGINAL.CodDiv
        AND VtaDDocu.CodPed = OD_ORIGINAL.CodDoc
        AND VtaDDocu.NroPed = OD_ORIGINAL.NroPed:
        CREATE B-Vtaddocu.
        BUFFER-COPY Vtaddocu TO B-Vtaddocu
            ASSIGN 
            B-Vtaddocu.CodDiv = s-CodDiv
            B-Vtaddocu.CodPed = ORDEN.CodDoc
            B-Vtaddocu.NroPed = ORDEN.NroPed
            B-Vtaddocu.CodCli = ORDEN.CodCli
            NO-ERROR.
    END.
    FOR EACH ControlOD NO-LOCK WHERE ControlOD.CodCia = OD_ORIGINAL.CodCia
        AND ControlOD.CodDiv = OD_ORIGINAL.CodDiv
        AND ControlOD.CodDoc = OD_ORIGINAL.CodDoc
        AND ControlOD.NroDoc = OD_ORIGINAL.NroPed:
        CREATE B-ControlOD.
        BUFFER-COPY ControlOD TO B-ControlOD
            ASSIGN
            B-ControlOD.CodDiv = s-CodDiv
            B-ControlOD.CodDoc = ORDEN.CodDoc
            B-ControlOD.NroDoc = ORDEN.NroPed
            B-ControlOD.CodAlm = ORDEN.CodAlm
            B-ControlOD.CodCli = ORDEN.CodCli
            NO-ERROR.
    END.
    FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = OD_ORIGINAL.CodCia
        AND CcbCBult.CodDiv = OD_ORIGINAL.CodDiv
        AND CcbCBult.CodDoc = OD_ORIGINAL.CodDoc
        AND CcbCBult.NroDoc = OD_ORIGINAL.NroPed:
        CREATE B-CcbCBult.
        BUFFER-COPY CcbCBult TO B-CcbCBult
            ASSIGN
            B-CcbCBult.CodDiv = s-CodDiv
            B-CcbCBult.CodDoc = ORDEN.CodDoc
            B-CcbCBult.NroDoc = ORDEN.NroPed
            B-CcbCBult.CodCli = ORDEN.CodCli
            NO-ERROR.
    END.
    /* RHC 21/05/2018 TRANSPORTISTA */
    FOR EACH CcbADocu NO-LOCK WHERE CcbADocu.CodCia = OD_ORIGINAL.CodCia
        AND CcbADocu.CodDiv = OD_ORIGINAL.CodDiv
        AND CcbADocu.CodDoc = OD_ORIGINAL.CodDoc
        AND CcbADocu.NroDoc = OD_ORIGINAL.NroPed:
        CREATE B-CcbADocu.
        BUFFER-COPY 
            CcbADocu TO B-CcbADocu
            ASSIGN
            B-CcbADocu.CodDiv = s-CodDiv
            B-CcbADocu.CodDoc = ORDEN.CodDoc
            B-CcbADocu.NroDoc = ORDEN.NroPed.
    END.
END.

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
  Notes:    Una N/C a la vez   
------------------------------------------------------------------------------*/

pMensaje = "".
FOR EACH Reporte NO-LOCK, FIRST Ccbcdocu OF Reporte NO-LOCK:
    /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
    RUN sunat/progress-to-ppll-v3  ( INPUT Ccbcdocu.coddiv,
                                     INPUT Ccbcdocu.coddoc,
                                     INPUT Ccbcdocu.nrodoc,
                                     INPUT-OUTPUT TABLE T-FELogErrores,
                                     OUTPUT pMensaje ).
    /* RHC 16/04/2018 En TODOS los casos: ANULAMOS los movimientos */
    IF RETURN-VALUE <> "OK" THEN DO:
        IF TRUE <> (pMensaje > "") THEN pMensaje = "ERROR confirmación de ePos".
        RETURN "ERROR-EPOS".
    END.
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
  {src/adm/template/snd-list.i "AlmCDocu"}
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "almtabla"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE THIRD-TRANSACTION B-table-Win 
PROCEDURE THIRD-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Es solo una N/C 
------------------------------------------------------------------------------*/

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* BLOQUEAMOS LA O/D (BUFFER B-CPEDI) */
    {lib/lock-genericov3.i ~
        &Tabla="B-CPEDI" ~
        &Condicion="B-CPEDI.codcia = AlmCDocu.CodCia ~
        AND B-CPEDI.coddoc = AlmCDocu.CodDoc ~      /* O/D */
        AND B-CPEDI.nroped = AlmCDocu.NroDoc" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}

    FOR EACH Reporte NO-LOCK, FIRST Ccbcdocu OF Reporte EXCLUSIVE-LOCK:
        /* Anulamos N/C */
        ASSIGN
            Ccbcdocu.FlgEst = "A"
            Ccbcdocu.FchAnu = TODAY
            CcbCDocu.UsuAnu = s-user-id.
        /* ACTUALIZAMOS EL SALDO  DE LA O/D */
        ASSIGN
            B-CPEDI.FchEnt = fFchEntOri     /* Su fecha original */
            B-CPEDI.FlgEst = "C".
        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK,
            FIRST B-DPEDI OF B-CPEDI EXCLUSIVE-LOCK WHERE B-DPEDI.CodMat = Ccbddocu.CodMat:
            ASSIGN
                B-DPEDI.CanAte = B-DPEDI.CanAte + Ccbddocu.CanDes.
        END.
        IF CAN-FIND(FIRST B-DPEDI OF B-CPEDI WHERE B-DPEDI.CanPed > B-DPEDI.CanAte NO-LOCK) 
                    THEN B-CPEDI.FlgEst = "P".  /* Aún queda por despachar */
        /* ACTUALIZAMOS SALDO DE LA FAC o BOL */
        ASSIGN
            B-CDOCU.SdoAct = B-CDOCU.SdoAct + Ccbcdocu.ImpTot
            B-CDOCU.FchCan = ?
            B-CDOCU.FlgEst = "P".       /* FAC o BOL */
        FOR EACH Ccbdcaja EXCLUSIVE-LOCK WHERE Ccbdcaja.codcia = B-CDOCU.codcia
            AND Ccbdcaja.coddoc = Ccbcdocu.coddoc
            AND Ccbdcaja.nrodoc = Ccbcdocu.nrodoc
            AND Ccbdcaja.codref = B-CDOCU.coddoc
            AND Ccbdcaja.nroref = B-CDOCU.nrodoc:
            DELETE Ccbdcaja.
        END.
    END.
END.

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

