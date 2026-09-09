&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

{bin/s-global.i}
{pln/s-global.i}

DEFINE NEW SHARED VARIABLE VAL-VAR AS DECIMAL EXTENT 20.
DEFINE VARIABLE x-valcalI AS DECIMAL NO-UNDO FORMAT ">,>>>,>>9.99".
DEFINE VARIABLE x-valcalE AS DECIMAL NO-UNDO FORMAT ">,>>>,>>9.99".
DEFINE VARIABLE x-valcalA AS DECIMAL NO-UNDO FORMAT ">,>>>,>>9.99".
DEFINE VARIABLE CMB-lista AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-linea   AS CHARACTER FORMAT "x(64)" NO-UNDO.
DEFINE VARIABLE x-mes     AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-dirdiv  AS CHARACTER NO-UNDO.
define variable x-desdiv  as char.
define variable ii        as int.
DEFINE VARIABLE stat-reg  AS LOGICAL NO-UNDO.
DEFINE VARIABLE x-con-reg AS INTEGER NO-UNDO.
DEFINE VARIABLE r-seleccion  AS INTEGER NO-UNDO initial 1.

DEFINE BUTTON Btn_OK IMAGE-UP FILE "img/plemrbol"
    LABEL "OK" SIZE 6.43 BY 1.58 BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-Codigo AS CHARACTER FORMAT "X(256)":U 
    LABEL "Personal" VIEW-AS FILL-IN SIZE 6.72 BY .81 BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-Seccion AS CHARACTER FORMAT "X(256)":U 
    LABEL "Proyecto" VIEW-AS FILL-IN SIZE 28 BY .81 BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-20 EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL SIZE 37.14 BY 3.08.

DEFINE FRAME F-msg
    FILL-IN-Codigo  AT ROW 2.08 COL 6.72 COLON-ALIGNED
    FILL-IN-Seccion AT ROW 2.96 COL 6.72 COLON-ALIGNED
    x-mes          AT ROW 3.84 COL 6.72 COLON-ALIGNED
    
    Btn_OK AT ROW 1.23 COL 30.29
    RECT-20 AT ROW 1 COL 1
    "Espere un momento por favor ..." VIEW-AS TEXT
    SIZE 22.57 BY .62 AT ROW 1.31 COL 4.43
    SPACE(11.13) SKIP(2.14)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
    FONT 4 TITLE "Procesando..." CENTERED.

DEFINE BUFFER b-PL-MOV-MES FOR PL-MOV-MES. /* BUFFER para busquedas de referencias */

DEFINE STREAM strm-boleta. /* STREAM para el reporte */

DEFINE WORK-TABLE tmp-bole
    FIELD t-nro    AS INTEGER
    FIELD t-codrem AS INTEGER
    FIELD t-refrem AS CHARACTER
    FIELD t-desrem AS CHARACTER
    FIELD t-imprem AS DECIMAL
    FIELD t-coddes AS INTEGER
    FIELD t-desdes AS CHARACTER
    FIELD t-impdes AS DECIMAL
    FIELD t-codApo AS INTEGER
    FIELD t-desApo AS CHARACTER
    FIELD t-impApo AS DECIMAL.

DEFINE TEMP-TABLE Tempo 
       FIELD CodPer AS CHAR FORMAT "x(6)"
       FIELD TpoBol AS CHAR FORMAT "x(15)"
       FIELD CodMov AS INTEGER FORMAT "999"
       FIELD ValCal AS DECI EXTENT 13.
       

DEFINE  VAr I AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_pl-flg-m

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES PL-PLAN PL-CALC
&Scoped-define FIRST-EXTERNAL-TABLE PL-PLAN


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR PL-PLAN, PL-CALC.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES PL-FLG-MES PL-PERS

