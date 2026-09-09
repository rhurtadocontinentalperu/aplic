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

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.

DEF VAR s-Tabla AS CHAR INIT "UTILEX-ENCARTE".

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
&Scoped-define EXTERNAL-TABLES VtaCTickets
&Scoped-define FIRST-EXTERNAL-TABLE VtaCTickets


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR VtaCTickets.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS VtaCTickets.CodPro VtaCTickets.Pos_Producto ~
VtaCTickets.Producto VtaCTickets.Libre_c05 VtaCTickets.FchIni ~
VtaCTickets.FchFin VtaCTickets.Longitud VtaCTickets.Pos_DayVcto ~
VtaCTickets.Libre_c01 VtaCTickets.Pos_MonthVcto VtaCTickets.Pos_YearVcto ~
VtaCTickets.Pos_NroTck VtaCTickets.Pos_Valor VtaCTickets.Pos_Verif1 ~
VtaCTickets.Prog_Verif1 VtaCTickets.Pos_Verif2 VtaCTickets.Prog_Verif2 
&Scoped-define ENABLED-TABLES VtaCTickets
&Scoped-define FIRST-ENABLED-TABLE VtaCTickets
&Scoped-Define ENABLED-OBJECTS RECT-4 
&Scoped-Define DISPLAYED-FIELDS VtaCTickets.CodPro VtaCTickets.Pos_Producto ~
VtaCTickets.Producto VtaCTickets.Libre_c05 VtaCTickets.FchIni ~
VtaCTickets.FchFin VtaCTickets.Longitud VtaCTickets.Pos_DayVcto ~
VtaCTickets.Libre_c01 VtaCTickets.Pos_MonthVcto VtaCTickets.Pos_YearVcto ~
VtaCTickets.Pos_NroTck VtaCTickets.Pos_Valor VtaCTickets.Pos_Verif1 ~
VtaCTickets.Prog_Verif1 VtaCTickets.Pos_Verif2 VtaCTickets.Prog_Verif2 
&Scoped-define DISPLAYED-TABLES VtaCTickets
&Scoped-define FIRST-DISPLAYED-TABLE VtaCTickets
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NomPro ChkValidar RADIO-SET-Estado ~
FILL-IN-Descripcion FILL-IN-Fecha-1 FILL-IN-Fecha-2 FILL-IN-Valor-1 ~
FILL-IN-Valor-2 

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
DEFINE VARIABLE FILL-IN-Descripcion AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Válida desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Fecha-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 74 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Valor-1 AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "% Descuento" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Valor-2 AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Tope en S/." 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-Estado AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Activa", "A":U,
"Inactiva", "I":U,
"?", ?
     SIZE 23 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65 BY 5.38.

