&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.



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
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR S-CODDIV  AS CHAR.
DEF SHARED VAR cl-codcia AS INT.

DEFINE BUFFER B-ITEM FOR ITEM.

DEFINE SHARED VARIABLE s-adm-new-record AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC  AS CHAR.
DEFINE SHARED VARIABLE s-NroPed AS CHAR.
DEFINE SHARED VARIABLE s-nrodec AS INT INIT 4.
DEFINE SHARED VARIABLE s-flgigv AS LOG.
DEFINE SHARED VARIABLE s-PorIgv LIKE Ccbcdocu.PorIgv.
DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
DEFINE SHARED VARIABLE S-TPOCMB  AS DEC.
DEFINE SHARED VARIABLE s-FlgSit AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CNDVTA  AS CHAR.
DEFINE SHARED VARIABLE s-TpoPed   AS CHAR.
DEFINE SHARED VARIABLE pCodDiv   AS CHAR.       /* División de Precios */
DEFINE SHARED VARIABLE S-FMAPGO  AS CHAR.

DEFINE SHARED VAR s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEFINE SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.

DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE I-NroItm AS INTE NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.
DEFINE VARIABLE f-FleteUnitario AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE x-adm-new-record AS CHAR.
DEFINE VARIABLE S-UNDVTA AS CHAR NO-UNDO.

