&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CMOV FOR Almcmov.
DEFINE BUFFER B-DMOV FOR Almdmov.
DEFINE SHARED TEMP-TABLE T-INGKIT NO-UNDO LIKE Almdmov.
DEFINE SHARED TEMP-TABLE T-SALKIT NO-UNDO LIKE Almdmov.



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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR.
DEFINE SHARED VAR lh_handle AS HANDLE.

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE ttItemSalidas
    FIELD   tCodMat     AS  CHAR    FORMAT 'x(6)'
    FIELD   tCodpack    AS  CHAR    FORMAT 'x(6)'
    FIELD   tCant       AS  DEC INIT 0
    FIELD   tundStk     AS  CHAR.
DEFINE TEMP-TABLE ttItemIngresos
    FIELD   tCodpack    AS  CHAR    FORMAT 'x(6)'
    FIELD   tCant       AS  DEC INIT 0
    FIELD   tundStkpack AS  CHAR.
DEFINE TEMP-TABLE tSaldo 
    FIELD CodMat AS CHAR
    FIELD StkAct AS DEC.

DEFINE VARIABLE C-CODMOV AS CHAR INIT '14'.  /* Reclasificación */
DEFINE VARIABLE S-NROSER  AS INTEGER.
DEFINE VAR cMensaje AS CHAR.

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
&Scoped-define INTERNAL-TABLES T-INGKIT Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-INGKIT.codmat Almmmatg.DesMat ~
T-INGKIT.CanDev T-INGKIT.CodUnd 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH T-INGKIT WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF T-INGKIT NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-INGKIT WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg OF T-INGKIT NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-INGKIT Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-INGKIT
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


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
      T-INGKIT, 
      Almmmatg
    FIELDS(Almmmatg.DesMat) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-INGKIT.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U
      Almmmatg.DesMat FORMAT "X(60)":U
      T-INGKIT.CanDev COLUMN-LABEL "Cantidad Fórmula" FORMAT "(ZZZ,ZZZ,ZZ9.9999)":U
      T-INGKIT.CodUnd FORMAT "X(10)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 74 BY 6.69
         FONT 4
         TITLE "ARTICULOS QUE ENTRAN".


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
      TABLE: B-CMOV B "?" ? INTEGRAL Almcmov
      TABLE: B-DMOV B "?" ? INTEGRAL Almdmov
      TABLE: T-INGKIT T "SHARED" NO-UNDO INTEGRAL Almdmov
      TABLE: T-SALKIT T "SHARED" NO-UNDO INTEGRAL Almdmov
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
         WIDTH              = 85.43.
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
     _TblList          = "Temp-Tables.T-INGKIT,INTEGRAL.Almmmatg OF Temp-Tables.T-INGKIT"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST USED"
     _FldNameList[1]   > Temp-Tables.T-INGKIT.codmat
"T-INGKIT.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-INGKIT.CanDev
"T-INGKIT.CanDev" "Cantidad Fórmula" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.T-INGKIT.CodUnd
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* ARTICULOS QUE ENTRAN */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* ARTICULOS QUE ENTRAN */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* ARTICULOS QUE ENTRAN */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}


   RUN Pinta-Salida IN lh_handle (INPUT T-INGKIT.codmat).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar B-table-Win 
PROCEDURE Generar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* CONSISTENCIA DE MOVIMIENTOS */
FIND Almtdocm WHERE Almtdocm.CodCia = s-codcia
    AND Almtdocm.CodAlm = s-codalm
    AND Almtdocm.TipMov = 'I'
    AND Almtdocm.CodMov = INTEGER (c-codmov)
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtdocm THEN DO:
    MESSAGE 'Movimiento de entrada' c-codmov 'NO configurado en el almacén' s-codalm
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
FIND Almtdocm WHERE Almtdocm.CodCia = s-codcia
    AND Almtdocm.CodAlm = s-codalm
    AND Almtdocm.TipMov = 'S'
    AND Almtdocm.CodMov = INTEGER (c-codmov)
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtdocm THEN DO:
    MESSAGE 'Movimiento de salida' c-codmov 'NO configurado en el almacén' s-codalm
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.


EMPTY TEMP-TABLE ttItemSalidas.
EMPTY TEMP-TABLE ttItemIngresos.

DEFINE VAR x-cont AS INT.
DEFINE VAR x-total AS INT.

DEFINE VAR x-codmat AS CHAR.
DEFINE VAR x-codpack AS CHAR.

