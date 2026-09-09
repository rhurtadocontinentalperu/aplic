&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDocu FOR CcbCDocu.
DEFINE BUFFER bGN-DIVI FOR GN-DIVI.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.



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
DEF SHARED VAR cl-codcia AS INT.

DEF VAR x-Divisiones AS CHAR NO-UNDO.

DEF TEMP-TABLE Detalle
    FIELD CodMat    AS CHAR     FORMAT 'x(8)'       LABEL 'CODMAT'
    FIELD DesMat    AS CHAR     FORMAT 'x(100)'     LABEL 'DESMAT'
    FIELD CodDoc    AS CHAR     FORMAT 'x(5)'       LABEL 'CODDOC'
    FIELD NroDoc    AS CHAR     FORMAT 'x(15)'      LABEL 'NRODOC'
    FIELD CodCli    AS CHAR     FORMAT 'x(15)'      LABEL 'CODCLI'
    FIELD NomCli    AS CHAR     FORMAT 'x(100)'     LABEL 'RAZON SOCIAL'
    FIELD FchDoc    AS DATE     FORMAT '99/99/9999' LABEL 'FECHA FACT'
    FIELD UndVta    AS CHAR     FORMAT 'x(8)'       LABEL 'UNDVTA'
    FIELD CanDes    AS DECI     FORMAT '->>>,>>9.99' LABEL 'CANTIDAD'
    FIELD Moneda    AS CHAR     FORMAT 'x(5)'       LABEL 'MONEDA'
    FIELD Pedido    AS CHAR     FORMAT 'x(15)'      LABEL '# PEDIDO COMERCIAL'
    FIELD Orden     AS CHAR     FORMAT 'x(15)'      LABEL '# O/D'
    FIELD ImpPed    AS DECI     FORMAT '->>>>,>>9.99' LABEL 'IMPORTE PEDIDO COMERCIAL'
    FIELD CtoKar    AS DECI     FORMAT '->>>,>>9.99' LABEL 'COSTO KARDEX'
    FIELD ValVta    AS DECI     FORMAT '->>>,>>9.99' LABEL 'V.VTA NETO'
    FIELD Importe   AS DECI     FORMAT '->>>>,>>9.99' LABEL 'P.VTA'
    FIELD Guia      AS CHAR     FORMAT 'x(15)'      LABEL 'GUIA'
    FIELD FchEmi    AS DATE     FORMAT '99/99/9999' LABEL 'FECHA G/R'
    FIELD ImpBrt    AS DECI     FORMAT '->>>>,>>9.99' LABEL 'V.VTA BRUTO'
    FIELD PorDto    AS DECI     FORMAT '->>>,>>9.99' LABEL '% DSCTO'
    FIELD DesMar    AS CHAR     FORMAT 'x(20)'      LABEL 'MARCA'
    FIELD CodFam    AS CHAR     FORMAT 'x(8)'       LABEL 'CODFAM PROD'
    FIELD DesFam    AS CHAR     FORMAT 'x(40)'      LABEL 'DESFAM PROD'
    FIELD DivOri    AS CHAR     FORMAT 'x(8)'       LABEL 'DIVISION VTA'
    FIELD DesDiv    AS CHAR     FORMAT 'x(40)'      LABEL 'NOMBRE DIV'
    FIELD NomVen    AS CHAR     FORMAT 'x(80)'      LABEL 'NOM VENDEDOR'
    .

DEF TEMP-TABLE Resumen
    FIELD CodDoc    AS CHAR     FORMAT 'x(5)'       LABEL 'CODDOC'
    FIELD NroDoc    AS CHAR     FORMAT 'x(15)'      LABEL 'NRODOC'
    FIELD CodCli    AS CHAR     FORMAT 'x(15)'      LABEL 'CODCLI'
    FIELD NomCli    AS CHAR     FORMAT 'x(100)'     LABEL 'RAZON SOCIAL'
    FIELD FchDoc    AS DATE     FORMAT '99/99/9999' LABEL 'FECHA FACT'
    FIELD Moneda    AS CHAR     FORMAT 'x(5)'       LABEL 'MONEDA'
    FIELD TpoCmb    AS DECI     FORMAT '>>>,>>9.99' LABEL 'T/C VTA'
    FIELD Pedido    AS CHAR     FORMAT 'x(15)'      LABEL '# PEDIDO COMERCIAL'
    FIELD ClfCli    AS CHAR     FORMAT 'x(8)'       LABEL 'CAT CLIENTE'
    FIELD CtoKar    AS DECI     FORMAT '->>>,>>9.99' LABEL 'COSTO KARDEX'
