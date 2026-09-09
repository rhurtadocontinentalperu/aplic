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

DEFINE TEMP-TABLE tt-hoja-trabajo
    FIELDS tt-coddoc AS CHAR FORMAT 'x(5)'
    FIELDS tt-nroped LIKE faccpedi.nroped
    FIELDS tt-codcli LIKE faccpedi.codcli
    FIELDS tt-nomcli LIKE gn-clie.nomcli
    FIELDS tt-fchped LIKE faccpedi.fchped
    FIELDS tt-coddiv LIKE faccpedi.coddiv
    FIELDS tt-codmon LIKE faccpedi.codmon
    FIELDS tt-tpocmb LIKE faccpedi.tpocmb
    FIELDS tt-impbrt LIKE faccpedi.impbrt
    FIELDS tt-imptot LIKE faccpedi.imptot
    FIELDS tt-impigv LIKE faccpedi.impigv
    FIELDS tt-impvta LIKE faccpedi.impvta
    FIELDS tt-flgest LIKE faccpedi.flgest
    FIELDS tt-divdesp LIKE faccpedi.coddiv
    FIELDS tt-peso-od AS DEC INIT 0
    FIELDS tt-peso-emitido AS DEC INIT 0
    FIELDS tt-peso-despacho AS DEC INIT 0

    FIELD tt-codmat LIKE facdpedi.codmat
    FIELD tt-desmat LIKE almmmatg.desmat
    FIELD tt-codfam AS CHAR
    FIELD tt-subfam AS CHAR
    FIELD tt-canped LIKE facdpedi.canped
    FIELD tt-undvta LIKE facdpedi.undvta
    FIELD tt-implin LIKE facdpedi.implin

    INDEX idx01 IS PRIMARY tt-coddoc tt-nroped.

DEFINE TEMP-TABLE tt-copia LIKE tt-hoja-trabajo.

DEFINE VAR cRutaFileTxt AS CHAR.

define stream REPORT.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-orden RADIO-SET-formato RADIO-SET-1 ~
rchk_cuales txtDesde txtHasta txt-CD txt-div btn-Ok RECT-7 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-orden RADIO-SET-formato ~
RADIO-SET-1 rchk_cuales txtDesde txtHasta txt-CD txt-div txtMsg txt-nom-cd 

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

DEFINE VARIABLE FILL-IN-orden AS CHARACTER FORMAT "X(10)":U 
     LABEL "Alguna orden en particular" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .77 NO-UNDO.

DEFINE VARIABLE txt-CD AS CHARACTER FORMAT "X(5)":U 
     LABEL "Punto despacho" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE txt-div AS CHARACTER FORMAT "X(100)":U 
     LABEL "Division de origen" 
     VIEW-AS FILL-IN 
     SIZE 51.14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-nom-cd AS CHARACTER FORMAT "X(50)":U 
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

DEFINE VARIABLE txtMsg AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 33 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cabecera", 1,
"Cabecera + Detalle", 2
     SIZE 34 BY .77 NO-UNDO.

DEFINE VARIABLE RADIO-SET-formato AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Excel", 1,
"Texto", 2
     SIZE 23 BY .77 NO-UNDO.

