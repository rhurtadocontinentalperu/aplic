&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE SHARED TEMP-TABLE PEDI NO-UNDO LIKE Facdpedi.
DEFINE BUFFER PEDIDO FOR FacCPedi.



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

/* Public Variable Definitions ---                                       */
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE s-codref   AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHARACTER.
DEFINE        VARIABLE S-NROCOT   AS CHARACTER.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE s-adm-new-record AS CHAR.
DEFINE SHARED VARIABLE s-NroSer AS INTEGER.
DEFINE SHARED VARIABLE s-FlgEmpaque LIKE gn-divi.FlgEmpaque.
DEFINE SHARED VARIABLE s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEFINE SHARED VARIABLE s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEFINE SHARED VARIABLE S-TPOPED AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE T-SALDO     AS DECIMAL.
DEFINE VARIABLE F-totdias   AS INTEGER NO-UNDO.
DEFINE VARIABLE s-FlgEnv AS LOG NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK.

DEFINE BUFFER B-CPEDI FOR Faccpedi.
DEFINE BUFFER B-DPEDI FOR Facdpedi.
DEFINE BUFFER B-MATG  FOR Almmmatg.

DEFINE VAR x-ClientesVarios AS CHAR INIT '11111111111'.     /* 06.02.08 */
x-ClientesVarios =  FacCfgGn.CliVar.                        /* 07.09.09 */

/* 07.09.09 Variable para el Tracking */
DEFINE VAR s-FechaHora AS CHAR.
DEFINE VAR s-FechaI AS DATETIME NO-UNDO.
DEFINE VAR s-FechaT AS DATETIME NO-UNDO.

/* MENSAJES DE ERROR Y DEL SISTEMA */
DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR pMensajeFinal AS CHAR NO-UNDO.

DEFINE VAR d-FechaEntrega AS DATE.  /* Ic - 13may2015 */

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
&Scoped-define EXTERNAL-TABLES Faccpedi
&Scoped-define FIRST-EXTERNAL-TABLE Faccpedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Faccpedi.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS FacCPedi.FaxCli FacCPedi.CodAlm ~
FacCPedi.fchven FacCPedi.CodCli FacCPedi.NomCli FacCPedi.DirCli ~
FacCPedi.Glosa FacCPedi.CodRef FacCPedi.NroRef FacCPedi.MotReposicion ~
FacCPedi.VtaPuntual 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.FaxCli ~
FacCPedi.FchPed FacCPedi.CodAlm FacCPedi.fchven FacCPedi.CodCli ~
FacCPedi.NomCli FacCPedi.FchEnt FacCPedi.AlmacenXD FacCPedi.usuario ~
FacCPedi.DirCli FacCPedi.UsrAct FacCPedi.Glosa FacCPedi.FecAct ~
FacCPedi.CodRef FacCPedi.NroRef FacCPedi.HorAct FacCPedi.MotReposicion ~
FacCPedi.VtaPuntual 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado f-NomAlm f-AlmacenXD 

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
DEFINE VARIABLE f-AlmacenXD AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81
     BGCOLOR 14 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE f-NomAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .81
     BGCOLOR 8 FGCOLOR 0  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1 COL 16 COLON-ALIGNED
          LABEL "Numero" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 15 FGCOLOR 1 FONT 0
     F-Estado AT ROW 1 COL 40 COLON-ALIGNED NO-LABEL
     FacCPedi.FaxCli AT ROW 1 COL 74 COLON-ALIGNED NO-LABEL WIDGET-ID 120 FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
     FacCPedi.FchPed AT ROW 1 COL 99 COLON-ALIGNED
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodAlm AT ROW 1.81 COL 16 COLON-ALIGNED WIDGET-ID 110
          LABEL "Almacén Despacho"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          BGCOLOR 8 FGCOLOR 0 
     f-NomAlm AT ROW 1.81 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 112
     FacCPedi.fchven AT ROW 1.81 COL 99 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodCli AT ROW 2.62 COL 16 COLON-ALIGNED HELP
          ""
          LABEL "Almacén Destino" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FacCPedi.NomCli AT ROW 2.62 COL 22 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
     FacCPedi.FchEnt AT ROW 2.62 COL 99 COLON-ALIGNED WIDGET-ID 124
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
     FacCPedi.AlmacenXD AT ROW 3.42 COL 16 COLON-ALIGNED WIDGET-ID 140
          LABEL "Destino Final" FORMAT "x(12)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
          BGCOLOR 14 FGCOLOR 0 
     f-AlmacenXD AT ROW 3.42 COL 29 COLON-ALIGNED NO-LABEL WIDGET-ID 142
     FacCPedi.usuario AT ROW 3.42 COL 99 COLON-ALIGNED WIDGET-ID 34
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.DirCli AT ROW 4.23 COL 16 COLON-ALIGNED
          LABEL "Dirección" FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 66 BY .81
     FacCPedi.UsrAct AT ROW 4.23 COL 99 COLON-ALIGNED WIDGET-ID 138
          LABEL "Modificado por" FORMAT "x(10)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.Glosa AT ROW 5.04 COL 13.28 FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 66 BY .81
     FacCPedi.FecAct AT ROW 5.04 COL 99 COLON-ALIGNED WIDGET-ID 134
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodRef AT ROW 5.85 COL 16 COLON-ALIGNED WIDGET-ID 126
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
     FacCPedi.NroRef AT ROW 5.85 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 122 FORMAT "X(254)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
          BGCOLOR 15 FGCOLOR 4 
     FacCPedi.HorAct AT ROW 5.85 COL 99 COLON-ALIGNED WIDGET-ID 136
          LABEL "Hora"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.MotReposicion AT ROW 6.65 COL 16 COLON-ALIGNED WIDGET-ID 132
          LABEL "Motivo"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Item 1","Item 1"
          DROP-DOWN-LIST
          SIZE 66 BY 1
     FacCPedi.VtaPuntual AT ROW 6.65 COL 101 WIDGET-ID 130
          LABEL "URGENTE"
          VIEW-AS TOGGLE-BOX
          SIZE 11.29 BY .77
          BGCOLOR 12 FGCOLOR 15 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.Faccpedi
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: PEDI T "SHARED" NO-UNDO INTEGRAL Facdpedi
      TABLE: PEDIDO B "?" ? INTEGRAL FacCPedi
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
         HEIGHT             = 6.88
         WIDTH              = 122.14.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN FacCPedi.AlmacenXD IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.CodAlm IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN FacCPedi.DirCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN f-AlmacenXD IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomAlm IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FaxCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.FchEnt IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.fchven IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.FecAct IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN FacCPedi.HorAct IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR COMBO-BOX FacCPedi.MotReposicion IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.NroRef IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.UsrAct IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX FacCPedi.VtaPuntual IN FRAME F-Main
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

&Scoped-define SELF-NAME FacCPedi.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Almacén Destino */
DO:
    MESSAGE 'NO debería pasar por LEAVE Faccpedi.codcli'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.NomCli V-table-Win
