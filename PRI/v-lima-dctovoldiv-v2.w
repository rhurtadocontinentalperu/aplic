&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
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

DEF SHARED VAR lh_handle AS HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES VtaDctoVol Almmmatg
&Scoped-define FIRST-EXTERNAL-TABLE VtaDctoVol


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaDctoVol, Almmmatg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS VtaDctoVol.DtoVolR[1] VtaDctoVol.DtoVolD[1] ~
VtaDctoVol.DtoVolP[1] VtaDctoVol.DtoVolR[2] VtaDctoVol.DtoVolD[2] ~
VtaDctoVol.DtoVolP[2] VtaDctoVol.DtoVolR[3] VtaDctoVol.DtoVolD[3] ~
VtaDctoVol.DtoVolP[3] VtaDctoVol.DtoVolR[4] VtaDctoVol.DtoVolD[4] ~
VtaDctoVol.DtoVolP[4] VtaDctoVol.DtoVolR[5] VtaDctoVol.DtoVolD[5] ~
VtaDctoVol.DtoVolP[5] VtaDctoVol.DtoVolR[6] VtaDctoVol.DtoVolD[6] ~
VtaDctoVol.DtoVolP[6] VtaDctoVol.DtoVolR[7] VtaDctoVol.DtoVolD[7] ~
VtaDctoVol.DtoVolP[7] VtaDctoVol.DtoVolR[8] VtaDctoVol.DtoVolD[8] ~
VtaDctoVol.DtoVolP[8] VtaDctoVol.DtoVolR[9] VtaDctoVol.DtoVolD[9] ~
VtaDctoVol.DtoVolP[9] VtaDctoVol.DtoVolR[10] VtaDctoVol.DtoVolD[10] ~
VtaDctoVol.DtoVolP[10] 
&Scoped-define ENABLED-TABLES VtaDctoVol
&Scoped-define FIRST-ENABLED-TABLE VtaDctoVol
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-4 
&Scoped-Define DISPLAYED-FIELDS Almmmatg.codmat Almmmatg.UndBas ~
Almmmatg.DesMat VtaDctoVol.DtoVolR[1] VtaDctoVol.DtoVolD[1] ~
VtaDctoVol.DtoVolP[1] VtaDctoVol.DtoVolR[2] VtaDctoVol.DtoVolD[2] ~
VtaDctoVol.DtoVolP[2] VtaDctoVol.DtoVolR[3] VtaDctoVol.DtoVolD[3] ~
VtaDctoVol.DtoVolP[3] VtaDctoVol.DtoVolR[4] VtaDctoVol.DtoVolD[4] ~
VtaDctoVol.DtoVolP[4] VtaDctoVol.DtoVolR[5] VtaDctoVol.DtoVolD[5] ~
VtaDctoVol.DtoVolP[5] VtaDctoVol.DtoVolR[6] VtaDctoVol.DtoVolD[6] ~
VtaDctoVol.DtoVolP[6] VtaDctoVol.DtoVolR[7] VtaDctoVol.DtoVolD[7] ~
VtaDctoVol.DtoVolP[7] VtaDctoVol.DtoVolR[8] VtaDctoVol.DtoVolD[8] ~
VtaDctoVol.DtoVolP[8] VtaDctoVol.DtoVolR[9] VtaDctoVol.DtoVolD[9] ~
VtaDctoVol.DtoVolP[9] VtaDctoVol.DtoVolR[10] VtaDctoVol.DtoVolD[10] ~
VtaDctoVol.DtoVolP[10] 
&Scoped-define DISPLAYED-TABLES Almmmatg VtaDctoVol
&Scoped-define FIRST-DISPLAYED-TABLE Almmmatg
&Scoped-define SECOND-DISPLAYED-TABLE VtaDctoVol
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-PrecioBase 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-PrecioBase AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "Precio Base" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 9.69.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51 BY 1.08.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18 BY 9.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Almmmatg.codmat AT ROW 1 COL 2 NO-LABEL WIDGET-ID 76
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .69
          BGCOLOR 11 FGCOLOR 0 
     Almmmatg.UndBas AT ROW 1 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 80 FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
          BGCOLOR 11 FGCOLOR 0 
     FILL-IN-PrecioBase AT ROW 1 COL 36 COLON-ALIGNED WIDGET-ID 84
     Almmmatg.DesMat AT ROW 1.81 COL 2 NO-LABEL WIDGET-ID 78
          VIEW-AS FILL-IN 
          SIZE 40.57 BY .69
          BGCOLOR 11 FGCOLOR 0 
     VtaDctoVol.DtoVolR[1] AT ROW 3.96 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVol.DtoVolD[1] AT ROW 3.96 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVol.DtoVolP[1] AT ROW 3.96 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     VtaDctoVol.DtoVolR[2] AT ROW 4.77 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVol.DtoVolD[2] AT ROW 4.77 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVol.DtoVolP[2] AT ROW 4.77 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 46
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     VtaDctoVol.DtoVolR[3] AT ROW 5.58 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVol.DtoVolD[3] AT ROW 5.58 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVol.DtoVolP[3] AT ROW 5.58 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     VtaDctoVol.DtoVolR[4] AT ROW 6.38 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVol.DtoVolD[4] AT ROW 6.38 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVol.DtoVolP[4] AT ROW 6.38 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     VtaDctoVol.DtoVolR[5] AT ROW 7.19 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVol.DtoVolD[5] AT ROW 7.19 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVol.DtoVolP[5] AT ROW 7.19 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     VtaDctoVol.DtoVolR[6] AT ROW 8 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVol.DtoVolD[6] AT ROW 8 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVol.DtoVolP[6] AT ROW 8 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 54
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     VtaDctoVol.DtoVolR[7] AT ROW 8.81 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVol.DtoVolD[7] AT ROW 8.81 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 36
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     VtaDctoVol.DtoVolP[7] AT ROW 8.81 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 56
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     VtaDctoVol.DtoVolR[8] AT ROW 9.62 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVol.DtoVolD[8] AT ROW 9.62 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 38
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVol.DtoVolP[8] AT ROW 9.62 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 58
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     VtaDctoVol.DtoVolR[9] AT ROW 10.42 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVol.DtoVolD[9] AT ROW 10.42 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 40
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVol.DtoVolP[9] AT ROW 10.42 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     VtaDctoVol.DtoVolR[10] AT ROW 11.23 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVol.DtoVolD[10] AT ROW 11.23 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVol.DtoVolP[10] AT ROW 11.23 COL 36 COLON-ALIGNED NO-LABEL WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     "Descuento %" VIEW-AS TEXT
          SIZE 10.86 BY .5 AT ROW 2.88 COL 20 WIDGET-ID 66
     "Precio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.88 COL 38 WIDGET-ID 64
     "Cantidad Minima" VIEW-AS TEXT
          SIZE 11.14 BY .5 AT ROW 2.88 COL 4 WIDGET-ID 62
     RECT-1 AT ROW 2.62 COL 2 WIDGET-ID 68
     RECT-2 AT ROW 2.62 COL 2 WIDGET-ID 70
     RECT-4 AT ROW 2.62 COL 18 WIDGET-ID 74
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.VtaDctoVol,INTEGRAL.Almmmatg
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 12.35
         WIDTH              = 66.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN Almmmatg.codmat IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN Almmmatg.DesMat IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-PrecioBase IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.UndBas IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME VtaDctoVol.DtoVolD[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolD[10] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolD[10] IN FRAME F-Main /* DtoVolD */
DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVol.DtoVolP[10]
        WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolD[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolD[1] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolD[1] IN FRAME F-Main /* DtoVolD */
DO:
  DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVol.DtoVolP[1]
      WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolD[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolD[2] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolD[2] IN FRAME F-Main /* DtoVolD */
DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVol.DtoVolP[2]
        WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolD[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolD[3] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolD[3] IN FRAME F-Main /* DtoVolD */
DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVol.DtoVolP[3]
        WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolD[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolD[4] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolD[4] IN FRAME F-Main /* DtoVolD */
DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVol.DtoVolP[4]
        WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolD[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolD[5] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolD[5] IN FRAME F-Main /* DtoVolD */
DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVol.DtoVolP[5]
        WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolD[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolD[6] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolD[6] IN FRAME F-Main /* DtoVolD */
DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVol.DtoVolP[6]
        WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolD[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolD[7] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolD[7] IN FRAME F-Main /* DtoVolD */
DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVol.DtoVolP[7]
        WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolD[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolD[8] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolD[8] IN FRAME F-Main /* DtoVolD */
DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVol.DtoVolP[8]
        WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolD[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolD[9] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolD[9] IN FRAME F-Main /* DtoVolD */
DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVol.DtoVolP[9]
        WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolP[10]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolP[10] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolP[10] IN FRAME F-Main /* DtoVolP */
DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVol.DtoVolD[10]
        WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolP[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolP[1] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolP[1] IN FRAME F-Main /* DtoVolP */
DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVol.DtoVolD[1]
        WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolP[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolP[2] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolP[2] IN FRAME F-Main /* DtoVolP */
DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVol.DtoVolD[2]
        WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolP[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolP[3] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolP[3] IN FRAME F-Main /* DtoVolP */
DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVol.DtoVolD[3]
        WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolP[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolP[4] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolP[4] IN FRAME F-Main /* DtoVolP */
DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVol.DtoVolD[4]
        WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolP[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolP[5] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolP[5] IN FRAME F-Main /* DtoVolP */
DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVol.DtoVolD[5]
        WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolP[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolP[6] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolP[6] IN FRAME F-Main /* DtoVolP */
DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVol.DtoVolD[6]
        WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolP[7]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolP[7] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolP[7] IN FRAME F-Main /* DtoVolP */
DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVol.DtoVolD[7]
        WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolP[8]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolP[8] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolP[8] IN FRAME F-Main /* DtoVolP */
DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVol.DtoVolD[8]
        WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaDctoVol.DtoVolP[9]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVol.DtoVolP[9] V-table-Win
ON LEAVE OF VtaDctoVol.DtoVolP[9] IN FRAME F-Main /* DtoVolP */
DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVol.DtoVolD[9]
        WITH FRAME {&FRAME-NAME}.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "VtaDctoVol"}
  {src/adm/template/row-list.i "Almmmatg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaDctoVol"}
  {src/adm/template/row-find.i "Almmmatg"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DEF VAR x-Orden AS INT NO-UNDO.
  DO x-Orden = 1 TO 10:
      VtaDctoVol.DtoVolD[x-Orden] = ROUND((1 - (VtaDctoVol.DtoVolP[x-Orden] / FILL-IN-PrecioBase)) * 100, 6) .
      IF VtaDctoVol.DtoVolR[x-Orden] = 0 OR VtaDctoVol.DtoVolD[x-Orden] = 0
      THEN ASSIGN
                VtaDctoVol.DtoVolR[x-Orden] = 0
                VtaDctoVol.DtoVolD[x-Orden] = 0
                VtaDctoVol.DToVolP[x-Orden] = 0.

  END.
  /* Ordenamos y guardamos */
  DEF VAR x-DtoVolR AS DEC EXTENT 10 NO-UNDO.
  DEF VAR x-DtoVolP AS DEC EXTENT 10 NO-UNDO.
  DEF VAR x-DtoVolD AS DEC EXTENT 10 NO-UNDO.
  DEF VAR x-Real AS INT NO-UNDO.

  x-Real = 0.
  DO x-Orden = 1 TO 10:
      IF VtaDctoVol.DtoVolR[x-Orden] > 0 THEN DO:
          x-Real = x-Real + 1.
          x-DtoVolD[x-Real] = VtaDctoVol.DToVolD[x-Orden].
          x-DtoVolR[x-Real] = VtaDctoVol.DtoVolR[x-Orden].
          x-DtoVolP[x-Real] = VtaDctoVol.DtoVolP[x-Orden].
      END.
  END.
  ASSIGN
      VtaDctoVol.DtoVolR = 0
      VtaDctoVol.DtoVolD = 0
      VtaDctoVol.DtoVolP = 0.
  DO x-Orden = 1 TO 10:
      ASSIGN
          VtaDctoVol.DtoVolR[x-Orden] = x-DtoVolR[x-Orden]
          VtaDctoVol.DtoVolD[x-Orden] = x-DtoVolD[x-Orden]
          VtaDctoVol.DtoVolP[x-Orden] = x-DtoVolP[x-Orden].

  END.


  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Enable-Header').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Almmmatg THEN DO WITH FRAME {&FRAME-NAME}:
      FILL-IN-PrecioBase = Almmmatg.Prevta[1].
      DISPLAY FILL-IN-PrecioBase.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Disable-Header').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "VtaDctoVol"}
  {src/adm/template/snd-list.i "Almmmatg"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.
  
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-ValorAnterior AS DEC NO-UNDO.
DEF VAR x-Orden AS INT NO-UNDO.
DEF VAR x-PreUni AS DEC NO-UNDO.

DEFINE VAR hProc AS HANDLE NO-UNDO.
RUN pri/pri-librerias PERSISTENT SET hProc.

DO WITH FRAME {&FRAME-NAME} :
    DO x-Orden = 1 TO 10:
        IF INPUT VtaDctoVol.DtoVolR[x-Orden] <= 0 THEN NEXT.
        IF x-ValorAnterior = 0 THEN x-ValorAnterior = VtaDctoVol.DtoVolR[x-Orden].
        IF INPUT VtaDctoVol.DtoVolR[x-Orden] < x-ValorANterior THEN DO:
            MESSAGE 'Cantidad mínima mal registrada' VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        x-ValorAnterior = INPUT VtaDctoVol.DtoVolR[x-Orden].
        /* ****************************************************************************************************** */
        /* Control Margen de Utilidad */
        /* ****************************************************************************************************** */
        DEFINE VAR x-Margen AS DECI NO-UNDO.
        DEFINE VAR x-Limite AS DECI NO-UNDO.
        DEFINE VAR pError AS CHAR NO-UNDO.
        /* 1ro. Calculamos el margen de utilidad */
        x-PreUni = INPUT VtaDctoVol.DtoVolP[x-Orden].
        RUN PRI_Margen-Utilidad IN hProc (INPUT VtaDctoVol.CodDiv,
                                          INPUT VtaDctoVol.CodMat,
                                          INPUT Almmmatg.UndBas,
                                          INPUT x-PreUni,
                                          INPUT Almmmatg.MonVta,        /*INPUT 1,*/
                                          OUTPUT x-Margen,
                                          OUTPUT x-Limite,
                                          OUTPUT pError).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            /* Error crítico */
            MESSAGE pError SKIP 'No admitido' VIEW-AS ALERT-BOX ERROR TITLE 'CONTROL DE MARGEN'.
            RETURN 'ADM-ERROR'.
        END.
        /* Controlamos si el margen de utilidad está bajo a través de la variable pError */
        IF pError > '' THEN DO:
            /* Error por margen de utilidad */
            /* 2do. Verificamos si solo es una ALERTA, definido por GG */
            DEF VAR pAlerta AS LOG NO-UNDO.
            RUN PRI_Alerta-de-Margen IN hProc (INPUT VtaDctoVol.CodMat,
                                               OUTPUT pAlerta).
            IF pAlerta = YES THEN MESSAGE pError VIEW-AS ALERT-BOX WARNING TITLE 'CONTROL DE MARGEN'.
            ELSE DO:
                MESSAGE pError SKIP 'NO admitido' VIEW-AS ALERT-BOX ERROR TITLE 'CONTROL DE MARGEN'.
                RETURN 'ADM-ERROR'.
            END.
        END.
    END.
END.
DELETE PROCEDURE hProc.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

