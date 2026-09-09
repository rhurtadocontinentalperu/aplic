&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
          cissac           PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE CDEVO NO-UNDO LIKE INTEGRAL.Almcmov.
DEFINE TEMP-TABLE CDOCU NO-UNDO LIKE cissac.CcbCDocu.
DEFINE TEMP-TABLE CINGD NO-UNDO LIKE cissac.Almcmov.
DEFINE TEMP-TABLE CTRANSF NO-UNDO LIKE INTEGRAL.Almcmov.
DEFINE TEMP-TABLE DDEVO NO-UNDO LIKE INTEGRAL.Almdmov.
DEFINE TEMP-TABLE DDOCU NO-UNDO LIKE cissac.CcbDDocu.
DEFINE TEMP-TABLE DINGD NO-UNDO LIKE cissac.Almdmov.
DEFINE TEMP-TABLE DMOV NO-UNDO LIKE INTEGRAL.Almdmov.
DEFINE TEMP-TABLE DTRANSF NO-UNDO LIKE INTEGRAL.Almdmov.
DEFINE TEMP-TABLE MMATE NO-UNDO LIKE INTEGRAL.Almmmate.
DEFINE TEMP-TABLE RDOCU NO-UNDO LIKE INTEGRAL.CcbDDocu.



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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEFINE NEW SHARED VARIABLE  CB-MaxNivel  AS INTEGER.
DEFINE NEW SHARED VARIABLE  CB-Niveles   AS CHAR.
DEFINE VARIABLE P-LIST AS CHAR NO-UNDO.

RUN cbd/cb-m000.r(OUTPUT P-LIST).
IF P-LIST = "" THEN DO:
    MESSAGE "No existen periodos asignados para " skip
        "la empresa" s-codcia VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

DEF VAR x-CodMat AS CHAR NO-UNDO.

DISABLE TRIGGERS FOR LOAD OF integral.almacen.
DISABLE TRIGGERS FOR LOAD OF integral.almcmov.
DISABLE TRIGGERS FOR LOAD OF integral.almdmov.
DISABLE TRIGGERS FOR LOAD OF integral.almmmate.

DEF STREAM aTexto.

DEF TEMP-TABLE TCDOCU LIKE CDOCU.
DEF TEMP-TABLE TDDOCU LIKE DDOCU.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES RDOCU INTEGRAL.Almmmatg MMATE

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 RDOCU.codmat ~
INTEGRAL.Almmmatg.DesMat RDOCU.UndVta RDOCU.CanDes RDOCU.CanDev 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH RDOCU NO-LOCK, ~
      EACH INTEGRAL.Almmmatg OF RDOCU NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH RDOCU NO-LOCK, ~
      EACH INTEGRAL.Almmmatg OF RDOCU NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 RDOCU INTEGRAL.Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 RDOCU
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-1 INTEGRAL.Almmmatg


/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 MMATE.CodAlm MMATE.StkAct 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH MMATE ~
      WHERE MMATE.codmat = x-codmat ~
 AND MMATE.StkAct > 0 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH MMATE ~
      WHERE MMATE.codmat = x-codmat ~
 AND MMATE.StkAct > 0 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 MMATE
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 MMATE


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnDone COMBO-BOX-Periodo BUTTON-3 BUTTON-5 ~
COMBO-BOX-NroMes BROWSE-1 BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Periodo COMBO-BOX-NroMes ~
EDITOR-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 8 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     LABEL "CARGA TEMPORALES" 
     SIZE 19 BY 1.12.

DEFINE BUTTON BUTTON-4 
     LABEL "INICIAR PROCESO DE DEVOLUCION" 
     SIZE 29 BY 1.12.

DEFINE BUTTON BUTTON-5 
     LABEL "EXCEL DE VERIFICACION" 
     SIZE 21 BY 1.12.

DEFINE VARIABLE COMBO-BOX-NroMes AS CHARACTER FORMAT "X(256)":U INITIAL "1" 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEM-PAIRS "Enero","1",
                     "Febrero","2",
                     "Marzo","3",
                     "Abril","4",
                     "Mayo","5",
                     "Junio","6",
                     "Julio","7",
                     "Agosto","8",
                     "Setiembre","9",
                     "Octubre","10",
                     "Noviembre","11",
                     "Diciembre","12"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 115 BY 5
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      RDOCU, 
      INTEGRAL.Almmmatg SCROLLING.

