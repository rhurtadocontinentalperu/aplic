&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
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

&SCOPED-DEFINE precio-venta-general web/PrecioFinalContadoMayorista.p

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF SHARED VAR s-codcia AS INTE.

DEF INPUT PARAMETER s-codmat AS CHAR.
DEF INPUT PARAMETER s-codalm AS CHAR.
DEF INPUT PARAMETER s-coddiv AS CHAR.
DEF INPUT PARAMETER s-CodCli AS CHAR.
DEF INPUT PARAMETER s-TpoCmb AS DECI.
DEF INPUT PARAMETER s-FlgSit AS CHAR.
DEF INPUT PARAMETER s-NroDec AS INTE.
DEF INPUT PARAMETER s-AlmDes AS CHAR.
DEF INPUT PARAMETER s-UndVta AS CHAR.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND
    Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almmmatg

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog Almmmatg.codmat Almmmatg.UndBas ~
Almmmatg.DesMat Almmmatg.DtoVolR[1] Almmmatg.DtoVolD[1] Almmmatg.DtoVolR[2] ~
Almmmatg.DtoVolD[2] Almmmatg.DtoVolR[3] Almmmatg.DtoVolD[3] ~
Almmmatg.DtoVolR[4] Almmmatg.DtoVolD[4] Almmmatg.DtoVolR[5] ~
Almmmatg.DtoVolD[5] Almmmatg.DtoVolR[6] Almmmatg.DtoVolD[6] ~
Almmmatg.DtoVolR[7] Almmmatg.DtoVolD[7] Almmmatg.DtoVolR[8] ~
Almmmatg.DtoVolD[8] Almmmatg.DtoVolR[9] Almmmatg.DtoVolD[9] ~
Almmmatg.DtoVolR[10] Almmmatg.DtoVolD[10] 
&Scoped-define QUERY-STRING-D-Dialog FOR EACH Almmmatg SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH Almmmatg SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog Almmmatg


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-38 RECT-39 RECT-40 RECT-41 RECT-43 ~
Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-FIELDS Almmmatg.codmat Almmmatg.UndBas ~
Almmmatg.DesMat Almmmatg.DtoVolR[1] Almmmatg.DtoVolD[1] Almmmatg.DtoVolR[2] ~
Almmmatg.DtoVolD[2] Almmmatg.DtoVolR[3] Almmmatg.DtoVolD[3] ~
Almmmatg.DtoVolR[4] Almmmatg.DtoVolD[4] Almmmatg.DtoVolR[5] ~
Almmmatg.DtoVolD[5] Almmmatg.DtoVolR[6] Almmmatg.DtoVolD[6] ~
Almmmatg.DtoVolR[7] Almmmatg.DtoVolD[7] Almmmatg.DtoVolR[8] ~
Almmmatg.DtoVolD[8] Almmmatg.DtoVolR[9] Almmmatg.DtoVolD[9] ~
Almmmatg.DtoVolR[10] Almmmatg.DtoVolD[10] 
&Scoped-define DISPLAYED-TABLES Almmmatg
&Scoped-define FIRST-DISPLAYED-TABLE Almmmatg
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_DtoVolP-1 FILL-IN_DtoVolP-2 ~
FILL-IN_DtoVolP-3 FILL-IN_DtoVolP-4 FILL-IN_DtoVolP-5 FILL-IN_DtoVolP-6 ~
FILL-IN_DtoVolP-7 FILL-IN_DtoVolP-8 FILL-IN_DtoVolP-9 FILL-IN_DtoVolP-10 

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

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.15
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN_DtoVolP-1 AS DECIMAL FORMAT ">,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81.

DEFINE VARIABLE FILL-IN_DtoVolP-10 AS DECIMAL FORMAT ">,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81.

DEFINE VARIABLE FILL-IN_DtoVolP-2 AS DECIMAL FORMAT ">,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81.

DEFINE VARIABLE FILL-IN_DtoVolP-3 AS DECIMAL FORMAT ">,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81.

DEFINE VARIABLE FILL-IN_DtoVolP-4 AS DECIMAL FORMAT ">,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81.

DEFINE VARIABLE FILL-IN_DtoVolP-5 AS DECIMAL FORMAT ">,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81.

DEFINE VARIABLE FILL-IN_DtoVolP-6 AS DECIMAL FORMAT ">,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81.

