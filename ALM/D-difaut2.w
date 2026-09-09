&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

/* Local Variable Definitions ---                                       */
DEFINE VAR F-STKALM  AS DECIMAL.
DEFINE VAR F-STKGEN  AS DECIMAL.
DEFINE VAR F-VALCTO  AS DECIMAL.
DEFINE VAR I-NROITM  AS INTEGER.
DEFINE VAR X-TASK-NO AS INTEGER.
DEFINE VAR C-OP      AS CHAR.
DEFINE VAR C-TPOINV  AS CHAR.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHAR.
define var S-FCHINV as date.

DEFINE VAR RUTA AS CHAR NO-UNDO.
GET-KEY-VALUE SECTION "STARTUP" KEY "BASE" VALUE RUTA.

DEFINE TEMP-TABLE T-REPORT LIKE W-REPORT.
DEFINE VAR R-ROWID  AS ROWID   NO-UNDO.
DEFINE VAR X-TPOCMB AS DECIMAL INITIAL 1 NO-UNDO.

DEFINE IMAGE IMAGE-1 FILENAME "IMG\print" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-18 RECT-16 RECT-19 D-FCHINV DesdeC ~
HastaC Btn_OK Btn_Cancel I-TpoCto ICodMon 
&Scoped-Define DISPLAYED-OBJECTS C-ALMCEN D-FCHINV DesdeC HastaC C-DESALM ~
I-TpoCto ICodMon 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD STOCKFACTURA D-Dialog 
FUNCTION STOCKFACTURA RETURNS DECIMAL
   (INPUT X-CODMAT AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE C-ALMCEN AS CHARACTER FORMAT "X(3)":U 
     LABEL "Almacen" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .69
     FONT 1 NO-UNDO.

DEFINE VARIABLE C-DESALM AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44.72 BY .69
     FONT 1 NO-UNDO.

DEFINE VARIABLE D-FCHINV AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha de Inventario" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .69
     FONT 1 NO-UNDO.

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .69 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .69 NO-UNDO.

DEFINE VARIABLE I-TpoCto AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Promedio", 1,
"Reposición", 2
     SIZE 20.57 BY .81 NO-UNDO.

DEFINE VARIABLE ICodMon AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "S/.", 1,
"US$", 2
     SIZE 13.72 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 15.57 BY .85.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 70 BY 5.5.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 21.86 BY 1.23.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     C-ALMCEN AT ROW 1.58 COL 16 COLON-ALIGNED
     D-FCHINV AT ROW 2.54 COL 16 COLON-ALIGNED
     DesdeC AT ROW 3.73 COL 16.29 COLON-ALIGNED
     HastaC AT ROW 4.5 COL 16.29 COLON-ALIGNED
     C-DESALM AT ROW 1.58 COL 21.86 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 6.88 COL 23
     Btn_Cancel AT ROW 6.88 COL 40
     I-TpoCto AT ROW 4.69 COL 45.72 NO-LABEL
     ICodMon AT ROW 3.65 COL 52.14 NO-LABEL
     RECT-18 AT ROW 1.31 COL 1
     RECT-16 AT ROW 3.54 COL 51.14
     "Moneda :" VIEW-AS TEXT
          SIZE 6.86 BY .62 AT ROW 3.69 COL 43.72
     RECT-19 AT ROW 4.54 COL 44.86
     SPACE(4.28) SKIP(2.64)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Ajuste Automatico de Diferencia de Inventario".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN C-ALMCEN IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN C-DESALM IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Ajuste Automatico de Diferencia de Inventario */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN DesdeC HastaC  ICodMon I-TpoCto.
  
  /* Verifica contra el mes cerrado */
  /*
  DEFINE VAR x-ok AS LOGICAL NO-UNDO.
  RUN alm\Ver-cier(D-FCHINV, OUTPUT x-ok).
  IF NOT x-ok THEN RETURN.
  */
   FIND AlmCierr WHERE 
        AlmCierr.CodCia = S-CODCIA AND 
        AlmCierr.FchCie = D-FCHINV 
        NO-LOCK NO-ERROR.    
    
   IF AVAILABLE AlmCierr AND
      AlmCierr.FlgCie THEN DO:
      MESSAGE "Este dia " AlmCierr.FchCie " se encuentra cerrado" SKIP 
              "Consulte con sistemas " VIEW-AS ALERT-BOX INFORMATION.
      RETURN.
   END.
  
  RUN Proceso.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME D-FCHINV
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-FCHINV D-Dialog
ON LEAVE OF D-FCHINV IN FRAME D-Dialog /* Fecha de Inventario */
DO:
    
    FIND InvConfig 
    WHERE InvConfig.CodCia = S-CODCIA
    AND InvConfig.CodAlm = S-CODALM 
    AND InvConfig.Fchinv = date(d-fchinv:screen-value)
    NO-LOCK NO-ERROR.
     
    IF AVAILABLE InvConfig THEN do:
        ASSIGN D-FCHINV.
        S-FCHINV = InvConfig.Fchinv.
    end.
    
    if not avail InvConfig then do:
        message "La fecha no esta registrada en Configuración de Inventarios" view-as alert-box error.
        RETURN NO-APPLY.
    end.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC D-Dialog
ON LEAVE OF DesdeC IN FRAME D-Dialog /* Desde */
DO:
  IF INPUT DesdeC = "" THEN RETURN.
  FIND FIRST Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
                      Almmmatg.CodMat BEGINS INPUT DesdeC NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC D-Dialog
ON LEAVE OF HastaC IN FRAME D-Dialog /* Hasta */
DO:
  IF INPUT HastaC = "" THEN RETURN.
  FIND FIRST Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND 
                      Almmmatg.CodMat BEGINS INPUT HastaC NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Almmmatg THEN DO:
     MESSAGE "Codigo no Existe" VIEW-AS ALERT-BOX ERROR.
     RETURN NO-APPLY.
  END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Tempo D-Dialog 
PROCEDURE Carga-Tempo :
/*------------------------------------------------------------------------------
  Purpose: Carga archivo temporal segun parametros ingresados    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR F-stkFac AS DECIMAL NO-UNDO.
DEFINE VAR F-invfis AS DECIMAL NO-UNDO.
DEFINE VAR F-ctorep AS DECIMAL NO-UNDO.
DEFINE VAR x-inventario AS INTEGER NO-UNDO.
FOR EACH T-REPORT :
    DELETE T-REPORT.
END.

I-NROITM = 0.

FOR EACH almmmatg WHERE 
         almmmatg.CodCia = S-CODCIA AND 
         almmmatg.CodMat >= DesdeC  AND 
         almmmatg.CodMat <= HastaC NO-LOCK USE-INDEX Matg01 :
    DISPLAY almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
            FORMAT "X(8)" WITH FRAME F-Proceso.
    
    /* UBICAMOS EL STOCK GENERAL */
    FIND LAST Almdmov WHERE 
              Almdmov.CodCia = almmmatg.CodCia AND
              Almdmov.CodMat = almmmatg.CodMat AND
              Almdmov.Fchdoc <= InvConfig.FchInv USE-INDEX Almd02 NO-LOCK NO-ERROR.
    IF AVAILABLE Almdmov THEN F-STKGEN = Almdmov.StkAct.
    ELSE F-STKGEN = 0.
    IF AVAILABLE Almdmov AND ICodMon = 1 THEN F-VALCTO = Almdmov.VctoMn1.
    IF AVAILABLE Almdmov AND ICodMon = 2 THEN F-VALCTO = Almdmov.VctoMn2.
    
    /* Valorización Costo de Reposición */
    FIND LAST Almdmov WHERE 
              Almdmov.CodCia = almmmatg.CodCia AND
              Almdmov.CodMat = almmmatg.CodMat AND
              Almdmov.FchDoc <= InvConfig.FchInv AND
              Almdmov.TipMov = 'I' AND
              Almdmov.CodMov = 02 USE-INDEX Almd02 NO-LOCK NO-ERROR.
    IF AVAILABLE Almdmov THEN 
       IF ICodMon = 1 THEN F-CtoRep = ROUND(ALMDMOV.ImpMn1 / ALMDMOV.Candes / Almdmov.factor, 3).
                      ELSE F-CtoRep = ROUND(ALMDMOV.ImpMn2 / ALMDMOV.Candes / Almdmov.factor, 3).
    ELSE F-CtoRep = 0.
       
    /* UBICAMOS EL STOCK DE ALMACEN */
    FIND LAST Almdmov WHERE 
              Almdmov.CodCia = almmmatg.CodCia AND
              Almdmov.CodAlm = S-CODALM        AND 
              Almdmov.CodMat = almmmatg.CodMat AND
              Almdmov.Fchdoc <= InvConfig.FchInv USE-INDEX Almd03 NO-LOCK NO-ERROR.
    IF AVAILABLE Almdmov THEN F-STKALM = Almdmov.StkSub.
    ELSE F-STKALM = 0.
    /* Calculamos el Inventario Fisico */
    F-InvFis = 0.
    x-inventario = 0. 
    FIND InvRecont WHERE
         InvRecont.CodCia = almmmatg.CodCia AND
         InvRecont.CodAlm = S-CODALM        AND
         InvRecont.FchInv = D-FCHINV        AND
         InvRecont.CodMat = almmmatg.CodMat NO-LOCK NO-ERROR.
    IF AVAILABLE InvRecont THEN
       FOR EACH InvRecont WHERE 
                InvRecont.CodCia = almmmatg.CodCia AND
                InvRecont.CodAlm = S-CODALM        AND
                InvRecont.FchInv = D-FCHINV        AND
                InvRecont.CodMat = almmmatg.CodMat NO-LOCK:
                F-InvFis = F-InvFis + INVRECONT.CanInv.      
                x-inventario = IF F-InvFis = 0 THEN 0 ELSE 1.
       END.
       
    ELSE
       FOR EACH InvConteo WHERE 
                InvConteo.CodCia = almmmatg.CodCia AND
                InvConteo.CodAlm = S-CODALM        AND
                InvConteo.FchInv = D-FCHINV        AND
                InvConteo.CodMat = almmmatg.CodMat NO-LOCK:
                F-InvFis = F-InvFis + INVCONTEO.CanInv.      
                x-inventario = IF F-InvFis = 0 THEN 0 ELSE 1.
       END.
        
    /* SOLO SI EXISTEN DIFERENCIAS */
    IF F-STKALM /*+ F-StkFac*/ - F-InvFis = 0 THEN NEXT.
    /********************************/

    /* GENERAMOS DETALLE SEGUN TIPO DE INVENTARIO */
    IF (C-TpoInv = "P" AND (AVAILABLE InvRecont OR AVAILABLE InvConteo)) OR 
        C-TpoInv = "T" THEN DO:
       F-VALCTO = IF F-STKGEN <> 0 THEN F-VALCTO ELSE 0.
       CREATE T-report.
       ASSIGN T-report.Llave-C    = almmmatg.CodMat
              T-report.Campo-c[1] = Almmmatg.DesMat
              T-report.Campo-c[2] = Almmmatg.UndStk
              T-report.Campo-c[3] = S-CODALM
              T-report.Campo-f[1] = F-STKGEN
              T-report.Campo-f[2] = F-VALCTO
              T-report.Campo-f[4] = F-CtoRep 
              T-report.Campo-f[3] = F-STKALM /*+ F-StkFac*/ 
              T-report.Campo-f[6] = F-InvFis - T-report.Campo-f[3].
              T-report.Campo-f[7] = x-inventario.
     
       IF F-STKALM = 0 AND F-InvFis < 0 THEN T-report.Campo-f[6] = 0.  
       
       I-NROITM = I-NROITM + 1.
       
    END.
END.

HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY C-ALMCEN D-FCHINV DesdeC HastaC C-DESALM I-TpoCto ICodMon 
      WITH FRAME D-Dialog.
  ENABLE RECT-18 RECT-16 RECT-19 D-FCHINV DesdeC HastaC Btn_OK Btn_Cancel 
         I-TpoCto ICodMon 
      WITH FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Ajuste-Ingreso D-Dialog 
PROCEDURE Genera-Ajuste-Ingreso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 define input parameter x-inven as integer.
 FIND Almtdocm WHERE 
      Almtdocm.CodCia = s-codcia AND
      Almtdocm.CodAlm = S-CODALM AND Almtdocm.TipMov = 'I' AND
      Almtdocm.CodMov = 01 NO-ERROR.
 if not avail  Almtdocm then do:
     message "El Movimiento 01 no esta definido en Autorización de Movimientos" skip 
     "el programa será abortado" view-as alert-box.
 end.     
 
 CREATE Almcmov.
 ASSIGN Almcmov.CodCia  = Almtdocm.CodCia 
        Almcmov.CodAlm  = Almtdocm.CodAlm 
        Almcmov.TipMov  = Almtdocm.TipMov
        Almcmov.CodMov  = Almtdocm.CodMov
        Almcmov.Observ  = 'AJUSTE POR DIFERENCIA DE INVENTARIO ' + string(today,"99/99/99") + string(time,"HH:MM") + S-USER-ID
        Almcmov.usuario = S-USER-ID
        Almcmov.Fchdoc  = InvConfig.FchInv
        Almcmov.Tpocmb  = X-TPOCMB.
 IF AVAILABLE Almtdocm THEN ASSIGN Almcmov.NroDoc = Almtdocm.NroDoc
                                   Almtdocm.NroDoc = Almtdocm.NroDoc + 1.
 RELEASE Almtdocm.
  
 FOR EACH T-REPORT WHERE T-report.Campo-f[6] > 0 AND T-report.Campo-f[7] = x-inven:
     CREATE almdmov.
     ASSIGN Almdmov.CodCia = Almcmov.CodCia 
            Almdmov.CodAlm = Almcmov.CodAlm 
            Almdmov.TipMov = Almcmov.TipMov 
            Almdmov.CodMov = Almcmov.CodMov 
            Almdmov.NroDoc = Almcmov.NroDoc 
            Almdmov.CodMon = Almcmov.CodMon 
            Almdmov.FchDoc = Almcmov.FchDoc 
            Almdmov.TpoCmb = Almcmov.TpoCmb
            Almdmov.codmat = T-report.Llave-C
            Almdmov.CanDes = T-report.Campo-f[6]
            Almdmov.CodUnd = T-report.Campo-c[2]
            Almdmov.Factor = 1.
            
     IF I-TpoCto = 1 THEN 
        ASSIGN Almdmov.PreUni = ROUND(T-report.Campo-f[2] / T-report.Campo-f[1], 4).
     ELSE 
        ASSIGN Almdmov.PreUni = ROUND(T-report.Campo-f[4], 4).
        
     ASSIGN Almdmov.ImpCto = Almdmov.Preuni * Almdmov.Candes
            Almdmov.CodAjt = ''
                   R-ROWID = ROWID(Almdmov).
     FIND FIRST Almtmovm WHERE 
                Almtmovm.CodCia = Almcmov.CodCia AND
                Almtmovm.Tipmov = Almcmov.TipMov AND 
                Almtmovm.Codmov = Almcmov.CodMov NO-LOCK NO-ERROR.
     IF AVAILABLE Almtmovm AND Almtmovm.PidPCo THEN ASSIGN Almdmov.CodAjt = "A".
     ELSE ASSIGN Almdmov.CodAjt = ''.
/*     RUN ALM\ALMACSTK (R-ROWID).*/
     /*
     RUN ALM\ALMACPR1 (R-ROWID,"U").
     RUN ALM\ALMACPR2 (R-ROWID,"U").
     */
 END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Ajuste-Salida D-Dialog 
PROCEDURE Genera-Ajuste-Salida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 define input parameter x-inven as integer.
 FIND Almtdocm WHERE 
      Almtdocm.CodCia = s-codcia AND
      Almtdocm.CodAlm = S-CODALM AND Almtdocm.TipMov = 'S' AND
      Almtdocm.CodMov = 01 NO-ERROR.

 if not avail  Almtdocm then do:
     message "El Movimiento 01 no esta definido en Autorización de Movimientos" skip 
     "el programa será abortado" view-as alert-box.
 end.     
      
 CREATE Almcmov.
 ASSIGN Almcmov.CodCia  = Almtdocm.CodCia 
        Almcmov.CodAlm  = Almtdocm.CodAlm 
        Almcmov.TipMov  = Almtdocm.TipMov
        Almcmov.CodMov  = Almtdocm.CodMov
        Almcmov.Observ  = 'AJUSTE POR DIFERENCIA DE INVENTARIO ' + string(today,"99/99/99") + string(time,"HH:MM") + S-USER-ID
        Almcmov.usuario = S-USER-ID
        Almcmov.Fchdoc  = InvConfig.FchInv
        Almcmov.Tpocmb  = X-TPOCMB.
 IF AVAILABLE Almtdocm THEN ASSIGN Almcmov.NroDoc = Almtdocm.NroDoc
                                   Almtdocm.NroDoc = Almtdocm.NroDoc + 1.
 RELEASE Almtdocm.
  
 FOR EACH T-REPORT WHERE T-report.Campo-f[6] < 0 AND T-report.Campo-f[7] = x-inven:
     CREATE almdmov.
     ASSIGN Almdmov.CodCia = Almcmov.CodCia 
            Almdmov.CodAlm = Almcmov.CodAlm 
            Almdmov.TipMov = Almcmov.TipMov 
            Almdmov.CodMov = Almcmov.CodMov 
            Almdmov.NroDoc = Almcmov.NroDoc 
            Almdmov.CodMon = Almcmov.CodMon 
            Almdmov.FchDoc = Almcmov.FchDoc 
            Almdmov.TpoCmb = Almcmov.TpoCmb
            Almdmov.codmat = T-report.Llave-C
            Almdmov.CanDes = ABS(T-report.Campo-f[6])
            Almdmov.CodUnd = T-report.Campo-c[2]
            Almdmov.Factor = 1
            Almdmov.PreUni = ROUND(T-report.Campo-f[2] / T-report.Campo-f[1], 4)
            Almdmov.ImpCto = Almdmov.Preuni * Almdmov.Candes
            Almdmov.CodAjt = ''
                   R-ROWID = ROWID(Almdmov).
     FIND FIRST Almtmovm WHERE 
                Almtmovm.CodCia = Almcmov.CodCia AND
                Almtmovm.Tipmov = Almcmov.TipMov AND 
                Almtmovm.Codmov = Almcmov.CodMov NO-LOCK NO-ERROR.
     IF AVAILABLE Almtmovm AND Almtmovm.PidPCo THEN ASSIGN Almdmov.CodAjt = "A".
     ELSE ASSIGN Almdmov.CodAjt = ''.
/*     RUN ALM\ALMDGSTK (R-ROWID).*/
     /*
     RUN ALM\ALMACPR1 (R-ROWID,"U").
     RUN ALM\ALMACPR2 (R-ROWID,"U").
     */
 END.
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
  DO WITH FRAME {&FRAME-NAME}:
     FIND LAST InvConfig WHERE InvConfig.CodCia = S-CODCIA AND 
                               InvConfig.CodAlm = S-CODALM NO-LOCK NO-ERROR.
     
     IF AVAILABLE InvConfig THEN ASSIGN D-FCHINV = InvConfig.FchInv.
     
     FIND gn-tcmb WHERE gn-tcmb.fecha <= InvConfig.FchInv NO-LOCK NO-ERROR.
     
     IF AVAILABLE gn-tcmb THEN X-TPOCMB = gn-tcmb.compra.
     
     ASSIGN  C-ALMCEN = S-CODALM
             C-DESALM = S-DESALM.
     DISPLAY C-ALMCEN 
             C-DESALM 
             D-FCHINV. 
     ASSIGN ICodMon:SENSITIVE = YES.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Proceso D-Dialog 
PROCEDURE Proceso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR OK-I AS LOGICAL NO-UNDO.
    DEFINE VAR OK-S AS LOGICAL NO-UNDO.
    DEFINE VAR OK-IT AS LOGICAL NO-UNDO.
    DEFINE VAR OK-ST AS LOGICAL NO-UNDO.
    
    HastaC = TRIM(HastaC) + 'ZZZZZZ'.
    
    
    FIND InvConfig WHERE 
         InvConfig.CodCia = S-CODCIA AND
         InvConfig.CodAlm = S-CODALM AND
         InvConfig.FchInv = D-FCHINV NO-LOCK NO-ERROR.
    
    IF NOT AVAILABLE InvConfig THEN DO:
       MESSAGE "No existe la configuracion de inventario" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    
    C-TpoInv = InvConfig.TipInv.
    C-OP = C-OP + "~nGsFchInv = " + STRING(InvConfig.FchInv,"99/99/9999"). 
    
    RUN Carga-Tempo.
    
    IF I-NROITM = 0 THEN DO:
       MESSAGE "No existen registros por actualizar" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    OK-I  = FALSE.
    OK-S  = FALSE.
    OK-IT = FALSE.
    OK-ST = FALSE.


    FOR EACH T-REPORT:
        IF T-report.Campo-f[6] > 0 AND T-report.Campo-f[7] = 1 THEN OK-I  = TRUE.
        IF T-report.Campo-f[6] < 0 AND T-report.Campo-f[7] = 1 THEN OK-S  = TRUE.
        IF T-report.Campo-f[6] > 0 AND T-report.Campo-f[7] = 0 THEN OK-IT = TRUE.
        IF T-report.Campo-f[6] < 0 AND T-report.Campo-f[7] = 0 THEN OK-ST = TRUE.
    END.
    
    IF OK-I  THEN RUN Genera-Ajuste-Ingreso(1).
    IF OK-S  THEN RUN Genera-Ajuste-Salida(1).
    IF OK-IT THEN RUN Genera-Ajuste-Ingreso(0).
    IF OK-ST THEN RUN Genera-Ajuste-Salida(0).

         
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
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


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION STOCKFACTURA D-Dialog 
FUNCTION STOCKFACTURA RETURNS DECIMAL
   (INPUT X-CODMAT AS CHAR) :
   DEFINE VAR X-STOCK AS DECIMAL INIT 0.
   
   RETURN X-STOCK.
   
   FOR EACH ALMDMOV WHERE 
            ALMDMOV.CodCia = S-CodCia AND
            ALMDMOV.CodMat = ALMMMATG.CodMat AND
            ALMDMOV.TipMov = 'S' AND
            ALMDMOV.CodMov = 02 
            USE-INDEX ALMD02 NO-LOCK:
                  
       FIND FIRST CCBCDOCU WHERE 
                  CCBCDOCU.CodCia = S-CodCia AND
                  CCBCDOCU.CodDoc = 'G/R'    AND 
                  CCBCDOCU.NroDoc = STRING(ALMDMOV.NroSer,'999') + STRING(ALMDMOV.NroDoc,'999999') AND
                  CCBCDOCU.Flgest <> 'A' AND
                  CCBCDOCU.FchDoc <= INVCONFIG.FchInv 
                  USE-INDEX LLAVE01 NO-LOCK NO-ERROR.
                  
       IF AVAILABLE CCBCDOCU THEN DO:
          /* cantidad en reserva */
          IF CcbCDocu.FlgAte = 'P' THEN
             X-STOCK = X-STOCK + (ALMDMOV.Factor * ALMDMOV.CanDes).
          ELSE DO:
             IF CCBCDOCU.FchAte > INVCONFIG.FchInv THEN 
                X-STOCK = X-STOCK + (ALMDMOV.Factor * ALMDMOV.CanDes).
          END.
       END.  
   END.      
            
   FOR EACH CcbDDocu WHERE 
            CcbDDocu.CodCia = s-codcia AND 
            CcbDDocu.codmat = x-codmat,
            FIRST CcbCDocu OF CcbDDocu WHERE
                  CcbCDocu.Flgest <> 'A' AND
                  CCBCDOCU.FchDoc <= INVCONFIG.FchInv
                  NO-LOCK:
       /* cantidad en reserva */
       IF CcbCDocu.FlgAte = 'P' THEN
          X-STOCK = X-STOCK + (CcbDDocu.Factor * CcbDDocu.CanDes).
       ELSE DO:
          IF CCBCDOCU.FchAte > INVCONFIG.FchInv THEN 
             X-STOCK = X-STOCK + (CcbDDocu.Factor * CcbDDocu.CanDes).
       END. 
   END.     
          
   RETURN X-STOCK.   /* Function return value. */
          
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


