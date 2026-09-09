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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-nomcia AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

/* Local Variable Definitions ---                                       */
DEF VAR s-coddoc AS CHAR INIT 'H/R' NO-UNDO.

DEF TEMP-TABLE DETALLE
    FIELD CodCia AS INT
    FIELD FchDoc LIKE Di-RutaC.FchDoc
    FIELD CodVeh LIKE Di-RutaC.CodVeh
    FIELD NroSal AS INT
    FIELD NroCli AS INT EXTENT 6
    FIELD Galones LIKE Di-CGasol.Galones
    FIELD Importe LIKE Di-CGasol.Importe
    FIELD Kilometros AS DEC
    FIELD HorTra AS DEC
    FIELD TmpPro AS DEC
    FIELD MtoDes AS DEC
    FIELD MnoObr AS DEC.
    
DEF TEMP-TABLE DETALLE-1
    FIELD CodCia AS INT
    FIELD FchDoc LIKE Di-RutaC.FchDoc
    FIELD CodVeh LIKE Di-RutaC.CodVeh
    FIELD NroSal AS INT
    FIELD TmpPro AS DEC.
    
DEF TEMP-TABLE DETALLE-2
    FIELD CodCia AS INT
    FIELD Fecha  AS DATE
    FIELD CodVeh LIKE Di-RutaC.CodVeh
    FIELD CodCli AS CHAR
    FIELD FlgEst AS CHAR.

