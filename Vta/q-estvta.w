&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS q-tables 
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

  Description: from QUERY.W - Template For Query objects in the ADM

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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR s-periodo AS INT.
DEFINE SHARED VAR s-nromes AS INT.
DEFINE SHARED VAR s-codmon AS INT.
DEFINE SHARED VAR C-clfCli AS CHAR.

DEF VAR x-month     AS INT NO-UNDO.
DEF VAR x-year      AS INT NO-UNDO.
DEF VAR x-nrofchi   AS INT NO-UNDO.
DEF VAR k           AS INT NO-UNDO.
DEF VAR x-NroFchE   AS INT NO-UNDO.
DEF VAR iFchIni     AS INT NO-UNDO.
DEF VAR iFcha       AS INT NO-UNDO.
DEF VAR iInt        AS INT NO-UNDO.

DEFINE BUFFER bevt-divi  FOR evtdivi.
DEFINE BUFFER bevt-all02 FOR evtall02.
DEFINE BUFFER bevt-line  FOR evtline.
DEF VAR dAcummA AS DECIMAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartQuery
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,Navigation-Target

&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES w-report

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for QUERY Query-Main                                     */
&Scoped-define QUERY-STRING-Query-Main FOR EACH w-report WHERE ~{&KEY-PHRASE} ~
      AND w-report.Task-No = s-codcia ~
 AND w-report.Llave-C = "XXXX" ~
  NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH w-report WHERE ~{&KEY-PHRASE} ~
      AND w-report.Task-No = s-codcia ~
 AND w-report.Llave-C = "XXXX" ~
  NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-Query-Main w-report
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main w-report


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" q-tables _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&QUERY-NAME
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" q-tables _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&QUERY-NAME
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

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      w-report SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartQuery
   Allow: Basic,Query
   Frames: 1
   Add Fields to: NEITHER
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
  CREATE WINDOW q-tables ASSIGN
         HEIGHT             = 1.35
         WIDTH              = 15.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB q-tables 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmquery.i}
{src/adm/method/query.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW q-tables
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for QUERY Query-Main
     _TblList          = "INTEGRAL.w-report"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _Where[1]         = "w-report.Task-No = s-codcia
 AND w-report.Llave-C = ""XXXX""
 "
     _Design-Parent    is WINDOW q-tables @ ( 1.12 , 1.86 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK q-tables 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available q-tables  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Data q-tables 
PROCEDURE Carga-Data :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
CASE C-clfCli :
    WHEN "División" THEN DO: 
        RUN Carga-Divi.
        RUN local-qbusca.
    END.
END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Divi q-tables 
PROCEDURE Carga-Divi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dAcum AS DECIMAL EXTENT 2 NO-UNDO.
    DEFINE BUFFER bw-report FOR w-report.
    
    iFchIni = (s-periodo - 1 ) + s-nromes.
    FOR EACH gn-divi NO-LOCK 
        WHERE gn-divi.CodCia = s-CodCia:
        dAcum[1] = 0.
        dAcum[2] = 0.
        DO k = s-periodo - 1 TO s-periodo:
            x-Year = k.
            x-Month = s-nromes.
            x-NroFchI = x-Year * 100 + x-Month.
            x-NroFchE = s-periodo * 100 + x-Month.
    
            FOR EACH evtdivi NO-LOCK
                WHERE evtdivi.CodCia = Gn-Divi.CodCia
                AND evtdivi.CodDiv = Gn-Divi.CodDiv
                AND evtdivi.NroFch = x-NroFchI:
        
                FIND FIRST w-report WHERE w-report.Task-No = evtdivi.CodCia
                    AND w-report.Campo-C[1] = evtdivi.CodDiv NO-ERROR.
    
                IF NOT AVAILABLE w-report THEN DO:
                    CREATE w-report.
                    ASSIGN
                        w-report.Task-No     = evtdivi.CodCia
                        w-report.Llave-C     = "XXXX"
                        w-report.Campo-C[30] = "DIV"
                        w-report.Campo-C[1]  = evtdivi.CodDiv
                        w-report.Campo-C[2]  = evtdivi.CodDiv + " - " + INTEGRAL.GN-DIVI.DesDiv.
                    CASE s-codmon:
                        WHEN 1 THEN DO:
                            IF (x-Year = s-periodo) THEN DO:
                                ASSIGN 
                                    w-report.Campo-F[1] = w-report.Campo-F[1] + EvtDivi.VtaxMesMn
                                    w-report.Campo-F[2] = w-report.Campo-F[2] + EvtDivi.CtoxMesMn 
                                    w-report.Campo-F[3] = w-report.Campo-F[3] + (EvtDivi.VtaxMesMn - EvtDivi.CtoxMesMn).
                            END.
                                
                            IF (x-Year = (s-periodo - 1)) THEN DO:
                                ASSIGN 
                                    w-report.Campo-F[4] = w-report.Campo-F[4] + EvtDivi.VtaxMesMn
                                    w-report.Campo-F[5] = w-report.Campo-F[5] + EvtDivi.CtoxMesMn
                                    w-report.Campo-F[6] = w-report.Campo-F[6] + (EvtDivi.VtaxMesMn - EvtDivi.CtoxMesMn).
                            END.
                                
                        END.
                        WHEN 2 THEN DO:
                            IF (x-Year = s-periodo) THEN DO:
                                ASSIGN 
                                    w-report.Campo-F[1] = w-report.Campo-F[1] + EvtDivi.VtaxMesMe
                                    w-report.Campo-F[2] = w-report.Campo-F[2] + EvtDivi.CtoxMesMe
                                    w-report.Campo-F[3] = w-report.Campo-F[3] + (EvtDivi.VtaxMesMe - EvtDivi.CtoxMesMe).
                            END.
                                
                            IF (x-Year = (s-periodo - 1)) THEN DO:
                                ASSIGN 
                                    w-report.Campo-F[4] = w-report.Campo-F[4] + EvtDivi.VtaxMesMe
                                    w-report.Campo-F[5] = w-report.Campo-F[5] + EvtDivi.CtoxMesMe
                                    w-report.Campo-F[6] = w-report.Campo-F[6] + (EvtDivi.VtaxMesMe - EvtDivi.CtoxMesMe).
                            END.
                                
                        END.
                    END CASE.     
                END.
                ELSE DO:
                    CASE s-codmon:
                        WHEN 1 THEN DO:
                            IF (x-Year = s-periodo) THEN DO:
                                ASSIGN 
                                    w-report.Campo-F[1] = w-report.Campo-F[1] + EvtDivi.VtaxMesMn
                                    w-report.Campo-F[2] = w-report.Campo-F[2] + EvtDivi.CtoxMesMn
                                    w-report.Campo-F[3] = w-report.Campo-F[3] + (EvtDivi.VtaxMesMn - EvtDivi.CtoxMesMn).
                            END.
                                
                            IF (x-Year = (s-periodo - 1)) THEN DO:
                                ASSIGN 
                                    w-report.Campo-F[4] = w-report.Campo-F[4] + EvtDivi.VtaxMesMn
                                    w-report.Campo-F[5] = w-report.Campo-F[5] + EvtDivi.CtoxMesMn
                                    w-report.Campo-F[6] = w-report.Campo-F[6] + (EvtDivi.VtaxMesMn - EvtDivi.CtoxMesMn).
                            END.
                                
                        END.
                        WHEN 2 THEN DO:
                            IF (x-Year = s-periodo) THEN DO:
                                ASSIGN 
                                    w-report.Campo-F[1] = w-report.Campo-F[1] + EvtDivi.VtaxMesMe
                                    w-report.Campo-F[2] = w-report.Campo-F[2] + EvtDivi.CtoxMesMe
                                    w-report.Campo-F[3] = w-report.Campo-F[3] + (EvtDivi.VtaxMesMe - EvtDivi.CtoxMesMe).
                            END.
                                
                            IF (x-Year = (s-periodo - 1)) THEN DO:
                                ASSIGN 
                                    w-report.Campo-F[1] = w-report.Campo-F[1] + EvtDivi.VtaxMesMe.
                                    w-report.Campo-F[2] = w-report.Campo-F[2] + EvtDivi.CtoxMesMe.
                                    w-report.Campo-F[3] = w-report.Campo-F[3] + (EvtDivi.VtaxMesMe - EvtDivi.CtoxMesMe).
                            END.
                                
                        END.
                    END CASE.     
                END.
            END.
        END.
    END.
    
    /*Calcula acumulado a la fecha*/
    FOR EACH w-report:
        DO k = s-periodo - 1 TO s-periodo:
            x-Month = s-nromes.
            iFcha = k * 100 + 1. /*2000801*/
            x-NroFchE = k * 100 + x-Month.
            dAcummA = 0.
            FOR EACH bevt-divi NO-LOCK 
                WHERE bevt-divi.CodCia = w-report.Task-No
                AND bevt-divi.CodDiv = w-report.Campo-C[1]
                AND bevt-divi.NroFch >= iFcha
                AND bevt-divi.NroFch <= x-NroFchE
                BREAK BY bevt-divi.CodDiv:
                CASE s-codmon:
                    WHEN 1 THEN dAcummA = dAcummA + bevt-divi.VtaxMesMn.
                    WHEN 2 THEN dAcummA = dAcummA + bevt-divi.VtaxMesMe.
                END CASE.
                IF LAST (bevt-divi.CodDiv) THEN DO:
                    FIND FIRST bw-report WHERE bw-report.Task-No = w-report.Task-No 
                        AND bw-report.Campo-C[1] = w-report.Campo-C[1] NO-ERROR.
                    IF AVAILABLE bw-report THEN DO:
                        IF k = (s-periodo) THEN ASSIGN bw-report.Campo-F[7] = dAcummA.
                        IF k = (s-periodo - 1) THEN ASSIGN bw-report.Campo-F[8] = dAcummA.
                        /*
                        /*Calcula Porcentajes*/
                        IF w-report.ttevt-AmountMes[2] <> 0 THEN DO:
                            bw-report.ttevt-DifMes[1] = (w-report.ttevt-AmountMes[1] / w-report.ttevt-AmountMes[2] * 100).                        
                        END.
                        ELSE bw-report.ttevt-DifMes[1] = 100.
                        IF w-report.ttevt-Accumulate[2] <> 0 THEN
                            bw-report.ttevt-DifMes[2] = (w-report.ttevt-Accumulate[1] / w-report.ttevt-Accumulate[2] * 100).
                        ELSE bw-report.ttevt-DifMes[2] = 100.
                        */
                    END.        
                END.
            END.
        END.
    END.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI q-tables  _DEFAULT-DISABLE
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
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-qbusca q-tables 
PROCEDURE local-qbusca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'qbusca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*
    AQUI SE DEBE LLAMAR AL PROGRAMA DE CONSULTA
    RUN C-LOOKUP ("<Título de la consulta>")
    */
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&QUERY-NAME}} THEN DO:
            REPOSITION {&QUERY-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records q-tables  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "w-report"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed q-tables 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/qstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

