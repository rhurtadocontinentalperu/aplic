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

DEFINE TEMP-TABLE tData
    FIELD   fecha           AS DATE    COLUMN-LABEL "Fecha Registro"
    FIELD   nruta           AS CHAR    FORMAT 'x(10)' COLUMN-LABEL "Hoja de ruta"
    FIELD   nplaca          AS CHAR    FORMAT 'x(10)' COLUMN-LABEL "Nro de Placa"
    FIELD   dresponsable    AS CHAR    FORMAT 'x(100)' COLUMN-LABEL "Responsable del reparto"
    FIELD   dcliente        AS CHAR    FORMAT 'x(100)' COLUMN-LABEL "Cliente"
    FIELD   ixcobrar        AS DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Importe de la venta (Soles) "
    FIELD   icobrado        AS DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Importe cobrado (Soles)"
    FIELD   dtiendaorigen   AS CHAR    FORMAT 'x(100)' COLUMN-LABEL "Tienda origen"
    FIELD   dsede           AS CHAR    FORMAT 'x(100)' COLUMN-LABEL "Sede".


DEF VAR cDelimitador AS CHAR INIT ';' NO-UNDO.
DEF STREAM Reporte.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-desde FILL-IN-hasta FILL-IN-ruta ~
BUTTON-2 RADIO-SET-tipo BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-desde FILL-IN-hasta FILL-IN-ruta ~
RADIO-SET-tipo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Generar reporte" 
     SIZE 18 BY 1.12.

DEFINE BUTTON BUTTON-2 
     LABEL "..." 
     SIZE 4 BY .92.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-ruta AS CHARACTER FORMAT "X(150)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .96 NO-UNDO.

DEFINE VARIABLE RADIO-SET-tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Texto", 1,
"Excel", 2
     SIZE 26 BY 1.15 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-desde AT ROW 1.96 COL 14 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-hasta AT ROW 1.96 COL 37.43 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-ruta AT ROW 4 COL 3.86 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     BUTTON-2 AT ROW 4.04 COL 56 WIDGET-ID 14
     RADIO-SET-tipo AT ROW 5.38 COL 20 NO-LABEL WIDGET-ID 8
     BUTTON-1 AT ROW 6.69 COL 21.29 WIDGET-ID 6
     "Ruta..." VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 3.35 COL 6 WIDGET-ID 16
          FGCOLOR 9 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62.43 BY 7.31
         FONT 3 WIDGET-ID 100.


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
         TITLE              = "Reporte de cobros realizados - contraentrega"
         HEIGHT             = 7.31
         WIDTH              = 62.43
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 88.57
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 88.57
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
ASSIGN 
       FILL-IN-ruta:READ-ONLY IN FRAME F-Main        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de cobros realizados - contraentrega */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de cobros realizados - contraentrega */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Generar reporte */
DO:
  RUN procesar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* ... */
DO:

    DEFINE VAR lDirectorio   AS CHAR.
  
        SYSTEM-DIALOG GET-DIR lDirectorio  
           RETURN-TO-START-DIR 
           TITLE 'Directorio Files'.

        IF lDirectorio > "" THEN DO :
           fill-in-ruta:SCREEN-VALUE = lDirectorio.
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
  DISPLAY FILL-IN-desde FILL-IN-hasta FILL-IN-ruta RADIO-SET-tipo 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-desde FILL-IN-hasta FILL-IN-ruta BUTTON-2 RADIO-SET-tipo 
         BUTTON-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generar-txt W-Win 
PROCEDURE generar-txt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-Archivo AS CHAR.
DEFINE VAR cFecha AS CHAR.

cDelimitador = "|".

x-Archivo = fill-in-ruta + "\CobranzasTXT.txt".

OUTPUT STREAM Reporte TO VALUE(x-Archivo).

PUT STREAM Reporte UNFORMATTED
    "Fecha Registro" cDelimitador
    "Nro Ruta" cDelimitador
    "Nro Placa" cDelimitador
    "Responsable" cDelimitador
    "Cliente" cDelimitador
    "Importe de la venta (S/)" cDelimitador
    "Importe cobrado (S/)" cDelimitador
    "Tienda Origen" cDelimitador
    "Sede" cDelimitador SKIP.

FOR EACH tData NO-LOCK:

    cFecha = STRING(tData.fecha,"99/99/9999").
    cFecha = ENTRY(3,cFecha,"/") + "-" + ENTRY(2,cFecha,"/") + "-" + ENTRY(1,cFecha,"/").

    PUT STREAM Reporte UNFORMATTED
    cFecha cDelimitador
    trim(tData.nruta) cDelimitador
    trim(tData.nplaca) cDelimitador
    trim(tData.dresponsable) cDelimitador
    trim(tData.dcliente) cDelimitador
    tData.ixcobrar cDelimitador
    tData.icobrado cDelimitador
    trim(tData.dtiendaorigen) cDelimitador
    trim(tData.dsede) cDelimitador SKIP.

END.
OUTPUT STREAM Reporte CLOSE.



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
      FILL-in-desde:SCREEN-VALUE = STRING(TODAY - 7,"99/99/9999").
      FILL-in-hasta:SCREEN-VALUE = STRING(TODAY,"99/99/9999").
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar W-Win 
PROCEDURE procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fill-in-desde fill-in-hasta radio-set-tipo fill-in-ruta.
END.

