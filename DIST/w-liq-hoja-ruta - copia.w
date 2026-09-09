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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR pv-codcia AS INT.
DEFINE SHARED VAR cl-codcia AS INT.

DEFINE TEMP-TABLE tt-hojaruta
        FIELDS tt-codcia LIKE DI-RutaC.codcia
        FIELDS tt-coddoc LIKE DI-RutaC.coddoc       
        FIELDS tt-nrodoc LIKE DI-RutaC.nrodoc
        FIELDS tt-flgest LIKE DI-RutaC.flgest
        FIELDS tt-horsal LIKE DI-RutaC.horsal
        FIELDS tt-horret LIKE DI-RutaC.horret
        FIELDS tt-fchsal LIKE DI-RutaC.fchsal
        FIELDS tt-kmtini LIKE DI-RutaC.kmtini
        FIELDS tt-kmtfin LIKE DI-RutaC.kmtfin
        FIELDS tt-codveh LIKE DI-RutaC.codveh
        FIELDS tt-guiatransportista LIKE DI-RutaC.guiatransportista
        FIELDS tt-nomtra LIKE DI-RutaC.nomtra
        FIELDS tt-tipomov AS CHAR FORMAT "x(30)"  /*"TRANSFERENCIAS"*/
        FIELDS tt-coddiv LIKE DI-RutaG.coddiv
        FIELDS tt-desdiv AS CHAR FORMAT 'x(50)'
        FIELDS tt-coclie LIKE ccbcdocu.codcli
        FIELDS tt-nomcli LIKE gn-clie.nomcli
        FIELDS tt-serref LIKE DI-RutaD.codref
        FIELDS tt-nroref LIKE DI-RutaD.nroref FORMAT 'x(15)'
        FIELDS tt-libre_d02 LIKE DI-RutaG.libre_d02
        FIELDS tt-libre_d01 LIKE Di-RutaG.libre_d01 
        FIELDS tt-flgest1 LIKE DI-RutaG.flgest
        FIELDS tt-tienda LIKE DI-RutaD.libre_c02
        FIELDS tt-horlle LIKE DI-RutaG.horlle
        FIELDS tt-horpar LIKE DI-RutaG.horpar
        FIELDS tt-dpto AS CHAR FORMAT "X(50)"
        FIELDS tt-prov AS CHAR FORMAT "x(50)"
        FIELDS tt-distrito AS CHAR FORMAT "X(50)"
        FIELDS tt-destino AS CHAR FORMAT "X(50)"
        FIELDS tt-items AS INT FORMAT ">>,>>>,>>9"
        FIELDS tt-tonelaje AS DEC 
        FIELDS tt-costo AS DEC 
        FIELDS tt-tipocontrato AS CHAR FORMAT "X(1)"
        FIELDS tt-horasalida AS DEC
        FIELDS tt-horaretorno AS DEC
        FIELDS tt-horaslaboradas AS DEC
        FIELDS tt-conta AS INT
        FIELDS tt-horasextras AS DEC
        FIELDS tt-moneda AS CHAR FORMAT "X(10)"        
        FIELDS tt-imp-mone-ori AS DEC
        FIELDS tt-tipo-cambio AS DEC
        FIELDS tt-imp-mone-sol AS DEC
        FIELDS tt-imp-horas-extras AS DEC
        FIELDS tt-total_soles AS DEC
        FIELDS tt-nomdivi AS CHAR FORMAT "x(60)"
        FIELDS tt-fac-serie AS CHAR FORMAT "x(4)"
        FIELDS tt-fac-nro AS CHAR FORMAT "x(20)"
        FIELDS tt-divorig AS CHAR FORMAT "x(4)"
        FIELDS tt-desdivorig AS CHAR FORMAT "x(50)"
        FIELDS tt-coskrdx AS DEC INIT 0
    FIELD tt-motivo AS CHAR FORMAT 'x(20)'
    FIELD tt-area AS CHAR FORMAT 'x(10)'
    FIELD tt-codori AS CHAR FORMAT 'x(8)'
    FIELD tt-nroori AS CHAR FORMAT 'x(15)'
    FIELD tt-termino_pago AS CHAR FORMAT 'x(50)'
    FIELD tt-responsable AS CHAR FORMAT 'x(80)'
INDEX Idx00 AS PRIMARY tt-nomtra tt-codveh tt-fchsal tt-flgest1
INDEX Idx01 tt-nomtra tt-codveh tt-guiatransportista tt-fchsal tt-nomcli tt-flgest1
    .

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
&Scoped-Define ENABLED-OBJECTS txtDesde txtHasta txtHoraLaboral ~
txtCostoHoraExtra txtIgv btn-Ok RECT-7 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje txtDesde txtHasta ~
txtHoraLaboral txtCostoHoraExtra txtIgv 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fArea W-Win 
FUNCTION fArea RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fAreaG W-Win 
FUNCTION fAreaG RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstadoDet W-Win 
FUNCTION fEstadoDet RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstadoDetG W-Win 
FUNCTION fEstadoDetG RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-Ok 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1 NO-UNDO.

