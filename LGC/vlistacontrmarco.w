&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
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
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE BUFFER MATPR FOR lg-clistamarco.
DEFINE BUFFER DMATPR FOR lg-dlistamarco.
DEFINE VAR X-NROLIS AS INTEGER NO-UNDO.
DEFINE VAR W-NROLIS AS INTEGER NO-UNDO.
DEFINE VAR L-COPIA  AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VAR F-PRECOS AS DECIMAL NO-UNDO.

DEFINE SHARED VAR lh_Handle AS HANDLE.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEFINE VARIABLE FI-MENSAJE AS CHAR FORMAT "X(40)" .
DEFINE STREAM REPORTE.

DEFINE FRAME F-Proceso
    IMAGE-1 AT ROW 1.5 COL 5
    "Espere un momento" VIEW-AS TEXT
        SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
    "por favor ...." VIEW-AS TEXT
        SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
        SKIP
    Fi-Mensaje NO-LABEL FONT 6
    SKIP     
    WITH OVERLAY CENTERED KEEP-TAB-ORDER 
        SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
        BGCOLOR 15 FGCOLOR 0 
        TITLE "Procesando ..." FONT 7.

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
&Scoped-define EXTERNAL-TABLES lg-clistamarco
&Scoped-define FIRST-EXTERNAL-TABLE lg-clistamarco


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR lg-clistamarco.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS lg-clistamarco.CodMon lg-clistamarco.CodPro ~
lg-clistamarco.Dsctos[1] lg-clistamarco.CndCmp lg-clistamarco.aftigv ~
lg-clistamarco.Dsctos[2] lg-clistamarco.FchEmi lg-clistamarco.FchVig ~
lg-clistamarco.Dsctos[3] 
&Scoped-define ENABLED-TABLES lg-clistamarco
&Scoped-define FIRST-ENABLED-TABLE lg-clistamarco
&Scoped-Define ENABLED-OBJECTS RECT-20 
&Scoped-Define DISPLAYED-FIELDS lg-clistamarco.nrolis lg-clistamarco.CodMon ~
lg-clistamarco.CodPro lg-clistamarco.Dsctos[1] lg-clistamarco.CndCmp ~
lg-clistamarco.aftigv lg-clistamarco.Dsctos[2] lg-clistamarco.FchEmi ~
lg-clistamarco.FchVig lg-clistamarco.FchVto lg-clistamarco.Dsctos[3] 
&Scoped-define DISPLAYED-TABLES lg-clistamarco
&Scoped-define FIRST-DISPLAYED-TABLE lg-clistamarco
&Scoped-Define DISPLAYED-OBJECTS F-Estado FILL-IN_NomPro F-DesCnd 

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
DEFINE VARIABLE F-DesCnd AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.14 BY .69 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14.29 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN_NomPro AS CHARACTER FORMAT "x(50)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 111 BY 3.77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     lg-clistamarco.nrolis AT ROW 1.27 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.14 BY .69
     lg-clistamarco.CodMon AT ROW 1.27 COL 52.43 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .5
     F-Estado AT ROW 1.27 COL 89 COLON-ALIGNED NO-LABEL
     lg-clistamarco.CodPro AT ROW 2.08 COL 12 COLON-ALIGNED
          LABEL "Proveedor"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     FILL-IN_NomPro AT ROW 2.08 COL 23 COLON-ALIGNED HELP
          "Nombre del Proveedor" NO-LABEL
     lg-clistamarco.Dsctos[1] AT ROW 2.08 COL 99 COLON-ALIGNED FORMAT "ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     lg-clistamarco.CndCmp AT ROW 2.88 COL 12 COLON-ALIGNED FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .69
     F-DesCnd AT ROW 2.88 COL 23 COLON-ALIGNED NO-LABEL
     lg-clistamarco.aftigv AT ROW 2.88 COL 60
          VIEW-AS TOGGLE-BOX
          SIZE 12 BY .69
     lg-clistamarco.Dsctos[2] AT ROW 2.88 COL 99 COLON-ALIGNED FORMAT "ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     lg-clistamarco.FchEmi AT ROW 3.69 COL 12 COLON-ALIGNED
          LABEL "Fecha Emision" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     lg-clistamarco.FchVig AT ROW 3.69 COL 35 COLON-ALIGNED
          LABEL "Fecha Activacion" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     lg-clistamarco.FchVto AT ROW 3.69 COL 58 COLON-ALIGNED
          LABEL "F. Desactivado"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     lg-clistamarco.Dsctos[3] AT ROW 3.69 COL 99 COLON-ALIGNED FORMAT "ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     "Moneda" VIEW-AS TEXT
          SIZE 6.14 BY .5 AT ROW 1.31 COL 45
     RECT-20 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.lg-clistamarco
   Allow: Basic,DB-Fields
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
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 4.88
         WIDTH              = 114.43.
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

