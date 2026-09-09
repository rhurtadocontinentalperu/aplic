&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-articulos-pickeados NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE tt-bultos NO-UNDO LIKE w-report.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEFINE INPUT PARAMETER pCoddoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE INPUT PARAMETER pChequeador AS CHAR.
DEFINE INPUT PARAMETER pCodPer AS CHAR.
DEFINE INPUT PARAMETER pPrioridad AS CHAR.
DEFINE INPUT PARAMETER pEmbalado AS CHAR.
DEFINE INPUT PARAMETER pMesa AS CHAR.
DEFINE OUTPUT PARAMETER pProcesado AS LOG.
DEFINE OUTPUT PARAMETER pItems AS INT.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR x-fecha-inicio AS DATE.
DEFINE VAR x-hora-inicio AS CHAR.

DEFINE VAR x-item AS INT INIT 0.
DEFINE VAR x-bultos AS INT INIT 1.
DEFINE VAR x-items-x-bulto AS INT INIT 0.
DEFINE VAR x-factor AS DEC INIT 1.
DEFINE VAR x-cantidad-x-pickear AS DEC INIT 0.
DEFINE VAR x-bulto-rotulo AS INT.

DEFINE VAR x-msgerror AS CHAR NO-UNDO.

x-fecha-inicio = TODAY.
x-hora-inicio = STRING(TIME,"HH:MM:SS").

DEFINE BUFFER b-ChkTareas FOR ChkTareas.
DEFINE BUFFER b-FacCpedi FOR FacCPedi.

/* Se va usar para la VALIDACION */
DEFINE TEMP-TABLE v-FacDpedi LIKE FacDPedi.

x-msgerror = "".
MARCAMOS_INICIO:
DO TRANSACTION ON ERROR UNDO, LEAVE:
    /* Marcamos la Tarea como en PROCESO*/
    FIND FIRST b-ChkTareas WHERE b-ChkTareas.codcia = s-codcia AND 
                                    b-ChkTareas.coddiv = s-coddiv AND 
                                    b-ChkTareas.mesa = pMesa AND 
                                    b-ChkTareas.coddoc = pCoddoc AND 
                                    b-ChkTareas.nroped = pNrodoc AND 
                                    b-ChkTareas.flgest = 'P' EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE b-ChkTareas THEN DO:
        x-msgerror = "La tarea NO esta en la colo de Chequeo".
        UNDO MARCAMOS_INICIO, LEAVE MARCAMOS_INICIO.
    END.

    /* Marcamos como proceso de Pickeo */
    FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                            b-faccpedi.coddoc = pCoddoc AND 
                            b-faccpedi.nroped = pNroDoc
                            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE b-faccpedi THEN DO:
        x-msgerror = "La orden no existe ó esta bloqueada...verifiquelo!!!".
        UNDO MARCAMOS_INICIO, LEAVE MARCAMOS_INICIO.
    END.

    IF NOT (b-faccpedi.flgest = 'P' AND b-faccpedi.flgsit = "PT") THEN DO:
        x-msgerror = "La orden NO esta en la cola de chequeo".
        UNDO MARCAMOS_INICIO, LEAVE MARCAMOS_INICIO.
    END.

    /**/
    ASSIGN b-ChkTareas.flgest = 'X' NO-ERROR.
    /**/
    ASSIGN b-faccpedi.flgsit = 'PK' NO-ERROR.   /* Lo ponemos en proceso de chequeo */

END.
IF x-msgerror <> "" THEN DO:    
    RELEASE b-ChkTareas.
    RELEASE b-faccpedi.

    MESSAGE x-msgerror.
    RETURN ERROR.
END.

/* Desbloqueamos */
FIND CURRENT b-faccpedi NO-LOCK NO-ERROR.
FIND CURRENT b-ChkTareas NO-LOCK NO-ERROR.

DEFINE VAR x-graficos AS CHAR.
DEFINE VAR x-grafico-rotulo AS CHAR.

/* Rotulo */
x-graficos = "€ƒŒ£§©µÄËÐØÞßæø±å†Š®¾½¼ÆÖÜÏ¶Ÿ¥#$%&‰".
x-bulto-rotulo = RANDOM ( 1 , LENGTH(x-graficos) ).

x-grafico-rotulo = SUBSTRING(x-graficos,x-bulto-rotulo,1).
x-bulto-rotulo = RANDOM ( 1 , 999999 ).

/*  */
DEFINE TEMP-TABLE ttBultosTmp
    FIELD   tBulto  AS  CHAR    FORMAT 'x(25)'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-12

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-articulos-pickeados

