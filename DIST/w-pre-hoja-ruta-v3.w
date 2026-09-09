&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-ALMACEN FOR Almacen.
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE TEMP-TABLE CPEDI NO-UNDO LIKE FacCPedi
       FIELD Peso   AS DEC FORMAT '>>>,>>9.99'
       FIELD Bultos AS INT FORMAT '>,>>9'
       FIELD Volumen AS DEC FORMAT '>>>,>>9.99'
       FIELD Zona AS CHAR
       FIELD SubZona AS CHAR
       FIELD CodDpto AS CHAR
       FIELD CodProv AS CHAR
       FIELD CodDist AS CHAR
       FIELD Reprogramado AS LOG INITIAL NO
       .
DEFINE BUFFER ORDENES FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.
DEFINE TEMP-TABLE T-CREPO NO-UNDO LIKE almcrepo.
DEFINE TEMP-TABLE T-RUTAD NO-UNDO LIKE FacCPedi
       FIELD Peso   AS DEC FORMAT '>>>,>>9.99'
       FIELD Bultos AS INT FORMAT '>,>>9'
       FIELD Volumen AS DEC FORMAT '>>>,>>9.99'
       FIELD Zona AS CHAR
       FIELD SubZona AS CHAR
       FIELD CodDpto AS CHAR
       FIELD CodProv AS CHAR
       FIELD CodDist AS CHAR
       FIELD Reprogramado AS LOG INITIAL NO.
DEFINE TEMP-TABLE T-VtaDTabla LIKE VtaDTabla.



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

DEF NEW SHARED VAR s-tabla  AS CHAR INIT 'SZGHR'.
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

&SCOPED-DEFINE Condicion ( ~
(COMBO-BOX-Canal = 'Todos' OR CPEDI.coddiv = COMBO-BOX-Canal) AND ~
(COMBO-BOX-Zona = 'Todos' OR CPEDI.Zona = COMBO-BOX-Zona ) AND ~
(COMBO-BOX-SubZona = 'Todos' OR CPEDI.SubZona = COMBO-BOX-SubZona) AND ~
(COMBO-BOX-Distrito = 'Todos' OR CPEDI.CodDist = COMBO-BOX-Distrito) ~
)

/* Variable que faltan en el temporal CPEDI */
DEF VAR x-Bultos AS INT NO-UNDO.
DEF VAR x-Peso   AS DEC NO-UNDO.    /* en kg */
DEF VAR x-Volumen AS DEC NO-UNDO.   /* em m3 */
DEF VAR x-Zona   AS CHAR NO-UNDO.   /* la zona actual */
DEF VAR x-Reprogramado AS LOGICAL FORMAT "SI/NO" NO-UNDO.

DEF VAR SORTBY-Canal       AS CHAR INIT "BY CPEDI.Sede" NO-UNDO.
DEF VAR SORTORDER-Canal    AS INT  INIT 0  NO-UNDO.
DEF VAR SORTBY-Zona        AS CHAR INIT "BY VtaCTabla.Descripcion" NO-UNDO.
DEF VAR SORTORDER-Zona     AS INT  INIT 0  NO-UNDO.
DEF VAR SORTBY-SubZona     AS CHAR INIT "BY VtaDTabla.Libre_c02" NO-UNDO.
DEF VAR SORTORDER-SubZona  AS INT  INIT 0  NO-UNDO.
DEF VAR SORTBY-Distrito    AS CHAR INIT "BY CPEDI.LugEnt" NO-UNDO.
DEF VAR SORTORDER-Distrito AS INT  INIT 0  NO-UNDO.
DEF VAR SORTBY-Cliente     AS CHAR INIT "BY CPEDI.NomCli" NO-UNDO.
DEF VAR SORTORDER-Cliente  AS INT  INIT 0  NO-UNDO.

DEF VAR FLAG-Canal    AS LOG INIT NO NO-UNDO.
DEF VAR FLAG-Zona     AS LOG INIT NO NO-UNDO.
DEF VAR FLAG-SubZona  AS LOG INIT NO NO-UNDO.
DEF VAR FLAG-Distrito AS LOG INIT NO NO-UNDO.
DEF VAR FLAG-Cliente  AS LOG INIT NO NO-UNDO.

DEF VAR SORTBY-General AS CHAR INIT "" NO-UNDO.

&SCOPED-DEFINE SORTBY-1

/* Tabla intermedia para el Excel */
DEF TEMP-TABLE Detalle
    FIELD Sede          LIKE Ccbcdocu.Sede      COLUMN-LABEL 'Canal'        FORMAT 'x(30)'
    FIELD Descripcion   AS CHAR                 COLUMN-LABEL 'Zona'         FORMAT 'x(20)'
    FIELD Libre_c02     AS CHAR                 COLUMN-LABEL 'SubZona'      FORMAT 'x(20)'
    FIELD LugEnt        LIKE CPEDI.LugEnt       COLUMN-LABEL 'Distrito'     FORMAT 'x(20)'
    FIELD NomCli        LIKE CPEDI.NomCli       COLUMN-LABEL 'Cliente'      FORMAT 'x(30)'
    FIELD FchEnt        LIKE CPEDI.FchEnt       COLUMN-LABEL 'Fecha Entrega'   FORMAT '99/99/9999'
    FIELD CodDoc        LIKE CPEDI.CodDoc       COLUMN-LABEL 'Refer.'       FORMAT 'x(3)'
    FIELD NroPed        LIKE CPEDI.NroPed       COLUMN-LABEL 'Numero'       FORMAT 'x(12)'
    FIELD Libre_d01     LIKE CPEDI.Libre_d01    COLUMN-LABEL '# Docs.'      FORMAT '>>9'
    FIELD Bultos        LIKE CPEDI.Bultos       COLUMN-LABEL 'Bultos'       FORMAT '>,>>9'
    FIELD ImpTot        LIKE CPEDI.ImpTot       COLUMN-LABEL 'Importe Total'   FORMAT '->>,>>>,>>9.99'
    FIELD Peso          LIKE CPEDI.Peso         COLUMN-LABEL 'Peso en kg'   FORMAT '>>>,>>9.99'
    FIELD Volumen       LIKE CPEDI.Volumen      COLUMN-LABEL 'Volumen en m3'   FORMAT '>>>,>>9.99'
    FIELD Contacto      AS CHAR                 COLUMN-LABEL 'Contacto'     FORMAT 'x(60)'
    FIELD Telefono      AS CHAR                 COLUMN-LABEL 'Telefono'     FORMAT 'x(20)'
    FIELD CodVen        AS CHAR                 COLUMN-LABEL 'Vendedor'     FORMAT 'x(5)'
    FIELD NomVen        AS CHAR                 COLUMN-LABEL 'Nombre'       FORMAT 'x(50)'
    FIELD Libre_c01     LIKE CPEDI.Libre_c01    COLUMN-LABEL 'Estado'       FORMAT 'x(20)'
    FIELD tObserva      AS CHAR                 COLUMN-LABEL "Observaciones" FORMAT 'x(100)'
    /*FIELD testado       AS CHAR                 COLUMN-LABEL "Estado"       FORMAT 'x(30)'*/
    FIELD tSituacion    AS CHAR                 COLUMN-LABEL "Situacion"    FORMAT 'x(50)'
    FIELD tnrohruta     AS CHAR                 COLUMN-LABEL "Nro HRuta"    FORMAT 'x(15)'
    FIELD tfchsal       AS DATE                 COLUMN-LABEL "Fecha Salida"
    FIELD tmotdevol     AS CHAR                 COLUMN-LABEL "Motivo Devol" FORMAT 'x(50)'
    FIELD tqty          AS DEC                  COLUMN-LABEL "Cantidad"     FORMAT '->>,>>>,>>9.99'
    FIELD timpte        AS DEC                  COLUMN-LABEL "importe"      FORMAT '->>,>>>,>>9.99'
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
&Scoped-define BROWSE-NAME BROWSE-DESTINO

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES T-RUTAD VtaCTabla VtaDTabla CPEDI

/* Definitions for BROWSE BROWSE-DESTINO                                */
&Scoped-define FIELDS-IN-QUERY-BROWSE-DESTINO ~
T-RUTAD.Reprogramado @ x-Reprogramado T-RUTAD.CrossDocking T-RUTAD.Sede ~
VtaCTabla.Descripcion VtaDTabla.Libre_c02 T-RUTAD.LugEnt T-RUTAD.NomCli ~
T-RUTAD.FchEnt T-RUTAD.CodDoc T-RUTAD.NroPed T-RUTAD.Libre_d01 ~
T-RUTAD.Bultos @ x-Bultos T-RUTAD.ImpTot T-RUTAD.Peso @ x-Peso ~
T-RUTAD.Volumen @ x-Volumen T-RUTAD.Libre_c01 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-DESTINO 
&Scoped-define QUERY-STRING-BROWSE-DESTINO FOR EACH T-RUTAD NO-LOCK, ~
      FIRST VtaCTabla WHERE VtaCTabla.CodCia = T-RUTAD.CodCia ~
  AND VtaCTabla.Llave = T-RUTAD.Zona ~
      AND VtaCTabla.Tabla = "ZGHR" NO-LOCK, ~
      FIRST VtaDTabla WHERE VtaDTabla.CodCia = T-RUTAD.CodCia ~
  AND VtaDTabla.Llave = T-RUTAD.Zona ~
  AND VtaDTabla.Tipo = T-RUTAD.SubZona ~
      AND VtaDTabla.Tabla = "SZGHR" ~
 AND VtaDTabla.LlaveDetalle = "C" NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-DESTINO OPEN QUERY BROWSE-DESTINO FOR EACH T-RUTAD NO-LOCK, ~
      FIRST VtaCTabla WHERE VtaCTabla.CodCia = T-RUTAD.CodCia ~
  AND VtaCTabla.Llave = T-RUTAD.Zona ~
      AND VtaCTabla.Tabla = "ZGHR" NO-LOCK, ~
      FIRST VtaDTabla WHERE VtaDTabla.CodCia = T-RUTAD.CodCia ~
  AND VtaDTabla.Llave = T-RUTAD.Zona ~
  AND VtaDTabla.Tipo = T-RUTAD.SubZona ~
      AND VtaDTabla.Tabla = "SZGHR" ~
 AND VtaDTabla.LlaveDetalle = "C" NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-DESTINO T-RUTAD VtaCTabla VtaDTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-DESTINO T-RUTAD
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-DESTINO VtaCTabla
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-DESTINO VtaDTabla


/* Definitions for BROWSE BROWSE-ORIGEN                                 */
&Scoped-define FIELDS-IN-QUERY-BROWSE-ORIGEN ~
CPEDI.Reprogramado @ x-Reprogramado CPEDI.CrossDocking CPEDI.Sede ~
VtaCTabla.Descripcion VtaDTabla.Libre_c02 CPEDI.LugEnt CPEDI.NomCli ~
CPEDI.FchEnt CPEDI.CodDoc CPEDI.NroPed CPEDI.Libre_d01 ~
CPEDI.Bultos @ x-Bultos CPEDI.ImpTot CPEDI.Peso @ x-Peso ~
CPEDI.Volumen @ x-Volumen CPEDI.Libre_c01 CPEDI.Observa 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-ORIGEN 
&Scoped-define QUERY-STRING-BROWSE-ORIGEN FOR EACH CPEDI ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST VtaCTabla WHERE VtaCTabla.CodCia = CPEDI.CodCia ~
  AND VtaCTabla.Llave = CPEDI.Zona ~
      AND VtaCTabla.Tabla = "ZGHR" NO-LOCK, ~
      EACH VtaDTabla WHERE VtaDTabla.CodCia = CPEDI.CodCia ~
  AND VtaDTabla.Llave = CPEDI.Zona  ~
  AND VtaDTabla.Tipo = CPEDI.SubZona ~
      AND VtaDTabla.Tabla = "SZGHR" ~
 AND VtaDTabla.LlaveDetalle = "C" NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-ORIGEN OPEN QUERY BROWSE-ORIGEN FOR EACH CPEDI ~
      WHERE {&Condicion} NO-LOCK, ~
      FIRST VtaCTabla WHERE VtaCTabla.CodCia = CPEDI.CodCia ~
  AND VtaCTabla.Llave = CPEDI.Zona ~
      AND VtaCTabla.Tabla = "ZGHR" NO-LOCK, ~
      EACH VtaDTabla WHERE VtaDTabla.CodCia = CPEDI.CodCia ~
  AND VtaDTabla.Llave = CPEDI.Zona  ~
  AND VtaDTabla.Tipo = CPEDI.SubZona ~
      AND VtaDTabla.Tabla = "SZGHR" ~
 AND VtaDTabla.LlaveDetalle = "C" NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-ORIGEN CPEDI VtaCTabla VtaDTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-ORIGEN CPEDI
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-ORIGEN VtaCTabla
&Scoped-define THIRD-TABLE-IN-QUERY-BROWSE-ORIGEN VtaDTabla


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-DESTINO}~
    ~{&OPEN-QUERY-BROWSE-ORIGEN}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-5 RECT-6 RECT-7 IMAGE-1 RECT-8 IMAGE-2 ~
