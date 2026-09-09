&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TICKETS LIKE VtaVTickets.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
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

  Description: from BROWSER.W - Basic SmartBrowser Object Template

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
DEF SHARED VAR cl-codcia AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES TICKETS

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table TICKETS.Libre_c01 TICKETS.Libre_d01 ~
TICKETS.Libre_d02 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table TICKETS.Libre_c01 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table TICKETS
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table TICKETS
&Scoped-define QUERY-STRING-br_table FOR EACH TICKETS WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH TICKETS WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table TICKETS
&Scoped-define FIRST-TABLE-IN-QUERY-br_table TICKETS


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodPro FILL-IN-NomPro ~
FILL-IN-Producto FILL-IN-CodCli FILL-IN-NomCli FILL-IN-FchVto ~
FILL-IN-NroIni FILL-IN-NroFin 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-CodCli AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodPro AS CHARACTER FORMAT "X(11)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchVto AS DATE FORMAT "99/99/99":U 
     LABEL "Vencimiento" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroFin AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     LABEL "Hasta el número" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroIni AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     LABEL "Desde el número" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Producto AS CHARACTER FORMAT "X(8)":U 
     LABEL "Producto" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      TICKETS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      TICKETS.Libre_c01 COLUMN-LABEL "Código de Barra" FORMAT "x(30)":U
      TICKETS.Libre_d01 COLUMN-LABEL "Número de Ticket" FORMAT ">>>>>>>>9":U
            WIDTH 14
      TICKETS.Libre_d02 COLUMN-LABEL "Importe" FORMAT "->>>,>>>,>>9.99":U
  ENABLE
      TICKETS.Libre_c01
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 66 BY 11.31
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodPro AT ROW 1.27 COL 14 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-NomPro AT ROW 1.27 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     FILL-IN-Producto AT ROW 2.08 COL 14 COLON-ALIGNED WIDGET-ID 6
     FILL-IN-CodCli AT ROW 2.88 COL 14 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-NomCli AT ROW 2.88 COL 26 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     FILL-IN-FchVto AT ROW 3.69 COL 14 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-NroIni AT ROW 4.5 COL 14 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-NroFin AT ROW 4.5 COL 39 COLON-ALIGNED WIDGET-ID 14
     br_table AT ROW 5.58 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: TICKETS T "?" ? INTEGRAL VtaVTickets
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 16.19
         WIDTH              = 76.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table FILL-IN-NroFin F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-CodCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FchVto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroFin IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroIni IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Producto IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.TICKETS"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.TICKETS.Libre_c01
"TICKETS.Libre_c01" "Código de Barra" "x(30)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.TICKETS.Libre_d01
"TICKETS.Libre_d01" "Número de Ticket" ">>>>>>>>9" "decimal" ? ? ? ? ? ? no ? no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.TICKETS.Libre_d02
"TICKETS.Libre_d02" "Importe" "->>>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodCli B-table-Win
ON LEAVE OF FILL-IN-CodCli IN FRAME F-Main /* Cliente */
DO:
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  FILL-IN-NomCli:SCREEN-VALUE = ''.
  IF AVAILABLE gn-clie THEN FILL-IN-NomCli:SCREEN-VALUE = gn-clie.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodPro B-table-Win
ON LEAVE OF FILL-IN-CodPro IN FRAME F-Main /* Proveedor */
DO:
  FIND gn-prov WHERE gn-prov.codcia = pv-codcia
      AND gn-prov.codpro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  FILL-IN-NomPro:SCREEN-VALUE = ''.
  IF AVAILABLE gn-prov THEN FILL-IN-NomPro:SCREEN-VALUE = gn-prov.nompro.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aceptar B-table-Win 
PROCEDURE Aceptar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Consistencias los datos */
DEF VAR k AS INT.

DO k = FILL-IN-NroIni TO FILL-IN-NroFin:
    FIND TICKETS WHERE TICKETS.Libre_d01 = k NO-LOCK NO-ERROR.
    IF NOT AVAILABLE TICKETS THEN DO:
        MESSAGE 'Falta registrar el ticket' k
            VIEW-AS ALERT-BOX WARNING.
        RETURN.
    END.
END.
CREATE VtaVTickets.
ASSIGN
    VtaVTickets.CodCia = s-codcia
    VtaVTickets.CodCli = FILL-IN-CodCli
    VtaVTickets.CodPro = FILL-IN-CodPro
    VtaVTickets.FchFin = FILL-IN-FchVto
    VtaVTickets.FchIni = TODAY
    VtaVTickets.NroFin = FILL-IN-NroFin
    VtaVTickets.NroIni = FILL-IN-NroIni
    VtaVTickets.Producto = FILL-IN-Producto.
