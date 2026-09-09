&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODDIV AS CHARACTER.
DEF SHARED VAR cl-codcia AS INT.
DEFINE NEW GLOBAL SHARED VAR S-task-no AS integer.

DEFINE VAR I-TPOREP AS INTEGER INIT 1.

/* Local Variable Definitions ---                                       */
def var tporep as integer.
def var subtit as character.
def var subtit-1 as character.
def var subdiv as character format 'x(50)'.

DEF TEMP-TABLE DETALLE LIKE Ccbcdocu
    FIELDS tt-implin AS DECIMAL FORMAT "->>>,>>>,>>9.99".

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
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BUTTON-2 x-Desde x-Hasta BUTTON-6 ~
x-FchDoc rs-opcion BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS F-Division x-Desde x-Hasta x-FchDoc ~
rs-opcion x-mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "..." 
     SIZE 3 BY .77.

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 2" 
     SIZE 12 BY 1.5.

DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 3" 
     SIZE 12 BY 1.5.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 6" 
     SIZE 12 BY 1.5.

DEFINE VARIABLE F-Division AS CHARACTER FORMAT "X(60)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81
     BGCOLOR 15 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE x-Desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-FchDoc AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Corte" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-Hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81 NO-UNDO.

DEFINE VARIABLE x-mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 80 BY .81 NO-UNDO.

