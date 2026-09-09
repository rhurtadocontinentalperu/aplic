&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEFINE INPUT PARAMETER X-ROWID AS ROWID.
/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR.
DEFINE TEMP-TABLE CCMP LIKE LG-COCmp.
DEFINE NEW SHARED TEMP-TABLE DCMP LIKE LG-DOCmp.
DEFINE NEW SHARED VARIABLE S-CODMON  AS INTEGER.
DEFINE NEW SHARED VARIABLE S-TPOCMB  AS DECIMAL.

DEFINE STREAM REPORT.

FIND LG-CRequ WHERE ROWID(LG-CRequ) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE LG-CRequ THEN RETURN "ADM-ERROR".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS C-OrdCmp FILL-IN_TpoCmb FILL-IN_CndCmp ~
FILL-IN_Observaciones FILL-IN_Fchdoc FILL-IN_FchEnt FILL-IN_FchVto Btn_OK ~
Btn_Cancel Btn-Print RECT-1 
&Scoped-Define DISPLAYED-OBJECTS C-OrdCmp F-CodPro FILL-IN_CodAlm ~
FILL-IN_TpoCmb F-ConPro F-DirEnt FILL-IN_CndCmp FILL-IN_Observaciones ~
RADIO-SET_Codmon F-DesCnd F-NomPro F-TlfPro F-FaxPro FILL-IN_Fchdoc ~
FILL-IN_FchEnt FILL-IN_FchVto 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-ordaut AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-Print 
     LABEL "Imprimir" 
     SIZE 10 BY .85.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY DEFAULT 
     LABEL "Cancelar" 
     SIZE 10 BY .85
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO DEFAULT 
     LABEL "Generar O/C" 
     SIZE 10 BY .85
     BGCOLOR 8 .

DEFINE VARIABLE C-OrdCmp AS INTEGER FORMAT "999999":U INITIAL 0 
     LABEL "No.Orden" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 11.86 BY 1 NO-UNDO.

DEFINE VARIABLE F-CodPro AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY .69 NO-UNDO.

DEFINE VARIABLE F-ConPro AS CHARACTER FORMAT "X(50)":U 
     LABEL "Atencion" 
     VIEW-AS FILL-IN 
     SIZE 25.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesCnd AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .69 NO-UNDO.

DEFINE VARIABLE F-DirEnt AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.43 BY .69 NO-UNDO.

DEFINE VARIABLE F-FaxPro AS CHARACTER FORMAT "X(15)":U 
     LABEL "Fax" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69 NO-UNDO.

DEFINE VARIABLE F-NomPro AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 36.29 BY .69 NO-UNDO.

DEFINE VARIABLE F-TlfPro AS CHARACTER FORMAT "X(15)":U 
     LABEL "Telefono" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_CndCmp AS CHARACTER FORMAT "X(3)" 
     LABEL "Forma Pgo" 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .69.

DEFINE VARIABLE FILL-IN_CodAlm AS CHARACTER FORMAT "x(3)" 
     LABEL "Almacen de Entrega" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .69.

DEFINE VARIABLE FILL-IN_Fchdoc AS DATE FORMAT "99/99/9999" 
     LABEL "Fecha Emision" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69.

DEFINE VARIABLE FILL-IN_FchEnt AS DATE FORMAT "99/99/9999" 
     LABEL "Fecha Entrega" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69.

DEFINE VARIABLE FILL-IN_FchVto AS DATE FORMAT "99/99/9999" 
     LABEL "Fecha Maxima" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69.

DEFINE VARIABLE FILL-IN_Observaciones AS CHARACTER FORMAT "x(60)" 
     LABEL "Observaciones" 
     VIEW-AS FILL-IN 
     SIZE 43.72 BY .69.

DEFINE VARIABLE FILL-IN_TpoCmb AS DECIMAL FORMAT "ZZ9.9999" INITIAL 0 
     LABEL "Tipo de cambio" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69.

