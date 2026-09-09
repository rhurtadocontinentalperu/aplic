&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWin
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998
          
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
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

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR cb-codcia AS INT.

DEFINE VAR s-NroMes AS INT.

DEFINE TEMP-TABLE Detalle
    FIELD KMES          AS INT FORMAT '99'
    FIELD KITEM         AS INT
    FIELD KANEXO        AS CHAR FORMAT 'x(7)'
    FIELD KCATALOGO     AS CHAR FORMAT 'x(1)'
    FIELD KTIPEXIST     AS CHAR FORMAT 'x(2)'
    FIELD KCODEXIST     AS CHAR FORMAT 'x(24)'
    FIELD KFECDOC       AS CHAR FORMAT 'x(10)'
    FIELD KTIPDOC       AS CHAR FORMAT 'x(2)'
    FIELD KSERDOC       AS CHAR FORMAT 'x(20)'
    FIELD KNUMDOC       AS CHAR FORMAT 'x(20)'
    FIELD KTIPOPE       AS CHAR FORMAT 'x(2)'
    FIELD KDESEXIST     AS CHAR FORMAT 'x(80)'
    FIELD KUNIMED       AS CHAR FORMAT 'x(3)'
    FIELD KMETVAL       AS CHAR FORMAT 'x'
    FIELD KUNIING       AS DEC FORMAT '-99999999999.99999999'
    FIELD KCOSING       AS DEC FORMAT '-99999999999.99999999'
    FIELD KTOTING       AS DEC FORMAT '-99999999999.99999999'
    FIELD KUNIRET       AS DEC FORMAT '-99999999999.99999999'
    FIELD KCOSRET       AS DEC FORMAT '-99999999999.99999999'
    FIELD KTOTRET       AS DEC FORMAT '-99999999999.99999999'
    FIELD KSALFIN       AS DEC FORMAT '-99999999999.99999999'
    FIELD KCOSFIN       AS DEC FORMAT '-99999999999.99999999'
    FIELD KTOTFIN       AS DEC FORMAT '-99999999999.99999999'
    FIELD KINTREG       AS CHAR FORMAT 'x(20)'
    INDEX Llave01 AS PRIMARY KCATALOGO KITEM.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS s-Periodo BUTTON-3 BtnDone 
&Scoped-Define DISPLAYED-OBJECTS s-Periodo FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 3" 
     SIZE 15 BY 1.62.

