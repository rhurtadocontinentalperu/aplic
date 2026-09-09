&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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

/* Local Variable Definitions ---                                       */
    DEFINE VAR lArchivoSalida AS CHARACTER INIT "".
    DEFINE SHARED VAR s-codcia AS INT.
    DEFINE STREAM rpt_file_txt.

    DEF TEMP-TABLE tt-txt
        FIELD Codigo AS CHAR FORMAT 'x(15)'.

    DEFINE TEMP-TABLE tt-almmmatg LIKE almmmatg INDEX tt-idx orden.
    DEFINE TEMP-TABLE tt-gn-clie LIKE gn-clie INDEX tt-idx MonLC.
    DEFINE TEMP-TABLE tt-gn-prov LIKE gn-prov INDEX tt-idx TpoEnt.

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
&Scoped-Define ENABLED-OBJECTS RADIO-quienes-1 ChkBoxTodos optgrp-cuales ~
BUTTON-1 txtAlmacenes BUTTON-procesar BUTTON-salir 
&Scoped-Define DISPLAYED-OBJECTS RADIO-quienes-1 ChkBoxTodos optgrp-cuales ~
optgrp-donde FILL-IN-filetxt txtAlmacenes FILL-IN-msg 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 5 BY 1.08.

DEFINE BUTTON BUTTON-procesar 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-salir 
     LABEL "Salir" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-filetxt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 72 BY 1
     FGCOLOR 4 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-msg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE txtAlmacenes AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacenes (Stock)" 
     VIEW-AS FILL-IN 
     SIZE 64 BY 1 NO-UNDO.

DEFINE VARIABLE optgrp-cuales AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "ACTIVOS", 1,
"NO ACTIVOS", 2,
"Ambos", 3
     SIZE 43 BY .96 NO-UNDO.

DEFINE VARIABLE optgrp-donde AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Excel", 1,
"Archivo plano TXT (Solo CLIENTES ó PROVEEDORES)", 2
     SIZE 64.57 BY .96
     FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE RADIO-quienes-1 AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Articulos", 1,
"Clientes", 2,
"Proveedores", 3,
"Articulos-Precios-Stock", 4
     SIZE 64 BY 1.23 NO-UNDO.

DEFINE VARIABLE ChkBoxTodos AS LOGICAL INITIAL no 
     LABEL "Generar TODOS  ( Ignorar el archivo de TEXTO )" 
     VIEW-AS TOGGLE-BOX
     SIZE 47.57 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-quienes-1 AT ROW 1.35 COL 10 NO-LABEL WIDGET-ID 2
     ChkBoxTodos AT ROW 2.85 COL 19.43 WIDGET-ID 20
     optgrp-cuales AT ROW 3.77 COL 19.29 NO-LABEL WIDGET-ID 26
     optgrp-donde AT ROW 5.31 COL 11.43 NO-LABEL WIDGET-ID 22
     BUTTON-1 AT ROW 6.19 COL 75 WIDGET-ID 8
     FILL-IN-filetxt AT ROW 7.08 COL 3 NO-LABEL WIDGET-ID 10
     txtAlmacenes AT ROW 8.62 COL 16.86 COLON-ALIGNED WIDGET-ID 30
     BUTTON-procesar AT ROW 11.19 COL 41 WIDGET-ID 14
     BUTTON-salir AT ROW 11.19 COL 63 WIDGET-ID 16
     FILL-IN-msg AT ROW 11.23 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     "Ejemplo 03,05,11,... (Maximo 10 Almacenes)" VIEW-AS TEXT
          SIZE 36 BY .62 AT ROW 9.69 COL 27 WIDGET-ID 32
          FGCOLOR 9 
     "Seleccione el Archivo de TEXTO a trabajar" VIEW-AS TEXT
          SIZE 37.43 BY .62 AT ROW 6.38 COL 37.43 WIDGET-ID 12
          FGCOLOR 14 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.86 BY 11.65 WIDGET-ID 100.


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
         TITLE              = "Generacion de Data"
         HEIGHT             = 11.65
         WIDTH              = 83.86
         MAX-HEIGHT         = 17.23
         MAX-WIDTH          = 85.57
         VIRTUAL-HEIGHT     = 17.23
         VIRTUAL-WIDTH      = 85.57
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
/* SETTINGS FOR FILL-IN FILL-IN-filetxt IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-msg IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET optgrp-donde IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Generacion de Data */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Generacion de Data */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:

    DEFINE VARIABLE X-archivo AS CHARACTER.
    DEFINE VARIABLE OKpressed AS LOGICAL.

    DISPLAY "" @ FILL-IN-filetxt WITH FRAME {&FRAME-NAME}.
    DISPLAY "" @ FILL-IN-msg WITH FRAME {&FRAME-NAME}.

SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS "Archivo (*.txt)" "*.txt"
            MUST-EXIST
            TITLE "Seleccione archivo..."
            UPDATE OKpressed.   
          IF OKpressed = NO THEN RETURN.  

      DISPLAY X-archivo @ FILL-IN-filetxt WITH FRAME {&FRAME-NAME}.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-procesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-procesar W-Win
ON CHOOSE OF BUTTON-procesar IN FRAME F-Main /* Procesar */
DO:
  
    DEFINE VARIABLE lRutaFile AS CHARACTER.

    lRutaFile = FILL-IN-filetxt:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    ASSIGN optgrp-donde ChkBoxTodos RADIO-quienes-1 txtAlmacenes.
    /* Todos = NO, validar */
    IF ChkBoxTodos = NO  THEN DO:
        IF lRutaFile = ? OR trim(lRutaFile) = "" THEN RETURN.
    END.
    
    RUN procesa.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-salir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-salir W-Win
ON CHOOSE OF BUTTON-salir IN FRAME F-Main /* Salir */
DO:
  APPLY  "CLOSE" TO THIS-PROCEDURE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga_articulos W-Win 
PROCEDURE carga_articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lCodArt AS CHARACTER.
DEFINE VAR lCorre AS INT.

/* Cargo la data desde articulos al temporal */
lCorre = 1.
FOR EACH tt-txt NO-LOCK:
    lCodArt = trim(tt-txt.codigo).
    IF lCodArt = "" THEN NEXT.
    DISPLAY lCodArt @ FILL-IN-msg WITH FRAME {&FRAME-NAME}.
    FIND almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = lCodArt NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN DO:
        CREATE tt-almmmatg.
        BUFFER-COPY almmmatg TO tt-almmmatg.
        tt-almmmatg.orden = lCorre.
    END.
    ELSE DO:
        CREATE tt-almmmatg.
        tt-almmmatg.codmat = lCodArt.
        tt-almmmatg.DesMat = " ** NO EXISTE **".
        tt-almmmatg.orden = lCorre.
    END.
    lCorre = lCorre + 1.
END.

