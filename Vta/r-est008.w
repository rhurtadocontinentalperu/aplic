&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

DEF VAR s-clivar    AS CHAR FORMAT 'x(11)'.
DEFINE VAR pCodDiv AS CHAR NO-UNDO.
DEFINE VAR pCanalVenta AS CHAR NO-UNDO.
Def var x-signo1    as inte init 1.
Def var x-Day       as inte format '99'   init 1.
Def var x-Month     as inte format '99'   init 1.
Def var x-Year      as inte format '9999' init 1.
DEF VAR x-ImpAde    AS DEC NO-UNDO.     /* Importe aplicado de la factura adelantada */
DEF VAR x-ImpTot    AS DEC NO-UNDO.     /* IMporte NETO de venta */
Def var x-TpoCmbCmp as deci init 1.
Def var x-TpoCmbVta as deci init 1.
DEF VAR x-codven    AS CHAR.
DEF VAR x-fmapgo    as char.
DEF VAR x-canal     as char.
DEF VAR x-CodUnico  LIKE Gn-clie.CodUnico.
DEF VAR x-NroCard   LIKE GN-card.NroCard.
DEF VAR x-Sede      LIKE Gn-ClieD.Sede.
DEF VAR x-CodCli    LIKE Gn-clie.codcli.
DEF VAR x-Zona      AS CHAR NO-UNDO.
Def var x-coe       as deci init 0.
Def var x-can       as deci init 0.
Def var f-factor    as deci init 0.

DEF BUFFER B-CDOCU FOR Ccbcdocu.
DEF BUFFER B-DDOCU FOR CcbDdocu.
DEF BUFFER B-DIVI  FOR Gn-Divi.

DEF TEMP-TABLE detalle
    FIELD coddiv LIKE ccbcdocu.coddiv
    FIELD coddoc LIKE Ccbcdocu.CodDoc
    FIELD nrodoc LIKE Ccbcdocu.NroDoc
    FIELD fchdoc LIKE Ccbcdocu.FchDoc
    FIELD codref LIKE Ccbcdocu.CodRef
    FIELD nroref LIKE Ccbcdocu.NroRef
    FIELD codcli LIKE Ccbcdocu.CodCli
    FIELD codven LIKE Ccbcdocu.CodVen
    FIELD VtaMn AS DEC
    FIELD VtaMe AS DEC
    FIELD Cantidad AS DEC.
DEF STREAM REPORTE.

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
&Scoped-Define ENABLED-OBJECTS x-CodFchI x-CodFchF x-CodMat BUTTON-2 ~
BtnDone 
&Scoped-Define DISPLAYED-OBJECTS x-CodFchI x-CodFchF x-CodMat ~
FILL-IN-Mensaje FILL-IN-DesMat 

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

DEFINE VARIABLE FILL-IN-DesMat AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 75 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodFchF AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodFchI AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-CodMat AS CHARACTER FORMAT "x(13)":U 
     LABEL "Producto" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodFchI AT ROW 1.54 COL 10 COLON-ALIGNED WIDGET-ID 2
     x-CodFchF AT ROW 2.62 COL 10 COLON-ALIGNED WIDGET-ID 4
     x-CodMat AT ROW 3.69 COL 10 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-Mensaje AT ROW 5.31 COL 10 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     FILL-IN-DesMat AT ROW 3.69 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     BUTTON-2 AT ROW 1.27 COL 85 WIDGET-ID 14
     BtnDone AT ROW 1.27 COL 93 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 104.14 BY 5.81 WIDGET-ID 100.


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
         TITLE              = "ANEXO 1 - ESTADISTICAS"
         HEIGHT             = 5.81
         WIDTH              = 104.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 104.14
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 104.14
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
   FRAME-NAME L-To-R,COLUMNS                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* ANEXO 1 - ESTADISTICAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* ANEXO 1 - ESTADISTICAS */
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
        x-CodFchF x-CodFchI x-CodMat.
    IF x-CodMat = '' THEN DO:
        MESSAGE 'Ingrese el Producto' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = x-codmat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        MESSAGE 'Producto NO registrado' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodMat W-Win
