&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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

&SCOPED-DEFINE Condicion almcrepo.CodCia = s-codcia ~
 AND (COMBO-BOX-CodAlm = 'Todos' OR almcrepo.CodAlm = COMBO-BOX-CodAlm) ~
 AND (COMBO-BOX-AlmPed = 'Todos' OR almcrepo.AlmPed = COMBO-BOX-AlmPed) ~
 AND almcrepo.FlgEst = s-FlgEst ~
 AND almcrepo.FlgSit = s-FlgSit ~
 AND (FILL-IN-Usuario = '' OR almcrepo.Usuario = FILL-IN-Usuario) ~
 AND (COMBO-BOX-Motivo = 'Todos' OR almcrepo.MotReposicion = COMBO-BOX-Motivo)

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
&Scoped-define INTERNAL-TABLES almcrepo Almacen

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table almcrepo.VtaPuntual almcrepo.CodAlm ~
Almacen.Descripcion almcrepo.AlmPed almcrepo.Usuario almcrepo.FchDoc ~
almcrepo.Hora almcrepo.Fecha almcrepo.FchVto almcrepo.NroSer ~
almcrepo.NroDoc almcrepo.MotReposicion almcrepo.Glosa almcrepo.FchApr ~
almcrepo.HorApr 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table almcrepo.VtaPuntual ~
almcrepo.Fecha almcrepo.MotReposicion almcrepo.Glosa 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table almcrepo
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table almcrepo
&Scoped-define QUERY-STRING-br_table FOR EACH almcrepo WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Almacen OF almcrepo NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH almcrepo WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST Almacen OF almcrepo NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table almcrepo Almacen
&Scoped-define FIRST-TABLE-IN-QUERY-br_table almcrepo
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almacen


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BUTTON-4 BUTTON-2 COMBO-BOX-CodAlm ~
FILL-IN-Usuario COMBO-BOX-AlmPed COMBO-BOX-Motivo br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-CodAlm FILL-IN-Usuario ~
COMBO-BOX-AlmPed COMBO-BOX-Motivo 

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


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br_table 
       MENU-ITEM m_Informacin_de_la_Anulacin_d LABEL "Información de la Anulación de la OTR".


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "APROBAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-4 
     LABEL "RECHAZAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-AlmPed AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Filtrar por Despacho" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 48 BY 1
     FONT 4 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-CodAlm AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Filtrar por Solicitante" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 52 BY 1
     FONT 4 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Motivo AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Motivo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 52 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Usuario AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      almcrepo, 
      Almacen
    FIELDS(Almacen.Descripcion) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      almcrepo.VtaPuntual COLUMN-LABEL "Urgente" FORMAT "Si/No":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11 VIEW-AS TOGGLE-BOX
      almcrepo.CodAlm COLUMN-LABEL "Alm." FORMAT "x(3)":U WIDTH 5
      Almacen.Descripcion COLUMN-LABEL "Solicitante" FORMAT "X(40)":U
            WIDTH 19.29
      almcrepo.AlmPed COLUMN-LABEL "Almacén!Despacho" FORMAT "x(3)":U
      almcrepo.Usuario COLUMN-LABEL "Usuario" FORMAT "x(15)":U
            WIDTH 10
      almcrepo.FchDoc COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
      almcrepo.Hora FORMAT "x(5)":U
      almcrepo.Fecha COLUMN-LABEL "Entrega" FORMAT "99/99/99":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      almcrepo.FchVto FORMAT "99/99/9999":U
      almcrepo.NroSer FORMAT "999":U WIDTH 5.14
      almcrepo.NroDoc FORMAT "999999":U
      almcrepo.MotReposicion COLUMN-LABEL "Motivo" FORMAT "x(60)":U
            WIDTH 34.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "Uno","Uno"
                      DROP-DOWN-LIST 
      almcrepo.Glosa FORMAT "x(60)":U COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      almcrepo.FchApr COLUMN-LABEL "Fecha!Aprob." FORMAT "99/99/99":U
      almcrepo.HorApr COLUMN-LABEL "Hora!Aprob." FORMAT "x(5)":U
  ENABLE
      almcrepo.VtaPuntual
      almcrepo.Fecha
      almcrepo.MotReposicion
      almcrepo.Glosa
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 141 BY 8.96
         FONT 4 ROW-HEIGHT-CHARS .42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 1 COL 2 WIDGET-ID 2
     BUTTON-4 AT ROW 1 COL 17 WIDGET-ID 18
     BUTTON-2 AT ROW 1 COL 32 WIDGET-ID 4
     COMBO-BOX-CodAlm AT ROW 1.27 COL 87 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-Usuario AT ROW 2.08 COL 87 COLON-ALIGNED WIDGET-ID 24
     COMBO-BOX-AlmPed AT ROW 2.15 COL 19 COLON-ALIGNED WIDGET-ID 16
     COMBO-BOX-Motivo AT ROW 2.88 COL 87 COLON-ALIGNED WIDGET-ID 26
     br_table AT ROW 3.96 COL 1
     "Botón derecho para abrir un sub-menú" VIEW-AS TEXT
          SIZE 28 BY .5 AT ROW 13.12 COL 111 WIDGET-ID 28
          BGCOLOR 9 FGCOLOR 15 
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
         HEIGHT             = 12.65
         WIDTH              = 145.29.
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
/* BROWSE-TAB br_table COMBO-BOX-Motivo F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-br_table:HANDLE
       br_table:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 3.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.almcrepo,INTEGRAL.Almacen OF INTEGRAL.almcrepo"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST USED"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > INTEGRAL.almcrepo.VtaPuntual
"almcrepo.VtaPuntual" "Urgente" "Si/No" "logical" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "TOGGLE-BOX" "?" ? ? 5 no 0 no no
     _FldNameList[2]   > INTEGRAL.almcrepo.CodAlm
"almcrepo.CodAlm" "Alm." ? "character" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almacen.Descripcion
"Almacen.Descripcion" "Solicitante" ? "character" ? ? ? ? ? ? no ? no no "19.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.almcrepo.AlmPed
"almcrepo.AlmPed" "Almacén!Despacho" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.almcrepo.Usuario
"almcrepo.Usuario" "Usuario" "x(15)" "character" ? ? ? ? ? ? no ? no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.almcrepo.FchDoc
"almcrepo.FchDoc" "Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = INTEGRAL.almcrepo.Hora
     _FldNameList[8]   > INTEGRAL.almcrepo.Fecha
"almcrepo.Fecha" "Entrega" ? "date" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   = INTEGRAL.almcrepo.FchVto
     _FldNameList[10]   > INTEGRAL.almcrepo.NroSer
"almcrepo.NroSer" ? ? "integer" ? ? ? ? ? ? no ? no no "5.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   = INTEGRAL.almcrepo.NroDoc
     _FldNameList[12]   > INTEGRAL.almcrepo.MotReposicion
"almcrepo.MotReposicion" "Motivo" "x(60)" "character" 11 0 ? ? ? ? yes ? no no "34.43" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "Uno,Uno" 5 no 0 no no
     _FldNameList[13]   > INTEGRAL.almcrepo.Glosa
"almcrepo.Glosa" ? ? "character" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.almcrepo.FchApr
"almcrepo.FchApr" "Fecha!Aprob." ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > INTEGRAL.almcrepo.HorApr
"almcrepo.HorApr" "Hora!Aprob." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME almcrepo.VtaPuntual
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almcrepo.VtaPuntual br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF almcrepo.VtaPuntual IN BROWSE br_table /* Urgente */
DO:
/*     ASSIGN BROWSE {&BROWSE-NAME} {&SELF-NAME} NO-ERROR. */
/*     RUN dispatch IN THIS-PROCEDURE ('update-record':U). */
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


