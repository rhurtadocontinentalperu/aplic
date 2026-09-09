&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-VtaDDocu NO-UNDO LIKE VtaDDocu.



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

DEF VAR x-CodPed AS CHAR NO-UNDO.
DEF VAR x-NroPed AS CHAR NO-UNDO.

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
&Scoped-define INTERNAL-TABLES t-VtaDDocu Almmmate Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table t-VtaDDocu.AftIsc Almmmate.CodUbi ~
t-VtaDDocu.CodMat t-VtaDDocu.CanPed t-VtaDDocu.CanPick Almmmatg.Chr__01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH t-VtaDDocu WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmate WHERE Almmmate.CodCia = t-VtaDDocu.CodCia ~
  AND Almmmate.codmat = t-VtaDDocu.CodMat ~
  AND Almmmate.CodAlm = t-VtaDDocu.AlmDes NO-LOCK, ~
      FIRST Almmmatg OF t-VtaDDocu NO-LOCK ~
    BY Almmmate.CodUbi ~
       BY t-VtaDDocu.CodMat
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH t-VtaDDocu WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmate WHERE Almmmate.CodCia = t-VtaDDocu.CodCia ~
  AND Almmmate.codmat = t-VtaDDocu.CodMat ~
  AND Almmmate.CodAlm = t-VtaDDocu.AlmDes NO-LOCK, ~
      FIRST Almmmatg OF t-VtaDDocu NO-LOCK ~
    BY Almmmate.CodUbi ~
       BY t-VtaDDocu.CodMat.
&Scoped-define TABLES-IN-QUERY-br_table t-VtaDDocu Almmmate Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table t-VtaDDocu
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmate
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_DesMat 

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
DEFINE VARIABLE FILL-IN_DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 63 BY 1
     BGCOLOR 14 FGCOLOR 0 FONT 11 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      t-VtaDDocu, 
      Almmmate
    FIELDS(Almmmate.CodUbi), 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      t-VtaDDocu.AftIsc COLUMN-LABEL "" FORMAT "Si/No":U WIDTH 2.43
            VIEW-AS TOGGLE-BOX
      Almmmate.CodUbi FORMAT "x(10)":U WIDTH 11.43
      t-VtaDDocu.CodMat COLUMN-LABEL "Artículo" FORMAT "X(6)":U
            WIDTH 10.43
      t-VtaDDocu.CanPed COLUMN-LABEL "Solicitado" FORMAT ">>>,>>9.99":U
            WIDTH 12.43
      t-VtaDDocu.CanPick FORMAT ">>>,>>9.99":U WIDTH 12.43
      Almmmatg.Chr__01 COLUMN-LABEL "Unidad" FORMAT "X(8)":U WIDTH 7.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 63 BY 16.42
         FONT 11 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN_DesMat AT ROW 17.42 COL 1 NO-LABEL WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 11 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: t-VtaDDocu T "?" NO-UNDO INTEGRAL VtaDDocu
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
         HEIGHT             = 17.69
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