DEFINE VARIABLE txtCostoHoraExtra AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 15 
     LABEL "Costo Hora Extra (S/.)" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 13.57 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txtHoraLaboral AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 10 
     LABEL "Horas Laborables x Dia" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE txtIgv AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 18 
     LABEL "% I.G.V." 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 1.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Mensaje AT ROW 8.54 COL 2 NO-LABEL WIDGET-ID 20
     txtDesde AT ROW 3.58 COL 17.43 COLON-ALIGNED WIDGET-ID 4
     txtHasta AT ROW 3.58 COL 35.57 WIDGET-ID 6
     txtHoraLaboral AT ROW 5.42 COL 22.57 COLON-ALIGNED WIDGET-ID 14
     txtCostoHoraExtra AT ROW 5.42 COL 51.72 COLON-ALIGNED WIDGET-ID 16
     txtIgv AT ROW 6.77 COL 22.43 COLON-ALIGNED WIDGET-ID 18
     btn-Ok AT ROW 8.42 COL 45 WIDGET-ID 12
     "Cuyas salidas de vehiculos sean..." VIEW-AS TEXT
          SIZE 36 BY .62 AT ROW 2.54 COL 9.43 WIDGET-ID 10
          FONT 3
     "Liquidaciones de Hoja de Ruta" VIEW-AS TEXT
          SIZE 28 BY .62 AT ROW 1.27 COL 19 WIDGET-ID 2
          FONT 6
     RECT-7 AT ROW 3.15 COL 9.43 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.86 BY 8.92 WIDGET-ID 100.


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
         TITLE              = "Liquidacion Hoja de Ruta"
         HEIGHT             = 8.92
         WIDTH              = 71.86
         MAX-HEIGHT         = 27.65
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.65
         VIRTUAL-WIDTH      = 146.29
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
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN txtHasta IN FRAME F-Main
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Liquidacion Hoja de Ruta */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Liquidacion Hoja de Ruta */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-Ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-Ok W-Win
ON CHOOSE OF btn-Ok IN FRAME F-Main /* Procesar */
DO:
  ASSIGN txtDesde txtHasta txtHoraLaboral txtCostoHoraExtra txtIGV.

  IF txtHoraLaboral < 4 THEN DO:
      MESSAGE 'Horas Laborales debe ser mayor/igual a 4' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF txtCostoHoraExtra < 0 THEN DO:
      MESSAGE 'Costo Hora Extra debe ser mayor/igual a CERO' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF txtIGV < 1 THEN DO:
      MESSAGE 'Ingrese el IGV' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.

  IF txtDesde = ?  THEN DO:
    MESSAGE 'Fecha DESDE esta ERRADA' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  IF txtHasta = ?  THEN DO:
    MESSAGE 'Fecha Hasta esta ERRADA' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.

  FILL-IN-Mensaje:SCREEN-VALUE in FRAME {&FRAME-NAME} = "CARGANDO TEMPORAL".
  RUN um_proceso.
  FILL-IN-Mensaje:SCREEN-VALUE in FRAME {&FRAME-NAME} = "CALCULANDO".
  RUN um_calcula_valores.
  FILL-IN-Mensaje:SCREEN-VALUE in FRAME {&FRAME-NAME} = "EXCEL".
  RUN um_envia_excel.
  FILL-IN-Mensaje:SCREEN-VALUE in FRAME {&FRAME-NAME} = "".
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
  DISPLAY FILL-IN-Mensaje txtDesde txtHasta txtHoraLaboral txtCostoHoraExtra 
          txtIgv 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txtDesde txtHasta txtHoraLaboral txtCostoHoraExtra txtIgv btn-Ok 
         RECT-7 
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

/* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    txtDesde:SCREEN-VALUE = STRING(ADD-INTERVAL(TODAY, -30, "days")).
    txtHasta:SCREEN-VALUE = STRING(TODAY,"99/99/9999") .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um_calcula_valores W-Win 
PROCEDURE um_calcula_valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lencontro AS LOGICAL.
DEFINE VAR lRecno AS ROWID.
DEFINE VAR lHorSalida AS DEC.
DEFINE VAR lHorRetorno AS DEC.
DEFINE VAR lHora AS DEC.
DEFINE VAR lHora1 AS DEC.
DEFINE VAR lHFrac AS DEC.
DEFINE VAR lMinuto AS INT.
DEFINE VAR lSuma AS DEC.


SESSION:SET-WAIT-STATE('GENERAL').

lEncontro = NO.
/* Cuenta */
FOR EACH tt-hojaruta BREAK BY tt-nomtra BY tt-codveh BY tt-guiatransportista  
    BY tt-fchsal BY tt-nomcli BY tt-flgest1 :
    IF FIRST-OF(tt-nomtra) OR FIRST-OF(tt-codveh)  OR FIRST-OF(tt-guiatransportista) 
        OR FIRST-OF(tt-fchsal) OR FIRST-OF(tt-nomcli) THEN DO:
        lEncontro = NO.
    END.
    IF lencontro = NO THEN DO:
        /* Si la mercaderia fue entregada */
        IF tt-hojaruta.tt-flgest1 = 'C' THEN DO:
            ASSIGN tt-conta = 1.
            lencontro = YES.
        END.
    END.
    IF LAST-OF(tt-nomtra) OR LAST-OF(tt-codveh) OR LAST-OF(tt-fchsal) OR 
        LAST-OF(tt-guiatransportista) OR LAST-OF(tt-nomcli) THEN DO:
        IF lencontro = NO THEN DO:
            ASSIGN tt-conta = 1.
        END.
    END.
END.

lHorSalida = 0.
lHorRetorno = 0.

DEFINE BUFFER bf-tt-hojaruta FOR tt-hojaruta.

