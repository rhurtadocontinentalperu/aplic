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
{lib/def-prn.i}    
DEFINE STREAM report.

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-CodCia AS INTEGER.
DEF SHARED VAR s-CodDiv AS CHARACTER.
DEF SHARED VAR s-CodDoc AS CHARACTER.
DEF SHARED VAR s-CodAlm AS CHARACTER.

DEF VAR ped        AS CHAR.
DEF VAR x-NOMCIA   AS CHAR.
DEF VAR F-DIRDIV   AS CHAR.
DEF VAR F-PUNTO    AS CHAR.
DEF VAR X-TITU     AS CHAR.
DEF VAR X-CodDoc   AS CHAR.
DEF VAR npage      AS DEC  NO-UNDO.
DEF VAR c-items    AS INT  NO-UNDO.

DEFINE TEMP-TABLE Reporte
    FIELDS NroPed LIKE FacCPedi.NroPed
    FIELDS CodRef LIKE FacCPedi.CodRef
    FIELDS nroRef LIKE FacCPedi.NroRef
    FIELDS CodMat LIKE FacDPedi.CodMat
    FIELDS DesMat LIKE Almmmatg.DesMat
    FIELDS DesMar LIKE Almmmatg.DesMar
    FIELDS UndBas LIKE Almmmatg.UndBas
    FIELDS CanPed LIKE FacDPedi.CanPed
/*RD01*/ FIELDS CodAlm LIKE Almmmate.CodAlm
    FIELDS CodUbi LIKE Almmmate.CodUbi
    FIELDS CodKit AS LOGICAL INIT NO.

FOR EACH empresas WHERE Empresas.CodCia = S-CODCIA NO-LOCK: 
    X-NOMCIA = Empresas.NomCia.
END.

ASSIGN 
    X-CodDoc = 'O/D'.

FOR EACH FacCfgGn WHERE FacCfgGn.CodCia = s-codcia:
    c-items = FacCfgGn.items_guias.
END.

DEFINE BUFFER b-reporte FOR reporte.

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
&Scoped-define INTERNAL-TABLES FacCPedi

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 FacCPedi.NroPed FacCPedi.NomCli ~
FacCPedi.FchPed FacCPedi.CodRef FacCPedi.NroRef 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define QUERY-STRING-BROWSE-5 FOR EACH FacCPedi ~
      WHERE FacCPedi.CodCia = s-CodCia ~
 /*AND FacCPedi.CodDiv = s-CodDiv*/ ~
 AND FacCPedi.CodAlm = s-CodAlm ~
 AND FacCPedi.FlgEst = "P" ~
 AND FacCPedi.FlgSit = "T" ~
 AND FacCPedi.CodDoc = x-CodDoc NO-LOCK ~
    BY FacCPedi.FchPed DESCENDING ~
       BY FacCPedi.NroPed DESCENDING INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH FacCPedi ~
      WHERE FacCPedi.CodCia = s-CodCia ~
 /*AND FacCPedi.CodDiv = s-CodDiv*/ ~
 AND FacCPedi.CodAlm = s-CodAlm ~
 AND FacCPedi.FlgEst = "P" ~
 AND FacCPedi.FlgSit = "T" ~
 AND FacCPedi.CodDoc = x-CodDoc NO-LOCK ~
    BY FacCPedi.FchPed DESCENDING ~
       BY FacCPedi.NroPed DESCENDING INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 FacCPedi


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-5 b-print b-cancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-cancel 
     LABEL "Cancelar" 
     SIZE 15 BY 1.12.

