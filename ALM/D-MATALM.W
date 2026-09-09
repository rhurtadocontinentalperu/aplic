&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE VAR I-TPOREP AS INTEGER INIT 1.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEF VAR RB-REPORT-LIBRARY AS CHAR.
RB-REPORT-LIBRARY = RUTA + "alm\rbalm.prl".

DEF VAR RB-REPORT-NAME AS CHAR INITIAL "".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "O".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".

DEF VAR RB-NO-WAIT AS LOGICAL INITIAL NO.

define variable XX as char.
define variable YY as char.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-14 RECT-15 RECT-19 RECT-45 ~
RECT-8 RECT-9 S-CodFam S-SubFam DesdeC HastaC DesdeD HastaD COMBO-BOX-2 ~
COMBO-BOX-1 fecha-d fecha-h orden-report Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS S-CodFam S-SubFam DesdeC HastaC DesdeD ~
HastaD COMBO-BOX-2 COMBO-BOX-1 fecha-d fecha-h orden-report 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-COMBO-BOX-1 
       MENU-ITEM m_Adicionar    LABEL "Adicionar"     
       MENU-ITEM m_Eliminar     LABEL "Eliminar"      .

DEFINE MENU POPUP-MENU-COMBO-BOX-2 
       MENU-ITEM m_Adicionar2   LABEL "Adicionar"     
       MENU-ITEM m_Eliminar2    LABEL "Eliminar"      .


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.35
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.38
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marcas" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 36.14 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 36.43 BY 1 NO-UNDO.

DEFINE VARIABLE orden-report AS CHARACTER FORMAT "X(256)":U INITIAL "Materiales por Almacen x Codigo" 
     LABEL "Orden de Reporte" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Materiales por Almacen x Codigo","Materiales por Almacen x Descrip","Materiales por Almacen x Marca","Materiales por Almacen x Proveed" 
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .69 NO-UNDO.

DEFINE VARIABLE DesdeD AS CHARACTER FORMAT "X(256)":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .69 NO-UNDO.

DEFINE VARIABLE fecha-d AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE fecha-h AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .69 NO-UNDO.

DEFINE VARIABLE HastaD AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .73 NO-UNDO.

DEFINE VARIABLE S-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 4.43 BY .69 NO-UNDO.

DEFINE VARIABLE S-SubFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Sub-Familia" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.72 BY 2.04.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.57 BY 1.38.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.57 BY 1.35.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.57 BY 1.31.

DEFINE RECTANGLE RECT-45
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54.14 BY 1.42.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.72 BY 1.23.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.72 BY 1.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     S-CodFam AT ROW 1.81 COL 15.86 COLON-ALIGNED
     S-SubFam AT ROW 1.85 COL 40.86 COLON-ALIGNED
     DesdeC AT ROW 3.62 COL 15.86 COLON-ALIGNED
     HastaC AT ROW 3.58 COL 40.72 COLON-ALIGNED
     DesdeD AT ROW 5.54 COL 9.43 COLON-ALIGNED
     HastaD AT ROW 6.38 COL 9.43 COLON-ALIGNED
     COMBO-BOX-2 AT ROW 8.31 COL 12.72 COLON-ALIGNED
     COMBO-BOX-1 AT ROW 9.69 COL 13 COLON-ALIGNED
     fecha-d AT ROW 11.85 COL 14.72 COLON-ALIGNED
     fecha-h AT ROW 11.96 COL 39.29 COLON-ALIGNED
     orden-report AT ROW 13.23 COL 17.14 COLON-ALIGNED
     Btn_OK AT ROW 14.85 COL 9
     Btn_Cancel AT ROW 14.88 COL 34
     RECT-10 AT ROW 5.31 COL 4.72
     RECT-14 AT ROW 7.96 COL 4.86
     RECT-15 AT ROW 9.5 COL 4.86
     RECT-19 AT ROW 11.62 COL 4.86
     RECT-45 AT ROW 13.04 COL 1.43
     RECT-8 AT ROW 1.62 COL 4.86
     RECT-9 AT ROW 3.27 COL 4.86
     "  Fecha de Ingreso" VIEW-AS TEXT
          SIZE 13.57 BY .5 AT ROW 11.35 COL 4.43
          BGCOLOR 1 FGCOLOR 15 
     "  Descripcion" VIEW-AS TEXT
          SIZE 9.86 BY .5 AT ROW 4.92 COL 5
          BGCOLOR 1 FGCOLOR 15 
     "  Codigo" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 3.15 COL 5.29
          BGCOLOR 1 FGCOLOR 15 
     SPACE(45.84) SKIP(12.99)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Materiales por Almacen".

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   Custom                                                               */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

ASSIGN 
       COMBO-BOX-1:POPUP-MENU IN FRAME D-Dialog       = MENU POPUP-MENU-COMBO-BOX-1:HANDLE.

ASSIGN 
       COMBO-BOX-2:POPUP-MENU IN FRAME D-Dialog       = MENU POPUP-MENU-COMBO-BOX-2:HANDLE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Materiales por Almacen */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN DesdeC DesdeD S-CodFam HastaC HastaD  combo-box-1 combo-box-2
  S-subfam fecha-d fecha-h orden-report.
  RUN Imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC D-Dialog
