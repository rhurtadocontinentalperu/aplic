&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.



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
&SCOPED-DEFINE precio-venta-general pri/PrecioVentaMayorCredito.p

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF VAR x-CodDoc AS CHAR NO-UNDO.
DEF VAR x-NroDoc AS CHAR NO-UNDO.
DEF VAR x-CodDiv AS CHAR NO-UNDO.

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.

&SCOPED-DEFINE Condicion ( FacCPedi.CodCia = s-CodCia ~
    AND FacCPedi.CodDiv = x-CodDiv ~
    AND FacCPedi.CodDoc = x-CodDoc ~
    AND FacCPedi.NroPed BEGINS x-NroDoc )

DEF VAR s-cndvta-validos AS CHAR NO-UNDO.
DEF VAR pCodDiv AS CHAR NO-UNDO.
DEF VAR s-TpoPed AS CHAR NO-UNDO.
DEF VAR s-Import-B2B AS LOG NO-UNDO.
DEF VAR s-Import-IBC AS LOG NO-UNDO.
DEF VAR S-TPOMARCO AS CHAR NO-UNDO.
DEF VAR s-nrodec AS INTE NO-UNDO.
DEF VAR s-porigv AS DECI NO-UNDO.
DEF VAR s-codcli AS CHAR NO-UNDO.
DEF VAR S-CMPBNTE  AS CHAR NO-UNDO.
DEF VAR s-codmon AS INTE NO-UNDO.
DEF VAR s-fmapgo AS CHAR NO-UNDO.
DEF VAR s-acceso AS LOG NO-UNDO.

DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR x-articulo-ICBPer AS CHAR INIT '099268' NO-UNDO.

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
&Scoped-define INTERNAL-TABLES FacCPedi gn-ConVt

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.Libre_c02 FacCPedi.FmaPgo ~
gn-ConVt.Nombr FacCPedi.CodMon FacCPedi.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table FacCPedi.FmaPgo ~
FacCPedi.CodMon 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table FacCPedi
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define QUERY-STRING-br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table FacCPedi gn-ConVt
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacCPedi
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-ConVt


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
      FacCPedi, 
      gn-ConVt SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.Libre_c02 COLUMN-LABEL "Grupo" FORMAT "x(50)":U
      FacCPedi.FmaPgo FORMAT "X(8)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      gn-ConVt.Nombr FORMAT "X(50)":U
      FacCPedi.CodMon COLUMN-LABEL "Moneda" FORMAT "9":U WIDTH 11.29
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "SOLES",1,
                                      "DOLARES",2
                      DROP-DOWN-LIST 
      FacCPedi.ImpTot FORMAT "->>,>>>,>>9.99":U
  ENABLE
      FacCPedi.FmaPgo
      FacCPedi.CodMon
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 126 BY 8.08
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
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
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
         HEIGHT             = 9.77
         WIDTH              = 137.43.
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
     _TblList          = "INTEGRAL.FacCPedi,INTEGRAL.gn-ConVt WHERE INTEGRAL.FacCPedi ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST OUTER"
     _Where[1]         = "{&Condicion}"
     _JoinCode[2]      = "gn-ConVt.Codig = FacCPedi.FmaPgo"
     _FldNameList[1]   > INTEGRAL.FacCPedi.Libre_c02
"FacCPedi.Libre_c02" "Grupo" "x(50)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.FmaPgo
"FacCPedi.FmaPgo" ? ? "character" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.gn-ConVt.Nombr
     _FldNameList[4]   > INTEGRAL.FacCPedi.CodMon
"FacCPedi.CodMon" "Moneda" ? "integer" 11 0 ? ? ? ? yes ? no no "11.29" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "SOLES,1,DOLARES,2" 5 no 0 no no
     _FldNameList[5]   = INTEGRAL.FacCPedi.ImpTot
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