/* 30/07/2026: Michael Poma */
    FIELD impbrt    AS DECI     FORMAT '->>>,>>>,>>9.99'    LABEL 'Imp Bruto'
    FIELD impdto    AS DECI     FORMAT '->>>,>>>,>>9.99'    LABEL 'Imp Dscto'
    FIELD impexo    AS DECI     FORMAT '->>>,>>>,>>9.99'    LABEL 'Imp Exonerado'
    FIELD impvta    AS DECI     FORMAT '->>>,>>>,>>9.99'    LABEL 'Imp Venta'
    FIELD impigv    AS DECI     FORMAT '->>>,>>>,>>9.99'    LABEL 'Imp I.G.V.'
    FIELD imptot    AS DECI     FORMAT '->>>,>>>,>>9.99'    LABEL 'Sin Percepcion'
    FIELD percepcion AS DECI    FORMAT '->>>,>>>,>>9.99'    LABEL 'Percepcion'
    FIELD totales   AS DECI     FORMAT '->>>,>>>,>>9.99'    LABEL 'Imp Total'
    FIELD estado    AS CHAR     FORMAT 'x(15)'              LABEL 'Estado'

    FIELD DivOri    AS CHAR     FORMAT 'x(8)'       LABEL 'DIVISION VTA'
    FIELD DesOri    AS CHAR     FORMAT 'x(40)'      LABEL 'NOMBRE DIV'
    FIELD NomVen    AS CHAR     FORMAT 'x(80)'      LABEL 'NOM VENDEDOR'

/* 30/07/2026: Michael Poma */
    FIELD DivDes    AS CHAR     FORMAT 'x(8)'       LABEL 'DIVISION DESPACHO'
    FIELD NomDes    AS CHAR     FORMAT 'x(80)'      LABEL 'NOM DIVISION DESPACHO'

    .

DEFINE IMAGE IMAGE-1 FILENAME "IMG\AUXILIAR" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR NO-UNDO.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
    SKIP
    Fi-Mensaje FORMAT 'x(50)' NO-LABEL FONT 6
    SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
    BGCOLOR 15 FGCOLOR 0 
    TITLE "Procesando ..." FONT 7.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 BUTTON-3 x-codcli x-CodMat x-desde ~
x-hasta TOGGLE_Resumido btn-excel btn-exit 
&Scoped-Define DISPLAYED-OBJECTS EDITOR_Divisiones x-codcli x-nomcli ~
x-CodMat x-DesMat x-desde x-hasta TOGGLE_Resumido x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-excel 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Button 1" 
     SIZE 8 BY 1.62 TOOLTIP "Exportar a Texto".

DEFINE BUTTON btn-exit 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 2" 
     SIZE 8 BY 1.62.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/search.ico":U
     LABEL "Button 3" 
     SIZE 7 BY 1.62.

DEFINE VARIABLE EDITOR_Divisiones AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 42 BY 4.31
     BGCOLOR 14 FGCOLOR 0 FONT 4 NO-UNDO.

DEFINE VARIABLE x-codcli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE x-CodMat AS CHARACTER FORMAT "X(6)":U 
     LABEL "Producto" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE x-DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY 1 NO-UNDO.

DEFINE VARIABLE x-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 66.29 BY .88 NO-UNDO.

DEFINE VARIABLE x-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 73 BY 1.88
     BGCOLOR 9 .

