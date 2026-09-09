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
DEFINE BUFFER MATPR FOR LG-cmatpr.
DEFINE BUFFER DMATPR FOR LG-dmatpr.
DEFINE VAR X-NROLIS AS INTEGER NO-UNDO.
DEFINE VAR W-NROLIS AS INTEGER NO-UNDO.
DEFINE VAR L-COPIA  AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VAR F-PRECOS AS DECIMAL NO-UNDO.

DEFINE SHARED VAR lh_Handle AS HANDLE.

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
&Scoped-define EXTERNAL-TABLES LG-cmatpr
&Scoped-define FIRST-EXTERNAL-TABLE LG-cmatpr


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR LG-cmatpr.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS LG-cmatpr.CodMon LG-cmatpr.CodPro ~
LG-cmatpr.Dsctos[1] LG-cmatpr.CndCmp LG-cmatpr.aftigv LG-cmatpr.Dsctos[2] ~
LG-cmatpr.FchEmi LG-cmatpr.FchVig LG-cmatpr.Dsctos[3] 
&Scoped-define ENABLED-TABLES LG-cmatpr
&Scoped-define FIRST-ENABLED-TABLE LG-cmatpr
&Scoped-Define ENABLED-OBJECTS RECT-20 RECT-18 
&Scoped-Define DISPLAYED-FIELDS LG-cmatpr.nrolis LG-cmatpr.CodMon ~
LG-cmatpr.CodPro LG-cmatpr.Dsctos[1] LG-cmatpr.CndCmp LG-cmatpr.aftigv ~
LG-cmatpr.Dsctos[2] LG-cmatpr.FchEmi LG-cmatpr.FchVig LG-cmatpr.FchVto ~
LG-cmatpr.Dsctos[3] 
&Scoped-define DISPLAYED-TABLES LG-cmatpr
&Scoped-define FIRST-DISPLAYED-TABLE LG-cmatpr
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

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 13.29 BY .73.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87.14 BY 3.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     LG-cmatpr.nrolis AT ROW 1.12 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.14 BY .69
     F-Estado AT ROW 1.23 COL 71 COLON-ALIGNED NO-LABEL
     LG-cmatpr.CodMon AT ROW 1.27 COL 52.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 12 BY .5
     LG-cmatpr.CodPro AT ROW 1.88 COL 12 COLON-ALIGNED
          LABEL "Proveedor"
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .69
     FILL-IN_NomPro AT ROW 1.88 COL 23.14 COLON-ALIGNED HELP
          "Nombre del Proveedor" NO-LABEL
     LG-cmatpr.Dsctos[1] AT ROW 1.92 COL 79.29 COLON-ALIGNED FORMAT "ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     LG-cmatpr.CndCmp AT ROW 2.58 COL 12 COLON-ALIGNED FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .69
     F-DesCnd AT ROW 2.58 COL 23.14 COLON-ALIGNED NO-LABEL
     LG-cmatpr.aftigv AT ROW 2.62 COL 58
          VIEW-AS TOGGLE-BOX
          SIZE 12 BY .69
     LG-cmatpr.Dsctos[2] AT ROW 2.62 COL 79.29 COLON-ALIGNED FORMAT "ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     LG-cmatpr.FchEmi AT ROW 3.31 COL 12 COLON-ALIGNED
          LABEL "Fecha Emision" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     LG-cmatpr.FchVig AT ROW 3.31 COL 35.29 COLON-ALIGNED
          LABEL "Fecha Activacion" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     LG-cmatpr.FchVto AT ROW 3.31 COL 58.29 COLON-ALIGNED
          LABEL "F. Desactivado"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     LG-cmatpr.Dsctos[3] AT ROW 3.31 COL 79.29 COLON-ALIGNED FORMAT "ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 6 BY .69
     "Moneda" VIEW-AS TEXT
          SIZE 6.14 BY .5 AT ROW 1.31 COL 44.86
     RECT-20 AT ROW 1 COL 1
     RECT-18 AT ROW 1.12 COL 51.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.LG-cmatpr
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
         HEIGHT             = 3.27
         WIDTH              = 87.14.
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

