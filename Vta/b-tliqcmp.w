&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-Almc LIKE Almcmov.
DEFINE SHARED TEMP-TABLE T-Log LIKE LG-COCmp
       INDEX LLave01 CodCia TpoDoc NroDoc.



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

DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE x-nrofac LIKE CcbCDocu.NroDoc.

DEFINE SHARED VARIABLE pv-codcia AS INTEGER.
DEFINE SHARED VARIABLE s-codcia  AS INTEGER.
DEFINE SHARED VARIABLE s-coddiv  AS CHARACTER INIT '00000'.


DEFINE VARIABLE Guia LIKE AlmcMov.NroRf2.
DEFINE VARIABLE tpodoc AS CHARACTER INIT 'N'.


DEFINE SHARED VAR p-codpro LIKE Lg-CoCmp.CodPro.
DEFINE SHARED VAR p-nrooc  LIKE Lg-CoCmp.NroDoc.
DEFINE SHARED VAR p-codalm LIKE Lg-CoCmp.CodAlm.

DEFINE VAR x-guias AS CHARACTER.

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
&Scoped-define INTERNAL-TABLES T-Log

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table T-Log.NroDoc T-Log.Fchdoc ~
T-Log.Codmon T-Log.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table T-Log.NroDoc 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table T-Log
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table T-Log
&Scoped-define QUERY-STRING-br_table FOR EACH T-Log WHERE ~{&KEY-PHRASE} NO-LOCK
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH T-Log WHERE ~{&KEY-PHRASE} NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br_table T-Log
&Scoped-define FIRST-TABLE-IN-QUERY-br_table T-Log


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

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
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      T-Log SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      T-Log.NroDoc COLUMN-LABEL "O/C" FORMAT "999999":U WIDTH 8
      T-Log.Fchdoc FORMAT "99/99/9999":U
      T-Log.Codmon FORMAT "9":U
      T-Log.ImpTot FORMAT "ZZ,ZZZ,ZZ9.99":U
  ENABLE
      T-Log.NroDoc
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 37 BY 8.08
         FONT 4
         TITLE "Ordenes de Compra" ROW-HEIGHT-CHARS .46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.27 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: T-Almc T "SHARED" ? INTEGRAL Almcmov
      TABLE: T-Log T "SHARED" ? INTEGRAL LG-COCmp
      ADDITIONAL-FIELDS:
          INDEX LLave01 CodCia TpoDoc NroDoc
      END-FIELDS.
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
         HEIGHT             = 9.23
         WIDTH              = 39.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.T-Log"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ","
     _FldNameList[1]   > Temp-Tables.T-Log.NroDoc
