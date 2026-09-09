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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR x-NroDoc AS CHAR NO-UNDO.
DEF VAR x-NroRef AS CHAR NO-UNDO.
DEF VAR X-CTOUND AS DEC NO-UNDO.
DEF VAR F-PreVta-A AS DEC NO-UNDO.
DEF VAR F-MrgUti-A AS DEC NO-UNDO.
DEF VAR F-PreVta-B AS DEC NO-UNDO.
DEF VAR F-MrgUti-B AS DEC NO-UNDO.
DEF VAR F-PreVta-C AS DEC NO-UNDO.
DEF VAR F-MrgUti-C AS DEC NO-UNDO.
DEF VAR fMot LIKE Almmmatg.PreOfi.
DEF VAR MrgOfi LIKE Almmmatg.MrgUti-A.
DEF VAR f-Factor AS DEC NO-UNDO.

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
&Scoped-define INTERNAL-TABLES OOCostos

/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 OOCostos.codmat OOCostos.DesMat ~
OOCostos.CtoLis OOCostos.CtoTot OOCostos.CtoLisMarco OOCostos.CtoTotMarco 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH OOCostos ~
      WHERE OOCostos.CodCia = s-codcia ~
      AND OOCostos.NroLista = FILL-IN-OC:SCREEN-VALUE IN FRAME {&FRAME-NAME} ~
      AND OOCostos.FlagMigracion = "N" NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH OOCostos ~
      WHERE OOCostos.CodCia = s-codcia ~
      AND OOCostos.NroLista = FILL-IN-OC:SCREEN-VALUE IN FRAME {&FRAME-NAME} ~
      AND OOCostos.FlagMigracion = "N" NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 OOCostos
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 OOCostos


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnDone FILL-IN-OC BUTTON-1 BROWSE-3 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-OC FILL-IN_FlagFecha ~
FILL-IN_FlagHora 

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
     SIZE 6 BY 1.35
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     LABEL "IMPORTAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FILL-IN-OC AS CHARACTER FORMAT "X(20)":U 
     LABEL "Orden de Compra" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_FlagFecha AS DATE FORMAT "99/99/9999" 
     LABEL "Fecha" 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_FlagHora AS CHARACTER FORMAT "x(10)" 
     LABEL "Hora" 
     VIEW-AS FILL-IN 
     SIZE 14.43 BY .81.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-3 FOR 
      OOCostos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 W-Win _STRUCTURED
  QUERY BROWSE-3 NO-LOCK DISPLAY
      OOCostos.codmat COLUMN-LABEL "Codigo" FORMAT "X(6)":U WIDTH 6.43
      OOCostos.DesMat FORMAT "X(45)":U WIDTH 50.43
      OOCostos.CtoLis COLUMN-LABEL "Precio Costo Lista!S/IGV" FORMAT "->>>,>>9.9999":U
            WIDTH 14.29
      OOCostos.CtoTot COLUMN-LABEL "Precio Costo Lista!C/IGV" FORMAT "->>>,>>9.9999":U
            WIDTH 14.43
      OOCostos.CtoLisMarco COLUMN-LABEL "Precio Costo Lista Marco!S/IGV" FORMAT "->>>,>>9.9999":U
            WIDTH 18.43
      OOCostos.CtoTotMarco COLUMN-LABEL "Precio Costo Lista Marco!C/IGV" FORMAT "->>>,>>9.9999":U
            WIDTH 19.86
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 130 BY 11.73
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BtnDone AT ROW 1.19 COL 127 WIDGET-ID 10
     FILL-IN-OC AT ROW 1.38 COL 24 COLON-ALIGNED WIDGET-ID 2
     BUTTON-1 AT ROW 1.38 COL 48 WIDGET-ID 8
     FILL-IN_FlagFecha AT ROW 2.35 COL 24 COLON-ALIGNED WIDGET-ID 4
     FILL-IN_FlagHora AT ROW 3.31 COL 24 COLON-ALIGNED WIDGET-ID 6
     BROWSE-3 AT ROW 4.27 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 133.29 BY 15.46
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "MIGRACION DE COSTOS DE OPEN ORANGE A PROGRESS"
         HEIGHT             = 15.46
         WIDTH              = 133.29
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 137.57
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 137.57
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
/* BROWSE-TAB BROWSE-3 FILL-IN_FlagHora F-Main */
/* SETTINGS FOR FILL-IN FILL-IN_FlagFecha IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_FlagHora IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "INTEGRAL.OOCostos"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "OOCostos.CodCia = s-codcia
      AND OOCostos.NroLista = FILL-IN-OC:SCREEN-VALUE IN FRAME {&FRAME-NAME}
      AND OOCostos.FlagMigracion = ""N"""
     _FldNameList[1]   > INTEGRAL.OOCostos.codmat
"OOCostos.codmat" "Codigo" ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.OOCostos.DesMat
"OOCostos.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "50.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.OOCostos.CtoLis
"OOCostos.CtoLis" "Precio Costo Lista!S/IGV" ? "decimal" ? ? ? ? ? ? no ? no no "14.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.OOCostos.CtoTot
"OOCostos.CtoTot" "Precio Costo Lista!C/IGV" ? "decimal" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.OOCostos.CtoLisMarco
"OOCostos.CtoLisMarco" "Precio Costo Lista Marco!S/IGV" ? "decimal" ? ? ? ? ? ? no ? no no "18.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.OOCostos.CtoTotMarco
"OOCostos.CtoTotMarco" "Precio Costo Lista Marco!C/IGV" ? "decimal" ? ? ? ? ? ? no ? no no "19.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* MIGRACION DE COSTOS DE OPEN ORANGE A PROGRESS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* MIGRACION DE COSTOS DE OPEN ORANGE A PROGRESS */
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


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 W-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* IMPORTAR */
DO:
  ASSIGN
      FILL-IN-OC.
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Importar NO-ERROR.
  SESSION:SET-WAIT-STATE('').
  IF AVAILABLE(Almmmatg) THEN RELEASE Almmmatg.
  IF AVAILABLE(Almmmatp) THEN RELEASE Almmmatp.
  IF AVAILABLE(VtaListaMay) THEN RELEASE VtaListaMay.
  IF AVAILABLE(VtaListaMinGN) THEN RELEASE VtaListaMinGn.
  IF ERROR-STATUS:ERROR THEN DO:
      MESSAGE 'ERROR en la importación' SKIP 'Proceso abortado'
          VIEW-AS ALERT-BOX WARNING.
      RETURN NO-APPLY.
  END.
  MESSAGE 'Importación exitosa' VIEW-AS ALERT-BOX INFORMATION.
  FILL-IN-OC = ''.
  DISPLAY FILL-IN-OC WITH FRAME {&FRAME-NAME}.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-OC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-OC W-Win