/* SETTINGS FOR FILL-IN lg-clistamarco.CndCmp IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN lg-clistamarco.CodPro IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN lg-clistamarco.Dsctos[1] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN lg-clistamarco.Dsctos[2] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN lg-clistamarco.Dsctos[3] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-DesCnd IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lg-clistamarco.FchEmi IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN lg-clistamarco.FchVig IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN lg-clistamarco.FchVto IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN_NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lg-clistamarco.nrolis IN FRAME F-Main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME lg-clistamarco.CndCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lg-clistamarco.CndCmp V-table-Win
ON LEAVE OF lg-clistamarco.CndCmp IN FRAME F-Main /* Condicion */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND gn-ConCp WHERE gn-ConCp.Codig = lg-clistamarco.CndCmp:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF AVAILABLE gn-ConCp THEN
      DISPLAY gn-ConCp.Nombr @ F-DesCnd WITH FRAME {&FRAME-NAME}.
   ELSE DO:
        MESSAGE "Condicion de Compra no Registrado" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lg-clistamarco.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lg-clistamarco.CodPro V-table-Win
ON LEAVE OF lg-clistamarco.CodPro IN FRAME F-Main /* Proveedor */
DO:
/*   IF SELF:SCREEN-VALUE = "" THEN RETURN.*/
   FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA 
                AND gn-prov.CodPro = lg-clistamarco.CodPro:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
   
   IF AVAILABLE gn-prov THEN
      DISPLAY gn-prov.NomPro @ FILL-IN_NomPro WITH FRAME {&FRAME-NAME}.

   ELSE DO:
        MESSAGE "Proveedor" SELF:SCREEN-VALUE "no Registrado en el Maestro de Proveedores" skip
                "Consulte con la División de Logística o Sistemas" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
   END.
   
   FIND lg-clistamarco WHERE lg-clistamarco.Codcia = S-CODCIA 
                  AND lg-clistamarco.Codpro = lg-clistamarco.Codpro:SCREEN-VALUE
                  NO-LOCK NO-ERROR.

   IF AVAILABLE lg-clistamarco THEN DO:
        MESSAGE "Ya Existe Lista Activa para el Proveedor "  SKIP
                "           Utilice Lista  # " + STRING(lg-clistamarco.Nrolis)  VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lg-clistamarco.FchVig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lg-clistamarco.FchVig V-table-Win
ON LEAVE OF lg-clistamarco.FchVig IN FRAME F-Main /* Fecha Activacion */
DO:
  IF INPUT lg-clistamarco.FchVig < INPUT lg-clistamarco.FchEmi THEN DO:
      MESSAGE "Fecha Activacion debe ser mayor fecha Emision" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY. 
  END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lg-clistamarco.FchVto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lg-clistamarco.FchVto V-table-Win
ON LEAVE OF lg-clistamarco.FchVto IN FRAME F-Main /* F. Desactivado */
DO:
  IF INPUT lg-clistamarco.FchVto = ? THEN RETURN.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Activar-lista V-table-Win 
PROCEDURE Activar-lista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Activa la Lista al Catalogo Principal
------------------------------------------------------------------------------*/
IF lg-clistamarco.FlgEst = "A" OR lg-clistamarco.FlgEst = "D" THEN DO:
   MESSAGE "No puede Activar una lista Activa/Desactivada" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
   END.
      