DEFINE BUTTON b-print 
     LABEL "Imprimir" 
     SIZE 15 BY 1.12.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 W-Win _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      FacCPedi.NroPed COLUMN-LABEL "Orden de Despacho" FORMAT "X(9)":U
            WIDTH 14.43
      FacCPedi.NomCli COLUMN-LABEL "Nombre del cliente" FORMAT "x(50)":U
            WIDTH 47
      FacCPedi.FchPed COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
            WIDTH 12.57
      FacCPedi.CodRef COLUMN-LABEL "Refer." FORMAT "x(3)":U
      FacCPedi.NroRef COLUMN-LABEL "Numero Referencia" FORMAT "X(9)":U
            WIDTH 14.29
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 98 BY 17.23
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-5 AT ROW 1.27 COL 2 WIDGET-ID 200
     b-print AT ROW 18.77 COL 70 WIDGET-ID 2
     b-cancel AT ROW 18.77 COL 85 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 101.57 BY 19.31
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
         TITLE              = "IMPRESION PARA PICKING DE ORDENES DE DESPACHO"
         HEIGHT             = 19.31
         WIDTH              = 101.57
         MAX-HEIGHT         = 19.31
         MAX-WIDTH          = 105.43
         VIRTUAL-HEIGHT     = 19.31
         VIRTUAL-WIDTH      = 105.43
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
/* BROWSE-TAB BROWSE-5 1 F-Main */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "INTEGRAL.FacCPedi"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "INTEGRAL.FacCPedi.FchPed|no,INTEGRAL.FacCPedi.NroPed|no"
     _Where[1]         = "FacCPedi.CodCia = s-CodCia
 /*AND FacCPedi.CodDiv = s-CodDiv*/
 AND FacCPedi.CodAlm = s-CodAlm
 AND FacCPedi.FlgEst = ""P""
 AND FacCPedi.FlgSit = ""T""
 AND FacCPedi.CodDoc = x-CodDoc"
     _FldNameList[1]   > INTEGRAL.FacCPedi.NroPed
"NroPed" "Orden de Despacho" ? "character" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.NomCli
"NomCli" "Nombre del cliente" ? "character" ? ? ? ? ? ? no ? no no "47" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.FchPed
"FchPed" "Emisión" ? "date" ? ? ? ? ? ? no ? no no "12.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.CodRef
"CodRef" "Refer." ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacCPedi.NroRef
"NroRef" "Numero Referencia" ? "character" ? ? ? ? ? ? no ? no no "14.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* IMPRESION PARA PICKING DE ORDENES DE DESPACHO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* IMPRESION PARA PICKING DE ORDENES DE DESPACHO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-cancel W-Win
ON CHOOSE OF b-cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-print W-Win
ON CHOOSE OF b-print IN FRAME F-Main /* Imprimir */
DO:
  DEF VAR i   AS INT NO-UNDO.
  DO i = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
    IF {&BROWSE-NAME}:FETCH-SELECTED-ROW(i) THEN DO:
        IF i = 1 
        THEN ped = TRIM(FacCPedi.NroPed).
    END.
  END.
  RUN imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-5
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
 DEFINE VAR conta AS INTEGER NO-UNDO INIT 0.
 DEFINE VARIABLE lKit AS LOGICAL     NO-UNDO.

 EMPTY TEMP-TABLE Reporte.

 FOR EACH FacDPedi OF FacCPedi NO-LOCK,
     FIRST Almmmatg WHERE Almmmatg.CodCia = FacCPedi.CodCia
           AND Almmmatg.CodMat = FacDPedi.CodMat NO-LOCK,
           FIRST Almmmate WHERE Almmmate.CodCia = FacCPedi.CodCia
                 AND Almmmate.CodAlm = FacCPedi.CodAlm
                 AND Almmmate.CodMat = FacDPedi.CodMat  
                 BREAK BY Almmmate.CodUbi BY FacDPedi.CodMat:
                 conta = conta + 1.
                 CREATE Reporte.
                 ASSIGN 
                     Reporte.NroPed = FacCPedi.NroPed
                     Reporte.CodRef = FacCPedi.CodRef
                     Reporte.NroRef = FacCPedi.NroRef
                     Reporte.CodMat = FacDPedi.CodMat
                     Reporte.DesMat = Almmmatg.DesMat
                     Reporte.DesMar = Almmmatg.DesMar
                     Reporte.UndBas = Almmmatg.UndBas
                     Reporte.CanPed = FacDPedi.CanPed
/*RD01*/             Reporte.CodAlm = FacCPedi.CodAlm
                     Reporte.CodUbi = Almmmate.CodUbi.
 END.
 FOR EACH Reporte:
     lKit = NO.
