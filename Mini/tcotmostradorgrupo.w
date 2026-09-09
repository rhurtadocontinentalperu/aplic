&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE SHARED TEMP-TABLE PEDI NO-UNDO LIKE FacDPedi.



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
DEFINE BUFFER B-ITEM FOR PEDI.

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR S-CODDIV  AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR S-CODDOC  AS CHAR.
DEF SHARED VAR s-NroPed AS CHAR.
DEF SHARED VAR S-CODCLI  AS CHAR.
DEF SHARED VAR s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEF SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEF SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEF SHARED VAR S-CODMON  AS INTEGER.
DEF SHARED VAR S-TPOCMB  AS DEC.
DEF SHARED VAR s-FlgSit AS CHAR.
DEF SHARED VAR s-nrodec AS INT INIT 4.
DEF SHARED VAR s-PorIgv LIKE Ccbcdocu.PorIgv.
DEF SHARED VAR s-Promotor AS CHAR.

DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.
DEFINE VARIABLE f-FleteUnitario AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE s-adm-new-record AS CHAR INIT "NO".
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE S-UNDVTA AS CHAR NO-UNDO.
DEFINE SHARED VARIABLE s-TpoPed   AS CHAR.

DEFINE SHARED VARIABLE pGrupo  AS CHAR.
DEFINE SHARED VARIABLE pCodDiv AS CHAR.       /* División de Precios */
DEFINE SHARED VARIABLE S-FMAPGO  AS CHAR.

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
&Scoped-define INTERNAL-TABLES PEDI Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table PEDI.CodMatWeb PEDI.DesMatWeb ~
PEDI.UndVta PEDI.CanPed PEDI.PreUni ~
STRING(Almmmatg.StkMax,'ZZZ9') + '/' + STRING(Almmmatg.Libre_d03, 'ZZZ9') @ Almmmatg.Libre_c01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table PEDI.CanPed 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table PEDI
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table PEDI
&Scoped-define QUERY-STRING-br_table FOR EACH PEDI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg WHERE Almmmatg.CodCia = PEDI.CodCia ~
  AND Almmmatg.codmat = PEDI.CodMatWeb NO-LOCK ~
    BY PEDI.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PEDI WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almmmatg WHERE Almmmatg.CodCia = PEDI.CodCia ~
  AND Almmmatg.codmat = PEDI.CodMatWeb NO-LOCK ~
    BY PEDI.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table PEDI Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-br_table PEDI
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-DesMat FILL-IN-ImpTot 

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
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/down.ico":U
     LABEL "Button 1" 
     SIZE 9 BY 2.12.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/up.ico":U
     LABEL "Button 2" 
     SIZE 9 BY 2.12.

DEFINE VARIABLE EDITOR-DesMat AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 53 BY 3.85
     BGCOLOR 14 FGCOLOR 0 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpTot AS DECIMAL FORMAT "ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.15
     BGCOLOR 1 FGCOLOR 15 FONT 9 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      PEDI, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      PEDI.CodMatWeb COLUMN-LABEL "Artículo" FORMAT "x(6)":U
      PEDI.DesMatWeb COLUMN-LABEL "Descripción" FORMAT "x(20)":U
            WIDTH 16.57
      PEDI.UndVta FORMAT "x(5)":U
      PEDI.CanPed COLUMN-LABEL "Cant" FORMAT ">,>>9.99":U WIDTH 9.86
      PEDI.PreUni COLUMN-LABEL "Unit" FORMAT ">>>9.9999":U WIDTH 10.43
      STRING(Almmmatg.StkMax,'ZZZ9') + '/' + STRING(Almmmatg.Libre_d03, 'ZZZ9') @ Almmmatg.Libre_c01 COLUMN-LABEL "Min/Empaq"
            WIDTH 19.72
  ENABLE
      PEDI.CanPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SIZE 76 BY 13.85
         FONT 9 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     EDITOR-DesMat AT ROW 14.85 COL 1 NO-LABEL WIDGET-ID 6
     FILL-IN-ImpTot AT ROW 15.04 COL 53 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     BUTTON-1 AT ROW 16.58 COL 55 WIDGET-ID 8
     BUTTON-2 AT ROW 16.58 COL 65 WIDGET-ID 10
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
      TABLE: ITEM T "SHARED" ? INTEGRAL FacDPedi
      TABLE: PEDI T "SHARED" NO-UNDO INTEGRAL FacDPedi
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
         HEIGHT             = 19.65
         WIDTH              = 76.86.
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

