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

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia  AS INT.
DEF SHARED VAR s-nomcia  AS CHAR.
DEF SHARED VAR s-Periodo AS INT.
DEF SHARED VAR s-nromes  AS INT.
DEF SHARED VAR pv-codcia AS INT.

DEF BUFFER bccbcdocu FOR ccbcdocu.

DEF VAR dDesdeF AS DATE NO-UNDO.
DEF VAR dHastaF AS DATE NO-UNDO.
DEF VAR dFechaF AS DATE NO-UNDO.

DEF TEMP-TABLE detalle NO-UNDO
    FIELD codcia LIKE almmmatg.codcia
    FIELD codmat LIKE almmmatg.codmat
    FIELD desmat LIKE almmmatg.desmat
    FIELD desmar LIKE almmmatg.desmar
    FIELD codpro AS CHAR FORMAT 'x(11)'
    FIELD nompro AS CHAR FORMAT 'x(60)'
    FIELD undbas LIKE almmmatg.undbas
    FIELD codfam LIKE almmmatg.codfam
    FIELD candes LIKE ccbddocu.candes
    FIELD implin LIKE ccbddocu.implin
    FIELD impcto LIKE ccbddocu.impcto
    FIELD tipo   AS CHAR FORMAT 'x(15)'.
    /*INDEX LLave01 IS PRIMARY UNIQUE codcia codmat.*/

DEF TEMP-TABLE tdmov
    FIELD codcia LIKE almmmatg.codcia
    FIELD codmat LIKE almmmatg.codmat
    FIELD desmat LIKE almmmatg.desmat
    FIELD desmar LIKE almmmatg.desmar
    FIELD codpro AS CHAR FORMAT 'x(11)'
    FIELD nompro AS CHAR FORMAT 'x(60)'
    FIELD undbas LIKE almmmatg.undbas
    FIELD codfam LIKE almmmatg.codfam
    FIELD candes LIKE ccbddocu.candes
    FIELD implin LIKE ccbddocu.implin
    FIELD impcto LIKE ccbddocu.impcto
    FIELD tipo   AS CHAR FORMAT 'x(15)'
    FIELD codalm LIKE almdmov.codalm
    FIELD tipmmov LIKE almdmov.tipmov
    FIELD codmov LIKE almdmov.codmov
    FIELD nroser LIKE almdmov.nroser
    FIELD nrodoc LIKE almdmov.nrodoc
    FIELD fchdoc LIKE almdmov.fchdoc
    FIELD coddoc1 LIKE ccbddoc.coddoc
    FIELD nrodoc1 LIKE ccbddoc.nrodoc
    FIELD origen AS CHAR FORMAT 'x(50)'
    FIELD moneda AS CHAR FORMAT 'x(50)'.
    
DEF VAR x-Factor AS INT NO-UNDO.

DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" NO-UNDO.
DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6 SKIP
    Fi-Mensaje NO-LABEL FONT 6 SKIP     
    WITH OVERLAY CENTERED KEEP-TAB-ORDER
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE
        BGCOLOR 15 FGCOLOR 0
        TITLE "Procesando..." FONT 7.

DEFINE VARIABLE cMeses AS CHARACTER NO-UNDO EXTENT 12.
cMeses[01]  = 'Enero'.
cMeses[02]  = 'Febrero'.
cMeses[03]  = 'Marzo'.
cMeses[04]  = 'Abril'.
cMeses[05]  = 'Mayo'.
cMeses[06]  = 'Junio'.
cMeses[07]  = 'Julio'.
cMeses[08]  = 'Agosto'.
cMeses[09]  = 'Setiembre'.
cMeses[10] = 'Octubre'.
cMeses[11] = 'Noviembre'.
cMeses[12] = 'Diciembre'.

DEFINE VAR sOrigenNotaCredito AS LOG.

