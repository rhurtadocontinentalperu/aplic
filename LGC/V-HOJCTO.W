&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI ADM1
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
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE PV-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE S-PROVEE  AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB  AS DECIMAL.
DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
DEFINE SHARED VARIABLE S-MARCA   AS CHAR.

DEFINE VARIABLE L-CREA   AS LOGICAL NO-UNDO.
DEFINE VARIABLE I-NROREQ AS INTEGER NO-UNDO.

DEFINE SHARED VAR lh_Handle AS HANDLE.

DEFINE SHARED TEMP-TABLE DCMP LIKE LG-DOCmp.
DEFINE BUFFER CCMP FOR LG-COCmp.

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
&Scoped-define EXTERNAL-TABLES LG-COCmp
&Scoped-define FIRST-EXTERNAL-TABLE LG-COCmp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR LG-COCmp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS LG-COCmp.CndCmp LG-COCmp.MonPro ~
LG-COCmp.TpoCmbP LG-COCmp.Observaciones LG-COCmp.ImpFle 
&Scoped-define ENABLED-TABLES LG-COCmp
&Scoped-define FIRST-ENABLED-TABLE LG-COCmp
&Scoped-Define ENABLED-OBJECTS RECT-24 RECT-27 RECT-25 
&Scoped-Define DISPLAYED-FIELDS LG-COCmp.Fchdoc LG-COCmp.NroDoc ~
LG-COCmp.FchEnt LG-COCmp.NroRef LG-COCmp.FchAte LG-COCmp.CodPro ~
LG-COCmp.TpoCmb LG-COCmp.CndCmp LG-COCmp.MonPro LG-COCmp.CodMar ~
LG-COCmp.TpoCmbP LG-COCmp.Observaciones LG-COCmp.ImpFle 
&Scoped-define DISPLAYED-TABLES LG-COCmp
&Scoped-define FIRST-DISPLAYED-TABLE LG-COCmp
&Scoped-Define DISPLAYED-OBJECTS F-SitDoc F-NomPro F-ConPro F-RucPro ~
F-DesCnd F-Desmon F-DesMar 

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
DEFINE VARIABLE F-ConPro AS CHARACTER FORMAT "X(256)":U 
     LABEL "Atencion" 
     VIEW-AS FILL-IN 
     SIZE 27.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesCnd AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.72 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesMar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .69 NO-UNDO.

DEFINE VARIABLE F-Desmon AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .69 NO-UNDO.

DEFINE VARIABLE F-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.72 BY .69 NO-UNDO.

DEFINE VARIABLE F-RucPro AS CHARACTER FORMAT "X(256)":U 
     LABEL "R.U.C." 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-SitDoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situacion" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .69
     FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83.14 BY 6.65.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 24.72 BY 1.19.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 24.72 BY 2.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     LG-COCmp.Fchdoc AT ROW 1.15 COL 69.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     LG-COCmp.NroDoc AT ROW 1.19 COL 11.57 COLON-ALIGNED
          LABEL "No. Importacion"
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .69
     F-SitDoc AT ROW 1.23 COL 36.14 COLON-ALIGNED
     LG-COCmp.FchEnt AT ROW 1.85 COL 69.57 COLON-ALIGNED
          LABEL "Fecha Aceptacion"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     LG-COCmp.NroRef AT ROW 1.92 COL 11.57 COLON-ALIGNED
          LABEL "Nro.Proforma"
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .69
     LG-COCmp.FchAte AT ROW 2.54 COL 69.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     LG-COCmp.CodPro AT ROW 2.73 COL 11.57 COLON-ALIGNED
          LABEL "Exportador" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     F-NomPro AT ROW 2.73 COL 20.57 COLON-ALIGNED NO-LABEL
     LG-COCmp.TpoCmb AT ROW 3.23 COL 69.57 COLON-ALIGNED
          LABEL "Tip.Cmb. Local" FORMAT "ZZ9.9999"
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .69
     F-ConPro AT ROW 3.42 COL 11.57 COLON-ALIGNED
     F-RucPro AT ROW 3.42 COL 45.29 COLON-ALIGNED
     LG-COCmp.CndCmp AT ROW 4.12 COL 11.57 COLON-ALIGNED
          LABEL "Forma de Pago" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .69
     F-DesCnd AT ROW 4.12 COL 17.43 COLON-ALIGNED NO-LABEL
     LG-COCmp.MonPro AT ROW 4.69 COL 65.29 COLON-ALIGNED
          LABEL "Moneda"
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .69
     F-Desmon AT ROW 4.69 COL 69.14 COLON-ALIGNED NO-LABEL
     LG-COCmp.CodMar AT ROW 4.85 COL 11.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.86 BY .69
     F-DesMar AT ROW 4.88 COL 19.14 COLON-ALIGNED NO-LABEL
     LG-COCmp.TpoCmbP AT ROW 5.38 COL 65.29 COLON-ALIGNED
          LABEL "Tpo.Cmb."
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .69
     LG-COCmp.Observaciones AT ROW 5.62 COL 11.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 43.86 BY .69
     LG-COCmp.ImpFle AT ROW 6.5 COL 68.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .81
     " Procedencia" VIEW-AS TEXT
          SIZE 9.72 BY .5 AT ROW 4.04 COL 59.72
          BGCOLOR 1 FGCOLOR 15 
     "TIPO PRECIO :  ( ) -> Precio Fob   (F) -> Precio Costo Flete" VIEW-AS TEXT
          SIZE 41.43 BY .5 AT ROW 7 COL 2.14
     RECT-24 AT ROW 1 COL 1
     RECT-27 AT ROW 4.27 COL 58.72
     RECT-25 AT ROW 6.31 COL 58.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.LG-COCmp
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
         HEIGHT             = 6.81
         WIDTH              = 83.43.
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

