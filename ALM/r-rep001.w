&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER CREDITOS FOR CcbCDocu.
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

DEF VAR x-Almacenes AS CHAR NO-UNDO.

DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-codcia AS INTE.

DEFINE VAR S-CODMOV LIKE ALMTMOVM.CODMOV NO-UNDO.

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

FIND FacDocum WHERE codcia = s-codcia 
    AND coddoc = 'D/F'
    NO-LOCK NO-ERROR.
IF AVAILABLE Facdocum THEN S-CODMOV = Facdocum.codmov.
ELSE RETURN.

DEF TEMP-TABLE Detalle NO-UNDO
    FIELD CodAlm AS CHAR FORMAT 'x(5)'                      LABEL 'Almacén'
    FIELD NroRf2 AS CHAR FORMAT 'x(20)'                     LABEL 'Devolución'
    FIELD CodMov AS INTE FORMAT '99'                        LABEL 'Movimiento'
    FIELD NroDoc AS CHAR FORMAT 'x(15)'                     LABEL 'Ingreso'
    FIELD FchDoc AS DATE FORMAT '99/99/9999'                LABEL 'Fecha del movimiento'
    FIELD CodCli AS CHAR FORMAT 'x(15)'                     LABEL 'Cliente'
    FIELD NomCli AS CHAR FORMAT 'x(100)'                    LABEL 'Nombre del cliente'
    FIELD DirCli AS CHAR FORMAT 'x(100)'                    LABEL 'Dirección'
    FIELD CodRef AS CHAR FORMAT 'x(20)'                     LABEL 'Referencia'
    FIELD Ruc    AS CHAR FORMAT 'x(15)'                     LABEL 'RUC'
    FIELD Observ AS CHAR FORMAT 'x(80)'                     LABEL 'Observaciones'
    FIELD CodMot AS CHAR FORMAT 'x(10)'                     LABEL 'Motivo'
    FIELD Motivo AS CHAR FORMAT 'x(80)'                     LABEL 'Descripción del motivo'
    FIELD Moneda AS CHAR FORMAT 'x(5)'                      LABEL 'Moneda'
    FIELD ValVta AS DECI DECIMALS 2 FORMAT '->>>>>>>>9.99'  LABEL 'Valor de Venta sin IGV'
    FIELD divivta AS CHAR FORMAT 'x(10)'                    LABEL 'Division venta'
    FIELD NomDivVta AS CHAR FORMAT 'x(100)'                 LABEL 'Nombre division venta'
    FIELD dividsp AS CHAR FORMAT 'x(10)'                    LABEL 'Division despacho'
    FIELD NomDivDsp AS CHAR FORMAT 'x(100)'                 LABEL 'Nombre division despacho'
    FIELD cvendedor AS CHAR FORMAT 'x(15)'                  LABEL 'Cod.Vendedor'
    FIELD dvendedor AS CHAR FORMAT 'x(100)'                 LABEL 'Nombre vendedor'
    FIELD Orden AS CHAR FORMAT 'x(20)'                      LABEL 'Orden de Despacho'
    FIELD PedCom AS CHAR FORMAT 'x(20)'                     LABEL 'Pedido Comercial '
    FIELD FchCom AS DATE FORMAT '99/99/9999'                LABEL 'Fecha del Comprobante'
    FIELD PedLog AS CHAR FORMAT 'x(20)'                     LABEL 'Pedido logistico'
    FIELD ImpPedLog AS DECI FORMAT '->>>>>>>>9.99'          LABEL 'Importe Total'
    FIELD AtePedLog AS DECI FORMAT '->>>>>>>>9.99'          LABEL 'Importe Atendido'
    FIELD CtoTot AS DECI DECIMALS 2 FORMAT '->>>>>>>>9.99'  LABEL 'CostoTotal'
    .