DEFINE STREAM sFileTxt.
define stream log-epos.

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
&Scoped-Define ENABLED-OBJECTS x-Periodo x-CodDiv FILL-IN-desde ~
FILL-IN-hasta Btn_Excel Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS x-Periodo x-CodDiv FILL-IN-desde ~
FILL-IN-hasta x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fwrite_log W-Win 
FUNCTION fwrite_log RETURNS CHARACTER
  (INPUT pTexto AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done 
     LABEL "Salir" 
     SIZE 15 BY 1.12.

DEFINE BUTTON Btn_Excel 
     LABEL "Excel" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todas" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE x-Periodo AS CHARACTER FORMAT "X(4)":U 
     LABEL "Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58.14 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-Periodo AT ROW 2.08 COL 9 COLON-ALIGNED WIDGET-ID 14
     x-CodDiv AT ROW 3.12 COL 9 COLON-ALIGNED WIDGET-ID 22
     FILL-IN-desde AT ROW 4.15 COL 9.29 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-hasta AT ROW 4.15 COL 29.29 COLON-ALIGNED WIDGET-ID 20
     x-mensaje AT ROW 6.38 COL 4 NO-LABEL WIDGET-ID 12
     Btn_Excel AT ROW 8.5 COL 30 WIDGET-ID 6
     Btn_Done AT ROW 8.5 COL 46 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.57 BY 10.23
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "VENTAS Y COSTOS COMPARATIVOS MENSUAL CON PI LINEA 010"
         HEIGHT             = 10.23
         WIDTH              = 77.57
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 82.14
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 82.14
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
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* VENTAS Y COSTOS COMPARATIVOS MENSUAL CON PI LINEA 010 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* VENTAS Y COSTOS COMPARATIVOS MENSUAL CON PI LINEA 010 */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Salir */
DO:

  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel W-Win
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Excel */
DO:
    ASSIGN x-coddiv fill-in-desde fill-in-hasta.

    IF fill-in-desde = ? OR fill-in-hasta = ? THEN DO:
        MESSAGE "Ingrese valores fechas por favor!!!" 
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    IF fill-in-desde > fill-in-hasta THEN DO:
        MESSAGE "Ingrese valores fechas correctas por favor!!!" 
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.

    
    dDesdeF = fill-in-desde.
    dHastaF = fill-in-hasta.

    RUN Excel.  
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
  DISPLAY x-Periodo x-CodDiv FILL-IN-desde FILL-IN-hasta x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-Periodo x-CodDiv FILL-IN-desde FILL-IN-hasta Btn_Excel Btn_Done 
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

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1.
    DEFINE VARIABLE cColumn            AS CHARACTER.
    DEFINE VARIABLE cRange             AS CHARACTER.
    
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN proc_carga-temp.
    SESSION:SET-WAIT-STATE('').
    
    IF NOT CAN-FIND (FIRST detalle) THEN DO:
        MESSAGE
            "No existen registros a imprimir"
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* set the column names for the Worksheet */
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "VENTAS Y COSTOS COMPARATIVOS MENSUAL".
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = 'Mes'.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Desde " + STRING(fill-in-desde,"99/99/9999") + " hasta " + STRING(fill-in-hasta,"99/99/9999").
    /*
    IF NOT tg-acum THEN chWorkSheet:Range(cRange):Value = cMeses[INT(cb-mes)].
    ELSE chWorkSheet:Range(cRange):Value = "Enero a " + cMeses[INT(cb-mes)].
    */
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = 'Division:'.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = x-coddiv.
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "COD MAT".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "DESCRIPCION".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "UND BAS".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "CANTIDAD".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "COSTO TOTAL S/.".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "VENTA TOTAL S/.".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "MARCA".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "TIPO".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "PROVEEDOR".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "NOMBRE".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "LINEA".

    chWorkSheet:Columns("A"):NumberFormat = "@".
    chWorkSheet:Columns("C"):NumberFormat = "@".
    chWorkSheet:Columns("I"):NumberFormat = "@".
    chWorkSheet:Columns("K"):NumberFormat = "@".
    chWorkSheet:Range("A1:K3"):Font:Bold = TRUE.

    FOR EACH detalle NO-LOCK:
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.codmat.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.desmat.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.undbas.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.candes.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.impcto.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.implin.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.desmar.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.tipo.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.codpro.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.nompro.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = detalle.codfam.
        DISPLAY "CARGANDO EXCEL" @ x-mensaje WITH FRAME {&FRAME-NAME}.
    END.

    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
    
    MESSAGE
        "Proceso Terminado con suceso"
        VIEW-AS ALERT-BOX INFORMA.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Registro W-Win 
PROCEDURE Graba-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR dPrecioUnitarioSinImpsto AS DECIMAL.
DEFINE VAR dImporteTotalSinImpuesto AS DECIMAL.

DEF INPUT PARAMETER x-Factor AS DECI NO-UNDO.

DEFINE VARIABLE f-precio AS DECIMAL NO-UNDO.

IF Almcmov.codmov = 09 THEN DO:
    /*x-factor = 1.*/
END.

FIND detalle WHERE Detalle.codcia = s-codcia AND Detalle.codmat = Almdmov.codmat EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
IF NOT AVAILABLE detalle THEN DO:
    CREATE detalle.
    ASSIGN
        detalle.codcia = almmmatg.codcia
        detalle.codmat = almmmatg.codmat
        detalle.desmat = almmmatg.desmat
        detalle.undbas = almmmatg.undbas
        detalle.desmar = almmmatg.desmar
        detalle.codfam = almmmatg.codfam
        detalle.codpro = almmmatg.codpr1
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN UNDO, RETURN 'ADM-ERROR'.
    IF almmmatg.CHR__02 = 'P' THEN detalle.tipo = 'PROPIOS'.
    ELSE detalle.tipo = 'TERCEROS'.
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = almmmatg.codpr1
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN detalle.nompro = gn-prov.nompro.
END.
ASSIGN
    detalle.candes = detalle.candes + (Almdmov.CanDes * Almdmov.Factor * x-factor).

CREATE tdmov.
    ASSIGN
        tdmov.codcia = almmmatg.codcia
        tdmov.codmat = almmmatg.codmat
        tdmov.desmat = almmmatg.desmat
        tdmov.undbas = almmmatg.undbas
        tdmov.desmar = almmmatg.desmar
        tdmov.codfam = almmmatg.codfam
        tdmov.codpro = almmmatg.codpr1
        tdmov.codalm = almdmov.codalm
        tdmov.tipmmov = almdmov.tipmov
        tdmov.codmov = almdmov.codmov
        tdmov.nroser = almdmov.nroser
        tdmov.nrodoc = almdmov.nrodoc
        tdmov.fchdoc = almdmov.fchdoc
        tdmov.candes = Almdmov.CanDes * Almdmov.Factor * x-factor.
    
/*Calculando el precio de venta sin I.G.V*/
IF AVAILABLE Ccbcdocu THEN DO:

    FIND FIRST Ccbddocu OF Ccbcdocu WHERE Ccbddocu.codmat = Almdmov.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbddocu THEN DO:

        ASSIGN tdmov.coddoc1 = ccbddoc.coddoc
                tdmov.nrodoc1 = ccbddoc.nrodoc.

        /**/
        IF Almcmov.codmov = 02 OR sOrigenNotaCredito = YES THEN DO:            
            /*
            IF ccbcdocu.codmon = 1 
            THEN detalle.implin = detalle.implin + (CcbDDocu.ImporteTotalSinImpuesto * x-factor).
            ELSE DO: 
                FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.  /* OJO */
                IF AVAIL gn-tcmb 
                THEN detalle.implin = detalle.implin + (CcbDDocu.ImporteTotalSinImpuesto * gn-tcmb.venta * x-factor).
                ELSE detalle.implin = detalle.implin + (CcbDDocu.ImporteTotalSinImpuesto * ccbcdocu.tpocmb * x-factor).
            END.
            */
            dImporteTotalSinImpuesto = ccbddocu.ImporteTotalSinImpuesto.        /* Ojo es el importe TOTAL */

            IF ccbcdocu.codmon = 1 THEN DO:
                ASSIGN detalle.implin = detalle.implin + (dImporteTotalSinImpuesto * x-factor) .
                ASSIGN tdmov.implin = dImporteTotalSinImpuesto * x-factor
                        tdmov.moneda = 'SOLES'.
            END.               
            ELSE DO: 
                ASSIGN tdmov.moneda = 'DOLARES'.
                FIND FIRST gn-tcmb WHERE gn-tcmb.fecha = Almcmov.fchdoc NO-LOCK NO-ERROR.
                IF AVAIL gn-tcmb THEN DO:
                    ASSIGN detalle.implin = detalle.implin + (dImporteTotalSinImpuesto) * gn-tcmb.venta * x-factor.
                    ASSIGN tdmov.implin = dImporteTotalSinImpuesto * gn-tcmb.venta * x-factor.
                END.                    
                ELSE DO: 
                    ASSIGN detalle.implin = detalle.implin + (dImporteTotalSinImpuesto) * ccbcdocu.tpocmb * x-factor.
                    ASSIGN tdmov.implin = dImporteTotalSinImpuesto * ccbcdocu.tpocmb * x-factor.
                END.
                    
            END.
            ASSIGN tdmov.origen = "AAAA".
        END.
        ELSE DO:
            ASSIGN tdmov.origen = "BBBB".
            /* Sacamos los precios de la factura */
            /* dPrecioUnitarioSinImpsto = Ccbddocu.importeUnitarioSinImpuesto. */
            dImporteTotalSinImpuesto = ccbddocu.ImporteTotalSinImpuesto.
            IF ccbcdocu.codmon = 1 THEN DO:
                /* ASSIGN detalle.implin = detalle.implin + ((Almdmov.CanDes * Almdmov.Factor) * dPrecioUnitarioSinImpsto * x-factor).*/
                ASSIGN detalle.implin = detalle.implin + ( dImporteTotalSinImpuesto * x-factor).
                ASSIGN tdmov.implin = (dImporteTotalSinImpuesto * x-factor)
                        tdmov.moneda = 'SOLES'.
            END.
            ELSE DO:
                ASSIGN tdmov.moneda = 'DOLARES'.
                FIND FIRST gn-tcmb WHERE gn-tcmb.fecha = Almcmov.fchdoc NO-LOCK NO-ERROR.                
                IF NOT AVAIL gn-tcmb THEN DO: 
                    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.  /* OJO */
                END.
                IF AVAIL gn-tcmb THEN DO: 
                    /* ASSIGN detalle.implin = detalle.implin + ((Almdmov.CanDes * Almdmov.Factor) * dPrecioUnitarioSinImpsto) * gn-tcmb.venta * x-factor. */
                    ASSIGN detalle.implin = detalle.implin + ((dImporteTotalSinImpuesto * gn-tcmb.venta) * x-factor).
                    ASSIGN tdmov.implin = ((dImporteTotalSinImpuesto * gn-tcmb.venta) * x-factor).
                END.
                ELSE DO: 
                    /* ASSIGN detalle.implin = detalle.implin + ((Almdmov.CanDes * Almdmov.Factor) * dPrecioUnitarioSinImpsto) * ccbcdocu.tpocmb * x-factor. */
                    ASSIGN detalle.implin = detalle.implin + ((dImporteTotalSinImpuesto * ccbcdocu.tpocmb) * x-factor).
                    ASSIGN tdmov.implin = ((dImporteTotalSinImpuesto * ccbcdocu.tpocmb) * x-factor).
                END.                    
            END.
        END.
    END.
END.

/*Calculando Costo Promedio*/
f-precio = 0.
FIND LAST AlmStkGe USE-INDEX Llave01 WHERE AlmStkge.CodCia = s-codcia
    AND AlmStkge.codmat = Almdmov.codmat
    AND AlmStkge.Fecha <= Almcmov.fchdoc
    NO-LOCK NO-ERROR.
IF AVAILABLE AlmStkGe THEN f-Precio = AlmStkge.CtoUni.
ASSIGN detalle.impcto = detalle.impcto + (Almdmov.CanDes * Almdmov.Factor * f-precio * x-factor).


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

  /* Code placed here will execute AFTER standard behavior.    */
  DEFINE VARIABLE iInt AS INTEGER     NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  FOR EACH gn-divi NO-LOCK WHERE codcia = s-codcia:
      x-coddiv:ADD-LAST(gn-divi.coddiv) IN FRAME {&FRAME-NAME}.
  END.

  DO iInt = 0 TO 8 :
      x-periodo:ADD-LAST(STRING(YEAR(TODAY) - iInt)) IN FRAME {&FRAME-NAME}.
  END.
  ASSIGN 
      x-periodo = STRING(YEAR(TODAY), '9999')
      /*cb-mes = STRING(s-nromes,'99')*/. 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FILL-in-desde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 15,"99/99/9999").
  FILL-in-hasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_carga-temp W-Win 