DEFINE SHARED VAR s-FlgTipoVenta LIKE GN-DIVI.FlgPreVta.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME CodMatbr_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ITEM Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE CodMatbr_table                                */
&Scoped-define FIELDS-IN-QUERY-CodMatbr_table ITEM.codmat ITEM.UndVta ~
ITEM.CanPed ITEM.PreUni ITEM.ImpLin 
&Scoped-define ENABLED-FIELDS-IN-QUERY-CodMatbr_table ITEM.codmat ~
ITEM.UndVta ITEM.CanPed 
&Scoped-define ENABLED-TABLES-IN-QUERY-CodMatbr_table ITEM
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-CodMatbr_table ITEM
&Scoped-define QUERY-STRING-CodMatbr_table FOR EACH ITEM WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF ITEM NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-CodMatbr_table OPEN QUERY CodMatbr_table FOR EACH ITEM WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF ITEM NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-CodMatbr_table ITEM Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-CodMatbr_table ITEM
&Scoped-define SECOND-TABLE-IN-QUERY-CodMatbr_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS CodMatbr_table 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-DesMat FILL-IN-ImpTot 

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
DEFINE VARIABLE EDITOR-DesMat AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 45 BY 5.58
     BGCOLOR 14 FGCOLOR 0 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpTot AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.35
     BGCOLOR 1 FGCOLOR 15 FONT 8 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY CodMatbr_table FOR 
      ITEM, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE CodMatbr_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS CodMatbr_table B-table-Win _STRUCTURED
  QUERY CodMatbr_table NO-LOCK DISPLAY
      ITEM.codmat COLUMN-LABEL "Articulo" FORMAT "X(13)":U WIDTH 13.72
      ITEM.UndVta FORMAT "x(6)":U WIDTH 9.43
      ITEM.CanPed COLUMN-LABEL "Cant." FORMAT ">>>9.99":U WIDTH 11.43
      ITEM.PreUni COLUMN-LABEL "Unit." FORMAT ">>>9.9999":U WIDTH 11.43
      ITEM.ImpLin COLUMN-LABEL "Imp." FORMAT ">>>>9.99":U WIDTH 16.72
  ENABLE
      ITEM.codmat
      ITEM.UndVta
      ITEM.CanPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 70 BY 14.42
         FONT 8 ROW-HEIGHT-CHARS 1.04 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CodMatbr_table AT ROW 1 COL 1
     EDITOR-DesMat AT ROW 15.42 COL 1 NO-LABEL WIDGET-ID 6
     FILL-IN-ImpTot AT ROW 15.62 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 6 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "SHARED" ? INTEGRAL FacDPedi
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
         HEIGHT             = 22.58
         WIDTH              = 79.29.
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
/* BROWSE-TAB CodMatbr_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR EDITOR EDITOR-DesMat IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE CodMatbr_table
/* Query rebuild information for BROWSE CodMatbr_table
     _TblList          = "Temp-Tables.ITEM,INTEGRAL.Almmmatg OF Temp-Tables.ITEM"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.ITEM.codmat
"ITEM.codmat" "Articulo" "X(13)" "character" ? ? ? ? ? ? yes ? no no "13.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ITEM.UndVta
"ITEM.UndVta" ? "x(6)" "character" ? ? ? ? ? ? yes ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ITEM.CanPed
"ITEM.CanPed" "Cant." ">>>9.99" "decimal" ? ? ? ? ? ? yes ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ITEM.PreUni
"ITEM.PreUni" "Unit." ">>>9.9999" "decimal" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ITEM.ImpLin
"ITEM.ImpLin" "Imp." ">>>>9.99" "decimal" ? ? ? ? ? ? no ? no no "16.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE CodMatbr_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME CodMatbr_table
&Scoped-define SELF-NAME CodMatbr_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CodMatbr_table B-table-Win
ON ROW-ENTRY OF CodMatbr_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CodMatbr_table B-table-Win
ON ROW-LEAVE OF CodMatbr_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CodMatbr_table B-table-Win
ON VALUE-CHANGED OF CodMatbr_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}

  IF AVAILABLE Almmmatg THEN RUN Pinta-Datos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM.codmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.codmat CodMatbr_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM.codmat IN BROWSE CodMatbr_table /* Articulo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    IF x-Adm-New-Record = "?" THEN RETURN.
    IF x-Adm-New-Record = "NO" AND AVAILABLE ITEM AND SELF:SCREEN-VALUE = ITEM.CodMat THEN RETURN.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
    IF pCodMat = '' THEN RETURN NO-APPLY.
    SELF:SCREEN-VALUE = pCodMat.
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK.
    IF Almmmatg.Chr__01 = "" THEN DO:
       MESSAGE "Articulo no tiene unidad de Oficina" VIEW-AS ALERT-BOX ERROR.
       SELF:SCREEN-VALUE = ''.
       RETURN NO-APPLY.
    END.
    ASSIGN 
        F-FACTOR = 1
        X-CANPED = 1.
    RUN vta2/PrecioMayorista-Cred-v2 (
        s-TpoPed,
        pCodDiv,
        s-CodCli,
        s-CodMon,
        INPUT-OUTPUT s-UndVta,
        OUTPUT f-Factor,
        ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name},
        s-FmaPgo,
        x-CanPed,
        s-NroDec,
        OUTPUT f-PreBas,
        OUTPUT f-PreVta,
        OUTPUT f-Dsctos,
        OUTPUT y-Dsctos,
        OUTPUT z-Dsctos,
        OUTPUT x-TipDto,
        OUTPUT f-FleteUnitario,
        "",
        TRUE
        ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY 
        s-UndVta @ ITEM.UndVta 
        F-PREVTA @ ITEM.PreUni 
        WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ITEM.CanPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.CanPed CodMatbr_table _BROWSE-COLUMN B-table-Win
ON ENTRY OF ITEM.CanPed IN BROWSE CodMatbr_table /* Cant. */
DO:
  IF x-Adm-New-Record = "YES" THEN SELF:SCREEN-VALUE = "1.00".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ITEM.CanPed CodMatbr_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF ITEM.CanPed IN BROWSE CodMatbr_table /* Cant. */