RELEASE VtaVTickets.
CLEAR FRAME {&FRAME-NAME} ALL NO-PAUSE.
EMPTY TEMP-TABLE TICKETS.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
RUN Enable-Variables.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Disable-Variables B-table-Win 
PROCEDURE Disable-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        FILL-IN-CodCli:SENSITIVE = NO
        FILL-IN-CodPro:SENSITIVE = NO
        FILL-IN-FchVto:SENSITIVE = NO
        FILL-IN-NroIni:SENSITIVE = NO
        FILL-IN-NroFin:SENSITIVE = NO
        FILL-IN-Producto:SENSITIVE = NO.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Enable-Variables B-table-Win 
PROCEDURE Enable-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        FILL-IN-CodCli:SENSITIVE = YES
        FILL-IN-CodPro:SENSITIVE = YES
        FILL-IN-FchVto:SENSITIVE = YES
        FILL-IN-NroIni:SENSITIVE = YES
        FILL-IN-NroFin:SENSITIVE = YES
        FILL-IN-Producto:SENSITIVE = YES.
    APPLY 'ENTRY':U TO FILL-IN-CodPro.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record B-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN 
          FILL-IN-CodCli 
          FILL-IN-CodPro 
          FILL-IN-FchVto 
          FILL-IN-NomCli 
          FILL-IN-NomPro 
          FILL-IN-NroFin 
          FILL-IN-NroIni 
          FILL-IN-Producto.

      RUN Disable-Variables.

      /* Consistencia de datos */
      FIND gn-prov WHERE gn-prov.codcia = pv-codcia
          AND gn-prov.codpro = FILL-IN-CodPro
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-prov THEN DO:
          MESSAGE 'Proveedor NO registrado' VIEW-AS ALERT-BOX ERROR.
          RUN Enable-Variables.
          RETURN 'ADM-ERROR'.
      END.
      FIND gn-clie WHERE gn-clie.codcia = cl-codcia
          AND gn-clie.codcli = FILL-IN-CodCli 
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-clie THEN DO:
          MESSAGE 'Cliente NO registrado' VIEW-AS ALERT-BOX ERROR.
          RUN Enable-Variables.
          RETURN 'ADM-ERROR'.
      END.
      FIND Vtactickets WHERE Vtactickets.codcia = s-codcia
          AND VtaCTickets.CodPro = FILL-IN-CodPro
          AND VtaCTickets.Producto = FILL-IN-Producto
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Vtactickets THEN DO:
          MESSAGE 'Producto NO registrado' VIEW-AS ALERT-BOX ERROR.
          RUN Enable-Variables.
          RETURN 'ADM-ERROR'.
      END.
      IF FILL-IN-NroIni = 0 OR FILL-IN-nroFin = 0 THEN DO:
          MESSAGE 'Debe indicar el rango de números' VIEW-AS ALERT-BOX ERROR.
          RUN Enable-Variables.
          RETURN 'ADM-ERROR'.
      END.
      IF FILL-IN-NroIni > FILL-IN-nroFin THEN DO:
          MESSAGE 'Incorrecto el rango de números' VIEW-AS ALERT-BOX ERROR.
          RUN Enable-Variables.
          RETURN 'ADM-ERROR'.
      END.
      FOR EACH Vtavtickets NO-LOCK WHERE VtaVTickets.CodCia = s-codcia
          AND VtaVTickets.CodPro = FILL-IN-CodPro
          AND VtaVTickets.Producto = FILL-IN-Producto:
          IF FILL-IN-NroIni >= VtaVTickets.NroIni
              AND FILL-IN-NroIni <= VtaVTickets.NroFin THEN DO:
              MESSAGE 'Incorrecto el rango de números' SKIP
                  'Ya se ecuentra registrado en' SKIP
                  'Producto:' VtaVTickets.Producto SKIP
                  'Des el número' VtaVTickets.NroIni 'Hast el número' VtaVTickets.NroFin
                  VIEW-AS ALERT-BOX ERROR.
              RUN Enable-Variables.
              RETURN 'ADM-ERROR'.
          END.
          IF FILL-IN-NroFin >= VtaVTickets.NroIni
              AND FILL-IN-NroFin <= VtaVTickets.NroFin THEN DO:
              MESSAGE 'Incorrecto el rango de números' SKIP
                  'Ya se ecuentra registrado en' SKIP
                  'Producto:' VtaVTickets.Producto SKIP
                  'Des el número' VtaVTickets.NroIni 'Hast el número' VtaVTickets.NroFin
                  VIEW-AS ALERT-BOX ERROR.
              RUN Enable-Variables.
              RETURN 'ADM-ERROR'.
          END.

           
      END.


  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement B-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      TICKETS.Libre_d01 = INTEGER(TICKETS.Libre_d01:SCREEN-VALUE IN BROWSE {&browse-name})
      TICKETS.Libre_d02 = DECIMAL(TICKETS.Libre_d02:SCREEN-VALUE IN BROWSE {&browse-name}).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  ASSIGN
      FILL-IN-FchVto = TODAY + (6 * 30).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
   RUN Enable-Variables.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
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
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "TICKETS"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
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
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* VERIFICAMOS EL VALE */
DEF VAR x-Ok AS LOG INIT NO NO-UNDO.
DEF VAR x-CodBarra AS CHAR NO-UNDO.
DEF VAR x-Producto AS CHAR NO-UNDO.
DEF VAR x-NroTck AS CHAR NO-UNDO.
DEF VAR x-Valor AS DEC NO-UNDO.
DEF VAR x-Digito AS INT NO-UNDO.

