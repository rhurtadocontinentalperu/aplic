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

DEFINE INPUT PARAMETER p-Almacenes      AS CHARACTER NO-UNDO.

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-codalm AS CHAR.
DEF STREAM REPORT.

DEFINE TEMP-TABLE ttTempoRepo
    FIELD tcodalm   LIKE almmmate.codalm    COLUMN-LABEL "Cod.Alm"
    FIELD tdescripcion LIKE almacen.descripcion COLUMN-LABEL "Descripcion Almacen"
    FIELD tcodmat LIKE almmmatg.codmat COLUMN-LABEL "Cod.Articulo"
    FIELD tdesmat LIKE almmmatg.desmat COLUMN-LABEL "Descricpion Articulo"
    FIELD tcodfam LIKE almmmatg.codfam COLUMN-LABEL "Cod.Fam"
    FIELD tdesfam LIKE almtfami.desfam COLUMN-LABEL "Descripcion Fam"
    FIELD tsubfam LIKE almmmatg.subfam COLUMN-LABEL "Cod.SubFam"
    FIELD tdessub LIKE almsfam.dessub COLUMN-LABEL "Descripcion  SubFamilia"
    FIELD tcodmar LIKE almmmatg.codmar COLUMN-LABEL "Cod.Marca"
    FIELD tdesmar LIKE almmmatg.desmar COLUMN-LABEL "Descripcion Marca"
    FIELD tmonvta LIKE almmmatg.monvta COLUMN-LABEL "Mone Vta"
    FIELD ttpocmb LIKE almmmatg.tpocmb COLUMN-LABEL "Tipo Cambio"
    FIELD tctotot LIKE almmmatg.ctotot COLUMN-LABEL "Costo Repo"
    FIELD tstockmax LIKE almmmate.stockmax COLUMN-LABEL "Stk Maximo"
    FIELD tstkmax LIKE almmmate.stkmax COLUMN-LABEL "Empaque Reposicion"
    FIELD tcanemp LIKE almmmatg.canemp COLUMN-LABEL "Master"
    FIELD tstkrep LIKE almmmatg.stkrep COLUMN-LABEL "Inner"
    FIELD tdec__03 LIKE almmmatg.DEC__03 COLUMN-LABEL "Minimo Vta"
    FIELD tstkact LIKE almmmate.stkact COLUMN-LABEL "Stock Actual"
    FIELD ttpoart LIKE almmmatg.tpoart COLUMN-LABEL "Estado".

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
&Scoped-Define ENABLED-OBJECTS cboAlmacen cboFamilia rsCuales btnProcesar 
&Scoped-Define DISPLAYED-OBJECTS cboAlmacen cboFamilia rsCuales 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnProcesar 
     LABEL "Generar Archivo" 
     SIZE 17 BY 1.12.

DEFINE VARIABLE cboAlmacen AS CHARACTER FORMAT "X(256)":U 
     LABEL "Elija almacen" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 49 BY 1 NO-UNDO.

DEFINE VARIABLE cboFamilia AS CHARACTER FORMAT "X(256)":U 
     LABEL "Elija familia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 49 BY 1 NO-UNDO.

