&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE rr-w-report NO-UNDO LIKE w-report.
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEFINE TEMP-TABLE tt-items-pickeados NO-UNDO LIKE w-report.

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER pCodDoc  AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pNroDoc  AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pBultos AS INT NO-UNDO.
DEFINE INPUT PARAMETER pNroBulto AS INT NO-UNDO.
DEFINE INPUT PARAMETER pGraficoRotulo AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-items-pickeados.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-CodAlm AS CHAR.
DEFINE SHARED VAR s-coddiv AS CHAR.

DEF STREAM REPORTE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-14

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-w-report

/* Definitions for BROWSE BROWSE-14                                     */
&Scoped-define FIELDS-IN-QUERY-BROWSE-14 tt-w-report.Campo-L[1] ~
tt-w-report.Campo-C[1] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-14 tt-w-report.Campo-L[1] 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-14 tt-w-report
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-14 tt-w-report
&Scoped-define QUERY-STRING-BROWSE-14 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-14 OPEN QUERY BROWSE-14 FOR EACH tt-w-report NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-14 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-14 tt-w-report


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-14}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-14 FILL-IN-oc FILL-IN-sap ~
RADIO-SET-tipo-rotulo Btn_OK 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-oc FILL-IN-sap ~
RADIO-SET-tipo-rotulo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD peso-de-articulo D-Dialog 
FUNCTION peso-de-articulo RETURNS DECIMAL
  ( INPUT pCodMat AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD peso-total-bulto D-Dialog 
FUNCTION peso-total-bulto RETURNS DECIMAL
  ( INPUT pBulto AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Imprimir Rotulo" 
     SIZE 23 BY 1.15
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-oc AS CHARACTER FORMAT "x(25)":U 
     LABEL "Orden de Compra" 
     VIEW-AS FILL-IN 
     SIZE 26.86 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-sap AS CHARACTER FORMAT "x(25)":U 
     LABEL "Codigo SAP" 
     VIEW-AS FILL-IN 
     SIZE 26.86 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-tipo-rotulo AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Rotulo Normal", 1,
"Rotulo Supermercado", 2
     SIZE 41 BY .96 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-14 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-14 D-Dialog _STRUCTURED
  QUERY BROWSE-14 NO-LOCK DISPLAY
      tt-w-report.Campo-L[1] COLUMN-LABEL "Sele" FORMAT "Si/No":U
            WIDTH 4.43 VIEW-AS TOGGLE-BOX
      tt-w-report.Campo-C[1] COLUMN-LABEL "Bulto" FORMAT "X(25)":U
            WIDTH 39.72
  ENABLE
      tt-w-report.Campo-L[1]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 48 BY 9.54
         TITLE "Rotulos para impimir" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-14 AT ROW 1.08 COL 7 WIDGET-ID 200
     Btn_Cancel AT ROW 4.08 COL 51
     FILL-IN-oc AT ROW 11 COL 20.29 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-sap AT ROW 12.15 COL 20.29 COLON-ALIGNED WIDGET-ID 6
     RADIO-SET-tipo-rotulo AT ROW 13.69 COL 10 NO-LABEL WIDGET-ID 8
     Btn_OK AT ROW 15.23 COL 19
     SPACE(25.28) SKIP(0.99)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Codigo SAP"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: rr-w-report T "?" NO-UNDO INTEGRAL w-report
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-14 1 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON Btn_Cancel IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       Btn_Cancel:HIDDEN IN FRAME D-Dialog           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-14
/* Query rebuild information for BROWSE BROWSE-14
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-L[1]
"tt-w-report.Campo-L[1]" "Sele" ? "logical" ? ? ? ? ? ? yes ? no no "4.43" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[1]
"tt-w-report.Campo-C[1]" "Bulto" "X(25)" "character" ? ? ? ? ? ? no ? no no "39.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-14 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Codigo SAP */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Imprimir Rotulo */
DO:
  ASSIGN radio-set-tipo-rotulo fill-in-oc fill-in-sap fill-in-oc.
  IF radio-set-tipo-rotulo = 1 THEN DO:
      /* Normal */
      RUN carga-info-rotulo.
      RUN imprime-rotulo-zebra.
  END.
  ELSE DO:
      /* Supermercados */
      IF TRUE <> (fill-in-sap > "") THEN DO:
          MESSAGE "Ingrese el codigo de SAP".
          RETURN NO-APPLY.
      END.
      IF TRUE <> (fill-in-oc > "") THEN DO:
          MESSAGE "Ingrese el codigo de SAP".
          RETURN NO-APPLY.
      END.

     RUN carga-info-rotulo-supermercados.
     RUN imprime-rotulo-zebra-supermercados.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-tipo-rotulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-tipo-rotulo D-Dialog
ON VALUE-CHANGED OF RADIO-SET-tipo-rotulo IN FRAME D-Dialog
DO:
  DEFINE VAR x-tipo-rotulo AS CHAR.

  x-tipo-rotulo = radio-set-tipo-rotulo:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  fill-in-oc:VISIBLE IN FRAME {&FRAME-NAME}  = NO.
  fill-in-sap:VISIBLE IN FRAME {&FRAME-NAME}  = NO.

  IF x-tipo-rotulo = '2' THEN DO:
      fill-in-oc:VISIBLE IN FRAME {&FRAME-NAME}  = YES.
      fill-in-sap:VISIBLE IN FRAME {&FRAME-NAME}  = YES.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-14
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-info-rotulo D-Dialog 
PROCEDURE carga-info-rotulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR dPeso        AS DECIMAL   NO-UNDO.
DEFINE VAR cNomChq      AS CHARACTER NO-UNDO.
DEFINE VAR cDir         AS CHARACTER NO-UNDO.
DEFINE VAR cSede        AS CHARACTER NO-UNDO.
DEFINE VAR dFactor      AS DECIMAL   NO-UNDO.

DEFINE VAR lCodRef AS CHAR.
DEFINE VAR lNroRef AS CHAR.
DEFINE VAR lCodDoc AS CHAR.
DEFINE VAR lNroDoc AS CHAR.

DEFINE VAR lCodRef2 AS CHAR.
DEFINE VAR lNroRef2 AS CHAR.

DEFINE VAR x-almfinal AS CHAR.
DEFINE VAR x-cliente-final AS CHAR.
DEFINE VAR x-cliente-intermedio AS CHAR.
DEFINE VAR x-direccion-final AS CHAR.
DEFINE VAR x-direccion-intermedio AS CHAR.

DEFINE BUFFER x-almacen FOR almacen.
DEFINE BUFFER x-pedido FOR faccpedi.
DEFINE BUFFER x-cotizacion FOR faccpedi.

DEFINE VAR i-nro AS INT.

/* Ubico la orden */
FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia
    AND faccpedi.coddoc = pCodDoc
    AND faccpedi.nroped = pNroDoc
    NO-LOCK NO-ERROR.

IF NOT AVAILABLE faccpedi THEN DO:
    MESSAGE "Impsible encontrar el documento".
    RETURN.
END.

cNomCHq = "".
lCodDoc = "".
lNroDoc = "".
/*
FIND FIRST Pl-pers WHERE pl-pers.codcia = s-codcia
    AND Pl-pers.codper = pCodPer NO-LOCK NO-ERROR.
IF AVAILABLE Pl-pers 
    THEN cNomCHq = Pl-pers.codper + "-" + TRIM(Pl-pers.patper) + ' ' +
        TRIM(Pl-pers.matper) + ',' + TRIM(PL-pers.nomper).                
*/
dPeso = 0.      /**ControlOD.PesArt.*/
lCodRef2 = pCoddoc.
lNroRef2 = pNroDoc.

x-cliente-final = faccpedi.nomcli.
x-direccion-final = faccpedi.dircli.
x-cliente-intermedio = "".
x-direccion-intermedio = "".

/* CrossDocking almacen FINAL */
x-almfinal = "".
IF faccpedi.crossdocking = YES THEN DO:
    lCodRef2 = faccpedi.codref.
    lNroRef2 = faccpedi.nroref.
    lCodDoc = "(" + faccpedi.coddoc.
    lNroDoc = faccpedi.nroped + ")".

    x-cliente-intermedio = faccpedi.codcli + " " + faccpedi.nomcli.
    x-direccion-intermedio = faccpedi.dircli.

    IF faccpedi.codref = 'R/A' THEN DO:
        FIND FIRST x-almacen WHERE x-almacen.codcia = s-codcia AND 
                                    x-almacen.codalm = faccpedi.almacenxD
                                    NO-LOCK NO-ERROR.
        IF AVAILABLE x-almacen THEN x-cliente-final = TRIM(x-almacen.descripcion). /*x-almfinal = TRIM(x-almacen.descripcion).*/
        IF AVAILABLE x-almacen THEN x-direccion-final = TRIM(x-almacen.diralm). /*x-almfinal = TRIM(x-almacen.descripcion).*/
    END.
END.
/* Ic - 02Dic2016, si es OTR verificar si no proviene de una PED (pedido) */
/* Si viene de un PED, los datos del cliente deben salir del PEDIDO */
/* Crossdocking */
IF faccpedi.coddoc = 'OTR' AND faccpedi.codref = 'PED' THEN DO:
    lCodDoc = "(" + pCoddoc.
    lNroDoc = pNrodoc + ")".
    lCodRef = faccpedi.codref.
    lNroRef = faccpedi.nroref.
    RELEASE faccpedi.

    FIND faccpedi WHERE faccpedi.codcia = s-codcia
        AND faccpedi.coddoc = lCodRef
        AND faccpedi.nroped = lNroRef
        NO-LOCK NO-ERROR.
    IF NOT AVAIL faccpedi THEN DO:
        MESSAGE "Pedido de Referencia de la OTR no existe" lCodRef lNroRef
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "ADM-ERROR".
    END.
    x-cliente-final = "".
    IF faccpedi.CodDoc = 'OTR' THEN x-cliente-final = faccpedi.codcli + " ".
    x-cliente-final = x-cliente-final + faccpedi.nomcli.
    x-direccion-final = faccpedi.dircli.
END.
/* Ic - 02Dic2016 - FIN */

/* Datos Sede de Venta */
FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = faccpedi.coddiv NO-LOCK NO-ERROR.
IF AVAIL gn-divi THEN 
    ASSIGN 
        cDir = INTEGRAL.GN-DIVI.DirDiv
        cSede = GN-DIVI.CodDiv + " " + INTEGRAL.GN-DIVI.DesDiv.
FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = s-CodAlm
    NO-LOCK NO-ERROR.
IF AVAILABLE Almacen THEN cDir = Almacen.DirAlm.


EMPTY TEMP-TABLE rr-w-report.
i-nro = 0.

/* Rotulos marcados */
FOR EACH tt-w-report WHERE tt-w-report.campo-l[1] = YES :

    /* Peso total del bulto */
    dPeso = peso-total-bulto(tt-w-report.campo-c[1]).

    CREATE rr-w-report.
    ASSIGN         
        i-nro             = i-nro + 1
        rr-w-report.Llave-C  = "01" + faccpedi.nroped
        rr-w-report.Campo-C[1] = faccpedi.ruc
        rr-w-report.Campo-C[2] = x-cliente-final   
        rr-w-report.Campo-C[3] = x-direccion-final  
        rr-w-report.Campo-C[4] = cNomChq
        rr-w-report.Campo-D[1] = faccpedi.fchped
        rr-w-report.Campo-C[5] = '0'    /*STRING(Ccbcbult.bultos,'9999')*/
        rr-w-report.Campo-F[1] = dPeso
        rr-w-report.Campo-C[7] = lCodRef2 + "-" + lNroRef2 /*faccpedi.nroped*/
        rr-w-report.Campo-I[1] = i-nro
        rr-w-report.Campo-C[8] = cDir
        rr-w-report.Campo-C[9] = cSede
        rr-w-report.Campo-C[10] = tt-w-report.campo-c[1] /* ControlOD.NroEtq*/
        rr-w-report.Campo-D[2] = faccpedi.fchent
        rr-w-report.campo-c[11] = TRIM(lCodDoc + " " + lNroDoc)
        rr-w-report.campo-c[12] = x-cliente-intermedio
        rr-w-report.campo-c[13] = STRING(pNroBulto)+ "-" + pGraficoRotulo + "-" + STRING(i-nro,"999")
        .       
    /* Ic - 15Feb2018, jalar la Nro de Orden de Iversa, ListaExpree */
    IF s-coddiv = '00506' THEN DO:
        /* Busco el Pedido */
        FIND FIRST x-pedido WHERE x-pedido.codcia = s-codcia AND 
                                    x-pedido.coddoc = faccpedi.codref AND 
                                    x-pedido.nroped = faccpedi.nroref NO-LOCK NO-ERROR.
        IF AVAILABLE x-pedido THEN DO:
            /* Busco la Cotizacion */
            FIND FIRST x-cotizacion WHERE x-cotizacion.codcia = s-codcia AND 
                                        x-cotizacion.coddoc = x-pedido.codref AND 
                                        x-cotizacion.nroped = x-pedido.nroref NO-LOCK NO-ERROR.
            IF AVAILABLE x-cotizacion THEN DO:
                ASSIGN w-report.campo-c[12] = "PEDIDO WEB :" + TRIM(x-cotizacion.nroref).
            END.
        END.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-info-rotulo-supermercados D-Dialog 
PROCEDURE carga-info-rotulo-supermercados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-descripcion-articulo AS CHAR.
DEFINE VAR x-unidad-medida AS CHAR.
DEFINE VAR x-ean13 AS CHAR.
DEFINE VAR x-nro AS INT.
DEFINE VAR x-cantidad AS DEC.

/* Rotulos marcados */
x-nro = 0.
FOR EACH tt-w-report WHERE tt-w-report.campo-l[1] = YES :
           

    RUN datos-del-articulo(INPUT tt-w-report.campo-c[1], 
                                OUTPUT x-descripcion-articulo,
                                OUTPUT x-unidad-medida,
                                OUTPUT x-ean13, OUTPUT x-cantidad).
    /*
    MESSAGE "Articulo "  tt-w-report.campo-c[1] SKIP
        "Qty " x-cantidad.
    */

    x-nro = x-nro + 1.

    CREATE rr-w-report.
    ASSIGN         
        /*rr-w-report.Llave-C  = "01" + faccpedi.nroped*/
        rr-w-report.Campo-C[1] = STRING(pNroBulto)+ "-" + pGraficoRotulo + "-" + STRING(x-nro,"999")
        rr-w-report.Campo-C[2] = fill-in-oc
        rr-w-report.Campo-C[3] = FILL-in-sap
        rr-w-report.Campo-C[4] = x-descripcion-articulo
        rr-w-report.Campo-C[5] = x-unidad-medida
        rr-w-report.Campo-C[6] = x-ean13.
        rr-w-report.Campo-C[10] = tt-w-report.Campo-C[1].       /* CodMat */
        rr-w-report.Campo-F[1] = x-cantidad
        .       
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE datos-del-articulo D-Dialog 
PROCEDURE datos-del-articulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pBulto AS CHAR.
DEFINE OUTPUT PARAMETER pDescripcionArticulo AS CHAR.
DEFINE OUTPUT PARAMETER pUnidadMedida AS CHAR.
DEFINE OUTPUT PARAMETER pEan13 AS CHAR.
DEFINE OUTPUT PARAMETER pCantidad AS DEC.

pDescripcionArticulo = "".
pUnidadMedida = "".
pEan13 = "".
pCantidad = 0.

DEFINE VAR x-codmat AS CHAR.

DATOS:
FOR EACH tt-items-pickeados WHERE tt-items-pickeados.campo-c[5] = pBulto NO-LOCK :
    x-codmat = tt-items-pickeados.campo-c[1].
    pCantidad = tt-items-pickeados.campo-f[1].

    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND
                                almmmatg.codmat = x-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN DO:
        pDescripcionArticulo = almmmatg.desmat.
        pUnidadMedida = almmmatg.CHR__01.
        IF NOT (TRUE <> (almmmatg.codbrr > "")) THEN DO:
            pEan13 = almmmatg.codbrr.
        END.
    END.
    LEAVE DATOS.
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-oc FILL-IN-sap RADIO-SET-tipo-rotulo 
      WITH FRAME D-Dialog.
  ENABLE BROWSE-14 FILL-IN-oc FILL-IN-sap RADIO-SET-tipo-rotulo Btn_OK 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-rotulo-zebra D-Dialog 
PROCEDURE imprime-rotulo-zebra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND FIRST rr-w-report NO-LOCK NO-ERROR.
IF NOT AVAILABLE rr-w-report THEN DO:
    RETURN.
END.

DEFINE VAR lDireccion1 AS CHAR.
DEFINE VAR lDireccion2 AS CHAR.
DEFINE VAR lDirPart1 AS CHAR.
DEFINE VAR lDirPart2 AS CHAR.
DEFINE VAR lbarra AS CHAR.
DEFINE VAR lSede AS CHAR.
DEFINE VAR lRuc AS CHAR.
DEFINE VAR lpedido AS CHAR.
DEFINE VAR lCliente AS CHAR.
DEFINE VAR lChequeador AS CHAR.
DEFINE VAR lFecha AS DATE.
DEFINE VAR lFechaEnt AS DATE.
DEFINE VAR lEtiqueta AS CHAR.
DEFINE VAR lpeso AS DEC.
DEFINE VAR lBultos AS CHAR.
DEFINE VAR lFiler AS CHAR.
DEFINE VAR lRefOtr AS CHAR.
DEFINE VAR x-almfinal AS CHAR.

DEFINE VAR rpta AS LOG.


SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.

OUTPUT STREAM REPORTE TO PRINTER.

/*
DEFINE VAR x-file-zpl AS CHAR.

x-file-zpl = "d:\tmp\" + REPLACE(pCoddoc,"/","") + "-" + pNroDOc + ".txt".

OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).
*/

FOR EACH rr-w-report WHERE NO-LOCK:

    /* Los valores */
    lDireccion1 = rr-w-report.campo-c[8].
    lSede = rr-w-report.campo-c[9].
    lRuc = rr-w-report.campo-c[1].
    lPedido = rr-w-report.campo-c[7].
    lCliente = rr-w-report.campo-c[2].
    lDireccion2 = rr-w-report.campo-c[3].
    lChequeador = rr-w-report.campo-c[4].
    lFecha = rr-w-report.campo-d[1].
    lFechaEnt = rr-w-report.campo-d[2].
    lEtiqueta = rr-w-report.campo-c[10].
    lPeso = rr-w-report.campo-f[1].
    lBultos = TRIM(rr-w-report.campo-c[13]).  /*STRING(rr-w-report.campo-i[1],"9999") + " / " + rr-w-report.campo-c[5].*/
    lBarra = STRING(rr-w-report.llave-c,"99999999999") + STRING(rr-w-report.campo-i[1],"9999").    
    lRefOtr = TRIM(rr-w-report.campo-c[11]).

    /* Ic - 10Set2018, realmente es el destino Intermedio */
    x-almfinal = TRIM(rr-w-report.campo-c[12]).
    IF s-coddiv <> '00506' THEN DO:
        IF x-almfinal <> "" THEN x-almfinal = "D.INTERMEDIO:" + x-almfinal.
    END.    

    lDireccion2 = TRIM(lDireccion2) + FILL(" ",90).
    lDirPart1 = SUBSTRING(lDireccion2,1,45).
    lDirPart2 = SUBSTRING(lDireccion2,46).

    PUT STREAM REPORTE "^XA^LH010,010" SKIP.

    PUT STREAM REPORTE "^FO025,20" SKIP.
    PUT STREAM REPORTE "^ADN,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "CONTINENTAL S.A.C." SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO035,020" SKIP.
    PUT STREAM REPORTE "^AVN,0,0" SKIP.
    PUT STREAM REPORTE "^FDBULTO : " + rr-w-report.campo-c[1] FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */

    PUT STREAM REPORTE "^FO020,050" SKIP.
    /*PUT STREAM REPORTE "^A0N,30,30" SKIP.*/
    PUT STREAM REPORTE "^AVN,0,0" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "BULTO : " + lBultos FORMAT 'x(67)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO035,130" SKIP.  /*080*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Direccion:" + lDireccion1 FORMAT 'x(67)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,160" SKIP. /*110*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Sede :" + lSede FORMAT 'x(60)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO690,030^BY2" SKIP. 
    PUT STREAM REPORTE "^B3R,N,80,N" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lBarra FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS".

    PUT STREAM REPORTE "^FO035,200" SKIP. /*150*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Nro. " + lPedido FORMAT 'x(40)' SKIP.
    PUT STREAM REPORTE "^FS".

    PUT STREAM REPORTE "^FO400,200" SKIP.  /*150*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "RUC:" + lRuc FORMAT 'x(16)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,250" SKIP.  /*200*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "DESTINO" FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,280" SKIP. /*230*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lCliente FORMAT 'x(50)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,320" SKIP.  /*270*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.  
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lDirPart1 FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,350" SKIP.   /*320*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lDirPart2 FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO035,350" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Chequeador :" + lChequeador FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^FO035,400" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Fecha :" + STRING(lFecha,"99/99/9999") FORMAT 'x(18)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO290,400" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Etiqueta :" + lEtiqueta FORMAT 'x(28)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,450" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "BULTOS :" + lbultos FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO370,450" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "PESO :" + STRING(lPeso,"ZZ,ZZZ,ZZ9.99") FORMAT 'x(19)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,500" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Entrega :" + STRING(lFechaEnt,"99/99/9999") FORMAT 'x(20)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO350,500" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lRefOtr FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,550" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE x-almfinal FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^XZ" SKIP.
END.

OUTPUT STREAM REPORTE CLOSE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-rotulo-zebra-supermercados D-Dialog 
PROCEDURE imprime-rotulo-zebra-supermercados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST rr-w-report NO-LOCK NO-ERROR.
IF NOT AVAILABLE rr-w-report THEN DO:
    RETURN.
END.

OUTPUT STREAM REPORTE CLOSE.

DEFINE VAR rpta AS LOG.
DEFINE VAR x-ean13 AS CHAR.
/*
SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.

OUTPUT STREAM REPORTE TO PRINTER.

*/
DEFINE VAR x-file-zpl AS CHAR.

x-file-zpl = "d:\tmp\" + REPLACE(pCoddoc,"/","") + "-" + pNroDOc + ".txt".

OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).


FOR EACH rr-w-report WHERE NO-LOCK:

    x-ean13 = if(rr-w-report.Campo-C[6] = "") THEN rr-w-report.Campo-C[10] ELSE rr-w-report.Campo-C[6].

    PUT STREAM REPORTE "^XA^LH010,010" SKIP.

    PUT STREAM REPORTE "^XA^LH010,010" SKIP.
    PUT STREAM REPORTE "^FO020,100" SKIP.
    PUT STREAM REPORTE "^GB780,470,3" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO020,160" SKIP.
    PUT STREAM REPORTE "^GB780,0,2" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO020,200" SKIP.
    PUT STREAM REPORTE "^GB780,0,2" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO020,240" SKIP.
    PUT STREAM REPORTE "^GB780,0,2" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO020,280" SKIP.
    PUT STREAM REPORTE "^GB780,0,2" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO020,360" SKIP.
    PUT STREAM REPORTE "^GB780,0,2" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO230,200" SKIP.
    PUT STREAM REPORTE "^GB0,370,2" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO035,020" SKIP.
    PUT STREAM REPORTE "^AVN,0,0" SKIP.
    PUT STREAM REPORTE "^FDBULTO : " + rr-w-report.campo-c[1] FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO130,114" SKIP.
    PUT STREAM REPORTE "^ARN,05,05" SKIP.
    PUT STREAM REPORTE "^FDCONTINENTAL S.A.C.    R.U.C. 20100038146" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO300,165" SKIP.
    PUT STREAM REPORTE "^ARN,05,05" SKIP.
    PUT STREAM REPORTE "^FDO/C " + rr-w-report.Campo-C[2] FORMAT 'x(20)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO030,205" SKIP.
    PUT STREAM REPORTE "^ARN,05,05" SKIP.
    PUT STREAM REPORTE "^FDCODIGO SAP" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO350,205" SKIP.
    PUT STREAM REPORTE "^ARN,05,05" SKIP.
    PUT STREAM REPORTE "^FD" + rr-w-report.Campo-C[3] FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO030,245" SKIP.
    PUT STREAM REPORTE "^ARN,05,05" SKIP.
    PUT STREAM REPORTE "^FDDESCRIPCION" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO250,245" SKIP.
    PUT STREAM REPORTE "^ARN,05,05" SKIP.
    PUT STREAM REPORTE "^FD" + rr-w-report.Campo-C[4] FORMAT 'x(35)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO030,285" SKIP.
    PUT STREAM REPORTE "^ARN,05,05" SKIP.
    PUT STREAM REPORTE "^FDCANTIDAD /" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    PUT STREAM REPORTE "^FO250,305" SKIP.
    PUT STREAM REPORTE "^ARN,05,05" SKIP.
    PUT STREAM REPORTE "^FD" + STRING(rr-w-report.Campo-f[1],">>>,>>9.99") + " " + rr-w-report.Campo-C[5] FORMAT 'X(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO030,325" SKIP.
    PUT STREAM REPORTE "^ARN,05,05" SKIP.
    PUT STREAM REPORTE "^FDUNIDADES" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO045,425" SKIP.
    PUT STREAM REPORTE "^AUN,05,05" SKIP.
    PUT STREAM REPORTE "^FDEAN 13" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO250,380" SKIP.
    PUT STREAM REPORTE "^A0N,50,25" SKIP.
    PUT STREAM REPORTE "^FDPAPEL FOTOCOPIA ATLAS" SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^FO350,400" SKIP.
    PUT STREAM REPORTE "^BEN,100,Y,N" SKIP.
    PUT STREAM REPORTE "^BY3" SKIP.
    PUT STREAM REPORTE "^FD" + x-ean13 FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^XZ" SKIP.

END.

OUTPUT STREAM REPORTE CLOSE.

/*
FIND FIRST rr-w-report NO-LOCK NO-ERROR.
IF NOT AVAILABLE rr-w-report THEN DO:
    RETURN.
END.

DEFINE VAR lDireccion1 AS CHAR.
DEFINE VAR lDireccion2 AS CHAR.
DEFINE VAR lDirPart1 AS CHAR.
DEFINE VAR lDirPart2 AS CHAR.
DEFINE VAR lbarra AS CHAR.
DEFINE VAR lSede AS CHAR.
DEFINE VAR lRuc AS CHAR.
DEFINE VAR lpedido AS CHAR.
DEFINE VAR lCliente AS CHAR.
DEFINE VAR lChequeador AS CHAR.
DEFINE VAR lFecha AS DATE.
DEFINE VAR lFechaEnt AS DATE.
DEFINE VAR lEtiqueta AS CHAR.
DEFINE VAR lpeso AS DEC.
DEFINE VAR lBultos AS CHAR.
DEFINE VAR lFiler AS CHAR.
DEFINE VAR lRefOtr AS CHAR.
DEFINE VAR x-almfinal AS CHAR.

DEFINE VAR rpta AS LOG.


SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
IF rpta = NO THEN RETURN.

OUTPUT STREAM REPORTE TO PRINTER.

/*
DEFINE VAR x-file-zpl AS CHAR.

x-file-zpl = "d:\tmp\" + REPLACE(pCoddoc,"/","") + "-" + pNroDOc + ".txt".

OUTPUT STREAM REPORTE TO VALUE(x-file-zpl).
*/

FOR EACH rr-w-report WHERE NO-LOCK:

    /* Los valores */
    lDireccion1 = rr-w-report.campo-c[8].
    lSede = rr-w-report.campo-c[9].
    lRuc = rr-w-report.campo-c[1].
    lPedido = rr-w-report.campo-c[7].
    lCliente = rr-w-report.campo-c[2].
    lDireccion2 = rr-w-report.campo-c[3].
    lChequeador = rr-w-report.campo-c[4].
    lFecha = rr-w-report.campo-d[1].
    lFechaEnt = rr-w-report.campo-d[2].
    lEtiqueta = rr-w-report.campo-c[10].
    lPeso = rr-w-report.campo-f[1].
    lBultos = TRIM(rr-w-report.campo-c[13]).  /*STRING(rr-w-report.campo-i[1],"9999") + " / " + rr-w-report.campo-c[5].*/
    lBarra = STRING(rr-w-report.llave-c,"99999999999") + STRING(rr-w-report.campo-i[1],"9999").    
    lRefOtr = TRIM(rr-w-report.campo-c[11]).

    /* Ic - 10Set2018, realmente es el destino Intermedio */
    x-almfinal = TRIM(rr-w-report.campo-c[12]).
    IF s-coddiv <> '00506' THEN DO:
        IF x-almfinal <> "" THEN x-almfinal = "D.INTERMEDIO:" + x-almfinal.
    END.    

    lDireccion2 = TRIM(lDireccion2) + FILL(" ",90).
    lDirPart1 = SUBSTRING(lDireccion2,1,45).
    lDirPart2 = SUBSTRING(lDireccion2,46).

    PUT STREAM REPORTE "^XA^LH010,010" SKIP.

    PUT STREAM REPORTE "^FO025,20" SKIP.
    PUT STREAM REPORTE "^ADN,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "CONTINENTAL S.A.C." SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,060" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "BULTO : " + lBultos FORMAT 'x(67)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    
    PUT STREAM REPORTE "^FO035,130" SKIP.  /*080*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Direccion:" + lDireccion1 FORMAT 'x(67)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,160" SKIP. /*110*/
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Sede :" + lSede FORMAT 'x(60)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO690,030^BY2" SKIP. 
    PUT STREAM REPORTE "^B3R,N,80,N" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lBarra FORMAT 'x(15)' SKIP.
    PUT STREAM REPORTE "^FS".

    PUT STREAM REPORTE "^FO035,200" SKIP. /*150*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Nro. " + lPedido FORMAT 'x(40)' SKIP.
    PUT STREAM REPORTE "^FS".

    PUT STREAM REPORTE "^FO400,200" SKIP.  /*150*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "RUC:" + lRuc FORMAT 'x(16)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,250" SKIP.  /*200*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "DESTINO" FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,280" SKIP. /*230*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lCliente FORMAT 'x(50)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,320" SKIP.  /*270*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.  
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lDirPart1 FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,350" SKIP.   /*320*/
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lDirPart2 FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    /*
    PUT STREAM REPORTE "^FO035,350" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Chequeador :" + lChequeador FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.
    */
    PUT STREAM REPORTE "^FO035,400" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Fecha :" + STRING(lFecha,"99/99/9999") FORMAT 'x(18)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO320,400" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Etiqueta :" + lEtiqueta FORMAT 'x(28)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,450" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "BULTOS :" + lbultos FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO350,450" SKIP.
    PUT STREAM REPORTE "^A0N,30,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "PESO :" + STRING(lPeso,"ZZ,ZZZ,ZZ9.99") FORMAT 'x(19)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,500" SKIP.
    PUT STREAM REPORTE "^A0N,35,30" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE "Entrega :" + STRING(lFechaEnt,"99/99/9999") FORMAT 'x(20)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO350,500" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE lRefOtr FORMAT 'x(25)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^FO035,550" SKIP.
    PUT STREAM REPORTE "^A0N,30,20" SKIP.
    PUT STREAM REPORTE "^FD".
    PUT STREAM REPORTE x-almfinal FORMAT 'x(45)' SKIP.
    PUT STREAM REPORTE "^FS" SKIP.

    PUT STREAM REPORTE "^XZ" SKIP.
END.

OUTPUT STREAM REPORTE CLOSE.

*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DEFINE VAR x-sec AS INT.

  REPEAT x-sec = 1 TO pBultos:
      CREATE tt-w-report.
        ASSIGN  tt-w-report.campo-c[1] = pCodDoc + "-" + pNroDOc + "-B" + STRING(x-sec,"999")
                tt-w-report.campo-l[1] = NO 
                tt-w-report.campo-i[1] = x-sec.
  END.
  {&open-query-browse-14}

  fill-in-oc:VISIBLE IN FRAME {&FRAME-NAME}  = NO.
  fill-in-sap:VISIBLE IN FRAME {&FRAME-NAME}  = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN ASSIGN input-var-1 = "".
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION peso-de-articulo D-Dialog 
FUNCTION peso-de-articulo RETURNS DECIMAL
  ( INPUT pCodMat AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR x-retval AS DEC INIT 0.

    DEFINE BUFFER x-almmmatg FOR almmmatg.

    FIND FIRST x-almmmatg WHERE x-almmmatg.codcia = s-codcia AND
                                    x-almmmatg.codmat = pCodMat NO-LOCK NO-ERROR.

    IF AVAILABLE x-almmmatg THEN x-retval = x-almmmatg.pesmat.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION peso-total-bulto D-Dialog 
FUNCTION peso-total-bulto RETURNS DECIMAL
  ( INPUT pBulto AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VAR x-retval AS DEC INIT 0.

  FOR EACH tt-items-pickeados WHERE tt-items-pickeados.campo-c[5] = pBulto NO-LOCK :
      x-retval = x-retval + (tt-items-pickeados.campo-f[1] * peso-de-articulo(tt-items-pickeados.campo-c[1])).
  END.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

