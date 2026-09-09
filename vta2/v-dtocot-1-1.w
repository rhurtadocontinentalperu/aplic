&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.



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
DEFINE SHARED VARIABLE cl-codcia  AS INT.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-TERMINAL AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHAR.
DEFINE SHARED VARIABLE s-nivel    AS CHAR.
DEFINE SHARED VARIABLE S-TPOCMB   AS DECIMAL.  
DEFINE SHARED VARIABLE s-PorIgv LIKE Faccpedi.PorIgv.

/* Local Variable Definitions ---                          */
DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROPED       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE C-CODVEN       AS CHARACTER NO-UNDO.
DEFINE VARIABLE F-DTOMAX       AS DECIMAL   NO-UNDO.

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
&Scoped-Define DISPLAYED-FIELDS FacCPedi.NroPed FacCPedi.usuario ~
FacCPedi.FchPed FacCPedi.CodCli FacCPedi.NomCli FacCPedi.CodMon ~
FacCPedi.CodVen FacCPedi.TpoCmb FacCPedi.Glosa FacCPedi.PorDto 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-Estado F-nomVen 

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
     SIZE 14 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-nomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.72 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.NroPed AT ROW 1.27 COL 8 COLON-ALIGNED
          LABEL "Cotizacion" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
          FONT 1
     FacCPedi.usuario AT ROW 1.27 COL 45 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 10.86 BY .81
     F-Estado AT ROW 1.27 COL 59 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     FacCPedi.FchPed AT ROW 1.27 COL 89 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodCli AT ROW 2.08 COL 8 COLON-ALIGNED
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .81
     FacCPedi.NomCli AT ROW 2.08 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 59 BY .81
     FacCPedi.CodMon AT ROW 2.08 COL 90.72 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.14 BY .81
     FacCPedi.CodVen AT ROW 2.88 COL 8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.29 BY .81
     F-nomVen AT ROW 2.88 COL 16 COLON-ALIGNED NO-LABEL
     FacCPedi.TpoCmb AT ROW 2.88 COL 89 COLON-ALIGNED
          LABEL "Tpo.Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.Glosa AT ROW 3.69 COL 5.28
          LABEL "Glosa"
          VIEW-AS FILL-IN 
          SIZE 71.57 BY .81
     FacCPedi.PorDto AT ROW 3.69 COL 89 COLON-ALIGNED
          LABEL "% Dscto." FORMAT ">>9.99"
          VIEW-AS FILL-IN 
          SIZE 7 BY .81
          BGCOLOR 15 FGCOLOR 12 
     "Moneda" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 2.08 COL 84
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
      TABLE: PEDI T "SHARED" ? INTEGRAL FacDPedi
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
         HEIGHT             = 4.15
         WIDTH              = 115.29.
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
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE                                                            */
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
/*   IF DECIMAL(Faccpedi.PorDto:SCREEN-VALUE) > 0 THEN DO:                                   */
/*     IF DECIMAL(Faccpedi.PorDto:SCREEN-VALUE) > F-DTOMAX THEN DO:                          */
/*         MESSAGE "El descuento no puede ser mayor a " F-DTOMAX  VIEW-AS ALERT-BOX WARNING. */
/*         RETURN NO-APPLY.                                                                  */
/*     END.                                                                                  */
/*      RUN Actualiza-Descuento ( DECIMAL(Faccpedi.PorDto:SCREEN-VALUE) ).                   */
/*     SELF:SCREEN-VALUE = '0.00'.                                                           */
/*   END.                                                                                    */
    DEF VAR f-DtoMax AS DEC NO-UNDO.
    FIND gn-clieds WHERE gn-clieds.CodCia = cl-CodCia 
        AND gn-clieds.CodCli = FacCPedi.CodCli 
        AND ((gn-clieds.fecini = ? AND gn-clieds.fecfin = ?) 
             OR (gn-clieds.fecini = ? AND gn-clieds.fecfin >= TODAY) 
             OR (gn-clieds.fecini <= TODAY AND gn-clieds.fecfin = ?) 
             OR (gn-clieds.fecini <= TODAY AND gn-clieds.fecfin >= TODAY))
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clieds THEN DO:
        f-DtoMax = gn-clieds.dscto.
        IF DECIMAL(SELF:SCREEN-VALUE) > f-DtoMax THEN DO:
            MESSAGE "Máximo Descuento Permitido es : " f-DtoMax " %"
                VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
    END.
    ELSE DO:
        FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
        FIND Almtabla WHERE 
             almtabla.Tabla =  "NA" AND  
             almtabla.Codigo = s-nivel
             NO-LOCK NO-ERROR.
        CASE almtabla.Codigo:
            WHEN "D1" THEN f-DtoMax = FacCfgGn.DtoMax.
            WHEN "D2" THEN f-DtoMax = FacCfgGn.DtoDis.
            WHEN "D3" THEN f-DtoMax = FacCfgGn.DtoMay.
            WHEN "D4" THEN f-DtoMax = FacCfgGn.DtoPro.
            OTHERWISE DO:
                MESSAGE "Nivel de Usuario no existe : " s-nivel
                    VIEW-AS ALERT-BOX WARNING.
                RETURN NO-APPLY.
            END.
        END CASE.
        IF DEC(SELF:SCREEN-VALUE) > f-DtoMax THEN DO:
            MESSAGE "Máximo Descuento permitido" SKIP
                "para el nivel de Usuario" SKIP
                TRIM(s-nivel) " : " almtabla.Nombre " es : " f-DtoMax " %" SKIP
                VIEW-AS ALERT-BOX ERROR.
            RETURN NO-APPLY.
        END.
    END.
    IF DECIMAL(Faccpedi.PorDto:SCREEN-VALUE) > F-DTOMAX THEN DO:
        MESSAGE "El descuento no puede ser mayor a " F-DTOMAX  VIEW-AS ALERT-BOX WARNING.
        RETURN NO-APPLY.
    END. 
    RUN Actualiza-Descuento ( DECIMAL(Faccpedi.PorDto:SCREEN-VALUE) ).
    SELF:SCREEN-VALUE = '0.00'.
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
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER pPorDto AS DEC.

  DEF VAR xPorDto AS DEC.
  DEF VAR F-DSCTO AS DEC.
  DEF VAR pError AS CHAR.
  DEF VAR X-MARGEN AS DEC.
  DEF VAR X-LIMITE AS DEC.
  DEF VAR x-NewPre AS DEC.

  FOR EACH PEDI TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':            
      F-DSCTO = pPorDto.
      x-NewPre = PEDI.PreUni *
          ( 1 - F-DSCTO / 100 ) *
          ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
          ( 1 - PEDI.Por_Dsctos[3] / 100 ) .
      /* RHC 13.12.2010 Margen de Utilidad */
      RUN vtagn/p-margen-utilidad (
          PEDI.CodMat,      /* Producto */
          x-NewPre,         /* Precio de venta unitario */
          PEDI.UndVta,
          s-CodMon,         /* Moneda de venta */
          s-TpoCmb,         /* Tipo de cambio */
          NO,               /* Muestra el error */
          PEDI.AlmDes,
          OUTPUT x-Margen,        /* Margen de utilidad */
          OUTPUT x-Limite,        /* Margen mínimo de utilidad */
          OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
          ).
       IF x-Margen <= 0 AND s-Nivel <> 'D3' THEN DO:     /* NO Gerente General */
           MESSAGE 'Material:' PEDI.codmat SKIP
               'Margen:' x-margen SKIP
               'NO está permitido margen negativo'
               VIEW-AS ALERT-BOX ERROR.
           UNDO, RETURN 'ADM-ERROR'.
       END.
       /* Fin de margen */
       xPorDto = pPorDto.
       /* SI TIENE DESCUENTO POR VOL/PROM */
       IF PEDI.Por_DSCTOS[3] > 0 OR PEDI.Por_DSCTOS[2] > 0 THEN xPorDto = 0.
       ASSIGN
           PEDI.Por_Dsctos[1] = xPorDto
           PEDI.Libre_d01     = x-Margen.
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