DEF TEMP-TABLE T-RutaD LIKE Di-RutaD
    FIELD CodCli LIKE Ccbcdocu.codcli.

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
&Scoped-Define ENABLED-OBJECTS Btn_OK FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
Btn_Done x-CodMon f-Usuarios 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 x-CodMon ~
f-Usuarios 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fHorTra W-Win 
FUNCTION fHorTra RETURNS DECIMAL
  ( INPUT Parm1 AS CHAR,
    INPUT Parm2 AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done DEFAULT 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Done" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO DEFAULT 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "OK" 
     SIZE 15 BY 1.54
     BGCOLOR 8 .

DEFINE VARIABLE f-Usuarios AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usuarios" 
     VIEW-AS FILL-IN 
     SIZE 33 BY .81 TOOLTIP "Debe ingresarlos separados por una coma (Ej. DSW-00,FMG-00)" NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde el dia" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta el dia" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-CodMon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 12 BY .96 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn_OK AT ROW 1.19 COL 46
     FILL-IN-Fecha-1 AT ROW 1.38 COL 12.29 COLON-ALIGNED
     FILL-IN-Fecha-2 AT ROW 2.54 COL 12 COLON-ALIGNED
     Btn_Done AT ROW 2.73 COL 46
     x-CodMon AT ROW 3.5 COL 14 NO-LABEL
     f-Usuarios AT ROW 4.65 COL 12 COLON-ALIGNED
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 3.69 COL 7
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 64.43 BY 5.19
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
         TITLE              = "INFORME SEMANAL AREA DE DISTRIBUCION"
         HEIGHT             = 5.19
         WIDTH              = 64.43
         MAX-HEIGHT         = 5.19
         MAX-WIDTH          = 64.43
         VIRTUAL-HEIGHT     = 5.19
         VIRTUAL-WIDTH      = 64.43
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
ON END-ERROR OF W-Win /* INFORME SEMANAL AREA DE DISTRIBUCION */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* INFORME SEMANAL AREA DE DISTRIBUCION */
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
ON CHOOSE OF Btn_Done IN FRAME F-Main /* Done */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* OK */
DO:
  ASSIGN
    FILL-IN-Fecha-1 FILL-IN-Fecha-2 x-CodMon f-Usuarios.
  RUN Imprimir.
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
  DEF VAR x-ImpTot AS DEC NO-UNDO.
  DEF VAR x-DevTot AS DEC NO-UNDO.
  DEF VAR x-ImpDev AS DEC NO-UNDO.
  DEF VAR x-NroSal AS DEC NO-UNDO.
  DEF VAR x-CodCli AS CHAR INIT '20100038146'.    /* CONTINENTAL SAC */
  DEF VAR x-Periodo AS INT NO-UNDO.
  DEF VAR x-NroMes AS INT NO-UNDO.
  DEF VAR x-ValCal AS DEC NO-UNDO.
  DEF VAR x-FlgEst AS CHAR NO-UNDO.
  DEF VAR x-Usuario AS CHAR NO-UNDO.
  
  FOR EACH DETALLE:
    DELETE DETALLE.
  END.
  FOR EACH DETALLE-1:
    DELETE DETALLE-1.
  END.
  FOR EACH DETALLE-2:
    DELETE DETALLE-2.
  END.
  
  x-Usuario = TRIM(f-Usuarios).
  
  DISPLAY
    'Espere un momento por favor...' SKIP
    WITH FRAME F-Mensaje TITLE 'Procesando informacion' CENTERED OVERLAY VIEW-AS DIALOG-BOX.
  FOR EACH Di-RutaC NO-LOCK WHERE di-rutac.codcia = s-codcia
        AND di-rutac.coddiv = s-coddiv
        AND di-rutac.coddoc = s-coddoc
        AND di-rutac.fchsal >= FILL-IN-Fecha-1
        AND di-rutac.fchsal <= FILL-IN-Fecha-2
        AND di-rutac.flgest = 'C'
        AND (x-Usuario = '' OR LOOKUP(TRIM(DI-RutaC.usuario), x-Usuario) > 0),
        EACH Di-RutaD OF Di-RutaC NO-LOCK WHERE LOOKUP(di-rutad.flgest, 'C,X,D,N') > 0,
            FIRST ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = di-rutad.codcia
                AND ccbcdocu.coddoc = di-rutad.codref
                AND ccbcdocu.nrodoc = di-rutad.nroref:
    CREATE T-RutaD.
    BUFFER-COPY Di-RutaD TO T-RutaD
        ASSIGN T-RutaD.CodCli = Ccbcdocu.codcli.    
  END.                

  FOR EACH Di-RutaC NO-LOCK WHERE di-rutac.codcia = s-codcia
        AND di-rutac.coddiv = s-coddiv
        AND di-rutac.coddoc = s-coddoc
        AND di-rutac.fchsal >= FILL-IN-Fecha-1
        AND di-rutac.fchsal <= FILL-IN-Fecha-2
        AND di-rutac.flgest = 'C'
        BREAK BY Di-RutaC.CodVeh BY Di-RutaC.FchSal:
    IF FIRST-OF(Di-RutaC.CodVeh) OR FIRST-OF(Di-RutaC.FchSal)
    THEN x-NroSal = 0.
    x-NroSal = x-NroSal + 1.

    FIND DETALLE WHERE DETALLE.CodVeh = Di-RutaC.CodVeh
        AND DETALLE.FchDoc = Di-RutaC.FchSal EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE DETALLE THEN DO:   
        CREATE DETALLE.
        ASSIGN
            DETALLE.FchDoc = Di-RutaC.FchSal
            DETALLE.CodVeh = Di-RutaC.CodVeh.
        CREATE DETALLE-1.
        ASSIGN
            DETALLE-1.FchDoc = Di-RutaC.FchSal
            DETALLE-1.CodVeh = Di-RutaC.CodVeh.
    END.
    ASSIGN
        DETALLE.HorTra = DETALLE.HorTra + fHorTra(DI-RutaC.HorSal, DI-RutaC.HorRet)
        DETALLE.Kilometros = DETALLE.Kilometros + (DI-RutaC.KmtFin - DI-RutaC.KmtIni).

    /* MANO DE OBRA */
    ASSIGN
        x-Periodo = YEAR(Di-RutaC.FchSal)
        x-NroMes  = MONTH(Di-RutaC.FchSal)
        x-ValCal = 0.
    FOR EACH PL-MOV-MES WHERE PL-MOV-MES.codcia = s-codcia
            AND PL-MOV-MES.codper = Di-RutaC.Responsable
            AND PL-MOV-MES.periodo = x-Periodo
            AND PL-MOV-MES.nromes  = x-NroMes
            AND PL-MOV-MES.codcal = 001
            AND (PL-MOV-MES.CodMov = 101 
                    OR PL-MOV-MES.CodMov = 103) NO-LOCK:
        x-ValCal = x-ValCal + PL-MOV-MES.valcal-mes.
    END.        
    IF Di-RutaC.Ayudante-1 <> Di-RutaC.Responsable THEN DO:
        FOR EACH PL-MOV-MES WHERE PL-MOV-MES.codcia = s-codcia
                AND PL-MOV-MES.codper = Di-RutaC.Ayudante-1
                AND PL-MOV-MES.periodo = x-Periodo
                AND PL-MOV-MES.nromes  = x-NroMes
                AND PL-MOV-MES.codcal = 001
                AND (PL-MOV-MES.CodMov = 101 
                        OR PL-MOV-MES.CodMov = 103) NO-LOCK:
            x-ValCal = x-ValCal + PL-MOV-MES.valcal-mes.
        END.        
    END.
    IF Di-RutaC.Ayudante-2 <> Di-RutaC.Responsable THEN DO:
        FOR EACH PL-MOV-MES WHERE PL-MOV-MES.codcia = s-codcia
                AND PL-MOV-MES.codper = Di-RutaC.Ayudante-2
                AND PL-MOV-MES.periodo = x-Periodo
                AND PL-MOV-MES.nromes  = x-NroMes
                AND PL-MOV-MES.codcal = 001
                AND (PL-MOV-MES.CodMov = 101 
                        OR PL-MOV-MES.CodMov = 103) NO-LOCK:
            x-ValCal = x-ValCal + PL-MOV-MES.valcal-mes.
        END.        
    END.
    IF x-codmon = 2 THEN DO:
        FIND LAST GN-TCMB WHERE gn-tcmb.fecha <= DETALLE.FchDoc
            NO-LOCK NO-ERROR.
        IF AVAILABLE GN-TCMB THEN x-ValCal = x-ValCal / gn-tcmb.venta.
    END.            
    ASSIGN
        DETALLE.MnoObr = DETALLE.MnoObr + (x-ValCal / 30 * DETALLE.HorTra).
    
    FOR EACH Di-RutaD OF Di-RutaC NO-LOCK WHERE LOOKUP(di-rutad.flgest, 'C,X,D,N') > 0,
            FIRST ccbcdocu NO-LOCK WHERE ccbcdocu.codcia = di-rutad.codcia
                AND ccbcdocu.coddoc = di-rutad.codref
                AND ccbcdocu.nrodoc = di-rutad.nroref,
            FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
                AND gn-clie.codcli = ccbcdocu.codcli:
        /* contador de clientes */
        FIND DETALLE-2 WHERE detalle-2.fecha = di-rutac.fchsal
            AND detalle-2.codveh = di-rutac.codveh
            AND detalle-2.codcli = ccbcdocu.codcli
            AND detalle-2.flgest = di-rutad.flgest
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DETALLE-2
        THEN DO:
            x-FlgEst = DI-RUTAD.FlgEst.
            CREATE DETALLE-2.
            ASSIGN
                DETALLE-2.fecha  = di-rutac.fchsal
                DETALLE-2.codveh = di-rutac.codveh
                DETALLE-2.codcli = ccbcdocu.codcli
                DETALLE-2.flgest = di-rutad.flgest.
            IF x-FlgEst = 'C' THEN DO:
                FIND FIRST T-RutaD OF Di-RutaC WHERE T-RutaD.CodCli = Ccbcdocu.CodCli
                    AND (T-RutaD.FlgEst = 'D' OR T-RutaD.FlgEst = 'X') NO-LOCK NO-ERROR.
                IF AVAILABLE T-RutaD THEN x-FlgEst = 'D'.
            END.
            IF x-FlgEst = 'X' THEN DO:
                FIND FIRST T-RutaD OF Di-RutaC WHERE T-RutaD.CodCli = Ccbcdocu.CodCli
                    AND (T-RutaD.FlgEst = 'D' OR T-RutaD.FlgEst = 'C') NO-LOCK NO-ERROR.
                IF AVAILABLE T-RutaD THEN x-FlgEst = 'D'.
            END.
            /*CASE Di-RutaD.FlgEst:*/
            CASE x-FlgEst:
                WHEN 'C' THEN DETALLE.NroCli[1] = DETALLE.NroCli[1] + 1.
                WHEN 'N' THEN DETALLE.NroCli[2] = DETALLE.NroCli[2] + 1.
                WHEN 'D' THEN DETALLE.NroCli[3] = DETALLE.NroCli[3] + 1.
                WHEN 'X' THEN DETALLE.NroCli[4] = DETALLE.NroCli[4] + 1.
                WHEN 'R' THEN DETALLE.NroCli[5] = DETALLE.NroCli[5] + 1.
                WHEN 'NR' THEN DETALLE.NroCli[6] = DETALLE.NroCli[6] + 1.
            END CASE.
        END.    
        /* Tiempo promedio de estadia */
        IF fHorTra(DI-RutaD.HorLle, DI-RutaD.HorPar) > 0
        THEN ASSIGN
                DETALLE-1.NroSal = DETALLE-1.NroSal + 1
                DETALLE-1.TmpPro = DETALLE-1.TmpPro + fHorTra(DI-RutaD.HorLle, DI-RutaD.HorPar).
        /* Monto Despachado */
        ASSIGN
            x-ImpTot = 0
            x-DevTot = 0
            x-ImpDev = 0.    
        IF x-codmon = ccbcdocu.codmon
        THEN x-ImpTot = ccbcdocu.imptot.
        ELSE IF x-codmon = 1
                THEN x-ImpTot = ccbcdocu.imptot * ccbcdocu.tpocmb.
                ELSE x-ImpTot = ccbcdocu.imptot / ccbcdocu.tpocmb.
                            
        /* Importe de las devoluciones */
        CASE di-rutad.flgest:
            WHEN 'X' OR WHEN 'N'
            THEN x-DevTot = x-imptot.
            WHEN 'D' 
            THEN DO:
                FOR EACH Di-RutaDv WHERE di-rutadv.codcia = di-rutad.codcia
                           AND di-rutadv.coddiv = di-rutad.coddiv
                           AND di-rutadv.coddoc = di-rutad.coddoc
                           AND di-rutadv.nrodoc = di-rutad.nrodoc
                           AND di-rutadv.codref = di-rutad.codref
                           AND di-rutadv.nroref = di-rutad.nroref
                           AND di-rutadv.candev > 0
                           NO-LOCK:
                    IF x-codmon = ccbcdocu.codmon 
                    THEN x-ImpDev = di-rutadv.implin.
                    ELSE IF x-codmon = 1
                            THEN x-ImpDev = di-rutadv.implin * ccbcdocu.tpocmb.
                            ELSE x-ImpDev = di-rutadv.implin / ccbcdocu.tpocmb.
                    x-DevTot = x-DevTot + 
                                    di-rutadv.candev * (x-impdev / di-rutadv.candes).
                END.
            END.
        END CASE.
        ASSIGN
            DETALLE.MtoDes = DETALLE.MtoDes + (x-ImpTot - x-DevTot).
    END.

    /* INCLUIMOS LAS GUIAS DE REMISION */
    FOR EACH Di-RutaG OF Di-RutaC NO-LOCK WHERE LOOKUP(di-rutag.flgest, 'C,N') > 0,
            FIRST Almcmov WHERE Almcmov.codcia = di-rutag.codcia
                AND Almcmov.codalm = di-rutag.codalm
                AND Almcmov.tipmov = di-rutag.tipmov
                AND Almcmov.codmov = di-rutag.codmov
                AND Almcmov.nroser = di-rutag.serref
                AND Almcmov.nrodoc = di-rutag.nroref NO-LOCK,
            FIRST Almacen WHERE Almacen.codcia = Almcmov.codcia
                AND Almacen.codalm = Almcmov.almdes NO-LOCK:
        /* contador de clientes */
        FIND DETALLE-2 WHERE detalle-2.fecha = di-rutac.fchsal
            AND detalle-2.codveh = di-rutac.codveh
            AND detalle-2.codcli = x-codcli
            AND detalle-2.flgest = di-rutag.flgest
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE DETALLE-2
        THEN DO:
            CREATE DETALLE-2.
            ASSIGN
                DETALLE-2.fecha  = di-rutac.fchsal
                DETALLE-2.codveh = di-rutac.codveh
                DETALLE-2.codcli = x-codcli
                DETALLE-2.flgest = di-rutag.flgest.
            CASE Di-RutaG.FlgEst:
                WHEN 'C' THEN DETALLE.NroCli[1] = DETALLE.NroCli[1] + 1.
                WHEN 'N' THEN DETALLE.NroCli[2] = DETALLE.NroCli[2] + 1.
            END CASE.
        END.    
        /* Tiempo promedio de estadia */
        IF fHorTra(DI-RutaG.HorLle, DI-RutaG.HorPar) > 0
        THEN ASSIGN
                DETALLE-1.NroSal = DETALLE-1.NroSal + 1
                DETALLE-1.TmpPro = DETALLE-1.TmpPro + fHorTra(DI-RutaG.HorLle, DI-RutaG.HorPar).
    END.
    IF LAST-OF(Di-RutaC.CodVeh) OR LAST-OF(Di-RutaC.FchSal)
    THEN DETALLE.NroSal = x-NroSal.

  END.        

  FOR EACH DETALLE:
    /* COMBUSTIBLE */
    FIND Di-CGasol WHERE Di-CGasol.CodCia = s-codcia 
        AND Di-CGasol.Fecha = DETALLE.FchDoc
        AND Di-CGasol.Placa = DETALLE.CodVeh NO-LOCK NO-ERROR.
    IF AVAILABLE Di-CGasol
    THEN DO:
        ASSIGN
            DETALLE.Galones = DETALLE.Galones + Di-CGasol.galones
            x-ImpTot = Di-CGasol.importe.
        IF x-codmon = 2 THEN DO:
            FIND LAST GN-TCMB WHERE gn-tcmb.fecha <= DETALLE.FchDoc
                NO-LOCK NO-ERROR.
            IF AVAILABLE GN-TCMB THEN x-ImpTot = x-ImpTot / gn-tcmb.venta.
        END.            
        ASSIGN
            DETALLE.Importe = DETALLE.Importe + x-ImpTot.
    END.
    /* TIEMPO PROMEDIO DE ESTADIA */
    FIND DETALLE-1 WHERE DETALLE-1.codveh = DETALLE.codveh
        AND DETALLE-1.fchdoc = DETALLE.fchdoc NO-LOCK NO-ERROR.
    IF AVAILABLE DETALLE-1
    THEN DETALLE.TmpPro = DETALLE-1.TmpPro / DETALLE-1.NroSal.
  END.
  
  HIDE FRAME f-Mensaje.

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
  DISPLAY FILL-IN-Fecha-1 FILL-IN-Fecha-2 x-CodMon f-Usuarios 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE Btn_OK FILL-IN-Fecha-1 FILL-IN-Fecha-2 Btn_Done x-CodMon f-Usuarios 
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
  DEF VAR x-Nombre AS CHAR NO-UNDO.
  DEF VAR x-CanDes AS DEC INIT 0 NO-UNDO.
  DEF VAR x-ImpDes AS DEC INIT 0 NO-UNDO.
  DEF VAR x-CanDev AS DEC INIT 0 NO-UNDO.
  DEF VAR x-ImpDev AS DEC INIT 0 NO-UNDO.
  DEF VAR x-ImpTot AS DEC INIT 0 NO-UNDO.  
  DEF VAR x-PorTot AS DEC INIT 0 NO-UNDO.
  DEF VAR x-SubTit AS CHAR FORMAT 'x(50)' NO-UNDO.
  
  x-SubTit = 'IMPORTES EXPRESADOS EN ' + IF x-codmon = 1 THEN 'NUEVOS SOLES' ELSE 'DOLARES AMERICANOS'.

  DEFINE FRAME FC-REP
    DETALLE.fchdoc      COLUMN-LABEL "Dia"                         
    DETALLE.codveh      COLUMN-LABEL "Vehiculo"                     FORMAT "X(10)"
    x-Nombre            COLUMN-LABEL "Observacion"                  FORMAT "X(20)"
    DETALLE.nrosal      COLUMN-LABEL "Cantidad de!Hojas de Ruta"    FORMAT ">>>,>>9"
    DETALLE.nrocli[1]   COLUMN-LABEL "Clientes!Entregados"      
    DETALLE.nrocli[2]   COLUMN-LABEL "Clientes!No Entregados"      
    DETALLE.nrocli[3]   COLUMN-LABEL "Clientes!Dev. Parcial"      
    DETALLE.nrocli[4]   COLUMN-LABEL "Clientes!Dev. Total"      
    DETALLE.nrocli[5]   COLUMN-LABEL "Clientes!Error Docum."      
    DETALLE.nrocli[6]   COLUMN-LABEL "Clientes!No Recibido"      
    DETALLE.galones     COLUMN-LABEL "Galones!Consumidos"           FORMAT ">>>,>>9.99"
    DETALLE.importe     COLUMN-LABEL "Costo!Combustible"            FORMAT ">>>,>>9.99"
    DETALLE.Kilometros  COLUMN-LABEL "Kilometros"                   FORMAT ">>>,>>9"
    DETALLE.hortra      COLUMN-LABEL "Horas!Trabajadas"             FORMAT ">>>,>>9.99"
    DETALLE.tmppro      COLUMN-LABEL "Tiempo!Promedio"              FORMAT ">>>,>>9.99"
    DETALLE.mtodes      COLUMN-LABEL "Monto!Despachado"             FORMAT ">>>,>>>,>>9.99"
    DETALLE.mnoobr      COLUMN-LABEL "Costo!Mano de Obra"           FORMAT ">>>,>>>,>>9.99"
    WITH WIDTH 250 NO-BOX STREAM-IO DOWN. 

  DEFINE FRAME H-REP
    HEADER
    S-NOMCIA FORMAT "X(45)" SKIP
    "( " + S-CODDIV + ")"  FORMAT "X(15)"
    "INFORME SEMANAL AREA DE DISTRIBUCION" AT 30
    "Pag.  : " AT 100 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
    "Fecha : " AT 100 STRING(TODAY,"99/99/9999") FORMAT "X(12)" SKIP
    "Desde : " FILL-IN-Fecha-1 FORMAT "99/99/9999" "hasta el" FILL-IN-Fecha-2 FORMAT "99/99/9999" SKIP
    x-SubTit SKIP
    WITH PAGE-TOP WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO CENTERED DOWN. 

  FOR EACH DETALLE BREAK BY DETALLE.codcia BY DETALLE.FchDoc BY DETALLE.CodVeh:
    VIEW STREAM REPORT FRAME H-REP.
    x-Nombre = '?'.
    FIND FIRST GN-VEHIC WHERE GN-VEHIC.codcia = s-codcia
        AND GN-VEHIC.Placa = DETALLE.CodVeh NO-LOCK NO-ERROR.
    IF AVAILABLE GN-VEHIC THEN DO:
        CASE GN-VEHIC.Estado:
            WHEN '01' THEN x-Nombre = 'PROPIO'.
            WHEN '02' THEN x-Nombre = 'EXTERNO'.
        END CASE.
    END.
    DISPLAY STREAM REPORT
        DETALLE.fchdoc      
        DETALLE.codveh      
        x-Nombre
        DETALLE.nrosal      
        DETALLE.nrocli[1]   
        DETALLE.nrocli[2]   
        DETALLE.nrocli[3]   
        DETALLE.nrocli[4]   
        DETALLE.nrocli[5]   
        DETALLE.nrocli[6]   
        DETALLE.galones     
        DETALLE.importe
        DETALLE.kilometros     
        DETALLE.hortra      
        DETALLE.tmppro      
        DETALLE.mtodes      
        DETALLE.mnoobr      
        WITH FRAME FC-REP.      
    ACCUMULATE DETALLE.nrocli[1] (TOTAL BY DETALLE.codcia).
    ACCUMULATE DETALLE.nrocli[2] (TOTAL BY DETALLE.codcia).
    ACCUMULATE DETALLE.nrocli[3] (TOTAL BY DETALLE.codcia).
    ACCUMULATE DETALLE.nrocli[4] (TOTAL BY DETALLE.codcia).
    ACCUMULATE DETALLE.nrocli[5] (TOTAL BY DETALLE.codcia).
    ACCUMULATE DETALLE.nrocli[6] (TOTAL BY DETALLE.codcia).
    ACCUMULATE DETALLE.nrocli[1] (SUB-TOTAL BY DETALLE.fchdoc).
    ACCUMULATE DETALLE.nrocli[2] (SUB-TOTAL BY DETALLE.fchdoc).
    ACCUMULATE DETALLE.nrocli[3] (SUB-TOTAL BY DETALLE.fchdoc).
    ACCUMULATE DETALLE.nrocli[4] (SUB-TOTAL BY DETALLE.fchdoc).
    ACCUMULATE DETALLE.nrocli[5] (SUB-TOTAL BY DETALLE.fchdoc).
    ACCUMULATE DETALLE.nrocli[6] (SUB-TOTAL BY DETALLE.fchdoc).
    ACCUMULATE DETALLE.mtodes (TOTAL BY DETALLE.codcia).
    ACCUMULATE DETALLE.mtodes (SUB-TOTAL BY DETALLE.fchdoc).
    ACCUMULATE DETALLE.importe (TOTAL BY DETALLE.codcia).
    ACCUMULATE DETALLE.importe (SUB-TOTAL BY DETALLE.fchdoc).
    ACCUMULATE DETALLE.mnoobr (TOTAL BY DETALLE.codcia).
    ACCUMULATE DETALLE.mnoobr (SUB-TOTAL BY DETALLE.fchdoc).
    ACCUMULATE DETALLE.galones (TOTAL BY DETALLE.codcia).
    ACCUMULATE DETALLE.galones (SUB-TOTAL BY DETALLE.fchdoc).
    ACCUMULATE DETALLE.kilometros (TOTAL BY DETALLE.codcia).
    ACCUMULATE DETALLE.kilometros (SUB-TOTAL BY DETALLE.fchdoc).
    ACCUMULATE DETALLE.hortra (TOTAL BY DETALLE.codcia).
    ACCUMULATE DETALLE.hortra (SUB-TOTAL BY DETALLE.fchdoc).
    ACCUMULATE DETALLE.tmppro (TOTAL BY DETALLE.codcia).
    ACCUMULATE DETALLE.tmppro (SUB-TOTAL BY DETALLE.fchdoc).

    IF LAST-OF(DETALLE.FchDoc)
    THEN DO:
        UNDERLINE STREAM REPORT
            DETALLE.fchdoc      
            DETALLE.codveh      
            x-Nombre
            DETALLE.nrosal      
            DETALLE.nrocli[1]   
            DETALLE.nrocli[2]   
            DETALLE.nrocli[3]   
            DETALLE.nrocli[4]   
            DETALLE.nrocli[5]   
            DETALLE.nrocli[6]   
            DETALLE.galones     
            DETALLE.importe     
            DETALLE.kilometros
            DETALLE.hortra      
            DETALLE.tmppro      
            DETALLE.mtodes      
            DETALLE.mnoobr      
            WITH FRAME FC-REP.
        DISPLAY STREAM REPORT
            "TOTAL DIARIO >>>" @ x-Nombre
            ACCUM SUB-TOTAL BY DETALLE.FchDoc DETALLE.nrocli[1] @ DETALLE.nrocli[1]
            ACCUM SUB-TOTAL BY DETALLE.FchDoc DETALLE.nrocli[2] @ DETALLE.nrocli[2]
            ACCUM SUB-TOTAL BY DETALLE.FchDoc DETALLE.nrocli[3] @ DETALLE.nrocli[3]
            ACCUM SUB-TOTAL BY DETALLE.FchDoc DETALLE.nrocli[4] @ DETALLE.nrocli[4]
            ACCUM SUB-TOTAL BY DETALLE.FchDoc DETALLE.nrocli[5] @ DETALLE.nrocli[5]
            ACCUM SUB-TOTAL BY DETALLE.FchDoc DETALLE.nrocli[6] @ DETALLE.nrocli[6]
            ACCUM SUB-TOTAL BY DETALLE.FchDoc DETALLE.galones @ DETALLE.galones
            ACCUM SUB-TOTAL BY DETALLE.FchDoc DETALLE.importe @ DETALLE.importe
            ACCUM SUB-TOTAL BY DETALLE.FchDoc DETALLE.kilometros @ DETALLE.kilometros
            ACCUM SUB-TOTAL BY DETALLE.FchDoc DETALLE.hortra @ DETALLE.hortra
            ACCUM SUB-TOTAL BY DETALLE.FchDoc DETALLE.tmppro @ DETALLE.tmppro
            ACCUM SUB-TOTAL BY DETALLE.FchDoc DETALLE.mtodes  @ DETALLE.mtodes
            ACCUM SUB-TOTAL BY DETALLE.FchDoc DETALLE.mnoobr  @ DETALLE.mnoobr
            WITH FRAME FC-REP.
        DOWN STREAM REPORT 1 WITH FRAME FC-REP.
    END.
  END.  

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

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN Carga-Temporal.
    FIND FIRST DETALLE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE DETALLE THEN DO:
        MESSAGE
            'No hay información a imprimir'
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

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
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn3}.
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
    FILL-IN-Fecha-1 = TODAY - DAY(TODAY) + 1
    FILL-IN-Fecha-2 = TODAY.

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fHorTra W-Win 
FUNCTION fHorTra RETURNS DECIMAL
  ( INPUT Parm1 AS CHAR,
    INPUT Parm2 AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR x-Min1 AS DEC.
  DEF VAR x-Min2 AS DEC.
  
  IF Parm1 = '' OR Parm2 = '' THEN RETURN 0.00.   /* Function return value. */
  ASSIGN
    x-Min1 = INTEGER(SUBSTRING(Parm1,1,2)) * 60 +
            INTEGER(SUBSTRING(Parm1,3))
    x-Min2 = INTEGER(SUBSTRING(Parm2,1,2)) * 60 +
            INTEGER(SUBSTRING(Parm2,3))
    NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN 0.00.
  IF x-Min2 < x-Min1 THEN RETURN 0.00.
  RETURN (x-Min2 - x-Min1) / 60.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