DEFINE VARIABLE TOGGLE_Resumido AS LOGICAL INITIAL no 
     LABEL "SOLO RESUMIDO" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY 1.35
     FONT 8 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     EDITOR_Divisiones AT ROW 1.27 COL 13 NO-LABEL WIDGET-ID 26
     BUTTON-3 AT ROW 1.27 COL 57 WIDGET-ID 24
     x-codcli AT ROW 5.58 COL 14 COLON-ALIGNED WIDGET-ID 2
     x-nomcli AT ROW 5.58 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     x-CodMat AT ROW 6.73 COL 14 COLON-ALIGNED WIDGET-ID 20
     x-DesMat AT ROW 6.73 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     x-desde AT ROW 7.88 COL 14 COLON-ALIGNED WIDGET-ID 6
     x-hasta AT ROW 7.88 COL 36 COLON-ALIGNED WIDGET-ID 8
     TOGGLE_Resumido AT ROW 9.62 COL 22 WIDGET-ID 30
     x-mensaje AT ROW 11.23 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     btn-excel AT ROW 12.42 COL 57.29 WIDGET-ID 10
     btn-exit AT ROW 12.42 COL 65.72 WIDGET-ID 12
     "Divisiones:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 1.27 COL 3 WIDGET-ID 28
     RECT-1 AT ROW 12.31 COL 2 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 75.29 BY 13.38 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDocu B "?" ? INTEGRAL CcbCDocu
      TABLE: bGN-DIVI B "?" ? INTEGRAL GN-DIVI
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "VENTAS POR CLIENTE"
         HEIGHT             = 13.38
         WIDTH              = 75.29
         MAX-HEIGHT         = 14.35
         MAX-WIDTH          = 86.14
         VIRTUAL-HEIGHT     = 14.35
         VIRTUAL-WIDTH      = 86.14
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR EDITOR EDITOR_Divisiones IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* VENTAS POR CLIENTE */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* VENTAS POR CLIENTE */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-excel W-Win
ON CHOOSE OF btn-excel IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN EDITOR_Divisiones TOGGLE_Resumido x-codcli x-CodMat x-desde x-hasta.

    IF TRUE <> (EDITOR_Divisiones > '') THEN NEXT.

    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    /* Cargamos la informacion al temporal */
    SESSION:SET-WAIT-STATE('GENERAL').

    RUN Carga-Temporal.

    /* Programas que generan el Excel */
    DISPLAY "GENERANDO TEXTO" @ fi-Mensaje WITH FRAME f-Proceso.

    cArchivo = LC(pArchivo).
    IF INDEX(pOptions, 'FileType:XLS') > 0 THEN SESSION:DATE-FORMAT = "mdy".
    CASE TOGGLE_Resumido:
        WHEN YES THEN RUN lib/tt-filev2 (TEMP-TABLE Resumen:HANDLE, cArchivo, pOptions).
        WHEN NO  THEN RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    END CASE.
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    SESSION:SET-WAIT-STATE('').
    HIDE FRAME f-Proceso.
    MESSAGE 'Proceso Concluido' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-exit W-Win
ON CHOOSE OF btn-exit IN FRAME F-Main /* Button 2 */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  x-Divisiones = EDITOR_Divisiones:SCREEN-VALUE.
  RUN gn/d-selecciona-divisiones (OUTPUT x-Divisiones).
  EDITOR_Divisiones:SCREEN-VALUE = x-Divisiones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-codcli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-codcli W-Win
ON LEAVE OF x-codcli IN FRAME F-Main /* Cliente */
DO:

  ASSIGN {&SELF-NAME}.
  FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = {&SELF-NAME} NO-LOCK NO-ERROR.
  IF AVAIL gn-clie THEN DISPLAY gn-clie.nomcli @ x-nomcli WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodMat W-Win
ON LEAVE OF x-CodMat IN FRAME F-Main /* Producto */
DO:
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
      AND Almmmatg.codmat = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg THEN x-DesMat:SCREEN-VALUE = ALmmmatg.desmat.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle W-Win 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Detalle.

DEF VAR cDesMat AS CHAR NO-UNDO.
DEF VAR cDesMar AS CHAR NO-UNDO.
DEF VAR cMoneda AS CHAR NO-UNDO.
DEF VAR dSigno AS INTE NO-UNDO.
DEF VAR cCodFam AS CHAR NO-UNDO.
DEF VAR cDesFam AS CHAR NO-UNDO.
DEF VAR iItems AS INTE NO-UNDO.

