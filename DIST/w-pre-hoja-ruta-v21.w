&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ALMACEN FOR Almacen.
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER ORDENES FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE T-CDOCU LIKE CcbCDocu.
DEFINE TEMP-TABLE T-RUTAD NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE T-VtaCTabla LIKE VtaCTabla.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF NEW SHARED VAR s-tabla  AS CHAR INIT 'ZGHR'.
DEF VAR s-tipmov AS CHAR INIT 'S' NO-UNDO.
DEF VAR s-codmov AS INT  INIT 03 NO-UNDO.
DEF VAR s-coddoc AS CHAR INIT 'PHR' NO-UNDO.    /* Pre Hoja de Ruta */

DEF NEW SHARED VAR lh_handle AS HANDLE.

FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia 
    AND FacCorre.CodDiv = s-coddiv 
    AND FacCorre.CodDoc = s-coddoc 
    AND FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'NO configurado el correlativo para el documento:' s-coddoc SKIP
        'en la división:' s-coddiv
        VIEW-AS ALERT-BOX WARNING.
    RETURN ERROR.
END.

DEF VAR SORTBY-NomCli     AS CHAR INIT "BY T-CDOCU.NomCli" NO-UNDO.
DEF VAR SORTORDER-NomCli  AS INT  INIT 0  NO-UNDO.
DEF VAR SORTBY-Peso       AS CHAR INIT "BY T-CDOCU.Libre_d01" NO-UNDO.
DEF VAR SORTORDER-Peso    AS INT  INIT 0  NO-UNDO.
DEF VAR SORTBY-Importe    AS CHAR INIT "BY T-CDOCU.ImpTot" NO-UNDO.
DEF VAR SORTORDER-Importe AS INT  INIT 0  NO-UNDO.
DEF VAR SORTBY-Pedido     AS CHAR INIT "BY T-CDOCU.NroPed" NO-UNDO.
DEF VAR SORTORDER-Pedido  AS INT  INIT 0  NO-UNDO.
DEF VAR SORTBY-Entrega     AS CHAR INIT "BY T-CDOCU.FchAte" NO-UNDO.
DEF VAR SORTORDER-Entrega  AS INT  INIT 0  NO-UNDO.
DEF VAR SORTBY-Sede       AS CHAR INIT "BY T-CDOCU.Sede" NO-UNDO.
DEF VAR SORTORDER-Sede    AS INT  INIT 0  NO-UNDO.
DEF VAR SORTBY-Distrito       AS CHAR INIT "BY T-CDOCU.LugEnt" NO-UNDO.
DEF VAR SORTORDER-Distrito    AS INT  INIT 0  NO-UNDO.

DEF VAR FLAG-NomCli  AS LOG INIT NO NO-UNDO.
DEF VAR FLAG-Peso    AS LOG INIT NO NO-UNDO.
DEF VAR FLAG-Importe AS LOG INIT NO NO-UNDO.
DEF VAR FLAG-Pedido  AS LOG INIT NO NO-UNDO.
DEF VAR FLAG-Entrega AS LOG INIT NO NO-UNDO.
DEF VAR FLAG-Sede    AS LOG INIT NO NO-UNDO.
DEF VAR FLAG-Distrito AS LOG INIT NO NO-UNDO.

DEF VAR SORTBY-General AS CHAR INIT "" NO-UNDO.


&SCOPED-DEFINE SORTBY-1

/* Tabla intermedia para el Excel */
DEF TEMP-TABLE Detalle
    FIELD Sede          LIKE T-CDOCU.Sede       LABEL 'Canal'       FORMAT 'x(30)'
    FIELD Descripcion   AS CHAR                 LABEL 'Zona'        FORMAT 'x(25)'
    FIELD LugEnt        LIKE T-CDOCU.LugEnt     LABEL 'Distrito'    FORMAT 'x(20)'
    FIELD NomCli        LIKE T-CDOCU.NomCli     LABEL 'Cliente'     FORMAT 'x(30)'
    FIELD CodPed        LIKE T-CDOCU.CodPed     LABEL 'Refer.'      FORMAT 'x(3)'
    FIELD NroPed        LIKE T-CDOCU.NroPed     LABEL 'Numero'      FORMAT 'x(12)'
    FIELD FchAte        LIKE T-CDOCU.FchAte     LABEL 'Fecha Entrega'   FORMAT '99/99/9999'
    FIELD CodDoc        LIKE T-CDOCU.CodDoc                         FORMAT 'x(3)'
    FIELD NroDoc        LIKE T-CDOCU.NroDoc                         FORMAT 'x(12)'
    FIELD Puntos        LIKE T-CDOCU.Puntos     LABEL 'Bultos'      FORMAT '>,>>9'
    FIELD Libre_d01     LIKE T-CDOCU.Libre_d01  LABEL 'Peso en Kg'  FORMAT '>>>,>>9.99'
    FIELD Libre_d02     LIKE T-CDOCU.Libre_d02  LABEL 'Peso en m3'  FORMAT '>>>,>>9.99'
    FIELD ImpTot        LIKE T-CDOCU.ImpTot     LABEL 'Importe en S/'   FORMAT '->>,>>>,>>9.99'
    FIELD Contacto      AS CHAR                 LABEL 'Contacto'    FORMAT 'x(60)'
    FIELD Telefono      AS CHAR                 LABEL 'Telefono'    FORMAT 'x(20)'
    FIELD CodVen        AS CHAR                 LABEL 'Vendedor'    FORMAT 'x(5)'
    FIELD NomVen        AS CHAR                 LABEL 'Nombre'      FORMAT 'x(50)'
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
&Scoped-define BROWSE-NAME BROWSE-CDOCU

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-CDOCU VtaCTabla T-RutaD

/* Definitions for BROWSE BROWSE-CDOCU                                  */
&Scoped-define FIELDS-IN-QUERY-BROWSE-CDOCU T-CDOCU.Sede ~
VtaCTabla.Descripcion T-CDOCU.LugEnt T-CDOCU.NomCli T-CDOCU.CodPed ~
T-CDOCU.NroPed T-CDOCU.FchAte T-CDOCU.NroDoc T-CDOCU.puntos ~
T-CDOCU.Libre_d01 T-CDOCU.Libre_d02 T-CDOCU.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-CDOCU 
&Scoped-define QUERY-STRING-BROWSE-CDOCU FOR EACH T-CDOCU ~
      WHERE (COMBO-BOX-Zona = 'Todos' OR T-CDOCU.Libre_c04 = COMBO-BOX-Zona) ~
 AND T-CDOCU.FlgEst <> 'A' NO-LOCK, ~
      FIRST VtaCTabla WHERE VtaCTabla.CodCia = T-CDOCU.CodCia ~
  AND VtaCTabla.Llave = T-CDOCU.Libre_c04 ~
      AND VtaCTabla.Tabla = s-Tabla NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-CDOCU OPEN QUERY BROWSE-CDOCU FOR EACH T-CDOCU ~
      WHERE (COMBO-BOX-Zona = 'Todos' OR T-CDOCU.Libre_c04 = COMBO-BOX-Zona) ~
 AND T-CDOCU.FlgEst <> 'A' NO-LOCK, ~
      FIRST VtaCTabla WHERE VtaCTabla.CodCia = T-CDOCU.CodCia ~
  AND VtaCTabla.Llave = T-CDOCU.Libre_c04 ~
      AND VtaCTabla.Tabla = s-Tabla NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-CDOCU T-CDOCU VtaCTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-CDOCU T-CDOCU
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-CDOCU VtaCTabla


/* Definitions for BROWSE BROWSE-RUTAD                                  */
&Scoped-define FIELDS-IN-QUERY-BROWSE-RUTAD T-RutaD.Sede ~
VtaCTabla.Descripcion T-RutaD.LugEnt T-RutaD.NomCli T-RutaD.CodPed ~
T-RutaD.NroPed T-RutaD.FchAte T-RutaD.NroDoc T-RutaD.puntos ~
T-RutaD.Libre_d01 T-RutaD.Libre_d02 T-RutaD.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-RUTAD 
&Scoped-define QUERY-STRING-BROWSE-RUTAD FOR EACH T-RutaD NO-LOCK, ~
      FIRST VtaCTabla WHERE VtaCTabla.Llave = T-RutaD.Libre_c04 ~
      AND VtaCTabla.CodCia = s-codcia ~
 AND VtaCTabla.Tabla = s-tabla NO-LOCK ~
    BY T-RutaD.Libre_c03 ~
       BY T-RutaD.Libre_c05 ~
        BY T-RutaD.Libre_c01 ~
         BY T-RutaD.Libre_c02 INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-RUTAD OPEN QUERY BROWSE-RUTAD FOR EACH T-RutaD NO-LOCK, ~
      FIRST VtaCTabla WHERE VtaCTabla.Llave = T-RutaD.Libre_c04 ~
      AND VtaCTabla.CodCia = s-codcia ~
 AND VtaCTabla.Tabla = s-tabla NO-LOCK ~
    BY T-RutaD.Libre_c03 ~
       BY T-RutaD.Libre_c05 ~
        BY T-RutaD.Libre_c01 ~
         BY T-RutaD.Libre_c02 INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-RUTAD T-RutaD VtaCTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-RUTAD T-RutaD
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-RUTAD VtaCTabla


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-CDOCU}~
    ~{&OPEN-QUERY-BROWSE-RUTAD}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-6 RADIO-SET-Condicion ~
BUTTON-Refrescar BtnDone FILL-IN-Desde BUTTON-1 FILL-IN-Hasta BUTTON-2 ~
BUTTON-Limpiar COMBO-BOX-Zona BROWSE-CDOCU BUTTON-Sube BUTTON-Baja ~
BUTTON-Sube-2 BUTTON-Baja-2 BUTTON-Auto BUTTON-3 BROWSE-RUTAD ~
BUTTON-Generar 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-Condicion FILL-IN-Desde ~
FILL-IN-Hasta COMBO-BOX-Zona FILL-IN-Peso-2 FILL-IN-Importe-2 ~
FILL-IN-Volumen-2 FILL-IN-Destinos FILL-IN-Peso FILL-IN-Importe ~
FILL-IN-Documentos FILL-IN-Volumen 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/calendar.bmp":U
     LABEL "Button 1" 
     SIZE 4 BY 1.08.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/calendar.bmp":U
     LABEL "Button 2" 
     SIZE 4 BY 1.08.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 6 BY 1.54.

DEFINE BUTTON BUTTON-Auto 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Button 4" 
     SIZE 6 BY 1.54 TOOLTIP "Automático".

DEFINE BUTTON BUTTON-Baja 
     IMAGE-UP FILE "img/up.ico":U
     LABEL "<" 
     SIZE 6 BY 1.54 TOOLTIP "Excluir seleccionados"
     FONT 8.

DEFINE BUTTON BUTTON-Baja-2 
     IMAGE-UP FILE "img/upblue.bmp":U
     LABEL "<<" 
     SIZE 6 BY 1.54 TOOLTIP "Excluir los que tienen el mismo cliente"
     FONT 8.

DEFINE BUTTON BUTTON-Generar 
     LABEL "GENERAR HOJA DE RUTA" 
     SIZE 31 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON-Limpiar 
     LABEL "LIMPIAR ORDENAMIENTO" 
     SIZE 21 BY 1.12.

DEFINE BUTTON BUTTON-Refrescar 
     LABEL "CARGA TEMPORALES" 
     SIZE 21 BY 1.08 TOOLTIP "REFRESCAR".