/*
DEF TEMP-TABLE Detalle NO-UNDO
    FIELD CodAlm AS CHAR FORMAT 'x(5)'                      LABEL 'Almacén'
    FIELD CodMov AS INTE FORMAT '99'                        LABEL 'Movimiento'
    FIELD NroDoc AS CHAR FORMAT 'x(15)'                     LABEL 'Número'
    FIELD FchDoc AS DATE FORMAT '99/99/9999'                LABEL 'Fecha del movimiento'
    FIELD FchTra AS DATE FORMAT '99/99/9999'                LABEL 'Fecha Transacción'   
    FIELD Usuario AS CHAR FORMAT 'x(15)'                    LABEL 'Usuario'
    /*FIELD EstMat AS CHAR*/
    FIELD Ref1 AS CHAR FORMAT 'x(20)'                       LABEL 'Referencia 1'
    FIELD Ref2 AS CHAR FORMAT 'x(20)'                       LABEL 'Referencia 2'
    FIELD CodMat AS CHAR FORMAT 'x(8)'                      LABEL 'Artículo'
    FIELD DesMat AS CHAR FORMAT 'x(100)'                    LABEL 'Descripción'
    FIELD UndBas AS CHAR FORMAT 'x(8)'                      LABEL 'Unidad base'
    FIELD DesMar AS CHAR FORMAT 'x(30)'                     LABEL 'Marca'
    FIELD Cantidad AS DECI FORMAT '>>>,>>9.99'              LABEL 'Cantidad'
    FIELD PreFac AS DECI DECIMALS 4 FORMAT '>>>,>>9.9999'   LABEL 'Precio factura'
    FIELD CtoTot AS DECI DECIMALS 2 FORMAT '>>>,>>,>>9.99'  LABEL 'Costo total'
    FIELD CtoProm AS DECI DECIMALS 4 FORMAT '>>>,>>9.9999'  LABEL 'Costo promedio'
    FIELD CatCon AS CHAR FORMAT 'x(5)'                      LABEL 'Categoría contable'
    FIELD Observ AS CHAR FORMAT 'x(80)'                     LABEL 'Observaciones'
    FIELD Moneda AS CHAR FORMAT 'x(5)'                      LABEL 'Moneda'
    FIELD TpoCmb AS DECI DECIMALS 2 FORMAT '>>>,>>9.99'     LABEL 'T.C.'
    FIELD NroOD AS CHAR FORMAT 'x(15)'                      LABEL 'O/D'
    FIELD NroGR AS CHAR FORMAT 'x(15)'                      LABEL 'G/R'
    FIELD Motivo AS CHAR FORMAT 'x(80)'                     LABEL 'Motivo'
    FIELD Estado AS CHAR FORMAT 'x(80)'                     LABEL 'Estado'
    .
*/

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
&Scoped-Define ENABLED-OBJECTS BUTTON-3 FILL-IN-CodCli FILL-IN-Fecha-1 ~
FILL-IN-Fecha-2 BUTTON_Texto BtnDone 
&Scoped-Define DISPLAYED-OBJECTS EDITOR_Almacenes FILL-IN-CodCli ~
FILL-IN-NomCli FILL-IN-Fecha-1 FILL-IN-Fecha-2 

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
     SIZE 9 BY 2.15
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/search.ico":U
     LABEL "Button 3" 
     SIZE 7 BY 1.62.

DEFINE BUTTON BUTTON_Texto 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Button 5" 
     SIZE 9 BY 2.15 TOOLTIP "Exportar a Texto".