DEFINE VARIABLE ChkValidar AS LOGICAL INITIAL no 
     LABEL "Validar existencia del vale" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     VtaCTickets.CodPro AT ROW 1.27 COL 11 COLON-ALIGNED WIDGET-ID 2
          LABEL "Proveedor"
          VIEW-AS FILL-IN 
          SIZE 15.43 BY 1
     FILL-IN-NomPro AT ROW 1.27 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     VtaCTickets.Pos_Producto AT ROW 2.35 COL 11 COLON-ALIGNED WIDGET-ID 16
          LABEL "Ubicación"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY 1
     VtaCTickets.Producto AT ROW 2.35 COL 27 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 12.43 BY 1
     VtaCTickets.Libre_c05 AT ROW 2.35 COL 51 COLON-ALIGNED WIDGET-ID 74
          LABEL "Descripción" FORMAT "x(60)"
          VIEW-AS FILL-IN 
          SIZE 50 BY 1
     VtaCTickets.FchIni AT ROW 3.42 COL 11 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 12.86 BY 1
     ChkValidar AT ROW 3.42 COL 53 WIDGET-ID 72
     VtaCTickets.FchFin AT ROW 4.5 COL 11 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 12.86 BY 1
     VtaCTickets.Longitud AT ROW 5.58 COL 29 COLON-ALIGNED WIDGET-ID 8
          LABEL "# caracteres del cód. de barra"
          VIEW-AS FILL-IN 
          SIZE 3.72 BY 1
     VtaCTickets.Pos_DayVcto AT ROW 6.65 COL 29 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 7.14 BY 1
     VtaCTickets.Libre_c01 AT ROW 6.77 COL 46 COLON-ALIGNED WIDGET-ID 46
          LABEL "CODIGO" FORMAT "x(20)"
          VIEW-AS FILL-IN 
          SIZE 31.57 BY 1
     RADIO-SET-Estado AT ROW 6.77 COL 80 NO-LABEL WIDGET-ID 64
     VtaCTickets.Pos_MonthVcto AT ROW 7.73 COL 29 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 7.14 BY 1
     FILL-IN-Descripcion AT ROW 7.92 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 50
     VtaCTickets.Pos_YearVcto AT ROW 8.81 COL 29 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 7.14 BY 1
     FILL-IN-Fecha-1 AT ROW 9.08 COL 54 COLON-ALIGNED WIDGET-ID 56
     FILL-IN-Fecha-2 AT ROW 9.08 COL 78 COLON-ALIGNED WIDGET-ID 58
     VtaCTickets.Pos_NroTck AT ROW 9.88 COL 29 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 7.14 BY 1
     FILL-IN-Valor-1 AT ROW 10.23 COL 54 COLON-ALIGNED WIDGET-ID 60
     FILL-IN-Valor-2 AT ROW 10.23 COL 78 COLON-ALIGNED WIDGET-ID 62
     VtaCTickets.Pos_Valor AT ROW 10.96 COL 29 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 7.14 BY 1
     VtaCTickets.Pos_Verif1 AT ROW 12.04 COL 29 COLON-ALIGNED WIDGET-ID 20
          LABEL "Dígito Verificador 1"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY 1
     VtaCTickets.Prog_Verif1 AT ROW 12.04 COL 59 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 26.43 BY 1
     VtaCTickets.Pos_Verif2 AT ROW 13.12 COL 29 COLON-ALIGNED WIDGET-ID 22
          LABEL "Dígito Verificador 2"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY 1
     VtaCTickets.Prog_Verif2 AT ROW 13.12 COL 59 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 26.43 BY 1
     "NOTA:" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 3.96 COL 41 WIDGET-ID 38
          BGCOLOR 7 FGCOLOR 15 FONT 5
     "Los primeros 2 números indican la posición inicial en el código de barras" VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 4.5 COL 41 WIDGET-ID 40
          BGCOLOR 7 FGCOLOR 15 FONT 5
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Los segundos 2 números indican cuantos caracteres hay que considerar" VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 5.04 COL 41 WIDGET-ID 42
          BGCOLOR 7 FGCOLOR 15 FONT 5
     "ENCARTE RELACIONADO" VIEW-AS TEXT
          SIZE 24 BY .62 AT ROW 6 COL 40 WIDGET-ID 48
          BGCOLOR 9 FGCOLOR 15 
     RECT-4 AT ROW 6.19 COL 39 WIDGET-ID 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.VtaCTickets
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
         HEIGHT             = 13.54
         WIDTH              = 104.86.
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

