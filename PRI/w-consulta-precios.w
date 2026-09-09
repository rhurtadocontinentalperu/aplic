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
DEF SHARED VAR s-codcia AS INTE.

/* Local Variable Definitions ---                                       */

DEFINE NEW SHARED VARIABLE s-CanalVenta AS CHAR.
DEFINE NEW SHARED VARIABLE s-Divisiones AS CHAR.

ASSIGN
    s-CanalVenta = 'ATL,HOR,INS,MOD,PRO,TDA,INT,B2C,MIN,FER'.


DEFINE VAR hProc AS HANDLE NO-UNDO.
RUN pri/pri-librerias PERSISTENT SET hProc.
RUN PRI_Divisiones-Validas IN hProc (INPUT 1, OUTPUT s-Divisiones).
DELETE PROCEDURE hProc.


DEF TEMP-TABLE Detalle-Prom
    FIELD CodMat LIKE Almmmatg.CodMat LABEL 'Artículo'
    FIELD CodFam LIKE Almmmatg.CodFam LABEL 'Línea'
    FIELD SubFam LIKE Almmmatg.SubFam LABEL 'SubLínea'
    FIELD DesMat AS CHAR FORMAT 'x(100)' LABEL 'Descripción'
    FIELD DesMar LIKE Almmmatg.DesMar LABEL 'Marca'
    FIELD CtoTot LIKE Almmmatg.CtoTot LABEL 'Costo en S/'
    FIELD PreOfi AS DECI LABEL 'Precio Mayorista en S/'
    FIELD CodDiv AS CHAR FORMAT 'x(8)' LABEL 'División'
    FIELD DesDiv AS CHAR FORMAT 'x(40)' LABEL 'Nombre'
    FIELD PrePro AS DECI LABEL 'Precio Promocional en S/'
    FIELD FchIni LIKE VtaDctoProm.FchIni LABEL 'Fecha Inicio'
    FIELD FchFin LIKE VtaDctoProm.FchFin LABEL 'Fecha Fin'
    .
DEF TEMP-TABLE Detalle-Prom-Utilex
    FIELD CodMat LIKE Almmmatg.CodMat LABEL 'Artículo'
    FIELD CodFam LIKE Almmmatg.CodFam LABEL 'Línea'
    FIELD SubFam LIKE Almmmatg.SubFam LABEL 'SubLínea'
    FIELD DesMat AS CHAR FORMAT 'x(100)' LABEL 'Descripción'
    FIELD DesMar LIKE Almmmatg.DesMar LABEL 'Marca'
    FIELD CtoTot LIKE Almmmatg.CtoTot LABEL 'Costo en S/'
    FIELD PreOfi AS DECI LABEL 'Precio Minorista en S/'
    FIELD CodDiv AS CHAR FORMAT 'x(8)' LABEL 'División'
    FIELD DesDiv AS CHAR FORMAT 'x(40)' LABEL 'Nombre'
    FIELD PrePro AS DECI LABEL 'Precio Promocional en S/'
    FIELD FchIni LIKE VtaDctoProm.FchIni LABEL 'Fecha Inicio'
    FIELD FchFin LIKE VtaDctoProm.FchFin LABEL 'Fecha Fin'
    .