&Scoped-define SELF-NAME FacCPedi.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF FacCPedi.FmaPgo IN BROWSE br_table /* Condicion de!venta */
DO:
  /* Verificamos si la moneda de venta es fija o no */
  DEF BUFFER b-VtaTabla FOR VtaTabla.

  FacCPedi.CodMon:READ-ONLY IN BROWSE {&browse-name} = NO.
  FIND FIRST b-VtaTabla WHERE b-VtaTabla.CodCia = s-codcia 
      AND b-VtaTabla.Tabla = 'CONFIG-VTAS'
      AND b-VtaTabla.Llave_c1 = 'COND.VTA-LINEA-PLAZO'
      AND b-VtaTabla.Llave_c2 = SELF:SCREEN-VALUE
      AND b-VtaTabla.Llave_c6 = "ACTIVO"
      AND (TODAY >= b-VtaTabla.Rango_fecha[1] AND TODAY <= b-VtaTabla.Rango_fecha[2])
      AND LOOKUP(TRIM(b-VtaTabla.Llave_c3), FacCPedi.Libre_c02) > 0
      NO-LOCK NO-ERROR.
  IF AVAILABLE b-VtaTabla THEN DO:
      FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia
          AND VtaTabla.Tabla    = 'GRP_DIV_LIN'
          AND VtaTabla.Llave_c1 = pCodDiv
          AND Vtatabla.Libre_c01 = FacCPedi.Libre_c02
          NO-LOCK NO-ERROR.
      IF AVAILABLE VtaTabla THEN DO:
          CASE TRUE:
              WHEN b-VtaTabla.Llave_c4 = "COR" THEN DO:       /* Corto Plazo */
                  IF (VtaTabla.Valor[1] = 1 OR VtaTabla.Valor[1] = 2)  /* Fijo Soles o Dólares */ 
                      THEN DO:                                                                           
                          FacCPedi.CodMon:SCREEN-VALUE IN BROWSE {&browse-name} = STRING(VtaTabla.Valor[1]).
                          FacCPedi.CodMon:READ-ONLY IN BROWSE {&browse-name} = YES.
                  END.
              END.
              WHEN b-VtaTabla.Llave_c4 = "MED" THEN DO:       /* Mediano Plazo */
                  IF (VtaTabla.Valor[2] = 1 OR VtaTabla.Valor[2] = 2)  /* Fijo Soles o Dólares */ 
                      THEN DO:                                                                           
                          FacCPedi.CodMon:SCREEN-VALUE IN BROWSE {&browse-name} = STRING(VtaTabla.Valor[2]).
                          FacCPedi.CodMon:READ-ONLY IN BROWSE {&browse-name} = YES.
                  END.
              END.
              WHEN b-VtaTabla.Llave_c4 = "LAR" THEN DO:       /* Largo Plazo */
                  IF (VtaTabla.Valor[3] = 1 OR VtaTabla.Valor[3] = 2)  /* Fijo Soles o Dólares */ 
                      THEN DO:                                                                           
                          FacCPedi.CodMon:SCREEN-VALUE IN BROWSE {&browse-name} = STRING(VtaTabla.Valor[3]).
                          FacCPedi.CodMon:READ-ONLY IN BROWSE {&browse-name} = YES.
                  END.
              END.
          END CASE.
      END.
  END.
  FIND gn-convt WHERE gn-ConVt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt THEN DISPLAY gn-ConVt.Nombr WITH BROWSE {&browse-name}.
/*   FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia                                           */
/*       AND VtaTabla.Tabla    = 'GRP_DIV_LIN'                                                      */
/*       AND VtaTabla.Llave_c1 = pCodDiv                                                            */
/*       AND Vtatabla.Libre_c01 = FacCPedi.Libre_c02                                                */
/*       NO-LOCK NO-ERROR.                                                                          */
/*   FIND gn-convt WHERE gn-ConVt.Codig = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.                       */
/*   IF AVAILABLE gn-convt AND AVAILABLE VtaTabla THEN DO:                                          */
/*       CASE TRUE:                                                                                 */
/*           WHEN gn-convt.tipvta = "1"        /* Contado */                                        */
/*               AND (VtaTabla.Valor[1] = 1 OR VtaTabla.Valor[1] = 2)  /* Fijo Soles o Dólares */   */
/*               THEN DO:                                                                           */
/*               FacCPedi.CodMon:SCREEN-VALUE IN BROWSE {&browse-name} = STRING(VtaTabla.Valor[1]). */
/*               FacCPedi.CodMon:READ-ONLY IN BROWSE {&browse-name} = YES.                          */
/*           END.                                                                                   */
/*           WHEN gn-convt.tipvta = "2"          /* Crédito */                                      */
/*               AND (VtaTabla.Valor[2] = 1 OR VtaTabla.Valor[2] = 2)  /* Fijo Soles o Dólares */   */
/*               THEN DO:                                                                           */
/*               FacCPedi.CodMon:SCREEN-VALUE IN BROWSE {&browse-name} = STRING(VtaTabla.Valor[2]). */
/*               FacCPedi.CodMon:READ-ONLY IN BROWSE {&browse-name} = YES.                          */
/*           END.                                                                                   */
/*       END CASE.                                                                                  */
/*       DISPLAY gn-ConVt.Nombr WITH BROWSE {&browse-name}.                                         */
/*   END.                                                                                           */
  s-FmaPgo = SELF:SCREEN-VALUE.
  s-CodMon = INTEGER(FacCPedi.CodMon:SCREEN-VALUE IN BROWSE {&browse-name}).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.FmaPgo br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF FacCPedi.FmaPgo IN BROWSE br_table /* Condicion de!venta */
