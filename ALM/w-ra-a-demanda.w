&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATE FOR Almmmate.
DEFINE BUFFER B-MATE2 FOR Almmmate.
DEFINE BUFFER B-MATG FOR Almmmatg.
DEFINE TEMP-TABLE t-Almtfami NO-UNDO LIKE Almtfami.
DEFINE TEMP-TABLE T-DREPO NO-UNDO LIKE RepAutomDetail
       FIELD VtaGrp30 AS DEC
       FIELD VtaGrp60 AS DEC
       FIELD VtaGrp90 AS DEC
       FIELD VtaGrp30y AS DEC
       FIELD VtaGrp60y AS DEC
       FIELD VtaGrp90y AS DEC
       FIELD DesStkTra AS DEC
       .
DEFINE TEMP-TABLE T-DREPO-2 NO-UNDO LIKE RepAutomDetail.
DEFINE TEMP-TABLE T-GENER NO-UNDO LIKE TabGener.
DEFINE TEMP-TABLE T-MATE NO-UNDO LIKE Almmmate.
DEFINE TEMP-TABLE T-MATE-2 NO-UNDO LIKE Almmmate
       FIELD DesStkMax AS DEC
       FIELD DesStkDis AS DEC
       FIELD DesStkTra AS DEC.
DEFINE TEMP-TABLE T-MATG NO-UNDO LIKE Almmmatg.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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

DEF VAR s-Reposicion AS LOG.     /* Campaña Yes, No Campaña No */
DEF VAR s-CodAlm AS CHAR NO-UNDO.

DEF VAR FILL-IN-PorStkMax AS DECI INIT 100 NO-UNDO.
DEF VAR FILL-IN-PorRep AS DECI INIT 100 NO-UNDO.

FIND Almcfggn WHERE Almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcfggn OR AlmCfgGn.Temporada = '' THEN DO:
    MESSAGE 'Debe definir primero si estamos en temporadad de Campaña o NO Campaña'
        VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.


DEF SHARED VAR s-coddiv AS CHAR.
DEF NEW SHARED VAR s-TipoCalculo AS CHAR.

DEFINE TEMP-TABLE tmp-tabla
    FIELD t-CodAlm LIKE Almacen.codalm  FORMAT 'x(3)'
    FIELD t-CodDoc LIKE FacDPedi.CodDoc FORMAT "XXX"
    FIELD t-Nroped LIKE FacDPedi.NroPed FORMAT "XXX-XXXXXXXX"
    FIELD t-CodDiv LIKE FacCPedi.CodDiv FORMAT 'x(5)'
    FIELD t-FchPed LIKE FacDPedi.FchPed
    FIELD t-NomCli LIKE FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
    FIELD t-CodMat LIKE FacDPedi.codmat
    FIELD t-Canped LIKE FacDPedi.CanPed.

