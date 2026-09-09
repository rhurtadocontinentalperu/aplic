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

DEF VAR s-codcia    as inte init 1.         /* OJO */
DEF VAR s-clivar    AS CHAR FORMAT 'x(11)'.
DEF VAR s-CliUni    AS CHAR FORMAT 'x(11)' INIT '99999999999' NO-UNDO.

DEF VAR x-signo1    as inte init 1.
DEF VAR x-fin       as inte init 0.
DEF VAR f-factor    as deci init 0.
DEF VAR x-NroFchI   as inte init 0.
DEF VAR x-NroFchF   as inte init 0.
DEF VAR x-CodFchI   as date format '99/99/9999' init TODAY.
DEF VAR x-CodFchF   as date format '99/99/9999' init TODAY.
DEF VAR i           as inte init 0.
DEF VAR x-TpoCmbCmp as deci init 1.
DEF VAR x-TpoCmbVta as deci init 1.
DEF VAR x-Day       as inte format '99'   init 1.
DEF VAR x-Month     as inte format '99'   init 1.
DEF VAR x-Year      as inte format '9999' init 1.
DEF VAR x-coe       as deci init 0.
DEF VAR x-can       as deci init 0.

DEF VAR x-ImpAde    AS DEC NO-UNDO.     /* Importe aplicado de la factura adelantada */
DEF VAR x-ImpTot    AS DEC NO-UNDO.     /* IMporte NETO de venta */

DEF BUFFER B-CDOCU FOR CcbCdocu.

DEF VAR x-fmapgo    as char.
DEF VAR x-canal     as char.
DEF VAR x-CodUnico  LIKE Gn-clie.CodUnico.
DEF VAR x-NroCard   LIKE GN-card.NroCard.
DEF VAR x-Sede      LIKE Gn-ClieD.Sede.
DEF VAR cl-CodCia   AS INT NO-UNDO.
DEF VAR x-CodCli    LIKE Gn-clie.codcli.

FIND FIRST Empresas WHERE Empresas.codcia = s-codcia NO-LOCK NO-ERROR.
IF AVAILABLE Empresas THEN DO:
    IF NOT Empresas.Campo-CodCli THEN cl-codcia = s-codcia.
END.
FIND FIRST FacCfgGn WHERE FacCFgGn.codcia = s-codcia NO-LOCK NO-ERROR.
  s-CliVar = FacCfgGn.CliVar.


DEFINE TEMP-TABLE tmp-datos
    FIELDS tpodoc    LIKE ccbcdocu.coddoc
    FIELDS nrodoc    LIKE ccbcdocu.nrodoc
    FIELDS codmat    LIKE almmmatg.codmat
    FIELDS fchdoc    LIKE ccbcdocu.fchdoc
    FIELDS codcli    LIKE gn-clie.codcli    
    FIELDS licencia  AS CHAR
    FIELDS totimp    LIKE ccbcdocu.ImpTot.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 txt-cliente txt-desde txt-hasta ~
BUTTON-3 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS txt-cliente txt-desde txt-hasta txt-msj 

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
     SIZE 8 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 8 BY 1.62.