DEFINE BUTTON BUTTON-Sube 
     IMAGE-UP FILE "img/down.ico":U
     LABEL ">" 
     SIZE 6 BY 1.54 TOOLTIP "Incluir seleccionados"
     FONT 8.

DEFINE BUTTON BUTTON-Sube-2 
     IMAGE-UP FILE "img/downblue.bmp":U
     LABEL ">>" 
     SIZE 6 BY 1.54 TOOLTIP "Incluir los que tienen el mismo cliente"
     FONT 8.

DEFINE VARIABLE COMBO-BOX-Zona AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Filtrar por" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 58 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Desde AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Destinos AS INTEGER FORMAT "-ZZ,ZZZ,ZZ9":U INITIAL 0 
     LABEL "Destinos" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Documentos AS INTEGER FORMAT "-ZZ,ZZZ,ZZ9":U INITIAL 0 
     LABEL "Documentos" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Hasta AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Importe (S/)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Importe-2 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Importe (S/)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Peso (kg)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Peso-2 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Peso (kg)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Volumen AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Volumen (m3)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Volumen-2 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Volumen (m3)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RADIO-SET-Condicion AS CHARACTER INITIAL "D" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Documentados", "D",
"Sin Documentar", "S",
"Todos", "Todos"
     SIZE 18 BY 2.42 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 140 BY 3.23.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 140 BY 1.35.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-CDOCU FOR 
      T-CDOCU, 
      VtaCTabla SCROLLING.

DEFINE QUERY BROWSE-RUTAD FOR 
      T-RutaD, 
      VtaCTabla
    FIELDS(VtaCTabla.Descripcion) SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-CDOCU
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-CDOCU W-Win _STRUCTURED
  QUERY BROWSE-CDOCU NO-LOCK DISPLAY
      T-CDOCU.Sede COLUMN-LABEL "Canal" FORMAT "x(30)":U WIDTH 22.43
      VtaCTabla.Descripcion COLUMN-LABEL "Zona" FORMAT "x(25)":U
            WIDTH 20.43
      T-CDOCU.LugEnt COLUMN-LABEL "Distrito" FORMAT "x(20)":U WIDTH 19.86
      T-CDOCU.NomCli COLUMN-LABEL "Cliente" FORMAT "x(30)":U WIDTH 30
      T-CDOCU.CodPed COLUMN-LABEL "Refer." FORMAT "x(3)":U
      T-CDOCU.NroPed COLUMN-LABEL "Número" FORMAT "X(12)":U
      T-CDOCU.FchAte COLUMN-LABEL "Fecha Entrega" FORMAT "99/99/9999":U
      T-CDOCU.NroDoc COLUMN-LABEL "Guia Número" FORMAT "X(12)":U
            WIDTH 11
      T-CDOCU.puntos COLUMN-LABEL "Bultos" FORMAT ">,>>9":U
      T-CDOCU.Libre_d01 COLUMN-LABEL "Peso en kg" FORMAT ">>>,>>9.99":U
            WIDTH 9.43
      T-CDOCU.Libre_d02 COLUMN-LABEL "Volumen m3" FORMAT ">>>,>>9.99":U
      T-CDOCU.ImpTot COLUMN-LABEL "Importe en S/" FORMAT "->>,>>>,>>9.99":U
            WIDTH 9.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 140 BY 8.08
         FONT 4 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-RUTAD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-RUTAD W-Win _STRUCTURED
  QUERY BROWSE-RUTAD NO-LOCK DISPLAY
      T-RutaD.Sede COLUMN-LABEL "Canal" FORMAT "x(30)":U WIDTH 22.43
      VtaCTabla.Descripcion COLUMN-LABEL "Zona" FORMAT "x(25)":U
            WIDTH 20.43
      T-RutaD.LugEnt COLUMN-LABEL "Distrito" FORMAT "x(20)":U WIDTH 20.43
      T-RutaD.NomCli COLUMN-LABEL "Cliente" FORMAT "x(30)":U WIDTH 29.43
      T-RutaD.CodPed COLUMN-LABEL "Refer." FORMAT "x(3)":U WIDTH 4.43
      T-RutaD.NroPed COLUMN-LABEL "Número" FORMAT "X(12)":U WIDTH 8.43
      T-RutaD.FchAte COLUMN-LABEL "Fecha Entrega" FORMAT "99/99/9999":U
      T-RutaD.NroDoc COLUMN-LABEL "Guia Numero" FORMAT "X(12)":U
            WIDTH 10.86
      T-RutaD.puntos COLUMN-LABEL "Bultos" FORMAT ">>>,>>9":U WIDTH 4.43
      T-RutaD.Libre_d01 COLUMN-LABEL "Peso en kg" FORMAT ">>>,>>9.99":U
      T-RutaD.Libre_d02 COLUMN-LABEL "Volumen en m3" FORMAT ">>>,>>9.99":U
      T-RutaD.ImpTot FORMAT "->>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 141 BY 8.62
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-Condicion AT ROW 1.81 COL 11 NO-LABEL WIDGET-ID 42
     BUTTON-Refrescar AT ROW 1.81 COL 61 WIDGET-ID 2
     BtnDone AT ROW 1.81 COL 133 WIDGET-ID 28
     FILL-IN-Desde AT ROW 2.08 COL 39 COLON-ALIGNED WIDGET-ID 46
     BUTTON-1 AT ROW 2.08 COL 50 WIDGET-ID 50
     FILL-IN-Hasta AT ROW 3.15 COL 39 COLON-ALIGNED WIDGET-ID 48
     BUTTON-2 AT ROW 3.15 COL 50 WIDGET-ID 54
     BUTTON-Limpiar AT ROW 4.65 COL 71 WIDGET-ID 26
     COMBO-BOX-Zona AT ROW 4.77 COL 9 COLON-ALIGNED WIDGET-ID 10
     BROWSE-CDOCU AT ROW 5.85 COL 2 WIDGET-ID 200
     FILL-IN-Peso-2 AT ROW 13.92 COL 85 COLON-ALIGNED WIDGET-ID 32
     FILL-IN-Importe-2 AT ROW 13.92 COL 107 COLON-ALIGNED WIDGET-ID 30
     BUTTON-Sube AT ROW 14.19 COL 3 WIDGET-ID 4
     BUTTON-Baja AT ROW 14.19 COL 10 WIDGET-ID 20
     BUTTON-Sube-2 AT ROW 14.19 COL 17 WIDGET-ID 18
     BUTTON-Baja-2 AT ROW 14.19 COL 24 WIDGET-ID 22
     BUTTON-Auto AT ROW 14.19 COL 31 WIDGET-ID 24
     BUTTON-3 AT ROW 14.19 COL 38 WIDGET-ID 64
     FILL-IN-Volumen-2 AT ROW 14.73 COL 85 COLON-ALIGNED WIDGET-ID 34
     BROWSE-RUTAD AT ROW 15.81 COL 2 WIDGET-ID 300
     FILL-IN-Destinos AT ROW 24.42 COL 61 COLON-ALIGNED WIDGET-ID 38
     FILL-IN-Peso AT ROW 24.42 COL 86 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-Importe AT ROW 24.42 COL 107 COLON-ALIGNED WIDGET-ID 16
     BUTTON-Generar AT ROW 24.69 COL 3 WIDGET-ID 8
     FILL-IN-Documentos AT ROW 25.23 COL 61 COLON-ALIGNED WIDGET-ID 40
     FILL-IN-Volumen AT ROW 25.23 COL 86 COLON-ALIGNED WIDGET-ID 14
     "Rango de Fechas de Entrega:" VIEW-AS TEXT
          SIZE 21 BY .5 AT ROW 1.54 COL 31 WIDGET-ID 62
     "Parámetros de carga" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 1 COL 2 WIDGET-ID 56
          BGCOLOR 9 FGCOLOR 15 
     RECT-5 AT ROW 1.27 COL 2 WIDGET-ID 58
     RECT-6 AT ROW 4.5 COL 2 WIDGET-ID 60
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 143 BY 25.27
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-ALMACEN B "?" ? INTEGRAL Almacen
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: ORDENES B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: T-CDOCU T "?" ? INTEGRAL CcbCDocu
      TABLE: T-RUTAD T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: T-VtaCTabla T "?" ? INTEGRAL VtaCTabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "GENERACION DE PRE HOJAS DE RUTA"
         HEIGHT             = 25.27
         WIDTH              = 143
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
         MAX-BUTTON         = no
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
   FRAME-NAME L-To-R                                                    */
/* BROWSE-TAB BROWSE-CDOCU COMBO-BOX-Zona F-Main */
/* BROWSE-TAB BROWSE-RUTAD FILL-IN-Volumen-2 F-Main */
ASSIGN 
       BROWSE-CDOCU:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 4
       BROWSE-CDOCU:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

ASSIGN 
       BROWSE-RUTAD:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 4.