/* SETTINGS FOR FILL-IN FILL-IN_DesMat IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.t-VtaDDocu,INTEGRAL.Almmmate WHERE Temp-Tables.t-VtaDDocu ...,INTEGRAL.Almmmatg OF Temp-Tables.t-VtaDDocu"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST USED, FIRST"
     _OrdList          = "INTEGRAL.Almmmate.CodUbi|yes,Temp-Tables.t-VtaDDocu.CodMat|yes"
     _JoinCode[2]      = "INTEGRAL.Almmmate.CodCia = Temp-Tables.t-VtaDDocu.CodCia
  AND INTEGRAL.Almmmate.codmat = Temp-Tables.t-VtaDDocu.CodMat
  AND INTEGRAL.Almmmate.CodAlm = Temp-Tables.t-VtaDDocu.AlmDes"
     _FldNameList[1]   > Temp-Tables.t-VtaDDocu.AftIsc
"t-VtaDDocu.AftIsc" "" ? "logical" ? ? ? ? ? ? no ? no no "2.43" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmate.CodUbi
"Almmmate.CodUbi" ? "x(10)" "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-VtaDDocu.CodMat
"t-VtaDDocu.CodMat" "Artículo" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-VtaDDocu.CanPed
"t-VtaDDocu.CanPed" "Solicitado" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-VtaDDocu.CanPick
"t-VtaDDocu.CanPick" ? ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.Almmmatg.Chr__01
"Almmmatg.Chr__01" "Unidad" ? "character" ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-DISPLAY OF br_table IN FRAME F-Main
DO:
  IF AVAILABLE t-Vtaddocu AND t-VtaDDocu.AftIsc = YES THEN DO:
      t-VtaDDocu.AftIsc:FGCOLOR IN BROWSE {&browse-name} = 0.
      t-VtaDDocu.AftIsc:BGCOLOR IN BROWSE {&browse-name} = 10.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
      IF AVAILABLE Almmmatg 
      THEN DISPLAY TRIM(Almmmatg.desmat) + ' - ' + Almmmatg.desmar @ FILL-IN_DesMat WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal B-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    x-CodPed = ''
    x-nroPed = ''.
EMPTY TEMP-TABLE t-Vtaddocu.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Temporal B-table-Win 
PROCEDURE Captura-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER TABLE FOR t-Vtaddocu.
DEF INPUT PARAMETER pCodMat AS CHAR.

DEF VAR x-Rowid AS ROWID NO-UNDO.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

FIND t-Vtaddocu WHERE t-Vtaddocu.codmat = pCodMat NO-LOCK NO-ERROR.
IF AVAILABLE t-Vtaddocu THEN DO:
    x-Rowid = ROWID(t-VtaDDocu).
    REPOSITION {&browse-name} TO ROWID x-Rowid NO-ERROR.
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

DEF INPUT PARAMETER pCodPed AS CHAR.
DEF INPUT PARAMETER pNroPed AS CHAR.

/* Capturamos las llaves */
ASSIGN
    x-CodPed = pCodPed
    x-NroPed = pNroPed.

EMPTY TEMP-TABLE t-Vtaddocu.

FOR FIRST VtaCDocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia
    AND VtaCDocu.DivDes = s-CodDiv
    AND VtaCDocu.CodPed = pCodPed
    AND VtaCDocu.NroPed = pNroPed,
    EACH Vtaddocu OF Vtacdocu NO-LOCK:
    CREATE t-Vtaddocu.
    ASSIGN
        t-VtaDDocu.CodCia = s-CodCia
        t-VtaDDocu.CanPed = VtaDDocu.CanPed * VtaDDocu.Factor
        t-VtaDDocu.CanPick = 0
        t-VtaDDocu.CodMat = VtaDDocu.CodMat 
        t-VtaDDocu.Factor = 1
        t-VtaDDocu.AlmDes = VtaDDocu.AlmDes
        t-VtaDDocu.AftIsc = NO
        .
END.
FOR EACH t-Vtaddocu EXCLUSIVE-LOCK:
    FOR EACH logisdpiqueo NO-LOCK WHERE logisdpiqueo.CodCia = s-codcia
        AND logisdpiqueo.CodDiv = s-coddiv
        AND logisdpiqueo.CodPed = pCodPed
        AND logisdpiqueo.NroPed = pNroPed
        AND logisdpiqueo.CodMat = t-VtaDDocu.CodMat:
        ASSIGN
            t-VtaDDocu.CanPick = t-VtaDDocu.CanPick + (logisdpiqueo.CanPed * logisdpiqueo.Factor).
        IF t-VtaDDocu.CanPick >= t-VtaDDocu.CanPed THEN t-VtaDDocu.AftIsc = YES.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-de-guia B-table-Win 