DEF TEMP-TABLE Detalle-Vol
    FIELD CodMat LIKE Almmmatg.CodMat LABEL 'Artículo'
    FIELD CodFam LIKE Almmmatg.CodFam LABEL 'Línea'
    FIELD SubFam LIKE Almmmatg.SubFam LABEL 'SubLínea'
    FIELD DesMat AS CHAR FORMAT 'x(100)' LABEL 'Descripción'
    FIELD DesMar LIKE Almmmatg.DesMar LABEL 'Marca'
    FIELD CtoTot LIKE Almmmatg.CtoTot LABEL 'Costo en S/'
    FIELD PreOfi AS DECI LABEL 'Precio Lista en S/'
    FIELD CanVol-1 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Cantidad Mínima'
    FIELD DtoVol-1 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Descuento'
    FIELD PreVol-1 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Precio Final Unitario'
    FIELD CanVol-2 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Cantidad Mínima'
    FIELD DtoVol-2 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Descuento'
    FIELD PreVol-2 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Precio Final Unitario'
    FIELD CanVol-3 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Cantidad Mínima'
    FIELD DtoVol-3 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Descuento'
    FIELD PreVol-3 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Precio Final Unitario'
    FIELD CanVol-4 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Cantidad Mínima'
    FIELD DtoVol-4 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Descuento'
    FIELD PreVol-4 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Precio Final Unitario'
    FIELD CanVol-5 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Cantidad Mínima'
    FIELD DtoVol-5 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Descuento'
    FIELD PreVol-5 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Precio Final Unitario'
    FIELD CanVol-6 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Cantidad Mínima'
    FIELD DtoVol-6 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Descuento'
    FIELD PreVol-6 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Precio Final Unitario'
    FIELD CanVol-7 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Cantidad Mínima'
    FIELD DtoVol-7 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Descuento'
    FIELD PreVol-7 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Precio Final Unitario'
    FIELD CanVol-8 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Cantidad Mínima'
    FIELD DtoVol-8 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Descuento'
    FIELD PreVol-8 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Precio Final Unitario'
    FIELD CanVol-9 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Cantidad Mínima'
    FIELD DtoVol-9 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Descuento'
    FIELD PreVol-9 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Precio Final Unitario'
    FIELD CanVol-10 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Cantidad Mínima'
    FIELD DtoVol-10 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Descuento'
    FIELD PreVol-10 AS DECI FORMAT '->>>,>>>.9999' LABEL 'Precio Final Unitario'
    .

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
&Scoped-Define ENABLED-OBJECTS RECT-14 RECT-15 COMBO-BOX-Linea ~
COMBO-BOX-Sublinea BUTTON-Filtrar BUTTON-Limpiar RADIO-SET-Imprimir ~
BUTTON-Texto 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Linea COMBO-BOX-Sublinea ~
RADIO-SET-Imprimir 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-articulos-en-venta AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-lima-dctoprom AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-utilex-dctoprom AS HANDLE NO-UNDO.
DEFINE VARIABLE h_tab95 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-lima-dtovol AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-utilex-dtovol AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Filtrar 
     LABEL "APLICAR FILTRO" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Limpiar 
     LABEL "LIMPIAR FILTROS" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BUTTON-Texto 
     LABEL "EXPORTAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Linea AS CHARACTER FORMAT "X(256)":U INITIAL "Todas" 
     LABEL "Linea" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "TODAS" 
     DROP-DOWN-LIST
     SIZE 55 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Sublinea AS CHARACTER FORMAT "X(256)":U INITIAL "TODAS" 
     LABEL "Sublinea" 
     VIEW-AS COMBO-BOX INNER-LINES 15
     LIST-ITEMS "TODAS" 
     DROP-DOWN-LIST
     SIZE 55 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Imprimir AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Promocional Mayorista", 1,
"Promocional Minorista", 2,
"Volumen Mayorista", 3,
"Volumen Minorista", 4
     SIZE 18 BY 3.77
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 6.19.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 30 BY 6.19
     BGCOLOR 15 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Linea AT ROW 2.08 COL 120 COLON-ALIGNED WIDGET-ID 6
     COMBO-BOX-Sublinea AT ROW 3.04 COL 120 COLON-ALIGNED WIDGET-ID 8
     BUTTON-Filtrar AT ROW 3.96 COL 122 WIDGET-ID 14
     BUTTON-Limpiar AT ROW 3.96 COL 137 WIDGET-ID 16
     RADIO-SET-Imprimir AT ROW 9.88 COL 152 NO-LABEL WIDGET-ID 18
     BUTTON-Texto AT ROW 13.92 COL 154 WIDGET-ID 28
     "Exportar a texto" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 9.08 COL 147 WIDGET-ID 26
          BGCOLOR 15 FGCOLOR 0 
     "Filtrar por" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.27 COL 120 WIDGET-ID 10
          BGCOLOR 9 FGCOLOR 15 
     RECT-14 AT ROW 1.54 COL 113 WIDGET-ID 12
     RECT-15 AT ROW 9.35 COL 146 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 178.72 BY 25.69
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
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
         TITLE              = "CONSULTA DE PRECIOS"
         HEIGHT             = 25.69
         WIDTH              = 178.72
         MAX-HEIGHT         = 27.15
         MAX-WIDTH          = 194.86
         VIRTUAL-HEIGHT     = 27.15
         VIRTUAL-WIDTH      = 194.86
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
ON END-ERROR OF W-Win /* CONSULTA DE PRECIOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSULTA DE PRECIOS */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Filtrar W-Win
ON CHOOSE OF BUTTON-Filtrar IN FRAME F-Main /* APLICAR FILTRO */
DO:
  ASSIGN
      COMBO-BOX-Linea COMBO-BOX-Sublinea.
  RUN Captura-Filtros IN h_b-articulos-en-venta
    ( INPUT ENTRY(1,COMBO-BOX-Linea,' - ')  /* CHARACTER */,
      INPUT ENTRY(1,COMBO-BOX-Sublinea,' - ') /* CHARACTER */).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Limpiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Limpiar W-Win
