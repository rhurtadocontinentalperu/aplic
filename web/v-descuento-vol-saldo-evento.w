&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-Tabla FOR FacTabla.



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

DEFINE SHARED VARIABLE s-codcia AS INT.
DEFINE SHARED VARIABLE s-Tabla  AS CHARACTER.
DEFINE SHARED VARIABLE s-Tabla-1 AS CHARACTER.
DEFINE SHARED VARIABLE S-CODDIV AS CHAR.
DEFINE SHARED VARIABLE lh_handle AS HANDLE.

DEFINE VARIABLE x-PreUni AS DECIMAL NO-UNDO.
DEFINE VARIABLE x-PorDto AS DECIMAL NO-UNDO.

DEF VAR x-Unidad AS CHAR NO-UNDO.
DEF VAR x-Precio AS DEC  NO-UNDO.
DEF VAR x-CodDiv AS CHAR NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES FacTabla
&Scoped-define FIRST-EXTERNAL-TABLE FacTabla


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacTabla.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS FacTabla.Campo-C[1] FacTabla.Valor[1] ~
FacTabla.Valor[11] FacTabla.Valor[2] FacTabla.Valor[12] FacTabla.Valor[3] ~
FacTabla.Valor[13] FacTabla.Valor[4] FacTabla.Valor[14] FacTabla.Valor[5] ~
FacTabla.Valor[15] FacTabla.Valor[6] FacTabla.Valor[16] FacTabla.Valor[7] ~
FacTabla.Valor[17] FacTabla.Valor[8] FacTabla.Valor[18] FacTabla.Valor[9] ~
FacTabla.Valor[19] FacTabla.Valor[10] FacTabla.Valor[20] 
&Scoped-define ENABLED-TABLES FacTabla
&Scoped-define FIRST-ENABLED-TABLE FacTabla
&Scoped-Define ENABLED-OBJECTS RECT-14 RECT-15 
&Scoped-Define DISPLAYED-FIELDS FacTabla.Campo-C[1] FacTabla.Valor[1] ~
FacTabla.Valor[11] FacTabla.Valor[2] FacTabla.Valor[12] FacTabla.Valor[3] ~
FacTabla.Valor[13] FacTabla.Valor[4] FacTabla.Valor[14] FacTabla.Valor[5] ~
FacTabla.Valor[15] FacTabla.Valor[6] FacTabla.Valor[16] FacTabla.Valor[7] ~
FacTabla.Valor[17] FacTabla.Valor[8] FacTabla.Valor[18] FacTabla.Valor[9] ~
FacTabla.Valor[19] FacTabla.Valor[10] FacTabla.Valor[20] 
&Scoped-define DISPLAYED-TABLES FacTabla
&Scoped-define FIRST-DISPLAYED-TABLE FacTabla


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
DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY .96.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 8.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacTabla.Campo-C[1] AT ROW 1.96 COL 16 COLON-ALIGNED WIDGET-ID 64
          LABEL "Unidad de Medida" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     FacTabla.Valor[1] AT ROW 4.23 COL 3 NO-LABEL WIDGET-ID 32 FORMAT "->>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     FacTabla.Valor[11] AT ROW 4.23 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacTabla.Valor[2] AT ROW 5.04 COL 3 NO-LABEL WIDGET-ID 36 FORMAT ">>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     FacTabla.Valor[12] AT ROW 5.04 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacTabla.Valor[3] AT ROW 5.85 COL 3 NO-LABEL WIDGET-ID 38 FORMAT ">>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     FacTabla.Valor[13] AT ROW 5.85 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacTabla.Valor[4] AT ROW 6.65 COL 3 NO-LABEL WIDGET-ID 40 FORMAT ">>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     FacTabla.Valor[14] AT ROW 6.65 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacTabla.Valor[5] AT ROW 7.46 COL 3 NO-LABEL WIDGET-ID 42 FORMAT ">>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     FacTabla.Valor[15] AT ROW 7.46 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacTabla.Valor[6] AT ROW 8.27 COL 3 NO-LABEL WIDGET-ID 44 FORMAT ">>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     FacTabla.Valor[16] AT ROW 8.27 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacTabla.Valor[7] AT ROW 9.08 COL 3 NO-LABEL WIDGET-ID 46 FORMAT ">>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     FacTabla.Valor[17] AT ROW 9.08 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacTabla.Valor[8] AT ROW 9.88 COL 3 NO-LABEL WIDGET-ID 48 FORMAT ">>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     FacTabla.Valor[18] AT ROW 9.88 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacTabla.Valor[9] AT ROW 10.69 COL 3 NO-LABEL WIDGET-ID 50 FORMAT ">>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     FacTabla.Valor[19] AT ROW 10.69 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     FacTabla.Valor[10] AT ROW 11.5 COL 3 NO-LABEL WIDGET-ID 12 FORMAT ">>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     FacTabla.Valor[20] AT ROW 11.5 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     "DESCUENTO X VOLUMEN" VIEW-AS TEXT
          SIZE 20 BY .5 AT ROW 1.19 COL 6 WIDGET-ID 60
          BGCOLOR 1 FGCOLOR 15 
     "Descuento %" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 3.15 COL 32 WIDGET-ID 54
     "Cantidad Mínima" VIEW-AS TEXT
          SIZE 13 BY .5 AT ROW 3.12 COL 3 WIDGET-ID 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
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
   External Tables: INTEGRAL.FacTabla
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-Tabla B "?" ? INTEGRAL FacTabla
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
         HEIGHT             = 11.96
         WIDTH              = 44.86.
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

