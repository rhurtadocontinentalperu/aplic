&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR VtaCDocu.
DEFINE TEMP-TABLE CDOCU LIKE VtaCDocu.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR lListaOrdenes AS CHAR NO-UNDO.
DEF VAR lCodDoc AS CHAR NO-UNDO.
DEF VAR lFlgSit LIKE Vtacdocu.flgsit NO-UNDO.
DEF VAR lZonaPickeo LIKE Vtacdocu.zonapickeo NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES CDOCU

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 CDOCU.CodPed CDOCU.NroPed ~
CDOCU.CodCli CDOCU.NomCli CDOCU.FlgSit CDOCU.ZonaPickeo 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 CDOCU.FlgSit ~
CDOCU.ZonaPickeo 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-5 CDOCU
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-5 CDOCU
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH CDOCU NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH CDOCU NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 CDOCU
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 CDOCU


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-CodDoc BtnDone BUTTON-1 BUTTON-9 ~
FILL-IN-NroPed BROWSE-5 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-CodDoc FILL-IN-NroPed 

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
     SIZE 8 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "IMG/ok.ico":U
     LABEL "Button 1" 
     SIZE 15 BY 1.62 TOOLTIP "Cierre de Tarea".

DEFINE BUTTON BUTTON-9 
     IMAGE-UP FILE "img/error.ico":U
     LABEL "Button 9" 
     SIZE 15 BY 1.62 TOOLTIP "Inicializa Variables".

DEFINE VARIABLE FILL-IN-NroPed AS CHARACTER FORMAT "X(256)":U 
     LABEL "# de Sub-Orden" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE RADIO-SET-CodDoc AS CHARACTER INITIAL "ODC" 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "SUB-ORDEN DE DESPACHO CONSOLIDADA", "ODC",
"SUB-ORDEN DE TRANSFERENCIA CONSOLIDADA", "OTC"
     SIZE 40 BY 1.88
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      CDOCU SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      CDOCU.CodPed FORMAT "x(3)":U
      CDOCU.NroPed COLUMN-LABEL "Número" FORMAT "X(12)":U WIDTH 12.57
      CDOCU.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U WIDTH 11.43
      CDOCU.NomCli FORMAT "x(60)":U
      CDOCU.FlgSit FORMAT "x":U WIDTH 12.57 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
            VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEM-PAIRS "TODO OK","C",
                                      "OBSERVADA","X"
                      DROP-DOWN-LIST 
      CDOCU.ZonaPickeo FORMAT "x(10)":U WIDTH 13.72 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
            VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "x" 
                      DROP-DOWN-LIST 
  ENABLE
      CDOCU.FlgSit
      CDOCU.ZonaPickeo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 104 BY 12.92
         FONT 4 ROW-HEIGHT-CHARS .42 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RADIO-SET-CodDoc AT ROW 1.27 COL 3 NO-LABEL WIDGET-ID 14
     BtnDone AT ROW 1.27 COL 98 WIDGET-ID 18
     BUTTON-1 AT ROW 2.62 COL 45 WIDGET-ID 16
     BUTTON-9 AT ROW 2.62 COL 60 WIDGET-ID 20
     FILL-IN-NroPed AT ROW 3.42 COL 20 COLON-ALIGNED WIDGET-ID 12
     BROWSE-5 AT ROW 4.5 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 107.57 BY 17.15
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL VtaCDocu
      TABLE: CDOCU T "?" ? INTEGRAL VtaCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "DES-CONSOLIDACION DE SUB-ORDENES DE DESPACHO"
         HEIGHT             = 17.15
         WIDTH              = 107.57
         MAX-HEIGHT         = 29.54
         MAX-WIDTH          = 144.29
         VIRTUAL-HEIGHT     = 29.54
         VIRTUAL-WIDTH      = 144.29
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
/* BROWSE-TAB BROWSE-5 FILL-IN-NroPed F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "Temp-Tables.CDOCU"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.CDOCU.CodPed
     _FldNameList[2]   > Temp-Tables.CDOCU.NroPed
"CDOCU.NroPed" "Número" ? "character" ? ? ? ? ? ? no ? no no "12.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.CDOCU.CodCli
"CDOCU.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.CDOCU.NomCli
     _FldNameList[5]   > Temp-Tables.CDOCU.FlgSit
"CDOCU.FlgSit" ? ? "character" 11 0 ? ? ? ? yes ? no no "12.57" yes no no "U" "" "" "DROP-DOWN-LIST" "," ? "TODO OK,C,OBSERVADA,X" 5 no 0 no no
     _FldNameList[6]   > Temp-Tables.CDOCU.ZonaPickeo
"CDOCU.ZonaPickeo" ? ? "character" 11 0 ? ? ? ? yes ? no no "13.72" yes no no "U" "" "" "DROP-DOWN-LIST" "," "x" ? 5 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* DES-CONSOLIDACION DE SUB-ORDENES DE DESPACHO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* DES-CONSOLIDACION DE SUB-ORDENES DE DESPACHO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
&Scoped-define SELF-NAME BROWSE-5
&Scoped-define SELF-NAME CDOCU.ZonaPickeo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CDOCU.ZonaPickeo BROWSE-5 _BROWSE-COLUMN W-Win
ON ENTRY OF CDOCU.ZonaPickeo IN BROWSE BROWSE-5 /* ZonaPickeo */
DO:
    SELF:DELETE(SELF:LIST-ITEMS).
    FOR EACH Almtabla NO-LOCK WHERE almtabla.Tabla = "ZP":
        SELF:ADD-LAST(almtabla.Codigo).
    END.
    IF LOOKUP(CDOCU.ZonaPickeo, SELF:LIST-ITEMS) = 0 THEN SELF:ADD-LAST(CDOCU.ZonaPickeo).
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
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  MESSAGE 'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
      BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN Cierre-de-Tarea.
  RUN Limpia-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-9 W-Win
