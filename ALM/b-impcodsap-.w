&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-datos LIKE CcbDDocu
       FIELDS numepq AS INT
       FIELDS nroord like ccbcdocu.nroord.



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
DEF STREAM REPORTE.
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR S-NROREF AS CHARACTER.



DEFINE VARIABLE cCodDoc AS CHARACTER   NO-UNDO INIT "G/R".
DEFINE VARIABLE iNroPaq AS INTEGER     NO-UNDO.

DEFINE VARIABLE cUbica AS ROWID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME r_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-datos Almmmatg

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE r_table                                       */
&Scoped-define FIELDS-IN-QUERY-r_table tt-datos.codmat Almmmatg.DesMat ~
Almmmatg.DesMar tt-datos.CanDes tt-datos.CanDev numepq @ numepq 
&Scoped-define ENABLED-FIELDS-IN-QUERY-r_table tt-datos.CanDev 
&Scoped-define ENABLED-TABLES-IN-QUERY-r_table tt-datos
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-r_table tt-datos
&Scoped-define QUERY-STRING-r_table FOR EACH tt-datos WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF tt-datos NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-r_table OPEN QUERY r_table FOR EACH tt-datos WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      EACH Almmmatg OF tt-datos NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-r_table tt-datos Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-r_table tt-datos
&Scoped-define SECOND-TABLE-IN-QUERY-r_table Almmmatg


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS r_table 

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
DEFINE QUERY r_table FOR 
      tt-datos, 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE r_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS r_table B-table-Win _STRUCTURED
  QUERY r_table NO-LOCK DISPLAY
      tt-datos.codmat COLUMN-LABEL "Articulo" FORMAT "X(6)":U WIDTH 7
      Almmmatg.DesMat FORMAT "X(45)":U WIDTH 50
      Almmmatg.DesMar COLUMN-LABEL "Marca" FORMAT "X(30)":U WIDTH 20
      tt-datos.CanDes FORMAT ">,>>>,>>9.9999":U
      tt-datos.CanDev COLUMN-LABEL "Empaque" FORMAT ">,>>>,>>99":U
      numepq @ numepq COLUMN-LABEL "Paquetes" FORMAT ">>>>>99":U
  ENABLE
      tt-datos.CanDev
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 112 BY 15.62
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     r_table AT ROW 1.27 COL 1
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
      TABLE: tt-datos T "?" ? INTEGRAL CcbDDocu
      ADDITIONAL-FIELDS:
          FIELDS numepq AS INT
          FIELDS nroord like ccbcdocu.nroord
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
         HEIGHT             = 16.54
         WIDTH              = 113.72.
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
/* BROWSE-TAB r_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE r_table
/* Query rebuild information for BROWSE r_table
     _TblList          = "Temp-Tables.tt-datos,INTEGRAL.Almmmatg OF Temp-Tables.tt-datos"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.tt-datos.codmat
"tt-datos.codmat" "Articulo" ? "character" ? ? ? ? ? ? no ? no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almmmatg.DesMat
"Almmmatg.DesMat" ? ? "character" ? ? ? ? ? ? no ? no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almmmatg.DesMar
"Almmmatg.DesMar" "Marca" ? "character" ? ? ? ? ? ? no ? no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.tt-datos.CanDes
     _FldNameList[5]   > Temp-Tables.tt-datos.CanDev
"tt-datos.CanDev" "Empaque" ">,>>>,>>99" "decimal" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"numepq @ numepq" "Paquetes" ">>>>>99" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE r_table */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME r_table
&Scoped-define SELF-NAME r_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL r_table B-table-Win
ON ROW-ENTRY OF r_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL r_table B-table-Win
ON ROW-LEAVE OF r_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL r_table B-table-Win
ON VALUE-CHANGED OF r_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Datos B-table-Win 
PROCEDURE Carga-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    EMPTY TEMP-TABLE tt-datos.

    FOR EACH ccbddocu WHERE ccbddocu.codcia = s-codcia
        AND ccbddocu.coddiv = s-coddiv
        AND ccbddocu.coddoc = cCodDoc
        AND ccbddocu.nrodoc = s-nroref NO-LOCK,
        FIRST almmmatg OF ccbddocu NO-LOCK:
        
        CREATE tt-datos.
        BUFFER-COPY ccbddocu TO tt-datos
            ASSIGN 
                tt-datos.candev = almmmatg.canemp.
        IF (DEC(ccbddocu.candes / almmmatg.canemp) - INT(ccbddocu.candes / almmmatg.canemp)) > 0
            THEN tt-datos.numepq = INT(ccbddocu.candes / almmmatg.canemp) + 1.
        ELSE tt-datos.numepq = INT(ccbddocu.candes / almmmatg.canemp).

        IF tt-datos.codcli = '' THEN DO: 
            FIND ccbcdocu OF ccbddocu NO-LOCK NO-ERROR.
            IF AVAIL ccbcdocu THEN tt-datos.codcli = ccbcdocu.codcli.
        END.
    END.
    RUN adm-open-query.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Etiquetas B-table-Win 
