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
DEFINE SHARED VAR cl-codcia AS INT INIT 0.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE cCodDoc AS CHARACTER   NO-UNDO.
DEFINE VARIABLE S-TITULO AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE t-datos
    FIELDS t-codcli LIKE faccpedi.codcli
    FIELDS t-coddoc LIKE ccbcdocu.coddoc
    FIELDS t-nrodoc LIKE ccbcdocu.nrodoc
    FIELDS t-fchped LIKE ccbcdocu.fchdoc
    FIELDS t-codmat LIKE facdpedi.codmat
    FIELDS t-desmat LIKE almmmatg.desmat
    FIELDS t-codfam LIKE Almmmatg.codfam
    FIELDS t-subfam LIKE almmmatg.subfam
    FIELDS t-implin LIKE CcbDDocu.ImpLin
    FIELDS t-codope AS INT
    FIELDS t-impapl LIKE CcbDDocu.ImpLin
    FIELDS t-impdif LIKE CcbDDocu.ImpLin
    FIELDS t-impnc  LIKE CcbDDocu.ImpLin
    FIELDS t-codmon LIKE CcbcDocu.CodMon
    FIELDS t-fchope AS DATE.


DEFINE TEMP-TABLE tt-tabla
    FIELDS tt-codcli LIKE ccbcdocu.codcli
    FIELDS tt-fecha  AS DATE
    FIELDS tt-codope AS INT
    FIELDS tt-imptot LIKE ccbcdocu.imptot
    FIELDS tt-tasa   AS DECIMAL.

DEFINE BUFFER btt-tabla     FOR tt-tabla.
DEFINE BUFFER bt-datos      FOR t-datos.
DEFINE BUFFER bt-datos2     FOR t-datos.

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
&Scoped-Define ENABLED-OBJECTS DesdeF HastaF Btn_OK Btn_Cancel RECT-65 ~
RECT-66 
&Scoped-Define DISPLAYED-OBJECTS DesdeF HastaF txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Cancelar" 
     SIZE 8 BY 1.58
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Aceptar" 
     SIZE 8 BY 1.58
     BGCOLOR 8 .

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .77 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .77 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U INITIAL "Cargando Informacion....." 
     VIEW-AS FILL-IN 
     SIZE 58 BY .81
     BGCOLOR 9 FGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE RECT-65
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 2.

DEFINE RECTANGLE RECT-66
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 5.27.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     DesdeF AT ROW 2.62 COL 9 COLON-ALIGNED WIDGET-ID 4
     HastaF AT ROW 2.62 COL 24.72 COLON-ALIGNED WIDGET-ID 8
     Btn_OK AT ROW 6.62 COL 42.29 WIDGET-ID 22
     Btn_Cancel AT ROW 6.62 COL 51 WIDGET-ID 20
     txt-msj AT ROW 5.31 COL 2.29 NO-LABEL WIDGET-ID 16
     RECT-65 AT ROW 6.42 COL 2 WIDGET-ID 18
     RECT-66 AT ROW 1.12 COL 2 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 61.29 BY 7.77
         FONT 1 WIDGET-ID 100.


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
         TITLE              = "Reporte de Cotizaciones"
         HEIGHT             = 7.77
         WIDTH              = 61.29
         MAX-HEIGHT         = 7.77
         MAX-WIDTH          = 61.29
         VIRTUAL-HEIGHT     = 7.77
         VIRTUAL-WIDTH      = 61.29
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

{src/bin/_prns.i}
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
ON END-ERROR OF W-Win /* Reporte de Cotizaciones */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Cotizaciones */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  
    ASSIGN DesdeF HastaF .

    S-TITULO = S-TITULO + "PENDIENTES POR ATENDER.".
    txt-msj:VISIBLE IN FRAME {&FRAME-NAME} = YES.
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

ON 'RETURN':U OF DesdeF,HastaF
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

