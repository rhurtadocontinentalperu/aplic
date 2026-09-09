&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-Almmmatg NO-UNDO LIKE Almmmatg.
DEFINE TEMP-TABLE t-AlmSFami NO-UNDO LIKE AlmSFami.
DEFINE TEMP-TABLE t-almtabla NO-UNDO LIKE almtabla.
DEFINE TEMP-TABLE t-Almtfami NO-UNDO LIKE Almtfami.
DEFINE TEMP-TABLE t-gn-clie NO-UNDO LIKE gn-clie.
DEFINE TEMP-TABLE t-gn-divi NO-UNDO LIKE GN-DIVI.
DEFINE TEMP-TABLE t-gn-prov NO-UNDO LIKE gn-prov.
DEFINE TEMP-TABLE t-gn-ven NO-UNDO LIKE gn-ven.
DEFINE TEMP-TABLE t-Promotores NO-UNDO LIKE VtaTabla.



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
DEF SHARED VAR pv-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.

DEF STREAM Reporte.


DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.
/*
DEFINE TEMP-TABLE t-Lineas NO-UNDO
    FIELD CodFam LIKE Almtfami.codfam
    FIELD DesFam LIKE Almtfami.desfam
    FIELD SubFam LIKE Almsfami.subfam
    FIELD DesSub LIKE almsfami.dessub
    INDEX Idx00 AS PRIMARY codfam subfam
    .
*/

DEF TEMP-TABLE t-Transacciones NO-UNDO
    FIELD Lista_de_Precios LIKE FacCPedi.Lista_de_Precios
    FIELD coddiv LIKE Faccpedi.coddiv 
    FIELD coddoc LIKE Faccpedi.coddoc
    FIELD nroped LIKE Faccpedi.nroped
    FIELD fchped LIKE Faccpedi.fchped
    FIELD codcli LIKE Faccpedi.codcli
    FIELD codven LIKE Faccpedi.codven
    FIELD codmat LIKE Facdpedi.codmat
    FIELD canped LIKE Facdpedi.canped
    FIELD implin LIKE Facdpedi.implin
    FIELD codprm AS CHAR FORMAT 'x(15)'
    FIELD codpro AS CHAR FORMAT 'x(15)'
    .

DEF TEMP-TABLE t-Resumen NO-UNDO
    FIELD coddiv LIKE Faccpedi.coddiv 
    FIELD desdiv AS CHAR FORMAT 'x(100)'
    FIELD coddoc LIKE Faccpedi.coddoc
    FIELD nroped LIKE Faccpedi.nroped
    FIELD fchped LIKE Faccpedi.fchped
    FIELD codcli LIKE Faccpedi.codcli
    FIELD nomcli AS CHAR FORMAT 'x(100)'
    FIELD codven LIKE Faccpedi.codven
    FIELD nomven AS CHAR FORMAT 'x(100)'
    FIELD codmat LIKE Facdpedi.codmat
    FIELD desmat AS CHAR FORMAT 'x(100)'
    FIELD codmar AS CHAR FORMAT 'x(10)'
    FIELD desmar AS CHAR FORMAT 'x(50)'
    FIELD undstk LIKE Almmmatg.undstk
    FIELD canped LIKE Facdpedi.canped
    FIELD implin LIKE Facdpedi.implin
    FIELD codprm AS CHAR FORMAT 'x(15)'
    FIELD nomprm AS CHAR FORMAT 'x(80)'
    FIELD codpro AS CHAR FORMAT 'x(15)'
    FIELD nompro AS CHAR FORMAT 'x(100)'
    FIELD codfam AS CHAR FORMAT 'x(5)'
    FIELD desfam AS CHAR FORMAT 'x(50)'
    .

DEF VAR cDelimitador AS CHAR INIT ';' NO-UNDO.
/*cDelimitador = CHR(29).*/

/* Variables para el pase al MySQL */
DEFINE VARIABLE comm-line AS CHARACTER FORMAT "x(70)".
DEFINE VARIABLE x-Url AS CHAR NO-UNDO.

x-Url = 'http://192.168.0.232:7000/evento/cargardata'.

FIND Vtatabla WHERE Vtatabla.codcia = s-codcia AND
    Vtatabla.tabla = 'CONFIG-VTAS' AND
    Vtatabla.llave_c1 = 'EXPOLIBRERIA' AND
    Vtatabla.llave_c2 = 'URL' AND
    Vtatabla.llave_c3 = 'DWH'
    NO-LOCK NO-ERROR.