ON LEAVE OF x-CodMat IN FRAME F-Main /* Producto */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vtagn/p-codbrr-01 (INPUT-OUTPUT pCodMat).
    IF pCodMat = '' THEN RETURN NO-APPLY.
    SELF:SCREEN-VALUE = pCodMat.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN fill-in-desmat:SCREEN-VALUE = almmmatg.desmat.
    ELSE fill-in-desmat:SCREEN-VALUE = ''.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Estadisticas-2 W-Win 
PROCEDURE Carga-Estadisticas-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

CREATE detalle.
ASSIGN
    detalle.coddiv = pCodDiv
    detalle.coddoc = Ccbcdocu.CodDoc
    detalle.nrodoc = Ccbcdocu.NroDoc
    detalle.fchdoc = Ccbcdocu.FchDoc
    detalle.codref = Ccbcdocu.CodRef
    detalle.nroref = Ccbcdocu.NroRef
    detalle.codcli = x-CodCli
    detalle.codven = x-CodVen.
IF Ccbcdocu.CodMon = 1 THEN 
    ASSIGN
        detalle.VtaMn = x-signo1 * CcbDdocu.ImpLin * x-coe
        detalle.VtaMe = x-signo1 * CcbDdocu.ImpLin * x-coe / x-TpoCmbCmp.
IF Ccbcdocu.CodMon = 2 THEN 
    ASSIGN
        detalle.VtaMn = x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta * x-coe
        detalle.VtaMe = x-signo1 * CcbDdocu.ImpLin * x-coe.
ASSIGN            
    detalle.Cantidad =  x-signo1 * CcbDdocu.CanDes * F-FACTOR * x-can.

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


FIND FIRST FacCfgGn WHERE FacCFgGn.codcia = s-codcia NO-LOCK NO-ERROR.
s-CliVar = FacCfgGn.CliVar.


FOR EACH detalle:
    DELETE detalle.
END.

FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CodCia NO-LOCK :
    /* Barremos las ventas */
    FOR EACH CcbCdocu NO-LOCK WHERE CcbCdocu.CodCia = S-CODCIA 
            AND CcbCdocu.CodDiv = Gn-Divi.CodDiv
            AND CcbCdocu.FchDoc >= x-CodFchI
            AND CcbCdocu.FchDoc <= x-CodFchF
            AND LOOKUP(CcbCdocu.TpoFac, 'A,S') = 0      /* NO facturas adelantadas NI servicios */
            USE-INDEX llave10
            BREAK BY CcbCdocu.CodCia BY CcbCdocu.CodDiv BY CcbCdocu.FchDoc:
        pCodDiv = Ccbcdocu.coddiv.      /* VALOR POR DEFECTO */
        pCanalVenta = GN-DIVI.CanalVenta.

        IF Ccbcdocu.coddiv <> '00017' 
            AND Ccbcdocu.codven = '151' THEN pCodDiv = '00017'.   /* Supermercados */
        IF Ccbcdocu.coddiv <> '00018' 
            AND LOOKUP(Ccbcdocu.codven, '015,173,900,901,902,017') > 0 THEN pCodDiv = '00018'.    /* Provincias */
        IF Ccbcdocu.codcli = '20511358907' THEN pCodDiv = '00022'.  /* STANDFORD */
        IF Ccbcdocu.coddiv <> '00019' 
            AND Ccbcdocu.codven = '081' THEN pCodDiv = '00019'.   /* Mesa redonda */
        /* ***************** FILTROS ********************************** */
        IF LOOKUP(CcbCDocu.CodDoc,"TCK,FAC,BOL,N/C,N/D") = 0 THEN NEXT.
        IF CcbCDocu.FlgEst = "A"  THEN NEXT.
        IF DAY(CcbCDocu.FchDoc) = 0 OR DAY(CcbCDocu.FchDoc) = ? THEN NEXT.
        IF Ccbcdocu.CodDoc = 'N/C' THEN DO:
            FIND B-CDOCU WHERE B-CDOCU.Codcia = CcbCdocu.Codcia 
                AND B-CDOCU.CodDoc = CcbCdocu.Codref 
                AND B-CDOCU.NroDoc = CcbCdocu.Nroref 
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE B-CDOCU THEN NEXT.
            IF LOOKUP(B-CDOCU.TpoFac, 'A,S') > 0 THEN NEXT.     /* NO SERVICIOS NI ADELANTADAS */
            IF B-CDOCU.coddiv <> '00017' 
                AND B-CDOCU.codven = '151' THEN pCodDiv = '00017'.   /* Supermercados */
            IF B-CDOCU.coddiv <> '00018' 
                AND LOOKUP(B-CDOCU.codven, '015,173,901,902') > 0 THEN pCodDiv = '00018'.    /* Provincias */
            IF B-CDOCU.codcli = '20511358907' THEN pCodDiv = '00022'.  /* STANDFORD */
        END.
        fill-in-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** PROCESANDO  " + STRING(ccbcdocu.fchdoc) + ' ' +
            ccbcdocu.coddoc + ' ' + ccbcdocu.nrodoc.
        /* *********************************************************** */
        FIND B-DIVI WHERE B-DIVI.codcia = s-codcia
            AND B-DIVI.coddiv = pCodDiv NO-LOCK NO-ERROR.
        IF AVAILABLE B-DIVI THEN pCanalVenta = B-DIVI.CanalVenta.
        /* *********************************************************** */
        ASSIGN
            x-signo1 = ( IF CcbCdocu.Coddoc = "N/C" THEN -1 ELSE 1 )
            x-Day   = DAY(CcbCdocu.FchDoc)
            x-Month = MONTH(CcbCdocu.FchDoc)
            x-Year  = YEAR(CcbCdocu.FchDoc)
            x-ImpTot = Ccbcdocu.ImpTot.     /* <<< OJO <<< */

        /* buscamos si hay una aplicación de fact adelantada */
        FIND FIRST Ccbddocu OF Ccbcdocu WHERE Ccbddocu.implin < 0 NO-LOCK NO-ERROR.
        IF AVAILABLE Ccbddocu THEN x-ImpTot = x-ImpTot + ABSOLUTE(Ccbddocu.ImpLin).
        /* ************************************************* */

        FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc NO-LOCK NO-ERROR.
        IF NOT AVAIL Gn-Tcmb THEN 
            FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc NO-LOCK NO-ERROR.
        IF AVAIL Gn-Tcmb THEN 
            ASSIGN
                x-TpoCmbCmp = Gn-Tcmb.Compra
                x-TpoCmbVta = Gn-Tcmb.Venta.

        /* VARIABLES DE VENTAS */
        ASSIGN
            x-codven = Ccbcdocu.CodVen
            X-FMAPGO = CcbCdocu.FmaPgo
            x-NroCard = Ccbcdocu.nrocard
            x-Sede = Ccbcdocu.Sede 
            x-Canal = ''
            x-CodCli = Ccbcdocu.CodCli
            x-CodUnico = Ccbcdocu.codcli
            x-Zona = ''.

        IF CcbCdocu.Coddoc = "N/C" THEN DO:
           FIND B-CDOCU WHERE B-CDOCU.Codcia = CcbCdocu.Codcia 
               AND B-CDOCU.Coddoc = CcbCdocu.Codref 
               AND B-CDOCU.NroDoc = CcbCdocu.Nroref
               NO-LOCK NO-ERROR.
           IF AVAILABLE B-CDOCU THEN DO:
               ASSIGN
                   x-CodVen = B-CDOCU.CodVen
                   X-FMAPGO = B-CDOCU.FmaPgo
                   x-NroCard = B-CDOCU.NroCard
                   x-Sede = B-CDOCU.Sede.
           END.
        END.

        /* CANAL */
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia     /* OJO */
            AND gn-clie.codcli = Ccbcdocu.codcli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie AND gn-clie.codunico <> '' THEN x-codunico = gn-clie.codunico.
        IF AVAILABLE Gn-clie THEN x-canal = gn-clie.Canal.
        /* ZONA */
        IF AVAILABLE gn-clie THEN DO:
            FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
            IF AVAILABLE TabDepto THEN x-Zona = TabDepto.Zona.
            /* 20.07.10 */
            IF gn-clie.CodDept = '15' AND gn-clie.CodProv = '01' THEN x-Zona = 'LMC'.
        END.

        /* EN CASO DE SER UN CLIENTE VARIOS */
        IF Ccbcdocu.codcli = s-CliVar THEN DO:
            ASSIGN
                x-CodCli = s-CliVar
                x-CodUnico = s-CliVar.
            IF x-NroCard <> '' THEN DO:
                FIND FIRST Gn-Clie WHERE  Gn-clie.codcia = cl-codcia
                    AND Gn-clie.nrocard = x-NroCard
                    AND Gn-clie.flgsit = 'A'        /* ACTIVOS */
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE Gn-clie 
                THEN FIND FIRST Gn-Clie WHERE  Gn-clie.codcia = cl-codcia
                        AND Gn-clie.nrocard = x-NroCard
                        NO-LOCK NO-ERROR.
                IF AVAILABLE Gn-Clie THEN x-CodUnico = Gn-Clie.CodUnico.
            END.
        END.
        /* ******************************** */
        
        /* NOTAS DE CREDITO por OTROS conceptos */
        /* RHC 15.03.10 considerar los rEbates */
       IF CcbCdocu.Coddoc = "N/C" AND CcbCdocu.CndCre = "N" AND Ccbcdocu.TpoFac <> "E" THEN DO:
           RUN PROCESA-NOTA.
           NEXT.
       END.
       IF CcbCdocu.Coddoc = "N/C" AND CcbCdocu.CndCre = "N" AND Ccbcdocu.TpoFac = "E" THEN DO:
           RUN PROCESA-NOTA-REBATE.
           NEXT.
       END.

       ASSIGN
           x-Coe = 1
           x-Can = 1.
       FOR EACH CcbDdocu OF CcbCdocu NO-LOCK WHERE Ccbddocu.CodMat = x-CodMat:
           /* ****************** Filtros ************************* */
           FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia 
               AND Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR.
           IF NOT AVAILABLE Almmmatg THEN NEXT.
           IF Ccbddocu.implin <= 0 THEN NEXT.       /* <<< OJO <<< */
           /* **************************************************** */
           FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
               AND Almtconv.Codalter = Ccbddocu.UndVta
               NO-LOCK NO-ERROR.
           F-FACTOR  = 1. 
           IF AVAILABLE Almtconv THEN DO:
              F-FACTOR = Almtconv.Equival.
              IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
           END.

           RUN Carga-Estadisticas-2.    /* Estadísticas CON materiales */
       END.  
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
  DISPLAY x-CodFchI x-CodFchF x-CodMat FILL-IN-Mensaje FILL-IN-DesMat 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-CodFchI x-CodFchF x-CodMat BUTTON-2 BtnDone 
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

