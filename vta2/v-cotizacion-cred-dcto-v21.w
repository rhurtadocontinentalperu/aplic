&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER BDctoDivLin FOR VtaTabla.
DEFINE BUFFER BDctoLin FOR VtaTabla.
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.



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
DEFINE BUFFER B-CPEDI FOR FacCPedi.


DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE CL-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE s-nivel    AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB   AS DECIMAL.  
DEFINE SHARED VARIABLE s-PorIgv LIKE Faccpedi.PorIgv.
DEFINE SHARED VARIABLE s-DtoMax   AS DECIMAL.

/* Local Variable Definitions ---                          */
DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROPED       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE C-CODVEN       AS CHARACTER NO-UNDO.

FIND FacCorre WHERE 
     FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer
          S-PRINTER-NAME = FacCorre.Printer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.


DEFINE VAR NIV  AS CHAR.
DEFINE VARIABLE X-MARGEN    AS DECIMAL   NO-UNDO.

/* ICBPER */
DEFINE VAR x-articulo-ICBPER AS CHAR.

x-articulo-ICBPER = '099268'.

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
&Scoped-define EXTERNAL-TABLES FacCPedi
&Scoped-define FIRST-EXTERNAL-TABLE FacCPedi


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR FacCPedi.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS FacCPedi.Glosa 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.FchPed ~
FacCPedi.CodCli FacCPedi.FaxCli FacCPedi.usuario FacCPedi.NomCli ~
FacCPedi.CodMon FacCPedi.CodVen FacCPedi.TpoCmb FacCPedi.FmaPgo ~
FacCPedi.Glosa FacCPedi.PorDto 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-nomVen F-CndVta 

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
DEFINE VARIABLE F-CndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE VARIABLE F-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "ESTADO" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-nomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1.27 COL 15 COLON-ALIGNED
          LABEL "Número" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
          FONT 1
     F-Estado AT ROW 1.27 COL 39 COLON-ALIGNED WIDGET-ID 2
     FacCPedi.FchPed AT ROW 1.27 COL 99 COLON-ALIGNED
          LABEL "Fecha de emisión"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodCli AT ROW 2.08 COL 15 COLON-ALIGNED
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
     FacCPedi.FaxCli AT ROW 2.08 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 124 FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .81
          FONT 6
     FacCPedi.usuario AT ROW 2.08 COL 99 COLON-ALIGNED
          LABEL "Digitado por"
          VIEW-AS FILL-IN 
          SIZE 10.86 BY .81
     FacCPedi.NomCli AT ROW 2.88 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 61 BY .81
     FacCPedi.CodMon AT ROW 2.88 COL 101 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.14 BY .81
     FacCPedi.CodVen AT ROW 3.69 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
     F-nomVen AT ROW 3.69 COL 22 COLON-ALIGNED NO-LABEL
     FacCPedi.TpoCmb AT ROW 3.69 COL 99.29 COLON-ALIGNED
          LABEL "Tpo.Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.FmaPgo AT ROW 4.5 COL 15 COLON-ALIGNED WIDGET-ID 4
          LABEL "Condición de Venta"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .81
     F-CndVta AT ROW 4.5 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     FacCPedi.Glosa AT ROW 5.31 COL 12.28
          LABEL "Glosa"
          VIEW-AS FILL-IN 
          SIZE 61 BY .81
     FacCPedi.PorDto AT ROW 5.31 COL 99 COLON-ALIGNED
          LABEL "% Dscto." FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
          BGCOLOR 15 FGCOLOR 12 FONT 6
     "Moneda" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 3.15 COL 94
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.FacCPedi
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: BDctoDivLin B "?" ? INTEGRAL VtaTabla
      TABLE: BDctoLin B "?" ? INTEGRAL VtaTabla
      TABLE: ITEM T "SHARED" ? INTEGRAL FacDPedi
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
         HEIGHT             = 5.92
         WIDTH              = 118.72.
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
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR RADIO-SET FacCPedi.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FaxCli IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN FacCPedi.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.PorDto IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN FacCPedi.TpoCmb IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME FacCPedi.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodMon V-table-Win
ON VALUE-CHANGED OF FacCPedi.CodMon IN FRAME F-Main /* Cod!mon */
DO:
  S-CODMON = INTEGER(FacCPedi.CodMon:SCREEN-VALUE).
  RUN Procesa-Handle IN lh_Handle ('Recalculo').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FacCPedi.PorDto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.PorDto V-table-Win
