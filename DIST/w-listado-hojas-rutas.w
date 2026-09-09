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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.

DEFINE TEMP-TABLE tt-hojaruta
        FIELDS tt-coddoc LIKE DI-RutaC.coddoc       
        FIELDS tt-nrodoc LIKE DI-RutaC.nrodoc
        FIELDS tt-flgest AS CHAR FORMAT "X(50)"         /* LIKE DI-RutaC.flgest */
        FIELDS tt-horsal LIKE DI-RutaC.horsal
        FIELDS tt-horret LIKE DI-RutaC.horret
        FIELDS tt-fchsal LIKE DI-RutaC.fchsal
        FIELDS tt-kmtini LIKE DI-RutaC.kmtini
        FIELDS tt-kmtfin LIKE DI-RutaC.kmtfin
        FIELDS tt-codveh LIKE DI-RutaC.codveh
        FIELDS tt-guiatransportista LIKE DI-RutaC.guiatransportista
        FIELDS tt-nomtra LIKE DI-RutaC.nomtra
        FIELDS tt-tipomov AS CHAR FORMAT "x(30)"  /*"TRANSFERENCIAS"*/
        FIELDS tt-coddiv LIKE DI-RutaG.coddiv
        FIELDS tt-coclie LIKE ccbcdocu.codcli
        FIELDS tt-nomcli LIKE gn-clie.nomcli
        FIELDS tt-serref LIKE DI-RutaD.codref
        FIELDS tt-nroref LIKE DI-RutaD.nroref
        FIELDS tt-destino AS CHAR FORMAT "X(50)"
        FIELDS tt-propterc AS CHAR FORMAT "X(10)"        
        FIELDS tt-nomdivi AS CHAR FORMAT "x(60)"
        FIELDS tt-fac-serie AS CHAR FORMAT "x(4)"
        FIELDS tt-fac-nro AS CHAR FORMAT "x(20)"
        FIELDS tt-codprov AS CHAR FORMAT "x(15)"
        FIELDS tt-usuario AS CHAR FORMAT "x(15)".


         /*INDEX idx01 IS PRIMARY tt-codmat.*/

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
&Scoped-Define ENABLED-OBJECTS ChkVehPropios optgrpQuienes txtDesde ~
txtHasta btn-Ok RECT-7 
&Scoped-Define DISPLAYED-OBJECTS ChkVehPropios optgrpQuienes txtDesde ~
txtHasta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-Ok 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 13.57 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE optgrpQuienes AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Todos", 1,
"Todos menos las cerradas", 2,
"Solo cerradas", 3
     SIZE 31 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 1.92.

