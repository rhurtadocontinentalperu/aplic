&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE MVTO LIKE CcbDMvto.



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

DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE SHARED VARIABLE S-TPOCMB   AS DECIMAL.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CONDIC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.

DEFINE BUFFER B-MVTO FOR MVTO.

DEFINE VAR C-MON  AS CHAR EXTENT 2 NO-UNDO.
ASSIGN
    C-MON[1] = "S/." 
    C-MON[2] = "US$" .

DEFINE VAR x-fill-combo AS LOG INIT YES.
DEFINE VAR x-Doc-Valido AS CHAR INIT 'FAC,N/D' NO-UNDO.

DEFINE VAR x-tabla-factabla AS CHAR INIT "TD-CANJE".

DEFINE SHARED VAR lh_handle AS HANDLE.

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
&Scoped-define INTERNAL-TABLES MVTO CcbCDocu

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table MVTO.CodRef MVTO.NroRef ~
CcbCDocu.FchDoc CcbCDocu.FmaPgo C-MON[CcbCDocu.CodMon] CcbCDocu.ImpTot ~
CcbCDocu.SdoAct C-MON[s-CodMon] MVTO.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table MVTO.CodRef MVTO.NroRef ~
MVTO.ImpTot 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table MVTO
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table MVTO
&Scoped-define QUERY-STRING-br_table FOR EACH MVTO WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH CcbCDocu WHERE CcbCDocu.CodCia = MVTO.CodCia ~
  AND CcbCDocu.CodDoc = MVTO.CodRef ~
  AND CcbCDocu.NroDoc = MVTO.NroRef NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH MVTO WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH CcbCDocu WHERE CcbCDocu.CodCia = MVTO.CodCia ~
  AND CcbCDocu.CodDoc = MVTO.CodRef ~
  AND CcbCDocu.NroDoc = MVTO.NroRef NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table MVTO CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-br_table MVTO
&Scoped-define SECOND-TABLE-IN-QUERY-br_table CcbCDocu


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table BUTTON-1 
&Scoped-Define DISPLAYED-OBJECTS F-ImpTot 

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
DEFINE BUTTON BUTTON-1 
     LABEL "ASIGNAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE F-ImpTot AS DECIMAL FORMAT "(ZZ,ZZZ,ZZ9.99)":U INITIAL 0 
     LABEL "Importe Total" 
     VIEW-AS FILL-IN 
     SIZE 17.57 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      MVTO, 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      MVTO.CodRef FORMAT "x(3)":U WIDTH 6.43 VIEW-AS COMBO-BOX INNER-LINES 5
                      LIST-ITEMS "Ninguno" 
                      DROP-DOWN-LIST 
      MVTO.NroRef FORMAT "X(12)":U WIDTH 9.57 COLUMN-FGCOLOR 1 COLUMN-BGCOLOR 11
      CcbCDocu.FchDoc COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
      CcbCDocu.FmaPgo COLUMN-LABEL "Condición!de Venta" FORMAT "X(8)":U
            WIDTH 8.29
      C-MON[CcbCDocu.CodMon] COLUMN-LABEL "Moneda!Origen"
      CcbCDocu.ImpTot COLUMN-LABEL "Total del Documento" FORMAT "->>,>>>,>>9.99":U
      CcbCDocu.SdoAct COLUMN-LABEL "Saldo Actual" FORMAT "->>,>>>,>>9.99":U
      C-MON[s-CodMon] COLUMN-LABEL "Moneda!Canje"
      MVTO.ImpTot COLUMN-LABEL "Importe Canjeado" FORMAT "(>>,>>>,>>9.99)":U
            COLUMN-FGCOLOR 1 COLUMN-BGCOLOR 11
  ENABLE
      MVTO.CodRef
      MVTO.NroRef
      MVTO.ImpTot
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 91 BY 5.19
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.08 COL 1.14
     BUTTON-1 AT ROW 6.19 COL 3 WIDGET-ID 2
     F-ImpTot AT ROW 6.38 COL 70 COLON-ALIGNED WIDGET-ID 4
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
   Temp-Tables and Buffers:
      TABLE: MVTO T "SHARED" ? INTEGRAL CcbDMvto
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
         HEIGHT             = 6.85
         WIDTH              = 107.86.
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

