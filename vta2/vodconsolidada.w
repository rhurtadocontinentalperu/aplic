&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE SHARED TEMP-TABLE PEDI NO-UNDO LIKE Facdpedi.



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
DEFINE SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER INIT 1.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHARACTER.
DEFINE SHARED VARIABLE S-TPOCMB AS DECIMAL.  
DEFINE SHARED VARIABLE S-NROCOT   AS CHARACTER.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE s-adm-new-record AS CHAR.
DEFINE SHARED VARIABLE S-NROPED   AS CHAR.
DEFINE SHARED VARIABLE s-NroSer AS INTEGER.
DEFINE SHARED VARIABLE s-FlgEmpaque LIKE gn-divi.FlgEmpaque.
DEFINE SHARED VARIABLE s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEFINE SHARED VARIABLE s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEFINE SHARED VARIABLE S-TPOPED AS CHAR.
DEFINE SHARED VARIABLE s-PorIgv LIKE Ccbcdocu.PorIgv.
DEFINE SHARED VARIABLE s-FlgIgv LIKE Faccpedi.FlgIgv.
DEFINE SHARED VARIABLE s-FmaPgo AS CHAR.
DEFINE SHARED VARIABLE s-NroDec AS INT.

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

DEFINE VAR pNroCotizacion AS CHAR.
DEFINE VAR pFechaEntrega AS DATE.

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
&Scoped-Define ENABLED-FIELDS FacCPedi.FaxCli FacCPedi.Glosa ~
FacCPedi.NroRef 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.FaxCli ~
FacCPedi.FchPed FacCPedi.usuario FacCPedi.Glosa FacCPedi.NroRef 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado 

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
DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.


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
     FacCPedi.usuario AT ROW 1.77 COL 99 COLON-ALIGNED WIDGET-ID 34
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.Glosa AT ROW 1.96 COL 13.28 FORMAT "X(256)"
          VIEW-AS FILL-IN 
          SIZE 70 BY .81
          BGCOLOR 11 FGCOLOR 0 
     FacCPedi.NroRef AT ROW 2.92 COL 18 NO-LABEL WIDGET-ID 126
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 71 BY 2.42
     "Consolidadas:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 2.92 COL 8 WIDGET-ID 128
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
         HEIGHT             = 6.92
         WIDTH              = 119.43.
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

/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FaxCli IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   ALIGN-L EXP-FORMAT                                                   */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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
  DEFINE VARIABLE i AS INT NO-UNDO.

  DEFINE FRAME F-Mensaje
    'Procesando: ' Facdpedi.codmat SKIP(1)
    'Espere un momento por favor ...' SKIP
    WITH CENTERED NO-LABELS OVERLAY VIEW-AS DIALOG-BOX TITLE 'TRASLADANDO COTIZACION'.

  EMPTY TEMP-TABLE PEDI.

  i-NPedi = 0.

  DETALLES:
  FOR EACH Facdpedi OF B-CPEDI NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0,
      FIRST Almmmatg OF Facdpedi NO-LOCK BY Facdpedi.NroItm:
      DISPLAY Facdpedi.codmat WITH FRAME F-Mensaje.
      f-Factor = Facdpedi.Factor.
      F-CANPED = (FacDPedi.CanPed - FacDPedi.CanAte).
      /* FILTROS */
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = s-CodAlm  /* *** OJO *** */
          AND Almmmate.codmat = Facdpedi.CodMat
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almmmate THEN DO:
          MESSAGE 'Producto' Facdpedi.codmat 'NO asignado al almacén' s-CodAlm
              VIEW-AS ALERT-BOX WARNING.
          NEXT DETALLES.
      END.
      x-StkAct = Almmmate.StkAct.