/* SETTINGS FOR FILL-IN LG-cmatpr.CndCmp IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN LG-cmatpr.CodPro IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN LG-cmatpr.Dsctos[1] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN LG-cmatpr.Dsctos[2] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN LG-cmatpr.Dsctos[3] IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-DesCnd IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LG-cmatpr.FchEmi IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN LG-cmatpr.FchVig IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN LG-cmatpr.FchVto IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN_NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LG-cmatpr.nrolis IN FRAME F-Main
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

&Scoped-define SELF-NAME LG-cmatpr.CndCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-cmatpr.CndCmp V-table-Win
ON LEAVE OF LG-cmatpr.CndCmp IN FRAME F-Main /* Condicion */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND gn-ConVt WHERE gn-ConVt.Codig = LG-cmatpr.CndCmp:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF AVAILABLE gn-ConVt THEN
      DISPLAY gn-ConVt.Nombr @ F-DesCnd WITH FRAME {&FRAME-NAME}.
   ELSE DO:
        MESSAGE "Condicion de Compra no Registrado" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LG-cmatpr.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-cmatpr.CodPro V-table-Win
ON LEAVE OF LG-cmatpr.CodPro IN FRAME F-Main /* Proveedor */
DO:
/*   IF SELF:SCREEN-VALUE = "" THEN RETURN.*/
   FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA 
                AND gn-prov.CodPro = LG-cmatpr.CodPro:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
   
   IF AVAILABLE gn-prov THEN
      DISPLAY gn-prov.NomPro @ FILL-IN_NomPro WITH FRAME {&FRAME-NAME}.

   ELSE DO:
        MESSAGE "Proveedor" SELF:SCREEN-VALUE "no Registrado en el Maestro de Proveedores" skip
                "Consulte con la División de Logística o Sistemas" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
   END.
   
   FIND LG-CMATPR WHERE LG-CMATPR.Codcia = S-CODCIA 
                  AND LG-CMATPR.Codpro = LG-CMATPR.Codpro:SCREEN-VALUE
                  NO-LOCK NO-ERROR.

   IF AVAILABLE LG-CMATPR THEN DO:
        MESSAGE "Ya Existe Lista Activa para el Proveedor "  SKIP
                "           Utilice Lista  # " + STRING(LG-CMATPR.Nrolis)  VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LG-cmatpr.FchVig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-cmatpr.FchVig V-table-Win
ON LEAVE OF LG-cmatpr.FchVig IN FRAME F-Main /* Fecha Activacion */
DO:
  IF INPUT LG-cmatpr.FchVig < INPUT LG-cmatpr.FchEmi THEN DO:
      MESSAGE "Fecha Activacion debe ser mayor fecha Emision" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY. 
  END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LG-cmatpr.FchVto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-cmatpr.FchVto V-table-Win
ON LEAVE OF LG-cmatpr.FchVto IN FRAME F-Main /* F. Desactivado */
DO:
  IF INPUT LG-cmatpr.FchVto = ? THEN RETURN.
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
IF LG-cmatpr.FlgEst = "A" OR LG-cmatpr.FlgEst = "D" THEN DO:
   MESSAGE "No puede Activar una lista Activa/Desactivada" VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
   END.
      
/* Desactiva La Antigua Lista */
FIND LAST MATPR WHERE MATPR.CodCia = LG-cmatpr.CodCia 
                  AND MATPR.CodPro = LG-cmatpr.CodPro 
                  AND MATPR.FlgEst = "A" 
                  NO-ERROR.
                  
IF AVAILABLE MATPR THEN DO:
    w-nrolis = matpr.nrolis.
    ASSIGN MATPR.FlgEst = "D"
    MATPR.FchVto = TODAY.
END.    
  