DEFINE VARIABLE rchk_cuales AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "O/D", 1,
"OTR", 2,
"Ambos", 3
     SIZE 38 BY .85 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 1.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-orden AT ROW 9.73 COL 33 COLON-ALIGNED WIDGET-ID 46
     RADIO-SET-formato AT ROW 12.38 COL 11 NO-LABEL WIDGET-ID 42
     RADIO-SET-1 AT ROW 10.77 COL 11 NO-LABEL WIDGET-ID 38
     rchk_cuales AT ROW 8.81 COL 11 NO-LABEL WIDGET-ID 34
     txtDesde AT ROW 3.12 COL 17.43 COLON-ALIGNED WIDGET-ID 4
     txtHasta AT ROW 3.12 COL 35.57 WIDGET-ID 6
     txt-CD AT ROW 4.85 COL 17.72 COLON-ALIGNED WIDGET-ID 20
     txt-div AT ROW 6.73 COL 17.86 COLON-ALIGNED WIDGET-ID 24
     txtMsg AT ROW 13.23 COL 9 COLON-ALIGNED WIDGET-ID 30
     txt-nom-cd AT ROW 4.85 COL 26.72 COLON-ALIGNED WIDGET-ID 26
     btn-Ok AT ROW 11.38 COL 53 WIDGET-ID 12
     "Emitidas en este rango de fechas..." VIEW-AS TEXT
          SIZE 39.14 BY .62 AT ROW 2.08 COL 9.86 WIDGET-ID 10
          FONT 3
     "Seguimiento de Ordenes de Despacho (O/D)  y Transferencias (OTR)" VIEW-AS TEXT
          SIZE 64.14 BY .62 AT ROW 1.15 COL 4.57 WIDGET-ID 2
          FGCOLOR 4 FONT 12
     "Ejm : 00015,00021,00018...(Vacio = todos)" VIEW-AS TEXT
          SIZE 41 BY .62 AT ROW 7.81 COL 22 WIDGET-ID 22
     "   No valido para OTR" VIEW-AS TEXT
          SIZE 22 BY .62 AT ROW 6.08 COL 20 WIDGET-ID 32
          BGCOLOR 9 FGCOLOR 15 FONT 2
     "   Formato de exportacion" VIEW-AS TEXT
          SIZE 26.43 BY .62 AT ROW 11.77 COL 11.57 WIDGET-ID 48
          BGCOLOR 4 FGCOLOR 15 FONT 2
     RECT-7 AT ROW 2.69 COL 9.43 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72.57 BY 13.58 WIDGET-ID 100.


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
         TITLE              = "Seguimiento Ordenes de Despacho"
         HEIGHT             = 13.58
         WIDTH              = 72.57
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
/* SETTINGS FOR FILL-IN txtHasta IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN txtMsg IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Seguimiento Ordenes de Despacho */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Seguimiento Ordenes de Despacho */
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
  ASSIGN txtDesde txtHasta txt-CD txt-div rchk_cuales RADIO-SET-1 fill-in-orden radio-set-formato.


  IF txtDesde = ?  THEN DO:
    MESSAGE 'Fecha DESDE esta ERRADA' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  IF txtHasta = ?  THEN DO:
    MESSAGE 'Fecha Hasta esta ERRADA' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.

  IF txtDesde > txtHasta THEN DO:
      MESSAGE 'Fechas Erradas' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.

  DEFINE VAR iDias AS INT.

  iDias = txtHasta - txtDesde.

  IF iDias > 31 THEN DO:
      MESSAGE 'Maximo de rango de fechas en 31 dias' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.

  DEFINE VAR lDirectorio AS CHAR.
  DEFINE VAR rpta AS LOG.

  /* TEXTO */
  IF Radio-set-formato = 2 THEN DO:
      /*
      SYSTEM-DIALOG GET-DIR lDirectorio  
         RETURN-TO-START-DIR 
         TITLE 'Seleccione el directorio para el TXT'.
      IF lDirectorio = "" THEN DO:
          RETURN NO-APPLY.
      END.
    */
	SYSTEM-DIALOG GET-FILE cRutaFileTxt
	    FILTERS 'Texto (*.txt)' '*.txt'
	    ASK-OVERWRITE
	    CREATE-TEST-FILE
	    DEFAULT-EXTENSION '.txt'
	    RETURN-TO-START-DIR
	    SAVE-AS
	    TITLE 'Exportar a texto'
	    UPDATE rpta.
	IF rpta = NO OR cRutaFileTxt = '' THEN RETURN NO-APPLY.
  END.
  /*cRutaFileTxt = lDirectorio.*/

  RUN um_proceso_v2.
  /*RUN um_calcula_valores.*/

  IF radio-set-formato = 1 THEN DO:
      CASE RADIO-SET-1:
          WHEN 1 THEN RUN um_envia_excel.
          WHEN 2 THEN RUN um_envia_excel-detalle.
      END CASE.
  END.    
  ELSE DO:
      RUN um_envia_txt.
  END.
  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rchk_cuales
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rchk_cuales W-Win
ON VALUE-CHANGED OF rchk_cuales IN FRAME F-Main
DO:
  IF SELF:SCREEN-VALUE = '3' THEN DO:
      fill-in-orden:VISIBLE = NO.
  END.
  ELSE DO:
      fill-in-orden:VISIBLE = YES.
  END.
       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME txt-CD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL txt-CD W-Win
ON LEAVE OF txt-CD IN FRAME F-Main /* Punto despacho */
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
ON LEAVE OF txt-div IN FRAME F-Main /* Division de origen */
DO:
    DEFINE VAR lCodDiv AS CHAR.

    /*txt-nom-div:SCREEN-VALUE ="".*/

    lCodDiv = txt-div:SCREEN-VALUE.
/*
    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND 
        gn-divi.coddiv = lCodDiv NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN DO:
        txt-nom-div:SCREEN-VALUE = gn-divi.desdiv.
    END.
  */
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
  DISPLAY FILL-IN-orden RADIO-SET-formato RADIO-SET-1 rchk_cuales txtDesde 
          txtHasta txt-CD txt-div txtMsg txt-nom-cd 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-orden RADIO-SET-formato RADIO-SET-1 rchk_cuales txtDesde 
         txtHasta txt-CD txt-div btn-Ok RECT-7 
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
        chWorkSheet:Range("F1"):Value = "DESDE :" + 
        STRING(txtDesde,"99/99/9999") + "   HASTA :" + STRING(txtHasta,"99/99/9999").

    chWorkSheet:Range("A2:AZ2"):Font:Bold = TRUE.

    chWorkSheet:Range("A2"):Value = "Cod.Doc".
    chWorkSheet:Range("B2"):Value = "Numero".
    chWorkSheet:Range("C2"):Value = "CodCliente".    
    chWorkSheet:Range("D2"):Value = "Nombre Cliente".
    chWorkSheet:Range("E2"):Value = "Fecha Emision".
    chWorkSheet:Range("F2"):Value = "Division".
    chWorkSheet:Range("G2"):Value = "Impte Venta".
    chWorkSheet:Range("H2"):Value = "Impte IGV".
    chWorkSheet:Range("I2"):Value = "Impte Total".
    chWorkSheet:Range("J2"):Value = "Estado".  
    chWorkSheet:Range("K2"):Value = "Peso de la ORDEN".  
    chWorkSheet:Range("L2"):Value = "Peso de la GUIA".  
    chWorkSheet:Range("M2"):Value = "Peso Despachado".  
    chWorkSheet:Range("N2"):Value = "Punto Salida".  
    
        DEF VAR x-Column AS INT INIT 74 NO-UNDO.
        DEF VAR x-Range  AS CHAR NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
