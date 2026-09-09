&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MATE FOR Almmmate.
DEFINE NEW SHARED TEMP-TABLE T-DREPO LIKE almdrepo.



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
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-CodAlm AS CHAR NO-UNDO.       /* Armamos la llave */
DEF VAR x-CodAlm AS CHAR NO-UNDO.       /* Armamos la llave */
DEF VAR s-AlmRep AS CHAR NO-UNDO.       /* Armamos la llave */
DEF VAR x-AlmRep AS CHAR NO-UNDO.       /* Armamos la llave */
DEF VAR s-coddoc AS CHAR INIT 'R/A' NO-UNDO.
DEF VAR s-tipmov AS CHAR INIT 'A' NO-UNDO.

DEF BUFFER BT-DREPO FOR T-DREPO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-6 BUTTON-8 BUTTON-7 BtnDone ~
TOGGLE-Sede-1 TOGGLE-Almacen-1 TOGGLE-Sede-2 TOGGLE-Almacen-2 TOGGLE-Sede-3 ~
TOGGLE-Sede-4 TOGGLE-Sede-5 
&Scoped-Define DISPLAYED-OBJECTS f-Mensaje TOGGLE-Sede-1 TOGGLE-Almacen-1 ~
TOGGLE-Sede-2 TOGGLE-Almacen-2 TOGGLE-Sede-3 TOGGLE-Sede-4 TOGGLE-Sede-5 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_treposicionutilex AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 9 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img/proces.bmp":U
     LABEL "Button 6" 
     SIZE 12 BY 1.69 TOOLTIP "Generar Temporal".

DEFINE BUTTON BUTTON-7 
     IMAGE-UP FILE "img/tbldef.ico":U
     LABEL "Button 7" 
     SIZE 10 BY 1.73 TOOLTIP "Generar Reposición Automática".

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 8" 
     SIZE 9 BY 1.73.

DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 64 BY 1 NO-UNDO.

