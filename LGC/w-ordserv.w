&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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

DEF VAR TITU2 AS CHAR.

def var x-moneda as integer.
/*VARIABLES LOCALES*/
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA  AS INTEGER.
DEFINE SHARED VAR s-NomCia AS CHAR.

DEF VAR s-coddoc AS CHAR INIT 'O/S'.

DEFINE TEMP-TABLE t-tempo 
    FIELD t-nrodoc  LIKE lg-coser.nrodoc
    FIELD t-fchdoc  LIKE lg-coser.fchdoc
    FIELD t-codpro  LIKE lg-coser.codpro
    FIELD t-glosa   LIKE lg-coser.glosa
    FIELD t-imptot  LIKE lg-coser.imptot
    FIELD t-codmon  LIKE lg-coser.codmon
    FIELD t-nompro  LIKE gn-prov.nompro
    FIELD t-cndcmp  LIKE lg-coser.cndcmp
    FIELD t-codser  LIKE lg-doser.codser
    FIELD t-desser  LIKE lg-doser.desser.

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
&Scoped-Define ENABLED-OBJECTS fechaD fechaH x-proveedor x-CodCco x-CodSer ~
x-Userid-com TOGGLE-1 Btn_OK Btn_OK-2 Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS fechaD fechaH x-proveedor x-nompro ~
x-CodCco x-NomCco x-CodSer x-NomSer x-Userid-com TOGGLE-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.46
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.42
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK-2 AUTO-GO 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.42
     BGCOLOR 8 .

DEFINE VARIABLE fechaD AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .81 NO-UNDO.

DEFINE VARIABLE fechaH AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodCco AS CHARACTER FORMAT "X(256)":U 
     LABEL "Centro de Costo" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodSer AS CHARACTER FORMAT "X(256)":U 
     LABEL "Servicio" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomCco AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE x-nompro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .81 NO-UNDO.

DEFINE VARIABLE x-NomSer AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .81 NO-UNDO.

DEFINE VARIABLE x-proveedor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .81 NO-UNDO.

DEFINE VARIABLE x-Userid-com AS CHARACTER FORMAT "X(10)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE TOGGLE-1 AS LOGICAL INITIAL no 
     LABEL "Resumido" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fechaD AT ROW 1.58 COL 12 COLON-ALIGNED
     fechaH AT ROW 1.58 COL 29 COLON-ALIGNED
     x-proveedor AT ROW 2.54 COL 12 COLON-ALIGNED
     x-nompro AT ROW 2.54 COL 25 COLON-ALIGNED NO-LABEL
     x-CodCco AT ROW 3.5 COL 12 COLON-ALIGNED
     x-NomCco AT ROW 3.5 COL 20 COLON-ALIGNED NO-LABEL
     x-CodSer AT ROW 4.46 COL 12 COLON-ALIGNED
     x-NomSer AT ROW 4.46 COL 25 COLON-ALIGNED NO-LABEL
     x-Userid-com AT ROW 5.42 COL 12 COLON-ALIGNED WIDGET-ID 6
     TOGGLE-1 AT ROW 6.58 COL 14
     Btn_OK AT ROW 7.54 COL 6
     Btn_OK-2 AT ROW 7.54 COL 19 WIDGET-ID 2
     Btn_Cancel AT ROW 7.54 COL 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 73.29 BY 8.35
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
         TITLE              = "Orden Servicios"
         HEIGHT             = 8.35
         WIDTH              = 73.29
         MAX-HEIGHT         = 9.27
         MAX-WIDTH          = 73.29
         VIRTUAL-HEIGHT     = 9.27
         VIRTUAL-WIDTH      = 73.29
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
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN x-NomCco IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-nompro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-NomSer IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Orden Servicios */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Orden Servicios */
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
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  RUN Asigna-Variables.
  RUN Inhabilita.
  RUN Imprime.
  RUN Habilita.
  RUN Inicializa-Variables.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK-2 W-Win
ON CHOOSE OF Btn_OK-2 IN FRAME F-Main /* Aceptar */
DO:
  
  RUN Asigna-Variables.
  RUN Inhabilita.
  IF TOGGLE-1 = NO THEN RUN Excel.
  ELSE RUN Excel2.
  RUN Habilita.
  RUN Inicializa-Variables.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodCco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodCco W-Win