ON LEAVE OF FacCPedi.NomCli IN FRAME F-Main /* Nombre */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Item V-table-Win 
PROCEDURE Actualiza-Item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE PEDI.
  FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.Libre_c05 <> 'OF'    /* SIN PROMOCIONES */
      BREAK BY Facdpedi.codmat:
      CREATE PEDI.
      BUFFER-COPY Facdpedi TO PEDI.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Pedido V-table-Win 
PROCEDURE Actualiza-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER X-Tipo AS INTEGER NO-UNDO.
  
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      {lib/lock-genericov3.i
          &Tabla="B-CPEDI"
          &Condicion="B-CPedi.CodCia=FacCPedi.CodCia ~
          AND B-CPedi.CodDoc=FacCPedi.CodRef ~
          AND B-CPedi.NroPed=FacCPedi.NroRef"
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
          &Accion="RETRY"
          &Mensaje="YES"
          &TipoError="UNDO, RETURN 'ADM-ERROR'"
          }
      FOR EACH FacdPedi OF FaccPedi NO-LOCK,
          FIRST B-DPedi OF B-CPedi WHERE B-DPedi.CodMat = FacDPedi.CodMat
          AND B-DPedi.Libre_c05 = FacDPedi.Libre_c05:
          ASSIGN
              B-DPEDI.CanAte = B-DPEDI.CanAte + x-Tipo * (FacDPedi.CanPed - FacDPedi.CanAte).
      END.

      IF x-Tipo = -1 THEN DO:
          IF NOT CAN-FIND(FIRST B-DPEDI OF B-CPEDI WHERE B-DPEDI.CanAte <> 0 NO-LOCK)
              THEN B-CPedi.FlgEst = "G".     /* Generado */
      END.
      IF x-Tipo = +1 THEN B-CPedi.FlgEst = "C".
      IF AVAILABLE B-CPEDI THEN RELEASE B-CPedi.
      IF AVAILABLE B-DPEDI THEN RELEASE B-DPedi.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Pedido-Ventas V-table-Win 
PROCEDURE Actualiza-Pedido-Ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* La OTR es un reflejo del PED */                       
DEF BUFFER B-DPEDI FOR Facdpedi.    
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Bloqueamos el PED */
    FIND PEDIDO WHERE PEDIDO.codcia = s-codcia
        AND PEDIDO.coddoc = Faccpedi.codref
        AND PEDIDO.nroped = Faccpedi.nroref
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    FIND COTIZACION WHERE COTIZACION.codcia = s-codcia
        AND COTIZACION.coddiv = PEDIDO.coddiv
        AND COTIZACION.coddoc = PEDIDO.codref
        AND COTIZACION.nroped = PEDIDO.nroref
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.canped > 0,
        FIRST B-DPEDI OF PEDIDO EXCLUSIVE-LOCK WHERE B-DPEDI.codmat = Facdpedi.codmat:
        ASSIGN
            B-DPEDI.CanPed = Facdpedi.CanPed    /* OJO */
            B-DPEDI.CanAte = Facdpedi.CanPed.
    END.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.canped > 0,
        FIRST B-DPEDI OF COTIZACION EXCLUSIVE-LOCK WHERE B-DPEDI.codmat = Facdpedi.codmat:
        ASSIGN
            B-DPEDI.CanAte = B-DPEDI.CanAte + Facdpedi.CanPed.
    END.
    ASSIGN
        COTIZACION.FlgEst = "C".
    IF CAN-FIND(FIRST B-DPEDI OF COTIZACION WHERE B-DPEDI.CanPed > B-DPEDI.CanAte NO-LOCK)
        THEN COTIZACION.FlgEst = "P".
    ASSIGN
        PEDIDO.FlgEst = "C".
    FOR EACH B-DPEDI OF PEDIDO EXCLUSIVE-LOCK WHERE B-DPEDI.CanPed <= 0:
        DELETE B-DPEDI.
    END.
    RELEASE PEDIDO.
    RELEASE COTIZACION.
    RELEASE B-DPEDI.
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
  {src/adm/template/row-list.i "Faccpedi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Faccpedi"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Anula-SubOrden V-table-Win 
PROCEDURE Anula-SubOrden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Borramos si hubiera una anterior */
FOR EACH Vtacdocu WHERE VtaCDocu.CodCia = Faccpedi.codcia
    AND VtaCDocu.CodDiv = Faccpedi.coddiv
    AND VtaCDocu.CodPed = Faccpedi.coddoc
    AND VtaCDocu.NroPed BEGINS Faccpedi.nroped:
    ASSIGN Vtacdocu.FlgEst = "A".
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Cotizacion V-table-Win 
PROCEDURE Asigna-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       

    Modificó    : Miguel Landeo /*ML01*/
    Fecha       : 13/Nov/2009
    Objetivo    : Captura Múltiplo configurado por artículo - cliente.
  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.
  DEFINE VARIABLE F-CANPED AS DECIMAL NO-UNDO.
  DEFINE VARIABLE x-StkAct AS DEC NO-UNDO.
  DEFINE VARIABLE x-CodAlm AS CHAR NO-UNDO.
  DEFINE VARIABLE i AS INT NO-UNDO.

  DEFINE FRAME F-Mensaje
    'Procesando: ' Almdrepo.codmat SKIP(1)
    'Espere un momento por favor ...' SKIP
    WITH CENTERED NO-LABELS OVERLAY VIEW-AS DIALOG-BOX TITLE 'TRASLADANDO SOLICITUD DE TRANSFERENCIA'.

  EMPTY TEMP-TABLE PEDI.

  i-NPedi = 0.
  /* ************************************************* */
  /* RHC 23/08/17 Simplificación del proceso Max Ramos */
  /* ************************************************* */
  DEF VAR t-AlmDes AS CHAR NO-UNDO.
  DEF VAR t-CanPed AS DEC NO-UNDO.
  FOR EACH Almdrepo OF Almcrepo NO-LOCK WHERE (Almdrepo.CanApro - Almdrepo.CanAten) > 0,
      FIRST Almmmatg OF Almdrepo NO-LOCK:
      DISPLAY Almdrepo.codmat WITH FRAME F-Mensaje.
      f-Factor = 1.
      t-AlmDes = ''.
      t-CanPed = 0.
      F-CANPED = (Almdrepo.CanApro - Almdrepo.CanAten).
      x-CodAlm = s-CodAlm.
      /* DEFINIMOS LA CANTIDAD */
      x-CanPed = f-CanPed * f-Factor.
      IF f-CanPed <= 0 THEN NEXT.
      IF f-CanPed > t-CanPed THEN DO:
          t-CanPed = f-CanPed.
          t-AlmDes = x-CodAlm.
      END.
      /* GRABACION */
      I-NPEDI = I-NPEDI + 1.
      CREATE PEDI.
      BUFFER-COPY Almdrepo 
          EXCEPT Almdrepo.CanReq Almdrepo.CanApro
          TO PEDI
          ASSIGN 
              PEDI.CodCia = s-codcia
              PEDI.CodDiv = s-coddiv
              PEDI.CodDoc = s-coddoc
              PEDI.NroPed = ''
              PEDI.ALMDES = t-AlmDes  /* *** OJO *** */
              PEDI.NroItm = I-NPEDI
              PEDI.CanPed = t-CanPed    /* << OJO << */
              PEDI.CanAte = 0.
      ASSIGN
          PEDI.Libre_d01 = (Almdrepo.CanApro - Almdrepo.CanAten)
          PEDI.Libre_d02 = t-CanPed
          PEDI.Libre_c01 = '*'.
      ASSIGN
          PEDI.UndVta = Almmmatg.UndBas.
  END.

/*
  /* SE ATIENDE LO QUE HAY, LO QUE QUEDA YA NO SE ATIENDE */
  /* PRIMERA PASADA: CARGAMOS STOCK DISPONIBLE */
  /* RHC 25.08.2014 NO MAS DE 52 ITEMS (13 * 4) */
  DEF VAR t-AlmDes AS CHAR NO-UNDO.
  DEF VAR t-CanPed AS DEC NO-UNDO.
  DETALLES:
  FOR EACH Almdrepo OF Almcrepo NO-LOCK WHERE (Almdrepo.CanApro - Almdrepo.CanAten) > 0,
      FIRST Almmmatg OF Almdrepo NO-LOCK:
      DISPLAY Almdrepo.codmat WITH FRAME F-Mensaje.
      /* BARREMOS LOS ALMACENES VALIDOS Y DECIDIMOS CUAL ES EL MEJOR DESPACHO */
      /* RHC AHORA ES UN SOLO ALMACEN */
      f-Factor = 1.
      t-AlmDes = ''.
      t-CanPed = 0.
      ALMACENES:
      DO i = 1 TO NUM-ENTRIES(s-CodAlm):
          F-CANPED = (Almdrepo.CanApro - Almdrepo.CanAten).
          x-CodAlm = ENTRY(i, s-CodAlm).
          /* FILTROS */
          FIND Almmmate WHERE Almmmate.codcia = s-codcia
              AND Almmmate.codalm = x-CodAlm  /* *** OJO *** */
              AND Almmmate.codmat = Almdrepo.CodMat
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Almmmate THEN DO:
              MESSAGE 'Producto' Almdrepo.codmat 'NO asignado al almacén' x-CodAlm
                  VIEW-AS ALERT-BOX WARNING.
              NEXT ALMACENES.
          END.
          x-StkAct = Almmmate.StkAct.
          RUN vta2/Stock-Comprometido-v2 (Almdrepo.CodMat, x-CodAlm, OUTPUT s-StkComprometido).
          s-StkDis = x-StkAct - s-StkComprometido + (f-CanPed * f-Factor).
          
          /* DEFINIMOS LA CANTIDAD */
          x-CanPed = f-CanPed * f-Factor.
          IF s-StkDis <= 0 THEN NEXT ALMACENES.

          IF s-StkDis < x-CanPed THEN DO:
              f-CanPed = ((S-STKDIS - (S-STKDIS MODULO f-Factor)) / f-Factor).
          END.
          /* EMPAQUE OTROS */
          IF s-FlgEmpaque = YES THEN DO:
              IF Almmmatg.DEC__03 > 0 THEN f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).
          END.
          f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).
          IF f-CanPed <= 0 THEN NEXT ALMACENES.
          IF f-CanPed > t-CanPed THEN DO:
              t-CanPed = f-CanPed.
              t-AlmDes = x-CodAlm.
          END.
      END.
      IF t-CanPed > 0 THEN DO:
          /* GRABACION */
          I-NPEDI = I-NPEDI + 1.
          CREATE PEDI.
          BUFFER-COPY Almdrepo 
              EXCEPT Almdrepo.CanReq Almdrepo.CanApro
              TO PEDI
              ASSIGN 
                  PEDI.CodCia = s-codcia
                  PEDI.CodDiv = s-coddiv
                  PEDI.CodDoc = s-coddoc
                  PEDI.NroPed = ''
                  PEDI.ALMDES = t-AlmDes  /* *** OJO *** */
                  PEDI.NroItm = I-NPEDI
                  PEDI.CanPed = t-CanPed    /* << OJO << */
                  PEDI.CanAte = 0.
          ASSIGN
              PEDI.Libre_d01 = (Almdrepo.CanApro - Almdrepo.CanAten)
              PEDI.Libre_d02 = t-CanPed
              PEDI.Libre_c01 = '*'.
          ASSIGN
              PEDI.UndVta = Almmmatg.UndBas.
          /* FIN DE CARGA */
      END.
  END.