/* SETTINGS FOR FILL-IN F-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.MVTO,INTEGRAL.CcbCDocu WHERE Temp-Tables.MVTO ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _JoinCode[2]      = "INTEGRAL.CcbCDocu.CodCia = Temp-Tables.MVTO.CodCia
  AND INTEGRAL.CcbCDocu.CodDoc = Temp-Tables.MVTO.CodRef
  AND INTEGRAL.CcbCDocu.NroDoc = Temp-Tables.MVTO.NroRef"
     _FldNameList[1]   > Temp-Tables.MVTO.CodRef
"MVTO.CodRef" ? ? "character" ? ? ? ? ? ? yes ? no no "6.43" yes no no "U" "" "" "DROP-DOWN-LIST" "," "Ninguno" ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.MVTO.NroRef
"MVTO.NroRef" ? ? "character" 11 1 ? ? ? ? yes ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.CcbCDocu.FchDoc
"CcbCDocu.FchDoc" "Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.CcbCDocu.FmaPgo
"CcbCDocu.FmaPgo" "Condición!de Venta" ? "character" ? ? ? ? ? ? no ? no no "8.29" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"C-MON[CcbCDocu.CodMon]" "Moneda!Origen" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CcbCDocu.ImpTot
"CcbCDocu.ImpTot" "Total del Documento" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > INTEGRAL.CcbCDocu.SdoAct
"CcbCDocu.SdoAct" "Saldo Actual" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"C-MON[s-CodMon]" "Moneda!Canje" ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.MVTO.ImpTot
"MVTO.ImpTot" "Importe Canjeado" "(>>,>>>,>>9.99)" "decimal" 11 1 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME MVTO.NroRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL MVTO.NroRef br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF MVTO.NroRef IN BROWSE br_table /* Numero */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
      AND Ccbcdocu.coddoc =  MVTO.CodRef:SCREEN-VALUE IN BROWSE {&browse-name}
      AND Ccbcdocu.nrodoc = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF AVAILABLE Ccbcdocu THEN DO:
      DISPLAY
          CcbCDocu.FchDoc 
          CcbCDocu.ImpTot
          CcbCDocu.SdoAct
          c-Mon[Ccbcdocu.codmon]
          Ccbcdocu.sdoact @ MVTO.ImpTot
          WITH BROWSE {&browse-name}.
      IF CcbCDocu.CodMon = S-CODMON 
          THEN DISPLAY CcbCDocu.SdoAct @ MVTO.ImpTot WITH BROWSE {&browse-name}.
      ELSE DO:
          IF CcbCDocu.CodMon = 1 
              THEN DISPLAY (CcbCDocu.SdoAct / S-TPOCMB) @ MVTO.ImpTot WITH BROWSE {&browse-name}.
          ELSE DISPLAY (CcbCDocu.SdoAct * S-TPOCMB) @ MVTO.ImpTot WITH BROWSE {&browse-name}.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 B-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* ASIGNAR */
