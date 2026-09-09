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

DEFINE VAR x-coddoc AS CHAR.
DEFINE VAR x-nrodoc AS CHAR.

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
&Scoped-define EXTERNAL-TABLES FacCPedi
&Scoped-define FIRST-EXTERNAL-TABLE FacCPedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacCPedi.
/* Standard List Definitions                                            */
&Scoped-Define DISPLAYED-FIELDS FacCPedi.CodDiv FacCPedi.CodCli ~
FacCPedi.NomCli FacCPedi.FchPed FacCPedi.CodRef FacCPedi.NroRef ~
FacCPedi.ImpBrt FacCPedi.TotalValorVentaNetoOpGravadas ~
FacCPedi.PorcentajeDsctoGlobal FacCPedi.ImpDto ~
FacCPedi.TotalValorVentaNetoOpExoneradas FacCPedi.MontoBaseDescuentoGlobal ~
FacCPedi.ImpDto2 FacCPedi.TotalValorVentaNetoOpGratuitas ~
FacCPedi.DescuentosGlobales FacCPedi.ImpExo ~
FacCPedi.TotalTributosOpeGratuitas FacCPedi.MontoBaseICBPER FacCPedi.ImpVta ~
FacCPedi.TotalValorVentaNetoOpNoGravada FacCPedi.TotalMontoICBPER ~
FacCPedi.ImpIgv FacCPedi.TotalIGV FacCPedi.PorIgv ~
FacCPedi.TotalDocumentoAnticipo FacCPedi.TotalImpuestos ~
FacCPedi.PorcentajeDsctoGlobalAnticipo FacCPedi.ImpTot ~
FacCPedi.TotalValorVenta FacCPedi.MontoBaseDsctoGlobalAnticipo ~
FacCPedi.Lista_de_Precios FacCPedi.TotalPrecioVenta ~
FacCPedi.TotalDsctoGlobalesAnticipo FacCPedi.TotalVenta 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-comprobante 

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
DEFINE VARIABLE FILL-IN-comprobante AS CHARACTER FORMAT "X(256)":U 
     LABEL "Comprobante" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.CodDiv AT ROW 1.08 COL 11 COLON-ALIGNED WIDGET-ID 78
          VIEW-AS FILL-IN 
          SIZE 7.72 BY .81
          FGCOLOR 9 
     FacCPedi.CodCli AT ROW 1.96 COL 11 COLON-ALIGNED WIDGET-ID 12
          LABEL "Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .81
          FGCOLOR 9 
     FacCPedi.NomCli AT ROW 1.96 COL 22.29 COLON-ALIGNED NO-LABEL WIDGET-ID 42
          VIEW-AS FILL-IN 
          SIZE 72.86 BY .81
          FGCOLOR 9 
     FacCPedi.FchPed AT ROW 2.92 COL 11.29 COLON-ALIGNED WIDGET-ID 18
          LABEL "Emision" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 9.72 BY .81
          FGCOLOR 9 
     FacCPedi.CodRef AT ROW 2.92 COL 31.72 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          FGCOLOR 9 
     FacCPedi.NroRef AT ROW 2.92 COL 37.14 COLON-ALIGNED NO-LABEL WIDGET-ID 44
          VIEW-AS FILL-IN 
          SIZE 11.86 BY .81
          FGCOLOR 9 
     FILL-IN-comprobante AT ROW 2.96 COL 62 COLON-ALIGNED WIDGET-ID 82
     FacCPedi.ImpBrt AT ROW 3.88 COL 16 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
          FGCOLOR 4 
     FacCPedi.TotalValorVentaNetoOpGravadas AT ROW 4 COL 57.29 COLON-ALIGNED WIDGET-ID 72
          LABEL "TotalValorVentaNetoOpGravadas" FORMAT ">>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FGCOLOR 12 
     FacCPedi.PorcentajeDsctoGlobal AT ROW 4.08 COL 94.14 COLON-ALIGNED WIDGET-ID 46
          VIEW-AS FILL-IN 
          SIZE 7.86 BY .81
          FGCOLOR 12 
     FacCPedi.ImpDto AT ROW 4.69 COL 16 COLON-ALIGNED WIDGET-ID 22
          LABEL "Suma Dsctos x Item" FORMAT "->>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
          FGCOLOR 4 
     FacCPedi.TotalValorVentaNetoOpExoneradas AT ROW 4.73 COL 57.29 COLON-ALIGNED WIDGET-ID 68
          LABEL "TotalValorVentaNetoOpExoneradas" FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FGCOLOR 12 
     FacCPedi.MontoBaseDescuentoGlobal AT ROW 4.92 COL 94.14 COLON-ALIGNED WIDGET-ID 36
          LABEL "MontoBaseDescuentoGlobal" FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FGCOLOR 12 
     FacCPedi.ImpDto2 AT ROW 5.5 COL 16 COLON-ALIGNED WIDGET-ID 24
          LABEL "Impte Dscto Encartes" FORMAT "->>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FGCOLOR 4 
     FacCPedi.TotalValorVentaNetoOpGratuitas AT ROW 5.54 COL 57.29 COLON-ALIGNED WIDGET-ID 70
          LABEL "TotalValorVentaNetoOpGratuitas" FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FGCOLOR 12 
     FacCPedi.DescuentosGlobales AT ROW 5.73 COL 94 COLON-ALIGNED WIDGET-ID 80
          LABEL "DescuentosGlobales" FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FGCOLOR 12 
     FacCPedi.ImpExo AT ROW 6.31 COL 16.14 COLON-ALIGNED WIDGET-ID 26
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
          FGCOLOR 4 
     FacCPedi.TotalTributosOpeGratuitas AT ROW 6.38 COL 57.29 COLON-ALIGNED WIDGET-ID 64
          LABEL "TotalTributosOpeGratuitas" FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FGCOLOR 12 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     FacCPedi.MontoBaseICBPER AT ROW 6.96 COL 94 COLON-ALIGNED WIDGET-ID 40
          LABEL "MontoBaseICBPER" FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FGCOLOR 12 
     FacCPedi.ImpVta AT ROW 7.12 COL 16.29 COLON-ALIGNED WIDGET-ID 32
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
          FGCOLOR 4 
     FacCPedi.TotalValorVentaNetoOpNoGravada AT ROW 7.19 COL 57.29 COLON-ALIGNED WIDGET-ID 74
          LABEL "TotalValorVentaNetoOpNoGravada" FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FGCOLOR 12 
     FacCPedi.TotalMontoICBPER AT ROW 7.77 COL 94 COLON-ALIGNED WIDGET-ID 60
          LABEL "TotalMontoICBPER" FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FGCOLOR 12 
     FacCPedi.ImpIgv AT ROW 7.92 COL 16.29 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
          FGCOLOR 4 
     FacCPedi.TotalIGV AT ROW 8.12 COL 57.14 COLON-ALIGNED WIDGET-ID 56
          LABEL "TotalIGV" FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FGCOLOR 12 
     FacCPedi.PorIgv AT ROW 8.73 COL 16.29 COLON-ALIGNED WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 6.43 BY .81
          FGCOLOR 4 
     FacCPedi.TotalDocumentoAnticipo AT ROW 8.73 COL 94 COLON-ALIGNED WIDGET-ID 52
          LABEL "TotalDocumentoAnticipo" FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FGCOLOR 12 
     FacCPedi.TotalImpuestos AT ROW 8.88 COL 57.14 COLON-ALIGNED WIDGET-ID 58
          LABEL "TotalImpuestos" FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FGCOLOR 12 
     FacCPedi.PorcentajeDsctoGlobalAnticipo AT ROW 9.54 COL 94 COLON-ALIGNED WIDGET-ID 48
          VIEW-AS FILL-IN 
          SIZE 7.86 BY .81
          FGCOLOR 12 
     FacCPedi.ImpTot AT ROW 9.58 COL 16.29 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .81
          FGCOLOR 4 
     FacCPedi.TotalValorVenta AT ROW 9.65 COL 57.14 COLON-ALIGNED WIDGET-ID 66
          LABEL "TotalValorVenta" FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FGCOLOR 12 
     FacCPedi.MontoBaseDsctoGlobalAnticipo AT ROW 10.35 COL 94 COLON-ALIGNED WIDGET-ID 38
          LABEL "MontoBaseDsctoGlobalAnticipo" FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FGCOLOR 12 
     FacCPedi.Lista_de_Precios AT ROW 10.42 COL 16.29 COLON-ALIGNED WIDGET-ID 34
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
          FGCOLOR 4 
     FacCPedi.TotalPrecioVenta AT ROW 10.58 COL 57.14 COLON-ALIGNED WIDGET-ID 62
          LABEL "TotalPrecioVenta" FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FGCOLOR 12 
     FacCPedi.TotalDsctoGlobalesAnticipo AT ROW 11.15 COL 94 COLON-ALIGNED WIDGET-ID 54
          LABEL "TotalDsctoGlobalesAnticipo" FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .81
          FGCOLOR 12 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     FacCPedi.TotalVenta AT ROW 11.31 COL 57.14 COLON-ALIGNED WIDGET-ID 76
          LABEL "totalVenta" FORMAT ">>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
          FGCOLOR 12 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.FacCPedi
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
         HEIGHT             = 11.31
         WIDTH              = 109.
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

