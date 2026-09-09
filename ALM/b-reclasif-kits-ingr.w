&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CMOV FOR Almcmov.
DEFINE TEMP-TABLE CMOV NO-UNDO LIKE Almcmov.
DEFINE SHARED TEMP-TABLE DMOV NO-UNDO LIKE Almdmov.
DEFINE TEMP-TABLE ITEM LIKE Almdmov.
DEFINE SHARED TEMP-TABLE T-SALKIT NO-UNDO LIKE Almdmov.



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
DEF SHARED VAR s-user-id AS CHAR.


DEF VAR s-tipmov AS CHAR INIT 'I' NO-UNDO.
DEF VAR s-codmov AS INT INIT 03 NO-UNDO.
DEF VAR x-FchDoc-1 AS DATE NO-UNDO.
DEF VAR x-FchDoc-2 AS DATE NO-UNDO.

&SCOPED-DEFINE Condicion (Almcmov.CodCia = s-codcia ~
AND Almcmov.CodAlm = s-codalm ~
AND Almcmov.TipMov = s-tipmov ~
AND Almcmov.CodMov = s-codmov ~
AND (x-FchDoc-1 = ? OR Almcmov.fchdoc >= x-FchDoc-1) ~
AND (x-FchDoc-2 = ? OR Almcmov.fchdoc <= x-FchDoc-2) ~
AND LOOKUP(Almcmov.FlgEst, "A,P") = 0)

DEF VAR cMensaje AS CHAR NO-UNDO.
DEF VAR F-TPOCMB AS DECIMAL NO-UNDO.

DEFINE SHARED VAR C-CODMOV AS CHAR.
DEFINE SHARED VAR S-NROSER  AS INTEGER.

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
&Scoped-define INTERNAL-TABLES CMOV Almcmov

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table Almcmov.NroSer Almcmov.NroDoc ~
Almcmov.FchDoc Almcmov.Observ 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH CMOV WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almcmov OF CMOV NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CMOV WHERE ~{&KEY-PHRASE} NO-LOCK, ~
      FIRST Almcmov OF CMOV NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table CMOV Almcmov
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CMOV
&Scoped-define SECOND-TABLE-IN-QUERY-br_table Almcmov


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
      CMOV, 
      Almcmov SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      Almcmov.NroSer COLUMN-LABEL "Serie" FORMAT "999":U
      Almcmov.NroDoc COLUMN-LABEL "Numero" FORMAT "999999999":U
      Almcmov.FchDoc COLUMN-LABEL "Fecha" FORMAT "99/99/9999":U
      Almcmov.Observ FORMAT "X(50)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 66 BY 6.69
         FONT 4
         TITLE "INGRESOS POR TRANSFERENCIAS".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
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
      TABLE: B-CMOV B "?" ? INTEGRAL Almcmov
      TABLE: CMOV T "?" NO-UNDO INTEGRAL Almcmov
      TABLE: DMOV T "SHARED" NO-UNDO INTEGRAL Almdmov
      TABLE: ITEM T "?" ? INTEGRAL Almdmov
      TABLE: T-SALKIT T "SHARED" NO-UNDO INTEGRAL Almdmov
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
         WIDTH              = 66.
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
     _TblList          = "Temp-Tables.CMOV,INTEGRAL.Almcmov OF Temp-Tables.CMOV"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _FldNameList[1]   > INTEGRAL.Almcmov.NroSer
"Almcmov.NroSer" "Serie" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.Almcmov.NroDoc
"Almcmov.NroDoc" "Numero" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.Almcmov.FchDoc
"Almcmov.FchDoc" "Fecha" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = INTEGRAL.Almcmov.Observ
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
ON ROW-ENTRY OF br_table IN FRAME F-Main /* INGRESOS POR TRANSFERENCIAS */
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main /* INGRESOS POR TRANSFERENCIAS */
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* INGRESOS POR TRANSFERENCIAS */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal B-table-Win 
PROCEDURE carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER p-FchDoc-1 AS DATE.
DEF INPUT PARAMETER p-FchDoc-2 AS DATE.

