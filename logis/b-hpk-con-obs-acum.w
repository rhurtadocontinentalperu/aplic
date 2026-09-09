&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER b-VtaCDocu FOR VtaCDocu.
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEFINE SHARED VARIABLE S-TPOPED   AS CHAR.
/* s-TpoPed:
    ACUMULATIVO
    RACK,ESTANTERIA
    */
&SCOPED-DEFINE Condicion ( LOOKUP(VtaCDocu.CodTer, s-TpoPed) > 0 ~
    AND VtaCDocu.CodCia = s-CodCia ~
    AND VtaCDocu.CodDiv = s-CodDiv ~
    AND VtaCDocu.CodPed = 'HPK' ~
    AND VtaCDocu.FlgEst = "P" ~
    AND VtaCDocu.FlgSit = "TX" )    /*TX*/

DEF VAR pError AS CHAR NO-UNDO.

DEF VAR x-Articulo-ICBPer AS CHAR INIT '099268'.

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
&Scoped-define INTERNAL-TABLES VtaCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtaCDocu.CodTer VtaCDocu.CodPed ~
VtaCDocu.NroPed VtaCDocu.CodOri VtaCDocu.NroOri VtaCDocu.CodRef ~
VtaCDocu.NroRef 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH VtaCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH VtaCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table VtaCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table VtaCDocu


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
      VtaCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtaCDocu.CodTer COLUMN-LABEL "Tipo" FORMAT "x(15)":U
      VtaCDocu.CodPed FORMAT "x(3)":U
      VtaCDocu.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U WIDTH 13
      VtaCDocu.CodOri COLUMN-LABEL "Refer." FORMAT "x(3)":U
      VtaCDocu.NroOri COLUMN-LABEL "Numero" FORMAT "x(15)":U
      VtaCDocu.CodRef FORMAT "x(3)":U
      VtaCDocu.NroRef COLUMN-LABEL "Referencia" FORMAT "X(15)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 67 BY 6.69
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
      TABLE: B-DPEDI B "?" ? INTEGRAL FacDPedi
      TABLE: b-VtaCDocu B "?" ? INTEGRAL VtaCDocu
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
         HEIGHT             = 6.69
         WIDTH              = 74.
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
     _TblList          = "INTEGRAL.VtaCDocu"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > INTEGRAL.VtaCDocu.CodTer
"VtaCDocu.CodTer" "Tipo" "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.VtaCDocu.CodPed
     _FldNameList[3]   > INTEGRAL.VtaCDocu.NroPed
"VtaCDocu.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaCDocu.CodOri
"VtaCDocu.CodOri" "Refer." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.VtaCDocu.NroOri
"VtaCDocu.NroOri" "Numero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.VtaCDocu.CodRef
     _FldNameList[7]   > INTEGRAL.VtaCDocu.NroRef
"VtaCDocu.NroRef" "Referencia" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
  Notes:       
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

{logis/i-hpk-con-obs.i &Control-RA="{&Otros-RA}" &Control-COT="{&Otros-COT}" &Control-PED="{&Otros-PED}"}

RETURN 'OK'.