FOR EACH gn-divi FIELD(codcia coddiv) NO-LOCK WHERE gn-divi.codcia = s-codcia AND
    LOOKUP(gn-divi.coddiv, EDITOR_Divisiones) > 0:
    FOR EACH ccbcdocu USE-INDEX llave10 NO-LOCK WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.coddiv = gn-divi.coddiv 
        AND ccbcdocu.fchdoc >= x-desde:
        /* FILTROS */
        IF ccbcdocu.fchdoc > x-hasta THEN LEAVE.
        IF LOOKUP(TRIM(ccbcdocu.coddoc),"FAC,BOL,N/C,N/D") = 0 THEN NEXT.
        IF ccbcdocu.flgest = "A" THEN NEXT.
        IF x-CodCli > '' AND Ccbcdocu.codcli <> x-CodCli THEN NEXT.
        /* ******* */
        iItems = iItems + 1.
        IF iItems MODULO 100 = 0 THEN DO:
            Fi-Mensaje = Ccbcdocu.coddiv + " " + STRING(Ccbcdocu.fchdoc) + " " +
                Ccbcdocu.coddoc + Ccbcdocu.nrodoc.
            DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
        END.
        /* ******* */
        IF CcbCDocu.CodMon = 1 THEN cMoneda = "PEN". ELSE cMoneda = "USD".
        IF CcbCDocu.CodDoc = "N/C" THEN dSigno = -1. ELSE dSigno = 1.
        FIND PEDIDO WHERE PEDIDO.codcia = s-codcia AND
            PEDIDO.coddoc = Ccbcdocu.codped AND                 /* PED */
            PEDIDO.nroped = Ccbcdocu.nroped NO-LOCK NO-ERROR.
        IF AVAILABLE PEDIDO THEN DO:
            FIND COTIZACION WHERE COTIZACION.codcia = s-codcia AND
                COTIZACION.coddoc = PEDIDO.codref AND
                COTIZACION.nroped = PEDIDO.nroref NO-LOCK NO-ERROR.
        END.
        FIND bGN-DIVI WHERE bGN-DIVI.codcia = s-codcia AND
            bGN-DIVI.coddiv = Ccbcdocu.divori NO-LOCK NO-ERROR.
        FIND gn-ven WHERE gn-ven.codcia = s-codcia AND
            gn-ven.codven = Ccbcdocu.codven NO-LOCK NO-ERROR.
        IF Ccbcdocu.codref = "G/R" THEN DO:
            FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia
                AND B-CDOCU.coddoc = Ccbcdocu.codref
                AND B-CDOCU.nrodoc = Ccbcdocu.nroref
                NO-LOCK NO-ERROR.
        END.

        FOR EACH ccbddocu OF ccbcdocu NO-LOCK WHERE (TRUE <> (x-codmat > "") OR Ccbddocu.codmat = x-codmat):
            cDesMat = "".
            cDesMar = "".
            cCodFam = "".
            cDesFam = "".
            CASE TRUE:
                WHEN Ccbcdocu.CodDoc = "N/D" OR 
                    (Ccbcdocu.coddoc = "N/C" AND Ccbcdocu.CndCre <> "D") THEN DO:
                    /* NO por devolución de mercadería => Financieras */
                    FIND CcbTabla WHERE CcbTabla.CodCia = s-codcia
                        AND CcbTabla.Tabla  = ccbcdocu.coddoc
                        AND CcbTabla.Codigo = ccbddocu.codmat NO-LOCK NO-ERROR.
                    IF AVAIL CcbTabla THEN cDesMat = CcbTabla.Nombre.                
                END.
                OTHERWISE DO:
                    FIND almmmatg WHERE almmmatg.codcia = s-codcia
                        AND almmmatg.codmat = ccbddocu.codmat NO-LOCK NO-ERROR.
                    IF AVAIL almmmatg THEN DO:
                        cDesMat = Almmmatg.DesMat.
                        cDesMar = Almmmatg.DesMar.
                        FIND Almtfami OF Almmmatg NO-LOCK NO-ERROR.
                        IF AVAILABLE Almtfami THEN ASSIGN cCodFam = Almtfami.codfam cDesFam = Almtfami.desfam.
                    END.
                END.
            END CASE.

            CREATE Detalle.
            ASSIGN
                Detalle.CodMat    = Ccbddocu.codmat
                Detalle.DesMat    = cDesMat
                Detalle.CodDoc    = Ccbddocu.coddoc
                Detalle.NroDoc    = Ccbddocu.nrodoc
                Detalle.CodCli    = Ccbcdocu.codcli
                Detalle.NomCli    = Ccbcdocu.nomcli
                Detalle.FchDoc    = Ccbcdocu.fchdoc
                Detalle.UndVta    = Ccbddocu.undvta
                Detalle.CanDes    = Ccbddocu.candes * dSigno
                Detalle.Moneda    = cMoneda
                .
            IF AVAILABLE PEDIDO THEN DO:
                ASSIGN
                    Detalle.Orden = Ccbcdocu.Libre_c02.
                IF AVAILABLE COTIZACION THEN DO:
                    ASSIGN
                        Detalle.Pedido = COTIZACION.NroPed
                        Detalle.ImpPed = COTIZACION.ImpTot.
                END.
            END.
            FIND LAST Almstkge USE-INDEX Llave01 WHERE Almstkge.codcia = s-codcia AND
                Almstkge.codmat = Ccbddocu.codmat AND
                Almstkge.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
            IF AVAILABLE Almstkge THEN DO:
                ASSIGN
                    Detalle.CtoKar = Almstkge.ctouni * Ccbddocu.candes * Ccbddocu.factor * dSigno.
            END.
            ASSIGN
                Detalle.ValVta    = CcbDDocu.ImporteTotalSinImpuesto * dSigno.
            ASSIGN
                Detalle.Importe   = CcbDDocu.cImporteTotalConImpuesto * dSigno
                Detalle.CodFam    = cCodFam
                Detalle.DesFam    = cDesFam
                Detalle.DivOri    = Ccbcdocu.divori
                .
            IF AVAILABLE bGN-DIVI THEN Detalle.DesDiv = bGN-DIVI.desdiv.
            IF AVAILABLE gn-ven THEN Detalle.nomven = gn-ven.NomVen.
            IF Ccbcdocu.codref = "G/R" THEN DO:
                Detalle.Guia = Ccbcdocu.nroref.
                IF AVAILABLE B-CDOCU THEN Detalle.FchEmi = B-CDOCU.FchDoc.
            END.
            ASSIGN
                Detalle.ImpBrt    = (CcbDDocu.ImpLin + CcbDDocu.ImpDto) * dSigno
                Detalle.PorDto    = CcbDDocu.por_dsctos[3]
                Detalle.DesMar    = cDesMar.
        END.
    END.
