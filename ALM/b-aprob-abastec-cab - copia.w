&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ALM FOR Almacen.
DEFINE BUFFER B-MATE FOR Almmmate.
DEFINE BUFFER B-MATG FOR Almmmatg.
DEFINE TEMP-TABLE T-CREPO NO-UNDO LIKE almcrepo.



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

DEF VAR s-FlgEst AS CHAR INIT 'P'.      /* Pendiente */
DEF VAR s-FlgSit AS CHAR INIT 'G'.      /* No Autorizado */

DEF SHARED VAR s-user-id AS CHAR.

DEF VAR x-VtaPuntual LIKE almcrepo.VtaPuntual NO-UNDO.
DEF VAR cMotivos AS CHAR NO-UNDO.

FOR EACH FacTabla NO-LOCK WHERE FacTabla.CodCia = s-codcia
    AND FacTabla.Tabla = 'REPOMOTIVO':
    cMotivos = cMotivos + (IF TRUE <> (cMotivos > '') THEN '' ELSE ',' ) + FacTabla.Codigo + ',' +
        FacTabla.Nombre.
END.

DEF SHARED VAR lh_handle AS HANDLE.

/* Ic - 14Set2016 - Variables para la generacion de la OTR */
DEFINE NEW SHARED VARIABLE s-coddoc   AS CHAR INITIAL "OTR".    /* Orden de Transferencia */

DEFINE NEW SHARED VARIABLE s-codref   AS CHAR INITIAL "R/A".    /* Reposiciones Automáticas */
DEFINE NEW SHARED VARIABLE s-adm-new-record AS CHAR.
DEFINE NEW SHARED VARIABLE s-NroSer AS INTEGER.
DEFINE NEW SHARED VARIABLE s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE NEW SHARED VARIABLE s-TpoPed AS CHAR.

DEFINE SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.

/* PARAMETROS DE PEDIDOS PARA LA DIVISION */
DEF NEW SHARED VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
DEF NEW SHARED VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEF NEW SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.

DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE        VARIABLE S-NROCOT   AS CHARACTER.

/* Buffer  */ 
DEFINE TEMP-TABLE PEDI LIKE facdpedi.
DEFINE BUFFER B-CPEDI FOR Faccpedi.
DEFINE BUFFER B-CREPO FOR Almcrepo.

/* MENSAJES DE ERROR Y DEL SISTEMA */
DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR pMensaje2 AS CHAR NO-UNDO.
DEF VAR pMensajeFinal AS CHAR NO-UNDO.

/* La division y almacen de donde se va a despachar la mercaderia */
DEFINE VAR lDivDespacho AS CHAR.
DEFINE VAR lAlmDespacho AS CHAR.

/* Variables para Cross Docking */
DEF VAR pCrossDocking AS LOG NO-UNDO.
DEF VAR pAlmacenXD AS CHAR NO-UNDO.

DEF VAR FILL-IN-Usuario AS CHAR NO-UNDO.
DEF VAR COMBO-BOX-Motivo AS CHAR NO-UNDO.
DEF VAR FILL-IN-FchDoc-1 AS DATE NO-UNDO.
DEF VAR FILL-IN-FchDoc-2 AS DATE NO-UNDO.
DEF VAR FILL-IN-Fecha-1 AS DATE NO-UNDO.
DEF VAR FILL-IN-Fecha-2 AS DATE NO-UNDO.
DEF VAR EDITOR-AlmPed AS CHAR NO-UNDO.
DEF VAR EDITOR-CodAlm AS CHAR NO-UNDO.

&SCOPED-DEFINE Condicion almcrepo.CodCia = s-codcia ~
AND LOOKUP(Almcrepo.TipMov, 'A,M') > 0 ~
AND almcrepo.FlgEst = s-FlgEst ~
AND (COMBO-BOX-Motivo = 'Todos' OR almcrepo.MotReposicion = COMBO-BOX-Motivo) ~
AND (FILL-IN-FchDoc-1 = ? OR almcrepo.FchDoc >= FILL-IN-FchDoc-1) ~
AND (FILL-IN-FchDoc-2 = ? OR almcrepo.FchDoc <= FILL-IN-FchDoc-2) ~
AND (FILL-IN-Fecha-1 = ? OR almcrepo.Fecha >= FILL-IN-Fecha-1) ~
AND (FILL-IN-Fecha-2 = ? OR almcrepo.Fecha <= FILL-IN-Fecha-2) ~
AND ((TRUE <> (FILL-IN-Usuario > '')) OR almcrepo.usuario = FILL-IN-Usuario)
/* AND almcrepo.FlgSit = s-FlgSit ~ */

&SCOPED-DEFINE Condicion2 B-CREPO.CodCia = s-codcia ~
AND B-CREPO.FlgEst = s-FlgEst ~
AND (COMBO-BOX-Motivo = 'Todos' OR B-CREPO.MotReposicion = COMBO-BOX-Motivo) ~
AND (FILL-IN-FchDoc-1 = ? OR B-CREPO.FchDoc >= FILL-IN-FchDoc-1) ~
AND (FILL-IN-FchDoc-2 = ? OR B-CREPO.FchDoc <= FILL-IN-FchDoc-2) ~
AND (FILL-IN-Fecha-1 = ? OR B-CREPO.Fecha >= FILL-IN-Fecha-1) ~
AND (FILL-IN-Fecha-2 = ? OR B-CREPO.Fecha <= FILL-IN-Fecha-2) ~
AND ((TRUE <> (FILL-IN-Usuario > '')) OR B-CREPO.usuario = FILL-IN-Usuario)
/*     AND B-CREPO.FlgSit = s-FlgSit ~ */