/* SETTINGS FOR TOGGLE-BOX ChkValidar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCTickets.CodPro IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Descripcion IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Fecha-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Fecha-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Valor-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Valor-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VtaCTickets.Libre_c01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN VtaCTickets.Libre_c05 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN VtaCTickets.Longitud IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCTickets.Pos_Producto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCTickets.Pos_Verif1 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VtaCTickets.Pos_Verif2 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME VtaCTickets.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCTickets.CodPro V-table-Win
ON LEAVE OF VtaCTickets.CodPro IN FRAME F-Main /* Proveedor */
DO:
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
      AND gn-prov.codpro = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
    IF AVAILABLE gn-prov THEN FILL-IN-NomPro:SCREEN-VALUE = gn-prov.nompro.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME VtaCTickets.Libre_c01
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL VtaCTickets.Libre_c01 V-table-Win
ON LEAVE OF VtaCTickets.Libre_c01 IN FRAME F-Main /* CODIGO */
DO:
  ASSIGN
      FILL-IN-Descripcion:SCREEN-VALUE = ''
      RADIO-SET-Estado:SCREEN-VALUE = ?
      FILL-IN-Fecha-1:SCREEN-VALUE = ''
      FILL-IN-Fecha-2:SCREEN-VALUE = ''
      FILL-IN-Valor-1:SCREEN-VALUE = ''
      FILL-IN-Valor-2:SCREEN-VALUE = ''.
  FIND Vtactabla WHERE VtaCTabla.CodCia = s-codcia
      AND VtaCTabla.Tabla = s-tabla
      AND VtaCTabla.Llave = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE VtaCTabla THEN
      ASSIGN
      FILL-IN-Descripcion:SCREEN-VALUE = VtaCTabla.Descripcion
      RADIO-SET-Estado:SCREEN-VALUE = VtaCTabla.Estado
      FILL-IN-Fecha-2:SCREEN-VALUE = STRING(VtaCTabla.FechaFinal)
      FILL-IN-Fecha-1:SCREEN-VALUE = STRING(VtaCTabla.FechaInicial)
      FILL-IN-Valor-1:SCREEN-VALUE = STRING(VtaCTabla.Libre_d01)
      FILL-IN-Valor-2:SCREEN-VALUE = STRING(VtaCTabla.Libre_d02).

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
  {src/adm/template/row-list.i "VtaCTickets"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "VtaCTickets"}

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

  DEFINE VAR lValida AS CHAR.

  lValida = CAPS(ChkValidar:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
  IF lValida = 'YES' THEN lValida = 'SI'.

  ASSIGN
      VtaCTickets.CodCia = s-codcia
      VtaCTickets.libre_c02 = lValida.
        
  
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
     chkvalidar:SENSITIVE = NO.
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
  IF AVAILABLE Vtactickets THEN DO WITH FRAME {&FRAME-NAME}:
      FIND gn-prov WHERE gn-prov.codcia = pv-codcia
          AND gn-prov.codpro = VtaCTickets.CodPro
          NO-LOCK NO-ERROR.
      FILL-IN-NomPro:SCREEN-VALUE = ''.
      IF AVAILABLE gn-prov THEN FILL-IN-NomPro:SCREEN-VALUE = gn-prov.nompro.

      ASSIGN
          FILL-IN-Descripcion:SCREEN-VALUE = ''
          RADIO-SET-Estado:SCREEN-VALUE = ?
          FILL-IN-Fecha-1:SCREEN-VALUE = ''
          FILL-IN-Fecha-2:SCREEN-VALUE = ''
          FILL-IN-Valor-1:SCREEN-VALUE = ''
          FILL-IN-Valor-2:SCREEN-VALUE = ''.
      FIND Vtactabla WHERE VtaCTabla.CodCia = s-codcia
          AND VtaCTabla.Tabla = s-tabla
          AND VtaCTabla.Llave = VtaCTickets.Libre_c01
          NO-LOCK NO-ERROR.
      IF AVAILABLE VtaCTabla THEN
          ASSIGN
          FILL-IN-Descripcion:SCREEN-VALUE = VtaCTabla.Descripcion
          RADIO-SET-Estado:SCREEN-VALUE = VtaCTabla.Estado
          FILL-IN-Fecha-1:SCREEN-VALUE = STRING(VtaCTabla.FechaFinal)
          FILL-IN-Fecha-2:SCREEN-VALUE = STRING(VtaCTabla.FechaInicial)
          FILL-IN-Valor-1:SCREEN-VALUE = STRING(VtaCTabla.Libre_d01)
          FILL-IN-Valor-2:SCREEN-VALUE = STRING(VtaCTabla.Libre_d02).

      chkvalidar:SCREEN-VALUE = 'no'.
      IF vtactickets.libre_c02 = 'SI' THEN chkvalidar:SCREEN-VALUE = 'yes'.

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
  DO WITH FRAME {&FRAME-NAME}:
      RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
      IF RETURN-VALUE = 'NO' THEN DO:
          ASSIGN
          VtaCTickets.CodPro:SENSITIVE = NO
          VtaCTickets.Producto:SENSITIVE = NO.
          APPLY 'entry' TO VTactickets.Pos_Producto.
      END.
      chkvalidar:SENSITIVE = YES.
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
        WHEN "Libre_c01" THEN 
            ASSIGN
            input-var-1 = s-tabla
            input-var-2 = ''.
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
  {src/adm/template/snd-list.i "VtaCTickets"}

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

DO WITH FRAME {&FRAME-NAME} :
    FIND gn-prov WHERE gn-prov.codcia = pv-codcia
        AND gn-prov.codpro = VtaCTickets.CodPro:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-prov THEN DO:
        MESSAGE 'Proveedor no registrado' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO Vtactickets.codpro.
        RETURN 'ADM-ERROR'.
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


RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

