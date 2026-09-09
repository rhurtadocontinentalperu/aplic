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

DEFINE VAR dInicioRiqra AS DATE.

dInicioRiqra = DATE(05,06,2024). /* m,d,a */

DEFINE TEMP-TABLE tDataPedComercial 
    FIELD coddoc AS CHAR FORMAT 'x(5)' COLUMN-LABEL "Cod.Ped.Comercial"
    FIELD nrodoc AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Nro.Ped.Comercial"
    FIELD fchdoc AS DATE COLUMN-LABEL "Fecha Emision Ped.Comercial"
    FIELD horadoc AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Hora Emision Ped.Comercial"
    FIELD codcli AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Cod.Cliente"
    FIELD nomcli AS CHAR FORMAT 'x(80)' COLUMN-LABEL "Nombre del Cliente"
    FIELD dnicli AS CHAR FORMAT 'x(12)' COLUMN-LABEL "DNI"
    FIELD ruc   AS CHAR FORMAT 'x(12)' COLUMN-LABEL "R.U.C."
    FIELD vend AS CHAR FORMAT 'x(5)' COLUMN-LABEL "CodVendedor"
    FIELD vendnom AS CHAR FORMAT 'x(5)' COLUMN-LABEL "NombreVendedor"
    FIELD usuario AS CHAR FORMAT 'x(25)' COLUMN-LABEL "Usuario"
    FIELD desusuario AS CHAR FORMAT 'x(25)' COLUMN-LABEL "Datos del Usuario"
    FIELD coddiv AS CHAR FORMAT 'x(8)' COLUMN-LABEL "Division"
    FIELD flgest AS CHAR FORMAT 'x(50)' COLUMN-LABEL "Estado Ped.Comercial"
    FIELD codmat AS CHAR FORMAT 'x(50)' COLUMN-LABEL "SKU del Ped.Comercial"
    FIELD desmat AS CHAR FORMAT 'x(50)' COLUMN-LABEL "Descripcion SKU"
    FIELD cantpedcom AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Cant. Solicitada del SKU"
    FIELD ordcmp AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Pedido RIQRA"
    FIELD imptot AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Importe Ped.Comercial"
    FIELD impvvta AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Importe V.Venta Ped.Comercial"
    FIELD pesoitems AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Peso Kgrs Ped.Comercial" INIT 0
    FIELD volitems AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Volumen m3 Ped.Comercial" INIT 0
    INDEX idx01 coddoc nrodoc codmat.