iColumn = 2.

FOR EACH tt-hoja-trabajo NO-LOCK:
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-hoja-trabajo.tt-coddoc.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-hoja-trabajo.tt-nroped.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-hoja-trabajo.tt-codcli.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-hoja-trabajo.tt-nomcli.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-fchped.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-hoja-trabajo.tt-coddiv.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-impvta.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-impigv.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-imptot.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-flgest.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-peso-od.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-peso-emitido.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-peso-despacho.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-hoja-trabajo.tt-divdesp.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um_envia_excel-detalle W-Win 
PROCEDURE um_envia_excel-detalle :
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
chExcelApplication:Visible = TRUE.

/* Para crear a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chExcelApplication:VISIBLE = FALSE.

/* set the column names for the Worksheet */

chWorkSheet:Range("F1"):Font:Bold = TRUE.
chWorkSheet:Range("F1"):Value = "DESDE :" + 
STRING(txtDesde,"99/99/9999") + "   HASTA :" + STRING(txtHasta,"99/99/9999").

chWorkSheet:Range("A2:AZ2"):Font:Bold = TRUE.

chWorkSheet:Range("A2"):Value = "Cod.Doc".
chWorkSheet:Range("B2"):Value = "Numero".
chWorkSheet:Range("C2"):Value = "CodCliente".    
chWorkSheet:Range("D2"):Value = "Nombre Cliente".
chWorkSheet:Range("E2"):Value = "Fecha Emision".
chWorkSheet:Range("F2"):Value = "Division".
chWorkSheet:Range("G2"):Value = "Impte Venta".
chWorkSheet:Range("H2"):Value = "Impte IGV".
chWorkSheet:Range("I2"):Value = "Impte Total".
chWorkSheet:Range("J2"):Value = "Estado".  
chWorkSheet:Range("K2"):Value = "Peso de la ORDEN".  
chWorkSheet:Range("L2"):Value = "Peso de la GUIA".  
chWorkSheet:Range("M2"):Value = "Peso Despachado".  
chWorkSheet:Range("N2"):Value = "Punto Salida".  
chWorkSheet:Range("O2"):Value = "Articulo".  
chWorkSheet:Range("P2"):Value = "Descripcion".  
chWorkSheet:Range("Q2"):Value = "Familia".  
chWorkSheet:Range("R2"):Value = "Sub-Familia".  
chWorkSheet:Range("S2"):Value = "Cantidad".  
chWorkSheet:Range("T2"):Value = "Unidad".  
chWorkSheet:Range("U2"):Value = "Importe".  

DEF VAR x-Column AS INT INIT 74 NO-UNDO.
DEF VAR x-Range  AS CHAR NO-UNDO.

SESSION:SET-WAIT-STATE('GENERAL').
iColumn = 2.

FOR EACH tt-hoja-trabajo NO-LOCK:
        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-hoja-trabajo.tt-coddoc.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-hoja-trabajo.tt-nroped.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-hoja-trabajo.tt-codcli.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-hoja-trabajo.tt-nomcli.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-fchped.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-hoja-trabajo.tt-coddiv.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-impvta.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-impigv.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-imptot.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-flgest.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-peso-od.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-peso-emitido.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-peso-despacho.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-hoja-trabajo.tt-divdesp.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + tt-hoja-trabajo.tt-codmat.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-desmat.
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-codfam.
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-subfam.
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-canped.
        cRange = "T" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-undvta.
        cRange = "U" + cColumn.
        chWorkSheet:Range(cRange):Value = tt-hoja-trabajo.tt-implin.
END.
chExcelApplication:DisplayAlerts = False.
chExcelApplication:VISIBLE = TRUE .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um_envia_txt W-Win 
PROCEDURE um_envia_txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF RADIO-SET-1 = 2 THEN DO:
    RUN um_envia_txt_detalle.
    RETURN.
END.
                       
OUTPUT STREAM REPORT TO VALUE(cRutaFileTxt).

SESSION:SET-WAIT-STATE('GENERAL').

PUT STREAM REPORT
  "Cod.Doc|" 
  "Numero|"
  "CodCliente|"
  "Nombre Cliente|"
    "Fecha Emision|"
    "Division|"
    "Impte Venta|"
    "Impte IGV|"
    "Impte Total|"
    "Estado|"
    "Peso de la ORDEN|"
    "Peso de la GUIA|"
    "Peso Despachado|"
    "Punto Salida" SKIP.

FOR EACH tt-hoja-trabajo NO-LOCK:

        PUT STREAM REPORT
            tt-hoja-trabajo.tt-coddoc "|"
            tt-hoja-trabajo.tt-nroped "|"
            tt-hoja-trabajo.tt-codcli "|" 
            trim(tt-hoja-trabajo.tt-nomcli) FORMA 'x(80)' "|" 
            tt-hoja-trabajo.tt-fchped "|" 
            tt-hoja-trabajo.tt-coddiv "|" 
            tt-hoja-trabajo.tt-impvta "|" 
            tt-hoja-trabajo.tt-impigv "|" 
            tt-hoja-trabajo.tt-imptot "|" 
            tt-hoja-trabajo.tt-flgest "|" 
            tt-hoja-trabajo.tt-peso-od "|" 
            tt-hoja-trabajo.tt-peso-emitido "|" 
            tt-hoja-trabajo.tt-peso-despacho "|" 
            tt-hoja-trabajo.tt-divdesp SKIP.