IF fill-in-desde = ? OR fill-in-hasta = ? THEN DO:
    MESSAGE "Debe ingresar fechas correctas" VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

IF fill-in-desde > fill-in-hasta THEN DO:
    MESSAGE "Las fechas estan incorrectas" VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

IF TRUE <> (fill-in-ruta > "") THEN DO:
    MESSAGE "Ingrese la ruta donde alojar el archivo" VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

RUN recupera-data.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recupera-data W-Win 
PROCEDURE recupera-data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
DEFINE TEMP-TABLE tData
    FIELD   fecha           AS DATE    COLUMN-LABEL "Fecha Registro"
    FIELD   nruta           AS CHAR    FORMAT 'x(10)' COLUMN-LABEL "Hoja de ruta"
    FIELD   nplaca          AS CHAR    FORMAT 'x(10)' COLUMN-LABEL "Nro de Placa"
    FIELD   dresponsable    AS CHAR    FORMAT 'x(100)' COLUMN-LABEL "Responsable del reparto"
    FIELD   dcliente        AS CHAR    FORMAT 'x(100)' COLUMN-LABEL "Cliente"
    FIELD   ixcobrar        AS DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Importe de/los comprobantes"
    FIELD   icobrado        AS DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Importe cobrado"
    FIELD   dtiendaorigen   AS CHAR    FORMAT 'x(100)' COLUMN-LABEL "Tienda origen"
    FIELD   dsede           AS CHAR    FORMAT 'x(100)' COLUMN-LABEL "Sede".
*/

DEFINE VAR cTdaOrigen AS CHAR.
DEFINE VAR cSede AS CHAR.
DEFINE VAR dResponsable AS CHAR.

DEFINE VAR iConteo AS INT.

SESSION:SET-WAIT-STATE("GENERAL").

DEFINE BUFFER b-gn-divi FOR gn-divi.

EMPTY TEMP-TABLE tData.

FOR EACH cobranza_hr WHERE cobranza_hr.flgest = 'C' AND 
                            (cobranza_hr.fregistro >= fill-in-desde AND cobranza_hr.fregistro <= fill-in-hasta)
                            NO-LOCK, 
                    FIRST di-rutaC WHERE di-rutaC.codcia = 1 AND di-rutaC.coddoc = 'H/R' AND di-rutaC.nrodoc = cobranza_hr.nruta,
                    FIRST gn-divi OF di-rutaC NO-LOCK,
                    EACH cobranza_hr_cliente NO-LOCK,
                    FIRST gn-clie WHERE gn-clie.codcia = 0 AND gn-clie.codcli = cobranza_hr_cliente.ccliente NO-LOCK:
  
    dResponsable = "".
    FIND FIRST pl-pers WHERE pl-pers.nrodocid = di-rutaC.responsable NO-LOCK NO-ERROR.
    IF AVAILABLE pl-pers THEN dResponsable = pl-pers.patper + " " + pl-pers.matper + " " + pl-pers.nomper.

    cTdaOrigen = "".
    DATOS:
    FOR EACH cobranza_hr_cmpte WHERE cobranza_hr_cmpte.nruta = cobranza_hr.nruta NO-LOCK, 
        FIRST ccbcdocu WHERE ccbcdocu.codcia = 1 AND ccbcdocu.coddoc = cobranza_hr_cmpte.ccomprobante AND
                            ccbcdocu.nrodoc = cobranza_hr_cmpte.ncomprobante NO-LOCK,
        FIRST b-gn-divi WHERE b-gn-divi.codcia = 1 AND b-gn-divi.coddiv = ccbcdocu.divori NO-LOCK:
        cTdaOrigen = b-gn-divi.desdiv.
        LEAVE DATOS.
    END.

    iConteo = iConteo + 1.

    CREATE tData.
        ASSIGN tData.fecha = cobranza_hr.fregistro
            tData.nruta = cobranza_hr.nruta
            tData.nplaca = di-rutaC.codVeh
            tData.dresponsable = dResponsable
            tData.dcliente = gn-clie.nomcli
            tData.ixcobrar = cobranza_hr_cliente.icobrarsoles
            tData.icobrado = cobranza_hr_cliente.iefectivosoles + cobranza_hr_cliente.ibilleteraelectrosoles + cobranza_hr_cliente.idepobancariosoles
            tData.dtiendaorigen = cTdaOrigen
            tData.dsede = gn-divi.desdiv.


END.

IF radio-set-tipo = 2 THEN DO:
    SESSION:SET-WAIT-STATE("").

    DEFINE VAR hProc AS HANDLE NO-UNDO.

    RUN lib\Tools-to-excel PERSISTENT SET hProc.

    def var c-csv-file as char no-undo.
    def var c-xls-file as char no-undo. /* will contain the XLS file path created */

    c-xls-file = fill-in-ruta + "\Cobranzas.xlsx".

    run pi-crea-archivo-csv IN hProc (input  buffer tdata:handle,
                            /*input  session:temp-directory + "file"*/ c-xls-file,
                            output c-csv-file) .

    run pi-crea-archivo-xls  IN hProc (input  buffer tdata:handle,
                            input  c-csv-file,
                            output c-xls-file) .

    DELETE PROCEDURE hProc.

    MESSAGE "Reporte terminado" SKIP
            c-xls-file
        VIEW-AS ALERT-BOX INFORMATION.

END.
ELSE DO:
    RUN generar-txt.
END.

SESSION:SET-WAIT-STATE("").

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

