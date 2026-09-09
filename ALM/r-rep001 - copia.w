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
{src/bin/_prns.i}   /* Para la impresion */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHAR.

DEFINE VAR S-CODMOV LIKE ALMTMOVM.CODMOV.
FIND FacDocum WHERE codcia = s-codcia 
    AND coddoc = 'D/F'
    NO-LOCK NO-ERROR.
IF AVAILABLE facdocum THEN S-CODMOV = facdocum.codmov.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

DEFINE BUFFER DMOV FOR Almdmov.

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
&Scoped-Define ENABLED-OBJECTS x-CodAlm FILL-IN-CodCli FILL-IN-Fecha-1 ~
FILL-IN-Fecha-2 Btn_Ok Btn_Done 
&Scoped-Define DISPLAYED-OBJECTS x-CodAlm FILL-IN-CodCli FILL-IN-NomCli ~
FILL-IN-Fecha-1 FILL-IN-Fecha-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_Ok 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 15 BY 1.54.

DEFINE VARIABLE x-CodAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacen" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde el dia" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta el dia" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-CodAlm AT ROW 1.38 COL 15 COLON-ALIGNED
     FILL-IN-CodCli AT ROW 2.54 COL 15 COLON-ALIGNED
     FILL-IN-NomCli AT ROW 2.54 COL 27 COLON-ALIGNED NO-LABEL
     FILL-IN-Fecha-1 AT ROW 3.5 COL 15 COLON-ALIGNED
     FILL-IN-Fecha-2 AT ROW 4.46 COL 15 COLON-ALIGNED
     Btn_Ok AT ROW 6.19 COL 6
     Btn_Done AT ROW 6.19 COL 23
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
         TITLE              = "REPORTE DE DEVOLUCIONES DE CLIENTES"
         HEIGHT             = 8.12
         WIDTH              = 71.86
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
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* REPORTE DE DEVOLUCIONES DE CLIENTES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* REPORTE DE DEVOLUCIONES DE CLIENTES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Done
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Done W-Win
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Cancelar */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Ok W-Win
ON CHOOSE OF Btn_Ok IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN x-CodAlm FILL-IN-CodCli FILL-IN-Fecha-1 FILL-IN-Fecha-2.
  IF FILL-IN-CodCli <> ''
  THEN DO:
    FIND GN-CLIE WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = FILL-IN-CodCli
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE GN-CLIE
    THEN DO:
        MESSAGE 'Cliente no registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FILL-IN-CodCli.
        RETURN NO-APPLY.
    END.
  END.
  RUN Imprimir.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli W-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Cliente */
