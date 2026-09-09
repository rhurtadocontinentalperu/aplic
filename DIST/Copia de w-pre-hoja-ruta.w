&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE T-CDOCU LIKE CcbCDocu.
DEFINE NEW SHARED TEMP-TABLE T-RutaD LIKE DI-RutaD.
DEFINE NEW SHARED TEMP-TABLE T-VtaCTabla LIKE VtaCTabla.



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

DEF VAR s-tabla  AS CHAR INIT 'ZGHR' NO-UNDO.
DEF VAR s-tipmov AS CHAR INIT 'S' NO-UNDO.
DEF VAR s-codmov AS INT  INIT 03 NO-UNDO.

DEF NEW SHARED VAR lh_handle AS HANDLE.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-Refrescar BUTTON-1 BUTTON-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-pre-hoja-rutac AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-pre-hoja-rutaf AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-pre-hoja-rutai AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/forward.ico":U
     LABEL "Button 1" 
     SIZE 6 BY 1.54.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/back.ico":U
     LABEL "Button 2" 
     SIZE 6 BY 1.54.

DEFINE BUTTON BUTTON-Refrescar 
     IMAGE-UP FILE "img/reload.ico":U
     LABEL "REFRESCAR" 
     SIZE 8 BY 1.73 TOOLTIP "REFRESCAR".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-Refrescar AT ROW 1.96 COL 82 WIDGET-ID 2
     BUTTON-1 AT ROW 10.04 COL 68 WIDGET-ID 4
     BUTTON-2 AT ROW 11.77 COL 68 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 141.86 BY 25.27 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-CDOCU T "NEW SHARED" ? INTEGRAL CcbCDocu
      TABLE: T-RutaD T "NEW SHARED" ? INTEGRAL DI-RutaD
      TABLE: T-VtaCTabla T "NEW SHARED" ? INTEGRAL VtaCTabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 25.27
         WIDTH              = 141.86
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
   RUN Pr-Sube IN h_b-pre-hoja-rutai.
   RUN dispatch IN h_b-pre-hoja-rutaf ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
   RUN Pr-Baja IN h_b-pre-hoja-rutaf.
   RUN dispatch IN h_b-pre-hoja-rutai ('open-query':U).
   RUN dispatch IN h_b-pre-hoja-rutaf ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Refrescar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Refrescar W-Win