RECT-10 RECT-9 BUTTON-Refrescar BUTTON-3 BtnDone RADIO-SET_Tipo ~
FILL-IN_NroPed FILL-IN_PesoLimite BUTTON_Limpiar FILL-IN_VolumenLimite ~
FILL-IN-Desde BUTTON-1 FILL-IN-Hasta BUTTON-2 FILL-IN_Cliente ~
FILL-IN_ClientesLimite BUTTON-Limpiar-Orden COMBO-BOX-Canal COMBO-BOX-Zona ~
COMBO-BOX-SubZona COMBO-BOX-Distrito BROWSE-ORIGEN BUTTON_Down_Todo ~
BUTTON_Down_Cliente BUTTON_Down_Selectivo BUTTON_Up_Todo BUTTON_Up_Cliente ~
BUTTON_Up_Selectivo BROWSE-DESTINO BUTTON-Generar 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET_Tipo FILL-IN_NroPed ~
FILL-IN_PesoLimite FILL-IN_VolumenLimite FILL-IN-Desde FILL-IN-Hasta ~
FILL-IN_Cliente FILL-IN_ClientesLimite COMBO-BOX-Canal COMBO-BOX-Zona ~
COMBO-BOX-SubZona COMBO-BOX-Distrito FILL-IN-SKU FILL-IN-Destinos ~
FILL-IN-Volumen FILL-IN-Peso FILL-IN-Documentados FILL-IN-Bultos ~
FILL-IN-Importe FILL-IN-SKU-2 FILL-IN-Destinos-2 FILL-IN-Volumen-2 ~
FILL-IN-Peso-2 FILL-IN-Documentados-2 FILL-IN-Bultos-2 FILL-IN-Importe-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 6 BY 1.62
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
     SIZE 6 BY 1.62.

DEFINE BUTTON BUTTON-Generar 
     LABEL "GENERAR" 
     SIZE 15 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON-Limpiar-Orden 
     LABEL "Limpiar Orden" 
     SIZE 11 BY 1.12.

DEFINE BUTTON BUTTON-Refrescar 
     LABEL "Aplicar Filtros" 
     SIZE 14 BY 1.08.

DEFINE BUTTON BUTTON_Down_Cliente 
     LABEL "CLIENTE" 
     SIZE 8 BY 1.12.

DEFINE BUTTON BUTTON_Down_Selectivo 
     LABEL "SELECTIVO" 
     SIZE 10 BY 1.12.

DEFINE BUTTON BUTTON_Down_Todo 
     LABEL "TODO" 
     SIZE 8 BY 1.12.

DEFINE BUTTON BUTTON_Limpiar 
     LABEL "Limpiar Filtros" 
     SIZE 14 BY 1.12.

DEFINE BUTTON BUTTON_Up_Cliente 
     LABEL "CLIENTE" 
     SIZE 8 BY 1.12.

DEFINE BUTTON BUTTON_Up_Selectivo 
     LABEL "SELECTIVO" 
     SIZE 10 BY 1.12.

DEFINE BUTTON BUTTON_Up_Todo 
     LABEL "TODO" 
     SIZE 8 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Canal AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Canal" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Distrito AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Distrito" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-SubZona AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Sub-Zona" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-Zona AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Zona" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Todos","Todos"
     DROP-DOWN-LIST
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Bultos AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Bultos" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Bultos-2 AS DECIMAL FORMAT "-ZZ,ZZZ,ZZ9.99":U INITIAL 0 
     LABEL "Bultos" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Desde AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Destinos AS INTEGER FORMAT "ZZ,ZZ9":U INITIAL 0 
     LABEL "Destinos" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Destinos-2 AS INTEGER FORMAT "ZZ,ZZ9":U INITIAL 0 
     LABEL "Destinos" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Documentados AS CHARACTER FORMAT "X(256)":U 
     LABEL "Documentados" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Documentados-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Documentados" 
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

DEFINE VARIABLE FILL-IN-SKU AS INTEGER FORMAT "ZZZ,ZZ9":U INITIAL 0 
     LABEL "SKU" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-SKU-2 AS INTEGER FORMAT "ZZZ,ZZ9":U INITIAL 0 
     LABEL "SKU" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81
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

DEFINE VARIABLE FILL-IN_Cliente AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_ClientesLimite AS INTEGER FORMAT ">>9":U INITIAL 10 
     LABEL "Clientes" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81
     BGCOLOR 10 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_NroPed AS CHARACTER FORMAT "X(12)":U 
     LABEL "Número" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_PesoLimite AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Peso en kg" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 10 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_VolumenLimite AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Volumen en m3" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 10 FGCOLOR 0  NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "img/down.ico":U
     SIZE 4 BY 1.08.

DEFINE IMAGE IMAGE-2
     FILENAME "img/up.ico":U
     SIZE 5 BY 1.35.

DEFINE VARIABLE RADIO-SET_Tipo AS CHARACTER INITIAL "Todos" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "O/D y OTR", "Todos",
"Solo Cliente Recoge", "Recoge"
     SIZE 32 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 140 BY 1.35
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 96 BY 3.23.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 140 BY 3.23.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 44 BY 3.23
     BGCOLOR 10 .

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33 BY 1.62
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33 BY 1.62.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-DESTINO FOR 
      T-RUTAD, 
      VtaCTabla, 
      VtaDTabla SCROLLING.

DEFINE QUERY BROWSE-ORIGEN FOR 
      CPEDI, 
      VtaCTabla, 
      VtaDTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-DESTINO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-DESTINO W-Win _STRUCTURED
  QUERY BROWSE-DESTINO NO-LOCK DISPLAY
      T-RUTAD.Reprogramado @ x-Reprogramado COLUMN-LABEL "Rep."
            WIDTH 4.43
      T-RUTAD.CrossDocking FORMAT "SI/NO":U
      T-RUTAD.Sede COLUMN-LABEL "Canal" FORMAT "x(25)":U
      VtaCTabla.Descripcion COLUMN-LABEL "Zona" FORMAT "x(20)":U
      VtaDTabla.Libre_c02 COLUMN-LABEL "SubZona" FORMAT "x(20)":U
      T-RUTAD.LugEnt COLUMN-LABEL "Distrito" FORMAT "x(25)":U
      T-RUTAD.NomCli COLUMN-LABEL "Cliente" FORMAT "x(30)":U
      T-RUTAD.FchEnt FORMAT "99/99/9999":U
      T-RUTAD.CodDoc COLUMN-LABEL "Refer." FORMAT "x(3)":U
      T-RUTAD.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U
      T-RUTAD.Libre_d01 COLUMN-LABEL "# Docs." FORMAT ">>9":U
      T-RUTAD.Bultos @ x-Bultos COLUMN-LABEL "Bultos" FORMAT ">,>>9":U
      T-RUTAD.ImpTot FORMAT "->>,>>>,>>9.99":U
      T-RUTAD.Peso @ x-Peso COLUMN-LABEL "Peso en kg" FORMAT ">>>,>>9.99":U
      T-RUTAD.Volumen @ x-Volumen COLUMN-LABEL "Volumen en m3" FORMAT ">>>,>>9.99":U
      T-RUTAD.Libre_c01 COLUMN-LABEL "Estado" FORMAT "x(20)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 140 BY 8.35
         FONT 4 ROW-HEIGHT-CHARS .46 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-ORIGEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-ORIGEN W-Win _STRUCTURED
  QUERY BROWSE-ORIGEN NO-LOCK DISPLAY
      CPEDI.Reprogramado @ x-Reprogramado COLUMN-LABEL "Rep." WIDTH 4.43
      CPEDI.CrossDocking FORMAT "SI/NO":U
      CPEDI.Sede COLUMN-LABEL "Canal" FORMAT "x(25)":U
      VtaCTabla.Descripcion COLUMN-LABEL "Zona" FORMAT "x(20)":U
      VtaDTabla.Libre_c02 COLUMN-LABEL "SubZona" FORMAT "x(20)":U
      CPEDI.LugEnt COLUMN-LABEL "Distrito" FORMAT "x(25)":U
      CPEDI.NomCli COLUMN-LABEL "Cliente" FORMAT "x(30)":U
      CPEDI.FchEnt FORMAT "99/99/9999":U
      CPEDI.CodDoc COLUMN-LABEL "Refer." FORMAT "x(3)":U
      CPEDI.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U
      CPEDI.Libre_d01 COLUMN-LABEL "# Docs." FORMAT ">>9":U
      CPEDI.Bultos @ x-Bultos COLUMN-LABEL "Bultos" FORMAT ">,>>9":U
      CPEDI.ImpTot FORMAT "->>,>>>,>>9.99":U
      CPEDI.Peso @ x-Peso COLUMN-LABEL "Peso en kg" FORMAT ">>>,>>9.99":U
      CPEDI.Volumen @ x-Volumen COLUMN-LABEL "Volumen en m3" FORMAT ">>>,>>9.99":U
      CPEDI.Libre_c01 COLUMN-LABEL "Estado" FORMAT "x(20)":U
      CPEDI.Observa FORMAT "X(50)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 140 BY 8.35
         FONT 4 ROW-HEIGHT-CHARS .42 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Refrescar AT ROW 1.54 COL 80 WIDGET-ID 2
     BUTTON-3 AT ROW 1.54 COL 127 WIDGET-ID 134
     BtnDone AT ROW 1.54 COL 133 WIDGET-ID 28
     RADIO-SET_Tipo AT ROW 1.81 COL 18 NO-LABEL WIDGET-ID 66
     FILL-IN_NroPed AT ROW 1.81 COL 59 COLON-ALIGNED WIDGET-ID 86
     FILL-IN_PesoLimite AT ROW 1.81 COL 108 COLON-ALIGNED WIDGET-ID 72
     BUTTON_Limpiar AT ROW 2.62 COL 80 WIDGET-ID 70
     FILL-IN_VolumenLimite AT ROW 2.62 COL 108 COLON-ALIGNED WIDGET-ID 74
     FILL-IN-Desde AT ROW 2.88 COL 16 COLON-ALIGNED WIDGET-ID 46
     BUTTON-1 AT ROW 2.88 COL 27 WIDGET-ID 50
     FILL-IN-Hasta AT ROW 2.88 COL 36 COLON-ALIGNED WIDGET-ID 48
     BUTTON-2 AT ROW 2.88 COL 47 WIDGET-ID 54
     FILL-IN_Cliente AT ROW 2.88 COL 59 COLON-ALIGNED WIDGET-ID 88
     FILL-IN_ClientesLimite AT ROW 3.42 COL 108 COLON-ALIGNED WIDGET-ID 78
     BUTTON-Limpiar-Orden AT ROW 4.69 COL 130 WIDGET-ID 132
     COMBO-BOX-Canal AT ROW 4.85 COL 6 COLON-ALIGNED WIDGET-ID 90
     COMBO-BOX-Zona AT ROW 4.85 COL 43 COLON-ALIGNED WIDGET-ID 10
     COMBO-BOX-SubZona AT ROW 4.85 COL 75 COLON-ALIGNED WIDGET-ID 124
     COMBO-BOX-Distrito AT ROW 4.85 COL 105 COLON-ALIGNED WIDGET-ID 84
     BROWSE-ORIGEN AT ROW 5.85 COL 2 WIDGET-ID 200
     FILL-IN-SKU AT ROW 14.19 COL 71 COLON-ALIGNED WIDGET-ID 114
     FILL-IN-Destinos AT ROW 14.19 COL 86 COLON-ALIGNED WIDGET-ID 38
     FILL-IN-Volumen AT ROW 14.19 COL 106 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-Peso AT ROW 14.19 COL 127 COLON-ALIGNED WIDGET-ID 12
     BUTTON_Down_Todo AT ROW 14.73 COL 8 WIDGET-ID 92
     BUTTON_Down_Cliente AT ROW 14.73 COL 16 WIDGET-ID 96
     BUTTON_Down_Selectivo AT ROW 14.73 COL 24 WIDGET-ID 98
     BUTTON_Up_Todo AT ROW 14.73 COL 41 WIDGET-ID 108
     BUTTON_Up_Cliente AT ROW 14.73 COL 49 WIDGET-ID 104
     BUTTON_Up_Selectivo AT ROW 14.73 COL 57 WIDGET-ID 106
     FILL-IN-Documentados AT ROW 15 COL 86 COLON-ALIGNED WIDGET-ID 40
     FILL-IN-Bultos AT ROW 15 COL 106 COLON-ALIGNED WIDGET-ID 112
     FILL-IN-Importe AT ROW 15 COL 127 COLON-ALIGNED WIDGET-ID 16
     BROWSE-DESTINO AT ROW 16.08 COL 2 WIDGET-ID 300
     FILL-IN-SKU-2 AT ROW 24.42 COL 71 COLON-ALIGNED WIDGET-ID 122
     FILL-IN-Destinos-2 AT ROW 24.42 COL 86 COLON-ALIGNED WIDGET-ID 118
     FILL-IN-Volumen-2 AT ROW 24.42 COL 106 COLON-ALIGNED WIDGET-ID 34
     FILL-IN-Peso-2 AT ROW 24.42 COL 127 COLON-ALIGNED WIDGET-ID 32
     BUTTON-Generar AT ROW 24.69 COL 2 WIDGET-ID 8
     FILL-IN-Documentados-2 AT ROW 25.23 COL 86 COLON-ALIGNED WIDGET-ID 120
     FILL-IN-Bultos-2 AT ROW 25.23 COL 106 COLON-ALIGNED WIDGET-ID 116
     FILL-IN-Importe-2 AT ROW 25.23 COL 127 COLON-ALIGNED WIDGET-ID 30
     "Filtros de listado" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 4.23 COL 3 WIDGET-ID 128
          BGCOLOR 9 FGCOLOR 15 
     "Tope máximo para generar la pre-hoja de ruta" VIEW-AS TEXT
          SIZE 32 BY .5 AT ROW 1 COL 99 WIDGET-ID 82
          BGCOLOR 9 FGCOLOR 15 
     "Filtros de carga" VIEW-AS TEXT
          SIZE 12 BY .5 AT ROW 1 COL 3 WIDGET-ID 56
          BGCOLOR 9 FGCOLOR 15 
     RECT-5 AT ROW 1.27 COL 2 WIDGET-ID 58
     RECT-6 AT ROW 1.27 COL 2 WIDGET-ID 60
     RECT-7 AT ROW 1.27 COL 98 WIDGET-ID 80
     IMAGE-1 AT ROW 14.73 COL 3 WIDGET-ID 94
     RECT-8 AT ROW 14.46 COL 2 WIDGET-ID 100
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 143 BY 25.27
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     IMAGE-2 AT ROW 14.73 COL 36 WIDGET-ID 102
     RECT-10 AT ROW 4.5 COL 2 WIDGET-ID 126
     RECT-9 AT ROW 14.46 COL 35 WIDGET-ID 110
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
      TABLE: CPEDI T "?" NO-UNDO INTEGRAL FacCPedi
      ADDITIONAL-FIELDS:
          FIELD Peso   AS DEC FORMAT '>>>,>>9.99'
          FIELD Bultos AS INT FORMAT '>,>>9'
          FIELD Volumen AS DEC FORMAT '>>>,>>9.99'
          FIELD Zona AS CHAR
          FIELD SubZona AS CHAR
          FIELD CodDpto AS CHAR
          FIELD CodProv AS CHAR
          FIELD CodDist AS CHAR
          FIELD Reprogramado AS LOG INITIAL NO
          
      END-FIELDS.
      TABLE: ORDENES B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
      TABLE: T-CREPO T "?" NO-UNDO INTEGRAL almcrepo
      TABLE: T-RUTAD T "?" NO-UNDO INTEGRAL FacCPedi
      ADDITIONAL-FIELDS:
          FIELD Peso   AS DEC FORMAT '>>>,>>9.99'
          FIELD Bultos AS INT FORMAT '>,>>9'
          FIELD Volumen AS DEC FORMAT '>>>,>>9.99'
          FIELD Zona AS CHAR
          FIELD SubZona AS CHAR
          FIELD CodDpto AS CHAR
          FIELD CodProv AS CHAR
          FIELD CodDist AS CHAR
          FIELD Reprogramado AS LOG INITIAL NO
      END-FIELDS.
      TABLE: T-VtaDTabla T "?" ? INTEGRAL VtaDTabla
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
/* BROWSE-TAB BROWSE-ORIGEN COMBO-BOX-Distrito F-Main */
/* BROWSE-TAB BROWSE-DESTINO FILL-IN-Importe F-Main */
ASSIGN 
       BROWSE-DESTINO:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 5.

