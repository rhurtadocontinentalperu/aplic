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
DEF SHARED VAR s-coddiv AS CHAR.
DEF VAR s-coddoc AS CHAR INIT 'PHR' NO-UNDO.

DEF VAR s-task-no AS INT NO-UNDO.

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
&Scoped-define INTERNAL-TABLES DI-RutaC

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table DI-RutaC.CodDoc DI-RutaC.NroDoc ~
DI-RutaC.FchDoc DI-RutaC.Observ 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH DI-RutaC WHERE ~{&KEY-PHRASE} ~
      AND DI-RutaC.CodCia = s-codcia ~
 AND DI-RutaC.CodDiv = s-coddiv ~
 AND DI-RutaC.CodDoc = s-coddoc ~
 AND DI-RutaC.FlgEst = "PF" NO-LOCK ~
    BY DI-RutaC.NroDoc DESCENDING
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH DI-RutaC WHERE ~{&KEY-PHRASE} ~
      AND DI-RutaC.CodCia = s-codcia ~
 AND DI-RutaC.CodDiv = s-coddiv ~
 AND DI-RutaC.CodDoc = s-coddoc ~
 AND DI-RutaC.FlgEst = "PF" NO-LOCK ~
    BY DI-RutaC.NroDoc DESCENDING.
&Scoped-define TABLES-IN-QUERY-br_table DI-RutaC
&Scoped-define FIRST-TABLE-IN-QUERY-br_table DI-RutaC


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
      DI-RutaC SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      DI-RutaC.CodDoc FORMAT "x(3)":U
      DI-RutaC.NroDoc FORMAT "X(9)":U WIDTH 9.57
      DI-RutaC.FchDoc FORMAT "99/99/9999":U WIDTH 9.72
      DI-RutaC.Observ COLUMN-LABEL "Glosa" FORMAT "x(60)":U WIDTH 35.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 65 BY 15.08
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1.08 COL 1.29
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
         HEIGHT             = 15.81
         WIDTH              = 68.29.
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.DI-RutaC"
     _Options          = "NO-LOCK KEY-PHRASE"
     _OrdList          = "INTEGRAL.DI-RutaC.NroDoc|no"
     _Where[1]         = "DI-RutaC.CodCia = s-codcia
 AND DI-RutaC.CodDiv = s-coddiv
 AND DI-RutaC.CodDoc = s-coddoc
 AND DI-RutaC.FlgEst = ""PF"""
     _FldNameList[1]   = INTEGRAL.DI-RutaC.CodDoc
     _FldNameList[2]   > INTEGRAL.DI-RutaC.NroDoc
"DI-RutaC.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "9.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.DI-RutaC.FchDoc
"DI-RutaC.FchDoc" ? ? "date" ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.DI-RutaC.Observ
"DI-RutaC.Observ" "Glosa" ? "character" ? ? ? ? ? ? no ? no no "35.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* SOlo se puede imprimir una PHR para Fedateo
    siempre y cuando TODOS los documentos relacionados
    esten FACTURADOS */
ON FIND OF DI-RutaC DO:
    IF CAN-FIND(FIRST DI-RutaD OF DI-RutaC NO-LOCK WHERE 
                CAN-FIND(FIRST Faccpedi WHERE Faccpedi.CodCia = DI-RutaD.CodCia AND
                         Faccpedi.CodDoc = DI-RutaD.CodRef AND
                         Faccpedi.NroPed = DI-RutaD.NroRef AND
                         Faccpedi.FlgEst = "P" NO-LOCK))
        THEN DO:
        RETURN ERROR.
    END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar B-table-Win 
PROCEDURE Aprobar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE DI-RutaC THEN RETURN.

DEF BUFFER B-RUTAC FOR DI-RutaC.

MESSAGE 'Procedemos con la aprobación?' VIEW-AS ALERT-BOX QUESTION 
    BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

{lib/lock-genericov3.i &Tabla="B-RUTAC" ~
    &Alcance="FIRST" ~
    &Condicion="ROWID(B-RUTAC) = ROWID(DI-RutaC)" ~
    &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
    &Accion="RETRY" ~
    &Mensaje="NO" ~
    &TipoError="UNDO, RETURN ERROR" }
IF B-RUTAC.FlgEst <> "PF" THEN DO:
    MESSAGE 'La PHR ya NO está disponible para aprobar el FEDATEO' VIEW-AS ALERT-BOX ERROR.
    RELEASE B-RUTAC.
    RUN dispatch IN THIS-PROCEDURE ('open-query':U).
    RETURN ERROR.
END.
ASSIGN
    B-RUTAC.FlgEst = "P".
RUN lib/logtabla ("DI-RUTAC",
                  B-RUTAC.CodDoc + '|' + B-RUTAC.CodDiv + '|' + B-RUTAC.CodDoc + '|' + B-RUTAC.NroDoc,
                  "FEDATEO").
RELEASE B-RUTAC.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF s-task-no = 0 THEN REPEAT:
    s-task-no = RANDOM(1,999999).
    IF NOT CAN-FIND(FIRST w-report WHERE w-report.task-no = s-task-no NO-LOCK) THEN LEAVE.
END.
CREATE w-report.
ASSIGN
    w-report.task-no = s-task-no.

FOR EACH Di-RutaD OF Di-RutaC NO-LOCK,
    FIRST Faccpedi NO-LOCK WHERE Faccpedi.codcia = Di-RutaD.CodCia AND
        Faccpedi.coddoc = Di-RutaD.CodRef AND       /* O/D */
        Faccpedi.nroped = Di-RutaD.NroRef
    BREAK BY Faccpedi.codcli:
    /* Buscamos documentos relacionados */
    CASE Faccpedi.CodDoc:
        WHEN "OTR" THEN DO:
            FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = s-CodCia AND
                Almcmov.CodRef = Faccpedi.CodDoc AND
                Almcmov.NroRef = Faccpedi.NroPed:
                CREATE w-report.
                ASSIGN
                    w-report.task-no = s-task-no
                    w-report.llave-c = di-rutac.nrodoc.
                ASSIGN
                    w-report.campo-c[1] = Faccpedi.codcli
                    w-report.campo-c[2] = Faccpedi.nomcli
                    w-report.campo-c[3] = Faccpedi.coddoc
                    w-report.campo-c[4] = Faccpedi.nroped.
                ASSIGN
                    w-report.campo-c[5] = "G/R"
                    w-report.campo-c[6] = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '999999999').
                FOR EACH Almdmov OF Almcmov NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
                    ASSIGN
                        w-report.campo-f[1] = w-report.campo-f[1] + (ccbddocu.candes * ccbddocu.factor * almmmatg.pesmat)
                        w-report.campo-f[2] = w-report.campo-f[2] + (ccbddocu.candes * ccbddocu.factor * almmmatg.libre_d02 / 1000000).
                END.
            END.
        END.
        OTHERWISE DO:       /* O/D */

            DEFINE VAR hProc AS HANDLE NO-UNDO.         /* Handle Libreria */
            DEFINE VAR x-DeliveryGroup AS CHAR.
            DEFINE VAR x-InvoiCustomerGroup AS CHAR.
            
            RUN logis\logis-librerias.p PERSISTENT SET hProc.
            
            /* Procedimientos */
            RUN Grupo-reparto IN hProc (INPUT Faccpedi.coddoc, INPUT Faccpedi.nroped, 
                                        OUTPUT x-DeliveryGroup, OUTPUT x-InvoiCustomerGroup).   
            
            
            DELETE PROCEDURE hProc.                     /* Release Libreria */
            
            IF x-DeliveryGroup = "" OR x-InvoiCustomerGroup = "" THEN DO:
                FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia AND
                    Ccbcdocu.coddiv = s-coddiv AND
                    Ccbcdocu.coddoc = "G/R" AND
                    Ccbcdocu.codcli = Faccpedi.codcli AND
                    Ccbcdocu.libre_c01 = Faccpedi.coddoc AND    /* O/D */
                    Ccbcdocu.libre_c02 = Faccpedi.nroped AND
                    Ccbcdocu.flgest <> 'A' :
                    CREATE w-report.
                    ASSIGN
                        w-report.task-no = s-task-no
                        w-report.llave-c = di-rutac.nrodoc.
                    ASSIGN
                        w-report.campo-c[1] = Faccpedi.codcli
                        w-report.campo-c[2] = Faccpedi.nomcli
                        w-report.campo-c[3] = Faccpedi.coddoc
                        w-report.campo-c[4] = Faccpedi.nroped.
                    ASSIGN
                        w-report.campo-c[5] = "G/R"
                        w-report.campo-c[6] = Ccbcdocu.nrodoc.
                    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
                        ASSIGN
                            w-report.campo-f[1] = w-report.campo-f[1] + (ccbddocu.candes * ccbddocu.factor * almmmatg.pesmat)
                            w-report.campo-f[2] = w-report.campo-f[2] + (ccbddocu.candes * ccbddocu.factor * almmmatg.libre_d02 / 1000000).
                    END.
                END.
            END.
            ELSE DO:

                /* Ubico la FAI cuyo origen es la O/D - CASO BCP */
                FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND
                                            ccbcdocu.codcli = faccpedi.codcli AND
                                            ccbcdocu.coddoc = 'FAI' AND
                                            Ccbcdocu.libre_c01 = Faccpedi.coddoc AND    /* O/D */
                                            Ccbcdocu.libre_c02 = Faccpedi.nroped AND
                                            Ccbcdocu.flgest <> 'A' NO-LOCK NO-ERROR.
                IF AVAILABLE ccbcdocu THEN DO:
                    CREATE w-report.
                    ASSIGN
                        w-report.task-no = s-task-no
                        w-report.llave-c = di-rutac.nrodoc.
                    ASSIGN
                        w-report.campo-c[1] = Faccpedi.codcli
                        w-report.campo-c[2] = Faccpedi.nomcli
                        w-report.campo-c[3] = Faccpedi.coddoc
                        w-report.campo-c[4] = Faccpedi.nroped.
                    ASSIGN
                        w-report.campo-c[5] = ccbcdocu.codref
                        w-report.campo-c[6] = Ccbcdocu.nroref.
                    FOR EACH Ccbddocu OF Ccbcdocu NO-LOCK, FIRST Almmmatg OF Ccbddocu NO-LOCK:
                        ASSIGN
                            w-report.campo-f[1] = w-report.campo-f[1] + (ccbddocu.candes * ccbddocu.factor * almmmatg.pesmat)
                            w-report.campo-f[2] = w-report.campo-f[2] + (ccbddocu.candes * ccbddocu.factor * almmmatg.libre_d02 / 1000000).
                    END.
                END.
            END.
        END.
    END CASE.
END.
DEF VAR pBultos AS INT NO-UNDO.

FOR EACH w-report WHERE w-report.task-no = s-task-no AND w-report.llave-c > ''
    BREAK BY w-report.campo-c[1] BY w-report.campo-c[3] BY w-report.campo-c[4]
        BY w-report.campo-c[5] BY w-report.campo-c[6]:
    IF FIRST-OF(w-report.campo-c[1]) OR FIRST-OF(w-report.campo-c[3]) OR
        FIRST-OF(w-report.campo-c[4]) THEN DO:

        RUN logis/p-numero-de-bultos (s-CodDiv,
                                      w-report.campo-c[3],
                                      w-report.campo-c[4],
                                      OUTPUT pBultos).

        ASSIGN
            w-report.campo-f[3] = pBultos.
/*         FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = s-CodCia AND       */
/*             CcbCBult.CodDiv = s-CodDiv AND                                   */
/*             CcbCBult.CodDoc = w-report.campo-c[3] AND                        */
/*             CcbCBult.NroDoc = w-report.campo-c[4]:                           */
/*             ASSIGN                                                           */
/*                 w-report.campo-f[3] = w-report.campo-f[3] + CcbCBult.Bultos. */
/*         END.                                                                 */
    END.
END.

FOR EACH w-report WHERE w-report.task-no = s-task-no AND 
    (TRUE <> (w-report.llave-c > '')):
    DELETE w-report.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime B-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF NOT AVAILABLE Di-RutaC THEN RETURN.
  s-Task-No = 0.
  RUN Carga-Temporal.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DEF VAR RB-REPORT-LIBRARY AS CHAR.              /* Archivo PRL a usar */
  DEF VAR RB-REPORT-NAME AS CHAR.                 /* Nombre del reporte */
  DEF VAR RB-INCLUDE-RECORDS AS CHAR.             /* "O" si necesita filtro */
  DEF VAR RB-FILTER AS CHAR.                      /* Filtro de impresion */
  DEF VAR RB-OTHER-PARAMETERS AS CHAR INITIAL "". /* Otros parametros */

  GET-KEY-VALUE SECTION 'Startup'   KEY 'BASE' VALUE RB-REPORT-LIBRARY.
  RB-REPORT-LIBRARY = RB-REPORT-LIBRARY + 'logis/rblogis.prl'.
  RB-REPORT-NAME = 'PHR Fedateo'.
  RB-INCLUDE-RECORDS = "O".
  RB-FILTER = "w-report.task-no = " + STRING(s-task-no).

  DEF VAR pClientes AS DEC NO-UNDO.
  DEF VAR pPeso AS DEC NO-UNDO.
  DEF VAR pVolumen AS DEC NO-UNDO.

  FOR EACH w-report NO-LOCK WHERE w-report.task-no = s-task-no
      BREAK BY w-report.campo-c[1]:
      IF FIRST-OF(w-report.campo-c[1]) THEN pClientes = pClientes + 1.
      ASSIGN
          pPeso = pPeso + w-report.campo-f[1]
          pVolumen = pVolumen + w-report.campo-f[2].
  END.
  RB-OTHER-PARAMETERS = "~npClientes=" + STRING(pClientes) +
                        "~npPeso=" + STRING(pPeso) +
                        "~npVolumen=" + STRING(pVolumen).

  RUN lib/_Imprime2 (INPUT RB-REPORT-LIBRARY,
                     INPUT RB-REPORT-NAME,
                     INPUT RB-INCLUDE-RECORDS,
                     INPUT RB-FILTER,
                     INPUT RB-OTHER-PARAMETERS).

  FOR EACH w-report EXCLUSIVE-LOCK WHERE w-report.task-no = s-task-no:
      DELETE w-report.
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
  {src/adm/template/snd-list.i "DI-RutaC"}

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