END.

OUTPUT STREAM REPORT CLOSE.

SESSION:SET-WAIT-STATE('').

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um_envia_txt_detalle W-Win 
PROCEDURE um_envia_txt_detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OUTPUT STREAM REPORT TO VALUE(cRutaFileTxt).

SESSION:SET-WAIT-STATE('GENERAL').

PUT STREAM REPORT
"Cod.Doc|"
"Numero|"
"CodCliente|"    
"Nombre Cliente|"
"Fecha Emision|"
"Division|"
"Impte Venta|"
"Impte IGV|"
"Impte Total|"
"Estado|"  
"Peso de la ORDEN|"  
"Peso de la GUIA|"  
"Peso Despachado|"  
"Punto Salida|"  
"Articulo|"  
"Descripcion|"
"Familia|"  
"Sub-Familia|"
"Cantidad|"  
"Unidad|"  
"Importe" SKIP.

FOR EACH tt-hoja-trabajo NO-LOCK:
    PUT STREAM REPORT
    tt-hoja-trabajo.tt-coddoc "|"
    tt-hoja-trabajo.tt-nroped "|"
    tt-hoja-trabajo.tt-codcli "|"
    trim(tt-hoja-trabajo.tt-nomcli) FORMA 'x(80)' "|" 
    tt-hoja-trabajo.tt-fchped "|"
    tt-hoja-trabajo.tt-coddiv "|"
    tt-hoja-trabajo.tt-impvta "|"
    tt-hoja-trabajo.tt-impigv "|"
    tt-hoja-trabajo.tt-imptot "|"
    tt-hoja-trabajo.tt-flgest "|"
    tt-hoja-trabajo.tt-peso-od "|"
    tt-hoja-trabajo.tt-peso-emitido "|"
    tt-hoja-trabajo.tt-peso-despacho "|"
    tt-hoja-trabajo.tt-divdesp "|"
    tt-hoja-trabajo.tt-codmat "|"
    tt-hoja-trabajo.tt-desmat "|"
    tt-hoja-trabajo.tt-codfam "|"
    tt-hoja-trabajo.tt-subfam "|"
    tt-hoja-trabajo.tt-canped "|"
    tt-hoja-trabajo.tt-undvta "|"
    tt-hoja-trabajo.tt-implin SKIP.
END.

OUTPUT STREAM REPORT CLOSE.

SESSION:SET-WAIT-STATE('').

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.


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

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VAR lPesoOD AS DEC.
DEFINE VAR lPesoFAC AS DEC.
DEFINE VAR lPesoDESP AS DEC.

DEFINE VAR lQueOrds AS CHAR.
DEFINE VAR lSec AS INT.
DEFINE VAR lCodDoc AS CHAR.
DEFINE VAR dcImporte AS DEC.
DEFINE VAR lTCambio AS DEC.
DEFINE VAR lCostoVenta AS DEC.

lQueOrds = IF(rchk_cuales = 1) THEN "O/D" ELSE lQueOrds.
lQueOrds = IF(rchk_cuales = 2) THEN "OTR" ELSE lQueOrds.
lQueOrds = IF(rchk_cuales = 3) THEN "O/D,OTR" ELSE lQueOrds.

EMPTY TEMP-TABLE tt-hoja-trabajo.

/* Todas las O/D y OTR */