/* SETTINGS FOR FILL-IN LG-COCmp.CndCmp IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN LG-COCmp.CodMar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LG-COCmp.CodPro IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN F-ConPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesCnd IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesMar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Desmon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-RucPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-SitDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LG-COCmp.FchAte IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LG-COCmp.Fchdoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LG-COCmp.FchEnt IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN LG-COCmp.MonPro IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN LG-COCmp.NroDoc IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN LG-COCmp.NroRef IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN LG-COCmp.TpoCmb IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN LG-COCmp.TpoCmbP IN FRAME F-Main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME LG-COCmp.CndCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-COCmp.CndCmp V-table-Win
ON LEAVE OF LG-COCmp.CndCmp IN FRAME F-Main /* Forma de Pago */
DO:
  IF LG-COCmp.CndCmp:SCREEN-VALUE <> "" THEN DO:
     F-DesCnd:SCREEN-VALUE = "".
     FIND gn-convt WHERE gn-convt.Codig = LG-COCmp.CndCmp:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN F-DesCnd:SCREEN-VALUE = gn-convt.Nombr.
        DISPLAY gn-convt.Nombr @ F-DesCnd WITH FRAME {&FRAME-NAME}.
  END.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LG-COCmp.CodMar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-COCmp.CodMar V-table-Win
ON LEAVE OF LG-COCmp.CodMar IN FRAME F-Main /* Marca */
DO:
  DO WITH FRAME {&FRAME-NAME}:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
     FIND almtabla WHERE almtabla.Tabla = "MK" AND
          almtabla.Codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE almtabla THEN 
        DISPLAY almtabla.Nombre @ F-DesMar WITH FRAME {&FRAME-NAME}.
  ELSE DO:
     MESSAGE "Codigo de Marca no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
  S-MARCA = SELF:SCREEN-VALUE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LG-COCmp.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-COCmp.CodPro V-table-Win
ON LEAVE OF LG-COCmp.CodPro IN FRAME F-Main /* Exportador */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA AND
        gn-prov.CodPro = LG-Cocmp.CodPro:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF AVAILABLE gn-prov THEN DO:
      IF gn-prov.TpoPro = 'E' THEN DO:
         MESSAGE 'El Proveedor no se encuentra asignado como del Exterior'
                 VIEW-AS ALERT-BOX ERROR.
         APPLY 'ENTRY':U TO SELF.
         RETURN NO-APPLY.
      END.
      DISPLAY gn-prov.NomPro @ F-NomPro
              gn-prov.Contactos[2] @ F-ConPro
              gn-prov.NomPro       @ F-NomPro
              gn-prov.Ruc          @ F-RucPro WITH FRAME {&FRAME-NAME}.
      END.
   ELSE DO:
        MESSAGE "Proveedor no Registrado" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
   END.
   S-PROVEE = LG-Cocmp.CodPro:SCREEN-VALUE.
   assign F-NomPro = gn-prov.NomPro.
   APPLY "ENTRY":U TO LG-COCmp.Fchdoc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LG-COCmp.Fchdoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-COCmp.Fchdoc V-table-Win
