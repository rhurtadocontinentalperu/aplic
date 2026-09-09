&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI LIKE Facdpedi.
DEFINE TEMP-TABLE PEDI-1 NO-UNDO LIKE Facdpedi.



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
DEFINE SHARED VARIABLE S-NROPED   AS CHAR.
DEFINE SHARED VARIABLE s-FlgRotacion LIKE gn-divi.FlgRotacion.
DEFINE SHARED VARIABLE s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEFINE SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEFINE SHARED VARIABLE S-CODIGV  AS INT.
DEFINE SHARED VARIABLE s-PorIgv LIKE Ccbcdocu.PorIgv.

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

DEFINE BUFFER B-PEDI-1 FOR PEDI-1.

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
&Scoped-define INTERNAL-TABLES PEDI-1 Almmmatg AlmSFami

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table PEDI-1.NroItm PEDI-1.codmat ~
Almmmatg.DesMat Almmmatg.DesMar PEDI-1.Libre_c01 PEDI-1.UndVta ~
PEDI-1.Libre_d01 PEDI-1.CanPed PEDI-1.PreUni PEDI-1.PorDto ~
PEDI-1.Por_Dsctos[1] PEDI-1.Por_Dsctos[2] PEDI-1.Por_Dsctos[3] ~
PEDI-1.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table PEDI-1.CanPed 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table PEDI-1
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table PEDI-1
&Scoped-define QUERY-STRING-br_table FOR EACH PEDI-1 WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF PEDI-1 NO-LOCK, ~
      EACH AlmSFami OF Almmmatg ~
      WHERE (AlmSFami.SwDigesa = NO OR Almmmatg.VtoDigesa >= TODAY) NO-LOCK ~
    BY PEDI-1.NroItm
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH PEDI-1 WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF PEDI-1 NO-LOCK, ~
      EACH AlmSFami OF Almmmatg ~
      WHERE (AlmSFami.SwDigesa = NO OR Almmmatg.VtoDigesa >= TODAY) NO-LOCK ~
    BY PEDI-1.NroItm.
&Scoped-define TABLES-IN-QUERY-br_table PEDI-1 Almmmatg AlmSFami
&Scoped-define FIRST-TABLE-IN-QUERY-br_table PEDI-1
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almmmatg
&Scoped-define THIRD-TABLE-IN-QUERY-br_table AlmSFami


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table x-Grupo BUTTON-FILTRAR RECT-11 
&Scoped-Define DISPLAYED-OBJECTS x-Grupo F-TotBrt F-ImpExo F-ImpDes ~
F-ValVta F-ImpIsc F-ImpIgv F-ImpTot 

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

