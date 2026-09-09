&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER BCPEDI FOR FacCPedi.
DEFINE BUFFER BDPEDI FOR FacDPedi.



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
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'PPD' NO-UNDO.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

&SCOPED-DEFINE condicion faccpedi.codcia = s-codcia ~
AND faccpedi.coddiv = s-coddiv ~
AND faccpedi.coddoc = s-coddoc ~
AND faccpedi.flgest = 'P'

DEF VAR x-ImpBD AS de NO-UNDO.
DEF VAR x-ImpCot LIKE Faccpedi.imptot NO-UNDO.

/* 07.09.09 Variable para el Tracking */
DEFINE VAR s-FechaI AS DATETIME NO-UNDO.
DEFINE VAR s-FechaT AS DATETIME NO-UNDO.

DEF VAR s-Inicia-Busqueda AS LOGIC INIT FALSE.
DEF VAR s-Registro-Actual AS ROWID.

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
&Scoped-define INTERNAL-TABLES FacCPedi ExpPromotor

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.NroRef FacCPedi.NroPed ~
FacCPedi.CodVen FacCPedi.FmaPgo FacCPedi.CodCli FacCPedi.NomCli ~
_ImpCot() @ x-ImpCot FacCPedi.ImpTot FacCPedi.Libre_d02 _ImpBD() @ x-ImpBD 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&condicion} NO-LOCK, ~
      EACH ExpPromotor WHERE ExpPromotor.CodCia = FacCPedi.CodCia ~
  AND ExpPromotor.CodDiv = FacCPedi.CodDiv ~
  AND ExpPromotor.CodVen = FacCPedi.CodVen ~
  AND ExpPromotor.Usuario = s-user-id NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&condicion} NO-LOCK, ~
      EACH ExpPromotor WHERE ExpPromotor.CodCia = FacCPedi.CodCia ~
  AND ExpPromotor.CodDiv = FacCPedi.CodDiv ~
  AND ExpPromotor.CodVen = FacCPedi.CodVen ~
  AND ExpPromotor.Usuario = s-user-id NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table FacCPedi ExpPromotor
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table ExpPromotor


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-10 BUTTON-11 BUTTON-7 BUTTON-8 ~
FILL-IN-NomCli br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NomCli f-Mensaje 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _ImpBD B-table-Win 
FUNCTION _ImpBD RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD _ImpCot B-table-Win 
FUNCTION _ImpCot RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-10 
     LABEL "Buscar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-11 
     LABEL "Buscar Siguiente" 
     SIZE 16 BY 1.12.

