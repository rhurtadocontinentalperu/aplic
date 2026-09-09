&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.
DEFINE BUFFER B-DDOCU FOR CcbDDocu.
DEFINE TEMP-TABLE DETA NO-UNDO LIKE CcbDDocu.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.
DEFINE BUFFER x-VtaTabla FOR VtaTabla.



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
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-nroser AS INTE.
DEF SHARED VAR s-CndCre AS CHAR.
DEF SHARED VAR s-TpoFac AS CHAR.
DEF SHARED VAR s-Tipo   AS CHAR.

DEFINE VAR x-tabla AS CHAR INIT "CONFIG-VTAS".
DEFINE VAR x-codigo AS CHAR INIT "PI.NO.VALIDAR.N/C".
DEFINE VAR pMensaje AS CHAR NO-UNDO.

DEFINE SHARED VARIABLE S-PORIGV AS DEC. 
DEFINE SHARED VARIABLE S-PORDTO AS DEC.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

/* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
DEF VAR x-Formato AS CHAR INIT '999-999999' NO-UNDO.
RUN sunat\p-formato-doc (INPUT s-CodDoc, OUTPUT x-Formato).

DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.

DEF VAR s-ClienteGenerico AS CHAR INIT '11111111111' NO-UNDO.

FIND FIRST FacCfgGn  WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.
IF AVAILABLE FacCfgGn THEN s-ClienteGenerico = FacCfgGn.CliVar.

DEF SHARED VAR s-CodRef AS CHAR INIT 'PNC'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME sF-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES CcbCDocu
&Scoped-define FIRST-EXTERNAL-TABLE CcbCDocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCDocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCDocu.FchDoc CcbCDocu.usuario ~
CcbCDocu.CodPed CcbCDocu.NroPed CcbCDocu.FchVto CcbCDocu.CodCli ~
CcbCDocu.RucCli CcbCDocu.CodAnt CcbCDocu.FchAnu CcbCDocu.UsuAnu ~
CcbCDocu.NomCli CcbCDocu.CodMon CcbCDocu.DirCli CcbCDocu.CodRef ~
CcbCDocu.NroRef CcbCDocu.FmaPgo CcbCDocu.CodCta CcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.usuario CcbCDocu.CodPed CcbCDocu.NroPed CcbCDocu.FchVto ~
CcbCDocu.CodCli CcbCDocu.RucCli CcbCDocu.CodAnt CcbCDocu.FchAnu ~
CcbCDocu.UsuAnu CcbCDocu.NomCli CcbCDocu.CodMon CcbCDocu.DirCli ~
CcbCDocu.CodRef CcbCDocu.NroRef CcbCDocu.FmaPgo CcbCDocu.CodCta ~
CcbCDocu.Glosa 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-EStado FILL-IN-FmaPgo ~
FILL-IN_CodCta 

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
DEFINE VARIABLE FILL-IN-EStado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FmaPgo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodCta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME sF-Main
     CcbCDocu.NroDoc AT ROW 1 COL 19 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-EStado AT ROW 1 COL 39 COLON-ALIGNED WIDGET-ID 172
     CcbCDocu.FchDoc AT ROW 1 COL 97 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.usuario AT ROW 1 COL 107 COLON-ALIGNED NO-LABEL WIDGET-ID 24 FORMAT "x(15)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.CodPed AT ROW 1.81 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 186
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     CcbCDocu.NroPed AT ROW 1.81 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 32 FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     CcbCDocu.FchVto AT ROW 1.81 COL 97 COLON-ALIGNED WIDGET-ID 10
          LABEL "Vencimiento"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.CodCli AT ROW 2.62 COL 19 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.RucCli AT ROW 2.62 COL 39 COLON-ALIGNED WIDGET-ID 22
          LABEL "RUC"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.CodAnt AT ROW 2.62 COL 59 COLON-ALIGNED WIDGET-ID 2
          LABEL "DNI" FORMAT "X(11)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.FchAnu AT ROW 2.62 COL 97 COLON-ALIGNED WIDGET-ID 6
          LABEL "Fecha Anulación" FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.UsuAnu AT ROW 2.62 COL 107 COLON-ALIGNED NO-LABEL WIDGET-ID 176 FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.NomCli AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 16 FORMAT "x(100)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
     CcbCDocu.CodMon AT ROW 3.42 COL 99 NO-LABEL WIDGET-ID 178
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dólares", 2
          SIZE 18 BY .81
     CcbCDocu.DirCli AT ROW 4.23 COL 19 COLON-ALIGNED WIDGET-ID 28
          LABEL "Dirección" FORMAT "x(100)"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
     CcbCDocu.CodRef AT ROW 5.04 COL 19 COLON-ALIGNED WIDGET-ID 26
          LABEL "Referencia" FORMAT "x(3)"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "FACTURA","FAC",
                     "BOLETA","BOL",
                     "FAI","FAI"
          DROP-DOWN-LIST
          SIZE 12 BY 1
     CcbCDocu.NroRef AT ROW 5.04 COL 39 COLON-ALIGNED WIDGET-ID 20
          LABEL "Número" FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     CcbCDocu.FmaPgo AT ROW 5.85 COL 19 COLON-ALIGNED WIDGET-ID 12
          LABEL "Forma de Pago" FORMAT "X(8)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-FmaPgo AT ROW 5.85 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 174
     CcbCDocu.CodCta AT ROW 6.65 COL 19 COLON-ALIGNED WIDGET-ID 182
          LABEL "Concepto"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN_CodCta AT ROW 6.65 COL 31 COLON-ALIGNED NO-LABEL WIDGET-ID 184
     CcbCDocu.Glosa AT ROW 7.46 COL 19 COLON-ALIGNED WIDGET-ID 14 FORMAT "x(80)"
          VIEW-AS FILL-IN 
          SIZE 100 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.CcbCDocu
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
      TABLE: B-DDOCU B "?" ? INTEGRAL CcbDDocu
      TABLE: DETA T "?" NO-UNDO INTEGRAL CcbDDocu
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
      TABLE: x-VtaTabla B "?" ? INTEGRAL VtaTabla
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
         HEIGHT             = 7.92
         WIDTH              = 128.14.
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
/* SETTINGS FOR FRAME sF-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME sF-Main:SCROLLABLE       = FALSE
       FRAME sF-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCDocu.CodAnt IN FRAME sF-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.CodCta IN FRAME sF-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX CcbCDocu.CodRef IN FRAME sF-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.DirCli IN FRAME sF-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.FchAnu IN FRAME sF-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.FchVto IN FRAME sF-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-EStado IN FRAME sF-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-FmaPgo IN FRAME sF-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodCta IN FRAME sF-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.FmaPgo IN FRAME sF-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.Glosa IN FRAME sF-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.NomCli IN FRAME sF-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME sF-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroPed IN FRAME sF-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.NroRef IN FRAME sF-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.RucCli IN FRAME sF-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.UsuAnu IN FRAME sF-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.usuario IN FRAME sF-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME sF-Main
/* Query rebuild information for FRAME sF-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME sF-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME CcbCDocu.CodCta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCta V-table-Win
ON LEAVE OF CcbCDocu.CodCta IN FRAME sF-Main /* Concepto */
DO:
    FIND Ccbtabla WHERE CcbTabla.CodCia = s-codcia AND
        CcbTabla.Tabla = "N/C" AND
        CcbTabla.Codigo = CcbCDocu.CodCta:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbtabla THEN FILL-IN_CodCta:SCREEN-VALUE = CcbTabla.Nombre.
    ELSE FILL-IN_CodCta:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCta V-table-Win
