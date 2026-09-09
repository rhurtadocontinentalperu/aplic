&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.
DEFINE TEMP-TABLE ttCcbCDocu NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE ttCcbDDocu NO-UNDO LIKE CcbDDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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

&SCOPED-DEFINE ARITMETICA-SUNAT YES

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER pCoddiv AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pCoddoc AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER pNrodoc AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR s-codcia AS INT.             
DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR s-coddiv AS CHAR.

DEFINE VAR x-coddoc AS CHAR INIT 'N/C'.

FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                            ccbcdocu.coddiv = pCoddiv AND
                            ccbcdocu.coddoc = pCodDOc AND
                            ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.

IF AVAILABLE ccbcdocu THEN DO:
    IF ccbcdocu.flgest <> 'P' AND ccbcdocu.flgest <> 'AP' THEN DO:
        MESSAGE "El documento :" SKIP
                ccbcdocu.coddoc + "-" ccbcdocu.nrodoc SKIP
                "De : " + ccbcdocu.codcli + "-" + ccbcdocu.nomcli SKIP
                "YA NO ESTA APROBADA!!!"
                VIEW-AS ALERT-BOX INFORMATION.
        RETURN ERROR.
    END.

    CREATE ttCcbcdocu.
        BUFFER-COPY ccbcdocu TO ttCcbcdocu.
    ASSIGN ttCcbcdocu.codped = Ccbcdocu.coddoc          /* PNC */
            ttCcbcdocu.nroped = Ccbcdocu.nrodoc
            ttCcbcdocu.fchdoc = TODAY
            ttCcbcdocu.fchvto = TODAY + 365
            ttCcbcdocu.usuario = s-user-id
            ttCcbcdocu.flgest = 'P'
            ttCcbcdocu.coddoc = x-coddoc
            ttCcbcdocu.nrodoc = '00000000000'
            ttCcbcdocu.coddiv = s-coddiv
            /* Se va recalcular x si algun item no sea APROBADO x el jefe de Linea */
            ttCcbcdocu.ImpBrt = 0
            ttCcbcdocu.ImpExo = 0
            ttCcbcdocu.ImpDto = 0
            ttCcbcdocu.ImpIgv = 0
            ttCcbcdocu.ImpTot = 0
        .
END.
ELSE DO:
    MESSAGE "El documento :" SKIP
            ccbcdocu.coddoc + "-" ccbcdocu.nrodoc SKIP
            "De : " + ccbcdocu.codcli + "-" + ccbcdocu.nomcli
            VIEW-AS ALERT-BOX INFORMATION.
    RETURN ERROR.
END.

/* DEFINE VAR x-nueva-arimetica-sunat-2021 AS LOG. */
/*                                                 */
/* x-nueva-arimetica-sunat-2021 = YES.             */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttCcbDDocu Almmmatg ttCcbCDocu

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 ttCcbDDocu.NroItm ttCcbDDocu.codmat ~
Almmmatg.DesMat Almmmatg.DesMar ttCcbDDocu.PreUni ttCcbDDocu.UndVta ~
ttCcbDDocu.CanDes ttCcbDDocu.ImpIgv ttCcbDDocu.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH ttCcbDDocu NO-LOCK, ~
      EACH Almmmatg OF ttCcbDDocu NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH ttCcbDDocu NO-LOCK, ~
      EACH Almmmatg OF ttCcbDDocu NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 ttCcbDDocu Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 ttCcbDDocu
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 Almmmatg