ON LEAVE OF x-CodCco IN FRAME F-Main /* Centro de Costo */
DO:
  x-NomCco:SCREEN-VALUE = ''.
  FIND Cb-Auxi WHERE cb-auxi.codcia = 0
    AND cb-auxi.clfaux = 'CCO'
    AND cb-auxi.codaux = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE cb-auxi
  THEN x-NomCco:SCREEN-VALUE = cb-auxi.Nomaux.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-CodSer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-CodSer W-Win
ON LEAVE OF x-CodSer IN FRAME F-Main /* Servicio */
DO:
  x-NomSer:SCREEN-VALUE = ''.
  FIND Lg-Serv WHERE lg-serv.codser = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE Lg-Serv THEN x-NomSer:SCREEN-VALUE = LG-SERV.desser.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-proveedor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-proveedor W-Win
ON LEAVE OF x-proveedor IN FRAME F-Main /* Proveedor */
DO:
  IF x-proveedor:screen-value = "" THEN DO:
     X-NOMPRO:SCREEN-VALUE = "".
     RETURN.
  END.
  FIND GN-PROV WHERE GN-PROV.CODCIA = PV-CODCIA AND
                GN-PROV.CODPRO = x-proveedor:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF NOT AVAILABLE GN-PROV THEN DO:
    MESSAGE "Codigo de proveedor no existe" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO x-proveedor.
    RETURN NO-APPLY.
  END.  
  X-NOMPRO:SCREEN-VALUE = GN-PROV.NOMPRO.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables W-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  Assign fechaD fechaH x-proveedor x-nompro x-CodCco x-CodSer x-NomCco x-NomSer
    TOGGLE-1 x-Userid-com.
  Titu2 = "Del " + STRING(FechaD,"99/99/9999") + " Al " + STRING(FechaH,"99/99/9999").   
END.

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

  FOR EACH t-tempo:
    DELETE t-tempo.
  END.
  
FOR EACH lg-coser NO-LOCK WHERE 
        lg-coser.codcia = s-codcia AND
        lg-coser.fchdoc >= fechaD AND
        lg-coser.fchdoc <= fechaH AND
        lg-coser.codpro = x-proveedor:
        
FIND FIRST lg-doser where lg-doser.nrodoc = lg-coser.nrodoc no-lock NO-ERROR.
CREATE t-tempo.
IF AVAILABLE lg-coser
THEN do: ASSIGN
         t-tempo.t-fchdoc  = lg-coser.fchdoc
         t-tempo.t-nrodoc  = lg-coser.nrodoc
         t-tempo.t-glosa   = lg-coser.glosa
         t-tempo.t-imptot  = lg-coser.imptot
         t-tempo.t-codmon  = lg-coser.codmon.
                   
END.  
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal1 W-Win 
PROCEDURE Carga-Temporal1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*  FOR EACH t-tempo:
 *     DELETE t-tempo.
 *   END.
 *   
 * FOR EACH lg-coser no-lock WHERE 
 *         lg-coser.codcia = s-codcia AND
 *         lg-coser.fchdoc >= fechaD AND
 *         lg-coser.fchdoc <= fechaH:
 *        
 * 
 *     CREATE t-tempo.
 *     ASSIGN
 *          t-tempo.t-fchdoc  = lg-coser.fchdoc
 *          t-tempo.t-nrodoc  = lg-coser.nrodoc
 *          t-tempo.t-codpro  = lg-coser.codpro
 *          t-tempo.t-glosa   = lg-coser.glosa
 *          t-tempo.t-codmon  = lg-coser.codmon
 *          t-tempo.t-imptot  = lg-coser.imptot.
 *                    
 * END.  */


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
  DISPLAY fechaD fechaH x-proveedor x-nompro x-CodCco x-NomCco x-CodSer x-NomSer 
          x-Userid-com TOGGLE-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE fechaD fechaH x-proveedor x-CodCco x-CodSer x-Userid-com TOGGLE-1 
         Btn_OK Btn_OK-2 Btn_Cancel 
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
DEFINE VARIABLE cFila1 AS CHAR FORMAT 'X' INIT ''.
DEFINE VARIABLE cFila2 AS CHAR FORMAT 'X' INIT ''.