IF AVAILABLE Vtatabla THEN x-Url = Vtatabla.llave_c4.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 x-FchPed-1 x-FchPed-2 x-CodDiv ~
BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS x-Carpeta x-FchPed-1 x-FchPed-2 x-CodDiv ~
TOGGLE-Transacciones TOGGLE-Articulos TOGGLE-Clientes TOGGLE-Proveedores ~
TOGGLE-Promotores TOGGLE-Vendedores TOGGLE-Lineas TOGGLE-Marcas ~
TOGGLE-Divisiones TOGGLE-Fechas 

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
     SIZE 5 BY .81.

DEFINE BUTTON BUTTON-2 
     LABEL "EXPORTAR" 
     SIZE 15 BY 1.12
     FONT 6.

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Seleccione la división" 
     VIEW-AS COMBO-BOX INNER-LINES 30
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE x-Carpeta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Carpeta Destino" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchPed-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchPed-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE TOGGLE-Articulos AS LOGICAL INITIAL no 
     LABEL "Artículos procesados" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Clientes AS LOGICAL INITIAL no 
     LABEL "Clientes procesados" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Divisiones AS LOGICAL INITIAL no 
     LABEL "Divisiones procesadas" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Fechas AS LOGICAL INITIAL no 
     LABEL "Fechas procesadas" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Lineas AS LOGICAL INITIAL no 
     LABEL "Lineas procesados" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Marcas AS LOGICAL INITIAL no 
     LABEL "Marcas procesadas" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Promotores AS LOGICAL INITIAL no 
     LABEL "Promotores procesados" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Proveedores AS LOGICAL INITIAL no 
     LABEL "Proveedores procesados" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Transacciones AS LOGICAL INITIAL no 
     LABEL "Transacciones procesadas" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-Vendedores AS LOGICAL INITIAL no 
     LABEL "Vendedores procesados" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-Carpeta AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 2
     BUTTON-1 AT ROW 1.54 COL 61 WIDGET-ID 4
     x-FchPed-1 AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 6
     x-FchPed-2 AT ROW 2.62 COL 39 COLON-ALIGNED WIDGET-ID 8
     x-CodDiv AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 10
     TOGGLE-Transacciones AT ROW 5.58 COL 21 WIDGET-ID 12
     TOGGLE-Articulos AT ROW 6.65 COL 21 WIDGET-ID 20
     TOGGLE-Clientes AT ROW 7.73 COL 21 WIDGET-ID 22
     TOGGLE-Proveedores AT ROW 8.81 COL 21 WIDGET-ID 16
     TOGGLE-Promotores AT ROW 9.88 COL 21 WIDGET-ID 18
     TOGGLE-Vendedores AT ROW 10.96 COL 21 WIDGET-ID 24
     TOGGLE-Lineas AT ROW 12.04 COL 21 WIDGET-ID 26
     TOGGLE-Marcas AT ROW 13.12 COL 21 WIDGET-ID 28
     TOGGLE-Divisiones AT ROW 14.19 COL 21 WIDGET-ID 30
     TOGGLE-Fechas AT ROW 15.27 COL 21 WIDGET-ID 32
     BUTTON-2 AT ROW 16.08 COL 3 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 16.96
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-Almmmatg T "?" NO-UNDO INTEGRAL Almmmatg
      TABLE: t-AlmSFami T "?" NO-UNDO INTEGRAL AlmSFami
      TABLE: t-almtabla T "?" NO-UNDO INTEGRAL almtabla
      TABLE: t-Almtfami T "?" NO-UNDO INTEGRAL Almtfami
      TABLE: t-gn-clie T "?" NO-UNDO INTEGRAL gn-clie
      TABLE: t-gn-divi T "?" NO-UNDO INTEGRAL GN-DIVI
      TABLE: t-gn-prov T "?" NO-UNDO INTEGRAL gn-prov
      TABLE: t-gn-ven T "?" NO-UNDO INTEGRAL gn-ven
      TABLE: t-Promotores T "?" NO-UNDO INTEGRAL VtaTabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "EXPORTACION DE DATOS"
         HEIGHT             = 16.96
         WIDTH              = 80
         MAX-HEIGHT         = 38.81
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 38.81
         VIRTUAL-WIDTH      = 274.29
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
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Articulos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Clientes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Divisiones IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Fechas IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Lineas IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Marcas IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Promotores IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Proveedores IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Transacciones IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX TOGGLE-Vendedores IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-Carpeta IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* EXPORTACION DE DATOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* EXPORTACION DE DATOS */
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
  SYSTEM-DIALOG GET-DIR x-Carpeta TITLE 'Seleccione una carpeta'.
  DISPLAY x-Carpeta WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* EXPORTAR */