ON LEAVE OF FacCPedi.PorDto IN FRAME F-Main /* % Dscto. */
DO:
  IF DECIMAL(Faccpedi.PorDto:SCREEN-VALUE) > 0 THEN DO:
/*       IF DECIMAL(Faccpedi.PorDto:SCREEN-VALUE) > s-DTOMAX THEN DO:                          */
/*           MESSAGE "El descuento no puede ser mayor a " s-DTOMAX  VIEW-AS ALERT-BOX WARNING. */
/*           RETURN NO-APPLY.                                                                  */
/*       END.                                                                                  */
      IF DECIMAL(Faccpedi.PorDto:SCREEN-VALUE) > s-DTOMAX THEN DO:
          MESSAGE "El descuento no puede ser mayor a " s-DTOMAX  SKIP
              'Continuamos con el proceso?' VIEW-AS ALERT-BOX QUESTION
              BUTTONS YES-NO UPDATE rpta AS LOG.
          IF rpta = NO THEN RETURN NO-APPLY.
      END.
      RUN Actualiza-Descuento ( DECIMAL(Faccpedi.PorDto:SCREEN-VALUE) ).
      SELF:SCREEN-VALUE = '0.00'.
  END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Descuento V-table-Win 
PROCEDURE Actualiza-Descuento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Puede ser 0 (cero)
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER pPorDto AS DEC.

  DEF VAR xPorDto AS DEC.
  DEF VAR pError AS CHAR NO-UNDO.
  DEF VAR X-MARGEN AS DEC NO-UNDO.
  DEF VAR X-LIMITE AS DEC NO-UNDO.
  DEF VAR x-PreUni AS DEC NO-UNDO.

  FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK:
      /* ************************************************************************** */
      /* SI TIENE DESCUENTO POR VOL/PROM */
      /* ************************************************************************** */
      IF (ITEM.Por_DSCTOS[3] <> 0 OR ITEM.Por_DSCTOS[2] <> 0) THEN NEXT.
      /* RHC 07/02/1029 Caso de cuadernos */
      IF ITEM.Libre_c04 = "DVXSALDOC" THEN NEXT.
      /* ************************************************************************** */
      /* Buscamos la equivalencia con el MLL */
      /* Si se vende mas de un millar no puede superar el 1% de descuento */
      /* ************************************************************************** */
      FIND Almtconv WHERE Almtconv.CodUnid = ITEM.UndVta
          AND Almtconv.Codalter = "MLL"
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almtconv THEN DO:
          IF ITEM.CanPed / Almtconv.Equival >= 1 AND pPorDto > 1 THEN NEXT.