/* Definitions for BROWSE br_pl-flg-m                                   */
&Scoped-define FIELDS-IN-QUERY-br_pl-flg-m PL-FLG-MES.codper PL-PERS.patper ~
PL-PERS.matper PL-PERS.nomper 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_pl-flg-m 
&Scoped-define FIELD-PAIRS-IN-QUERY-br_pl-flg-m
&Scoped-define OPEN-QUERY-br_pl-flg-m OPEN QUERY br_pl-flg-m FOR EACH PL-FLG-MES ~
      WHERE PL-FLG-MES.CodCia = s-CodCia ~
 AND PL-FLG-MES.Periodo = s-Periodo ~
 AND PL-FLG-MES.codpln = 1 /*PL-PLAN.CodPln*/ ~
 AND PL-FLG-MES.NroMes = FILL-IN-NRO-MES ~
 NO-LOCK, ~
      EACH PL-PERS OF PL-FLG-MES NO-LOCK ~
    BY PL-FLG-MES.Proyecto ~
       BY PL-FLG-MES.seccion ~
        BY PL-PERS.patper ~
         BY PL-PERS.matper ~
          BY PL-PERS.nomper.
&Scoped-define TABLES-IN-QUERY-br_pl-flg-m PL-FLG-MES PL-PERS
&Scoped-define FIRST-TABLE-IN-QUERY-br_pl-flg-m PL-FLG-MES


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br_pl-flg-m}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-2 TGL-pantalla Btn-UP FILL-IN-NRO-MES ~
Btn-DOWN B-aceptar br_pl-flg-m FILL-IN-msg 
&Scoped-Define DISPLAYED-OBJECTS TGL-pantalla FILL-IN-NRO-MES ~
FILL-IN-Copias FILL-IN-msg 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON B-aceptar 
     IMAGE-UP FILE "img/b-ok":U
     LABEL "&Aceptar" 
     SIZE 10.72 BY 1.54.

DEFINE BUTTON Btn-DOWN 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE VARIABLE FILL-IN-Copias AS INTEGER FORMAT "99":U INITIAL 1 
     LABEL "Copias" 
     VIEW-AS FILL-IN 
     SIZE 3.29 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-msg AS CHARACTER FORMAT "X(256)":U 
     LABEL "Mensaje" 
     VIEW-AS FILL-IN 
     SIZE 40.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NRO-MES AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 69.72 BY 9.5.

DEFINE VARIABLE TGL-pantalla AS LOGICAL INITIAL no 
     LABEL "Salida a Pantalla" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.57 BY .5 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_pl-flg-m FOR 
      PL-FLG-MES, 
      PL-PERS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_pl-flg-m
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_pl-flg-m B-table-Win _STRUCTURED
  QUERY br_pl-flg-m NO-LOCK DISPLAY
      PL-FLG-MES.codper COLUMN-FONT 4 LABEL-FONT 4
      PL-PERS.patper COLUMN-FONT 4 LABEL-FONT 4
      PL-PERS.matper COLUMN-FONT 4 LABEL-FONT 4
      PL-PERS.nomper COLUMN-FONT 4 LABEL-FONT 4
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS MULTIPLE SIZE 47.14 BY 7.92
         BGCOLOR 15 FGCOLOR 0 FONT 6.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     TGL-pantalla AT ROW 5.54 COL 4.86
     Btn-UP AT ROW 2.77 COL 9.43
     FILL-IN-NRO-MES AT ROW 2.96 COL 4 COLON-ALIGNED
     Btn-DOWN AT ROW 3.38 COL 9.43
     B-aceptar AT ROW 6.15 COL 6.57
     FILL-IN-Copias AT ROW 2.92 COL 16.72 COLON-ALIGNED
     br_pl-flg-m AT ROW 1.31 COL 22.43
     FILL-IN-msg AT ROW 9.46 COL 27 COLON-ALIGNED
     RECT-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.72 BY 9.5
         BGCOLOR 8 FGCOLOR 0 FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: integral.PL-PLAN,integral.PL-CALC
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 9.5
         WIDTH              = 69.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* BROWSE-TAB br_pl-flg-m FILL-IN-Copias F-Main */
