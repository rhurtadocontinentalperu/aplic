&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-RutaC FOR DI-RutaC.
DEFINE BUFFER B-RutaD FOR DI-RutaD.
DEFINE TEMP-TABLE T-RUTAD NO-UNDO LIKE DI-RutaD
       FIELD LugEnt AS CHAR
       FIELD SKU AS INT
       FIELD FchEnt AS DATE
       FIELD Docs AS INT
       FIELD Estado AS CHAR
       FIELD Reprogramado AS LOG INITIAL NO
       FIELD PtoDestino as char
       FIELD Departamento AS CHAR.
DEFINE BUFFER X-DI-RutaC FOR DI-RutaC.



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
DEF SHARED VAR S-CODCIA AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR lh_handle AS HANDLE.

DEF VAR x-Cuadrante AS CHAR NO-UNDO.
DEF VAR x-Departamento AS CHAR NO-UNDO.
DEF VAR x-Distrito AS CHAR NO-UNDO.
DEF VAR x-SKU AS INT NO-UNDO.
DEF VAR x-Docs AS INT NO-UNDO.
DEF VAR x-Estado AS CHAR NO-UNDO.

DEF VAR x-Reprogramado AS LOGICAL FORMAT "SI/NO" NO-UNDO.

DEF TEMP-TABLE TT-RUTAD LIKE T-RUTAD.

DEFINE BUFFER x-faccpedi FOR faccpedi.

/* SORT */
define var x-sort-direccion as char init "".
define var x-sort-column as char init "".
define var x-sort-command as char init "".

DEFINE VAR x-sort-acumulativo AS LOG INIT NO.           /* Indica si add columna */
DEFINE VAR x-sort-color-reset AS LOG INIT YES.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-5

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES DI-RutaC
&Scoped-define FIRST-EXTERNAL-TABLE DI-RutaC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR DI-RutaC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-RUTAD X-DI-RUTAC FacCPedi GN-DIVI DI-RutaD

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 FacCPedi.Cliente_Recoge FacCPedi.EmpaqEspec t-RutaD.Departamento @ x-Departamento t-rutad.ptodestino @ x-Distrito T-RUTAD.CodRef T-RUTAD.NroRef FacCPedi.FchPed FacCPedi.Hora FacCPedi.FchEnt FacCPedi.NomCli T-RUTAD.Estado @ x-Estado T-RUTAD.SKU @ x-SKU T-RUTAD.Libre_c01 T-RUTAD.Libre_d02 T-RUTAD.Libre_d01 T-RUTAD.ImpCob T-RUTAD.libre_c02 FacCPedi.Glosa fLugEnt() @ FacCPedi.LugEnt Faccpedi.CodRef Faccpedi.nroref   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 T-RUTAD.Libre_d01   
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-5 T-RUTAD
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-5 T-RUTAD
&Scoped-define SELF-NAME BROWSE-5
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH T-RUTAD WHERE T-RUTAD.codcia = s-codcia NO-LOCK, ~
           FIRST X-DI-RUTAC WHERE T-RUTAD.codcia = X-DI-RUTAC.CODCIA AND T-RUTAD.coddiv = INTEGRAL.X-DI-RutaC.coddiv AND T-RUTAD.coddoc = INTEGRAL.X-DI-RutaC.coddoc AND T-RUTAD.nrodoc = INTEGRAL.X-DI-RutaC.nrodoc NO-LOCK, ~
             FIRST INTEGRAL.FacCPedi WHERE INTEGRAL.FacCPedi.CodCia = T-RUTAD.CodCia   AND INTEGRAL.FacCPedi.CodDoc = T-RUTAD.CodRef   AND INTEGRAL.FacCPedi.NroPed = T-RUTAD.NroRef NO-LOCK, ~
             FIRST INTEGRAL.GN-DIVI OF INTEGRAL.FacCPedi NO-LOCK, ~
             FIRST INTEGRAL.DI-RutaD WHERE INTEGRAL.DI-RutaD.CodCia = T-RUTAD.CodCia   AND INTEGRAL.DI-RutaD.CodDiv = T-RUTAD.CodDiv   AND INTEGRAL.DI-RutaD.CodDoc = T-RUTAD.CodDoc   AND INTEGRAL.DI-RutaD.CodRef = T-RUTAD.CodRef   AND INTEGRAL.DI-RutaD.NroRef = T-RUTAD.NroRef   AND INTEGRAL.DI-RutaD.NroDoc = T-RUTAD.NroDoc NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH T-RUTAD WHERE T-RUTAD.codcia = s-codcia NO-LOCK, ~
           FIRST X-DI-RUTAC WHERE T-RUTAD.codcia = X-DI-RUTAC.CODCIA AND T-RUTAD.coddiv = INTEGRAL.X-DI-RutaC.coddiv AND T-RUTAD.coddoc = INTEGRAL.X-DI-RutaC.coddoc AND T-RUTAD.nrodoc = INTEGRAL.X-DI-RutaC.nrodoc NO-LOCK, ~
             FIRST INTEGRAL.FacCPedi WHERE INTEGRAL.FacCPedi.CodCia = T-RUTAD.CodCia   AND INTEGRAL.FacCPedi.CodDoc = T-RUTAD.CodRef   AND INTEGRAL.FacCPedi.NroPed = T-RUTAD.NroRef NO-LOCK, ~
             FIRST INTEGRAL.GN-DIVI OF INTEGRAL.FacCPedi NO-LOCK, ~
             FIRST INTEGRAL.DI-RutaD WHERE INTEGRAL.DI-RutaD.CodCia = T-RUTAD.CodCia   AND INTEGRAL.DI-RutaD.CodDiv = T-RUTAD.CodDiv   AND INTEGRAL.DI-RutaD.CodDoc = T-RUTAD.CodDoc   AND INTEGRAL.DI-RutaD.CodRef = T-RUTAD.CodRef   AND INTEGRAL.DI-RutaD.NroRef = T-RUTAD.NroRef   AND INTEGRAL.DI-RutaD.NroDoc = T-RUTAD.NroDoc NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 T-RUTAD X-DI-RUTAC FacCPedi GN-DIVI ~