FOR EACH PEDI:
    DELETE PEDI.
END.

FOR EACH FacDPedi OF FacCPedi NO-LOCK:
    CREATE PEDI.
    BUFFER-COPY FacDPedi TO PEDI.
END.
FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
FIND FIRST FacUsers WHERE 
           FacUsers.CodCia = S-CODCIA AND  
           FacUsers.Usuario = S-USER-ID NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacUsers THEN F-DTOMAX = 0.
CASE NIV:
   WHEN "D1" THEN F-DTOMAX = FacCfgGn.DtoMax.
   WHEN "D2" THEN F-DTOMAX = FacCfgGn.DtoDis.
   WHEN "D3" THEN F-DTOMAX = FacCfgGn.DtoMay.
   WHEN "D4" THEN F-DTOMAX = FacCfgGn.DtoPro.
   OTHERWISE F-DTOMAX = 0.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Estado V-table-Win 
PROCEDURE Actualiza-Estado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE f-DtoMax AS DEC NO-UNDO.    
    DEFINE VARIABLE dDscto   AS DEC NO-UNDO.
    DEFINE VARIABLE s-Tipo   AS CHAR.
    
    FOR EACH PEDI:
        /*Busca en lista de excepciones*/
        RUN vta\p-parche-precio-uno (s-codDiv, s-user-id, PEDI.CodMat, OUTPUT dDscto).        
        IF Pedi.Por_Dscto[1] <= dDscto THEN NEXT.

        /*Descuentos Permitidos*/
        FIND gn-clieds WHERE
            gn-clieds.CodCia = cl-CodCia AND
            gn-clieds.CodCli = s-CodCli AND
            ((gn-clieds.fecini = ? AND gn-clieds.fecfin = ?) OR
            (gn-clieds.fecini = ? AND gn-clieds.fecfin >= TODAY) OR
            (gn-clieds.fecini <= TODAY AND gn-clieds.fecfin = ?) OR
            (gn-clieds.fecini <= TODAY AND gn-clieds.fecfin >= TODAY)) NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clieds THEN DO:
            f-DtoMax = gn-clieds.dscto.
            IF DECIMAL(PEDI.Por_DSCTOS[1]) > f-DtoMax THEN s-tipo = 'Si'.        
        END.
        ELSE DO:
            FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
            FIND Almtabla WHERE almtabla.Tabla =  "NA" 
                AND almtabla.Codigo = s-nivel NO-LOCK NO-ERROR.
            CASE almtabla.Codigo:
                WHEN "D1" THEN f-DtoMax = FacCfgGn.DtoMax.
                WHEN "D2" THEN f-DtoMax = FacCfgGn.DtoDis.
                WHEN "D3" THEN f-DtoMax = FacCfgGn.DtoMay.
                WHEN "D4" THEN f-DtoMax = FacCfgGn.DtoPro.
            END CASE.
            IF DEC(PEDI.Por_DSCTOS[1]) > f-DtoMax THEN s-tipo = 'Si'.
        END.
        /*Validando Margen*/        
        IF PEDI.Libre_d01 <= 0 THEN s-tipo = 'Si'.
    END.

    IF s-tipo = 'Si' THEN DO:
        MESSAGE 'Porcentaje de Descuento excede al permitido' SKIP                    
                '  La cotización pasa a estado POR APROBAR  '
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        ASSIGN Faccpedi.flgest = 'E'.
    END.
    ELSE 
        ASSIGN 
            Faccpedi.flgest = 'P'
            Faccpedi.flgsit = ''.

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
    FOR EACH PEDI:
        CREATE FacDPedi.
        BUFFER-COPY PEDI TO FacDPedi.
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
   FOR EACH PEDI NO-LOCK ON ERROR UNDO, RETURN "ADM-ERROR":
       CREATE FacDPedi.
       RAW-TRANSFER PEDI TO FacDPedi.
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