DO:
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN RETURN.
    ASSIGN
        x-CanPed = DEC(SELF:SCREEN-VALUE)
        s-UndVta = ITEM.UndVta:SCREEN-VALUE IN BROWSE {&browse-name}.
    RUN vta2/PrecioMayorista-Cred-v2 (
        s-TpoPed,
        pCodDiv,
        s-CodCli,
        s-CodMon,
        INPUT-OUTPUT s-UndVta,
        OUTPUT f-Factor,
        ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name},
        s-FmaPgo,
        x-CanPed,
        s-NroDec,
        OUTPUT f-PreBas,
        OUTPUT f-PreVta,
        OUTPUT f-Dsctos,
        OUTPUT y-Dsctos,
        OUTPUT z-Dsctos,
        OUTPUT x-TipDto,
        OUTPUT f-FleteUnitario,
        "",
        TRUE
        ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
    DISPLAY 
        F-PREVTA @ ITEM.PreUni 
        WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

ON 'RETURN':U OF ITEM.CanPed, ITEM.codmat
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Apply-Number B-table-Win 
PROCEDURE Apply-Number :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Apply-Tab B-table-Win 
PROCEDURE Apply-Tab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hSortColumn  AS WIDGET-HANDLE.
    DEFINE VARIABLE hQueryHandle AS HANDLE     NO-UNDO.

    hSortColumn = BROWSE {&BROWSE-NAME}:CURRENT-COLUMN.
    CASE hSortColumn:NAME:
        WHEN "CodMat" THEN DO:
            APPLY 'TAB':U TO ITEM.CodMat IN BROWSE {&BROWSE-NAME}.
        END.
        WHEN "CanPed" THEN DO:
            APPLY 'TAB':U TO ITEM.CanPed IN BROWSE {&BROWSE-NAME}.
        END.
    END CASE.

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
    FILL-IN-ImpTot = 0.
FOR EACH B-ITEM:
    FILL-IN-ImpTot = FILL-IN-ImpTot + B-ITEM.ImpLin.
