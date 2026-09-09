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


DEFINE BUFFER bFaccpedi FOR faccpedi.

DEFINE TEMP-TABLE tFaccpedi LIKE faccpedi.

DEFINE TEMP-TABLE tApiJson
    FIELD   tKey    AS  CHAR    FORMAT 'x(100)'
    FIELD   tValue  AS  CHAR    FORMAT 'x(255)'.

DEFINE TEMP-TABLE tData
    FIELD   tCoddoc     AS  CHAR    FORMAT 'x(5)'   COLUMN-LABEL "Cod.Comercial"
    FIELD   tNrodoc     AS  CHAR    FORMAT 'x(15)'   COLUMN-LABEL "Nro.Pedido Comercial"
    FIELD   tfchdoc     AS  DATE    COLUMN-LABEL "Fecha Pedido Comercial"
    FIELD   timpdoc     AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Importe Pedido Comercial"
    FIELD   tcoddiv     AS  CHAR    FORMAT 'x(8)'   COLUMN-LABEL "Division comercial"
    FIELD   tnumorder   AS  CHAR    FORMAT 'x(15)'   COLUMN-LABEL "RIQRA : Pedido"
    FIELD   tCodlog     AS  CHAR    FORMAT 'x(5)'   COLUMN-LABEL "Cod.Logistico"
    FIELD   tNrolog     AS  CHAR    FORMAT 'x(15)'   COLUMN-LABEL "Nro.Pedido Logistico"
    FIELD   tfchlog     AS  DATE    COLUMN-LABEL "Fecha Pedido Logistico"
    FIELD   timplog     AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Importe Pedido Logistico"
    FIELD   tFlglog     AS  CHAR    FORMAT 'x(15)'   COLUMN-LABEL "Flag estado Pedido Logistico"
    FIELD   tCodcmpte     AS  CHAR    FORMAT 'x(5)'   COLUMN-LABEL "Cod.Comprobante"
    FIELD   tNrocmpte     AS  CHAR    FORMAT 'x(15)'   COLUMN-LABEL "Nro.Comprobante"
    FIELD   tfchcmpte     AS  DATE    COLUMN-LABEL "Fecha Comprobante"
    FIELD   timpcmpte     AS  DEC     FORMAT '->>,>>>,>>9.99' COLUMN-LABEL "Importe Comprobante"
    FIELD   tFlgCmpte     AS  CHAR    FORMAT 'x(15)'   COLUMN-LABEL "Flag estado Comprobante"
    FIELD   tpayname        AS  CHAR    FORMAT 'x(150)'   COLUMN-LABEL "RIQRA : Tipo forma de pago"
    FIELD   ttransactionid  AS  CHAR    FORMAT 'x(50)'   COLUMN-LABEL "RIQRA : TransactionID"
    FIELD   ttype           AS  CHAR    FORMAT 'x(25)'   COLUMN-LABEL "RIQRA : Tipo"
    FIELD   tprovider       AS  CHAR    FORMAT 'x(50)'   COLUMN-LABEL "RIQRA : Proveedor"

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-desde FILL-IN-hasta FILL-IN-division ~
BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-desde FILL-IN-hasta ~
FILL-IN-division 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Procesar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-desde AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-division AS CHARACTER FORMAT "X(8)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 13 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-desde AT ROW 2.08 COL 10 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-hasta AT ROW 2.08 COL 30 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-division AT ROW 3.31 COL 10 COLON-ALIGNED WIDGET-ID 8
     BUTTON-1 AT ROW 4.23 COL 57 WIDGET-ID 2
     "(vacio todos)" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 3.42 COL 25 WIDGET-ID 10
          FGCOLOR 12 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 4.88 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 4.88
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartWindowCues" W-Win _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartWindow,ab,49271
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Procesar */
DO:
  
    ASSIGN fill-in-desde fill-in-hasta fill-in-division.

    RUN procesar.

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
  DISPLAY FILL-IN-desde FILL-IN-hasta FILL-IN-division 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE FILL-IN-desde FILL-IN-hasta FILL-IN-division BUTTON-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endpoint-api W-Win 
PROCEDURE endpoint-api :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER cNumOrder AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER iIdEnviroment AS INT NO-UNDO.
DEFINE INPUT PARAMETER cUrl AS CHAR NO-UNDO.

/* El contenido de la web */
define var v-result as char no-undo.
define var v-response as LONGCHAR no-undo.
define var v-content as LONGCHAR no-undo.
define var cTexto as LONGCHAR no-undo.
define var cTexto1 as CHAR no-undo.

DEFINE VAR cValueTag AS CHAR.

DEFINE VAR cTagInicial AS CHAR.
DEFINE VAR cTagFinal AS CHAR.
DEFINE VAR posIni AS INT.
DEFINE VAR posFin AS INT.
DEFINE VAR posTexto AS INT.
DEFINE VAR posIni1 AS INT.
DEFINE VAR posFin1 AS INT.
DEFINE VAR posTexto1 AS INT.
DEFINE VAR Filer1 AS INT.

