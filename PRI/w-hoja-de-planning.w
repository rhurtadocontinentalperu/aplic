&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
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
DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */

DEF TEMP-TABLE Detalle
    FIELD CodMat        AS CHAR     FORMAT 'x(10)'      LABEL 'SKU'
    FIELD DesMat        AS CHAR     FORMAT 'x(80)'      LABEL 'DESCRIPCION'
    FIELD DesMar        AS CHAR     FORMAT 'x(30)'      LABEL 'MARCA'
    FIELD CHR__01       AS CHAR     FORMAT 'x(10)'      LABEL 'UNIDAD'
    FIELD CodFam        AS CHAR     FORMAT 'x(8)'       LABEL 'LINEA'
    FIELD SubFam        AS CHAR     FORMAT 'x(8)'       LABEL 'SUBLINEA'
    FIELD CtoTot        AS DEC      FORMAT '>>>,>>9.9999'   LABEL 'COSTO REPOSICION'
    FIELD PreBas        AS DEC      FORMAT '>>>,>>9.9999'   LABEL 'PRECIO BASE'
    FIELD Margen        AS DEC      FORMAT '->>>,>>9.99'    LABEL 'MARGEN'
    FIELD Canal         AS CHAR     FORMAT 'x(30)'      LABEL 'CANAL'
    FIELD Factor-1      AS DEC      FORMAT '>>9.99'     LABEL 'FACTOR-1'
    FIELD Precio-1      AS DECI     FORMAT '->>>,>>9.9999'  LABEL 'PRECIO-1'
    FIELD Grupo         AS CHAR     FORMAT 'x(30)'      LABEL 'GRUPO'
    FIELD Factor-2      AS DEC      FORMAT '>>9.99'     LABEL 'FACTOR-2'
    FIELD Precio-2      AS DECI     FORMAT '->>>,>>9.9999'  LABEL 'PRECIO-2'
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
&Scoped-Define ENABLED-OBJECTS BUTTON-10 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-user-line AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-user-line-sline AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-jefe-linea AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-10 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 10" 
     SIZE 7 BY 1.62.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-10 AT ROW 15.81 COL 3 WIDGET-ID 2
     FILL-IN-Mensaje AT ROW 16.08 COL 9 COLON-ALIGNED NO-LABEL WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "HOJA DE PLANNING"
         HEIGHT             = 17
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* HOJA DE PLANNING */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* HOJA DE PLANNING */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-10 W-Win
ON CHOOSE OF BUTTON-10 IN FRAME F-Main /* Button 10 */
DO:
  RUN Genera-Excel-Plantilla.
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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pri/b-user-line.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-user-line ).
       RUN set-position IN h_b-user-line ( 1.54 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-user-line ( 6.69 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pri/b-user-line-sline.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-user-line-sline ).
       RUN set-position IN h_b-user-line-sline ( 8.54 , 4.00 ) NO-ERROR.
       RUN set-size IN h_b-user-line-sline ( 6.69 , 66.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/pri/q-jefe-linea.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-jefe-linea ).
       RUN set-position IN h_q-jefe-linea ( 1.00 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.50 , 7.72 ) */

       /* Links to SmartBrowser h_b-user-line. */
       RUN add-link IN adm-broker-hdl ( h_q-jefe-linea , 'Record':U , h_b-user-line ).

       /* Links to SmartBrowser h_b-user-line-sline. */
       RUN add-link IN adm-broker-hdl ( h_b-user-line , 'Record':U , h_b-user-line-sline ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-user-line ,
             BUTTON-10:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-user-line-sline ,
             h_b-user-line , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

EMPTY TEMP-TABLE Detalle.

DEF VAR x-margen AS DEC.
DEF VAR x-ctotot AS DEC.
DEF VAR x-prebas AS DEC.
DEF VAR x-precio-1 AS DEC.
DEF VAR x-precio-2 AS DEC.

FOR EACH priuserlineasublin WHERE priuserlineasublin.CodCia = s-CodCia AND
    priuserlineasublin.User-Id = s-User-Id NO-LOCK,
    EACH Almmmatg WHERE Almmmatg.codcia = s-CodCia AND
    Almmmatg.codfam = priuserlineasublin.CodFam AND
    Almmmatg.subfam = priuserlineasublin.SubFam AND 
    Almmmatg.tpoart <> "D" NO-LOCK:
    FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
        "PROCESANDO: " + Almmmatg.CodMat.
    x-ctotot = (IF monvta = 2 THEN Almmmatg.ctotot * Almmmatg.tpocmb ELSE Almmmatg.ctotot).
    x-prebas = 0.
    x-precio-1 = 0.
    x-precio-2 = 0.
    x-margen = 0.
    FIND prilistabase WHERE prilistabase.CodCia = Almmmatg.CodCia AND
        prilistabase.CodMat = Almmmatg.CodMat
        NO-LOCK NO-ERROR.
    IF AVAILABLE prilistabase THEN x-prebas = prilistabase.PreBas.
    IF x-ctotot > 0 THEN x-margen = (x-prebas - x-ctotot) / x-ctotot * 100.
    FOR EACH pricanal NO-LOCK WHERE pricanal.CodCia = almmmatg.codcia,
        EACH pricanalgrupo OF pricanal NO-LOCK,
        FIRST prigrupo OF pricanalgrupo NO-LOCK:
        ASSIGN
            x-Precio-1 = ROUND(x-PreBas * pricanal.Factor / 100, 4).
        ASSIGN
            x-Precio-2 = ROUND(x-Precio-1 * pricanalgrupo.Factor / 100, 4).
        CREATE Detalle.
        ASSIGN
            Detalle.CodMat = Almmmatg.CodMat 
            Detalle.DesMat = Almmmatg.DesMat
            Detalle.DesMar = Almmmatg.DesMar
            Detalle.CHR__01 = Almmmatg.Chr__01
            Detalle.CodFam = Almmmatg.CodFam
            Detalle.SubFam = Almmmatg.SubFam
            Detalle.CtoTot = x-CtoTot
            Detalle.PreBas = x-PreBas
            Detalle.Margen = x-Margen
            Detalle.Canal = pricanal.Canal + " - " + pricanal.Descripcion
            Detalle.Factor-1 = pricanal.Factor
            Detalle.Precio-1 = x-Precio-1
            Detalle.Grupo = prigrupo.Grupo + " - " + prigrupo.Descripcion
            Detalle.Factor-2 = pricanalgrupo.Factor
            Detalle.Precio-2 = x-Precio-2
            .
    END.
END.
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

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
  DISPLAY FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-10 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel W-Win 
PROCEDURE Genera-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Archivo de Salida */
DEF VAR c-csv-file AS CHAR NO-UNDO.
DEF VAR c-xls-file AS CHAR INIT 'Archivo_Excel' NO-UNDO.
DEF VAR rpta AS LOG INIT NO NO-UNDO.

SYSTEM-DIALOG GET-FILE c-xls-file
    FILTERS 'Libro de Excel' '*.xlsx'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".xlsx"
    SAVE-AS
    TITLE "Guardar como"
    USE-FILENAME
    UPDATE rpta.
IF rpta = NO THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').

/* Variable de memoria */
DEFINE VAR hProc AS HANDLE NO-UNDO.

/* Levantamos la libreria a memoria */
RUN lib\Tools-to-excel PERSISTENT SET hProc.

/* Cargamos la informacion al temporal */
EMPTY TEMP-TABLE Detalle.
RUN Carga-Temporal.

/* Programas que generan el Excel */
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .

RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle:handle,
                                  INPUT  c-csv-file,
                                  OUTPUT c-xls-file) .

/* Borramos librerias de la memoria */
DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').
MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Excel-Plantilla W-Win 
PROCEDURE Genera-Excel-Plantilla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Archivo de Salida */
DEF VAR c-csv-file AS CHAR NO-UNDO.
DEF VAR c-xls-file AS CHAR INIT 'Hoja_de_Planning_1' NO-UNDO.
DEF VAR rpta AS LOG INIT NO NO-UNDO.

SYSTEM-DIALOG GET-FILE c-xls-file
    FILTERS 'Libro de Excel' '*.xlsx'
    INITIAL-FILTER 1
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION ".xlsx"
    SAVE-AS
    TITLE "Guardar como"
    USE-FILENAME
    UPDATE rpta.
IF rpta = NO THEN RETURN.

/* ******************************************************************************** */
/* Buscamos la plantilla */
/* ******************************************************************************** */
DEF VAR lFileXls AS CHAR NO-UNDO.
DEF VAR lNuevoFile AS LOG NO-UNDO.
GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta'  VALUE lFileXls.
lFileXls = lFileXls + 'hoja_de_planning.xltx'.
FILE-INFO:FILE-NAME = lFileXls.
IF FILE-INFO:FULL-PATHNAME EQ ? THEN DO:
    MESSAGE 'La plantilla ' lFileXls SKIP 'NO existe' VIEW-AS ALERT-BOX.
    RETURN.
END.
SESSION:SET-WAIT-STATE('GENERAL').
/* ******************************************************************************** */
/* Cargamos la informacion al temporal */
/* ******************************************************************************** */
EMPTY TEMP-TABLE Detalle.
RUN Carga-Temporal.
/* ******************************************************************************** */
/* Programas que generan el Excel */
/* ******************************************************************************** */
lNuevoFile = NO.    /* Abre la plantilla lFileXls */
{lib/excel-open-file.i}
/* ******************************************************************************** */
/* LOGICA PRINCIPAL: CARGA DEL EXCEL */
/* ******************************************************************************** */
/* Select a worksheet */
chWorkbook:Worksheets(1):Activate.
chWorksheet = chWorkbook:Worksheets(1).
/* Cargamos al revés */
DEF VAR LocalRow AS INT NO-UNDO.
iRow = 2.
LocalRow = 2.
FOR EACH Detalle NO-LOCK BY Detalle.CodFam DESCENDING
    BY Detalle.SubFam DESCENDING
    BY Detalle.CodMat DESCENDING
    BY Detalle.Canal DESCENDING
    BY Detalle.Grupo DESCENDING:
    /*Agrega Row*/
    chWorkSheet:Range("A2"):EntireRow:INSERT.
    /* Grabar */
    /*iRow = iRow + 1.*/
    LocalRow = LocalRow + 1.
    cColumn = STRING(iRow).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CodMat.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.DesMat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.DesMar.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CHR__01.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CodFam.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.SubFam.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.CtoTot.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.PreBas.
/*     cRange = "I" + cColumn.                           */
/*     chWorkSheet:Range(cRange):Value = Detalle.Margen. */
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.Canal.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.Factor-1.
/*     cRange = "L" + cColumn.                             */
/*     chWorkSheet:Range(cRange):Value = Detalle.Precio-1. */
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.Grupo.
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = Detalle.Factor-2.
/*     cRange = "O" + cColumn.                             */
/*     chWorkSheet:Range(cRange):Value = Detalle.Precio-2. */
END.
/* Borramos librerias de la memoria */
/* Delete Row*/
chWorkSheet:Range("A" + STRING(LocalRow)):EntireRow:DELETE.
SESSION:SET-WAIT-STATE('').
lNuevoFile = YES.           /* Graba la plantilla en el nuevo archivo */
lFileXls = c-xls-file.
lCerrarAlTerminar = YES.     /* NO Se hace visible al terminar */
lMensajeAlTerminar = YES.   /* Aviso que terminó el proceso */
{lib/excel-close-file.i}

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
  RUN Disable-Columns IN h_b-user-line.
  RUN Disable-Columns IN h_b-user-line-sline.

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