x-CodBarra = Tickets.Libre_c01:SCREEN-VALUE IN BROWSE {&browse-name}.
/* Barremos todos los productos del proveedor */
FOR EACH Vtactickets NO-LOCK WHERE Vtactickets.codcia = s-codcia
    AND VtaCTickets.CodPro = FILL-IN-CodPro
    AND VtaCTickets.Producto = FILL-IN-Producto
    AND TODAY >= VtaCTickets.FchIni
    AND TODAY <= VtaCTickets.FchFin:
    /* Determinamos cual es el producto */
    IF VtaCTickets.Pos_Producto = '9999' THEN NEXT.
    IF LENGTH(x-CodBarra) <> VtaCTickets.Longitud THEN NEXT.
    x-Producto = SUBSTRING(x-CodBarra, INTEGER(SUBSTRING(VtaCTickets.Pos_Producto,1,2)), INTEGER(SUBSTRING(VtaCTickets.Pos_Producto,3,2))).
    IF VtaCTickets.Producto <> x-Producto THEN NEXT.
    /* Digito verificador */
    IF VtaCTickets.Pos_Verif1 <> '9999' AND VtaCTickets.Prog_Verif1 <> '' THEN DO:
        RUN VALUE (VtaCTickets.Prog_Verif1) (x-CodBarra, OUTPUT x-Digito).
        IF x-Digito = -1 THEN DO:
            MESSAGE 'Error en el código de barra, volver a pasar el ticket'
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'entry' TO TICKETS.Libre_c01.
            RETURN 'ADM-ERROR'.
        END.
        IF INTEGER ( SUBSTRING(x-CodBarra, INTEGER(SUBSTRING(VtaCTickets.Pos_Verif1,1,2)), INTEGER(SUBSTRING(VtaCTickets.Pos_Verif1,3,2))) )
            <> x-Digito THEN DO:
            MESSAGE 'Error en el dígito verificador'
                VIEW-AS ALERT-BOX ERROR.
            APPLY 'entry' TO TICKETS.Libre_c01.
            RETURN 'ADM-ERROR'.
        END.
    END.
    /* capturamos los valores */
    ASSIGN
        x-NroTck = SUBSTRING(x-CodBarra, INTEGER(SUBSTRING(VtaCTickets.Pos_NroTck,1,2)), INTEGER(SUBSTRING(VtaCTickets.Pos_NroTck,3,2)))
        x-Valor = DECIMAL (SUBSTRING(x-CodBarra, INTEGER(SUBSTRING(VtaCTickets.Pos_Valor,1,2)), INTEGER(SUBSTRING(VtaCTickets.Pos_Valor,3,2))) ) / 100.
    ASSIGN
        TICKETS.Libre_d01:SCREEN-VALUE IN BROWSE {&browse-name} = x-NroTck
        TICKETS.Libre_d02:SCREEN-VALUE IN BROWSE {&browse-name} = STRING(x-Valor).
    /* NO repetido */
    IF CAN-FIND(FIRST Tickets WHERE TICKETS.Libre_d01 = INTEGER(x-NroTck) NO-LOCK) THEN DO:
        MESSAGE 'Ticket repetido' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry' TO TICKETS.Libre_c01.
        RETURN 'ADM-ERROR'.
    END.
    x-Ok = YES.
    LEAVE.
END.

IF x-Ok = NO THEN DO:
    MESSAGE 'Ticket NO válido' VIEW-AS ALERT-BOX ERROR.
    APPLY 'entry' TO TICKETS.Libre_c01.
    RETURN "ADM-ERROR".
END.
RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