ON LEAVE OF LG-COCmp.Fchdoc IN FRAME F-Main /* Fecha Emision */
DO:
  IF INPUT LG-COCmp.Fchdoc = ? THEN RETURN.
  FIND gn-tcmb WHERE gn-tcmb.FECHA = INPUT LG-COCmp.Fchdoc NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN DO:
     DISPLAY gn-tcmb.compra @ LG-COCmp.TpoCmb WITH FRAME {&FRAME-NAME}.
     S-TPOCMB = gn-tcmb.compra.
  END.
  ELSE MESSAGE "Tipo de cambio no registrado" VIEW-AS ALERT-BOX WARNING.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LG-COCmp.MonPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-COCmp.MonPro V-table-Win
ON LEAVE OF LG-COCmp.MonPro IN FRAME F-Main /* Moneda */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
     FIND almtabla WHERE almtabla.Tabla = "MO" AND
          almtabla.Codigo = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE almtabla THEN 
        DISPLAY almtabla.Nombre @ F-Desmon WITH FRAME {&FRAME-NAME}.
   ELSE DO:
      MESSAGE "Codigo de Moneda del Exterior no Existe" VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO SELF.
      RETURN NO-APPLY.
   END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LG-COCmp.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-COCmp.TpoCmb V-table-Win
ON LEAVE OF LG-COCmp.TpoCmb IN FRAME F-Main /* Tip.Cmb. Local */
DO:
  S-TPOCMB = DECIMAL(SELF:SCREEN-VALUE).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-DCMP V-table-Win 
PROCEDURE Actualiza-DCMP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER I-EST AS INTEGER.
FOR EACH DCMP:
    DELETE DCMP.
END.
IF I-EST = 2 THEN DO:
   IF AVAILABLE LG-COCmp THEN 
     FOR EACH LG-DOCmp WHERE LG-DOCmp.CodCia = LG-COCmp.CodCia AND 
         LG-DOCmp.TpoDoc = LG-COCmp.TpoDoc AND
         LG-DOCmp.NroDoc = LG-COCmp.NroDoc:
         CREATE DCMP.
         ASSIGN DCMP.CodCia = LG-DOCmp.CodCia 
                DCMP.TpoDoc = LG-DOCmp.TpoDoc 
                DCMP.NroDoc = LG-DOCmp.NroDoc 
                DCMP.Codmat = LG-DOCmp.Codmat 
                DCMP.ArtPro = LG-DOCmp.ArtPro 
                DCMP.UndCmp = LG-DOCmp.UndCmp
                DCMP.CanPedi = LG-DOCmp.CanPedi 
                DCMP.ImpTot = LG-DOCmp.ImpTot 
                DCMP.PreFob = LG-DOCmp.PreFob
                DCMP.tpobien = LG-DOCmp.tpobien.
        /* GRABAMOS EL CODIGO DE MONEDA EN LG-DOCmp.CanAten */
        DCmp.CanAten = LG-COCmp.Codmon.
     END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Detalle-Requisicion V-table-Win 
PROCEDURE Actualiza-Detalle-Requisicion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER I-FAC AS INTEGER.
   FOR EACH LG-DOCmp NO-LOCK WHERE LG-DOCmp.CodCia = LG-COCmp.CodCia AND 
       LG-DOCmp.TpoDoc = LG-COCmp.TpoDoc AND
       LG-DOCmp.NroDoc = LG-COCmp.NroDoc:
       FIND LG-DRequ WHERE LG-DRequ.CodCia = LG-DOCmp.CodCia AND
            LG-DRequ.NroReq = LG-COCmp.NroReq AND
            LG-DRequ.Codmat = LG-DOCmp.CodMat NO-ERROR.
       IF AVAILABLE LG-DRequ THEN DO:
          ASSIGN LG-DRequ.CanAten = LG-DRequ.CanAten + (I-FAC * LG-DOCmp.CanPedi ).
       END.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Estado-Requisicion V-table-Win 
