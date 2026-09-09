&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER DEVOLUCION FOR CcbCDocu.



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

DEFINE INPUT PARAMETER is-div-sele AS CHAR.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

DEF STREAM REPORTE.
DEF TEMP-TABLE detalle NO-UNDO
    FIELD coddiv    AS CHAR     FORMAT 'x(80)'          LABEL 'Origen'
    FIELD nroped    AS CHAR     FORMAT '999999999'      LABEL 'Cotizacion'
    FIELD nroref    AS CHAR     FORMAT '999999999'      LABEL 'Cot. Orig. (ST)'
    FIELD fchped    AS DATE     FORMAT '99/99/9999'     LABEL 'Fecha Emision'
    FIELD hora      AS CHAR     FORMAT 'x(25)'          LABEL "Hora"
    FIELD fchent    AS DATE     FORMAT '99/99/9999'     LABEL 'Fecha Entrega'
    FIELD codven    AS CHAR     FORMAT 'x(80)'          LABEL 'Vendedor'
    FIELD codcli    AS CHAR     FORMAT 'x(150)'         LABEL 'Cliente'
    FIELD codmat    AS CHAR     FORMAT 'X(120)'         LABEL 'Producto'
    FIELD desmar    AS CHAR     FORMAT 'x(30)'          LABEL 'Marca'
    FIELD codfam    AS CHAR     FORMAT 'X(50)'          LABEL 'Linea'
    FIELD subfam    AS CHAR     FORMAT 'X(50)'          LABEL 'SubLinea'
    FIELD undvta    LIKE facdpedi.undvta                LABEL 'Unidad'
    FIELD cancot    LIKE facdpedi.canped                LABEL 'Cotizado!Cantidad'
    FIELD impcot    LIKE facdpedi.implin                LABEL 'Cotizado!Importe'
    FIELD canate    LIKE facdpedi.canped                LABEL 'Atendido!Cantidad'
    FIELD impate    LIKE facdpedi.implin                LABEL 'Atendido!Importe'
    FIELD canfac    LIKE facdpedi.canped                LABEL 'Facturado!Cantidad'
    FIELD impfac    LIKE facdpedi.implin                LABEL 'Facturado!Importe'
    FIELD cannc     LIKE facdpedi.canped                LABEL 'Nota Credito!Cantidad'
    FIELD impnc     LIKE facdpedi.implin                LABEL 'Nota Credito!Importe'
    FIELD flgest    AS CHAR     FORMAT 'x(5)'           LABEL 'Estado'
    FIELD coddept   AS CHAR     FORMAT 'x(30)'          LABEL 'Departamento'
    FIELD codprov   AS CHAR     FORMAT 'x(30)'          LABEL 'Provincia'
    FIELD coddist   AS CHAR     FORMAT 'x(30)'          LABEL 'Distrito'
    FIELD codpro    AS CHAR     FORMAT 'x(100)'         LABEL 'Proveedor Producto'
    FIELD codproprom AS CHAR                            LABEL 'Proveedor Promotor'
    FIELD promotor  AS CHAR                             LABEL 'Promotor'
    FIELD equipo    AS CHAR                             LABEL 'Equipo'
    FIELD pesmat    AS DEC FORMAT ">>,>>9.9999"         LABEL "Peso Unitario"
    FIELD volumen   AS DEC FORMAT ">>,>>9.9999"         LABEL "Vol.Unitario"
    FIELD licencia  AS CHAR                             LABEL 'Licencia'
    FIELD listaprecio AS CHAR FORMAT "x(6)"             LABEL "Lista de Precio"
    INDEX llave01 AS PRIMARY nroped codmat
    INDEX llave02 nroped codcli codfam subfam
    INDEX llave03 nroped codcli
    INDEX llave04 nroped codven codcli codmat.

DEF VAR x-CodDept AS CHAR NO-UNDO.
DEF VAR x-CodProv AS CHAR NO-UNDO.
DEF VAR x-CodDist AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
COMBO-BOX-Lista BUTTON-Texto BtnDone 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
COMBO-BOX-Lista FILL-IN-Mensaje 

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
     LABEL "&Salir" 
     SIZE 8 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 8 BY 1.62.

DEFINE BUTTON BUTTON-Texto 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Button 3" 
     SIZE 8 BY 1.62 TOOLTIP "Exportar a texto".