ON LEFT-MOUSE-DBLCLICK OF CcbCDocu.CodCta IN FRAME sF-Main /* Concepto */
OR F8 OF CcbCDocu.CodCta DO:
    ASSIGN
        input-var-1 = s-TpoFac
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN lkup/c-cfg-tipos-nc-tipo.w ('Seleccione').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.FmaPgo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.FmaPgo V-table-Win
ON LEAVE OF CcbCDocu.FmaPgo IN FRAME sF-Main /* Forma de Pago */
DO:
  FIND gn-ConVt WHERE gn-ConVt.Codig = INPUT {&self-name} NO-LOCK NO-ERROR.
  IF AVAILABLE gn-ConVt THEN
      DISPLAY gn-ConVt.Nombr @ FILL-IN-FmaPgo WITH FRAME {&FRAME-NAME}.
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
  {src/adm/template/row-list.i "CcbCDocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCDocu"}

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
  HIDE FRAME sF-Main.
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

  DEF VAR x-nuevo-preuni AS DEC.
  DEF VAR x-nuevo-implin AS DEC.
  DEF VAR x-nuevo-igv AS DEC.
  DEF VAR x-Items AS INT NO-UNDO.

  /* Importamos el temporal */
  RUN Import-Temp-Table IN lh_handle (OUTPUT TABLE DETA).

  FOR EACH DETA BY DETA.NroItm:
      x-Items = x-Items + 1.
      CREATE CcbDDocu.
      ASSIGN 
          CcbDDocu.NroItm = x-Items
          CcbDDocu.CodCia = CcbCDocu.CodCia 
          CcbDDocu.Coddiv = CcbCDocu.Coddiv 
          CcbDDocu.CodDoc = CcbCDocu.CodDoc 
          CcbDDocu.NroDoc = CcbCDocu.NroDoc
          CcbDDocu.FchDoc = CcbCDocu.FchDoc
          CcbDDocu.codmat = DETA.codmat 
          CcbDDocu.PreUni = DETA.PreUni 
          CcbDDocu.CanDes = DETA.CanDes 
          CcbDDocu.Factor = DETA.Factor 
          CcbDDocu.ImpIsc = DETA.ImpIsc
          CcbDDocu.ImpIgv = DETA.ImpIgv 
          CcbDDocu.ImpLin = DETA.ImpLin
          CcbDDocu.PorDto = 0  /*DETA.PorDto */
          CcbDDocu.PreBas = DETA.PreBas 
          CcbDDocu.ImpDto = 0  /*DETA.ImpDto*/
          CcbDDocu.AftIgv = DETA.AftIgv
          CcbDDocu.AftIsc = DETA.AftIsc
          CcbDDocu.UndVta = DETA.UndVta
          CcbDDocu.Por_Dsctos[1] = 0 /*DETA.Por_Dsctos[1]*/
          CcbDDocu.Por_Dsctos[2] = 0 /*DETA.Por_Dsctos[2]*/
          CcbDDocu.Por_Dsctos[3] = 0 /*DETA.Por_Dsctos[3]*/
          CcbDDocu.Flg_factor = DETA.Flg_factor
          CcbDDocu.ImpCto     = DETA.ImpCto.
  END.
  IF AVAILABLE(Ccbddocu) THEN RELEASE Ccbddocu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Temp-FeLogErrores V-table-Win 
