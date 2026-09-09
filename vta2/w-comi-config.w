&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
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
DEF SHARED VAR s-codcia AS INT.

/* Local Variable Definitions ---                                       */

DEF NEW SHARED VAR s-CodFam AS CHAR INIT '010'.     /* Productos Propios */

RUN Inicializa-Configuracion.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 BUTTON-2 BUTTON-10 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-canalvta-or AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-comi-010 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-comi-010-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-comi-convt-010 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-comi-convt-999 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-vendedores-excep-canalvta-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv10 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv10-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv10-4 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv10-5 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv10-7 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv97 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-comiconfig AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-comiconfig AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-10 
     LABEL "PARAMETROS A EXCEL" 
     SIZE 28 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "Imprimir Comisiones" 
     SIZE 19 BY 1.12.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 57 BY 11.73
     BGCOLOR 15 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-2 AT ROW 11.23 COL 85 WIDGET-ID 4
     BUTTON-10 AT ROW 13.12 COL 100 WIDGET-ID 8
     RECT-1 AT ROW 1.27 COL 51 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 128.86 BY 24.73 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 3
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "CONFIGURACION DE COMISIONES POR MARGEN DE UTILIDAD"
         HEIGHT             = 24.73
         WIDTH              = 128.86
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
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
ON END-ERROR OF W-Win /* CONFIGURACION DE COMISIONES POR MARGEN DE UTILIDAD */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONFIGURACION DE COMISIONES POR MARGEN DE UTILIDAD */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 W-Win
ON CHOOSE OF BUTTON-10 IN FRAME F-Main /* PARAMETROS A EXCEL */
DO:
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Imprimir Comisiones */
DO:
  RUN Imprime-Reporte IN h_v-comiconfig.
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
             INPUT  'aplic/adm/b-canalvta-or.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-canalvta-or ).
       RUN set-position IN h_b-canalvta-or ( 1.19 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-canalvta-or ( 12.12 , 47.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/v-comiconfig.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-comiconfig ).
       RUN set-position IN h_v-comiconfig ( 1.27 , 52.00 ) NO-ERROR.
       /* Size in UIB:  ( 9.81 , 52.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv97.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv97 ).
       RUN set-position IN h_p-updv97 ( 11.23 , 53.00 ) NO-ERROR.
       RUN set-size IN h_p-updv97 ( 1.42 , 31.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-new/objects/folder.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'Linea 10|Otras Lineas|Vendedor-Excp' + ',
                     FOLDER-TAB-TYPE = 1':U ,
             OUTPUT h_folder-2 ).
       RUN set-position IN h_folder-2 ( 13.38 , 2.00 ) NO-ERROR.
       RUN set-size IN h_folder-2 ( 12.12 , 127.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/q-comiconfig.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-comiconfig ).
       RUN set-position IN h_q-comiconfig ( 1.27 , 110.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.50 , 7.72 ) */

       /* Links to SmartViewer h_v-comiconfig. */
       RUN add-link IN adm-broker-hdl ( h_p-updv97 , 'TableIO':U , h_v-comiconfig ).
       RUN add-link IN adm-broker-hdl ( h_q-comiconfig , 'Record':U , h_v-comiconfig ).

       /* Links to SmartFolder h_folder-2. */
       RUN add-link IN adm-broker-hdl ( h_folder-2 , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-canalvta-or ,
             BUTTON-2:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-comiconfig ,
             h_b-canalvta-or , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv97 ,
             h_v-comiconfig , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder-2 ,
             BUTTON-10:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/b-comi-010.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-comi-010 ).
       RUN set-position IN h_b-comi-010 ( 14.73 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-comi-010 ( 8.81 , 59.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/b-comi-convt-010.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-comi-convt-010 ).
       RUN set-position IN h_b-comi-convt-010 ( 14.73 , 67.00 ) NO-ERROR.
       RUN set-size IN h_b-comi-convt-010 ( 8.62 , 59.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv10.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10 ).
       RUN set-position IN h_p-updv10 ( 23.62 , 4.00 ) NO-ERROR.
       RUN set-size IN h_p-updv10 ( 1.42 , 41.72 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv10.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10-4 ).
       RUN set-position IN h_p-updv10-4 ( 23.62 , 67.00 ) NO-ERROR.
       RUN set-size IN h_p-updv10-4 ( 1.42 , 41.72 ) NO-ERROR.

       /* Links to SmartBrowser h_b-comi-010. */
       RUN add-link IN adm-broker-hdl ( h_b-canalvta-or , 'Record':U , h_b-comi-010 ).
       RUN add-link IN adm-broker-hdl ( h_p-updv10 , 'TableIO':U , h_b-comi-010 ).

       /* Links to SmartBrowser h_b-comi-convt-010. */
       RUN add-link IN adm-broker-hdl ( h_p-updv10-4 , 'TableIO':U , h_b-comi-convt-010 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-comi-010 ,
             h_folder-2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-comi-convt-010 ,
             h_b-comi-010 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10 ,
             h_b-comi-convt-010 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10-4 ,
             h_p-updv10 , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/b-comi-010.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-comi-010-2 ).
       RUN set-position IN h_b-comi-010-2 ( 14.73 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-comi-010-2 ( 8.81 , 59.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/b-comi-convt-999.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-comi-convt-999 ).
       RUN set-position IN h_b-comi-convt-999 ( 14.73 , 67.00 ) NO-ERROR.
       RUN set-size IN h_b-comi-convt-999 ( 8.62 , 59.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv10.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10-2 ).
       RUN set-position IN h_p-updv10-2 ( 23.58 , 4.00 ) NO-ERROR.
       RUN set-size IN h_p-updv10-2 ( 1.42 , 41.72 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv10.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10-5 ).
       RUN set-position IN h_p-updv10-5 ( 23.62 , 67.00 ) NO-ERROR.
       RUN set-size IN h_p-updv10-5 ( 1.42 , 41.72 ) NO-ERROR.

       /* Links to SmartBrowser h_b-comi-010-2. */
       RUN add-link IN adm-broker-hdl ( h_b-canalvta-or , 'Record':U , h_b-comi-010-2 ).
       RUN add-link IN adm-broker-hdl ( h_p-updv10-2 , 'TableIO':U , h_b-comi-010-2 ).

       /* Links to SmartBrowser h_b-comi-convt-999. */
       RUN add-link IN adm-broker-hdl ( h_p-updv10-5 , 'TableIO':U , h_b-comi-convt-999 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-comi-010-2 ,
             h_folder-2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-comi-convt-999 ,
             h_b-comi-010-2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10-2 ,
             h_b-comi-convt-999 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10-5 ,
             h_p-updv10-2 , 'AFTER':U ).
    END. /* Page 2 */
    WHEN 3 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/b-vendedores-excep-canalvta-.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-vendedores-excep-canalvta-2 ).
       RUN set-position IN h_b-vendedores-excep-canalvta-2 ( 15.42 , 5.00 ) NO-ERROR.
       RUN set-size IN h_b-vendedores-excep-canalvta-2 ( 7.69 , 60.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv10.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Save,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv10-7 ).
       RUN set-position IN h_p-updv10-7 ( 23.50 , 8.00 ) NO-ERROR.
       RUN set-size IN h_p-updv10-7 ( 1.42 , 41.72 ) NO-ERROR.

       /* Links to SmartBrowser h_b-vendedores-excep-canalvta-2. */
       RUN add-link IN adm-broker-hdl ( h_p-updv10-7 , 'TableIO':U , h_b-vendedores-excep-canalvta-2 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-vendedores-excep-canalvta-2 ,
             h_folder-2 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv10-7 ,
             h_b-vendedores-excep-canalvta-2 , 'AFTER':U ).
    END. /* Page 3 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

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
  ENABLE RECT-1 BUTTON-2 BUTTON-10 
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

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.


lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */


{lib\excel-open-file.i}

/* CANAL DE VENTA LINEA 10 */
chWorkSheet:NAME = "Linea 10".
chWorkSheet:Range("C1"):Value = "MARGEN DE UTILIDAD (%)".
chWorkSheet:Range("E1"):Value = "% COMISION SOBRE MARGEN".
chWorkSheet:Range("A2"):Value = "Canal de Venta".
chWorkSheet:Range("B2"):Value = "Descripción".
chWorkSheet:Range("C2"):Value = "Desde".
chWorkSheet:Range("D2"):Value = "Hasta".
chWorkSheet:Range("E2"):Value = "Campaña".
chWorkSheet:Range("F2"):Value = "No Campaña".
/*chWorkSheet:Columns("D"):NumberFormat = "dd/mm/yyyy"*/
DEF VAR s-Clave AS CHAR INIT '%COMI-CV' NO-UNDO.    /* Por Canal de Venta */
DEF VAR s-CodFam AS CHAR INIT '010'.     /* Productos Propios */
ASSIGN
    iIndex = 2.
FOR EACH Vtamcanal WHERE Vtamcanal.Codcia = s-codcia NO-LOCK,
    EACH TabGener WHERE TabGener.CodCia = s-Codcia
    AND TabGener.Codigo = Vtamcanal.CanalVenta + '|' +  s-CodFam
    AND TabGener.Clave = s-Clave NO-LOCK 
    BY Vtamcanal.CanalVenta BY TabGener.ValorIni:
    ASSIGN
        iColumn = 0
        iIndex  = iIndex + 1.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iIndex, iColumn):VALUE = Vtamcanal.CanalVenta. 
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iIndex, iColumn):VALUE = Vtamcanal.Descrip. 
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iIndex, iColumn):VALUE = TabGener.ValorIni.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iIndex, iColumn):VALUE =  TabGener.ValorFin. 
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iIndex, iColumn):VALUE =  TabGener.Parametro[1].
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iIndex, iColumn):VALUE =  TabGener.Parametro[2].
END.
/* MARGEN DE UTILIDAD OTRAS LINEAS */
chWorkSheet = chExcelApplication:Sheets:Item(2).    /* Activa Hoja 2 */
chWorkSheet:NAME = "Otras Lineas".
chWorkSheet:Range("C1"):Value = "MARGEN DE UTILIDAD (%)".
chWorkSheet:Range("E1"):Value = "% COMISION SOBRE MARGEN".
chWorkSheet:Range("A2"):Value = "Canal de Venta".
chWorkSheet:Range("B2"):Value = "Descripción".
chWorkSheet:Range("C2"):Value = "Desde".
chWorkSheet:Range("D2"):Value = "Hasta".
chWorkSheet:Range("E2"):Value = "Campaña".
chWorkSheet:Range("F2"):Value = "No Campaña".
/*chWorkSheet:Columns("D"):NumberFormat = "dd/mm/yyyy"*/
ASSIGN
    s-CodFam = '999'
    iIndex = 2.
