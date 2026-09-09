&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-w-report NO-UNDO LIKE w-report.



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
DEF SHARED VAR s-codcia  AS INTE.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv  AS CHAR.

DEF NEW SHARED VAR s-coddoc AS CHAR INITIAL "BD".
DEF NEW SHARED VAR s-NroSer LIKE Faccorre.nroser.

DEF NEW SHARED VAR lh_Handle AS HANDLE.
DEFINE NEW SHARED VAR pCodDiv AS CHAR.

/* Control de correlativos */
FIND FacDocum WHERE facdocum.codcia = s-codcia AND facdocum.coddoc = s-coddoc
              NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum
THEN DO:
    MESSAGE "No esta definido el documento Boleta Deposito" s-coddoc VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

DEFINE VAR x-Archivo AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES GN-DIVI tt-w-report

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 GN-DIVI.CodDiv GN-DIVI.DesDiv 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH GN-DIVI ~
      WHERE gn-divi.codcia = s-codcia NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH GN-DIVI ~
      WHERE gn-divi.codcia = s-codcia NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 GN-DIVI
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 GN-DIVI


/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 tt-w-report.Campo-C[1] ~
tt-w-report.Campo-C[2] tt-w-report.Campo-D[1] tt-w-report.Campo-C[3] ~
tt-w-report.Campo-C[4] tt-w-report.Campo-C[5] tt-w-report.Campo-C[10] ~
tt-w-report.Campo-F[1] tt-w-report.Campo-C[8] tt-w-report.Campo-C[6] ~
tt-w-report.Campo-C[7] tt-w-report.Campo-C[11] tt-w-report.Campo-C[9] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH tt-w-report ~
      WHERE tt-w-report.campo-c[20] = 'X' NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH tt-w-report ~
      WHERE tt-w-report.campo-c[20] = 'X' NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 tt-w-report
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 tt-w-report


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-3 btnFromExcel BROWSE-5 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnFromExcel 
     LABEL "Excel" 
     SIZE 10 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      GN-DIVI SCROLLING.

DEFINE QUERY BROWSE-5 FOR 
      tt-w-report SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      GN-DIVI.CodDiv FORMAT "XX-XXX":U WIDTH 8.29
      GN-DIVI.DesDiv FORMAT "X(40)":U WIDTH 50.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 62.86 BY 8.35
         FONT 4 FIT-LAST-COLUMN.

DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      tt-w-report.Campo-C[1] COLUMN-LABEL "STD" FORMAT "X(3)":U
            WIDTH 5.43 COLUMN-FGCOLOR 12
      tt-w-report.Campo-C[2] COLUMN-LABEL "Cond!Vta" FORMAT "X(5)":U
      tt-w-report.Campo-D[1] COLUMN-LABEL "Fecha!Deposito" FORMAT "99/99/9999":U
      tt-w-report.Campo-C[3] COLUMN-LABEL "Bco" FORMAT "X(3)":U
      tt-w-report.Campo-C[4] COLUMN-LABEL "Nro!Deposito" FORMAT "X(10)":U
      tt-w-report.Campo-C[5] COLUMN-LABEL "Cod!Cuenta" FORMAT "X(10)":U
      tt-w-report.Campo-C[10] COLUMN-LABEL "Mone" FORMAT "X(4)":U
      tt-w-report.Campo-F[1] COLUMN-LABEL "Importe!Total" FORMAT "->,>>>,>>9.99":U
      tt-w-report.Campo-C[8] COLUMN-LABEL "EFE!CHQ" FORMAT "X(3)":U
      tt-w-report.Campo-C[6] COLUMN-LABEL "Cod!Cliente" FORMAT "X(11)":U
      tt-w-report.Campo-C[7] COLUMN-LABEL "Nombre Cliente" FORMAT "X(40)":U
            WIDTH 32.29
      tt-w-report.Campo-C[11] COLUMN-LABEL "Glosa" FORMAT "X(40)":U
      tt-w-report.Campo-C[9] COLUMN-LABEL "Descripcion del error" FORMAT "X(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 105 BY 14.23 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-3 AT ROW 2.46 COL 3.14 WIDGET-ID 200
     btnFromExcel AT ROW 9.46 COL 68 WIDGET-ID 4
     BROWSE-5 AT ROW 11 COL 4 WIDGET-ID 300
     "CARGA MASIVA DE DEPOSITOS" VIEW-AS TEXT
          SIZE 43 BY .62 AT ROW 1.38 COL 32 WIDGET-ID 2
          FGCOLOR 9 FONT 11
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 110.29 BY 25.08 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Temp-Tables and Buffers:
      TABLE: tt-w-report T "?" NO-UNDO INTEGRAL w-report
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Carga masiva de depositos"
         HEIGHT             = 25.08
         WIDTH              = 110.86
         MAX-HEIGHT         = 25.73
         MAX-WIDTH          = 118.86
         VIRTUAL-HEIGHT     = 25.73
         VIRTUAL-WIDTH      = 118.86
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
/* BROWSE-TAB BROWSE-3 TEXT-1 F-Main */
/* BROWSE-TAB BROWSE-5 btnFromExcel F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "INTEGRAL.GN-DIVI"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "gn-divi.codcia = s-codcia"
     _FldNameList[1]   > INTEGRAL.GN-DIVI.CodDiv
"GN-DIVI.CodDiv" ? ? "character" ? ? ? ? ? ? no ? no no "8.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" ? ? "character" ? ? ? ? ? ? no ? no no "50.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.tt-w-report"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "tt-w-report.campo-c[20] = 'X'"
     _FldNameList[1]   > Temp-Tables.tt-w-report.Campo-C[1]
"Campo-C[1]" "STD" "X(3)" "character" ? 12 ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-w-report.Campo-C[2]
"Campo-C[2]" "Cond!Vta" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-w-report.Campo-D[1]
"Campo-D[1]" "Fecha!Deposito" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt-w-report.Campo-C[3]
"Campo-C[3]" "Bco" "X(3)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-w-report.Campo-C[4]
"Campo-C[4]" "Nro!Deposito" "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt-w-report.Campo-C[5]
"Campo-C[5]" "Cod!Cuenta" "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt-w-report.Campo-C[10]
"Campo-C[10]" "Mone" "X(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt-w-report.Campo-F[1]
"Campo-F[1]" "Importe!Total" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt-w-report.Campo-C[8]
"Campo-C[8]" "EFE!CHQ" "X(3)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt-w-report.Campo-C[6]
"Campo-C[6]" "Cod!Cliente" "X(11)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt-w-report.Campo-C[7]
"Campo-C[7]" "Nombre Cliente" "X(40)" "character" ? ? ? ? ? ? no ? no no "32.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt-w-report.Campo-C[11]
"Campo-C[11]" "Glosa" "X(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tt-w-report.Campo-C[9]
"Campo-C[9]" "Descripcion del error" "X(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Carga masiva de depositos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Carga masiva de depositos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
&Scoped-define SELF-NAME BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-3 W-Win
ON VALUE-CHANGED OF BROWSE-3 IN FRAME F-Main
DO:
  pCoddiv = gn-divi.coddiv.

  /*RUN dispatch IN h_q-docmto-02('open-query':U).*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnFromExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnFromExcel W-Win
ON CHOOSE OF btnFromExcel IN FRAME F-Main /* Excel */
DO:

    DEFINE VAR OKpressed AS LOG.

    x-Archivo = "".

	  SYSTEM-DIALOG GET-FILE x-Archivo
	    FILTERS "Archivo (*.xlsx)" "*.xlsx,*.xls"
	    MUST-EXIST
	    TITLE "Seleccione archivo..."
	    UPDATE OKpressed.   
	  IF OKpressed = NO OR x-archivo = "" THEN RETURN.

      RUN procesar-excel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-datos W-Win 
