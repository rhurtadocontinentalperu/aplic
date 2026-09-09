&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE DDUA LIKE ImDDua.



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

/*DEFINE SHARED TEMP-TABLE DCMP LIKE ImDOCmp.*/
DEFINE BUFFER B-CCMP FOR ImCOCmp.
DEFINE VARIABLE Im-CREA   AS LOGICAL NO-UNDO.
DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-NROSER  AS INTEGER.
DEFINE SHARED VARIABLE S-PROVEE  AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-PORCFR  AS DEC.
DEFINE SHARED VARIABLE S-TPOCMB  AS DECIMAL.
DEFINE SHARED VARIABLE S-IMPCFR  AS DECIMAL.

DEFINE VAR p-NroRef LIKE ImCFacCom.NroFac.

DEFINE BUFFER B-CDUA FOR IMCDUA. 
DEFINE BUFFER B-CFAC FOR IMCFacCom.

/*
 * DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
 * DEFINE SHARED VARIABLE S-TPODOC AS CHAR.
 * 
 * */
/*DEFINE VARIABLE F-FACTOR     AS DECIMAL   NO-UNDO.
 * 
 * DEFINE VARIABLE X-TIPO AS CHAR INIT "CC".
 * DEFINE VARIABLE s-Control-Compras AS LOG NO-UNDO.   /* Control de 7 dias */
 * 
 * 
 * */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ImCDua
&Scoped-define FIRST-EXTERNAL-TABLE ImCDua


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ImCDua.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ImCDua.NroPed ImCDua.NroFac ImCDua.CodPro ~
ImCDua.Codmon ImCDua.FchDua ImCDua.FchVto ImCDua.ImpFob ImCDua.AjValor ~
ImCDua.TpoCmb ImCDua.ImpFlete ImCDua.ValAdua ImCDua.Seguro 
&Scoped-define ENABLED-TABLES ImCDua
&Scoped-define FIRST-ENABLED-TABLE ImCDua
&Scoped-Define ENABLED-OBJECTS RECT-24 r-moneda 
&Scoped-Define DISPLAYED-FIELDS ImCDua.NroDua ImCDua.NroCon ImCDua.NroPed ~
ImCDua.FchDoc ImCDua.NroFac ImCDua.Hora ImCDua.CodPro ImCDua.Userid-dua ~
ImCDua.Codmon ImCDua.FchDua ImCDua.FchVto ImCDua.ImpFob ImCDua.AjValor ~
ImCDua.TpoCmb ImCDua.ImpFlete ImCDua.ValAdua ImCDua.Seguro 
&Scoped-define DISPLAYED-TABLES ImCDua
&Scoped-define FIRST-DISPLAYED-TABLE ImCDua
&Scoped-Define DISPLAYED-OBJECTS x-estado x-prov r-moneda 

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
DEFINE VARIABLE x-estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 18.86 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 6 NO-UNDO.

DEFINE VARIABLE x-prov AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .81 NO-UNDO.