/* Temporal para el Excel */
DEF TEMP-TABLE Detalle
    FIELD NroItm AS INT                                 COLUMN-LABEL 'Item'
    FIELD CodMat LIKE Almmmatg.codmat                   COLUMN-LABEL 'Codigo'
    FIELD DesMat LIKE Almmmatg.desmat FORMAT 'x(100)'   COLUMN-LABEL 'Descripcion'
    FIELD DesMar LIKE Almmmatg.desmar                   COLUMN-LABEL 'Marca'
    FIELD UndStk LIKE Almmmatg.undstk FORMAT 'x(10)'    COLUMN-LABEL 'Unidad'
    FIELD AlmPed LIKE Almacen.codalm                    COLUMN-LABEL 'Almacen Despacho'
    FIELD CanReq AS DEC                                 COLUMN-LABEL 'Cantidad Requerida'
    FIELD CanGen AS DEC                                 COLUMN-LABEL 'Cantidad Generada'
    FIELD SolStkDis AS DEC                              COLUMN-LABEL 'Disponible Solicitante'
    FIELD SolStkMax AS DEC                              COLUMN-LABEL 'Stock Maximo Solicitante'
    FIELD SolStkTra AS DEC                              COLUMN-LABEL 'Transito Solicitante'
    FIELD SolCmpTra AS DEC                              COLUMN-LABEL 'Compras en Transito'
    FIELD PorcReposicion AS DEC                         COLUMN-LABEL '% de Reposicion'
    FIELD DesStkDis AS DEC                              COLUMN-LABEL 'Disponible Despacho'
    FIELD FSDespacho AS DEC                             COLUMN-LABEL 'Faltante/Sobrante Despacho'
    FIELD GrpStkDis AS DEC                              COLUMN-LABEL 'Disponible Grupo'
    FIELD FSGrupo AS DEC                                COLUMN-LABEL 'Faltante/Sobrante Grupo'
    FIELD DesStkMax AS DEC                              COLUMN-LABEL 'Stock Maximo Despacho'
    FIELD EmpReposicion AS DEC                          COLUMN-LABEL 'Empaque Reposicion'
    FIELD EmpMaster AS DEC                              COLUMN-LABEL 'Empaque Master'
    FIELD CtoTotal AS DEC                               COLUMN-LABEL 'Costo de Reposicion'
    FIELD Origen AS CHAR                                COLUMN-LABEL 'Origen'
    FIELD ClfGral AS CHAR                               COLUMN-LABEL 'Clasificacion General'
    FIELD ClfUtil AS CHAR                               COLUMN-LABEL 'Clasificacion Utilex'
    FIELD ClfMayo AS CHAR                               COLUMN-LABEL 'Clasificacion Mayorista'
    FIELD Peso AS DEC                                   COLUMN-LABEL 'Peso en kg'
    FIELD Volumen AS DEC                                COLUMN-LABEL 'Volumen en m3'
    FIELD SolStkAct AS DEC                              COLUMN-LABEL 'Stock Actual'
    FIELD SolStkCom AS DEC                              COLUMN-LABEL 'Stock Reservado'
    FIELD CodFam LIKE Almtfami.codfam                   COLUMN-LABEL 'Linea'
    FIELD DesFam LIKE almtfami.desfam                   COLUMN-LABEL 'Deascripcion'
    FIELD SubFam LIKE Almsfami.subfam                   COLUMN-LABEL 'SubLinea'
    FIELD DesSub LIKE  AlmSFami.dessub                  COLUMN-LABEL 'Descripcion'
    FIELD CodZona AS CHAR                               COLUMN-LABEL 'Sector'
    FIELD CodUbi  AS CHAR                               COLUMN-LABEL 'Ubicacion'
    INDEX llave01 AS PRIMARY NroItm
    .

DEF BUFFER bt-drepo FOR t-drepo-2.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t-Almtfami T-DREPO-2

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 t-Almtfami.codfam t-Almtfami.desfam ~
t-Almtfami.Libre_c01 t-Almtfami.Libre_c02 t-Almtfami.Libre_c03 ~
t-Almtfami.Libre_d01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH t-Almtfami NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH t-Almtfami NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 t-Almtfami
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 t-Almtfami


/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 T-DREPO-2.CodAlm T-DREPO-2.AlmPed ~
T-DREPO-2.CodMat T-DREPO-2.DesMat T-DREPO-2.CanGen T-DREPO-2.UndBas 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH T-DREPO-2 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH T-DREPO-2 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 T-DREPO-2
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 T-DREPO-2


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BUTTON-6 BROWSE-2 BROWSE-4 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Temporada FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "PROCESAR" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-6 
     LABEL "EXCEL" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 101 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Temporada AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1.15
     BGCOLOR 0 FGCOLOR 14 FONT 8 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      t-Almtfami SCROLLING.

