&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
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

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INT.

DEFINE VAR x-col-estado AS CHAR.
DEFINE VAR x-msg-status AS CHAR.

DEFINE TEMP-TABLE ttCotizacionDtl
    FIELD   tNroPed     AS  CHAR    FORMAT  'X(15)'
    FIELD   tItem       AS  INT     FORMAT  '>>,>>>,>>9'
    FIELD   tCodmat     AS  CHAR    FORMAT  'x(8)'
    FIELD   tCaso       AS  CHAR    FORMAT 'x(1)'
    FIELD   tcanped     AS  DEC     FORMAT '->>,>>>,>>9.99' INIT 0
    FIELD   tcanate     AS  DEC     FORMAT '->>,>>>,>>9.99' INIT 0
    FIELD   tPesMat     AS  DEC     FORMAT '->>,>>>,>>9.9999' INIT 0
    FIELD   tFactor     AS  DEC     FORMAT '->>,>>>,>>9.9999' INIT 0
    FIELD   tPesTot     AS  DEC     FORMAT '->>,>>>,>>9.9999' INIT 0
    FIELD   tpreuni     AS  DEC     FORMAT '->>,>>>,>>9.9999' INIT 0    
    FIELD   tCoddiv     AS  CHAR    FORMAT 'x(8)'
    INDEX idx01 IS PRIMARY tnroped tcodmat
    INDEX idx02 tcaso tnroped tcodmat
    .

DEFINE TEMP-TABLE ttCotizacionHdr
    FIELD   tNroPed     AS  CHAR    FORMAT  'X(15)'     COLUMN-LABEL "Nro.PCO"
    INDEX idx01 IS PRIMARY tnroped
    .

DEFINE TEMP-TABLE ttCotizacionDtlTrabajadas
    FIELD   tNroPed     AS  CHAR    FORMAT  'X(15)'     COLUMN-LABEL "Nro.PCO"
    FIELD   tCoddiv     AS  CHAR    FORMAT 'x(8)' INIT "" COLUMN-LABEL "Division"
    FIELD   tlista      AS  CHAR    FORMAT 'x(8)' INIT "" COLUMN-LABEL "Lista de Precio"
    FIELD   tfchpco     AS  DATE    COLUMN-LABEL "Fecha Emision PCO"
    FIELD   tfchent     AS  DATE    COLUMN-LABEL "Fecha Entrega PCO"
    FIELD   tfchaba     AS  DATE    COLUMN-LABEL "Fecha abastecimiento PCO"
    FIELD   tfchtope    AS  DATE    COLUMN-LABEL "Fecha Tope PCO"
    FIELD   trazonsoc   AS  CHAR    FORMAT 'X(80)'  COLUMN-LABEL "Razon Social Cliente"
    FIELD   timptot     AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Importe Total con IGV"
    FIELD   tpestot     AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Peso Total"
    FIELD   tvendedor   AS  CHAR     FORMAT 'x(50)' COLUMN-LABEL "Vendedor"
    FIELD   tubigeo     AS  CHAR     FORMAT 'x(50)' COLUMN-LABEL "Ubigeo"
    FIELD   tCodmat     AS  CHAR    FORMAT  'x(8)'      COLUMN-LABEL "Cod.Articulo"
    FIELD   tdesmat     LIKE almmmatg.desmat    COLUMN-LABEL "Descripcion Articulo"
    FIELD   tdesmar     LIKE almmmatg.desmar    COLUMN-LABEL "Marca"
    FIELD   tundvta     LIKE almmmatg.CHR__01   COLUMN-LABEL "Und.Vta"
    FIELD   tcostrep    LIKE almmmatg.ctotot    COLUMN-LABEL "Costo Reposicion"
    FIELD   tqmaster    LIKE almmmatg.canemp    COLUMN-LABEL "Master"
    FIELD   tqinner     LIKE almmmatg.stkrep    COLUMN-LABEL "Inner"
    FIELD   tCaso       AS  CHAR    FORMAT 'x(1)'       COLUMN-LABEL "Caso"
    FIELD   tcodalm     AS  CHAR    FORMAT  'x(6)'      COLUMN-LABEL "Almacen"
    FIELD   tcanped     AS  DEC     FORMAT '->>,>>>,>>9.99' INIT 0  COLUMN-LABEL "Cantidad"
    FIELD   tpesmat     AS  DEC     FORMAT '->>,>>>,>>9.9999' INIT 0 COLUMN-LABEL "Peso x Uni"    
    FIELD   tstkconti     AS  DEC FORMAT '->>,>>>,>>9.99' INIT 0 COLUMN-LABEL "Stock Conti"    
    FIELD   tstkcissac     AS  DEC FORMAT '->>,>>>,>>9.99' INIT 0 COLUMN-LABEL "Stock Cissac"
    FIELD   tstkconti1     AS  DEC FORMAT '->>,>>>,>>9.99' INIT 0 COLUMN-LABEL "Stock Conti Final"
    FIELD   tstkcissac1     AS  DEC FORMAT '->>,>>>,>>9.99' INIT 0 COLUMN-LABEL "Stock Cissac Final"
    FIELD   tstkautconti     AS  DEC FORMAT '->>,>>>,>>9.99' INIT 0 COLUMN-LABEL "Stock Autorizado"
    FIELD   tstkcmpcissac1     AS  DEC FORMAT '->>,>>>,>>9.99' INIT 0 COLUMN-LABEL "Compra Cissac"
    FIELD   tsecuencia  AS  INT     FORMAT '>>>,>>>,>>9'    INIT 0 COLUMN-LABEL "Correlativo"
    FIELD   tfactor     AS  DEC     FORMAT '->>,>>>,>>9.9999' INIT 0 COLUMN-LABEL "Factor"
    FIELD   tpreuni     AS  DEC     FORMAT '->>,>>>,>>9.9999' INIT 0 COLUMN-LABEL "Precio Unitario"    
    
    INDEX idx01 tcodalm tcodmat tsecuencia
    .

DEFINE TEMP-TABLE ttCotizacionCaso
    FIELD   tCaso       AS  CHAR    FORMAT 'x(1)'
    FIELD   tcanped     AS  DEC     FORMAT '->>,>>>,>>9.99' INIT 0
    FIELD   tcanate     AS  DEC     FORMAT '->>,>>>,>>9.99' INIT 0
    FIELD   tPesTot     AS  DEC     FORMAT '->>,>>>,>>9.9999' INIT 0
    INDEX idx01 IS PRIMARY tCaso
    .

/* Para los SALDOS */
DEFINE TEMP-TABLE ttSaldos
    FIELD   tcodmat     AS  CHAR
    FIELD   tcodalm     AS  CHAR
    FIELD   tstkact     AS  DEC INIT 0
    FIELD   tstkconti     AS  DEC INIT 0
    FIELD   tstkcissac     AS  DEC INIT 0
    FIELD   tstkuso     AS  DEC INIT 0
    INDEX idx01 IS PRIMARY tcodmat tcodalm
    .

DEFINE TEMP-TABLE x-ttCotizacionDtl LIKE ttCotizacionDtl.
DEFINE TEMP-TABLE ttVtaddocu LIKE Vtaddocu.

/* Se usa en Stock en Transito, nose para que? */
DEFINE TEMP-TABLE tmp-tabla
    FIELD t-CodAlm LIKE Almacen.codalm  FORMAT 'x(3)'
    FIELD t-CodDoc LIKE FacDPedi.CodDoc FORMAT "XXX"
    FIELD t-Nroped LIKE FacDPedi.NroPed FORMAT "XXX-XXXXXXXX"
    FIELD t-CodDiv LIKE FacCPedi.CodDiv FORMAT 'x(5)'
    FIELD t-FchPed LIKE FacDPedi.FchPed
    FIELD t-NomCli LIKE FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(35)"
    FIELD t-CodMat LIKE FacDPedi.codmat
    FIELD t-Canped LIKE FacDPedi.CanPed.

DEFINE VAR x-secuencia AS INT INIT 0.
DEFINE VAR x-nro-coddoc AS CHAR.
DEFINE VAR x-nro-nroped AS CHAR.
DEFINE VAR x-solo-pruebas AS LOG.

DEFINE VAR x-url-stock-cissac AS CHAR.

DEFINE TEMP-TABLE ttCotizacionBorrar
    FIELD   tcodalm     AS  CHAR    FORMAT  'X(15)'
    FIELD   tCodmat     AS  CHAR    FORMAT  'x(8)'
    FIELD   tStock      AS  DEC     FORMAT '->>,>>>,>>9.9999' INIT 0
    FIELDS  tmsg        AS CHAR FORMAT 'x(254)'.


x-solo-pruebas = YES.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-4

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES FacCPedi

