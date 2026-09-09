&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-FacTabla FOR FacTabla.



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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR lh_handle AS HANDLE.

DEF SHARED VAR s-Tabla-1 AS CHAR.

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
&Scoped-define EXTERNAL-TABLES VtaDctoVolSaldo
&Scoped-define FIRST-EXTERNAL-TABLE VtaDctoVolSaldo


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaDctoVolSaldo.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS VtaDctoVolSaldo.DtoVolR[1] ~
VtaDctoVolSaldo.DtoVolD[1] VtaDctoVolSaldo.DtoVolP[1] ~
VtaDctoVolSaldo.DtoVolR[2] VtaDctoVolSaldo.DtoVolD[2] ~
VtaDctoVolSaldo.DtoVolP[2] VtaDctoVolSaldo.DtoVolR[3] ~
VtaDctoVolSaldo.DtoVolD[3] VtaDctoVolSaldo.DtoVolP[3] ~
VtaDctoVolSaldo.DtoVolR[4] VtaDctoVolSaldo.DtoVolD[4] ~
VtaDctoVolSaldo.DtoVolP[4] VtaDctoVolSaldo.DtoVolR[5] ~
VtaDctoVolSaldo.DtoVolD[5] VtaDctoVolSaldo.DtoVolP[5] ~
VtaDctoVolSaldo.DtoVolR[6] VtaDctoVolSaldo.DtoVolD[6] ~
VtaDctoVolSaldo.DtoVolP[6] VtaDctoVolSaldo.DtoVolR[7] ~
VtaDctoVolSaldo.DtoVolD[7] VtaDctoVolSaldo.DtoVolP[7] ~
VtaDctoVolSaldo.DtoVolR[8] VtaDctoVolSaldo.DtoVolD[8] ~
VtaDctoVolSaldo.DtoVolP[8] VtaDctoVolSaldo.DtoVolR[9] ~
VtaDctoVolSaldo.DtoVolD[9] VtaDctoVolSaldo.DtoVolP[9] ~
VtaDctoVolSaldo.DtoVolR[10] VtaDctoVolSaldo.DtoVolD[10] ~
VtaDctoVolSaldo.DtoVolP[10] 
&Scoped-define ENABLED-TABLES VtaDctoVolSaldo
&Scoped-define FIRST-ENABLED-TABLE VtaDctoVolSaldo
&Scoped-Define ENABLED-OBJECTS RECT-14 RECT-15 
&Scoped-Define DISPLAYED-FIELDS VtaDctoVolSaldo.Unidad ~
VtaDctoVolSaldo.DtoVolR[1] VtaDctoVolSaldo.DtoVolD[1] ~
VtaDctoVolSaldo.DtoVolP[1] VtaDctoVolSaldo.DtoVolR[2] ~
VtaDctoVolSaldo.DtoVolD[2] VtaDctoVolSaldo.DtoVolP[2] ~
VtaDctoVolSaldo.DtoVolR[3] VtaDctoVolSaldo.DtoVolD[3] ~
VtaDctoVolSaldo.DtoVolP[3] VtaDctoVolSaldo.DtoVolR[4] ~
VtaDctoVolSaldo.DtoVolD[4] VtaDctoVolSaldo.DtoVolP[4] ~
VtaDctoVolSaldo.DtoVolR[5] VtaDctoVolSaldo.DtoVolD[5] ~
VtaDctoVolSaldo.DtoVolP[5] VtaDctoVolSaldo.DtoVolR[6] ~
VtaDctoVolSaldo.DtoVolD[6] VtaDctoVolSaldo.DtoVolP[6] ~
VtaDctoVolSaldo.DtoVolR[7] VtaDctoVolSaldo.DtoVolD[7] ~
VtaDctoVolSaldo.DtoVolP[7] VtaDctoVolSaldo.DtoVolR[8] ~
VtaDctoVolSaldo.DtoVolD[8] VtaDctoVolSaldo.DtoVolP[8] ~
VtaDctoVolSaldo.DtoVolR[9] VtaDctoVolSaldo.DtoVolD[9] ~
VtaDctoVolSaldo.DtoVolP[9] VtaDctoVolSaldo.DtoVolR[10] ~
VtaDctoVolSaldo.DtoVolD[10] VtaDctoVolSaldo.DtoVolP[10] 
&Scoped-define DISPLAYED-TABLES VtaDctoVolSaldo
&Scoped-define FIRST-DISPLAYED-TABLE VtaDctoVolSaldo
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

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY .96.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 8.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     VtaDctoVolSaldo.Unidad AT ROW 2 COL 18 COLON-ALIGNED WIDGET-ID 82
          LABEL "Unidad de Medida"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FILL-IN-PrecioBase AT ROW 2.08 COL 37 COLON-ALIGNED WIDGET-ID 106
     VtaDctoVolSaldo.DtoVolR[1] AT ROW 4.23 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 4 FORMAT ">>>,>>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVolSaldo.DtoVolD[1] AT ROW 4.23 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 62
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVolSaldo.DtoVolP[1] AT ROW 4.23 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 88
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     VtaDctoVolSaldo.DtoVolR[2] AT ROW 5.04 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 6 FORMAT ">>>,>>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVolSaldo.DtoVolD[2] AT ROW 5.04 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 64
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVolSaldo.DtoVolP[2] AT ROW 5.04 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 90
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     VtaDctoVolSaldo.DtoVolR[3] AT ROW 5.85 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 8 FORMAT ">>>,>>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVolSaldo.DtoVolD[3] AT ROW 5.85 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 66
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVolSaldo.DtoVolP[3] AT ROW 5.85 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 92
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     VtaDctoVolSaldo.DtoVolR[4] AT ROW 6.65 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 10 FORMAT ">>>,>>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVolSaldo.DtoVolD[4] AT ROW 6.65 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 68
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVolSaldo.DtoVolP[4] AT ROW 6.65 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 94
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     VtaDctoVolSaldo.DtoVolR[5] AT ROW 7.46 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 12 FORMAT ">>>,>>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVolSaldo.DtoVolD[5] AT ROW 7.46 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 70
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVolSaldo.DtoVolP[5] AT ROW 7.46 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 96
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     VtaDctoVolSaldo.DtoVolR[6] AT ROW 8.27 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 14 FORMAT ">>>,>>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVolSaldo.DtoVolD[6] AT ROW 8.27 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 72
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVolSaldo.DtoVolP[6] AT ROW 8.27 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 98
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     VtaDctoVolSaldo.DtoVolR[7] AT ROW 9.08 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 16 FORMAT ">>>,>>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVolSaldo.DtoVolD[7] AT ROW 9.08 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 74
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVolSaldo.DtoVolP[7] AT ROW 9.08 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 100
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     VtaDctoVolSaldo.DtoVolR[8] AT ROW 9.88 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 18 FORMAT ">>>,>>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVolSaldo.DtoVolD[8] AT ROW 9.88 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 76
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVolSaldo.DtoVolP[8] AT ROW 9.88 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 102
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     VtaDctoVolSaldo.DtoVolR[9] AT ROW 10.69 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 20 FORMAT ">>>,>>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVolSaldo.DtoVolD[9] AT ROW 10.69 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 78
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVolSaldo.DtoVolP[9] AT ROW 10.69 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 104
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     VtaDctoVolSaldo.DtoVolR[10] AT ROW 11.5 COL 2 COLON-ALIGNED NO-LABEL WIDGET-ID 2 FORMAT ">>>,>>>,>>9"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     VtaDctoVolSaldo.DtoVolD[10] AT ROW 11.5 COL 20 COLON-ALIGNED NO-LABEL WIDGET-ID 60
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
     VtaDctoVolSaldo.DtoVolP[10] AT ROW 11.5 COL 34 COLON-ALIGNED NO-LABEL WIDGET-ID 86
          VIEW-AS FILL-IN 
          SIZE 13.57 BY .81
     "Cantidad Mínima" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 3.12 COL 3 WIDGET-ID 52
     "Descuento %" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 3.12 COL 23 WIDGET-ID 54
     "Precio" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.15 COL 38 WIDGET-ID 84
     "DESCUENTO X VOLUMEN X SALDO" VIEW-AS TEXT
          SIZE 27 BY .5 AT ROW 1.19 COL 6 WIDGET-ID 80
          BGCOLOR 1 FGCOLOR 15 
     RECT-14 AT ROW 2.92 COL 1 WIDGET-ID 56
     RECT-15 AT ROW 3.88 COL 1 WIDGET-ID 58
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.VtaDctoVolSaldo
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-FacTabla B "?" ? INTEGRAL FacTabla
   END-TABLES.
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
         HEIGHT             = 16.73
         WIDTH              = 65.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN VtaDctoVolSaldo.DtoVolR[10] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaDctoVolSaldo.DtoVolR[1] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaDctoVolSaldo.DtoVolR[2] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaDctoVolSaldo.DtoVolR[3] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaDctoVolSaldo.DtoVolR[4] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaDctoVolSaldo.DtoVolR[5] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaDctoVolSaldo.DtoVolR[6] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaDctoVolSaldo.DtoVolR[7] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaDctoVolSaldo.DtoVolR[8] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN VtaDctoVolSaldo.DtoVolR[9] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN FILL-IN-PrecioBase IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaDctoVolSaldo.Unidad IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       VtaDctoVolSaldo.Unidad:HIDDEN IN FRAME F-Main           = TRUE.

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