FOR EACH dmatpr WHERE dmatpr.CodCia = LG-cmatpr.CodCia
                AND  dmatpr.nrolis = w-nrolis 
                AND  dmatpr.FlgEst = "A":
    ASSIGN
    dmatpr.flgest = "D".
    FIND almmmatg WHERE almmmatg.codcia = S-CODCIA 
                    AND almmmatg.codmat = dmatpr.codmat 
                    NO-ERROR.
    IF AVAILABLE almmmatg THEN DO:
        ASSIGN
            ALmmmatg.CodPr1     = "".
            ALmmmatg.ArtPro     = "".
            ALmmmatg.CodPr2     = dmatpr.CodPro.
        RELEASE Almmmatg.
    END.
END.    
  
/* Actualiza Cabecera Lista */
FIND MATPR WHERE MATPR.CodCia = LG-cmatpr.CodCia 
            AND  MATPR.nrolis = LG-cmatpr.nrolis 
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
FOR EACH LG-dmatpr WHERE LG-dmatpr.CodCia = LG-cmatpr.CodCia 
                    AND  LG-dmatpr.nrolis = LG-cmatpr.nrolis:
    ASSIGN 
    LG-dmatpr.flgest = "A".
                
    FIND almmmatg WHERE almmmatg.codcia = S-CODCIA 
                   AND  almmmatg.codmat = LG-dmatpr.codmat 
                   NO-ERROR.
 
    IF AVAILABLE almmmatg THEN DO:                                                               
        ASSIGN                                                                                    
            ALmmmatg.ArtPro     = LG-dmatpr.ArtPro                                                
            ALmmmatg.CodPr1     = LG-dmatpr.CodPro
            Almmmatg.FchmPre[2] = TODAY.
        RELEASE Almmmatg.
    END.
END.                                                                        


END PROCEDURE.

/*                      Almmmatg.dsctos[1]  = LG-dmatpr.Dsctos[1]                                             
 *                       Almmmatg.dsctos[2]  = LG-dmatpr.Dsctos[2]                                             
 *                       Almmmatg.dsctos[3]  = LG-dmatpr.Dsctos[3]
 *                       ALmmmatg.MonVta     = LG-dmatpr.CodMon                                                
 *                       Almmmatg.preant     = LG-dmatpr.PreAnt                                                
 *                       Almmmatg.preact     = LG-dmatpr.PreAct                                                
 *                       Almmmatg.CtoUnd     = LG-dmatpr.PreCos                                                
 *                       Almmmatg.CtoLis     = LG-dmatpr.PreCos                                                
 *                       Almmmatg.CtoTot     = LG-dmatpr.CtoTot.                                               */

/*                      Almmmatg.dsctos[1]  = LG-dmatpr.Dsctos[1]                                             
 *                       Almmmatg.dsctos[2]  = LG-dmatpr.Dsctos[2]                                             
 *                       Almmmatg.dsctos[3]  = LG-dmatpr.Dsctos[3]
 *                       /*ALmmmatg.MonVta     = LG-dmatpr.CodMon*/                                                
 *                       Almmmatg.preant     = LG-dmatpr.PreAnt * tpocmb                                               
 *                       Almmmatg.preact     = LG-dmatpr.PreAct * tpocmb                                                
 *                       Almmmatg.CtoUnd     = LG-dmatpr.PreCos * tpocmb                                                
 *                       Almmmatg.CtoLis     = LG-dmatpr.PreCos * tpocmb                                                
 *                       Almmmatg.CtoTot     = LG-dmatpr.CtoTot * tpocmb.                                               */