/* SETTINGS FOR FILL-IN FILL-IN-Destinos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Documentos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Volumen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Volumen-2 IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-CDOCU
/* Query rebuild information for BROWSE BROWSE-CDOCU
     _TblList          = "Temp-Tables.T-CDOCU,INTEGRAL.VtaCTabla WHERE Temp-Tables.T-CDOCU ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _Where[1]         = "(COMBO-BOX-Zona = 'Todos' OR T-CDOCU.Libre_c04 = COMBO-BOX-Zona)
 AND Temp-Tables.T-CDOCU.FlgEst <> 'A'"
     _JoinCode[2]      = "INTEGRAL.VtaCTabla.CodCia = Temp-Tables.T-CDOCU.CodCia
  AND INTEGRAL.VtaCTabla.Llave = Temp-Tables.T-CDOCU.Libre_c04"
     _Where[2]         = "INTEGRAL.VtaCTabla.Tabla = s-Tabla"
     _FldNameList[1]   > Temp-Tables.T-CDOCU.Sede
"T-CDOCU.Sede" "Canal" "x(30)" "character" ? ? ? ? ? ? no ? no no "22.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.VtaCTabla.Descripcion
"VtaCTabla.Descripcion" "Zona" "x(25)" "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-CDOCU.LugEnt
"T-CDOCU.LugEnt" "Distrito" "x(20)" "character" ? ? ? ? ? ? no ? no no "19.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-CDOCU.NomCli
"T-CDOCU.NomCli" "Cliente" "x(30)" "character" ? ? ? ? ? ? no ? no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-CDOCU.CodPed
"T-CDOCU.CodPed" "Refer." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-CDOCU.NroPed
"T-CDOCU.NroPed" "Número" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-CDOCU.FchAte
"T-CDOCU.FchAte" "Fecha Entrega" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-CDOCU.NroDoc
"T-CDOCU.NroDoc" "Guia Número" ? "character" ? ? ? ? ? ? no ? no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-CDOCU.puntos
"T-CDOCU.puntos" "Bultos" ">,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-CDOCU.Libre_d01
"T-CDOCU.Libre_d01" "Peso en kg" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-CDOCU.Libre_d02
"T-CDOCU.Libre_d02" "Volumen m3" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.T-CDOCU.ImpTot
"T-CDOCU.ImpTot" "Importe en S/" ? "decimal" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-CDOCU */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-RUTAD
/* Query rebuild information for BROWSE BROWSE-RUTAD
     _TblList          = "Temp-Tables.T-RutaD,INTEGRAL.VtaCTabla WHERE Temp-Tables.T-RutaD ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED"
     _OrdList          = "Temp-Tables.T-RutaD.Libre_c03|yes,Temp-Tables.T-RutaD.Libre_c05|yes,Temp-Tables.T-RutaD.Libre_c01|yes,Temp-Tables.T-RutaD.Libre_c02|yes"
     _JoinCode[2]      = "INTEGRAL.VtaCTabla.Llave = Temp-Tables.T-RutaD.Libre_c04"
     _Where[2]         = "INTEGRAL.VtaCTabla.CodCia = s-codcia
 AND INTEGRAL.VtaCTabla.Tabla = s-tabla"
     _FldNameList[1]   > Temp-Tables.T-RutaD.Sede
"T-RutaD.Sede" "Canal" "x(30)" "character" ? ? ? ? ? ? no ? no no "22.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.VtaCTabla.Descripcion
"VtaCTabla.Descripcion" "Zona" "x(25)" "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-RutaD.LugEnt
"T-RutaD.LugEnt" "Distrito" "x(20)" "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.T-RutaD.NomCli
"T-RutaD.NomCli" "Cliente" "x(30)" "character" ? ? ? ? ? ? no ? no no "29.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.T-RutaD.CodPed
"T-RutaD.CodPed" "Refer." ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-RutaD.NroPed
"T-RutaD.NroPed" "Número" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-RutaD.FchAte
"T-RutaD.FchAte" "Fecha Entrega" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.T-RutaD.NroDoc
"T-RutaD.NroDoc" "Guia Numero" ? "character" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.T-RutaD.puntos
"T-RutaD.puntos" "Bultos" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-RutaD.Libre_d01
"T-RutaD.Libre_d01" "Peso en kg" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-RutaD.Libre_d02
"T-RutaD.Libre_d02" "Volumen en m3" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   = Temp-Tables.T-RutaD.ImpTot
     _Query            is OPENED
*/  /* BROWSE BROWSE-RUTAD */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* GENERACION DE PRE HOJAS DE RUTA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* GENERACION DE PRE HOJAS DE RUTA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-CDOCU
&Scoped-define SELF-NAME BROWSE-CDOCU
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-CDOCU W-Win
ON START-SEARCH OF BROWSE-CDOCU IN FRAME F-Main
DO:
    DEFINE VAR hSortColumn   AS WIDGET-HANDLE.
    DEFINE VAR lColumName    AS CHAR.
    DEFINE VAR hQueryHandle  AS HANDLE NO-UNDO.
    DEFINE VAR lQueryPrepare AS CHAR NO-UNDO.

    hSortColumn = BROWSE BROWSE-CDOCU:CURRENT-COLUMN.
    lColumName = hSortColumn:NAME.
  
    hQueryHandle = BROWSE BROWSE-CDOCU:QUERY.
    hQueryHandle:QUERY-CLOSE().

    /* CONTROL DE COLUMNA ACTIVA */
    CASE lColumName:
        WHEN "NomCli"    THEN ASSIGN FLAG-NomCli  = YES T-CDOCU.NomCli:COLUMN-FGCOLOR = 0 T-CDOCU.NomCli:COLUMN-BGCOLOR = 11.
        WHEN "Libre_d01" THEN ASSIGN FLAG-Peso    = YES T-CDOCU.Libre_d01:COLUMN-FGCOLOR = 0 T-CDOCU.Libre_d01:COLUMN-BGCOLOR = 11.
        WHEN "ImpTot"    THEN ASSIGN FLAG-Importe = YES T-CDOCU.ImpTot:COLUMN-FGCOLOR = 0 T-CDOCU.ImpTot:COLUMN-BGCOLOR = 11.
        WHEN "NroPed"    THEN ASSIGN FLAG-Pedido  = YES T-CDOCU.NroPed:COLUMN-FGCOLOR = 0 T-CDOCU.NroPed:COLUMN-BGCOLOR = 11.
        WHEN "FchAte"    THEN ASSIGN FLAG-Entrega = YES T-CDOCU.FchAte:COLUMN-FGCOLOR = 0 T-CDOCU.FchAte:COLUMN-BGCOLOR = 11.
        WHEN "Sede"      THEN ASSIGN FLAG-Sede    = YES T-CDOCU.Sede:COLUMN-FGCOLOR   = 0 T-CDOCU.Sede:COLUMN-BGCOLOR = 11.
        WHEN "LugEnt"    THEN ASSIGN FLAG-Distrito = YES T-CDOCU.LugEnt:COLUMN-FGCOLOR = 0 T-CDOCU.LugEnt:COLUMN-BGCOLOR = 11.
    END CASE.

    IF FLAG-NomCli = YES AND INDEX(SORTBY-General,SORTBY-NomCli) = 0
        THEN SORTBY-General = SORTBY-General + (IF TRUE <> (SORTBY-General > '') THEN '' ELSE ' ') + SORTBY-NomCli.
    IF FLAG-Peso = YES AND INDEX(SORTBY-General,SORTBY-Peso) = 0
        THEN SORTBY-General = SORTBY-General + (IF TRUE <> (SORTBY-Peso > '')    THEN '' ELSE ' ') + SORTBY-Peso.
    IF FLAG-Importe = YES AND INDEX(SORTBY-General,SORTBY-Importe) = 0
        THEN SORTBY-General = SORTBY-General + (IF TRUE <> (SORTBY-Importe > '') THEN '' ELSE ' ') + SORTBY-Importe.
    IF FLAG-Pedido = YES AND INDEX(SORTBY-General,SORTBY-Pedido) = 0
        THEN SORTBY-General = SORTBY-General + (IF TRUE <> (SORTBY-Pedido > '')  THEN '' ELSE ' ') + SORTBY-Pedido.
    IF FLAG-Entrega = YES AND INDEX(SORTBY-General,SORTBY-Entrega) = 0
        THEN SORTBY-General = SORTBY-General + (IF TRUE <> (SORTBY-Entrega > '')  THEN '' ELSE ' ') + SORTBY-Entrega.
    IF FLAG-Sede = YES AND INDEX(SORTBY-General,SORTBY-Sede) = 0
        THEN SORTBY-General = SORTBY-General + (IF TRUE <> (SORTBY-Sede > '')  THEN '' ELSE ' ') + SORTBY-Sede.
    IF FLAG-Distrito = YES AND INDEX(SORTBY-General,SORTBY-Distrito) = 0
        THEN SORTBY-General = SORTBY-General + (IF TRUE <> (SORTBY-Distrito > '')  THEN '' ELSE ' ') + SORTBY-Distrito.

    CASE lColumName:
        WHEN "NomCli" THEN DO:
            IF SORTORDER-NomCli = 0 THEN SORTORDER-NomCli = 1.
            CASE SORTORDER-NomCli:
                WHEN 1 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-NomCli + ' DESC', SORTBY-NomCli).
                    SORTORDER-NomCli = 2.
                END.
                WHEN 2 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-NomCli, SORTBY-NomCli  + ' DESC').
                    SORTORDER-NomCli = 1.
                END.
            END CASE.
        END.
        WHEN "Libre_d01" THEN DO:
            IF SORTORDER-Peso = 0 THEN SORTORDER-Peso = 1.
             CASE SORTORDER-Peso:
                WHEN 1 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-Peso + ' DESC', SORTBY-Peso).
                    SORTORDER-Peso = 2.
                END.
                WHEN 2 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-Peso, SORTBY-Peso  + ' DESC').
                    SORTORDER-Peso = 1.
                END.
            END CASE.
        END.
        WHEN "ImpTot" THEN DO:
            IF SORTORDER-Importe = 0 THEN SORTORDER-Importe = 1.
            CASE SORTORDER-Importe:
                WHEN 1 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-Importe + ' DESC', SORTBY-Importe).
                    SORTBY-Importe = " BY T-CDOCU.ImpTot".
                    SORTORDER-Importe = 2.
                END.
                WHEN 2 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-Importe, SORTBY-Importe  + ' DESC').
                    SORTORDER-Importe = 1.
                END.
            END CASE.
        END.
        WHEN "NroPed" THEN DO:
            IF SORTORDER-Pedido = 0 THEN SORTORDER-Pedido = 1.
            CASE SORTORDER-Pedido:
                WHEN 1 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-Pedido + ' DESC', SORTBY-Pedido).
                    SORTORDER-Pedido = 2.
                END.
                WHEN 2 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-Pedido, SORTBY-Pedido  + ' DESC').
                    SORTORDER-Pedido = 1.
                END.
            END CASE.
        END.
        WHEN "FchAte" THEN DO:
            IF SORTORDER-Entrega = 0 THEN SORTORDER-Entrega = 1.
            CASE SORTORDER-Entrega:
                WHEN 1 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-Entrega + ' DESC', SORTBY-Entrega).
                    SORTORDER-Entrega = 2.
                END.
                WHEN 2 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-Entrega, SORTBY-Entrega  + ' DESC').
                    SORTORDER-Entrega = 1.
                END.
            END CASE.
        END.
        WHEN "Sede" THEN DO:
            IF SORTORDER-Sede = 0 THEN SORTORDER-Sede = 1.
            CASE SORTORDER-Sede:
                WHEN 1 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-Sede + ' DESC', SORTBY-Sede).
                    SORTORDER-Sede = 2.
                END.
                WHEN 2 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-Sede, SORTBY-Sede  + ' DESC').
                    SORTORDER-Sede = 1.
                END.
            END CASE.
        END.
        WHEN "LugEnt" THEN DO:
            IF SORTORDER-Distrito = 0 THEN SORTORDER-Distrito = 1.
            CASE SORTORDER-Distrito:
                WHEN 1 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-Distrito + ' DESC', SORTBY-Distrito).
                    SORTORDER-Distrito = 2.
                END.
                WHEN 2 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-Distrito, SORTBY-Distrito  + ' DESC').
                    SORTORDER-Distrito = 1.
                END.
            END CASE.
        END.
    END CASE.

    CASE COMBO-BOX-Zona:
        WHEN 'Todos' THEN lQueryPrepare = "FOR EACH T-CDOCU NO-LOCK WHERE T-CDOCU.FlgEst <> 'A'".
        OTHERWISE lQueryPrepare = "FOR EACH T-CDOCU NO-LOCK WHERE T-CDOCU.FlgEst <> 'A' AND T-CDOCU.Libre_c04 = '" + COMBO-BOX-Zona + "'".
    END CASE.

    lQueryPrepare = lQueryPrepare +
        ", FIRST VtaCTabla NO-LOCK WHERE VtaCTabla.CodCia = T-CDOCU.CodCia AND VtaCTabla.Llave = T-CDOCU.Libre_c04" +
        " AND INTEGRAL.VtaCTabla.Tabla = '" + s-Tabla + "' ".

    hQueryHandle:QUERY-PREPARE(lQueryPrepare + " " + SORTBY-General).
    hQueryHandle:QUERY-OPEN().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  RUN src/bin/_calenda.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
  DISPLAY RETURN-VALUE @ FILL-IN-Desde WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
    RUN src/bin/_calenda.
    IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
    DISPLAY RETURN-VALUE @ FILL-IN-Hasta WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Auto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Auto W-Win
ON CHOOSE OF BUTTON-Auto IN FRAME F-Main /* Button 4 */
DO:
  DEF VAR pPeso AS DEC NO-UNDO.
  DEF VAR pVolumen AS DEC NO-UNDO.
  DEF VAR pError AS LOG NO-UNDO.
  RUN dist/d-pre-hr-auto (OUTPUT pPeso, OUTPUT pVolumen, OUTPUT pError).
  IF pError = YES THEN RETURN NO-APPLY.
  RUN Pr-Automatico (pPeso, pVolumen).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Baja
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Baja W-Win
ON CHOOSE OF BUTTON-Baja IN FRAME F-Main /* < */
DO:
/*    RUN Pr-Baja IN h_b-pre-hoja-rutaf.                   */
/*    RUN dispatch IN h_b-pre-hoja-rutai ('open-query':U). */
/*    RUN dispatch IN h_b-pre-hoja-rutaf ('open-query':U). */
    RUN Pr-Baja.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Baja-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Baja-2 W-Win