{vta2/graba-totales-cot.i}

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
  RUN Actualiza-Estado.

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
/* FOR EACH PEDI:                                                             */
/*     /* RHC 13.12.2010 Margen de Utilidad */                                */
/*     DEF VAR pError AS CHAR NO-UNDO.                                        */
/*     DEF VAR X-MARGEN AS DEC NO-UNDO.                                       */
/*     DEF VAR X-LIMITE AS DEC NO-UNDO.                                       */
/*     DEF VAR x-PreUni AS DEC NO-UNDO.                                       */
/*                                                                            */
/*     x-PreUni = PEDI.PreUni *                                               */
/*         ( 1 - PEDI.Por_Dsctos[1] / 100 ) *                                 */
/*         ( 1 - PEDI.Por_Dsctos[2] / 100 ) *                                 */
/*         ( 1 - PEDI.Por_Dsctos[3] / 100 ) .                                 */
/*     RUN vtagn/p-margen-utilidad (                                          */
/*         PEDI.CodMat,      /* Producto */                                   */
/*         x-PreUni,  /* Precio de venta unitario */                          */
/*         PEDI.UndVta,                                                       */
/*         s-CodMon,       /* Moneda de venta */                              */
/*         s-TpoCmb,       /* Tipo de cambio */                               */
/*         YES,            /* Muestra el error */                             */
/*         PEDI.AlmDes,                                                       */
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
   FOR EACH PEDI NO-LOCK:
       POR_DSCREM = ROUND(((1 - ((1 - PEDI.Por_Dsctos[2] / 100) / (1 - PEDI.PorDto / 100))) * 100), 2).
        DSCT_REM = DSCT_REM + (PEDI.PreUni * (IF PEDI.Flg_factor = "1" THEN 
                              PEDI.CanPed ELSE (PEDI.CanPed * PEDI.Factor)) * 
                              (POR_DSCREM / 100)
                              ).
       X-Bruto = X-Bruto + (PEDI.PreUni * (IF PEDI.Flg_factor = "1" THEN                                PEDI.CanPed ELSE (PEDI.CanPed * PEDI.Factor))
                              ).
                              
       X-ImpDto = X-ImpDto + PEDI.ImpDto.
         F-IGV  = F-IGV + PEDI.ImpIgv.
         F-ISC  = F-ISC + PEDI.ImpIsc.
       X-ImpTot = X-ImpTot + PEDI.ImpLin.
       IF NOT PEDI.AftIgv THEN X-ImpExo = X-ImpExo + PEDI.ImpLin.
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

/*   FOR EACH PEDI:
 *        F-DSCTO = F-DSCTO + PEDI.ImpDto.
 *    END.
 *    F-DSCTO = 0.
 *    IF F-DSCTO > 0 AND DECIMAL(FacCPedi.PorDto:SCREEN-VALUE) > 0 THEN DO:
 *       MESSAGE "El pedido ya tiene descuentos por PEDI"  VIEW-AS ALERT-BOX ERROR.
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

DEFINE VAR RPTA AS CHAR NO-UNDO.

  RUN vtamay/D-CLAVE.R("D",
                    "DESCUENTOS",
                    OUTPUT NIV,
                    OUTPUT RPTA).
  IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".

  ASSIGN
      s-CodCli = Faccpedi.CodCli
      s-TpoCmb = Faccpedi.TpoCmb
      s-CodMon = Faccpedi.CodMon
      s-nivel = NIV
      s-PorIgv = Faccpedi.PorIgv.
/******************/

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