DEFINE VARIABLE ChkVehPropios AS LOGICAL INITIAL no 
     LABEL "Considerar vehiculos Propios" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     ChkVehPropios AT ROW 5.81 COL 41 WIDGET-ID 24
     optgrpQuienes AT ROW 5.81 COL 7 NO-LABEL WIDGET-ID 20
     txtDesde AT ROW 3.58 COL 17.43 COLON-ALIGNED WIDGET-ID 4
     txtHasta AT ROW 3.58 COL 35.57 WIDGET-ID 6
     btn-Ok AT ROW 8.42 COL 45 WIDGET-ID 12
     "Cuyas salidas de vehiculos sean..." VIEW-AS TEXT
          SIZE 36 BY .62 AT ROW 2.54 COL 9.43 WIDGET-ID 10
          FONT 3
     "Listado de Situacion de Hoja de Ruta" VIEW-AS TEXT
          SIZE 33 BY .62 AT ROW 1.27 COL 19 WIDGET-ID 2
          FONT 6
     RECT-7 AT ROW 3.15 COL 9.43 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.86 BY 8.92 WIDGET-ID 100.


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
         TITLE              = "Listado de hojas de Rutas"
         HEIGHT             = 8.92
         WIDTH              = 71.86
         MAX-HEIGHT         = 27.65
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.65
         VIRTUAL-WIDTH      = 146.29
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN txtHasta IN FRAME F-Main
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Listado de hojas de Rutas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Listado de hojas de Rutas */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-Ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-Ok W-Win
ON CHOOSE OF btn-Ok IN FRAME F-Main /* Procesar */
DO:
  ASSIGN txtDesde txtHasta OptGrpQuienes ChkVehPropios.

  IF txtDesde = ?  THEN DO:
    MESSAGE 'Fecha DESDE esta ERRADA' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  IF txtHasta = ?  THEN DO:
    MESSAGE 'Fecha Hasta esta ERRADA' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.

  RUN um_proceso.
  /*RUN um_calcula_valores.*/
  RUN um_envia_excel.

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
  DISPLAY ChkVehPropios optgrpQuienes txtDesde txtHasta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE ChkVehPropios optgrpQuienes txtDesde txtHasta btn-Ok RECT-7 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
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
    txtDesde:SCREEN-VALUE = STRING(TODAY - 30,"99/99/9999").
    txtHasta:SCREEN-VALUE = STRING(TODAY,"99/99/9999") .
  END.
    

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um_calcula_valores W-Win 
PROCEDURE um_calcula_valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um_envia_excel W-Win 
PROCEDURE um_envia_excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
        DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
        DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

        DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

        DEFINE VARIABLE iCount                  AS INTEGER init 1.
        DEFINE VARIABLE iIndex                  AS INTEGER.
        DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
        DEFINE VARIABLE cColumn                 AS CHARACTER.
        DEFINE VARIABLE cRange                  AS CHARACTER.
        DEFINE VARIABLE x-signo                 AS DECI.

    DEFINE VAR lDpto AS CHAR.
    DEFINE VAR lProv AS CHAR.
    DEFINE VAR lDist AS CHAR.
    DEFINE VAR lCCli AS CHAR.
    DEFINE VAR lDCli AS CHAR.
    DEFINE VAR lImp AS DEC.
    DEFINE VAR lDestino AS CHAR.
    DEFINE VAR lTonelaje AS DEC.
    DEFINE VAR lCosto AS DEC.
    DEFINE VAR lTipo AS CHAR.
    DEFINE VAR lCodPro AS CHAR.
    DEFINE VAR lHora AS DEC.
    DEFINE VAR lHora1 AS DEC.
    DEFINE VAR lHFrac AS DEC.

        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication.

        /* launch Excel so it is visible to the user */
        chExcelApplication:Visible = FALSE.

        /* Para crear a new Workbook */
        chWorkbook = chExcelApplication:Workbooks:Add().

        /* get the active Worksheet */
        chWorkSheet = chExcelApplication:Sheets:Item(1).

    chExcelApplication:VISIBLE = FALSE.

        /* set the column names for the Worksheet */

        chWorkSheet:Range("A1"):Font:Bold = TRUE.
        chWorkSheet:Range("A1"):Value = "LISTADO HOJAS DE RUTA -  DESDE :" + 
        STRING(txtDesde,"99/99/9999") + "   HASTA :" + STRING(txtHasta,"99/99/9999").

        chWorkSheet:Range("A2:AZ2"):Font:Bold = TRUE.
        chWorkSheet:Range("A2"):Value = "cod.Hoja".
        chWorkSheet:Range("B2"):Value = "Nro de Hoja".
        chWorkSheet:Range("C2"):Value = "Situacion".
        chWorkSheet:Range("D2"):Value = "Hora Salida".
        chWorkSheet:Range("E2"):Value = "Hora Retorno".
        chWorkSheet:Range("F2"):Value = "Fecha Salida".
        chWorkSheet:Range("G2"):Value = "Km inicial".
        chWorkSheet:Range("H2"):Value = "Usuario".
        chWorkSheet:Range("I2"):Value = "Placa".
        chWorkSheet:Range("J2"):Value = "Guia Transp.".
        chWorkSheet:Range("K2"):Value = "Transportista".
        chWorkSheet:Range("L2"):Value = "Tipo Vehiculo".
        chWorkSheet:Range("M2"):Value = "Division".
        chWorkSheet:Range("O2"):Value = "Cod.Transportista".

        DEF VAR x-Column AS INT INIT 74 NO-UNDO.
        DEF VAR x-Range  AS CHAR NO-UNDO.


SESSION:SET-WAIT-STATE('GENERAL').
iColumn = 2.

FOR EACH tt-hojaruta NO-LOCK:
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).

        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-coddoc.       
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-nrodoc.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-flgest.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-horsal.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-horret.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-fchsal.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-kmtini.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-usuario.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-codveh.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-guiatransportista.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-nomtra.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-propterc.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-coddiv.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-nomdivi.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-codprov.

        
END.

    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
    chExcelApplication:DisplayAlerts = False.
    chExcelApplication:VISIBLE = TRUE .
        /*chExcelApplication:Quit().*/


        /* release com-handles */
        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.
        RELEASE OBJECT chWorksheetRange NO-ERROR. 

SESSION:SET-WAIT-STATE('').

    


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um_proceso W-Win 
PROCEDURE um_proceso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEFINE VAR lDpto AS CHAR.
    DEFINE VAR lProv AS CHAR.
    DEFINE VAR lDist AS CHAR.
    DEFINE VAR lCCli AS CHAR.
    DEFINE VAR lDCli AS CHAR.
    DEFINE VAR lPropTerc AS CHAR.
    /*DEFINE VAR lDCli AS CHAR.*/
    DEFINE VAR lImp AS DEC.
    DEFINE VAR lDestino AS CHAR.
    DEFINE VAR lTonelaje AS DEC.
    DEFINE VAR lCosto AS DEC.
    DEFINE VAR lTipo AS CHAR.
    DEFINE VAR lCodPro AS CHAR.
    DEFINE VAR lDesPro AS CHAR.
    DEFINE VAR lHora AS DEC.
    DEFINE VAR lMinuto AS DEC.
    DEFINE VAR lHora1 AS DEC.
    DEFINE VAR lHFrac AS DEC.
    DEFINE VAR lMone AS CHAR.
    DEFINE VAR lSoles AS DEC.
    DEFINE VAR lTcmb AS DEC.
    DEFINE VAR lOrigen AS CHAR.