FOR EACH tt-hojaruta BREAK BY tt-nomtra BY tt-codveh BY tt-fchsal :
    IF FIRST-OF(tt-nomtra) OR FIRST-OF(tt-codveh) OR FIRST-OF(tt-fchsal)  THEN DO:
        lHorSalida  = tt-horasalida.
        lHorRetorno = tt-horaretorno.
        ASSIGN lRecno = ROWID(tt-hojaruta).
    END.
    ELSE DO:
        IF LAST-OF(tt-nomtra) OR LAST-OF(tt-codveh) OR LAST-OF(tt-fchsal)  THEN DO:
            IF tt-horasalida < lHorSalida THEN lHorSalida = tt-horasalida.
            IF tt-horaretorno > lHorRetorno THEN lHorRetorno = tt-horaretorno.
            /* Actualizo las */
            lSuma = 0.
            FOR EACH bf-tt-hojaruta WHERE bf-tt-hojaruta.tt-nomtra = tt-hojaruta.tt-nomtra AND 
                bf-tt-hojaruta.tt-codveh = tt-hojaruta.tt-codveh AND 
                bf-tt-hojaruta.tt-fchsal = tt-hojaruta.tt-fchsal EXCLUSIVE :
                ASSIGN  
                    bf-tt-hojaruta.tt-horasalida = lHorSalida
                    bf-tt-hojaruta.tt-horaretorno = lHorRetorno.
                lSuma = lSuma + bf-tt-hojaruta.tt-imp-mone-sol.
                /**/
                lHora   = lHorSalida.
                lHora1  = lHorRetorno.
                lHora   = lHora1 - lHora.
                IF (lHora < 0) THEN lHora = 0.        
                ASSIGN 
                    tt-horaslaboradas = lHora
                    tt-horasextras = 0
                    tt-imp-horas-extras = 0.
                /* Calcular HORAS EXTRAS  */
                IF lHora > txtHoraLaboral THEN DO:
                    lHora = lHora - txtHoraLaboral.      /* Horas extras */
                    lHFrac = lHora - TRUNCATE(lHora,0). /* Obtengo Fraccion */
                    lMinuto = (lHFrac * 60).            /* Convierto en Minutos */
                    lMinuto = truncate(lMinuto / 15,0). /* Se paga x cada 15 minutos */
                    lMinuto = lMinuto * 15.             /* A enteros de 15 minutos */
                    lHFrac = lMinuto / 60.
                    lHora = truncate(lHora,0) + lHFrac.
                    ASSIGN 
                        tt-horasextras = lHora
                        tt-imp-horas-extras = (txtCostoHoraExtra * ( 1 + (txtIGV / 100))) * lHora.
                END.
            END.
            /* -- */
            ASSIGN tt-total_soles = lSuma.
        END.
        ELSE DO:
            IF tt-horasalida < lHorSalida THEN lHorSalida = tt-horasalida.
            IF tt-horaretorno > lHorRetorno THEN lHorRetorno = tt-horaretorno.
        END.
    END.
END.
/* Tonelaje y Tarifa  */
FOR EACH tt-hojaruta BREAK BY tt-nomtra BY tt-codveh BY tt-fchsal BY tt-flgest1 :
    IF FIRST-OF(tt-nomtra) OR FIRST-OF(tt-codveh)  /* OR FIRST-OF(tt-guiatransportista) */
        OR FIRST-OF(tt-fchsal)  THEN DO:
        /**/
    END.
    ELSE DO:
        ASSIGN  
            tt-tonelaje = 0
            tt-costo = 0
            tt-horasalida = 0
            tt-horaretorno = 0
            tt-horaslaboradas = 0
            tt-horasextras = 0
            tt-imp-horas-extras = 0.
    END.
END.
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um_envia_excel W-Win 
PROCEDURE um_envia_excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

    DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

    DEFINE VARIABLE iCount                  AS INTEGER init 1.
    DEFINE VARIABLE iIndex                  AS INTEGER.
    DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
    DEFINE VARIABLE cColumn                 AS CHARACTER.
    DEFINE VARIABLE cRange                  AS CHARACTER.
    DEFINE VARIABLE x-signo                 AS DECI.

    DEFINE VAR lDpto AS CHAR.
    DEFINE VAR lProv AS CHAR.
    DEFINE VAR lDist AS CHAR.
    DEFINE VAR lCCli AS CHAR.
    DEFINE VAR lDCli AS CHAR.
    DEFINE VAR lImp AS DEC.
    DEFINE VAR lDestino AS CHAR.
    DEFINE VAR lTonelaje AS DEC.
    DEFINE VAR lCosto AS DEC.
    DEFINE VAR lTipo AS CHAR.
    DEFINE VAR lCodPro AS CHAR.
    DEFINE VAR lHora AS DEC.
    DEFINE VAR lHora1 AS DEC.
    DEFINE VAR lHFrac AS DEC.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = FALSE.

    /* Para crear a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /* set the column names for the Worksheet */
    chWorkSheet:Range("A1"):Font:Bold = TRUE.
    chWorkSheet:Range("A1"):Value = "LIQUIDACION HOJA DE RUTA -  DESDE :" + 
    STRING(txtDesde,"99/99/9999") + "   HASTA :" + STRING(txtHasta,"99/99/9999").

    chWorkSheet:Range("A2:AZ2"):Font:Bold = TRUE.
    chWorkSheet:Range("A2"):Value = "cod.Hoja".
    chWorkSheet:Range("B2"):Value = "Nro de Hoja".
    chWorkSheet:Range("C2"):Value = "Situacion".
    chWorkSheet:Range("D2"):Value = "Hora Salida".
    chWorkSheet:Range("E2"):Value = "Hora Retorno".
    chWorkSheet:Range("F2"):Value = "Fecha Salida".
    chWorkSheet:Range("G2"):Value = "Km inicial".
    chWorkSheet:Range("H2"):Value = "Km final".
    chWorkSheet:Range("I2"):Value = "Placa".
    chWorkSheet:Range("J2"):Value = "Guia Transp.".
    chWorkSheet:Range("K2"):Value = "Transportista".
    chWorkSheet:Range("L2"):Value = "Tipo Movim.".
    chWorkSheet:Range("M2"):Value = "Division".
    chWorkSheet:Range("N2"):Value = "CodCliente".
    chWorkSheet:Range("O2"):Value = "Nombre del Cliente".
    chWorkSheet:Range("P2"):Value = "Guia".
    chWorkSheet:Range("Q2"):Value = "Nro Guia".
    chWorkSheet:Range("R2"):Value = "Importe Original".
    chWorkSheet:Range("S2"):Value = "Peso".
    chWorkSheet:Range("T2"):Value = "Sit.Dcmnto".
    chWorkSheet:Range("U2"):Value = "Hora Llegada".
    chWorkSheet:Range("V2"):Value = "Hora Partida".
    chWorkSheet:Range("W2"):Value = "Dpto".
    chWorkSheet:Range("X2"):Value = "Provincia".
    chWorkSheet:Range("Y2"):Value = "Distrito".

    chWorkSheet:Range("Z2"):Value = "Origen".
    chWorkSheet:Range("AA2"):Value = "Destino".
    chWorkSheet:Range("AB2"):Value = "Tonelaje".
    chWorkSheet:Range("AC2"):Value = "Tarifa".
    chWorkSheet:Range("AD2"):Value = "Tipo Pago".
    chWorkSheet:Range("AE2"):Value = "H.Sal".
    chWorkSheet:Range("AF2"):Value = "H.Ret".
    chWorkSheet:Range("AG2"):Value = "H.Trabajadas".
    chWorkSheet:Range("AH2"):Value = "Cuenta".
    chWorkSheet:Range("AI2"):Value = "Horas Extras".
    chWorkSheet:Range("AJ2"):Value = "Importe Horas Extras".
    chWorkSheet:Range("AK2"):Value = "Costo x Dia".
    chWorkSheet:Range("AL2"):Value = "Moneda".
    chWorkSheet:Range("AM2"):Value = "Importe Original".
    chWorkSheet:Range("AN2"):Value = "Tipo Cambio".
    chWorkSheet:Range("AO2"):Value = "Importe Soles".  
    chWorkSheet:Range("AP2"):Value = "Serie Dcto".  
    chWorkSheet:Range("AQ2"):Value = "Nro. Dcto".  
    chWorkSheet:Range("AR2"):Value = "Div. Origen".  
    chWorkSheet:Range("AS2"):Value = "Descripcion Div. Origen".     
    chWorkSheet:Range("AT2"):Value = "Cant.Items".
    chWorkSheet:Range("AU2"):Value = "Costo Kardex".
    chWorkSheet:Range("AV2"):Value = "Cod.Tienda".
    chWorkSheet:Range("AW2"):Value = "Descripcion Tienda".
    chWorkSheet:Range("AX2"):Value = "Motivo".
    chWorkSheet:Range("AY2"):Value = "Area Responsable".
    chWorkSheet:Range("AZ2"):Value = "Ref.".
    chWorkSheet:Range("BA2"):Value = "Nro. Ref.".

    chWorkSheet:Range("BB2"):Value = "Termino de Pago".
    chWorkSheet:Range("BC2"):Value = "Responsable".
    
    chWorkSheet:COLUMNS("B"):NumberFormat = "@".
    chWorkSheet:COLUMNS("D"):NumberFormat = "@".
    chWorkSheet:COLUMNS("E"):NumberFormat = "@".
    chWorkSheet:COLUMNS("J"):NumberFormat = "@".
    chWorkSheet:COLUMNS("K"):NumberFormat = "@".
    chWorkSheet:COLUMNS("M"):NumberFormat = "@".
    chWorkSheet:COLUMNS("N"):NumberFormat = "@".
    chWorkSheet:COLUMNS("O"):NumberFormat = "@".
    chWorkSheet:COLUMNS("P"):NumberFormat = "@".
    chWorkSheet:COLUMNS("Q"):NumberFormat = "@".
    chWorkSheet:COLUMNS("U"):NumberFormat = "@".
    chWorkSheet:COLUMNS("V"):NumberFormat = "@".
    chWorkSheet:COLUMNS("W"):NumberFormat = "@".
    chWorkSheet:COLUMNS("X"):NumberFormat = "@".
    chWorkSheet:COLUMNS("Y"):NumberFormat = "@".
    chWorkSheet:COLUMNS("Z"):NumberFormat = "@".
    chWorkSheet:COLUMNS("AP"):NumberFormat = "@".
    chWorkSheet:COLUMNS("AQ"):NumberFormat = "@".
    chWorkSheet:COLUMNS("AR"):NumberFormat = "@".
    chWorkSheet:COLUMNS("BA"):NumberFormat = "@".

    DEF VAR x-Column AS INT INIT 74 NO-UNDO.
    DEF VAR x-Range  AS CHAR NO-UNDO.


