&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CCAJA FOR CcbCCaja.
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.
DEFINE TEMP-TABLE T-CcbCCaja LIKE CcbCCaja.
DEFINE TEMP-TABLE T-CDOCU LIKE CcbCDocu.



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
DEF SHARED VAR s-user-id AS CHAR.
DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR s-Glosa-1 AS CHAR INIT 'ANULADO DOCUMENTARIAMENTE' NO-UNDO.
DEF VAR s-Glosa-2 AS CHAR INIT 'CANJE DOCUMENTARIO' NO-UNDO.

DEFINE VARIABLE s-CodCja AS CHAR INIT "I/C" NO-UNDO.
DEFINE VARIABLE s-Tipo AS CHAR INIT "MOSTRADOR" NO-UNDO.

&SCOPED-DEFINE Condicion ( CcbCCaja.CodCia = s-codcia ~
AND CcbCCaja.CodDiv = s-coddiv ~
AND CcbCCaja.CodDoc = s-CodCja ~
AND CcbCCaja.FlgEst <> "A" ~
AND CcbCCaja.FlgCie = "P" ~
AND CcbCCaja.Tipo = s-Tipo ~
AND (CcbCCaja.Glosa <> s-Glosa-1 AND CcbCCaja.Glosa <> s-Glosa-2) ~
AND (COMBO-BOX-Usuario = 'Todos' OR CcbCCaja.usuario = COMBO-BOX-Usuario) )

    DEF VAR ix AS INTEGER NO-UNDO.

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
&Scoped-define INTERNAL-TABLES CcbCCaja CcbDCaja

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table CcbCCaja.usuario CcbCCaja.FchDoc ~
CcbCCaja.CodDoc CcbCCaja.NroDoc CcbCCaja.CodCli CcbCCaja.NomCli ~
CcbDCaja.CodRef CcbDCaja.NroRef 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH CcbCCaja WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST CcbDCaja OF CcbCCaja NO-LOCK ~
    BY CcbCCaja.NroDoc DESCENDING
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH CcbCCaja WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK, ~
      FIRST CcbDCaja OF CcbCCaja NO-LOCK ~
    BY CcbCCaja.NroDoc DESCENDING.
&Scoped-define TABLES-IN-QUERY-br_table CcbCCaja CcbDCaja
&Scoped-define FIRST-TABLE-IN-QUERY-br_table CcbCCaja
&Scoped-define SECOND-TABLE-IN-QUERY-br_table CcbDCaja


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-6 BUTTON-7 COMBO-BOX-Usuario br_table 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Usuario 

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
DEFINE BUTTON BUTTON-6 
     LABEL "ANULACION DOCUMENTARIA" 
     SIZE 31 BY 1.12.