/* Desde el temporal, lo llevo a EXCEL */

        DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
        DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
        DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

        DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

        DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
        DEFINE VARIABLE cColumn                 AS CHARACTER.
        DEFINE VARIABLE cRange                  AS CHARACTER.


        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = TRUE.

        /* create a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

    cRange = "A1".
    chWorkSheet:Range(cRange):Value = "CODIGO".
    cRange = "B1".
    chWorkSheet:Range(cRange):Value = "DESCRIPCION".
    cRange = "C1".
    chWorkSheet:Range(cRange):Value = "COD.MARCA".
    cRange = "D1".
    chWorkSheet:Range(cRange):Value = "DESC. MARCA".
    cRange = "E1".
    chWorkSheet:Range(cRange):Value = "UND BASE".
    cRange = "F1".
    chWorkSheet:Range(cRange):Value = "UND STOCK".
    cRange = "G1".
    chWorkSheet:Range(cRange):Value = "UND. COMPRA". 
    cRange = "H1".
    chWorkSheet:Range(cRange):Value = "MND VENTA".
    cRange = "I1".
    chWorkSheet:Range(cRange):Value = "COD.FAMILIA".
    cRange = "J1".
    chWorkSheet:Range(cRange):Value = "DESC.FAMILIA".
    cRange = "K1".
    chWorkSheet:Range(cRange):Value = "COD.SUB-FAMILIA".
    cRange = "L1".
    chWorkSheet:Range(cRange):Value = "DESC.SUB-FAMILIA".
    cRange = "M1".
    chWorkSheet:Range(cRange):Value = "COD. BARRA".
    cRange = "N1".
    chWorkSheet:Range(cRange):Value = "PROVEE. 1".
    cRange = "O1".
    chWorkSheet:Range(cRange):Value = "PROVEE. 2".
    cRange = "P1".
    chWorkSheet:Range(cRange):Value = "Nombre PROV 1".
    cRange = "Q1".
    chWorkSheet:Range(cRange):Value = "Clasif. Gral".
    cRange = "R1".
    chWorkSheet:Range(cRange):Value = "Clasif. Utilex".
    cRange = "S1".
    chWorkSheet:Range(cRange):Value = "Clasif. Mayorista".
    cRange = "T1".
    chWorkSheet:Range(cRange):Value = "Situacion".
    cRange = "U1".
    chWorkSheet:Range(cRange):Value = "Fec.Creacion".
    cRange = "V1".
    chWorkSheet:Range(cRange):Value = "Cod.Lic".
    cRange = "W1".
    chWorkSheet:Range(cRange):Value = "Decripcion.Lic".


iColumn = 2.

FOR EACH tt-almmmatg 
    WHERE ((optgrp-cuales = 3)
    OR (optgrp-cuales = 1 AND tt-almmmatg.tpoart = 'A')
    OR (optgrp-cuales = 2 AND tt-almmmatg.tpoart <> 'A'))
    NO-LOCK:

    FIND FIRST almtfami WHERE almtfami.codcia = s-codcia AND almtfami.codfam = tt-almmmatg.codfam NO-LOCK NO-ERROR.
    FIND FIRST almsfami WHERE almsfami.codcia = s-codcia 
        AND almsfami.codfam = tt-almmmatg.codfam 
        AND almsfami.subfam = tt-almmmatg.subfam
        NO-LOCK NO-ERROR.

    cRange = "A" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.codmat.
    cRange = "B" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.DesMat.
    cRange = "C" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-almmmatg.CodMar.
    cRange = "D" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-almmmatg.DesMar.                                            
    cRange = "E" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.UndBas.
    cRange = "F" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.UndStk.
    cRange = "G" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.UndCmp.                                       
    cRange = "H" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + STRING(tt-almmmatg.MonVta).

    cRange = "I" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.codfam.
    cRange = "J" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + IF (AVAILABLE almtfami) THEN almtfami.desfam ELSE "".
    cRange = "K" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.subfam.
    cRange = "L" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + IF (AVAILABLE almsfam) THEN almsfam.dessub ELSE "".

    cRange = "M" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.CodBrr.
    cRange = "N" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.CodPr1.
    cRange = "O" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.CodPr2.

    FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND gn-prov.codpro = tt-almmmatg.CodPr1 NO-LOCK NO-ERROR.
    cRange = "P" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = IF (AVAILABLE gn-prov) THEN gn-prov.nompro ELSE "".

    cRange = "Q" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-almmmatg.tiprot[1].
    cRange = "R" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-almmmatg.undalt[3].
    cRange = "S" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-almmmatg.undalt[4].
    cRange = "T" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = if(tt-almmmatg.tpoart = 'A') THEN "ACTIVO" ELSE 
        IF(tt-almmmatg.tpoart = 'B') THEN "BLOQUEADO" ELSE "DESACTIVADO".
   cRange = "U" + STRING(iColumn).
   chWorkSheet:Range(cRange):Value = tt-almmmatg.fching.

   /*Licencas*/
   cRange = "V" + STRING(iColumn).
   chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.licencia[1].
   FIND FIRST almtabla WHERE almtabla.tabla = 'LC' AND almtabla.codigo = tt-almmmatg.licencia[1] NO-LOCK NO-ERROR.
   IF AVAILABLE almtabla THEN DO:
       cRange = "W" + STRING(iColumn).
       chWorkSheet:Range(cRange):Value = almtabla.nombre.
   END.

    iColumn = iColumn + 1.

    FILL-IN-msg:SCREEN-VALUE = tt-almmmatg.codmat + " (" + STRING(iColumn,">>,>>>,>>9")  + ")".
END.

chWorkSheet:SaveAs(lArchivoSalida).
chExcelApplication:DisplayAlerts = False.
chExcelApplication:Quit().


/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga_articulos_precio W-Win 
PROCEDURE carga_articulos_precio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lCodArt AS CHARACTER.
DEFINE VAR lCorre AS INT.
DEFINE VAR lCelda AS CHAR.

/* Cargo la data desde articulos al temporal */
lCorre = 1.
FOR EACH tt-txt NO-LOCK:
    lCodArt = trim(tt-txt.codigo).
    IF lCodArt = "" THEN NEXT.
    DISPLAY lCodArt @ FILL-IN-msg WITH FRAME {&FRAME-NAME}.
    FIND almmmatg WHERE almmmatg.codcia = s-codcia AND almmmatg.codmat = lCodArt NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN DO:
        CREATE tt-almmmatg.
        BUFFER-COPY almmmatg TO tt-almmmatg.
        tt-almmmatg.orden = lCOrre.
    END.
    ELSE DO:
        CREATE tt-almmmatg.
        tt-almmmatg.codmat = lCodArt.
        tt-almmmatg.DesMat = " ** NO EXISTE **".
        tt-almmmatg.orden = lCOrre.
    END.
    lCorre = lCorre + 1.
