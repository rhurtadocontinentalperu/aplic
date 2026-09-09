&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-DPEDI FOR FacDPedi.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER ORDEN FOR FacCPedi.
DEFINE TEMP-TABLE PEDI NO-UNDO LIKE FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
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

&SCOPED-DEFINE Condicion (VtaCDocu.CodCia = s-codcia ~
 AND VtaCDocu.DivDes = s-coddiv ~
 AND (VtaCDocu.CodPed = "O/D" ~
  OR VtaCDocu.CodPed = "O/M" ~
  OR VtaCDocu.CodPed = "OTR")  ~
 AND VtaCDocu.FlgEst = "P" ~
 AND VtaCDocu.FlgSit = "X")

     DEFINE VARIABLE pError AS CHAR NO-UNDO.

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
&Scoped-define INTERNAL-TABLES VtaCDocu T-VtaCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtaCDocu.CodPed VtaCDocu.NroPed ~
VtaCDocu.FchPed VtaCDocu.CodCli VtaCDocu.NomCli 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH VtaCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST T-VtaCDocu OF VtaCDocu NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH VtaCDocu WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST T-VtaCDocu OF VtaCDocu NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table VtaCDocu T-VtaCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table VtaCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-br_table T-VtaCDocu


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
      VtaCDocu, 
      T-VtaCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtaCDocu.CodPed FORMAT "x(3)":U
      VtaCDocu.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U WIDTH 12.57
      VtaCDocu.FchPed COLUMN-LABEL "Fecha" FORMAT "99/99/99":U
            WIDTH 8
      VtaCDocu.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U WIDTH 11.29
      VtaCDocu.NomCli FORMAT "x(60)":U WIDTH 47.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 91 BY 6.69
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
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: ORDEN B "?" ? INTEGRAL FacCPedi
      TABLE: PEDI T "?" NO-UNDO INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
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
         HEIGHT             = 6.85
         WIDTH              = 104.
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
     _TblList          = "INTEGRAL.VtaCDocu,Temp-Tables.T-VtaCDocu OF INTEGRAL.VtaCDocu"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   = INTEGRAL.VtaCDocu.CodPed
     _FldNameList[2]   > INTEGRAL.VtaCDocu.NroPed
"VtaCDocu.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "12.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.VtaCDocu.FchPed
"VtaCDocu.FchPed" "Fecha" ? "date" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaCDocu.CodCli
"VtaCDocu.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "11.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.VtaCDocu.NomCli
"VtaCDocu.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "47.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

CICLO:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CASE ORDEN.CodDoc:
        /* CONTROL DE ORDENES DE DESPACHO */
        WHEN "O/D" OR WHEN "O/M" THEN DO:
            /* POSICIONAMOS PUNTEROS DEL PEDIDO Y COTIZACION */
            /* RHC 19/02/2018 En caso de Cross Docking x Cliente el origen está en otra división */
            FIND FIRST PEDIDO WHERE PEDIDO.codcia = ORDEN.codcia
                /*AND PEDIDO.coddiv = ORDEN.coddiv*/
                AND PEDIDO.coddoc = ORDEN.codref
                AND PEDIDO.nroped = ORDEN.nroref
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE PEDIDO THEN DO:
                pError = "NO se pudo bloquear el " + ORDEN.codref + " " + ORDEN.nroref +
                    CHR(10) + ERROR-STATUS:GET-MESSAGE(1).
                UNDO CICLO, RETURN 'ADM-ERROR'.
            END.
            IF Vtacdocu.CodPed = 'O/D' THEN DO:
                FIND FIRST COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
                    AND COTIZACION.coddiv = PEDIDO.coddiv
                    AND COTIZACION.coddoc = PEDIDO.codref
                    AND COTIZACION.nroped = PEDIDO.nroref
                    EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE COTIZACION THEN DO:
                    pError = "NO se pudo bloquear la cotización " + PEDIDO.codref + " " + PEDIDO.nroref +
                        CHR(10) + ERROR-STATUS:GET-MESSAGE(1).
                    UNDO CICLO, RETURN 'ADM-ERROR'.
                END.
            END.
        END.
        /* CONTROL ORDENES DE TRANSFERENCIA */
        WHEN "OTR" THEN DO:
            /* DOS TIPOS: POR REPOSICION AUTOMATICA (R/A) O POR CROSS DOCKING CLIENTES (PED) */
            CASE ORDEN.CodRef:
                /* POR REPOSICION AUTOMATICA */
                WHEN "R/A" THEN DO:
                    /* Buscamos la R/A base */
                    /* **************************************************************** */
                    /* RHC 12/01/2018 Si no la encuentra puede que sea un Cross Docking */
                    /* **************************************************************** */
                    IF ORDEN.CrossDocking = YES THEN DO:
                        FIND FIRST Almcrepo WHERE almcrepo.CodCia = ORDEN.codcia
                            AND almcrepo.CodAlm = ORDEN.AlmacenXD
                            AND almcrepo.NroSer = INT(SUBSTRING(ORDEN.nroref,1,3))
                            AND almcrepo.NroDoc = INT(SUBSTRING(ORDEN.nroref,4))
                            NO-LOCK NO-ERROR.
                    END.
                    ELSE DO:
                        FIND FIRST Almcrepo WHERE almcrepo.CodCia = ORDEN.codcia
                            AND almcrepo.CodAlm = ORDEN.CodCli
                            AND almcrepo.NroSer = INT(SUBSTRING(ORDEN.nroref,1,3))
                            AND almcrepo.NroDoc = INT(SUBSTRING(ORDEN.nroref,4))
                            NO-LOCK NO-ERROR.
                    END.
                    /* **************************************************************** */
                    IF NOT AVAILABLE Almcrepo THEN DO:
                        pError = "NO se pudo bloquear la R/A " + ORDEN.nroref +
                            CHR(10) + ERROR-STATUS:GET-MESSAGE(1).
                        UNDO CICLO, RETURN 'ADM-ERROR'.
                    END.
                    /* Extornamos la cantidad atendida en la R/A */
                    FOR EACH Vtaddocu OF Vtacdocu NO-LOCK,
                        FIRST Facdpedi OF ORDEN NO-LOCK WHERE Facdpedi.codmat = Vtaddocu.codmat,
                        FIRST Almdrepo OF Almcrepo EXCLUSIVE-LOCK WHERE Almdrepo.codmat = Vtaddocu.codmat:
