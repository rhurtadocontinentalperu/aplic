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

DEFINE TEMP-TABLE tt-prov-alm-art
        FIELDS tt-codpro AS CHAR FORMAT 'x(11)'
        FIELDS tt-codalm AS CHAR FORMAT 'x(3)'
        FIELDS tt-codmat AS CHAR FORMAT 'x(6)'
        FIELDS tt-desmat AS CHAR FORMAT 'x(80)'
        FIELDS tt-stkact AS DECIMAL INIT 0
        FIELDS tt-costo AS DECIMAL INIT 0
        FIELDS tt-dias AS DECIMAL INIT 0
        FIELDS tt-art-oc AS CHAR FORMAT 'x(1)' INIT 'N'

        INDEX idx01 IS PRIMARY tt-codpro tt-codalm tt-codmat.

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
&Scoped-Define ENABLED-OBJECTS txtDate btnProcesar 
&Scoped-Define DISPLAYED-OBJECTS txtDate 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnProcesar 
     LABEL "Excel" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtDate AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Proceso" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtDate AT ROW 5.23 COL 37 COLON-ALIGNED WIDGET-ID 2
     btnProcesar AT ROW 9.08 COL 50 WIDGET-ID 6
     "Seguimiento de Ordenes de Compra diaria - EXCEL" VIEW-AS TEXT
          SIZE 73.57 BY 1.54 AT ROW 1.96 COL 2.43 WIDGET-ID 4
          FGCOLOR 9 FONT 9
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 75.86 BY 10.62 WIDGET-ID 100.


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
         TITLE              = "Impresion de Ordenes de Compra"
         HEIGHT             = 10.62
         WIDTH              = 75.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 83.43
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 83.43
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Impresion de Ordenes de Compra */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Impresion de Ordenes de Compra */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnProcesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnProcesar W-Win
ON CHOOSE OF btnProcesar IN FRAME F-Main /* Excel */
DO:
  
    ASSIGN txtDate.

    RUN ue-excel.

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
  DISPLAY txtDate 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txtDate btnProcesar 
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

  txtDate:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 1,"99/99/9999").

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel W-Win 
PROCEDURE ue-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.
DEFINE VAR lSec AS INT.

DEFINE VAR lFecha AS CHAR.
DEFINE VAR lFechaTitulo AS CHAR.

lFecha = STRING(YEAR(txtDate),"9999").
lFecha = lFecha + STRING(MONTH(txtDate),"99").
lFecha = lFecha + STRING(DAY(txtDate),"99").

SESSION:SET-WAIT-STATE('GENERAL').

lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio solo para nuevos */
lNuevoFile = YES.       /* Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

iColumn = 2.
cColumn = STRING(iColumn).

cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Fecha de Proceso :" + STRING(txtDate,"99/99/9999").
chWorkSheet:Range(cRange):interior:colorindex = 36.
chWorkSheet:Range(cRange):FONT:bold = YES.

iColumn = iColumn + 2.
cColumn = STRING(iColumn).
cRange = "A" + cColumn + ":U" + cColumn.
chWorkSheet:Range(cRange):FONT:bold = YES.

cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "CodPro".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Nombre Proveedor".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Ordenes Compra".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "A".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "B".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "C".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "D".
cRange = "H" + cColumn.                           
chWorkSheet:Range(cRange):Value = "E".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "F".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Nuevos".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Actual".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "NroDias".
cRange = "M" + cColumn.
chWorkSheet:Range(cRange):Value = "Plazo".
cRange = "N" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Proveedor".
cRange = "O" + cColumn.
chWorkSheet:Range(cRange):Value = "O/C Acumulado".
cRange = "P" + cColumn.
chWorkSheet:Range(cRange):Value = "Nro Items".
cRange = "Q" + cColumn.
chWorkSheet:Range(cRange):Value = "Presupuestado".
cRange = "R" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Maximo".
cRange = "S" + cColumn.
chWorkSheet:Range(cRange):Value = "Items Maximo".
cRange = "T" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Maximos Observaciones".
cRange = "U" + cColumn.
chWorkSheet:Range(cRange):Value = "Item Maximos Observaciones".

FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND 
        vtatabla.tabla = 'OC-SEGUI' AND vtatabla.llave_c1 = lFecha NO-LOCK :
     iColumn = iColumn + 1.
     cColumn = STRING(iColumn).

     cRange = "A" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + vtatabla.llave_c2.
     cRange = "B" + cColumn.
     chWorkSheet:Range(cRange):Value = "'" + vtatabla.libre_c01.
     cRange = "C" + cColumn.
     chWorkSheet:Range(cRange):Value = Round(vtatabla.valor[1],0).
     cRange = "D" + cColumn.
     chWorkSheet:Range(cRange):Value = ROUND((vtatabla.valor[2] / vtatabla.valor[1]) * 100,2).
     cRange = "E" + cColumn.
     chWorkSheet:Range(cRange):Value = ROUND((vtatabla.valor[3] / vtatabla.valor[1]) * 100,2).
     cRange = "F" + cColumn.
     chWorkSheet:Range(cRange):Value = ROUND((vtatabla.valor[4] / vtatabla.valor[1]) * 100,2).
     cRange = "G" + cColumn.
     chWorkSheet:Range(cRange):Value = ROUND((vtatabla.valor[5] / vtatabla.valor[1]) * 100,2).
     cRange = "H" + cColumn.                           
     chWorkSheet:Range(cRange):Value = ROUND((vtatabla.valor[6] / vtatabla.valor[1]) * 100,2).
     cRange = "I" + cColumn.
     chWorkSheet:Range(cRange):Value = ROUND((vtatabla.valor[7] / vtatabla.valor[1]) * 100,2).
     cRange = "J" + cColumn.
     chWorkSheet:Range(cRange):Value = Round(vtatabla.valor[8],0) /*(tt-ranking[7] / tt-imp-oc) * 100*/.
     cRange = "K" + cColumn.
     chWorkSheet:Range(cRange):Value = Round(vtatabla.valor[9],0) .
     cRange = "L" + cColumn.
     chWorkSheet:Range(cRange):Value = round(vtatabla.valor[10],0).
     cRange = "M" + cColumn.
     chWorkSheet:Range(cRange):Value = vtatabla.libre_c02.
     cRange = "N" + cColumn.
     chWorkSheet:Range(cRange):Value = Round(vtatabla.valor[11],0).
     cRange = "O" + cColumn.
     chWorkSheet:Range(cRange):Value = round(vtatabla.valor[13],0).
     cRange = "P" + cColumn.
     chWorkSheet:Range(cRange):Value = round(vtatabla.valor[14],0).
     cRange = "Q" + cColumn.
     FIND lg-tabla WHERE lg-tabla.codcia = s-codcia
         AND lg-tabla.tabla = 'PRSPRV'
         AND lg-tabla.codigo = vtatabla.llave_c2
         NO-LOCK NO-ERROR.
/*      chWorkSheet:Range(cRange):Value = round(vtatabla.valor[12],0). */
     IF AVAILABLE lg-tabla THEN chWorkSheet:Range(cRange):Value = lg-tabla.valor[1].
     cRange = "R" + cColumn.
     chWorkSheet:Range(cRange):Value = round(if(vtatabla.valor[15] = 0) THEN vtatabla.valor[11] ELSE vtatabla.valor[15],0).
     cRange = "S" + cColumn.
/*      chWorkSheet:Range(cRange):Value = round(IF(vtatabla.valor[16] = 0) THEN vtatabla.valor[14] ELSE vtatabla.valor[16],0). */
     IF AVAILABLE lg-tabla THEN chWorkSheet:Range(cRange):Value = lg-tabla.valor[2].
     cRange = "T" + cColumn.
     chWorkSheet:Range(cRange):Value = if(vtatabla.valor[15] = 0) THEN "Stk Maximo Proveedor NO CONFIG" ELSE 
            IF (vtatabla.valor[11] > vtatabla.valor[15]) THEN "Stk Proveedor Excedido" ELSE "".
     cRange = "U" + cColumn.
     chWorkSheet:Range(cRange):Value = if(vtatabla.valor[16] = 0) THEN "Item Maximo NO CONFIG" ELSE 
            IF (vtatabla.valor[14] > vtatabla.valor[16]) THEN "Items Proveedor Excedido" ELSE "".


END.

