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

/*
    Modificó    : Miguel Landeo /*ML01*/
    Fecha       : 03/Nov/2009
    Objetivo    : Captura Porcenta de Descuento Máximo de tabla gn-clids
*/

CREATE WIDGET-POOL.
/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Public Variable Definitions ---                                       */
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE SHARED TEMP-TABLE PEDI LIKE FacDPedi.

DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
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

DEFINE SHARED VARIABLE s-tipo     AS CHAR.

/* Local Variable Definitions ---                          */
DEFINE VARIABLE L-CREA         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE I-NROPED       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE C-CODVEN       AS CHARACTER NO-UNDO.
DEFINE VARIABLE F-DTOMAX       AS DECIMAL   NO-UNDO.

/*RD01*/
DEFINE VARIABLE lExiste        AS LOGICAL   NO-UNDO INIT NO.

FIND FIRST FacCorre WHERE 
     FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV
     NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer
          S-PRINTER-NAME = FacCorre.Printer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.


DEFINE VAR NIV  AS CHAR.

DEFINE VARIABLE X-MARGEN    AS DECIMAL   NO-UNDO.

/*ML01* ***/
DEFINE VARIABLE cl-codcia AS INTEGER INITIAL 0 NO-UNDO.
FOR Empresas FIELDS
    (Empresas.CodCia Empresas.Campo-CodCli) WHERE
    Empresas.CodCia = S-CODCIA NO-LOCK:
END.
IF NOT Empresas.Campo-CodCli THEN cl-codcia = S-CODCIA.
/*ML01* ***/

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
&Scoped-Define ENABLED-FIELDS FacCPedi.PorDto FacCPedi.Glosa 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define ENABLED-OBJECTS RECT-18 
&Scoped-Define DISPLAYED-FIELDS FacCPedi.usuario FacCPedi.PorDto ~
FacCPedi.NroPed FacCPedi.FchPed FacCPedi.CodCli FacCPedi.NomCli ~
FacCPedi.CodMon FacCPedi.CodVen FacCPedi.TpoCmb FacCPedi.Glosa 
&Scoped-define DISPLAYED-TABLES FacCPedi
&Scoped-define FIRST-DISPLAYED-TABLE FacCPedi
&Scoped-Define DISPLAYED-OBJECTS F-nomVen x-PorDto 

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
DEFINE VARIABLE F-nomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.72 BY .69 NO-UNDO.

DEFINE VARIABLE x-PorDto AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "% Dcto." 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .69
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.43 BY 3.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.usuario AT ROW 1.19 COL 37 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.86 BY .69
     FacCPedi.PorDto AT ROW 1.19 COL 59 COLON-ALIGNED FORMAT "-ZZ9.99"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
          BGCOLOR 15 FGCOLOR 12 
     FacCPedi.NroPed AT ROW 1.23 COL 7.43 COLON-ALIGNED
          LABEL "Pedido" FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .69
          FONT 1
     FacCPedi.FchPed AT ROW 1.23 COL 75 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FacCPedi.CodCli AT ROW 1.96 COL 7.43 COLON-ALIGNED
          LABEL "Cliente"
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .69
     FacCPedi.NomCli AT ROW 1.96 COL 20 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 39 BY .69
     FacCPedi.CodMon AT ROW 2 COL 77.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.14 BY .5
     FacCPedi.CodVen AT ROW 2.73 COL 7.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.29 BY .69
     F-nomVen AT ROW 2.73 COL 15.14 COLON-ALIGNED NO-LABEL
     FacCPedi.TpoCmb AT ROW 2.73 COL 75 COLON-ALIGNED
          LABEL "Tpo.Cambio"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     FacCPedi.Glosa AT ROW 3.5 COL 4.71
          LABEL "Glosa"
          VIEW-AS FILL-IN 
          SIZE 48.43 BY .69
     x-PorDto AT ROW 3.5 COL 75 COLON-ALIGNED
     "Moneda" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 2 COL 70.43
     RECT-18 AT ROW 1 COL 1.72
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
         HEIGHT             = 3.46
         WIDTH              = 91.43.
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

/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR RADIO-SET FacCPedi.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodVen IN FRAME F-Main
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
   EXP-FORMAT                                                           */
ASSIGN 
       FacCPedi.PorDto:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN FacCPedi.TpoCmb IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FacCPedi.usuario IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-PorDto IN FRAME F-Main
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

&Scoped-define SELF-NAME FacCPedi.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.CodCli V-table-Win
ON LEAVE OF FacCPedi.CodCli IN FRAME F-Main /* Cliente */
DO:
    s-CodCli = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