DO:
  FILL-IN-NomCli:SCREEN-VALUE = ''.
  FIND GN-CLIE WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = SELF:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE GN-CLIE THEN FILL-IN-NomCli:SCREEN-VALUE = gn-clie.nomcli.
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
  DISPLAY x-CodAlm FILL-IN-CodCli FILL-IN-NomCli FILL-IN-Fecha-1 FILL-IN-Fecha-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE x-CodAlm FILL-IN-CodCli FILL-IN-Fecha-1 FILL-IN-Fecha-2 Btn_Ok 
         Btn_Done 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
  DEF VAR x-NomCli LIKE gn-clie.nomcli.
  DEF VAR x-ImpLin AS DEC  NO-UNDO.
  DEF VAR x-Moneda AS CHAR NO-UNDO.

  DEFINE FRAME FD-REP
    Almdmov.codmat COLUMN-LABEL "Codigo"
    Almmmatg.desmat COLUMN-LABEL "Descripcion"
    Almdmov.CanDes COLUMN-LABEL "Cantidad"
    Almdmov.CodUnd COLUMN-LABEL "Und"       FORMAT 'x(5)'
    Almdmov.ImpLin COLUMN-LABEL "Importe"   FORMAT ">>>,>>9.99"
    WITH WIDTH 200 NO-BOX STREAM-IO DOWN. 
    
  DEFINE FRAME FC-REP
    SKIP(1)
    "       Numero:" Almcmov.nroser almcmov.nrodoc "Fecha:" AT 40 almcmov.fchdoc "Importe:" AT 66 x-Moneda FORMAT "x(3)" x-ImpLin FORMAT ">>>,>>9.99" SKIP
    "      Cliente:" almcmov.codcli x-nomcli FORMAT "x(33)" SKIP
    "   Referencia:" almcmov.codref FORMAT 'x(3)' almcmov.nrorf1 FORMAT 'x(10)' "Guias:" AT 40 ccbcdocu.nroref FORMAT 'x(20)' SKIP
    "Observaciones:" almcmov.observ FORMAT 'x(50)' SKIP
    "          O/D:" ccbcdocu.libre_c02 FORMAT 'XXX-XXXXXXXX'
    WITH WIDTH 200 NO-BOX NO-LABELS STREAM-IO DOWN. 

  DEFINE FRAME H-REP
    HEADER
    S-NOMCIA FORMAT "X(45)" SKIP
    "( " + X-CODALM + ")"  FORMAT "X(15)"
    "REPORTE DE DEVOLUCIONES DE CLIENTES" AT 30
    "Pag.  : " AT 110 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
    "Desde : " FILL-IN-Fecha-1 FORMAT "99/99/9999" "hasta el" FILL-IN-Fecha-2 FORMAT "99/99/9999"
    "Fecha : " AT 110 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP(1)
    WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS STREAM-IO CENTERED DOWN. 

  FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = S-CODCIA 
        AND Almcmov.CodAlm = x-CODALM 
        AND Almcmov.TipMov = "I" 
        AND Almcmov.CodMov = S-CODMOV
        AND Almcmov.FchDoc >= FILL-IN-Fecha-1
        AND Almcmov.FchDoc <= FILL-IN-Fecha-2
        AND Almcmov.CodCli BEGINS FILL-IN-CodCli
        AND Almcmov.flgest <> "A",
        FIRST Ccbcdocu WHERE ccbcdocu.codcia = almcmov.codcia
            AND ccbcdocu.coddoc = almcmov.codref
            AND ccbcdocu.nrodoc = almcmov.nrorf1 NO-LOCK,
        EACH Almdmov OF Almcmov NO-LOCK,
        FIRST Almmmatg OF Almdmov NO-LOCK
        BREAK BY Almcmov.CodCia BY Almcmov.NroDoc :
       
    DISPLAY Almcmov.NroDoc @ Fi-Mensaje LABEL "Numero"
        FORMAT "X(11)" 
        WITH FRAME F-Proceso.

    VIEW STREAM REPORT FRAME H-REP.
    IF FIRST-OF(Almcmov.NroDoc)
    THEN DO:
        x-NomCli = ''.
        FIND GN-CLIE WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = almcmov.codcli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN x-NomCli = gn-clie.nomcli.
        x-Moneda = IF Almcmov.codmon = 1 THEN 'S/.' ELSE 'US$'.
        x-ImpLin = 0.
        FOR EACH dmov OF Almcmov NO-LOCK:
            x-ImpLin = x-ImpLin + dmov.implin.
        END.
        DISPLAY STREAM REPORT
            Almcmov.Nroser  
            Almcmov.Nrodoc  
            Almcmov.FchDoc  
            x-Moneda
            x-ImpLin
            Almcmov.codref
            Almcmov.nrorf1
            Ccbcdocu.nroref
            Almcmov.CodCli  
            x-NomCli        
            Almcmov.Observ
            Ccbcdocu.libre_c02
            WITH FRAME FC-REP.      
        ACCUMULATE x-implin (TOTAL BY Almcmov.codcia).
    END.

    DISPLAY STREAM REPORT
        Almdmov.codmat 
        Almmmatg.desmat
        Almdmov.CanDes 
        Almdmov.CodUnd 
        Almdmov.ImpLin 
        WITH FRAME FD-REP.
    
    IF LAST-OF(Almcmov.codcia)
    THEN DO:
        UNDERLINE STREAM REPORT
            almdmov.candes
            almdmov.implin
            WITH FRAME FD-REP.
        DISPLAY STREAM REPORT
            "TOTAL" @ almdmov.candes
            ACCUM TOTAL BY Almcmov.codcia x-implin @ almdmov.implin
            WITH FRAME FD-REP.
    END.
  END.  
  HIDE FRAME F-PROCESO.

END PROCEDURE.


