&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-Almmmatg FOR Almmmatg.
DEFINE TEMP-TABLE tmp-tabla NO-UNDO LIKE Almmmatg
       FIELD UM        LIKE Almmmatg.UndA
       FIELD Prevta1   LIKE Almmmatg.Prevta[2]
       FIELD Prevta2   LIKE Almmmatg.Prevta[2]
       INDEX Idx00 AS PRIMARY codcia.



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

&SCOPED-DEFINE precio-venta-general web/PrecioFinalContadoMayorista.p

/* Parameters Definitions ---                                           */

DEF INPUT PARAMETER s-codmat AS CHAR.
DEF INPUT PARAMETER s-codalm AS CHAR.
DEF INPUT PARAMETER s-coddiv AS CHAR.
DEF INPUT PARAMETER s-CodCli AS CHAR.
DEF INPUT PARAMETER s-TpoCmb AS DECI.
DEF INPUT PARAMETER s-FlgSit AS CHAR.
DEF INPUT PARAMETER s-NroDec AS INTE.
DEF INPUT PARAMETER s-AlmDes AS CHAR.
DEF OUTPUT PARAMETER s-UndVta AS CHAR.

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INTE.


DEF VAR x-UM LIKE tmp-tabla.UM NO-UNDO.
DEF VAR x-PreVta1 LIKE tmp-tabla.Prevta1 NO-UNDO.
DEF VAR x-PreVta2 LIKE tmp-tabla.Prevta2 NO-UNDO.

DEFINE NEW SHARED VAR s-acceso-total  AS LOG INIT NO NO-UNDO.

FIND FIRST B-Almmmatg WHERE B-Almmmatg.CodCia = S-CODCIA
    AND B-Almmmatg.codmat = S-CODMAT
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE b-Almmmatg THEN RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tmp-tabla

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tmp-tabla.UM @ x-UM ~
tmp-tabla.PreVta1 @ x-PreVta1 tmp-tabla.PreVta2 @ x-PreVta2 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tmp-tabla NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tmp-tabla NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tmp-tabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tmp-tabla


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-33 RECT-34 RECT-35 RECT-36 RECT-37 ~
BROWSE-2 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS F-descuento F-CODIGO F-ubase F-descrip ~
F-marca F-totstk FILL-IN-flgcomercial F-comprometido F-dispo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE VARIABLE F-CODIGO AS CHARACTER FORMAT "X(256)":U 
     LABEL "Codigo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE F-comprometido AS DECIMAL FORMAT "-zzz,zz9.99":U INITIAL 0 
     LABEL "Stock Comprometido" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .81
     BGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE F-descrip AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descripcion" 
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-descuento AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 51.86 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 1 NO-UNDO.

DEFINE VARIABLE F-dispo AS DECIMAL FORMAT "-zzz,zz9.99":U INITIAL 0 
     LABEL "Stock Disponible" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .81
     BGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE F-marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-totstk AS DECIMAL FORMAT "-zzz,zz9.99":U INITIAL 0 
     LABEL "Stock Actual" 
     VIEW-AS FILL-IN 
     SIZE 11.14 BY .81
     BGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE F-ubase AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unidad Base" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81
     BGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-flgcomercial AS CHARACTER FORMAT "X(25)":U 
     VIEW-AS FILL-IN 
     SIZE 23.86 BY 1.04
     BGCOLOR 15 FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 2.69.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 5.38.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 2.96.

DEFINE RECTANGLE RECT-36
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 3.23.