/*       RUN vta2/Stock-Comprometido (Facdpedi.CodMat, s-CodAlm, OUTPUT s-StkComprometido). */
      RUN vta2/Stock-Comprometido-v2 (Facdpedi.CodMat, s-CodAlm, OUTPUT s-StkComprometido).
      s-StkDis = x-StkAct - s-StkComprometido.
      /* DEFINIMOS LA CANTIDAD */
      x-CanPed = f-CanPed * f-Factor.
      IF s-StkDis <= 0 THEN NEXT DETALLES.

      IF s-StkDis < x-CanPed THEN DO:
          f-CanPed = ((S-STKDIS - (S-STKDIS MODULO f-Factor)) / f-Factor).
      END.
      /* EMPAQUE SUPERMERCADOS */
      FIND FIRST supmmatg WHERE supmmatg.codcia = B-CPedi.CodCia
          AND supmmatg.codcli = B-CPedi.CodCli
          AND supmmatg.codmat = FacDPedi.codmat 
          NO-LOCK NO-ERROR.
      f-CanPed = f-CanPed * f-Factor.

      IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:
          f-CanPed = (TRUNCATE((f-CanPed / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).
          IF f-CanPed <= 0 THEN NEXT DETALLES.
      END.
      ELSE DO:    /* EMPAQUE OTROS */
          IF s-FlgEmpaque = YES THEN DO:
              IF Almmmatg.DEC__03 > 0 THEN f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).
          END.
      END.
      f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).
      IF f-CanPed > 0 THEN DO:
          /* GRABACION */
          I-NPEDI = I-NPEDI + 1.
          CREATE PEDI.
          BUFFER-COPY FacDPedi 
              EXCEPT 
              Facdpedi.CanSol 
              Facdpedi.CanApr
              Facdpedi.PreVta   /* NO control de transferencias Alm. 11 */
              TO PEDI
              ASSIGN 
                  PEDI.CodCia = s-codcia
                  PEDI.CodDiv = s-coddiv
                  PEDI.CodDoc = s-coddoc
                  PEDI.NroPed = ''
                  PEDI.ALMDES = s-CodAlm    /* *** OJO *** */
                  PEDI.NroItm = I-NPEDI.
          ASSIGN
              PEDI.CanPed = f-CanPed    /* << OJO << */
              PEDI.CanAte = 0
              PEDI.Libre_d01 = (FacDPedi.CanPed - FacDPedi.CanAte)
              PEDI.SdoCot    = (FacDPedi.CanPed - FacDPedi.CanAte)
              PEDI.Libre_d02 = f-CanPed
              PEDI.Libre_c01 = '*'.
          IF PEDI.CanPed <> FacdPedi.CanPed THEN DO:
              /* RECALCULAMOS */    
              ASSIGN
                  PEDI.ImpLin = PEDI.CanPed * PEDI.PreUni * 
                                ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                                ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                                ( 1 - PEDI.Por_Dsctos[3] / 100 ).
              IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
              THEN PEDI.ImpDto = 0.
              ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
              ASSIGN
                  PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
                  PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
              IF PEDI.AftIsc 
                  THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
              IF PEDI.AftIgv 
                  THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
          END.
          /* FIN DE CARGA */
      END.
  END.
  /* RHC 17/12/2015 EN CASO DE QUE EL ALMACEN SEA EL 11M TRATAMOS DE COMPLETAR EL PEDIDO 
  CON SALDOS DEL ALMACEN 11 */
  DEF VAR x-CodAlm AS CHAR NO-UNDO.
  IF s-CodAlm = "11M" THEN DO:
      x-CodAlm = "11".
      FOR EACH Facdpedi OF B-CPEDI NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0,
          FIRST Almmmatg OF Facdpedi NO-LOCK BY Facdpedi.NroItm:
          FIND PEDI WHERE PEDI.codmat = Facdpedi.codmat NO-ERROR.
          IF AVAILABLE PEDI AND PEDI.CanPed >= PEDI.SdoCot THEN NEXT. /* Ya está cubierto el pedido */
          f-Factor = Facdpedi.Factor.
          IF AVAILABLE PEDI THEN f-CanPed = PEDI.SdoCot - PEDI.CanPed.   /* Solo lo faltante */
          ELSE f-CanPed = (Facdpedi.CanPed - Facdpedi.CanAte).              /* Todo el saldo */
          /* Buscamos saldo del almacén 11 */
          /* FILTROS */
          FIND Almmmate WHERE Almmmate.codcia = s-codcia
              AND Almmmate.codalm = x-CodAlm  /* *** OJO *** */
              AND Almmmate.codmat = Facdpedi.CodMat
              NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Almmmate THEN NEXT.
          x-StkAct = Almmmate.StkAct.