/*                      Almmmatg.dsctos[1]  = LG-dmatpr.Dsctos[1]                                             
 *                       Almmmatg.dsctos[2]  = LG-dmatpr.Dsctos[2]                                             
 *                       Almmmatg.dsctos[3]  = LG-dmatpr.Dsctos[3]
 *                       /*ALmmmatg.MonVta     = LG-dmatpr.CodMon*/                                                
 *                       Almmmatg.preant     = LG-dmatpr.PreAnt / tpocmb                                               
 *                       Almmmatg.preact     = LG-dmatpr.PreAct / tpocmb                                                
 *                       Almmmatg.CtoUnd     = LG-dmatpr.PreCos / tpocmb                                                
 *                       Almmmatg.CtoLis     = LG-dmatpr.PreCos / tpocmb                                                
 *                       Almmmatg.CtoTot     = LG-dmatpr.CtoTot / tpocmb.                                               */

                  /*IF Almmmatg.Pesmat > 0 THEN                                                             
 *                      ASSIGN                                                                                 
 *                          Almmmatg.CtoUnd  = ROUND(LG-dmatpr.PreCos / 1000 * Almmmatg.pesmat, 2).*/          

                  /*IF Almmmatg.Pesmat > 0 THEN                                                             
 *                      ASSIGN                                                                                 
 *                          Almmmatg.CtoUnd  = ROUND(LG-dmatpr.PreCos / 1000 * Almmmatg.pesmat, 2).*/          

                  /*IF Almmmatg.Pesmat > 0 THEN                                                             
 *                      ASSIGN                                                                                 
 *                          Almmmatg.CtoUnd  = ROUND(LG-dmatpr.PreCos / 1000 * Almmmatg.pesmat, 2).*/          

/* MATPR.FchAct = TODAY. */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Lista V-table-Win 
PROCEDURE Actualiza-Lista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH LG-dmatpr WHERE LG-dmatpr.CodCia = LG-cmatpr.CodCia AND
                         LG-dmatpr.nrolis = LG-cmatpr.nrolis:
    ASSIGN LG-dmatpr.codpro = LG-cmatpr.codpro
    LG-dmatpr.FchEmi = LG-cmatpr.FchEmi
    LG-dmatpr.FchVto = LG-cmatpr.FchVto
    LG-dmatpr.FlgEst = LG-cmatpr.FlgEst
    LG-dmatpr.Dsctos[1] = LG-cmatpr.Dsctos[1] 
    LG-dmatpr.Dsctos[2] = LG-cmatpr.Dsctos[2] 
    LG-dmatpr.Dsctos[3] = LG-cmatpr.Dsctos[3].
    LG-dmatpr.PreCos = f-precos.
    F-PRECOS = ROUND(LG-dmatpr.PreAct * 
             (1 - (LG-dmatpr.Dsctos[1] / 100)) *
             (1 - (LG-dmatpr.Dsctos[2] / 100)) *
             (1 - (LG-dmatpr.Dsctos[3] / 100)) , 4).
    END.
 
END PROCEDURE.




