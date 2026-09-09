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

DEFINE TEMP-TABLE tt-hojaruta
        FIELDS tt-nrodoc LIKE DI-RutaC.nrodoc
        FIELDS tt-fchsal LIKE DI-RutaC.fchsal
        FIELDS tt-coddiv LIKE DI-RutaG.coddiv
        FIELDS tt-coclie LIKE ccbcdocu.codcli
        FIELDS tt-nomcli LIKE gn-clie.nomcli
        FIELDS tt-serref LIKE DI-RutaD.codref
        FIELDS tt-nroref LIKE DI-RutaD.nroref    
        FIELDS tt-libre_d01 LIKE Di-RutaG.libre_d01 
        FIELDS tt-moneda AS CHAR FORMAT "X(10)"        
        FIELDS tt-imp-mone-ori AS DEC
        FIELDS tt-tipo-cambio AS DEC
        FIELDS tt-imp-mone-sol AS DEC
        FIELDS tt-total_soles AS DEC
        FIELDS tt-nomdivi AS CHAR FORMAT "x(60)"

        FIELDS tt-fac-serie AS CHAR FORMAT "x(4)"
        FIELDS tt-fac-nro AS CHAR FORMAT "x(20)"
        FIELDS tt-fechemi AS DATE
        FIELDS tt-condvta AS CHAR
        FIELDS tt-estado AS CHAR
        FIELD tt-fechcanc AS DATE

        FIELDS tt-divdcto AS CHAR FORMAT "x(5)"
        FIELDS tt-nomdctodiv AS CHAR FORMAT "x(60)"
        FIELDS tt-peso AS DEC

         INDEX idx01 IS PRIMARY tt-fchsal tt-divdcto .

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
&Scoped-Define ENABLED-OBJECTS rButtonEstado txtDesde txtHasta txt-div ~
txt-CD btn-Ok RECT-7 
&Scoped-Define DISPLAYED-OBJECTS rButtonEstado txtDesde txtHasta txt-div ~
txt-CD txt-nom-cd txt-nom-div 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-Ok 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txt-CD AS CHARACTER FORMAT "X(5)":U 
     LABEL "CD de entrega" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE txt-div AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division del Docto" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE txt-nom-cd AS CHARACTER FORMAT "X(50)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1 NO-UNDO.

DEFINE VARIABLE txt-nom-div AS CHARACTER FORMAT "X(50)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1 NO-UNDO.

DEFINE VARIABLE txtDesde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 13.57 BY 1 NO-UNDO.

DEFINE VARIABLE txtHasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE rButtonEstado AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Solo Pendientes", 1,
"Todos", 2
     SIZE 31 BY .96 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 1.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     rButtonEstado AT ROW 8.31 COL 22 NO-LABEL WIDGET-ID 30
     txtDesde AT ROW 3.58 COL 17.43 COLON-ALIGNED WIDGET-ID 4
     txtHasta AT ROW 3.58 COL 35.57 WIDGET-ID 6
     txt-div AT ROW 5.5 COL 17 COLON-ALIGNED WIDGET-ID 24
     txt-CD AT ROW 6.77 COL 17 COLON-ALIGNED WIDGET-ID 20
     txt-nom-cd AT ROW 6.77 COL 26.72 COLON-ALIGNED WIDGET-ID 26
     btn-Ok AT ROW 9.85 COL 48 WIDGET-ID 12
     txt-nom-div AT ROW 5.46 COL 26.86 COLON-ALIGNED WIDGET-ID 28
     "Rango de documentos emitidos" VIEW-AS TEXT
          SIZE 36 BY .62 AT ROW 2.54 COL 9.43 WIDGET-ID 10
          FONT 3
     "Documentos emitidos por CONTRAENTREGA" VIEW-AS TEXT
          SIZE 43 BY .62 AT ROW 1.58 COL 16 WIDGET-ID 2
          FGCOLOR 4 FONT 12
     "(Vacio = todo(s))" VIEW-AS TEXT
          SIZE 18.14 BY .62 AT ROW 10.12 COL 27 WIDGET-ID 22
     RECT-7 AT ROW 3.15 COL 9.43 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.86 BY 10.77 WIDGET-ID 100.


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
         HEIGHT             = 10.77
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN txt-nom-cd IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-nom-div IN FRAME F-Main
   NO-ENABLE                                                            */
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
  ASSIGN txtDesde txtHasta txt-CD txt-div rButtonEstado.


  IF txtDesde = ?  THEN DO:
    MESSAGE 'Fecha DESDE esta ERRADA' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  IF txtHasta = ?  THEN DO:
    MESSAGE 'Fecha Hasta esta ERRADA' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.

  RUN um_proceso.
  /*RUN um_calcula_valores.*/
  RUN um_envia_excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-CD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-CD W-Win