"NroDoc" "O/C" ? "integer" ? ? ? ? ? ? yes ? no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = Temp-Tables.T-Log.Fchdoc
     _FldNameList[3]   = Temp-Tables.T-Log.Codmon
     _FldNameList[4]   = Temp-Tables.T-Log.ImpTot
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* Ordenes de Compra */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* Ordenes de Compra */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* Ordenes de Compra */
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
      IF T-Log.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} <> '' THEN DO:

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Guias B-table-Win 
PROCEDURE Asigna-Guias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN VTA/d-tlicmp (INPUT-OUTPUT x-guias).
  
  DEFINE VARIABLE lOk AS LOGICAL NO-UNDO.
  DEFINE VARIABLE ind AS INTEGER NO-UNDO.
  FOR EACH Almcmov WHERE Almcmov.CodCia = s-CodCia
      AND Almcmov.CodAlm = p-codalm
      AND Almcmov.TipMov = 'I'
      AND Almcmov.CodMov = 02
      AND LOOKUP(STRING(Almcmov.NroDoc), x-guias) > 0:
      CREATE T-Almc.
      BUFFER-COPY Almcmov TO T-Almc.
  END.
  RUN Procesa-Handle IN Lh_Handle ('Browse').
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cargando-Detalle B-table-Win 
PROCEDURE Cargando-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*                                                                                   */
/*   FIND FIRST Lg-CoCmp WHERE Lg-CoCmp.CodCia = s-codcia                            */
/*       AND Lg-CoCmp.CodDiv = s-coddiv                                              */
/*       AND Lg-CoCmp.TpoDoc = Tpodoc                                                */
/*       AND Lg-CoCmp.NroDoc = T-Log.NroDoc                                          */
/*       NO-LOCK NO-ERROR.                                                           */
/*   IF AVAILABLE Lg-CoCmp THEN DO:                                                  */
/*       MESSAGE "Disponible Lg-CoCmp ".                                             */
/*       FOR EACH AlmCmov NO-LOCK WHERE AlmCmov.CodCia = Lg-CoCmp.CodCia             */
/*           AND AlmCmov.CodAlm = Lg-Cocmp.CodAlm                                    */
/*           AND AlmCmov.TipMov = 'I'                                                */
/*           AND AlmCmov.CodMov = 02                                                 */
/*           AND AlmCmov.NroRf1 = T-Log.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME} */
/*           AND AlmCmov.NroRf2 = T-Almc.NroRf2:                                     */
/*           MESSAGE "Encontro" Almcmov.CodAlm VIEW-AS ALERT-BOX.                    */
/*           CREATE T-Almc.                                                          */
/*           BUFFER-COPY Almcmov TO T-Almc.                                          */
/*       END.                                                                        */
/*                                                                                   */
/*   END.                                                                            */
  /*
  FIND FIRST Almcmov NO-LOCK WHERE Almcmov.CodCia = 1
      AND Almcmov.CodAlm = 11
      AND Almcmov.TipMov = 'I'
      AND Almcmov.CodMov = 02
      AND Almcmov.NroRf1 = STRING(T-Log.NroDoc, '999999')
      NO-LOCK NO-ERROR.
  IF AVAIL Almcmov THEN DO:
      CREATE T-Almc.
      BUFFER-COPY Almcmov TO T-Almc.
  END.
ASSIGN 
      T-Almc.CodCia = 1
      T-Almc.CodAlm = '11'
      T-Almc.TipMov = 'I'
      T-Almc.CodMov = 02
      T-Almc.NroRf1 = STRING(T-Log.NroDoc, '999999').*/
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Datos-Impresion B-table-Win 
PROCEDURE Datos-Impresion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEFINE VARIABLE imptot LIKE Almcmov.ImpMn1.
DEFINE VARIABLE x-moneda AS CHARACTER NO-UNDO.
DEFINE VARIABLE x-prvdor AS CHARACTER NO-UNDO.
DEFINE VARIABLE totalfin AS DECIMAL NO-UNDO.

FIND FIRST Gn-Prov WHERE Gn-Prov.CodCia = pv-codcia
    AND Gn-Prov.CodPro = x-prove
    NO-LOCK NO-ERROR.
IF AVAILABLE Gn-Prov THEN x-prvdor = gn-prov.NomPro.

DEFINE FRAME F-Det
    HEADER 
    "Proveedor:  " AT 1 x-prvdor FORMAT "X(30)" SKIP
    "Factura N°: " AT 1 x-nrofac
    WITH STREAM-IO NO-BOX DOWN WIDTH 320.

