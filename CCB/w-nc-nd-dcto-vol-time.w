&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER CREDITO FOR CcbCDocu.
DEFINE TEMP-TABLE t-CcbCDocu NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE t-CcbDDocu NO-UNDO LIKE CcbDDocu.
DEFINE TEMP-TABLE T-CDOCU NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE T-DDOCU NO-UNDO LIKE CcbDDocu.
DEFINE TEMP-TABLE T-DPEDI NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE T-FELogErrores NO-UNDO LIKE FELogErrores.
DEFINE TEMP-TABLE T-VtamDctoVolTime NO-UNDO LIKE VtamDctoVolTime.
DEFINE TEMP-TABLE T-VtapDctoVolTime NO-UNDO LIKE VtapDctoVolTime.
DEFINE TEMP-TABLE TT-DDOCU NO-UNDO LIKE CcbDDocu.
DEFINE TEMP-TABLE ttCcbcdocu NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE ttCcbddocu NO-UNDO LIKE CcbDDocu.
DEFINE TEMP-TABLE txCcbCDocu NO-UNDO LIKE CcbCDocu.
DEFINE TEMP-TABLE txCcbDDocu NO-UNDO LIKE CcbDDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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
&SCOPED-DEFINE ARITMETICA-SUNAT YES

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR cl-codcia AS INTE.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.

DEFINE NEW SHARED VAR s-FlgRotacion LIKE gn-divi.flgrotacion.
DEFINE NEW SHARED VAR s-FlgEmpaque  LIKE GN-DIVI.FlgEmpaque.
DEFINE NEW SHARED VAR s-FlgMinVenta LIKE GN-DIVI.FlgMinVenta.
DEFINE NEW SHARED VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.
DEFINE NEW SHARED VAR s-FlgTipoVenta LIKE GN-DIVI.FlgPreVta.
DEFINE NEW SHARED VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEFINE NEW SHARED VAR s-TpoPed AS CHAR.

DEFINE NEW SHARED VAR s-NroDec AS INTE INIT 4.
DEFINE NEW SHARED VAR s-PorIgv AS DECI.

/* DESCUENTO POR VOLUMEN/ ESCALA */
DEF VAR pCodCtaNC AS CHAR INIT '00002' NO-UNDO.
DEF VAR pCodCtaND AS CHAR INIT '00002' NO-UNDO.

FIND FIRST CcbTabla WHERE CcbTabla.CodCia = s-codcia AND
    CcbTabla.Tabla = 'CFG_DCTO_VOL_ACUM'
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE CcbTabla THEN DO:
    MESSAGE 'NO está configurados los conceptos de N/C y N/D' SKIP
        'Comunicarse con el Créditos y Cobranzas'
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
IF TRUE <> (CcbTabla.Libre_c01 > '') THEN DO:
    MESSAGE 'NO está configurados el conceptos de N/C' SKIP
        'Comunicarse con el Créditos y Cobranzas'
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
IF TRUE <> (CcbTabla.Libre_c02 > '') THEN DO:
    MESSAGE 'NO está configurados el conceptos de N/D' SKIP
        'Comunicarse con el Créditos y Cobranzas'
        VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
ASSIGN
    pCodCtaNC = CcbTabla.Libre_c01
    pCodCtaND = CcbTabla.Libre_c02.
/* pCodCtaNC = ENTRY(1,pParam). */
/* pCodCtaND = ENTRY(2,pParam). */
IF NOT CAN-FIND(FIRST CcbTabla WHERE CcbTabla.CodCia = s-codcia
                AND CcbTabla.Tabla = "N/C" 
                AND CcbTabla.Codigo = pCodCtaNC
                NO-LOCK)
    THEN DO:
    MESSAGE 'NO configurado el concepto' pCodCtaND 'para la N/C' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.
IF NOT CAN-FIND(FIRST CcbTabla WHERE CcbTabla.CodCia = s-codcia
                AND CcbTabla.Tabla = "N/D" 
                AND CcbTabla.Codigo = pCodCtaND
                NO-LOCK)
    THEN DO:
    MESSAGE 'NO configurado el concepto' pCodCtaND 'para la N/D' VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

IF NOT CAN-FIND(FIRST FacCorre WHERE FacCorre.CodCia = s-codcia AND
                FacCorre.CodDiv = s-coddiv AND
                FacCorre.CodDoc = 'PNC' AND
                FacCorre.FlgEst = YES NO-LOCK)
    THEN DO:
    MESSAGE 'NO hay ningún correlativo definido para la PNC' SKIP
        'en la división' s-coddiv VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

IF NOT CAN-FIND(FIRST FacCorre WHERE FacCorre.CodCia = s-codcia AND
                FacCorre.CodDiv = s-coddiv AND
                FacCorre.CodDoc = 'N/D' AND
                FacCorre.FlgEst = YES NO-LOCK)
    THEN DO:
    MESSAGE 'NO hay ningún correlativo definido para la N/D' SKIP
        'en la división' s-coddiv VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 FILL-IN_CodCli ~
COMBO-BOX_Father COMBO-BOX_NroSerNC COMBO-BOX_NroSerND BUTTON_Calcular ~
BUTTON_Generar 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_CodCli FILL-IN_NomCli ~
COMBO-BOX_Father SELECT_Sons COMBO-BOX_NroSerNC FILL-IN_CodCtaNC ~
FILL-IN_DescripcionNC COMBO-BOX_NroSerND FILL-IN_CodCtaND ~
FILL-IN_DescripcionND 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-nc-nd-dcto-vol-time-a AS HANDLE NO-UNDO.
DEFINE VARIABLE h_t-nc-nd-dcto-vol-time-c AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON_Borrar 
     LABEL "BORRAR DATOS" 
     SIZE 19 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON_Calcular 
     LABEL "PROCESAR" 
     SIZE 15 BY 1.12
     FONT 6.

DEFINE BUTTON BUTTON_Generar 
     LABEL "GENERAR PRENOTA DE CREDITO Y NOTA DE DEBITO" 
     SIZE 51 BY 1.12
     FONT 6.

DEFINE VARIABLE COMBO-BOX_Father AS INTEGER FORMAT "->,>>>,>>9":U INITIAL -1 
     LABEL "Seleccione División y Periodo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Seleccione",-1
     DROP-DOWN-LIST
     SIZE 59 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_NroSerNC AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Nro. de Serie PNC" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_NroSerND AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Nro. de Serie N/D" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodCli AS CHARACTER FORMAT "X(15)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodCtaNC AS CHARACTER FORMAT "X(256)":U 
     LABEL "Concepto" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_CodCtaND AS CHARACTER FORMAT "X(256)":U 
     LABEL "Concepto" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_DescripcionNC AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 71 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_DescripcionND AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 71 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_NomCli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 65 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 136 BY 7.81
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 136 BY 1.62
     BGCOLOR 15 FGCOLOR 0 .

