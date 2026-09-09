&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE CPedi LIKE FacCPedi.
DEFINE SHARED TEMP-TABLE ITEM NO-UNDO LIKE Facdpedi.
DEFINE SHARED TEMP-TABLE ITEM-2 NO-UNDO LIKE FacDPedi.
DEFINE SHARED TEMP-TABLE ITEM-3 NO-UNDO LIKE FacDPedi.



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
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHARACTER.
DEFINE SHARED VARIABLE S-CNDVTA   AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.  
DEFINE SHARED VARIABLE X-NRODEC AS INTEGER INIT 2.
DEFINE SHARED VARIABLE S-NROCOT   AS CHARACTER.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEFINE SHARED VAR s-adm-new-record AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE T-SALDO AS DECIMAL.
DEFINE VARIABLE F-totdias      AS INTEGER NO-UNDO.
DEFINE VAR X-Codalm  AS CHAR NO-UNDO.

FIND FacCorre
    WHERE FacCorre.CodCia = S-CODCIA 
    AND FacCorre.CodDoc = S-CODDOC 
    AND FacCorre.CodDiv = S-CODDIV
    AND FacCorre.CodAlm = S-CodAlm 
    NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
    ASSIGN
        I-NroSer = FacCorre.NroSer
        S-PRINTER-NAME = FacCorre.Printer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

x-CodAlm = S-CODALM.

DEFINE BUFFER B-CPEDI FOR CPEDI.
DEFINE BUFFER B-DPEDI FOR Facdpedi.

DEFINE VAR x-ClientesVarios AS CHAR INIT '11111111111'.     /* 06.02.08 */
x-ClientesVarios =  FacCfgGn.CliVar.                        /* 07.09.09 */

/* RHC 23.12.04 Variable para controlar cuando un pedido se ha generado a partir de una copia */
DEFINE VAR s-copia-registro AS LOGICAL INIT FALSE NO-UNDO.
DEFINE VAR s-documento-registro AS CHAR INIT '' NO-UNDO.

/* 07.09.09 Variable para el Tracking */
DEFINE VAR s-FechaHora AS CHAR.
DEFINE VAR s-FechaI AS DATETIME NO-UNDO.
DEFINE VAR s-FechaT AS DATETIME NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES CPedi
&Scoped-define FIRST-EXTERNAL-TABLE CPedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CPedi.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CPedi.CodCli CPedi.NomCli CPedi.DirCli ~
CPedi.TpoCmb CPedi.CodAlm CPedi.fchven CPedi.Cmpbnte CPedi.CodMon 
&Scoped-define ENABLED-TABLES CPedi
&Scoped-define FIRST-ENABLED-TABLE CPedi
&Scoped-Define ENABLED-OBJECTS RECT-21 
&Scoped-Define DISPLAYED-FIELDS CPedi.CodCli CPedi.NomCli CPedi.FchPed ~
CPedi.DirCli CPedi.TpoCmb CPedi.CodAlm CPedi.fchven CPedi.Cmpbnte ~
CPedi.CodMon 
&Scoped-define DISPLAYED-TABLES CPedi
&Scoped-define FIRST-DISPLAYED-TABLE CPedi
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Almacen 

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
DEFINE VARIABLE FILL-IN-Almacen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 100 BY 4.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CPedi.CodCli AT ROW 1.54 COL 8 COLON-ALIGNED HELP
          ""
          LABEL "Cliente" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
          BGCOLOR 11 FGCOLOR 9 
     CPedi.NomCli AT ROW 1.54 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 48 BY .81
     CPedi.FchPed AT ROW 1.54 COL 82 COLON-ALIGNED
          LABEL "Fecha"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CPedi.DirCli AT ROW 2.35 COL 8 COLON-ALIGNED
          LABEL "Dirección"
          VIEW-AS FILL-IN 
          SIZE 61 BY .81
     CPedi.TpoCmb AT ROW 2.35 COL 82 COLON-ALIGNED
          LABEL "T/  Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CPedi.CodAlm AT ROW 3.15 COL 8 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 5 BY .81
          BGCOLOR 11 FGCOLOR 9 
     FILL-IN-Almacen AT ROW 3.15 COL 14 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     CPedi.fchven AT ROW 3.15 COL 82 COLON-ALIGNED
          LABEL "Vencimiento" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
          BGCOLOR 11 FGCOLOR 9 
     CPedi.Cmpbnte AT ROW 3.96 COL 82 COLON-ALIGNED
          LABEL "Comprobante"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "FAC","BOL","TCK" 
          DROP-DOWN-LIST
          SIZE 8 BY 1
     CPedi.CodMon AT ROW 4.23 COL 60 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.57 BY .81
     "Moneda:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 4.23 COL 53
     RECT-21 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: Temp-Tables.CPedi
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: CPedi T "SHARED" ? INTEGRAL FacCPedi
      TABLE: ITEM T "SHARED" NO-UNDO INTEGRAL Facdpedi
      TABLE: ITEM-2 T "SHARED" NO-UNDO INTEGRAL FacDPedi
      TABLE: ITEM-3 T "SHARED" NO-UNDO INTEGRAL FacDPedi
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
         HEIGHT             = 4.31
         WIDTH              = 100.
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