DEFINE RECTANGLE RECT-37
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 17 BY 15.62.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      tmp-tabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      tmp-tabla.UM @ x-UM COLUMN-LABEL "UM!Venta" FORMAT "x(8)":U
            WIDTH 7.43
      tmp-tabla.PreVta1 @ x-PreVta1 COLUMN-LABEL "Precio!Venta S/"
            WIDTH 11.86
      tmp-tabla.PreVta2 @ x-PreVta2 COLUMN-LABEL "Precio!Venta U$"
            WIDTH 10.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 34 BY 4.5
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     BROWSE-2 AT ROW 1.54 COL 12 WIDGET-ID 200
     Btn_OK AT ROW 1.54 COL 68
     Btn_Cancel AT ROW 3.42 COL 68
     F-descuento AT ROW 6.65 COL 3 NO-LABEL WIDGET-ID 20
     F-CODIGO AT ROW 7.85 COL 10.72 COLON-ALIGNED WIDGET-ID 2
     F-ubase AT ROW 7.85 COL 34.57 COLON-ALIGNED WIDGET-ID 8
     F-descrip AT ROW 8.77 COL 10.72 COLON-ALIGNED WIDGET-ID 4
     F-marca AT ROW 9.73 COL 10.72 COLON-ALIGNED WIDGET-ID 6
     F-totstk AT ROW 11 COL 16.86 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-flgcomercial AT ROW 11.88 COL 28.57 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     F-comprometido AT ROW 11.96 COL 16.86 COLON-ALIGNED WIDGET-ID 10
     F-dispo AT ROW 12.88 COL 16.86 COLON-ALIGNED WIDGET-ID 12
     "            F10 - Consulta Descuentos X Promocion" VIEW-AS TEXT
          SIZE 63.29 BY .54 AT ROW 15.92 COL 3 WIDGET-ID 28
          FONT 6
     "Indicador comercial" VIEW-AS TEXT
          SIZE 16.14 BY .5 AT ROW 11.35 COL 30.86 WIDGET-ID 18
          FGCOLOR 4 FONT 6
     "            F8 - Consulta de Stocks por Almacen" VIEW-AS TEXT
          SIZE 62.86 BY .5 AT ROW 14.69 COL 3.29 WIDGET-ID 22
          FONT 6
     "            F7 - Stocks Comprometidos por Pedidos" VIEW-AS TEXT
          SIZE 62.86 BY .5 AT ROW 14.19 COL 3.29 WIDGET-ID 24
          FONT 6
     "            F9 - Consulta Descuentos X Volumen" VIEW-AS TEXT
          SIZE 63.29 BY .54 AT ROW 15.38 COL 3 WIDGET-ID 26
          FONT 6
     RECT-33 AT ROW 13.92 COL 2 WIDGET-ID 30
     RECT-34 AT ROW 1 COL 2 WIDGET-ID 32
     RECT-35 AT ROW 7.73 COL 2 WIDGET-ID 34
     RECT-36 AT ROW 10.69 COL 2 WIDGET-ID 36
     RECT-37 AT ROW 1 COL 67 WIDGET-ID 38
     SPACE(1.71) SKIP(0.29)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Unidades de Venta"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-Almmmatg B "?" ? INTEGRAL Almmmatg
      TABLE: tmp-tabla T "?" NO-UNDO INTEGRAL Almmmatg
      ADDITIONAL-FIELDS:
          FIELD UM        LIKE Almmmatg.UndA
          FIELD Prevta1   LIKE Almmmatg.Prevta[2]
          FIELD Prevta2   LIKE Almmmatg.Prevta[2]
          INDEX Idx00 AS PRIMARY codcia
      END-FIELDS.
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
   NOT-VISIBLE FRAME-NAME                                               */
/* BROWSE-TAB BROWSE-2 RECT-37 D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-CODIGO IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-comprometido IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-descrip IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-descuento IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-dispo IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-marca IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-totstk IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ubase IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-flgcomercial IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tmp-tabla"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"tmp-tabla.UM @ x-UM" "UM!Venta" "x(8)" ? ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"tmp-tabla.PreVta1 @ x-PreVta1" "Precio!Venta S/" ? ? ? ? ? ? ? ? no ? no no "11.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"tmp-tabla.PreVta2 @ x-PreVta2" "Precio!Venta U$" ? ? ? ? ? ? ? ? no ? no no "10.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Unidades de Venta */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
  IF AVAILABLE tmp-tabla THEN s-UndVta = tmp-tabla.UM.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* **************************  Main Block  *************************** */
ON 'RETURN' OF {&browse-name} 
DO:
    APPLY 'CHOOSE':U TO Btn_OK.
END.


ON F7 ANYWHERE 
DO:
    ASSIGN
        input-var-1 = s-codalm
        input-var-2 = s-codmat
        input-var-3 = ''.
    RUN vtagn/c-conped.
END.

ON F8 OF {&browse-name} ANYWHERE
DO:
  ASSIGN
      input-var-1 = s-codmat
      input-var-2 = ''
      input-var-3 = ''.
  RUN vtagn/d-almmmate-02-v2.
  /*RUN web/d-almmmate-solo-stock.w.*/
END.