ASSIGN 
       BROWSE-ORIGEN:NUM-LOCKED-COLUMNS IN FRAME F-Main     = 6
       BROWSE-ORIGEN:ALLOW-COLUMN-SEARCHING IN FRAME F-Main = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Bultos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Bultos-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Destinos IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Destinos-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Documentados IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Documentados-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Importe-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Peso-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-SKU IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-SKU-2 IN FRAME F-Main
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

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-DESTINO
/* Query rebuild information for BROWSE BROWSE-DESTINO
     _TblList          = "Temp-Tables.T-RUTAD,INTEGRAL.VtaCTabla WHERE Temp-Tables.T-RUTAD ...,INTEGRAL.VtaDTabla WHERE Temp-Tables.T-RUTAD ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, FIRST"
     _JoinCode[2]      = "INTEGRAL.VtaCTabla.CodCia = Temp-Tables.T-RUTAD.CodCia
  AND INTEGRAL.VtaCTabla.Llave = Temp-Tables.T-RUTAD.Zona"
     _Where[2]         = "INTEGRAL.VtaCTabla.Tabla = ""ZGHR"""
     _JoinCode[3]      = "INTEGRAL.VtaDTabla.CodCia = Temp-Tables.T-RUTAD.CodCia
  AND INTEGRAL.VtaDTabla.Llave = T-RUTAD.Zona
  AND INTEGRAL.VtaDTabla.Tipo = T-RUTAD.SubZona"
     _Where[3]         = "INTEGRAL.VtaDTabla.Tabla = ""SZGHR""
 AND INTEGRAL.VtaDTabla.LlaveDetalle = ""C"""
     _FldNameList[1]   > "_<CALC>"
"T-RUTAD.Reprogramado @ x-Reprogramado" "Rep." ? ? ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.T-RUTAD.CrossDocking
"T-RUTAD.CrossDocking" ? "SI/NO" "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.T-RUTAD.Sede
"T-RUTAD.Sede" "Canal" "x(25)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaCTabla.Descripcion
"VtaCTabla.Descripcion" "Zona" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.VtaDTabla.Libre_c02
"VtaDTabla.Libre_c02" "SubZona" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.T-RUTAD.LugEnt
"T-RUTAD.LugEnt" "Distrito" "x(25)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.T-RUTAD.NomCli
"T-RUTAD.NomCli" "Cliente" "x(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = Temp-Tables.T-RUTAD.FchEnt
     _FldNameList[9]   > Temp-Tables.T-RUTAD.CodDoc
"T-RUTAD.CodDoc" "Refer." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.T-RUTAD.NroPed
"T-RUTAD.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.T-RUTAD.Libre_d01
"T-RUTAD.Libre_d01" "# Docs." ">>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"T-RUTAD.Bultos @ x-Bultos" "Bultos" ">,>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   = Temp-Tables.T-RUTAD.ImpTot
     _FldNameList[14]   > "_<CALC>"
"T-RUTAD.Peso @ x-Peso" "Peso en kg" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"T-RUTAD.Volumen @ x-Volumen" "Volumen en m3" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.T-RUTAD.Libre_c01
"T-RUTAD.Libre_c01" "Estado" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-DESTINO */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-ORIGEN
/* Query rebuild information for BROWSE BROWSE-ORIGEN
     _TblList          = "Temp-Tables.CPEDI,INTEGRAL.VtaCTabla WHERE Temp-Tables.CPEDI ...,INTEGRAL.VtaDTabla WHERE Temp-Tables.CPEDI ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST,"
     _Where[1]         = "{&Condicion}"
     _JoinCode[2]      = "INTEGRAL.VtaCTabla.CodCia = Temp-Tables.CPEDI.CodCia
  AND INTEGRAL.VtaCTabla.Llave = Temp-Tables.CPEDI.Zona"
     _Where[2]         = "INTEGRAL.VtaCTabla.Tabla = ""ZGHR"""
     _JoinCode[3]      = "INTEGRAL.VtaDTabla.CodCia = Temp-Tables.CPEDI.CodCia
  AND INTEGRAL.VtaDTabla.Llave = CPEDI.Zona 
  AND INTEGRAL.VtaDTabla.Tipo = CPEDI.SubZona"
     _Where[3]         = "INTEGRAL.VtaDTabla.Tabla = ""SZGHR""
 AND INTEGRAL.VtaDTabla.LlaveDetalle = ""C"""
     _FldNameList[1]   > "_<CALC>"
"CPEDI.Reprogramado @ x-Reprogramado" "Rep." ? ? ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.CPEDI.CrossDocking
"CPEDI.CrossDocking" ? "SI/NO" "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.CPEDI.Sede
"CPEDI.Sede" "Canal" "x(25)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.VtaCTabla.Descripcion
"VtaCTabla.Descripcion" "Zona" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.VtaDTabla.Libre_c02
"VtaDTabla.Libre_c02" "SubZona" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.CPEDI.LugEnt
"CPEDI.LugEnt" "Distrito" "x(25)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.CPEDI.NomCli
"CPEDI.NomCli" "Cliente" "x(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   = Temp-Tables.CPEDI.FchEnt
     _FldNameList[9]   > Temp-Tables.CPEDI.CodDoc
"CPEDI.CodDoc" "Refer." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.CPEDI.NroPed
"CPEDI.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.CPEDI.Libre_d01
"CPEDI.Libre_d01" "# Docs." ">>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"CPEDI.Bultos @ x-Bultos" "Bultos" ">,>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   = Temp-Tables.CPEDI.ImpTot
     _FldNameList[14]   > "_<CALC>"
"CPEDI.Peso @ x-Peso" "Peso en kg" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"CPEDI.Volumen @ x-Volumen" "Volumen en m3" ">>>,>>9.99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > Temp-Tables.CPEDI.Libre_c01
"CPEDI.Libre_c01" "Estado" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   = Temp-Tables.CPEDI.Observa
     _Query            is OPENED
*/  /* BROWSE BROWSE-ORIGEN */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME F-Main:HANDLE
       ROW             = 3.42
       COLUMN          = 115
       HEIGHT          = .81
       WIDTH           = 3
       WIDGET-ID       = 76
       HIDDEN          = no
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {EAF26C8F-9586-101B-9306-0020AF234C9D} type: CSSpin */
      CtrlFrame:MOVE-AFTER(FILL-IN_ClientesLimite:HANDLE IN FRAME F-Main).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


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


&Scoped-define BROWSE-NAME BROWSE-ORIGEN
&Scoped-define SELF-NAME BROWSE-ORIGEN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-ORIGEN W-Win
ON START-SEARCH OF BROWSE-ORIGEN IN FRAME F-Main
DO:
    DEFINE VAR hSortColumn   AS WIDGET-HANDLE.
    DEFINE VAR lColumName    AS CHAR.
    DEFINE VAR lColumLabel   AS CHAR.
    DEFINE VAR hQueryHandle  AS HANDLE NO-UNDO.
    DEFINE VAR lQueryPrepare AS CHAR NO-UNDO.

    hSortColumn = BROWSE BROWSE-ORIGEN:CURRENT-COLUMN.
    lColumName  = hSortColumn:NAME.
    lColumLabel = hSortColumn:LABEL.

    hQueryHandle = BROWSE BROWSE-ORIGEN:QUERY.
    hQueryHandle:QUERY-CLOSE().

    /* CONTROL DE COLUMNA ACTIVA */
    CASE lColumLabel:
        WHEN "Canal"    THEN ASSIGN FLAG-Canal   = YES CPEDI.Sede:COLUMN-FGCOLOR = 0 CPEDI.Sede:COLUMN-BGCOLOR = 11.
        WHEN "Zona"     THEN ASSIGN FLAG-Zona    = YES VtaCTabla.Descripcion:COLUMN-FGCOLOR = 0 VtaCTabla.Descripcion:COLUMN-BGCOLOR = 11.
        WHEN "SubZona"  THEN ASSIGN FLAG-SubZona = YES VtaDTabla.Libre_c02:COLUMN-FGCOLOR = 0 VtaDTabla.Libre_c02:COLUMN-BGCOLOR = 11.
        WHEN "Distrito" THEN ASSIGN FLAG-Distrito= YES CPEDI.LugEnt:COLUMN-FGCOLOR = 0 CPEDI.LugEnt:COLUMN-BGCOLOR = 11.
        WHEN "Cliente"  THEN ASSIGN FLAG-Cliente = YES CPEDI.NomCli:COLUMN-FGCOLOR = 0 CPEDI.NomCli:COLUMN-BGCOLOR = 11.
    END CASE.

    IF FLAG-Canal = YES AND INDEX(SORTBY-General,SORTBY-Canal) = 0
        THEN SORTBY-General = SORTBY-General + (IF TRUE <> (SORTBY-General > '') THEN '' ELSE ' ') + SORTBY-Canal.
    IF FLAG-Zona = YES AND INDEX(SORTBY-General,SORTBY-Zona) = 0
        THEN SORTBY-General = SORTBY-General + (IF TRUE <> (SORTBY-General > '') THEN '' ELSE ' ') + SORTBY-Zona.
    IF FLAG-SubZona = YES AND INDEX(SORTBY-General,SORTBY-SubZona) = 0
        THEN SORTBY-General = SORTBY-General + (IF TRUE <> (SORTBY-General > '') THEN '' ELSE ' ') + SORTBY-SubZona.
    IF FLAG-Distrito = YES AND INDEX(SORTBY-General,SORTBY-Distrito) = 0
        THEN SORTBY-General = SORTBY-General + (IF TRUE <> (SORTBY-General > '') THEN '' ELSE ' ') + SORTBY-Distrito.
    IF FLAG-Cliente = YES AND INDEX(SORTBY-General,SORTBY-Cliente) = 0
        THEN SORTBY-General = SORTBY-General + (IF TRUE <> (SORTBY-General > '') THEN '' ELSE ' ') + SORTBY-Cliente.

    CASE lColumLabel:
        WHEN "Canal" THEN DO:
            IF SORTORDER-Canal = 0 THEN SORTORDER-Canal = 1.
            CASE SORTORDER-Canal:
                WHEN 1 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-Canal + ' DESC', SORTBY-Canal).
                    SORTORDER-Canal = 2.
                END.
                WHEN 2 THEN DO:
                    SORTBY-Canal = REPLACE(SORTBY-General, SORTBY-Canal, SORTBY-Canal  + ' DESC').
                    SORTORDER-Canal = 1.
                END.
            END CASE.
        END.
        WHEN "Zona" THEN DO:
            IF SORTORDER-Zona = 0 THEN SORTORDER-Zona = 1.
             CASE SORTORDER-Zona:
                WHEN 1 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-Zona + ' DESC', SORTBY-Zona).
                    SORTORDER-Zona = 2.
                END.
                WHEN 2 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-Zona, SORTBY-Zona  + ' DESC').
                    SORTORDER-Zona = 1.
                END.
            END CASE.
        END.
        WHEN "SubZona" THEN DO:
            IF SORTORDER-SubZona = 0 THEN SORTORDER-SubZona = 1.
            CASE SORTORDER-SubZona:
                WHEN 1 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-SubZona + ' DESC', SORTBY-SubZona).
                    SORTORDER-SubZona = 2.
                END.
                WHEN 2 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-SubZona, SORTBY-SubZona  + ' DESC').
                    SORTORDER-SubZona = 1.
                END.
            END CASE.
        END.
        WHEN "Distrito" THEN DO:
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
        WHEN "Cliente" THEN DO:
            IF SORTORDER-Cliente = 0 THEN SORTORDER-Cliente = 1.
            CASE SORTORDER-Cliente:
                WHEN 1 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-Cliente + ' DESC', SORTBY-Cliente).
                    SORTORDER-Cliente = 2.
                END.
                WHEN 2 THEN DO:
                    SORTBY-General = REPLACE(SORTBY-General, SORTBY-Cliente, SORTBY-Cliente  + ' DESC').
                    SORTORDER-Cliente = 1.
                END.
            END CASE.
        END.
    END CASE.