ON CHOOSE OF BUTTON-Baja-2 IN FRAME F-Main /* << */
DO:
/*    RUN Pr-Baja IN h_b-pre-hoja-rutaf.                   */
/*    RUN dispatch IN h_b-pre-hoja-rutai ('open-query':U). */
/*    RUN dispatch IN h_b-pre-hoja-rutaf ('open-query':U). */
    RUN Pr-Baja-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Generar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Generar W-Win
ON CHOOSE OF BUTTON-Generar IN FRAME F-Main /* GENERAR HOJA DE RUTA */
DO:
   RUN Genera-PreHoja.
   APPLY 'CHOOSE':U TO BUTTON-Refrescar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Limpiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Limpiar W-Win
ON CHOOSE OF BUTTON-Limpiar IN FRAME F-Main /* LIMPIAR ORDENAMIENTO */
DO:
    DO WITH FRAME {&FRAME-NAME}:
        FLAG-NomCli  = NO.
        FLAG-Peso    = NO.
        FLAG-Importe = NO.
        FLAG-Pedido  = NO.
        FLAG-Entrega = NO.
        FLAG-Sede    = NO.
        FLAG-Distrito= NO.

        ASSIGN T-CDOCU.NomCli:COLUMN-FGCOLOR IN BROWSE {&browse-name} = ? T-CDOCU.NomCli:COLUMN-BGCOLOR IN BROWSE {&browse-name} = ?.
        ASSIGN T-CDOCU.Libre_d01:COLUMN-FGCOLOR IN BROWSE {&browse-name} = ? T-CDOCU.Libre_d01:COLUMN-BGCOLOR IN BROWSE {&browse-name} = ?.
        ASSIGN T-CDOCU.ImpTot:COLUMN-FGCOLOR IN BROWSE {&browse-name} = ? T-CDOCU.ImpTot:COLUMN-BGCOLOR IN BROWSE {&browse-name} = ?.
        ASSIGN T-CDOCU.NroPed:COLUMN-FGCOLOR IN BROWSE {&browse-name} = ? T-CDOCU.NroPed:COLUMN-BGCOLOR IN BROWSE {&browse-name} = ?.
        ASSIGN T-CDOCU.FchAte:COLUMN-FGCOLOR IN BROWSE {&browse-name} = ? T-CDOCU.FchAte:COLUMN-BGCOLOR IN BROWSE {&browse-name} = ?.
        ASSIGN T-CDOCU.Sede:COLUMN-FGCOLOR IN BROWSE {&browse-name} = ? T-CDOCU.Sede:COLUMN-BGCOLOR IN BROWSE {&browse-name} = ?.
        ASSIGN T-CDOCU.LugEnt:COLUMN-FGCOLOR IN BROWSE {&browse-name} = ? T-CDOCU.LugEnt:COLUMN-BGCOLOR IN BROWSE {&browse-name} = ?.

        SORTBY-General = "".

        SORTORDER-NomCli = 0.
        SORTORDER-Peso = 0.
        SORTORDER-Importe = 0.
        SORTORDER-Pedido = 0.
        SORTORDER-Entrega = 0.
        SORTORDER-Sede = 0.
        SORTORDER-Distrito = 0.

        {&OPEN-QUERY-BROWSE-CDOCU}
        RUN Totales.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Refrescar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Refrescar W-Win
ON CHOOSE OF BUTTON-Refrescar IN FRAME F-Main /* CARGA TEMPORALES */
DO:
/*   MESSAGE 'Se van a limpiar TODAS las tablas y cargar con información actualizada' SKIP */
/*       'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION                          */
/*       BUTTONS YES-NO UPDATE rpta AS LOG.                                                */
/*   IF rpta = NO THEN RETURN NO-APPLY.                                                    */
  ASSIGN
       FILL-IN-Desde FILL-IN-Hasta RADIO-SET-Condicion.
  IF FILL-IN-Desde = ? THEN FILL-IN-Desde = TODAY.
  IF FILL-IN-Hasta = ? THEN FILL-IN-Hasta = TODAY + 1.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporales.
  SESSION:SET-WAIT-STATE('').
  MESSAGE 'Carga Exitosa' VIEW-AS ALERT-BOX INFORMATION.
  {&OPEN-QUERY-BROWSE-CDOCU}
  {&OPEN-QUERY-BROWSE-RUTAD}
  RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Sube
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Sube W-Win
ON CHOOSE OF BUTTON-Sube IN FRAME F-Main /* > */
DO:
    RUN Pr-Sube.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Sube-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Sube-2 W-Win
ON CHOOSE OF BUTTON-Sube-2 IN FRAME F-Main /* >> */
DO:
    RUN Pr-Sube-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Zona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Zona W-Win
ON VALUE-CHANGED OF COMBO-BOX-Zona IN FRAME F-Main /* Filtrar por */
DO:
  ASSIGN {&self-name}.

  DO WITH FRAME {&FRAME-NAME}:
      FLAG-NomCli  = NO.
      FLAG-Peso    = NO.
      FLAG-Importe = NO.
      FLAG-Pedido  = NO.

      ASSIGN T-CDOCU.NomCli:COLUMN-FGCOLOR IN BROWSE {&browse-name} = ? T-CDOCU.NomCli:COLUMN-BGCOLOR IN BROWSE {&browse-name} = ?.
      ASSIGN T-CDOCU.Libre_d01:COLUMN-FGCOLOR IN BROWSE {&browse-name} = ? T-CDOCU.Libre_d01:COLUMN-BGCOLOR IN BROWSE {&browse-name} = ?.
      ASSIGN T-CDOCU.ImpTot:COLUMN-FGCOLOR IN BROWSE {&browse-name} = ? T-CDOCU.ImpTot:COLUMN-BGCOLOR IN BROWSE {&browse-name} = ?.
      ASSIGN T-CDOCU.NroPed:COLUMN-FGCOLOR IN BROWSE {&browse-name} = ? T-CDOCU.NroPed:COLUMN-BGCOLOR IN BROWSE {&browse-name} = ?.

      SORTBY-General = "".

      SORTORDER-NomCli = 0.
      SORTORDER-Peso = 0.
      SORTORDER-Importe = 0.
      SORTORDER-Pedido = 0.
      {&OPEN-QUERY-BROWSE-CDOCU}
      RUN Totales.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporales W-Win 
PROCEDURE Carga-Temporales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE T-VtaCTabla.
EMPTY TEMP-TABLE T-CDOCU.
EMPTY TEMP-TABLE T-RUTAD.

FOR EACH VtaCTabla NO-LOCK WHERE VtaCTabla.CodCia = s-codcia
    AND VtaCTabla.Tabla = s-tabla:
    CREATE T-VtaCTabla.
    BUFFER-COPY VtaCTabla TO T-VtaCTabla.
END.

/* Parámetros de Carga */
CASE RADIO-SET-Condicion:
    WHEN "D" THEN RUN Documentados.
    WHEN "S" THEN RUN NoDocumentados.
    OTHERWISE DO:
        RUN Documentados.
        RUN NoDocumentados.
    END.
END CASE.
RUN Datos-Finales.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Datos-Finales W-Win 
PROCEDURE Datos-Finales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* RHC 09/10/17 Limpiamos las que están fuera de rango de la fecha de entrega */
FOR EACH T-CDOCU:
    IF NOT (T-CDOCU.FchAte >= FILL-IN-Desde AND T-CDOCU.FchAte <= FILL-IN-Hasta)
        THEN DELETE T-CDOCU.
END.
/* Destino Teórico: Depende del Cliente */
FOR EACH T-CDOCU:
    /* Valor por Defecto */
    ASSIGN
        T-CDOCU.CodDpto = '15'
        T-CDOCU.CodProv = '01'      /* Lima - Lima */
        T-CDOCU.CodDist = '01'
        T-CDOCU.Libre_c05 = ''.     /* CODIGO POSTAL */
    CASE T-CDOCU.CodRef:
        WHEN "G/R" THEN DO:
            FIND gn-clie WHERE gn-clie.codcia = cl-codcia
                AND gn-clie.codcli = T-CDOCU.codcli
                NO-LOCK NO-ERROR.
            FIND FIRST TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept 
                AND TabDistr.CodProvi = gn-clie.CodProv 
                AND TabDistr.CodDistr = gn-clie.CodDist
                NO-LOCK NO-ERROR.
            IF AVAILABLE TabDistr THEN
                ASSIGN
                    T-CDOCU.CodDpto = TabDistr.CodDepto
                    T-CDOCU.CodProv = TabDistr.CodProvi
                    T-CDOCU.CodDist = TabDistr.CodDistr
                    T-CDOCU.Libre_c05 = TabDistr.CodPos.
            FIND PEDIDO WHERE PEDIDO.codcia = s-codcia
                AND PEDIDO.coddoc = T-CDOCU.Libre_c01
                AND PEDIDO.nroped = T-CDOCU.Libre_c02
                AND PEDIDO.codpos > ''
                NO-LOCK NO-ERROR.
            IF AVAILABLE PEDIDO THEN DO:
                FIND FIRST TabDistr WHERE TabDistr.CodPos = PEDIDO.CodPos NO-LOCK NO-ERROR.
                IF AVAILABLE TabDistr
                    THEN ASSIGN
                        T-CDOCU.CodDpto = TabDistr.CodDepto
                        T-CDOCU.CodProv = TabDistr.CodProvi
                        T-CDOCU.CodDist = TabDistr.CodDistr.
                ASSIGN
                    T-CDOCU.Libre_c05 = PEDIDO.CodPos.
            END.
        END.
        WHEN "GTR" THEN DO:
            FIND FIRST Almacen WHERE Almacen.codcia = T-CDOCU.codcia
                AND Almacen.codalm = T-CDOCU.codcli
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almacen THEN DO:
                FIND FIRST gn-divi WHERE GN-DIVI.CodCia = Almacen.codcia
                    AND GN-DIVI.CodDiv = Almacen.coddiv
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-divi THEN DO:
                    ASSIGN
                        T-CDOCU.CodDpto = GN-DIVI.Campo-Char[3]
                        T-CDOCU.CodProv = GN-DIVI.Campo-Char[4]
                        T-CDOCU.CodDist = GN-DIVI.Campo-Char[5].
                    FIND FIRST TabDistr WHERE TabDistr.CodDepto = T-CDOCU.CodDpto
                        AND TabDistr.CodProvi = T-CDOCU.CodProv
                        AND TabDistr.CodDistr = T-CDOCU.CodDist
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE TabDistr THEN ASSIGN T-CDOCU.Libre_c05 = TabDistr.CodPos.
                END.
            END.
        END.
    END CASE.