/*                         FIND Almdrepo OF Almcrepo EXCLUSIVE-LOCK WHERE Almdrepo.codmat = Vtaddocu.codmat   */
/*                             EXCLUSIVE-LOCK NO-ERROR NO-WAIT.                                               */
/*                         IF NOT AVAILABLE Almdrepo THEN DO:                                                 */
/*                             pError = "NO se pudo extornar la R/A, artículo " + Vtaddocu.codmat + CHR(10) + */
/*                                 "Documento: " + ORDEN.coddoc + " " + ORDEN.nroped +                        */
/*                                 CHR(10) + ERROR-STATUS:GET-MESSAGE(1).                                     */
/*                             UNDO CICLO, RETURN 'ADM-ERROR'.                                                */
/*                         END.                                                                               */
                        ASSIGN
                            Almdrepo.CanAte = Almdrepo.CanAte - Facdpedi.CanPed + Vtaddocu.CanPed.
                    END.
                    IF AVAILABLE Almdrepo THEN RELEASE Almdrepo.
                END.
                /* POR CROSS DOCKING CLIENTES */
                WHEN "PED" THEN DO:
                    /* ACTUALIZAMOS PEDIDOS Y COTIZACIONES */
                    FIND FIRST PEDIDO WHERE PEDIDO.codcia = ORDEN.codcia
                        AND PEDIDO.coddoc = ORDEN.codref
                        AND PEDIDO.nroped = ORDEN.nroref
                        EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE PEDIDO THEN DO:
                        pError = "NO se pudo bloquear el " + ORDEN.codref + " " + ORDEN.nroref +
                            CHR(10) + ERROR-STATUS:GET-MESSAGE(1).
                        UNDO CICLO, RETURN 'ADM-ERROR'.
                    END.
                    FIND FIRST COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
                        AND COTIZACION.coddiv = PEDIDO.coddiv
                        AND COTIZACION.coddoc = PEDIDO.codref
                        AND COTIZACION.nroped = PEDIDO.nroref
                        EXCLUSIVE-LOCK NO-ERROR.
                    IF NOT AVAILABLE COTIZACION THEN DO:
                        pError = "NO se pudo bloquear la cotización " + PEDIDO.codref + " " + PEDIDO.nroref +
                            CHR(10) + ERROR-STATUS:GET-MESSAGE(1).
                        UNDO CICLO, RETURN 'ADM-ERROR'.
                    END.
                    FOR EACH Vtaddocu OF Vtacdocu NO-LOCK,
                        EACH Facdpedi OF ORDEN WHERE Facdpedi.CodMat = Vtaddocu.CodMat,
                        FIRST B-DPEDI OF COTIZACION EXCLUSIVE-LOCK WHERE B-DPEDI.codmat = Vtaddocu.codmat:
