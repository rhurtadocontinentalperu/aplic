&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-MOV-MES FOR PL-MOV-MES.



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

DEFINE VARIABLE db-work AS CHARACTER NO-UNDO.
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-periodo AS INT.
DEFINE SHARED VAR s-nromes AS INT.


DEFINE TEMP-TABLE tt-datos
    FIELDS t-codper LIKE pl-pers.codper
    FIELDS t-nombre AS CHAR
    FIELDS t-fching AS DATE
    FIELDS t-toting AS DEC
    FIELDS t-totdsc AS DEC
    FIELDS t-ccosto AS CHAR
    FIELDS t-totvvv AS DEC EXTENT 40
    FIELDS t-totvvo AS DEC EXTENT 40
    FIELDS t-ccto   AS CHAR FORMAT "99"
    FIELD  t-cargos LIKE pl-flg-mes.cargos
    FIELD  t-clase  LIKE pl-flg-mes.clase.

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
&Scoped-Define ENABLED-OBJECTS x-periodo cb-mes x-codper BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS x-periodo cb-mes x-codper x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 6.86 BY 1.62.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 2" 
     SIZE 7 BY 1.62.

DEFINE VARIABLE cb-mes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Enero",01,
                     "Febrero",02,
                     "Marzo",03,
                     "Abril",04,
                     "Mayo",05,
                     "Junio",06,
                     "Julio",07,
                     "Agosto",08,
                     "Setiembre",09,
                     "Octubre",10,
                     "Noviembre",11,
                     "Diciembre",12
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE x-codper AS CHARACTER FORMAT "X(256)":U 
     LABEL "Codigo del Personal" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .85 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61.29 BY .85
     FONT 1 NO-UNDO.

DEFINE VARIABLE x-periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-periodo AT ROW 2.08 COL 15 COLON-ALIGNED WIDGET-ID 12
     cb-mes AT ROW 3.15 COL 15 COLON-ALIGNED WIDGET-ID 16
     x-codper AT ROW 4.23 COL 15 COLON-ALIGNED WIDGET-ID 10
     x-mensaje AT ROW 5.58 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     BUTTON-1 AT ROW 6.65 COL 49 WIDGET-ID 2
     BUTTON-2 AT ROW 6.65 COL 56 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 67.29 BY 7.85
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-MOV-MES B "?" ? INTEGRAL PL-MOV-MES
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "REPORTE DE REMUNERACIONES"
         HEIGHT             = 7.85
         WIDTH              = 67.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE REMUNERACIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE REMUNERACIONES */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN
        x-periodo
        cb-mes
        X-CODPER.
    RUN excel2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF  
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
  DISPLAY x-periodo cb-mes x-codper x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-periodo cb-mes x-codper BUTTON-1 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel2 W-Win 