DEFINE QUERY BROWSE-2 FOR 
      MMATE SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      RDOCU.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U WIDTH 8.43
      INTEGRAL.Almmmatg.DesMat FORMAT "X(60)":U
      RDOCU.UndVta FORMAT "XXXX":U WIDTH 5.86
      RDOCU.CanDes COLUMN-LABEL "Vendido" FORMAT ">,>>>,>>9.99":U
      RDOCU.CanDev COLUMN-LABEL "A Devolver" FORMAT ">,>>>,>>9.99":U
            WIDTH 12.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 84 BY 12.12
         FONT 4
         TITLE "RESUMEN DE VENTAS DE CISSAC A CONTINENTAL" FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      MMATE.CodAlm FORMAT "x(3)":U
      MMATE.StkAct COLUMN-LABEL "Stock" FORMAT "(ZZZ,ZZZ,ZZ9.99)":U
            WIDTH 18.57
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 30 BY 12.12
         FONT 4
         TITLE "DISPONIBLE POR ALMACEN" ROW-HEIGHT-CHARS .5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BtnDone AT ROW 1 COL 109 WIDGET-ID 10
     COMBO-BOX-Periodo AT ROW 1.38 COL 12 COLON-ALIGNED WIDGET-ID 2
     BUTTON-3 AT ROW 2.15 COL 33 WIDGET-ID 6
     BUTTON-5 AT ROW 2.15 COL 52 WIDGET-ID 14
     BUTTON-4 AT ROW 2.15 COL 73 WIDGET-ID 8
     COMBO-BOX-NroMes AT ROW 2.35 COL 12 COLON-ALIGNED WIDGET-ID 4
     BROWSE-1 AT ROW 3.69 COL 2 WIDGET-ID 400
     BROWSE-2 AT ROW 3.69 COL 87 WIDGET-ID 300
     EDITOR-1 AT ROW 16.19 COL 2 NO-LABEL WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 117.29 BY 20.54
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: CDEVO T "?" NO-UNDO INTEGRAL Almcmov
      TABLE: CDOCU T "?" NO-UNDO cissac CcbCDocu
      TABLE: CINGD T "?" NO-UNDO cissac Almcmov
      TABLE: CTRANSF T "?" NO-UNDO INTEGRAL Almcmov
      TABLE: DDEVO T "?" NO-UNDO INTEGRAL Almdmov
      TABLE: DDOCU T "?" NO-UNDO cissac CcbDDocu
      TABLE: DINGD T "?" NO-UNDO cissac Almdmov
      TABLE: DMOV T "?" NO-UNDO INTEGRAL Almdmov
      TABLE: DTRANSF T "?" NO-UNDO INTEGRAL Almdmov
      TABLE: MMATE T "?" NO-UNDO INTEGRAL Almmmate
      TABLE: RDOCU T "?" NO-UNDO INTEGRAL CcbDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "DEVOLUCIONES DE CONTINENTAL A CISSAC"
         HEIGHT             = 20.54
         WIDTH              = 117.29
         MAX-HEIGHT         = 22.46
         MAX-WIDTH          = 142.29
         VIRTUAL-HEIGHT     = 22.46
         VIRTUAL-WIDTH      = 142.29
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
/* BROWSE-TAB BROWSE-1 COMBO-BOX-NroMes F-Main */
/* BROWSE-TAB BROWSE-2 BROWSE-1 F-Main */
/* SETTINGS FOR BUTTON BUTTON-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR EDITOR-1 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "Temp-Tables.RDOCU,INTEGRAL.Almmmatg OF Temp-Tables.RDOCU"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.RDOCU.codmat
"RDOCU.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.RDOCU.UndVta
"RDOCU.UndVta" ? ? "character" ? ? ? ? ? ? no ? no no "5.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.RDOCU.CanDes
"RDOCU.CanDes" "Vendido" ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.RDOCU.CanDev
"RDOCU.CanDev" "A Devolver" ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "12.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.MMATE"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Temp-Tables.MMATE.codmat = x-codmat
 AND Temp-Tables.MMATE.StkAct > 0"
     _FldNameList[1]   = Temp-Tables.MMATE.CodAlm
     _FldNameList[2]   > Temp-Tables.MMATE.StkAct
"MMATE.StkAct" "Stock" ? "decimal" ? ? ? ? ? ? no ? no no "18.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* DEVOLUCIONES DE CONTINENTAL A CISSAC */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* DEVOLUCIONES DE CONTINENTAL A CISSAC */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 W-Win
ON VALUE-CHANGED OF BROWSE-1 IN FRAME F-Main /* RESUMEN DE VENTAS DE CISSAC A CONTINENTAL */
DO:
    x-CodMat = RDOCU.codmat.
    {&OPEN-QUERY-BROWSE-2}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* CARGA TEMPORALES */
DO:
   ASSIGN  COMBO-BOX-NroMes COMBO-BOX-Periodo.
   SESSION:SET-WAIT-STATE('GENERAL').
   RUN Carga-Temporales.
   SESSION:SET-WAIT-STATE('').
   ASSIGN
       COMBO-BOX-NroMes:SENSITIVE = NO
       COMBO-BOX-Periodo:SENSITIVE = NO
       BUTTON-3:SENSITIVE = NO
       BUTTON-4:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* INICIAR PROCESO DE DEVOLUCION */
DO:
    MESSAGE 'Confirme el inicio del proceso'
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
    ASSIGN
        COMBO-BOX-NroMes COMBO-BOX-Periodo.
    RUN Devolucion-Conti-Cissac.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 W-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* EXCEL DE VERIFICACION */
DO:
  RUN Excel-Verificacion.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE almacpr1 W-Win 
PROCEDURE almacpr1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER R-DMov AS ROWID.
DEFINE INPUT PARAMETER C-UD   AS CHAR.
DEFINE VARIABLE I-CODMAT   AS CHAR NO-UNDO.
DEFINE VARIABLE C-CODALM   AS CHAR NO-UNDO.
DEFINE VARIABLE F-CANDES   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-IMPCTO   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-STKSUB   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-STKACT   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-VCTOMN   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-VCTOME   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-TCTOMN   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-TCTOME   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PCTOMN   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PCTOME   AS DECIMAL NO-UNDO.
DEFINE VARIABLE L-INGRESO  AS LOGICAL NO-UNDO.

