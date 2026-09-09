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

/*DEFINE INPUT PARAMETER is-div-sele AS CHAR.*/

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

DEF STREAM REPORTE.
DEF TEMP-TABLE detalle NO-UNDO
    FIELD codmat    AS CHAR 
    FIELD desmat    AS CHAR 
    FIELD codfam    AS CHAR 
    FIELD subfam    AS CHAR 
    FIELD impcot    LIKE facdpedi.implin 
    FIELD tipo      AS CHAR     
    FIELD DesMar    AS CHAR
    FIELD CanPed    AS DEC
    FIELD codcli    AS CHAR
    FIELD nomcli    AS CHAR
    FIELD canfac    AS DEC
    FIELD impfac    AS DEC
    INDEX Llave00 AS PRIMARY codmat codcli
    INDEX Llave01 codcli 
    .

DEF TEMP-TABLE T-Detalle LIKE Detalle.

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
&Scoped-Define ENABLED-OBJECTS BtnDone FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
COMBO-BOX-Lista BUTTON-Preparar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
COMBO-BOX-Lista RADIO-SET-Tipo FILL-IN-Mensaje 

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
     LABEL "&Salir" 
     SIZE 8 BY 1.62 TOOLTIP "Salir"
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-Excel 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 8 BY 1.62.

DEFINE BUTTON BUTTON-LIMPIAR 
     LABEL "LIMPIAR TODO" 
     SIZE 30 BY 1.12.

DEFINE BUTTON BUTTON-Preparar 
     LABEL "PREPARAR INFORMACION" 
     SIZE 30 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Lista AS CHARACTER FORMAT "X(256)":U 
     LABEL "Lista de Precios" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 70 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Tipo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Solo Productos", 1,
"Solo Clientes", 2
     SIZE 20 BY 3 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BtnDone AT ROW 1.27 COL 71 WIDGET-ID 10
     FILL-IN-Fecha-1 AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-Fecha-2 AT ROW 1.54 COL 43 COLON-ALIGNED WIDGET-ID 6
     COMBO-BOX-Lista AT ROW 2.88 COL 19 COLON-ALIGNED WIDGET-ID 22
     BUTTON-Preparar AT ROW 4.23 COL 21 WIDGET-ID 24
     BUTTON-LIMPIAR AT ROW 5.58 COL 21 WIDGET-ID 26
     RADIO-SET-Tipo AT ROW 7.19 COL 21 NO-LABEL WIDGET-ID 28
     BUTTON-Excel AT ROW 7.73 COL 46 WIDGET-ID 8
     FILL-IN-Mensaje AT ROW 10.69 COL 11 NO-LABEL WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 11.19 WIDGET-ID 100.


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
         TITLE              = "ESTADISTICAS DE PEDIDOS COMERCIALES"
         HEIGHT             = 11.19
         WIDTH              = 90.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 108.29
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 108.29
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
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR BUTTON BUTTON-Excel IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-LIMPIAR IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR RADIO-SET RADIO-SET-Tipo IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ESTADISTICAS DE PEDIDOS COMERCIALES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ESTADISTICAS DE PEDIDOS COMERCIALES */
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
ON CHOOSE OF BtnDone IN FRAME F-Main /* Salir */
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


&Scoped-define SELF-NAME BUTTON-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Excel W-Win
ON CHOOSE OF BUTTON-Excel IN FRAME F-Main /* Button 2 */
DO:
  ASSIGN RADIO-SET-Tipo.
  CASE RADIO-SET-Tipo:
      WHEN 1 THEN RUN Excel-1.
      WHEN 2 THEN RUN Excel-2.
  END CASE.
  /*RUN Excel.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-LIMPIAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-LIMPIAR W-Win
ON CHOOSE OF BUTTON-LIMPIAR IN FRAME F-Main /* LIMPIAR TODO */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      ENABLE BUTTON-Preparar COMBO-BOX-Lista FILL-IN-Fecha-1.
      DISABLE BUTTON-Excel BUTTON-LIMPIAR RADIO-SET-Tipo.
      FILL-IN-Mensaje:SCREEN-VALUE = ''.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Preparar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Preparar W-Win
ON CHOOSE OF BUTTON-Preparar IN FRAME F-Main /* PREPARAR INFORMACION */
DO:
  ASSIGN COMBO-BOX-Lista FILL-IN-Fecha-1 FILL-IN-Fecha-2.
  /* Cargamos la informacion al temporal */
  EMPTY TEMP-TABLE Detalle.
  RUN Carga-Temporal.
  DISABLE COMBO-BOX-Lista FILL-IN-Fecha-1 FILL-IN-Fecha-2 BUTTON-Preparar WITH FRAME {&FRAME-NAME}.
  ENABLE BUTTON-Excel BUTTON-LIMPIAR RADIO-SET-Tipo WITH FRAME {&FRAME-NAME}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-NomPro LIKE gn-prov.nompro NO-UNDO.