DEFINE VARIABLE rsCuales AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Todos", 1,
"Solo con Stock", 2,
"Solo sin Stock", 3
     SIZE 46 BY .96 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     cboAlmacen AT ROW 3.5 COL 16 COLON-ALIGNED WIDGET-ID 6
     cboFamilia AT ROW 5 COL 16 COLON-ALIGNED WIDGET-ID 8
     rsCuales AT ROW 6.5 COL 21 NO-LABEL WIDGET-ID 14
     btnProcesar AT ROW 10.04 COL 63 WIDGET-ID 10
     " La seleccion de TODOS como almacen, implica" VIEW-AS TEXT
          SIZE 63.57 BY 1.15 AT ROW 7.88 COL 3.43 WIDGET-ID 18
          FGCOLOR 12 FONT 11
     " demasiado tiempo de demora en procesar" VIEW-AS TEXT
          SIZE 57.57 BY 1.15 AT ROW 8.88 COL 3.43 WIDGET-ID 20
          FGCOLOR 12 FONT 11
     "Enviar a Excel articulos con stocks Minimos y Maximos" VIEW-AS TEXT
          SIZE 46 BY .62 AT ROW 1.77 COL 19.43 WIDGET-ID 12
          FGCOLOR 9 FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 84.14 BY 10.62 WIDGET-ID 100.


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
         TITLE              = "Stock Minimo y Maximos"
         HEIGHT             = 10.62
         WIDTH              = 84.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 84.14
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 84.14
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Stock Minimo y Maximos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Stock Minimo y Maximos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnProcesar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnProcesar W-Win
ON CHOOSE OF btnProcesar IN FRAME F-Main /* Generar Archivo */
DO:
  SESSION:SET-WAIT-STATE('GENERAL').

  ASSIGN rsCuales.

  /*RUN ue-procesar.*/
  RUN ue-texto.
  SESSION:SET-WAIT-STATE('').
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
  DISPLAY cboAlmacen cboFamilia rsCuales 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE cboAlmacen cboFamilia rsCuales btnProcesar 
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
      /* Almacenes */
          REPEAT WHILE cboAlmacen:NUM-ITEMS > 0:
            cboAlmacen:DELETE(1).
          END.
      
      IF CAPS(p-Almacenes)='TODOS' THEN cboAlmacen:ADD-LAST('Todos').

      FOR EACH almacen WHERE (CAPS(p-Almacenes)='TODOS' OR 
          almacen.codalm = s-codalm ) AND (almacen.campo-c[9]<>'I' AND CAPS(almacen.campo-c[6])='SI')
          NO-LOCK BY codalm:
            /*cboAlmacen:ADD-LAST(almacen.codalm + " - " + almacen.descripcion, almacen.codalm).*/
            cboAlmacen:ADD-LAST(almacen.codalm + " - " + almacen.descripcion).
            IF (cboAlmacen:SCREEN-VALUE = '' OR cboAlmacen:SCREEN-VALUE = ?) THEN DO:
                cboAlmacen:SCREEN-VALUE = almacen.codalm + " - " + almacen.descripcion.
            END.
      END.
      /* Familias */
          REPEAT WHILE cboFamilia:NUM-ITEMS > 0:
            cboFamilia:DELETE(1).
          END.
      
          cboFamilia:ADD-LAST('Todos').
      
      FOR EACH almtfami WHERE almtfami.codcia = s-codcia NO-LOCK BY codfam:
            /*cboAlmacen:ADD-LAST(almacen.codalm + " - " + almacen.descripcion, almacen.codalm).*/
            IF (almtfami.codfam = '008' OR almtfami.codfam = '009' OR 
                 almtfami.codfam >= '015') THEN DO:
                /* No vaaaaa */
            END.
            ELSE DO:            
                cboFamilia:ADD-LAST(almtfami.codfam + " - " + almtfami.desfam).
                IF (cboFamilia:SCREEN-VALUE = '' OR cboFamilia:SCREEN-VALUE = ?) THEN DO:
                    cboFamilia:SCREEN-VALUE = almtfami.codfam + " - " + almtfami.desfam.
                END.
            END.
      END.

    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-procesar W-Win 
PROCEDURE ue-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lAlmacen AS CHAR.
DEFINE VAR lFamilia AS CHAR.
DEFINE VAR lPos AS INT.