ASSIGN 
       br_pl-flg-m:NUM-LOCKED-COLUMNS IN FRAME F-Main = 1.

/* SETTINGS FOR FILL-IN FILL-IN-Copias IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       FILL-IN-Copias:HIDDEN IN FRAME F-Main           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_pl-flg-m
/* Query rebuild information for BROWSE br_pl-flg-m
     _TblList          = "integral.PL-FLG-MES,integral.PL-PERS OF integral.PL-FLG-MES"
     _Options          = "NO-LOCK"
     _OrdList          = "integral.PL-FLG-MES.Proyecto|yes,integral.PL-FLG-MES.seccion|yes,integral.PL-PERS.patper|yes,integral.PL-PERS.matper|yes,integral.PL-PERS.nomper|yes"
     _Where[1]         = "PL-FLG-MES.CodCia = s-CodCia
 AND PL-FLG-MES.Periodo = s-Periodo
 AND PL-FLG-MES.codpln = 1 /*PL-PLAN.CodPln*/
 AND PL-FLG-MES.NroMes = FILL-IN-NRO-MES
"
     _FldNameList[1]   > integral.PL-FLG-MES.codper
"PL-FLG-MES.codper" ? ? "character" ? ? 4 ? ? 4 no ?
     _FldNameList[2]   > integral.PL-PERS.patper
"PL-PERS.patper" ? ? "character" ? ? 4 ? ? 4 no ?
     _FldNameList[3]   > integral.PL-PERS.matper
"PL-PERS.matper" ? ? "character" ? ? 4 ? ? 4 no ?
     _FldNameList[4]   > integral.PL-PERS.nomper
"PL-PERS.nomper" ? ? "character" ? ? 4 ? ? 4 no ?
     _Query            is OPENED
*/  /* BROWSE br_pl-flg-m */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aceptar B-table-Win
ON CHOOSE OF B-aceptar IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN FILL-IN-NRO-MES  FILL-IN-Copias FILL-IN-msg.
    IF FILL-IN-Copias = 0 THEN FILL-IN-Copias = 1.
    RUN imp_boleta.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_pl-flg-m
&Scoped-define SELF-NAME br_pl-flg-m
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-m B-table-Win
ON ROW-ENTRY OF br_pl-flg-m IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-m B-table-Win
ON ROW-LEAVE OF br_pl-flg-m IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_pl-flg-m B-table-Win
ON VALUE-CHANGED OF br_pl-flg-m IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN B-table-Win
ON CHOOSE OF Btn-DOWN IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main FILL-IN-NRO-MES - 1 >= 1 THEN DO:
    DISPLAY INPUT FILL-IN-NRO-MES - 1 @ FILL-IN-NRO-MES WITH FRAME F-Main.
    ASSIGN FILL-IN-NRO-MES.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP B-table-Win
