&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
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
{lib/def-prn.i}    
DEFINE STREAM report.
DEFINE STREAM report1.

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-CodCia AS INTEGER.
DEF SHARED VAR s-CodDiv AS CHARACTER.
DEF SHARED VAR s-CodDoc AS CHARACTER.
DEF SHARED VAR s-CodAlm AS CHARACTER.

DEF VAR ped        AS CHAR.
DEF VAR x-NOMCIA   AS CHAR.
DEF VAR F-DIRDIV   AS CHAR.
DEF VAR F-PUNTO    AS CHAR.
DEF VAR X-TITU     AS CHAR.
DEF VAR X-CodDoc   AS CHAR.
DEF VAR npage      AS INT  NO-UNDO.
DEF VAR c-items    AS INT  NO-UNDO.

DEFINE TEMP-TABLE Reporte
    FIELDS NroPed LIKE FacCPedi.NroPed
    FIELDS CodMat LIKE FacDPedi.CodMat
    FIELDS DesMat LIKE Almmmatg.DesMat
    FIELDS DesMar LIKE Almmmatg.DesMar
    FIELDS UndBas LIKE Almmmatg.UndBas
    FIELDS CanPed LIKE FacDPedi.CanPed
/*RD01*/ FIELDS CodAlm LIKE Almmmate.CodAlm
    FIELDS CodUbi LIKE Almmmate.CodUbi
    FIELDS CodFam LIKE Almmmatg.codfam
    FIELDS CodKit AS LOGICAL
    FIELDS Glosa  AS CHARACTER.

FOR EACH empresas WHERE Empresas.CodCia = S-CODCIA NO-LOCK: 
    X-NOMCIA = Empresas.NomCia.
END.

ASSIGN 
    X-CodDoc = 'PED'.

FOR EACH FacCfgGn WHERE FacCfgGn.CodCia = s-codcia:
    c-items = FacCfgGn.items_guias.
END.

DEFINE BUFFER b-reporte FOR reporte.
DEFINE BUFFER B-FACCPED FOR FacCPedi.
DEFINE VARIABLE clave AS CHARACTER FORMAT "x(20)" LABEL "Clave" NO-UNDO.

DEF VAR s-Registro-Actual AS ROWID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacCPedi

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 FacCPedi.NroPed FacCPedi.NomCli ~
FacCPedi.FchPed 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH FacCPedi ~
      WHERE FacCPedi.CodCia = s-CodCia ~
/* AND FacCPedi.CodDiv = s-CodDiv*/ ~
 AND FacCPedi.CodAlm begins cb-almac     ~
 AND FacCPedi.FlgEst = "P" ~
 AND FacCPedi.CodDoc = x-CodDoc ~
  NO-LOCK ~
    BY FacCPedi.FchPed DESCENDING ~
       BY FacCPedi.NroPed DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH FacCPedi ~
      WHERE FacCPedi.CodCia = s-CodCia ~
/* AND FacCPedi.CodDiv = s-CodDiv*/ ~
 AND FacCPedi.CodAlm begins cb-almac     ~
 AND FacCPedi.FlgEst = "P" ~
 AND FacCPedi.CodDoc = x-CodDoc ~
  NO-LOCK ~
    BY FacCPedi.FchPed DESCENDING ~
       BY FacCPedi.NroPed DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 FacCPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cb-tipo txt-nom txt-pedido cb-almac BROWSE-5 ~
b-print b-cancel rs-alm 
&Scoped-Define DISPLAYED-OBJECTS cb-tipo txt-nom txt-pedido cb-almac ~
txt-desalm rs-alm 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-cancel 
     LABEL "Cancelar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON b-print 
     LABEL "Imprimir" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE cb-almac AS CHARACTER FORMAT "X(256)":U INITIAL "35" 
     LABEL "Almacen" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "35" 
     DROP-DOWN-LIST
     SIZE 9.43 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo AS CHARACTER FORMAT "X(256)":U INITIAL "Pedido" 
     LABEL "Filtrar por" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Pedido","Cliente" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE txt-desalm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE txt-nom AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 47.43 BY .81 NO-UNDO.

DEFINE VARIABLE txt-pedido AS CHARACTER FORMAT "X(9)":U 
     LABEL "NroPedido" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81 NO-UNDO.

DEFINE VARIABLE rs-alm AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Almacen", 1,
"Distribucion", 2
     SIZE 24 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      FacCPedi.NroPed COLUMN-LABEL "N°Pedido" FORMAT "X(9)":U WIDTH 8
      FacCPedi.NomCli FORMAT "x(50)":U WIDTH 50
      FacCPedi.FchPed FORMAT "99/99/9999":U WIDTH 18.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 77.86 BY 9.42
         FONT 1
         TITLE "Nota de Pedido Pendientes" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-tipo AT ROW 1.27 COL 8.57 COLON-ALIGNED WIDGET-ID 12
     txt-nom AT ROW 1.27 COL 31.14 COLON-ALIGNED WIDGET-ID 16
     txt-pedido AT ROW 1.27 COL 33.72 COLON-ALIGNED WIDGET-ID 6
     cb-almac AT ROW 2.35 COL 8.57 COLON-ALIGNED WIDGET-ID 18
     txt-desalm AT ROW 2.35 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     BROWSE-5 AT ROW 3.58 COL 3.14 WIDGET-ID 200
     b-print AT ROW 13.35 COL 49.86 WIDGET-ID 2
     b-cancel AT ROW 13.35 COL 64.86 WIDGET-ID 4
     rs-alm AT ROW 13.46 COL 25.72 NO-LABEL WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.14 BY 13.96
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Impresion de Nota de Pedidos"
         HEIGHT             = 13.96
         WIDTH              = 83.14
         MAX-HEIGHT         = 13.96
         MAX-WIDTH          = 83.14
         VIRTUAL-HEIGHT     = 13.96
         VIRTUAL-WIDTH      = 83.14
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