ON F9 ANYWHERE
DO:
  /*RUN Vta/D-Dtovol2.r(trim(s-codmat) ).*/
  RUN web/d-consulta-dcto-vol-may (s-codmat,
                                   s-codalm,
                                   s-coddiv,
                                   s-codcli,
                                   s-tpocmb,
                                   s-flgsit,
                                   s-nrodec,
                                   s-almdes,
                                   B-Almmmatg.CHR__01).
END.

ON F10 ANYWHERE
DO:
  /*RUN Vta/D-Dtoprom2.r(trim(s-codmat) ).*/
    RUN web/d-consulta-dcto-prom-may (s-codmat,
                                     s-codalm,
                                     s-coddiv,
                                     s-codcli,
                                     s-tpocmb,
                                     s-flgsit,
                                     s-nrodec,
                                     s-almdes,
                                     B-Almmmatg.CHR__01).
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal D-Dialog 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* STOCK COMPROMETIDO */
DEF VAR j AS INT NO-UNDO.
DEF VAR x-CanPed AS DECI NO-UNDO.
DEF VAR pPreVta AS DECI NO-UNDO.

RUN gn/stock-comprometido-v2 (s-codmat, ENTRY(1, s-codalm), YES, OUTPUT x-CanPed).
/*****/

EMPTY TEMP-TABLE tmp-tabla.

FIND FIRST B-Almmmatg WHERE B-Almmmatg.CodCia = S-CODCIA
    AND (B-Almmmatg.codmat = S-CODMAT)
    NO-LOCK NO-ERROR.
IF AVAIL B-Almmmatg THEN DO:
    ASSIGN
        F-CODIGO    = B-Almmmatg.codmat  
        F-descrip   = B-Almmmatg.DesMat
        F-marca     = B-Almmmatg.DesMar
        F-ubase     = B-Almmmatg.UndBas
        F-comprometido = X-CanPed
        F-totstk    = 0.
    /* solo el almacén principal */
    FIND almmmate WHERE Almmmate.CodCia = B-Almmmatg.CodCia
        AND  Almmmate.CodAlm = ENTRY(1, s-codalm)
        AND  Almmmate.codmat = B-Almmmatg.codmat
        NO-LOCK NO-ERROR.
    IF AVAILABLE almmmate THEN F-totstk = f-TotStk + Almmmate.StkAct.
    ASSIGN F-dispo = F-totstk - X-CanPed.
    /****   PRECIO A    ****/
    IF B-Almmmatg.UndA > "" THEN DO:
        CREATE tmp-tabla.
        ASSIGN tmp-tabla.codcia = j.
        ASSIGN 
            tmp-tabla.UM = B-Almmmatg.UndA
            tmp-tabla.dsctos = B-Almmmatg.dsctos[1].
        RUN Precio-Unitario (1, B-Almmmatg.UndA, OUTPUT tmp-tabla.Prevta1).
        RUN Precio-Unitario (2, B-Almmmatg.UndA, OUTPUT tmp-tabla.Prevta2).
    END.
    /****   PRECIO B    ****/
    IF B-Almmmatg.UndB > "" THEN DO:
        CREATE tmp-tabla.
        j = j + 1.
        ASSIGN tmp-tabla.codcia = j.
        ASSIGN 
            tmp-tabla.UM = B-Almmmatg.UndB
            tmp-tabla.dsctos = B-Almmmatg.dsctos[2].
        RUN Precio-Unitario (1, B-Almmmatg.UndB, OUTPUT tmp-tabla.Prevta1).
        RUN Precio-Unitario (2, B-Almmmatg.UndB, OUTPUT tmp-tabla.Prevta2).
    END.
    /****   PRECIO C    ****/
    IF B-Almmmatg.UndC > "" THEN DO:
        CREATE tmp-tabla.
        j = j + 1.
        ASSIGN tmp-tabla.codcia = j.
        ASSIGN 
            tmp-tabla.UM     = B-Almmmatg.UndC
            tmp-tabla.dsctos = B-Almmmatg.dsctos[3].
        RUN Precio-Unitario (1, B-Almmmatg.UndC, OUTPUT tmp-tabla.Prevta1).
        RUN Precio-Unitario (2, B-Almmmatg.UndC, OUTPUT tmp-tabla.Prevta2).
    END.
    /************Descuento Promocional ************/
    DEFINE VAR X-PROMO AS CHAR INIT "".
    FIND FIRST VtaTabla WHERE VtaTabla.CodCia = B-Almmmatg.CodCia
        AND VtaTabla.Llave_c1 = B-Almmmatg.codmat
        AND VtaTabla.Tabla = "DTOPROLIMA"
        AND VtaTabla.Llave_c2 = s-coddiv
        AND TODAY >=  VtaTabla.Rango_fecha[1] 
        AND TODAY <= VtaTabla.Rango_fecha[2]
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN X-PROMO = "Promocional ".
    /************************************************/
 
    /***************Descuento Volumen****************/                    
     DEFINE VAR X-VOLU AS CHAR INIT "".
     DO J = 1 TO 10 :
        IF  B-Almmmatg.DtoVolD[J] > 0  THEN X-VOLU = "Volumen " .                 
     END.        
    /************************************************/

    DO WITH FRAME {&FRAME-NAME}:
       F-DESCUENTO = "". 
       IF X-PROMO <> "" THEN F-DESCUENTO = "Producto con Descuento " + X-PROMO. 
       IF X-VOLU  <> "" THEN F-DESCUENTO = "Producto con Descuento " + X-VOLU.
       IF X-PROMO <> "" AND X-VOLU <> "" THEN F-DESCUENTO = "Producto con Descuento " + X-PROMO + " y " + X-VOLU.
       F-DESCUENTO:BGCOLOR = 8 .
       F-DESCUENTO:FGCOLOR = 8 .
       
       IF F-DESCUENTO <> "" THEN DO WITH FRAME {&FRAME-NAME}:
          F-DESCUENTO:BGCOLOR = 12 .
          F-DESCUENTO:FGCOLOR = 15 .
          DISPLAY F-DESCUENTO @ F-DESCUENTO.
       END. 
    END.
