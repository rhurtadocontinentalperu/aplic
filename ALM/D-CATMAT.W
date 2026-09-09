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
DEFINE VAR I-TPOREP AS INTEGER INIT 1.

DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEF VAR RB-REPORT-LIBRARY AS CHAR.
RB-REPORT-LIBRARY = RUTA + "alm\rbalm.prl".

DEF VAR RB-REPORT-NAME AS CHAR INITIAL "".
DEF VAR RB-INCLUDE-RECORDS AS CHAR INITIAL "O".
DEF VAR RB-FILTER AS CHAR INITIAL "".
DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".

/* Local Variable Definitions ---                                       */

define variable XX as char.
define variable yy as char.
Define var sub-tit as char.

/* Definimos Variables de impresoras */
DEFINE VARIABLE s-printer-list AS CHAR NO-UNDO.
DEFINE VARIABLE s-port-list AS CHAR NO-UNDO.
DEFINE VARIABLE s-port-name AS CHAR format "x(20)" NO-UNDO.
DEFINE VARIABLE s-printer-count AS INTEGER NO-UNDO.
DEFINE NEW SHARED VARIABLE s-pagina-final     AS INTEGER.
DEFINE NEW SHARED VARIABLE s-pagina-inicial   AS INTEGER.
DEFINE NEW SHARED VARIABLE s-salida-impresion AS INTEGER.
DEFINE NEW SHARED VARIABLE s-printer-name     AS CHARACTER.
DEFINE NEW SHARED VARIABLE s-print-file       AS CHARACTER.
DEFINE NEW SHARED VARIABLE s-nro-copias       AS INTEGER.
DEFINE NEW SHARED VARIABLE s-orientacion      AS INTEGER.
DEFINE STREAM REPORT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-14 RECT-15 RECT-18 RECT-19 ~
RECT-45 RECT-9 S-CodFam S-SubFam DesdeC HastaC DesdeD HastaD C-Proveedor ~
C-Marcas fecha-h fecha-d orden-report Btn_OK-2 Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS S-CodFam S-SubFam DesdeC HastaC DesdeD ~
HastaD C-Proveedor C-Marcas fecha-h fecha-d orden-report 

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
     SIZE 12 BY 1.38
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK-2 AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.46
     BGCOLOR 8 .

DEFINE VARIABLE C-Marcas AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marcas" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 36.72 BY 1 NO-UNDO.

DEFINE VARIABLE C-Proveedor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 36.43 BY 1 NO-UNDO.

DEFINE VARIABLE orden-report AS CHARACTER FORMAT "X(256)":U INITIAL "Catalogo de Materiales x Codigo" 
     LABEL " Orden de Reporte" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "Catalogo de Materiales x Codigo","Catalogo de Materiales x Descrip","Catalogo de Materiales x Proveed","Catalogo de Materiales x Marca" 
     SIZE 38.72 BY 1 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Art. Desde" 
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
     LABEL "Art. Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .69 NO-UNDO.

DEFINE VARIABLE HastaD AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .69 NO-UNDO.

DEFINE VARIABLE S-CodFam AS CHARACTER FORMAT "X(2)":U 
     LABEL "Familia" 
     VIEW-AS FILL-IN 
     SIZE 4.43 BY .69 NO-UNDO.

DEFINE VARIABLE S-SubFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Sub-Familia" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.14 BY 2.04.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.14 BY 1.38.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.29 BY 1.35.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.29 BY 1.35.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.14 BY 1.31.