*/  
  
  HIDE FRAME F-Mensaje.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Datos V-table-Win 
PROCEDURE Asigna-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT AVAILABLE FacCPedi THEN DO:
        MESSAGE 'Pedido NO Disponible'  VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.                                                        

    IF FaccPedi.FchVen < TODAY THEN DO:
       MESSAGE 'Pedido vencido' VIEW-AS ALERT-BOX ERROR.
       UNDO, RETURN 'ADM-ERROR'.
    END.
    IF LOOKUP (FacCPedi.FlgEst,"X,G,P") > 0 THEN DO:
        RUN vta/w-agtrans-02 (Faccpedi.codcia, Faccpedi.coddiv, Faccpedi.coddoc, Faccpedi.nroped).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Pedido V-table-Win 
PROCEDURE Borra-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER p-Ok AS LOG.
  
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FOR EACH Facdpedi OF Faccpedi:
          IF p-Ok = YES THEN DELETE Facdpedi.
          ELSE Facdpedi.FlgEst = 'A'.   /* <<< OJO <<< */
      END.    
  END.
  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Despachar-Pedido V-table-Win 
PROCEDURE Despachar-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Faccpedi THEN RETURN.
IF Faccpedi.flgest <> "G" THEN RETURN.
MESSAGE 'El Pedido está listo para ser despachado' SKIP
      'Continuamos?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
IF rpta = NO THEN RETURN.

/* Cliente */
FIND Gn-clie WHERE Gn-clie.codcia = cl-codcia
    AND Gn-clie.codcli = Faccpedi.codcli
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Gn-clie THEN DO:
    MESSAGE 'Cliente NO registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
/* Revisar datos del Transportista */
FIND Ccbadocu WHERE Ccbadocu.codcia = Faccpedi.codcia
    AND Ccbadocu.coddoc = Faccpedi.coddoc
    AND Ccbadocu.nrodoc = Faccpedi.nroped
    AND Ccbadocu.coddiv = Faccpedi.coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbadocu THEN DO:
    MESSAGE 'Aún NO ha ingresado los datos del transportista' SKIP
        'Continuamos?'
        VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE rpta-1 AS LOG.
    IF rpta-1 = NO THEN RETURN.
END.

FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE Faccpedi THEN RETURN.

{vta2/verifica-cliente-01.i}

/* RHC 22.11.2011 Verificamos los margenes y precios */
IF Faccpedi.FlgEst = "X" THEN DO:
    FIND CURRENT Faccpedi NO-LOCK.
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
    RETURN.   /* NO PASO LINEA DE CREDITO */