/*  IF DECIMAL(FacCPedi.PorDto:SCREEN-VALUE) > 0 THEN DO:
 *      IF DECIMAL(FacCPedi.PorDto:SCREEN-VALUE) > F-DTOMAX THEN DO:
 *         MESSAGE "El descuento no puede ser mayor a " F-DTOMAX  VIEW-AS ALERT-BOX ERROR.
 *         RETURN NO-APPLY.
 *      END. 
 *   END.*/
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME x-PorDto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL x-PorDto V-table-Win
ON LEAVE OF x-PorDto IN FRAME F-Main /* % Dcto. */
/*
    Modificó    : ML01 (Miguel Landeo)
    Fecha       : 02/Nov/2009
    Objetivo    : Busca descuento tope en tabla gn-clieds 
*/

OR RETURN OF x-PorDto
DO:
  IF x-PorDto <> INPUT x-PorDto
  THEN DO:
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
      ASSIGN 
          x-PorDto.
      RUN Recalculo-Detalle.
      IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.
      RUN Procesa-Handle IN lh_Handle ('browse').
      ASSIGN 
          x-PorDto:SENSITIVE = NO.
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
    BUFFER-COPY Facdpedi TO PEDI.
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
   OTHERWISE F-DTOMAX = 0.
END CASE.

/****************Margenes**********/
define var x-cto1 as deci NO-UNDO.
define var x-cto2 as deci NO-UNDO.
define var x-cto  as deci NO-UNDO.
define var x-uni  as deci NO-UNDO.
FOR EACH pedi:
    /* RHC 13.12.2010 Margen de Utilidad */
    DEF VAR pError AS CHAR NO-UNDO.
    DEF VAR X-MARGEN AS DEC NO-UNDO.
    DEF VAR X-LIMITE AS DE NO-UNDO.
    x-Uni = PEDI.ImpLin / PEDI.CanPed.
    RUN vtagn/p-margen-utilidad (
        PEDI.CodMat,      /* Producto */
        x-Uni,           /* Precio de venta unitario */
        PEDI.UndVta,
        s-CodMon,         /* Moneda de venta */
        s-TpoCmb,         /* Tipo de cambio */
        NO,               /* Muestra el error */
        PEDI.AlmDes,
        OUTPUT x-Margen,        /* Margen de utilidad */
        OUTPUT x-Limite,        /* Margen mínimo de utilidad */
        OUTPUT pError           /* Control de errores: "OK" "ADM-ERROR" */
        ).
     PEDI.Libre_d01 = x-margen.
END.
/********************************/


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
    
    FOR EACH PEDI NO-LOCK:
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

    FIND FIRST b-cpedi WHERE ROWID(b-cpedi) = ROWID(FacCPedi) NO-LOCK NO-ERROR.
    IF AVAIL b-cpedi THEN DO:
        IF s-tipo = 'Si' THEN DO:
            MESSAGE 'Porcentaje de Descuento excede al permitido' SKIP                    
                    '  La cotización pasa a estado POR APROBAR  '
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            ASSIGN b-cpedi.flgest = 'E'.
        END.
        ELSE 
            ASSIGN 
                b-cpedi.flgest = 'P'
                b-cpedi.flgsit = ''.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-PEDI V-table-Win 