/*                         FIND B-DPEDI OF COTIZACION WHERE B-DPEDI.codmat = Vtaddocu.codmat                  */
/*                             EXCLUSIVE-LOCK NO-ERROR NO-WAIT.                                               */
/*                         IF NOT AVAILABLE B-DPEDI THEN DO:                                                  */
/*                             pError = "NO se pudo extornar la COT, artículo " + Vtaddocu.codmat + CHR(10) + */
/*                                 "Documento: " + ORDEN.coddoc + " " + ORDEN.nroped +                        */
/*                                 CHR(10) + ERROR-STATUS:GET-MESSAGE(1).                                     */
/*                             UNDO CICLO, RETURN 'ADM-ERROR'.                                                */
/*                         END.                                                                               */
                        ASSIGN
                            B-DPEDI.CanAte = B-DPEDI.CanAte - Facdpedi.CanPed + Vtaddocu.CanPed.
                    END.
                    ASSIGN
                        COTIZACION.FlgEst = "C".
                    IF CAN-FIND(FIRST Facdpedi OF COTIZACION WHERE Facdpedi.CanPed > Facdpedi.CanAte NO-LOCK)
                        THEN COTIZACION.FlgEst = "P".
                    FOR EACH Vtaddocu OF Vtacdocu NO-LOCK,
                        EACH Facdpedi OF ORDEN WHERE Facdpedi.CodMat = Vtaddocu.CodMat,
                        FIRST B-DPEDI OF PEDIDO EXCLUSIVE-LOCK WHERE B-DPEDI.codmat = Vtaddocu.codmat:
/*                         FIND B-DPEDI OF PEDIDO WHERE B-DPEDI.codmat = Vtaddocu.codmat                      */
/*                             EXCLUSIVE-LOCK NO-ERROR NO-WAIT.                                               */
/*                         IF NOT AVAILABLE B-DPEDI THEN DO:                                                  */
/*                             pError = "NO se pudo extornar el PED, artículo " + Vtaddocu.codmat + CHR(10) + */
/*                                 "Documento: " + ORDEN.coddoc + " " + ORDEN.nroped +                        */
/*                                 CHR(10) + ERROR-STATUS:GET-MESSAGE(1).                                     */
/*                             UNDO CICLO, RETURN 'ADM-ERROR'.                                                */
/*                         END.                                                                               */
                        ASSIGN
                            B-DPEDI.CanPed = Vtaddocu.CanPed
                            B-DPEDI.CanAte = Vtaddocu.CanPed.
                        IF B-DPEDI.CanPed <= 0 THEN DELETE B-DPEDI.
                    END.
                END.
            END CASE.
        END.
    END CASE.
END.
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

DEFINE BUFFER REPOSICION FOR Almcrepo.
DEFINE BUFFER b-vtacdocu FOR Vtacdocu.
DEFINE BUFFER B-DPEDI    FOR Facdpedi.