DEFINE VARIABLE txt-cliente AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-desde AS DATE FORMAT "99/99/99":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-hasta AS DATE FORMAT "99/99/99":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 50 BY .81
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 3.77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-cliente AT ROW 3.15 COL 19 COLON-ALIGNED WIDGET-ID 26
     txt-desde AT ROW 4.23 COL 19 COLON-ALIGNED WIDGET-ID 28
     txt-hasta AT ROW 4.23 COL 45 COLON-ALIGNED WIDGET-ID 30
     BUTTON-3 AT ROW 6.38 COL 3 WIDGET-ID 20
     BtnDone AT ROW 6.38 COL 11 WIDGET-ID 22
     txt-msj AT ROW 6.77 COL 21 NO-LABEL WIDGET-ID 2
     "CRITERIOS DE SELECCION" VIEW-AS TEXT
          SIZE 25 BY .54 AT ROW 2.08 COL 5 WIDGET-ID 18
          BGCOLOR 7 FGCOLOR 15 
     RECT-1 AT ROW 2.35 COL 3 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 7.69 WIDGET-ID 100.


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
         TITLE              = "zzzz"
         HEIGHT             = 7.69
         WIDTH              = 80
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
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
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       txt-msj:HIDDEN IN FRAME F-Main           = TRUE
       txt-msj:READ-ONLY IN FRAME F-Main        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* zzzz */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* zzzz */
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
  ASSIGN
      txt-cliente txt-desde txt-hasta.

  RUN Excel.
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.

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
    DEFINE VARIABLE clicencia AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-signo1  AS INTEGER     NO-UNDO.

    FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
        FOR EACH CcbCdocu USE-INDEX llave09 WHERE CcbCdocu.CodCia = S-CODCIA 
            AND CcbCdocu.CodDiv =  gn-divi.coddiv
            AND CcbCdocu.codcli =  txt-cliente
            AND CcbCdocu.FchDoc >= txt-desde
            AND CcbCdocu.FchDoc <= txt-hasta
            AND LOOKUP(CcbCdocu.CodDoc,'FAC,BOL,TCK,N/C') > 0
            AND CcbCdocu.TpoFac <> 'A'      /* NO facturas adelantadas */ NO-LOCK ,
            EACH CcbDdocu OF CcbCdocu NO-LOCK
            BREAK BY CcbCdocu.CodDoc
            BY CcbCdocu.NroDoc:

            x-signo1 = ( IF CcbCdocu.Coddoc = "N/C" THEN -1 ELSE 1 ).
            FIND FIRST almmmatg WHERE almmmatg.codcia = ccbcdocu.codcia
                AND almmmatg.codmat = CcbDdocu.codmat NO-LOCK NO-ERROR.

            IF AVAIL almmmatg THEN DO: 
                cLicencia = almmmatg.Licencia[1].
                IF cLicencia = '' THEN cLicencia = almmmatg.Licencia[2].
            END.

            FIND FIRST tmp-datos WHERE tmp-datos.tpodoc = ccbcdocu.coddoc
                AND tmp-datos.nrodoc = ccbcdocu.nrodoc
                AND tmp-datos.codmat = ccbddocu.codmat NO-LOCK NO-ERROR.
            IF NOT AVAIL tmp-datos THEN DO:
                MESSAGE 'crea'.
                CREATE tmp-datos.
                ASSIGN 
                    tmp-datos.tpodoc = ccbcdocu.coddoc
                    tmp-datos.nrodoc = ccbcdocu.nrodoc
                    tmp-datos.codmat = ccbddocu.codmat
                    tmp-datos.fchdoc = ccbcdocu.fchdoc
                    tmp-datos.codcli = ccbcdocu.codcli                    
                    tmp-datos.licencia = cLicencia.                    
            END.
            ASSIGN tmp-datos.totimp = tmp-datos.totimp + (CcbDDocu.ImpLin * x-signo1).       

            IF LAST-OF(Ccbcdocu.nrodoc) THEN DO:
                CREATE tmp-datos.
                ASSIGN 
                    tmp-datos.tpodoc = ccbcdocu.coddoc
                    tmp-datos.nrodoc = ccbcdocu.nrodoc
                    tmp-datos.codmat = 'XXX'
                    tmp-datos.fchdoc = ccbcdocu.fchdoc
                    tmp-datos.codcli = ccbcdocu.codcli                    
                    tmp-datos.licencia = '0'
                    tmp-datos.totimp = CcbCDocu.ImpTot.
            END.
        END.
    END.