/* Definitions for BROWSE BROWSE-12                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-12 tt-articulos-pickeados.Campo-I[1] ~
tt-articulos-pickeados.Campo-C[1] tt-articulos-pickeados.Campo-C[2] ~
tt-articulos-pickeados.Campo-C[3] tt-articulos-pickeados.Campo-C[4] ~
tt-articulos-pickeados.Campo-F[1] tt-articulos-pickeados.Campo-F[2] ~
tt-articulos-pickeados.Campo-F[3] tt-articulos-pickeados.Campo-C[5] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-12 
&Scoped-define QUERY-STRING-BROWSE-12 FOR EACH tt-articulos-pickeados NO-LOCK ~
    BY tt-articulos-pickeados.Campo-I[1] INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-12 OPEN QUERY BROWSE-12 FOR EACH tt-articulos-pickeados NO-LOCK ~
    BY tt-articulos-pickeados.Campo-I[1] INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-12 tt-articulos-pickeados
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-12 tt-articulos-pickeados


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-12}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-del-item FILL-IN-articulo ~
FILL-IN-cantidad BROWSE-12 Btn_OK Btn_Cancel BUTTON-1 BUTTON-imprimir ~
FILL-IN-bultos TOGGLE-multiple RECT-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-articulo FILL-IN-cantidad ~
FILL-IN-descripcion FILL-IN-orden FILL-IN-cliente FILL-IN-chequeador ~
FILL-IN-embalado FILL-IN-crossdocking FILL-IN-prioridad FILL-IN-bulto ~
FILL-IN-bultos TOGGLE-multiple FILL-IN-tiempo FILL-IN-factor FILL-IN-marca 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD centrar-texto D-Dialog 
FUNCTION centrar-texto RETURNS LOGICAL
  ( INPUT h AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-BROWSE-12 
       MENU-ITEM m_Eliminar_item LABEL "Eliminar item" 
       MENU-ITEM m_Observar_item LABEL "Observar item" .


/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Salir" 
     SIZE 15 BY 1.15
     BGCOLOR 12 FGCOLOR 15 .

DEFINE BUTTON Btn_OK 
     LABEL "CERRAR ORDEN" 
     SIZE 18 BY 1.15
     BGCOLOR 2 FGCOLOR 15 .

DEFINE BUTTON BUTTON-1  NO-CONVERT-3D-COLORS
     LABEL "Cerrar Bulto" 
     SIZE 12 BY 1.12
     BGCOLOR 9 FGCOLOR 15 .

DEFINE BUTTON BUTTON-del-item 
     LABEL "Eliminar Item" 
     SIZE 14 BY 1.15
     BGCOLOR 12 FGCOLOR 9 .

DEFINE BUTTON BUTTON-imprimir 
     LABEL "Imprimir" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-articulo AS CHARACTER FORMAT "X(18)":U 
     LABEL "Articulo" 
     VIEW-AS FILL-IN 
     SIZE 20.72 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-bulto AS CHARACTER FORMAT "X(60)":U INITIAL "OTR-000000127-B003" 
     LABEL "Bulto" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1.15
     FGCOLOR 2 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-bultos AS CHARACTER FORMAT "X(25)":U INITIAL "BULTOS : 999" 
     VIEW-AS FILL-IN 
     SIZE 21.29 BY 1
     BGCOLOR 0 FGCOLOR 14 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-cantidad AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Cantidad" 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-chequeador AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1
     FGCOLOR 4 FONT 17 NO-UNDO.

DEFINE VARIABLE FILL-IN-cliente AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1
     FGCOLOR 1 FONT 17 NO-UNDO.

DEFINE VARIABLE FILL-IN-crossdocking AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1
     FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-descripcion AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY 1
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-embalado AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1
     FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-factor AS DECIMAL FORMAT ">>,>>9.99":U INITIAL 0 
     LABEL "Factor" 
     VIEW-AS FILL-IN 
     SIZE 7.86 BY 1
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-marca AS CHARACTER FORMAT "X(60)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 26 BY 1
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-orden AS CHARACTER FORMAT "X(60)":U INITIAL "OTR 000 000127" 
     LABEL "Orden" 
     VIEW-AS FILL-IN 
     SIZE 27.43 BY 1.15
     FGCOLOR 9 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-prioridad AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 17.86 BY 1
     FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-tiempo AS CHARACTER FORMAT "X(25)":U 
     VIEW-AS FILL-IN 
     SIZE 21.29 BY 1.31
     FGCOLOR 12 FONT 8 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 145 BY 1.73.

DEFINE VARIABLE TOGGLE-multiple AS LOGICAL INITIAL no 
     LABEL "Ingreso multiple" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .77
     BGCOLOR 14 FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-12 FOR 
      tt-articulos-pickeados SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-12 D-Dialog _STRUCTURED
  QUERY BROWSE-12 NO-LOCK DISPLAY
      tt-articulos-pickeados.Campo-I[1] COLUMN-LABEL "No" FORMAT ">,>>9":U
            WIDTH 6.43
      tt-articulos-pickeados.Campo-C[1] COLUMN-LABEL "Codigo" FORMAT "X(6)":U
            WIDTH 9.43
      tt-articulos-pickeados.Campo-C[2] COLUMN-LABEL "Descripcion" FORMAT "X(50)":U
            WIDTH 37.29
      tt-articulos-pickeados.Campo-C[3] COLUMN-LABEL "Marca" FORMAT "X(20)":U
            WIDTH 26.57
      tt-articulos-pickeados.Campo-C[4] COLUMN-LABEL "Unidad" FORMAT "X(5)":U
      tt-articulos-pickeados.Campo-F[1] COLUMN-LABEL "Cantidad" FORMAT ">>,>>9.99":U
            WIDTH 8.43
      tt-articulos-pickeados.Campo-F[2] COLUMN-LABEL "Factor" FORMAT ">>9.99":U
            WIDTH 8.57
      tt-articulos-pickeados.Campo-F[3] COLUMN-LABEL "Calculado" FORMAT ">>,>>9.99":U
      tt-articulos-pickeados.Campo-C[5] COLUMN-LABEL "Nro. Bulto" FORMAT "X(25)":U
            WIDTH 25.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 146 BY 19.23 ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BUTTON-del-item AT ROW 4 COL 105 WIDGET-ID 56
     FILL-IN-articulo AT ROW 5.88 COL 2.15 WIDGET-ID 44
     FILL-IN-cantidad AT ROW 5.88 COL 82 COLON-ALIGNED WIDGET-ID 50
     FILL-IN-descripcion AT ROW 5.88 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     BROWSE-12 AT ROW 7.54 COL 3 WIDGET-ID 200
     FILL-IN-orden AT ROW 1 COL 6.29 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-cliente AT ROW 1.15 COL 45 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     FILL-IN-chequeador AT ROW 1.19 COL 112 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     FILL-IN-embalado AT ROW 2.35 COL 69.86 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     Btn_OK AT ROW 2.35 COL 110
     Btn_Cancel AT ROW 2.35 COL 131
     FILL-IN-crossdocking AT ROW 2.38 COL 47.43 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     FILL-IN-prioridad AT ROW 2.42 COL 12.14 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     FILL-IN-bulto AT ROW 4.08 COL 3.29 WIDGET-ID 4
     BUTTON-1 AT ROW 4.08 COL 73 WIDGET-ID 8
     BUTTON-imprimir AT ROW 4.08 COL 86 WIDGET-ID 10
     FILL-IN-bultos AT ROW 4.08 COL 122 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     TOGGLE-multiple AT ROW 4.27 COL 48 WIDGET-ID 42
     FILL-IN-tiempo AT ROW 2.31 COL 84 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN-factor AT ROW 5.81 COL 104.86 COLON-ALIGNED WIDGET-ID 52
     FILL-IN-marca AT ROW 5.73 COL 121.29 COLON-ALIGNED WIDGET-ID 54
     "Embalado :" VIEW-AS TEXT
          SIZE 11.43 BY .62 AT ROW 2.54 COL 59.86 WIDGET-ID 32
          FONT 17
     "CLIENTE" VIEW-AS TEXT
          SIZE 8.86 BY .62 AT ROW 1.35 COL 37.72 WIDGET-ID 20
          FONT 17
     "CHEQUEADOR" VIEW-AS TEXT
          SIZE 14 BY .62 AT ROW 1.38 COL 99 WIDGET-ID 24
          FONT 17
     "Prioridad :" VIEW-AS TEXT
          SIZE 11.57 BY .62 AT ROW 2.58 COL 2.43 WIDGET-ID 28
          FONT 17
     "CrossDocking :" VIEW-AS TEXT
          SIZE 15.43 BY .62 AT ROW 2.54 COL 33.57 WIDGET-ID 30
          FONT 17
     RECT-1 AT ROW 3.77 COL 2 WIDGET-ID 6
     SPACE(3.71) SKIP(21.61)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D NO-AUTO-VALIDATE  SCROLLABLE 
         TITLE "Chequeo de Ordenes" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-articulos-pickeados T "?" NO-UNDO INTEGRAL w-report
      TABLE: tt-bultos T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-12 FILL-IN-descripcion D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

ASSIGN 
       BROWSE-12:POPUP-MENU IN FRAME D-Dialog             = MENU POPUP-MENU-BROWSE-12:HANDLE.

/* SETTINGS FOR FILL-IN FILL-IN-articulo IN FRAME D-Dialog
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-bulto IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-chequeador IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-cliente IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-crossdocking IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-descripcion IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-embalado IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-factor IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-marca IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-orden IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-prioridad IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-tiempo IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-12
/* Query rebuild information for BROWSE BROWSE-12
     _TblList          = "Temp-Tables.tt-articulos-pickeados"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "Temp-Tables.tt-articulos-pickeados.Campo-I[1]|yes"
     _FldNameList[1]   > Temp-Tables.tt-articulos-pickeados.Campo-I[1]
"tt-articulos-pickeados.Campo-I[1]" "No" ">,>>9" "integer" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-articulos-pickeados.Campo-C[1]
"tt-articulos-pickeados.Campo-C[1]" "Codigo" "X(6)" "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-articulos-pickeados.Campo-C[2]
"tt-articulos-pickeados.Campo-C[2]" "Descripcion" "X(50)" "character" ? ? ? ? ? ? no ? no no "37.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-articulos-pickeados.Campo-C[3]
"tt-articulos-pickeados.Campo-C[3]" "Marca" "X(20)" "character" ? ? ? ? ? ? no ? no no "26.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-articulos-pickeados.Campo-C[4]
"tt-articulos-pickeados.Campo-C[4]" "Unidad" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-articulos-pickeados.Campo-F[1]
"tt-articulos-pickeados.Campo-F[1]" "Cantidad" ">>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-articulos-pickeados.Campo-F[2]
"tt-articulos-pickeados.Campo-F[2]" "Factor" ">>9.99" "decimal" ? ? ? ? ? ? no ? no no "8.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-articulos-pickeados.Campo-F[3]
"tt-articulos-pickeados.Campo-F[3]" "Calculado" ">>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-articulos-pickeados.Campo-C[5]
"tt-articulos-pickeados.Campo-C[5]" "Nro. Bulto" "X(25)" "character" ? ? ? ? ? ? no ? no no "25.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-12 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME D-Dialog:HANDLE
       ROW             = 3.12
       COLUMN          = 143
       HEIGHT          = 1.54
       WIDTH           = 6
       WIDGET-ID       = 18
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      CtrlFrame:MOVE-AFTER(FILL-IN-prioridad:HANDLE IN FRAME D-Dialog).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON END-ERROR OF FRAME D-Dialog /* Chequeo de Ordenes */
DO:
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON LEAVE OF FRAME D-Dialog /* Chequeo de Ordenes */
DO:
  MESSAGE KEYFUNCTION(LASTKEY).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Chequeo de Ordenes */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
    
  /* Anular cuando hizo click en la X para salir */
  /*APPLY "END-ERROR":U TO SELF.*/


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Salir */
DO:

    IF x-bultos > 1 OR x-items-x-bulto > 0  THEN DO:
        MESSAGE 'Seguro de PERDER los ' + STRING(x-bultos) + ' Bulto(s) trabajados ?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.
    END.
    /*
    /* Bloqueamos */
    FIND CURRENT b-faccpedi EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b-faccpedi THEN DO:
        ASSIGN b-faccpedi.flgsit = 'PT'.
    END.
    ELSE MESSAGE "Imposible Revertir a la Orden (faccpedi)".
    
    FIND CURRENT b-ChkTareas EXCLUSIVE-LOCK NO-ERROR.

    IF AVAILABLE b-ChkTareas THEN DO:
        ASSIGN b-ChkTareas.flgest = 'P'.
    END.
    ELSE MESSAGE "Imposible Revertir a la Orden (ChkTareas)".
    
    /* Desbloqueamos */
    RELEASE b-faccpedi.
    RELEASE b-ChkTareas.
    */
    pProcesado = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* CERRAR ORDEN */
