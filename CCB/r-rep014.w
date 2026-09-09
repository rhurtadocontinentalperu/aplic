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

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODDIV AS CHARACTER.

/* Local Variable Definitions ---                                       */
DEF TEMP-TABLE DETALLE 
    FIELD CodDiv AS CHAR FORMAT 'x(5)'  COLUMN-LABEL 'División'
    FIELD Usuario AS CHAR FORMAT 'x(10)' COLUMN-LABEL 'Usuario de Caja'
    FIELD FchCie LIKE Ccbccaja.fchcie   COLUMN-LABEL 'Fecha de Cierre'
    FIELD FchDoc LIKE Ccbccaja.fchdoc   COLUMN-LABEL 'Fecha de Operacion'
    FIELD CodDoc LIKE Ccbccaja.coddoc   COLUMN-LABEL 'Cod. Doc.'
    FIELD NroDoc LIKE Ccbccaja.nrodoc   COLUMN-LABEL 'Número de Doc.'
    FIELD CodCli LIKE Ccbccaja.codcli   COLUMN-LABEL 'Cliente'
    FIELD NomCli AS CHAR                COLUMN-LABEL 'Nombre'
    FIELD Tipo   AS CHAR                COLUMN-LABEL 'Tipo de Tarjeta'
    FIELD NumTar AS CHAR                COLUMN-LABEL 'Número de Tarjeta'
    FIELD Moneda AS CHAR                COLUMN-LABEL 'Moneda'
    FIELD ImpTot AS DEC                 COLUMN-LABEL 'Importe Total'
    FIELD ImpCom AS DEC                 COLUMN-LABEL 'Comisión'
    FIELD Neto   AS DEC                 COLUMN-LABEL 'Importe Neto'.

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
&Scoped-Define ENABLED-OBJECTS x-CodDiv x-FchCie-1 x-FchCie-2 Btn_OK ~
BUTTON-1 Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS x-CodDiv x-FchCie-1 x-FchCie-2 

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
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 1" 
     SIZE 11 BY 1.54.

DEFINE VARIABLE x-CodDiv AS CHARACTER FORMAT "X(256)":U 
     LABEL "Division" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "xxx","xxx"
     DROP-DOWN-LIST
     SIZE 51 BY 1 NO-UNDO.

DEFINE VARIABLE x-FchCie-1 AS DATE FORMAT "99/99/99":U 
     LABEL "Cerrados desde el" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchCie-2 AS DATE FORMAT "99/99/99":U 
     LABEL "hasta el" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodDiv AT ROW 1.58 COL 16 COLON-ALIGNED
     x-FchCie-1 AT ROW 2.92 COL 16 COLON-ALIGNED
     x-FchCie-2 AT ROW 2.92 COL 33 COLON-ALIGNED
     Btn_OK AT ROW 4.85 COL 37
     BUTTON-1 AT ROW 4.85 COL 48 WIDGET-ID 2
     Btn_Cancel AT ROW 4.85 COL 59
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
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
         TITLE              = "TARJETAS DE CREDITO EN CAJA"
         HEIGHT             = 6.15
         WIDTH              = 71.43
         MAX-HEIGHT         = 27.58
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.58
         VIRTUAL-WIDTH      = 146.29
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
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* TARJETAS DE CREDITO EN CAJA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* TARJETAS DE CREDITO EN CAJA */
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
  ASSIGN x-CodDiv x-FchCie-1 x-FchCie-2.
  RUN IMPRIMIR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
    ASSIGN x-CodDiv x-FchCie-1 x-FchCie-2.
    RUN Excel.
    MESSAGE 'Fin del Proceso' VIEW-AS ALERT-BOX INFORMATION.
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
  DISPLAY x-CodDiv x-FchCie-1 x-FchCie-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-CodDiv x-FchCie-1 x-FchCie-2 Btn_OK BUTTON-1 Btn_Cancel 
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
FOR EACH Ccbccaja NO-LOCK WHERE ccbccaja.codcia = s-codcia
    AND ccbccaja.coddoc = 'I/C'
    AND ccbccaja.coddiv = x-coddiv
    AND ccbccaja.flgest = 'C'
    AND ccbccaja.flgcie = 'C'
    AND (ccbccaja.impnac[4] > 0 OR ccbccaja.impusa[4] > 0 OR
         ccbccaja.tarptonac > 0 OR ccbccaja.tarptousa > 0)
    AND ccbccaja.fchcie >= x-FchCie-1
    AND ccbccaja.fchcie <= x-FchCie-2:
    CREATE Detalle.
    BUFFER-COPY Ccbccaja TO Detalle.
    CASE TRUE:
        WHEN (ccbccaja.impnac[4] > 0 OR ccbccaja.impusa[4] > 0) THEN DO:
            ASSIGN
                Detalle.Tipo   = Ccbccaja.Voucher[9]
                Detalle.NumTar = Ccbccaja.Voucher[4]
                Detalle.Moneda = (IF Ccbccaja.ImpNac[4] > 0 THEN 'Soles' ELSE 'Dólares')
                Detalle.ImpTot = (Ccbccaja.ImpNac[4] + Ccbccaja.ImpUsa[4]).
            FIND FacTabla WHERE FacTabla.CodCia = Ccbccaja.codcia
                AND FacTabla.Tabla = "TC"
                AND FacTabla.Codigo = ENTRY(1,Ccbccaja.Voucher[9],' ')
                NO-LOCK NO-ERROR.
            IF AVAILABLE FacTabla THEN FOR EACH VtaTabla WHERE VtaTabla.CodCia = FacTabla.CodCia
                AND VtaTabla.Tabla = FacTabla.Tabla
                AND VtaTabla.Llave_c1 = FacTabla.Codigo NO-LOCK
                BY VtaTabla.Rango_valor[1] 
                BY VtaTabla.Rango_valor[2]:
                IF Detalle.ImpTot >=  VtaTabla.Rango_Valor[1] AND Detalle.ImpTot <=  VtaTabla.Rango_Valor[2] 
                    THEN DO:
                    Detalle.ImpCom = Detalle.ImpTot * VtaTabla.Valor[1] / 100.
                    LEAVE.
                END.
            END.
            Detalle.Neto = Detalle.ImpTot - Detalle.ImpCom.
        END.
        WHEN (ccbccaja.tarptonac > 0 OR ccbccaja.tarptousa > 0) THEN DO:
            ASSIGN
                Detalle.Tipo   = Ccbccaja.TarPtoTpo
                Detalle.NumTar = Ccbccaja.TarPtoNro
                Detalle.Moneda = (IF Ccbccaja.TarPtoNac > 0 THEN 'Soles' ELSE 'Dólares')
                Detalle.ImpTot = (Ccbccaja.TarPtoNac + Ccbccaja.TarPtoUsa).
            FIND FacTabla WHERE FacTabla.CodCia = Ccbccaja.codcia
                AND FacTabla.Tabla = "TC"
                AND FacTabla.Codigo = ENTRY(1,Ccbccaja.TarPtoTpo,' ')
                NO-LOCK NO-ERROR.
            IF AVAILABLE FacTabla THEN FOR EACH VtaTabla WHERE VtaTabla.CodCia = FacTabla.CodCia
                AND VtaTabla.Tabla = FacTabla.Tabla
                AND VtaTabla.Llave_c1 = FacTabla.Codigo NO-LOCK
                BY VtaTabla.Rango_valor[1] 
                BY VtaTabla.Rango_valor[2]:
                IF Detalle.ImpTot >=  VtaTabla.Rango_Valor[1] AND Detalle.ImpTot <=  VtaTabla.Rango_Valor[2] 
                    THEN DO:
                    Detalle.ImpCom = Detalle.ImpTot * VtaTabla.Valor[1] / 100.
                    LEAVE.
                END.
            END.
            Detalle.Neto = Detalle.ImpTot - Detalle.ImpCom.
        END.
    END CASE.