DEF VAR x-Llave AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR x-Titulo AS CHAR FORMAT 'x(1000)' NO-UNDO.
DEF VAR x-Archivo AS CHAR NO-UNDO.
DEF VAR x-NomPro LIKE gn-prov.nompro NO-UNDO.

RUN Carga-Temporal.
FIND FIRST detalle NO-LOCK NO-ERROR.
IF NOT AVAILABLE detalle THEN DO:
    MESSAGE 'No hay Registros' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

x-Archivo = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".txt".

FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** GENERANDO EL EXCEL **".
OUTPUT STREAM REPORTE TO VALUE (x-Archivo).
x-Titulo = 'Division|Codigo|Numero|Fecha|Referencia|Numero|Cliente|Vendedor|' +
    'Importe en S/.|Importe en US$|Cantidad|Unidad|'.
x-Titulo = REPLACE(x-Titulo, '|', CHR(9) ).
PUT STREAM REPORTE x-Titulo SKIP.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** EXCEL **".
FOR EACH detalle NO-LOCK:
    FIND gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = detalle.coddiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN x-Llave = detalle.coddiv + ' ' + GN-DIVI.DesDiv + '|'.
    ELSE x-Llave = detalle.coddiv + '|'.
    x-Llave = x-LLave + detalle.coddoc + '|' + 
        detalle.nrodoc + '|' +
        STRING(detalle.fchdoc, '99/99/9999') + '|' +
        detalle.codref + '|' + 
        detalle.nroref + '|'.
    FIND gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = detalle.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN x-Llave = x-LLave + detalle.codcli + ' ' + gn-clie.nomcli + '|'.
    ELSE x-Llave = x-Llave + detalle.codcli + '|'.
    FIND gn-ven WHERE gn-ven.codcia = s-codcia
        AND gn-ven.codven = detalle.codven NO-LOCK NO-ERROR.
    IF AVAILABLE gn-ven THEN x-Llave = x-Llave + detalle.codven + ' ' + gn-ven.NomVen + '|'.
    ELSE x-Llave = x-Llave + detalle.codven + '|'.
    x-Llave = x-Llave + STRING(detalle.vtamn, '->>>,>>>,>>9.99') + '|' +
            STRING(detalle.vtame, '->>>,>>>,>>9.99') + '|' +
            STRING(detalle.Cantidad, '->>>,>>>,>>9.99') + '|' +
            Almmmatg.undbas + '|'.
    x-Llave = REPLACE ( x-Llave, '|', CHR(9) ).
    PUT STREAM REPORTE x-LLave SKIP.
