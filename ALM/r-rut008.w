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

DEFINE TEMP-TABLE tdi-rutad LIKE di-rutad 
    FIELDS codcli LIKE gn-clie.codcli
    FIELDS nomcli LIKE gn-clie.nomcli
    FIELDS fchdoc AS   DATE
    FIELDS codveh LIKE di-rutac.codveh
    FIELDS desveh AS   CHAR
    FIELDS desest AS   CHAR
    FIELDS detest AS   CHAR
    FIELDS numrep AS   INT 
    FIELDS distrito AS CHAR
    FIELDS codped AS CHAR
    FIELDS nroped AS CHAR.

DEFINE BUFFER btemp FOR tdi-rutad.    
DEFINE BUFFER bdi-rutad FOR di-rutad.
DEFINE BUFFER bdi-rutac FOR di-rutac.

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR cl-codcia AS INT.

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
&Scoped-Define ENABLED-OBJECTS x-desde x-hasta x-numero BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS x-desde x-hasta x-numero x-mensaje 

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
     SIZE 7 BY 1.62.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 2" 
     SIZE 7 BY 1.62.

DEFINE VARIABLE x-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 71 BY 1
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE x-numero AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Nro Salidas" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-desde AT ROW 2.35 COL 19 COLON-ALIGNED WIDGET-ID 2
     x-hasta AT ROW 2.35 COL 42 COLON-ALIGNED WIDGET-ID 4
     x-numero AT ROW 3.69 COL 19 COLON-ALIGNED WIDGET-ID 6
     x-mensaje AT ROW 5.58 COL 2 NO-LABEL WIDGET-ID 12
     BUTTON-1 AT ROW 6.92 COL 57 WIDGET-ID 8
     BUTTON-2 AT ROW 6.92 COL 65 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 73.14 BY 8.46 WIDGET-ID 100.


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
         TITLE              = "Documentos Repetidos - HR"
         HEIGHT             = 8.46
         WIDTH              = 73.14
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
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Documentos Repetidos - HR */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Documentos Repetidos - HR */
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
    ASSIGN x-desde x-hasta x-numero.
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
    
    DEFINE VARIABLE iInt     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE x-estado AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-motivo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-marca  AS CHARACTER   NO-UNDO.

    FOR EACH tdi-rutad:
        DELETE tdi-rutad.
    END.

    FOR EACH di-rutac WHERE di-rutac.codcia = s-codcia
        AND di-rutac.coddiv = s-coddiv
        AND di-rutac.fchdoc >= x-desde
        AND di-rutac.fchdoc <= x-hasta 
        AND di-rutac.flgest <> "A" NO-LOCK,
        EACH di-rutad OF di-rutac   
            /* WHERE di-rutad.codref = "FAC"
            AND di-rutad.nroref = "002298799" */ NO-LOCK:

        FIND FIRST tdi-rutad WHERE tdi-rutad.codcia = di-rutad.codcia
            AND tdi-rutad.coddoc = di-rutac.coddoc
            AND tdi-rutad.nrodoc = di-rutac.nrodoc
            AND tdi-rutad.codref = di-rutad.codref
            AND tdi-rutad.nroref = di-rutad.nroref NO-ERROR.
        IF NOT AVAIL tdi-rutad THEN DO:
            /*MESSAGE di-rutad.nrodoc.*/
            RUN alm/f-flgrut ("D", Di-RutaD.flgest, OUTPUT x-Estado).
            x-motivo = "".
            IF Di-RutaD.flgest = "N" THEN DO:
                /*Motivo de Devolucion*/
                FIND AlmTabla WHERE AlmTabla.Tabla = 'HR'
                    AND AlmTabla.Codigo = DI-RutaD.FlgEstDet
                    AND almtabla.NomAnt = 'N' NO-LOCK NO-ERROR.
                IF AVAILABLE AlmTabla THEN x-motivo = almtabla.Nombre.
            END.

            FIND FIRST gn-vehic WHERE gn-vehic.CodCia = s-codcia
                AND gn-vehic.placa = di-rutac.codveh NO-LOCK NO-ERROR.
            IF AVAIL gn-vehic THEN x-marca = gn-vehic.Marca.
            ELSE x-marca = "".

            CREATE tdi-rutad.
            BUFFER-COPY di-rutad TO tdi-rutad.
            ASSIGN 
                tdi-rutad.fchdoc = di-rutac.fchdoc
                tdi-rutad.codveh = di-rutac.codveh
                tdi-rutad.desveh = x-marca
                tdi-rutad.desest = x-estado
                tdi-rutad.detest = x-motivo.

            FIND ccbcdocu WHERE ccbcdocu.codcia = s-codcia
                AND ccbcdocu.coddoc = di-rutad.codref
                AND ccbcdocu.nrodoc = di-rutad.nroref
                NO-LOCK NO-ERROR.
            IF AVAILABLE ccbcdocu THEN DO:
                ASSIGN
                    tdi-rutad.codped = ccbcdocu.codped
                    tdi-rutad.nroped = ccbcdocu.nroped.
                FIND gn-clie WHERE gn-clie.codcia = cl-codcia
                    AND gn-clie.codcli = ccbcdocu.codcli
                    NO-LOCK NO-ERROR.
                IF AVAILABLE gn-clie THEN DO:
                    FIND TabDistr WHERE TabDistr.CodDepto = gn-clie.coddept
                        AND TabDistr.CodProvi = gn-clie.codprov
                        AND TabDistr.CodDistr = gn-clie.coddist
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE tabDistr THEN tdi-rutad.distrito = TabDistr.NomDistr.
                END.
            END.
        END.

        /*Busca Repeticiones*/
        FOR EACH bdi-rutad WHERE bdi-rutad.codcia = s-codcia
            AND bdi-rutac.coddiv = s-coddiv
            AND bdi-rutad.coddoc = di-rutad.coddoc
            AND bdi-rutad.nrodoc <> di-rutad.nrodoc
            AND bdi-rutad.codref = di-rutad.codref
            AND bdi-rutad.nroref = di-rutad.nroref NO-LOCK,
            EACH bdi-rutac OF bdi-rutad 
                WHERE bdi-rutac.flgest <> "A" NO-LOCK:
            FIND FIRST tdi-rutad WHERE tdi-rutad.codcia = bdi-rutad.codcia
                AND tdi-rutad.coddoc = bdi-rutac.coddoc
                AND tdi-rutad.nrodoc = bdi-rutac.nrodoc
                AND tdi-rutad.codref = bdi-rutad.codref
                AND tdi-rutad.nroref = bdi-rutad.nroref NO-ERROR.
            IF NOT AVAIL tdi-rutad THEN DO:
                /*MESSAGE bdi-rutad.nrodoc.*/
                RUN alm/f-flgrut ("D", Di-RutaD.flgest, OUTPUT x-Estado).

                /*Motivo de Devolucion*/
                FIND AlmTabla WHERE AlmTabla.Tabla = 'HR'
                    AND AlmTabla.Codigo = DI-RutaD.FlgEstDet
                    AND almtabla.NomAnt = 'N' NO-LOCK NO-ERROR.
                IF AVAILABLE AlmTabla THEN x-motivo = almtabla.Nombre.

                FIND FIRST gn-vehic WHERE gn-vehic.CodCia = s-codcia
                    AND gn-vehic.placa = di-rutac.codveh NO-LOCK NO-ERROR.
                IF AVAIL gn-vehic THEN x-marca = gn-vehic.Marca.
                ELSE x-marca = "".

                CREATE tdi-rutad.
                BUFFER-COPY bdi-rutad TO tdi-rutad.
                ASSIGN 
                    tdi-rutad.fchdoc = di-rutac.fchdoc
                    tdi-rutad.codveh = di-rutac.codveh
                    tdi-rutad.desveh = x-marca
                    tdi-rutad.desest = x-estado
                    tdi-rutad.detest = x-motivo.
            END.
        END.
        DISPLAY "CARGANDO: " + di-rutad.coddoc + "-" + di-rutad.nrodoc @ x-mensaje
            WITH FRAME {&FRAME-NAME}.
    END.

    /*Busca Repeticiones*/
    FOR EACH tdi-rutad :
        iInt = 0.
        FOR EACH btemp WHERE btemp.codcia = tdi-rutad.codcia
            AND btemp.codref = tdi-rutad.codref
            AND btemp.nroref = tdi-rutad.nroref NO-LOCK:
            iInt = iInt + 1.
        END.
        ASSIGN tdi-rutad.numrep = iInt.

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
  DISPLAY x-desde x-hasta x-numero x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-desde x-hasta x-numero BUTTON-1 BUTTON-2 
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

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    DEFINE VARIABLE cCodCli AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cNomCli AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dImpTot AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE cCodMon AS CHARACTER   NO-UNDO.

    RUN Carga-Temporal.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /*Formato de Celda*/
    chWorkSheet:Columns("B"):NumberFormat = "@".
    chWorkSheet:Columns("D"):NumberFormat = "@".
    chWorkSheet:Columns("J"):NumberFormat = "@".

    /* Encabezado */    
    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Codigo".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Número H/R".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod. Documento".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nº Documento".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod. Pedido".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Nº Pedido".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cod Cliente".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cliente".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Distrito".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha Documento".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "Moneda".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Importe".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = "Placa".
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = "Marca".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = "Estado".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = "Motivo".
    
    FOR EACH tdi-rutad NO-LOCK
        WHERE tdi-rutad.numrep >= x-numero
        BREAK BY tdi-rutad.codref
            BY tdi-rutad.nroref:

        FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia
            AND ccbcdocu.coddoc = TDI-RutaD.CodRef
            AND ccbcdocu.nrodoc = TDI-RutaD.NroRef NO-LOCK NO-ERROR.
        IF AVAIL ccbcdocu THEN DO:
            cCodCli = ccbcdocu.codcli.
            cNomCli = ccbcdocu.nomcli.
            dImpTot = ccbcdocu.imptot.
            IF ccbcdocu.codmon = 1 THEN cCodMon = "S/.".
            ELSE cCodMon = "$".
        END.

        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = TDI-RutaD.CodDoc. 
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = TDI-RutaD.NroDoc .
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = TDI-RutaD.CodRef .
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = TDI-RutaD.NroRef.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = TDI-RutaD.CodPed.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = TDI-RutaD.NroPed.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = cCodCli.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = cNomCli.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = TDI-RutaD.Distrito.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = TDI-RutaD.FchDoc.
        cRange = "K" + cColumn.       
        chWorkSheet:Range(cRange):Value = cCodMon.
        cRange = "L" + cColumn.       
        chWorkSheet:Range(cRange):Value = dImpTot.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = TDI-RutaD.CodVeh.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = TDI-RutaD.DesVeh.
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = TDI-RutaD.DesEst.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = TDI-RutaD.DetEst.

        DISPLAY "CARGANDO EXCEL .... "  @ x-mensaje
            WITH FRAME {&FRAME-NAME}.
    END.

  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  DISPLAY "" @ x-mensaje
      WITH FRAME {&FRAME-NAME}.

  MESSAGE 'Proceso Terminado'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.


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
      ASSIGN
          x-desde = (TODAY - DAY(TODAY)) + 1
          x-hasta = TODAY.
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