END.

END PROCEDURE.

PROCEDURE Precio-Unitario:
/* *********************** */

    DEF INPUT PARAMETER s-CodMon AS INTE.
    DEF INPUT PARAMETER s-UndVta AS CHAR.
    DEF OUTPUT PARAMETER f-PreVta AS DECI.
    
    DEF VAR f-Factor AS DECI NO-UNDO.
    DEF VAR f-PreBas AS DECI NO-UNDO.
    DEF VAR f-Dsctos AS DECI NO-UNDO.
    DEF VAR y-Dsctos AS DECI NO-UNDO.
    DEF VAR x-TipDto AS CHAR NO-UNDO.
    DEF VAR f-FleteUnitario AS DECI NO-UNDO.

    DEF VAR x-PreVta AS DECI NO-UNDO.
    DEF VAR pMensaje AS CHAR NO-UNDO.

    RUN {&precio-venta-general} (s-CodCia,
                                 s-CodDiv,
                                 s-CodCli,
                                 s-CodMon,
                                 s-TpoCmb,
                                 OUTPUT f-Factor,
                                 s-CodMat,
                                 s-FlgSit,
                                 s-UndVta,
                                 1,
                                 s-NroDec,
                                 s-AlmDes,   /* Necesario para REMATES */
                                 OUTPUT f-PreBas,
                                 OUTPUT x-PreVta,
                                 OUTPUT f-Dsctos,
                                 OUTPUT y-Dsctos,
                                 OUTPUT x-TipDto,
                                 OUTPUT f-FleteUnitario,
                                 OUTPUT pMensaje
                                 ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN x-PreVta = 0.
    f-PreVta = x-PreVta.

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
  DISPLAY F-descuento F-CODIGO F-ubase F-descrip F-marca F-totstk 
          FILL-IN-flgcomercial F-comprometido F-dispo 
      WITH FRAME D-Dialog.
  ENABLE RECT-33 RECT-34 RECT-35 RECT-36 RECT-37 BROWSE-2 Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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
  RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE b-almmmatg THEN DO:
      FIND FIRST almtabla WHERE almtabla.tabla = "IN_CO" AND
          almtabla.codigo = b-almmmatg.flgcomercial NO-LOCK NO-ERROR.
      IF AVAILABLE almtabla THEN DO:
          fill-in-flgcomercial:SCREEN-VALUE IN FRAME {&FRAME-NAME} = CAPS(almtabla.nombre).
      END.
  END.

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
  {src/adm/template/snd-list.i "tmp-tabla"}

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

