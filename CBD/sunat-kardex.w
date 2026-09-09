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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VARIABLE S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA AS CHARACTER.
DEFINE SHARED VARIABLE s-Periodo AS INTEGER.

DEFINE VARIABLE F-Ingreso AS DECIMAL FORMAT "->>>,>>9.99" NO-UNDO.
DEFINE VARIABLE F-PreIng AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE F-TotIng AS DECIMAL FORMAT "->>>,>>9.99" NO-UNDO.
DEFINE VARIABLE F-Salida AS DECIMAL FORMAT "->>>,>>9.99" NO-UNDO.
DEFINE VARIABLE F-Saldo AS DECIMAL FORMAT "->>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE F-STKGEN AS DECIMAL FORMAT "->>>,>>9.99" NO-UNDO.
DEFINE VARIABLE F-PRECIO AS DECIMAL FORMAT "->>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE F-VALCTO AS DECIMAL FORMAT "->>,>>>,>>9.99" NO-UNDO.
DEFINE VARIABLE dTotIng AS DECIMAL NO-UNDO.
DEFINE VARIABLE dTotSal AS DECIMAL NO-UNDO.
DEFINE VARIABLE S-SUBTIT AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE FI-MENSAJE AS CHARACTER FORMAT "X(40)" NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-NroMes nCodMon Btn_TXT BtnDone 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-NroMes nCodMon x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 8 BY 1.73
     BGCOLOR 8 .

DEFINE BUTTON Btn_TXT 
     IMAGE-UP FILE "img\tbldat":U
     LABEL "Texto" 
     SIZE 12 BY 1.73 TOOLTIP "Salida a texto".

DEFINE VARIABLE COMBO-BOX-NroMes AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Mes" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "01","02","03","04","05","06","07","08","09","10","11","12" 
     DROP-DOWN-LIST
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY .81 NO-UNDO.

DEFINE VARIABLE nCodMon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles  ", 1,
"Dolares", 2
     SIZE 19.43 BY .46 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-NroMes AT ROW 1.77 COL 18 COLON-ALIGNED WIDGET-ID 10
     nCodMon AT ROW 2.73 COL 20 NO-LABEL
     x-mensaje AT ROW 5.42 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     Btn_TXT AT ROW 6.38 COL 4
     BtnDone AT ROW 6.38 COL 16 WIDGET-ID 56
     "Moneda:" VIEW-AS TEXT
          SIZE 6.86 BY .58 AT ROW 2.73 COL 13
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.57 BY 7.96
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
         TITLE              = "Kardex General Contable - 2010"
         HEIGHT             = 7.96
         WIDTH              = 80.57
         MAX-HEIGHT         = 12.62
         MAX-WIDTH          = 93.72
         VIRTUAL-HEIGHT     = 12.62
         VIRTUAL-WIDTH      = 93.72
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT W-Win:LOAD-ICON("img\climnu3":U) THEN
    MESSAGE "Unable to load icon: img\climnu3"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
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
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Kardex General Contable - 2010 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Kardex General Contable - 2010 */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
  &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_TXT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_TXT W-Win
ON CHOOSE OF Btn_TXT IN FRAME F-Main /* Texto */
DO:

    RUN Asigna-Variables.
    RUN Inhabilita.
    RUN Texto.
    RUN Habilita.
    RUN Inicializa-Variables.

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
    ASSIGN
        COMBO-BOX-NroMes
        nCodMon.
        
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
  DISPLAY COMBO-BOX-NroMes nCodMon x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE COMBO-BOX-NroMes nCodMon Btn_TXT BtnDone 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
        ENABLE ALL.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime W-Win 