SESSION:SET-WAIT-STATE('GENERAL').
iColumn = 2.

FOR EACH tt-hojaruta NO-LOCK:
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-coddoc.       
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-nrodoc.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-flgest.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-horsal.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-horret.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-fchsal.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-kmtini.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-kmtfin.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-codveh.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-guiatransportista.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-nomtra.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-tipomov.
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-coddiv.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-coclie.
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-nomcli.
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-serref.
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-nroref.
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-libre_d02.
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-libre_d01. 
    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-flgest1.
    cRange = "U" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-horlle.
    cRange = "V" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-horpar.
    cRange = "W" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-dpto.
    cRange = "X" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-prov.
    cRange = "Y" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-distrito.
    cRange = "Z" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-nomdiv.
    cRange = "AA" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-destino.

    cRange = "AB" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-tonelaje.
    cRange = "AC" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-costo.
    cRange = "AD" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-tipocontrato.
    cRange = "AE" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-horasalida.    
    cRange = "AF" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-horaretorno.
    cRange = "AG" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-horaslaboradas.
    cRange = "AH" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-conta.
    cRange = "AI" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-horasextras.
    cRange = "AJ" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-imp-horas-extras.
    cRange = "AK" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-costo + tt-imp-horas-extras.
    cRange = "AL" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-moneda.
    cRange = "AM" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-imp-mone-ori.
    cRange = "AN" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-tipo-cambio.
    cRange = "AO" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-imp-mone-sol.
    cRange = "AP" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-fac-serie.
    cRange = "AQ" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-fac-nro.
    cRange = "AR" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-divorig.
    cRange = "AS" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-desdivorig.
    cRange = "AT" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-items.
    cRange = "AU" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-coskrdx.

    IF NOT (TRUE <> (tt-tienda > "")) THEN DO:
        cRange = "AV" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-tienda.

        FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
                                    gn-divi.coddiv = tt-tienda NO-LOCK NO-ERROR.
        IF AVAILABLE gn-divi THEN DO:
            cRange = "AW" + cColumn.
            chWorkSheet:Range(cRange):Value = gn-divi.desdiv.
        END.
    END.
    cRange = "AX" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-motivo.
    cRange = "AY" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-area.
    cRange = "AZ" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-codori.
    cRange = "BA" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-nroori.

    cRange = "BB" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-termino_pago.
    cRange = "BC" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-responsable.

