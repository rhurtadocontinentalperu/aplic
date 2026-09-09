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

DEFINE TEMP-TABLE ttValesUsados
    FIELD   tproducto   AS  CHAR    COLUMN-LABEL "Producto"
    FIELD   tnrovale    AS  CHAR    COLUMN-LABEL "Nro de Vale"
    FIELD   timpvale    AS  DEC     COLUMN-LABEL "Valor Vale"
    FIELD   tcajera     AS  CHAR    COLUMN-LABEL "Cajera"
    FIELD   tcoddiv     AS  CHAR    COLUMN-LABEL "Tienda"
    FIELD   tcodingcaj  AS  CHAR    COLUMN-LABEL "Cod.Ing.Caja"
    FIELD   tnroingcaj  AS  CHAR    COLUMN-LABEL "Nro.Ing.Caja"
    FIELD   tfcosumo    AS  DATETIME    COLUMN-LABEL "Fecha de Consumo"
    FIELD   tcodcmpte   AS  CHAR    COLUMN-LABEL "Cod. Comprobante"
    FIELD   tnrocmpte   AS  CHAR    COLUMN-LABEL "Nro. Comprobante"
    FIELD   timpcmpte   AS  DEC     COLUMN-LABEL "Impte Comprobante"
    FIELD   tcodcli     AS  CHAR     COLUMN-LABEL "Cod.Cliente"
    FIELD   tnomcli     AS  CHAR     COLUMN-LABEL "Nombre Cliente"
    FIELD   tcodtrab    AS  CHAR    COLUMN-LABEL "Cod.Trabajador"
    FIELD   tnomtrab    AS  CHAR    COLUMN-LABEL "Nombre trabajador".

DEFINE VAR x-DBname AS CHAR.
DEFINE VAR x-LDname AS CHAR.
DEFINE VAR x-IP     AS CHAR.
DEFINE VAR x-PORT   AS CHAR.
DEFINE VAR x-User   AS CHAR.
DEFINE VAR x-Pass   AS CHAR.
DEFINE VAR x-archivo AS CHAR.

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
&Scoped-define INTERNAL-TABLES VtaCTickets

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 VtaCTickets.CodPro ~
VtaCTickets.Libre_c05 VtaCTickets.FchIni VtaCTickets.FchFin ~
VtaCTickets.Producto 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH VtaCTickets ~
      WHERE vtactickets.libre_c05 <> "" NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH VtaCTickets ~
      WHERE vtactickets.libre_c05 <> "" NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 VtaCTickets
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 VtaCTickets


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 txtDesde txtHasta BtnExcel 
&Scoped-Define DISPLAYED-OBJECTS txtMsg txtProveedor txtDespro txtDesde ~
txtHasta txtProducto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnExcel 
     LABEL "Generar XLS" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtDespro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtMsg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 64 BY 1 NO-UNDO.

DEFINE VARIABLE txtProducto AS CHARACTER FORMAT "X(25)":U 
     LABEL "Producto" 
     VIEW-AS FILL-IN 
     SIZE 5 BY 1 NO-UNDO.

