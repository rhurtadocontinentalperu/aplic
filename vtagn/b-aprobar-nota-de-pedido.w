&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE BONIFICACION NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM NO-UNDO LIKE FacDPedi.



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

DEF SHARED VAR s-flgest AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.

&SCOPED-DEFINE Condicion ( FacCPedi.CodCia = s-CodCia ~
    AND FacCPedi.CodDiv = s-CodDiv ~
    AND FacCPedi.CodDoc = s-CodDoc ~
    AND FacCPedi.FlgEst = s-FlgEst )

DEF VAR x-articulo-ICBPer AS CHAR INIT '099268'.
DEF VAR s-TpoPed AS CHAR NO-UNDO.
DEF VAR pCodDiv AS CHAR NO-UNDO.

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
&Scoped-define INTERNAL-TABLES FacCPedi

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table FacCPedi.FchPed FacCPedi.NroPed ~
FacCPedi.CodCli FacCPedi.NomCli 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH FacCPedi WHERE ~{&KEY-PHRASE} ~
      AND {&Condicion} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table FacCPedi
&Scoped-define FIRST-TABLE-IN-QUERY-br_table FacCPedi


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
      FacCPedi SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      FacCPedi.FchPed COLUMN-LABEL "Emisión" FORMAT "99/99/9999":U
      FacCPedi.NroPed COLUMN-LABEL "Numero" FORMAT "X(12)":U WIDTH 9.72
      FacCPedi.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U WIDTH 11.43
      FacCPedi.NomCli FORMAT "x(60)":U WIDTH 45.43
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 111 BY 6.69
         FONT 4 FIT-LAST-COLUMN.


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
      TABLE: BONIFICACION T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: ITEM T "?" NO-UNDO INTEGRAL FacDPedi
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
         WIDTH              = 122.57.
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
     _TblList          = "INTEGRAL.FacCPedi"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _TblOptList       = ", FIRST"
     _Where[1]         = "{&Condicion}"
     _FldNameList[1]   > INTEGRAL.FacCPedi.FchPed
"FacCPedi.FchPed" "Emisión" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > INTEGRAL.FacCPedi.NroPed
"FacCPedi.NroPed" "Numero" ? "character" ? ? ? ? ? ? no ? no no "9.72" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > INTEGRAL.FacCPedi.CodCli
"FacCPedi.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > INTEGRAL.FacCPedi.NomCli
"FacCPedi.NomCli" ? "x(60)" "character" ? ? ? ? ? ? no ? no no "45.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
DEF VAR pMensaje AS CHAR NO-UNDO.

