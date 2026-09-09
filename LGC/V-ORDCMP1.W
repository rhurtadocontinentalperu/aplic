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
DEFINE SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE PV-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-PROVEE  AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB  AS DECIMAL.
DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.

DEFINE VARIABLE L-CREA   AS LOGICAL NO-UNDO.
DEFINE VARIABLE I-NROREQ AS INTEGER NO-UNDO.
DEFINE VARIABLE X-NRODOC AS INTEGER NO-UNDO.

DEFINE SHARED VAR lh_Handle AS HANDLE.

DEFINE SHARED TEMP-TABLE DCMP LIKE LG-DOCmp.
DEFINE BUFFER CCMP FOR LG-COCmp.
DEFINE BUFFER b-lgcocmp FOR LG-COCmp.


DEFINE VARIABLE F-FACTOR     AS DECIMAL   NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS LG-COCmp.UsoInt LG-COCmp.CodPro ~
LG-COCmp.CndCmp LG-COCmp.Observaciones LG-COCmp.CodAlm LG-COCmp.Fchdoc ~
LG-COCmp.FchEnt LG-COCmp.FchVto LG-COCmp.TpoCmb LG-COCmp.ModAdq ~
LG-COCmp.NroDoc LG-COCmp.Codmon 
&Scoped-define ENABLED-TABLES LG-COCmp
&Scoped-define FIRST-ENABLED-TABLE LG-COCmp
&Scoped-Define ENABLED-OBJECTS RECT-24 RECT-25 
&Scoped-Define DISPLAYED-FIELDS LG-COCmp.UsoInt LG-COCmp.CodPro ~
LG-COCmp.CndCmp LG-COCmp.Observaciones LG-COCmp.CodAlm LG-COCmp.Fchdoc ~
LG-COCmp.FchEnt LG-COCmp.FchVto LG-COCmp.TpoCmb LG-COCmp.ModAdq ~
LG-COCmp.SerReq LG-COCmp.NroDoc LG-COCmp.Codmon LG-COCmp.NomPro ~
LG-COCmp.NroReq 
&Scoped-define DISPLAYED-TABLES LG-COCmp
&Scoped-define FIRST-DISPLAYED-TABLE LG-COCmp
&Scoped-Define DISPLAYED-OBJECTS F-modalidad F-HorRec F-DesCnd F-DirEnt ~
F-RucPro F-SitDoc F-Contacto F-TlfAlm 

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
DEFINE VARIABLE F-Contacto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Contacto" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesCnd AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-DirEnt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-HorRec AS CHARACTER FORMAT "X(256)":U 
     LABEL "Horario de Recepcion" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .69 NO-UNDO.

DEFINE VARIABLE F-modalidad AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 23.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-RucPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .69 NO-UNDO.