/* Definitions for BROWSE BROWSE-4                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-4 ~
estado(faccpedi.flgest) @ x-col-estado FacCPedi.NroRef FacCPedi.NroPed ~
FacCPedi.CodCli FacCPedi.NomCli FacCPedi.FchEnt FacCPedi.Libre_f01 ~
FacCPedi.Libre_f02 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-4 
&Scoped-define QUERY-STRING-BROWSE-4 FOR EACH FacCPedi ~
      WHERE faccpedi.codcia = s-codcia and ~
faccpedi.coddoc = 'PCO' and ~
(faccpedi.flgest = 'G' or faccpedi.flgest = 'T') NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-4 OPEN QUERY BROWSE-4 FOR EACH FacCPedi ~
      WHERE faccpedi.codcia = s-codcia and ~
faccpedi.coddoc = 'PCO' and ~
(faccpedi.flgest = 'G' or faccpedi.flgest = 'T') NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-4 FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-4 FacCPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-4}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 FILL-IN-abastecimiento ~
TOGGLE-grabar TOGGLE-stock-cissac BROWSE-4 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS fill-in-titulo FILL-IN-abastecimiento ~
FILL-IN-fechatope TOGGLE-grabar TOGGLE-stock-cissac FILL-IN-msg ~
FILL-IN-ruta FILL-IN-cissac 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD centrar-texto W-Win 
FUNCTION centrar-texto RETURNS LOGICAL ( INPUT h AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD estado W-Win 
FUNCTION estado RETURNS CHARACTER
  ( INPUT pFlgest AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Procesar PCOs" 
     SIZE 18 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "..." 
     SIZE 3.86 BY .73
     FONT 11.

DEFINE VARIABLE FILL-IN-abastecimiento AS DATE FORMAT "99/99/9999":U 
     LABEL "Abastecimiento" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 4 FGCOLOR 15 FONT 12 NO-UNDO.

DEFINE VARIABLE FILL-IN-cissac AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 60 BY .96
     FGCOLOR 9 FONT 4 NO-UNDO.

DEFINE VARIABLE FILL-IN-fechatope AS DATE FORMAT "99/99/9999":U 
     LABEL "Tope" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     BGCOLOR 4 FGCOLOR 15 FONT 13 NO-UNDO.

DEFINE VARIABLE FILL-IN-msg AS CHARACTER FORMAT "X(180)":U 
     LABEL "Procesando..." 
     VIEW-AS FILL-IN 
     SIZE 44 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-ruta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ruta del Excel" 
     VIEW-AS FILL-IN 
     SIZE 93.72 BY 1
     BGCOLOR 15 FGCOLOR 9 FONT 0 NO-UNDO.

DEFINE VARIABLE fill-in-titulo AS CHARACTER FORMAT "X(160)":U INITIAL "Programacion de Abastecimiento" 
     VIEW-AS FILL-IN 
     SIZE 122.72 BY 1.31
     BGCOLOR 9 FGCOLOR 15 FONT 9 NO-UNDO.

DEFINE VARIABLE TOGGLE-grabar AS LOGICAL INITIAL no 
     LABEL "Grabar PCO procesadas" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .77
     BGCOLOR 15 FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE TOGGLE-stock-cissac AS LOGICAL INITIAL yes 
     LABEL "Stock Cissac" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .77
     FGCOLOR 4  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-4 FOR 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-4 W-Win _STRUCTURED
  QUERY BROWSE-4 NO-LOCK DISPLAY
      estado(faccpedi.flgest) @ x-col-estado COLUMN-LABEL "Estado" FORMAT "x(15)":U
            WIDTH 8.29 COLUMN-FONT 0
      FacCPedi.NroRef COLUMN-LABEL "Cotizacion" FORMAT "X(12)":U
            WIDTH 9.43 COLUMN-FONT 0
      FacCPedi.NroPed COLUMN-LABEL "Nro. PCO" FORMAT "X(12)":U
            COLUMN-FONT 0
      FacCPedi.CodCli COLUMN-LABEL "Cod.Clie" FORMAT "x(11)":U
            COLUMN-FONT 0
      FacCPedi.NomCli COLUMN-LABEL "Nombre Cliente" FORMAT "x(100)":U
            WIDTH 29.86 COLUMN-FONT 0
      FacCPedi.FchEnt COLUMN-LABEL "Entrega" FORMAT "99/99/9999":U
            COLUMN-BGCOLOR 11 COLUMN-FONT 0
      FacCPedi.Libre_f01 COLUMN-LABEL "Abastecimiento" FORMAT "99/99/9999":U
            COLUMN-FONT 0
      FacCPedi.Libre_f02 COLUMN-LABEL "Tope" FORMAT "99/99/9999":U
            WIDTH 22.57 COLUMN-FONT 0
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 122.86 BY 20.81 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fill-in-titulo AT ROW 1.04 COL 2.14 NO-LABEL WIDGET-ID 4
     BUTTON-1 AT ROW 2.42 COL 104 WIDGET-ID 6
     FILL-IN-abastecimiento AT ROW 2.46 COL 14.43 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-fechatope AT ROW 2.46 COL 34.86 COLON-ALIGNED WIDGET-ID 18
     TOGGLE-grabar AT ROW 2.54 COL 78 WIDGET-ID 14
     TOGGLE-stock-cissac AT ROW 2.58 COL 60.14 WIDGET-ID 20
     BROWSE-4 AT ROW 3.65 COL 2.14 WIDGET-ID 200
     FILL-IN-msg AT ROW 24.65 COL 18 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-ruta AT ROW 25.73 COL 15.29 COLON-ALIGNED WIDGET-ID 10
     BUTTON-2 AT ROW 25.92 COL 111.14 WIDGET-ID 12
     FILL-IN-cissac AT ROW 24.65 COL 63.57 COLON-ALIGNED NO-LABEL WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 125.14 BY 26.31 WIDGET-ID 100.


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
         TITLE              = "Proceso programacion de abastecimiento"
         HEIGHT             = 25.81
         WIDTH              = 126
         MAX-HEIGHT         = 39.12
         MAX-WIDTH          = 274.29
         VIRTUAL-HEIGHT     = 39.12
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
/* BROWSE-TAB BROWSE-4 TOGGLE-stock-cissac F-Main */
/* SETTINGS FOR FILL-IN FILL-IN-cissac IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-fechatope IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-msg IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ruta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fill-in-titulo IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-4
/* Query rebuild information for BROWSE BROWSE-4
     _TblList          = "INTEGRAL.FacCPedi"
     _Options          = "NO-LOCK"
     _Where[1]         = "faccpedi.codcia = s-codcia and
faccpedi.coddoc = 'PCO' and
(faccpedi.flgest = 'G' or faccpedi.flgest = 'T')"
     _FldNameList[1]   > "_<CALC>"
"estado(faccpedi.flgest) @ x-col-estado" "Estado" "x(15)" ? ? ? 0 ? ? ? no ? no no "8.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.NroRef
"FacCPedi.NroRef" "Cotizacion" ? "character" ? ? 0 ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Nro. PCO" ? "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" "Cod.Clie" ? "character" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" "Nombre Cliente" ? "character" ? ? 0 ? ? ? no ? no no "29.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacCPedi.FchEnt
"FacCPedi.FchEnt" "Entrega" ? "date" 11 ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacCPedi.Libre_f01
"FacCPedi.Libre_f01" "Abastecimiento" "99/99/9999" "date" ? ? 0 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacCPedi.Libre_f02
"FacCPedi.Libre_f02" "Tope" "99/99/9999" "date" ? ? 0 ? ? ? no ? no no "22.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-4 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Proceso programacion de abastecimiento */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Proceso programacion de abastecimiento */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Procesar PCOs */
DO:
  DEFINE BUFFER x-faccpedi FOR faccpedi.
  ASSIGN toggle-grabar FILL-in-ruta fill-in-fechatope fill-in-abastecimiento toggle-stock-cissac.
  
  FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                                x-faccpedi.coddoc = 'PCO' AND
                                x-faccpedi.flgest = 'G' NO-LOCK NO-ERROR.
  IF AVAILABLE x-faccpedi THEN DO:
      MESSAGE "Existen PCO sin autorizar, imposible Procesar!!".
      IF USERID("DICTDB") <> "ADMIN" THEN RETURN NO-APPLY.
  END.
  FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                                x-faccpedi.coddoc = 'PCO' AND
                                x-faccpedi.flgest = 'T' NO-LOCK NO-ERROR.
  IF NOT AVAILABLE x-faccpedi THEN DO:
      MESSAGE "NO existen PCOs autorizadas, imposible Procesar!!".
      RETURN NO-APPLY.
  END.
  
    IF TRUE <> (fill-in-ruta > '') THEN DO:
        MESSAGE "Ingrese la ruta donde se va a GUARDAR el Excel".
        RETURN NO-APPLY.
    END.


    IF toggle-stock-cissac = YES THEN DO:
        FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND
                                    vtatabla.tabla = 'ABASTECIMIENTO' AND
                                    vtatabla.llave_c1 = "CONFIG" NO-LOCK NO-ERROR.
        IF NOT AVAILABLE vtatabla THEN DO:
            MESSAGE "No esta configurado el URL del WebService para buscar los Stock de Cissac".
            RETURN NO-APPLY.
        END.
        x-url-stock-cissac = TRIM(vtatabla.libre_c01).
        IF TRUE <> (x-url-stock-cissac > '') THEN DO:
            MESSAGE "El URL del WebService para buscar los Stock de Cissac esta vacio".
            RETURN NO-APPLY.
        END.

    END.    

        MESSAGE 'Esta seguro de realizar el proceso?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.


  RUN procesar.

  {&OPEN-QUERY-BROWSE-4}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* ... */