END.
IF LOOKUP(s-CodDiv, '00000,00017,00018') > 0 THEN DO:
    {vta2/i-verifica-margen-utilidad-1.i}
END.
FIND CURRENT Faccpedi NO-LOCK.

DEF VAR pMensaje AS CHAR NO-UNDO.
RUN vta2/pcreaordendesp (ROWID(Faccpedi), OUTPUT pMensaje).
IF RETURN-VALUE = 'ADM-ERROR' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.

RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel V-table-Win 
PROCEDURE Excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE chExcelApplication AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorkbook AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE chWorksheet AS COM-HANDLE NO-UNDO.
    DEFINE VARIABLE cColumn AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cRange AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iRow AS INTEGER NO-UNDO INITIAL 1.

    DEFINE VARIABLE cNomCli AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNomVen AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cMoneda AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cNomCon AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cOrdCom AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dPreUni LIKE FacDPedi.Preuni NO-UNDO.
    DEFINE VARIABLE dImpLin LIKE FacDPedi.ImpLin NO-UNDO.
    DEFINE VARIABLE dImpTot LIKE FacCPedi.ImpTot NO-UNDO.

    DEFINE BUFFER b-facdpedi FOR facdpedi.

    IF FacCpedi.FlgIgv THEN DO:
       dImpTot = FacCPedi.ImpTot.
    END.
    ELSE DO:
       dImpTot = FacCPedi.ImpVta.
    END.

    FIND gn-ven WHERE 
         gn-ven.CodCia = FacCPedi.CodCia AND  
         gn-ven.CodVen = FacCPedi.CodVen 
         NO-LOCK NO-ERROR.
    cNomVen = FacCPedi.CodVen.
    IF AVAILABLE gn-ven THEN cNomVen = cNomVen + " - " + gn-ven.NomVen.
    FIND gn-clie WHERE 
         gn-clie.codcia = cl-codcia AND  
         gn-clie.codcli = FacCPedi.codcli NO-LOCK NO-ERROR.
     
    cNomCli  = FacCPedi.CodCli + ' - ' + FaccPedi.Nomcli.

    IF FacCPedi.coddoc = "PED" THEN 
        cOrdCom = "Orden de Compra : ".
    ELSE 
        cOrdCom = "Solicitud Cotiz.: ".

    FIND gn-ConVt WHERE gn-ConVt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
    cNomCon = FacCPedi.FmaPgo.
    IF AVAILABLE gn-ConVt THEN cNomCon = gn-ConVt.Nombr.

    IF FacCpedi.Codmon = 2 THEN cMoneda = "DOLARES US$.".
    ELSE cMoneda = "SOLES   S/. ".

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:ADD().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:ITEM(1).

    /* set the column names for the Worksheet */
    chWorkSheet:COLUMNS("A"):ColumnWidth = 4.
    chWorkSheet:COLUMNS("A"):NumberFormat = "@".
    chWorkSheet:COLUMNS("B"):ColumnWidth = 11.43.
    chWorkSheet:COLUMNS("B"):NumberFormat = "@".
    chWorkSheet:COLUMNS("C"):ColumnWidth = 45.
    chWorkSheet:COLUMNS("C"):NumberFormat = "@".
    chWorkSheet:COLUMNS("D"):ColumnWidth = 14.

    cColumn = STRING(iRow).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Número:".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = FacCPedi.NroPed.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Fecha:".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = faccpedi.fchped. 
    iRow = iRow + 1.
    cColumn = STRING(iRow).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Cliente:". 
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = cNomCli. 
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Vencimiento:".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = faccpedi.fchven. 
    iRow = iRow + 1.
    cColumn = STRING(iRow).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Dirección :". 
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = gn-clie.dircli. 
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Tpo. Cambio:".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = FacCPedi.Tpocmb. 
    iRow = iRow + 1.
    cColumn = STRING(iRow).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "R.U.C.:". 
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = gn-clie.ruc. 
    iRow = iRow + 1.
    cColumn = STRING(iRow).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Vendedor:". 
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = cNomVen.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = cOrdCom.
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = faccpedi.ordcmp. 
    iRow = iRow + 1.
    cColumn = STRING(iRow).
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Cond.Venta:". 
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = cNomCon. 
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Moneda:".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = cMoneda. 

    iRow = iRow + 2.
    cColumn = STRING(iRow).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "No".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Artículo".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Descripción".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Marca".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Unidad".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Alm Des".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Cant. Solicitada".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Cant. Aprobada".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "% Descto".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Precio Unitario".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "Importe".
    chWorkSheet:Range(cRange):FONT:Bold = TRUE.

    FOR EACH b-facdpedi OF faccpedi NO-LOCK,
        FIRST almmmatg OF b-facdpedi NO-LOCK
        BREAK BY b-facdpedi.NroPed BY b-facdpedi.NroItm:
        IF FacCpedi.FlgIgv THEN DO:
            dPreUni = b-facdpedi.PreUni.
            dImpLin = b-facdpedi.ImpLin. 
        END.
        ELSE DO:
            dPreUni = ROUND(b-facdpedi.PreUni / (1 + FacCPedi.PorIgv / 100),2).
            dImpLin = ROUND(b-facdpedi.ImpLin / (1 + FacCPedi.PorIgv / 100),2). 
        END.  
        iRow = iRow + 1.
        cColumn = STRING(iRow).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):VALUE = STRING(b-facdpedi.nroitm, '>>>9').
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):VALUE = b-facdpedi.codmat.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):VALUE = almmmatg.desmat.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):VALUE = almmmatg.desmar.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):VALUE = b-facdpedi.undvta.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):VALUE = b-facdpedi.almdes.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):VALUE = b-facdpedi.canped.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):VALUE = b-facdpedi.canate.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):VALUE = b-facdpedi.pordto.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dPreUni.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):VALUE = dImpLin.
    END.

    iRow = iRow + 2.
    cColumn = STRING(iRow).
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):VALUE = "NETO A PAGAR:" + cMoneda.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):VALUE = dImpTot.
    /* PERCEPCION */
    IF Faccpedi.acubon[5] > 0 THEN DO:
        iRow = iRow + 4.
        cColumn = STRING(iRow).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = "* Operación sujeta a percepción del IGV: " +
            (IF FacCPedi.codmon = 1 THEN "S/." ELSE "US$") + 
            TRIM(STRING(Faccpedi.acubon[5], '>>>,>>9.99')).
    END.

    /* launch Excel so it is visible to the user */
    chExcelApplication:VISIBLE = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-Pedido-Ventas V-table-Win 