/*
&SCOPED-DEFINE Otros-RA ~
FOR EACH Facdpedi OF ORDEN NO-LOCK, ~
    FIRST Vtaddocu OF Vtacdocu NO-LOCK WHERE Vtaddocu.codmat = Facdpedi.codmat, ~
    FIRST Almdrepo OF Almcrepo EXCLUSIVE-LOCK WHERE Almdrepo.codmat = Facdpedi.codmat ~
    ON ERROR UNDO, THROW: ~
    ASSIGN ~
        Almdrepo.CanAte = Almdrepo.CanAte - Facdpedi.CanPed + (Vtaddocu.CanPed / Facdpedi.Factor). ~
END.

&SCOPED-DEFINE Otros-COT ~
FOR EACH Facdpedi OF ORDEN NO-LOCK, ~
    FIRST Vtaddocu OF Vtacdocu NO-LOCK WHERE Vtaddocu.codmat = Facdpedi.codmat, ~
    FIRST B-DPEDI OF COTIZACION EXCLUSIVE-LOCK WHERE B-DPEDI.codmat = Facdpedi.codmat ~
    ON ERROR UNDO, THROW: ~
    ASSIGN ~
        B-DPEDI.CanAte = B-DPEDI.CanAte - Facdpedi.CanPed + (Vtaddocu.CanPed / B-DPEDI.Factor). ~
END.
&SCOPED-DEFINE Otros-PED ~
FOR EACH Facdpedi OF ORDEN NO-LOCK, ~
    FIRST Vtaddocu OF Vtacdocu NO-LOCK WHERE Vtaddocu.codmat = Facdpedi.codmat, ~
    FIRST B-DPEDI OF PEDIDO EXCLUSIVE-LOCK WHERE B-DPEDI.codmat = Facdpedi.codmat: ~
    ASSIGN ~
        B-DPEDI.CanPed = (Vtaddocu.CanPed / B-DPEDI.Factor)~
        B-DPEDI.CanAte = (Vtaddocu.CanPed / B-DPEDI.Factor). ~
    IF B-DPEDI.CanPed <= 0 THEN DELETE B-DPEDI. ~
END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Relacionados-Acum B-table-Win 
PROCEDURE Actualiza-Relacionados-Acum :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&SCOPED-DEFINE Acum-RA ~
FOR EACH Facdpedi OF ORDEN NO-LOCK, ~
    FIRST Almddocu NO-LOCK WHERE Almddocu.codcia = ORDEN.codcia AND ~
        Almddocu.codllave = Vtacdocu.codped + ',' + Vtacdocu.nroped AND ~
        Almddocu.coddoc = ORDEN.coddoc AND ~
        Almddocu.nrodoc = ORDEN.nroped AND ~
        Almddocu.codigo = Facdpedi.codmat, ~
    FIRST Almdrepo OF Almcrepo EXCLUSIVE-LOCK WHERE Almdrepo.codmat = Facdpedi.codmat ~
    ON ERROR UNDO, THROW: ~
    ASSIGN ~
        Almdrepo.CanAte = Almdrepo.CanAte - Facdpedi.CanPed + (AlmDDocu.Libre_d01 / Facdpedi.Factor). ~
END.

&SCOPED-DEFINE Acum-COT ~
FOR EACH Facdpedi OF ORDEN NO-LOCK, ~
    FIRST Almddocu NO-LOCK WHERE Almddocu.codcia = ORDEN.codcia AND ~
        Almddocu.codllave = Vtacdocu.codped + ',' + Vtacdocu.nroped AND ~
        Almddocu.coddoc = ORDEN.coddoc AND ~
        Almddocu.nrodoc = ORDEN.nroped AND ~
        Almddocu.codigo = Facdpedi.codmat, ~
    FIRST B-DPEDI OF COTIZACION EXCLUSIVE-LOCK WHERE B-DPEDI.codmat = Facdpedi.codmat ~
    ON ERROR UNDO, THROW: ~
        MESSAGE 'detalle1' almddocu.codigo almddocu.libre_d01.  ~
    ASSIGN ~
        B-DPEDI.CanAte = B-DPEDI.CanAte - Facdpedi.CanPed + (AlmDDocu.Libre_d01 / B-DPEDI.Factor). ~
END.

&SCOPED-DEFINE Acum-PED ~
FOR EACH Facdpedi OF ORDEN NO-LOCK, ~
    FIRST Almddocu NO-LOCK WHERE Almddocu.codcia = ORDEN.codcia AND ~
        Almddocu.codllave = Vtacdocu.codped + ',' + Vtacdocu.nroped AND ~
        Almddocu.coddoc = ORDEN.coddoc AND ~
        Almddocu.nrodoc = ORDEN.nroped AND ~
        Almddocu.codigo = Facdpedi.codmat, ~
    FIRST B-DPEDI OF PEDIDO EXCLUSIVE-LOCK WHERE B-DPEDI.codmat = Facdpedi.codmat ~
    ON ERROR UNDO, THROW: ~
        MESSAGE 'detalle2' almddocu.codigo almddocu.libre_d01.  ~
        ASSIGN ~
        B-DPEDI.CanPed = (AlmDDocu.Libre_d01 / B-DPEDI.Factor)~
        B-DPEDI.CanAte = (AlmDDocu.Libre_d01 / B-DPEDI.Factor). ~
    IF B-DPEDI.CanPed <= 0 THEN DELETE B-DPEDI. ~
END.

{logis/i-hpk-con-obs.i &Control-RA="{&Acum-RA}" &Control-COT="{&Acum-COT}" &Control-PED="{&Acum-PED}"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cerrar-Acumulativo B-table-Win 
PROCEDURE Cerrar-Acumulativo PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-CodODS AS CHAR EXTENT 100 NO-UNDO.                                                                    
DEF VAR x-NroODS AS CHAR EXTENT 100 NO-UNDO.                                                                    
DEF VAR x-Items  AS INTE NO-UNDO.
DEF VAR k AS INTE NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
pError = "".  
CICLO:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    x-NroODS = ''.
    x-Items = 0.
    /* Una HPK tiene relacionada varios O/D */
    FOR EACH AlmDDocu NO-LOCK WHERE AlmDDocu.CodCia = VtaCDocu.CodCia AND
        AlmDDocu.CodLlave = VtaCDocu.CodPed + ',' + VtaCDocu.NroPed
        BREAK BY AlmDDocu.CodDoc BY AlmDDocu.NroDoc:
        IF FIRST-OF(AlmDDocu.CodDoc) OR FIRST-OF(AlmDDocu.NroDoc) THEN DO:
            x-Items = x-Items + 1.
            x-CodODS[x-Items] = AlmDDocu.CodDoc.
            x-NroODS[x-Items] = AlmDDocu.NroDoc.
        END.
    END.
    IF x-Items = 0 THEN LEAVE.
    /* Barremos c/u de los documentos */
    DO k = 1 TO x-Items:
        /* Actualizamos los documentos originales */
        {lib/lock-genericov3.i ~
            &Tabla="ORDEN" ~
            &Alcance="FIRST" ~
            &Condicion="ORDEN.codcia = s-CodCia ~
            AND ORDEN.coddoc = x-CodODS[k] ~        /* <<< OJO <<< */
            AND ORDEN.nroped = x-NroODS[k]" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="YES" ~
            &txtMensaje="pError" ~
            &TipoError="UNDO CICLO, LEAVE CICLO" ~
            &Intentos=5 ~
            }
        /* Actualizamos el detalle */
        RUN Actualiza-Relacionados-Acum.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO CICLO, LEAVE CICLO.
        /* *********************** */
        FOR EACH Facdpedi OF ORDEN EXCLUSIVE-LOCK,
            FIRST Almmmatg OF Facdpedi NO-LOCK,
            FIRST Almddocu NO-LOCK WHERE Almddocu.codcia = ORDEN.codcia AND 
                Almddocu.codllave = Vtacdocu.codped + ',' + Vtacdocu.nroped AND 
                Almddocu.coddoc = ORDEN.coddoc AND 
                Almddocu.nrodoc = ORDEN.nroped AND 
                Almddocu.codigo = Facdpedi.codmat
            ON ERROR UNDO, THROW:
            /* Como las cantidades están en unidades de STOCK hay que convertirlas a unidades de VENTA */
            IF Facdpedi.CanPed <> (AlmDDocu.Libre_d01 / Facdpedi.Factor) THEN DO:
                /* Transformadas a unidades de VENTA */
                ASSIGN
                    Facdpedi.CanPed = (AlmDDocu.Libre_d01 / Facdpedi.Factor).
                RUN Recalcula-Registro.
            END.
            /* OJO: Los items que están en cero se ELIMINAN */
            IF Facdpedi.CanPed <= 0 THEN DO:
                DELETE Facdpedi.    /* OJO */
            END.
            /* ******************************************** */
        END.
        IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.

        /* RHC 20/01/2018 Si no quedan items NO permitir cerrar */
        FIND FIRST Facdpedi OF ORDEN NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Facdpedi THEN DO:
            pError = "NO se puede eliminar TODOS los items del documento " + ORDEN.CodDoc + " " + ORDEN.NroPed + CHR(10) +
                "Favor de eliminar la orden COMPLETA" + CHR(10) +
                "Proceso Abortado".
            UNDO CICLO, LEAVE CICLO.
        END.
        /* **************************************************** */
        CASE ORDEN.CodDoc:
            WHEN "O/D" OR WHEN "O/M" THEN DO:
                RUN Graba-Totales ( ROWID(ORDEN) ).
                IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                    pError = "NO se pudo actualizar el documento: " + ORDEN.coddoc + " " + ORDEN.nroped.
                    UNDO CICLO, LEAVE.
                END.
                /* Actualizamos Saldo del Pedido */
                FIND FIRST PEDIDO WHERE PEDIDO.codcia = ORDEN.codcia
                    AND PEDIDO.coddoc = ORDEN.codref
                    AND PEDIDO.nroped = ORDEN.nroref
                    NO-LOCK NO-ERROR.
                FOR EACH Facdpedi OF PEDIDO EXCLUSIVE-LOCK,
                    FIRST Almddocu NO-LOCK WHERE Almddocu.codcia = ORDEN.codcia AND 
                        Almddocu.codllave = Vtacdocu.codped + ',' + Vtacdocu.nroped AND 
                        Almddocu.coddoc = ORDEN.coddoc AND 
                        Almddocu.nrodoc = ORDEN.nroped AND 
                        Almddocu.codigo = Facdpedi.codmat
                    ON ERROR UNDO, THROW:
                    ASSIGN
                        Facdpedi.CanPed = (Almddocu.Libre_d01 / Facdpedi.Factor)
                        Facdpedi.CanAte = (Almddocu.Libre_d01 / Facdpedi.Factor)
                        Facdpedi.CanPick = (Almddocu.Libre_d01 / Facdpedi.Factor).
                    IF Facdpedi.CanPed <= 0 THEN DELETE Facdpedi.   /* OJO */
                END.
                IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.
                RUN Graba-Totales ( ROWID(PEDIDO) ).
                IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                    pError = "NO se pudo actualizar el documento: " + PEDIDO.coddoc + " " + PEDIDO.nroped.
                    UNDO CICLO, LEAVE CICLO.
                END.
                /* Actualizamos Saldo de la Cotización */
                IF ORDEN.CodDoc = 'O/D' THEN DO:
                    FOR EACH Facdpedi OF COTIZACION EXCLUSIVE-LOCK,
                        FIRST Almddocu NO-LOCK WHERE Almddocu.codcia = ORDEN.codcia AND 
                        Almddocu.codllave = Vtacdocu.codped + ',' + Vtacdocu.nroped AND 
                        Almddocu.coddoc = ORDEN.coddoc AND 
                        Almddocu.nrodoc = ORDEN.nroped AND 
                        Almddocu.codigo = Facdpedi.codmat
                        ON ERROR UNDO, THROW:
                        ASSIGN
                            Facdpedi.CanAte = Facdpedi.CanAte - (Almddocu.Libre_d03 / Facdpedi.Factor) + (Almddocu.Libre_d01 / Facdpedi.Factor).
                    END.
                    IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.
                    IF CAN-FIND(FIRST Facdpedi OF COTIZACION WHERE Facdpedi.CanPed > Facdpedi.CanAte NO-LOCK)
                        THEN COTIZACION.FlgEst = "P".
                    ELSE COTIZACION.FlgEst = "C".
                END.
            END.
            WHEN "OTR" THEN DO:
                /* OJO: Si NO tiene items entonces ANULAR la OTR */
                IF NOT CAN-FIND(FIRST Facdpedi OF ORDEN NO-LOCK) THEN ORDEN.FlgEst = "A".
            END.
        END CASE.
    END.
    ASSIGN 
        Vtacdocu.FlgSit = "P"
        Vtacdocu.Libre_c03 = s-user-id + '|' + STRING(NOW, '99/99/9999 HH:MM:SS') + '|' + Vtacdocu.usrsac
        Vtacdocu.usrsacrecep = s-user-id
        Vtacdocu.fchfin = NOW
        Vtacdocu.usuariofin = s-user-id.
    FOR EACH Vtaddocu OF Vtacdocu EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
        /* OJO: Actualizamos la cantidad base */
        ASSIGN 
            Vtaddocu.CanBase = Vtaddocu.CanPed.
        /* OJO: Los items que están en cero se ELIMINAN */
        IF Vtaddocu.CanPed <= 0 THEN DO:
            DELETE Vtaddocu.    /* OJO */
        END.
    END.
    FOR EACH Almddocu WHERE AlmDDocu.CodCia = Vtacdocu.CodCia AND
        AlmDDocu.CodLlave = Vtacdocu.codped + ',' + Vtacdocu.nroped
        EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
        /* OJO: Actualizamos la cantidad base */
        ASSIGN 
            AlmDDocu.Libre_d03 = AlmDDocu.Libre_d01.
        /* OJO: Los items que están en cero se ELIMINAN */
        IF AlmDDocu.Libre_d01 <= 0 THEN DO:
            DELETE AlmDDocu.    /* OJO */
        END.
    END.
    /* Intenta cerra la PHR */
    RUN logis/p-cierra-pik-phr (INPUT VtaCDocu.CodPed,
                                INPUT VtaCDocu.CodDiv,
                                INPUT VtaCDocu.CodOri,
                                INPUT VtaCDocu.NroOri,
                                OUTPUT pError).
    IF pError > '' THEN UNDO, LEAVE.

    /* RHC 29/01/2019 BUSCAMOS SI AUN LA O/D ESTA EN LA PHR */
    /* Barremos c/u de los documentos */
    DEF VAR pFound AS LOG NO-UNDO.
    DEF VAR pCodOri AS CHAR NO-UNDO.
    DEF VAR pNroOri AS CHAR NO-UNDO.
    ASSIGN
        pCodOri = VtaCDocu.CodOri
        pNroOri = VtaCDocu.NroOri.
    DO k = 1 TO x-Items:
        /* Actualizamos los documentos originales */
        FIND FIRST ORDEN WHERE ORDEN.codcia = s-CodCia 
            AND ORDEN.coddoc = x-CodODS[k]         /* <<< OJO <<< */
            AND ORDEN.nroped = x-NroODS[k]
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pError"}
            UNDO CICLO, LEAVE.
        END.
        RUN Busca-Orden (INPUT pCodOri,         /* PHR */
                         INPUT pNroOri,
                         INPUT ORDEN.CodDoc,    /* O/D */
                         INPUT ORDEN.NroPed,
                         OUTPUT pFound).
        IF pFound = NO THEN ORDEN.FlgSit = "T".     /* Regresa a su modo original */
    END.
