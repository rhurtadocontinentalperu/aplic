&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE DETA LIKE ImDFacCom.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

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
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-NROSER   AS INTEGER.
DEFINE SHARED VARIABLE S-NROFAC   AS INTEGER.
DEFINE SHARED VARIABLE S-IMPFLE   AS DECIMAL.

/*DEFINE SHARED TEMP-TABLE DETA LIKE ImDFacCom.*/
DEFINE SHARED TEMP-TABLE DCMP LIKE ImDOCmP.

DEF BUFFER B-CFAC FOR ImCFacCom.
DEF BUFFER B-DFAC FOR ImDFacCom.
DEF BUFFER B-CCFAC FOR ImCFacCom.
DEF BUFFER B-COCMP FOR ImCOcmp.
                    
DEFINE VARIABLE I              AS INTEGER   NO-UNDO.
DEFINE VARIABLE Im-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE C-NRODOC       AS CHAR      NO-UNDO.
DEFINE VARIABLE C-CODDOC       AS CHAR      NO-UNDO.
DEFINE VARIABLE C-NROPED       AS CHAR      NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NROFAC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE S-PROVEE       AS CHARACTER NO-UNDO. 
DEFINE VARIABLE I-CODMON       AS INTEGER   NO-UNDO. 
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 
DEFINE VARIABLE D-FCHVTO       AS DATE      NO-UNDO.
DEFINE VARIABLE NroImp         LIKE ImDOcmp.NroImp .
DEFINE VARIABLE p-NroRef       LIKE ImCOcmp.NroPed. 

/*FIND FIRST ImCFacCom WHERE ImCFacCom.CodCia = S-CODCIA AND
 *      ImCFacCom.CodDiv = S-CODDIV AND
 *      ImCFacCom.NroFac = S-NROFAC NO-LOCK NO-ERROR.
 * IF AVAILABLE FacCorre THEN 
 *    ASSIGN I-NROFAC = ImCFacCom.NROFAC.*/

/*FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.*/

DEFINE TEMP-TABLE T-CPEDM LIKE FacCPedi
   FIELD CodRef LIKE CcbCDocu.CodRef.

DEFINE TEMP-TABLE T-DPEDM LIKE FacDPedi.

DEFINE VARIABLE RPTA        AS CHARACTER NO-UNDO.

DEFINE VARIABLE x-cto1 AS DECI INIT 0.
DEFINE VARIABLE x-cto2 AS DECI INIT 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ImCFacCom
&Scoped-define FIRST-EXTERNAL-TABLE ImCFacCom


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ImCFacCom.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ImCFacCom.FchCom ImCFacCom.NroPed ~
ImCFacCom.NroCom ImCFacCom.NroBl ImCFacCom.CodPro ImCFacCom.ImpFob ~
ImCFacCom.Codmon ImCFacCom.ImpFlete ImCFacCom.CndCmp ImCFacCom.TEmbj ~
ImCFacCom.VpEmbq ImCFacCom.VpTrans ImCFacCom.PrtEmbq ImCFacCom.PrtTrans ~
ImCFacCom.PrtLlega ImCFacCom.PrtLlegaT ImCFacCom.FchEmbq ImCFacCom.FchEmbqT ~
ImCFacCom.FchLlega ImCFacCom.FchLlegaT 
&Scoped-define ENABLED-TABLES ImCFacCom
&Scoped-define FIRST-ENABLED-TABLE ImCFacCom
&Scoped-Define ENABLED-OBJECTS RECT-24 x-seguro 
&Scoped-Define DISPLAYED-FIELDS ImCFacCom.NroFac ImCFacCom.FchCom ~
ImCFacCom.NroPed ImCFacCom.NroCon ImCFacCom.FchDoc ImCFacCom.NroCom ~
ImCFacCom.Userid-fac ImCFacCom.NroBl ImCFacCom.Hora ImCFacCom.CodPro ~
ImCFacCom.ImpFob ImCFacCom.Codmon ImCFacCom.ImpFlete ImCFacCom.CndCmp ~
ImCFacCom.TEmbj ImCFacCom.ImpCfr ImCFacCom.VpEmbq ImCFacCom.VpTrans ~
ImCFacCom.PrtEmbq ImCFacCom.PrtTrans ImCFacCom.PrtLlega ImCFacCom.PrtLlegaT ~
ImCFacCom.FchEmbq ImCFacCom.FchEmbqT ImCFacCom.FchLlega ImCFacCom.FchLlegaT 
&Scoped-define DISPLAYED-TABLES ImCFacCom
&Scoped-define FIRST-DISPLAYED-TABLE ImCFacCom
&Scoped-Define DISPLAYED-OBJECTS x-estado x-prov x-conpago x-seguro 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE x-conpago AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .81 NO-UNDO.