PROCEDURE cargar-datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia
      AND Faccorre.coddoc = s-coddoc
      AND Faccorre.coddiv = pCodDiv
      AND Faccorre.flgest = YES
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccorre THEN DO:
      MESSAGE 'La division(' + pCoddiv + ") y Documento (" + s-coddoc + ") no configurado de correlativos!!!"
          VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.

  END.
  s-NroSer = Faccorre.nroser.
  
  FIND Faccorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddiv = pCodDiv
    AND Faccorre.coddoc = s-coddoc
    AND Faccorre.nroser = s-nroser
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccorre THEN DO:
    MESSAGE 'No esta definido el control de correlativos de la division(' + pCoddiv + ")"
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
  END.

SESSION:SET-WAIT-STATE("GENERAL").

/*  */
FOR EACH tt-w-report WHERE tt-w-report.campo-c[1] = "" :
    FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia 
        AND  FacCorre.CodDiv = pCodDiv
        AND  FacCorre.CodDoc = s-coddoc 
        AND  FacCorre.NroSer = s-NroSer
        EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAILABLE FacCorre THEN DO:
        tt-w-report.campo-c[20] = "X".
        tt-w-report.campo-c[9] = "TABLA faccorre no se pudo bloquear".
        NEXT.
    END.        
        
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1        
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        tt-w-report.campo-c[20] = "X".
        tt-w-report.campo-c[9] = "No se pudo actualizar el FACCORRE".
        NEXT.       
        /*UNDO, RETURN 'ADM-ERROR'.*/
    END.

    FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= TODAY NO-LOCK NO-ERROR.

    CREATE Ccbcdocu.
        ASSIGN Ccbcdocu.NroDoc = STRING(faccorre.nroser, "999") + STRING(faccorre.correlativo, "999999").
    ASSIGN
        Ccbcdocu.fchdoc = TODAY
        ccbcdocu.fmapgo = tt-w-report.campo-c[2]
        ccbcdocu.fchate = tt-w-report.campo-d[1]
        ccbcdocu.flgate = tt-w-report.campo-c[3]
        ccbcdocu.codmon = tt-w-report.campo-i[1]
        ccbcdocu.nroref = tt-w-report.campo-c[4]
        ccbcdocu.tpofac = tt-w-report.campo-c[8]
        ccbcdocu.codcta = tt-w-report.campo-c[5]
        ccbcdocu.glosa = tt-w-report.campo-c[11]
        ccbcdocu.codage = "Provincia"
        ccbcdocu.imptot = tt-w-report.campo-f[1]
        ccbcdocu.codcli = tt-w-report.campo-c[6]
        Ccbcdocu.Nomcli = tt-w-report.campo-c[7]
        ccbcdocu.coddiv = pCodDiv
        Ccbcdocu.tpocmb = gn-tcmb.compra
        Ccbcdocu.FlgEst = "E"       /* OJO -> Emitido */
        Ccbcdocu.FlgSit = "Pendiente"
        Ccbcdocu.FchUbi = ?
        Ccbcdocu.FlgUbi = ""
        CcbCDocu.HorCie = STRING(TIME, 'HH:MM')
        Ccbcdocu.CodCia = s-codcia
        Ccbcdocu.CodDoc = s-coddoc
        Ccbcdocu.usuario= s-user-id
        Ccbcdocu.SdoAct = Ccbcdocu.ImpTot.

    /**/
    ASSIGN tt-w-report.campo-c[20] = "".

    RELEASE faccorre.

END.

{&OPEN-QUERY-BROWSE-5}

SESSION:SET-WAIT-STATE("").