ON LEAVE OF txt-CD IN FRAME F-Main /* CD de entrega */
DO:

    DEFINE VAR lCodDiv AS CHAR.

    txt-nom-cd:SCREEN-VALUE ="".

    lCodDiv = txt-cd:SCREEN-VALUE.

    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
        gn-divi.coddiv = lCodDiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN DO:
        txt-nom-cd:SCREEN-VALUE = gn-divi.desdiv.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-div
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-div W-Win
ON LEAVE OF txt-div IN FRAME F-Main /* Division del Docto */
DO:
    DEFINE VAR lCodDiv AS CHAR.

    txt-nom-div:SCREEN-VALUE ="".

    lCodDiv = txt-div:SCREEN-VALUE.

    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
        gn-divi.coddiv = lCodDiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN DO:
        txt-nom-div:SCREEN-VALUE = gn-divi.desdiv.
    END.
  
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
  DISPLAY rButtonEstado txtDesde txtHasta txt-div txt-CD txt-nom-cd txt-nom-div 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE rButtonEstado txtDesde txtHasta txt-div txt-CD btn-Ok RECT-7 
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
    txtDesde:SCREEN-VALUE = STRING(TODAY - 30,"99/99/9999").
    txtHasta:SCREEN-VALUE = STRING(TODAY,"99/99/9999") .
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

/*
SESSION:SET-WAIT-STATE('GENERAL').

lEncontro = NO.
/* Cuenta */
FOR EACH tt-hojaruta BREAK BY tt-nomtra BY tt-codveh BY tt-guiatransportista  
    BY tt-fchsal BY tt-nomcli BY tt-flgest1 :
    IF FIRST-OF(tt-nomtra) OR FIRST-OF(tt-codveh)  OR FIRST-OF(tt-guiatransportista) 
        OR FIRST-OF(tt-fchsal)OR FIRST-OF(tt-nomcli) THEN DO:
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
    IF FIRST-OF(tt-nomtra) OR FIRST-OF(tt-codveh)  
        OR FIRST-OF(tt-fchsal)  THEN DO:
        lHorSalida  = tt-horasalida.
        lHorRetorno = tt-horaretorno.
        ASSIGN lRecno = ROWID(tt-hojaruta).
    END.
    ELSE DO:
        IF LAST-OF(tt-nomtra) OR LAST-OF(tt-codveh)  
            OR LAST-OF(tt-fchsal)  THEN DO:
            IF tt-horasalida < lHorSalida THEN lHorSalida = tt-horasalida.
            IF tt-horaretorno > lHorRetorno THEN lHorRetorno = tt-horaretorno.
            /* Actualizo las */
            lSuma = 0.
            FOR EACH bf-tt-hojaruta WHERE bf-tt-hojaruta.tt-nomtra = tt-hojaruta.tt-nomtra AND 
                bf-tt-hojaruta.tt-codveh = tt-hojaruta.tt-codveh AND 
                bf-tt-hojaruta.tt-fchsal = tt-hojaruta.tt-fchsal EXCLUSIVE :
                
                ASSIGN  bf-tt-hojaruta.tt-horasalida = lHorSalida
                        bf-tt-hojaruta.tt-horaretorno = lHorRetorno.

                lSuma = lSuma + bf-tt-hojaruta.tt-imp-mone-sol.
                /**/
                lHora   = lHorSalida.
                lHora1  = lHorRetorno.
                lHora   = lHora1 - lHora.
                IF (lHora < 0) THEN lHora = 0.        

                    ASSIGN tt-horaslaboradas = lHora
                        tt-horasextras = 0
                        tt-imp-horas-extras = 0.

                /* Calcular HORAS EXTRAS  */
                   /* ASSIGN txtDesde txtHasta txtHoraLaboral txtCostoHoraExtra txtIGV.*/
                IF lHora > txtHoraLaboral THEN DO:
                    lHora = lHora - txtHoraLaboral.      /* Horas extras */
                    lHFrac = lHora - TRUNCATE(lHora,0). /* Obtengo Fraccion */
                    lMinuto = (lHFrac * 60).            /* Convierto en Minutos */
                    lMinuto = truncate(lMinuto / 15,0). /* Se paga x cada 15 minutos */
                    lMinuto = lMinuto * 15.             /* A enteros de 15 minutos */
                    lHFrac = lMinuto / 60.
                    lHora = truncate(lHora,0) + lHFrac.

                    ASSIGN tt-horasextras = lHora
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
/*FOR EACH tt-hojaruta BREAK BY tt-nomtra BY tt-codveh BY tt-guiatransportista  BY tt-fchsal :*/
FOR EACH tt-hojaruta BREAK BY tt-nomtra BY tt-codveh BY tt-fchsal BY tt-flgest1 :
    IF FIRST-OF(tt-nomtra) OR FIRST-OF(tt-codveh)  /* OR FIRST-OF(tt-guiatransportista) */
        OR FIRST-OF(tt-fchsal)  THEN DO:
        /**/
    END.
    ELSE DO:
        ASSIGN  tt-tonelaje = 0
                tt-costo = 0
                tt-horasalida = 0
                tt-horaretorno = 0
                tt-horaslaboradas = 0
                tt-horasextras = 0
                tt-imp-horas-extras = 0.

    END.