END.
/* Acumulamos */
FOR EACH T-CDOCU:
    FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-codcia
        AND VtaDTabla.Tabla = s-tabla
        AND VtaDTabla.Libre_c01 = T-CDOCU.CodDpto
        AND VtaDTabla.Libre_c02 = T-CDOCU.CodProv
        AND VtaDTabla.Libre_c03 = T-CDOCU.CodDist,
        FIRST T-VtaCTabla OF VtaDTabla:
        ASSIGN
            T-VtaCTabla.Libre_d01 = T-VtaCTabla.Libre_d01 + 1
            T-VtaCTabla.Libre_d02 = T-VtaCTabla.Libre_d02 + T-CDOCU.libre_d01
            T-VtaCTabla.Libre_d03 = T-VtaCTabla.Libre_d03 + T-CDOCU.libre_d02
            T-VtaCTabla.Libre_d04 = T-VtaCTabla.Libre_d04 + T-CDOCU.imptot.
        ASSIGN
            T-CDOCU.Libre_c04 = T-VtaCTabla.Llave.
    END.
    IF T-CDOCU.Libre_c05 = "P0" THEN T-CDOCU.Libre_c04 = "02".  /* LIMA CENTRO AGENCIAS */
    /* Otros Datos */
    FIND FIRST GN-DIVI WHERE GN-DIVI.CodCia = T-CDOCU.CodCia
        AND GN-DIVI.CodDiv = T-CDOCU.DivOri NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN T-CDOCU.Sede = gn-divi.desdiv.
    FIND TabDistr WHERE TabDistr.CodDepto = T-CDOCU.CodDpto
        AND TabDistr.CodProvi = T-CDOCU.CodProv
        AND TabDistr.CodDistr = T-CDOCU.CodDist
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN T-CDOCU.LugEnt = TabDistr.NomDistr.
    FIND FIRST CcbCBult WHERE CcbCBult.CodCia = s-codcia
        AND CcbCBult.CodDoc = T-CDOCU.CodPed
        AND CcbCBult.NroDoc = T-CDOCU.NroPed
        AND CcbCBult.CHR_01 = "P"                     /* H/R Aún NO cerrada */
        NO-LOCK NO-ERROR.
    IF AVAILABLE CcbCBult THEN T-CDOCU.puntos = CcbCBult.Bultos.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Documentados W-Win 
PROCEDURE Documentados PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Cargamos Guias */
DEFINE VARIABLE pResumen AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iInt     AS INTEGER     NO-UNDO.
DEFINE VARIABLE cValor   AS CHARACTER   NO-UNDO.

/* Guias de Remisión por Ventas */
FOR EACH Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia 
    AND CcbCDocu.CodDiv = s-coddiv
    AND CcbCDocu.CodDoc = 'G/R'
    AND CcbCDocu.FlgEst = "F"
    AND CcbCDocu.TpoFac <> "I"      /* NO Itinerantes */
    AND CcbCDocu.FchDoc >= TODAY - 7:
    /* Buscamos la referencia */
    FIND B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
          AND B-CDOCU.coddoc = Ccbcdocu.codref
          AND B-CDOCU.nrodoc = Ccbcdocu.nroref
          NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN NEXT.
    /* NO CONTADO ANTICIPADO PENDIENTES DE PAGO */
    IF AVAILABLE B-CDOCU AND B-CDOCU.fmapgo = '002' AND B-CDOCU.flgest <> "C"
        THEN NEXT.
    /* Buscamos si ya ha sido registrada en una PRE H/R en Proceso */
    FIND FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-codcia
        AND DI-RutaD.CodDiv = s-coddiv
        AND DI-RutaD.CodDoc = "PHR"
        AND DI-RutaD.CodRef = Ccbcdocu.coddoc
        AND DI-RutaD.NroRef = Ccbcdocu.nrodoc
        AND CAN-FIND(FIRST Di-Rutac OF Di-rutad WHERE Di-rutac.flgest = "P" NO-LOCK)
        NO-LOCK NO-ERROR.
    IF AVAILABLE Di-rutad THEN NEXT.
    /* Buscamos si ya ha sido registrada en una H/R */
    FIND FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-codcia
        AND DI-RutaD.CodDiv = s-coddiv
        AND DI-RutaD.CodDoc = "H/R"
        AND DI-RutaD.CodRef = Ccbcdocu.coddoc
        AND DI-RutaD.NroRef = Ccbcdocu.nrodoc
        AND CAN-FIND(FIRST Di-Rutac OF Di-rutad WHERE Di-rutac.flgest <> "A" NO-LOCK)
        NO-LOCK NO-ERROR.
    IF AVAILABLE Di-rutad THEN NEXT.
/*     FIND FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-codcia                             */
/*         AND DI-RutaD.CodDiv = s-coddiv                                               */
/*         AND DI-RutaD.CodDoc = "H/R"                                                  */
/*         AND DI-RutaD.CodRef = Ccbcdocu.coddoc                                        */
/*         AND DI-RutaD.NroRef = Ccbcdocu.nrodoc                                        */
/*         AND DI-RutaD.FlgEst = "C"                                                    */
/*         AND CAN-FIND(FIRST Di-Rutac OF Di-rutad WHERE Di-rutac.flgest = "C" NO-LOCK) */
/*         NO-LOCK NO-ERROR.                                                            */
/*     IF AVAILABLE Di-rutad THEN NEXT.                                                 */
/*     FIND FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-codcia                             */
/*         AND DI-RutaD.CodDiv = s-coddiv                                               */
/*         AND DI-RutaD.CodDoc = "H/R"                                                  */
/*         AND DI-RutaD.CodRef = Ccbcdocu.coddoc                                        */
/*         AND DI-RutaD.NroRef = Ccbcdocu.nrodoc                                        */
/*         AND DI-RutaD.FlgEst = "P"                                                    */
/*         AND CAN-FIND(FIRST Di-Rutac OF Di-rutad WHERE Di-rutac.flgest = "P" NO-LOCK) */
/*         NO-LOCK NO-ERROR.                                                            */
/*     IF AVAILABLE Di-rutad THEN NEXT.                                                 */
    CREATE T-CDOCU.
    ASSIGN
        T-CDOCU.CodCia = s-codcia
        T-CDOCU.CodDiv = s-coddiv
        T-CDOCU.CodDoc = CcbCDocu.CodDoc
        T-CDOCU.NroDoc = CcbCDocu.NroDoc
        T-CDOCU.CodRef = "G/R"      /* Guia por Ventas */
        T-CDOCU.CodCli = CcbCDocu.CodCli
        T-CDOCU.NomCli = CcbCDocu.NomCli
        T-CDOCU.CodPed = B-CDOCU.Libre_c01   /* O/D */
        T-CDOCU.NroPed = B-CDOCU.Libre_c02
        T-CDOCU.Libre_c01 = B-CDOCU.CodPed  /* PED */
        T-CDOCU.Libre_c02 = B-CDOCU.NroPed  
        T-CDOCU.DivOri = B-CDOCU.DivOri
        T-CDOCU.FlgSit = "D"
        T-CDOCU.CodVen = CcbCDocu.CodVen.
    /* Pesos y Volumenes */
    RUN Vta/resumen-pedido (T-CDOCU.CodDiv, T-CDOCU.CodDoc, T-CDOCU.NroDoc, OUTPUT pResumen).
    pResumen = SUBSTRING(pResumen,2,(LENGTH(pResumen) - 2)).
    cValor = ''.
    DO iint = 1 TO NUM-ENTRIES(pResumen,"/"):
        cValor = cValor + SUBSTRING(ENTRY(iint,pResumen,"/"),4) + ','.
    END.
    ASSIGN
        T-CDOCU.Libre_d01 = DEC(ENTRY(4,cValor))    /* Peso en Kg */
        T-CDOCU.Libre_d02 = DEC(ENTRY(5,cValor))    /* Volumen en m3 */
        T-CDOCU.ImpTot    = (IF Ccbcdocu.codmon = 2 THEN Ccbcdocu.TpoCmb * Ccbcdocu.ImpTot ELSE Ccbcdocu.ImpTot).
    IF T-CDOCU.Libre_d01 = ? THEN T-CDOCU.Libre_d01 = 0.
    IF T-CDOCU.Libre_d02 = ? THEN T-CDOCU.Libre_d02 = 0.
    /* Fecha de entrega 04/014/2017 Felix Perez */
    FIND PEDIDO WHERE PEDIDO.codcia = s-codcia
        AND PEDIDO.coddoc = T-CDOCU.CodPed
        AND PEDIDO.nroped = T-CDOCU.NroPed
        NO-LOCK NO-ERROR.
    IF AVAILABLE PEDIDO THEN T-CDOCU.FchAte = PEDIDO.FchEnt.
END.

/* Guias de Remisión por Transferencias */
DEFINE VAR lPesos AS DEC.
DEFINE VAR lCosto AS DEC.
DEFINE VAR lVolumen AS DEC.    
DEFINE VAR lValorizado AS LOGICAL.
FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = s-codcia
    AND Almacen.CodDiv = s-coddiv,
    EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = Almacen.codcia
    AND Almcmov.CodAlm = Almacen.codalm
    AND Almcmov.TipMov = s-tipmov
    AND Almcmov.CodMov = s-codmov
    AND Almcmov.FlgEst <> "A"
    AND Almcmov.FlgSit = "T":
    /* Buscamos si ya ha sido registrada en una PRE H/R en Proceso */
    FIND Di-RutaG WHERE Di-RutaG.CodCia = Almcmov.codcia
        AND Di-RutaG.CodAlm = Almcmov.codalm
        AND Di-RutaG.CodDiv = s-coddiv
        AND Di-RutaG.CodDoc = "PHR"
        AND Di-RutaG.serref = Almcmov.nroser
        AND Di-RutaG.nroref = Almcmov.nrodoc
        AND Di-RutaG.Tipmov = Almcmov.tipmov
        AND Di-RutaG.Codmov = Almcmov.codmov
        AND CAN-FIND(FIRST Di-Rutac OF Di-RutaG WHERE Di-rutac.flgest = "P" NO-LOCK)
        NO-LOCK NO-ERROR.
    IF AVAILABLE Di-rutag THEN NEXT.
    /* Buscamos si ya ha sido registrada en una H/R */
    FIND FIRST Di-RutaG WHERE Di-RutaG.CodCia = Almcmov.codcia
        AND Di-RutaG.CodAlm = Almcmov.codalm
        AND Di-RutaG.CodDiv = s-coddiv
        AND Di-RutaG.CodDoc = "H/R"
        AND Di-RutaG.nroref = Almcmov.nrodoc
        AND Di-RutaG.serref = Almcmov.nroser
        AND Di-RutaG.Tipmov = Almcmov.tipmov
        AND Di-RutaG.Codmov = Almcmov.codmov
        AND CAN-FIND(FIRST Di-Rutac OF Di-rutad WHERE Di-rutac.flgest <> "A" NO-LOCK)
        NO-LOCK NO-ERROR.
    IF AVAILABLE Di-rutag THEN NEXT.