ON LEAVE OF FILL-IN-OC IN FRAME F-Main /* Orden de Compra */
OR ENTER OF FILL-IN-OC
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND FIRST OOCostos WHERE OOCostos.CodCia = s-codcia
      AND OOCostos.NroLista = INPUT {&SELF-NAME}
      AND OOCostos.FlagMigracion = "N"
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE OOCostos THEN DO:
      MESSAGE 'Orden de Compra no válida' VIEW-AS ALERT-BOX ERROR.
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  DISPLAY
      OOCostos.FlagFecha @  FILL-IN_FlagFecha
      OOCostos.FlagHora  @ FILL-IN_FlagHora
      WITH FRAME {&FRAME-NAME}.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-3
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Margen-Utilidad W-Win 
PROCEDURE Calcula-Margen-Utilidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* RHC 08/09/2015 SOLO PARA LINEAS COMERCIALES */
FIND FIRST Almtfami OF Almmmatg NO-LOCK NO-ERROR.
IF NOT (AVAILABLE Almtfami AND Almtfami.SwComercial = YES) THEN RETURN.
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    ASSIGN
        F-MrgUti-A = 0
        F-MrgUti-B = 0
        F-MrgUti-C = 0
        MrgOfi = 0.
    /****   MARGEN A   ****/
    ASSIGN
        F-PreVta-A = Almmmatg.Prevta[2]
        X-CTOUND = Almmmatg.CtoTot
        F-FACTOR = 1
        F-MrgUti-A = 0.    
    IF Almmmatg.UndA <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
            AND  Almtconv.Codalter = Almmmatg.UndA
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE 'ERROR unidad A' Almmmatg.codmat Almmmatg.UndA VIEW-AS ALERT-BOX WARNING.
            UNDO, RETURN ERROR.
        END.
        F-FACTOR = Almtconv.Equival.
        F-MrgUti-A = ROUND(((((F-PreVta-A / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
    END.
    ASSIGN
        F-PreVta-B = Almmmatg.Prevta[3]
        X-CTOUND = Almmmatg.CtoTot
        F-FACTOR = 1
        F-MrgUti-B = 0.   
    /****   MARGEN B   ****/
    IF Almmmatg.UndB <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
            AND  Almtconv.Codalter = Almmmatg.UndB
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE 'ERROR unidad B' Almmmatg.codmat Almmmatg.UndB VIEW-AS ALERT-BOX WARNING.
            UNDO, RETURN ERROR.
        END.
        F-FACTOR = Almtconv.Equival.
        F-MrgUti-B = ROUND(((((F-PreVta-B / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
    END.
    /****   MARGEN C   ****/
    ASSIGN
        F-PreVta-C = Almmmatg.Prevta[4]
        X-CTOUND = Almmmatg.CtoTot
        F-FACTOR = 1
        F-MrgUti-C = 0.
    IF Almmmatg.UndC <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
            AND  Almtconv.Codalter = Almmmatg.UndC
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE 'ERROR unidad C' Almmmatg.codmat Almmmatg.UndC VIEW-AS ALERT-BOX WARNING.
            UNDO, RETURN ERROR.
        END.
        F-FACTOR = Almtconv.Equival.
        F-MrgUti-C = ROUND(((((F-PreVta-C / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
    END.
    /**** MARGEN PRECIO DE OFICINA ****/
    ASSIGN
        fMot   = 0
        MrgOfi = 0
        F-FACTOR = 1
        X-CTOUND = Almmmatg.CtoTot.
    CASE Almmmatg.Chr__02 :
        WHEN "T" THEN DO:        
            IF Almmmatg.Chr__01 <> "" THEN DO:
                FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
                    AND  Almtconv.Codalter = Almmmatg.Chr__01
                    NO-LOCK NO-ERROR.
                IF NOT AVAILABLE Almtconv THEN DO:
                    MESSAGE 'ERROR unidad Oficina' Almmmatg.codmat Almmmatg.CHR__01 VIEW-AS ALERT-BOX WARNING.
                    UNDO, RETURN ERROR.
                END.
                F-FACTOR = Almtconv.Equival.
                fMot = Almmmatg.PreOfi / X-CTOUND / F-FACTOR.
                MrgOfi = ROUND((fMot - 1) * 100, 6).
            END.
        END.
        WHEN "P" THEN DO:
            MrgOfi = ((Almmmatg.Prevta[1] / Almmmatg.Ctotot) - 1 ) * 100. 
        END. 
    END.    
    ASSIGN
        Almmmatg.MrgUti-A  = F-MrgUti-A
        Almmmatg.MrgUti-B  = F-MrgUti-B
        Almmmatg.MrgUti-C  = F-MrgUti-C
        Almmmatg.MrgUti = ((Almmmatg.Prevta[1] / Almmmatg.Ctotot) - 1 ) * 100. 

    /* MARGEN LISTA UTILEX */
    FIND VtaListaMinGn OF Almmmatg EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR = YES AND LOCKED(VtaListaMinGn) THEN DO:
        MESSAGE 'ERROR lista utilex, bloqueado por otro usuario' VIEW-AS ALERT-BOX WARNING.
        UNDO, RETURN ERROR.
    END.
    IF AVAILABLE VtaListaMinGn THEN DO:
        ASSIGN
            X-CTOUND = Almmmatg.CtoTot
            F-FACTOR = 1.
        /****   Busca el Factor de conversion   ****/
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
            AND  Almtconv.Codalter = Almmmatg.CHR__01
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE 'ERROR unidad Utilex' Almmmatg.codmat Almmmatg.CHR__01 VIEW-AS ALERT-BOX WARNING.
            UNDO, RETURN ERROR.
        END.
        F-FACTOR = Almtconv.Equival.
        VtaListaMinGn.Dec__01 = ROUND(((((VtaListaMinGn.PreOfi / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
    END.

    /* MARGEN LISTA MAYORISTA POR DIVISION */
    FOR EACH VtaListaMay WHERE VtaListaMay.codcia = Almmmatg.codcia
        AND VtaListaMay.codmat = Almmmatg.codmat:
        ASSIGN
            X-CTOUND = Almmmatg.CtoTot
            F-FACTOR = 1.
        /****   Busca el Factor de conversion   ****/
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
            AND Almtconv.Codalter = VtaListaMay.CHR__01
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE 'ERROR unidad x División' Almmmatg.codmat VtaListaMay.CHR__01 VIEW-AS ALERT-BOX WARNING.
            UNDO, RETURN ERROR.
        END.
        F-FACTOR = Almtconv.Equival.
        ASSIGN
            VtaListaMay.DEC__01 = ROUND(((((VtaListaMay.PreOfi / F-FACTOR) / X-CTOUND) - 1) * 100), 6).
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
  DISPLAY FILL-IN-OC FILL-IN_FlagFecha FILL-IN_FlagHora 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BtnDone FILL-IN-OC BUTTON-1 BROWSE-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar W-Win 
PROCEDURE Importar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*PUT UNFORMATTED 'INICIO ' STRING(TIME, 'HH:MM:SS') SKIP.*/
PRINCIPAL:
FOR EACH OOCostos WHERE OOCostos.CodCia = s-codcia AND OOCostos.FlagMigracion = 'N'
    AND OOCostos.NroLista  = FILL-IN-OC
    TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    {lib/lock-genericov2.i 
        &Tabla="Almmmatg" 
        &Condicion="Almmmatg.codcia = OOCostos.CodCia AND Almmmatg.codmat = OOCostos.codmat"
        &Bloqueo="EXCLUSIVE-LOCK"
        &Accion="RETRY"
        &Mensaje="YES"
        &TipoError="RETURN ERROR"
        }
    CASE OOCostos.TipoCosto:
        WHEN 1 THEN DO:     /* NORMAL */
            IF (OOCostos.CtoLis + OOCostos.CtoTot) <= 0 THEN NEXT PRINCIPAL.
            RUN Recalcular NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO PRINCIPAL, RETURN ERROR.
        END.
        WHEN 2 THEN DO:     /* CONTRATO MARCO */
            IF (OOCostos.CtoLisMarco + OOCostos.CtoTotMarco) <= 0 THEN NEXT PRINCIPAL.
            RUN Recalcular-Marco NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO PRINCIPAL, RETURN ERROR.
        END.
    END CASE.
    /* LOG DE CONTROL */
    CREATE Logmmatg.
    BUFFER-COPY Almmmatg TO Logmmatg
        ASSIGN
            Logmmatg.LogDate = TODAY
            Logmmatg.LogTime = STRING(TIME, 'HH:MM:SS')
            Logmmatg.LogUser = s-user-id
            Logmmatg.FlagFechaHora = DATETIME(TODAY, MTIME)
            Logmmatg.FlagUsuario = s-user-id
            Logmmatg.flagestado = "C".

    ASSIGN
        OOCostos.FlagMigracion = "S"
        OOCostos.MigFecha = TODAY
        OOCostos.MigHora = STRING(TIME, 'HH:MM:SS')
        OOCostos.MigUsuario = s-user-id.
END.
/*PUT UNFORMATTED 'PROCESO TERMINADO ' STRING(TIME, 'HH:MM:SS') SKIP.*/

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Oficina W-Win 
PROCEDURE Precio-Oficina :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR MaxCat AS DEC NO-UNDO.
DEF VAR MaxVta AS DEC NO-UNDO.
DEF VAR MrgMin AS DEC NO-UNDO.
DEF VAR Pre-Ofi AS DEC NO-UNDO.

MaxCat = 0.
MaxVta = 0.
fmot   = 0.
MrgMin = 5000.
MrgOfi = 0.
F-FACTOR = 1.
MaxCat = 4.
MaxVta = 3.

ASSIGN X-CTOUND = Almmmatg.CtoTot.

/****   Busca el Factor de conversion   ****/
IF Almmmatg.Chr__01 = "" THEN RETURN.
FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
    AND  Almtconv.Codalter = Almmmatg.Chr__01
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN RETURN ERROR.
F-FACTOR = Almtconv.Equival.
/*******************************************/
CASE Almmmatg.Chr__02 :
    WHEN "T" THEN DO:        
        /*  TERCEROS  */
        IF F-MrgUti-A < MrgMin AND F-MrgUti-A <> 0 THEN MrgMin = F-MrgUti-A.
        IF F-MrgUti-B < MrgMin AND F-MrgUti-B <> 0 THEN MrgMin = F-MrgUti-B.
        IF F-MrgUti-C < MrgMin AND F-MrgUti-C <> 0 THEN MrgMin = F-MrgUti-C.
        fmot = (1 + MrgMin / 100) / ((1 - MaxCat / 100) * (1 - MaxVta / 100)).
        pre-ofi = X-CTOUND * fmot * F-FACTOR .        
        MrgOfi = ROUND((fmot - 1) * 100, 6).
    END.
    WHEN "P" THEN DO:
        /* PROPIOS */
       pre-ofi = Almmmatg.Prevta[1] * F-FACTOR.
       MrgOfi = ((Almmmatg.Prevta[1] / Almmmatg.Ctotot) - 1 ) * 100. 
    END. 
END.    
ASSIGN
    Almmmatg.DEC__01 = MrgOfi
    Almmmatg.PreOfi = pre-ofi.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precios-Mayorista-General W-Win 
PROCEDURE Precios-Mayorista-General :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN
        F-FACTOR = 1
        F-PreVta-A = 0
        F-PreVta-B = 0
        F-PreVta-C = 0
        X-CTOUND = Almmmatg.CtoTot.
    /****   Busca el Factor de conversion   ****/
    IF Almmmatg.UndA <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
            AND  Almtconv.Codalter = Almmmatg.UndA
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN DO:
            F-FACTOR = Almtconv.Equival.
            F-PreVta-A = ROUND(( X-CTOUND * (1 + F-MrgUti-A / 100) ), 6) * F-FACTOR.
        END.
    END.
    IF Almmmatg.UndB <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
            AND  Almtconv.Codalter = Almmmatg.UndB
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN DO:
            F-FACTOR = Almtconv.Equival.
            F-PreVta-B = ROUND(( X-CTOUND * (1 + F-MrgUti-B / 100) ), 6) * F-FACTOR.
        END.
    END.
    IF Almmmatg.UndC <> "" THEN DO:
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas
            AND  Almtconv.Codalter = Almmmatg.UndC
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN DO:
            F-FACTOR = Almtconv.Equival.
            F-PreVta-C = ROUND(( X-CTOUND * (1 + F-MrgUti-C / 100) ), 6) * F-FACTOR.
        END.
    END.
    ASSIGN
        Almmmatg.PreVta[1] = ROUND(( X-CTOUND * (1 + Almmmatg.MrgUti / 100) ), 6)
        Almmmatg.PreVta[2] = F-PreVta-A
        Almmmatg.PreVta[3] = F-PreVta-B
        Almmmatg.PreVta[4] = F-PreVta-C
        Almmmatg.INFOR[1]  = OOCostos.NroLista.
    RUN Precio-Oficina NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN ERROR.
    /* Descuentos Promocionales */
    DEF BUFFER BTABLA FOR VtaTabla.
    DEF VAR F-PRECIO AS DEC NO-UNDO.

    F-PRECIO = Almmmatg.Prevta[1].
    IF Almmmatg.MonVta = 2 THEN F-PRECIO = Almmmatg.Prevta[1] * Almmmatg.TpoCmb.
    FOR EACH VtaTabla WHERE VtaTabla.CodCia = Almmmatg.CodCia
        AND VtaTabla.Llave_c1 = Almmmatg.codmat
        AND VtaTabla.Tabla = "DTOPROLIMA":
        f-Factor = 1.   /* x defecto */
        /* RHC 07/05/2020 Ya no es válido */
/*         FIND BTABLA WHERE BTABLA.codcia = s-codcia                                                 */
/*             AND BTABLA.llave_c1 = gn-divi.coddiv                                                   */
/*             AND BTABLA.tabla = "DIVFACXLIN"                                                        */
/*             AND BTABLA.llave_c2 = Almmmatg.codfam                                                  */
/*             NO-LOCK NO-ERROR.                                                                      */
/*         IF AVAILABLE BTABLA AND BTABLA.valor[1] > 0 THEN F-FACTOR = ( 1 + BTABLA.valor[1] / 100 ). */
        ASSIGN
            VtaTabla.Valor[2] = ROUND( (F-PRECIO * F-FACTOR) * ( 1 - ( VtaTabla.Valor[1] / 100 ) ),4).
    END.
    /**/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precios-Utilex W-Win 
PROCEDURE Precios-Utilex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-CtoTot AS DEC NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.

IF NOT AVAILABLE VtaListaMinGn THEN RETURN.

FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = VtaListaMinGn.Chr__01
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN RETURN ERROR.
F-FACTOR = Almtconv.Equival.
ASSIGN
    VtaListaMinGn.PreOfi = ROUND(( Almmmatg.ctotot * f-Factor ) * (1 + VtaListaMinGn.Dec__01 / 100), 6)
    Almmmatg.MrgAlt[1] = VtaListaMinGn.Dec__01.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular W-Win 
PROCEDURE Recalcular :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       SE mantiene el margen de utilidad => Los precios se ajustan
------------------------------------------------------------------------------*/

    DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
        /* **************************************************************************** */
        /*************************** MARGEN PRECIO DE LISTA *****************************/
        /* **************************************************************************** */
        RUN Calcula-Margen-Utilidad NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
        /* **************************************************************************** */
        /******************  RECALCULAMOS PRECIOS DE VENTA  *****************************/
        /* **************************************************************************** */
        /* Ahora sí actualizamos los costos de reposición */
        ASSIGN
            Almmmatg.CtoLis = OOCostos.CtoLis 
            Almmmatg.CtoTot = OOCostos.CtoTot
            X-CTOUND        = OOCostos.CtoTot.
        /* LISTA DE PRECIO MAYORISTA GENERAL (LIMA) */
        RUN Precios-Mayorista-General NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
        /* LISTA DE PRECIOS UTILEX */
        RUN Precios-Utilex.
        IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Marco W-Win 
PROCEDURE Recalcular-Marco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-CtoTot AS DEC NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.

FIND Almmmatp OF Almmmatg NO-ERROR NO-WAIT.
IF NOT AVAILABLE Almmmatp THEN RETURN.
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    /* El Contrato Marco SIEMPRE está en SOLES (Almmmatg.DEC__02 = 1) */
    ASSIGN
        Almmmatg.CtoLisMarco = OOCostos.CtoLisMarco 
        Almmmatg.CtoTotMarco = OOCostos.CtoTotMarco.
    {lib/lock-genericov2.i 
            &Tabla="Almmmatp" 
            &Condicion="Almmmatp.codcia = Almmmatg.CodCia AND Almmmatp.codmat = Almmmatg.codmat"
            &Bloqueo="EXCLUSIVE-LOCK"
            &Accion="RETRY"
            &Mensaje="YES"
            &TipoError="RETURN ERROR"
            }
    ASSIGN
        Almmmatp.CtoTot = OOCostos.CtoTotMarco.
    IF Almmmatg.monvta = Almmmatp.monvta THEN x-CtoTot = Almmmatp.CtoTot.
    ELSE IF Almmmatp.monvta = 1 THEN x-CtoTot = Almmmatp.ctotot *  Almmmatg.tpocmb.
    ELSE x-CtoTot = Almmmatp.ctotot /  Almmmatg.tpocmb.

    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = Almmmatp.Chr__01
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE 'ERROR unidad Marco' Almmmatg.codmat Almmmatp.CHR__01 VIEW-AS ALERT-BOX WARNING.
        UNDO, RETURN ERROR.
    END.
    F-FACTOR = Almtconv.Equival.
    ASSIGN
        Almmmatp.Dec__01 = ( (Almmmatp.PreOfi / (x-Ctotot * f-Factor) ) - 1 ) * 100
        Almmmatp.INFOR[1]  = OOCostos.NroLista.
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
  {src/adm/template/snd-list.i "OOCostos"}

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