DEFINE VAR lVenta AS DEC INIT 0.
DEFINE VAR lVentaOrig AS DEC INIT 0.
DEFINE VAR lSuma AS DEC INIT 0.
DEFINE VAR lCambio AS DEC INIT 0.

/* Pestaña 2 - Detalle de Ordenes */
chWorkSheet = chExcelApplication:Sheets:Item(2).

iColumn = 1.
cColumn = STRING(iColumn).

cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Nro O/C".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Cod.Articulo".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Descr.Articulo".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Moneda".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Cantidad".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Precio Unitario".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Impte.Original".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Impte Nuevos Soles".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Cod.Proveedor".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Nombre del Proveedor".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "Clasificacion".

FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND 
        vtatabla.tabla = 'OC-SEGUI' AND vtatabla.llave_c1 = lFecha NO-LOCK :
    FOR EACH lg-cocmp WHERE lg-cocmp.codcia = 1 
        AND lg-cocmp.fchdoc = txtDate AND lg-cocmp.tpodoc = 'N' 
        AND lg-cocmp.codpro = vtatabla.llave_c2 
        AND (lg-cocmp.flgsit <> 'X' AND lg-cocmp.flgsit <> 'A' ) NO-LOCK,
        EACH lg-docmp OF lg-cocmp NO-LOCK, 
        FIRST almmmatg OF lg-docmp NO-LOCK,
        FIRST Almtfami OF Almmmatg NO-LOCK WHERE Almtfami.SwComercial = YES  :
    
        FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND gn-prov.codpro = lg-cocmp.codpro NO-LOCK NO-ERROR.
    
        lcambio = IF(lg-cocmp.codmon = 2) THEN lg-cocmp.tpocmb ELSE 1.

        /*lVenta = ((lg-docmp.canpedi * lg-docmp.preuni) * lCambio).*/
        lVenta = ((lg-docmp.canpedi * lg-docmp.preuni)).
    
        lVenta = lVenta - (lVenta * (lg-docmp.dsctos[1] / 100)).
        lVenta = lVenta - (lVenta * (lg-docmp.dsctos[2] / 100)).
        lVenta = lVenta - (lVenta * (lg-docmp.dsctos[3] / 100)).
                                                         
        lVentaOrig = lVenta.
        lVenta = lVenta * lCambio.

        lSUma = lSuma + lVenta.
    
         iColumn = iColumn + 1.
         cColumn = STRING(iColumn).

         cRange = "A" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + string(lg-docmp.nrodoc,"999999").
         cRange = "B" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + lg-docmp.codmat.
         cRange = "C" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + almmmatg.desmat.
         cRange = "D" + cColumn.
         chWorkSheet:Range(cRange):Value = IF(lg-cocmp.codmon = 2) THEN "Dolares Americanos ($)" ELSE "Nuevos Soles (S/.)".
         cRange = "E" + cColumn.
         chWorkSheet:Range(cRange):Value = Round(lg-docmp.canpedi,2).
         cRange = "F" + cColumn.
         chWorkSheet:Range(cRange):Value = Round(lg-docmp.preuni,4).
         cRange = "G" + cColumn.
         chWorkSheet:Range(cRange):Value = round(lVentaOrig,2) .
         cRange = "H" + cColumn.
         chWorkSheet:Range(cRange):Value = Round(lVEnta,2).
         cRange = "I" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + vtatabla.llave_c2.
         cRange = "J" + cColumn.
         chWorkSheet:Range(cRange):Value = "'" + vtatabla.libre_c01.
         cRange = "K" + cColumn.
         chWorkSheet:Range(cRange):Value = almmmatg.tiprot[1].

    END.
END.

/*
chWorkSheet = chExcelApplication:Sheets:Item(2).

FOR EACH tt-prov-alm-art NO-LOCK :
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-prov-alm-art.tt-codpro.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-prov-alm-art.tt-codalm.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-prov-alm-art.tt-codmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-prov-alm-art.tt-stkact.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-prov-alm-art.tt-costo.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-prov-alm-art.tt-dias.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-prov-alm-art.tt-art-oc.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-prov-alm-art.tt-desmat.

END.
*/

SESSION:SET-WAIT-STATE('').

{lib\excel-close-file.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