DEFINE BUTTON BUTTON-7 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-8 
     LABEL "ELIMINAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 79 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     LABEL "Nombre:" 
     VIEW-AS FILL-IN 
     SIZE 32 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      FacCPedi, 
      ExpPromotor SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.NroRef COLUMN-LABEL "Cotizacion" FORMAT "X(9)":U
            WIDTH 10
      FacCPedi.NroPed COLUMN-LABEL "Pre-Pedido" FORMAT "X(9)":U
            WIDTH 10
      FacCPedi.CodVen FORMAT "x(5)":U
      FacCPedi.FmaPgo COLUMN-LABEL "Condicion" FORMAT "X(4)":U
      FacCPedi.CodCli FORMAT "x(11)":U WIDTH 13
      FacCPedi.NomCli FORMAT "x(50)":U
      _ImpCot() @ x-ImpCot COLUMN-LABEL "Importe Cotizacion" FORMAT "->>,>>>,>>9.99":U
      FacCPedi.ImpTot COLUMN-LABEL "Importe Pre-Pedido" FORMAT "->>,>>>,>>9.99":U
      FacCPedi.Libre_d02 COLUMN-LABEL "Importe Negociado" FORMAT "->>>,>>>,>>9.99<<<":U
      _ImpBD() @ x-ImpBD COLUMN-LABEL "Saldo de Depósitos!y Notas de Crédito"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 142 BY 6.69
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-10 AT ROW 1 COL 42 WIDGET-ID 8
     BUTTON-11 AT ROW 1 COL 57 WIDGET-ID 10
     BUTTON-7 AT ROW 1 COL 73 WIDGET-ID 12
     BUTTON-8 AT ROW 1 COL 88 WIDGET-ID 14
     FILL-IN-NomCli AT ROW 1.27 COL 7 COLON-ALIGNED WIDGET-ID 6
     br_table AT ROW 2.35 COL 1
     f-Mensaje AT ROW 9.35 COL 2 NO-LABEL WIDGET-ID 4
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
      TABLE: BCPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: BDPEDI B "?" ? INTEGRAL FacDPedi
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
         HEIGHT             = 11.27
         WIDTH              = 146.14.
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
/* BROWSE-TAB br_table FILL-IN-NomCli F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.FacCPedi,INTEGRAL.ExpPromotor WHERE INTEGRAL.FacCPedi ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "{&condicion}"
     _JoinCode[2]      = "ExpPromotor.CodCia = FacCPedi.CodCia
  AND ExpPromotor.CodDiv = FacCPedi.CodDiv
  AND ExpPromotor.CodVen = FacCPedi.CodVen
  AND ExpPromotor.Usuario = s-user-id"
     _FldNameList[1]   > INTEGRAL.FacCPedi.NroRef
"FacCPedi.NroRef" "Cotizacion" ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Pre-Pedido" ? "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.CodVen
"FacCPedi.CodVen" ? "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.FmaPgo
"FacCPedi.FmaPgo" "Condicion" "X(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = INTEGRAL.FacCPedi.NomCli
     _FldNameList[7]   > "_<CALC>"
"_ImpCot() @ x-ImpCot" "Importe Cotizacion" "->>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacCPedi.ImpTot
"FacCPedi.ImpTot" "Importe Pre-Pedido" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacCPedi.Libre_d02
"FacCPedi.Libre_d02" "Importe Negociado" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"_ImpBD() @ x-ImpBD" "Saldo de Depósitos!y Notas de Crédito" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 B-table-Win
ON CHOOSE OF BUTTON-10 IN FRAME F-Main /* Buscar */
DO:
    ASSIGN
      s-Inicia-Busqueda = YES
      s-Registro-Actual = ?
      FILL-IN-NomCli.
    FOR EACH FacCPedi NO-LOCK WHERE {&condicion},
            EACH ExpPromotor OF FacCPedi NO-LOCK:
      IF INDEX(FacCPedi.nomcli, FILL-IN-NomCli:SCREEN-VALUE) > 0
      THEN DO:
          ASSIGN
              s-Registro-Actual = ROWID(FacCPedi).
          REPOSITION {&BROWSE-NAME} TO ROWID s-Registro-Actual.
          LEAVE.
      END.
    END.      
    IF s-Registro-Actual = ? THEN MESSAGE 'Fin de búsqueda' VIEW-AS ALERT-BOX WARNING.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-11 B-table-Win
ON CHOOSE OF BUTTON-11 IN FRAME F-Main /* Buscar Siguiente */
DO:
    IF s-Registro-Actual = ? THEN RETURN.
    GET NEXT {&BROWSE-NAME}.
    REPEAT WHILE AVAILABLE FacCPedi:
      IF INDEX(FacCPedi.nomcli, FILL-IN-NomCli:SCREEN-VALUE) > 0
      THEN DO:
          ASSIGN
              s-Registro-Actual = ROWID(FacCPedi).
              REPOSITION {&BROWSE-NAME} TO ROWID s-Registro-Actual.
              LEAVE.
      END.
      GET NEXT {&BROWSE-NAME}.
    END.
    IF NOT AVAILABLE FacCPedi THEN s-Registro-Actual = ?.
    IF s-Registro-Actual = ? THEN MESSAGE 'Fin de búsqueda' VIEW-AS ALERT-BOX WARNING.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 B-table-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* REFRESCAR */
DO:
   RUN dispatch IN THIS-PROCEDURE ('open-query').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 B-table-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* ELIMINAR */