DEFINE VARIABLE SELECT_Sons AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     LIST-ITEM-PAIRS "Seleccione","Seleccione" 
     SIZE 59 BY 2.42 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN_CodCli AT ROW 1.27 COL 29 COLON-ALIGNED WIDGET-ID 18
     FILL-IN_NomCli AT ROW 1.27 COL 44 COLON-ALIGNED NO-LABEL WIDGET-ID 40
     COMBO-BOX_Father AT ROW 2.08 COL 29 COLON-ALIGNED WIDGET-ID 2
     SELECT_Sons AT ROW 2.88 COL 31 NO-LABEL WIDGET-ID 12
     BUTTON_Borrar AT ROW 3.42 COL 95 WIDGET-ID 14
     COMBO-BOX_NroSerNC AT ROW 5.31 COL 29 COLON-ALIGNED WIDGET-ID 34
     FILL-IN_CodCtaNC AT ROW 6.12 COL 29 COLON-ALIGNED WIDGET-ID 28
     FILL-IN_DescripcionNC AT ROW 6.12 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     COMBO-BOX_NroSerND AT ROW 6.92 COL 29 COLON-ALIGNED WIDGET-ID 32
     FILL-IN_CodCtaND AT ROW 7.73 COL 29 COLON-ALIGNED WIDGET-ID 38
     FILL-IN_DescripcionND AT ROW 7.73 COL 39 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     BUTTON_Calcular AT ROW 9.08 COL 4 WIDGET-ID 20
     BUTTON_Generar AT ROW 9.08 COL 21 WIDGET-ID 22
     "Pack de Productos:" VIEW-AS TEXT
          SIZE 14 BY .54 AT ROW 3.15 COL 17 WIDGET-ID 16
     RECT-1 AT ROW 1 COL 2 WIDGET-ID 42
     RECT-2 AT ROW 8.81 COL 2 WIDGET-ID 44
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 139.29 BY 26.15
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: CREDITO B "?" ? INTEGRAL CcbCDocu
      TABLE: t-CcbCDocu T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: t-CcbDDocu T "?" NO-UNDO INTEGRAL CcbDDocu
      TABLE: T-CDOCU T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: T-DDOCU T "?" NO-UNDO INTEGRAL CcbDDocu
      TABLE: T-DPEDI T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: T-FELogErrores T "?" NO-UNDO INTEGRAL FELogErrores
      TABLE: T-VtamDctoVolTime T "?" NO-UNDO INTEGRAL VtamDctoVolTime
      TABLE: T-VtapDctoVolTime T "?" NO-UNDO INTEGRAL VtapDctoVolTime
      TABLE: TT-DDOCU T "?" NO-UNDO INTEGRAL CcbDDocu
      TABLE: ttCcbcdocu T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: ttCcbddocu T "?" NO-UNDO INTEGRAL CcbDDocu
      TABLE: txCcbCDocu T "?" NO-UNDO INTEGRAL CcbCDocu
      TABLE: txCcbDDocu T "?" NO-UNDO INTEGRAL CcbDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "GENERACION DE N/C O N/D POR DESCUENTOS POR VOL ACUM POR PERIODO"
         HEIGHT             = 26.15
         WIDTH              = 139.29
         MAX-HEIGHT         = 26.15
         MAX-WIDTH          = 191.29
         VIRTUAL-HEIGHT     = 26.15
         VIRTUAL-WIDTH      = 191.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON BUTTON_Borrar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodCtaNC IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_CodCtaND IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DescripcionNC IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DescripcionND IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NomCli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR SELECTION-LIST SELECT_Sons IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* GENERACION DE N/C O N/D POR DESCUENTOS POR VOL ACUM POR PERIODO */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* GENERACION DE N/C O N/D POR DESCUENTOS POR VOL ACUM POR PERIODO */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Borrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Borrar W-Win
ON CHOOSE OF BUTTON_Borrar IN FRAME F-Main /* BORRAR DATOS */
DO:
  DO WITH WITH FRAME {&FRAME-NAME}:
      FILL-IN_CodCli = ''.
      FILL-IN_NomCli = ''.

      COMBO-BOX_Father = -1.

      SELECT_Sons:DELETE(SELECT_Sons:LIST-ITEM-PAIRS).
      SELECT_Sons:ADD-LAST('Seleccione','Seleccione').
      SELECT_Sons = 'Seleccione'.

      DISPLAY FILL-IN_CodCli FILL-IN_NomCli COMBO-BOX_Father.

      ENABLE FILL-IN_CodCli BUTTON_Calcular COMBO-BOX_Father /*SELECT_Sons*/.

      DISABLE BUTTON_Borrar BUTTON_Generar.

      EMPTY TEMP-TABLE T-DPEDI.
      EMPTY TEMP-TABLE T-DDOCU.
      EMPTY TEMP-TABLE T-CDOCU.
      RUN Import-Table IN h_t-nc-nd-dcto-vol-time-a ( INPUT TABLE T-DPEDI).
      RUN Import-Table IN h_t-nc-nd-dcto-vol-time-c ( INPUT TABLE T-CDOCU).
      APPLY 'ENTRY':U TO FILL-IN_CodCli.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Calcular
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Calcular W-Win
ON CHOOSE OF BUTTON_Calcular IN FRAME F-Main /* PROCESAR */
DO:
  ASSIGN FILL-IN_CodCli COMBO-BOX_Father FILL-IN_CodCli SELECT_Sons.

  /* Validación */
  IF NOT CAN-FIND(FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
                  AND gn-clie.codcli = FILL-IN_CodCli NO-LOCK)
      THEN DO:
      MESSAGE 'Cliente NO registrado' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN_CodCli.
      RETURN NO-APPLY.
  END.
  /* SI pertenece a un grupo debe ser el PRINCIPAL */
  FIND FIRST pri_comclientgrp_d WHERE pri_comclientgrp_d.CodCli = FILL-IN_CodCli AND
      CAN-FIND(pri_comclientgrp_h WHERE pri_comclientgrp_h.IdGroup = pri_comclientgrp_d.IdGroup NO-LOCK)
      NO-LOCK NO-ERROR.
  IF AVAILABLE pri_comclientgrp_d AND pri_comclientgrp_d.Principal = NO THEN DO:
      MESSAGE 'Este cliente está asociado a un GRUPO COMERCIAL pero NO es el PRINCIPAL' SKIP
          'Favor de registrar el cliente PRINCIPAL de este grupo'
          VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO FILL-IN_CodCli.
      RETURN NO-APPLY.
  END.


  IF COMBO-BOX_Father = -1 THEN DO:
      MESSAGE 'Debe seleccionar una División y Periodo' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO COMBO-BOX_Father.
      RETURN NO-APPLY.
  END.
  IF SELECT_Sons BEGINS 'Selecc' THEN DO:
      MESSAGE 'Debe seleccionar un Pack de Productos' VIEW-AS ALERT-BOX ERROR.
      APPLY 'ENTRY':U TO SELECT_Sons.
      RETURN NO-APPLY.
  END.

  SESSION:SET-WAIT-STATE('GENERAL').
  RUN Carga-Real-Teorico.
  SESSION:SET-WAIT-STATE('').

  IF NOT CAN-FIND(FIRST T-DPEDI WHERE T-DPEDI.Libre_c01 = "*" NO-LOCK) THEN RETURN NO-APPLY.

  DISABLE FILL-IN_CodCli COMBO-BOX_Father SELECT_Sons BUTTON_Calcular WITH FRAME {&FRAME-NAME}.
  ENABLE BUTTON_Borrar BUTTON_Generar WITH FRAME {&FRAME-NAME}.
  MESSAGE 'Proceso Terminado' VIEW-AS ALERT-BOX INFORMATION.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON_Generar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON_Generar W-Win