END.

/* Desde el temporal, lo llevo a EXCEL */

        DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
        DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
        DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

        DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

        DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
        DEFINE VARIABLE cColumn                 AS CHARACTER.
        DEFINE VARIABLE cRange                  AS CHARACTER.


        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = FALSE.

        /* create a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

    cRange = "A1".
    chWorkSheet:Range(cRange):Value = "CODIGO".
    cRange = "B1".
    chWorkSheet:Range(cRange):Value = "DESCRIPCION".
    cRange = "C1".
    chWorkSheet:Range(cRange):Value = "UND BASE".
    cRange = "D1".
    chWorkSheet:Range(cRange):Value = "UND STOCK".
    cRange = "E1".
    chWorkSheet:Range(cRange):Value = "UND. COMPRA". 
    cRange = "F1".
    chWorkSheet:Range(cRange):Value = "MND VENTA".
    cRange = "G1".
    chWorkSheet:Range(cRange):Value = "PRECIO OFICINA".
    cRange = "H1".
    chWorkSheet:Range(cRange):Value = "TPO CAMBIO".
    cRange = "I1".
    chWorkSheet:Range(cRange):Value = "SITUACION".

    cRange = "J1".
    chWorkSheet:Range(cRange):Value = "COD.MARCA".
    cRange = "K1".
    chWorkSheet:Range(cRange):Value = "DESC. MARCA".
    cRange = "L1".
    chWorkSheet:Range(cRange):Value = "COD.FAMILIA".
    cRange = "M1".
    chWorkSheet:Range(cRange):Value = "DESC.FAMILIA".
    cRange = "N1".
    chWorkSheet:Range(cRange):Value = "COD.SUB-FAMILIA".
    cRange = "O1".
    chWorkSheet:Range(cRange):Value = "DESC.SUB-FAMILIA".

    /*
        80 : Letra 'O'
    */

        DO lCorre = 1 TO NUM-ENTRIES(txtAlmacenes):
        IF lCorre < 11 THEN DO:
            lCelda = CHR(79 + lCorre).
            cRange = lCelda + "1".
            lCelda = ENTRY(lCorre,txtAlmacenes,",").  /* Almamcen */
            chWorkSheet:Range(cRange):Value = "'" + lCelda.
        END.
    END.


iColumn = 2.

FOR EACH tt-almmmatg 
    WHERE ((optgrp-cuales = 3)
    OR (optgrp-cuales = 1 AND tt-almmmatg.tpoart = 'A')
    OR (optgrp-cuales = 2 AND tt-almmmatg.tpoart <> 'A'))
    NO-LOCK:

    FIND FIRST almtfami WHERE almtfami.codcia = s-codcia 
        AND almtfami.codfam = tt-almmmatg.codfam NO-LOCK NO-ERROR.
    FIND FIRST almsfami WHERE almsfami.codcia = s-codcia 
        AND almsfami.codfam = tt-almmmatg.codfam 
        AND almsfami.subfam = tt-almmmatg.subfam
        NO-LOCK NO-ERROR.
    FIND almtabla WHERE almtabla.tabla = 'MK' 
        AND almtabla.codigo = tt-almmmatg.codmar NO-LOCK NO-ERROR.

    cRange = "A" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.codmat.
    cRange = "B" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.DesMat.
    cRange = "C" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.UndBas.
    cRange = "D" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.UndStk.
    cRange = "E" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.UndCmp.                                       
    cRange = "F" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = if(tt-almmmatg.MonVta = 2) THEN "($.)" ELSE "(S/.)".
    cRange = "G" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-almmmatg.PreOfi.
    cRange = "H" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-almmmatg.tpocmb.
    cRange = "I" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = if(tt-almmmatg.tpoart = 'A') THEN "ACTIVO" ELSE 
        IF(tt-almmmatg.tpoart = 'B') THEN "BLOQUEADO" ELSE "DESACTIVADO".
   cRange = "J" + STRING(iColumn).
   chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.codmar.
   cRange = "K" + STRING(iColumn).
   chWorkSheet:Range(cRange):Value = "'" + IF (AVAILABLE almtabla) THEN almtabla.nombre ELSE "".
   cRange = "L" + STRING(iColumn).
   chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.codfam.
   cRange = "M" + STRING(iColumn).
   chWorkSheet:Range(cRange):Value = "'" + IF (AVAILABLE almtfami) THEN almtfami.desfam ELSE "".
   cRange = "N" + STRING(iColumn).
   chWorkSheet:Range(cRange):Value = "'" + tt-almmmatg.subfam.
   cRange = "O" + STRING(iColumn).
   chWorkSheet:Range(cRange):Value = "'" + IF (AVAILABLE almsfam) THEN almsfam.dessub ELSE "".

        DO lCorre = 1 TO NUM-ENTRIES(txtAlmacenes):
        IF lCorre < 11 THEN DO:
            lCelda = CHR(79 + lCorre).
            cRange = lCelda + STRING(iColumn).
            lCelda = ENTRY(lCorre,txtAlmacenes,",").  /* Almamcen */

            FIND almmmate WHERE almmmate.codcia = s-codcia AND 
                    almmmate.codalm = lCelda AND almmmate.codmat = tt-almmmatg.codmat 
                    NO-LOCK NO-ERROR.

            chWorkSheet:Range(cRange):Value = IF(AVAILABLE almmmate) THEN almmmate.stkact ELSE 0.
        END.
    END.


    iColumn = iColumn + 1.