&Scoped-define SELF-NAME almcrepo.Glosa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL almcrepo.Glosa br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF almcrepo.Glosa IN BROWSE br_table /* Observaciones */
DO:
/*     ASSIGN BROWSE {&BROWSE-NAME} {&SELF-NAME} NO-ERROR. */
/*     RUN dispatch IN THIS-PROCEDURE ('update-record':U). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* APROBAR */
DO:
   SESSION:SET-WAIT-STATE('GENERAL').
   RUN Aprobar.
   SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 B-table-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* REFRESCAR */
DO:
  /*RUN dispatch IN THIS-PROCEDURE ('open-query':U).*/
  RUN Procesa-Handle IN lh_handle ('open-queries').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 B-table-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* RECHAZAR */
DO:
  RUN Rechazar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-AlmPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-AlmPed B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-AlmPed IN FRAME F-Main /* Filtrar por Despacho */
DO:
  ASSIGN {&self-name}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-CodAlm B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-CodAlm IN FRAME F-Main /* Filtrar por Solicitante */
DO:
  ASSIGN {&self-name}.
  IF NOT CAN-FIND(FIRST Almcrepo WHERE {&Condicion} NO-LOCK) THEN DO:
      MESSAGE 'Fin de Archivo' VIEW-AS ALERT-BOX WARNING.
      SELF:SCREEN-VALUE = 'Todos'.
      RETURN NO-APPLY.
  END.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Motivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Motivo B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Motivo IN FRAME F-Main /* Motivo */