/* Ubicamos el detalle a Actualizar */
FIND integral.AlmDMov WHERE ROWID(integral.AlmDMov) = R-DMov NO-LOCK NO-ERROR.
IF NOT AVAILABLE integral.AlmDMov THEN RETURN.
/* Inicio de Transaccion */
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
    /* ************** RHC 30.03.04 ******************* */
    FIND integral.AlmDMov WHERE ROWID(integral.AlmDMov) = r-dmov NO-LOCK NO-ERROR.
    ASSIGN I-CODMAT = integral.AlmDMov.CodMaT
           C-CODALM = integral.AlmDMov.CodAlm
           F-CANDES = integral.AlmDMov.CanDes
           F-IMPCTO = integral.AlmDMov.ImpCto.
    IF integral.AlmDMov.Factor > 0 THEN ASSIGN F-CANDES = integral.AlmDMov.CanDes * integral.AlmDMov.Factor.
    /* Buscamos el stock inicial */
    FIND PREV integral.AlmDMov USE-INDEX ALMD02 WHERE integral.AlmDMov.codcia = s-codcia
        AND integral.AlmDMov.codmat = i-codmat
        AND integral.AlmDMov.codalm = c-codalm
        NO-LOCK NO-ERROR.
    IF AVAILABLE integral.AlmDMov
    THEN f-StkSub = integral.AlmDMov.stksub.
    ELSE f-StkSub = 0.
    /* actualizamos el kardex por almacen */
    FIND integral.AlmDMov WHERE ROWID(integral.AlmDMov) = r-dmov EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    IF C-UD = 'D'       /* Eliminar */
    THEN integral.AlmDMov.candes = 0.        /* OJO */
    REPEAT WHILE AVAILABLE integral.AlmDMov:
        L-INGRESO = LOOKUP(integral.AlmDMov.TipMov,"I,U") <> 0.
        F-CANDES = integral.AlmDMov.CanDes.
        IF integral.AlmDMov.Factor > 0 THEN F-CANDES = integral.AlmDMov.CanDes * integral.AlmDMov.Factor.
        IF L-INGRESO 
        THEN F-STKSUB = F-STKSUB + F-CANDES.
        ELSE F-STKSUB = F-STKSUB - F-CANDES.
        integral.AlmDMov.StkSub = F-STKSUB.      /* OJO */
        FIND NEXT integral.AlmDMov USE-INDEX ALMD02 WHERE integral.AlmDMov.codcia = s-codcia
            AND integral.AlmDMov.codmat = i-codmat
            AND integral.AlmDMov.codalm = c-codalm
            NO-LOCK NO-ERROR.
        IF AVAILABLE integral.AlmDMov
        THEN DO:
            FIND CURRENT integral.AlmDMov EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO, RETURN "ADM-ERROR".
        END.
    END.
END.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE almdcstk W-Win 
PROCEDURE almdcstk :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER R-DMov AS ROWID.

DEFINE VARIABLE I-CODMAT AS CHAR NO-UNDO.
DEFINE VARIABLE C-CODALM AS CHAR NO-UNDO.
DEFINE VARIABLE F-CANDES AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUNI AS DECIMAL NO-UNDO.
/* DEFINE SHARED VAR S-CODCIA AS INTEGER. */

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Ubicamos el detalle a Actualizar */
    FIND integral.Almdmov WHERE ROWID(integral.Almdmov) = R-DMov NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.Almdmov THEN RETURN.
    ASSIGN 
      I-CODMAT = integral.Almdmov.CodMaT
      C-CODALM = integral.Almdmov.CodAlm
      F-CANDES = integral.Almdmov.CanDes
      F-PREUNI = integral.Almdmov.PreUni.
    IF integral.Almdmov.Factor > 0 
    THEN ASSIGN 
              F-CANDES = integral.Almdmov.CanDes * integral.Almdmov.Factor
              F-PREUNI = integral.Almdmov.PreUni / integral.Almdmov.Factor.
    /* Des-Actualizamos a los Materiales por Almacen */
    FIND integral.Almmmate WHERE integral.Almmmate.CodCia = S-CODCIA AND
          integral.Almmmate.CodAlm = C-CODALM AND 
          integral.Almmmate.CodMat = I-CODMAT EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.Almmmate THEN DO:
        MESSAGE 'Codigo' i-codmat 'NO asignado en el almacen' c-codalm
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    integral.Almmmate.StkAct = integral.Almmmate.StkAct - F-CANDES.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporales W-Win 
PROCEDURE Carga-Temporales PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* 1ro Ventas de Cissac a Continental */
EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} +
    "Resumen de Ventas de CISSAC a CONTINENTAL...".
RUN Ventas-Cissac-a-Conti.
EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " OK" + CHR(10).

/* 2do Saldos de los Almacene Comerciales */
EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} +
    "Saldos de Almacenes Comerciales de CONTINENTAL...".
RUN Saldos-Almacenes-Comerciales.
EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " OK" + CHR(10).

/* 3ro Transferencias de almacenes comerciales al almacén 21 */
EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} +
    "Resumen de Transferencias de CONTINENTAL a CISSAC...".
RUN Preparar-Transferencias.
EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " OK" + CHR(10).

/* CONSISTENCIAS */
EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} +
    "Consistenciando información...".
RUN Consistencias.
EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " OK" + CHR(10).
/* ************* */