ON CHOOSE OF BUTTON-9 IN FRAME F-Main /* Button 9 */
DO:
   RUN Limpia-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-NroPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-NroPed W-Win
ON LEAVE OF FILL-IN-NroPed IN FRAME F-Main /* # de Sub-Orden */
OR RETURN OF FILL-IN-NroPed DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    SELF:SCREEN-VALUE = REPLACE(SELF:SCREEN-VALUE,"'","-").
    ASSIGN {&SELF-NAME}.
    IF LENGTH(FILL-IN-NroPed) > 12 THEN DO:
        /* Transformamos el número */
        FIND Facdocum WHERE Facdocum.codcia = s-codcia AND Facdocum.codcta[8] = SUBSTRING(FILL-IN-NroPed,1,3)
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacDocum THEN DO:
            RADIO-SET-CodDoc = Facdocum.coddoc.
            FILL-IN-NroPed = SUBSTRING(FILL-IN-NroPed,4).
            DISPLAY FILL-IN-NroPed RADIO-SET-CodDoc WITH FRAME {&FRAME-NAME}.
        END.
    END.
    ASSIGN RADIO-SET-CodDoc FILL-IN-NroPed.
    /* Buscamos Sub-Orden */
    FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia 
        AND B-CDOCU.divdes = s-CodDiv
        AND B-CDOCU.codped = RADIO-SET-CodDoc
        AND B-CDOCU.nroped = FILL-IN-NroPed
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CDOCU THEN DO:
        MESSAGE 'Sub-Orden CONSOLIDADA NO registrada' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    /*RD01- Verifica si la orden ya ha sido chequeado*/
    IF NOT (B-CDOCU.flgest = 'P' AND B-CDOCU.flgsit = 'C') THEN DO:
        MESSAGE 'La Sub-Orden NO está pendiente de cierre' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    ASSIGN
        lCodDoc = B-CDOCU.CodOri
        lListaOrdenes = B-CDOCU.NroOri
        lFlgSit = B-CDOCU.FlgSit
        lZonaPickeo =  B-CDOCU.ZonaPickeo.
    RUN Carga-Temporal.
    {&OPEN-QUERY-{&BROWSE-NAME}}
