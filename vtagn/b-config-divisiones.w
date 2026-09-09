&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-Tabla AS CHAR INIT 'GN-DIVI' NO-UNDO.

&SCOPED-DEFINE Condicion (FacTabla.CodCia = s-CodCia AND FacTabla.Tabla = s-Tabla)

DEF VAR x-Usuario AS CHAR NO-UNDO.
DEF VAR x-FechaHora AS CHAR NO-UNDO.

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
&Scoped-define INTERNAL-TABLES FacTabla GN-DIVI logtabla

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacTabla.Codigo GN-DIVI.DesDiv ~
FacTabla.Campo-L[1] FacTabla.Campo-L[2] FacTabla.Valor[1] ~
FacTabla.Campo-C[1] FacTabla.Campo-L[3] FacTabla.Campo-L[4] ~
FacTabla.Campo-L[5] FacTabla.Campo-L[6] FacTabla.Valor[2] 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table FacTabla.Campo-L[1] ~
FacTabla.Campo-L[2] FacTabla.Valor[1] FacTabla.Campo-C[1] ~
FacTabla.Campo-L[3] FacTabla.Campo-L[4] FacTabla.Campo-L[5] ~
FacTabla.Campo-L[6] FacTabla.Valor[2] 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table FacTabla
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table FacTabla
&Scoped-define QUERY-STRING-br_table FOR EACH FacTabla WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion}  NO-LOCK, ~
      EACH GN-DIVI WHERE GN-DIVI.CodCia = FacTabla.CodCia ~
  AND GN-DIVI.CodDiv = FacTabla.Codigo NO-LOCK, ~
      LAST logtabla WHERE TRUE /* Join to FacTabla incomplete */ ~
      AND logtabla.codcia = s-codcia ~
 AND logtabla.Evento = "CFG-COT-PED" ~
 AND logtabla.Tabla = "GN-DIVI" ~
 AND logtabla.ValorLlave BEGINS STRING(s-codcia) + '|GN-DIVI|' + FacTabla.Codigo  OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacTabla WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion}  NO-LOCK, ~
      EACH GN-DIVI WHERE GN-DIVI.CodCia = FacTabla.CodCia ~
  AND GN-DIVI.CodDiv = FacTabla.Codigo NO-LOCK, ~
      LAST logtabla WHERE TRUE /* Join to FacTabla incomplete */ ~
      AND logtabla.codcia = s-codcia ~
 AND logtabla.Evento = "CFG-COT-PED" ~
 AND logtabla.Tabla = "GN-DIVI" ~
 AND logtabla.ValorLlave BEGINS STRING(s-codcia) + '|GN-DIVI|' + FacTabla.Codigo  OUTER-JOIN NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table FacTabla GN-DIVI logtabla
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacTabla
&Scoped-define SECOND-TABLE-IN-QUERY-br_table GN-DIVI
&Scoped-define THIRD-TABLE-IN-QUERY-br_table logtabla


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_Usuario FILL-IN_FechaHora 

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
DEFINE VARIABLE FILL-IN_FechaHora AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fecha y Hora" 
     VIEW-AS FILL-IN 
     SIZE 53 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_Usuario AS CHARACTER FORMAT "X(256)":U 
     LABEL "Usuario" 
     VIEW-AS FILL-IN 
     SIZE 23 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      FacTabla, 
      GN-DIVI, 
      logtabla
    FIELDS() SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacTabla.Codigo COLUMN-LABEL "Canal de!Venta" FORMAT "x(8)":U
            WIDTH 8.43
      GN-DIVI.DesDiv FORMAT "X(35)":U WIDTH 35.43
      FacTabla.Campo-L[1] COLUMN-LABEL "Bloquea!si no hay!Stock Disponible" FORMAT "yes/no":U
            WIDTH 11.86 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14 VIEW-AS TOGGLE-BOX
      FacTabla.Campo-L[2] COLUMN-LABEL "Reserva!Mercadería por!Pedido Comercial" FORMAT "yes/no":U
            WIDTH 12.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14 VIEW-AS TOGGLE-BOX
      FacTabla.Valor[1] COLUMN-LABEL "Horas de!Reserva por!Pedido Comercial" FORMAT ">9":U
            WIDTH 12.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      FacTabla.Campo-C[1] COLUMN-LABEL "Hora Límite!Reserva!Formato 24h" FORMAT "XX:XX":U
            WIDTH 9.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 14
      FacTabla.Campo-L[3] COLUMN-LABEL "PEDIDOS!LOGISTICOS!al 100%" FORMAT "yes/no":U
            WIDTH 9.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 10 VIEW-AS TOGGLE-BOX
      FacTabla.Campo-L[4] COLUMN-LABEL "Controla Margen Mínimo!de Utilidad!Lista de Precios y!Pedidos Comerciales" FORMAT "yes/no":U
            WIDTH 17.43 COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11 VIEW-AS TOGGLE-BOX
      FacTabla.Campo-L[5] COLUMN-LABEL "Usar el!TIPO DE CAMBIO!COMERCIAL" FORMAT "yes/no":U
            WIDTH 13.43 VIEW-AS TOGGLE-BOX
      FacTabla.Campo-L[6] COLUMN-LABEL "Aprobación del!Administrador y!Supervisor" FORMAT "yes/no":U
            WIDTH 11.43 VIEW-AS TOGGLE-BOX
      FacTabla.Valor[2] COLUMN-LABEL "Días Vigencia!Pre-Pedido!EVENTOS" FORMAT ">>9":U
            WIDTH 12.29
  ENABLE
      FacTabla.Campo-L[1]
      FacTabla.Campo-L[2]
      FacTabla.Valor[1]
      FacTabla.Campo-C[1]
      FacTabla.Campo-L[3]
      FacTabla.Campo-L[4]
      FacTabla.Campo-L[5]
      FacTabla.Campo-L[6]
      FacTabla.Valor[2]
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 165 BY 20.46
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     FILL-IN_Usuario AT ROW 21.73 COL 10 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_FechaHora AT ROW 21.73 COL 46 COLON-ALIGNED WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
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
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 21.88
         WIDTH              = 189.57.
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
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN_FechaHora IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_Usuario IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.FacTabla,INTEGRAL.GN-DIVI WHERE INTEGRAL.FacTabla ...,INTEGRAL.logtabla WHERE INTEGRAL.FacTabla ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ",, LAST OUTER USED"
     _Where[1]         = "{&Condicion} "
     _JoinCode[2]      = "GN-DIVI.CodCia = FacTabla.CodCia
  AND GN-DIVI.CodDiv = FacTabla.Codigo"
     _Where[3]         = "logtabla.codcia = s-codcia
 AND logtabla.Evento = ""CFG-COT-PED""
 AND logtabla.Tabla = ""GN-DIVI""
 AND logtabla.ValorLlave BEGINS STRING(s-codcia) + '|GN-DIVI|' + FacTabla.Codigo "
     _FldNameList[1]   > INTEGRAL.FacTabla.Codigo
