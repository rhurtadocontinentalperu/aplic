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

DEFINE TEMP-TABLE ttVtasEncartes
    FIELD ttItem        AS  INT     COLUMN-LABEL "Item"
    FIELD ttCodCupon    AS  CHAR    COLUMN-LABEL "Cupon/Encarte"    FORMAT 'x(15)'
    FIELD ttDesCupon    AS  CHAR    COLUMN-LABEL "Descripcion"    FORMAT 'x(60)'
    FIELD ttCoddiv      AS  CHAR    COLUMN-LABEL "Cod.Tienda"   FORMAT 'x(6)'
    FIELD ttDesdiv      AS  CHAR    COLUMN-LABEL "Nombre Tienda"   FORMAT 'x(60)'
    FIELD ttCajera      AS  CHAR    COLUMN-LABEL "Cajera"   FORMAT 'x(15)'
    FIELD ttcoddoc      AS  CHAR    COLUMN-LABEL "TipoDoc"  FORMAT 'x(5)'
    FIELD ttnrodoc      AS  CHAR    COLUMN-LABEL "Nro Doc"  FORMAT 'x(15)'
    FIELD ttfchdoc      AS  DATE    COLUMN-LABEL "Fecha Emision"
    FIELD ttImpBrt      AS  DEC     COLUMN-LABEL "Impte Bruto Comprobante"     INIT 0
    FIELD ttImpDscto    AS  DEC     COLUMN-LABEL "Impte Dscto Comprobante"    INIT 0
    FIELD ttImpIgv      AS  DEC     COLUMN-LABEL "I.G.V"  INIT 0    
    FIELD ttImpTot      AS  DEC     COLUMN-LABEL "Impte Total Comprobante"   INIT 0 
    FIELD ttcodmat      AS  CHAR    COLUMN-LABEL "Cod.Articulo"
    FIELD ttdesmat      AS  CHAR    COLUMN-LABEL "Descripcion"
    FIELD ttcant        AS  DEC     COLUMN-LABEL "Cantidad" INIT 0
    FIELD ttprecio      AS  DEC     COLUMN-LABEL "Precio" INIT 0
    FIELD ttImpLin      AS  DEC     COLUMN-LABEL "Impte Vta Articulo"  INIT 0
    FIELD ttImpdto2     AS  DEC     COLUMN-LABEL "Impte Dscto Articulo "  INIT 0
    FIELD ttDsctoDtl    AS  DEC     COLUMN-LABEL "Suma Dsctos"  INIT 0    
    FIELD ttcodfam      AS  CHAR    COLUMN-LABEL "Familia"
    FIELD ttsubfam      AS  CHAR    COLUMN-LABEL "Sub Familia"
    FIELD ttcodtrab     AS  CHAR    COLUMN-LABEL "Cod.Trab"
    FIELD ttnomtrab     AS  CHAR    COLUMN-LABEL "Nombre trabajador"
    FIELD ttcodasoc     AS  CHAR    COLUMN-LABEL "Cod. Asociado"
    INDEX idx01 ttItem
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
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES VtaCTabla

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 VtaCTabla.Llave ~
VtaCTabla.Descripcion VtaCTabla.Estado VtaCTabla.FechaInicial ~
VtaCTabla.FechaFinal VtaCTabla.Libre_d01 VtaCTabla.Libre_d02 ~
VtaCTabla.Libre_d04 VtaCTabla.Libre_l01 VtaCTabla.Libre_l02 ~
VtaCTabla.Libre_l03 VtaCTabla.Libre_l04 VtaCTabla.Libre_c01 ~
VtaCTabla.Libre_d03 VtaCTabla.UsrCreacion VtaCTabla.FchCreacion ~
VtaCTabla.UsrModificacion VtaCTabla.FchModificacion 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH VtaCTabla ~
      WHERE vtactabla.codcia = s-codcia and  ~
vtactabla.tabla = 'UTILEX-ENCARTE' NO-LOCK
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH VtaCTabla ~
      WHERE vtactabla.codcia = s-codcia and  ~