{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-5 txt-desalm F-Main */
/* SETTINGS FOR FILL-IN txt-desalm IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "INTEGRAL.FacCPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.FacCPedi.FchPed|no,INTEGRAL.FacCPedi.NroPed|no"
     _Where[1]         = "FacCPedi.CodCia = s-CodCia
/* AND FacCPedi.CodDiv = s-CodDiv*/
 AND FacCPedi.CodAlm begins cb-almac    
 AND FacCPedi.FlgEst = ""P""
 AND FacCPedi.CodDoc = x-CodDoc
 "
     _FldNameList[1]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "N°Pedido" ? "character" ? ? ? ? ? ? no ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" ? ? "date" ? ? ? ? ? ? no ? no no "18.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Impresion de Nota de Pedidos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Impresion de Nota de Pedidos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-cancel W-Win
ON CHOOSE OF b-cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-print W-Win
ON CHOOSE OF b-print IN FRAME F-Main /* Imprimir */
DO:
  ASSIGN rs-alm.
  DEF VAR i   AS INT NO-UNDO.
  DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN DO:
        IF i = 1 
        THEN ped = TRIM(FacCPedi.NroPed).
    END.
  END.
  RUN imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
&Scoped-define SELF-NAME BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-5 W-Win
ON RIGHT-MOUSE-CLICK OF BROWSE-5 IN FRAME F-Main /* Nota de Pedido Pendientes */
DO:

  
  MESSAGE "Desea pasar a Chequeo el Pedido??"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      TITLE "" UPDATE lchoice AS LOGICAL.

  CASE lchoice:
      WHEN YES THEN DO:
          IF NOT AVAILABLE FacCPedi THEN DO:
              MESSAGE 'Pedido NO Disponible'  VIEW-AS ALERT-BOX ERROR.
              UNDO, RETURN 'ADM-ERROR'.
          END.                                                        
          IF FaccPedi.FchVen < TODAY THEN DO:
              MESSAGE 'Pedido NO disponible' VIEW-AS ALERT-BOX ERROR.
              UNDO, RETURN 'ADM-ERROR'.
          END.

          FIND B-FACCPED WHERE ROWID(B-FACCPED) = ROWID(FacCPedi) EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE B-FACCPED THEN DO:
              IF FacCPedi.FlgSit = "X" THEN DO:
                  MESSAGE 'Pedido ya ha sido chequeado'
                      VIEW-AS ALERT-BOX INFO BUTTONS OK.
              END.

              IF FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "" THEN DO:
                  clave = "".
                  UPDATE
                    SKIP(.5)
                    SPACE(2)
                    clave PASSWORD-FIELD
                    SPACE(2)
                    SKIP(.5)
                    WITH CENTERED VIEW-AS DIALOG-BOX THREE-D
                    SIDE-LABEL TITLE "Ingrese Clave".
                  IF clave = "chk" THEN DO:
                      ASSIGN
                          B-FACCPED.FlgSit = "X". /* X --> POR CHEQUEAR*/
                  END.
                  ELSE DO:
                      RELEASE B-FACCPED.
                      MESSAGE
                          "CLAVE DE CREACION INCORRECTA"
                          VIEW-AS ALERT-BOX ERROR.
                      RETURN "ADM-ERROR".
                  END.
                  RELEASE B-FACCPED.
              END.
          END.
      END.
      WHEN NO THEN DO:
          RETURN NO-APPLY.
      END.
  END CASE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-almac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-almac W-Win
ON VALUE-CHANGED OF cb-almac IN FRAME F-Main /* Almacen */
DO:
    ASSIGN cb-almac.
    FIND FIRST almacen WHERE almacen.codcia = s-codcia
        AND almacen.codalm = cb-almac:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
        NO-LOCK NO-ERROR.
    IF AVAIL almacen THEN DISPLAY almacen.descripcion @ txt-desalm
        WITH FRAME {&FRAME-NAME} .
    ELSE DISPLAY '' @ txt-desalm
        WITH FRAME {&FRAME-NAME} .
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo W-Win
ON VALUE-CHANGED OF cb-tipo IN FRAME F-Main /* Filtrar por */
DO:
  ASSIGN  cb-tipo.
  
  CASE cb-tipo:
      WHEN 'Pedido' THEN DO:
          txt-nom:HIDDEN IN FRAME {&FRAME-NAME} = YES.
          txt-pedido:VISIBLE IN FRAME {&FRAME-NAME} = YES.          
      END.
      WHEN 'Cliente' THEN DO:
          txt-pedido:HIDDEN IN FRAME {&FRAME-NAME} = YES.
          DISABLE txt-pedido.
          txt-nom:HIDDEN IN FRAME {&FRAME-NAME} = NO.          
      END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-nom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-nom W-Win
ON LEAVE OF txt-nom IN FRAME F-Main /* Cliente */
DO:
  ASSIGN 
      s-registro-actual = ?
      txt-nom.
  IF txt-nom:SCREEN-VALUE <> "" THEN DO:
      FOR EACH B-FacCPed WHERE B-FacCPed.CodCia = s-CodCia
          AND B-FacCPed.CodDiv = s-CodDiv
          AND B-FacCPed.CodAlm = s-CodAlm
          AND B-FacCPed.FlgEst = "P"
          AND B-FacCPed.CodDoc = x-CodDoc NO-LOCK
          BY B-FacCPed.FchPed DESCENDING
          BY B-FacCPed.NroPed DESCENDING :
          IF INDEX(B-FacCPed.NomCli,txt-nom:SCREEN-VALUE) > 0
              THEN DO:
              ASSIGN s-registro-actual = ROWID(B-FacCPed).
              REPOSITION {&BROWSE-NAME} TO ROWID s-registro-actual.
              LEAVE.
          END.      
      END.
      IF s-registro-actual = ? THEN MESSAGE "Fin de búsqueda" VIEW-AS ALERT-BOX WARNING.
  END.  
  RELEASE B-FacCPed.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-pedido W-Win
ON LEAVE OF txt-pedido IN FRAME F-Main /* NroPedido */
DO:
  ASSIGN 
      s-registro-actual = ?
      txt-pedido.
  IF txt-pedido:SCREEN-VALUE <> "" THEN DO:
      FOR EACH FacCPedi WHERE FacCPedi.CodCia = s-CodCia
          AND FacCPedi.CodDiv = s-CodDiv
          AND FacCPedi.CodAlm = s-CodAlm
          AND FacCPedi.FlgEst = "P"
          AND FacCPedi.CodDoc = x-CodDoc
          AND FacCPedi.NroPed = txt-pedido NO-LOCK
          BY FacCPedi.FchPed DESCENDING
          BY FacCPedi.NroPed DESCENDING :
          IF INDEX(FacCPedi.NroPed,txt-pedido:SCREEN-VALUE) > 0
              THEN DO:
              ASSIGN s-registro-actual = ROWID(faccpedi).
              REPOSITION {&BROWSE-NAME} TO ROWID s-registro-actual.
              LEAVE.
          END.      
      END.
      IF s-registro-actual = ? THEN MESSAGE "Fin de búsqueda" VIEW-AS ALERT-BOX WARNING.
  END.

  RELEASE Faccpedi.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ASSIGN cb-tipo = 'P'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR conta    AS INTEGER NO-UNDO INIT 0.
 DEFINE VAR conta1   AS INTEGER NO-UNDO INIT 0.
 DEFINE VAR lKit     AS LOGICAL     NO-UNDO.

 FOR EACH reporte.
     DELETE Reporte.
 END.

 conta1 = 0.
 npage = 0.
 conta = 0.

 FOR EACH FacDPedi OF FacCPedi NO-LOCK,
     FIRST Almmmatg WHERE Almmmatg.CodCia = FacCPedi.CodCia
           AND Almmmatg.CodMat = FacDPedi.CodMat NO-LOCK,
           FIRST Almmmate WHERE Almmmate.CodCia = FacCPedi.CodCia
                 AND Almmmate.CodAlm = FacCPedi.CodAlm
                 AND Almmmate.CodMat = FacDPedi.CodMat  
                 BREAK BY Almmmate.CodUbi 
                       BY FacDPedi.CodMat:
                 IF Almmmatg.CodFam = "010" OR Almmmatg.CodFam = "011" THEN conta1 = conta1 + 1.
                 ELSE conta = conta + 1.

                 CREATE Reporte.
                 ASSIGN 
                     Reporte.NroPed = FacCPedi.NroPed
                     Reporte.CodMat = FacDPedi.CodMat
                     Reporte.DesMat = Almmmatg.DesMat
                     Reporte.DesMar = Almmmatg.DesMar
                     Reporte.UndBas = Almmmatg.UndBas
                     Reporte.CanPed = FacDPedi.CanPed
/*RD01*/             Reporte.CodAlm = FacCPedi.CodAlm
                     Reporte.CodUbi = Almmmate.CodUbi
                     Reporte.CodFam = Almmmatg.CodFam
                     Reporte.Glosa  = "________________________".
 END.

 /*
 /*Buscando Kits*/
 FOR EACH Reporte:
     lKit = NO.
     FOR EACH AlmdKits WHERE AlmDKits.CodCia = s-CodCia
         AND AlmdKits.CodMat = Reporte.CodMat NO-LOCK,
         FIRST Almmmate WHERE Almmmate.CodCia = AlmDKits.CodCia
               AND Almmmate.CodAlm = Reporte.CodAlm
               AND Almmmate.CodMat = AlmDKits.CodMat2
               BREAK BY Almmmate.CodUbi 
               BY Reporte.CodMat:                               
               FIND FIRST b-Reporte WHERE b-Reporte.NroPed = Reporte.NroPed
                   AND b-Reporte.CodMat = AlmDkits.CodMat2
                   AND b-Reporte.CodKit  NO-ERROR.
               IF NOT AVAIL b-Reporte THEN DO:
                   FIND FIRST almmmatg WHERE almmmatg.codcia = almmmate.codcia
                       AND almmmatg.codmat = AlmDKits.CodMat2 NO-LOCK NO-ERROR.
                   CREATE b-Reporte.
                   ASSIGN 
                       b-Reporte.NroPed = Reporte.NroPed
                       b-Reporte.CodMat = AlmDKits.CodMat2.
                   IF AVAIL almmmatg THEN DO:
                       ASSIGN
                           b-Reporte.DesMat = Almmmatg.DesMat + ' (' + Reporte.CodMat + ')'                        
                           b-Reporte.DesMar = Almmmatg.DesMar
                           b-Reporte.UndBas = Almmmatg.UndBas                       
                           b-Reporte.CodFam = Almmmatg.CodFam.
                       IF Almmmatg.CodFam = "010" OR Almmmatg.CodFam = "011"  THEN conta1 = conta1 + 1.
                       ELSE conta = conta + 1.
                   END.
                   ASSIGN
       /*RD01*/        b-Reporte.CodAlm = FacCPedi.CodAlm
                       b-Reporte.CodUbi = Almmmate.CodUbi
                       b-Reporte.CanPed = Reporte.CanPed * AlmDKits.Cantidad
                       b-Reporte.Glosa  = STRING(Reporte.CanPed).
               END.
               ELSE DO:
                   ASSIGN 
                       b-Reporte.CanPed = Reporte.CanPed * AlmDKits.Cantidad + b-Reporte.CanPed
                       b-Reporte.DesMat = b-Reporte.DesMat + ' (' + Reporte.CodMat + ')'
                       b-Reporte.Glosa  = STRING(DEC(b-Reporte.Glosa) + Reporte.CanPed) .
               END.
               b-Reporte.Glosa = b-Reporte.Glosa + " Kit(s)".
               lKit = YES.
     END.
     IF lKit THEN
         FIND FIRST b-Reporte WHERE ROWID(b-Reporte) = ROWID(Reporte) EXCLUSIVE-LOCK NO-ERROR.
         IF AVAIL b-Reporte THEN DO: 
             IF b-Reporte.CodFam = "010" OR b-Reporte.CodFam = "011" THEN conta1 = conta1 - 1.
             ELSE conta = conta - 1.
             DELETE Reporte.
         END.
 END.
*/
 /*Contador de paginas*/
 DEF VAR iconta AS INT NO-UNDO.
 /*Terceros*/
 FOR EACH Reporte WHERE LOOKUP(Reporte.CodFam,'010,011,012') = 0 NO-LOCK:
     iconta = iconta + 1.
 END.

 IF INTEGER(iconta / c-items) >= DECIMAL(iconta / c-items ) THEN npage = INTEGER(iconta / c-items) + npage.
 ELSE npage = (INTEGER(iconta / c-items) + 1) + npage.

 /*Familia 010 y 011*/
 iconta = 0.
 FOR EACH Reporte WHERE LOOKUP(Reporte.CodFam,'010,011') > 0 NO-LOCK:
     iconta = iconta + 1.
 END.

 IF INTEGER(iconta / c-items) >= DECIMAL(iconta / c-items ) THEN npage = INTEGER(iconta / c-items) + npage.
 ELSE npage = (INTEGER(iconta / c-items) + 1) + npage.

 /*Familia 012*/
 iconta = 0.
 FOR EACH Reporte WHERE LOOKUP(Reporte.CodFam,'012') > 0 NO-LOCK:
     iconta = iconta + 1.
 END.

 IF INTEGER(iconta / c-items) >= DECIMAL(iconta / c-items ) THEN npage = INTEGER(iconta / c-items) + npage.
 ELSE npage = (INTEGER(iconta / c-items) + 1) + npage.

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
  DISPLAY cb-tipo txt-nom txt-pedido cb-almac txt-desalm rs-alm 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE cb-tipo txt-nom txt-pedido cb-almac BROWSE-5 b-print b-cancel rs-alm 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Envia-Chequeo W-Win 
PROCEDURE Envia-Chequeo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 IF NOT AVAILABLE FacCPedi THEN DO:
        MESSAGE 'Pedido NO Disponible'  VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.                                                        
 IF FaccPedi.FchVen < TODAY THEN DO:
       MESSAGE 'Pedido NO disponible' VIEW-AS ALERT-BOX ERROR.
       UNDO, RETURN 'ADM-ERROR'.
 END.

 FIND B-FACCPED WHERE ROWID(B-FACCPED) = ROWID(FacCPedi) EXCLUSIVE-LOCK NO-ERROR.
 IF AVAILABLE B-FACCPED THEN DO:
     IF FacCPedi.FlgEst = "P" AND FacCPedi.FlgSit = "" THEN DO:
        clave = "".
        UPDATE
            SKIP(.5)
            SPACE(2)
            clave PASSWORD-FIELD
            SPACE(2)
            SKIP(.5)
            WITH CENTERED VIEW-AS DIALOG-BOX THREE-D
            SIDE-LABEL TITLE "Ingrese Clave".
        IF clave = "pcl" THEN DO:
            ASSIGN
                B-FACCPED.FlgSit = "X". /* X --> POR CHEQUEAR*/
        END.
        ELSE DO:
            RELEASE B-FACCPED.
            MESSAGE
                "CLAVE DE CREACION INCORRECTA"
                VIEW-AS ALERT-BOX ERROR.
                RETURN "ADM-ERROR".
        END.
      END.
 END.
 RELEASE B-FACCPED.
 /*
 RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  */            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.  
DEFINE VARIABLE iCount  AS INTEGER NO-UNDO INIT 0.

DEFINE FRAME f-cab
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        Reporte.Glosa  FORMAT "x(25)" 
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + X-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 85 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"
        {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + string(npage) AT 104 FORMAT "X(15)" SKIP(1)
        {&PRN4} + {&PRN6A} + " Fecha : " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(30)" SKIP  
        {&PRN4} + {&PRN6A} + "Cliente: " + Faccpedi.nomcli + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(50)" 
        /*{&PRN4} + {&PRN6A} + "*** PARA ALMACEN ***" + {&PRN6B} + {&PRN3} AT 90 FORMAT "X(50)"*/  SKIP  
        {&PRN4} + {&PRN6B} + "Hora  : " AT 1 FORMAT "X(15)" STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        /*{&PRN4} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 1 FORMAT "X(30)" SKIP   */
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.


DEFINE FRAME f-cab2
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        Reporte.Glosa  FORMAT "x(25)" 
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + X-NOMCIA + "******** 010 y 011 ********" + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 85 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"
        {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + string(npage) AT 104 FORMAT "X(15)" SKIP(1)
        {&PRN4} + {&PRN6A} + " Fecha : " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(30)" SKIP  
        {&PRN4} + {&PRN6A} + "Cliente: " + Faccpedi.nomcli + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(50)" 
        /*{&PRN4} + {&PRN6A} + "*** PARA ALMACEN ***" + {&PRN6B} + {&PRN3} AT 90 FORMAT "X(50)"*/ SKIP  
        {&PRN4} + {&PRN6B} + "Hora  : " AT 1 FORMAT "X(15)" STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        /*{&PRN4} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 1 FORMAT "X(30)" SKIP   */
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

/*Listado Utiles Standford*/
DEFINE FRAME f-cab2a
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        Reporte.Glosa  FORMAT "x(25)" 
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + X-NOMCIA + "******** 012 ********" + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 85 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"
        {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + string(npage) AT 104 FORMAT "X(15)" SKIP(1)
        {&PRN4} + {&PRN6A} + " Fecha : " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(30)" SKIP  
        {&PRN4} + {&PRN6A} + "Cliente: " + Faccpedi.nomcli + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(50)" 
        /*{&PRN4} + {&PRN6A} + "*** PARA ALMACEN ***" + {&PRN6B} + {&PRN3} AT 90 FORMAT "X(50)"*/ SKIP  
        {&PRN4} + {&PRN6B} + "Hora  : " AT 1 FORMAT "X(15)" STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        /*{&PRN4} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 1 FORMAT "X(30)" SKIP   */
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.


 /*
 FOR EACH Reporte BREAK BY Reporte.NroPed:
 */
 FOR EACH Reporte 
     WHERE LOOKUP(Reporte.CodFam,'010,011,012') = 0
     /*
     WHERE Reporte.CodFam <> '010' 
     OR Reporte.CodFam <> '011'  
     OR Reporte.CodFam <> '012' /*Productos Propios*/
     */
     BREAK BY Reporte.CodUbi BY Reporte.CodMat:
     IF Reporte.CodFam = '010' THEN NEXT.
     IF Reporte.CodFam = '011' THEN NEXT.
     IF conta <= c-items THEN DO:         
         DISPLAY STREAM Report 
                Reporte.CodMat 
                Reporte.DesMat
                Reporte.DesMar
                Reporte.UndBas
                Reporte.CanPed
                Reporte.CodUbi
                Reporte.Glosa
                /*"________________________"*/
                WITH FRAME f-cab.
         conta = conta + 1.         
     END.
     IF conta > 13 THEN DO:
         PAGE STREAM Report.
         conta = 1.
     END.
     iCount = iCount + 1.
 END.

 conta = 1.
 PAGE STREAM Report.
 FOR EACH Reporte 
     WHERE LOOKUP(Reporte.CodFam,'010,011') > 0
     /*
     WHERE Reporte.CodFam = '010' 
     OR Reporte.CodFam = '011' 
     */  
     BREAK BY Reporte.DesMat:  
     IF conta <= c-items THEN DO:         
         DISPLAY STREAM Report 
                Reporte.CodMat 
                Reporte.DesMat
                Reporte.DesMar
                Reporte.UndBas
                Reporte.CanPed
                Reporte.CodUbi
                Reporte.Glosa
                /*"________________________"*/
                WITH FRAME f-cab2.
         conta = conta + 1.         
     END.
     IF conta > 13 THEN DO:
         PAGE STREAM Report.
         conta = 1.
     END.
     iCount = iCount + 1.
     /*
     IF LAST(Reporte.DesMat) THEN DO:
         PUT STREAM Report 'Total' AT 93  FORMAT "X(8)".
         PUT STREAM Report iCount  AT 104 FORMAT ">>>9".
     END.
     */
 END.

 /*Listado Utiles Standford*/
 conta = 1.
 PAGE STREAM Report.
 FOR EACH Reporte 
     WHERE Reporte.CodFam = '012'
     /*
     WHERE Reporte.CodFam = '010'
     OR Reporte.CodFam = '011' */ 
     BREAK BY Reporte.DesMat:  
     IF conta <= c-items THEN DO:         
         DISPLAY STREAM Report 
                Reporte.CodMat 
                Reporte.DesMat
                Reporte.DesMar
                Reporte.UndBas
                Reporte.CanPed
                Reporte.CodUbi
                Reporte.Glosa
                /*"________________________"*/
                WITH FRAME f-cab2a.
         conta = conta + 1.         
     END.
     IF conta > 13 THEN DO:
         PAGE STREAM Report.
         conta = 1.
     END.
     iCount = iCount + 1.
     IF LAST(Reporte.DesMat) THEN DO:
         PUT STREAM Report 'Total' AT 93  FORMAT "X(8)".
         PUT STREAM Report iCount  AT 104 FORMAT ">>>9".
     END.
 END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato2 W-Win 
PROCEDURE Formato2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1. 
DEFINE VARIABLE iCount  AS INTEGER NO-UNDO INIT 0.
npage = npage - 1.

DEFINE FRAME f-cab3
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        Reporte.Glosa
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + X-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)"
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 85 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"
    /*  
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 85 FORMAT "X(15)" (PAGE-NUMBER(REPORT) - npage)  FORMAT "ZZ9"
    */    
        {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + string(npage) AT 104 FORMAT "X(15)" SKIP(1)
        {&PRN4} + {&PRN6A} + " Fecha : " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(30)" SKIP  
        {&PRN4} + {&PRN6A} + "Cliente: " + Faccpedi.nomcli + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(50)" 
        /*{&PRN4} + {&PRN6A} + "*** PARA DISTRIBUCION ***" + {&PRN6B} + {&PRN3} AT 90 FORMAT "X(50)"*/ SKIP  
        {&PRN4} + {&PRN6B} + "Hora  : " AT 1 FORMAT "X(15)" STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        /*{&PRN4} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 1 FORMAT "X(30)" SKIP   */
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.


 FOR EACH Reporte 
     WHERE Reporte.CodFam <> '010' BREAK BY Reporte.CodUbi BY Reporte.CodMat:
     IF conta <= c-items THEN DO:
         iCount = iCount + 1.
         DISPLAY STREAM Report 
                Reporte.CodMat 
                Reporte.DesMat
                Reporte.DesMar
                Reporte.UndBas
                Reporte.CanPed
                Reporte.CodUbi
                Reporte.Glosa
                /*"________________________"*/
                WITH FRAME f-cab.
         conta = conta + 1.         
     END.
     IF conta > 13 THEN DO:
         PAGE STREAM Report.
         conta = 1.
     END.
 END.

 conta = 1.
 PAGE STREAM Report.
 FOR EACH Reporte 
     WHERE Reporte.CodFam = '010' BREAK BY Reporte.CodUbi BY Reporte.CodMat:     
     IF conta <= c-items THEN DO:
         iCount = iCount + 1.
         DISPLAY STREAM Report 
                Reporte.CodMat 
                Reporte.DesMat
                Reporte.DesMar
                Reporte.UndBas
                Reporte.CanPed
                Reporte.CodUbi
                Reporte.Glosa
                /*"________________________"*/
                WITH FRAME f-cab2.
         conta = conta + 1.         
     END.
     IF conta > 13 THEN DO:
         PAGE STREAM Report.
         conta = 1.
     END.
     IF LAST(Reporte.CodMat) THEN DO:
         PUT STREAM Report 'Total' AT 93  FORMAT "X(8)".
         PUT STREAM Report iCount  AT 104 FORMAT ">>>9".
     END.
 END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato3 W-Win 
PROCEDURE Formato3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1. 
DEFINE VARIABLE iCount  AS INTEGER NO-UNDO INIT 0.
DEFINE VARIABLE npage2  AS INTEGER NO-UNDO INIT 0.

/* FOR EACH Reporte /*WHERE Reporte.CodFam <> "010"                               */
/*     OR Reporte.CodFam <> "010"*/ NO-LOCK:                                      */
/*     /*                                                                         */
/*         IF Reporte.CodFam = '010' THEN NEXT.                                   */
/*         IF Reporte.CodFam = '011' THEN NEXT.                                   */
/*     */                                                                         */
/*     npage2 = npage2 + 1.                                                       */
/* END.                                                                           */
/*                                                                                */
/* IF (npage2 MOD c-items) <> 0 THEN npage2 = TRUNCATE((npage2 / c-items),0) + 1. */
/*  ELSE npage2 = TRUNCATE((npage2 / c-items),0).                                 */

DEFINE FRAME f-cab3
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        Reporte.Glosa  FORMAT "x(25)" 
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + X-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 85 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"
        {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + string(npage2) AT 104 FORMAT "X(15)" SKIP(1)
        {&PRN4} + {&PRN6A} + " Fecha : " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(30)" SKIP  
        {&PRN4} + {&PRN6A} + "Cliente: " + Faccpedi.nomcli + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(50)" 
        /*{&PRN4} + {&PRN6A} + "*** PARA ALMACEN ***" + {&PRN6B} + {&PRN3} AT 90 FORMAT "X(50)"*/  SKIP  
        {&PRN4} + {&PRN6B} + "Hora  : " AT 1 FORMAT "X(15)" STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        /*{&PRN4} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 1 FORMAT "X(30)" SKIP   */
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.


DEFINE FRAME f-cab4
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        Reporte.Glosa  FORMAT "x(25)" 
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + X-NOMCIA + "********010********" + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 85 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"
        {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + string(npage) AT 104 FORMAT "X(15)" SKIP(1)
        {&PRN4} + {&PRN6A} + " Fecha : " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(30)" SKIP  
        {&PRN4} + {&PRN6A} + "Cliente: " + Faccpedi.nomcli + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(50)" 
        /*{&PRN4} + {&PRN6A} + "*** PARA ALMACEN ***" + {&PRN6B} + {&PRN3} AT 90 FORMAT "X(50)"*/ SKIP  
        {&PRN4} + {&PRN6B} + "Hora  : " AT 1 FORMAT "X(15)" STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        /*{&PRN4} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 1 FORMAT "X(30)" SKIP   */
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

/*
 conta = 1.
 PAGE STREAM Report.  
 FOR EACH Reporte 
     BREAK BY Reporte.DesMat:
     IF conta <= c-items THEN DO:       
         conta = conta + 1.
         DISPLAY STREAM Report 
                Reporte.CodMat 
                Reporte.DesMat
                Reporte.DesMar
                Reporte.UndBas
                Reporte.CanPed
                Reporte.CodUbi
                Reporte.Glosa
                /*"________________________"*/
                WITH FRAME f-cab3.         
     END.
     IF conta > 13 THEN DO:
         PAGE STREAM Report.
         conta = 1.
     END.
 END.
*/

 FOR EACH Reporte /*
     WHERE Reporte.CodFam <> '010' 
     OR Reporte.CodFam <> '011'*/  BREAK BY Reporte.DesMat:
     /*
     IF Reporte.CodFam = '010' THEN NEXT.
     IF Reporte.CodFam = '011' THEN NEXT.
     */
     IF conta <= c-items THEN DO:
         iCount = iCount + 1.
         DISPLAY STREAM Report 
                Reporte.CodMat 
                Reporte.DesMat
                Reporte.DesMar
                Reporte.UndBas
                Reporte.CanPed
                Reporte.CodUbi
                Reporte.Glosa
                /*"________________________"*/
                WITH FRAME f-cab3.
         conta = conta + 1.         
     END.
     IF conta > 13 THEN DO:
         PAGE STREAM Report.
         conta = 1.
     END.
     IF LAST(Reporte.DesMat) THEN DO:
         PUT STREAM Report 'Total' AT 93  FORMAT "X(8)".
         PUT STREAM Report iCount  AT 104 FORMAT ">>>9".
     END.
 END.


 /*RD01 -Para distribucion no se imprimira articulos de la familia 10

 conta = 1.
 PAGE STREAM Report.
 FOR EACH Reporte 
     WHERE Reporte.CodFam = '010' BREAK BY Reporte.DesMat:     
     IF conta <= c-items THEN DO:
         iCount = iCount + 1.
         DISPLAY STREAM Report 
                Reporte.CodMat 
                Reporte.DesMat
                Reporte.DesMar
                Reporte.UndBas
                Reporte.CanPed
                Reporte.CodUbi
                Reporte.Glosa
                /*"________________________"*/
                WITH FRAME f-cab4.
         conta = conta + 1.         
     END.
     IF conta > 13 THEN DO:
         PAGE STREAM Report.
         conta = 1.
     END.
     IF LAST(Reporte.DesMat) THEN DO:
         PUT STREAM Report 'Total' AT 93  FORMAT "X(8)".
         PUT STREAM Report iCount  AT 104 FORMAT ">>>9".
     END.
 END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato_Distri W-Win 
PROCEDURE Formato_Distri :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.  
DEFINE VARIABLE iCount  AS INTEGER NO-UNDO INIT 0.

DEFINE FRAME f-cab
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        Reporte.Glosa  FORMAT "x(25)" 
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + X-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 85 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"
        {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + string(npage) AT 104 FORMAT "X(15)" SKIP(1)
        {&PRN4} + {&PRN6A} + " Fecha : " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(30)" SKIP  
        {&PRN4} + {&PRN6A} + "Cliente: " + Faccpedi.nomcli + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(50)" 
        /*{&PRN4} + {&PRN6A} + "*** PARA ALMACEN ***" + {&PRN6B} + {&PRN3} AT 90 FORMAT "X(50)"*/  SKIP  
        {&PRN4} + {&PRN6B} + "Hora  : " AT 1 FORMAT "X(15)" STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        /*{&PRN4} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 1 FORMAT "X(30)" SKIP   */
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.


DEFINE FRAME f-cab2
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        Reporte.Glosa  FORMAT "x(25)" 
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + X-NOMCIA + "******** 010 y 011 ********" + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 85 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"
        {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + string(npage) AT 104 FORMAT "X(15)" SKIP(1)
        {&PRN4} + {&PRN6A} + " Fecha : " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(30)" SKIP  
        {&PRN4} + {&PRN6A} + "Cliente: " + Faccpedi.nomcli + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(50)" 
        /*{&PRN4} + {&PRN6A} + "*** PARA ALMACEN ***" + {&PRN6B} + {&PRN3} AT 90 FORMAT "X(50)"*/ SKIP  
        {&PRN4} + {&PRN6B} + "Hora  : " AT 1 FORMAT "X(15)" STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        /*{&PRN4} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 1 FORMAT "X(30)" SKIP   */
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

/*Listado Utiles Standford*/
DEFINE FRAME f-cab2a
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        Reporte.Glosa  FORMAT "x(25)" 
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + X-NOMCIA + "******** 012 ********" + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 85 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"
        {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + string(npage) AT 104 FORMAT "X(15)" SKIP(1)
        {&PRN4} + {&PRN6A} + " Fecha : " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 90 FORMAT "X(30)" SKIP  
        {&PRN4} + {&PRN6A} + "Cliente: " + Faccpedi.nomcli + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(50)" 
        /*{&PRN4} + {&PRN6A} + "*** PARA ALMACEN ***" + {&PRN6B} + {&PRN3} AT 90 FORMAT "X(50)"*/ SKIP  
        {&PRN4} + {&PRN6B} + "Hora  : " AT 1 FORMAT "X(15)" STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        /*{&PRN4} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 1 FORMAT "X(30)" SKIP   */
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

 FOR EACH Reporte 
     WHERE LOOKUP(Reporte.CodFam,'010,011,012') = 0
     BREAK BY Reporte.DesMat:
     IF Reporte.CodFam = '010' THEN NEXT.
     IF Reporte.CodFam = '011' THEN NEXT.
     IF conta <= c-items THEN DO:         
         DISPLAY STREAM Report 
                Reporte.CodMat 
                Reporte.DesMat
                Reporte.DesMar
                Reporte.UndBas
                Reporte.CanPed
                Reporte.CodUbi
                Reporte.Glosa
                /*"________________________"*/
                WITH FRAME f-cab.
         conta = conta + 1.         
     END.
     IF conta > 13 THEN DO:
         PAGE STREAM Report.
         conta = 1.
     END.
     iCount = iCount + 1.
 END.

 conta = 1.
 PAGE STREAM Report.
 FOR EACH Reporte 
     WHERE LOOKUP(Reporte.CodFam,'010,011') > 0
     BREAK BY Reporte.DesMat:  
     IF conta <= c-items THEN DO:         
         DISPLAY STREAM Report 
                Reporte.CodMat 
                Reporte.DesMat
                Reporte.DesMar
                Reporte.UndBas
                Reporte.CanPed
                Reporte.CodUbi
                Reporte.Glosa
                /*"________________________"*/
                WITH FRAME f-cab2.
         conta = conta + 1.         
     END.
     IF conta > 13 THEN DO:
         PAGE STREAM Report.
         conta = 1.
     END.
     iCount = iCount + 1.
 END.

 /*Listado Utiles Standford*/
 conta = 1.
 PAGE STREAM Report.
 FOR EACH Reporte 
     WHERE Reporte.CodFam = '012'
     BREAK BY Reporte.DesMat:  
     IF conta <= c-items THEN DO:         
         DISPLAY STREAM Report 
                Reporte.CodMat 
                Reporte.DesMat
                Reporte.DesMar
                Reporte.UndBas
                Reporte.CanPed
                Reporte.CodUbi
                Reporte.Glosa
                /*"________________________"*/
                WITH FRAME f-cab2a.
         conta = conta + 1.         
     END.
     IF conta > 13 THEN DO:
         PAGE STREAM Report.
         conta = 1.
     END.
     iCount = iCount + 1.
     IF LAST(Reporte.DesMat) THEN DO:
         PUT STREAM Report 'Total' AT 93  FORMAT "X(8)".
         PUT STREAM Report iCount  AT 104 FORMAT ">>>9".
     END.
 END.

 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.
 
    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    RUN Carga-Temporal.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 30.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 30. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4} .
        IF rs-alm = 1 THEN RUN Formato.
        ELSE RUN Formato_Distri.
        PAGE STREAM REPORT.
        OUTPUT STREAM REPORT CLOSE.
    END.
    OUTPUT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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
  ASSIGN cb-tipo = 'Pedido'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  txt-nom:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  FIND FIRST almacen WHERE almacen.codcia = s-codcia
      AND almacen.codalm = cb-almac:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
      NO-LOCK NO-ERROR.
  IF AVAIL almacen THEN DISPLAY almacen.descripcion @ txt-desalm
      WITH FRAME {&FRAME-NAME} .
  ELSE DISPLAY '' @ txt-desalm
      WITH FRAME {&FRAME-NAME} .



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
  {src/adm/template/snd-list.i "FacCPedi"}

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