DEFINE VARIABLE FILL-IN_DtoVolP-7 AS DECIMAL FORMAT ">,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81.

DEFINE VARIABLE FILL-IN_DtoVolP-8 AS DECIMAL FORMAT ">,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81.

DEFINE VARIABLE FILL-IN_DtoVolP-9 AS DECIMAL FORMAT ">,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .81.

DEFINE RECTANGLE RECT-38
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 11.85.

DEFINE RECTANGLE RECT-39
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18 BY 9.69.

DEFINE RECTANGLE RECT-40
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 15 BY 9.69.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 16 BY 9.69.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY .81.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     Almmmatg.codmat AT ROW 1.73 COL 1.14 COLON-ALIGNED NO-LABEL WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .69
          BGCOLOR 15 FGCOLOR 1 
     Almmmatg.UndBas AT ROW 1.73 COL 18.14 COLON-ALIGNED NO-LABEL WIDGET-ID 74 FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 15 FGCOLOR 1 
     Almmmatg.DesMat AT ROW 2.58 COL 1.14 COLON-ALIGNED NO-LABEL WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 40.57 BY .69
          BGCOLOR 15 FGCOLOR 1 
     Almmmatg.DtoVolR[1] AT ROW 4.5 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[1] AT ROW 4.5 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     FILL-IN_DtoVolP-1 AT ROW 4.5 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 80
     Almmmatg.DtoVolR[2] AT ROW 5.31 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 54
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[2] AT ROW 5.31 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     FILL-IN_DtoVolP-2 AT ROW 5.31 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 82
     Almmmatg.DtoVolR[3] AT ROW 6.12 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[3] AT ROW 6.12 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     FILL-IN_DtoVolP-3 AT ROW 6.12 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     Almmmatg.DtoVolR[4] AT ROW 6.92 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 58
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[4] AT ROW 6.92 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     FILL-IN_DtoVolP-4 AT ROW 6.92 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 86
     Almmmatg.DtoVolR[5] AT ROW 7.73 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[5] AT ROW 7.73 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     FILL-IN_DtoVolP-5 AT ROW 7.73 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 88
     Almmmatg.DtoVolR[6] AT ROW 8.54 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[6] AT ROW 8.54 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     FILL-IN_DtoVolP-6 AT ROW 8.54 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     Almmmatg.DtoVolR[7] AT ROW 9.35 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 64
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[7] AT ROW 9.35 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     FILL-IN_DtoVolP-7 AT ROW 9.35 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 92
     Almmmatg.DtoVolR[8] AT ROW 10.15 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 66
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[8] AT ROW 10.15 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 46
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     FILL-IN_DtoVolP-8 AT ROW 10.15 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 94
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME D-Dialog
     Almmmatg.DtoVolR[9] AT ROW 10.96 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 68
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[9] AT ROW 10.96 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     FILL-IN_DtoVolP-9 AT ROW 10.96 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 96
     Almmmatg.DtoVolR[10] AT ROW 11.77 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     Almmmatg.DtoVolD[10] AT ROW 11.77 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .81
     FILL-IN_DtoVolP-10 AT ROW 11.81 COL 35 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     Btn_OK AT ROW 13.38 COL 3
     Btn_Cancel AT ROW 13.38 COL 19
     "Descuento %" VIEW-AS TEXT
          SIZE 10.86 BY .5 AT ROW 3.54 COL 21 WIDGET-ID 72
     "Cantidad Minima" VIEW-AS TEXT
          SIZE 11.14 BY .5 AT ROW 3.54 COL 5.14 WIDGET-ID 70
     "Precio S/" VIEW-AS TEXT
          SIZE 9 BY .5 AT ROW 3.54 COL 39 WIDGET-ID 76
     "DESCUENTO POR VOLUMEN" VIEW-AS TEXT
          SIZE 25 BY .5 AT ROW 1 COL 11 WIDGET-ID 24
          BGCOLOR 9 FGCOLOR 15 FONT 6
     RECT-38 AT ROW 1.27 COL 2 WIDGET-ID 98
     RECT-39 AT ROW 3.42 COL 2 WIDGET-ID 100
     RECT-40 AT ROW 3.42 COL 20 WIDGET-ID 102
     RECT-41 AT ROW 3.42 COL 35 WIDGET-ID 104
     RECT-43 AT ROW 3.42 COL 2 WIDGET-ID 106
     SPACE(1.71) SKIP(11.03)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "DESCUENTO POR VOLUMEN"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
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
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Almmmatg.codmat IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DesMat IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolD[10] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolD[1] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolD[2] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolD[3] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolD[4] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolD[5] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolD[6] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolD[7] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolD[8] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolD[9] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolR[10] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolR[1] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolR[2] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolR[3] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolR[4] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolR[5] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolR[6] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolR[7] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolR[8] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DtoVolR[9] IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DtoVolP-1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DtoVolP-10 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DtoVolP-2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DtoVolP-3 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DtoVolP-4 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DtoVolP-5 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DtoVolP-6 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DtoVolP-7 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DtoVolP-8 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DtoVolP-9 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.UndBas IN FRAME D-Dialog
   NO-ENABLE EXP-FORMAT                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "INTEGRAL.Almmmatg"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* DESCUENTO POR VOLUMEN */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[10] D-Dialog