DEFINE VARIABLE txtProveedor AS CHARACTER FORMAT "X(25)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      VtaCTickets SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      VtaCTickets.CodPro FORMAT "x(11)":U
      VtaCTickets.Libre_c05 COLUMN-LABEL "Proveedor" FORMAT "x(60)":U
            WIDTH 37.86
      VtaCTickets.FchIni FORMAT "99/99/9999":U
      VtaCTickets.FchFin FORMAT "99/99/9999":U
      VtaCTickets.Producto FORMAT "x(8)":U WIDTH 7.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 80 BY 4.5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 3.5 COL 7 WIDGET-ID 200
     txtMsg AT ROW 11.08 COL 9.43 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     txtProveedor AT ROW 9.85 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     txtDespro AT ROW 8.69 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     txtDesde AT ROW 2.15 COL 25 COLON-ALIGNED WIDGET-ID 2
     txtHasta AT ROW 2.15 COL 50 COLON-ALIGNED WIDGET-ID 4
     txtProducto AT ROW 8.69 COL 17 COLON-ALIGNED WIDGET-ID 8
     BtnExcel AT ROW 8.69 COL 69 WIDGET-ID 6
     "RANGO DE MOVIMIENTO DE VENTAS" VIEW-AS TEXT
          SIZE 39 BY .77 AT ROW 1.35 COL 24.43 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 94.14 BY 11.62 WIDGET-ID 100.


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
         TITLE              = "Vales Utilex usados"
         HEIGHT             = 11.62
         WIDTH              = 94.14
         MAX-HEIGHT         = 17.54
         MAX-WIDTH          = 94.29
         VIRTUAL-HEIGHT     = 17.54
         VIRTUAL-WIDTH      = 94.29
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BROWSE-2 1 F-Main */
/* SETTINGS FOR FILL-IN txtDespro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtMsg IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtProducto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txtProveedor IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.VtaCTickets"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "integral.vtactickets.libre_c05 <> """""
     _FldNameList[1]   = INTEGRAL.VtaCTickets.CodPro
     _FldNameList[2]   > INTEGRAL.VtaCTickets.Libre_c05
"VtaCTickets.Libre_c05" "Proveedor" ? "character" ? ? ? ? ? ? no ? no no "37.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = INTEGRAL.VtaCTickets.FchIni
     _FldNameList[4]   = INTEGRAL.VtaCTickets.FchFin
     _FldNameList[5]   > INTEGRAL.VtaCTickets.Producto
"VtaCTickets.Producto" ? ? "character" ? ? ? ? ? ? no ? no no "7.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Vales Utilex usados */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Vales Utilex usados */
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
ON ENTRY OF BROWSE-2 IN FRAME F-Main
DO:
   IF AVAILABLE integral.vtactickets THEN DO:
        txtProducto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = integral.Vtactickets.producto.
        txtDesPro:SCREEN-VALUE IN FRAME {&FRAME-NAME} = integral.Vtactickets.libre_c05.
        txtProveedor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = integral.Vtactickets.codpro.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 W-Win
ON VALUE-CHANGED OF BROWSE-2 IN FRAME F-Main
DO:    
    txtProducto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = integral.Vtactickets.producto.
    txtDesPro:SCREEN-VALUE IN FRAME {&FRAME-NAME} = integral.Vtactickets.libre_c05.
    txtProveedor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = integral.Vtactickets.codpro.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnExcel W-Win
ON CHOOSE OF BtnExcel IN FRAME F-Main /* Generar XLS */
DO:

    ASSIGN txtDesde txtHasta txtproducto txtProveedor.

    IF txtDesde <= txtHasta THEN DO:
        RUN generar-excel.
    END.
    ELSE DO:
        MESSAGE "Rango de Fechas Erradas".
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
  DISPLAY txtMsg txtProveedor txtDespro txtDesde txtHasta txtProducto 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BROWSE-2 txtDesde txtHasta BtnExcel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-excel W-Win 
PROCEDURE generar-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR rpta AS LOG.
DEFINE VAR x-archivo AS CHAR.

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

DEFINE VAR x-conexion-ok AS LOG.
             
x-user = 'admin'.

SESSION:SET-WAIT-STATE("general").

EMPTY TEMP-TABLE  ttValesUsados.

/* Tiendas */  
Tiendas:
FOR EACH integral.factabla WHERE integral.factabla.codcia = s-codcia AND
                    integral.factabla.tabla = 'TDAS-UTILEX' NO-LOCK:
    x-DBname = "integral".
    x-LDname = "DBTDA".  /* + TRIM(factabla.codigo). */
    x-ip = TRIM(integral.factabla.campo-c[1]).
    x-port = TRIM(integral.factabla.campo-c[2]).
    x-Pass = TRIM(integral.factabla.campo-c[3]).

    x-conexion-ok = NO.

    txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(integral.factabla.codigo) + " " + x-ip + " Conectandose...".

    RUN lib/p-connect-db.p(INPUT x-DBname, INPUT x-LDname, INPUT x-ip, 
                         INPUT x-port, INPUT x-user, INPUT x-pass, OUTPUT x-conexion-ok).

    IF x-conexion-ok = YES THEN DO:
        IF CONNECTED(x-LDname) THEN DO:
            RUN leer-tickes.
        END.            
    END.

