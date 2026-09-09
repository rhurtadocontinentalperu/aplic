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
DEFINE SHARED VAR PV-CODCIA AS INTEGER.

/* Local Variable Definitions ---                                       */
DEF TEMP-TABLE DETALLE 
    FIELD codcia LIKE ccbccaja.codcia
    FIELD coddiv LIKE ccbccaja.coddiv FORMAT 'x(60)'
    FIELD coddoc LIKE ccbccaja.coddoc
    FIELD fchcie LIKE ccbccaja.fchcie
    FIELD FORMA_pago AS CHAR
    FIELD totnac AS DEC FORMAT '->>>,>>>,>>9.99'
    FIELD totusa AS DEC FORMAT '->>>,>>>,>>9.99'
    INDEX Llave01 IS PRIMARY coddoc coddiv fchcie FORMA_pago.

FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 x-FchCie-1 x-FchCie-2 Btn_Excel ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS f-Division x-FchCie-1 x-FchCie-2 

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

DEFINE BUTTON Btn_Excel AUTO-GO 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE VARIABLE f-Division AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 44 BY 3.23 NO-UNDO.

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
     f-Division AT ROW 1.27 COL 14 NO-LABEL WIDGET-ID 4
     BUTTON-1 AT ROW 1.58 COL 59
     x-FchCie-1 AT ROW 4.77 COL 12 COLON-ALIGNED
     x-FchCie-2 AT ROW 5.73 COL 12 COLON-ALIGNED
     Btn_Excel AT ROW 7.27 COL 2 WIDGET-ID 2
     Btn_Cancel AT ROW 7.27 COL 13
     "Divisiones:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 1.27 COL 6 WIDGET-ID 6
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
         TITLE              = "REPORTE DETALLADO DE CIERRE DE CAJAS"
         HEIGHT             = 8.42
         WIDTH              = 71.43
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
/* SETTINGS FOR EDITOR f-Division IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DETALLADO DE CIERRE DE CAJAS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DETALLADO DE CIERRE DE CAJAS */
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


&Scoped-define SELF-NAME Btn_Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Excel W-Win
ON CHOOSE OF Btn_Excel IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN f-division x-fchcie-1 x-fchcie-2.
  IF f-division = '' THEN DO:
    MESSAGE 'Ingrese al menos una division' VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  RUN Excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ... */