DI-RutaD
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 T-RUTAD
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-5 X-DI-RUTAC
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-5 FacCPedi
&Scoped-define FOURTH-TABLE-IN-QUERY-BROWSE-5 GN-DIVI
&Scoped-define FIFTH-TABLE-IN-QUERY-BROWSE-5 DI-RutaD


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-5 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Importe FILL-IN-Peso ~
FILL-IN-Volumen FILL-IN-Bultos FILL-IN-SKUs 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fBultos B-table-Win 
FUNCTION fBultos RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fCuadrante B-table-Win 
FUNCTION fCuadrante RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDepartamento B-table-Win 
FUNCTION fDepartamento RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDistrito B-table-Win 
FUNCTION fDistrito RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fDocumentos B-table-Win 
FUNCTION fDocumentos RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fImporte B-table-Win 
FUNCTION fImporte RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fLugEnt B-table-Win 
FUNCTION fLugEnt RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fSKU B-table-Win 
FUNCTION fSKU RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fVolumen B-table-Win 
FUNCTION fVolumen RETURNS DECIMAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-BROWSE-5 
       MENU-ITEM m_Detalle_de_la_Orden LABEL "Detalle de la Orden".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-Bultos AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Bultos" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe AS DECIMAL FORMAT "-ZZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Importe" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Peso (kg)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-SKUs AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "SKUs" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Volumen AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Volumen (m3)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      T-RUTAD, 
      X-DI-RUTAC, 
      FacCPedi, 
      GN-DIVI, 
      DI-RutaD SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 B-table-Win _FREEFORM
  QUERY BROWSE-5 DISPLAY
      FacCPedi.Cliente_Recoge COLUMN-LABEL "Cliente!Recoge" FORMAT "SI/NO":U
      FacCPedi.EmpaqEspec COLUMN-LABEL "Embalaje!Especial" FORMAT "SI/NO":U
      t-RutaD.Departamento @ x-Departamento COLUMN-LABEL 'Departamento' FORMAT 'x(20)':U
      t-rutad.ptodestino @ x-Distrito COLUMN-LABEL "Distrito" FORMAT "x(30)":U
      T-RUTAD.CodRef FORMAT "x(3)":U WIDTH 6
      T-RUTAD.NroRef FORMAT "X(9)":U WIDTH 10
      FacCPedi.FchPed COLUMN-LABEL "Fecha de!Pedido" FORMAT "99/99/9999":U
      FacCPedi.Hora FORMAT "X(5)":U WIDTH 5.43
      FacCPedi.FchEnt COLUMN-LABEL "Fecha de!Entrega" FORMAT "99/99/9999":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(30)":U WIDTH 28.86
      T-RUTAD.Estado @ x-Estado COLUMN-LABEL "Estado" FORMAT "x(20)":U
      T-RUTAD.SKU @ x-SKU COLUMN-LABEL "SKU" FORMAT ">>,>>9":U
      T-RUTAD.Libre_c01 COLUMN-LABEL "Bultos" FORMAT "x(6)":U
      T-RUTAD.Libre_d02 COLUMN-LABEL "Importe" FORMAT ">>>,>>9.99":U
            WIDTH 7.86
      T-RUTAD.Libre_d01 COLUMN-LABEL "Peso" FORMAT ">>>,>>9.99":U
            WIDTH 6.57
      T-RUTAD.ImpCob COLUMN-LABEL "M3" FORMAT ">>>,>>9.99":U WIDTH 8.57
      T-RUTAD.libre_c02 COLUMN-LABEL "Tipo!BCP" FORMAT "X(15)":U WIDTH 10
      FacCPedi.Glosa COLUMN-LABEL "Glosa O/D" FORMAT "X(50)":U
      fLugEnt() @ FacCPedi.LugEnt COLUMN-LABEL 'Lugar de Entrega' FORMAT 'x(60)':U
      Faccpedi.CodRef
          Faccpedi.nroref
  ENABLE
      T-RUTAD.Libre_d01
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 150.57 BY 11.42
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-5 AT ROW 1.12 COL 1.43 WIDGET-ID 200
     FILL-IN-Importe AT ROW 12.85 COL 69 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-Peso AT ROW 12.85 COL 88 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-Volumen AT ROW 12.85 COL 110 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-Bultos AT ROW 12.85 COL 127 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-SKUs AT ROW 12.85 COL 140 COLON-ALIGNED WIDGET-ID 22
     "Doble clic para reasignar / Botón Derecho para menú contextual" VIEW-AS TEXT
          SIZE 47 BY .5 AT ROW 12.85 COL 2 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.DI-RutaC
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-RutaC B "?" ? INTEGRAL DI-RutaC
      TABLE: B-RutaD B "?" ? INTEGRAL DI-RutaD
      TABLE: T-RUTAD T "?" NO-UNDO INTEGRAL DI-RutaD
      ADDITIONAL-FIELDS:
          FIELD LugEnt AS CHAR
          FIELD SKU AS INT
          FIELD FchEnt AS DATE
          FIELD Docs AS INT
          FIELD Estado AS CHAR
          FIELD Reprogramado AS LOG INITIAL NO
          FIELD PtoDestino as char
          FIELD Departamento AS CHAR
      END-FIELDS.
      TABLE: X-DI-RutaC B "?" ? INTEGRAL DI-RutaC
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
         HEIGHT             = 13.19
         WIDTH              = 152.29.
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
/* BROWSE-TAB BROWSE-5 TEXT-1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       BROWSE-5:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-BROWSE-5:HANDLE.

/* SETTINGS FOR FILL-IN FILL-IN-Bultos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-SKUs IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Volumen IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _START_FREEFORM
OPEN QUERY BROWSE-5 FOR EACH T-RUTAD WHERE T-RUTAD.codcia = s-codcia NO-LOCK,
    FIRST X-DI-RUTAC WHERE T-RUTAD.codcia = X-DI-RUTAC.CODCIA AND T-RUTAD.coddiv = INTEGRAL.X-DI-RutaC.coddiv AND T-RUTAD.coddoc = INTEGRAL.X-DI-RutaC.coddoc AND T-RUTAD.nrodoc = INTEGRAL.X-DI-RutaC.nrodoc NO-LOCK,
      FIRST INTEGRAL.FacCPedi WHERE INTEGRAL.FacCPedi.CodCia = T-RUTAD.CodCia
  AND INTEGRAL.FacCPedi.CodDoc = T-RUTAD.CodRef
  AND INTEGRAL.FacCPedi.NroPed = T-RUTAD.NroRef NO-LOCK,
      FIRST INTEGRAL.GN-DIVI OF INTEGRAL.FacCPedi NO-LOCK,
      FIRST INTEGRAL.DI-RutaD WHERE INTEGRAL.DI-RutaD.CodCia = T-RUTAD.CodCia
  AND INTEGRAL.DI-RutaD.CodDiv = T-RUTAD.CodDiv
  AND INTEGRAL.DI-RutaD.CodDoc = T-RUTAD.CodDoc
  AND INTEGRAL.DI-RutaD.CodRef = T-RUTAD.CodRef
  AND INTEGRAL.DI-RutaD.NroRef = T-RUTAD.NroRef
  AND INTEGRAL.DI-RutaD.NroDoc = T-RUTAD.NroDoc NO-LOCK
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME BROWSE-5
&Scoped-define SELF-NAME BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-5 B-table-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-5 IN FRAME F-Main
DO:
    IF AVAILABLE di-rutaC THEN DO:
        DEF VAR x-FlgEst AS CHAR INIT 'P|C' NO-UNDO.
        DEF VAR x-FlgSit AS CHAR INIT 'TG|PI|C' NO-UNDO.

        /* Chequeamos la configuración */
        FIND GN-DIVI WHERE gn-divi.codcia = s-codcia
            AND gn-divi.coddiv = s-coddiv
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-divi THEN DO:
            FIND FIRST TabGener WHERE TabGener.CodCia = GN-DIVI.CodCia
                AND TabGener.Codigo = GN-DIVI.CodDiv
                AND TabGener.Clave = "CFGINC" NO-LOCK NO-ERROR.
            IF AVAILABLE TabGener AND TabGener.Libre_c03 > '' THEN x-FlgEst = TabGener.Libre_c03.
            IF AVAILABLE TabGener AND TabGener.Libre_c04 > '' THEN x-FlgSit = TabGener.Libre_c04.
        END.
        /* Consistencia */
        IF NOT (LOOKUP(Faccpedi.FlgEst, x-FlgEst,'|') > 0 AND
                LOOKUP(Faccpedi.FlgSit, x-FlgSit,'|') > 0)
            THEN DO:
            MESSAGE 'Acceso Denegado' SKIP
                'Consultar a su KeyUser' VIEW-AS ALERT-BOX WARNING.
            RETURN NO-APPLY.
        END.
