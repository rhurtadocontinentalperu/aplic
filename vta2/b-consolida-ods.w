&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE CDOCU LIKE VtaCDocu.



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
DEF SHARED VAR s-coddoc AS CHAR.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEFINE TEMP-TABLE ttOrdenes
    FIELDS  ttCoddoc    AS  CHAR    FORMAT 'x(5)'
    FIELD   ttNrodoc    AS  CHAR    FORMAT 'x(20)'.

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
&Scoped-define INTERNAL-TABLES CDOCU

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CDOCU.NroPed CDOCU.CodCli ~
CDOCU.NomCli 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table CDOCU.NroPed 
&Scoped-define ENABLED-TABLES-IN-QUERY-br_table CDOCU
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br_table CDOCU
&Scoped-define QUERY-STRING-br_table FOR EACH CDOCU WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CDOCU WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table CDOCU
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CDOCU


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table BUTTON-20 

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
DEFINE BUTTON BUTTON-20 
     LABEL "CONSOLIDAR" 
     SIZE 38 BY 1.62
     FONT 8.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CDOCU SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CDOCU.NroPed COLUMN-LABEL "Codigo de Barra o Numero" FORMAT "X(20)":U
            COLUMN-FGCOLOR 0 COLUMN-BGCOLOR 11
      CDOCU.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U WIDTH 10.86
      CDOCU.NomCli FORMAT "x(80)":U
  ENABLE
      CDOCU.NroPed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 93 BY 12.65
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     BUTTON-20 AT ROW 13.92 COL 4 WIDGET-ID 2
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
      TABLE: CDOCU T "?" ? INTEGRAL VtaCDocu
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
         HEIGHT             = 15.19
         WIDTH              = 96.29.
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
     _TblList          = "Temp-Tables.CDOCU"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.CDOCU.NroPed
"CDOCU.NroPed" "Codigo de Barra o Numero" "X(20)" "character" 11 0 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.CDOCU.CodCli
"CDOCU.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "10.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.CDOCU.NomCli
"CDOCU.NomCli" ? "x(80)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME CDOCU.NroPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CDOCU.NroPed br_table _BROWSE-COLUMN B-table-Win
ON LEAVE OF CDOCU.NroPed IN BROWSE br_table /* Codigo de Barra o Numero */
DO:
    IF SELF:SCREEN-VALUE = '' THEN RETURN.
    SELF:SCREEN-VALUE = REPLACE(SELF:SCREEN-VALUE,"'","-").
    IF LENGTH(SELF:SCREEN-VALUE) > 12 THEN DO:
        /* Transformamos el número */
        FIND Facdocum WHERE Facdocum.codcia = s-codcia 
            AND Facdocum.codcta[8] = SUBSTRING(SELF:SCREEN-VALUE,1,3)
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacDocum THEN DO:
            IF FacDocum.CodDoc <> s-CodDoc THEN DO:
                MESSAGE "El comprobante NO es una Sub-Orden de Despacho" VIEW-AS ALERT-BOX ERROR.
                SELF:SCREEN-VALUE = ''.
                RETURN NO-APPLY.
            END.
            SELF:SCREEN-VALUE = SUBSTRING(SELF:SCREEN-VALUE,4).
        END.
    END.
    /* Buscamos Sub-Orden */
    FIND Vtacdocu WHERE Vtacdocu.codcia = s-codcia 
        AND Vtacdocu.divdes = s-CodDiv
        AND Vtacdocu.codped = s-CodDoc
        AND Vtacdocu.nroped = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtacdocu THEN DO:
        MESSAGE 'Sub-Orden de Despacho NO registrada' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    /*RD01- Verifica si la orden ya ha sido chequeado*/
    IF NOT (Vtacdocu.flgest = 'P' AND Vtacdocu.flgsit = 'T') THEN DO:
        MESSAGE 'La Sub-Orden NO está pendiente de cierre' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF Vtacdocu.flgimpod = NO THEN DO:
        MESSAGE 'La Sub-Orden NO está impresa' VIEW-AS ALERT-BOX ERROR.
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    DISPLAY  
        VtaCDocu.CodCli @ CDOCU.CodCli 
        VtaCDocu.NomCli @ CDOCU.NomCli
        WITH BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-20
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-20 B-table-Win
ON CHOOSE OF BUTTON-20 IN FRAME F-Main /* CONSOLIDAR */
DO:
  RUN Consolidar.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Consolidar B-table-Win 