/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog ttCcbCDocu.CodDoc ttCcbCDocu.NroDoc ~
ttCcbCDocu.CodDiv ttCcbCDocu.CodPed ttCcbCDocu.NroPed ttCcbCDocu.CodCli ~
ttCcbCDocu.FchVto ttCcbCDocu.NomCli ttCcbCDocu.RucCli ttCcbCDocu.FchDoc ~
ttCcbCDocu.CodMon ttCcbCDocu.ImpBrt ttCcbCDocu.ImpIgv ttCcbCDocu.ImpTot ~
ttCcbCDocu.usuario ttCcbCDocu.CodRef ttCcbCDocu.NroRef ttCcbCDocu.ImpExo ~
ttCcbCDocu.DivOri 
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-BROWSE-2}
&Scoped-define QUERY-STRING-D-Dialog FOR EACH ttCcbCDocu SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH ttCcbCDocu SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog ttCcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog ttCcbCDocu


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel COMBO-BOX-serie BROWSE-2 
&Scoped-Define DISPLAYED-FIELDS ttCcbCDocu.CodDoc ttCcbCDocu.NroDoc ~
ttCcbCDocu.CodDiv ttCcbCDocu.CodPed ttCcbCDocu.NroPed ttCcbCDocu.CodCli ~
ttCcbCDocu.FchVto ttCcbCDocu.NomCli ttCcbCDocu.RucCli ttCcbCDocu.FchDoc ~
ttCcbCDocu.CodMon ttCcbCDocu.ImpBrt ttCcbCDocu.ImpIgv ttCcbCDocu.ImpTot ~
ttCcbCDocu.usuario ttCcbCDocu.CodRef ttCcbCDocu.NroRef ttCcbCDocu.ImpExo ~
ttCcbCDocu.DivOri 
&Scoped-define DISPLAYED-TABLES ttCcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE ttCcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-division FILL-IN-moneda ~
COMBO-BOX-serie FILL-IN-division-origen 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-serie AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Serie de la N/C" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 9 BY 1
     FGCOLOR 9 FONT 11 NO-UNDO.

DEFINE VARIABLE FILL-IN-division AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .81
     FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE FILL-IN-division-origen AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .81
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-moneda AS CHARACTER FORMAT "X(5)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     FGCOLOR 9  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      ttCcbDDocu, 
      Almmmatg SCROLLING.

DEFINE QUERY D-Dialog FOR 
      ttCcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 D-Dialog _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      ttCcbDDocu.NroItm COLUMN-LABEL "Item" FORMAT ">>9":U WIDTH 5
      ttCcbDDocu.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U
            WIDTH 8.43
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 38.43
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 23.43
      ttCcbDDocu.PreUni COLUMN-LABEL "P.Unitario" FORMAT ">,>>>,>>9.999999":U
            WIDTH 8.43
      ttCcbDDocu.UndVta COLUMN-LABEL "Und Vta" FORMAT "x(8)":U
            WIDTH 5.43
      ttCcbDDocu.CanDes FORMAT ">,>>>,>>9.99":U WIDTH 6.43
      ttCcbDDocu.ImpIgv COLUMN-LABEL "Igv" FORMAT ">,>>>,>>9.9999":U
            WIDTH 7.43
      ttCcbDDocu.ImpLin FORMAT "->>,>>>,>>9.99":U WIDTH 7.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 118.57 BY 14.96
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     ttCcbCDocu.CodDoc AT ROW 1.04 COL 6.43 COLON-ALIGNED WIDGET-ID 4
          LABEL "T.Doc" FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .81
          FGCOLOR 9 
     ttCcbCDocu.NroDoc AT ROW 1.08 COL 18.14 COLON-ALIGNED WIDGET-ID 20
          LABEL "Nro.Doc" FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 12.29 BY .81
          FGCOLOR 9 
     ttCcbCDocu.CodDiv AT ROW 1.08 COL 37.57 COLON-ALIGNED WIDGET-ID 2
          LABEL "Division" FORMAT "x(5)"
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .81
          FGCOLOR 9 
     FILL-IN-division AT ROW 1.08 COL 43.57 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     Btn_OK AT ROW 1.19 COL 105
     ttCcbCDocu.CodPed AT ROW 1.92 COL 6.43 COLON-ALIGNED WIDGET-ID 48
          LABEL "Pre-Nota" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     ttCcbCDocu.NroPed AT ROW 1.92 COL 11.72 COLON-ALIGNED NO-LABEL WIDGET-ID 50 FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     Btn_Cancel AT ROW 2.42 COL 105
     ttCcbCDocu.CodCli AT ROW 2.81 COL 6.43 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .81
          FGCOLOR 9 
     ttCcbCDocu.FchVto AT ROW 2.81 COL 91.86 COLON-ALIGNED WIDGET-ID 10
          LABEL "Vcto" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .81
          FGCOLOR 9 
     ttCcbCDocu.NomCli AT ROW 2.85 COL 17.14 COLON-ALIGNED NO-LABEL WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .81
          FGCOLOR 9 
     ttCcbCDocu.RucCli AT ROW 2.85 COL 58.72 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          FGCOLOR 9 
     ttCcbCDocu.FchDoc AT ROW 2.85 COL 77.14 COLON-ALIGNED WIDGET-ID 8
          LABEL "Emision" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          FGCOLOR 9 
     FILL-IN-moneda AT ROW 3.65 COL 6.43 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     ttCcbCDocu.CodMon AT ROW 3.65 COL 6.43 COLON-ALIGNED WIDGET-ID 6
          LABEL "Moneda" FORMAT "9"
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .81
          FGCOLOR 9 
     Btn_Help AT ROW 3.65 COL 105
     ttCcbCDocu.ImpBrt AT ROW 3.69 COL 33 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
          FGCOLOR 9 
     ttCcbCDocu.ImpIgv AT ROW 3.69 COL 50.57 COLON-ALIGNED WIDGET-ID 14
          LABEL "I.G.V." FORMAT "->>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
          FGCOLOR 9 
     ttCcbCDocu.ImpTot AT ROW 3.77 COL 67.86 COLON-ALIGNED WIDGET-ID 16
          LABEL "Total" FORMAT "->>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
          FGCOLOR 9 
     ttCcbCDocu.usuario AT ROW 3.88 COL 92.14 COLON-ALIGNED WIDGET-ID 34
          LABEL "Usuario" FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
          FGCOLOR 9 
     ttCcbCDocu.CodRef AT ROW 4.5 COL 6.43 COLON-ALIGNED WIDGET-ID 26
          LABEL "Cod.Ref" FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          FGCOLOR 4 
     ttCcbCDocu.NroRef AT ROW 4.5 COL 19.29 COLON-ALIGNED WIDGET-ID 28
          LABEL "Nro. Ref" FORMAT "X(12)"
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .81
          FGCOLOR 4 
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME D-Dialog
     ttCcbCDocu.ImpExo AT ROW 4.54 COL 47 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
          FGCOLOR 12 
     COMBO-BOX-serie AT ROW 5.19 COL 74.72 COLON-ALIGNED WIDGET-ID 42
     ttCcbCDocu.DivOri AT ROW 5.35 COL 6.29 COLON-ALIGNED WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
          FGCOLOR 4 
     FILL-IN-division-origen AT ROW 5.35 COL 14.86 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     BROWSE-2 AT ROW 6.23 COL 2.43 WIDGET-ID 200
     SPACE(1.56) SKIP(0.30)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Generar Nota de Credito desde una PNC" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
      TABLE: ttCcbCDocu T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: ttCcbDDocu T "?" NO-UNDO INTEGRAL CcbDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 FILL-IN-division-origen D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON Btn_Help IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       Btn_Help:HIDDEN IN FRAME D-Dialog           = TRUE.