DEFINE VARIABLE F-ImpDes AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpExo AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpIgv AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpIsc AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ImpTot AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-TotBrt AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-ValVta AS DECIMAL FORMAT "Z,ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE x-Grupo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Selecciona el grupo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 153 BY 2.35.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      PEDI-1, 
      Almmmatg, 
      AlmSFami SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      PEDI-1.NroItm COLUMN-LABEL "No" FORMAT ">>>9":U
      PEDI-1.codmat COLUMN-LABEL "Articulo" FORMAT "X(8)":U
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 41.72
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(12)":U
      PEDI-1.Libre_c01 COLUMN-LABEL "Característica" FORMAT "x(20)":U
            COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
      PEDI-1.UndVta COLUMN-LABEL "Unidad" FORMAT "x(10)":U
      PEDI-1.Libre_d01 COLUMN-LABEL "Stock Disponible" FORMAT "->>>,>>>,>>9.99":U
            COLUMN-FGCOLOR 9 COLUMN-BGCOLOR 11
      PEDI-1.CanPed COLUMN-LABEL "Cantidad!Aprobada" FORMAT ">>,>>9.99":U
      PEDI-1.PreUni COLUMN-LABEL "Precio!Unitario" FORMAT ">>,>>9.9999":U
      PEDI-1.PorDto COLUMN-LABEL "% Dscto.!Incluido" FORMAT "->>9.99":U
      PEDI-1.Por_Dsctos[1] COLUMN-LABEL "% Dscto!Manual" FORMAT "->>9.99":U
      PEDI-1.Por_Dsctos[2] COLUMN-LABEL "% Dscto!Evento" FORMAT "->>9.99":U
      PEDI-1.Por_Dsctos[3] COLUMN-LABEL "% Dscto!Vol/Prom" FORMAT "->>9.99":U
      PEDI-1.ImpLin FORMAT ">,>>>,>>9.99":U
  ENABLE
      PEDI-1.CanPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 153 BY 9.96
         FONT 4 ROW-HEIGHT-CHARS .5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 2.35 COL 2
     x-Grupo AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 34
     BUTTON-FILTRAR AT ROW 1 COL 30 WIDGET-ID 36
     F-TotBrt AT ROW 13.96 COL 3 NO-LABEL WIDGET-ID 14
     F-ImpExo AT ROW 13.96 COL 19 NO-LABEL WIDGET-ID 4
     F-ImpDes AT ROW 13.96 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     F-ValVta AT ROW 13.92 COL 55 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     F-ImpIsc AT ROW 13.96 COL 74 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     F-ImpIgv AT ROW 13.96 COL 93 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     F-ImpTot AT ROW 13.96 COL 109 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     "I.G.V." VIEW-AS TEXT
          SIZE 5.14 BY .5 AT ROW 13.38 COL 97.72 WIDGET-ID 30
     "Total Importe" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 13.38 COL 111.14 WIDGET-ID 24
     "T.Descuento" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 13.38 COL 36.57 WIDGET-ID 20
     "T.Exonerado" VIEW-AS TEXT
          SIZE 9.43 BY .5 AT ROW 13.38 COL 19.43 WIDGET-ID 22
     "I.S.C." VIEW-AS TEXT
          SIZE 4.57 BY .5 AT ROW 13.38 COL 79.72 WIDGET-ID 28
     "Total Bruto" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 13.38 COL 4.86 WIDGET-ID 32
     "Valor Venta" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 13.38 COL 58.72 WIDGET-ID 26
     RECT-11 AT ROW 12.58 COL 2 WIDGET-ID 18
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
      TABLE: PEDI T "SHARED" ? INTEGRAL Facdpedi
      TABLE: PEDI-1 T "?" NO-UNDO INTEGRAL Facdpedi
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
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-ImpDes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ImpExo IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-ImpIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ImpIsc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TotBrt IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-ValVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.PEDI-1,INTEGRAL.Almmmatg OF Temp-Tables.PEDI-1,INTEGRAL.AlmSFami OF INTEGRAL.Almmmatg"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ",,"
     _OrdList          = "Temp-Tables.PEDI-1.NroItm|yes"
     _Where[3]         = "(AlmSFami.SwDigesa = NO OR Almmmatg.VtoDigesa >= TODAY)"
     _FldNameList[1]   > Temp-Tables.PEDI-1.NroItm