DEFINE VARIABLE x-estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 23 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 6 NO-UNDO.

DEFINE VARIABLE x-prov AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .81 NO-UNDO.

DEFINE VARIABLE x-seguro AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Seguro" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .81.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 104 BY 10.77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     ImCFacCom.NroFac AT ROW 1.19 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
          FONT 1
     x-estado AT ROW 1.19 COL 29.29 COLON-ALIGNED NO-LABEL
     ImCFacCom.FchCom AT ROW 1.19 COL 73 COLON-ALIGNED
          LABEL "Fecha Comercial Invoice"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCFacCom.NroPed AT ROW 1.96 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .81
     ImCFacCom.NroCon AT ROW 1.96 COL 38 COLON-ALIGNED NO-LABEL FORMAT "999"
          VIEW-AS FILL-IN 
          SIZE 6 BY .81
     ImCFacCom.FchDoc AT ROW 1.96 COL 73 COLON-ALIGNED
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCFacCom.NroCom AT ROW 2.73 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .81
     ImCFacCom.Userid-fac AT ROW 2.73 COL 73 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCFacCom.NroBl AT ROW 3.5 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     ImCFacCom.Hora AT ROW 3.5 COL 73 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCFacCom.CodPro AT ROW 4.27 COL 16 COLON-ALIGNED
          LABEL "Proveedor"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     x-prov AT ROW 4.27 COL 31 COLON-ALIGNED NO-LABEL
     ImCFacCom.ImpFob AT ROW 4.46 COL 73 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     ImCFacCom.Codmon AT ROW 5.04 COL 18 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 15 BY .96
     ImCFacCom.ImpFlete AT ROW 5.23 COL 73 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     ImCFacCom.CndCmp AT ROW 6 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.29 BY .81
     x-conpago AT ROW 6 COL 21 COLON-ALIGNED NO-LABEL
     x-seguro AT ROW 6 COL 73 COLON-ALIGNED
     ImCFacCom.TEmbj AT ROW 6.77 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 35 BY .81
     ImCFacCom.ImpCfr AT ROW 6.77 COL 73 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     ImCFacCom.VpEmbq AT ROW 7.54 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29 BY .81
     ImCFacCom.VpTrans AT ROW 7.54 COL 73 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29 BY .81
     ImCFacCom.PrtEmbq AT ROW 8.31 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29 BY .81
     ImCFacCom.PrtTrans AT ROW 8.31 COL 73 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29 BY .81
     ImCFacCom.PrtLlega AT ROW 9.08 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29 BY .81
     ImCFacCom.PrtLlegaT AT ROW 9.08 COL 73 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29 BY .81
     ImCFacCom.FchEmbq AT ROW 9.85 COL 16 COLON-ALIGNED
          LABEL "Fecha E"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCFacCom.FchEmbqT AT ROW 9.85 COL 73 COLON-ALIGNED
          LABEL "Fecha Embarque"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCFacCom.FchLlega AT ROW 10.62 COL 16 COLON-ALIGNED
          LABEL "Fecha Llegada"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     ImCFacCom.FchLlegaT AT ROW 10.62 COL 73 COLON-ALIGNED
          LABEL "Fecha Llegada"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 5.23 COL 11
     "-" VIEW-AS TEXT
          SIZE 1 BY .5 AT ROW 2.15 COL 39
     RECT-24 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.ImCFacCom
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: DETA T "SHARED" ? INTEGRAL ImDFacCom
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 10.88
         WIDTH              = 104.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN ImCFacCom.CodPro IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ImCFacCom.FchCom IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ImCFacCom.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN ImCFacCom.FchEmbq IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ImCFacCom.FchEmbqT IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ImCFacCom.FchLlega IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ImCFacCom.FchLlegaT IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ImCFacCom.Hora IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCFacCom.ImpCfr IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCFacCom.NroCon IN FRAME F-Main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN ImCFacCom.NroFac IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCFacCom.Userid-fac IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-conpago IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-prov IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       x-seguro:HIDDEN IN FRAME F-Main           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME ImCFacCom.CndCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCFacCom.CndCmp V-table-Win