PROCEDURE Actualiza-PEDI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF FacCPedi.PorDto <> 0 THEN DO:
  FaccPedi.PorDto = 0.
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
   
   FOR EACH  FacDPedi OF Faccpedi:
       DELETE FacDPedi.
   END.
   FOR EACH PEDI:
       CREATE FacDPedi.
       BUFFER-COPY PEDI 
           EXCEPT PEDI.Libre_d01
           TO Facdpedi
           ASSIGN 
                FacDPedi.CodCia = FacCPedi.CodCia
                FacDPedi.coddoc = FacCPedi.coddoc
                FacDPedi.NroPed = FacCPedi.NroPed
                FacDPedi.FlgEst = FacCPedi.FlgEst
                FacDPedi.Hora   = FacCPedi.Hora
                FacDPedi.FchPed = FacCPedi.FchPed.
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
DO ON ERROR UNDO, RETURN "ADM-ERROR":
   DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
   DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
   
   FIND B-CPEDI WHERE ROWID(B-CPEDI) = ROWID(FacCPedi) EXCLUSIVE-LOCK NO-ERROR.
   B-CPEDI.UsrDscto = S-USER-ID.
   B-CPEDI.ImpDto = 0.
   B-CPEDI.ImpIgv = 0.
   B-CPEDI.ImpIsc = 0.
   B-CPEDI.ImpTot = 0.
   B-CPEDI.ImpExo = 0.
   B-CPEDI.ImpBrt = 0.
   FOR EACH PEDI NO-LOCK:
       /*B-CPEDI.ImpDto = B-CPEDI.ImpDto + PEDI.ImpDto.*/
               F-IGV  = F-IGV + PEDI.ImpIgv.
               F-ISC  = F-ISC + PEDI.ImpIsc.
       B-CPEDI.ImpTot = B-CPEDI.ImpTot + PEDI.ImpLin.
       IF NOT PEDI.AftIgv THEN B-CPEDI.ImpExo = B-CPEDI.ImpExo + PEDI.ImpLin.
       IF PEDI.AftIgv = YES
       THEN B-CPEDI.ImpDto = B-CPEDI.ImpDto + ROUND(PEDI.ImpDto / (1 + B-CPEDI.PorIgv / 100), 2).
       ELSE B-CPEDI.ImpDto = B-CPEDI.ImpDto + PEDI.ImpDto.
   END.
   B-CPEDI.ImpIgv = ROUND(F-IGV,2).
   B-CPEDI.ImpIsc = ROUND(F-ISC,2).
   B-CPEDI.ImpVta = B-CPEDI.ImpTot - B-CPEDI.ImpExo - B-CPEDI.ImpIgv.
   B-CPEDI.ImpBrt = B-CPEDI.ImpTot - B-CPEDI.ImpIgv - B-CPEDI.ImpIsc + 
                    B-CPEDI.ImpDto - B-CPEDI.ImpExo.

   
  /* RHC 22.12.06 */
  IF B-CPedi.PorDto > 0 THEN DO:
    B-CPEDI.ImpDto = B-CPEDI.ImpDto + ROUND((B-CPEDI.ImpVta + B-CPEDI.ImpExo) * B-CPEDI.PorDto / 100, 2).
    B-CPEDI.ImpTot = ROUND(B-CPEDI.ImpTot * (1 - B-CPEDI.PorDto / 100),2).
    B-CPEDI.ImpVta = ROUND(B-CPEDI.ImpVta * (1 - B-CPEDI.PorDto / 100),2).
    B-CPEDI.ImpExo = ROUND(B-CPEDI.ImpExo * (1 - B-CPEDI.PorDto / 100),2).
    B-CPEDI.ImpIgv = B-CPEDI.ImpTot - B-CPEDI.ImpExo - B-CPEDI.ImpVta.
    B-CPEDI.ImpBrt = B-CPEDI.ImpTot - B-CPEDI.ImpIgv - B-CPEDI.ImpIsc + 
                    B-CPEDI.ImpDto - B-CPEDI.ImpExo.
  END.  

   /*** DESCUENTO GLOBAL ****/
   /*IF B-CPEDI.PorDto > 0 THEN DO:
 *       /**** Add by C.Q. 29/03/2000  ****/
 *       /*********************************/
 *       B-CPEDI.ImpDto = B-CPEDI.ImpDto + ROUND(B-CPEDI.ImpTot * B-CPEDI.PorDto / 100,2).
 *       B-CPEDI.ImpTot = ROUND(B-CPEDI.ImpTot * (1 - B-CPEDI.PorDto / 100),2).
 *       B-CPEDI.ImpVta = ROUND(B-CPEDI.ImpTot / (1 + B-CPEDI.PorIgv / 100),2).
 *       B-CPEDI.ImpIgv = B-CPEDI.ImpTot - B-CPEDI.ImpVta.
 *       B-CPEDI.ImpBrt = B-CPEDI.ImpTot - B-CPEDI.ImpIgv - B-CPEDI.ImpIsc + 
 *                        B-CPEDI.ImpDto - B-CPEDI.ImpExo.
 *    END.*/

   RELEASE B-CPEDI.

END.

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
  RUN Actualiza-PEDI.
  RUN Genera-Detalle.
  RUN Graba-Totales.
  
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
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN x-PorDto:SENSITIVE = NO.
  END.

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
     F-NomVen:screen-value = "".
     FIND gn-ven WHERE gn-ven.CodCia = S-CODCIA AND 
          gn-ven.CodVen = FacCPedi.CodVen NO-LOCK NO-ERROR.
     IF AVAILABLE gn-ven THEN F-NomVen:screen-value = gn-ven.NomVen.
     S-CODMON = FacCPedi.CodMon.
     S-TPOCMB = FacCPedi.TpoCmb.