/*      FOR EACH AlmdKits WHERE AlmDKits.CodCia = s-CodCia                                         */
/*          AND AlmdKits.CodMat = Reporte.CodMat NO-LOCK,                                          */
/*          FIRST Almmmate WHERE Almmmate.CodCia = AlmDKits.CodCia                                 */
/*                AND Almmmate.CodAlm = Reporte.CodAlm                                             */
/*                AND Almmmate.CodMat = AlmDKits.CodMat2                                           */
/*                BREAK BY Almmmate.CodUbi                                                         */
/*                BY Reporte.CodMat:                                                               */
/*                FIND FIRST b-Reporte WHERE b-Reporte.NroPed = Reporte.NroPed                     */
/*                    AND b-Reporte.CodMat = AlmDkits.CodMat2                                      */
/*                    AND b-Reporte.CodKit NO-LOCK NO-ERROR.                                       */
/*                IF NOT AVAIL b-Reporte THEN DO:                                                  */
/*                    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia                         */
/*                        AND almmmatg.codmat = AlmDKits.CodMat2 NO-LOCK NO-ERROR.                 */
/*                    conta = conta + 1.                                                           */
/*                    CREATE b-Reporte.                                                            */
/*                    ASSIGN                                                                       */
/*                        b-Reporte.NroPed = Reporte.NroPed                                        */
/*                        b-Reporte.CodMat = AlmDKits.CodMat2                                      */
/*                        b-Reporte.CodKit = YES.                                                  */
/*                    IF AVAIL almmmatg THEN                                                       */
/*                        ASSIGN                                                                   */
/*                        b-Reporte.DesMat = Almmmatg.DesMat + ' (' + Reporte.CodMat + ')'         */
/*                        b-Reporte.DesMar = Almmmatg.DesMar                                       */
/*                        b-Reporte.UndBas = Almmmatg.UndBas.                                      */
/*                    ASSIGN                                                                       */
/*                        b-Reporte.CodAlm = FacCPedi.CodAlm                                       */
/*                        b-Reporte.CodUbi = Almmmate.CodUbi                                       */
/*                        b-Reporte.CanPed = Reporte.CanPed * AlmDKits.Cantidad.                   */
/*                END.                                                                             */
/*                ELSE DO:                                                                         */
/*                    ASSIGN                                                                       */
/*                        b-Reporte.CanPed = Reporte.CanPed * AlmDKits.Cantidad + b-Reporte.CanPed */
/*                        b-Reporte.DesMat = b-Reporte.DesMat + ' (' + Reporte.CodMat + ')'.       */
/*                END.                                                                             */
/*                lKit = YES.                                                                      */
/*      END.                                                                                       */
     IF lKit THEN
         FIND FIRST b-Reporte WHERE ROWID(b-Reporte) = ROWID(Reporte) EXCLUSIVE-LOCK NO-ERROR.
         IF AVAIL b-Reporte THEN DO: 
             conta = conta - 1.
             DELETE Reporte.
         END.
 END.

 npage = DECIMAL(conta / c-items ) - INTEGER(conta / c-items).
 IF npage <= 0 THEN npage = INTEGER(conta / c-items).
 ELSE npage = INTEGER(conta / c-items) + 1. 


END PROCEDURE.


 /****Cambio*****
 FOR EACH FacDPedi OF FacCPedi NO-LOCK,
     FIRST Almmmatg WHERE Almmmatg.CodCia = FacCPedi.CodCia
           AND Almmmatg.CodMat = FacDPedi.CodMat NO-LOCK,
           FIRST Almmmate WHERE Almmmate.CodCia = FacCPedi.CodCia
                 AND Almmmate.CodAlm = FacCPedi.CodAlm
                 AND Almmmate.CodMat = FacDPedi.CodMat  
                 BREAK BY Almmmate.CodUbi 
                       BY FacDPedi.CodMat:
                 conta = conta + 1.
                 CREATE Reporte.
                 ASSIGN 
                     Reporte.NroPed = FacCPedi.NroPed
                     Reporte.CodMat = FacDPedi.CodMat
                     Reporte.DesMat = Almmmatg.DesMat
                     Reporte.DesMar = Almmmatg.DesMar
                     Reporte.UndBas = Almmmatg.UndBas
                     Reporte.CanPed = FacDPedi.CanPed
                     Reporte.CodUbi = Almmmate.CodUbi.
 END.
  npage = DECIMAL(conta / c-items ) - INTEGER(conta / c-items).
  IF npage < 0 THEN npage = INTEGER(conta / c-items).
  ELSE npage = INTEGER(conta / c-items) + 1. 

END PROCEDURE.

*******Fin********/

