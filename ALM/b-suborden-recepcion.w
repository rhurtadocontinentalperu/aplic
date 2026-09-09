&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE PEDI NO-UNDO LIKE FacCPedi.
DEFINE TEMP-TABLE T-VtaCDocu NO-UNDO LIKE VtaCDocu.



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

DEF VAR s-task-no AS INT.
DEFINE VAR lNroEnvio AS CHAR.

DEFINE TEMP-TABLE x-vtacdocu LIKE vtacdocu.

&SCOPED-DEFINE Condicion (VtaCDocu.CodCia = s-codcia ~
 AND VtaCDocu.DivDes = s-coddiv ~
 AND (VtaCDocu.CodPed = "O/D" ~
  OR VtaCDocu.CodPed = "O/M" ~
  OR VtaCDocu.CodPed = "OTR") ~
 AND VtaCDocu.FlgEst = "P" ~
 AND ((VtaCDocu.FlgSit = "C" ) ~
      AND SUBSTRING(VtacDocu.zonapickeo,1,1) = 'B' ) ~
 AND (VtaCDocu.coddep = ? OR VtaCDocu.coddep = ""))


     /* VtaCDocu.coddep : Nro de envio al primer piso */

{src/bin/_prns.i}

DEF VAR RB-REPORT-LIBRARY AS CHAR INITIAL "alm/rbalm.prl".
DEF VAR RB-REPORT-NAME AS CHAR INITIAL "Hoja Ruta2".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     
DEF VAR RB-DB-CONNECTION AS CHAR INITIAL "".
DEF VAR RB-MEMO-FILE AS CHAR INITIAL "".
DEF VAR RB-PRINT-DESTINATION AS CHAR INITIAL "".
DEF VAR RB-PRINTER-NAME AS CHAR INITIAL "".
DEF VAR RB-PRINTER-PORT AS CHAR INITIAL "".
DEF VAR RB-OUTPUT-FILE AS CHAR INITIAL "".
DEF VAR RB-NUMBER-COPIES AS INTEGER INITIAL 1.
DEF VAR RB-BEGIN-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-END-PAGE AS INTEGER INITIAL 0.
DEF VAR RB-TEST-PATTERN AS LOGICAL INITIAL NO.
DEF VAR RB-WINDOW-TITLE AS CHARACTER INITIAL "".
DEF VAR RB-DISPLAY-ERRORS AS LOGICAL INITIAL YES.
DEF VAR RB-DISPLAY-STATUS AS LOGICAL INITIAL YES.
DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

/* capturamos ruta inicial */
DEF VAR S-REPORT-LIBRARY AS CHAR.
GET-KEY-VALUE SECTION "Startup" KEY "BASE" VALUE s-report-library.
RB-REPORT-LIBRARY = s-report-library + "alm\rbalm.prl".

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

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES FacCPedi
&Scoped-define FIRST-EXTERNAL-TABLE FacCPedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacCPedi.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-VtaCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-VtaCDocu.CodPed T-VtaCDocu.NroPed ~
T-VtaCDocu.CodCli T-VtaCDocu.NomCli T-VtaCDocu.FchPed T-VtaCDocu.NroCard ~
T-VtaCDocu.ZonaPickeo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH T-VtaCDocu WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-VtaCDocu WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-VtaCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-VtaCDocu


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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSector B-table-Win 
FUNCTION fSector RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-VtaCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-VtaCDocu.CodPed FORMAT "x(3)":U WIDTH 4.43
      T-VtaCDocu.NroPed COLUMN-LABEL "Numero!SubOrden" FORMAT "X(12)":U
            WIDTH 9.43
      T-VtaCDocu.CodCli COLUMN-LABEL "CodClie" FORMAT "x(11)":U
            WIDTH 9.43
      T-VtaCDocu.NomCli FORMAT "x(60)":U WIDTH 35.43
      T-VtaCDocu.FchPed FORMAT "99/99/99":U
      T-VtaCDocu.NroCard COLUMN-LABEL "Zona!Pickeo" FORMAT "x(8)":U
      T-VtaCDocu.ZonaPickeo COLUMN-LABEL "Zona!Temporal" FORMAT "x(10)":U
            WIDTH 10.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 94 BY 6.69
         FONT 4 FIT-LAST-COLUMN.


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
   External Tables: INTEGRAL.FacCPedi
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: PEDI T "?" NO-UNDO INTEGRAL FacCPedi
      TABLE: T-VtaCDocu T "?" NO-UNDO INTEGRAL VtaCDocu
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
         HEIGHT             = 6.96
         WIDTH              = 95.
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-VtaCDocu Where INTEGRAL.FacCPedi ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST,"
     _FldNameList[1]   > Temp-Tables.T-VtaCDocu.CodPed