DEFINE VARIABLE COMBO-BOX-Lista AS CHARACTER FORMAT "X(256)":U 
     LABEL "Lista de Precios" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "0","0"
     DROP-DOWN-LIST
     SIZE 80 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Fecha-1 AT ROW 1.54 COL 19 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-Fecha-2 AT ROW 1.54 COL 43 COLON-ALIGNED WIDGET-ID 6
     COMBO-BOX-Lista AT ROW 2.88 COL 19 COLON-ALIGNED WIDGET-ID 20
     BUTTON-Texto AT ROW 5.31 COL 11 WIDGET-ID 22
     BtnDone AT ROW 5.31 COL 19 WIDGET-ID 10
     BUTTON-2 AT ROW 5.31 COL 27 WIDGET-ID 8
     FILL-IN-Mensaje AT ROW 5.31 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 108.29 BY 7.46 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: DEVOLUCION B "?" ? INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ESTADISTICAS DE COTIZACIONES"
         HEIGHT             = 7.46
         WIDTH              = 108.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 108.29
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 108.29
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
/* SETTINGS FOR BUTTON BUTTON-2 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       BUTTON-2:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ESTADISTICAS DE COTIZACIONES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ESTADISTICAS DE COTIZACIONES */
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
ON CHOOSE OF BtnDone IN FRAME F-Main /* Salir */
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


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  ASSIGN
      FILL-IN-Fecha-1 FILL-IN-Fecha-2 COMBO-BOX-Lista.
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Texto W-Win
ON CHOOSE OF BUTTON-Texto IN FRAME F-Main /* Button 3 */
DO:
  ASSIGN
      FILL-IN-Fecha-1 FILL-IN-Fecha-2 COMBO-BOX-Lista.
  RUN Texto.
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

DEF VAR x-NomPro LIKE gn-prov.nompro NO-UNDO.
DEF VAR x-NomVen LIKE gn-ven.nomven NO-UNDO.
DEF VAR x-NomCli AS CHAR NO-UNDO.
DEF VAR iContador AS INTE NO-UNDO.