DEFINE VARIABLE s-Periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Seleccione el periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     s-Periodo AT ROW 2.08 COL 29 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-Mensaje AT ROW 5.31 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     BUTTON-3 AT ROW 5.31 COL 48 WIDGET-ID 8
     BtnDone AT ROW 5.31 COL 63 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 7.19 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE APPSERVER
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "KARDEX - SUNAT"
         HEIGHT             = 7.19
         WIDTH              = 80
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.14
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME fMain
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* KARDEX - SUNAT */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* KARDEX - SUNAT */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone wWin
ON CHOOSE OF BtnDone IN FRAME fMain /* Done */
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


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 wWin
ON CHOOSE OF BUTTON-3 IN FRAME fMain /* Button 3 */
DO:
    ASSIGN
        s-Periodo.

    DEF VAR pArchivo AS CHAR INIT "kardex".
    DEF VAR OKpressed AS LOG.

    SYSTEM-DIALOG GET-FILE pArchivo
        FILTERS "Archivo (txt)" "*.txt"
        ASK-OVERWRITE 
        CREATE-TEST-FILE
        DEFAULT-EXTENSION LC(".txt")
        RETURN-TO-START-DIR 
        SAVE-AS
        USE-FILENAME
        UPDATE OKpressed.
    IF OKpressed = NO THEN RETURN NO-APPLY.

    RUN Texto.

    FIND FIRST Detalle NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Detalle THEN DO:
        MESSAGE 'No hay datos que imprimir' VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END.

    OUTPUT TO VALUE(pArchivo).
    PUT UNFORMATTED
            'KMES'
        '|' 'KANEXO'
        '|' 'KCATALOGO'
        '|' 'KTIPEXIST'
        '|' 'KCODEXIST'
        '|' 'KFECDOC'
        '|' 'KTIPOPE'
        '|' 'KSERDOC'
        '|' 'KNUMDOC'
        '|' 'KTIPOPE'
        '|' 'KDESEXIST'
        '|' 'KUNIMED'
        '|' 'KMETVAL'
        '|' 'KUNIING'
        '|' 'KCOSING'
        '|' 'KTOTING'
        '|' 'KUNIRET'
        '|' 'KCOSRET'
        '|' 'KTOTRET'
        '|' 'KSALFIN'
        '|' 'KCOSFIN'
        '|' 'KTOTFIN'
        '|' 'KINTREG'
        SKIP.
    FOR EACH Detalle NO-LOCK:
        PUT /*UNFORMATTED*/
            KMES
        '|' KANEXO
        '|' KCATALOGO
        '|' KTIPEXIST
        '|' KCODEXIST
        '|' KFECDOC
        '|' KTIPOPE
        '|' KSERDOC
        '|' KNUMDOC
        '|' KTIPOPE
        '|' KDESEXIST
        '|' KUNIMED
        '|' KMETVAL
        '|' KUNIING
        '|' KCOSING
        '|' KTOTING
        '|' KUNIRET
        '|' KCOSRET
        '|' KTOTRET
        '|' KSALFIN
        '|' KCOSFIN
        '|' KTOTFIN
        '|' KINTREG
            SKIP.
    END.
    OUTPUT CLOSE.
    MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY s-Periodo FILL-IN-Mensaje 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE s-Periodo BUTTON-3 BtnDone 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
  VIEW wWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FOR EACH cb-peri NO-LOCK WHERE codcia = s-codcia WITH FRAME {&FRAME-NAME}:
       s-Periodo:ADD-LAST(STRING(CB-PERI.Periodo, '9999')).
       s-Periodo = CB-PERI.Periodo.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto wWin 
PROCEDURE Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR DesdeF AS DATE.
DEF VAR HastaF AS DATE.
DEF VAR x-Item AS INT INIT 1.
DEF VAR nCodMon AS INT INIT 1.  /* Soles */

DEFINE VAR F-Ingreso AS DECIMAL.
DEFINE VAR F-PreIng  AS DECIMAL.
DEFINE VAR F-TotIng  AS DECIMAL.
DEFINE VAR F-Salida  AS DECIMAL.
DEFINE VAR F-PreSal  AS DECIMAL.
DEFINE VAR F-TotSal  AS DECIMAL.
DEFINE VAR F-Saldo   AS DECIMAL.
DEFINE VAR F-STKGEN  AS DECIMAL.
DEFINE VAR F-PRECIO  AS DECIMAL.
DEFINE VAR F-VALCTO  AS DECIMAL.
DEFINE VARIABLE S-CODMOV AS CHAR NO-UNDO. 
DEFINE VARIABLE x-codmon LIKE Almdmov.candes NO-UNDO.

ASSIGN
    DesdeF = DATE(01,01, s-Periodo)
    HastaF = DATE(12,31, s-Periodo).