END.

    
    chWorkSheet:SaveAs(lArchivoSalida).
    chExcelApplication:DisplayAlerts = False.
    chExcelApplication:Visible = TRUE.

    /*chExcelApplication:Quit().*/


        /* release com-handles */
        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.

        MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga_clientes W-Win 
PROCEDURE carga_clientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR lCodClie AS CHARACTER.
DEFINE VAR lCorre AS INT.

/* Cargo la data desde articulos al temporal */
lCorre = 1.
FOR EACH tt-txt NO-LOCK:
    lCodClie = trim(tt-txt.codigo).
    IF lCodClie = "" THEN NEXT.
    DISPLAY lCodClie @ FILL-IN-msg WITH FRAME {&FRAME-NAME}.
    FIND gn-clie WHERE gn-clie.codcia = 0 AND gn-clie.CodCli = lCodClie NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:
        CREATE tt-gn-clie.
        BUFFER-COPY gn-clie TO tt-gn-clie.
        tt-gn-clie.Monlc = lCOrre.
    END.
    ELSE DO:
        CREATE tt-gn-clie.
        tt-gn-clie.Monlc = lCOrre.
        tt-gn-clie.CodCli = lCodClie.
        tt-gn-clie.NomCli = "** NO EXISTE **".
    END.
    lCorre = lCorre + 1.
END.

{adm\w-generacion-data-clientes.i &tabla="tt-gn-clie"}.
    