DO:
  MESSAGE 'Procedemos con la Exportación?'
      VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.

  ASSIGN
      x-Carpeta x-CodDiv x-FchPed-1 x-FchPed-2.
  TOGGLE-Articulos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO".
  TOGGLE-Clientes:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO".
  TOGGLE-Promotores:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO".
  TOGGLE-Proveedores:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO".
  TOGGLE-Transacciones:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO".
  TOGGLE-Vendedores:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO".
  TOGGLE-Lineas:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO".
  TOGGLE-Marcas:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO".
  TOGGLE-Divisiones:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO".
  TOGGLE-Fechas:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO".
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Exporta-Transacciones.
  RUN Exporta-SKUs.
  RUN Exporta-Clientes.
  RUN Exporta-Proveedores.
  RUN Exporta-Promotores.
  RUN Exporta-Vendedores.
  RUN Exporta-Lineas.
  RUN Exporta-Marcas.
  RUN Exporta-Divisiones.
  RUN Exporta-Fechas.
  RUN Exporta-Resumen.
  SESSION:SET-WAIT-STATE('').
  MESSAGE 'Exportación terminada' VIEW-AS ALERT-BOX INFORMATION.
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
  DISPLAY x-Carpeta x-FchPed-1 x-FchPed-2 x-CodDiv TOGGLE-Transacciones 
          TOGGLE-Articulos TOGGLE-Clientes TOGGLE-Proveedores TOGGLE-Promotores 
          TOGGLE-Vendedores TOGGLE-Lineas TOGGLE-Marcas TOGGLE-Divisiones 
          TOGGLE-Fechas 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 x-FchPed-1 x-FchPed-2 x-CodDiv BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Clientes W-Win 
PROCEDURE Exporta-Clientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-NomCli AS CHAR NO-UNDO.

EMPTY TEMP-TABLE t-gn-clie.

FOR EACH t-Transacciones NO-LOCK,
    FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND
    gn-clie.codcli = t-Transacciones.codcli NO-LOCK
    BREAK BY t-Transacciones.codcli:
    IF FIRST-OF(t-Transacciones.codcli) THEN DO:
        x-NomCli = REPLACE(gn-clie.nomcli,cDelimitador,' ').
        CREATE t-gn-clie.
        BUFFER-COPY gn-clie TO t-gn-clie ASSIGN t-gn-clie.NomCli = x-NomCli.
    END.
END.

x-Archivo = x-Carpeta + "\clientes.txt".

OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH t-gn-clie NO-LOCK:
    PUT STREAM Reporte UNFORMATTED 
        t-gn-clie.CodCli cDelimitador
        t-gn-clie.NomCli cDelimitador
        SKIP
        .
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
/* comm-line = 'curl -F ' +                                */
/*     '"file=@' + x-Archivo + '"' + ' ' +                 */
/*     x-Url.                                              */
/* IF CAN-FIND(FIRST t-gn-clie NO-LOCK)                    */
/*     THEN OS-COMMAND SILENT NO-CONSOLE VALUE(comm-line). */

TOGGLE-Clientes:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Divisiones W-Win 
PROCEDURE Exporta-Divisiones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-DesDiv AS CHAR NO-UNDO.

x-Archivo = x-Carpeta + "\divisiones.txt".
OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND
    gn-divi.canalventa = 'FER' AND
    gn-divi.campo-log[1] = NO:
    x-DesDiv = REPLACE(gn-divi.desdiv,cDelimitador,' ').
    PUT STREAM Reporte UNFORMATTED
        gn-divi.coddiv cDelimitador
        x-DesDiv cDelimitador
        SKIP.
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
/* comm-line = 'curl -F ' +                       */
/*     '"file=@' + x-Archivo + '"' + ' ' +        */
/*     x-Url.                                     */
/* OS-COMMAND SILENT NO-CONSOLE VALUE(comm-line). */

TOGGLE-Divisiones:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Fechas W-Win 
PROCEDURE Exporta-Fechas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Fecha AS DATE NO-UNDO.