"CodPed" ? ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-VtaCDocu.NroPed
"NroPed" "Numero!SubOrden" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-VtaCDocu.CodCli
"CodCli" "CodClie" ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-VtaCDocu.NomCli
"NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "35.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = Temp-Tables.T-VtaCDocu.FchPed
     _FldNameList[6]   > Temp-Tables.T-VtaCDocu.NroCard
"NroCard" "Zona!Pickeo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-VtaCDocu.ZonaPickeo
"ZonaPickeo" "Zona!Temporal" ? "character" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "FacCPedi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacCPedi"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND PikSupervisores WHERE PikSupervisores.CodCia = s-codcia
      AND PikSupervisores.CodDiv = s-coddiv
      AND PikSupervisores.Usuario = s-user-id
      NO-LOCK NO-ERROR.
DEF VAR X AS INT NO-UNDO.

EMPTY TEMP-TABLE T-Vtacdocu.
FOR EACH Vtacdocu NO-LOCK WHERE {&Condicion}:
    IF AVAILABLE PikSupervisores AND PikSupervisores.Sector > '' THEN DO:
        IF LOOKUP(ENTRY(2,Vtacdocu.nroped,'-'), PikSupervisores.Sector) > 0
            THEN DO:
            CREATE T-Vtacdocu.
            BUFFER-COPY Vtacdocu TO T-Vtacdocu.
        END.
    END.  
    ELSE DO:
        CREATE T-Vtacdocu.
        BUFFER-COPY Vtacdocu TO T-Vtacdocu.
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cerrar-Tarea B-table-Win 
PROCEDURE Cerrar-Tarea :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Vtacdocu THEN RETURN.

FIND CURRENT Vtacdocu NO-LOCK NO-ERROR.
IF Vtacdocu.FlgSit <> "X" THEN DO:
    MESSAGE 'La sub-orden YA no está observada' VIEW-AS ALERT-BOX WARNING.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RETURN.
END.

MESSAGE 'Cerramos la tarea?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

DEFINE BUFFER ORDEN      FOR Faccpedi.
DEFINE BUFFER COTIZACION FOR Faccpedi.
DEFINE BUFFER PEDIDO     FOR Faccpedi.
DEFINE BUFFER b-vtacdocu FOR Vtacdocu.

DEFINE VARIABLE x-NroRef AS CHAR NO-UNDO.
DEFINE VARIABLE pError AS CHAR NO-UNDO.
DEFINE VAR lOrdenLista AS LOG NO-UNDO.