DO:
        DEFINE VAR lDirectorio AS CHAR.

        lDirectorio = "".

        SYSTEM-DIALOG GET-DIR lDirectorio  
           RETURN-TO-START-DIR 
           TITLE 'Directorio Files'.
        IF lDirectorio <> "" THEN DO :
        fill-in-ruta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = lDirectorio.
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-abastecimiento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-abastecimiento W-Win
ON LEAVE OF FILL-IN-abastecimiento IN FRAME F-Main /* Abastecimiento */
DO:
  
    ASSIGN fill-in-abastecimiento.
    fill-in-fechatope:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(fill-in-abastecimiento + 6,"99/99/9999").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-4
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE articulos-xyz W-Win 
PROCEDURE articulos-xyz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pExcel AS CHAR.

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

DEFINE VAR lLinea AS INT.

lFileXls = pExcel.              /* Nombre el archivo a abrir o crear, vacio solo para nuevos */
lNuevoFile = NO.                            /* Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = NO. /* Si permanece abierto el Excel luego de concluir el proceso */

iColumn = 1.
lLinea = 1.

/* Cuantas Columnas tiene el Excel */
DEFINE VAR x-columnas-excel AS INT.
DEFINE VAR x-handle-excel AS HANDLE.
DEFINE VAR x-num-almacenes AS INT INIT 0.

DEFINE VAR x-almacen AS CHAR.
DEFINE VAR x-celda AS CHAR.
DEFINE VAR x-articulo AS CHAR.
DEFINE VAR x-stock AS DEC.
DEFINE VAR x-reservado AS DEC.

x-handle-excel = TEMP-TABLE ttCotizacionDtlTrabajadas:HANDLE.
x-columnas-excel = x-handle-excel:DEFAULT-BUFFER-HANDLE:NUM-FIELDS. 
x-num-almacenes = 0.

/* Adiciono las Columnas (almacenes) */
FOR EACH almtabla WHERE almtabla.tabla = 'ABASTECIMIENTO-XYZ' NO-LOCK.
    
    x-almacen = TRIM(almtabla.codigo).
    x-num-almacenes = x-num-almacenes + 1.
    x-celda = ENTRY(x-columnas-excel + x-num-almacenes,cColList,",").

    cColumn = "1".
    cRange = x-celda + cColumn.
    chWorkSheet:Range(cRange):VALUE = "'" + x-almacen.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.

END.

cColumn = STRING(lLinea).
REPEAT iColumn = 2 TO 65000 :
    cColumn = STRING(iColumn).

    /* El almacen esta en la Celda V y el Articulo en la M */
    /* U  tcodalm */
    /* M  tCodmat */

    cRange = "U" + cColumn.
    x-almacen = chWorkSheet:Range(cRange):TEXT.

    IF x-almacen = "" OR x-almacen = ? THEN LEAVE.    /* FIN DE DATOS */
    
    IF (x-almacen = 'XYZ') OR (x-almacen = 'ERR') THEN DO:

        cRange = "M" + cColumn.
        x-articulo = chWorkSheet:Range(cRange):TEXT.

        x-num-almacenes = 0.
        FOR EACH almtabla WHERE almtabla.tabla = 'ABASTECIMIENTO-XYZ' NO-LOCK.
            x-almacen = TRIM(almtabla.codigo).
            x-stock = 0.
            /* Stock */
            FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                                        almmmate.codmat = x-articulo AND
                                        almmmate.codalm = x-almacen NO-LOCK NO-ERROR.
            IF AVAILABLE almmmate THEN x-stock = almmmate.stkact.
            /* El Stock Comprometido */
            x-reservado = 0.
            RUN gn/Stock-Comprometido-v2 (INPUT x-articulo, INPUT x-almacen, YES, OUTPUT x-reservado).

            /* El Excel */
            x-num-almacenes = x-num-almacenes + 1.
            x-celda = ENTRY(x-columnas-excel + x-num-almacenes,cColList,",").

            cRange = x-celda + cColumn.
            chWorkSheet:Range(cRange):VALUE = x-stock - x-reservado.

        END.
    END.

END.

chWorkbook:SAVE.

{lib\excel-close-file.i}

END PROCEDURE.

