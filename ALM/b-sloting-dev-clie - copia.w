&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATE FOR Almmmate.
DEFINE BUFFER b-ooMoviAlmacen FOR OOMoviAlmacen.
DEFINE TEMP-TABLE T-CMOV LIKE Almcmov.
DEFINE TEMP-TABLE T-MoviAlmacen LIKE OOMoviAlmacen
       FIELD Peso AS DEC
       FIELD Volumen AS DEC
       FIELD Items AS INT
       .



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
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

/* RHC 14/07/2020 NO compras por Drop Shipping */
&SCOPED-DEFINE Condicion ( OOMoviAlmacen.codcia = s-codcia ~
    AND OOMoviAlmacen.codalm = s-codalm ~
    AND OOMoviAlmacen.FlagMigracion = "N" ~
    AND OOMoviAlmacen.TipMov = "I" ~
    AND OOMoviAlmacen.CodMov = 09 ~
    AND OOMoviAlmacen.UseInDropShipment = "no" )

DEF VAR x-ValorLlave AS CHAR NO-UNDO.
DEF VAR x-Peso AS DEC NO-UNDO.
DEF VAR x-Volumen AS DEC NO-UNDO.
DEF VAR x-Items AS INT NO-UNDO.
DEF VAR x-Chequeador AS CHAR NO-UNDO.
DEF VAR x-NomPer AS CHAR NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

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
&Scoped-define INTERNAL-TABLES T-MoviAlmacen OOMoviAlmacen

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-MoviAlmacen.MigFecha ~
T-MoviAlmacen.MigHora T-MoviAlmacen.NroSer T-MoviAlmacen.NroDoc ~
T-MoviAlmacen.NroRf1 T-MoviAlmacen.Observ T-MoviAlmacen.CodPro ~
T-MoviAlmacen.NomRef T-MoviAlmacen.Items @ x-Items ~
T-MoviAlmacen.Volumen @ x-Volumen T-MoviAlmacen.Peso @ x-Peso 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH T-MoviAlmacen WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST OOMoviAlmacen WHERE OOMoviAlmacen.CodAlm = T-MoviAlmacen.CodAlm ~
  AND OOMoviAlmacen.TipMov = T-MoviAlmacen.TipMov ~
  AND OOMoviAlmacen.CodMov = T-MoviAlmacen.CodMov ~
  AND OOMoviAlmacen.NroSer = T-MoviAlmacen.NroSer ~
  AND OOMoviAlmacen.NroDoc = T-MoviAlmacen.NroDoc ~
      AND OOMoviAlmacen.FlagMigracion = "N" NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-MoviAlmacen WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST OOMoviAlmacen WHERE OOMoviAlmacen.CodAlm = T-MoviAlmacen.CodAlm ~
  AND OOMoviAlmacen.TipMov = T-MoviAlmacen.TipMov ~
  AND OOMoviAlmacen.CodMov = T-MoviAlmacen.CodMov ~
  AND OOMoviAlmacen.NroSer = T-MoviAlmacen.NroSer ~
  AND OOMoviAlmacen.NroDoc = T-MoviAlmacen.NroDoc ~
      AND OOMoviAlmacen.FlagMigracion = "N" NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-MoviAlmacen OOMoviAlmacen
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-MoviAlmacen
&Scoped-define SECOND-TABLE-IN-QUERY-br_table OOMoviAlmacen


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
      T-MoviAlmacen, 
      OOMoviAlmacen SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-MoviAlmacen.MigFecha COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
      T-MoviAlmacen.MigHora COLUMN-LABEL "Hora" FORMAT "x(10)":U
      T-MoviAlmacen.NroSer COLUMN-LABEL "Serie" FORMAT "999":U
      T-MoviAlmacen.NroDoc COLUMN-LABEL "Numero" FORMAT "999999999":U
            WIDTH 8.57
      T-MoviAlmacen.NroRf1 COLUMN-LABEL "O/C" FORMAT "x(10)":U
            WIDTH 11
      T-MoviAlmacen.Observ FORMAT "X(30)":U WIDTH 30.86
      T-MoviAlmacen.CodPro COLUMN-LABEL "Proveedor" FORMAT "x(11)":U
            WIDTH 11.86
      T-MoviAlmacen.NomRef FORMAT "x(50)":U WIDTH 25.29
      T-MoviAlmacen.Items @ x-Items COLUMN-LABEL "Items" FORMAT ">>9":U
      T-MoviAlmacen.Volumen @ x-Volumen COLUMN-LABEL "Vol. m3" FORMAT ">>>,>>9.99":U
      T-MoviAlmacen.Peso @ x-Peso COLUMN-LABEL "Peso kg" FORMAT ">>>,>>9.99":U
            WIDTH 5.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 142 BY 6.69
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
      TABLE: B-MATE B "?" ? INTEGRAL Almmmate
      TABLE: b-ooMoviAlmacen B "?" ? INTEGRAL OOMoviAlmacen
      TABLE: T-CMOV T "?" ? INTEGRAL Almcmov
      TABLE: T-MoviAlmacen T "?" ? INTEGRAL OOMoviAlmacen
      ADDITIONAL-FIELDS:
          FIELD Peso AS DEC
          FIELD Volumen AS DEC
          FIELD Items AS INT
          
      END-FIELDS.
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
         WIDTH              = 143.
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
     _TblList          = "Temp-Tables.T-MoviAlmacen,INTEGRAL.OOMoviAlmacen WHERE Temp-Tables.T-MoviAlmacen ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _JoinCode[2]      = "INTEGRAL.OOMoviAlmacen.CodAlm = Temp-Tables.T-MoviAlmacen.CodAlm
  AND INTEGRAL.OOMoviAlmacen.TipMov = Temp-Tables.T-MoviAlmacen.TipMov
  AND INTEGRAL.OOMoviAlmacen.CodMov = Temp-Tables.T-MoviAlmacen.CodMov
  AND INTEGRAL.OOMoviAlmacen.NroSer = Temp-Tables.T-MoviAlmacen.NroSer
  AND INTEGRAL.OOMoviAlmacen.NroDoc = Temp-Tables.T-MoviAlmacen.NroDoc"
     _Where[2]         = "INTEGRAL.OOMoviAlmacen.FlagMigracion = ""N"""
     _FldNameList[1]   > Temp-Tables.T-MoviAlmacen.MigFecha