REPEAT lSec = 1 TO NUM-ENTRIES(lQueOrds,","):
    lCodDoc = ENTRY(lSec,lQueOrds,",").
    FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia AND faccpedi.coddoc = lCodDoc AND
        (faccpedi.fchped >= txtDesde AND faccpedi.fchped <= txtHasta) AND faccpedi.flgest <> 'A' NO-LOCK :
        
        txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = faccpedi.nroped.

        IF lCodDoc = 'O/D' THEN DO:
            IF (txt-div <> "" AND LOOKUP(faccpedi.coddiv,txt-div) = 0) OR faccpedi.flgest = 'A' THEN NEXT.
        END.
        
        lPesoOD = 0.
        dcImporte = 0.
        lCostoVenta = 0.
        FOR EACH facdpedi OF faccpedi NO-LOCK, 
            FIRST almmmatg OF facdpedi NO-LOCK:
            lPesoOD = lpesoOD + (facdpedi.canped * almmmatg.pesmat).
            /**/
            lTCambio = 1.
            IF almmmatg.monvta = 2 THEN DO:
                /* Dolares */
                lTCambio = Almmmatg.tpocmb.
            END.
            lCostoVenta = lCostoVenta + ((Almmmatg.preofi * lTCambio) * facdpedi.canped).
        END.

        FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND gn-clie.codcli = faccpedi.codcli NO-LOCK NO-ERROR.
        IF txt-cd = "" THEN DO:
            CREATE tt-hoja-trabajo.
            ASSIGN  tt-coddoc = faccpedi.coddoc
                    tt-nroped = faccpedi.nroped
                    tt-codcli = faccpedi.codcli
                    tt-nomcli = faccpedi.nomcli
                    tt-fchped = faccpedi.fchped
                    tt-coddiv = faccpedi.coddiv
                    tt-codmon = faccpedi.codmon
                    tt-tpocmb = faccpedi.tpocmb
                    tt-impbrt = lCostoVenta
                    tt-imptot = lCostoVenta
                    tt-impigv = 0
                    tt-impvta = lCostoVenta
                    tt-flgest = faccpedi.flgest
                    tt-peso-od = lPesoOD
                    tt-peso-emitido = 0
                    tt-peso-despacho = 0.                   
        END.

        IF faccpedi.coddoc = 'OTR' THEN DO:
            /**/            
            FOR EACH almcmov USE-INDEX almc07 WHERE almcmov.codcia = s-codcia AND 
                                    almcmov.codref = faccpedi.coddoc AND 
                                    almcmov.nroref = faccpedi.nroped AND
                                    almcmov.flgest <> 'A'
                                    NO-LOCK :               
                lpesoFAC = 0.
                FOR EACH almdmov OF almcmov NO-LOCK,
                    FIRST almmmatg OF almdmov NO-LOCK:
                    lPesoFAC = lpesoFAC + (almdmov.candes * almmmatg.pesmat).
                END.
                IF txt-cd = "" THEN DO:
                    ASSIGN tt-peso-emitido = tt-peso-emitido + lPesoFAC.
                END.  
                /**/
                FIND FIRST di-rutaG WHERE di-rutaG.codcia = s-codcia AND 
                                            di-rutaG.coddoc = 'H/R' AND 
                                            di-rutaG.codalm = almcmov.codalm AND
                                            di-rutaG.tipmov = almcmov.tipmov AND 
                                            di-rutaG.codmov = almcmov.codmov AND 
                                            di-rutaG.serref = almcmov.nroser AND 
                                            di-rutaG.nroref = almcmov.nrodoc
                                            NO-LOCK NO-ERROR.
                IF AVAILABLE di-rutaG THEN DO:
                    IF txt-cd = "" THEN DO:                    
                        ASSIGN tt-peso-despacho = tt-peso-despacho + lPesoFAC
                                tt-divdesp = di-rutaG.coddiv.
                    END.
                    ELSE DO:
                        IF txt-cd = di-rutaG.coddiv  THEN DO:
                            FIND FIRST tt-hoja-trabajo WHERE tt-hoja-trabajo.tt-coddoc = faccpedi.coddoc AND 
                                                tt-hoja-trabajo.tt-nroped = faccpedi.nroped EXCLUSIVE NO-ERROR.
                            IF NOT AVAILABLE tt-hoja-trabajo THEN DO:

                                CREATE tt-hoja-trabajo.
                                ASSIGN  tt-coddoc = faccpedi.coddoc
                                        tt-nroped = faccpedi.nroped
                                        tt-codcli = faccpedi.codcli
                                        tt-nomcli = faccpedi.nomcli
                                        tt-fchped = faccpedi.fchped
                                        tt-coddiv = faccpedi.coddiv
                                        tt-codmon = faccpedi.codmon
                                        tt-tpocmb = faccpedi.tpocmb
                                        tt-impbrt = lCostoVenta
                                        tt-imptot = lCostoVenta
                                        tt-impigv = 0
                                        tt-impvta = lCostoVenta
                                        tt-flgest = faccpedi.flgest
                                        tt-divdesp = di-rutaG.coddiv
                                        tt-peso-od = lPesoOD
                                        tt-peso-emitido = 0
                                        tt-peso-despacho = 0.                   
                            END.            
                            ASSIGN tt-peso-despacho = tt-peso-despacho + lPesoFAC
                                    tt-peso-emitido = tt-peso-emitido + lPesoFAC.
                        END.
                    END.
                END.
            END.
            /* Que no continue, Seguir leyendo las OTR */
            NEXT.
        END.

        /* Todos los Comprobanyes emitidos x cada O/D  */
        FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND ccbcdocu.codped = 'PED' AND 
                                ccbcdocu.nroped = faccpedi.nroref AND ccbcdocu.flgest <> 'A' NO-LOCK:

            /* G/R de la misma O/D */
            IF ccbcdocu.coddoc = 'G/R' AND ccbcdocu.libre_c01 = 'O/D' AND ccbcdocu.libre_c02 = faccpedi.nroped THEN DO:       

                lpesoFAC = 0.
                FOR EACH ccbddocu OF ccbcdocu NO-LOCK,
                    FIRST almmmatg OF ccbddocu NO-LOCK:
                    lPesoFAC = lpesoFAC + ccbddocu.pesmat /*(ccbddocu.candes * almmmatg.pesmat)*/.
                END.

                IF txt-cd = "" THEN DO:
                    ASSIGN tt-peso-emitido = tt-peso-emitido + lPesoFAC.
                END.            

                /* Buscar si la guia de remision G/R ya se despacho */
                FIND FIRST di-rutad WHERE di-rutad.codcia = s-codcia AND di-rutad.coddoc = 'H/R' AND 
                                            di-rutad.codref = ccbcdocu.coddoc AND di-rutad.nroref = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
                IF AVAILABLE di-rutad THEN DO:                
                    IF txt-cd = "" THEN DO:                    
                        ASSIGN tt-peso-despacho = tt-peso-despacho + lPesoFAC
                                tt-divdesp = di-rutad.coddiv.
                    END.
                    ELSE DO:
                        IF txt-cd = di-rutad.coddiv  THEN DO:
                            FIND FIRST tt-hoja-trabajo WHERE tt-hoja-trabajo.tt-coddoc = faccpedi.coddoc AND 
                                                tt-hoja-trabajo.tt-nroped = faccpedi.nroped EXCLUSIVE NO-ERROR.
                            IF NOT AVAILABLE tt-hoja-trabajo THEN DO:

                                CREATE tt-hoja-trabajo.
                                ASSIGN  tt-coddoc = faccpedi.coddoc
                                        tt-nroped = faccpedi.nroped
                                        tt-codcli = faccpedi.codcli
                                        tt-nomcli = gn-clie.nomcli
                                        tt-fchped = faccpedi.fchped
                                        tt-coddiv = faccpedi.coddiv
                                        tt-codmon = faccpedi.codmon
                                        tt-tpocmb = faccpedi.tpocmb
                                        tt-impbrt = faccpedi.impbrt
                                        tt-imptot = faccpedi.imptot
                                        tt-impigv = faccpedi.impigv
                                        tt-impvta = faccpedi.impvta
                                        tt-flgest = faccpedi.flgest
                                        tt-divdesp = di-rutad.coddiv
                                        tt-peso-od = lPesoOD
                                        tt-peso-emitido = 0
                                        tt-peso-despacho = 0.                   
                            END.            
                            ASSIGN tt-peso-despacho = tt-peso-despacho + lPesoFAC
                                    tt-peso-emitido = tt-peso-emitido + lPesoFAC.
                        END.
                    END.
                END.
            END.
        END.
    END.