END.

SESSION:SET-WAIT-STATE('').

  */
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

DEFINE VAR cEstado AS CHAR.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* Para crear a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chExcelApplication:VISIBLE = FALSE.

/* set the column names for the Worksheet */

chWorkSheet:Range("F1"):Font:Bold = TRUE.
chWorkSheet:Range("F1"):Value = "DOCUMENTOS EMITIDOS -  DESDE :" + 
STRING(txtDesde,"99/99/9999") + "   HASTA :" + STRING(txtHasta,"99/99/9999").

chWorkSheet:Range("A2:AZ2"):Font:Bold = TRUE.
chWorkSheet:Range("A2"):Value = "Fecha Salida".
chWorkSheet:Range("B2"):Value = "Nro de Hoja".    
chWorkSheet:Range("C2"):Value = "Cod.CD".
chWorkSheet:Range("D2"):Value = "CD Nombre".
chWorkSheet:Range("E2"):Value = "Cond.Vta".  
chWorkSheet:Range("F2"):Value = "Fec.Emision". 
chWorkSheet:Range("G2"):Value = "Div. Dcto".  
chWorkSheet:Range("H2"):Value = "Nomb.Div. Dcto".  
chWorkSheet:Range("I2"):Value = "Cod.Docto".  
chWorkSheet:Range("J2"):Value = "Nro. Dcto".  
chWorkSheet:Range("K2"):Value = "CodCliente".
chWorkSheet:Range("L2"):Value = "Nombre del Cliente".
chWorkSheet:Range("M2"):Value = "Importe Soles".  
chWorkSheet:Range("N2"):Value = "Importe Dolares".  
chWorkSheet:Range("O2"):Value = "Estado".  
chWorkSheet:Range("P2"):Value = "CodGuia".
chWorkSheet:Range("Q2"):Value = "Nro Guia".
chWorkSheet:Range("R2"):Value = "Cancelacion".  

/*chWorkSheet:Range("N2"):Value = "Peso Kgrs.".  */

DEF VAR x-Column AS INT INIT 74 NO-UNDO.
DEF VAR x-Range  AS CHAR NO-UNDO.


SESSION:SET-WAIT-STATE('GENERAL').
iColumn = 2.

FOR EACH tt-hojaruta NO-LOCK:
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).

        cEstado = ''.
        RUN gn\fFlgEstCCBv2.r(INPUT tt-fac-serie, INPUT tt-estado, OUTPUT cEstado).

        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-fchsal.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-nrodoc.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-hojaruta.tt-coddiv.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-nomdiv.

        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-condvta.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-fechemi.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-divdcto.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-nomdctodiv.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-fac-serie.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-fac-nro.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-coclie.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-nomcli.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = (IF tt-moneda = 'S/.' THEN tt-imp-mone-ori ELSE 0).
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = (IF tt-moneda <> 'S/.' THEN tt-imp-mone-ori ELSE 0).
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = cEstado.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-serref.
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-nroref.
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-fechcanc.
END.

    chExcelApplication:DisplayAlerts = False.
    chExcelApplication:VISIBLE = TRUE .
        /*chExcelApplication:Quit().*/


        /* release com-handles */
        RELEASE OBJECT chExcelApplication NO-ERROR.      
        RELEASE OBJECT chWorkbook NO-ERROR.
        RELEASE OBJECT chWorksheet NO-ERROR.
        RELEASE OBJECT chWorksheetRange NO-ERROR. 