x-Archivo = x-Carpeta + "\fechas.txt".
OUTPUT STREAM Reporte TO VALUE(x-Archivo).
DO x-Fecha = x-FchPed-1 TO x-FchPed-2:
    PUT STREAM Reporte UNFORMATTED
        (STRING(YEAR(x-Fecha),'9999') + '-' + 
        STRING(MONTH(x-Fecha),'99') + '-' +
        STRING(DAY(x-Fecha),'99')) cDelimitador
        STRING(YEAR(x-Fecha),'9999') cDelimitador
        STRING(MONTH(x-Fecha),'99') cDelimitador
        STRING(DAY(x-Fecha),'99') cDelimitador
        SKIP
        .
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
/* comm-line = 'curl -F ' +                       */
/*     '"file=@' + x-Archivo + '"' + ' ' +        */
/*     x-Url.                                     */
/* OS-COMMAND SILENT NO-CONSOLE VALUE(comm-line). */

TOGGLE-Fechas:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Lineas W-Win 
PROCEDURE Exporta-Lineas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-DesFam AS CHAR NO-UNDO.

/* LINEAS */
EMPTY TEMP-TABLE t-almtfami.

FOR EACH Almtfami NO-LOCK WHERE Almtfami.codcia = s-codcia:
    CREATE t-almtfami.
    BUFFER-COPY Almtfami TO t-almtfami.
END.

x-Archivo = x-Carpeta + "\lineas.txt".
OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH t-almtfami NO-LOCK:
    x-DesFam = REPLACE(t-almtfami.desfam,cDelimitador,' ').
    PUT STREAM Reporte UNFORMATTED
        t-almtfami.codfam cDelimitador
        x-DesFam cDelimitador
        SKIP.
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
/* comm-line = 'curl -F ' +                       */
/*     '"file=@' + x-Archivo + '"' + ' ' +        */
/*     x-Url.                                     */
/* OS-COMMAND SILENT NO-CONSOLE VALUE(comm-line). */

/* SUB-LINEAS */
EMPTY TEMP-TABLE t-almsfami.

FOR EACH Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia:
    CREATE t-almsfami.
    BUFFER-COPY Almsfami TO t-almsfami.
END.

DEF VAR x-DesSub AS CHAR NO-UNDO.

x-Archivo = x-Carpeta + "\sublineas.txt".
OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH t-almsfami NO-LOCK:
    x-DesSub = REPLACE(t-almsfami.dessub,cDelimitador,' ').
    PUT STREAM Reporte UNFORMATTED
        t-almsfami.codfam cDelimitador
        t-almsfami.subfam cDelimitador
        x-DesSub cDelimitador
        SKIP.
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
/* comm-line = 'curl -F ' +                       */
/*     '"file=@' + x-Archivo + '"' + ' ' +        */
/*     x-Url.                                     */
/* OS-COMMAND SILENT NO-CONSOLE VALUE(comm-line). */

TOGGLE-Lineas:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Marcas W-Win 
PROCEDURE Exporta-Marcas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-DesMar AS CHAR NO-UNDO.

x-Archivo = x-Carpeta + "\marcas.txt".
OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH t-almtabla NO-LOCK WHERE t-almtabla.tabla = 'MK':
    x-DesMar = REPLACE(t-almtabla.nombre,cDelimitador,' ').
    PUT STREAM Reporte UNFORMATTED
        t-almtabla.codigo cDelimitador
        x-DesMar cDelimitador
        SKIP.
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
/* comm-line = 'curl -F ' +                       */
/*     '"file=@' + x-Archivo + '"' + ' ' +        */
/*     x-Url.                                     */
/* OS-COMMAND SILENT NO-CONSOLE VALUE(comm-line). */

TOGGLE-Marcas:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Promotores W-Win 
PROCEDURE Exporta-Promotores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Proveedor AS CHAR NO-UNDO.
DEF VAR x-Promotor AS CHAR NO-UNDO.

/* Carga inicial promotores */
EMPTY TEMP-TABLE t-Promotores.

FOR EACH VtaTabla WHERE VtaTabla.CodCia = s-codcia 
    AND VtaTabla.Tabla = 'EXPOPROMOTOR' NO-LOCK:
    CREATE t-Promotores.
    BUFFER-COPY VtaTabla TO t-Promotores.