/*

FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CodCia NO-LOCK :
    /* Barremos las ventas */
    FOR EACH CcbCdocu NO-LOCK WHERE CcbCdocu.CodCia = S-CODCIA 
        AND CcbCdocu.CodDiv = Gn-Divi.CodDiv
        AND CcbCdocu.FchDoc >= x-CodFchI
        AND CcbCdocu.FchDoc <= x-CodFchF
        AND CcbCdocu.TpoFac <> 'A'      /* NO facturas adelantadas */
        USE-INDEX llave10
        BREAK BY CcbCdocu.CodCia BY CcbCdocu.CodDiv BY CcbCdocu.FchDoc:

        /* ***************** FILTROS ********************************** */
        IF LOOKUP(CcbCDocu.CodDoc,"TCK,FAC,BOL,N/C,N/D") = 0 THEN NEXT.
        IF CcbCDocu.FlgEst = "A"  THEN NEXT.
        IF DAY(CcbCDocu.FchDoc) = 0 OR DAY(CcbCDocu.FchDoc) = ? THEN NEXT.
        IF CcbCDocu.TpoFac = 'S' THEN NEXT.     /* NO Servicios */
        IF CcbCDocu.ImpCto = ? THEN DO: 
            RUN Corrige-Costo.
            IF RETURN-VALUE = 'ADM-ERROR' THEN NEXT.
        END.
        /* *********************************************************** */
        DISPLAY CcbCdocu.Codcia CcbCdocu.Coddiv CcbCdocu.FchDoc  CcbCdocu.CodDoc CcbCdocu.NroDoc
                STRING(TIME,'HH:MM') TODAY.
        PAUSE 0.
 
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

        FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
            USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF NOT AVAIL Gn-Tcmb THEN 
            FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
                USE-INDEX Cmb01 NO-LOCK NO-ERROR.
        IF AVAIL Gn-Tcmb THEN 
            ASSIGN
                x-TpoCmbCmp = Gn-Tcmb.Compra
                x-TpoCmbVta = Gn-Tcmb.Venta.

        /* VARIABLES DE VENTAS */
        ASSIGN
            X-FMAPGO = CcbCdocu.FmaPgo
            x-NroCard = Ccbcdocu.nrocard
            x-Sede = Ccbcdocu.Sede 
            x-Canal = ''
            x-CodCli = Ccbcdocu.CodCli
            x-CodUnico = Ccbcdocu.codcli.

        IF CcbCdocu.Coddoc = "N/C" THEN DO:
           FIND B-CDOCU WHERE B-CDOCU.Codcia = CcbCdocu.Codcia 
               AND B-CDOCU.Coddoc = CcbCdocu.Codref 
               AND B-CDOCU.NroDoc = CcbCdocu.Nroref
               NO-LOCK NO-ERROR.
           IF AVAILABLE B-CDOCU THEN DO:
               X-FMAPGO = B-CDOCU.FmaPgo.
               x-NroCard = B-CDOCU.NroCard.
               x-Sede = B-CDOCU.Sede.
           END.
        END.
        
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia     /* OJO */
            AND gn-clie.codcli = Ccbcdocu.codcli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie AND gn-clie.codunico <> '' THEN x-codunico = gn-clie.codunico.
        IF AVAILABLE Gn-clie THEN x-canal = gn-clie.Canal.

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
        
        RUN Carga-Estadisticas.     /* Estadísticas SIN materiales */

        /* NOTAS DE CREDITO por OTROS conceptos */
       IF CcbCdocu.Coddoc = "N/C" AND CcbCdocu.CndCre = "N" THEN DO:
           RUN PROCESA-NOTA.
           NEXT.
       END.

       ASSIGN
           x-Coe = 1
           x-Can = 1.
       FOR EACH CcbDdocu OF CcbCdocu NO-LOCK:
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

*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Corrige-Costo W-Win 
PROCEDURE Corrige-Costo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND B-CDOCU WHERE ROWID(B-CDOCU) = ROWID(Ccbcdocu) EXCLUSIVE-LOCK NO-WAIT.
    IF ERROR-STATUS:ERROR THEN RETURN 'ADM-ERROR'.
    B-CDOCU.ImpCto = 0.        /* <<< OJO <<< */
    RELEASE B-CDOCU.
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
  DISPLAY txt-cliente txt-desde txt-hasta txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 txt-cliente txt-desde txt-hasta BUTTON-3 BtnDone 
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 4.
DEFINE VARIABLE t-Letra                 AS INTEGER.
DEFINE VARIABLE iInt                    AS INTEGER     NO-UNDO.

DEFINE VARIABLE cLetra  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLetra2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE t-col   AS INTEGER     NO-UNDO.


RUN Carga-Temporal.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A3"):Value = "Tipo Doc".
chWorkSheet:Range("B3"):Value = "Nro Documento".
chWorkSheet:Range("C3"):Value = "Fecha".
chWorkSheet:Range("D3"):Value = "Cliente".
chWorkSheet:Range("E3"):Value = "Licencia".
chWorkSheet:Range("F3"):Value = "Importe".

/*Formato*/
chWorkSheet:Columns("B"):NumberFormat = "@".
chWorkSheet:Columns("D"):NumberFormat = "@".

t-column = 3.
FOR EACH tmp-datos NO-LOCK
    BREAK BY tmp-datos.tpodoc
    BY tmp-datos.nrodoc:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.TpoDoc.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.NroDoc.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.FchDoc.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.CodCli.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.licencia.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.totimp.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = tmp-datos.codmat.
END.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

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
  DEFINE VARIABLE dInicio AS DATE NO-UNDO.
  DEFINE VARIABLE dFin AS DATE NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */  
  RUN bin/_dateif (MONTH(TODAY), YEAR(TODAY), OUTPUT dInicio, OUTPUT dFin).

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN 
          txt-desde = dInicio
          txt-Hasta = TODAY.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Nota W-Win 