END.
DISPLAY FILL-IN-ImpTot WITH FRAME {&FRAME-NAME}.

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
  IF s-CodCli = '' THEN DO:
      MESSAGE 'Debe ingresar el CLIENTE' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  IF s-CndVta = '' THEN DO:
      MESSAGE 'Debe ingresar la CONDICION DE VENTA' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  I-NroItm = 0.  
  DEFINE VARIABLE N-ITMS AS INTEGER INIT 0 NO-UNDO.
  FOR EACH B-ITEM BY B-ITEM.NroItm:
      N-ITMS = N-ITMS + 1.
      I-NroItm = B-ITEM.NroItm.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ASSIGN
      I-NroItm = I-NroItm + 1
      s-UndVta = ""
      x-Adm-New-Record = "YES".
  RUN Procesa-Handle IN lh_handle ('Disable-Head').
  APPLY 'ENTRY':U TO ITEM.codmat IN BROWSE {&browse-name}.

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
  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
      AND Almmmatg.codmat = ITEM.codmat:SCREEN-VALUE IN BROWSE {&browse-name}
      NO-LOCK NO-ERROR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND Almtconv.Codalter = ITEM.UndVta
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almtconv THEN DO:
      MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat
          'Unidad de venta:' ITEM.UndVta SKIP
          'Grabación abortada'
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.UndVta IN BROWSE {&browse-name}.
      UNDO, RETURN "ADM-ERROR".
  END.
  F-FACTOR = Almtconv.Equival.
  ASSIGN 
      ITEM.CodCia = S-CODCIA
      ITEM.AlmDes = s-CodAlm
      ITEM.Factor = F-FACTOR
      ITEM.NroItm = I-NroItm
      ITEM.PorDto = f-Dsctos
      ITEM.PreBas = F-PreBas 
      ITEM.PreVta[1] = F-PreVta     /* CONTROL DE PRECIO DE LISTA */
      ITEM.AftIgv = Almmmatg.AftIgv
      ITEM.AftIsc = Almmmatg.AftIsc
      ITEM.Libre_c04 = x-TipDto.
  ASSIGN 
      ITEM.PreUni = f-PreVta
      ITEM.Por_Dsctos[1] = 0
      ITEM.Por_Dsctos[2] = z-Dsctos
      ITEM.Por_Dsctos[3] = y-Dsctos
      ITEM.Libre_d02     = f-FleteUnitario.
  ASSIGN
      ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                    ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
  IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
      THEN ITEM.ImpDto = 0.
      ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
  /* RHC 04/08/2015 Si existe f-FleteUnitario se recalcula el Descuento */
  IF f-FleteUnitario > 0 THEN DO:
      /* El flete afecta el monto final */
      IF ITEM.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
          ASSIGN
              ITEM.PreUni = ROUND(f-PreVta + f-FleteUnitario, s-NroDec)  /* Incrementamos el PreUni */
              ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni.
      END.
      ELSE DO:      /* CON descuento promocional o volumen */
          ASSIGN
              ITEM.ImpLin = ITEM.ImpLin + (ITEM.CanPed * f-FleteUnitario)
              ITEM.PreUni = ROUND( (ITEM.ImpLin + ITEM.ImpDto) / ITEM.CanPed, s-NroDec).
      END.
  END.
  /* ***************************************************************** */

  ASSIGN
      ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
      ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
  IF ITEM.AftIsc 
  THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
  ELSE ITEM.ImpIsc = 0.
  IF ITEM.AftIgv 
  THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
  ELSE ITEM.ImpIgv = 0.

  IF ITEM.PreUni = 0 THEN DO:
       MESSAGE "Precio debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM.CodMat.
       UNDO, RETURN "ADM-ERROR".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record B-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  x-adm-new-record = "?".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Enable-Head').

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
  RUN Procesa-Handle IN lh_handle ('Enable-Head').
  RUN Imp-Total.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields B-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE Almmmatg THEN RUN Pinta-Datos.

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
  ITEM.UndVta:READ-ONLY IN BROWSE {&BROWSE-NAME} = YES.
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = "NO" THEN APPLY 'ENTRY':U TO ITEM.CodMat IN BROWSE {&BROWSE-NAME}.

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
  DEF VAR x-adm-new-record AS CHAR.
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  x-adm-new-record = RETURN-VALUE.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Imp-Total.
  RUN Procesa-Handle IN lh_handle ('Enable-Head').
  IF x-adm-new-record = "YES" THEN RUN Procesa-Handle IN lh_handle ('Add-Record').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta-Datos B-table-Win 