/*     RUN vta2\d-cierre-picking-sub-ordenes ( ROWID(B-CDOCU),     */
/*                                             OUTPUT x-UsrChq,     */
/*                                             OUTPUT pZonaPickeo,  */
/*                                             OUTPUT pSituacion,   */
/*                                             OUTPUT pEstado).     */
/*     IF pEstado = "ADM-ERROR" THEN RETURN NO-APPLY.               */
/*                                                                  */
/*     pError = "".                                                 */
/*     RUN Cierre-de-guia.                                          */
/*     ASSIGN                                                       */
/*         COMBO-BOX-2 = 'Hoy'                                      */
/*         FILL-IN-NroPed = ''.                                     */
/*     DISPLAY COMBO-BOX-2 FILL-IN-NroPed WITH FRAME {&FRAME-NAME}. */
/*     APPLY 'VALUE-CHANGED':U TO COMBO-BOX-2.                      */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-CodDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-CodDoc W-Win
ON VALUE-CHANGED OF RADIO-SET-CodDoc IN FRAME F-Main
DO:
  ASSIGN {&SELF-NAME}.
  APPLY 'LEAVE':U TO  FILL-IN-NroPed.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE CDOCU.
DEF VAR k AS INT NO-UNDO.

DO k = 1 TO NUM-ENTRIES(lListaOrdenes):
    FIND FIRST Vtacdocu WHERE  VtaCDocu.CodCia = s-codcia
        AND VtaCDocu.CodPed = lCodDoc
        AND VtaCDocu.NroPed = ENTRY(k,lListaOrdenes)
        NO-LOCK NO-ERROR.
    IF AVAILABLE Vtacdocu THEN DO:
        CREATE CDOCU.
        BUFFER-COPY Vtacdocu TO CDOCU
            ASSIGN
            CDOCU.FlgSit        = B-CDOCU.FlgSit
            CDOCU.ZonaPickeo    = B-CDOCU.ZonaPickeo
            CDOCU.Libre_c03     = B-CDOCU.Libre_c03
            CDOCU.UsrSacRecep   = B-CDOCU.UsrSacRecep
            CDOCU.ZonaPickeo    = B-CDOCU.zonapickeo
            CDOCU.FchFin        = B-CDOCU.fchfin
            CDOCU.UsuarioFin    = B-CDOCU.usuariofin.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-de-Tarea W-Win 