ON LEAVE OF DesdeC IN FRAME D-Dialog /* Desde */
DO:
  IF INPUT DesdeC = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
                      Almmmatg.CodMat = INPUT DesdeC NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC D-Dialog
ON LEAVE OF HastaC IN FRAME D-Dialog /* Hasta */
DO:
  IF INPUT HastaC = "" THEN RETURN.
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
                      Almmmatg.CodMat = INPUT HastaC NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Adicionar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Adicionar D-Dialog
ON CHOOSE OF MENU-ITEM m_Adicionar /* Adicionar */
DO:
   do with frame {&FRAME-NAME}:
   input-var-1 = "MK".
   run lkup/c-almtab.r ("MARCAS").
   IF output-var-1 <> ? then do:
      if COMBO-BOX-1:add-last(output-var-3) then .
      if xx = "" then xx = output-var-2.
      else xx = xx + "," + output-var-2.
   end.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Adicionar2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Adicionar2 D-Dialog
ON CHOOSE OF MENU-ITEM m_Adicionar2 /* Adicionar */
DO:
   do with frame {&FRAME-NAME}:
   input-var-1 = "MK".
   run lkup/c-provee.r ("PROVEEDORES").
   IF output-var-1 <> ? then do:
      if COMBO-BOX-2:add-last(output-var-3) then .
      if yy = "" then yy = output-var-2.
      else yy = yy + "," + output-var-2.
   end.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Eliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Eliminar D-Dialog
ON CHOOSE OF MENU-ITEM m_Eliminar /* Eliminar */
DO:
   do with frame {&FRAME-NAME}:
   assign COMBO-BOX-1.
   if COMBO-BOX-1:delete(lookup(COMBO-BOX-1,COMBO-BOX-1:list-items)) then .
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Eliminar2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Eliminar2 D-Dialog
ON CHOOSE OF MENU-ITEM m_Eliminar2 /* Eliminar */
DO:
   do with frame {&FRAME-NAME}:
   assign COMBO-BOX-2.
   if COMBO-BOX-2:delete(lookup(COMBO-BOX-2,COMBO-BOX-2:list-items)) then .
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY S-CodFam S-SubFam DesdeC HastaC DesdeD HastaD COMBO-BOX-2 COMBO-BOX-1 
          fecha-d fecha-h orden-report 
      WITH FRAME D-Dialog.
  ENABLE RECT-10 RECT-14 RECT-15 RECT-19 RECT-45 RECT-8 RECT-9 S-CodFam 
         S-SubFam DesdeC HastaC DesdeD HastaD COMBO-BOX-2 COMBO-BOX-1 fecha-d 
         fecha-h orden-report Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime D-Dialog 
PROCEDURE imprime :
/*--------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
----------------------------------------------------------------------------*/
    RB-REPORT-NAME = orden-report.

    
    SESSION:DATE-FORMAT = "mdy".
    
    RB-FILTER = "Almmmatg.CodCia = " + STRING(S-CODCIA) +
                " AND Almmmate.CodAlm = '" + STRING(S-CODALM) + "'".
                
    IF S-CodFam <> "" THEN 
       RB-FILTER = RB-FILTER + " AND Almmmatg.codfam = '" + S-CodFam + "'".
    IF S-SubFam <> "" THEN 
       RB-FILTER = RB-FILTER + " AND Almmmatg.codfam = '" + S-SubFam + "'".
    IF DesdeC <> "" THEN
       RB-FILTER = RB-FILTER + " AND Almmmatg.CodMat >= '" + DesdeC + "'".
    IF HastaC <> "" THEN
       RB-FILTER = RB-FILTER + " AND Almmmatg.CodMat <= '" + HastaC + "'".
    IF DesdeD <> "" THEN
       RB-FILTER = RB-FILTER + " AND Almmmatg.DesMat >= '" + DesdeD + "'".
    IF HastaD <> "" THEN
       RB-FILTER = RB-FILTER + " AND Almmmatg.DesMat <= '" + HastaD + "'".
   
    IF yy <> "" THEN
       RB-FILTER = RB-FILTER + " AND  lookup(Almmmatg.Codpr1,'" + YY + "') > 0".   

    IF XX <> "" THEN
       RB-FILTER = RB-FILTER + " AND  lookup(Almmmatg.CodMar,'" + XX + "') > 0".   

    IF fecha-d <> ? THEN 
       RB-FILTER = RB-FILTER + " AND Almmmatg.fching >= " + STRING(fecha-d).

    IF fecha-h <> ? THEN 
       RB-FILTER = RB-FILTER + " AND Almmmatg.fching <= " + STRING(fecha-h).


    RB-OTHER-PARAMETERS = "GsNomCia = " + S-NOMCIA + "~nGsTitulo = " + S-CODALM + "-" + S-DESALM.

    RUN lib\_imprime.r(RB-REPORT-LIBRARY, RB-REPORT-NAME,
        RB-INCLUDE-RECORDS, RB-FILTER, RB-OTHER-PARAMETERS).                            
        
    SESSION:DATE-FORMAT = "dmy".     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
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
        WHEN "DesdeC" THEN ASSIGN input-var-1 = S-CODALM.
        WHEN "HastaC" THEN ASSIGN input-var-1 = S-CODALM.
        /*
            ASSIGN
                input-var-1 = ""
                input-var-2 = ""
                input-var-3 = "".
         */      
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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