PROCEDURE Pinta-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    EDITOR-DesMat:SCREEN-VALUE  = "DESCRIPCIÓN: " + Almmmatg.desmat + CHR(10).
    /* Mínimo de ventas */
    EDITOR-DesMat:SCREEN-VALUE  = EDITOR-DesMat:SCREEN-VALUE + "MÍNIMO DE VENTAS: " + STRING(Almmmatg.DEC__03) + CHR(10).
    /* Empaque Master */
    EDITOR-DesMat:SCREEN-VALUE  = EDITOR-DesMat:SCREEN-VALUE + "EMPAQUE MASTER: " + STRING(Almmmatg.CanEmp).
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalcular-Precios B-table-Win 
PROCEDURE Recalcular-Precios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH ITEM WHERE ITEM.Libre_c05 <> "OF",     /* NO promociones */
    FIRST Almmmatg OF ITEM NO-LOCK:
    ASSIGN
        F-FACTOR = ITEM.Factor
        f-PreVta = ITEM.PreUni
        f-PreBas = ITEM.PreBas
        f-Dsctos = ITEM.PorDto
        z-Dsctos = ITEM.Por_Dsctos[2]
        y-Dsctos = ITEM.Por_Dsctos[3].
    DISPLAY ITEM.codmat ITEM.undvta ITEM.canped ITEM.almdes
        s-codcia s-coddiv s-codcli s-codmon s-tpocmb s-flgsit s-nrodec WITH 1 COL.
    RUN vta2/PrecioMayorista-Cont-v2 (s-CodCia,
                                   s-CodDiv,
                                   s-CodCli,
                                   s-CodMon,
                                   s-TpoCmb,
                                   OUTPUT f-Factor,
                                   ITEM.codmat,
                                   s-FlgSit,
                                   ITEM.undvta,
                                   ITEM.CanPed,
                                   s-NroDec,
                                   ITEM.almdes,   /* Necesario para REMATES */
                                   OUTPUT f-PreBas,
                                   OUTPUT f-PreVta,
                                   OUTPUT f-Dsctos,
                                   OUTPUT y-Dsctos,
                                   OUTPUT x-TipDto,
                                   OUTPUT f-FleteUnitario
                                   ).
    MESSAGE ITEM.codmat ITEM.preuni ITEM.canped ITEM.implin.
    ASSIGN 
        ITEM.Factor = f-Factor
        ITEM.PreUni = F-PREVTA
        ITEM.PreBas = F-PreBas 
        ITEM.PorDto = F-DSCTOS  /* Ambos descuentos afectan */
        ITEM.PorDto2 = 0        /* el precio unitario */
        ITEM.Por_Dsctos[2] = z-Dsctos
        ITEM.Por_Dsctos[3] = Y-DSCTOS 
        ITEM.AftIgv = Almmmatg.AftIgv
        ITEM.AftIsc = Almmmatg.AftIsc
        ITEM.ImpIsc = 0
        ITEM.ImpIgv = 0.
    ASSIGN
        ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                    ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
    IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
        THEN ITEM.ImpDto = 0.
    ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
    /* RHC 04/08/2015 Si existe f-FleteUnitario se recalcula el Descuento */
    IF f-FleteUnitario > 0 THEN DO:
        /* El flete afecta el monto final */
        IF ITEM.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
            ASSIGN
                ITEM.PreUni = ROUND(f-PreVta + f-FleteUnitario, s-NroDec)  /* Incrementamos el PreUni */
                ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni.
        END.
        ELSE DO:      /* CON descuento promocional o volumen */
            ASSIGN
                ITEM.ImpLin = ITEM.ImpLin + (ITEM.CanPed * f-FleteUnitario)
                ITEM.PreUni = ROUND( (ITEM.ImpLin + ITEM.ImpDto) / ITEM.CanPed, s-NroDec).
        END.
    END.
    /* ***************************************************************** */
    ASSIGN
        ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
        ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
    IF ITEM.AftIsc THEN 
        ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
    ELSE ITEM.ImpIsc = 0.
    IF ITEM.AftIgv THEN  
        ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (s-PorIgv / 100)),4).
    ELSE ITEM.ImpIgv = 0.