/*
DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

lFileXls = lArchivoSalida.              /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

iColumn = 1.

cRange = "A1".
chWorkSheet:Range(cRange):Value = "CODIGO".
cRange = "B1".
chWorkSheet:Range(cRange):Value = "NOMBRE/RAZON".
cRange = "C1".
chWorkSheet:Range(cRange):Value = "DIRECCION".
cRange = "D1".
chWorkSheet:Range(cRange):Value = "DIRECCION ENTREGA".
cRange = "E1".
chWorkSheet:Range(cRange):Value = "CONTACTO".
cRange = "F1".
chWorkSheet:Range(cRange):Value = "RUC".
cRange = "G1".
chWorkSheet:Range(cRange):Value = "FAX".
cRange = "H1".
chWorkSheet:Range(cRange):Value = "REFERENCIAS".
cRange = "I1".
chWorkSheet:Range(cRange):Value = "GIRO".
cRange = "J1".
chWorkSheet:Range(cRange):Value = "VENDEDOR".
cRange = "K1".
chWorkSheet:Range(cRange):Value = "COND.VENTA".
cRange = "L1".
chWorkSheet:Range(cRange):Value = "TELEFONOS".
cRange = "M1".
chWorkSheet:Range(cRange):Value = "DIVISION".
cRange = "N1".
chWorkSheet:Range(cRange):Value = "CANAL".
cRange = "O1".
chWorkSheet:Range(cRange):Value = "NRO TARJETA".
cRange = "P1".
chWorkSheet:Range(cRange):Value = "COD. UNICO".
cRange = "Q1".
chWorkSheet:Range(cRange):Value = "D.N.I.".
cRange = "R1".
chWorkSheet:Range(cRange):Value = "AP. PATERNO".
cRange = "S1".
chWorkSheet:Range(cRange):Value = "AP. MATERNO".
cRange = "T1".
chWorkSheet:Range(cRange):Value = "NOMBRES".
cRange = "U1".
chWorkSheet:Range(cRange):Value = "CodDepto".
cRange = "V1".
chWorkSheet:Range(cRange):Value = "Nombre Depto".
cRange = "W1".
chWorkSheet:Range(cRange):Value = "CodProv".
cRange = "X1".
chWorkSheet:Range(cRange):Value = "Nombre Provincia".
cRange = "Y1".
chWorkSheet:Range(cRange):Value = "CodDistrito".
cRange = "Z1".
chWorkSheet:Range(cRange):Value = "Nombre Distrito".

cRange = "AA1".
chWorkSheet:Range(cRange):Value = "Clasif. Prod.Propios".
cRange = "AB1".
chWorkSheet:Range(cRange):Value = "Clasif. Prod.Terceros".

iColumn = 2.

FOR EACH tt-gn-clie NO-LOCK:
    cRange = "A" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-clie.CodCli.
    cRange = "B" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-clie.NomCli.
    cRange = "C" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-gn-clie.DirCli.
    cRange = "D" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-gn-clie.DirEnt.                                            
    cRange = "E" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-gn-clie.Contac.
    cRange = "F" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-clie.Ruc.
    cRange = "G" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-clie.FaxCli.                                       
    cRange = "H" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-gn-clie.Referencias.
    cRange = "I" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-clie.GirCli.
    cRange = "J" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-clie.CodVen.
    cRange = "K" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-clie.CndVta.
    cRange = "L" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-clie.Telfnos[1] + " " + tt-gn-clie.Telfnos[2] + " " + tt-gn-clie.Telfnos[3].
    cRange = "M" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-clie.CodDiv.
    cRange = "N" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-clie.Canal.
    cRange = "O" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-clie.NroCard.
    cRange = "P" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-clie.CodUnico.
    cRange = "Q" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-clie.DNI.
    cRange = "R" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-gn-clie.ApePat.
    cRange = "S" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-gn-clie.ApeMat.
    cRange = "T" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-gn-clie.Nombre.

    FIND FIRST TABdepto WHERE TABdepto.coddepto = tt-gn-clie.coddep NO-LOCK NO-ERROR.
    FIND FIRST TABProvi WHERE TABProvi.coddepto = tt-gn-clie.coddep 
                        AND TABProvi.codprovi = tt-gn-clie.codprov NO-LOCK NO-ERROR.
    FIND FIRST TABdistr WHERE TABdistr.coddepto = tt-gn-clie.coddep 
                        AND TABdistr.codprovi = tt-gn-clie.codprov 
                        AND coddistr = tt-gn-clie.coddist  NO-LOCK NO-ERROR.

    cRange = "U" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-clie.coddep.
    cRange = "V" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = IF(AVAILABLE tabdepto) THEN tabdepto.nomdepto ELSE "" .
    cRange = "W" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-clie.codprov.
    cRange = "X" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = IF(AVAILABLE tabprovi) THEN tabprovi.nomprovi ELSE "".
    cRange = "Y" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-clie.coddist.
    cRange = "Z" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = IF(AVAILABLE tabdistr) THEN tabdistr.nomdistr ELSE "".
    cRange = "AA" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-clie.clfcli.
    cRange = "AB" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-clie.clfcli2.


    iColumn = iColumn + 1.
END.

{lib\excel-close-file.i}
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga_proveedores W-Win 
PROCEDURE carga_proveedores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR lCodProv AS CHARACTER.
DEFINE VAR lCorre AS INT.

/* Cargo la data desde articulos al temporal */
lCorre = 1.
FOR EACH tt-txt NO-LOCK:
    lCodProv = trim(tt-txt.codigo).
    IF lCodProv = "" THEN NEXT.
    DISPLAY lCodProv @ FILL-IN-msg WITH FRAME {&FRAME-NAME}.
    FIND gn-Prov WHERE gn-Prov.codcia = 0 AND gn-Prov.CodPro = lCodProv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-Prov THEN DO:
        CREATE tt-gn-Prov.
        BUFFER-COPY gn-Prov TO tt-gn-Prov.
        tt-gn-Prov.TpoEnt = lCorre.
    END.
    ELSE DO:
        CREATE tt-gn-Prov.
        tt-gn-prov.CodPro = lCodProv.
        tt-gn-prov.NomPro = "** NO EXISTE **".
        tt-gn-Prov.TpoEnt = lCorre.
    END.
    lCorre = lCorre + 1.
