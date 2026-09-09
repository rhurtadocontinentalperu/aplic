&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE t-FacCPedi NO-UNDO LIKE FacCPedi
       INDEX Idx00 AS PRIMARY coddoc nroped.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-nomcia AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES t-FacCPedi

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 t-FacCPedi.CodDoc t-FacCPedi.NroPed ~
t-FacCPedi.NomCli t-FacCPedi.Items t-FacCPedi.Peso t-FacCPedi.FchEnt ~
t-FacCPedi.Libre_c01 t-FacCPedi.Libre_c02 t-FacCPedi.NroRef ~
t-FacCPedi.Libre_d01 t-FacCPedi.Libre_c03 t-FacCPedi.Libre_c04 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH t-FacCPedi NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH t-FacCPedi NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 t-FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 t-FacCPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-2 BUTTON_REFRESCAR BROWSE-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fPicador W-Win 
FUNCTION fPicador RETURNS CHARACTER
  ( INPUT pDNI AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/print.ico":U
     LABEL "Button 2" 
     SIZE 7 BY 1.62.

DEFINE BUTTON BUTTON_REFRESCAR 
     LABEL "CARGAR INFORMACION" 
     SIZE 24 BY 1.12
     FONT 6.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      t-FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      t-FacCPedi.CodDoc COLUMN-LABEL "Orden" FORMAT "x(3)":U WIDTH 4.43
      t-FacCPedi.NroPed COLUMN-LABEL "Número" FORMAT "X(12)":U
            WIDTH 10.43
      t-FacCPedi.NomCli COLUMN-LABEL "Cliente" FORMAT "x(100)":U
            WIDTH 51.43
      t-FacCPedi.Items FORMAT "->,>>>,>>9":U
      t-FacCPedi.Peso COLUMN-LABEL "Peso en kg" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 9.57
      t-FacCPedi.FchEnt COLUMN-LABEL "Entrega" FORMAT "99/99/9999":U
            WIDTH 9.43
      t-FacCPedi.Libre_c01 COLUMN-LABEL "Estado" FORMAT "x(60)":U
            WIDTH 21.43
      t-FacCPedi.Libre_c02 COLUMN-LABEL "Fecha/Hora" FORMAT "x(60)":U
            WIDTH 20.43
      t-FacCPedi.NroRef COLUMN-LABEL "Número HPK" FORMAT "X(12)":U
            WIDTH 10.43
      t-FacCPedi.Libre_d01 COLUMN-LABEL "Bultos" FORMAT ">>>,>>9":U
      t-FacCPedi.Libre_c03 COLUMN-LABEL "Picador" FORMAT "x(60)":U
            WIDTH 20
      t-FacCPedi.Libre_c04 COLUMN-LABEL "Mesa" FORMAT "x(60)":U
            WIDTH 9
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 189 BY 24.23
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-2 AT ROW 1 COL 31 WIDGET-ID 4
     BUTTON_REFRESCAR AT ROW 1.27 COL 3 WIDGET-ID 2
     BROWSE-2 AT ROW 2.62 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 191.29 BY 26.15
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: t-FacCPedi T "?" NO-UNDO INTEGRAL FacCPedi
      ADDITIONAL-FIELDS:
          INDEX Idx00 AS PRIMARY coddoc nroped
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "PEDIDOS SIN PHR"
         HEIGHT             = 26.15
         WIDTH              = 191.86
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.86
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.86
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
/* BROWSE-TAB BROWSE-2 BUTTON_REFRESCAR F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.t-FacCPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.t-FacCPedi.CodDoc
"t-FacCPedi.CodDoc" "Orden" ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.t-FacCPedi.NroPed
"t-FacCPedi.NroPed" "Número" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.t-FacCPedi.NomCli
"t-FacCPedi.NomCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "51.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.t-FacCPedi.Items
     _FldNameList[5]   > Temp-Tables.t-FacCPedi.Peso
"t-FacCPedi.Peso" "Peso en kg" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.t-FacCPedi.FchEnt
"t-FacCPedi.FchEnt" "Entrega" ? "date" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.t-FacCPedi.Libre_c01
"t-FacCPedi.Libre_c01" "Estado" ? "character" ? ? ? ? ? ? no ? no no "21.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.t-FacCPedi.Libre_c02
"t-FacCPedi.Libre_c02" "Fecha/Hora" ? "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.t-FacCPedi.NroRef
"t-FacCPedi.NroRef" "Número HPK" ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.t-FacCPedi.Libre_d01
"t-FacCPedi.Libre_d01" "Bultos" ">>>,>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.t-FacCPedi.Libre_c03
"t-FacCPedi.Libre_c03" "Picador" ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.t-FacCPedi.Libre_c04
"t-FacCPedi.Libre_c04" "Mesa" ? "character" ? ? ? ? ? ? no ? no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* PEDIDOS SIN PHR */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* PEDIDOS SIN PHR */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
  DEF VAR s-Task-No AS INT NO-UNDO.

  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

  SESSION:SET-WAIT-STATE('GENERAL').
  s-Task-No = 0.
  RUN Carga-Reporte (OUTPUT s-Task-No).
  SESSION:SET-WAIT-STATE('').
  
  GET-KEY-VALUE SECTION 'StartUp' KEY 'Base' VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY  = RB-REPORT-LIBRARY + "logis/rblogis.prl".
  RB-REPORT-NAME     = "Pedidos Sin PHR".
  RB-INCLUDE-RECORDS = "O".
  RB-FILTER = "w-report.task-no = " + STRING(s-task-no).
  RB-OTHER-PARAMETERS = "s-nomcia=" + s-nomcia.
  
  RUN lib/_Imprime2 (RB-REPORT-LIBRARY,
                     RB-REPORT-NAME,
                     RB-INCLUDE-RECORDS,
                     RB-FILTER,
                     RB-OTHER-PARAMETERS).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_REFRESCAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_REFRESCAR W-Win
ON CHOOSE OF BUTTON_REFRESCAR IN FRAME F-Main /* CARGAR INFORMACION */
DO:
  SESSION:SET-WAIT-STATE("GENERAL").
  RUN Carga-Temporal.
  SESSION:SET-WAIT-STATE("").
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Reporte W-Win 
PROCEDURE Carga-Reporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAMETER s-Task-No AS INTE NO-UNDO.

    IF s-Task-No = 0 THEN REPEAT:
        s-Task-No = RANDOM(1,999999).
        IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK) THEN LEAVE.
    END.

    DEF BUFFER bt-Faccpedi FOR t-Faccpedi.

    FOR EACH bt-Faccpedi NO-LOCK:
        CREATE w-report.
        ASSIGN
            w-report.task-no = s-task-no
            w-report.Llave-C = Di-RutaC.NroDoc + " " + DI-RutaC.Observ.
        ASSIGN
            w-report.Campo-C[9] = bt-Faccpedi.CodDoc
            w-report.Campo-C[10] = bt-Faccpedi.NroPed
            w-report.Campo-C[11] = bt-Faccpedi.NomCli
            w-report.Campo-F[1] = bt-Faccpedi.Items
            w-report.Campo-F[2] = bt-Faccpedi.Peso
            w-report.Campo-D[1] = bt-Faccpedi.fchent
            w-report.Campo-C[3] = bt-Faccpedi.Libre_C01
            w-report.Campo-C[4] = bt-Faccpedi.Libre_C02
            w-report.Campo-C[2] = bt-Faccpedi.nroref
            w-report.Campo-F[4] = bt-Faccpedi.Libre_d01
            w-report.Campo-C[6] = bt-Faccpedi.Libre_C03
            w-report.Campo-C[7] = bt-Faccpedi.Libre_C04
        .
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Barremos todos los pedidos pendientes
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE t-Faccpedi.