DEFINE VARIABLE rs-opcion AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Division", 1,
"Resumnido", 2
     SIZE 21 BY 1.12 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Division AT ROW 1.81 COL 14 COLON-ALIGNED WIDGET-ID 26
     BUTTON-1 AT ROW 1.81 COL 60 WIDGET-ID 18
     BUTTON-2 AT ROW 2.08 COL 73 WIDGET-ID 52
     x-Desde AT ROW 2.85 COL 14 COLON-ALIGNED WIDGET-ID 58
     x-Hasta AT ROW 2.85 COL 36 COLON-ALIGNED WIDGET-ID 60
     BUTTON-6 AT ROW 3.69 COL 73 WIDGET-ID 62
     x-FchDoc AT ROW 3.92 COL 14 COLON-ALIGNED WIDGET-ID 42
     rs-opcion AT ROW 5.04 COL 16 NO-LABEL WIDGET-ID 64
     BUTTON-3 AT ROW 5.31 COL 73 WIDGET-ID 54
     x-mensaje AT ROW 6.92 COL 3 COLON-ALIGNED NO-LABEL WIDGET-ID 56
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 87.86 BY 8.42
         FONT 1 WIDGET-ID 100.


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
         TITLE              = "Reporte Documentos por Cobrar"
         HEIGHT             = 8.42
         WIDTH              = 87.86
         MAX-HEIGHT         = 19.69
         MAX-WIDTH          = 97.29
         VIRTUAL-HEIGHT     = 19.69
         VIRTUAL-WIDTH      = 97.29
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
{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN F-Division IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte Documentos por Cobrar */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte Documentos por Cobrar */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
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


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
    ASSIGN F-Division x-Desde x-FchDoc x-Hasta.

    RUN IMPRIMIR.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
    ASSIGN F-Division x-Desde x-FchDoc x-Hasta rs-opcion.
    
    IF rs-opcion = 1 THEN RUN Excel.
    ELSE RUN Excel-R.
    /*
    RUN xxx.
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Division W-Win
ON LEAVE OF F-Division IN FRAME F-Main /* Division */
DO:
/*    Find gn-divi where gn-divi.codcia = s-codcia and gn-divi.coddiv = F-Division:screen-value no-lock no-error.
 *     If available gn-divi then
 *         F-DesDiv:screen-value = gn-divi.desdiv.
 *     else
 *         F-DesDiv:screen-value = "".*/
    ASSIGN F-Division.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

DEFINE VAR XDOCINI AS CHAR.
DEFINE VAR XDOCFIN AS CHAR.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal W-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH DETALLE:
      DELETE DETALLE.
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

    DEF VAR x-Control  AS INT       NO-UNDO.
    DEF VAR x-Division AS CHAR      NO-UNDO.
    
    DO x-Control = 1 TO NUM-ENTRIES(f-Division):
        x-Division = ENTRY(x-Control, f-Division).
        /* DOS procesos */
        IF x-FchDoc < TODAY THEN DO:
            FOR EACH Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
                /*AND Ccbcdocu.coddoc BEGINS x-Docu*/
                AND LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL,N/C,N/D,LET,A/R,BD') > 0
                AND Ccbcdocu.coddiv = x-Division
                /*AND Ccbcdocu.flgest <> 'A'*/
                AND LOOKUP(Ccbcdocu.flgest,"P,J") > 0
                AND (x-Desde = ? OR Ccbcdocu.fchdoc >= x-Desde)
                AND (x-Hasta = ? OR Ccbcdocu.fchdoc <= x-Hasta)
                AND Ccbcdocu.fchdoc <= x-FchDoc NO-LOCK,
                FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
                    AND gn-clie.codcli = Ccbcdocu.codcli:

                DISPLAY "Procesando: " + STRING(ccbcdocu.fchdoc) + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc @ x-mensaje
                    WITH FRAME {&FRAME-NAME}.

                /* RHC 03.11.05 hay casos que no tiene sustento de cancelacion => nos fijamos en la fecha de cancelacion */
                IF ccbcdocu.flgest = 'C' 
                    AND ccbcdocu.fchcan <> ? 
                    AND ccbcdocu.fchcan <= x-FchDoc THEN DO:
                    FIND FIRST Ccbdcaja WHERE ccbdcaja.codcia = s-codcia
                        AND Ccbdcaja.codref = Ccbcdocu.coddoc
                        AND Ccbdcaja.nroref = Ccbcdocu.nrodoc NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE ccbdcaja THEN NEXT.
                END.

                IF ccbcdocu.flgest = 'C' AND ccbcdocu.fchcan = ? THEN NEXT.   /* Suponemos que está cancelada en la fecha */
                /* ***************************************************************************************************** */

                CREATE DETALLE.
                BUFFER-COPY Ccbcdocu TO DETALLE
                    ASSIGN DETALLE.sdoact = Ccbcdocu.imptot.
                /* Buscamos las cancelaciones */
                FOR EACH Ccbdcaja WHERE ccbdcaja.codcia = s-codcia
                    AND Ccbdcaja.codref = Ccbcdocu.coddoc
                    AND Ccbdcaja.nroref = Ccbcdocu.nrodoc
                    AND Ccbdcaja.fchdoc <= x-FchDoc NO-LOCK:
                    ASSIGN
                        DETALLE.SdoAct = DETALLE.SdoAct - Ccbdcaja.imptot.
                END.

                /*
                IF DETALLE.CodDoc = 'N/C' THEN DO:
                    FOR EACH Ccbdcaja WHERE ccbdcaja.codcia = s-codcia
                        AND Ccbdcaja.coddoc = Ccbcdocu.coddoc
                        AND Ccbdcaja.nrodoc = Ccbcdocu.nrodoc
                        AND Ccbdcaja.fchdoc <= x-FchDoc NO-LOCK:
                        ASSIGN
                            DETALLE.SdoAct = DETALLE.SdoAct - Ccbdcaja.imptot.
                    END.
                END.
                */
                IF lookup(Detalle.CodDoc,"N/C,A/R,BD") > 0  THEN
                    Detalle.SdoAct = CcbCDocu.SdoAct.


            END.
            HIDE FRAME F-Mensaje.
        END.
        ELSE DO:
            FOR EACH Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
                AND LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL,N/C,N/D,CHQ,LET,A/R,BD') > 0
                AND (x-Desde = ? OR Ccbcdocu.fchdoc >= x-Desde)
                AND (x-Hasta = ? OR Ccbcdocu.fchdoc <= x-Hasta)
                AND Ccbcdocu.coddiv = x-Division                
                AND lookup(Ccbcdocu.flgest,'J,P') > 0 NO-LOCK,
                FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
                    AND gn-clie.codcli = Ccbcdocu.codcli:

                DISPLAY "Procesando: " + STRING(ccbcdocu.fchdoc) + " " + ccbcdocu.coddoc + " " + 
                    ccbcdocu.nrodoc @ x-mensaje
                    WITH FRAME {&FRAME-NAME}.

                CREATE DETALLE.
                BUFFER-COPY Ccbcdocu TO DETALLE
                    /*ASSIGN DETALLE.sdoact = Ccbcdocu.sdoact*/  .
                IF DETALLE.FchVto = ? THEN DETALLE.FchVto = DETALLE.FchDoc.

            END.
        END.
    END.

    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

    /* Depuramos los cancelados */
    FOR EACH DETALLE:
        IF DETALLE.sdoact <= 0 THEN DO:
            DELETE DETALLE.
            NEXT.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cargando W-Win 
PROCEDURE Cargando :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR x-Control  AS INT       NO-UNDO.
    DEF VAR x-Division AS CHAR      NO-UNDO.
    
    DO x-Control = 1 TO NUM-ENTRIES(f-Division):
        x-Division = ENTRY(x-Control, f-Division).
        /* DOS procesos */
        IF x-FchDoc < TODAY THEN DO:
            FOR EACH Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
                /*AND Ccbcdocu.coddoc BEGINS x-Docu*/
                AND LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL,N/C,N/D,LET,A/R,BD') > 0
                AND Ccbcdocu.coddiv = x-Division
                /*AND Ccbcdocu.flgest <> 'A'*/
                AND LOOKUP(Ccbcdocu.flgest,"P,J") > 0
                AND Ccbcdocu.fchdoc >= x-Desde
                AND Ccbcdocu.fchdoc <= x-Hasta
                AND Ccbcdocu.fchdoc <= x-FchDoc NO-LOCK,
                FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
                    AND gn-clie.codcli = Ccbcdocu.codcli:

                DISPLAY "Procesando: " + STRING(ccbcdocu.fchdoc) + " " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc @ x-mensaje
                    WITH FRAME {&FRAME-NAME}.

                /* RHC 03.11.05 hay casos que no tiene sustento de cancelacion => nos fijamos en la fecha de cancelacion */
                IF ccbcdocu.flgest = 'C' 
                    AND ccbcdocu.fchcan <> ? 
                    AND ccbcdocu.fchcan <= x-FchDoc THEN DO:
                    FIND FIRST Ccbdcaja WHERE ccbdcaja.codcia = s-codcia
                        AND Ccbdcaja.codref = Ccbcdocu.coddoc
                        AND Ccbdcaja.nroref = Ccbcdocu.nrodoc NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE ccbdcaja THEN NEXT.
                END.

                IF ccbcdocu.flgest = 'C' AND ccbcdocu.fchcan = ? THEN NEXT.   /* Suponemos que está cancelada en la fecha */
                /* ***************************************************************************************************** */

                CREATE DETALLE.
                BUFFER-COPY Ccbcdocu TO DETALLE.

                /*
                    ASSIGN DETALLE.sdoact = Ccbcdocu.imptot.
                /* Buscamos las cancelaciones */
                FOR EACH Ccbdcaja WHERE ccbdcaja.codcia = s-codcia
                    AND Ccbdcaja.codref = Ccbcdocu.coddoc
                    AND Ccbdcaja.nroref = Ccbcdocu.nrodoc
                    AND Ccbdcaja.fchdoc <= x-FchDoc NO-LOCK:
                    ASSIGN
                        DETALLE.SdoAct = DETALLE.SdoAct - Ccbdcaja.imptot.
                END.            
                */
/*
                IF DETALLE.CodDoc = 'N/C' THEN DO:
                    FOR EACH Ccbdcaja WHERE ccbdcaja.codcia = s-codcia
                        AND Ccbdcaja.coddoc = Ccbcdocu.coddoc
                        AND Ccbdcaja.nrodoc = Ccbcdocu.nrodoc
                        AND Ccbdcaja.fchdoc <= x-FchDoc NO-LOCK:
                        ASSIGN
                            DETALLE.SdoAct = DETALLE.SdoAct - Ccbdcaja.imptot.
                    END.
                END.
*/                

/*                 IF lookup(DETALLE.CodDoc,'N/C,A/R,B/D') > 0 THEN DO:            */
/*                     FOR EACH Ccbdcaja WHERE ccbdcaja.codcia = s-codcia          */
/*                         AND Ccbdcaja.coddoc = Ccbcdocu.coddoc                   */
/*                         AND Ccbdcaja.nrodoc = Ccbcdocu.nrodoc                   */
/*                         AND Ccbdcaja.fchdoc <= x-FchDoc NO-LOCK:                */
/*                         ASSIGN                                                  */
/*                             DETALLE.SdoAct = DETALLE.SdoAct - Ccbdcaja.imptot.  */
/*                     END.                                                        */
/*                 END.                                                            */
            END.
            HIDE FRAME F-Mensaje.
        END.
        ELSE DO:
            FOR EACH Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
                AND LOOKUP(TRIM(ccbcdocu.coddoc), 'FAC,BOL,N/C,N/D,LET,A/R,BD') > 0
                AND Ccbcdocu.coddiv = x-Division
                /*
                AND Ccbcdocu.flgest = 'P' 
                */
                AND LOOKUP(Ccbcdocu.flgest,"P,J") > 0 NO-LOCK,
                FIRST gn-clie NO-LOCK WHERE gn-clie.codcia = cl-codcia
                    AND gn-clie.codcli = Ccbcdocu.codcli:

                DISPLAY "Procesando: " + STRING(ccbcdocu.fchdoc) + " " + ccbcdocu.coddoc + " " + 
                    ccbcdocu.nrodoc @ x-mensaje
                    WITH FRAME {&FRAME-NAME}.

                CREATE DETALLE.
                BUFFER-COPY Ccbcdocu TO DETALLE.
                /*
                    ASSIGN DETALLE.sdoact = Ccbcdocu.sdoact.
                */    
                IF DETALLE.FchVto = ? THEN DETALLE.FchVto = DETALLE.FchDoc.

            END.
        END.
    END.

    DISPLAY "" @ x-mensaje WITH FRAME {&FRAME-NAME}.

    /* Depuramos los cancelados */
    FOR EACH DETALLE:
        IF DETALLE.sdoact <= 0 THEN DO:
            DELETE DETALLE.
            NEXT.
        END.
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
  DISPLAY F-Division x-Desde x-Hasta x-FchDoc rs-opcion x-mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-1 BUTTON-2 x-Desde x-Hasta BUTTON-6 x-FchDoc rs-opcion BUTTON-3 
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
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    DEFINE VARIABLE dSdoAct-1 AS DECIMAL    NO-UNDO EXTENT 2.
    DEFINE VARIABLE dSdoAct-2 AS DECIMAL    NO-UNDO EXTENT 2.
    DEFINE VARIABLE cNomCli   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE x-factor  AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dTotal    AS DECIMAL    NO-UNDO EXTENT 4.
    dTotal = 0.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    RUN Borra-Temporal.
    /*RUN Cargando.*/
    RUN Carga-Temporal.

    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "RESUMEN DOCUMENTOS POR COBRAR AL " + STRING(x-FchDoc ).
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "DESDE: " + STRING(x-Desde).
    cColumn = STRING(iCount).
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "HASTA: " + STRING(x-Hasta).

    iCount = iCount + 2.
    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "DIV".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "CODIGO".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "CLIENTE".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. VENCIDOS IMPORTE S/.".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. VENCIDOC IMPORTE $".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. POR VENCER IMPORTE S/.".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. POR VENCER IMPORTE $".
    iCount = iCount + 1.

    FOR EACH DETALLE NO-LOCK 
        BREAK BY DETALLE.CodCia
        BY DETALLE.CodDiv
        BY DETALLE.CodCli:
        
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = detalle.codcli NO-LOCK NO-ERROR.
        IF AVAIL gn-clie THEN cNomCli = gn-clie.nomcli.
        ELSE cNomCli = "".

        IF lookup(Detalle.CodDoc,"N/C,A/R,BD") > 0  
            THEN Detalle.SdoAct = -1 * Detalle.SdoAct.
        ELSE x-Factor = 1 * Detalle.SdoAct.

        IF FIRST-OF(Detalle.CodCli) THEN DO:
            dSdoAct-1 = 0.
            dSdoAct-2 = 0.
        END.

        IF Detalle.FchVto < TODAY THEN DO:
            CASE Detalle.CodMon:
                WHEN 1 THEN dSdoAct-1[1] = Detalle.SdoAct + dSdoAct-1[1].
                WHEN 2 THEN dSdoAct-1[2] = Detalle.SdoAct + dSdoAct-1[2].
            END CASE.
        END.
        ELSE DO:
            CASE Detalle.CodMon:
                WHEN 1 THEN dSdoAct-2[1] = Detalle.SdoAct + dSdoAct-2[1].
                WHEN 2 THEN dSdoAct-2[2] = Detalle.SdoAct + dSdoAct-2[2].
            END CASE.
        END.

        IF LAST-OF(Detalle.CodCli) THEN DO:
            cColumn = STRING(iCount).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + Detalle.CodDiv.
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + Detalle.CodCli.
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = cNomCli.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = dSdoAct-1[1].
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = dSdoAct-1[2].
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = dSdoAct-2[1].
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = dSdoAct-2[2].
            iCount = iCount + 1.

            /*Totales*/
            dTotal[1] = dTotal[1] + dSdoAct-1[1].
            dTotal[2] = dTotal[2] + dSdoAct-1[2].
            dTotal[3] = dTotal[3] + dSdoAct-2[1].
            dTotal[4] = dTotal[4] + dSdoAct-2[2].
        END.

        IF LAST (Detalle.CodDiv) THEN DO:
            cColumn = STRING(iCount).
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = "Total".
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[1].
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[2].
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[3].
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[4].
            
        END.
    END.





  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  /* release com-handles */
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-R W-Win 
PROCEDURE Excel-R :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    DEFINE VARIABLE dSdoAct-1 AS DECIMAL    NO-UNDO EXTENT 2.
    DEFINE VARIABLE dSdoAct-2 AS DECIMAL    NO-UNDO EXTENT 2.
    DEFINE VARIABLE cNomCli   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE x-factor  AS DECIMAL    NO-UNDO INIT 1.
    DEFINE VARIABLE dTotal    AS DECIMAL    NO-UNDO EXTENT 4.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    RUN Borra-Temporal.
    /*RUN Cargando.*/
    RUN Carga-Temporal.

    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "RESUMEN DOCUMENTOS POR COBRAR AL " + STRING(x-FchDoc ).
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "DESDE: " + STRING(x-Desde).
    cColumn = STRING(iCount).
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "HASTA: " + STRING(x-Hasta).

    iCount = iCount + 2.
    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    /*
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "DIV".
    */
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "CODIGO".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "CLIENTE".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. VENCIDOS IMPORTE S/.".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. VENCIDOC IMPORTE $".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. POR VENCER IMPORTE S/.".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. POR VENCER IMPORTE $".
    iCount = iCount + 1.

    FOR EACH DETALLE NO-LOCK 
        BREAK BY DETALLE.CodCia
        /*BY DETALLE.CodDiv*/
        BY DETALLE.CodCli:
        
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = detalle.codcli NO-LOCK NO-ERROR.
        IF AVAIL gn-clie THEN cNomCli = gn-clie.nomcli.
        ELSE cNomCli = "".

        
        IF lookup(Detalle.CodDoc,"N/C,A/R,BD") > 0  THEN x-Factor = -1.
        ELSE x-Factor = 1.
        

        IF FIRST-OF(Detalle.CodCli) THEN DO:
            dSdoAct-1 = 0.
            dSdoAct-2 = 0.
        END.

        IF Detalle.FchVto < TODAY THEN DO:
            CASE Detalle.CodMon:
                WHEN 1 THEN dSdoAct-1[1] = (Detalle.SdoAct * x-factor) + dSdoAct-1[1].
                WHEN 2 THEN dSdoAct-1[2] = (Detalle.SdoAct * x-factor) + dSdoAct-1[2].
            END CASE.
        END.
        ELSE DO:
            CASE Detalle.CodMon:
                WHEN 1 THEN dSdoAct-2[1] = (Detalle.SdoAct * x-factor) + dSdoAct-2[1].
                WHEN 2 THEN dSdoAct-2[2] = (Detalle.SdoAct * x-factor) + dSdoAct-2[2].
            END CASE.
        END.

        IF LAST-OF(Detalle.CodCli) THEN DO:
            cColumn = STRING(iCount).
            /*
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + Detalle.CodDiv.
            */
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + Detalle.CodCli.
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = cNomCli.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = dSdoAct-1[1].
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = dSdoAct-1[2].
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = dSdoAct-2[1].
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = dSdoAct-2[2].
            iCount = iCount + 1.

            /*Totales*/
            dTotal[1] = dTotal[1] + dSdoAct-1[1].
            dTotal[2] = dTotal[2] + dSdoAct-1[2].
            dTotal[3] = dTotal[3] + dSdoAct-2[1].
            dTotal[4] = dTotal[4] + dSdoAct-2[2].
        END.

        IF LAST (Detalle.CodCli) THEN DO:
            cColumn = STRING(iCount).
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = "Total".
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[1].
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[2].
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[3].
            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = dTotal[4].
            
        END.
    END.

    /* launch Excel so it is visible to the user */
    chExcelApplication:Visible = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato-1 W-Win 
PROCEDURE Formato-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dSdoAct-1 AS DECIMAL NO-UNDO EXTENT 2.
    DEFINE VARIABLE dSdoAct-2 AS DECIMAL NO-UNDO EXTENT 2.
    DEFINE VARIABLE cNomCli   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-factor  AS DECIMAL   NO-UNDO.

    DEFINE FRAME F-Titulo
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN7B} + {&PRN4} + {&PRN6B} FORMAT "X(45)" 
        {&PRN6A} + "PAG.  : " AT 103 PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "RESUMEN DOCUMENTOS POR COBRAR AL " AT 50 x-FchDoc  AT 85 
        "FECHA : " AT 115 TODAY SKIP     
        "DESDE : " x-Desde 
        "HASTA : " AT 115 x-Hasta SKIP     
        "------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                              Documentos  Vencidos            Documentos por Vencer                                    " SKIP
        "Div   Cliente      Razon Social                                           Importe S/.      Importe $.      Importe S/.      Importe $.          " SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*
                  1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16
         12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         123 XXX-XXXXXX 99/99/9999 99/99/9999 (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) (>>>,>>9.99) 
