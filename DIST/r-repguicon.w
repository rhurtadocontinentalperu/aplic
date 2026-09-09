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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE STREAM REPORT.

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE tt-datos
    FIELDS fchate AS DATE
    FIELDS nrodoc AS CHAR
    FIELDS nroref AS CHAR
    FIELDS nroruc AS CHAR
    FIELDS nomcli AS CHAR
    FIELDS dirpar AS CHAR
    FIELDS dirlle AS CHAR
    FIELDS tpofac AS CHAR
    FIELDS desmat AS CHAR
    FIELDS candes AS DEC.

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
&Scoped-Define ENABLED-OBJECTS cb-divi f-desde f-hasta BUTTON-3 BUTTON-1 ~
BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS cb-divi FILL-IN-1 f-desde f-hasta txt-msje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 10 BY 1.5.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 2" 
     SIZE 10 BY 1.5.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img\tbldat":U
     LABEL "Button 3" 
     SIZE 10 BY 1.5.

DEFINE VARIABLE cb-divi AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .92 NO-UNDO.

DEFINE VARIABLE txt-msje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 69 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cb-divi AT ROW 1.54 COL 9 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-1 AT ROW 1.54 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     f-desde AT ROW 3.15 COL 9 COLON-ALIGNED WIDGET-ID 6
     f-hasta AT ROW 3.15 COL 36 COLON-ALIGNED WIDGET-ID 8
     txt-msje AT ROW 5.04 COL 3 NO-LABEL WIDGET-ID 10
     BUTTON-3 AT ROW 6.38 COL 35 WIDGET-ID 16
     BUTTON-1 AT ROW 6.38 COL 46.43 WIDGET-ID 12
     BUTTON-2 AT ROW 6.38 COL 58 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72 BY 7.92 WIDGET-ID 100.


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
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 7.92
         WIDTH              = 72
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-msje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
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
    ASSIGN
        cb-divi
        f-desde
        f-hasta.
    RUN Excel.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    ASSIGN
        cb-divi
        f-desde
        f-hasta.
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
DEFINE VARIABLE cDir AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNom AS CHARACTER   NO-UNDO.

DEFINE BUFFER b-alm FOR almacen.

FOR EACH ccbcdocu USE-INDEX llave10
    WHERE ccbcdocu.codcia = s-codcia
    AND (ccbcdocu.coddiv = cb-divi
         OR cb-divi = "todos")
    AND ccbcdocu.coddoc = 'G/R'
    AND ccbcdocu.fchdoc >= f-desde 
    AND ccbcdocu.fchdoc <= f-hasta
    AND ccbcdocu.flgest <> "A" NO-LOCK,
    EACH ccbddocu OF ccbcdocu NO-LOCK,
        FIRST almmmatg WHERE almmmatg.codcia = s-codcia
            AND almmmatg.codmat = ccbddocu.codmat NO-LOCK:

    /*Busca Direccion*/
    FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia
        AND gn-divi.coddiv = ccbcdocu.coddiv NO-LOCK NO-ERROR.
    IF AVAIL gn-divi THEN cDir = GN-DIVI.DirDiv.
    ELSE cDir = ''.

    CREATE tt-datos.
    ASSIGN 
        tt-datos.fchate = ccbcdocu.fchdoc
        tt-datos.nrodoc = CcbcDocu.NroDoc
        tt-datos.nroref = ccbcdocu.CodRef + "-" + ccbcdocu.nroref
        tt-datos.nroruc = ccbcdocu.ruc
        tt-datos.nomcli = ccbcdocu.nomcli
        tt-datos.dirpar = cDir
        tt-datos.dirlle = ccbcdocu.dircli
        tt-datos.tpofac = "V"
        tt-datos.desmat = ccbddocu.codmat + "-" + almmmatg.desmat
        tt-datos.candes = ccbddocu.candes.
    PAUSE 0.
    DISPLAY "PROCESANDO: " + Ccbcdocu.coddoc + "-" + ccbcdocu.nrodoc @ TXT-MSJE
        WITH FRAME {&FRAME-NAME}.
END.

