&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM LIKE Facdpedi.
DEFINE TEMP-TABLE ITEM-1 NO-UNDO LIKE Facdpedi.



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

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-CODDOC  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
DEFINE SHARED VARIABLE S-CODALM  AS CHAR.
DEFINE SHARED VARIABLE s-TpoPed  AS CHAR.
/* NOTA: s-codalm puede ser mas de uno */
DEFINE SHARED VARIABLE S-CNDVTA  AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB  AS DEC.
DEFINE SHARED VARIABLE s-adm-new-record AS CHAR.

DEFINE SHARED VARIABLE s-FlgRotacion LIKE gn-divi.FlgRotacion.
DEFINE SHARED VARIABLE s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEFINE SHARED VARIABLE s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE SHARED VARIABLE s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEFINE SHARED VARIABLE s-PorIgv LIKE Ccbcdocu.PorIgv.
/*DEFINE SHARED VARIABLE S-CODIGV  AS INT.*/
DEFINE SHARED VARIABLE s-NroDec AS INT.

/* Variable de control porque falla el browse cuando esá activo
    Add-Multiple-Records 
*/    
DEFINE VARIABLE s-local-new-record AS CHAR INIT 'YES'.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE S-UNDBAS AS CHAR NO-UNDO.
DEFINE VARIABLE S-UNDVTA AS CHAR NO-UNDO.
DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE I-NroItm AS INTE NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE SW-LOG1  AS LOGI NO-UNDO.
DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.

DEFINE BUFFER B-ITEM-1 FOR ITEM-1.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE NEW SHARED VARIABLE output-var-4 LIKE FacDPedi.PreUni.
DEFINE NEW SHARED VARIABLE output-var-5 LIKE FacDPedi.PorDto.

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
&Scoped-define INTERNAL-TABLES ITEM-1 Almmmatg AlmSFami

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ITEM-1.NroItm ITEM-1.codmat ~
Almmmatg.DesMat Almmmatg.DesMar ITEM-1.Libre_c01 ITEM-1.Libre_d01 ~
ITEM-1.UndVta ITEM-1.CanPed ITEM-1.PreUni ITEM-1.Por_Dsctos[1] ~
ITEM-1.Por_Dsctos[2] ITEM-1.Por_Dsctos[3] ITEM-1.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table ITEM-1.CanPed 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table ITEM-1
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table ITEM-1
&Scoped-define QUERY-STRING-br_table FOR EACH ITEM-1 WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF ITEM-1 NO-LOCK, ~
      EACH AlmSFami OF Almmmatg ~
      WHERE (AlmSFami.SwDigesa = NO OR Almmmatg.VtoDigesa >= TODAY) NO-LOCK ~
    BY ITEM-1.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH ITEM-1 WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF ITEM-1 NO-LOCK, ~
      EACH AlmSFami OF Almmmatg ~
      WHERE (AlmSFami.SwDigesa = NO OR Almmmatg.VtoDigesa >= TODAY) NO-LOCK ~
    BY ITEM-1.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table ITEM-1 Almmmatg AlmSFami
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ITEM-1
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-br_table AlmSFami


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-Grupo BUTTON-FILTRAR br_table 
&Scoped-Define DISPLAYED-OBJECTS x-Grupo 

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
DEFINE BUTTON BUTTON-FILTRAR 
     LABEL "ACTUALIZAR INFORMACION" 
     SIZE 23 BY 1.12.