/*         IF NOT (LOOKUP(Faccpedi.FlgEst, 'P,C') > 0 AND  */
/*                 LOOKUP(Faccpedi.FlgSit, 'TG,PI,C') > 0) */
/*              THEN RETURN NO-APPLY.                      */
        /* Chequeo completo, con HPK y Picking completo */
        IF AVAILABLE t-rutaD THEN DO:
            FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                x-faccpedi.coddoc = t-rutaD.codref AND
                x-faccpedi.nroped = t-rutaD.nroref 
                NO-LOCK NO-ERROR.
            IF AVAILABLE x-faccpedi THEN DO:
                RUN logis/d-reasignar-orden.r(INPUT di-rutaC.coddoc, 
                                              INPUT di-rutaC.nrodoc, 
                                              INPUT t-rutaD.codref,
                                              INPUT t-rutaD.nroref).
                RUN dispatch IN THIS-PROCEDURE ('open-query':U).
            END.              
            ELSE DO:
                MESSAGE "La orden " + t-rutaD.codref + "-" + t-rutaD.nroref + " no esta documentada"
                    VIEW-AS ALERT-BOX INFORMATION.
            END.
        END.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-5 B-table-Win
ON ROW-DISPLAY OF BROWSE-5 IN FRAME F-Main
DO:
    IF AVAILABLE T-RUTAD THEN DO:
        IF T-RUTAD.Libre_d01 = 0 THEN DO: /* No Documentado */
            T-RUTAD.CodRef:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
            T-RUTAD.NroRef:BGCOLOR IN BROWSE {&BROWSE-NAME} = 12.
            T-RUTAD.CodRef:FGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
            T-RUTAD.NroRef:FGCOLOR IN BROWSE {&BROWSE-NAME} = 15.
        END.
        IF FacCPedi.Cliente_Recoge = YES THEN DO:
            T-RUTAD.CodRef:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14.
            T-RUTAD.NroRef:BGCOLOR IN BROWSE {&BROWSE-NAME} = 14.
            T-RUTAD.CodRef:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0.
            T-RUTAD.NroRef:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0.
        END.
        IF FacCPedi.EmpaqEspec = YES THEN DO:
            T-RUTAD.CodRef:BGCOLOR IN BROWSE {&BROWSE-NAME} = 10.
            T-RUTAD.NroRef:BGCOLOR IN BROWSE {&BROWSE-NAME} = 10.
            T-RUTAD.CodRef:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0.
            T-RUTAD.NroRef:FGCOLOR IN BROWSE {&BROWSE-NAME} = 0.
        END.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-5 B-table-Win
ON START-SEARCH OF BROWSE-5 IN FRAME F-Main
DO:
    DEFINE VARIABLE hSortColumn AS WIDGET-HANDLE.
    DEFINE VARIABLE hColumnIndex AS WIDGET-HANDLE.
    DEFINE VAR lColumName AS CHAR.
    DEFINE VAR hQueryHandle AS HANDLE NO-UNDO.

    DEFINE VAR n_cols_browse AS INT NO-UNDO.
    DEFINE VAR n_celda AS WIDGET-HANDLE NO-UNDO.

    hSortColumn = BROWSE BROWSE-5:CURRENT-COLUMN.
    lColumName = hSortColumn:NAME.
    lColumName = TRIM(REPLACE(lColumName," no","")).

    IF lColumName = 'x-distrito' THEN lColumName = 't-rutad.ptodestino'.
    IF lColumName = 'x-Estado' THEN lColumName = 'T-RUTAD.Estado'.

    x-sort-command = "BY " + lColumName.

    IF x-sort-acumulativo = NO THEN DO:
        IF CAPS(x-sort-command) = CAPS(x-sort-column) THEN DO:
            x-sort-command = "BY " + lColumName + " DESC".
        END.
        ELSE DO:
            x-sort-command = "BY " + lColumName + " DESC".
            IF CAPS(x-sort-command) = CAPS(x-sort-column) THEN DO:
                x-sort-command = "BY " + lColumName.
            END.
            ELSE x-sort-command = "BY " + lColumName.
        END.
        x-sort-column = x-sort-command.

        x-sort-color-reset = YES.
    END.
    ELSE DO:
        x-sort-command = "BY " + lColumName + " DESC".

        IF INDEX(x-sort-column,x-sort-command) > 0 THEN DO:
            x-sort-column = REPLACE(x-sort-column,x-sort-command,"BY " + lColumName).
        END.
        ELSE DO:
            x-sort-command = "BY " + lColumName.
            IF INDEX(x-sort-column,x-sort-command) > 0 THEN DO:
                x-sort-column = REPLACE(x-sort-column,x-sort-command,"BY " + lColumName + " DESC").
            END.
            ELSE DO:
                x-sort-column = x-sort-column + " " + x-sort-command.
            END.
        END.
        x-sort-command = x-sort-column.
    END.

    /* Clear Sort Imagen */
    BROWSE BROWSE-5:CLEAR-SORT-ARROWS().

    DO n_cols_browse = 1 TO BROWSE-5:NUM-COLUMNS.
        hColumnIndex = BROWSE-5:GET-BROWSE-COLUMN(n_cols_browse).
        IF hSortColumn = hColumnIndex  THEN DO:
            IF INDEX(x-sort-command," DESC") > 0 THEN DO:
                BROWSE BROWSE-5:SET-SORT-ARROW(n_cols_browse,TRUE).
            END.
            ELSE DO:
                BROWSE BROWSE-5:SET-SORT-ARROW(n_cols_browse,FALSE).
            END.            
        END.
    END.
    
    DEFINE VAR x-sql AS CHAR.

    /*x-sql = "EACH T-RUTAD OF INTEGRAL.DI-RutaC NO-LOCK, " +*/
    /*x-sql = "FOR EACH T-RUTAD OF INTEGRAL.DI-RutaC WHERE " + "{&" + "KEY-PHRASE" + "} NO-LOCK, " + */
    /*
    DEF VAR hBuffer AS HANDLE NO-UNDO.
    CREATE BUFFER hBuffer FOR TABLE "di-rutaC":U BUFFER-NAME "x-di-rutaC":U.
    */
    x-sql = "FOR EACH T-RUTAD WHERE T-RUTAD.codcia = 1 NO-LOCK, " +
        "FIRST X-DI-RUTAC WHERE T-RUTAD.codcia = X-DI-RUTAC.CODCIA AND T-RUTAD.coddiv = INTEGRAL.X-DI-RutaC.coddiv AND T-RUTAD.coddoc = INTEGRAL.X-DI-RutaC.coddoc AND T-RUTAD.nrodoc = INTEGRAL.X-DI-RutaC.nrodoc NO-LOCK, " +
      "FIRST FacCPedi WHERE FacCPedi.CodCia = T-RUTAD.CodCia AND FacCPedi.CodDoc = T-RUTAD.CodRef " +
      "AND FacCPedi.NroPed = T-RUTAD.NroRef NO-LOCK, FIRST GN-DIVI OF FacCPedi NO-LOCK, FIRST DI-RutaD WHERE DI-RutaD.CodCia = T-RUTAD.CodCia " +
      "AND DI-RutaD.CodDiv = T-RUTAD.CodDiv AND DI-RutaD.CodDoc = T-RUTAD.CodDoc AND DI-RutaD.CodRef = T-RUTAD.CodRef AND DI-RutaD.NroRef = T-RUTAD.NroRef " +
      "AND DI-RutaD.NroDoc = T-RUTAD.NroDoc NO-LOCK ".
        /*"{&" + "SORTBY-PHRASE" + "} ".*/

    hQueryHandle = BROWSE BROWSE-5:QUERY.   
    hQueryHandle:QUERY-CLOSE().

    /*hQueryHandle:ADD-BUFFER(hBuffer).*/

    /* *--- Este valor debe ser el QUERY que esta definido en el BROWSE. */   
    /*hQueryHandle:QUERY-PREPARE("FOR EACH ORDENES WHERE " + "{& " + "CONDICION" + "} NO-LOCK, FIRST INTEGRAL.FacCPedi OF ORDENES NO-LOCK " + x-sort-command).*/
    hQueryHandle:QUERY-PREPARE(x-sql + x-sort-command).
    hQueryHandle:QUERY-OPEN().

    /* Color SortCol */
    IF x-sort-color-reset = YES THEN DO:
        /* Color normal */
        DO n_cols_browse = 1 TO BROWSE-5:NUM-COLUMNS.
            n_celda = BROWSE-5:GET-BROWSE-COLUMN(n_cols_browse).
            n_celda:COLUMN-BGCOLOR = 15.
        END.        

        x-sort-color-reset = NO.
    END.
    hSortColumn:COLUMN-BGCOLOR = 11.   
  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Detalle_de_la_Orden
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Detalle_de_la_Orden B-table-Win
ON CHOOSE OF MENU-ITEM m_Detalle_de_la_Orden /* Detalle de la Orden */
DO:
  IF AVAILABLE Faccpedi THEN RUN logis/d-detalle-orden (Faccpedi.CodDoc, Faccpedi.NroPed).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ASSIGN T-RutaD.libre_d01:READ-ONLY IN BROWSE BROWSE-5 = TRUE.