/* SETTINGS FOR COMBO-BOX CPedi.Cmpbnte IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CPedi.CodCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN CPedi.DirCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN CPedi.fchven IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-Almacen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CPedi.TpoCmb IN FRAME F-Main
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

&Scoped-define SELF-NAME CPedi.Cmpbnte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CPedi.Cmpbnte V-table-Win
ON VALUE-CHANGED OF CPedi.Cmpbnte IN FRAME F-Main /* Comprobante */
DO:

    IF SELF:SCREEN-VALUE = "FAC" THEN DO:
        ASSIGN
            CPEDI.DirCli:SENSITIVE = NO
            CPEDI.NomCli:SENSITIVE = NO.
    END.
    ELSE DO:
        ASSIGN
            CPEDI.DirCli:SENSITIVE = YES 
            CPEDI.NomCli:SENSITIVE = YES.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CPedi.CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CPedi.CodAlm V-table-Win
ON LEAVE OF CPedi.CodAlm IN FRAME F-Main /* Almacén */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    FIND Almacen WHERE Almacen.CodCia = S-CodCia 
        AND Almacen.CodAlm = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN DO:
       MESSAGE "Almacen no existe" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
    FILL-IN-Almacen:SCREEN-VALUE = Almacen.Descripcion.
    /* 08.09.09 Almacenes de despacho */
    IF s-codalm <> SELF:SCREEN-VALUE THEN DO:
        FIND almrepos WHERE almrepos.codalm = s-codalm
            AND almrepos.almped = SELF:SCREEN-VALUE
            AND almrepos.tipmat = 'VTA'
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almrepos THEN DO:
            MESSAGE 'Almacen NO AUTORIZADO para ventas' VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CPedi.CodAlm V-table-Win
ON LEFT-MOUSE-DBLCLICK OF CPedi.CodAlm IN FRAME F-Main /* Almacén */
OR F8 OF CPEDI.codalm
DO:
    ASSIGN
        input-var-1 = s-codalm
        input-var-2 = 'VTA'
        input-var-3 = ''.
    RUN lkup/c-almrep ('Almacenes de Despacho').
    IF output-var-1 <> ? THEN DO:
        SELF:SCREEN-VALUE = output-var-2.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CPedi.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CPedi.CodCli V-table-Win
ON LEAVE OF CPedi.CodCli IN FRAME F-Main /* Cliente */
DO:
  IF CPEDI.CodCli:SCREEN-VALUE = "" THEN RETURN.
   IF CAPS(SUBSTRING(SELF:SCREEN-VALUE,1,1)) = "A" THEN DO:
      MESSAGE "Codigo Incorrecto, Verifique ...... " VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
  IF LENGTH(SELF:SCREEN-VALUE) < 11 THEN DO:
      MESSAGE "Codigo tiene menos de 11 dígitos" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
    AND  gn-clie.CodCli = CPEDI.CodCli:SCREEN-VALUE 
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie  
  THEN DO:      /* CREA EL CLIENTE NUEVO */
    S-CODCLI = CPEDI.CodCli:SCREEN-VALUE.
    RUN vta/d-regcli (INPUT-OUTPUT S-CODCLI).
    IF S-CODCLI = "" 
    THEN DO:
        APPLY "ENTRY" TO CPEDI.CodCli.
        RETURN NO-APPLY.
    END.
    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
        AND  gn-clie.CodCli = S-CODCLI 
        NO-LOCK NO-ERROR.
  END.
  /* BLOQUEO DEL CLIENTE */
  IF gn-clie.FlgSit = "I" THEN DO:
      MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF gn-clie.FlgSit = "C" THEN DO:
      MESSAGE "Cliente esta Cesado" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
 
  DO WITH FRAME {&FRAME-NAME}:
    DISPLAY 
        gn-clie.CodCli  @ CPEDI.CodCli
        gn-clie.NomCli  @ CPEDI.NomCli
        gn-clie.DirCli  @ CPEDI.DirCli.
    ASSIGN
        S-CODMON = INTEGER(CPEDI.CodMon:SCREEN-VALUE)
        S-CNDVTA = gn-clie.CndVta
        S-CODCLI = gn-clie.CodCli.
  END.
  RUN Procesa-Handle IN lh_Handle ('browse').
  /* DETERMINAMOS LA FECHA Y LA HORA DE INICIO DEL TRACKING */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      s-FechaI = DATETIME(TODAY, MTIME).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CPedi.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CPedi.CodMon V-table-Win