PROCEDURE Imprime :
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
        RUN Formato.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto W-Win 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE S-CODMOV AS CHARACTER NO-UNDO. 
    DEFINE VARIABLE x-codpro LIKE Almcmov.codpro NO-UNDO.
    DEFINE VARIABLE x-codcli LIKE Almcmov.codcli NO-UNDO.
    DEFINE VARIABLE x-nrorf1 LIKE Almcmov.nrorf1 NO-UNDO.
    DEFINE VARIABLE x-nrorf2 LIKE Almcmov.nrorf2 NO-UNDO.
    DEFINE VARIABLE x-codmov LIKE Almcmov.codmov NO-UNDO.
    DEFINE VARIABLE x-inggen LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-salgen LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-totgen LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-codmon LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-tpocmb LIKE Almdmov.candes NO-UNDO.
    DEFINE VARIABLE x-total AS DECIMAL NO-UNDO.
    DEFINE VARIABLE x-Archivo AS CHARACTER NO-UNDO.
    DEFINE VARIABLE x-Rpta AS LOGICAL NO-UNDO.
    DEFINE VARIABLE DesdeF AS DATE NO-UNDO.
    DEFINE VARIABLE HastaF AS DATE NO-UNDO.

    DEFINE VARIABLE KTIPEXIST AS CHAR NO-UNDO.
    DEFINE VARIABLE KTIPOPE   AS CHAR NO-UNDO.
    DEFINE VARIABLE KUNIING   AS DEC NO-UNDO.
    DEFINE VARIABLE KCOSING   AS DEC NO-UNDO.
    DEFINE VARIABLE KTOTING   AS DEC NO-UNDO.
    DEFINE VARIABLE KUNIRET   AS DEC NO-UNDO.
    DEFINE VARIABLE KCOSRET   AS DEC NO-UNDO.
    DEFINE VARIABLE KTOTRET   AS DEC NO-UNDO.
    DEFINE VARIABLE KTIPDOC   AS CHAR NO-UNDO.

    DEFINE VARIABLE pControlKardex AS LOG NO-UNDO.

    RUN src/bin/_dateif ( COMBO-BOX-NroMes, s-Periodo, OUTPUT DesdeF, OUTPUT HastaF).

    x-Archivo = 'Kardex.txt'.
    SYSTEM-DIALOG GET-FILE x-Archivo
        FILTERS 'Texto' '*.txt'
        ASK-OVERWRITE
        CREATE-TEST-FILE
        DEFAULT-EXTENSION '.txt'
        RETURN-TO-START-DIR 
        USE-FILENAME
        SAVE-AS UPDATE x-rpta.
    IF x-rpta = NO THEN RETURN.

    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= DesdeF NO-LOCK NO-ERROR.

    ASSIGN
        x-inggen = 0
        x-salgen = 0
        x-totgen = 0
        x-total  = 0.
    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= DesdeF NO-LOCK NO-ERROR.
    OUTPUT STREAM REPORT TO VALUE(x-Archivo).
    PUT STREAM REPORT UNFORMATTED
        "KMES|KANEXO|KCATALOGO|KTIPEXIST|KCODEXIST|KFECDOC|KTIPDOC|KSERDOC|KNUMDOC|"
        "KTIPOPE|KDESEXIST|KUNIMED|KMETVAL|KUNIING|KCOSING|KTOTING|"
        "KUNIRET|KCOSRET|KTOTRET|KSALFIN|KCOSFIN|KTOTFIN"
        SKIP.

    FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
        AND LOOKUP(TRIM(Almmmatg.CatConta[1]), 'AF,SV,XX') = 0 
        BY Almmmatg.codmat:
        pControlKardex = NO.
        /* Tipo de Existencia */
        KTIPEXIST = "99".
        FIND FIRST cb-tabl WHERE cb-tabl.tabla = "S05" AND cb-tabl.codcta =  Almmmatg.catconta[1]
            NO-LOCK NO-ERROR.
        IF AVAILABLE cb-tabl THEN KTIPEXIST = cb-tabl.codigo.
        /* SALDO INICIAL */
        FIND LAST AlmStkGe WHERE AlmstkGe.Codcia = Almmmatg.Codcia 
            AND AlmstkGe.CodMat = Almmmatg.CodMat 
            AND AlmstkGe.Fecha < DesdeF
            NO-LOCK NO-ERROR.
        ASSIGN
            F-STKGEN = 0
            F-SALDO  = 0
            F-PRECIO = 0
            F-VALCTO = 0.
        IF AVAILABLE AlmStkGe THEN DO:
            pControlKardex = YES.
            ASSIGN
                F-STKGEN = AlmStkGe.StkAct
                F-SALDO  = AlmStkGe.StkAct
                F-PRECIO = AlmStkGe.CtoUni
                F-VALCTO = F-STKGEN * F-PRECIO.
            PUT STREAM REPORT
                COMBO-BOX-NroMes FORMAT '99' '|'
                '|'
                '9|'
                KTIPEXIST FORMAT 'x(2)' '|'
                Almmmatg.codmat FORMAT 'x(6)' '|'
                DesdeF FORMAT '99/99/9999' '|'
                '|'
                '|'
                '|'
                '|'
                Almmmatg.desmat FORMAT 'x(80)' '|'
                Almmmatg.undstk FORMAT 'x(3)' '|'
                '1|'
                F-SALDO FORMAT '->>>>>>>>>>9.99999999' '|'
                F-PRECIO FORMAT '->>>>>>>>>>9.99999999' '|'
                F-VALCTO FORMAT '->>>>>>>>>>9.99999999' '|'
                '0.00000000|'
                '0.00000000|'
                '0.00000000|'
                F-SALDO FORMAT '->>>>>>>>>>9.99999999' '|'
                F-PRECIO FORMAT '->>>>>>>>>>9.99999999' '|'
                F-VALCTO FORMAT '->>>>>>>>>>9.99999999' '|'
                SKIP.
        END.
        FOR EACH Almdmov NO-LOCK USE-INDEX ALMD02 WHERE Almdmov.CodCia = Almmmatg.CodCia 
            AND Almdmov.codmat = Almmmatg.CodMat
            AND Almdmov.FchDoc >= DesdeF
            AND Almdmov.FchDoc <= HastaF,
            FIRST Almtmov NO-LOCK WHERE Almtmovm.Codcia = Almdmov.Codcia 
            AND Almtmovm.TipMov = Almdmov.TipMov 
            AND Almtmovm.Codmov = Almdmov.Codmov
            AND Almtmovm.Movtrf = FALSE,
            FIRST Almacen OF Almdmov NO-LOCK WHERE Almacen.FlgRep = TRUE
            AND Almacen.AlmCsg = FALSE,
            FIRST gn-divi OF Almacen NO-LOCK
            BREAK BY Almdmov.CodCia BY Almdmov.FchDoc:

            pControlKardex = YES.

            DISPLAY "Código de Artículo: " + Almmmatg.CodMat @ x-mensaje WITH FRAME {&FRAME-NAME}.
            /* Tipo de Operación */
            KTIPOPE = "01".
            FIND FIRST cb-tabl WHERE cb-tabl.tabla = "S12"
                AND cb-tabl.codcta =  STRING(Almdmov.tipmov ,'x') + STRING(Almdmov.codmov, '99')
                NO-LOCK NO-ERROR.
            IF AVAILABLE cb-tabl THEN KTIPOPE = cb-tabl.codigo.
            /* Tipo de Documento */
            KTIPDOC = "".
            FIND Facdocum WHERE Facdocum.codcia = s-codcia
                AND Facdocum.coddoc = Almcmov.codref
                NO-LOCK NO-ERROR.
            IF AVAILABLE Facdocum THEN KTIPDOC = FacDocum.CodCbd.

            ASSIGN
                x-codpro = ""
                x-codcli = ""
                x-nrorf1 = ""
                x-nrorf2 = "".
            FIND Almcmov WHERE Almcmov.CodCia = Almdmov.codcia 
                AND Almcmov.CodAlm = Almdmov.codalm 
                AND Almcmov.TipMov = Almdmov.tipmov 
                AND Almcmov.CodMov = Almdmov.codmov 
                AND Almcmov.NroDoc = Almdmov.nrodoc 
                NO-LOCK NO-ERROR.
            IF AVAILABLE Almcmov THEN DO:
                ASSIGN
                    x-codpro = Almcmov.codpro
                    x-codcli = Almcmov.codcli
                    x-nrorf1 = Almcmov.nrorf1
                    x-nrorf2 = Almcmov.nrorf2
                    x-codmon = Almcmov.codmon
                    x-tpocmb = Almcmov.tpocmb.
            END.
            ASSIGN
                S-CODMOV  = Almdmov.TipMov + STRING(Almdmov.CodMov,"99")
                F-Ingreso = IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0
                F-PreIng  = 0
                F-TotIng  = 0.
            ASSIGN
                KUNIING = 0
                KCOSING = 0
                KTOTING = 0
                KUNIRET = 0
                KCOSRET = 0
                KTOTRET = 0.
            IF nCodmon = x-Codmon THEN DO:
                IF Almdmov.Tipmov = 'I' THEN DO:
                    F-PreIng  = Almdmov.PreUni / Almdmov.Factor.
                    F-TotIng  = Almdmov.ImpCto.
                END.
                ELSE DO:
                    F-PreIng  = 0.
                    F-TotIng  = F-PreIng * F-Ingreso.
                 END.
            END.
            ELSE DO:
                IF nCodmon = 1 THEN DO:
                    IF Almdmov.Tipmov = 'I' THEN DO:
                        F-PreIng  = ROUND(Almdmov.PreUni * Almdmov.Tpocmb / Almdmov.Factor, 4).
                        F-TotIng  = (Almdmov.ImpCto * Almdmov.TpoCmb ).
                    END.
                    IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
                        F-PreIng  = 0.
                        F-TotIng  = F-PreIng * F-Ingreso.
                    END.
                END.
                ELSE DO:
                    IF Almdmov.Tipmov = 'I' THEN DO:
                        F-PreIng  = ROUND(Almdmov.PreUni / Almdmov.TpoCmb / Almdmov.Factor, 4).
                        F-TotIng  = ROUND(Almdmov.ImpCto / Almdmov.TpoCmb, 2).
                    END.
                    IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
                        F-PreIng  = 0.
                        F-TotIng  = F-PreIng * F-Ingreso.
                    END.
                END.
            END.
            F-Salida = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
            F-Saldo = Almdmov.StkAct.
            F-VALCTO = Almdmov.StkAct * Almdmov.VctoMn1.
            F-PRECIO = Almdmov.VctoMn1.

            ASSIGN
                KUNIING = F-Ingreso
                KCOSING = F-PreIng
                KTOTING = F-TotIng.
            IF Almdmov.tipmov = "S" 
                THEN ASSIGN
                KUNIRET = F-Salida
                KCOSRET = F-PRECIO
                KTOTRET = F-VALCTO.
            PUT STREAM REPORT
                COMBO-BOX-NroMes FORMAT '99' '|'
                Gn-divi.Libre_c02 FORMAT 'x(7)' '|'
                '9|'
                KTIPEXIST FORMAT 'x(2)' '|'
                Almmmatg.codmat FORMAT 'x(6)' '|'
                Almdmov.fchdoc FORMAT '99/99/9999' '|'
                KTIPDOC FORMAT 'x(2)' '|'
                Almdmov.nroser FORMAT '999' '|'
                Almdmov.nrodoc FORMAT '9999999' '|'
                KTIPOPE FORMAT 'x(2)' '|'
                Almmmatg.desmat FORMAT 'x(80)' '|'
                Almmmatg.undstk FORMAT 'x(3)' '|'
                '1|'
                KUNIING FORMAT '->>>>>>>>>>9.99999999' '|'
                KCOSING FORMAT '->>>>>>>>>>9.99999999' '|'
                KTOTING FORMAT '->>>>>>>>>>9.99999999' '|'
                KUNIRET FORMAT '->>>>>>>>>>9.99999999' '|'
                KCOSRET FORMAT '->>>>>>>>>>9.99999999' '|'
                KTOTRET FORMAT '->>>>>>>>>>9.99999999' '|'
                F-SALDO FORMAT '->>>>>>>>>>9.99999999' '|'.
            IF LAST-OF(Almdmov.CodCia) 
                THEN PUT STREAM REPORT
                Almdmov.VctoMn1 FORMAT '->>>>>>>>>>9.99999999' '|'
                F-VALCTO FORMAT '->>>>>>>>>>9.99999999' '|'
                SKIP.
            ELSE PUT STREAM REPORT '||' SKIP.
        END.    /* Almdmov */
    END.    /* Almmmatg */

    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.
    OUTPUT STREAM REPORT CLOSE.

    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMA.