PROCEDURE Excel2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cNomAux AS CHARACTER NO-UNDO.
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iCountReg          AS INTEGER NO-UNDO.

    DEFINE VARIABLE dTotIng   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dTotOtr   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dTotDscto AS DECIMAL     NO-UNDO.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* set the column names for the Worksheet */
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "REPORTE DE EMPLEADOS " + cb-mes:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "SECCION".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "CÓDIGO".


    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "APELLIDOS Y NOMBRES".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "FCH ING".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "DIAS TRAB".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "SUELDO".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "ASIG FAM".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "BONIF ESP".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "COMISION".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "CONDICIÓN DE TRABAJO - MOVILIDAD".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "REMUNER.VACACIONES".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "REMUNER.VACACIONES TRABAJADAS".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "REMUNER.VACACIONES TRUNCAS".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "COND.TRABAJO - MOVLIDAD VARIABLE".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "PRESTACIONES ALIMENTARIAS".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "TRANSPORTE".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = "ASIGNACION POR REFRIGERIO".
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = "CENA CONDICIÓN DE TRABAJO".
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = "REEMB. REFRIG Y MOVILIDAD".
    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Value = "ALIMENTACIÓN PRINCIPAL".
    cRange = "U" + cColumn.
    chWorkSheet:Range(cRange):Value = "SUBSIDIO POR INCAPACIDAD TEMPORAL".
    cRange = "V" + cColumn.
    chWorkSheet:Range(cRange):Value = "SUBSIDIO ESSALUD".
    cRange = "W" + cColumn.
    chWorkSheet:Range(cRange):Value = "HORAS EXTRAS 25 %".
    cRange = "X" + cColumn.
    chWorkSheet:Range(cRange):Value = "TRABAJO EN FERIADO Y/O DESCANSO".
    cRange = "Y" + cColumn.
    chWorkSheet:Range(cRange):Value = "HORAS EXTRAS 35%".
    cRange = "Z" + cColumn.
    chWorkSheet:Range(cRange):Value = "OTROS INGRESOS".
    cRange = "AA" + cColumn.
    chWorkSheet:Range(cRange):Value = "BONIFICACION POR INCENTIVO".
    cRange = "AB" + cColumn.
    chWorkSheet:Range(cRange):Value = "AGUINALDO".
    cRange = "AC" + cColumn.
    chWorkSheet:Range(cRange):Value = "REINTEGRO".
    cRange = "AD" + cColumn.
    chWorkSheet:Range(cRange):Value = "PARTICIPACION UTILIDADES".
    cRange = "AE" + cColumn.
    chWorkSheet:Range(cRange):Value = "ASIGNACION EXTRAORDINARIA".
    cRange = "AF" + cColumn.
    chWorkSheet:Range(cRange):Value = "GRATIFICACION TRUNCA".
    cRange = "AG" + cColumn.
    chWorkSheet:Range(cRange):Value = "AFP 10.23%".
    cRange = "AH" + cColumn.
    chWorkSheet:Range(cRange):Value = "AFP 3.00 %".
    cRange = "AI" + cColumn.
    chWorkSheet:Range(cRange):Value = "RIESGO DE CAJA".
    cRange = "AJ" + cColumn.
    chWorkSheet:Range(cRange):Value = "GRATIFICACIONES EXTRAORDINARIAS".
    cRange = "AK" + cColumn.
    chWorkSheet:Range(cRange):Value = "BONIFICACION POR PRODUCCION".
    cRange = "AL" + cColumn.
    chWorkSheet:Range(cRange):Value = "BONIFICACIÓN NOCTURNA".
    cRange = "AM" + cColumn.
    chWorkSheet:Range(cRange):Value = "SUBSIDIO PRE-NATAL Y POST-NATAL".
    cRange = "AN" + cColumn.
    chWorkSheet:Range(cRange):Value = "CANASTA NAVIDEÑA".
    cRange = "AO" + cColumn.
    chWorkSheet:Range(cRange):Value = "ASIGNACION POR FALLECIMIENTO".
    /********/
    cRange = "AP" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL ING".

    cRange = "AQ" + cColumn.
    chWorkSheet:Range(cRange):Value = "SNP".
    cRange = "AR" + cColumn.
    chWorkSheet:Range(cRange):Value = "A.F.P".
    cRange = "AS" + cColumn.
    chWorkSheet:Range(cRange):Value = "QUINTA".
    cRange = "AT" + cColumn.
    chWorkSheet:Range(cRange):Value = "CTA CTE.".
    cRange = "AU" + cColumn.
    chWorkSheet:Range(cRange):Value = "ADEL QUIN".
    cRange = "AV" + cColumn.
    chWorkSheet:Range(cRange):Value = "TARDANZAS/PERMISOS".
    cRange = "AW" + cColumn.
    chWorkSheet:Range(cRange):Value = "INASISTENCIAS".
    cRange = "AX" + cColumn.
    chWorkSheet:Range(cRange):Value = "LICENCIA SIN GOCE DE HABER".
    cRange = "AY" + cColumn.
    chWorkSheet:Range(cRange):Value = "SEGURO PRIVADO DE SALUD".
    cRange = "AZ" + cColumn.
    chWorkSheet:Range(cRange):Value = "MANDATO JUDICIAL".

    cRange = "BA" + cColumn.
    chWorkSheet:Range(cRange):Value = "OTROS".
    cRange = "BB" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL DESCTO".
    cRange = "BC" + cColumn.
    chWorkSheet:Range(cRange):Value = "TOTAL NETO".
    cRange = "BD" + cColumn.
    chWorkSheet:Range(cRange):Value = "ESSALUD".
    cRange = "BE" + cColumn.
    chWorkSheet:Range(cRange):Value = "SENATI".
    cRange = "BF" + cColumn.
    chWorkSheet:Range(cRange):Value = "CENTRO DE COSTO".
    cRange = "BG" + cColumn.
    chWorkSheet:Range(cRange):Value = "CARGO".
    cRange = "BH" + cColumn.
    chWorkSheet:Range(cRange):Value = "CLASE".
    /* RHC 19/04/17 Alex Quiroz */
    cRange = "BI" + cColumn.
    chWorkSheet:Range(cRange):Value = "HHEE 25%".
    cRange = "BJ" + cColumn.
    chWorkSheet:Range(cRange):Value = "HHEE 35%".
    cRange = "BK" + cColumn.
    chWorkSheet:Range(cRange):Value = "HHEE 100%".
    /* RHC 31/07/2017 Alex Quiroz */
    cRange = "BL" + cColumn.
    chWorkSheet:Range(cRange):Value = "SUELDO BASICO".

    chWorkSheet:Columns("A"):NumberFormat = "@".
    chWorkSheet:Columns("B"):NumberFormat = "@".
    
    EMPTY TEMP-TABLE tt-datos.

    FOR EACH pl-mov-mes WHERE pl-mov-mes.codcia = s-codcia
        AND pl-mov-mes.periodo = x-periodo
        AND pl-mov-mes.nromes  = cb-mes
        AND pl-mov-mes.codpln  = 01
        AND pl-mov-mes.codcal  = 001
        AND pl-mov-mes.codper  BEGINS x-codper NO-LOCK,
        FIRST pl-pers WHERE pl-pers.codcia = pl-mov-mes.codcia
            AND pl-pers.codper = pl-mov-mes.codper NO-LOCK:

        FIND FIRST tt-datos WHERE t-codper = pl-mov-mes.codper NO-ERROR.
        IF NOT AVAIL tt-datos THEN DO:
            FIND pl-flg-mes WHERE pl-flg-mes.codcia = s-codcia
                AND pl-flg-mes.codper = pl-pers.codper
                AND pl-flg-mes.periodo = pl-mov-mes.periodo
                AND pl-flg-mes.nromes  = pl-mov-mes.nromes
                AND pl-mov-mes.codpln  = pl-mov-mes.codpln NO-LOCK NO-ERROR.        
            CREATE tt-datos.
            ASSIGN 
                t-codper = pl-pers.codper
                t-nombre = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.
            IF AVAIL pl-flg-mes  THEN 
                ASSIGN 
                    t-fching = PL-FLG-MES.fecing
                    t-ccosto = PL-FLG-MES.seccion
                    t-ccto   = pl-flg-mes.ccosto
                    t-clase  = pl-flg-mes.clase
                    t-cargos = pl-flg-mes.cargos.

            /*Busca CCosto*/
            FIND FIRST cb-tabl WHERE cb-tabl.Codigo = 'CCO' NO-LOCK NO-ERROR.
            IF AVAIL cb-tabl THEN DO:
                FIND FIRST cb-auxi WHERE cb-auxi.CodCia = 0
                    AND cb-auxi.clfaux = cb-tabl.codigo
                    AND cb-auxi.Codaux = pl-flg-mes.ccosto NO-LOCK NO-ERROR.
                IF AVAIL cb-auxi THEN t-ccto = cb-auxi.Codaux + "-" + cb-auxi.Nomaux.
            END.


        END.

        {pln/r-repremunera.i}

        DISPLAY
            t-codper + "-" + t-nombre @ x-mensaje WITH FRAME {&FRAME-NAME}. 
        PAUSE 0.        
    END.
    FOR EACH TT-DATOS  NO-LOCK BREAK BY t-ccosto BY T-CODPER:
        dTotOtr   = t-totvvo[01] + t-totvvo[02] + t-totvvo[03] + t-totvvo[04] + t-totvvo[05] + 
                    t-totvvo[06] + t-totvvo[07] + t-totvvo[08] + t-totvvo[09] + t-totvvo[10] + 
                    t-totvvo[11] + t-totvvo[12] + t-totvvo[13] + t-totvvo[14] + t-totvvo[15] + 
                    t-totvvo[16] + t-totvvo[17] + t-totvvo[18] + t-totvvo[19] + t-totvvo[20] + 
                    t-totvvo[21] + t-totvvo[22] + t-totvvo[23] + t-totvvo[24] + t-totvvo[25] + 
                    t-totvvo[26] + t-totvvo[27] + t-totvvo[28] + t-totvvo[29] + t-totvvo[30] +
                    t-totvvo[31] + t-totvvo[32].
        dTotIng   = t-totvvv[16] + t-totvvv[17] + t-totvvv[18] + t-totvvv[19] + t-totvvv[20] + dTotOtr.
        dTotDscto = t-totvvv[21] + t-totvvv[22] + t-totvvv[23] + t-totvvv[24] + t-totvvv[25] + t-totvvv[26] +
            t-totvvv[32] + t-totvvv[33] + t-totvvv[34] + t-totvvv[35] + t-totvvv[36].

        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = t-ccosto.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = t-codper.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = t-nombre.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = t-fching.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvv[15].
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvv[16].
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvv[17].
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvv[19].
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvv[20].
        /*******/
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[01].
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[02].
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[03].
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[04].
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[05].
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[06].
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[07].
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[08].
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[09].
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[10].
        cRange = "T" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[11].
        cRange = "U" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[12].
        cRange = "V" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[13].
        cRange = "W" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[14].
        cRange = "X" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[15].
        cRange = "Y" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[16].
        cRange = "Z" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[17].
        cRange = "AA" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[18].
        cRange = "AB" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[19].
        cRange = "AC" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[20].
        cRange = "AD" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[21].
        cRange = "AE" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[22].
        cRange = "AF" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[23].
        cRange = "AG" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[24].
        cRange = "AH" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[25].
        cRange = "AI" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[26].
        cRange = "AJ" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[27].
        cRange = "AK" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[28].
        cRange = "AL" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[29].
        cRange = "AM" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[30].
        cRange = "AN" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[31].
        cRange = "AO" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvo[32].
        /********/
        cRange = "AP" + cColumn.
        chWorkSheet:Range(cRange):Value = dTotIng.
        cRange = "AQ" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvv[21].
        cRange = "AR" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvv[25].
        cRange = "AS" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvv[24].
        cRange = "AT" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvv[26].
        cRange = "AU" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvv[22].
        cRange = "AV" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvv[32].
        cRange = "AW" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvv[33].
        cRange = "AX" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvv[34].
        cRange = "AY" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvv[35].
        cRange = "AZ" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvv[36].

        cRange = "BA" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvv[23].
        cRange = "BB" + cColumn.
        chWorkSheet:Range(cRange):Value = dTotDscto.
        cRange = "BC" + cColumn.
        chWorkSheet:Range(cRange):Value = dTotIng - dTotDscto.
        cRange = "BD" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvv[30].
        cRange = "BE" + cColumn.
        chWorkSheet:Range(cRange):Value = t-totvvv[31].
        cRange = "BF" + cColumn.
        chWorkSheet:Range(cRange):Value = t-ccto.
        cRange = "BG" + cColumn.
        chWorkSheet:Range(cRange):Value = t-cargos.
        cRange = "BH" + cColumn.
        chWorkSheet:Range(cRange):Value = t-clase.

        FIND FIRST B-MOV-MES WHERE B-MOV-MES.codcia = s-codcia
                    AND B-MOV-MES.codper = t-codper
                    AND B-MOV-MES.periodo = x-periodo
                    AND B-MOV-MES.nromes  = cb-mes
                    AND B-MOV-MES.codpln  = 01
                    AND B-MOV-MES.codcal  = 000
                    AND B-MOV-MES.codmov = 125 NO-LOCK NO-ERROR.
        IF AVAILABLE B-MOV-MES THEN DO:
            cRange = "BI" + cColumn.
            chWorkSheet:Range(cRange):Value = B-MOV-MES.valcal-mes.
        END.
        FIND FIRST B-MOV-MES WHERE B-MOV-MES.codcia = s-codcia
                    AND B-MOV-MES.codper = t-codper
                    AND B-MOV-MES.periodo = x-periodo
                    AND B-MOV-MES.nromes  = cb-mes
                    AND B-MOV-MES.codpln  = 01
                    AND B-MOV-MES.codcal  = 000
                    AND B-MOV-MES.codmov = 127 NO-LOCK NO-ERROR.
        IF AVAILABLE B-MOV-MES THEN DO:
            cRange = "BJ" + cColumn.
            chWorkSheet:Range(cRange):Value = B-MOV-MES.valcal-mes.
        END.
        FIND FIRST B-MOV-MES WHERE B-MOV-MES.codcia = s-codcia
                    AND B-MOV-MES.codper = t-codper
                    AND B-MOV-MES.periodo = x-periodo
                    AND B-MOV-MES.nromes  = cb-mes
                    AND B-MOV-MES.codpln  = 01
                    AND B-MOV-MES.codcal  = 000
                    AND B-MOV-MES.codmov = 126 NO-LOCK NO-ERROR.
        IF AVAILABLE B-MOV-MES THEN DO:
            cRange = "BK" + cColumn.
            chWorkSheet:Range(cRange):Value = B-MOV-MES.valcal-mes.
        END.

        /* SUELDO BASICO */
        FIND FIRST B-MOV-MES WHERE B-MOV-MES.codcia = s-codcia
                    AND B-MOV-MES.codper = t-codper
                    AND B-MOV-MES.periodo = x-periodo
                    AND B-MOV-MES.nromes  = cb-mes
                    AND B-MOV-MES.codpln  = 01
                    AND B-MOV-MES.codcal  = 000
                    AND B-MOV-MES.codmov = 101 NO-LOCK NO-ERROR.
        IF AVAILABLE B-MOV-MES THEN DO:
            cRange = "BL" + cColumn.
            chWorkSheet:Range(cRange):Value = B-MOV-MES.valcal-mes.
        END.

        DISPLAY
           t-codper + "-" + t-nombre @ x-mensaje WITH FRAME {&FRAME-NAME}.        
        PAUSE 0.
    END.
    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.        
    MESSAGE "Proceso Terminado con suceso" VIEW-AS ALERT-BOX INFORMA.

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
  
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN 
          x-periodo = s-periodo
          cb-mes = s-nromes.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