PROCEDURE Actualiza-Estado-Requisicion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VAR I-Nro AS INTEGER NO-UNDO.
   FOR EACH LG-DRequ WHERE 
            LG-DRequ.CodCia = LG-COCmp.CodCia AND
            LG-CRequ.TpoReq = "N" AND
            LG-DRequ.NroReq = LG-COCmp.NroReq:
       IF (LG-DRequ.CanApro - LG-DRequ.CanAten) > 0 THEN DO:
          I-NRO = 1.
          LEAVE.
       END.
   END.
   FIND LG-CRequ WHERE LG-CRequ.CodCia = LG-COCmp.CodCia AND
        LG-CRequ.TpoReq = "N" AND
        LG-CRequ.NroReq = LG-COCmp.NroReq NO-ERROR.
   IF AVAILABLE LG-CRequ THEN DO:
      IF I-NRO = 0 THEN ASSIGN LG-CRequ.FlgSit = "C".
      ELSE ASSIGN LG-CRequ.FlgSit = "P".
   END.
   RELEASE LG-CRequ.

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
  {src/adm/template/row-list.i "LG-COCmp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "LG-COCmp"}

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
   FOR EACH LG-DOCmp WHERE LG-DOCmp.CodCia = LG-COCmp.CodCia AND 
       LG-DOCmp.TpoDoc = LG-COCmp.TpoDoc AND
       LG-DOCmp.NroDoc = LG-COCmp.NroDoc:
       DELETE LG-DOCmp.
   END.
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
   FOR EACH DCMP:
        CREATE LG-DOCmp.
        ASSIGN LG-DOCmp.CodCia = LG-COCmp.CodCia 
               LG-DOCmp.TpoDoc = LG-COCmp.TpoDoc 
               LG-DOCmp.NroDoc = LG-COCmp.NroDoc 
               LG-DOCmp.Codmat = DCMP.Codmat 
               LG-DOCmp.ArtPro = DCMP.ArtPro 
               LG-DOCmp.UndCmp = DCMP.UndCmp
               LG-DOCmp.CanPedi = DCMP.CanPedi 
               LG-DOCmp.ImpTot = DCMP.ImpTot 
               LG-DOCmp.PreFob = DCMP.PreFob
               LG-DOCmp.tpobien = DCMP.tpobien.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  RUN Actualiza-DCMP (2).
  RUN Procesa-Handle IN lh_Handle ("Pagina2").
  RUN Procesa-Handle IN lh_Handle ('Browse-add').
  
  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY     @ LG-COCmp.Fchdoc. 
     FIND gn-tcmb WHERE gn-tcmb.FECHA = TODAY NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN DO:
        DISPLAY gn-tcmb.compra @ LG-COCmp.TpoCmb.
        S-TPOCMB = gn-tcmb.compra.
     END.
     S-CODMON = 1.
  END.
  I-NROREQ = 0.
  S-PROVEE = "".
  L-CREA = YES.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE X-NRODOC AS INTEGER NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  RUN get-attribute("ADM-NEW-RECORD").
  IF RETURN-VALUE = "YES" THEN DO:
     FIND LG-CORR WHERE LG-CORR.CodCia = S-CODCIA AND
          LG-CORR.CodDoc = "O/I" NO-ERROR.
     X-NRODOC = LG-CORR.NroDoc.
     ASSIGN LG-CORR.NroDoc = LG-CORR.NroDoc + 1.
     RELEASE LG-CORR.
     ASSIGN LG-COCmp.CodCia = S-CODCIA
            LG-COCmp.TpoDoc = "I"
            LG-COCmp.NroDoc = X-NRODOC
            LG-COCmp.FlgSit = "G"
            LG-COCmp.Userid-com = S-USER-ID.
  END.
  ASSIGN LG-COCmp.ImpTot = 0
         LG-COCmp.ImpExo = 0
         LG-COCmp.NomPro = F-NomPro.
  FOR EACH DCMP NO-LOCK:
      LG-COCmp.ImpTot = LG-COCmp.ImpTot + DCMP.ImpTot.
  END.
  ASSIGN LG-COCmp.ImpBrt = LG-COCmp.ImpTot
         LG-COCmp.ImpNet = LG-COCmp.ImpTot.
  
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
  
  RUN Procesa-Handle IN lh_Handle ("Pagina1").

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
  IF LG-COCmp.FlgSit <> "G"  THEN DO:
     MESSAGE "La Orden de Compra no puede se anulada" SKIP
              "se encuentra " ENTRY(LOOKUP(LG-COCmp.FlgSit,"P,A,T"),"atendida parcialmente,Anulada,totalmente atendida")
              VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  IF AVAILABLE LG-COCmp AND (LOOKUP(LG-COCmp.FlgSit,"A,T,P") = 0) THEN DO:
     FIND CCMP WHERE CCMP.CodCia = LG-COCmp.CodCia AND 
          CCMP.TpoDoc = LG-COCmp.TpoDoc AND
          CCMP.NroDoc = LG-COCmp.NroDoc NO-ERROR.
     IF AVAILABLE CCMP THEN DO:
        ASSIGN CCMP.FlgSit = "A"
               CCMP.Userid-com = S-USER-ID.
/*        RUN Actualiza-Detalle-Requisicion(-1).*/
        RUN Borra-Detalle.
/*        FIND LG-CRequ WHERE LG-CRequ.CodCia = LG-COCmp.CodCia AND
             LG-CRequ.TpoReq = "N" AND
             LG-CRequ.NroReq = LG-COCmp.NroReq NO-ERROR.
        IF AVAILABLE LG-CRequ THEN ASSIGN LG-CRequ.FlgSit = "P".
        RELEASE LG-CRequ.*/
     END.
     RELEASE CCMP.
  END.
  /* Dispatch standard ADM method.                             */
  /*  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ).  */
  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_Handle ('Browse').


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
  
  IF AVAILABLE LG-COCmp THEN DO WITH FRAME {&FRAME-NAME}:
     FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA AND 
          gn-prov.CodPro = LG-COCmp.CodPro NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN 
        DISPLAY gn-prov.Contactos[1] @ F-ConPro
                gn-prov.NomPro       @ F-NomPro
                gn-prov.Ruc          @ F-RucPro.
     FIND gn-convt WHERE gn-convt.Codig = LG-COCmp.CndCmp NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN 
        DISPLAY gn-convt.Nombr @ F-DesCnd.           
     I-NROREQ = LG-COCmp.NroReq.
     S-PROVEE = LG-COCmp.CodPro.
     FIND almtabla WHERE almtabla.Tabla = "MK" AND
          almtabla.Codigo = LG-COCmp.Codmar NO-LOCK NO-ERROR.
     IF AVAILABLE almtabla THEN 
        DISPLAY almtabla.Nombre @ F-DesMar.
     FIND almtabla WHERE almtabla.Tabla = "MO" AND
          almtabla.Codigo = STRING(LG-COCmp.MonPro, '99') NO-LOCK NO-ERROR.
     IF AVAILABLE almtabla THEN 
        DISPLAY almtabla.Nombre @ F-DesMon.
     IF LOOKUP(LG-COCmp.FlgSit,"G,P,A,T") > 0 THEN
        F-SitDoc:SCREEN-VALUE = ENTRY(LOOKUP(LG-COCmp.FlgSit,"G,P,A,T"),"EMITIDA,PENDIENTE,ANULADO,ATEN.TOTAL").
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
  
  IF LG-COCmp.FlgSit <> "A" THEN RUN lgc\r-impcmp(ROWID(LG-COCmp)).
  
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
  
  IF NOT L-CREA THEN DO:
/*     RUN Actualiza-Detalle-Requisicion(-1).*/
     RUN Borra-Detalle.
  END.
  RUN Genera-Orden-Compra.
/*  RUN Actualiza-Detalle-Requisicion(1).*/
/*  RUN Actualiza-Estado-Requisicion.*/
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

    CASE HANDLE-CAMPO:name:
        WHEN "CndCmp" THEN ASSIGN input-var-1 = "20".
        WHEN "CodMar" THEN ASSIGN input-var-1 = "MK".
        WHEN "MonPro" THEN ASSIGN input-var-1 = "MO".
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
  {src/adm/template/snd-list.i "LG-COCmp"}

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

  IF p-state = 'update-begin':U AND NOT AVAILABLE LG-COCmp THEN RETURN ERROR.
  IF p-state = 'update-begin':U AND LG-COCmp.FlgSit <> "G" THEN RETURN ERROR.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
     RUN Actualiza-DCMP (2).
     RUN Procesa-Handle IN lh_Handle ("Pagina2").
     RUN Procesa-Handle IN lh_Handle ('Browse').
     S-TPOCMB = LG-COCmp.TpoCmb.
     L-CREA = NO.
     S-CODMON = LG-COCmp.Codmon.
     S-MARCA  = LG-COCmp.CodMar.
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
DO WITH FRAME {&FRAME-NAME} :
   /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CAMPO.
         RETURN "ADM-ERROR".   
   
      END.
   */
  ASSIGN F-NomPro.
END.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