DEF VAR lConHPK AS LOG NO-UNDO.
DEF VAR cCodDoc AS CHAR INIT "O/D,OTR" NO-UNDO.
DEF VAR i AS INTE NO-UNDO.

/* NOTA:
    Una O/D u OTR puede tener más de una HPK, en ese caso se va agenerar + de un registro
*/

DO i = 1 TO 2:
    RLOOP:
    FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
        AND Faccpedi.divdes = s-coddiv
        AND Faccpedi.coddoc = ENTRY(i, cCodDoc)
        AND Faccpedi.flgest = "P"
        AND faccpedi.fchped >= ADD-INTERVAL(TODAY,-1,'month'):
        /* ************************************************************************* */
        /* FILTROS */
        /* ************************************************************************* */
        FOR EACH DI-RutaD NO-LOCK WHERE DI-RutaD.CodCia = s-codcia 
            AND DI-RutaD.CodDoc = "PHR"
            AND DI-RutaD.CodRef = Faccpedi.coddoc
            AND DI-RutaD.NroRef = Faccpedi.nroped
            AND DI-RutaD.CodDiv = s-coddiv,
            FIRST DI-RutaC OF DI-RutaD NO-LOCK:
            IF DI-RutaC.FlgEst BEGINS "P" THEN NEXT RLOOP.
        END.
        /* ************************************************************************* */
        /* Buscamos HPK ACTIVA */
        lConHPK = NO.
        FOR EACH Vtacdocu NO-LOCK WHERE Vtacdocu.codcia = s-codcia
            AND Vtacdocu.codref = Faccpedi.coddoc
            AND Vtacdocu.nroref = Faccpedi.nroped:
            IF (Vtacdocu.coddiv = s-coddiv
                AND Vtacdocu.codped = "HPK"
                AND Vtacdocu.flgest <> "A")
                THEN DO:
                lConHPK = YES.
                LEAVE.
            END.
        END.
        CASE lConHPK:
            WHEN YES THEN DO:
                /* Barremos las HPK */
                FOR EACH Vtacdocu NO-LOCK WHERE VtaCDocu.CodCia = s-codcia 
                    AND VtaCDocu.CodRef = Faccpedi.coddoc
                    AND VtaCDocu.NroRef = Faccpedi.nroped
                    AND VtaCDocu.CodDiv = s-coddiv
                    AND VtaCDocu.CodPed = "HPK"
                    AND VtaCDocu.FlgEst <> "A":
                    /* Grabación básica */
                    CREATE t-Faccpedi.
                    ASSIGN
                        t-FacCPedi.CodCia = FacCPedi.CodCia 
                        t-FacCPedi.CodDiv = FacCPedi.CodDiv 
                        t-FacCPedi.CodDoc = FacCPedi.CodDoc 
                        t-FacCPedi.NroPed = FacCPedi.NroPed 
                        t-FacCPedi.CodCli = FacCPedi.CodCli 
                        t-FacCPedi.NomCli = FacCPedi.NomCli 
                        t-FacCPedi.Items  = Vtacdocu.Items  
                        t-FacCPedi.Peso   = Vtacdocu.Peso   
                        t-FacCPedi.FchPed = FacCPedi.FchPed
                        t-FacCPedi.FchEnt = FacCPedi.FchEnt
                        .
                    ASSIGN
                        t-FacCPedi.NroRef = VtaCDocu.NroPed.    /* HPK */
                    /* Usamos el tracking de HPK */
                    FOR EACH LogTrkDocs NO-LOCK WHERE LogTrkDocs.CodCia = VtaCDocu.CodCia
                        AND LogTrkDocs.CodDoc = VtaCDocu.CodPed
                        AND LogTrkDocs.NroDoc = VtaCDocu.NroPed
                        AND LogTrkDocs.Clave = "TRCKHPK",
                        FIRST TabTrkDocs WHERE TabTrkDocs.CodCia = LogTrkDocs.CodCia
                        AND TabTrkDocs.Clave = LogTrkDocs.Clave
                        AND TabTrkDocs.Codigo = LogTrkDocs.Codigo NO-LOCK
                        BY LogTrkDocs.Fecha:
                        ASSIGN
                            t-FacCPedi.Libre_C01 = TabTrkDocs.NomCorto
                            t-Faccpedi.Libre_c02 = STRING(LogTrkDocs.Fecha, '99/99/9999 HH:MM:SS')
                            t-FacCPedi.Libre_C03 = fPicador(VtaCDocu.UsrSac)
                            .