DEFINE TEMP-TABLE Detalle
    FIELD CodMat AS CHAR LABEL 'Articulo'
    FIELD CodAlm AS CHAR LABEL 'Alm.Solicitante'
    FIELD Observ AS CHAR FORMAT 'x(60)' LABEL 'Observaciones'.

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
&Scoped-define INTERNAL-TABLES T-CREPO almcrepo Almacen

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table almcrepo.CodAlm Almacen.Descripcion ~
almcrepo.AlmPed almcrepo.Usuario almcrepo.FchDoc almcrepo.Hora ~
almcrepo.Fecha almcrepo.FchVto almcrepo.NroSer almcrepo.NroDoc 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH T-CREPO WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST almcrepo OF T-CREPO NO-LOCK, ~
      FIRST Almacen OF almcrepo OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-CREPO WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST almcrepo OF T-CREPO NO-LOCK, ~
      FIRST Almacen OF almcrepo OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table T-CREPO almcrepo Almacen
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-CREPO
&Scoped-define SECOND-TABLE-IN-QUERY-br_table almcrepo
&Scoped-define THIRD-TABLE-IN-QUERY-br_table Almacen


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table RECT-1 RECT-28 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-TotPeso FILL-IN-TotAlmacenes ~
FILL-IN-TotValor FILL-IN-TotPedidos FILL-IN-TotItems FILL-IN-Seleccionados ~
FILL-IN-TotPeso-2 FILL-IN-TotValor-2 

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
DEFINE VARIABLE FILL-IN-Seleccionados AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Total Seleccionados" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 12 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-TotAlmacenes AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Cantidad de Almacenes" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TotItems AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Total Items" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TotPedidos AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Cantidad de Pedidos" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TotPeso AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Total Peso (kg)" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TotPeso-2 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Total Peso (kg)" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 12 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN-TotValor AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Tot. Valor SIN/IGV (S/)" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-TotValor-2 AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Tot. Valor SIN/IGV (S/)" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 12 FGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55 BY 2.96.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 55 BY 2.96.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-CREPO, 
      almcrepo, 
      Almacen SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      almcrepo.CodAlm COLUMN-LABEL "Alm.!Solic." FORMAT "x(3)":U
            WIDTH 4.43
      Almacen.Descripcion COLUMN-LABEL "Solicitante" FORMAT "X(40)":U
            WIDTH 19.29
      almcrepo.AlmPed COLUMN-LABEL "Alm.!Desp." FORMAT "x(3)":U
      almcrepo.Usuario COLUMN-LABEL "Usuario" FORMAT "x(15)":U
            WIDTH 7
      almcrepo.FchDoc COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
      almcrepo.Hora FORMAT "x(5)":U WIDTH 5
      almcrepo.Fecha COLUMN-LABEL "Entrega" FORMAT "99/99/99":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      almcrepo.FchVto FORMAT "99/99/9999":U
      almcrepo.NroSer FORMAT "999":U WIDTH 6.43
      almcrepo.NroDoc FORMAT "999999":U WIDTH 9.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 87 BY 21.27
         FONT 4
         TITLE "PEDIDOS POR APROBAR" ROW-HEIGHT-CHARS .42 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN-TotPeso AT ROW 5.31 COL 104 COLON-ALIGNED WIDGET-ID 44
     FILL-IN-TotAlmacenes AT ROW 5.31 COL 133 COLON-ALIGNED WIDGET-ID 40
     FILL-IN-TotValor AT ROW 6.12 COL 104 COLON-ALIGNED WIDGET-ID 46
     FILL-IN-TotPedidos AT ROW 6.12 COL 133 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-TotItems AT ROW 6.92 COL 133 COLON-ALIGNED WIDGET-ID 48
     FILL-IN-Seleccionados AT ROW 8.27 COL 104 COLON-ALIGNED WIDGET-ID 72
     FILL-IN-TotPeso-2 AT ROW 9.08 COL 104 COLON-ALIGNED WIDGET-ID 68
     FILL-IN-TotValor-2 AT ROW 9.88 COL 104 COLON-ALIGNED WIDGET-ID 70
     RECT-1 AT ROW 5.04 COL 88 WIDGET-ID 50
     RECT-28 AT ROW 8 COL 88 WIDGET-ID 74
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
      TABLE: B-ALM B "?" ? INTEGRAL Almacen
      TABLE: B-MATE B "?" ? INTEGRAL Almmmate
      TABLE: B-MATG B "?" ? INTEGRAL Almmmatg
      TABLE: T-CREPO T "?" NO-UNDO INTEGRAL almcrepo
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
         HEIGHT             = 21.62
         WIDTH              = 142.
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

ASSIGN 
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 3.