DEFINE VAR x-Cco AS CHAR FORMAT 'x(20)' NO-UNDO.
DEFINE VAR x-Moneda AS CHAR FORMAT 'x(3)' NO-UNDO.
DEFINE VAR x-NomPro AS CHAR FORMAT 'x(40)' NO-UNDO.
DEFINE VAR x-ImpMn  AS DEC NO-UNDO.
DEFINE VAR x-ImpUs  AS DEC NO-UNDO.
  
/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

t-column = t-column + 1. 
cColumn = STRING(t-Column).
cRange = "D" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "RELACIONES DE ORDENDES DE SERVICIO DESDE " + STRING(fechaD,"99/99/9999") + " HASTA " + STRING(FechaH,"99/99/9999").
t-column = t-column + 1. 
cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "FECHA".
cRange = "B" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "NRO. DOCUMENTO".
cRange = "C" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "PROVEEDOR".
cRange = "D" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "COD. SERVICIO".
cRange = "E" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "DESCRIPCION".
cRange = "F" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "REFERENCIA".
cRange = "G" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "CCO".
cRange = "H" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "MON".
cRange = "I" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "IMPORTE S/.".
cRange = "J" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "IMPORTE $".
cRange = "K" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "USUARIO".


FOR EACH LG-COSER WHERE lg-coser.codcia = s-codcia
    AND lg-coser.coddoc = s-coddoc
    AND lg-coser.fchdoc >= fechaD AND lg-coser.fchdoc <= fechaH
    AND lg-coser.codpro BEGINS x-proveedor 
    AND (x-Userid-com = "" OR LG-COSer.Usuario BEGINS x-Userid-com)
    NO-LOCK,
    EACH LG-DOSER OF LG-COSER NO-LOCK WHERE lg-doser.CCo BEGINS x-CodCco
        AND lg-doser.codser BEGINS x-CodSer
        BREAK BY lg-coser.nrodoc:

    x-Cco = ''.
    FIND CB-AUXI WHERE cb-auxi.codcia = 0
        AND cb-auxi.clfaux = 'CCO'
        AND cb-auxi.codaux = lg-doser.cco NO-LOCK NO-ERROR.
    IF AVAILABLE cb-auxi THEN x-Cco = cb-auxi.nomaux.
    ASSIGN 
        x-Cco = lg-doser.cco       /* <<< OJO >>> RHC 22.03.05 */
        x-Moneda = IF lg-coser.codmon = 1 THEN "S/." ELSE "US$"
        x-NomPro = '???'.

    FIND GN-PROV WHERE gn-prov.codcia = PV-CODCIA
        AND gn-prov.codpro = lg-coser.codpro NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN x-NomPro = gn-prov.nompro.
    

    t-column = t-column + 1.                                                                                                                               
    cColumn = STRING(t-Column).                                                                                        
    cRange = "A" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = lg-coser.fchdoc.
    cRange = "B" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = "'" + STRING(lg-coser.nrodoc).
    cRange = "C" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = x-nompro.
    cRange = "D" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = lg-doser.codser.    
    cRange = "E" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = lg-doser.desser.
    cRange = "F" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = lg-coser.nroref.
    cRange = "G" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = x-cco.
    cRange = "H" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = x-moneda.

    IF lg-coser.codmon = 1 THEN DO:
        cRange = "I" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = lg-doser.ImpTot.
    END.
    IF lg-coser.codmon = 2 THEN DO:
        cRange = "J" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = lg-doser.ImpTot.
    END.
    cRange = "K" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = lg-coser.usuario.
END.        

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel2 W-Win 
PROCEDURE Excel2 :
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
DEFINE VARIABLE cFila1 AS CHAR FORMAT 'X' INIT ''.
DEFINE VARIABLE cFila2 AS CHAR FORMAT 'X' INIT ''.

DEFINE VAR x-Cco AS CHAR FORMAT 'x(20)' NO-UNDO.
DEFINE VAR x-Moneda AS CHAR FORMAT 'x(3)' NO-UNDO.
DEFINE VAR x-NomPro AS CHAR FORMAT 'x(40)' NO-UNDO.
DEFINE VAR x-ImpMn  AS DEC NO-UNDO.
DEFINE VAR x-ImpUs  AS DEC NO-UNDO.
  
/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