/*Guias De Transferencia*/
FOR EACH almacen WHERE almacen.codcia = s-codcia
    AND almacen.coddiv = cb-divi NO-LOCK,
    EACH almcmov WHERE almcmov.codcia = almacen.codcia
        AND almcmov.codalm = almacen.codalm
        AND almcmov.tipmov = 'S'
        AND almcmov.codmov = 03
        AND almcmov.flgest <> "A"
        AND almcmov.nroser <> 000
        AND almcmov.fchdoc >= f-desde
        AND almcmov.fchdoc <= f-hasta NO-LOCK,
        EACH almdmov OF almcmov NO-LOCK,
        FIRST almmmatg OF almdmov NO-LOCK:

        cDir = Almacen.DirAlm.
        FIND FIRST b-alm WHERE b-alm.codcia = s-codcia
            AND b-alm.codalm = almcmov.almdes NO-LOCK NO-ERROR.
        IF AVAIL b-alm THEN 
            ASSIGN 
                cDir = b-alm.DirAlm
                cNom = b-alm.codalm + "-" + b-alm.Descripcion. 
        ELSE 
            ASSIGN 
                cDir = ''
                cNom = ''.
    
        CREATE tt-datos.
        ASSIGN 
            tt-datos.fchate = almcmov.fchdoc
            tt-datos.nrodoc = STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"999999")
            tt-datos.nroref = ""
            tt-datos.nroruc = ""
            tt-datos.nomcli = cNom
            tt-datos.dirpar = Almacen.DirAlm
            tt-datos.dirlle = cDir
            tt-datos.tpofac = "T"
            tt-datos.desmat = almdmov.codmat + "-" + almmmatg.desmat
            tt-datos.candes = Almdmov.CanDes.
        PAUSE 0.
        DISPLAY "PROCESANDO: " + STRING(almcmov.nrodoc,"999999") @ TXT-MSJE
            WITH FRAME {&FRAME-NAME}.
END.

/*Guias por ingreso de proveedor*/
FOR EACH almacen WHERE almacen.codcia = s-codcia
    AND almacen.coddiv = cb-divi NO-LOCK,
    EACH almcmov WHERE almcmov.codcia = almacen.codcia
        AND almcmov.codalm = almacen.codalm
        AND almcmov.tipmov = 'S'
        AND almcmov.codmov = 09
        AND almcmov.flgest <> "A"
        AND almcmov.nroser <> 000   
        AND almcmov.fchdoc >= f-desde
        AND almcmov.fchdoc <= f-hasta NO-LOCK,
        EACH almdmov OF almcmov NO-LOCK,
        FIRST almmmatg OF almdmov NO-LOCK:

        cDir = Almacen.DirAlm.
        FIND FIRST b-alm WHERE b-alm.codcia = s-codcia
            AND b-alm.codalm = almcmov.almdes NO-LOCK NO-ERROR.
        IF AVAIL b-alm THEN 
            ASSIGN 
                cDir = b-alm.DirAlm
                cNom = b-alm.codalm + "-" + b-alm.Descripcion. 
        ELSE 
            ASSIGN 
                cDir = ''
                cNom = ''.
    
        CREATE tt-datos.
        ASSIGN 
            tt-datos.fchate = almcmov.fchdoc
            tt-datos.nrodoc = STRING(almcmov.nroser,"999") + STRING(almcmov.nrodoc,"999999")
            tt-datos.nroref = ""
            tt-datos.nroruc = ""
            tt-datos.nomcli = cNom
            tt-datos.dirpar = Almacen.DirAlm
            tt-datos.dirlle = cDir
            tt-datos.tpofac = "D"
            tt-datos.desmat = almdmov.codmat + "-" + almmmatg.desmat
            tt-datos.candes = Almdmov.CanDes.
        PAUSE 0.
        DISPLAY "PROCESANDO: " + STRING(almcmov.nrodoc,"999999") @ TXT-MSJE
            WITH FRAME {&FRAME-NAME}.
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
  DISPLAY cb-divi FILL-IN-1 f-desde f-hasta txt-msje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE cb-divi f-desde f-hasta BUTTON-3 BUTTON-1 BUTTON-2 
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 1.

DEFINE VARIABLE cDir AS CHARACTER   NO-UNDO.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

RUN Carga-Temporal.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("B2"):Value = "REPORTE DE GUIAS REMITENTE".