&Scoped-define SELF-NAME VtaDctoVolSaldo.Unidad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaDctoVolSaldo.Unidad V-table-Win
ON LEAVE OF VtaDctoVolSaldo.Unidad IN FRAME F-Main /* Unidad de Medida */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
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

ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolD[1] DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVolSaldo.DtoVolP[1]
        WITH FRAME {&FRAME-NAME}.
END.
ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolD[2] DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVolSaldo.DtoVolP[2]
        WITH FRAME {&FRAME-NAME}.
END.
ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolD[3] DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVolSaldo.DtoVolP[3]
        WITH FRAME {&FRAME-NAME}.
END.
ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolD[4] DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVolSaldo.DtoVolP[4]
        WITH FRAME {&FRAME-NAME}.
END.
ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolD[5] DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVolSaldo.DtoVolP[5]
        WITH FRAME {&FRAME-NAME}.
END.
ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolD[6] DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVolSaldo.DtoVolP[6]
        WITH FRAME {&FRAME-NAME}.
END.
ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolD[7] DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVolSaldo.DtoVolP[7]
        WITH FRAME {&FRAME-NAME}.
END.
ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolD[8] DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVolSaldo.DtoVolP[8]
        WITH FRAME {&FRAME-NAME}.
END.
ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolD[9] DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVolSaldo.DtoVolP[9]
        WITH FRAME {&FRAME-NAME}.