END.
FOR EACH t-Transacciones WHERE t-Transacciones.codprm > '' NO-LOCK,
    FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND
    Almmmatg.codmat = t-Transacciones.codmat NO-LOCK:
    IF Almmmatg.codpr1 > '' THEN DO:
        FIND t-Promotores WHERE t-Promotores.codcia = s-codcia AND
            t-Promotores.Tabla = 'EXPOPROMOTOR' AND
            t-Promotores.Llave_c1 = t-Transacciones.Lista_de_Precios AND
            t-Promotores.llave_c2 = Almmmatg.codpr1 AND
            t-Promotores.llave_c3 = t-Transacciones.codprm
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE t-Promotores THEN DO:
            CREATE t-Promotores.
            ASSIGN
                t-Promotores.CodCia = s-codcia 
                t-Promotores.Tabla = 'EXPOPROMOTOR'
                t-Promotores.Llave_c1 = t-Transacciones.Lista_de_Precios
                t-Promotores.Llave_c2 = Almmmatg.codpr1
                t-Promotores.LLave_c3 = t-Transacciones.codprm.
        END.
    END.
END.

x-Archivo = x-Carpeta + "\promotores.txt".

OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH t-Promotores NO-LOCK:
    PUT STREAM Reporte UNFORMATTED 
        t-Promotores.Llave_c1 cDelimitador
        t-Promotores.Llave_c2 cDelimitador
        t-Promotores.LLave_c3 cDelimitador
        t-Promotores.Libre_c01 cDelimitador
        t-Promotores.Libre_c02 cDelimitador
        SKIP
        .
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
/* comm-line = 'curl -F ' +                                */
/*     '"file=@' + x-Archivo + '"' + ' ' +                 */
/*     x-Url.                                              */
/* IF CAN-FIND(FIRST t-Promotores NO-LOCK)                 */
/*     THEN OS-COMMAND SILENT NO-CONSOLE VALUE(comm-line). */

TOGGLE-Promotores:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Proveedores W-Win 
PROCEDURE Exporta-Proveedores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Proveedor AS CHAR NO-UNDO.
DEF VAR x-Promotor AS CHAR NO-UNDO.
DEF VAR x-NomPro AS CHAR NO-UNDO.

x-Archivo = x-Carpeta + "\proveedores.txt".

OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH t-gn-prov NO-LOCK:
    x-NomPro = REPLACE(t-gn-prov.nompro,cDelimitador,' ').
    PUT STREAM Reporte UNFORMATTED 
        t-gn-prov.codpro cDelimitador
        x-NomPro cDelimitador
        SKIP
        .
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
/* comm-line = 'curl -F ' +                                */
/*     '"file=@' + x-Archivo + '"' + ' ' +                 */
/*     x-Url.                                              */
/* IF CAN-FIND(FIRST t-gn-prov NO-LOCK)                    */
/*     THEN OS-COMMAND SILENT NO-CONSOLE VALUE(comm-line). */

TOGGLE-Proveedores:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Resumen W-Win 
PROCEDURE Exporta-Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Archivo AS CHAR NO-UNDO.

EMPTY TEMP-TABLE t-Resumen.

FOR EACH t-Transacciones NO-LOCK,
    FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
        gn-divi.coddiv = t-Transacciones.coddiv NO-LOCK,
    FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND
        gn-clie.codcli = t-Transacciones.codcli NO-LOCK,
    FIRST gn-ven WHERE gn-ven.codcia = s-codcia AND
        gn-ven.codven = t-Transacciones.codven NO-LOCK,
    FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND
    Almmmatg.codmat = t-Transacciones.codmat NO-LOCK:
    CREATE t-Resumen.
    BUFFER-COPY t-Transacciones TO t-Resumen
        ASSIGN
        t-Resumen.desdiv = gn-divi.desdiv
        t-Resumen.nomcli = gn-clie.nomcli
        t-Resumen.nomven = gn-ven.nomven
        t-Resumen.desmat = Almmmatg.desmat
        t-Resumen.codmar = TRIM(Almmmatg.codmar)
        t-Resumen.undstk = Almmmatg.undstk
        t-Resumen.codfam = Almmmatg.codfam
        .
    FIND FIRST Almtabla WHERE Almtabla.Tabla = "MK" AND
        Almtabla.Codigo = TRIM(Almmmatg.codmar) NO-LOCK NO-ERROR.
    IF AVAILABLE Almtabla THEN t-Resumen.desmar = REPLACE(TRIM(Almtabla.Nombre),cDelimitador," ").
    IF t-Resumen.codpro > '' THEN DO:
        FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia AND
            gn-prov.codpro = t-Resumen.codpro NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN t-Resumen.nompro = REPLACE(gn-prov.nompro,cDelimitador," ").
    END.
    IF t-Resumen.codprm > '' THEN DO:
        FIND Vtatabla WHERE Vtatabl.CodCia = s-codcia AND
            Vtatabla.Tabla = 'EXPOPROMOTOR' AND
            Vtatabla.Llave_c1 = t-Transacciones.coddiv AND
            Vtatabla.Llave_c2 = Almmmatg.codpr1 AND
            Vtatabla.LLave_c3 = t-Resumen.codprm
            NO-LOCK NO-ERROR.
        IF AVAILABLE Vtatabla THEN t-Resumen.nomprm = REPLACE(Vtatabla.libre_c01,cDelimitador," ").
    END.
    FIND Almtfami OF Almmmatg NO-LOCK NO-ERROR.
    IF AVAILABLE Almtfami THEN t-Resumen.desfam = Almtfami.desfam.