END.
/* RHC 27/02/2017 En caso de Cabecera + Detalle */
txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Agregando el detalle".
IF RADIO-SET-1 = 2 THEN DO:
    EMPTY TEMP-TABLE tt-copia.
    FOR EACH tt-hoja-trabajo:
        CREATE tt-copia.
        BUFFER-COPY tt-hoja-trabajo TO tt-copia.
        DELETE tt-hoja-trabajo.
    END.
    FOR EACH tt-copia NO-LOCK, FIRST faccpedi NO-LOCK WHERE faccpedi.codcia = s-codcia
        AND faccpedi.coddiv = tt-copia.tt-coddiv
        AND faccpedi.coddoc = tt-copia.tt-coddoc
        AND faccpedi.nroped = tt-copia.tt-nroped,
        EACH facdpedi OF faccpedi NO-LOCK,
        FIRST almmmatg OF facdpedi NO-LOCK,
        FIRST almtfami OF almmmatg NO-LOCK,
        FIRST almsfami OF almmmatg NO-LOCK:
        CREATE tt-hoja-trabajo.
        BUFFER-COPY tt-copia TO tt-hoja-trabajo.
        ASSIGN
            tt-hoja-trabajo.tt-codmat = facdpedi.codmat
            tt-hoja-trabajo.tt-desmat = almmmatg.desmat
            tt-hoja-trabajo.tt-codfam = Almtfami.codfam + ' ' + Almtfami.desfam
            tt-hoja-trabajo.tt-subfam = AlmSFami.subfam + ' ' + AlmSFami.dessub 
            tt-hoja-trabajo.tt-canped = facdpedi.canped
            tt-hoja-trabajo.tt-undvta = facdpedi.undvta
            tt-hoja-trabajo.tt-implin = facdpedi.implin.
    END.
END.
SESSION:SET-WAIT-STATE('').

/*

EMPTY TEMP-TABLE tt-hojaruta.

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


SESSION:SET-WAIT-STATE('').

   /* MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.*/
  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um_proceso_v2 W-Win 
PROCEDURE um_proceso_v2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').

DEFINE VAR lQueOrds AS CHAR.
DEFINE VAR lSec AS INT.
DEFINE VAR lCodDoc AS CHAR.
DEFINE VAR lNroOrden AS CHAR.

lQueOrds = IF(rchk_cuales = 1) THEN "O/D" ELSE lQueOrds.
lQueOrds = IF(rchk_cuales = 2) THEN "OTR" ELSE lQueOrds.
lQueOrds = IF(rchk_cuales = 3) THEN "O/D,OTR" ELSE lQueOrds.

EMPTY TEMP-TABLE tt-hoja-trabajo.

lNroOrden = fill-in-orden:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

IF fill-in-orden:VISIBLE AND rchk_cuales <> 3 AND NOT (TRUE <> ( lNroOrden > ""))  THEN DO:
    FIND FIRST faccpedi WHERE faccpedi.codcia = 1 AND faccpedi.coddoc = lQueOrds AND
                                faccpedi.nroped = lNroOrden NO-LOCK NO-ERROR.
    IF NOT AVAILABLE faccpedi OR faccpedi.flgest = 'A' THEN DO:
        MESSAGE "La orden no existe o esta anulada" VIEW-AS ALERT-BOX INFORMATION.
        RETURN.
    END.

    RUN um_proceso_v2_dtl.
END.
ELSE DO:
    /* Todas las O/D y OTR */
    REPEAT lSec = 1 TO NUM-ENTRIES(lQueOrds,","):
        lCodDoc = ENTRY(lSec,lQueOrds,",").
        FOR EACH faccpedi WHERE faccpedi.codcia = s-codcia AND faccpedi.coddoc = lCodDoc AND
            faccpedi.fchped >= txtDesde AND faccpedi.flgest <> 'A' NO-LOCK :
            /*(faccpedi.fchped >= txtDesde AND faccpedi.fchped <= txtHasta) AND faccpedi.flgest <> 'A' NO-LOCK :*/

            IF faccpedi.fchped > txtHasta THEN NEXT.

            txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = faccpedi.nroped.

            RUN um_proceso_v2_dtl.
        END.
    END.