/*
DEFINE TEMP-TABLE ttCotizacionDtlTrabajadas
    FIELD A  tNroPed     AS  CHAR    FORMAT  'X(15)'     COLUMN-LABEL "Nro.PCO"
    FIELD B  tCoddiv     AS  CHAR    FORMAT 'x(8)' INIT "" COLUMN-LABEL "Division"
    FIELD C  tlista      AS  CHAR    FORMAT 'x(8)' INIT "" COLUMN-LABEL "Lista de Precio"
    FIELD D  tfchpco     AS  DATE    COLUMN-LABEL "Fecha Emision PCO"
    FIELD E  tfchent     AS  DATE    COLUMN-LABEL "Fecha Entrega PCO"
    FIELD F  tfchaba     AS  DATE    COLUMN-LABEL "Fecha abastecimiento PCO"
    FIELD G  tfchtope    AS  DATE    COLUMN-LABEL "Fecha Tope PCO"
    FIELD H  trazonsoc   AS  CHAR    FORMAT 'X(80)'  COLUMN-LABEL "Razon Social Cliente"
    FIELD I  timptot     AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Importe Total con IGV"
    FIELD J  tpestot     AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Peso Total"
    FIELD K  tvendedor   AS  CHAR     FORMAT 'x(50)' COLUMN-LABEL "Vendedor"
    FIELD L  tubigeo     AS  CHAR     FORMAT 'x(50)' COLUMN-LABEL "Ubigeo"
    FIELD M  tCodmat     AS  CHAR    FORMAT  'x(8)'      COLUMN-LABEL "Cod.Articulo"
    FIELD N  tdesmat     LIKE almmmatg.desmat    COLUMN-LABEL "Descripcion Articulo"
    FIELD O  tdesmar     LIKE almmmatg.desmar    COLUMN-LABEL "Marca"
    FIELD P  tundvta     LIKE almmmatg.CHR__01   COLUMN-LABEL "Und.Vta"
    FIELD Q  tcostrep    LIKE almmmatg.ctotot    COLUMN-LABEL "Costo Reposicion"
    FIELD R  tqmaster    LIKE almmmatg.canemp    COLUMN-LABEL "Master"
    FIELD S  tqinner     LIKE almmmatg.stkrep    COLUMN-LABEL "Inner"
    FIELD T  tCaso       AS  CHAR    FORMAT 'x(1)'       COLUMN-LABEL "Caso"
    FIELD V  tcodalm     AS  CHAR    FORMAT  'x(6)'      COLUMN-LABEL "Almacen"
    FIELD W  tcanped     AS  DEC     FORMAT '->>,>>>,>>9.99' INIT 0  COLUMN-LABEL "Cantidad"
    FIELD X  tpesmat     AS  DEC     FORMAT '->>,>>>,>>9.9999' INIT 0 COLUMN-LABEL "Peso x Uni"    
    FIELD Y  tstkconti     AS  DEC FORMAT '->>,>>>,>>9.99' INIT 0 COLUMN-LABEL "Stock Conti"    
    FIELD Z  tstkcissac     AS  DEC FORMAT '->>,>>>,>>9.99' INIT 0 COLUMN-LABEL "Stock Cissac"
    FIELD AA  tstkconti1     AS  DEC FORMAT '->>,>>>,>>9.99' INIT 0 COLUMN-LABEL "Stock Conti Final"
    FIELD AB  tstkcissac1     AS  DEC FORMAT '->>,>>>,>>9.99' INIT 0 COLUMN-LABEL "Stock Cissac Final"
    FIELD AC  tstkautconti     AS  DEC FORMAT '->>,>>>,>>9.99' INIT 0 COLUMN-LABEL "Stock Autorizado"
    FIELD AD  tstkcmpcissac1     AS  DEC FORMAT '->>,>>>,>>9.99' INIT 0 COLUMN-LABEL "Compra Cissac"
    FIELD AE  tsecuencia  AS  INT     FORMAT '>>>,>>>,>>9'    INIT 0 COLUMN-LABEL "Correlativo"
    FIELD AF  tfactor     AS  DEC     FORMAT '->>,>>>,>>9.9999' INIT 0 COLUMN-LABEL "Factor"
    FIELD AG  tpreuni     AS  DEC     FORMAT '->>,>>>,>>9.9999' INIT 0 COLUMN-LABEL "Precio Unitario"    
    
    

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
  DISPLAY fill-in-titulo FILL-IN-abastecimiento FILL-IN-fechatope TOGGLE-grabar 
          TOGGLE-stock-cissac FILL-IN-msg FILL-IN-ruta FILL-IN-cissac 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 FILL-IN-abastecimiento TOGGLE-grabar TOGGLE-stock-cissac 
         BROWSE-4 BUTTON-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-data W-Win 
PROCEDURE grabar-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pProcesoOK AS LOG.

DEFINE BUFFER b-faccpedi FOR faccpedi.
DEFINE BUFFER b-facdpedi FOR facdpedi.

SESSION:SET-WAIT-STATE("GENERAL").

EMPTY TEMP-TABLE ttCotizacionHdr.

FOR EACH ttCotizacionDtlTrabajadas :
    FIND FIRST ttCotizacionHdr WHERE ttCotizacionHdr.tnroped = ttCotizacionDtlTrabajadas.tnroped EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE ttCotizacionHdr THEN DO:
        CREATE ttCotizacionHdr.
                ttCotizacionHdr.tnroped = ttCotizacionDtlTrabajadas.tnroped.
    END.
END.

DEFINE VAR x-proceso-ok AS LOG NO-UNDO.
DEFINE VAR x-nro-item AS INT NO-UNDO.

x-proceso-ok = NO.
x-nro-item = 0.

LOOPGRABAR:
DO TRANSACTION ON ERROR UNDO, LEAVE :

  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                          vtatabla.tabla = 'ABASTECIMIENTO' AND
                          vtatabla.llave_c1 = 'CONFIG' 
                          EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  IF LOCKED vtatabla THEN DO:
      UNDO LOOPGRABAR, LEAVE LOOPGRABAR.
  END.
  ELSE IF NOT AVAILABLE vtatabla THEN DO:
      CREATE vtatabla.
          ASSIGN vtatabla.codcia = s-codcia
                  vtatabla.tabla = 'ABASTECIMIENTO'
                  vtatabla.llave_c1 = 'CONFIG' NO-ERROR.
  END.
  ASSIGN vtatabla.rango_fecha[2] = fill-in-abastecimiento   /*FechaTope*/
        vtatabla.rango_fecha[1] = TODAY NO-ERROR.

  FOR EACH ttCotizacionHdr NO-LOCK ON ERROR UNDO , LEAVE LOOPGRABAR:
      FIND FIRST b-faccpedi WHERE b-faccpedi.codcia = s-codcia AND 
                                    b-faccpedi.coddoc = 'PCO' AND 
                                    b-faccpedi.nroped = ttCotizacionHdr.tnroped EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF AVAILABLE b-faccpedi THEN DO:
          ASSIGN b-faccpedi.flgest = 'P' NO-ERROR.
      END.
      ELSE DO:
          UNDO LOOPGRABAR, LEAVE LOOPGRABAR.
      END.
      FOR EACH ttCotizacionDtlTrabajadas WHERE ttCotizacionDtlTrabajadas.tnroped = ttCotizacionHdr.tnroped 
                                                    ON ERROR UNDO, THROW:
          x-nro-item = x-nro-item + 1.
        /* OrderLine update block */
        CREATE vtaddocu.
        ASSIGN  vtaddocu.codcia = s-codcia
                vtaddocu.coddiv = ttCotizacionDtlTrabajadas.tcoddiv
                vtaddocu.codped = 'PCO'
                vtaddocu.nroped = ttCotizacionDtlTrabajadas.tnroped
                vtaddocu.fchped = TODAY
                vtaddocu.codcli = b-faccpedi.codcli
                vtaddocu.almdes = IF (ttCotizacionDtlTrabajadas.tcodalm = 'XYZ' OR ttCotizacionDtlTrabajadas.tcodalm = 'ERR') THEN '11E' ELSE ttCotizacionDtlTrabajadas.tcodalm
                vtaddocu.nroitm = x-nro-item
                vtaddocu.codmat = ttCotizacionDtlTrabajadas.tcodmat
                vtaddocu.canped = ttCotizacionDtlTrabajadas.tcanped NO-ERROR
        .
        IF ERROR-STATUS:ERROR = YES THEN DO:
            UNDO LOOPGRABAR, LEAVE LOOPGRABAR.
        END.
        /* Grabar el CASO en la PCO, detalle */
        FIND FIRST b-facdpedi WHERE b-facdpedi.codcia = s-codcia AND 
                                        b-facdpedi.coddoc = 'PCO' AND
                                        b-facdpedi.nroped = ttCotizacionDtlTrabajadas.tnroped AND
                                        b-facdpedi.codmat = ttCotizacionDtlTrabajadas.tcodmat
                                        EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE b-facdpedi THEN DO:
            ASSIGN b-facdpedi.libre_c01 = ttCotizacionDtlTrabajadas.tcaso
                    b-facdpedi.libre_c02 = IF (ttCotizacionDtlTrabajadas.tcodalm = 'XYZ' OR ttCotizacionDtlTrabajadas.tcodalm = 'ERR') THEN '11E' ELSE ttCotizacionDtlTrabajadas.tcodalm
                NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
               UNDO LOOPGRABAR, LEAVE LOOPGRABAR.
            END.
        END.
      END.

  END.

  x-proceso-ok = YES.

END. /* TRANSACTION block */
RELEASE vtaddocu.
RELEASE b-facdpedi.

pProcesoOK = x-proceso-ok.

SESSION:SET-WAIT-STATE("").

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
  centrar-texto(INPUT fill-in-titulo:HANDLE IN FRAME {&FRAME-NAME}).

  FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                          vtatabla.tabla = 'ABASTECIMIENTO' AND
                          vtatabla.llave_c1 = 'CONFIG' 
                          NO-LOCK NO-ERROR.
  IF AVAILABLE vtatabla THEN DO:
        fill-in-abastecimiento:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(vtatabla.rango_fecha[2] + 1,"99/99/9999").
        fill-in-fechatope:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(vtatabla.rango_fecha[2] + 7,"99/99/9999").
  END.

  
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

DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nroped AS CHAR.
DEFINE VAR x-msg AS CHAR.
DEFINE VAR x-grabacion-ok AS LOG.

DEFINE VAR x-cotizaciones AS INT INIT 0.
DEFINE VAR x-cotizaciones-procesadas AS INT INIT 0.
DEFINE VAR x-cantidad AS DEC INIT 0.

DEFINE VAR x-tempo AS INT INIT 0.

SESSION:SET-WAIT-STATE("GENERAL").

/**/
EMPTY TEMP-TABLE ttCotizacionDtlTrabajadas.
EMPTY TEMP-TABLE ttVtaddocu.

GET FIRST browse-4.
DO WHILE AVAILABLE faccpedi:
    x-cotizaciones = x-cotizaciones + 1.
    GET NEXT BROWSE-4.
END.

x-secuencia = 0.

SESSION:SET-WAIT-STATE("GENERAL").

GET FIRST browse-4.
LOOPPCOS:
DO WHILE AVAILABLE faccpedi:
    x-coddoc = faccpedi.coddoc.
    x-nroped = faccpedi.nroped.

    /*IF (x-nroped BEGINS '015201848-1') THEN DO:*/
        x-cotizaciones-procesadas = x-cotizaciones-procesadas + 1.

        FILL-IN-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "    " + STRING(x-cotizaciones-procesadas) + " / " + STRING(x-cotizaciones).

        x-msg = "".
        RUN procesar-pco(INPUT x-coddoc, INPUT x-nroped, OUTPUT x-msg).
        /*
        x-tempo = x-tempo + 1.
        IF x-tempo >= 1000000 THEN LEAVE LOOPPCOS.
        */
    /*END.*/

    GET NEXT BROWSE-4.
END.

FILL-IN-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "    " + STRING(x-cotizaciones-procesadas) + " / " + STRING(x-cotizaciones) + " - Recalculando.".

/* Recalculamos */
DEFINE VAR x-saldo-conti AS DEC INIT 0.
DEFINE VAR x-saldo-cissac AS DEC INIT 0.

