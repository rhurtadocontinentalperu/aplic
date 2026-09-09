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
DEFINE SHARED VAR cl-codcia AS INT.

DEFINE TEMP-TABLE tmp-datos 
    FIELDS t-codalm LIKE almacen.codalm
    FIELDS t-coddoc LIKE ccbcdocu.coddoc
    FIELDS t-nrodoc LIKE ccbcdocu.nrodoc
    FIELDS t-codcli LIKE ccbcdocu.codcli
    FIELDS t-nomcli LIKE ccbcdocu.nomcli
    FIELDS t-fchdoc LIKE AlmDCdoc.Fecha 
    FIELDS t-Bultos LIKE AlmDCdoc.Bultos
    FIELDS t-Hora   LIKE AlmDCdoc.Hora
    FIELDS t-flag   AS CHAR
    FIELDS t-tipo   AS CHAR.

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
&Scoped-Define ENABLED-OBJECTS txt-codalm rs-tipo cb-CodDoc txt-Desde ~
txt-Hasta txt-CodCli BUTTON-2 BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS txt-codalm rs-tipo cb-CodDoc txt-Desde ~
txt-Hasta txt-CodCli txt-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 10 BY 1.88.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 3" 
     SIZE 10 BY 1.88.

DEFINE VARIABLE cb-CodDoc AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Documento" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos","FAC","BOL","G/R" 
     DROP-DOWN-LIST
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE txt-codalm AS CHARACTER FORMAT "X(3)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE txt-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-Desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-Hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57.14 BY 1
     FONT 0 NO-UNDO.

DEFINE VARIABLE rs-tipo AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Salida", "S",
"Ingreso", "I"
     SIZE 22 BY 1.08 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-codalm AT ROW 2.08 COL 19 COLON-ALIGNED WIDGET-ID 6
     rs-tipo AT ROW 3.19 COL 21 NO-LABEL WIDGET-ID 2
     cb-CodDoc AT ROW 4.35 COL 19 COLON-ALIGNED WIDGET-ID 16
     txt-Desde AT ROW 5.58 COL 19 COLON-ALIGNED WIDGET-ID 8
     txt-Hasta AT ROW 5.58 COL 45.86 COLON-ALIGNED WIDGET-ID 12
     txt-CodCli AT ROW 6.62 COL 19 COLON-ALIGNED WIDGET-ID 10
     BUTTON-2 AT ROW 8 COL 61 WIDGET-ID 14
     BUTTON-3 AT ROW 8 COL 71 WIDGET-ID 20
     txt-mensaje AT ROW 8.58 COL 2.86 NO-LABEL WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 9.5 WIDGET-ID 100.


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
         TITLE              = "Reporte Control Documentario"
         HEIGHT             = 9.5
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN txt-mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte Control Documentario */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte Control Documentario */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  
    ASSIGN 
        cb-CodDoc rs-tipo txt-codalm txt-CodCli txt-Desde txt-Hasta.
    RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
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