PROCEDURE Cierre-de-Tarea :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR lOrdenLista AS LOG NO-UNDO.

  DEFINE BUFFER b-vtacdocu FOR vtacdocu.

  DEF VAR x-CodRef AS CHAR NO-UNDO.
  DEF VAR x-NroRef AS CHAR NO-UNDO.
  DEF VAR pError AS CHAR NO-UNDO.

  lOrdenLista = NO.
  pError = "".
  CICLO:
  DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
      FOR EACH CDOCU NO-LOCK, FIRST Vtacdocu OF CDOCU EXCLUSIVE-LOCK:
          lOrdenLista = NO.
          ASSIGN
              x-CodRef = Vtacdocu.codped
              x-NroRef = ENTRY(1,Vtacdocu.nroped,'-').
          FIND Faccpedi WHERE Faccpedi.codcia = Vtacdocu.codcia
              AND Faccpedi.coddiv = Vtacdocu.coddiv
              AND Faccpedi.coddoc = x-codref
              AND Faccpedi.nroped = x-nroref
              EXCLUSIVE-LOCK NO-ERROR.
          IF NOT AVAILABLE Faccpedi THEN DO:
              pError = "Comprobante " + x-codref + " " + x-nroref + " en uso por otro usuario".
              UNDO, LEAVE CICLO.
          END.
          /* Volvemos a chequear las condiciones */
          IF NOT (Vtacdocu.flgest = 'X' AND Vtacdocu.flgsit = 'T') THEN DO:

              pError =  'ERROR en la Sub-Orden ' + Vtacdocu.nroped + ' ya NO está pendiente de Cierre de Pickeo'.
              UNDO, LEAVE CICLO.

          END.
          ASSIGN 
              Vtacdocu.flgest       = 'P'
              Vtacdocu.flgsit       = CDOCU.FlgSit
              Vtacdocu.Libre_c03    = CDOCU.Libre_c03
              Vtacdocu.Libre_c04    = s-user-id + '|' + STRING(NOW, '99/99/9999 HH:MM:SS')
              Vtacdocu.usrsacrecep  = CDOCU.UsrSacRecep
              Vtacdocu.zonapickeo   = CDOCU.ZonaPickeo
              Vtacdocu.fchfin       = CDOCU.FchFin
              Vtacdocu.usuariofin   = CDOCU.UsuarioFin.
          FOR EACH Vtaddocu OF Vtacdocu:
              ASSIGN
                  Vtaddocu.CanBase = Vtaddocu.CanPed.
          END.
          /* TRACKING */
          RUN vtagn/pTracking-04 (s-CodCia,
                                  s-CodDiv,
                                  Vtacdocu.CodRef,
                                  Vtacdocu.NroRef,
                                  s-User-Id,
                                  'VODP',
                                  'P',
                                  DATETIME(TODAY, MTIME),
                                  DATETIME(TODAY, MTIME),
                                  Vtacdocu.CodPed,
                                  Vtacdocu.NroPed,
                                  Vtacdocu.CodPed,
                                  ENTRY(1,Vtacdocu.NroPed,'-')).
          /* Verificamos si ya se puede cerrar la orden original */
          IF AVAILABLE Faccpedi 
              AND NOT CAN-FIND(FIRST Vtacdocu WHERE Vtacdocu.codcia = Faccpedi.codcia
                               AND Vtacdocu.coddiv = Faccpedi.coddiv
                               AND Vtacdocu.codped = Faccpedi.coddoc
                               AND ENTRY(1,Vtacdocu.nroped,'-') = Faccpedi.nroped
                               AND Vtacdocu.flgsit <> "C"
                               NO-LOCK) THEN DO:
              ASSIGN
                  Faccpedi.FlgSit = "P".    /* Picking OK */
              lOrdenLista = YES.

          END.
          /* Ic - 15Feb2018, COMPLETADO / FALTANTES a las subordenes  */
          x-NroRef = ENTRY(1,Vtacdocu.nroped,'-').  /*ENTRY(1,FILL-IN-NroPed,'-').*/
          FOR EACH b-vtacdocu WHERE b-vtacdocu.codcia = s-codcia 
              /* AND b-vtacdocu.divdes = Vtacdocu.coddiv */
              AND b-vtacdocu.coddiv = Vtacdocu.coddiv
              AND b-vtacdocu.codped = Vtacdocu.codped
              AND ENTRY(1,b-vtacdocu.nroped,'-') = x-nroref :
              ASSIGN 
                  b-VtacDocu.libre_c05 = IF(lOrdenLista = YES) THEN "COMPLETADO" ELSE "FALTANTES".
          END.

      END.

      /* Marco la ORDEN como COMPLETADO o FALTANTES */
      x-NroRef = ENTRY(1,FILL-IN-NroPed,'-').
      FOR EACH b-vtacdocu WHERE b-vtacdocu.codcia = s-codcia 
          AND b-vtacdocu.divdes = s-CodDiv
          AND b-vtacdocu.codped = RADIO-SET-CodDoc 
          AND ENTRY(1,b-vtacdocu.nroped,'-') = x-nroref :
          ASSIGN 
              b-VtacDocu.libre_c05 = IF(lOrdenLista = YES) THEN "COMPLETADO" ELSE "FALTANTES".
      END.

  END.
  IF AVAILABLE(Vtacdocu) THEN RELEASE Vtacdocu.
  IF AVAILABLE(PikSacadores) THEN RELEASE PikSacadores.
  IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
  IF AVAILABLE(b-vtacdocu) THEN RELEASE b-vtacdocu.
  IF pError > "" THEN MESSAGE pError VIEW-AS ALERT-BOX ERROR.
  IF lOrdenLista = YES THEN DO:
/*       MESSAGE "Documento" RADIO-SET-CodDoc ENTRY(1,FILL-IN-NroPed,'-') "listo para CIERRE" VIEW-AS ALERT-BOX INFORMATION. */
  END.
  RETURN "OK".

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
  DISPLAY RADIO-SET-CodDoc FILL-IN-NroPed 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RADIO-SET-CodDoc BtnDone BUTTON-1 BUTTON-9 FILL-IN-NroPed BROWSE-5 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpia-Variables W-Win 
PROCEDURE Limpia-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    FILL-IN-NroPed = ''.
    EMPTY TEMP-TABLE CDOCU.
    DISPLAY FILL-IN-NroPed.
    {&OPEN-QUERY-{&BROWSE-NAME}}
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
  {src/adm/template/snd-list.i "CDOCU"}

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