DO:
  MESSAGE 'Está seguro?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = YES THEN RUN eliminar IN THIS-PROCEDURE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Eliminar B-table-Win 
PROCEDURE Eliminar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.

    /* extornamos cotizaciones */
    RUN gn/actualiza-cotizacion ( ROWID(FacCPedi) , -1 ).       /* Descarga COT */
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    ASSIGN Faccpedi.flgest = 'A'.
    FIND CURRENT Faccpedi NO-LOCK.
    RUN dispatch IN THIS-PROCEDURE ('open-query').
END.


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
  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
  DEFINE VARIABLE S-OK AS LOG INIT NO.
  DEFINE VARIABLE S-STKDIS AS DEC INIT 0.
  DEFINE VARIABLE x-StkAct AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC NO-UNDO.

  FOR EACH BDPEDI OF BCPEDI WHERE BDPEDI.Libre_d02 > 0,
      FIRST Almmmatg OF BDPEDI NO-LOCK,
      FIRST Almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia
      AND Almmmate.codalm = BDPEDI.AlmDes
      AND Almmmate.codmat = BDPEDI.CodMat
      BY BDPEDI.NroItm: 

      /* RUTINA QUE VERIFICA NUEVAMENTE EL STOCK DISPONIBLE Y AJUSTA LA CANTIDAD EN CASO NECESARIO */
      x-StkAct = Almmmate.StkAct.
      RUN gn/Stock-Comprometido (BDPEDI.CodMat, BDPEDI.AlmDes, OUTPUT s-StkComprometido).
      s-StkDis = x-StkAct - s-StkComprometido.
      IF s-StkDis < BDPEDI.Libre_d02 THEN DO:
          MESSAGE 'Se agotó el stock del material' BDPEDI.codmat SKIP
              'El IMPORTE TOTAL del pedido será recalculado'
              VIEW-AS ALERT-BOX WARNING.
          NEXT.
      END.

      I-NITEM = I-NITEM + 1.
      CREATE Facdpedi.
      BUFFER-COPY BDPEDI 
          EXCEPT BDPEDI.CanAte
          TO Facdpedi
          ASSIGN
            FacDPedi.CodCia = FacCPedi.CodCia
            FacDPedi.CodDiv = FacCPedi.CodDiv
            FacDPedi.coddoc = FacCPedi.coddoc
            FacDPedi.NroPed = FacCPedi.NroPed
            FacDPedi.FchPed = FacCPedi.FchPed
            FacDPedi.Hora   = FacCPedi.Hora 
            FacDPedi.FlgEst = FacCPedi.FlgEst
            FacDPedi.NroItm = I-NITEM
            FacDPedi.CanPed = BDPEDI.Libre_d02
            FacDpedi.Libre_d02 = FacDPedi.CanPed.      /* CONTROL */
      ASSIGN
          Facdpedi.ImpLin = Facdpedi.CanPed * Facdpedi.PreUni * 
                    ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                    ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                    ( 1 - Facdpedi.Por_Dsctos[3] / 100 ).
      IF Facdpedi.Por_Dsctos[1] = 0 AND Facdpedi.Por_Dsctos[2] = 0 AND Facdpedi.Por_Dsctos[3] = 0 
          THEN Facdpedi.ImpDto = 0.
      ELSE Facdpedi.ImpDto = Facdpedi.CanPed * Facdpedi.PreUni - Facdpedi.ImpLin.
      ASSIGN
          Facdpedi.ImpLin = ROUND(Facdpedi.ImpLin, 2)
          Facdpedi.ImpDto = ROUND(Facdpedi.ImpDto, 2).
      IF Facdpedi.AftIsc 
      THEN Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
      IF Facdpedi.AftIgv 
      THEN Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND(Facdpedi.ImpLin  / (1 + (Faccpedi.PorIgv / 100)),4).
  END.
  /* verificamos que al menos exista 1 item grabado */
  FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi 
  THEN RETURN 'ADM-ERROR'.
  ELSE RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedidos B-table-Win 
