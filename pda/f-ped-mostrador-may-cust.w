&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM-3 LIKE FacDPedi.
DEFINE TEMP-TABLE PEDI-3 NO-UNDO LIKE FacDPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS F-Frame-Win 
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

  Description: from cntnrfrm.w - ADM SmartFrame Template

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
&SCOPED-DEFINE Promocion web/promocion-general-flash.p

/* Local Variable Definitions ---                                       */

DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddoc AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-CndVta AS CHAR.
DEF SHARED VAR s-FlgEmpaque LIKE gn-divi.FlgEmpaque.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-fmapgo AS CHAR.

DEFINE SHARED VARIABLE S-CODCLI AS CHAR.
DEFINE SHARED VARIABLE s-RucCli AS CHAR.
DEFINE SHARED VARIABLE s-Atencion AS CHAR.
DEFINE SHARED VARIABLE s-NomCli AS CHAR.
DEFINE SHARED VARIABLE s-DirCli AS CHAR.
DEFINE SHARED VARIABLE s-Cmpbnte AS CHAR.
DEFINE SHARED VARIABLE lh_handle AS HANDLE.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VAR x-ClientesVarios AS CHAR.
x-ClientesVarios = FacCfgGn.CliVar.     /* 11 digitos */

DEF SHARED VAR s-CodMon AS INTE.
DEF SHARED VAR s-TpoCmb AS DECI.
/* ICBPER */
DEFINE VAR x-articulo-ICBPER AS CHAR.

