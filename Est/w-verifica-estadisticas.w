&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
          estavtas         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.
DEFINE BUFFER B-DIVI FOR GN-DIVI.
DEFINE TEMP-TABLE Detalle NO-UNDO LIKE Ventas_Detalle.
DEFINE TEMP-TABLE Resumen NO-UNDO LIKE Ventas_Detalle.



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

DEF VAR x-PorIgv AS DEC DECIMALS 4 NO-UNDO.
DEF VAR x-signo1 AS INT INIT 1 NO-UNDO.
DEF VAR x-coe       AS DECI INIT 0 NO-UNDO.
DEF VAR x-can       AS DECI INIT 0 NO-UNDO.
DEF VAR x-TpoCmbCmp AS DECI INIT 1 NO-UNDO.
DEF VAR x-TpoCmbVta AS DECI INIT 1 NO-UNDO.
DEF VAR pCodDiv AS CHAR NO-UNDO.
DEF VAR pDivDes AS CHAR NO-UNDO.
DEF VAR f-factor    AS DECI INIT 0 NO-UNDO.
DEF VAR x-codven    AS CHAR NO-UNDO.
DEF VAR x-ImpTot AS DEC NO-UNDO.     /* IMporte NETO de venta */
DEF VAR x-ImpLin AS DEC NO-UNDO.

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
&Scoped-define INTERNAL-TABLES Resumen

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 Resumen.DateKey Resumen.CodDiv ~
Resumen.ImpNacCIGV Resumen.ImpExtCIGV Resumen.FleteNacCIGV ~
Resumen.FleteExtCIGV 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH Resumen NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH Resumen NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 Resumen
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 Resumen


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS x-CodFchI x-CodFchF BUTTON-1 RECT-1 BROWSE-2 ~
RECT-2 
&Scoped-Define DISPLAYED-OBJECTS x-CodFchI x-CodFchF 

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

DEFINE VARIABLE x-CodFchF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodFchI AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 40 BY 1.35
     BGCOLOR 14 FGCOLOR 0 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 40 BY 1.35
     BGCOLOR 10 FGCOLOR 0 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      Resumen SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      Resumen.DateKey COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
      Resumen.CodDiv COLUMN-LABEL "División" FORMAT "x(5)":U WIDTH 8.72
      Resumen.ImpNacCIGV FORMAT "->>>,>>>,>>9.99":U WIDTH 19.43
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      Resumen.ImpExtCIGV FORMAT "->>>,>>>,>>9.99":U WIDTH 18.43
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      Resumen.FleteNacCIGV COLUMN-LABEL "Importe Nac con IGV" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 18.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
      Resumen.FleteExtCIGV COLUMN-LABEL "Importe Ext Con IGV" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 18.72 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 99 BY 12.65 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodFchI AT ROW 1.27 COL 19 COLON-ALIGNED WIDGET-ID 2
     x-CodFchF AT ROW 2.35 COL 19 COLON-ALIGNED WIDGET-ID 4
     BUTTON-1 AT ROW 1.27 COL 51 WIDGET-ID 6
     BROWSE-2 AT ROW 5.04 COL 2 WIDGET-ID 200
     "EN PRODUCTIVO" VIEW-AS TEXT
          SIZE 17 BY .62 AT ROW 4.23 COL 33 WIDGET-ID 8
          BGCOLOR 14 FGCOLOR 0 FONT 6
     "EN ESTADISTICAS" VIEW-AS TEXT
          SIZE 17 BY .62 AT ROW 4.23 COL 73 WIDGET-ID 10
          BGCOLOR 10 FGCOLOR 0 FONT 6
     RECT-1 AT ROW 3.69 COL 21 WIDGET-ID 12
     RECT-2 AT ROW 3.69 COL 61 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 101.14 BY 17 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-DDOCU B "?" ? INTEGRAL CcbDDocu
      TABLE: B-DIVI B "?" ? INTEGRAL GN-DIVI
      TABLE: Detalle T "?" NO-UNDO estavtas Ventas_Detalle
      TABLE: Resumen T "?" NO-UNDO estavtas Ventas_Detalle
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "VERIFICACION RAPIDA DE ESTADISTICAS"
         HEIGHT             = 17
         WIDTH              = 101.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 114.14
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 114.14
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
/* BROWSE-TAB BROWSE-2 RECT-1 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.Resumen"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.Resumen.DateKey
"DateKey" "Fecha" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.Resumen.CodDiv
"CodDiv" "División" ? "character" ? ? ? ? ? ? no ? no no "8.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.Resumen.ImpNacCIGV
"ImpNacCIGV" ? ? "decimal" 14 0 ? ? ? ? no ? no no "19.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.Resumen.ImpExtCIGV
"ImpExtCIGV" ? ? "decimal" 14 0 ? ? ? ? no ? no no "18.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.Resumen.FleteNacCIGV
"FleteNacCIGV" "Importe Nac con IGV" ? "decimal" 10 0 ? ? ? ? no ? no no "18.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.Resumen.FleteExtCIGV
"FleteExtCIGV" "Importe Ext Con IGV" ? "decimal" 10 0 ? ? ? ? no ? no no "18.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* VERIFICACION RAPIDA DE ESTADISTICAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* VERIFICACION RAPIDA DE ESTADISTICAS */
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
  ASSIGN x-CodFchF x-CodFchI.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Verifica.
  {&OPEN-QUERY-{&BROWSE-NAME}}
  SESSION:SET-WAIT-STATE('').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Ventas-Detalle W-Win 