/* Desactiva La Antigua Lista */
FIND LAST MATPR WHERE MATPR.CodCia = lg-clistamarco.CodCia 
                  AND MATPR.CodPro = lg-clistamarco.CodPro 
                  AND MATPR.FlgEst = "A" 
                  NO-ERROR.
                  
IF AVAILABLE MATPR THEN DO:
    w-nrolis = matpr.nrolis.
    ASSIGN MATPR.FlgEst = "D"
    MATPR.FchVto = TODAY.
END.    
  
FOR EACH dmatpr WHERE dmatpr.CodCia = lg-clistamarco.CodCia
                AND  dmatpr.nrolis = w-nrolis 
                AND  dmatpr.FlgEst = "A":
    ASSIGN
    dmatpr.flgest = "D".
/*     FIND almmmatg WHERE almmmatg.codcia = S-CODCIA      */
/*                     AND almmmatg.codmat = dmatpr.codmat */
/*                     NO-ERROR.                           */
/*     IF AVAILABLE almmmatg THEN DO:                      */
/*         ASSIGN                                          */
/*             ALmmmatg.CodPr1     = "".                   */
/*             ALmmmatg.ArtPro     = "".                   */
/*             ALmmmatg.CodPr2     = dmatpr.CodPro.        */
/*         RELEASE Almmmatg.                               */
/*     END.                                                */
END.  

/* Actualiza Cabecera Lista */
FIND MATPR WHERE MATPR.CodCia = lg-clistamarco.CodCia 
            AND  MATPR.nrolis = lg-clistamarco.nrolis 
            NO-ERROR.
            
IF AVAILABLE MATPR THEN DO:
    ASSIGN 
        MATPR.FlgEst = "A".
        MATPR.FchVIG = TODAY. 
END.
   
CASE MATPR.FlgEst:
    WHEN "A" THEN DISPLAY "ACTIVO" @ F-Estado WITH FRAME {&FRAME-NAME}.
    WHEN "D" THEN DISPLAY "DESACTIVADO" @ F-Estado WITH FRAME {&FRAME-NAME}.
    WHEN ""  THEN DISPLAY "PENDIENTE" @ F-Estado WITH FRAME {&FRAME-NAME}.
END CASE.        

/* Actualiza Detalle Lista */
FOR EACH lg-dlistamarco WHERE lg-dlistamarco.CodCia = lg-clistamarco.CodCia 
                    AND  lg-dlistamarco.nrolis = lg-clistamarco.nrolis:
    ASSIGN 
    lg-dlistamarco.flgest = "A".
                
/*     FIND almmmatg WHERE almmmatg.codcia = S-CODCIA              */
/*                    AND  almmmatg.codmat = lg-dlistamarco.codmat */
/*                    NO-ERROR.                                    */
/*     IF AVAILABLE almmmatg THEN DO:                              */
/*         ASSIGN                                                  */
/*             ALmmmatg.ArtPro     = lg-dlistamarco.ArtPro         */
/*             ALmmmatg.CodPr1     = lg-dlistamarco.CodPro         */
/*             Almmmatg.FchmPre[2] = TODAY.                        */
/*         RELEASE Almmmatg.                                       */
/*     END.                                                        */
END.                                                                        


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Lista V-table-Win 
PROCEDURE Actualiza-Lista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH lg-dlistamarco WHERE lg-dlistamarco.CodCia = lg-clistamarco.CodCia 
    AND lg-dlistamarco.nrolis = lg-clistamarco.nrolis:
    ASSIGN 
        lg-dlistamarco.codpro = lg-clistamarco.codpro
        lg-dlistamarco.FchEmi = lg-clistamarco.FchEmi
        lg-dlistamarco.FchVto = lg-clistamarco.FchVto
        lg-dlistamarco.FlgEst = lg-clistamarco.FlgEst
        lg-dlistamarco.Dsctos[1] = lg-clistamarco.Dsctos[1] 
        lg-dlistamarco.Dsctos[2] = lg-clistamarco.Dsctos[2] 
        lg-dlistamarco.Dsctos[3] = lg-clistamarco.Dsctos[3].
    lg-dlistamarco.PreCos = f-precos.
    F-PRECOS = ROUND(lg-dlistamarco.PreAct * 
                     (1 - (lg-dlistamarco.Dsctos[1] / 100)) *
                     (1 - (lg-dlistamarco.Dsctos[2] / 100)) *
                     (1 - (lg-dlistamarco.Dsctos[3] / 100)) , 4).