DEFINE VARIABLE RADIO-SET_Codmon AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 11.72 BY .69.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 82.57 BY 4.92.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     C-OrdCmp AT ROW 1.12 COL 10.57 COLON-ALIGNED
     F-CodPro AT ROW 2.04 COL 4.71
     FILL-IN_CodAlm AT ROW 4.85 COL 15.29 COLON-ALIGNED
     FILL-IN_TpoCmb AT ROW 4.85 COL 70 COLON-ALIGNED
     F-ConPro AT ROW 2.73 COL 10.57 COLON-ALIGNED
     F-DirEnt AT ROW 4.85 COL 20.86 COLON-ALIGNED NO-LABEL
     FILL-IN_CndCmp AT ROW 3.42 COL 10.57 COLON-ALIGNED
     FILL-IN_Observaciones AT ROW 4.12 COL 10.57 COLON-ALIGNED
     RADIO-SET_Codmon AT ROW 1.19 COL 69.57 NO-LABEL
     F-DesCnd AT ROW 3.42 COL 17.14 COLON-ALIGNED NO-LABEL
     F-NomPro AT ROW 2.04 COL 23 COLON-ALIGNED NO-LABEL
     F-TlfPro AT ROW 2.73 COL 45.29 COLON-ALIGNED
     F-FaxPro AT ROW 2.04 COL 66 COLON-ALIGNED
     FILL-IN_Fchdoc AT ROW 2.73 COL 70 COLON-ALIGNED
     FILL-IN_FchEnt AT ROW 3.42 COL 70 COLON-ALIGNED
     FILL-IN_FchVto AT ROW 4.12 COL 70 COLON-ALIGNED
     Btn_OK AT ROW 10.81 COL 72.57
     Btn_Cancel AT ROW 11.92 COL 72.57
     Btn-Print AT ROW 13.04 COL 72.57
     "Moneda :" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 1.31 COL 62.86
     RECT-1 AT ROW 1 COL 1
     SPACE(0.57) SKIP(8.49)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Ordenes de Compra".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN F-CodPro IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN F-ConPro IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesCnd IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DirEnt IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-FaxPro IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomPro IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-TlfPro IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodAlm IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RADIO-SET_Codmon IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Ordenes de Compra */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Print D-Dialog
ON CHOOSE OF Btn-Print IN FRAME D-Dialog /* Imprimir */
DO:
  ASSIGN F-CodPro F-ConPro F-DesCnd F-FaxPro FILL-IN_CndCmp 
         FILL-IN_Fchdoc FILL-IN_FchEnt FILL-IN_FchVto 
         FILL-IN_Observaciones F-NomPro F-TlfPro RADIO-SET_Codmon.
  RUN Imprime-Pre-Orden.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Generar O/C */
DO:
  RUN Genera-Ordenes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME C-OrdCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-OrdCmp D-Dialog
ON VALUE-CHANGED OF C-OrdCmp IN FRAME D-Dialog /* No.Orden */
DO:
   ASSIGN C-OrdCmp.
    RUN Pinta-Datos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CndCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CndCmp D-Dialog
ON LEAVE OF FILL-IN_CndCmp IN FRAME D-Dialog /* Forma Pgo */
DO:
  ASSIGN FILL-IN_CndCmp
         CCMP.CndCmp = FILL-IN_CndCmp.
  F-DesCnd:SCREEN-VALUE = "".
  FIND gn-convt WHERE gn-convt.Codig = FILL-IN_CndCmp NO-LOCK NO-ERROR.
  IF AVAILABLE gn-convt THEN 
     DISPLAY gn-convt.Nombr @ F-DesCnd WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Fchdoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Fchdoc D-Dialog
ON LEAVE OF FILL-IN_Fchdoc IN FRAME D-Dialog /* Fecha Emision */
DO:
  ASSIGN FILL-IN_Fchdoc
         CCMP.Fchdoc = FILL-IN_Fchdoc.
  FIND gn-tcmb WHERE gn-tcmb.FECHA = FILL-IN_Fchdoc NO-LOCK NO-ERROR.
  IF AVAILABLE gn-tcmb THEN DO:
     DISPLAY gn-tcmb.compra @ FILL-IN_TpoCmb WITH FRAME {&FRAME-NAME}.
     CCMP.TpoCmb = gn-tcmb.compra.
     S-TPOCMB = gn-tcmb.compra.
  END.
  ELSE MESSAGE "Tipo de cambio no registrado" VIEW-AS ALERT-BOX WARNING.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_FchEnt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_FchEnt D-Dialog