"FacTabla.Codigo" "Canal de!Venta" ? "character" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.GN-DIVI.DesDiv
"GN-DIVI.DesDiv" ? "X(35)" "character" ? ? ? ? ? ? no ? no no "35.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacTabla.Campo-L[1]
"FacTabla.Campo-L[1]" "Bloquea!si no hay!Stock Disponible" ? "logical" 14 0 ? ? ? ? yes ? no no "11.86" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacTabla.Campo-L[2]
"FacTabla.Campo-L[2]" "Reserva!Mercadería por!Pedido Comercial" ? "logical" 14 0 ? ? ? ? yes ? no no "12.43" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[5]   > INTEGRAL.FacTabla.Valor[1]
"FacTabla.Valor[1]" "Horas de!Reserva por!Pedido Comercial" ">9" "decimal" 14 0 ? ? ? ? yes ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.FacTabla.Campo-C[1]
"FacTabla.Campo-C[1]" "Hora Límite!Reserva!Formato 24h" "XX:XX" "character" 14 0 ? ? ? ? yes ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.FacTabla.Campo-L[3]
"FacTabla.Campo-L[3]" "PEDIDOS!LOGISTICOS!al 100%" ? "logical" 10 0 ? ? ? ? yes ? no no "9.43" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[8]   > INTEGRAL.FacTabla.Campo-L[4]
"FacTabla.Campo-L[4]" "Controla Margen Mínimo!de Utilidad!Lista de Precios y!Pedidos Comerciales" ? "logical" 11 0 ? ? ? ? yes ? no no "17.43" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[9]   > INTEGRAL.FacTabla.Campo-L[5]
"FacTabla.Campo-L[5]" "Usar el!TIPO DE CAMBIO!COMERCIAL" ? "logical" ? ? ? ? ? ? yes ? no no "13.43" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[10]   > INTEGRAL.FacTabla.Campo-L[6]
"FacTabla.Campo-L[6]" "Aprobación del!Administrador y!Supervisor" ? "logical" ? ? ? ? ? ? yes ? no no "11.43" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[11]   > INTEGRAL.FacTabla.Valor[2]
"FacTabla.Valor[2]" "Días Vigencia!Pre-Pedido!EVENTOS" ">>9" "decimal" ? ? ? ? ? ? yes ? no no "12.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
      IF AVAILABLE FacTabla THEN DO WITH FRAME {&FRAME-NAME}:
          DISPLAY 
              logtabla.Usuario @ FILL-IN_Usuario
              STRING(logtabla.Dia, '99/99/9999') + ' ' + SUBSTRING(logtabla.Hora,1,5) @ FILL-IN_FechaHora
              .
      END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacTabla.Campo-C[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacTabla.Campo-C[1] br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF FacTabla.Campo-C[1] IN BROWSE br_table /* Hora Límite!Reserva!Formato 24h */
DO:
  DEF VAR x-Hora AS INT NO-UNDO.
  DEF VAR x-Minuto AS INT NO-UNDO.
  ASSIGN
      x-Hora = INTEGER(ENTRY(1,SELF:SCREEN-VALUE,':'))
      x-Minuto = INTEGER(ENTRY(2,SELF:SCREEN-VALUE,':')).
  IF NOT ((x-Hora >= 0 AND x-Hora < 24) AND (x-Minuto >= 00 AND x-Minuto < 60))
      THEN DO:
      MESSAGE 'Los valores van desde las 00:00 horas hasta las 23:59 horas'
          VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN NO-APPLY.
  END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tabla B-table-Win 
PROCEDURE Carga-Tabla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia:
    FIND FacTabla WHERE FacTabla.CodCia = s-CodCia AND
        FacTabla.Tabla = s-Tabla AND
        FacTabla.Codigo = gn-divi.CodDiv
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacTabla THEN DO:
        CREATE FacTabla.
        ASSIGN
            FacTabla.CodCia = s-CodCia 
            FacTabla.Tabla = s-Tabla
            FacTabla.Codigo = gn-divi.CodDiv
            FacTabla.Campo-C[1] = "00:00"
            FacTabla.Campo-L[4] = YES   /* Por defecto SI: controla margen de utilidad */
            .
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DISABLE-COLUMNS B-table-Win 
PROCEDURE DISABLE-COLUMNS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR hBrowse AS HANDLE NO-UNDO.
DEF VAR hColumn AS HANDLE NO-UNDO.
DEF VAR iCounter AS INT NO-UNDO.

ASSIGN hBrowse = BROWSE {&BROWSE-NAME}:HANDLE.

DO iCounter = 1 TO hBrowse:NUM-COLUMNS:
    hColumn = hBrowse:GET-BROWSE-COLUMN(iCounter).
    hColumn:READ-ONLY = TRUE NO-ERROR.
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
  DEF VAR cLlave AS CHAR NO-UNDO.

  cLlave =  STRING(FacTabla.CodCia) + '|' +
            FacTabla.Tabla + '|' +
            FacTabla.Codigo + '|' +
            STRING(FacTabla.Campo-L[1]) + '|' +
            STRING(FacTabla.Campo-L[2]) + '|' +
            STRING(FacTabla.Valor[1], '>9') + '|' +
            STRING(FacTabla.Campo-C[1], 'XX:XX') + '|' +
            STRING(FacTabla.Campo-L[3]) + '|' +
            STRING(FacTabla.Campo-L[4]) + '|' +
            STRING(FacTabla.Campo-L[5]) + '|' +
            STRING(FacTabla.Campo-L[6]).

  FIND LAST LogTabla WHERE logtabla.codcia = s-codcia AND
      logtabla.Tabla = 'GN-DIVI' AND
      logtabla.ValorLlave BEGINS STRING(s-codcia) + '|GN-DIVI|' + FacTabla.Codigo 
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE LogTabla OR logtabla.ValorLlave <> cLlave THEN DO:
      RUN lib/logtabla (INPUT "GN-DIVI",
                        INPUT cLlave,
                        INPUT 'CFG-COT-PED').
      DEF VAR x-Rowid AS ROWID NO-UNDO.
      x-Rowid = ROWID(FacTabla).
      RUN dispatch IN THIS-PROCEDURE ('open-query':U).
      REPOSITION {&browse-name} TO ROWID(x-Rowid) NO-ERROR.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query B-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Carga-Tabla.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available B-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE FacTabla THEN DO WITH FRAME {&FRAME-NAME}:
      DISPLAY 
          logtabla.Usuario @ FILL-IN_Usuario
          STRING(logtabla.Dia, '99/99/9999') + ' ' + SUBSTRING(logtabla.Hora,1,5) @ FILL-IN_FechaHora
          .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-changed B-table-Win 
PROCEDURE local-row-changed :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-changed':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE FacTabla THEN DO WITH FRAME {&FRAME-NAME}:
      DISPLAY 
          logtabla.Usuario @ FILL-IN_Usuario
          STRING(logtabla.Dia, '99/99/9999') + ' ' + SUBSTRING(logtabla.Hora,1,5) @ FILL-IN_FechaHora
          .
  END.

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
  {src/adm/template/snd-list.i "FacTabla"}
  {src/adm/template/snd-list.i "GN-DIVI"}
  {src/adm/template/snd-list.i "logtabla"}

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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