/*     CASE COMBO-BOX-Zona:                                                                                                             */
/*         WHEN 'Todos' THEN lQueryPrepare = "FOR EACH CPEDI NO-LOCK WHERE CPEDI.FlgEst <> 'A'".                                        */
/*         OTHERWISE lQueryPrepare = "FOR EACH CPEDI NO-LOCK WHERE CPEDI.FlgEst <> 'A' AND CPEDI.Libre_c04 = '" + COMBO-BOX-Zona + "'". */
/*     END CASE.                                                                                                                        */
/*                                                                                                                                      */
/*     lQueryPrepare = lQueryPrepare +                                                                                                  */
/*         ", FIRST VtaCTabla NO-LOCK WHERE VtaCTabla.CodCia = CPEDI.CodCia AND VtaCTabla.Llave = CPEDI.Libre_c04" +                    */
/*         " AND INTEGRAL.VtaCTabla.Tabla = '" + s-Tabla + "' ".                                                                        */
    lQueryPrepare = "FOR EACH CPEDI NO-LOCK".
    CASE COMBO-BOX-Canal:
        WHEN 'Todos' THEN .
        OTHERWISE lQueryPrepare = lQueryPrepare + (IF INDEX(lQueryPrepare,'WHERE') = 0 THEN ' WHERE ' ELSE '') +
            "CPEDI.CodDiv = '" + COMBO-BOX-Canal + "'".
    END CASE.
    CASE COMBO-BOX-Zona:
        WHEN 'Todos' THEN .
        OTHERWISE lQueryPrepare = lQueryPrepare + (IF INDEX(lQueryPrepare,'WHERE') = 0 THEN ' WHERE ' ELSE '') +
            "CPEDI.Zona = '" + COMBO-BOX-Zona + "'".
    END CASE.
    CASE COMBO-BOX-SubZona:
        WHEN 'Todos' THEN .
        OTHERWISE lQueryPrepare = lQueryPrepare + (IF INDEX(lQueryPrepare,'WHERE') = 0 THEN ' WHERE ' ELSE '') +
            "CPEDI.SubZona = '" + COMBO-BOX-SubZona + "'".
    END CASE.
    CASE COMBO-BOX-Distrito:
        WHEN 'Todos' THEN .
        OTHERWISE lQueryPrepare = lQueryPrepare + (IF INDEX(lQueryPrepare,'WHERE') = 0 THEN ' WHERE ' ELSE '') +
            "CPEDI.LugEnt = '" + COMBO-BOX-Distrito + "'".
    END CASE.

    lQueryPrepare = lQueryPrepare + 
        ", FIRST VtaCTabla NO-LOCK WHERE VtaCTabla.CodCia = CPEDI.CodCia AND VtaCTabla.Llave = CPEDI.Zona " +
        " AND VtaCTabla.Tabla = 'ZGHR', " +
        " EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = CPEDI.CodCia AND VtaDTabla.Llave = CPEDI.Zona " +
        " AND VtaDTabla.Tipo = CPEDI.SubZona AND VtaDTabla.Tabla = 'SZGHR' " +
        " AND VtaDTabla.LlaveDetalle = 'C'".
    
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


&Scoped-define SELF-NAME BUTTON-Generar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Generar W-Win
ON CHOOSE OF BUTTON-Generar IN FRAME F-Main /* GENERAR */
DO:
   IF NOT CAN-FIND(FIRST T-RUTAD NO-LOCK) THEN RETURN NO-APPLY.
   
   ASSIGN
       FILL-IN_ClientesLimite FILL-IN_PesoLimite FILL-IN_VolumenLimite.
   ASSIGN
       FILL-IN-Bultos-2 FILL-IN-Destinos-2 FILL-IN-Documentados-2
       FILL-IN-Importe-2 FILL-IN-Peso-2 FILL-IN-Volumen-2.
   /* Consistencia de límites */
   IF FILL-IN_PesoLimite > 0 AND FILL-IN-Peso-2 > FILL-IN_PesoLimite THEN DO:
       MESSAGE 'Supera el tope máximo de peso' VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
   END.
   IF FILL-IN_VolumenLimite > 0 AND FILL-IN-Volumen-2 > FILL-IN_VolumenLimite THEN DO:
       MESSAGE 'Supera el tope máximo de volumen' VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
   END.
   IF FILL-IN_ClientesLimite > 0 AND FILL-IN-Destinos-2 > FILL-IN_ClientesLimite THEN DO:
       MESSAGE 'Supera el tope máximo de clientes' VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
   END.
   IF FILL-IN_PesoLimite = 0 AND FILL-IN_VolumenLimite = 0 THEN DO:
       MESSAGE 'NO se han establecido límites de Peso y/o Volumen' SKIP
           'Continuamos con la generación de la Pre-Hoja de Ruta?'
           VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
       IF rpta = NO THEN RETURN NO-APPLY.
   END.
   RUN Genera-PreHoja.
   {&OPEN-QUERY-BROWSE-DESTINO}
   /*APPLY 'CHOOSE':U TO BUTTON-Refrescar.*/
   /*APPLY 'CHOOSE':U TO BUTTON-Limpiar-Orden.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Limpiar-Orden
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Limpiar-Orden W-Win
ON CHOOSE OF BUTTON-Limpiar-Orden IN FRAME F-Main /* Limpiar Orden */
DO:
    DEFINE VAR hQueryHandle  AS HANDLE NO-UNDO.

    hQueryHandle = BROWSE BROWSE-ORIGEN:QUERY.
    
    IF hQueryHandle:PREPARE-STRING = ? THEN RETURN.

    DO WITH FRAME {&FRAME-NAME}:
        FLAG-Canal    = NO.
        FLAG-Zona     = NO.
        FLAG-SubZona  = NO.
        FLAG-Distrito = NO.
        FLAG-Cliente  = NO.

        ASSIGN CPEDI.Sede:COLUMN-FGCOLOR IN BROWSE BROWSE-ORIGEN = ? CPEDI.Sede:COLUMN-BGCOLOR IN BROWSE BROWSE-ORIGEN = ?.
        ASSIGN VtaCTabla.Descripcion:COLUMN-FGCOLOR IN BROWSE BROWSE-ORIGEN = ? VtaCTabla.Descripcion:COLUMN-BGCOLOR IN BROWSE BROWSE-ORIGEN = ?.
        ASSIGN VtaDTabla.Libre_c02:COLUMN-FGCOLOR IN BROWSE BROWSE-ORIGEN = ? VtaDTabla.Libre_c02:COLUMN-BGCOLOR IN BROWSE BROWSE-ORIGEN = ?.
        ASSIGN CPEDI.LugEnt:COLUMN-FGCOLOR IN BROWSE BROWSE-ORIGEN = ? CPEDI.LugEnt:COLUMN-BGCOLOR IN BROWSE BROWSE-ORIGEN = ?.
        ASSIGN CPEDI.NomCli:COLUMN-FGCOLOR IN BROWSE BROWSE-ORIGEN = ? CPEDI.NomCli:COLUMN-BGCOLOR IN BROWSE BROWSE-ORIGEN = ?.

        SORTBY-General = "".

        SORTORDER-Canal = 0.
        SORTORDER-Zona = 0.
        SORTORDER-SubZona = 0.
        SORTORDER-Distrito = 0.
        SORTORDER-Cliente = 0.

        {&OPEN-QUERY-BROWSE-ORIGEN}
        RUN Totales.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Refrescar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Refrescar W-Win
ON CHOOSE OF BUTTON-Refrescar IN FRAME F-Main /* Aplicar Filtros */
DO:
  ASSIGN
      FILL-IN-Desde FILL-IN-Hasta
      RADIO-SET_Tipo FILL-IN_NroPed FILL-IN_Cliente
      COMBO-BOX-Canal COMBO-BOX-Distrito COMBO-BOX-SubZona COMBO-BOX-Zona
      .

  IF FILL-IN-Desde = ? THEN FILL-IN-Desde = TODAY - 10.
  IF FILL-IN-Hasta = ? THEN FILL-IN-Hasta = TODAY + 1.
  DISPLAY FILL-IN-Desde FILL-IN-Hasta WITH FRAME {&FRAME-NAME}.
  ASSIGN
      COMBO-BOX-Canal = 'Todos'
      COMBO-BOX-Distrito = 'Todos'
      COMBO-BOX-SubZona = 'Todos'
      COMBO-BOX-Zona = 'Todos'.
  DISPLAY COMBO-BOX-Canal COMBO-BOX-Distrito COMBO-BOX-SubZona COMBO-BOX-Zona WITH FRAME {&FRAME-NAME}.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporales.
  RUN Depuracion.
  SESSION:SET-WAIT-STATE('').
  MESSAGE 'Carga Exitosa' VIEW-AS ALERT-BOX INFORMATION.
  {&OPEN-QUERY-BROWSE-ORIGEN}
  {&OPEN-QUERY-BROWSE-DESTINO}
  RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Down_Cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Down_Cliente W-Win
ON CHOOSE OF BUTTON_Down_Cliente IN FRAME F-Main /* CLIENTE */
DO:
    DEF VAR k AS INT NO-UNDO.
    DEF VAR x-Clientes AS CHAR NO-UNDO.

    DO k = 1 TO BROWSE-ORIGEN:NUM-SELECTED-ROWS:
        IF BROWSE-ORIGEN:FETCH-SELECTED-ROW(k) THEN DO:
            IF TRUE <> (x-Clientes > '') THEN x-Clientes = CPEDI.CodCli.
            ELSE IF LOOKUP(CPEDI.CodCli, x-Clientes) = 0 THEN x-Clientes = x-Clientes + ',' + CPEDI.CodCli.
        END.
    END.
    DO k = 1 TO NUM-ENTRIES(x-Clientes):
        FOR EACH CPEDI WHERE {&Condicion} AND CPEDI.CodCli = ENTRY(k,x-Clientes):
            CREATE T-RUTAD.
            BUFFER-COPY CPEDI TO T-RUTAD.
            DELETE CPEDI.
        END.
    END.
    APPLY 'CHOOSE':U TO BUTTON-Limpiar-Orden.
    RUN Totales.
    {&OPEN-QUERY-BROWSE-ORIGEN}
    {&OPEN-QUERY-BROWSE-DESTINO}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Down_Selectivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Down_Selectivo W-Win
ON CHOOSE OF BUTTON_Down_Selectivo IN FRAME F-Main /* SELECTIVO */
DO:
    DEF VAR k AS INT NO-UNDO.
    DEF VAR x-Clientes AS CHAR NO-UNDO.

    DO k = 1 TO BROWSE-ORIGEN:NUM-SELECTED-ROWS:
        IF BROWSE-ORIGEN:FETCH-SELECTED-ROW(k) THEN DO:
            CREATE T-RUTAD.
            BUFFER-COPY CPEDI TO T-RUTAD.
            DELETE CPEDI.
        END.
    END.
    APPLY 'CHOOSE':U TO BUTTON-Limpiar-Orden.
    RUN Totales.
    {&OPEN-QUERY-BROWSE-ORIGEN}
    {&OPEN-QUERY-BROWSE-DESTINO}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Down_Todo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Down_Todo W-Win
ON CHOOSE OF BUTTON_Down_Todo IN FRAME F-Main /* TODO */
DO:
  FOR EACH CPEDI WHERE {&Condicion}:
      CREATE T-RUTAD.
      BUFFER-COPY CPEDI TO T-RUTAD.
      DELETE CPEDI.
  END.
  APPLY 'CHOOSE':U TO BUTTON-Limpiar-Orden.
  RUN Totales.
  {&OPEN-QUERY-BROWSE-ORIGEN}
  {&OPEN-QUERY-BROWSE-DESTINO}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Limpiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Limpiar W-Win
ON CHOOSE OF BUTTON_Limpiar IN FRAME F-Main /* Limpiar Filtros */
DO:
  RUN Limpiar-Filtros.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Up_Cliente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Up_Cliente W-Win