SESSION:SET-WAIT-STATE('').

    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


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

DEF BUFFER GUIA FOR Ccbcdocu.

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
DEFINE VAR lPesoGuia AS DEC.

/*txt-CD txt-div*/
SESSION:SET-WAIT-STATE('GENERAL').

EMPTY TEMP-TABLE tt-hojaruta.

FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia 
    AND (ccbcdocu.fchdoc  >= txtDesde AND ccbcdocu.fchdoc <= txtHasta) 
    AND LOOKUP(ccbcdocu.coddoc,"FAC,BOL,TCK") > 0 
    AND ccbcdocu.fmapgo = '001' 
    AND (txt-div = "" OR ccbcdocu.divori = txt-div) NO-LOCK:
    /* Solo Pendientes */
    IF rButtonEstado = 1 THEN DO:
        IF ccbcdocu.flgest <> 'P' THEN NEXT.
    END.        
    /* --  */
    lPesoGuia = 0.
    lCCli = ccbcdocu.codcli.
    lImp = ccbcdocu.imptot.
    lMone = IF(ccbcdocu.codmon = 2) THEN '$.' ELSE 'S/.'.
    lTcmb = ccbcdocu.tpocmb.
    lSoles = IF (ccbcdocu.codmon = 2) THEN lImp * lTcmb ELSE lImp.
    lOrigen = "".

    /* Detalle de Hoja de Ruta */
    FIND FIRST GUIA WHERE GUIA.codcia = Ccbcdocu.codcia
        AND GUIA.coddoc = "G/R"
        AND GUIA.codref = Ccbcdocu.coddoc
        AND GUIA.nroref = Ccbcdocu.nrodoc
        AND GUIA.flgest <> 'A'
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE GUIA THEN DO:
        CREATE tt-hojaruta.
        ASSIGN tt-nrodoc   = ?
                tt-fchsal   = ?
                tt-coddiv   = ?
                tt-coclie   = ccbcdocu.codcli
                tt-nomcli   = ccbcdocu.nomcli
                tt-serref   = ccbcdocu.codref
                tt-nroref   = ccbcdocu.nroref                
                tt-libre_d01    = 0.00
                tt-moneda       = lMone
                tt-imp-mone-ori = lImp
                tt-tipo-cambio  = lTcmb
                tt-imp-mone-sol = lSoles
                tt-nomdivi = lOrigen
                tt-peso  = lPesoGuia
                tt-fac-serie = ccbcdocu.coddoc
                tt-fac-nro = ccbcdocu.nrodoc
                tt-divdcto = ccbcdocu.divori
                tt-fechemi = ccbcdocu.fchdoc
                tt-condvta = ccbcdocu.fmapgo
                tt-estado = ccbcdocu.flgest
                tt-fechcanc = ccbcdocu.fchcan.

        FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
            gn-divi.coddiv = ccbcdocu.divori NO-LOCK NO-ERROR.
        ASSIGN tt-nomdctodiv = IF AVAILABLE gn-divi THEN gn-divi.desdiv ELSE "".
        NEXT.
    END.
    FIND FIRST di-rutaD USE-INDEX llave02 WHERE di-rutaD.codcia = s-codcia 
        AND di-rutaD.coddoc = 'H/R' 
        AND di-rutaD.codref = GUIA.coddoc
        AND di-rutaD.nroref = GUIA.nrodoc
        NO-LOCK NO-ERROR.
    IF AVAILABLE di-rutaD THEN DO:
        FIND FIRST di-RutaC OF di-rutaD NO-LOCK.
        IF (txt-cd = "" OR di-rutaC.coddiv = txt-cd) THEN DO:
            FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
                gn-divi.coddiv = di-rutaC.coddiv NO-LOCK NO-ERROR.
            IF AVAILABLE gn-divi THEN lOrigen = gn-divi.desdiv.

            CREATE tt-hojaruta.
                ASSIGN tt-nrodoc   = DI-RutaC.nrodoc
                        tt-fchsal   = (IF DI-RutaC.fchsal <> ? THEN DI-RutaC.fchsal ELSE DI-RutaC.fchdoc)
                        tt-coddiv   = DI-RutaD.coddiv
                        tt-coclie   = ccbcdocu.codcli
                        tt-nomcli   = ccbcdocu.nomcli
                        tt-serref   = DI-RutaD.codref
                        tt-nroref   = DI-RutaD.nroref                
                        tt-libre_d01    = IF (NUM-ENTRIES(DI-RutaD.Libre_c01) > 3) THEN DECIMAL(ENTRY(4,DI-RutaD.Libre_c01,",")) ELSE 0
                        tt-moneda       = lMone
                        tt-imp-mone-ori = lImp
                        tt-tipo-cambio  = lTcmb
                        tt-imp-mone-sol = lSoles
                        tt-nomdivi = lOrigen
                        tt-peso  = lPesoGuia
                        tt-fac-serie = ccbcdocu.coddoc
                        tt-fac-nro = ccbcdocu.nrodoc
                        tt-divdcto = ccbcdocu.divori
                        tt-fechemi = ccbcdocu.fchdoc
                        tt-condvta = ccbcdocu.fmapgo
                        tt-estado = ccbcdocu.flgest
                        tt-fechcanc = ccbcdocu.fchcan.

                FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
                    gn-divi.coddiv = ccbcdocu.divori NO-LOCK NO-ERROR.
                ASSIGN tt-nomdctodiv = IF AVAILABLE gn-divi THEN gn-divi.desdiv ELSE "".
        END.
    END.                           
    ELSE DO:
        CREATE tt-hojaruta.
            ASSIGN tt-nrodoc   = ?
                    tt-fchsal   = ?
                    tt-coddiv   = ?
                    tt-coclie   = ccbcdocu.codcli
                    tt-nomcli   = ccbcdocu.nomcli
                    tt-serref   = ccbcdocu.codref
                    tt-nroref   = ccbcdocu.nroref
                    tt-libre_d01    = 0.00
                    tt-moneda       = lMone
                    tt-imp-mone-ori = lImp
                    tt-tipo-cambio  = lTcmb
                    tt-imp-mone-sol = lSoles
                    tt-nomdivi = lOrigen
                    tt-peso  = lPesoGuia
                    tt-fac-serie = ccbcdocu.coddoc
                    tt-fac-nro = ccbcdocu.nrodoc
                    tt-divdcto = ccbcdocu.divori
                    tt-fechemi = ccbcdocu.fchdoc
                    tt-condvta = ccbcdocu.fmapgo
                    tt-estado = ccbcdocu.flgest
                    tt-fechcanc = ccbcdocu.fchcan.

            FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
                gn-divi.coddiv = ccbcdocu.divori NO-LOCK NO-ERROR.
            ASSIGN tt-nomdctodiv = IF AVAILABLE gn-divi THEN gn-divi.desdiv ELSE "".
    END.