EMPTY TEMP-TABLE Detalle.
FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
    AND LOOKUP(TRIM(Almmmatg.CatConta[1]), 'AF,SV,XX') = 0,
    EACH Almdmov NO-LOCK USE-INDEX ALMD02 WHERE Almdmov.CodCia = Almmmatg.CodCia 
    AND  Almdmov.codmat = Almmmatg.CodMat 
    AND  Almdmov.FchDoc >= DesdeF 
    AND  Almdmov.FchDoc <= HastaF,
    FIRST Almtmov NO-LOCK WHERE Almtmovm.Codcia = Almdmov.Codcia 
    AND Almtmovm.TipMov = Almdmov.TipMov 
    AND Almtmovm.Codmov = Almdmov.Codmov
    AND Almtmovm.MovTrf = No,
    FIRST Almacen OF Almdmov NO-LOCK WHERE Almacen.FlgRep = Yes
    AND Almacen.AlmCsg = No
    BREAK BY Almmmatg.CodCia BY Almmmatg.CodMat BY Almdmov.FchDoc:
    
    IF FIRST-OF(Almmmatg.CodMat) THEN DO:
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "** PRODUCTO " + Almmmatg.codmat.
         /* BUSCAMOS SI TIENE MOVIMIENTOS ANTERIORES A DesdeF */
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
         CREATE Detalle.
         ASSIGN
             KMES = 01
             KITEM = x-Item
             /*KANEXO */
             /*KCATALOGO */
             /*KTIPEXIST  */
             KCODEXIST = Almmmatg.CodMat
             KFECDOC = STRING(DesdeF, '99/99/9999')
             /*KTIPDOC */
             /*KSERDOC */
             /*KNUMDOC */
             /*KTIPOPE */
             KDESEXIST = Almmmatg.DesMat
             KUNIMED = STRING(Almmmatg.UndStk, 'x(3)')
             /*KMETVAL */
             KUNIING = f-Saldo
             KCOSING = f-Precio
             KTOTING = f-ValCto
             /*KUNIRET */
             /*KCOSRET */
             /*KTOTRET */
             KSALFIN = f-Saldo
             KCOSFIN = f-Precio
             KTOTFIN = f-valCto
             /*KINTREG */
             .
         x-Item = x-Item + 1.
    END.
    FIND Almcmov WHERE Almcmov.CodCia = Almdmov.codcia 
        AND  Almcmov.CodAlm = Almdmov.codalm 
        AND  Almcmov.TipMov = Almdmov.tipmov 
        AND  Almcmov.CodMov = Almdmov.codmov 
        AND  Almcmov.NroDoc = Almdmov.nrodoc 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almcmov THEN DO:
        ASSIGN
            x-codmon = Almcmov.codmon.
    END.
    S-CODMOV  = Almdmov.TipMov + STRING(Almdmov.CodMov,"99"). 
    F-Ingreso = ( IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0 ).
    F-PreIng  = 0.
    F-TotIng  = 0.
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
    F-Salida  = ( IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN Almdmov.CanDes * Almdmov.Factor ELSE 0 ).
    F-Saldo   = Almdmov.StkAct.
    F-VALCTO = Almdmov.StkAct * Almdmov.VctoMn1.
    F-PRECIO = Almdmov.VctoMn1.
    ACCUMULATE F-Ingreso (TOTAL BY Almmmatg.CodMat).
    ACCUMULATE F-Salida  (TOTAL BY Almmmatg.CodMat).
    CREATE Detalle.
    ASSIGN
        KMES = MONTH(Almdmov.FchDoc)
        KITEM = x-Item
        /*KANEXO */
        /*KCATALOGO */
        /*KTIPEXIST  */
        KCODEXIST = Almmmatg.CodMat
        KFECDOC = STRING(Almdmov.FchDoc, '99/99/9999')
        /*KTIPDOC */
        KSERDOC = STRING(Almdmov.NroSer, '999')
        KNUMDOC = STRING(Almdmov.NroDoc)
        /*KTIPOPE */
        KDESEXIST = Almmmatg.DesMat
        KUNIMED = STRING(Almmmatg.UndStk, 'x(3)')
        /*KMETVAL */
        .
    IF Almdmov.TipMov = "I" THEN
        ASSIGN
        KUNIING = f-Ingreso
        KCOSING = (IF Almtmovm.TpoCto = 0 OR ALmtmovm.TpoCto = 1 THEN f-PreIng ELSE f-Precio)
        KTOTING = KUNIING * KCOSING
        .
    IF Almdmov.TipMov = "S" THEN
        ASSIGN
        KUNIRET = f-Salida
        KCOSRET = f-Precio
        KTOTRET = f-Salida * f-Precio.
        .
    ASSIGN
        KSALFIN = f-Saldo
        KCOSFIN = f-Precio
        KTOTFIN = f-ValCto
        /*KINTREG */
        .
    x-Item = x-Item + 1.
END.    
FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