DEFINE VAR x-stkact AS DEC.
DEFINE VAR x-cant-sugerida AS DEC.
DEFINE VAR x-cant AS DEC.

SESSION:SET-WAIT-STATE('GENERAL').
/* Control de Saldo de Componentes */
EMPTY TEMP-TABLE tSaldo.
FOR EACH T-SALKIT:
    FIND FIRST tSaldo WHERE tSaldo.codmat = T-SALKIT.codmat NO-ERROR.
    IF NOT AVAILABLE tSaldo THEN CREATE tSaldo.
    ASSIGN
        tSaldo.codmat = T-SALKIT.codmat 
        tSaldo.stkact = T-SALKIT.StkAct.
END.
/* Barremos Kit por Kit */
DEF VAR x-Factor AS DEC NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO.
RLOOP:
DO x-Item = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(x-Item) THEN DO:
        FIND CURRENT T-INGKIT EXCLUSIVE-LOCK.
        T-INGKIT.candes = 0.
        /* Determinamos si se puede completar el kit */
        FOR EACH T-SALKIT WHERE T-SALKIT.CodAnt = T-INGKIT.CodMat,
            FIRST tSaldo WHERE tSaldo.codmat = T-SALKIT.codmat:
            IF T-SALKIT.candev > tSaldo.stkact THEN NEXT RLOOP.
        END.
        /* Determinamos la cantidad de kits que se pueden armar */
        x-Factor = 0.
        FOR EACH T-SALKIT WHERE T-SALKIT.CodAnt = T-INGKIT.CodMat,
            FIRST tSaldo WHERE tSaldo.codmat = T-SALKIT.codmat:
            /* Factor */
            x-Factor = TRUNCATE(tSaldo.stkact / T-SALKIT.candev, 0).
            IF T-INGKIT.candes = 0 THEN T-INGKIT.candes = x-Factor.
            ELSE T-INGKIT.candes = MINIMUM(T-INGKIT.candes, x-Factor).
        END.
        /* Armamos kits */
        IF T-INGKIT.candes = 0 THEN NEXT.
        FOR EACH T-SALKIT WHERE T-SALKIT.CodAnt = T-INGKIT.CodMat,
            FIRST tSaldo WHERE tSaldo.codmat = T-SALKIT.codmat:
            T-SALKIT.candes = T-INGKIT.candes * T-SALKIT.candev.    /* Formula */
            tSaldo.stkact = tSaldo.stkact - T-SALKIT.candes.
        END.
        /* Cargamos los temporales de Salida e Ingreso */
        /* Salidas */
        FOR EACH T-SALKIT WHERE T-SALKIT.CodAnt = T-INGKIT.CodMat,
            FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
            almmmatg.codmat = T-SALKIT.codmat:
            FIND FIRST ttItemSalidas WHERE ttItemSalidas.tcodmat = T-SALKIT.codmat AND
                ttItemSalidas.tcodpack = T-SALKIT.CodAnt NO-ERROR.
            IF NOT AVAILABLE ttItemSalidas THEN DO:
                CREATE ttItemSalidas.
                ASSIGN 
                    ttItemSalidas.tcodmat  = T-SALKIT.codmat 
                    ttItemSalidas.tcodpack = T-SALKIT.CodAnt
                    ttItemSalidas.tUndStk = Almmmatg.undstk.
            END.
            ASSIGN 
                ttItemSalidas.tcant = ttItemSalidas.tCant + T-SALKIT.candes.
        END.
        /* Ingresos */
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
            almmmatg.codmat = T-INGKIT.codmat NO-LOCK NO-ERROR.
        FIND FIRST ttItemIngresos WHERE ttItemIngresos.tcodpack = T-INGKIT.codmat NO-ERROR.
        IF NOT AVAILABLE ttItemIngresos THEN DO:
            CREATE ttItemIngresos.
            ASSIGN 
                ttItemIngresos.tcodpack = T-INGKIT.codmat
                ttItemIngresos.tUndStkPack = Almmmatg.undstk.
        END.
        ASSIGN 
            ttItemIngresos.tcant = ttItemIngresos.tCant + (T-INGKIT.candes * T-INGKIT.candev).  /* Formula */
    END.
END.
/* GENERAMOS MOVIMIENTO DE ALMACEN */
FIND FIRST ttItemSalidas NO-ERROR.
IF NOT AVAILABLE ttItemSalidas THEN DO:
    MESSAGE "No existen movimientos para reclasificar".
    RETURN "ADM-ERROR".