ON LEAVE OF FILL-IN_FchEnt IN FRAME D-Dialog /* Fecha Entrega */
DO:
  ASSIGN FILL-IN_FchEnt
         CCMP.FchEnt = FILL-IN_FchEnt.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_FchVto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_FchVto D-Dialog
ON LEAVE OF FILL-IN_FchVto IN FRAME D-Dialog /* Fecha Maxima */
DO:
  ASSIGN FILL-IN_FchVto
         CCMP.FchVto = FILL-IN_FchVto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Observaciones
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Observaciones D-Dialog
ON LEAVE OF FILL-IN_Observaciones IN FRAME D-Dialog /* Observaciones */
DO:
  ASSIGN FILL-IN_Observaciones
         CCMP.Observaciones = FILL-IN_Observaciones.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_TpoCmb D-Dialog
ON LEAVE OF FILL-IN_TpoCmb IN FRAME D-Dialog /* Tipo de cambio */
DO:
  ASSIGN FILL-IN_TpoCmb. 
  CCMP.TpoCmb = FILL-IN_TpoCmb.
  S-TPOCMB = FILL-IN_TpoCmb.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET_Codmon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET_Codmon D-Dialog
ON VALUE-CHANGED OF RADIO-SET_Codmon IN FRAME D-Dialog
DO:
  ASSIGN RADIO-SET_Codmon.
  CCMP.CodMon = RADIO-SET_Codmon.
  S-CODMON = RADIO-SET_Codmon.
  RUN Cambio-de-Moneda IN h_b-ordaut.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'lgc/b-ordaut.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_b-ordaut ).
       /* Position in AB:  ( 6.04 , 1.00 ) */
       /* Size in UIB:  ( 8.15 , 69.86 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME D-Dialog:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 6.04 , 71.86 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 4.50 , 11.43 ) NO-ERROR.

       /* Links to  h_b-ordaut. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_b-ordaut ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             C-OrdCmp:HANDLE , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporales D-Dialog 
PROCEDURE Carga-Temporales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE S-LISTORD AS CHAR NO-UNDO.
DEFINE VARIABLE I-ORDEN   AS INTEGER INIT 0 NO-UNDO.
FIND gn-tcmb WHERE gn-tcmb.FECHA = TODAY NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-tcmb THEN FIND LAST gn-tcmb NO-LOCK NO-ERROR.
S-TPOCMB = gn-tcmb.compra.
S-CODMON = 2.
FIND LG-CRequ WHERE ROWID(LG-CRequ) = X-ROWID NO-LOCK NO-ERROR.
IF AVAILABLE LG-CRequ THEN DO WITH FRAME {&FRAME-NAME}:
   /* PRIMERO CARGAMOS EL DETALLE GUARDANDO EL CODIGO DE PROVEEDOR EN TPODOC */
   FOR EACH LG-DRequ WHERE 
            LG-DRequ.CodCia = LG-CRequ.CodCia AND
            LG-DRequ.NroSer = LG-CRequ.NroSer AND
            LG-DRequ.NroReq = LG-CRequ.NroReq AND
            (LG-DRequ.CanApro - LG-DRequ.CanAten) > 0:
       FIND LAST LG-dmatpr WHERE LG-dmatpr.CodCia = LG-DRequ.CodCia AND
                 LG-dmatpr.codmat = LG-DRequ.Codmat  AND
                 LG-dmatpr.FlgEst = "A"  NO-LOCK NO-ERROR.
       CREATE DCMP.
       ASSIGN DCMP.CodCia  = LG-CRequ.CodCia 
              DCMP.Codmat  = LG-DRequ.Codmat 
              DCMP.CanPedi = LG-DRequ.CanApro 
              DCMP.UndCmp  = LG-DRequ.UndCmp 
              DCMP.CanAten = IF AVAILABLE LG-dmatpr THEN LG-dmatpr.CodMon ELSE S-Codmon 
              DCMP.PreUni  = IF AVAILABLE LG-dmatpr THEN LG-dmatpr.PreAct ELSE 0 
              DCMP.TpoDoc  = IF AVAILABLE LG-dmatpr THEN LG-dmatpr.codpro ELSE "VARIOS" 
              DCMP.ArtPro  = IF AVAILABLE LG-dmatpr THEN LG-dmatpr.ArtPro ELSE "" 
              DCMP.Dsctos[1] = IF AVAILABLE LG-dmatpr THEN LG-dmatpr.Dsctos[1] ELSE 0 
              DCMP.Dsctos[2] = IF AVAILABLE LG-dmatpr THEN LG-dmatpr.Dsctos[2] ELSE 0 
              DCMP.Dsctos[3] = IF AVAILABLE LG-dmatpr THEN LG-dmatpr.Dsctos[3] ELSE 0 
              DCMP.IgvMat = IF AVAILABLE LG-dmatpr THEN LG-dmatpr.IgvMat ELSE 0.
      DCMP.ImpTot = ROUND(DCMP.CanPedi * ROUND(DCMP.PreUni * 
                          (1 - (DCMP.Dsctos[1] / 100)) *
                          (1 - (DCMP.Dsctos[2] / 100)) *
                          (1 - (DCMP.Dsctos[3] / 100)) *
                          (1 + (DCMP.IgvMat / 100)) , 4),2).
   END.
   /* SEGUNDO CREAMOS LA CABECERA DE ORDEN DE COMPRA POR CADA PROVEEDOR ENCONTRADO */
   S-LISTORD = "".
   FOR EACH DCMP BREAK BY (DCMP.TpoDoc + STRING(DCmp.CanAten)):
       IF FIRST-OF ((DCMP.TpoDoc + STRING(DCmp.CanAten))) THEN DO:
          I-ORDEN = I-ORDEN + 1.
          CREATE CCMP.
          ASSIGN CCMP.CodCia = DCMP.CodCia 
                 CCMP.CodDiv = s-CodDiv
                 CCMP.NroDoc = I-ORDEN 
                 CCMP.CodPro = DCMP.TpoDoc 
                 CCMP.CodAlm = LG-CRequ.Solicita 
                 CCMP.SerReq = LG-CRequ.NroSer 
                 CCMP.NroReq = LG-CRequ.NroReq 
                 CCMP.Fchdoc = TODAY 
                 CCMP.FchEnt = TODAY + 1 
                 CCMP.FchVto = TODAY + 7 
                 CCMP.TpoCmb = S-TPOCMB 
                 CCMP.CodMon = DCMP.CanAten 
                 CCMP.Userid-com = S-USER-ID.
          FIND LAST LG-cmatpr WHERE LG-cmatpr.CodCia = CCMP.CodCia AND
               LG-cmatpr.CodPro = CCMP.CodPro AND
               LG-cmatpr.FlgEst = "A" NO-LOCK NO-ERROR.
          IF AVAILABLE LG-cmatpr THEN 
             ASSIGN CCMP.CndCmp = LG-cmatpr.CndCmp.
          ELSE ASSIGN CCMP.Observaciones = "ARTICULOS SIN PROVEEDOR".
          IF S-LISTORD = "" THEN S-LISTORD = STRING(CCMP.NroDoc).
          ELSE S-LISTORD = S-LISTORD + "," + STRING(CCMP.NroDoc).
          FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA AND
               gn-prov.CodPro = CCMP.CodPro NO-LOCK NO-ERROR.
          IF AVAILABLE gn-prov THEN CCMP.NomPro = gn-prov.NomPro .
       END.
       DCMP.NroDoc = I-ORDEN.
   END.
   C-OrdCmp:LIST-ITEMS = S-LISTORD.
   C-OrdCmp:SCREEN-VALUE = ENTRY(1,S-LISTORD).
   C-OrdCmp = INTEGER(ENTRY(1,S-LISTORD)).