ON CHOOSE OF BUTTON-Limpiar IN FRAME F-Main /* LIMPIAR FILTROS */
DO:
  ASSIGN
      COMBO-BOX-Linea = "TODAS"
      COMBO-BOX-Sublinea = "TODAS".
  DISPLAY COMBO-BOX-Linea COMBO-BOX-Sublinea WITH FRAME {&FRAME-NAME}.
  APPLY 'LEAVE':U TO COMBO-BOX-Linea.
  APPLY 'CHOOSE':U TO BUTTON-Filtrar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Texto W-Win
ON CHOOSE OF BUTTON-Texto IN FRAME F-Main /* EXPORTAR */
DO:

  DEF VAR pOptions AS CHAR NO-UNDO.
  DEF VAR pArchivo AS CHAR NO-UNDO.

  DEF VAR OKpressed AS LOG.
  
  SYSTEM-DIALOG GET-FILE pArchivo
        FILTERS "Archivo txt" "*.txt"
        ASK-OVERWRITE 
        CREATE-TEST-FILE
        DEFAULT-EXTENSION ".txt"
        SAVE-AS
        USE-FILENAME
        UPDATE OKpressed.
  IF OKpressed = FALSE THEN RETURN NO-APPLY.

  ASSIGN 
      RADIO-SET-Imprimir.

  /* Capturamos Articulos */
  SESSION:SET-WAIT-STATE('GENERAL').
  
  RUN Captura-Articulos IN h_b-articulos-en-venta ( OUTPUT TABLE T-MATG).


  CASE RADIO-SET-Imprimir:
      WHEN 1 THEN DO:
          FOR EACH T-MATG:
              IF T-MATG.MonVta = 2 THEN T-MATG.CtoTot = T-MATG.CtoTot * T-MATG.TpoCmb.
              IF T-MATG.MonVta = 2 THEN T-MATG.PreOfi = T-MATG.PreOfi * T-MATG.TpoCmb.
          END.
      END.
      WHEN 2 THEN DO:
          FOR EACH T-MATG:
              FIND FIRST VtaListaMinGn WHERE VtaListaMinGn.CodCia = s-CodCia
                  AND VtaListaMinGn.codmat = T-MATG.CodMat
                  NO-LOCK NO-ERROR.
              IF NOT AVAILABLE VtaListaMinGn THEN DO:
                  DELETE T-MATG.
                  NEXT.
              END.
              T-MATG.PreOfi = VtaListaMinGn.PreOfi.
              IF T-MATG.MonVta = 2 THEN T-MATG.CtoTot = T-MATG.CtoTot * T-MATG.TpoCmb.
              IF T-MATG.MonVta = 2 THEN T-MATG.PreOfi = T-MATG.PreOfi * T-MATG.TpoCmb.
          END.
      END.
  END CASE.

  DEF VAR x-Divisiones AS CHAR NO-UNDO.
  RUN pri/pri-librerias PERSISTENT SET hProc.
  EMPTY TEMP-TABLE Detalle-Prom.
  EMPTY TEMP-TABLE Detalle-Prom-Utilex.
  EMPTY TEMP-TABLE Detalle-Vol.
  CASE RADIO-SET-Imprimir:
      WHEN 1 THEN DO:       /* Promocional Mayorista */
          RUN PRI_Divisiones-Validas IN hProc (INPUT 1, OUTPUT x-Divisiones).
          RUN Carga-Prom-Mayor (INPUT x-Divisiones).
      END.
      WHEN 2 THEN DO:       /* Promocional Minorista */
          RUN PRI_Divisiones-Validas IN hProc (INPUT 2, OUTPUT x-Divisiones).
          RUN Carga-Prom-Minorista (INPUT x-Divisiones).
      END.
      WHEN 3 THEN DO:       /* Volumen Mayorista */
          RUN PRI_Divisiones-Validas IN hProc (INPUT 1, OUTPUT x-Divisiones).
          RUN Carga-Vol-Mayor (INPUT x-Divisiones).
      END.
      WHEN 4 THEN DO:       /* Volumen Minorista */
          RUN PRI_Divisiones-Validas IN hProc (INPUT 2, OUTPUT x-Divisiones).
          RUN Carga-Vol-Minorista (INPUT x-Divisiones).
      END.
  END CASE.
  DELETE PROCEDURE hProc.


  ASSIGN
      pOptions = "FileType:TXT" + CHR(1) + ~
            "Grid:ver" + CHR(1) + ~ 
            "ExcelAlert:false" + CHR(1) + ~
            "ExcelVisible:false" + CHR(1) + ~
            "Labels:yes".

  DEF VAR cArchivo AS CHAR NO-UNDO.

  /* El archivo se va a generar en un archivo temporal de trabajo antes 
  de enviarlo a su directorio destino */
  cArchivo = LC(pArchivo).
  CASE RADIO-SET-Imprimir:
      WHEN 1 THEN DO:
          RUN lib/tt-filev2 (TEMP-TABLE Detalle-Prom:HANDLE, cArchivo, pOptions).
      END.
      WHEN 2 THEN DO:
          RUN lib/tt-filev2 (TEMP-TABLE Detalle-Prom-Utilex:HANDLE, cArchivo, pOptions).
      END.
      WHEN 3 THEN DO:
          RUN lib/tt-filev2 (TEMP-TABLE Detalle-Vol:HANDLE, cArchivo, pOptions).
      END.
      WHEN 4 THEN DO:
          RUN lib/tt-filev2 (TEMP-TABLE Detalle-Vol:HANDLE, cArchivo, pOptions).
      END.
  END CASE.
  SESSION:SET-WAIT-STATE('').
  /* ******************************************************* */
  MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Linea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Linea W-Win