DEFINE VARIABLE F-SitDoc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situacion" 
     VIEW-AS FILL-IN 
     SIZE 13.29 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE F-TlfAlm AS CHARACTER FORMAT "X(256)":U 
     LABEL "Telefono" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 92.72 BY 5.42.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 92.72 BY 1.77.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     LG-COCmp.UsoInt AT ROW 4.77 COL 13.57 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 79.14 BY 1.54
          BGCOLOR 11 
     LG-COCmp.CodPro AT ROW 1.85 COL 11.57 COLON-ALIGNED
          LABEL "Sr(es)" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     F-modalidad AT ROW 2.54 COL 15.43 COLON-ALIGNED NO-LABEL
     LG-COCmp.CndCmp AT ROW 3.31 COL 11.57 COLON-ALIGNED
          LABEL "Forma de Pago" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .69
     LG-COCmp.Observaciones AT ROW 4 COL 11.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 46.29 BY .69
     LG-COCmp.CodAlm AT ROW 6.58 COL 15.29 COLON-ALIGNED
          LABEL "Almacen de Entrega"
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .69
     LG-COCmp.Fchdoc AT ROW 1.85 COL 76.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     LG-COCmp.FchEnt AT ROW 2.54 COL 76.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     LG-COCmp.FchVto AT ROW 3.23 COL 76.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     LG-COCmp.TpoCmb AT ROW 3.92 COL 76.57 COLON-ALIGNED
          LABEL "Tipo de cambio" FORMAT "ZZ9.9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     LG-COCmp.ModAdq AT ROW 2.54 COL 11.57 COLON-ALIGNED FORMAT "X(2)"
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .69
     LG-COCmp.SerReq AT ROW 1.12 COL 31.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.29 BY .69
     LG-COCmp.NroDoc AT ROW 1.15 COL 11.57 COLON-ALIGNED
          LABEL "No. O/C"
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .69
     LG-COCmp.Codmon AT ROW 1.15 COL 45 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"D¢lares", 2
          SIZE 14.86 BY .69
     F-HorRec AT ROW 7.27 COL 15.29 COLON-ALIGNED
     LG-COCmp.NomPro AT ROW 1.85 COL 23 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 35 BY .69
     F-DesCnd AT ROW 3.31 COL 20.57 COLON-ALIGNED NO-LABEL
     F-DirEnt AT ROW 6.58 COL 20.86 COLON-ALIGNED NO-LABEL
     LG-COCmp.NroReq AT ROW 1.12 COL 35.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
     F-RucPro AT ROW 2.54 COL 46.57 COLON-ALIGNED NO-LABEL
     F-SitDoc AT ROW 1.15 COL 75.14 COLON-ALIGNED
     F-Contacto AT ROW 6.58 COL 76.57 COLON-ALIGNED
     F-TlfAlm AT ROW 7.27 COL 76.57 COLON-ALIGNED
     "No.Requis." VIEW-AS TEXT
          SIZE 7.72 BY .69 AT ROW 1.12 COL 25.29
     "R.U.C." VIEW-AS TEXT
          SIZE 5.14 BY .69 AT ROW 2.54 COL 43.57
     "Uso Interno" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 5.27 COL 4.43
     RECT-24 AT ROW 1 COL 1
     RECT-25 AT ROW 6.46 COL 1
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
         HEIGHT             = 7.23
         WIDTH              = 92.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN LG-COCmp.CndCmp IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN LG-COCmp.CodAlm IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN LG-COCmp.CodPro IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN F-Contacto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesCnd IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DirEnt IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-HorRec IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-modalidad IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-RucPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-SitDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TlfAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LG-COCmp.ModAdq IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN LG-COCmp.NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LG-COCmp.NroDoc IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN LG-COCmp.NroReq IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LG-COCmp.SerReq IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN LG-COCmp.TpoCmb IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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


&Scoped-define SELF-NAME LG-COCmp.CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-COCmp.CodAlm V-table-Win
ON LEAVE OF LG-COCmp.CodAlm IN FRAME F-Main /* Almacen de Entrega */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
     FIND Almacen WHERE Almacen.CodCia = S-CODCIA  AND
          Almacen.CodAlm = LG-COCmp.CodAlm:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN
        DISPLAY Almacen.DirAlm @ F-DirEnt 
                Almacen.EncAlm @ F-Contacto 
                Almacen.HorRec @ F-HorRec 
                Almacen.TelAlm @ F-TlfAlm WITH FRAME {&FRAME-NAME}.
     ELSE DO:
          MESSAGE "Almacen no Registrado" VIEW-AS ALERT-BOX.
          RETURN NO-APPLY.
     END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LG-COCmp.Codmon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-COCmp.Codmon V-table-Win
ON VALUE-CHANGED OF LG-COCmp.Codmon IN FRAME F-Main /* Mon */
DO:
  S-CODMON = INTEGER(SELF:SCREEN-VALUE).
  RUN Procesa-Handle IN lh_Handle ('Moneda').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LG-COCmp.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-COCmp.CodPro V-table-Win
ON LEAVE OF LG-COCmp.CodPro IN FRAME F-Main /* Sr(es) */
DO:
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA AND
        gn-prov.CodPro = LG-Cocmp.CodPro:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF AVAILABLE gn-prov THEN
      DISPLAY gn-prov.NomPro @ LG-COCmp.NomPro