END.
RUN PINTA-DATOS.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY C-OrdCmp F-CodPro FILL-IN_CodAlm FILL-IN_TpoCmb F-ConPro F-DirEnt 
          FILL-IN_CndCmp FILL-IN_Observaciones RADIO-SET_Codmon F-DesCnd 
          F-NomPro F-TlfPro F-FaxPro FILL-IN_Fchdoc FILL-IN_FchEnt 
          FILL-IN_FchVto 
      WITH FRAME D-Dialog.
  ENABLE C-OrdCmp FILL-IN_TpoCmb FILL-IN_CndCmp FILL-IN_Observaciones 
         FILL-IN_Fchdoc FILL-IN_FchEnt FILL-IN_FchVto Btn_OK Btn_Cancel 
         Btn-Print RECT-1 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Ordenes D-Dialog 
PROCEDURE Genera-Ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR X-NRODOC AS INTEGER NO-UNDO.
FIND LAST LG-CFGIGV NO-LOCK NO-ERROR.
FOR EACH CCMP:
    FIND LG-CORR WHERE LG-CORR.CodCia = S-CODCIA 
        AND LG-CORR.CodDiv = s-CodDiv
        AND LG-CORR.CodDoc = "O/C" NO-ERROR.
    X-NRODOC = LG-CORR.NroDoc.
    ASSIGN LG-CORR.NroDoc = LG-CORR.NroDoc + 1.
    RELEASE LG-CORR.
    CREATE LG-COCmp.
    ASSIGN LG-COCmp.CodCia = S-CODCIA
           LG-COCmp.CodDiv = s-CodDiv
           LG-COCmp.TpoDoc = "N"
           LG-COCmp.NroDoc = X-NRODOC
           LG-COCmp.CodPro = CCMP.CodPro
           LG-COCmp.NomPro = CCMP.NomPro
           LG-COCmp.CodAlm = CCMP.CodAlm
           LG-COCmp.SerReq = CCMP.SerReq
           LG-COCmp.NroReq = CCMP.NroReq
           LG-COCmp.FchDoc = CCMP.Fchdoc
           LG-COCmp.FchEnt = CCMP.FchEnt
           LG-COCmp.FchVto = CCMP.FchVto 
           LG-COCmp.CndCmp = CCMP.CndCmp
           LG-COCmp.Codmon = CCMP.Codmon
           LG-COCmp.TpoCmb = CCMP.TpoCmb
           LG-COCmp.Observaciones = CCMP.Observaciones 
           LG-COCmp.FlgSit = "P"
           LG-COCmp.Userid-com = CCMP.Userid-com.
    FOR EACH DCMP WHERE DCMP.CodCia = CCMP.CodCia AND
             DCMP.NroDoc = CCMP.NroDoc:
        CREATE LG-DOCmp.
        ASSIGN LG-DOCmp.CodCia    = LG-COCmp.CodCia 
               LG-DOCmp.CodDiv    = LG-COCmp.CodDiv
               LG-DOCmp.TpoDoc    = LG-COCmp.TpoDoc 
               LG-DOCmp.NroDoc    = LG-COCmp.NroDoc 
               LG-DOCmp.Codmat    = DCMP.Codmat
               LG-DOCmp.UndCmp    = DCMP.UndCmp
               LG-DOCmp.CanPedi   = DCMP.CanPedi 
               LG-DOCmp.PreUni    = DCMP.PreUni 
               LG-DOCmp.Dsctos[1] = DCMP.Dsctos[1] 
               LG-DOCmp.Dsctos[2] = DCMP.Dsctos[2]
               LG-DOCmp.Dsctos[3] = DCMP.Dsctos[3]
               LG-DOCmp.IgvMat    = DCMP.IgvMat 
               LG-DOCmp.ImpTot    = DCMP.ImpTot 
               LG-DOCmp.tpobien   = DCMP.tpobien 
               LG-DOCmp.ArtPro    = DCMP.ArtPro. 
        LG-COCmp.ImpTot = LG-COCmp.ImpTot + DCMP.ImpTot.
        IF DCMP.IgvMat = 0 THEN LG-COCmp.ImpExo = LG-COCmp.ImpExo + DCMP.ImpTot.
    END.
    ASSIGN LG-COCmp.ImpIgv = (LG-COCmp.ImpTot - LG-COCmp.ImpExo) - 
                             ROUND((LG-COCmp.ImpTot - LG-COCmp.ImpExo) / (1 + LG-CFGIGV.PorIgv / 100),2)
           LG-COCmp.ImpBrt = LG-COCmp.ImpTot - LG-COCmp.ImpExo - LG-COCmp.ImpIgv
           LG-COCmp.ImpDto = 0
           LG-COCmp.ImpNet = LG-COCmp.ImpBrt - LG-COCmp.ImpDto.
    RUN Imprime-Orden-Compra.