END.
ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolD[10] DO:
    DISPLAY ROUND(FILL-IN-PrecioBase * ( 1 - ( DECI(SELF:SCREEN-VALUE) / 100 ) ), 4) @ VtaDctoVolSaldo.DtoVolP[10]
        WITH FRAME {&FRAME-NAME}.
END.

ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolP[1] DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVolSaldo.DtoVolD[1]
        WITH FRAME {&FRAME-NAME}.
END.
ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolP[2] DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVolSaldo.DtoVolD[2]
        WITH FRAME {&FRAME-NAME}.
END.
ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolP[3] DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVolSaldo.DtoVolD[3]
        WITH FRAME {&FRAME-NAME}.
END.
ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolP[4] DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVolSaldo.DtoVolD[4]
        WITH FRAME {&FRAME-NAME}.
END.
ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolP[5] DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVolSaldo.DtoVolD[5]
        WITH FRAME {&FRAME-NAME}.
END.
ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolP[6] DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVolSaldo.DtoVolD[6]
        WITH FRAME {&FRAME-NAME}.
END.
ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolP[7] DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVolSaldo.DtoVolD[7]
        WITH FRAME {&FRAME-NAME}.
END.
ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolP[8] DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVolSaldo.DtoVolD[8]
        WITH FRAME {&FRAME-NAME}.