DEFINE VARIABLE x-Grupo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Selecciona el grupo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      ITEM-1, 
      Almmmatg, 
      AlmSFami SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      ITEM-1.NroItm COLUMN-LABEL "No" FORMAT ">>>9":U
      ITEM-1.codmat COLUMN-LABEL "Articulo" FORMAT "X(8)":U
      Almmmatg.DesMat FORMAT "X(60)":U WIDTH 41.72
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(20)":U
      ITEM-1.Libre_c01 COLUMN-LABEL "Característica" FORMAT "x(20)":U
      ITEM-1.Libre_d01 COLUMN-LABEL "Stock Disponible" FORMAT "->>>,>>>,>>9.99":U
      ITEM-1.UndVta COLUMN-LABEL "Unidad" FORMAT "x(10)":U WIDTH 6
      ITEM-1.CanPed COLUMN-LABEL "Cantidad!Aprobada" FORMAT ">>,>>9.99":U
            WIDTH 8.29
      ITEM-1.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT ">>,>>9.9999":U
      ITEM-1.Por_Dsctos[1] COLUMN-LABEL "% Dscto!Manual" FORMAT "->>9.99":U
            WIDTH 6.72
      ITEM-1.Por_Dsctos[2] COLUMN-LABEL "% Dscto!Evento" FORMAT "->>9.99":U
            WIDTH 6.43
      ITEM-1.Por_Dsctos[3] COLUMN-LABEL "% Dscto!Vol/Prom" FORMAT "->>9.99":U
      ITEM-1.ImpLin FORMAT ">,>>>,>>9.99":U WIDTH 8.29
  ENABLE
      ITEM-1.CanPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SIZE 153 BY 11.31
         FONT 4 ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-Grupo AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 34
     BUTTON-FILTRAR AT ROW 1 COL 30 WIDGET-ID 36
     br_table AT ROW 2.35 COL 2
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
      TABLE: ITEM T "SHARED" ? INTEGRAL Facdpedi
      TABLE: ITEM-1 T "?" NO-UNDO INTEGRAL Facdpedi
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
         HEIGHT             = 15.54
         WIDTH              = 154.86.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