ON 'RETURN':U OF T-RUTAD.CodRef, T-RUTAD.NroRef
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "DI-RutaC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "DI-RutaC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT-OUTPUT PARAMETER TABLE FOR TT-RUTAD.

EMPTY TEMP-TABLE TT-RUTAD.

DEF BUFFER B-RutaC FOR Di-RutaC.

FIND B-RutaC WHERE ROWID(B-RutaC) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-RutaC THEN RETURN.
FIND FIRST x-di-rutac WHERE ROWID(x-di-rutac) = pRowid NO-LOCK NO-ERROR.

RUN Carga-Temporal (INPUT pRowid).

FOR EACH T-RUTAD OF B-RutaC NO-LOCK,
    FIRST FacCPedi WHERE FacCPedi.CodCia = T-RUTAD.CodCia
    AND FacCPedi.CodDoc = T-RUTAD.CodRef
    AND FacCPedi.NroPed = T-RUTAD.NroRef NO-LOCK,
    FIRST GN-DIVI OF FacCPedi NO-LOCK,
    FIRST DI-RutaD WHERE DI-RutaD.CodCia = T-RUTAD.CodCia
    AND DI-RutaD.CodDiv = T-RUTAD.CodDiv
    AND DI-RutaD.CodDoc = T-RUTAD.CodDoc
    AND DI-RutaD.CodRef = T-RUTAD.CodRef
    AND DI-RutaD.NroRef = T-RUTAD.NroRef
    AND DI-RutaD.NroDoc = T-RUTAD.NroDoc NO-LOCK:
    CREATE TT-RUTAD.
    BUFFER-COPY T-RUTAD TO TT-RUTAD.
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
DEF INPUT PARAMETER pRowid AS ROWID.

EMPTY TEMP-TABLE T-RUTAD.

DEF BUFFER B-RutaC FOR Di-RutaC.
FIND B-RutaC WHERE ROWID(B-RUtaC) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-RutaC THEN RETURN.
    
FIND FIRST x-di-rutac WHERE ROWID(x-di-rutac) = pRowid NO-LOCK NO-ERROR.
/**/
DEFINE VAR hProc AS HANDLE NO-UNDO.             /* Handle Libreria */
DEFINE VAR x-DeliveryGroup AS CHAR.
DEFINE VAR x-InvoiCustomerGroup AS CHAR.

RUN logis\logis-librerias.p PERSISTENT SET hProc.
/**/            

FOR EACH DI-RutaD OF B-RutaC NO-LOCK, 
    FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = Di-RutaD.codcia
        AND Faccpedi.coddoc = Di-RutaD.codref
        AND Faccpedi.nroped = Di-RutaD.nroref:

    CREATE T-RutaD.
    BUFFER-COPY DI-RutaD TO T-RutaD.
    T-RUTAD.Estado = fEstado().
    T-RUTAD.Libre_c01 = STRING(Faccpedi.AcuBon[9]).
    T-RUTAD.SKU = Faccpedi.Items.
    t-Rutad.Libre_d02 = Faccpedi.AcuBon[8].
    t-Rutad.Libre_d01 = Faccpedi.Peso.
    t-Rutad.ImpCob = Faccpedi.Volumen.
    t-rutad.ptodestino = fDistrito().
    t-Rutad.libre_c02 = "".
    t-RutaD.Departamento = fDepartamento().

    IF faccpedi.codcli = '20100047218' THEN DO:
        /* Es Grupo de Reparto */
        RUN Grupo-reparto IN hProc (INPUT Faccpedi.coddoc, INPUT Faccpedi.nroped, /* O/D */
                                    OUTPUT x-DeliveryGroup, OUTPUT x-InvoiCustomerGroup).       
        IF TRUE <> (x-DeliveryGroup > "") THEN DO:
            t-Rutad.libre_c02 = "ExtraOrdinario".
        END.
        ELSE DO:
            t-Rutad.libre_c02 = "Planificado".
        END.        
    END.