/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.CodDiv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.DescuentosGlobales IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FILL-IN-comprobante IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.ImpBrt IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.ImpDto IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.ImpDto2 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.ImpExo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.ImpIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.ImpVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.Lista_de_Precios IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.MontoBaseDescuentoGlobal IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.MontoBaseDsctoGlobalAnticipo IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.MontoBaseICBPER IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.PorcentajeDsctoGlobal IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.PorcentajeDsctoGlobalAnticipo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.PorIgv IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.TotalDocumentoAnticipo IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.TotalDsctoGlobalesAnticipo IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.TotalIGV IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.TotalImpuestos IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.TotalMontoICBPER IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.TotalPrecioVenta IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.TotalTributosOpeGratuitas IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.TotalValorVenta IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.TotalValorVentaNetoOpExoneradas IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.TotalValorVentaNetoOpGratuitas IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.TotalValorVentaNetoOpGravadas IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.TotalValorVentaNetoOpNoGravada IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.TotalVenta IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


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
  {src/adm/template/row-list.i "FacCPedi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacCPedi"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscar-documento V-table-Win 
PROCEDURE buscar-documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER combo-box-coddoc AS CHAR.
DEFINE INPUT PARAMETER fill-in-nrodoc AS CHAR.


x-coddoc = combo-box-coddoc.
x-nrodoc = fill-in-nrodoc.

FIND FIRST faccpedi WHERE faccpedi.codcia = 1 AND 
                            faccpedi.coddoc = combo-box-coddoc AND
                            faccpedi.nroped = fill-in-nrodoc NO-LOCK NO-ERROR.
IF AVAILABLE faccpedi  THEN DO:
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
END.

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

  FILL-in-comprobante:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" .

  FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = 1 AND 
                            ccbcdocu.codref = x-coddoc AND
                            ccbcdocu.nroref = x-nrodoc AND 
                            ccbcdocu.coddoc = 'FAC' AND 
                            ccbcdocu.flgest <> "A" NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ccbcdocu THEN DO:
      FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = 1 AND 
                                ccbcdocu.codref = x-coddoc AND
                                ccbcdocu.nroref = x-nrodoc AND                                 
                                ccbcdocu.coddoc = 'BOL' AND
                                ccbcdocu.flgest <> "A" NO-LOCK NO-ERROR.
  END.

  IF AVAILABLE ccbcdocu THEN DO:
        FILL-in-comprobante:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ccbcdocu.coddoc + " - " + ccbcdocu.nrodoc .
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
  {src/adm/template/snd-list.i "FacCPedi"}

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
   /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CAMPO.
         RETURN "ADM-ERROR".   
   
      END.
   */

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