ASSIGN
    x-FchDoc-1 = p-FchDoc-1
    x-FchDoc-2 = p-FchDoc-2.
EMPTY TEMP-TABLE CMOV.
EMPTY TEMP-TABLE DMOV.
EMPTY TEMP-TABLE T-SALKIT.
FOR EACH Almcmov NO-LOCK WHERE {&Condicion}:
    /* Buscamos si tiene al menos un kit */
    FIND FIRST Almdmov OF Almcmov WHERE CAN-FIND(FIRST vtactabla WHERE vtactabla.codcia = s-codcia AND
                                                 vtactabla.tabla = 'PACKS-ECOMERCE' AND 
                                                 vtactabla.llave = Almdmov.codmat NO-LOCK)
                                                NO-LOCK NO-ERROR. 
    IF AVAILABLE(Almdmov) THEN DO:
        CREATE CMOV.
        BUFFER-COPY Almcmov TO CMOV.
    END.
END.
DEF VAR x-Cuenta AS INT NO-UNDO.
FOR EACH CMOV NO-LOCK:
    FOR EACH Almdmov OF CMOV NO-LOCK, FIRST vtactabla NO-LOCK WHERE vtactabla.codcia = s-codcia
        AND vtactabla.tabla = 'PACKS-ECOMERCE'
        AND vtactabla.llave = Almdmov.codmat:

        x-Cuenta = 0.
        FOR EACH vtadtabla WHERE vtadtabla.CodCia = vtactabla.CodCia AND
                                vtadtabla.tabla = vtactabla.tabla AND
                                vtadtabla.llave = vtactabla.llave NO-LOCK,
                                FIRST almmmatg WHERE almmmatg.codcia = vtactabla.codcia AND                                                    
                                almmmatg.codmat = vtadtabla.llavedetalle NO-LOCK:
            x-Cuenta = x-Cuenta + vtadtabla.libre_d01.
        END.

        IF x-Cuenta = 0 THEN NEXT.
        IF (Almdmov.CanDes * Almdmov.Factor) MODULO x-Cuenta > 0 THEN NEXT.
        /* Movimiento de SALIDA del PADRE */
        CREATE T-SALKIT.
        BUFFER-COPY Almdmov TO T-SALKIT.
        /* Detalle de los ITEMS x KITs */
        FOR EACH vtadtabla WHERE vtadtabla.codcia = vtactabla.codcia AND 
                                    vtadtabla.tabla = 'PACKS-ECOMERCE' AND
                                    vtadtabla.llave = vtactabla.llave NO-LOCK,
                            FIRST almmmatg WHERE almmmatg.codcia = vtadtabla.codcia AND 
                                                    almmmatg.codmat = vtadtabla.llavedetalle NO-LOCK.

            FIND FIRST DMOV OF CMOV WHERE DMOV.codmat = vtadtabla.llavedetalle NO-ERROR.
            IF NOT AVAILABLE dmov THEN DO:
                CREATE DMOV.
                BUFFER-COPY CMOV TO DMOV
                    ASSIGN 
                    DMOV.CodMat = vtadtabla.llavedetalle
                    DMOV.CodUnd = Almmmatg.UndStk
                    DMOV.PreUni = 0
                    DMOV.CodMon = 1
                    DMOV.Factor = 1
                    DMOV.CanDes = 0.    /* Ic 12Abr2018 */
                /* Valorizacion */
                FIND LAST Almstkge WHERE Almstkge.codcia = s-codcia
                    AND Almstkge.codmat = Almdmov.CodMat
                    AND Almstkge.fecha <= TODAY
                    NO-LOCK NO-ERROR.
                IF AVAILABLE Almstkge THEN ASSIGN DMOV.PreUni = AlmStkge.CtoUni / x-Cuenta.
            END.
            ASSIGN
                DMOV.CanDes = DMOV.CanDes + (Almdmov.CanDes * Almdmov.Factor / x-Cuenta * vtadtabla.libre_d01)
                DMOV.ImpCto = DMOV.CanDes * DMOV.PreUni.
        END.
    END.