/*     IF Faccpedi.coddoc = 'OTR' THEN DO:                                                                     */
/*         t-Rutad.Libre_d02 = 0.                                                                              */
/*         FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:                          */
/*             t-Rutad.Libre_d02 = t-Rutad.Libre_d02 + (Facdpedi.CanPed * Facdpedi.Factor * Almmmatg.CtoTot) * */
/*                                 (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1).                       */
/*         END.                                                                                                */
/*     END.                                                                                                    */
    /* ******************************* */
    /* RHC 12/08/2021 TC venta de caja */
    /* ******************************* */
    T-RUTAD.Libre_d02 = fImporte().
    /* ******************************* */
END.

DELETE PROCEDURE hProc.

/* FOR EACH DI-RutaD OF B-RutaC NO-LOCK,                              */
/*     FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = Di-RutaD.codcia */
/*         AND Faccpedi.coddoc = Di-RutaD.codref                      */
/*         AND Faccpedi.nroped = Di-RutaD.nroref:                     */
/*     CREATE T-RutaD.                                                */
/*     BUFFER-COPY DI-RutaD TO T-RutaD.                               */
/*     T-RUTAD.Estado = fEstado().                                    */
/*     T-RUTAD.Libre_c01 = STRING(Faccpedi.AcuBon[9]).                */
/*     T-RUTAD.SKU = Faccpedi.Items.                                  */
/* END.                                                               */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Disable-Columns B-table-Win 
PROCEDURE Disable-Columns :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR hBrowse AS HANDLE NO-UNDO.
DEF VAR hColumn AS HANDLE NO-UNDO.
DEF VAR iCounter AS INT NO-UNDO.

ASSIGN hBrowse = BROWSE {&BROWSE-NAME}:HANDLE.

DO iCounter = 1 TO hBrowse:NUM-COLUMNS:
    hColumn = hBrowse:GET-BROWSE-COLUMN(iCounter).
    hColumn:READ-ONLY = TRUE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

/*
  /* Code placed here will execute PRIOR to standard behavior. */
  IF LOOKUP(DI-RutaC.FlgEst, 'C,A,L') > 0 THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
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
  DEF VAR s-Add-Record AS CHAR NO-UNDO.

  /* Bloqueamos DI-RutaC */
  FIND CURRENT DI-RutaC EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE DI-RutaC THEN DO:
      RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
      UNDO, RETURN 'ADM-ERROR'.
  END.
  ASSIGN
      DI-RutaC.Libre_c05 = s-user-id
      DI-RutaC.Libre_f05 = TODAY.
  FIND CURRENT DI-RutaC NO-LOCK NO-ERROR.

/*   DEF BUFFER B-RutaD FOR DI-RutaD. */
/*   DEF BUFFER B-RutaC FOR DI-RutaC. */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  s-Add-Record = RETURN-VALUE.      /* 'YES' o 'NO' */
  IF s-Add-Record = 'YES' THEN DO:
      CREATE DI-RutaD.
  END.
  ELSE DO:
      FIND CURRENT DI-RutaD EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE DI-RutaD THEN DO:
          RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
          UNDO, RETURN 'ADM-ERROR'.
      END.
  END.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      T-RutaD.CodCia = DI-RutaC.CodCia
      T-RutaD.CodDiv = DI-RutaC.CodDiv
      T-RutaD.CodDoc = DI-RutaC.CodDoc
      T-RutaD.NroDoc = DI-RutaC.NroDoc
      NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
      RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
      UNDO, RETURN 'ADM-ERROR'.
  END.
  IF s-Add-Record = 'YES' THEN DO:  /* REGISTRO NUEVO */
      FIND FIRST FacCPedi WHERE FacCPedi.CodCia = T-RUTAD.CodCia
          AND FacCPedi.CodDoc = T-RUTAD.CodRef
          AND FacCPedi.NroPed = T-RUTAD.NroRef
          NO-LOCK NO-ERROR.
      T-RUTAD.LugEnt = fDistrito().
      T-RUTAD.Docs = fDocumentos().
      T-RUTAD.Libre_c01 = STRING(fBultos()).
      T-RUTAD.ImpCob = (IF Faccpedi.codmon = 2 THEN Faccpedi.TpoCmb * Faccpedi.ImpTot ELSE Faccpedi.ImpTot).
      ASSIGN
          T-RUTAD.SKU = 0
          T-RUTAD.Libre_d01 = 0
          T-RUTAD.Libre_d02 = 0.
      FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
          T-RUTAD.SKU = T-RUTAD.SKU + 1.
          T-RUTAD.Libre_d01 = T-RUTAD.Libre_d01 + (Facdpedi.canped * Facdpedi.factor * almmmatg.pesmat).
          IF almmmatg.libre_d02 <> ? THEN T-RUTAD.Libre_d02 = T-RUTAD.Libre_d02 + (Facdpedi.canped * Facdpedi.Factor * (Almmmatg.libre_d02 / 1000000)).
      END.
      IF Faccpedi.CodDoc = "OTR" THEN DO:
          ASSIGN
              T-RUTAD.ImpCob = 0.
          FOR EACH Facdpedi OF Faccpedi NO-LOCK:
              FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia 
                  AND AlmStkGe.codmat = Facdpedi.codmat 
                  AND AlmStkGe.fecha <= TODAY NO-LOCK NO-ERROR.
              T-RUTAD.ImpCob = T-RUTAD.ImpCob + (IF AVAILABLE AlmStkGe THEN 
                  AlmStkGe.CtoUni * Facdpedi.canped * Facdpedi.factor
                  ELSE 0).
          END.
      END.
      T-RUTAD.Estado = fEstado().
  END.
  /* ACTUALIZAMOS LA TABLA */
  BUFFER-COPY T-RutaD TO DI-RutaD.  
  FIND CURRENT DI-RutaD NO-LOCK NO-ERROR.
  /* NO debe estar repetido */
/*   FIND FIRST B-RutaD WHERE B-RutaD.CodCia = DI-RutaD.CodCia */
/*       AND B-RutaD.CodDiv = DI-RutaD.CodDiv                  */
/*       AND B-RutaD.CodDoc = DI-RutaD.CodDoc                  */
/*       AND B-RutaD.NroDoc = DI-RutaD.NroDoc                  */
/*       AND B-RutaD.CodRef = DI-RutaD.CodRef                  */
/*       AND B-RutaD.NroRef = DI-RutaD.NroRef                  */
/*       AND ROWID(B-RutaD)<> ROWID(DI-RutaD)                  */
/*       NO-LOCK NO-ERROR.                                     */
/*   IF AVAILABLE B-RutaD THEN DO:                             */
/*       MESSAGE 'Documento repetido' VIEW-AS ALERT-BOX ERROR. */
/*       UNDO, RETURN 'ADM-ERROR'.                             */
/*   END.                                                      */
  /* ******************************************************** */
  /* Buscamos que no esté registrado en otra pre-hoja de ruta */
  /* ******************************************************** */