PROCEDURE Carga-Ventas-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-CanDes AS DECI NO-UNDO.

    /* AJUSTE DEL IMPORTE DE VENTA DEBIDO A LAS VENTAS CON DESCUENTOS EN UTILEX */
    ASSIGN
    x-ImpLin = Ccbddocu.ImpLin - Ccbddocu.ImpDto2.
    /* ************************************************************************ */
    /* RHC 30/04/2015 COSTO DE REPOSICION ACTUAL */
    /* ************************************************************************ */
    FIND DimProducto WHERE DimProducto.CodMat = TRIM(ccbddocu.codmat) NO-LOCK NO-ERROR.
    /* ************************************************************************ */
    /* RHC 06/03/2019 Caso de Productos SIN IGV */
    /* RHC 19/07/2021 veamos si el producto tiene IGV */
    /* ************************************************************************ */
    /*IF Almmmatg.AftIgv = NO THEN x-PorIgv = 0.00.*/
    IF Ccbddocu.AftIgv = NO THEN x-PorIgv = 0.
    ELSE DO:
        IF x-PorIgv <= 0 OR x-PorIgv = ? THEN 
            IF (Ccbddocu.ImpLin - Ccbddocu.ImpIgv) > 0 THEN x-PorIgv = Ccbddocu.ImpIgv / ( Ccbddocu.ImpLin - Ccbddocu.ImpIgv) * 100.
            ELSE x-PorIgv = 0.
    END.

    /* OJO */
    x-CanDes = CcbDdocu.CanDes * F-FACTOR * x-can.
    /* *** */

    CREATE Detalle.
    ASSIGN
        Detalle.DateKey = Ccbcdocu.FchDoc
        Detalle.CodDiv = pCodDiv.
    IF Ccbcdocu.CodMon = 1 THEN 
        ASSIGN
            Detalle.ImpExtCIGV   = x-signo1 * x-ImpLin * x-coe / x-TpoCmbCmp
            Detalle.ImpExtSIGV   = Detalle.ImpExtCIGV / ( 1 + ( x-PorIgv / 100) )
            Detalle.ImpNacCIGV   = x-signo1 * x-ImpLin * x-coe
            Detalle.ImpNacSIGV   = Detalle.ImpNacCIGV / ( 1 + ( x-PorIgv / 100) ).
    IF Ccbcdocu.CodMon = 2 THEN 
        ASSIGN
            Detalle.ImpExtCIGV   = x-signo1 * x-ImpLin * x-coe 
            Detalle.ImpExtSIGV   = Detalle.ImpExtCIGV / ( 1 + ( x-PorIgv / 100) )
            Detalle.ImpNacCIGV   = x-signo1 * x-ImpLin * x-coe * x-TpoCmbVta
            Detalle.ImpNacSIGV   = Detalle.ImpNacCIGV / ( 1 + ( x-PorIgv / 100) ).
    /* 11.09.10 INCORPORAMOS EL COSTO PROMEDIO */
    /* 06/05/2019 A todos excepto a las N/C por Otros conceptos cuyo concepto NO afecte al costo de ventas */
    DEF VAR x-CtoUni AS DEC NO-UNDO.
    x-CtoUni = 0.
    FIND LAST AlmStkGe WHERE Almstkge.codcia = Ccbcdocu.codcia
        AND Almstkge.codmat = Ccbddocu.codmat
        AND Almstkge.fecha <= Ccbcdocu.fchdoc
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almstkge AND Almstkge.CtoUni <> ? THEN x-CtoUni = AlmStkge.CtoUni.
    IF Ccbcdocu.codcia = 1 and Ccbcdocu.coddoc = 'N/C' and Ccbcdocu.cndcre = "N" THEN DO:
        FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia AND
            CcbTabla.Tabla = "N/C" AND
            CcbTabla.Codigo = Ccbcdocu.codcta
            NO-LOCK NO-ERROR.
        IF AVAILABLE CcbTabla AND CcbTabla.Libre_c02 = "NO" THEN x-CtoUni = 0.
    END.
    ASSIGN
        Detalle.PromExtSIGV = x-signo1 * x-CanDes * x-CtoUni * x-coe / x-TpoCmbCmp
        Detalle.PromExtCIGV = Detalle.PromExtSIGV * ( 1 + ( x-PorIgv / 100) )
        Detalle.PromNacSIGV = x-signo1 * x-CanDes * x-CtoUni * x-coe
        Detalle.PromNacCIGV = Detalle.PromNacSIGV * ( 1 + ( x-PorIgv / 100) ).

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
  DISPLAY x-CodFchI x-CodFchF 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-CodFchI x-CodFchF BUTTON-1 RECT-1 BROWSE-2 RECT-2 
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
  ASSIGN
      x-CodFchF = TODAY - 1
      x-CodFchI = TODAY - 1.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESA-ANTCIPOS-APLICADOS W-Win 