DEFINE TEMP-TABLE tDataPedLogistico
    FIELD coddoc AS CHAR FORMAT 'x(5)' COLUMN-LABEL "Cod.Ped.Logistico"
    FIELD nrodoc AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Nro.Ped.Logistico"
    FIELD fchdoc AS DATE COLUMN-LABEL "Fecha Emision Ped.Logistico"
    FIELD horadoc AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Hora Emision Ped.Logistico"
    FIELD codcli AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Cod.Cliente"
    FIELD nomcli AS CHAR FORMAT 'x(80)' COLUMN-LABEL "Nombre del Cliente"
    FIELD dnicli AS CHAR FORMAT 'x(12)' COLUMN-LABEL "DNI"
    FIELD ruc   AS CHAR FORMAT 'x(12)' COLUMN-LABEL "R.U.C."
    FIELD vend AS CHAR FORMAT 'x(5)' COLUMN-LABEL "CodVendedor"
    FIELD vendnom AS CHAR FORMAT 'x(5)' COLUMN-LABEL "NombreVendedor"
    FIELD usuario AS CHAR FORMAT 'x(25)' COLUMN-LABEL "Usuario"
    FIELD desusuario AS CHAR FORMAT 'x(25)' COLUMN-LABEL "Datos del Usuario"
    FIELD coddiv AS CHAR FORMAT 'x(8)' COLUMN-LABEL "Division"
    FIELD flgest AS CHAR FORMAT 'x(50)' COLUMN-LABEL "Estado Ped.Logistico"
    FIELD codmat AS CHAR FORMAT 'x(50)' COLUMN-LABEL "SKU del Ped.Logistico"
    FIELD desmat AS CHAR FORMAT 'x(50)' COLUMN-LABEL "Descripcion SKU"
    FIELD cantpedlog AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Cant.del SKU Ped.Logistico"
    FIELD imptot AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Importe Ped.Logistico"
    FIELD impvvta AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Importe V.Venta Ped.Logistico"
    FIELD pesoitems AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Peso Kgrs Ped.Logistico" INIT 0
    FIELD volitems AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Volumen m3 Ped.Logistico" INIT 0
    FIELD cododlog AS CHAR FORMAT 'x(5)' COLUMN-LABEL "Cod.O/D"
    FIELD nroodlog AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Nro.O/D"
    FIELD fchodlog AS DATE COLUMN-LABEL "Fecha Emision O/D"
    FIELD horaodlog AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Hora Emision O/D"
    FIELD flgestodlog AS CHAR FORMAT 'x(50)' COLUMN-LABEL "Estado O/D"
    FIELD codlinea AS CHAR FORMAT 'x(5)' COLUMN-LABEL "Cod.Linea"
    FIELD deslinea AS CHAR FORMAT 'x(50)' COLUMN-LABEL "descripcion Linea"
    FIELD ordcmp AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Pedido RIQRA"
    FIELD nrodoccom AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Nro.Ped.Comercial"
    INDEX idx01 coddoc nrodoc codmat.


    DEFINE BUFFER b-faccpedi FOR faccpedi.
    DEFINE BUFFER o-faccpedi FOR faccpedi.


        /*
    FIELD coddoc AS CHAR FORMAT 'x(5)' COLUMN-LABEL "Cod.Ped.Comercial"
    FIELD nrodoc AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Nro.Ped.Comercial"
    FIELD fchdoc AS DATE COLUMN-LABEL "Fecha Emision Ped.Comercial"
    FIELD horadoc AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Hora Emision Ped.Comercial"
    FIELD codcli AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Cod.Cliente"
    FIELD nomcli AS CHAR FORMAT 'x(80)' COLUMN-LABEL "Nombre del Cliente"
    FIELD dnicli AS CHAR FORMAT 'x(12)' COLUMN-LABEL "DNI"
    FIELD ruc   AS CHAR FORMAT 'x(12)' COLUMN-LABEL "R.U.C."
    FIELD vend AS CHAR FORMAT 'x(5)' COLUMN-LABEL "CodVendedor"
    FIELD vendnom AS CHAR FORMAT 'x(5)' COLUMN-LABEL "NombreVendedor"
    FIELD usuario AS CHAR FORMAT 'x(25)' COLUMN-LABEL "Usuario"
    FIELD desusuario AS CHAR FORMAT 'x(25)' COLUMN-LABEL "Datos del Usuario"
    FIELD coddiv AS CHAR FORMAT 'x(8)' COLUMN-LABEL "Division"
    FIELD flgest AS CHAR FORMAT 'x(50)' COLUMN-LABEL "Estado Ped.Comercial"
    FIELD ordcmp AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Pedido RIQRA"
    FIELD imptot AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Importe Total Ped.Comercial"
    FIELD impvvta AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Importe V.Venta Ped.Comercial"
    FIELD items AS INT FORMAT '->>>,>>>,>>9' COLUMN-LABEL "Items del Ped.Comercial" INIT 0
    FIELD cantitems AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Cantidades del Ped.Comercial" INIT 0    
    FIELD pesoitems AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Peso Kgrs Ped.Comercial" INIT 0
    FIELD volitems AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Volumen m3 Ped.Comercial" INIT 0
    FIELD codpedlog AS CHAR FORMAT 'x(5)' COLUMN-LABEL "Cod.Ped.Logistico"
    FIELD nropedlog AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Nro.Ped.Logistico"
    FIELD fchpedlog AS DATE COLUMN-LABEL "Fecha Emision Ped.Logistica"
    FIELD horapedlog AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Hora Emision Ped.Logistico"
    FIELD flgestpedlog AS CHAR FORMAT 'x(50)' COLUMN-LABEL "Estado Ped.Logistico"
    FIELD cododlog AS CHAR FORMAT 'x(5)' COLUMN-LABEL "Cod.O/D"
    FIELD nroodlog AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Nro.O/D"
    FIELD fchodlog AS DATE COLUMN-LABEL "Fecha Emision O/D"
    FIELD horaodlog AS CHAR FORMAT 'x(15)' COLUMN-LABEL "Hora Emision O/D"
    FIELD flgestodlog AS CHAR FORMAT 'x(50)' COLUMN-LABEL "Estado O/D"
    FIELD codlinea AS CHAR FORMAT 'x(5)' COLUMN-LABEL "Cod.Linea"
    FIELD deslinea AS CHAR FORMAT 'x(50)' COLUMN-LABEL "descripcion Linea"
    FIELD imptotlinea AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Importe Linea"
    FIELD itemsLinea AS INT FORMAT '->>>,>>>,>>9' COLUMN-LABEL "Items linea" INIT 0
    FIELD cantitemslinea AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Cantidades  linea" INIT 0
    FIELD pesoitemslinea AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Peso Kgrs linea" INIT 0
    FIELD volitemslinea AS DEC FORMAT '->>>,>>>,>>9.99' COLUMN-LABEL "Volumen m3 linea" INIT 0
    INDEX idx01 coddoc nrodoc codlinea.
        
        */

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-desde FILL-IN-hasta FILL-IN-ptovtas ~
TOGGLE-riqra RADIO-SET-resultado BUTTON-ruta BUTTON-procesar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-desde FILL-IN-hasta ~
FILL-IN-ptovtas TOGGLE-riqra RADIO-SET-resultado 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-procesar 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-ruta 
     LABEL "..." 
     SIZE 4 BY .81.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U INITIAL 05/06/24 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-ptovtas AS CHARACTER FORMAT "X(256)":U INITIAL "00031,00038,00011,00041,00032,00039,00014" 
     LABEL "Divisiones de ventas" 
     VIEW-AS FILL-IN 
     SIZE 53 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-ruta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ruta para el Excel" 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE RADIO-SET-resultado AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Solo pedido comercial", 1,