EMPTY TEMP-TABLE Detalle.
ESTADISTICAS:
FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = COMBO-BOX-Lista,
    EACH faccpedi NO-LOCK WHERE faccpedi.codcia = s-codcia
    AND faccpedi.coddiv = gn-divi.coddiv
    AND faccpedi.coddoc = 'COT'
    AND faccpedi.fchped >= FILL-IN-Fecha-1
    AND faccpedi.fchped <= FILL-IN-Fecha-2,
    FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = faccpedi.codcli:
    IF Faccpedi.flgest = "A" /*OR Faccpedi.flgest = "W"*/ THEN NEXT.
    iContador = iContador + 1.
    IF iContador MODULO 100 = 0 THEN DO:
        Fi-Mensaje = "** RESUMIENDO ** " + "COTIZACION " + faccpedi.nroped.
        DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
    END.
    RUN lib/limpiar-texto (gn-clie.nomcli, '', OUTPUT x-NomCli).
    FOR EACH facdpedi OF Faccpedi NO-LOCK, 
        FIRST Almmmatg OF Facdpedi NO-LOCK, 
        FIRST Almtfami OF Almmmatg NO-LOCK,
        FIRST Almsfami OF Almmmatg NO-LOCK:
        CREATE detalle.
        ASSIGN
            detalle.coddiv = faccpedi.coddiv + ' ' +  GN-DIVI.DesDiv
            detalle.nroped = faccpedi.nroped
            detalle.nroref = (IF faccpedi.codref = 'COT' THEN faccpedi.nroref ELSE '')
            detalle.fchped = faccpedi.fchped
            detalle.hora = faccpedi.hora
            detalle.fchent = faccpedi.fchent
            detalle.codven = faccpedi.codven
            detalle.codcli = faccpedi.codcli + ' '  + x-NomCli
            detalle.codmat = facdpedi.codmat + ' '  + almmmatg.desmat
            detalle.desmar = almmmatg.desmar
            detalle.codfam = almmmatg.codfam + ' ' + almtfami.desfam
            detalle.subfam = almmmatg.subfam + ' ' + almsfami.dessub
            detalle.flgest = faccpedi.flgest
            detalle.coddept = gn-clie.CodDept 
            detalle.codprov = gn-clie.CodProv 
            detalle.coddist = gn-clie.CodDist
            detalle.pesmat = almmmatg.pesmat
            detalle.volume = almmmatg.libre_d02
            detalle.listaprecio = faccpedi.libre_c01.
        /* PARCHE */
        detalle.codpro  = almmmatg.codpr1.
        IF NUM-ENTRIES(Facdpedi.Libre_c03, '|') >= 3 THEN DO:
            ASSIGN
                detalle.codproprom = ENTRY(1, Facdpedi.libre_c03, '|')
                detalle.promotor = ENTRY(2, Facdpedi.libre_c03, '|')
                detalle.equipo   = ENTRY(3, Facdpedi.libre_c03, '|').
        END.
        FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia 
            AND VtaTabla.Tabla = 'EXPOPROMOTOR'
            AND VtaTabla.Llave_c1 = Faccpedi.coddiv
            AND VtaTabla.Llave_c2 = detalle.codproprom
            AND VtaTabla.Llave_c3 = detalle.promotor
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTabla THEN detalle.promotor = VtaTabla.libre_c01.
        /* Licencia */
        FIND almtabla WHERE almtabla.Tabla = "LC" AND
             almtabla.Codigo = Almmmatg.Licencia[1] NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN detalle.licencia = almtabla.Nombre.
        /* Datos faltantes */
        ASSIGN
            x-nompro = 'NN'
            x-nomven = 'NN'
            x-coddept = detalle.coddept
            x-codprov = detalle.codprov
            x-coddist = detalle.coddist.
        FIND gn-prov WHERE gn-prov.codcia = pv-codcia
            AND gn-prov.codpro = almmmatg.codpr1
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov THEN x-nompro = gn-prov.nompro.
        FIND gn-ven WHERE gn-ven.codcia = s-codcia AND gn-ven.codven = detalle.codven NO-LOCK NO-ERROR.
        IF AVAILABLE gn-ven THEN x-nomven = gn-ven.nomven.
        FIND TabDepto WHERE TabDepto.CodDepto = detalle.coddept NO-LOCK NO-ERROR.
        IF AVAILABLE TabDepto THEN x-coddept = TRIM(x-coddept) + ' ' + TabDepto.NomDepto.
        FIND TabProvi WHERE TabProvi.CodDepto = detalle.coddept
            AND TabProvi.CodProvi = detalle.codprov NO-LOCK NO-ERROR.
        IF AVAILABLE TabProvi THEN x-codprov = TRIM(x-codprov) + ' ' + TabProvi.NomProvi.
        FIND TabDistr WHERE TabDistr.CodDepto = detalle.coddept
            AND TabDistr.CodProvi = detalle.codprov
            AND TabDistr.CodDistr = detalle.coddist NO-LOCK NO-ERROR.
        IF AVAILABLE TabDistr THEN x-coddist = TRIM(x-coddist) + ' ' + TabDistr.NomDistr.
        ASSIGN
            detalle.codpro = detalle.codpro + ' ' + x-nompro
            detalle.codven = detalle.codven + ' ' + x-nomven
            detalle.coddept = x-coddept
            detalle.codprov = x-codprov
            detalle.coddist = x-coddist
            .
        ASSIGN
            detalle.undvta = facdpedi.undvta
            detalle.cancot = facdpedi.canped
            detalle.impcot = facdpedi.implin.
    END.
END.
HIDE FRAME F-Proceso.

/* Datos adicionales */
DEF BUFFER b-faccpedi FOR faccpedi.
DEF BUFFER b-facdpedi FOR facdpedi.
DEF VAR x-codmat AS CHAR NO-UNDO.

