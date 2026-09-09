&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER B-VtaDDocu FOR VtaDDocu.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER ORDEN FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.



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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR INIT "HPK" NO-UNDO.
DEF VAR s-flgest AS CHAR INIT "O" NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.

&SCOPED-DEFINE Condicion (ChkTareas.CodCia = s-codcia ~
AND ChkTareas.CodDiv = s-coddiv ~
AND ChkTareas.CodDoc = s-coddoc ~
AND ChkTareas.FlgEst = s-flgest)

DEF VAR x-articulo-ICBPer AS CHAR INIT '099268'.

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
&Scoped-define INTERNAL-TABLES ChkTareas VtaCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ChkTareas.Mesa ChkTareas.CodDoc ~
ChkTareas.NroPed ChkTareas.FechaInicio ChkTareas.HoraInicio ~
ChkTareas.Prioridad 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH ChkTareas WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST VtaCDocu WHERE VtaCDocu.CodCia = ChkTareas.CodCia ~
  AND VtaCDocu.CodDiv = ChkTareas.CodDiv ~
  AND VtaCDocu.CodPed = ChkTareas.CodDoc ~
  AND VtaCDocu.NroPed = ChkTareas.NroPed ~
      AND VtaCDocu.FlgEst <> "A" NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ChkTareas WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST VtaCDocu WHERE VtaCDocu.CodCia = ChkTareas.CodCia ~
  AND VtaCDocu.CodDiv = ChkTareas.CodDiv ~
  AND VtaCDocu.CodPed = ChkTareas.CodDoc ~
  AND VtaCDocu.NroPed = ChkTareas.NroPed ~
      AND VtaCDocu.FlgEst <> "A" NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table ChkTareas VtaCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ChkTareas
&Scoped-define SECOND-TABLE-IN-QUERY-br_table VtaCDocu


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
      ChkTareas, 
      VtaCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      ChkTareas.Mesa FORMAT "x(8)":U WIDTH 8.43
      ChkTareas.CodDoc FORMAT "x(3)":U WIDTH 6.43
      ChkTareas.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U WIDTH 13
      ChkTareas.FechaInicio FORMAT "99/99/9999":U
      ChkTareas.HoraInicio FORMAT "x(8)":U WIDTH 9.43
      ChkTareas.Prioridad FORMAT "x(8)":U WIDTH 8.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 62 BY 6.69
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
      TABLE: B-VtaDDocu B "?" ? INTEGRAL VtaDDocu
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: ORDEN B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
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
         WIDTH              = 66.
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
     _TblList          = "INTEGRAL.ChkTareas,INTEGRAL.VtaCDocu WHERE INTEGRAL.ChkTareas ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _Where[1]         = "{&Condicion}"
     _JoinCode[2]      = "VtaCDocu.CodCia = ChkTareas.CodCia
  AND VtaCDocu.CodDiv = ChkTareas.CodDiv
  AND VtaCDocu.CodPed = ChkTareas.CodDoc
  AND VtaCDocu.NroPed = ChkTareas.NroPed"
     _Where[2]         = "VtaCDocu.FlgEst <> ""A"""
     _FldNameList[1]   > INTEGRAL.ChkTareas.Mesa
"ChkTareas.Mesa" ? ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.ChkTareas.CodDoc
"ChkTareas.CodDoc" ? ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.ChkTareas.NroPed
"ChkTareas.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.ChkTareas.FechaInicio
     _FldNameList[5]   > INTEGRAL.ChkTareas.HoraInicio
"ChkTareas.HoraInicio" ? ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.ChkTareas.Prioridad
"ChkTareas.Prioridad" ? ? "character" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Relacionados B-table-Win 
PROCEDURE Actualiza-Relacionados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Todo pasa a Unidades de Venta
------------------------------------------------------------------------------*/

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
        Almdrepo.CanAte = Almdrepo.CanAte - Facdpedi.CanPed + (Vtaddocu.CanPick / Facdpedi.Factor). ~
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
        B-DPEDI.CanAte = B-DPEDI.CanAte - Facdpedi.CanPed + (Vtaddocu.CanPick / B-DPEDI.Factor). ~
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
        B-DPEDI.CanPed = (Vtaddocu.CanPick / B-DPEDI.Factor)~
        B-DPEDI.CanAte = (Vtaddocu.CanPick / B-DPEDI.Factor). ~
    IF B-DPEDI.CanPed <= 0 THEN DELETE B-DPEDI. ~