ON VALUE-CHANGED OF COMBO-BOX-Linea IN FRAME F-Main /* Linea */
DO:
  ASSIGN {&self-name}.
  COMBO-BOX-Sublinea:DELETE(COMBO-BOX-Sublinea:LIST-ITEMS).
  COMBO-BOX-Sublinea:ADD-LAST("TODAS").
  COMBO-BOX-Sublinea:SCREEN-VALUE = "TODAS".
  FOR EACH Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia
      AND Almsfami.codfam = ENTRY(1, COMBO-BOX-Linea, ' - ') :
      COMBO-BOX-Sublinea:ADD-LAST(AlmSFami.subfam + " - " + AlmSFami.dessub).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Sublinea
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Sublinea W-Win
ON VALUE-CHANGED OF COMBO-BOX-Sublinea IN FRAME F-Main /* Sublinea */
DO:
  ASSIGN {&self-name}.
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
             INPUT  'aplic/pri/b-articulos-en-venta.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-articulos-en-venta ).
       RUN set-position IN h_b-articulos-en-venta ( 1.27 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-articulos-en-venta ( 6.69 , 109.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-free/objects/tab95.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'LABEL-FONT = 4,
                     LABEL-FGCOLOR = 0,
                     FOLDER-BGCOLOR = 8,
                     FOLDER-PARENT-BGCOLOR = 8,
                     LABELS = Descuentos Mayoristas|Descuentos Minoristas':U ,
             OUTPUT h_tab95 ).
       RUN set-position IN h_tab95 ( 8.00 , 2.00 ) NO-ERROR.
       RUN set-size IN h_tab95 ( 18.58 , 141.00 ) NO-ERROR.

       /* Links to SmartTab95 h_tab95. */
       RUN add-link IN adm-broker-hdl ( h_tab95 , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-articulos-en-venta ,
             COMBO-BOX-Linea:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_tab95 ,
             BUTTON-Limpiar:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pri/b-lima-dctoprom.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-lima-dctoprom ).
       RUN set-position IN h_b-lima-dctoprom ( 9.08 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-lima-dctoprom ( 16.96 , 80.29 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/v-lima-dtovol.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-lima-dtovol ).
       RUN set-position IN h_v-lima-dtovol ( 10.96 , 91.00 ) NO-ERROR.
       /* Size in UIB:  ( 11.65 , 42.86 ) */

       /* Links to SmartBrowser h_b-lima-dctoprom. */
       RUN add-link IN adm-broker-hdl ( h_b-articulos-en-venta , 'Record':U , h_b-lima-dctoprom ).

       /* Links to SmartViewer h_v-lima-dtovol. */
       RUN add-link IN adm-broker-hdl ( h_b-articulos-en-venta , 'Record':U , h_v-lima-dtovol ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-lima-dctoprom ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-lima-dtovol ,
             RADIO-SET-Imprimir:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pri/b-utilex-dctoprom.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-utilex-dctoprom ).
       RUN set-position IN h_b-utilex-dctoprom ( 9.08 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-utilex-dctoprom ( 16.96 , 80.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vta2/v-utilex-dtovol.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-utilex-dtovol ).
       RUN set-position IN h_v-utilex-dtovol ( 10.96 , 91.00 ) NO-ERROR.
       /* Size in UIB:  ( 11.65 , 42.86 ) */

       /* Links to SmartBrowser h_b-utilex-dctoprom. */
       RUN add-link IN adm-broker-hdl ( h_b-articulos-en-venta , 'Record':U , h_b-utilex-dctoprom ).

       /* Links to SmartViewer h_v-utilex-dtovol. */
       RUN add-link IN adm-broker-hdl ( h_b-articulos-en-venta , 'Record':U , h_v-utilex-dtovol ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-utilex-dctoprom ,
             h_tab95 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-utilex-dtovol ,
             RADIO-SET-Imprimir:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 2 */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Prom-Mayor W-Win 
PROCEDURE Carga-Prom-Mayor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER x-Divisiones AS CHAR.

    FOR EACH T-MATG:
      IF NOT CAN-FIND(FIRST VtaDctoProm WHERE VtaDctoProm.CodCia = s-CodCia
                      AND VtaDctoProm.CodMat = T-MATG.CodMat
                      AND (VtaDctoProm.FchIni >= TODAY OR TODAY <= VtaDctoProm.FchFin)
                      AND LOOKUP(VtaDctoProm.CodDiv, x-Divisiones) > 0 NO-LOCK)
          THEN DO:
          CREATE Detalle-Prom.
          ASSIGN
              Detalle-Prom.CodMat = T-MATG.CodMat
              Detalle-Prom.CodFam = T-MATG.CodFam
              Detalle-Prom.SubFam = T-MATG.SubFam
              Detalle-Prom.DesMat = T-MATG.DesMat
              Detalle-Prom.DesMar = T-MATG.DesMar
              Detalle-Prom.CtoTot = T-MATG.CtoTot
              Detalle-Prom.PreOfi = T-MATG.PreOfi
              .
          NEXT.
      END.
      FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = s-CodCia
          AND VtaDctoProm.CodMat = T-MATG.CodMat
          AND (VtaDctoProm.FchIni >= TODAY OR TODAY <= VtaDctoProm.FchFin),
          FIRST GN-DIVI OF VtaDctoProm NO-LOCK WHERE LOOKUP(GN-DIVI.CodDiv, x-Divisiones) > 0:
          CREATE Detalle-Prom.
          ASSIGN
              Detalle-Prom.CodMat = T-MATG.CodMat
              Detalle-Prom.CodFam = T-MATG.CodFam
              Detalle-Prom.SubFam = T-MATG.SubFam
              Detalle-Prom.DesMat = T-MATG.DesMat
              Detalle-Prom.DesMar = T-MATG.DesMar
              Detalle-Prom.CtoTot = T-MATG.CtoTot
              Detalle-Prom.PreOfi = T-MATG.PreOfi
              .
          ASSIGN
              Detalle-Prom.CodDiv = gn-divi.CodDiv
              Detalle-Prom.DesDiv = gn-divi.desdiv
              Detalle-Prom.PrePro = VtaDctoProm.Precio
              Detalle-Prom.FchIni = VtaDctoProm.FchIni
              Detalle-Prom.FchFin = VtaDctoProm.FchFin
              .
      END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Prom-Minorista W-Win 
PROCEDURE Carga-Prom-Minorista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER x-Divisiones AS CHAR.

    FOR EACH T-MATG:
      IF NOT CAN-FIND(FIRST VtaDctoPromMin WHERE VtaDctoPromMin.CodCia = s-CodCia
                      AND VtaDctoPromMin.CodMat = T-MATG.CodMat
                      AND (VtaDctoPromMin.FchIni >= TODAY OR TODAY <= VtaDctoPromMin.FchFin)
                      AND LOOKUP(VtaDctoPromMin.CodDiv, x-Divisiones) > 0 NO-LOCK)
          THEN DO:
          CREATE Detalle-Prom-Utilex.
          ASSIGN
              Detalle-Prom-Utilex.CodMat = T-MATG.CodMat
              Detalle-Prom-Utilex.CodFam = T-MATG.CodFam
              Detalle-Prom-Utilex.SubFam = T-MATG.SubFam
              Detalle-Prom-Utilex.DesMat = T-MATG.DesMat
              Detalle-Prom-Utilex.DesMar = T-MATG.DesMar
              Detalle-Prom-Utilex.CtoTot = T-MATG.CtoTot
              Detalle-Prom-Utilex.PreOfi = T-MATG.PreOfi
              .
          NEXT.
      END.
      FOR EACH VtaDctoPromMin NO-LOCK WHERE VtaDctoPromMin.CodCia = s-CodCia
          AND VtaDctoPromMin.CodMat = T-MATG.CodMat
          AND (VtaDctoPromMin.FchIni >= TODAY OR TODAY <= VtaDctoPromMin.FchFin),
          FIRST GN-DIVI OF VtaDctoPromMin NO-LOCK WHERE LOOKUP(GN-DIVI.CodDiv, x-Divisiones) > 0:
          CREATE Detalle-Prom-Utilex.
          ASSIGN
              Detalle-Prom-Utilex.CodMat = T-MATG.CodMat
              Detalle-Prom-Utilex.CodFam = T-MATG.CodFam
              Detalle-Prom-Utilex.SubFam = T-MATG.SubFam
              Detalle-Prom-Utilex.DesMat = T-MATG.DesMat
              Detalle-Prom-Utilex.DesMar = T-MATG.DesMar
              Detalle-Prom-Utilex.CtoTot = T-MATG.CtoTot
              Detalle-Prom-Utilex.PreOfi = T-MATG.PreOfi
              .
          ASSIGN
              Detalle-Prom-Utilex.CodDiv = gn-divi.CodDiv
              Detalle-Prom-Utilex.DesDiv = gn-divi.desdiv
              Detalle-Prom-Utilex.PrePro = VtaDctoPromMin.Precio
              Detalle-Prom-Utilex.FchIni = VtaDctoPromMin.FchIni
              Detalle-Prom-Utilex.FchFin = VtaDctoPromMin.FchFin
              .
      END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Vol-Mayor W-Win 
PROCEDURE Carga-Vol-Mayor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER x-Divisiones AS CHAR.

  DEF VAR i AS INTE NO-UNDO.
  DEF VAR F-PRECIO AS DECI NO-UNDO.

  FOR EACH T-MATG WHERE T-MATG.DtoVolR[1] > 0:
      F-PRECIO = T-MATG.Prevta[1].
      IF T-MATG.MonVta = 2 THEN F-PRECIO = T-MATG.Prevta[1] * T-MATG.TpoCmb.
      CREATE Detalle-Vol.
      ASSIGN
          Detalle-Vol.CodMat = T-MATG.CodMat
          Detalle-Vol.CodFam = T-MATG.CodFam
          Detalle-Vol.SubFam = T-MATG.SubFam
          Detalle-Vol.DesMat = T-MATG.DesMat
          Detalle-Vol.DesMar = T-MATG.DesMar
          Detalle-Vol.CtoTot = T-MATG.CtoTot
          Detalle-Vol.PreOfi = F-PRECIO     /*T-MATG.PreOfi*/
          .
      DO I = 1 TO 10:
          IF i = 1 THEN
              ASSIGN
              Detalle-Vol.CanVol-1 = T-MATG.DtoVolR[i]
              Detalle-Vol.DtoVol-1 = T-MATG.DtoVolD[i]
              Detalle-Vol.PreVol-1 = IF T-MATG.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (T-MATG.DtoVolD[i] / 100 ) ),4) ELSE 0.
              .
          IF i = 2 THEN
              ASSIGN
              Detalle-Vol.CanVol-2 = T-MATG.DtoVolR[i]
              Detalle-Vol.DtoVol-2 = T-MATG.DtoVolD[i]
              Detalle-Vol.PreVol-2 = IF T-MATG.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (T-MATG.DtoVolD[i] / 100 ) ),4) ELSE 0.
              .
          IF i = 3 THEN
              ASSIGN
              Detalle-Vol.CanVol-3 = T-MATG.DtoVolR[i]
              Detalle-Vol.DtoVol-3 = T-MATG.DtoVolD[i]
              Detalle-Vol.PreVol-3 = IF T-MATG.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (T-MATG.DtoVolD[i] / 100 ) ),4) ELSE 0.
              .
          IF i = 4 THEN
              ASSIGN
              Detalle-Vol.CanVol-4 = T-MATG.DtoVolR[i]
              Detalle-Vol.DtoVol-4 = T-MATG.DtoVolD[i]
              Detalle-Vol.PreVol-4 = IF T-MATG.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (T-MATG.DtoVolD[i] / 100 ) ),4) ELSE 0.
              .
          IF i = 5 THEN
              ASSIGN
              Detalle-Vol.CanVol-5 = T-MATG.DtoVolR[i]
              Detalle-Vol.DtoVol-5 = T-MATG.DtoVolD[i]
              Detalle-Vol.PreVol-5 = IF T-MATG.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (T-MATG.DtoVolD[i] / 100 ) ),4) ELSE 0.
              .

              IF i = 6 THEN
                  ASSIGN
                  Detalle-Vol.CanVol-6 = T-MATG.DtoVolR[i]
                  Detalle-Vol.DtoVol-6 = T-MATG.DtoVolD[i]
                  Detalle-Vol.PreVol-6 = IF T-MATG.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (T-MATG.DtoVolD[i] / 100 ) ),4) ELSE 0.
                  .
              IF i = 7 THEN
                  ASSIGN
                  Detalle-Vol.CanVol-7 = T-MATG.DtoVolR[i]
                  Detalle-Vol.DtoVol-7 = T-MATG.DtoVolD[i]
                  Detalle-Vol.PreVol-7 = IF T-MATG.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (T-MATG.DtoVolD[i] / 100 ) ),4) ELSE 0.
                  .
              IF i = 8 THEN
                  ASSIGN
                  Detalle-Vol.CanVol-8 = T-MATG.DtoVolR[i]
                  Detalle-Vol.DtoVol-8 = T-MATG.DtoVolD[i]
                  Detalle-Vol.PreVol-8 = IF T-MATG.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (T-MATG.DtoVolD[i] / 100 ) ),4) ELSE 0.
                  .
              IF i = 9 THEN
                  ASSIGN
                  Detalle-Vol.CanVol-9 = T-MATG.DtoVolR[i]
                  Detalle-Vol.DtoVol-9 = T-MATG.DtoVolD[i]
                  Detalle-Vol.PreVol-9 = IF T-MATG.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (T-MATG.DtoVolD[i] / 100 ) ),4) ELSE 0.
                  .
              IF i = 10 THEN
                  ASSIGN
                  Detalle-Vol.CanVol-10 = T-MATG.DtoVolR[i]
                  Detalle-Vol.DtoVol-10 = T-MATG.DtoVolD[i]
                  Detalle-Vol.PreVol-10 = IF T-MATG.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (T-MATG.DtoVolD[i] / 100 ) ),4) ELSE 0.
                  .
      END.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Vol-Minorista W-Win 