DEF VAR x-NomVen LIKE gn-ven.nomven NO-UNDO.

EMPTY TEMP-TABLE Detalle.

ESTADISTICAS:
FOR EACH faccpedi NO-LOCK WHERE faccpedi.codcia = s-codcia
    AND faccpedi.coddiv = s-coddiv
    AND faccpedi.coddoc = 'COT'
    AND faccpedi.fchped >= FILL-IN-Fecha-1
    AND faccpedi.fchped <= FILL-IN-Fecha-2
    AND FacCPedi.Libre_C01 = COMBO-BOX-Lista,
    FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = faccpedi.codcli:
    IF Faccpedi.flgest = "A" OR Faccpedi.flgest = "W" THEN NEXT.
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** RESUMIENDO ** " + "COTIZACION " + faccpedi.nroped.
    FOR EACH facdpedi OF Faccpedi NO-LOCK, 
        FIRST Almmmatg OF Facdpedi NO-LOCK, 
        FIRST Almtfami OF Almmmatg NO-LOCK,
        FIRST Almsfami OF Almmmatg NO-LOCK:
        FIND FIRST detalle WHERE detalle.codmat = facdpedi.codmat AND
            detalle.codcli = gn-clie.codcli EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE detalle THEN CREATE detalle.
        ASSIGN
            detalle.codmat = facdpedi.codmat
            detalle.desmat = facdpedi.codmat + ' '  + almmmatg.desmat
            detalle.codfam = almmmatg.codfam + ' ' + almtfami.desfam
            detalle.subfam = almmmatg.subfam + ' ' + almsfami.dessub
            detalle.desmar = almmmatg.desmar
            detalle.canped = detalle.canped + facdpedi.canped
            detalle.codcli = gn-clie.codcli
            detalle.nomcli = gn-clie.codcli + ' '  + gn-clie.nomcli
            .
        ASSIGN
            detalle.impcot = detalle.impcot + facdpedi.implin.
        CASE Almmmatg.CodFam:
            WHEN "011" THEN Detalle.Tipo = "FOTOCOPIAS".
            WHEN "010" OR WHEN "012" OR WHEN "013" THEN Detalle.Tipo = "PROPIOS".
            OTHERWISE Detalle.Tipo = "TERCEROS".
        END CASE.
    END.
END.
/* Cargamos estadísticos de ventas */
DEF VAR x-FchDoc-1 AS DATE NO-UNDO.
DEF VAR x-FchDoc-2 AS DATE NO-UNDO.

/* del año pasado */
EMPTY TEMP-TABLE T-Detalle.
ASSIGN
    x-FchDoc-1 = DATE(01,01,YEAR(TODAY) - 1)
    x-FchDoc-2 = DATE(12,31,YEAR(TODAY) - 1).
FOR EACH Detalle NO-LOCK BREAK BY Detalle.CodCli:
    IF FIRST-OF(Detalle.CodCli) THEN DO:
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** VENTAS ** " + Detalle.CodCli.
        FOR EACH VtaTabla NO-LOCK WHERE VtaTabla.CodCia = s-codcia AND 
                VtaTabla.Tabla = 'EXPOVTAHIST' AND
                VtaTabla.Llave_c1 = COMBO-BOX-Lista AND
                VtaTabla.Llave_c2 = Detalle.CodCli AND
                VtaTabla.Rango_fecha[1] >= x-FchDoc-1 AND VtaTabla.Rango_fecha[1] <= x-FchDoc-2,
            FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = VtaTabla.Llave_c2,
            FIRST Almmmatg NO-LOCK WHERE Almmmatg.CodCia = s-codcia AND
                Almmmatg.codmat = VtaTabla.Llave_c3,
            FIRST Almtfami OF Almmmatg NO-LOCK,
            FIRST Almsfami OF Almmmatg NO-LOCK:
            CREATE T-Detalle.
            ASSIGN
                T-Detalle.codmat = VtaTabla.Llave_c3
                T-Detalle.desmat = almmmatg.codmat + ' '  + almmmatg.desmat
                T-Detalle.codfam = almmmatg.codfam + ' ' + almtfami.desfam
                T-Detalle.subfam = almmmatg.subfam + ' ' + almsfami.dessub
                T-Detalle.desmar = almmmatg.desmar
                T-Detalle.canfac = VtaTabla.Valor[1] 
                T-Detalle.codcli = VtaTabla.Llave_c2
                T-Detalle.nomcli = gn-clie.codcli + ' '  + gn-clie.nomcli
                .
            ASSIGN
                T-Detalle.impfac = VtaTabla.Valor[2].
            CASE Almmmatg.CodFam:
                WHEN "011" THEN T-Detalle.Tipo = "FOTOCOPIAS".
                WHEN "010" OR WHEN "012" OR WHEN "013" THEN T-Detalle.Tipo = "PROPIOS".
                OTHERWISE T-Detalle.Tipo = "TERCEROS".
            END CASE.