pError = "".
lOrdenLista = NO.
CICLO:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    FIND CURRENT Vtacdocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE Vtacdocu THEN DO:
        pError = "NO se pudo bloquear la Sub-Orden " + Vtacdocu.codped + " " + Vtacdocu.nroped.
        UNDO, LEAVE.
    END.
    IF Vtacdocu.FlgSit <> "X" THEN DO:
        pError = 'La sub-orden YA no está observada'.
        UNDO, LEAVE.
    END.
    /* Actualizamos los documentos originales */
    {lib/lock-genericov21.i &Tabla="ORDEN" ~
        &Alcance="FIRST" ~
        &Condicion="ORDEN.codcia = Vtacdocu.codcia ~
        AND ORDEN.coddiv = Vtacdocu.coddiv 
        AND ORDEN.coddoc = Vtacdocu.codped ~
        AND ORDEN.nroped = ENTRY(1,Vtacdocu.nroped,'-')" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO CICLO, LEAVE" ~
        &Intentos=5 ~
        }
    IF LOOKUP(Vtacdocu.CodPed, 'O/D,O/M') > 0 THEN DO:
        FIND FIRST PEDIDO WHERE PEDIDO.codcia = ORDEN.codcia
            AND PEDIDO.coddiv = ORDEN.coddiv
            AND PEDIDO.coddoc = ORDEN.codref
            AND PEDIDO.nroped = ORDEN.nroref
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE PEDIDO THEN DO:
            pError = "NO se pudo bloquear el pedido " + ORDEN.codref + " " + ORDEN.nroref.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        FIND FIRST COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
            AND COTIZACION.coddiv = PEDIDO.coddiv
            AND COTIZACION.coddoc = PEDIDO.codref
            AND COTIZACION.nroped = PEDIDO.nroref
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE COTIZACION THEN DO:
            pError = "NO se pudo bloquear la cotización " + PEDIDO.codref + " " + PEDIDO.nroref.
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    /* Actualizamos el detalle */
    FOR EACH Vtaddocu OF Vtacdocu NO-LOCK:
        FIND Facdpedi OF ORDEN WHERE Facdpedi.codmat = Vtaddocu.codmat
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Facdpedi THEN DO:
            pError = "NO se pudo bloquear el artículo " + Vtaddocu.codmat + CHR(10) + 
                "Documento: " + ORDEN.coddoc + " " + ORDEN.nroped.
            UNDO CICLO, LEAVE.
        END.
        ASSIGN
            Facdpedi.CanPed = Vtaddocu.CanPed
            Facdpedi.ImpLin = Vtaddocu.ImpLin
            Facdpedi.Por_Dsctos[1] = Vtaddocu.Por_Dsctos[1]
            Facdpedi.Por_Dsctos[2] = Vtaddocu.Por_Dsctos[2]
            Facdpedi.Por_Dsctos[3] = Vtaddocu.Por_Dsctos[3]
            Facdpedi.ImpDto = Vtaddocu.ImpDto
            Facdpedi.ImpLin = Vtaddocu.ImpLin 
            Facdpedi.ImpIsc = Vtaddocu.ImpIsc 
            Facdpedi.ImpIgv = Vtaddocu.ImpIgv.
        IF Facdpedi.CanPed <= 0 THEN DELETE Facdpedi.   /* OJO */
    END.
    IF LOOKUP(Vtacdocu.CodPed, 'O/D,O/M') > 0 THEN DO:
        RUN Graba-Totales ( ROWID(ORDEN) ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pError = "NO se pudo actualizar el documento: " + ORDEN.coddoc + " " + ORDEN.nroped.
            UNDO CICLO, LEAVE.
        END.
        /* Actualizamos Saldo del Pedido */
        FOR EACH Vtaddocu OF Vtacdocu NO-LOCK:
            FIND Facdpedi OF PEDIDO WHERE Facdpedi.codmat = Vtaddocu.codmat
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Facdpedi THEN DO:
                pError = "NO se pudo bloquear el artículo " + Vtaddocu.codmat + CHR(10) +
                    "Pedido: " + PEDIDO.coddoc + " " + PEDIDO.nroped.
                UNDO CICLO, LEAVE.
            END.
            ASSIGN
                Facdpedi.CanPed = Vtaddocu.CanPed
                Facdpedi.CanAte = Vtaddocu.CanPed
                Facdpedi.CanPick = Vtaddocu.CanPed.
            IF Facdpedi.CanPed <= 0 THEN DELETE Facdpedi.   /* OJO */
        END.
        RUN Graba-Totales ( ROWID(PEDIDO) ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pError = "NO se pudo actualizar el documento: " + PEDIDO.coddoc + " " + PEDIDO.nroped.
            UNDO CICLO, LEAVE.
        END.
        /* Actualizamos Saldo de la Cotización */
        FOR EACH Vtaddocu OF Vtacdocu NO-LOCK:
            FIND Facdpedi OF COTIZACION WHERE Facdpedi.codmat = Vtaddocu.codmat
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Facdpedi THEN DO:
                pError = "NO se pudo bloquear el artículo " + Vtaddocu.codmat + CHR(10) +
                    "Cotización: " + COTIZACION.coddoc + " " + COTIZACION.nroped.
                UNDO CICLO, LEAVE.
            END.
            ASSIGN
                Facdpedi.CanAte = Facdpedi.CanAte - Vtaddocu.CanBase + Vtaddocu.CanPed.
        END.
        IF CAN-FIND(FIRST Facdpedi OF COTIZACION WHERE Facdpedi.CanPed > Facdpedi.CanAte NO-LOCK)
            THEN COTIZACION.FlgEst = "P".
        ELSE COTIZACION.FlgEst = "C".
    END.
    ASSIGN 
        Vtacdocu.FlgSit = "C"
        Vtacdocu.Libre_c03 = s-user-id + '|' + STRING(NOW, '99/99/9999 HH:MM:SS') + '|' + Vtacdocu.usrsac
        Vtacdocu.usrsacrecep = s-user-id
        /*Vtacdocu.zonapickeo = pZonaPickeo*/
        Vtacdocu.fchfin = NOW
        Vtacdocu.usuariofin = s-user-id.
    /* Verificamos si ya se puede cerrar la orden original */
    IF NOT CAN-FIND(FIRST Vtacdocu WHERE Vtacdocu.codcia = ORDEN.codcia
                    AND Vtacdocu.coddiv = ORDEN.coddiv
                    AND Vtacdocu.codped = ORDEN.coddoc
                    AND ENTRY(1,Vtacdocu.nroped,'-') = ORDEN.nroped
                    AND Vtacdocu.flgsit <> "C"
                    NO-LOCK)
        THEN DO:
        ASSIGN
            ORDEN.FlgSit = "P".    /* Picking OK */
        lOrdenLista = YES.
    END.
    /* Marco la ORDEN como COMPLETADO o FALTANTES */
    x-NroRef = ENTRY(1,VtaCDocu.NroPed,'-').
    FOR EACH b-vtacdocu WHERE b-vtacdocu.codcia = Vtacdocu.codcia
        AND b-vtacdocu.divdes = s-CodDiv
        AND b-vtacdocu.codped = Vtacdocu.codped
        AND ENTRY(1,b-vtacdocu.nroped,'-') = x-nroref :
        ASSIGN 
            b-VtacDocu.libre_c05 = IF(lOrdenLista = YES) THEN "COMPLETADO" ELSE "FALTANTES".
    END.
END.
IF AVAILABLE(Faccpedi)   THEN RELEASE Faccpedi.
IF AVAILABLE(ORDEN)      THEN RELEASE ORDEN.
IF AVAILABLE(COTIZACION) THEN RELEASE COTIZACION.
IF AVAILABLE(b-vtacdocu) THEN RELEASE b-vtacdocu.
IF pError > '' THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.
IF lOrdenLista = YES THEN DO:
    MESSAGE "Documento" Vtacdocu.CodPed ENTRY(1,Vtacdocu.NroPed,'-') "listo para CIERRE" VIEW-AS ALERT-BOX INFORMATION.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviar-impresion B-table-Win 
PROCEDURE enviar-impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RB-INCLUDE-RECORDS = "O".

RB-FILTER = " w-report.task-no = " + STRING(s-task-no) +  
              " AND w-report.llave-c = '" + lNroEnvio + "'".
RB-OTHER-PARAMETERS = "".

DEFINE VARIABLE cDatabaseName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cHostName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNetworkProto    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPortNumber      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOtherParams     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNewConnString   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDelimeter       AS CHARACTER NO-UNDO.

GET-KEY-VALUE SECTION "RBParametros" KEY "cDatabaseName" VALUE cDatabaseName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cHostName" VALUE cHostName.
GET-KEY-VALUE SECTION "RBParametros" KEY "cNetworkProto" VALUE cNetworkProto.
GET-KEY-VALUE SECTION "RBParametros" KEY "cPortNumber" VALUE cPortNumber.
GET-KEY-VALUE SECTION "RBParametros" KEY "cOtherParams" VALUE cOtherParams.

ASSIGN cDelimeter = CHR(32).
IF NOT (cDatabaseName = ? OR
   cHostName = ? OR
   cNetworkProto = ? OR
   cPortNumber = ?) THEN DO:
   ASSIGN
       cNewConnString =
       "-db" + cDelimeter + cDatabaseName + cDelimeter +
       "-H" + cDelimeter + cHostName + cDelimeter +
       "-N" + cDelimeter + cNetworkProto + cDelimeter +
       "-S" + cDelimeter + cPortNumber + cDelimeter.
   RB-DB-CONNECTION = cNewConnString.
END.

RUN bin/_prnctr.p.
IF s-salida-impresion = 0 THEN RETURN.

ASSIGN
      RB-REPORT-NAME = "Envio Subordenes 1er-piso"
      RB-BEGIN-PAGE = s-pagina-inicial
      RB-END-PAGE = s-pagina-final
      RB-PRINTER-NAME = s-printer-name
      RB-OUTPUT-FILE = s-print-file
      RB-NUMBER-COPIES = s-nro-copias.
  CASE s-salida-impresion:
      WHEN 1 THEN RB-PRINT-DESTINATION = "D".     /* Pantalla */
      WHEN 2 THEN RB-PRINT-DESTINATION = "".      /* Impresora */
      WHEN 3 THEN RB-PRINT-DESTINATION = "A".     /* Archivo */
  END CASE.
  RUN aderb/_prntrb2 (RB-REPORT-LIBRARY,
                      RB-REPORT-NAME,
                      RB-DB-CONNECTION,
                      RB-INCLUDE-RECORDS,
                      RB-FILTER,
                      RB-MEMO-FILE,
                      RB-PRINT-DESTINATION,
                      RB-PRINTER-NAME,
                      RB-PRINTER-PORT,
                      RB-OUTPUT-FILE,
                      RB-NUMBER-COPIES,
                      RB-BEGIN-PAGE,
                      RB-END-PAGE,
                      RB-TEST-PATTERN,
                      RB-WINDOW-TITLE,
                      RB-DISPLAY-ERRORS,
                      RB-DISPLAY-STATUS,
                      RB-NO-WAIT,
                      RB-OTHER-PARAMETERS,
                      "").

/* Borar el temporal */

DEF BUFFER B-w-report FOR w-report.
DEFINE VAR lRowId AS ROWID.

FOR EACH w-report WHERE w-report.task-no = s-task-no NO-LOCK:
    lRowId = ROWID(w-report).
    FIND FIRST b-w-report WHERE ROWID(b-w-report) = lRowid EXCLUSIVE NO-ERROR.
    IF AVAILABLE b-w-report THEN DO:
        DELETE b-w-report.            
    END.    
END.
RELEASE B-w-report.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviar-tareas B-table-Win 
PROCEDURE enviar-tareas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lRegSele AS INT.

lRegSele = {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}.

/* Si hay registros seleccionados */
IF lRegSele <= 0 THEN RETURN "ADM-ERROR".

MESSAGE 'Seguro de realizar el Envio?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN "ADM-ERROR".

DEFINE VAR lCont AS INT.
DEFINE VAR lRowid AS ROWID.
DEFINE VAR lRegs AS INT.

DEFINE BUFFER b-vtacdocu FOR vtacdocu.

lNroEnvio = STRING(NOW,"99/99/9999 HH:MM:SS").

lNroEnvio = REPLACE(lNroEnvio,"/","").
lNroEnvio = REPLACE(lNroEnvio,":","").
lNroEnvio = REPLACE(lNroEnvio," ","").

lRegs = 0.
EMPTY TEMP-TABLE x-vtacdocu.

DO WITH FRAME {&FRAME-NAME}:    
    DO lCont = 1 TO lRegSele :
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(lcont) THEN DO:
            lRowId = ROWID(VtacDocu).
            FIND FIRST b-vtacdocu OF vtacdocu EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE b-vtacdocu THEN DO:
                ASSIGN b-vtacdocu.coddep = lNroEnvio
                        b-vtacdocu.codprov = s-user-id + "|" + STRING(NOW,"99/99/9999 HH:MM:SS").
                lRegs = lRegs + 1.

                /* Copiar al Temporal */
                CREATE x-vtacdocu.
                    BUFFER-COPY vtacdocu TO x-vtacdocu.

            END.
            /*cFami = {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}.Codfam.*/
        END.
        RELEASE b-vtacdocu.
    END.    
    {&OPEN-QUERY-br_table}
END.

IF lRegs = 0 THEN RETURN "ADM-ERROR".
/* Llenar el Temporal para la impresion */

REPEAT:
    s-task-no = RANDOM(1, 999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no
                    AND w-report.llave-c = lNroEnvio NO-LOCK)
        THEN DO:
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no.
        LEAVE.
    END.
END.

FOR EACH x-vtacdocu :
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no
        w-report.llave-c = lNroEnvio
        w-report.campo-c[1] = x-vtacdocu.codped
        w-report.campo-c[2] = x-vtacdocu.nroped
        w-report.campo-c[3] = x-vtacdocu.codcli
        w-report.campo-c[4] = x-vtacdocu.nomcli
        w-report.campo-c[5] = STRING(x-vtacdocu.fchped,"99/99/9999")
        w-report.campo-c[7] = STRING(x-vtacdocu.fchent,"99/99/9999")
        w-report.campo-c[6] = lNroEnvio
        w-report.campo-c[20] = "*" + lNroEnvio + "*".
END.

/* Imprimir */
RUN enviar-impresion.

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

DEF INPUT PARAMETER pRowid AS ROWID .

{lib/lock-genericov21.i &Tabla="Faccpedi" ~
        &Condicion="ROWID(Faccpedi) = pRowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-WAIT" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &TipoError="RETURN 'ADM-ERROR'" ~
        &Intentos=5 ~
        }

{vta2/graba-totales-cotizacion-cred.i}

RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "T-VtaCDocu"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSector B-table-Win 
FUNCTION fSector RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND PikSupervisores WHERE PikSupervisores.CodCia = s-codcia
      AND PikSupervisores.CodDiv = s-coddiv
      AND PikSupervisores.Usuario = s-user-id
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE PikSupervisores THEN RETURN TRUE.
  MESSAGE ENTRY(2,VtaCDocu.NroPed,'-').
  IF LOOKUP(ENTRY(2,VtaCDocu.NroPed,'-'),PikSupervisores.Sector) > 0 THEN RETURN TRUE.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