PROCEDURE proc_carga-temp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE f-precio AS DECIMAL NO-UNDO.

EMPTY TEMP-TABLE detalle.
EMPTY TEMP-TABLE tdmov.

DEFINE VAR x-msg AS CHAR.
DEFINE VAR x-msg1 AS CHAR.

/* 14/01/2025: Juan Hermoza, movimientos de almacén I-09 S-02 */
FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-CodCia AND (x-coddiv = 'Todas' OR gn-divi.coddiv = x-coddiv): 

    DISPLAY gn-divi.coddiv @ x-mensaje WITH FRAME {&FRAME-NAME}.
    /* Ventas S-02 */
    FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = gn-divi.codcia AND Almacen.coddiv = gn-divi.coddiv,
        EACH Almcmov NO-LOCK WHERE Almcmov.codcia = gn-divi.codcia AND 
        Almcmov.codalm = Almacen.codalm AND
        Almcmov.tipmov = "S" AND
        Almcmov.codmov = 02 AND
        (Almcmov.fchdoc >= dDesdeF AND Almcmov.fchdoc <= dHastaF) AND
        Almcmov.flgest <> "A":

        sOrigenNotaCredito = NO.
        x-msg = "Ventas : " + gn-divi.coddiv + " " + STRING(Almcmov.nrodoc) + " " + Almcmov.codref + "-" + Almcmov.nroref.
        DISPLAY x-msg @ x-mensaje WITH FRAME {&FRAME-NAME}.


        FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = Almcmov.codcia AND
            Ccbcdocu.coddoc = Almcmov.codref AND 
            Ccbcdocu.nrodoc = Almcmov.nroref AND
            Ccbcdocu.flgest <> "A" NO-LOCK NO-ERROR.

        FOR EACH Almdmov OF Almcmov NO-LOCK, FIRST Almmmatg OF Almdmov WHERE Almmmatg.codfam = '010' NO-LOCK:
            RUN Graba-Registro (1).
        END.
    END.    
    /*x-msg1 = fwrite_log(gn-divi.coddiv).*/
    /* Ventas I-09 */
    FOR EACH Almacen NO-LOCK WHERE Almacen.codcia = gn-divi.codcia AND Almacen.coddiv = gn-divi.coddiv,
        EACH Almcmov NO-LOCK WHERE Almcmov.codcia = gn-divi.codcia AND 
        Almcmov.codalm = Almacen.codalm AND
        Almcmov.tipmov = "I" AND
        Almcmov.codmov = 09 AND
        (Almcmov.fchdoc >= dDesdeF AND Almcmov.fchdoc <= dHastaF) AND
        Almcmov.flgest <> "A":

        sOrigenNotaCredito = NO.     

        x-msg = "Devoluciones : " + gn-divi.coddiv + " " + STRING(Almcmov.nrodoc) + " " + Almcmov.codref + "-" + Almcmov.nroref.
        DISPLAY x-msg @ x-mensaje WITH FRAME {&FRAME-NAME}.
        /*x-msg1 = fwrite_log(x-msg).*/

        FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia AND
            Ccbcdocu.codref = Almcmov.codref AND
            Ccbcdocu.nroref = Almcmov.nroref AND
            Ccbcdocu.coddoc = "N/C" AND
            INT64(CCBCDOCU.nroped) = Almcmov.nrodoc AND Ccbcdocu.flgest <> "A" NO-LOCK NO-ERROR.

        /*x-msg1 = fwrite_log(x-msg + "000").*/

        /*x-msg1 = fwrite_log(x-msg + " AAA").*/

        FOR EACH Almdmov OF Almcmov NO-LOCK, 
            FIRST Almmmatg OF Almdmov WHERE Almmmatg.codfam = '010' NO-LOCK:
            RUN Graba-Registro(-1).
        END.

        /*x-msg1 = fwrite_log(x-msg + " BBB").*/
    END.