/*           IF ITEM.CanPed / Almtconv.Equival < 1 THEN NEXT. */
      END.
      /* ************************************************************************** */
      /* RHC 08/02/2019 G.R. descuento configurado por linea para productos propios y terceros */
      /* ************************************************************************** */
      /* Descuento configurado por linea */
      FIND FIRST BDctoLin WHERE BDctoLin.codcia = s-codcia
          AND BDctoLin.Tabla = 'NA'
          AND BDctoLin.Llave_c1 = s-Nivel
          AND BDctoLin.Llave_c2 = Almmmatg.CodFam
          NO-LOCK NO-ERROR.
      /* Descuento configurado por división y línea */
      FIND FIRST BDctoDivLin WHERE BDctoDivLin.codcia = s-codcia
          AND BDctoDivLin.Tabla = 'NADL'
          AND BDctoDivLin.Llave_c1 = s-Nivel
          AND BDctoDivLin.Llave_c2 = s-CodDiv
          AND BDctoDivLin.Llave_c3 = Almmmatg.CodFam
          NO-LOCK NO-ERROR.
      /* NOTA: en caso de productos propios NO se aceptan descuento salvo que esté declarado como excepción */
      IF Almmmatg.CHR__02 = "P" THEN DO:
          /* Debe haber al menos un descuento */
          IF NOT (AVAILABLE BDctoLin OR AVAILABLE BDctoDivLin) THEN NEXT.
          /* Primero por División y Línea */
          IF NOT AVAILABLE BDctoDivLin OR BDctoDivLin.Valor[2] <= 0 THEN DO:
              /* Segundo por Línea */
              IF NOT AVAILABLE BDctoLin OR BDctoLin.Valor[2] <= 0 THEN NEXT.
          END.
      END.
      /* ************************************************************************** */
      /*  NIVELES DE DESCUENTO */
      /* Nota: Por defecto se debe tomar el de la división y línea */
      /* ************************************************************************** */
      ASSIGN
          xPorDto = 0.
      CASE TRUE:
          WHEN Almmmatg.CHR__02 = "T" AND AVAILABLE BDctoDivLin AND BDctoDivLin.Valor[1] > 0 
              THEN xPorDto = MINIMUM(BDctoDivLin.Valor[1], pPorDto).
          WHEN Almmmatg.CHR__02 = "T" AND AVAILABLE BDctoLin AND BDctoLin.Valor[1] > 0 
              THEN xPorDto = MINIMUM(BDctoLin.Valor[1], pPorDto).
          WHEN Almmmatg.CHR__02 = "P" AND AVAILABLE BDctoDivLin AND BDctoDivLin.Valor[2] > 0 
              THEN xPorDto = MINIMUM(BDctoDivLin.Valor[2], pPorDto).
          WHEN Almmmatg.CHR__02 = "P" AND AVAILABLE BDctoLin AND BDctoLin.Valor[2] > 0 
              THEN xPorDto = MINIMUM(BDctoLin.Valor[2], pPorDto).
      END CASE.
      /* ************************************************************************** */
      /* Si xPorDto > 0 entonces es el que vale */
      /* ************************************************************************** */
      IF xPorDto <= 0 THEN ASSIGN xPorDto = MINIMUM(s-DtoMax, pPorDto).  /* NO Puede superar el dcto maximo */
      /* ************************************************************************** */
      /* RHC 13.12.2010 Margen de Utilidad */
      /* ************************************************************************** */
      x-PreUni = ITEM.PreUni * ( 1 - xPorDto / 100 ) *
                                ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                                ( 1 - ITEM.Por_Dsctos[3] / 100 ) .
      RUN vtagn/p-margen-utilidad (
          ITEM.CodMat,
          x-PreUni,  
          ITEM.UndVta,
          s-CodMon,       /* Moneda de venta */
          s-TpoCmb,       /* Tipo de cambio */
          YES,            /* Muestra el error */
          ITEM.AlmDes,
          OUTPUT x-Margen,        /* Margen de utilidad */
          OUTPUT x-Limite,        /* Margen mínimo de utilidad */
          OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
          ).
      IF pError = "ADM-ERROR" THEN NEXT.
      /* ************************************************************************** */
      ASSIGN 
          ITEM.Por_Dsctos[1] = xPorDto.
  END.
  RUN Procesa-Handle IN lh_Handle ('recalcular-precios'). 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Detalle V-table-Win 
PROCEDURE Actualiza-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE F-NRO AS DECIMAL NO-UNDO.