DO:
    /*input-var-1 = "FAC,BOL,N/D,LET,N/C".*/


    IF x-Doc-Valido = "" THEN DO:
        FOR EACH factabla WHERE factabla.codcia = s-codcia AND
                                    factabla.tabla = x-tabla-factabla NO-LOCK:

            IF (TODAY >= factabla.campo-d[1] AND TODAY <= factabla.campo-d[2]) THEN DO:

                IF x-Doc-Valido <> "" THEN x-Doc-Valido = x-Doc-Valido + ",".
                x-Doc-Valido = x-Doc-Valido + TRIM(factabla.codigo).
            END.
        END.

    END.


    input-var-1 = x-Doc-Valido.     /*"FAC,BOL,N/D,LET".*/
    input-var-2 = S-CODCLI.
    input-var-3 = 'P'.

    RUN lkup\C-ADocFl("Documento Pendientes").
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RUN Imp-Total.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON ENTRY OF MVTO.codref IN BROWSE br_table DO:
    /**/
    DEFINE VARIABLE hColumn AS HANDLE      NO-UNDO.
    DEFINE VAR cColumnName AS CHAR.

    ASSIGN hColumn = SELF:HANDLE.
    cColumnName = CAPS(hColumn:NAME).     

    IF x-fill-combo = YES THEN DO:

        x-Doc-Valido = "".

        /* Eliminar lo anterior definidos */
            REPEAT WHILE hColumn:NUM-ITEMS > 0:
                hColumn:DELETE(1).
            END.

        FOR EACH factabla WHERE factabla.codcia = s-codcia AND
                                    factabla.tabla = x-tabla-factabla NO-LOCK:

            IF (TODAY >= factabla.campo-d[1] AND TODAY <= factabla.campo-d[2]) THEN DO:

                /* Solo los Vigentes */
                RUN AddComboItem(INPUT hColumn,TRIM(factabla.codigo),"").

                IF SELF:SCREEN-VALUE = '' THEN SELF:SCREEN-VALUE = TRIM(factabla.codigo).

                IF x-Doc-Valido <> "" THEN x-Doc-Valido = x-Doc-Valido + ",".
                x-Doc-Valido = x-Doc-Valido + TRIM(factabla.codigo).
            END.
        END.
        
    END.    
    x-fill-combo = NO.
      
END.

PROCEDURE AddComboItem :
/*------------------------------------------------------------------------------
  Purpose:     add an item to the combo-box. Each item can be associated with 
               itemdata (is low-level implementation of PRIVATE-DATA).
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER ip_hCombobox AS HANDLE  NO-UNDO.
  DEFINE INPUT PARAMETER ip_ItemText  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER ip_ItemData  AS INTEGER NO-UNDO.
 
  DEFINE VARIABLE lpString AS MEMPTR  NO-UNDO.
  DEFINE VARIABLE SelIndex AS INTEGER NO-UNDO.
  DEFINE VARIABLE retval   AS INTEGER NO-UNDO.
 
  SET-SIZE(lpString)     = 0.
  SET-SIZE(lpString)     = LENGTH(ip_ItemText) + 1.
  PUT-STRING(lpString,1) = ip_ItemText.
 
  RUN SendMessageA (ip_hCombobox:HWND,
                    323, /* = CB_ADSTRING */
                    0,
                    GET-POINTER-VALUE(lpString),
                    OUTPUT selIndex) NO-ERROR.
 
  RUN SendMessageA (ip_hCombobox:HWND  ,
                    337, /* = CB_SETITEMDATA */
                    SelIndex,
                    ip_ItemData,
                    OUTPUT retval) NO-ERROR.
  SET-SIZE(lpString)=0.
 
  RETURN.
END PROCEDURE.

PROCEDURE SendMessageA EXTERNAL "user32.dll":
    DEFINE INPUT PARAMETER hwnd AS LONG.
    DEFINE INPUT PARAMETER umsg AS LONG.
    DEFINE INPUT PARAMETER wparam AS LONG.
    DEFINE INPUT PARAMETER lparam AS LONG.
    DEFINE OUTPUT PARAMETER lRetval AS LONG.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imp-Total B-table-Win 
PROCEDURE Imp-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN 
    F-ImpTot = 0
    s-Condic = "".
FOR EACH B-MVTO WHERE B-MVTO.CodCia = S-CODCIA 
    AND B-MVTO.TpoRef = 'O',
    FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.coddoc = B-MVTO.codref
    AND Ccbcdocu.nrodoc = B-MVTO.nroref:
    ASSIGN
        s-Condic = CcbCDocu.FmaPgo
        F-ImpTot = F-ImpTot + (IF Ccbcdocu.coddoc = "N/C" THEN -1 ELSE 1 ) * B-MVTO.ImpTot.
END.
DISPLAY F-ImpTot WITH FRAME {&FRAME-NAME}.