FOR EACH detalle:
    x-codmat = ENTRY(1,detalle.codmat,' ').
    Fi-Mensaje = "** ANALIZANDO ** " + "COTIZACION " + detalle.nroped.
    DISPLAY Fi-Mensaje WITH FRAME F-Proceso.
    /* Barremos los pedidos relacionados */
    FOR EACH b-faccpedi NO-LOCK WHERE b-faccpedi.codcia = s-codcia AND
        b-faccpedi.codref = 'COT' AND
        b-faccpedi.nroref = detalle.nroped AND
        b-faccpedi.coddoc = 'PED' AND
        b-faccpedi.flgest <> 'A',
        FIRST b-facdpedi OF b-faccpedi NO-LOCK WHERE b-facdpedi.codmat = x-codmat:
        /* Barremos las O/D relacionadas */
        FOR EACH faccpedi NO-LOCK WHERE faccpedi.codcia = s-codcia AND
            faccpedi.codref = b-faccpedi.coddoc AND
            faccpedi.nroref = b-faccpedi.nroped AND
            faccpedi.coddoc = 'O/D' AND
            faccpedi.flgest <> 'A',
            FIRST facdpedi OF faccpedi NO-LOCK WHERE facdpedi.codmat = x-codmat:
            detalle.canate = detalle.canate + (facdpedi.canped * facdpedi.factor).
            detalle.impate = detalle.impate + facdpedi.implin.
        END.
        /* Solo lo facturado */
        FOR EACH ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = s-codcia AND
            ccbcdocu.codped = b-faccpedi.coddoc AND
            ccbcdocu.nroped = b-faccpedi.nroped AND
            ccbcdocu.flgest <> 'A':
            IF LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL') = 0 THEN NEXT.
            FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK WHERE ccbddocu.codmat = x-codmat:
                detalle.canfac = detalle.canfac + (ccbddocu.candes * ccbddocu.factor).
                detalle.impfac = detalle.impfac + ccbddocu.implin.
            END.

            /* **************************************** */
            /* 15/12/2025: Alex Tisza, notas de crédito */
            /* **************************************** */
            FOR EACH DEVOLUCION NO-LOCK WHERE DEVOLUCION.codcia = s-codcia
                    AND DEVOLUCION.codref = Ccbcdocu.coddoc
                    AND DEVOLUCION.nroref = Ccbcdocu.nrodoc
                    AND DEVOLUCION.coddoc = "N/C"
                    AND DEVOLUCION.flgest <> "A":
                FOR EACH Ccbddocu OF DEVOLUCION NO-LOCK WHERE Ccbddocu.codmat = x-codmat:
                    Detalle.ImpNC = Detalle.ImpNC + Ccbddocu.ImpLin.
                    Detalle.CanNC = Detalle.CanNC + (Ccbddocu.CanDes * Ccbddocu.Factor).
                END.
            END.
            /* **************************************** */
        END.
    END.
END.
HIDE FRAME F-Proceso.

RETURN "OK".

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
  DISPLAY FILL-IN-Fecha-1 FILL-IN-Fecha-2 COMBO-BOX-Lista FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-Fecha-1 FILL-IN-Fecha-2 COMBO-BOX-Lista BUTTON-Texto BtnDone 
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
DEF VAR x-Llave AS CHAR FORMAT 'x(800)' NO-UNDO.
DEF VAR x-Titulo AS CHAR FORMAT 'x(800)' NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.

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
RUN Carga-Temporal.
/* Programas que generan el Excel */
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .

RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle:handle,
                                  INPUT  c-csv-file,
                                  OUTPUT c-xls-file) .

/* Borramos librerias de la memoria */
DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** FIN DEL PROCESO **".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable W-Win 
PROCEDURE local-disable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable':U ) .

  /* Code placed here will execute AFTER standard behavior.    */



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable W-Win 
PROCEDURE local-enable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
      FILL-IN-Fecha-1 = TODAY
      FILL-IN-Fecha-2 = TODAY.     

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Lista:DELIMITER = ":".
      COMBO-BOX-Lista:DELETE(1).
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND
          (gn-divi.campo-char[1] = 'L' OR gn-divi.campo-char[1] = 'A' ) AND
          gn-divi.campo-log[1] = NO:
          COMBO-BOX-Lista:ADD-LAST(gn-divi.coddiv + " - " + GN-DIVI.DesDiv, gn-divi.coddiv).
      END.
      COMBO-BOX-Lista:SCREEN-VALUE IN FRAME {&FRAME-NAME} = s-coddiv.
      ENABLE COMBO-BOX-Lista WITH FRAME {&FRAME-NAME}.
      IF is-div-sele = 'X' THEN DO:
          DISABLE COMBO-BOX-Lista WITH FRAME {&FRAME-NAME}.
      END.
      ELSE DO:
          ENABLE COMBO-BOX-Lista WITH FRAME {&FRAME-NAME}.
      END.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Pantalla de Impresión */
    DEF VAR pOptions AS CHAR.
    DEF VAR pArchivo AS CHAR.
    DEF VAR cArchivo AS CHAR.

    RUN lib/tt-file-to-onlytext (OUTPUT pOptions, OUTPUT pArchivo).
    IF pOptions = "" THEN RETURN NO-APPLY.

    /* Cargamos la informacion al temporal */
    SESSION:SET-WAIT-STATE('GENERAL').

    EMPTY TEMP-TABLE Detalle.
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