END.
SESSION:SET-WAIT-STATE('').
chExcelApplication:DisplayAlerts = False.
chExcelApplication:VISIBLE = TRUE .
/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um_proceso W-Win 
PROCEDURE um_proceso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEFINE VAR lDpto AS CHAR.
    DEFINE VAR lProv AS CHAR.
    DEFINE VAR lDist AS CHAR.
    DEFINE VAR lCCli AS CHAR.
    DEFINE VAR lDCli AS CHAR.
    DEFINE VAR lImp AS DEC.
    DEFINE VAR lDestino AS CHAR.
    DEFINE VAR lTonelaje AS DEC.
    DEFINE VAR lCosto AS DEC.
    DEFINE VAR lTipo AS CHAR.
    DEFINE VAR lCodPro AS CHAR.
    DEFINE VAR lDesPro AS CHAR.
    DEFINE VAR lHora AS DEC.
    DEFINE VAR lMinuto AS DEC.
    DEFINE VAR lHora1 AS DEC.
    DEFINE VAR lHFrac AS DEC.
    DEFINE VAR lMone AS CHAR.
    DEFINE VAR lSoles AS DEC.
    DEFINE VAR lTcmb AS DEC.
    DEFINE VAR lOrigen AS CHAR.
    DEFINE VAR lDesDiv AS CHAR.

    DEFINE VAR lTermino_Pago AS CHAR NO-UNDO.
    DEFINE VAR lResponsable AS CHAR NO-UNDO.
    
    DEFINE VAR pNombre AS CHAR NO-UNDO.
    DEFINE VAR pOrigen AS CHAR NO-UNDO.


    DEFINE VAR lItems AS INT.

    DEFINE VAR lCostoKardex AS DEC.

SESSION:SET-WAIT-STATE('GENERAL').

EMPTY TEMP-TABLE tt-hojaruta.

DEFINE BUFFER b-divi FOR gn-divi.
DEFINE BUFFER x-divi FOR gn-divi.