END PROCEDURE.

/*
    FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA
        AND LOOKUP(TRIM(Almmmatg.CatConta[1]), 'AF,SV,XX') = 0,
        EACH Almdmov NO-LOCK USE-INDEX ALMD02 WHERE Almdmov.CodCia = Almmmatg.CodCia 
        AND Almdmov.codmat = Almmmatg.CodMat
        AND Almdmov.FchDoc >= DesdeF
        AND Almdmov.FchDoc <= HastaF,
        FIRST Almtmov NO-LOCK WHERE Almtmovm.Codcia = Almdmov.Codcia 
        AND Almtmovm.TipMov = Almdmov.TipMov 
        AND Almtmovm.Codmov = Almdmov.Codmov
        AND Almtmovm.Movtrf = FALSE,
        FIRST Almacen OF Almdmov NO-LOCK WHERE Almacen.FlgRep = TRUE
        AND Almacen.AlmCsg = FALSE,
        FIRST gn-divi OF Almacen NO-LOCK
        BREAK BY Almmmatg.CodCia BY Almmmatg.CodMat BY Almdmov.FchDoc:
        DISPLAY "Código de Artículo: " + Almmmatg.CodMat @ x-mensaje
            WITH FRAME {&FRAME-NAME}.

        /* Tipo de Existencia */
        KTIPEXIST = "99".
        FIND FIRST cb-tabl WHERE cb-tabl.tabla = "S05"
            AND cb-tabl.codcta =  Almmmatg.catconta[1]
            NO-LOCK NO-ERROR.
        IF AVAILABLE cb-tabl THEN KTIPEXIST = cb-tabl.codigo.
        /* Tipo de Operación */
        KTIPOPE = "01".
        FIND FIRST cb-tabl WHERE cb-tabl.tabla = "S12"
            AND cb-tabl.codcta =  STRING(Almdmov.tipmov ,'x') + STRING(Almdmov.codmov, '99')
            NO-LOCK NO-ERROR.
        IF AVAILABLE cb-tabl THEN KTIPOPE = cb-tabl.codigo.
        /* Tipo de Documento */
        KTIPDOC = "".
        FIND Facdocum WHERE Facdocum.codcia = s-codcia
            AND Facdocum.coddoc = Almcmov.codref
            NO-LOCK NO-ERROR.
        IF AVAILABLE Facdocum THEN KTIPDOC = FacDocum.CodCbd.

        IF FIRST-OF(Almmmatg.CodMat) THEN DO:
            /* SALDO INICIAL */
            FIND LAST AlmStkGe WHERE AlmstkGe.Codcia = Almmmatg.Codcia 
                AND AlmstkGe.CodMat = Almmmatg.CodMat 
                AND AlmstkGe.Fecha < DesdeF
                NO-LOCK NO-ERROR.
            ASSIGN
                F-STKGEN = 0
                F-SALDO  = 0
                F-PRECIO = 0
                F-VALCTO = 0.
            IF AVAILABLE AlmStkGe THEN DO:
                ASSIGN
                    F-STKGEN = AlmStkGe.StkAct
                    F-SALDO  = AlmStkGe.StkAct
                    F-PRECIO = AlmStkGe.CtoUni
                    F-VALCTO = F-STKGEN * F-PRECIO.
            END.
            PUT STREAM REPORT
                COMBO-BOX-NroMes FORMAT '99' '|'
                '|'
                '9|'
                KTIPEXIST FORMAT 'x(2)' '|'
                Almmmatg.codmat FORMAT 'x(6)' '|'
                DesdeF FORMAT '99/99/9999' '|'
                '|'
                '|'
                '|'
                '|'
                Almmmatg.desmat FORMAT 'x(80)' '|'
                Almmmatg.undstk FORMAT 'x(3)' '|'
                '1|'
                F-SALDO FORMAT '->>>>>>>>>>9.99999999' '|'
                F-PRECIO FORMAT '->>>>>>>>>>9.99999999' '|'
                F-VALCTO FORMAT '->>>>>>>>>>9.99999999' '|'
                '0.00000000|'
                '0.00000000|'
                '0.00000000|'
                F-SALDO FORMAT '->>>>>>>>>>9.99999999' '|'
                F-VALCTO FORMAT '->>>>>>>>>>9.99999999' '|'
                SKIP.
        END.
        ASSIGN
            x-codpro = ""
            x-codcli = ""
            x-nrorf1 = ""
            x-nrorf2 = "".
        FIND Almcmov WHERE Almcmov.CodCia = Almdmov.codcia 
            AND Almcmov.CodAlm = Almdmov.codalm 
            AND Almcmov.TipMov = Almdmov.tipmov 
            AND Almcmov.CodMov = Almdmov.codmov 
            AND Almcmov.NroDoc = Almdmov.nrodoc 
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almcmov THEN DO:
            ASSIGN
                x-codpro = Almcmov.codpro
                x-codcli = Almcmov.codcli
                x-nrorf1 = Almcmov.nrorf1
                x-nrorf2 = Almcmov.nrorf2
                x-codmon = Almcmov.codmon
                x-tpocmb = Almcmov.tpocmb.
        END.
        ASSIGN
            S-CODMOV  = Almdmov.TipMov + STRING(Almdmov.CodMov,"99")
            F-Ingreso = IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0
            F-PreIng  = 0
            F-TotIng  = 0.
        ASSIGN
            KUNIING = 0
            KCOSING = 0
            KTOTING = 0
            KUNIRET = 0
            KCOSRET = 0
            KTOTRET = 0.
        IF nCodmon = x-Codmon THEN DO:
            IF Almdmov.Tipmov = 'I' THEN DO:
                F-PreIng  = Almdmov.PreUni / Almdmov.Factor.
                F-TotIng  = Almdmov.ImpCto.
            END.
            ELSE DO:
                F-PreIng  = 0.
                F-TotIng  = F-PreIng * F-Ingreso.
             END.
        END.
        ELSE DO:
            IF nCodmon = 1 THEN DO:
                IF Almdmov.Tipmov = 'I' THEN DO:
                    F-PreIng  = ROUND(Almdmov.PreUni * Almdmov.Tpocmb / Almdmov.Factor, 4).
                    F-TotIng  = (Almdmov.ImpCto * Almdmov.TpoCmb ).
                END.
                IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
                    F-PreIng  = 0.
                    F-TotIng  = F-PreIng * F-Ingreso.
                END.
            END.
            ELSE DO:
                IF Almdmov.Tipmov = 'I' THEN DO:
                    F-PreIng  = ROUND(Almdmov.PreUni / Almdmov.TpoCmb / Almdmov.Factor, 4).
                    F-TotIng  = ROUND(Almdmov.ImpCto / Almdmov.TpoCmb, 2).
                END.
                IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
                    F-PreIng  = 0.
                    F-TotIng  = F-PreIng * F-Ingreso.
                END.
            END.
        END.
        F-Salida = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
        F-Saldo = Almdmov.StkAct.
        F-VALCTO = Almdmov.StkAct * Almdmov.VctoMn1.
        F-PRECIO = Almdmov.VctoMn1.

        ASSIGN
            KUNIING = F-Ingreso
            KCOSING = F-PreIng
            KTOTING = F-TotIng.
        IF Almdmov.tipmov = "S" 
            THEN ASSIGN
            KUNIRET = F-Salida
            KCOSRET = F-PRECIO
            KTOTRET = F-VALCTO.
        PUT STREAM REPORT
            COMBO-BOX-NroMes FORMAT '99' '|'
            Gn-divi.Libre_c02 FORMAT 'x(7)' '|'
            '9|'
            KTIPEXIST FORMAT 'x(2)' '|'
            Almmmatg.codmat FORMAT 'x(6)' '|'
            Almdmov.fchdoc FORMAT '99/99/9999' '|'
            KTIPDOC FORMAT 'x(2)' '|'
            Almdmov.nroser FORMAT '999' '|'
            Almdmov.nrodoc FORMAT '9999999' '|'
            KTIPOPE FORMAT 'x(2)' '|'
            Almmmatg.desmat FORMAT 'x(80)' '|'
            Almmmatg.undstk FORMAT 'x(3)' '|'
            '1|'
            KUNIING FORMAT '->>>>>>>>>>9.99999999' '|'
            KCOSING FORMAT '->>>>>>>>>>9.99999999' '|'
            KTOTING FORMAT '->>>>>>>>>>9.99999999' '|'
            KUNIRET FORMAT '->>>>>>>>>>9.99999999' '|'
            KCOSRET FORMAT '->>>>>>>>>>9.99999999' '|'
            KTOTRET FORMAT '->>>>>>>>>>9.99999999' '|'
            F-SALDO FORMAT '->>>>>>>>>>9.99999999' '|'.
        IF LAST-OF(Almmmatg.CodMat) 
            THEN PUT STREAM REPORT
            Almdmov.VctoMn1 FORMAT '->>>>>>>>>>9.99999999' '|'
            F-VALCTO FORMAT '->>>>>>>>>>9.99999999' '|'
            SKIP.
        ELSE PUT STREAM REPORT '||' SKIP.
    END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