DEFINE QUERY BROWSE-4 FOR 
      T-DREPO-2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      t-Almtfami.codfam COLUMN-LABEL "Línea" FORMAT "X(3)":U
      t-Almtfami.desfam FORMAT "X(30)":U WIDTH 35.14
      t-Almtfami.Libre_c01 COLUMN-LABEL "Almacenes!Stock Maximo" FORMAT "x(20)":U
      t-Almtfami.Libre_c02 COLUMN-LABEL "Ranking" FORMAT "x(20)":U
      t-Almtfami.Libre_c03 COLUMN-LABEL "Almacén!Origen" FORMAT "x(20)":U
      t-Almtfami.Libre_d01 COLUMN-LABEL "% Reposicion" FORMAT ">>9.99":U
            WIDTH 10.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 99 BY 4.5
         FONT 4 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      T-DREPO-2.CodAlm COLUMN-LABEL "Almacen!Destino" FORMAT "x(8)":U
      T-DREPO-2.AlmPed COLUMN-LABEL "Almacén!Origen" FORMAT "x(8)":U
      T-DREPO-2.CodMat COLUMN-LABEL "Artículo" FORMAT "x(8)":U
      T-DREPO-2.DesMat FORMAT "X(60)":U WIDTH 70.29
      T-DREPO-2.CanGen COLUMN-LABEL "Cantidad!Generada" FORMAT "ZZZ,ZZ9.99":U
      T-DREPO-2.UndBas COLUMN-LABEL "Unidad" FORMAT "x(8)":U WIDTH 6.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 108 BY 15.35
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Temporada AT ROW 1.27 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     BUTTON-1 AT ROW 1.27 COL 32 WIDGET-ID 64
     BUTTON-6 AT ROW 1.27 COL 47 WIDGET-ID 68
     BROWSE-2 AT ROW 3.15 COL 3 WIDGET-ID 200
     BROWSE-4 AT ROW 8 COL 3 WIDGET-ID 300
     FILL-IN-Mensaje AT ROW 23.62 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 66
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 113.72 BY 24.27
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-MATE B "?" ? INTEGRAL Almmmate
      TABLE: B-MATE2 B "?" ? INTEGRAL Almmmate
      TABLE: B-MATG B "?" ? INTEGRAL Almmmatg
      TABLE: t-Almtfami T "?" NO-UNDO INTEGRAL Almtfami
      TABLE: T-DREPO T "?" NO-UNDO INTEGRAL RepAutomDetail
      ADDITIONAL-FIELDS:
          FIELD VtaGrp30 AS DEC
          FIELD VtaGrp60 AS DEC
          FIELD VtaGrp90 AS DEC
          FIELD VtaGrp30y AS DEC
          FIELD VtaGrp60y AS DEC
          FIELD VtaGrp90y AS DEC
          FIELD DesStkTra AS DEC
          
      END-FIELDS.
      TABLE: T-DREPO-2 T "?" NO-UNDO INTEGRAL RepAutomDetail
      TABLE: T-GENER T "?" NO-UNDO INTEGRAL TabGener
      TABLE: T-MATE T "?" NO-UNDO INTEGRAL Almmmate
      TABLE: T-MATE-2 T "?" NO-UNDO INTEGRAL Almmmate
      ADDITIONAL-FIELDS:
          FIELD DesStkMax AS DEC
          FIELD DesStkDis AS DEC
          FIELD DesStkTra AS DEC
      END-FIELDS.
      TABLE: T-MATG T "?" NO-UNDO INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 24.27
         WIDTH              = 113.72
         MAX-HEIGHT         = 24.27
         MAX-WIDTH          = 178.72
         VIRTUAL-HEIGHT     = 24.27
         VIRTUAL-WIDTH      = 178.72
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 BUTTON-6 F-Main */
/* BROWSE-TAB BROWSE-4 BROWSE-2 F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Temporada IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.t-Almtfami"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.t-Almtfami.codfam
"t-Almtfami.codfam" "Línea" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-Almtfami.desfam
"t-Almtfami.desfam" ? ? "character" ? ? ? ? ? ? no ? no no "35.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-Almtfami.Libre_c01
"t-Almtfami.Libre_c01" "Almacenes!Stock Maximo" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.t-Almtfami.Libre_c02
"t-Almtfami.Libre_c02" "Ranking" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.t-Almtfami.Libre_c03
"t-Almtfami.Libre_c03" "Almacén!Origen" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-Almtfami.Libre_d01
"t-Almtfami.Libre_d01" "% Reposicion" ">>9.99" "decimal" ? ? ? ? ? ? no ? no no "10.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "Temp-Tables.T-DREPO-2"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _FldNameList[1]   > Temp-Tables.T-DREPO-2.CodAlm
"T-DREPO-2.CodAlm" "Almacen!Destino" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-DREPO-2.AlmPed
"T-DREPO-2.AlmPed" "Almacén!Origen" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-DREPO-2.CodMat
"T-DREPO-2.CodMat" "Artículo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-DREPO-2.DesMat
"T-DREPO-2.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no "70.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-DREPO-2.CanGen
"T-DREPO-2.CanGen" "Cantidad!Generada" "ZZZ,ZZ9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-DREPO-2.UndBas
"T-DREPO-2.UndBas" "Unidad" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* PROCESAR */
DO:
  RUN MASTER-TRANSACTION.
  MESSAGE 'Proceso terminado'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* EXCEL */