END.
ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolP[9] DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVolSaldo.DtoVolD[9]
        WITH FRAME {&FRAME-NAME}.
END.
ON 'LEAVE':U OF VtaDctoVolSaldo.DtoVolP[10] DO:
    DISPLAY ROUND((1 - (DECIMAL(SELF:SCREEN-VALUE) / FILL-IN-PrecioBase)) * 100, 6) @ VtaDctoVolSaldo.DtoVolD[10]
        WITH FRAME {&FRAME-NAME}.
END.

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
  {src/adm/template/row-list.i "VtaDctoVolSaldo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaDctoVolSaldo"}

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
  IF AVAILABLE VtaListaMay AND AVAILABLE Almmmatg THEN DO WITH FRAME {&FRAME-NAME}:
      /* TODO EN SOLES */
      FILL-IN-PrecioBase = VtaListaMay.PreOfi.
      IF Almmmatg.MonVta = 2 THEN FILL-IN-PrecioBase = FILL-IN-PrecioBase * Almmmatg.TpoCmb.
      DISPLAY FILL-IN-PrecioBase.
  END.
  RUN Procesa-Handle IN lh_handle ('Enable-Header').
  RUN Procesa-Handle IN lh_handle ('Enable-Detail').

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
  IF NOT AVAILABLE VtaDctoVolSaldo THEN RETURN.

  /* Buscamos Producto relacionado de acuerdo a la división actual */
  DEF VAR x-TpoCmb AS DEC NO-UNDO.
  DEF VAR x-MonVta AS INT NO-UNDO.
  DEF VAR x-UndVta AS CHAR NO-UNDO.
  
  DEF VAR hProc AS HANDLE NO-UNDO.

  RUN pri/pri-librerias PERSISTENT SET hProc.

  RUN PRI_PrecioBase-DctoVolSaldo IN hProc (INPUT s-Tabla-1,
                                            INPUT VtaDctoVolSaldo.Codigo,
                                            INPUT VtaDctoVolSaldo.coddiv,
                                            OUTPUT FILL-IN-PrecioBase,
                                            OUTPUT x-TpoCmb,
                                            OUTPUT x-MonVta,
                                            OUTPUT x-UndVta).
  DELETE PROCEDURE hProc.