/*ML01*/ s-CodCli = FacCPedi.CodCli.
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
    x-PorDto = 0.
    x-PorDto:SENSITIVE = YES.
    DISPLAY x-PorDto.
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
  
  IF FacCPedi.FlgEst <> "A" THEN RUN VTA\R-IMPCOT (ROWID(FacCPedi)).
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recalculo-Detalle V-table-Win 
PROCEDURE Recalculo-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE pre1 AS DECIMAL.
  DEFINE VARIABLE pre2 AS DECIMAL.
  DEFINE VARIABLE dsct_disp AS DECIMAL.
  DEFINE VARIABLE X-NEWDSC AS DECIMAL.
  DEFINE VARIABLE X-NEWPRE AS DECIMAL.
  DEFINE VARIABLE F-DSCTO AS DECIMAL.
  DEFINE VARIABLE x-cto1    AS DECIMAL.
  DEFINE VARIABLE x-cto2    AS DECIMAL.
  DEFINE VARIABLE x-uni     AS DECIMAL.
  DEFINE VARIABLE x-cto     AS DECIMAL.

 DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
     FOR EACH PEDI:
       FIND Almmmatg WHERE 
            Almmmatg.CodCia = S-CODCIA AND  
            Almmmatg.codmat = PEDI.CodMat
            NO-LOCK NO-ERROR.
       ASSIGN
           pre1 = 0
           pre2 = 0
           dsct_disp = 0
           X-NEWDSC = PEDI.PorDto
           X-NEWPRE = PEDI.PreUni.
       FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
       FIND Almtabla WHERE 
            almtabla.Tabla =  "NA" AND  
            almtabla.Codigo = s-nivel
            NO-LOCK NO-ERROR.
       dsct_disp = ROUND((1 - (1 - Almmmatg.PorMax / 100) / (1 - PEDI.PorDto / 100)), 4) * 100.

       /*******************************************/
       F-DSCTO = x-PorDto.
       x-NewPre = PEDI.PreUni *
           ( 1 - F-DSCTO / 100 ) *
           ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
           ( 1 - PEDI.Por_Dsctos[3] / 100 ) .
       /* RHC 13.12.2010 Margen de Utilidad */
       DEF VAR pError AS CHAR NO-UNDO.
       DEF VAR X-MARGEN AS DEC NO-UNDO.
       DEF VAR X-LIMITE AS DE NO-UNDO.
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

        PEDI.Libre_d01 = x-Margen.
        IF x-Margen <= 0 AND s-Nivel <> 'D3' THEN DO:     /* NO Gerente General */
            MESSAGE 'Material:' PEDI.codmat SKIP
                'Margen:' x-margen SKIP
                'NO está permitido margen negativo'
                VIEW-AS ALERT-BOX ERROR.
            UNDO, RETURN 'ADM-ERROR'.
        END.

        ASSIGN 
           PEDI.Por_DSCTOS[1] = x-PorDto.
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
        IF PEDI.AftIgv 
            THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (FacCfgGn.PorIgv / 100) ), 4 ).
     END.
 END.


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
       X-Bruto = X-Bruto + (PEDI.PreUni * (IF PEDI.Flg_factor = "1" THEN                                
           PEDI.CanPed ELSE (PEDI.CanPed * PEDI.Factor))
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
  
  Modificó  :   Rosa Diaz Poma /*RD01*/
  Fecha     :   17/11/2009
  Motivo    :   Verificar si la cotización ya ha sido aprobada.
------------------------------------------------------------------------------*/

IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".

IF LOOKUP(FacCPedi.FlgEst,"C,A") > 0 THEN  RETURN "ADM-ERROR".

/* NO PASA si tiene atenciones parciales */
FIND FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate <> 0 NO-LOCK NO-ERROR.
IF AVAILABLE Facdpedi THEN DO:
    MESSAGE 'Tiene atenciones parciales' SKIP
        'Acceso denegado'
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.

DEFINE VAR RPTA AS CHAR NO-UNDO.

/*FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
 * RUN ALM/D-CLAVE.R(FacCfgGn.Cla_Venta,OUTPUT RPTA). 
 * IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".*/

/*RD01 - Verifica si la cotización ha sido aprobada*/
  IF FacCPedi.FlgSit <> 'P' THEN DO:
      IF FacCPedi.FlgSit = 'R' THEN 
          MESSAGE 'Esta Cotización ha sido RECHAZADA' 
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RUN VTA/D-CLAVE.R("D",
                        "DESCUENTOS",
                        OUTPUT NIV,
                        OUTPUT RPTA).
      IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
      s-nivel = NIV.
      s-tipo  = ''.
  END.
  ELSE DO: 
      MESSAGE 'Cotización Aprobada'
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN 'ADM-ERROR'.
  END.


/******************
  RUN VTA/D-CLAVE.R("D",
                    "DESCUENTOS",
                    OUTPUT NIV,
                    OUTPUT RPTA).
  IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
  s-nivel = NIV.
  s-tipo  = ''.
******************/

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