/* SETTINGS FOR FILL-IN ttCcbCDocu.CodCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttCcbCDocu.CodDiv IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN ttCcbCDocu.CodDoc IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN ttCcbCDocu.CodMon IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN ttCcbCDocu.CodPed IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN ttCcbCDocu.CodRef IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN ttCcbCDocu.DivOri IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttCcbCDocu.FchDoc IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN ttCcbCDocu.FchVto IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FILL-IN-division IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-division-origen IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-moneda IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttCcbCDocu.ImpBrt IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttCcbCDocu.ImpExo IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttCcbCDocu.ImpIgv IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN ttCcbCDocu.ImpTot IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN ttCcbCDocu.NomCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttCcbCDocu.NroDoc IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN ttCcbCDocu.NroPed IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN ttCcbCDocu.NroRef IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN ttCcbCDocu.RucCli IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ttCcbCDocu.usuario IN FRAME D-Dialog
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.ttCcbDDocu,INTEGRAL.Almmmatg OF Temp-Tables.ttCcbDDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.ttCcbDDocu.NroItm
"ttCcbDDocu.NroItm" "Item" ? "integer" ? ? ? ? ? ? no ? no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ttCcbDDocu.codmat
"ttCcbDDocu.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "38.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "23.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ttCcbDDocu.PreUni
"ttCcbDDocu.PreUni" "P.Unitario" ? "decimal" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttCcbDDocu.UndVta
"ttCcbDDocu.UndVta" "Und Vta" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttCcbDDocu.CanDes
"ttCcbDDocu.CanDes" ? ">,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttCcbDDocu.ImpIgv
"ttCcbDDocu.ImpIgv" "Igv" ? "decimal" ? ? ? ? ? ? no ? no no "7.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ttCcbDDocu.ImpLin
"ttCcbDDocu.ImpLin" ? ? "decimal" ? ? ? ? ? ? no ? no no "7.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "Temp-Tables.ttCcbCDocu"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Generar Nota de Credito desde una PNC */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help D-Dialog
ON CHOOSE OF Btn_Help IN FRAME D-Dialog /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
    /*btn_ok:AUTO-GO = NO  .*/

    DEFINE VAR hxProc AS HANDLE NO-UNDO.                /* Handle Libreria */
    DEFINE VAR x-retval AS CHAR.
    
    RUN ccb\libreria-ccb.r PERSISTENT SET hxProc.
                                                     
    RUN notas-creditos-supera-comprobante IN hxProc (INPUT ttCcbCdocu.codref, 
                                                 INPUT ttCcbCdocu.nroref,
                                                 OUTPUT x-retval).
    
    DELETE PROCEDURE hxProc.                    /* Release Libreria */
    
    /* 
        pRetVal : NO (importes de N/C NO supera al comprobante)
    */
    IF x-retval <> "NO" THEN DO:
        MESSAGE "El comprobante " + ttCcbCdocu.codref + " " + ttCcbCdocu.nroref SKIP
            "tiene emitida varias N/Cs que la suma de sus importes" SKIP
            "superan al importe total del comprobante"
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN NO-APPLY.
    END.
    ELSE DO:
        ASSIGN combo-box-serie.

        IF combo-box-serie = ? OR 
            COMBO-BOX-serie:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" OR 
            COMBO-BOX-serie:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ? THEN DO:

            MESSAGE "Elija la el Nro de Serie"
                    VIEW-AS ALERT-BOX INFORMATION.
            RETURN NO-APPLY.
        END.

        MESSAGE 'Seguro de generar la N/C con Serie Nro : ' + STRING(combo-box-serie,"999")
             VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = YES THEN DO:

            /* * */
            SESSION:SET-WAIT-STATE("GENERAL").
            RUN grabar-datos.
            SESSION:SET-WAIT-STATE("").

            IF RETURN-VALUE = 'OK' THEN DO:
                pRetVal = "OK".
            END.
            ELSE DO:
                pRetVal = "ADM-ERROR".
            END.

            /*btn_ok:AUTO-GO = YES.*/
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-items D-Dialog 
PROCEDURE carga-items :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ttCcbddocu.