PROCEDURE Genera-Pedidos :
/*------------------------------------------------------------------------------
  Purpose:     Se va a generar 1 a la vez
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* CONSISTENCIA */
DEF VAR x-ImpBD     AS de NO-UNDO.
DEF VAR F-Tot       AS DEC.

s-FechaI = DATETIME(TODAY, MTIME).

IF NOT AVAILABLE FacCPedi THEN RETURN.

IF Faccpedi.Libre_d02 <= 0 THEN DO:
    MESSAGE 'NO hay proyección para la cotización' Faccpedi.nroref
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

/* filtro por importe */
DEF VAR pImpMin AS DEC NO-UNDO.
RUN gn/pMinCotPed (Faccpedi.CodCia,
                 Faccpedi.CodDiv,
                 Faccpedi.CodDoc,
                 OUTPUT pImpMin).
/* ****************** */
f-Tot = Faccpedi.Libre_d02.
IF Faccpedi.codmon = 2 THEN f-Tot = f-Tot * Faccpedi.tpocmb.
IF pImpMin > 0 AND f-Tot < pImpMin THEN DO:
  MESSAGE 'El importe del pedido debe superar los S/.' pImpMin
      VIEW-AS ALERT-BOX WARNING.
  RETURN 'ADM-ERROR'.
END.
/* ****************** */
/* FILTRO DE ACUERDO A LA CONDICION DE VENTA: (1) CONTADO   O   (2) CREDITO */
FIND Gn-convt WHERE gn-ConVt.Codig = Faccpedi.fmapgo NO-LOCK.
CASE gn-ConVt.TipVta:
    WHEN '1' THEN DO:           /* CONTADO */
        IF Faccpedi.FmaPgo <> '001' THEN DO:    /* MENOS CONTRAENTREGA */
            x-ImpBD = _ImpBD().
            IF x-ImpBD <= 0 THEN DO:
                MESSAGE 'NO hay ningún depósito para la cotización' Faccpedi.nroref
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            IF x-ImpBD < Faccpedi.Libre_d02 THEN DO:
                MESSAGE 'El depósito NO cubre la cotizacion' Faccpedi.nroref
                    VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
        END.
    END.
    WHEN '2' THEN DO:
    END.
END CASE.
    

/* VERIFICAMOS LA LINEA DE CREDITO EN TODOS LOS CASOS */
f-Tot = Faccpedi.Libre_d02.
DEF VAR t-Resultado AS CHAR NO-UNDO.
RUN gn/linea-de-credito ( Faccpedi.CodCli,
                          f-Tot,
                          Faccpedi.CodMon,
                          Faccpedi.FmaPgo,
                          TRUE,
                          OUTPUT t-Resultado).
IF t-Resultado = 'ADM-ERROR' THEN DO:
    RETURN "ADM-ERROR".   
END.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND BCPEDI WHERE ROWID(BCPEDI) = ROWID(FacCPedi) EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE BCPEDI THEN RETURN 'ADM-ERROR'.
    FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
        AND FacCorre.CodDoc = 'PED'
        AND FacCorre.CodDiv = S-CODDIV 
        AND Faccorre.Codalm = BCPEDI.CodAlm
        AND Faccorre.FlgEst = YES
      EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN DO:
        MESSAGE 'NO existe el correlativo para el PEDIDO'
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    CREATE Faccpedi.
    BUFFER-COPY BCPEDI TO Faccpedi
        ASSIGN 
            FacCPedi.CodCia = s-codcia
            FacCPedi.CodDiv = s-coddiv
            FacCPedi.CodDoc = 'PED' 
            FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            FacCPedi.FchPed = TODAY 
            FacCPedi.NroRef = BCPEDI.NroRef
            FacCPedi.FlgEst = 'G'
            FacCPedi.TpoPed = '1'.
    ASSIGN
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
    ASSIGN 
          FacCPedi.Hora = STRING(TIME,"HH:MM")
          FacCPedi.Usuario = S-USER-ID
          FacCPedi.CodAlm = BCPEDI.CodAlm.

    /* TRACKING */
    FIND Almacen OF Faccpedi NO-LOCK.
    s-FechaT = DATETIME(TODAY, MTIME).
    RUN vtagn/pTracking-04 (s-CodCia,
                         Almacen.CodDiv,
                     Faccpedi.CodDoc,
                     Faccpedi.NroPed,
                     s-User-Id,
                     'GNP',
                     'P',
                     DATETIME(TODAY, MTIME),
                     DATETIME(TODAY, MTIME),
                     Faccpedi.coddoc,
                     Faccpedi.nroped,
                     Faccpedi.codref,
                     Faccpedi.nroref).

    RUN Genera-Detalle.     /* Detalle del pedido */ 
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        MESSAGE 'NO se pudo generar el pedido' SKIP
            'NO hay stock suficiente en los almacenes' VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.

    RUN Graba-Totales.

    /* Verificacion del Cliente */
    RUN Verifica-Cliente.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    /* Actualiza COTIZACION */
    RUN gn/actualiza-cotizacion ( ROWID(BCPEDI) , -1 ).         /* Descarga COT */
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

    RUN gn/actualiza-cotizacion ( ROWID(FacCPedi) , +1 ).       /* Carga COT */
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    
    ASSIGN
        BCPEDI.FlgEst = 'C'.    /* CERRADO */

    RELEASE FacCorre.     /* OJO */
    RELEASE BCPEDI.