DO:
  pProcesado = NO.
  btn_ok:AUTO-GO = NO.

  DEFINE VAR x-orden-con-obs AS LOG INIT NO.
  DEFINE VAR x-proceso AS LOG.
  DEFINE VAR x-msg AS CHAR.

  x-orden-con-obs = NO.

  /* Verificar si faltan articulos por PICKEAR */
  FIND FIRST v-facdpedi WHERE v-facdpedi.canpick = 0 NO-LOCK NO-ERROR.

  IF AVAILABLE v-facdpedi THEN DO:
      /*
      MESSAGE 'Existen articulos aun sin Checkear' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
      */
      MESSAGE 'Existen articulos aun sin Checkear, desea de todas manera CERRAR la Orden como OBSERVADA (Ya no hay marcha atras)?' VIEW-AS ALERT-BOX QUESTION
              BUTTONS YES-NO UPDATE rpta AS LOG.

      IF rpta = YES THEN DO:
        x-orden-con-obs = YES.
      END.
      ELSE DO:
          RETURN NO-APPLY.
      END.

  END.

  IF x-orden-con-obs = NO THEN DO:
      /* La orden tiene Items Observados */
      FIND FIRST v-facdpedi WHERE v-facdpedi.libre_c05 = "OBSERVADO" NO-LOCK NO-ERROR.
      IF AVAILABLE v-facdpedi THEN DO:
          MESSAGE 'Existen articulos OBSERVADOS, desea de todas manera CERRAR la Orden (Ya no hay marcha atras)?' VIEW-AS ALERT-BOX QUESTION
                  BUTTONS YES-NO UPDATE rpta1 AS LOG.
          IF rpta1 = YES THEN DO:
            x-orden-con-obs = YES.
          END.
          ELSE DO:
              RETURN NO-APPLY.
          END.
      END.
  END.

  x-msg = "".
  x-proceso = NO.
  /* Guardamos la ORDEN como OBSERVADA */
  IF x-orden-con-obs = YES THEN DO:
    /* Verificar primero si es que no viene desde una OBSERVADA */
    FIND FIRST vtaddocu WHERE vtaddocu.codcia = s-codcia AND 
                                vtaddocu.codped = 'X' + pCodDOc AND
                                vtaddocu.nroped = pNroDoc NO-LOCK NO-ERROR.
    IF AVAILABLE vtaddocu THEN DO:
        x-msg = "La Orden ya tiene una observacion, imposible observarla otra vez!!!".
    END.
    ELSE DO:
        x-proceso = NO.
        /* Calificar los Observados */
        RUN dist/d-chequeo-de-observados.r(OUTPUT x-proceso, INPUT-OUTPUT TABLE v-facdpedi).

        IF x-proceso = YES THEN DO:
            x-proceso = NO.
            x-msg = "".
            RUN grabar-observados(OUTPUT x-msg).
            IF x-msg = 'OK' THEN x-proceso = YES.
        END.
    END.
  END.
  ELSE DO:
      /* Grabar el Pedido como PROCESASDO */
      x-proceso = NO.
      x-msg = "".
      RUN grabar-chequeo(OUTPUT x-msg).
      IF x-msg = 'OK' THEN x-proceso = YES.
  END.
  IF x-proceso = NO THEN DO:
    IF x-msg <> "" THEN DO:
       MESSAGE x-msg.
    END.
  END.
  ELSE DO:
      /* Imprimir Rotulo Master */
      RUN dist/p-imprime-rotulo-master.r(INPUT x-bulto-rotulo,
                                         INPUT x-grafico-rotulo,
                                         INPUT pCoddoc,
                                          INPUT pNrodoc).
      pProcesado = YES.
      btn_ok:AUTO-GO = YES.
  END.


  /*pProcesado = YES.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 D-Dialog
ON CHOOSE OF BUTTON-1 IN FRAME D-Dialog /* Cerrar Bulto */
DO:
  ASSIGN toggle-multiple.

  IF toggle-multiple = NO THEN DO:
      IF x-items-x-bulto = 0 THEN DO:
          MESSAGE "Imposible CERRAR , por que el Bulto no contiene ningun Item".
          RETURN NO-APPLY.
      END.
      x-bultos = x-bultos + 1.
      x-items-x-bulto = 0.
      RUN show-bultos.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-del-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-del-item D-Dialog
ON CHOOSE OF BUTTON-del-item IN FRAME D-Dialog /* Eliminar Item */
DO:
  RUN elimina-item.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-imprimir D-Dialog
ON CHOOSE OF BUTTON-imprimir IN FRAME D-Dialog /* Imprimir */
DO:  
    
    DEFINE VAR y-bultos AS INT.

    IF x-bultos > 1 OR x-items-x-bulto > 0  THEN DO:

        y-bultos = x-bultos.
        IF x-items-x-bulto <= 0 THEN y-bultos = y-bultos - 1.   /* Ultimo bulto aun sin ningun Item */

        RUN dist/d-chequeo-de-ordenes-rotulos(INPUT pCodDOc, INPUT pNroDoc, 
                                              INPUT y-bultos, INPUT x-bulto-rotulo, 
                                              INPUT x-grafico-rotulo,
                                              INPUT TABLE tt-articulos-pickeados ).
    END.
    ELSE DO:
        MESSAGE "No existen bultos aun creados".
        RETURN NO-APPLY.
    END.
    
END.