DEFINE VAR x-estado-item AS CHAR.
DEFINE VAR x-item AS INT INIT 0.

DEFINE VAR x-ImpBrt AS DEC.
DEFINE VAR x-ImpExo AS DEC.
DEFINE VAR x-ImpIgv AS DEC.
DEFINE VAR x-ImpTot AS DEC.

SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH ccbddocu OF ccbcdocu NO-LOCK:
    IF NOT(TRUE <> (ccbddocu.flg_factor > "")) THEN DO:
        IF NUM-ENTRIES(ccbddocu.flg_factor,"|") >= 1 THEN DO:
            x-estado-item = ENTRY(1,ccbddocu.flg_factor,"|").
            IF x-estado-item = "APROBADO" THEN DO:
                x-item = x-item + 1.

                IF Ccbddocu.AftIgv = YES THEN x-ImpBrt = x-ImpBrt + ccbddocu.implin.
                IF Ccbddocu.AftIgv = NO THEN x-ImpExo = x-ImpExo + ccbddocu.implin.
                x-ImpIgv = x-ImpIgv + Ccbddocu.ImpIgv.
                x-ImpTot = x-ImpTot + Ccbddocu.ImpLin.

                CREATE ttCcbddocu.
                BUFFER-COPY ccbddocu TO ttCcbddocu.
                    ASSIGN ttCcbddocu.nroitm = x-item
                            ttCcbddocu.coddoc = x-coddoc
                            ttCcbddocu.dcto_otros_factor = 0
                            ttCcbddocu.Por_Dsctos[1] = 0
                            ttCcbddocu.Por_Dsctos[2] = 0
                            ttCcbddocu.Por_Dsctos[3] = 0.
            END.
        END.
    END.
END.