/*              gn-prov.Contactos[2] @ F-ConPro*/
              gn-prov.Ruc          @ F-RucPro WITH FRAME {&FRAME-NAME}.
   ELSE DO:
        MESSAGE "Proveedor no Registrado" VIEW-AS ALERT-BOX.
        RETURN NO-APPLY.
   END.
   S-PROVEE = LG-Cocmp.CodPro:SCREEN-VALUE.
   APPLY "ENTRY":U TO LG-COCmp.Fchdoc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LG-COCmp.Fchdoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-COCmp.Fchdoc V-table-Win
ON LEAVE OF LG-COCmp.Fchdoc IN FRAME F-Main /* Fecha Emision */
DO:
  IF INPUT LG-COCmp.Fchdoc = ? THEN RETURN.
  FIND LAST gn-tcmb WHERE gn-tcmb.FECHA <= INPUT LG-COCmp.Fchdoc NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN DO:
     DISPLAY gn-tcmb.compra @ LG-COCmp.TpoCmb WITH FRAME {&FRAME-NAME}.
     S-TPOCMB = gn-tcmb.compra.
  END.
  ELSE MESSAGE "Tipo de cambio no registrado" VIEW-AS ALERT-BOX WARNING.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LG-COCmp.ModAdq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-COCmp.ModAdq V-table-Win
ON LEAVE OF LG-COCmp.ModAdq IN FRAME F-Main /* Modalidad */
DO:
  IF LG-COCmp.ModAdq:screen-value <> "" THEN DO:
  FIND almtabla WHERE almtabla.Tabla = 'MD' 
                 AND  almtabla.Codigo = LG-COCmp.ModAdq:screen-value 
                NO-LOCK NO-ERROR.
  IF AVAILABLE almtabla THEN 
     F-modalidad:screen-value = almtabla.nombre.
  ELSE 
     F-modalidad:screen-value = "".
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LG-COCmp.NroDoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-COCmp.NroDoc V-table-Win
ON LEAVE OF LG-COCmp.NroDoc IN FRAME F-Main /* No. O/C */
DO:
  assign
  x-nrodoc = integer(lg-cocmp.nrodoc:SCREEN-VALUE).
  find first lg-cocmp where lg-cocmp.codcia = 1
                        and lg-cocmp.nrodoc = x-nrodoc
                        no-lock no-error.
                        
  if avail lg-cocmp then do:
    message 'Este numero de docuemnto ya existe'.
    APPLY "ENTRY":U TO LG-COCmp.nrodoc.
  end.  

    
    
     

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LG-COCmp.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LG-COCmp.TpoCmb V-table-Win
ON LEAVE OF LG-COCmp.TpoCmb IN FRAME F-Main /* Tipo de cambio */
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
FOR EACH DCMP:
    DELETE DCMP.