PROCEDURE Graba-Temp-FeLogErrores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH T-FeLogErrores:
    CREATE FeLogErrores.
    BUFFER-COPY T-FeLogErrores TO FeLogErrores NO-ERROR.
    DELETE T-FeLogErrores.
END.
IF AVAILABLE(FeLogErrores) THEN RELEASE FeLogErrores.

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

    DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

    {vtagn/i-total-factura-sunat.i &Cabecera="Ccbcdocu" &Detalle="Ccbddocu"}

    DEF VAR hxProc AS HANDLE NO-UNDO.
    RUN sunat/sunat-calculo-importes.r PERSISTENT SET hxProc.
    RUN tabla-ccbcdocu IN hxProc (INPUT Ccbcdocu.CodDiv,
                                  INPUT Ccbcdocu.CodDoc,
                                  INPUT Ccbcdocu.NroDoc,
                                  OUTPUT pMensaje).
    DELETE PROCEDURE hxProc.
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
    
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Import-Temp-Table V-table-Win 
PROCEDURE Import-Temp-Table :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER TABLE FOR DETA.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
       AND FacCorre.CodDoc = S-CODDOC 
       AND FacCorre.NroSer = s-NroSer
       NO-LOCK NO-ERROR.
  IF FacCorre.FlgEst = NO THEN DO:
       MESSAGE 'Esta serie está bloqueada para hacer movimientos' VIEW-AS ALERT-BOX WARNING.
       RETURN 'ADM-ERROR'.
  END.

  DEFINE VAR x-nuevo-preuni AS DEC.
  DEFINE VAR pRowid_Ccbcdocu AS ROWID NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida-add-record ( OUTPUT pRowid_Ccbcdocu,
                          OUTPUT pMensaje ).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
      RETURN "ADM-ERROR".
  END.
  ASSIGN
      s-PorIgv = FacCfgGn.PorIgv
      s-PorDto = 0.
  RUN Procesa-Handle IN lh_handle ("Disable-Head").

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      FIND B-CDOCU WHERE ROWID(B-CDOCU) = pRowid_Ccbcdocu NO-LOCK.
      DISPLAY
          B-CDOCU.codcli @ Ccbcdocu.codcli
          B-CDOCU.nomcli @ Ccbcdocu.nomcli
          B-CDOCU.dircli @ Ccbcdocu.dircli
          B-CDOCU.ruccli @ Ccbcdocu.ruccli
          B-CDOCU.codant @ Ccbcdocu.codant
          B-CDOCU.nroref @ Ccbcdocu.nroref
          B-CDOCU.fmapgo @ Ccbcdocu.fmapgo
          B-CDOCU.codcta @ Ccbcdocu.codcta
          B-CDOCU.glosa  @ Ccbcdocu.glosa
          STRING(FacCorre.nroSer, '999') + STRING(FacCorre.Correlativo, '999999') @  CcbCDocu.NroDoc
          STRING(FacCorre.nroSer, ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo, ENTRY(2,x-Formato,'-')) @  CcbCDocu.NroDoc
          TODAY @ CcbCDocu.FchDoc 
          TODAY @ CcbCDocu.FchVto
          s-user-id @ CcbCDocu.usuario.
      ASSIGN
          Ccbcdocu.codref:SCREEN-VALUE = B-CDOCU.codref
          Ccbcdocu.nroref:SCREEN-VALUE = B-CDOCU.nroref
          CcbCDocu.CodMon:SCREEN-VALUE = STRING(B-CDOCU.codmon)
          Ccbcdocu.codped:SCREEN-VALUE = B-CDOCU.coddoc
          Ccbcdocu.nroped:SCREEN-VALUE = B-CDOCU.nrodoc
          .

      EMPTY TEMP-TABLE DETA.
      FOR EACH Ccbddocu OF B-CDOCU NO-LOCK:
          CREATE DETA.
          BUFFER-COPY Ccbddocu TO DETA.
      END.
      APPLY 'LEAVE':U TO CcbCDocu.FmaPgo.
      APPLY 'LEAVE':U TO CcbCDocu.CodCta.
  END.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('Browse').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       Siempre es CREATE
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR pCuenta AS INTE NO-UNDO.

  FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia AND
      B-CDOCU.coddoc = CcbCDocu.CodRef:SCREEN-VALUE IN FRAME {&FRAME-NAME} AND
      B-CDOCU.nrodoc = CcbCDocu.NroRef:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
      NO-LOCK NO-ERROR.


  /* Bloqueamos Correlativo */
  {lib/lock-genericov3.i ~
      &Tabla="FacCorre" ~
      &Condicion="FacCorre.CodCia = s-codcia ~
      AND FacCorre.CodDiv = s-coddiv ~
      AND FacCorre.CodDoc = s-coddoc ~
      AND FacCorre.NroSer = s-nroser" ~
      &Bloqueo="EXCLUSIVE-LOCK" ~
      &Accion="RETRY" ~
      &Mensaje="YES" ~
      &txtMensaje="pMensaje" ~
      &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
      }

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* FORMATO DEL COMPROBANTE: XXX-XXXXXXXX    (3-8) */
  ASSIGN 
      CcbCDocu.CodCia = S-CODCIA
      CcbCDocu.CodDiv = S-CODDIV
      CcbCDocu.CodDoc = S-CODDOC
      CcbCDocu.NroDoc = STRING(FacCorre.NroSer,ENTRY(1,x-Formato,'-')) + STRING(FacCorre.Correlativo,ENTRY(2,x-Formato,'-')) 
      CcbCDocu.FchDoc = TODAY
      CcbCDocu.FchVto = ADD-INTERVAL (TODAY, 1, 'years')
      CcbCDocu.FlgEst = "P"
      CcbCDocu.PorIgv = s-PorIgv
      CcbCDocu.PorDto = S-PORDTO
      CcbCDocu.TpoCmb = FacCfgGn.TpoCmb[1]
      CcbCDocu.CndCre = s-CndCre     /* POR DEVOLUCION */
      CcbCDocu.TpoFac = s-TpoFac
      CcbCDocu.Tipo   = s-Tipo
      /*CcbCDocu.CodCaja= s-CodTer*/
      CcbCDocu.usuario = S-USER-ID
      CcbCDocu.SdoAct = CcbCDocu.Imptot
      NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
      {lib/mensaje-de-error.i &MensajeError="pMensaje"}
      UNDO, RETURN 'ADM-ERROR'.
  END.
  /* Control de Aprobación de N/C */
  RUN lib/LogTabla ("ccbcdocu", ccbcdocu.coddoc + ',' + ccbcdocu.nrodoc, "APROBADO").
  /* **************************** */
  ASSIGN 
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
  RELEASE FacCorre.

  ASSIGN 
      CcbCDocu.CodAlm = Almcmov.CodAlm
      CcbCDocu.CodMov = Almcmov.CodMov
      CcbCDocu.CodVen = Almcmov.CodVen
      .
  /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
  FIND B-CDOCU WHERE B-CDOCU.codcia = s-codcia
      AND B-CDOCU.coddoc = ccbcdocu.codref
      AND B-CDOCU.nrodoc = ccbcdocu.nroref 
      NO-LOCK NO-ERROR.
  IF AVAILABLE B-CDOCU THEN DO:
      FIND GN-VEN WHERE gn-ven.codcia = s-codcia
          AND gn-ven.codven = B-CDOCU.codven
          NO-LOCK NO-ERROR.
      IF AVAILABLE GN-VEN THEN Ccbcdocu.cco = gn-ven.cco.
  END.

  RUN Genera-Detalle.   

  RUN vta2/actualiza-cot-por-devolucion (ROWID(Ccbcdocu), -1).
  IF RETURN-VALUE = "ADM-ERROR" THEN DO:
      pMensaje = "NO se pudo actualizar la cotización" + CHR(10) +
                "Proceso Abortado".
      UNDO, RETURN "ADM-ERROR".
  END.
  
  RUN Graba-Totales (OUTPUT pMensaje).
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.



  /* *******************************************************************************
    Ic - 24Ago2020, Correo de Julissa del 21 de Agosto del 2020
        Al momento que el area de credito genere la NCI, y referencie el FAI, EN AUTOMÁTICO quedarán liquidados ambos documentos,
        Con esta nueva operativa minimizamos el tiempo en las liquidaciones        
  ****************************************************************************** */
   DEFINE VAR hProc AS HANDLE NO-UNDO.          /* Handle Libreria */
   DEFINE VAR cRetVal AS CHAR.

   RUN ccb\libreria-ccb.r PERSISTENT SET hProc.

   /* Procedimientos */
   RUN CCB_Aplica-NCI IN hProc (INPUT CcbCDocu.coddoc, INPUT CcbCDocu.nrodoc, OUTPUT cRetVal).   

   DELETE PROCEDURE hProc.                      /* Release Libreria */

   IF cRetVal > "" THEN DO:
       MESSAGE "Hubo problemas en la grabacion " SKIP
                cRetval VIEW-AS ALERT-BOX INFORMATION.
       UNDO, RETURN 'ADM-ERROR'.
   END.
  /* ********************************************************************** */
  /* RHC 17/07/17 OJO: Hay una condición de error en el trigger w-almcmov.p */
  /* ********************************************************************** */
  ASSIGN Almcmov.FlgEst = "C" NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
      {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
      UNDO, RETURN 'ADM-ERROR'.
  END.
  RELEASE Almcmov.  /* Forzamos la ejecución del Trigger WRITE */
  /* ********************************************************************** */

  /* GENERACION DE CONTROL DE PERCEPCIONES */
  RUN vta2/control-percepcion-abonos (ROWID(Ccbcdocu)) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
  /* ************************************* */

  /* ************************************************** */
  /* RHC SUNAT: Generación del Archivo FELogComprobantes sí o sí */
  RUN sunat\progress-to-ppll-v3  ( INPUT Ccbcdocu.coddiv,
                                   INPUT Ccbcdocu.coddoc,
                                   INPUT Ccbcdocu.nrodoc,
                                   INPUT-OUTPUT TABLE T-FELogErrores,
                                   OUTPUT pMensaje ).
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
  IF RETURN-VALUE = 'ERROR-EPOS' THEN DO:
      /* NO se pudo confirmar el comprobante en el e-pos */
      /* Se procede a ANULAR el comprobante              */
      pMensaje = pMensaje + CHR(10) +
          "Se procede a anular el comprobante: " + Ccbcdocu.coddoc + " " + Ccbcdocu.nrodoc + CHR(10) +
          "Salga del sistema, vuelva a entra y vuelva a intentarlo".
      ASSIGN
          CcbCDocu.FchAnu = TODAY
          CcbCDocu.FlgEst = "A"
          CcbCDocu.SdoAct = 0
          CcbCDocu.UsuAnu = s-user-id.
      FIND Almcmov WHERE ROWID(Almcmov) = R-NRODEV  EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE Almcmov THEN Almcmov.FlgEst = "P".
      RUN vta2/actualiza-cot-por-devolucion (ROWID(Ccbcdocu), +1).
      /* EXTORNA CONTROL DE PERCEPCIONES POR ABONOS */
      FOR EACH B-CDOCU WHERE B-CDOCU.codcia = Ccbcdocu.codcia
          AND B-CDOCU.coddiv = Ccbcdocu.coddiv
          AND B-CDOCU.coddoc = "PRA"
          AND B-CDOCU.codref = Ccbcdocu.coddoc
          AND B-CDOCU.nroref = Ccbcdocu.nrodoc:
          DELETE B-CDOCU.
      END.
  END.
  /* *********************************************************** */

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
  RUN Procesa-Handle IN lh_handle ("Enable-Head").

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
  MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
  RETURN 'ADM-ERROR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  IF AVAILABLE Ccbcdocu THEN DO WITH FRAME {&FRAME-NAME}:
      RUN gn/fFlgEstCCB (Ccbcdocu.flgest, OUTPUT FILL-IN-Estado).
      DISPLAY FILL-IN-Estado.

      FIND gn-ConVt WHERE gn-ConVt.Codig = CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
      IF AVAILABLE gn-ConVt THEN DISPLAY gn-ConVt.Nombr @ FILL-IN-FmaPgo.
      
      FIND Ccbtabla WHERE CcbTabla.CodCia = s-codcia AND
          CcbTabla.Tabla = "N/C" AND
          CcbTabla.Codigo = CcbCDocu.CodCta
          NO-LOCK NO-ERROR.
      IF AVAILABLE Ccbtabla THEN DISPLAY CcbTabla.Nombre @ FILL-IN_CodCta.
      ELSE DISPLAY "" @ FILL-IN_CodCta.
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
      DISABLE 
          CcbCDocu.CodAnt 
          CcbCDocu.CodCli
          CcbCDocu.CodCta
          CcbCDocu.CodMon 
          CcbCDocu.CodPed 
          CcbCDocu.CodRef 
          CcbCDocu.DirCli 
          CcbCDocu.FchAnu 
          CcbCDocu.FchDoc 
          CcbCDocu.FchVto 
          CcbCDocu.FmaPgo 
          CcbCDocu.NomCli 
          CcbCDocu.NroDoc 
          CcbCDocu.NroPed 
          CcbCDocu.NroRef 
          CcbCDocu.RucCli 
          CcbCDocu.UsuAnu 
          CcbCDocu.usuario
          CcbCDocu.CodCta
          .
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
  EMPTY TEMP-TABLE T-FELogErrores.    /* CONTROL DE ERRORES DE FACTURACION ELECTRONICA */
  pMensaje = "".

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  IF pMensaje > "" THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */

  RUN Procesa-Handle IN lh_Handle ('Pagina1'). 
  RUN Procesa-Handle IN lh_Handle ('browse'). 
  RUN Procesa-Handle IN lh_handle ("Enable-Head").

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
  {src/adm/template/snd-list.i "CcbCDocu"}

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

DO WITH FRAME {&FRAME-NAME}:
    /* Concepto */
    IF TRUE <> (CcbCDocu.CodCta:SCREEN-VALUE > '') THEN DO:
        MESSAGE 'Ingreso el concepto' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO CcbCDocu.CodCta.
        RETURN 'ADM-ERROR'.
    END.
    /* Debe estar en el maestro y activo */
    FIND Ccbtabla WHERE CcbTabla.CodCia = s-codcia AND
        CcbTabla.Tabla = "N/C" AND
        CcbTabla.Codigo = CcbCDocu.CodCta:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbtabla OR Ccbtabla.Libre_L02 = NO THEN DO:
        MESSAGE 'Concepto no válido' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO CcbCDocu.CodCta.
        RETURN 'ADM-ERROR'.
    END.
    /* Debe estar en la configuración */
    FIND Vtactabla WHERE VtaCTabla.CodCia = s-codcia AND
        VtaCTabla.Tabla = 'CFG_TIPO_NC' AND 
        VtaCTabla.Llave = s-TpoFac
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtactabla THEN DO:
        MESSAGE 'Concepto no configurado para este movimiento' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO CcbCDocu.CodCta.
        RETURN 'ADM-ERROR'.
    END.
    FIND Vtadtabla WHERE VtaDTabla.CodCia = s-codcia AND
        VtaDTabla.Tabla = 'CFG_TIPO_NC' AND
        VtaDTabla.Llave = s-TpoFac AND
        VtaDTabla.Tipo = "CONCEPTO" AND
        VtaDTabla.LlaveDetalle = CcbCDocu.CodCta:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtadtabla THEN DO:
        MESSAGE 'Concepto no configurado para este movimiento' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO CcbCDocu.CodCta.
        RETURN 'ADM-ERROR'.
    END.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-add-record V-table-Win 
PROCEDURE valida-add-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER pRowid_Ccbcdocu AS ROWID NO-UNDO.
  DEFINE OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  DEFINE VAR x-nuevo-preuni             AS DEC NO-UNDO.
  DEFINE VAR x-nuevo-implin             AS DEC NO-UNDO.
  DEFINE VAR x-impte-devolucion         AS DEC NO-UNDO.
  DEFINE VAR x-impte-cmpte-referenciado AS DEC NO-UNDO. 
  DEFINE VAR x-impte-QR                 AS DEC NO-UNDO. 
  DEFINE VAR x-porcentaje-devol         AS DEC NO-UNDO. 
  DEFINE VAR x-valida-nc                AS LOG NO-UNDO. 
  DEFINE VAR x-diferencia               AS DEC NO-UNDO.
  
  /* Piden PNC */
  ASSIGN
      input-var-1 = s-CodRef
      input-var-2 = s-CodDiv
      input-var-3 = 'P'
      output-var-1 = ?
      output-var-2 = ''
      output-var-3 = ''.
  RUN lkup/c-pncndxotros ('PRE-NOTAS APROBADAS').
  IF output-var-1 = ? THEN RETURN 'ADM-ERROR'.

  FIND B-CDOCU WHERE ROWID(B-CDOCU) = output-var-1 NO-LOCK.
  ASSIGN
      pRowid_Ccbcdocu = ROWID(B-CDOCU).

  DEFINE VAR hxProc AS HANDLE NO-UNDO.                /* Handle Libreria */

  RUN ccb\libreria-ccb.r PERSISTENT SET hxProc.
  DEFINE VAR x-retval AS CHAR.
                                               
  RUN notas-creditos-supera-comprobante IN hxProc (INPUT B-CDOCU.codref, 
                                           INPUT B-CDOCU.NroRef,
                                           OUTPUT x-retval).

  DELETE PROCEDURE hxProc.                    /* Release Libreria */
  /* 
      pRetVal : NO (importes de N/C NO supera al comprobante)
  */
  IF x-retval <> "NO" THEN DO:
      pMensaje = "Existen N/Cs emitidas referenciando al comprobante" + CHR(10) +
          B-CDocu.CodRef + " " + B-CDocu.NroRef + " y cuya suma de sus importes" + CHR(10) +
          "superan a dicho comprobante".
      RETURN 'ADM-ERROR'.
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

MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX ERROR.
RETURN 'ADM-ERROR'. /* No se puede realizar modificaciones */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