ON CHOOSE OF BUTTON_Generar IN FRAME F-Main /* GENERAR PRENOTA DE CREDITO Y NOTA DE DEBITO */
DO:
  DEF VAR pMensaje AS CHAR NO-UNDO.
  DEF VAR pMsgSUnat AS CHAR NO-UNDO.

  RUN MASTER-TRANSACTION (OUTPUT pMensaje, OUTPUT pMsgSunat).
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      IF TRUE <> (pMensaje > '') THEN pMensaje = "Hubo problemas para generar las PNC y/o N/D".
      IF pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  IF pMsgSunat > '' THEN MESSAGE pMsgSunat VIEW-AS ALERT-BOX WARNING.

  DO WITH WITH FRAME {&FRAME-NAME}:
      ENABLE FILL-IN_CodCli BUTTON_Calcular COMBO-BOX_Father SELECT_Sons.
      DISABLE BUTTON_Borrar BUTTON_Generar.

      EMPTY TEMP-TABLE T-DPEDI.
      EMPTY TEMP-TABLE T-DDOCU.
      EMPTY TEMP-TABLE T-CDOCU.
      RUN Import-Table IN h_t-nc-nd-dcto-vol-time-a ( INPUT TABLE T-DPEDI).
      RUN Import-Table IN h_t-nc-nd-dcto-vol-time-c ( INPUT TABLE T-CDOCU).

      APPLY 'ENTRY':U TO FILL-IN_CodCli.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_Father
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_Father W-Win
ON VALUE-CHANGED OF COMBO-BOX_Father IN FRAME F-Main /* Seleccione División y Periodo */
DO:
  ASSIGN {&SELF-NAME}.
  DEF VAR x-Log AS LOG NO-UNDO.

  x-Log = SELECT_Sons:DELETE(SELECT_Sons:LIST-ITEM-PAIRS) NO-ERROR.
/*   x-Log = SELECT_Sons:ADD-LAST('Seleccione', 'Seleccione') NO-ERROR. */
/*   SELECT_Sons = "Seleccione".                                        */
  FOR EACH VtapDctoVolTime NO-LOCK WHERE VtapDctoVolTime.IdMaster = COMBO-BOX_Father:
      x-Log = SELECT_Sons:ADD-LAST(VtapDctoVolTime.Descrip, STRING(VtapDctoVolTime.IdPack)) NO-ERROR.
  END.
  DISPLAY SELECT_Sons WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodCli W-Win
ON LEAVE OF FILL-IN_CodCli IN FRAME F-Main /* Cliente */
DO:
  FILL-IN_NomCli:SCREEN-VALUE = ''.
  FIND gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN FILL-IN_NomCli:SCREEN-VALUE = gn-clie.nomcli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_CodCli W-Win
ON LEFT-MOUSE-DBLCLICK OF FILL-IN_CodCli IN FRAME F-Main /* Cliente */
OR F8 OF FILL-IN_CodCli DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN lkup/c-client ('Seleccione el Cliente').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-new/objects/folder.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'Procesado|Comprobantes' + ',
                     FOLDER-TAB-TYPE = 1':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 10.42 , 2.00 ) NO-ERROR.
       RUN set-size IN h_folder ( 16.42 , 136.00 ) NO-ERROR.

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             BUTTON_Generar:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/t-nc-nd-dcto-vol-time-a.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-nc-nd-dcto-vol-time-a ).
       RUN set-position IN h_t-nc-nd-dcto-vol-time-a ( 11.77 , 4.00 ) NO-ERROR.
       RUN set-size IN h_t-nc-nd-dcto-vol-time-a ( 14.54 , 120.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-nc-nd-dcto-vol-time-a ,
             h_folder , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/ccb/t-nc-nd-dcto-vol-time-c.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_t-nc-nd-dcto-vol-time-c ).
       RUN set-position IN h_t-nc-nd-dcto-vol-time-c ( 11.77 , 4.00 ) NO-ERROR.
       RUN set-size IN h_t-nc-nd-dcto-vol-time-c ( 14.54 , 111.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_t-nc-nd-dcto-vol-time-c ,
             h_folder , 'AFTER':U ).
    END. /* Page 2 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Real-Teorico W-Win 
PROCEDURE Carga-Real-Teorico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR hProc AS HANDLE NO-UNDO.

/* ************************************************************************** */
/* LOGICA PRINCIPAL */
/* ************************************************************************** */
RUN vtagn/ventas-library PERSISTENT SET hProc.
RUN DCTO_VOL_ACUM_TIME_GEN IN hProc (COMBO-BOX_Father,
                                     /*SELECT_Sons,*/
                                     FILL-IN_CodCli).

RUN DCTO_VOL_ACUM_TIME_GEN_Export IN hProc (OUTPUT TABLE T-DPEDI, OUTPUT TABLE T-CDOCU).
DELETE PROCEDURE hProc.

