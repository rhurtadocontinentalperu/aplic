&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

DEF VAR x-Estado AS CHAR.
DEF VAR x-condicion AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES LG-COCmp Almacen

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 LG-COCmp.CodAlm LG-COCmp.NroDoc ~
LG-COCmp.Fchdoc LG-COCmp.CodPro LG-COCmp.NomPro ~
f_Estado(LG-COCmp.FlgSit) @ x-Estado ~
f_condicion(LG-COCmp.CndCmp) @ x-condicion LG-COCmp.Observaciones 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH LG-COCmp ~
      WHERE LG-COCmp.CodCia = s-codcia ~
 AND LOOKUP(INTEGRAL.LG-COCmp.TpoDoc, "N,C") > 0 ~
 AND LG-COCmp.CodDiv = "00000" NO-LOCK, ~
      EACH Almacen OF LG-COCmp ~
      WHERE Almacen.CodDiv = s-coddiv NO-LOCK ~
    BY LG-COCmp.NroDoc DESCENDING
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH LG-COCmp ~
      WHERE LG-COCmp.CodCia = s-codcia ~
 AND LOOKUP(INTEGRAL.LG-COCmp.TpoDoc, "N,C") > 0 ~
 AND LG-COCmp.CodDiv = "00000" NO-LOCK, ~
      EACH Almacen OF LG-COCmp ~
      WHERE Almacen.CodDiv = s-coddiv NO-LOCK ~
    BY LG-COCmp.NroDoc DESCENDING.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 LG-COCmp Almacen
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 LG-COCmp
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-1 Almacen


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-1 BUTTON-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f_Condicion W-Win 
FUNCTION f_Condicion RETURNS CHARACTER
  ( INPUT cCndCmp AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f_Estado W-Win 
FUNCTION f_Estado RETURNS CHARACTER
  ( INPUT cFlgSit AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img\print1":U
     LABEL "Button 1" 
     SIZE 10 BY 1.54.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      LG-COCmp, 
      Almacen SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 W-Win _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      LG-COCmp.CodAlm FORMAT "x(3)":U
      LG-COCmp.NroDoc FORMAT "999999":U
      LG-COCmp.Fchdoc COLUMN-LABEL "Fecha !de Emision" FORMAT "99/99/9999":U
      LG-COCmp.CodPro COLUMN-LABEL "Codigo" FORMAT "x(11)":U
      LG-COCmp.NomPro FORMAT "X(40)":U
      f_Estado(LG-COCmp.FlgSit) @ x-Estado COLUMN-LABEL "Estado" FORMAT "x(15)":U
      f_condicion(LG-COCmp.CndCmp) @ x-condicion COLUMN-LABEL "Condicion" FORMAT "x(35)":U
      LG-COCmp.Observaciones COLUMN-LABEL "Observaciones" FORMAT "x(60)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SIZE 92 BY 15.38
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-1 AT ROW 1.19 COL 2
     BUTTON-1 AT ROW 16.77 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 93.43 BY 17.5
         FONT 4.


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
         TITLE              = "Impresion de Ordenes de Compra"
         HEIGHT             = 17.5
         WIDTH              = 93.43
         MAX-HEIGHT         = 17.5
         MAX-WIDTH          = 93.43
         VIRTUAL-HEIGHT     = 17.5
         VIRTUAL-WIDTH      = 93.43
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
/* BROWSE-TAB BROWSE-1 1 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "INTEGRAL.LG-COCmp,INTEGRAL.Almacen OF INTEGRAL.LG-COCmp"
     _Options          = "NO-LOCK"
     _TblOptList       = ","
     _OrdList          = "INTEGRAL.LG-COCmp.NroDoc|no"
     _Where[1]         = "INTEGRAL.LG-COCmp.CodCia = s-codcia
 AND LOOKUP(INTEGRAL.LG-COCmp.TpoDoc, ""N,C"") > 0
 AND INTEGRAL.LG-COCmp.CodDiv = ""00000"""
     _Where[2]         = "INTEGRAL.Almacen.CodDiv = s-coddiv"
     _FldNameList[1]   = INTEGRAL.LG-COCmp.CodAlm
     _FldNameList[2]   = INTEGRAL.LG-COCmp.NroDoc
     _FldNameList[3]   > INTEGRAL.LG-COCmp.Fchdoc
"LG-COCmp.Fchdoc" "Fecha !de Emision" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.LG-COCmp.CodPro
"LG-COCmp.CodPro" "Codigo" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   = INTEGRAL.LG-COCmp.NomPro
     _FldNameList[6]   > "_<CALC>"
"f_Estado(LG-COCmp.FlgSit) @ x-Estado" "Estado" "x(15)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"f_condicion(LG-COCmp.CndCmp) @ x-condicion" "Condicion" "x(35)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > INTEGRAL.LG-COCmp.Observaciones
"LG-COCmp.Observaciones" "Observaciones" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Impresion de Ordenes de Compra */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Impresion de Ordenes de Compra */
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
  RUN Imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
/* VM - INCLUDE PARA LA CREACION DEL MENU BAR */
{src/adm/template/cntnrwin.i}

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
  ENABLE BROWSE-1 BUTTON-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR MENS AS CHARACTER.
  DEF VAR x-Ok AS LOG NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  SYSTEM-DIALOG PRINTER-SETUP UPDATE x-Ok.
  IF x-Ok = NO THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  MENS = "ALMACEN".
  IF LG-COCmp.FlgSit <> "A" THEN RUN lgc/r-impcmp(ROWID(LG-COCmp), MENS).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "LG-COCmp"}
  {src/adm/template/snd-list.i "Almacen"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f_Condicion W-Win 
FUNCTION f_Condicion RETURNS CHARACTER
  ( INPUT cCndCmp AS CHAR ):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF LOOKUP(cCndCmp,"000,001,002,003,004,005,006,007,010,011,012,013,014,025,026,029,030,031,039,040,041,042,043,100,101,102,103,104,105,107,112,115,121,125,130,135,145,160,162,163,164,165,166,305,310,312,315,318,320,360,375,376,377,378,379,380,381,382,383,384,385,390,395,396,397,398,400,807,815,830,863,864,900,999") > 0
  THEN RETURN ENTRY(LOOKUP(LG-COCmp.CndCmp,"000,001,002,003,004,005,006,007,010,011,012,013,014,025,026,029,030,031,039,040,041,042,043,100,101,102,103,104,105,107,112,115,121,125,130,135,145,160,162,163,164,165,166,305,310,312,315,318,320,360,375,376,377,378,379,380,381,382,383,384,385,390,395,396,397,398,400,807,815,830,863,864,900,999"),
  "Contado,Contado Contra Entrega,Contado Anticipado,Contra Factura,Contra Deuda,Letras Adelantadas,Deposito x Confirmar,Contado 90 Dias,Cheque del Dia,Cheque Dif. 7 dias,Cheque Dif. 10 dias,Cheque Dif. 15 dias,Cheque Dif. 20 dias,Cheque Dif. 25 dias,Cheque Dif. 30 dias,
  Cheque Dif. 45 dias,Cheque Dif. 90 dias,Cheque Dif. 60 dias,Factura 30 ds C/Devolucion,Factura 60 ds C/Devolucion,Factura 75 ds C/Devolucion,Factura 90 ds C/Devolucion,Factura 120 ds C/Devolucion,Letras Campaña,Letras Campaña Prov.Vcto. 15/20/25 Marz,Letras Campaña Lima Vcto. 10/20/30 Marz,
  Letras Campaña 30-Marzo/15-25-Abril,Letras con Vcto. 05/10/15 de Abril,Factura 03 Dias,Factura 07 Dias,Factura 10 Dias,Factura 15 Dias,Factura 20 Dias,Factura 25 Dias,Factura 30 Dias,Factura 35 Dias,Factura 45 Dias,Factura 60 Dias,Factura 90 Dias,Factura 180 Dias,Factura 120 Dias,Factura 75 Dias,
  Factura 150 Dias,Letra 105 Dias,1 Letra 30 Dias,1 Letra 35 Dias,1 Letra 15 Dias,1 Letra 20 Dias,1 Letra 45 Dias,1 Letra 60 Dias,Letra 75 Dias,2 Letras con Vcto 45/60 Dias,2 Letras con Vcto 60/75 Dias,Letras con Vcto 75/90 Dias,Letras con Vcto 60/90 Dias,Letras con Vcto 90/120/150 Dias,
  Letras con Vcto 60/75/90 Dias,Letras con Vcto 90/105 Dias,Letras con Vcto 45/60/75 Dias,Letras con Vcto 75/90/105 Dias,Letras con Vcto 90/120 Dias,Letra 90 Dias,Letra 30/45 Dias,Letra 45/50/55/60 Dias,Letra 120 Dias,Letras 150 Dias,Financiamiento Bancario,Credito Consignacion-Liq 7 Dias,Credito Consignacion-Liq 15 Dias,
  Credito Consignacion-Liq 30 Dias,Credito Consignacion - Indefinido,Credito Consignacion - Fin de Campaña,Transf. Gratuita,Donacion").
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f_Estado W-Win 
FUNCTION f_Estado RETURNS CHARACTER
  ( INPUT cFlgSit AS CHAR ):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF LOOKUP(cFlgSit,"X,G,P,A,T,V,R") > 0 
  THEN RETURN ENTRY(LOOKUP(LG-COCmp.FlgSit,"X,G,P,A,T,V,R"),"Rechazado,Emitido,Aprobado,Anulado,Aten.Total,Vencida,En Revision").
  RETURN "".   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