t-column = t-column + 1. 
cColumn = STRING(t-Column).
cRange = "D" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "RELACIONES DE ORDENDES DE SERVICIO DESDE " + STRING(fechaD,"99/99/9999") + " HASTA " + STRING(FechaH,"99/99/9999").
t-column = t-column + 1. 
cColumn = STRING(t-Column).
cRange = "A" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "FECHA".
cRange = "B" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "NRO. DOCUMENTO".
cRange = "C" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "PROVEEDOR".
cRange = "D" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "****ASUNTO****".
cRange = "E" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "REFERENCIA".
cRange = "F" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "MON".
cRange = "G" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "IMPORTE S/.".
cRange = "H" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "IMPORTE $".
cRange = "I" + cColumn.                                                                                                                                
chWorkSheet:Range(cRange):Value = "USUARIO".

FOR EACH LG-COSER NO-LOCK WHERE lg-coser.codcia = s-codcia
    AND lg-coser.coddoc = s-coddoc
    AND lg-coser.fchdoc >= fechaD AND lg-coser.fchdoc <= fechaH
    AND lg-coser.codpro BEGINS x-proveedor 
    AND (x-Userid-com = "" OR LG-COSer.Usuario BEGINS x-Userid-com)
    AND lg-coser.flgsit <> 'A'
        BY lg-coser.nrodoc:

    ASSIGN 
        x-Moneda = IF lg-coser.codmon = 1 THEN "S/." ELSE "US$"
        x-NomPro = '???'.

    FIND GN-PROV WHERE gn-prov.codcia = PV-CODCIA
        AND gn-prov.codpro = lg-coser.codpro NO-LOCK NO-ERROR.

    IF AVAILABLE gn-prov THEN x-NomPro = gn-prov.nompro.

    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = lg-coser.fchdoc.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + STRING(lg-coser.nrodoc).
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = x-nompro.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = lg-coser.observaciones.    
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = lg-coser.nroref .
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = x-moneda.
    IF lg-coser.codmon = 1 THEN DO:
        cRange = "G" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = lg-coser.ImpTot.
    END.
    IF lg-coser.codmon = 2 THEN DO:
        cRange = "H" + cColumn.                                                                                                                                
        chWorkSheet:Range(cRange):Value = lg-doser.ImpTot.
    END.
    cRange = "I" + cColumn.                                                                                                                                
    chWorkSheet:Range(cRange):Value = lg-coser.usuario.
END.  

/* launch Excel so it is visible to the user */
chExcelApplication:VISIBLE = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR x-Cco AS CHAR FORMAT 'x(20)' NO-UNDO.
  DEFINE VAR x-Moneda AS CHAR FORMAT 'x(3)' NO-UNDO.
  DEFINE VAR x-NomPro AS CHAR FORMAT 'x(40)' NO-UNDO.
  DEFINE VAR x-ImpMn  AS DEC NO-UNDO.
  DEFINE VAR x-ImpUs  AS DEC NO-UNDO.
  
  DEFINE FRAME F-Cab
    lg-coser.fchdoc COLUMN-LABEL "Fecha"            FORMAT "99/99/99"
    lg-coser.nrodoc COLUMN-LABEL "Nro.!Docum."      
    x-NomPro        COLUMN-LABEL "Proveedor"        FORMAT "x(25)"
    lg-doser.codser COLUMN-LABEL "Cod.!Servicio"
    lg-doser.desser COLUMN-LABEL "Descripcion"      FORMAT 'x(40)'
    lg-coser.nroref COLUMN-LABEL "Referencia"       FORMAT "x(35)"
    x-Cco           COLUMN-LABEL "CCo"      
    x-Moneda        COLUMN-LABEL "Mon"
    /*lg-doser.ImpTot COLUMN-LABEL "Importe"          FORMAT ">>,>>9.99"*/
    x-ImpMn         COLUMN-LABEL "Importe"          FORMAT ">>,>>9.99"
    x-ImpUs         COLUMN-LABEL "Importe"          FORMAT ">>,>>9.99"
  WITH WIDTH 200 NO-BOX STREAM-IO DOWN.

  DEFINE FRAM F-Header
    HEADER
        s-NomCia FORMAT 'x(50)' SKIP
        "REPORTE DE ORDENES DE SERVICIO" AT 50
        "Pagina :" TO 140 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
        "Desde : " STRING(fechaD,"99/99/99") "Al" STRING(fechaH,"99/99/99")
        "Hora   :" TO 140 STRING(TIME,"HH:MM") SKIP
  WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO.
    
  FOR EACH LG-COSER WHERE lg-coser.codcia = s-codcia
      AND lg-coser.coddoc = s-coddoc
      AND lg-coser.fchdoc >= fechaD AND lg-coser.fchdoc <= fechaH
      AND lg-coser.codpro BEGINS x-proveedor 
      AND (x-Userid-com = "" OR LG-COSer.Usuario BEGINS x-Userid-com)
      NO-LOCK,
      EACH LG-DOSER OF LG-COSER NO-LOCK WHERE lg-doser.CCo BEGINS x-CodCco
      AND lg-doser.codser BEGINS x-CodSer
      BREAK BY lg-coser.nrodoc:
    x-Cco = ''.
    FIND CB-AUXI WHERE cb-auxi.codcia = 0
        AND cb-auxi.clfaux = 'CCO'
        AND cb-auxi.codaux = lg-doser.cco
        NO-LOCK NO-ERROR.
    IF AVAILABLE cb-auxi THEN x-Cco = cb-auxi.nomaux.
    x-Cco = lg-doser.cco.       /* <<< OJO >>> RHC 22.03.05 */
    x-Moneda = IF lg-coser.codmon = 1 THEN "S/." ELSE "US$".
    x-NomPro = '???'.
    FIND GN-PROV WHERE gn-prov.codcia = PV-CODCIA
        AND gn-prov.codpro = lg-coser.codpro
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN x-NomPro = gn-prov.nompro.
    VIEW STREAM REPORT FRAME F-Header.
    DISPLAY STREAM REPORT
        lg-coser.fchdoc WHEN FIRST-OF(lg-coser.nrodoc)
        lg-coser.nrodoc WHEN FIRST-OF(lg-coser.nrodoc)
        x-nompro        WHEN FIRST-OF(lg-coser.nrodoc)
        lg-doser.codser
        lg-doser.desser 
        lg-coser.nroref WHEN FIRST-OF(lg-coser.nrodoc)
        x-cco           FORMAT 'x(3)'
        x-moneda
        /*lg-doser.ImpTot */
        lg-doser.ImpTot WHEN lg-coser.codmon = 1 @ x-ImpMn
        lg-doser.ImpTot WHEN lg-coser.codmon = 2 @ x-ImpUs
        WITH FRAME F-Cab.
  END.        