PROCEDURE Imprime-Etiquetas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEF VAR rpta AS LOG.
    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.

    OUTPUT STREAM REPORTE TO PRINTER.        
        RUN Print.
    OUTPUT STREAM reporte CLOSE.    
    
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Etiquetas02 B-table-Win 
PROCEDURE Imprime-Etiquetas02 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR rpta AS LOG.
    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.

    OUTPUT STREAM REPORTE TO PRINTER.        
        RUN Print02.
    OUTPUT STREAM reporte CLOSE.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record B-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  cUbica = ROWID(tt-datos).
  
  IF (DEC(tt-datos.candes / tt-datos.candev) - INT(tt-datos.candes / tt-datos.candev)) > 0
    THEN tt-datos.numepq = INT(tt-datos.candes / tt-datos.candev) + 1.
  ELSE tt-datos.numepq = INT(tt-datos.candes / tt-datos.candev).

  RUN adm-open-query.  
  REPOSITION r_table TO ROWID cUbica NO-ERROR.  

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Print B-table-Win 
PROCEDURE Print :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE x-nomcia AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-codmat AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-desmat AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-desma2 AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-undemp AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-numcop AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iInt     AS INTEGER     NO-UNDO.

    DEFINE VARIABLE d-undemp AS INTEGER     NO-UNDO.

    FOR EACH tt-datos NO-LOCK:
        
        FIND FIRST VtaProxCli WHERE VtaProxCli.CodCia = tt-datos.codcia
            AND VtaProxCli.CodCli = tt-datos.codcli
            AND VtaProxCli.CodMat = tt-datos.codmat NO-LOCK NO-ERROR.
        IF NOT AVAIL VtaProxCli THEN RETURN "adm-error".
        
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
            AND almmmatg.codmat = VtaProxCli.CodMat NO-LOCK NO-ERROR.

        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = VtaProxCli.CodCli NO-LOCK NO-ERROR.

        ASSIGN 
            x-nomcia = gn-clie.nomcli
            x-codmat = VtaProxCli.CodEqui
            x-desmat = SUBSTRING(Almmmatg.desmat,1,30)
            x-desma2 = SUBSTRING(Almmmatg.desmat,31)
            /*
            x-undemp = STRING(tt-datos.candev) + " " + VtaProxCli.UndStk /*Cantidad Empaque*/
            */
            x-numcop = tt-datos.numepq.

        /**
        IF DEC(INT(tt-datos.candes) / tt-datos.candev) > 0 THEN 
            x-numcop = INT(INT(tt-datos.candes) / tt-datos.candev) + 1.
        ELSE x-numcop = DEC(INT(tt-datos.candes) / tt-datos.candev).
        ***/
        
        d-undemp = tt-datos.candev.
        DO iInt = 1 TO tt-datos.numepq:
            IF tt-datos.candes > d-undemp THEN 
                x-undemp = STRING(tt-datos.candev) + " " + VtaProxCli.UndStk. /*Cantidad Empaque*/
            ELSE 
                x-undemp = STRING(tt-datos.candes - (d-undemp - tt-datos.candev)) + " " + VtaProxCli.UndStk. /*Cantidad Empaque*/
            d-undemp = d-undemp + tt-datos.candev.

            PUT STREAM REPORTE '^XA^LH50,012'               SKIP.   /* Inicia formato */
            {alm/codigoxbultos.i}
            PUT STREAM REPORTE '^PQ' + TRIM(STRING(1)) SKIP.  /* Cantidad a imprimir */
            PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
            PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */    
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Print02 B-table-Win 
PROCEDURE Print02 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE x-nomcia AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-codmat AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-desmat AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-desma2 AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-undemp AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE x-numcop AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iInt     AS INTEGER     NO-UNDO.

    DEFINE VARIABLE d-undemp AS INTEGER     NO-UNDO.
    DEFINE VARIABLE x-nroord AS CHARACTER   NO-UNDO.

    FOR EACH tt-datos NO-LOCK:
        
        FIND FIRST VtaProxCli WHERE VtaProxCli.CodCia = tt-datos.codcia
            AND VtaProxCli.CodCli = tt-datos.codcli
            AND VtaProxCli.CodMat = tt-datos.codmat NO-LOCK NO-ERROR.
        IF NOT AVAIL VtaProxCli THEN RETURN "adm-error".
        
        FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
            AND almmmatg.codmat = VtaProxCli.CodMat NO-LOCK NO-ERROR.

        FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = VtaProxCli.CodCli NO-LOCK NO-ERROR.

        ASSIGN 
            x-nomcia = gn-clie.nomcli
            x-codmat = VtaProxCli.CodEqui
            x-desmat = SUBSTRING(Almmmatg.desmat,1,30)
            x-desma2 = SUBSTRING(Almmmatg.desmat,31)
            x-nroord = tt-datos.nroord
            x-numcop = tt-datos.numepq.

        d-undemp = tt-datos.candev.
        DO iInt = 1 TO tt-datos.numepq:
            IF tt-datos.candes > d-undemp THEN 
                x-undemp = STRING(tt-datos.candev) + " " + VtaProxCli.UndStk. /*Cantidad Empaque*/
            ELSE 
                x-undemp = STRING(tt-datos.candes - (d-undemp - tt-datos.candev)) + " " + VtaProxCli.UndStk. /*Cantidad Empaque*/
            d-undemp = d-undemp + tt-datos.candev.

            PUT STREAM REPORTE '^XA^LH50,012'               SKIP.   /* Inicia formato */
            {alm/codigoxbultos02.i}
            PUT STREAM REPORTE '^PQ' + TRIM(STRING(1)) SKIP.  /* Cantidad a imprimir */
            PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
            PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */    
        END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Prueba B-table-Win 
PROCEDURE Prueba :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR rpta AS LOG.
    SYSTEM-DIALOG PRINTER-SETUP UPDATE rpta.
    IF rpta = NO THEN RETURN.
    OUTPUT STREAM REPORTE TO PRINTER. 
        
        FIND FIRST almmmatg WHERE codcia = s-codcia
            AND almmmatg.codmat = '033263' NO-LOCK NO-ERROR.

        PUT STREAM REPORTE '^XA^LH50,012'               SKIP.   /* Inicia formato */
        {alm/codigoxbultos02.i}
        PUT STREAM REPORTE '^PQ' + TRIM(STRING(1)) SKIP.  /* Cantidad a imprimir */
        PUT STREAM REPORTE '^PR' + '4'                   SKIP.   /* Velocidad de impresion Pulg/seg */
        PUT STREAM REPORTE '^XZ'                         SKIP.   /* Fin de formato */    
    OUTPUT STREAM reporte CLOSE.    
    
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
  {src/adm/template/snd-list.i "tt-datos"}
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