DEFINE VAR cKey AS CHAR.
DEFINE VAR cValue AS CHAR.

EMPTY TEMP-TABLE tApiJson.

cUrl = cUrl + "?numorder=" + cNumOrder + "&enviroment=" + STRING(iIdEnviroment).

RUN lib/http-get-contenido.r(cUrl,output v-result,output v-response,output v-content) NO-ERROR.
IF NOT (v-result = "1:Success" AND INDEX(v-response,"200 OK") > 0) THEN RETURN.

posIni = INDEX(v-content,'~{~n') + 1.
posFin = INDEX(v-content,'~}~n').
posTexto = posFin - posIni.

DO WHILE posTexto > 0:

    cTexto = SUBSTRING(v-content,posIni,posTexto).

    posIni1 = 1. 
    posFin1 = INDEX(cTexto,'~n',3).
    posTexto1 = posFin1 - posIni1.
    cTexto1 = SUBSTRING(cTexto,posIni1,posTexto1).

    REGISTROS:
    DO WHILE posTexto1 > 0:
        cKey = trim(ENTRY(1,cTexto1,":")).
        cKey = REPLACE(cKey,'~n',"").
        cKey = REPLACE(cKey,'"',"").

        cValue = TRIM(ENTRY(2,cTexto1,":")).
        cValue = REPLACE(cValue,'",',"").
        cValue = REPLACE(cValue,'null,',"").
        cValue = REPLACE(cValue,"\u00e9","e").
        cValue = REPLACE(cValue,"\u00ed","i").

        IF SUBSTRING(cValue,1,1) = '"' THEN cValue = SUBSTRING(cValue,2).        

        filer1 = r-index(cValue,",").
        IF filer1 > 1 THEN do:
            filer1 = filer1 - 1.
            cValue = SUBSTRIN(cValue,1,filer1).
        END.
        
        /* Ultimo Tag */
        filer1 = r-index(cValue,'"').
        IF filer1 > 1 THEN do:
            filer1 = filer1 - 1.
            cValue = SUBSTRIN(cValue,1,filer1).
        END.
        
        CREATE tApiJson.
        ASSIGN tApiJson.tkey = cKey
                tApiJson.tvalue = cValue.

        cTexto = SUBSTRING(cTexto,posFin1).
        posIni1 = 1.
        posFin1 = INDEX(cTexto,'~n',3).
        posTexto1 = posFin1 - posIni1.
        cTexto1 = SUBSTRING(cTexto,posIni1,posTexto1).
        /*LEAVE REGISTROS.*/
    END.
    posTexto = -1.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  fill-in-desde:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY - 15,"99/99/9999").
  fill-in-hasta:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999").

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

DEFINE VAR cTabla AS CHAR INIT "CONFIG-WEB-SATELITE".
DEFINE VAR cLlave_c1 AS CHAR INIT "PEDIDO".

DEFINE VAR cUrl AS CHAR.

FIND FIRST vtatabla WHERE vtatabla.codcia = 1 AND 
                            vtatabla.tabla = cTabla AND
                            vtatabla.Llave_c1 = cLlave_c1 NO-LOCK NO-ERROR.
IF NOT AVAILABLE vtatabla THEN DO:
    MESSAGE "No existe config de URL" SKIP 
        "Tabla : CONFIG-WEB-SATELITE" SKIP
        "Llave_c1 : PEDIDO"
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
END.

cUrl = vtatabla.libre_C01.

SESSION:SET-WAIT-STATE("GENERAL").

DEFINE VAR lFlagPedComAdd AS LOG.
DEFINE VAR lFlagCmpteAdd AS LOG.

EMPTY TEMP-TABLE tfaccpedi.
       