END.
IF NOT L-CREA THEN DO:
   FOR EACH LG-DOCmp WHERE LG-DOCmp.CodCia = LG-COCmp.CodCia 
                      AND  LG-DOCmp.TpoDoc = LG-COCmp.TpoDoc 
                      AND  LG-DOCmp.NroDoc = LG-COCmp.NroDoc:
       CREATE DCMP.
       ASSIGN DCMP.CodCia = LG-DOCmp.CodCia 
              DCMP.TpoDoc = LG-DOCmp.TpoDoc 
              DCMP.NroDoc = LG-DOCmp.NroDoc 
              DCMP.Codmat = LG-DOCmp.Codmat 
              DCMP.ArtPro = LG-DOCmp.ArtPro 
              DCMP.UndCmp = LG-DOCmp.UndCmp
              DCMP.CanPedi = LG-DOCmp.CanPedi 
              DCMP.Dsctos[1] = LG-DOCmp.Dsctos[1] 
              DCMP.Dsctos[2] = LG-DOCmp.Dsctos[2] 
              DCMP.Dsctos[3] = LG-DOCmp.Dsctos[3] 
              DCMP.IgvMat = LG-DOCmp.IgvMat 
              DCMP.ImpTot = LG-DOCmp.ImpTot 
              DCMP.PreUni = LG-DOCmp.PreUni 
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
   FOR EACH LG-DOCmp NO-LOCK WHERE LG-DOCmp.CodCia = LG-COCmp.CodCia 
                              AND  LG-DOCmp.TpoDoc = LG-COCmp.TpoDoc 
                              AND  LG-DOCmp.NroDoc = LG-COCmp.NroDoc
                             ON ERROR UNDO, RETURN "ADM-ERROR":
       FIND LG-DRequ WHERE LG-DRequ.CodCia = LG-DOCmp.CodCia 
                      AND  LG-DRequ.NroReq = LG-COCmp.NroReq 
                      AND  LG-DRequ.Codmat = LG-DOCmp.CodMat 
                     EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE LG-DRequ THEN DO:
          ASSIGN LG-DRequ.CanAten = LG-DRequ.CanAten + (I-FAC * LG-DOCmp.CanPedi ).
       END.
       RELEASE LG-DRequ.
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
DO ON ERROR UNDO, RETURN "ADM-ERROR":
   DEFINE VAR I-Nro AS INTEGER NO-UNDO.
   FOR EACH LG-DRequ NO-LOCK WHERE LG-DRequ.CodCia = LG-COCmp.CodCia 
                              AND  LG-CRequ.TpoReq = "N" 
                              AND  LG-DRequ.NroReq = LG-COCmp.NroReq:
       IF (LG-DRequ.CanApro - LG-DRequ.CanAten) > 0 THEN DO:
          I-NRO = 1.
          LEAVE.
       END.
   END.
   FIND LG-CRequ WHERE LG-CRequ.CodCia = LG-COCmp.CodCia 
                  AND  LG-CRequ.TpoReq = "N" 
                  AND  LG-CRequ.NroReq = LG-COCmp.NroReq 
                 EXCLUSIVE-LOCK NO-ERROR.
   IF AVAILABLE LG-CRequ THEN DO:
      IF I-NRO = 0 THEN ASSIGN LG-CRequ.FlgSit = "C".
      ELSE ASSIGN LG-CRequ.FlgSit = "P".
   END.
   RELEASE LG-CRequ.
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
   FOR EACH LG-DOCmp OF LG-COCmp ON ERROR UNDO, RETURN "ADM-ERROR":
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
   FOR EACH DCMP WHERE DCMP.CanPedi > 0
       ON ERROR UNDO, RETURN "ADM-ERROR":
        CREATE LG-DOCmp.
        ASSIGN LG-DOCmp.CodCia = LG-COCmp.CodCia 
               LG-DOCmp.CodDiv = LG-COCmp.CodDiv
               LG-DOCmp.TpoDoc = LG-COCmp.TpoDoc 
               LG-DOCmp.NroDoc = LG-COCmp.NroDoc 
               LG-DOCmp.Codmat = DCMP.Codmat 
               LG-DOCmp.ArtPro = DCMP.ArtPro 
               LG-DOCmp.UndCmp = DCMP.UndCmp
               LG-DOCmp.CanPedi = DCMP.CanPedi 
               LG-DOCmp.Dsctos[1] = DCMP.Dsctos[1] 
               LG-DOCmp.Dsctos[2] = DCMP.Dsctos[2] 
               LG-DOCmp.Dsctos[3] = DCMP.Dsctos[3] 
               LG-DOCmp.IgvMat = DCMP.IgvMat 
               LG-DOCmp.ImpTot = DCMP.ImpTot 
               LG-DOCmp.PreUni = DCMP.PreUni 
               LG-DOCmp.tpobien = DCMP.tpobien.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Texto V-table-Win 