DO:
  DEF VAR x-Divisiones AS CHAR.
  x-Divisiones = f-Division:SCREEN-VALUE.
  RUN vta/d-repo06 (INPUT-OUTPUT x-Divisiones).
  f-Division:SCREEN-VALUE = x-Divisiones.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR pos AS INT NO-UNDO.
  DEF VAR pCodPro AS CHAR NO-UNDO.    /* Proveedor pero solo para TICKETS */
  DEF VAR i AS INT NO-UNDO.
  DEF VAR j AS INT NO-UNDO.
  DEF VAR x-CodDiv LIKE GN-DIVI.CodDiv NO-UNDO.
  DEF VAR pForma_Pago AS CHAR NO-UNDO.
  
  EMPTY TEMP-TABLE Detalle.
  DO i = 1 TO NUM-ENTRIES(f-Division):
      x-CodDiv = ENTRY(i, f-Division).
      FOR EACH Ccbccaja NO-LOCK WHERE Ccbccaja.codcia = s-codcia
          AND Ccbccaja.coddiv = x-coddiv
          AND LOOKUP(ccbccaja.coddoc, "I/C,E/C") NE 0
          AND Ccbccaja.flgcie = 'C'
          AND Ccbccaja.fchcie >= x-fchcie-1
          AND Ccbccaja.fchcie <= x-fchcie-2
          AND ccbccaja.flgest NE "A":
          /* Definimos la "forma de pago" */
          DO j = 1 TO 10:
              IF CcbCCaja.ImpNac[j] = 0 AND CcbCCaja.Impusa[j] = 0 THEN NEXT.
              RUN Define-Tipo ( INPUT j,
                                OUTPUT pFORMA_pago,
                                OUTPUT pos,
                                OUTPUT pCodPro).
              /* Grabamos la información */
              FIND Detalle WHERE Detalle.codcia = Ccbccaja.codcia
                  AND Detalle.coddoc = Ccbccaja.coddoc
                  AND Detalle.coddiv = Ccbccaja.coddiv
                  AND Detalle.fchcie = Ccbccaja.fchcie
                  AND Detalle.FORMA_pago = pFORMA_pago
                  EXCLUSIVE-LOCK NO-ERROR.
              IF NOT AVAILABLE Detalle THEN DO:
                  CREATE Detalle.
                  ASSIGN
                      Detalle.codcia = Ccbccaja.codcia
                      Detalle.coddiv = Ccbccaja.coddiv
                      Detalle.coddoc = Ccbccaja.coddoc
                      Detalle.fchcie = Ccbccaja.fchcie
                      Detalle.FORMA_pago = pFORMA_pago.
              END.
              /* *********************** */
              ASSIGN
                  Detalle.totnac = Detalle.totnac + Ccbccaja.impnac[j] - (IF j = 1 THEN CcbCCaja.VueNac ELSE 0)
                  Detalle.totusa = Detalle.totusa + Ccbccaja.impusa[j] - (IF j = 1 THEN CcbCCaja.VueUsa ELSE 0).
          END. /* DO j = 1 TO... */
          /* RHC 06/07/2016 Tarjeta Puntos */
          IF ccbccaja.coddoc = "I/C" AND (CcbCCaja.TarPtoNac <> 0 OR CcbCCaja.TarPtoUsa <> 0) THEN DO:
              j = 11.
              pos = j.
              pCodPro = "".
              pos = 31.
              pForma_Pago = "TARJETA CANJE PUNTOS".
              /* Grabamos la información */
              FIND Detalle WHERE Detalle.codcia = Ccbccaja.codcia
                  AND Detalle.coddoc = Ccbccaja.coddoc
                  AND Detalle.coddiv = Ccbccaja.coddiv
                  AND Detalle.fchcie = Ccbccaja.fchcie
                  AND Detalle.FORMA_pago = pFORMA_pago
                  EXCLUSIVE-LOCK NO-ERROR.
              IF NOT AVAILABLE Detalle THEN DO:
                  CREATE Detalle.
                  ASSIGN
                      Detalle.codcia = Ccbccaja.codcia
                      Detalle.coddiv = Ccbccaja.coddiv
                      Detalle.coddoc = Ccbccaja.coddoc
                      Detalle.fchcie = Ccbccaja.fchcie
                      Detalle.FORMA_pago = pFORMA_pago.
              END.
              /* *********************** */
              ASSIGN
                  Detalle.totnac = Detalle.totnac + CcbCCaja.TarPtoNac
                  Detalle.totusa = Detalle.totusa + CcbCCaja.TarPtoUsa.
          END.
      END.            
  END.
  FOR EACH Detalle: 
      FIND FIRST gn-divi OF Detalle NO-LOCK NO-ERROR.
      IF AVAILABLE gn-divi THEN Detalle.coddiv = gn-divi.coddiv + ' ' + gn-divi.desdiv.
  END.
                  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Define-Tipo W-Win 
PROCEDURE Define-Tipo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER j AS INT.
DEF OUTPUT PARAMETER pFORMA_pago AS CHAR.
DEF OUTPUT PARAMETER pos AS INT.
DEF OUTPUT PARAMETER pCodPro AS CHAR.
 
CASE j:
    WHEN 1 THEN pforma_pago = "EFECTIVO".
    WHEN 2 THEN pforma_pago = "CHEQUES DEL DIA".
    WHEN 3 THEN pforma_pago = "CHEQUES DIFERIDOS".
    WHEN 4 THEN pforma_pago = "TARJETA DE CREDITO".
    WHEN 5 THEN pforma_pago = "BOLETAS DE DEPOSITO".
    WHEN 6 THEN pforma_pago = "NOTAS DE CREDITO".
    WHEN 7 THEN pforma_pago = "ANTICIPOS A/R".
    WHEN 8 THEN pforma_pago = "COMISION FACTORING".
    WHEN 9 THEN pforma_pago = "RETENCIONES".
    WHEN 10 THEN pforma_pago = "VALES DE CONSUMO".