vtactabla.tabla = 'UTILEX-ENCARTE' NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 VtaCTabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 VtaCTabla


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      VtaCTabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      VtaCTabla.Llave COLUMN-LABEL "Codigo" FORMAT "x(10)":U
      VtaCTabla.Descripcion FORMAT "x(40)":U
      VtaCTabla.Estado FORMAT "x":U
      VtaCTabla.FechaInicial FORMAT "99/99/9999":U
      VtaCTabla.FechaFinal FORMAT "99/99/9999":U
      VtaCTabla.Libre_d01 COLUMN-LABEL "% Dscto Gral" FORMAT "->>,>>9.9999":U
      VtaCTabla.Libre_d02 COLUMN-LABEL "Tope!Dscto S/" FORMAT "->>,>>9.99":U
      VtaCTabla.Libre_d04 COLUMN-LABEL "Minimo!Venta S/" FORMAT "->>,>>9.99":U
      VtaCTabla.Libre_l01 COLUMN-LABEL "Aplica!mejor Dscto" FORMAT "yes/no":U
      VtaCTabla.Libre_l02 COLUMN-LABEL "Prod!sin promo" FORMAT "yes/no":U
      VtaCTabla.Libre_l03 COLUMN-LABEL "Req.!DNI" FORMAT "yes/no":U
      VtaCTabla.Libre_l04 COLUMN-LABEL "Req.!Cod.Trab" FORMAT "yes/no":U
      VtaCTabla.Libre_c01 COLUMN-LABEL "Kit!Promo" FORMAT "x(8)":U
      VtaCTabla.Libre_d03 COLUMN-LABEL "Tope" FORMAT "->>,>>9.99":U
      VtaCTabla.UsrCreacion COLUMN-LABEL "Creador" FORMAT "x(8)":U
      VtaCTabla.FchCreacion COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
      VtaCTabla.UsrModificacion COLUMN-LABEL "Modificado" FORMAT "x(8)":U
      VtaCTabla.FchModificacion COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 144.14 BY 17.12 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 2.81 COL 2 WIDGET-ID 200
     "Double Click en CODIGO para enviar a EXCEL las ventas" VIEW-AS TEXT
          SIZE 53 BY .62 AT ROW 20.42 COL 2 WIDGET-ID 4
          BGCOLOR 9 FGCOLOR 15 FONT 6
     "   SEGUIMIENTO VENTAS DE ENCARTES" VIEW-AS TEXT
          SIZE 55.86 BY 1.15 AT ROW 1.27 COL 42.14 WIDGET-ID 2
          BGCOLOR 15 FGCOLOR 9 FONT 11
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 146.86 BY 20.5 WIDGET-ID 100.


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
         TITLE              = "Seguimientos de Encartes"
         HEIGHT             = 20.5
         WIDTH              = 146.86
         MAX-HEIGHT         = 20.5
         MAX-WIDTH          = 146.86
         VIRTUAL-HEIGHT     = 20.5
         VIRTUAL-WIDTH      = 146.86
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
/* BROWSE-TAB BROWSE-2 TEXT-2 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.VtaCTabla"
     _Options          = "NO-LOCK"
     _Where[1]         = "vtactabla.codcia = s-codcia and 
vtactabla.tabla = 'UTILEX-ENCARTE'"
     _FldNameList[1]   > INTEGRAL.VtaCTabla.Llave
"VtaCTabla.Llave" "Codigo" "x(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.VtaCTabla.Descripcion
"VtaCTabla.Descripcion" ? "x(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.VtaCTabla.Estado
     _FldNameList[4]   = INTEGRAL.VtaCTabla.FechaInicial
     _FldNameList[5]   = INTEGRAL.VtaCTabla.FechaFinal
     _FldNameList[6]   > INTEGRAL.VtaCTabla.Libre_d01
"VtaCTabla.Libre_d01" "% Dscto Gral" "->>,>>9.9999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.VtaCTabla.Libre_d02
"VtaCTabla.Libre_d02" "Tope!Dscto S/" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.VtaCTabla.Libre_d04
"VtaCTabla.Libre_d04" "Minimo!Venta S/" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > INTEGRAL.VtaCTabla.Libre_l01
"VtaCTabla.Libre_l01" "Aplica!mejor Dscto" ? "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > INTEGRAL.VtaCTabla.Libre_l02
"VtaCTabla.Libre_l02" "Prod!sin promo" ? "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > INTEGRAL.VtaCTabla.Libre_l03
"VtaCTabla.Libre_l03" "Req.!DNI" ? "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > INTEGRAL.VtaCTabla.Libre_l04
"VtaCTabla.Libre_l04" "Req.!Cod.Trab" ? "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > INTEGRAL.VtaCTabla.Libre_c01
"VtaCTabla.Libre_c01" "Kit!Promo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > INTEGRAL.VtaCTabla.Libre_d03
"VtaCTabla.Libre_d03" "Tope" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > INTEGRAL.VtaCTabla.UsrCreacion
"VtaCTabla.UsrCreacion" "Creador" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > INTEGRAL.VtaCTabla.FchCreacion
"VtaCTabla.FchCreacion" "Fecha" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > INTEGRAL.VtaCTabla.UsrModificacion
"VtaCTabla.UsrModificacion" "Modificado" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > INTEGRAL.VtaCTabla.FchModificacion
"VtaCTabla.FchModificacion" "Fecha" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Seguimientos de Encartes */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Seguimientos de Encartes */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON MOUSE-SELECT-DBLCLICK OF BROWSE-2 IN FRAME F-Main
DO:
  IF AVAILABLE vtactabla THEN DO:
    RUN cargar-ventas.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-ventas W-Win 