DEFINE VARIABLE r-moneda AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Soles", 1,
"Dolares", 2
     SIZE 16 BY .96 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 7.08.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     ImCDua.NroDua AT ROW 1.35 COL 10 COLON-ALIGNED
          LABEL "Nº DUA"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     ImCDua.NroCon AT ROW 1.35 COL 19.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.29 BY .81
     x-estado AT ROW 1.38 COL 66 COLON-ALIGNED NO-LABEL
     ImCDua.NroPed AT ROW 2.15 COL 10 COLON-ALIGNED
          LABEL "Nº Pedido"
          VIEW-AS FILL-IN 
          SIZE 22 BY .81
     ImCDua.FchDoc AT ROW 2.15 COL 75 COLON-ALIGNED
          LABEL "Fecha Emisión"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCDua.NroFac AT ROW 2.92 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     ImCDua.Hora AT ROW 2.92 COL 75 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCDua.CodPro AT ROW 3.69 COL 10 COLON-ALIGNED
          LABEL "Proveedor"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     x-prov AT ROW 3.69 COL 23 NO-LABEL
     ImCDua.Userid-dua AT ROW 3.69 COL 75 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     r-moneda AT ROW 4.5 COL 12 NO-LABEL WIDGET-ID 4
     ImCDua.Codmon AT ROW 4.5 COL 12 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 16 BY .96
     ImCDua.FchDua AT ROW 4.65 COL 75 COLON-ALIGNED
          LABEL "Fecha DUA"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCDua.FchVto AT ROW 5.42 COL 75 COLON-ALIGNED
          LABEL "Fecha Vencimiento"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCDua.ImpFob AT ROW 5.62 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     ImCDua.AjValor AT ROW 5.62 COL 37 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     ImCDua.TpoCmb AT ROW 6.19 COL 75 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     ImCDua.ImpFlete AT ROW 6.38 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     ImCDua.ValAdua AT ROW 6.38 COL 37 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     ImCDua.Seguro AT ROW 7.15 COL 10 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     "-" VIEW-AS TEXT
          SIZE 2 BY .5 AT ROW 1.54 COL 20 WIDGET-ID 2
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 4.85 COL 5
     RECT-24 AT ROW 1.19 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.ImCDua
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: DDUA T "SHARED" ? INTEGRAL ImDDua
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
         HEIGHT             = 7.5
         WIDTH              = 88.86.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       ImCDua.Codmon:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN ImCDua.CodPro IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ImCDua.FchDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN ImCDua.FchDua IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ImCDua.FchVto IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ImCDua.Hora IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCDua.NroCon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ImCDua.NroDua IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN ImCDua.NroPed IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ImCDua.Userid-dua IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-prov IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-FAC V-table-Win 