PROCEDURE Extorna-Pedido-Ventas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* La OTR es un reflejo del PED */                       
DEF BUFFER B-DPEDI FOR Facdpedi.    
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Bloqueamos el PED */
    FIND PEDIDO WHERE PEDIDO.codcia = s-codcia
        AND PEDIDO.coddoc = Faccpedi.codref
        AND PEDIDO.nroped = Faccpedi.nroref
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    FIND COTIZACION WHERE COTIZACION.codcia = s-codcia
        AND COTIZACION.coddiv = PEDIDO.coddiv
        AND COTIZACION.coddoc = PEDIDO.codref
        AND COTIZACION.nroped = PEDIDO.nroref
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    /* Extornamos detalle del PED */
    FOR EACH Facdpedi OF PEDIDO EXCLUSIVE-LOCK,
        FIRST B-DPEDI OF COTIZACION EXCLUSIVE-LOCK WHERE B-DPEDI.codmat = Facdpedi.codmat:
        /* Se actualiza el saldo en la cotización */
        ASSIGN
            B-DPEDI.CanAte = B-DPEDI.CanAte - Facdpedi.CanPed.
        /* Se extorna todo el pedido */
        ASSIGN
            Facdpedi.CanPed = 0
            Facdpedi.CanAte = 0.
    END.
    ASSIGN
        COTIZACION.FlgEst = "P".
    ASSIGN
        PEDIDO.FlgEst = "A".
    RELEASE PEDIDO.
    RELEASE COTIZACION.
    RELEASE B-DPEDI.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-SubOrden V-table-Win 
PROCEDURE Extorna-SubOrden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Borramos si hubiera una anterior */
FOR EACH Vtacdocu WHERE VtaCDocu.CodCia = Faccpedi.codcia
    AND VtaCDocu.CodDiv = Faccpedi.coddiv
    AND VtaCDocu.CodPed = Faccpedi.coddoc
    AND VtaCDocu.NroPed BEGINS Faccpedi.nroped:
    FOR EACH Vtaddocu OF Vtacdocu:
        DELETE Vtaddocu.
    END.
    DELETE Vtacdocu.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Facturas-Adelantadas V-table-Win 
PROCEDURE Facturas-Adelantadas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Control de Facturas Adelantadas */
  DEFINE VARIABLE x-saldo-mn AS DEC NO-UNDO.
  DEFINE VARIABLE x-saldo-me AS DEC NO-UNDO.


  GetLock:
  REPEAT ON STOP UNDO GetLock, RETRY GetLock ON ERROR UNDO GetLock, RETRY GetLock:
      FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE Faccpedi THEN LEAVE.
  END.
  ASSIGN
      x-saldo-mn = 0
      x-saldo-me = 0.
  FOR EACH Ccbcdocu USE-INDEX Llave06 NO-LOCK WHERE Ccbcdocu.codcia = Faccpedi.codcia
      AND Ccbcdocu.codcli = Faccpedi.CodCli
      AND Ccbcdocu.flgest = "P"
      AND Ccbcdocu.coddoc = "A/C":
      IF Ccbcdocu.CodMon = 1 THEN x-saldo-mn = x-saldo-mn + Ccbcdocu.SdoAct.
      ELSE x-saldo-me = x-saldo-me + Ccbcdocu.SdoAct.
  END.
  IF x-saldo-mn > 0 OR x-saldo-me > 0 THEN DO:
      MESSAGE 'Hay un SALDO de Factura(s) Adelantada(s) por aplicar' SKIP
          'Por aplicar NUEVOS SOLES:' x-saldo-mn SKIP
          'Por aplicar DOLARES:' x-saldo-me SKIP(1)
          'Aplicamos automáticamente a la factura?'
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
      IF rpta = YES THEN FacCPedi.TpoLic = YES.
      ELSE FacCPedi.TpoLic = NO.
  END.
  FIND CURRENT Faccpedi NO-LOCK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido V-table-Win 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO INIT 0.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.

  DEF VAR f-PreBas AS DEC NO-UNDO.
  DEF VAR f-PreVta AS DEC NO-UNDO.
  DEF VAR f-Dsctos AS DEC NO-UNDO.
  DEF VAR y-Dsctos AS DEC NO-UNDO.
  DEF VAR SW-LOG1  AS LOGI NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.

  /* POR CADA PEDI VOLVEMOS A VERIFICAR EL STOCK DISPONIBLE */
  /* Borramos data sobrante */
/*   FOR EACH PEDI WHERE PEDI.CanPed <= 0: */
/*       DELETE PEDI.                      */
/*   END.                                  */

  /* AHORA SÍ GRABAMOS EL PEDIDO */
  FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      I-NPEDI = I-NPEDI + 1.
      IF I-NPEDI > 52 THEN LEAVE.
      CREATE Facdpedi.
      BUFFER-COPY PEDI 
          TO Facdpedi
          ASSIGN
              Facdpedi.CodCia = Faccpedi.CodCia
              Facdpedi.CodDiv = Faccpedi.CodDiv
              Facdpedi.AlmDes = Faccpedi.CodAlm
              Facdpedi.coddoc = Faccpedi.coddoc
              Facdpedi.NroPed = Faccpedi.NroPed
              Facdpedi.FchPed = Faccpedi.FchPed
              Facdpedi.Hora   = Faccpedi.Hora 
              Facdpedi.FlgEst = Faccpedi.FlgEst
              FacDPedi.CanPick = FacDPedi.CanPed
              Facdpedi.NroItm = I-NPEDI.
      DELETE PEDI.
  END.
  
  /* verificamos que al menos exista 1 item grabado */
  FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi 
  THEN RETURN 'ADM-ERROR'.
  ELSE RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-SubOrden V-table-Win 
PROCEDURE Genera-SubOrden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN Extorna-SubOrden.
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
/* Los subpedidos se generan de acuerdo al SECTOR donde esten ubicados los productos */

/* SOLO para O/D control de Pickeo */
IF FacCPedi.FlgSit <> "T" THEN RETURN 'OK'.

/* El SECTOR forma parte del código de ubicación */
FOR EACH facdpedi OF faccpedi NO-LOCK,
    FIRST almmmate NO-LOCK WHERE Almmmate.CodCia = facdpedi.codcia
    AND Almmmate.CodAlm = facdpedi.almdes
    AND Almmmate.codmat = facdpedi.codmat
    BREAK BY SUBSTRING(Almmmate.CodUbi,1,2):
    IF FIRST-OF(SUBSTRING(Almmmate.CodUbi,1,2)) THEN DO:
        CREATE vtacdocu.
        BUFFER-COPY faccpedi TO vtacdocu
            ASSIGN 
            VtaCDocu.CodCia = faccpedi.codcia
            VtaCDocu.CodDiv = faccpedi.coddiv
            VtaCDocu.CodPed = faccpedi.coddoc
            VtaCDocu.NroPed = faccpedi.nroped + '-' + SUBSTRING(Almmmate.CodUbi,1,2)
            VtaCDocu.FlgEst = 'P'   /* APROBADO */
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Error al grabar la suborden " + faccpedi.nroped + '-' + SUBSTRING(Almmmate.CodUbi,1,2).
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    CREATE vtaddocu.
    BUFFER-COPY facdpedi TO vtaddocu
        ASSIGN
        VtaDDocu.CodCia = VtaCDocu.codcia
        VtaDDocu.CodDiv = VtaCDocu.coddiv
        VtaDDocu.CodPed = VtaCDocu.codped
        VtaDDocu.NroPed = VtaCDocu.nroped
        VtaDDocu.CodUbi = Almmmate.CodUbi.