/* SETTINGS FOR FILL-IN FILL-IN-Seleccionados IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotAlmacenes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotItems IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotPedidos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotPeso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotPeso-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotValor IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-TotValor-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-CREPO,INTEGRAL.almcrepo OF Temp-Tables.T-CREPO,INTEGRAL.Almacen OF INTEGRAL.almcrepo"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST, FIRST OUTER"
     _FldNameList[1]   > INTEGRAL.almcrepo.CodAlm
"almcrepo.CodAlm" "Alm.!Solic." ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almacen.Descripcion
"Almacen.Descripcion" "Solicitante" ? "character" ? ? ? ? ? ? no ? no no "19.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.almcrepo.AlmPed
"almcrepo.AlmPed" "Alm.!Desp." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.almcrepo.Usuario
"almcrepo.Usuario" "Usuario" "x(15)" "character" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.almcrepo.FchDoc
"almcrepo.FchDoc" "Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.almcrepo.Hora
"almcrepo.Hora" ? ? "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.almcrepo.Fecha
"almcrepo.Fecha" "Entrega" ? "date" 11 0 ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = INTEGRAL.almcrepo.FchVto
     _FldNameList[9]   > INTEGRAL.almcrepo.NroSer
"almcrepo.NroSer" ? ? "integer" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.almcrepo.NroDoc
"almcrepo.NroDoc" ? ? "integer" ? ? ? ? ? ? no ? no no "9.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON LEFT-MOUSE-DBLCLICK OF br_table IN FRAME F-Main /* PEDIDOS POR APROBAR */
DO:
  IF NOT AVAILABLE Almcrepo THEN RETURN.
  RUN alm/d-aprob-abastec-det.w (ROWID(Almcrepo)).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-DISPLAY OF br_table IN FRAME F-Main /* PEDIDOS POR APROBAR */
DO:
  IF AVAILABLE Almcrepo THEN DO:
      DEF BUFFER B-CPEDI FOR Faccpedi.
      FIND FIRST B-CPEDI WHERE B-CPEDI.codcia = s-codcia
          AND B-CPEDI.coddoc = 'OTR'
          AND B-CPEDI.codref = 'R/A'
          AND B-CPEDI.nroref = STRING(Almcrepo.nroser,'999') + STRING(Almcrepo.nrodoc, '999999')
          AND B-CPEDI.flgest = "A"
          NO-LOCK NO-ERROR.
      IF AVAILABLE B-CPEDI THEN DO:
          Almcrepo.NroSer:FGCOLOR IN BROWSE {&browse-name} = 0.
          Almcrepo.NroDoc:FGCOLOR IN BROWSE {&browse-name} = 0.
          Almcrepo.NroSer:BGCOLOR IN BROWSE {&browse-name} = 14.
          Almcrepo.NroDoc:BGCOLOR IN BROWSE {&browse-name} = 14.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main /* PEDIDOS POR APROBAR */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* PEDIDOS POR APROBAR */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* PEDIDOS POR APROBAR */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
   RUN Total-Seleccionado.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME almcrepo.Fecha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almcrepo.Fecha br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF almcrepo.Fecha IN BROWSE br_table /* Entrega */
DO:
/*     ASSIGN BROWSE {&BROWSE-NAME} {&SELF-NAME} NO-ERROR. */
/*     RUN dispatch IN THIS-PROCEDURE ('update-record':U). */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar B-table-Win 
PROCEDURE Aprobar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Selección múltiple  */
pMensajeFinal = ''.
DEF VAR k AS INT NO-UNDO.
RLOOP:
DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:
        IF NOT (almcrepo.flgest = s-FlgEst AND almcrepo.flgsit = s-FlgSit) THEN DO:
            MESSAGE 'El Pedido' STRING(almcrepo.NroSer, '999') STRING(almcrepo.NroDoc, '999999')
                'ya NO está habilitado para su aprobación' SKIP
                'Pasamos al siguiente registro' VIEW-AS ALERT-BOX WARNING.
            NEXT RLOOP.
        END.
        /* ******************************************************************************************* */
        RUN Grabar-Aprobado.
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = 'Error an procesar el pedido: ' + STRING(almcrepo.NroSer, '999') + STRING(almcrepo.NroDoc, '999999').
            LEAVE RLOOP.
        END.
        /* ******************************************************************************************* */
        IF pMensaje2 > '' THEN pMensajeFinal = pMensajeFinal + CHR(10) + pMensaje2.
    END.