END.
FOR EACH CMOV:
    FIND FIRST DMOV OF CMOV NO-LOCK NO-ERROR.
    IF NOT AVAILABLE DMOV THEN DELETE CMOV.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
IF NOT CAN-FIND(FIRST CMOV NO-LOCK) THEN DO:
    MESSAGE 'Fin de Archivo' VIEW-AS ALERT-BOX WARNING.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-borrar B-table-Win 
PROCEDURE Carga-Temporal-borrar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER p-FchDoc-1 AS DATE.
DEF INPUT PARAMETER p-FchDoc-2 AS DATE.

ASSIGN
    x-FchDoc-1 = p-FchDoc-1
    x-FchDoc-2 = p-FchDoc-2.
EMPTY TEMP-TABLE CMOV.
EMPTY TEMP-TABLE DMOV.
EMPTY TEMP-TABLE T-SALKIT.
FOR EACH Almcmov NO-LOCK WHERE {&Condicion}:
    /* Buscamos si tiene al menos un kit */
    FIND FIRST Almdmov OF Almcmov WHERE CAN-FIND(FIRST Almckits WHERE Almckits.codcia = s-codcia
                                                 AND Almckits.codmat = "K" + Almdmov.codmat
                                                 NO-LOCK) NO-LOCK NO-ERROR.
    IF AVAILABLE(Almdmov) THEN DO:
        CREATE CMOV.
        BUFFER-COPY Almcmov TO CMOV.
    END.
END.
DEF VAR x-Cuenta AS INT NO-UNDO.
FOR EACH CMOV NO-LOCK:
    FOR EACH Almdmov OF CMOV NO-LOCK, FIRST Almckits NO-LOCK WHERE Almckits.codcia = s-codcia
        AND Almckits.codmat = "K" + Almdmov.codmat:
        x-Cuenta = 0.
        FOR EACH AlmDKits WHERE AlmDKits.CodCia = AlmCKits.CodCia
            AND AlmDKits.codmat = AlmCKits.codmat NO-LOCK,
            FIRST Almmmatg WHERE Almmmatg.CodCia = AlmDKits.CodCia
            AND Almmmatg.codmat = AlmDKits.codmat2 NO-LOCK:
            x-Cuenta = x-Cuenta + AlmDKits.Cantidad.
        END.
        IF x-Cuenta = 0 THEN NEXT.
        IF (Almdmov.CanDes * Almdmov.Factor) MODULO x-Cuenta > 0 THEN NEXT.
        /* Detalle de los KITs */
        CREATE T-SALKIT.
        BUFFER-COPY Almdmov TO T-SALKIT.
        /* Detalle de los ITEMS x KITs */
        FOR EACH AlmDKits WHERE AlmDKits.CodCia = AlmCKits.CodCia
            AND AlmDKits.codmat = AlmCKits.codmat NO-LOCK,
            FIRST Almmmatg WHERE Almmmatg.CodCia = AlmDKits.CodCia
            AND Almmmatg.codmat = AlmDKits.codmat2 NO-LOCK:
            FIND FIRST DMOV OF CMOV WHERE DMOV.codmat = AlmDKits.codmat2 NO-ERROR.
            IF NOT AVAILABLE DMOV THEN DO:
                CREATE DMOV.
                BUFFER-COPY CMOV TO DMOV
                    ASSIGN 
                    DMOV.CodMat = AlmDKits.codmat2
                    DMOV.CodUnd = Almmmatg.UndStk
                    DMOV.PreUni = 0
                    DMOV.CodMon = 1
                    DMOV.Factor = 1.
                /* Valorizacion */
                FIND LAST Almstkge WHERE Almstkge.codcia = s-codcia
                    AND Almstkge.codmat = Almdmov.CodMat
                    AND Almstkge.fecha <= TODAY
                    NO-LOCK NO-ERROR.
                /*IF AVAILABLE Almstkge THEN ASSIGN DMOV.PreUni = AlmStkge.CtoUni / x-Cuenta.*/
                IF AVAILABLE Almstkge THEN ASSIGN DMOV.PreUni = AlmStkge.CtoUni.
            END.
            ASSIGN
                DMOV.CanDes = DMOV.CanDes + (Almdmov.CanDes * Almdmov.Factor / x-Cuenta * AlmDKits.Cantidad)
                DMOV.ImpCto = DMOV.CanDes * DMOV.PreUni.
        END.
    END.