END.

/* Servidor de LIMA */
FOR EACH integral.vtadtickets WHERE integral.vtadtickets.codcia = s-codcia AND 
                                    integral.vtadtickets.codpro = txtProveedor AND
                                    integral.vtadtickets.producto = txtproducto AND
                                    (date(integral.vtadtickets.fecha) >= txtDesde AND date(integral.vtadtickets.fecha) <= txtHasta)
                                    NO-LOCK:

    FIND FIRST ttValesUsados WHERE ttValesUsados.tproducto = integral.vtadtickets.producto AND 
                                    ttValesUsados.tnrovale = integral.vtadtickets.nrotck NO-ERROR.

    IF NOT AVAILABLE ttValesUsados THEN DO:

        txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(integral.vtadtickets.coddiv) + " SERVIDOR CENTRAL - Vale " + integral.vtadtickets.nrotck NO-ERROR.

        FIND FIRST integral.ccbdcaja WHERE integral.ccbdcaja.codcia = s-codcia AND 
                                        integral.ccbdcaja.coddoc = integral.vtadtickets.codref AND 
                                        integral.ccbdcaja.nrodoc = integral.vtadtickets.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE integral.ccbdcaja THEN DO:
            CREATE ttValesUsados.
                    ASSIGN tproducto = integral.vtadtickets.producto
                            tnrovale = integral.vtadtickets.nrotck
                            timpvale = integral.vtadtickets.valor
                            tcajera = integral.vtadtickets.usuario
                            tcoddiv = integral.vtadtickets.coddiv
                            tcodingcaj = integral.vtadtickets.codref
                            tnroingcaj = integral.vtadtickets.nroref
                            tfcosumo = integral.vtadtickets.fecha
                            tcodcmpte = integral.ccbdcaja.codref
                            tnrocmpte = integral.ccbdcaja.nroref
                            timpcmpte = integral.ccbdcaja.imptot.
                    /* Cliente */
                    FIND FIRST integral.vtatabla WHERE integral.vtatabla.codcia = s-codcia AND 
                                                integral.vtatabla.tabla = 'VUTILEXTCK' AND 
                                                integral.vtatabla.llave_c5 = integral.vtadtickets.nrotck
                                                NO-LOCK NO-ERROR.
                    IF AVAILABLE integral.vtatabla THEN DO:
                        FIND FIRST integral.gn-clie  WHERE integral.gn-clie.codcia = 0 AND 
                                                            integral.gn-clie.codcli = integral.vtatabla.libre_c01
                                                            NO-LOCK NO-ERROR.
                        IF AVAILABLE integral.gn-clie THEN DO:
                            ASSIGN tcodcli = integral.vtatabla.libre_c01
                                    tnomcli = integral.gn-clie.nomcli.
                        END.
                    END.

                    /* Codigo de Trabajador - Ic 07May2018, correo 02May2018 */       
                    FIND FIRST integral.ccbcdocu WHERE integral.ccbcdocu.codcia = s-codcia AND 
                                                    integral.ccbcdocu.coddoc = integral.ccbdcaja.codref AND 
                                                    integral.ccbcdocu.nrodoc = integral.ccbdcaja.nroref NO-LOCK NO-ERROR.

                    IF AVAILABLE integral.ccbcdocu THEN DO:
                        FIND FIRST integral.faccpedi WHERE integral.faccpedi.codcia = s-codcia AND 
                                                            integral.faccpedi.coddoc = integral.ccbcdocu.codped AND 
                                                            integral.faccpedi.nroped = integral.ccbcdocu.nroped NO-LOCK NO-ERROR.
                            ASSIGN tcodtrab = integral.faccpedi.libre_c04.
                    END.

        END.    
    END.
END.

/* Nombre del trabajador */
FOR EACH ttValesUsados :
    FIND FIRST integral.pl-pers WHERE integral.pl-pers.codper = tcodtrab NO-LOCK NO-ERROR.
    IF AVAILABLE integral.pl-pers THEN DO:
        ASSIGN tnomtrab = trim(integral.pl-pers.patper) + " " + trim(integral.pl-pers.matper) + " " + trim(integral.pl-pers.nomper).
    END.