/*   FIND LAST LG-CFGIGV NO-LOCK NO-ERROR.
        IF AVAILABLE LG-CFGIGV AND LG-cmatpr.aftigv THEN 
            LG-dmatpr.IgvMat = LG-CFGIGV.PorIgv.
      ELSE  LG-dmatpr.IgvMat = 0.  */

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
  {src/adm/template/row-list.i "LG-cmatpr"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "LG-cmatpr"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asignar-Articulos V-table-Win 
PROCEDURE Asignar-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF LG-cmatpr.FlgEst <> " " THEN RETURN ERROR.
IF AVAILABLE LG-cmatpr THEN
    RUN LGC\C-MATPRO.R ("ASIGNACION DE ARTICULOS POR PROVEEDOR",LG-cmatpr.nrolis).
END PROCEDURE.



/* FOR EACH LG-dmatpr WHERE LG-dmatpr.CodCia = LG-cmatpr.CodCia AND
           LG-dmatpr.nrolis = LG-cmatpr.nrolis:
      FIND Almmmatg WHERE Almmmatg.CodCia = LG-dmatpr.CodCia AND
           Almmmatg.codmat = LG-dmatpr.codmat NO-ERROR.
      IF AVAILABLE Almmmatg THEN DO:
         ASSIGN Almmmatg.CodPr1 = LG-cmatpr.CodPro
                Almmmatg.MonVta = LG-cmatpr.CodMon
                Almmmatg.AftIgv = (LG-dmatpr.IgvMat > 0)  
                Almmmatg.ArtPro = LG-dmatpr.ArtPro.  
      END.  
      RELEASE Almmmatg.
  END. */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Copia-Lista V-table-Win 
PROCEDURE Copia-Lista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH LG-dmatpr 
    WHERE LG-dmatpr.CodCia = LG-cmatpr.CodCia 
    AND LG-dmatpr.nrolis = X-NROLIS:
    CREATE DMATPR.
    ASSIGN DMATPR.CodCia = LG-cmatpr.CodCia
        DMATPR.nrolis    = LG-cmatpr.nrolis
        DMATPR.codpro    = LG-cmatpr.codpro
        DMATPR.FchEmi    = LG-cmatpr.FchEmi
        DMATPR.FchVto    = LG-cmatpr.FchVto
        DMATPR.FlgEst    = LG-cmatpr.FlgEst
        DMATPR.Dsctos[1] = LG-dmatpr.Dsctos[1]
        DMATPR.Dsctos[2] = LG-dmatpr.Dsctos[2] 
        DMATPR.Dsctos[3] = LG-dmatpr.Dsctos[3]
        DMATPR.IgvMat    = LG-dmatpr.IgvMat
        DMATPR.CodMon    = LG-dmatpr.CodMon
        DMATPR.ArtPro    = LG-dmatpr.ArtPro 
        DMATPR.codmat    = LG-dmatpr.codmat 
        DMATPR.desmat    = LG-dmatpr.desmat 
        DMATPR.PreAct    = LG-dmatpr.PreAct 
        DMATPR.PreAnt    = LG-dmatpr.PreAct 
        DMATPR.PreCos    = LG-dmatpr.PreCos
        DMATPR.tpobien   = LG-dmatpr.tpobien.
    END.
    L-COPIA = NO.

    RELEASE MATPR.
END PROCEDURE.




   /*   FIND LAST LG-CFGIGV NO-LOCK NO-ERROR.
        IF AVAILABLE LG-CFGIGV AND LG-cmatpr.aftigv THEN 
            DMATPR.IgvMat = LG-CFGIGV.PorIgv.
        ELSE  DMATPR.IgvMat = 0.   */


  /* Desactiva Lista Anterior
  FIND MATPR WHERE MATPR.CodCia = LG-cmatpr.CodCia AND
       MATPR.nrolis = X-NROLIS NO-ERROR.
  IF AVAILABLE MATPR THEN DO TRANSACTION:
     ASSIGN MATPR.FlgEst = "I"
            MATPR.FchVto = TODAY.
     FOR EACH LG-dmatpr WHERE LG-dmatpr.CodCia = MATPR.CodCia AND
              LG-dmatpr.nrolis = MATPR.nrolis:
         ASSIGN LG-dmatpr.FchVto = MATPR.FchVto
                LG-dmatpr.FlgEst = MATPR.FlgEst.
     END.
  END.
  
  */

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
     DISPLAY TODAY @ LG-cmatpr.FchEmi.
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
    LG-cmatpr.CodCia = S-CodCia
    LG-cmatpr.NroLis = X-NRO.
    END.

IF LG-cmatpr.FchVto = ? THEN LG-cmatpr.FlgEst = "".
    ELSE DO:
    IF LG-cmatpr.FchEmi <= TODAY AND LG-cmatpr.FchVto > TODAY THEN
    ASSIGN LG-cmatpr.FlgEst = " ".
    ELSE ASSIGN LG-cmatpr.FlgEst = " ".
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
  
  IF LG-cmatpr.FlgEst = "D" THEN DO:
     MESSAGE "No Puede Copiar Lista Desactivada" VIEW-AS ALERT-BOX ERROR.
     RETURN ERROR.
  END.
  MESSAGE "Se Generara Nueva Lista Actual, " 
          VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO
          UPDATE Rpta AS LOGICAL.
  IF NOT Rpta THEN RETURN ERROR.
  X-NROLIS = LG-cmatpr.nrolis.
  L-COPIA  = YES.
  
  /* Dispatch standard ADM method.                             */
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY LG-cmatpr.FchVto @ LG-cmatpr.FchEmi
                           "" @ LG-cmatpr.FchVto.
     IF LG-cmatpr.FchVto = ? THEN DISPLAY TODAY @ LG-cmatpr.FchEmi.
     LG-cmatpr.CodPro:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
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

  IF LG-cmatpr.FlgEst <> "" THEN DO:
     MESSAGE "No puede Eliminar una lista Activa/Inactiva" VIEW-AS ALERT-BOX ERROR.
     RETURN ERROR.
  END.
  
  FOR EACH LG-dmatpr 
      WHERE LG-dmatpr.CodCia = LG-cmatpr.CodCia 
      AND LG-dmatpr.nrolis = LG-cmatpr.nrolis:
      /*Actualiza Costo*/
      FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia
          AND almmmatg.codmat = lg-dmatpr.codmat NO-ERROR.
      IF AVAIL almmmatg THEN ASSIGN almmmatg.ctolis = 0.
      DELETE LG-dmatpr.
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
  
  IF AVAILABLE LG-cmatpr THEN DO:
     FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA AND
          gn-prov.CodPro = LG-cmatpr.CodPro 
          NO-LOCK NO-ERROR.

     IF AVAILABLE gn-prov THEN
        DISPLAY gn-prov.NomPro @ FILL-IN_NomPro WITH FRAME {&FRAME-NAME}.
     ELSE DISPLAY "" @ FILL-IN_NomPro WITH FRAME {&FRAME-NAME}.
     
     FIND gn-ConVt WHERE gn-ConVt.Codig = LG-cmatpr.CndCmp NO-LOCK NO-ERROR.
     
     IF AVAILABLE gn-ConVt THEN
        DISPLAY gn-ConVt.Nombr @ F-DesCnd WITH FRAME {&FRAME-NAME}.
     ELSE DISPLAY "" @ F-DesCnd WITH FRAME {&FRAME-NAME}.
       CASE LG-cmatpr.FlgEst:
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

/*  IF LG-cmatpr.FlgEst <> "A" THEN RUN LGC\R-IMPLIS.R(ROWID(LG-cmatpr)).*/
  RUN LGC\R-IMPLIS.R(ROWID(LG-cmatpr)).
  MESSAGE "IMPRESION FINALIZADA" VIEW-AS ALERT-BOX MESSAGE.
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
  {src/adm/template/snd-list.i "LG-cmatpr"}

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
     IF NOT AVAILABLE LG-cmatpr THEN RETURN ERROR.
     IF AVAILABLE LG-cmatpr AND LG-cmatpr.FlgEst <> "" THEN DO:
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
   IF LG-cmatpr.CodPro:SCREEN-VALUE  = "" THEN DO:
      MESSAGE "Codigo Proveedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO LG-cmatpr.CodPro.
      RETURN "ADM-ERROR".   
   END.
   IF INPUT LG-cmatpr.FchVig < INPUT LG-cmatpr.FchEmi THEN DO:
      MESSAGE "Fecha Activacion debe ser mayor fecha Emision" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO LG-cmatpr.FchVig.
      RETURN "ADM-ERROR". 
   END.
   IF NOT L-COPIA AND LG-cmatpr.FlgEst <> " " THEN DO:
   
      FIND FIRST MATPR WHERE MATPR.CodCia = S-CODCIA AND
           MATPR.CodPro = LG-cmatpr.CodPro:SCREEN-VALUE AND 
           MATPR.FlgEst = "A" NO-LOCK NO-ERROR.
      IF AVAILABLE MATPR AND ROWID(MATPR) <> ROWID(LG-cmatpr) THEN DO:
         MESSAGE "Ya existe una lista activa del proveedor" SKIP
                 FILL-IN_NomPro:SCREEN-VALUE SKIP
                 "copie la ultima lista activa" SKIP
                 "para generar una nueva" VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO LG-cmatpr.CodPro.
         RETURN "ADM-ERROR".   
      END.
   END. 
END.
RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