OR f8 OF FacCPedi.FmaPgo
DO:
    ASSIGN
        input-var-1 = s-cndvta-validos
        input-var-2 = ''
        input-var-3 = ''.
    RUN vta/d-cndvta.r.
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodMon br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF FacCPedi.CodMon IN BROWSE br_table /* Moneda */
DO:
  s-CodMon = INTEGER(SELF:SCREEN-VALUE).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Filtros B-table-Win 
PROCEDURE Captura-Filtros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDoc AS CHAR NO-UNDO.
DEF INPUT PARAMETER pNroDoc AS CHAR NO-UNDO.
DEF INPUT PARAMETER pCodDiv AS CHAR NO-UNDO.

ASSIGN
    x-CodDoc = pCodDoc
    x-NroDoc = pNroDoc
    x-CodDiv = pCodDiv.
FIND Faccpedi WHERE Faccpedi.codcia = s-codcia
    AND Faccpedi.coddiv = x-CodDiv
    AND Faccpedi.coddoc = REPLACE(x-CodDoc,'*','')
    AND Faccpedi.nroped = x-NroDoc
    NO-LOCK NO-ERROR.
s-acceso = NO.
IF AVAILABLE Faccpedi THEN s-acceso = (IF Faccpedi.flgest = "PV" THEN YES ELSE NO).

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DESCUENTOS-FINALES B-table-Win 
PROCEDURE DESCUENTOS-FINALES :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* ************************************************************************************** */
  /* DESCUENTOS APLICADOS A TODA LA COTIZACION */
  /* ************************************************************************************** */
  DEF VAR hProc AS HANDLE NO-UNDO.
  RUN vtagn/ventas-library PERSISTENT SET hProc.
  RUN DCTO_VOL_LINEA IN hProc (INPUT ROWID(Faccpedi),
                               INPUT s-TpoPed,
                               INPUT pCodDiv,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN DCTO_VOL_SALDO IN hProc (INPUT ROWID(Faccpedi),
                               INPUT s-TpoPed,
                               INPUT pCodDiv,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN DCTO_VOL_SALDO_EVENTO IN hProc (INPUT ROWID(Faccpedi),
                                      INPUT s-TpoPed,
                                      INPUT pCodDiv,
                                      OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  DELETE PROCEDURE hProc.

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
  EMPTY TEMP-TABLE ITEM.
  FOR EACH Facdpedi OF Faccpedi EXCLUSIVE-LOCK:
      CREATE ITEM.
      BUFFER-COPY Facdpedi TO ITEM.
      DELETE Facdpedi.
  END.
  /* Recalculamos Precios y Descuentos */
  RUN Recalcular-Precios.
  FOR EACH ITEM NO-LOCK:
      CREATE Facdpedi.
      BUFFER-COPY ITEM TO Facdpedi
          ASSIGN 
              Facdpedi.CodDoc = Faccpedi.CodDoc
              Facdpedi.NroPed = Faccpedi.NroPed
              Facdpedi.CodDiv = Faccpedi.CodDiv
              Facdpedi.FchPed = Faccpedi.FchPed
              Facdpedi.CodCli = Faccpedi.CodCli.
  END.
  /* ************************************************************************************** */
  /* DESCUENTOS APLICADOS A TODA LA COTIZACION */
  /* ************************************************************************************** */
  RUN DESCUENTOS-FINALES (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF TRUE <> (pMensaje > '') THEN pMensaje = 'ERROR al aplicar los descuentos totales a la cotización'.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  /* ****************************************************************************************** */
  /* RHC 09/06/2021 Verificamos si todos los productos cumplen con el margen mínimo de utilidad */
  /* ****************************************************************************************** */
  DEF VAR hProc AS HANDLE NO-UNDO.
  RUN pri/pri-librerias PERSISTENT SET hProc.
  RUN PRI_Valida-Margen-Utilidad-Total IN hProc (INPUT ROWID(Faccpedi), OUTPUT pMensaje).
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
  DELETE PROCEDURE hProc.
  /* ****************************************************************************************** */
  {vtagn/totales-cotizacion-unificada.i &Cabecera="Faccpedi" &Detalle="Facdpedi"}
  /* ****************************************************************************************** */


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
  FacCPedi.CodMon:READ-ONLY IN BROWSE {&browse-name} = NO.
  FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia
      AND VtaTabla.Tabla    = 'GRP_DIV_LIN'
      AND VtaTabla.Llave_c1 = pCodDiv
      AND Vtatabla.Libre_c01 = FacCPedi.Libre_c02
      NO-LOCK NO-ERROR.
  FIND gn-convt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt AND AVAILABLE VtaTabla THEN DO:
      CASE TRUE:
          WHEN gn-convt.tipvta = "1"        /* Contado */
              AND (VtaTabla.Valor[1] = 1 OR VtaTabla.Valor[1] = 2)  /* Fijo Soles o Dólares */
              THEN DO:
              FacCPedi.CodMon:READ-ONLY IN BROWSE {&browse-name} = YES.
          END.
          WHEN gn-convt.tipvta = "2"          /* Crédito */
              AND (VtaTabla.Valor[2] = 1 OR VtaTabla.Valor[2] = 2)  /* Fijo Soles o Dólares */
              THEN DO:
              FacCPedi.CodMon:READ-ONLY IN BROWSE {&browse-name} = YES.
          END.
      END CASE.
  END.

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
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_handle ('browse').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precio-TpoPed B-table-Win 
PROCEDURE Recalcular-Precio-TpoPed :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER pTpoPed AS CHAR.

    {vtagn/recalcular-cotizacion-unificada.i &pTpoPed=pTpoPed}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios B-table-Win 
PROCEDURE Recalcular-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* ************************************************************************ */
/* RHC 06/11/2017 NO recalcular precios para CANAL MODERNO NI LISTA EXPRESS */
/* ************************************************************************ */
IF s-TpoPed = "LF" THEN RETURN.     /* LISTA EXPRESS */
IF s-TpoPed = "S" AND s-Import-B2B = YES THEN RETURN.   /* SUPERMERCADOS */
IF s-TpoPed = "S" AND s-Import-IBC = YES THEN RETURN.   /* SUPERMERCADOS */
/*IF s-TpoPed = "S" AND s-Import-Cissac = YES THEN RETURN.   /* SUPERMERCADOS */*/
/* ******************************************************* */
/* ******************************************************* */
/* ARTIFICIO */
IF S-TPOMARCO = "SI" THEN RUN Recalcular-Precio-TpoPed ("M").
ELSE RUN Recalcular-Precio-TpoPed (s-TpoPed).

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
  {src/adm/template/snd-list.i "gn-ConVt"}

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

IF s-acceso = NO THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
RUN vtagn/p-fmapgo-valido-lineas.p (INPUT FacCPedi.Libre_c02,
                                    OUTPUT s-cndvta-validos).
/* IF FacCPedi.CodDiv = '00101' THEN DO:                      */
/*     /* WhatsApp */                                         */
/*     RUN vtagn/p-fmapgo-valido.r (Faccpedi.codcli,          */
/*                                  Faccpedi.tpoped,          */
/*                                  Faccpedi.CodDiv,          */
/*                                  OUTPUT s-cndvta-validos). */
/* END.                                                       */
/* ELSE DO:                                                   */
/*     RUN vtagn/p-fmapgo-valido.r (Faccpedi.codcli,          */
/*                                  Faccpedi.tpoped,          */
/*                                  Faccpedi.libre_c01,       */
/*                                  OUTPUT s-cndvta-validos). */
/* END.                                                       */

pCodDiv = (IF TRUE <> (Faccpedi.Libre_c01 > '') THEN Faccpedi.CodDiv ELSE Faccpedi.Libre_c01).

ASSIGN
    s-TpoPed = Faccpedi.TpoPed
    s-Import-IBC    = NO
    s-Import-B2B    = NO
    S-CODMON = FacCPedi.CodMon
    S-CODCLI = FacCPedi.CodCli
    S-FmaPgo = FacCPedi.FmaPgo
    s-PorIgv = Faccpedi.porigv
    s-NroDec = (IF Faccpedi.Libre_d01 <= 0 THEN 4 ELSE Faccpedi.Libre_d01)
    S-CMPBNTE = Faccpedi.Cmpbnte
    S-TPOMARCO = Faccpedi.Libre_C04.    /* CASO DE CLIENTES EXCEPCIONALES */

/* SOLO CANAL MODERNO */
IF s-TpoPed = "S" THEN DO:
    IF FacCPedi.Libre_C05 = "1" THEN s-Import-Ibc       = YES.
    IF FacCPedi.Libre_C05 = "3" THEN s-Import-B2B       = YES.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