ON CHOOSE OF BUTTON_Up_Cliente IN FRAME F-Main /* CLIENTE */
DO:
    DEF VAR k AS INT NO-UNDO.
    DEF VAR x-Clientes AS CHAR NO-UNDO.

    DO k = 1 TO BROWSE-DESTINO:NUM-SELECTED-ROWS:
        IF BROWSE-DESTINO:FETCH-SELECTED-ROW(k) THEN DO:
            IF TRUE <> (x-Clientes > '') THEN x-Clientes = T-RUTAD.CodCli.
            ELSE IF LOOKUP(T-RUTAD.CodCli, x-Clientes) = 0 THEN x-Clientes = x-Clientes + ',' + T-RUTAD.CodCli.
        END.
    END.
    DO k = 1 TO NUM-ENTRIES(x-Clientes):
        FOR EACH T-RUTAD WHERE T-RUTAD.CodCli = ENTRY(k,x-Clientes):
            CREATE CPEDI.
            BUFFER-COPY T-RUTAD TO CPEDI.
            DELETE T-RUTAD.
        END.
    END.
    APPLY 'CHOOSE':U TO BUTTON-Limpiar-Orden.
    RUN Totales.
    {&OPEN-QUERY-BROWSE-ORIGEN}
    {&OPEN-QUERY-BROWSE-DESTINO}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Up_Selectivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Up_Selectivo W-Win
ON CHOOSE OF BUTTON_Up_Selectivo IN FRAME F-Main /* SELECTIVO */
DO:
    DEF VAR k AS INT NO-UNDO.
    DEF VAR x-Clientes AS CHAR NO-UNDO.

    DO k = 1 TO BROWSE-DESTINO:NUM-SELECTED-ROWS:
        IF BROWSE-DESTINO:FETCH-SELECTED-ROW(k) THEN DO:
            CREATE CPEDI.
            BUFFER-COPY T-RUTAD TO CPEDI.
            DELETE T-RUTAD.
        END.
    END.
    APPLY 'CHOOSE':U TO BUTTON-Limpiar-Orden.
    RUN Totales.
    {&OPEN-QUERY-BROWSE-ORIGEN}
    {&OPEN-QUERY-BROWSE-DESTINO}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Up_Todo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Up_Todo W-Win
ON CHOOSE OF BUTTON_Up_Todo IN FRAME F-Main /* TODO */
DO:
    FOR EACH T-RUTAD:
        CREATE CPEDI.
        BUFFER-COPY T-RUTAD TO CPEDI.
        DELETE T-RUTAD.
    END.
    APPLY 'CHOOSE':U TO BUTTON-Limpiar-Orden.
    RUN Totales.
    {&OPEN-QUERY-BROWSE-ORIGEN}
    {&OPEN-QUERY-BROWSE-DESTINO}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Canal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Canal W-Win
ON VALUE-CHANGED OF COMBO-BOX-Canal IN FRAME F-Main /* Canal */
DO:
  IF SELF:SCREEN-VALUE = COMBO-BOX-Canal THEN RETURN.
  ASSIGN {&self-name}.
  {&OPEN-QUERY-BROWSE-ORIGEN}
  RUN Totales.
/*
  DEFINE VAR lColumName    AS CHAR.
  DEFINE VAR lColumLabel   AS CHAR.
  DEFINE VAR hQueryHandle  AS HANDLE NO-UNDO.
  DEFINE VAR lQueryPrepare AS CHAR NO-UNDO.

  hSortColumn = BROWSE BROWSE-ORIGEN:CURRENT-COLUMN.
  lColumName  = hSortColumn:NAME.
  lColumLabel = hSortColumn:LABEL.

  hQueryHandle = BROWSE BROWSE-ORIGEN:QUERY.
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Distrito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Distrito W-Win
ON VALUE-CHANGED OF COMBO-BOX-Distrito IN FRAME F-Main /* Distrito */
DO:
    IF SELF:SCREEN-VALUE = COMBO-BOX-Distrito THEN RETURN.
    ASSIGN {&self-name}.
    {&OPEN-QUERY-BROWSE-ORIGEN}
    RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-SubZona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-SubZona W-Win
ON VALUE-CHANGED OF COMBO-BOX-SubZona IN FRAME F-Main /* Sub-Zona */
DO:
    IF SELF:SCREEN-VALUE = COMBO-BOX-SubZona THEN RETURN.
    ASSIGN {&self-name}.
    DEF VAR cListItems AS CHAR NO-UNDO.

    REPEAT WHILE COMBO-BOX-Distrito:NUM-ITEMS > 0:
        COMBO-BOX-Distrito:DELETE(1).
    END.
    COMBO-BOX-Distrito:ADD-LAST('Todos','Todos').
    FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-codcia
        AND VtaDTabla.Tabla = "SZGHR"
        AND VtaDTabla.Llave = COMBO-BOX-Zona:SCREEN-VALUE
        AND VtaDTabla.Tipo  = SELF:SCREEN-VALUE
        AND VtaDTabla.LlaveDetalle = "D",
        FIRST TabDistr NO-LOCK WHERE TabDistr.CodDepto = VtaDTabla.Libre_c01
        AND TabDistr.CodProvi = VtaDTabla.Libre_c02
        AND TabDistr.CodDistr = VtaDTabla.Libre_c03:
        COMBO-BOX-Distrito:ADD-LAST(TabDistr.NomDistr, TabDistr.CodDistr).
    END.
    {&OPEN-QUERY-BROWSE-ORIGEN}
    COMBO-BOX-Distrito:SCREEN-VALUE = 'Todos'.
    APPLY 'VALUE-CHANGED':U TO COMBO-BOX-Distrito.
    RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Zona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Zona W-Win
ON VALUE-CHANGED OF COMBO-BOX-Zona IN FRAME F-Main /* Zona */
DO:
  IF SELF:SCREEN-VALUE = COMBO-BOX-Zona THEN RETURN.
  ASSIGN {&self-name}.
  DEF VAR cListItems AS CHAR NO-UNDO.

  REPEAT WHILE COMBO-BOX-SubZona:NUM-ITEMS > 0:
      COMBO-BOX-SubZona:DELETE(1).
  END.
  COMBO-BOX-SubZona:ADD-LAST('Todos','Todos').
  FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-codcia
      AND VtaDTabla.Tabla = "SZGHR"
      AND VtaDTabla.Llave = SELF:SCREEN-VALUE
      AND VtaDTabla.LlaveDetalle = "C":
      COMBO-BOX-SubZona:ADD-LAST(VtaDTabla.Libre_c02, VtaDTabla.Tipo).
  END.
  {&OPEN-QUERY-BROWSE-ORIGEN}
  COMBO-BOX-SubZona:SCREEN-VALUE = 'Todos'.
  APPLY 'VALUE-CHANGED':U TO COMBO-BOX-SubZona.
  RUN Totales.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame W-Win OCX.SpinDown
PROCEDURE CtrlFrame.CSSpin.SpinDown .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    FILL-IN_ClientesLimite:SCREEN-VALUE = STRING(INT(FILL-IN_ClientesLimite:SCREEN-VALUE) - 1).
    IF INT(FILL-IN_ClientesLimite:SCREEN-VALUE) = 0 THEN FILL-IN_ClientesLimite:SCREEN-VALUE = '1'.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame W-Win OCX.SpinUp
PROCEDURE CtrlFrame.CSSpin.SpinUp .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    IF INT(FILL-IN_ClientesLimite:SCREEN-VALUE) + 1 > 999 
        THEN FILL-IN_ClientesLimite:SCREEN-VALUE = '999'.
    ELSE FILL-IN_ClientesLimite:SCREEN-VALUE = STRING(INT(FILL-IN_ClientesLimite:SCREEN-VALUE) + 1).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-DESTINO
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

EMPTY TEMP-TABLE T-VtaDTabla.
EMPTY TEMP-TABLE CPEDI.
/*EMPTY TEMP-TABLE T-RUTAD.*/

FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-codcia
    AND VtaDTabla.Tabla = "SZGHR"
    AND VtaDTabla.LlaveDetalle = "C":
    CREATE T-VtaDTabla.
    BUFFER-COPY VtaDTabla TO T-VtaDTabla.
END.

RUN NoDocumentados.

RUN Datos-Finales.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Consistencia W-Win 
PROCEDURE Consistencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER B-RutaC FOR Di-RutaC.
DEF BUFFER B-RUTAD FOR Di-RutaD.
DEF BUFFER B-RUTAG FOR Di-RutaG.

{dist/valida-od-para-phr.i}

/* ************
  /* Está en una PHR en trámite => NO va */
  FIND FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-CodCia AND
        DI-RutaD.CodDiv = s-CodDiv AND
        DI-RutaD.CodDoc = "PHR" AND
        DI-RutaD.CodRef = Faccpedi.CodDoc AND
        DI-RutaD.NroRef = Faccpedi.NroPed AND
        CAN-FIND(DI-RutaC OF DI-RutaD WHERE DI-RutaC.FlgEst BEGINS "P" NO-LOCK)
        NO-LOCK NO-ERROR.
  IF AVAILABLE DI-RutaD THEN RETURN 'ADM-ERROR'.

  /* Si tiene una reprogramación por aprobar => No va  */
  FIND FIRST Almcdocu WHERE AlmCDocu.CodCia = s-CodCia AND
      AlmCDocu.CodLlave = s-CodDiv AND
      AlmCDocu.CodDoc = Faccpedi.coddoc AND 
      AlmCDocu.NroDoc = Faccpedi.nroped AND
      AlmCDocu.FlgEst = "P" NO-LOCK NO-ERROR.
  IF AVAILABLE Almcdocu THEN RETURN 'ADM-ERROR'.

  /* Si ya fue entregado o tiene una devolución parcial NO va */
  FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
      AND CcbCDocu.CodPed = Faccpedi.codref       /* PED */
      AND CcbCDocu.NroPed = Faccpedi.nroref
      AND Ccbcdocu.Libre_c01 = Faccpedi.coddoc    /* O/D */
      AND Ccbcdocu.Libre_c02 = Faccpedi.nroped
      AND Ccbcdocu.FlgEst <> "A":
      IF NOT (Ccbcdocu.coddiv = s-coddiv AND Ccbcdocu.coddoc = "G/R") THEN NEXT.
      FOR EACH B-RutaD NO-LOCK WHERE B-RutaD.CodCia = s-codcia
          AND B-RutaD.CodDiv = s-CodDiv
          AND B-RutaD.CodDoc = "H/R"
          AND B-RutaD.CodRef = Ccbcdocu.coddoc
          AND B-RutaD.NroRef = Ccbcdocu.nrodoc,
          FIRST B-RutaC OF B-RutaD NO-LOCK WHERE B-RutaC.FlgEst = 'C':
          IF B-RutaD.FlgEst = "C" THEN RETURN 'ADM-ERROR'.  /* Entregado */
          IF B-RutaD.FlgEst = "D" THEN RETURN 'ADM-ERROR'.  /* Devolución Parcial */
          /* Verificamos que haya pasado por PHR */
          IF NOT CAN-FIND(FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-CodCia AND
                          DI-RutaD.CodDiv = s-CodDiv AND
                          DI-RutaD.CodDoc = "PHR" AND
                          DI-RutaD.CodRef = Faccpedi.CodDoc AND
                          DI-RutaD.NroRef = Faccpedi.NroPed AND
                          CAN-FIND(DI-RutaC OF DI-RutaD WHERE DI-RutaC.FlgEst = "C" NO-LOCK)
                          NO-LOCK)
              THEN RETURN 'ADM-ERROR'.
      END.
  END.
  FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = s-CodCia AND 
      Almcmov.CodRef = Faccpedi.CodDoc AND 
      Almcmov.NroRef = Faccpedi.NroPed AND
      Almcmov.FlgEst <> 'A':
      FOR EACH B-RutaG NO-LOCK WHERE B-RutaG.CodCia = s-codcia
          AND B-RutaG.CodDiv = s-CodDiv
          AND B-RutaG.CodDoc = "H/R"
          AND B-RutaG.CodAlm = Almcmov.CodAlm
          AND B-RutaG.Tipmov = Almcmov.TipMov
          AND B-RutaG.Codmov = Almcmov.CodMov
          AND B-RutaG.SerRef = Almcmov.NroSer
          AND B-RutaG.NroRef = Almcmov.NroDoc,
          FIRST B-RutaC OF B-RutaG NO-LOCK WHERE B-RutaC.FlgEst = 'C':
          IF B-RutaG.FlgEst = "C" THEN RETURN 'ADM-ERROR'.  /* Entregado */
          IF B-RutaG.FlgEst = "D" THEN RETURN 'ADM-ERROR'.  /* Devolución Parcial */
      END.
  END.
  /* Si está en una H/R en trámite => No va */
  FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
      AND CcbCDocu.CodPed = Faccpedi.codref       /* PED */
      AND CcbCDocu.NroPed = Faccpedi.nroref
      AND Ccbcdocu.Libre_c01 = Faccpedi.coddoc    /* O/D */
      AND Ccbcdocu.Libre_c02 = Faccpedi.nroped
      AND Ccbcdocu.FlgEst <> "A":
      IF NOT (Ccbcdocu.coddiv = s-coddiv AND Ccbcdocu.coddoc = "G/R") THEN NEXT.
      FOR EACH B-RutaD NO-LOCK WHERE B-RutaD.CodCia = s-codcia
          AND B-RutaD.CodDiv = s-CodDiv
          AND B-RutaD.CodDoc = "H/R"
          AND B-RutaD.CodRef = Ccbcdocu.coddoc
          AND B-RutaD.NroRef = Ccbcdocu.nrodoc,
          FIRST B-RutaC OF B-RutaD NO-LOCK WHERE B-RutaC.FlgEst BEGINS 'P':
          RETURN 'ADM-ERROR'.
      END.
  END.
  FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = s-CodCia AND 
      Almcmov.CodRef = Faccpedi.CodDoc AND 
      Almcmov.NroRef = Faccpedi.NroPed AND
      Almcmov.FlgEst <> 'A':
      FOR EACH B-RutaG NO-LOCK WHERE B-RutaG.CodCia = s-codcia
          AND B-RutaG.CodDiv = s-CodDiv
          AND B-RutaG.CodDoc = "H/R"
          AND B-RutaG.CodAlm = Almcmov.CodAlm
          AND B-RutaG.Tipmov = Almcmov.TipMov
          AND B-RutaG.Codmov = Almcmov.CodMov
          AND B-RutaG.SerRef = Almcmov.NroSer
          AND B-RutaG.NroRef = Almcmov.NroDoc,
          FIRST B-RutaC OF B-RutaG NO-LOCK WHERE B-RutaC.FlgEst BEGINS 'P':
          RETURN 'ADM-ERROR'.
      END.
  END.
  RETURN 'OK'.
