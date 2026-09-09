&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-MATG NO-UNDO LIKE Almmmatg.



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
DEF STREAM REPORTE.

/* Buscamos los valores generales */
FIND FIRST AlmCfgGn WHERE almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcfggn THEN DO:
    MESSAGE 'Debe configurar los parámetros generales' VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.

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
&Scoped-Define ENABLED-OBJECTS txt-codalm BUTTON-1 x-CodFam x-CodPro ~
BUTTON-6 BUTTON-7 
&Scoped-Define DISPLAYED-OBJECTS txt-codalm x-CodFam x-desFam x-CodPro ~
x-NomPro FILL-IN-DiasMinimo FILL-IN-DiasMaximo x-mensaje 

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
     SIZE 3 BY .88.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 6" 
     SIZE 6 BY 1.62.

DEFINE BUTTON BUTTON-7 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 7" 
     SIZE 6 BY 1.62.

DEFINE VARIABLE FILL-IN-DiasMaximo AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Dias máximo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-DiasMinimo AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Dias mínimo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY 1 NO-UNDO.

DEFINE VARIABLE txt-codalm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 58 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE x-CodPro AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE x-desFam AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.29 BY .88 NO-UNDO.

DEFINE VARIABLE x-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-codalm AT ROW 1.27 COL 11 COLON-ALIGNED WIDGET-ID 30
     BUTTON-1 AT ROW 1.27 COL 71 WIDGET-ID 62
     x-CodFam AT ROW 2.35 COL 11 COLON-ALIGNED WIDGET-ID 70
     x-desFam AT ROW 2.35 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     x-CodPro AT ROW 3.42 COL 11 COLON-ALIGNED WIDGET-ID 74
     x-NomPro AT ROW 3.42 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 76
     FILL-IN-DiasMinimo AT ROW 4.5 COL 11 COLON-ALIGNED WIDGET-ID 78
     FILL-IN-DiasMaximo AT ROW 4.5 COL 29 COLON-ALIGNED WIDGET-ID 80
     BUTTON-6 AT ROW 6.38 COL 3 WIDGET-ID 64
     BUTTON-7 AT ROW 6.38 COL 10 WIDGET-ID 66
     x-mensaje AT ROW 6.92 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 68
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 82.86 BY 9.08 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-MATG T "?" NO-UNDO INTEGRAL Almmmatg
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "STOCK PROYECTADO"
         HEIGHT             = 9.08
         WIDTH              = 82.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 82.86
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 82.86
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-DiasMaximo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DiasMinimo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-desFam IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* STOCK PROYECTADO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* STOCK PROYECTADO */
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

    DEF VAR x-Almacenes AS CHAR.
    x-Almacenes = txt-CodAlm:SCREEN-VALUE.
    RUN alm/d-repalm (INPUT-OUTPUT x-Almacenes).
    txt-CodAlm:SCREEN-VALUE = x-Almacenes.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
    ASSIGN txt-codalm x-codfam x-codpro FILL-IN-DiasMaximo FILL-IN-DiasMinimo.
    IF txt-codalm = "" THEN DO:
        MESSAGE "Debe seleccionar al menos un almacen" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF FILL-IN-DiasMaximo < FILL-IN-DiasMinimo THEN DO:
        MESSAGE 'Ingrese correctamente los días mínimo y máximo' 
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Button 7 */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-DiasMaximo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-DiasMaximo W-Win
ON LEAVE OF FILL-IN-DiasMaximo IN FRAME F-Main /* Dias máximo */
DO:
    IF INPUT {&self-name} <= 0 THEN DO:
        MESSAGE 'Debe ingresar información' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-DiasMinimo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-DiasMinimo W-Win
ON LEAVE OF FILL-IN-DiasMinimo IN FRAME F-Main /* Dias mínimo */
DO:
  IF INPUT {&self-name} <= 0 THEN DO:
      MESSAGE 'Debe ingresar información' VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodFam W-Win
ON LEAVE OF x-CodFam IN FRAME F-Main /* Familia */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND Almtfami WHERE Almtfami.codcia = s-codcia
      AND Almtfami.codfam = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almtfami THEN DO:
      MESSAGE "Familia no registrada" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  x-desfam:SCREEN-VALUE = Almtfami.desfam. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodPro W-Win