END.

RUN dispatch IN THIS-PROCEDURE ('open-query').
RUN dispatch IN THIS-PROCEDURE ('row-changed').

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

{vta/graba-totales.i}

/*
{vtaexp/graba-totales.i}
*/

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
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "ExpPromotor"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Cliente B-table-Win 
PROCEDURE Verifica-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vtamay/verifica-cliente.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _ImpBD B-table-Win 
FUNCTION _ImpBD RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR pSdoMn1 AS DEC NO-UNDO.     /* Saldo de los docs en S/. */
DEF VAR pSdoMn2 AS DEC NO-UNDO.     /* Saldo de los docs en US$ */
DEF VAR pSdoAct AS DEC NO-UNDO.

  RUN gn/saldo-por-doc-cli (Faccpedi.codcli,
                            'BD',
                            s-coddiv,
                            OUTPUT pSdoMn1,
                            OUTPUT pSdoMn2).

  FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK.
  IF Faccpedi.codmon = 1
  THEN pSdoAct = pSdoMn1 + pSdoMn2 * gn-tcmb.Venta.
  ELSE pSdoAct = pSdoMn2 + pSdoMn1 / gn-tcmb.Compra.

  /* RHC 14.12.09 incrementamos los saldos por antipos */
  RUN gn/saldo-por-doc-cli (Faccpedi.codcli,
                            'A/R',
                            s-coddiv,
                            OUTPUT pSdoMn1,
                            OUTPUT pSdoMn2).
  IF Faccpedi.codmon = 1
  THEN pSdoAct = pSdoAct + ( pSdoMn1 + pSdoMn2 * gn-tcmb.Venta ).
  ELSE pSdoAct = pSdoAct + ( pSdoMn2 + pSdoMn1 / gn-tcmb.Compra ).

   RUN gn/saldo-por-doc-cli (Faccpedi.codcli,
                             'N/C',
                             s-coddiv,
                             OUTPUT pSdoMn1,
                             OUTPUT pSdoMn2).
   IF Faccpedi.codmon = 1
   THEN pSdoAct = pSdoAct + ( pSdoMn1 + pSdoMn2 * gn-tcmb.Venta ).
   ELSE pSdoAct = pSdoAct + ( pSdoMn2 + pSdoMn1 / gn-tcmb.Compra ).

  RETURN pSdoAct.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION _ImpCot B-table-Win 
FUNCTION _ImpCot RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
FIND BCPEDI WHERE BCPEDI.codcia = Faccpedi.codcia
    AND BCPEDI.coddoc = 'COT'
    AND BCPEDI.nroped = Faccpedi.nroref
    NO-LOCK NO-ERROR.
IF AVAILABLE BCPEDI THEN RETURN BCPEDI.imptot.
  RETURN 0.00.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