**************** */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load W-Win  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "w-pre-hoja-ruta-v3.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
END.
ELSE MESSAGE "w-pre-hoja-ruta-v3.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

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

/* Destino Teórico: Depende del Cliente */
DEF VAR pCodDpto AS CHAR NO-UNDO. 
DEF VAR pCodProv AS CHAR NO-UNDO. 
DEF VAR pCodDist AS CHAR NO-UNDO. 
DEF VAR pCodPos  AS CHAR NO-UNDO. 
DEF VAR pZona    AS CHAR NO-UNDO. 
DEF VAR pSubZona AS CHAR NO-UNDO. 

FOR EACH CPEDI:
    RUN gn/fUbigeo (
        CPEDI.CodDiv, 
        CPEDI.CodDoc,
        CPEDI.NroPed,
        OUTPUT pCodDpto,
        OUTPUT pCodProv,
        OUTPUT pCodDist,
        OUTPUT pCodPos,
        OUTPUT pZona,
        OUTPUT pSubZona
        ).
    /* Valor por Defecto */
    ASSIGN
        CPEDI.CodDpto = pCodDpto
        CPEDI.CodProv = pCodProv
        CPEDI.CodDist = pCodDist
        CPEDI.CodPos  = pCodPos
        CPEDI.Zona    = pZona
        CPEDI.SUbZona = pSubZona
        CPEDI.Libre_d01 = 0     /* # de G/R relacionadas */
        .
    CASE CPEDI.CodDoc:
        WHEN "O/M" OR WHEN "O/D" THEN DO:
            /* Buscamos del PEDido: Puede ser del cliente o del 1er. tramo */
            FIND PEDIDO WHERE PEDIDO.codcia = s-codcia
                AND PEDIDO.coddoc = CPEDI.codref
                AND PEDIDO.nroped = CPEDI.nroref
                AND PEDIDO.codpos > ''
                NO-LOCK NO-ERROR.
            IF AVAILABLE PEDIDO THEN DO:
                /* Contamos cuantas guias de remisión están relacionadas */
                FOR EACH Ccbcdocu NO-LOCK USE-INDEX Llave15 WHERE Ccbcdocu.codcia = s-codcia
                    AND Ccbcdocu.codped = PEDIDO.coddoc
                    AND Ccbcdocu.nroped = PEDIDO.nroped
                    AND Ccbcdocu.flgest <> 'A':
                    IF Ccbcdocu.coddiv = s-coddiv AND Ccbcdocu.coddoc = 'G/R'
                        THEN CPEDI.Libre_d01 = CPEDI.Libre_d01 + 1.
                END.
            END.
        END.
        WHEN "OTR" THEN DO:
            /* Contamos cuantas guias de remisión están relacionadas */
            FOR EACH Almcmov NO-LOCK USE-INDEX Almc07 WHERE Almcmov.codcia = 1 
                AND Almcmov.flgest <> 'A'
                AND Almcmov.codref = CPEDI.coddoc
                AND Almcmov.nroref = CPEDI.nroped:
                IF Almcmov.tipmov = 'S' AND Almcmov.codmov = 03
                    THEN CPEDI.Libre_d01 = CPEDI.Libre_d01 + 1.
            END.
        END.
    END CASE.
END.

/* Acumulamos */
FOR EACH CPEDI:
    FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-codcia
        AND VtaDTabla.Tabla = "SZGHR"
        AND VtaDTabla.LlaveDetalle = "D"
        AND VtaDTabla.Libre_c01 = CPEDI.CodDpto
        AND VtaDTabla.Libre_c02 = CPEDI.CodProv
        AND VtaDTabla.Libre_c03 = CPEDI.CodDist,
        FIRST T-VtaDTabla WHERE T-VtaDTabla.CodCia = VtaDTabla.CodCia
        AND T-VtaDTabla.Tabla = "SZGHR"
        AND T-VtaDTabla.Llave = VtaDTabla.Llave
        AND T-VtaDTabla.Tipo  = VtaDTabla.Tipo:
        ASSIGN
            T-VtaDTabla.Libre_d01 = T-VtaDTabla.Libre_d01 + 1
            T-VtaDTabla.Libre_d02 = T-VtaDTabla.Libre_d02 + CPEDI.Peso
            T-VtaDTabla.Libre_d03 = T-VtaDTabla.Libre_d03 + CPEDI.Volumen
            T-VtaDTabla.Libre_d04 = T-VtaDTabla.Libre_d04 + CPEDI.ImpTot.
    END.
    /* Otros Datos */
    FIND FIRST GN-DIVI WHERE GN-DIVI.CodCia = CPEDI.CodCia
        AND GN-DIVI.CodDiv = CPEDI.CodDiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN CPEDI.Sede = CAPS(gn-divi.desdiv).
    FIND TabDistr WHERE TabDistr.CodDepto = CPEDI.CodDpto
        AND TabDistr.CodProvi = CPEDI.CodProv
        AND TabDistr.CodDistr = CPEDI.CodDist
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN CPEDI.LugEnt = TabDistr.NomDistr.
    FIND FIRST CcbCBult WHERE CcbCBult.CodCia = s-codcia
        AND CcbCBult.CodDoc = CPEDI.CodDoc
        AND CcbCBult.NroDoc = CPEDI.NroPed
        AND CcbCBult.CHR_01 = "P"                     /* H/R Aún NO cerrada */
        NO-LOCK NO-ERROR.
    IF AVAILABLE CcbCBult THEN CPEDI.Bultos = CcbCBult.Bultos.
END.

END PROCEDURE.


/*
FOR EACH CPEDI:
    /* Valor por Defecto */
    ASSIGN
        CPEDI.CodDpto = '15'
        CPEDI.CodProv = '01'      /* Lima - Lima */
        CPEDI.CodDist = '01'
        CPEDI.CodPos  = ''      /* CODIGO POSTAL */
        CPEDI.Libre_d01 = 0     /* # de G/R relacionadas */
        .
    CASE CPEDI.CodDoc:
        WHEN "O/M" OR WHEN "O/D" THEN DO:
            /* Por defecto del cliente */
            FIND gn-clie WHERE gn-clie.codcia = cl-codcia
                AND gn-clie.codcli = CPEDI.codcli
                NO-LOCK NO-ERROR.
            FIND FIRST TabDistr WHERE TabDistr.CodDepto = gn-clie.CodDept 
                AND TabDistr.CodProvi = gn-clie.CodProv 
                AND TabDistr.CodDistr = gn-clie.CodDist
                NO-LOCK NO-ERROR.
            IF AVAILABLE TabDistr THEN
                ASSIGN
                    CPEDI.CodDpto = TabDistr.CodDepto
                    CPEDI.CodProv = TabDistr.CodProvi
                    CPEDI.CodDist = TabDistr.CodDistr
                    CPEDI.CodPos  = TabDistr.CodPos.
            /* Buscamos del PEDido: Puede ser del cliente o del 1er. tramo */
            FIND PEDIDO WHERE PEDIDO.codcia = s-codcia
                AND PEDIDO.coddoc = CPEDI.codref
                AND PEDIDO.nroped = CPEDI.nroref
                AND PEDIDO.codpos > ''
                NO-LOCK NO-ERROR.
            IF AVAILABLE PEDIDO THEN DO:
                ASSIGN CPEDI.CodPos = PEDIDO.CodPos.
                IF CPEDI.CodPos <> "P0" THEN DO:    /* NO PARA PROVINCIAS: Tomamos el del cliente */
                    FIND FIRST TabDistr WHERE TabDistr.CodPos = PEDIDO.CodPos NO-LOCK NO-ERROR.
                    IF AVAILABLE TabDistr
                        THEN ASSIGN
                            CPEDI.CodDpto = TabDistr.CodDepto
                            CPEDI.CodProv = TabDistr.CodProvi
                            CPEDI.CodDist = TabDistr.CodDistr.
                END.
                /* Contamos cuantas guias de remisión están relacionadas */
                FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
                    AND Ccbcdocu.coddiv = s-coddiv
                    AND Ccbcdocu.coddoc = 'G/R'
                    AND Ccbcdocu.codped = PEDIDO.coddoc
                    AND Ccbcdocu.nroped = PEDIDO.nroped
                    AND Ccbcdocu.flgest <> 'A':
                    CPEDI.Libre_d01 = CPEDI.Libre_d01 + 1.
                END.
            END.
        END.
        WHEN "OTR" THEN DO:
            FIND FIRST Almacen WHERE Almacen.codcia = CPEDI.codcia
                AND Almacen.codalm = CPEDI.codcli
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almacen THEN DO:
                FIND FIRST gn-divi WHERE GN-DIVI.CodCia = Almacen.codcia
                    AND GN-DIVI.CodDiv = Almacen.coddiv
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-divi THEN DO:
                    ASSIGN
                        CPEDI.CodDpto = GN-DIVI.Campo-Char[3]
                        CPEDI.CodProv = GN-DIVI.Campo-Char[4]
                        CPEDI.CodDist = GN-DIVI.Campo-Char[5].
                    FIND FIRST TabDistr WHERE TabDistr.CodDepto = CPEDI.CodDpto
                        AND TabDistr.CodProvi = CPEDI.CodProv
                        AND TabDistr.CodDistr = CPEDI.CodDist
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE TabDistr THEN ASSIGN CPEDI.CodPos = TabDistr.CodPos.
                END.
            END.
            /* Contamos cuantas guias de remisión están relacionadas */
            FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = 1 
                AND Almcmov.tipmov = 'S' 
                AND Almcmov.codmov = 03
                AND Almcmov.flgest <> 'A'
                AND Almcmov.codref = CPEDI.coddoc
                AND Almcmov.nroref = CPEDI.nroped:
                CPEDI.Libre_d01 = CPEDI.Libre_d01 + 1.
            END.
        END.
    END CASE.
END.
/* Acumulamos */
FOR EACH CPEDI:
    FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-codcia
        AND VtaDTabla.Tabla = "SZGHR"
        AND VtaDTabla.LlaveDetalle = "D"
        AND VtaDTabla.Libre_c01 = CPEDI.CodDpto
        AND VtaDTabla.Libre_c02 = CPEDI.CodProv
        AND VtaDTabla.Libre_c03 = CPEDI.CodDist,
        FIRST T-VtaDTabla WHERE T-VtaDTabla.CodCia = VtaDTabla.CodCia
        AND T-VtaDTabla.Tabla = "SZGHR"
        AND T-VtaDTabla.Llave = VtaDTabla.Llave
        AND T-VtaDTabla.Tipo  = VtaDTabla.Tipo:
        ASSIGN
            T-VtaDTabla.Libre_d01 = T-VtaDTabla.Libre_d01 + 1
            T-VtaDTabla.Libre_d02 = T-VtaDTabla.Libre_d02 + CPEDI.Peso
            T-VtaDTabla.Libre_d03 = T-VtaDTabla.Libre_d03 + CPEDI.Volumen
            T-VtaDTabla.Libre_d04 = T-VtaDTabla.Libre_d04 + CPEDI.ImpTot.
        ASSIGN
            CPEDI.Zona    = T-VtaDTabla.Llave
            CPEDI.SubZona = T-VtaDTabla.Tipo.
    END.
    IF CPEDI.CodPos = "P0" THEN ASSIGN CPEDI.Zona = "02" CPEDI.SubZona = "01".  /* LIMA CENTRO AGENCIAS */
    /* Otros Datos */
    FIND FIRST GN-DIVI WHERE GN-DIVI.CodCia = CPEDI.CodCia
        AND GN-DIVI.CodDiv = CPEDI.CodDiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN CPEDI.Sede = CAPS(gn-divi.desdiv).
    FIND TabDistr WHERE TabDistr.CodDepto = CPEDI.CodDpto
        AND TabDistr.CodProvi = CPEDI.CodProv
        AND TabDistr.CodDistr = CPEDI.CodDist
        NO-LOCK NO-ERROR.
    IF AVAILABLE TabDistr THEN CPEDI.LugEnt = TabDistr.NomDistr.
    FIND FIRST CcbCBult WHERE CcbCBult.CodCia = s-codcia
        AND CcbCBult.CodDoc = CPEDI.CodDoc
        AND CcbCBult.NroDoc = CPEDI.NroPed
        AND CcbCBult.CHR_01 = "P"                     /* H/R Aún NO cerrada */
        NO-LOCK NO-ERROR.
    IF AVAILABLE CcbCBult THEN CPEDI.Bultos = CcbCBult.Bultos.
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Depuracion W-Win 
PROCEDURE Depuracion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR cEstado AS CHAR NO-UNDO.
FOR EACH CPEDI:
    FIND FIRST VtaCTabla WHERE VtaCTabla.CodCia = CPEDI.CodCia
        AND VtaCTabla.Llave = CPEDI.Zona
        AND VtaCTabla.Tabla = "ZGHR" NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaCTabla THEN DO:
        DELETE CPEDI.
        NEXT.
    END.
    FIND VtaDTabla WHERE VtaDTabla.CodCia = CPEDI.CodCia
        AND VtaDTabla.Llave = CPEDI.Zona 
        AND VtaDTabla.Tipo = CPEDI.SubZona
        AND VtaDTabla.Tabla = "SZGHR"
        AND VtaDTabla.LlaveDetalle = "C" NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaCTabla THEN DO:
        DELETE CPEDI.
        NEXT.
    END.
    RUN Estado (CPEDI.CodDoc, CPEDI.NroPed, OUTPUT cEstado).
    CPEDI.Libre_c01 = cEstado.
    IF CAN-FIND(LAST AlmCDocu WHERE AlmCDocu.CodCia = CPEDI.codcia AND
                AlmCDocu.CodLlave = s-CodDiv AND 
                AlmCDocu.CodDoc = CPEDI.CodDoc AND
                AlmCDocu.NroDoc = CPEDI.NroPed AND 
                AlmCDocu.FlgEst = "C" NO-LOCK)
        THEN CPEDI.Reprogramado = YES.