ON LEAVE OF x-CodPro IN FRAME F-Main /* Proveedor */
DO:
    IF SELF:SCREEN-VALUE = '' THEN DO:
        DISPLAY
            AlmCfgGn.DiasMinimo @ FILL-IN-DiasMinimo
            AlmCfgGn.DiasMaximo @ FILL-IN-DiasMaximo
            WITH FRAME {&FRAME-NAME}.
        RETURN.
    END.
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-prov THEN DO:
        MESSAGE "Proveedor no registrado" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    x-nompro:SCREEN-VALUE = gn-prov.nompro.
    IF gn-prov.StkMin >= 0 AND gn-prov.StkMax > 0 THEN DO:
        DISPLAY
            gn-prov.StkMin @ FILL-IN-DiasMinimo
            gn-prov.StkMax @ FILL-IN-DiasMaximo
            WITH FRAME {&FRAME-NAME}.
    END.
  
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
DEF VAR i AS INT NO-UNDO.
DEF VAR x-CodAlm AS CHAR NO-UNDO.
DEF VAR pVentaDiaria AS DEC NO-UNDO.
DEF VAR pDiasUtiles AS INT.
DEF VAR x-VentaDiaria AS DEC NO-UNDO.
DEF VAR x-StockMinimo AS DEC NO-UNDO.
DEF VAR x-StockMaximo AS DEC NO-UNDO.
DEF VAR pDiasMaximo AS INT.
DEF VAR pDiasMinimo AS INT.

FOR EACH T-MATG:
    DELETE T-MATG.
END.

/*
/* Buscamos los valores generales */
FIND FIRST AlmCfgGn WHERE almcfggn.codcia = s-codcia NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcfggn THEN DO:
    MESSAGE 'Debe configurar los parámetros generales' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.
*/

/* Cargamos stocks */
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codfam BEGINS x-CodFam
    AND Almmmatg.codpr1 BEGINS x-CodPro
    AND Almmmatg.TpoArt <> "D",
    FIRST Almtfami OF Almmmatg NO-LOCK WHERE Almtfami.SwComercial = YES
    BY Almmmatg.codmat:
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CALCULANDO STOCK: " + Almmmatg.codmat.
    CREATE T-MATG.
    BUFFER-COPY Almmmatg TO T-MATG.
    DO i = 1 TO NUM-ENTRIES(txt-codalm):
        FIND Almmmate WHERE Almmmate.codcia = s-codcia
            AND Almmmate.codalm = ENTRY(I, txt-codalm)
            AND Almmmate.codmat = Almmmatg.codmat
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmate THEN T-MATG.StkRep = T-MATG.StkRep + Almmmate.StkAct.
    END.
END.
/* Cargamos dias de stock */
FOR EACH T-MATG BY T-MATG.CodMat:
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CALCULANDO VENTAS: " + T-MATG.codmat.
    ASSIGN
        pDiasMinimo = FILL-IN-DiasMinimo
        pDiasMaximo = FILL-IN-DiasMaximo.
    /*
    /* Valores por defecto */
    ASSIGN
        pDiasMaximo = AlmCfgGn.DiasMaximo
        pDiasMinimo = AlmCfgGn.DiasMinimo
        pDiasUtiles = AlmCfgGn.DiasUtiles.
    /* Buscamos parametros del proveedor */
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = Almmmatg.codpr1
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov AND (gn-prov.stkmin > 0 AND gn-prov.stkmax > 0) THEN DO:
        ASSIGN
            pDiasMaximo = gn-prov.stkmax
            pDiasMinimo = gn-prov.stkmin.
    END.
    */
    ASSIGN
        x-StockMinimo = 0
        x-StockMaximo = 0
        x-VentaDiaria = 0.
    DO i = 1 TO NUM-ENTRIES(txt-codalm):
        x-CodAlm = ENTRY(i, txt-codalm).
        FIND Almmmate WHERE Almmmate.codcia = s-codcia
            AND Almmmate.codalm = x-CodAlm
            AND Almmmate.codmat = T-MATG.CodMat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN NEXT.
        /* Venta Diaria */
        RUN venta-diaria (ROWID(Almmmate), AlmCfgGn.DiasUtiles, Almmmate.CodAlm, OUTPUT pVentaDiaria).
        x-VentaDiaria = x-VentaDiaria + pVentaDiaria.
    END.
    /* Stock Minimo y Maximo */
    x-StockMinimo = ROUND (pDiasMinimo * x-VentaDiaria, 0).
    x-StockMaximo = ROUND (pDiasMaximo * x-VentaDiaria, 0).
    /* EMPAQUE */
    DEF VAR f-Canped AS DEC NO-UNDO.
    IF Almmmatg.CanEmp > 0 THEN DO:
        IF x-StockMinimo > 0 THEN DO:
            f-CanPed = x-StockMinimo.
            f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.CanEmp),0) * Almmmatg.CanEmp).
            x-StockMinimo = f-CanPed.
        END.
        IF x-StockMaximo > 0 THEN DO:
            f-CanPed = x-StockMaximo.
            f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.CanEmp),0) * Almmmatg.CanEmp).
            x-StockMaximo = f-CanPed.
        END.
    END.
    ASSIGN
        T-MATG.StkMin = x-StockMinimo
        T-MATG.StkMax = x-StockMaximo.
    IF x-VentaDiaria <> 0 THEN T-MATG.Libre_d01 = T-MATG.StkRep / x-VentaDiaria.