ASSIGN  ttCcbcdocu.ImpBrt = x-impbrt
        ttCcbcdocu.ImpExo = x-impexo
        ttCcbcdocu.ImpIgv = x-ImpIgv
        ttCcbcdocu.ImpTot = x-ImpTot
        ttCcbcdocu.ImpVta = ttCcbcdocu.ImpBrt - ttCcbcdocu.ImpIgv
        ttCcbcdocu.ImpBrt = ttCcbcdocu.ImpBrt - ttCcbcdocu.ImpIgv
        ttCcbcdocu.SdoAct = ttCcbcdocu.ImpTot.

fill-in-moneda:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF(ttCcbcdocu.codmon = 2) THEN 'Dolares americano' ELSE 'Soles'.

FIND FIRST gn-divi OF ttCcbcdocu NO-LOCK NO-ERROR.
IF AVAILABLE gn-divi THEN DO:
    fill-in-division:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-divi.desdiv.
END.

FIND FIRST gn-divi WHERE gn-divi.codcia = s-codcia AND
                        gn-divi.coddiv = ttCcbcdocu.divori NO-LOCK NO-ERROR.
IF AVAILABLE gn-divi THEN DO:
    fill-in-division-origen:SCREEN-VALUE IN FRAME {&FRAME-NAME} = gn-divi.desdiv.
END.


ASSIGN fill-in-moneda fill-in-division fill-in-division-origen.

DO WITH FRAME {&FRAME-NAME}:
    DISPLAY ttCcbcdocu.ImpBrt @ ttCcbcdocu.ImpBrt.
    DISPLAY ttCcbcdocu.ImpExo @ ttCcbcdocu.ImpExo.
    DISPLAY ttCcbcdocu.ImpIgv @ ttCcbcdocu.ImpIgv.
    DISPLAY ttCcbcdocu.ImpVta @ ttCcbcdocu.ImpVta.
    DISPLAY ttCcbcdocu.SdoAct @ ttCcbcdocu.SdoAct.
    DISPLAY ttCcbcdocu.imptot @ ttCcbcdocu.imptot.
    DISPLAY fill-in-moneda @ fill-in-moneda.
    DISPLAY fill-in-division @ fill-in-division.
    DISPLAY fill-in-division-origen @ fill-in-division-origen.
END.

{&open-query-browse-2}

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-division FILL-IN-moneda COMBO-BOX-serie 
          FILL-IN-division-origen 
      WITH FRAME D-Dialog.
  IF AVAILABLE ttCcbCDocu THEN 
    DISPLAY ttCcbCDocu.CodDoc ttCcbCDocu.NroDoc ttCcbCDocu.CodDiv 
          ttCcbCDocu.CodPed ttCcbCDocu.NroPed ttCcbCDocu.CodCli 
          ttCcbCDocu.FchVto ttCcbCDocu.NomCli ttCcbCDocu.RucCli 
          ttCcbCDocu.FchDoc ttCcbCDocu.CodMon ttCcbCDocu.ImpBrt 
          ttCcbCDocu.ImpIgv ttCcbCDocu.ImpTot ttCcbCDocu.usuario 
          ttCcbCDocu.CodRef ttCcbCDocu.NroRef ttCcbCDocu.ImpExo 
          ttCcbCDocu.DivOri 
      WITH FRAME D-Dialog.
  ENABLE Btn_OK Btn_Cancel COMBO-BOX-serie BROWSE-2 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Temp-FeLogErrores D-Dialog 
PROCEDURE Graba-Temp-FeLogErrores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-FeLogErrores:
    CREATE FeLogErrores.
    BUFFER-COPY T-FeLogErrores TO FeLogErrores NO-ERROR.
    DELETE T-FeLogErrores.
END.
RELEASE FeLogErrores.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grabar-datos D-Dialog 
PROCEDURE grabar-datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-msg AS CHAR.
DEFINE VAR x-serie AS INT.
DEFINE VAR x-numero AS INT.
DEFINE VAR x-nrodoc AS CHAR.

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-ccbddocu FOR ccbddocu.
DEFINE BUFFER pnc-ccbcdocu FOR ccbcdocu.

FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                            ccbcdocu.coddiv = pCoddiv AND
                            ccbcdocu.coddoc = pCodDOc AND
                            ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.