FOR EACH DI-RutaC NO-LOCK WHERE DI-RutaC.codcia = s-codcia AND 
    DI-RutaC.CodDoc = "H/R" AND 
    DI-RutaC.fchsal >= txtDesde AND
    DI-RutaC.fchsal <= txtHasta:
    IF DI-RutaC.FlgEst = 'L' THEN NEXT.
    /* Datos del Transportista */
    lTonelaje   = 0.
    lCosto      = 0.
    lTipo       = ''.    
    lCodPro     = ''.
    lDesPro     = ''.
    lCodPro = DI-RutaC.codpro.  /* OJO */
    IF NOT CAN-FIND(FIRST gn-prov WHERE gn-prov.codcia = pv-codcia AND
                    gn-prov.codpro = lCodPro NO-LOCK)
        THEN DO:
        FIND FIRST gn-vehic WHERE gn-vehic.codcia = DI-RutaC.codcia AND 
              gn-vehic.placa = DI-RutaC.codveh NO-LOCK NO-ERROR.
        IF AVAILABLE gn-vehic THEN DO:
            lTonelaje   = gn-vehic.carga.
            lCodPro     = gn-vehic.codpro.
        END.
    END.
    FIND FIRST gn-prov WHERE gn-prov.codcia = pv-codcia 
        AND gn-prov.codpro = lCodPro NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN lDesPro = gn-prov.nompro.
    FIND FIRST vtatabla WHERE vtatabla.codcia = DI-RutaC.codcia AND
        vtatabla.tabla = 'VEHICULO' AND 
        vtatabla.llave_c2 = DI-RutaC.codveh AND
        vtatabla.llave_c1 = lCodPro NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
        lCosto      = vtatabla.valor[1].
        lTipo      = vtatabla.libre_c01.
    END.
    /* La division */
    lOrigen = "".
    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
        gn-divi.coddiv = di-rutaC.coddiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN DO:
        lOrigen = gn-divi.desdiv.
    END.
    /* Ventas */
    FOR EACH DI-RutaD WHERE DI-RutaD.codcia = DI-RutaC.codcia AND 
        DI-RutaD.coddiv = DI-RutaC.coddiv AND 
        DI-RutaD.coddoc = DI-RutaC.coddoc AND
        DI-RutaD.NroDoc = DI-RutaC.Nrodoc NO-LOCK :
        lDpto = ''.
        lProv = ''.
        lDist = ''.
        lCCli = ''.
        lDCli = ''.
        lDestino = ''.
        lImp = 0.
        lMone = 'S/.'.
        lSoles = 0.
        lTcmb = 0.
        lItems = 0.
        lTermino_Pago = ''.
        lResponsable = ''.
        /* Busco por division - segun hoja de ruta */
        FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = DI-rutaC.codcia AND 
            ccbcdocu.coddiv = DI-RutaD.coddiv AND 
            ccbcdocu.coddoc = DI-RutaD.codref AND
            ccbcdocu.nrodoc = DI-RutaD.nroref NO-LOCK NO-ERROR.
        /* Si no ubica el documento, lo busco sin la division
            por que hay casos que la hoja de ruta contiene
            documentos emitidos x otra division
        */
        IF NOT AVAILABLE ccbcdocu THEN DO:
            FIND FIRST CcbCDocu WHERE ccbcdocu.codcia = s-codcia
                AND DI-RutaD.codref = ccbcdocu.coddoc
                AND DI-RutaD.nroref = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
        END.
        IF AVAILABLE ccbcdocu THEN DO:
            /* Items y Costo Kardex */
            lCostoKardex = 0.
            FOR EACH ccbddocu OF ccbcdocu NO-LOCK :
                lItems = lItems + 1.
                FIND LAST almstkge WHERE almstkge.codcia = s-codcia AND 
                    almstkge.codmat = ccbddocu.codmat AND
                    almstkge.fecha <= ccbcdocu.fchdoc NO-LOCK NO-ERROR.
                IF AVAILABLE almstkge THEN DO:
                    lCostoKardex = lCostoKardex + ((ccbddocu.candes * ccbddocu.factor) * almstkge.ctouni).
                END.
            END.
            lCCli = ccbcdocu.codcli.
            lImp = ccbcdocu.imptot.
            lMone = IF(ccbcdocu.codmon = 2) THEN '$.' ELSE 'S/.'.
            lTcmb = ccbcdocu.tpocmb.
            /* ************************************* */
            /* RHC 13/08/2021 el TC de venta de caja */
            /* ************************************* */
            FIND LAST Gn-tccja WHERE Gn-tccja.fecha <= Ccbcdocu.FchDoc NO-LOCK NO-ERROR.
            IF AVAILABLE Gn-tccja THEN lTcmb = Gn-tccja.venta.
            /* ************************************* */
            lSoles = IF (ccbcdocu.codmon = 2) THEN lImp * lTcmb ELSE lImp.
            FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia 
                AND gn-clie.codcli = ccbcdocu.codcli 
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN lDCli = gn-clie.nomcli.
            FIND FIRST tabdepto WHERE gn-clie.coddept = tabdepto.coddepto NO-LOCK NO-ERROR.
            IF AVAILABLE tabdepto THEN lDpto = tabdepto.nomdepto.
            FIND FIRST tabprovi WHERE gn-clie.coddept = tabprovi.coddepto AND
                gn-clie.codprov = tabprovi.codprovi NO-LOCK NO-ERROR.
            IF AVAILABLE tabprovi THEN lProv = tabprovi.nomprovi.
            FIND FIRST tabdistr WHERE gn-clie.coddept = tabdistr.coddepto AND 
                gn-clie.codprov = tabdistr.codprovi AND 
                gn-clie.coddist = tabdistr.coddistr NO-LOCK NO-ERROR.
            IF AVAILABLE tabdistr THEN lDist = tabdistr.nomdistr.
            lTermino_Pago = Ccbcdocu.fmapgo.
            FIND gn-convt WHERE gn-ConVt.Codig = Ccbcdocu.fmapgo NO-LOCK NO-ERROR.
            IF AVAILABLE gn-convt THEN lTermino_Pago = gn-ConVt.Codig + " " + gn-ConVt.Nombr.
        END.
        IF lProv <> '' THEN DO:
            IF lProv = 'LIMA' THEN DO:
                lDestino = lDist.
            END.
            ELSE DO:
                IF lProv = 'CALLAO' THEN DO:
                    lDestino = "CALLAO".
                END.
                ELSE DO:
                    lDestino = "PROVINCIAS".
                END.
            END.
        END.
        CREATE tt-hojaruta.
        ASSIGN 
            tt-codcia    = DI-RutaC.codcia
            tt-coddoc    = DI-RutaC.coddoc
            tt-nrodoc   = DI-RutaC.nrodoc
            tt-flgest   = DI-RutaC.flgest
            tt-horsal   = DI-RutaC.horsal
            tt-horret   = DI-RutaC.horret
            tt-fchsal   = DI-RutaC.fchsal
            tt-kmtini   = DI-RutaC.kmtini
            tt-kmtfin   = DI-RutaC.kmtfin
            tt-codveh   = DI-RutaC.codveh
            tt-guiatransportista    = DI-RutaC.guiatransportista
            tt-nomtra   = lDesPro  /*DI-RutaC.nomtra*/
            tt-tipomov  = "VENTAS"
            tt-coddiv   = DI-RutaD.coddiv
            tt-coclie   = lCCli
            tt-nomcli   = lDCli
            tt-serref   = DI-RutaD.codref
            tt-nroref   = DI-RutaD.nroref
            tt-libre_d02    = lImp
            tt-libre_d01    = IF (NUM-ENTRIES(DI-RutaD.Libre_c01) > 3) THEN DECIMAL(ENTRY(4,DI-RutaD.Libre_c01,",")) ELSE 0
            tt-flgest1      = DI-RutaD.flgest
            tt-horlle       = DI-RutaD.horlle
            tt-horpar       = DI-RutaD.horpar
            tt-dpto         = lDpto
            tt-prov         = lProv
            tt-distrito     = lDist
            tt-destino      = lDestino
            tt-tonelaje     = lTonelaje
            tt-costo        = lCosto
            tt-items        = lItems
            tt-tipocontrato = lTIpo
            tt-conta        = 0
            tt-moneda       = lMone
            tt-imp-mone-ori = lImp
            tt-tipo-cambio  = lTcmb
            tt-imp-mone-sol = lSoles
            tt-nomdivi = lOrigen
            tt-coskrdx = lCostoKardex
            tt-motivo  = fEstadoDet()
            tt-area    = fArea()
                tt-codori = Ccbcdocu.Libre_c01
                tt-nroori = Ccbcdocu.Libre_c02
                tt-termino_pago = lTermino_Pago
                .
        IF di-rutaD.flgest = 'T' THEN DO:
            /* Dejado en tienda */
            ASSIGN tt-hojaruta.tt-tienda = di-rutaD.libre_c02.
        END.
        IF AVAILABLE ccbcdocu THEN DO:
            ASSIGN 
                tt-fac-serie = ccbcdocu.codref
                tt-fac-nro = ccbcdocu.nroref
                tt-divorig = ccbcdocu.divori.
            FIND FIRST x-divi WHERE x-divi.codcia = s-codcia AND 
                x-divi.coddiv = ccbcdocu.divori NO-LOCK NO-ERROR.
            IF AVAILABLE x-divi THEN DO:
                ASSIGN tt-desdivorig = x-divi.desdiv.
            END.
        END.
        /* Convertir las horas a Fraccion */
        lHora = DECIMAL(SUBSTRING(DI-RutaC.horsal,1,2)) NO-ERROR.
        lHFrac = DECIMAL(SUBSTRING(DI-RutaC.horsal,3,2)) NO-ERROR.
        lHora = lHora + (lHFrac / 60) .        
        lHora1 = DECIMAL(SUBSTRING(DI-RutaC.horret,1,2)) NO-ERROR.
        lHFrac = DECIMAL(SUBSTRING(DI-RutaC.horret,3,2)) NO-ERROR.
        lHora1 = lHora1 + (lHFrac / 60) .  /* Convierto en fraccion decimal */
        ASSIGN 
            tt-horasalida        = lHora
            tt-horaretorno      = lHora1.                
        lHora = lHora1 - lHora.
        IF (lHora < 0) THEN lHora = 0.        
        ASSIGN 
            tt-horaslaboradas = lHora
            tt-horasextras = 0
            tt-imp-horas-extras = 0.
        /* Calcular HORAS EXTRAS  */
        IF lHora > txtHoraLaboral THEN DO:
            lHora = lHora - txtHoraLaboral.      /* Horas extras */
            lHFrac = lHora - TRUNCATE(lHora,0). /* Obtengo Fraccion */
            lMinuto = (lHFrac * 60).            /* Convierto en Minutos */
            lMinuto = truncate(lMinuto / 15,0).
            lMinuto = lMinuto * 15.             /* A enteros de 15 minutos */
            lHFrac = lMinuto / 60.
            lHora = truncate(lHora,0) + lHFrac.
            ASSIGN tt-horasextras = lHora
                    tt-imp-horas-extras = (txtCostoHoraExtra * ( 1 + (txtIGV / 100))) * lHora.
        END.
        /* Responsable */
        RUN logis/p-busca-por-dni ( INPUT DI-RutaC.responsable,
                                    OUTPUT pNombre,
                                    OUTPUT pOrigen).
        ASSIGN
            tt-Responsable = DI-RutaC.responsable + " " + pNombre.

    END.
    
    /* TRANSFERENCIAS */
    FOR EACH DI-RutaG WHERE DI-RutaG.codcia = DI-rutaC.codcia AND 
        DI-RutaG.coddiv = DI-RutaC.coddiv AND
        DI-RutaG.coddoc = DI-RutaC.coddoc AND 
        DI-RutaG.nrodoc = DI-RutaC.nrodoc NO-LOCK:
        lDpto = ''.
        lProv = ''.
        lDist = ''.
        lCCli = ''.
        lDCli = ''.
        lDestino = ''.
        lImp = 0.

        lItems = 0.
        FIND FIRST almcmov WHERE almcmov.codcia = DI-RutaG.codcia AND 
            almcmov.codalm = DI-RutaG.codalm AND
            almcmov.tipmov = DI-RutaG.tipmov AND 
            almcmov.codmov = DI-RutaG.codmov AND
            almcmov.nroser = DI-RutaG.serref AND 
            almcmov.nrodoc = DI-RutaG.nroref 
            NO-LOCK NO-ERROR.
        IF AVAILABLE almcmov THEN DO:
            lCCli = almcmov.almdes.
            lDCli = almcmov.almdes.
            lDist = almcmov.almdes.
            lDestino = almcmov.almdes.            

            lCostoKardex = 0.
            FOR EACH almdmov OF almcmov NO-LOCK:
                lItems = lItems + 1.
                FIND LAST almstkge WHERE almstkge.codcia = s-codcia AND 
                                        almstkge.codmat = almdmov.codmat AND
                                        almstkge.fecha <= almdmov.fchdoc NO-LOCK NO-ERROR.
                IF AVAILABLE almstkge THEN DO:
                    lCostoKardex = lCostoKardex + ((almdmov.candes * almdmov.factor) * almstkge.ctouni).
                END.

            END.

            /**/
            FIND FIRST almacen WHERE almacen.codcia = DI-RutaG.codcia AND almacen.codalm = lDist
                NO-LOCK NO-ERROR.
            IF AVAILABLE almacen THEN DO:                
                FIND FIRST b-divi WHERE b-divi.codcia = s-codcia AND 
                    b-divi.coddiv = almacen.coddiv NO-LOCK NO-ERROR.
                IF AVAILABLE b-divi THEN DO:
                    IF NUM-ENTRIES(b-divi.faxdiv,"-") > 2 THEN DO:
                        lDestino = ENTRY(3,b-divi.faxdiv,"-").
                    END.                    
                END.
            END.                
        END.
        CREATE tt-hojaruta.
        ASSIGN 
            tt-codcia    = DI-RutaC.codcia
            tt-coddoc    = DI-RutaC.coddoc
            tt-nrodoc   = DI-RutaC.nrodoc
            tt-flgest   = DI-RutaC.flgest
            tt-horsal   = DI-RutaC.horsal
            tt-horret   = DI-RutaC.horret
            tt-fchsal   = DI-RutaC.fchsal
            tt-kmtini   = DI-RutaC.kmtini
            tt-kmtfin   = DI-RutaC.kmtfin
            tt-codveh   = DI-RutaC.codveh
            tt-guiatransportista    = DI-RutaC.guiatransportista
            tt-nomtra   = DI-RutaC.nomtra
            tt-tipomov  = "TRANSFERENCIAS"
            tt-coddiv   = DI-RutaG.coddiv
            tt-coclie   = lCCli
            tt-nomcli   = lDCli
            tt-serref   = 'TRF'   /*STRING(DI-RutaG.serref,"999")*/
            tt-nroref   = STRING(DI-RutaG.serref,"999") + STRING(DI-RutaG.nroref,"999999")
            tt-libre_d02    = DI-RutaG.libre_d02
            tt-libre_d01    = Di-RutaG.libre_d01
            tt-flgest1      = DI-RutaG.flgest
            tt-horlle       = DI-RutaG.horlle
            tt-horpar       = DI-RutaG.horpar
            tt-dpto         = ""
            tt-prov         = ""
            tt-distrito     = lDist
            tt-destino      = lDestino
            tt-tonelaje     = lTonelaje
            tt-costo        = lCosto
            tt-items        = lItems
            tt-tipocontrato = lTIpo
            tt-conta        = 0
            tt-moneda       = 'S/.'
            tt-imp-mone-ori = DI-RutaG.libre_d02
            tt-tipo-cambio  = 1
            tt-imp-mone-sol = DI-RutaG.libre_d02
            tt-nomdivi = lOrigen
            tt-coskrdx = lCostoKardex
            tt-motivo  = fEstadoDetG()
            tt-area    = fAreaG()
            tt-codori = (IF AVAILABLE Almcmov THEN Almcmov.codref ELSE '')
            tt-nroori = (IF AVAILABLE ALmcmov THEN Almcmov.nroref ELSE '')
            .

            /* Convertir las horas a Fraccion */
            lHora = DECIMAL(SUBSTRING(DI-RutaC.horsal,1,2)) NO-ERROR.
            lHFrac = DECIMAL(SUBSTRING(DI-RutaC.horsal,3,2)) NO-ERROR.
            lHora = lHora + (lHFrac / 60) .        

            lHora1 = DECIMAL(SUBSTRING(DI-RutaC.horret,1,2)) NO-ERROR.
            lHFrac = DECIMAL(SUBSTRING(DI-RutaC.horret,3,2)) NO-ERROR.
            lHora1 = lHora1 + (lHFrac / 60) .
        ASSIGN 
            tt-horasalida        = lHora
            tt-horaretorno      = lHora1.                
        lHora = lHora1 - lHora.
        IF (lHora < 0) THEN lHora = 0.        
        ASSIGN 
            tt-horaslaboradas = lHora
            tt-horasextras = 0
            tt-imp-horas-extras = 0.
        /* Calcular HORAS EXTRAS  */
        IF lHora > txtHoraLaboral THEN DO:
            lHora = lHora - txtHoraLaboral.     /* Horas extras */
            lHFrac = lHora - TRUNCATE(lHora,0). /* Obtengo Fraccion */
            lMinuto = (lHFrac * 60).            /* Convierto en Minutos */
            lMinuto = truncate(lMinuto / 15,0).
            lMinuto = lMinuto * 15.             /* A enteros de 15 minutos */
            lHFrac = lMinuto / 60.
            lHora = truncate(lHora,0) + lHFrac.
            ASSIGN 
                tt-horasextras = lHora
                tt-imp-horas-extras = (txtCostoHoraExtra * ( 1 + (txtIGV / 100))) * lHora.
        END.
    END.