END.
x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

END PROCEDURE.

/*
/* Cargamos dias de stock */
FOR EACH T-MATG BY T-MATG.CodMat:
    x-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "CALCULANDO VENTAS: " + T-MATG.codmat.
    x-VentaDiaria = 0.
    DO i = 1 TO NUM-ENTRIES(txt-codalm):
        x-CodAlm = ENTRY(i, txt-codalm).
        FIND Almmmate WHERE Almmmate.codcia = s-codcia
            AND Almmmate.codalm = x-CodAlm
            AND Almmmate.codmat = T-MATG.CodMat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN NEXT.
        /* Acumulando minimos y maximos */
        ASSIGN
            T-MATG.StkMin = T-MATG.StkMin + Almmmate.StkMin
            T-MATG.StkMax = T-MATG.StkMax + Almmmate.StkMax.
        /* Venta Diaria */
        RUN venta-diaria (ROWID(Almmmate), AlmCfgGn.DiasUtiles, Almmmate.CodAlm, OUTPUT pVentaDiaria).
        x-VentaDiaria = x-VentaDiaria + pVentaDiaria.
    END.
    IF x-VentaDiaria <> 0 THEN T-MATG.Libre_d01 = T-MATG.StkRep / x-VentaDiaria.
END.
*/

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
  DISPLAY txt-codalm x-CodFam x-desFam x-CodPro x-NomPro FILL-IN-DiasMinimo 
          FILL-IN-DiasMaximo x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txt-codalm BUTTON-1 x-CodFam x-CodPro BUTTON-6 BUTTON-7 
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

SESSION:SET-WAIT-STATE('GENERAL').

/* Cargamos el temporal */
RUN Carga-Temporal.

/* Generamos el archivo texto */
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Llave AS CHAR FORMAT 'x(500)' NO-UNDO.

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".
OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
x-Llave = ''.
x-Llave = x-Llave + "Codigo" + CHR(9).
x-LLave = x-Llave + "Descripcion" + CHR(9).
x-LLave = x-Llave + "Marca" + CHR(9).
x-Llave = x-Llave + "Familia" + CHR(9).
x-LLave = x-LLave + "Sub-familia" + CHR(9).
x-Llave = x-Llave + "Stock" + CHR(9).
x-Llave = x-Llave + "Dias" + CHR(9).
x-Llave = x-Llave + "Stock minimo" + CHR(9).
x-Llave = x-LLave + "Stock maximo" + CHR(9).
x-Llave = x-Llave + "Costo" + CHR(9).
x-Llave = x-Llave + "Empaque" + CHR(9).
x-Llave = x-Llave + "".
PUT STREAM REPORTE x-LLave SKIP.
FOR EACH T-MATG:
    x-Llave = "".
    x-Llave = x-Llave + STRING(T-MATG.codmat, "999999") + CHR(9).
    x-Llave = x-Llave + T-MATG.desmat + CHR(9).
    x-Llave = x-Llave + T-MATG.desmar + CHR(9).
    x-LLave = x-LLave + T-MATG.codfam + CHR(9).
    x-Llave = x-LLave + T-MATG.subfam + CHR(9).
    x-LLave = x-Llave + STRING(T-MATG.stkrep) + CHR(9).
    x-Llave = x-LLave + STRING(T-MATG.libre_d01) + CHR(9).
    x-Llave = x-Llave + STRING(T-MATG.stkmin) + CHR(9).
    x-Llave = x-Llave + STRING(T-MATG.stkmax) + CHR(9).
    x-Llave = x-Llave + STRING(T-MATG.ctotot) + CHR(9).
    x-Llave = x-Llave + STRING(T-MATG.canemp) + CHR(9).
    x-Llave = x-Llave + "".
    PUT STREAM REPORTE x-LLave SKIP.