/*                                                                                        */
/*     FILL-IN-PrecioBase = 0.                                                            */
/*     x-TpoCmb = 0.                                                                      */
/*     x-MonVta = 1.                                                                      */
/*     FIND gn-divi WHERE gn-divi.codcia = s-codcia AND                                   */
/*         gn-divi.coddiv = VtaDctoVolSaldo.CodDiv NO-LOCK.                               */
/*     CASE TRUE:                                                                         */
/*         WHEN gn-divi.CanalVenta = "FER" AND GN-DIVI.VentaMayorista = 2 THEN DO:        */
/*             /* EVENTOS */                                                              */
/*             FIND FIRST B-FacTabla WHERE B-FacTabla.CodCia = s-codcia AND               */
/*                 B-FacTabla.Tabla = s-Tabla-1 AND                                       */
/*                 B-FacTabla.Codigo BEGINS VtaDctoVolSaldo.Codigo AND                    */
/*                 CAN-FIND(FIRST VtaListaMay WHERE VtaListaMay.CodCia = s-codcia AND     */
/*                          VtaListaMay.CodDiv = VtaDctoVolSaldo.coddiv AND               */
/*                          VtaListaMay.codmat = ENTRY(2,B-FacTabla.Codigo,'|')           */
/*                          NO-LOCK)                                                      */
/*                 NO-LOCK NO-ERROR.                                                      */
/*             IF AVAILABLE B-FacTabla THEN DO:                                           */
/*                 FIND FIRST VtaListaMay WHERE VtaListaMay.CodCia = s-codcia AND         */
/*                     VtaListaMay.CodDiv = VtaDctoVolSaldo.coddiv AND                    */
/*                     VtaListaMay.codmat = ENTRY(2,B-FacTabla.Codigo,'|')                */
/*                     NO-LOCK.                                                           */
/*                 FILL-IN-PrecioBase = VtaListaMay.PreOfi.                               */
/*                 FIND FIRST Almmmatg OF VtaListaMay NO-LOCK.                            */
/*                 x-TpoCmb = Almmmatg.TpoCmb.                                            */
/*                 x-MonVta = Almmmatg.MonVta.                                            */
/*             END.                                                                       */
/*         END.                                                                           */
/*         WHEN gn-divi.CanalVenta = "MIN" AND GN-DIVI.VentaMayorista = 1 THEN DO:        */
/*             /* UTILEX */                                                               */
/*             FIND FIRST B-FacTabla WHERE B-FacTabla.CodCia = s-codcia AND               */
/*                 B-FacTabla.Tabla = s-Tabla-1 AND                                       */
/*                 B-FacTabla.Codigo BEGINS VtaDctoVolSaldo.Codigo AND                    */
/*                 CAN-FIND(FIRST VtaListaMinGn WHERE VtaListaMinGn.CodCia = s-codcia AND */
/*                          VtaListaMinGn.codmat = ENTRY(2,B-FacTabla.Codigo,'|')         */
/*                          NO-LOCK)                                                      */
/*                 NO-LOCK NO-ERROR.                                                      */
/*             IF AVAILABLE B-FacTabla THEN DO:                                           */
/*                 FIND FIRST VtaListaMinGn WHERE VtaListaMinGn.CodCia = s-codcia AND     */
/*                     VtaListaMinGn.codmat = ENTRY(2,B-FacTabla.Codigo,'|')              */
/*                     NO-LOCK.                                                           */
/*                 FILL-IN-PrecioBase = VtaListaMinGn.PreOfi.                             */
/*                 FIND FIRST Almmmatg OF VtaListaMinGn NO-LOCK.                          */
/*                 x-TpoCmb = Almmmatg.TpoCmb.                                            */
/*                 x-MonVta = Almmmatg.MonVta.                                            */
/*             END.                                                                       */
/*         END.                                                                           */
/*         WHEN GN-DIVI.VentaMayorista = 1 THEN DO:                                       */
/*             /* LISTA GENERAL LIMA */                                                   */
/*             FIND FIRST B-FacTabla WHERE B-FacTabla.CodCia = s-codcia AND               */
/*                 B-FacTabla.Tabla = s-Tabla-1 AND                                       */
/*                 B-FacTabla.Codigo BEGINS VtaDctoVolSaldo.Codigo AND                    */
/*                 CAN-FIND(FIRST Almmmatg WHERE Almmmatg.CodCia = s-codcia AND           */
/*                          Almmmatg.codmat = ENTRY(2,B-FacTabla.Codigo,'|') AND          */
/*                          Almmmatg.preofi > 0 NO-LOCK)                                  */
/*                 NO-LOCK NO-ERROR.                                                      */
/*             IF AVAILABLE B-FacTabla THEN DO:                                           */
/*                 FIND FIRST Almmmatg WHERE Almmmatg.CodCia = s-codcia AND               */
/*                     Almmmatg.codmat = ENTRY(2,B-FacTabla.Codigo,'|')                   */
/*                     NO-LOCK.                                                           */
/*                 FILL-IN-PrecioBase = Almmmatg.PreOfi.                                  */
/*                 x-TpoCmb = Almmmatg.TpoCmb.                                            */
/*                 x-MonVta = Almmmatg.MonVta.                                            */
/*             END.                                                                       */
/*         END.                                                                           */
/*         WHEN GN-DIVI.VentaMayorista = 2 THEN DO:                                       */
/*             /* LISTA POR DIVISION */                                                   */
/*             FIND FIRST B-FacTabla WHERE B-FacTabla.CodCia = s-codcia AND               */
/*                 B-FacTabla.Tabla = s-Tabla-1 AND                                       */
/*                 B-FacTabla.Codigo BEGINS VtaDctoVolSaldo.Codigo AND                    */
/*                 CAN-FIND(FIRST VtaListaMay WHERE VtaListaMay.CodCia = s-codcia AND     */
/*                          VtaListaMay.CodDiv = VtaDctoVolSaldo.coddiv AND               */
/*                          VtaListaMay.codmat = ENTRY(2,B-FacTabla.Codigo,'|')           */
/*                          NO-LOCK)                                                      */
/*                 NO-LOCK NO-ERROR.                                                      */
/*             IF AVAILABLE B-FacTabla THEN DO:                                           */
/*                 FIND FIRST VtaListaMay WHERE VtaListaMay.CodCia = s-codcia AND         */
/*                     VtaListaMay.CodDiv = VtaDctoVolSaldo.coddiv AND                    */
/*                     VtaListaMay.codmat = ENTRY(2,B-FacTabla.Codigo,'|')                */
/*                     NO-LOCK.                                                           */
/*                 FILL-IN-PrecioBase = VtaListaMay.PreOfi.                               */
/*                 FIND FIRST Almmmatg OF VtaListaMay NO-LOCK.                            */
/*               x-TpoCmb = Almmmatg.TpoCmb.                                              */
/*               x-MonVta = Almmmatg.MonVta.                                              */
/*           END.                                                                         */
/*       END.                                                                             */
/*   END CASE.                                                                            */


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* TODO EN SOLES */
  IF x-MonVta = 2 THEN FILL-IN-PrecioBase = FILL-IN-PrecioBase * x-TpoCmb.
  DISPLAY FILL-IN-PrecioBase WITH FRAME {&FRAME-NAME}.

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
  RUN Procesa-Handle IN lh_handle ('Disable-Detail').

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
  {src/adm/template/snd-list.i "VtaDctoVolSaldo"}

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