/*           RUN vta2/Stock-Comprometido (Facdpedi.CodMat, x-CodAlm, OUTPUT s-StkComprometido). */
          RUN vta2/Stock-Comprometido-v2 (Facdpedi.CodMat, x-CodAlm, OUTPUT s-StkComprometido).
          s-StkDis = x-StkAct - s-StkComprometido.
          /* DEFINIMOS LA CANTIDAD */
          x-CanPed = f-CanPed * f-Factor.
          IF s-StkDis <= 0 THEN NEXT.
          IF s-StkDis < x-CanPed THEN DO:
              f-CanPed = ((S-STKDIS - (S-STKDIS MODULO f-Factor)) / f-Factor).  /* Ajustamos el saldo */
          END.
          /* EMPAQUE SUPERMERCADOS */
          f-CanPed = f-CanPed * f-Factor.
          IF s-FlgEmpaque = YES THEN DO:
              IF Almmmatg.DEC__03 > 0 THEN f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).
          END.
          f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).
          IF f-CanPed > 0 THEN DO:
              IF NOT AVAILABLE PEDI THEN DO:
                  /* GRABACION */
                  I-NPEDI = I-NPEDI + 1.
                  CREATE PEDI.
                  BUFFER-COPY FacDPedi 
                      EXCEPT 
                      Facdpedi.CanSol 
                      Facdpedi.CanApr
                      Facdpedi.PreVta   /* NO control de transferencias Alm. 11 */
                      TO PEDI
                      ASSIGN 
                          PEDI.CodCia = s-codcia
                          PEDI.CodDiv = s-coddiv
                          PEDI.CodDoc = s-coddoc
                          PEDI.NroPed = ''
                          PEDI.ALMDES = s-CodAlm  /* *** OJO *** */
                          PEDI.NroItm = I-NPEDI.
                  ASSIGN
                      PEDI.CanPed    = 0    /* Valor Inicial */
                      PEDI.CanAte    = 0
                      PEDI.Libre_d01 = (FacDPedi.CanPed - FacDPedi.CanAte)
                      PEDI.SdoCot    = (FacDPedi.CanPed - FacDPedi.CanAte)
                      PEDI.Libre_d02 = 0
                      PEDI.Libre_c01 = '*'.
              END.
              ASSIGN 
                  PEDI.CanPed    = PEDI.CanPed    + f-CanPed  /* << OJO << */
                  PEDI.Libre_d02 = PEDI.Libre_d02 + f-CanPed
                  PEDI.CanTrf    = f-CanPed                   /* OJO: Cantidad a Transferir */
                  PEDI.AlmTrf    = "11".
              ASSIGN
                  PEDI.ImpLin = PEDI.CanPed * PEDI.PreUni * 
                                ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                                ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                                ( 1 - PEDI.Por_Dsctos[3] / 100 ).
              IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
              THEN PEDI.ImpDto = 0.
              ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
              ASSIGN
                  PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
                  PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
              IF PEDI.AftIsc 
                  THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
              IF PEDI.AftIgv 
                  THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
          END.
      END.
  END.
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

DEF VAR pMensaje AS CHAR NO-UNDO.

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
    AND Ccbadocu.coddiv = Faccpedi.coddiv
    AND Ccbadocu.coddoc = Faccpedi.coddoc
    AND Ccbadocu.nrodoc = Faccpedi.nroped
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbadocu THEN DO:
    MESSAGE 'Aún NO ha ingresado los datos del transportista' SKIP
        'Continuamos?'
        VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE rpta-1 AS LOG.
    IF rpta-1 = NO THEN RETURN.