{&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
APPLY 'VALUE-CHANGED':U TO {&BROWSE-NAME} IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Consistencias W-Win 
PROCEDURE Consistencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*OUTPUT STREAM aTexto TO c:\tmp\errores.txt.*/
FOR EACH RDOCU:
    FIND integral.Almmmatg WHERE integral.Almmmatg.CodCia = S-CODCIA 
        AND integral.Almmmatg.CodMat = RDOCU.CodMat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.Almmmatg THEN DO:
        MESSAGE "Articulo" RDOCU.codmat "NO registrado en el catálogo" 
            VIEW-AS ALERT-BOX WARNING.
        DELETE RDOCU.
        NEXT.
    END.
    IF integral.Almmmatg.Tpoart <> "A" THEN DO:
        MESSAGE "Articulo" RDOCU.codmat "Desactivado" 
            VIEW-AS ALERT-BOX WARNING.
        DELETE RDOCU.
        NEXT.
    END.
    FIND integral.Almtconv WHERE integral.Almtconv.CodUnid = integral.Almmmatg.UndBas
        AND  integral.Almtconv.Codalter = integral.Almmmatg.UndCmp
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.Almtconv THEN DO:
        MESSAGE "Tabla de equivalencias NO definida para:" SKIP
            "Artículo:" integral.Almmmatg.codmat SKIP
            "Unidad base:" integral.Almmmatg.undbas SKIP
            "Unidad de compra:" integral.Almmmatg.undcmp
            VIEW-AS ALERT-BOX WARNING.
        DELETE RDOCU.
        NEXT.
    END.
    /***** Se Usara con lista de Precios Proveedor Original *****/
    FIND integral.lg-dmatpr WHERE integral.lg-dmatpr.codcia = s-codcia
        AND integral.lg-dmatpr.codmat = RDOCU.codmat
        AND CAN-FIND(FIRST integral.lg-cmatpr WHERE integral.lg-cmatpr.codcia = s-codcia
                     AND integral.lg-cmatpr.nrolis = integral.lg-dmatpr.nrolis
                     AND integral.lg-cmatpr.codpro = "51135890"     /* Standford */
                     AND integral.lg-cmatpr.flgest = 'A' NO-LOCK)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.lg-dmatpr THEN DO:
/*         DISPLAY STREAM aTexto "Articulo" RDOCU.codmat "NO está asignado al proveedor" */
/*             WITH STREAM-IO NO-BOX WIDTH 200.                                          */
/*         PAUSE 0.                                                                      */
        MESSAGE "Articulo" RDOCU.codmat "NO está asignado al proveedor"
            VIEW-AS ALERT-BOX WARNING.
        DELETE RDOCU.
        NEXT.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Devolucion-Conti-Cissac W-Win 
PROCEDURE Devolucion-Conti-Cissac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* VERIFICACION DE PROCESO */
DEF VAR x-Codigo AS CHAR NO-UNDO.

/* DEBE ESTAR PROCESADO EL MES ANTERIOR */
x-Codigo = STRING(COMBO-BOX-Periodo * 100 + INTEGER(COMBO-BOX-NroMes) - 1, '999999').
IF INTEGER(COMBO-BOX-NroMes) - 1 <= 0 THEN x-Codigo = STRING((COMBO-BOX-Periodo - 1) * 100 + 12, '999999').
FIND INTEGRAL.lg-tabla WHERE INTEGRAL.lg-tabla.CodCia = s-codcia
    AND INTEGRAL.lg-tabla.Tabla = "DEVCOCI"
    AND INTEGRAL.lg-tabla.Codigo = x-Codigo
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE INTEGRAL.lg-tabla THEN DO:
    FIND FIRST INTEGRAL.lg-tabla WHERE INTEGRAL.lg-tabla.CodCia = s-codcia
        AND INTEGRAL.lg-tabla.Tabla = "DEVCOCI"
        NO-LOCK NO-ERROR.
    IF AVAILABLE integral.lg-tabla THEN DO:
        MESSAGE 'FALTA procesar el periodo anterior' VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
END.

/* AHORA SÍ */
x-Codigo = STRING(COMBO-BOX-Periodo * 100 + INTEGER(COMBO-BOX-NroMes), '999999').
FIND INTEGRAL.lg-tabla WHERE INTEGRAL.lg-tabla.CodCia = s-codcia
    AND INTEGRAL.lg-tabla.Tabla = "DEVCOCI"
    AND INTEGRAL.lg-tabla.Codigo = x-Codigo
    NO-LOCK NO-ERROR.
IF AVAILABLE INTEGRAL.lg-tabla THEN DO:
    MESSAGE 'YA fue procesado este periodo y mes' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* 1ro Generamos los movimientos de salida de Continental */
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} +
        "Generando Transferencias en CONTINENTAL y Devoluciones a CISSAC...".
    RUN lgc/pdevo-conti-cissac-salida-conti ( INTEGER(COMBO-BOX-NroMes),
                                              COMBO-BOX-Periodo,
                                              INPUT TABLE DMOV,
                                              INPUT TABLE RDOCU,
                                              OUTPUT TABLE CDEVO,
                                              OUTPUT TABLE DDEVO,
                                              INPUT-OUTPUT TABLE CDOCU,
                                              INPUT-OUTPUT TABLE DDOCU,
                                              OUTPUT TABLE CTRANSF,
                                              OUTPUT TABLE DTRANSF
                                              ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
            "ERROR" + CHR(10) +
            "NO se pudo generar los movimientos de transferencias y devoluciones en Continental".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "OK" + CHR(10).

    /* 2do Generamos los movimientos de ingresos en Cissac */
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} +
        "Generando Ingresos en el almacén 21 de CISSAC...".
    RUN lgc/pdevo-conti-cissac-ingreso-cissac ( INTEGER(COMBO-BOX-NroMes),
                                                COMBO-BOX-Periodo,
                                                INPUT TABLE CDEVO,
                                                INPUT TABLE DDEVO,
                                                INPUT TABLE CDOCU,
                                                INPUT TABLE DDOCU).

    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
            "ERROR" + CHR(10) +
            "NO se pudo generar los movimientos de ingresos en Cissac".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "OK" + CHR(10).

    /* 3ro Generamos la venta de Cissac a Continental */
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} +
        "Generando Ventas de CISSAC a CONTINENTAL...".
    RUN lgc/pdevo-conti-cissac-venta-cissac-conti ( INTEGER(COMBO-BOX-NroMes),
                                                COMBO-BOX-Periodo,
                                                INPUT TABLE RDOCU).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
            "ERROR" + CHR(10) +
            'NO se pudo generar los movimientos de devoluciones en Cissac'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "OK" + CHR(10).

    /* 4to Generamos los movimientos de ingreso a Continental */
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} +
        "Generando Salidas-Ingresos por Transferencias CONTINENTAL...".
    RUN lgc/pdevo-conti-cissac-transfer-conti ( INTEGER(COMBO-BOX-NroMes),
                                                COMBO-BOX-Periodo,
                                                INPUT TABLE CTRANSF,
                                                INPUT TABLE DTRANSF).

    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
            "ERROR" + CHR(10) +
            'NO se pudo generar los movimientos de salidas-ingreso por transferencia en Continental'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = EDITOR-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "OK" + CHR(10).

    CREATE INTEGRAL.lg-tabla.
    ASSIGN
        INTEGRAL.lg-tabla.CodCia = s-codcia
        INTEGRAL.lg-tabla.Tabla = "DEVCOCI"
        INTEGRAL.lg-tabla.Codigo = x-Codigo.