END.
HIDE FRAME F-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Resumen W-Win 
PROCEDURE Carga-Resumen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE Resumen.

DEF VAR cMoneda AS CHAR NO-UNDO.
DEF VAR dSigno AS INTE NO-UNDO.
DEF VAR iItems AS INTE NO-UNDO.
DEF VAR x-Factor AS DEC NO-UNDO.
DEF VAR cTexto AS CHAR NO-UNDO.

FOR EACH gn-divi FIELD(codcia coddiv) NO-LOCK WHERE gn-divi.codcia = s-codcia AND
    LOOKUP(gn-divi.coddiv, EDITOR_Divisiones) > 0:
    FOR EACH ccbcdocu USE-INDEX llave10 NO-LOCK WHERE ccbcdocu.codcia = s-codcia
        AND ccbcdocu.coddiv = gn-divi.coddiv 
        AND ccbcdocu.fchdoc >= x-desde:
        /* FILTROS */
        IF ccbcdocu.fchdoc > x-hasta THEN LEAVE.
        IF LOOKUP(TRIM(ccbcdocu.coddoc),"FAC,BOL,N/C,N/D") = 0 THEN NEXT.
        IF ccbcdocu.flgest = "A" THEN NEXT.
        IF x-CodCli > '' AND Ccbcdocu.codcli <> x-CodCli THEN NEXT.
        /* ******* */
        iItems = iItems + 1.
        IF iItems MODULO 100 = 0 THEN DO:
            Fi-Mensaje = Ccbcdocu.coddiv + " " + STRING(Ccbcdocu.fchdoc) + " " +
                Ccbcdocu.coddoc + Ccbcdocu.nrodoc.
            DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
        END.
        /* ******* */
        IF CcbCDocu.CodMon = 1 THEN cMoneda = "PEN". ELSE cMoneda = "USD".
        IF CcbCDocu.CodDoc = "N/C" THEN dSigno = -1. ELSE dSigno = 1.
        FIND PEDIDO WHERE PEDIDO.codcia = s-codcia AND
            PEDIDO.coddoc = Ccbcdocu.codped AND                 /* PED */
            PEDIDO.nroped = Ccbcdocu.nroped NO-LOCK NO-ERROR.
        IF AVAILABLE PEDIDO THEN DO:
            FIND COTIZACION WHERE COTIZACION.codcia = s-codcia AND
                COTIZACION.coddoc = PEDIDO.codref AND
                COTIZACION.nroped = PEDIDO.nroref NO-LOCK NO-ERROR.
        END.

        FIND gn-ven WHERE gn-ven.codcia = s-codcia AND
            gn-ven.codven = Ccbcdocu.codven NO-LOCK NO-ERROR.
        IF Ccbcdocu.codref = "G/R" THEN DO:
            FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia
                AND B-CDOCU.coddoc = Ccbcdocu.codref
                AND B-CDOCU.nrodoc = Ccbcdocu.nroref
                NO-LOCK NO-ERROR.
        END.
        FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
        FIND LAST gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = Ccbcdocu.codcli
            NO-LOCK NO-ERROR.


        CREATE Resumen.
        ASSIGN
            Resumen.CodDoc    = Ccbcdocu.coddoc
            Resumen.NroDoc    = Ccbcdocu.nrodoc
            Resumen.CodCli    = Ccbcdocu.codcli
            Resumen.NomCli    = Ccbcdocu.nomcli
            Resumen.FchDoc    = Ccbcdocu.fchdoc
            Resumen.Moneda    = cMoneda
            .
        RUN lib/limpiar-texto-abc (Resumen.NomCli, "", OUTPUT cTexto).
        Resumen.NomCli = cTexto.


        IF AVAILABLE PEDIDO THEN DO:
            IF AVAILABLE COTIZACION THEN DO:
                ASSIGN
                    Resumen.Pedido = COTIZACION.NroPed.
            END.
        END.

        /* Valores Totales */
        ASSIGN
            Resumen.impbrt          = Ccbcdocu.impbrt
            Resumen.impdto          = (IF LOOKUP(Ccbcdocu.coddoc, 'N/C,N/D') > 0 THEN 0 ELSE Ccbcdocu.Libre_d01)
            Resumen.impexo          = Ccbcdocu.impexo
            Resumen.impvta          = Ccbcdocu.impvta
            Resumen.impigv          = Ccbcdocu.impigv
            Resumen.imptot          = Ccbcdocu.ImpTot - Ccbcdocu.AcuBon[5] - Ccbcdocu.AcuBon[10].    /* SIN PERCEP */
            .
        /* CASO DE FACTURAS CON APLICACION DE ADELANTOS */
        IF LOOKUP (Ccbcdocu.coddoc, 'FAC,BOL') > 0
            AND Ccbcdocu.FlgEst <> 'A' 
            AND Ccbcdocu.ImpTot2 > 0
            THEN DO:
            /* Recalculamos Importes */
            ASSIGN
                Resumen.ImpTot = Resumen.ImpTot - Ccbcdocu.ImpTot2.
            IF Resumen.ImpTot <= 0 THEN DO:
                ASSIGN
                    Resumen.ImpTot = 0
                    Resumen.ImpBrt = 0
                    Resumen.ImpExo = 0
                    Resumen.ImpDto = 0
                    Resumen.ImpVta = 0
                    Resumen.ImpIgv = 0.
            END.
            ELSE DO:
                x-Factor = Resumen.ImpTot / (Ccbcdocu.ImpTot - Ccbcdocu.AcuBon[5]).
                ASSIGN
                    Resumen.ImpVta = ROUND (Ccbcdocu.ImpVta * x-Factor, 2)
                    Resumen.ImpIgv = Resumen.ImpTot - Resumen.ImpVta.
                ASSIGN
                    Resumen.ImpBrt = Resumen.ImpVta + Ccbcdocu.ImpIsc + Resumen.ImpDto /*+ T-CDOC.ImpExo*/.
            END.
        END.
        /* Ic - 11Ene2017, no valido para Transferencias Gratuitas */
        IF Ccbcdocu.fmapgo <> '899' THEN
            ASSIGN
            Resumen.ImpBrt = Resumen.ImpVta + Ccbcdocu.ImpIsc + Resumen.ImpDto /*+ T-CDOC.ImpExo*/.

        FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK:
            FIND LAST Almstkge USE-INDEX Llave01 WHERE Almstkge.codcia = s-codcia AND
                Almstkge.codmat = Ccbddocu.codmat AND
                Almstkge.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
            IF AVAILABLE Almstkge THEN DO:
                ASSIGN
                    Resumen.CtoKar = Resumen.CtoKar + 
                                        (Almstkge.ctouni * Ccbddocu.candes * Ccbddocu.factor * dSigno).
            END.
        END.
        ASSIGN
             Resumen.impbrt = Resumen.impbrt * dSigno
             Resumen.impdto = Resumen.impdto * dSigno
             Resumen.impexo = Resumen.impexo * dSigno
             Resumen.impvta = Resumen.impvta * dSigno
             Resumen.impigv = Resumen.impigv * dSigno
             Resumen.imptot = Resumen.imptot * dSigno
            .
        ASSIGN
            Resumen.percepcion = (Ccbcdocu.AcuBon[5]  + Ccbcdocu.AcuBon[10] ) * dSigno
            /*Resumen.totales = (Ccbcdocu.imptot + Ccbcdocu.AcuBon[5] + Ccbcdocu.AcuBon[10]) * dSigno   */
            Resumen.totales = Ccbcdocu.imptot * dSigno   
            .
        CASE Ccbcdocu.FlgEst :
            WHEN "P" THEN Resumen.Estado = "PEN".
            WHEN "C" THEN Resumen.Estado = "CAN".
            WHEN "A" THEN Resumen.Estado = "ANU".
        END CASE.


        Resumen.DivOri = Ccbcdocu.divori.
        FIND bGN-DIVI WHERE bGN-DIVI.codcia = s-codcia AND
            bGN-DIVI.coddiv = Ccbcdocu.divori NO-LOCK NO-ERROR.
        IF AVAILABLE bGN-DIVI THEN Resumen.DesOri = bGN-DIVI.desdiv.

        Resumen.DivDes    = Ccbcdocu.coddiv.
        FIND bGN-DIVI WHERE bGN-DIVI.codcia = s-codcia AND bGN-DIVI.coddiv = Ccbcdocu.coddiv NO-LOCK NO-ERROR.
        IF AVAILABLE bGN-DIVI THEN Resumen.NomDes = bGN-DIVI.desdiv.

        IF AVAILABLE gn-tcmb THEN Resumen.tpocmb = gn-tcmb.venta.
        IF AVAILABLE gn-clie THEN Resumen.clfcli = gn-clie.clfcli.

    END.