/*             FIND FIRST detalle WHERE detalle.codmat = VtaTabla.Llave_c3 AND           */
/*                 detalle.codcli = VtaTabla.Llave_c2                                    */
/*                 EXCLUSIVE-LOCK NO-ERROR.                                              */
/*             IF NOT AVAILABLE detalle THEN CREATE detalle.                             */
/*             ASSIGN                                                                    */
/*                 detalle.codmat = VtaTabla.Llave_c3                                    */
/*                 detalle.desmat = almmmatg.codmat + ' '  + almmmatg.desmat             */
/*                 detalle.codfam = almmmatg.codfam + ' ' + almtfami.desfam              */
/*                 detalle.subfam = almmmatg.subfam + ' ' + almsfami.dessub              */
/*                 detalle.desmar = almmmatg.desmar                                      */
/*                 detalle.canfac = detalle.canfac + VtaTabla.Valor[1]                   */
/*                 detalle.codcli = VtaTabla.Llave_c2                                    */
/*                 detalle.nomcli = gn-clie.codcli + ' '  + gn-clie.nomcli               */
/*                 .                                                                     */
/*             ASSIGN                                                                    */
/*                 detalle.impfac = detalle.impfac + VtaTabla.Valor[2].                  */
/*             CASE Almmmatg.CodFam:                                                     */
/*                 WHEN "011" THEN Detalle.Tipo = "FOTOCOPIAS".                          */
/*                 WHEN "010" OR WHEN "012" OR WHEN "013" THEN Detalle.Tipo = "PROPIOS". */
/*                 OTHERWISE Detalle.Tipo = "TERCEROS".                                  */
/*             END CASE.                                                                 */

        END.
    END.
END.
FOR EACH T-Detalle NO-LOCK:
    FIND FIRST Detalle WHERE Detalle.CodMat = T-Detalle.CodMat AND
        Detalle.CodCli = T-Detalle.CodCli EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        CREATE Detalle.
        BUFFER-COPY T-Detalle TO Detalle.
    END.
    ELSE DO:
        ASSIGN
            Detalle.CanFac = Detalle.CanFac + T-Detalle.CanFac
            Detalle.ImpFac = Detalle.ImpFac + T-Detalle.ImpFac.
    END.
END.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** INFORMACION LISTA **".
RETURN "OK".

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
  DISPLAY FILL-IN-Fecha-1 FILL-IN-Fecha-2 COMBO-BOX-Lista RADIO-SET-Tipo 
          FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BtnDone FILL-IN-Fecha-1 FILL-IN-Fecha-2 COMBO-BOX-Lista 
         BUTTON-Preparar 
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
DEF VAR x-Llave AS CHAR FORMAT 'x(800)' NO-UNDO.
DEF VAR x-Titulo AS CHAR FORMAT 'x(800)' NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.

/* Archivo de Salida */
DEF VAR c-csv-file AS CHAR NO-UNDO.
DEF VAR c-xls-file AS CHAR INIT 'Formato 001' NO-UNDO.
DEF VAR rpta AS LOG INIT NO NO-UNDO.

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


DEF VAR lFileXls AS CHAR NO-UNDO.
DEF VAR lNuevoFile AS LOG NO-UNDO.


GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta'  VALUE lFileXls.
lFileXls = lFileXls + 'plantilla_expolibreria.xltx'.
FILE-INFO:FILE-NAME = lFileXls.
IF FILE-INFO:FULL-PATHNAME EQ ? THEN DO:
    MESSAGE 'La plantilla ' lFileXls SKIP 'NO existe' VIEW-AS ALERT-BOX.
    RETURN.
END.

SESSION:SET-WAIT-STATE('GENERAL').
/* Cargamos la informacion al temporal */
EMPTY TEMP-TABLE Detalle.
RUN Carga-Temporal.
/* Programas que generan el Excel */
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".