DEFINE RECTANGLE RECT-45
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54.14 BY 1.42.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.29 BY 1.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     S-CodFam AT ROW 1.85 COL 14.14 COLON-ALIGNED
     S-SubFam AT ROW 1.85 COL 36.29 COLON-ALIGNED
     DesdeC AT ROW 3.65 COL 20 COLON-ALIGNED
     HastaC AT ROW 3.69 COL 43.57 COLON-ALIGNED
     DesdeD AT ROW 5.69 COL 12.14 COLON-ALIGNED
     HastaD AT ROW 6.54 COL 12.14 COLON-ALIGNED
     C-Proveedor AT ROW 8.38 COL 16 COLON-ALIGNED
     C-Marcas AT ROW 9.92 COL 15.43 COLON-ALIGNED
     fecha-h AT ROW 12.04 COL 41.14 COLON-ALIGNED
     fecha-d AT ROW 11.96 COL 20.43 COLON-ALIGNED
     orden-report AT ROW 13.62 COL 15 COLON-ALIGNED
     Btn_OK-2 AT ROW 14.96 COL 15.57
     Btn_Cancel AT ROW 15 COL 37
     RECT-10 AT ROW 5.46 COL 8
     RECT-14 AT ROW 8.04 COL 8.14
     RECT-15 AT ROW 9.73 COL 8.14
     RECT-18 AT ROW 1.5 COL 8.14
     RECT-19 AT ROW 11.77 COL 8.14
     RECT-45 AT ROW 13.27 COL 2.57
     RECT-9 AT ROW 3.35 COL 8
     "  Fecha de Ingreso" VIEW-AS TEXT
          SIZE 13.57 BY .5 AT ROW 11.42 COL 8.29
          BGCOLOR 1 FGCOLOR 15 
     "  Descripcion" VIEW-AS TEXT
          SIZE 9.86 BY .5 AT ROW 5.12 COL 8.14
          BGCOLOR 1 FGCOLOR 15 
     "  Codigo" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 3.12 COL 8.14
          BGCOLOR 1 FGCOLOR 15 
     SPACE(43.57) SKIP(13.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Catalogo de Materiales".

 

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
       C-Marcas:POPUP-MENU IN FRAME D-Dialog       = MENU POPUP-MENU-COMBO-BOX-1:HANDLE.

ASSIGN 
       C-Proveedor:POPUP-MENU IN FRAME D-Dialog       = MENU POPUP-MENU-COMBO-BOX-2:HANDLE.

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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Catalogo de Materiales */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK-2 D-Dialog
ON CHOOSE OF Btn_OK-2 IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN DesdeC DesdeD S-CodFam HastaC HastaD S-SubFam orden-report C-Marcas
  C-Proveedor fecha-d fecha-h.


  RUN Imprime.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC D-Dialog
ON LEAVE OF DesdeC IN FRAME D-Dialog /* Art. Desde */
DO:
  IF INPUT DesdeC = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
                      Almmmatg.CodMat = INPUT DesdeC NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY":U TO DESDEC.     
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC D-Dialog
ON LEAVE OF HastaC IN FRAME D-Dialog /* Art. Hasta */
DO:
  IF INPUT HastaC = "" THEN RETURN.
  SELF:SCREEN-VALUE = STRING(INTEGER(SELF:SCREEN-VALUE),"999999").
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
                      Almmmatg.CodMat = INPUT HastaC NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     APPLY "ENTRY":U TO HASTAC. 
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
      if C-Marcas:add-last(output-var-3) then .
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
      if C-Proveedor:add-last(output-var-3) then .
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
   assign C-Marcas.
   if C-Marcas:delete(lookup(C-Marcas,C-Marcas:list-items)) then .
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Eliminar2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Eliminar2 D-Dialog
ON CHOOSE OF MENU-ITEM m_Eliminar2 /* Eliminar */
DO:
   do with frame {&FRAME-NAME}:
   assign C-Proveedor.
   if C-Proveedor:delete(lookup(C-Proveedor,C-Proveedor:list-items)) then .
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME orden-report
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL orden-report D-Dialog
ON VALUE-CHANGED OF orden-report IN FRAME D-Dialog /*  Orden de Reporte */
DO:
/*
CASE orden-report :
WHEN "Catalogo de Materiales x Codigo" THEN 
  FOR EACH Almmmatg WHERE
      Almmmatg.codcia = S-CODCIA AND
      Almmmatg.codfam BEGINS S-CodFam AND 
      Almmmatg.subfam BEGINS S-SubFam AND
      Almmmatg.codmat >= DesdeC AND
      Almmmatg.codmat <= HastaC AND
      Almmmatg.fching >= fecha-d AND
      Almmmatg.fching <= fecha-h 
      BREAK BY Almmmatg.codCia
            BY Almmmatg.codMat.
  END.

WHEN "Catalogo de Materiales x Descrip" THEN 
  FOR EACH Almmmatg WHERE
      Almmmatg.codcia = S-CODCIA AND
      Almmmatg.codfam BEGINS S-CodFam AND 
      Almmmatg.subfam BEGINS S-SubFam AND
      Almmmatg.codmat >= DesdeC AND
      Almmmatg.codmat <= HastaC AND
      Almmmatg.fching >= fecha-d AND
      Almmmatg.fching <= fecha-h  
      BREAK BY Almmmatg.codCia
            BY Almmmatg.Desmat.
  END.          

WHEN "Catalogo de Materiales x Proveed" THEN 
  FOR EACH Almmmatg WHERE
      Almmmatg.codcia = S-CODCIA AND
      Almmmatg.codfam BEGINS S-CodFam AND 
      Almmmatg.subfam BEGINS S-SubFam AND
      Almmmatg.codmat >= DesdeC AND
      Almmmatg.codmat <= HastaC AND
      Almmmatg.fching >= fecha-d AND
      Almmmatg.fching <= fecha-h 
      BREAK BY Almmmatg.codCia
            BY Almmmatg.CodPr1.

  END.    
WHEN "Catalogo de Materiales x Marca" THEN 
  FOR EACH Almmmatg WHERE 
      Almmmatg.codcia = S-CODCIA AND
      Almmmatg.codfam BEGINS S-CodFam AND 
      Almmmatg.subfam BEGINS S-SubFam AND
      Almmmatg.codmat >= DesdeC AND
      Almmmatg.codmat <= HastaC AND
      Almmmatg.fching >= fecha-d AND
      Almmmatg.fching <= fecha-h 
      BREAK BY Almmmatg.codCia
            BY Almmmatg.Codmar.


  END.    
END CASE.
*/
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
  DISPLAY S-CodFam S-SubFam DesdeC HastaC DesdeD HastaD C-Proveedor C-Marcas 
          fecha-h fecha-d orden-report 
      WITH FRAME D-Dialog.
  ENABLE RECT-10 RECT-14 RECT-15 RECT-18 RECT-19 RECT-45 RECT-9 S-CodFam 
         S-SubFam DesdeC HastaC DesdeD HastaD C-Proveedor C-Marcas fecha-h 
         fecha-d orden-report Btn_OK-2 Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime D-Dialog 
PROCEDURE imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    SUB-TIT = "Del " + string(Fecha-D) + " al " + string(Fecha-H).
    RB-REPORT-NAME = orden-report.   
   
    SESSION:DATE-FORMAT = "mdy".

    RB-FILTER = "Almmmatg.CodCia = " + STRING(S-CODCIA).
    IF S-CodFam <> "" THEN 
       RB-FILTER = RB-FILTER + " AND Almmmatg.codfam = '" + S-CodFam + "'".
    IF S-SubFam <> "" THEN 
       RB-FILTER = RB-FILTER + " AND Almmmatg.subfam = '" + S-SubFam + "'".

    IF DesdeC <> "" THEN
       RB-FILTER = RB-FILTER + " AND Almmmatg.CodMat >= '" + DesdeC + "'".
    IF HastaC <> "" THEN
       RB-FILTER = RB-FILTER + " AND Almmmatg.CodMat <= '" + HastaC + "'".

    IF DesdeD <> "" THEN
       RB-FILTER = RB-FILTER + " AND Almmmatg.DesMat >= '" + DesdeD + "'".
    IF HastaD <> "" THEN
       RB-FILTER = RB-FILTER + " AND Almmmatg.DesMat <= '" + HastaD + "".
   
       
    IF YY <> "" THEN
       RB-FILTER = RB-FILTER + " AND lookup(Almmmatg.CodPr1,'" + YY + "') > 0".
    
    IF XX <> "" THEN
       RB-FILTER = RB-FILTER + " AND lookup(Almmmatg.CodMar,'" + XX + "') > 0".

    IF fecha-d <> ? THEN 
       RB-FILTER = RB-FILTER + " AND Almmmatg.fching >= " + STRING(fecha-d).

    IF fecha-h <> ? THEN 
       RB-FILTER = RB-FILTER + " AND Almmmatg.fching <= " + STRING(fecha-h).


    RB-OTHER-PARAMETERS = "GsNomCia = " + S-NOMCIA +
                          "~nsub-tit = " + Sub-tit.  
    

    RUN lib\_imprime.r(RB-REPORT-LIBRARY, RB-REPORT-NAME,
        RB-INCLUDE-RECORDS, RB-FILTER, RB-OTHER-PARAMETERS).                            

    SESSION:DATE-FORMAT = "dmy".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Texto D-Dialog 
PROCEDURE Imprime-Texto :
/*---------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-----------------------------------------------------------------------------*/
  DEFINE VAR X-TEXTO AS CHARACTER.
  RUN bin/_prnctr.p.
  IF s-salida-impresion = 0 THEN RETURN.
   
  /* Captura parametros de impresion */
  /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
  
  RUN aderb/_prlist.p(
      OUTPUT s-printer-list,
      OUTPUT s-port-list,
      OUTPUT s-printer-count).
  s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
  s-port-name = REPLACE(S-PORT-NAME, ":", "").
  
  IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
     
  DEFINE VARIABLE C-DESMAR AS CHAR NO-UNDO.
  DEFINE VARIABLE C-TITULO AS CHAR FORMAT "X(40)"NO-UNDO.
  C-TITULO = orden-report.
  
  DEFINE FRAME F-Reporte
         Almmmatg.codmat COLUMN-LABEL "Codigo"   
         Almmmatg.CodAnt
         Almmmatg.codfam COLUMN-LABEL "Fam."  
         Almmmatg.subfam COLUMN-LABEL "SubF." 
         Almmmatg.DesMat
         C-DESMAR COLUMN-LABEL "Marca" FORMAT "X(15)"
         Almmmatg.CodPr1 COLUMN-LABEL "Codigo!Proveed." 
         Almmmatg.UndStk COLUMN-LABEL "Unid!Med." 
         Almmmatg.FacEqu COLUMN-LABEL "Factor!Equiv."  FORMAT ">,>>9.9999"
         Almmmatg.FchIng 
         HEADER
         S-NOMCIA FORMAT "X(50)"
         C-TITULO AT 50
         "PAGINA : " TO 113 PAGE-NUMBER(REPORT) FORMAT "ZZZZZZZZZ9" SKIP
         "FECHA : " TO 113 TODAY FORMAT "99/99/9999" SKIP
         "HORA : " TO 113 STRING(TIME,"HH:MM") SKIP(2)
         WITH WIDTH 200 NO-BOX STREAM-IO DOWN.
  
  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Pantalla */
        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 62. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62. /* Archivo */
  END CASE.
  
  PUT STREAM REPORT CONTROL CHR(27) "@".               /* Inicializa la impresora */
  PUT STREAM REPORT CONTROL CHR(27) "C" CHR(66).       /* Setea el tamaño de papel */
  PUT STREAM REPORT CONTROL CHR(27) CHR(120) CHR(0).   /* Setea calidad de impresion draf */
  PUT STREAM REPORT CONTROL CHR(27) CHR(80) CHR(15).   /* setea tamaño de caracter */
  
  /*
      LOOKUP(Almmmatg.CodPr1,YY) > 0 AND
      LOOKUP(Almmmatg.CodMar,XX) > 0
  */

  IF HastaC = "" THEN HastaC = "999999".

  FOR EACH Almmmatg NO-LOCK WHERE 
      Almmmatg.codcia = S-CODCIA AND
      Almmmatg.codfam BEGINS S-CodFam AND 
      Almmmatg.subfam BEGINS S-SubFam AND
      Almmmatg.codmat >= DesdeC AND
      Almmmatg.codmat <= HastaC AND
      Almmmatg.fching >= fecha-d AND
      Almmmatg.fching <= fecha-h
      BREAK BY Almmmatg.codCia
            BY Almmmatg.codMat: 
          
      FIND almtabla WHERE almtabla.Tabla = "MK" AND
           almtabla.Codigo = Almmmatg.CodMar NO-LOCK NO-ERROR.
      IF AVAILABLE almtabla THEN C-DesMar = almtabla.Nombre.
      ELSE C-DesMar = "".    

      DISPLAY STREAM REPORT 
         Almmmatg.codmat 
         Almmmatg.CodAnt
         Almmmatg.codfam 
         Almmmatg.subfam 
         Almmmatg.DesMat
         C-DesMar 
         Almmmatg.CodPr1 
         Almmmatg.UndStk 
         Almmmatg.FacEqu 
         Almmmatg.FchIng WITH FRAME F-Reporte.
  END. 
  PAGE STREAM REPORT.
  OUTPUT STREAM REPORT CLOSE.
  CASE s-salida-impresion:
       WHEN 1 OR WHEN 3 THEN RUN LIB/D-README.R(s-print-file). 
  END CASE. 
  
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
 ASSIGN

    Fecha-D:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY)
    fecha-H:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY).
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