END.
DO WITH FRAME {&FRAME-NAME}:
    COMBO-BOX-Canal:DELETE(COMBO-BOX-Canal:LIST-ITEM-PAIRS).
    COMBO-BOX-Canal:ADD-LAST('Todos','Todos').
    COMBO-BOX-Canal = 'Todos'.
    FOR EACH CPEDI, FIRST GN-DIVI NO-LOCK WHERE GN-DIVI.CodCia = s-codcia 
        AND GN-DIVI.CodDiv = CPEDI.CodDiv
        BREAK BY CPEDI.CodDiv:
        IF FIRST-OF(CPEDI.CodDiv) THEN COMBO-BOX-Canal:ADD-LAST(CAPS(GN-DIVI.DesDiv), GN-DIVI.CodDiv).
    END.
    DISPLAY COMBO-BOX-Canal.
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
  DISPLAY RADIO-SET_Tipo FILL-IN_NroPed FILL-IN_PesoLimite FILL-IN_VolumenLimite 
          FILL-IN-Desde FILL-IN-Hasta FILL-IN_Cliente FILL-IN_ClientesLimite 
          COMBO-BOX-Canal COMBO-BOX-Zona COMBO-BOX-SubZona COMBO-BOX-Distrito 
          FILL-IN-SKU FILL-IN-Destinos FILL-IN-Volumen FILL-IN-Peso 
          FILL-IN-Documentados FILL-IN-Bultos FILL-IN-Importe FILL-IN-SKU-2 
          FILL-IN-Destinos-2 FILL-IN-Volumen-2 FILL-IN-Peso-2 
          FILL-IN-Documentados-2 FILL-IN-Bultos-2 FILL-IN-Importe-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-5 RECT-6 RECT-7 IMAGE-1 RECT-8 IMAGE-2 RECT-10 RECT-9 
         BUTTON-Refrescar BUTTON-3 BtnDone RADIO-SET_Tipo FILL-IN_NroPed 
         FILL-IN_PesoLimite BUTTON_Limpiar FILL-IN_VolumenLimite FILL-IN-Desde 
         BUTTON-1 FILL-IN-Hasta BUTTON-2 FILL-IN_Cliente FILL-IN_ClientesLimite 
         BUTTON-Limpiar-Orden COMBO-BOX-Canal COMBO-BOX-Zona COMBO-BOX-SubZona 
         COMBO-BOX-Distrito BROWSE-ORIGEN BUTTON_Down_Todo BUTTON_Down_Cliente 
         BUTTON_Down_Selectivo BUTTON_Up_Todo BUTTON_Up_Cliente 
         BUTTON_Up_Selectivo BROWSE-DESTINO BUTTON-Generar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Estado W-Win 
PROCEDURE Estado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF OUTPUT PARAMETER pEstado AS CHAR.

pEstado = 'Aprobado'.
CASE pCodDoc:
    WHEN "O/D" OR WHEN "O/M" OR WHEN "OTR" THEN DO:
        IF CPEDI.usrImpOD > '' THEN pEstado = 'Impreso'.
        IF CPEDI.FlgSit = "P" THEN pEstado = "Picking Terminado".
        IF CPEDI.FlgSit = "C" THEN pEstado = "Checking Terminado".
        IF CPEDI.FlgEst = "C" THEN pEstado = "Documentado".
    END.
END CASE.

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

DEFINE VAR x-qty AS DEC.
DEFINE VAR x-imp AS DEC.

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

DEFINE BUFFER x-faccpedi FOR faccpedi.

GET FIRST BROWSE-ORIGEN.
REPEAT WHILE AVAILABLE CPEDI:
    CREATE Detalle.
    BUFFER-COPY CPEDI TO Detalle.
    ASSIGN
        Detalle.Descripcion = VtaCTabla.Descripcion 
        Detalle.Libre_c02   = VtaDTabla.Libre_c02.
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcl = CPEDI.codcli
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN
        ASSIGN
        Detalle.Contacto = gn-clie.repleg[1]
        Detalle.Telefono = gn-clie.Telfnos[1].
    FIND gn-ven WHERE gn-ven.CodCia = s-codcia
        AND gn-ven.CodVen = CPEDI.codven
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN
        ASSIGN
        Detalle.codven = gn-ven.codven
        Detalle.nomven = gn-ven.NomVen.

    /* Ic - 22Ene2018, Fernan Oblitas, Autorizacion Harold Segura */
    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                                x-faccpedi.coddoc = detalle.coddoc AND  /* O/D, O/M, OTR */
                                x-faccpedi.nroped = detalle.nroped NO-LOCK NO-ERROR.
    IF AVAILABLE x-faccpedi THEN DO:
        ASSIGN detalle.tobserva = x-faccpedi.glosa.
        /* Buscar la guia de remision (las g/r emitidas por el pedido) */
        GuiaDeLaOrden:
        FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                                ccbcdocu.codped = x-faccpedi.codref AND 
                                ccbcdocu.nroped = x-faccpedi.nroref NO-LOCK:
            /* G/R del Pedido, de la Orden */
            IF ccbcdocu.coddoc = 'G/R' AND 
                ccbcdocu.libre_c01 = detalle.coddoc AND 
                ccbcdocu.libre_c02 = detalle.nroped THEN DO:                
                /* Buscamos si tiene H/R */
                FOR EACH di-rutaD USE-INDEX llave02 WHERE di-rutaD.codcia = s-codcia AND 
                                            di-rutaD.coddoc = 'h/r' AND
                                            di-rutaD.codref = ccbcdocu.coddoc AND 
                                            di-rutaD.nroref = ccbcdocu.nrodoc NO-LOCK  
                                            BY di-rutaD.nrodoc DESC:                      
                    FIND FIRST di-rutaC OF di-rutaD WHERE di-rutaC.flgest <> 'A' NO-LOCK NO-ERROR.
                    IF AVAILABLE di-rutaC THEN DO:
                        ASSIGN 
                            /*detalle.libre_c01 = "EN HOJA DE RUTA"*/
                            detalle.tnrohruta = di-rutaD.nrodoc
                            detalle.tfchsal = di-rutac.fchsal.
                       IF di-rutaC.flgest = 'C' THEN DO:
                           /* Esta CERRADA */
                           ASSIGN detalle.libre_c01 = "HOJA DE RUTA CERRADA".
                           /* Verificar si tiene devoluciones */
                           IF di-rutaD.flgest = 'P' OR di-rutaD.flgest = 'E' THEN detalle.tsituacion = "POR ENTREGAR".
                           IF di-rutaD.flgest = 'C' THEN detalle.tsituacion = "ENTREGADO".
                           IF di-rutaD.flgest = 'D' THEN detalle.tsituacion = "DEVOLUCION PARCIAL".
                           IF di-rutaD.flgest = 'X' THEN detalle.tsituacion = "DEVOLUCION TOTAL".
                           IF di-rutaD.flgest = 'N' THEN detalle.tsituacion = "NO ENTREGADO".
                           IF di-rutaD.flgest = 'R' THEN detalle.tsituacion = "ERROR DE DOCUMENTO".
                           IF di-rutaD.flgest = 'NR' THEN detalle.tsituacion = "NO RECIBIDO".

                            x-qty = 0.
                            x-imp = 0.
                           FOR EACH di-rutaDv OF di-rutaC NO-LOCK WHERE di-rutaDv.codref = di-rutaD.codref AND 
                                                                        di-rutaDv.nroref = di-rutaD.nroref :
                                x-qty = x-qty + di-rutaDv.candes.
                                x-imp = x-imp + di-rutaDV.implin.
                           END.
                           /* Motivo de devolucion */
                           FIND FIRST almtabla WHERE almtabla.tabla = 'HR' AND 
                                                        almtabla.codigo = di-rutaD.FlgEstDet AND
                                                        almtabla.nomant = 'N' NO-LOCK NO-ERROR.

                           ASSIGN detalle.tmotdevol = di-rutaD.FlgEstDet + " " + IF(AVAILABLE almtabla) THEN almtabla.nombre ELSE ""
                                detalle.tqty = x-qty
                                detalle.timpte = x-imp.

                       END.
                       LEAVE GuiaDeLaOrden.
                    END.
                END.
            END.
        END.
        /* LAS OTR */
        FOR EACH almcmov USE-INDEX almc07 WHERE almcmov.codcia = s-codcia AND 
                                almcmov.codref = detalle.coddoc AND
                                almcmov.nroref = detalle.nroped AND
                                almcmov.flgest <> 'A' NO-LOCK:
            FIND FIRST di-rutaG USE-INDEX llave02 WHERE di-rutaG.codcia = s-codcia AND 
                                        di-rutaG.coddoc = 'H/R' AND 
                                        di-rutaG.codalm = almcmov.codalm AND 
                                        di-rutaG.tipmov = almcmov.tipmov AND
                                        di-rutaG.codmov = almcmov.codmov AND 
                                        di-rutaG.serref = almcmov.nroser AND
                                        di-rutaG.nroref = almcmov.nrodoc NO-LOCK NO-ERROR.
            
            IF AVAILABLE di-rutaG THEN DO:
                FIND FIRST di-rutaC OF di-rutaG WHERE di-rutaC.flgest <> 'A' NO-LOCK NO-ERROR.
                IF AVAILABLE di-rutaC THEN DO:
                    ASSIGN 
                        /*detalle.libre_c01 = "EN HOJA DE RUTA"*/
                        detalle.tnrohruta = di-rutaG.nrodoc
                        detalle.tfchsal = di-rutac.fchsal.
                    IF di-rutaC.flgest = 'C' THEN DO:
                        /* Esta CERRADA */
                        /*ASSIGN detalle.libre_c01 = "HOJA DE RUTA CERRADA".*/
                        /* Verificar si tiene devoluciones */
                        IF di-rutaG.flgest = 'P' OR di-rutaG.flgest = 'E' THEN detalle.tsituacion = "POR ENTREGAR".
                        IF di-rutaG.flgest = 'C' THEN detalle.tsituacion = "ENTREGADO".
                        IF di-rutaG.flgest = 'D' THEN detalle.tsituacion = "DEVOLUCION PARCIAL".
                        IF di-rutaG.flgest = 'X' THEN detalle.tsituacion = "DEVOLUCION TOTAL".
                        IF di-rutaG.flgest = 'N' THEN detalle.tsituacion = "NO ENTREGADO".
                        IF di-rutaG.flgest = 'R' THEN detalle.tsituacion = "ERROR DE DOCUMENTO".
                        IF di-rutaG.flgest = 'NR' THEN detalle.tsituacion = "NO RECIBIDO".

                    END.
                END.
            END.
        END.
    END.        

    GET NEXT BROWSE-ORIGEN.
END.

RELEASE x-faccpedi.

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

/* ********************************************************************* */
/* RHC 30/10/18 Verificamos que todas las OTR de una R/A estén en la PHR */
/* ********************************************************************* */
/* EMPTY TEMP-TABLE T-CREPO.                                                                   */
/* FOR EACH T-RUTAD NO-LOCK WHERE T-RUTAD.CodDoc = "OTR",                                      */
/*     FIRST Faccpedi NO-LOCK WHERE FacCPedi.CodCia = s-CodCia AND                             */
/*         FacCPedi.CodDoc = T-RUTAD.CodDoc AND                                                */
/*         FacCPedi.NroPed = T-RUTAD.NroPed AND                                                */
/*         Faccpedi.DivDes = s-CodDiv,                                                         */
/*     FIRST Almcrepo NO-LOCK WHERE almcrepo.CodCia = s-CodCia AND                             */
/*         almcrepo.CodAlm = Faccpedi.CodCli AND                                               */
/*         LOOKUP(almcrepo.TipMov, "M,A") > 0 AND                                              */
/*         almcrepo.NroSer = INTEGER(SUBSTRING(FacCPedi.NroRef,1,3)) AND                       */
/*         almcrepo.NroDoc = INTEGER(SUBSTRING(FacCPedi.NroRef,4)):                            */
/*     FIND FIRST T-CREPO WHERE T-CREPO.codcia = s-CodCia AND                                  */
/*         T-CREPO.nroser = Almcrepo.nroser AND                                                */
/*         T-CREPO.nrodoc = Almcrepo.nrodoc                                                    */
/*         NO-LOCK NO-ERROR.                                                                   */
/*     IF NOT AVAILABLE T-CREPO THEN DO:                                                       */
/*         CREATE T-CREPO.                                                                     */
/*         BUFFER-COPY Almcrepo TO T-CREPO.                                                    */
/*     END.                                                                                    */
/* END.                                                                                        */
/* FOR EACH T-CREPO NO-LOCK,                                                                   */
/*     EACH FacCPedi NO-LOCK WHERE FacCPedi.CodCia = s-CodCia AND                              */
/*         FacCPedi.CodDoc = "OTR" AND                                                         */
/*         FacCPedi.CodRef = "R/A" AND                                                         */
/*         FacCPedi.NroRef = STRING(T-CREPO.NroSer, '999') + STRING(T-CREPO.NroDoc, '999999'): */
/*     IF NOT CAN-FIND(FIRST T-RUTAD WHERE T-RUTAD.CodDoc = Faccpedi.CodDoc AND                */
/*                     T-RUTAD.NroPed = Faccpedi.NroPed NO-LOCK)                               */
/*         THEN DO:                                                                            */
/*         MESSAGE 'Falta la' Faccpedi.CodDoc Faccpedi.NroPed 'de la R/A' FacCPedi.NroRef      */
/*             VIEW-AS ALERT-BOX ERROR.                                                        */
/*         RETURN.                                                                             */
/*     END.                                                                                    */
/* END.                                                                                        */