"T-MoviAlmacen.MigFecha" "Fecha" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-MoviAlmacen.MigHora
"T-MoviAlmacen.MigHora" "Hora" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-MoviAlmacen.NroSer
"T-MoviAlmacen.NroSer" "Serie" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-MoviAlmacen.NroDoc
"T-MoviAlmacen.NroDoc" "Numero" "999999999" "integer" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-MoviAlmacen.NroRf1
"T-MoviAlmacen.NroRf1" "O/C" ? "character" ? ? ? ? ? ? no ? no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-MoviAlmacen.Observ
"T-MoviAlmacen.Observ" ? "X(30)" "character" ? ? ? ? ? ? no ? no no "30.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-MoviAlmacen.CodPro
"T-MoviAlmacen.CodPro" "Proveedor" ? "character" ? ? ? ? ? ? no ? no no "11.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-MoviAlmacen.NomRef
"T-MoviAlmacen.NomRef" ? ? "character" ? ? ? ? ? ? no ? no no "25.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"T-MoviAlmacen.Items @ x-Items" "Items" ">>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"T-MoviAlmacen.Volumen @ x-Volumen" "Vol. m3" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"T-MoviAlmacen.Peso @ x-Peso" "Peso kg" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no "5.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Factura B-table-Win 
PROCEDURE Actualiza-Factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER FACTOR AS INTEGER.
  DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  DEFINE VARIABLE F-Des AS DECIMAL INIT 0 NO-UNDO.
  DEFINE VARIABLE F-Dev AS DECIMAL INIT 0 NO-UNDO.
  DEFINE VARIABLE C-SIT AS CHARACTER INIT "" NO-UNDO.

  DEFINE VAR x-tabla AS CHAR INIT "CONFIG-VTAS".
  DEFINE VAR x-codigo AS CHAR INIT "PI.NO.VALIDAR.N/C".

  
  pMensaje = "".
  RLOOP:
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      {lib/lock-genericov3.i ~
          &Tabla="Ccbcdocu" ~
          &Condicion="CcbCDocu.CodCia = S-CODCIA ~
          AND CcbCDocu.CodDoc = Almcmov.CodRef ~
          AND CcbCDocu.NroDoc = Almcmov.NroRf1" ~
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
          &Accion="RETRY" ~
          &Mensaje="NO" ~
          &txtMensaje="pMensaje" ~
          &TipoError="UNDO, RETURN 'ADM-ERROR'" }
      FOR EACH Almdmov OF Almcmov NO-LOCK:
          FIND FIRST CcbDDocu WHERE CcbDDocu.CodCia = Almdmov.CodCia 
              AND  CcbDDocu.CodDoc = Almcmov.CodRef 
              AND  CcbDDocu.NroDoc = Almcmov.NroRf1 
              AND  CcbDDocu.CodMat = Almdmov.CodMat 
              EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
          IF ERROR-STATUS:ERROR = YES THEN DO:
              {lib/mensaje-de-error.i &MensajeError="pMensaje"}
              UNDO RLOOP, RETURN 'ADM-ERROR'.
          END.
          ASSIGN 
              CcbDDocu.CanDev = CcbDDocu.CanDev + (FACTOR * Almdmov.CanDes).
          RELEASE CcbDDocu.
      END.
      IF Ccbcdocu.FlgEst <> 'A' THEN DO:
          FOR EACH CcbDDocu OF CcbCDocu NO-LOCK:
              F-Des = F-Des + CcbDDocu.CanDes.
              F-Dev = F-Dev + CcbDDocu.CanDev. 
          END.
          IF F-Dev > 0 THEN C-SIT = "P".
          IF F-Des = F-Dev THEN C-SIT = "D".
          ASSIGN 
              CcbCDocu.FlgCon = C-SIT.
      END.

      /**/
      x-codigo = "PI.NO.VALIDAR.N/C".
      FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                  vtatabla.tabla = x-tabla AND
                                  vtatabla.llave_c1 = x-codigo AND
                                  vtatabla.llave_c2 = ccbcdocu.coddoc AND
                                  vtatabla.llave_c3 = ccbcdocu.nrodoc EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE vtatabla THEN DO:
            ASSIGN vtatabla.libre_c03 = "PI=" + STRING(almcmov.nrodoc) + "|" + "Devolucion=" + almcmov.NroRf2.
      END.

      /**/
      x-codigo = "DEV.MERCADERIA.DSCTO.VOL".
      FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                  vtatabla.tabla = x-tabla AND
                                  vtatabla.llave_c1 = x-codigo AND
                                  vtatabla.llave_c2 = ccbcdocu.coddoc AND
                                  vtatabla.llave_c3 = ccbcdocu.nrodoc EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE vtatabla THEN DO:
            ASSIGN vtatabla.libre_c03 = "PI=" + STRING(almcmov.nrodoc) + "|" + "Devolucion=" + almcmov.NroRf2.
      END.

  END.  
  IF AVAILABLE Ccbcdocu THEN RELEASE CcbCDocu.
  RELEASE vtatabla NO-ERROR.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar B-table-Win 