PROCEDURE Cierre-de-guia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

  DEFINE VAR lOrdenLista AS LOG NO-UNDO.
  DEFINE BUFFER b-vtacdocu FOR vtacdocu.

  DEFINE VAR lCodCliente AS CHAR INIT "".
  DEFINE VAR lCodDoc AS CHAR INIT "".

  lOrdenLista = YES.    /* Por defecto TODO cerrado */
  pError = "".

  DEF VAR x-Rowid AS ROWID NO-UNDO.

  FIND VtaCDocu WHERE VtaCDocu.CodCia = s-codcia
      AND VtaCDocu.DivDes = s-CodDiv
      AND VtaCDocu.CodPed = x-CodPed
      AND VtaCDocu.NroPed = x-NroPed
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Vtacdocu THEN RETURN 'OK'.

  /* Chequeamos si está todo pickeado o no */
  DEF VAR pSituacion AS LOG NO-UNDO.
  FIND FIRST t-VtaDDocu WHERE t-VtaDDocu.CanPed > t-VtaDDocu.CanPick NO-LOCK NO-ERROR.
  IF AVAILABLE t-VtaDDocu THEN DO:
      MESSAGE 'Cerramos HPK con observaciones?' VIEW-AS ALERT-BOX QUESTION
          BUTTONS YES-NO UPDATE rpta AS LOG.
      IF rpta = NO THEN RETURN 'ADM-ERROR'.
      pSituacion = NO.
  END.
  ELSE pSituacion = YES.

  x-Rowid = ROWID(Vtacdocu).
  CICLO:
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      /* Bloqueado el comprobante */
      {lib/lock-genericov3.i
          &Tabla="Vtacdocu"
          &Condicion="ROWID(Vtacdocu) = x-Rowid"
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT"
          &Accion="RETRY"
          &Mensaje="NO"
          &txtMensaje="pError"
          &TipoError="UNDO, LEAVE"
          }
      
      /* Volvemos a chequear las condiciones */
      IF NOT (Vtacdocu.flgest = 'P' AND Vtacdocu.flgsit = 'TP') THEN DO:
          pError =  'ERROR: la HPK ya NO está pendiente de Cierre de Pickeo'.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      /* ********************************************************************************* */
      IF pSituacion = NO THEN Vtacdocu.flgsit = 'TX'.       /* Pickeado CON OBSERVACIONES */
      ELSE Vtacdocu.flgsit = 'P'.                           /* Pickeo Cerrado de la SUB-ORDEN */
      ASSIGN 
          Vtacdocu.Libre_c03 = s-user-id + '|' + STRING(NOW, '99/99/9999 HH:MM:SS') + '|' + Vtacdocu.usrsac
          Vtacdocu.usrsacrecep = s-user-id
          /*Vtacdocu.zonapickeo = pZonaPickeo*/
          Vtacdocu.fchfin = NOW
          Vtacdocu.usuariofin = s-user-id.
      FOR EACH Vtaddocu OF Vtacdocu EXCLUSIVE-LOCK, FIRST t-Vtaddocu NO-LOCK WHERE t-Vtaddocu.codmat = Vtaddocu.codmat:
          ASSIGN Vtaddocu.CanBase = Vtaddocu.CanPed.
          ASSIGN Vtaddocu.CanPed  = (t-Vtaddocu.CanPick * t-Vtaddocu.Factor) / Vtaddocu.Factor.
      END.
      
      /* Verificamos si ya se puede cerrar la orden original */
      FOR EACH b-vtacdocu WHERE b-vtacdocu.codcia = VtaCDocu.codcia
          AND b-vtacdocu.coddiv = VtaCDocu.coddiv
          AND b-vtacdocu.codped = VtaCDocu.codped      /* HPK */
          AND b-vtacdocu.codref = VtaCDocu.codref      /* O/D OTR */
          AND b-vtacdocu.nroref = VtaCDocu.nroref:
          IF b-vtacdocu.flgsit <> "P" THEN DO:
              lOrdenLista = NO.
              LEAVE.
          END.
      END.
      
      /* Marco la ORDEN como COMPLETADO o FALTANTES */
      FOR EACH b-vtacdocu EXCLUSIVE-LOCK WHERE b-vtacdocu.codcia = VtaCDocu.codcia
          AND b-vtacdocu.coddiv = VtaCDocu.coddiv
          AND b-vtacdocu.codped = VtaCDocu.codped
          AND b-vtacdocu.codref = VtaCDocu.codref
          AND b-vtacdocu.nroref = VtaCDocu.nroref ON ERROR UNDO, THROW:
          ASSIGN 
              b-VtacDocu.libre_c05 = IF(lOrdenLista = YES) THEN "COMPLETADO" ELSE "FALTANTES".
      END.
      
      /* RHC 09/05/2020 Si todas las HPK está COMPLETADO => O/D cambiamos FlgSit = "PI" */
      IF lOrdenLista = YES THEN DO:
          /* Marcamos la O/D como PICADO COMPLETO */
          FIND FIRST Faccpedi WHERE FacCPedi.CodCia = Vtacdocu.CodCia AND
              FacCPedi.CodDoc = Vtacdocu.CodRef AND
              FacCPedi.NroPed = Vtacdocu.NroRef
              EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
          IF ERROR-STATUS:ERROR = YES THEN DO:
              {lib/mensaje-de-error.i &MensajeError="pError"}
               UNDO CICLO, LEAVE CICLO.
          END.
          ASSIGN
              Faccpedi.FlgSit = "PI".
          RELEASE Faccpedi.
      END.
      IF AVAILABLE(Vtacdocu) THEN RELEASE Vtacdocu.
      IF AVAILABLE(b-vtacdocu) THEN RELEASE b-vtacdocu.
  END.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Devuelve-Datos B-table-Win 