END.

/* 08Julio2026 Solo para propositos de verificacion se activo */
/*     
IF USERID("DICTDB") = "ADMIN" OR USERID("DICTDB") = "MASTER" THEN DO:
    DEFINE VAR hProc AS HANDLE NO-UNDO.
    
    RUN lib\Tools-to-excel PERSISTENT SET hProc.
    
    def var c-csv-file as char no-undo.
    def var c-xls-file as char no-undo. /* will contain the XLS file path created */
    
    c-xls-file = 'd:\xpciman\DEtalleVerifi.xlsx'.
    
    run pi-crea-archivo-csv IN hProc (input  buffer tdmov:handle,
                            /*input  session:temp-directory + "file"*/ c-xls-file,
                            output c-csv-file) .
    
    run pi-crea-archivo-xls  IN hProc (input  buffer tdmov:handle,
                            input  c-csv-file,
                            output c-xls-file) .
    
    DELETE PROCEDURE hProc.
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fwrite_log W-Win 
FUNCTION fwrite_log RETURNS CHARACTER
  (INPUT pTexto AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE BUFFER x-factabla FOR factabla.

/* IP de la PC */
DEFINE VAR x-ip AS CHAR.
DEFINE VAR x-pc AS CHAR.

RUN lib/_get_ip.r(OUTPUT x-pc, OUTPUT x-ip).

/* ---- */
DEFINE VAR lClientComputerName  AS CHAR.
DEFINE VAR lClientName          AS CHAR.
DEFINE VAR lComputerName        AS CHAR.

DEFINE VAR lPCName AS CHAR.
 
lClientComputerName = OS-GETENV ( "CLIENTCOMPUTERNAME"). 
lClientName         = OS-GETENV ( "CLIENTNAME").
lComputerName       = OS-GETENV ( "COMPUTERNAME").

lClientName = IF (lClientName = ?) THEN "" ELSE lClientName.
lClientComputerName = IF (lClientComputerName = ?) THEN "" ELSE lClientComputerName.
lComputerName = IF (lComputerName = ?) THEN "" ELSE lComputerName.

lPcName = IF (lClientComputerName = ? OR lClientComputerName = "") THEN lClientName ELSE lClientComputerName.
lPCName = IF (CAPS(lPCName) = "CONSOLE") THEN "" ELSE lPCName.
lPCName = IF (lPCName = ? OR lPCName = "") THEN lComputerName ELSE lPCName.
x-pc = IF (x-pc = ?) THEN '' ELSE x-pc.
x-ip = IF (x-ip = ?) THEN '' ELSE x-ip.
/* ------ */

    DEFINE VAR x-archivo AS CHAR.
    DEFINE VAR x-file AS CHAR.
    DEFINE VAR x-linea AS CHAR.

    x-file = STRING(TODAY,"99/99/9999").
    /*x-file = x-file + "-" + STRING(TIME,"HH:MM:SS").*/

    x-file = REPLACE(x-file,"/","").
    x-file = REPLACE(x-file,":","").

    x-archivo = session:TEMP-DIRECTORY + "LOG-PRUEBAS-" + x-file + ".txt".

    OUTPUT STREAM log-epos TO VALUE(x-archivo) APPEND.

    x-linea = STRING(TODAY,"99/99/9999") + " " + STRING(TIME,"hh:mm:ss") + " (" + lPCName + "-" + x-pc + ":" + x-ip + ") - " + TRIM(pTexto).

    PUT STREAM log-epos x-linea FORMAT 'x(300)' SKIP.

    OUTPUT STREAM LOG-epos CLOSE.


RETURN "".  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