END.
FOR EACH CMOV:
    FIND FIRST DMOV OF CMOV NO-LOCK NO-ERROR.
    IF NOT AVAILABLE DMOV THEN DELETE CMOV.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).
IF NOT CAN-FIND(FIRST CMOV NO-LOCK) THEN DO:
    MESSAGE 'Fin de Archivo' VIEW-AS ALERT-BOX WARNING.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Proceso-Principal B-table-Win 
PROCEDURE Proceso-Principal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND LAST gn-tcmb NO-LOCK NO-ERROR.
IF AVAILABLE gn-tcmb THEN f-TPOCMB = gn-tcmb.compra.

FIND FIRST Almtdocm WHERE Almtdocm.CodCia = S-CODCIA 
    AND Almtdocm.CodAlm = S-CODALM 
    AND Almtdocm.TipMov = "S" 
    AND LOOKUP(STRING(Almtdocm.CodMov, '99'), C-CODMOV) > 0
    NO-LOCK NO-ERROR.

/* Por cada CMOV generamos una reclasificación */
cMensaje = "".
IF NOT AVAILABLE CMOV THEN RETURN.
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    {lib/lock-genericov3.i
        &Tabla="Almcmov"
        &Condicion="Almcmov.CodCia = CMOV.codcia ~
        AND Almcmov.CodAlm = CMOV.codalm ~
        AND Almcmov.TipMov = CMOV.tipmov ~
        AND Almcmov.CodMov = CMOV.codmov ~
        AND Almcmov.NroSer = CMOV.nroser ~
        AND Almcmov.NroDoc = CMOV.nrodoc"
        &Bloqueo="EXCLUSIVE-LOCK"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="cMensaje"
        &TipoError="UNDO, LEAVE"
        &Intentos=2
        }
    ASSIGN
        Almcmov.FlgEst = "P".   /* Procesado */
    RUN SUB-PROCESO.
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, LEAVE.
    IF AVAILABLE(Almacen) THEN RELEASE Almacen.
    IF AVAILABLE(Almcmov) THEN RELEASE Almcmov.
    IF AVAILABLE(Almdmov) THEN RELEASE Almdmov.
END.
IF cMensaje > '' THEN DO:
    MESSAGE cMensaje VIEW-AS ALERT-BOX ERROR.
END.
ELSE MESSAGE 'Proceso culminado con éxito' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

PROCEDURE SUB-PROCESO:
/* ****************** */

DEF VAR x-CorrSal LIKE Almacen.CorrSal NO-UNDO.
DEF VAR x-CorrIng LIKE Almacen.CorrIng NO-UNDO.
DEF VAR cNroRf1 AS CHAR NO-UNDO.

/* Guardamos la referencia del ingreso transferencia */
ASSIGN cNroRf1 = STRING(Almcmov.NroSer,'999') + STRING(Almcmov.NroDoc).

DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
  {lib/lock-genericov3.i 
      &Tabla="Almacen "
      &Condicion="Almacen.CodCia = s-CodCia AND Almacen.CodAlm = s-CodAlm"
      &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
      &Accion="RETRY"
      &Mensaje="NO"
      &txtMensaje="cMensaje"
      &TipoError="UNDO, RETURN 'ADM-ERROR'"}
  /* ********************************************************************************* */
  /* CABECERAS */
  /* ********************************************************************************* */
  SALIDAS:
  REPEAT:
      ASSIGN
          x-CorrSal = Almacen.CorrSal.
      IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia 
                      AND Almcmov.codalm = Almtdocm.CodAlm
                      AND Almcmov.tipmov = "S"
                      AND Almcmov.codmov = Almtdocm.CodMov
                      AND Almcmov.nroser = s-NroSer
                      AND Almcmov.nrodoc = x-CorrSal
                      NO-LOCK)
          THEN LEAVE.
      ASSIGN
          Almacen.CorrSal = Almacen.CorrSal + 1.
  END.
  INGRESOS:
  REPEAT:
      ASSIGN
          x-CorrIng = Almacen.CorrIng.
      IF NOT CAN-FIND(FIRST Almcmov WHERE Almcmov.codcia = Almtdocm.CodCia 
                      AND Almcmov.codalm = Almtdocm.CodAlm
                      AND Almcmov.tipmov = "I"
                      AND Almcmov.codmov = Almtdocm.CodMov
                      AND Almcmov.nroser = s-NroSer
                      AND Almcmov.nrodoc = x-CorrIng
                      NO-LOCK)
          THEN LEAVE.
      ASSIGN
          Almacen.CorrIng = Almacen.CorrIng + 1.
  END.
  /* MOVIMIENTO DE SALIDA */
  CREATE Almcmov.
  ASSIGN 
      Almcmov.CodCia = Almtdocm.CodCia 
      Almcmov.CodAlm = Almtdocm.CodAlm 
      Almcmov.TipMov = Almtdocm.TipMov
      Almcmov.CodMov = Almtdocm.CodMov
      Almcmov.NroSer = S-NROSER
      Almcmov.Nrodoc  = Almacen.CorrSal
      Almcmov.HorSal = STRING(TIME,"HH:MM:SS")
      Almcmov.TpoCmb  = F-TPOCMB
      Almcmov.NroRf1 = cNroRf1.
  /* MOVIMIENTO DE ENTRADA */
  CREATE B-CMOV.
  BUFFER-COPY Almcmov 
      TO B-CMOV
      ASSIGN
      B-CMOV.TipMov = "I"
      B-CMOV.Nrodoc = Almacen.CorrIng
      B-CMOV.NroRef = STRING(Almcmov.nroser, '999') + STRING(Almcmov.nrodoc, '9999999').
  ASSIGN 
      Almcmov.NroRef = STRING(B-CMOV.nroser, '999') + STRING(B-CMOV.nrodoc, '9999999').
  ASSIGN
      Almacen.CorrSal = Almacen.CorrSal + 1
      Almacen.CorrIng = Almacen.CorrIng + 1.
  ASSIGN 
      Almcmov.usuario = S-USER-ID.
  /* ********************************************************************************* */
  /* ********************************************************************************* */
  /* DETALLES */
  /* ********************************************************************************* */
  DEF VAR N-Itm AS INTEGER NO-UNDO.
  DEF VAR r-Rowid AS ROWID NO-UNDO.
  DEF VAR pComprometido AS DEC.

  /* SALIDAS */
  EMPTY TEMP-TABLE ITEM.
  FOR EACH T-SALKIT OF CMOV NO-LOCK:
      CREATE ITEM.
      BUFFER-COPY T-SALKIT TO ITEM.
  END.
  N-Itm = 0.
  FOR EACH ITEM BY ITEM.NroItm:
      N-Itm = N-Itm + 1.
      CREATE almdmov.
      ASSIGN 
          Almdmov.CodCia = Almcmov.CodCia 
          Almdmov.CodAlm = Almcmov.CodAlm 
          Almdmov.TipMov = Almcmov.TipMov 
          Almdmov.CodMov = Almcmov.CodMov 
          Almdmov.NroSer = Almcmov.NroSer 
          Almdmov.NroDoc = Almcmov.NroDoc 
          Almdmov.CodMon = Almcmov.CodMon 
          Almdmov.FchDoc = Almcmov.FchDoc 
          Almdmov.TpoCmb = Almcmov.TpoCmb
          Almdmov.codmat = ITEM.codmat
          Almdmov.CanDes = ITEM.CanDes
          Almdmov.CodUnd = ITEM.CodUnd
          Almdmov.Factor = ITEM.Factor
          Almdmov.PreBas = ITEM.PreBas
          Almdmov.ImpCto = ITEM.ImpCto
          Almdmov.PreUni = ITEM.PreUni
          Almdmov.NroItm = N-Itm
          Almdmov.CodAjt = ''
          Almdmov.HraDoc = almcmov.HorSal
          R-ROWID = ROWID(Almdmov).
      FIND Almmmatg OF Almdmov NO-LOCK.
      ASSIGN
          Almdmov.CodUnd = Almmmatg.UndStk.
      RUN alm/almdcstk (R-ROWID).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      RUN ALM\ALMACPR1 (R-ROWID,"U").
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  /* ENTRADAS */
  EMPTY TEMP-TABLE ITEM.
  FOR EACH DMOV OF CMOV NO-LOCK:
      CREATE ITEM.
      BUFFER-COPY DMOV TO ITEM.
  END.
  /* RHC 28.01.10 El codigo destino se puede repetir => acumular por codigo */
  N-Itm = 0.
  FOR EACH ITEM WHERE BY ITEM.NroItm:
      N-Itm = N-Itm + 1.
      CREATE almdmov.
      ASSIGN 
          Almdmov.CodCia = B-CMOV.CodCia 
          Almdmov.CodAlm = B-CMOV.CodAlm 
          Almdmov.TipMov = B-CMOV.TipMov 
          Almdmov.CodMov = B-CMOV.CodMov 
          Almdmov.NroSer = B-CMOV.NroSer 
          Almdmov.NroDoc = B-CMOV.NroDoc 
          Almdmov.CodMon = B-CMOV.CodMon 
          Almdmov.FchDoc = B-CMOV.FchDoc 
          Almdmov.TpoCmb = B-CMOV.TpoCmb
          Almdmov.codmat = ITEM.codmat
          Almdmov.CanDes = 0  /* ITEM.CanDes */
          Almdmov.CodUnd = ITEM.CodUnd
          Almdmov.Factor = ITEM.Factor
          Almdmov.PreBas = ITEM.PreBas
          Almdmov.ImpCto = ITEM.ImpCto
          Almdmov.PreUni = ITEM.PreUni
          Almdmov.NroItm = N-Itm
          Almdmov.CodAjt = ''
          Almdmov.HraDoc = almcmov.HorSal
          R-ROWID = ROWID(Almdmov).
      FIND Almmmatg OF Almdmov NO-LOCK.
      ASSIGN
          Almdmov.CodUnd = Almmmatg.UndStk.
      ASSIGN 
          Almdmov.CanDes = Almdmov.candes + ITEM.CanDes
          Almdmov.ImpCto = ITEM.ImpCto
          Almdmov.PreUni = (ITEM.ImpCto / ITEM.CanDes).
      /* fin de valorizaciones */
      FIND FIRST Almtmovm WHERE Almtmovm.CodCia = B-CMOV.CodCia 
          AND  Almtmovm.Tipmov = B-CMOV.TipMov 
          AND  Almtmovm.Codmov = B-CMOV.CodMov 
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almtmovm AND Almtmovm.PidPCo 
          THEN ASSIGN Almdmov.CodAjt = "A".
      ELSE ASSIGN Almdmov.CodAjt = ''.
      RUN ALM\ALMACSTK (R-ROWID).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      RUN ALM\ALMACPR1 (R-ROWID,"U").
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. 
  END.

  /* ********************************************************************* */
    /*  SALIDAS */
  /* ********************************************************************* */
  /* Ic - 12Ene2018 Log para e-Commerce */
  DEF VAR pOk AS LOG NO-UNDO.
  RUN gn/log-inventory-qty.p (ROWID(Almcmov),
                            "C",      /* CREATE */
                            OUTPUT pOk).
  IF pOk = NO THEN DO:
    UNDO, RETURN 'ADM-ERROR'.
  END.

  /*  ENTRADAS */
  pOk = NO.
  RUN gn/log-inventory-qty.p (ROWID(B-CMOV),
                            "C",      /* CREATE */
                            OUTPUT pOk).
  IF pOk = NO THEN DO:
    UNDO, RETURN 'ADM-ERROR'.
  END.

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
  {src/adm/template/snd-list.i "CMOV"}
  {src/adm/template/snd-list.i "Almcmov"}

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