/* RHC 21/07/2021: OJO >>> Si hay un importe NO se pueda modificar la 
moneda ni el tipo de cambio del canje */
IF f-ImpTot > 0 THEN RUN Procesa-Handle IN lh_handle ('disable-moneda').
ELSE RUN Procesa-Handle IN lh_handle ('enable-moneda').

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
  IF s-codcli = "" THEN DO:
      MESSAGE "Primero debe ingresar el cliente" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
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
      MVTO.CodCia = S-CODCIA
      MVTO.Coddoc = s-coddoc
      MVTO.TpoRef = 'O'.

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Imp-Total.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Imp-Total.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields B-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  RUN Procesa-Handle IN lh_handle ('enable-header').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields B-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  BUTTON-1:SENSITIVE IN FRAME {&FRAME-NAME}  = NO.
  RUN Procesa-Handle IN lh_handle ('disable-header').

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Imp-Total.

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
  {src/adm/template/snd-list.i "MVTO"}
  {src/adm/template/snd-list.i "CcbCDocu"}

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

   IF MVTO.CodRef:SCREEN-VALUE IN BROWSE {&browse-name} = "" THEN DO:
       MESSAGE "Ingrese el número del documento"
           VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY":U TO MVTO.CodRef IN BROWSE {&browse-name}.
       RETURN "ADM-ERROR".
   END.
   IF LOOKUP(MVTO.CodRef:SCREEN-VALUE IN BROWSE {&browse-name}, x-Doc-Valido) = 0
       THEN DO:
       MESSAGE 'Documento no válido' VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY":U TO MVTO.CodRef IN BROWSE {&browse-name}.
       RETURN "ADM-ERROR".
   END.
   FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia 
       AND CcbCDocu.CodCli = s-codcli 
       AND CcbCDocu.CodDoc = MVTO.CodRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
       AND CcbCDocu.NroDoc = MVTO.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} 
       NO-LOCK NO-ERROR.
   IF NOT AVAILABLE CcbCDocu THEN DO:
      MESSAGE 'Documento no válido' VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY":U TO MVTO.CodRef IN BROWSE {&browse-name}.
      RETURN "ADM-ERROR".
   END.
   IF CcbCDocu.FlgEst <> "P" THEN DO:
      MESSAGE 'NO se puede canjear si no está pendiente de pago' VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY":U TO MVTO.CodRef IN BROWSE {&browse-name}.
      RETURN "ADM-ERROR".
   END.
   IF S-CONDIC = '' AND Ccbcdocu.CodDoc <> "N/C" THEN S-CONDIC = CcbCDocu.FmaPgo.
   IF Ccbcdocu.CodDoc <> "N/C" AND CcbCDocu.FmaPgo <> S-CONDIC THEN DO:
      MESSAGE 'El documento no corresponde a la condicion' SKIP
              'crediticia ' + S-CONDIC VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY":U TO MVTO.CodRef IN BROWSE {&browse-name}.
      RETURN "ADM-ERROR".
   END.
      
   IF DECIMAL(MVTO.ImpTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
      MESSAGE "Documento con importe igual a cero" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY":U TO MVTO.CodRef IN BROWSE {&browse-name}.
      RETURN "ADM-ERROR".
   END.
      
   DEF VAR x-ImpTot AS DEC NO-UNDO.
   IF CcbCDocu.CodMon = S-CODMON THEN x-ImpTot = CcbCDocu.SdoAct.
   ELSE DO:
      IF CcbCDocu.CodMon = 1 THEN x-ImpTot = (CcbCDocu.SdoAct / S-TPOCMB).
      ELSE x-ImpTot = (CcbCDocu.SdoAct * S-TPOCMB).
   END.
   IF DECIMAL(MVTO.ImpTot:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) > x-ImpTot THEN DO:
      MESSAGE "El importe no puede ser mayor a" x-ImpTot VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY":U TO MVTO.ImpTot IN BROWSE {&browse-name}.
      RETURN "ADM-ERROR".
   END.

   /* RHC 13/07/2017 VENTAS ANTICIPADAS */
   IF LOOKUP(Ccbcdocu.coddoc, 'FAC,BOL') > 0 AND Ccbcdocu.TpoFac = "A" THEN DO:
       MESSAGE 'Este comprobante es un ANTICIPO DE CAMPAÑA' SKIP
           'No se puede hacer un canje por letra' VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY":U TO MVTO.CodRef IN BROWSE {&browse-name}.
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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

