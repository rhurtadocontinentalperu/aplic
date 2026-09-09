&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-DtoMax   AS DECIMAL.
DEF SHARED VAR s-nivel    AS CHAR.
DEF SHARED VAR lh_handle AS HANDLE.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-nrodec AS INT.

DEFINE SHARED VARIABLE S-TPOCMB   AS DECIMAL.  
DEFINE SHARED VARIABLE S-CODMON   AS INTEGER.
DEFINE SHARED VARIABLE S-CODCLI   AS CHAR.
DEFINE SHARED VARIABLE s-PorIgv LIKE Faccpedi.PorIgv.
DEFINE SHARED VARIABLE pCodDiv AS CHAR.


DEF VAR NIV AS CHAR.
DEF VAR x-usuario-autoriza AS CHAR.

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
&Scoped-Define ENABLED-FIELDS FacCPedi.PorDto 
&Scoped-define ENABLED-TABLES FacCPedi
&Scoped-define FIRST-ENABLED-TABLE FacCPedi
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS FacCPedi.PorDto FacCPedi.NroPed ~
FacCPedi.FchPed FacCPedi.CodCli FacCPedi.RucCli FacCPedi.DNICli ~
FacCPedi.usuario FacCPedi.NomCli FacCPedi.CodMon FacCPedi.CodVen ~
FacCPedi.FmaPgo FacCPedi.Glosa FacCPedi.NroRef 
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
     SIZE 26 BY .81
     BGCOLOR 15 FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE F-nomVen AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 24 BY 1.35
     BGCOLOR 15 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FacCPedi.PorDto AT ROW 3.96 COL 109 COLON-ALIGNED WIDGET-ID 30
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .81
          BGCOLOR 11 FGCOLOR 0 FONT 6
     FacCPedi.NroPed AT ROW 1 COL 16 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     F-Estado AT ROW 1 COL 37 COLON-ALIGNED WIDGET-ID 34
     FacCPedi.FchPed AT ROW 1 COL 109 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FacCPedi.CodCli AT ROW 1.81 COL 16 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     FacCPedi.RucCli AT ROW 1.81 COL 37 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     FacCPedi.DNICli AT ROW 1.81 COL 58 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .81
     FacCPedi.usuario AT ROW 1.81 COL 109 COLON-ALIGNED WIDGET-ID 20
          LABEL "Digitado por" FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     FacCPedi.NomCli AT ROW 2.62 COL 16 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 72.86 BY .81
     FacCPedi.CodMon AT ROW 2.62 COL 111 NO-LABEL WIDGET-ID 24
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 11.14 BY .81
     FacCPedi.CodVen AT ROW 3.42 COL 16 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     F-nomVen AT ROW 3.42 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 92
     FacCPedi.FmaPgo AT ROW 4.23 COL 16 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 8 BY .81
     F-CndVta AT ROW 4.23 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 90
     FacCPedi.Glosa AT ROW 5.85 COL 16 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS FILL-IN 
          SIZE 73 BY .81
     FacCPedi.NroRef AT ROW 5.04 COL 16 COLON-ALIGNED WIDGET-ID 94
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     "Moneda" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 2.88 COL 104 WIDGET-ID 28
     RECT-1 AT ROW 3.69 COL 101 WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.FacCPedi
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
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
         WIDTH              = 144.29.
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
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN FacCPedi.CodCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET FacCPedi.CodMon IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.CodVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.DNICli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-CndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-nomVen IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FchPed IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.FmaPgo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.Glosa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroPed IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.NroRef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.RucCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FacCPedi.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
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

