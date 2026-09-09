&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

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

{BIN/S-GLOBAL.I}
{PLN/S-GLOBAL.I}

DEFINE NEW GLOBAL SHARED VARIABLE VAL-VAR AS DECIMAL EXTENT 20 FORMAT "Z,ZZZ,ZZ9.99".

DEFINE VARIABLE x-ImpTot AS DECIMAL NO-UNDO.
DEFINE VARIABLE i        AS INTEGER NO-UNDO.

DEFINE STREAM strm-boleta. /* STREAM para el reporte */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-8 FILL-IN-NRO-MES Btn-UP ~
Btn-DOWN Btn-UP-2 FILL-IN-Copias Btn-DOWN-2 B-aceptar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Msg FILL-IN-NRO-MES FILL-IN-Copias ~
FILL-IN-CodPer FILL-IN-NroCopia 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

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

DEFINE BUTTON Btn-DOWN-2 
     IMAGE-UP FILE "img/btn-down":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE BUTTON Btn-UP-2 
     IMAGE-UP FILE "img/btn-up":U
     LABEL "" 
     SIZE 3 BY .69.

DEFINE VARIABLE FILL-IN-CodPer AS CHARACTER FORMAT "X(6)":U 
     LABEL "Personal" 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .81
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-Copias AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Copias" 
     VIEW-AS FILL-IN 
     SIZE 3.14 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-Msg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .81
     BGCOLOR 8 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-NRO-MES AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Mes" 
     VIEW-AS FILL-IN 
     SIZE 3.14 BY .81
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-NroCopia AS INTEGER FORMAT "Z9":U INITIAL 0 
     LABEL "Copia nro." 
     VIEW-AS FILL-IN 
     SIZE 3 BY .81
     BGCOLOR 8 FGCOLOR 9  NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68.86 BY 2.31
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68.86 BY 1.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-Msg AT ROW 3.88 COL 1.72 NO-LABEL
     FILL-IN-NRO-MES AT ROW 1.69 COL 8.43 COLON-ALIGNED
     Btn-UP AT ROW 1.42 COL 14.14
     Btn-DOWN AT ROW 2.04 COL 14.14
     Btn-UP-2 AT ROW 1.46 COL 29.57
     FILL-IN-Copias AT ROW 1.69 COL 24.29 COLON-ALIGNED
     Btn-DOWN-2 AT ROW 2.08 COL 29.57
     B-aceptar AT ROW 1.38 COL 43.14
     FILL-IN-CodPer AT ROW 3.88 COL 48.57 COLON-ALIGNED
     FILL-IN-NroCopia AT ROW 3.88 COL 64 COLON-ALIGNED
     RECT-7 AT ROW 1 COL 1
     RECT-8 AT ROW 3.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 4.08
         WIDTH              = 68.86.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Default                                      */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-CodPer IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Msg IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-NroCopia IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME B-aceptar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-aceptar V-table-Win
ON CHOOSE OF B-aceptar IN FRAME F-Main /* Aceptar */
DO:
    ASSIGN FILL-IN-NRO-MES FILL-IN-Copias.
    RUN imp_aportes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN V-table-Win
ON CHOOSE OF Btn-DOWN IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main FILL-IN-NRO-MES - 1 >= 1 THEN DO:
    DISPLAY INPUT FILL-IN-NRO-MES - 1 @ FILL-IN-NRO-MES WITH FRAME F-Main.
    ASSIGN FILL-IN-NRO-MES.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-DOWN-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-DOWN-2 V-table-Win
ON CHOOSE OF Btn-DOWN-2 IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main FILL-IN-Copias - 1 >= 1 THEN DO:
    DISPLAY INPUT FILL-IN-Copias - 1 @ FILL-IN-Copias WITH FRAME F-Main.
    ASSIGN FILL-IN-Copias.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP V-table-Win
ON CHOOSE OF Btn-UP IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main FILL-IN-NRO-MES + 1 <= 53 THEN DO:
    DISPLAY INPUT FILL-IN-NRO-MES + 1 @ FILL-IN-NRO-MES WITH FRAME F-Main.
    ASSIGN FILL-IN-NRO-MES.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-UP-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-UP-2 V-table-Win
ON CHOOSE OF Btn-UP-2 IN FRAME F-Main
DO:
  IF INPUT FRAME F-Main FILL-IN-Copias + 1 <= 99 THEN DO:
    DISPLAY INPUT FILL-IN-Copias + 1 @ FILL-IN-Copias WITH FRAME F-Main.
    ASSIGN FILL-IN-Copias.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NRO-MES
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NRO-MES V-table-Win
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imp_aportes V-table-Win 
PROCEDURE imp_aportes :
/*------------------------------------------------------------------------------
    Impresi¢n de conceptos.
------------------------------------------------------------------------------*/
/*DEFINE STREAM strm-boleta.*/
DEFINE VARI X-NOMPER AS CHARACTER FORMAT "X(40)".
DEFINE VARI x-NroPag AS INTEGER.