PROCEDURE Consolidar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Verificamos que pertenezca a la misma seccion */
DEF BUFFER B-CDOCU FOR Vtacdocu.
DEF BUFFER B-DDOCU FOR Vtaddocu.

DEF VAR lSeccion AS CHAR NO-UNDO.
DEF VAR s-nroser AS INT NO-UNDO.
DEF VAR cMsgError AS CHAR NO-UNDO.
DEF VAR lNroItm AS INT NO-UNDO.

EMPTY TEMP-TABLE ttordenes.
DEFINE VAR x-orden AS CHAR.

DEF VAR pCodDoc AS CHAR NO-UNDO.

CASE s-CodDoc:
    WHEN "O/D" THEN pCodDoc = "ODC".
    WHEN "OTR" THEN pCodDoc = "OTC".
    OTHERWISE RETURN.
END CASE.
FIND FIRST Faccorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddiv = s-coddiv
    AND Faccorre.coddoc = pCodDoc
    AND Faccorre.flgest = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Faccorre THEN DO:
    MESSAGE 'NO está definido el correlativo para el documento' pCodDoc
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
s-nroser = Faccorre.nroser.

FOR EACH CDOCU NO-LOCK:
    IF TRUE <> (lSeccion > '') THEN lSeccion = ENTRY(2,CDOCU.nroPed,'-').
    ELSE IF LOOKUP(ENTRY(2,CDOCU.nroPed,'-'),lSeccion) = 0 THEN lSeccion = lSeccion + ',' + ENTRY(2,CDOCU.nroPed,'-').
END.
IF NUM-ENTRIES(lSeccion) > 1 THEN DO:
    MESSAGE 'TODAS las Sub_ordenes deben pertenecer a la misma sección' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