FOR EACH ttCotizacionDtlTrabajadas BREAK BY ttCotizacionDtlTrabajadas.tcodalm BY ttCotizacionDtlTrabajadas.tcodmat BY ttCotizacionDtlTrabajadas.tsecuencia :

    IF FIRST-OF(ttCotizacionDtlTrabajadas.tcodalm) OR FIRST-OF(ttCotizacionDtlTrabajadas.tcodmat) THEN DO:
        x-saldo-conti = ttCotizacionDtlTrabajadas.tStkConti.
        x-saldo-cissac = ttCotizacionDtlTrabajadas.tStkCissac.
    END.
    ELSE DO:
        ASSIGN ttCotizacionDtlTrabajadas.tStkConti = x-saldo-conti
                ttCotizacionDtlTrabajadas.tStkCissac = x-saldo-cissac.
    END.

    x-cantidad = (ttCotizacionDtlTrabajadas.tcanped * ttCotizacionDtlTrabajadas.tfactor).
    IF x-saldo-conti > 0 THEN DO:
        /* Conti */
        IF x-cantidad <= x-saldo-conti THEN DO:
            x-saldo-conti = x-saldo-conti - x-cantidad.
            x-cantidad = 0.
            ASSIGN  ttCotizacionDtlTrabajadas.tStkConti1 = x-saldo-conti.
        END.
        ELSE DO:            
            x-cantidad = x-cantidad - x-saldo-conti.
            ASSIGN  ttCotizacionDtlTrabajadas.tStkConti1 = 0.
            x-saldo-conti = 0.
        END.
    END.
    IF x-cantidad > 0 THEN DO:
        /* Cissac */
        IF x-saldo-cissac > 0 THEN DO:
            IF x-cantidad <= x-saldo-cissac THEN DO:
                x-saldo-cissac = x-saldo-cissac - x-cantidad.
                x-cantidad = 0.
                ASSIGN  ttCotizacionDtlTrabajadas.tStkCissac1 = x-saldo-cissac.
            END.
            ELSE DO:                
                x-cantidad = x-cantidad - x-saldo-cissac.
                x-saldo-cissac = 0.
                ASSIGN  ttCotizacionDtlTrabajadas.tStkCissac1 = 0.
            END.
        END.
    END.
    ELSE DO:
        ASSIGN  ttCotizacionDtlTrabajadas.tStkCissac1 = x-saldo-cissac.
    END.
    /*  */
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                almmmatg.codmat = ttCotizacionDtlTrabajadas.tcodmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN DO:

        FIND FIRST almtfam OF almmmatg NO-LOCK NO-ERROR.
        FIND FIRST almsfam OF almmmatg NO-LOCK NO-ERROR.

       ASSIGN ttCotizacionDtlTrabajadas.tdesmat = almmmatg.desmat
                ttCotizacionDtlTrabajadas.tdesmar = almmmatg.desmar
                ttCotizacionDtlTrabajadas.tundvta = almmmatg.CHR__01
                ttCotizacionDtlTrabajadas.tcostrep = almmmatg.ctotot
                ttCotizacionDtlTrabajadas.tqmaster = almmmatg.canemp
                ttCotizacionDtlTrabajadas.tqinner = almmmatg.stkrep
           .
    END.
END.

/* Datos adicionales */
DEFINE BUFFER x-faccpedi FOR faccpedi.
DEFINE BUFFER b-ttCotizacionDtlTrabajadas FOR ttCotizacionDtlTrabajadas.

DEFINE VAR x-ubigeo AS CHAR INIT "".
DEFINE VAR x-imptot AS DEC INIT 0.
DEFINE VAR x-pesotot AS DEC INIT 0.

FOR EACH ttCotizacionDtlTrabajadas BREAK BY ttCotizacionDtlTrabajadas.tnroped:
    IF FIRST-OF(ttCotizacionDtlTrabajadas.tnroped) THEN DO:
        x-imptot = 0.
        x-pesotot = 0.
        x-ubigeo = "".
        /* Header */
    END.
        FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = s-codcia AND 
                                        x-faccpedi.coddoc = 'PCO' AND 
                                        x-faccpedi.nroped = ttCotizacionDtlTrabajadas.tnroped NO-LOCK NO-ERROR.
        IF AVAILABLE x-faccpedi THEN DO:
            /* Vendedor */
            FIND FIRST gn-ven WHERE gn-ven.codcia = s-codcia AND 
                                        gn-ven.codven = x-faccpedi.codven NO-LOCK NO-ERROR.
            /* Cliente */            
            FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND 
                                    gn-clie.codcli = x-faccpedi.codcli NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN DO:
                /* Departamento */
                FIND FIRST tabdepto WHERE tabdepto.coddepto = gn-clie.coddept NO-LOCK NO-ERROR.
                IF AVAILABLE tabdepto THEN x-ubigeo = tabdepto.nomdepto.

                /* Provincia */
                FIND FIRST tabprov WHERE tabprov.coddepto = gn-clie.coddept AND 
                                        tabprov.codprov = gn-clie.codprov NO-LOCK NO-ERROR.
                IF AVAILABLE tabprov THEN x-ubigeo = TRIM(x-ubigeo) + " " + tabprov.nomprov.

                /* Distrto */
                FIND FIRST tabdist WHERE tabdist.coddepto = gn-clie.coddept AND 
                                        tabdist.codprov = gn-clie.codprov AND 
                                        tabdist.coddist = gn-clie.coddist NO-LOCK NO-ERROR.
                IF AVAILABLE tabdist THEN x-ubigeo = TRIM(x-ubigeo) + " " + tabdist.nomdist.

                x-ubigeo = TRIM(x-ubigeo).
            END.
        END.
    
    x-imptot = x-imptot + (ttCotizacionDtlTrabajadas.tcanped * ttCotizacionDtlTrabajadas.tpreuni).
    x-pesotot = x-pesotot + ((ttCotizacionDtlTrabajadas.tcanped * ttCotizacionDtlTrabajadas.tfactor) * ttCotizacionDtlTrabajadas.tpesmat).

    IF AVAILABLE x-faccpedi THEN DO:
        ASSIGN ttCotizacionDtlTrabajadas.tlista = x-faccpedi.libre_c01
                ttCotizacionDtlTrabajadas.tfchpco = x-faccpedi.fchped
                ttCotizacionDtlTrabajadas.tfchent = x-faccpedi.fchent
                ttCotizacionDtlTrabajadas.tfchaba = x-faccpedi.libre_f01
                ttCotizacionDtlTrabajadas.tfchtope = x-faccpedi.libre_f02
                ttCotizacionDtlTrabajadas.trazonsoc = x-faccpedi.nomcli
                ttCotizacionDtlTrabajadas.tvendedor = x-faccpedi.codven
                ttCotizacionDtlTrabajadas.tubigeo = x-ubigeo
        .
        IF AVAILABLE gn-ven THEN DO:
            ttCotizacionDtlTrabajadas.tvendedor = TRIM(ttCotizacionDtlTrabajadas.tvendedor) + " " +
                                    gn-ven.nomven.
        END.
    END.

    IF LAST-OF(ttCotizacionDtlTrabajadas.tnroped) THEN DO:
        FOR EACH b-ttCotizacionDtlTrabajadas WHERE b-ttCotizacionDtlTrabajadas.tnroped = ttCotizacionDtlTrabajadas.tnroped :
            ASSIGN b-ttCotizacionDtlTrabajadas.timptot = x-imptot
                    b-ttCotizacionDtlTrabajadas.tpestot = x-pesotot
                    b-ttCotizacionDtlTrabajadas.tstkautconti = b-ttCotizacionDtlTrabajadas.tstkconti - b-ttCotizacionDtlTrabajadas.tstkconti1
                    b-ttCotizacionDtlTrabajadas.tstkcmpcissac1 = b-ttCotizacionDtlTrabajadas.tstkcissac - b-ttCotizacionDtlTrabajadas.tstkcissac1
            .
        END.
    END.

END.

SESSION:SET-WAIT-STATE("").

/* Alimentamos el VTADDOCU apartir ttCotizacionDtlTrabajadas */
IF toggle-grabar = YES THEN DO:

    x-grabacion-ok = NO.
    FILL-IN-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "    " + STRING(x-cotizaciones-procesadas) + " / " + STRING(x-cotizaciones) + " - Grabando.".
    RUN grabar-data(OUTPUT x-grabacion-ok).

    IF x-grabacion-ok = NO THEN DO:
        MESSAGE "Hubo problemas al grabar, por favor intente otra vez".
    END.

END.

SESSION:SET-WAIT-STATE("GENERAL").

/* Excel */
DEFINE VAR x-ruta-excel AS CHAR.
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */


c-xls-file = fill-in-ruta + '\PCO-Procesadas.xlsx'.
x-ruta-excel = c-xls-file.

run pi-crea-archivo-csv IN hProc (input  buffer ttCotizacionDtlTrabajadas:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer ttCotizacionDtlTrabajadas:handle,
                        input  c-csv-file,
                        output c-xls-file) .

/* ----- */
/*
c-xls-file = fill-in-ruta + '\PCO-Saldos-Cissac.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer ttCotizacionBorrar:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer ttCotizacionBorrar:handle,
                        input  c-csv-file,
                        output c-xls-file) .

*/

DELETE PROCEDURE hProc.


/* Los XYZ y ERR (sus mariconadas de max el timido) */
RUN articulos-xyz(INPUT x-ruta-excel).

SESSION:SET-WAIT-STATE("").

MESSAGE "Proceso Terminado".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-pco W-Win 
PROCEDURE procesar-pco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroPed AS CHAR.
DEFINE OUTPUT PARAMETER pMsg AS CHAR.

DEFINE VAR x-cant AS DEC.
DEFINE VAR x-peso AS DEC.
DEFINE VAR x-Stk-alm AS DEC.