IF AVAILABLE ccbcdocu THEN DO:
    IF (ccbcdocu.flgest <> 'P' AND ccbcdocu.flgest <> 'AP')  THEN DO:
        MESSAGE "El documento :" SKIP
                ccbcdocu.coddoc + "-" ccbcdocu.nrodoc SKIP
                "De : " + ccbcdocu.codcli + "-" + ccbcdocu.nomcli SKIP
                "YA NO ESTA APROBADA!!!"
                VIEW-AS ALERT-BOX INFORMATION.
        x-msg = "ERROR".
        RETURN "ADM-ERROR".
    END.
END.
ELSE DO:
    MESSAGE "El documento :" SKIP
            pCodDoc + "-" pNroDoc SKIP
            "NO EXISTE!!!"
            VIEW-AS ALERT-BOX INFORMATION.
    x-msg = "ERROR".
    RETURN "ADM-ERROR".
END.

EMPTY TEMP-TABLE T-FELogErrores.
x-msg = "Grabando documento".

/* Grabar datos de la nota de credito */
GRABAR_DOCUMENTO:
DO TRANSACTION ON ERROR UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO:
    /* Header update block */
    DO:
       /* El numero de serie */ 
        FIND FIRST Faccorre WHERE  Faccorre.CodCia = S-CODCIA 
            AND Faccorre.CodDoc = x-CODDOC 
            AND Faccorre.CodDiv = S-CODDIV 
            AND Faccorre.NroSer = combo-box-serie
            AND Faccorre.FlgEst = YES EXCLUSIVE-LOCK NO-ERROR.
        IF LOCKED faccorre THEN DO:
            x-msg = "La tabla FACCORRE esta bloqueada por otro usuario".
            UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO.
        END.                                  
        ELSE DO:
            IF NOT AVAILABLE faccorre THEN DO:
                x-msg = 'Correlativo no asignado a la división : ' + s-coddiv .
                UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO.
            END.
        END.
        
        x-serie = FacCorre.nroser.
        x-numero = Faccorre.correlativo.
        ASSIGN
            Faccorre.correlativo = Faccorre.correlativo + 1 NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            x-msg = "Al actualizar el correlativo (" + ERROR-STATUS:GET-MESSAGE(1) + ")".
            UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO.
        END.                  

        /* Ultimos ajustes a los temporales */
        x-nrodoc = STRING(x-serie,"999") + STRING(x-numero,"99999999").

        ASSIGN ttccbcdocu.nrodoc = x-nrodoc
                ttccbcdocu.fchdoc = TODAY
                ttccbcdocu.horcie = STRING(TIME,"HH:MM:SS")
                ttccbcdocu.fchvto = TODAY + 365
                NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            x-msg = "ERROR - ttCcbcdocu :(" + ERROR-STATUS:GET-MESSAGE(1) + ")".
            UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO.
        END.

        /* Detalle */
        FOR EACH ttCcbddocu :
            /* Las notas de credito no tienen descuento */
            ASSIGN ttCcbddocu.nrodoc = x-nrodoc 
                    ttCcbddocu.dcto_otros_factor = 0
                    ttCcbddocu.Por_Dsctos[1] = 0
                    ttCcbddocu.Por_Dsctos[2] = 0
                    ttCcbddocu.Por_Dsctos[3] = 0
                    NO-ERROR.                
                
            IF ERROR-STATUS:ERROR THEN DO:
                x-msg = "ERROR - ttCcbddocu (" + ERROR-STATUS:GET-MESSAGE(1) + ")".
                UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO.
            END.                  
        END.

        /* La cabecera del documento */
        CREATE b-ccbcdocu.
            BUFFER-COPY ttCcbcdocu TO b-ccbcdocu NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            x-msg = "ERROR al crear registro en CCBCDOCU (" + ERROR-STATUS:GET-MESSAGE(1) + ")".
            UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO.
        END.
    END.
    FOR EACH ttCcbddocu ON ERROR UNDO, THROW:
        /* Detalle update block */
        CREATE b-ccbddocu.
            BUFFER-COPY ttCcbddocu TO b-ccbddocu NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            x-msg = "ERROR al crear registro en CCBDDOCU (" + ERROR-STATUS:GET-MESSAGE(1) + ")".
            UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO.
        END.
    END.

    /* Actualizo el estado de la PNC */
    FIND FIRST pnc-ccbcdocu OF ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
    IF LOCKED pnc-ccbcdocu THEN DO:
        x-msg = "La tabla CCBCDOCU esta bloqueada por otro usuario, se intento actualizar el estado de la PNC".
        UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO.
    END.                                  
    ELSE DO:
        IF NOT AVAILABLE faccorre THEN DO:
            x-msg = "La PNC no existe ????, se intento actualizar el estado de la PNC".
            UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO.
        END.
    END.
    ASSIGN pnc-ccbcdocu.flgest = 'G' NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        x-msg = "ERROR al actualizar el estado de la PNC (" + ERROR-STATUS:GET-MESSAGE(1) + ")".
        UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO.
    END.

    /* ****************************** */
    /* Ic - 16Nov2021 - Importes Arimetica de SUNAT */
    /* ****************************** */
    &IF {&ARITMETICA-SUNAT} &THEN
        DEF VAR hProc AS HANDLE NO-UNDO.
        RUN sunat/sunat-calculo-importes.r PERSISTENT SET hProc.
        RUN tabla-ccbcdocu IN hProc (INPUT s-coddiv,
                                     INPUT x-coddoc,
                                     INPUT x-nrodoc,
                                     OUTPUT x-msg).
        DELETE PROCEDURE hProc.
        /* ****************************** */
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO.
        END.
    &ENDIF
    x-msg = "OK".