*/

        WITH PAGE-TOP NO-LABELS NO-BOX NO-UNDERLINE WIDTH 250 STREAM-IO DOWN.

    DEFINE FRAME F-Detalle
        DETALLE.CodDiv 
        DETALLE.CodCli FORMAT "XXXXXXXXXXX"
        DETALLE.NomCli 
        dSdoAct-1[1]   FORMAT "->>>,>>>,>>9.99"  
        dSdoAct-1[2]   FORMAT "->>>,>>>,>>9.99"  
        dSdoAct-2[1]   FORMAT "->>>,>>>,>>9.99"
        dSdoAct-2[2]   FORMAT "->>>,>>>,>>9.99"
        WITH NO-LABELS NO-BOX NO-UNDERLINE WIDTH 190 STREAM-IO DOWN.

    FOR EACH DETALLE NO-LOCK 
        BREAK BY DETALLE.CodCia
        BY DETALLE.CodDiv
        BY DETALLE.CodCli:
        
        VIEW STREAM REPORT FRAME F-Titulo.

        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = detalle.codcli NO-LOCK NO-ERROR.
        IF AVAIL gn-clie THEN cNomCli = gn-clie.nomcli.
        ELSE cNomCli = "".

        IF lookup(Detalle.CodDoc,"N/C,A/R,BD,CHQ") > 0  THEN x-Factor = -1.
        ELSE x-Factor = 1.
        
        IF FIRST-OF(Detalle.CodCli) THEN DO:
            dSdoAct-1 = 0.
            dSdoAct-2 = 0.
        END.

        IF Detalle.FchVto < TODAY THEN DO:
            CASE Detalle.CodMon:
                WHEN 1 THEN dSdoAct-1[1] = (Detalle.SdoAct * x-factor) + dSdoAct-1[1].
                WHEN 2 THEN dSdoAct-1[2] = (Detalle.SdoAct * x-factor) + dSdoAct-1[2].
            END CASE.
        END.
        ELSE DO:
            CASE Detalle.CodMon:
                WHEN 1 THEN dSdoAct-2[1] = (Detalle.SdoAct * x-factor) + dSdoAct-2[1].
                WHEN 2 THEN dSdoAct-2[2] = (Detalle.SdoAct * x-factor) + dSdoAct-2[2].
            END CASE.
        END.

        IF LAST-OF(Detalle.CodCli) THEN
            DISPLAY STREAM Report
                Detalle.CodDiv
                Detalle.CodCli
                cNomCli @ Detalle.NomCli
                dSdoAct-1[1]
                dSdoAct-1[2]
                dSdoAct-2[1]
                dSdoAct-2[2]
                WITH FRAME f-Detalle.     
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir W-Win 
PROCEDURE imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.   

    RUN Borra-Temporal.
    RUN Carga-Temporal.

    IF F-Division = "" THEN  subdiv = "".
    ELSE subdiv = "Division : " + F-Division.

    subtit-1 = 'FECHA DE CORTE: ' + STRING(x-FchDoc).

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

        RUN Formato-1.

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
  
  DEF VAR xx as logical.
  x-fchdoc = TODAY.

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
        WHEN "" THEN .
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE XXX W-Win 
PROCEDURE XXX :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook         AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet        AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE iCount             AS INTEGER INITIAL 1 NO-UNDO.
    DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange             AS CHARACTER NO-UNDO.

    DEFINE VARIABLE dSdoAct-1 AS DECIMAL    NO-UNDO EXTENT 2.
    DEFINE VARIABLE dSdoAct-2 AS DECIMAL    NO-UNDO EXTENT 2.
    DEFINE VARIABLE cNomCli   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE x-factor  AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dTotal    AS DECIMAL    NO-UNDO EXTENT 4.
    dTotal = 0.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    RUN Borra-Temporal.
    /*RUN Cargando.*/
    RUN Carga-Temporal.

    /* Encabezado */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "RESUMEN DOCUMENTOS POR COBRAR AL " + STRING(x-FchDoc ).
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "DESDE: " + STRING(x-Desde).
    cColumn = STRING(iCount).
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "HASTA: " + STRING(x-Hasta).

    iCount = iCount + 2.
    /* set the column names for the Worksheet */
    iCount = iCount + 1.
    cColumn = STRING(iCount).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "DIV".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "CODIGO".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = "CLIENTE".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. VENCIDOS IMPORTE S/.".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. VENCIDOC IMPORTE $".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. POR VENCER IMPORTE S/.".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = "DOC. POR VENCER IMPORTE $".
    iCount = iCount + 1.

    FOR EACH DETALLE NO-LOCK 
        BREAK BY DETALLE.CodCia
        BY DETALLE.CodDiv
        BY DETALLE.CodCli:
        
        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = detalle.codcli NO-LOCK NO-ERROR.
        IF AVAIL gn-clie THEN cNomCli = gn-clie.nomcli.
        ELSE cNomCli = "".

        IF lookup(Detalle.CodDoc,"N/C,A/R,BD") > 0  
            THEN Detalle.SdoAct = -1 * Detalle.SdoAct.
        ELSE x-Factor = 1 * Detalle.SdoAct.

        cColumn = STRING(iCount).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Detalle.CodDoc.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + Detalle.CodCli.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = cNomCli.
        
        IF Detalle.FchVto < TODAY THEN DO:
            CASE Detalle.CodMon:
                WHEN 1 THEN DO: 
                    cRange = "D" + cColumn.
                    chWorkSheet:Range(cRange):Value = Detalle.SdoAct.
                END.
                WHEN 2 THEN DO: 
                    cRange = "E" + cColumn.
                    chWorkSheet:Range(cRange):Value = Detalle.SdoAct.
                END.
            END CASE.
        END.
        ELSE DO:
            CASE Detalle.CodMon:
                WHEN 1 THEN DO: 
                    cRange = "F" + cColumn.
                    chWorkSheet:Range(cRange):Value = Detalle.SdoAct.
                END.
                WHEN 2 THEN DO: 
                    cRange = "G" + cColumn.
                    chWorkSheet:Range(cRange):Value = Detalle.SdoAct.
                END.
            END CASE.
        END.

        iCount = iCount + 1.
   END.

  /* launch Excel so it is visible to the user */
  chExcelApplication:Visible = TRUE.

  /* release com-handles */
  RELEASE OBJECT chExcelApplication.      
  RELEASE OBJECT chWorkbook.
  RELEASE OBJECT chWorksheet.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