FOR EACH faccpedi WHERE faccpedi.codcia = 1 and faccpedi.codorigen = 'RIQRA' NO-LOCK:
    IF faccpedi.coddoc <> "cot" THEN NEXT.
    IF NOT (faccpedi.fchped >= fill-in-desde AND faccpedi.fchped <= fill-in-hasta) THEN NEXT.
    IF faccpedi.flgest = 'A' THEN NEXT.
    IF fill-in-division <> "" AND fill-in-division <> faccpedi.coddiv THEN NEXT.
    CREATE tData.
        ASSIGN tData.tcoddoc = faccpedi.coddoc
                tData.tnrodoc = faccpedi.nroped
                tData.tfchdoc = faccpedi.fchped
                tData.timpdoc = faccpedi.imptot
                tData.tcoddiv = faccpedi.coddiv
                tData.tnumorder = faccpedi.ordcmp.

    lFlagPedComAdd = NO.
    /* Pedido Logistico */
    FOR EACH bfaccpedi WHERE bfaccpedi.codcia = 1 AND bfaccpedi.codref = faccpedi.coddoc AND bfaccpedi.nroref = faccpedi.nroped NO-LOCK:
        IF bfaccpedi.coddoc <> "PED" THEN NEXT.
        IF bfaccpedi.flgest = 'A' THEN NEXT.

        IF lFlagPedComAdd THEN DO:
            CREATE tData.
                ASSIGN tData.tcoddoc = faccpedi.coddoc
                        tData.tnrodoc = faccpedi.nroped
                        tData.tfchdoc = faccpedi.fchped
                        tData.timpdoc = faccpedi.imptot
                        tData.tcoddiv = faccpedi.coddiv
                        tData.tnumorder = faccpedi.ordcmp.
        END.
        ASSIGN tData.tcodlog = bfaccpedi.coddoc
                tData.tnrolog = bfaccpedi.nroped
                tData.tfchlog = bfaccpedi.fchped
                tData.timplog = bfaccpedi.imptot
                tData.tflglog = bfaccpedi.flgest.

        lFlagPedComAdd = YES.

        lFlagCmpteAdd = NO.
        /* Comprobantes */
        FOR EACH ccbcdocu WHERE ccbcdocu.codcia = 1 AND ccbcdocu.codped = bfaccpedi.coddoc AND ccbcdocu.nroped = bfaccpedi.nroped NO-LOCK:
            IF LOOKUP(ccbcdocu.coddoc,"FAC,BOL") = 0 THEN NEXT.
            IF lFlagCmpteAdd THEN DO:
                CREATE tData.
                    ASSIGN tData.tcoddoc = faccpedi.coddoc
                            tData.tnrodoc = faccpedi.nroped
                            tData.tfchdoc = faccpedi.fchped
                            tData.timpdoc = faccpedi.imptot
                            tData.tcoddiv = faccpedi.coddiv
                            tData.tnumorder = faccpedi.ordcmp.
                    ASSIGN tData.tcodlog = bfaccpedi.coddoc
                            tData.tnrolog = bfaccpedi.nroped
                            tData.tfchlog = bfaccpedi.fchped
                            tData.timplog = bfaccpedi.imptot
                            tData.tflglog = bfaccpedi.flgest.
            END.
            ASSIGN tData.tcodcmpte = ccbcdocu.coddoc
                    tData.tnrocmpte = ccbcdocu.nrodoc
                    tData.tfchcmpte = ccbcdocu.fchdoc
                    tData.timpcmpte = ccbcdocu.imptot
                    tData.tflgcmpte = ccbcdocu.flgest.

            lFlagCmpteAdd = YES.
        END.
    END.
END.

/***/
FOR EACH tData:
    RUN endpoint-api (tData.tnumorder, 14, cUrl).
    /**/
    FIND FIRST tApiJson WHERE tKey = "paymentname" NO-LOCK NO-ERROR.
    IF AVAILABLE tApiJson  THEN DO:
        ASSIGN tData.tpayname = CODEPAGE-CONVERT(tApiJson.tValue, SESSION:CHARSET, "utf-8").
    END.
    FIND FIRST tApiJson WHERE tKey = "paymenttransactionid" NO-LOCK NO-ERROR.
    IF AVAILABLE tApiJson  THEN DO:
        ASSIGN tData.ttransactionid = tApiJson.tValue.
    END.
    FIND FIRST tApiJson WHERE tKey = "paymenttype" NO-LOCK NO-ERROR.
    IF AVAILABLE tApiJson  THEN DO:
        ASSIGN tData.ttype = tApiJson.tValue.
    END.
    FIND FIRST tApiJson WHERE tKey = "paymentprovider" NO-LOCK NO-ERROR.
    IF AVAILABLE tApiJson  THEN DO:
        ASSIGN tData.tprovider = tApiJson.tValue.
    END.    
END.
/*
    FIELD   tpayname        AS  CHAR    FORMAT 'x(150)'   COLUMN-LABEL "RIQRA : Tipo forma de pago"
    FIELD   ttransactionid  AS  CHAR    FORMAT 'x(50)'   COLUMN-LABEL "RIQRA : TransactionID"
    FIELD   ttype           AS  CHAR    FORMAT 'x(25)'   COLUMN-LABEL "RIQRA : Tipo"
    FIELD   tprovider       AS  CHAR    FORMAT 'x(50)'   COLUMN-LABEL "RIQRA : Proveedor"

    FIELD   tKey    AS  CHAR    FORMAT 'x(100)'
    FIELD   tValue  AS  CHAR    FORMAT 'x(255)'.
  */
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */


c-xls-file = 'd:\xpciman\Riqra-ped-comercial.xlsx'.

run pi-crea-archivo-csv IN hProc (input  buffer tData:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tData:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.

SESSION:SET-WAIT-STATE("").

END PROCEDURE.
/*
*/

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