END.

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
  {src/adm/template/snd-list.i "ITEM"}
  {src/adm/template/snd-list.i "Almmmatg"}

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

  /* PRODUCTO */  
  IF ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''
    OR INTEGER(ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) = 0 THEN DO:
       MESSAGE "Codigo de Producto no puede ser blanco" VIEW-AS ALERT-BOX ERROR.
       APPLY 'ENTRY':U TO ITEM.CodMat.
       RETURN "ADM-ERROR".
  END.
  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
      AND Almmmatg.codmat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
      MESSAGE 'Código de producto NO registrado' VIEW-AS ALERT-BOX ERROR.
      ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  IF Almmmatg.TpoArt = "D" THEN DO:
      MESSAGE 'Código de producto DESACTIVADO' VIEW-AS ALERT-BOX ERROR.
      ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA 
      AND  Almmmate.CodAlm = s-codalm
      AND  Almmmate.codmat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmate THEN DO:
      MESSAGE "Articulo no asignado al almacén " s-codalm
           VIEW-AS ALERT-BOX ERROR.
      ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  /* FAMILIA DE VENTAS */
  FIND Almtfami OF Almmmatg NO-LOCK NO-ERROR.
  IF AVAILABLE Almtfami AND 
      Almtfami.SwComercial = NO THEN DO:
      MESSAGE 'Línea NO autorizada para ventas' VIEW-AS ALERT-BOX ERROR.
      ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  FIND Almsfami OF Almmmatg NO-LOCK NO-ERROR.
  IF AVAILABLE Almsfami AND 
      AlmSFami.SwDigesa = YES AND 
      Almmmatg.VtoDigesa <> ? AND 
      Almmmatg.VtoDigesa < TODAY THEN DO:
      MESSAGE 'Producto con autorización de DIGESA VENCIDA' VIEW-AS ALERT-BOX ERROR.
      ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  /* ARTICULO */
  DEF VAR pCodMat AS CHAR.
  pCodMat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}.
  RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).
  IF RETURN-VALUE = "ADM-ERROR" THEN DO:
      ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN "ADM-ERROR".
  END.
  /* RHC 21/08/2012 CONTROL POR TIPO DE PRODUCTO */
  IF Almmmatg.TpoMrg = "1" AND s-FlgTipoVenta = NO THEN DO:
      MESSAGE "No se puede vender este producto al por menor"
          VIEW-AS ALERT-BOX ERROR.
      ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN 'ADM-ERROR'.
  END.
  IF Almmmatg.TpoMrg = "2" AND s-FlgTipoVenta = YES THEN DO:
      MESSAGE "No se puede vender este producto al por mayor"
          VIEW-AS ALERT-BOX ERROR.
      ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
      APPLY 'ENTRY':U TO ITEM.CodMat.
      RETURN 'ADM-ERROR'.
  END.
  /* ********************************************* */
  /* UNIDAD */
  IF ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = "" THEN DO:
       MESSAGE "NO tiene registrado la unidad de venta" VIEW-AS ALERT-BOX ERROR.
       ITEM.CodMat:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} = ''.
       APPLY 'ENTRY':U TO ITEM.CodMat.
       RETURN "ADM-ERROR".
  END.
  /* CANTIDAD */
  IF ITEM.UndVta:SCREEN-VALUE IN BROWSE {&browse-name} = "UNI" 
      AND DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) -
            TRUNCATE(DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}), 0) <> 0
      THEN DO:
      MESSAGE "NO se permiten ventas fraccionadas" VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.CanPed.
      RETURN "ADM-ERROR".
  END.
  /* FACTOR DE EQUIVALENCIA */
  FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
      AND Almtconv.Codalter = ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almtconv THEN DO:
      MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
          'Unidad de venta:' ITEM.UndVta:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO ITEM.UndVta.
      RETURN "ADM-ERROR".
  END.
  F-FACTOR = Almtconv.Equival.

  /* STOCK COMPROMETIDO */