END.
FIND LG-CRequ WHERE ROWID(LG-CRequ) = X-ROWID NO-ERROR.
IF AVAILABLE LG-CRequ THEN ASSIGN LG-CRequ.FlgSit = "C".
RELEASE LG-CRequ.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Orden-Compra D-Dialog 
PROCEDURE Imprime-Orden-Compra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN lgc\r-impcmp(ROWID(LG-COCmp)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Pre-Orden D-Dialog 
PROCEDURE Imprime-Pre-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE F-TOTAL AS DECIMAL INIT 0 NO-UNDO.
DEFINE FRAME F-CMP
       DCmp.ArtPro FORMAT "X(8)"
       DCMP.Codmat     FORMAT "X(6)"  COLUMN-LABEL "Codigo"
       Almmmatg.DesMat FORMAT "X(40)" COLUMN-LABEL "Descripcion"
       Almmmatg.DesMar FORMAT "X(15)" COLUMN-LABEL "Marca"
       DCMP.CanPedi    FORMAT ">>,>>9.99" 
       DCMP.UndCmp     FORMAT "X(4)"  COLUMN-LABEL "Und."
       DCMP.PreUni     FORMAT ">>,>>9.9999"
       DCMP.Dsctos[1]  FORMAT ">9.99" COLUMN-LABEL "Dscto"
       DCMP.Dsctos[2]  FORMAT ">9.99" COLUMN-LABEL "Dscto"
       DCMP.Dsctos[3]  FORMAT ">9.99" COLUMN-LABEL "Dscto"
       DCMP.IgvMat     FORMAT ">9.99" COLUMN-LABEL "% IGV"
       DCMP.ImpTot     FORMAT ">,>>>,>>9.99"
       HEADER
             S-NomCia   "PRE-ORDEN DE COMPRA" AT 55 SKIP
             " Sr(es) : " F-NomPro   "Tpo.Cambio : " TO 126  FILL-IN_TpoCmb SKIP
             "Atencion : " F-ConPro  "Moneda : " TO 126 (IF S-CODMON = 1 THEN "S/." ELSE "US$") SKIP
             "TELEFONO : " F-TlfPro  "Fax : " TO 45 F-FaxPro 
             "FECHA EMISION : " TO 126 FILL-IN_Fchdoc FORMAT "99/99/9999" SKIP 
             "Forma de Pago : " FILL-IN_CndCmp " " F-DesCnd
             "FECHA ENTREGA : " TO 126 FILL-IN_FchEnt FORMAT "99/99/9999" SKIP 
             "Observaciones : " FILL-IN_Observaciones
             "FECHA VENCMTO : " TO 126 FILL-IN_FchVto FORMAT "99/99/9999" SKIP(2) 
        WITH WIDTH 160 NO-BOX STREAM-IO DOWN.

/* OUTPUT STREAM report TO C:\TMP\PRUEBA.PRN PAGED PAGE-SIZE 60.    */
OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 60.   

PUT STREAM report CONTROL CHR(27) "@".
PUT STREAM report CONTROL CHR(27) "C" CHR(66).
PUT STREAM report CONTROL CHR(27) CHR(120) 0.
PUT STREAM report CONTROL CHR(15).

FOR EACH DCMP WHERE DCMP.CodCia = S-CODCIA AND
         DCMP.NroDoc = C-OrdCmp:
    FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
         Almmmatg.codmat = DCMP.Codmat NO-LOCK NO-ERROR.
    DISPLAY STREAM report 
           DCmp.ArtPro 
           DCMP.Codmat     
           Almmmatg.DesMat 
           Almmmatg.DesMar
           DCMP.CanPedi   
           DCMP.UndCmp    
           DCMP.PreUni    
           DCMP.Dsctos[1] 
           DCMP.Dsctos[2] 
           DCMP.Dsctos[3] 
           DCMP.IgvMat    
           DCMP.ImpTot   WITH FRAME F-CMP.
    F-TOTAL = F-TOTAL + DCMP.ImpTot.
END.
DO WHILE LINE-COUNTER(report) < PAGE-SIZE(report) - 6 :
   PUT STREAM report "" skip.
END.
PUT STREAM report "------------" AT 126 SKIP.
PUT STREAM report "Importe Total : " TO 124 F-TOTAL AT 126 FORMAT ">,>>>,>>9.99" SKIP.
PUT STREAM report "------------" AT 126 SKIP.
PUT STREAM report "-----------------       ------------------       -----------------      "  AT 10 SKIP.
PUT STREAM report  S-USER-ID  AT 10       "Vo.Bo.Jefe Compras        Vo.Bo.GERENCIA        "  AT 34 SKIP.
OUTPUT STREAM report CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN Carga-Temporales.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta-Datos D-Dialog 
PROCEDURE Pinta-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
   ASSIGN C-OrdCmp
          F-CodPro = ""
          F-NomPro = ""
          F-FaxPro = ""
          F-ConPro = ""
          F-TlfPro = ""
          F-DesCnd = "".
   FIND CCMP WHERE CCMP.CodCia = 1 AND
        CCMP.NroDoc = C-OrdCmp NO-ERROR.
   IF AVAILABLE CCMP THEN DO:
      FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA AND
           gn-prov.CodPro = CCMP.CodPro NO-LOCK NO-ERROR.
      IF AVAILABLE gn-prov THEN 
          ASSIGN F-ConPro = gn-prov.Contactos[1]
                 F-FaxPro = gn-prov.FaxPro 
                 F-TlfPro = gn-prov.Telfnos[1].
      ASSIGN F-CodPro       = CCMP.CodPro 
             F-NomPro       = CCMP.NomPro 
             FILL-IN_CndCmp = CCMP.CndCmp 
             FILL-IN_Fchdoc = CCMP.Fchdoc 
             FILL-IN_FchEnt = CCMP.FchEnt 
             FILL-IN_FchVto = CCMP.FchVto 
             FILL-IN_Observaciones = CCMP.Observaciones.
      RADIO-SET_Codmon:SCREEN-VALUE = STRING(CCMP.Codmon).
      FILL-IN_TpoCmb = CCMP.TpoCmb.
   END.
   F-DesCnd = "".
   FIND gn-convt WHERE gn-convt.Codig = FILL-IN_CndCmp NO-LOCK NO-ERROR.
   IF AVAILABLE gn-convt THEN F-DesCnd = gn-convt.Nombr.
   F-DirEnt = "".
   FIND Almacen WHERE Almacen.CodCia = CCmp.CodCia AND
        Almacen.CodAlm = CCmp.CodAlm NO-LOCK NO-ERROR.
   IF AVAILABLE Almacen THEN F-DirEnt = Almacen.DirAlm.
   FILL-IN_CodAlm = CCmp.CodAlm.
   DISPLAY F-ConPro 
           F-FaxPro 
           F-NomPro 
           F-TlfPro 
           F-DirEnt 
           F-DesCnd
           F-CodPro 
           FILL-IN_CndCmp 
           FILL-IN_Fchdoc 
           FILL-IN_FchEnt 
           FILL-IN_FchVto 
           FILL-IN_Observaciones 
           FILL-IN_TpoCmb 
           FILL-IN_CodAlm.
   RUN Filtro-por-Orden IN h_b-ordaut (C-OrdCmp,F-CodPro).
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
PROCEDURE Recoge-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