END.
IF AVAILABLE vtacdocu THEN RELEASE vtacdocu.
IF AVAILABLE vtaddocu THEN RELEASE vtaddocu.
RETURN 'OK'.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
RETURN 'ADM-ERROR'.

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR i AS INT NO-UNDO.

  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

  ASSIGN
      input-var-1 = s-codalm
      input-var-2 = ""
      input-var-3 = "".
  RUN lkup/c-pedrepaut ('PEDIDOS PARA REPOSICION AUTOMATICA').
  IF output-var-3 = ? THEN RETURN 'ADM-ERROR'.
  ASSIGN
      s-NroCot = output-var-3.
  FIND Almcrepo WHERE almcrepo.CodCia = s-codcia
      AND almcrepo.AlmPed = s-codalm
      AND almcrepo.NroSer = INTEGER(SUBSTRING(s-nrocot,1,3))
      AND almcrepo.NroDoc = INTEGER(SUBSTRING(s-nrocot,4))
      NO-LOCK.
  ASSIGN
      s-FechaHora = ''
      s-FechaI = DATETIME(TODAY, MTIME)
      s-FechaT = ?
      s-adm-new-record = 'YES'
      s-FlgEnv = YES
      d-FechaEntrega = almcrepo.fecha.   /* Ic - 13May2015 */

  /* DISTRIBUYE LOS PRODUCTOS POR ORDEN DE ALMACENES */
  RUN Asigna-Cotizacion.
  IF RETURN-VALUE = "ADM-ERROR" THEN DO:
      UNDO, RETURN 'ADM-ERROR'.
  END.
  /* *********************************************** */
  FIND FIRST PEDI NO-LOCK NO-ERROR.
  IF NOT AVAILABLE PEDI THEN DO:
      MESSAGE 'NO hay stock suficiente para atender ese pedido' SKIP
          'PROCESO ABORTADO'
          VIEW-AS ALERT-BOX WARNING.
      RETURN "ADM-ERROR".
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FIND Almacen WHERE Almacen.codcia = s-codcia
          AND Almacen.codalm = s-codalm NO-LOCK NO-ERROR.
      f-NomAlm = Almacen.Descripcion.
      FIND Almacen WHERE Almacen.codcia = s-codcia
          AND Almacen.codalm = Almcrepo.codalm NO-LOCK NO-ERROR.
      DISPLAY 
          STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ Faccpedi.NroPed
          TODAY @ Faccpedi.FchPed
          TODAY + 7 @ Faccpedi.FchVen
          Almcrepo.CodAlm @ Faccpedi.CodCli
          Almacen.Descripcion @ Faccpedi.NomCli
          Almacen.DirAlm @ Faccpedi.Dircli
          s-CodRef @ FacCPedi.CodRef
          s-NroCot @ FacCPedi.NroRef
          s-CodAlm @ FacCPedi.CodAlm
          f-NomAlm
          Almcrepo.Glosa @ FacCPedi.Glosa
          .
      /* Motivo */
      FacCPedi.MotReposicion:SCREEN-VALUE = Almcrepo.MotReposicion.
      FacCPedi.VtaPuntual:SCREEN-VALUE    = STRING(Almcrepo.VtaPuntual).
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       El ALMACEN NO se pude modificar, entonces solo se hace 1 tracking
               NO se puede crear documentos, solo modificar
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
  DEFINE VARIABLE s-FlgBarras LIKE GN-DIVI.FlgBarras.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* Extornamos la referencia */
  CASE FacCPedi.CodRef:
      WHEN "R/A" THEN DO:
          RUN alm/pactualizareposicion ( ROWID(Faccpedi), "D", OUTPUT pMensaje).
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      END.
      WHEN "PED" THEN DO:
          RUN Extorna-Pedido-Ventas.
          IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
              IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo extornar " + Faccpedi.codref + ' ' + Faccpedi.nroref.
              UNDO, RETURN 'ADM-ERROR'.
          END.
      END.
  END CASE.
  RUN Borra-Pedido (TRUE).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      pMensaje = "NO se pudo actualizar el pedido".
      UNDO, RETURN 'ADM-ERROR'.
  END.
  RUN Extorna-SubOrden.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      pMensaje = "NO se pudo extornar la sub-orden".
      UNDO, RETURN 'ADM-ERROR'.
  END.
  /* Modificaciones */
  ASSIGN
      FacCPedi.UsrAct = s-user-id
      FacCPedi.FecAct = TODAY
      FacCPedi.HorAct = STRING(TIME,'HH:MM:SS').
  /* Actualizamos la hora cuando lo vuelve a modificar */
  ASSIGN
      Faccpedi.Usuario = S-USER-ID
      Faccpedi.Hora   = STRING(TIME,"HH:MM").
  /* Detalle del Pedido */
  RUN Genera-Pedido.    /* Detalle del pedido */
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      pMensaje = 'NO se pudo generar el pedido' + CHR(10) + 'NO hay stock suficiente en los almacenes'.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  /* Actualizamos la cotizacion */
  CASE FacCPedi.CodRef:
      WHEN "R/A" THEN DO:
          RUN alm/pactualizareposicion ( ROWID(Faccpedi), "C", OUTPUT pMensaje).
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      END.
      WHEN "PED" THEN DO:
          RUN Actualiza-Pedido-Ventas.
          IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
              IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo actualizar " + Faccpedi.codref + ' ' + Faccpedi.nroref.
              UNDO, RETURN 'ADM-ERROR'.
          END.
      END.
  END CASE.
  /* RHC 30/11/17 Anulamos los ceros */
  FOR EACH Facdpedi OF Faccpedi EXCLUSIVE-LOCK WHERE Facdpedi.canped <= 0:
      DELETE Facdpedi.
  END.
  /* *********************************************************** */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      RUN Genera-SubOrden.
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          pMensaje = 'NO se pudo generar la sub-orden'.
          UNDO, RETURN 'ADM-ERROR'.
      END.
  END.
  /* ************ CREAMOS VARIAS OTRs SI FUERA NECESARIO ************* */
  IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
  IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
  IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.
  IF AVAILABLE(Almcrepo) THEN RELEASE Almcrepo.

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
  RUN Procesa-Handle IN lh_Handle ('Browse').
  

  
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
    IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".

    /* ******************************************** */
    /* RHC 13/02/2018 SI vienen de un Cross Docking */
    /* ******************************************** */