DEFINE VARIABLE TOGGLE-Almacen-1 AS LOGICAL INITIAL yes 
     LABEL "Almacén 11" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Almacen-2 AS LOGICAL INITIAL yes 
     LABEL "Almacén 10a" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Sede-1 AS LOGICAL INITIAL yes 
     LABEL "Surquillo" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Sede-2 AS LOGICAL INITIAL yes 
     LABEL "San Borja" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Sede-3 AS LOGICAL INITIAL yes 
     LABEL "Plaza Norte" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Sede-4 AS LOGICAL INITIAL yes 
     LABEL "La Molina" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Sede-5 AS LOGICAL INITIAL yes 
     LABEL "Chorrillos" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-6 AT ROW 1.19 COL 2 WIDGET-ID 36
     BUTTON-8 AT ROW 1.19 COL 14 WIDGET-ID 42
     BUTTON-7 AT ROW 1.19 COL 23 WIDGET-ID 38
     BtnDone AT ROW 1.19 COL 33 WIDGET-ID 40
     f-Mensaje AT ROW 1.58 COL 43 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     TOGGLE-Sede-1 AT ROW 3.12 COL 42 WIDGET-ID 2
     TOGGLE-Almacen-1 AT ROW 3.12 COL 103 WIDGET-ID 24
     TOGGLE-Sede-2 AT ROW 4.08 COL 42 WIDGET-ID 4
     TOGGLE-Almacen-2 AT ROW 4.08 COL 103 WIDGET-ID 26
     TOGGLE-Sede-3 AT ROW 5.04 COL 42 WIDGET-ID 6
     TOGGLE-Sede-4 AT ROW 6 COL 42 WIDGET-ID 8
     TOGGLE-Sede-5 AT ROW 6.96 COL 42 WIDGET-ID 10
     "1ro." VIEW-AS TEXT
          SIZE 3.43 BY .62 AT ROW 3.12 COL 99 WIDGET-ID 30
     "5to." VIEW-AS TEXT
          SIZE 3.43 BY .62 AT ROW 6.96 COL 38 WIDGET-ID 22
     "3ro." VIEW-AS TEXT
          SIZE 3.43 BY .62 AT ROW 5.04 COL 38 WIDGET-ID 18
     "2do." VIEW-AS TEXT
          SIZE 3.43 BY .62 AT ROW 4.08 COL 38 WIDGET-ID 16
     "1ro." VIEW-AS TEXT
          SIZE 3.43 BY .62 AT ROW 3.12 COL 38 WIDGET-ID 14
     "Secuencia de Reposición de Stock:" VIEW-AS TEXT
          SIZE 31 BY .62 AT ROW 3.12 COL 6 WIDGET-ID 12
     "Secuencia de Almacenes de Despacho:" VIEW-AS TEXT
          SIZE 35 BY .62 AT ROW 3.12 COL 63 WIDGET-ID 28
     "2do." VIEW-AS TEXT
          SIZE 3.43 BY .62 AT ROW 4.08 COL 99 WIDGET-ID 32
     "4to." VIEW-AS TEXT
          SIZE 3.43 BY .62 AT ROW 6 COL 38 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 136.57 BY 22.42 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-MATE B "?" ? INTEGRAL Almmmate
      TABLE: T-DREPO T "NEW SHARED" ? INTEGRAL almdrepo
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "GENERACION DE REPOSICIONES UTILEX"
         HEIGHT             = 22.42
         WIDTH              = 136.57
         MAX-HEIGHT         = 23.81
         MAX-WIDTH          = 136.57
         VIRTUAL-HEIGHT     = 23.81
         VIRTUAL-WIDTH      = 136.57
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
/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* GENERACION DE REPOSICIONES UTILEX */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* GENERACION DE REPOSICIONES UTILEX */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
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


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
    ASSIGN
        TOGGLE-Almacen-1 TOGGLE-Almacen-2 
        TOGGLE-Sede-1 TOGGLE-Sede-2 TOGGLE-Sede-3 TOGGLE-Sede-4 TOGGLE-Sede-5.
   RUN Carga-Temporal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Button 7 */
DO:
    MESSAGE '¿Procedemos a generar los Pedidos por Reposición?'
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN NO-APPLY.
   RUN Generar-Pedido.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Button 8 */