"Solo pedido logistico", 2,
"Ambos", 3
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE TOGGLE-linea AS LOGICAL INITIAL no 
     LABEL "Detallado por linea de producto" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-riqra AS LOGICAL INITIAL no 
     LABEL "Solo pedidos de Riqra" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-desde AT ROW 1.81 COL 22 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-hasta AT ROW 1.81 COL 44 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-ptovtas AT ROW 3.15 COL 22 COLON-ALIGNED WIDGET-ID 6
     TOGGLE-linea AT ROW 4.5 COL 24 WIDGET-ID 8
     TOGGLE-riqra AT ROW 5.31 COL 24 WIDGET-ID 10
     RADIO-SET-resultado AT ROW 6.38 COL 21 NO-LABEL WIDGET-ID 20
     FILL-IN-ruta AT ROW 7.35 COL 14 COLON-ALIGNED WIDGET-ID 12
     BUTTON-ruta AT ROW 7.35 COL 76 WIDGET-ID 14
     BUTTON-procesar AT ROW 8.46 COL 30 WIDGET-ID 18
     "Elija la ruta" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 6.81 COL 72 WIDGET-ID 16
          FGCOLOR 9 FONT 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.57 BY 10.08
         FONT 4
         TITLE "Reporte de pedidos comerciales horizontales - Riqra" WIDGET-ID 100.


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
         TITLE              = "Pedidos comerciales Horizontales - Riqra"
         HEIGHT             = 10.08
         WIDTH              = 83.57
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 84.14
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 84.14
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
/* SETTINGS FOR FILL-IN FILL-IN-ruta IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       FILL-IN-ruta:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR TOGGLE-BOX TOGGLE-linea IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       TOGGLE-linea:HIDDEN IN FRAME F-Main           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Pedidos comerciales Horizontales - Riqra */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Pedidos comerciales Horizontales - Riqra */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-procesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-procesar W-Win
ON CHOOSE OF BUTTON-procesar IN FRAME F-Main /* Procesar */
DO:
  ASSIGN fill-in-desde FILL-IN-hasta fill-in-ptovtas toggle-linea toggle-riqra fill-in-ruta radio-set-resultado.

  RUN procesar.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-ruta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-ruta W-Win
ON CHOOSE OF BUTTON-ruta IN FRAME F-Main /* ... */
DO:
        DEFINE VAR lDirectorio AS CHAR.

        lDirectorio = "".

        SYSTEM-DIALOG GET-DIR lDirectorio  
           RETURN-TO-START-DIR 
           TITLE 'Directorio Files'.

    fill-in-ruta:SCREEN-VALUE = lDirectorio.
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
  DISPLAY FILL-IN-desde FILL-IN-hasta FILL-IN-ptovtas TOGGLE-riqra 
          RADIO-SET-resultado 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-desde FILL-IN-hasta FILL-IN-ptovtas TOGGLE-riqra 
         RADIO-SET-resultado BUTTON-ruta BUTTON-procesar 
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
  fill-in-desde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(dInicioRiqra,"99/99/9999").
  fill-in-hasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar W-Win 
PROCEDURE procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*ASSIGN fill-in-desde FILL-IN-hasta fill-in-ptovtas toggle-linea toggle-riqra fill-in-ruta.*/

IF fill-in-desde = ? OR  FILL-IN-hasta = ? THEN DO:
    MESSAGE "Debe ingresar fechas" VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

IF fill-in-desde > FILL-IN-hasta  THEN DO:
    MESSAGE "Fechas estan ingresados incorrectamente" VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

IF fill-in-desde < dinicioRiqra  THEN DO:
    MESSAGE "La operaciones de Riqra empezaron el 05 de Mayo de 2024" VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

IF TRUE <> (fill-in-ptovtas > "") THEN DO:
    MESSAGE "Debe ingresar al menos una division de venta" VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