/* SETTINGS FOR EDITOR EDITOR-DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.PEDI,INTEGRAL.Almmmatg WHERE Temp-Tables.PEDI ..."
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST"
     _OrdList          = "Temp-Tables.PEDI.NroItm|yes"
     _JoinCode[2]      = "INTEGRAL.Almmmatg.CodCia = Temp-Tables.PEDI.CodCia
  AND INTEGRAL.Almmmatg.codmat = Temp-Tables.PEDI.CodMatWeb"
     _FldNameList[1]   > Temp-Tables.PEDI.CodMatWeb
"PEDI.CodMatWeb" "Artículo" "x(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.PEDI.DesMatWeb
"PEDI.DesMatWeb" "Descripción" "x(20)" "character" ? ? ? ? ? ? no ? no no "16.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.PEDI.UndVta
"PEDI.UndVta" ? "x(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.PEDI.CanPed
"PEDI.CanPed" "Cant" ">,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no "9.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.PEDI.PreUni
"PEDI.PreUni" "Unit" ">>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"STRING(Almmmatg.StkMax,'ZZZ9') + '/' + STRING(Almmmatg.Libre_d03, 'ZZZ9') @ Almmmatg.Libre_c01" "Min/Empaq" ? ? ? ? ? ? ? ? no ? no no "19.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
    /* RHC 05/01/2018 pinta colores cuando hay descuentos adicionales */
    DEF BUFFER B-LISTA FOR VtaListaMay.
    DEF BUFFER B-TABLA FOR FacTabla.
    DEF VAR k AS INT NO-UNDO.
    FIND B-LISTA WHERE B-LISTA.codcia = s-codcia
        AND B-LISTA.coddiv = pCodDiv
        AND B-LISTA.codmat = PEDI.CodMatWeb
        NO-LOCK NO-ERROR.
    IF AVAILABLE B-LISTA THEN DO:
        /* Primero el descuento por volumen por producto */
        DO k = 1 TO 10:
            IF B-LISTA.DtoVolD[k] > 0 AND B-LISTA.DtoVolR[k] > 0 THEN DO:
                PEDI.CodMatWeb:BGCOLOR IN BROWSE {&BROWSE-NAME} = 10.
                PEDI.DesMatWeb:BGCOLOR IN BROWSE {&BROWSE-NAME} = 10.
                PEDI.CanPed:BGCOLOR IN BROWSE {&BROWSE-NAME} = 10.
                PEDI.PreUni:BGCOLOR IN BROWSE {&BROWSE-NAME} = 10.
                PEDI.UndVta:BGCOLOR IN BROWSE {&BROWSE-NAME} = 10.
                LEAVE.
            END.
        END.
        /* Segundo por dcto x vol total */
        FIND FIRST B-TABLA WHERE B-TABLA.codcia = s-codcia
            AND B-TABLA.codigo = TRIM(pCodDiv) + '|' +
            TRIM(Almmmatg.codfam) + '|' +
            TRIM(Almmmatg.subfam) NO-LOCK NO-ERROR.
        IF AVAILABLE B-TABLA THEN DO:
            DO k = 1 TO 10:
                IF B-TABLA.Valor[k] > 0 AND B-TABLA.Valor[k + 10] > 0 THEN DO:
                    PEDI.CodMatWeb:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14.
                    PEDI.DesMatWeb:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14.
                    PEDI.CanPed:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14.
                    PEDI.PreUni:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14.
                    PEDI.UndVta:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14.
                    LEAVE.
                END.
            END.
        END.

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

  IF AVAILABLE Almmmatg THEN RUN Pinta-Datos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PEDI.CanPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI.CanPed br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDI.CanPed IN BROWSE br_table /* Cant */