/*
DEFINE INPUT PARAMETER pCodDoc  AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pNroDoc  AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pBultos AS INT NO-UNDO.
DEFINE INPUT PARAMETER pCodPer AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pNroBulto AS INT NO-UNDO.
DEFINE INPUT PARAMETER pGraficoRotulo AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-items-pickeados.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame D-Dialog OCX.Tick
PROCEDURE CtrlFrame.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-tiempo AS CHAR.
DEFINE VAR x-centrar AS LOG.

x-Tiempo = ''.

RUN lib/_time-passed ( DATETIME(STRING(x-fecha-inicio,"99/99/9999") + ' ' + x-hora-inicio),
                         DATETIME(STRING(TODAY,"99/99/9999") + ' ' + STRING(TIME,"HH:MM:SS")), OUTPUT x-Tiempo).


fill-in-tiempo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-tiempo.

x-centrar = centrar-texto(fill-in-tiempo:HANDLE).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-articulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-articulo D-Dialog
ON LEAVE OF FILL-IN-articulo IN FRAME D-Dialog /* Articulo */
DO:
  DEFINE VAR x-codigo AS CHAR.

  x-codigo = TRIM(fill-in-articulo:SCREEN-VALUE IN FRAME {&frame-name}).

  IF x-codigo <> "" THEN DO:
    RUN validar-articulo-ingresado.
    IF RETURN-VALUE = "ADM-ERROR" THEN DO:
        APPLY 'ENTRY':U TO FILL-IN-articulo IN FRAME {&frame-name}.
        /*RETURN NO-APPLY.*/
    END.
    ELSE DO:
        FILL-in-cantidad:SCREEN-VALUE IN FRAME {&frame-name} = "1.00" .
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-cantidad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-cantidad D-Dialog
ON LEAVE OF FILL-IN-cantidad IN FRAME D-Dialog /* Cantidad */
DO:
  DEFINE VAR x-filer AS CHAR.
  DEFINE VAR x-filer1 AS DEC.

  DEFINE VAR x-filer2 AS DEC.

  DEFINE VAR x-observado AS LOG INIT NO.
  DEFINE VAR x-codigo AS CHAR.

  ASSIGN toggle-multiple.

  x-codigo = TRIM(fill-in-articulo:SCREEN-VALUE IN FRAME {&frame-name}).

  x-filer = TRIM(FILL-IN-cantidad:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
  x-filer1 = DECIMAL(x-filer).

  IF x-codigo <> "" THEN DO:
      IF x-filer1 > 0 THEN DO:
        /* Validar */
        x-filer2 = 0.
        FOR EACH tt-articulos-pickeados WHERE tt-articulos-pickeados.campo-c[1] = trim(FILL-IN-articulo:SCREEN-VALUE IN FRAME {&FRAME-NAME}):
            x-filer2 = x-filer2 + tt-articulos-pickeados.campo-f[3].
        END.
        
        IF ( x-factor * x-filer1 ) > (x-cantidad-x-pickear - x-filer2) THEN DO:
            MESSAGE 'Cantidad esta por encima de los solicitado ?' VIEW-AS ALERT-BOX QUESTION.
            APPLY 'ENTRY':U TO fill-in-cantidad IN FRAME {&FRAME-NAME}.
            RETURN NO-APPLY.
        END.
        /* Cantidad Pedida es diferente a cant digitada x factor mas lo que existe digitado */
        IF x-cantidad-x-pickear <> ((x-filer1 * x-factor) + x-filer2) THEN DO:

            IF toggle-multiple = NO THEN DO:
                MESSAGE 'Cantidad no corresponde a la solicitada, desea OBSERVARLA ?' VIEW-AS ALERT-BOX QUESTION
                        BUTTONS YES-NO UPDATE rpta AS LOG.
                IF rpta = NO THEN DO:
                    APPLY 'ENTRY':U TO fill-in-cantidad IN FRAME {&FRAME-NAME}.
                    RETURN NO-APPLY.
                END.
            END.
            x-observado = YES.

        END.
        x-item = x-item + 1.
        IF (x-observado = NO) THEN x-items-x-bulto = x-items-x-bulto + 1.

        /* Actualizo el temporal */
        FIND FIRST v-facdpedi WHERE v-facdpedi.codcia = s-codcia AND 
                                        v-facdpedi.coddoc = pCodDoc AND
                                        v-facdpedi.nroped = pNroDoc AND
                                        v-facdpedi.codmat = trim(FILL-IN-articulo:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                                        EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE v-facdpedi THEN DO:
            ASSIGN v-facdpedi.canpick = x-filer2 +  (x-factor * x-filer1)
                    v-facdpedi.libre_c04 = "".
                    v-facdpedi.libre_c05 = IF(x-observado = YES) THEN "OBSERVADO" ELSE TRIM(fill-in-bulto:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
        END.

        /* Si ya no esta observado, actualizar el bulto */
        IF x-observado = NO THEN DO:
            FOR EACH tt-articulos-pickeados WHERE tt-articulos-pickeados.campo-c[1] = FILL-IN-articulo:SCREEN-VALUE IN FRAME {&FRAME-NAME}:
                ASSIGN tt-articulos-pickeados.campo-c[5] = TRIM(fill-in-bulto:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                        tt-articulos-pickeados.campo-c[6] = "".
                /***/
                IF tt-articulos-pickeados.campo-c[7] = "MULTIPLE" THEN DO:
                    x-bultos = x-bultos + 1.
                    x-items-x-bulto = 0.
                    RUN show-bultos.
                END.

            END.
        END.

        CREATE tt-articulos-pickeados.
            ASSIGN tt-articulos-pickeados.campo-i[1] = x-item
                    tt-articulos-pickeados.campo-c[1] = trim(FILL-IN-articulo:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                    tt-articulos-pickeados.campo-c[2] = almmmatg.desmat
                    tt-articulos-pickeados.campo-c[3] = almmmatg.desmar
                    tt-articulos-pickeados.campo-c[4] = v-facdpedi.undvta
                    tt-articulos-pickeados.campo-f[1] = x-filer1
                    tt-articulos-pickeados.campo-f[2] = x-factor
                    tt-articulos-pickeados.campo-f[3] = x-factor * x-filer1
                    tt-articulos-pickeados.campo-c[5] = IF(x-observado = YES) THEN "OBSERVADO" ELSE TRIM(fill-in-bulto:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                    tt-articulos-pickeados.campo-c[6] = IF(x-observado = YES) THEN "OBSERVADO" ELSE ""
                    tt-articulos-pickeados.campo-c[7] = IF(toggle-multiple = YES) THEN "MULTIPLE" ELSE ""
        .
        {&OPEN-QUERY-BROWSE-12}

        /* Ingreso Multiple */
        IF toggle-multiple = YES AND x-observado = NO THEN DO:
            x-bultos = x-bultos + 1.
            x-items-x-bulto = 0.
            RUN show-bultos.
        END.

        APPLY 'ENTRY':U TO fill-in-articulo IN FRAME {&FRAME-NAME}.
        RETURN NO-APPLY.
      END.

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME POPUP-MENU-BROWSE-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL POPUP-MENU-BROWSE-12 D-Dialog
ON MENU-DROP OF MENU POPUP-MENU-BROWSE-12
DO:
  IF AVAILABLE tt-articulos-pickeados THEN DO:
      /**/
  END.
  ELSE DO:
      MESSAGE "No existe informacion".      
  END.
       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-12
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

ON 'RETURN':U OF fill-in-articulo
DO:
    APPLY 'TAB'.
    RETURN NO-APPLY.
END.
ON 'RETURN':U OF fill-in-cantidad
DO:
    APPLY 'TAB'.
    RETURN NO-APPLY.
END.

 DEF VAR celda_br AS WIDGET-HANDLE EXTENT 100 NO-UNDO.
 DEF VAR cual_celda AS WIDGET-HANDLE NO-UNDO.
 DEF VAR n_cols_browse AS INT NO-UNDO.
 DEF VAR col_act AS INT NO-UNDO.
 DEF VAR t_col_br AS INT NO-UNDO INITIAL 11.
 DEF VAR vg_col_eti_b AS INT NO-UNDO INITIAL 28.

ON ROW-DISPLAY OF browse-12
DO:
  IF tt-articulos-pickeados.campo-c[5] <> "OBSERVADO" THEN RETURN.
  DO col_act = 1 TO n_cols_browse.
      
     cual_celda = celda_br[col_act].
     cual_celda:BGCOLOR = 12.
     cual_celda:FGCOLOR = 15.
     /*t_col_br.*/
  END.
END.

DO n_cols_browse = 1 TO browse-12:NUM-COLUMNS.
   celda_br[n_cols_browse] = browse-12:GET-BROWSE-COLUMN(n_cols_browse).
   cual_celda = celda_br[n_cols_browse].
     
   IF vg_col_eti_b <> 0 THEN cual_celda:LABEL-BGCOLOR = vg_col_eti_b.
   IF n_cols_browse = 15 THEN LEAVE.
END.

n_cols_browse = browse-12:NUM-COLUMNS.
IF n_cols_browse > 15 THEN n_cols_browse = 15.



{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-detalle-de-la-orden D-Dialog 
PROCEDURE cargar-detalle-de-la-orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-ingreso-multiple AS CHAR.

/* Cargamos la Orden inicial que no sean KITS*/
SESSION:SET-WAIT-STATE("GENERAL").
FOR EACH facdpedi WHERE facdpedi.codcia = s-codcia AND 
                            facdpedi.coddoc = pCodDOc AND 
                            facdpedi.nroped = pNroDoc NO-LOCK:

    FIND FIRST almckits OF facdpedi NO-LOCK NO-ERROR.
    FIND FIRST almmmatg OF facdpedi NO-LOCK NO-ERROR.

    IF NOT AVAILABLE almckits AND AVAILABLE almmmatg THEN DO:
        CREATE v-facdpedi.
                BUFFER-COPY facdpedi TO v-facdpedi.
            ASSIGN v-facdpedi.canpick = 0
                    v-facdpedi.libre_c04 = ""       /* La identificacion de la observacion (FALTANTE, MAL ESTADO, SELECCIONAR FALTANTE */
                    v-facdpedi.libre_c05 = ""       /* Si esta observado el Item (Valor:OBSERVADO)*/
                    /*v-facdpedi.undvta = almmmatg.undstk*/
                   .
    END.

END.
/* Cargamos la Orden inicial que sean KITS*/
FOR EACH facdpedi WHERE facdpedi.codcia = s-codcia AND 
                            facdpedi.coddoc = pCodDOc AND 
                            facdpedi.nroped = pNroDoc NO-LOCK:

    FIND FIRST almckits OF facdpedi NO-LOCK NO-ERROR.
    FIND FIRST almmmatg OF facdpedi NO-LOCK NO-ERROR.

    IF AVAILABLE almckits THEN DO:
        FOR EACH almdkits OF almckits NO-LOCK:
            FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                        almmmatg.codmat = almdkits.codmat2 NO-LOCK NO-ERROR.
            IF AVAILABLE almmmatg THEN DO:
                FIND FIRST v-facdpedi WHERE v-facdpedi.codmat = almdkits.codmat2 EXCLUSIVE-LOCK NO-ERROR.
                IF NOT AVAILABLE v-facdpedi THEN DO:
                    CREATE v-facdpedi.
                            BUFFER-COPY facdpedi TO v-facdpedi.
                        ASSIGN v-facdpedi.canpick = 0
                                v-facdpedi.codmat = almdkits.codmat2
                                v-facdpedi.libre_c04 = ""       /* La identificacion de la observacion (FALTANTE, MAL ESTADO, SELECCIONAR FALTANTE */
                                v-facdpedi.libre_c05 = ""       /* Si esta observado el Item (Valor:OBSERVADO)*/
                                /*v-facdpedi.undvta = almmmatg.undstk*/
                                v-facdpedi.canped = v-facdpedi.canped * almdkits.cantidad.
                END.
                ELSE ASSIGN v-facdpedi.canped = v-facdpedi.canped + (v-facdpedi.canped * almdkits.cantidad).
            END.
        END.
    END.

END.

/* Si tiene una OBSERVACION anterior */
FOR EACH v-facdpedi :
    FIND FIRST vtaddocu WHERE vtaddocu.codcia = s-codcia AND 
                                vtaddocu.codped = "X" + pCodDoc AND 
                                vtaddocu.nroped = pNroDoc AND
                                vtaddocu.codmat = v-facdpedi.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE vtaddocu THEN DO:
        ASSIGN v-facdpedi.canpick = vtaddocu.canpick
                v-facdpedi.libre_c04 = vtaddocu.libre_c04
                v-facdpedi.libre_c05 = vtaddocu.libre_c05.      
    END.
END.

/* Lo cargamos al temporal */
DEFINE VAR x-pos AS INT.
DEFINE VAR x-bulto-txt AS CHAR.
DEFINE VAR x-bulto-num AS INT.
  
x-bultos = 1.
FOR EACH v-facdpedi :
    FOR EACH vtaddocu WHERE vtaddocu.codcia = s-codcia AND 
                                vtaddocu.codped = "T" + pCodDoc AND 
                                vtaddocu.nroped = pNroDoc AND
                                vtaddocu.codmat = v-facdpedi.codmat NO-LOCK.
        FIND FIRST almmmatg OF v-facdpedi NO-LOCK NO-ERROR.
        x-item = x-item + 1.
        CREATE tt-articulos-pickeados.
            ASSIGN tt-articulos-pickeados.campo-i[1] = vtaddocu.nroitm
                    tt-articulos-pickeados.campo-c[1] = vtaddocu.codmat
                    tt-articulos-pickeados.campo-c[2] = almmmatg.desmat
                    tt-articulos-pickeados.campo-c[3] = almmmatg.desmar
                    tt-articulos-pickeados.campo-c[4] = v-facdpedi.undvta
                    tt-articulos-pickeados.campo-f[1] = vtaddocu.canpick
                    tt-articulos-pickeados.campo-f[2] = vtaddocu.factor
                    tt-articulos-pickeados.campo-f[3] = vtaddocu.canpick * vtaddocu.factor
                    tt-articulos-pickeados.campo-c[5] = vtaddocu.libre_c05
                    tt-articulos-pickeados.campo-c[7] = vtaddocu.libre_c01
        .
        /* Los bultos */
        IF vtaddocu.libre_c05 <> "" AND vtaddocu.libre_c05 <> "OBSERVADO" THEN DO:
            x-Pos = INDEX(vtaddocu.libre_c05,"-B").
            IF x-Pos > 0 THEN DO:
                x-bulto-txt = TRIM(SUBSTRING(vtaddocu.libre_c05,x-pos + 2)).
                x-bulto-num = INTEGER(x-bulto-txt).
                IF x-bulto-num > x-bultos THEN x-bultos = x-bulto-num .
            END.
        END.

    END.
    /*
    FIND FIRST vtaddocu WHERE vtaddocu.codcia = s-codcia AND 
                                vtaddocu.codped = "X" + pCodDoc AND 
                                vtaddocu.nroped = pNroDoc AND
                                vtaddocu.codmat = v-facdpedi.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE vtaddocu THEN DO:
        FIND FIRST almmmatg OF v-facdpedi NO-LOCK NO-ERROR.
        x-item = x-item + 1.
        CREATE tt-articulos-pickeados.
            ASSIGN tt-articulos-pickeados.campo-i[1] = x-item
                    tt-articulos-pickeados.campo-c[1] = v-facdpedi.codmat
                    tt-articulos-pickeados.campo-c[2] = almmmatg.desmat
                    tt-articulos-pickeados.campo-c[3] = almmmatg.desmar
                    tt-articulos-pickeados.campo-c[4] = v-facdpedi.undvta
                    tt-articulos-pickeados.campo-f[1] = v-facdpedi.canpick
                    tt-articulos-pickeados.campo-f[2] = v-facdpedi.factor
                    tt-articulos-pickeados.campo-f[3] = v-facdpedi.canpick * v-facdpedi.factor
                    tt-articulos-pickeados.campo-c[5] = v-facdpedi.libre_c05
            .
        /* Los bultos */
        IF v-facdpedi.libre_c05 <> "" AND v-facdpedi.libre_c05 <> "OBSERVADO" THEN DO:
            x-Pos = INDEX(v-facdpedi.libre_c05,"-B").
            IF x-Pos > 0 THEN DO:
                x-bulto-txt = TRIM(SUBSTRING(v-facdpedi.libre_c05,x-pos + 2)).
                x-bulto-num = INTEGER(x-bulto-txt).
                IF x-bulto-num > x-bultos THEN x-bultos = x-bulto-num .
            END.
        END.
    END.
    */
END.

/**/
x-item = 0.

FOR EACH vtaddocu WHERE vtaddocu.codcia = s-codcia AND 
                            vtaddocu.codped = "T" + pCodDoc AND 
                            vtaddocu.nroped = pNroDoc NO-LOCK BY vtaddocu.nroitm :
    x-ingreso-multiple = vtaddocu.libre_c01.
    x-item = vtaddocu.nroitm.
END.

IF x-ingreso-multiple = "MULTIPLE" THEN x-bultos = x-bultos + 1.
IF x-ingreso-multiple = "MULTIPLE" THEN toggle-multiple:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'yes'.

SESSION:SET-WAIT-STATE("").


END PROCEDURE.

/*

x-bultos

        CREATE tt-articulos-pickeados.
            ASSIGN tt-articulos-pickeados.campo-i[1] = x-item
                    tt-articulos-pickeados.campo-c[1] = trim(FILL-IN-articulo:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                    tt-articulos-pickeados.campo-c[2] = almmmatg.desmat
                    tt-articulos-pickeados.campo-c[3] = almmmatg.desmar
                    tt-articulos-pickeados.campo-c[4] = v-facdpedi.undvta
                    tt-articulos-pickeados.campo-f[1] = x-filer1
                    tt-articulos-pickeados.campo-f[2] = x-factor
                    tt-articulos-pickeados.campo-f[3] = x-factor * x-filer1
                    tt-articulos-pickeados.campo-c[5] = IF(x-observado = YES) THEN "OBSERVADO" ELSE fill-in-bulto:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                    tt-articulos-pickeados.campo-c[6] = IF(x-observado = YES) THEN "OBSERVADO" ELSE ""

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Control-LPN D-Dialog 
PROCEDURE Control-LPN :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ************************************************ */
/* RHC 18/11/2015 CONTROL DE LPN PARA SUPERMERCADOS */
/* ************************************************ */

DEFINE BUFFER pedido FOR faccpedi.
DEFINE BUFFER cotizacion FOR faccpedi.
DEFINE BUFFER x-faccpedi FOR faccpedi.

/* La Orden */
FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND
                            x-faccpedi.coddoc = pCodDoc AND
                            x-faccpedi.nroped = pNroDoc NO-LOCK NO-ERROR.

/* Ubicamos el registro de control de la Orden de Compra */
FIND PEDIDO WHERE PEDIDO.codcia = x-Faccpedi.codcia
                    AND PEDIDO.coddoc = x-Faccpedi.codref
                    AND PEDIDO.nroped = x-Faccpedi.nroref NO-LOCK NO-ERROR.
IF NOT AVAILABLE PEDIDO THEN RETURN.

/* La cotizacion */
FIND COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
                    AND COTIZACION.coddiv = PEDIDO.coddiv
                    AND COTIZACION.coddoc = PEDIDO.codref
                    AND COTIZACION.nroped = PEDIDO.nroref NO-LOCK NO-ERROR.
IF NOT AVAILABLE COTIZACION THEN RETURN.

/* Control para SuperMercados */
FIND SupControlOC  WHERE SupControlOC.CodCia = COTIZACION.codcia
  AND SupControlOC.CodDiv = COTIZACION.coddiv
  AND SupControlOC.CodCli = COTIZACION.codcli
  AND SupControlOC.OrdCmp = COTIZACION.OrdCmp NO-LOCK NO-ERROR.
IF NOT AVAILABLE SupControlOC THEN RETURN.

/* Comienza la Transacción */
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
  {lib/lock-genericov2.i ~
      &Tabla="SupControlOC" ~
      &Condicion="SupControlOC.CodCia = COTIZACION.codcia ~
      AND SupControlOC.CodDiv = COTIZACION.coddiv ~
      AND SupControlOC.CodCli = COTIZACION.codcli ~
      AND SupControlOC.OrdCmp = COTIZACION.OrdCmp" ~
      &Bloqueo="EXCLUSIVE-LOCK" 
      &Accion="RETRY" ~
      &Mensaje="YES" ~
      &TipoError="RETURN ERROR" ~
      }
  FOR EACH ControlOD WHERE ControlOD.CodCia = x-Faccpedi.codcia
      AND ControlOD.CodDiv = s-CodDiv
      AND ControlOD.CodDoc = x-Faccpedi.coddoc
      AND ControlOD.NroDoc = x-Faccpedi.nroped:
      ASSIGN
          ControlOD.LPN1 = "5000"
          ControlOD.LPN2 = FILL("0",10) + TRIM(COTIZACION.OrdCmp)
          ControlOD.LPN2 = SUBSTRING(ControlOD.LPN2, LENGTH(ControlOD.LPN2) - 10 + 1, 10)
/*                   ControlOD.LPN3 = STRING(SupControlOC.Correlativo + 1, '9999')                       */
/*                   ControlOD.LPN  = TRIM(ControlOD.LPN1) + TRIM(ControlOD.LPN2) + TRIM(ControlOD.LPN3) */
          ControlOD.LPN    = "POR DEFINIR"
          ControlOD.OrdCmp = COTIZACION.OrdCmp
          ControlOD.Sede   = COTIZACION.Ubigeo[1].
/*               ASSIGN                                                       */
/*                   SupControlOC.Correlativo = SupControlOC.Correlativo + 1. */
  END.
END.
IF AVAILABLE(SupControlOC) THEN RELEASE SupControlOC.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load D-Dialog  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "d-chequeo-de-ordenes.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
END.
ELSE MESSAGE "d-chequeo-de-ordenes.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE elimina-item D-Dialog 
PROCEDURE elimina-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


IF NOT AVAILABLE tt-articulos-pickeados THEN RETURN.

MESSAGE 'Desea eliminar el Item No. ' + STRING(tt-articulos-pickeados.campo-i[1]) SKIP
         tt-articulos-pickeados.campo-c[1] + " " + tt-articulos-pickeados.campo-c[2]   VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN NO-APPLY.

DEFINE VAR y-codmat AS CHAR.

y-codmat = tt-articulos-pickeados.campo-c[1].

DELETE tt-articulos-pickeados.

FOR EACH tt-articulos-pickeados WHERE tt-articulos-pickeados.campo-c[1] = y-codmat:
    ASSIGN tt-articulos-pickeados.campo-c[5] = "OBSERVADO".
END.

{&OPEN-QUERY-BROWSE-12}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-articulo FILL-IN-cantidad FILL-IN-descripcion FILL-IN-orden 
          FILL-IN-cliente FILL-IN-chequeador FILL-IN-embalado 
          FILL-IN-crossdocking FILL-IN-prioridad FILL-IN-bulto FILL-IN-bultos 
          TOGGLE-multiple FILL-IN-tiempo FILL-IN-factor FILL-IN-marca 
      WITH FRAME D-Dialog.
  ENABLE BUTTON-del-item FILL-IN-articulo FILL-IN-cantidad BROWSE-12 Btn_OK 
         Btn_Cancel BUTTON-1 BUTTON-imprimir FILL-IN-bultos TOGGLE-multiple 
         RECT-1 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-chequeo D-Dialog 
PROCEDURE grabar-chequeo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pMsg AS CHAR.

DEFINE VAR x-nroitem AS INT.
DEFINE VAR x-numbultos AS INT.

pMsg = "".

SESSION:SET-WAIT-STATE("GENERAL").

x-numbultos = 0.
GRABAR_INFO:
DO TRANSACTION ON ERROR UNDO, LEAVE:

    FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
                                faccpedi.coddoc = pCoddoc AND
                                faccpedi.nroped = pNroDoc AND
                                faccpedi.flgest <> 'A' NO-LOCK NO-ERROR.
    IF NOT AVAILABLE faccpedi THEN DO:
        pMsg = "La Orden no existe o esta anulada".
        UNDO GRABAR_INFO, LEAVE GRABAR_INFO.
    END.

    x-nroitem = 0.
    /*FOR EACH v-facdpedi ON ERROR UNDO, THROW:*/
    FOR EACH tt-articulos-pickeados ON ERROR UNDO, THROW:   
        x-nroitem = x-nroitem + 1.
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                    almmmatg.codmat = tt-articulos-pickeados.campo-c[1] NO-LOCK NO-ERROR.
        CREATE vtaddocu.
            ASSIGN  vtaddocu.codcia = s-codcia
                    vtaddocu.coddiv = s-coddiv
                    vtaddocu.codped = faccpedi.coddoc
                    vtaddocu.nroped = faccpedi.nroped
                    vtaddocu.fchped = faccpedi.fchped
                    vtaddocu.codcli = faccpedi.codcli
                    vtaddocu.NroItm = x-nroitem
                    vtaddocu.pesmat = almmmatg.pesmat
                    vtaddocu.codmat = tt-articulos-pickeados.campo-c[1]
                    vtaddocu.canped = tt-articulos-pickeados.campo-f[3]
                    vtaddocu.factor = tt-articulos-pickeados.campo-f[2]
                    vtaddocu.undvta = tt-articulos-pickeados.campo-c[4]
                    vtaddocu.libre_c01 = tt-articulos-pickeados.campo-c[5]       /* El bulto */
        .

        /* Control de Los bultos */
        FIND FIRST ControlOD WHERE ControlOD.codcia = s-codcia AND 
                                    ControlOD.coddiv = s-coddiv AND
                                    ControlOD.coddoc = faccpedi.coddoc AND 
                                    ControlOD.nrodoc = faccpedi.nroped AND 
                                    ControlOD.nroetq = tt-articulos-pickeados.campo-c[5] NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ControlOD THEN DO:
            CREATE ControlOD.
            ASSIGN ControlOD.codcia = s-codcia
                    ControlOD.coddiv = s-coddiv
                    ControlOD.coddoc = faccpedi.coddoc
                    ControlOD.nrodoc = faccpedi.nroped
                    ControlOD.nroetq = tt-articulos-pickeados.campo-c[5]
                    ControlOD.codcli = faccpedi.codcli
                    ControlOD.codalm = faccpedi.codalm
                    ControlOD.fchdoc = faccpedi.fchped
                    ControlOD.fchchq = TODAY
                    ControlOD.horchq = STRING(TIME,"HH:MM:SS")
                    ControlOD.nomcli = faccpedi.nomcli
                    ControlOD.usuario = faccpedi.usuario
            .
            x-numbultos = x-numbultos + 1.
        END.
        ELSE DO:
            FIND CURRENT ControlOD EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE ControlOD THEN DO:
                pMsg = "Imposible actualizar la tabla ControlOD".
                UNDO GRABAR_INFO, LEAVE GRABAR_INFO.
            END.
            ASSIGN  ControlOD.cantart = ControlOD.cantart + tt-articulos-pickeados.campo-f[3]
                    ControlOD.pesart = ControlOD.pesart + (tt-articulos-pickeados.campo-f[3] * almmmatg.pesmat)
            .
        END.
    END.

    DO:
        /* Header update block */
        FIND FIRST Ccbcbult WHERE Ccbcbult.codcia = s-codcia AND
                                    Ccbcbult.coddiv = s-coddiv AND
                                    Ccbcbult.coddoc = faccpedi.coddoc AND
                                    Ccbcbult.nrodoc = faccpedi.nroped NO-LOCK NO-ERROR.
        IF NOT AVAILABLE ccbcbult THEN DO:
            CREATE Ccbcbult.
                ASSIGN  ccbcbult.codcia = s-codcia 
                        ccbcbult.coddiv = s-coddiv
                        ccbcbult.coddoc = faccpedi.coddoc
                        ccbcbult.nrodoc = faccpedi.nroped
                        ccbcbult.bultos = x-numbultos
                        ccbcbult.codcli = faccpedi.codcli
                        ccbcbult.fchdoc = TODAY
                        ccbcbult.nomcli = faccpedi.nomcli
                        ccbcbult.CHR_01 = 'P'
                        ccbcbult.usuario = s-user-id
                        
            .
        END.

        FIND CURRENT faccpedi EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE faccpedi THEN DO:
            pMsg = "Imposible actualizar la Orden (faccpedi)".
            UNDO GRABAR_INFO, LEAVE GRABAR_INFO.
        END.
        ASSIGN faccpedi.flgsit = if(pEmbalado = 'SI') THEN 'PE' ELSE 'PC'
                faccpedi.usrchq = pCodPer
                faccpedi.fchchq = TODAY
                faccpedi.horchq = STRING(TIME,"HH:MM:SS")
                faccpedi.horsac = x-hora-inicio
                faccpedi.fecsac = x-fecha-inicio
        .
        IF faccpedi.coddoc = 'O/M' THEN faccpedi.flgest = 'C'.
        IF faccpedi.coddiv = '00065' AND 
            faccpedi.coddoc = 'O/M' AND
            faccpedi.codref = 'PPV' AND
            ENTRY(1,faccpedi.codalm) = "65S" THEN DO:

            RUN dist/p-transfxppv(ROWID(faccpedi),"65S", "65").
            IF RETURN-VALUE = "ADM-ERROR" THEN DO:
                pMsg = "Ocurrio un error en (dist/p-transfxppv) avise a sistemas ".
                UNDO GRABAR_INFO, LEAVE GRABAR_INFO.
            END.
        END.
        /* Control LPN Supermercados */
        RUN Control-LPN NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMsg = "No se pudo generar los LPNs".
            UNDO GRABAR_INFO, LEAVE GRABAR_INFO.
        END.
    END.

    /* Tarea Cerrada */    
    FIND FIRST chktareas WHERE chktareas.codcia = s-codcia AND
                                chktareas.coddiv = s-coddiv AND 
                                chktareas.coddoc = pCodDoc AND
                                chktareas.nroped = pNroDoc AND
                                chktareas.mesa = pMesa EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE chktareas THEN DO:
        pMsg = "No se pudo actualizar la tarea (ChkTareas)".
        UNDO GRABAR_INFO, LEAVE GRABAR_INFO.
    END.
    ASSIGN chktareas.flgest = if(pEmbalado = 'SI') THEN 'E' ELSE 'T'
            chktareas.fechafin = TODAY
            chktareas.horafin = STRING(TIME,"HH:MM:SS")
            chktareas.usuariofin = s-user-id
            .

    pMsg = "OK".
END. /* TRANSACTION block */

RELEASE faccpedi.
RELEASE chktareas.
RELEASE ccbcbult.
RELEASE ControlOD.

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-observados D-Dialog 
PROCEDURE grabar-observados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pProcesoOk AS CHAR NO-UNDO.

DEFINE BUFFER w-faccpedi FOR faccpedi.

pProcesoOK = "Inicio de grabacion".
GRABAR_REGISTROS:
DO TRANSACTION ON ERROR UNDO, LEAVE:
  pProcesoOK = "Eliminando los registros anteriores observados".
  /* Elimino los datos anteriores */
  FOR EACH vtaddocu WHERE vtaddocu.codcia = s-codcia AND 
                            vtaddocu.codped = "X" + pCodDoc AND
                            vtaddocu.nroped = pNroDoc ON ERROR UNDO, THROW:
      DELETE vtaddocu.
  END.
  /* Temporal del Detalle */
  FOR EACH vtaddocu WHERE vtaddocu.codcia = s-codcia AND 
                            vtaddocu.codped = "T" + pCodDoc AND
                            vtaddocu.nroped = pNroDoc ON ERROR UNDO, THROW:
      DELETE vtaddocu.
  END.


  pProcesoOK = "Adicionando los articulos observados (vtaddocu)".
  FOR EACH v-facdpedi NO-LOCK ON ERROR UNDO, THROW :
    /* Detalle update block */
      CREATE vtaddocu.
        ASSIGN vtaddocu.codcia = s-codcia
                vtaddocu.codped = "X" + pCodDoc
                vtaddocu.nroped = pNroDoc
                vtaddocu.nroitm = v-facdpedi.nroitm
                vtaddocu.codmat = v-facdpedi.codmat
                vtaddocu.canped = v-facdpedi.canped
                vtaddocu.canpick = v-facdpedi.canpick
                vtaddocu.libre_c04 = v-facdpedi.libre_c04
                vtaddocu.libre_c05 = v-facdpedi.libre_c05
        .                
  END.
  FOR EACH tt-articulos-pickeados NO-LOCK:
      CREATE vtaddocu.
        ASSIGN vtaddocu.codcia = s-codcia
                vtaddocu.codped = "T" + pCodDoc
                vtaddocu.nroped = pNroDoc
                vtaddocu.nroitm = tt-articulos-pickeados.campo-i[1]
                vtaddocu.codmat = tt-articulos-pickeados.campo-c[1]
                vtaddocu.canped = tt-articulos-pickeados.campo-f[1]
                vtaddocu.canpick = tt-articulos-pickeados.campo-f[1]
                vtaddocu.factor = tt-articulos-pickeados.campo-f[2]
                vtaddocu.libre_c04 = ""
                vtaddocu.libre_c05 = tt-articulos-pickeados.campo-c[5] /*v-facdpedi.libre_c05*/
                vtaddocu.libre_c01 = tt-articulos-pickeados.campo-c[7]
        .
  END.

  DO:
    /* Header update block */
    pProcesoOK = "Actualizar la orden como observada (PO)".    
    FIND FIRST w-faccpedi WHERE w-faccpedi.codcia = s-codcia AND 
                                    w-faccpedi.coddoc = pCodDoc AND
                                    w-faccpedi.nroped = pNroDoc EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE w-faccpedi THEN DO:
        pProcesoOK = "Error al actualizar la ORDEN como observado".
        UNDO GRABAR_REGISTROS, LEAVE GRABAR_REGISTROS.
    END.
    ASSIGN w-faccpedi.flgsit = 'PO'
            w-faccpedi.usrchq = pCodPer NO-ERROR.

    /* Tarea Observacion */
    pProcesoOK = "Ponemos la tarea como Observado".
    FIND FIRST chktareas WHERE chktareas.codcia = s-codcia AND
                                chktareas.coddiv = s-coddiv AND 
                                chktareas.coddoc = pCodDoc AND
                                chktareas.nroped = pNroDoc AND
                                chktareas.mesa = pMesa EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE chktareas THEN DO:
        pProcesoOK = "Error al actualizar la tarea como observado".
        UNDO GRABAR_REGISTROS, LEAVE GRABAR_REGISTROS.
    END.
    ASSIGN chktareas.flgest = 'O' 
        chktareas.fechafin = TODAY
        chktareas.horafin = STRING(TIME,"HH:MM:SS")
        chktareas.usuariofin = s-user-id NO-ERROR
    .
                                
  END.

  pProcesoOK = "OK".

END. /* TRANSACTION block */

RELEASE w-faccpedi.
RELEASE chktareas.
RELEASE vtaddocu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FILL-in-orden:SCREEN-VALUE = pCodDoc + "-" + pNroDoc.
      FILL-IN-chequeador:SCREEN-VALUE = pChequeador.
      fill-in-prioridad:SCREEN-VALUE = pPrioridad.
      fill-in-embalado:SCREEN-VALUE = pEmbalado.
      fill-in-cliente:SCREEN-VALUE = b-faccpedi.codcli + " " + b-faccpedi.nomcli.
      FILL-in-crossdocking:SCREEN-VALUE = IF(b-faccpedi.crossdocking = YES) THEN "SI" ELSE "NO".
  END.

  RUN cargar-detalle-de-la-orden.

  {&open-query-browse-12}

  RUN show-bultos.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
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
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-articulos-pickeados"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show-bultos D-Dialog 
PROCEDURE show-bultos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME} :
    fill-in-bulto:SCREEN-VALUE = pCodDoc + "-" + pNroDOc + "-B" + STRING(x-bultos,"999").
    FILL-in-bultos:SCREEN-VALUE = "BULTOS : " + STRING(x-bultos,"999").

    centrar-texto(fill-in-bulto:HANDLE).
    centrar-texto(fill-in-bultos:HANDLE).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validar-articulo-ingresado D-Dialog 
PROCEDURE validar-articulo-ingresado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-articulo AS CHAR.
DEFINE VAR x-codmat AS CHAR.
DEFINE VAR x-item AS INT.

x-articulo = TRIM(fill-in-articulo:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
x-codmat = "".
x-factor = 1.

x-cantidad-x-pickear = 0.

/* Es codigo EAN ? */
IF LENGTH(x-articulo) > 6 THEN DO:    
    /* EAN 13 */
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                almmmatg.codbrr = x-articulo NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN x-codmat = almmmatg.codmat.

    IF x-codmat = "" THEN DO:
        /* EANs 14 */
        LOOPEANS14:
        DO x-Item = 1 TO 6:
            FIND FIRST Almmmat1 WHERE Almmmat1.codcia = s-CodCia 
                AND Almmmat1.Barras[x-Item] = x-articulo 
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almmmat1 THEN DO:
                FIND Almmmatg OF Almmmat1 NO-LOCK NO-ERROR.
                IF NOT AVAILABLE Almmmatg THEN NEXT.
                x-CodMat = Almmmat1.CodMat.
                x-factor = Almmmat1.Equival[x-Item].
                x-item = 100.
                LEAVE LOOPEANS14.
            END.
        END.
    END.
END.
IF x-codmat = "" THEN x-codmat = x-articulo.

/* Datos del Articulo */
FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                            almmmatg.codmat = x-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE almmmatg THEN DO:
    MESSAGE "Articulo no existe".
    RETURN "ADM-ERROR".
END.
/**/
FILL-IN-descripcion:SCREEN-VALUE IN FRAME {&FRAME-NAME} = almmmatg.desmat.
FILL-IN-marca:SCREEN-VALUE IN FRAME {&FRAME-NAME} = almmmatg.desmar.
FILL-in-factor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(x-factor,">>,>>9.99").
FILL-IN-articulo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-codmat.

/* Verificar si esta en la ORDEN */
FIND FIRST v-facdpedi WHERE v-facdpedi.codcia = s-codcia AND
                            v-facdpedi.coddoc = pCodDoc AND 
                            v-facdpedi.nroped = pNroDoc AND 
                            v-facdpedi.codmat = x-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE v-facdpedi THEN DO:
    MESSAGE "Articulo " + x-codmat + " NO es parte de la Orden".
    RETURN "ADM-ERROR".
END.

x-cantidad-x-pickear = v-facdpedi.canped.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION centrar-texto D-Dialog 
FUNCTION centrar-texto RETURNS LOGICAL
  ( INPUT h AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE VARIABLE reps AS INTEGER     NO-UNDO.

reps = (h:WIDTH-PIXELS - FONT-TABLE:GET-TEXT-WIDTH-PIXELS(TRIM(h:SCREEN-VALUE),h:FONT) - 8 /* allow for 3-D borders */ ) / FONT-TABLE:GET-TEXT-WIDTH-PIXELS(' ',h:FONT).
reps = reps / 2.
h:SCREEN-VALUE = FILL(' ',reps) + TRIM(h:SCREEN-VALUE).

RETURN yes.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