lAlmacen = CAPS(cboAlmacen:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
lFamilia = CAPS(cboFamilia:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

IF lAlmacen<>"TODOS" THEN DO:
    lPos = INDEX(lAlmacen,"-").
    lAlmacen = TRIM(SUBSTRING(lAlmacen,1,lPos - 1)).
END.
IF lFamilia<>"TODOS" THEN DO:
    lPos = INDEX(lFamilia,"-").
    lFamilia = TRIM(SUBSTRING(lFamilia,1,lPos - 1)).
END.

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

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = FALSE.

/* Para crear a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

iColumn = 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "Cod.Almacen".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "Descrip. Almamcen".
cColumn = STRING(iColumn).
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "Cod.Art".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "Cod.Fami".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion Fami".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Cod.Sub.Fami".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion SubFami.".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Cod.Marca".
cRange = "J" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion Marca".
cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "Moneda Vta".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "Tipo Cambio".
cRange = "M" + cColumn.
chWorkSheet:Range(cRange):Value = "Costo Repo. Sin IGV".
cRange = "N" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Minimo".
cRange = "O" + cColumn.
chWorkSheet:Range(cRange):Value = "Stk Maximo".
cRange = "P" + cColumn.
chWorkSheet:Range(cRange):Value = "Empaque".
cRange = "Q" + cColumn.
chWorkSheet:Range(cRange):Value = "Minimo Vta".
cRange = "R" + cColumn.
chWorkSheet:Range(cRange):Value = "Clsf. General".
cRange = "S" + cColumn.
chWorkSheet:Range(cRange):Value = "Clsf Mayorista".
cRange = "T" + cColumn.
chWorkSheet:Range(cRange):Value = "Clsf Utilex/Institucionales".
cRange = "U" + cColumn.
chWorkSheet:Range(cRange):Value = "Estado".

FOR EACH almacen WHERE almacen.codcia = s-codcia AND 
    (lAlmacen = 'TODOS' OR almacen.codalm = lAlmacen) AND
    (almacen.campo-c[9]<>'I' AND CAPS(almacen.campo-c[6])='SI') NO-LOCK,
     EACH almmmatg NO-LOCK WHERE (lFamilia = 'TODOS' OR almmmatg.codfam = lFamilia ),
     EACH almmmate OF almmmatg NO-LOCK WHERE almmmate.codalm = almacen.codalm,
        FIRST almtfami OF almmmatg NO-LOCK, 
        FIRST almsfami OF almmmatg NO-LOCK:

        FIND FIRST almtabla WHERE almtabla.tabla = 'MK' AND 
            almmmatg.codmar = almtabla.codigo NO-LOCK NO-ERROR.

        iColumn = iColumn + 1.
        cColumn = STRING(iColumn).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + almmmate.codalm.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = almacen.descripcion.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + almmmatg.codmat.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = almmmatg.desmat.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + almmmatg.codfam.

        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = almtfami.desfam.

       cRange = "G" + cColumn.
       chWorkSheet:Range(cRange):Value = "'" + almmmatg.subfam.
       cRange = "H" + cColumn.
       chWorkSheet:Range(cRange):Value = almsfam.dessub.
       
       cRange = "I" + cColumn.
       chWorkSheet:Range(cRange):Value = "'" + almmmatg.codmar.
       IF AVAILABLE almtabla THEN DO:
           cRange = "J" + cColumn.
           chWorkSheet:Range(cRange):Value = almtabla.nombre.
       END.
       cRange = "K" + cColumn.
       chWorkSheet:Range(cRange):Value = almmmatg.monvta.
       cRange = "L" + cColumn.
       chWorkSheet:Range(cRange):Value = almmmatg.tpocmb.
       cRange = "M" + cColumn.
       chWorkSheet:Range(cRange):Value = almmmatg.ctotot.
       cRange = "N" + cColumn.
       chWorkSheet:Range(cRange):Value = almmmate.stkmin.
       cRange = "O" + cColumn.
       chWorkSheet:Range(cRange):Value = almmmate.stkmax.
       cRange = "P" + cColumn.
       chWorkSheet:Range(cRange):Value = almmmatg.canemp.
       cRange = "Q" + cColumn.
       chWorkSheet:Range(cRange):Value = almmmatg.DEC__03.
       cRange = "R" + cColumn.
       chWorkSheet:Range(cRange):Value = "'" + almmmatg.tiprot[1].
       cRange = "S" + cColumn.
       chWorkSheet:Range(cRange):Value = "'" + almmmatg.undAlt[4].
       cRange = "T" + cColumn.
       chWorkSheet:Range(cRange):Value = "'" + almmmatg.undAlt[3].
       cRange = "U" + cColumn.
       chWorkSheet:Range(cRange):Value = "'" + almmmatg.tpoart.
    
END.

chExcelApplication:DisplayAlerts = False.
chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication NO-ERROR.      
RELEASE OBJECT chWorkbook NO-ERROR.
RELEASE OBJECT chWorksheet NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR. 

MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-texto W-Win 
PROCEDURE ue-texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR lAlmacen AS CHAR.
DEFINE VAR lFamilia AS CHAR.
DEFINE VAR lPos AS INT.
DEFINE VAR lMarca AS CHAR.
DEFINE VAR x-archivo AS CHAR.
DEFINE VAR rpta AS LOG.

lAlmacen = CAPS(cboAlmacen:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
lFamilia = CAPS(cboFamilia:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

IF lAlmacen<>"TODOS" THEN DO:
    lPos = INDEX(lAlmacen,"-").
    lAlmacen = TRIM(SUBSTRING(lAlmacen,1,lPos - 1)).
END.
IF lFamilia<>"TODOS" THEN DO:
    lPos = INDEX(lFamilia,"-").
    lFamilia = TRIM(SUBSTRING(lFamilia,1,lPos - 1)).
    /**/
    IF lFamilia = '008' OR lFamilia = '009' OR lFamilia >= '015' THEN DO:
        MESSAGE "La familia seleccionada no esta permitida" 
            VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

END.

SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS 'Texto (*.xlsx)' '*.xlsx'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.xlsx'
    RETURN-TO-START-DIR
    SAVE-AS
    TITLE 'Exportar a Excel'
    UPDATE rpta.
IF rpta = NO OR x-Archivo = '' THEN RETURN.


  EMPTY TEMP-TABLE ttTempoRepo.

  FOR EACH almacen WHERE almacen.codcia = s-codcia AND 
      (lAlmacen = 'TODOS' OR almacen.codalm = lAlmacen) AND
      (almacen.campo-c[9]<>'I' AND CAPS(almacen.campo-c[6])='SI') NO-LOCK,
       EACH almmmatg NO-LOCK WHERE (lFamilia = 'TODOS' OR almmmatg.codfam = lFamilia ),
       EACH almmmate OF almmmatg NO-LOCK WHERE almmmate.codalm = almacen.codalm,
          FIRST almtfami OF almmmatg NO-LOCK, 
          FIRST almsfami OF almmmatg NO-LOCK:

          /* Si el articulo esta DESACTIVADO y no tiene Stock - NO VAAA */
            IF (rsCuales = 2 AND almmmate.stkact = 0) OR  
                (rsCuales = 3 AND almmmate.stkact <> 0) THEN NEXT.
        
          /*IF (almmmatg.tpoart = 'D' AND almmmate.stkact = 0)  THEN NEXT.*/

          FIND FIRST almtabla WHERE almtabla.tabla = 'MK' AND 
              almmmatg.codmar = almtabla.codigo NO-LOCK NO-ERROR.
          IF AVAILABLE almtabla THEN DO :
              lMarca = almtabla.nombre.
           END.
           ELSE lMarca = " ".

           CREATE ttTempoRepo.
           ASSIGN tcodalm = almmmate.codalm
                    tdescripcion = almacen.descripcion
                    tcodmat = almmmatg.codmat
                    tdesmat = almmmatg.desmat
                    tcodfam = almmmatg.codfam
                    tdesfam = almtfami.desfam
                    tsubfam = almmmatg.subfam
                    tdessub = almsfam.dessub
                    tcodmar = almmmatg.codmar
                    tdesmar = lMarca
                    tmonvta = almmmatg.monvta
                    ttpocmb = almmmatg.tpocmb
                    tctotot = almmmatg.ctotot
                    tstockmax = almmmate.stockmax
                    tstkmax = almmmate.stkmax
                    tcanemp = almmmatg.canemp
                    tstkrep = almmmatg.stkrep
                    tdec__03 = almmmatg.DEC__03
                    tstkact = almmmate.stkact
                    ttpoart = almmmatg.tpoart.

  END.


DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */


c-xls-file = x-Archivo.

run pi-crea-archivo-csv IN hProc (input  buffer ttTempoRepo:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer ttTempoRepo:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.


MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