chWorkSheet:Range("A3"):Value = "FECHA INICIO TRASLADO".
chWorkSheet:Range("B3"):Value = "SERIE Y N° GUIA CORRELATIVO".
chWorkSheet:Range("C3"):Value = "N° COMPROBANTE".
chWorkSheet:Range("D3"):Value = "RUC DESTINATARIO".
chWorkSheet:Range("E3"):Value = "NOMBRE DESTINATARIO".
chWorkSheet:Range("F3"):Value = "PUNTO DE PARTIDA".
chWorkSheet:Range("G3"):Value = "PUNTO DE LLEGADA".
chWorkSheet:Range("H3"):Value = "MOTIVO DE TRASLADO".
chWorkSheet:Range("I3"):Value = "DETALLE ARTICULO".
chWorkSheet:Range("J3"):Value = "CANTIDAD".

t-column = 3.

FOR EACH tt-datos NO-LOCK:    
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-datos.fchate.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-datos.NroDoc.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-datos.nroref.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + tt-datos.nroruc.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-datos.nomcli.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-datos.dirpar.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-datos.dirlle.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-datos.tpofac.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-datos.desmat.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = tt-datos.candes.

    PAUSE 0.
    DISPLAY "PROCESANDO: " + tt-datos.nrodoc @ TXT-MSJE
        WITH FRAME {&FRAME-NAME}.
END.

DISPLAY "PROCESO TERMINADO" @ TXT-MSJE WITH FRAME {&FRAME-NAME}.

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

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

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH gn-divi WHERE gn-divi.codcia = s-codcia NO-LOCK:
          cb-divi:ADD-LAST(gn-divi.coddiv).          
      END.
/*       ASSIGN cb-divi = s-coddiv. */
/*       DISPLAY cb-divi.           */
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR x-Archivo AS CHAR NO-UNDO.
  DEF VAR x-Rpta    AS LOG  NO-UNDO.
  DEF VAR x-CodDoc  AS CHAR NO-UNDO.

  DEFINE VAR Titulo1 AS CHAR FORMAT "X(230)".
  DEFINE VAR Titulo2 AS CHAR FORMAT "X(230)".
  DEFINE VAR Titulo3 AS CHAR FORMAT "X(230)".
  DEFINE VAR VAN     AS DECI EXTENT 10.
  DEFINE VAR X-LLAVE AS LOGICAL.
  DEFINE VAR x-NroSer AS CHAR.
  DEFINE VAR x-NroDoc AS CHAR.
  DEFINE VAR x-SerRef AS CHAR.
  DEFINE VAR x-NroRef AS CHAR.
 
  x-Archivo = 'Guias' + cb-divi + '.txt'.
  SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Texto' '*.txt'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.txt'
    INITIAL-DIR 'c:\tmp'
    RETURN-TO-START-DIR 
    USE-FILENAME
    SAVE-AS
    UPDATE x-rpta.
  IF x-rpta = NO THEN RETURN.

  RUN Carga-Temporal.

  DEFINE FRAME f-cab
      tt-datos.fchate    COLUMN-LABEL "Fecha de!Emisión" FORMAT "99/99/9999"
      tt-datos.nrodoc    COLUMN-LABEL "Nro Doc"          FORMAT 'x(15)'
      tt-datos.nroref    COLUMN-LABEL "Nro Ref"          FORMAT 'x(15)'
      tt-datos.nroruc    COLUMN-LABEL "Nro.!R.U.C."      FORMAT "X(15)"
      tt-datos.NomCli    COLUMN-LABEL "C L I E N T E"    FORMAT "X(50)"
      tt-datos.Dirpar    COLUMN-LABEL "Punto de!Partida" FORMAT "X(40)"
      tt-datos.Dirlle    COLUMN-LABEL "Punto de!Llegada" FORMAT "X(40)"
      tt-datos.TpoFac    COLUMN-LABEL "Motivo!Traslad"   FORMAT "X(10)"
      tt-datos.DesMat    COLUMN-LABEL "Descripcion"      FORMAT "X(40)"
      tt-datos.CanDes    COLUMN-LABEL "Cantidad"         FORMAT ">>>>>>>>9.99"
      WITH WIDTH 300 NO-BOX STREAM-IO DOWN.


  OUTPUT STREAM REPORT TO VALUE(x-Archivo).
  FOR EACH tt-datos NO-LOCK:
      DISPLAY STREAM REPORT  
          tt-datos.fchate 
          tt-datos.nrodoc 
          tt-datos.nroref 
          tt-datos.nroruc 
          tt-datos.NomCli 
          tt-datos.Dirpar 
          tt-datos.Dirlle 
          tt-datos.TpoFac 
          tt-datos.DesMat 
          tt-datos.CanDes 
          WITH FRAME F-CAB. 
  END.
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.
  
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