PROCEDURE Aprobar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR x-Rowid AS ROWID NO-UNDO.

IF NOT AVAILABLE ooMoviAlmacen THEN RETURN 'ADM-ERROR'.
x-Rowid = ROWID(ooMoviAlmacen).
pMensaje = "".

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Bloqueamos Cabecera */
    {lib/lock-genericov3.i ~
        &Tabla="ooMoviAlmacen" ~
        &Alcance="FIRST" ~
        &Condicion="ROWID(ooMoviAlmacen) = x-Rowid" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
     IF NOT({&Condicion}) THEN DO:
         pMensaje = 'El registro ha sido modificado por otro usuario' + CHR(10) +
             'Proceso abortado'.
         UNDO RLOOP, RETURN 'ADM-ERROR'.
     END.
    /* MoviAlmacen */
    CASE ooMoviAlmacen.TipMov:
        WHEN "I" THEN DO:
            RUN Crea-Cabecera-Detalle-Ingresos (OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
        END.
        /*WHEN "S" THEN RUN Crea-Cabecera-Detalle-Salidas NO-ERROR.*/
    END CASE.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Impresion B-table-Win 
PROCEDURE Carga-Impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER s-Task-No AS INT.
DEF INPUT PARAMETER pHoraInicio AS DATETIME.

DEF VAR pLeadTime AS CHAR NO-UNDO.
RUN Carga-Temporal.

FOR EACH T-MoviAlmacen NO-LOCK,
    FIRST OOMoviAlmacen WHERE OOMoviAlmacen.CodCia = T-MoviAlmacen.CodCia
    AND OOMoviAlmacen.CodAlm = T-MoviAlmacen.CodAlm
    AND OOMoviAlmacen.TipMov = T-MoviAlmacen.TipMov
    AND OOMoviAlmacen.CodMov = T-MoviAlmacen.CodMov
    AND OOMoviAlmacen.NroSer = T-MoviAlmacen.NroSer
    AND OOMoviAlmacen.NroDoc = T-MoviAlmacen.NroDoc 
    AND OOMoviAlmacen.FlagMigracion = "N" NO-LOCK:
    CREATE w-report.
    ASSIGN
        w-report.task-no = s-task-no.
    ASSIGN
        w-report.Campo-C[1] = OOMoviAlmacen.TipMov + "-" + STRING(OOMoviAlmacen.CodMov, '99')
        w-report.Campo-C[2] = STRING(OOMoviAlmacen.NroSer, '999') + STRING(OOMoviAlmacen.NroDoc, '999999999')
        w-report.Campo-C[3] = ooMoviAlmacen.CodPro
        w-report.Campo-C[4] = ooMoviAlmacen.NomRef
        w-report.Campo-D[1] = OOMoviAlmacen.MigFecha 
        w-report.Campo-C[5] = OOMoviAlmacen.MigHora.
    RUN lib/_time-passed (DATETIME(STRING(w-report.Campo-D[1],'99/99/9999') + ' ' + w-report.Campo-C[5]), 
                          pHoraInicio, 
                          OUTPUT pLeadTime).
    w-report.Campo-C[6] = pLeadTime.
    FOR EACH b-OOMoviAlmacen WHERE b-OOMoviAlmacen.CodCia = OOMoviAlmacen.CodCia
        AND b-OOMoviAlmacen.CodAlm = OOMoviAlmacen.CodAlm
        AND b-OOMoviAlmacen.TipMov = OOMoviAlmacen.TipMov
        AND b-OOMoviAlmacen.CodMov = OOMoviAlmacen.CodMov
        AND b-OOMoviAlmacen.NroSer = OOMoviAlmacen.NroSer
        AND b-OOMoviAlmacen.NroDoc = OOMoviAlmacen.NroDoc 
        AND b-OOMoviAlmacen.FlagMigracion = "N" NO-LOCK,
        FIRST INTEGRAL.Almmmatg WHERE Almmmatg.CodCia = b-OOMoviAlmacen.CodCia
        AND Almmmatg.codmat = b-OOMoviAlmacen.codmat NO-LOCK:
        w-report.Campo-I[1] = w-report.Campo-I[1] + 1.
    END.
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

EMPTY TEMP-TABLE T-MoviAlmacen.
FOR EACH OOMoviAlmacen WHERE {&Condicion} NO-LOCK
    BREAK BY OOMoviAlmacen.CodAlm 
    BY OOMoviAlmacen.TipMov
    BY OOMoviAlmacen.CodMov
    BY OOMoviAlmacen.NroSer 
    BY OOMoviAlmacen.NroDoc:
    IF FIRST-OF(OOMoviAlmacen.CodAlm) 
        OR FIRST-OF(OOMoviAlmacen.TipMov) 
        OR FIRST-OF(OOMoviAlmacen.CodMov)
        OR FIRST-OF(OOMoviAlmacen.NroSer)
        OR FIRST-OF(OOMoviAlmacen.NroDoc)
        THEN DO:
        CREATE T-MoviAlmacen.
        BUFFER-COPY OOMoviAlmacen TO T-MoviAlmacen.
        T-MoviAlmacen.Peso = 0.
        T-MoviAlmacen.Volumen = 0.
        T-MoviAlmacen.Items = 0.
        FIND FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia AND
            Faccpedi.coddoc = OOMoviAlmacen.CodRef AND
            Faccpedi.nroped = OOMoviAlmacen.NroRef
            NO-LOCK NO-ERROR.
        FOR EACH b-ooMoviAlmacen NO-LOCK WHERE b-ooMoviAlmacen.CodCia = ooMoviAlmacen.CodCia AND
            b-ooMoviAlmacen.CodAlm = ooMoviAlmacen.CodAlm AND
            b-ooMoviAlmacen.TipMov = ooMoviAlmacen.TipMov AND
            b-ooMoviAlmacen.CodMov = ooMoviAlmacen.CodMov AND
            b-ooMoviAlmacen.NroSer = ooMoviAlmacen.NroSer AND
            b-ooMoviAlmacen.NroDoc = ooMoviAlmacen.NroDoc AND
            b-ooMoviAlmacen.FlagMigracion = "N",
            FIRST Almmmatg OF b-ooMoviAlmacen NO-LOCK:
            T-MoviAlmacen.Items = T-MoviAlmacen.Items + 1.
            T-MoviAlmacen.Peso = T-MoviAlmacen.Peso + (b-ooMoviAlmacen.CanDes * b-ooMoviAlmacen.Factor * Almmmatg.Pesmat).
            T-MoviAlmacen.Volumen = T-MoviAlmacen.Volumen + (b-ooMoviAlmacen.CanDes * b-ooMoviAlmacen.Factor * Almmmatg.Libre_d02).
        END.
        T-MoviAlmacen.Volumen = T-MoviAlmacen.Volumen / 1000000.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Control-de-Series B-table-Win 
PROCEDURE Control-de-Series :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR iCuenta AS INT NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Catálogo de Articulos Series */
    FIND fifommatg WHERE fifommatg.CodCia = b-ooMoviAlmacen.CodCia
        AND fifommatg.CodMat = b-ooMoviAlmacen.CodMat
        AND fifommatg.SerialNumber = b-ooMoviAlmacen.SerialNumber
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE fifommatg THEN DO:
        CREATE fifommatg.
        ASSIGN
            fifommatg.AssetId = b-ooMoviAlmacen.AssetId
            fifommatg.CodCia = b-ooMoviAlmacen.CodCia
            fifommatg.CodMat = b-ooMoviAlmacen.CodMat
            fifommatg.ExpiryDate = OOMoviAlmacen.ExpiryDate
            fifommatg.FchIng = TODAY
            fifommatg.SerialNumber = b-ooMoviAlmacen.SerialNumber
            fifommatg.UsrIng = s-user-id
            fifommatg.WarrantyDate = OOMoviAlmacen.WarrantyDate
            NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="iCuenta"}
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    /* Articulo por Almacen */
    FIND fifommate WHERE fifommate.CodAlm = b-ooMoviAlmacen.CodAlm
        AND fifommate.CodCia = b-ooMoviAlmacen.CodCia
        AND fifommate.CodMat = b-ooMoviAlmacen.CodMat
        AND fifommate.SerialNumber = b-ooMoviAlmacen.SerialNumber
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE fifommate THEN DO:
        CREATE fifommate.
        ASSIGN
            fifommate.CodAlm = b-ooMoviAlmacen.CodAlm
            fifommate.CodCia = b-ooMoviAlmacen.CodCia
            fifommate.CodMat = b-ooMoviAlmacen.CodMat
            fifommate.SerialNumber = b-ooMoviAlmacen.SerialNumber
            fifommate.StkAct = b-ooMoviAlmacen.CanDes * b-ooMoviAlmacen.Factor
            NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="iCuenta"}
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    /* Movimientos por almacén */
    CREATE fifodmov.
    BUFFER-COPY Almdmov TO fifodmov
        ASSIGN fifodmov.SerialNumber = b-ooMoviAlmacen.SerialNumber
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="iCuenta"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Cabecera-Detalle-Ingresos B-table-Win 
PROCEDURE Crea-Cabecera-Detalle-Ingresos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR iCuenta AS INT NO-UNDO.