/* Limpiamos comprobantes ya procesados */
/* FOR EACH T-CDOCU, FIRST Ccbcdocu OF T-CDOCU WHERE Ccbcdocu.FlgCie = "C": */
/*     DELETE T-CDOCU.                                                      */
/* END.                                                                     */

EMPTY TEMP-TABLE T-DDOCU.
FOR EACH T-CDOCU NO-LOCK, EACH Ccbddocu OF T-CDOCU NO-LOCK:
    CREATE T-DDOCU.
    BUFFER-COPY Ccbddocu TO T-DDOCU.
END.

/* Calculamos Reales y Teóricos */
/* REAL */
FOR EACH T-DPEDI EXCLUSIVE-LOCK WHERE T-DPEDI.Libre_c01 = "*":
    ASSIGN
        T-DPEDI.cImporteTotalConImpuesto = 0
        T-DPEDI.ImpLin = 0.
    FOR EACH T-CDOCU NO-LOCK, EACH T-DDOCU OF T-CDOCU NO-LOCK WHERE T-DDOCU.codmat = T-DPEDI.codmat:
        ASSIGN
            T-DPEDI.cImporteTotalConImpuesto = T-DPEDI.cImporteTotalConImpuesto + 
            ((IF T-CDOCU.CodDoc = "N/C" THEN -1 ELSE 1) * (T-DDOCU.ImpLin + T-DDOCU.Dcto_Otros_PV)).    /* NO TOMAR EN CUENTA DESCUENTOS LOGISTICOS */
    END.
END.

/* TEORICO */
EMPTY TEMP-TABLE TT-DDOCU.
/* un espejo */
FOR EACH T-DDOCU:
    CREATE TT-DDOCU.
    BUFFER-COPY T-DDOCU TO TT-DDOCU.
END.
/* deducimos las N/C */
DEF BUFFER BT-CDOCU FOR T-CDOCU.
DEF BUFFER BT-DDOCU FOR T-DDOCU.

FOR EACH T-CDOCU NO-LOCK WHERE LOOKUP(T-CDOCU.CodDoc, 'FAC,BOL') > 0,
    FIRST BT-CDOCU WHERE BT-CDOCU.CodDoc = "N/C" AND 
        BT-CDOCU.codref = T-CDOCU.coddoc AND
        BT-CDOCU.nroref = T-CDOCU.nrodoc:
    FOR EACH TT-DDOCU OF T-CDOCU, FIRST BT-DDOCU OF BT-CDOCU WHERE BT-DDOCU.codmat = TT-DDOCU.codmat:
        TT-DDOCU.candes = TT-DDOCU.candes - BT-DDOCU.candes.    /* Quitamos la devolución por N/C */
        IF TT-DDOCU.candes <= 0 THEN DELETE TT-DDOCU.
    END.
END.
FOR EACH T-CDOCU NO-LOCK WHERE LOOKUP(T-CDOCU.CodDoc, 'FAC,BOL') > 0,
    EACH TT-DDOCU OF T-CDOCU,
    FIRST T-DPEDI WHERE T-DPEDI.codmat = TT-DDOCU.codmat AND T-DPEDI.libre_c01 = "*":
    /* Recalculamos nuevamente */
    ASSIGN
        TT-DDOCU.ImpDto2 = 0
        TT-DDOCU.Dcto_Otros_PV = 0
        TT-DDOCU.Por_Dsctos[1] = 0
        TT-DDOCU.Por_Dsctos[2] = 0
        TT-DDOCU.Por_Dsctos[3] = T-DPEDI.PorDto.
    {sunat/sunat-calculo-importes-sku.i &Cabecera="T-CDOCU" &Detalle="TT-DDOCU"}
END.
FOR EACH T-DPEDI EXCLUSIVE-LOCK WHERE T-DPEDI.Libre_c01 = "*":
    ASSIGN T-DPEDI.ImpLin = 0.
    FOR EACH T-CDOCU NO-LOCK WHERE LOOKUP(T-CDOCU.CodDoc, 'FAC,BOL') > 0, 
        EACH TT-DDOCU OF T-CDOCU NO-LOCK WHERE TT-DDOCU.codmat = T-DPEDI.codmat:
        ASSIGN
            T-DPEDI.ImpLin = T-DPEDI.ImpLin +  TT-DDOCU.ImpLin.
    END.
END.
/* DOCUMENTO */
FOR EACH T-DPEDI EXCLUSIVE-LOCK WHERE T-DPEDI.Libre_c01 = "*":
    IF T-DPEDI.cImporteTotalConImpuesto > T-DPEDI.ImpLin THEN T-DPEDI.CodDoc = "PNC".
    IF T-DPEDI.cImporteTotalConImpuesto < T-DPEDI.ImpLin THEN T-DPEDI.CodDoc = "N/D".
    IF T-DPEDI.cImporteTotalConImpuesto = T-DPEDI.ImpLin THEN T-DPEDI.Libre_c01 = "".   /* NO VA */
END.

RUN select-page('2').
RUN Import-Table IN h_t-nc-nd-dcto-vol-time-c ( INPUT TABLE T-CDOCU).
RUN select-page('1').
RUN Import-Table IN h_t-nc-nd-dcto-vol-time-a ( INPUT TABLE T-DPEDI).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-General W-Win 
PROCEDURE Carga-Temporal-General :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pCodDoc AS CHAR.    /* PNC o N/D */

/* Limpiamos tablas receptoras */
EMPTY TEMP-TABLE txCcbcdocu.
EMPTY TEMP-TABLE txCcbddocu.

/* ******************************************************************************************* */
/* Por cada comprobante repartimos los artículos */
/* Comprobante de mayor importe al de menor importe */
/* ******************************************************************************************* */
DEF VAR x-CanDes AS DECI NO-UNDO.