&Scoped-define SELF-NAME cb-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-CodDoc W-Win
ON VALUE-CHANGED OF cb-CodDoc IN FRAME F-Main /* Documento */
DO:
  IF {&SELF-NAME} <> SELF:SCREEN-VALUE
  THEN DO:
    ASSIGN {&SELF-NAME}. 
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Busca-Registros W-Win 
PROCEDURE Busca-Registros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    EMPTY TEMP-TABLE tmp-datos.
    

    CASE rs-tipo:
        WHEN "S" THEN DO:
            FOR EACH AlmDCdoc WHERE AlmDCdoc.CodCia = s-codcia
                AND AlmDCdoc.CodAlm BEGINS txt-codalm
                AND (AlmDCdoc.CodDoc = cb-CodDoc
                     OR cb-CodDoc = "Todos")
                AND AlmDCdoc.Fecha  >= txt-Desde
                AND AlmDCdoc.Fecha  <= txt-Hasta NO-LOCK:
                FIND FIRST tmp-datos WHERE t-codalm = AlmDCDoc.CodAlm
                    AND t-CodDoc = AlmDCDoc.CodDoc
                    AND t-NroDoc = AlmDCDoc.NroDoc NO-LOCK NO-ERROR.
                IF NOT AVAIL tmp-datos THEN DO:
                    CREATE tmp-datos.
                    ASSIGN
                        t-codalm = AlmDCDoc.CodAlm
                        t-coddoc = AlmDCDoc.CodDoc
                        t-nrodoc = AlmDCDoc.NroDoc
                        t-fchdoc = AlmDCdoc.Fecha 
                        t-Bultos = AlmDCdoc.Bultos
                        t-Hora   = AlmDCdoc.Hora
                        t-flag   = AlmDCDoc.CodDoc
                        t-tipo   = rs-tipo.
                    DISPLAY "<<   CARGANDO DOCUMENTOS   >>"  @ txt-mensaje WITH FRAME {&FRAME-NAME}.
                END.
            END.
        END.
        WHEN "I" THEN DO:
            FOR EACH AlmRCDoc WHERE AlmRCDoc.CodCia = s-codcia
                AND AlmRCDoc.CodAlm BEGINS txt-codalm
                AND (AlmRCDoc.CodDoc = cb-CodDoc
                     OR cb-CodDoc = "Todos")
                AND AlmRCDoc.Fecha  >= txt-Desde
                AND AlmRCDoc.Fecha  <= txt-Hasta NO-LOCK:
                FIND FIRST tmp-datos WHERE t-codalm = AlmRCDoc.CodAlm
                    AND t-CodDoc = AlmRCDoc.CodDoc
                    AND t-NroDoc = AlmRCDoc.NroDoc NO-LOCK NO-ERROR.
                IF NOT AVAIL tmp-datos THEN DO:
                    CREATE tmp-datos.
                    ASSIGN
                        t-codalm = AlmRCDoc.CodAlm
                        t-coddoc = AlmRCDoc.CodDoc
                        t-nrodoc = AlmRCDoc.NroDoc
                        t-fchdoc = AlmRCdoc.Fecha 
                        t-Bultos = AlmRCdoc.Bultos
                        t-Hora   = AlmRCdoc.Hora
                        t-flag   = AlmRCDoc.CodDoc
                        t-tipo   = rs-tipo.
                    DISPLAY "<<   CARGANDO DOCUMENTOS   >>"  @ txt-mensaje WITH FRAME {&FRAME-NAME}.
                END.
            END.
        END.
    END CASE.

    /*Filtra por Clientes*/

    FOR EACH tmp-datos NO-LOCK:
        FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia
            AND ccbcdocu.coddoc = t-coddoc
            AND ccbcdocu.nrodoc = t-nrodoc
            AND ccbcdocu.codcli BEGINS txt-codcli NO-LOCK NO-ERROR.
        IF AVAIL ccbcdocu THEN DO:
            ASSIGN 
                t-codcli = ccbcdocu.codcli
                t-nomcli = ccbcdocu.nomcli.
        END.
        ELSE DO:
            RASTREO:
            FOR EACH AlmTMovm WHERE almtmovm.codcia = s-codcia
                AND almtmovm.tipmov = 'S'
                AND almtmovm.reqguia = YES NO-LOCK:
                FOR EACH Almacen WHERE Almacen.codcia = s-codcia NO-LOCK:
                    FIND Almcmov WHERE almcmov.codcia = s-codcia
                        AND almcmov.codalm = txt-codalm
                        AND almcmov.tipmov = almtmovm.tipmov
                        AND almcmov.codmov = almtmovm.codmov
                        AND almcmov.flgest <> 'A'
                        AND almcmov.nroser = INTEGER(SUBSTRING(t-nrodoc,1,3))
                        AND almcmov.nrodoc = INTEGER(SUBSTRING(t-nrodoc,4))
                        NO-LOCK NO-ERROR.
                    IF AVAILABLE Almcmov THEN DO:
                        ASSIGN 
                            t-codcli = almcmov.codcli
                            t-flag   = "MOV".
                        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
                            AND gn-clie.codcli = t-codcli NO-LOCK NO-ERROR.
                        IF AVAIL gn-clie THEN t-nomcli = gn-clie.nomcli.
                        LEAVE RASTREO.
                    END.
                END.
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
  DISPLAY txt-codalm rs-tipo cb-CodDoc txt-Desde txt-Hasta txt-CodCli 
          txt-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txt-codalm rs-tipo cb-CodDoc txt-Desde txt-Hasta txt-CodCli BUTTON-2 
         BUTTON-3 
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
DEFINE VARIABLE t-Column                AS INTEGER INIT 2.

DEFINE VAR x-NomVen LIKE Gn-Ven.NomVen NO-UNDO.
DEFINE VAR x-ImpLin1 AS DEC NO-UNDO.
DEFINE VAR x-ImpLin2 AS DEC NO-UNDO.
DEFINE VAR x-ImpCom1 AS DEC NO-UNDO.
DEFINE VAR x-ImpCom2 AS DEC NO-UNDO.
  
RUN Busca-Registros.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