DO:
    ASSIGN {&self-name}.
    IF NOT CAN-FIND(FIRST Almcrepo WHERE {&Condicion} NO-LOCK) THEN DO:
        MESSAGE 'Fin de Archivo' VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = 'Todos'.
        RETURN NO-APPLY.
    END.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-Usuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-Usuario B-table-Win
ON LEAVE OF FILL-IN-Usuario IN FRAME F-Main /* Usuario */
DO:
    ASSIGN {&self-name}.
    IF NOT CAN-FIND(FIRST Almcrepo WHERE {&Condicion} NO-LOCK) THEN DO:
        MESSAGE 'Fin de Archivo' VIEW-AS ALERT-BOX WARNING.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Informacin_de_la_Anulacin_d
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Informacin_de_la_Anulacin_d B-table-Win
ON CHOOSE OF MENU-ITEM m_Informacin_de_la_Anulacin_d /* Información de la Anulación de la OTR */
DO:
  IF AVAILABLE almcrepo THEN RUN alm/d-aprob-mot-anul (ROWID(almcrepo)).
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
DEF VAR k AS INT NO-UNDO.

DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}
    TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:
        IF NOT (almcrepo.flgest = s-FlgEst AND almcrepo.flgsit = s-FlgSit) THEN NEXT.
        FIND B-CREPO WHERE ROWID(B-CREPO) = ROWID(almcrepo) EXCLUSIVE-LOCK NO-ERROR.    /*NO-WAIT.*/
        IF NOT AVAILABLE B-CREPO THEN NEXT.
        ASSIGN
            B-CREPO.FchApr = TODAY
            B-CREPO.FlgSit = 'A'       /* Aprobado */
            B-CREPO.HorApr = STRING(TIME, 'HH:MM')
            B-CREPO.UsrApr = s-user-id.
        /* RHC Paso Previo */