/* SETTINGS FOR FILL-IN FacTabla.Campo-C[1] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacTabla.Valor[10] IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN FacTabla.Valor[1] IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN FacTabla.Valor[2] IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN FacTabla.Valor[3] IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN FacTabla.Valor[4] IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN FacTabla.Valor[5] IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN FacTabla.Valor[6] IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN FacTabla.Valor[7] IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN FacTabla.Valor[8] IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN FacTabla.Valor[9] IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
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

&Scoped-define SELF-NAME FacTabla.Valor[11]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacTabla.Valor[11] V-table-Win
ON LEAVE OF FacTabla.Valor[11] IN FRAME F-Main /* Valor */
DO:
/*     x-PorDto = DECIMAL(FacTabla.Valor[11]:SCREEN-VALUE).                       */
/*     FILL-IN-PreUni-1:SCREEN-VALUE = STRING(x-Precio * (1 - (x-PorDto / 100))). */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacTabla.Valor[12]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacTabla.Valor[12] V-table-Win
ON LEAVE OF FacTabla.Valor[12] IN FRAME F-Main /* Valor */
DO:
/*     x-PorDto = DECIMAL(FacTabla.Valor[12]:SCREEN-VALUE).                       */
/*     FILL-IN-PreUni-2:SCREEN-VALUE = STRING(x-Precio * (1 - (x-PorDto / 100))). */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacTabla.Valor[13]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacTabla.Valor[13] V-table-Win
ON LEAVE OF FacTabla.Valor[13] IN FRAME F-Main /* Valor */
DO:
/*     x-PorDto = DECIMAL(FacTabla.Valor[13]:SCREEN-VALUE).                       */
/*     FILL-IN-PreUni-3:SCREEN-VALUE = STRING(x-Precio * (1 - (x-PorDto / 100))). */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacTabla.Valor[14]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacTabla.Valor[14] V-table-Win
ON LEAVE OF FacTabla.Valor[14] IN FRAME F-Main /* Valor */
DO:
/*     x-PorDto = DECIMAL(FacTabla.Valor[14]:SCREEN-VALUE).                       */
/*     FILL-IN-PreUni-4:SCREEN-VALUE = STRING(x-Precio * (1 - (x-PorDto / 100))). */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacTabla.Valor[15]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacTabla.Valor[15] V-table-Win
ON LEAVE OF FacTabla.Valor[15] IN FRAME F-Main /* Valor */
DO:
/*     x-PorDto = DECIMAL(FacTabla.Valor[15]:SCREEN-VALUE).                       */
/*     FILL-IN-PreUni-5:SCREEN-VALUE = STRING(x-Precio * (1 - (x-PorDto / 100))). */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacTabla.Valor[16]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacTabla.Valor[16] V-table-Win
ON LEAVE OF FacTabla.Valor[16] IN FRAME F-Main /* Valor */
DO:
/*     x-PorDto = DECIMAL(FacTabla.Valor[16]:SCREEN-VALUE).                       */
/*     FILL-IN-PreUni-6:SCREEN-VALUE = STRING(x-Precio * (1 - (x-PorDto / 100))). */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacTabla.Valor[17]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacTabla.Valor[17] V-table-Win
ON LEAVE OF FacTabla.Valor[17] IN FRAME F-Main /* Valor */
DO:
/*     x-PorDto = DECIMAL(FacTabla.Valor[17]:SCREEN-VALUE).                       */
/*     FILL-IN-PreUni-7:SCREEN-VALUE = STRING(x-Precio * (1 - (x-PorDto / 100))). */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacTabla.Valor[18]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacTabla.Valor[18] V-table-Win
ON LEAVE OF FacTabla.Valor[18] IN FRAME F-Main /* Valor */
DO:
/*     x-PorDto = DECIMAL(FacTabla.Valor[18]:SCREEN-VALUE).                       */
/*     FILL-IN-PreUni-8:SCREEN-VALUE = STRING(x-Precio * (1 - (x-PorDto / 100))). */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacTabla.Valor[19]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacTabla.Valor[19] V-table-Win
ON LEAVE OF FacTabla.Valor[19] IN FRAME F-Main /* Valor */
DO:
/*     x-PorDto = DECIMAL(FacTabla.Valor[19]:SCREEN-VALUE).                       */
/*     FILL-IN-PreUni-9:SCREEN-VALUE = STRING(x-Precio * (1 - (x-PorDto / 100))). */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacTabla.Valor[20]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacTabla.Valor[20] V-table-Win
ON LEAVE OF FacTabla.Valor[20] IN FRAME F-Main /* Valor */
DO:
/*     x-PorDto = DECIMAL(FacTabla.Valor[20]:SCREEN-VALUE).                        */
/*     FILL-IN-PreUni-10:SCREEN-VALUE = STRING(x-Precio * (1 - (x-PorDto / 100))). */
  
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
  {src/adm/template/row-list.i "FacTabla"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacTabla"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ("Enable-Others-2").

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
  DO WITH FRAME {&FRAME-NAME}:
/*       DISABLE FILL-IN-PreUni-1 FILL-IN-PreUni-10 FILL-IN-PreUni-2             */
/*           FILL-IN-PreUni-3 FILL-IN-PreUni-4 FILL-IN-PreUni-5 FILL-IN-PreUni-6 */
/*           FILL-IN-PreUni-7 FILL-IN-PreUni-8 FILL-IN-PreUni-9.                 */
  END.

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
  IF NOT AVAILABLE FacTabla THEN RETURN.
  DEF VAR x-CodDiv AS CHAR NO-UNDO.
  ASSIGN
    x-CodDiv = ENTRY(1,FacTabla.Codigo,'|').
  DEF VAR x-PreUni AS DEC NO-UNDO.
/*   IF AVAILABLE FacTabla THEN DO WITH FRAME {&FRAME-NAME}:                              */
/*       ASSIGN                                                                           */
/*           FILL-IN-PreUni-1  = 0                                                        */
/*           FILL-IN-PreUni-10 = 0                                                        */
/*           FILL-IN-PreUni-2  = 0                                                        */
/*           FILL-IN-PreUni-3  = 0                                                        */
/*           FILL-IN-PreUni-4  = 0                                                        */
/*           FILL-IN-PreUni-5  = 0                                                        */
/*           FILL-IN-PreUni-6  = 0                                                        */
/*           FILL-IN-PreUni-7  = 0                                                        */
/*           FILL-IN-PreUni-8  = 0                                                        */
/*           FILL-IN-PreUni-9  = 0.                                                       */
/*       FOR EACH B-Tabla WHERE B-Tabla.CodCia = FacTabla.CodCia AND                      */
/*           B-Tabla.Tabla = s-Tabla-1 AND                                                */
/*           B-Tabla.Codigo BEGINS FacTabla.Codigo NO-LOCK,                               */
/*           FIRST Almmmatg WHERE Almmmatg.CodCia = B-Tabla.CodCia                        */
/*           AND Almmmatg.codmat = B-Tabla.Campo-C[1] NO-LOCK:                            */
/*           FIND VtaListaMay WHERE VtaListaMay.CodCia = s-CodCia AND                     */
/*               VtaListaMay.CodDiv = x-CodDiv AND                                        */
/*               VtaListaMay.codmat = B-Tabla.Campo-C[1]                                  */
/*               NO-LOCK NO-ERROR.                                                        */
/*           IF NOT AVAILABLE VtaListaMay THEN NEXT.                                      */
/*           IF VtaListaMay.PreOfi = 0 THEN NEXT.                                         */
/*           x-PreUni = VtaListaMay.PreOfi.                                               */
/*           IF Almmmatg.MonVta = 2 THEN x-PreUni = VtaListaMay.PreOfi * Almmmatg.TpoCmb. */
/*           LEAVE.                                                                       */
/*       END.                                                                             */
/*       ASSIGN                                                                           */
/*           FILL-IN-PreUni-1  = x-PreUni * (1 - FacTabla.Valor[11] / 100)                */
/*           FILL-IN-PreUni-2  = x-PreUni * (1 - FacTabla.Valor[12] / 100)                */
/*           FILL-IN-PreUni-3  = x-PreUni * (1 - FacTabla.Valor[13] / 100)                */
/*           FILL-IN-PreUni-4  = x-PreUni * (1 - FacTabla.Valor[14] / 100)                */
/*           FILL-IN-PreUni-5  = x-PreUni * (1 - FacTabla.Valor[15] / 100)                */
/*           FILL-IN-PreUni-6  = x-PreUni * (1 - FacTabla.Valor[16] / 100)                */
/*           FILL-IN-PreUni-7  = x-PreUni * (1 - FacTabla.Valor[17] / 100)                */
/*           FILL-IN-PreUni-8  = x-PreUni * (1 - FacTabla.Valor[18] / 100)                */
/*           FILL-IN-PreUni-9  = x-PreUni * (1 - FacTabla.Valor[19] / 100)                */
/*           FILL-IN-PreUni-10 = x-PreUni * (1 - FacTabla.Valor[20] / 100)                */
/*           .                                                                            */
/*       IF FacTabla.Valor[11] = 0 THEN FILL-IN-PreUni-1  = 0.                            */
/*       IF FacTabla.Valor[12] = 0 THEN FILL-IN-PreUni-2  = 0.                            */
/*       IF FacTabla.Valor[13] = 0 THEN FILL-IN-PreUni-3  = 0.                            */
/*       IF FacTabla.Valor[14] = 0 THEN FILL-IN-PreUni-4  = 0.                            */
/*       IF FacTabla.Valor[15] = 0 THEN FILL-IN-PreUni-5  = 0.                            */
/*       IF FacTabla.Valor[16] = 0 THEN FILL-IN-PreUni-6  = 0.                            */
/*       IF FacTabla.Valor[17] = 0 THEN FILL-IN-PreUni-7  = 0.                            */
/*       IF FacTabla.Valor[18] = 0 THEN FILL-IN-PreUni-8  = 0.                            */
/*       IF FacTabla.Valor[19] = 0 THEN FILL-IN-PreUni-9  = 0.                            */
/*       IF FacTabla.Valor[20] = 0 THEN FILL-IN-PreUni-10 = 0.                            */
/*       DISPLAY FILL-IN-PreUni-1 FILL-IN-PreUni-10 FILL-IN-PreUni-2                      */
/*           FILL-IN-PreUni-3 FILL-IN-PreUni-4 FILL-IN-PreUni-5                           */
/*           FILL-IN-PreUni-6 FILL-IN-PreUni-7 FILL-IN-PreUni-8                           */
/*           FILL-IN-PreUni-9.                                                            */
/*   END.                                                                                 */
  
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
  DO WITH FRAME {&FRAME-NAME}:
/*       ENABLE FILL-IN-PreUni-1 FILL-IN-PreUni-10 FILL-IN-PreUni-2              */
/*           FILL-IN-PreUni-3 FILL-IN-PreUni-4 FILL-IN-PreUni-5 FILL-IN-PreUni-6 */
/*           FILL-IN-PreUni-7 FILL-IN-PreUni-8 FILL-IN-PreUni-9.                 */
  END.

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
  RUN Procesa-Handle IN lh_handle ("Enable-Others-2").

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
  {src/adm/template/snd-list.i "FacTabla"}

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

DEF VAR x-CodDiv AS CHAR NO-UNDO.

x-CodDiv = ENTRY(1,FacTabla.Codigo,'|').

DO WITH FRAME {&FRAME-NAME} :
    IF NOT CAN-FIND(FIRST Unidades WHERE Unidades.Codunid = FacTabla.Campo-C[1]:SCREEN-VALUE NO-LOCK)
        THEN DO:
        MESSAGE 'Unidad de medida NO registrada' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO FacTabla.Campo-C[1].
        RETURN 'ADM-ERROR'.
    END.
    FOR EACH B-Tabla WHERE B-Tabla.CodCia = FacTabla.CodCia AND
        B-Tabla.Tabla = s-Tabla-1 AND 
        B-Tabla.Codigo BEGINS FacTabla.Codigo NO-LOCK,
        FIRST Almmmatg WHERE Almmmatg.CodCia = B-Tabla.CodCia
        AND Almmmatg.codmat = B-Tabla.Campo-C[1] NO-LOCK:
        IF FacTabla.Campo-C[1]:SCREEN-VALUE <> Almmmatg.Chr__01 THEN DO:
            MESSAGE 'ERROR: Las unidades de los artículos no son iguales'
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO FacTabla.Campo-C[1].
            RETURN 'ADM-ERROR'.
        END.
    END.
    /* ****************************************************************************************************** */
    /* Control Margen de Utilidad */
    /* Se van a barrer todos los productos relacionados */
    /* ****************************************************************************************************** */
    /* 05/12/2022: Control de Margen */
    RUN Valida-Margen.
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
END.
/* ****************************************************************************************************** */

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida-Margen V-table-Win 
PROCEDURE Valida-Margen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR x-Orden AS INT NO-UNDO.
DEF VAR x-Margen AS DECI NO-UNDO.
DEF VAR x-Limite AS DECI NO-UNDO.
DEF VAR pError AS CHAR NO-UNDO.

DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE BUFFER LocalBufferMatg FOR Almmmatg.

RUN pri/pri-librerias PERSISTENT SET hProc.

SESSION:SET-WAIT-STATE('GENERAL').
RUN GET-ATTRIBUTE('ADM-NEW-RECORD').

CASE RETURN-VALUE:
    WHEN "YES" THEN DO WITH FRAME {&FRAME-NAME}:
        FOR EACH B-Tabla WHERE B-Tabla.CodCia = FacTabla.CodCia AND
            B-Tabla.Tabla = s-Tabla-1 AND 
            B-Tabla.Codigo BEGINS FacTabla.Codigo NO-LOCK,
            FIRST LocalBufferMatg WHERE LocalBufferMatg.CodCia = B-Tabla.CodCia
            AND LocalBufferMatg.codmat = B-Tabla.Campo-C[1] NO-LOCK:
            DO x-Orden = 11 TO 20:
                x-PorDto =  INPUT FacTabla.Valor[x-Orden].
                IF x-PorDto > 0 THEN DO:
                    RUN PRI_Margen-Utilidad-Listas IN hProc (INPUT ENTRY(1,FacTabla.Codigo,'|'),
                                                             INPUT LocalBufferMatg.CodMat,
                                                             INPUT LocalBufferMatg.CHR__01,
                                                             INPUT x-PorDto,
                                                             INPUT 1,
                                                             OUTPUT x-Margen,
                                                             OUTPUT x-Limite,
                                                             OUTPUT pError).
                    IF RETURN-VALUE = 'ADM-ERROR' OR pError > '' THEN DO:
                        MESSAGE pError VIEW-AS ALERT-BOX ERROR.
                        RETURN 'ADM-ERROR'.
                    END.
                END.
            END.
        END.
    END.
    WHEN "NO" THEN DO WITH FRAME {&FRAME-NAME}:
        FOR EACH B-Tabla WHERE B-Tabla.CodCia = FacTabla.CodCia AND
            B-Tabla.Tabla = s-Tabla-1 AND 
            B-Tabla.Codigo BEGINS FacTabla.Codigo NO-LOCK,
            FIRST LocalBufferMatg WHERE LocalBufferMatg.CodCia = B-Tabla.CodCia
            AND LocalBufferMatg.codmat = B-Tabla.Campo-C[1] NO-LOCK:
            DO x-Orden = 11 TO 20:
                x-PorDto =  INPUT FacTabla.Valor[x-Orden].
                IF x-PorDto > 0 AND x-PorDto <> FacTabla.Valor[x-Orden] THEN DO:
                    RUN PRI_Margen-Utilidad-Listas IN hProc (INPUT ENTRY(1,FacTabla.Codigo,'|'),
                                                             INPUT LocalBufferMatg.CodMat,
                                                             INPUT LocalBufferMatg.CHR__01,
                                                             INPUT x-PorDto,
                                                             INPUT 1,
                                                             OUTPUT x-Margen,
                                                             OUTPUT x-Limite,
                                                             OUTPUT pError).
                    IF RETURN-VALUE = 'ADM-ERROR' OR pError > '' THEN DO:
                        MESSAGE pError VIEW-AS ALERT-BOX ERROR.
                        RETURN 'ADM-ERROR'.
                    END.
                END.
            END.
        END.
    END.
END CASE.

SESSION:SET-WAIT-STATE('').
DELETE PROCEDURE hProc.

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

/* RHC 27/12/2018 Verificar UNIDADES y PRECIOS */
/* ASSIGN                                                                                                     */
/*     x-CodDiv = ENTRY(1,FacTabla.Codigo,'|')                                                                */
/*     x-Unidad = ''                                                                                          */
/*     x-Precio = 0.                                                                                          */
/* FOR EACH B-Tabla WHERE B-Tabla.CodCia = FacTabla.CodCia AND                                                */
/*     B-Tabla.Tabla = s-Tabla-1 AND                                                                          */
/*     B-Tabla.Codigo BEGINS FacTabla.Codigo NO-LOCK,                                                         */
/*     FIRST Almmmatg WHERE Almmmatg.CodCia = B-Tabla.CodCia                                                  */
/*     AND Almmmatg.codmat = B-Tabla.Campo-C[1] NO-LOCK:                                                      */
/*     FIND VtaListaMay WHERE VtaListaMay.CodCia = s-CodCia AND                                               */
/*         VtaListaMay.CodDiv = x-CodDiv AND                                                                  */
/*         VtaListaMay.codmat = B-Tabla.Campo-C[1]                                                            */
/*         NO-LOCK NO-ERROR.                                                                                  */
/*     IF NOT AVAILABLE VtaListaMay THEN DO:                                                                  */
/*         MESSAGE 'ERROR: No se encontró el artículo' B-Tabla.Campo-C[1] 'registrado en la lista de precios' */
/*             VIEW-AS ALERT-BOX ERROR.                                                                       */
/*         RETURN 'ADM-ERROR'.                                                                                */
/*     END.                                                                                                   */
/*     IF VtaListaMay.PreOfi = 0 THEN DO:                                                                     */
/*         MESSAGE 'ERROR: Artículo' VtaListaMay.codmat 'NO tiene precio de venta'                            */
/*             VIEW-AS ALERT-BOX ERROR.                                                                       */
/*         RETURN 'ADM-ERROR'.                                                                                */
/*     END.                                                                                                   */
/*     IF x-Unidad > '' AND (x-Unidad <> VtaListaMay.Chr__01) THEN DO:                                        */
/*         MESSAGE 'ERROR: Las unidades de los artículos no son iguales'                                      */
/*             VIEW-AS ALERT-BOX ERROR.                                                                       */
/*         RETURN 'ADM-ERROR'.                                                                                */
/*     END.                                                                                                   */
/*     x-Unidad = VtaListaMay.Chr__01.                                                                        */
/*     IF x-Precio > 0 AND (x-Precio <> VtaListaMay.PreOfi) THEN DO:                                          */
/*         MESSAGE 'ERROR: los artículos no tienen el mismo precio'                                           */
/*             VIEW-AS ALERT-BOX ERROR.                                                                       */
/*         RETURN 'ADM-ERROR'.                                                                                */
/*     END.                                                                                                   */
/*     x-Precio = VtaListaMay.PreOfi.                                                                         */
/* END.                                                                                                       */

RUN Procesa-Handle IN lh_handle ("Disable-Others-2").

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