/*
 FOR EACH FacCPedi NO-LOCK WHERE FacCPedi.CodCia = s-codcia
         AND FacCPedi.CodDiv = s-CodDiv
         AND FacCPedi.CodDoc = x-CodDoc
         AND FacCPedi.CodAlm = s-CodAlm
         AND FacCPedi.FlgEst = 'P'
         AND FacCPedi.FlgSit = ''
         AND FacCPedi.NroPed = ped :
         FOR EACH FacDPedi OF FacCPedi NO-LOCK,
             FIRST Almmmatg WHERE Almmmatg.CodCia = FacCPedi.CodCia
                   AND Almmmatg.CodMat = FacDPedi.CodMat NO-LOCK,
                   FIRST Almmmate WHERE Almmmate.CodCia = FacCPedi.CodCia
                         AND Almmmate.CodAlm = FacCPedi.CodAlm
                         AND Almmmate.CodMat = FacDPedi.CodMat  
                         BREAK BY Almmmate.CodUbi 
                               BY FacDPedi.CodMat:
                         conta = conta + 1.
                         CREATE Reporte.
                         ASSIGN 
                             Reporte.NroPed = FacCPedi.NroPed
                             Reporte.CodMat = FacDPedi.CodMat
                             Reporte.DesMat = Almmmatg.DesMat
                             Reporte.DesMar = Almmmatg.DesMar
                             Reporte.UndBas = Almmmatg.UndBas
                             Reporte.CanPed = FacDPedi.CanPed
                             Reporte.CodUbi = Almmmate.CodUbi.
         END.
 END.
 npage = DECIMAL(conta / c-items ) - INTEGER(conta / c-items).
 IF npage < 0 THEN npage = INTEGER(conta / c-items).
 ELSE npage = INTEGER(conta / c-items) + 1. 
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
  ENABLE BROWSE-5 b-print b-cancel 
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
DEFINE VARIABLE conta   AS INTEGER NO-UNDO INIT 1.    

DEFINE FRAME f-cab
        Reporte.CodMat FORMAT 'X(7)'
        Reporte.DesMat FORMAT 'x(60)'
        Reporte.DesMar FORMAT 'X(24)'
        Reporte.UndBas
        Reporte.CanPed FORMAT ">>,>>>,>>9.9999"
        Reporte.CodUbi FORMAT "x(10)"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + X-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "Pagina: " AT 85 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9"
        {&PRN4} + {&PRN7A} + {&PRN6B} + "/" + string(npage) AT 104 FORMAT "X(15)" SKIP(1)
        {&PRN4} + {&PRN6A} + " Fecha : " AT 1 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° ORDEN DE DESPACHO: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP  
        {&PRN3} + {&PRN7A} + {&PRN6B} + "N° PEDIDO: " + Reporte.CodRef + ' ' + Reporte.NroRef + {&PRN6B} + {&PRN7B} + {&PRN3} AT 80 FORMAT "X(40)" SKIP  
        {&PRN4} + {&PRN6A} + "Cliente: " + Faccpedi.nomcli + {&PRN6B} + {&PRN3} AT 1 FORMAT "X(50)" SKIP  
        {&PRN4} + {&PRN6B} + "Hora  : " AT 1 FORMAT "X(15)" STRING(TIME,"HH:MM") FORMAT "X(12)" SKIP
        "Direccion:" FacCPedi.Dircli FORMAT "x(80)" SKIP 
        "Pto. Llegada:" FacCPedi.LugEnt FORMAT 'X(80)' SKIP
        FacCPedi.lugent2 FORMAT 'x(80)' AT 14 SKIP
        /*{&PRN4} + {&PRN7A} + {&PRN6B} + "N° Pedido: " + Reporte.NroPed + {&PRN6B} + {&PRN7B} + {&PRN3} AT 1 FORMAT "X(30)" SKIP   */
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "Código  Descripción                                                    Marca                  Unidad      Cantidad Ubicación  Observaciones            " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/***     999999  123456789012345678901234567890123456789012345678901234567890 12345678901234567890 123456789  >>,>>>,>>9.9999 56789012345              ***/
         WITH WIDTH 400 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

 /*
 FOR EACH Reporte BREAK BY Reporte.NroPed:
 */
 FOR EACH Reporte BREAK BY Reporte.CodUbi BY Reporte.CodMat:
     IF conta <= c-items THEN DO:
         DISPLAY STREAM Report 
                Reporte.CodMat 
                Reporte.DesMat
                Reporte.DesMar
                Reporte.UndBas
                Reporte.CanPed
                Reporte.CodUbi
                "________________________"
                WITH FRAME f-cab.
         conta = conta + 1.
     END.
     IF conta > 13 THEN DO:
         PAGE STREAM Report.
         conta = 1.
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
 
    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    RUN Carga-Temporal.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 30.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 30. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(33) + {&Prn4} .
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM REPORT CLOSE.
    END.
    OUTPUT CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
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
  {src/adm/template/snd-list.i "FacCPedi"}

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