END.
IF AVAILABLE Vtacdocu THEN RELEASE Vtacdocu.
IF AVAILABLE Faccpedi THEN RELEASE Faccpedi.
IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.
IF AVAILABLE ORDEN    THEN RELEASE ORDEN.
IF AVAILABLE PEDIDO   THEN RELEASE ORDEN.
IF AVAILABLE COTIZACION THEN RELEASE COTIZACION.
SESSION:SET-WAIT-STATE('').
IF pError > '' THEN RETURN 'ADM-ERROR'.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cerrar-Otros B-table-Win 
PROCEDURE Cerrar-Otros PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* OJO:
    Como hay un proceso mas que modifica la cantidad pedida entonces
    arrastramos la cantidad final en el campo Vtaddocu.CanBase
    
*/    

DEFINE VARIABLE x-NroRef AS CHAR NO-UNDO.
              
DEF VAR pCuentaError AS INT NO-UNDO.

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
    /* Actualizamos el detalle */
    /* ************************************************************************ */
    /* POSICIONA EL PUNTERO EN EL PEDIDO Y LA COTIZACION EN MODO EXCLUSIVE-LOCK */
    /* ************************************************************************ */
    RUN Actualiza-Relacionados.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, LEAVE.
    
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
        DEF VAR x-CanPed AS DEC NO-UNDO.
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
                                        STRING(Facdpedi.CanPed).
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
    /* RHC 20/01/2018 Si no quedan items NO permitir cerrar */
    /* RHC 30/07/2019 Bloqueado a solicitu de M.R. */