END.
/* RHC 27/02/2017 En caso de Cabecera + Detalle */
txtMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Agregando el detalle".
IF RADIO-SET-1 = 2 THEN DO:
    EMPTY TEMP-TABLE tt-copia.
    FOR EACH tt-hoja-trabajo:
        CREATE tt-copia.
        BUFFER-COPY tt-hoja-trabajo TO tt-copia.
        DELETE tt-hoja-trabajo.
    END.
    FOR EACH tt-copia NO-LOCK, FIRST faccpedi NO-LOCK WHERE faccpedi.codcia = s-codcia
        AND faccpedi.coddiv = tt-copia.tt-coddiv
        AND faccpedi.coddoc = tt-copia.tt-coddoc
        AND faccpedi.nroped = tt-copia.tt-nroped,
        EACH facdpedi OF faccpedi NO-LOCK,
        FIRST almmmatg OF facdpedi NO-LOCK,
        FIRST almtfami OF almmmatg NO-LOCK,
        FIRST almsfami OF almmmatg NO-LOCK:
        CREATE tt-hoja-trabajo.
        BUFFER-COPY tt-copia TO tt-hoja-trabajo.
        ASSIGN
            tt-hoja-trabajo.tt-codmat = facdpedi.codmat
            tt-hoja-trabajo.tt-desmat = almmmatg.desmat
            tt-hoja-trabajo.tt-codfam = Almtfami.codfam + ' ' + Almtfami.desfam
            tt-hoja-trabajo.tt-subfam = AlmSFami.subfam + ' ' + AlmSFami.dessub 
            tt-hoja-trabajo.tt-canped = facdpedi.canped
            tt-hoja-trabajo.tt-undvta = facdpedi.undvta
            tt-hoja-trabajo.tt-implin = facdpedi.implin.
    END.
END.
SESSION:SET-WAIT-STATE('').


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE um_proceso_v2_dtl W-Win 
PROCEDURE um_proceso_v2_dtl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lPesoOD AS DEC.
DEFINE VAR lPesoFAC AS DEC.
DEFINE VAR lPesoDESP AS DEC.