FOR EACH T-DPEDI WHERE T-DPEDI.CodDoc = pCodDoc AND T-DPEDI.Libre_c01 = "*":      /* OJO */
    x-CanDes = T-DPEDI.CanPed.      /* Cantidad Acumulada a repartir */
    FOR EACH T-CDOCU WHERE LOOKUP(T-CDOCU.CodDoc, 'FAC,BOL') > 0,
        FIRST TT-DDOCU OF T-CDOCU WHERE TT-DDOCU.CodMat = T-DPEDI.CodMat,
        FIRST Almmmatg OF TT-DDOCU NO-LOCK
        BY T-CDOCU.ImpTot DESC:
        CREATE txCcbddocu.
        BUFFER-COPY TT-DDOCU TO txCcbddocu
            ASSIGN 
            txCcbddocu.CanDes = MINIMUM(x-CanDes, (TT-DDOCU.CanDes * TT-DDOCU.Factor))
            txCcbddocu.Factor = 1
            txCcbddocu.UndVta = Almmmatg.undstk
            .
        /* Importe de la PNC: aplicamos factor por cantidades */
        ASSIGN
            /*txCcbddocu.impdto = txCcbddocu.CanDes / (TT-DDOCU.CanDes * TT-DDOCU.Factor) * ABS(T-DPEDI.cImporteTotalConImpuesto - T-DPEDI.ImpLin).*/
            txCcbddocu.impdto = txCcbddocu.CanDes / T-DPEDI.CanPed * ABS(T-DPEDI.cImporteTotalConImpuesto - T-DPEDI.ImpLin).
        IF NOT CAN-FIND(FIRST txCcbcdocu OF T-CDOCU NO-LOCK) THEN DO:
            CREATE txCcbcdocu.
            BUFFER-COPY T-CDOCU TO txCcbcdocu.
        END.
        x-CanDes = x-CanDes - txCcbddocu.CanDes.
        IF x-CanDes <= 0 THEN LEAVE.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-NC W-Win 
PROCEDURE Carga-Temporal-NC :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Limpiamos tablas receptoras */
EMPTY TEMP-TABLE txCcbcdocu.
EMPTY TEMP-TABLE txCcbddocu.

/* ******************************************************************************************* */
/* Por cada comprobante repartimos los artículos */
/* Comprobante de mayor importe al de menor importe */
/* ******************************************************************************************* */
DEF VAR x-CanDes AS DECI NO-UNDO.

FOR EACH T-DPEDI WHERE T-DPEDI.CodDoc = "PNC" AND T-DPEDI.Libre_c01 = "*":      /* OJO */
    x-CanDes = T-DPEDI.CanPed.      /* Cantidad Acumulada a repartir */
    FOR EACH T-CDOCU WHERE LOOKUP(T-CDOCU.CodDoc, 'FAC,BOL') > 0,
        FIRST TT-DDOCU OF T-CDOCU WHERE TT-DDOCU.CodMat = T-DPEDI.CodMat,
        FIRST Almmmatg OF TT-DDOCU NO-LOCK
        BY T-CDOCU.ImpTot DESC:
        CREATE txCcbddocu.
        BUFFER-COPY TT-DDOCU TO txCcbddocu
            ASSIGN 
            txCcbddocu.CanDes = MINIMUM(x-CanDes, (TT-DDOCU.CanDes * TT-DDOCU.Factor))
            txCcbddocu.Factor = 1
            txCcbddocu.UndVta = Almmmatg.undstk
            .
        /* Importe de la PNC: aplicamos factor por cantidades */
        ASSIGN
            txCcbddocu.impdto = txCcbddocu.CanDes / T-DPEDI.CanPed * ABS(T-DPEDI.cImporteTotalConImpuesto - T-DPEDI.ImpLin).
        IF NOT CAN-FIND(FIRST txCcbcdocu OF T-CDOCU NO-LOCK) THEN DO:
            CREATE txCcbcdocu.
            BUFFER-COPY T-CDOCU TO txCcbcdocu.
        END.
        x-CanDes = x-CanDes - txCcbddocu.CanDes.
        IF x-CanDes <= 0 THEN LEAVE.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal-ND W-Win 
PROCEDURE Carga-Temporal-ND :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Limpiamos tablas receptoras */
EMPTY TEMP-TABLE txCcbcdocu.
EMPTY TEMP-TABLE txCcbddocu.

/* ******************************************************************************************* */
/* Por cada comprobante repartimos los artículos */
/* Comprobante de mayor importe al de menor importe */
/* ******************************************************************************************* */
DEF VAR x-CanDes AS DECI NO-UNDO.

FOR EACH T-DPEDI WHERE T-DPEDI.CodDoc = "N/D" AND T-DPEDI.Libre_c01 = "*":      /* OJO */
    x-CanDes = T-DPEDI.CanPed.      /* Cantidad Acumulada a repartir */
    FOR EACH T-CDOCU WHERE LOOKUP(T-CDOCU.CodDoc, 'FAC,BOL') > 0,
        FIRST TT-DDOCU OF T-CDOCU WHERE TT-DDOCU.CodMat = T-DPEDI.CodMat,
        FIRST Almmmatg OF TT-DDOCU NO-LOCK
        BY T-CDOCU.ImpTot DESC:
        CREATE txCcbddocu.
        BUFFER-COPY TT-DDOCU TO txCcbddocu
            ASSIGN 
            txCcbddocu.CanDes = MINIMUM(x-CanDes, (TT-DDOCU.CanDes * TT-DDOCU.Factor))
            txCcbddocu.Factor = 1
            txCcbddocu.UndVta = Almmmatg.undstk
            .
        /* Importe de la PNC: aplicamos factor por cantidades */
        ASSIGN
            txCcbddocu.impdto = txCcbddocu.CanDes / (TT-DDOCU.CanDes * TT-DDOCU.Factor) * ABS(T-DPEDI.cImporteTotalConImpuesto - T-DPEDI.ImpLin).
        IF NOT CAN-FIND(FIRST txCcbcdocu OF T-CDOCU NO-LOCK) THEN DO:
            CREATE txCcbcdocu.
            BUFFER-COPY T-CDOCU TO txCcbcdocu.
        END.
        x-CanDes = x-CanDes - txCcbddocu.CanDes.
        IF x-CanDes <= 0 THEN LEAVE.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierra-Comprobante-Origen W-Win 
PROCEDURE Cierra-Comprobante-Origen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Actualizamos el estado de todas las facturas relacionadas */
    FOR EACH T-CDOCU NO-LOCK:
        FIND FIRST Ccbcdocu OF T-CDOCU EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
        IF ERROR-STATUS:ERROR = YES THEN DO:
            pMensaje = "ERROR al actualizar el comprobante " + T-CDOCU.coddoc + " " + T-CDOCU.nrodoc + " (" + ERROR-STATUS:GET-MESSAGE(1) + ")".
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            CcbCDocu.FchCie = TODAY
            CcbCDocu.FlgCie = "C".      /* OJO */