PROCEDURE Procesa-Nota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND B-CDOCU WHERE B-CDOCU.Codcia = CcbCdocu.Codcia 
        AND B-CDOCU.CodDoc = CcbCdocu.Codref 
        AND B-CDOCU.NroDoc = CcbCdocu.Nroref 
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN RETURN.
    
    ASSIGN
        x-Can = 0                       /* ¿¿¿ OJO ??? */
        x-ImpTot = B-CDOCU.ImpTot.      /* <<< OJO <<< */
    
    /* buscamos si hay una aplicación de fact adelantada */
    FIND FIRST Ccbddocu OF B-CDOCU WHERE Ccbddocu.implin < 0 NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbddocu THEN x-ImpTot = x-ImpTot + ABSOLUTE(Ccbddocu.ImpLin).
    /* ************************************************* */
    x-Coe = Ccbcdocu.ImpTot / x-ImpTot.     /* OJO */
    FOR EACH CcbDdocu OF B-CDOCU NO-LOCK:
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Top-100 W-Win 
PROCEDURE Top-100 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR k AS INT NO-UNDO.

    /* CALCULAMOS las ventas de los 3 últimos años */
    ASSIGN
        x-NroFchI = INTEGER(STRING(YEAR(TODAY) - 3,"9999") + STRING(MONTH(TODAY),"99"))
        x-NroFchF = INTEGER(STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99")).                           

    FOR EACH Gn-divi NO-LOCK WHERE Gn-divi.codcia = s-codcia:
        FOR EACH Evtall01 NO-LOCK WHERE Evtall01.codcia = s-codcia
                AND Evtall01.nrofch >= x-NroFchI
                AND Evtall01.nrofch <= x-NroFchF
                AND Evtall01.coddiv = GN-divi.coddiv:
            ASSIGN
                x-CodUnico = Evtall01.CodUnico
                x-CodCli   = Evtall01.CodUnico.
            FIND Evtall03 WHERE Evtall03.codcia = Evtall01.codcia
                AND Evtall03.codunico = x-CodUnico
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Evtall03 THEN CREATE EvtALL03.
            ASSIGN
                EvtALL03.CodCia = Evtall01.codcia
                EvtALL03.CodCli = x-CodCli
                EvtALL03.CodUnico = x-CodUnico
                EvtALL03.VtaxMesMe = EvtALL03.VtaxMesMe + Evtall01.VtaxMesMe
                EvtALL03.VtaxMesMn = EvtALL03.VtaxMesMn + Evtall01.VtaxMesMn.
            RELEASE Evtall03.
            FIND Evtall04 WHERE Evtall04.codcia = Evtall01.codcia
                AND Evtall04.codunico = x-CodUnico
                AND Evtall04.CodCli   = Evtall01.CodCli
                AND Evtall04.NroFch   = Evtall01.NroFch
                AND Evtall04.coddiv   = Evtall01.coddiv
                AND Evtall04.CodFam   = Evtall01.CodFam
                AND Evtall04.CodVen   = Evtall01.CodVen
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Evtall04 THEN CREATE Evtall04.
            ASSIGN
                Evtall04.CodCia    = Evtall01.codcia
                Evtall04.CodUnico  = x-CodUnico
                Evtall04.CodCli    = Evtall01.CodCli
                Evtall04.NroFch    = Evtall01.NroFch
                EvtALL04.CodDiv    = Evtall01.CodDiv
                EvtALL04.codfam    = Evtall01.CodFam
                EvtAll04.CodVen    = Evtall01.CodVen
                EvtALL04.Codano    = evtall01.codano               
                EvtALL04.Codmes    = Evtall01.codmes
                EvtALL04.CanxMes   = EvtALL04.CanxMes + EvtALL01.CanxMes 
                Evtall04.VtaxMesMe = Evtall04.VtaxMesMe + Evtall01.VtaxMesMe
                Evtall04.VtaxMesMn = Evtall04.VtaxMesMn + Evtall01.VtaxMesMn.
            RELEASE Evtall04.
        END.
    END.

    /* CREAMOS EL ARCHIVO RESUMEN DE LOS TOP 100 */
    DEF VAR x-Cuenta AS INT NO-UNDO.

    FOR EACH EvtALL03 USE-INDEX Indice02 NO-LOCK WHERE Evtall03.codcia = s-codcia
            BY Evtall03.VtaxMesMn DESC:
        x-Cuenta = x-Cuenta + 1.
        /* Definimos si va al detalle o unificados */
        ASSIGN
            x-CodUnico = Evtall03.codunico
            x-CodCli   = Evtall03.codcli.
        IF x-Cuenta > 200           /* Resumimos por el cliente unificado */
        THEN ASSIGN
                x-CodUnico = s-CliUni
                x-CodCli   = s-CliUni.
        DISPLAY 'top 200' x-cuenta evtall03.codunico x-codunico STRING(TIME,'hh:mm')
            WITH STREAM-IO NO-BOX NO-LABELS.
        PAUSE 0.
        /* Acumulamos la información detallada por cada año */
        x-Month = MONTH(TODAY).     /* Mes de partida */
        DO k = YEAR(TODAY) - 3 TO YEAR(TODAY):
            x-Year = k.
            REPEAT WHILE x-Month <= 12:
                x-NroFchI = x-Year * 100 + x-Month.
                FOR EACH Gn-divi NO-LOCK WHERE Gn-divi.codcia = s-codcia:
                    FOR EACH Evtall01 NO-LOCK WHERE Evtall01.codcia = Evtall03.codcia
                            AND Evtall01.nrofch = x-NroFchI
                            AND Evtall01.coddiv = Gn-divi.CodDiv
                            AND Evtall01.codunico = EvtAll03.CodUnico:
                        FIND EvtAll02 USE-INDEX Indice05 WHERE EvtAll02.Codcia = Evtall01.Codcia
                            AND EvtAll02.CodUnico = x-CodUnico
                            AND EvtAll02.CodDiv = Evtall01.Coddiv
                            AND EvtAll02.Nrofch = Evtall01.NroFch
                            /*AND EvtAll02.FmaPgo = Evtall01.FmaPgo*/
                            AND EvtAll02.CodFam = Evtall01.CodFam
                            /*AND EvtAll02.SubFam = Evtall01.SubFam*/
                            AND EvtAll02.DesMar = Evtall01.DesMar
                            EXCLUSIVE-LOCK
                            NO-ERROR.
                        IF NOT AVAILABLE EvtAll02 THEN DO:
                             CREATE EvtAll02.
                             BUFFER-COPY EvtAll01
                                 EXCEPT
                                    EvtAll01.CodCli
                                    EvtAll01.CodUnico
                                    EvtAll01.NroCard
                                    EvtAll01.Sede
                                    EvtAll01.CodVen
                                    EvtAll01.CodMat
                                    EvtAll01.SubFam
                                    EvtAll01.FmaPgo
                                    EvtAll01.Canal
                                    EvtAll01.CodPais
                                    EvtAll01.CodDept
                                    EvtAll01.CodProv
                                    EvtAll01.CodDist
                                    EvtAll01.CtoxDiaMn
                                    EvtAll01.VtaxDiaMn
                                    EvtAll01.CtoxMesMn
                                    EvtAll01.VtaxMesMn
                                    EvtAll01.CtoxDiaMe
                                    EvtAll01.VtaxDiaMe
                                    EvtAll01.CtoxMesMe
                                    EvtAll01.VtaxMesMe
                                    EvtAll01.CanxDia
                                    EvtAll01.CanxMes
                                 TO EvtAll02
                                 ASSIGN
                                    /*EvtAll02.CodCli = x-CodCli*/
                                    EvtAll02.CodUnico = x-CodUnico
                                    EvtAll02.Ranking = x-Cuenta.
                        END.
                        ASSIGN
                            EvtAll02.CtoxMesMn = EvtAll02.CtoxMesMn + EvtAll01.CtoxMesMn
                            EvtAll02.VtaxMesMn = EvtAll02.VtaxMesMn + EvtAll01.VtaxMesMn
                            EvtAll02.CtoxMesMe = EvtAll02.CtoxMesMe + EvtAll01.CtoxMesMe
                            EvtAll02.VtaxMesMe = EvtAll02.VtaxMesMe + EvtAll01.VtaxMesMe
                            EvtAll02.CanxMes = EvtAll02.CanxMes + EvtAll01.CanxMes.
                    END.
                END.    /* Gn-Divi */
                x-Month = x-Month + 1.
            END.    /* REPEAT */
            x-Month = 01.
        END.
        /* FIN ciclo de acumulacion */
    END.    /* EvtALL03 */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