END.

{adm\w-generacion-data-proveedores.i &tabla="tt-gn-prov"}.

/*
/* Desde el temporal, lo llevo a EXCEL */

        DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
        DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
        DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

        DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

        DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
        DEFINE VARIABLE cColumn                 AS CHARACTER.
        DEFINE VARIABLE cRange                  AS CHARACTER.


        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = TRUE.

        /* create a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

    cRange = "A1".
    chWorkSheet:Range(cRange):Value = "CODIGO".
    cRange = "B1".
    chWorkSheet:Range(cRange):Value = "NOMBRES / RAZON SOC.".
    cRange = "C1".
    chWorkSheet:Range(cRange):Value = "DIRECCION".
    cRange = "D1".
    chWorkSheet:Range(cRange):Value = "R.U.C.".
    cRange = "E1".
    chWorkSheet:Range(cRange):Value = "TIPO PROV".
    cRange = "F1".
    chWorkSheet:Range(cRange):Value = "FAX".
    cRange = "G1".
    chWorkSheet:Range(cRange):Value = "REFERENCIAS".
    cRange = "H1".
    chWorkSheet:Range(cRange):Value = "GIRO".
    cRange = "I1".
    chWorkSheet:Range(cRange):Value = "COND.COMPRA".
    cRange = "J1".
    chWorkSheet:Range(cRange):Value = "CONTACTOS".
    cRange = "K1".
    chWorkSheet:Range(cRange):Value = "REP. LEGAL".
    cRange = "L1".
    chWorkSheet:Range(cRange):Value = "TELEFONOS".
    cRange = "M1".
    chWorkSheet:Range(cRange):Value = "E-MAIL".
    cRange = "N1".
    chWorkSheet:Range(cRange):Value = "TIEMPO ENTRGA".
    cRange = "O1".
    chWorkSheet:Range(cRange):Value = "LOCAL".
    cRange = "P1".
    chWorkSheet:Range(cRange):Value = "CLASIFIC.".
    cRange = "Q1".
    chWorkSheet:Range(cRange):Value = "FECHA CREAC.".
    cRange = "R1".
    chWorkSheet:Range(cRange):Value = "AP. PATERNO".
    cRange = "S1".
    chWorkSheet:Range(cRange):Value = "AP. MATERNO".
    cRange = "T1".
    chWorkSheet:Range(cRange):Value = "NOMBRES".

iColumn = 2.

FOR EACH tt-gn-prov NO-LOCK:
    cRange = "A" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-prov.CodPro.
    cRange = "B" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-prov.NomPro.
    cRange = "C" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-gn-prov.DirPro.
    cRange = "D" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-prov.Ruc.                                            
    cRange = "E" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-prov.TpoPro.
    cRange = "F" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-prov.FaxPro.
    cRange = "G" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-prov.Referencias.                                       
    cRange = "H" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-prov.Girpro.
    cRange = "I" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-prov.CndCmp.
    cRange = "J" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-prov.Contactos[1] + " " + tt-gn-prov.Contactos[2] + " " + tt-gn-prov.Contactos[3].
    cRange = "K" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-prov.RepLegal.
    cRange = "L" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-prov.Telfnos[1] + " " + tt-gn-prov.Telfnos[2] + " " + tt-gn-prov.Telfnos[3].
    cRange = "M" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-prov.E-Mail.
    cRange = "N" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + string(tt-gn-prov.TpoEnt).
    cRange = "O" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-prov.LocPro.
    cRange = "P" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = "'" + tt-gn-prov.clfpro.
    cRange = "Q" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-gn-prov.Fching.
    cRange = "R" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-gn-prov.ApePat.
    cRange = "S" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-gn-prov.ApeMat.
    cRange = "T" + STRING(iColumn).
    chWorkSheet:Range(cRange):Value = tt-gn-prov.Nombre.

    iColumn = iColumn + 1.
END.

    chWorkSheet:SaveAs(lArchivoSalida).
        chExcelApplication:DisplayAlerts = False.
        chExcelApplication:Quit().


        /* release com-handles */
        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.

        MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga_proveedores_todos W-Win 
PROCEDURE carga_proveedores_todos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{adm\w-generacion-data-proveedores.i &tabla="gn-prov"}.

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
  DISPLAY RADIO-quienes-1 ChkBoxTodos optgrp-cuales optgrp-donde FILL-IN-filetxt 
          txtAlmacenes FILL-IN-msg 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RADIO-quienes-1 ChkBoxTodos optgrp-cuales BUTTON-1 txtAlmacenes 
         BUTTON-procesar BUTTON-salir 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa W-Win 