/*         ASSIGN                                                      */
/*             B-CREPO.FlgSit = 'WL'.     /* Por Aprobar Logistica */ */
        /* Ic - 14Set2016, Aprobacion y Generacion de OTR automaticamente */
        pMensaje = ''.
        pMensaje2 = ''.
        RUN generar-OTR.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, LEAVE.
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
IF pMensaje2 > '' THEN MESSAGE pMensaje2 VIEW-AS ALERT-BOX INFORMATION.
/*RUN dispatch IN THIS-PROCEDURE ('open-query').*/
RUN Procesa-Handle IN lh_handle ('open-queries').

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

  /* SE ATIENDE LO QUE HAY, LO QUE QUEDA YA NO SE ATIENDE */
  /* PRIMERA PASADA: CARGAMOS STOCK DISPONIBLE */
  /* RHC 25.08.2014 NO MAS DE 52 ITEMS (13 * 4) */
  DEF VAR t-AlmDes AS CHAR NO-UNDO.
  DEF VAR t-CanPed AS DEC NO-UNDO.
  DETALLES:
  FOR EACH Almdrepo OF Almcrepo NO-LOCK WHERE (Almdrepo.CanApro - Almdrepo.CanAten) > 0,
      FIRST Almmmatg OF Almdrepo NO-LOCK:
      /* BARREMOS LOS ALMACENES VALIDOS Y DECIDIMOS CUAL ES EL MEJOR DESPACHO */
      /* RHC AHORA ES UN SOLO ALMACEN */
      f-Factor = 1.
      t-AlmDes = ''.
      t-CanPed = 0.
      ALMACENES:
      DO i = 1 TO NUM-ENTRIES(lAlmDespacho):
          F-CANPED = (Almdrepo.CanApro - Almdrepo.CanAten).
          x-CodAlm = ENTRY(i, lAlmDespacho).  /* s-CodAlm */
          /* FILTROS */
          FIND Almmmate WHERE Almmmate.codcia = s-codcia
              AND Almmmate.codalm = x-CodAlm  /* *** OJO *** */
              AND Almmmate.codmat = Almdrepo.CodMat
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Almmmate THEN DO:
              MESSAGE 'Producto' Almdrepo.codmat 'NO asignado al almacén' x-CodAlm
                  VIEW-AS ALERT-BOX WARNING.
              NEXT ALMACENES.
          END.
          x-StkAct = Almmmate.StkAct.
          RUN vta2/Stock-Comprometido-v2 (Almdrepo.CodMat, x-CodAlm, OUTPUT s-StkComprometido).
          s-StkDis = x-StkAct - s-StkComprometido + (f-CanPed * f-Factor).
          
          /* DEFINIMOS LA CANTIDAD */
          x-CanPed = f-CanPed * f-Factor.
          IF s-StkDis <= 0 THEN NEXT ALMACENES.

          IF s-StkDis < x-CanPed THEN DO:
              f-CanPed = ((S-STKDIS - (S-STKDIS MODULO f-Factor)) / f-Factor).
          END.
          /* EMPAQUE OTROS */
          IF s-FlgEmpaque = YES THEN DO:
              IF Almmmatg.DEC__03 > 0 THEN f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).
          END.
          f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).
          IF f-CanPed <= 0 THEN NEXT ALMACENES.
          IF f-CanPed > t-CanPed THEN DO:
              t-CanPed = f-CanPed.
              t-AlmDes = x-CodAlm.
          END.
      END.
      IF t-CanPed > 0 THEN DO:
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
                  PEDI.CanPed = t-CanPed    /* << OJO << */
                  PEDI.CanAte = 0.
          ASSIGN
              PEDI.Libre_d01 = (Almdrepo.CanApro - Almdrepo.CanAten)
              PEDI.Libre_d02 = t-CanPed
              PEDI.Libre_c01 = '*'.
          ASSIGN
              PEDI.UndVta = Almmmatg.UndBas.
          /* FIN DE CARGA */
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable-filtros B-table-Win 
PROCEDURE disable-filtros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          BUTTON-1:SENSITIVE = NO
          BUTTON-2:SENSITIVE = NO
          BUTTON-4:SENSITIVE = NO
          COMBO-BOX-AlmPed:SENSITIVE = NO
          COMBO-BOX-CodAlm:SENSITIVE = NO
          COMBO-BOX-Motivo:SENSITIVE = NO
          FILL-IN-Usuario:SENSITIVE = NO.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Enable-Filtros B-table-Win 
PROCEDURE Enable-Filtros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          BUTTON-1:SENSITIVE = YES
          BUTTON-2:SENSITIVE = YES
          BUTTON-4:SENSITIVE = YES
          COMBO-BOX-AlmPed:SENSITIVE = YES
          COMBO-BOX-CodAlm:SENSITIVE = YES
          COMBO-BOX-Motivo:SENSITIVE = YES
          FILL-IN-Usuario:SENSITIVE = YES.
  END.

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
    BREAK BY SUBSTRING(Almmmate.CodUbi,1,2):

    IF FIRST-OF(SUBSTRING(Almmmate.CodUbi,1,2)) THEN DO:
        /* Ic - 29Nov2016, G- = G0 */
        lSector = CAPS(SUBSTRING(Almmmate.CodUbi,1,2)).
        lUbic = TRIM(Almmmate.CodUbi).
        lSectorOK = NO.
        /* Si el sector es Correcto y el codigo de la ubicacion esta OK */
        IF (lSector >= '01' AND lSector <= '06') AND LENGTH(lUbic) = 7 THEN DO:
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-OTR B-table-Win 
PROCEDURE generar-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* El almacen de despacho */
FIND FIRST Almacen WHERE Almacen.codcia = s-codcia
      AND Almacen.codalm = Almcrepo.almped NO-LOCK NO-ERROR.
