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
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.

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
&Scoped-define INTERNAL-TABLES VtaCatVenta gn-prov

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table VtaCatVenta.CodPro gn-prov.NomPro 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table VtaCatVenta.CodPro 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table VtaCatVenta
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table VtaCatVenta
&Scoped-define QUERY-STRING-br_table FOR EACH VtaCatVenta WHERE ~{&KEY-PHRASE} ~
      AND VtaCatVenta.CodCia = s-codcia ~
 AND VtaCatVenta.CodDiv = COMBO-BOX-Division NO-LOCK, ~
      EACH gn-prov WHERE gn-prov.CodPro = VtaCatVenta.CodPro ~
      AND gn-prov.CodCia = pv-codcia NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH VtaCatVenta WHERE ~{&KEY-PHRASE} ~
      AND VtaCatVenta.CodCia = s-codcia ~
 AND VtaCatVenta.CodDiv = COMBO-BOX-Division NO-LOCK, ~
      EACH gn-prov WHERE gn-prov.CodPro = VtaCatVenta.CodPro ~
      AND gn-prov.CodCia = pv-codcia NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table VtaCatVenta gn-prov
&Scoped-define FIRST-TABLE-IN-QUERY-br_table VtaCatVenta
&Scoped-define SECOND-TABLE-IN-QUERY-br_table gn-prov


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Division br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Division 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fMov B-table-Win 
FUNCTION fMov RETURNS LOGICAL
  ( INPUT pCodPro AS CHAR,
    INPUT pNroPag AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-Division AS CHARACTER FORMAT "X(256)":U 
     LABEL "Canal de Venta" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 55 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      VtaCatVenta, 
      gn-prov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      VtaCatVenta.CodPro COLUMN-LABEL "Proveedor" FORMAT "x(11)":U
      gn-prov.NomPro FORMAT "x(50)":U WIDTH 51.14
  ENABLE
      VtaCatVenta.CodPro
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 68 BY 6.69
         FONT 4
         TITLE "Proveedores" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     COMBO-BOX-Division AT ROW 1.19 COL 12 COLON-ALIGNED WIDGET-ID 32
     br_table AT ROW 2.35 COL 1
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
         HEIGHT             = 8.5
         WIDTH              = 82.72.
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
/* BROWSE-TAB br_table COMBO-BOX-Division F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.VtaCatVenta,INTEGRAL.gn-prov WHERE INTEGRAL.VtaCatVenta  ..."
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "INTEGRAL.VtaCatVenta.CodCia = s-codcia
 AND INTEGRAL.VtaCatVenta.CodDiv = COMBO-BOX-Division"
     _JoinCode[2]      = "INTEGRAL.gn-prov.CodPro = INTEGRAL.VtaCatVenta.CodPro"
     _Where[2]         = "INTEGRAL.gn-prov.CodCia = pv-codcia"
     _FldNameList[1]   > INTEGRAL.VtaCatVenta.CodPro
"VtaCatVenta.CodPro" "Proveedor" ? "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.gn-prov.NomPro
"gn-prov.NomPro" ? ? "character" ? ? ? ? ? ? no ? no no "51.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* Proveedores */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* Proveedores */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* Proveedores */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Division
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Division B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Division IN FRAME F-Main /* Canal de Venta */
DO:
  ASSIGN {&self-name}.
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Disable-Columns B-table-Win 
PROCEDURE Disable-Columns :
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
    IF hColumn:LABEL = 'Proveedor' THEN hColumn:READ-ONLY = TRUE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Eliminar-Seleccionado B-table-Win 
PROCEDURE Eliminar-Seleccionado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE VtaCatVenta THEN RETURN.

DEF VAR pMensaje AS CHAR NO-UNDO.

DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    FIND CURRENT VtaCatVenta EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    {lib/mensaje-de-error.i &MensajeError="pMensaje"}
    FOR EACH AlmCatVtaC OF VtaCatVenta EXCLUSIVE-LOCK:
        FOR EACH AlmCatVtaD OF AlmCatVtaC EXCLUSIVE-LOCK:
            DELETE AlmcatVtaD.
        END.
        DELETE AlmCatVtaC.
    END.
    DELETE VtaCatVenta.
END.
RELEASE VtaCatVenta.
RELEASE AlmCatVtaC.
RELEASE AlmCatVtaD.

IF pMensaje > ''  THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Eliminar-Todos B-table-Win 
PROCEDURE Eliminar-Todos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE('GENERAL').                                                        
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    FOR EACH VtaCatVenta EXCLUSIVE-LOCK WHERE VtaCatVenta.CodCia = s-codcia
        AND VtaCatVenta.CodDiv = COMBO-BOX-Division:
        FOR EACH AlmCatVtaC OF VtaCatVenta EXCLUSIVE-LOCK:
            FOR EACH AlmCatVtaD OF AlmCatVtaC EXCLUSIVE-LOCK:
                DELETE AlmcatVtaD.
            END.
            DELETE AlmCatVtaC.
        END.
        DELETE VtaCatVenta.
    END.
END.
RELEASE VtaCatVenta.
RELEASE AlmCatVtaC.
RELEASE AlmCatVtaD.
SESSION:SET-WAIT-STATE('').                                                        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera_Excel B-table-Win 
PROCEDURE Genera_Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER INIT 5.
DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.

DEFINE VARIABLE dPrecioSoles    AS DECIMAL.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*Header del Excel */
cRange = "D" + '2'.
chWorkSheet:Range('D2'):Font:Bold = TRUE.
chWorkSheet:Range(cRange):Value = "CATALOGO DE PRODUCTOS PARA EL PROVEEDOR " + GN-PROV.NOMPRO.
cRange = "K" + '2'.
chWorkSheet:Range(cRange):Value = TODAY.


/*Formato*/
chWorkSheet:Columns("A"):NumberFormat = "@".
chWorkSheet:Columns("B"):NumberFormat = "@".
chWorkSheet:Columns("C"):NumberFormat = "@".

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH almcatvtac OF vtacatventa NO-LOCK:
    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.    
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = STRING(almcatvtac.nropag,'999').
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = AlmCatVtaC.DesPag.  

    /* set the column names for the Worksheet */
    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Nro.Pag".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Nro.Sec".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Codigo".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Descripción".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Marca".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Unidades".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Precio".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "CodGrupo".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Descripcion Grupo".

    /*
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Moneda".
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Tpo Cambio".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Empaque".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Cantidad".
     */
    FOR EACH almcatvtad OF almcatvtac NO-LOCK,
        FIRST almmmatg OF almcatvtad NO-LOCK
        BREAK BY almcatvtad.nropag:
        FIND FIRST VtaListaMay WHERE VtaListaMay.CodCia = s-codcia
            AND VtaListaMay.CodDiv = s-coddiv
            AND VtaListaMay.CodMat = almcatvtad.codmat 
            NO-LOCK NO-ERROR.

            t-Column = t-Column + 1.
            cColumn = STRING(t-Column).
            cRange = "A" + cColumn.
            chWorkSheet:Range(cRange):Value = STRING(almcatvtad.nropag,'999').
            cRange = "B" + cColumn.
            chWorkSheet:Range(cRange):Value = STRING(almcatvtad.nrosec,'999').
            cRange = "C" + cColumn.
            chWorkSheet:Range(cRange):Value = almcatvtad.codmat.
            cRange = "D" + cColumn.
            chWorkSheet:Range(cRange):Value = almcatvtad.DesMat.
            cRange = "E" + cColumn.
            chWorkSheet:Range(cRange):Value = almmmatg.desmar.
            cRange = "F" + cColumn.
            chWorkSheet:Range(cRange):Value = almmmatg.undbas.
        IF AVAIL VtaListaMay THEN DO:
            IF vtalistamay.monvta = 2 THEN dPrecioSoles = vtalistamay.tpocmb * vtalistamay.preofi.
            ELSE dPrecioSoles = vtalistamay.preofi.

            IF  VtaListaMay.PromDto <> ? AND VtaListaMay.PromDto > 0 THEN DO:
                dPrecioSoles * ( 1 - VtaListaMay.PromDto / 100 ).
            END.

            cRange = "G" + cColumn.
            chWorkSheet:Range(cRange):Value = dPrecioSoles. /*VtaListaMay.PreOfi.    */
            
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = "'" + almcatvtad.libre_c04.
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = almcatvtad.libre_c05.
            

            /*
            cRange = "H" + cColumn.
            chWorkSheet:Range(cRange):Value = VtaListaMay.MonVta.    
            cRange = "I" + cColumn.
            chWorkSheet:Range(cRange):Value = VtaListaMay.TpoCmb.    
            */
       END.
        /*
            cRange = "J" + cColumn.
            chWorkSheet:Range(cRange):Value = AlmCatVtaD.CanEmp.
            cRange = "K" + cColumn.
            chWorkSheet:Range(cRange):Value = AlmCatVtaD.Libre_d05.                    
          */
    END.
    t-Column = t-Column + 3.
END.


HIDE FRAME F-Proceso.

/* launch Excel so it is visible to the user */
 chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

SESSION:SET-WAIT-STATE('').

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
      VtaCatVenta.CodCia = s-codcia
      VtaCatVenta.CodDiv = COMBO-BOX-Division.



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
  FOR EACH AlmCatVtaC OF VtaCatVenta NO-LOCK:
      IF fMov(almcatvtac.codpro, almcatvtac.nropag) THEN DO: 
          MESSAGE 'La página' almcatvtac.nropag 'tiene registros asociados' SKIP
              '      No se puede eliminar           '
              VIEW-AS ALERT-BOX INFO.
          RETURN 'ADM-ERROR'.
      END.
  END.

  FOR EACH AlmCatVtaC OF VtaCatVenta:
      FOR EACH AlmCatVtaD OF AlmCatVtaC:
          DELETE AlmcatVtaD.
      END.
      DELETE AlmCatVtaC.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  COMBO-BOX-Division:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

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
  COMBO-BOX-Division:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX-Division:DELETE(1).
      FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia 
          AND GN-DIVI.VentaMayorista = 2
          AND GN-DIVI.CanalVenta = 'FER'
          /*AND LOOKUP(GN-DIVI.Campo-Char[1], 'D,A') > 0*/
          AND GN-DIVI.Campo-Log[1] = NO
          BREAK BY gn-divi.codcia:
          COMBO-BOX-Division:ADD-LAST( GN-DIVI.CodDiv + ' - ' + GN-DIVI.DesDiv, GN-DIVI.CodDiv ).
/*           IF FIRST-OF(gn-divi.codcia) THEN COMBO-BOX-Division = gn-divi.coddiv. */
      END.
      COMBO-BOX-Division = s-coddiv.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "VtaCatVenta"}
  {src/adm/template/snd-list.i "gn-prov"}

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

FIND gn-prov WHERE gn-prov.codcia = pv-codcia
    AND gn-prov.codpro =  VtaCatVenta.CodPro:SCREEN-VALUE IN BROWSE {&browse-name}
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-prov THEN DO:
    MESSAGE 'Proveedor NO registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fMov B-table-Win 
FUNCTION fMov RETURNS LOGICAL
  ( INPUT pCodPro AS CHAR,
    INPUT pNroPag AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lMov AS LOGICAL     NO-UNDO.

  FIND FIRST vtaddocu WHERE vtaddocu.codcia = s-codcia
      AND vtaddocu.libre_c03 = pCodPro
      AND vtaddocu.libre_c01 = STRING(pNroPag,'9999') NO-LOCK NO-ERROR.
  IF AVAIL vtaddocu THEN lMov = YES.
  ELSE lMov = NO.

  RETURN lMov.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