/*     FIND FIRST Di-RutaG WHERE Di-RutaG.CodCia = Almcmov.codcia                       */
/*         AND Di-RutaG.CodAlm = Almcmov.codalm                                         */
/*         AND Di-RutaG.CodDiv = s-coddiv                                               */
/*         AND Di-RutaG.CodDoc = "H/R"                                                  */
/*         AND Di-RutaG.FlgEst = "C"                                                    */
/*         AND Di-RutaG.nroref = Almcmov.nrodoc                                         */
/*         AND Di-RutaG.serref = Almcmov.nroser                                         */
/*         AND Di-RutaG.Tipmov = Almcmov.tipmov                                         */
/*         AND Di-RutaG.Codmov = Almcmov.codmov                                         */
/*         AND CAN-FIND(FIRST Di-Rutac OF Di-rutad WHERE Di-rutac.flgest = "C" NO-LOCK) */
/*         NO-LOCK NO-ERROR.                                                            */
/*     IF AVAILABLE Di-rutag THEN NEXT.                                                 */
/*     FIND Di-RutaG WHERE Di-RutaG.CodCia = Almcmov.codcia                             */
/*         AND Di-RutaG.CodAlm = Almcmov.codalm                                         */
/*         AND Di-RutaG.CodDiv = s-coddiv                                               */
/*         AND Di-RutaG.CodDoc = "H/R"                                                  */
/*         AND Di-RutaG.FlgEst = "P"                                                    */
/*         AND Di-RutaG.nroref = Almcmov.nrodoc                                         */
/*         AND Di-RutaG.serref = Almcmov.nroser                                         */
/*         AND Di-RutaG.Tipmov = Almcmov.tipmov                                         */
/*         AND Di-RutaG.Codmov = Almcmov.codmov                                         */
/*         AND CAN-FIND(FIRST Di-Rutac OF Di-rutad WHERE Di-rutac.flgest = "P" NO-LOCK) */
/*         NO-LOCK NO-ERROR.                                                            */
/*     IF AVAILABLE Di-rutag THEN NEXT.                                                 */
    /* RHC 16/08/2012 CONSISTENCIA DE ROTULADO */
    CASE TRUE:
        WHEN Almcmov.CodRef = "OTR" THEN DO:
            FIND FIRST CcbCBult WHERE CcbCBult.CodCia = s-codcia
                AND CcbCBult.CodDoc = Almcmov.CodRef
                AND CcbCBult.NroDoc = Almcmov.NroRef
                AND CcbCBult.CHR_01 = "P"
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Ccbcbult THEN NEXT.
        END.
        OTHERWISE DO:
            FIND FIRST CcbCBult WHERE CcbCBult.CodCia = s-codcia
                AND CcbCBult.CodDoc = "TRA"
                AND CcbCBult.NroDoc = STRING(Almcmov.NroSer) +
                                      STRING(Almcmov.NroDoc , '9999999')
                AND CcbCBult.CHR_01 = "P"
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Ccbcbult THEN NEXT.
        END.
    END CASE.

    CREATE T-CDOCU.
    ASSIGN
        T-CDOCU.CodCia = s-codcia
        T-CDOCU.CodDiv = s-coddiv
        T-CDOCU.CodDoc = "G/R"
        T-CDOCU.NroDoc = STRING(Almcmov.NroSer,'999') + STRING(Almcmov.NroDoc,'999999999')
        T-CDOCU.CodRef = "GTR"     /* Transferencia */
        T-CDOCU.CodCli = Almcmov.AlmDes
        T-CDOCU.CodAlm = Almcmov.CodAlm
        T-CDOCU.CodPed = Almcmov.codref     /* OTR */
        T-CDOCU.NroPed = Almcmov.nroref
        T-CDOCU.FlgSit = "D".

    FIND B-ALMACEN WHERE B-ALMACEN.codcia = s-codcia
        AND B-ALMACEN.codalm = Almcmov.almdes NO-LOCK NO-ERROR.
    IF AVAILABLE B-ALMACEN  THEN 
        ASSIGN 
            T-CDOCU.NomCli = B-ALMACEN.descripcion
            T-CDOCU.DivOri = B-ALMACEN.coddiv.
    lPesos = 0.
    lCosto = 0.
    lVolumen = 0.
    FOR EACH almdmov OF almcmov NO-LOCK, FIRST Almmmatg OF Almdmov NO-LOCK:
        /* Peso */
        lPesos = lPesos + (Almdmov.CanDes * Almdmov.Factor * Almmmatg.PesMat).
        /* Volumen */
        lVolumen = lVolumen + ( Almdmov.candes * Almdmov.factor * ( almmmatg.libre_d02 / 1000000)).
        /* Costo */
        FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia 
            AND AlmStkGe.codmat = almdmov.codmat 
            AND AlmStkGe.fecha <= DI-RutaC.Fchdoc NO-LOCK NO-ERROR.
        lValorizado = NO.
        IF AVAILABLE AlmStkGe AND AlmStkGe.CtoUni <> ? THEN DO:
            /* Costo KARDEX */
            lCosto = lCosto + ( AlmStkGe.CtoUni * (AlmDmov.candes * AlmDmov.factor) ).
            lValorizado = YES.
        END.
        /* Si tiene valorizacion CERO, cargo el precio de venta */
        IF lValorizado = NO THEN DO:
            IF almmmatg.monvta = 2 THEN DO:
                /* Dolares */
                lCosto = lCosto + ((Almmmatg.preofi * Almmmatg.tpocmb) * AlmDmov.candes * Almdmov.factor).
            END.
            ELSE lCosto = lCosto + (Almmmatg.preofi * AlmDmov.candes * Almdmov.factor).
        END.
    END.
    ASSIGN 
        T-CDOCU.libre_d01 = lPesos
        T-CDOCU.libre_d02 = lVolumen
        T-CDOCU.imptot    = lCosto.           
    IF T-CDOCU.Libre_d01 = ? THEN T-CDOCU.Libre_d01 = 0.
    IF T-CDOCU.Libre_d02 = ? THEN T-CDOCU.Libre_d02 = 0.
    /* Fecha de entrega 04/014/2017 Felix Perez */
    FIND PEDIDO WHERE PEDIDO.codcia = s-codcia
        AND PEDIDO.coddoc = T-CDOCU.CodPed
        AND PEDIDO.nroped = T-CDOCU.NroPed
        NO-LOCK NO-ERROR.
    IF AVAILABLE PEDIDO THEN ASSIGN T-CDOCU.FchAte = PEDIDO.FchEnt.
END.


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
  DISPLAY RADIO-SET-Condicion FILL-IN-Desde FILL-IN-Hasta COMBO-BOX-Zona 
          FILL-IN-Peso-2 FILL-IN-Importe-2 FILL-IN-Volumen-2 FILL-IN-Destinos 
          FILL-IN-Peso FILL-IN-Importe FILL-IN-Documentos FILL-IN-Volumen 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-5 RECT-6 RADIO-SET-Condicion BUTTON-Refrescar BtnDone 
         FILL-IN-Desde BUTTON-1 FILL-IN-Hasta BUTTON-2 BUTTON-Limpiar 
         COMBO-BOX-Zona BROWSE-CDOCU BUTTON-Sube BUTTON-Baja BUTTON-Sube-2 
         BUTTON-Baja-2 BUTTON-Auto BUTTON-3 BROWSE-RUTAD BUTTON-Generar 
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

/* Archivo de Salida */
DEF VAR c-csv-file AS CHAR NO-UNDO.
DEF VAR c-xls-file AS CHAR INIT 'Archivo_Excel' NO-UNDO.
DEF VAR rpta AS LOG INIT NO NO-UNDO.

SYSTEM-DIALOG GET-FILE c-xls-file
    FILTERS 'Libro de Excel' '*.xlsx'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".xlsx"
    SAVE-AS
    TITLE "Guardar como"
    USE-FILENAME
    UPDATE rpta.
IF rpta = NO THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
/* Variable de memoria */
DEFINE VAR hProc AS HANDLE NO-UNDO.
/* Levantamos la libreria a memoria */
RUN lib\Tools-to-excel PERSISTENT SET hProc.

/* Cargamos la informacion al temporal */
EMPTY TEMP-TABLE Detalle.
DEF BUFFER B-CDOCU FOR T-CDOCU.
FOR EACH B-CDOCU WHERE (COMBO-BOX-Zona = 'Todos' OR B-CDOCU.Libre_c04 = COMBO-BOX-Zona)
    AND B-CDOCU.FlgEst <> 'A' NO-LOCK,
    FIRST VtaCTabla WHERE VtaCTabla.CodCia = B-CDOCU.CodCia
    AND VtaCTabla.Llave = B-CDOCU.Libre_c04
    AND VtaCTabla.Tabla = s-Tabla NO-LOCK:
    CREATE Detalle.
    BUFFER-COPY B-CDOCU TO Detalle
        ASSIGN Detalle.Descripcion = VtaCTabla.Descripcion.
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcl = B-CDOCU.codcli
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN
        ASSIGN
        Detalle.Contacto = gn-clie.repleg[1]
        Detalle.Telefono = gn-clie.Telfnos[1].
    FIND gn-ven WHERE gn-ven.CodCia = s-codcia
        AND gn-ven.CodVen = B-CDOCU.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN
        ASSIGN
        Detalle.codven = gn-ven.codven
        Detalle.nomven = gn-ven.NomVen.
END.

/* Programas que generan el Excel */
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .

RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle:handle,
                                  INPUT  c-csv-file,
                                  OUTPUT c-xls-file) .

/* Borramos librerias de la memoria */
DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-PreHoja W-Win 
PROCEDURE Genera-PreHoja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT CAN-FIND(FIRST Faccorre WHERE FacCorre.CodCia = s-codcia 
                AND FacCorre.CodDiv = s-coddiv 
                AND FacCorre.CodDoc = s-coddoc 
                AND FacCorre.FlgEst = YES
                NO-LOCK) THEN DO:
    MESSAGE 'NO definido el correlativo para el documento:' s-coddoc VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

MESSAGE 'Procedemos con la generación de la Pre Hoja de Ruta?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

DEF VAR pError AS CHAR INIT 'ERROR' NO-UNDO.

DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    {lib/lock-genericov21.i &Tabla="FacCorre" ~
        &Alcance="FIRST" ~
        &Condicion="FacCorre.CodCia = s-codcia ~
        AND FacCorre.CodDiv = s-coddiv ~
        AND FacCorre.CodDoc = s-coddoc ~
        AND FacCorre.FlgEst = YES" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="DO: pError = 'ERROR'. UNDO, LEAVE. END" ~
        }
    CREATE DI-RutaC.
    ASSIGN
        DI-RutaC.CodCia = s-codcia
        DI-RutaC.CodDiv = s-coddiv
        DI-RutaC.CodDoc = s-coddoc
        DI-RutaC.FchDoc = TODAY
        DI-RutaC.NroDoc = STRING(FacCorre.nroser, '999') + 
                            STRING(FacCorre.correlativo, '999999')
        DI-RutaC.usuario = s-user-id
        DI-RutaC.flgest  = "P".     /* Pendiente */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    pError = DI-RutaC.CodDoc + ' ' + DI-RutaC.NroDoc.
    FOR EACH T-RUTAD:
        CASE T-RUTAD.CodRef:
            WHEN "G/R" THEN RUN Genera-Ventas.
            WHEN "GTR" THEN RUN Genera-Transferencias.
        END CASE.
    END.
END.
IF AVAILABLE FacCorre THEN RELEASE FacCorre.
IF AVAILABLE DI-RutaC THEN RELEASE DI-RutaC.
IF pError <> 'ERROR' THEN MESSAGE 'Se generó el documento:' pError VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Transferencias W-Win 
PROCEDURE Genera-Transferencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lAlmacen AS CHAR.
DEFINE VAR lSerMovAlm AS INT.
DEFINE VAR lNroMovAlm AS INT64.

ASSIGN
    lAlmacen   = T-RUTAD.CodAlm
    lSerMovAlm = INTEGER(SUBSTRING(T-RUTAD.NroDoc,1,3))
    lNroMovAlm = INTEGER(SUBSTRING(T-RUTAD.NroDoc,4)).
CREATE Di-RutaG.
ASSIGN 
    Di-RutaG.CodCia = Di-RutaC.CodCia
    Di-RutaG.CodDiv = Di-RutaC.CodDiv
    Di-RutaG.CodDoc = Di-RutaC.CodDoc
    Di-RutaG.NroDoc = Di-RutaC.NroDoc
    Di-RutaG.Tipmov = s-tipmov
    Di-RutaG.Codmov = s-codmov
    Di-RutaG.CodAlm = lAlmacen.
ASSIGN
    Di-RutaG.nroref = lNroMovAlm
    Di-RutaG.serref = lSerMovAlm.