IF NOT AVAILABLE almacen THEN DO:
    MESSAGE 'Almacen de despacho ' almcrepo.almped 'No existe' VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
lDivDespacho = Almacen.CodDiv.
lAlmDespacho = Almcrepo.almped.

FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDiv = lDivDespacho AND
    FacCorre.CodDoc = S-CODDOC
      NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   MESSAGE "Codigo de Documento " s-coddoc " No configurado para la division " lDivDespacho VIEW-AS ALERT-BOX WARNING.
   RETURN "ADM-ERROR".
END.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = lDivDespacho
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' lDivDespacho 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.

ASSIGN
    s-DiasVtoPed = GN-DIVI.DiasVtoPed
    s-FlgEmpaque = GN-DIVI.FlgEmpaque
    s-VentaMayorista = GN-DIVI.VentaMayorista.

FIND FIRST VtaAlmDiv WHERE Vtaalmdiv.codcia = s-codcia
    AND Vtaalmdiv.coddiv = lDivDespacho
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaAlmDiv THEN DO:
    MESSAGE 'NO se han definido los almacenes de ventas para la división' lDivDespacho VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.

DEFINE VAR lHora AS CHAR.
DEFINE VAR lDias AS INT.
DEFINE VAR lHoraTope AS CHAR.
DEFINE VAR lFechaPedido AS DATE.

/* La serie segun el almacen de donde se desea despachar(Almcrepo.almped) segun la R/A */
s-NroSer = FacCorre.NroSer.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
  AND FacCorre.CodDoc = S-CODDOC 
  AND FacCorre.NroSer = s-NroSer
  NO-LOCK.
IF FacCorre.FlgEst = NO THEN DO:
  MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
  RETURN 'ADM-ERROR'.
END.
FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.


DEFINE VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
DEFINE VARIABLE s-FlgBarras LIKE GN-DIVI.FlgBarras.