END PROCEDURE.
/*
        ASSIGN  = cCondVta
                 = cBanco
                 = cnrodeposito
                 = codcuenta
                 = ccodclie
                 = cEfeChq
                 = dFDeposito
                 = imptetotal
                 = gn-clie.nomcli.
            ASSIGN tt-w-report.campo-c[10] = IF (cb-ctas.codmon = 1) THEN "S/" ELSE "US$.".
            ASSIGN  = cb-ctas.nomcta.
                

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
  ENABLE BROWSE-3 btnFromExcel BROWSE-5 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesar-excel W-Win 
PROCEDURE procesar-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

DEFINE VAR cValor AS CHAR.
DEFINE VAR lLinea AS INT.
DEFINE VAR dValor AS DEC.

DEFINE VAR cCondVta AS CHAR.
DEFINE VAR dFchaDeposito AS CHAR.
DEFINE VAR cBanco AS CHAR.
DEFINE VAR cnrodeposito AS CHAR.
DEFINE VAR codcuenta AS CHAR.
DEFINE VAR imptetotal AS DEC.
DEFINE VAR ccodclie AS CHAR.
DEFINE VAR cEfeChq AS CHAR.

DEFINE VAR dFDeposito AS DATE.

DEFINE VAR x-existe AS LOG.
EMPTY TEMP-TABLE tt-w-report.

DEFINE BUFFER b-w-report FOR w-report.

lFileXls = x-archivo.		/* Nombre el archivo a abrir o crear, vacio solo para nuevos */
lNuevoFile = NO.	                    /* Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

lMensajeAlTerminar = YES. /*  */
lCerrarAlTerminar = YES.	/* Si permanece abierto el Excel luego de concluir el proceso */

iColumn = 1.
lLinea = 1.

SESSION:SET-WAIT-STATE("GENERAL").