chWorkSheet:Range("A1: M2"):FONT:Bold = TRUE.
chWorkSheet:Range("A2"):VALUE = "Código".
chWorkSheet:Range("B2"):VALUE = "Número".
chWorkSheet:Range("C2"):VALUE = "Cliente".
chWorkSheet:Range("D2"):VALUE = "Nombre Cliente".
chWorkSheet:Range("E2"):VALUE = "Fecha".
chWorkSheet:Range("F2"):VALUE = "Hora".
chWorkSheet:Range("G2"):VALUE = "Bultos".
chWorkSheet:Range("H2"):VALUE = "Código".
chWorkSheet:Range("I2"):VALUE = "Descripción".
chWorkSheet:Range("J2"):VALUE = "Cantidad".


chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:COLUMNS("D"):NumberFormat = "@".
chWorkSheet = chExcelApplication:Sheets:Item(1).

DISPLAY "<<   GENERANDO EXCEL   >>"  @ txt-mensaje WITH FRAME {&FRAME-NAME}.
FOR EACH tmp-datos NO-LOCK
    WHERE t-codcli BEGINS txt-codcli :


    IF t-flag <> "MOV" THEN DO:
        FOR EACH ccbddocu WHERE ccbddocu.codcia = s-codcia
            AND ccbddocu.coddoc = t-coddoc
            AND ccbddocu.nrodoc = t-nrodoc
            AND ccbddocu.codcli = t-codcli NO-LOCK,
            FIRST almmmatg OF ccbddocu NO-LOCK:
            t-column = t-column + 1.
            cColumn = STRING(t-Column).      
            cRange = "A" + cColumn.   
            chWorkSheet:Range(cRange):Value = t-coddoc.
            cRange = "B" + cColumn.   
            chWorkSheet:Range(cRange):Value = t-nrodoc.
            cRange = "C" + cColumn.   
            chWorkSheet:Range(cRange):Value = t-codcli.
            cRange = "D" + cColumn.   
            chWorkSheet:Range(cRange):Value = t-nomcli.
            cRange = "E" + cColumn.   
            chWorkSheet:Range(cRange):Value = t-fchdoc.
            cRange = "F" + cColumn.   
            chWorkSheet:Range(cRange):Value = t-Hora.
            cRange = "G" + cColumn.   
            chWorkSheet:Range(cRange):Value = t-Bultos.    
            cRange = "H" + cColumn.   
            chWorkSheet:Range(cRange):Value = ccbddocu.codmat.    
            cRange = "I" + cColumn.   
            chWorkSheet:Range(cRange):Value = almmmatg.desmat.    
            cRange = "J" + cColumn.   
            chWorkSheet:Range(cRange):Value = CcbDDocu.UndVta.    
            cRange = "K" + cColumn.   
            chWorkSheet:Range(cRange):Value = CcbDDocu.CanDes.    
        END.
    END.
    ELSE DO:
        FOR EACH Almdmov WHERE almdmov.codcia = s-codcia
            AND almdmov.codalm = txt-codalm
            AND almdmov.nroser = INTEGER(SUBSTRING(t-nrodoc,1,3))
            AND almdmov.nrodoc = INTEGER(SUBSTRING(t-nrodoc,4)) NO-LOCK,
            FIRST almmmatg OF almdmov NO-LOCK:
            t-column = t-column + 1.
            cColumn = STRING(t-Column).      
            cRange = "A" + cColumn.   
            chWorkSheet:Range(cRange):Value = t-coddoc.
            cRange = "B" + cColumn.   
            chWorkSheet:Range(cRange):Value = t-nrodoc.
            cRange = "C" + cColumn.   
            chWorkSheet:Range(cRange):Value = t-codcli.
            cRange = "D" + cColumn.   
            chWorkSheet:Range(cRange):Value = t-nomcli.
            cRange = "E" + cColumn.   
            chWorkSheet:Range(cRange):Value = t-fchdoc.
            cRange = "F" + cColumn.   
            chWorkSheet:Range(cRange):Value = t-Hora.
            cRange = "G" + cColumn.   
            chWorkSheet:Range(cRange):Value = t-Bultos.    
            cRange = "H" + cColumn.   
            chWorkSheet:Range(cRange):Value = almdmov.codmat.    
            cRange = "I" + cColumn.   
            chWorkSheet:Range(cRange):Value = almmmatg.desmat.    
            cRange = "J" + cColumn.   
            chWorkSheet:Range(cRange):Value = almdmov.CodUnd.    
            cRange = "K" + cColumn.   
            chWorkSheet:Range(cRange):Value = almdmov.CanDes.    

        END.
    END.
END.


/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

DISPLAY "<<   PROCESO TERMINADO   >>"  @ txt-mensaje WITH FRAME {&FRAME-NAME}.

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

