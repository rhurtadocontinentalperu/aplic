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

DEFINE VARIABLE cDistri AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cProvin AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDepto  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDirPer AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNacion AS CHARACTER   NO-UNDO.
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-nromes AS INT.

DEFINE TEMP-TABLE tt-datos
    FIELDS t-codper AS CHAR
    FIELDS t-nrodoc LIKE PL-PERS.NroDocId                   
    FIELDS t-tpodoc LIKE PL-PERS.TpoDocId                   
    FIELDS t-patper LIKE pl-pers.patper                     
    FIELDS t-matper LIKE pl-pers.matper                     
    FIELDS t-nomper LIKE pl-pers.nomper                     
    FIELDS t-fecnac LIKE PL-PERS.fecnac                     
    FIELDS t-ecivil LIKE PL-PERS.ecivil                     
    FIELDS t-sexper LIKE PL-PERS.sexper
    FIELDS t-codnac LIKE pl-pers.codnac
    FIELDS t-dirper AS CHAR
    FIELDS t-distri AS CHAR
    FIELDS t-provin AS CHAR
    FIELDS t-depto  AS CHAR
    FIELDS t-telefo LIKE pl-pers.telefo
    FIELDS t-celu   LIKE pl-pers.lmil
    FIELDS t-e-mail AS CHAR
    FIELDS t-fecini AS DATE.

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
&Scoped-Define ENABLED-OBJECTS x-periodo BUTTON-1 BUTTON-2 x-nromes ~
rs-cuenta 
&Scoped-Define DISPLAYED-OBJECTS x-periodo x-nromes rs-cuenta x-mensaje 

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

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58 BY .85 NO-UNDO.

DEFINE VARIABLE x-nromes AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE x-periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE rs-cuenta AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Cuentas CTS", 1,
"Cuentas Sueldos", 2
     SIZE 23 BY 2.15 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-periodo AT ROW 2.08 COL 15 COLON-ALIGNED WIDGET-ID 2
     BUTTON-1 AT ROW 2.35 COL 41 WIDGET-ID 12
     BUTTON-2 AT ROW 2.35 COL 49 WIDGET-ID 14
     x-nromes AT ROW 3.15 COL 15 COLON-ALIGNED WIDGET-ID 4
     rs-cuenta AT ROW 4.5 COL 17 NO-LABEL WIDGET-ID 18
     x-mensaje AT ROW 7.73 COL 2 NO-LABEL WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 60 BY 7.85 WIDGET-ID 100.


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
         TITLE              = "Personal sin Cuentas CTS"
         HEIGHT             = 7.85
         WIDTH              = 60
         MAX-HEIGHT         = 7.85
         MAX-WIDTH          = 60
         VIRTUAL-HEIGHT     = 7.85
         VIRTUAL-WIDTH      = 60
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
ON END-ERROR OF W-Win /* Personal sin Cuentas CTS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Personal sin Cuentas CTS */
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
    ASSIGN x-periodo x-nromes rs-cuenta.
    RUN Genera_Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga_Informacion W-Win 