SESSION:SET-WAIT-STATE('GENERAL').

EMPTY TEMP-TABLE tt-hojaruta.

DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE VAR pEstado AS CHAR NO-UNDO.
RUN tra/tra-librerias PERSISTENT SET hProc.

FOR EACH DI-RutaC WHERE DI-RutaC.codcia = s-codcia AND DI-RutaC.coddoc = 'h/r' AND (DI-RutaC.fchsal >= txtDesde AND
    DI-RutaC.fchsal <= txtHasta) NO-LOCK:

    IF DI-RutaC.FlgEst = 'A' THEN NEXT.
    /*IF DI-RutaC.coddiv <> s-coddiv THEN NEXT.*/
    IF OptGrpQuienes > 1 THEN DO:
        IF OptGrpQuienes = 2 AND DI-RutaC.FlgEst = 'C' THEN NEXT.
        IF OptGrpQuienes = 3 AND DI-RutaC.FlgEst <> 'C' THEN NEXT.
    END.
    /*
    ((OptGrpQuienes = 1) OR (OptGrpQuienes = 2 AND DI-RutaC.FlgEst='L') OR
    (OptGrpQuienes = 3 AND DI-RutaC.FlgEst<>'L')) NO-LOCK:
    */
    /* Datos del Transportista */
    lTonelaje   = 0.
    lCosto      = 0.
    lTipo       = ''.    
    lCodPro     = ''.
    lDesPro     = ''.
    lPropTerc     = "".
    
    /* Version antigua */
    FIND FIRST gn-vehic WHERE gn-vehic.codcia = DI-RutaC.codcia AND 
          gn-vehic.placa = DI-RutaC.codveh NO-LOCK NO-ERROR.
    IF AVAILABLE gn-vehic THEN DO:
       lTonelaje   = gn-vehic.carga.
       lCodPro     = gn-vehic.codpro.
       lPropTerc    = ""    /*gn-vehic.estado*/.
    END.
    IF DI-RutaC.codpro = '' OR DI-RutaC.codpro = ? THEN DO: 
        /* La ruta no tiene codprodveedor por lo tanto agarra la de la tabla Vehiculos */
    END.
    ELSE lCodPro = DI-RutaC.codpro.
    /*
    IF (lPropTerc = '02') OR (ChkVehPropios = YES) THEN DO:
        /* Tercero x Default, */
    END.
    ELSE NEXT.
    */
    FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND gn-prov.codpro = lCodPro NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN DO:
        lDesPro = gn-prov.nompro.
        /*IF (ChkVehPropios = YES AND gn-prov.libre_d01 <> 2) THEN NEXT.*/
        IF gn-prov.libre_d01 = 2 AND ChkVehPropios = NO THEN NEXT.
        lPropTerc    = "EXTERNO".
        IF gn-prov.libre_d01 = 2 THEN lPropTerc= "PROPIO".
    END.
        
    /* La division */
    lOrigen = "".
    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
        gn-divi.coddiv = di-rutaC.coddiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN lOrigen = gn-divi.desdiv.
        

    RUN Flag-Estado IN hProc (DI-RutaC.FlgEst, OUTPUT pEstado).
    
        CREATE tt-hojaruta.
            ASSIGN tt-coddoc    = DI-RutaC.coddoc
                    tt-nrodoc   = DI-RutaC.nrodoc
                    tt-flgest   = pEstado       /*DI-RutaC.flgest*/
                    tt-horsal   = string(DI-RutaC.horsal,"99:99")
                    tt-horret   = string(DI-RutaC.horret,"99:99")
                    tt-fchsal   = DI-RutaC.fchsal
                    tt-codveh   = DI-RutaC.codveh
                    tt-kmtini   = DI-RutaC.kmtini
                    tt-coddiv   = di-rutaC.coddiv
                    tt-guiatransportista    = DI-RutaC.guiatransportista
                    tt-nomtra   = lDesPro  /*DI-RutaC.nomtra*/
                    tt-nomdivi = lOrigen
                    tt-propterc = lPropTerc
                    tt-codprov = lCodPro
                    tt-usuario = di-rutaC.usuario.              

END.

SESSION:SET-WAIT-STATE('').

DELETE PROCEDURE hProc.

   /* MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