/*         FOR EACH CREDITO WHERE CREDITO.codcia = s-codcia                   */
/*             AND CREDITO.coddoc = "N/C"                                     */
/*             AND CREDITO.codref = Ccbcdocu.coddoc                           */
/*             AND CREDITO.nroref = Ccbcdocu.nrodoc                           */
/*             AND CREDITO.CndCre = "D"                                       */
/*             AND CREDITO.flgest <> "A"                                      */
/*             AND CREDITO.flgcie <> "C" EXCLUSIVE-LOCK ON ERROR UNDO, THROW: */
/*             ASSIGN                                                         */
/*                 CREDITO.FchCie = TODAY                                     */
/*                 CREDITO.FlgCie = "C".      /* OJO */                       */
/*         END.                                                               */
        RELEASE Ccbcdocu.
        IF AVAILABLE(CREDITO)  THEN RELEASE CREDITO.
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN_CodCli FILL-IN_NomCli COMBO-BOX_Father SELECT_Sons 
          COMBO-BOX_NroSerNC FILL-IN_CodCtaNC FILL-IN_DescripcionNC 
          COMBO-BOX_NroSerND FILL-IN_CodCtaND FILL-IN_DescripcionND 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 FILL-IN_CodCli COMBO-BOX_Father COMBO-BOX_NroSerNC 
         COMBO-BOX_NroSerND BUTTON_Calcular BUTTON_Generar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FIRST-TRANSACTION W-Win 
PROCEDURE FIRST-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER x-CodDoc AS CHAR.       /* PNC N/D */
DEF INPUT PARAMETER pNroSer AS INTE.
DEF INPUT PARAMETER pCodCta AS CHAR.    
DEF INPUT PARAMETER pCodRef AS CHAR.        /* FAC */
DEF INPUT PARAMETER pNroRef AS CHAR.

DEF OUTPUT PARAMETER pNroDoc AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VAR x-Serie  AS INT NO-UNDO.
DEFINE VAR x-Numero AS INT NO-UNDO.
DEFINE VAR x-NroDoc AS CHAR NO-UNDO.
DEFINE VAR x-Item   AS INTE NO-UNDO.
DEFINE VAR x-ImpBrt AS DECI NO-UNDO.
DEFINE VAR x-ImpExo AS DECI NO-UNDO.
DEFINE VAR x-ImpIgv AS DECI NO-UNDO.
DEFINE VAR x-ImpTot AS DECI NO-UNDO.

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-ccbddocu FOR ccbddocu.
DEFINE BUFFER CREDITO FOR ccbcdocu.