PROCEDURE Carga_Informacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH tt-datos:
        DELETE tt-datos.
    END.

    FOR EACH pl-flg-mes WHERE pl-flg-mes.codcia = s-codcia
        AND pl-flg-mes.codpln = 01
        AND pl-flg-mes.periodo = x-periodo
        AND pl-flg-mes.nromes = x-nromes
        AND pl-flg-mes.sitact = 'Activo' /*
        AND pl-flg-mes.nrodpt-cts = ''*/  NO-LOCK,
        FIRST pl-pers WHERE pl-pers.codcia = pl-flg-mes.codcia
        AND pl-pers.codper = pl-flg-mes.codper NO-LOCK:

        IF rs-cuenta = 1 THEN IF pl-flg-mes.nrodpt-cts <> '' THEN NEXT.
        IF rs-cuenta = 2 THEN  
            IF (pl-flg-mes.cnpago = 'CHEQUE' OR 
                pl-flg-mes.cnpago = 'EFECTIVO' ) OR
                pl-flg-mes.nrodpt <> '' THEN NEXT.
    
        FIND FIRST tt-datos WHERE t-codper = pl-pers.codper NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-datos THEN DO:
            cDistri = ''.
            cProvin = ''.
            cDepto  = ''.
    
            /* Distrito */
            FIND TabDistr WHERE
                TabDistr.CodDepto = SUBSTRING(pl-pers.ubigeo,1,2) AND
                TabDistr.CodProvi = SUBSTRING(pl-pers.ubigeo,3,2) AND
                TabDistr.CodDistr = SUBSTRING(pl-pers.ubigeo,5,2)
                NO-LOCK NO-ERROR.
            IF AVAILABLE TabDistr THEN cDistri = TabDistr.NomDistr.
    
            /* Provincia */
            FIND TabProvi WHERE
                TabProvi.CodDepto = SUBSTRING(pl-pers.ubigeo,1,2) AND
                TabProvi.CodProvi = SUBSTRING(pl-pers.ubigeo,3,2) NO-LOCK NO-ERROR.
            IF AVAILABLE TabProvi THEN cProvin = TabProvi.NomProvi.
    
            /* Region */
            FIND TabDepto WHERE
                TabDepto.CodDepto = SUBSTRING(pl-pers.ubigeo,1,2) NO-LOCK NO-ERROR.
            IF AVAILABLE TabDepto THEN cDepto = TabDepto.NomDepto.
    
            FIND FIRST PL-TABLA WHERE
                pl-tabla.codcia = 0 AND
                pl-tabla.tabla = '05' AND 
                pl-tabla.codigo = pl-pers.TipoVia NO-LOCK NO-ERROR.
            IF AVAIL pl-tabla THEN cDirPer = pl-tabla.nombre + " " + pl-pers.dirper.
            ELSE cDirPer = pl-pers.dirper.

            FIND pl-tabla WHERE
                pl-tabla.codcia = 0 AND
                pl-tabla.tabla = '04' AND
                pl-tabla.codigo = pl-pers.CodNac NO-LOCK NO-ERROR.
            IF AVAILABLE pl-tabla THEN cNacion = pl-tabla.nombre.
            ELSE cNacion = ' '.


            
            CREATE tt-datos.
            ASSIGN
                t-codper = pl-pers.codper
                t-nrodoc = PL-PERS.NroDocId     
                t-tpodoc = PL-PERS.TpoDocId     
                t-patper = pl-pers.patper       
                t-matper = pl-pers.matper       
                t-nomper = pl-pers.nomper       
                t-fecnac = PL-PERS.fecnac       
                t-ecivil = PL-PERS.ecivil       
                t-sexper = IF (pl-pers.sexper = '1') THEN 'M' ELSE 'F'
                t-codnac = cNacion
                t-dirper = cDirper
                t-distri = cDistri
                t-provin = cProvin                   
                t-depto  = cDepto                   
                t-telefo = pl-pers.telefo       
                t-celu   = pl-pers.lmil
                t-e-mail = pl-pers.e-mail
                t-fecini = pl-flg-mes.fecing.
            DISPLAY 'CARGANDO INFORMACION ' @ x-mensaje
                WITH FRAME {&FRAME-NAME}.
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
  DISPLAY x-periodo x-nromes rs-cuenta x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-periodo BUTTON-1 BUTTON-2 x-nromes rs-cuenta 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera_Excel W-Win 
PROCEDURE Genera_Excel :
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
    DEFINE VARIABLE t-Column           AS INTEGER INIT 5.
    DEFINE VARIABLE p                  AS INTEGER     NO-UNDO.

    DEFINE VARIABLE iint AS INTEGER     NO-UNDO INIT 0.

    RUN Carga_Informacion.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    /*chWorkbook = chExcelApplication:Workbooks:Add("C:\PRG\Templates\q fue\Cotizacion.xlt").*/
    DEF var x-Plantilla AS CHAR NO-UNDO.
    GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta' VALUE x-Plantilla .
    x-Plantilla = x-Plantilla + "Plantilla_Aperturas_CTS.xlt".
    
    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add(x-Plantilla).
    /*chWorkbook = chExcelApplication:Workbooks:Add().*/
    
    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    iCount = 32.
    FOR EACH tt-datos NO-LOCK:
        iint = iint + 1.
        iCount = iCount + 1.
        cColumn = STRING(iCount).
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = iint.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = t-nrodoc.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = t-tpodoc.         
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = t-patper.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = t-matper.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = t-nomper.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = t-fecnac.

        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = ''.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = t-sexper.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = t-codnac.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = t-dirper.
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = t-distri.

        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = t-provin.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = t-depto.
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = t-telefo.
        cRange = "R" + cColumn.
        chWorkSheet:Range(cRange):Value = t-celu.
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = t-e-mail.
        cRange = "U" + cColumn.
        chWorkSheet:Range(cRange):Value = t-fecini.
        cRange = "V" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + t-codper.        

        DISPLAY 'GENERANDO EXCEL ' @ x-mensaje 
            WITH FRAME {&FRAME-NAME}.
    END.


  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  DISPLAY '' @ x-mensaje WITH FRAME {&FRAME-NAME}.


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
  ASSIGN 
      x-periodo = YEAR(TODAY)
      x-nromes  = s-nromes.

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