ON CHOOSE OF BUTTON-Refrescar IN FRAME F-Main /* REFRESCAR */
DO:
  MESSAGE 'Se van a limpiar TODAS las tablas y cargar con información actualizada' SKIP
      'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporales.
  SESSION:SET-WAIT-STATE('').
  RUN dispatch IN h_b-pre-hoja-rutac ('open-query':U).
  RUN dispatch IN h_b-pre-hoja-rutai ('open-query':U).
  RUN dispatch IN h_b-pre-hoja-rutaf ('open-query':U).
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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-pre-hoja-rutac.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-pre-hoja-rutac ).
       RUN set-position IN h_b-pre-hoja-rutac ( 1.19 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-pre-hoja-rutac ( 6.69 , 79.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-pre-hoja-rutai.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-pre-hoja-rutai ).
       RUN set-position IN h_b-pre-hoja-rutai ( 8.12 , 2.00 ) NO-ERROR.
       RUN set-size IN h_b-pre-hoja-rutai ( 17.88 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/dist/b-pre-hoja-rutaf.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-pre-hoja-rutaf ).
       RUN set-position IN h_b-pre-hoja-rutaf ( 8.12 , 74.00 ) NO-ERROR.
       RUN set-size IN h_b-pre-hoja-rutaf ( 17.88 , 66.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-pre-hoja-rutai. */
       RUN add-link IN adm-broker-hdl ( h_b-pre-hoja-rutac , 'Record':U , h_b-pre-hoja-rutai ).

       /* Links to SmartBrowser h_b-pre-hoja-rutaf. */
       RUN add-link IN adm-broker-hdl ( h_b-pre-hoja-rutac , 'Record':U , h_b-pre-hoja-rutaf ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-pre-hoja-rutac ,
             BUTTON-Refrescar:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-pre-hoja-rutai ,
             BUTTON-Refrescar:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-pre-hoja-rutaf ,
             h_b-pre-hoja-rutai , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

DEF BUFFER B-CDOCU FOR Ccbcdocu.
DEF BUFFER B-ALMACEN FOR Almacen.

EMPTY TEMP-TABLE T-VtaCTabla.
EMPTY TEMP-TABLE T-CDOCU.
EMPTY TEMP-TABLE T-RUTAD.

FOR EACH VtaCTabla NO-LOCK WHERE VtaCTabla.CodCia = s-codcia
    AND VtaCTabla.Tabla = s-tabla:
    CREATE T-VtaCTabla.
    BUFFER-COPY VtaCTabla TO T-VtaCTabla.
END.
RUN dispatch IN h_b-pre-hoja-rutac ('open-query':U).

/* Cargamos Guias */
DEFINE VARIABLE pResumen AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iInt     AS INTEGER     NO-UNDO.
DEFINE VARIABLE cValor   AS CHARACTER   NO-UNDO.

/* Guias de Remisión por Ventas */
FOR EACH Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = s-codcia 
    AND CcbCDocu.CodDiv = s-coddiv
    AND CcbCDocu.CodDoc = 'G/R'
    AND CcbCDocu.FlgEst = "F"
    AND CcbCDocu.FchDoc >= TODAY - 7:
    FIND B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
          AND B-CDOCU.coddoc = Ccbcdocu.codref
          AND B-CDOCU.nrodoc = Ccbcdocu.nroref
          NO-LOCK NO-ERROR.
    IF AVAILABLE B-CDOCU
        AND B-CDOCU.fmapgo = '002'
        AND B-CDOCU.flgest <> "C"
        THEN NEXT.
    FIND FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-codcia
        AND DI-RutaD.CodDiv = s-coddiv
        AND DI-RutaD.CodDoc = "H/R"
        AND DI-RutaD.CodRef = Ccbcdocu.coddoc
        AND DI-RutaD.NroRef = Ccbcdocu.nrodoc
        AND DI-RutaD.FlgEst = "C"
        AND CAN-FIND(FIRST Di-Rutac OF Di-rutad WHERE Di-rutac.flgest = "C" NO-LOCK)
        NO-LOCK NO-ERROR.
    IF AVAILABLE Di-rutad THEN NEXT.
    CREATE T-CDOCU.
    ASSIGN
        T-CDOCU.CodCia = s-codcia
        T-CDOCU.CodDiv = s-coddiv
        T-CDOCU.CodDoc = CcbCDocu.CodDoc
        T-CDOCU.NroDoc = CcbCDocu.NroDoc
        T-CDOCU.CodRef = "G/R"      /* Guia por Ventas */
        T-CDOCU.NomCli = CcbCDocu.NomCli.
    /* Pesos y Volumenes */
    RUN Vta/resumen-pedido (T-CDOCU.CodDiv, T-CDOCU.CodDoc, T-CDOCU.NroDoc, OUTPUT pResumen).
    pResumen = SUBSTRING(pResumen,2,(LENGTH(pResumen) - 2)).
    cValor = ''.
    DO iint = 1 TO NUM-ENTRIES(pResumen,"/"):
        cValor = cValor + SUBSTRING(ENTRY(iint,pResumen,"/"),4) + ','.
    END.
    ASSIGN
        T-CDOCU.Libre_d01 = DEC(ENTRY(4,cValor))    /* Peso en Kg */
        T-CDOCU.Libre_d02 = DEC(ENTRY(5,cValor))    /* Volumen en m3 */
        T-CDOCU.ImpTot    = (IF Ccbcdocu.codmon = 2 THEN Ccbcdocu.TpoCmb * Ccbcdocu.ImpTot ELSE Ccbcdocu.ImpTot).
END.

/* Guias de Remisión por Transferencias */
DEFINE VAR lPesos AS DEC.
DEFINE VAR lCosto AS DEC.
DEFINE VAR lVolumen AS DEC.    
DEFINE VAR lValorizado AS LOGICAL.
FOR EACH Almacen NO-LOCK WHERE Almacen.CodCia = s-codcia
    AND Almacen.CodDiv = s-coddiv,
    EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = Almacen.codcia
    AND Almcmov.CodAlm = Almacen.codalm
    AND Almcmov.TipMov = s-tipmov
    AND Almcmov.CodMov = s-codmov
    AND Almcmov.FlgEst <> "A"
    AND Almcmov.FlgSit = "T":
    FIND Di-RutaG WHERE Di-RutaG.CodCia = Almcmov.codcia
        AND Di-RutaG.CodAlm = Almcmov.codalm
        AND Di-RutaG.CodDiv = s-coddiv
        AND Di-RutaG.CodDoc = "H/R"
        AND Di-RutaG.FlgEst = "C"
        AND Di-RutaG.nroref = Almcmov.nrodoc
        AND Di-RutaG.serref = Almcmov.nroser
        AND Di-RutaG.Tipmov = Almcmov.tipmov
        AND Di-RutaG.Codmov = Almcmov.codmov
        AND CAN-FIND(FIRST Di-Rutac OF Di-rutad WHERE Di-rutac.flgest = "C" NO-LOCK)
        NO-LOCK NO-ERROR.
    IF AVAILABLE Di-rutag THEN NEXT.
    /* RHC 16/08/2012 CONSISTENCIA DE ROTULADO */
    CASE TRUE:
        WHEN Almcmov.CodRef = "OTR" THEN DO:
            FIND FIRST CcbCBult WHERE CcbCBult.CodCia = s-codcia
                AND CcbCBult.CodDoc = Almcmov.CodRef
                AND CcbCBult.NroDoc = Almcmov.NroRef
                AND CcbCBult.CHR_01 = "P"
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Ccbcbult THEN NEXT.
        END.
        OTHERWISE DO:
            FIND FIRST CcbCBult WHERE CcbCBult.CodCia = s-codcia
                AND CcbCBult.CodDoc = "TRA"
                AND CcbCBult.NroDoc = STRING(Almcmov.NroSer) +
                                      STRING(Almcmov.NroDoc , '9999999')
                AND CcbCBult.CHR_01 = "P"
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE Ccbcbult THEN NEXT.
        END.
    END CASE.
    CREATE T-CDOCU.
    ASSIGN
        T-CDOCU.CodCia = s-codcia
        T-CDOCU.CodDiv = s-coddiv
        T-CDOCU.CodDoc = "G/R"
        T-CDOCU.NroDoc = STRING(Almcmov.NroSer,'999') + STRING(Almcmov.NroDoc,'999999999')
        T-CDOCU.CodRef = "GTR".    /* Transferencia */
    FIND B-ALMACEN WHERE B-ALMACEN.codcia = s-codcia
        AND B-ALMACEN.codalm = Almcmov.almdes NO-LOCK NO-ERROR.
    IF AVAILABLE B-ALMACEN  THEN ASSIGN T-CDOCU.NomCli = B-ALMACEN.descripcion.
    lPesos = 0.
    lCosto = 0.
    lVolumen = 0.
    FOR EACH almdmov OF almcmov NO-LOCK:
        lPesos = lPesos + almdmov.pesmat.
        /* Costo */
        FIND LAST AlmStkGe WHERE AlmStkGe.codcia = s-codcia AND AlmStkGe.codmat = almdmov.codmat AND
            AlmStkGe.fecha <= DI-RutaC.Fchdoc NO-LOCK NO-ERROR.
        lValorizado = NO.
        IF AVAILABLE AlmStkGe THEN DO:
            /*
            lCosto = lCosto + (AlmStkGe.CtoUni * AlmDmov.candes).
            IF AlmStkGe.CtoUni > 0 THEN lValorizado = YES.
            */
        END.
        /* Ic - 28Feb2015 : Felix Perez indico que se valorize con el precio de venta*/
        lValorizado = NO.
        /* Volumen */
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia 
            AND almmmatg.codmat = almdmov.codmat NO-LOCK NO-ERROR.
        IF AVAILABLE almmmatg THEN DO :
            lVolumen = lVolumen + ( Almdmov.candes * ( almmmatg.libre_d02 / 1000000)).
            /* Si tiene valorzacion CERO, cargo el precio de venta */
            IF lValorizado = NO THEN DO:
                IF almmmatg.monvta = 2 THEN DO:
                    /* Dolares */
                    lCosto = lCosto + ((Almmmatg.preofi * Almmmatg.tpocmb) * AlmDmov.candes).
                END.
                ELSE lCosto = lCosto + (Almmmatg.preofi * AlmDmov.candes).
            END.
        END.
    END.
    ASSIGN 
        T-CDOCU.libre_d01 = lPesos
        T-CDOCU.libre_d02 = lVolumen
        T-CDOCU.imptot    = lCosto.           
END.

/* Destino Teórico: Depende del Cliente */
FOR EACH T-CDOCU:
    ASSIGN
        T-CDOCU.Libre_c01 = '15'
        T-CDOCU.Libre_c02 = '01'.     /* Lima - Lima */
    CASE T-CDOCU.CodRef:
        WHEN "G/R" THEN DO:
            FIND B-CDOCU WHERE B-CDOCU.codcia = T-CDOCU.codcia
                AND B-CDOCU.coddoc = T-CDOCU.coddoc
                AND B-CDOCU.nrodoc = T-CDOCU.nrodoc
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE B-CDOCU THEN NEXT.
            FIND gn-clie WHERE gn-clie.codcia = cl-codcia
                AND gn-clie.codcli = B-CDOCU.codcli
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE gn-clie THEN NEXT.
            IF TRUE <> (gn-clie.CodDept > '')
                OR TRUE <> (gn-clie.CodProv > '') THEN NEXT.
            ASSIGN
                T-CDOCU.Libre_c01 = gn-clie.CodDept 
                T-CDOCU.Libre_c02 = gn-clie.CodProv.
        END.
    END CASE.
END.

/* Acumulamos */
FOR EACH T-CDOCU:
    FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-codcia
        AND VtaDTabla.Tabla = s-tabla
        AND VtaDTabla.Tipo = T-CDOCU.Libre_c01
        AND VtaDTabla.LlaveDetalle = T-CDOCU.Libre_c02,
        FIRST T-VtaCTabla OF VtaDTabla:
        ASSIGN
            T-VtaCTabla.Libre_d01 = T-VtaCTabla.Libre_d01 + 1
            T-VtaCTabla.Libre_d02 = T-VtaCTabla.Libre_d02 + T-CDOCU.libre_d01
            T-VtaCTabla.Libre_d03 = T-VtaCTabla.Libre_d03 + T-CDOCU.libre_d02
            T-VtaCTabla.Libre_d04 = T-VtaCTabla.Libre_d04 + T-CDOCU.imptot.
        ASSIGN
            T-CDOCU.Libre_c03 = T-VtaCTabla.Llave.
    END.
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
  ENABLE BUTTON-Refrescar BUTTON-1 BUTTON-2 
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