ON VALUE-CHANGED OF CPedi.CodMon IN FRAME F-Main
DO:
  S-CODMON = INTEGER(CPEDI.CodMon:SCREEN-VALUE).
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CPedi.NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CPedi.NomCli V-table-Win
ON LEAVE OF CPedi.NomCli IN FRAME F-Main /* NomCli */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CPedi.TpoCmb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CPedi.TpoCmb V-table-Win
ON LEAVE OF CPedi.TpoCmb IN FRAME F-Main /* T/  Cambio */
DO:
    S-TPOCMB = DEC(CPEDI.TpoCmb:SCREEN-VALUE).
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Cotizacion V-table-Win 
PROCEDURE Actualiza-Cotizacion :
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Item V-table-Win 
PROCEDURE Actualiza-Item :
/*------------------------------------------------------------------------------

  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH ITEM:
        DELETE ITEM.
    END.
    FOR EACH ITEM-2:
        DELETE ITEM-2.
    END.
    FOR EACH ITEM-3:
        DELETE ITEM-3.
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
  {src/adm/template/row-list.i "CPedi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CPedi"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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
  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.
  DEFINE VARIABLE F-CANPED AS DECIMAL NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.

  DEFINE FRAME F-Mensaje
    'Procesando: ' Facdpedi.codmat SKIP(1)
    'Espere un momento por favor ...' SKIP
    WITH CENTERED NO-LABELS OVERLAY VIEW-AS DIALOG-BOX TITLE 'TRASLADANDO COTIZACION'.

  DO WITH FRAME {&FRAME-NAME}:  
    IF NOT CPEDI.CodCli:SENSITIVE THEN RETURN "ADM-ERROR".
    IF NOT CPEDI.CodAlm:SENSITIVE THEN RETURN "ADM-ERROR".
    IF CPEDI.CodCli:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'Ingrese el código del cliente' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO CPEDI.codcli.
        RETURN "ADM-ERROR".
    END.
    IF CPEDI.CodAlm:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'Ingrese el código del almacen' VIEW-AS ALERT-BOX ERROR.
        APPLY 'entry':U TO CPEDI.codalm.
        RETURN "ADM-ERROR".
    END.
    ASSIGN
        S-NroCot = ""
        input-var-1 = "COT"
        input-var-2 = CPEDI.CodCli:SCREEN-VALUE.
    RUN lkup/C-PedidoT ("Cotizaciones Vigentes").
    IF output-var-1 = ? THEN RETURN "ADM-ERROR".
    FIND B-CPEDI WHERE ROWID(B-CPEDI) = output-var-1 NO-LOCK NO-ERROR.
    RUN Actualiza-Item.
    ASSIGN
        S-NroCot = SUBSTRING(output-var-2,4,9)      /* *** OJO *** */
        s-CodMon = B-CPEDI.CodMon                   /* >>> OJO <<< */
        S-CNDVTA = B-CPEDI.FmaPgo.
    
    DISPLAY 
        B-CPEDI.CodCli @ CPEDI.CodCli
        B-CPEDI.NomCli @ CPEDI.NomCli
        B-CPedi.FchVen @ CPEDI.FchVen.
    ASSIGN
        CPEDI.CodMon:SCREEN-VALUE = STRING(B-CPEDI.CodMon).

    DETALLES:
    FOR EACH Facdpedi OF B-CPEDI NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0,
            FIRST Almmmatg OF Facdpedi NO-LOCK:
        DISPLAY Facdpedi.codmat WITH FRAME F-Mensaje.
        F-CANPED = (FacDPedi.CanPed - FacDPedi.CanAte).
        /* RUTINA QUE VERIFICA NUEVAMENTE EL STOCK DISPONIBLE Y AJUSTA LA CANTIDAD EN CASO NECESARIO */
        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
            AND Almtconv.Codalter = Facdpedi.UndVta
            NO-LOCK NO-ERROR.
        f-Factor = Almtconv.Equival / Almmmatg.FacEqu.
        FIND Almmmate WHERE Almmmate.codcia = s-codcia
            AND Almmmate.codalm = CPEDI.CodAlm:SCREEN-VALUE  /* *** OJO *** */
            AND Almmmate.codmat = Facdpedi.CodMat
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN DO:
            MESSAGE 'Material' Facdpedi.codmat 'NO asignado al almacén' CPEDI.CodAlm:SCREEN-VALUE
                VIEW-AS ALERT-BOX WARNING.
            NEXT detalles.
        END.
        x-StkAct = Almmmate.StkAct.
        RUN gn/Stock-Comprometido (Almmmate.CodMat, Almmmate.CodAlm, OUTPUT s-StkComprometido).
        /*MESSAGE facdpedi.codmat x-stkact s-stkcomprometido.*/
        s-StkDis = x-StkAct - s-StkComprometido.
        IF s-StkDis <= 0 THEN DO:
            MESSAGE 'Artículo' Facdpedi.codmat 'no tiene stock disponible' SKIP
                'Almacén:' CPEDI.codalm:SCREEN-VALUE SKIP
                'Stock actual:' x-StkAct SKIP
                'Stock Comprometido:' s-StkComprometido SKIP
                'Stock Disponible:' s-StkDis
                VIEW-AS ALERT-BOX WARNING.
            NEXT DETALLES.
        END.
        x-CanPed = f-CanPed * f-Factor.
        IF s-StkDis < x-CanPed THEN DO:
            f-CanPed = ((S-STKDIS - (S-STKDIS MODULO Facdpedi.Factor)) / Facdpedi.Factor).
        END.