END.

x-Archivo = x-Carpeta + "\resumen.txt".

OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH t-Resumen NO-LOCK:
    PUT STREAM Reporte UNFORMATTED
        t-Resumen.coddiv cDelimitador 
        t-Resumen.desdiv cDelimitador 
        t-Resumen.coddoc cDelimitador 
        t-Resumen.nroped cDelimitador 
        t-Resumen.fchped cDelimitador 
        t-Resumen.codcli cDelimitador 
        t-Resumen.nomcli cDelimitador 
        t-Resumen.codven cDelimitador 
        t-Resumen.nomven cDelimitador 
        t-Resumen.codmat cDelimitador 
        t-Resumen.desmat cDelimitador 
        t-Resumen.codmar cDelimitador 
        t-Resumen.desmar cDelimitador 
        t-Resumen.undstk cDelimitador 
        t-Resumen.canped cDelimitador 
        t-Resumen.implin cDelimitador 
        t-Resumen.codprm cDelimitador 
        t-Resumen.nomprm cDelimitador 
        t-Resumen.codpro cDelimitador 
        t-Resumen.nompro cDelimitador 
        t-Resumen.codfam cDelimitador 
        t-Resumen.desfam cDelimitador 
        SKIP
        .
END.
OUTPUT STREAM Reporte CLOSE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-SKUs W-Win 
PROCEDURE Exporta-SKUs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-DesMat AS CHAR NO-UNDO.

EMPTY TEMP-TABLE t-Almmmatg.

FOR EACH t-Transacciones NO-LOCK, 
    FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND
        Almmmatg.codmat = t-Transacciones.codmat NO-LOCK
    BREAK BY t-Transacciones.codmat:
    IF FIRST-OF(t-Transacciones.codmat) THEN DO:
        x-DesMat = REPLACE(Almmmatg.desmat,cDelimitador,' ').
        CREATE t-Almmmatg.
        ASSIGN
            t-Almmmatg.codcia = Almmmatg.codcia 
            t-Almmmatg.codmat = Almmmatg.codmat
            t-Almmmatg.DesMat = x-DesMat
            t-Almmmatg.CodMar = TRIM(Almmmatg.codmar)
            t-Almmmatg.codfam = Almmmatg.codfam
            t-Almmmatg.subfam = Almmmatg.subfam
            t-Almmmatg.CodPr1 = Almmmatg.codpr1
            t-Almmmatg.CHR__02 = Almmmatg.CHR__02
            t-Almmmatg.undstk = Almmmatg.undstk
            .
    END.
END.

x-Archivo = x-Carpeta + "\articulos.txt".

OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH t-Almmmatg NO-LOCK:
    PUT STREAM Reporte UNFORMATTED 
        t-Almmmatg.codmat cDelimitador
        t-Almmmatg.DesMat cDelimitador
        t-Almmmatg.codfam cDelimitador
        t-Almmmatg.CodMar cDelimitador
        t-Almmmatg.subfam cDelimitador
        t-Almmmatg.undstk cDelimitador      /* Unidad de stock */
        t-Almmmatg.CHR__02 cDelimitador     /* Tipo (T o P) */
        t-Almmmatg.CodPr1 cDelimitador      /* Proveedor */
        SKIP.
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
/* comm-line = 'curl -F ' +                                */
/*     '"file=@' + x-Archivo + '"' + ' ' +                 */
/*     x-Url.                                              */
/* IF CAN-FIND(FIRST t-Almmmatg NO-LOCK)                   */
/*     THEN OS-COMMAND SILENT NO-CONSOLE VALUE(comm-line). */