PROCEDURE Imprime-Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF LG-COCMP.FlgSit <> "A" THEN RUN lgc\r-imptxt(ROWID(LG-COCmp)).
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
  
  L-CREA = YES.
  RUN Actualiza-DCMP.
  RUN Procesa-Handle IN lh_Handle ("Pagina2").
  RUN Procesa-Handle IN lh_Handle ('Browse-add').

  DO WITH FRAME {&FRAME-NAME}:
     DISPLAY TODAY     @ LG-COCmp.Fchdoc 
             TODAY + 1 @ LG-COCmp.FchEnt 
             TODAY + 7 @ LG-COCmp.FchVto.
     FIND LAST gn-tcmb WHERE gn-tcmb.FECHA <= TODAY NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN DO:
        DISPLAY gn-tcmb.compra @ LG-COCmp.TpoCmb.
        S-TPOCMB = gn-tcmb.compra.
     END.
     S-CODMON = 1.
  END.
  I-NROREQ = 0.
  S-PROVEE = "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF L-CREA THEN DO:
      ASSIGN LG-COCmp.CodCia = S-CODCIA
            LG-COCmp.CodDiv = S-CODDIV
            LG-COCmp.TpoDoc = "N"
            LG-COCmp.NroDoc = X-NRODOC
            LG-COCmp.FlgSit = "G"
            LG-COCmp.NroReq = I-NROREQ
            LG-COCmp.Userid-com = S-USER-ID.
  END.
  FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA 
                AND  gn-prov.CodPro = LG-COCmp.CodPro 
               NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN 
     ASSIGN LG-COCmp.NomPro = gn-prov.NomPro.
  ASSIGN LG-COCmp.ImpTot = 0
         LG-COCmp.ImpExo = 0.
  FOR EACH DCMP NO-LOCK:
      LG-COCmp.ImpTot = LG-COCmp.ImpTot + DCMP.ImpTot.
      IF DCMP.IgvMat = 0 THEN LG-COCmp.ImpExo = LG-COCmp.ImpExo + DCMP.ImpTot.
  END.
  FIND LAST LG-CFGIGV NO-LOCK NO-ERROR.
  ASSIGN LG-COCmp.ImpIgv = (LG-COCmp.ImpTot - LG-COCmp.ImpExo) - 
                           ROUND((LG-COCmp.ImpTot - LG-COCmp.ImpExo) / (1 + LG-CFGIGV.PorIgv / 100),2)
         LG-COCmp.ImpBrt = LG-COCmp.ImpTot - LG-COCmp.ImpExo - LG-COCmp.ImpIgv
         LG-COCmp.ImpDto = 0
         LG-COCmp.ImpNet = LG-COCmp.ImpBrt - LG-COCmp.ImpDto.
  
  IF NOT L-CREA THEN DO:
     RUN Actualiza-Detalle-Requisicion(-1).
     RUN Borra-Detalle.
  END.
  RUN Genera-Orden-Compra.
  RUN Actualiza-Detalle-Requisicion(1).
  RUN Actualiza-Estado-Requisicion.

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
  
  /* Code placed here will execute PRIOR to standard behavior. */
  IF LG-COCmp.FlgSit <> "G"  THEN DO:
     MESSAGE "La Orden de Compra no puede ser anulada" SKIP
              "se encuentra " ENTRY(LOOKUP(LG-COCmp.FlgSit,"A,T,V,P"),"Anulada,totalmente atendida,Vencida,Pendiente")
              VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  FOR EACH LG-DOCmp OF LG-COCmp NO-LOCK:
      IF LG-DOCmp.CanAten > 0 THEN DO:
         L-ATEPAR = YES.
         LEAVE.
      END.
  END.
  IF L-ATEPAR THEN DO:
     MESSAGE "La Orden de Compra no puede ser anulada" SKIP
              "se encuentra parcialmente atendida" VIEW-AS ALERT-BOX ERROR.
     RETURN "ADM-ERROR".
  END.
  IF AVAILABLE LG-COCmp AND (LOOKUP(LG-COCmp.FlgSit,"A,T,V") = 0) THEN DO
     ON ERROR UNDO, RETURN "ADM-ERROR":
     FIND CCMP OF LG-COCmp EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE CCMP THEN DO:
        ASSIGN CCMP.FlgSit = "A"
               CCMP.Userid-com = S-USER-ID.
        RUN Actualiza-Detalle-Requisicion(-1).
        RUN Borra-Detalle.
        FIND LG-CRequ WHERE LG-CRequ.CodCia = LG-COCmp.CodCia 
                       AND  LG-CRequ.TpoReq = "N" 
                       AND  LG-CRequ.NroReq = LG-COCmp.NroReq 
                      EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE LG-CRequ THEN ASSIGN LG-CRequ.FlgSit = "P".
        RELEASE LG-CRequ.
     END.
     RELEASE CCMP.
  END.
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
     FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA 
                   AND  gn-prov.CodPro = LG-COCmp.CodPro 
                  NO-LOCK NO-ERROR.
              
     IF AVAILABLE gn-prov THEN 
        DISPLAY /*gn-prov.Contactos[2] @ F-ConPro*/
                gn-prov.Ruc          @ F-RucPro.
     FIND gn-convt WHERE gn-convt.Codig = LG-COCmp.CndCmp NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN 
        DISPLAY gn-convt.Nombr @ F-DesCnd.           
     I-NROREQ = LG-COCmp.NroReq.
     S-PROVEE = LG-COCmp.CodPro.
     FIND Almacen WHERE Almacen.CodCia = LG-COCmp.CodCia 
                   AND  Almacen.CodAlm = LG-COCmp.CodAlm 
                  NO-LOCK NO-ERROR.
     IF AVAILABLE Almacen THEN
        DISPLAY Almacen.DirAlm @ F-DirEnt 
                Almacen.EncAlm @ F-Contacto 
                Almacen.HorRec @ F-HorRec 
                Almacen.TelAlm @ F-TlfAlm.
     IF LOOKUP(LG-COCmp.FlgSit,"X,G,P,A,T,V") > 0 THEN
        F-SitDoc:SCREEN-VALUE = ENTRY(LOOKUP(LG-COCmp.FlgSit,"X,G,P,A,T,V"),"Rechazado,Emitido,Aprobado,Anulado,Aten.Total,Vencida").
        
    FIND almtabla WHERE almtabla.Tabla = 'MD' 
                   AND  almtabla.Codigo = LG-COCmp.ModAdq:screen-value 
                  NO-LOCK NO-ERROR.
    IF AVAILABLE almtabla THEN 
       F-modalidad:screen-value = almtabla.nombre.
    ELSE 
       F-modalidad:screen-value = "".

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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  DO I = 1 TO 4:
    CASE I:
        WHEN 1 THEN MENS = "ALMACEN".
        WHEN 2 THEN MENS = "CONTABILIDAD".
        WHEN 3 THEN MENS = "PROVEEDOR".
        WHEN 4 THEN MENS = "ARCHIVO".
    END CASE.
  IF LG-COCmp.FlgSit <> "A" THEN RUN lgc\r-impcmp(ROWID(LG-COCmp), MENS).
  END.
  
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
        WHEN "ModAdq" THEN ASSIGN input-var-1 = "MD".
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
     L-CREA = NO.
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
DO WITH FRAME {&FRAME-NAME} :

   IF LG-Cocmp.CodPro:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo de proveedor no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO LG-Cocmp.CodPro.
      RETURN "ADM-ERROR".   
   END.
   
   FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA 
                 AND  gn-prov.CodPro = LG-Cocmp.CodPro:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-prov THEN DO:
      MESSAGE "Almacen no Registrado" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO LG-Cocmp.CodPro.
      RETURN "ADM-ERROR".
   END.
   FIND Almacen WHERE Almacen.CodCia = S-CODCIA
                 AND  Almacen.CodAlm = LG-COCmp.CodAlm:SCREEN-VALUE 
                NO-LOCK NO-ERROR.
   IF NOT AVAILABLE Almacen THEN DO:
      MESSAGE "Almacen no Registrado" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO LG-COCmp.CodAlm.
      RETURN "ADM-ERROR".   
   END.
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
IF NOT AVAILABLE LG-COCmp THEN RETURN "ADM-ERROR".
IF LG-COCmp.FlgSit <> "G" /*AND LG-COCmp.FlgSit <> "P"*/ THEN RETURN "ADM-ERROR".
S-TPOCMB = LG-COCmp.TpoCmb.
S-CODMON = LG-COCmp.Codmon.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