DISPLAY di-rutag WITH 1 COL FRAME f-frame.
/* Guardos los pesos y el costo de Mov. Almacen - Ic 10Jul2013 */
DEFINE VAR lPesos AS DEC.
DEFINE VAR lCosto AS DEC.
DEFINE VAR lVolumen AS DEC.    
DEFINE VAR lValorizado AS LOGICAL.

lPesos = 0.
lCosto = 0.
lVolumen = 0.

FOR EACH almdmov NO-LOCK WHERE almdmov.codcia = s-codcia
    AND almdmov.codalm = lAlmacen
    AND almdmov.tipmov = s-tipmov 
    AND almdmov.codmov = s-codmov
    AND almdmov.nroser = lSerMovAlm
    AND almdmov.nrodoc = lNroMovAlm,
    FIRST Almmmatg OF Almdmov NO-LOCK:
    lPesos = lPesos + (Almdmov.candes * Almdmov.factor * Almmmatg.pesmat).
    /* Ic - 28Feb2015 : Felix Perez indico que se valorize con el precio de venta*/
    lValorizado = NO.
    /* Volumen */
    lVolumen = lVolumen + ( Almdmov.candes * Almdmov.factor * ( almmmatg.libre_d02 / 1000000)).
    /* Si tiene valorzacion CERO, cargo el precio de venta */
    IF lValorizado = NO THEN DO:
        IF almmmatg.monvta = 2 THEN DO:
            /* Dolares */
            lCosto = lCosto + ((Almmmatg.preofi * Almmmatg.tpocmb) * AlmDmov.candes * Almdmov.factor).
        END.
        ELSE lCosto = lCosto + (Almmmatg.preofi * AlmDmov.candes *  Almdmov.factor).
    END.
END.

ASSIGN 
    Di-RutaG.libre_d01 = lPesos
    Di-RutaG.libre_d02 = lCosto.           
    Di-RutaG.libre_d03 = lVolumen.

RELEASE Di-RutaG.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Ventas W-Win 
PROCEDURE Genera-Ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE pResumen AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iInt     AS INTEGER     NO-UNDO.
DEFINE VARIABLE cValor   AS CHARACTER   NO-UNDO.

CREATE DI-RutaD.
ASSIGN
    DI-RutaD.CodCia = DI-RutaC.CodCia
    DI-RutaD.CodDiv = DI-RutaC.CodDiv
    DI-RutaD.CodDoc = DI-RutaC.CodDoc
    DI-RutaD.NroDoc = DI-RutaC.NroDoc
    DI-RutaD.CodRef = T-RUTAD.CodDoc
    DI-RutaD.NroRef = T-RUTAD.NroDoc.
/* Pesos y Volumenes */
RUN Vta/resumen-pedido (DI-RutaD.CodDiv, DI-RutaD.CodRef, DI-RutaD.NroRef, OUTPUT pResumen).
pResumen = SUBSTRING(pResumen,2,(LENGTH(pResumen) - 2)).
DO iint = 1 TO NUM-ENTRIES(pResumen,"/"):
    cValor = cValor + SUBSTRING(ENTRY(iint,pResumen,"/"),4) + ','.
END.
DI-RutaD.Libre_c01 = cValor.

/* Grabamos el orden de impresion */
ASSIGN
    DI-RutaD.Libre_d01 = 9999.
FIND Vtaubidiv WHERE VtaUbiDiv.CodCia = s-codcia
    AND VtaUbiDiv.CodDiv = s-coddiv
    AND VtaUbiDiv.CodDept = T-RUTAD.CodDpto
    AND VtaUbiDiv.CodProv = T-RUTAD.CodProv 
    AND VtaUbiDiv.CodDist = T-RUTAD.CodDist
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaUbiDiv THEN DI-RutaD.Libre_d01 = VtaUbiDiv.Libre_d01.
RELEASE Di-RutaD.
RETURN 'OK'.

END PROCEDURE.

/*
DEFINE VARIABLE pResumen AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iInt     AS INTEGER     NO-UNDO.
DEFINE VARIABLE cValor   AS CHARACTER   NO-UNDO.

CREATE DI-RutaD.
ASSIGN
    DI-RutaD.CodCia = DI-RutaC.CodCia
    DI-RutaD.CodDiv = DI-RutaC.CodDiv
    DI-RutaD.CodDoc = DI-RutaC.CodDoc
    DI-RutaD.NroDoc = DI-RutaC.NroDoc
    DI-RutaD.CodRef = T-RUTAD.CodRef
    DI-RutaD.NroRef = T-RUTAD.NroRef.
/* Pesos y Volumenes */
RUN Vta/resumen-pedido (DI-RutaD.CodDiv, DI-RutaD.CodRef, DI-RutaD.NroRef, OUTPUT pResumen).
pResumen = SUBSTRING(pResumen,2,(LENGTH(pResumen) - 2)).
DO iint = 1 TO NUM-ENTRIES(pResumen,"/"):
    cValor = cValor + SUBSTRING(ENTRY(iint,pResumen,"/"),4) + ','.
END.
DI-RutaD.Libre_c01 = cValor.

/* Grabamos el orden de impresion */
FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.coddoc = DI-RutaD.CodRef
    AND ccbcdocu.nrodoc = DI-RutaD.NroRef
    NO-LOCK NO-ERROR.
ASSIGN
    DI-RutaD.Libre_d01 = 9999.
FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = ccbcdocu.codcli
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie THEN DO:
    FIND Vtaubidiv WHERE VtaUbiDiv.CodCia = s-codcia
        AND VtaUbiDiv.CodDiv = s-coddiv
        AND VtaUbiDiv.CodDept = gn-clie.CodDept 
        AND VtaUbiDiv.CodProv = gn-clie.CodProv 
        AND VtaUbiDiv.CodDist = gn-clie.CodDist
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaUbiDiv THEN DI-RutaD.Libre_d01 = VtaUbiDiv.Libre_d01.
END.
RELEASE Di-RutaD.
RETURN 'OK'.
*/

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
      FOR EACH VtaCTabla NO-LOCK WHERE VtaCTabla.CodCia = s-codcia
          AND VtaCTabla.Tabla = s-tabla:
          COMBO-BOX-Zona:ADD-LAST(VtaCTabla.Descripcion, VtaCTabla.Llave).
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NoDocumentados W-Win 
PROCEDURE NoDocumentados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Cargamos Guias */
DEFINE VARIABLE pResumen    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iInt        AS INTEGER     NO-UNDO.
DEFINE VARIABLE cValor      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE x-Pesos     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE x-Volumen   AS DECIMAL     NO-UNDO.

/* Ordenes de Despacho */
FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
    AND LOOKUP(Faccpedi.coddoc , "O/D,O/M,OTR") > 0
    AND Faccpedi.divdes = s-coddiv
    AND (FILL-IN-Desde = ? OR Faccpedi.fchent >= FILL-IN-Desde)
    AND (FILL-IN-Hasta = ? OR Faccpedi.fchent <= FILL-IN-Hasta)
    AND Faccpedi.flgest = "P":
    CREATE T-CDOCU.
    ASSIGN
        T-CDOCU.CodCia = s-codcia
        T-CDOCU.CodDiv = s-coddiv
        T-CDOCU.CodDoc = Faccpedi.coddoc
        T-CDOCU.NroDoc = Faccpedi.nroped
        T-CDOCU.CodRef = (IF LOOKUP(Faccpedi.coddoc, "O/D,O/M") > 0 THEN "G/R"      
                            ELSE "GTR")
        T-CDOCU.CodCli = Faccpedi.CodCli
        T-CDOCU.NomCli = Faccpedi.NomCli
        T-CDOCU.CodPed = Faccpedi.codref    /* PED P/M R/A */
        T-CDOCU.NroPed = Faccpedi.nroref
        T-CDOCU.Libre_c01 = Faccpedi.codref    /* PED P/M R/A */
        T-CDOCU.Libre_c02 = Faccpedi.nroref
        T-CDOCU.DivOri = FacCPedi.CodDiv
        T-CDOCU.FlgSit = "ND"
        T-CDOCU.CodVen = Faccpedi.CodVen.
    /* Pesos y Volumenes */
    ASSIGN
        x-Pesos = 0
        x-Volumen = 0.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
        IF almmmatg.libre_d02 <> ? THEN x-Volumen = x-Volumen + (Facdpedi.canped * Facdpedi.Factor * (Almmmatg.libre_d02 / 1000000)).
        x-Pesos = x-Pesos + (Facdpedi.canped * Facdpedi.factor * almmmatg.pesmat).
    END.
    ASSIGN
        T-CDOCU.Libre_d01 = x-Pesos         /* Peso en Kg */
        T-CDOCU.Libre_d02 = x-Volumen       /* Volumen en m3 */
        T-CDOCU.ImpTot    = (IF Faccpedi.codmon = 2 THEN Faccpedi.TpoCmb * Faccpedi.ImpTot ELSE Faccpedi.ImpTot).
        IF T-CDOCU.Libre_d01 = ? THEN T-CDOCU.Libre_d01 = 0.
        IF T-CDOCU.Libre_d02 = ? THEN T-CDOCU.Libre_d02 = 0.
    /* Fecha de entrega 04/014/2017 Felix Perez */
    ASSIGN T-CDOCU.FchAte = Faccpedi.FchEnt.
    /* RHC 09/10/17 Importes para OTR igual al de la impresión de H/R */
    IF Faccpedi.CodDoc = "OTR" THEN DO:
        ASSIGN
            T-CDOCU.ImpTot = 0.
        FOR EACH Facdpedi OF Faccpedi NO-LOCK:
            FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia 
                AND AlmStkGe.codmat = Facdpedi.codmat 
                AND AlmStkGe.fecha <= TODAY NO-LOCK NO-ERROR.
            T-CDOCU.ImpTot = T-CDOCU.ImpTot + (IF AVAILABLE AlmStkGe THEN 
                AlmStkGe.CtoUni * Facdpedi.canped * Facdpedi.factor
                ELSE 0).
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pr-Automatico W-Win 
PROCEDURE Pr-Automatico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Barremos en orden hasta cubrir la cuota
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pPeso AS DEC.
DEF INPUT PARAMETER pVolumen AS DEC.

DEF VAR x-Peso    AS DEC INIT 0 NO-UNDO.
DEF VAR x-Volumen AS DEC INIT 0 NO-UNDO.

GET FIRST BROWSE-CDOCU.
REPEAT WHILE AVAILABLE T-CDOCU:
    IF T-CDOCU.FlgSit = "D" THEN DO:    /* SOLO DOCUMENTADOS */
        IF pPeso > 0 THEN DO:
            IF (x-Peso + T-CDOCU.Libre_d01) > (pPeso * 1.10) THEN LEAVE.
        END.
        IF pVolumen > 0 THEN DO:
            IF (x-Volumen + T-CDOCU.Libre_d02) > (pVolumen * 1.10) THEN LEAVE.
        END.
        FIND CURRENT T-CDOCU EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = NO THEN DO:
            CREATE T-RUTAD.
            /*{dist/i-pre-hoja-ruta-sube.i}*/
            BUFFER-COPY T-CDOCU TO T-RUTAD.
            ASSIGN 
                T-CDOCU.FlgEst = "A".
            ASSIGN
                x-Peso = x-Peso + T-RUTAD.Libre_d01
                x-Volumen = x-Volumen + T-RUTAD.Libre_d02.
        END.
    END.
    GET NEXT BROWSE-CDOCU.