END.
SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fArea W-Win 
FUNCTION fArea RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR x-Area AS CHAR NO-UNDO.

x-Area = ''.
CASE DI-RutaD.FlgEst:
    WHEN "N" THEN DO:
        FIND AlmTabla WHERE AlmTabla.Tabla = 'HR'
            AND AlmTabla.Codigo = DI-RutaD.FlgEstDet
            AND almtabla.NomAnt = 'N'
            NO-LOCK NO-ERROR.
        IF AVAILABLE AlmTabla THEN DO:
            IF almtabla.CodCta2 > '' THEN RETURN almtabla.CodCta2.
            ELSE RETURN 'NO DEFINIDO'.
        END.
    END.
    WHEN "C" THEN DO:
        FIND AlmTabla WHERE AlmTabla.Tabla = 'HRD'
            AND AlmTabla.Codigo = DI-RutaD.FlgEstDet
            AND almtabla.NomAnt = 'D'
            NO-LOCK NO-ERROR.
        IF AVAILABLE AlmTabla THEN DO:
            IF almtabla.CodCta2 > '' THEN RETURN almtabla.CodCta2.
            ELSE RETURN 'NO DEINIDO'.
        END.
    END.
END CASE.
RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fAreaG W-Win 
FUNCTION fAreaG RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEF VAR x-Area AS CHAR NO-UNDO.