END.

SESSION:SET-WAIT-STATE('').

/* -------------------------------------------------------------------------------------------------------------- */

/*
FOR EACH DI-RutaC WHERE DI-RutaC.codcia = s-codcia AND (DI-RutaC.fchsal >= txtDesde AND
    DI-RutaC.fchsal <= txtHasta) AND 
    (txt-cd = "" OR di-rutaC.coddiv = txt-cd)   NO-LOCK:
    
    /* Version antigua */
    /*
    FIND FIRST gn-vehic WHERE gn-vehic.codcia = DI-RutaC.codcia AND 
          gn-vehic.placa = DI-RutaC.codveh NO-LOCK NO-ERROR.
    IF AVAILABLE gn-vehic THEN DO:
       lTonelaje   = gn-vehic.carga.
       lCodPro     = gn-vehic.codpro.
    END.
    IF DI-RutaC.codpro = '' OR DI-RutaC.codpro = ? THEN DO: 
        /* La ruta no tiene codprodveedor por lo tanto agarra la de la tabla Vehiculos */
    END.
    ELSE lCodPro = DI-RutaC.codpro.
    
    FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND gn-prov.codpro = lCodPro NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN lDesPro = gn-prov.nompro.

    FIND FIRST vtatabla WHERE vtatabla.codcia = DI-RutaC.codcia AND
            vtatabla.tabla = 'VEHICULO' AND vtatabla.llave_c2 = DI-RutaC.codveh AND
            vtatabla.llave_c1 = lCodPro NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
         lCosto      = vtatabla.valor[1].
         lTipo      = vtatabla.libre_c01.
    END.
    */

    /* La division/Sede de la emision de la hoja de Ruta */
    lOrigen = "".
    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
        gn-divi.coddiv = di-rutaC.coddiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN lOrigen = gn-divi.desdiv.

    /* Ventas */
    FOR EACH DI-RutaD WHERE DI-RutaD.codcia = DI-RutaC.codcia AND 
        DI-RutaD.coddiv = DI-RutaC.coddiv AND DI-RutaD.coddoc = DI-RutaC.coddoc AND
        DI-RutaD.NroDoc = DI-RutaC.Nrodoc NO-LOCK :
        
        lCCli = ''.
        lDCli = ''.
        lImp = 0.
        lMone = 'S/.'.
        lSoles = 0.
        lTcmb = 0.

        /* Busco por division - segun hoja de ruta */
        FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = DI-rutaC.codcia AND 
            DI-RutaD.coddiv = ccbcdocu.coddiv AND DI-RutaD.codref = ccbcdocu.coddoc AND
            DI-RutaD.nroref = ccbcdocu.nrodoc NO-LOCK NO-ERROR.

        /* Si no ubica el documento, lo busco sin la division
            por que hay casos que la hoja de ruta contiene
            documentos emitidos x otra division
         */
        IF NOT AVAILABLE ccbcdocu THEN DO:
            FIND FIRST CcbCDocu WHERE ccbcdocu.codcia = s-codcia
                AND DI-RutaD.codref = ccbcdocu.coddoc
                AND DI-RutaD.nroref = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
        END.

        lPesoGuia = 0.
        IF AVAILABLE ccbcdocu THEN DO:
            lCCli = ccbcdocu.codcli.
            lImp = ccbcdocu.imptot.
            lMone = IF(ccbcdocu.codmon = 2) THEN '$.' ELSE 'S/.'.
            lTcmb = ccbcdocu.tpocmb.
            lSoles = IF (ccbcdocu.codmon = 2) THEN lImp * lTcmb ELSE lImp.

            FIND FIRST gn-clie WHERE gn-clie.codcia= 0 AND gn-clie.codcli = ccbcdocu.codcli 
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN lDCli = gn-clie.nomcli.

            /* El peso de la Guia */
            FOR EACH ccbddocu OF ccbcdocu NO-LOCK :
                lPesoGuia = lPesoGuia + ccbddocu.pesmat.
            END.
        END.
        IF (txt-div = "" OR ccbcdocu.divori = txt-div) THEN DO:
            CREATE tt-hojaruta.
                ASSIGN tt-nrodoc   = DI-RutaC.nrodoc
                        tt-fchsal   = DI-RutaC.fchsal
                        tt-coddiv   = DI-RutaD.coddiv
                        tt-coclie   = lCCli
                        tt-nomcli   = lDCli
                        tt-serref   = DI-RutaD.codref
                        tt-nroref   = DI-RutaD.nroref                
                        tt-libre_d01    = DECIMAL(ENTRY(4,DI-RutaD.Libre_c01,","))
                        tt-moneda       = lMone
                        tt-imp-mone-ori = lImp
                        tt-tipo-cambio  = lTcmb
                        tt-imp-mone-sol = lSoles
                        tt-nomdivi = lOrigen
                        tt-peso  = lPesoGuia.

                IF AVAILABLE ccbcdocu THEN DO:
                    ASSIGN tt-fac-serie = ccbcdocu.codref
                            tt-fac-nro = ccbcdocu.nroref.
                            tt-divdcto = ccbcdocu.divori.
                    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
                        gn-divi.coddiv = ccbcdocu.divori NO-LOCK NO-ERROR.
                    ASSIGN tt-nomdctodiv = IF AVAILABLE gn-divi THEN gn-divi.desdiv ELSE "".

                END.
        END.
    END.      
END.
*/


   /* MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