END.
/* */
RUN Grabar.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    IF cMensaje > '' THEN MESSAGE cMensaje VIEW-AS ALERT-BOX ERROR.
END.
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar B-table-Win 
PROCEDURE Grabar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR f-TPOCMB AS DEC.

FIND LAST gn-tcmb NO-LOCK NO-ERROR.
IF AVAILABLE gn-tcmb THEN f-TPOCMB = gn-tcmb.compra.
FIND FIRST Almtdocm WHERE Almtdocm.CodCia = S-CODCIA 
    AND Almtdocm.CodAlm = S-CODALM 
    AND Almtdocm.TipMov = "S" 
    AND LOOKUP(STRING(Almtdocm.CodMov, '99'), C-CODMOV) > 0
    NO-LOCK NO-ERROR.

DEF VAR x-CorrSal LIKE Almacen.CorrSal NO-UNDO.
DEF VAR x-CorrIng LIKE Almacen.CorrIng NO-UNDO.

cMensaje = "".
tGrabarMovimientos:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    {lib/lock-genericov3.i 
        &Tabla="Almacen "
        &Condicion="Almacen.CodCia = s-CodCia AND Almacen.CodAlm = s-CodAlm"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="cMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    /* ********************************************************************************* */
    /* CABECERAS */
    /* ********************************************************************************* */
    SALIDAS:
    REPEAT:
        ASSIGN
            x-CorrSal = Almacen.CorrSal.
        IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia 
                        AND Almcmov.codalm = Almtdocm.CodAlm
                        AND Almcmov.tipmov = "S"
                        AND Almcmov.codmov = Almtdocm.CodMov
                        AND Almcmov.nroser = s-NroSer
                        AND Almcmov.nrodoc = x-CorrSal
                        NO-LOCK)
            THEN LEAVE.
        ASSIGN
            Almacen.CorrSal = Almacen.CorrSal + 1.
    END.
    INGRESOS:
    REPEAT:
        ASSIGN
            x-CorrIng = Almacen.CorrIng.
        IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia 
                        AND Almcmov.codalm = Almtdocm.CodAlm
                        AND Almcmov.tipmov = "I"
                        AND Almcmov.codmov = Almtdocm.CodMov
                        AND Almcmov.nroser = s-NroSer
                        AND Almcmov.nrodoc = x-CorrIng
                        NO-LOCK)
            THEN LEAVE.
        ASSIGN
            Almacen.CorrIng = Almacen.CorrIng + 1.
    END.
    /* MOVIMIENTO DE SALIDA */
    CREATE Almcmov.
    ASSIGN 
        Almcmov.CodCia = Almtdocm.CodCia 
        Almcmov.CodAlm = Almtdocm.CodAlm 
        Almcmov.TipMov = 'S'
        Almcmov.CodMov = Almtdocm.CodMov
        Almcmov.NroSer = S-NROSER
        Almcmov.Nrodoc  = Almacen.CorrSal
        Almcmov.HorSal = STRING(TIME,"HH:MM:SS")
        Almcmov.CodMon = 1
        Almcmov.TpoCmb  = F-TPOCMB
        Almcmov.NroRf1 = ""
        Almcmov.usuario = S-USER-ID NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'.
    END.
    /* MOVIMIENTO DE ENTRADA */
    CREATE B-CMOV.
    BUFFER-COPY Almcmov 
        TO B-CMOV
        ASSIGN
        B-CMOV.TipMov = "I"
        B-CMOV.Nrodoc = Almacen.CorrIng
        B-CMOV.NroRef = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '9999999') NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'.
    END.
    ASSIGN 
        Almcmov.NroRef = STRING(B-CMOV.nroser, '999') + STRING(B-CMOV.nrodoc, '9999999').
    ASSIGN
        Almacen.CorrSal = Almacen.CorrSal + 1
        Almacen.CorrIng = Almacen.CorrIng + 1.
    ASSIGN 
        Almcmov.usuario = S-USER-ID.
    /* ********************************************************************************* */
    /* DETALLES */
    /* ********************************************************************************* */
    DEF VAR N-Itm AS INTEGER NO-UNDO.
    DEF VAR r-Rowid AS ROWID NO-UNDO.
    DEF VAR pComprometido AS DEC.

    /* SALIDAS */
    N-Itm = 0.
    FOR EACH ttItemSalidas NO-LOCK:
        N-Itm = N-Itm + 1.
        CREATE almdmov.
        ASSIGN 
            Almdmov.CodCia = Almcmov.CodCia 
            Almdmov.CodAlm = Almcmov.CodAlm 
            Almdmov.TipMov = Almcmov.TipMov 
            Almdmov.CodMov = Almcmov.CodMov 
            Almdmov.NroSer = Almcmov.NroSer 
            Almdmov.NroDoc = Almcmov.NroDoc 
            Almdmov.CodMon = Almcmov.CodMon 
            Almdmov.FchDoc = Almcmov.FchDoc 
            Almdmov.TpoCmb = Almcmov.TpoCmb
            Almdmov.codmat = ttItemSalidas.tcodmat
            Almdmov.CanDes = ttItemSalidas.tCant
            Almdmov.CodUnd = ttItemSalidas.tUndStk
            Almdmov.Factor = 1
            Almdmov.PreBas = 0
            Almdmov.ImpCto = 0
            Almdmov.PreUni = 0
            Almdmov.NroItm = N-Itm
            Almdmov.CodAjt = ''
            Almdmov.HraDoc = almcmov.HorSal
            R-ROWID = ROWID(Almdmov) NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'.
        END.
        FIND Almmmatg OF Almdmov NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almmmatg THEN DO:
          UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            Almdmov.CodUnd = Almmmatg.UndStk.
        RUN alm/almdcstk (R-ROWID).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'.
        RUN ALM\ALMACPR1 (R-ROWID,"U").
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'.
    END.
    /* INGRESOS */
    N-Itm = 0.
    FOR EACH ttItemIngresos NO-LOCK:
        N-Itm = N-Itm + 1.
        CREATE almdmov.
        ASSIGN 
            Almdmov.CodCia = B-CMOV.CodCia 
            Almdmov.CodAlm = B-CMOV.CodAlm 
            Almdmov.TipMov = B-CMOV.TipMov 
            Almdmov.CodMov = B-CMOV.CodMov 
            Almdmov.NroSer = B-CMOV.NroSer 
            Almdmov.NroDoc = B-CMOV.NroDoc 
            Almdmov.CodMon = B-CMOV.CodMon 
            Almdmov.FchDoc = B-CMOV.FchDoc 
            Almdmov.TpoCmb = B-CMOV.TpoCmb
            Almdmov.codmat = ttItemIngresos.tCodPack
            Almdmov.CanDes = ttItemIngresos.tCant
            Almdmov.CodUnd = ttItemIngresos.tUndStkPack
            Almdmov.Factor = 1
            Almdmov.PreBas = 0
            Almdmov.ImpCto = 0
            Almdmov.PreUni = 0
            Almdmov.NroItm = N-Itm
            Almdmov.CodAjt = ''
            Almdmov.HraDoc = B-CMOV.HorSal
            R-ROWID = ROWID(Almdmov) NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'.
        END.
        FIND Almmmatg OF Almdmov NO-LOCK NO-ERROR.
        IF NOT AVAILABLE almmmatg THEN DO:
          UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            Almdmov.CodUnd = Almmmatg.UndStk.
        /* VALORIZACION */
        FIND LAST Almstkge WHERE Almstkge.codcia = s-codcia AND
            Almstkge.codmat = Almdmov.codmat AND
            Almstkge.fecha <= TODAY AND
            Almstkge.ctouni > 0
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almstkge THEN 
            ASSIGN 
                Almdmov.ImpCto = (Almdmov.candes * Almdmov.Factor * Almstkge.ctouni)
                Almdmov.PreUni = Almdmov.ImpCto / Almdmov.candes.
        /* ************ */
        FIND FIRST Almtmovm WHERE Almtmovm.CodCia = B-CMOV.CodCia 
            AND  Almtmovm.Tipmov = B-CMOV.TipMov 
            AND  Almtmovm.Codmov = B-CMOV.CodMov 
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtmovm AND Almtmovm.PidPCo 
            THEN ASSIGN Almdmov.CodAjt = "A".
        ELSE ASSIGN Almdmov.CodAjt = ''.
        RUN ALM\ALMACSTK (R-ROWID).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'.
        RUN ALM\ALMACPR1 (R-ROWID,"U").
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO tGrabarMovimientos, RETURN 'ADM-ERROR'. 
    END.
END.
RELEASE almdmov.
RELEASE almcmov.
RELEASE B-CMOV.
RELEASE B-DMOV.
RELEASE Almacen.

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
  {src/adm/template/snd-list.i "T-INGKIT"}
  {src/adm/template/snd-list.i "Almmmatg"}

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