DEFINE FRAME F-Det
    SKIP
    Almcmov.NroRf2  COLUMN-LABEL "G/R"      FORMAT "X(11)"
    Lg-Cocmp.NroDoc COLUMN-LABEL "O/C"      FORMAT "99999"
    Almcmov.CodAlm  COLUMN-LABEL "CodAlm"   FORMAT "X(6)"
    Almcmov.NroDoc  COLUMN-LABEL "I02"      
    x-moneda        COLUMN-LABEL "Moneda"   FORMAT "X(10)"
    Almcmov.ImpMn1  COLUMN-LABEL "Importe"  FORMAT "->,>>>,>>9.99"
    ImpTot          COLUMN-LABEL "Total"    FORMAT "->,>>>,>>9.99" SKIP
    WITH STREAM-IO NO-BOX DOWN WIDTH 320.

  FOR EACH T-Log,
      EACH Lg-CoCmp NO-LOCK WHERE Lg-CoCmp.CodCia = s-CodCia
            AND Lg-CoCmp.CodDiv = s-coddiv
            AND Lg-CoCmp.TpoDoc = tpodoc
            AND Lg-CoCmp.NroDoc = T-Log.NroDoc,
                EACH Almcmov WHERE Almcmov.CodCia = Lg-CoCmp.CodCia
                    AND Almcmov.CodAlm = Lg-Cocmp.CodAlm
                    AND Almcmov.TipMov = 'I'
                    AND Almcmov.CodMov = 02
                    AND INTEGER( TRIM(Almcmov.NroRf1)) = Lg-Cocmp.NroDoc
                    AND Almcmov.NroRf2 = T-Log.NroRef, 
                        EACH Almdmov OF Almcmov NO-LOCK:
                        IF  Almcmov.CodMon = 1 THEN DO:
                            ImpTot = Almcmov.ImpMn1.
                            x-moneda = 'Soles'.
                        END.
                        ELSE DO:
                            ImpTot = Almcmov.ImpMn2.
                            x-moneda = 'Dolares'.
                        END.
                        
                        DISPLAY STREAM Report
                                Almcmov.NroRf2
                                Lg-Cocmp.NroDoc
                                Almcmov.CodAlm
                                Almcmov.NroDoc
                                x-moneda
                                Almcmov.ImpMn1
                                ImpTot 
                        WITH FRAME F-Det.
  END.
*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir B-table-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      
    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".
    
   /* RUN Carga-Temporal.*/
    
    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM report TO VALUE(s-print-file) /*PAGED PAGE-SIZE 62*/ .
            WHEN 2 THEN
                OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
        RUN Datos-Impresion.
        PAGE STREAM report.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.
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

  FIND FIRST Lg-Cocmp WHERE Lg-Cocmp.CodCia = s-codcia
      AND Lg-Cocmp.CodDiv = s-coddiv
      AND Lg-Cocmp.NroDoc = INTEGER(T-Log.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
      NO-LOCK NO-ERROR.
  IF AVAILABLE Lg-Cocmp THEN DO:
     BUFFER-COPY Lg-Cocmp TO T-Log.
     ASSIGN 
       p-nrooc  = INTEGER(T-Log.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
       p-codalm = Lg-Cocmp.CodAlm.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
 FOR EACH T-Log:
     DELETE T-Log.
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
  {src/adm/template/snd-list.i "T-Log"}

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

FIND FIRST Lg-COcmp WHERE Lg-COcmp.CodCia = 1 
    AND lg-cocmp.tpodoc = 'N'
    AND Lg-COcmp.NroDoc = INTEGER(T-Log.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Lg-COcmp THEN DO:
    MESSAGE "Ordene de compra no registrada" VIEW-AS ALERT-BOX.
    APPLY 'ENTRY':U TO T-lOG.NroDoc IN BROWSE {&BROWSE-NAME}.
    RETURN 'ADM-ERROR'.    
END.

IF Lg-COcmp.codpro <> p-codpro THEN DO:
    MESSAGE "Proveedor no coincide" VIEW-AS ALERT-BOX.
    APPLY 'ENTRY':U TO T-lOG.NroDoc IN BROWSE {&BROWSE-NAME}.
    RETURN 'ADM-ERROR'.    
END.
/*
FIND FIRST Almcmov WHERE Almcmov.CodCia = 1
    AND Almcmov.TipMov = 'I'
    AND Almcmov.CodMov = 02
    AND Almcmov.CodAlm = Lg-cocmp.codalm
    AND INTEGER( TRIM (Almcmov.NroRf1)) = INTEGER (T-Log.NroDoc:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    AND Almcmov.NroRf2 = STRING(T-Log.NroRef:SCREEN-VALUE IN BROWSE {&BROWSE-NAME})
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcmov THEN DO:
    MESSAGE "Guia de remision no valida" VIEW-AS ALERT-BOX.
    APPLY 'ENTRY':U TO T-Log.NroRef IN BROWSE {&BROWSE-NAME}.
    RETURN 'ADM-ERROR'.
END.*/

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