/* ******************* RHC 11.11.04 FORMATO ANTERIOR
  DEF VAR x-NomCli LIKE gn-clie.nomcli.
  DEF VAR x-ImpLin AS DEC  NO-UNDO.
  DEF VAR x-Moneda AS CHAR NO-UNDO.
  

  DEFINE FRAME FD-REP
    Almdmov.codmat COLUMN-LABEL "Codigo"
    Almmmatg.desmat COLUMN-LABEL "Descripcion"
    Almdmov.CanDes COLUMN-LABEL "Cantidad"
    Almdmov.CodUnd COLUMN-LABEL "Und"
    Almdmov.ImpLin COLUMN-LABEL "Importe"
    WITH WIDTH 200 NO-BOX STREAM-IO DOWN. 
    
  DEFINE FRAME FC-REP
    Almcmov.Nroser  COLUMN-LABEL "Serie"
    Almcmov.Nrodoc  COLUMN-LABEL "Numero"
    Almcmov.FchDoc  COLUMN-LABEL "Fecha"    FORMAT "99/99/9999"
    x-Moneda        COLUMN-LABEL "Mon"      FORMAT "x(3)"
    x-ImpLin        COLUMN-LABEL "Importe"  FORMAT ">>,>>9.99"
    Almcmov.CodRef  COLUMN-LABEL "Doc"      FORMAT "x(3)"
    Almcmov.NroRf1  COLUMN-LABEL "Numero"   FORMAT "x(10)"
    Ccbcdocu.nroref COLUMN-LABEL "Guia(s)"  FORMAT "x(20)"
    Almcmov.CodCli  COLUMN-LABEL "Cliente"
    x-NomCli        COLUMN-LABEL "Nombre / Razon Social" FORMAT 'x(33)'
    Almcmov.Observ  COLUMN-LABEL "Observaciones"    FORMAT "x(40)"
    WITH WIDTH 200 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME H-REP
    HEADER
    S-NOMCIA FORMAT "X(45)" SKIP
    "( " + X-CODALM + ")"  FORMAT "X(15)"
    "REPORTE DE DEVOLUCIONES DE CLIENTES" AT 30
    "Pag.  : " AT 110 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
    "Desde : " FILL-IN-Fecha-1 FORMAT "99/99/9999" "hasta el" FILL-IN-Fecha-2 FORMAT "99/99/9999"
    "Fecha : " AT 110 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP(1)
    WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = S-CODCIA 
        AND Almcmov.CodAlm = x-CODALM 
        AND Almcmov.TipMov = "I" 
        AND Almcmov.CodMov = S-CODMOV
        AND Almcmov.FchDoc >= FILL-IN-Fecha-1
        AND Almcmov.FchDoc <= FILL-IN-Fecha-2
        AND Almcmov.CodCli BEGINS FILL-IN-CodCli
        AND Almcmov.flgest <> "A",
        FIRST Ccbcdocu WHERE ccbcdocu.codcia = almcmov.codcia
            AND ccbcdocu.coddoc = almcmov.codref
            AND ccbcdocu.nrodoc = almcmov.nrorf1 NO-LOCK
        EACH Almdmov OF Almcmov NO-LOCK,
        FIRST Almmmatg OF Almdmov NO-LOCK,
        BREAK BY Almcmov.CodCia BY Almcmov.NroDoc :
       
    DISPLAY Almcmov.NroDoc @ Fi-Mensaje LABEL "Numero"
        FORMAT "X(11)" 
        WITH FRAME F-Proceso.

    VIEW STREAM REPORT FRAME H-REP.
    x-NomCli = ''.
    FIND GN-CLIE WHERE gn-clie.codcia = 0
        AND gn-clie.codcli = almcmov.codcli
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN x-NomCli = gn-clie.nomcli.
    x-Moneda = IF Almcmov.codmon = 1 THEN 'S/.' ELSE 'US$'.
    x-ImpLin = 0.
    FOR EACH Almdmov OF Almcmov NO-LOCK:
        x-ImpLin = x-ImpLin + Almdmov.implin.
    END.
    DISPLAY STREAM REPORT
        Almcmov.Nroser  
        Almcmov.Nrodoc  
        Almcmov.FchDoc  
        x-Moneda
        x-ImpLin
        Almcmov.codref
        Almcmov.nrorf1
        Ccbcdocu.nroref
        Almcmov.CodCli  
        x-NomCli        
        WITH FRAME FC-REP.      
    ACCUMULATE x-implin (TOTAL BY Almcmov.codcia).
    IF LAST-OF(Almcmov.codcia)
    THEN DO:
        UNDERLINE STREAM REPORT
            almcmov.nrodoc
            x-implin
            WITH FRAME FC-REP.
        DISPLAY STREAM REPORT
            "TOTAL" @ almcmov.nrodoc
            ACCUM TOTAL BY Almcmov.codcia x-implin @ x-implin
            WITH FRAME FC-REP.
    END.
  END.  
  HIDE FRAME F-PROCESO.
************************************ */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
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
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
        RUN formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

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
    ASSIGN
        FILL-IN-Fecha-1 = TODAY - DAY(TODAY) + 1
        FILL-IN-Fecha-2 = TODAY.
    FOR EACH Almacen WHERE almacen.codcia = s-codcia NO-LOCK:
        x-CodAlm:ADD-LAST(almacen.codalm).
    END.
    x-CodAlm = s-CodAlm.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