PROCEDURE cargar-ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-Archivo AS CHAR.                                
DEFINE VAR rpta AS LOG.
                                
SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Excel (*.xlsx)' '*.xlsx'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.xlsx'
    RETURN-TO-START-DIR
    SAVE-AS
    TITLE 'Exportar a Excel'
    UPDATE rpta.
IF rpta = NO OR x-Archivo = '' THEN RETURN.

DEFINE VAR x-desde AS DATE.
DEFINE VAR x-hasta AS DATE.
DEFINE VAR x-fecha AS DATE.
DEFINE VAR x-docs AS CHAR.
DEFINE VAR x-encartes-cupones AS CHAR.

DEFINE VAR z-doc AS CHAR.
DEFINE VAR z-cupon AS CHAR.

DEFINE VAR x-sec AS INT.
DEFINE VAR x-sec1 AS INT.
DEFINE VAR x-graba-dtl AS LOG.
DEFINE VAR x-item AS INT INIT 0.
DEFINE VAR x-item-old AS INT INIT 0.

DEFINE VAR x-que-dscto-gral AS DEC.
DEFINE VAR x-que-dscto-particular AS DEC.

x-desde = vtactabla.fechainicial.
x-hasta = vtactabla.fechafinal.
IF x-hasta > TODAY THEN x-hasta = TODAY.

x-docs = "FAC,BOL,TCK".
x-encartes-cupones = TRIM(vtactabla.llave).

DEFINE BUFFER x-ttVtasEncartes FOR ttVtasEncartes.

SESSION:SET-WAIT-STATE('GENERAL').
                   
x-item = 0.

