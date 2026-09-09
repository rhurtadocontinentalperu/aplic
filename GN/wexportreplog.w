&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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
DEF INPUT PARAMETER pParametro AS CHAR.
/* Sintaxis:
    CENTRAL: Se recibe o envía desde el servidor CENTRAL de Lima
    REMOTA:  Se recibe o envía desde el servidor REMOTO de una tienda 
*/    
IF LOOKUP(pParametro, 'CENTRAL,REMOTA') = 0 THEN RETURN ERROR.

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-Tabla AS CHAR NO-UNDO.

s-Tabla = TRIM(pParametro) + '-' + "EXPORTAR".

&SCOPED-DEFINE Condicion logtabla.codcia = s-codcia ~
AND logtabla.Tabla = s-Tabla  ~
AND logtabla.Evento = "EXPORTAR"

DEF STREAM Reporte.

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
&Scoped-define INTERNAL-TABLES logtabla

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 logtabla.ValorLlave ~
logtabla.Usuario logtabla.Dia logtabla.Hora 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH logtabla ~
      WHERE {&Condicion} NO-LOCK ~
    BY logtabla.Dia DESCENDING ~
       BY logtabla.Hora DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH logtabla ~
      WHERE {&Condicion} NO-LOCK ~
    BY logtabla.Dia DESCENDING ~
       BY logtabla.Hora DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 logtabla
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 logtabla


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnOK BtnDone FILL-IN-Fecha-1 ~
FILL-IN-Fecha-2 COMBO-BOX-CodDiv BROWSE-2 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Fecha-1 FILL-IN-Fecha-2 ~
COMBO-BOX-CodDiv 

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
     SIZE 10 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BtnOK AUTO-GO DEFAULT 
     IMAGE-UP FILE "img/tbldat.ico":U
     LABEL "Exportar LOG" 
     SIZE 10 BY 1.54 TOOLTIP "Exportar LOG"
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-CodDiv AS CHARACTER FORMAT "X(256)":U INITIAL "Seleccione el Destino" 
     LABEL "Sede" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Seleccione el Destino","Seleccione el Destino"
     DROP-DOWN-LIST
     SIZE 69 BY .92 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Migrar LOG desde el" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      logtabla SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 W-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      logtabla.ValorLlave COLUMN-LABEL "Observaciones" FORMAT "x(80)":U
      logtabla.Usuario FORMAT "x(12)":U
      logtabla.Dia FORMAT "99/99/9999":U
      logtabla.Hora FORMAT "X(8)":U WIDTH 12.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 119 BY 12.5
         TITLE "Historial de Exportaciones" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BtnOK AT ROW 1.19 COL 100 WIDGET-ID 6
     BtnDone AT ROW 1.19 COL 110 WIDGET-ID 8
     FILL-IN-Fecha-1 AT ROW 1.38 COL 22 COLON-ALIGNED WIDGET-ID 2
     FILL-IN-Fecha-2 AT ROW 2.54 COL 22 COLON-ALIGNED WIDGET-ID 4
     COMBO-BOX-CodDiv AT ROW 3.69 COL 22 COLON-ALIGNED WIDGET-ID 10
     BROWSE-2 AT ROW 4.85 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 122.29 BY 17 WIDGET-ID 100.


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
         TITLE              = "EXPORTACION DEL LOG DE MOVIMIENTOS"
         HEIGHT             = 17
         WIDTH              = 122.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 134.86
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 134.86
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartWindowCues" W-Win _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartWindow,ab,49271
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
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
/* BROWSE-TAB BROWSE-2 COMBO-BOX-CodDiv F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "INTEGRAL.logtabla"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.logtabla.Dia|no,INTEGRAL.logtabla.Hora|no"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > INTEGRAL.logtabla.ValorLlave
"ValorLlave" "Observaciones" "x(80)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.logtabla.Usuario
     _FldNameList[3]   = INTEGRAL.logtabla.Dia
     _FldNameList[4]   > INTEGRAL.logtabla.Hora
"Hora" ? ? "character" ? ? ? ? ? ? no ? no no "12.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* EXPORTACION DEL LOG DE MOVIMIENTOS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* EXPORTACION DEL LOG DE MOVIMIENTOS */
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



&Scoped-define SELF-NAME BtnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOK W-Win
ON CHOOSE OF BtnOK IN FRAME F-Main /* Exportar LOG */
DO:
  ASSIGN FILL-IN-Fecha-1 FILL-IN-Fecha-2 COMBO-BOX-CodDiv.
  IF FILL-IN-Fecha-1 = ? OR FILL-IN-Fecha-2 = ?
      OR FILL-IN-Fecha-1  > FILL-IN-Fecha-2
      OR FILL-IN-Fecha-2 > TODAY - 1
      THEN DO:
      MESSAGE 'Ingrese correctamente los rangos de fecha' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN-Fecha-1.
      RETURN NO-APPLY.
  END.
  IF COMBO-BOX-CodDiv BEGINS 'Seleccione' THEN DO:
      MESSAGE 'Selecciona un destino' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO COMBO-BOX-CodDiv.
      RETURN NO-APPLY.
  END.
  DEF VAR x-Archivo AS CHAR INIT 'replog.d' NO-UNDO.
  DEF VAR rpta AS LOG NO-UNDO.
  SYSTEM-DIALOG GET-FILE x-Archivo
      FILTERS "*.d" "*.d"
      ASK-OVERWRITE
      CREATE-TEST-FILE
      DEFAULT-EXTENSION ".d" 
      SAVE-AS
      TITLE "Archivo de exportación del log"
      USE-FILENAME
      UPDATE rpta.
  IF rpta = NO THEN RETURN NO-APPLY.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Temporal (x-Archivo).
  SESSION:SET-WAIT-STATE('').
  {&OPEN-QUERY-{&BROWSE-NAME}}
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pArchivo AS CHAR.