/*ML01* Inicio de bloque */
        FOR FIRST supmmatg
            FIELDS (supmmatg.codcia supmmatg.codcli supmmatg.codmat supmmatg.Libre_d01)
            WHERE supmmatg.codcia = B-CPedi.CodCia
            AND supmmatg.codcli = B-CPedi.CodCli
            AND supmmatg.codmat = FacDPedi.codmat 
            NO-LOCK:
        END.
        IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:
            f-CanPed = (TRUNCATE((FacDPedi.CanPed / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).
        END.
/*ML01* Fin de bloque */

        I-NITEM = I-NITEM + 1.
        CREATE ITEM.
        BUFFER-COPY FacDPedi TO ITEM
            ASSIGN 
                ITEM.CodCia = s-codcia
                ITEM.CodDiv = s-coddiv
                ITEM.CodDoc = s-coddoc
                ITEM.NroPed = ''
                ITEM.ALMDES = CPEDI.CodAlm:SCREEN-VALUE  /* *** OJO *** */
                ITEM.NroItm = I-NITEM
                ITEM.CanPed = F-CANPED
                ITEM.CanAte = 0.
        ITEM.Libre_d01 = (FacDPedi.CanPed - FacDPedi.CanAte).
        ITEM.Libre_c01 = '*'.
        IF ITEM.CanPed <> facdPedi.CanPed THEN DO:
            ITEM.ImpDto = ROUND( ITEM.PreBas * (ITEM.PorDto / 100) * ITEM.CanPed , 2 ).
            /* RHC 22.06.06 */
            ITEM.ImpDto = ITEM.ImpDto + ROUND( ITEM.PreBas * ITEM.CanPed * (1 - ITEM.PorDto / 100) * (ITEM.Por_Dsctos[1] / 100),4 ).
            /* ************ */
            ITEM.ImpLin = ROUND( ITEM.PreUni * ITEM.CanPed , 2 ).
            IF ITEM.AftIsc THEN 
                ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
            IF ITEM.AftIgv THEN  
                ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
        END.
    END.
    HIDE FRAME F-Mensaje.
    ASSIGN
        CPEDI.CodCli:SENSITIVE = NO
        CPEDI.CodAlm:SENSITIVE = NO.
  END.
  FIND FIRST ITEM NO-LOCK NO-ERROR.
  IF NOT AVAILABLE ITEM THEN DO:
      MESSAGE 'NO hay stock suficiente para atender el pedido' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.

  RUN Venta-Corregida.

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
      FOR EACH Facdpedi OF CPEDI:
          /* BORRAMOS SALDO EN LAS COTIZACIONES */
          FIND B-DPEDI WHERE B-DPEDI.CodCia = CPEDI.CodCia 
              AND  B-DPEDI.CodDoc = "COT" 
              AND  B-DPEDI.NroPed = CPEDI.NroRef
              AND  B-DPEDI.CodMat = Facdpedi.CodMat 
              EXCLUSIVE-LOCK NO-ERROR.
          /*IF AVAILABLE B-DPEDI THEN B-DPEDI.CanAte = B-DPEDI.CanAte - Facdpedi.CanPed.*/
          IF AVAILABLE B-DPEDI 
          THEN ASSIGN
                B-DPEDI.FlgEst = 'P'
                B-DPEDI.CanAte = B-DPEDI.CanAte - Facdpedi.CanPed.  /* <<<< OJO <<<< */
          RELEASE B-DPEDI.
          IF p-Ok = YES
          THEN DELETE Facdpedi.
          ELSE Facdpedi.FlgEst = 'A'.   /* <<< OJO <<< */

           FIND B-CPedi WHERE 
                B-CPedi.CodCia = S-CODCIA AND  
                B-CPedi.CodDiv = S-CODDIV AND  
                B-CPedi.CodDoc = "COT"    AND  
                B-CPedi.NroPed = CPEDI.NroRef
                EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE B-CPedi THEN B-CPedi.FlgEst = "P".
           RELEASE B-CPedi.
      END.    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido V-table-Win 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
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

  /* POR CADA ITEM VOLVEMOS A VERIFICAR EL STOCK DISPONIBLE */
  /* Borramos data sobrante */
  FOR EACH ITEM WHERE ITEM.CanPed <= 0:
      DELETE ITEM.
  END.
  FOR EACH item-3:
      DELETE item-3.
  END.
  DETALLE:
  FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK BY ITEM.NroItm: 
      ITEM.Libre_d01 = ITEM.CanPed.
      ITEM.Libre_c01 = '*'.
      /* RUTINA QUE VERIFICA NUEVAMENTE EL STOCK DISPONIBLE Y AJUSTA LA CANTIDAD EN CASO NECESARIO */
      FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
          AND Almtconv.Codalter = ITEM.UndVta
          NO-LOCK NO-ERROR.
      f-Factor = Almtconv.Equival / Almmmatg.FacEqu.
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = ITEM.AlmDes
          AND Almmmate.codmat = ITEM.CodMat
          NO-LOCK NO-ERROR .
      x-StkAct = Almmmate.StkAct.
      RUN gn/Stock-Comprometido (ITEM.CodMat, ITEM.AlmDes, OUTPUT s-StkComprometido).
      s-StkDis = x-StkAct - s-StkComprometido.
      IF s-StkDis < 0 THEN s-StkDis = 0.    /* *** OJO *** */
      x-CanPed = ITEM.CanPed * f-Factor.
      IF s-StkDis < x-CanPed THEN DO:
          /* Ajustamos los valores de acuerdo a la cantidad */
          /* CONTROL DE AJUTES */
          CREATE ITEM-3.
          BUFFER-COPY ITEM TO ITEM-3
              ASSIGN ITEM-3.CanAte = 0.     /* Valor por defecto */    
          /* Ajustamos de acuerdo a los multiplos */
          ITEM.CanPed = s-StkDis / f-Factor.
          IF Almtconv.Multiplos <> 0 THEN DO:
              IF (ITEM.CanPed / Almtconv.Multiplos) <> INTEGER(ITEM.CanPed / Almtconv.Multiplos) THEN DO:
                  ITEM.CanPed = TRUNCATE(ITEM.CanPed / Almtconv.Multiplos, 0) * Almtconv.Multiplos.
              END.
          END.
          ASSIGN ITEM-3.CanAte = ITEM.CanPed.       /* CANTIDAD AJUSTADA */
          RELEASE ITEM-3.
          /* FIN DE CONTROL DE AJUSTES */
          ITEM.ImpDto = ROUND( ITEM.PreBas * (ITEM.PorDto / 100) * ITEM.CanPed , 2 ).
          /* RHC 22.06.06 */
          ITEM.ImpDto = ITEM.ImpDto + ROUND( ITEM.PreBas * ITEM.CanPed * (1 - ITEM.PorDto / 100) * (ITEM.Por_Dsctos[1] / 100),4 ).
          /* ************ */
          ITEM.ImpLin = ROUND( ITEM.PreUni * ITEM.CanPed , 2 ).
          IF ITEM.AftIsc THEN 
              ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
          IF ITEM.AftIgv THEN  
              ITEM.ImpIgv = ITEM.ImpLin - ROUND(ITEM.ImpLin  / (1 + (FacCfgGn.PorIgv / 100)),4).
      END.
      /* ************************************************************************************** */
      I-NITEM = I-NITEM + 1.
      CREATE Facdpedi.
      BUFFER-COPY ITEM TO Facdpedi
          ASSIGN
              Facdpedi.CodCia = CPEDI.CodCia
              Facdpedi.CodDiv = CPEDI.CodDiv
              Facdpedi.coddoc = CPEDI.coddoc
              Facdpedi.NroPed = CPEDI.NroPed
              Facdpedi.FchPed = CPEDI.FchPed
              Facdpedi.Hora   = CPEDI.Hora 
              Facdpedi.FlgEst = CPEDI.FlgEst
              Facdpedi.NroItm = I-NITEM
              Facdpedi.Libre_d02 = Facdpedi.CanPed.        /* CONTROL */
      RELEASE Facdpedi.
  END.
  /* verificamos que al menos exista 1 item grabado */
  FIND FIRST Facdpedi OF CPEDI NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi 
  THEN RETURN 'ADM-ERROR'.
  ELSE RETURN 'OK'.

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

DO TRANSACTION ON ERROR UNDO, RETRY ON STOP UNDO, RETRY:
    /* Detalle del Pedido */
    RUN Genera-Pedido.    /* Detalle del pedido */ 

    /* Grabamos Totales */
    RUN Graba-Totales.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETRY.

    /* Actualizamos la cotizacion */
    RUN Actualiza-Cotizacion.
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETRY.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales V-table-Win 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta/graba-totales.i}

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

    FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            s-TpoCmb = FacCfgGn.TpoCmb[1].
        DISPLAY
            TODAY @ CPEDI.FchPed
            S-TPOCMB @ CPEDI.TpoCmb
            TODAY @ CPEDI.FchVen
            x-ClientesVarios @ CPEDI.CodCli
            s-CodAlm @ CPEDI.codalm.             /* Almacen por defecto */
        ASSIGN
            S-CODCLI = CPEDI.CodCli:SCREEN-VALUE
            CPEDI.CodMon:SCREEN-VALUE = STRING(s-CodMon).

        FIND gn-clie
            WHERE gn-clie.CodCia = CL-CODCIA
            AND gn-clie.CodCli = CPEDI.CodCli:SCREEN-VALUE 
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            DISPLAY
                gn-clie.CodCli @ CPEDI.CodCli.
            IF gn-clie.Ruc = "" 
            THEN CPEDI.Cmpbnte:SCREEN-VALUE = "BOL".
            ELSE CPEDI.Cmpbnte:SCREEN-VALUE = "FAC".
        END.
        FIND Almacen WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = s-codalm
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen THEN FILL-IN-Almacen:SCREEN-VALUE = Almacen.Descripcion.

        RUN Actualiza-Item.
        RUN Procesa-Handle IN lh_Handle ('Pagina2').

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       El ALMACEN NO se pude modificar, entonces solo se hace 1 tracking
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
          AND FacCorre.CodDoc = S-CODDOC 
          AND FacCorre.CodDiv = S-CODDIV 
          AND Faccorre.Codalm = S-CodAlm
          AND FacCorre.FlgEst = YES
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE FacCorre THEN UNDO, RETURN 'ADM-ERROR'.
      ASSIGN 
        CPEDI.CodCia = S-CODCIA
        CPEDI.CodDoc = s-coddoc 
        CPEDI.FchPed = TODAY 
        CPEDI.PorIgv = FacCfgGn.PorIgv 
        CPEDI.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        CPEDI.CodDiv = S-CODDIV
        CPEDI.FlgEst = "G"
        CPEDI.Libre_c01 = 'COT'.
      ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
      /* TRACKING */
      FIND Almacen OF CPEDI NO-LOCK.
      s-FechaT = DATETIME(TODAY, MTIME).
      RUN gn/pTracking (s-CodCia,
                        s-CodDiv,
                        Almacen.CodDiv,
                        CPEDI.CodDoc,
                        CPEDI.NroPed,
                        s-User-Id,
                        'GNP',
                        'P',
                        'IO',
                        s-FechaI,
                        s-FechaT,
                        'COT',
                        CPEDI.NroRef).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  ELSE DO:
      RUN Borra-Pedido (TRUE).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.
  /* Actualizamos la hora cuando lo vuelve a modificar */
  ASSIGN
      CPEDI.Usuario = S-USER-ID
      CPEDI.Hora   = STRING(TIME,"HH:MM").

  /* Detalle del Pedido */
  RUN Genera-Pedido.    /* Detalle del pedido */
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      MESSAGE 'NO se pudo generar el pedido' SKIP
          'NO hay stock suficiente en los almacenes' VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN 'ADM-ERROR'.
  END.

  RUN Venta-Corregida.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      RUN Procesa-Handle IN lh_Handle ('browse'). 
      UNDO, RETURN 'ADM-ERROR'.
  END.

  /* Grabamos Totales */
  RUN Graba-Totales.

  /* APROBAMOS EL PEDIDO O LO RECHAZAMOS */
  IF CPEDI.FlgEst <> 'P' THEN DO:
      RUN Verifica-Cliente.
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  END.

  /* Actualizamos la cotizacion */
  RUN gn/actualiza-cotizacion ( ROWID(CPEDI), +1 ).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RELEASE FacCorre.

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

  DO WITH FRAME {&FRAME-NAME}:
     CPEDI.NomCli:SENSITIVE = NO.
     CPEDI.DirCli:SENSITIVE = NO.
  END. 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('Browse').
  

  
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
  MESSAGE 'Se va a proceder a con la copia' SKIP
      'El pedido ORIGINAL puede que sea anulado' SKIP
      'Continuamos (S-N)?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN 'ADM-ERROR'.

  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
    AND FacCorre.CodDoc = S-CODDOC 
    AND FacCorre.CodDiv = S-CODDIV 
    AND Faccorre.Codalm = S-CodAlm
    AND Faccorre.FlgEst = YES
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE FacCorre THEN DO:
      MESSAGE 'Correlativo NO configurado para ' s-coddoc SKIP
          'de la division' s-coddiv SKIP
          'del almacén' s-codalm
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

  IF NOT AVAILABLE CPEDI THEN RETURN "ADM-ERROR".
  FIND CURRENT CPEDI EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE CPEDI THEN RETURN "ADM-ERROR".
  ASSIGN
    S-CODMON = CPEDI.CodMon
    S-CODCLI = CPEDI.CodCli
    S-TPOCMB = CPEDI.TpoCmb
    S-CNDVTA = CPEDI.FmaPgo.
  FOR EACH ITEM:
    DELETE ITEM.
  END.
  FOR EACH ITEM-2:
    DELETE ITEM-2.
  END.
  FOR EACH ITEM-3:
    DELETE ITEM-3.
  END.
  FOR EACH Facdpedi OF CPEDI NO-LOCK:
    CREATE ITEM.
    BUFFER-COPY Facdpedi TO ITEM.
    /* SI HUBIERA UN PICKING ANTERIOR */
    IF CPEDI.FchPed = TODAY AND CPEDI.FlgEst = 'C' 
        THEN ITEM.CanPed = ITEM.CanPick.
    IF ITEM.CanPed = 0 THEN DELETE ITEM.
    /* ****************************** */
  END.
  /* RHC 13.02.08 anular el pedido original */
  IF CPEDI.FlgEst <> 'C' THEN DO:
      IF CPEDI.FlgEst = 'P' THEN DO:
          /* TRACKING */
          s-FechaT = DATETIME(TODAY, MTIME).
          RUN vta/pFlujoPedido (s-CodCia,
                                s-CodDiv,
                                'GNP',
                                s-User-Id,
                                CPEDI.CodDoc,
                                CPEDI.NroPed,
                                'A',
                                'IO',
                                s-FechaI,
                                s-FechaT).
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
          FOR EACH Facdpedi OF CPEDI NO-LOCK WHERE Facdpedi.almdes <> s-codalm,
              FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
              AND Almacen.codalm = Facdpedi.almdes
              AND Almacen.coddiv <> s-coddiv
              BREAK BY Almacen.coddiv:
              IF FIRST-OF(Almacen.coddiv) THEN DO:
                  /* TRACKING */
                  s-FechaT = DATETIME(TODAY, MTIME).
                  RUN vta/pFlujoPedido (s-CodCia,
                                        Almacen.CodDiv,
                                        'GNP',
                                        s-User-Id,
                                        CPEDI.CodDoc,
                                        CPEDI.NroPed,
                                        'A',
                                        'IO',
                                        s-FechaI,
                                        s-FechaT).
                  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
              END.
          END.
      END.
      ASSIGN CPEDI.FlgEst = 'A'.
  END.

  FIND CURRENT CPEDI NO-LOCK NO-ERROR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      /*
      DISPLAY
          STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ CPEDI.NroPed.
        */
      ASSIGN
          s-TpoCmb = FacCfgGn.TpoCmb[1].
      DISPLAY 
          S-TPOCMB @ CPEDI.TpoCmb
          TODAY @ CPEDI.FchVen.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Recalcular-Precios').
  RUN Procesa-Handle IN lh_Handle ('Browse').
  s-Copia-Registro = YES.   /* <<< OJO >>> */
  s-Documento-Registro = '*' + STRING(CPEDI.coddoc, 'x(3)') + ' ' + ~
      STRING(CPEDI.nroped, 'x(9)').

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
    IF CPEDI.FlgEst = "A" THEN DO:
       MESSAGE "El pedido ya fue anulado" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF CPEDI.FlgEst = "C" THEN DO:
       MESSAGE "No puede eliminar un pedido atendido" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.
    IF CPEDI.FlgEst = "E" THEN DO:
       MESSAGE "No puede eliminar un pedido cerrado" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
    END.

    {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""}

/*     FIND FIRST FacDPedi OF CPEDI WHERE FacDPedi.canate > 0 NO-LOCK NO-ERROR. */
/*     IF AVAILABLE Facdpedi THEN DO:                                              */
/*        MESSAGE "No puede eliminar un pedido con atención parcial" SKIP          */
/*         "Codigo:" Facdpedi.codmat                                               */
/*         VIEW-AS ALERT-BOX ERROR.                                                */
/*        RETURN "ADM-ERROR".                                                      */
/*     END.                                                                        */

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND CURRENT CPEDI EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE CPEDI THEN RETURN 'ADM-ERROR'.

      IF CPEDI.flgest = 'P' THEN DO:
          /* TRACKING */
          FIND Almacen OF CPEDI NO-LOCK.
          s-FechaT = DATETIME(TODAY, MTIME).
          RUN gn/pTracking (s-CodCia,
                            s-CodDiv,
                            Almacen.CodDiv,
                            CPEDI.CodDoc,
                            CPEDI.NroPed,
                            s-User-Id,
                            'ANP',
                            'A',
                            'IO',
                            ?,
                            s-FechaT,
                            'COT',
                            CPEDI.NroRef).
          IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      END.

      /* TRACKING */
      FIND Almacen OF CPEDI NO-LOCK.
      s-FechaT = DATETIME(TODAY, MTIME).
      RUN gn/pTracking (s-CodCia,
                        s-CodDiv,
                        Almacen.CodDiv,
                        CPEDI.CodDoc,
                        CPEDI.NroPed,
                        s-User-Id,
                        'GNP',
                        'A',
                        'IO',
                        ?,
                        s-FechaT,
                        'COT',
                        CPEDI.NroRef).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      /* BORRAMOS DETALLE */
      RUN Borra-Pedido (FALSE).
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

      ASSIGN
          CPEDI.FlgEst = 'A'.
      FIND CURRENT CPEDI NO-LOCK.
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
  IF AVAILABLE CPEDI THEN DO WITH FRAME {&FRAME-NAME}:
     FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
                   AND  gn-clie.CodCli = CPEDI.CodCli 
                  NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie  THEN DO: 
        DISPLAY CPEDI.NomCli.
    END.  
    fill-in-Almacen:SCREEN-VALUE = ''.
    FIND Almacen WHERE Almacen.codcia = s-codcia
        AND ALmacen.codalm = CPEDI.codalm
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN fill-in-Almacen:SCREEN-VALUE = Almacen.Descripcion.

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
        CPEDI.NomCli:SENSITIVE = NO
        CPEDI.DirCli:SENSITIVE = NO
        CPEDI.TpoCmb:SENSITIVE = NO
        CPEDI.CodMon:SENSITIVE = NO.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' 
        THEN CPEDI.CodAlm:SENSITIVE = NO.
        ELSE CPEDI.CodAlm:SENSITIVE = YES.
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
  IF CPEDI.FlgEst <> "A" THEN RUN VTA\R-ImpPed (ROWID(CPEDI)).

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
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  
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

IF CPEDI.FlgEst <> "A" THEN DO:
   NIV = "".
   RUN VTA/D-CLAVE.R("D",
                    " ",
                    OUTPUT NIV,
                    OUTPUT RPTA).
   IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".

   RUN vta/d-mrgped (ROWID(CPEDI)).
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
  {src/adm/template/snd-list.i "CPedi"}

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
     RUN Procesa-Handle IN lh_Handle ('browse').
     APPLY 'ENTRY':U TO CPEDI.NomCli IN FRAME {&FRAME-NAME}.
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
DEFINE VARIABLE F-SALDO AS DECIMAL INIT 0 NO-UNDO.
DEFINE VARIABLE dImpLCred LIKE Gn-ClieL.ImpLC NO-UNDO.
DEFINE VARIABLE lEnCampan AS LOGICAL NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    IF CPEDI.CodCli:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Código de cliente no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO CPEDI.CodCli.
        RETURN "ADM-ERROR".   
    END.
    FIND gn-clie WHERE
        gn-clie.CodCia = cl-codcia AND
        gn-clie.CodCli = CPEDI.CodCli:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
        MESSAGE "Código de cliente no existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO CPEDI.CodCli.
        RETURN "ADM-ERROR".   
    END.
    IF gn-clie.FlgSit = "I" THEN DO:
       MESSAGE "Cliente esta Inactivo" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO CPEDI.CodCli.
       RETURN "ADM-ERROR".   
    END.
    IF gn-clie.FlgSit = "C" THEN DO:
       MESSAGE "Cliente esta Cesado" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO CPEDI.CodCli.
       RETURN "ADM-ERROR".   
    END.
    IF LOOKUP(TRIM(CPEDI.CodCli:SCREEN-VALUE), x-ClientesVarios) = 0
        AND LENGTH(TRIM(CPEDI.CodCli:SCREEN-VALUE)) <> 11
        THEN DO:
        MESSAGE 'El codigo del cliente debe tener 11 digitos' VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO CPEDI.CodCli.
        RETURN 'ADM-ERROR'.
    END.
    IF CPEDI.CodAlm:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Almacen de Despacho no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO CPEDI.CodAlm.
      RETURN "ADM-ERROR".
    END.
    FOR EACH ITEM NO-LOCK: 
        F-Tot = F-Tot + ITEM.ImpLin.
    END.
    IF F-Tot = 0 THEN DO:
        MESSAGE "Importe total debe ser mayor a cero" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO CPEDI.CodCli.
        RETURN "ADM-ERROR".   
    END.

    /* VERIFICAMOS LA LINEA DE CREDITO */
    f-Saldo = f-Tot.
    RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
    IF RETURN-VALUE = 'NO' THEN F-Saldo = F-Tot - CPEDI.Imptot.
    DEF VAR t-Resultado AS CHAR NO-UNDO.
    RUN gn/linea-de-credito ( s-CodCli,
                              f-Saldo,
                              s-CodMon,
                              s-CndVta,
                              TRUE,
                              OUTPUT t-Resultado).
    IF t-Resultado = 'ADM-ERROR' THEN DO:
        APPLY "ENTRY" TO CPEDI.CodCli.
        RETURN "ADM-ERROR".   
    END.
    /**** CONTROL DE 1/2 UIT PARA BOLETAS DE VENTA */
    f-TOT = IF S-CODMON = 1 THEN
        F-TOT ELSE F-TOT * DECI(CPEDI.Tpocmb:SCREEN-VALUE).
    IF F-Tot >= 1725 THEN DO:
        IF CPEDI.Cmpbnte:SCREEN-VALUE = 'BOL' THEN DO:
            MESSAGE
                "Boleta de Venta Venta Mayor a S/.1,725.00 Ingresar Nro. Ruc., Verifique... " 
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".   
        END.
    END.
    /* RHC 15.12.09 CONTROL DE IMPORTE MINIMO POR COTIZACION */
    DEF VAR pImpMin AS DEC NO-UNDO.
    RUN gn/pMinCotPed (s-CodCia,
                       s-CodDiv,
                       s-CodDoc,
                       OUTPUT pImpMin).
    IF pImpMin > 0 AND f-Tot < pImpMin THEN DO:
        MESSAGE 'El importe mínimo para los pedidos es de S/.' pImpMin
            VIEW-AS ALERT-BOX ERROR.
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
  IF NOT AVAILABLE CPEDI THEN RETURN "ADM-ERROR".
  IF LOOKUP(CPEDI.FlgEst,"P,F,C,A,E,R") > 0 THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.

  S-CODMON = CPEDI.CodMon.
  S-CODCLI = CPEDI.CodCli.
  s-Copia-Registro = NO.
  s-NroCot = CPEDI.NroRef.
  s-adm-new-record = 'NO'.
  RETURN "OK".

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

FIND FIRST ITEM-3 NO-LOCK NO-ERROR.
IF NOT AVAILABLE ITEM-3 THEN RETURN 'OK'.
RUN vta/d-vtacorr.
RETURN 'ADM-ERROR'.

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

{vta/verifica-cliente.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