END CASE.
/* Detalla los I/C Efectivo */
pos = j.
pCodPro = "".
CASE Ccbccaja.coddoc:
    WHEN "I/C" THEN DO:
        IF pos > 1 THEN pos = pos * 10.     /* OJO */
        ELSE CASE ccbccaja.tipo:
            WHEN "SENCILLO" THEN DO:
                pforma_pago = "EFECTIVO - SENCILLO".
                pos = 1.
            END.
            WHEN "ANTREC" THEN DO:
                pforma_pago = "EFECTIVO - ANTICIPO".
                pos = 2.
            END.
            WHEN "CANCELACION" THEN DO:
                pforma_pago = "EFECTIVO - CANCELACION".
                pos = 3.
            END.
            WHEN "MOSTRADOR" THEN DO:
                pforma_pago = "EFECTIVO - MOSTRADOR".
                pos = 4.
            END.
            OTHERWISE DO:
                pforma_pago = "EFECTIVO - OTROS".
                pos = 20.
            END.
        END CASE.
        /* RHC 08/09/2016 Separamos las Tarjetas de Crédito */
        IF j = 4 THEN DO:
            pFORMA_pago = "TARJETA" + SUBSTRING(CcbCCaja.Voucher[9],3).
            pCodPro = CcbCCaja.Voucher[9].
        END.
        /* RHC 10/11/2015 Separamos las N/C */
        IF j = 6 THEN DO:
            FIND FIRST ccbdmov WHERE ccbdmov.codcia = s-codcia
                AND ccbdmov.coddoc = 'N/C'
                AND ccbdmov.codref = ccbccaja.coddoc
                AND ccbdmov.nroref = ccbccaja.nrodoc
                NO-LOCK NO-ERROR.
            IF AVAILABLE Ccbdmov THEN DO:
                FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = ccbdmov.codcia
                    AND ccbcdocu.coddoc = ccbdmov.coddoc
                    AND ccbcdocu.nrodoc = ccbdmov.nrodoc NO-LOCK NO-ERROR.
                IF AVAILABLE Ccbcdocu THEN
                CASE CcbCDocu.Cndcre:
                    WHEN "D" THEN ASSIGN pos = 61 pforma_pago = "NOTAS DE CREDITO x DEV MERCADERIA".
                    OTHERWISE ASSIGN pos = 62 pforma_pago = "NOTAS DE CREDITO OTROS".
                END CASE.
            END.
        END.
        /* RHC 22/08/2015 Separamos los vales por proveedor */
        IF j = 10 THEN DO:
            FOR EACH VtaDTickets NO-LOCK WHERE VtaDTickets.codcia = Ccbccaja.codcia
                AND VtaDTickets.codref = Ccbccaja.coddoc
                AND VtaDTickets.nroref = Ccbccaja.nrodoc,
                FIRST VtaCTickets OF VtaDTickets NO-LOCK,
                FIRST gn-prov NO-LOCK WHERE gn-prov.codcia = pv-codcia
                AND gn-prov.codpro = Vtadtickets.codpro
                BREAK BY VtaDTickets.CodPro:
                pforma_pago = "VALES DE CONSUMO " + CAPS(gn-pro.nompro).
                pCodPro = Vtadtickets.codpro.
                LEAVE.
            END.
        END.
    END.
    WHEN "E/C" THEN DO:
        CASE ccbccaja.tipo:
            WHEN "REMEBOV" THEN DO:
                pforma_pago = "REMESA A BOVEDA".
                pos = 1.
            END.
            WHEN "REMECJC" THEN DO:
                pforma_pago = "REMESA A CAJA CENTRAL".
                pos = 2.
            END.
            WHEN "ANTREC" THEN DO:
                pforma_pago = "DEVOLUCION EFECTIVO (ANTICIPO) - IDENTIFICADO".
                pos = 3.
                IF Ccbccaja.codcli = FacCfgGn.CliVar THEN
                    ASSIGN
                    pos = 4
                    pforma_pago = "DEVOLUCION EFECTIVO (ANTICIPO) - COD GENERICO".

            END.
            WHEN "DEVONC" THEN DO:
                pforma_pago = "DEVOLUCION EFECTIVO (N/C) - IDENTIFICADO".
                pos = 5.
                IF Ccbccaja.codcli = FacCfgGn.CliVar THEN
                    ASSIGN
                    pos = 6
                    pforma_pago = "DEVOLUCION EFECTIVO (N/C) - COD GENERICO".
            END.
            WHEN "SENCILLO" THEN DO:
                pforma_pago = "SENCILLO".
                pos = 7.
            END.
            OTHERWISE DO:
                pforma_pago = "EGRESOS - OTROS".
                pos = 20.
            END.
        END CASE.
    END.
END CASE.

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
  DISPLAY f-Division x-FchCie-1 x-FchCie-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 x-FchCie-1 x-FchCie-2 Btn_Excel Btn_Cancel 
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