DEFINE VAR dcImporte AS DEC.
DEFINE VAR lTCambio AS DEC.
DEFINE VAR lCostoVenta AS DEC.

    IF faccpedi.coddoc = 'O/D' THEN DO:
        IF (txt-div <> "" AND LOOKUP(faccpedi.coddiv,txt-div) = 0) OR faccpedi.flgest = 'A' THEN RETURN.
    END.
    
    lPesoOD = 0.
    dcImporte = 0.
    lCostoVenta = 0.
    FOR EACH facdpedi OF faccpedi NO-LOCK, 
        FIRST almmmatg OF facdpedi NO-LOCK:
        lPesoOD = lpesoOD + (facdpedi.canped * almmmatg.pesmat).
        /**/
        lTCambio = 1.
        IF almmmatg.monvta = 2 THEN DO:
            /* Dolares */
            lTCambio = Almmmatg.tpocmb.
        END.
        lCostoVenta = lCostoVenta + ((Almmmatg.preofi * lTCambio) * facdpedi.canped).
    END.

    FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND gn-clie.codcli = faccpedi.codcli NO-LOCK NO-ERROR.
    IF txt-cd = "" THEN DO:
        CREATE tt-hoja-trabajo.
        ASSIGN  tt-coddoc = faccpedi.coddoc
                tt-nroped = faccpedi.nroped
                tt-codcli = faccpedi.codcli
                tt-nomcli = faccpedi.nomcli
                tt-fchped = faccpedi.fchped
                tt-coddiv = faccpedi.coddiv
                tt-codmon = faccpedi.codmon
                tt-tpocmb = faccpedi.tpocmb
                tt-impbrt = lCostoVenta
                tt-imptot = lCostoVenta
                tt-impigv = 0
                tt-impvta = lCostoVenta
                tt-flgest = faccpedi.flgest
                tt-peso-od = lPesoOD
                tt-peso-emitido = 0
                tt-peso-despacho = 0.                   
    END.

    IF faccpedi.coddoc = 'OTR' THEN DO:
        /**/            
        FOR EACH almcmov USE-INDEX almc07 WHERE almcmov.codcia = s-codcia AND 
                                almcmov.codref = faccpedi.coddoc AND 
                                almcmov.nroref = faccpedi.nroped AND
                                almcmov.flgest <> 'A'
                                NO-LOCK :               
            lpesoFAC = 0.
            FOR EACH almdmov OF almcmov NO-LOCK,
                FIRST almmmatg OF almdmov NO-LOCK:
                lPesoFAC = lpesoFAC + (almdmov.candes * almmmatg.pesmat).
            END.
            IF txt-cd = "" THEN DO:
                ASSIGN tt-peso-emitido = tt-peso-emitido + lPesoFAC.
            END.  
            /**/
            FIND FIRST di-rutaG WHERE di-rutaG.codcia = s-codcia AND 
                                        di-rutaG.coddoc = 'H/R' AND 
                                        di-rutaG.codalm = almcmov.codalm AND
                                        di-rutaG.tipmov = almcmov.tipmov AND 
                                        di-rutaG.codmov = almcmov.codmov AND 
                                        di-rutaG.serref = almcmov.nroser AND 
                                        di-rutaG.nroref = almcmov.nrodoc
                                        NO-LOCK NO-ERROR.
            IF AVAILABLE di-rutaG THEN DO:
                IF txt-cd = "" THEN DO:                    
                    ASSIGN tt-peso-despacho = tt-peso-despacho + lPesoFAC
                            tt-divdesp = di-rutaG.coddiv.
                END.
                ELSE DO:
                    IF txt-cd = di-rutaG.coddiv  THEN DO:
                        FIND FIRST tt-hoja-trabajo WHERE tt-hoja-trabajo.tt-coddoc = faccpedi.coddoc AND 
                                            tt-hoja-trabajo.tt-nroped = faccpedi.nroped EXCLUSIVE NO-ERROR.
                        IF NOT AVAILABLE tt-hoja-trabajo THEN DO:

                            CREATE tt-hoja-trabajo.
                            ASSIGN  tt-coddoc = faccpedi.coddoc
                                    tt-nroped = faccpedi.nroped
                                    tt-codcli = faccpedi.codcli
                                    tt-nomcli = faccpedi.nomcli
                                    tt-fchped = faccpedi.fchped
                                    tt-coddiv = faccpedi.coddiv
                                    tt-codmon = faccpedi.codmon
                                    tt-tpocmb = faccpedi.tpocmb
                                    tt-impbrt = lCostoVenta
                                    tt-imptot = lCostoVenta
                                    tt-impigv = 0
                                    tt-impvta = lCostoVenta
                                    tt-flgest = faccpedi.flgest
                                    tt-divdesp = di-rutaG.coddiv
                                    tt-peso-od = lPesoOD
                                    tt-peso-emitido = 0
                                    tt-peso-despacho = 0.                   
                        END.            
                        ASSIGN tt-peso-despacho = tt-peso-despacho + lPesoFAC
                                tt-peso-emitido = tt-peso-emitido + lPesoFAC.
                    END.
                END.
            END.
        END.
        /* Que no continue, Seguir leyendo las OTR */
        NEXT.
    END.

    /* Todos los Comprobanyes emitidos x cada O/D  */
    FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND ccbcdocu.codped = 'PED' AND 
                            ccbcdocu.nroped = faccpedi.nroref AND ccbcdocu.flgest <> 'A' NO-LOCK:

        /* G/R de la misma O/D */
        IF ccbcdocu.coddoc = 'G/R' AND ccbcdocu.libre_c01 = 'O/D' AND ccbcdocu.libre_c02 = faccpedi.nroped THEN DO:       

            lpesoFAC = 0.
            FOR EACH ccbddocu OF ccbcdocu NO-LOCK,
                FIRST almmmatg OF ccbddocu NO-LOCK:
                lPesoFAC = lpesoFAC + ccbddocu.pesmat /*(ccbddocu.candes * almmmatg.pesmat)*/.
            END.

            IF txt-cd = "" THEN DO:
                ASSIGN tt-peso-emitido = tt-peso-emitido + lPesoFAC.
            END.            

            /* Buscar si la guia de remision G/R ya se despacho */
            FIND FIRST di-rutad WHERE di-rutad.codcia = s-codcia AND di-rutad.coddoc = 'H/R' AND 
                                        di-rutad.codref = ccbcdocu.coddoc AND di-rutad.nroref = ccbcdocu.nrodoc NO-LOCK NO-ERROR.
            IF AVAILABLE di-rutad THEN DO:                
                IF txt-cd = "" THEN DO:                    
                    ASSIGN tt-peso-despacho = tt-peso-despacho + lPesoFAC
                            tt-divdesp = di-rutad.coddiv.
                END.
                ELSE DO:
                    IF txt-cd = di-rutad.coddiv  THEN DO:
                        FIND FIRST tt-hoja-trabajo WHERE tt-hoja-trabajo.tt-coddoc = faccpedi.coddoc AND 
                                            tt-hoja-trabajo.tt-nroped = faccpedi.nroped EXCLUSIVE NO-ERROR.
                        IF NOT AVAILABLE tt-hoja-trabajo THEN DO:

                            CREATE tt-hoja-trabajo.
                            ASSIGN  tt-coddoc = faccpedi.coddoc
                                    tt-nroped = faccpedi.nroped
                                    tt-codcli = faccpedi.codcli
                                    tt-nomcli = gn-clie.nomcli
                                    tt-fchped = faccpedi.fchped
                                    tt-coddiv = faccpedi.coddiv
                                    tt-codmon = faccpedi.codmon
                                    tt-tpocmb = faccpedi.tpocmb
                                    tt-impbrt = faccpedi.impbrt
                                    tt-imptot = faccpedi.imptot
                                    tt-impigv = faccpedi.impigv
                                    tt-impvta = faccpedi.impvta
                                    tt-flgest = faccpedi.flgest
                                    tt-divdesp = di-rutad.coddiv
                                    tt-peso-od = lPesoOD
                                    tt-peso-emitido = 0
                                    tt-peso-despacho = 0.                   
                        END.            
                        ASSIGN tt-peso-despacho = tt-peso-despacho + lPesoFAC
                                tt-peso-emitido = tt-peso-emitido + lPesoFAC.
                    END.
                END.
            END.
        END.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