PROCEDURE Actualiza-FAC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /*Calculando totales de Factura y DUAS*/
  DEFINE VAR TOT  AS DECIMAL NO-UNDO.
  DEFINE VAR CONT AS INTEGER NO-UNDO INIT 0.

  FOR EACH IMCDUA WHERE ImCDua.CodCia = s-CodCia
      AND ImCDua.NroFac = INTEGER(ImCDua.NroFac:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
      EACH IMDDUA WHERE IMDDUA.CODCIA = IMCDUA.CODCIA
           AND ImDDua.NroDua = IMCDUA.NRODUA
           NO-LOCK BREAK BY IMDDUA.CODMAT:
              ACCUMULATE ImDDua.CanDua (SUB-TOTAL BY IMDDUA.CODMAT).   
              IF LAST-OF(IMDDUA.CODMAT) THEN DO:
                 TOT = ACCUM SUB-TOTAL BY IMDDUA.CODMAT ImDDua.CanDua.
                  FIND FIRST B-CFac WHERE B-CFac.CodCia = ImCDua.CodCia
                       AND B-CFac.NroFac = ImCDua.NroFac
                       EXCLUSIVE-LOCK NO-ERROR.
                       IF AVAILABLE B-CFac THEN DO:
                          FOR EACH ImDFacCom NO-LOCK WHERE ImDFacCom.CodCia = B-CFac.CodCia
                              AND ImDFacCom.NroFac = B-CFac.NroFac 
                              BREAK BY ImDFacCom.CodMat:
                                 IF ImDFacCom.CanAten > TOT THEN DO:                         
                                    CONT = CONT + 1.
                                 END.
                                 IF CONT = 0 THEN DO:
                                    ASSIGN B-CFAC.FlgEst = 'B'.
                                 END.
                                 ELSE DO:
                                    ASSIGN B-CFAC.FlgEst = 'E'.
                                 END. 
                          END.
                       END.
              END.
  END.
  RELEASE B-CFac.
  RELEASE ImDFacCom.
  RELEASE ImDDua.

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
  {src/adm/template/row-list.i "ImCDua"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ImCDua"}

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
  FOR EACH ImDDua WHERE ImDDua.CodCia = ImCDua.CodCia
      AND ImDDua.NroDua = ImCDua.NroDua
      EXCLUSIVE-LOCK 
      ON ERROR UNDO, RETURN 'ADM-ERROR'
      ON STOP UNDO, RETURN 'ADM-ERROR':
        DELETE ImDDua.
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
  FOR EACH DDUA:
    DELETE DDUA.
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
           AND ImCOcmp.NroPed = ImCDua.NroPed:SCREEN-VALUE
           NO-LOCK NO-ERROR.      
      IF AVAILABLE ImCOcmp THEN DO:
         CASE ImCOCmp.FlgEst[1]:
            WHEN 'CFR' THEN
               DO:
                 Valor0 = INTEGER(ImCDua.ImpFlete:SCREEN-VALUE) + INTEGER(ImCDua.ImpFob:SCREEN-VALUE).  
               END.
            WHEN 'FOB' THEN
               DO:
                 Valor0 = INTEGER(ImCDua.ImpFob:SCREEN-VALUE).
               END.
            WHEN 'CIF' THEN
               DO:
                 Valor0 = INTEGER(ImCDua.ImpFlete:SCREEN-VALUE) + INTEGER(ImCDua.ImpFob:SCREEN-VALUE) + INTEGER(ImCDua.Seguro:SCREEN-VALUE).
               END.      
         END CASE.
     END.
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
  DEFINE VARIABLE NroFac AS DECIMAL NO-UNDO.
  NroFac = INTEGER(ImCDua.NroFac:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
  FOR EACH ImDFacCom WHERE ImDFacCom.CodCia = s-CodCia
    AND ImDFacCom.NroFac = p-NroRef NO-LOCK BREAK BY ImDFacCom.codmat:
     CREATE DDUA.
     BUFFER-COPY ImDFacCom TO DDUA.
        ASSIGN
           DDUA.CodCia = ImDFacCom.CodCia
           DDUA.Nrodua = INTEGER(ImCDua.Nrodua:SCREEN-VALUE IN FRAME {&FRAME-NAME})
           DDUA.CodMat = ImDFacCom.CodMat
           DDUA.UndCmp = ImDFacCom.UndCmp.
        FIND FIRST ImCDua WHERE ImCDua.CodCia = s-CodCia
             AND ImCDua.NroFac = NroFac 
             AND ImCDua.FlgEst <> 'A' NO-LOCK NO-ERROR.
        IF AVAILABLE ImCDua THEN DO:
           FOR EACH IMCDUA WHERE ImCDua.NroFac = NroFac,
               EACH IMDDUA WHERE IMDDUA.CODCIA = IMCDUA.CODCIA
               AND ImDDua.NroDua = IMCDUA.NRODUA
               NO-LOCK BREAK BY IMDDUA.CODMAT:
                  ACCUMULATE ImDDua.CanDua (SUB-TOTAL BY IMDDUA.CODMAT).
                  IF ImDFacCom.codmat = IMDDUA.CODMAT THEN DO:
                     DDUA.CanDua = ImDFacCom.CanAte - ACCUM SUB-TOTAL BY IMDDUA.CODMAT ImDDua.CanDua. 
                  END.
           END.
        END.
        ELSE DO:
             ASSIGN DDUA.CanDua = ImDFacCom.CanAte. 
        END.
  END.
  RELEASE ImDDua.
  RELEASE ImDFacCom.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Comparando-Totales V-table-Win 
PROCEDURE Comparando-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Orden-Compra V-table-Win 
PROCEDURE Genera-Orden-Compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*  FOR EACH DCMP WHERE DCMP.CanPedi > 0:
 *     CREATE ImDOCmp.
 *     BUFFER-COPY DCMP TO ImDOcmp
 *         ASSIGN 
 *             ImDOCmp.CodCia = ImCOCmp.CodCia 
 *             ImDOCmp.Coddoc = ImCOCmp.Coddoc
 *             ImDOCmp.NroImp = ImCOCmp.NroImp.
 *     RELEASE ImDOCmp.
 *   END.*/

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
  FOR EACH DDUA:
      CREATE ImDDua.
       ASSIGN 
           ImDDua.CodCia  =  DDUA.CodCia
           ImDDua.CodDiv  =  ImCDua.CodDiv
           ImDDua.NroDua  =  ImCDua.NroDua
           ImDDua.CodMat  =  DDUA.CodMat 
           ImDDua.UndCmp  =  DDUA.UndCmp
           ImDDua.CanDua  =  DDUA.CanDua. 
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
     ImCDua.Seguro:HIDDEN = FALSE.
     ImCDua.Seguro:SENSITIVE = TRUE.
     ImCDua.ImpFlete:HIDDEN = FALSE.
     ImCDua.ImpFlete:SENSITIVE = TRUE.
     ImCDua.ImpFob:HIDDEN = FALSE.
     ImCDua.ImpFob:SENSITIVE = TRUE.     
     r-moneda:HIDDEN = FALSE.
     ImCDua.CodMon:HIDDEN = TRUE.
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
  DEFINE VAR Prov AS CHARACTER FORMAT 'X(55)'.
  DEFINE VAR x-item AS INTEGER NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */
    RUN IMP\d-facpen (OUTPUT p-NroRef).
    IF p-NroRef = 0 THEN RETURN 'ADM-ERROR'.
     
    /*VA EN EL ASSIGN*/
      FIND LG-CORR WHERE 
        LG-CORR.codcia = s-codcia AND 
        LG-CORR.coddiv = s-coddiv AND 
        LG-CORR.coddoc = "DUA"
        EXCLUSIVE-LOCK NO-ERROR.
     IF NOT AVAILABLE LG-CORR THEN DO:
        MESSAGE 'Correlativo No Disponible'
        VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
   END.
   
  /*  RUN Habilitar-Campos.  */
   
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  
  
  /* Code placed here will execute AFTER standard behavior.    */
  
 RUN Habilitar-Campos. 
 DO WITH FRAME {&FRAME-NAME}:
    FIND FIRST ImCFacCom WHERE ImCFacCom.NroFac = p-NroRef
         NO-LOCK NO-ERROR.
    IF AVAILABLE ImCFacCom THEN DO:
       /*Proveedores*/
       FIND FIRST GN-PROV WHERE gn-prov.CodPro = ImCFacCom.CodPro
          NO-LOCK NO-ERROR.
       IF AVAILABLE GN-PROV THEN DO:
          Prov = gn-prov.NomPro.
       END.
       
       /*Dato Incoterm*/
       FIND FIRST ImCOcmp WHERE ImCOcmp.CodCia = ImCFacCom.CodCia
            AND ImCOcmp.NroPed = ImCFacCom.NroPed
            NO-LOCK NO-ERROR.
       IF AVAILABLE ImCOcmp THEN DO:
           Case ImCOCmp.FlgEst[1]:
                When 'FOB' THEN
                      DO: 
                        ImCDua.Seguro:HIDDEN = TRUE.
                        ImCDua.ImpFlete:HIDDEN = TRUE.
                      END.
                When 'CFR' THEN
                      DO:
                        ImCDua.Seguro:HIDDEN = TRUE.
                        /* ImCDua.ImpFlete:HIDDEN = TRUE. */
                      END.
           End Case.
       END. 
       x-item = ImCFacCom.Codmon. 
       r-moneda = x-item.
       DISPLAY 
         Lg-Corr.NroDoc   @ ImCDua.NroDua
         ImCFacCom.NroFac @ INTEGRAL.ImCDua.NroFac
         ImCFacCom.NroPed @ ImCDua.NroPed 
/*          ImCDua.Codmon */
         r-moneda
         TODAY @ ImCDua.FchDoc
         s-user-id @ ImCDua.Userid-dua
         STRING(TIME,"HH:MM") @ ImCDua.Hora
         ImCFacCom.CodPro @ ImCDua.CodPro
         Prov @ x-prov.
       RUN Carga-Temporal.
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
        LG-CORR.coddoc = "DUA"
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE LG-CORR THEN DO:
        MESSAGE 'Correlativo No Disponible'
        VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
   DEFINE VAR CONTADOR AS INT INIT 1.  
   RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'YES' THEN DO WITH FRAME {&FRAME-NAME}:  
       FOR EACH B-CDUA WHERE B-CDUA.NroFac = INTEGER(ImCDua.NroFac:SCREEN-VALUE IN FRAME {&FRAME-NAME})
         BREAK BY B-CDUA.NroFac:
         CONTADOR = CONTADOR + 1.
       END.

       /* RUN Calculando-Incoterm.  */
       DO WITH FRAME {&FRAME-NAME}:
          ASSIGN
            ImCDua.CodCia     = s-CodCia
            ImCDua.CodDiv     = s-CodDiv
            ImCDua.NroDua     = LG-CORR.NroDoc
            LG-CORR.NroDoc    = LG-CORR.NroDoc + 1
            ImCDua.CodMon     = r-moneda
            ImCDua.FchDoc     = TODAY
            ImCDua.Hora       = STRING(TIME,'HH:MM')
            ImCDua.NroCon     = Contador
            ImCDua.Userid-dua = S-USER-ID
            ImCDua.FlgEst     = 'E'      /* Emitido */ .
       
       END.
    END.
    ELSE RUN Borra-Detalle.
    RUN Graba-Detalle.    
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    
    RUN Actualiza-FAC.    
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

    ImCDua.Seguro:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.      
        
    RELEASE Lg-Corr.
    RELEASE ImDDua.   
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
  
  DO WITH FRAME {&FRAME-NAME}:
     ImCDua.Seguro:HIDDEN = FALSE.
     ImCDua.Seguro:SENSITIVE = TRUE.
     ImCDua.ImpFlete:HIDDEN = FALSE. 
     ImCDua.ImpFob:HIDDEN = FALSE.   
  END.
  
  RUN Procesa-Handle IN lh_Handle ("Pagina1").
  RUN Procesa-Handle IN lh_Handle ('Browse').

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE L-ATEPAR AS LOGICAL INIT NO NO-UNDO.  
  FIND FIRST B-CDUA WHERE B-CDUA.CodCia = ImCDua.CodCia
       AND B-CDUA.NroDua = ImCDua.NroDua
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE B-CDUA THEN DO:
     RUN Borra-Detalle.
     ASSIGN
        B-CDUA.FlgEst = 'A'.
  END.

  FIND FIRST B-CFAC WHERE B-CFAC.CodCia = ImCDua.CodCia
       AND B-CFAC.NroFac = ImCDua.NroFac
       AND B-CFAC.FlgEst = 'B'
       EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE B-CFAC THEN DO:
     ASSIGN B-CFAC.FlgEst = 'E'.
  END.
    
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
    
   FIND FIRST ImCOcmp WHERE ImCOcmp.CodCia = ImCDua.CodCia
          AND ImCOcmp.NroPed = ImCDua.NroPed
          NO-LOCK NO-ERROR.
     IF AVAILABLE ImCOcmp THEN DO WITH FRAME {&FRAME-NAME}:
        Case ImCOCmp.FlgEst[1]:
             When 'FOB' THEN
                   DO: 
                     ImCDua.Seguro:HIDDEN = TRUE.
                     ImCDua.ImpFlete:HIDDEN = TRUE.
                   END.
             When 'CFR' THEN
                   DO:
                     ImCDua.Seguro:HIDDEN = TRUE.
                   END.
             OTHERWISE
                   DO:
                     ImCDua.Seguro:HIDDEN = FALSE.
                     ImCDua.ImpFlete:HIDDEN = FALSE.
                   END.      
        End Case.
     END.
    
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  IF AVAILABLE ImCDua THEN DO WITH FRAME {&FRAME-NAME}:
     r-moneda:HIDDEN = TRUE.
     imcdua.codmon:HIDDEN = FALSE.
     FIND gn-prov WHERE gn-prov.CodPro = ImCDua.CodPro
                  NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN
        DISPLAY gn-prov.NomPro    @ x-prov.     
     IF LOOKUP(ImCDua.FlgEst,"E,A") > 0 THEN
        x-Estado:SCREEN-VALUE = ENTRY(LOOKUP(ImCDua.FlgEst,"E,A,C"), ~
                  " E M I T I D O , A N U L A D O , C E R R A D O ").
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
     ImCDua.NroPed:SENSITIVE = FALSE.
     ImCDua.CodPro:SENSITIVE = FALSE.
     ImCDua.NroFac:SENSITIVE = FALSE.
/*      ImCDua.CodMon:SENSITIVE = FALSE. */
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
  DEF VAR MENS AS CHARACTER.
  DEF VAR x-Ok AS LOG NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  SYSTEM-DIALOG PRINTER-SETUP UPDATE x-Ok.
  IF x-Ok = NO THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
   DEF VAR x-Copias AS CHAR.
  
/*   RUN lgc/d-impodc (OUTPUT x-Copias).                */
/*   IF x-Copias = 'ADM-ERROR' THEN RETURN.             */
/*   DO i = 1 TO NUM-ENTRIES(x-Copias):                 */
/* /*     CASE ENTRY(i, x-Copias):                   */ */
/* /*         WHEN 'ALM' THEN MENS = 'ALMACEN'.      */ */
/* /*         WHEN 'CBD' THEN MENS = 'CONTABILIDAD'. */ */
/* /*         WHEN 'PRO' THEN MENS = 'PROVEEDOR'.    */ */
/* /*         WHEN 'ARC' THEN MENS = 'ARCHIVO'.      */ */
/* /*     END CASE.                                  */ */
/*     IF ImCDua.FlgEst <> "A" THEN RUN imp\r-duaimp(ROWID(ImCDua), NroDua). */
/*   END. */

/*     IF ImCFacCom.FlgEst <> "A" THEN RUN IMP\r-facimp(ROWID(ImCFacCom), ImCFacCom.CodDoc, ImCFacCom.NroFac). */
    IF ImCDua.FlgEst <> "A" THEN RUN IMP\r-duaimp(ROWID(ImCDua), ImCDua.NroDua).
  
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
  /*
 *   DO WITH FRAME {&FRAME-NAME}:
 *     FOR EACH Lg-Tabla NO-LOCK WHERE Lg-Tabla.codcia = s-codcia
 *             AND Lg-Tabla.Tabla = '01':
 *         ImCOCmp.FlgEst[1]:ADD-LAST(lg-tabla.Codigo).
 *     END.            
 *   END.*/

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
  
  RUN Genera-Orden-Compra.

  RUN Procesa-Handle IN lh_Handle ("Pagina1").
  RUN Procesa-Handle IN lh_Handle ('Browse').

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
    input-var-1 = "".
    CASE HANDLE-CAMPO:name:
        WHEN "CndCmp" THEN ASSIGN input-var-1 = "" /*"20"*/.
        

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
  {src/adm/template/snd-list.i "ImCDua"}

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
  
  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
     Im-CREA = NO.
     RUN Actualiza-DCMP.
     RUN Procesa-Handle IN lh_Handle ("Pagina2").
     RUN Procesa-Handle IN lh_Handle ('Browse').
  END.
  
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
RETURN "ADM-ERROR".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