cColumn = STRING(lLinea).
REPEAT iColumn = 2 TO 65000 :
    cColumn = STRING(iColumn).

    cRange = "A" + cColumn.
    cValor = chWorkSheet:Range(cRange):TEXT.

    IF cValor = "" OR cValor = ? THEN LEAVE.    /* FIN DE DATOS */

    cCondVta = cValor.

    cRange = "B" + cColumn.
    dFchaDeposito = TRIM(chWorkSheet:Range(cRange):TEXT).
    cRange = "C" + cColumn.
    cBanco = TRIM(chWorkSheet:Range(cRange):TEXT).
    cRange = "D" + cColumn.
    cnrodeposito = TRIM(chWorkSheet:Range(cRange):TEXT).
    cRange = "E" + cColumn.
    codcuenta = TRIM(chWorkSheet:Range(cRange):TEXT).
    cRange = "F" + cColumn.
    imptetotal = ROUND(chWorkSheet:Range(cRange):VALUE,2).
    cRange = "G" + cColumn.
    ccodclie = TRIM(chWorkSheet:Range(cRange):TEXT).

    /* Nro de Boletas de Deposito en Blanco no VAN */
    IF cnrodeposito = "" OR cnrodeposito = ? THEN NEXT.

    dFDeposito = DATE(INTEGER(SUBSTRING(dFchaDeposito,4,2)),INTEGER(SUBSTRING(dFchaDeposito,1,2)),INTEGER(SUBSTRING(dFchaDeposito,7))).

    CREATE tt-w-report.
        ASSIGN tt-w-report.campo-c[2] = cCondVta
                tt-w-report.campo-c[3] = cBanco
                tt-w-report.campo-c[4] = cnrodeposito
                tt-w-report.campo-c[5] = codcuenta
                tt-w-report.campo-c[6] = ccodclie
                tt-w-report.campo-c[7] = ""
                tt-w-report.campo-c[8] = cEfeChq
                tt-w-report.campo-d[1] = dFDeposito
                tt-w-report.campo-f[1] = imptetotal
                tt-w-report.campo-c[1] = ""
                tt-w-report.campo-c[9] = ""
                tt-w-report.campo-c[10] = ""
                tt-w-report.campo-c[11] = ""
                tt-w-report.campo-c[20] = "X" .            

        /* Condicion de venta */
        FIND FIRST gn-convt WHERE gn-convt.codig = cCondVta NO-LOCK NO-ERROR.
        tt-w-report.campo-c[1] = IF(NOT AVAILABLE gn-convt) THEN "ERR" ELSE tt-w-report.campo-c[1].
        tt-w-report.campo-c[9] = IF(NOT AVAILABLE gn-convt) THEN "Cond.Vta no existe" ELSE "".

        /* Cliente */
        FIND FIRST gn-clie WHERE gn-clie.codcia = 0 AND
                                gn-clie.codcli = cCodClie NO-LOCK NO-ERROR.
        IF NOT AVAILABLE gn-clie THEN DO:
            tt-w-report.campo-c[1] = "ERR".
            tt-w-report.campo-c[9] = tt-w-report.campo-c[9] + "/Cliente no existe".
        END.
        ELSE tt-w-report.campo-c[7] = gn-clie.nomcli.

        /* Banco */
        FIND FIRST cb-ctas WHERE cb-ctas.codcia = 0 AND 
                                    cb-ctas.codcta = codcuenta NO-LOCK NO-ERROR.
        IF NOT AVAILABLE cb-ctas THEN DO:
            tt-w-report.campo-c[1] = "ERR".
            tt-w-report.campo-c[9] = tt-w-report.campo-c[9] + "/CodCuenta no existe".
        END.
        ELSE DO:
            ASSIGN tt-w-report.campo-c[10] = IF (cb-ctas.codmon = 1) THEN "S/" ELSE "US$.".
            ASSIGN tt-w-report.campo-c[11] = cb-ctas.nomcta.
            ASSIGN tt-w-report.campo-i[1] = cb-ctas.codmon.
            IF cb-ctas.codbco <> cbanco THEN DO:
                tt-w-report.campo-c[1] = "ERR".
                tt-w-report.campo-c[9] = tt-w-report.campo-c[9] + "/Cuenta es de otro BANCO".
            END.
        END.
        IF imptetotal <= 0 THEN DO:
            tt-w-report.campo-c[1] = "ERR".
            tt-w-report.campo-c[9] = tt-w-report.campo-c[9] + "/Impte Errado".
        END.

        /* Validar que no existan depositos repetidos en CCBCDOCU */
        x-existe = NO.
        FOR EACH ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                                    ccbcdocu.codref = "" AND
                                    ccbcdocu.nroref = cnrodeposito AND 
                                    ccbcdocu.coddoc = 'BD' NO-LOCK:
            /*
            MESSAGE ccbcdocu.codcli  ccodclie SKIP 
                        ccbcdocu.imptot imptetotal
                        ccbcdocu.fchate dFDeposito.
            */
            IF ccbcdocu.codcli = ccodclie AND ccbcdocu.imptot = imptetotal AND ccbcdocu.fchate = dFDeposito THEN DO:
                x-existe = YES.
            END.
        END.
        IF x-existe = YES THEN DO:
            tt-w-report.campo-c[1] = "ERR".
            tt-w-report.campo-c[9] = tt-w-report.campo-c[9] + "/Deposito ya esta registrado".
        END.
        ELSE DO:
                /* Que NO existam depositos repetidos en el EXCEL */
              FOR EACH b-w-report WHERE b-w-report.campo-c[4] = cnrodeposito NO-LOCK:
                  IF b-w-report.campo-c[6] = ccodclie AND 
                      b-w-report.campo-f[1] = imptetotal AND 
                      b-w-report.campo-d[1] = dFDeposito THEN DO:
                      x-existe = YES.
                  END.
              END.
              IF x-existe = YES THEN DO:
                  tt-w-report.campo-c[1] = "ERR".
                  tt-w-report.campo-c[9] = tt-w-report.campo-c[9] + "/Deposito esta duplicado en el EXCEL".
              END.
        END.

        /* CHQ/EFE */
        IF NOT (cEfeChq = 'CHQ' OR cEfeChq = 'EFE') THEN DO:
            tt-w-report.campo-c[1] = "ERR".
            tt-w-report.campo-c[9] = tt-w-report.campo-c[9] + "/Validos CHQ/EFE".
        END.

END.


{&OPEN-QUERY-BROWSE-5}

{lib\excel-close-file.i}

SESSION:SET-WAIT-STATE("").


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
  {src/adm/template/snd-list.i "GN-DIVI"}
  {src/adm/template/snd-list.i "tt-w-report"}

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