ON CHOOSE OF Btn-UP IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main FILL-IN-NRO-MES + 1 <= 12 THEN DO:
    DISPLAY INPUT FILL-IN-NRO-MES + 1 @ FILL-IN-NRO-MES WITH FRAME F-Main.
    ASSIGN FILL-IN-NRO-MES.
    {&OPEN-QUERY-{&BROWSE-NAME}}
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NRO-MES
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NRO-MES B-table-Win
ON LEAVE OF FILL-IN-NRO-MES IN FRAME F-Main /* Mes */
DO:
    IF INPUT FILL-IN-NRO-MES > 12 OR INPUT FILL-IN-NRO-MES = 0 THEN DO:
        BELL.
        MESSAGE "Rango de mes es de 1 a 12"
            VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO FILL-IN-NRO-MES.
        RETURN NO-APPLY.
    END.
    IF INPUT FILL-IN-NRO-MES = FILL-IN-NRO-MES THEN RETURN.
    ASSIGN FILL-IN-NRO-MES.
    {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ASSIGN FILL-IN-NRO-MES = s-NroMes.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "PL-PLAN"}
  {src/adm/template/row-list.i "PL-CALC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "PL-PLAN"}
  {src/adm/template/row-find.i "PL-CALC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busca_datos B-table-Win 
PROCEDURE busca_datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE saldo     AS DECIMAL.
DEFINE VARIABLE F-ValCal  AS DECIMAL.
DEFINE VARIABLE linea-msg AS CHARACTER EXTENT 3.
DEFINE VARIABLE j         AS INTEGER.
DEFINE VARIABLE ii        AS INTEGER.
DEFINE VARIABLE x-dirdiv  AS CHAR.
DEFINE VARIABLE x-desdiv  AS CHAR.
DEFINE VARIABLE x-dirper  AS CHAR.
DEFINE VARIABLE x-LEper   AS CHAR.
DEFINE VARIABLE X-RUC     AS CHAR INIT "20100038146" format "X(11)".
FOR EACH tempo:
    DELETE Tempo.
END.


for each PL-MOV-MES WHERE
        PL-MOV-MES.CodCia  = s-CodCia AND
        PL-MOV-MES.Periodo = s-Periodo AND
        PL-MOV-MES.NroMes  <= FILL-IN-NRO-MES AND
        lookup(string(PL-MOV-MES.CodMov),"221,222,225") > 0 use-index idx02:
        /*PL-MOV-MES.CodPln  = 01  AND   Tipo Planilla
        PL-MOV-MES.CodCal  = PL-BOLE.CodCal AND
        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer AND*/

        
        IF PL-MOV-MES.ValCal-Mes <> 0 THEN
        DO:
            DISPLAY PL-MOV-MES.CodPer @ FILL-IN-Codigo
            PL-MOV-MES.Nromes @ x-mes WITH FRAME F-Msg.

           FIND Tempo WHERE Tempo.CodPer = PL-MOV-MES.CodPer NO-ERROR.
           IF NOT AVAILABLE Tempo THEN
           DO:                 
            CREATE tempo.
            ASSIGN
             Tempo.CodPer = PL-MOV-MES.CodPer.
           END.
           Tempo.ValCal[PL-MOV-MES.Nromes] = Tempo.ValCal[PL-MOV-MES.Nromes] + PL-MOV-MES.ValCal-Mes .    
           Tempo.ValCal[13] = Tempo.ValCal[13] + PL-MOV-MES.ValCal-Mes .    
        END.
end.

FIND GN-DIVI WHERE GN-DIVI.CodCia = s-codcia AND
     GN-DIVI.CodDiv =  PL-FLG-MES.CodDiv NO-LOCK NO-ERROR.
IF AVAILABLE GN-DIVI THEN
   ASSIGN x-desdiv = GN-DIVI.DesDiv
          x-dirdiv = GN-DIVI.DirDiv.
x-linea = TRIM(PL-FLG-MES.CodDiv) + " " + TRIM(x-desdiv).
FIND gn-cias WHERE gn-cias.codcia  = s-codcia NO-LOCK NO-ERROR.

DO ii = 1 TO 1 /*FILL-IN-Copias */:
    FIND GN-DIVI WHERE GN-DIVI.CodCia = s-codcia AND
         GN-DIVI.CodDiv =  PL-FLG-MES.CodDiv NO-LOCK NO-ERROR.
    IF AVAILABLE GN-DIVI THEN
       ASSIGN x-desdiv = GN-DIVI.DesDiv
              x-dirdiv = TRIM(GN-DIVI.DirDiv).
    x-linea = TRIM(PL-FLG-MES.CodDiv) + " " + TRIM(x-desdiv).
    PUT STREAM strm-boleta SKIP(1).
    PUT STREAM strm-boleta CONTROL CHR(18) CHR(27) CHR(69).
    PUT STREAM strm-boleta S-NomCia SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70) CHR(27) CHR(77).
   
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(80) CHR(27) CHR(69).
    
    x-linea = "R E P O R T E   D E    A F P  " + STRING(S-PERIODO,"9999").
    
    PUT STREAM strm-boleta x-linea AT 20 SKIP.
    
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70) CHR(15).
    /*IF AVAILABLE PL-PERS THEN DO:
        x-linea = PL-PERS.PatPer + " " + PL-PERS.MatPer + ", " + PL-PERS.NomPer.
        x-dirper = TRIM(PL-PERS.dirper) + " " + TRIM(PL-PERS.distri).
        x-LEper  = PL-PERS.lelect.
        END.
    ELSE x-linea = "".*/

    /*PUT STREAM strm-boleta "Codigo    : " PL-FLG-MES.codper " " x-linea FORMAT "X(40)" SKIP.*/
    
    x-linea = FILL("-",150).
 
    PUT STREAM strm-boleta x-linea FORMAT "X(150)" SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(69).
    PUT STREAM strm-boleta "   Personal            ENE       FEB      MAR       ABR       MAY       JUN       JUL       AGO       SEP       OCT       NOV       DIC     TOTAL " FORMAT "X(245)" SKIP.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(70).
    x-linea = FILL("-",150).
    PUT STREAM strm-boleta x-linea FORMAT "X(150)" SKIP.
    
    
    FOR EACH tempo NO-LOCK : 
    /*BREAK BY tempo.tpobol DESCENDING 
                                 BY tempo.CodMov :*/
        /*IF FIRST-OF(Tempo.TpoBol) THEN DO:
           PUT STREAM strm-boleta  tempo.Tpobol  SKIP.
        END.*/
        FIND PL-pers WHERE PL-pers.Codper = tempo.Codper NO-LOCK NO-ERROR.
        IF AVAILABLE PL-pers THEN x-linea = PL-pers.Nomper.

        PUT STREAM strm-boleta tempo.codper format "x(6)"AT 1.
        PUT STREAM strm-boleta x-linea format "x(20)" AT 13 .
        PUT STREAM strm-boleta tempo.ValCal[1] FORMAT "->>>>9.99" AT 35.
        PUT STREAM strm-boleta tempo.ValCal[2] FORMAT "->>>>9.99" AT 45.
        PUT STREAM strm-boleta tempo.ValCal[3] FORMAT "->>>>9.99" AT 55.
        PUT STREAM strm-boleta tempo.ValCal[4] FORMAT "->>>>9.99" AT 65.
        PUT STREAM strm-boleta tempo.ValCal[5] FORMAT "->>>>9.99" AT 75.
        PUT STREAM strm-boleta tempo.ValCal[6] FORMAT "->>>>9.99" AT 85.
        PUT STREAM strm-boleta tempo.ValCal[7] FORMAT "->>>>9.99" AT 95.
        PUT STREAM strm-boleta tempo.ValCal[8] FORMAT "->>>>9.99" AT 105.
        PUT STREAM strm-boleta tempo.ValCal[9] FORMAT "->>>>9.99" AT 120.
        PUT STREAM strm-boleta tempo.ValCal[10] FORMAT "->>>>9.99" AT 135.
        PUT STREAM strm-boleta tempo.ValCal[11] FORMAT "->>>>9.99" AT 150.
        PUT STREAM strm-boleta tempo.ValCal[12] FORMAT "->>>>9.99" AT 165.
        PUT STREAM strm-boleta tempo.ValCal[13] FORMAT "->>>>9.99" AT 180 SKIP.
    END.
   
    PAGE STREAM strm-boleta.
    