/*                         IF LogTrkDocs.Codigo = "PK_SEM" THEN   /* MRC 23/11/2020 */                 */
/*                             t-Faccpedi.Libre_c02 = STRING(LogTrkDocs.Fecha, '99/99/9999 HH:MM:SS'). */
/*                         ASSIGN                                                                      */
/*                             t-FacCPedi.Libre_C01 = TabTrkDocs.NomCorto                              */
/*                             t-FacCPedi.Libre_C03 = fPicador(VtaCDocu.UsrSac)                        */
/*                             .                                                                       */
                        FIND FIRST ChkTareas WHERE ChkTareas.CodCia = VtaCDocu.CodCia
                            AND ChkTareas.CodDiv = VtaCDocu.CodDiv
                            AND ChkTareas.CodDoc = VtaCDocu.CodPed
                            AND ChkTareas.NroPed = VtaCDocu.NroPed
                            NO-LOCK NO-ERROR.
                        IF AVAILABLE ChkTareas THEN t-FacCPedi.Libre_C04 = ChkTareas.Mesa.
                    END.
                    /* Bultos por HPK */
                    FOR EACH logisdchequeo NO-LOCK WHERE logisdchequeo.CodCia = s-codcia AND
                        logisdchequeo.CodDiv = s-coddiv AND 
                        logisdchequeo.CodPed = Vtacdocu.codped AND
                        logisdchequeo.NroPed = Vtacdocu.nroped 
                        BREAK BY logisdchequeo.Etiqueta:
                        IF FIRST-OF(logisdchequeo.Etiqueta) THEN t-FacCPedi.Libre_D01 = t-FacCPedi.Libre_D01 + 1.
                    END.

                END.
            END.
            WHEN NO THEN DO:
                /* Grabación básica */
                CREATE t-Faccpedi.
                ASSIGN
                    t-FacCPedi.CodCia = FacCPedi.CodCia 
                    t-FacCPedi.CodDiv = FacCPedi.CodDiv 
                    t-FacCPedi.CodDoc = FacCPedi.CodDoc 
                    t-FacCPedi.NroPed = FacCPedi.NroPed 
                    t-FacCPedi.CodCli = FacCPedi.CodCli 
                    t-FacCPedi.NomCli = FacCPedi.NomCli 
                    t-FacCPedi.Items  = FacCPedi.Items  
                    t-FacCPedi.Peso   = FacCPedi.Peso   
                    t-FacCPedi.FchPed = FacCPedi.FchPed
                    t-FacCPedi.FchEnt = FacCPedi.FchEnt
                    .
                /* Usamos el tracking de Pedidos */
                FOR EACH LogTrkDocs NO-LOCK WHERE LogTrkDocs.CodCia = Faccpedi.CodCia
                    AND LogTrkDocs.CodDoc = Faccpedi.CodDoc
                    AND LogTrkDocs.NroDoc = Faccpedi.NroPed
                    AND LogTrkDocs.Clave = "TRCKPED",
                    FIRST TabTrkDocs WHERE TabTrkDocs.CodCia = LogTrkDocs.CodCia
                    AND TabTrkDocs.Clave = LogTrkDocs.Clave
                    AND TabTrkDocs.Codigo = LogTrkDocs.Codigo NO-LOCK
                    BY LogTrkDocs.Fecha:
                    ASSIGN
                        t-Faccpedi.Libre_c01 = TabTrkDocs.NomCorto
                        t-Faccpedi.Libre_c02 = STRING(LogTrkDocs.Fecha, '99/99/9999 HH:MM:SS').
                END.
                /* Bultos por Pedido */
                FOR EACH CcbCBult WHERE CcbCBult.CodCia = Faccpedi.codcia
                    AND CcbCBult.CodDoc = Faccpedi.coddoc 
                    AND CcbCBult.NroDoc = Faccpedi.nroped
                    AND CcbCBult.CodDiv = s-coddiv
                    NO-LOCK:
                    t-FacCPedi.Libre_D01 = t-FacCPedi.Libre_D01 + CcbCBult.Bultos.
                END.
            END.
        END CASE.   /* CASE lConHPK */
    END.    /* FOR EACH Faccpedi */
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
  ENABLE BUTTON-2 BUTTON_REFRESCAR BROWSE-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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
  {src/adm/template/snd-list.i "t-FacCPedi"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fPicador W-Win 
FUNCTION fPicador RETURNS CHARACTER
  ( INPUT pDNI AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEF VAR pNombre AS CHAR NO-UNDO.
  DEF VAR pOrigen AS CHAR NO-UNDO.

  RUN logis/p-busca-por-dni.p (pDNI, OUTPUT pNombre, OUTPUT pOrigen).
  RETURN pNombre.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

