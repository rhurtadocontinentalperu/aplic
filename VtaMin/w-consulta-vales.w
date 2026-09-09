&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



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
    FIELD   tnomcli     AS  CHAR     COLUMN-LABEL "Nombre Cliente".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-w-report

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 tt-w-report.Campo-C[2] ~
tt-w-report.Campo-I[1] tt-w-report.Campo-C[3] tt-w-report.Campo-C[4] ~
tt-w-report.Campo-C[5] tt-w-report.Campo-C[10] tt-w-report.Campo-C[6] ~
tt-w-report.Campo-C[7] tt-w-report.Campo-F[1] tt-w-report.Campo-C[8] ~
tt-w-report.Campo-C[9] tt-w-report.Campo-C[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 tt-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS txtValeDesde txtValeHasta BtnConsulta ~
BROWSE-5 
&Scoped-Define DISPLAYED-OBJECTS txtValeDesde txtValeHasta txtMsg 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnConsulta 
     LABEL "Consulta" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtMsg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 96 BY 1 NO-UNDO.

DEFINE VARIABLE txtValeDesde AS INTEGER FORMAT "999999999":U INITIAL 0 
     LABEL "Nro de Vale - Desde" 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE txtValeHasta AS INTEGER FORMAT "999999999":U INITIAL 0 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      tt-w-report.Campo-C[2] COLUMN-LABEL "NroVale" FORMAT "X(9)":U
      tt-w-report.Campo-I[1] COLUMN-LABEL "Valor Vale" FORMAT "->>,>>9":U
      tt-w-report.Campo-C[3] COLUMN-LABEL "Cajera" FORMAT "X(8)":U
            WIDTH 10.29
      tt-w-report.Campo-C[4] COLUMN-LABEL "Tienda" FORMAT "X(40)":U
            WIDTH 25.14
      tt-w-report.Campo-C[5] COLUMN-LABEL "Nro I/C" FORMAT "X(9)":U
      tt-w-report.Campo-C[10] COLUMN-LABEL "Fecha consumo" FORMAT "X(20)":U
            WIDTH 18.29
      tt-w-report.Campo-C[6] COLUMN-LABEL "CodCmpte" FORMAT "X(4)":U
      tt-w-report.Campo-C[7] COLUMN-LABEL "NroCmpte" FORMAT "X(11)":U
      tt-w-report.Campo-F[1] COLUMN-LABEL "Impte Cmpte" FORMAT "->>,>>9.99":U
      tt-w-report.Campo-C[8] COLUMN-LABEL "Cod.Clie" FORMAT "X(11)":U
      tt-w-report.Campo-C[9] COLUMN-LABEL "Nombre Cliente" FORMAT "X(50)":U
      tt-w-report.Campo-C[1] COLUMN-LABEL "Producto" FORMAT "X(25)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 119 BY 11.73 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtValeDesde AT ROW 2.35 COL 34 COLON-ALIGNED WIDGET-ID 2
     txtValeHasta AT ROW 2.35 COL 58 COLON-ALIGNED WIDGET-ID 6
     BtnConsulta AT ROW 2.42 COL 77.43 WIDGET-ID 4
     BROWSE-5 AT ROW 3.69 COL 3 WIDGET-ID 200
     txtMsg AT ROW 16 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     "CONSULTA DE VALES EMITIDOS POR CONTINENTAL" VIEW-AS TEXT
          SIZE 71 BY .62 AT ROW 1.23 COL 21.57 WIDGET-ID 10
          FGCOLOR 9 FONT 11
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 123.14 BY 16.96 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Temp-Tables and Buffers:
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta de Consumo de Vales"
         HEIGHT             = 16.96
         WIDTH              = 123.14
         MAX-HEIGHT         = 22.69
         MAX-WIDTH          = 134.72
         VIRTUAL-HEIGHT     = 22.69
         VIRTUAL-WIDTH      = 134.72
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartWindowCues" W-Win _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartWindow,ab,49271
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
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
/* BROWSE-TAB BROWSE-5 BtnConsulta F-Main */
/* SETTINGS FOR FILL-IN txtMsg IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[2]
"Campo-C[2]" "NroVale" "X(9)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-I[1]
"Campo-I[1]" "Valor Vale" "->>,>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-C[3]
"Campo-C[3]" "Cajera" ? "character" ? ? ? ? ? ? no ? no no "10.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[4]
"Campo-C[4]" "Tienda" "X(40)" "character" ? ? ? ? ? ? no ? no no "25.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[5]
"Campo-C[5]" "Nro I/C" "X(9)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-C[10]
"Campo-C[10]" "Fecha consumo" "X(20)" "character" ? ? ? ? ? ? no ? no no "18.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-w-report.Campo-C[6]
"Campo-C[6]" "CodCmpte" "X(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-w-report.Campo-C[7]
"Campo-C[7]" "NroCmpte" "X(11)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-w-report.Campo-F[1]
"Campo-F[1]" "Impte Cmpte" "->>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-w-report.Campo-C[8]
"Campo-C[8]" "Cod.Clie" "X(11)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-w-report.Campo-C[9]
"Campo-C[9]" "Nombre Cliente" "X(50)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt-w-report.Campo-C[1]
"Campo-C[1]" "Producto" "X(25)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Consulta de Consumo de Vales */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Consulta de Consumo de Vales */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnConsulta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnConsulta W-Win
ON CHOOSE OF BtnConsulta IN FRAME F-Main /* Consulta */
DO:
  
    ASSIGN txtValeDesde txtValehasta.

    IF txtValeDesde > txtValeHasta THEN DO:
        MESSAGE "Rango de vales estan errados".
        RETURN NO-APPLY.
    END.
    RUN consultar-informacion.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consultar-informacion W-Win 
PROCEDURE consultar-informacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-nro-vale AS INT.

EMPTY TEMP-TABLE tt-w-report.

REPEAT x-nro-vale = txtValeDesde TO txtValeHasta :
    RUN informacion-vale(INPUT x-nro-vale).
END.

FOR EACH ttValesUsados :

    FIND FIRST vtactickets WHERE vtactickets.codcia = s-codcia AND
                                vtactickets.codpro = '10003814' AND
                                vtactickets.libre_c05 <> "" AND 
                                vtactickets.producto = tproducto NO-LOCK NO-ERROR.

    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
                                gn-divi.coddiv = tcoddiv NO-LOCK NO-ERROR.

    CREATE tt-w-report.
    ASSIGN tt-w-report.campo-c[1] = tproducto + " " + IF(AVAILABLE vtactickets) THEN vtactickets.libre_c05 ELSE ""
            tt-w-report.campo-c[2] = tnrovale
            tt-w-report.campo-c[3] = tcajera
            tt-w-report.campo-c[4] = tcoddiv + " " + IF(AVAILABLE gn-divi) THEN gn-divi.desdiv ELSE ""
            tt-w-report.campo-c[5] = tnroingcaj
            tt-w-report.campo-c[6] = tcodcmpte
            tt-w-report.campo-c[7] = tnrocmpte
            tt-w-report.campo-c[8] = tcodcli
            tt-w-report.campo-c[9] = tnomcli
            tt-w-report.campo-c[10] = STRING(tfcosumo,"99/99/9999 HH:MM:SS")
            tt-w-report.campo-i[1] = timpvale
            tt-w-report.campo-f[1] = timpcmpte
        .
END.

{&OPEN-QUERY-BROWSE-5}

END PROCEDURE.

/*
DEFINE TEMP-TABLE ttValesUsados
    FIELD      AS  CHAR    COLUMN-LABEL "Producto"
    FIELD       AS  CHAR    COLUMN-LABEL "Nro de Vale"
    FIELD       AS  DEC     COLUMN-LABEL "Valor Vale"
    FIELD        AS  CHAR    COLUMN-LABEL "Cajera"
    FIELD        AS  CHAR    COLUMN-LABEL "Tienda"
    FIELD     AS  CHAR    COLUMN-LABEL "Nro.Ing.Caja"
    FIELD       AS  DATETIME    COLUMN-LABEL "Fecha de Consumo"
    FIELD      AS  CHAR    COLUMN-LABEL "Cod. Comprobante"
    FIELD      AS  CHAR    COLUMN-LABEL "Nro. Comprobante"
    FIELD      AS  DEC     COLUMN-LABEL "Impte Comprobante"
    FIELD        AS  CHAR     COLUMN-LABEL "Cod.Cliente"
    FIELD        AS  CHAR     COLUMN-LABEL "Nombre Cliente".
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
  DISPLAY txtValeDesde txtValeHasta txtMsg 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txtValeDesde txtValeHasta BtnConsulta BROWSE-5 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE informacion-vale W-Win 
PROCEDURE informacion-vale :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-nrovale AS INT.

DEFINE VAR x-nrovale AS CHAR.

x-nrovale = STRING(p-nrovale,"999999999").

FIND FIRST integral.vtadtickets WHERE integral.vtadtickets.codcia = s-codcia AND 
                                    integral.vtadtickets.codpro = '10003814' AND 
                                    integral.vtadtickets.nrotck = x-nrovale NO-LOCK NO-ERROR.

IF AVAILABLE integral.vtadtickets THEN DO:

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
        END.    
    END.
END.

END PROCEDURE.

/*
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
    FIELD   tnomcli     AS  CHAR     COLUMN-LABEL "Nombre Cliente".
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
  {src/adm/template/snd-list.i "tt-w-report"}

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