&Scoped-define SELF-NAME FacCPedi.PorDto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FacCPedi.PorDto V-table-Win
ON LEAVE OF FacCPedi.PorDto IN FRAME F-Main /* % Dscto. */
DO:
  IF DECIMAL(Faccpedi.PorDto:SCREEN-VALUE) > 0 THEN DO:
      IF DECIMAL(Faccpedi.PorDto:SCREEN-VALUE) > s-DTOMAX THEN DO:
          MESSAGE "El descuento no puede ser mayor a " s-DTOMAX  VIEW-AS ALERT-BOX WARNING.
          RETURN NO-APPLY.
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
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER pPorDto AS DEC.

  DEF VAR xPorDto AS DEC.
  DEF VAR pError AS CHAR NO-UNDO.
  DEF VAR X-MARGEN AS DEC NO-UNDO.
  DEF VAR X-LIMITE AS DEC NO-UNDO.
  DEF VAR x-PreUni AS DEC NO-UNDO.
  DEF VAR x-DtoMax AS DEC NO-UNDO.

  DEFINE VAR hProc AS HANDLE NO-UNDO.

  RUN pri/pri-librerias PERSISTENT SET hProc.

  /* Solo para terceros */
  FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK WHERE Almmmatg.CHR__02 = "T":
      DISPLAY ITEM.CodMat @ Fi-Mensaje LABEL "Código: "
          FORMAT "X(20)" 
          WITH FRAME F-Proceso.
      xPorDto = pPorDto.
      x-DtoMax = pPorDto.
      /* SI TIENE DESCUENTO POR VOL/PROM */
      IF (ITEM.Por_DSCTOS[3] <> 0 OR ITEM.Por_DSCTOS[2] <> 0) THEN NEXT.
      /* RHC 13.12.2010 Margen de Utilidad */
      x-PreUni = ITEM.PreUni *
          ( 1 - xPorDto / 100 ) *
          ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
          ( 1 - ITEM.Por_Dsctos[3] / 100 ) .

      RUN PRI_Valida-Margen-Utilidad IN hProc (INPUT FacCPedi.Lista_de_Precios,
                                               INPUT ITEM.CodMat,
                                               INPUT ITEM.UndVta,
                                               INPUT x-PreUni,
                                               INPUT Faccpedi.CodMon,
                                               OUTPUT x-Margen,
                                               OUTPUT x-Limite,
                                               OUTPUT pError).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          /* Error crítico */
          MESSAGE pError VIEW-AS ALERT-BOX WARNING TITLE 'CONTROL DE MARGEN'.
          NEXT.
      END.
      /* 06/09/2023 Buscamos la Excepción a la Regla */
      FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia
          AND VtaTabla.Tabla = 'NA'
          AND VtaTabla.Llave_c1 = s-Nivel
          AND VtaTabla.Llave_c2 = Almmmatg.CodFam
          NO-LOCK NO-ERROR.
      IF AVAILABLE VtaTabla THEN DO:
          x-DtoMax = MINIMUM(VtaTabla.Valor[1], xPorDto).
      END.
      ASSIGN ITEM.Por_Dsctos[1] = x-DtoMax.
  END.
  DELETE PROCEDURE hProc.

  /* RHC 30/01/2017 Solo para productos propios */
  FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK WHERE Almmmatg.CHR__02 = "P":
      DISPLAY ITEM.CodMat @ Fi-Mensaje LABEL "Código: "
          FORMAT "X(20)" 
          WITH FRAME F-Proceso.
      /* SI TIENE DESCUENTO POR VOL/PROM */
      IF (ITEM.Por_DSCTOS[3] <> 0 OR ITEM.Por_DSCTOS[2] <> 0) THEN NEXT.
      /* RHC 07/02/1029 Caso de cuadernos */
      IF ITEM.Libre_c04 = "DVXSALDOC" THEN NEXT.
      /* Buscamos la equivalencia con el MLL */
      xPorDto = pPorDto.
      FIND Almtconv WHERE Almtconv.CodUnid = ITEM.UndVta
          AND Almtconv.Codalter = "MLL"
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almtconv THEN DO:
          IF ITEM.CanPed / Almtconv.Equival >= 1 AND xPorDto > 1 THEN NEXT.
      END.
      /* ************************************************************************** */
      /* RHC 08/02/2019 G.R. descuento configurado por linea para productos propios */
      /* ************************************************************************** */
      /*  NIVELES DE DESCUENTO */
      FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia
          AND VtaTabla.Tabla = 'NA'
          AND VtaTabla.Llave_c1 = s-Nivel
          AND VtaTabla.Llave_c2 = Almmmatg.CodFam
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE VtaTabla THEN NEXT.

      x-DtoMax = MINIMUM(VtaTabla.Valor[2], xPorDto).
      ASSIGN ITEM.Por_Dsctos[1] = x-DtoMax.
  END.
  RUN Procesa-Handle IN lh_Handle ('recalcular-precios'). 

  HIDE FRAME F-Proceso.

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
    FOR EACH FacDPedi OF FacCPedi EXCLUSIVE-LOCK ON ERROR UNDO, THROW:
        DELETE FacDPedi.
    END.
    FOR EACH ITEM:
        CREATE FacDPedi.
        BUFFER-COPY ITEM TO FacDPedi.
    END.
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