END.
IF AVAILABLE(B-CREPO)  THEN RELEASE B-CREPO.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.
IF AVAILABLE(vtacdocu) THEN RELEASE vtacdocu.
IF AVAILABLE(vtaddocu) THEN RELEASE vtaddocu.
IF pMensaje > ''  THEN MESSAGE pMensaje  VIEW-AS ALERT-BOX ERROR.
IF pMensajeFinal > '' THEN MESSAGE pMensajeFinal VIEW-AS ALERT-BOX INFORMATION.
RUN Procesa-Handle IN lh_handle ('open-queries').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar-Seleccionados B-table-Win 
PROCEDURE Aprobar-Seleccionados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF BUFFER B-DESTINO FOR Almacen.
    DEF BUFFER B-ORIGEN  FOR Almacen.
    DEF VAR k AS INT NO-UNDO.

    RUN alm/d-crossdocking-v2 (OUTPUT pCrossDocking, OUTPUT pAlmacenXD).
    IF pAlmacenXD = "ERROR" THEN RETURN NO-APPLY.
    IF pCrossDocking = YES THEN 
        DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
            IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:
                FIND B-DESTINO WHERE B-DESTINO.codcia = s-codcia
                    AND B-DESTINO.codalm = almcrepo.CodAlm
                    NO-LOCK.
                FIND B-ORIGEN WHERE B-ORIGEN.codcia = s-codcia
                    AND B-ORIGEN.codalm = pAlmacenXD
                    NO-LOCK.
                IF B-DESTINO.CodDiv = B-ORIGEN.CodDiv THEN DO:
                    MESSAGE 'NO se puede generar para el mismo CD' VIEW-AS ALERT-BOX ERROR.
                    RETURN NO-APPLY.
                END.
        END.
    END.
   
    MESSAGE 'Está seguro de APROBAR SELECCIONADOS?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN 'ADM-ERROR'.
    
    /* Selección múltiple  */
    EMPTY TEMP-TABLE Detalle.
    pMensajeFinal = ''.
    RLOOP:
    DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
        IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:
            IF NOT (almcrepo.flgest = s-FlgEst /*AND almcrepo.flgsit = s-FlgSit*/) THEN DO:
                MESSAGE 'El Pedido' STRING(almcrepo.NroSer, '999') STRING(almcrepo.NroDoc, '999999')
                    'ya NO está habilitado para su aprobación' SKIP
                    'Pasamos al siguiente registro' VIEW-AS ALERT-BOX WARNING.
                NEXT RLOOP.
            END.
            /* ******************************************************************************************* */
            RUN Grabar-Aprobado.
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                IF TRUE <> (pMensaje > '') THEN pMensaje = 'Error an procesar el pedido: ' + STRING(almcrepo.NroSer, '999') + STRING(almcrepo.NroDoc, '999999').
                LEAVE RLOOP.
            END.
            /* ******************************************************************************************* */
            IF pMensaje2 > '' THEN pMensajeFinal = pMensajeFinal + CHR(10) + pMensaje2.
        END.
    END.
    IF AVAILABLE(B-CREPO)  THEN RELEASE B-CREPO.
    IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
    IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
    IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
    IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.
    IF AVAILABLE(vtacdocu) THEN RELEASE vtacdocu.
    IF AVAILABLE(vtaddocu) THEN RELEASE vtaddocu.
    IF pMensaje > ''  THEN MESSAGE pMensaje  VIEW-AS ALERT-BOX ERROR.
    IF pMensajeFinal > '' THEN MESSAGE pMensajeFinal VIEW-AS ALERT-BOX INFORMATION.
    /* Pintamos no migrados */
    IF CAN-FIND(FIRST Detalle NO-LOCK) THEN DO:
        RUN Excel.
    END.

    RUN Procesa-Handle IN lh_handle ('open-queries').

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

/* Recepción de parámetros */
DEF INPUT PARAMETER pUsuario AS CHAR.
DEF INPUT PARAMETER pMotivo AS CHAR.
DEF INPUT PARAMETER pFchDoc1 AS DATE.
DEF INPUT PARAMETER pFchDoc2 AS DATE.
DEF INPUT PARAMETER pFecha1 AS DATE.
DEF INPUT PARAMETER pFecha2 AS DATE.
DEF INPUT PARAMETER pAlmPed AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.

ASSIGN
    FILL-IN-Usuario = pUsuario
    COMBO-BOX-Motivo = pMotivo
    FILL-IN-FchDoc-1 = pFchDoc1
    FILL-IN-FchDoc-2 = pFchDoc2
    FILL-IN-Fecha-1 = pFecha1
    FILL-IN-Fecha-2 = pFecha2
    EDITOR-AlmPed = pAlmPed
    EDITOR-CodAlm = pCodAlm.

DEF BUFFER B-ALM FOR Almacen.

SESSION:SET-WAIT-STATE('GENERAL').
EMPTY TEMP-TABLE T-CREPO.
FOR EACH B-ALM NO-LOCK WHERE B-ALM.codcia = s-codcia
    AND LOOKUP(B-ALM.codalm, EDITOR-AlmPed) > 0:
    FOR EACH Almcrepo NO-LOCK WHERE Almcrepo.codcia = B-ALM.codcia
        AND Almcrepo.almped = B-ALM.codalm
        AND {&Condicion}:
        IF ( TRUE <> (EDITOR-CodAlm > '') OR LOOKUP(Almcrepo.codalm, EDITOR-CodAlm) > 0 )
            THEN DO:
            CREATE T-CREPO.
            BUFFER-COPY Almcrepo TO T-CREPO.
        END.
    END.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