DEFINE FRAME F-CAB
    PL-FLG-MES.CodPer COLUMN-LABEL "C¢digo" 
    X-NOMPER          COLUMN-LABEL "Apellidos y nombres" 
    PL-PERS.ctipss    COLUMN-LABEL "Carnet SSP" 
    PL-PERS.dirper    COLUMN-LABEL "Direcci¢n" FORMAT "x(15)"
    PL-PERS.distri    COLUMN-LABEL "Distrito"  FORMAT "x(15)"
    PL-PERS.fecnac    COLUMN-LABEL "Fecha de!nacimiento"
    PL-PERS.lelect    COLUMN-LABEL "L.E."
    PL-PERS.profesion COLUMN-LABEL "Profesi¢n" FORMAT "x(15)"
    PL-PERS.sexper    COLUMN-LABEL "Sexo" FORMAT "x(4)"
    PL-FLG-MES.cargos COLUMN-LABEL "Cargo"  FORMAT "x(15)"
    PL-FLG-MES.seccion  COLUMN-LABEL "Secci¢n" FORMAT "X(15)"
    PL-FLG-MES.codafp   COLUMN-LABEL "AFP"
    PL-FLG-MES.Conyugue COLUMN-LABEL "Con-!yugue"
    PL-FLG-MES.Nro-de-Hijos COLUMN-LABEL "Nro!Hijo"
    PL-FLG-MES.fecing   COLUMN-LABEL "Fecha de!Ingreso"
    PL-FLG-MES.inivac   COLUMN-LABEL "Inicio de!Vacaciones"
    PL-FLG-MES.finvac   COLUMN-LABEL "Fin de!Vacaciones"
    PL-FLG-MES.SitAct   COLUMN-LABEL "Situaci¢n" VIEW-AS FILL-IN format "x(8)"
    HEADER
    "LISTADO DE EMPLEADOS"
    SKIP(1)
    WITH DOWN NO-BOX STREAM-IO WIDTH 400.
/*    
    ASSIGN B-aceptar:SENSITIVE = FALSE
           FILL-IN-Copias:SENSITIVE = FALSE
           FILL-IN-NRO-MES:SENSITIVE = FALSE
           hc_PSSpin:SENSITIVE = FALSE
           hc_PSSpin-2:SENSITIVE = FALSE.
    ASSIGN FILL-IN-Msg = "Espere un momento por favor. Procesando         ".
    DISPLAY FILL-IN-Msg WITH FRAME F-Main.
*/

DO i = 1 TO FILL-IN-Copias:

    OUTPUT STREAM strm-boleta TO PRINTER PAGED PAGE-SIZE 66.

    PUT STREAM strm-boleta CONTROL "~033@~0335~033F~033P~033x~001~033E~033C" CHR(66).
    PUT STREAM strm-boleta CONTROL "~033x" NULL "~017~033P".

   
    FOR EACH PL-FLG-MES WHERE PL-FLG-MES.CodCia = s-codcia   AND
                              PL-FLG-MES.Periodo = s-periodo AND
                              PL-FLG-MES.NroMes = FILL-IN-NRO-MES NO-LOCK:
        FIND PL-PERS WHERE PL-PERS.CodPer = PL-FLG-MES.CodPer NO-LOCK NO-ERROR.
        ASSIGN X-NOMPER = PL-PERS.patper + " " + PL-PERS.matper + ", " + PL-PERS.nomper.
        DISPLAY STREAM strm-boleta
        PL-FLG-MES.CodPer
        X-NOMPER         
        PL-PERS.ctipss   
        PL-PERS.dirper 
        PL-PERS.distri 
        PL-PERS.fecnac 
        PL-PERS.lelect 
        PL-PERS.profesion 
        PL-PERS.sexper    
        PL-FLG-MES.cargos 
        PL-FLG-MES.seccion
        PL-FLG-MES.codafp 
        PL-FLG-MES.Conyugue 
        PL-FLG-MES.Nro-de-Hijos
        PL-FLG-MES.fecing 
        PL-FLG-MES.inivac 
        PL-FLG-MES.finvac
        PL-FLG-MES.SitAct
        WITH FRAME f-cab.
        IF LINE-COUNTER( strm-boleta ) > 62 THEN PAGE STREAM strm-boleta.
    END.
    
    OUTPUT STREAM strm-boleta CLOSE.
END.
/*
ASSIGN
    FILL-IN-NroCopia:VISIBLE = FALSE
    FILL-IN-NroCopia = 0
    B-aceptar:SENSITIVE = TRUE
    FILL-IN-Copias:SENSITIVE = TRUE
    FILL-IN-NRO-MES:SENSITIVE = TRUE
    hc_PSSpin:SENSITIVE = TRUE
    hc_PSSpin-2:SENSITIVE = TRUE.
    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN
        FILL-IN-NRO-MES = s-NroMes
        FILL-IN-Copias  = 2
        FILL-IN-CodPer:VISIBLE IN FRAME F-Main = FALSE
        FILL-IN-Msg:VISIBLE = FALSE
        FILL-IN-NroCopia:VISIBLE = FALSE.

    DISPLAY FILL-IN-NRO-MES FILL-IN-Copias WITH FRAME F-Main.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
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
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


