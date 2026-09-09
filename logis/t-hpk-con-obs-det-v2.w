&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER B-VtaCDocu FOR VtaCDocu.
DEFINE BUFFER B-VtaDDocu FOR VtaDDocu.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER ORDEN FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE t-VtaDDocu LIKE VtaDDocu.



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

&SCOPED-DEFINE ARITMETICA-SUNAT YES

/* Parameters Definitions ---                                           */
DEF SHARED VAR s-CodCia AS INTE.
DEF SHARED VAR s-User-Id AS CHAR.
DEF SHARED VAR s-CodDiv AS CHAR.

/* Local Variable Definitions ---                                       */

DEF VAR x-CodDoc AS CHAR NO-UNDO.
DEF VAR x-NroDoc AS CHAR NO-UNDO.

DEF VAR x-Articulo-ICBPer AS CHAR INIT '099268'.

DEF SHARED VAR lh_handle AS HANDLE.

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
&Scoped-define INTERNAL-TABLES t-VtaDDocu Almmmatg almtabla

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table t-VtaDDocu.CodMat Almmmatg.DesMat ~
Almmmatg.DesMar t-VtaDDocu.CanPed t-VtaDDocu.CanBase t-VtaDDocu.UndVta ~
t-VtaDDocu.Libre_c01 almtabla.Nombre 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table t-VtaDDocu.CanPed ~
t-VtaDDocu.Libre_c01 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table t-VtaDDocu
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table t-VtaDDocu
&Scoped-define QUERY-STRING-br_table FOR EACH t-VtaDDocu WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF t-VtaDDocu NO-LOCK, ~
      FIRST almtabla WHERE almtabla.Codigo = t-VtaDDocu.Libre_c01 ~
      AND almtabla.Tabla = "HPK" ~
 AND almtabla.NomAnt = "PO" OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH t-VtaDDocu WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF t-VtaDDocu NO-LOCK, ~
      FIRST almtabla WHERE almtabla.Codigo = t-VtaDDocu.Libre_c01 ~
      AND almtabla.Tabla = "HPK" ~
 AND almtabla.NomAnt = "PO" OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table t-VtaDDocu Almmmatg almtabla