DEFINE VARIABLE EDITOR_Almacenes AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 40 BY 4.31
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde el dia" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta el dia" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     EDITOR_Almacenes AT ROW 1.27 COL 13 NO-LABEL WIDGET-ID 2
     BUTTON-3 AT ROW 1.27 COL 53 WIDGET-ID 4
     FILL-IN-CodCli AT ROW 5.85 COL 11 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-NomCli AT ROW 5.85 COL 23 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     FILL-IN-Fecha-1 AT ROW 6.81 COL 11 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-Fecha-2 AT ROW 7.77 COL 11 COLON-ALIGNED WIDGET-ID 12
     BUTTON_Texto AT ROW 9.35 COL 4 WIDGET-ID 18
     BtnDone AT ROW 9.35 COL 14 WIDGET-ID 16
     "Almacenes:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.27 COL 3 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 11.46
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: CREDITOS B "?" ? INTEGRAL CcbCDocu
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "REPORTE DE DEVOLUCIONES DE CLIENTES"
         HEIGHT             = 11.46
         WIDTH              = 80
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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
/* SETTINGS FOR EDITOR EDITOR_Almacenes IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE DEVOLUCIONES DE CLIENTES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE DEVOLUCIONES DE CLIENTES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
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


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  x-Almacenes = EDITOR_Almacenes:SCREEN-VALUE.
  RUN alm/d-almacen (INPUT-OUTPUT x-Almacenes).
  EDITOR_Almacenes:SCREEN-VALUE = x-Almacenes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Texto W-Win
ON CHOOSE OF BUTTON_Texto IN FRAME F-Main /* Button 5 */
DO:
    ASSIGN EDITOR_Almacenes FILL-IN-CodCli FILL-IN-Fecha-1 FILL-IN-Fecha-2.

    IF TRUE <> (EDITOR_Almacenes > '') THEN NEXT.

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
    RUN lib/tt-filev2 (TEMP-TABLE Detalle:HANDLE, cArchivo, pOptions).
    SESSION:DATE-FORMAT = "dmy".
    SESSION:SET-WAIT-STATE('').
    /* ******************************************************* */
    SESSION:SET-WAIT-STATE('').
    HIDE FRAME f-Proceso.
    MESSAGE 'Proceso Concluido' VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Cliente */
DO:
  FILL-IN-NomCli:SCREEN-VALUE = ''.
  FIND GN-CLIE WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE GN-CLIE THEN FILL-IN-NomCli:SCREEN-VALUE = gn-clie.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEFT-MOUSE-DBLCLICK OF FILL-IN-CodCli IN FRAME F-Main /* Cliente */
OR F8 OF FILL-IN-CodCli DO:
    input-var-1 = ''.
    input-var-2 = ''.
    input-var-3 = ''.
    output-var-1 = ?.
    RUN lkup/c-client ('Clientes').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE Detalle.
DEF BUFFER bCcbcdocu FOR Ccbcdocu.
DEF VAR cMotivo AS CHAR NO-UNDO.