/*     IF (Faccpedi.CodRef = "PED") THEN DO:                          */
/*         MESSAGE "Acceso Denegado" SKIP "Viene de un Cross Docking" */
/*             VIEW-AS ALERT-BOX ERROR.                               */
/*         RETURN "ADM-ERROR".                                        */
/*     END.                                                           */
    IF Faccpedi.CodRef = "R/A" AND Faccpedi.CrossDocking = NO THEN DO:
        /* Buscamos Origen */
        FIND Almcrepo WHERE almcrepo.CodCia = Faccpedi.codcia
            AND almcrepo.NroSer = INTEGER(SUBSTRING(Faccpedi.nroref,1,3))
            AND almcrepo.NroDoc = INTEGER(SUBSTRING(Faccpedi.nroref,4))
            AND almcrepo.CrossDocking = YES
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almcrepo THEN DO:
            MESSAGE "Acceso Denegado" SKIP "Viene de un Cross Docking"
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
    END.

    FIND FIRST FacDPedi OF FacCPedi WHERE FacDPedi.CanAte > 0 NO-LOCK NO-ERROR.
    IF AVAILABLE FacDPedi THEN DO:
        MESSAGE 'No se puede modificar/eliminar si tiene atenciones parciales' 
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.

    IF LOOKUP(FacCPedi.FlgEst,"A,C,E,R,F,S") > 0 THEN DO:
          MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
          RETURN "ADM-ERROR".
    END.

    /* RHC 30/01/2018 NO anular si está en una PHR */
    FOR EACH DI-RutaD NO-LOCK WHERE DI-RutaD.CodCia = s-codcia
        AND DI-RutaD.CodDoc = "PHR"
        AND DI-RutaD.CodRef = Faccpedi.coddoc
        AND DI-RutaD.NroRef = Faccpedi.nroped,
        FIRST DI-RutaC OF DI-RutaD NO-LOCK WHERE DI-RutaC.FlgEst <> "A":
        MESSAGE 'No se puede eliminarr si ya está en una Pre-Hoja de Ruta' SKIP
            DI-RutaC.CodDoc DI-RutaC.NroDoc VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.

    /* RHC 16/03/17 Motivo de anulación */
    DEF VAR pMotivo AS CHAR NO-UNDO.
    DEF VAR pGlosa  AS CHAR NO-UNDO.
    DEF VAR pError  AS LOG  NO-UNDO.

    RUN alm/d-mot-anu-otr ( INPUT 'MOTIVO DE ANULACION DE LA OTR',
                            OUTPUT pMotivo,
                            OUTPUT pGlosa,
                            OUTPUT pError).
    IF pError = TRUE THEN RETURN 'ADM-ERROR'.
    
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* RHC BLOQUEAMOS PEDIDO */
        FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedi THEN UNDO, RETURN 'ADM-ERROR'.

        /* RHC 16/03/17 Motivo de anulación */
        ASSIGN
            Faccpedi.Libre_c05 = pMotivo + '|' +
                                    pGlosa + '|' +
                                    STRING(NOW) + '|' +
                                    s-user-id.

        CASE TRUE:
            WHEN Faccpedi.codref = "PED" THEN DO:   /* Por Cross Docking */
                RUN Extorna-Pedido-Ventas.
                IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                    IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo extornar " + Faccpedi.codref + ' ' + Faccpedi.nroref.
                    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
                    UNDO, RETURN 'ADM-ERROR'.
                END.
/*                 RUN Actualiza-Pedido (-1).                                   */
/*                 IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
/*                 RUN Anula-SubOrden.                                          */
/*                 IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
/*                 RUN vtagn/pTracking-04 (Faccpedi.CodCia,                     */
/*                                         Faccpedi.CodDiv,                     */
/*                                         Faccpedi.CodRef,                     */
/*                                         Faccpedi.NroRef,                     */
/*                                         s-User-Id,                           */
/*                                         'GOD',                               */
/*                                         'A',                                 */
/*                                         DATETIME(TODAY, MTIME),              */
/*                                         DATETIME(TODAY, MTIME),              */
/*                                         Faccpedi.CodDoc,                     */
/*                                         Faccpedi.NroPed,                     */
/*                                         Faccpedi.CodRef,                     */
/*                                         Faccpedi.NroRef).                    */
            END.
            WHEN Faccpedi.codref = "R/A" THEN DO:
                /* RHC 28/11/2017 */
                /* Actualizamos R/A */
                {lib/lock-genericov3.i
                    &Tabla="Almcrepo"
                    &Alcance="FIRST"
                    &Condicion="Almcrepo.codcia = Faccpedi.codcia ~
                    AND LOOKUP(Almcrepo.tipmov, 'A,M') > 0 ~
                    AND Almcrepo.nroser = INTEGER(SUBSTRING(Faccpedi.NroRef,1,3)) ~
                    AND Almcrepo.nrodoc = INTEGER(SUBSTRING(Faccpedi.NroRef,4))"
                    &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
                    &Accion="RETRY"
                    &Mensaje="YES"
                    &TipoError="UNDO, RETURN 'ADM-ERROR'"
                    }
                ASSIGN            
                    Almcrepo.FlgEst = "A"       /* ANULADO */
                    almcrepo.FchApr = TODAY
                    Almcrepo.HorApr = STRING(TIME, 'HH:MM')
                    Almcrepo.UsrApr = s-user-id
                    almcrepo.Libre_c02 = pMotivo + '|' + pGlosa + '|' + STRING(NOW) + '|' + s-user-id.
                    .
                RELEASE Almcrepo.
                /* Actualizamos Cotizacion */
                /* RHC 28/11/17 Esta rutina ya NO cambia es estado de la R/A */
                RUN alm/pactualizareposicion ( ROWID(Faccpedi), 
                                               "D", 
                                               OUTPUT pMensaje).
                IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
                    UNDO, RETURN 'ADM-ERROR'.
                END.
                /* Extorno de SubOrden */
                RUN Extorna-SubOrden.
                IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                    UNDO, RETURN 'ADM-ERROR'.
                END.
            END.
        END CASE.

        ASSIGN
            FacCPedi.Glosa = "ANULADO POR " + s-user-id + " EL DIA " + STRING ( DATETIME(TODAY, MTIME), "99/99/9999 HH:MM" ).
            Faccpedi.FlgEst = 'A'.
        FIND CURRENT Faccpedi NO-LOCK.
    END.
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
    RUN Procesa-Handle IN lh_Handle ('browse').
      
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
  IF AVAILABLE Faccpedi THEN DO WITH FRAME {&FRAME-NAME}:
      RUN vta2/p-faccpedi-flgest (Faccpedi.flgest, Faccpedi.coddoc, OUTPUT f-Estado).
      DISPLAY f-Estado.
      f-NomAlm:SCREEN-VALUE = "".
      FIND Almacen OF Faccpedi NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen THEN f-NomAlm:SCREEN-VALUE = Almacen.Descripcion.
      f-AlmacenXD:SCREEN-VALUE = "".
      FIND Almacen WHERE ALmacen.codcia = s-codcia AND Almacen.codalm = Faccpedi.AlmacenXD
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen THEN f-AlmacenXD:SCREEN-VALUE = Almacen.Descripcion.
      ELSE DO:
          FIND gn-clie WHERE gn-clie.codcia = cl-codcia
              AND gn-clie.codcli = Faccpedi.AlmacenXD NO-LOCK NO-ERROR.
          IF AVAILABLE gn-clie THEN f-AlmacenXD:SCREEN-VALUE = gn-clie.nomcli.
      END.
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
    ASSIGN
        Faccpedi.CodCli:SENSITIVE = NO
        Faccpedi.NomCli:SENSITIVE = NO
        Faccpedi.DirCli:SENSITIVE = NO
        Faccpedi.FchPed:SENSITIVE = NO
        Faccpedi.FchVen:SENSITIVE = NO
        Faccpedi.NroRef:SENSITIVE = NO
        Faccpedi.CodAlm:SENSITIVE = NO
        Faccpedi.FaxCli:SENSITIVE = NO
        FacCPedi.Glosa:SENSITIVE = NO
        FacCPedi.CodRef:SENSITIVE = NO
        FacCPedi.MotReposicion:SENSITIVE = NO
        FacCPedi.VtaPuntual:SENSITIVE = NO.
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
  IF FacCPedi.FlgEst <> "A" THEN RUN vta2\r-ImpPed-1 (ROWID(FacCPedi)).

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
  DO WITH FRAME {&FRAME-NAME}:
      FacCPedi.MotReposicion:DELETE(1).
      FOR EACH FacTabla NO-LOCK WHERE FacTabla.CodCia = s-codcia
          AND FacTabla.Tabla = 'REPOMOTIVO':
          FacCPedi.MotReposicion:ADD-LAST(FacTabla.Nombre, FacTabla.Codigo).
      END.
  END.

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

  pMensajeFinal = "".
  pMensaje = "".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  IF pMensaje <> "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Facturas-Adelantadas.
  RUN vta2/d-saldo-cot-cred (ROWID(Faccpedi)).
  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  IF pMensajeFinal <> "" THEN MESSAGE pMensajeFinal.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Margen V-table-Win 