END.
EMPTY TEMP-TABLE RDOCU.
EMPTY TEMP-TABLE MMATE.
{&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
ASSIGN
    COMBO-BOX-NroMes:SENSITIVE = YES
    COMBO-BOX-Periodo:SENSITIVE = YES
    BUTTON-3:SENSITIVE = YES
    BUTTON-4:SENSITIVE = NO.
MESSAGE 'Proceso terminado con éxito' VIEW-AS ALERT-BOX INFORMATION.

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
  DISPLAY COMBO-BOX-Periodo COMBO-BOX-NroMes EDITOR-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BtnDone COMBO-BOX-Periodo BUTTON-3 BUTTON-5 COMBO-BOX-NroMes BROWSE-1 
         BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-Verificacion W-Win 
PROCEDURE Excel-Verificacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-CanDev AS DEC NO-UNDO.

/* PRIMERO REPARTIMOS LAS CANTIDADES A DEVOLVER POR CADA FACTURA 
    DESDE LA MAS RECIENTE HASTA LA MAS ANTIGUA 
*/   
EMPTY TEMP-TABLE TCDOCU.
EMPTY TEMP-TABLE TDDOCU.
FOR EACH CDOCU NO-LOCK:
    CREATE TCDOCU.
    BUFFER-COPY CDOCU TO TCDOCU.

END.
FOR EACH DDOCU NO-LOCK:
    CREATE TDDOCU.
    BUFFER-COPY DDOCU TO TDDOCU.

END.
FOR EACH RDOCU WHERE RDOCU.CanDev > 0:
    x-CanDev = RDOCU.CanDev.
    FOR EACH TDDOCU WHERE TDDOCU.codmat = RDOCU.codmat,
        FIRST TCDOCU OF TDDOCU BY TCDOCU.FchDoc DESC:
        ASSIGN
            TDDOCU.CanDev = MINIMUM(TDDOCU.CanDes, x-CanDev).
        ASSIGN
            x-CanDev = x-CanDev - TDDOCU.CanDev.
        IF x-CanDev <= 0 THEN LEAVE.
    END.
END.
FOR EACH TDDOCU WHERE TDDOCU.CanDev <= 0:
    DELETE TDDOCU.
END.
/* ****************************************************** */
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.
DEFINE VARIABLE t-Row                   AS INTEGER INIT 1.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */
ASSIGN
    chWorkSheet:Range("A1"):Value = "DEVOLUCIONES A CISSAC " +  COMBO-BOX-NroMes + " " + STRING(COMBO-BOX-Periodo, '9999')
    chWorkSheet:Range("A2"):Value = "CODIGO"
    chWorkSheet:Range("B2"):Value = "NUMERO"
    chWorkSheet:Columns("B"):NumberFormat = "@"
    chWorkSheet:Range("C2"):Value = "FECHA"
    chWorkSheet:Columns("C"):NumberFormat = "dd/mm/yyyy"
    chWorkSheet:Range("D2"):Value = "MONEDA"
    chWorkSheet:Range("E2"):Value = "ARTICULO"
    chWorkSheet:Columns("E"):NumberFormat = "@"
    chWorkSheet:Range("F2"):Value = "DESCRIPCION"
    chWorkSheet:Range("G2"):Value = "CANTIDAD"
    chWorkSheet:Range("H2"):Value = "P.UNITARIO".

ASSIGN
    t-Row = 2.
FOR EACH TCDOCU NO-LOCK, EACH TDDOCU OF TCDOCU NO-LOCK, FIRST integral.Almmmatg OF TDDOCU NO-LOCK:
    ASSIGN
        t-Column = 0
        t-Row    = t-Row + 1.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = TCDOCU.CODDOC.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = TCDOCU.NRODOC.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = TCDOCU.FCHDOC.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = (IF TCDOCU.CODMON = 1 THEN 'S/.' ELSE 'US$').
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = TDDOCU.CODMAT.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = INTEGRAL.ALMMMATG.DESMAT.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = TDDOCU.CANDEV.
    ASSIGN
        t-Column = t-Column + 1
        chWorkSheet:Cells(t-Row, t-Column):VALUE = TDDOCU.PREUNI.
END.
chExcelApplication:VISIBLE = TRUE.
/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Ingreso-por-Devolucion W-Win 
PROCEDURE Genera-Ingreso-por-Devolucion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR r-Rowid AS ROWID NO-UNDO.

EMPTY TEMP-TABLE CINGD.
EMPTY TEMP-TABLE DINGD.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND cissac.FacCfgGn WHERE cissac.FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
    FIND cissac.Almacen WHERE cissac.Almacen.CodCia = S-CODCIA 
        AND cissac.Almacen.CodAlm = "21"
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE cissac.Almacen THEN RETURN 'ADM-ERROR'.

    FOR EACH CDEVO:
        CREATE cissac.Almcmov.
        ASSIGN 
            cissac.Almcmov.CodCia = S-CodCia 
            cissac.Almcmov.CodAlm = "21"
            cissac.Almcmov.TipMov = "I"
            cissac.Almcmov.CodMov = 09 
            cissac.Almcmov.NroSer = 000
            cissac.Almcmov.NroDoc = cissac.Almacen.CorrIng
            cissac.Almcmov.FchDoc = TODAY
            cissac.Almcmov.TpoCmb = cissac.FacCfgGn.Tpocmb[1]
            cissac.Almcmov.FlgEst = "P"
            cissac.Almcmov.HorRcp = STRING(TIME,"HH:MM:SS")
            cissac.Almcmov.usuario = S-USER-ID
            cissac.Almcmov.CodCli = "20100038146"
            cissac.Almcmov.CodMon = CDEVO.CodMon    /* OJO */
            cissac.Almcmov.CodRef = CDEVO.CodRef
            cissac.Almcmov.NroRef = CDEVO.NroRef.
            /*cissac.Almcmov.NomRef  = Fill-in_nomcli:SCREEN-VALUE in frame {&FRAME-NAME}.*/
            /*cissac.Almcmov.NroRf3 = cReturnValue.*/
            /*cissac.Almcmov.NroRf2 = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999").*/
        ASSIGN
            cissac.Almacen.CorrIng = cissac.Almacen.CorrIng + 1.
        FIND cissac.CcbCDocu WHERE cissac.CcbCDocu.CodCia = S-CODCIA
            AND cissac.CcbCDocu.CodDoc = cissac.Almcmov.CodRef
            AND cissac.CcbCDocu.NroDoc = cissac.Almcmov.NroRef
            NO-LOCK.
        ASSIGN
            cissac.Almcmov.CodCli = cissac.CcbCDocu.CodCli
            cissac.Almcmov.CodMon = cissac.CcbCDocu.CodMon
            cissac.Almcmov.CodVen = cissac.CcbCDocu.CodVen.
        CREATE CINGD.
        BUFFER-COPY cissac.Almcmov TO CINGD.
        FOR EACH DDEVO OF CDEVO:
            CREATE cissac.Almdmov.
            ASSIGN 
                cissac.Almdmov.CodCia = cissac.Almcmov.CodCia 
                cissac.Almdmov.CodAlm = cissac.Almcmov.CodAlm 
                cissac.Almdmov.TipMov = cissac.Almcmov.TipMov 
                cissac.Almdmov.CodMov = cissac.Almcmov.CodMov 
                cissac.Almdmov.NroSer = cissac.Almcmov.NroSer
                cissac.Almdmov.NroDoc = cissac.Almcmov.NroDoc 
                cissac.Almdmov.CodMon = cissac.Almcmov.CodMon 
                cissac.Almdmov.FchDoc = cissac.Almcmov.FchDoc 
                cissac.Almdmov.TpoCmb = cissac.Almcmov.TpoCmb 
                cissac.Almdmov.codmat = DDEVO.codmat
                cissac.Almdmov.CanDes = DDEVO.CanDes
                cissac.Almdmov.CodUnd = DDEVO.CodUnd
                cissac.Almdmov.Factor = DDEVO.Factor
                cissac.Almdmov.ImpCto = DDEVO.ImpCto
                cissac.Almdmov.PreUni = DDEVO.PreUni
                cissac.Almdmov.CodAjt = '' 
                cissac.Almdmov.PreBas = DDEVO.PreBas 
                cissac.Almdmov.PorDto = DDEVO.PorDto 
                cissac.Almdmov.ImpLin = DDEVO.ImpLin 
                cissac.Almdmov.ImpIsc = DDEVO.ImpIsc 
                cissac.Almdmov.ImpIgv = DDEVO.ImpIgv 
                cissac.Almdmov.ImpDto = DDEVO.ImpDto 
                cissac.Almdmov.AftIsc = DDEVO.AftIsc 
                cissac.Almdmov.AftIgv = DDEVO.AftIgv 
                cissac.Almdmov.CodAnt = DDEVO.CodAnt
                cissac.Almdmov.Por_Dsctos[1] = DDEVO.Por_Dsctos[1]
                cissac.Almdmov.Por_Dsctos[2] = DDEVO.Por_Dsctos[2]
                cissac.Almdmov.Por_Dsctos[3] = DDEVO.Por_Dsctos[3]
                cissac.Almdmov.Flg_factor = DDEVO.Flg_factor
                cissac.Almdmov.HraDoc     = cissac.Almcmov.HorRcp
                R-ROWID = ROWID(cissac.Almdmov).
/*             RUN ALM\ALMACSTK (R-ROWID).                                  */
/*             IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
/*             /* RHC 31.03.04 REACTIVAMOS KARDEX POR ALMACEN */            */
/*             RUN alm/almacpr1 (R-ROWID, 'U').                             */
/*             IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
            FIND cissac.Almmmatg WHERE cissac.Almmmatg.CodCia = S-CODCIA 
                AND cissac.Almmmatg.codmat = DDEVO.codmat 
                NO-LOCK NO-ERROR.
            IF AVAILABLE cissac.Almmmatg THEN DO:
                ASSIGN 
                    cissac.Almdmov.ImpLin = ROUND( cissac.Almdmov.PreUni * cissac.Almdmov.CanDes , 2 ).
                IF cissac.Almdmov.AftIgv THEN cissac.Almdmov.ImpIgv = cissac.Almdmov.ImpLin - ROUND(cissac.Almdmov.ImpLin  / (1 + (cissac.CcbCDocu.PorIgv / 100)),4).
            END.
            BUFFER-COPY cissac.Almdmov TO DINGD.
        END.
    END.
END.

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
  COMBO-BOX-Periodo:DELETE(1) IN FRAME {&FRAME-NAME}.
  COMBO-BOX-Periodo:LIST-ITEMS = p-List.
  COMBO-BOX-Periodo = INTEGER(ENTRY(NUM-ENTRIES(p-List) - 1, p-List)).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Movimientos-de-Ingresos-Cissac W-Win 
PROCEDURE Movimientos-de-Ingresos-Cissac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* 1ro Devolucion Mercaderia del Cliente */
RUN Genera-Ingreso-por-Devolucion.

/* 2do Notas de Credito por Devolucion */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Movimientos-de-Salida-de-Continental W-Win 
PROCEDURE Movimientos-de-Salida-de-Continental :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* 1ro Transferencias de salida de los almacenes comerciales al almacen 21 */
RUN Genera-Transferencia-de-Salida (INTEGER(COMBO-BOX-NroMes), 
                                    COMBO-BOX-Periodo,
                                    INPUT TABLE DMOV,
                                    INPUT TABLE RDOCU).

/* 3ro Salida por devolución de Mercaderia de Continental a Cissac Almacén 21 */
RUN Genera-Salida-por-Devolucion.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Preparar-Transferencias W-Win 
PROCEDURE Preparar-Transferencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Determinamos cuanto transferir de los otros almacenes al 21 */
DEF VAR x-Vendido AS DEC NO-UNDO.
DEF VAR x-Stock21 AS DEC NO-UNDO.
DEF VAR x-CanDes  AS DEC NO-UNDO.

/* Transferencias de los almacenes comerciales al almacén 21 */
EMPTY TEMP-TABLE DMOV.
FOR EACH RDOCU NO-LOCK:
    x-Vendido = RDOCU.CanDes.
    x-Stock21 = 0.
    /* Buscamos el stock en el almacen 21 */
    FIND MMATE WHERE MMATE.codmat = RDOCU.codmat
        AND MMATE.codalm = '21' NO-ERROR.
    IF AVAILABLE MMATE THEN x-Stock21 = MMATE.stkact.
    x-CanDes = x-Vendido - x-Stock21.
    IF x-CanDes <= 0 THEN NEXT.     /* Lo cubre el Almacén 21 */
    /* Generamos las transferencias de los almacenes al almacen 21 */
    FOR EACH MMATE WHERE MMATE.codcia = s-codcia
        AND MMATE.codmat = RDOCU.codmat
        AND MMATE.codalm <> "21",
        FIRST integral.almmmatg OF MMATE NO-LOCK
        BY MMATE.stkact DESC:
        CREATE DMOV.
        ASSIGN
            DMOV.CodCia = s-codcia
            DMOV.CodAlm = MMATE.codalm
            DMOV.TipMov = "S"
            DMOV.CodMov = 03
            DMOV.AlmOri = "21"
            DMOV.CanDes = MINIMUM(x-CanDes, MMATE.stkact)
            DMOV.codmat = RDOCU.codmat
            DMOV.CodUnd = integral.Almmmatg.undstk
            DMOV.Factor = 1.
        x-CanDes = x-CanDes - DMOV.candes.
        IF x-CanDes <= 0 THEN LEAVE.
    END.
END.
/* Determinamos las cantidades a devolver de Continental a Cissac */
FOR EACH MMATE WHERE MMATE.codalm = "21", 
    FIRST RDOCU WHERE RDOCU.codcia = s-codcia
    AND RDOCU.codmat = MMATE.codmat:
    ASSIGN
        RDOCU.CanDev = MINIMUM(RDOCU.CanDes, MMATE.StkAct).
END.
FOR EACH RDOCU, EACH DMOV WHERE DMOV.codmat = RDOCU.codmat:
    ASSIGN
        RDOCU.CanDev = RDOCU.CanDev + DMOV.CanDes.
END.
/* QUITAMOS PRODUCTOS QUE NO SE VAN A DEVOLVER */
FOR EACH RDOCU WHERE RDOCU.CanDev <= 0:
    DELETE RDOCU.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Saldos-Almacenes-Comerciales W-Win 
PROCEDURE Saldos-Almacenes-Comerciales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Saldos a la Fecha de Corte */
DEF VAR x-FechaD AS DATE NO-UNDO.
DEF VAR x-FechaH AS DATE NO-UNDO.

RUN src/bin/_dateif (INTEGER(COMBO-BOX-NroMes), COMBO-BOX-Periodo, OUTPUT x-FechaD, OUTPUT x-FechaH).

/* Solo almacenes comerciales */
EMPTY TEMP-TABLE MMATE.
FOR EACH RDOCU NO-LOCK,
    EACH integral.Almacen NO-LOCK WHERE integral.Almacen.codcia = s-codcia
    AND integral.Almacen.Campo-C[6] = "Si",
    LAST integral.Almstkal NO-LOCK WHERE integral.Almstkal.codcia = s-codcia
    AND integral.Almstkal.codmat = RDOCU.codmat
    AND integral.Almstkal.codalm = integral.Almacen.codalm
    AND integral.Almstkal.fecha <= x-FechaH:
    CREATE MMATE.
    ASSIGN
        MMATE.codcia = s-codcia
        MMATE.codmat = RDOCU.codmat
        MMATE.codalm = integral.Almacen.codalm
        MMATE.stkact = integral.Almstkal.stkact.
END.
FOR EACH MMATE WHERE MMATE.StkAct <= 0:
    DELETE MMATE.
END.
browse-2:TITLE IN FRAME {&FRAME-NAME} = "SALDOS AL " + STRING(x-FechaH, '99/99/9999').

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
  {src/adm/template/snd-list.i "MMATE"}
  {src/adm/template/snd-list.i "RDOCU"}
  {src/adm/template/snd-list.i "INTEGRAL.Almmmatg"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Ventas-Cissac-a-Conti W-Win 
PROCEDURE Ventas-Cissac-a-Conti :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-FechaD AS DATE NO-UNDO.
DEF VAR x-FechaH AS DATE NO-UNDO.

/* Termina el fin de mes */
RUN src/bin/_dateif (INTEGER(COMBO-BOX-NroMes), COMBO-BOX-Periodo, OUTPUT x-FechaD, OUTPUT x-FechaH).

/* Inicio desde el primero de Oct */
IF INTEGER(COMBO-BOX-NroMes) <= 09 THEN x-FechaD = DATE(10, 01, COMBO-BOX-Periodo - 1).
ELSE x-FechaD = DATE(10, 01, COMBO-BOX-Periodo).

/* ACUMULAMOS LOS PRODUCTOS VENDIDOS */
EMPTY TEMP-TABLE CDOCU.
EMPTY TEMP-TABLE DDOCU.
EMPTY TEMP-TABLE RDOCU.
FOR EACH cissac.ccbcdocu NO-LOCK WHERE cissac.ccbcdocu.codcia = s-codcia
    AND cissac.ccbcdocu.coddoc = 'FAC'
    AND cissac.ccbcdocu.codcli = '20100038146'      /* Continental SAC */
    AND cissac.ccbcdocu.flgest <> "A"
    AND cissac.ccbcdocu.fchdoc >= x-FechaD
    AND cissac.ccbcdocu.fchdoc <= x-FechaH:
    CREATE CDOCU.
    BUFFER-COPY cissac.ccbcdocu TO CDOCU.
    FOR EACH cissac.ccbddocu OF cissac.ccbcdocu NO-LOCK:
        CREATE DDOCU.
        BUFFER-COPY cissac.ccbddocu TO DDOCU.
    END.
END.
/* RESUMIMOS POR PRODUCTO */
FOR EACH DDOCU, FIRST integral.almmmatg OF DDOCU NO-LOCK WHERE integral.almmmatg.PP = NO:   /* OJO */
    FIND FIRST RDOCU WHERE RDOCU.codmat = DDOCU.codmat NO-ERROR.
    IF NOT AVAILABLE RDOCU THEN CREATE RDOCU.
    ASSIGN
        RDOCU.codcia = s-codcia
        RDOCU.codmat = DDOCU.codmat
        RDOCU.candes = RDOCU.candes + (DDOCU.candes * DDOCU.factor)
        RDOCU.undvta = integral.Almmmatg.undstk.
END.
{&BROWSE-NAME}:TITLE IN FRAME {&FRAME-NAME} = {&BROWSE-NAME}:TITLE IN FRAME {&FRAME-NAME} +
    " DESDE EL " + STRING(x-FechaD, '99/99/9999') +
    " HASTA EL " + STRING(x-FechaH, '99/99/9999').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