x-articulo-ICBPER = '099268'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartFrame
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BUTTON-1 BUTTON-6 RECT-5 RADIO-SET_Cmpbte ~
FILL-IN_CodCli FILL-IN_RucCli FILL-IN_Atencion 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET_Cmpbte FILL-IN_CodCli ~
FILL-IN_RucCli FILL-IN_Atencion EDITOR_NomCli EDITOR_DirCli FILL-IN-ImpTot 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEsAlfabetico F-Frame-Win 
FUNCTION getEsAlfabetico RETURNS LOGICAL
  ( INPUT pCaracter AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSoloLetras F-Frame-Win 
FUNCTION getSoloLetras RETURNS LOGICAL
  ( INPUT pTexto AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     IMAGE-UP FILE "img/search-alt-2-regular-24.bmp":U NO-FOCUS
     LABEL "Button 1" 
     SIZE 5 BY 1.35 TOOLTIP "Buscar".

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img/user-plus-regular-24.bmp":U NO-FOCUS
     LABEL "Button 6" 
     SIZE 5 BY 1.35 TOOLTIP "Registrar nuevo cliente".

DEFINE VARIABLE EDITOR_DirCli AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 100
     SIZE 48 BY 2.96 NO-UNDO.

DEFINE VARIABLE EDITOR_NomCli AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 100
     SIZE 48 BY 2.96 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpTot AS DECIMAL FORMAT "ZZZ,ZZ9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY 1.38
     BGCOLOR 14 FGCOLOR 0 FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN_Atencion AS CHARACTER FORMAT "X(11)" 
     LABEL "DNI" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1.38.

DEFINE VARIABLE FILL-IN_CodCli AS CHARACTER FORMAT "x(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1.38 NO-UNDO.

DEFINE VARIABLE FILL-IN_RucCli AS CHARACTER FORMAT "x(11)" 
     LABEL "RUC" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1.38.

DEFINE VARIABLE RADIO-SET_Cmpbte AS CHARACTER INITIAL "BOL" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "FACTURA", "FAC",
"BOLETA", "BOL"
     SIZE 36 BY 1.38 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 62 BY 2.69.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-1 AT ROW 3.15 COL 40 WIDGET-ID 114
     BUTTON-6 AT ROW 3.15 COL 45 WIDGET-ID 124
     RADIO-SET_Cmpbte AT ROW 1.54 COL 15 NO-LABEL WIDGET-ID 108
     FILL-IN_CodCli AT ROW 3.15 COL 13 COLON-ALIGNED WIDGET-ID 102
     FILL-IN_RucCli AT ROW 4.77 COL 13 COLON-ALIGNED WIDGET-ID 106
     FILL-IN_Atencion AT ROW 6.38 COL 13 COLON-ALIGNED WIDGET-ID 104
     EDITOR_NomCli AT ROW 8 COL 15 NO-LABEL WIDGET-ID 100
     EDITOR_DirCli AT ROW 10.96 COL 15 NO-LABEL WIDGET-ID 92
     FILL-IN-ImpTot AT ROW 14.73 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     "TOTAL S/" VIEW-AS TEXT
          SIZE 17 BY 1.35 AT ROW 14.73 COL 24 WIDGET-ID 120
          FONT 8
     "Nombre:" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 8 COL 4 WIDGET-ID 90
     "Dirección:" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 10.96 COL 2 WIDGET-ID 94
     RECT-5 AT ROW 13.92 COL 2 WIDGET-ID 128
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 63.72 BY 16
         BGCOLOR 15 FGCOLOR 0 FONT 9 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartFrame
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
      TABLE: ITEM-3 T "?" ? INTEGRAL FacDPedi
      TABLE: PEDI-3 T "?" NO-UNDO INTEGRAL FacDPedi
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
  CREATE WINDOW F-Frame-Win ASSIGN
         HEIGHT             = 21.58
         WIDTH              = 66.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB F-Frame-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW F-Frame-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME                                               */
ASSIGN 
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR EDITOR EDITOR_DirCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR EDITOR_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = ""
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 F-Frame-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Button 1 */
DO:
  ASSIGN
      input-var-1 = ''
      input-var-2 = ''
      input-var-3 = ''
      output-var-1 = ?.
  RUN pda/c-cliente-activo.w ('REGISTRADOS Y CLIENTES ACTIVOS').
  IF output-var-1 <> ? THEN DO:
      FILL-IN_CodCli:SCREEN-VALUE = output-var-2.
      APPLY 'ENTRY':U TO FILL-IN_CodCli.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 F-Frame-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
    RUN Procesa-Botones IN lh_handle ('Select-Page-5').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME EDITOR_DirCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EDITOR_DirCli F-Frame-Win
ON LEAVE OF EDITOR_DirCli IN FRAME F-Main
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME EDITOR_NomCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EDITOR_NomCli F-Frame-Win
ON LEAVE OF EDITOR_NomCli IN FRAME F-Main
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodCli F-Frame-Win
ON LEAVE OF FILL-IN_CodCli IN FRAME F-Main /* Cliente */
DO:
  IF FILL-IN_CodCli:SCREEN-VALUE = "" THEN RETURN.

  /* Verificar la Longuitud */
  DEFINE VAR x-data AS CHAR.
  x-data = TRIM(FILL-IN_CodCli:SCREEN-VALUE).
  IF LENGTH(x-data) < 11 THEN DO:
      x-data = FILL("0", 11 - LENGTH(x-data)) + x-data.
  END.

  FILL-IN_CodCli:SCREEN-VALUE = x-data.
  /**/
  FIND FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA
      AND gn-clie.CodCli = SELF:SCREEN-VALUE 
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-clie THEN DO:      /* CREA EL CLIENTE NUEVO */
      RUN Mensaje-Error ('Cliente NO registrado').
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  /* **************************************** */
  /* RHC 22/07/2020 Nuevo bloqueo de clientes */
  /* **************************************** */
  RUN pri/p-verifica-cliente-utilex (INPUT gn-clie.codcli,
                                     INPUT s-CodDoc,
                                     INPUT s-CodDiv).
/*   RUN pri/p-verifica-cliente (INPUT gn-clie.codcli, */
/*                               INPUT s-CodDoc,       */
/*                               INPUT s-CodDiv).      */
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  /* **************************************** */
  /* 13/05/2022: Verificar configuración del cliente */
  FIND VtaTabla WHERE VtaTabla.CodCia = s-CodCia
      AND VtaTabla.Tabla = 'CN-GN'
      AND VtaTabla.Llave_c1 =  Gn-Clie.Canal
      AND VtaTabla.Llave_c2 =  Gn-Clie.GirCli
      NO-LOCK NO-ERROR.
  IF AVAILABLE VtaTabla AND VtaTabla.Libre_c01 = "SI" THEN DO:
      RUN Mensaje-Error ('El cliente pertenece a una institucion PUBLICA').
      SELF:SCREEN-VALUE = ''.
      RETURN NO-APPLY.
  END.
  s-CodCli = SELF:SCREEN-VALUE.
  /* *********************************************** */
  DISPLAY 
      gn-clie.Ruc     WHEN s-codcli <> x-ClientesVarios @ FILL-IN_RucCli
      gn-clie.Dni     WHEN s-codcli <> x-ClientesVarios @ FILL-IN_Atencion
      WITH FRAME {&FRAME-NAME}.
  IF s-codcli <> x-ClientesVarios THEN EDITOR_NomCli:SCREEN-VALUE = gn-clie.NomCli.
  IF s-codcli <> x-ClientesVarios THEN EDITOR_DirCli:SCREEN-VALUE = gn-clie.DirCli.

  /* En caso NO tenga su dirección */
  IF TRUE <> (EDITOR_DirCli:SCREEN-VALUE IN FRAME {&FRAME-NAME} > '') THEN DO:
      FIND FIRST gn-clied OF gn-clie WHERE Gn-ClieD.Sede = "@@@" NO-LOCK NO-ERROR.
      IF AVAILABLE gn-clied THEN EDITOR_DirCli:SCREEN-VALUE = Gn-ClieD.DirCli.
  END.
  
  IF TRIM(FILL-IN_CodCli:SCREEN-VALUE) = x-ClientesVarios  THEN DO:
      FILL-IN_Atencion:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
      FILL-IN_RucCli:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
      EDITOR_DirCli:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
      EDITOR_NomCli:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  END.
  ELSE DO:
      FILL-IN_Atencion:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
      FILL-IN_RucCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
      EDITOR_DirCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
      EDITOR_NomCli:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  END.

  RUN Mensaje-Error ('').   /* Limpia Mensaje de Error */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK F-Frame-Win 


/* ***************************  Main Block  *************************** */
ON 'RETURN':U OF EDITOR_DirCli ,EDITOR_NomCli ,FILL-IN_Atencion ,FILL-IN_CodCli ,FILL-IN_RucCli ,RADIO-SET_Cmpbte
DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.


&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
   /* Now enable the interface  if in test mode - otherwise this happens when
      the object is explicitly initialized from its container. */
   RUN dispatch IN THIS-PROCEDURE ('initialize':U).
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects F-Frame-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available F-Frame-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cliente-Nuevo F-Frame-Win 
PROCEDURE Cliente-Nuevo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    DISPLAY s-codcli @ FILL-IN_CodCli.
    APPLY "ENTRY":U TO FILL-IN_CodCli.
    APPLY "TAB":U TO FILL-IN_CodCli.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Devuelve-Temporal F-Frame-Win 
PROCEDURE Devuelve-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER TABLE FOR ITEM.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI F-Frame-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI F-Frame-Win  _DEFAULT-ENABLE
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
  DISPLAY RADIO-SET_Cmpbte FILL-IN_CodCli FILL-IN_RucCli FILL-IN_Atencion 
          EDITOR_NomCli EDITOR_DirCli FILL-IN-ImpTot 
      WITH FRAME F-Main.
  ENABLE BUTTON-1 BUTTON-6 RECT-5 RADIO-SET_Cmpbte FILL-IN_CodCli 
         FILL-IN_RucCli FILL-IN_Atencion 
      WITH FRAME F-Main.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Limpia-Variables F-Frame-Win 
PROCEDURE Limpia-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    CLEAR FRAME {&FRAME-NAME} ALL NO-PAUSE.
    FILL-IN_CodCli = x-ClientesVarios.
    RADIO-SET_Cmpbte = "BOL".
    EDITOR_DirCli = ''.
    EDITOR_NomCli = ''.
    DISPLAY FILL-IN_CodCli RADIO-SET_Cmpbte EDITOR_DirCli EDITOR_NomCli.
    ASSIGN
        s-codcli = x-ClientesVarios
        s-Cmpbnte = "BOL"
        s-dircli = ''
        s-nomcli = ''.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize F-Frame-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FILL-IN_CodCli = x-ClientesVarios.
  RADIO-SET_Cmpbte = "BOL".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Mensaje-Error F-Frame-Win 
PROCEDURE Mensaje-Error :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pMensaje AS CHAR.

IF TRUE <> (pMensaje > '') THEN RETURN.

DEF VAR pRpta AS LOG NO-UNDO.

RUN pda/d-message (pMensaje, "ERROR", "", OUTPUT pRpta).


/* DO WITH FRAME {&FRAME-NAME}:            */
/*     EDITOR_Error = pMensaje.            */
/*     IF TRUE <> (pMensaje > '') THEN DO: */
/*         EDITOR_Error:HIDDEN = YES.      */
/*     END.                                */
/*     ELSE DO:                            */
/*         EDITOR_Error:HIDDEN = NO.       */
/*         DISPLAY EDITOR_Error.           */
/*     END.                                */
/* END.                                    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recibe-Parametros F-Frame-Win 
PROCEDURE Recibe-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pImpTot AS DEC.
DEF INPUT PARAMETER TABLE FOR ITEM.

DISPLAY pImpTot @ FILL-IN-ImpTot WITH FRAME {&FRAME-NAME}.
APPLY 'ENTRY':U TO FILL-IN_CodCli IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records F-Frame-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartFrame, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed F-Frame-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida F-Frame-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR ImpMinDNI AS DEC INIT 700 NO-UNDO.
DEF VAR F-BOL AS DECIMAL INIT 0 NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        EDITOR_DirCli EDITOR_NomCli FILL-IN_Atencion FILL-IN_CodCli 
        FILL-IN_RucCli FILL-IN-ImpTot RADIO-SET_Cmpbte.

    FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
          AND  gn-clie.CodCli = FILL-IN_CodCli
          NO-LOCK NO-ERROR.

    IF RADIO-SET_Cmpbte = "FAC" AND TRUE <> (FILL-IN_RucCli > '') THEN DO:
        RUN Mensaje-Error ('El Cliente NO tiene R.U.C.').
        APPLY "ENTRY" TO FILL-IN_CodCli.
        RETURN "ADM-ERROR".   
    END.
    IF RADIO-SET_Cmpbte = "FAC" THEN DO:
       IF LENGTH(FILL-IN_RucCli) < 11 THEN DO:
           RUN Mensaje-Error ('El RUC debe tener 11 dígitos').
           APPLY 'ENTRY':U TO FILL-IN_CodCli.
           RETURN 'ADM-ERROR'.
       END.
       IF LOOKUP(SUBSTRING(FILL-IN_RucCli,1,2), '20,15,17,10') = 0 THEN DO:
           RUN Mensaje-Error ('El RUC debe comenzar con 10,15,17 ó 20').
           APPLY 'ENTRY':U TO FILL-IN_CodCli.
           RETURN 'ADM-ERROR'.
       END.
       /* dígito verificador */
       DEF VAR pResultado AS CHAR NO-UNDO.
       RUN lib/_ValRuc (FILL-IN_RucCli, OUTPUT pResultado).
       IF pResultado = 'ERROR' THEN DO:
           RUN Mensaje-Error ('Código RUC MAL registrado').
           APPLY 'ENTRY':U TO FILL-IN_CodCli.
           RETURN 'ADM-ERROR'.
       END.
    END.

    FOR EACH ITEM NO-LOCK:
        F-Bol = F-Bol + ITEM.ImpLin.
    END.
    F-BOL = IF s-CodMon = 1 
        THEN F-BOL
        ELSE F-BOL * s-TpoCmb.

    DEF VAR cNroDni AS CHAR NO-UNDO.
    DEF VAR iLargo  AS INT NO-UNDO.
    DEF VAR cError  AS CHAR NO-UNDO.
    cNroDni = FILL-IN_Atencion:SCREEN-VALUE.

    IF RADIO-SET_Cmpbte = 'BOL' AND F-BOL > ImpMinDNI THEN DO:
        /* 03/07/2023: Carnet de extranjeria actualmente tiene 9 dígitos Gianella Chirinos S.Leon */
        RUN lib/_valid_number (INPUT-OUTPUT cNroDni, OUTPUT iLargo, OUTPUT cError).
        IF cError > '' OR iLargo < 8 THEN DO:
            cError = cError + (IF cError > '' THEN '.' ELSE '') + "El DNI debe tener al menos 8 dígitos".
            RUN Mensaje-Error (cError).
            APPLY "ENTRY" TO FILL-IN_Atencion.
            RETURN "ADM-ERROR".   
        END.
        IF iLargo <> 8 AND gn-clie.Libre_c01 = "N" THEN DO:
            RUN Mensaje-Error ('El DNI debete tener 8 dígitos').
            APPLY "ENTRY" TO FILL-IN_Atencion.
            RETURN "ADM-ERROR".   
        END.

        IF TRUE <> (EDITOR_NomCli > '') THEN DO:
            RUN Mensaje-Error ("Venta Mayor a " + STRING(ImpMinDNI) + ". Debe ingresar el Nombre del Cliente").
            APPLY "ENTRY" TO EDITOR_NomCli.
            RETURN "ADM-ERROR".   
        END.
        IF TRUE <> (EDITOR_DirCli > '') THEN DO:
            RUN Mensaje-Error ("Venta Mayor a " + STRING(ImpMinDNI) + ". Debe ingresar la Dirección del Cliente").
            APPLY "ENTRY" TO EDITOR_DirCli.
            RETURN "ADM-ERROR".   
        END.
    END.
    /* VALIDAMOS CLIENTES VARIOS */
    IF FILL-IN_CodCli = x-ClientesVarios THEN DO:
        IF NOT getSoloLetras(SUBSTRING(EDITOR_NomCli,1,2)) THEN DO:
            RUN Mensaje-Error ('Nombre no pasa la validacion para SUNAT').
            RETURN 'ADM-ERROR'.                                   
        END.
    END.
    /* *************************************************************************************** */
    /* 19/01/2023 Nuevos Controles */
    /* *************************************************************************************** */
    /* *************************************************************************************** */
    /* Verificamos PEDI y lo actualizamos con el stock disponible */
    /* *************************************************************************************** */
    DEF VAR pMensaje AS CHAR NO-UNDO.

    EMPTY TEMP-TABLE PEDI-3.
    FOR EACH ITEM:
        CREATE PEDI-3.
        BUFFER-COPY ITEM TO PEDI-3.
    END.
    SESSION:SET-WAIT-STATE('GENERAL').
    RUN VALIDATE-DETAIL (INPUT "YES", OUTPUT pMensaje).
    SESSION:SET-WAIT-STATE('').
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        RUN Mensaje-Error (pMensaje).
        /* Regresamos todo como si no hubiera pasado nada */
        EMPTY TEMP-TABLE ITEM.
        FOR EACH PEDI-3:
            CREATE ITEM.
            BUFFER-COPY PEDI-3 TO ITEM.
        END.
        RETURN 'ADM-ERROR'.
    END.
    /* Variables para la grabación */
    ASSIGN
        s-CodCli = FILL-IN_CodCli
        s-RucCli =  FILL-IN_RucCli
        s-Atencion = FILL-IN_Atencion
        s-NomCli = EDITOR_NomCli
        s-DirCli = EDITOR_DirCli
        s-Cmpbnte = RADIO-SET_Cmpbte
        .

END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VALIDATE-DETAIL F-Frame-Win 
PROCEDURE VALIDATE-DETAIL :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF INPUT PARAMETER pEvento AS CHAR.
  DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

  /* ********************* */
  DEF VAR f-Factor AS DECI NO-UNDO.
  DEF VAR s-StkComprometido AS DECI NO-UNDO.
  DEF VAR x-StkAct AS DECI NO-UNDO.
  DEF VAR s-StkDis AS DECI NO-UNDO.
  DEF VAR x-CanPed AS DECI NO-UNDO.

  /* Borramos data sobrante */
  FOR EACH ITEM EXCLUSIVE-LOCK WHERE ITEM.CanPed <= 0:
      DELETE ITEM.
  END.
  
  EMPTY TEMP-TABLE ITEM-3.

  DETALLE:
  FOR EACH ITEM EXCLUSIVE-LOCK WHERE ITEM.codmat <> x-articulo-ICBPER, 
      FIRST Almmmatg OF ITEM NO-LOCK  
      BY ITEM.NroItm : 
      ASSIGN
          ITEM.Libre_d01 = ITEM.CanPed.
      /* RUTINA QUE VERIFICA NUEVAMENTE EL STOCK DISPONIBLE Y AJUSTA LA CANTIDAD EN CASO NECESARIO */
      x-StkAct = 0.
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = ITEM.AlmDes
          AND Almmmate.codmat = ITEM.CodMat
          NO-LOCK NO-ERROR .
      IF NOT AVAILABLE Almmmate THEN DO:
          pMensaje = "Código " + ITEM.CodMat + " No registrado en el almacén " + ITEM.almdes  + CHR(10) + ~
              "Proceso abortado".
          UNDO, RETURN "ADM-ERROR".
      END.
      x-StkAct = Almmmate.StkAct.
      f-Factor = ITEM.Factor.
      /* **************************************************************** */
      /* Solo verifica comprometido si hay stock */
      /* **************************************************************** */
      IF x-StkAct > 0 THEN DO:
          RUN gn/Stock-Comprometido-v2 (ITEM.CodMat, ITEM.AlmDes, YES, OUTPUT s-StkComprometido).
          /* **************************************************************** */
          /* OJO: Cuando se modifica hay que actualizar el STOCK COMPROMETIDO */
          /* **************************************************************** */
          IF pEvento = "NO" THEN DO:
              FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = ITEM.codmat NO-LOCK NO-ERROR.
              IF AVAILABLE Facdpedi THEN s-StkComprometido = s-StkComprometido - (Facdpedi.CanPed * Facdpedi.Factor).
          END.
      END.
      /* **************************************************************** */
      s-StkDis = x-StkAct - s-StkComprometido.

      IF s-StkDis < 0 THEN s-StkDis = 0.    /* *** OJO *** */
      x-CanPed = ITEM.CanPed * f-Factor.

      IF s-coddiv = '00506' THEN DO:
          IF s-StkDis < x-CanPed THEN DO:
              pMensaje = "Código " + ITEM.CodMat + " No hay stock disponible en el almacén " + ITEM.almdes  + CHR(10) + ~
                  "Proceso abortado".
              UNDO, RETURN "ADM-ERROR".
          END.
      END.
      IF s-StkDis < x-CanPed THEN DO:
          /* CONTROL DE AJUTES */
          CREATE ITEM-3.
          BUFFER-COPY ITEM TO ITEM-3
              ASSIGN ITEM-3.CanAte = 0.     /* Valor por defecto */    
          /* AJUSTAMOS Y RECALCULAMOS IMPORTES */
          ASSIGN
              ITEM.CanPed = s-StkDis / f-Factor
              ITEM.Libre_c01 = '*'.
          FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
              AND Almtconv.Codalter = ITEM.UndVta
              NO-LOCK NO-ERROR.
          IF AVAILABLE Almtconv AND Almtconv.Multiplos <> 0 THEN DO:
              IF (ITEM.CanPed / Almtconv.Multiplos) <> INTEGER(ITEM.CanPed / Almtconv.Multiplos) THEN DO:
                  ITEM.CanPed = TRUNCATE(ITEM.CanPed / Almtconv.Multiplos, 0) * Almtconv.Multiplos.
              END.
          END.
          IF s-FlgEmpaque = YES AND Almmmatg.CanEmp > 0 THEN DO:
              ITEM.CanPed = (TRUNCATE((ITEM.CanPed * ITEM.Factor / Almmmatg.CanEmp),0) * Almmmatg.CanEmp) / ITEM.Factor.
          END.
          ASSIGN ITEM-3.CanAte = ITEM.CanPed.       /* CANTIDAD AJUSTADA */

          RUN Recalcular-Item.
      END.
  END.

  /* POR CADA ITEM VOLVEMOS A VERIFICAR EL STOCK DISPONIBLE
    SI NO HAY STOCK RECALCULAMOS EL PRECIO DE VENTA */
  /* Borramos data sobrante */
  FOR EACH ITEM EXCLUSIVE-LOCK WHERE ITEM.CanPed <= 0:
      DELETE ITEM.
  END.

  /* 26/07/2023: Nueva libreria de promociones C.Camus
    Dos parámetros nuevos:
    pCodAlm: código de almacén de despacho
    pEvento: CREATE o UPDATE
  */                
  RUN {&Promocion} (s-CodDiv, 
                    s-CodCli, 
                    ENTRY(1,s-codalm), 
                    (IF pEvento = "YES" THEN "CREATE" ELSE "UDPATE"),
                    INPUT-OUTPUT TABLE ITEM, 
                    OUTPUT pMensaje).
  IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".


  FOR EACH ITEM NO-LOCK WHERE ITEM.Libre_c05 = "OF", 
      FIRST Almmmatg OF ITEM NO-LOCK, FIRST Almtfami OF Almmmatg NO-LOCK:
      /* **************************************************************************************** */
      /* VERIFICAMOS STOCK DISPONIBLE DE ALMACEN */
      /* **************************************************************************************** */
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = ITEM.AlmDes
          AND Almmmate.codmat = ITEM.CodMat
          NO-LOCK NO-ERROR.
      x-StkAct = 0.
      IF AVAILABLE Almmmate THEN x-StkAct = Almmmate.StkAct.
      RUN gn/stock-comprometido-v2.p (ITEM.CodMat, ITEM.AlmDes, YES, OUTPUT s-StkComprometido).
      /* **************************************************************** */
      /* OJO: Cuando se modifica hay que actualizar el STOCK COMPROMETIDO */
      /* **************************************************************** */
      IF pEvento = "NO" THEN DO:
          FIND Facdpedi OF Faccpedi WHERE Facdpedi.codmat = ITEM.codmat NO-LOCK NO-ERROR.
          IF AVAILABLE Facdpedi THEN s-StkComprometido = s-StkComprometido - (Facdpedi.CanPed * Facdpedi.Factor).
      END.
      /* **************************************************************** */
      s-StkDis = x-StkAct - s-StkComprometido.
      IF s-StkDis <= 0 THEN DO:
          pMensaje = 'El STOCK DISPONIBLE está en CERO para el producto ' + ITEM.codmat + 
              'en el almacén ' + ITEM.AlmDes + CHR(10).
          RETURN "ADM-ERROR".
      END.
      f-Factor = ITEM.Factor.
      x-CanPed = ITEM.CanPed * f-Factor.
      IF s-StkDis < x-CanPed THEN DO:
          pMensaje = 'Producto ' + ITEM.codmat + ' NO tiene Stock Disponible suficiente en el almacén ' + ITEM.AlmDes + CHR(10) +
              'Se va a abortar la generación del Pedido'.
          RETURN "ADM-ERROR".
      END.
  END.
  /* ********************************************************************************************** */
  /* ********************************************************************************************** */
  /* 16/11/2022: NINGUN producto (así sea promocional) debe estar con PRECIO CERO */
  /* ********************************************************************************************** */
  FOR EACH ITEM NO-LOCK:
      IF ITEM.PreUni <= 0 THEN DO:
          pMensaje = 'Producto ' + ITEM.codmat + ' NO tiene Precio Unitario ' + CHR(10) +
              'Se va a abortar la generación del Pedido'.
          RETURN "ADM-ERROR".
      END.
  END.
  IF NOT CAN-FIND(FIRST ITEM NO-LOCK) THEN DO:
      pMensaje = "NO hay stock suficiente para cubrir el pedido".
      RETURN 'ADM-ERROR'.
  END.

  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEsAlfabetico F-Frame-Win 
FUNCTION getEsAlfabetico RETURNS LOGICAL
  ( INPUT pCaracter AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-alfabetico AS CHAR.
    DEFINE VAR x-retval AS LOG INIT NO.

    x-alfabetico = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZabcdefghijklmnñopqrstuvwxyz".
    IF INDEX(x-alfabetico,pCaracter) > 0 THEN x-retval = YES.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSoloLetras F-Frame-Win 
FUNCTION getSoloLetras RETURNS LOGICAL
  ( INPUT pTexto AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    DEFINE VAR x-caracter AS CHAR.
    DEFINE VAR x-retval AS LOG INIT YES.
    DEFINE VAR x-sec AS INT.

    VALIDACION:
    REPEAT x-sec = 1 TO LENGTH(pTexto):
        x-caracter = SUBSTRING(pTexto,x-sec,1).
        x-retval = getEsAlfabetico(x-caracter).
        IF x-retval = NO THEN DO:
            LEAVE VALIDACION.
        END.
    END.

  RETURN x-retval.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