END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE busca_datos2 B-table-Win 
PROCEDURE busca_datos2 :
/*------------------------------------------------------------------------------
    Busca datos
------------------------------------------------------------------------------*/

IF PL-FLG-MES.SitAct = "Inactivo" THEN RETURN. /* Si no esta Activo */
/*
IF NOT CAN-FIND(FIRST PL-MOV-MES WHERE
    PL-MOV-MES.CodCia  = s-CodCia        AND
    PL-MOV-MES.Periodo = s-Periodo       AND
    PL-MOV-MES.NroMes  = FILL-IN-NRO-MES AND
    PL-MOV-MES.CodPln  = PL-PLAN.CodPln  AND
    PL-MOV-MES.CodCal  = PL-CALC.CodCal  AND
    PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer) THEN RETURN. /* Si no tiene c lculo */
*/

DISPLAY PL-FLG-MES.CodPer @ FILL-IN-Codigo WITH FRAME F-Msg.


/* Cargamos el temporal con los ingresos */
DO I = 1 TO 12:
FOR EACH PL-MOV-MES WHERE
        PL-MOV-MES.CodCia  = s-CodCia AND
        PL-MOV-MES.Periodo = s-Periodo AND
        PL-MOV-MES.NroMes  = I /*FILL-IN-NRO-MES*/ AND
        PL-MOV-MES.CodPln  = PL-PLAN.CodPln AND
        PL-MOV-MES.CodCal  = PL-CALC.CodCal AND
        PL-MOV-MES.CodPer  = PL-FLG-MES.CodPer NO-LOCK :
        CREATE Tempo.
        RAW-TRANSFER PL-MOV-MES TO Tempo.