GRABAR_DOCUMENTO:
DO TRANSACTION ON ERROR UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO ON STOP UNDO GRABAR_DOCUMENTO, LEAVE GRABAR_DOCUMENTO:
    /* Nos posicionamos en la FAC */
    FIND FIRST Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia AND
        Ccbcdocu.coddoc = pCodRef AND
        Ccbcdocu.nrodoc = pNroRef NO-LOCK.
    /* El número de serie */ 
    FIND FIRST Faccorre WHERE  Faccorre.CodCia = S-CODCIA 
        AND Faccorre.CodDoc = x-CodDoc
        AND Faccorre.CodDiv = S-CODDIV 
        AND Faccorre.NroSer = pNroSer
        AND Faccorre.FlgEst = YES EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = "ERROR en el correlativo del documento " + x-CodDoc + " (" + ERROR-STATUS:GET-MESSAGE(1) + ")".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    x-Serie = FacCorre.nroser.
    x-Numero = Faccorre.correlativo.
    Faccorre.correlativo = Faccorre.correlativo + 1.
    /* Ultimos ajustes a los temporales */
    x-NroDoc = STRING(x-Serie,"999") + STRING(x-Numero,"99999999").
    CREATE ttCcbcdocu.
    BUFFER-COPY Ccbcdocu TO ttCcbcdocu
    ASSIGN 
        ttCcbcdocu.CodCia = s-codcia
        ttCcbcdocu.coddiv = s-coddiv
        ttCcbcdocu.coddoc = x-coddoc
        ttccbcdocu.nrodoc = x-NroDoc
        ttccbcdocu.cndcre = "N"
        ttccbcdocu.tpofac = "OTROS"
        ttccbcdocu.codcta = pCodCta
        ttccbcdocu.codref = pCodRef
        ttccbcdocu.nroref = pNroRef
        ttCcbcdocu.divori = ccbcdocu.divori
        ttccbcdocu.porigv = Ccbcdocu.porigv
        ttccbcdocu.codmon = 1       /* OJO: Siempre em soles Ccbcdocu.codmon */
        ttCcbcdocu.fchdoc = TODAY
        ttCcbcdocu.fchvto = ADD-INTERVAL (TODAY, 1, 'years')
        ttCcbcdocu.usuario = s-user-id
        ttCcbcdocu.FlgEst = 'T'   /* POR APROBAR */
        ttCcbcdocu.ImpBrt = 0
        ttCcbcdocu.ImpExo = 0
        ttCcbcdocu.ImpDto = 0
        ttCcbcdocu.ImpIgv = 0
        ttCcbcdocu.ImpTot = 0
        ttCcbcdocu.horcie = STRING(TIME,"HH:MM:SS")
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = "ERROR - Ccbcdocu :(" + ERROR-STATUS:GET-MESSAGE(1) + ")".
        UNDO GRABAR_DOCUMENTO, RETURN 'ADM-ERROR'.
    END.
    IF x-CodDoc = "N/D" THEN ttCcbcdocu.FlgEst = 'P'.       /* PENDIENTE */

    ASSIGN
        pNroDoc = ttccbcdocu.nrodoc.    /* # de Control */
    /* *************************************************************************** */
    /* Cargamos los items */
    /* *************************************************************************** */
    x-Item = 0.
    x-ImpBrt = 0.
    x-ImpExo = 0.
    x-ImpIgv = 0.
    x-ImpTot = 0.
    DEF VAR tImpIgv AS DECI NO-UNDO.
    EMPTY TEMP-TABLE ttCcbddocu.
    FOR EACH txCcbddocu OF txCcbcdocu:
        x-item = x-item + 1.
        tImpIgv = ROUND(ABS(txCcbddocu.impdto) / (1 + ttCcbcdocu.PorIgv) * ttCcbcdocu.PorIgv, 4).
        CREATE ttCcbddocu.
        ASSIGN
            ttCcbddocu.codcia = s-codcia
            ttCcbddocu.coddiv = s-coddiv
            ttCcbddocu.coddoc = x-coddoc
            ttCcbddocu.nrodoc = x-NroDoc 
            ttCcbddocu.nroitm = x-item
            ttCcbddocu.codcli = ttCcbcdocu.codcli
            ttCcbddocu.codmat = txCcbddocu.codmat
            ttCcbddocu.aftigv = txCcbddocu.aftigv
            ttCcbddocu.candes = txCcbddocu.candes
            ttCcbddocu.preuni = ABS(txCcbddocu.impdto) / txCcbddocu.candes
            ttCcbddocu.implin = ABS(txCcbddocu.impdto)
            ttCcbddocu.undvta = txCcbddocu.undvta
            ttCcbddocu.factor = txCcbddocu.factor
            ttCcbddocu.impigv = (IF txCcbddocu.AftIgv THEN tImpIgv ELSE 0)
            .
        IF txCcbddocu.AftIgv = YES THEN x-ImpBrt = x-ImpBrt + ttCcbddocu.implin.
        IF txCcbddocu.AftIgv = NO THEN x-ImpExo = x-ImpExo + ttCcbddocu.implin.
        x-ImpIgv = x-ImpIgv + ttCcbddocu.ImpIgv.
        x-ImpTot = x-ImpTot + ttCcbddocu.ImpLin.
    END.
    ASSIGN  
        ttCcbcdocu.ImpBrt = x-impbrt
        ttCcbcdocu.ImpExo = x-impexo
        ttCcbcdocu.ImpIgv = x-ImpIgv
        ttCcbcdocu.ImpTot = x-ImpTot
        ttCcbcdocu.ImpVta = ttCcbcdocu.ImpBrt - ttCcbcdocu.ImpIgv
        ttCcbcdocu.ImpBrt = ttCcbcdocu.ImpBrt - ttCcbcdocu.ImpIgv
        ttCcbcdocu.SdoAct = ttCcbcdocu.ImpTot.
    IF NOT CAN-FIND(FIRST ttCcbddocu NO-LOCK) THEN DO:
        pMensaje = 'NO hay items'.
        RETURN 'ADM-ERROR'.
    END.
    ttCcbcdocu.Libre_c01 = "".
    FOR EACH ttCcbddocu OF ttCcbcdocu NO-LOCK, FIRST Almmmatg OF ttCcbddocu NO-LOCK
        BREAK BY Almmmatg.codfam:
        IF FIRST-OF(Almmmatg.codfam) THEN
            ttCcbcdocu.Libre_c01 = ttCcbcdocu.Libre_c01 + 
            (IF TRUE <> (ttCcbcdocu.Libre_c01 > "") THEN "" ELSE ",") + 
            TRIM(almmmatg.codfam).
    END.
    /* *************************************************************************** */
    /* La cabecera del documento */
    /* *************************************************************************** */
    CREATE b-ccbcdocu.
    BUFFER-COPY ttCcbcdocu TO b-ccbcdocu NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "ERROR al crear registro en CCBCDOCU (" + ERROR-STATUS:GET-MESSAGE(1) + ")".
        UNDO GRABAR_DOCUMENTO, RETURN 'ADM-ERROR'.
    END.
    FOR EACH ttCcbddocu ON ERROR UNDO, THROW:
        /* Detalle update block */
        CREATE b-ccbddocu.
        BUFFER-COPY ttCcbddocu TO b-ccbddocu NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "ERROR al crear registro en CCBDDOCU (" + ERROR-STATUS:GET-MESSAGE(1) + ")".
            UNDO GRABAR_DOCUMENTO, RETURN 'ADM-ERROR'.
        END.
    END.
    {vtagn/i-total-factura-sunat.i &Cabecera="b-Ccbcdocu" &Detalle="b-Ccbddocu"}
    /* ****************************** */
    /* Ic - 16Nov2021 - Importes Aritmética de SUNAT */
    /* ****************************** */
    IF x-CodDoc = "N/D" THEN DO:
      &IF {&ARITMETICA-SUNAT} &THEN
          DEF VAR hProc AS HANDLE NO-UNDO.
          RUN sunat/sunat-calculo-importes.r PERSISTENT SET hProc.
          RUN tabla-ccbcdocu IN hProc (INPUT b-Ccbcdocu.CodDiv,
                                       INPUT b-Ccbcdocu.CodDoc,
                                       INPUT b-Ccbcdocu.NroDoc,
                                       OUTPUT pMensaje).
          DELETE PROCEDURE hProc.
          IF RETURN-VALUE = "ADM-ERROR" THEN UNDO GRABAR_DOCUMENTO, RETURN 'ADM-ERROR'. 
      &ENDIF
    END.
END. /* TRANSACTION block */
IF AVAILABLE FacCorre THEN RELEASE faccorre.
IF AVAILABLE b-ccbcdocu THEN RELEASE b-ccbcdocu.
IF AVAILABLE b-ccbddocu THEN RELEASE b-ccbddocu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-NC-MASTER W-Win 
PROCEDURE Genera-NC-MASTER :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* Varias formas de generar N/C */
/* Depende de cuantos clientes están involucrados */
DEF VAR pNroDoc AS CHAR NO-UNDO.