/*   FIND FIRST B-RutaD WHERE B-RutaD.CodCia = DI-RutaD.codcia                            */
/*       AND B-RutaD.CodDiv = DI-RutaD.coddiv                                             */
/*       AND B-RutaD.CodDoc = DI-RutaD.CodDoc                                             */
/*       AND B-RutaD.NroDoc <> DI-RutaD.NroDoc                                            */
/*       AND B-RutaD.CodRef = DI-RutaD.CodRef                                             */
/*       AND B-RutaD.NroRef = DI-RutaD.NroRef                                             */
/*       AND CAN-FIND(FIRST DI-RutaC OF B-RutaD WHERE DI-RutaC.FlgEst <> "A" NO-LOCK)     */
/*       NO-LOCK NO-ERROR.                                                                */
/*   IF AVAILABLE B-RutaD THEN DO:                                                        */
/*       MESSAGE 'Documento registrado en otra Pre-Hoja de Ruta' VIEW-AS ALERT-BOX ERROR. */
/*       UNDO, RETURN 'ADM-ERROR'.                                                        */
/*   END.                                                                                 */
  /* ********************************************* */
  /* Si está en otra PHR, la H/R NO debe estar en tránsito */
  /* ********************************************* */
/*   FIND LAST B-RutaD USE-INDEX Llave01 WHERE B-RutaD.CodCia = DI-RutaD.codcia                 */
/*       AND B-RutaD.CodDiv = DI-RutaD.coddiv                                                   */
/*       AND B-RutaD.CodDoc = DI-RutaD.CodDoc                                                   */
/*       AND B-RutaD.CodRef = DI-RutaD.CodRef                                                   */
/*       AND B-RutaD.NroRef = DI-RutaD.NroRef                                                   */
/*       AND CAN-FIND(FIRST B-RutaC OF B-RutaD WHERE B-RutaC.FlgEst = "C" NO-LOCK)              */
/*       AND CAN-FIND(FIRST Di-RutaC WHERE DI-RutaC.codcia = s-codcia                           */
/*                    AND Di-RutaC.coddiv = s-coddiv                                            */
/*                    AND Di-RutaC.coddoc = "H/R"                                               */
/*                    AND Di-RutaC.flgest = "P"                                                 */
/*                    AND Di-RutaC.libre_c03 = B-RutaD.coddoc + ',' + B-RutaD.nrodoc NO-LOCK)   */
/*       NO-LOCK NO-ERROR.                                                                      */
/*   IF AVAILABLE B-RutaD THEN DO:                                                              */
/*       MESSAGE 'Documento registrado en una Hoja de Ruta en trámite' VIEW-AS ALERT-BOX ERROR. */
/*       UNDO, RETURN 'ADM-ERROR'.                                                              */
/*   END.                                                                                       */
  /* RHC 01/12/17 Validación de los topes */