PROCEDURE Margen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR RPTA AS CHAR.
DEFINE VAR NIV  AS CHAR.

IF FacCPedi.FlgEst <> "A" THEN DO:
   NIV = "".
   RUN VTA/D-CLAVE.R("D",
                    " ",
                    OUTPUT NIV,
                    OUTPUT RPTA).
   IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".

   RUN vta/d-mrgped (ROWID(FacCPedi)).
END.

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
    DO WITH FRAME {&FRAME-NAME}:
        CASE HANDLE-CAMPO:name:
            WHEN "" THEN ASSIGN input-var-1 = "".
            WHEN "" THEN ASSIGN input-var-2 = "".
            WHEN "" THEN ASSIGN input-var-3 = "".
            WHEN 'CodPos' THEN input-var-1 = 'CP'.
        END CASE.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Redondeo V-table-Win 
PROCEDURE Redondeo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT AVAILABLE Faccpedi THEN RETURN.
RUN vta2/d-redondeo-ped (ROWID(Faccpedi)).
RUN Procesa-Handle IN lh_Handle ('browse').

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
  {src/adm/template/snd-list.i "Faccpedi"}

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
     RUN Actualiza-Item.
     RUN Procesa-Handle IN lh_Handle ('Pagina2').
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
 
DEFINE VARIABLE F-TOT AS DECIMAL INIT 0 NO-UNDO.
DEFINE VARIABLE F-BOL AS DECIMAL INIT 0 NO-UNDO.
DEFINE VARIABLE F-SALDO AS DECIMAL INIT 0 NO-UNDO.
DEFINE VARIABLE dImpLCred LIKE Gn-ClieL.ImpLC NO-UNDO.
DEFINE VARIABLE lEnCampan AS LOGICAL NO-UNDO.

DEF VAR x-CanPed AS DEC NO-UNDO.
DEF VAR l-CanPed AS LOG NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    /* CONSISTENCIA ALMACEN DESPACHO */
    IF Faccpedi.CodAlm:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Almacen de Despacho no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO Faccpedi.CodAlm.
      RETURN "ADM-ERROR".
    END.
    /* Verificamos que al menos tenga 1 item activo */
    x-CanPed = 0.
    l-CanPed = YES.
    FOR EACH PEDI NO-LOCK:
        x-CanPed = x-CanPed + PEDI.CanPed.
        IF PEDI.CanPed <= 0 THEN l-CanPed = NO.
    END.
    IF x-CanPed <= 0 THEN DO:
        MESSAGE 'NO puede poner todos los registros en cero' SKIP
            'Mejor ANULE la orden' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    IF l-CanPed = NO THEN DO:
        MESSAGE 'Uno o varios registros los ha puesto en valor cero' SKIP
            'Se va a proceder a anular estos registros' SKIP
            'Continuamos con la grabación?' VIEW-AS ALERT-BOX QUESTION
            BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN 'ADM-ERROR'.
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

IF (Faccpedi.FlgEst <> "P") THEN DO:
    MESSAGE "Acceso Denegado" VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
/* IF Faccpedi.CrossDocking = YES THEN DO:                    */
/*     IF Faccpedi.FlgSit <> "T" THEN DO:                     */
/*         MESSAGE "Acceso Denegado" VIEW-AS ALERT-BOX ERROR. */
/*         RETURN "ADM-ERROR".                                */
/*     END.                                                   */
/* END.                                                       */
/* ELSE DO:                                                   */
    IF (Faccpedi.FlgSit <> "P") THEN DO:
        MESSAGE "Acceso Denegado" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    /* ******************************************** */
    /* RHC 13/02/2018 SI vienen de un Cross Docking */
    /* ******************************************** */
    IF Faccpedi.CodRef = "R/A" AND Faccpedi.CrossDocking = NO THEN DO:
        FIND Almcrepo WHERE almcrepo.CodCia = Faccpedi.codcia
            AND almcrepo.NroSer = INTEGER(SUBSTRING(Faccpedi.nroref,1,3))
            AND almcrepo.NroDoc = INTEGER(SUBSTRING(Faccpedi.nroref,4))
            AND almcrepo.CrossDocking = YES
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almcrepo THEN DO:
            MESSAGE "Acceso Denegado" VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
    END.
/* END. */
FIND FIRST FacDPedi OF FacCPedi WHERE FacDPedi.CanAte > 0 NO-LOCK NO-ERROR.
IF AVAILABLE FacDPedi THEN DO:
    MESSAGE 'No se puede modificar/eliminar si tiene atenciones parciales' 
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
ASSIGN
    s-NroCot = Faccpedi.NroRef
    d-FechaEntrega = Faccpedi.FchEnt.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Venta-Corregida V-table-Win 
PROCEDURE Venta-Corregida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
FIND FIRST PEDI-3 NO-LOCK NO-ERROR.
IF NOT AVAILABLE PEDI-3 THEN RETURN 'OK'.
RUN vtamay/d-vtacorr-ped.
/*RETURN 'ADM-ERROR'.*/
RETURN 'OK'.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Cliente V-table-Win 
PROCEDURE Verifica-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*
{vta2/verifica-cliente.i}

/* RHC 22.11.2011 Verificamos los margenes y precios */
IF Faccpedi.FlgEst = "X" THEN RETURN.   /* NO PASO LINEA DE CREDITO */
IF LOOKUP(s-CodDiv, '00000,00017,00018') = 0 THEN RETURN.     /* SOLO PARA LA DIVISION DE ATE */

{vta2/i-verifica-margen-utilidad-1.i}
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