END.

{logis/i-hpk-con-obs.i &Control-RA="{&Otros-RA}" &Control-COT="{&Otros-COT}" &Control-PED="{&Otros-PED}"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cerramos-HPK B-table-Win 
PROCEDURE Cerramos-HPK :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Rowid AS ROWID NO-UNDO.
pMensaje = ''.
x-Rowid = ROWID(Vtacdocu).
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    {lib/lock-genericov3.i ~
        &Tabla="Vtacdocu" ~
        &Condicion="ROWID(Vtacdocu) = x-Rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, LEAVE"}
        
    
    /* ***************************************************************************************** */
    /* Actualizamos Saldo de l O/D y los documentos relacionados (PED y COT) de acuerdo al chequeo */
    /* ***************************************************************************************** */
    RUN Cerrar-Otros.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo cerrar las O/D, PED y COT".
        UNDO, LEAVE.
    END.
END.
IF pMensaje > '' THEN RETURN 'ADM-ERROR'.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cerrar-con-Observaciones B-table-Win 
PROCEDURE Cerrar-con-Observaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE ChkTareas THEN RETURN.

/* RHC 07/08/2019 NO SE PUEDE CERRAR SI FALTAN ETIQUETAR LOS BULTOS */
FIND FIRST LogisDChequeo WHERE LogisDChequeo.CodCia = s-CodCia
    AND LogisDChequeo.CodDiv = s-CodDiv
    AND LogisDChequeo.CodPed = ChkTareas.CodDoc
    AND LogisDChequeo.NroPed = ChkTareas.NroPed
    AND (TRUE <> (logisdchequeo.Etiqueta > ''))
    NO-LOCK NO-ERROR.
IF AVAILABLE LogisDChequeo THEN DO:
    MESSAGE 'NO se puede CERRAR CON OBSERVACIONES' SKIP
        'Todavía hay bultos que ETIQUETAR' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

MESSAGE 'Desea cerrar CON OBSERVACIONES la' ChkTareas.CodDoc ChkTareas.NroPed "?"
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

/* Pasos:
    1- Vtaddocu: La cantidad Pedida = cantidad Chequeada
    2- Actualizar las O/D, PED y COT con los valores reales chequeados
    3- Cerrar la tarea y cerrar la HPK
    */

DEF VAR x-Rowid AS ROWID NO-UNDO.
DEF VAR x-RowidHPK AS ROWID NO-UNDO.
DEF VAR x-Embalado AS CHAR NO-UNDO.

x-Rowid = ROWID(ChkTareas).
x-RowidHPK = ROWID(Vtacdocu).

pMensaje = ''.
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    {lib/lock-genericov3.i ~
        &Tabla="ChkTareas" ~
        &Condicion="ROWID(ChkTareas) = x-Rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, LEAVE"}
   IF NOT {&Condicion} THEN DO:
       pMensaje = "La tarea ya no se encuentra observada".
       LEAVE.
   END.
   /* 1ro. Cerramos la Tarea      */
   /* ControlOD, Ccbcbult, Vtacdocu.FlgSit (PC o PE) Cntrol-LPN CHkTareas.FlgEst (T o E) */
   /* OJO: almacena en el campo Vtaddocu.CanPick el total Chequeado en Mesa */
   x-Embalado = (IF ChkTareas.Embalaje = YES THEN "SI" ELSE "NO").
   RUN logis/p-cierre-de-chequeo (INPUT ChkTareas.CodDoc,
                                  INPUT ChkTareas.NroPed,
                                  x-Embalado,       /*INPUT ChkTareas.Embalaje,*/
                                  INPUT ENTRY(1,Vtacdocu.libre_c04,'|'),
                                  INPUT ChkTareas.HoraInicio,
                                  INPUT ChkTareas.FechaInicio,
                                  INPUT ChkTareas.Mesa,
                                  NO,       /* SIN INCONSISTENCIAS */
                                  OUTPUT pMensaje).
   IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
       IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo cerrar la orden la tarea".
       UNDO, LEAVE.
   END.
   /* 2da. Actualizamos las O/D, PED y COT con la cantidad chequeada */
   RUN Cerramos-HPK.
   IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
       IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo cerrar la HPK".
       UNDO, LEAVE.
   END.
END.
IF AVAILABLE ChkTareas THEN RELEASE ChkTareas.
IF pMensaje > '' THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

FIND Vtacdocu WHERE ROWID(Vtacdocu) = x-RowidHPK NO-LOCK.
/* *************************************************************************** */
/* ALERTA */
/* *************************************************************************** */
RUN logis/d-alerta-phr-reasign (Vtacdocu.CodPed, Vtacdocu.NroPed).
/* *************************************************************************** */
/* *************************************************************************** */

RETURN 'OK'.

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

/* OJO:
    Como hay un proceso mas que modifica la cantidad pedida entonces
    arrastramos la cantidad final en el campo Vtaddocu.CanBase
    
*/    
DEF VAR pCuentaError AS INT NO-UNDO.

pMensaje = "".  
CICLO:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Actualizamos los documentos originales */
    {lib/lock-genericov3.i ~
        &Tabla="ORDEN" ~
        &Alcance="FIRST" ~
        &Condicion="ORDEN.codcia = Vtacdocu.codcia ~
        AND ORDEN.coddoc = Vtacdocu.CodRef ~ 
        AND ORDEN.nroped = Vtacdocu.NroRef" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, LEAVE" ~
        &Intentos=5 ~
        }
    
    /* ****************************************************************************************** */
    /* Actualizamos el detalle */
    RUN Actualiza-Relacionados.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo actualizar documentos relacionados'.
        UNDO, LEAVE.
    END.
    /* ************************************************************************ */
    
    FOR EACH Vtaddocu OF Vtacdocu NO-LOCK:
        FIND FIRST Facdpedi OF ORDEN WHERE Facdpedi.codmat = Vtaddocu.codmat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Facdpedi THEN NEXT.
        FIND CURRENT Facdpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="pCuentaError"}
            UNDO CICLO, LEAVE CICLO.
        END.
        FIND FIRST Almmmatg OF Facdpedi NO-LOCK.
        /* *************************************** */
        /* RHC 11/03/2020 Conrol de modificaciones */
        /* *************************************** */
        DEF VAR x-CanPed AS DEC NO-UNDO.
        ASSIGN
            x-CanPed = Facdpedi.CanPed.
        /* 1ro. Extornamos la cantidad base: en Unidades de Venta */
        ASSIGN
            Facdpedi.CanPed = Facdpedi.CanPed - (Vtaddocu.CanBase / Facdpedi.Factor).
        /* 2do. Actualizamos la cantidad pickeada final: en Unidades de Venta */
        ASSIGN
            Facdpedi.CanPed = Facdpedi.CanPed + (Vtaddocu.CanPick / Facdpedi.Factor).
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
                                        STRING(Facdpedi.CanPed)  + '|' +
                                        Vtacdocu.codped + '|' +
                                        Vtacdocu.nroped + '|' + 
                                        "XX".
        END.
        /* *************************************** */
        /* 3ro. Recalcular */
        RUN Recalcula-Registro.
        /* OJO: Los items que están en cero se ELIMINAN */
        IF Facdpedi.CanPed <= 0 THEN DO:
            DELETE Facdpedi.    /* OJO */
        END.
        /* ******************************************** */
    END.
    IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.
    
    CASE ORDEN.CodDoc:
        WHEN "O/D" OR WHEN "O/M" THEN DO:
            RUN Graba-Totales ( ROWID(ORDEN), OUTPUT pMensaje ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                pMensaje = "NO se pudo actualizar el documento: " + ORDEN.coddoc + " " + ORDEN.nroped.
                UNDO CICLO, LEAVE CICLO.
            END.
            /* Actualizamos Saldo del Pedido: Eliminamos la cantidad base y actualizamos con la cantidad pickeada */
            FIND FIRST PEDIDO WHERE PEDIDO.codcia = ORDEN.codcia
                AND PEDIDO.coddoc = ORDEN.codref
                AND PEDIDO.nroped = ORDEN.nroref
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE PEDIDO THEN DO:
                pMensaje = "No se pudo ACTUALIZAR el pedido: " + ORDEN.CodRef + " " + ORDEN.NroRef.
                UNDO CICLO, LEAVE CICLO.
            END.
            FIND CURRENT PEDIDO EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                pMensaje = "No se pudo ACTUALIZAR el pedido: " + ORDEN.CodRef + " " + ORDEN.NroRef.
                UNDO CICLO, LEAVE CICLO.
            END.
            FOR EACH Vtaddocu OF Vtacdocu NO-LOCK:
                FIND FIRST Facdpedi OF PEDIDO WHERE Facdpedi.codmat = Vtaddocu.codmat NO-LOCK NO-ERROR.
                IF NOT AVAILABLE Facdpedi THEN NEXT.
                FIND CURRENT Facdpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF ERROR-STATUS:ERROR = YES THEN DO:
                    {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="pCuentaError"}
                    UNDO CICLO, LEAVE CICLO.
                END.
                ASSIGN
                    Facdpedi.CanPed = Facdpedi.CanPed - (Vtaddocu.CanBase / Facdpedi.Factor) + (Vtaddocu.CanPick / Facdpedi.Factor)
                    Facdpedi.CanAte = Facdpedi.CanAte - (Vtaddocu.CanBase / Facdpedi.Factor) + (Vtaddocu.CanPick / Facdpedi.Factor)
                    Facdpedi.CanPick = Facdpedi.CanPick - (Vtaddocu.CanBase / Facdpedi.Factor) + (Vtaddocu.CanPick / Facdpedi.Factor).
                IF Facdpedi.CanPed <= 0 THEN DELETE Facdpedi.   /* OJO */
            END.
            IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.
            RUN Graba-Totales ( ROWID(PEDIDO), OUTPUT pMensaje ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                pMensaje = "NO se pudo actualizar el documento: " + PEDIDO.coddoc + " " + PEDIDO.nroped.
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
                    pMensaje = "No se pudo ACTUALIZAR la Cotizacion: " + PEDIDO.CodRef + " " + PEDIDO.NroRef.
                    UNDO CICLO, LEAVE CICLO.
                END.
                FIND CURRENT COTIZACION EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF ERROR-STATUS:ERROR = YES THEN DO:
                    pMensaje = "No se pudo ACTUALIZAR la Cotizacion: " + PEDIDO.CodRef + " " + PEDIDO.NroRef.
                    UNDO CICLO, LEAVE CICLO.
                END.
                FOR EACH Vtaddocu OF Vtacdocu NO-LOCK:
                    FIND FIRST Facdpedi OF COTIZACION WHERE Facdpedi.codmat = Vtaddocu.codmat NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE Facdpedi THEN NEXT.
                    FIND CURRENT Facdpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                    IF ERROR-STATUS:ERROR = YES THEN DO:
                        {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="pCuentaError"}
                        UNDO CICLO, LEAVE CICLO.
                    END.
                    ASSIGN
                        Facdpedi.CanAte = Facdpedi.CanAte - (Vtaddocu.CanBase / Facdpedi.Factor) + (Vtaddocu.CanPick / Facdpedi.Factor).
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
                        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
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
                        pMensaje = "NO se pudo anular la " + ORDEN.CodRef + " " + ORDEN.NroRef.
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
    
    /* ***************************************************************************************** */
    /* Actualizamos Saldo de la HPK */
    /* ***************************************************************************************** */
    FOR EACH Vtaddocu OF Vtacdocu NO-LOCK:
        FIND B-VtaDDocu WHERE ROWID(B-VtaDDocu) = ROWID(Vtaddocu) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="pCuentaError"}
            UNDO CICLO, LEAVE CICLO.
        END.
        /* OJO: Actualizamos la cantidad base */
        ASSIGN 
            B-Vtaddocu.CanPed  = B-Vtaddocu.CanPick
            B-Vtaddocu.CanBase = B-Vtaddocu.CanPick.
        /* OJO: Los items que están en cero se ELIMINAN */
        IF B-Vtaddocu.CanPed <= 0 THEN DO:
            DELETE B-Vtaddocu.    /* OJO */
        END.
    END.
    IF AVAILABLE(B-Vtaddocu) THEN RELEASE B-Vtaddocu.
    /* ************************************************************ */
    /* RHC 18/01/2019 Si NO tiene detalle => ELIMINAR COMPLETAMENTE */
    /* ************************************************************ */
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
    /* ************************************************************ */
    /* RHC 29/01/2019 BUSCAMOS SI AUN LA O/D ESTA EN LA PHR */
    /* Barremos c/u de los documentos */
    /* ************************************************************ */
    RUN Busca-Orden (INPUT pCodOri,         /* PHR */
                     INPUT pNroOri,
                     INPUT ORDEN.CodDoc,    /* O/D */
                     INPUT ORDEN.NroPed,
                     OUTPUT pFound).
    IF pFound = NO AND ORDEN.FlgEst = "P" THEN ORDEN.FlgSit = "T".     /* Regresa a su modo original */
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
    /* RHC 15/11//2019 Si todas las HPK están OK => ORDEN Lista para facturar */
    /* ************************************************************** */
    RUN LL_Actualiza-OD-Control IN hProc (INPUT ROWID(ORDEN),
                                          OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        UNDO CICLO, LEAVE CICLO.
    END.
    /* ************************************************************** */
    /* ************************************************************** */
    /* RHC 30/10/2019 Si todas las HPK están OK => PHR pasa a Fedateo */
    /* ************************************************************** */
    RUN PHR_Listo-para-Fedateo IN hProc (INPUT pCodOri,
                                         INPUT pNroOri,
                                         OUTPUT pMensaje).
    DELETE PROCEDURE hProc.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, LEAVE.
    /* ************************************************************** */
    /* ************************************************************** */
    

END.
IF AVAILABLE Vtacdocu THEN RELEASE Vtacdocu.
IF AVAILABLE Faccpedi THEN RELEASE Faccpedi.
IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.
IF AVAILABLE ORDEN THEN RELEASE ORDEN.
IF AVAILABLE PEDIDO THEN RELEASE PEDIDO.
IF AVAILABLE COTIZACION THEN RELEASE COTIZACION.
IF AVAILABLE Almcrepo THEN RELEASE Almcrepo.
IF pMensaje > '' THEN RETURN 'ADM-ERROR'.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Devolver-a-mesa B-table-Win 
PROCEDURE Devolver-a-mesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE ChkTareas THEN RETURN.

MESSAGE 'Desea devolver a mesa la' ChkTareas.CodDoc ChkTareas.NroPed "?"
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

DEF VAR x-Rowid AS ROWID NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.

x-Rowid = ROWID(ChkTareas).
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    {lib/lock-genericov3.i ~
        &Tabla="ChkTareas" ~
        &Condicion="ROWID(ChkTareas) = x-Rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, LEAVE"}
    IF NOT {&Condicion} THEN DO:
        pMensaje = "La tarea ya NO está pendiente de observaciones".
        UNDO, LEAVE.
    END.
    ASSIGN
        ChkTareas.FlgEst = "P"
        ChkTareas.Prioridad = "URGENTE".
    /* *********************************** */
    /* RHC 18/03/2019 Reseteamos el FlgSit */
    /* *********************************** */
    FIND Vtacdocu WHERE Vtacdocu.codcia = ChkTareas.codcia
        AND Vtacdocu.coddiv = ChkTareas.coddiv
        AND Vtacdocu.codped = ChkTareas.coddoc
        AND Vtacdocu.nroped = ChkTareas.nroped
        EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        UNDO, LEAVE.
    END.
    ASSIGN
        Vtacdocu.FlgSit = "PT".     /* Asignado a Mesa */
    RELEASE Vtacdocu.
    /* *********************************** */
    /* *********************************** */
    RELEASE ChkTareas.
END.
IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
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
    /* No actualiza los campos Progress */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir B-table-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE ChkTareas THEN RETURN.

DEF VAR s-task-no AS INT NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO INIT 0.

/* cargamos reporte */
FOR EACH Vtaddocu OF Vtacdocu NO-LOCK WHERE Vtaddocu.canped <> Vtaddocu.canpick,
    FIRST Almmmatg OF Vtaddocu NO-LOCK:
    IF s-task-no = 0 THEN REPEAT:
        s-task-no = RANDOM(1,999999).
        IF NOT CAN-FIND(w-report WHERE w-report.task-no = s-task-no NO-LOCK) THEN LEAVE.
    END.
    CREATE w-report.
    x-Item = x-Item + 1.
    ASSIGN
        w-report.task-no = s-task-no.
    ASSIGN
        w-report.Llave-I = x-Item
        w-report.Llave-C = ChkTareas.Mesa
        w-report.Campo-C[1] = ChkTareas.CodDoc
        w-report.Campo-C[2] = ChkTareas.NroPed.
    ASSIGN
        w-report.Campo-C[3] = VtaDDocu.CodMat
        w-report.Campo-C[4] = Almmmatg.DesMat 
        w-report.Campo-C[5] = Almmmatg.DesMar
        w-report.Campo-C[6] = VtaDDocu.UndVta
        w-report.Campo-F[1] = VtaDDocu.CanPed 
        w-report.Campo-F[2] = VtaDDocu.CanPick
        w-report.Campo-F[3] = VtaDDocu.CanPed - VtaDDocu.CanPick
        .
    ASSIGN
        w-report.Campo-C[7] = VtaCDocu.CodRef
        w-report.Campo-C[8] = VtaCDocu.NroRef.
    /* Chequeador  */
    FIND FIRST ChkChequeador WHERE ChkChequeador.codcia = s-codcia AND 
        ChkChequeador.coddiv = s-coddiv AND 
        chkchequeador.mesa = ChkTareas.Mesa AND
        ChkChequeador.flgest = 'A' NO-LOCK NO-ERROR.
    IF AVAILABLE ChkChequeador THEN DO:
        w-report.Campo-C[9] = chkchequeador.codper.
        DEF VAR pDNI AS CHAR.
        DEF VAR pNombre AS CHAR.
        DEF VAR pOrigen AS CHAR.
        RUN logis/p-busca-por-dni (chkchequeador.codper,
                                 OUTPUT pNombre,
                                 OUTPUT pOrigen).
        w-report.Campo-C[10] = pNombre.
    END.
    /* Picador */
    RUN logis/p-busca-por-dni (VtaCDocu.UsrSac,
                               OUTPUT pNombre,
                               OUTPUT pOrigen).
    w-report.Campo-C[11] = VtaCDocu.UsrSac + ' ' + pNombre.
    /* Ubicacion */
    FIND Almmmate WHERE Almmmate.codcia = s-codcia AND 
        Almmmate.codalm = Vtaddocu.almdes AND
        Almmmate.codmat = Vtaddocu.codmat
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmate THEN w-report.Campo-C[12] = Almmmate.CodUbi.

    RELEASE w-report.
END.
DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

GET-KEY-VALUE SECTION 'Startup' KEY 'Base'  VALUE RB-REPORT-LIBRARY.
RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + "logis/rblogis.prl".
RB-REPORT-NAME = "HPK Chequeo Observado".
RB-INCLUDE-RECORDS = "O".
RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
RUN lib/_imprime2.p (RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-OTHER-PARAMETERS).

FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.task-no = s-task-no:
    DELETE w-report.
END.






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
  {src/adm/template/snd-list.i "ChkTareas"}
  {src/adm/template/snd-list.i "VtaCDocu"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Sincera-Relacionados B-table-Win 
PROCEDURE Sincera-Relacionados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

CICLO:        
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH Vtaddocu OF Vtacdocu EXCLUSIVE-LOCK,
        FIRST Facdpedi OF ORDEN EXCLUSIVE-LOCK WHERE Facdpedi.codmat = Vtaddocu.codmat,
        FIRST Almmmatg OF Facdpedi NO-LOCK
        ON ERROR UNDO, THROW:
        /* Como las cantidades están en unidades de STOCK hay que convertirlas a unidades de VENTA */
        IF Facdpedi.CanPed <> (Vtaddocu.CanPed / Facdpedi.Factor) THEN DO:
            /* Transformadas a unidades de VENTA */
            ASSIGN
                Facdpedi.CanPed = Facdpedi.CanPed - (Vtaddocu.CanBase / Facdpedi.Factor) + (Vtaddocu.CanPed / Facdpedi.Factor).
            RUN Recalcula-Registro.
        END.
        /* OJO: Los items que están en cero se ELIMINAN */
        IF Facdpedi.CanPed <= 0 THEN DO:
            DELETE Facdpedi.    /* OJO */
        END.
        /* ******************************************** */
    END.
    IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.
    CASE ORDEN.CodDoc:
        WHEN "O/D" OR WHEN "O/M" THEN DO:
            RUN Graba-Totales ( ROWID(ORDEN) ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                pMensaje = "NO se pudo actualizar el documento: " + ORDEN.coddoc + " " + ORDEN.nroped.
                UNDO CICLO, LEAVE.
            END.
            /* Actualizamos Saldo del Pedido */
            FIND FIRST PEDIDO WHERE PEDIDO.codcia = ORDEN.codcia
                AND PEDIDO.coddoc = ORDEN.codref
                AND PEDIDO.nroped = ORDEN.nroref
                NO-LOCK NO-ERROR.
            FOR EACH Vtaddocu OF Vtacdocu NO-LOCK,
                FIRST Facdpedi OF PEDIDO EXCLUSIVE-LOCK WHERE Facdpedi.codmat = Vtaddocu.codmat
                ON ERROR UNDO, THROW:
                ASSIGN
                    Facdpedi.CanPed = (Vtaddocu.CanPed / Facdpedi.Factor)
                    Facdpedi.CanAte = (Vtaddocu.CanPed / Facdpedi.Factor)
                    Facdpedi.CanPick = (Vtaddocu.CanPed / Facdpedi.Factor).
                RUN Recalcula-Registro.
                IF Facdpedi.CanPed <= 0 THEN DELETE Facdpedi.   /* OJO */
            END.
            IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.
            RUN Graba-Totales ( ROWID(PEDIDO) ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                pMensaje = "NO se pudo actualizar el documento: " + PEDIDO.coddoc + " " + PEDIDO.nroped.
                UNDO CICLO, LEAVE CICLO.
            END.
            /* Actualizamos Saldo de la Cotización */
            IF Vtacdocu.CodRef = 'O/D' THEN DO:
                FOR EACH Vtaddocu OF Vtacdocu NO-LOCK WHERE Vtaddocu.Libre_c05 <> "OF",
                    FIRST Facdpedi OF COTIZACION EXCLUSIVE-LOCK WHERE Facdpedi.codmat = Vtaddocu.codmat
                    ON ERROR UNDO, THROW:
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
                        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
                        UNDO CICLO, LEAVE CICLO.
                    END.
                    DELETE DI-RutaD.
                END.
            END.
        END.
    END CASE.
END.
RETURN 'OK'.

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