/*   RUN Valida-Limites.                                          */
/*   IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR". */
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /*
  /* Code placed here will execute PRIOR to standard behavior. */
  DEF BUFFER B-RutaD FOR DI-RutaD.
  IF LOOKUP(DI-RutaC.FlgEst, 'C,A,L') > 0 THEN DO:
    MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.
  /* Bloqueamos DI-RutaC */
  FIND CURRENT DI-RutaC EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE DI-RutaC THEN UNDO, RETURN 'ADM-ERROR'.
  ASSIGN
      DI-RutaC.Libre_c05 = s-user-id
      DI-RutaC.Libre_f05 = TODAY.
  /* Bloqueamos DI-RutaD */
  FIND B-RutaD WHERE ROWID(B-RutaD) = ROWID(DI-RutaD) EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE B-RutaD THEN UNDO, RETURN 'ADM-ERROR'.
  DELETE B-RutaD.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND CURRENT DI-RutaC NO-LOCK NO-ERROR.

  RUN Procesa-handle IN lh_handle ('Pinta-Cabecera').
  RUN Totales.
  */

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
  RUN Carga-Temporal (INPUT ROWID(Di-RutaC)).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Totales.

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
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-handle IN lh_handle ('Pinta-Cabecera').
  RUN Totales.

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
  {src/adm/template/snd-list.i "DI-RutaC"}
  {src/adm/template/snd-list.i "T-RUTAD"}
  {src/adm/template/snd-list.i "X-DI-RUTAC"}
  {src/adm/template/snd-list.i "FacCPedi"}
  {src/adm/template/snd-list.i "GN-DIVI"}
  {src/adm/template/snd-list.i "DI-RutaD"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales B-table-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF BUFFER BT-RUTAD FOR T-RUTAD.

    FILL-IN-Importe = 0.
    FILL-IN-Peso = 0.
    FILL-IN-Volumen = 0.
    FILL-IN-Bultos = 0.
    FILL-IN-SKUs = 0.

    FOR EACH BT-RUTAD NO-LOCK:
        FILL-IN-Peso = FILL-IN-Peso + BT-RUTAD.Libre_d01.
        FILL-IN-Volumen = FILL-IN-Volumen + BT-RUTAD.ImpCob.
        FILL-IN-Importe = FILL-IN-Importe + BT-RUTAD.Libre_d02.
        FILL-IN-Bultos = FILL-IN-Bultos + INTEGER(BT-RUTAD.Libre_c01).
        FILL-IN-SKUs = FILL-IN-SKUs + BT-RUTAD.SKU.
    END.
    DISPLAY
        FILL-IN-Importe FILL-IN-Peso FILL-IN-Volumen 
        FILL-IN-Bultos FILL-IN-SKUs
        WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/*
    FILL-IN-Importe = 0.
    FILL-IN-Peso = 0.
    FILL-IN-Volumen = 0.

    FOR EACH BT-RUTAD NO-LOCK:
        FILL-IN-Peso = FILL-IN-Peso + BT-RUTAD.Libre_d01.
        FILL-IN-Volumen = FILL-IN-Volumen + BT-RUTAD.Libre_d02.
        FILL-IN-Importe = FILL-IN-Importe + BT-RUTAD.ImpCob.
    END.
    DISPLAY
        FILL-IN-Importe FILL-IN-Peso FILL-IN-Volumen WITH FRAME {&FRAME-NAME}.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-DIVI  FOR GN-DIVI.
FIND B-CPEDI WHERE B-CPEDI.codcia = s-codcia
    AND B-CPEDI.coddoc = T-RUTAD.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    AND B-CPEDI.nroped = T-RUTAD.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
    AND LOOKUP(B-CPEDI.FlgEst, 'P,C') > 0
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN DO:
    MESSAGE 'Documento NO válido' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO T-RUTAD.CodRef.
    RETURN 'ADM-ERROR'.
END.
FIND FIRST B-DIVI WHERE B-DIVI.CodCia = s-codcia 
    AND B-DIVI.CodDiv = B-CPEDI.CodDiv
    AND B-DIVI.Campo-Log[1] = NO
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-DIVI THEN DO:
    MESSAGE 'Documento NO válido' VIEW-AS ALERT-BOX ERROR.
    APPLY 'ENTRY':U TO T-RUTAD.CodRef.
    RETURN 'ADM-ERROR'.
END.
RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
IF RETURN-VALUE = 'YES' THEN DO:
  /* NO debe estar repetido */
  FIND FIRST B-RutaD WHERE B-RutaD.CodCia = DI-RutaC.CodCia
      AND B-RutaD.CodDiv = DI-RutaC.CodDiv
      AND B-RutaD.CodDoc = DI-RutaC.CodDoc
      AND B-RutaD.NroDoc = DI-RutaC.NroDoc
      AND B-RutaD.CodRef = T-RUTAD.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      AND B-RutaD.NroRef = T-RUTAD.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF AVAILABLE B-RutaD THEN DO:
      MESSAGE 'Documento repetido' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO T-RUTAD.CodRef.
      RETURN 'ADM-ERROR'.
  END.
  /* ******************************************************** */
  /* Buscamos que no esté registrado en otra pre-hoja de ruta */
  /* ******************************************************** */
  FIND FIRST B-RutaD WHERE B-RutaD.CodCia = DI-RutaC.codcia
      AND B-RutaD.CodDiv = DI-RutaC.coddiv
      AND B-RutaD.CodDoc = DI-RutaC.CodDoc
      AND B-RutaD.NroDoc <> DI-RutaC.NroDoc
      AND B-RutaD.CodRef = T-RUTAD.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      AND B-RutaD.NroRef = T-RUTAD.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      AND CAN-FIND(FIRST DI-RutaC OF B-RutaD WHERE DI-RutaC.FlgEst <> "A" NO-LOCK)
      NO-LOCK NO-ERROR.
  IF AVAILABLE B-RutaD THEN DO:
      MESSAGE 'Documento registrado en otra Pre-Hoja de Ruta' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO T-RUTAD.CodRef.
      RETURN 'ADM-ERROR'.
  END.
END.


RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Limites B-table-Win 
PROCEDURE Valida-Limites :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   IF DI-RutaC.Libre_d01 = 0 AND DI-RutaC.Libre_d02 = 0 AND DI-RutaC.Libre_d03 = 0 
       THEN RETURN "OK".
   
   /* Consistencia de límites */
   DEF VAR x-Peso AS DEC NO-UNDO.
   DEF VAR x-Volumen AS DEC NO-UNDO.
   DEF VAR x-Destinos AS DEC NO-UNDO.

   ASSIGN
       x-Peso = 0
       x-Volumen = 0
       x-Destinos = 0.

   DEF BUFFER BT-RUTAD FOR T-RUTAD.
   DEF BUFFER B-CPEDI  FOR Faccpedi.

   FOR EACH BT-RUTAD NO-LOCK, FIRST B-CPEDI NO-LOCK WHERE B-CPEDI.codcia = BT-RUTAD.codcia
       AND B-CPEDI.coddoc = BT-RUTAD.codref
       AND B-CPEDI.nroped = BT-RUTAD.nroref
       BREAK BY B-CPEDI.CodCli:
       x-Peso = x-Peso + BT-RUTAD.Libre_d01.
       x-Volumen = x-Volumen + BT-RUTAD.Libre_d02.
       IF FIRST-OF(B-CPEDI.CodCli) THEN x-Destinos = x-Destinos + 1.
   END.
   IF DI-RutaC.Libre_d02 > 0 AND x-Peso > DI-RutaC.Libre_d02 THEN DO:
       MESSAGE 'Supera el tope máximo de peso' VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
   END.
   IF DI-RutaC.Libre_d03 > 0 AND x-Volumen > DI-RutaC.Libre_d03 THEN DO:
       MESSAGE 'Supera el tope máximo de volumen' VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
   END.
   IF DI-RutaC.Libre_d01 > 0 AND x-Destinos > DI-RutaC.Libre_d01 THEN DO:
       MESSAGE 'Supera el tope máximo de clientes' VIEW-AS ALERT-BOX ERROR.
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
MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fBultos B-table-Win 
FUNCTION fBultos RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Bultos AS INT NO-UNDO.

  RUN logis/p-numero-de-bultos (s-CodDiv, Faccpedi.CodDoc, Faccpedi.NroPed, OUTPUT x-Bultos).
/*   FOR EACH CcbCBult WHERE CcbCBult.CodCia = Faccpedi.codcia */
/*       AND CcbCBult.CodDoc = Faccpedi.CodDoc                 */
/*       AND CcbCBult.NroDoc = Faccpedi.NroPed                 */
/*       NO-LOCK:                                              */
/*       x-Bultos = CcbCBult.Bultos.                           */
/*   END.                                                      */
  RETURN x-Bultos.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fCuadrante B-table-Win 
FUNCTION fCuadrante RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pUbigeo AS CHAR NO-UNDO.
  DEF VAR pLongitud AS DEC NO-UNDO.
  DEF VAR pLatitud AS DEC NO-UNDO.
  DEF VAR pCuadrante AS CHAR NO-UNDO.

  RUN logis/p-datos-sede-auxiliar (
      FacCPedi.Ubigeo[2],   /* ClfAux @CL @PV */
      FacCPedi.Ubigeo[3],   /* Auxiliar */
      FacCPedi.Ubigeo[1],   /* Sede */
      OUTPUT pUbigeo,
      OUTPUT pLongitud,
      OUTPUT pLatitud
      ).
  RUN logis/p-cuadrante (
      pLongitud,
      pLatitud,
      OUTPUT pCuadrante
      ).

  RETURN pCuadrante.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDepartamento B-table-Win 
FUNCTION fDepartamento RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pUbigeo AS CHAR NO-UNDO.
  DEF VAR pLongitud AS DEC NO-UNDO.
  DEF VAR pLatitud AS DEC NO-UNDO.
  DEF VAR pCuadrante AS CHAR NO-UNDO.

  RUN logis/p-datos-sede-auxiliar.r (
      FacCPedi.Ubigeo[2],   /* ClfAux @CL @PV */
      FacCPedi.Ubigeo[3],   /* Auxiliar */
      FacCPedi.Ubigeo[1],   /* Sede */
      OUTPUT pUbigeo,
      OUTPUT pLongitud,
      OUTPUT pLatitud
      ).
  FIND TabDepto WHERE TabDepto.CodDepto = SUBSTRING(pUbigeo,1,2) NO-LOCK NO-ERROR.
  IF AVAILABLE TabDepto THEN RETURN TabDepto.NomDepto.
  ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDistrito B-table-Win 
FUNCTION fDistrito RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pUbigeo AS CHAR NO-UNDO.
  DEF VAR pLongitud AS DEC NO-UNDO.
  DEF VAR pLatitud AS DEC NO-UNDO.
  DEF VAR pCuadrante AS CHAR NO-UNDO.

  RUN logis/p-datos-sede-auxiliar.r (
      FacCPedi.Ubigeo[2],   /* ClfAux @CL @PV */
      FacCPedi.Ubigeo[3],   /* Auxiliar */
      FacCPedi.Ubigeo[1],   /* Sede */
      OUTPUT pUbigeo,
      OUTPUT pLongitud,
      OUTPUT pLatitud
      ).
  FIND TabDistr WHERE TabDistr.CodDepto = SUBSTRING(pUbigeo,1,2)
      AND TabDistr.CodProvi = SUBSTRING(pUbigeo,3,2)
      AND TabDistr.CodDistr = SUBSTRING(pUbigeo,5,2)
      NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN RETURN TabDistr.NomDistr.
    ELSE RETURN "".

/*   DEF VAR pCodDpto AS CHAR NO-UNDO.                      */
/*   DEF VAR pCodProv AS CHAR NO-UNDO.                      */
/*   DEF VAR pCodDist AS CHAR NO-UNDO.                      */
/*   DEF VAR pCodPos  AS CHAR NO-UNDO.                      */
/*   DEF VAR pZona    AS CHAR NO-UNDO.                      */
/*   DEF VAR pSubZona AS CHAR NO-UNDO.                      */
/*                                                          */
/*   RUN gn/fUbigeo (                                       */
/*       Faccpedi.CodDiv,                                   */
/*       Faccpedi.CodDoc,                                   */
/*       Faccpedi.NroPed,                                   */
/*       OUTPUT pCodDpto,                                   */
/*       OUTPUT pCodProv,                                   */
/*       OUTPUT pCodDist,                                   */
/*       OUTPUT pCodPos,                                    */
/*       OUTPUT pZona,                                      */
/*       OUTPUT pSubZona                                    */
/*       ).                                                 */
/*   FIND TabDistr WHERE TabDistr.CodDepto = pCodDpto       */
/*       AND TabDistr.CodProvi = pCodProv                   */
/*       AND TabDistr.CodDistr = pCodDist                   */
/*       NO-LOCK NO-ERROR.                                  */
/*     IF AVAILABLE TabDistr THEN RETURN TabDistr.NomDistr. */
/*     ELSE RETURN "".                                      */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fDocumentos B-table-Win 
FUNCTION fDocumentos RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-NroDocs AS INT NO-UNDO.
  DEF BUFFER PEDIDO FOR Faccpedi.

  CASE FacCPedi.CodDoc:
      WHEN "O/M" OR WHEN "O/D" THEN DO:
          /* Buscamos del PEDido: Puede ser del cliente o del 1er. tramo */
          FIND FIRST PEDIDO WHERE PEDIDO.codcia = FacCPedi.codcia
              AND PEDIDO.coddoc = FacCPedi.codref
              AND PEDIDO.nroped = FacCPedi.nroref
              AND PEDIDO.codpos > ''
              NO-LOCK NO-ERROR.
          IF AVAILABLE PEDIDO THEN DO:
              /* Contamos cuantas guias de remisión están relacionadas */
              FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = Faccpedi.codcia
                  AND Ccbcdocu.codped = PEDIDO.coddoc
                  AND Ccbcdocu.nroped = PEDIDO.nroped:
                  IF Ccbcdocu.coddiv = s-coddiv
                      AND Ccbcdocu.coddoc = 'G/R'
                      AND Ccbcdocu.flgest <> 'A'
                      THEN x-NroDocs = x-NroDocs + 1.
              END.
          END.
      END.
      WHEN "OTR" THEN DO:
          /* Contamos cuantas guias de remisión están relacionadas */
          FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = 1 
              AND Almcmov.codref = FacCPedi.coddoc
              AND Almcmov.nroref = FacCPedi.nroped:
              IF Almcmov.tipmov = 'S' 
                  AND Almcmov.codmov = 03
                  AND Almcmov.flgest <> 'A'
                  THEN x-NroDocs = x-NroDocs + 1.
          END.
      END.
  END CASE.
  RETURN x-NroDocs.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR cEstado AS CHAR NO-UNDO.

  cEstado = 'Aprobado'.
  CASE Faccpedi.CodDoc:
      WHEN "O/D" OR WHEN "O/M" OR WHEN "OTR" THEN DO:
          IF Faccpedi.usrImpOD > '' THEN cEstado = 'Impreso'.
          IF Faccpedi.FlgSit = "P" OR Faccpedi.FlgSit = "PI" THEN cEstado = "Picking Terminado".
          IF Faccpedi.FlgEst = "P" AND Faccpedi.FlgSit = "C" THEN cEstado = "Por Facturar".
          IF Faccpedi.FlgEst = "P" AND Faccpedi.FlgSit = "PC" THEN cEstado = "Checking Terminado".
          IF Faccpedi.FlgEst = "C" THEN cEstado = "Documentado".
          IF Faccpedi.FlgEst = "P" AND Faccpedi.FlgSit = "TG" THEN cEstado = "En Almacén".
      END.
  END CASE.
  RETURN cEstado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fImporte B-table-Win 
FUNCTION fImporte RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR x-Importe AS DEC NO-UNDO.

      IF Faccpedi.CodDoc = "OTR" THEN DO:
          FOR EACH Facdpedi OF Faccpedi NO-LOCK:
              FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia 
                  AND AlmStkGe.codmat = Facdpedi.codmat 
                  AND AlmStkGe.fecha <= TODAY NO-LOCK NO-ERROR.
              IF AVAILABLE AlmStkGe THEN
                  x-Importe = x-Importe + (AlmStkGe.CtoUni * Facdpedi.canped * Facdpedi.factor).
          END.
      END.
      ELSE DO:
          /* RHC 12/08/2021: Se va a tomar el tipo de cambio venta de caja cobranza */
          FIND LAST Gn-tccja WHERE Gn-tccja.fecha <= Faccpedi.FchPed NO-LOCK NO-ERROR.
          IF AVAILABLE Gn-tccja THEN
              x-Importe = x-Importe + (IF Faccpedi.codmon = 2 THEN Gn-tccja.venta * Faccpedi.ImpTot ELSE Faccpedi.ImpTot).
          ELSE 
              x-Importe = x-Importe + (IF Faccpedi.codmon = 2 THEN Faccpedi.TpoCmb * Faccpedi.ImpTot ELSE Faccpedi.ImpTot).
      END.
  RETURN x-Importe.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fLugEnt B-table-Win 
FUNCTION fLugEnt RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEF VAR x-LugEnt AS CHAR NO-UNDO.

    IF NOT AVAILABLE Faccpedi THEN RETURN x-LugEnt.

    RUN logis/p-lugar-de-entrega (FacCPedi.CodDoc,
                                  FacCPedi.NroPed,
                                  OUTPUT x-LugEnt).
    IF NUM-ENTRIES(x-LugEnt,'|') > 1 THEN x-LugEnt = ENTRY(2,x-LugEnt,'|').

    RETURN x-LugEnt.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPeso B-table-Win 
FUNCTION fPeso RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Pesos AS DEC NO-UNDO.

  FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
      x-Pesos = x-Pesos + (Facdpedi.canped * Facdpedi.factor * almmmatg.pesmat).
  END.
  RETURN x-Pesos.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fSKU B-table-Win 
FUNCTION fSKU RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-SKU AS INT NO-UNDO.

  FOR EACH Facdpedi OF Faccpedi NO-LOCK:
      x-SKU = x-SKU + 1.
  END.
  RETURN x-SKU.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fVolumen B-table-Win 
FUNCTION fVolumen RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR x-Volumen AS DEC NO-UNDO.

  FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
      IF almmmatg.libre_d02 <> ? THEN x-Volumen = x-Volumen + (Facdpedi.canped * Facdpedi.Factor * (Almmmatg.libre_d02 / 1000000)).
  END.
  RETURN x-Volumen.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