DO:
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

    /* Titulos */
    chWorkSheet:Range("A1"):VALUE = "Almacén Despacho".
    chWorkSheet:Range("B1"):VALUE = "Almacén Solicitante".
    chWorkSheet:Range("C1"):VALUE = "Código".
    chWorkSheet:Range("D1"):VALUE = "Descripción".
    chWorkSheet:Range("E1"):VALUE = "Marca".
    chWorkSheet:Range("F1"):VALUE = "Unidad".
    chWorkSheet:Range("G1"):VALUE = "Cantidad Requerida".
    chWorkSheet:Range("H1"):VALUE = "Cantidad Generada".
    chWorkSheet:Range("I1"):VALUE = "Stock Actual".

    chWorkSheet:COLUMNS("A"):NumberFormat = "@".
    chWorkSheet:COLUMNS("B"):NumberFormat = "@".
    chWorkSheet:COLUMNS("C"):NumberFormat = "@".

    chWorkSheet = chExcelApplication:Sheets:Item(1).

    SESSION:SET-WAIT-STATE('GENERAL').
    FOR EACH T-DREPO NO-LOCK, FIRST Almmmatg OF T-DREPO NO-LOCK:
        t-Row = t-Row + 1.
        t-Column = 1.
        chWorkSheet:Cells(t-Row, t-Column) = T-DREPO.AlmPed.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = T-DREPO.CodAlm.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = T-DREPO.CodMat.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.DesMat.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.DesMar.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = Almmmatg.UndBas.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = T-DREPO.CanReq.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = T-DREPO.CanGen.
        t-column = t-column + 1.
        chWorkSheet:Cells(t-Row, t-Column) = T-DREPO.StkAct.
    END.
    SESSION:SET-WAIT-STATE('').
    /* launch Excel so it is visible to the user */
    chExcelApplication:VISIBLE = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/treposicionutilex.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_treposicionutilex ).
       RUN set-position IN h_treposicionutilex ( 8.12 , 2.00 ) NO-ERROR.
       RUN set-size IN h_treposicionutilex ( 15.00 , 133.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_treposicionutilex ,
             TOGGLE-Sede-5:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

DEF VAR pRowid AS ROWID.
DEF VAR pReposicion AS DEC.
DEF VAR pComprometido AS DEC.

DEF VAR x-StockMinimo AS DEC NO-UNDO.
DEF VAR x-StockDisponible AS DEC NO-UNDO.
DEF VAR x-Item AS INT INIT 1 NO-UNDO.
DEF VAR x-CanReq LIKE T-DREPO.CanReq.
DEF VAR x-StkAct LIKE Almmmate.StkAct NO-UNDO.
DEF VAR x-Factor AS DEC NO-UNDO.

DEF VAR j AS INT NO-UNDO.
DEF VAR k AS INT NO-UNDO.

/* Buscamos los valores generales */
FIND FIRST AlmCfgGn WHERE almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcfggn THEN DO:
    MESSAGE 'Debe configurar los parámetros generales' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Buscando información, un momento por favor'.

ASSIGN
    x-CodAlm = ''
    x-AlmRep = ''.
IF TOGGLE-Sede-1 = YES THEN x-CodAlm = x-CodAlm + (IF x-CodAlm = '' THEN '10' ELSE ',10').
IF TOGGLE-Sede-2 = YES THEN x-CodAlm = x-CodAlm + (IF x-CodAlm = '' THEN '502' ELSE ',502').
IF TOGGLE-Sede-3 = YES THEN x-CodAlm = x-CodAlm + (IF x-CodAlm = '' THEN '501' ELSE ',501').
IF TOGGLE-Sede-4 = YES THEN x-CodAlm = x-CodAlm + (IF x-CodAlm = '' THEN '503' ELSE ',503').
IF TOGGLE-Sede-5 = YES THEN x-CodAlm = x-CodAlm + (IF x-CodAlm = '' THEN '27' ELSE ',27').

IF TOGGLE-Almacen-1 = YES THEN x-AlmRep = x-AlmRep + (IF x-AlmRep = '' THEN '11' ELSE ',11').
IF TOGGLE-Almacen-2 = YES THEN x-AlmRep = x-AlmRep + (IF x-AlmRep = '' THEN '10a' ELSE ',10a').

SESSION:SET-WAIT-STATE('GENERAL').
EMPTY TEMP-TABLE T-DREPO.
DO j = 1 TO NUM-ENTRIES(x-CodAlm):
    s-CodAlm = ENTRY(j, x-CodAlm).
    /* BARREMOS TIENDA POR TIENDA */
    FOR EACH almmmate NO-LOCK WHERE Almmmate.codcia = s-codcia 
        AND Almmmate.codalm = s-codalm
        AND Almmmate.stkrep > 0,
        FIRST almmmatg OF almmmate NO-LOCK WHERE Almmmatg.TpoArt <> 'D':
        f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Procesando ' + Almmmate.codalm + ' ' + Almmmate.codmat.
        ASSIGN
            pRowid = ROWID(Almmmate).
        /* Stock Minimo */
        ASSIGN
            x-StockMinimo = Almmmate.StkMin     /* CASO ESPECIAL UTILEX */
            x-StkAct      = Almmmate.StkAct.
        IF x-StkAct >= x-StockMinimo THEN NEXT.

        /* Cantidad de Reposicion */
        x-Factor = (IF Almmmate.StkRep > 0 THEN Almmmate.StkRep ELSE 1).
        pReposicion = ROUND( (x-StockMinimo - x-StkAct) / x-Factor, 0) * x-Factor.
        IF pReposicion <= 0 THEN NEXT.

        /* distribuimos el pedido entre los almacenes de despacho */
        DO k = 1 TO NUM-ENTRIES(x-AlmRep):
            s-AlmRep = ENTRY(k, x-AlmRep).
            FIND B-MATE WHERE B-MATE.codcia = s-codcia
                AND B-MATE.codalm = s-AlmRep
                AND B-MATE.codmat = Almmmate.codmat
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE B-MATE THEN NEXT.
            /* STOCK COMPROMETIDO */
            pComprometido = 0.
            RUN vta2/Stock-Comprometido (Almmmate.CodMat, s-AlmRep, OUTPUT pComprometido).
            /* REPOSICIONES YA PROCESADAS EN ESTA RUTINA */
            FOR EACH BT-DREPO WHERE BT-DREPO.CodMat = Almmmate.codmat AND BT-DREPO.AlmPed <> "998":
                pComprometido = pComprometido + BT-DREPO.CanReq.
            END.
            x-StockDisponible = (B-MATE.StkAct - pComprometido).
            IF x-StockDisponible <= 0 THEN NEXT.
            x-CanReq = MINIMUM(x-StockDisponible, pReposicion).
            IF x-CanReq <= 0 THEN NEXT.    /* Menos que la cantidad por empaque */
            /* Redondeamos la cantidad a entero */
            IF TRUNCATE(x-CanReq,0) <> x-CanReq THEN DO:
                x-CanReq = TRUNCATE(x-CanReq,0) + 1.
            END.
            /* ********************************* */
            CREATE T-DREPO.
            ASSIGN
                T-DREPO.Origen = 'AUT'
                T-DREPO.CodCia = s-codcia 
                T-DREPO.CodAlm = s-codalm 
                T-DREPO.Item   = x-Item
                T-DREPO.AlmPed = s-AlmRep
                T-DREPO.CodMat = Almmmate.codmat
                T-DREPO.CanReq = x-CanReq
                T-DREPO.CanGen = x-CanReq
                T-DREPO.StkAct = x-StockDisponible.
            ASSIGN
                x-Item = x-Item + 1
                pReposicion = pReposicion - T-DREPO.CanReq.
        END.
        /* RHC 15/10/2012 si queda un saldo lo pintamos en el almacén 998 */
        IF pReposicion > 0 THEN DO:
            x-CanReq = pReposicion.
            IF Almmmatg.CanEmp > 0 THEN DO:
                x-CanReq = ROUND(x-CanReq / Almmmatg.CanEmp, 0) * Almmmatg.CanEmp.
            END.
            IF x-CanReq > 0 THEN DO:
                /* Redondeamos la cantidad a enteros */
                IF TRUNCATE(x-CanReq,0) <> x-CanReq THEN DO:
                    x-CanReq = TRUNCATE(x-CanReq,0) + 1.
                END.
                /* ********************************* */
                CREATE T-DREPO.
                ASSIGN
                    T-DREPO.Origen = 'AUT'
                    T-DREPO.CodCia = s-codcia 
                    T-DREPO.CodAlm = s-codalm
                    T-DREPO.Item = x-Item
                    T-DREPO.AlmPed = "998"
                    T-DREPO.CodMat = Almmmate.codmat
                    T-DREPO.CanReq = 0
                    T-DREPO.CanGen = x-CanReq
                    /*T-DREPO.CanGen = pReposicion*/
                    T-DREPO.StkAct = 0.
                x-Item = x-Item + 1.
            END.
        END.
    END.
END.

FOR EACH T-DREPO WHERE T-DREPO.canreq <= 0 AND LOOKUP(T-DREPO.AlmPed, '997,998') = 0:
    DELETE T-DREPO.
END.
f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '*** PROCESO TERMINADO ***'.
SESSION:SET-WAIT-STATE('').

RUN dispatch IN h_treposicionutilex ('open-query':U).

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
  DISPLAY f-Mensaje TOGGLE-Sede-1 TOGGLE-Almacen-1 TOGGLE-Sede-2 
          TOGGLE-Almacen-2 TOGGLE-Sede-3 TOGGLE-Sede-4 TOGGLE-Sede-5 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-6 BUTTON-8 BUTTON-7 BtnDone TOGGLE-Sede-1 TOGGLE-Almacen-1 
         TOGGLE-Sede-2 TOGGLE-Almacen-2 TOGGLE-Sede-3 TOGGLE-Sede-4 
         TOGGLE-Sede-5 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Generar-Pedido W-Win 
PROCEDURE Generar-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Verificamos los controles de correlativos */
FOR EACH T-DREPO WHERE LOOKUP(T-DREPO.AlmPed, '997,998') = 0 BREAK BY T-DREPO.CodAlm:
    IF FIRST-OF(T-DREPO.CodAlm) THEN DO:
        s-CodAlm = T-DREPO.codalm.
        FIND Faccorre WHERE Faccorre.codcia = s-codcia
            AND Faccorre.coddoc = s-coddoc
            AND Faccorre.flgest = YES
            AND Faccorre.codalm = s-codalm
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccorre THEN DO:
            MESSAGE 'No se encuentra el correlativo para el documento' s-coddoc 'del almacén' s-codalm
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
    END.
END.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FOR EACH T-DREPO WHERE LOOKUP(T-DREPO.AlmPed, '997,998') = 0,
        FIRST Almmmatg OF T-DREPO NO-LOCK
        BREAK BY T-DREPO.CodAlm BY T-DREPO.AlmPed BY T-DREPO.Item:
        IF FIRST-OF(T-DREPO.CodAlm) OR FIRST-OF(T-DREPO.AlmPed) THEN DO:
            s-CodAlm = T-DREPO.codalm.
            FIND Faccorre WHERE Faccorre.codcia = s-codcia
                AND Faccorre.coddoc = s-coddoc
                AND Faccorre.flgest = YES
                AND Faccorre.codalm = s-codalm
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Faccorre THEN DO:
                MESSAGE 'No se encuentra el correlativo para el documento' s-coddoc 'del almacén' s-codalm
                    VIEW-AS ALERT-BOX ERROR.
                UNDO, RETURN "ADM-ERROR".
            END.
            CREATE Almcrepo.
            ASSIGN
                almcrepo.AlmPed = T-DREPO.Almped
                almcrepo.CodAlm = s-codalm
                almcrepo.CodCia = s-codcia
                almcrepo.FchDoc = TODAY
                almcrepo.FchVto = TODAY + 7
                almcrepo.Fecha = TODAY
                almcrepo.Hora = STRING(TIME, 'HH:MM')
                almcrepo.NroDoc = Faccorre.correlativo
                almcrepo.NroSer = Faccorre.nroser
                almcrepo.TipMov = s-tipmov
                almcrepo.Usuario = s-user-id.
            ASSIGN
                Faccorre.correlativo = Faccorre.correlativo + 1.
        END.
        CREATE Almdrepo.
        BUFFER-COPY T-DREPO TO Almdrepo
            ASSIGN
            almdrepo.CodCia = almcrepo.codcia
            almdrepo.CodAlm = almcrepo.codalm
            almdrepo.TipMov = almcrepo.tipmov
            almdrepo.NroSer = almcrepo.nroser
            almdrepo.NroDoc = almcrepo.nrodoc
            almdrepo.CanApro = almdrepo.canreq.
    END.
    RELEASE Faccorre.
    EMPTY TEMP-TABLE T-DREPO.
END.
MESSAGE 'Proceso Terminado'.
RUN dispatch IN h_treposicionutilex ('open-query':U).


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