PROCEDURE PROCESA-ANTCIPOS-APLICADOS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-ImpCto LIKE CcbDdocu.ImpCto.

/* AJUSTE DEL IMPORTE DE VENTA DEBIDO A LAS VENTAS CON DESCUENTOS EN UTILEX */
ASSIGN
    x-ImpLin = Ccbcdocu.ImpTot2
    x-ImpCto = 0
    x-signo1 = -1.
IF x-ImpCto = ? THEN x-ImpCto = 0.
/* ************************************************************************ */
CREATE Detalle.
ASSIGN
    Detalle.DateKey = Ccbcdocu.fchdoc
    Detalle.CodDiv = "99999".
IF Ccbcdocu.CodMon = 1 THEN 
    ASSIGN
        Detalle.CostoExtCIGV = 0
        Detalle.CostoExtSIGV = 0
        Detalle.CostoNacCIGV = 0
        Detalle.CostoNacSIGV = 0
        Detalle.ImpExtCIGV   = x-signo1 * x-ImpLin * x-coe / x-TpoCmbCmp
        Detalle.ImpExtSIGV   = Detalle.ImpExtCIGV / ( 1 + ( x-PorIgv / 100) )
        Detalle.ImpNacCIGV   = x-signo1 * x-ImpLin * x-coe
        Detalle.ImpNacSIGV   = Detalle.ImpNacCIGV / ( 1 + ( x-PorIgv / 100) ).