RUN Total-Seleccionado.
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-temporal-otr B-table-Win 
PROCEDURE cargar-temporal-otr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.
  DEFINE VARIABLE F-CANPED AS DECIMAL NO-UNDO.
  DEFINE VARIABLE x-StkAct AS DEC NO-UNDO.
  DEFINE VARIABLE x-CodAlm AS CHAR NO-UNDO.
  DEFINE VARIABLE i AS INT NO-UNDO.

  EMPTY TEMP-TABLE PEDI.

  i-NPedi = 0.
  /* ************************************************* */
  /* RHC 23/08/17 Simplificación del proceso Max Ramos */
  /* ************************************************* */
  DEF VAR t-AlmDes AS CHAR NO-UNDO.
  DEF VAR t-CanPed AS DEC NO-UNDO.
  FOR EACH Almdrepo OF Almcrepo NO-LOCK WHERE (Almdrepo.CanApro - Almdrepo.CanAten) > 0,
      FIRST Almmmatg OF Almdrepo NO-LOCK:
      f-Factor = 1.
      t-AlmDes = ''.
      t-CanPed = 0.
      F-CANPED = (Almdrepo.CanApro - Almdrepo.CanAten).     /* OJO */
      x-CodAlm = lAlmDespacho.
      /* DEFINIMOS LA CANTIDAD */
      x-CanPed = f-CanPed * f-Factor.
      IF f-CanPed <= 0 THEN NEXT.
      IF f-CanPed > t-CanPed THEN DO:
          t-CanPed = f-CanPed.
          t-AlmDes = x-CodAlm.
      END.
      /* GRABACION */
      I-NPEDI = I-NPEDI + 1.
      CREATE PEDI.
      BUFFER-COPY Almdrepo 
          EXCEPT Almdrepo.CanReq Almdrepo.CanApro
          TO PEDI
          ASSIGN 
              PEDI.CodCia = s-codcia
              PEDI.CodDiv = lDivDespacho
              PEDI.CodDoc = s-coddoc
              PEDI.NroPed = ''
              PEDI.ALMDES = t-AlmDes  /* *** OJO *** */
              PEDI.NroItm = I-NPEDI
              PEDI.CanPed = t-CanPed            /* << OJO << */
              PEDI.CanAte = 0.
      ASSIGN
          PEDI.Libre_d01 = (Almdrepo.CanApro - Almdrepo.CanAten)
          PEDI.Libre_d02 = t-CanPed
          PEDI.Libre_c01 = '*'.
      ASSIGN
          PEDI.UndVta = Almmmatg.UndBas.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel B-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR lNuevoFile AS LOG NO-UNDO.
    DEF VAR lFIleXls AS CHAR NO-UNDO.

    lNuevoFile = YES.
    {lib/excel-open-file.i}
    chExcelApplication:Visible = FALSE.
    /* ******************************************************************************** */
    /* LOGICA PRINCIPAL: CARGA DEL EXCEL */
    /* ******************************************************************************** */
    /* Select a worksheet */
    chWorkbook:Worksheets(1):Activate.
    chWorksheet = chWorkbook:Worksheets(1).

    chWorkSheet:Range("A1"):VALUE = "Alm.Solicitante".
    chWorkSheet:Range("B1"):VALUE = "Articulo".
    chWorkSheet:Range("C1"):VALUE = "Observaciones".
    chWorkSheet:COLUMNS("A"):NumberFormat = "@".
    chWorkSheet:COLUMNS("B"):NumberFormat = "@".
    iRow = 1.
    FOR EACH Detalle NO-LOCK:
        iRow = iRow + 1.
        cColumn = STRING(iRow).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.CodAlm.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.CodMat.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = Detalle.Observ.
    END.
    /* ******************************************************************************** */
    /* ******************************************************************************** */
    lNuevoFile = NO.
    lCerrarAlTerminar = NO.
    {lib/excel-close-file.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido B-table-Win 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO INIT 0.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.

  DEF VAR f-PreBas AS DEC NO-UNDO.
  DEF VAR f-PreVta AS DEC NO-UNDO.
  DEF VAR f-Dsctos AS DEC NO-UNDO.
  DEF VAR y-Dsctos AS DEC NO-UNDO.
  DEF VAR SW-LOG1  AS LOGI NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.

  /* POR CADA PEDI VOLVEMOS A VERIFICAR EL STOCK DISPONIBLE */
  /* Borramos data sobrante */
  FOR EACH PEDI WHERE PEDI.CanPed <= 0:
      DELETE PEDI.
  END.

  /* RHC 13.08.2014 bloqueado por ahora 
  DETALLE:
  FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      /* RUTINA QUE VERIFICA NUEVAMENTE EL STOCK DISPONIBLE Y AJUSTA LA CANTIDAD EN CASO NECESARIO */
      FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
          AND Almtconv.Codalter = PEDI.UndVta
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almtconv THEN DO:
          pMensaje = 'Se ha encontrado un problema con el producto ' + PEDI.codmat + CHR(10) +
              'No se encuentra definido su factor de equivalencia' + CHR(10) +
              'Unidad base en el catálogo: ' + Almmmatg.UndBas + CHR(10) +
              'Unidad de venta pedido:' + PEDI.UndVta.
          RETURN 'ADM-ERROR'.
      END.
      f-Factor = Almtconv.Equival.
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = PEDI.AlmDes
          AND Almmmate.codmat = PEDI.CodMat
          NO-LOCK NO-ERROR .
      x-StkAct = Almmmate.StkAct.
      RUN vta2/Stock-Comprometido (PEDI.CodMat, PEDI.AlmDes, OUTPUT s-StkComprometido).
      s-StkDis = x-StkAct - s-StkComprometido + (PEDI.CanPed * f-Factor).   /* <<< OJO: NO tomar la cantidad del STR */
      IF s-StkDis <= 0 THEN DO:
          pMensajeFinal = pMensajeFinal + 
              'El STOCK esta en CERO para el producto ' + PEDI.codmat + 
              'en el almacén ' + PEDI.AlmDes + CHR(10).
          NEXT DETALLE.    /* << OJO << */
      END.
      /* **************************************************************************************** */
      x-CanPed = PEDI.CanPed * f-Factor.

      IF s-StkDis < x-CanPed THEN DO:
          /* Ajustamos de acuerdo a los multiplos */
          PEDI.CanPed = ( s-StkDis - ( s-StkDis MODULO f-Factor ) ) / f-Factor.
          IF PEDI.CanPed <= 0 THEN NEXT DETALLE.
          /* EMPAQUE SUPERMERCADOS */
          x-CanPed = PEDI.CanPed * f-Factor.
          IF s-FlgEmpaque = YES THEN DO:
              IF Almmmatg.DEC__03 > 0 THEN x-CanPed = (TRUNCATE((x-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).
          END.
          PEDI.CanPed = ( x-CanPed - ( x-CanPed MODULO f-Factor ) ) / f-Factor.
          IF PEDI.CanPed <= 0 THEN NEXT DETALLE.    /* << OJO << */
      END.
      /* FIN DE CONTROL DE AJUSTES */
  END.
  */

  /* AHORA SÍ GRABAMOS EL PEDIDO */
  FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      I-NPEDI = I-NPEDI + 1.
      IF I-NPEDI > 52 THEN LEAVE.
      CREATE Facdpedi.
      BUFFER-COPY PEDI 
          TO Facdpedi
          ASSIGN
              Facdpedi.CodCia = Faccpedi.CodCia
              Facdpedi.CodDiv = Faccpedi.CodDiv
              Facdpedi.AlmDes = Faccpedi.CodAlm
              Facdpedi.coddoc = Faccpedi.coddoc
              Facdpedi.NroPed = Faccpedi.NroPed
              Facdpedi.FchPed = Faccpedi.FchPed
              Facdpedi.Hora   = Faccpedi.Hora 
              Facdpedi.FlgEst = Faccpedi.FlgEst
              FacDPedi.CanPick = FacDPedi.CanPed
              Facdpedi.NroItm = I-NPEDI.
      DELETE PEDI.
  END.
  
  /* verificamos que al menos exista 1 item grabado */
  FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi 
  THEN RETURN 'ADM-ERROR'.
  ELSE RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-SubOrden B-table-Win 
PROCEDURE Genera-SubOrden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* RUN Extorna-SubOrden.                                  */
/* IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'. */
/* Los subpedidos se generan de acuerdo al SECTOR donde esten ubicados los productos */

/* SOLO para O/D control de Pickeo */
IF FacCPedi.FlgSit <> "T" THEN RETURN 'OK'.

DEFINE VAR lSector AS CHAR.

DEFINE VAR lSectorG0 AS LOG.
DEFINE VAR lSectorOK AS LOG.
DEFINE VAR lUbic AS CHAR.
/* 
    Para aquellos articulos cuya ubicacion no sea correcta SSPPMMN
    SS : Sector
    PP : Pasaje
    MM : Modulo
    N  : Nivel (A,B,C,D,E,F)
*/
lSectorG0 = NO.

/* El SECTOR forma parte del código de ubicación */
FOR EACH facdpedi OF faccpedi NO-LOCK,
    FIRST almmmate NO-LOCK WHERE Almmmate.CodCia = facdpedi.codcia
    AND Almmmate.CodAlm = facdpedi.almdes
    AND Almmmate.codmat = facdpedi.codmat
    BREAK BY SUBSTRING(Almmmate.CodUbi,1,2)
    ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    IF FIRST-OF(SUBSTRING(Almmmate.CodUbi,1,2)) THEN DO:
        /* Ic - 29Nov2016, G- = G0 */
        lSector = CAPS(SUBSTRING(Almmmate.CodUbi,1,2)).
        lUbic = TRIM(Almmmate.CodUbi).
        lSectorOK = NO.
        /* Si el sector es Correcto y el codigo de la ubicacion esta OK */
        /* 18May2017 Felix Perez creo una nueva ZONA (07) */
        IF (lSector >= '01' AND lSector <= '07') AND LENGTH(lUbic) = 7 THEN DO:
            /* Ubic Ok */
            lSectorOK = YES.
        END.
        ELSE DO:
            lSector = "G0".
        END.        
        /* Ic - 29Nov2016, FIN  */
        IF lSectorOK = YES OR lSectorG0 = NO THEN DO:
            CREATE vtacdocu.
            BUFFER-COPY faccpedi TO vtacdocu
                ASSIGN 
                VtaCDocu.CodCia = faccpedi.codcia
                VtaCDocu.CodDiv = faccpedi.coddiv
                VtaCDocu.CodPed = faccpedi.coddoc
                VtaCDocu.NroPed = faccpedi.nroped + '-' + lSector
                VtaCDocu.FlgEst = 'P'   /* APROBADO */
                NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = "Error al grabar la suborden " + faccpedi.nroped + '-' + SUBSTRING(Almmmate.CodUbi,1,2).
                UNDO, RETURN 'ADM-ERROR'.
            END.
            IF lSector = 'G0' THEN lSectorG0 = YES.
        END.
    END.
    CREATE vtaddocu.
    BUFFER-COPY facdpedi TO vtaddocu
        ASSIGN
        VtaDDocu.CodCia = VtaCDocu.codcia
        VtaDDocu.CodDiv = VtaCDocu.coddiv
        VtaDDocu.CodPed = VtaCDocu.codped
        VtaDDocu.NroPed = faccpedi.nroped + '-' + lSector /*VtaCDocu.nroped*/
        VtaDDocu.CodUbi = Almmmate.CodUbi.
END.
IF AVAILABLE vtacdocu THEN RELEASE vtacdocu.
IF AVAILABLE vtaddocu THEN RELEASE vtaddocu.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Grabar-Aprobado B-table-Win 
PROCEDURE Grabar-Aprobado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pComprometido AS DEC NO-UNDO.
DEF VAR fDisponible AS DEC NO-UNDO.
DEF VAR pFechaEntrega AS DATE NO-UNDO.

pMensaje  = ''.
pMensaje2 = ''.
RLOOP:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    {lib/lock-genericov3.i
        &Tabla="B-CREPO"
        &Alcance="FIRST" 
        &Condicion="ROWID(B-CREPO) = ROWID(almcrepo)"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, LEAVE"
        }
    /* ********************************************************************************************* */
    /* RHC 21/02/2018 Consistencia del Stock Origen Disponible */
    /* ********************************************************************************************* */
    FIND B-ALM WHERE B-ALM.codcia = s-codcia AND B-ALM.codalm = B-CREPO.codalm NO-LOCK.
    FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = B-ALM.coddiv NO-LOCK.
    FOR EACH Almdrepo OF B-CREPO NO-LOCK, FIRST B-MATG OF Almdrepo NO-LOCK:
        /* Comprometido */
        RUN gn/stock-comprometido-v2 (almdrepo.CodMat, B-CREPO.AlmPed, NO, OUTPUT pComprometido).
        FIND B-MATE WHERE B-MATE.codcia = s-codcia
            AND B-MATE.codalm = B-CREPO.AlmPed
            AND B-MATE.codmat = almdrepo.CodMat
            NO-LOCK NO-ERROR.
        IF AVAILABLE B-MATE THEN fDisponible = (B-MATE.StkAct - pComprometido).
        ELSE fDisponible = 0.00.
        IF fDisponible < 0 THEN DO:
            pMensaje = "ERROR en el Pedido: " + STRING(B-CREPO.NroSer, '999') + STRING(B-CREPO.NroDoc, '999999') + CHR(10) +
                "Artículo: " + Almdrepo.codmat + CHR(10) +
                "Stock Origen Disponible en negativo" + CHR(10) +
                "Proceso Abortado".
            UNDO RLOOP, LEAVE RLOOP.
        END.
        /* *********************************************************************** */
        /* CONSISTENCIA TIPO DE ALMACEN */
        /* *********************************************************************** */
        CASE TRUE:
            WHEN GN-DIVI.CanalVenta = "MIN" THEN DO:    /* UTILEX */
                IF NOT ( (TRUE <> (B-MATG.TpoMrg > '')) OR B-MATG.TpoMrg = "2" ) THEN DO:
                    CREATE Detalle.
                    ASSIGN 
                        Detalle.codmat = Almdrepo.codmat
                        Detalle.codalm = B-CREPO.codalm
                        Detalle.observ = 'Este producto es solo para almacenes mayoristas'.

                END.
            END.
            OTHERWISE DO:   /* MAYORISTAS */
/*                 IF NOT ( (TRUE <> (B-MATG.TpoMrg > '')) OR B-MATG.TpoMrg = "1" ) THEN DO:   */
/*                     CREATE Detalle.                                                         */
/*                     ASSIGN                                                                  */
/*                         Detalle.codmat = Almdrepo.codmat                                    */
/*                         Detalle.codalm = B-CREPO.codalm                                     */
/*                         Detalle.observ = 'Este producto es solo para almacenes minoristas'. */
/*                 END.                                                                        */
            END.
        END CASE.
        /* *********************************************************************** */
    END.
    /* ********************************************************************************************* */
    /* ********************************************************************************************* */
    ASSIGN
        B-CREPO.FlgEst = "C"        /* RHC 28/11/17 CERRADO */
        B-CREPO.FchApr = TODAY
        B-CREPO.FlgSit = 'A'       /* Aprobado */
        B-CREPO.HorApr = STRING(TIME, 'HH:MM')
        B-CREPO.UsrApr = s-user-id.
    /* Ic - 14Set2016, Aprobacion y Generacion de OTR automaticamente */
    pMensaje = ''.
    pMensaje2 = ''.
    DEF VAR hProc AS HANDLE NO-UNDO.
    RUN gn/master-library PERSISTENT SET hProc.
    RUN genera-OTR IN hProc ("R/A",
                             ROWID(B-CREPO),
                             pCrossDocking,
                             pAlmacenXD,
                             OUTPUT pFechaEntrega,
                             OUTPUT pMensaje,
                             OUTPUT pMensaje2).
    DELETE PROCEDURE hProc.
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo generar la OTR para el doc: " +
            STRING(almcrepo.NroSer, '999') + "-" + STRING(almcrepo.NroDoc, '999999').
        UNDO RLOOP, LEAVE RLOOP.
    END.
    ASSIGN
        B-CREPO.Fecha = pFechaEntrega
        B-CREPO.CrossDocking = pCrossDocking
        B-CREPO.AlmacenXD = pAlmacenXD.
    RELEASE B-CREPO.
END.
IF pMensaje > '' THEN RETURN 'ADM-ERROR'.
RETURN 'OK'.

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
  /* Venta Puntual */
  IF x-VtaPuntual <> almcrepo.VtaPuntual THEN DO:
      ASSIGN
          almcrepo.Libre_c01 = s-user-id + '|' + 
            STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS').
  END.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('enable-items').
  RUN Enable-Filtros.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Enable-Filtros.

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
  RUN disable-filtros.

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

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('enable-items').
  RUN Enable-Filtros.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rechazar B-table-Win 
PROCEDURE Rechazar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Selección simple */
IF NOT AVAILABLE almcrepo THEN RETURN.
IF NOT (almcrepo.flgest = s-FlgEst /*AND almcrepo.flgsit = s-FlgSit*/) THEN DO:
    MESSAGE 'Este pedido NO se encuentra pendiente de aprobación' VIEW-AS ALERT-BOX WARNING.
    RUN Procesa-Handle IN lh_handle ('open-queries').
    RETURN.
END.
/* RHC 10/04/17 Motivo de anulación Max Ramos */
DEF VAR pMotivo AS CHAR NO-UNDO.
DEF VAR pGlosa  AS CHAR NO-UNDO.
DEF VAR pError  AS LOG  NO-UNDO.

DEF BUFFER B-CPEDI FOR Faccpedi.
FIND FIRST B-CPEDI WHERE B-CPEDI.codcia = s-codcia
    AND B-CPEDI.coddoc = 'OTR'
    AND B-CPEDI.codref = 'R/A'
    AND B-CPEDI.nroref = STRING(Almcrepo.nroser,'999') + STRING(Almcrepo.nrodoc, '999999')
    AND B-CPEDI.flgest = "A"
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN DO:
    RUN alm/d-mot-anu-otr ( INPUT 'MOTIVO DE RECHAZO',
                            OUTPUT pMotivo,
                            OUTPUT pGlosa,
                            OUTPUT pError).
    IF pError = TRUE THEN RETURN.
END.
FIND CURRENT almcrepo EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
IF ERROR-STATUS:ERROR THEN DO:
    RUN dispatch IN THIS-PROCEDURE ('show-errors':U).
    RETURN.
END.
ASSIGN
    almcrepo.FlgEst = "R"       /* Rechazado */
    almcrepo.FchApr = TODAY
    /*almcrepo.FlgSit = 'R'       /* Rechazado */*/
    almcrepo.HorApr = STRING(TIME, 'HH:MM')
    almcrepo.UsrApr = s-user-id.
/* RHC 10/04/17 Max Ramos */
IF pMotivo > '' THEN almcrepo.Libre_c02 = pMotivo + '|' + pGlosa + '|' + STRING(NOW) + '|' + s-user-id.

FIND CURRENT almcrepo NO-LOCK NO-ERROR.
RUN Procesa-Handle IN lh_handle ('open-queries').

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
  {src/adm/template/snd-list.i "T-CREPO"}
  {src/adm/template/snd-list.i "almcrepo"}
  {src/adm/template/snd-list.i "Almacen"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Total-Seleccionado B-table-Win 
PROCEDURE Total-Seleccionado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN
    FILL-IN-Seleccionados = {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}
    FILL-IN-TotPeso-2 = 0
    FILL-IN-TotValor-2 = 0.
DEF VAR k AS INT NO-UNDO.
DO k = 1 TO FILL-IN-Seleccionados:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) IN FRAME {&FRAME-NAME} THEN DO:
        FOR EACH Almdrepo OF Almcrepo NO-LOCK, FIRST Almmmatg OF Almdrepo NO-LOCK:
            FILL-IN-TotValor-2 = FILL-IN-TotValor-2 + Almmmatg.CtoLis * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1) * Almdrepo.canapro.
            FILL-IN-TotPeso-2  = FILL-IN-TotPeso-2  + (almdrepo.CanApro * Almmmatg.Pesmat).
        END.
    END.
END.
DISPLAY
    FILL-IN-Seleccionados
    FILL-IN-TotPeso-2
    FILL-IN-TotValor-2
    WITH FRAME {&FRAME-NAME}.


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

DEF VAR x-Almacenes AS CHAR NO-UNDO.
ASSIGN
    FILL-IN-TotAlmacenes = 0
    FILL-IN-TotItems = 0
    FILL-IN-TotPedidos = 0
    FILL-IN-TotPeso = 0
    FILL-IN-TotValor = 0.

DEF BUFFER BT-CREPO FOR T-CREPO.

FOR EACH BT-CREPO NO-LOCK,
    FIRST B-CREPO OF BT-CREPO NO-LOCK,
    FIRST B-ALM OF B-CREPO:
    IF TRUE <> (x-Almacenes > '') THEN x-Almacenes = B-CREPO.codalm.
    ELSE IF LOOKUP(B-CREPO.codalm, x-Almacenes) = 0 THEN x-Almacenes = x-Almacenes + ',' + B-CREPO.codalm.
    FOR EACH Almdrepo OF B-CREPO NO-LOCK, FIRST Almmmatg OF Almdrepo NO-LOCK:
        FILL-IN-TotItems = FILL-IN-TotItems + 1.
        FILL-IN-TotValor = FILL-IN-TotValor + Almmmatg.CtoLis * (IF Almmmatg.MonVta = 2 THEN Almmmatg.TpoCmb ELSE 1) * Almdrepo.canapro.
        FILL-IN-TotPeso = FILL-IN-TotPeso + (almdrepo.CanApro * Almmmatg.Pesmat).
    END.
    FILL-IN-TotPedidos = FILL-IN-TotPedidos  + 1.
END.
FILL-IN-TotAlmacenes = NUM-ENTRIES(x-Almacenes).
DISPLAY
    FILL-IN-TotAlmacenes FILL-IN-TotItems FILL-IN-TotPedidos FILL-IN-TotPeso FILL-IN-TotValor
    WITH FRAME {&FRAME-NAME}.


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

    /* RHC 04/10/2016 CONSISTENCIA DE FECHA DE ENTREGA */
    pMensaje = "".
    DEF VAR pFchEnt AS DATE NO-UNDO.
    pFchEnt = DATE(almcrepo.Fecha:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}).
    /* OJO con la hora */
    /*RUN gn/p-fchent (TODAY, STRING(TIME,'HH:MM:SS'), pFchEnt, s-coddiv, OUTPUT pMensaje).*/
    RUN gn/p-fchent (TODAY, STRING(TIME,'HH:MM:SS'), pFchEnt, s-coddiv, s-codalm, OUTPUT pMensaje).
    IF pMensaje <> '' THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO almcrepo.Fecha.
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
x-VtaPuntual =  almcrepo.VtaPuntual.
RUN Procesa-Handle IN lh_handle ('disable-items').
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