END.
RUN pi-crea-archivo-csv IN hProc (INPUT BUFFER Detalle:HANDLE,
                                  INPUT c-xls-file,
                                  OUTPUT c-csv-file) .

RUN pi-crea-archivo-xls IN hProc (INPUT BUFFER Detalle:handle,
                                  INPUT  c-csv-file,
                                  OUTPUT c-xls-file) .

/* Borramos librerias de la memoria */
DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').

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
  DEF VAR RB-REPORT-LIBRARY AS CHAR.  /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.     /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR. /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.  /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "".     /* Otros parametros */
  DEF VAR x-Date AS CHAR NO-UNDO.
   
  GET-KEY-VALUE SECTION 'Startup' KEY 'Base' VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'ccb/rbccb.prl'.
  RB-REPORT-NAME = 'Relacion de Cheques en Caja'.
  RB-INCLUDE-RECORDS = "O".
  RB-FILTER = "ccbccaja.codcia = " + STRING(s-codcia) +
                " AND ccbccaja.coddoc = 'I/C'" +
                " AND ccbccaja.coddiv = '" + x-coddiv + "'" +
                " AND ccbccaja.flgest = 'C'" +
                " AND ccbccaja.flgcie = 'C'" +
                " AND (ccbccaja.impnac[4] > 0 OR ccbccaja.impusa[4] > 0)".
  x-Date = SESSION:DATE-FORMAT.
  SESSION:DATE-FORMAT = 'mdy'.
  RB-FILTER = RB-FILTER + 
                " AND ccbccaja.fchcie >= " + STRING(x-FchCie-1) +
                " AND ccbccaja.fchcie <= " + STRING(x-FchCie-2).
  SESSION:DATE-FORMAT = x-Date.
  RB-OTHER-PARAMETERS = 's-nomcia = ' + s-nomcia.
                
  RUN lib/_Imprime2 (RB-REPORT-LIBRARY,
                    RB-REPORT-NAME,
                    RB-INCLUDE-RECORDS,
                    RB-FILTER,
                    RB-OTHER-PARAMETERS).


   
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
    x-FchCie-1 = TODAY
    x-FchCie-2 = TODAY.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      x-CodDiv:DELIMITER = '|'.
      x-CodDiv:DELETE(1).
      FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.codcia = s-codcia:
          x-CodDiv:ADD-LAST(Gn-Divi.coddiv + ' - ' + GN-DIVI.DesDiv,Gn-Divi.coddiv).
      END.
      x-CodDiv:SCREEN-VALUE = s-coddiv.
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