ON LEAVE OF Almmmatg.DtoVolD[10] IN FRAME D-Dialog /* DtoVolD */
DO:
 DO WITH FRAME {&FRAME-NAME}:
    IF INTEGER(Almmmatg.DtoVolR[10]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
    IF INTEGER(Almmmatg.DtoVolR[10]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
       MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
               "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.    
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[1] D-Dialog
ON LEAVE OF Almmmatg.DtoVolD[1] IN FRAME D-Dialog /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatg.DtoVolR[1]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatg.DtoVolR[1]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[2] D-Dialog
ON LEAVE OF Almmmatg.DtoVolD[2] IN FRAME D-Dialog /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatg.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatg.DtoVolR[2]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[3] D-Dialog
ON LEAVE OF Almmmatg.DtoVolD[3] IN FRAME D-Dialog /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatg.DtoVolR[3]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatg.DtoVolR[3]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[4] D-Dialog
ON LEAVE OF Almmmatg.DtoVolD[4] IN FRAME D-Dialog /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatg.DtoVolR[4]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatg.DtoVolR[4]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[5] D-Dialog
ON LEAVE OF Almmmatg.DtoVolD[5] IN FRAME D-Dialog /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatg.DtoVolR[5]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatg.DtoVolR[5]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[6] D-Dialog
ON LEAVE OF Almmmatg.DtoVolD[6] IN FRAME D-Dialog /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatg.DtoVolR[6]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatg.DtoVolR[6]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[7] D-Dialog
ON LEAVE OF Almmmatg.DtoVolD[7] IN FRAME D-Dialog /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatg.DtoVolR[7]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatg.DtoVolR[7]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[8] D-Dialog
ON LEAVE OF Almmmatg.DtoVolD[8] IN FRAME D-Dialog /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatg.DtoVolR[8]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatg.DtoVolR[8]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Almmmatg.DtoVolD[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Almmmatg.DtoVolD[9] D-Dialog
ON LEAVE OF Almmmatg.DtoVolD[9] IN FRAME D-Dialog /* DtoVolD */
DO:
  DO WITH FRAME {&FRAME-NAME}:
      IF INTEGER(Almmmatg.DtoVolR[9]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) = 0 THEN RETURN.
      IF INTEGER(Almmmatg.DtoVolR[9]:SCREEN-VALUE) = 0 AND DECI(SELF:SCREEN-VALUE) <> 0 THEN DO:
          MESSAGE "Descuento Solo se aplica Para Rangos Mayores a Cero " SKIP
              "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY FILL-IN_DtoVolP-1 FILL-IN_DtoVolP-2 FILL-IN_DtoVolP-3 
          FILL-IN_DtoVolP-4 FILL-IN_DtoVolP-5 FILL-IN_DtoVolP-6 
          FILL-IN_DtoVolP-7 FILL-IN_DtoVolP-8 FILL-IN_DtoVolP-9 
          FILL-IN_DtoVolP-10 
      WITH FRAME D-Dialog.
  IF AVAILABLE Almmmatg THEN 
    DISPLAY Almmmatg.codmat Almmmatg.UndBas Almmmatg.DesMat Almmmatg.DtoVolR[1] 
          Almmmatg.DtoVolD[1] Almmmatg.DtoVolR[2] Almmmatg.DtoVolD[2] 
          Almmmatg.DtoVolR[3] Almmmatg.DtoVolD[3] Almmmatg.DtoVolR[4] 
          Almmmatg.DtoVolD[4] Almmmatg.DtoVolR[5] Almmmatg.DtoVolD[5] 
          Almmmatg.DtoVolR[6] Almmmatg.DtoVolD[6] Almmmatg.DtoVolR[7] 
          Almmmatg.DtoVolD[7] Almmmatg.DtoVolR[8] Almmmatg.DtoVolD[8] 
          Almmmatg.DtoVolR[9] Almmmatg.DtoVolD[9] Almmmatg.DtoVolR[10] 
          Almmmatg.DtoVolD[10] 
      WITH FRAME D-Dialog.
  ENABLE RECT-38 RECT-39 RECT-40 RECT-41 RECT-43 Btn_OK Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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
  DEF VAR f-PreUni AS DECI NO-UNDO.
  DEF VAR s-CodMon AS INTE INIT 1 NO-UNDO.
  DEF VAR f-Factor AS DECI NO-UNDO.
  DEF VAR f-PreBas AS DECI NO-UNDO.
  DEF VAR f-PreVta AS DECI NO-UNDO.
  DEF VAR f-Dsctos AS DECI NO-UNDO.
  DEF VAR y-Dsctos AS DECI NO-UNDO.
  DEF VAR x-TipDto AS CHAR NO-UNDO.
  DEF VAR f-FleteUnitario AS DECI NO-UNDO.
  DEF VAR pMensaje AS CHAR NO-UNDO.


  RUN {&precio-venta-general} (s-CodCia,
                               s-CodDiv,
                               s-CodCli,
                               s-CodMon,
                               s-TpoCmb,
                               OUTPUT f-Factor,
                               s-CodMat,
                               s-FlgSit,
                               s-UndVta,
                               1,
                               s-NroDec,
                               s-AlmDes,   /* Necesario para REMATES */
                               OUTPUT f-PreBas,
                               OUTPUT f-PreVta,
                               OUTPUT f-Dsctos,
                               OUTPUT y-Dsctos,
                               OUTPUT x-TipDto,
                               OUTPUT f-FleteUnitario,
                               OUTPUT pMensaje
                               ).
  IF RETURN-VALUE = 'ADM-ERROR' THEN f-PreBas = 0.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Almmmatg THEN DO WITH FRAME {&FRAME-NAME}:
      DISPLAY
          s-UndVta @ Almmmatg.UndBas
          ROUND((1 - Almmmatg.DtoVolD[1] / 100) * f-PreBas, 2) WHEN Almmmatg.DtoVolD[1] > 0 @ FILL-IN_DtoVolP-1 
          ROUND((1 - Almmmatg.DtoVolD[2] / 100) * f-PreBas, 2) WHEN Almmmatg.DtoVolD[2] > 0 @ FILL-IN_DtoVolP-2
          ROUND((1 - Almmmatg.DtoVolD[3] / 100) * f-PreBas, 2) WHEN Almmmatg.DtoVolD[3] > 0 @ FILL-IN_DtoVolP-3
          ROUND((1 - Almmmatg.DtoVolD[4] / 100) * f-PreBas, 2) WHEN Almmmatg.DtoVolD[4] > 0 @ FILL-IN_DtoVolP-4
          ROUND((1 - Almmmatg.DtoVolD[5] / 100) * f-PreBas, 2) WHEN Almmmatg.DtoVolD[5] > 0 @ FILL-IN_DtoVolP-5
          ROUND((1 - Almmmatg.DtoVolD[6] / 100) * f-PreBas, 2) WHEN Almmmatg.DtoVolD[6] > 0 @ FILL-IN_DtoVolP-6
          ROUND((1 - Almmmatg.DtoVolD[7] / 100) * f-PreBas, 2) WHEN Almmmatg.DtoVolD[7] > 0 @ FILL-IN_DtoVolP-7
          ROUND((1 - Almmmatg.DtoVolD[8] / 100) * f-PreBas, 2) WHEN Almmmatg.DtoVolD[8] > 0 @ FILL-IN_DtoVolP-8
          ROUND((1 - Almmmatg.DtoVolD[9] / 100) * f-PreBas, 2) WHEN Almmmatg.DtoVolD[9] > 0 @ FILL-IN_DtoVolP-9
          ROUND((1 - Almmmatg.DtoVolD[10] / 100) * f-PreBas, 2) WHEN Almmmatg.DtoVolD[10] > 0 @ FILL-IN_DtoVolP-10
          .

  END.

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