DEFINE VARIABLE x-NroRef AS CHAR NO-UNDO.
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
    {lib/lock-genericov3.i ~
        &Tabla="ORDEN" ~
        &Alcance="FIRST" ~
        &Condicion="ORDEN.codcia = Vtacdocu.codcia ~
        AND ORDEN.coddiv = Vtacdocu.coddiv ~
        AND ORDEN.coddoc = Vtacdocu.codped ~
        AND ORDEN.nroped = ENTRY(1,Vtacdocu.nroped,'-')" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &txtMensaje="pError" ~
        &TipoError="UNDO CICLO, LEAVE CICLO " ~
        &Intentos=5 ~
        }
    /* Actualizamos el detalle */
    RUN Actualiza-Relacionados.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, LEAVE.
    /* *********************** */
    DEF VAR x-CanPed AS DEC NO-UNDO.
    FOR EACH Vtaddocu OF Vtacdocu NO-LOCK,
        FIRST Facdpedi OF ORDEN EXCLUSIVE-LOCK WHERE Facdpedi.codmat = Vtaddocu.codmat:
        /* *************************************** */
        /* RHC 11/03/2020 Conrol de modificaciones */
        /* *************************************** */
        ASSIGN
            x-CanPed = Facdpedi.CanPed.
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
        /* OJO: Los items que están en cero se ELIMINAN */
        IF Facdpedi.CanPed <= 0 THEN DELETE Facdpedi.   /* OJO */
        /* ******************************************** */
    END.
    IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.
    /* RHC 20/01/2018 Si no quedan items NO permitir cerrar */
    FIND FIRST Facdpedi OF ORDEN NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Facdpedi THEN DO:
        pError = "NO se puede eliminar TODOS los items" + CHR(10) +
            "Favor de eliminar la orden COMPLETA".
        UNDO CICLO, LEAVE.
    END.
    /* **************************************************** */
    CASE Vtacdocu.CodPed:
        WHEN "O/D" OR WHEN "O/M" THEN DO:
            RUN Graba-Totales ( ROWID(ORDEN) ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                pError = "NO se pudo actualizar el documento: " + ORDEN.coddoc + " " + ORDEN.nroped.
                UNDO CICLO, LEAVE.
            END.
            /* Actualizamos Saldo del Pedido */
            FOR EACH Vtaddocu OF Vtacdocu NO-LOCK,
                FIRST Facdpedi OF PEDIDO EXCLUSIVE-LOCK WHERE Facdpedi.codmat = Vtaddocu.codmat:
/*                 FIND Facdpedi OF PEDIDO WHERE Facdpedi.codmat = Vtaddocu.codmat               */
/*                     EXCLUSIVE-LOCK NO-ERROR NO-WAIT.                                          */
/*                 IF NOT AVAILABLE Facdpedi THEN DO:                                            */
/*                     pError = "NO se pudo bloquear el artículo " + Vtaddocu.codmat + CHR(10) + */
/*                         "Pedido: " + PEDIDO.coddoc + " " + PEDIDO.nroped.                     */
/*                     UNDO CICLO, LEAVE CICLO.                                                  */
/*                 END.                                                                          */
                ASSIGN
                    Facdpedi.CanPed = Vtaddocu.CanPed
                    Facdpedi.CanAte = Vtaddocu.CanPed
                    Facdpedi.CanPick = Vtaddocu.CanPed.
                IF Facdpedi.CanPed <= 0 THEN DELETE Facdpedi.   /* OJO */
            END.
            IF AVAILABLE Facdpedi THEN RELEASE Facdpedi.
            RUN Graba-Totales ( ROWID(PEDIDO) ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                pError = "NO se pudo actualizar el documento: " + PEDIDO.coddoc + " " + PEDIDO.nroped.
                UNDO CICLO, LEAVE.
            END.
            /* Actualizamos Saldo de la Cotización */
            IF Vtacdocu.CodPed = 'O/D' THEN DO:
                FOR EACH Vtaddocu OF Vtacdocu NO-LOCK WHERE Vtaddocu.Libre_c05 <> "OF",
                    FIRST Facdpedi OF COTIZACION EXCLUSIVE-LOCK WHERE Facdpedi.codmat = Vtaddocu.codmat:
/*                     FIND Facdpedi OF COTIZACION WHERE Facdpedi.codmat = Vtaddocu.codmat           */
/*                         EXCLUSIVE-LOCK NO-ERROR NO-WAIT.                                          */
/*                     IF NOT AVAILABLE Facdpedi THEN DO:                                            */
/*                         pError = "NO se pudo bloquear el artículo " + Vtaddocu.codmat + CHR(10) + */
/*                             "Cotización: " + COTIZACION.coddoc + " " + COTIZACION.nroped.         */
/*                         UNDO CICLO, LEAVE CICLO.                                                  */
/*                     END.                                                                          */
                    ASSIGN
                        Facdpedi.CanAte = Facdpedi.CanAte - Vtaddocu.CanBase + Vtaddocu.CanPed.
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
    ASSIGN 
        Vtacdocu.FlgSit = "C"
        Vtacdocu.Libre_c03 = s-user-id + '|' + STRING(NOW, '99/99/9999 HH:MM:SS') + '|' + Vtacdocu.usrsac
        Vtacdocu.usrsacrecep = s-user-id
        Vtacdocu.fchfin = NOW
        Vtacdocu.usuariofin = s-user-id.
    /* TRACKING */
      CASE Vtacdocu.CodPed:
          WHEN "O/D" OR WHEN "O/M" THEN DO:
              RUN vtagn/pTracking-04 (s-CodCia,
                                      s-CodDiv,
                                      Vtacdocu.CodRef,
                                      Vtacdocu.NroRef,
                                      s-User-Id,
                                      'VODP',
                                      'P',
                                      DATETIME(TODAY, MTIME),
                                      DATETIME(TODAY, MTIME),
                                      Vtacdocu.CodPed,
                                      Vtacdocu.NroPed,
                                      Vtacdocu.CodPed,
                                      ENTRY(1,Vtacdocu.NroPed,'-')).
          END.
          WHEN "OTR" THEN DO:
              RUN vtagn/pTracking-04 (s-CodCia,
                                      s-CodDiv,
                                      Vtacdocu.CodPed,
                                      ENTRY(1,Vtacdocu.NroPed,'-'),
                                      s-User-Id,
                                      'VODP',
                                      'P',
                                      DATETIME(TODAY, MTIME),
                                      DATETIME(TODAY, MTIME),
                                      Vtacdocu.CodPed,
                                      Vtacdocu.NroPed,
                                      Vtacdocu.CodPed,
                                      ENTRY(1,Vtacdocu.NroPed,'-')).
          END.
      END CASE.
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
    FOR EACH b-vtacdocu EXCLUSIVE-LOCK WHERE b-vtacdocu.codcia = Vtacdocu.codcia
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
  {src/adm/template/snd-list.i "VtaCDocu"}
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