REPEAT x-fecha = x-desde TO x-hasta:
    FOR EACH gn-div WHERE gn-div.codcia = s-codcia AND 
                            gn-div.canal = 'MIN' NO-LOCK:
        REPEAT x-sec = 1 TO NUM-ENTRIES(x-docs,","):
            z-doc = ENTRY(x-sec,x-docs,",").
            FOR EACH ccbcdocu USE-INDEX llave10 WHERE ccbcdocu.codcia = s-codcia AND 
                                ccbcdocu.coddiv = gn-div.coddiv AND
                                ccbcdocu.fchdoc = x-fecha AND 
                                ccbcdocu.coddoc = z-doc AND
                                ccbcdocu.flgest <> "A"
                                NO-LOCK:

                /* El pedido (PED,P/M)*/
                FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND 
                                            faccpedi.coddoc = ccbcdocu.codref AND 
                                            faccpedi.nroped = ccbcdocu.nroref 
                                            NO-LOCK NO-ERROR.
                IF AVAILABLE faccpedi THEN DO:
                    IF LOOKUP(faccpedi.libre_c05,x-encartes-cupones) > 0 THEN DO:

                        x-item = x-item + 1.
                        x-item-old = x-item.

                        CREATE ttVtasEncartes.
                            ASSIGN  ttItem = x-item
                                    ttCodCupon = faccpedi.libre_c05
                                    ttdesCupon = vtactabla.descripcion
                                    ttCoddiv    = ccbcdocu.coddiv
                                    ttDesdiv    = gn-div.Desdiv
                                    ttCajera    = ccbcdocu.usuario
                                    ttcoddoc    = ccbcdocu.coddoc
                                    ttnrodoc    = ccbcdocu.nrodoc
                                    ttfchdoc    = ccbcdocu.fchdoc
                                    ttImpbrt    = ccbcdocu.imptot + ccbcdocu.impdto2
                                    ttImpTot    = ccbcdocu.imptot
                                    ttImpDscto  = ccbcdocu.impdto2
                                    ttImpIgv    = ccbcdocu.impigv
                                    ttcodtrab   = faccpedi.libre_c04
                                    ttcodasoc   = faccpedi.libre_c03
                                    ttnomtrab   = "".

                        x-que-dscto-gral = 0.
                        x-que-dscto-particular = 0.
                        FIND FIRST vtaCtabla WHERE vtactabla.codcia = s-codcia AND 
                                                    vtactabla.tabla = "UTILEX-ENCARTE" AND
                                                    vtactabla.llave = faccpedi.libre_c05
                                                    NO-LOCK NO-ERROR.
                        IF AVAILABLE vtactabla THEN x-que-dscto-gral = vtactabla.libre_d01.

                        /* Ic - Productos afectado por el Encarte */
                        FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
                            x-graba-dtl = NO.

                            FIND FIRST almmmatg OF ccbddocu NO-LOCK NO-ERROR.

                            /* Si esta en Excepciones */
                            /*
                            /* Articulos */
                            FIND FIRST vtadtabla WHERE vtadtabla.codcia = s-codcia AND 
                                                        vtadtabla.tabla = "UTILEX-ENCARTE" AND
                                                        vtadtabla.llave = faccpedi.libre_c05 AND
                                                        vtadtabla.llavedetalle = ccbddocu.codmat AND 
                                                        vtadtabla.tipo = 'XM' NO-LOCK NO-ERROR.

                            IF AVAILABLE vtadtabla THEN NEXT.

                            /* x Sub Linea */
                            FIND FIRST vtadtabla WHERE vtadtabla.codcia = s-codcia AND 
                                                        vtadtabla.tabla = "UTILEX-ENCARTE" AND
                                                        vtadtabla.llave = faccpedi.libre_c05 AND
                                                        vtadtabla.llavedetalle = almmmatg.codfam AND 
                                                        vtadtabla.libre_c01 = almmmatg.subfam AND 
                                                        vtadtabla.tipo = 'XL' NO-LOCK NO-ERROR.

                            IF AVAILABLE vtadtabla THEN NEXT.

                            /* x Linea */
                            FIND FIRST vtadtabla WHERE vtadtabla.codcia = s-codcia AND 
                                                        vtadtabla.tabla = "UTILEX-ENCARTE" AND
                                                        vtadtabla.llave = faccpedi.libre_c05 AND
                                                        vtadtabla.llavedetalle = almmmatg.codfam AND 
                                                        vtadtabla.tipo = 'XL' NO-LOCK NO-ERROR.

                            IF AVAILABLE vtadtabla THEN NEXT.
                            */



                            /* Condiciones  */
                            
                            /* x Articulo */
                            FIND FIRST vtadtabla WHERE vtadtabla.codcia = s-codcia AND 
                                                        vtadtabla.tabla = "UTILEX-ENCARTE" AND
                                                        vtadtabla.llave = faccpedi.libre_c05 AND
                                                        vtadtabla.llavedetalle = ccbddocu.codmat AND 
                                                        vtadtabla.tipo = 'M' NO-LOCK NO-ERROR.
                            IF AVAILABLE vtadtabla THEN DO:
                                /*ASSIGN ttImpLin = ttImpLin + ccbddocu.implin.*/
                                x-graba-dtl = YES.
                                x-que-dscto-particular = vtadtabla.libre_d01.
                            END.
                            ELSE DO:
                                /* x Sub Linea */
                                FIND FIRST vtadtabla WHERE vtadtabla.codcia = s-codcia AND 
                                                            vtadtabla.tabla = "UTILEX-ENCARTE" AND
                                                            vtadtabla.llave = faccpedi.libre_c05 AND
                                                            vtadtabla.llavedetalle = almmmatg.codfam AND 
                                                            vtadtabla.libre_c01 = almmmatg.subfam AND 
                                                            vtadtabla.tipo = 'L' NO-LOCK NO-ERROR.
                                IF AVAILABLE vtadtabla THEN DO:
                                    /*ASSIGN ttImpLin = ttImpLin + ccbddocu.implin.*/
                                    x-graba-dtl = YES.
                                    x-que-dscto-particular = vtadtabla.libre_d01.
                                END.
                                ELSE DO:
                                    /* x Linea */
                                    FIND FIRST vtadtabla WHERE vtadtabla.codcia = s-codcia AND 
                                                                vtadtabla.tabla = "UTILEX-ENCARTE" AND
                                                                vtadtabla.llave = faccpedi.libre_c05 AND
                                                                vtadtabla.llavedetalle = almmmatg.codfam AND 
                                                                vtadtabla.tipo = 'L' NO-LOCK NO-ERROR.
                                    IF AVAILABLE vtadtabla THEN DO:
                                        /*ASSIGN ttImpLin = ttImpLin + ccbddocu.implin.*/
                                        x-graba-dtl = YES.
                                        x-que-dscto-particular = vtadtabla.libre_d01.
                                    END.
                                    ELSE DO:
                                        /* Proveedor */
                                        /*vtadtabla.tipo = 'P'*/
                                    END.
                                END.
                            END.
                            IF x-graba-dtl = YES THEN DO:
                                ASSIGN ttVtasEncartes.ttDsctoDtl = ttVtasEncartes.ttDsctoDtl + ccbddocu.impdto2.
                                
                                IF x-que-dscto-particular > 0 AND ccbddocu.pordto2 = x-que-dscto-particular OR 
                                    x-que-dscto-gral > 0 AND ccbddocu.pordto2 = x-que-dscto-gral THEN DO:

                                    x-item = x-item + 1.

                                    IF x-item-old = (x-item - 1) THEN DO:
                                        ASSIGN ttCodCupon = faccpedi.libre_c05
                                        ttdesCupon = vtactabla.descripcion
                                        ttCoddiv    = ccbcdocu.coddiv
                                        ttDesdiv    = gn-div.Desdiv
                                        ttCajera    = ccbcdocu.usuario
                                        ttcoddoc    = ccbcdocu.coddoc
                                        ttnrodoc    = ccbcdocu.nrodoc
                                        ttfchdoc    = ccbcdocu.fchdoc
                                        ttImpbrt    = ccbcdocu.imptot + ccbcdocu.impdto2
                                        ttImpTot    = ccbcdocu.imptot
                                        ttImpDscto  = ccbcdocu.impdto2
                                        ttImpIgv    = ccbcdocu.impigv.
                                        
                                        ASSIGN  ttVtasEncartes.ttcodmat    = ccbddocu.codmat
                                                ttVtasEncartes.ttdesmat    = almmmatg.desmat
                                                ttVtasEncartes.ttcant  =   ccbddocu.candes
                                                ttVtasEncartes.ttprecio    = ccbddocu.preuni
                                                ttVtasEncartes.ttcodfam    = almmmatg.codfam
                                                ttVtasEncartes.ttsubfam    = almmmatg.subfam
                                                ttVtasEncartes.ttImpLin    = ccbddocu.implin
                                                ttVtasEncartes.ttImpdto2    = ccbddocu.impdto2.

                                    END.                                    
                                    ELSE DO:
                                        CREATE x-ttVtasEncartes.                                        
                                        ASSIGN x-ttVtasEncartes.ttCodCupon = faccpedi.libre_c05
                                        x-ttVtasEncartes.ttdesCupon = vtactabla.descripcion
                                        x-ttVtasEncartes.ttCoddiv    = ccbcdocu.coddiv
                                        x-ttVtasEncartes.ttDesdiv    = gn-div.Desdiv
                                        x-ttVtasEncartes.ttCajera    = ccbcdocu.usuario
                                        x-ttVtasEncartes.ttcoddoc    = ccbcdocu.coddoc
                                        x-ttVtasEncartes.ttnrodoc    = ccbcdocu.nrodoc
                                        x-ttVtasEncartes.ttfchdoc    = ccbcdocu.fchdoc
                                        x-ttVtasEncartes.ttImpbrt    = ccbcdocu.imptot + ccbcdocu.impdto2
                                        x-ttVtasEncartes.ttImpTot    = ccbcdocu.imptot
                                        x-ttVtasEncartes.ttImpDscto  = ccbcdocu.impdto2
                                        x-ttVtasEncartes.ttImpIgv    = ccbcdocu.impigv
                                        x-ttVtasEncartes.ttcodtrab   = faccpedi.libre_c04
                                        x-ttVtasEncartes.ttnomtrab   = "".

                                        ASSIGN  x-ttVtasEncartes.ttitem = x-item.
                                        ASSIGN  x-ttVtasEncartes.ttcodmat    = ccbddocu.codmat
                                                x-ttVtasEncartes.ttdesmat    = almmmatg.desmat
                                                x-ttVtasEncartes.ttcant  =   ccbddocu.candes
                                                x-ttVtasEncartes.ttprecio    = ccbddocu.preuni
                                                x-ttVtasEncartes.ttcodfam    = almmmatg.codfam
                                                x-ttVtasEncartes.ttsubfam    = almmmatg.subfam
                                                x-ttVtasEncartes.ttImpLin    = ccbddocu.implin
                                                x-ttVtasEncartes.ttImpdto2    = ccbddocu.impdto2.
                                    END.
                                END.
                                        
                            END.
                        END.
                    END.
                END.
            END.

        END.
    END.