DEF VAR pMensaje AS CHAR NO-UNDO.

  /* ****************************************************************************************** */
  /* ****************************************************************************************** */
  {vtagn/totales-cotizacion-sunat.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}
  /* ****************************************************************************************** */
  /* Importes SUNAT */
  /* ****************************************************************************************** */
  DEF VAR hProc AS HANDLE NO-UNDO.
  RUN sunat/sunat-calculo-importes PERSISTENT SET hProc.
  RUN tabla-faccpedi IN hProc (INPUT Faccpedi.CodDiv,
                               INPUT Faccpedi.CodDoc,
                               INPUT Faccpedi.NroPed,
                               OUTPUT pMensaje).
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
  DELETE PROCEDURE hProc.
  /* ****************************************************************************************** */
  /* ****************************************************************************************** */

  RETURN 'OK'.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR pMensaje AS CHAR NO-UNDO.

  IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".
  
  MESSAGE 'Este proceso es irreversible' SKIP
      'Continuamos con la anulación?'
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE rpta AS LOG.
  IF rpta = NO THEN RETURN 'ADM-ERROR'.

  /* Si tiene atenciones parciales tambien se bloquea */
  FIND FIRST facdpedi OF faccpedi WHERE CanAte <> 0 NO-LOCK NO-ERROR.
  IF AVAILABLE facdpedi THEN DO:
      MESSAGE "El Pedido Comercial tiene atenciones parciales" SKIP 
          "Acceso denegado" VIEW-AS ALERT-BOX ERROR.
      MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
      RETURN "ADM-ERROR".
  END.
  FIND CURRENT Faccpedi EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  IF ERROR-STATUS:ERROR = YES THEN DO:
      {lib/mensaje-de-error.i &MensajeError="pMensaje"}
      RETURN 'ADM-ERROR'.
  END.
  ASSIGN                 
      FacCPedi.UsrAprobacion = s-user-id
      FacCPedi.FchAprobacion = TODAY
      FacCPedi.FlgEst = 'A'
      FacCPedi.Glosa  = "ANULADO POR: " + TRIM (s-user-id) + " EL DIA: " + STRING(TODAY) + " " + STRING(TIME, 'HH:MM').
  FIND CURRENT FacCPedi NO-LOCK.

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Procesa-Handle IN lh_handle ('Open-Query':U).

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

IF AVAILABLE Faccpedi AND FacCPedi.FlgEst <> "A" THEN DO:
   
   RUN vtamay/d-mrgped (ROWID(FacCPedi)).

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
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

END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE FacCPedi THEN RETURN "ADM-ERROR".

IF Faccpedi.ImpDto2 > 0 THEN DO:
    MESSAGE "La venta tiene descuentos especiales" SKIP
        "Acceso denegado"
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
/* NO PASA si tiene atenciones parciales */
IF CAN-FIND(FIRST Facdpedi OF Faccpedi WHERE Facdpedi.canate <> 0 NO-LOCK) THEN DO:
    MESSAGE 'Tiene atenciones parciales' SKIP 'Acceso denegado' VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
/* RHC 19/01/2016 Solo clasificación C */
IF NOT CAN-FIND(FIRST gn-clie WHERE gn-clie.codcia = cl-codcia AND 
                gn-clie.codcli = Faccpedi.codcli AND 
                gn-clie.clfcli = "C" NO-LOCK)
    THEN DO:
    MESSAGE 'Cliente NO válido para descuento' SKIP
        'El cliente debe ser de clasificación C'
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
/* **************************************** */
/* SOLICITAMOS NIVEL DE ACCESO A DESCUENTOS */
/* **************************************** */
s-Nivel = ''.
s-DtoMax = 0.
FIND FIRST FacUsers WHERE FacUsers.CodCia = S-CODCIA 
    AND FacUsers.Usuario = s-user-id
    NO-LOCK NO-ERROR.
IF AVAILABLE FacUsers THEN s-Nivel = SUBSTRING(FacUsers.Niveles,1,2).
/* Rutina anterior (por compatibilidad) */
FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
CASE s-Nivel:
   WHEN "D1" THEN s-DtoMax = FacCfgGn.DtoMax.
   WHEN "D2" THEN s-DtoMax = FacCfgGn.DtoDis.
   WHEN "D3" THEN s-DtoMax = FacCfgGn.DtoMay.
   WHEN "D4" THEN s-DtoMax = FacCfgGn.DtoPro.
   OTHERWISE s-DtoMax = 0.
END CASE.

/* Rutina nueva */
FIND FIRST AlmTabla WHERE AlmTabla.Tabla = "NA" AND almtabla.Codigo = s-Nivel NO-LOCK NO-ERROR.
IF AVAILABLE AlmTabla THEN s-DtoMax = DECIMAL(AlmTabla.NomAnt).

/* Excepciones */
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
        'No tiene permiso para hacer descuentos' SKIP
        'Usuario :' x-usuario-autoriza SKIP
        'Nivel de autorizacion :' NIV
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.

ASSIGN
    s-TpoCmb = Faccpedi.TpoCmb
    s-CodMon = Faccpedi.CodMon
    s-nivel = NIV
    s-CodCli = Faccpedi.CodCli
    s-PorIgv = Faccpedi.PorIgv
    s-NroDec = Faccpedi.Libre_d01
    pCodDiv = FacCPedi.Lista_de_Precios.

RUN Actualiza-Detalle.
RUN Procesa-Handle IN lh_Handle ('Pagina2').
RUN Procesa-Handle IN lh_Handle ('browse').

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