DEFINE VAR x-tonelada AS DEC.
DEFINE VAR x-caso AS CHAR.
DEFINE VAR x-can-pedida AS DEC.
DEFINE VAR x-peso-total-caso AS DEC.
DEFINE VAR x-peso-sobrante-caso AS DEC.
DEFINE VAR x-filer AS CHAR.

DEFINE VAR x-Stk-cissac AS DEC INIT 0.
DEFINE VAR x-Stk-conti AS DEC INIT 0.

DEFINE BUFFER x-facdpedi FOR facdpedi.

DEFINE BUFFER x-vtatabla FOR vtatabla.
DEFINE BUFFER x-ttCotizacionDtl FOR ttCotizacionDtl.

EMPTY TEMP-TABLE ttCotizacionDtl.
EMPTY TEMP-TABLE ttCotizacionCaso.

x-msg-status = FILL-IN-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

FILL-IN-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = FILL-IN-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " Ubicando el CASO".

/* Segun la Linea del Articulo en CASO se ubica */
FOR EACH x-facdpedi WHERE x-facdpedi.codcia = s-codcia AND
                            x-facdpedi.coddoc = pCodDoc AND
                            x-facdpedi.nroped = pNroPed NO-LOCK:
    x-caso = "".
    x-peso = 0.
    RUN ubicar-caso-segun-articulo(INPUT x-facdpedi.codmat, OUTPUT x-caso, OUTPUT x-peso).
    
    /* Guardo los Datos */
    CREATE ttCotizacionDtl.
    ASSIGN  tNroPed     = pNroPed
            tItem       = x-facdpedi.nroitm
            tCodMat     = x-facdpedi.codmat
            ttCotizacionDtl.tCaso       = x-caso
            ttCotizacionDtl.tCanPed     = x-facdpedi.canped
            ttCotizacionDtl.tCanAte     = 0
            ttCotizacionDtl.tPesMat     = x-peso
            ttCotizacionDtl.tfactor     = if(x-facdpedi.factor <= 0) THEN 1 ELSE x-facdpedi.factor
            ttCotizacionDtl.tPesTot     = (x-facdpedi.canped * x-facdpedi.factor) * x-peso
            ttCotizacionDtl.tcoddiv     = x-facdpedi.coddiv
            ttCotizacionDtl.tpreuni     = x-facdpedi.implin / x-facdpedi.libre_d05
    .
    FIND FIRST ttCotizacionCaso WHERE ttCotizacionCaso.tcaso = x-Caso EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE ttCotizacionCaso THEN DO:
        CREATE ttCotizacionCaso.
        ASSIGN  ttCotizacionCaso.tcaso = x-caso.
    END.
    ASSIGN ttCotizacionCaso.tCanPed     = ttCotizacionCaso.tCanPed + x-facdpedi.canped
            ttCotizacionCaso.tCanAte    = 0
            ttCotizacionCaso.tPesTot    = ttCotizacionCaso.tPesTot + ttCotizacionDtl.tPesTot.    
END.
/*
/* Excel */
DEFINE VAR x-ruta-excel AS CHAR.
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = fill-in-ruta + '\PCO-Cotizacion-caso.xlsx'.
x-ruta-excel = c-xls-file.

run pi-crea-archivo-csv IN hProc (input  buffer ttCotizacionCaso:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer ttCotizacionCaso:handle,
                        input  c-csv-file,
                        output c-xls-file) .
/*******************/

c-xls-file = fill-in-ruta + '\PCO-Cotizacion-dtl.xlsx'.
x-ruta-excel = c-xls-file.