IF TRUE <> (fill-in-ruta > "") THEN DO:
    MESSAGE "Debe ingresar la ruta donde se va grabar el Excel" VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

SESSION:SET-WAIT-STATE('GENERAL').
RUN procesar-paso1.
SESSION:SET-WAIT-STATE('').

MESSAGE "Proceso Concluido" VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-paso1 W-Win 
PROCEDURE procesar-paso1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR xCantidad AS DEC.
    DEFINE VAR xPeso AS DEC.
    DEFINE VAR xVolumen AS DEC.
    DEFINE VAR xItems AS INT.

    DEFINE VAR xCantidadLinea AS DEC.
    DEFINE VAR xPesoLinea AS DEC.
    DEFINE VAR xVolumenLinea AS DEC.
    DEFINE VAR xItemsLinea AS INT.

    DEFINE VAR xEsNuevo AS INT.
    DEFINE VAR xEstadoPedCom AS CHAR.
    DEFINE VAR xEstadoPedLog AS CHAR.
    DEFINE VAR xEstadoPedOD AS CHAR.

    DEFINE VAR cFechaHora AS CHAR.

    DEFINE VAR cNameFile AS CHAR.
    DEFINE VAR cNameFileCom AS CHAR.
    DEFINE VAR cNameFileLog AS CHAR.

    DEFINE VAR cMeses AS CHAR INIT "Ene,Feb,Mar,Abr,May,Jun,Jul,Ago,Set,Oct,Nov,Dic".
    DEFINE VAR cPara AS CHAR INIT "Sistemas,Logistica,Comercial".
    cFechaHora = STRING(NOW,"99/99/9999 HH:MM:SS").
    cNameFile = ENTRY(1,cFechahora,"/") + ENTRY(INT(ENTRY(2,cFechahora,"/")),cMeses,",") + ENTRY(3,cFechahora,"/").
    cNameFile = REPLACE(cNameFile,":","-").
    cNameFile = REPLACE(cNameFile," ","_").

    cNameFileCom = "VtasHorizontales_pedcomercial_" + cNameFile.
    cNameFileLog = "VtasHorizontales_pedlogistico_" + cNameFile .

    /*cNameFile = cNameFile + "_" + ENTRY(xLogistica + 1,cPara,",") + ".xlsx" .*/

    EMPTY TEMP-TABLE tDataPedComercial.
    EMPTY TEMP-TABLE tDataPedLogistico.

    FOR EACH faccpedi WHERE codcia = 1 and faccpedi.coddoc = 'cot' AND faccpedi.fchped >= FILL-IN-desde NO-LOCK:

        IF faccpedi.fchped > FILL-IN-hasta THEN NEXT.
        
        IF faccpedi.fmapgo = '000'  THEN NEXT.
        
        IF toggle-riqra = YES THEN DO:
            IF faccpedi.codorigen <> 'riqra' OR SUBSTRING(faccpedi.ordcmp,1,1) <> 'P' THEN NEXT.
        END.        
        
        IF LOOKUP(faccpedi.coddiv,fill-in-ptovtas) = 0 THEN NEXT.
    
        /* Pedido Logistico */
        FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = 1 AND b-faccpedi.codref = faccpedi.coddoc AND
                                    b-faccpedi.nroref = faccpedi.nroped AND b-faccpedi.coddoc = 'PED' AND 
                                    b-faccpedi.flgest <> 'A' NO-LOCK NO-ERROR.    
        IF radio-set-resultado = 1 OR radio-set-resultado = 3 THEN DO:
            FIND FIRST gn-ven WHERE gn-ven.codcia = 1 AND gn-ven.codven = faccpedi.codven NO-LOCK NO-ERROR.
            FIND FIRST _user WHERE _user._userid = faccpedi.usuario NO-LOCK NO-ERROR.

            xCantidad = 0.
            xPeso = 0.
            xVolumen = 0.
            xItems = 0.
            FOR EACH facdpedi OF faccpedi NO-LOCK,
                    FIRST almmmatg OF facdpedi NO-LOCK :
                xCantidad = xCantidad + (facdpedi.canped * facdpedi.factor).
                xPeso = xPeso + ((facdpedi.canped * facdpedi.factor) * almmmatg.pesmat).
                xVolumen = xVolumen + ((facdpedi.canped * facdpedi.factor) * almmmatg.libre_d02).
                xItems = xItems + 1.
            END.

            xEstadoPedCom = faccpedi.flgest.
            CASE faccpedi.flgest:
                WHEN 'P' THEN ASSIGN xEstadoPedCom = "Pendiente por atender".
                WHEN 'C' THEN ASSIGN xEstadoPedCom = "Con pedido logistico".
                WHEN 'PV' THEN ASSIGN xEstadoPedCom = "Pendiente por autorizar".
                WHEN 'V' THEN ASSIGN xEstadoPedCom = "Vencido".
                WHEN 'A' THEN ASSIGN xEstadoPedCom = "Anulado en Progress".
                WHEN '' THEN ASSIGN xEstadoPedCom = "Pendiente de envio a progress".
            END.

            FOR EACH facdpedi OF faccpedi NO-LOCK,
                    FIRST almmmatg OF facdpedi NO-LOCK :

                FIND FIRST almtfam OF almmmatg NO-LOCK NO-ERROR.

                CREATE tDataPedComercial.
                ASSIGN tDataPedComercial.coddoc = faccpedi.coddoc
                        tDataPedComercial.nrodoc = faccpedi.nroped
                        tDataPedComercial.fchdoc = faccpedi.fchped
                        tDataPedComercial.horadoc = faccpedi.hora
                        tDataPedComercial.codcli = faccpedi.codcli
                        tDataPedComercial.nomcli = faccpedi.nomcli
                        tDataPedComercial.dnicli = faccpedi.dnicli
                        tDataPedComercial.ruc = faccpedi.ruc
                        tDataPedComercial.vend = faccpedi.codven
                        tDataPedComercial.vendnom = IF(AVAILABLE gn-ven) THEN gn-ven.nomven ELSE "No existe vendedor"
                        tDataPedComercial.usuario = faccpedi.usuario
                        tDataPedComercial.desusuario = IF (AVAILABLE _user) THEN _user._user-name ELSE ""
                        tDataPedComercial.coddiv = faccpedi.coddiv
                        tDataPedComercial.flgest = xEstadoPedCom
                        tDataPedComercial.codmat = facdpedi.codmat
                        tDataPedComercial.desmat = almmmatg.desmat
                        tDataPedComercial.cantpedcom = (facdpedi.canped * facdpedi.factor)
                        tDataPedComercial.ordcmp = faccpedi.ordcmp
                        tDataPedComercial.imptot = faccpedi.imptot
                        tDataPedComercial.impvvta = faccpedi.impvta
                        tDataPedComercial.pesoitems = xPeso
                        tDataPedComercial.volitems = xVolumen / 1000000.
            END.
        END.
        IF (radio-set-resultado = 2 OR radio-set-resultado = 3) AND AVAILABLE b-faccpedi THEN DO:
            FIND FIRST gn-ven WHERE gn-ven.codcia = 1 AND gn-ven.codven = b-faccpedi.codven NO-LOCK NO-ERROR.
            FIND FIRST _user WHERE _user._userid = b-faccpedi.usuario NO-LOCK NO-ERROR.
            /* O/D */
            FIND FIRST o-faccpedi WHERE o-faccpedi.codcia = 1 AND o-faccpedi.codref = b-faccpedi.coddoc AND
                                        o-faccpedi.nroref = b-faccpedi.nroped AND o-faccpedi.coddoc = 'O/D' AND 
                                        o-faccpedi.flgest <> 'A' NO-LOCK NO-ERROR.

            xCantidad = 0.
            xPeso = 0.
            xVolumen = 0.
            xItems = 0.
            FOR EACH facdpedi OF b-faccpedi NO-LOCK,
                    FIRST almmmatg OF facdpedi NO-LOCK :
                xCantidad = xCantidad + (facdpedi.canped * facdpedi.factor).
                xPeso = xPeso + ((facdpedi.canped * facdpedi.factor) * almmmatg.pesmat).
                xVolumen = xVolumen + ((facdpedi.canped * facdpedi.factor) * almmmatg.libre_d02).
                xItems = xItems + 1.
            END.

            xEstadoPedLog = "".
            xEstadoPedOD = "".
            RUN vta2\p-faccpedi-flgest.p(INPUT b-faccpedi.flgest, INPUT 'PED', OUTPUT xEstadoPedLog).
            xEstadoPedLog = b-faccpedi.flgest + " - " + xEstadoPedLog.  

            IF AVAILABLE o-faccpedi THEN DO:                
                RUN vta2\p-faccpedi-flgest.p(INPUT o-faccpedi.flgest, INPUT 'O/D', OUTPUT xEstadoPedOD).
                xEstadoPedOD = o-faccpedi.flgest + " - " + xEstadoPedOD.  
            END.            

            FOR EACH facdpedi OF b-faccpedi NO-LOCK,
                    FIRST almmmatg OF facdpedi NO-LOCK :

                FIND FIRST almtfam OF almmmatg NO-LOCK NO-ERROR.

                CREATE tDataPedLogistico.
                ASSIGN tDataPedLogistico.coddoc = b-faccpedi.coddoc
                        tDataPedLogistico.nrodoc = b-faccpedi.nroped
                        tDataPedLogistico.fchdoc = b-faccpedi.fchped
                        tDataPedLogistico.horadoc = b-faccpedi.hora
                        tDataPedLogistico.codcli = b-faccpedi.codcli
                        tDataPedLogistico.nomcli = b-faccpedi.nomcli
                        tDataPedLogistico.dnicli = b-faccpedi.dnicli
                        tDataPedLogistico.ruc = b-faccpedi.ruc
                        tDataPedLogistico.vend = b-faccpedi.codven
                        tDataPedLogistico.vendnom = IF(AVAILABLE gn-ven) THEN gn-ven.nomven ELSE "No existe vendedor"
                        tDataPedLogistico.usuario = b-faccpedi.usuario
                        tDataPedLogistico.desusuario = IF (AVAILABLE _user) THEN _user._user-name ELSE ""
                        tDataPedLogistico.coddiv = b-faccpedi.coddiv
                        tDataPedLogistico.flgest = xEstadoPedLog
                        tDataPedLogistico.codmat = facdpedi.codmat
                        tDataPedLogistico.desmat = almmmatg.desmat
                        tDataPedLogistico.cantpedlog = (facdpedi.canped * facdpedi.factor)
                        tDataPedLogistico.imptot = b-faccpedi.imptot
                        tDataPedLogistico.impvvta = b-faccpedi.impvta
                        tDataPedLogistico.pesoitems = xPeso
                        tDataPedLogistico.volitems = xVolumen / 1000000
                        tDataPedLogistico.nrodoccom = faccpedi.nroped
                        tDataPedLogistico.ordcmp = b-faccpedi.ordcmp
                        tDataPedLogistico.codlinea = almmmatg.codfam
                        tDataPedLogistico.deslinea = IF (AVAILABLE almtfam) THEN almtfam.desfam ELSE "Linea inexistente".

                       IF AVAILABLE o-faccpedi THEN DO:
                           ASSIGN tDataPedLogistico.cododlog = o-faccpedi.coddoc
                                   tDataPedLogistico.nroodlog = o-faccpedi.nroped
                                   tDataPedLogistico.fchodlog = o-faccpedi.fchped
                                   tDataPedLogistico.horaodlog = o-faccpedi.hora
                                   tDataPedLogistico.flgestodlog = xEstadoPedOD.
                       END.
            END.
        END.
    
    END.

    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN lib\Tools-to-excel PERSISTENT SET hProc.
    
    def var c-csv-file as char no-undo.
    def var c-xls-file as char no-undo. /* will contain the XLS file path created */
       
    /*c-xls-file = 'd:\xpciman\VentasHorizontalesHasta11Jun2024_18_15pm.xlsx'.*/
    IF radio-set-resultado = 1 OR radio-set-resultado = 3 THEN DO:
        c-xls-file = fill-in-ruta + '\' + cNameFileCom.

        run pi-crea-archivo-csv IN hProc (input  buffer tdataPedComercial:handle,
                                /*input  session:temp-directory + "file"*/ c-xls-file,
                                output c-csv-file) .

        run pi-crea-archivo-xls  IN hProc (input  buffer tdataPedComercial:handle,
                                input  c-csv-file,
                                output c-xls-file) .

    END.
    IF radio-set-resultado = 2 OR radio-set-resultado = 3 THEN DO:
        c-xls-file = fill-in-ruta + '\' + cNameFileLog.

        run pi-crea-archivo-csv IN hProc (input  buffer tdataPedLogistico:handle,
                                /*input  session:temp-directory + "file"*/ c-xls-file,
                                output c-csv-file) .

        run pi-crea-archivo-xls  IN hProc (input  buffer tdataPedLogistico:handle,
                                input  c-csv-file,
                                output c-xls-file) .

    END.
    
    DELETE PROCEDURE hProc.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-paso1old W-Win 