PROCEDURE Carga-Vol-Minorista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER x-Divisiones AS CHAR.

  DEF VAR i AS INTE NO-UNDO.
  DEF VAR F-PRECIO AS DECI NO-UNDO.

  FOR EACH T-MATG, FIRST VtaListaMinGn NO-LOCK WHERE VtaListaMinGn.CodCia = s-CodCia
      AND VtaListaMinGn.codmat = T-MATG.CodMat
      AND VtaListaMinGn.DtoVolR[1] > 0:
      F-PRECIO = VtaListaMinGn.PreOfi.
      IF T-MATG.MonVta = 2 THEN F-PRECIO = VtaListaMinGn.PreOfi * T-MATG.TpoCmb.
      CREATE Detalle-Vol.
      ASSIGN
          Detalle-Vol.CodMat = T-MATG.CodMat
          Detalle-Vol.CodFam = T-MATG.CodFam
          Detalle-Vol.SubFam = T-MATG.SubFam
          Detalle-Vol.DesMat = T-MATG.DesMat
          Detalle-Vol.DesMar = T-MATG.DesMar
          Detalle-Vol.CtoTot = T-MATG.CtoTot
          Detalle-Vol.PreOfi = F-PRECIO     /*T-MATG.PreOfi*/
          .
      DO I = 1 TO 10:
          IF i = 1 THEN
              ASSIGN
              Detalle-Vol.CanVol-1 = VtaListaMinGn.DtoVolR[i]
              Detalle-Vol.DtoVol-1 = VtaListaMinGn.DtoVolD[i]
              Detalle-Vol.PreVol-1 = IF VtaListaMinGn.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (VtaListaMinGn.DtoVolD[i] / 100 ) ),4) ELSE 0.
              .
          IF i = 2 THEN
              ASSIGN
              Detalle-Vol.CanVol-2 = VtaListaMinGn.DtoVolR[i]
              Detalle-Vol.DtoVol-2 = VtaListaMinGn.DtoVolD[i]
              Detalle-Vol.PreVol-2 = IF VtaListaMinGn.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (VtaListaMinGn.DtoVolD[i] / 100 ) ),4) ELSE 0.
              .
          IF i = 3 THEN
              ASSIGN
              Detalle-Vol.CanVol-3 = VtaListaMinGn.DtoVolR[i]
              Detalle-Vol.DtoVol-3 = VtaListaMinGn.DtoVolD[i]
              Detalle-Vol.PreVol-3 = IF VtaListaMinGn.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (VtaListaMinGn.DtoVolD[i] / 100 ) ),4) ELSE 0.
              .
          IF i = 4 THEN
              ASSIGN
              Detalle-Vol.CanVol-4 = VtaListaMinGn.DtoVolR[i]
              Detalle-Vol.DtoVol-4 = VtaListaMinGn.DtoVolD[i]
              Detalle-Vol.PreVol-4 = IF VtaListaMinGn.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (VtaListaMinGn.DtoVolD[i] / 100 ) ),4) ELSE 0.
              .
          IF i = 5 THEN
              ASSIGN
              Detalle-Vol.CanVol-5 = VtaListaMinGn.DtoVolR[i]
              Detalle-Vol.DtoVol-5 = VtaListaMinGn.DtoVolD[i]
              Detalle-Vol.PreVol-5 = IF VtaListaMinGn.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (VtaListaMinGn.DtoVolD[i] / 100 ) ),4) ELSE 0.
              .

              IF i = 6 THEN
                  ASSIGN
                  Detalle-Vol.CanVol-6 = VtaListaMinGn.DtoVolR[i]
                  Detalle-Vol.DtoVol-6 = VtaListaMinGn.DtoVolD[i]
                  Detalle-Vol.PreVol-6 = IF VtaListaMinGn.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (VtaListaMinGn.DtoVolD[i] / 100 ) ),4) ELSE 0.
                  .
              IF i = 7 THEN
                  ASSIGN
                  Detalle-Vol.CanVol-7 = VtaListaMinGn.DtoVolR[i]
                  Detalle-Vol.DtoVol-7 = VtaListaMinGn.DtoVolD[i]
                  Detalle-Vol.PreVol-7 = IF VtaListaMinGn.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (VtaListaMinGn.DtoVolD[i] / 100 ) ),4) ELSE 0.
                  .
              IF i = 8 THEN
                  ASSIGN
                  Detalle-Vol.CanVol-8 = VtaListaMinGn.DtoVolR[i]
                  Detalle-Vol.DtoVol-8 = VtaListaMinGn.DtoVolD[i]
                  Detalle-Vol.PreVol-8 = IF VtaListaMinGn.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (VtaListaMinGn.DtoVolD[i] / 100 ) ),4) ELSE 0.
                  .
              IF i = 9 THEN
                  ASSIGN
                  Detalle-Vol.CanVol-9 = VtaListaMinGn.DtoVolR[i]
                  Detalle-Vol.DtoVol-9 = VtaListaMinGn.DtoVolD[i]
                  Detalle-Vol.PreVol-9 = IF VtaListaMinGn.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (VtaListaMinGn.DtoVolD[i] / 100 ) ),4) ELSE 0.
                  .
              IF i = 10 THEN
                  ASSIGN
                  Detalle-Vol.CanVol-10 = VtaListaMinGn.DtoVolR[i]
                  Detalle-Vol.DtoVol-10 = VtaListaMinGn.DtoVolD[i]
                  Detalle-Vol.PreVol-10 = IF VtaListaMinGn.DtoVolR[i] <> 0 THEN ROUND(F-PRECIO * ( 1 - (VtaListaMinGn.DtoVolD[i] / 100 ) ),4) ELSE 0.
                  .
      END.
  END.

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
  DISPLAY COMBO-BOX-Linea COMBO-BOX-Sublinea RADIO-SET-Imprimir 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-14 RECT-15 COMBO-BOX-Linea COMBO-BOX-Sublinea BUTTON-Filtrar 
         BUTTON-Limpiar RADIO-SET-Imprimir BUTTON-Texto 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
  DEFINE VAR hProc AS HANDLE NO-UNDO.
  
  RUN GET-ATTRIBUTE('Current-Page').

  CASE RETURN-VALUE:
      WHEN '1' THEN DO:
          RUN pri/pri-librerias PERSISTENT SET hProc.
          RUN PRI_Divisiones-Validas IN hProc (INPUT 1, OUTPUT s-Divisiones).
          RUN dispatch IN h_b-lima-dctoprom ('open-query':U).
          RUN Disable-Columns IN h_b-lima-dctoprom.
      END.
      WHEN '2' THEN DO:
          RUN pri/pri-librerias PERSISTENT SET hProc.
          RUN PRI_Divisiones-Validas IN hProc (INPUT 2, OUTPUT s-Divisiones).
          RUN dispatch IN h_b-utilex-dctoprom ('open-query':U).
          RUN Disable-Columns IN h_b-utilex-dctoprom.
      END.
  END CASE.
  DELETE PROCEDURE hProc.

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
      FOR EACH Almtfami NO-LOCK WHERE Almtfami.CodCia = s-codcia AND Almtfami.SwComercial = YES:
          COMBO-BOX-Linea:ADD-LAST( Almtfami.codfam + ' - ' + Almtfami.desfam).
      END.
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