run pi-crea-archivo-csv IN hProc (input  buffer ttCotizacionDtl:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer ttCotizacionDtl:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.
*/
/********************************************************************************/

/* Segun los casos entran a la TRAMPA (configuracion) */
FOR EACH ttCotizacionCaso:
    
    x-peso-sobrante-caso = ttCotizacionCaso.tPesTot.    

    /* Configuracion del CASO */
    FIND FIRST x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                                    x-vtatabla.tabla = 'EVENTOS' AND
                                    x-vtatabla.llave_c1 = ttCotizacionCaso.tCaso AND
                                    x-vtatabla.llave_c2 <> 'EVENTOS_DTL' NO-LOCK NO-ERROR.

    IF AVAILABLE x-vtatabla THEN DO:
        /* Almacen 3 */
        IF x-vtatabla.valor[2] > 0 AND x-vtatabla.llave_c5 <> '' THEN DO:
            IF x-peso-sobrante-caso > 0 THEN DO:
                x-peso-sobrante-caso = 0.
                RUN procesar-pco-caso(INPUT x-vtatabla.valor[2], INPUT x-vtatabla.llave_c5, 
                                      INPUT ttCotizacionCaso.tCaso, INPUT '>=', OUTPUT x-peso-sobrante-caso).
            END.
        END.
        /* Almacen 2 */
        IF x-vtatabla.valor[1] > 0 AND x-vtatabla.llave_c4 <> '' THEN DO:
            /* Si aun hay stock */
            IF x-peso-sobrante-caso > 0 THEN DO:
                x-peso-sobrante-caso = 0.
                RUN procesar-pco-caso(INPUT x-vtatabla.valor[1], INPUT x-vtatabla.llave_c4, 
                                      INPUT ttCotizacionCaso.tCaso, INPUT '>=', OUTPUT x-peso-sobrante-caso).
            END.
        END.
        /* Almacen Inicial (Default) */
        IF x-vtatabla.llave_c2 <> '' THEN DO:
            IF x-peso-sobrante-caso > 0 THEN DO:
                x-peso-sobrante-caso = 0.
                RUN procesar-pco-caso(INPUT x-vtatabla.valor[1], INPUT x-vtatabla.llave_c2, 
                                      INPUT ttCotizacionCaso.tCaso, INPUT '*', OUTPUT x-peso-sobrante-caso).       /* Pedido de Lucy Mesia 24Nov2020 - todo entra ahi */
                                      /*INPUT ttCotizacionCaso.tCaso, INPUT '<=', OUTPUT x-peso-sobrante-caso).*/   
            END.
        END.
    END.
    /* Aun quedan articulos para programar */
    IF x-peso-sobrante-caso > 0 THEN DO:
        FOR EACH ttCotizacionDtl WHERE (ttCotizacionDtl.tcaso = ttCotizacionCaso.tCaso) AND (ttCotizacionDtl.tcanped - ttCotizacionDtl.tcanate) > 0 NO-LOCK:

            /* 
                ERR : No esta definido en la tabla configuracion 
                XYZ : No tiene almacen inicial (default)
            */
            x-Stk-cissac = 0.
            x-Stk-conti = 0.
            x-filer = "ERR".
            IF AVAILABLE x-vtatabla THEN DO:
                x-filer = "XYZ".
                /*x-filer = IF(x-vtatabla.llave_c2 <> '') THEN x-vtatabla.llave_c2 ELSE "XYZ".*/
            END.            

            RUN rebajar-el-stock(INPUT ttCotizacionDtl.tcodmat, INPUT x-filer,  INPUT 0, OUTPUT x-Stk-conti, OUTPUT x-Stk-cissac).

            x-secuencia = x-secuencia + 1.
            CREATE ttCotizacionDtlTrabajadas.
                ASSIGN  ttCotizacionDtlTrabajadas.tnroped = ttCotizacionDtl.tnroped
                            ttCotizacionDtlTrabajadas.tcodmat = ttCotizacionDtl.tcodmat
                            ttCotizacionDtlTrabajadas.tcaso = ttCotizacionDtl.tcaso
                            ttCotizacionDtlTrabajadas.tcodalm = x-filer
                            ttCotizacionDtlTrabajadas.tcanped = (ttCotizacionDtl.tcanped - ttCotizacionDtl.tcanate)
                            ttCotizacionDtlTrabajadas.tpesmat = ttCotizacionDtl.tpesmat
                            ttCotizacionDtlTrabajadas.tfactor = ttCotizacionDtl.tfactor
                            ttCotizacionDtlTrabajadas.tStkConti = x-Stk-conti
                            ttCotizacionDtlTrabajadas.tStkCissac = x-Stk-cissac
                            ttCotizacionDtlTrabajadas.tsecuencia = x-secuencia
                            ttCotizacionDtlTrabajadas.tcoddiv = ttCotizacionDtl.tcoddiv
                            ttCotizacionDtlTrabajadas.tpreuni = ttCotizacionDtl.tpreuni
                            .
        END.
    END.
END.


/*  */
/*
DEFINE VAR hProc AS HANDLE.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. 
DEFINE VAR x-ruta-excel AS CHAR.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

c-xls-file = fill-in-ruta + '\PCO-ttCotizacionDtlTrabajadas.xlsx'.
x-ruta-excel = c-xls-file.

run pi-crea-archivo-csv IN hProc (input  buffer ttCotizacionDtlTrabajadas:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer ttCotizacionDtlTrabajadas:handle,
                        input  c-csv-file,
                        output c-xls-file) .

/**/

c-xls-file = fill-in-ruta + '\PCO-ttCotizacionDtl.xlsx'.
x-ruta-excel = c-xls-file.

run pi-crea-archivo-csv IN hProc (input  buffer ttCotizacionDtl:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer ttCotizacionDtl:handle,
                        input  c-csv-file,
                        output c-xls-file) .

/**/
c-xls-file = fill-in-ruta + '\PCO-xxx-ttCotizacionDtl.xlsx'.
x-ruta-excel = c-xls-file.

run pi-crea-archivo-csv IN hProc (input  buffer x-ttCotizacionDtl:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer x-ttCotizacionDtl:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-pco-caso W-Win 
PROCEDURE procesar-pco-caso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pPesoTM AS DEC.
DEFINE INPUT PARAMETER pCodAlm AS CHAR.
DEFINE INPUT PARAMETER pCaso AS CHAR.
DEFINE INPUT PARAMETER pCondicion AS CHAR.
DEFINE OUTPUT PARAMETER pPesoKgrSobrante AS DEC.

DEFINE VAR x-peso-total-caso AS DEC INIT 0.
DEFINE VAR x-peso-tonelada AS DEC INIT 0.
DEFINE VAR x-Stk-alm AS DEC INIT 0.
DEFINE VAR x-Stk-conti AS DEC INIT 0.
DEFINE VAR x-Stk-cissac AS DEC INIT 0.
DEFINE VAR x-can-pedida AS DEC INIT 0.

x-peso-total-caso = 0.

EMPTY TEMP-TABLE x-ttCotizacionDtl.

FIND FIRST ttCotizacionDtl NO-LOCK NO-ERROR.

/* Si hay stock suficiente */
FOR EACH ttCotizacionDtl WHERE (ttCotizacionDtl.tcaso = pCaso) AND
                                (ttCotizacionDtl.tcanped - ttCotizacionDtl.tcanate) > 0 NO-LOCK:


    FILL-IN-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-msg-status.
    FILL-IN-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = FILL-IN-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} + 
                                                " - Verificando Stock (" + pCaso + ") - " + ttCotizacionDtl.tcodmat.

    x-Stk-alm = 0.
    x-Stk-cissac = 0.
    x-Stk-conti = 0.
    x-can-pedida = (ttCotizacionDtl.tcanped - ttCotizacionDtl.tcanate) * ttCotizacionDtl.tfactor.
    RUN stock-del-almacen(INPUT ttCotizacionDtl.tcodmat, INPUT pCodAlm, OUTPUT x-stk-alm, OUTPUT x-stk-conti, OUTPUT x-stk-cissac).

    /*IF pCaso = 'A' AND pCodAlm = '14' THEN DO:*/
    IF (ttCotizacionDtl.tcodmat = "098265") THEN DO:
        /*
        MESSAGE "ttCotizacionDtl.tcodmat " ttCotizacionDtl.tcodmat SKIP
                "pCodAlm " pCodAlm SKIP
                "x-stk-alm " x-stk-alm SKIP
                "x-stk-conti " x-stk-conti SKIP
                "x-stk-cissac " x-stk-cissac SKIP
                "x-can-pedida " x-can-pedida SKIP
                "pCondicion " pCondicion.
        */                        
    END.


    IF x-can-pedida <= x-stk-alm THEN DO:
        /* Suficiente Stock para atender */
        x-peso-total-caso = x-peso-total-caso + (x-can-pedida * ttCotizacionDtl.tPesmat).
        CREATE x-ttCotizacionDtl.
        BUFFER-COPY ttCotizacionDtl TO x-ttCotizacionDtl.
        ASSIGN x-ttCotizacionDtl.tcanped = x-can-pedida / ttCotizacionDtl.tfactor.  /* UM de la cotizacion */
    END.
    ELSE DO:
        /* Despachamos solo el Stock que existe */
        x-peso-total-caso = x-peso-total-caso + (ttCotizacionDtl.tPesmat * x-stk-alm).
        CREATE x-ttCotizacionDtl.
        BUFFER-COPY ttCotizacionDtl TO x-ttCotizacionDtl.
        ASSIGN x-ttCotizacionDtl.tcanped = x-stk-alm / ttCotizacionDtl.tfactor.         /* UM de la cotizacion */
    END.
END.

/* Peso en Toneladas */
x-peso-tonelada = x-peso-total-caso / 1000.

FILL-IN-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-msg-status.
FILL-IN-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = FILL-IN-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " - Grabando Items (" + pCaso + ")".

/*  Lucy Mesia el 24Nov2020 pidio no considerar el '<='
IF (pCondicion = ">=" AND x-peso-tonelada >= pPesoTM) OR (pCondicion = "<=" AND x-peso-tonelada <= pPesoTM) THEN DO:
*/
IF (pCondicion = ">=" AND x-peso-tonelada >= pPesoTM) OR (pCondicion = "*") THEN DO:
    FOR EACH x-ttCotizacionDtl WHERE x-ttCotizacionDtl.tCanPed > 0 :
        /* Rebajamos el Stock */
        x-Stk-cissac = 0.
        x-Stk-conti = 0.
        RUN rebajar-el-stock(INPUT x-ttCotizacionDtl.tcodmat, INPUT pCodAlm,  INPUT (x-ttCotizacionDtl.tCanPed * x-ttCotizacionDtl.tfactor), 
                                OUTPUT x-Stk-conti, OUTPUT x-Stk-cissac).

        FIND FIRST ttCotizacionDtl WHERE ttCotizacionDtl.tnroped = x-ttCotizacionDtl.tnroped AND
                                            ttCotizacionDtl.tcodmat = x-ttCotizacionDtl.tcodmat EXCLUSIVE-LOCK NO-ERROR.

        IF AVAILABLE ttCotizacionDtl THEN DO:
            ASSIGN ttCotizacionDtl.tcanate = ttCotizacionDtl.tcanate + x-ttCotizacionDtl.tcanped.
        END.
        /* */

        x-secuencia = x-secuencia + 1.
        CREATE ttCotizacionDtlTrabajadas.
            ASSIGN  ttCotizacionDtlTrabajadas.tnroped = x-ttCotizacionDtl.tnroped
                        ttCotizacionDtlTrabajadas.tcodmat = x-ttCotizacionDtl.tcodmat
                        ttCotizacionDtlTrabajadas.tcaso = x-ttCotizacionDtl.tcaso
                        ttCotizacionDtlTrabajadas.tcodalm = pCodAlm
                        ttCotizacionDtlTrabajadas.tcanped = x-ttCotizacionDtl.tcanped
                        ttCotizacionDtlTrabajadas.tpesmat = x-ttCotizacionDtl.tpesmat
                        ttCotizacionDtlTrabajadas.tfactor = x-ttCotizacionDtl.tfactor
                        ttCotizacionDtlTrabajadas.tstkconti = x-stk-Conti
                        ttCotizacionDtlTrabajadas.tstkcissac = x-stk-Cissac
                        ttCotizacionDtlTrabajadas.tsecuencia = x-secuencia
                        ttCotizacionDtlTrabajadas.tcoddiv = ttCotizacionDtl.tcoddiv
                        ttCotizacionDtlTrabajadas.tpreuni = ttCotizacionDtl.tpreuni
            .
    END.
END.

FILL-IN-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = x-msg-status.
FILL-IN-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = FILL-IN-msg:SCREEN-VALUE IN FRAME {&FRAME-NAME} + " - Sobrantes (" + pCaso + ")".

/* Nuevo peso de los articulos pendientes */
pPesoKgrSobrante = 0.
FOR EACH ttCotizacionDtl WHERE (ttCotizacionDtl.tcaso = pCaso) AND
                                (ttCotizacionDtl.tcanped - ttCotizacionDtl.tcanate) > 0 NO-LOCK:
    pPesoKgrSobrante = pPesoKgrSobrante + (((ttCotizacionDtl.tcanped - ttCotizacionDtl.tcanate) * ttCotizacionDtl.tfactor) 
                                             * ttCotizacionDtl.tpesmat).
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rebajar-el-stock W-Win 
PROCEDURE rebajar-el-stock :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodMat AS CHAR.
DEFINE INPUT PARAMETER pCodAlm AS CHAR.
DEFINE INPUT PARAMETER pStkUsado AS DEC.
DEFINE OUTPUT PARAMETER pStkConti AS DEC.
DEFINE OUTPUT PARAMETER pStkCissac AS DEC.

pStkConti = 0.
pStkCissac = 0.

FIND FIRST ttSaldos WHERE ttSaldos.tcodmat = pCodMat AND 
                            ttSaldos.tcodalm = pCodAlm EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE ttSaldos THEN DO:
    ASSIGN ttSaldos.tStkUso = ttSaldos.tStkUso + pStkUsado.
    pStkConti = ttSaldos.tStkConti.
    pStkCissac = ttSaldos.tStkCissac.
END.

RELEASE ttSaldos.

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
  {src/adm/template/snd-list.i "FacCPedi"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE stock-de-cissac W-Win 
PROCEDURE stock-de-cissac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pCodMat AS CHAR.
DEFINE INPUT PARAMETER  pCodAlm AS CHAR.
DEFINE OUTPUT PARAMETER pStock AS DEC.

pStock = 0.

DEFINE VAR x-url AS CHAR.
DEFINE VAR x-xml AS LONGCHAR.
DEFINE VAR x-texto AS CHAR.
DEFINE VAR x-pos1 AS INT.
DEFINE VAR x-pos2 AS INT.

DEFINE VAR x-CodAlm AS CHAR.

/* 30Oct2019 - Lucy Mesia */
x-CodAlm = pCodAlm.
IF LENGTH(x-CodAlm) > 2 THEN x-CodAlm = SUBSTRING(pCodAlm,1, LENGTH(pCodAlm) - 1).

/*x-CodAlm = SUBSTRING(pCodAlm,1, LENGTH(pCodAlm) - 1).*/

DEFINE VARIABLE hDoc AS HANDLE NO-UNDO.
 
CREATE X-DOCUMENT hDoc.

/* La URL del Webservice */
x-url = TRIM(x-url-stock-cissac).
x-url = x-url + "/" + x-CodAlm + "/" + pCodMat.

fill-in-cissac:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pCodMat.

DEFINE VAR x-intentos AS INT.
DEFINE VAR x-msg-err AS CHAR.

COMSUME_WS:
REPEAT x-intentos = 1 TO 5:
    /*hDoc:LOAD("file", "http://192.168.1.201/android-api/public/api/stock/21I/001271", FALSE).*/
    hDoc:LOAD("file", x-url, FALSE) NO-ERROR.

    /* Caso pierda comunicacion con el WebService */
    IF ERROR-STATUS:ERROR = NO THEN DO:
        fill-in-cissac:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pCodMat + " ... " + x-url.
        hDoc:SAVE("LONGCHAR",x-xml) NO-ERROR.
        x-texto = CAPS(STRING(x-xml)).

        fill-in-cissac:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pCodMat + " ... " + x-texto.

        IF ERROR-STATUS:ERROR = YES THEN DO:

            x-msg-err = "URL :" + x-url + CHR(13) + CHR(10) + 
                        "RESPONSE : " + x-texto + CHR(13) + CHR(10) +
                        "ERROR : " + ERROR-STATUS:GET-MESSAGE(1).                        
        END.
        ELSE DO:
            x-pos1 = INDEX(x-texto,"<VALUE>").
            IF x-pos1 > 0 THEN DO:
                x-pos1 = x-pos1 + LENGTH("<VALUE>").
                x-pos2 = INDEX(x-texto,"</VALUE>").
                x-texto = TRIM(SUBSTRING(x-texto,x-pos1,x-pos2 - x-pos1)).
                pStock = DEC(x-texto).
                /**/
            END.
            x-msg-err = "".
            LEAVE COMSUME_WS.
        END.

    END.
    ELSE DO:
        x-msg-err = "URL :" + x-url + CHR(13) + CHR(10) +
                    "ERROR : " + ERROR-STATUS:GET-MESSAGE(1).
    END.
END.

IF x-msg-err <> "" THEN DO:
    MESSAGE x-msg-err.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE stock-del-almacen W-Win 
PROCEDURE stock-del-almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodMat AS CHAR.
DEFINE INPUT PARAMETER pCodAlm AS CHAR.
DEFINE OUTPUT PARAMETER pStkAlm AS DEC.
DEFINE OUTPUT PARAMETER pStkConti AS DEC.
DEFINE OUTPUT PARAMETER pStkCissac AS DEC.

pStkAlm = 0.

DEFINE VAR x-stk-cissac AS DEC INIT 0.
DEFINE VAR x-StkComprometido AS DEC INIT 0.
DEFINE VAR x-stk-transito AS DEC INIT 0.

FIND FIRST ttSaldos WHERE ttSaldos.tcodmat = pCodMat AND 
                            ttSaldos.tcodalm = pCodAlm NO-LOCK NO-ERROR.
IF NOT AVAILABLE ttSaldos THEN DO:
    CREATE ttSaldos.
        ASSIGN ttSaldos.tcodmat = pCodMat
                ttSaldos.tcodalm = pCodAlm
                ttSaldos.tstkact = 0
                ttSaldos.tstkuso = 0
        .
    /* No existe, ubicar el Stock de CONTI y Tambien de STANDFORD */
    FIND FIRST almmmate WHERE almmmate.codcia = s-codcia AND
                                almmmate.codmat = pCodMat AND
                                almmmate.codalm = pCodAlm NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN ASSIGN ttSaldos.tStkact = IF(almmmate.stkact > 0) THEN almmmate.stkact ELSE 0.
    /* Buscar el Stock en StandFord, WebService de Brayan Acuña mi secretario... */
    x-stk-cissac = 0.

    IF toggle-stock-cissac = YES THEN DO:

        RUN stock-de-cissac(INPUT pCodMat, INPUT pCodAlm, OUTPUT x-stk-cissac).
    END.
    
    /* El Stock Comprometido */
    x-StkComprometido = 0.
    RUN gn/Stock-Comprometido-v2 (pCodMat, pCodAlm, YES, OUTPUT x-StkComprometido).

    /* Stock en transito */
    x-stk-transito = 0.
    RUN alm\p-articulo-en-transito (
            s-codcia,
            pCodAlm,
            pCodMat,
            INPUT-OUTPUT TABLE tmp-tabla,
            OUTPUT x-stk-transito).

    /**/
    ASSIGN ttSaldos.tStkConti = ttSaldos.tStkact + x-stk-transito - x-StkComprometido
            ttSaldos.tStkCissac = x-stk-cissac
            ttSaldos.tStkact = ttSaldos.tStkact + x-stk-transito - x-StkComprometido + x-stk-cissac .

END.
pStkConti = ttSaldos.tStkConti.
pStkCissac = ttSaldos.tStkCissac.
pStkAlm = ttSaldos.tStkact - ttSaldos.tStkUso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ubicar-caso-segun-articulo W-Win 
PROCEDURE ubicar-caso-segun-articulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodMat AS CHAR.
DEFINE OUTPUT PARAMETER pCaso AS CHAR.
DEFINE OUTPUT PARAMETER pPeso AS DEC.

pCaso = "D".    /* Default */
pPeso = 0.

DEFINE BUFFER x-almmmatg FOR almmmatg.
DEFINE BUFFER x-almtfam FOR almtfam.
DEFINE BUFFER x-vtatabla FOR vtatabla.
DEFINE BUFFER y-vtatabla FOR vtatabla.

/* Ubico el articulo */
FIND FIRST x-almmmatg WHERE x-almmmatg.codcia = s-codcia AND
                            x-almmmatg.codmat = pCodMat NO-LOCK NO-ERROR.

IF NOT AVAILABLE x-almmmatg THEN RETURN.

pPeso = x-almmmatg.pesmat.

/* Familia del articulo */
FIND FIRST x-almtfam WHERE x-almtfam.codcia = s-codcia AND
                            x-almtfam.codfam = x-almmmatg.codfam NO-LOCK NO-ERROR.

IF NOT AVAILABLE x-almtfam THEN RETURN.

/* Caso, primero segun linea y familia y 2do solo linea */
UBICARCASO:
FOR EACH x-vtatabla WHERE x-vtatabla.codcia = s-codcia AND
                            x-vtatabla.tabla = 'EVENTOS' AND
                            x-vtatabla.llave_c2 = 'EVENTOS_DTL' AND
                            x-vtatabla.llave_c4 = x-almmmatg.codfam NO-LOCK:
    pCaso = x-vtatabla.llave_c1.
    IF x-vtatabla.llave_c5 = x-almmmatg.subfam THEN DO:
        /* Tiene configurado con SUBFAMILIA */
        pCaso = x-vtatabla.llave_c1.
        LEAVE UBICARCASO.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION centrar-texto W-Win 
FUNCTION centrar-texto RETURNS LOGICAL ( INPUT h AS HANDLE ) :
    DEFINE VARIABLE reps AS INTEGER     NO-UNDO.
    reps = (h:WIDTH-PIXELS - FONT-TABLE:GET-TEXT-WIDTH-PIXELS(TRIM(h:SCREEN-VALUE),h:FONT) - 8 /* allow for 3-D borders */ ) / FONT-TABLE:GET-TEXT-WIDTH-PIXELS(' ',h:FONT).
    reps = reps / 2.
    h:SCREEN-VALUE = FILL(' ',reps) + TRIM(h:SCREEN-VALUE).
    RETURN yes.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION estado W-Win 
FUNCTION estado RETURNS CHARACTER
  ( INPUT pFlgest AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VAR x-retval AS CHAR INIT "Sin Estado".

  IF pFlgest = 'G' THEN x-retval = 'GENERADO'.
  IF pFlgest = 'T' THEN x-retval = 'AUTORIZADO'.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