IF AVAILABLE Faccpedi THEN DO:
    MESSAGE 'Procedemos con la APROBACION?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN.
    CASE s-FlgEst:
        WHEN "PA" THEN DO:
            RUN Aprobar-Administrador (OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        END.
        WHEN "E" THEN DO:
            RUN Aprobar-Supervisor (OUTPUT pMensaje).
            IF RETURN-VALUE = 'ADM-ERROR' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
        END.
    END CASE.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar-Administrador B-table-Win 
PROCEDURE Aprobar-Administrador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        RETURN 'ADM-ERROR'.
    END.
    ASSIGN 
        FacCPedi.FlgEst = "E"
        FacCPedi.FchAprobacion = TODAY
        FacCPedi.UsrAprobacion = s-user-id.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Aprobar-Supervisor B-table-Win 
PROCEDURE Aprobar-Supervisor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        RETURN 'ADM-ERROR'.
    END.
    ASSIGN 
        FacCPedi.FlgEst = "C"       /* "P" */
        FacCPedi.FchAprobacion = TODAY
        FacCPedi.UsrAprobacion = s-user-id.
    RUN vtagn/gen-cot-grupos-library (INPUT ROWID(Faccpedi),
                                      OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-COT-Grupos B-table-Win 
PROCEDURE Genera-COT-Grupos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR x-CodDoc AS CHAR NO-UNDO.                         
DEF VAR x-NroDoc AS CHAR NO-UNDO.

x-CodDoc = Faccpedi.CodDoc + "*".
x-NroDoc = Faccpedi.NroPed.
                         
/* Se barren las NPC* para generar las COT */
DEF BUFFER B-CDOCU FOR Faccpedi.
DEF BUFFER B-DDOCU FOR Facdpedi.

DEF VAR s-CodDoc AS CHAR INIT "COT" NO-UNDO.
DEF VAR s-NroSer AS INTE NO-UNDO.
DEF VAR I-NITEM AS INTE NO-UNDO.

FIND FIRST FacCorre WHERE FacCorre.CodCia = s-CodCia AND
    FacCorre.CodDoc = s-CodDoc AND
    FacCorre.CodDiv = s-CodDiv AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'NO hay correlativo refido para esta división' VIEW-AS ALERT-BOX  ERROR.
    RETURN 'ADM-ERROR'.
END.
s-NroSer = FacCorre.NroSer.

DEF VAR s-DiasVtoCot AS INTE NO-UNDO.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = pCodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' pCodDiv 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
ASSIGN
    s-DiasVtoCot = GN-DIVI.DiasVtoCot.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}
    FOR EACH B-CDOCU NO-LOCK WHERE B-CDOCU.codcia = s-codcia 
        AND B-CDOCU.CodDiv = s-CodDiv
        AND B-CDOCU.CodDoc = x-CodDoc
        AND B-CDOCU.NroPed BEGINS x-NroDoc:
        ASSIGN
            pCodDiv = B-CDOCU.Libre_c01
            s-TpoPed = B-CDOCU.TpoPed.
        /* ********************************************************************************************* */
        /* Cargamos Detalle */
        /* ********************************************************************************************* */
        EMPTY TEMP-TABLE ITEM.
        FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
            CREATE ITEM.
            BUFFER-COPY B-DDOCU TO ITEM.
        END.
        /* ********************************************************************************************* */
        /* Creamos Cabecera */
        /* ********************************************************************************************* */
        CREATE Faccpedi.
        BUFFER-COPY B-CDOCU EXCEPT B-CDOCU.Libre_c02        /* NO los grupos */
            TO Faccpedi
            ASSIGN
                FacCPedi.CodDoc = s-coddoc 
                FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            NO-ERROR.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            {lib/mensaje-de-error.i &MensajeError="pMensaje"}
            UNDO, RETURN 'ADM-ERROR'.
        END.
        ASSIGN 
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
        ASSIGN 
            FacCPedi.FchPed = TODAY 
            FacCPedi.FchVen = TODAY + s-DiasVtoCot
            FacCPedi.Hora   = STRING(TIME,"HH:MM:SS")
            FacCPedi.FlgEst = (IF FacCPedi.CodCli BEGINS "SYS" THEN "I" ELSE "P")     /* APROBADO */
            FacCPedi.Lista_de_Precios = FacCPedi.Libre_c01      /* OJO */
            NO-ERROR.
        /* DATOS SUPERMERCADOS */
/*         CASE Faccpedi.TpoPed:                                                  */
/*             WHEN "S" THEN DO:                                                  */
/*                 IF s-Import-Ibc = YES THEN FacCPedi.Libre_C05 = "1".           */
/*                 IF s-Import-B2B = YES THEN FacCPedi.Libre_C05 = "3".  /* OJO*/ */
/*             END.                                                               */
/*         END CASE.                                                              */
/*         /*  */                                                                 */
/*         IF lOrdenGrabada > '' THEN DO:                                         */
/*             DISABLE TRIGGERS FOR LOAD OF factabla.                             */
/*             FIND FIRST factabla WHERE factabla.codcia = s-codcia AND           */
/*                 factabla.tabla = 'OC PLAZA VEA' AND                            */
/*                 factabla.codigo = lOrdenGrabada EXCLUSIVE NO-ERROR.            */
/*             IF NOT AVAILABLE factabla THEN DO:                                 */
/*                 CREATE factabla.                                               */
/*                 ASSIGN                                                         */
/*                     factabla.codcia = s-codcia                                 */
/*                     factabla.tabla = 'OC PLAZA VEA'                            */
/*                     factabla.codigo = lOrdenGrabada                            */
/*                     factabla.campo-c[2] = STRING(NOW,"99/99/9999 HH:MM:SS").   */
/*             END.                                                               */
/*         END.                                                                   */
        /* RHC 05/10/17 En caso de COPIAR una cotizacion hay que "limpiar" estos campos */
        ASSIGN
            Faccpedi.Libre_c02 = ""       /* "PROCESADO" por Abastecimientos */
            Faccpedi.LugEnt2   = ""
            .
        /* Control si el Cliente Recoge */
        IF FacCPedi.Cliente_Recoge = NO THEN FacCPedi.CodAlm = ''.
        /* ********************************************************************************************* */
        /* Ic - 03Oct2019, bolsas plasticas, adicionar el registro de IMPUESTO (ICBPER) */
        /* ********************************************************************************************* */
        RUN impuesto-icbper. 
        /* ********************************************************************************************* */
        /* ******************************************** */
        /* RHC 19/050/2021 Datos para HOMOLOGAR las COT */
        /* ******************************************** */
        ASSIGN
            FacCPedi.CustomerPurchaseOrder = Faccpedi.OrdCmp.
        /* ******************************************** */
        /* ******************************************** */
        I-NITEM = 0.
        FOR EACH ITEM,
            FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = ITEM.codmat
            BY ITEM.NroItm:
            I-NITEM = I-NITEM + 1.
            CREATE FacDPedi.
            BUFFER-COPY ITEM 
                TO FacDPedi
                ASSIGN
                    FacDPedi.CodCia = FacCPedi.CodCia
                    FacDPedi.CodDiv = FacCPedi.CodDiv
                    FacDPedi.coddoc = FacCPedi.coddoc
                    FacDPedi.NroPed = FacCPedi.NroPed
                    FacDPedi.FchPed = FacCPedi.FchPed
                    FacDPedi.Hora   = FacCPedi.Hora 
                    FacDPedi.FlgEst = FacCPedi.FlgEst
                    FacDPedi.NroItm = I-NITEM.
        END.
        /* ****************************************************************************************** */
        /* RHC 02/01/2020 Promociones proyectadas */
        /* ****************************************************************************************** */
        EMPTY TEMP-TABLE ITEM.
        FOR EACH Facdpedi OF Faccpedi NO-LOCK:
            CREATE ITEM.
            BUFFER-COPY Facdpedi TO ITEM.
        END.
        RUN vtagn/p-promocion-general.r (INPUT Faccpedi.CodDiv,
                                         INPUT Faccpedi.CodDoc,
                                         INPUT Faccpedi.NroPed,
                                         INPUT TABLE ITEM,
                                         OUTPUT TABLE BONIFICACION,
                                         OUTPUT pMensaje).
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
        I-NITEM = 0.
        FOR EACH BONIFICACION,
            FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND 
            Almmmatg.codmat = BONIFICACION.codmat
            BY BONIFICACION.NroItm:
            I-NITEM = I-NITEM + 1.
            CREATE FacDPedi.
            BUFFER-COPY BONIFICACION
                TO FacDPedi
                ASSIGN
                    FacDPedi.CodCia = FacCPedi.CodCia
                    FacDPedi.CodDiv = FacCPedi.CodDiv
                    FacDPedi.coddoc = "CBO"   /* Bonificacion en COT */
                    FacDPedi.NroPed = FacCPedi.NroPed
                    FacDPedi.FchPed = FacCPedi.FchPed
                    FacDPedi.Hora   = FacCPedi.Hora 
                    FacDPedi.FlgEst = FacCPedi.FlgEst
                    FacDPedi.NroItm = I-NITEM.
        END.
        /* ****************************************************************************************** */
        /* ****************************************************************************************** */
        {vtagn/totales-cotizacion-unificada.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
        /* ****************************************************************************************** */
        IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
        IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
        IF AVAILABLE(gn-clie)  THEN RELEASE Gn-Clie.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE impuesto-icbper B-table-Win 
PROCEDURE impuesto-icbper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Ic - 03Oct2019, bolsas plasticas, adicionar el registro de IMPUESTO (ICBPER) */
  DEFINE VAR x-ultimo-item AS INT.
  DEFINE VAR x-cant-bolsas AS INT.
  DEFINE VAR x-precio-ICBPER AS DEC.
  DEFINE VAR x-alm-des AS CHAR INIT "".

  x-ultimo-item = -1.
  x-cant-bolsas = 0.
  x-precio-ICBPER = 0.0.

  /* Sacar el importe de bolsas plasticas */
  DEFINE VAR z-hProc AS HANDLE NO-UNDO.               /* Handle Libreria */
  
  RUN ccb\libreria-ccb.p PERSISTENT SET z-hProc.
  /* Procedimientos */
  RUN precio-impsto-bolsas-plastica IN z-hProc (INPUT TODAY, OUTPUT x-precio-ICBPER).
  DELETE PROCEDURE z-hProc.                   /* Release Libreria */

  FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK BY ITEM.NroItm DESC:
      IF Almmmatg.CodFam = '086' AND Almmmatg.SubFam = '001' THEN DO:
          x-cant-bolsas = x-cant-bolsas + (ITEM.canped * ITEM.factor).
          x-alm-des = ITEM.almdes.
      END.
  END.

  x-ultimo-item = 0.
  FOR EACH ITEM WHERE item.codmat = x-articulo-ICBPER :
      DELETE ITEM.
  END.

  FOR EACH ITEM BY ITEM.NroItm:
      x-ultimo-item = x-ultimo-item + 1.
      ASSIGN ITEM.implinweb = x-ultimo-item.
  END.
  FOR EACH ITEM :
      x-ultimo-item = x-ultimo-item + 1.
      ASSIGN ITEM.NroItm = ITEM.implinweb
            ITEM.implinweb = 0.
  END.

  IF x-cant-bolsas > 0 THEN DO:

      FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                almmmatg.codmat = x-articulo-ICBPER NO-LOCK NO-ERROR.

        x-ultimo-item = x-ultimo-item + 1.

        CREATE ITEM.
        ASSIGN
          ITEM.CodCia = Faccpedi.CodCia
          ITEM.CodDiv = Faccpedi.CodDiv
          ITEM.coddoc = Faccpedi.coddoc
          ITEM.NroPed = Faccpedi.NroPed
          ITEM.FchPed = Faccpedi.FchPed
          ITEM.Hora   = Faccpedi.Hora 
          ITEM.FlgEst = Faccpedi.FlgEst
          ITEM.NroItm = x-ultimo-item
          ITEM.CanPick = 0.   /* OJO */

      ASSIGN 
          ITEM.codmat = x-articulo-ICBPER
          ITEM.UndVta = IF (AVAILABLE almmmatg) THEN Almmmatg.UndA ELSE 'UNI'
          ITEM.almdes = x-alm-des
          ITEM.Factor = 1
          ITEM.PorDto = 0
          ITEM.PreBas = x-precio-ICBPER
          ITEM.AftIgv = IF (AVAILABLE almmmatg) THEN Almmmatg.AftIgv ELSE NO
          ITEM.AftIsc = NO
          ITEM.Libre_c04 = "".
      ASSIGN 
          ITEM.CanPed = x-cant-bolsas
          ITEM.PreUni = x-precio-ICBPER
          ITEM.Por_Dsctos[1] = 0.00
          ITEM.Por_Dsctos[2] = 0.00
          ITEM.Por_Dsctos[3] = 0.00
          ITEM.Libre_d02     = 0.
      ASSIGN
          ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                        ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                        ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
      IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
          THEN ITEM.ImpDto = 0.
          ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
      /* ***************************************************************** */
    
      ASSIGN
          ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
          ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
      IF ITEM.AftIsc 
        THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
      ELSE ITEM.ImpIsc = 0.
        IF ITEM.AftIgv 
      THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (Faccpedi.PorIgv / 100) ), 4 ).
        ELSE ITEM.ImpIgv = 0.
  END.

  /* Ic - 03Oct2019, bolsas plasticas */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Rechazar B-table-Win 
PROCEDURE Rechazar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF AVAILABLE Faccpedi THEN DO:
    MESSAGE 'Procedemos con RECHAZAR?' VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO UPDATE rpta AS LOG.
    IF rpta = NO THEN RETURN.
    FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN RETURN.
    CASE s-FlgEst:
        WHEN "PA" THEN ASSIGN FacCPedi.FlgEst = "PV".
        WHEN "E" THEN ASSIGN FacCPedi.FlgEst = "PA".
    END CASE.
    ASSIGN
        FacCPedi.FchAprobacion = TODAY
        FacCPedi.UsrAprobacion = s-user-id.
    FIND CURRENT Faccpedi NO-LOCK.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query':U).

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
  {src/adm/template/snd-list.i "FacCPedi"}

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