END.
OUTPUT STREAM REPORTE CLOSE.

/* CARGAMOS EL EXCEL */
RUN lib/filetext-to-excel(x-Archivo, 'Anexo 1', YES).
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** FIN DEL PROCESO **".

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
      x-CodFchF = TODAY
      x-CodFchI = TODAY - DAY(TODAY) + 1.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESA-NOTA W-Win 
PROCEDURE PROCESA-NOTA :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    x-Can = 0                       /* ¿¿¿ OJO ??? */
    x-ImpTot = B-CDOCU.ImpTot.      /* <<< OJO <<< */

/* buscamos si hay una aplicación de fact adelantada */
FIND FIRST Ccbddocu OF B-CDOCU WHERE Ccbddocu.implin < 0 NO-LOCK NO-ERROR.
IF AVAILABLE Ccbddocu THEN x-ImpTot = x-ImpTot + ABSOLUTE(Ccbddocu.ImpLin).
/* ************************************************* */
x-Coe = Ccbcdocu.ImpTot / x-ImpTot.     /* OJO */
FOR EACH CcbDdocu OF B-CDOCU NO-LOCK WHERE Ccbddocu.CodMat = x-CodMat:
    /* ***************** FILTROS ********************************* */
    FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia 
        AND Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN NEXT.
    IF Ccbddocu.implin <= 0 THEN NEXT.       /* <<< OJO <<< */
    /* ************************************************************ */
    F-FACTOR  = 1. 
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = Ccbddocu.UndVta
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN DO:
       F-FACTOR = Almtconv.Equival.
       IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
    END.

    RUN Carga-Estadisticas-2.    /* Estadísticas CON materiales */

END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PROCESA-NOTA-REBATE W-Win 
PROCEDURE PROCESA-NOTA-REBATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* EL REBATE ES APLICADO SOLO A PRODUCTOS DE LA FAMILIA 010 Y 012 */
    FIND B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
        AND B-CDOCU.coddoc = Ccbcdocu.codref
        AND B-CDOCU.nrodoc = Ccbcdocu.nroref
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN RETURN.
    ASSIGN
        x-Can = 0                       /* ¿¿¿ OJO ??? */
        x-ImpTot = 0.                   /* <<< OJO <<< */
    FOR EACH CcbDdocu OF B-CDOCU NO-LOCK WHERE Ccbddocu.ImpLin > 0,
        FIRST Almmmatg OF Ccbddocu NO-LOCK WHERE LOOKUP(Almmmatg.codfam , '010,012') > 0:
        x-ImpTot = x-ImpTot + Ccbddocu.ImpLin.
    END.  
    IF x-ImpTot <= 0 THEN RETURN.
    /* ************************************************* */
    x-Coe = Ccbcdocu.ImpTot / x-ImpTot.     /* OJO */
    FOR EACH CcbDdocu OF B-CDOCU NO-LOCK WHERE Ccbddocu.CodMat = x-CodMat:
        /* ***************** FILTROS ********************************* */
        FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia 
            AND Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmatg THEN NEXT.
        IF LOOKUP(Almmmatg.codfam , '010,012') = 0 THEN NEXT.
        IF Ccbddocu.implin <= 0 THEN NEXT.       /* <<< OJO <<< */
        /* ************************************************************ */
        F-FACTOR  = 1. 
        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
            AND Almtconv.Codalter = Ccbddocu.UndVta
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN DO:
           F-FACTOR = Almtconv.Equival.
           IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
        END.

        RUN Carga-Estadisticas-2.    /* Estadísticas CON materiales */

    END.  

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
        WHEN "" THEN .
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