END PROCEDURE.


/*
run carga-temporal.
DEFINE FRAME F-Cab
         t-tempo.t-fchdoc 
         t-tempo.t-nrodoc    space(5)
         t-tempo.t-glosa     space(18)
         t-tempo.t-codmon    space(6)
         t-tempo.t-imptot    FORMAT "->>>,>>9.99"
         
         
         WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
         assign titu2 = "ORDENES DE SERVICIOS".
         
         DEFINE FRAME H-REP
         HEADER
         "Pagina :" TO 82 PAGE-NUMBER(REPORT) TO 93 FORMAT "ZZZZZ9" SKIP
          titu2 AT 30 FORMAT 'x(60)' 
         "Desde : " AT 83 STRING(fechaD,"99/99/99") "Al" STRING(fechaH,"99/99/99") SKIP
         /*"Fecha  :" TO 90 TODAY TO 102 FORMAT "99/99/9999" SKIP*/
         "Hora   :" TO 90 STRING(TIME,"HH:MM") TO 100 SKIP
        "-----------------------------------------------------------------------------------------------------" skip
        "           Nro.                                           Imp.        "  SKIP
        " Fecha     Documento          Glosa           Moneda      Total       "  skip
        "-----------------------------------------------------------------------------------------------------" skip
  WITH PAGE-TOP WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN.
 VIEW STREAM REPORT FRAME H-REP.
  
  FOR EACH t-tempo BREAK
                     BY t-tempo.t-codpro:
 
  DISPLAY STREAM REPORT WITH FRAME F-CAB.
                   
  IF FIRST-OF(t-tempo.t-codpro) THEN DO:
       PUT STREAM REPORT "PROVEEDOR  : "  x-proveedor " " t-tempo.t-nompro   SKIP.
       PUT STREAM REPORT '------------------------------------------' SKIP.
  END.
    
 DISPLAY STREAM REPORT 
         t-tempo.t-fchdoc
         t-tempo.t-nrodoc
         t-tempo.t-glosa
         t-tempo.t-codmon 
         t-tempo.t-imptot    
                 
        WITH FRAME F-Cab.