/* ********************************************************************* */
/* ********************************************************************* */

IF NOT CAN-FIND(FIRST Faccorre WHERE FacCorre.CodCia = s-codcia 
                AND FacCorre.CodDiv = s-coddiv 
                AND FacCorre.CodDoc = s-coddoc 
                AND FacCorre.FlgEst = YES
                NO-LOCK) THEN DO:
    MESSAGE 'NO definido el correlativo para el documento:' s-coddoc VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
/* Glosa */
DEF VAR lError AS LOG NO-UNDO.
DEF VAR pGlosa AS CHAR NO-UNDO.
RUN dist/d-mot-anu-hr (
    'MOTIVO DE ANULACION DE LA HOJA DE RUTA',
    OUTPUT pGlosa,
    OUTPUT lError).
IF lError = YES THEN RETURN.

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
        DI-RutaC.Observ = pGlosa
        DI-RutaC.usuario = s-user-id
        DI-RutaC.flgest  = "P".     /* Pendiente */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* Datos de Topes Máximos */
    ASSIGN
        DI-RutaC.Libre_d01 = FILL-IN_ClientesLimite 
        DI-RutaC.Libre_d02 = FILL-IN_PesoLimite 
        DI-RutaC.Libre_d03 = FILL-IN_VolumenLimite.
    ASSIGN
        DI-RutaC.Libre_f01 = FILL-IN-Desde 
        DI-RutaC.Libre_f02 = FILL-IN-Hasta
        DI-RutaC.Libre_c01 = RADIO-SET_Tipo
        DI-RutaC.Libre_c02 = FILL-IN_NroPed 
        DI-RutaC.Libre_c03 = FILL-IN_Cliente.
    /* ********************** */
    pError = DI-RutaC.CodDoc + ' ' + DI-RutaC.NroDoc.
    FOR EACH T-RUTAD:
        RUN Genera-Ventas.
        DELETE T-RUTAD.
    END.
END.
IF AVAILABLE FacCorre THEN RELEASE FacCorre.
IF AVAILABLE DI-RutaC THEN RELEASE DI-RutaC.
IF pError <> 'ERROR' THEN MESSAGE 'Se generó el documento:' pError VIEW-AS ALERT-BOX INFORMATION.

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
    DI-RutaD.NroRef = T-RUTAD.NroPed.
ASSIGN
    DI-RutaD.ImpCob    = T-RUTAD.ImpTot
    DI-RutaD.Libre_d01 = T-RUTAD.Peso
    DI-RutaD.Libre_d02 = T-RUTAD.Volumen
    DI-RutaD.Libre_c01 = STRING(T-RUTAD.Bultos).
RELEASE Di-RutaD.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpiar-Filtros W-Win 
PROCEDURE Limpiar-Filtros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE CPEDI.
/*EMPTY TEMP-TABLE T-RUTAD.*/

ASSIGN
    COMBO-BOX-Canal = 'Todos'
    COMBO-BOX-Distrito = 'Todos'
    COMBO-BOX-SubZona = 'Todos'
    COMBO-BOX-Zona = 'Todos'
    FILL-IN_Cliente = ''
    FILL-IN-Desde = TODAY - 10
    FILL-IN-Hasta = TODAY + 1
    FILL-IN_NroPed = ''
    .
DISPLAY COMBO-BOX-Canal COMBO-BOX-Distrito COMBO-BOX-SubZona COMBO-BOX-Zona 
    FILL-IN_Cliente FILL-IN-Desde FILL-IN-Hasta FILL-IN_NroPed 
    WITH FRAME {&FRAME-NAME}.

{&OPEN-QUERY-BROWSE-ORIGEN}
/*{&OPEN-QUERY-BROWSE-DESTINO}*/
RUN Totales.

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
  FILL-IN-Desde = TODAY - 10.
  FILL-IN-Hasta = TODAY + 1.
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH VtaCTabla NO-LOCK WHERE VtaCTabla.CodCia = s-codcia
          AND VtaCTabla.Tabla = "ZGHR":
          COMBO-BOX-Zona:ADD-LAST(VtaCTabla.Descripcion, VtaCTabla.Llave).
      END.
/*       FOR EACH GN-DIVI NO-LOCK WHERE GN-DIVI.CodCia = s-codcia            */
/*           AND GN-DIVI.Campo-Log[1] = NO                                   */
/*           AND GN-DIVI.Campo-Char[1] <> "L":                               */
/*           COMBO-BOX-Canal:ADD-LAST(CAPS(GN-DIVI.DesDiv), GN-DIVI.CodDiv). */
/*       END.                                                                */
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/*
  DO WITH FRAME {&FRAME-NAME}:
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
*/

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
DEF BUFFER B-RutaC FOR Di-RutaC.
DEF BUFFER B-RUTAD FOR Di-RutaD.
DEF BUFFER x-FacCPedi FOR FacCPedi.
EMPTY TEMP-TABLE CPEDI.
RLOOP:
FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
    AND LOOKUP(Faccpedi.coddoc , "O/D,O/M,OTR") > 0
    AND Faccpedi.divdes = s-coddiv
    AND (FILL-IN-Desde = ? OR Faccpedi.fchent >= FILL-IN-Desde)
    AND (FILL-IN-Hasta = ? OR Faccpedi.fchent <= FILL-IN-Hasta)
    AND LOOKUP(Faccpedi.FlgEst, 'P,C') > 0,     /* PENDIENTES o CERRADOS */
    FIRST GN-DIVI NO-LOCK WHERE GN-DIVI.CodCia = s-codcia 
    AND GN-DIVI.CodDiv = Faccpedi.CodDiv
    AND GN-DIVI.Campo-Log[1] = NO
    AND GN-DIVI.Campo-Char[1] <> "L":
    IF FILL-IN_Cliente > '' AND Faccpedi.codcli <> FILL-IN_Cliente THEN NEXT.
    IF FILL-IN_NroPed > ''  AND Faccpedi.nroped <> FILL-IN_NroPed  THEN NEXT.
    IF RADIO-SET_Tipo = "Recoge" AND Faccpedi.TipVta <> 'Si'       THEN NEXT.

    RUN Consistencia.
    IF RETURN-VALUE = 'ADM-ERROR' THEN NEXT.

    CREATE CPEDI.
    BUFFER-COPY Faccpedi TO CPEDI.
    /* Pesos y Volumenes */
    ASSIGN
        x-Pesos = 0
        x-Volumen = 0.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK, FIRST Almmmatg OF Facdpedi NO-LOCK:
        IF almmmatg.libre_d02 <> ? THEN x-Volumen = x-Volumen + (Facdpedi.canped * Facdpedi.Factor * (Almmmatg.libre_d02 / 1000000)).
        x-Pesos = x-Pesos + (Facdpedi.canped * Facdpedi.factor * almmmatg.pesmat).
    END.
    ASSIGN
        CPEDI.Peso    = x-Pesos         /* Peso en Kg */
        CPEDI.Volumen = x-Volumen       /* Volumen en m3 */
        CPEDI.ImpTot  = (IF Faccpedi.codmon = 2 THEN Faccpedi.TpoCmb * Faccpedi.ImpTot ELSE Faccpedi.ImpTot).
    IF CPEDI.Peso = ? THEN CPEDI.Peso = 0.
    IF CPEDI.Volumen = ? THEN CPEDI.Volumen = 0.
    /* RHC 09/10/17 Importes para OTR igual al de la impresión de H/R */
    IF Faccpedi.CodDoc = "OTR" THEN DO:
        ASSIGN
            CPEDI.ImpTot = 0.
        FOR EACH Facdpedi OF Faccpedi NO-LOCK:
            FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia 
                AND AlmStkGe.codmat = Facdpedi.codmat 
                AND AlmStkGe.fecha <= TODAY NO-LOCK NO-ERROR.
            CPEDI.ImpTot = CPEDI.ImpTot + (IF AVAILABLE AlmStkGe THEN 
                AlmStkGe.CtoUni * Facdpedi.canped * Facdpedi.factor
                ELSE 0).
        END.
    END.
    FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
        x-faccpedi.coddoc = CPEDI.coddoc AND  /* O/D, O/M, OTR */
        x-faccpedi.nroped = CPEDI.nroped NO-LOCK NO-ERROR.
    IF AVAILABLE x-faccpedi THEN ASSIGN CPEDI.observa = x-faccpedi.glosa.

END.

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
  {src/adm/template/snd-list.i "CPEDI"}
  {src/adm/template/snd-list.i "VtaCTabla"}
  {src/adm/template/snd-list.i "VtaDTabla"}
  {src/adm/template/snd-list.i "T-RUTAD"}

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

DEF VAR x-Documentados AS INT NO-UNDO.
DEF VAR x-Documentados-2 AS INT NO-UNDO.
DEF VAR x-Total AS INT NO-UNDO.
DEF VAR x-Total-2 AS INT NO-UNDO.

    ASSIGN
        FILL-IN-Peso = 0
        FILL-IN-Volumen = 0
        FILL-IN-Importe = 0
        FILL-IN-Bultos = 0
        FILL-IN-Destinos = 0
        x-Documentados = 0
        FILL-IN-Documentados = ''
        FILL-IN-SKU = 0.
    ASSIGN
        FILL-IN-Peso-2 = 0
        FILL-IN-Volumen-2 = 0
        FILL-IN-Importe-2 = 0
        FILL-IN-Bultos-2 = 0
        FILL-IN-Destinos-2 = 0
        x-Documentados-2 = 0
        FILL-IN-Documentados-2 = ''
        FILL-IN-SKU-2 = 0.

    FOR EACH CPEDI NO-LOCK WHERE {&Condicion}:
        ASSIGN
            FILL-IN-Peso = FILL-IN-Peso + CPEDI.Peso
            FILL-IN-Volumen = FILL-IN-Volumen + CPEDI.Volumen
            FILL-IN-Importe = FILL-IN-Importe + CPEDI.ImpTot
            FILL-IN-Bultos = FILL-IN-Bultos + CPEDI.Bultos.
        x-Total = x-Total + 1.
        IF CPEDI.Libre_d01 > 0 THEN x-Documentados = x-Documentados + 1.
    END.
    FOR EACH CPEDI NO-LOCK WHERE {&Condicion}, 
        EACH Facdpedi OF CPEDI NO-LOCK:
        FILL-IN-SKU = FILL-IN-SKU + 1.
    END.
    FOR EACH CPEDI NO-LOCK WHERE {&Condicon} BREAK BY CPEDI.CodCli:
        IF FIRST-OF(CPEDI.CodCli) THEN FILL-IN-Destinos = FILL-IN-Destinos + 1.
    END.
    DISPLAY FILL-IN-Peso
        FILL-IN-Volumen
        FILL-IN-Importe
        FILL-IN-Bultos
        FILL-IN-Destinos
        STRING(x-Documentados) + '/' + STRING(x-Total) @ FILL-IN-Documentados
        FILL-IN-SKU
        WITH FRAME {&FRAME-NAME}.

    FOR EACH T-RUTAD NO-LOCK:
        ASSIGN
            FILL-IN-Peso-2 = FILL-IN-Peso-2 + T-RUTAD.Peso
            FILL-IN-Volumen-2 = FILL-IN-Volumen-2 + T-RUTAD.Volumen
            FILL-IN-Importe-2 = FILL-IN-Importe-2 + T-RUTAD.ImpTot
            FILL-IN-Bultos-2 = FILL-IN-Bultos-2 + T-RUTAD.Bultos.
        x-Total-2 = x-Total-2 + 1.
        IF T-RUTAD.Libre_d01 > 0 THEN x-Documentados-2 = x-Documentados-2 + 1.
    END.
    FOR EACH T-RUTAD NO-LOCK, EACH Facdpedi OF T-RUTAD NO-LOCK:
        FILL-IN-SKU-2 = FILL-IN-SKU-2 + 1.
    END.
    FOR EACH T-RUTAD NO-LOCK BREAK BY T-RUTAD.CodCli:
        IF FIRST-OF(T-RUTAD.CodCli) THEN FILL-IN-Destinos-2 = FILL-IN-Destinos-2 + 1.
    END.
    DISPLAY FILL-IN-Peso-2 
        FILL-IN-Volumen-2 
        FILL-IN-Importe-2 
        FILL-IN-Bultos-2 
        FILL-IN-Destinos-2 
        STRING(x-Documentados-2) + '/' + STRING(x-Total-2) @ FILL-IN-Documentados-2
        FILL-IN-SKU-2
        WITH FRAME {&FRAME-NAME}.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