/* ******************************************************************************************* */
/* Limpiamos tablas receptoras: txCcbcdocu txCcbddocu */
/* ******************************************************************************************* */
/*RUN Carga-Temporal-NC.*/
RUN Carga-Temporal-General ("PNC").
IF NOT CAN-FIND(FIRST txCcbcdocu) THEN RETURN 'OK'.
/* ******************************************************************************************* */
/* Una vez terminado el proceso anterior debe quedar una o más comprobantes referenciados */
/* ******************************************************************************************* */
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH txCcbcdocu:
        RUN FIRST-TRANSACTION (INPUT "PNC",
                               INPUT COMBO-BOX_NroSerNC,
                               INPUT FILL-IN_CodCtaNC,
                               INPUT txCcbcdocu.CodDoc,     /* FAC */
                               INPUT txCcbcdocu.NroDoc,
                               OUTPUT pNroDoc,
                               OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = 'No se pudo generar la PNC'.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
    END.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-ND-MASTER W-Win 
PROCEDURE Genera-ND-MASTER :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* Varias formas de generar N/C */
/* Depende de cuantos clientes están involucrados */
DEF VAR pNroDoc AS CHAR NO-UNDO.

/* ******************************************************************************************* */
/* Limpiamos tablas receptoras: txCcbcdocu txCcbddocu */
/* ******************************************************************************************* */
/*RUN Carga-Temporal-ND.*/
RUN Carga-Temporal-General ("N/D").
IF NOT CAN-FIND(FIRST txCcbcdocu) THEN RETURN 'OK'.
/* ******************************************************************************************* */
/* Una vez terminado el proceso anterior debe quedar una o más comprobantes referenciados */
/* ******************************************************************************************* */
PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH txCcbcdocu:
        RUN FIRST-TRANSACTION (INPUT "N/D",
                               INPUT COMBO-BOX_NroSerND,
                               INPUT FILL-IN_CodCtaND,
                               INPUT txCcbcdocu.CodDoc,     /* FAC */
                               INPUT txCcbcdocu.NroDoc,
                               OUTPUT pNroDoc,
                               OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = 'No se pudo generar la N/D'.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
    END.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-PNC-ND W-Win 
PROCEDURE Genera-PNC-ND :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF NOT CAN-FIND(FIRST T-DPEDI NO-LOCK) THEN RETURN "OK".



RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Temp-FeLogErrores W-Win 
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
RELEASE FeLogErrores.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      COMBO-BOX_NroSerNC:DELETE(1).
      FOR EACH FacCorre NO-LOCK WHERE FacCorre.CodCia = s-codcia AND
          FacCorre.CodDiv = s-coddiv AND
          FacCorre.CodDoc = "PNC" AND
          FacCorre.FlgEst = YES
          BY FacCorre.NroSer DESC:
          COMBO-BOX_NroSerNC:ADD-LAST(STRING(FacCorre.NroSer,'999')).
          COMBO-BOX_NroSerNC = FacCorre.NroSer.
      END.
      COMBO-BOX_NroSerND:DELETE(1).
      FOR EACH FacCorre NO-LOCK WHERE FacCorre.CodCia = s-codcia AND
          FacCorre.CodDiv = s-coddiv AND
          FacCorre.CodDoc = "N/D" AND
          FacCorre.FlgEst = YES
          BY FacCorre.NroSer DESC:
          COMBO-BOX_NroSerND:ADD-LAST(STRING(FacCorre.NroSer,'999')).
          COMBO-BOX_NroSerND = FacCorre.NroSer.
      END.
      COMBO-BOX_NroSerNC:LABEL = "Nro. de Serie PNC".
      FILL-IN_CodCtaNC = pCodCtaNC.
      FIND FIRST CcbTabla WHERE CcbTabla.CodCia = s-codcia
          AND CcbTabla.Tabla = "N/C" 
          AND CcbTabla.Codigo = pCodCtaNC
          NO-LOCK NO-ERROR.
      IF AVAILABLE CcbTabla THEN FILL-IN_DescripcionNC = CcbTabla.Nombre.
      COMBO-BOX_NroSerND:LABEL = "Nro. de Serie N/D".
      FILL-IN_CodCtaND = pCodCtaND.
      FIND FIRST CcbTabla WHERE CcbTabla.CodCia = s-codcia
          AND CcbTabla.Tabla = "N/D" 
          AND CcbTabla.Codigo = pCodCtaND
          NO-LOCK NO-ERROR.
      IF AVAILABLE CcbTabla THEN FILL-IN_DescripcionND = CcbTabla.Nombre.
  END.
  DO WITH FRAME {&FRAME-NAME}:
      FOR EACH VtamDctoVolTime NO-LOCK WHERE VtamDctoVolTime.FlgEst = "Activo",
          FIRST gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia AND
          gn-divi.coddiv = VtamDctoVolTime.CodDiv:
          COMBO-BOX_Father:ADD-LAST(VtamDctoVolTime.CodDiv + " - " +
                                    GN-DIVI.DesDiv + " >>>>> " + 
                                    "Inicio: " + STRING(VtamDctoVolTime.FchIni, '99/99/9999') + " " +
                                    "Fin: " + STRING(VtamDctoVolTime.FchFin, '99/99/9999'),
                                    VtamDctoVolTime.IdMaster).
          
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MASTER-TRANSACTION W-Win 
PROCEDURE MASTER-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pMsgSunat AS CHAR NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    EMPTY TEMP-TABLE ttCcbcdocu.    /* Archivo de control */
    EMPTY TEMP-TABLE ttCcbddocu.

    RUN Cierra-Comprobante-Origen (OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    
    IF COMBO-BOX_NroSerNC >= 0 THEN DO:
        RUN Genera-NC-MASTER (OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.

    IF COMBO-BOX_NroSerND > 0 THEN DO:
        RUN Genera-ND-MASTER (OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    END.

END.

EMPTY TEMP-TABLE T-FELogErrores.
FOR EACH ttCcbcdocu WHERE ttCcbcdocu.CodDoc = "N/D":
    RUN SECOND-TRANSACTION (INPUT ttCcbcdocu.CodDoc,
                            INPUT ttCcbcdocu.NroDoc,
                            OUTPUT pMensaje,
                            OUTPUT pMsgSunat).
    IF RETURN-VALUE = 'ADM-ERROR' AND pMensaje > '' THEN MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    IF RETURN-VALUE = 'ERROR-EPOS' AND pMsgSunat > '' THEN MESSAGE pMsgSunat VIEW-AS ALERT-BOX WARNING.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SECOND-TRANSACTION W-Win 
PROCEDURE SECOND-TRANSACTION :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER x-CodDoc AS CHAR.                                    
    DEFINE INPUT PARAMETER x-NroDoc AS CHAR.
    DEFINE OUTPUT PARAMETER pMensaje  AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER pMsgSunat AS CHAR NO-UNDO.
    
    {lib/lock-genericov3.i  ~
        &Tabla="Ccbcdocu" ~
        &Condicion="Ccbcdocu.codcia = s-codcia AND Ccbcdocu.coddoc = x-coddoc AND Ccbcdocu.nrodoc = x-nrodoc" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR NO-WAIT" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}

    EMPTY TEMP-TABLE T-FeLogErrores.

    RUN sunat\progress-to-ppll-v3 ( INPUT s-coddiv,
                                    INPUT x-coddoc,
                                    INPUT x-nrodoc,
                                    INPUT-OUTPUT TABLE T-FELogErrores,
                                    OUTPUT pMensaje ).

    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.
    IF RETURN-VALUE = "ERROR-EPOS" THEN DO:
        ASSIGN
            Ccbcdocu.FlgEst = "A"
            CcbCDocu.UsuAnu = s-user-id
            CcbCDocu.FchAnu = TODAY.
        pMsgSunat = "Hubo problemas en la generación del documento " + x-CodDoc + " " + x-NroDoc + CHR(10) +
                    "Mensaje : " + pMensaje + CHR(10) +
                    "El documento a sido ANULADO".
    END.
    RELEASE Ccbcdocu.

    RUN Graba-Temp-FeLogErrores.    /* Control de Errores (si es que hay) */

    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
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