DO:
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}
    
    
{alm/i-reposicionautomaticav51.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CARGA-REPOSICION W-Win 
PROCEDURE CARGA-REPOSICION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* *************************************************************** */
/* 1ra parte: DETERMINAMOS SI EL PRODUCTO NECESITA REPOSICION O NO */
/* *************************************************************** */
DEF VAR x-StockMaximo AS DEC NO-UNDO.
DEF VAR x-Empaque AS DEC NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.
DEF VAR pAReponer   AS DEC NO-UNDO.
DEF VAR pReposicion AS DEC NO-UNDO.
DEF VAR dFactor AS DEC NO-UNDO.
DEF VAR p      AS INT NO-UNDO.
DEF VAR k      AS INT NO-UNDO.

ASSIGN
    x-StockMaximo   = T-MATE.StkMin     /* Stock Maximo + Seguridad */
    x-Empaque       = T-MATE.StkMax     /* Empaque */
    x-StkAct        = T-MATE.StkAct.    /* Stock Actual - Stock Comprometido */

IF x-Empaque <= 0 OR x-Empaque = ? THEN x-Empaque = 1.   /* RHC 29/02/2016 */
/* INCREMENTAMOS LOS PEDIDOS POR REPOSICION EN TRANSITO + TRANSITO COMPRAS  */
x-StkAct = x-StkAct + T-MATE.StkRep + T-MATE.StkActCbd.

IF x-StkAct < 0 THEN x-StkAct = 0.
IF x-StkAct >= x-StockMaximo THEN RETURN.   /* NO VA */

/* ********************* Cantidad de Reposicion ******************* */
/* Definimos el stock maximo */
/* RHC 05/06/2014 Cambio de filosofía, ahora es el % del stock mínimo */
IF x-StkAct >= (x-StockMaximo * FILL-IN-PorRep / 100) THEN RETURN.    /* NO VA */

/* Se va a reponer en cantidades múltiplo del valor T-MATE.StkMax (EMPAQUE) */
pAReponer = x-StockMaximo - x-StkAct.
pReposicion = pAReponer.    /* RHC 16/06/2017 */
IF pReposicion <= 0 THEN RETURN.    /* NO VA */
pAReponer = pReposicion.    /* OJO */

/* ***************************************************************************** */
/* 2da parte: DISTRIBUIMOS LA CANTIDAD A REPONER ENTRE LOS ALMACENES DE DESPACHO */
/* ***************************************************************************** */
DEF VAR pComprometido AS DEC NO-UNDO.
DEF VAR x-TipMat AS CHAR NO-UNDO.
DEF VAR x-StockDisponible AS DEC NO-UNDO.
DEF VAR x-CanReq AS DEC NO-UNDO.
DEF VAR x-Tolerancia AS DEC NO-UNDO.
DEF VAR x-Item AS INT INIT 1 NO-UNDO.
DEF VAR x-StkMax AS DEC NO-UNDO.

DEF VAR x-ControlDespacho AS LOG INIT NO NO-UNDO.

/* RHC 05/09/2017 Acumulado de CANTIDAD GENERADA */
DEF VAR x-Total-CanGen AS DEC NO-UNDO.
x-Total-CanGen = 0.

IF T-MATG.Chr__02 = "P" THEN x-TipMat = "P". 
ELSE x-TipMat = "T".

DO k = 1 TO NUM-ENTRIES(t-Almtfami.Libre_c03):
    FIND FIRST Almacen WHERE Almacen.codcia = s-codcia 
        AND Almacen.codalm = ENTRY(k, t-Almtfami.Libre_c03)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN NEXT.
    RUN RESUMEN-POR-DESPACHO (ENTRY(k, t-Almtfami.Libre_c03), T-MATE.codmat).
    FIND FIRST T-MATE-2 WHERE T-MATE-2.codcia = s-codcia
        AND T-MATE-2.codalm = ENTRY(k, t-Almtfami.Libre_c03)
        AND T-MATE-2.codmat = T-MATE.CodMat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE T-MATE-2 THEN NEXT.

    /* Incluye Transferencias en Tránsito y Compras en Tránsito */
    x-StockDisponible = T-MATE-2.StkAct - T-MATE-2.StkMin + T-MATE-2.StkRep + T-MATE-2.StkActCbd.
    IF x-StockDisponible <= 0 THEN NEXT.

    /* Se solicitará la reposición de acuerdo al empaque del producto */
    x-CanReq = MINIMUM(x-StockDisponible, pReposicion).

    /* redondeamos al entero superior */
    IF x-CanReq <> TRUNCATE(x-CanReq,0) THEN x-CanReq = TRUNCATE(x-CanReq,0) + 1.

    /* *************************************************** */
    /* RHC 06/07/17 Corregido                              */
    /* *************************************************** */
    IF (x-CanReq / x-Empaque) <> TRUNCATE(x-CanReq / x-Empaque,0) 
        THEN x-CanReq = (TRUNCATE(x-CanReq / x-Empaque,0) + 1) * x-Empaque.

    x-Tolerancia = x-StockMaximo * 1.1.     /* Maximo Solicitante + 10% Tolerancia */
    REPEAT WHILE ( (x-CanReq + x-Total-CanGen) + x-StkAct) > x-Tolerancia:
        x-CanReq = x-CanReq - x-Empaque.
    END.

    /* No debe superar el stock disponible */
    REPEAT WHILE x-CanReq > x-StockDisponible:
        x-CanReq = x-CanReq - x-Empaque.
    END.
    IF x-CanReq <= 0 AND x-StockDisponible > 0 THEN x-ControlDespacho = YES.
    IF x-CanReq <= 0 THEN NEXT.    /* Menos que la cantidad por empaque */
    /* ******************** RHC 18/02/2014 FILTRO POR IMPORTE DE REPOSICION ********************* */
/*     IF T-MATG.MonVta = 2 THEN DO:                                               */
/*         IF x-CanReq * T-MATG.CtoTot * T-MATG.TpoCmb < FILL-IN-ImpMin THEN NEXT. */
/*     END.                                                                        */
/*     ELSE IF x-CanReq * T-MATG.CtoTot < FILL-IN-ImpMin THEN NEXT.                */

    IF x-CanReq = ? THEN NEXT.
    /* ****************************************************************************************** */
    CREATE T-DREPO.
    ASSIGN
        T-DREPO.Origen = 'AUT'
        T-DREPO.CodCia = s-codcia 
        T-DREPO.CodAlm = s-codalm 
        T-DREPO.Item = x-Item
        T-DREPO.AlmPed = ENTRY(k, t-Almtfami.Libre_c03)
        T-DREPO.CodMat = T-MATE.codmat
        T-DREPO.CanReq = pAReponer
        T-DREPO.CanGen = x-CanReq.
    /* RHC 03/07/17 Redondear al empaque */
    IF T-DREPO.CanGen MODULO x-Empaque > 0 THEN DO:
        T-DREPO.CanGen = ( TRUNCATE(T-DREPO.CanGen / x-Empaque, 0) + 1 ) * x-Empaque.
    END.
    /* RHC Acumulamos */
    x-Total-CanGen = x-Total-CanGen + T-DREPO.CanGen.
    /* Del Almacén Solicitante */
    ASSIGN                 
        T-DREPO.SolStkAct = T-MATE.StkAct + T-MATE.StkComprometido
        T-DREPO.SolStkCom = T-MATE.StkComprometido
        T-DREPO.SolStkDis = T-MATE.StkAct
        T-DREPO.SolStkMax = T-MATE.StkMin
        T-DREPO.SolStkTra = T-MATE.StkRep
        T-DREPO.SolCmpTra = T-MATE.StkActCbd
        .
    /* Del Almacén de Despacho */
    ASSIGN
        T-DREPO.DesStkDis = T-MATE-2.StkAct
        T-DREPO.PorcReposicion = (IF T-DREPO.CanReq <> 0 THEN (T-DREPO.CanGen / T-DREPO.CanReq * 100) ELSE 0).
    /* Datos Adicionales */
    ASSIGN
        T-DREPO.ClfGral = fClasificacion(T-DREPO.CodMat).
    ASSIGN
        x-Item = x-Item + 1
        pReposicion = pReposicion - T-DREPO.CanGen.
    IF pReposicion <= 0 THEN LEAVE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-NroItm AS INT NO-UNDO INIT 0.
EMPTY TEMP-TABLE Detalle.

FOR EACH BT-DREPO NO-LOCK WHERE BT-DREPO.codalm = s-codalm,
    FIRST B-MATG OF BT-DREPO NO-LOCK,
    FIRST Almtfami OF B-MATG NO-LOCK,
    FIRST Almsfami OF B-MATG NO-LOCK
    BY B-MATG.desmar BY B-MATG.desmat:
    x-NroItm = x-NroItm + 1.
    CREATE Detalle.
    BUFFER-COPY BT-DREPO TO Detalle
        ASSIGN
        Detalle.nroitm = x-NroItm
        Detalle.desmat = B-MATG.desmat
        Detalle.desmar = B-MATG.desmar
        Detalle.undstk = B-MATG.undstk
        Detalle.FSDespacho = BT-DREPO.DesSaldo
        Detalle.empreposicion = B-MATE.stkmax
        Detalle.empmaster = B-MATG.canemp
        Detalle.ctototal = BT-DREPO.CanGen * (IF B-MATG.MonVta = 2 THEN B-MATG.CtoTot * B-MATG.TpoCmb ELSE B-MATG.CtoTot)
        Detalle.peso = (BT-DREPO.CanGen * B-MATG.Pesmat ) 
        Detalle.volumen = (BT-DREPO.CanGen * B-MATG.Libre_d02 / 1000000)
        Detalle.CodFam = B-MATG.codfam
        Detalle.DesFam = Almtfami.desfam
        Detalle.SubFam = B-MATG.subfam
        Detalle.DesSub = Almsfami.dessub
        .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY FILL-IN-Temporada FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 BUTTON-6 BROWSE-2 BROWSE-4 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel W-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Seleccionamos el almacén */
DEF VAR x-Almacenes AS CHAR NO-UNDO.

FOR EACH bt-drepo NO-LOCK BREAK BY bt-drepo.codalm:
    IF FIRST-OF(bt-drepo.codalm) THEN DO:
        x-Almacenes = x-Almacenes +
            (IF TRUE <> (x-Almacenes > '') THEN '' ELSE ',') +
            bt-drepo.codalm.
    END.
END.
IF TRUE <> (x-Almacenes > '') THEN RETURN.

DEF VAR x-CodAlm AS CHAR NO-UNDO.
DEF VAR x-NomAlm AS CHAR NO-UNDO.
DEF VAR pAlmacenes AS CHAR NO-UNDO.
DEF VAR pTitulo AS CHAR INIT 'Seleccione un almacén destino'.
DEF VAR k AS INTE NO-UNDO.

DO k = 1 TO NUM-ENTRIES(x-Almacenes):
    x-CodAlm = ENTRY(k, x-Almacenes).
    FIND Almacen WHERE Almacen.codcia = s-codcia AND
        Almacen.codalm = x-codalm NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN DO:
        x-CodAlm = Almacen.codalm + " - " + Almacen.descrip.
        RUN lib/limpiar-texto-abc (x-CodAlm, '', OUTPUT x-nomalm).
        pAlmacenes = pAlmacenes + 
            (IF TRUE <> (pAlmacenes > '') THEN '' ELSE '|') +
            x-nomalm.
    END.
END.

DEF VAR pCadena AS CHAR NO-UNDO.

RUN lib/d-selectionlist.w (pAlmacenes,
                           pTitulo,
                           OUTPUT pCadena).
IF TRUE <> (pCadena > '') THEN RETURN.

s-CodAlm = ENTRY(1, pCadena, ' - ').

/* Archivo de Salida */
DEF VAR c-csv-file AS CHAR NO-UNDO.
DEF VAR c-xls-file AS CHAR NO-UNDO.
DEF VAR rpta AS LOG INIT NO NO-UNDO.

c-xls-file = 'Reposicion_Alm_' + s-CodAlm.

SYSTEM-DIALOG GET-FILE c-xls-file
    FILTERS 'Libro de Excel' '*.xlsx'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".xlsx"
    SAVE-AS
    TITLE "Guardar como"
    USE-FILENAME
    UPDATE rpta.
IF rpta = NO THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
/* Variable de memoria */
DEFINE VAR hProc AS HANDLE NO-UNDO.
/* Levantamos la libreria a memoria */
RUN lib\Tools-to-excel PERSISTENT SET hProc.

/* Cargamos la informacion al temporal */
EMPTY TEMP-TABLE Detalle.
RUN Carga-Temporal.

/* Programas que generan el Excel */
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .

RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle:handle,
                                  INPUT  c-csv-file,
                                  OUTPUT c-xls-file) .