MESSAGE 'Procedemos con la Consolidación?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.
cMsgError = ''.
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    {vta2/icorrelativosecuencial.i &Codigo = pCodDoc &Serie = s-nroser}
    CREATE Vtacdocu.
    ASSIGN 
        VtaCDocu.CodCia = s-codcia
        VtaCDocu.CodDiv = s-coddiv
        VtaCDocu.DivDes = s-coddiv
        VtaCDocu.CodPed = pCodDoc
        VtaCDocu.NroPed = STRING(s-nroser,'999') + STRING(Faccorre.correlativo,'999999') + "-" + lSeccion
        VtaCDocu.CodCli = '11111111111'
        VtaCDocu.FchPed = TODAY
        VtaCDocu.FlgEst = 'P'
        VtaCDocu.FlgSit = 'T'
        VtaCDocu.UsrImpOD = ''
        VtaCDocu.FlgImpOD = NO
        VtaCDocu.FchImpOD = ?
        VtaCDocu.Hora   = STRING(TIME,'HH:MM:SS')
        VtaCDocu.NomCli = "CONSOLIDADO"
        VtaCDocu.Usuario = s-user-id
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        cMsgError = "Error al grabar la suborden" + CHR(10) + "Revise el control de correlativos".
        UNDO, LEAVE.
    END.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    lNroItm = 0.
    FOR EACH CDOCU NO-LOCK, FIRST B-CDOCU OF CDOCU EXCLUSIVE-LOCK:
        x-orden = ENTRY(1,CDOCU.nroped,"-").
        FIND FIRST ttOrdenes WHERE ttOrdenes.ttnrodoc = x-orden NO-ERROR.
        IF NOT AVAILABLE ttOrdenes THEN DO:
            CREATE ttOrdenes.
            ASSIGN ttNroDoc = x-orden.
        END.
        ASSIGN
            VtaCDocu.DivDes = B-CDOCU.DivDes
            VtaCDocu.CodOri = B-CDOCU.CodPed
            VtaCDocu.NroOri = VtaCDocu.NroOri + (IF TRUE <> (VtaCDocu.NroOri > '')
                                                 THEN '' ELSE ',') + B-CDOCU.NroPed.
        FOR EACH B-DDOCU OF B-CDOCU NO-LOCK, FIRST Almmmatg OF B-DDOCU NO-LOCK:
            FIND FIRST Vtaddocu OF Vtacdocu WHERE Vtaddocu.codmat = B-DDOCU.codmat
                EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE Vtaddocu THEN DO:
                CREATE Vtaddocu.
                ASSIGN
                    Vtaddocu.codcia = VtaCDocu.CodCia 
                    Vtaddocu.coddiv = VtaCDocu.CodDiv 
                    Vtaddocu.codped = VtaCDocu.CodPed 
                    Vtaddocu.nroped = VtaCDocu.NroPed
                    Vtaddocu.codcli = Vtacdocu.CodCli.
                lNroItm = lNroItm + 1.
            END.
            ASSIGN
                VtaDDocu.CodMat = B-DDOCU.codmat
                VtaDDocu.CanAte = VtaDDocu.CanAte + (B-DDOCU.canate * B-DDOCU.factor)
                VtaDDocu.CanBase = VtaDDocu.CanBase + (B-DDOCU.canbase * B-DDOCU.factor)
                VtaDDocu.CanPed = VtaDDocu.CanPed + (B-DDOCU.canped * B-DDOCU.factor)
                VtaDDocu.CanPick = VtaDDocu.CanPick + (B-DDOCU.canpick * B-DDOCU.factor)
                VtaDDocu.Factor = 1
                VtaDDocu.NroItm = lNroItm
                VtaDDocu.PesMat = VtaDDocu.PesMat + B-DDOCU.pesmat
                VtaDDocu.UndVta = Almmmatg.undstk
                VtaDDocu.almdes = B-DDOCU.Almdes.

            /* Ic - 14Feb2018 */
                ASSIGN VtaCDocu.items = VtaCDocu.items + 1
                        VtaCDocu.peso = VtaCDocu.peso + B-DDOCU.pesmat
                        VtaCDocu.volumen = VtaCDocu.volumen + ((B-DDOCU.canate * B-DDOCU.factor) * (almmmatg.libre_d02 / 1000000) ).
        END.
        ASSIGN
            B-CDOCU.FlgEst = "X".   /* CONSOLIDADO */
    END.
END.
IF AVAILABLE(B-CDOCU)  THEN RELEASE B-CDOCU.
IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
IF AVAILABLE(Vtacdocu) THEN RELEASE Vtacdocu.
IF AVAILABLE(Vtaddocu) THEN RELEASE Vtaddocu.
IF cMsgError > '' THEN DO:
    MESSAGE cMsgError VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
MESSAGE 'Proceso Exitoso' VIEW-AS ALERT-BOX INFORMATION.
EMPTY TEMP-TABLE CDOCU.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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
  BUFFER-COPY Vtacdocu TO CDOCU.


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
  DO WITH FRAME {&FRAME-NAME}:
      BUTTON-20:SENSITIVE = YES.
  END.

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
  DO WITH FRAME {&FRAME-NAME}:
      BUTTON-20:SENSITIVE = NO.
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
  {src/adm/template/snd-list.i "CDOCU"}

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

IF CDOCU.NroPed:SCREEN-VALUE IN BROWSE {&browse-name} = '' THEN DO:
    APPLY 'ENTRY':U TO CDOCU.NroPed.
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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