DEFINE BUTTON BUTTON-7 
     LABEL "REFRESCAR" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE COMBO-BOX-Usuario AS CHARACTER FORMAT "X(256)":U INITIAL "Todos" 
     LABEL "Cajero" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Todos" 
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      CcbCCaja, 
      CcbDCaja SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      CcbCCaja.usuario COLUMN-LABEL "Cajero" FORMAT "x(10)":U
      CcbCCaja.FchDoc FORMAT "99/99/9999":U
      CcbCCaja.CodDoc FORMAT "x(3)":U
      CcbCCaja.NroDoc FORMAT "X(12)":U WIDTH 11.86
      CcbCCaja.CodCli FORMAT "x(11)":U WIDTH 11.43
      CcbCCaja.NomCli COLUMN-LABEL "Nombre" FORMAT "X(60)":U
      CcbDCaja.CodRef FORMAT "x(3)":U
      CcbDCaja.NroRef FORMAT "X(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 109 BY 16.54
         FONT 4 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-6 AT ROW 1 COL 50 WIDGET-ID 4
     BUTTON-7 AT ROW 1 COL 81 WIDGET-ID 6
     COMBO-BOX-Usuario AT ROW 1.19 COL 16 COLON-ALIGNED WIDGET-ID 2
     br_table AT ROW 2.35 COL 1
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
      TABLE: B-CCAJA B "?" ? INTEGRAL CcbCCaja
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-DDOCU B "?" ? INTEGRAL CcbDDocu
      TABLE: T-CcbCCaja T "?" ? INTEGRAL CcbCCaja
      TABLE: T-CDOCU T "?" ? INTEGRAL CcbCDocu
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
         HEIGHT             = 19
         WIDTH              = 127.14.
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
/* BROWSE-TAB br_table COMBO-BOX-Usuario F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "INTEGRAL.CcbCCaja,INTEGRAL.CcbDCaja OF INTEGRAL.CcbCCaja"
     _Options          = "NO-LOCK KEY-PHRASE"
     _TblOptList       = ", FIRST"
     _OrdList          = "INTEGRAL.CcbCCaja.NroDoc|no"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > INTEGRAL.CcbCCaja.usuario
"CcbCCaja.usuario" "Cajero" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = INTEGRAL.CcbCCaja.FchDoc
     _FldNameList[3]   = INTEGRAL.CcbCCaja.CodDoc
     _FldNameList[4]   > INTEGRAL.CcbCCaja.NroDoc
"CcbCCaja.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "11.86" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > INTEGRAL.CcbCCaja.CodCli
"CcbCCaja.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > INTEGRAL.CcbCCaja.NomCli
"CcbCCaja.NomCli" "Nombre" "X(60)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = INTEGRAL.CcbDCaja.CodRef
     _FldNameList[8]   = INTEGRAL.CcbDCaja.NroRef
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


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 B-table-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* ANULACION DOCUMENTARIA */
DO:
  MESSAGE 'Se va a Proceder a la anulación documentaria' SKIP
      'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN NO-APPLY.
  RUN Genera-Comprobantes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 B-table-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* REFRESCAR */