OUTPUT STREAM Reporte TO VALUE(pArchivo).
CASE pParametro:
    WHEN "REMOTA" THEN DO:
        FOR EACH replog NO-LOCK WHERE replog.FlgDb0 = NO USE-INDEX Idx0:
            EXPORT STREAM Reporte replog.
        END.
    END.
    WHEN "CENTRAL" THEN DO:
        CASE COMBO-BOX-CodDiv:
            WHEN "00023" THEN DO:
                FOR EACH replog NO-LOCK WHERE replog.FlgDb2 = NO 
                    AND DATE(replog.LogDate) >= FILL-IN-Fecha-1
                    AND DATE(replog.LogDate) <= FILL-IN-Fecha-2
                    USE-INDEX Idx02:
                    EXPORT STREAM Reporte replog.
                END.
            END.
            WHEN "00027" THEN DO:
                FOR EACH replog NO-LOCK WHERE replog.FlgDb3 = NO 
                    AND DATE(replog.LogDate) >= FILL-IN-Fecha-1
                    AND DATE(replog.LogDate) <= FILL-IN-Fecha-2
                    USE-INDEX Idx03:
                    EXPORT STREAM Reporte replog.
                END.
            END.
        END CASE.
    END.
END CASE.
OUTPUT STREAM Reporte CLOSE.
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = COMBO-BOX-CodDiv
    NO-LOCK.
CREATE logtabla.
ASSIGN
    logtabla.codcia = s-codcia
    logtabla.Dia = TODAY
    logtabla.Evento = "EXPORTAR"
    logtabla.Hora = STRING(TIME, 'HH:MM:SS')
    logtabla.Tabla = s-Tabla
    logtabla.Usuario = s-user-id
    logtabla.ValorLlave = "DESTINO: " + GN-DIVI.CodDiv + ' - ' + GN-DIVI.DesDiv + ' ' +
                            "Desde el dia " + STRING(FILL-IN-Fecha-1) +
                            ' hasta el dia ' + STRING(FILL-IN-Fecha-2).
                            
RELEASE logtabla.

END PROCEDURE.

/*
{replica/p-batch.i &Campo = FlgDb0 &LLave = Idx0}

    DEFINE VARIABLE L-FLG  AS LOGICAL NO-UNDO.
DEFINE VARIABLE X-PROG AS CHAR FORMAT "x(20)" NO-UNDO.
DEFINE BUFFER b-replog FOR integral.replog.

    FOR EACH integral.replog NO-LOCK WHERE integral.replog.{&Campo} = NO 
        USE-INDEX {&Llave}:
        FIND b-replog WHERE ROWID(b-replog) = ROWID(integral.replog)
            EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
        IF NOT AVAILABLE b-replog THEN DO:
            PAUSE 2.
            NEXT.
        END.
        DISPLAY integral.replog.LogDate integral.replog.TableName integral.replog.Event 
            TODAY STRING(TIME,'HH:MM')
            WITH STREAM-IO NO-BOX WIDTH 200.
        X-PROG = TRIM(LC(integral.replog.RunProgram)).
        RUN VALUE(X-PROG) (b-replog.TransactionID, OUTPUT L-FLG).
        ASSIGN b-replog.{&Campo} = L-FLG.
        RELEASE b-replog.
    END. 
*/

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
  DISPLAY FILL-IN-Fecha-1 FILL-IN-Fecha-2 COMBO-BOX-CodDiv 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BtnOK BtnDone FILL-IN-Fecha-1 FILL-IN-Fecha-2 COMBO-BOX-CodDiv 
         BROWSE-2 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
      FILL-IN-Fecha-1 = (TODAY - 1) - DAY(TODAY - 1) + 1
      FILL-IN-Fecha-2 = TODAY - 1.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-CodDiv:DELIMITER = '|'.
      CASE pParametro:
          WHEN "CENTRAL" THEN DO:
              FIND gn-divi WHERE gn-divi.codcia = s-codcia
                  AND gn-divi.coddiv = '00023' NO-LOCK.
              COMBO-BOX-CodDiv:ADD-LAST(GN-DIVI.CodDiv + ' - ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv).
              FIND gn-divi WHERE gn-divi.codcia = s-codcia
                  AND gn-divi.coddiv = '00027' NO-LOCK.
              COMBO-BOX-CodDiv:ADD-LAST(GN-DIVI.CodDiv + ' - ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv).
          END.
          WHEN "REMOTA" THEN DO:
              FIND gn-divi WHERE gn-divi.codcia = s-codcia
                  AND gn-divi.coddiv = '00003'.
              COMBO-BOX-CodDiv:ADD-LAST(GN-DIVI.CodDiv + ' - ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv).
          END.
      END CASE.
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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "logtabla"}

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