FOR EACH Almacen WHERE Almacen.codcia = s-codcia AND LOOKUP(TRIM(Almacen.codalm), EDITOR_Almacenes) > 0:
    DISPLAY 'Almacén: ' + Almacen.codalm @ fi-Mensaje WITH FRAME f-Proceso.
    FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = S-CODCIA 
            AND Almcmov.CodAlm = Almacen.codalm
            AND Almcmov.TipMov = "I" 
            AND Almcmov.CodMov = S-CODMOV
            AND Almcmov.FchDoc >= FILL-IN-Fecha-1
            AND Almcmov.FchDoc <= FILL-IN-Fecha-2,
        FIRST Ccbcdocu WHERE ccbcdocu.codcia = almcmov.codcia
            AND ccbcdocu.coddoc = almcmov.codref
            AND ccbcdocu.nrodoc = almcmov.nroref NO-LOCK:
        IF Almcmov.flgest = "A" THEN NEXT.
        IF FILL-IN-CodCli > '' AND Almcmov.CodCli <> FILL-IN-CodCli THEN NEXT.

        cMotivo = "".
        FIND ccbtabla WHERE ccbtabla.codcia = s-codcia
            AND ccbtabla.tabla = 'MD'
            AND CcbTabla.Codigo = almcmov.nrorf3
            NO-LOCK NO-ERROR.
        IF AVAILABLE ccbtabla THEN cMotivo = ccbtabla.nombre.
        
        CREATE Detalle.
        ASSIGN
            Detalle.codalm = Almacen.codalm
            Detalle.nrorf2 = STRING(Almcmov.nrorf2, 'XXX-XXXXXXXXX')
            Detalle.codmov = Almcmov.codmov
            Detalle.nrodoc = STRING(Almcmov.nroser,'999') + "-" + STRING(Almcmov.nrodoc,'999999999')
            Detalle.codref = Almcmov.codref + "-" + Almcmov.nroref
            Detalle.fchdoc = Almcmov.fchdoc
            Detalle.codcli = Ccbcdocu.codcli
            Detalle.nomcli = Ccbcdocu.nomcli
            Detalle.dircli = Ccbcdocu.dircli
            Detalle.ruc    = Ccbcdocu.ruccli
            Detalle.divivta = Ccbcdocu.divori
            Detalle.dividsp = Ccbcdocu.coddiv
            Detalle.cvendedor = Ccbcdocu.codven
            Detalle.observ = Almcmov.observ
            Detalle.codmot = Almcmov.nrorf3
            Detalle.motivo = cMotivo
            Detalle.Moneda = (IF Almcmov.codmon = 2 THEN 'US$' ELSE 'S/.')
            .
        FIND FIRST gn-ven WHERE gn-ven.codcia = 1 AND gn-ven.codven = Ccbcdocu.codven NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ven THEN Detalle.dvendedor = gn-ven.nomven.

        FOR EACH Almdmov OF Almcmov NO-LOCK, FIRST Almmmatg OF Almdmov NO-LOCK:
            Detalle.ValVta = Detalle.ValVta + ((Almdmov.candes * Almdmov.preuni) - Almdmov.ImpIgv).
        END.

        /* 23/03/2026: Aracelly Gutierrez, datos adicionales */
        FIND gn-divi WHERE gn-divi.codcia = s-codcia AND
            gn-divi.coddiv = Detalle.divivta NO-LOCK NO-ERROR.
        IF AVAILABLE gn-divi THEN Detalle.nomdivvta = gn-divi.desdiv.
        FIND gn-divi WHERE gn-divi.codcia = s-codcia AND
            gn-divi.coddiv = Detalle.dividsp NO-LOCK NO-ERROR.
        IF AVAILABLE gn-divi THEN Detalle.NomDivDsp = gn-divi.desdiv.

        ASSIGN
            Detalle.Orden = Ccbcdocu.Libre_c01 + "-" + Ccbcdocu.Libre_c02
            Detalle.FchCom = Ccbcdocu.fchdoc.

        FIND PEDIDO WHERE PEDIDO.codcia = s-codcia AND
            PEDIDO.coddoc = Ccbcdocu.codped AND
            PEDIDO.nroped = Ccbcdocu.nroped
            NO-LOCK NO-ERROR.
        IF AVAILABLE PEDIDO THEN DO:
            Detalle.PedCom = PEDIDO.codref + "-" + PEDIDO.nroref.
            Detalle.PedLog = PEDIDO.coddoc + "-" + PEDIDO.nroped.
            Detalle.ImpPedLog = PEDIDO.ImpTot.
            Detalle.AtePedLog = PEDIDO.ImpTot.
            /* Descontamos las N/C */
            FOR EACH CREDITOS NO-LOCK WHERE CREDITOS.codcia = s-codcia AND
                CREDITOS.coddoc = "N/C" AND
                CREDITOS.codref = Ccbcdocu.coddoc AND
                CREDITOS.nroref = Ccbcdocu.nrodoc AND
                CREDITOS.flgest <> "A":
                Detalle.AtePedLog = Detalle.AtePedLog - CREDITOS.ImpTot.
                IF Detalle.AtePedLog < 0 THEN Detalle.AtePedLog = 0.
            END.
        END.
        FOR EACH Almdmov OF Almcmov NO-LOCK:
            FIND LAST almstkge USE-INDEX Llave01 WHERE almstkge.codcia = s-codcia AND
                almstkge.codmat = Almdmov.codmat AND
                almstkge.fecha <= Ccbcdocu.fchdoc NO-LOCK NO-ERROR.
            IF AVAILABLE almstkge THEN Detalle.CtoTot =  Detalle.CtoTot + (Almdmov.candes * Almdmov.factor * Almstkge.ctouni).
        END.
    END.
END.
HIDE FRAME f-Proceso.

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
  DISPLAY EDITOR_Almacenes FILL-IN-CodCli FILL-IN-NomCli FILL-IN-Fecha-1 
          FILL-IN-Fecha-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-3 FILL-IN-CodCli FILL-IN-Fecha-1 FILL-IN-Fecha-2 BUTTON_Texto 
         BtnDone 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
        FILL-IN-Fecha-1 = TODAY - DAY(TODAY) + 1
        FILL-IN-Fecha-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