lNuevoFile = NO.    /* Abre la plantilla lFileXls */
{lib/excel-open-file.i}
/* ******************************************************************************** */
/* LOGICA PRINCIPAL: CARGA DEL EXCEL */
/* ******************************************************************************** */
/* Select a worksheet */
chWorkbook:Worksheets(1):Activate.
chWorksheet = chWorkbook:Worksheets(1).

iRow = 1.
FOR EACH Detalle NO-LOCK BREAK BY Detalle.codmat:
    IF FIRST-OF(Detalle.CodMat) THEN DO:
        IF iRow >= 100 AND (iRow MODULO 100 = 0) THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL ** " + Detalle.CodMat.
    END.
    iRow = iRow + 1.
    cColumn = STRING(iRow).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CodMat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.DesMat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CodFam.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.SubFam.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.Tipo.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.ImpCot.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.DesMar.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CanPed.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.NomCli.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.ImpFac.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CanFac.
END.
/* ******************************************************************************** */
/* ******************************************************************************** */
SESSION:SET-WAIT-STATE('').

lNuevoFile = YES.           /* Graba la plantilla en el nuevo archivo */
lFileXls = c-xls-file.
lCerrarAlTerminar = NO.     /* Se hace visible al terminar */
lMensajeAlTerminar = YES.   /* Aviso que terminó el proceso */
{lib/excel-close-file.i}
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** FIN DEL PROCESO **".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-1 W-Win 
PROCEDURE Excel-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Llave AS CHAR FORMAT 'x(800)' NO-UNDO.
DEF VAR x-Titulo AS CHAR FORMAT 'x(800)' NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.

/* Archivo de Salida */
DEF VAR c-csv-file AS CHAR NO-UNDO.
DEF VAR c-xls-file AS CHAR INIT 'Formato001a' NO-UNDO.
DEF VAR rpta AS LOG INIT NO NO-UNDO.

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


DEF VAR lFileXls AS CHAR NO-UNDO.
DEF VAR lNuevoFile AS LOG NO-UNDO.


GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta'  VALUE lFileXls.
lFileXls = lFileXls + 'plantilla_expolibreria_001a.xltx'.
FILE-INFO:FILE-NAME = lFileXls.
IF FILE-INFO:FULL-PATHNAME EQ ? THEN DO:
    MESSAGE 'La plantilla ' lFileXls SKIP 'NO existe' VIEW-AS ALERT-BOX.
    RETURN.
END.

SESSION:SET-WAIT-STATE('GENERAL').
/* Cargamos la informacion al temporal */
EMPTY TEMP-TABLE T-Detalle.
FOR EACH Detalle NO-LOCK:
    FIND T-Detalle WHERE T-Detalle.codmat = Detalle.codmat EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE T-Detalle THEN DO:
        CREATE T-Detalle.
        BUFFER-COPY Detalle TO T-Detalle.
    END.
    ELSE DO:
        ASSIGN
            T-Detalle.canped = T-Detalle.canped + Detalle.canped
            T-Detalle.impcot = T-Detalle.impcot + Detalle.impcot.
    END.
END.
/* Programas que generan el Excel */
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".

lNuevoFile = NO.    /* Abre la plantilla lFileXls */
{lib/excel-open-file.i}
/* ******************************************************************************** */
/* LOGICA PRINCIPAL: CARGA DEL EXCEL */
/* ******************************************************************************** */
/* Select a worksheet */
chWorkbook:Worksheets(1):Activate.
chWorksheet = chWorkbook:Worksheets(1).

iRow = 1.
FOR EACH T-Detalle NO-LOCK BREAK BY T-Detalle.codmat:
    IF FIRST-OF(T-Detalle.CodMat) THEN DO:
        IF iRow >= 100 AND (iRow MODULO 100 = 0) THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL ** " + T-Detalle.CodMat.
    END.
    iRow = iRow + 1.
    cColumn = STRING(iRow).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Detalle.CodMat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Detalle.DesMat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Detalle.CodFam.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Detalle.SubFam.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Detalle.Tipo.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Detalle.ImpCot.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Detalle.DesMar.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Detalle.CanPed.
END.
/* ******************************************************************************** */
/* ******************************************************************************** */
SESSION:SET-WAIT-STATE('').

lNuevoFile = YES.           /* Graba la plantilla en el nuevo archivo */
lFileXls = c-xls-file.
lCerrarAlTerminar = NO.     /* Se hace visible al terminar */
lMensajeAlTerminar = YES.   /* Aviso que terminó el proceso */
{lib/excel-close-file.i}
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** FIN DEL PROCESO **".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-2 W-Win 
PROCEDURE Excel-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Llave AS CHAR FORMAT 'x(800)' NO-UNDO.
DEF VAR x-Titulo AS CHAR FORMAT 'x(800)' NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.