END. /* TRANSACTION block */

RELEASE faccorre.
RELEASE b-ccbcdocu.
RELEASE b-ccbddocu.
RELEASE pnc-ccbcdocu.

IF x-msg = "OK" THEN DO:
    /* Lo enviamos al proveedor electronico */
    
    DEFINE VAR x-mensaje AS CHAR NO-UNDO.

    RUN sunat\progress-to-ppll-v3 ( INPUT s-coddiv,
                                    INPUT x-coddoc,
                                    INPUT x-nrodoc,
                                    INPUT-OUTPUT TABLE T-FELogErrores,
                                    OUTPUT x-mensaje ).
    
    RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */

    IF RETURN-VALUE = 'OK' THEN DO:
        MESSAGE "Se genero la " + x-coddoc + " - " + x-nrodoc + " correctamente"
                VIEW-AS ALERT-BOX INFORMATION.
        pRetVal = "OK".
        RETURN "OK".
    END.
    ELSE DO:
        /* Por Error, Anular la N/C y cambiar el estado a P (Aprobada) */
        FIND FIRST pnc-ccbcdocu OF ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE pnc-ccbcdocu THEN ASSIGN pnc-ccbcdocu.flgest = 'P' NO-ERROR.

        FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND
                                    b-ccbcdocu.coddiv = s-coddiv AND
                                    b-ccbcdocu.coddoc = x-coddoc AND
                                    b-ccbcdocu.nrodoc = x-nrodoc EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE b-ccbcdocu THEN DO:
            ASSIGN  b-Ccbcdocu.FlgEst = "A"
                    b-CcbCDocu.UsuAnu = "ERROR-FE"
                    b-CcbCDocu.FchAnu = TODAY.
        END.

        RELEASE b-CcbCDocu.
        RELEASE pnc-CcbCDocu.

        MESSAGE "Hubo problemas en la generacion del documento" SKIP
                "Mensaje : " + x-mensaje SKIP
                "Por favor intente de nuevo"
                VIEW-AS ALERT-BOX INFORMATION.

        RETURN "ADM-ERROR".
    END.
END.
ELSE DO:
    MESSAGE x-msg VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ADM-ERROR".
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:

      COMBO-BOX-serie:SCREEN-VALUE = "".

      REPEAT WHILE COMBO-BOX-serie:NUM-ITEMS > 0:
        COMBO-BOX-serie:DELETE(1).
      END.
      FOR EACH faccorre WHERE faccorre.codcia = s-codcia AND
                                faccorre.coddiv = s-coddiv AND
                                faccorre.coddoc = x-coddoc AND
                                faccorre.flgest = YES NO-LOCK :
          
        COMBO-BOX-serie:ADD-LAST(STRING(faccorre.nroser,"999")).
        IF TRUE <> (COMBO-BOX-serie:SCREEN-VALUE > "") THEN DO:
            COMBO-BOX-serie:SCREEN-VALUE = STRING(faccorre.nroser,"999").
        END.
        
      END.

  END.
  
  RUN carga-items NO-ERROR.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ttCcbCDocu"}
  {src/adm/template/snd-list.i "ttCcbDDocu"}
  {src/adm/template/snd-list.i "Almmmatg"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