/* Borramos librerias de la memoria */
DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').
MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
/*   CREATE t-Almtfami.                    */
/*   ASSIGN                                */
/*       t-Almtfami.CodCia = s-codcia      */
/*       t-Almtfami.codfam = '001'         */
/*       t-Almtfami.Libre_c01 = '03,04,05' */
/*       t-Almtfami.Libre_c02 = 'A,B,C'    */
/*       t-Almtfami.Libre_c03 = '11'       */
/*       t-Almtfami.Libre_d01 = 25.        */
/*   CREATE t-Almtfami.                    */
/*   ASSIGN                                */
/*       t-Almtfami.CodCia = s-codcia      */
/*       t-Almtfami.codfam = '012'         */
/*       t-Almtfami.Libre_c01 = '03,04,05' */
/*       t-Almtfami.Libre_c02 = 'A,B,C'    */
/*       t-Almtfami.Libre_c03 = '14,11'    */
/*       t-Almtfami.Libre_d01 = 25.        */
/*   CREATE t-Almtfami.                    */
/*   ASSIGN                                */
/*       t-Almtfami.CodCia = s-codcia      */
/*       t-Almtfami.codfam = '010'         */
/*       t-Almtfami.Libre_c01 = '03,04,05' */
/*       t-Almtfami.Libre_c02 = ''         */
/*       t-Almtfami.Libre_c03 = '21,11'    */
/*       t-Almtfami.Libre_d01 = 50.        */
/*   CREATE t-Almtfami.                    */
/*   ASSIGN                                */
/*       t-Almtfami.CodCia = s-codcia      */
/*       t-Almtfami.codfam = '013'         */
/*       t-Almtfami.Libre_c01 = '03,04,05' */
/*       t-Almtfami.Libre_c02 = 'A,B,C'    */
/*       t-Almtfami.Libre_c03 = '14,11'    */
/*       t-Almtfami.Libre_d01 = 25.        */

  FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia AND
      FacTabla.Tabla = 'CFG_RA-DEMANDA':
      CREATE t-Almtfami.
      ASSIGN
          t-Almtfami.CodCia = s-codcia
          t-Almtfami.codfam = FacTabla.codigo
          t-Almtfami.Libre_c01 = FacTabla.campo-c[1]
          t-Almtfami.Libre_c02 = FacTabla.campo-c[2]
          t-Almtfami.Libre_c03 = FacTabla.campo-c[3]
          t-Almtfami.Libre_d01 = FacTabla.valor[1]
          .
  END.

  FOR EACH t-Almtfami, FIRST Almtfami OF t-Almtfami NO-LOCK:
      t-Almtfami.desfam = Almtfami.desfam.
  END.

  FIND Almcfggn WHERE Almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
  CASE TRUE:
      WHEN Almcfggn.Temporada = "C" THEN ASSIGN FILL-IN-Temporada = "CAMPAÑA" s-Reposicion = YES.
      WHEN Almcfggn.Temporada = "NC" THEN ASSIGN FILL-IN-Temporada = "NO CAMPAÑA" s-Reposicion = NO.
  END CASE.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION W-Win 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Clasificaciones AS CHAR NO-UNDO.