EMPTY TEMP-TABLE ITEM.
FOR EACH FacDPedi OF FacCPedi NO-LOCK:
    CREATE ITEM.
    BUFFER-COPY FacDPedi TO ITEM.
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
  {src/adm/template/row-list.i "FacCPedi"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "FacCPedi"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FOR EACH FacDPedi OF FacCPedi:
        DELETE FacDPedi.
    END.
    FOR EACH ITEM:
        CREATE FacDPedi.
        BUFFER-COPY ITEM TO FacDPedi.
    END.
END.

/*   
   FOR EACH  FacDPedi EXCLUSIVE-LOCK WHERE 
             FacDPedi.codcia = FacCPedi.codcia AND
             FacDPedi.coddoc = FacCPedi.coddoc AND
             FacDPedi.nroped = FacCPedi.nroped
             ON ERROR UNDO, RETURN "ADM-ERROR":
       DELETE FacDPedi.
   END.
   FOR EACH ITEM NO-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
       CREATE FacDPedi.
       RAW-TRANSFER ITEM TO FacDPedi.
       ASSIGN FacDPedi.CodCia = FacCPedi.CodCia
              FacDPedi.coddoc = FacCPedi.coddoc
              FacDPedi.NroPed = FacCPedi.NroPed
              FacDPedi.FlgEst = FacCPedi.FlgEst
              FacDPedi.Hora   = FacCPedi.Hora
              FacDPedi.FchPed = FacCPedi.FchPed
              FacDPedi.Por_Dsctos[3] = 0.
   END.
*/

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

{vta2/graba-totales-cotizacion-cred.i}

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
  RUN Genera-Detalle.
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
  RUN Graba-Totales.
  ASSIGN
      FacCPedi.UsrDscto = s-user-id + '|' + STRING (DATETIME(TODAY, MTIME)).
  
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
  RUN Procesa-Handle IN lh_Handle ('browse'). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  FacCPedi.PorDto:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

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
  IF AVAILABLE FacCPedi THEN DO WITH FRAME {&FRAME-NAME}:
      RUN vta2/p-faccpedi-flgest (Faccpedi.flgest, Faccpedi.coddoc, OUTPUT f-Estado).
      DISPLAY f-Estado.
     F-NomVen:screen-value = "".
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = FacCPedi.CodVen NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
     F-CndVta:SCREEN-VALUE = "".
     FIND gn-convt WHERE gn-convt.Codig = FacCPedi.FmaPgo NO-LOCK NO-ERROR.
     IF AVAILABLE gn-convt THEN F-CndVta:SCREEN-VALUE = gn-convt.Nombr.
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
  /*
  IF s-User-Id = "CAA-13"   /* CARMEN AYALA EXPOLIBRERIA */
  THEN FacCPedi.PorDto:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  ELSE FacCPedi.PorDto:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  */
  FacCPedi.PorDto:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

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
  
  IF FacCPedi.FlgEst <> "A" THEN RUN vta/R-IMPCOT (ROWID(FacCPedi)).
  
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

  RUN Procesa-Handle IN lh_Handle ('Pagina1').
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

IF FacCPedi.FlgEst <> "A" THEN DO:
/*   NIV = "".
 *    RUN VTA/D-CLAVE.R("D",
 *                     " ",
 *                     OUTPUT NIV,
 *                     OUTPUT RPTA).
 *    IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".*/
   
   RUN vtamay/d-mrgped (ROWID(FacCPedi)).

/* RHC 16.10.04 NUEVO PROGRAMA */
/*   DEFINE VAR X-COSTO  AS DECI INIT 0.
 *    DEFINE VAR T-COSTO  AS DECI INIT 0.
 *    DEFINE VAR X-MARGEN AS DECI INIT 0.
 *    FOR EACH FacDPedi OF FacCPedi NO-LOCK :
 *        FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND
 *                            Almmmatg.Codmat = FacDPedi.Codmat NO-LOCK NO-ERROR.
 *        X-COSTO = 0.
 *        IF AVAILABLE Almmmatg THEN DO:
 *           IF FacCPedi.CodMon = 1 THEN DO:
 *              IF Almmmatg.MonVta = 1 THEN 
 *                 ASSIGN X-COSTO = (Almmmatg.Ctotot).
 *              ELSE
 *                 ASSIGN X-COSTO = (Almmmatg.Ctotot) * FacCPedi.Tpocmb .
 *           END.        
 *           IF FacCPedi.CodMon = 2 THEN DO:
 *              IF Almmmatg.MonVta = 2 THEN
 *                 ASSIGN X-COSTO = (Almmmatg.Ctotot).
 *              ELSE
 *                 ASSIGN X-COSTO = (Almmmatg.Ctotot) / FacCPedi.Tpocmb .
 *           END.      
 *           T-COSTO = T-COSTO + X-COSTO * FacDPedi.CanPed.          
 *        END.
 *    END.
 *    X-MARGEN = ROUND(((( FacCPedi.ImpTot / T-COSTO ) - 1 ) * 100 ),2).
 *    IF X-MARGEN < 20 THEN DO:
 *       MESSAGE " Margen Obtenido Para Actual Cotizacion " SKIP
 *               "             " + STRING(X-MARGEN,"->>9.99%")
 *               VIEW-AS ALERT-BOX WARNING .
 *    END.
 *    ELSE DO:
 *       MESSAGE " Margen Obtenido Para Actual Cotizacion " SKIP
 *               "             " + STRING(X-MARGEN,"->>9.99%")
 *               VIEW-AS ALERT-BOX INFORMATION.
 *    END.*/
            
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
  {src/adm/template/snd-list.i "FacCPedi"}

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
  IF p-state = 'update-begin':U THEN DO:
     RUN Actualiza-Detalle.
     RUN Procesa-Handle IN lh_Handle ('Pagina2').
     RUN Procesa-Handle IN lh_Handle ('browse').
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
/* DEFINE VARIABLE F-DSCTO AS DECIMAL NO-UNDO.                                */
/*                                                                            */
/* FOR EACH ITEM:                                                             */
/*     /* RHC 13.12.2010 Margen de Utilidad */                                */
/*     DEF VAR pError AS CHAR NO-UNDO.                                        */
/*     DEF VAR X-MARGEN AS DEC NO-UNDO.                                       */
/*     DEF VAR X-LIMITE AS DEC NO-UNDO.                                       */
/*     DEF VAR x-PreUni AS DEC NO-UNDO.                                       */
/*                                                                            */
/*     x-PreUni = ITEM.PreUni *                                               */
/*         ( 1 - ITEM.Por_Dsctos[1] / 100 ) *                                 */
/*         ( 1 - ITEM.Por_Dsctos[2] / 100 ) *                                 */
/*         ( 1 - ITEM.Por_Dsctos[3] / 100 ) .                                 */
/*     RUN vtagn/p-margen-utilidad (                                          */
/*         ITEM.CodMat,      /* Producto */                                   */
/*         x-PreUni,  /* Precio de venta unitario */                          */
/*         ITEM.UndVta,                                                       */
/*         s-CodMon,       /* Moneda de venta */                              */
/*         s-TpoCmb,       /* Tipo de cambio */                               */
/*         YES,            /* Muestra el error */                             */
/*         ITEM.AlmDes,                                                       */
/*         OUTPUT x-Margen,        /* Margen de utilidad */                   */
/*         OUTPUT x-Limite,        /* Margen mínimo de utilidad */            */
/*         OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */ */
/*         ).                                                                 */
/*     IF pError = "ADM-ERROR" THEN DO:                                       */
/*         RETURN "ADM-ERROR".                                                */
/*     END.                                                                   */
/* END.                                                                       */

RETURN "OK".

END PROCEDURE.


/* RHC 28.09.05 

DEFINE VARIABLE F-DSCTO AS DECIMAL NO-UNDO.
DO WITH FRAME {&FRAME-NAME}:
   
   /******************************************/
   DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
   DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
   DEFINE VARIABLE POR_DSCREM AS DECIMAL NO-UNDO.
   DEFINE VARIABLE DSCT_REM AS DECIMAL NO-UNDO.
   DEFINE VARIABLE P-VAL1 AS DECIMAL.
   DEFINE VARIABLE P-VAL2 AS DECIMAL.
   DEFINE VARIABLE M1 AS DECIMAL.
   DEFINE VARIABLE M2 AS DECIMAL.
   
   DEFINE VARIABLE X-ImpDto AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-ImpIgv AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-ImpIsc AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-ImpTot AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-ImpExo AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-ImpBrt AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-ImpVta AS DECIMAL NO-UNDO.
   DEFINE VARIABLE X-Bruto  AS DECIMAL NO-UNDO.

/*
   X-ImpDto = 0.
   X-ImpIgv = 0.
   X-ImpIsc = 0.
   X-ImpTot = 0.
   X-ImpExo = 0.
   X-ImpBrt = 0.
   X-ImpVta = 0.
   X-Bruto = 0.
   F-IGV = 0.
   F-ISC = 0.
   P-VAL1 = 0.
   P-VAL2 = 0.
   M1 = 0.
   M2 = 0.
   FOR EACH ITEM NO-LOCK:
       POR_DSCREM = ROUND(((1 - ((1 - ITEM.Por_Dsctos[2] / 100) / (1 - ITEM.PorDto / 100))) * 100), 2).
        DSCT_REM = DSCT_REM + (ITEM.PreUni * (IF ITEM.Flg_factor = "1" THEN 
                              ITEM.CanPed ELSE (ITEM.CanPed * ITEM.Factor)) * 
                              (POR_DSCREM / 100)
                              ).
       X-Bruto = X-Bruto + (ITEM.PreUni * (IF ITEM.Flg_factor = "1" THEN                                ITEM.CanPed ELSE (ITEM.CanPed * ITEM.Factor))
                              ).
                              
       X-ImpDto = X-ImpDto + ITEM.ImpDto.
         F-IGV  = F-IGV + ITEM.ImpIgv.
         F-ISC  = F-ISC + ITEM.ImpIsc.
       X-ImpTot = X-ImpTot + ITEM.ImpLin.
       IF NOT ITEM.AftIgv THEN X-ImpExo = X-ImpExo + ITEM.ImpLin.
   END.
   
   X-ImpIgv = ROUND(F-IGV,2).
   X-ImpIsc = ROUND(F-ISC,2).
   X-ImpBrt = X-ImpTot - X-ImpIgv - X-ImpIsc + 
                    X-ImpDto - X-ImpExo.
   X-ImpVta = X-ImpBrt - X-ImpDto.

   P-VAL1 = (((DECIMAL(FacCPedi.PorDto:SCREEN-VALUE) / 100) * X-ImpVta) + X-ImpDto).
   P-VAL2 = ((F-DTOMAX / 100) * X-Bruto ).
   M1 = ROUND(((((F-DTOMAX / 100) * X-Bruto ) - X-ImpDto) / X-Bruto) * 100 , 2).
   M2 = ROUND(((DSCT_REM - X-ImpDto) / X-ImpVta) * 100, 2).
   
   /* MESSAGE P-VAL1 P-VAL2 M1 M2 VIEW-AS ALERT-BOX.*/
   
   IF P-VAL1 > P-VAL2 THEN DO:
        MESSAGE "Se ha excedido DSCTO. de Usuario" SKIP
                "posible DSCTO1. : " M1 " %" SKIP
                VIEW-AS ALERT-BOX ERROR TITLE "Descuento por Monto".
        APPLY "ENTRY":U TO FacCPedi.PorDto.
        RETURN "ADM-ERROR".
   END.
   
   P-VAL2 = ((DSCT_REM / 100) * X-Bruto ).
/*   MESSAGE P-VAL1 P-VAL2 VIEW-AS ALERT-BOX.*/
   IF P-VAL1 > P-VAL2 THEN DO:
        MESSAGE "Se ha excedido DSCTO. de Usuario" SKIP
                "posible DSCTO2. : " M2 " %" SKIP
                VIEW-AS ALERT-BOX ERROR TITLE "Descuento por Monto".
        APPLY "ENTRY":U TO FacCPedi.PorDto.
        RETURN "ADM-ERROR".
   END.
   
   
   
   /******************************************/

/*   FOR EACH ITEM:
 *        F-DSCTO = F-DSCTO + ITEM.ImpDto.
 *    END.
 *    F-DSCTO = 0.
 *    IF F-DSCTO > 0 AND DECIMAL(FacCPedi.PorDto:SCREEN-VALUE) > 0 THEN DO:
 *       MESSAGE "El pedido ya tiene descuentos por ITEM"  VIEW-AS ALERT-BOX ERROR.
 *       APPLY "ENTRY":U TO FacCPedi.PorDto.
 *       RETURN "ADM-ERROR".
 *    END.*/

*/
 
END.

RETURN "OK".

*/

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

IF Faccpedi.ImpDto2 > 0
THEN DO:
    MESSAGE "La venta tiene descuentos especiales" SKIP
        "Acceso denegado"
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
/* NO PASA si tiene atenciones parciales */
FIND FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate <> 0 NO-LOCK NO-ERROR.
IF AVAILABLE Facdpedi THEN DO:
    MESSAGE 'Tiene atenciones parciales' SKIP
        'Acceso denegado'
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
/* RHC 19/01/2016 Solo clasificación C */
FIND gn-clie WHERE gn-clie.codcia = cl-codcia
    AND gn-clie.codcli = Faccpedi.codcli
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie OR gn-clie.clfcli <> "C" THEN DO:
    MESSAGE 'Cliente NO válido para descuento' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

/* SOLICITAMOS NIVEL DE ACCESO A DESCUENTOS */
DEFINE VAR RPTA AS CHAR NO-UNDO.
RUN vtamay/D-CLAVE.R("D",
                     "DESCUENTOS",
                     OUTPUT NIV,
                     OUTPUT RPTA).
IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
/* **************************************** */
ASSIGN
    s-TpoCmb = Faccpedi.TpoCmb
    s-CodMon = Faccpedi.CodMon
    s-nivel = NIV
    s-CodCli = Faccpedi.CodCli
    s-PorIgv = Faccpedi.PorIgv
    s-DtoMax = 0.
/* VERIFICAMOS DESCUENTO MAXIMO */
FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
CASE s-Nivel:
   WHEN "D1" THEN s-DtoMax = FacCfgGn.DtoMax.
   WHEN "D2" THEN s-DtoMax = FacCfgGn.DtoDis.
   WHEN "D3" THEN s-DtoMax = FacCfgGn.DtoMay.
   WHEN "D4" THEN s-DtoMax = FacCfgGn.DtoPro.
   OTHERWISE s-DtoMax = 0.
END CASE.
/* RHC 23/01/2014 */

FIND FIRST AlmTabla WHERE AlmTabla.Tabla = "NA" AND almtabla.Codigo = s-Nivel NO-LOCK NO-ERROR.
IF AVAILABLE AlmTabla THEN s-DtoMax = DECIMAL(AlmTabla.NomAnt).
/* ********************************************************************************** */

FIND gn-clieds WHERE gn-clieds.CodCia = cl-CodCia AND
    gn-clieds.CodCli = FacCPedi.CodCli AND
    ((gn-clieds.fecini = ? AND gn-clieds.fecfin = ?) OR
     (gn-clieds.fecini = ? AND gn-clieds.fecfin >= TODAY) OR
     (gn-clieds.fecini <= TODAY AND gn-clieds.fecfin = ?) OR
     (gn-clieds.fecini <= TODAY AND gn-clieds.fecfin >= TODAY))
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clieds THEN s-DtoMax = gn-clieds.dscto.
IF s-DtoMax <= 0 THEN DO:
    MESSAGE 'Acceso Denegado' SKIP
        'No tiene permiso para hacer descuentos'
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