PROCEDURE procesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lRutaFile AS CHARACTER.
    DEFINE VAR rpta AS LOGICAL.
    DEFINE VAR x-Archivo AS CHARACTER.

    DEFINE VAR lFilter AS CHAR.
    /*lFilter = IF (optgrp-donde = 1) THEN "'Excel (*.XLS)' '*.XLS'" ELSE "'Texto (*.TXT)' '*.TXT'".*/

    /*
        En donde alojo el archvio procesado
    */
    IF optgrp-donde = 1 THEN DO:
        SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS 'Excel (*.XLS)' '*.XLS'
            ASK-OVERWRITE
            CREATE-TEST-FILE
            DEFAULT-EXTENSION IF(optgrp-donde = 1) THEN ".XLS" ELSE ".TXT"
            RETURN-TO-START-DIR
            SAVE-AS
            TITLE 'Exportar a ' + IF(optgrp-donde = 1) THEN "XLS" ELSE "TXT"
            UPDATE rpta.
    END.
    ELSE DO:
        SYSTEM-DIALOG GET-FILE x-Archivo
            FILTERS 'Texto (*.TXT)' '*.TXT'
            ASK-OVERWRITE
            CREATE-TEST-FILE
            DEFAULT-EXTENSION IF(optgrp-donde = 1) THEN ".XLS" ELSE ".TXT"
            RETURN-TO-START-DIR
            SAVE-AS
            TITLE 'Exportar a ' + IF(optgrp-donde = 1) THEN "XLS" ELSE "TXT"
            UPDATE rpta.
    END.

        IF rpta = NO OR x-Archivo = '' THEN RETURN.

        lArchivoSalida = x-Archivo.
        lRutaFile = FILL-IN-filetxt:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

        SESSION:SET-WAIT-STATE('GENERAL').

        FOR EACH tt-almmmatg:
                DELETE tt-almmmatg.
        END.
        FOR EACH tt-gn-clie:
                DELETE tt-gn-clie.
        END.
        FOR EACH tt-gn-prov:
                DELETE tt-gn-prov.
        END.
        FOR EACH tt-txt:
                DELETE tt-txt.
        END.

        IF (ChkBoxTodos = NO) THEN DO:
            /* Cargo el TXT */
            INPUT FROM VALUE(lRutaFile).
            REPEAT:
                CREATE tt-txt.
                IMPORT tt-txt.
            END.                    
            INPUT CLOSE.

            CASE RADIO-quienes-1:SCREEN-VALUE IN FRAME {&FRAME-NAME}:
                WHEN '1' THEN RUN carga_articulos.

                WHEN '2' THEN RUN carga_clientes.

                WHEN '3' THEN RUN carga_proveedores.

                WHEN '4' THEN RUN carga_articulos_precio.

            END CASE.
        END.
        ELSE DO:
            CASE RADIO-quienes-1:SCREEN-VALUE IN FRAME {&FRAME-NAME}:
                WHEN '1' THEN MESSAGE "Opcion Aun no Implementada" .

                WHEN '2' THEN RUN ue_carga_cliente_todos.

                WHEN '3' THEN RUN carga_proveedores_todos .

                WHEN '4' THEN MESSAGE "Opcion TODOS Aun no Implementada" .

            END CASE.
        END.
        SESSION:SET-WAIT-STATE('').
        
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-limpiar-cadena W-Win 
PROCEDURE ue-limpiar-cadena :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT-OUTPUT PARAMETER p-cadena AS CHAR    NO-UNDO.
DEFINE INPUT PARAMETER p-cadena-buscar AS CHAR    NO-UNDO.
DEFINE INPUT PARAMETER p-cadena-nueva AS CHAR    NO-UNDO.

p-cadena = REPLACE(p-cadena,CHR(13)," ").
p-cadena = REPLACE(p-cadena,CHR(10)," ").
p-cadena = REPLACE(p-cadena,CHR(9)," ").
IF p-cadena-buscar <> ? AND p-cadena-buscar <> "" THEN DO:
    p-cadena = REPLACE(p-cadena,p-cadena-buscar,p-cadena-nueva).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue_carga_cliente_todos W-Win 
PROCEDURE ue_carga_cliente_todos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{adm\w-generacion-data-clientes.i &tabla="gn-clie"}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