END.
{&OPEN-QUERY-BROWSE-CDOCU}
{&OPEN-QUERY-BROWSE-RUTAD}
RUN Totales.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pr-Baja W-Win 
PROCEDURE Pr-Baja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF BROWSE-RUTAD:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} <= 0 THEN RETURN.
DEF VAR k AS INT NO-UNDO.
DO k = 1 TO BROWSE-RUTAD:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF BROWSE-RUTAD:FETCH-SELECTED-ROW(k) THEN DO:
        FIND CURRENT T-RUTAD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE T-RUTAD THEN NEXT.
        FIND T-CDOCU WHERE T-CDOCU.CodDoc = T-RutaD.CodDoc
            AND T-CDOCU.NroDoc = T-RutaD.NroDoc
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF AVAILABLE T-CDOCU THEN DO:
            ASSIGN T-CDOCU.FlgEst = "".
            DELETE T-RUTAD.
        END.
    END.
END.

DEFINE VAR hSortColumn   AS WIDGET-HANDLE.
DEFINE VAR hQueryHandle  AS HANDLE NO-UNDO.

hSortColumn = BROWSE BROWSE-CDOCU:CURRENT-COLUMN.
hQueryHandle = BROWSE BROWSE-CDOCU:QUERY.

IF hQueryHandle:PREPARE-STRING = ? THEN DO:
{&OPEN-QUERY-BROWSE-CDOCU}
END.
ELSE hQueryHandle:QUERY-OPEN().

{&OPEN-QUERY-BROWSE-RUTAD}
RUN Totales.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pr-Baja-2 W-Win 
PROCEDURE Pr-Baja-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF BROWSE-RUTAD:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} <= 0 THEN RETURN.

DEF VAR x-Llave AS CHAR NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DO k = 1 TO 1:
    IF BROWSE-RUTAD:FETCH-SELECTED-ROW(k) THEN DO:
        FIND CURRENT T-RUTAD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE T-RUTAD THEN RETURN.
        x-Llave = T-RUTAD.NomCli.
    END.
END.
GET FIRST BROWSE-RUTAD.
REPEAT WHILE AVAILABLE T-RUTAD:
    IF T-RUTAD.NomCli = x-Llave THEN DO:
        FIND CURRENT T-RUTAD EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE T-RUTAD THEN NEXT.
        FIND T-CDOCU WHERE T-CDOCU.CodDoc = T-RutaD.CodDoc
            AND T-CDOCU.NroDoc = T-RutaD.NroDoc
            EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF AVAILABLE T-CDOCU THEN 
            ASSIGN 
            T-CDOCU.FlgEst = ""
            T-RUTAD.FlgEst = "A".
    END.
    GET NEXT BROWSE-RUTAD.
END.
FOR EACH T-RUTAD WHERE T-RUTAD.FlgEst = "A":
    DELETE T-RUTAD.
END.

DEFINE VAR hSortColumn   AS WIDGET-HANDLE.
DEFINE VAR hQueryHandle  AS HANDLE NO-UNDO.

hSortColumn = BROWSE BROWSE-CDOCU:CURRENT-COLUMN.
hQueryHandle = BROWSE BROWSE-CDOCU:QUERY.

IF hQueryHandle:PREPARE-STRING = ? THEN DO:
{&OPEN-QUERY-BROWSE-CDOCU}
END.
ELSE hQueryHandle:QUERY-OPEN().

{&OPEN-QUERY-BROWSE-RUTAD}
RUN Totales.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pr-Sube W-Win 
PROCEDURE Pr-Sube :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF BROWSE-CDOCU:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} <= 0 THEN RETURN.

DEF VAR k AS INT NO-UNDO.
DO k = 1 TO BROWSE-CDOCU:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME}:
    IF BROWSE-CDOCU:FETCH-SELECTED-ROW(k) THEN DO:
        IF T-CDOCU.FlgSit <> "D" THEN NEXT.
        FIND CURRENT T-CDOCU EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE T-CDOCU THEN NEXT.
        CREATE T-RUTAD.
        /*{dist/i-pre-hoja-ruta-sube.i}*/
        BUFFER-COPY T-CDOCU TO T-RUTAD.
        ASSIGN 
            T-CDOCU.FlgEst = "A".
    END.
END.

DEFINE VAR hSortColumn   AS WIDGET-HANDLE.
DEFINE VAR hQueryHandle  AS HANDLE NO-UNDO.

hSortColumn = BROWSE BROWSE-CDOCU:CURRENT-COLUMN.
hQueryHandle = BROWSE BROWSE-CDOCU:QUERY.

IF hQueryHandle:PREPARE-STRING = ? THEN DO:
{&OPEN-QUERY-BROWSE-CDOCU}
END.
ELSE hQueryHandle:QUERY-OPEN().

{&OPEN-QUERY-BROWSE-RUTAD}
RUN Totales.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pr-Sube-2 W-Win 
PROCEDURE Pr-Sube-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Pescamos el primero como referencia
------------------------------------------------------------------------------*/

IF BROWSE-CDOCU:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} <= 0 THEN RETURN.

DEF VAR x-Llave AS CHAR NO-UNDO.
DEF VAR k AS INT NO-UNDO.
DO k = 1 TO 1:
    IF BROWSE-CDOCU:FETCH-SELECTED-ROW(k) THEN DO:
        FIND CURRENT T-CDOCU EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE T-CDOCU THEN RETURN.
        x-Llave = T-CDOCU.NomCli.
    END.
END.
GET FIRST BROWSE-CDOCU.
REPEAT WHILE AVAILABLE T-CDOCU:
    IF T-CDOCU.FlgSit = "D" AND T-CDOCU.NomCli = x-Llave THEN DO:
        FIND CURRENT T-CDOCU EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE T-CDOCU THEN NEXT.
        CREATE T-RUTAD.
        /*{dist/i-pre-hoja-ruta-sube.i}*/
        BUFFER-COPY T-CDOCU TO T-RUTAD.
        ASSIGN 
            T-CDOCU.FlgEst = "A".
    END.
    GET NEXT BROWSE-CDOCU.
END.

DEFINE VAR hSortColumn   AS WIDGET-HANDLE.
DEFINE VAR hQueryHandle  AS HANDLE NO-UNDO.

hSortColumn = BROWSE BROWSE-CDOCU:CURRENT-COLUMN.
hQueryHandle = BROWSE BROWSE-CDOCU:QUERY.

IF hQueryHandle:PREPARE-STRING = ? THEN DO:
{&OPEN-QUERY-BROWSE-CDOCU}
END.
ELSE hQueryHandle:QUERY-OPEN().

{&OPEN-QUERY-BROWSE-RUTAD}
RUN Totales.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pParametro AS CHAR.

CASE pParametro:
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "T-RutaD"}
  {src/adm/template/snd-list.i "VtaCTabla"}
  {src/adm/template/snd-list.i "T-CDOCU"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Totales W-Win 
PROCEDURE Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF BUFFER D-RUTAD FOR T-RUTAD.

    ASSIGN
        FILL-IN-Peso = 0
        FILL-IN-Volumen = 0
        FILL-IN-Importe = 0
        FILL-IN-Destinos = 0
        FILL-IN-Documentos = 0.
    FOR EACH D-RUTAD NO-LOCK WHERE D-RUTAD.Libre_d01 <> ? AND D-RUTAD.Libre_d02 <> ?:
        ASSIGN
            FILL-IN-Peso = FILL-IN-Peso + D-RUTAD.Libre_d01
            FILL-IN-Volumen = FILL-IN-Volumen + D-RUTAD.Libre_d02
            FILL-IN-Importe = FILL-IN-Importe + D-RUTAD.ImpTot.
    END.
    FOR EACH D-RUTAD NO-LOCK BREAK BY D-RUTAD.NomCli:
        IF FIRST-OF(D-RUTAD.NomCli) THEN FILL-IN-Destinos = FILL-IN-Destinos + 1.
    END.
    FOR EACH D-RUTAD NO-LOCK BREAK BY D-RUTAD.CodDoc BY D-RUTAD.NroDoc:
        IF FIRST-OF(D-RUTAD.CodDoc) OR FIRST-OF(D-RUTAD.NroDoc) THEN FILL-IN-Documentos = FILL-IN-Documentos + 1.
    END.
    DISPLAY FILL-IN-Peso FILL-IN-Volumen FILL-IN-Importe FILL-IN-Destinos FILL-IN-Documentos WITH FRAME {&FRAME-NAME}.
    
    DEF BUFFER D-CDOCU FOR T-CDOCU.
    ASSIGN
        FILL-IN-Peso-2 = 0
        FILL-IN-Volumen-2 = 0
        FILL-IN-Importe-2 = 0.
    GET FIRST BROWSE-CDOCU.
    REPEAT WHILE AVAILABLE T-CDOCU:
        ASSIGN
            FILL-IN-Peso-2 = FILL-IN-Peso-2 + T-CDOCU.Libre_d01
            FILL-IN-Volumen-2 = FILL-IN-Volumen-2 + T-CDOCU.Libre_d02
            FILL-IN-Importe-2 = FILL-IN-Importe-2 + T-CDOCU.ImpTot.
        GET NEXT BROWSE-CDOCU.
    END.
    DISPLAY FILL-IN-Peso-2 FILL-IN-Volumen-2 FILL-IN-Importe-2 WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/*
    DEF BUFFER D-RUTAD FOR T-RUTAD.

    ASSIGN
        FILL-IN-Peso = 0
        FILL-IN-Volumen = 0
        FILL-IN-Importe = 0
        FILL-IN-Destinos = 0
        FILL-IN-Documentos = 0.
    FOR EACH D-RUTAD NO-LOCK WHERE D-RUTAD.Libre_d01 <> ? AND D-RUTAD.Libre_d02 <> ?:
        ASSIGN
            FILL-IN-Peso = FILL-IN-Peso + D-RUTAD.Libre_d01
            FILL-IN-Volumen = FILL-IN-Volumen + D-RUTAD.Libre_d02
            FILL-IN-Importe = FILL-IN-Importe + D-RUTAD.ImpCob.
    END.
    FOR EACH D-RUTAD NO-LOCK BREAK BY D-RUTAD.Libre_c05:
        IF FIRST-OF(D-RUTAD.Libre_c05) THEN FILL-IN-Destinos = FILL-IN-Destinos + 1.
    END.
    FOR EACH D-RUTAD NO-LOCK BREAK BY D-RUTAD.CodRef BY D-RUTAD.NroRef:
        IF FIRST-OF(D-RUTAD.CodRef) OR FIRST-OF(D-RUTAD.NroRef) THEN FILL-IN-Documentos = FILL-IN-Documentos + 1.
    END.
    DISPLAY FILL-IN-Peso FILL-IN-Volumen FILL-IN-Importe FILL-IN-Destinos FILL-IN-Documentos WITH FRAME {&FRAME-NAME}.
    
    DEF BUFFER D-CDOCU FOR T-CDOCU.
    ASSIGN
        FILL-IN-Peso-2 = 0
        FILL-IN-Volumen-2 = 0
        FILL-IN-Importe-2 = 0.
    GET FIRST BROWSE-CDOCU.
    REPEAT WHILE AVAILABLE T-CDOCU:
        ASSIGN
            FILL-IN-Peso-2 = FILL-IN-Peso-2 + T-CDOCU.Libre_d01
            FILL-IN-Volumen-2 = FILL-IN-Volumen-2 + T-CDOCU.Libre_d02
            FILL-IN-Importe-2 = FILL-IN-Importe-2 + T-CDOCU.ImpTot.
        GET NEXT BROWSE-CDOCU.
    END.
    DISPLAY FILL-IN-Peso-2 FILL-IN-Volumen-2 FILL-IN-Importe-2 WITH FRAME {&FRAME-NAME}.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