/*     FIND FIRST Facdpedi OF ORDEN NO-LOCK NO-ERROR.                  */
/*     IF NOT AVAILABLE Facdpedi THEN DO:                              */
/*         pError = "NO se puede eliminar TODOS los items" + CHR(10) + */
/*             "Favor de eliminar la orden COMPLETA".                  */
/*         UNDO CICLO, LEAVE.                                          */
/*     END.                                                            */
    /* **************************************************** */
    CASE ORDEN.CodDoc:
        WHEN "O/D" OR WHEN "O/M" THEN DO:
            RUN Graba-Totales ( ROWID(ORDEN) ).
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
            RUN Graba-Totales ( ROWID(PEDIDO) ).
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
/*IF AVAILABLE Vtacdocu THEN RELEASE Vtacdocu.*/
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

IF NOT AVAILABLE Vtacdocu THEN RETURN.

/* RHC 30/07/2019 */
IF NOT CAN-FIND(FIRST Vtaddocu OF Vtacdocu WHERE Vtaddocu.CanPed > 0 NO-LOCK)
    THEN DO:
    MESSAGE 'NO ha ingresado nada en CANTIDAD PICKEADA' SKIP
        'Se va a anular la HPK' SKIP
        'Continuamos con el cierre?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN.
END.

MESSAGE 'Cerramos la tarea?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta-2 AS LOG.
IF rpta-2 = NO THEN RETURN.