END.
 
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
  {src/adm/template/row-list.i "lg-clistamarco"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "lg-clistamarco"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Copia-Lista V-table-Win 
PROCEDURE Copia-Lista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH lg-dlistamarco 
    WHERE lg-dlistamarco.CodCia = lg-clistamarco.CodCia 
    AND lg-dlistamarco.nrolis = X-NROLIS:
    CREATE DMATPR.
    ASSIGN DMATPR.CodCia = lg-clistamarco.CodCia
        DMATPR.nrolis    = lg-clistamarco.nrolis
        DMATPR.codpro    = lg-clistamarco.codpro
        DMATPR.FchEmi    = lg-clistamarco.FchEmi
        DMATPR.FchVto    = lg-clistamarco.FchVto
        DMATPR.FlgEst    = lg-clistamarco.FlgEst
        DMATPR.Dsctos[1] = lg-dlistamarco.Dsctos[1]
        DMATPR.Dsctos[2] = lg-dlistamarco.Dsctos[2] 
        DMATPR.Dsctos[3] = lg-dlistamarco.Dsctos[3]
        DMATPR.IgvMat    = lg-dlistamarco.IgvMat
        DMATPR.CodMon    = lg-dlistamarco.CodMon
        DMATPR.ArtPro    = lg-dlistamarco.ArtPro 
        DMATPR.codmat    = lg-dlistamarco.codmat 
        DMATPR.desmat    = lg-dlistamarco.desmat 
        DMATPR.PreAct    = lg-dlistamarco.PreAct 
        DMATPR.PreAnt    = lg-dlistamarco.PreAct 
        DMATPR.PreCos    = lg-dlistamarco.PreCos
        DMATPR.tpobien   = lg-dlistamarco.tpobien.
    END.
    L-COPIA = NO.

    RELEASE MATPR.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importar-Excel V-table-Win 
PROCEDURE Importar-Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE lg-clistamarco OR lg-clistamarco.flgest <> '' THEN DO:
    MESSAGE 'Solo se puede importar información si la lista está PENDIENTE'
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.

DEFINE VARIABLE OKpressed AS LOGICAL NO-UNDO.
DEFINE VARIABLE FILL-IN-file AS CHAR NO-UNDO.
DEFINE VAR F-CTOLIS AS DECIMAL NO-UNDO.
DEFINE VAR F-CTOTOT AS DECIMAL NO-UNDO.

SYSTEM-DIALOG GET-FILE FILL-IN-file
    FILTERS "Archivos Excel (*.xls)" "*.xls", "Todos (*.*)" "*.*"
    TITLE "Archivo(s) de Carga..."
    MUST-EXIST
    USE-FILENAME
    UPDATE OKpressed.
IF OKpressed = FALSE THEN RETURN.

/* PRIMERO BORRAMOS TODO EL DETALLE */
FOR EACH lg-dlistamarco OF lg-clistamarco:
    DISPLAY "** ELIMINANDO **" lg-dlistamarco.codmat @ fi-mensaje WITH FRAME f-Proceso.
    DELETE lg-dlistamarco.
END.
/* ******************************** */

/* SEGUNDO IMPORTAMOS DESDE EL EXCEL */
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.

DEFINE VARIABLE cRange AS CHARACTER NO-UNDO.
DEFINE VARIABLE iCountLine AS INTEGER NO-UNDO.
DEFINE VARIABLE iTotalColumn AS INTEGER NO-UNDO.
DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.

CREATE "Excel.Application" chExcelApplication.

chWorkbook = chExcelApplication:Workbooks:OPEN(FILL-IN-file).
chWorkSheet = chExcelApplication:Sheets:ITEM(1).

iCountLine = 1.     /* Saltamos el encabezado de los campos */
REPEAT:
    iCountLine = iCountLine + 1.
    cRange = "A" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    IF cValue = "" OR cValue = ? THEN LEAVE.    /* FIN DE DATOS */
    /* CODIGO */
    cRange = "A" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN
        cValue = STRING(INTEGER (cValue), '999999')
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor no reconocido:' cValue SKIP
            'Campo: Código' VIEW-AS ALERT-BOX ERROR.
        NEXT.
    END.
    DISPLAY "** ACTUALIZANDO **" cValue @ fi-mensaje WITH FRAME f-Proceso.
    /* REGISTRAMOS EL PRODUCTO */
    FIND lg-dlistamarco OF lg-clistamarco WHERE lg-dlistamarco.codmat = cValue
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE lg-dlistamarco THEN CREATE lg-dlistamarco.
    BUFFER-COPY lg-clistamarco TO lg-dlistamarco.
    ASSIGN
        lg-dlistamarco.CodMat = cValue.
    /* CODIGO PROVEEDOR */
    cRange = "B" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN
        lg-dlistamarco.ArtPro = cValue.
    /* MONEDA */
    cRange = "F" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN
        lg-dlistamarco.CodMon = INTEGER (cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor no reconocido:' cValue SKIP
            'Campo: Moneda' VIEW-AS ALERT-BOX ERROR.
        NEXT.
    END.
    /* PRECIO LISTA */
    cRange = "G" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN
        lg-dlistamarco.PreAct = DECIMAL (cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor no reconocido:' cValue SKIP
            'Campo: Precio' VIEW-AS ALERT-BOX ERROR.
        NEXT.
    END.
    /* DESCUENTO 1 */
    cRange = "H" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN
        lg-dlistamarco.Dsctos[1] = DECIMAL (cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor no reconocido:' cValue SKIP
            'Campo: % Dscto 1' VIEW-AS ALERT-BOX ERROR.
        NEXT.
    END.
    /* DESCUENTO 2 */
    cRange = "I" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN
        lg-dlistamarco.Dsctos[2] = DECIMAL (cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor no reconocido:' cValue SKIP
            'Campo: % Dscto 2' VIEW-AS ALERT-BOX ERROR.
        NEXT.
    END.
    /* DESCUENTO 3 */
    cRange = "J" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN
        lg-dlistamarco.Dsctos[3] = DECIMAL (cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor no reconocido:' cValue SKIP
            'Campo: % Dscto 3' VIEW-AS ALERT-BOX ERROR.
        NEXT.
    END.
    /* IGV */
    cRange = "K" + TRIM(STRING(iCountLine)).
    cValue = chWorkSheet:Range(cRange):VALUE.
    ASSIGN
        lg-dlistamarco.IgvMat = DECIMAL (cValue)
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Valor no reconocido:' cValue SKIP
            'Campo: % IGV' VIEW-AS ALERT-BOX ERROR.
        NEXT.
    END.
    /* GRABACIONES FINALES */
    ASSIGN
        lg-dlistamarco.TpoBien = 1.
    FIND Almmmatg WHERE Almmmatg.CodCia = lg-dlistamarco.CodCia 
        AND  Almmmatg.codmat = lg-dlistamarco.codmat 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
        F-CtoLis = ROUND(lg-dlistamarco.PreAct * 
                      (1 - (lg-dlistamarco.Dsctos[1] / 100)) * 
                      (1 - (lg-dlistamarco.Dsctos[2] / 100)) * 
                      (1 - (lg-dlistamarco.Dsctos[3] / 100)) ,4).
        F-CtoTot = ROUND(lg-dlistamarco.PreAct * 
                      (1 - (lg-dlistamarco.Dsctos[1] / 100)) *
                      (1 - (lg-dlistamarco.Dsctos[2] / 100)) *
                      (1 - (lg-dlistamarco.Dsctos[3] / 100)) *
                      (1 + (lg-dlistamarco.IgvMat / 100)) , 4).
        ASSIGN 
            lg-dlistamarco.desmat = Almmmatg.DesMat
            lg-dlistamarco.PreAnt = Almmmatg.preant
            lg-dlistamarco.PreCos = F-CtoLis           
            lg-dlistamarco.CtoLis = F-CtoLis
            lg-dlistamarco.CtoTot = F-CtoTot.           
    END.
END.
chExcelApplication:QUIT().
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet. 

HIDE FRAME f-Proceso.
RELEASE lg-dlistamarco.

RUN Procesa-Handle IN lh_handle ('open').

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY @ lg-clistamarco.FchEmi.
  END.
  
  RUN Procesa-Handle IN lh_Handle ("Hide").
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE X-NRO AS INTEGER NO-UNDO.

/* Code placed here will execute PRIOR to standard behavior. */

FIND LAST MATPR WHERE MATPR.codcia = S-CODCIA NO-LOCK NO-ERROR.
IF AVAILABLE MATPR THEN X-NRO = MATPR.nrolis + 1.
ELSE X-NRO = 1.

/* Dispatch standard ADM method.                             */

RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ).

/* Code placed here will execute AFTER standard behavior.    */

RUN get-attribute("ADM-NEW-RECORD").

IF RETURN-VALUE = "YES" THEN DO:
    ASSIGN 
    lg-clistamarco.CodCia = S-CodCia
    lg-clistamarco.NroLis = X-NRO.
    END.

IF lg-clistamarco.FchVto = ? THEN lg-clistamarco.FlgEst = "".
    ELSE DO:
    IF lg-clistamarco.FchEmi <= TODAY AND lg-clistamarco.FchVto > TODAY THEN
    ASSIGN lg-clistamarco.FlgEst = " ".
    ELSE ASSIGN lg-clistamarco.FlgEst = " ".
    END.

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

  /* Dispatch standard ADM method.
                         */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  
  L-COPIA = NO.
  RUN Procesa-Handle IN lh_Handle ("Show").
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  
  IF lg-clistamarco.FlgEst = "D" THEN DO:
     MESSAGE "No Puede Copiar Lista Desactivada" VIEW-AS ALERT-BOX ERROR.
     RETURN ERROR.
  END.
  MESSAGE "Se Generara Nueva Lista Actual, " SKIP
          "  la otra lista de Desactivará  " SKIP
          "         ¿Desea Continuar?      "  
          VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO
          UPDATE Rpta AS LOGICAL.
  IF NOT Rpta THEN RETURN ERROR.
  X-NROLIS = lg-clistamarco.nrolis.
  L-COPIA  = YES.
  
  /* Dispatch standard ADM method.                             */
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */

  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY lg-clistamarco.FchVto @ lg-clistamarco.FchEmi
                           "" @ lg-clistamarco.FchVto.
     IF lg-clistamarco.FchVto = ? THEN DISPLAY TODAY @ lg-clistamarco.FchEmi.
     lg-clistamarco.CodPro:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
     /*Desactiva Lista Anterior*/
     FIND FIRST matpr WHERE matpr.codcia = s-codcia
         AND matpr.nrolis = lg-clistamarco.NroLis  NO-ERROR.
     IF AVAIL matpr THEN ASSIGN matpr.flgest = 'D'.
  END.
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

  IF lg-clistamarco.FlgEst <> "" THEN DO:
     MESSAGE "No puede Eliminar una lista Activa/Inactiva" VIEW-AS ALERT-BOX ERROR.
     RETURN ERROR.
  END.
  
  FOR EACH lg-dlistamarco 
      WHERE lg-dlistamarco.CodCia = lg-clistamarco.CodCia 
      AND lg-dlistamarco.nrolis = lg-clistamarco.nrolis:
      /*Actualiza Costo*/
      FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
          AND almmmatg.codmat = lg-dlistamarco.codmat NO-ERROR.
      IF AVAIL almmmatg THEN 
          ASSIGN 
          almmmatg.CtoLisMarco = 0
          almmmatg.CtoTotMarco = 0.
      DELETE lg-dlistamarco.
  END.


  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN Procesa-Handle IN lh_Handle ("Show").

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
  
  IF AVAILABLE lg-clistamarco THEN DO:
     FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA AND
          gn-prov.CodPro = lg-clistamarco.CodPro 
          NO-LOCK NO-ERROR.

     IF AVAILABLE gn-prov THEN
        DISPLAY gn-prov.NomPro @ FILL-IN_NomPro WITH FRAME {&FRAME-NAME}.
     ELSE DISPLAY "" @ FILL-IN_NomPro WITH FRAME {&FRAME-NAME}.
     
     FIND gn-ConCp WHERE gn-ConCp.Codig = lg-clistamarco.CndCmp NO-LOCK NO-ERROR.
     
     IF AVAILABLE gn-ConCp THEN
        DISPLAY gn-ConCp.Nombr @ F-DesCnd WITH FRAME {&FRAME-NAME}.
     ELSE DISPLAY "" @ F-DesCnd WITH FRAME {&FRAME-NAME}.
       CASE lg-clistamarco.FlgEst:
          WHEN "A" THEN DISPLAY "ACTIVO" @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN "D" THEN DISPLAY "DESACTIVADO" @ F-Estado WITH FRAME {&FRAME-NAME}.
          WHEN ""  THEN DISPLAY "PENDIENTE" @ F-Estado WITH FRAME {&FRAME-NAME}.
       END CASE.        
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN LGC\R-IMPLISMARCO (ROWID(lg-clistamarco)).

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
  
  /* Dispatch standard ADM method. */
   
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF L-COPIA THEN RUN Copia-Lista.
  ELSE RUN Actualiza-Lista.
  
  RUN get-attribute("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" THEN DO:  
     RUN Procesa-Handle IN lh_Handle ("view").
  END.
  ELSE RUN Procesa-Handle IN lh_Handle ("show").
  
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

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.
    

END PROCEDURE.


    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CASE HANDLE-CAMPO:name:
        WHEN "CndCmp" THEN ASSIGN input-var-1 = "" /*"20"*/.
    END CASE.

END PROCEDURE.


/*
Variables a usar:
input-var-1 como CHARACTER
input-var-2 como CHARACTER
input-var-3 como CHARACTER.
*/

/*
ASSIGN
input-para-1 = ""
input-para-2 = ""
input-para-3 = "".
*/

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
  {src/adm/template/snd-list.i "lg-clistamarco"}

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

  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
     IF NOT AVAILABLE lg-clistamarco THEN RETURN ERROR.
     IF AVAILABLE lg-clistamarco AND lg-clistamarco.FlgEst <> "" THEN DO:
        MESSAGE "No puede modificar una lista Activa/Inactiva" VIEW-AS ALERT-BOX ERROR.
        RETURN ERROR.
     END.
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
   IF lg-clistamarco.CodPro:SCREEN-VALUE  = "" THEN DO:
      MESSAGE "Codigo Proveedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO lg-clistamarco.CodPro.
      RETURN "ADM-ERROR".   
   END.
   IF INPUT lg-clistamarco.FchVig < INPUT lg-clistamarco.FchEmi THEN DO:
      MESSAGE "Fecha Activacion debe ser mayor fecha Emision" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO lg-clistamarco.FchVig.
      RETURN "ADM-ERROR". 
   END.
   IF NOT L-COPIA AND lg-clistamarco.FlgEst <> " " THEN DO:
      FIND FIRST MATPR WHERE MATPR.CodCia = S-CODCIA AND
           MATPR.CodPro = lg-clistamarco.CodPro:SCREEN-VALUE AND 
           MATPR.FlgEst = "A" NO-LOCK NO-ERROR.
      IF AVAILABLE MATPR AND ROWID(MATPR) <> ROWID(lg-clistamarco) THEN DO:
         MESSAGE "Ya existe una lista activa del proveedor" SKIP
                 FILL-IN_NomPro:SCREEN-VALUE SKIP
                 "copie la ultima lista activa" SKIP
                 "para generar una nueva" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO lg-clistamarco.CodPro.
         RETURN "ADM-ERROR".   
      END.
   END. 
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