DO:
  RUN dispatch IN THIS-PROCEDURE ('open-query':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Usuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Usuario B-table-Win
ON VALUE-CHANGED OF COMBO-BOX-Usuario IN FRAME F-Main /* Cajero */
DO:
  ASSIGN {&SELF-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Comprobantes B-table-Win 
PROCEDURE Genera-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Filtros de Control */
IF NOT AVAILABLE Ccbccaja THEN RETURN.
FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK.
EMPTY TEMP-TABLE T-CDOCU.   /* Aqui guardamos los nuevos comprobantes */
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
    /* Bloqueamos el I/C */
    FIND B-CCAJA WHERE ROWID(B-CCAJA) = ROWID(Ccbccaja) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF NOT AVAILABLE B-CCAJA THEN DO:
        pMensaje = "NO se pudo bloquear el I/C".
        UNDO, LEAVE.
    END.
    
    pMensaje = ''.
    /* 1ro. N/C x Devolucion */
    RUN Genera-NC.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = '' THEN pMensaje = 'ERROR al generar la N/C x devolución'.
        UNDO, LEAVE.
    END.

    /* 2do. Nuevas FAC */
    RUN Genera-FAC.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = '' THEN pMensaje = 'ERROR al generar la N/C x devolución'.
        UNDO, LEAVE.
    END.
    
    /* 2do. Nuevo I/C */
    RUN Genera-IC.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF pMensaje = '' THEN pMensaje = 'ERROR al generar el nuevo I/C'.
        UNDO, LEAVE.
    END.
    /* Grabamos control */
    ASSIGN
        B-CCAJA.Glosa = s-Glosa-1.
END.
IF AVAILABLE(B-CCAJA) THEN RELEASE B-CCAJA.
IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.
IF AVAILABLE(Almcmov)  THEN RELEASE Almcmov.
IF AVAILABLE(Almdmov)  THEN RELEASE Almdmov.
IF AVAILABLE(Almmmate) THEN RELEASE Almmmate.

IF pMensaje <> '' THEN DO:
    MESSAGE pMensaje SKIP 'Proceso Abortado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
    
pMensaje = 'Se han generado los siguientes documentos:' + CHR(10).
FOR EACH T-CDOCU NO-LOCK:
    pMensaje = pMensaje + T-CDOCU.coddoc + ' ' + T-CDOCU.nrodoc + CHR(10).
END.
MESSAGE pMensaje VIEW-AS ALERT-BOX INFORMATION.

RUN dispatch IN THIS-PROCEDURE ('open-query':U).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-FAC B-table-Win 
PROCEDURE Genera-FAC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-CodDoc AS CHAR NO-UNDO.
DEF VAR s-PtoVta AS INT NO-UNDO.

DEF BUFFER B-CDOCU FOR Ccbcdocu.
DEF BUFFER B-DDOCU FOR Ccbddocu.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.

TRLOOP:    
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* Rehacemos cada comprobante */
    FOR EACH Ccbdcaja OF Ccbccaja NO-LOCK, 
        FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = Ccbdcaja.codcia
        AND B-CDOCU.coddoc = Ccbdcaja.codref
        AND B-CDOCU.nrodoc = Ccbdcaja.nroref:
        s-CodDoc = B-CDOCU.CodDoc.
        x-Formato = '999-999999'.
        RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).
        /* Buscamos correlativo */
        FIND FIRST Ccbdterm WHERE CcbdTerm.CodCia = CcbCCaja.CodCia 
            AND CcbdTerm.CodDiv = CcbCCaja.CodDiv
            AND CcbdTerm.CodTer = CcbCCaja.CodCaja 
            AND CcbDTerm.CodDoc = s-CodDoc
            AND CAN-FIND(FIRST Ccbcterm OF Ccbdterm NO-LOCK)
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Ccbdterm THEN DO:
            pMensaje = "NO está configurado el comprobante " + s-coddoc + " en la caja " + CcbCCaja.CodCaja.
            UNDO TRLOOP, RETURN 'ADM-ERROR'.
        END.
        s-PtoVta = CcbDTerm.NroSer.
        /* Correlativo */
        {lib\lock-genericov21.i &Tabla="FacCorre" ~
            &Condicion="FacCorre.CodCia = s-CodCia ~
            AND FacCorre.CodDoc = s-CodDoc ~
            AND FacCorre.NroSer = s-PtoVta" ~
            &Bloqueo="EXCLUSIVE-LOCK" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &TipoError="UNDO TRLOOP, RETURN 'ADM-ERROR'" }
        CREATE Ccbcdocu.
        BUFFER-COPY B-CDOCU
            TO Ccbcdocu
            ASSIGN
            Ccbcdocu.coddiv = CcbCCaja.CodDiv
            CcbCDocu.NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) 
            CcbCDocu.FchDoc = TODAY 
            CcbCDocu.FchVto = TODAY 
            CcbCDocu.usuario = S-USER-ID
            CcbCDocu.HorCie = STRING(TIME,'hh:mm').
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
        FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
            CREATE Ccbddocu.
            BUFFER-COPY B-DDOCU
                TO Ccbddocu
                ASSIGN
                CcbDDocu.CodCia = Ccbcdocu.codcia
                CcbDDocu.CodDiv = Ccbcdocu.coddiv
                CcbDDocu.CodDoc = Ccbcdocu.coddoc
                CcbDDocu.NroDoc = Ccbcdocu.nrodoc
                CcbDDocu.FchDoc = CcbCDocu.FchDoc.
        END.
        /* GENERACION DE CONTROL DE PERCEPCIONES */
        RUN vta2/control-percepcion-cargos (ROWID(Ccbcdocu)) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN 'ADM-ERROR'.
        /* El documento nace Cancelado */
        ASSIGN
            Ccbcdocu.flgest = "C"
            Ccbcdocu.fchcan = TODAY
            Ccbcdocu.sdoact = 0.
        /* ************************************* */
        /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
        RUN sunat\progress-to-ppll ( INPUT ROWID(Ccbcdocu), OUTPUT pMensaje ).
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO trloop, RETURN 'ADM-ERROR'.
        /* *********************************************************** */
        /* Descarga de Almacen */
        RUN vta2/act_almv2 ( INPUT ROWID(CcbCDocu), OUTPUT pMensaje ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.

        CREATE T-CDOCU.
        BUFFER-COPY Ccbcdocu TO T-CDOCU.
        CATCH eBlockError AS PROGRESS.Lang.Error:
            IF pMensaje = '' AND eBlockError:NumMessages > 0 THEN DO:
                pMensaje = eBlockError:GetMessage(1).
                DO ix = 2 TO eBlockError:NumMessages:
                    pMensaje = pMensaje + CHR(10) + eBlockError:GetMessage(ix).
                END.
            END.
            DELETE OBJECT eBlockError.
            RETURN 'ADM-ERROR'.
        END CATCH.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-IC B-table-Win 
PROCEDURE Genera-IC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE x_NumDoc AS CHARACTER.
    DEFINE VARIABLE s-SerCja AS INT NO-UNDO.
    DEFINE VARIABLE s-CodTer AS CHAR NO-UNDO.
    DEFINE VARIABLE s-User-Id AS CHAR NO-UNDO.

    FIND FIRST Ccbdterm WHERE CcbdTerm.CodCia = CcbCCaja.CodCia 
        AND CcbdTerm.CodDiv = CcbCCaja.CodDiv
        AND CcbdTerm.CodTer = CcbCCaja.CodCaja 
        AND CcbDTerm.CodDoc = s-CodCja
        AND CAN-FIND(FIRST Ccbcterm OF Ccbdterm NO-LOCK)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbdterm THEN DO:
        pMensaje = "NO está configurado el documento " + s-codcja + " en la caja " + CcbCCaja.CodCaja.
        RETURN 'ADM-ERROR'.
    END.
    s-SerCja = CcbDTerm.NroSer.
    
    trloop:
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        EMPTY TEMP-TABLE T-Ccbccaja.
        CREATE T-Ccbccaja.
        BUFFER-COPY Ccbccaja TO T-Ccbccaja.
        ASSIGN
            T-Ccbccaja.ImpNac[6] = 0
            T-Ccbccaja.ImpUsa[6] = 0.
        FOR EACH T-CDOCU NO-LOCK WHERE T-CDOCU.CodDoc = "N/C":
            IF T-CDOCU.CodMon = 1 THEN T-Ccbccaja.ImpNac[6] = T-Ccbccaja.ImpNac[6] + T-CDOCU.ImpTot.
            ELSE T-Ccbccaja.ImpUsa[6] = T-Ccbccaja.ImpUsa[6] + T-CDOCU.ImpTot.
        END.
        ASSIGN
            s-CodTer  = CcbCCaja.CodCaja
            s-User-Id = CcbCCaja.Usuario
            s-Tipo    = CcbCCaja.Tipo.

        {lib\lock-genericov21.i &Tabla="FacCorre" ~
            &Condicion="FacCorre.CodCia = s-codcia ~
            AND FacCorre.CodDiv = s-coddiv ~
            AND FacCorre.CodDoc = s-codcja ~
            AND FacCorre.NroSer = s-sercja" ~
            &Bloqueo="EXCLUSIVE-LOCK" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &TipoError="UNDO, RETURN 'ADM-ERROR'" }
        /* Crea Cabecera de Caja */
        CREATE CcbCCaja.
        ASSIGN
            CcbCCaja.CodCia     = s-CodCia
            CcbCCaja.CodDiv     = s-CodDiv 
            CcbCCaja.CodDoc     = s-CodCja
            CcbCCaja.NroDoc     = STRING(FacCorre.NroSer,"999") +
                                    STRING(FacCorre.Correlativo,"999999")
            CcbCCaja.CodCaja    = s-CodTer
            CcbCCaja.usuario    = s-user-id
            CcbCCaja.CodCli     = T-Ccbccaja.codcli
            CcbCCaja.NomCli     = T-Ccbccaja.NomCli
            CcbCCaja.CodMon     = T-Ccbccaja.CodMon
            CcbCCaja.FchDoc     = TODAY
            CcbCCaja.ImpNac[6]  = T-CcbCCaja.ImpNac[6]
            CcbCCaja.ImpUsa[6]  = T-CcbCCaja.ImpUsa[6]
            CcbCCaja.Tipo       = s-Tipo
            CcbCCaja.TpoCmb     = T-CcbCCaja.TpoCmb
            CcbCCaja.FLGEST     = "C"
            CcbCCaja.Glosa      = s-Glosa-2.
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
        /* Crea Detalle de Caja */
        FOR EACH T-CDOCU NO-LOCK WHERE T-CDOCU.coddoc <> "N/C",
            FIRST CcbCDocu WHERE CcbCDocu.CodCia = T-CDOCU.CodCia
            AND CcbCDocu.CodDoc = T-CDOCU.CodDoc
            AND CcbCDocu.NroDoc = T-CDOCU.NroDoc:
            CREATE CcbDCaja.
            ASSIGN
                CcbDCaja.CodCia = CcbCCaja.CodCia
                CcbdCaja.CodDiv = CcbCCaja.CodDiv
                CcbDCaja.CodDoc = CcbCCaja.CodDoc
                CcbDCaja.NroDoc = CcbCCaja.NroDoc
                CcbDCaja.CodRef = CcbCDocu.CodDoc
                CcbDCaja.NroRef = CcbCDocu.NroDoc
                CcbDCaja.CodCli = CcbCDocu.CodCli
                CcbDCaja.CodMon = CcbCDocu.CodMon
                CcbDCaja.FchDoc = CcbCCaja.FchDoc
                CcbDCaja.ImpTot = T-CDOCU.ImpTot
                CcbDCaja.TpoCmb = CcbCCaja.TpoCmb.
        END.
        /* Aplicacion de las nuevas N/C */
        FOR EACH T-CDOCU NO-LOCK WHERE T-CDOCU.CodDoc = "N/C":
            RUN proc_AplicaDoc( T-CDOCU.CodDoc,
                                T-CDOCU.NroDoc,
                                CcbCCaja.NroDoc,
                                T-CcbCCaja.tpocmb,
                                IF T-CDOCU.CodMon = 1 THEN T-CDOCU.Imptot ELSE 0,
                                    IF T-CDOCU.CodMon = 2 THEN T-CDOCU.Imptot ELSE 0
                                        ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                pMensaje = "NO se pudo aplicar la Nota de Crédito".
                UNDO trloop, RETURN "ADM-ERROR".
            END.
        END.
        CATCH eBlockError AS PROGRESS.Lang.Error:
            IF pMensaje = '' AND eBlockError:NumMessages > 0 THEN DO:
                pMensaje = eBlockError:GetMessage(1).
                DO ix = 2 TO eBlockError:NumMessages:
                    pMensaje = pMensaje + CHR(10) + eBlockError:GetMessage(ix).
                END.
            END.
            DELETE OBJECT eBlockError.
            RETURN 'ADM-ERROR'.
        END CATCH.
    END.
    RETURN 'OK'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-NC B-table-Win 
PROCEDURE Genera-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       NC x Devolución
------------------------------------------------------------------------------*/

DEF VAR S-CODDOC AS CHAR INIT "N/C" NO-UNDO.
DEF VAR s-NroSer AS INT NO-UNDO.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

FIND FIRST Ccbdterm WHERE CcbdTerm.CodCia = CcbCCaja.CodCia 
    AND CcbdTerm.CodDiv = CcbCCaja.CodDiv
    AND CcbdTerm.CodTer = CcbCCaja.CodCaja 
    AND CcbDTerm.CodDoc = s-CodDoc
    AND CAN-FIND(FIRST Ccbcterm OF Ccbdterm NO-LOCK)
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbdterm THEN DO:
    pMensaje = "NO configurado el documento " + s-coddoc + " para la caja " + ccbccaja.codcaja.
    RETURN 'ADM-ERROR'.
END.
s-NroSer = CcbDTerm.NroSer.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Por cada comprobante se genera una N/C x devolución */
    FOR EACH Ccbdcaja OF Ccbccaja NO-LOCK, 
        FIRST B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = Ccbdcaja.codcia
        AND B-CDOCU.coddoc = Ccbdcaja.codref
        AND B-CDOCU.nrodoc = Ccbdcaja.nroref:
        
        pMensaje = "ERROR correlativo " + s-coddoc + " serie " + STRING(s-nroser).
        {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}
        pMensaje = "".
        CREATE Ccbcdocu.
        BUFFER-COPY B-CDOCU
            EXCEPT B-CDOCu.CodRef B-CDOCU.NroRef B-CDOCU.Glosa B-CDOCU.NroOrd
            TO CcbCDocu
            ASSIGN 
            CcbCDocu.CodCia = S-CODCIA
            CcbCDocu.CodDiv = S-CODDIV
            CcbCDocu.CodDoc = S-CODDOC
            CcbCDocu.NroDoc = STRING(FacCorre.NroSer, ENTRY(1, x-Formato, '-')) +
                              STRING(FacCorre.Correlativo, ENTRY(2, x-Formato, '-'))
            CcbCDocu.CodRef = B-CDOCU.coddoc
            CcbCDocu.NroRef = B-CDOCU.nrodoc
            CcbCDocu.FchDoc = TODAY
            CcbCDocu.FchVto = TODAY
            CcbCDocu.FlgEst = "P"
            CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
            CcbCDocu.CndCre = 'D'
            CcbCDocu.TpoFac = ""
            /*CcbCDocu.Tipo   = "OFICINA"*/
            CcbCDocu.Tipo   = "MOSTRADOR"
            CcbCDocu.CodCaja= CcbCCaja.CodCaja
            CcbCDocu.usuario = S-USER-ID
            CcbCDocu.SdoAct = B-CDOCU.ImpTot
            CcbCDocu.ImpTot2 = 0
            CcbCDocu.ImpDto2 = 0
            CcbCDocu.CodMov = 09.     /* INGRESO POR DEVOLUCION DEL CLIENTE */
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
        /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
        FIND GN-VEN WHERE gn-ven.codcia = s-codcia
            AND gn-ven.codven = B-CDOCU.codven
            NO-LOCK NO-ERROR.
        IF AVAILABLE GN-VEN THEN ccbcdocu.cco = gn-ven.cco.
        FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
            CREATE Ccbddocu.
            BUFFER-COPY B-DDOCU
                TO Ccbddocu
                ASSIGN
                CcbDDocu.CodCia = CcbCDocu.CodCia 
                CcbDDocu.Coddiv = CcbCDocu.Coddiv 
                CcbDDocu.CodDoc = CcbCDocu.CodDoc 
                CcbDDocu.NroDoc = CcbCDocu.NroDoc
                CcbDDocu.FchDoc = CcbCDocu.FchDoc.
        END.
        
        RUN vta2/ing-devo-utilex (ROWID(Ccbcdocu)).
        IF RETURN-VALUE = "ADM-ERROR" THEN DO:
            pMensaje = 'NO se pudo generar el movimiento de devolución el el almacén'.
            UNDO, RETURN "ADM-ERROR".
        END.
        
        {vta/graba-totales-abono.i}

        /* GENERACION DE CONTROL DE PERCEPCIONES */
        RUN vta2/control-percepcion-abonos (ROWID(Ccbcdocu)) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = 'NO se pudo generar las percepciones'.
            UNDO, RETURN 'ADM-ERROR'.
        END.
        
        /* Las N/C nacen CANCELADAS */
        ASSIGN
            Ccbcdocu.flgest = "C"
            Ccbcdocu.fchcan = TODAY
            Ccbcdocu.sdoact = 0.
        /* ************************************* */
        /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
        RUN sunat\progress-to-ppll ( INPUT ROWID(Ccbcdocu), OUTPUT pMensaje ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        /* *********************************************************** */
        
        CREATE T-CDOCU.
        BUFFER-COPY Ccbcdocu TO T-CDOCU.
        CATCH eBlockError AS PROGRESS.Lang.Error:
            IF pMensaje = '' AND eBlockError:NumMessages > 0 THEN DO:
                pMensaje = eBlockError:GetMessage(1).
                DO ix = 2 TO eBlockError:NumMessages:
                    pMensaje = pMensaje + CHR(10) + eBlockError:GetMessage(ix).
                END.
            END.
            DELETE OBJECT eBlockError.
            RETURN 'ADM-ERROR'.
        END CATCH.
    END.
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
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH UsrCjaCo NO-LOCK WHERE UsrCjaCo.CodCia = s-codcia,
          FIRST FacUsers NO-LOCK WHERE FacUsers.CodCia = s-codcia
          AND FacUsers.CodDiv = s-coddiv
          AND FacUsers.Usuario = UsrCjaCo.Usuario:
          COMBO-BOX-Usuario:ADD-LAST(UsrCjaCo.Usuario).
      END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AplicaDoc B-table-Win 
PROCEDURE proc_AplicaDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER para_CodDoc LIKE CcbCDocu.CodDoc.
    DEFINE INPUT PARAMETER para_NroDoc LIKE CcbDMov.NroDoc.
    DEFINE INPUT PARAMETER para_NroDocCja LIKE CcbDMov.NroDoc.    
    DEFINE INPUT PARAMETER para_TpoCmb LIKE CCBDMOV.TpoCmb.
    DEFINE INPUT PARAMETER para_ImpNac LIKE CcbDMov.ImpTot.
    DEFINE INPUT PARAMETER para_ImpUSA LIKE CcbDMov.ImpTot.

    /* Tipo de Documento */
    FIND FacDoc WHERE
        FacDoc.CodCia = s-CodCia AND
        FacDoc.CodDoc = para_CodDoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacDoc THEN DO:
        MESSAGE
            para_CodDoc 'NO CONFIGURADO'
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Busca Documento */
        {lib\lock-genericov21.i &Tabla="B-CDOCU" ~
            &Alcance="FIRST" ~
            &Condicion="B-CDocu.CodCia = s-codcia ~
            AND B-CDocu.CodDoc = para_CodDoc ~
            AND B-CDocu.NroDoc = para_NroDoc" ~
            &Bloqueo="NO-LOCK" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &TipoError="UNDO, RETURN 'ADM-ERROR'" }

        /* Crea Detalle de la Aplicación */
        CREATE CCBDMOV.
        ASSIGN
            CCBDMOV.CodCia = s-CodCia
            CCBDMOV.CodDiv = s-CodDiv
            CCBDMOV.NroDoc = B-CDocu.NroDoc
            CCBDMOV.CodDoc = B-CDocu.CodDoc
            CCBDMOV.CodMon = B-CDocu.CodMon
            CCBDMOV.CodRef = s-CodCja
            CCBDMOV.NroRef = para_NroDocCja
            CCBDMOV.CodCli = B-CDocu.CodCli
            CCBDMOV.FchDoc = B-CDocu.FchDoc
            CCBDMOV.HraMov = STRING(TIME,"HH:MM:SS")
            CCBDMOV.TpoCmb = para_tpocmb
            CCBDMOV.usuario = s-User-ID.
        IF B-CDocu.CodMon = 1 THEN
            ASSIGN CCBDMOV.ImpTot = para_ImpNac.
        ELSE ASSIGN CCBDMOV.ImpTot = para_ImpUSA.
    END. /* DO TRANSACTION... */
    RETURN 'OK'.

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
  {src/adm/template/snd-list.i "CcbCCaja"}
  {src/adm/template/snd-list.i "CcbDCaja"}

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