/* Archivo de Salida */
DEF VAR c-csv-file AS CHAR NO-UNDO.
DEF VAR c-xls-file AS CHAR INIT 'Formato001b' NO-UNDO.
DEF VAR rpta AS LOG INIT NO NO-UNDO.

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


DEF VAR lFileXls AS CHAR NO-UNDO.
DEF VAR lNuevoFile AS LOG NO-UNDO.


GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta'  VALUE lFileXls.
lFileXls = lFileXls + 'plantilla_expolibreria_001b.xltx'.
FILE-INFO:FILE-NAME = lFileXls.
IF FILE-INFO:FULL-PATHNAME EQ ? THEN DO:
    MESSAGE 'La plantilla ' lFileXls SKIP 'NO existe' VIEW-AS ALERT-BOX.
    RETURN.
END.

SESSION:SET-WAIT-STATE('GENERAL').
/* Cargamos la informacion al temporal */
EMPTY TEMP-TABLE T-Detalle.
FOR EACH Detalle NO-LOCK:
    FIND T-Detalle WHERE T-Detalle.codcli = Detalle.codcli AND
        T-Detalle.tipo = Detalle.tipo EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE T-Detalle THEN DO:
        CREATE T-Detalle.
        BUFFER-COPY Detalle TO T-Detalle.
    END.
    ELSE DO:
        ASSIGN
            T-Detalle.impfac = T-Detalle.impfac + Detalle.impfac
            T-Detalle.impcot = T-Detalle.impcot + Detalle.impcot.
    END.
END.
/* Programas que generan el Excel */
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".

lNuevoFile = NO.    /* Abre la plantilla lFileXls */
{lib/excel-open-file.i}
/* ******************************************************************************** */
/* LOGICA PRINCIPAL: CARGA DEL EXCEL */
/* ******************************************************************************** */
/* Select a worksheet */
chWorkbook:Worksheets(1):Activate.
chWorksheet = chWorkbook:Worksheets(1).

iRow = 1.
FOR EACH T-Detalle NO-LOCK BREAK BY T-Detalle.codcli:
    IF FIRST-OF(T-Detalle.CodCli) THEN DO:
        IF iRow >= 100 AND (iRow MODULO 100 = 0) THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL ** " + T-Detalle.CodCli.
    END.
    iRow = iRow + 1.
    cColumn = STRING(iRow).
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Detalle.Tipo.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Detalle.ImpCot.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Detalle.NomCli.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = T-Detalle.ImpFac.
END.
/* ******************************************************************************** */
/* ******************************************************************************** */
SESSION:SET-WAIT-STATE('').

lNuevoFile = YES.           /* Graba la plantilla en el nuevo archivo */
lFileXls = c-xls-file.
lCerrarAlTerminar = NO.     /* Se hace visible al terminar */
lMensajeAlTerminar = YES.   /* Aviso que terminó el proceso */
{lib/excel-close-file.i}
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** FIN DEL PROCESO **".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable W-Win 
PROCEDURE local-disable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable':U ) .

  /* Code placed here will execute AFTER standard behavior.    */



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable W-Win 
PROCEDURE local-enable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  ASSIGN
      FILL-IN-Fecha-1 = TODAY
      FILL-IN-Fecha-2 = TODAY.     

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND
      (gn-divi.campo-char[1] = 'L' OR gn-divi.campo-char[1] = 'A' ) AND
      gn-divi.campo-log[1] = NO
      WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Lista:ADD-LAST(gn-divi.coddiv, '999999') NO-ERROR.
  END.
  COMBO-BOX-Lista:SCREEN-VALUE IN FRAME {&FRAME-NAME} = s-coddiv.

  ENABLE COMBO-BOX-Lista WITH FRAME {&FRAME-NAME}.
  /*
  IF is-div-sele = 'X' THEN DO:
        /*COMBO-BOX-Lista:ENABLED IN FRAME {&FRAME-NAME} = NO .   */
      DISABLE COMBO-BOX-Lista WITH FRAME {&FRAME-NAME}.
  END.
  ELSE DO:
      /*COMBO-BOX-Lista:ENABLED IN FRAME {&FRAME-NAME} = YES .*/
      ENABLE COMBO-BOX-Lista WITH FRAME {&FRAME-NAME}.
  END.
  */
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