DO WITH FRAME {&FRAME-NAME} :
/*     IF NOT CAN-FIND(FIRST Unidades WHERE Unidades.Codunid = VtaDctoVolSaldo.Unidad:SCREEN-VALUE NO-LOCK) */
/*         THEN DO:                                                                                         */
/*         MESSAGE 'Unidad de medida NO registrada' VIEW-AS ALERT-BOX ERROR.                                */
/*         APPLY 'ENTRY':U TO VtaDctoVolSaldo.Unidad.                                                       */
/*         RETURN 'ADM-ERROR'.                                                                              */
/*     END.                                                                                                 */
    DO x-Orden = 1 TO 10:
        IF INPUT VtaDctoVolSaldo.DtoVolR[x-Orden] <= 0 THEN NEXT.
        IF x-ValorAnterior = 0 THEN x-ValorAnterior = VtaDctoVolSaldo.DtoVolR[x-Orden].
        IF INPUT VtaDctoVolSaldo.DtoVolR[x-Orden] < x-ValorANterior THEN DO:
            MESSAGE 'Cantidad mínima mal registrada' VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
        x-ValorAnterior = INPUT VtaDctoVolSaldo.DtoVolR[x-Orden].
    END.
END.

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

IF NOT AVAILABLE VtaDctoVolSaldo THEN RETURN 'ADM-ERROR'.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