END.

/* Nombre trajabdor */
FOR EACH x-ttVtasEncartes :
    FIND FIRST pl-pers WHERE pl-pers.codcia = s-codcia AND 
                                pl-pers.codper = x-ttVtasEncartes.ttcodtrab NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN DO:
        ASSIGN x-ttVtasEncartes.ttnomtrab = TRIM(pl-pers.patpe) + " " + TRIM(pl-pers.matpe) + " " + TRIM(pl-pers.nompe).
    END.
END.

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */


c-xls-file = x-Archivo.

run pi-crea-archivo-csv IN hProc (input  buffer ttVtasEncartes:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer ttVtasEncartes:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

SESSION:SET-WAIT-STATE('').


MESSAGE "Proceso Concluido".


END PROCEDURE.

/*
    FIELD ttCodCupon    AS  CHAR    COLUMN-LABEL "Cupon/Encarte"    FORMAT 'x(15)'
    FIELD ttDesCupon    AS  CHAR    COLUMN-LABEL "Descripcion"    FORMAT 'x(60)'
    FIELD ttCoddiv      AS  CHAR    COLUMN-LABEL "Cod.Tienda"   FORMAT 'x(6)'
    FIELD ttDesdiv      AS  CHAR    COLUMN-LABEL "Nombre Tienda"   FORMAT 'x(60)'
    FIELD ttCajera      AS  CHAR    COLUMN-LABEL "Cajera"   FORMAT 'x(15)'
    FIELD ttcoddoc      AS  CHAR    COLUMN-LABEL "TipoDoc"  FORMAT 'x(5)'
    FIELD ttnrodoc      AS  CHAR    COLUMN-LABEL "Nro Doc"  FORMAT 'x(15)'
    FIELD ttfchdoc      AS  DATE    COLUMN-LABEL "Fecha Emision"
    FIELD ttImpBrt      AS  DEC     COLUMN-LABEL "Importe Bruto"   
    FIELD ttImpDscto    AS  DEC     COLUMN-LABEL "Importe Descuento"
    FIELD ttImpTot      AS  DEC     COLUMN-LABEL "Importe Total (inc IGV)"   
    FIELD ttImpIgv      AS  DEC     COLUMN-LABEL "Igv".

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
  ENABLE BROWSE-2 
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
  {src/adm/template/snd-list.i "VtaCTabla"}

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