IF Ccbcdocu.CodMon = 2 THEN 
    ASSIGN
        Detalle.CostoExtCIGV = 0
        Detalle.CostoExtSIGV = 0
        Detalle.CostoNacCIGV = 0
        Detalle.CostoNacSIGV = 0
        Detalle.ImpExtCIGV   = x-signo1 * x-ImpLin * x-coe 
        Detalle.ImpExtSIGV   = Detalle.ImpExtCIGV / ( 1 + ( x-PorIgv / 100) )
        Detalle.ImpNacCIGV   = x-signo1 * x-ImpLin * x-coe * x-TpoCmbVta
        Detalle.ImpNacSIGV   = Detalle.ImpNacCIGV / ( 1 + ( x-PorIgv / 100) ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESA-NC-DIFPRECIO W-Win 
PROCEDURE PROCESA-NC-DIFPRECIO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND B-CDOCU WHERE B-CDOCU.Codcia = CcbCdocu.Codcia 
    AND B-CDOCU.CodDoc = CcbCdocu.Codref 
    AND B-CDOCU.NroDoc = CcbCdocu.Nroref 
    NO-LOCK.
FOR EACH CcbDdocu OF CcbCdocu NO-LOCK, FIRST Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia 
    AND Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK:
    FIND FIRST B-DDOCU WHERE B-DDOCU.codcia = B-CDOCU.codcia
        AND B-DDOCU.coddoc = B-CDOCU.coddoc
        AND B-DDOCU.nrodoc = B-CDOCU.nrodoc
        AND B-DDOCU.codmat = CcbDdocu.codmat 
        NO-LOCK NO-ERROR.
    F-FACTOR = 1.   /* NO afecta la cantidad */
    x-coe = 1.
    x-can = 0.
    RUN Carga-Ventas-Detalle.    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Nota W-Win 
PROCEDURE Procesa-Nota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    x-Can = 0                       /* ¿¿¿ OJO ??? */
    x-ImpTot = B-CDOCU.ImpTot.      /* <<< OJO <<< */
/* RHC 25/04/2014 cambio en la lógica */
x-ImpTot = 0.
FOR EACH CcbDdocu OF B-CDOCU NO-LOCK:
    x-ImpTot = x-ImpTot + Ccbddocu.ImpLin.
END.
/* buscamos si hay una aplicación de fact adelantada */
FIND FIRST Ccbddocu OF B-CDOCU WHERE Ccbddocu.implin < 0 NO-LOCK NO-ERROR.
IF AVAILABLE Ccbddocu THEN x-ImpTot = x-ImpTot + ABSOLUTE(Ccbddocu.ImpLin).
/* ************************************************* */
x-Coe = Ccbcdocu.ImpTot / x-ImpTot.     /* OJO */
FOR EACH CcbDdocu OF B-CDOCU NO-LOCK:
    /* ***************** FILTROS ********************************* */
    FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia 
        AND Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN NEXT.
    IF Ccbddocu.implin <= 0 THEN NEXT.       /* <<< OJO <<< */
    /* ************************************************************ */
    IF Ccbddocu.ImpCto = ? THEN NEXT.
    /* **************************************************** */
    F-FACTOR  = 1. 
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = Ccbddocu.UndVta
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN DO:
       F-FACTOR = Almtconv.Equival.
       IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
    END.

    RUN Carga-Ventas-Detalle.    
END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Nota-Rebade W-Win 
PROCEDURE Procesa-Nota-Rebade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* EL REBATE ES APLICADO SOLO A PRODUCTOS DE LA FAMILIA 010 Y 012 */
    FIND B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
        AND B-CDOCU.coddoc = Ccbcdocu.codref
        AND B-CDOCU.nrodoc = Ccbcdocu.nroref
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN RETURN.
    ASSIGN
        x-Can = 0                       /* ¿¿¿ OJO ??? */
        x-ImpTot = 0.                   /* <<< OJO <<< */
    FOR EACH CcbDdocu OF B-CDOCU NO-LOCK WHERE Ccbddocu.ImpLin > 0,
        FIRST Almmmatg OF Ccbddocu NO-LOCK WHERE LOOKUP(Almmmatg.codfam , '010,012') > 0:
        x-ImpTot = x-ImpTot + Ccbddocu.ImpLin.
    END.  
    IF x-ImpTot <= 0 THEN RETURN.
    /* ************************************************* */
    x-Coe = Ccbcdocu.ImpTot / x-ImpTot.     /* OJO */
    FOR EACH CcbDdocu OF B-CDOCU NO-LOCK:
        /* ***************** FILTROS ********************************* */
        FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia 
            AND Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN NEXT.
        IF LOOKUP(Almmmatg.codfam , '010,012') = 0 THEN NEXT.
        IF Ccbddocu.implin <= 0 THEN NEXT.       /* <<< OJO <<< */
        /* ************************************************************ */
        IF Ccbddocu.ImpCto = ? THEN NEXT.
        /* **************************************************** */
        F-FACTOR  = 1. 
        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
            AND Almtconv.Codalter = Ccbddocu.UndVta
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN DO:
           F-FACTOR = Almtconv.Equival.
           IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
        END.

        RUN Carga-Ventas-Detalle.

    END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESA-OTRAS-VENTAS W-Win 
PROCEDURE PROCESA-OTRAS-VENTAS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-ImpCto LIKE CcbDdocu.ImpCto NO-UNDO.
    DEF VAR x-ImpLin AS DECI NO-UNDO.

    /* AJUSTE DEL IMPORTE DE VENTA DEBIDO A LAS VENTAS CON DESCUENTOS EN UTILEX */
    ASSIGN
        x-ImpLin = Ccbcdocu.ImpTot
        x-ImpCto = 0.
    IF x-PorIgv <= 0 THEN x-PorIgv = Ccbcdocu.ImpIgv / ( Ccbcdocu.ImpTot - Ccbcdocu.ImpIgv) * 100.
    IF x-ImpCto = ? THEN x-ImpCto = 0.
    /* ************************************************************************ */
    CREATE Detalle.
    ASSIGN
        Detalle.CodDiv = pCodDiv
        Detalle.DateKey = Ccbcdocu.fchdoc.
    IF Ccbcdocu.CodMon = 1 THEN 
        ASSIGN
            Detalle.CostoExtCIGV = 0
            Detalle.CostoExtSIGV = 0
            Detalle.CostoNacCIGV = 0
            Detalle.CostoNacSIGV = 0
            Detalle.ImpExtCIGV   = x-signo1 * x-ImpLin * x-coe / x-TpoCmbCmp
            Detalle.ImpExtSIGV   = Detalle.ImpExtCIGV / ( 1 + ( x-PorIgv / 100) )
            Detalle.ImpNacCIGV   = x-signo1 * x-ImpLin * x-coe
            Detalle.ImpNacSIGV   = Detalle.ImpNacCIGV / ( 1 + ( x-PorIgv / 100) ).
    IF Ccbcdocu.CodMon = 2 THEN 
        ASSIGN
            Detalle.CostoExtCIGV = 0
            Detalle.CostoExtSIGV = 0
            Detalle.CostoNacCIGV = 0
            Detalle.CostoNacSIGV = 0
            Detalle.ImpExtCIGV   = x-signo1 * x-ImpLin * x-coe 
            Detalle.ImpExtSIGV   = Detalle.ImpExtCIGV / ( 1 + ( x-PorIgv / 100) )
            Detalle.ImpNacCIGV   = x-signo1 * x-ImpLin * x-coe * x-TpoCmbVta
            Detalle.ImpNacSIGV   = Detalle.ImpNacCIGV / ( 1 + ( x-PorIgv / 100) ).

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
  {src/adm/template/snd-list.i "Resumen"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica W-Win 
PROCEDURE Verifica :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Barremos las ventas */
EMPTY TEMP-TABLE Detalle.
EMPTY TEMP-TABLE Resumen.

ESTADISTICAS:
FOR EACH DimDivision NO-LOCK,
    EACH CcbCdocu USE-INDEX Llave10 NO-LOCK WHERE CcbCdocu.CodCia = S-CODCIA 
        AND CcbCdocu.CodDiv = DimDivision.CodDiv
        AND CcbCdocu.FchDoc >= x-CodFchI
        AND CcbCdocu.FchDoc <= x-CodFchF:
    /* ***************** FILTROS ********************************** */
    IF LOOKUP(CcbCDocu.CodDoc,"TCK,FAC,BOL,N/C") = 0 THEN NEXT.
    IF LOOKUP(CcbCDocu.FlgEst, "A,X") > 0 THEN NEXT.    /* ANULADO y CERRADO */
    IF LOOKUP(CcbCDocu.TpoFac, "B") > 0   THEN NEXT.    /* VIENE DE UNA BAJA DE SUNAT */
    IF DAY(CcbCDocu.FchDoc) = 0 OR DAY(CcbCDocu.FchDoc) = ? THEN NEXT.
    /* NO facturas adelantadas NI servicios */
    IF LOOKUP(Ccbcdocu.CodDoc, 'N/C,A/C') > 0 THEN DO:
        FIND B-CDOCU WHERE B-CDOCU.Codcia = CcbCdocu.Codcia
            AND B-CDOCU.CodDoc = CcbCdocu.Codref
            AND B-CDOCU.NroDoc = CcbCdocu.Nroref
            NO-LOCK NO-ERROR.
         IF NOT AVAILABLE B-CDOCU THEN NEXT.
    END.
    /* SACAMOS LOS DATOS DEL DOCUMENTO BASE */
    ASSIGN
        pCodDiv     = IF Ccbcdocu.DivOri <> '' THEN Ccbcdocu.DivOri ELSE Ccbcdocu.CodDiv
        pDivDes     = Ccbcdocu.CodDiv
        x-PorIgv    = Ccbcdocu.porigv
        x-CodVen    = Ccbcdocu.codven
        .
    /* ******************************************************* */
    IF LOOKUP(Ccbcdocu.CodDoc, 'N/C,A/C') > 0 THEN DO:
        /* SACAMOS LOS DATOS DEL DOCUMENTO DE REFERENCIA */
        FIND B-CDOCU WHERE B-CDOCU.Codcia = CcbCdocu.Codcia 
            AND B-CDOCU.CodDoc = CcbCdocu.Codref 
            AND B-CDOCU.NroDoc = CcbCdocu.Nroref 
            NO-LOCK NO-ERROR.
        IF AVAILABLE B-CDOCU THEN DO:
            ASSIGN
                pCodDiv     = (IF B-CDOCU.DivOri <> '' THEN B-CDOCU.DivOri ELSE B-CDOCU.CodDiv)
                x-PorIgv    = B-CDOCU.porigv
                x-CodVen    = B-CDOCU.codven
                .
        END.
    END.
    /* Ajuste de la division en los valores historicos */
    IF Ccbcdocu.codcli = '20511358907' THEN pCodDiv = '00022'.  /* STANDFORD */
    IF pCodDiv <> '00099' AND x-codven = '998' THEN pCodDiv = '00099'.   /* Exportaciones */
    IF pCodDiv <> '00098' AND x-codven = '157' THEN pCodDiv = '00098'.   /* Refiles */
    /* FACTURAS ANTICIPOS Y/O SERVICIOS SE VAN A OTRA DIVISION */
    IF LOOKUP(CcbCDocu.CodDoc,"TCK,FAC,BOL") > 0 AND LOOKUP(CcbCdocu.TpoFac, 'A,S') > 0 THEN pCodDiv = "99999".
    /* ADELANTOS DE CAMPAÑA VAN A OTRA DIVISION */
    IF CcbCDocu.CodDoc = "A/C" THEN pCodDiv = "99999".
    /* NOTAS DE CREDITO APLICADA A OTRAS VENTAS VAN A OTRA DIVISION */
    IF CcbCDocu.CodDoc = "N/C" AND LOOKUP(B-CDOCU.TpoFac, 'A,S') > 0 THEN pCodDiv = "99999".
    /* *********************************************************** */
    FIND B-DIVI WHERE B-DIVI.codcia = s-codcia AND B-DIVI.coddiv = pCodDiv NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-DIVI THEN NEXT.
    /* *********************************************************** */
    ASSIGN
        x-signo1 = ( IF LOOKUP(CcbCdocu.Coddoc, "N/C,A/C") > 0 THEN -1 ELSE 1 )
        x-ImpTot = Ccbcdocu.ImpTot.     /* <<< OJO <<< */
    /* buscamos si hay una aplicación de fact adelantada */
    FIND FIRST Ccbddocu OF Ccbcdocu WHERE Ccbddocu.implin < 0 NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbddocu THEN x-ImpTot = x-ImpTot + ABSOLUTE(Ccbddocu.ImpLin).
    /* ************************************************* */
    FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc NO-LOCK NO-ERROR.
    IF NOT AVAIL Gn-Tcmb THEN 
        FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc NO-LOCK NO-ERROR.
    IF AVAIL Gn-Tcmb THEN 
        ASSIGN
            x-TpoCmbCmp = Gn-Tcmb.Compra
            x-TpoCmbVta = Gn-Tcmb.Venta.
    /* VARIABLES DE VENTAS */
    ASSIGN
       x-Coe = 1
       x-Can = 1.
    /* OTRAS NOTAS DE CREDITO */
    OTROS:
    DO:
        /* FACTURAS POR ANTICIPOS Y/O SERVICIOS */
        IF LOOKUP(CcbCDocu.CodDoc,"FAC,BOL") > 0 AND LOOKUP(CcbCdocu.TpoFac, 'A,S') > 0 THEN DO:
            RUN PROCESA-OTRAS-VENTAS.   /* CODMAT = '999999' */
            NEXT ESTADISTICAS.
        END.
        /* ADELANTOS DE CAMPAÑA */
        IF CcbCDocu.CodDoc = "A/C" THEN DO:
            RUN PROCESA-OTRAS-VENTAS.   /* CODMAT = '999999' */
            NEXT ESTADISTICAS.
        END.
        /* *********************** */
        /* NOTAS DE CREDITO NUEVAS */
        /* *********************** */
        IF CcbCDocu.CodDoc = "N/C" AND CcbCdocu.CndCre = "N" AND CcbCdocu.TpoFac = "OTROS" THEN DO:
            RUN PROCESA-NC-DIFPRECIO.       /* RHC 04/02/2020 */
            NEXT ESTADISTICAS.
        END.
        /* *********************** */
        /* NOTAS DE CREDITO APLICADAS A FACTURAS DE SERVICIO Y/O ANTICIPOS DE CAMPAÑA */
        IF CcbCDocu.CodDoc = "N/C" AND LOOKUP(B-CDOCU.TpoFac, 'A,S') > 0 THEN DO:
            RUN PROCESA-OTRAS-VENTAS.   /* CODMAT = '999999' */
            NEXT ESTADISTICAS.
        END.
        /* NOTAS DE CREDITO POR OTROS CONCEPTOS */
        IF CcbCdocu.Coddoc = "N/C" AND CcbCdocu.CndCre = "N" AND Ccbcdocu.TpoFac <> "E" THEN DO:
            RUN PROCESA-NOTA.
            NEXT ESTADISTICAS.
        END.
        IF CcbCdocu.Coddoc = "N/C" AND CcbCdocu.CndCre = "N" AND Ccbcdocu.TpoFac = "E" THEN DO:
            RUN PROCESA-NOTA-REBADE.
            NEXT ESTADISTICAS.
        END.
    END.
    /* CONTINUAMOS CON FACTURAS Y NOTAS DE CREDITO POR DEVOLUCION */
    FOR EACH CcbDdocu OF CcbCdocu NO-LOCK:
       /* ****************** Filtros ************************* */
       FIND FIRST Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia 
           AND Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Almmmatg THEN NEXT.
       IF Ccbddocu.implin < 0 THEN NEXT.       /* <<< OJO <<< */
       /* **************************************************** */
       RUN Carga-Ventas-Detalle.
    END.
    /* FACTURAS Y BOLETAS QUE TENGAN UNA APLICACION DE ANTICIPOS */
    IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') > 0
        AND Ccbcdocu.ImpTot2 > 0 THEN DO:
        RUN PROCESA-ANTCIPOS-APLICADOS.
    END.
END.

FOR EACH Detalle NO-LOCK:
    FIND Resumen WHERE Resumen.coddiv = Detalle.CodDiv
        AND Resumen.DateKey = Detalle.DateKey
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Resumen THEN CREATE Resumen.
    ASSIGN
        Resumen.coddiv = Detalle.CodDiv
        Resumen.DateKey = Detalle.DateKey
        Resumen.ImpNacCIGV = Resumen.ImpNacCIGV + Detalle.ImpNacCIGV
        Resumen.ImpExtCIGV = Resumen.ImpExtCIGV + Detalle.ImpExtCIGV.
END.
FOR EACH Ventas_Cabecera NO-LOCK WHERE estavtas.Ventas_Cabecera.DateKey >= x-CodFchI
    AND estavtas.Ventas_Cabecera.DateKey <= x-CodFchF,
    EACH Ventas_Detalle OF Ventas_Cabecera NO-LOCK:
    FIND Resumen WHERE Resumen.CodDiv = Ventas_Cabecera.CodDiv
        AND Resumen.DateKey = Ventas_Cabecera.DateKey
        NO-ERROR.
    IF NOT AVAILABLE Resumen THEN CREATE Resumen.
    ASSIGN
        Resumen.CodDiv = Ventas_Cabecera.CodDiv
        Resumen.DateKey = Ventas_Cabecera.DateKey
        Resumen.FleteNacCIGV = Resumen.FleteNacCIGV + Ventas_Detalle.ImpNacCIGV
        Resumen.FleteExtCIGV = Resumen.FleteExtCIGV + Ventas_Detalle.ImpExtCIGV.
END.
/* FOR EACH Resumen EXCLUSIVE-LOCK:                                                     */
/*     FOR EACH Ventas_Cabecera NO-LOCK WHERE Ventas_Cabecera.DateKey = Resumen.DateKey */
/*         AND estavtas.Ventas_Cabecera.CodDiv = Resumen.CodDiv,                        */
/*         EACH Ventas_Detalle OF Ventas_Cabecera NO-LOCK:                              */
/*         ASSIGN                                                                       */
/*             Resumen.FleteNacCIGV = Resumen.FleteNacCIGV + Ventas_Detalle.ImpNacCIGV  */
/*             Resumen.FleteExtCIGV = Resumen.FleteExtCIGV + Ventas_Detalle.ImpExtCIGV. */
/*     END.                                                                             */
/* END.                                                                                 */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