&Scoped-define FIRST-TABLE-IN-QUERY-br_table t-VtaDDocu
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
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
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      t-VtaDDocu, 
      Almmmatg, 
      almtabla
    FIELDS(almtabla.Nombre) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      t-VtaDDocu.CodMat COLUMN-LABEL "Artículo" FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(60)":U
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U
      t-VtaDDocu.CanPed COLUMN-LABEL "Cantidad!Pickeada" FORMAT ">>>,>>>,>>9.99":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      t-VtaDDocu.CanBase COLUMN-LABEL "Cantidad!Pedida" FORMAT ">>>,>>>,>>9.99":U
      t-VtaDDocu.UndVta FORMAT "x(5)":U
      t-VtaDDocu.Libre_c01 COLUMN-LABEL "Motivo" FORMAT "x(10)":U
      almtabla.Nombre COLUMN-LABEL "Descripción" FORMAT "x(40)":U
  ENABLE
      t-VtaDDocu.CanPed
      t-VtaDDocu.Libre_c01
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 136 BY 20.46
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
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: B-VtaCDocu B "?" ? INTEGRAL VtaCDocu
      TABLE: B-VtaDDocu B "?" ? INTEGRAL VtaDDocu
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: ORDEN B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: t-VtaDDocu T "?" ? INTEGRAL VtaDDocu
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
         HEIGHT             = 21.5
         WIDTH              = 138.86.
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
     _TblList          = "Temp-Tables.t-VtaDDocu,INTEGRAL.Almmmatg OF Temp-Tables.t-VtaDDocu,INTEGRAL.almtabla WHERE Temp-Tables.t-VtaDDocu ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ",, FIRST OUTER USED"
     _JoinCode[3]      = "INTEGRAL.almtabla.Codigo = Temp-Tables.t-VtaDDocu.Libre_c01"
     _Where[3]         = "INTEGRAL.almtabla.Tabla = ""HPK""
 AND INTEGRAL.almtabla.NomAnt = ""PO"""
     _FldNameList[1]   > Temp-Tables.t-VtaDDocu.CodMat
"t-VtaDDocu.CodMat" "Artículo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-VtaDDocu.CanPed
"t-VtaDDocu.CanPed" "Cantidad!Pickeada" ">>>,>>>,>>9.99" "decimal" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-VtaDDocu.CanBase
"t-VtaDDocu.CanBase" "Cantidad!Pedida" ">>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.t-VtaDDocu.UndVta
     _FldNameList[7]   > Temp-Tables.t-VtaDDocu.Libre_c01
"t-VtaDDocu.Libre_c01" "Motivo" "x(10)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.almtabla.Nombre
"almtabla.Nombre" "Descripción" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME t-VtaDDocu.Libre_c01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-VtaDDocu.Libre_c01 br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF t-VtaDDocu.Libre_c01 IN BROWSE br_table /* Motivo */
OR F8 OF t-VtaDDocu.Libre_c01
DO:
    ASSIGN
        input-var-1 = 'HPK'
        input-var-2 = 'PO'
        input-var-3 = ''
        output-var-1 = ?
        output-var-2 = ''.
    RUN lkup/c-almtab-nom-act ('Motivo de Observación').
    IF output-var-1 <> ? THEN DO:
        SELF:SCREEN-VALUE = output-var-2.
        DISPLAY output-var-3 @ almtabla.Nombre WITH BROWSE {&browse-name}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF t-VtaDDocu.CanPed, t-VtaDDocu.Libre_c01
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Relacionados B-table-Win 
PROCEDURE Actualiza-Relacionados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

&SCOPED-DEFINE Otros-RA ~
FOR EACH Facdpedi OF ORDEN NO-LOCK, ~
    FIRST Vtaddocu OF Vtacdocu NO-LOCK WHERE Vtaddocu.codmat = Facdpedi.codmat: ~
    FIND FIRST Almdrepo OF Almcrepo WHERE Almdrepo.codmat = Facdpedi.codmat NO-LOCK NO-ERROR NO-WAIT. ~
    IF NOT AVAILABLE Almdrepo THEN NEXT. ~
    FIND CURRENT Almdrepo EXCLUSIVE-LOCK NO-ERROR NO-WAIT. ~
    IF ERROR-STATUS:ERROR = YES THEN DO: ~
        pError = 'NO se pudo bloquear el artículo de la R/A: ' + Facdpedi.codmat. ~
        UNDO CICLO, RETURN 'ADM-ERROR'. ~
    END. ~
    ASSIGN ~
        Almdrepo.CanAte = Almdrepo.CanAte - Facdpedi.CanPed + (Vtaddocu.CanPed / Facdpedi.Factor). ~
END.

&SCOPED-DEFINE Otros-COT ~
FOR EACH Facdpedi OF ORDEN NO-LOCK, ~
    FIRST Vtaddocu OF Vtacdocu NO-LOCK WHERE Vtaddocu.codmat = Facdpedi.codmat: ~
    FIND FIRST B-DPEDI OF COTIZACION WHERE B-DPEDI.codmat = Facdpedi.codmat NO-LOCK NO-ERROR. ~
    IF NOT AVAILABLE B-DPEDI THEN NEXT. ~
    FIND CURRENT B-DPEDI EXCLUSIVE-LOCK NO-ERROR NO-WAIT. ~
    IF ERROR-STATUS:ERROR = YES THEN DO: ~
        pError = 'NO se pudo bloquear el artículo de la COTIZACION: ' + Facdpedi.codmat. ~
        UNDO CICLO, RETURN 'ADM-ERROR'. ~
    END. ~
    ASSIGN ~
        B-DPEDI.CanAte = B-DPEDI.CanAte - Facdpedi.CanPed + (Vtaddocu.CanPed / B-DPEDI.Factor). ~
END.

&SCOPED-DEFINE Otros-PED ~
FOR EACH Facdpedi OF ORDEN NO-LOCK, ~
    FIRST Vtaddocu OF Vtacdocu NO-LOCK WHERE Vtaddocu.codmat = Facdpedi.codmat: ~
    FIND FIRST B-DPEDI OF PEDIDO WHERE B-DPEDI.codmat = Facdpedi.codmat NO-LOCK NO-ERROR. ~
    IF NOT AVAILABLE B-DPEDI THEN NEXT. ~
    FIND CURRENT B-DPEDI EXCLUSIVE-LOCK NO-ERROR NO-WAIT. ~
    IF ERROR-STATUS:ERROR = YES THEN DO: ~
        pError = 'NO se pudo bloquear el artículo del PEDIDO: ' + Facdpedi.codmat. ~
        UNDO CICLO, RETURN 'ADM-ERROR'. ~
    END. ~
    ASSIGN ~
        B-DPEDI.CanPed = (Vtaddocu.CanPed / B-DPEDI.Factor)~
        B-DPEDI.CanAte = (Vtaddocu.CanPed / B-DPEDI.Factor). ~
    IF B-DPEDI.CanPed <= 0 THEN DELETE B-DPEDI. ~
END.

{logis/i-hpk-con-obs.i &txtMensaje="pError" &Control-RA="{&Otros-RA}" &Control-COT="{&Otros-COT}" &Control-PED="{&Otros-PED}"}

RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Busca-Orden B-table-Win 
PROCEDURE Busca-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodOri AS CHAR.    /* PHR */
DEF INPUT PARAMETER pNroOri AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.    /* O/D */
DEF INPUT PARAMETER pNroPed AS CHAR.
DEF OUTPUT PARAMETER pFound AS LOG.

pFound = NO.
DEF BUFFER b-vtacdocu FOR vtacdocu.
DEF BUFFER b-almddocu FOR almddocu.

FOR EACH b-vtacdocu NO-LOCK WHERE b-vtacdocu.codcia = s-codcia AND
    b-vtacdocu.coddiv = s-coddiv AND
    b-vtacdocu.codped = "HPK" AND
    b-vtacdocu.codori = pCodOri AND 
    b-vtacdocu.nroori = pNroOri:
    CASE b-vtacdocu.codter:
        WHEN "ACUMULATIVO" THEN DO:
            FOR EACH b-Almddocu WHERE b-AlmDDocu.CodCia = b-Vtacdocu.CodCia AND
                b-AlmDDocu.CodLlave = b-Vtacdocu.codped + ',' + b-Vtacdocu.nroped:
                IF b-AlmDDocu.CodDoc = pCodDoc AND b-AlmDDocu.NroDoc = ORDEN.NroPed 
                    THEN DO:
                    pFound = YES.
                    RETURN.
                END.
            END.
        END.
        OTHERWISE DO:
            IF b-Vtacdocu.codref = pCodDoc AND
                b-Vtacdocu.nroref = pNroPed THEN DO:
                pFound = YES.
                RETURN.
            END.
        END.
    END CASE.
END.

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

DEF INPUT PARAMETER TABLE FOR t-VtaDDocu.

FOR EACH t-VtaDDocu NO-LOCK:
    x-CodDoc = t-VtaDDocu.CodPed.
    x-NroDoc = t-VtaDDocu.NroPed.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
FIND VtaCDocu WHERE Vtacdocu.codcia = s-codcia AND Vtacdocu.codped = x-coddoc AND Vtacdocu.nroped = x-nrodoc NO-LOCK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cerrar-Otros B-table-Win 
PROCEDURE Cerrar-Otros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.       
/* OJO:
    Como hay un proceso mas que modifica la cantidad pedida entonces
    arrastramos la cantidad final en el campo Vtaddocu.CanBase
*/    
DEF VAR pCuentaError AS INT NO-UNDO.
DEF VAR x-CanPed AS DEC NO-UNDO.

pError = "".  
CICLO:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* Actualizamos los documentos originales */
    {lib/lock-genericov3.i ~
        &Tabla="ORDEN" ~
        &Alcance="FIRST" ~
        &Condicion="ORDEN.codcia = Vtacdocu.codcia ~
        AND ORDEN.coddoc = Vtacdocu.CodRef ~ 
        AND ORDEN.nroped = Vtacdocu.NroRef" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &txtMensaje="pError" ~
        &TipoError="UNDO, LEAVE" ~
        &Intentos=5 ~
        }
    /* ************************************************************************ */
    /* POSICIONA EL PUNTERO EN EL PEDIDO Y LA COTIZACION EN MODO EXCLUSIVE-LOCK */
    /* ************************************************************************ */
    RUN Actualiza-Relacionados (OUTPUT pError).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, LEAVE.
    /* ************************************************************************ */
    /*  ACTUALIZAMOS EL DETALLE DE LA HPK */
    /* ************************************************************************ */
    FOR EACH Vtaddocu OF Vtacdocu NO-LOCK:
        FIND FIRST Facdpedi OF ORDEN WHERE Facdpedi.codmat = Vtaddocu.codmat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Facdpedi THEN NEXT.
        FIND CURRENT Facdpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pError" &CuentaError="pCuentaError"}
            UNDO CICLO, LEAVE CICLO.
        END.
        FIND FIRST Almmmatg OF Facdpedi NO-LOCK.
        /* *************************************** */
        /* RHC 11/03/2020 Conrol de modificaciones */
        /* *************************************** */
        ASSIGN
            x-CanPed = Facdpedi.CanPed.
        /* 1ro. Extornamos la cantidad base */
        ASSIGN
            Facdpedi.CanPed = Facdpedi.CanPed - (Vtaddocu.CanBase / Facdpedi.Factor).
        /* 2do. Actualizamos la cantidad pickeada final */
        ASSIGN
            Facdpedi.CanPed = Facdpedi.CanPed + (Vtaddocu.CanPed / Facdpedi.Factor).
        /* *************************************** */
        /* RHC 11/03/2020 Control de modificaciones */
        /* *************************************** */
        IF x-CanPed <> Facdpedi.CanPed THEN DO:
            CREATE LogTabla.
            ASSIGN
                logtabla.codcia = s-CodCia
                logtabla.Dia = TODAY
                logtabla.Evento = 'CORRECCION'
                logtabla.Hora = STRING(TIME, 'HH:MM:SS')
                logtabla.Tabla = 'FACDPEDI'
                logtabla.Usuario = s-User-Id
                logtabla.ValorLlave = Facdpedi.CodDoc + '|' +
                                        Facdpedi.NroPed + '|' +
                                        Facdpedi.CodMat + '|' +
                                        STRING(x-CanPed) + '|' +
                                        STRING(Facdpedi.CanPed) + '|' +
                                        Vtacdocu.codped + '|' +
                                        Vtacdocu.nroped + '|' + 
                                        Vtaddocu.libre_c01.
        END.
        /* *************************************** */
        /* 3ro. Recalcular */
        RUN Recalcula-Registro.
        /* OJO: Los items que están en cero se ELIMINAN */
        IF Facdpedi.CanPed <= 0 THEN DO:
            DELETE Facdpedi.    /* OJO */
        END.
    END.
    IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.
    /* ************************************************************************ */
    /* ************************************************************************ */
    CASE ORDEN.CodDoc:
        WHEN "O/D" OR WHEN "O/M" THEN DO:
            RUN Graba-Totales ( ROWID(ORDEN), OUTPUT pError ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                pError = "NO se pudo actualizar el documento: " + ORDEN.coddoc + " " + ORDEN.nroped.
                UNDO CICLO, LEAVE CICLO.
            END.
            /* Actualizamos Saldo del Pedido: Eliminamos la cantidad base y actualizamos con la cantidad pickeada */
            FIND FIRST PEDIDO WHERE PEDIDO.codcia = ORDEN.codcia
                AND PEDIDO.coddoc = ORDEN.codref
                AND PEDIDO.nroped = ORDEN.nroref
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE PEDIDO THEN DO:
                pError = "No se pudo ACTUALIZAR el pedido: " + ORDEN.CodRef + " " + ORDEN.NroRef.
                UNDO CICLO, LEAVE CICLO.
            END.
            FIND CURRENT PEDIDO EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                pError = "No se pudo ACTUALIZAR el pedido: " + ORDEN.CodRef + " " + ORDEN.NroRef.
                UNDO CICLO, LEAVE CICLO.
            END.
            FOR EACH Vtaddocu OF Vtacdocu NO-LOCK:
                FIND FIRST Facdpedi OF PEDIDO WHERE Facdpedi.codmat = Vtaddocu.codmat NO-LOCK NO-ERROR.
                IF NOT AVAILABLE Facdpedi THEN NEXT.
                FIND CURRENT Facdpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF ERROR-STATUS:ERROR = YES THEN DO:
                    {lib/mensaje-de-error.i &MensajeError="pError" &CuentaError="pCuentaError"}
                    UNDO CICLO, LEAVE CICLO.
                END.
                ASSIGN
                    Facdpedi.CanPed = Facdpedi.CanPed - (Vtaddocu.CanBase / Facdpedi.Factor) + (Vtaddocu.CanPed / Facdpedi.Factor)
                    Facdpedi.CanAte = Facdpedi.CanAte - (Vtaddocu.CanBase / Facdpedi.Factor) + (Vtaddocu.CanPed / Facdpedi.Factor)
                    Facdpedi.CanPick = Facdpedi.CanPick - (Vtaddocu.CanBase / Facdpedi.Factor) + (Vtaddocu.CanPed / Facdpedi.Factor).
                IF Facdpedi.CanPed <= 0 THEN DELETE Facdpedi.   /* OJO */
            END.
            IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.
            RUN Graba-Totales ( ROWID(PEDIDO), OUTPUT pError ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                pError = "NO se pudo actualizar el documento: " + PEDIDO.coddoc + " " + PEDIDO.nroped.
                UNDO CICLO, LEAVE CICLO.
            END.
            IF NOT CAN-FIND(FIRST Facdpedi OF PEDIDO NO-LOCK) THEN ASSIGN PEDIDO.FlgEst = "A".  /* <<< OJO <<< */
            /* Actualizamos Saldo de la Cotización */
            IF ORDEN.CodDoc = 'O/D' THEN DO:
                FIND FIRST COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
                    AND COTIZACION.coddoc = PEDIDO.codref
                    AND COTIZACION.nroped = PEDIDO.nroref
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE COTIZACION THEN DO:
                    pError = "No se pudo ACTUALIZAR la Cotizacion: " + PEDIDO.CodRef + " " + PEDIDO.NroRef.
                    UNDO CICLO, LEAVE CICLO.
                END.
                FIND CURRENT COTIZACION EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF ERROR-STATUS:ERROR = YES THEN DO:
                    pError = "No se pudo ACTUALIZAR la Cotizacion: " + PEDIDO.CodRef + " " + PEDIDO.NroRef.
                    UNDO CICLO, LEAVE CICLO.
                END.
                FOR EACH Vtaddocu OF Vtacdocu NO-LOCK:
                    FIND FIRST Facdpedi OF COTIZACION WHERE Facdpedi.codmat = Vtaddocu.codmat NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE Facdpedi THEN NEXT.
                    FIND CURRENT Facdpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF ERROR-STATUS:ERROR = YES THEN DO:
                        {lib/mensaje-de-error.i &MensajeError="pError" &CuentaError="pCuentaError"}
                        UNDO CICLO, LEAVE CICLO.
                    END.
                    ASSIGN
                        Facdpedi.CanAte = Facdpedi.CanAte - (Vtaddocu.CanBase / Facdpedi.Factor) + (Vtaddocu.CanPed / Facdpedi.Factor).
                END.
                IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.
                IF CAN-FIND(FIRST Facdpedi OF COTIZACION WHERE Facdpedi.CanPed > Facdpedi.CanAte NO-LOCK)
                    THEN COTIZACION.FlgEst = "P".
                ELSE COTIZACION.FlgEst = "C".
            END.
        END.
        WHEN "OTR" THEN DO:
            /* OJO: Si NO tiene items entonces ANULAR la OTR */
            IF NOT CAN-FIND(FIRST Facdpedi OF ORDEN NO-LOCK) THEN DO:
                ASSIGN
                    ORDEN.FlgEst = "A".
                /* RHC 30/10/2019 Se elimina la ORDEN de todas las PHR */
                REPEAT:
                    FIND FIRST DI-RutaD WHERE DI-RutaD.CodCia = ORDEN.CodCia AND
                        DI-RutaD.CodDiv = s-CodDiv AND 
                        DI-RutaD.CodDoc = "PHR" AND 
                        DI-RutaD.CodRef = ORDEN.CodDoc AND
                        DI-RutaD.NroRef = ORDEN.NroPed
                        NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE DI-RutaD THEN LEAVE.
                    FIND CURRENT DI-RutaD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF NOT AVAILABLE DI-RutaD THEN DO:
                        {lib/mensaje-de-error.i &MensajeError="pError"}
                        UNDO CICLO, LEAVE CICLO.
                    END.
                    DELETE DI-RutaD.
                END.
                /* RHC 18/12/2019 Anulamos las R/A's relacionadas */
                IF ORDEN.CodRef = "R/A" THEN DO:
                    FIND FIRST Almcrepo WHERE almcrepo.CodCia = ORDEN.CodCia AND
                        almcrepo.NroSer = INTEGER(SUBSTRING(ORDEN.NroRef,1,3)) AND
                        almcrepo.NroDoc = INTEGER(SUBSTRING(ORDEN.NroRef,4))
                        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF ERROR-STATUS:ERROR = YES THEN DO:
                        pError = "NO se pudo anular la " + ORDEN.CodRef + " " + ORDEN.NroRef.
                        UNDO CICLO, LEAVE CICLO.
                    END.
                    ASSIGN
                        almcrepo.flgest = 'A'
                        almcrepo.usract = s-user-id
                        almcrepo.fecact = TODAY
                        almcrepo.horact = STRING(TIME, 'HH:MM:SS').
                END.
            END.
        END.
    END CASE.
    /* ************************************************************************ */
    /* CERRAMOS LA HPK */
    /* ************************************************************************ */
    ASSIGN 
        Vtacdocu.FlgSit = "P"   /* Listo para pasar a Chequeo */
        Vtacdocu.Libre_c03 = s-user-id + '|' + STRING(NOW, '99/99/9999 HH:MM:SS') + '|' + Vtacdocu.usrsac
        Vtacdocu.usrsacrecep = s-user-id
        Vtacdocu.fchfin = NOW
        Vtacdocu.usuariofin = s-user-id.
    FOR EACH Vtaddocu OF Vtacdocu NO-LOCK:
        FIND B-VtaDDocu WHERE ROWID(B-VtaDDocu) = ROWID(Vtaddocu) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pError" &CuentaError="pCuentaError"}
            UNDO CICLO, LEAVE CICLO.
        END.
        /* OJO: Actualizamos la cantidad base */
        ASSIGN 
            B-Vtaddocu.CanBase = B-Vtaddocu.CanPed.
        /* OJO: Los items que están en cero se ELIMINAN */
        IF B-Vtaddocu.CanPed <= 0 THEN DO:
            DELETE B-Vtaddocu.    /* OJO */
        END.
    END.
    IF AVAILABLE(B-Vtaddocu) THEN RELEASE B-Vtaddocu.
    /* ************************************************************************ */
    /* RHC 18/01/2019 Si NO tiene detalle => ELIMINAR COMPLETAMENTE */
    /* ************************************************************************ */
    DEF VAR pFound AS LOG NO-UNDO.
    DEF VAR pCodOri AS CHAR NO-UNDO.
    DEF VAR pNroOri AS CHAR NO-UNDO.

    /* Almacenamos la PHR de origen */
    ASSIGN
        pCodOri = VtaCDocu.CodOri
        pNroOri = VtaCDocu.NroOri.
    /* Si no hay registros => se elimina todo */
    FIND FIRST Vtaddocu OF Vtacdocu NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtaddocu THEN DO:
        ASSIGN 
            Vtacdocu.FlgSit = "A".   /* Listo para pasar a Chequeo */
        ASSIGN
            Vtacdocu.FlgEst = "A"
            Vtacdocu.CodPed = Vtacdocu.CodPed + "XX".   /* Para auditar */
        /*DELETE Vtacdocu.    /* OJO >>> Que no quede huella */*/
    END.
    /* ************************************************************************ */
    /* RHC 29/01/2019 BUSCAMOS SI AUN LA O/D ESTA EN LA PHR */
    /* Barremos c/u de los documentos */
    /* ************************************************************************ */
    RUN Busca-Orden (INPUT pCodOri,         /* PHR */
                     INPUT pNroOri,
                     INPUT ORDEN.CodDoc,    /* O/D */
                     INPUT ORDEN.NroPed,
                     OUTPUT pFound).
    IF pFound = NO AND ORDEN.FlgEst = "P" THEN ORDEN.FlgSit = "T".     /* Regresa a su modo original */
    /* ********************************************************************************************* */
    /* RHC 09/05/2020 Si todas las HPK está COMPLETADO => O/D cambiamos FlgSit = "PI" */
    /* ********************************************************************************************* */
    IF pFound = YES THEN DO:
        DEF VAR lOrdenLista AS LOG NO-UNDO.
        lOrdenLista = YES.
        FOR EACH b-vtacdocu WHERE b-vtacdocu.codcia = s-codcia
              AND b-vtacdocu.coddiv = s-coddiv
              AND b-vtacdocu.codped = "HPK"
              AND b-vtacdocu.codref = ORDEN.CodDoc
              AND b-vtacdocu.nroref = ORDEN.NroPed:
              IF b-vtacdocu.flgsit <> "P" THEN DO:
                  lOrdenLista = NO.
                  LEAVE.
              END.
        END.
        IF lOrdenLista = YES THEN DO:
            /* Marcamos la O/D como PICADO COMPLETO */
              ASSIGN
                  ORDEN.FlgSit = "PI".
        END.
    END.
    /* ********************************************************************************************* */
    /* ********************************************************************************************* */
    DEFINE VAR hProc AS HANDLE NO-UNDO.
    RUN logis/logis-librerias PERSISTENT SET hProc.
    /* ************************************************************** */
    /* RHC 15/11//2019 Si todas las HPK están OK => ORDEN Lista para facturar */
    /* ************************************************************** */
    RUN ODOTR_Listo-para-Facturar IN hProc (INPUT ORDEN.CodDoc,
                                            INPUT ORDEN.NroPed,
                                            OUTPUT pFound).
    IF pFound = YES AND ORDEN.FlgEst = "P" THEN ORDEN.FlgSit = "C".
    /* ************************************************************** */
    /* RHC 30/10/2019 Si todas las HPK están OK => PHR pasa a Fedateo */
    /* ************************************************************** */
    RUN PHR_Listo-para-Fedateo IN hProc (INPUT pCodOri,
                                         INPUT pNroOri,
                                         OUTPUT pError).
    DELETE PROCEDURE hProc.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, LEAVE.
    /* ************************************************************** */
    /* RHC 05/03/2021 Si ya no hay mas items en la ORDEN => se ANULA  */
    /* ************************************************************** */
    IF NOT CAN-FIND(FIRST Facdpedi OF ORDEN NO-LOCK) THEN DO:
        ASSIGN 
            ORDEN.FlgEst = "A".
        /* RHC 30/10/2019 Se elimina la ORDEN de todas las PHR */
        REPEAT:
            FIND FIRST DI-RutaD WHERE DI-RutaD.CodCia = ORDEN.CodCia AND
                DI-RutaD.CodDiv = s-CodDiv AND 
                DI-RutaD.CodDoc = "PHR" AND 
                DI-RutaD.CodRef = ORDEN.CodDoc AND
                DI-RutaD.NroRef = ORDEN.NroPed
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE DI-RutaD THEN LEAVE.
            FIND CURRENT DI-RutaD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF NOT AVAILABLE DI-RutaD THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pError" &CuentaError="pCuentaError"}
                UNDO CICLO, LEAVE CICLO.
            END.
            DELETE DI-RutaD.
        END.
    END.
END.
IF AVAILABLE Faccpedi THEN RELEASE Faccpedi.
IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.
IF AVAILABLE ORDEN THEN RELEASE ORDEN.
IF AVAILABLE PEDIDO THEN RELEASE PEDIDO.
IF AVAILABLE COTIZACION THEN RELEASE COTIZACION.
IF AVAILABLE Almcrepo THEN RELEASE Almcrepo.

IF pError > '' THEN RETURN 'ADM-ERROR'.
RETURN 'OK'.

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

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR pCuenta AS INTE NO-UNDO.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* 1ro. Bloqueamos la cabecera */
    {lib/lock-genericov3.i ~
        &Tabla="VtaCDocu" ~
        &Condicion="VtaCDocu.CodCia = s-CodCia AND VtaCDocu.CodPed = x-CodDoc AND VtaCDocu.NroPed = x-NroDoc" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    /* 2ro. Actualizamos el detalle con los datos del temporal */
    FOR EACH t-Vtaddocu NO-LOCK:
        FIND FIRST VtaDDocu WHERE VtaDDocu.CodCia = t-VtaDDocu.CodCia
            AND VtaDDocu.CodDiv = t-VtaDDocu.CodDiv
            AND VtaDDocu.CodPed = t-VtaDDocu.CodPed
            AND VtaDDocu.NroPed = t-VtaDDocu.NroPed
            AND VtaDDocu.CodMat = t-VtaDDocu.CodMat 
            NO-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        FIND CURRENT VtaDDocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR THEN DO:
            {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        IF t-VtaDDocu.CanBase <> VtaDDocu.CanBase THEN DO:
            pMensaje = "El registro del artículo " + t-VtaDDocu.codmat + " ha sido modificado por otro usuario".
            UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        BUFFER-COPY t-VtaDDocu TO VtaDDocu.
    END.
    RUN Cerrar-Otros (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales B-table-Win 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID .
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

{lib/lock-genericov3.i &Tabla="Faccpedi" ~
        &Condicion="ROWID(Faccpedi) = pRowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="RETURN 'ADM-ERROR'" ~
        &Intentos=5 ~
        }

/* ****************************************************************************************** */
/* ****************************************************************************************** */
&IF {&ARITMETICA-SUNAT} &THEN
    {vtagn/totales-cotizacion-sunat.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
    /* ****************************************************************************************** */
    /* Importes SUNAT */
    /* ****************************************************************************************** */
    DEF VAR hProc AS HANDLE NO-UNDO.
    RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
    RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                 INPUT Faccpedi.CodDoc,
                                 INPUT Faccpedi.NroPed,
                                 OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
    DELETE PROCEDURE hProc.
&ELSE
    {vta2/graba-totales-cotizacion-cred.i}
    /* ****************************************************************************************** */
    /* Importes SUNAT */
    /* NO actualiza campos Progress */
    /* ****************************************************************************************** */
    DEF VAR hProc AS HANDLE NO-UNDO.
    RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
    RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                                 INPUT Faccpedi.CodDoc,
                                 INPUT Faccpedi.NroPed,
                                 OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
    DELETE PROCEDURE hProc.
&ENDIF
IF pMensaje = "OK" THEN pMensaje = "".
/* ****************************************************************************************** */
/* ****************************************************************************************** */

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      t-VtaDDocu.ImpLin = ROUND ( t-VtaDDocu.CanPed * t-VtaDDocu.PreUni * 
                    ( 1 - t-VtaDDocu.Por_Dsctos[1] / 100 ) *
                    ( 1 - t-VtaDDocu.Por_Dsctos[2] / 100 ) *
                    ( 1 - t-VtaDDocu.Por_Dsctos[3] / 100 ), 2 ).
  IF t-VtaDDocu.Por_Dsctos[1] = 0 AND t-VtaDDocu.Por_Dsctos[2] = 0 AND t-VtaDDocu.Por_Dsctos[3] = 0 
      THEN t-VtaDDocu.ImpDto = 0.
      ELSE t-VtaDDocu.ImpDto = t-VtaDDocu.CanPed * t-VtaDDocu.PreUni - t-VtaDDocu.ImpLin.
  ASSIGN
      t-VtaDDocu.ImpLin = ROUND(t-VtaDDocu.ImpLin, 2)
      t-VtaDDocu.ImpDto = ROUND(t-VtaDDocu.ImpDto, 2).
  IF t-VtaDDocu.AftIsc 
  THEN t-VtaDDocu.ImpIsc = ROUND(t-VtaDDocu.PreBas * t-VtaDDocu.CanPed * (Almmmatg.PorIsc / 100),4).
  ELSE t-VtaDDocu.ImpIsc = 0.
  IF t-VtaDDocu.AftIgv 
  THEN t-VtaDDocu.ImpIgv = t-VtaDDocu.ImpLin - ROUND( t-VtaDDocu.ImpLin  / ( 1 + (Vtacdocu.PorIgv / 100) ), 4 ).
  ELSE t-VtaDDocu.ImpIgv = 0.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-handle IN lh_handle ('enable-buttons').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-handle IN lh_handle ('disable-buttons').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcula-Registro B-table-Win 
PROCEDURE Recalcula-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Recalculamos el importe del registro */
    ASSIGN
        Facdpedi.ImpLin = ROUND ( Facdpedi.CanPed * Facdpedi.PreUni * 
                              ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                              ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                              ( 1 - Facdpedi.Por_Dsctos[3] / 100 ), 2 ).
    IF Facdpedi.Por_Dsctos[1] = 0 AND Facdpedi.Por_Dsctos[2] = 0 AND Facdpedi.Por_Dsctos[3] = 0 
        THEN Facdpedi.ImpDto = 0.
    ELSE Facdpedi.ImpDto = Facdpedi.CanPed * Facdpedi.PreUni - Facdpedi.ImpLin.
    ASSIGN
        Facdpedi.ImpLin = ROUND(Facdpedi.ImpLin, 2)
        Facdpedi.ImpDto = ROUND(Facdpedi.ImpDto, 2).
    IF Facdpedi.AftIsc 
        THEN Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE Facdpedi.ImpIsc = 0.
    IF Facdpedi.AftIgv 
        THEN Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND( Facdpedi.ImpLin  / ( 1 + (ORDEN.PorIgv / 100) ), 4 ).
    ELSE Facdpedi.ImpIgv = 0.

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
  {src/adm/template/snd-list.i "t-VtaDDocu"}
  {src/adm/template/snd-list.i "Almmmatg"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF DECIMAL(t-VtaDDocu.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0 THEN DO:
    MESSAGE 'Debe ingresar una cantidad' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO t-VtaDDocu.CanPed IN BROWSE {&BROWSE-NAME}.
    RETURN 'ADM-ERROR'.
END.
IF DECIMAL(t-VtaDDocu.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > t-VtaDDocu.CanBase THEN DO:
    MESSAGE 'NO puede superar la cantidad original' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO t-VtaDDocu.CanPed IN BROWSE {&BROWSE-NAME}.
    RETURN 'ADM-ERROR'.
END.
IF TRUE <> (t-VtaDDocu.Libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} > '') 
    THEN DO:
    MESSAGE 'Ingreso el motivo de la observación' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO t-VtaDDocu.Libre_c01.
    RETURN 'ADM-ERROR'.
END.
IF NOT CAN-FIND(FIRST Almtabla WHERE Almtabla.Tabla = 'HPK'
                AND Almtabla.NomAnt = 'PO'
                AND AlmTabla.Codigo = t-VtaDDocu.Libre_c01:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
                AND AlmTabla.CodCta1 <> "I"
                NO-LOCK)
    THEN DO:
    MESSAGE 'Código del motivo no registrado' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO t-VtaDDocu.Libre_c01.
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