FIND CURRENT Vtacdocu NO-LOCK NO-ERROR.
IF NOT {&Condicion} THEN DO:
    MESSAGE 'El documento YA no está observada' VIEW-AS ALERT-BOX WARNING.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RETURN.
END.

DEFINE BUFFER b-vtacdocu FOR Vtacdocu.
DEFINE BUFFER B-DPEDI    FOR Facdpedi.

DEFINE VARIABLE x-NroRef AS CHAR NO-UNDO.
DEFINE VARIABLE x-Rowid  AS ROWID NO-UNDO.

pError = "".
x-Rowid = ROWID(Vtacdocu).
CICLO:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    {lib/lock-genericov3.i ~
        &Tabla="Vtacdocu" ~
        &Condicion="ROWID(Vtacdocu) = x-Rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pError" ~
        &TipoError="UNDO, LEAVE"}
    IF NOT {&Condicion} THEN DO:
        pError = 'La sub-orden YA no está observada'.
        UNDO, LEAVE.
    END.
    /* Cada HPK relaciona a una sola O/D */
    RUN Cerrar-Otros.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, LEAVE.
END.
IF AVAILABLE(Faccpedi)   THEN RELEASE Faccpedi.
IF AVAILABLE(ORDEN)      THEN RELEASE ORDEN.
IF AVAILABLE(COTIZACION) THEN RELEASE COTIZACION.
IF AVAILABLE(b-vtacdocu) THEN RELEASE b-vtacdocu.
IF pError > '' THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

/* *************************************************************************** */
/* ALERTA */
/* *************************************************************************** */
FIND Vtacdocu WHERE ROWID(Vtacdocu) = x-Rowid NO-LOCK.
RUN logis/d-alerta-phr-reasign (Vtacdocu.CodPed, Vtacdocu.NroPed).
/* *************************************************************************** */
/* *************************************************************************** */

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

{lib/lock-genericov3.i &Tabla="Faccpedi" ~
        &Condicion="ROWID(Faccpedi) = pRowid" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Modificar B-table-Win 
PROCEDURE Modificar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Vtacdocu THEN RETURN.

DEF VAR x-Rowid AS ROWID NO-UNDO.

x-Rowid = ROWID(VtaCDocu).
RUN logis/d-hpk-con-observ-v2 (INPUT ROWID(VtaCDocu)).

RUN dispatch IN THIS-PROCEDURE ('open-query':U).
REPOSITION {&BROWSE-NAME} TO ROWID x-Rowid NO-ERROR.
IF ERROR-STATUS:ERROR = NO THEN RUN dispatch IN THIS-PROCEDURE ('row-changed':U).

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
  Notes:       El flete ya está aplicado en el PreUni
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
  {src/adm/template/snd-list.i "VtaCDocu"}

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