x-Area = ''.
CASE DI-RutaG.FlgEst:
    WHEN "N" THEN DO:
        FIND AlmTabla WHERE AlmTabla.Tabla = 'HR'
            AND AlmTabla.Codigo = DI-RutaG.FlgEstDet
            AND almtabla.NomAnt = 'N'
            NO-LOCK NO-ERROR.
        IF AVAILABLE AlmTabla THEN DO:
            IF almtabla.CodCta2 > '' THEN RETURN almtabla.CodCta2.
            ELSE RETURN 'NO DEFINIDO'.
        END.
    END.
    WHEN "C" THEN DO:
        FIND AlmTabla WHERE AlmTabla.Tabla = 'HRD'
            AND AlmTabla.Codigo = DI-RutaG.FlgEstDet
            AND almtabla.NomAnt = 'D'
            NO-LOCK NO-ERROR.
        IF AVAILABLE AlmTabla THEN DO:
            IF almtabla.CodCta2 > '' THEN RETURN almtabla.CodCta2.
            ELSE RETURN 'NO DEFINIDO'.
        END.
    END.
END CASE.
RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstadoDet W-Win 
FUNCTION fEstadoDet RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

CASE DI-RutaD.FlgEst:
    WHEN "N" THEN DO:
        FIND AlmTabla WHERE AlmTabla.Tabla = 'HR'
            AND AlmTabla.Codigo = DI-RutaD.FlgEstDet
            AND almtabla.NomAnt = 'N'
            NO-LOCK NO-ERROR.
        IF AVAILABLE AlmTabla THEN RETURN almtabla.Nombre.
    END.
    WHEN "C" THEN DO:
        FIND AlmTabla WHERE AlmTabla.Tabla = 'HRD'
            AND AlmTabla.Codigo = DI-RutaD.FlgEstDet
            AND almtabla.NomAnt = 'D'
            NO-LOCK NO-ERROR.
        IF AVAILABLE AlmTabla THEN RETURN almtabla.Nombre.
    END.
END CASE.
RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstadoDetG W-Win 
FUNCTION fEstadoDetG RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
CASE DI-RutaG.FlgEst:
    WHEN "N" THEN DO:
        FIND AlmTabla WHERE AlmTabla.Tabla = 'HR'
            AND AlmTabla.Codigo = DI-RutaG.FlgEstDet
            AND almtabla.NomAnt = 'N'
            NO-LOCK NO-ERROR.
        IF AVAILABLE AlmTabla THEN RETURN almtabla.Nombre.
    END.
    WHEN "C" THEN DO:
        FIND AlmTabla WHERE AlmTabla.Tabla = 'HRD'
            AND AlmTabla.Codigo = DI-RutaG.FlgEstDet
            AND almtabla.NomAnt = 'D'
            NO-LOCK NO-ERROR.
        IF AVAILABLE AlmTabla THEN RETURN almtabla.Nombre.
    END.
END CASE.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