DO:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = PEDI.CodMatWeb:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN RETURN.
    ASSIGN
        x-CanPed = DEC(SELF:SCREEN-VALUE)
        s-UndVta = PEDI.UndVta:SCREEN-VALUE IN BROWSE {&browse-name}.
    RUN vta2/PrecioMayorista-Cred-v2 (
        s-TpoPed,
        pCodDiv,
        s-CodCli,
        s-CodMon,
        INPUT-OUTPUT s-UndVta,
        OUTPUT f-Factor,
        PEDI.codmatweb:SCREEN-VALUE IN BROWSE {&browse-name},
        s-FmaPgo,
        x-CanPed,
        s-NroDec,
        OUTPUT f-PreBas,
        OUTPUT f-PreVta,
        OUTPUT f-Dsctos,
        OUTPUT y-Dsctos,
        OUTPUT z-Dsctos,
        OUTPUT x-TipDto,
        OUTPUT f-FleteUnitario,
        "",
        TRUE
        ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    DISPLAY 
        F-PREVTA @ PEDI.PreUni 
        WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  APPLY 'PAGE-DOWN' TO {&browse-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 B-table-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  APPLY 'PAGE-UP' TO {&browse-name}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE PEDI.

FOR EACH ExpoGrupoDetail NO-LOCK WHERE ExpoGrupoDetail.CodCia = s-codcia
    AND ExpoGrupoDetail.Grupo = pGrupo,
    FIRST Almmmatg OF ExpoGrupoDetail NO-LOCK:
    CREATE PEDI.
    ASSIGN
        PEDI.codcia = s-codcia
        PEDI.CodMatWeb = ExpoGrupoDetail.CodMat 
        PEDI.NroItm = ExpoGrupoDetail.Secuencia
        PEDI.DesMatWeb = ExpoGrupoDetail.Descripcion
        PEDI.Libre_c05 = pGrupo.
    /* Veamos si ya hay algo grabado */
    FIND FIRST ITEM WHERE ITEM.codmat = PEDI.CodMatWeb
        AND ITEM.libre_c05 = pGrupo
        NO-LOCK NO-ERROR.
    IF AVAILABLE ITEM THEN 
        ASSIGN 
            PEDI.CanPed = ITEM.CanPed           /* Cantidad */
            PEDI.Libre_c03 = ITEM.Libre_c03.    /* Promotor */
    ASSIGN 
        F-FACTOR = 1
        X-CANPED = (IF PEDI.CanPed <= 0 THEN 1 ELSE PEDI.CanPed).
    RUN vta2/PrecioMayorista-Cred-v2 (
        s-TpoPed,
        pCodDiv,
        s-CodCli,
        s-CodMon,
        INPUT-OUTPUT s-UndVta,
        OUTPUT f-Factor,
        PEDI.CodMatWeb,
        s-FmaPgo,
        x-CanPed,
        s-NroDec,
        OUTPUT f-PreBas,
        OUTPUT f-PreVta,
        OUTPUT f-Dsctos,
        OUTPUT y-Dsctos,
        OUTPUT z-Dsctos,
        OUTPUT x-TipDto,
        OUTPUT f-FleteUnitario,
        "",
        TRUE
        ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    ASSIGN 
        PEDI.UndVta = s-UndVta
        PEDI.PreUni = f-PreVta
        PEDI.Por_Dsctos[1] = 0
        PEDI.Por_Dsctos[2] = z-Dsctos
        PEDI.Por_Dsctos[3] = y-Dsctos
        PEDI.Libre_d02     = f-FleteUnitario.
    ASSIGN
        PEDI.ImpLin = ROUND ( PEDI.CanPed * PEDI.PreUni * 
                      ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                      ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                      ( 1 - PEDI.Por_Dsctos[3] / 100 ), 2 ).
    IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
        THEN PEDI.ImpDto = 0.
        ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
    /* RHC 04/08/2015 Si existe f-FleteUnitario se recalcula el Descuento */
    IF f-FleteUnitario > 0 THEN DO:
        /* El flete afecta el monto final */
        IF PEDI.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
            ASSIGN
                PEDI.PreUni = ROUND(f-PreVta + f-FleteUnitario, s-NroDec)  /* Incrementamos el PreUni */
                PEDI.ImpLin = PEDI.CanPed * PEDI.PreUni.
        END.
        ELSE DO:      /* CON descuento promocional o volumen */
            ASSIGN
                PEDI.ImpLin = PEDI.ImpLin + (PEDI.CanPed * f-FleteUnitario)
                PEDI.PreUni = ROUND( (PEDI.ImpLin + PEDI.ImpDto) / PEDI.CanPed, s-NroDec).
        END.
    END.
    /* ***************************************************************** */

    ASSIGN
        PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
        PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
    IF PEDI.AftIsc 
    THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE PEDI.ImpIsc = 0.
    IF PEDI.AftIgv 
    THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
    ELSE PEDI.ImpIgv = 0.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-Total B-table-Win 
PROCEDURE Imp-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    FILL-IN-ImpTot = 0.
FOR EACH B-ITEM:
    FILL-IN-ImpTot = FILL-IN-ImpTot + B-ITEM.ImpLin.
END.
DISPLAY FILL-IN-ImpTot WITH FRAME {&FRAME-NAME}.

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
      PEDI.CodCia = S-CODCIA
      PEDI.AlmDes = s-CodAlm
      PEDI.Factor = F-FACTOR
      PEDI.PorDto = f-Dsctos
      PEDI.PreBas = F-PreBas 
      PEDI.PreVta[1] = F-PreVta     /* CONTROL DE PRECIO DE LISTA */
      PEDI.AftIgv = Almmmatg.AftIgv
      PEDI.AftIsc = Almmmatg.AftIsc
      PEDI.Libre_c04 = x-TipDto
      PEDI.Libre_c05 = pGrupo.
  ASSIGN 
      PEDI.UndVta = PEDI.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      PEDI.PreUni = DEC(PEDI.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      PEDI.Por_Dsctos[1] = 0
      PEDI.Por_Dsctos[2] = z-Dsctos
      PEDI.Por_Dsctos[3] = y-Dsctos
      PEDI.Libre_d02     = f-FleteUnitario.
  ASSIGN
      PEDI.ImpLin = ROUND ( PEDI.CanPed * PEDI.PreUni * 
                    ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                    ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                    ( 1 - PEDI.Por_Dsctos[3] / 100 ), 2 ).
  IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
      THEN PEDI.ImpDto = 0.
      ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
  /* RHC 04/08/2015 Si existe f-FleteUnitario se recalcula el Descuento */
  IF f-FleteUnitario > 0 THEN DO:
      /* El flete afecta el monto final */
      IF PEDI.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
          ASSIGN
              PEDI.PreUni = ROUND(f-PreVta + f-FleteUnitario, s-NroDec)  /* Incrementamos el PreUni */
              PEDI.ImpLin = PEDI.CanPed * PEDI.PreUni.
      END.
      ELSE DO:      /* CON descuento promocional o volumen */
          ASSIGN
              PEDI.ImpLin = PEDI.ImpLin + (PEDI.CanPed * f-FleteUnitario)
              PEDI.PreUni = ROUND( (PEDI.ImpLin + PEDI.ImpDto) / PEDI.CanPed, s-NroDec).
      END.
  END.
  /* ***************************************************************** */

  ASSIGN
      PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
      PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
  IF PEDI.AftIsc 
  THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
  ELSE PEDI.ImpIsc = 0.
  IF PEDI.AftIgv 
  THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
  ELSE PEDI.ImpIgv = 0.

  IF PEDI.PreUni = 0 THEN DO:
       MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDI.CodMatWeb.
       UNDO, RETURN "ADM-ERROR".
  END.
  /* ************************************ */
  /* Solo si no tiene promotor grabado */
  IF TRUE <> (PEDI.Libre_c03 > '') THEN PEDI.Libre_c03 = s-Promotor +  '|' + Almmmatg.codfam.

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
  IF AVAILABLE Almmmatg THEN RUN Pinta-Datos.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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
  RUN Imp-Total.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta-Datos B-table-Win 
PROCEDURE Pinta-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    EDITOR-DesMat:SCREEN-VALUE  = "DESCRIPCIÓN: " + Almmmatg.desmat + CHR(10).
    /* Mínimo de ventas */
    EDITOR-DesMat:SCREEN-VALUE  = EDITOR-DesMat:SCREEN-VALUE + "MÍNIMO DE VENTAS: " + STRING(Almmmatg.StkMax) + CHR(10).
    /* Empaque Master */
    EDITOR-DesMat:SCREEN-VALUE  = EDITOR-DesMat:SCREEN-VALUE + "EMPAQUE MASTER: " + STRING(Almmmatg.Libre_d03).
END.

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
  {src/adm/template/snd-list.i "PEDI"}
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

  FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
      AND  Almmmate.CodAlm = s-codalm
      AND  Almmmate.codmat = PEDI.CodMatWeb:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmate THEN DO:
      MESSAGE "Articulo no asignado al almacén " s-codalm
           VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO PEDI.CodMatWeb.
      RETURN "ADM-ERROR".
  END.

  /* CANTIDAD */
  IF PEDI.UndVta:SCREEN-VALUE IN BROWSE {&browse-name} = "UNI" 
      AND DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) -
            TRUNCATE(DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}), 0) <> 0
      THEN DO:
      MESSAGE "NO se permiten ventas fraccionadas" VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO PEDI.CanPed.
      RETURN "ADM-ERROR".
  END.
  /* FACTOR DE EQUIVALENCIA */
  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
      AND Almtconv.Codalter = PEDI.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almtconv THEN DO:
      MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
          'Unidad de venta:' PEDI.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO PEDI.UndVta.
      RETURN "ADM-ERROR".
  END.
  F-FACTOR = Almtconv.Equival.

  /* STOCK COMPROMETIDO */
  DEF VAR s-StkComprometido AS DEC NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.

  RUN vta2/Stock-Comprometido-v2 (PEDI.CodMatWeb:SCREEN-VALUE IN BROWSE {&browse-name}, 
                                s-codalm, 
                                OUTPUT s-StkComprometido).
  IF s-adm-new-record = 'NO' THEN DO:
      FIND Facdpedi WHERE Facdpedi.codcia = s-codcia
          AND Facdpedi.coddoc = s-coddoc
          AND Facdpedi.nroped = s-nroped
          AND Facdpedi.codmat = PEDI.CodMatWeb:SCREEN-VALUE IN BROWSE {&browse-name}
          NO-LOCK NO-ERROR.
      IF AVAILABLE Facdpedi THEN s-StkComprometido = s-StkComprometido - ( Facdpedi.CanPed * Facdpedi.Factor ).
  END.
  ASSIGN
      x-CanPed = DEC(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * f-Factor
      x-StkAct = Almmmate.StkAct.

  /* EMPAQUE */
  IF DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > 0
      AND DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0.125 THEN DO:
      MESSAGE "Cantidad debe ser mayor o igual a 0.125" VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO PEDI.CanPed.
      RETURN "ADM-ERROR".
  END.
  
  DEF VAR f-Canped AS DEC NO-UNDO.
  /* CONTROL DE EMPAQUE */
  IF s-FlgEmpaque = YES THEN DO:
      DEF VAR pSugerido AS DEC NO-UNDO.
      DEF VAR pEmpaque AS DEC NO-UNDO.
      f-CanPed = DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.
      RUN vtagn/p-cantidad-sugerida.p (s-TpoPed, Almmmatg.CodMat, f-CanPed, OUTPUT pSugerido, OUTPUT pEmpaque).
      CASE s-TpoPed:
          WHEN "E" THEN DO:     /* Caso EXPOLIBRERIAS */
              f-CanPed = pSugerido / f-Factor.
              PEDI.CanPed:SCREEN-VALUE IN BROWSE {&browse-name} = STRING(f-CanPed).
          END.
          OTHERWISE DO:         /* Todos los demás casos */
              /* RHC solo se va a trabajar con una lista general */
              IF pEmpaque > 0 THEN DO:
                  f-CanPed = TRUNCATE((f-CanPed / pEmpaque),0) * pEmpaque.
                  IF f-CanPed <> DECIMAL(PEDI.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor THEN DO:
                      MESSAGE 'Solo puede vender en empaques de' pEmpaque Almmmatg.UndBas
                          VIEW-AS ALERT-BOX ERROR.
                      APPLY 'ENTRY':U TO PEDI.CanPed.
                      RETURN "ADM-ERROR".
                  END.
              END.
          END.
      END CASE.
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