/*   DEF VAR s-StkComprometido AS DEC NO-UNDO.                                                                     */
/*   DEF VAR x-StkAct AS DEC NO-UNDO.                                                                              */
/*                                                                                                                 */
/*   RUN vta2/Stock-Comprometido-v2 (ITEM.CodMat:SCREEN-VALUE IN BROWSE {&browse-name},                            */
/*                                 s-codalm,                                                                       */
/*                                 OUTPUT s-StkComprometido).                                                      */
/*   IF s-adm-new-record = 'NO' THEN DO:                                                                           */
/*       FIND Facdpedi WHERE Facdpedi.codcia = s-codcia                                                            */
/*           AND Facdpedi.coddoc = s-coddoc                                                                        */
/*           AND Facdpedi.nroped = s-nroped                                                                        */
/*           AND Facdpedi.codmat = ITEM.CodMat:SCREEN-VALUE IN BROWSE {&browse-name}                               */
/*           NO-LOCK NO-ERROR.                                                                                     */
/*       IF AVAILABLE Facdpedi THEN s-StkComprometido = s-StkComprometido - ( Facdpedi.CanPed * Facdpedi.Factor ). */
/*   END.                                                                                                          */
/*   ASSIGN                                                                                                        */
/*       x-CanPed = DEC(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&BROWSE-NAME}) * f-Factor                              */
/*       x-StkAct = Almmmate.StkAct.                                                                               */
/*   IF (x-StkAct - s-StkComprometido) < x-CanPed                                                                  */
/*       THEN DO:                                                                                                  */
/*         MESSAGE "No hay STOCK suficiente" SKIP(1)                                                               */
/*                 "       STOCK ACTUAL : " x-StkAct Almmmatg.undbas SKIP                                          */
/*                 "  STOCK COMPROMETIDO: " s-StkComprometido Almmmatg.undbas SKIP                                 */
/*                 "   STOCK DISPONIBLE : " (x-StkAct - s-StkComprometido) Almmmatg.undbas SKIP                    */
/*                 VIEW-AS ALERT-BOX ERROR.                                                                        */
/*         APPLY 'ENTRY':U TO ITEM.CanPed.                                                                         */
/*         RETURN "ADM-ERROR".                                                                                     */
/*   END.                                                                                                          */

  /* EMPAQUE */
  DEF VAR f-Canped AS DEC NO-UNDO.
  IF s-FlgEmpaque = YES THEN DO:
      f-CanPed = DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.
      /* RHC solo se va a trabajar con una lista general */
      IF Almmmatg.DEC__03 > 0 THEN DO:
          f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).
          IF f-CanPed <> DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor THEN DO:
              MESSAGE 'Solo puede vender en empaques de' Almmmatg.DEC__03 Almmmatg.UndBas
                  VIEW-AS ALERT-BOX ERROR.
              APPLY 'ENTRY':U TO ITEM.CanPed.
              RETURN "ADM-ERROR".
          END.
      END.
  END.
  /* MINIMO DE VENTA */
  IF s-FlgMinVenta = YES THEN DO:
      f-CanPed = DECIMAL(ITEM.CanPed:SCREEN-VALUE IN BROWSE {&browse-name}) * f-Factor.
      IF s-VentaMayorista = 2 THEN DO:  /* LISTA POR DIVISION */
          FIND FIRST VtaListaMay OF Almmmatg WHERE Vtalistamay.coddiv = s-coddiv NO-LOCK NO-ERROR.
          IF AVAILABLE VtaListaMay AND Vtalistamay.CanEmp > 0 THEN DO:
              IF f-CanPed < Vtalistamay.CanEmp THEN DO:
                  MESSAGE 'Solo puede vender como mínimo' Vtalistamay.CanEmp Almmmatg.UndBas
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO ITEM.CanPed.
                  RETURN "ADM-ERROR".
              END.
          END.
      END.
      ELSE DO:      /* LISTA GENERAL */
          IF Almmmatg.DEC__03 > 0 THEN DO:
              IF f-CanPed < Almmmatg.DEC__03 THEN DO:
                  MESSAGE 'Solo puede vender como mínimo' Almmmatg.DEC__03 Almmmatg.UndBas
                      VIEW-AS ALERT-BOX ERROR.
                  APPLY 'ENTRY':U TO ITEM.CanPed.
                  RETURN "ADM-ERROR".
              END.
          END.
      END.
  END.
  /* ************************************** */
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

IF AVAILABLE ITEM THEN 
    ASSIGN
    i-nroitm = ITEM.NroItm
    f-Factor = ITEM.Factor
    f-PreBas = ITEM.PreBas
    f-PreVta = ITEM.PreUni
    s-UndVta = ITEM.UndVta
    x-TipDto = ITEM.Libre_c04
    x-Adm-New-Record = "NO".
RUN Procesa-Handle IN lh_handle ('Disable-Head').

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