"PEDI-1.NroItm" "No" ">>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.PEDI-1.codmat
"PEDI-1.codmat" "Articulo" "X(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "41.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" "X(12)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.PEDI-1.Libre_c01
"PEDI-1.Libre_c01" "Característica" "x(20)" "character" 11 9 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.PEDI-1.UndVta
"PEDI-1.UndVta" "Unidad" "x(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.PEDI-1.Libre_d01
"PEDI-1.Libre_d01" "Stock Disponible" "->>>,>>>,>>9.99" "decimal" 11 9 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.PEDI-1.CanPed
"PEDI-1.CanPed" "Cantidad!Aprobada" ">>,>>9.99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.PEDI-1.PreUni
"PEDI-1.PreUni" "Precio!Unitario" ">>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.PEDI-1.PorDto
"PEDI-1.PorDto" "% Dscto.!Incluido" "->>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.PEDI-1.Por_Dsctos[1]
"PEDI-1.Por_Dsctos[1]" "% Dscto!Manual" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.PEDI-1.Por_Dsctos[2]
"PEDI-1.Por_Dsctos[2]" "% Dscto!Evento" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.PEDI-1.Por_Dsctos[3]
"PEDI-1.Por_Dsctos[3]" "% Dscto!Vol/Prom" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > Temp-Tables.PEDI-1.ImpLin
"PEDI-1.ImpLin" ? ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME PEDI-1.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI-1.codmat br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDI-1.codmat IN BROWSE br_table /* Articulo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    IF s-local-new-record = 'NO' AND SELF:SCREEN-VALUE = PEDI-1.codmat THEN RETURN.
    ASSIGN
        SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999")
        NO-ERROR.
    /* Valida Maestro Productos */
    FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
        AND Almmmatg.codmat = SELF:SCREEN-VALUE 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
       MESSAGE "Codigo de Articulo no Existe" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    IF Almmmatg.TpoArt <> "A" THEN DO:
       MESSAGE "Articulo no Activo" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    IF Almmmatg.Chr__01 = "" THEN DO:
       MESSAGE "Articulo no tiene unidad de Oficina" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    /* Valida Maestro Productos x Almacen */
    FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
        AND Almmmate.CodAlm = TRIM(S-CODALM) 
        AND Almmmate.CodMat = TRIM(SELF:SCREEN-VALUE) 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
       MESSAGE "Articulo no esta asignado al" SKIP
               "    ALMACEN : " S-CODALM VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.   
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PEDI-1.CanPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI-1.CanPed br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDI-1.CanPed IN BROWSE br_table /* Cantidad!Aprobada */
DO:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = PEDI-1.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK.
    x-CanPed = DEC(PEDI-1.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    IF x-CanPed = 0 THEN RETURN.
    RUN vta2/PrecioListaMayorista (
                            s-TpoPed,
                            s-CodDiv,
                            s-CodCli,
                            s-CodMon,
                            OUTPUT s-UndVta,
                            OUTPUT f-Factor,
                            Almmmatg.CodMat,
                            s-CndVta,
                            x-CanPed,
                            4,
                            OUTPUT f-PreBas,
                            OUTPUT f-PreVta,
                            OUTPUT f-Dsctos,
                            OUTPUT y-Dsctos,
                            OUTPUT z-Dsctos
                            ).
    DISPLAY 
        F-DSCTOS @ PEDI-1.PorDto
        F-PREVTA @ PEDI-1.PreUni 
        WITH BROWSE {&BROWSE-NAME}.
    DISPLAY 
        s-UndVta @ PEDI-1.UndVta 
        F-DSCTOS @ PEDI-1.PorDto
        F-PREVTA @ PEDI-1.PreUni 
        y-Dsctos @ PEDI-1.Por_Dsctos[3]
        z-Dsctos @ PEDI-1.Por_Dsctos[2]
        WITH BROWSE {&BROWSE-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME PEDI-1.PreUni
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PEDI-1.PreUni br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF PEDI-1.PreUni IN BROWSE br_table /* Precio!Unitario */
DO:
    IF F-PREVTA > DEC(PEDI-1.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) THEN DO:
       MESSAGE "No Autorizado para modificar Precio " 
       VIEW-AS ALERT-BOX ERROR.
       DISPLAY F-PREVTA @ PEDI-1.PreUni WITH BROWSE {&BROWSE-NAME}.
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF PEDI-1.CodMat, PEDI-1.CanPed
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

FOR EACH PEDI-1:
    DELETE PEDI-1.
END.
/* CONFIGURACIONES DE LA DIVISION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv NO-LOCK.

/* LISTAS DE PRECIOS */
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
    /* Valida lista de precios */
    IF gn-divi.VentaMayorista = 2 THEN DO:
        FIND Vtalistamay WHERE VtaListaMay.CodCia = s-codcia
            AND VtaListaMay.CodDiv = s-coddiv
            AND VtaListaMay.codmat = Vtadfammat.codmat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaListaMay THEN NEXT.
    END.
    /* Valida Maestro Productos x Almacen */
    FIND FIRST PEDI WHERE PEDI.codmat = Vtadfammat.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE PEDI THEN NEXT.
    CREATE PEDI-1.
    ASSIGN
        PEDI-1.CodCia = s-codcia
        PEDI-1.NroItm = VtaDFamMat.Secuencia
        PEDI-1.AlmDes = ENTRY(1, s-codalm)
        PEDI-1.CodMat = VtaDFamMat.codmat
        PEDI-1.UndVta = Almmmatg.UndBas
        PEDI-1.Libre_c01 = VtaDFamMat.Descripcion.
    DEF VAR pStkAct AS DEC NO-UNDO.
    RUN vtagn/p-stkact-01 (s-CodAlm, PEDI-1.CodMat, OUTPUT pStkAct).
    ASSIGN
        PEDI-1.Libre_d01 = pStkAct.
    DEF VAR pComprometido AS DEC NO-UNDO.
    RUN vtagn/stock-comprometido (PEDI-1.CodMat,
                               s-codalm,
                               OUTPUT pComprometido).
    ASSIGN
        PEDI-1.Libre_d01 = PEDI-1.Libre_d01 - pComprometido.

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
FOR EACH PEDI BY PEDI.NroItm:
    i = PEDI.NroItm + 1.
END.
FOR EACH PEDI-1 WHERE PEDI-1.CanPed > 0:
    CREATE PEDI.
    BUFFER-COPY PEDI-1 
        EXCEPT PEDI-1.Libre_d01 PEDI-1.Libre_c01
        TO PEDI
        ASSIGN PEDI.NroItm = i.
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
  FOR EACH B-PEDI-1:
    F-ImpTot = F-ImpTot + B-PEDI-1.ImpLin.
    F-Igv = F-Igv + B-PEDI-1.ImpIgv.
    F-Isc = F-Isc + B-PEDI-1.ImpIsc.
    IF NOT B-PEDI-1.AftIgv THEN F-ImpExo = F-ImpExo + B-PEDI-1.ImpLin.
    IF B-PEDI-1.AftIgv = YES
    THEN F-ImpDes = F-ImpDes + ROUND(B-PEDI-1.ImpDto / (1 + s-PorIgv / 100), 2).
    ELSE F-ImpDes = F-ImpDes + B-PEDI-1.ImpDto.
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
    PEDI-1.CodCia = s-CodCia
    PEDI-1.Factor = F-FACTOR
    PEDI-1.NroItm = I-NroItm
    PEDI-1.PreUni = DEC(PEDI-1.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    PEDI-1.PorDto = DEC(PEDI-1.PorDto:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    PEDI-1.Por_Dsctos[1] = DEC(PEDI-1.Por_Dsctos[1]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    PEDI-1.Por_Dsctos[2] = DEC(PEDI-1.Por_Dsctos[2]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    PEDI-1.Por_Dsctos[3] = DEC(PEDI-1.Por_Dsctos[3]:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    PEDI-1.PreBas = F-PreBas 
    PEDI-1.AftIgv = ( IF s-CodIgv = 1 THEN Almmmatg.AftIgv ELSE NO )
    PEDI-1.AftIsc = Almmmatg.AftIsc 
    PEDI-1.UndVta = PEDI-1.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
  ASSIGN
      PEDI-1.ImpLin = PEDI-1.CanPed * PEDI-1.PreUni * 
                    ( 1 - PEDI-1.Por_Dsctos[1] / 100 ) *
                    ( 1 - PEDI-1.Por_Dsctos[2] / 100 ) *
                    ( 1 - PEDI-1.Por_Dsctos[3] / 100 ).
  IF PEDI-1.Por_Dsctos[1] = 0 AND PEDI-1.Por_Dsctos[2] = 0 AND PEDI-1.Por_Dsctos[3] = 0 
      THEN PEDI-1.ImpDto = 0.
      ELSE PEDI-1.ImpDto = PEDI-1.CanPed * PEDI-1.PreUni - PEDI-1.ImpLin.
  ASSIGN
      PEDI-1.ImpLin = ROUND(PEDI-1.ImpLin, 2)
      PEDI-1.ImpDto = ROUND(PEDI-1.ImpDto, 2).
  IF PEDI-1.AftIsc 
  THEN PEDI-1.ImpIsc = ROUND(PEDI-1.PreBas * PEDI-1.CanPed * (Almmmatg.PorIsc / 100),4).
  ELSE PEDI-1.ImpIsc = 0.
  IF PEDI-1.AftIgv 
  THEN PEDI-1.ImpIgv = PEDI-1.ImpLin - ROUND( PEDI-1.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
  ELSE PEDI-1.ImpIgv = 0.

  PEDI-1.Libre_d01 = DECIMAL(PEDI-1.Libre_d01:SCREEN-VALUE IN BROWSE {&browse-name}).

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
  FOR EACH B-PEDI-1:
    F-FACTOR = B-PEDI-1.Factor.
    FIND Almmmatg WHERE 
         Almmmatg.CodCia = B-PEDI-1.CODCIA AND  
         Almmmatg.codmat = B-PEDI-1.codmat 
         NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
        x-CanPed = B-PEDI-1.CanPed.
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
            B-PEDI-1.PreBas = F-PreBas 
            B-PEDI-1.AftIgv = Almmmatg.AftIgv 
            B-PEDI-1.AftIsc = Almmmatg.AftIsc
            B-PEDI-1.PreUni = F-PREVTA
            B-PEDI-1.PorDto = F-DSCTOS
            B-PEDI-1.Por_Dsctos[2] = Almmmatg.PorMax
            B-PEDI-1.Por_Dsctos[3] = Y-DSCTOS 
            B-PEDI-1.ImpDto = ROUND( B-PEDI-1.PreBas * (F-DSCTOS / 100) * B-PEDI-1.CanPed , 2).
            B-PEDI-1.ImpLin = ROUND( B-PEDI-1.PreUni * B-PEDI-1.CanPed , 2 ).
       IF B-PEDI-1.AftIsc THEN 
          B-PEDI-1.ImpIsc = ROUND(B-PEDI-1.PreBas * B-PEDI-1.CanPed * (Almmmatg.PorIsc / 100),4).
       IF B-PEDI-1.AftIgv THEN  
          B-PEDI-1.ImpIgv = B-PEDI-1.ImpLin - ROUND(B-PEDI-1.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
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
  {src/adm/template/snd-list.i "PEDI-1"}
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
  
  IF DECIMAL(PEDI-1.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN RETURN 'OK'.
  IF DECIMAL(PEDI-1.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) < 0.125 THEN DO:
       MESSAGE "Cantidad debe ser mayor o igual a 0.25" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDI-1.CanPed.
       RETURN "ADM-ERROR".
  END.
  IF DECIMAL(PEDI-1.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDI-1.PreUni.
       RETURN "ADM-ERROR".
  END.
  IF PEDI-1.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
       MESSAGE "Codigo de Unidad no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
       APPLY 'ENTRY':U TO PEDI-1.CodMat.
  END.

  /* EMPAQUE */
  DEF VAR f-Canped AS DEC NO-UNDO.
  IF s-FlgEmpaque = YES THEN DO:
      IF s-VentaMayorista = 2 THEN DO:  /* LISTA POR DIVISION */
          FIND FIRST VtaListaMay OF Almmmatg WHERE Vtalistamay.coddiv = s-coddiv NO-LOCK NO-ERROR.
          IF AVAILABLE VtaListaMay AND Vtalistamay.CanEmp > 0 THEN DO:
              f-CanPed = DECIMAL(PEDI-1.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.
              f-CanPed = (TRUNCATE((f-CanPed / Vtalistamay.CanEmp),0) * Vtalistamay.CanEmp).
              IF f-CanPed <> DECIMAL(PEDI-1.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor THEN DO:
                  MESSAGE 'Solo puede vender en empaques de' Vtalistamay.CanEmp Almmmatg.UndBas
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO PEDI-1.CanPed.
                  RETURN "ADM-ERROR".
              END.
          END.
      END.
      ELSE DO:      /* LISTA GENERAL */
          IF Almmmatg.DEC__03 > 0 THEN DO:
              f-CanPed = DECIMAL(PEDI-1.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.
              f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).
              IF f-CanPed <> DECIMAL(PEDI-1.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor THEN DO:
                  MESSAGE 'Solo puede vender en empaques de' Almmmatg.DEC__03 Almmmatg.UndBas
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO PEDI-1.CanPed.
                  RETURN "ADM-ERROR".
              END.
          END.
      END.
  END.
  /* MINIMO DE VENTA */
  IF s-FlgMinVenta = YES THEN DO:
      f-CanPed = DECIMAL(PEDI-1.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.
      IF s-VentaMayorista = 2 THEN DO:  /* LISTA POR DIVISION */
          FIND FIRST VtaListaMay OF Almmmatg WHERE Vtalistamay.coddiv = s-coddiv NO-LOCK NO-ERROR.
          IF AVAILABLE VtaListaMay AND Vtalistamay.CanEmp > 0 THEN DO:
              IF f-CanPed < Vtalistamay.CanEmp THEN DO:
                  MESSAGE 'Solo puede vender como mínimo' Vtalistamay.CanEmp Almmmatg.UndBas
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO PEDI-1.CanPed.
                  RETURN "ADM-ERROR".
              END.
          END.
      END.
      ELSE DO:      /* LISTA GENERAL */
          IF Almmmatg.DEC__03 > 0 THEN DO:
              IF f-CanPed < Almmmatg.DEC__03 THEN DO:
                  MESSAGE 'Solo puede vender como mínimo' Almmmatg.DEC__03 Almmmatg.UndBas
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO PEDI-1.CanPed.
                  RETURN "ADM-ERROR".
              END.
          END.
      END.
  END.
  /* PRECIO UNITARIO */
  IF DECIMAL(PEDI-1.PreUni:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDI-1.CanPed.
       RETURN "ADM-ERROR".
  END.
  IF PEDI-1.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
       MESSAGE "Codigo de Unidad no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO PEDI-1.CanPed.
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
IF AVAILABLE PEDI-1
THEN ASSIGN
        i-nroitm = PEDI-1.NroItm
        f-Factor = PEDI-1.Factor
        f-PreBas = PEDI-1.PreBas
        f-PreVta = PEDI-1.PreUni.

s-local-new-record = 'NO'.
RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