PROCEDURE Devuelve-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pCodMat AS CHAR.
DEF OUTPUT PARAMETER pSolicitado AS DECI.

ASSIGN
    pCodMat = ''
    pSolicitado = 0.
IF AVAILABLE t-Vtaddocu THEN DO:
    pCodMat = t-VtaDDocu.CodMat.
    pSolicitado = t-VtaDDocu.CanPed.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Entrega-Temporal B-table-Win 
PROCEDURE Entrega-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER TABLE FOR t-Vtaddocu.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields B-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Almmmatg 
      THEN DISPLAY TRIM(Almmmatg.desmat) + ' - ' + Almmmatg.desmar @ FILL-IN_DesMat WITH FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Registra-Picking B-table-Win 
PROCEDURE Registra-Picking :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCanChk AS DECI.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* Verificamos si sobrepasa la cantidad */
FIND t-VtaDDocu WHERE t-VtaDDocu.CodMat = pCodMat NO-ERROR.
IF ERROR-STATUS:ERROR = YES THEN DO:
    pMensaje = "Artículo NO registrado".
    RETURN 'ADM-ERROR'.
END.
IF (t-VtaDDocu.CanPick + pCanChk) > t-VtaDDocu.CanPed THEN DO:
    pMensaje = 'La cantidad Pickeada supera la cantidad Solicitada'.
    RETURN 'ADM-ERROR'.
END.
ASSIGN
    t-VtaDDocu.CanPick = t-VtaDDocu.CanPick + pCanChk.
IF t-VtaDDocu.CanPick >=  t-VtaDDocu.CanPed THEN t-VtaDDocu.AftIsc = YES.

CREATE logisdpiqueo.
ASSIGN
    logisdpiqueo.CodCia = s-codcia
    logisdpiqueo.CodDiv = s-coddiv
    logisdpiqueo.CodPed = x-CodPed
    logisdpiqueo.NroPed = x-NroPed
    logisdpiqueo.CodMat = pCodMat
    logisdpiqueo.CanPed = pCanChk
    logisdpiqueo.CanChk = pCanChk
    logisdpiqueo.Factor = 1
    logisdpiqueo.FechaHora = NOW
    logisdpiqueo.Usuario = s-user-id
    .

DEF VAR x-Rowid AS ROWID NO-UNDO.

x-Rowid = ROWID(t-VtaDDocu).
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
REPOSITION {&browse-name} TO ROWID x-Rowid NO-ERROR.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Repinta-Browse B-table-Win 
PROCEDURE Repinta-Browse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Rowid AS ROWID NO-UNDO.

x-Rowid = ROWID(t-VtaDDocu).
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
REPOSITION {&browse-name} TO ROWID x-Rowid NO-ERROR.

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
  {src/adm/template/snd-list.i "Almmmate"}
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