TOGGLE-Articulos:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Transacciones W-Win 
PROCEDURE Exporta-Transacciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-Proveedor AS CHAR NO-UNDO.
DEF VAR x-Promotor AS CHAR NO-UNDO.

x-Archivo = x-Carpeta + "\transacciones.txt".

EMPTY TEMP-TABLE t-Transacciones.
EMPTY TEMP-TABLE t-gn-prov.
EMPTY TEMP-TABLE t-almtabla.

DEF VAR x-DesMat AS CHAR NO-UNDO.
DEF VAR x-NomCli AS CHAR NO-UNDO.
DEF VAR x-NomVen AS CHAR NO-UNDO.
DEF VAR x-Contador AS INTE NO-UNDO.

/* Carga inicial promotores */
FOR EACH VtaTabla WHERE VtaTabla.CodCia = s-codcia 
    AND VtaTabla.Tabla = 'EXPOPROMOTOR' NO-LOCK:
    CREATE t-Promotores.
    BUFFER-COPY VtaTabla TO t-Promotores.
END.

OUTPUT STREAM Reporte TO VALUE(x-Archivo).
/* Cabecera */
/* PUT STREAM Reporte UNFORMATTED */
/*     "CODDIV" cDelimitador      */
/*     "CODDOC" cDelimitador      */
/*     "NRODOC" cDelimitador      */
/*     "FECHA" cDelimitador       */
/*     "CODMAT" cDelimitador      */
/*     "CANPED" cDelimitador      */
/*     "IMPLIN" cDelimitador      */
/*     "CODCLI" cDelimitador      */
/*     "CODVEN" cDelimitador      */
/*     "CODPRM" cDelimitador      */
/*     SKIP                       */
/*     .                          */

FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia AND
    Faccpedi.coddiv = x-CodDiv AND
    Faccpedi.coddoc = "COT" AND
    Faccpedi.fchped >= x-FchPed-1 AND
    Faccpedi.fchped <= x-FchPed-2 AND
    Faccpedi.flgest <> "A",
    EACH Facdpedi OF Faccpedi NO-LOCK,
    FIRST Almmmatg OF Facdpedi NO-LOCK:

    x-Contador = x-Contador + 1.
    IF x-Contador MODULO 1000 = 0 THEN DO:
        Fi-Mensaje = "REGISTRO: " + STRING(Faccpedi.fchped,'99/99/9999') + ' ' + Faccpedi.nroped.
        DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
    END.

    x-Proveedor = Almmmatg.codpr1.
    x-Promotor = "".
    IF NUM-ENTRIES(Facdpedi.Libre_c03, '|') >= 3 THEN DO:
        ASSIGN
            x-Proveedor = ENTRY(1, Facdpedi.libre_c03, '|')
            x-Promotor  = ENTRY(2, Facdpedi.libre_c03, '|').
    END.
    PUT STREAM Reporte UNFORMATTED 
        Faccpedi.coddiv cDelimitador
        Faccpedi.coddoc cDelimitador
        Faccpedi.nroped cDelimitador
        Faccpedi.fchped cDelimitador
        Facdpedi.codmat cDelimitador
        (Facdpedi.canped * Facdpedi.factor) cDelimitador
        Facdpedi.implin cDelimitador
        Faccpedi.codcli cDelimitador
        Faccpedi.codven cDelimitador
        x-Promotor      cDelimitador
        /*x-Proveedor cDelimitador*/
        SKIP
        .
    CREATE t-Transacciones.
    ASSIGN
        t-Transacciones.Lista_de_Precios = FacCPedi.Lista_de_Precios
        t-Transacciones.coddiv = Faccpedi.coddiv
        t-Transacciones.coddoc = Faccpedi.coddoc
        t-Transacciones.nroped = Faccpedi.nroped
        t-Transacciones.fchped = Faccpedi.fchped
        t-Transacciones.codcli = Faccpedi.codcli
        t-Transacciones.codven = Faccpedi.codven
        t-Transacciones.codmat = Facdpedi.codmat
        t-Transacciones.canped = (Facdpedi.canped * Facdpedi.factor)
        t-Transacciones.implin = Facdpedi.implin
        t-Transacciones.codprm = x-Promotor
        t-Transacciones.codpro = x-Proveedor
        .
    /* Proveedores */
    FIND t-gn-prov WHERE t-gn-prov.codcia = pv-codcia AND
        t-gn-prov.codpro = x-Proveedor
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE t-gn-prov THEN DO:
        CREATE t-gn-prov.
        ASSIGN
            t-gn-prov.codcia = pv-codcia
            t-gn-prov.codpro = x-Proveedor.
    END.
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia AND
        gn-prov.codpro = x-Proveedor
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN DO:
        BUFFER-COPY gn-prov TO t-gn-prov.
    END.
    /* Marcas */
    FIND t-Almtabla WHERE t-almtabla.Tabla = "MK" AND
        t-almtabla.Codigo = TRIM(Almmmatg.codmar)
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE t-Almtabla THEN DO:
        CREATE t-almtabla.
        ASSIGN
            t-almtabla.Tabla = "MK" 
            t-almtabla.Codigo = TRIM(Almmmatg.codmar)
            .
    END.
    FIND Almtabla WHERE almtabla.Tabla = "MK" AND
        almtabla.Codigo = TRIM(Almmmatg.codmar) NO-LOCK NO-ERROR.
    IF AVAILABLE Almtabla THEN t-almtabla.nombre = Almtabla.nombre.