PROCEDURE procesar-paso1old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    DEFINE VAR xCantidad AS DEC.
    DEFINE VAR xPeso AS DEC.
    DEFINE VAR xVolumen AS DEC.
    DEFINE VAR xItems AS INT.

    DEFINE VAR xCantidadLinea AS DEC.
    DEFINE VAR xPesoLinea AS DEC.
    DEFINE VAR xVolumenLinea AS DEC.
    DEFINE VAR xItemsLinea AS INT.

    DEFINE VAR xEsNuevo AS INT.
    DEFINE VAR xEstado AS CHAR.

    DEFINE VAR cFechaHora AS CHAR.
    DEFINE VAR cNameFile AS CHAR.
    DEFINE VAR cMeses AS CHAR INIT "Ene,Feb,Mar,Abr,May,Jun,Jul,Ago,Set,Oct,Nov,Dic".
    DEFINE VAR cPara AS CHAR INIT "Sistemas,Logistica,Comercial".
    cFechaHora = STRING(NOW,"99/99/9999 HH:MM:SS").
    cNameFile = ENTRY(1,cFechahora,"/") + ENTRY(INT(ENTRY(2,cFechahora,"/")),cMeses,",") + ENTRY(3,cFechahora,"/").
    cNameFile = REPLACE(cNameFile,":","-").
    cNameFile = REPLACE(cNameFile," ","_").

    IF toggle-linea = YES THEN DO:
        cNameFile = "VtasHorizontales_x_linea_" + cNameFile .
    END.
    ELSE DO:
        cNameFile = "VtasHorizontales_" + cNameFile .
    END.

    /*cNameFile = cNameFile + "_" + ENTRY(xLogistica + 1,cPara,",") + ".xlsx" .*/

    EMPTY TEMP-TABLE tDataPedComercial.
    EMPTY TEMP-TABLE tDataPedLogistico.

    FOR EACH faccpedi WHERE codcia = 1 and faccpedi.coddoc = 'cot' AND faccpedi.fchped >= FILL-IN-desde NO-LOCK:

        IF faccpedi.fchped > FILL-IN-hasta THEN NEXT.
        
        IF faccpedi.fmapgo = '000'  THEN NEXT.
        
        IF toggle-riqra = YES THEN DO:
            IF faccpedi.codorigen <> 'riqra' OR SUBSTRING(faccpedi.ordcmp,1,1) <> 'P' THEN NEXT.
        END.        
        
        IF LOOKUP(faccpedi.coddiv,fill-in-ptovtas) = 0 THEN NEXT.
    
        FIND FIRST gn-ven WHERE gn-ven.codcia = 1 AND gn-ven.codven = faccpedi.codven NO-LOCK NO-ERROR.
        FIND FIRST _user WHERE _user._userid = faccpedi.usuario NO-LOCK NO-ERROR.
    
        FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = 1 AND b-faccpedi.codref = faccpedi.coddoc AND
                                    b-faccpedi.nroref = faccpedi.nroped AND b-faccpedi.coddoc = 'PED' AND 
                                    b-faccpedi.flgest <> 'A' NO-LOCK NO-ERROR.
    
        xCantidad = 0.
        xPeso = 0.
        xVolumen = 0.
        xItems = 0.
        FOR EACH facdpedi OF faccpedi NO-LOCK,
                FIRST almmmatg OF facdpedi NO-LOCK :
            xCantidad = xCantidad + (facdpedi.canped * facdpedi.factor).
            xPeso = xPeso + ((facdpedi.canped * facdpedi.factor) * almmmatg.pesmat).
            xVolumen = xVolumen + ((facdpedi.canped * facdpedi.factor) * almmmatg.libre_d02).
            xItems = xItems + 1.
        END.
    
        xCantidadLinea = 0.
        xPesoLinea = 0.
        xVolumenLinea = 0.
        xItemsLinea = 0.
    
        FOR EACH facdpedi OF faccpedi NO-LOCK,
                FIRST almmmatg OF facdpedi NO-LOCK :
            xCantidadLinea =  (facdpedi.canped * facdpedi.factor).
            xPesoLinea = ((facdpedi.canped * facdpedi.factor) * almmmatg.pesmat).
            xVolumenLinea = ((facdpedi.canped * facdpedi.factor) * almmmatg.libre_d02).
    
            FIND FIRST almtfam OF almmmatg NO-LOCK NO-ERROR.
    
            xEsNuevo = 0.       
            IF toggle-linea = YES THEN DO:
                /* Comercial */
                FIND FIRST tData WHERE tData.coddoc = faccpedi.coddoc AND
                                        tData.nrodoc = faccpedi.nroped AND
                                        tData.codlinea = almmmatg.codfam EXCLUSIVE-LOCK NO-ERROR.                
            END.
            ELSE DO:
                FIND FIRST tData WHERE tData.coddoc = faccpedi.coddoc AND
                                        tData.nrodoc = faccpedi.nroped EXCLUSIVE-LOCK NO-ERROR.
            END.
            IF NOT AVAILABLE tData THEN DO:
                xEsNuevo = 1.
                CREATE tData.
                ASSIGN tData.coddoc = faccpedi.coddoc
                        tData.nrodoc = faccpedi.nroped
                        tData.fchdoc = faccpedi.fchped
                        tData.horadoc = faccpedi.hora
                        tData.codcli = faccpedi.codcli
                        tData.nomcli = faccpedi.nomcli
                        tData.dnicli = faccpedi.dnicli
                        tData.vend = faccpedi.codven
                        tData.vendnom = IF(AVAILABLE gn-ven) THEN gn-ven.nomven ELSE "No existe vendedor"
                        tData.ruc = faccpedi.ruc
                        tData.usuario = faccpedi.usuario
                        tData.desusuario = IF (AVAILABLE _user) THEN _user._user-name ELSE ""
                        tData.coddiv = faccpedi.coddiv
                        tData.flgest = faccpedi.flgest
                        tData.ordcmp = faccpedi.ordcmp               
                        tData.imptot = faccpedi.imptot
                        tData.imptotlinea = 0
                        tData.impvvta = faccpedi.impvta
                        tData.cantitems = xCantidad
                        tData.items = xItems
                        tData.pesoitems = xPeso
                        tData.volitems = xVolumen / 1000000.
    
                IF toggle-linea = YES THEN DO:
                    ASSIGN tData.codlinea = almmmatg.codfam
                            tData.deslinea = almtfam.desfam.
                END.
            END.
            
            IF toggle-linea = YES THEN DO:
                ASSIGN tData.imptotlinea = tData.imptotlinea + facdpedi.implin.
                ASSIGN  tData.cantitemsLinea = tData.cantitemsLinea + xCantidadLinea
                        tData.itemsLinea = tData.itemsLinea + 1
                        tData.pesoitemsLinea = tData.pesoitemsLinea + xPesoLinea
                        tData.volitemsLinea = tData.volitemsLinea + (xVolumenLinea / 1000000).
            END.
            /**/
            IF xEsNuevo = 1 THEN DO:
                IF AVAILABLE b-faccpedi THEN DO:
    
                    ASSIGN tData.codpedlog = b-faccpedi.coddoc
                            tData.nropedlog = b-faccpedi.nroped
                            tData.fchpedlog = b-faccpedi.fchped
                            tData.horapedlog = b-faccpedi.hora
                            tData.flgestpedlog = b-faccpedi.flgest.
    
                    FIND FIRST o-faccpedi WHERE o-faccpedi.codcia = 1 AND o-faccpedi.codref = b-faccpedi.coddoc AND
                                                o-faccpedi.nroref = b-faccpedi.nroped AND o-faccpedi.coddoc = 'O/D' AND 
                                                o-faccpedi.flgest <> 'A' NO-LOCK NO-ERROR.
    
                    IF AVAILABLE o-faccpedi THEN DO:
                        ASSIGN tData.cododlog = o-faccpedi.coddoc
                                tData.nroodlog = o-faccpedi.nroped
                                tData.fchodlog = o-faccpedi.fchped
                                tData.horaodlog = o-faccpedi.hora
                                tData.flgestodlog = o-faccpedi.flgest.
                    END.
                END.
    
                CASE tData.flgest:
                    WHEN 'P' THEN ASSIGN tData.flgest = "Pendiente por atender".
                    WHEN 'C' THEN ASSIGN tData.flgest = "Con pedido logistico".
                    WHEN 'PV' THEN ASSIGN tData.flgest = "Pendiente por autorizar".
                    WHEN 'V' THEN ASSIGN tData.flgest = "Vencido".
                    WHEN 'A' THEN ASSIGN tData.flgest = "Anulado en Progress".
                    WHEN '' THEN ASSIGN tData.flgest = "Pendiente de envio a progress".
                END.
                /**/
                xEstado = "".
                RUN vta2\p-faccpedi-flgest.p(INPUT tData.flgestpedlog, INPUT 'PED', OUTPUT xEstado).
                xEstado = tData.flgestpedlog + " - " + xEstado.  
                ASSIGN tData.flgestpedlog = xEstado.
                /**/
                xEstado = "".
                RUN vta2\p-faccpedi-flgest.p(INPUT tData.flgestodlog, INPUT 'O/D', OUTPUT xEstado).
                xEstado = tData.flgestodlog + " - " + xEstado.  
                ASSIGN tData.flgestodlog = xEstado.
            END.
    
        END.
    
    END.

    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN lib\Tools-to-excel PERSISTENT SET hProc.
    
    def var c-csv-file as char no-undo.
    def var c-xls-file as char no-undo. /* will contain the XLS file path created */
       
    /*c-xls-file = 'd:\xpciman\VentasHorizontalesHasta11Jun2024_18_15pm.xlsx'.*/
    c-xls-file = fill-in-ruta + '\' + cNameFile.

    run pi-crea-archivo-csv IN hProc (input  buffer tdata:handle,
                            /*input  session:temp-directory + "file"*/ c-xls-file,
                            output c-csv-file) .
    
    run pi-crea-archivo-xls  IN hProc (input  buffer tdata:handle,
                            input  c-csv-file,
                            output c-xls-file) .
    
    DELETE PROCEDURE hProc.
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