END.
HIDE FRAME F-Proceso.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


CASE TOGGLE_Resumido:
    WHEN YES THEN DO:
        RUN Carga-Resumen.
    END.
    WHEN NO THEN DO:
        RUN Carga-Detalle.
    END.
END CASE.
RUN Limpieza.

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
  DISPLAY EDITOR_Divisiones x-codcli x-nomcli x-CodMat x-DesMat x-desde x-hasta 
          TOGGLE_Resumido x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 BUTTON-3 x-codcli x-CodMat x-desde x-hasta TOGGLE_Resumido 
         btn-excel btn-exit 
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
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 3.
DEFINE VARIABLE t-Letra                 AS INTEGER.
DEFINE VARIABLE iInt                    AS INTEGER     NO-UNDO.

DEFINE VARIABLE cLetra  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLetra2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE t-col   AS INTEGER   NO-UNDO.

DEFINE VARIABLE dSigno  AS DECIMAL     NO-UNDO.

DEFINE VARIABLE cMoneda AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDesMat AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDesMar AS CHARACTER   NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A3"):Value = "CODMAT".
chWorkSheet:Range("B3"):Value = "DESMAT".
chWorkSheet:Range("C3"):Value = "CODDOC".
chWorkSheet:Range("D3"):Value = "NRODOC".
chWorkSheet:Range("E3"):Value = "CODCLI".
chWorkSheet:Range("F3"):Value = "RAZON SOCIAL".
chWorkSheet:Range("G3"):Value = "FCHDOC".
chWorkSheet:Range("H3"):Value = "UNDVTA".
chWorkSheet:Range("I3"):Value = "CANTIDAD".
chWorkSheet:Range("J3"):Value = "MONEDA".
chWorkSheet:Range("K3"):Value = "IMPORTE".
chWorkSheet:Range("L3"):Value = "GUIA".
chWorkSheet:Range("M3"):Value = "EMISION".
chWorkSheet:Range("N3"):Value = "IMPORTE BRUTO".
chWorkSheet:Range("O3"):Value = "% DSCTO".
chWorkSheet:Range("P3"):Value = "MARCA".