/* BROWSE-TAB br_table BUTTON-FILTRAR F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.ITEM-1,INTEGRAL.Almmmatg OF Temp-Tables.ITEM-1,INTEGRAL.AlmSFami OF INTEGRAL.Almmmatg"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ",,"
     _OrdList          = "Temp-Tables.ITEM-1.NroItm|yes"
     _Where[3]         = "(AlmSFami.SwDigesa = NO OR Almmmatg.VtoDigesa >= TODAY)"
     _FldNameList[1]   > Temp-Tables.ITEM-1.NroItm
"ITEM-1.NroItm" "No" ">>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ITEM-1.codmat
"ITEM-1.codmat" "Articulo" "X(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "41.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ITEM-1.Libre_c01
"ITEM-1.Libre_c01" "Característica" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ITEM-1.Libre_d01
"ITEM-1.Libre_d01" "Stock Disponible" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ITEM-1.UndVta
"ITEM-1.UndVta" "Unidad" "x(10)" "character" ? ? ? ? ? ? no ? no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ITEM-1.CanPed
"ITEM-1.CanPed" "Cantidad!Aprobada" ">>,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no "8.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ITEM-1.PreUni
"ITEM-1.PreUni" "Precio!Unitario" ">>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.ITEM-1.Por_Dsctos[1]
"ITEM-1.Por_Dsctos[1]" "% Dscto!Manual" ? "decimal" ? ? ? ? ? ? no ? no no "6.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.ITEM-1.Por_Dsctos[2]
"ITEM-1.Por_Dsctos[2]" "% Dscto!Evento" ? "decimal" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.ITEM-1.Por_Dsctos[3]
"ITEM-1.Por_Dsctos[3]" "% Dscto!Vol/Prom" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.ITEM-1.ImpLin
"ITEM-1.ImpLin" ? ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME ITEM-1.UndVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM-1.UndVta br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM-1.UndVta IN BROWSE br_table /* Unidad */
DO:
    SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    IF NOT AVAILABLE Almmmatg THEN RETURN.
    ASSIGN 
        F-FACTOR = 1
        X-CANPED = DEC(ITEM-1.CanPed:SCREEN-VALUE IN BROWSE {&browse-name})
        s-UndVta = SELF:SCREEN-VALUE.
    RUN vta2/PrecioMayorista-Cred (
        s-TpoPed,
        s-CodDiv,
        s-CodCli,
        s-CodMon,
        INPUT-OUTPUT s-UndVta,
        OUTPUT f-Factor,
        Almmmatg.CodMat,
        s-CndVta,
        x-CanPed,
        s-NroDec,
        OUTPUT f-PreBas,
        OUTPUT f-PreVta,
        OUTPUT f-Dsctos,
        OUTPUT y-Dsctos,
        OUTPUT z-Dsctos,
        OUTPUT x-TipDto,
        TRUE
        ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        s-UndVta = "".
        RUN vta2/PrecioMayorista-Cred (
            s-TpoPed,
            s-CodDiv,
            s-CodCli,
            s-CodMon,
            INPUT-OUTPUT s-UndVta,
            OUTPUT f-Factor,
            Almmmatg.CodMat,
            s-CndVta,
            x-CanPed,
            s-NroDec,
            OUTPUT f-PreBas,
            OUTPUT f-PreVta,
            OUTPUT f-Dsctos,
            OUTPUT y-Dsctos,
            OUTPUT z-Dsctos,
            OUTPUT x-TipDto,
            TRUE
            ).
        SELF:SCREEN-VALUE = s-UndVta.
        RETURN NO-APPLY.
    END.
    DISPLAY 
        F-PREVTA @ ITEM-1.PreUni 
        z-Dsctos @ ITEM-1.Por_Dsctos[2]
        y-Dsctos @ ITEM-1.Por_Dsctos[3]
        WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM-1.UndVta br_table _BROWSE-COLUMN B-table-Win
ON LEFT-MOUSE-DBLCLICK OF ITEM-1.UndVta IN BROWSE br_table /* Unidad */
DO:
    IF AVAILABLE Almmmatg THEN DO:
        ASSIGN
            input-var-1 = Almmmatg.UndStk
            input-var-2 = ""
            input-var-3 = "".
        RUN lkup/c-equivl ("Unidades válidas").
        IF output-var-1 <> ? THEN DO:
            SELF:SCREEN-VALUE = output-var-2.
            RETURN NO-APPLY.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM-1.CanPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM-1.CanPed br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM-1.CanPed IN BROWSE br_table /* Cantidad!Aprobada */
DO:
    x-CanPed = DEC(ITEM-1.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    IF x-CanPed = 0 THEN RETURN.
    s-UndVta = ITEM-1.UndVta:SCREEN-VALUE IN BROWSE {&browse-name}.
    RUN vta2/PrecioMayorista-Cred (
        s-TpoPed,
        s-CodDiv,
        s-CodCli,
        s-CodMon,
        INPUT-OUTPUT s-UndVta,
        OUTPUT f-Factor,
        Almmmatg.CodMat,
        s-CndVta,
        x-CanPed,
        s-NroDec,
        OUTPUT f-PreBas,
        OUTPUT f-PreVta,
        OUTPUT f-Dsctos,
        OUTPUT y-Dsctos,
        OUTPUT z-Dsctos,
        OUTPUT x-TipDto,
        TRUE
        ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    DISPLAY 
        F-PREVTA @ ITEM-1.PreUni 
        z-Dsctos @ ITEM-1.Por_Dsctos[2]
        y-Dsctos @ ITEM-1.Por_Dsctos[3]
        WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM-1.PreUni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM-1.PreUni br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM-1.PreUni IN BROWSE br_table /* Precio!Unitario */
DO:
    IF F-PREVTA > DEC(ITEM-1.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) THEN DO:
       MESSAGE "No Autorizado para modificar Precio " 
       VIEW-AS ALERT-BOX ERROR.
       DISPLAY F-PREVTA @ ITEM-1.PreUni WITH BROWSE {&BROWSE-NAME}.
       RETURN NO-APPLY.   
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-FILTRAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-FILTRAR B-table-Win
ON CHOOSE OF BUTTON-FILTRAR IN FRAME F-Main /* ACTUALIZAR INFORMACION */
DO:
  ASSIGN x-Grupo.
  RUN Carga-Temporal.
  x-Grupo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  BUTTON-FILTRAR:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-Grupo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-Grupo B-table-Win
ON LEFT-MOUSE-DBLCLICK OF x-Grupo IN FRAME F-Main /* Selecciona el grupo */
DO:
  ASSIGN
      input-var-1 = ""
      input-var-2 = ""
      input-var-3 = "".
  RUN lkup/c-vtacfammat-01 ("Códigos agrupados").
  IF output-var-1 <> ?  THEN SELF:SCREEN-VALUE = Output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF ITEM-1.CodMat, ITEM-1.UndVta,  ITEM-1.CanPed
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ITEM-1.
/* CONFIGURACIONES DE LA DIVISION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv NO-LOCK.

/* LISTAS DE PRECIOS */
/*
    RUN vta2/PrecioMayorista-Cred (
        s-TpoPed,
        s-CodDiv,
        s-CodCli,
        s-CodMon,
        INPUT-OUTPUT s-UndVta,
        OUTPUT f-Factor,
        Almmmatg.CodMat,
        s-CndVta,
        x-CanPed,
        s-NroDec,
        OUTPUT f-PreBas,
        OUTPUT f-PreVta,
        OUTPUT f-Dsctos,
        OUTPUT y-Dsctos,
        OUTPUT z-Dsctos,
        OUTPUT x-TipDto,
        TRUE
        ).
*/
FOR EACH Vtadfammat NO-LOCK WHERE VtaDFamMat.CodCia = s-codcia
    AND VtaDFamMat.grupo = x-Grupo,
    FIRST Almmmatg OF Vtadfammat NO-LOCK WHERE Almmmatg.TpoArt <= s-FlgRotacion:
    /* VALIDACION DE ARTICULO */
    IF Almmmatg.Chr__01 = "" THEN NEXT.
    FIND Almtfami OF Almmmatg NO-LOCK NO-ERROR.
    IF AVAILABLE Almtfami AND Almtfami.SwComercial = NO THEN NEXT.
    FIND Almsfami OF Almmmatg NO-LOCK NO-ERROR.
    IF AVAILABLE Almsfami AND AlmSFami.SwDigesa = YES 
      AND (Almmmatg.VtoDigesa = ? OR Almmmatg.VtoDigesa < TODAY) THEN NEXT.
    /* VALIDA LISTA DE PRECIOS */
    RUN vta2/PrecioMayorista-Cred (
        s-TpoPed,
        s-CodDiv,
        s-CodCli,
        s-CodMon,
        INPUT-OUTPUT s-UndVta,
        OUTPUT f-Factor,
        Almmmatg.CodMat,
        s-CndVta,
        1,
        2,
        OUTPUT f-PreBas,
        OUTPUT f-PreVta,
        OUTPUT f-Dsctos,
        OUTPUT y-Dsctos,
        OUTPUT z-Dsctos,
        OUTPUT x-TipDto,
        FALSE
        ).
    IF f-PreVta = 0 THEN NEXT.
    /* Valida Maestro Productos x Almacen */
    FIND FIRST ITEM WHERE ITEM.codmat = Vtadfammat.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE ITEM THEN NEXT.
    CREATE ITEM-1.
    ASSIGN
        ITEM-1.CodCia = s-codcia
        ITEM-1.NroItm = VtaDFamMat.Secuencia
        ITEM-1.AlmDes = ENTRY(1, s-codalm)
        ITEM-1.CodMat = VtaDFamMat.codmat
        ITEM-1.UndVta = Almmmatg.UndBas
        ITEM-1.Libre_c01 = VtaDFamMat.Descripcion.
    DEF VAR pStkAct AS DEC NO-UNDO.
    RUN vtagn/p-stkact-01 (s-CodAlm, ITEM-1.CodMat, OUTPUT pStkAct).
    ASSIGN
        ITEM-1.Libre_d01 = pStkAct.
    DEF VAR pComprometido AS DEC NO-UNDO.
    RUN vtagn/stock-comprometido (ITEM-1.CodMat,
                               s-codalm,
                               OUTPUT pComprometido).
    ASSIGN
        ITEM-1.Libre_d01 = ITEM-1.Libre_d01 - pComprometido.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Temporal B-table-Win 
PROCEDURE Graba-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR i AS INT NO-UNDO.

i = 1.
FOR EACH ITEM BY ITEM.NroItm:
    i = ITEM.NroItm + 1.
END.
FOR EACH ITEM-1 WHERE ITEM-1.CanPed > 0:
    CREATE ITEM.
    BUFFER-COPY ITEM-1 
        EXCEPT ITEM-1.Libre_d01 ITEM-1.Libre_c01
        TO ITEM
        ASSIGN ITEM.NroItm = i.
    i = i + 1.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-Total B-table-Win 
PROCEDURE Imp-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
  DEFINE VARIABLE F-IGV AS DECIMAL INIT 0 NO-UNDO.
  DEFINE VARIABLE F-ISC AS DECIMAL INIT 0 NO-UNDO.

  ASSIGN 
    F-ImpDes = 0
    F-ImpExo = 0
    F-ImpIgv = 0
    F-ImpIsc = 0
    F-ImpTot = 0
    F-TotBrt = 0
    F-ValVta = 0.
  FOR EACH B-ITEM-1:
    F-ImpTot = F-ImpTot + B-ITEM-1.ImpLin.
    F-Igv = F-Igv + B-ITEM-1.ImpIgv.
    F-Isc = F-Isc + B-ITEM-1.ImpIsc.
    IF NOT B-ITEM-1.AftIgv THEN F-ImpExo = F-ImpExo + B-ITEM-1.ImpLin.
    IF B-ITEM-1.AftIgv = YES
    THEN F-ImpDes = F-ImpDes + ROUND(B-ITEM-1.ImpDto / (1 + s-PorIgv / 100), 2).
    ELSE F-ImpDes = F-ImpDes + B-ITEM-1.ImpDto.
  END.
  F-ImpIgv = ROUND(F-Igv,2).
  F-ImpIsc = ROUND(F-Isc,2).
  F-ValVta = F-ImpTot - F-ImpExo - F-ImpIgv.
  F-TotBrt = F-ValVta + F-ImpIsc + F-ImpDes + F-ImpExo.
  DISPLAY F-ImpDes
        F-ImpExo
        F-ImpIgv
        F-ImpIsc
        F-ImpTot
        F-TotBrt
        F-ValVta WITH FRAME {&FRAME-NAME}.
*/
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
    ITEM-1.CodCia = s-CodCia
    ITEM-1.Factor = F-FACTOR
    ITEM-1.NroItm = I-NroItm
    ITEM-1.PreUni = DEC(ITEM-1.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    /*ITEM-1.PorDto = DEC(ITEM-1.PorDto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})*/
    ITEM-1.Por_Dsctos[1] = DEC(ITEM-1.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    ITEM-1.Por_Dsctos[2] = DEC(ITEM-1.Por_Dsctos[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    ITEM-1.Por_Dsctos[3] = DEC(ITEM-1.Por_Dsctos[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    ITEM-1.PreBas = F-PreBas 
    ITEM-1.AftIgv = Almmmatg.AftIgv
    ITEM-1.AftIsc = Almmmatg.AftIsc 
    ITEM-1.UndVta = ITEM-1.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
  ASSIGN
      ITEM-1.ImpLin = ITEM-1.CanPed * ITEM-1.PreUni * 
                    ( 1 - ITEM-1.Por_Dsctos[1] / 100 ) *
                    ( 1 - ITEM-1.Por_Dsctos[2] / 100 ) *
                    ( 1 - ITEM-1.Por_Dsctos[3] / 100 ).
  IF ITEM-1.Por_Dsctos[1] = 0 AND ITEM-1.Por_Dsctos[2] = 0 AND ITEM-1.Por_Dsctos[3] = 0 
      THEN ITEM-1.ImpDto = 0.
      ELSE ITEM-1.ImpDto = ITEM-1.CanPed * ITEM-1.PreUni - ITEM-1.ImpLin.
  ASSIGN
      ITEM-1.ImpLin = ROUND(ITEM-1.ImpLin, 2)
      ITEM-1.ImpDto = ROUND(ITEM-1.ImpDto, 2).
  IF ITEM-1.AftIsc 
  THEN ITEM-1.ImpIsc = ROUND(ITEM-1.PreBas * ITEM-1.CanPed * (Almmmatg.PorIsc / 100),4).
  ELSE ITEM-1.ImpIsc = 0.
  IF ITEM-1.AftIgv 
  THEN ITEM-1.ImpIgv = ITEM-1.ImpLin - ROUND( ITEM-1.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
  ELSE ITEM-1.ImpIgv = 0.

  ITEM-1.Libre_d01 = DECIMAL(ITEM-1.Libre_d01:SCREEN-VALUE IN BROWSE {&browse-name}).

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record B-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  s-local-new-record = 'YES'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Enable-Head'). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Imp-Total.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Imp-Total.

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
  RUN Imp-Total.
  RUN Procesa-Handle IN lh_handle ('Enable-Head').
  s-local-new-record = 'YES'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios B-table-Win 
PROCEDURE Recalcular-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH B-ITEM-1:
    F-FACTOR = B-ITEM-1.Factor.
    FIND Almmmatg WHERE 
         Almmmatg.CodCia = B-ITEM-1.CODCIA AND  
         Almmmatg.codmat = B-ITEM-1.codmat 
         NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
        x-CanPed = B-ITEM-1.CanPed.
        RUN vtamay/PrecioVenta (s-CodCia,
                            s-CodDiv,
                            s-CodCli,
                            s-CodMon,
                            s-TpoCmb,
                            f-Factor,
                            Almmmatg.CodMat,
                            s-CndVta,
                            x-CanPed,
                            4,
                            OUTPUT f-PreBas,
                            OUTPUT f-PreVta,
                            OUTPUT f-Dsctos,
                            OUTPUT y-Dsctos).
        ASSIGN 
            B-ITEM-1.PreBas = F-PreBas 
            B-ITEM-1.AftIgv = Almmmatg.AftIgv 
            B-ITEM-1.AftIsc = Almmmatg.AftIsc
            B-ITEM-1.PreUni = F-PREVTA
            B-ITEM-1.PorDto = F-DSCTOS
            B-ITEM-1.Por_Dsctos[2] = Almmmatg.PorMax
            B-ITEM-1.Por_Dsctos[3] = Y-DSCTOS 
            B-ITEM-1.ImpDto = ROUND( B-ITEM-1.PreBas * (F-DSCTOS / 100) * B-ITEM-1.CanPed , 2).
            B-ITEM-1.ImpLin = ROUND( B-ITEM-1.PreUni * B-ITEM-1.CanPed , 2 ).
       IF B-ITEM-1.AftIsc THEN 
          B-ITEM-1.ImpIsc = ROUND(B-ITEM-1.PreBas * B-ITEM-1.CanPed * (Almmmatg.PorIsc / 100),4).
       IF B-ITEM-1.AftIgv THEN  
          B-ITEM-1.ImpIgv = B-ITEM-1.ImpLin - ROUND(B-ITEM-1.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
    END.
  END.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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
  {src/adm/template/snd-list.i "ITEM-1"}
  {src/adm/template/snd-list.i "Almmmatg"}
  {src/adm/template/snd-list.i "AlmSFami"}

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
  
  IF DECIMAL(ITEM-1.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN RETURN 'OK'.
  IF DECIMAL(ITEM-1.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0.125 THEN DO:
       MESSAGE "Cantidad debe ser mayor o igual a 0.25" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM-1.CanPed.
       RETURN "ADM-ERROR".
  END.
  IF DECIMAL(ITEM-1.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM-1.PreUni.
       RETURN "ADM-ERROR".
  END.
  IF ITEM-1.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
       MESSAGE "Codigo de Unidad no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
       APPLY 'ENTRY':U TO ITEM-1.CodMat.
  END.

  /* EMPAQUE */
  DEF VAR f-Canped AS DEC NO-UNDO.
  IF s-FlgEmpaque = YES THEN DO:
      /* RHC 30.05.2012 solo una lista general */
/*       IF s-VentaMayorista = 2 THEN DO:  /* LISTA POR DIVISION */                                              */
/*           FIND FIRST VtaListaMay OF Almmmatg WHERE Vtalistamay.coddiv = s-coddiv NO-LOCK NO-ERROR.            */
/*           IF AVAILABLE VtaListaMay AND Vtalistamay.CanEmp > 0 THEN DO:                                        */
/*               f-CanPed = DECIMAL(ITEM-1.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.             */
/*               f-CanPed = (TRUNCATE((f-CanPed / Vtalistamay.CanEmp),0) * Vtalistamay.CanEmp).                  */
/*               IF f-CanPed <> DECIMAL(ITEM-1.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor THEN DO: */
/*                   MESSAGE 'Solo puede vender en empaques de' Vtalistamay.CanEmp Almmmatg.UndBas               */
/*                       VIEW-AS ALERT-BOX ERROR.                                                                */
/*                   APPLY 'ENTRY':U TO ITEM-1.CanPed.                                                           */
/*                   RETURN "ADM-ERROR".                                                                         */
/*               END.                                                                                            */
/*           END.                                                                                                */
/*       END.                                                                                                    */
/*       ELSE DO:      /* LISTA GENERAL */                                                                       */
/*           IF Almmmatg.DEC__03 > 0 THEN DO:                                                                    */
/*               f-CanPed = DECIMAL(ITEM-1.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.             */
/*               f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).                      */
/*               IF f-CanPed <> DECIMAL(ITEM-1.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor THEN DO: */
/*                   MESSAGE 'Solo puede vender en empaques de' Almmmatg.DEC__03 Almmmatg.UndBas                 */
/*                       VIEW-AS ALERT-BOX ERROR.                                                                */
/*                   APPLY 'ENTRY':U TO ITEM-1.CanPed.                                                           */
/*                   RETURN "ADM-ERROR".                                                                         */
/*               END.                                                                                            */
/*           END.                                                                                                */
/*       END.                                                                                                    */
      IF Almmmatg.DEC__03 > 0 THEN DO:
          f-CanPed = DECIMAL(ITEM-1.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.
          f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).
          IF f-CanPed <> DECIMAL(ITEM-1.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor THEN DO:
              MESSAGE 'Solo puede vender en empaques de' Almmmatg.DEC__03 Almmmatg.UndBas
                  VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO ITEM-1.CanPed.
              RETURN "ADM-ERROR".
          END.
      END.
  END.
  /* MINIMO DE VENTA */
  IF s-FlgMinVenta = YES THEN DO:
      f-CanPed = DECIMAL(ITEM-1.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.
/*       IF s-VentaMayorista = 2 THEN DO:  /* LISTA POR DIVISION */                                   */
/*           FIND FIRST VtaListaMay OF Almmmatg WHERE Vtalistamay.coddiv = s-coddiv NO-LOCK NO-ERROR. */
/*           IF AVAILABLE VtaListaMay AND Vtalistamay.CanEmp > 0 THEN DO:                             */
/*               IF f-CanPed < Vtalistamay.CanEmp THEN DO:                                            */
/*                   MESSAGE 'Solo puede vender como mínimo' Vtalistamay.CanEmp Almmmatg.UndBas       */
/*                       VIEW-AS ALERT-BOX ERROR.                                                     */
/*                   APPLY 'ENTRY':U TO ITEM-1.CanPed.                                                */
/*                   RETURN "ADM-ERROR".                                                              */
/*               END.                                                                                 */
/*           END.                                                                                     */
/*       END.                                                                                         */
/*       ELSE DO:      /* LISTA GENERAL */                                                            */
/*           IF Almmmatg.DEC__03 > 0 THEN DO:                                                         */
/*               IF f-CanPed < Almmmatg.DEC__03 THEN DO:                                              */
/*                   MESSAGE 'Solo puede vender como mínimo' Almmmatg.DEC__03 Almmmatg.UndBas         */
/*                       VIEW-AS ALERT-BOX ERROR.                                                     */
/*                   APPLY 'ENTRY':U TO ITEM-1.CanPed.                                                */
/*                   RETURN "ADM-ERROR".                                                              */
/*               END.                                                                                 */
/*           END.                                                                                     */
/*       END.                                                                                         */
      IF Almmmatg.DEC__03 > 0 THEN DO:
          IF f-CanPed < Almmmatg.DEC__03 THEN DO:
              MESSAGE 'Solo puede vender como mínimo' Almmmatg.DEC__03 Almmmatg.UndBas
                  VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO ITEM-1.CanPed.
              RETURN "ADM-ERROR".
          END.
      END.
  END.
  /* PRECIO UNITARIO */
  IF DECIMAL(ITEM-1.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM-1.CanPed.
       RETURN "ADM-ERROR".
  END.
  IF ITEM-1.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
       MESSAGE "Codigo de Unidad no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM-1.CanPed.
       RETURN "ADM-ERROR".
  END.
  /* CONTRATO MARCO NI REMATES NO TIENE MINIMO DE MARGEN DE UTILIDAD */
  IF LOOKUP(s-TpoPed, "M,R") > 0 THEN RETURN "OK".   
  /* RHC 13.12.2010 Margen de Utilidad */
  DEF VAR pError AS CHAR NO-UNDO.
  DEF VAR X-MARGEN AS DEC NO-UNDO.
  DEF VAR X-LIMITE AS DEC NO-UNDO.
  DEF VAR x-PreUni AS DEC NO-UNDO.

  x-PreUni = DECIMAL ( ITEM-1.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) *
      ( 1 - DECIMAL (ITEM-1.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) / 100 ) *
      ( 1 - DECIMAL (ITEM-1.Por_Dsctos[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} )/ 100 ) *
      ( 1 - DECIMAL (ITEM-1.Por_Dsctos[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} ) / 100 ) .
  
  RUN vtagn/p-margen-utilidad (
      ITEM-1.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},      /* Producto */
      x-PreUni,  /* Precio de venta unitario */
      ITEM-1.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME},
      s-CodMon,       /* Moneda de venta */
      s-TpoCmb,       /* Tipo de cambio */
      YES,            /* Muestra el error */
      "",
      OUTPUT x-Margen,        /* Margen de utilidad */
      OUTPUT x-Limite,        /* Margen mínimo de utilidad */
      OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
      ).
  IF pError = "ADM-ERROR" THEN DO:
      APPLY 'ENTRY':U TO ITEM-1.CanPed.
      RETURN "ADM-ERROR".
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
IF AVAILABLE ITEM-1
THEN ASSIGN
        i-nroitm = ITEM-1.NroItm
        f-Factor = ITEM-1.Factor
        f-PreBas = ITEM-1.PreBas
        f-PreVta = ITEM-1.PreUni.

s-local-new-record = 'NO'.
RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