FOR EACH Vtamcanal WHERE Vtamcanal.Codcia = s-codcia NO-LOCK,
    EACH TabGener WHERE TabGener.CodCia = s-Codcia
    AND TabGener.Codigo = Vtamcanal.CanalVenta + '|' +  s-CodFam
    AND TabGener.Clave = s-Clave NO-LOCK 
    BY Vtamcanal.CanalVenta BY TabGener.ValorIni:
    ASSIGN
        iColumn = 0
        iIndex  = iIndex + 1.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iIndex, iColumn):VALUE = Vtamcanal.CanalVenta. 
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iIndex, iColumn):VALUE = Vtamcanal.Descrip. 
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iIndex, iColumn):VALUE = TabGener.ValorIni.
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iIndex, iColumn):VALUE =  TabGener.ValorFin. 
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iIndex, iColumn):VALUE =  TabGener.Parametro[1].
    ASSIGN
        iColumn = iColumn + 1
        chWorkSheet:Cells(iIndex, iColumn):VALUE =  TabGener.Parametro[2].
END.
{lib\excel-close-file.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Configuracion W-Win 
PROCEDURE Inicializa-Configuracion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT CAN-FIND(FIRST ComiConfig WHERE ComiConfig.codcia = s-codcia NO-LOCK) 
    THEN DO:
    CREATE ComiConfig.
    ASSIGN
        ComiConfig.CodCia = s-codcia.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-change-page W-Win 
PROCEDURE local-change-page :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'change-page':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('CURRENT-PAGE').
  CASE RETURN-VALUE:
      WHEN "1" THEN DO:
          s-CodFam = "010".
          RUN dispatch IN h_b-comi-010 ('open-query':U).
      END.
      WHEN "2" THEN DO:
          s-CodFam = "999".
          RUN dispatch IN h_b-comi-010-2 ('open-query':U).
      END.
  END CASE.

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