/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("D"):NumberFormat = "@".
chWorkSheet:Columns("E"):NumberFormat = "@".
chWorkSheet:Columns("L"):NumberFormat = "@".

FOR EACH ccbcdocu USE-INDEX llave13 NO-LOCK WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.fchdoc >= x-desde
    AND ccbcdocu.fchdoc <= x-hasta
    AND LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK,N/C,N/D") > 0:
    /* FILTROS */
    IF ccbcdocu.flgest = "A" THEN NEXT.
    IF x-CodCli <> '' AND Ccbcdocu.codcli <> x-CodCli THEN NEXT.
    /* ******* */
    DISPLAY "PROCESANDO: " +  Ccbcdocu.coddoc + "-" + CcbCDocu.NroDoc @ x-mensaje
        WITH FRAME {&FRAME-NAME}.
    FOR EACH ccbddocu OF ccbcdocu NO-LOCK WHERE (x-codmat = "" OR Ccbddocu.codmat = x-codmat):
        cDesMar = "".
        CASE ccbcdocu.coddoc:
            WHEN 'N/C' THEN DO:
                FIND FIRST CcbTabla WHERE CcbTabla.CodCia = s-codcia
                    AND CcbTabla.Tabla  = ccbcdocu.coddoc
                    AND CcbTabla.Codigo = ccbddocu.codmat NO-LOCK NO-ERROR.
                IF AVAIL CcbTabla THEN cDesMat = CcbTabla.Nombre.                
            END.
            OTHERWISE DO:
                FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
                    AND almmmatg.codmat = ccbddocu.codmat NO-LOCK NO-ERROR.
                IF AVAIL almmmatg THEN DO:
                    cDesMat = Almmmatg.DesMat.
                    cDesMar = Almmmatg.DesMar.
                END.
                    
            END.
        END CASE.

        IF CcbCDocu.CodMon = 1 THEN cMoneda = "S/.". ELSE cMoneda = "$".

        IF CcbCDocu.CodDoc = "N/C" THEN dSigno = -1. ELSE dSigno = 1.


        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbDDocu.codmat.     
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = cDesMat.     
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbDDocu.CodDoc.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbDDocu.NroDoc.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbCDocu.CodCli.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbCDocu.NomCli.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbCDocu.FchDoc.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbDDocu.UndVta.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbDDocu.CanDes * dSigno.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = cMoneda.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbDDocu.ImpLin * dSigno.
        IF Ccbcdocu.codref = "G/R" THEN DO:
            cRange = "L" + cColumn.
            chWorkSheet:Range(cRange):Value = CcbCDocu.NroRef.
            FIND B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
                AND B-CDOCU.coddoc = Ccbcdocu.codref
                AND B-CDOCU.nrodoc = Ccbcdocu.nroref
                NO-LOCK NO-ERROR.
            IF AVAILABLE B-CDOCU THEN DO:
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Value = B-CDOCU.FchDoc.
            END.
        END.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = (CcbDDocu.ImpLin * dSigno) + CcbDDocu.ImpDto * dSigno.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbDDocu.por_dsctos[3].
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = cDesMar.
    END.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/*
FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia
    AND ccbcdocu.codcli BEGINS x-codcli
    AND LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK,N/C,N/D") > 0
    AND ccbcdocu.fchdoc >= x-desde
    AND ccbcdocu.fchdoc <= x-hasta
    AND ccbcdocu.flgest <> "A",
    EACH ccbddocu OF ccbcdocu NO-LOCK:
    CASE ccbcdocu.coddoc:
        WHEN 'N/C' THEN DO:
            FIND FIRST CcbTabla WHERE CcbTabla.CodCia = s-codcia
                AND CcbTabla.Tabla  = ccbcdocu.coddoc
                AND CcbTabla.Codigo = ccbddocu.codmat NO-LOCK NO-ERROR.
            IF AVAIL CcbTabla THEN cDesMat = CcbTabla.Nombre.
        END.
        OTHERWISE DO:
            FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
                AND almmmatg.codmat = ccbddocu.codmat NO-LOCK NO-ERROR.
            IF AVAIL almmmatg THEN cDesMat = Almmmatg.DesMat.
        END.
    END CASE.

    IF CcbCDocu.CodMon = 1 THEN cMoneda = "S/.". ELSE cMoneda = "$".

    IF CcbCDocu.CodDoc = "N/C" THEN dSigno = -1. ELSE dSigno = 1.

    DISPLAY "PROCESANDO: " +  Ccbcdocu.coddoc + "-" + CcbCDocu.NroDoc @ x-mensaje
        WITH FRAME {&FRAME-NAME}.

    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.codmat.     
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = cDesMat.     
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.CodDoc.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.NroDoc.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbCDocu.CodCli.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbCDocu.NomCli.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbCDocu.FchDoc.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.UndVta.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.CanDes * dSigno.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = cMoneda.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = CcbDDocu.PreUni * dSigno.
    IF Ccbcdocu.codref = "G/R" THEN DO:
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = CcbCDocu.NroRef.
        FIND B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
            AND B-CDOCU.coddoc = Ccbcdocu.codref
            AND B-CDOCU.nrodoc = Ccbcdocu.nroref
            NO-LOCK NO-ERROR.
        IF AVAILABLE B-CDOCU THEN DO:
            cRange = "M" + cColumn.
            chWorkSheet:Range(cRange):Value = B-CDOCU.FchDoc.
        END.
    END.
END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpieza W-Win 
PROCEDURE Limpieza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR cNomCli AS CHAR NO-UNDO.
FOR EACH Detalle EXCLUSIVE-LOCK:
    RUN lib/limpiar-texto (INPUT Detalle.nomcli, INPUT " ", OUTPUT cNomCli).
    Detalle.nomcli = cNomCli.
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
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
          x-hasta = TODAY
          x-desde = (TODAY - DAY(TODAY) + 1).
  END.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
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