END.            
OUTPUT STREAM REPORTE CLOSE.
/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Proyeccion', YES).

SESSION:SET-WAIT-STATE('').


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
  /* Valores por defecto */
  ASSIGN
      FILL-IN-DiasMaximo = AlmCfgGn.DiasMaximo
      FILL-IN-DiasMinimo = AlmCfgGn.DiasMinimo.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
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
        WHEN "" THEN .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE venta-diaria W-Win 
PROCEDURE venta-diaria :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pDiasUtiles AS INT.
DEF INPUT PARAMETER pAlmacenes AS CHAR.
DEF OUTPUT PARAMETER pVentaDiaria AS DEC.

FIND Almmmate WHERE ROWID(Almmmate) = pRowid
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmate THEN RETURN.

FIND Almmmatg OF Almmmate NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.

FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = pAlmacenes NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN RETURN.

/* determinamos las fechas de venta */
DEF VAR x-FchIni-Ant AS DATE NO-UNDO.
DEF VAR x-FchFin-Ant AS DATE NO-UNDO.
DEF VAR x-FchIni-Hoy AS DATE NO-UNDO.
DEF VAR x-FchFin-Hoy AS DATE NO-UNDO.
DEF VAR x-Venta-Ant AS DEC NO-UNDO.
DEF VAR x-Venta-Hoy AS DEC NO-UNDO.
DEF VAR x-Venta-Mes AS DEC NO-UNDO.

DEF VAR x-Mes AS INT NO-UNDO.
DEF VAR x-Ano AS INT NO-UNDO.
DEF VAR x-Meses AS INT INIT 3 NO-UNDO.      /* Meses de estudio estadístico */

/* 21.08.09 ahora hay que retroceder 365 dias */
x-FchFin-Ant = TODAY - 365.
x-FchIni-Ant = x-FchFin-Ant - x-Meses * 30.

/*RUN Venta-Diaria-Promedio-Estadistica (x-FchIni-Ant, x-FchFin-Ant, OUTPUT x-Venta-Ant).*/
RUN vtagn/ventas-promedio-01 (x-FchIni-Ant, x-FchFin-Ant, pAlmacenes, Almmmatg.codmat, OUTPUT x-Venta-Ant).

/* 21.08.09 ahora hay que retroceder 365 dias */
x-FchFin-Hoy = TODAY.
x-FchIni-Hoy = x-FchFin-Hoy - x-Meses * 30.

/*RUN Venta-Diaria-Promedio-Estadistica (x-FchIni-Hoy, x-FchFin-Hoy, OUTPUT x-Venta-Hoy).*/
RUN vtagn/ventas-promedio-01 (x-FchIni-Hoy, x-FchFin-Hoy, pAlmacenes, Almmmatg.codmat, OUTPUT x-Venta-Hoy).

/* 21.08.09 ahora hay que retroceder 365 dias */
x-FchFin-Ant = TODAY - 365.
x-FchIni-Ant = x-FchFin-Ant - 30.

/*RUN Venta-Diaria-Promedio-Estadistica (x-FchIni-Ant, x-FchFin-Ant, OUTPUT x-Venta-Mes).*/
RUN vtagn/ventas-promedio-01 (x-FchIni-Ant, x-FchFin-Ant, pAlmacenes, Almmmatg.codmat, OUTPUT x-Venta-Mes).

IF x-Venta-Ant <= 0 THEN DO:
    pVentaDiaria = x-Venta-Hoy.
    RETURN.
END.
IF ( x-Venta-Hoy / x-Venta-Ant ) > 3 OR ( x-Venta-Hoy / x-Venta-Ant ) < (1 / 3) THEN DO: 
    pVentaDiaria = x-Venta-Hoy.
    RETURN.
END.
IF ( x-Venta-Hoy / x-Venta-Mes ) > 3 OR ( x-Venta-Hoy / x-Venta-Mes ) < (1 / 3) THEN DO: 
    pVentaDiaria = x-Venta-Hoy.
    RETURN.
END.
pVentaDiaria = x-Venta-Hoy / x-Venta-Ant * x-Venta-Mes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