END.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN ON STOP UNDO, RETURN:
    FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccpedi THEN RETURN.
    IF Faccpedi.flgest <> "G" THEN DO:
        MESSAGE 'El Pedido ya fue aprobado por:' SKIP
            'Usuario:' FacCPedi.UsrAprobacion SKIP
            'Fecha:' FacCPedi.FchAprobacion SKIP(1)
            'Proceso abortado'
            VIEW-AS ALERT-BOX WARNING.
        FIND CURRENT Faccpedi NO-LOCK.
        RETURN.
    END.
    {vta2/verifica-cliente-01.i}
    /* RHC 22.11.2011 Verificamos los margenes y precios */
    IF Faccpedi.FlgEst = "X" THEN DO:
        pMensaje = "NO pasó la línea de crédito".
        LEAVE RLOOP.
    END.
    IF LOOKUP(s-CodDiv, '00000,00017,00018') > 0 THEN DO:
        {vta2/i-verifica-margen-utilidad-1.i}
        IF Faccpedi.FlgEst = "W" THEN DO:
            pMensaje = "NO pasó la margen de utilidad".
            LEAVE RLOOP.
        END.
    END.
    RUN vta2/pcreaordendesp (ROWID(Faccpedi), OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        UNDO RLOOP, LEAVE RLOOP.
    END.
END.
FIND CURRENT Faccpedi NO-LOCK.
RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
IF pMensaje <> "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.

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
  DEFINE VARIABLE f-CanPed AS DEC NO-UNDO.
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
  FOR EACH PEDI WHERE PEDI.CanPed <= 0:
      DELETE PEDI.
  END.
  /* **************************** PROMOCIONES ESPECIALES  **************************** */
/*   IF TODAY <= 03/09/2014 AND B-CPedi.TpoPed = "N" THEN                        */
/*   RUN vta2/promociones-pedidos-cred-01a ("MITZY", INPUT-OUTPUT TABLE PEDI).   */
/*   IF TODAY <= 03/09/2014 AND B-CPedi.TpoPed = "N" THEN                        */
/*   RUN vta2/promociones-pedidos-cred-01a ("AVENGER", INPUT-OUTPUT TABLE PEDI). */
  /* ********************************************************************************* */

  /* RHC 05/05/2014 nueva rutina de promociones */
  /*RUN vta2/promocion-general (INPUT-OUTPUT TABLE PEDI, OUTPUT pMensaje).*/
  FIND COTIZACION WHERE COTIZACION.codcia = s-codcia
      AND COTIZACION.coddoc = Faccpedi.codref
      AND COTIZACION.nroped = Faccpedi.nroref
      NO-LOCK NO-ERROR.
  RUN vta2/promocion-generalv2 (COTIZACION.Libre_c01,   /* División Lista Precio */
                                Faccpedi.CodCli,
                                INPUT-OUTPUT TABLE PEDI, 
                                OUTPUT pMensaje).
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  DETALLES:
  FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      /* FILTROS */
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = PEDI.AlmDes
          AND Almmmate.codmat = PEDI.CodMat
          NO-LOCK NO-ERROR.
      x-StkAct = Almmmate.StkAct.
/*       RUN vta2/Stock-Comprometido (PEDI.CodMat, PEDI.AlmDes, OUTPUT s-StkComprometido). */
      RUN vta2/Stock-Comprometido-v2 (PEDI.CodMat, PEDI.AlmDes, OUTPUT s-StkComprometido).
      s-StkDis = x-StkAct - s-StkComprometido.
      IF s-StkDis <= 0 THEN DO:
          pMensajeFinal = pMensajeFinal + 
              'El STOCK esta en CERO para el producto ' + PEDI.codmat + 
              ' en el almacén ' + PEDI.AlmDes + CHR(10).
          IF s-coddiv = "00506" THEN RETURN "ADM-ERROR".
          PEDI.CanPed = 0.  /* OJO: NO DESPACHAR */
          NEXT DETALLES.    /* << OJO << */
      END.
      /* ** */
      PEDI.CanPed  = PEDI.CanPed - PEDI.CanTrf.  /* Revertimos lo agregado */
      f-Factor = PEDI.Factor.
      F-CANPED = PEDI.CanPed.
      IF f-CanPed <= 0 THEN NEXT DETALLES.
      /* DEFINIMOS LA CANTIDAD */
      x-CanPed = f-CanPed * f-Factor.
      IF s-StkDis < x-CanPed THEN DO:
          IF s-coddiv = '00506' THEN DO:
                pMensajeFinal = pMensajeFinal + 
                'No hay STOCK suficiente para el producto ' + PEDI.codmat + 
                'en el almacén ' + PEDI.AlmDes + CHR(10).
              RETURN "ADM-ERROR".
          END.
      END.
      IF s-StkDis < x-CanPed THEN DO:
          /* Ajustamos de acuerdo a los multiplos */
          PEDI.CanPed = ( s-StkDis - ( s-StkDis MODULO f-Factor ) ) / f-Factor.
          IF PEDI.CanPed <= 0 THEN NEXT DETALLES.
      END.
      /* EMPAQUE SUPERMERCADOS */
      FIND FIRST supmmatg WHERE supmmatg.codcia = FacCPedi.CodCia
          AND supmmatg.codcli = FacCPedi.CodCli
          AND supmmatg.codmat = PEDI.codmat 
          NO-LOCK NO-ERROR.
      f-CanPed = PEDI.CanPed * f-Factor.

      IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:
          f-CanPed = (TRUNCATE((f-CanPed / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).
      END.
      ELSE DO:    /* EMPAQUE OTROS */
          IF s-FlgEmpaque = YES THEN DO:
              IF Almmmatg.DEC__03 > 0 THEN f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).
          END.
      END.
      PEDI.CanPed = ( f-CanPed - ( f-CanPed MODULO f-Factor ) ) / f-Factor.
  END.
  /* RHC 17/12/2015 EN CASO DE QUE EL ALMACEN SEA EL 11M TRATAMOS DE COMPLETAR EL PEDIDO 
  CON SALDOS DEL ALMACEN 11 */
  FOR EACH PEDI WHERE PEDI.CanPed < 0:
      PEDI.CanPed = 0.
  END.
  DEF VAR x-CodAlm AS CHAR NO-UNDO.
  IF s-CodAlm = "11M" THEN DO:
      x-CodAlm = "11".
      FOR EACH PEDI WHERE PEDI.CanTrf > 0, FIRST Almmmatg OF PEDI NO-LOCK:
          f-Factor = PEDI.Factor.
          f-CanPed = PEDI.CanTrf.    /* Solo lo faltante */
          /* Buscamos saldo del almacén 11 */
          /* FILTROS */
          FIND Almmmate WHERE Almmmate.codcia = s-codcia
              AND Almmmate.codalm = x-CodAlm  /* *** OJO *** */
              AND Almmmate.codmat = PEDI.CodMat
              NO-LOCK NO-ERROR.
          x-StkAct = Almmmate.StkAct.
/*           RUN vta2/Stock-Comprometido (PEDI.CodMat, x-CodAlm, OUTPUT s-StkComprometido). */
          RUN vta2/Stock-Comprometido-v2 (PEDI.CodMat, x-CodAlm, OUTPUT s-StkComprometido).
          s-StkDis = x-StkAct - s-StkComprometido.
          /* DEFINIMOS LA CANTIDAD */
          x-CanPed = f-CanPed * f-Factor.
          IF s-StkDis <= 0 THEN DO:
              PEDI.CanTrf = 0.   /* NO DESPACHAR */
              NEXT.
          END.
          IF s-StkDis < x-CanPed THEN DO:
              f-CanPed = ((S-STKDIS - (S-STKDIS MODULO f-Factor)) / f-Factor).  /* Ajustamos el saldo */
          END.
          /* EMPAQUE SUPERMERCADOS */
          f-CanPed = f-CanPed * f-Factor.
          IF s-FlgEmpaque = YES THEN DO:
              IF Almmmatg.DEC__03 > 0 THEN f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).
          END.
          f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).
          PEDI.CanTrf = f-CanPed.
      END.
  END.
  /* RECALCULAMOS */
  FOR EACH PEDI:
      IF PEDI.CanTrf < 0 THEN PEDI.CanTrf = 0.
      PEDI.CanPed = PEDI.CanPed + PEDI.CanTrf.
      ASSIGN
          PEDI.ImpLin = ROUND ( PEDI.CanPed * PEDI.PreUni * 
                        ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                        ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                        ( 1 - PEDI.Por_Dsctos[3] / 100 ), 2 ).
      IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
      THEN PEDI.ImpDto = 0.
      ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
      ASSIGN
          PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
          PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
      IF PEDI.AftIsc 
          THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
      IF PEDI.AftIgv 
          THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
  END.
  /* AHORA SÍ GRABAMOS EL PEDIDO */
  FOR EACH PEDI WHERE PEDI.CanPed > 0, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      I-NPEDI = I-NPEDI + 1.
      CREATE Facdpedi.
      BUFFER-COPY PEDI 
          TO Facdpedi
          ASSIGN
              Facdpedi.CodCia = Faccpedi.CodCia
              Facdpedi.CodDiv = Faccpedi.CodDiv
              Facdpedi.coddoc = Faccpedi.coddoc
              Facdpedi.NroPed = Faccpedi.NroPed
              Facdpedi.FchPed = Faccpedi.FchPed
              Facdpedi.Hora   = Faccpedi.Hora 
              Facdpedi.FlgEst = Faccpedi.FlgEst
              Facdpedi.NroItm = I-NPEDI.
  END.
  
  /* verificamos que al menos exista 1 item grabado */
  FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi 
  THEN RETURN 'ADM-ERROR'.
  ELSE RETURN 'OK'.

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
  DEF VAR i AS INT NO-UNDO.

  DEF VAR lCotProg AS LOG.

  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
      AND FacCorre.CodDoc = S-CODDOC 
      AND FacCorre.NroSer = s-NroSer
      NO-LOCK.
  IF FacCorre.FlgEst = NO THEN DO:
      MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR'.
  END.
  FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

  pNroCotizacion = "".

  RUN vta2/d-cotizacion-pend (OUTPUT s-CodAlm, OUTPUT s-NroCot).
  IF s-CodAlm = "" THEN RETURN "ADM-ERROR".

  ASSIGN
      s-FechaHora = ''
      s-FechaI = DATETIME(TODAY, MTIME)
      s-FechaT = ?
      s-adm-new-record = 'YES'
      s-PorIgv = FacCfgGn.PorIgv
      s-FlgEnv = YES.

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
      ASSIGN
          s-NroPed = ''
          s-CodCli = B-CPEDI.CodCli
          s-CodMon = B-CPEDI.CodMon                   /* >>> OJO <<< */
          s-TpoCmb = FacCfgGn.TpoCmb[1]
          s-FmaPgo = B-CPEDI.FmaPgo
          S-FlgIgv = B-CPedi.FlgIgv.
      DISPLAY 
          STRING(FacCorre.NroSer, '999') + STRING(FacCorre.Correlativo, '999999') @ Faccpedi.NroPed
          TODAY @ Faccpedi.FchPed
          B-CPEDI.Glosa  @ Faccpedi.Glosa.
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
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  /* Bloqueamos el correlativo para controlar las actualizaciones multiusuario */
  DEF VAR iLocalCounter AS INTEGER INITIAL 0 NO-UNDO.
  GetLock:
  DO ON STOP UNDO GetLock, RETRY GetLock:
      IF RETRY THEN DO:
          iLocalCounter = iLocalCounter + 1.
          IF iLocalCounter = 5 THEN LEAVE GetLock.
      END.
      FIND FacCorre WHERE FacCorre.CodCia = s-CodCia AND
          FacCorre.CodDoc = s-coddoc AND
          FacCorre.NroSer = s-nroser EXCLUSIVE-LOCK NO-ERROR.
  END. 
  IF iLocalCounter = 5 OR NOT AVAILABLE FacCorre THEN UNDO, RETURN "ADM-ERROR".
  /* RHC 21/01/2014 BLOQUEAMOS LA COTIZACION TAMBIEN */
  GetLock :
  DO ON STOP UNDO GetLock, RETRY GetLock:
      IF RETRY THEN DO:
          iLocalCounter = iLocalCounter + 1.
          IF iLocalCounter = 5 THEN LEAVE GetLock.
      END.
      FIND B-CPedi WHERE B-CPedi.CodCia = s-CodCia
          AND B-CPedi.CodDiv = s-CodDiv
          AND B-CPedi.CodDoc = s-CodRef
          AND B-CPedi.NroPed = s-NroCot EXCLUSIVE-LOCK NO-ERROR.
  END. 
  IF iLocalCounter = 5 OR NOT AVAILABLE B-CPEDI THEN UNDO, RETURN "ADM-ERROR".
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = "YES" THEN DO:  /* SOLO CUANDO ES UN NUEVO PEDIDO */
      IF B-CPEDI.FlgEst <> "P" THEN DO:
          pMensaje = "La cotización ha sido modificada por otro usuario"  + CHR(10) +
              "Proceso abortado".
          UNDO, RETURN "ADM-ERROR".
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* DATOS DE LA CABECERA */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = 'YES' THEN DO:
      {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}
      ASSIGN 
          Faccpedi.CodCia = S-CODCIA
          Faccpedi.CodDoc = s-coddoc 
          Faccpedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
          Faccpedi.CodRef = s-codref      /* COT */
          Faccpedi.FchPed = TODAY 
          Faccpedi.PorIgv = s-PorIgv 
          Faccpedi.CodDiv = S-CODDIV
          Faccpedi.FlgEst = "G"       /* FLAG TEMPORAL POR APROBAR */
          FacCPedi.TpoPed = s-TpoPed
          FacCPedi.FlgEnv = s-FlgEnv
          FacCPedi.Libre_c01 = s-User-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM')
          FacCPedi.Ubigeo[1] = B-CPEDI.Ubigeo[1]    /* Sede del Cliente CANAL MODERNO */
          .
      ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
      
      /* TRACKING */
      RUN vtagn/pTracking-04 (s-CodCia,
                        s-CodDiv,
                        Faccpedi.CodDoc,
                        Faccpedi.NroPed,
                        s-User-Id,
                        'GNP',
                        'P',
                        DATETIME(TODAY, MTIME),
                        DATETIME(TODAY, MTIME),
                        Faccpedi.CodDoc,
                        Faccpedi.NroPed,
                        Faccpedi.CodRef,
                        Faccpedi.NroRef).
      
  END.
  ELSE DO:
      /* Actualizamos la cotizacion */
      RUN vta2/pactualizacotizacion ( ROWID(Faccpedi), "D", OUTPUT pMensaje).
      /*RUN vta2/actualiza-cotizacion-01 ( ROWID(Faccpedi), -1, OUTPUT pMensaje ).*/
      IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
      RUN Borra-Pedido (TRUE).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          pMensaje = "NO se pudo actualizar el pedido".
          UNDO, RETURN 'ADM-ERROR'.
      END.
  END.
  /* Actualizamos la hora cuando lo vuelve a modificar */
  ASSIGN
      Faccpedi.Usuario = S-USER-ID
      Faccpedi.Hora   = STRING(TIME,"HH:MM").
  /* Division destino */
  FIND Almacen OF Faccpedi NO-LOCK NO-ERROR.
  IF AVAILABLE Almacen THEN FacCPedi.DivDes = Almacen.CodDiv.

  /* Detalle del Pedido */
  RUN Genera-Pedido.    /* Detalle del pedido */
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      pMensaje = 'NO se pudo generar el pedido' + CHR(10) + 'NO hay stock suficiente en los almacenes'.
      UNDO, RETURN 'ADM-ERROR'.
  END.
  
  /* RHC 08.08.11 agrupamos las promociones */