pMensaje = ''.
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* Paso 01 : Llenar el Temporal con el detalle de los Articulos */
    RUN cargar-temporal-otr.

    /* Paso 02 : Adiciono el Registro en la Cabecera */
    {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}

    /* Controlar la hora de aprobacion para calcular la fecha del pedido*/
    lHora = STRING(TIME,"HH:MM:SS").
    lDias = 2.
    lHoraTope = '17'.   /* 5pm */
    lFechaPedido = TODAY.

    /* Si es SABADO o la hora es despues de la CINCO (17pm)*/
    IF WEEKDAY(TODAY) = 7  OR SUBSTRING(lHora,1,2) >= lHoraTope THEN DO:
        lDias = 1.
        /* Si es VIERNES despues de la 5pm */
        IF WEEKDAY(TODAY) = 6 THEN lDias = lDias + 1.
    END.
    lFechaPedido = lFechaPedido + lDias.
    /* RHC 27/02/17 Tomamos la fecha mayor.*/
    lFechaPedido = MAXIMUM(lFechaPedido,almcrepo.fecha).
    IF lFechaPedido <> Almcrepo.Fecha THEN pMensaje2 = "Se cambió la fecha de entrega a " + STRING(lFechaPedido).

    CREATE Faccpedi.

    FIND Almacen WHERE Almacen.codcia = s-codcia
      AND Almacen.codalm = Almcrepo.codalm NO-LOCK NO-ERROR.

    ASSIGN 
        Faccpedi.CodCia = S-CODCIA
        Faccpedi.CodDoc = s-coddoc 
        Faccpedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        Faccpedi.CodRef = s-codref      /* R/A */
        Faccpedi.FchPed = TODAY
        Faccpedi.CodDiv = lDivDespacho
        Faccpedi.FlgEst = "P"       /* APROBADO */
        FacCPedi.TpoPed = s-TpoPed
        FacCPedi.FlgEnv = YES
        FacCPedi.Libre_c01 = s-User-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM')
        /*FacCPedi.Fchent = IF (almcrepo.fecha < lFechaPedido) THEN lFechaPedido ELSE almcrepo.fecha*/
        FacCPedi.Fchent = lFechaPedido
        Faccpedi.FchVen = lFechaPedido + 7
        Faccpedi.CodCli = Almcrepo.CodAlm
        Faccpedi.NomCli = Almacen.Descripcion
        Faccpedi.Dircli = Almacen.DirAlm
        FacCPedi.NroRef = STRING(almcrepo.nroser,"999") + STRING(almcrepo.nrodoc,"999999")
        FacCPedi.CodAlm = lAlmDespacho
        FacCPedi.Glosa = Almcrepo.Glosa.
    /* Motivo */
    ASSIGN FacCPedi.MotReposicion = Almcrepo.MotReposicion.
    ASSIGN FacCPedi.VtaPuntual = Almcrepo.VtaPuntual.
    ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
    ASSIGN B-CREPO.Fecha = lFechaPedido.    /* OJO */

    /* TRACKING */
    RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                            Faccpedi.CodDiv,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef,
                            s-User-Id,
                            'GOT',    /* Generación OTR */
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef)
        NO-ERROR.

    /* Actualizamos la hora cuando lo vuelve a modificar */
    ASSIGN
        Faccpedi.Usuario = S-USER-ID
        Faccpedi.Hora   = STRING(TIME,"HH:MM").

    /* Division destino */
    FIND Almacen OF Faccpedi NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN FacCPedi.DivDes = Almacen.CodDiv.

    /* CONTROL DE OTROS PROCESOS POR DIVISION */
    FIND gn-divi WHERE gn-divi.codcia = Faccpedi.codcia
        AND gn-divi.coddiv = Faccpedi.divdes
        NO-LOCK.
    ASSIGN
        s-FlgPicking = GN-DIVI.FlgPicking
        s-FlgBarras  = GN-DIVI.FlgBarras.
    IF s-FlgPicking = YES THEN FacCPedi.FlgSit = "T".    /* Por Pre-Pickear */
    IF s-FlgPicking = NO AND s-FlgBarras = NO THEN FacCPedi.FlgSit = "C".    /* Barras OK */
    IF s-FlgPicking = NO AND s-FlgBarras = YES THEN FacCPedi.FlgSit = "P".   /* Pre-Picking OK */
      /* ******************************************************** */
      /* RHC 08/02/2016 Pedido de Pablo Wong DIRECTO A DISTRIBUCION */
    /*   IF s-CodDiv = "00000" AND Faccpedi.FchPed <= DATE(03,31,2016) */
    /*       AND FacCPedi.FlgSit = "T" THEN FacCPedi.FlgSit = "P".     */
      /* ******************************************************** */
      /* Detalle del Pedido */

    RUN Genera-Pedido.    /* Detalle del pedido */
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = 'NO se pudo generar el pedido' + CHR(10) + 'NO hay stock suficiente en los almacenes'.
        UNDO, LEAVE.
    END.

    /* Actualizamos la cotizacion */
    RUN alm/pactualizareposicion ( ROWID(Faccpedi), "C", OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = 'NO se pudo extornar la R/A'.
        UNDO, LEAVE.
    END.
    /* *********************************************************** */
    /* *********************************************************** */
    RUN Genera-SubOrden.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = 'NO se pudo generar la sub-orden'.
        UNDO, LEAVE.
    END.

    /* ************ CREAMOS VARIAS OTRs SI FUERA NECESARIO ************* */
    REPEAT:
        FIND FIRST PEDI NO-ERROR.
        IF NOT AVAILABLE PEDI THEN LEAVE.
        CREATE B-CPEDI.
        BUFFER-COPY FacCPedi TO B-CPEDI ASSIGN B-CPEDI.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999").
        ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
        FIND FacCPedi WHERE ROWID(Faccpedi) = ROWID(B-CPEDI).
        RUN Genera-Pedido.    /* Detalle del pedido */
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = 'NO se pudo generar el pedido' + CHR(10) + 'NO hay stock suficiente en los almacenes'.
            UNDO, LEAVE.
        END.
        /* Actualizamos la cotizacion */
        RUN alm/pactualizareposicion ( ROWID(Faccpedi), "C", OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = 'NO se pudo extornar la R/A'.
            UNDO, LEAVE.
        END.
        /* *********************************************************** */
        RUN Genera-SubOrden.
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = 'NO se pudo generar la sub-orden'.
            UNDO, LEAVE.
        END.
    END.
END.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.
IF pMensaje <> '' THEN RETURN 'ADM-ERROR'.
ELSE RETURN 'OK'.
/* -------------------------------------      */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-CodAlm:DELIMITER = '|'.
      COMBO-BOX-AlmPed:DELIMITER = '|'.
      FOR EACH TabGener NO-LOCK WHERE TabGener.codcia = s-codcia
          AND TabGener.clave = "ZG"
          AND TabGener.libre_l01 = YES,
          FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
          AND Almacen.codalm = TabGener.libre_c01:
          COMBO-BOX-AlmPed:ADD-LAST( Almacen.CodAlm + ' - ' + Almacen.Descripcion, Almacen.CodAlm ).
      END.
      FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
          AND Almacen.campo-c[9] <> "I"
          AND Almacen.flgrep = YES:
          COMBO-BOX-CodAlm:ADD-LAST( Almacen.CodAlm + ' - ' + Almacen.Descripcion, Almacen.CodAlm ).
      END.
      COMBO-BOX-Motivo:DELIMITER = '|'.
      FOR EACH FacTabla NO-LOCK WHERE FacTabla.CodCia = s-codcia
          AND FacTabla.Tabla = 'REPOMOTIVO':
          COMBO-BOX-Motivo:ADD-LAST(FacTabla.Nombre, FacTabla.Codigo).
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /*almcrepo.MotReposicion:DELIMITER IN BROWSE {&BROWSE-NAME} = '|'.*/
  almcrepo.MotReposicion:DELETE(1) IN BROWSE {&BROWSE-NAME}.
  almcrepo.MotReposicion:ADD-LAST('Sin Motivo', ' ').
  FOR EACH FacTabla NO-LOCK WHERE FacTabla.CodCia = s-codcia
      AND FacTabla.Tabla = 'REPOMOTIVO':
      almcrepo.MotReposicion:ADD-LAST(FacTabla.Nombre, FacTabla.Codigo).
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

/* Selección múltiple  */
DEF VAR k AS INT NO-UNDO.

DO k = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(k) THEN DO:
        IF NOT (almcrepo.flgest = s-FlgEst AND almcrepo.flgsit = s-FlgSit) THEN NEXT.
        FIND CURRENT almcrepo EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        ASSIGN
            almcrepo.FchApr = TODAY
            almcrepo.FlgSit = 'R'       /* Rechazado */
            almcrepo.HorApr = STRING(TIME, 'HH:MM')
            almcrepo.UsrApr = s-user-id.
        FIND CURRENT almcrepo NO-LOCK NO-ERROR.
    END.
END.
/*RUN dispatch IN THIS-PROCEDURE ('open-query').*/
RUN Procesa-Handle IN lh_handle ('open-queries').

/* Selección simple */
/* IF NOT AVAILABLE almcrepo THEN RETURN.                                                       */
/* IF NOT (almcrepo.flgest = s-FlgEst AND almcrepo.flgsit = s-FlgSit) THEN DO:                  */
/*     MESSAGE 'Este pedido NO se encuentra pendiente de aprobación' VIEW-AS ALERT-BOX WARNING. */
/*     RUN dispatch IN THIS-PROCEDURE ('open-query').                                           */
/*     RETURN.                                                                                  */
/* END.                                                                                         */
/* FIND CURRENT almcrepo EXCLUSIVE-LOCK NO-ERROR.                                               */
/* IF NOT AVAILABLE almcrepo THEN RETURN.                                                       */
/* ASSIGN                                                                                       */
/*     almcrepo.FchApr = TODAY                                                                  */
/*     almcrepo.FlgSit = 'R'       /* Rechazado */                                              */
/*     almcrepo.HorApr = STRING(TIME, 'HH:MM')                                                  */
/*     almcrepo.UsrApr = s-user-id.                                                             */
/* FIND CURRENT almcrepo NO-LOCK NO-ERROR.                                                      */
/* RUN dispatch IN THIS-PROCEDURE ('open-query').                                               */

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