END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp_boleta B-table-Win 
PROCEDURE imp_boleta :
/*------------------------------------------------------------------------------
    Impresi¢n de boleta de pago.
------------------------------------------------------------------------------*/
DEFINE VARIABLE p-archivo AS CHARACTER.

/* Direccionamiento del STREAM */

IF INPUT FRAME {&FRAME-NAME} TGL-pantalla = TRUE THEN DO:
    P-archivo = SESSION:TEMP-DIRECTORY +
          STRING(NEXT-VALUE(sec-arc,integral),"99999999") + ".scr".
    OUTPUT STREAM strm-boleta TO VALUE ( P-archivo ) PAGED PAGE-SIZE 66.
END.
ELSE DO:
    OUTPUT STREAM strm-boleta TO PRINTER PAGED PAGE-SIZE 66.
    PUT STREAM strm-boleta CONTROL CHR(27) CHR(67) CHR(66) CHR(27) CHR(80). /* LETRA NORMAL */
END.

FOR EACH Tempo:
    DELETE Tempo.
END.


DEFINE VAR I AS INTEGER.
R-seleccion = 1.

CASE R-seleccion:
WHEN 1 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL IN FRAME F-Msg = "Secci¢n".
    GET FIRST br_pl-flg-m.
    DO WHILE AVAILABLE(PL-FLG-MES):
        DISPLAY PL-FLG-MES.seccion @ FILL-IN-Seccion WITH FRAME F-Msg.
        RUN busca_datos.
        GET NEXT br_pl-flg-m.
    END.
END.
WHEN 2 THEN DO:
    ASSIGN FILL-IN-Seccion:LABEL = "Secci¢n".
    DO i = 1 TO br_pl-flg-m:NUM-SELECTED-ROWS IN FRAME F-Main:
        ASSIGN stat-reg  = br_pl-flg-m:FETCH-SELECTED-ROW(i).
        IF stat-reg THEN DO:
            DISPLAY PL-FLG-MES.seccion @ FILL-IN-Seccion WITH FRAME F-Msg.
            RUN busca_datos.
        END.
    END.
    ASSIGN stat-reg = br_pl-flg-m:DESELECT-ROWS().
END.
END CASE.

HIDE FRAME F-Msg.

OUTPUT STREAM strm-boleta CLOSE.

IF INPUT TGL-pantalla = TRUE THEN DO:
    RUN bin/_vcat.p ( P-archivo ). 
    OS-DELETE VALUE ( P-archivo ). 
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    DISPLAY FILL-IN-NRO-MES WITH FRAME F-Main.

    /*APPLY "VALUE-CHANGED" TO R-seleccion IN FRAME F-Main.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "PL-PLAN"}
  {src/adm/template/snd-list.i "PL-CALC"}
  {src/adm/template/snd-list.i "PL-FLG-MES"}
  {src/adm/template/snd-list.i "PL-PERS"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