END.
HIDE FRAME F-Proceso.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
comm-line = 'curl -F ' +
    '"file=@' + x-Archivo + '"' + ' ' + 
    x-Url.
IF CAN-FIND(FIRST t-Transacciones NO-LOCK) 
    THEN OS-COMMAND SILENT NO-CONSOLE VALUE(comm-line).

TOGGLE-Transacciones:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta-Vendedores W-Win 
PROCEDURE Exporta-Vendedores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-NomVen AS CHAR NO-UNDO.

EMPTY TEMP-TABLE t-gn-ven.

FOR EACH t-Transacciones NO-LOCK BREAK BY t-Transacciones.codven:
    IF FIRST-OF(t-Transacciones.codven) THEN DO:
        FIND t-gn-ven WHERE t-gn-ven.CodCia = s-codcia AND 
            t-gn-ven.CodVen = t-Transacciones.codven
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE t-gn-ven THEN DO:
            CREATE t-gn-ven.
            ASSIGN
                t-gn-ven.codcia = s-codcia 
                t-gn-ven.CodVen = t-Transacciones.codven.
        END.
        FIND gn-ven WHERE gn-ven.codcia = s-codcia AND
            gn-ven.codven = t-Transacciones.codven NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ven THEN DO:
            x-NomVen = REPLACE(gn-ven.nomven,cDelimitador,' ').
            BUFFER-COPY gn-ven TO t-gn-ven ASSIGN t-gn-ven.NomVen = x-NomVen.
        END.

    END.
END.

x-Archivo = x-Carpeta + "\vendedores.txt".

OUTPUT STREAM Reporte TO VALUE(x-Archivo).
FOR EACH t-gn-ven NO-LOCK:
    PUT STREAM Reporte UNFORMATTED 
        t-gn-ven.CodVen cDelimitador
        t-gn-ven.NomVen cDelimitador
        SKIP
        .
END.
OUTPUT STREAM Reporte CLOSE.

/* Pasamos el archivo a la base de datos */
comm-line = 'curl -F ' +
    '"file=@' + x-Archivo + '"' + ' ' + 
    x-Url.
IF CAN-FIND(FIRST t-gn-ven NO-LOCK) 
    THEN OS-COMMAND SILENT NO-CONSOLE VALUE(comm-line).

TOGGLE-Vendedores:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES".

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
      x-CodDiv:DELETE(1).
      x-CodDiv:DELIMITER = cDelimitador.
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND
          gn-divi.canalventa = 'FER' AND
          gn-divi.campo-log[1] = NO:
          x-CodDiv:ADD-LAST(gn-divi.coddiv + ' ' + gn-divi.desdiv, gn-divi.coddiv).
          IF gn-divi.coddiv = s-coddiv THEN x-coddiv = gn-divi.coddiv.
      END.
      x-FchPed-2 = TODAY.
      x-FchPed-1 = TODAY - 3.
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