pMensaje = "".
CICLO:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND FIRST Almcmov  WHERE Almcmov.codcia = s-codcia
        AND Almcmov.codalm =  ooMoviAlmacen.CodAlm
        AND Almcmov.tipmov =  ooMoviAlmacen.TipMov
        AND Almcmov.codmov =  ooMoviAlmacen.CodMov
        AND Almcmov.nroser =  ooMoviAlmacen.NroSer
        AND Almcmov.nrodoc =  ooMoviAlmacen.NroDoc
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almcmov THEN DO:
        MESSAGE "ERROR:Cabecera ya registrada (almacen" ooMoviAlmacen.CodAlm "mov" 
            ooMoviAlmacen.TipMov ooMoviAlmacen.CodMov "numero" ooMoviAlmacen.NroSer
            ooMoviAlmacen.NroDoc ")" SKIP
            'Proceso abortado' VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    CREATE Almcmov.
    BUFFER-COPY ooMoviAlmacen 
        TO Almcmov
        ASSIGN 
        /*Almcmov.FchDoc = TODAY*/
        Almcmov.HraDoc = STRING(TIME, 'HH:MM:SS')
        Almcmov.HorRcp = STRING(TIME, 'HH:MM:SS')
        Almcmov.usuario = s-User-Id
        Almcmov.TpoCmb = FacCfgGn.Tpocmb[1]
        Almcmov.FlgEst = "P".    /* OJO */
    /* RHC 03/02/2019 Nos aseguramos la grabación bloqueando e ALMMMATE */
    /* RHC 10/07/2020 Los códigos pueden ir repetidos, los vamos acumulando */
    DETALLE:
    REPEAT:
        FIND FIRST b-ooMoviAlmacen WHERE b-ooMoviAlmacen.CodCia = ooMoviAlmacen.CodCia
            AND b-ooMoviAlmacen.CodAlm = ooMoviAlmacen.CodAlm
            AND b-ooMoviAlmacen.TipMov = ooMoviAlmacen.TipMov
            AND b-ooMoviAlmacen.CodMov = ooMoviAlmacen.CodMov
            AND b-ooMoviAlmacen.NroSer = ooMoviAlmacen.NroSer
            AND b-ooMoviAlmacen.NroDoc = ooMoviAlmacen.NroDoc 
            AND b-ooMoviAlmacen.FlagMigracion = "N" NO-LOCK NO-ERROR.
        IF NOT AVAILABLE b-ooMoviAlmacen THEN LEAVE DETALLE.
        FIND CURRENT b-ooMoviAlmacen EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="iCuenta"}
            UNDO CICLO, RETURN 'ADM-ERROR'.
        END.

        FIND FIRST Almdmov OF Almcmov WHERE Almdmov.CodMat = b-ooMoviAlmacen.CodMat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almdmov THEN DO:
            CREATE Almdmov.
            BUFFER-COPY Almcmov TO Almdmov
                ASSIGN
                Almdmov.CodMat = b-ooMoviAlmacen.CodMat 
                Almdmov.CodUnd = b-ooMoviAlmacen.CodUnd
                Almdmov.Factor = b-ooMoviAlmacen.Factor
                Almdmov.PreUni = b-ooMoviAlmacen.LinPreUni
                Almdmov.HraDoc     = Almcmov.HorRcp
                NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                pMensaje = "ERROR:Detalle ya registrado (almacen " + ooMoviAlmacen.CodAlm + " mov " +
                    ooMoviAlmacen.TipMov + STRING(ooMoviAlmacen.CodMov) + " numero " + STRING(ooMoviAlmacen.NroSer, '999') + 
                    STRING(ooMoviAlmacen.NroDoc, '999999999') + " producto " + b-ooMoviAlmacen.CodMat + ")" + CHR(10) +
                    'Proceso Abortado'.
                UNDO CICLO, RETURN 'ADM-ERROR'.
            END.
        END.
        ELSE DO:
            FIND CURRENT Almdmov EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="iCuenta"}
                UNDO CICLO, RETURN 'ADM-ERROR'.
            END.
        END.
        ASSIGN
            Almdmov.CanDes = Almdmov.CanDes + b-ooMoviAlmacen.CanDes   /* Acumulamos */
            Almdmov.ImpLin = Almdmov.ImpLin + b-ooMoviAlmacen.LinImpLin
            Almdmov.ImpIgv = Almdmov.ImpIgv + b-ooMoviAlmacen.LinImpIgv
            Almdmov.ImpIsc = Almdmov.ImpIsc + b-ooMoviAlmacen.LinImpIsc
            .
        /* Actualizamos el control de series */
        IF b-ooMoviAlmacen.SerialNumber > '' THEN DO:
            /* ***************************************************************************** */
            /* Control de series */
            /* ***************************************************************************** */
            DEFINE VAR hProc AS HANDLE NO-UNDO.

            RUN alm/almacen-library PERSISTENT SET hProc.
            RUN FIFO_Control-de-Series IN hProc (INPUT "WRITE",
                                                 INPUT Almdmov.CodAlm,
                                                 INPUT Almdmov.AlmOri,
                                                 INPUT Almdmov.TipMov,
                                                 INPUT Almdmov.CodMov,
                                                 INPUT Almdmov.NroSer,
                                                 INPUT Almdmov.NroDoc,
                                                 INPUT Almdmov.CodMat,
                                                 INPUT OOMoviAlmacen.CodUnd,
                                                 INPUT OOMoviAlmacen.SerialNumber,
                                                 INPUT OOMoviAlmacen.CanDes,
                                                 INPUT OOMoviAlmacen.Factor,
                                                 OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN  UNDO CICLO, RETURN 'ADM-ERROR'.
            DELETE PROCEDURE hProc.
/*             RUN Control-de-Series (OUTPUT pMensaje).                           */
/*             IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO CICLO, RETURN 'ADM-ERROR'. */
        END.
        /* ********************************************************* */
        /* RHC 03/02/2020 Bloqueamos B-MATE como registro de control */
        /* ********************************************************* */
        FIND B-MATE WHERE B-MATE.codcia = Almdmov.codcia AND
            B-MATE.codalm = Almdmov.codalm AND
            B-MATE.codmat = Almdmov.codmat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-MATE THEN DO:
            pMensaje = "Artículo " + Almdmov.codmat + " NO está asignado en el almacén " + Almdmov.codalm.
            UNDO CICLO, RETURN 'ADM-ERROR'.
        END.
        FIND B-MATE WHERE B-MATE.codcia = Almdmov.codcia AND
            B-MATE.codalm = Almdmov.codalm AND
            B-MATE.codmat = Almdmov.codmat EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="iCuenta"}
            UNDO CICLO, RETURN 'ADM-ERROR'.
        END.
        /* ********************************************************* */
        RUN alm/ALMACSTK (ROWID(Almdmov)).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = "ERROR:Stock (almacen " + ooMoviAlmacen.CodAlm + " mov " + 
                ooMoviAlmacen.TipMov + STRING(ooMoviAlmacen.CodMov) + " numero " + STRING(ooMoviAlmacen.NroSer, '999') +
                STRING(ooMoviAlmacen.NroDoc, '999999999') + " producto " + b-ooMoviAlmacen.CodMat + ")" + CHR(10) +
                'Proceso Abortado'.
            UNDO CICLO, RETURN 'ADM-ERROR'.
        END.
        /* RHC 31.03.04 REACTIVAMOS KARDEX POR ALMACEN */
        RUN alm/almacpr1 (ROWID(Almdmov), 'U').
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = "ERROR:Kardex (almacen " + ooMoviAlmacen.CodAlm + " mov " +
                ooMoviAlmacen.TipMov + STRING(ooMoviAlmacen.CodMov) + " numero " + STRING(ooMoviAlmacen.NroSer, '999') + 
                STRING(ooMoviAlmacen.NroDoc, '999999999') + " producto " + b-ooMoviAlmacen.CodMat + ")" + CHR(10) +
                'Proceso Abortado'.
            UNDO CICLO, RETURN 'ADM-ERROR'.
        END.
        /* **************************************************************************************** */
        /* Transferido */
        /* **************************************************************************************** */
        ASSIGN
            b-ooMoviAlmacen.FlagUsuario = s-User-Id
            b-ooMoviAlmacen.FlagFecha = TODAY
            b-ooMoviAlmacen.FlagHora = STRING(TIME,'HH:MM:SS')
            b-ooMoviAlmacen.FlagMigracion = "S".
    END.
    /* ********************************************************************************** */
    /* Importes */
    /* ********************************************************************************** */
    DEF VAR x-ImpLin AS DECI NO-UNDO.
    FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.coddoc = Almcmov.codref
        AND Ccbcdocu.nrodoc = Almcmov.nrorf1    /* OJO */
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbcdocu THEN DO:
        ASSIGN 
            Almcmov.CodCli = CcbCDocu.CodCli
            Almcmov.CodMon = CcbCDocu.CodMon
            Almcmov.CodVen = CcbCDocu.CodVen.
        FOR EACH Almdmov OF Almcmov EXCLUSIVE-LOCK,
            FIRST Ccbddocu OF Ccbcdocu NO-LOCK WHERE Ccbddocu.codmat = Almdmov.codmat:
            x-ImpLin = Ccbddocu.ImpLin - Ccbddocu.ImpDto2.
            ASSIGN
                Almdmov.PreUni = x-ImpLin / CcbDDocu.CanDes
                Almdmov.ImpLin = ROUND( Almdmov.PreUni * Almdmov.CanDes , 2 ) 
                Almdmov.AftIsc = CcbDDocu.AftIsc 
                Almdmov.AftIgv = CcbDDocu.AftIgv 
                .
            IF Almdmov.AftIgv THEN 
                Almdmov.ImpIgv = Almdmov.ImpLin - ROUND(Almdmov.ImpLin  / (1 + (Ccbcdocu.PorIgv / 100)),4).
        END.
        /* Se supone que ya se hizo en el control de barras */
/*         RUN Actualiza-Factura (INPUT 1, OUTPUT pMensaje).                                       */
/*         IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                                  */
/*             IF TRUE <> (pMensaje > '')  THEN pMensaje = 'NO se pudo actualizar el comprobante'. */
/*             UNDO, RETURN 'ADM-ERROR'.                                                           */
/*         END.                                                                                    */
    END.
    /* ********************************************************************************** */
END.
IF AVAILABLE(b-ooMoviAlmacen) THEN RELEASE b-ooMoviAlmacen.
IF AVAILABLE(B-MATE) THEN RELEASE B-MATE.

RETURN "OK".

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
  {src/adm/template/snd-list.i "T-MoviAlmacen"}
  {src/adm/template/snd-list.i "OOMoviAlmacen"}

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