ON LEAVE OF ImCFacCom.CndCmp IN FRAME F-Main /* Forma de Pago */
DO:
  FIND FIRST Gn-ConCp WHERE ROWID(Gn-ConCp) = output-var-1
    NO-LOCK NO-ERROR.
  IF AVAILABLE Gn-ConCp THEN DO:
     DISPLAY Gn-ConCp.Nombr @ x-conpago WITH FRAME {&FRAME-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCFacCom.ImpFlete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCFacCom.ImpFlete V-table-Win
ON LEAVE OF ImCFacCom.ImpFlete IN FRAME F-Main /* Flete */
DO:
  RUN Calculando-Incoterm.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ImCFacCom.ImpFob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ImCFacCom.ImpFob V-table-Win
ON LEAVE OF ImCFacCom.ImpFob IN FRAME F-Main /* FOB */
DO:
  
   RUN Calculando-Incoterm.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-seguro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-seguro V-table-Win
ON LEAVE OF x-seguro IN FRAME F-Main /* Seguro */
DO:
  ASSIGN x-Seguro = DECIMAL(x-Seguro:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
  RUN Calculando-Incoterm.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

ON RETURN OF ImCFacCom.NroCom, ImCFacCom.NroBl, ImCFacCom.CodPro, ImCFacCom.Codmon,
ImCFacCom.CndCmp, ImCFacCom.TEmbj, ImCFacCom.VpEmbq, ImCFacCom.PrtEmbq, ImCFacCom.PrtLlega,
ImCFacCom.FchEmbq, ImCFacCom.FchLlega, ImCFacCom.FchCom, ImCFacCom.ImpFob, ImCFacCom.ImpFlete,
ImCFacCom.ImpCfr, ImCFacCom.VpTrans, ImCFacCom.PrtTrans, ImCFacCom.PrtLlegaT, ImCFacCom.FchEmbqT,
ImCFacCom.FchLlegaT
DO:
    APPLY "TAB":U.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-OC V-table-Win 
PROCEDURE Actualiza-OC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR SumandoT AS DECIMAL INIT 0.
  DEFINE VAR BAN      AS INTEGER INIT 0 NO-UNDO .
    
  FOR EACH B-CFAC NO-LOCK WHERE B-CFAC.CODCIA = S-CODCIA
     AND B-CFAC.NroPed = ImCFacCom.NroPed,
     EACH B-DFAC OF B-CFAC NO-LOCK 
        BREAK BY B-CFAC.NroPed BY B-DFAC.CodMat:
        ACCUMULATE B-DFAC.CanAten(SUB-TOTAL BY B-DFAC.CodMat).
            FIND FIRST ImCoCmp WHERE ImCoCmp.CodCia = s-CodCia
            AND ImCoCmp.NroPed = ImCFacCom.NroPed
            NO-LOCK NO-ERROR.
                IF AVAILABLE ImCoCmp THEN DO:
                    FOR EACH ImDoCmp OF ImCoCmp WHERE ImDoCmp.CodMat = B-DFAC.CodMat:
                        SumandoT = ACCUM SUB-TOTAL by B-DFAC.codmat B-DFAC.canaten. 
                           ASSIGN ImDOCmp.CanAten = SumandoT.    
                    END.
                END.
  END.
  RELEASE ImCoCmp.
  RELEASE ImDoCmp.
  
  /*Bloqueando Orden de Compra*/ 
  FIND FIRST B-COCMP WHERE B-COCMP.CodCia = s-CodCia
       AND B-COCMP.NroPed = p-NroRef
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE B-COCMP THEN DO:
       FOR EACH ImDOcmp OF B-COCMP WHERE 
           ImDOCmp.CanPed <> ImDOCmp.CanAten BREAK BY ImDOcmp.CodMat:
           BAN = BAN + 1.
       END. 
       IF BAN = 0 THEN DO:
            ASSIGN B-COCMP.FlgSit = 'B'.
       END.
       ELSE ASSIGN B-COCMP.FlgSit = 'E'.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualizando2 V-table-Win 
PROCEDURE Actualizando2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
  DEFINE VAR BAN AS INTEGER. 
  
  FOR EACH B-DFAC OF ImCFacCom BREAK BY B-DFAC.CodMat:
      FIND FIRST ImCoCmp WHERE ImCoCmp.CodCia = s-CodCia
       AND ImCoCmp.NroPed = ImCFacCom.NroPed
       NO-LOCK NO-ERROR.
        IF AVAILABLE ImCoCmp THEN DO:
          FOR EACH ImDoCmp OF ImCoCmp WHERE ImDoCmp.CodMat = B-DFAC.CodMat:
             ASSIGN ImDOCmp.CanAten = ImDOCmp.CanAten - B-DFAC.CanAten.    
          END.
        END.
  END.
  RELEASE ImCoCmp.
  RELEASE ImDoCmp.
  
  /*Bloqueando Orden de Compra*/ 

  FIND FIRST B-COCMP WHERE B-COCMP.CodCia = ImCFacCom.CodCia
       AND B-COCMP.NroPed = ImCFacCom.NroPed
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE B-COCMP THEN DO:
       FOR EACH ImDOcmp OF B-COCMP WHERE 
           ImDOCmp.CanPed <> ImDOCmp.CanAten BREAK BY ImDOcmp.CodMat:
           BAN = BAN + 1.
       END. 
       IF BAN = 0 THEN DO:
            ASSIGN B-COCMP.FlgSit = 'B'.
       END.
       ELSE ASSIGN B-COCMP.FlgSit = 'E'.
  END.  
  RELEASE B-DFAC.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "ImCFacCom"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ImCFacCom"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Detalle V-table-Win 
PROCEDURE Borra-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   FOR EACH ImDFacCom OF ImCFacCom EXCLUSIVE-LOCK 
        ON ERROR UNDO, RETURN 'ADM-ERROR'
        ON STOP UNDO, RETURN 'ADM-ERROR':
    DELETE ImDFacCom.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Temporal V-table-Win 
PROCEDURE Borra-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH DETA:
   DELETE DETA.
  END.
  
  FOR EACH DCMP:
   DELETE DCMP.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculando-Incoterm V-table-Win 
PROCEDURE Calculando-Incoterm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR Valor0 AS DECIMAL.
 DO WITH FRAME {&FRAME-NAME}: 
  FIND FIRST ImCOcmp WHERE ImCOcmp.CodCia = s-CodCia
       AND ImCOcmp.NroImp = NroImp
       NO-LOCK NO-ERROR.

  IF AVAILABLE ImCOcmp THEN DO:
     CASE ImCOCmp.FlgEst[1]:
        WHEN 'CFR' THEN
           DO:
             Valor0 = INTEGER(ImCFacCom.ImpFlete:SCREEN-VALUE) + INTEGER(ImCFacCom.ImpFob:SCREEN-VALUE).  
           END.
        WHEN 'FOB' THEN
           DO:
             Valor0 = INTEGER(ImCFacCom.ImpFob:SCREEN-VALUE).
           END.
        WHEN 'CIF' THEN
           DO:
             Valor0 = INTEGER(ImCFacCom.ImpFlete:SCREEN-VALUE) + INTEGER(ImCFacCom.ImpFob:SCREEN-VALUE) + INTEGER(x-seguro:SCREEN-VALUE).
           END.      
     END CASE.
  END.
  DISPLAY Valor0 @ INTEGRAL.ImCFacCom.ImpCfr.
 END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN Borra-Temporal.
  
  FOR EACH ImDOcmp WHERE ImDOcmp.CodCia = s-CodCia
    AND  ImDOcmp.NroImp = NroImp 
    AND  ImDOcmp.CanPed > ImDOcmp.CanAten NO-LOCK:
     CREATE DCMP.
     BUFFER-COPY ImDOcmp TO DCMP.
  END.
  FOR EACH DCMP:
      CREATE DETA.
        ASSIGN 
          DETA.NroFac  = INTEGER(ImCFacCom.NroFac:SCREEN-VALUE IN FRAME {&FRAME-NAME})
          DETA.CodCia  = DCMP.CodCia
          DETA.CodDoc  = 'FAC'
          DETA.CodMat  = DCMP.CodMat
          DETA.UndCmp  = DCMP.UndCmp
          DETA.CanAten = DCMP.CanPed - DCMP.CanAten
          DETA.PreUni  = DCMP.PreUni
          DETA.ImpTot  = DETA.CanAten * DETA.PreUni.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Contador V-table-Win 
PROCEDURE Contador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE Conta AS INTEGER INIT 1.
  FOR EACH B-CFAC NO-LOCK WHERE B-CFAC.NROPED = p-NroRef:
     Conta = Conta + 1.
  END.
  ASSIGN 
     ImCFacCom.NroCon = Conta.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Detalle V-table-Win 
PROCEDURE Graba-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
  DEFINE VAR ImpTot AS DECIMAL NO-UNDO INIT 0.
  
  FOR EACH DETA:
      CREATE ImDFacCom.
         ImpTot = ImpTot + DETA.ImpTot.
       ASSIGN 
           ImDFacCom.CodCia  =  ImCFacCom.CodCia
           ImDFacCom.CodDoc  =  DETA.CodDoc
           ImDFacCom.NroFac  =  ImCFacCom.NroFac
           ImDFacCom.NroCon  =  ImCFacCom.NroCon
           ImDFacCom.CodPro  =  ImCFacCom.CodPro
           ImDFacCom.codmat  =  DETA.CodMat 
           ImDFacCom.UndCmp  =  DETA.UndCmp
           ImDFacCom.PreUni  =  DETA.PreUni
           ImDFacCom.CanAten =  DETA.CanAten 
           ImDFacCom.ImpTot = DETA.ImpTot. 

  END. 
  FOR EACH B-CFAC WHERE B-CFAC.NroFac = ImCFacCom.NroFac:
      ASSIGN B-CFAC.IMPTOT = IMPTOT.
  END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Habilitar-Campos V-table-Win 
PROCEDURE Habilitar-Campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
     x-seguro:HIDDEN = TRUE.
     x-seguro:SENSITIVE = FALSE.
     ImCFacCom.ImpCfr:HIDDEN = FALSE. 
     ImCFacCom.ImpFlete:HIDDEN = FALSE. 
     ImCFacCom.ImpFob:HIDDEN = FALSE.
    /* ImCFacCom.ImpCfr:SENSITIVE = TRUE. 
 *      ImCFacCom.ImpFlete:SENSITIVE = TRUE. 
 *      ImCFacCom.ImpFob:SENSITIVE = .*/
     
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
   /*{adm/i-DocPssw.i s-CodCia s-CodDoc ""ADD""}*/
    
   RUN IMP\d-orppen (OUTPUT p-NroRef).
   IF (p-NroRef = 'ADM-ERROR') OR (p-NroRef = '') THEN RETURN 'ADM-ERROR'.
  
  /*VA EN EL ASSIGN*/
  FIND LG-CORR WHERE 
        LG-CORR.codcia = s-codcia AND 
        LG-CORR.coddiv = s-coddiv AND 
        LG-CORR.coddoc = "FAC"
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE LG-CORR THEN DO:
        MESSAGE 'Correlativo No Disponible'
        VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
   END.
   
  RUN Habilitar-Campos. 
   
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DEFINE VAR Prov AS CHARACTER NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
     FIND FIRST ImCOcmp WHERE ImCOcmp.NroPed = p-NroRef
           NO-LOCK NO-ERROR.
     IF AVAILABLE ImCOcmp THEN DO WITH FRAME {&FRAME-NAME}:
       NroImp = ImCOcmp.NroImp.
       
       /*Proveedores*/
       FIND FIRST GN-PROV WHERE gn-prov.CodPro = ImCOcmp.CodPro
          NO-LOCK NO-ERROR.
       IF AVAILABLE ImCOcmp THEN DO:
          Prov = INTEGRAL.gn-prov.NomPro.
       END.
       /*Dato Incoterm*/
       Case ImCOCmp.FlgEst[1]:
            When 'FOB' THEN
                  DO: 
                    x-seguro:HIDDEN = TRUE.
                    ImCFacCom.ImpCfr:HIDDEN = FALSE.
                    ImCFacCom.ImpFlete:HIDDEN = TRUE.
                  END.
            When 'CIF' THEN
                  DO:
                    x-seguro:HIDDEN = FALSE.
                    x-seguro:SENSITIVE = TRUE.
                    ImCFacCom.ImpCfr:LABEL = 'CIF'.
                  END.
       End Case.
       RUN Carga-Temporal.
       DISPLAY 
         (Lg-Corr.NroDoc) @ ImCFacCom.NroFac
         ImCOcmp.NroPed @ ImCFacCom.NroPed
         TODAY @ INTEGRAL.ImCFacCom.FchDoc
         s-user-id @ ImCFacCom.Userid-fac
         STRING(TIME,"HH:MM") @ ImCFacCom.Hora
         ImCOCmp.CodPro @ ImCFacCom.CodPro
         Prov @ x-prov.
     END.
  END.
  RUN Procesa-handle IN lh_handle ('Pagina2').  

 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
   /*Correlativo*/
   FIND LG-CORR WHERE 
        LG-CORR.codcia = s-codcia AND 
        LG-CORR.coddiv = s-coddiv AND 
        LG-CORR.coddoc = "FAC"
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE LG-CORR THEN DO:
        MESSAGE 'Correlativo No Disponible'
        VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.

    RUN Validando-Incoterm.
     ImCFacCom.ImpCfr:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
   DEFINE VAR CONTADOR AS INT INIT 1.  
  
 DO TRANSACTION ON STOP UNDO, RETURN 'ADM-ERROR'
                ON ERROR UNDO, RETURN 'ADM-ERROR':
   RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO WITH FRAME {&FRAME-NAME}:  
       FOR EACH B-CFAC WHERE B-CFAC.NroPed = p-nroref /*ImCFacCom.NroPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}*/
         BREAK BY B-CFAC.NroPed:
         CONTADOR = CONTADOR + 1.
       END.
       RUN Calculando-Incoterm.
      /* RUN Contador. */       
       DO WITH FRAME {&FRAME-NAME}:
          ASSIGN
            ImCFacCom.CodCia = s-CodCia
            ImCFacCom.CodDiv = s-CodDiv
            ImCFacCom.CodDoc = 'FAC'
            ImCFacCom.NroPed = ImCFacCom.NroPed:SCREEN-VALUE 
            ImCFacCom.NroCon = Contador
            ImCFacCom.NroFac = LG-CORR.NroDoc 
            LG-CORR.NroDoc   = LG-CORR.NroDoc + 1
            ImCFacCom.CodPro = ImCFacCom.CodPro:SCREEN-VALUE 
            ImCFacCom.FchDoc = TODAY
            ImCFacCom.Codmon = INTEGER(ImCFacCom.Codmon:SCREEN-VALUE)
            ImCFacCom.Hora   = STRING(TIME,'HH:MM')
            ImCFacCom.Userid-fac = S-USER-ID
            ImCFacCom.ImpCfr = INTEGER(ImCFacCom.ImpCfr:SCREEN-VALUE)
            ImCFacCom.FlgEst = 'E'      /* Emitido */ .
       
       END.
    END.
    ELSE RUN Borra-Detalle.
   RUN Graba-Detalle.    
   IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
   RUN Actualiza-OC.
   IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
 END.   
   ImCFacCom.ImpCfr:SENSITIVE = FALSE.
   RELEASE Lg-Corr.
   RELEASE ImDFacCom.   
   RUN Procesa-handle IN lh_handle ('Pagina1').  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    
  RUN Procesa-Handle IN lh_Handle ('Pagina1').
/*  RUN Procesa-Handle IN lh_Handle ('Browse').*/
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF ImCFacCom.FlgEst <> 'E' THEN RETURN 'ADM-ERROR'.
  
  /*Validando si tiene Duas vinculadas.*/
  
  FIND FIRST ImCDua WHERE ImCDua.CodCia = ImcFacCom.CodCia
       AND ImCDua.NroFac = ImcFacCom.NroFac
       AND ImCDua.FlgEst = 'E'
       NO-LOCK NO-ERROR.
  IF AVAILABLE ImCDua THEN DO:
     MESSAGE "No puede eliminar la Factura" SKIP
             "tiene DUAS pendientes" VIEW-AS ALERT-BOX ERROR.
     RETURN 'ADM-ERROR'.  
  END.
  
  /* Dispatch standard ADM method.                             */
 /*  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */
  
  FIND FIRST B-CFAC WHERE B-CFAC.CodCia = ImCFacCom.CodCia
       AND B-CFAC.NroFac = ImCFacCom.NroFac
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE B-CFAC THEN DO:
     B-CFAC.FlgEst = 'A'.
  END.
  RUN Actualizando2.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
  RUN Borra-Detalle.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
   
  
  /* RUN Procesa-Handle IN lh_Handle ('Browse'). */
/*   RUN adm-open-query. */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-handle IN lh_handle ('Pagina1').  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
   
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DEFINE VAR Seguro AS DECIMAL.
   
  IF AVAILABLE ImCFacCom THEN DO WITH FRAME {&FRAME-NAME}:
    CASE ImCFacCom.FlgEst:
        WHEN "A" THEN x-Estado:SCREEN-VALUE = "  A N U L A D O  ".
        WHEN "C" THEN x-Estado:SCREEN-VALUE = "  C E R R A D A  ".
        WHEN "E" THEN x-Estado:SCREEN-VALUE = "  E M I T I D A  ".
        OTHERWISE x-Estado:SCREEN-VALUE = "???".
    END CASE.
    x-seguro:SENSITIVE = FALSE.
    FIND FIRST ImCOcmp WHERE ImCOcmp.CodCia = ImCFacCom.CodCia
        AND ImCOcmp.NroPed    = ImCFacCom.NroPed:SCREEN-VALUE
        AND ImCOCmp.FlgEst[1] = 'CIF'
        NO-LOCK NO-ERROR.
     IF AVAILABLE ImCOcmp THEN DO:
        x-seguro:HIDDEN = FALSE.
        Seguro = DECIMAL(ImCFacCom.ImpCfr:SCREEN-VALUE) -
                          (DECIMAL(ImCFacCom.ImpFlete:SCREEN-VALUE) +
                           DECIMAL(ImCFacCom.ImpFob:SCREEN-VALUE)).
        DISPLAY Seguro @ x-seguro WITH FRAME {&FRAME-NAME}.
     END.
     ELSE x-seguro:HIDDEN = TRUE.
    
    FIND FIRST Gn-Prov WHERE Gn-Prov.CodPro = ImCFacCom.CodPro
    NO-LOCK NO-ERROR.
    IF AVAILABLE Gn-Prov THEN DISPLAY gn-prov.NomPro @ x-prov.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
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
   
     INTEGRAL.ImCFacCom.CodPro:SENSITIVE = FALSE.
     INTEGRAL.ImCFacCom.NroPed:SENSITIVE = FALSE.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR I AS INTEGER.
  DEF VAR x-Ok AS LOG NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  SYSTEM-DIALOG PRINTER-SETUP UPDATE x-Ok.
  IF x-Ok = NO THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */ 

  IF ImCFacCom.FlgEst <> "A" THEN RUN IMP\r-facimp(ROWID(ImCFacCom), ImCFacCom.CodDoc, ImCFacCom.NroFac).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
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
        WHEN "" THEN .
    END CASE.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ImCFacCom"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
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
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME} :
   /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CAMPO.
         RETURN "ADM-ERROR".   
   
      END.
   */
   


END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/
/*  RUN Carga-Temporal2.
 *   RUN Procesa-Handle IN lh_handle ('Pagina2').*/
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Validando-Incoterm V-table-Win 
PROCEDURE Validando-Incoterm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR Valor AS DECIMAL.
DEFINE VAR ImpTT AS DECIMAL NO-UNDO.

 /*Contando detalle*/
 FOR EACH DETA:
   ImpTT = ImpTT + Deta.ImpTot.
 END.  
 
 /*Validando valore FOB, Flete, Seguro*/  
 DO WITH FRAME {&FRAME-NAME}:
  FIND FIRST ImCOcmp WHERE ImCOcmp.CodCia = s-CodCia
       AND ImCOcmp.NroImp = NroImp
       NO-LOCK NO-ERROR.
  IF AVAILABLE ImCOcmp THEN DO:
     CASE ImCOCmp.FlgEst[1]:
        WHEN 'CFR' THEN
           DO:
             Valor = INTEGER(ImCFacCom.ImpFlete:SCREEN-VALUE) + INTEGER(ImCFacCom.ImpFob:SCREEN-VALUE).  
           END.
        WHEN 'FOB' THEN
           DO:
             Valor = INTEGER(ImCFacCom.ImpFob:SCREEN-VALUE).
           END.
        WHEN 'CIF' THEN
           DO:
             Valor = INTEGER(ImCFacCom.ImpFlete:SCREEN-VALUE) + INTEGER(ImCFacCom.ImpFob:SCREEN-VALUE) + INTEGER(x-seguro:SCREEN-VALUE).
           END.      
     END CASE.
     IF Valor <> ImpTT THEN DO:
       CASE ImCOCmp.FlgEst[1]:
         WHEN 'CFR' THEN 
              DO:
                MESSAGE "Se debe cumplir que: FOB + Flete = CFR " VIEW-AS ALERT-BOX.
                APPLY 'ENTRY':U TO ImCFacCom.ImpFob.
                RETURN 'ADM-ERROR'.
              END.
         WHEN 'FOB' THEN 
              DO:
                MESSAGE "Se debe cumplir que: FOB = CFR " VIEW-AS ALERT-BOX.
                APPLY 'ENTRY':U TO ImCFacCom.ImpFob.
                RETURN 'ADM-ERROR'.
              END.
         WHEN 'CIF' THEN 
              DO:
                MESSAGE "Se debe cumplir que: FOB + Flete + Seguro = CIF" VIEW-AS ALERT-BOX.
                APPLY 'ENTRY':U TO ImCFacCom.ImpFob.
                RETURN 'ADM-ERROR'.
              END. 
       END CASE.
     END.
  END.
 END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