END.



/* --------------------------------------------- */                                   
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = x-Archivo.

run pi-crea-archivo-csv IN hProc (input  buffer ttValesUsados:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer ttValesUsados:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

SESSION:SET-WAIT-STATE("").


MESSAGE "Proceso Concluido".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leer-tickes W-Win 
PROCEDURE leer-tickes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-docs AS INT INIT 0.
        
/* Tiendas */
FOR EACH dbtda.vtadtickets WHERE dbtda.vtadtickets.codcia = s-codcia AND 
                                    dbtda.vtadtickets.codpro = txtProveedor AND
                                    dbtda.vtadtickets.producto = txtproducto AND
                                    dbtda.vtadtickets.coddiv = integral.factabla.codigo AND
                                    (date(dbtda.vtadtickets.fecha) >= txtDesde AND date(dbtda.vtadtickets.fecha) <= txtHasta)
                                    NO-LOCK:

    txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(integral.factabla.codigo) + " " + x-ip + " Vale " + dbtda.vtadtickets.nrotck.

    FIND FIRST dbtda.ccbdcaja WHERE dbtda.ccbdcaja.codcia = s-codcia AND 
                                    dbtda.ccbdcaja.coddoc = dbtda.vtadtickets.codref AND 
                                    dbtda.ccbdcaja.nrodoc = dbtda.vtadtickets.nroref NO-LOCK NO-ERROR.
    IF AVAILABLE dbtda.ccbdcaja THEN DO:
        CREATE ttValesUsados.
                ASSIGN tproducto = dbtda.vtadtickets.producto
                        tnrovale = dbtda.vtadtickets.nrotck
                        timpvale = dbtda.vtadtickets.valor
                        tcajera = dbtda.vtadtickets.usuario
                        tcoddiv = dbtda.vtadtickets.coddiv
                        tcodingcaj = dbtda.vtadtickets.codref
                        tnroingcaj = dbtda.vtadtickets.nroref
                        tfcosumo = dbtda.vtadtickets.fecha
                        tcodcmpte = dbtda.ccbdcaja.codref
                        tnrocmpte = dbtda.ccbdcaja.nroref
                        timpcmpte = dbtda.ccbdcaja.imptot.
        /* Cliente */
        FIND FIRST integral.vtatabla WHERE integral.vtatabla.codcia = s-codcia AND 
                                    integral.vtatabla.tabla = 'VUTILEXTCK' AND 
                                    integral.vtatabla.llave_c5 = dbtda.vtadtickets.nrotck
                                    NO-LOCK NO-ERROR.
        IF AVAILABLE integral.vtatabla THEN DO:
            FIND FIRST integral.gn-clie  WHERE integral.gn-clie.codcia = 0 AND 
                                                integral.gn-clie.codcli = integral.vtatabla.libre_c01
                                                NO-LOCK NO-ERROR.
            IF AVAILABLE integral.gn-clie THEN DO:
                ASSIGN tcodcli = integral.vtatabla.libre_c01
                        tnomcli = integral.gn-clie.nomcli.
            END.
        END.

        /* Codigo de Trabajador - Ic 07May2018, correo 02May2018 */       
        FIND FIRST dbtda.ccbcdocu WHERE dbtda.ccbcdocu.codcia = s-codcia AND 
                                        dbtda.ccbcdocu.coddoc = dbtda.ccbdcaja.codref AND 
                                        dbtda.ccbcdocu.nrodoc = dbtda.ccbdcaja.nroref NO-LOCK NO-ERROR.
                                        
        IF AVAILABLE dbtda.ccbcdocu THEN DO:
            FIND FIRST dbtda.faccpedi WHERE dbtda.faccpedi.codcia = s-codcia AND 
                                                dbtda.faccpedi.coddoc = dbtda.ccbcdocu.codped AND 
                                                dbtda.faccpedi.nroped = dbtda.ccbcdocu.nroped NO-LOCK NO-ERROR.
                ASSIGN tcodtrab = dbtda.faccpedi.libre_c04.
        END.


    END.

END.

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
  txtdesde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 45,"99/99/9999").
  txtHasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").

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
  {src/adm/template/snd-list.i "VtaCTickets"}

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