/*   RUN vta2/promociones-pedidos-cred-01 ( ROWID(Faccpedi), OUTPUT pMensaje). */
/*   IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.              */

  /* RHC 19/12/2015 Transferencias (Faccpedi.TipVta = "CMTRANSF") */
  RUN vta2/ptransfxpedido (ROWID(Faccpedi), "11", "11M") NO-ERROR.
  IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.

  /* Grabamos Totales */
  {vta2/graba-totales-cotizacion-cred.i}

  /* Actualizamos la cotizacion */
  RUN vta2/pactualizacotizacion ( ROWID(Faccpedi), "C", OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

  /* *********************************************************** */
/*   RUN Facturas-Adelantadas. */

  IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
  IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
  IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.

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
    IF LOOKUP(FacCPedi.FlgEst,"A,C,E,R,F,S") > 0 THEN DO:
          MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
          RETURN "ADM-ERROR".
    END.
    /* RHC 15.11.05 VERIFICAR SI TIENE ATENCIONES PARCIALES */
    FIND FIRST FacDPedi OF FacCPedi WHERE FacDPedi.CanAte > 0 NO-LOCK NO-ERROR.
    IF AVAILABLE FacDPedi THEN DO:
        MESSAGE 'No se puede eliminar/modificar un pedido con atenciones parciales' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
        AND Ccbcdocu.fchdoc >= Faccpedi.fchped
        AND Ccbcdocu.codped = Faccpedi.coddoc
        AND Ccbcdocu.nroped = Faccpedi.nroped
        AND LOOKUP(Ccbcdocu.coddoc, "FAC,BOL") > 0
        AND Ccbcdocu.flgest <> "A"
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbcdocu THEN DO:
        MESSAGE 'No se puede eliminar/modificar un pedido con atenciones parciales' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.


/*     {adm/i-DocPssw.i s-CodCia s-CodDoc ""DEL""} */

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* RHC 21/01/2014 BLOQUEAMOS LA COTIZACION COMO CONTROL MULTIUSUARIO */
        {lib/lock-wait.i &Tabla=B-CPedi &Condicion="B-CPedi.CodCia=FacCPedi.CodCia ~
            AND B-CPedi.CodDiv=FacCPedi.CodDiv ~
            AND B-CPedi.CodDoc=FacCPedi.CodRef ~
            AND B-CPedi.NroPed=FacCPedi.NroRef"}

        /* RHC BLOQUEAMOS PEDIDO */
        FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE Faccpedi THEN UNDO, RETURN 'ADM-ERROR'.

        /* Actualizamos Cotizacion */
        RUN vta2/pactualizacotizacion ( ROWID(Faccpedi), "D", OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.

        /* Extorna transferencias automáticas entre alm 11 y 11m */
        RUN vta2/pextornatransfxped ( ROWID(Faccpedi) ) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.

        /* TRACKING */
        RUN vtagn/pTracking-04 (s-CodCia,
                          s-CodDiv,
                          Faccpedi.CodDoc,
                          Faccpedi.NroPed,
                          s-User-Id,
                          'GNP',
                          'A',
                          DATETIME(TODAY, MTIME),
                          DATETIME(TODAY, MTIME),
                          Faccpedi.CodDoc,
                          Faccpedi.NroPed,
                          Faccpedi.CodRef,
                          Faccpedi.NroRef).
        ASSIGN
            FacCPedi.Glosa = "ANULADO POR " + s-user-id + " EL DIA " + STRING ( DATETIME(TODAY, MTIME), "99/99/9999 HH:MM" ).
            Faccpedi.FlgEst = 'A'.
        FIND CURRENT Faccpedi NO-LOCK.
        IF AVAILABLE(B-CPEDI) THEN RELEASE B-CPEDI.
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
        Faccpedi.FchPed:SENSITIVE = NO.
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
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje <> "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RETURN 'ADM-ERROR'.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resumen-por-Division V-table-Win 
PROCEDURE Resumen-por-Division :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN vtagn/p-pedresdiv (s-codcia, s-codalm, s-codmon, s-tpocmb, s-flgenv).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-cotizacion-preventa V-table-Win 
PROCEDURE ue-cotizacion-preventa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
 
DO WITH FRAME {&FRAME-NAME}:
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

IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".
/*IF LOOKUP(FacCPedi.FlgEst,"P,F,C,A,E,R,W,WX,WL") > 0 THEN DO:*/
IF FacCPedi.FlgEst <> "G" THEN DO:
      MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
END.
/* RHC 15.11.05 VERIFICAR SI TIENE ATENCIONES PARCIALES */
FIND FIRST FacDPedi OF FacCPedi WHERE FacDPedi.CanAte > 0 NO-LOCK NO-ERROR.
IF AVAILABLE FacDPedi THEN DO:
    MESSAGE 'No se puede eliminar/modificar un pedido con atenciones parciales' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.codped = Faccpedi.coddoc
    AND Ccbcdocu.nroped = Faccpedi.nroped
    AND LOOKUP(Ccbcdocu.coddoc, "FAC,BOL") > 0
    AND Ccbcdocu.flgest <> "A"
    NO-LOCK NO-ERROR.
IF AVAILABLE Ccbcdocu THEN DO:
    MESSAGE 'No se puede eliminar/modificar un pedido con atenciones parciales' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
/* RHC 19/12/2015 Pedidos que han generado transferencias entre alm 11 y 11m */
IF Faccpedi.TipVta = "CMTRANSF" THEN DO:
    MESSAGE 'Acceso Denegado' SKIP
        'Se han generado transferencias automáticas entre los almacenes 11 y 11m'
        VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

ASSIGN
    s-NroPed = FacCPedi.NroPed
    S-CODMON = FacCPedi.CodMon
    s-TpoCmb = FacCPedi.TpoCmb
    S-CODCLI = FacCPedi.CodCli
    s-NroCot = FacCPedi.NroRef
    s-adm-new-record = 'NO'
    s-FlgEnv = FacCPedi.FlgEnv
    s-codalm = FacCPedi.CodAlm
    s-PorIgv = Faccpedi.PorIgv
    s-FmaPgo = Faccpedi.FmaPgo.

ASSIGN pFechaEntrega = faccpedi.fchent.

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