/*
ON 'LEAVE':U OF txt-codcli
DO:
  FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = txt-codcli:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAIL gn-clie 
      THEN DISPLAY gn-clie.nomcli @ txt-nomcli WITH FRAME {&FRAME-NAME}.
  ELSE DISPLAY "" @ txt-nomcli WITH FRAME {&FRAME-NAME}.    
END.
*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-1 W-Win 
PROCEDURE Carga-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


FOR EACH t-datos:
    DELETE t-datos.
END.

FOR EACH tt-tabla:
    DELETE tt-tabla.
END.

INPUT FROM "O:\Rosa\Clientes.txt".
REPEAT:
    CREATE tt-tabla.
    IMPORT DELIMITER "|" tt-tabla NO-ERROR.
END.
INPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Data W-Win 
PROCEDURE Carga-Data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE iInt AS INTEGER     NO-UNDO.
    DEFINE VARIABLE dDif AS DECIMAL     NO-UNDO.

    RUN Carga-1.

    FOR EACH tt-tabla NO-LOCK BREAK BY tt-codcli:
        IF FIRST-OF(tt-codcli) THEN DO:
            FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia
                /*AND ccbcdocu.coddiv = "00015"*/
                AND ccbcdocu.codcli = tt-codcli
                AND ccbcdocu.coddoc = "FAC"                
                AND ccbcdocu.flgest = "C"
                AND ccbcdocu.fchdoc >= DesdeF
                AND ccbcdocu.fchdoc <= HastaF NO-LOCK,
                EACH ccbddocu OF ccbcdocu NO-LOCK:

                FIND FIRST almmmatg WHERE almmmatg.codcia = ccbcdocu.codcia
                    AND almmmatg.codmat = ccbddocu.codmat NO-LOCK NO-ERROR.
                CREATE t-datos.
                ASSIGN 
                    t-codcli = tt-codcli  
                    t-coddoc = ccbcdocu.coddoc                     
                    t-nrodoc = ccbcdocu.nrodoc                     
                    t-fchped = ccbcdocu.fchdoc                     
                    t-codmat = ccbddocu.codmat
                    t-desmat = almmmatg.desmat                     
                    t-codfam = Almmmatg.codfam                     
                    t-subfam = almmmatg.subfam                     
                    t-implin = CcbDDocu.ImpLin                     
                    /*t-codope = tt-codope */
                    t-impapl = 0
                    t-impdif = CcbDDocu.ImpLin                     
                    /*t-impnc  = tt-tasa*/
                    t-codmon = CcbCDocu.CodMon. 
                
                IF ccbcdocu.codmon = 2 THEN DO: 
                    t-implin = t-implin * CcbCDocu.TpoCmb.
                    t-impdif = t-impdif * CcbCDocu.TpoCmb.
                END.
                
            END.
        END.
    END.

    /*Asigna Montos*/

    Head:
    FOR EACH tt-tabla NO-LOCK WHERE tt-tabla.tt-imptot <> 0 
        BREAK BY tt-codcli
        BY tt-fecha
        BY tt-codope:        
        FOR EACH t-datos WHERE t-datos.t-codcli = tt-tabla.tt-codcli NO-LOCK
            BREAK BY t-datos.t-codcli
            BY t-datos.t-coddoc
            BY t-datos.t-nrodoc
            BY t-datos.t-codmat
            BY t-datos.t-impapl DESC:            
            /*Si tiene diferencias*/ 
            IF t-datos.t-impdif = 0 THEN NEXT.    
            /*IF tt-tabla.tt-imptot = 0 THEN NEXT.*/

            IF tt-tabla.tt-imptot >= t-datos.t-impdif THEN DO:
                ASSIGN
                    t-datos.t-codope = tt-tabla.tt-codope
                    t-datos.t-fchope = tt-tabla.tt-fecha
                    t-datos.t-impapl = t-datos.t-impdif
                    t-datos.t-impdif = (t-datos.t-impdif - t-datos.t-impapl)
                    tt-tabla.tt-imptot = (tt-tabla.tt-imptot - t-datos.t-impapl).
                IF tt-tabla.tt-imptot = 0 THEN NEXT Head.
            END.
            ELSE DO:
                ASSIGN
                    t-datos.t-codope = tt-tabla.tt-codope
                    t-datos.t-fchope = tt-tabla.tt-fecha
                    t-datos.t-impapl = tt-tabla.tt-imptot
                    t-datos.t-impdif = (t-datos.t-impdif - t-datos.t-impapl)
                    tt-tabla.tt-imptot = 0.

                /*Repito Linea*/
                FIND LAST bt-datos WHERE bt-datos.t-codcli = t-datos.t-codcli 
                    AND bt-datos.t-coddoc = t-datos.t-coddoc 
                    AND bt-datos.t-nrodoc = t-datos.t-nrodoc 
                    AND bt-datos.t-codmat = t-datos.t-codmat
                    AND bt-datos.t-impdif <> 0
                    AND bt-datos.t-impapl <> 0 NO-ERROR.
                IF AVAIL bt-datos THEN DO:
                    CREATE bt-datos2.
                    BUFFER-COPY bt-datos TO bt-datos2. 
                    ASSIGN bt-datos2.t-impapl = 0.
                END.                
                t-datos.t-impdif = 0.                
            END.     

            IF LOOKUP(t-datos.t-codmat,"032749,032750,032751,032781,032779,032780,005206,005207") = 0 
                THEN t-datos.t-impnc = t-datos.t-impapl * (tt-tabla.tt-tasa / 100).

            IF tt-tabla.tt-imptot = 0 THEN NEXT Head.
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
  DISPLAY DesdeF HastaF txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE DesdeF HastaF Btn_OK Btn_Cancel RECT-65 RECT-66 
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

    RUN Carga-Data.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).    

    /*Formato*/
    chWorkSheet:Columns("A"):NumberFormat = "@".    
    chWorkSheet:Columns("C"):NumberFormat = "@".    
    chWorkSheet:Columns("E"):NumberFormat = "@".    
    chWorkSheet:Columns("G"):NumberFormat = "@".    
    chWorkSheet:Columns("H"):NumberFormat = "@".    

    iCount = iCount + 3.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "Cliente".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "Codigo".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "Numero".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "Fecha".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "Codigo".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "Descripcion".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "Familia".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "SubFamilia".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = "Imp. Linea".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = "CodOpe".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = "ImpAplicado".
    /*
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Diferencia".
    */
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = "Imp N/C".   
    

    FOR EACH t-datos NO-LOCK BREAK BY t-datos.t-codcli
        BY t-datos.t-nrodoc        
        BY t-datos.t-fchope
        BY t-datos.t-codope
        BY t-datos.t-codmat
        BY t-datos.t-impapl DESC:

        IF t-codope > 0 AND t-impapl <= 0 THEN NEXT.
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = t-codcli.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = t-coddoc.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = t-nrodoc.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = t-fchped.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = t-codmat.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = t-desmat.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = t-codfam.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = t-subfam.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = t-implin.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = t-codope.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = t-impapl.
        /*
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = t-impdif.
        */
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = t-impnc .
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  txt-msj:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN DesdeF   = TODAY
             HastaF   = TODAY.
      DISPLAY 
          TODAY @ DesdeF
          TODAY @ HastaF.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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