end.  
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato1 W-Win 
PROCEDURE Formato1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR x-Cco AS CHAR FORMAT 'x(20)' NO-UNDO.
  DEFINE VAR x-Moneda AS CHAR FORMAT 'x(3)' NO-UNDO.
  DEFINE VAR x-NomPro AS CHAR FORMAT 'x(40)' NO-UNDO.
  DEFINE VAR x-ImpMn  AS DEC NO-UNDO.
  DEFINE VAR x-ImpUs  AS DEC NO-UNDO.
  
  DEFINE FRAME F-Cab
    lg-coser.fchdoc COLUMN-LABEL "Fecha"            FORMAT "99/99/99"
    lg-coser.nrodoc COLUMN-LABEL "Nro.!Docum."      
    x-NomPro        COLUMN-LABEL "Proveedor"        FORMAT "x(40)"
    lg-coser.observaciones COLUMN-LABEL "Asunto"    FORMAT "x(40)"
    lg-coser.nroref COLUMN-LABEL "Referencia"       FORMAT "x(35)"
    x-Moneda        COLUMN-LABEL "Mon"
    x-ImpMn         COLUMN-LABEL "Importe"          FORMAT ">>,>>9.99"
    x-ImpUs         COLUMN-LABEL "Importe"          FORMAT ">>,>>9.99"
  WITH WIDTH 200 NO-BOX STREAM-IO DOWN.

  DEFINE FRAM F-Header
    HEADER
        s-NomCia FORMAT 'x(50)' SKIP
        "REPORTE DE ORDENES DE SERVICIO" AT 50
        "Pagina :" TO 140 PAGE-NUMBER(REPORT) FORMAT "ZZZZZ9" SKIP
        "Desde : " STRING(fechaD,"99/99/99") "Al" STRING(fechaH,"99/99/99")
        "Hora   :" TO 140 STRING(TIME,"HH:MM") SKIP
  WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO.
    
  FOR EACH LG-COSER NO-LOCK WHERE lg-coser.codcia = s-codcia
      AND lg-coser.coddoc = s-coddoc
      AND lg-coser.fchdoc >= fechaD AND lg-coser.fchdoc <= fechaH
      AND lg-coser.codpro BEGINS x-proveedor 
      AND lg-coser.flgsit <> 'A'
      AND (x-Userid-com = "" OR LG-COSer.Usuario BEGINS x-Userid-com)
      BY lg-coser.nrodoc:
    x-Moneda = IF lg-coser.codmon = 1 THEN "S/." ELSE "US$".
    x-NomPro = '???'.
    FIND GN-PROV WHERE gn-prov.codcia = PV-CODCIA
        AND gn-prov.codpro = lg-coser.codpro
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN x-NomPro = gn-prov.nompro.
    VIEW STREAM REPORT FRAME F-Header.
    DISPLAY STREAM REPORT
        lg-coser.fchdoc 
        lg-coser.nrodoc 
        x-nompro        
        lg-coser.observaciones
        lg-coser.nroref 
        x-moneda
        lg-coser.ImpTot WHEN lg-coser.codmon = 1 @ x-ImpMn
        lg-coser.ImpTot WHEN lg-coser.codmon = 2 @ x-ImpUs
        WITH FRAME F-Cab.
  END.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilita W-Win 
PROCEDURE Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ENABLE ALL EXCEPT x-nompro x-NomCco x-NomSer.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime W-Win 
PROCEDURE imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        IF TOGGLE-1 = NO THEN RUN Formato.
        ELSE RUN Formato1.
        PAGE.
        OUTPUT STREAM REPORT CLOSE.
    END.
    OUTPUT STREAM REPORT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/D-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inhabilita W-Win 
PROCEDURE Inhabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    DISABLE ALL.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Variables W-Win 
PROCEDURE Inicializa-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  Assign fechaD fechaH x-proveedor x-nompro .

  IF x-proveedor <> "" THEN DO:
     x-proveedor = "".
     x-nompro    = "".
  END.

END.
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
     ASSIGN FechaD = TODAY
            FechaH = TODAY.
end.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
    
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
        WHEN "x-CodSer" THEN ASSIGN
                            input-var-1 = s-coddoc
                            input-var-2 = ""
                            input-var-3 = "".

        WHEN "x-CodCco" THEN ASSIGN
                            input-var-1 = "CCO"
                            input-var-2 = ""
                            input-var-3 = "".
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