DEF VAR k AS INTE NO-UNDO.

EMPTY TEMP-TABLE T-DREPO-2.
/* Barremos almacén por almacén, línea por línea */
FOR EACH t-Almtfami WHERE t-Almtfami.CodCia = s-codcia:
    x-Clasificaciones = t-Almtfami.Libre_c02.
    FILL-IN-PorRep    = t-Almtfami.Libre_d01.
    /* Cargamos los artículos a trabajar */
    EMPTY TEMP-TABLE T-MATG.
    FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.tpoart <> "D"
        AND Almmmatg.codfam = t-Almtfami.codfam
        BY Almmmatg.codmat:
        /* Filtro por Clasificación */
        IF x-Clasificaciones > '' THEN DO:
            FIND FIRST FacTabla WHERE FacTabla.codcia = Almmmatg.codcia 
                AND FacTabla.tabla = 'RANKVTA' 
                AND FacTabla.codigo = Almmmatg.codmat
                NO-LOCK NO-ERROR.
            IF AVAILABLE FacTabla THEN DO:
                IF s-Reposicion = YES /* Campaña */ THEN DO:
                    IF LOOKUP(factabla.campo-c[1],x-Clasificaciones) = 0 THEN NEXT.
                END.
                ELSE DO:
                    /* No Campaña */
                    IF LOOKUP(factabla.campo-c[4],x-Clasificaciones) = 0 THEN NEXT.
                END.
            END.
        END.
        FIND FIRST T-MATG OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE T-MATG THEN CREATE T-MATG.
        BUFFER-COPY Almmmatg TO T-MATG.
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
            "(1) CARGANDO ARTICULOS LINEA " + t-Almtfami.codfam + " " + Almmmatg.codmat.
    END.
    /* Barremos almacén por almacén */
    DO k = 1 TO NUM-ENTRIES(t-Almtfami.Libre_c01):
        s-CodAlm = ENTRY(k, t-Almtfami.Libre_c01).
        /* Cantidades a reponer */
        EMPTY TEMP-TABLE T-MATE.
        /* Barremos producto por producto */
        FOR EACH T-MATG NO-LOCK:
            FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
                "(2) SOLICITANDO LINEA " + T-MATG.CodFam + " ALMACEN " + s-CodAlm + " " + "ARTICULO " + T-MATG.CodMat.
            RUN ARTICULOS-A-SOLICITAR (INPUT T-MATG.CodMat, "MAN"). /* OJO: Simulamos una tienda */
            IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.
        END.
        /* Cantidad a reponer */
        EMPTY TEMP-TABLE T-DREPO.
        FOR EACH T-MATG NO-LOCK, EACH T-MATE OF T-MATG NO-LOCK:
            FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
                "(3) REPONIENDO LINEA " + T-MATG.CodFam + " ALMACEN " + s-CodAlm + " " + "ARTICULO " + T-MATG.CodMat.
            RUN CARGA-REPOSICION.
        END.
/*         FOR EACH T-DREPO WHERE T-DREPO.canreq <= 0 AND LOOKUP(T-DREPO.AlmPed, '997,998') = 0: */
/*             DELETE T-DREPO.                                                                   */
/*         END.                                                                                  */
        DEF VAR x-Item AS INT INIT 1 NO-UNDO.
        FOR EACH T-DREPO BY T-DREPO.CodMat:
            T-DREPO.ITEM = x-Item.
            x-Item = x-Item + 1.
        END.
        /* No mas de los items de la reposición */
        FIND FIRST AlmCfgGn WHERE almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
        FOR EACH T-DREPO, FIRST B-MATG OF T-DREPO NO-LOCK:
            RUN DATOS-FINALES.
        END.
        /* ******************************************************************************** */
        FOR EACH T-DREPO:
            CREATE T-DREPO-2.
            BUFFER-COPY T-DREPO TO T-DREPO-2.
        END.
        /* ******************************************************************************** */
    END.
END.
{&OPEN-QUERY-BROWSE-4}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "T-DREPO-2"}
  {src/adm/template/snd-list.i "t-Almtfami"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

