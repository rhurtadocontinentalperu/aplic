&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
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

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.


DEFINE STREAM report.

DEFINE NEW SHARED VARIABLE xTerm     AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id  LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.

  
def var l-immediate-display  AS LOGICAL.
DEFINE        VARIABLE PTO        AS LOGICAL.

DEFINE VARIABLE T-CLIEN AS CHAR INIT "" NO-UNDO.
DEFINE VARIABLE T-VENDE  AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR CB-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV AS CHAR.
DEFINE SHARED VAR S-NOMCIA AS CHAR.
DEFINE SHARED VAR S-CODALM AS CHAR.

DEFINE VARIABLE dDateD AS DATE NO-UNDO.
DEFINE VARIABLE dDateH AS DATE NO-UNDO.

DEFINE TEMP-TABLE tmp-tempo 
    FIELD t-codpro  LIKE Almmmatg.Codpr1
    FIELD t-nompro  LIKE Gn-Prov.Nompro 
    FIELD t-codalm  LIKE FacCpedi.Codalm
    FIELD t-codcli  LIKE FacCpedi.Codcli
    FIELD t-nomcli  LIKE FacCpedi.Nomcli
    FIELD t-codmat  LIKE FacDpedi.codmat
    FIELD t-desmat  LIKE Almmmatg.DesMat    FORMAT "X(40)"
    FIELD t-desmar  LIKE Almmmatg.DesMar    FORMAT "X(8)"
    FIELD t-undbas  LIKE Almmmatg.UndBas    FORMAT "X(8)"
    FIELD t-glosa   AS CHAR          FORMAT "X(30)"
    FIELD t-stkact  LIKE Almmmate.StkAct    FORMAT "->>>>>,>>9.99"
    FIELD t-compro  AS DEC           FORMAT "->>>>,>>9.99"
    FIELD t-solici  AS DEC           FORMAT "->>>>,>>9.99"
    FIELD t-atendi  AS DEC           FORMAT "->>>>,>>9.99"
    FIELD t-pendie  AS DEC           FORMAT "->>>>,>>9.99"
    FIELD t-totsol  AS DEC           FORMAT "->>>>,>>9.99"
    FIELD t-totdol  AS DEC           FORMAT "->>>>,>>9.99"
    INDEX Llave01 AS PRIMARY t-CodMat
    INDEX Llave02 t-CodCli t-CodMat
    INDEX Llave03 t-DesMar
    Index Llave04 t-CodPro.

DEF BUFFER B-FacCPedi FOR FacCPedi.

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
&Scoped-Define ENABLED-OBJECTS RECT-41 RECT-43 f-clien R-Tipo FILL-IN-Marca ~
f-desde f-hasta FILL-IN-FchPed-1 FILL-IN-FchPed-2 Btn_OK Btn_Cancel ~
Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-3 f-clien f-nomcli R-Tipo ~
FILL-IN-Marca f-desde f-hasta FILL-IN-FchPed-1 FILL-IN-FchPed-2 txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "A&yuda" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 12 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE f-clien AS CHARACTER FORMAT "X(11)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Cotizaciones Emitidas Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE f-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 28.29 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     LABEL "División" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-1 AS DATE FORMAT "99/99/9999":U 
     LABEL "Con Pedidos Emitidos Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-FchPed-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Marca AS CHARACTER FORMAT "X(256)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 66 BY .81
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE R-Tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cliente", 1,
"Resumen Proveedor", 2,
"Resumen por Marca", 3
     SIZE 42 BY .77 NO-UNDO.

DEFINE RECTANGLE RECT-41
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 9.58.

DEFINE RECTANGLE RECT-43
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 68 BY 1.62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-3 AT ROW 1.54 COL 4.86 WIDGET-ID 18
     f-clien AT ROW 2.62 COL 9 COLON-ALIGNED WIDGET-ID 10
     f-nomcli AT ROW 2.62 COL 21.57 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     R-Tipo AT ROW 3.69 COL 11 NO-LABEL WIDGET-ID 26
     FILL-IN-Marca AT ROW 4.77 COL 19 COLON-ALIGNED WIDGET-ID 24
     f-desde AT ROW 6.38 COL 30 COLON-ALIGNED WIDGET-ID 12
     f-hasta AT ROW 6.38 COL 48 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-FchPed-1 AT ROW 7.62 COL 30.14 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-FchPed-2 AT ROW 7.62 COL 48 COLON-ALIGNED WIDGET-ID 22
     txt-msj AT ROW 9.62 COL 2.86 NO-LABEL WIDGET-ID 2
     Btn_OK AT ROW 10.81 COL 33 WIDGET-ID 8
     Btn_Cancel AT ROW 10.81 COL 45 WIDGET-ID 4
     Btn_Help AT ROW 10.81 COL 57 WIDGET-ID 6
     RECT-41 AT ROW 1.12 COL 1.72 WIDGET-ID 30
     RECT-43 AT ROW 10.69 COL 1.86 WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 70.14 BY 11.54
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Cotizaciones por atender oficina"
         HEIGHT             = 11.54
         WIDTH              = 70.14
         MAX-HEIGHT         = 11.54
         MAX-WIDTH          = 70.14
         VIRTUAL-HEIGHT     = 11.54
         VIRTUAL-WIDTH      = 70.14
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
{src/bin/_prns.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN f-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       txt-msj:HIDDEN IN FRAME F-Main           = TRUE
       txt-msj:READ-ONLY IN FRAME F-Main        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Cotizaciones por atender oficina */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Cotizaciones por atender oficina */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel W-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  RUN dispatch IN THIS-PROCEDURE ('exit':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help W-Win
ON CHOOSE OF Btn_Help IN FRAME F-Main /* Ayuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
MESSAGE "Help for File: {&FILE-NAME}":U VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  ASSIGN f-Desde f-hasta f-clien R-tipo FILL-IN-Marca FILL-IN-FchPed-1 FILL-IN-FchPed-2.

  IF f-desde = ? then do:
     MESSAGE "Ingrese Fecha Desde ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.   
  END.
   
  IF f-hasta = ? then do:
     MESSAGE "Ingrese Fecha Hasta ... " VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-hasta.
     RETURN NO-APPLY.   
  END.   

  IF f-desde > f-hasta then do:
     MESSAGE "Rango de fechas Mal ingresado" VIEW-AS ALERT-BOX.
     APPLY "ENTRY":U to f-desde.
     RETURN NO-APPLY.
  END.
 
  RUN Imprime.
  DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-clien
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-clien W-Win
ON LEAVE OF f-clien IN FRAME F-Main /* Cliente */
DO:
  F-clien = "".
  IF F-clien:SCREEN-VALUE <> "" THEN DO: 
     FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA AND 
          gn-clie.Codcli = F-clien:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-clie THEN F-Nomcli = gn-clie.Nomcli.
  END.
  DISPLAY F-NomCli WITH FRAME {&FRAME-NAME}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal W-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 
 DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
 DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.  
 DEFINE VAR x-StkCom    AS DECIMAL INIT 0.

  FOR EACH TMP-TEMPO:
    DELETE tmp-tempo.
  END.

  DISPLAY "Cargando Informacion...." @ txt-msj WITH FRAME {&FRAME-NAME}.

  INICIO:
  FOR EACH FacCpedi NO-LOCK WHERE
        FacCpedi.CodCia = S-CODCIA AND
        FacCpedi.CodDiv = S-CODDIV AND
        FacCpedi.CodDoc = "COT"    AND
        FacCpedi.FlgEst = "P"      AND
        FacCpedi.FchPed >= F-desde AND
        FacCpedi.FchPed <= F-hasta AND 
        FacCpedi.Codcli BEGINS f-clien ,
        EACH FacDpedi OF FacCpedi  :
    IF CANPED - CANATE <= 0 THEN NEXT.
    /* Filtro por fecha de pedido */
    IF FILL-IN-FchPed-1 <> ?
    THEN DO:
        FIND FIRST B-FacCPedi WHERE B-FacCPedi.CodCia = s-CodCia
            AND B-FacCPedi.CodDiv = s-CodDiv
            AND B-FacCPedi.CodDoc = 'PED'
            AND B-FacCPedi.FlgEst <> 'A'
            AND B-FacCPedi.FchPed >= FILL-IN-FchPed-1
            AND B-FacCPedi.FchPed <= FILL-IN-FchPed-2
            AND B-FacCPedi.NroRef = FacCPedi.NroPed
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-FacCPedi THEN NEXT INICIO.
    END.
    FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
        AND Almmmatg.CodmAT = FacDpedi.CodMat
        NO-LOCK NO-ERROR. 
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
        AND Almtconv.Codalter = FacDpedi.UndVta
        NO-LOCK NO-ERROR.
    F-FACTOR  = 1. 
    IF AVAILABLE Almtconv THEN DO:
        F-FACTOR = Almtconv.Equival.
        IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
    END.
      
      FIND Tmp-tempo WHERE Tmp-Tempo.t-Codcli = Faccpedi.Codcli AND
                           Tmp-Tempo.t-Codmat = FacdPedi.Codmat 
                           NO-LOCK NO-ERROR.
                           
      IF NOT AVAILABLE Tmp-Tempo THEN DO: 
         CREATE Tmp-Tempo.
         ASSIGN   Tmp-Tempo.t-CodAlm = Faccpedi.CodAlm
                  Tmp-Tempo.t-Codcli = Faccpedi.Codcli 
                  Tmp-Tempo.t-Nomcli = Faccpedi.Nomcli 
                  Tmp-Tempo.t-Codmat = FacdPedi.Codmat
                  Tmp-Tempo.t-DesMat = Almmmatg.DesMat
                  Tmp-Tempo.t-DesMar = Almmmatg.DesMar
                  Tmp-Tempo.t-UndBas = Almmmatg.UndBas.
       END.  
         Tmp-Tempo.t-glosa  = Tmp-Tempo.t-glosa + substring(string(FaccPedi.FchPed),1,5) + "-" + SUBSTRING(FaccPedi.Nroped,4,6) + '/'.
         Tmp-Tempo.t-solici = Tmp-Tempo.t-solici + FacdPedi.Canped * F-FACTOR.
         Tmp-Tempo.t-atendi = Tmp-Tempo.t-atendi + FacdPedi.Canate * F-FACTOR.
         Tmp-Tempo.t-pendie = Tmp-Tempo.t-pendie + (FacdPedi.Canped - FacdPedi.CanAte) * F-FACTOR.
         If FaccPedi.Codmon = 1 THEN Tmp-Tempo.t-totsol = Tmp-Tempo.t-totsol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).
         If FaccPedi.Codmon = 2 THEN Tmp-Tempo.t-totdol = Tmp-Tempo.t-totdol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).
  END.


  FOR EACH Tmp-Tempo:
    /* STOCK COMPROMETIDO */
    x-StkCom = 0.
    RUN Stock-Comprometido (Tmp-Tempo.t-CodMat, OUTPUT x-StkCom).
    /* ****************** */
    ASSIGN
        Tmp-Tempo.t-Compro = x-StkCom.
  END.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal-prove W-Win 
PROCEDURE carga-temporal-prove :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
 DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.  
 DEFINE VAR x-nompro AS CHAR.
 
FOR EACH TMP-TEMPO:
 delete tmp-tempo.
end.
 DISPLAY "Cargando Informacion...." @ txt-msj WITH FRAME {&FRAME-NAME}.
INICIO:
FOR EACH FacCpedi NO-LOCK WHERE
          FacCpedi.CodCia = S-CODCIA AND
          FacCpedi.CodDiv = S-CODDIV AND
          FacCpedi.CodDoc = "COT"    AND
          FacCpedi.FlgEst = "P"      AND
          FacCpedi.FchPed >= F-desde AND
          FacCpedi.FchPed <= F-hasta AND 
          FacCpedi.Codcli BEGINS f-clien ,
        EACH FacDpedi OF FacCpedi NO-LOCK:
     IF CANPED - CANATE = 0 THEN NEXT.
    /* Filtro por fecha de pedido */
    IF FILL-IN-FchPed-1 <> ?
    THEN DO:
        FIND FIRST B-FacCPedi WHERE B-FacCPedi.CodCia = s-CodCia
            AND B-FacCPedi.CodDiv = s-CodDiv
            AND B-FacCPedi.CodDoc = 'PED'
            AND B-FacCPedi.FlgEst <> 'A'
            AND B-FacCPedi.FchPed >= FILL-IN-FchPed-1
            AND B-FacCPedi.FchPed <= FILL-IN-FchPed-2
            AND B-FacCPedi.NroRef = FacCPedi.NroPed
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE B-FacCPedi THEN NEXT INICIO.
    END.
     
     FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA AND
                         Almmmatg.CodmAT = FacDpedi.CodMat
                         NO-LOCK NO-ERROR. 

     FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                         Almtconv.Codalter = FacDpedi.UndVta
                         NO-LOCK NO-ERROR.
  
      F-FACTOR  = 1. 
          
      IF AVAILABLE Almtconv THEN DO:
        F-FACTOR = Almtconv.Equival.
        IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
      END.
      
      FIND Tmp-tempo WHERE Tmp-Tempo.t-Codmat = FacdPedi.Codmat 
                           NO-LOCK NO-ERROR.
                           
      IF NOT AVAILABLE Tmp-Tempo THEN DO: 
         FIND Gn-Prov WHERE Gn-Prov.Codcia = PV-CODCIA AND
                            Gn-Prov.Codpro = Almmmatg.Codpr1
                            NO-LOCK NO-ERROR.
         x-nompro = "".                   
         IF AVAILABLE Gn-Prov THEN x-nompro = Gn-prov.NomPro.                   
         CREATE Tmp-Tempo.
         ASSIGN   Tmp-Tempo.t-CodAlm = Faccpedi.CodAlm
                  Tmp-Tempo.t-Codcli = Faccpedi.Codcli 
                  Tmp-Tempo.t-Nomcli = Faccpedi.Nomcli 
                  Tmp-Tempo.t-Codmat = FacdPedi.Codmat
                  Tmp-Tempo.t-DesMat = Almmmatg.DesMat
                  Tmp-Tempo.t-DesMar = Almmmatg.DesMar
                  Tmp-Tempo.t-UndBas = Almmmatg.UndBas
                  Tmp-Tempo.t-Codpro = Almmmatg.Codpr1 
                  Tmp-Tempo.t-Nompro = x-nompro.

       END.  
         Tmp-Tempo.t-glosa  = Tmp-Tempo.t-glosa + substring(string(FaccPedi.FchPed),1,5) + "-" + SUBSTRING(FaccPedi.Nroped,4,6) + '/'.
         Tmp-Tempo.t-solici = Tmp-Tempo.t-solici + FacdPedi.Canped * F-FACTOR.
         Tmp-Tempo.t-atendi = Tmp-Tempo.t-atendi + FacdPedi.Canate * F-FACTOR.
         Tmp-Tempo.t-pendie = Tmp-Tempo.t-pendie + (FacdPedi.Canped - FacdPedi.CanAte) * F-FACTOR.
         If FaccPedi.Codmon = 1 THEN Tmp-Tempo.t-totsol = Tmp-Tempo.t-totsol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).
         If FaccPedi.Codmon = 2 THEN Tmp-Tempo.t-totdol = Tmp-Tempo.t-totdol + (FacdPedi.Canped - FacdPedi.CanAte) * ( FacdPedi.ImpLin / FacdPedi.CanPed ).

 END.
FOR EACH Tmp-Tempo:
    IF FILL-IN-Marca <> '' THEN DO:
        IF NOT tmp-tempo.t-desmar BEGINS TRIM(FILL-IN-Marca) THEN DELETE tmp-tempo.
    END.
    /*
     FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmate.CodAlm = tmp-tempo.t-CodAlm AND
                         Almmmate.CodmAT = tmp-tempo.t-CodMat
                         NO-LOCK NO-ERROR. 
     IF AVAILABLE Almmmate THEN DO:
        IF Almmmate.stkact >= tmp-tempo.t-pendie THEN DELETE Tmp-Tempo.
     End.
    */
END.

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
  DISPLAY FILL-IN-3 f-clien f-nomcli R-Tipo FILL-IN-Marca f-desde f-hasta 
          FILL-IN-FchPed-1 FILL-IN-FchPed-2 txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-41 RECT-43 f-clien R-Tipo FILL-IN-Marca f-desde f-hasta 
         FILL-IN-FchPed-1 FILL-IN-FchPed-2 Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime W-Win 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.    

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4}.
        CASE R-tipo:
            WHEN 1 THEN RUN prn-ofi.
            WHEN 2 THEN RUN proveedor.
            WHEN 3 THEN RUN marca.
        END.       
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.
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
  ASSIGN FILL-IN-3 = S-CODDIV
      F-DESDE   = TODAY
      F-HASTA   = TODAY.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Marca W-Win 
PROCEDURE Marca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 DEFINE VAR W-TOTBRU AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTIGV AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
 DEFINE VAR X-STOCK     AS DECIMAL INIT 0.   
 DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.   
 
 RUN CARGA-TEMPORAL-PROVE.
 
 DEFINE FRAME f-cab
        tmp-tempo.t-codmat 
        tmp-tempo.t-DesMat FORMAT "X(35)"
        tmp-tempo.t-DesMar FORMAT "X(10)"
        tmp-tempo.t-glosa  FORMAT "X(30)"
        tmp-tempo.t-undbas FORMAT "X(4)"
        x-stock            FORMAT "->>>,>>9.99"
        tmp-tempo.t-solici FORMAT "->>>,>>9.99"
        tmp-tempo.t-atendi FORMAT "->>>,>>9.99"
        tmp-tempo.t-pendie FORMAT "->>>,>>9.99"
        HEADER
        S-NOMCIA AT 10 FORMAT "X(45)" SKIP
        "( " + S-CODDIV + ")" AT 1 FORMAT "X(15)"
        "COTIZACIONES POR ATENDER OFICINA"  AT 43 FORMAT "X(35)"
        "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") FORMAT "X(12)"
        "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                 C    A    N    T    I    D    A    D   " SKIP
        " Codigos      Descripcion              Marca          Pedidos                         U.M.    Stock   Solicitado   Atendido  Pendiente  " 
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         /*WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.*/
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
    /*PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .*/

    FOR EACH TMP-TEMPO BREAK
                     BY tmp-tempo.t-desmar
                     BY tmp-tempo.t-codmat:

     /*{&new-page}.*/
     
     DISPLAY STREAM REPORT WITH FRAME F-CAB.
    

     IF FIRST-OF(tmp-tempo.t-desmar) THEN DO:
       PUT STREAM REPORT "MARCA  : "  tmp-tempo.t-desmar SKIP.
       PUT STREAM REPORT '------------------------------------------' SKIP.
     END.

     FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmate.CodAlm = tmp-tempo.t-CodAlm AND
                         Almmmate.CodmAT = tmp-tempo.t-CodMat
                         NO-LOCK NO-ERROR. 
     X-STOCK = 0.
     If Available Almmmate Then X-STOCK = Almmmate.StkAct.

     ACCUM  t-totsol  (SUB-TOTAL BY t-desmar) .
     ACCUM  t-totdol  (SUB-TOTAL BY t-desmar) .

     DISPLAY STREAM REPORT 
        tmp-tempo.t-codmat
        tmp-tempo.t-Desmat
        tmp-tempo.t-Desmar
        tmp-tempo.t-Glosa
        tmp-tempo.t-UndBas
        X-Stock 
        tmp-tempo.t-solici
        tmp-tempo.t-atendi
        tmp-tempo.t-pendie

        WITH FRAME F-Cab.
        
     IF LAST-OF(tmp-tempo.t-desmar) THEN DO:
       PUT STREAM REPORT ' ' SKIP.
       PUT STREAM REPORT  "TOTAL SOLES   : " AT 40. 
       PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-desmar t-totsol) FORMAT '>>>,>>>,>>>,>>>.99' AT 60 .
       PUT STREAM REPORT  "TOTAL DOLARES : " AT 90. 
       PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-desmar t-totdol) FORMAT '>>>,>>>,>>>,>>>.99' AT 110  SKIP.

     END.

 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prn-ofi W-Win 
PROCEDURE prn-ofi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR W-TOTBRU AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTIGV AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
 DEFINE VAR X-STOCK     AS DECIMAL INIT 0.   
 DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.   
 
 RUN CARGA-TEMPORAL.
 
 DEFINE FRAME f-cab
        tmp-tempo.t-codmat 
        tmp-tempo.t-DesMat FORMAT "X(30)"
        tmp-tempo.t-DesMar FORMAT "X(10)"
        tmp-tempo.t-glosa  FORMAT "X(35)"
        tmp-tempo.t-undbas FORMAT "X(4)"
        x-stock            FORMAT "->>>,>>9.99"
        tmp-tempo.t-compro FORMAT "->>>,>>9.99"
        tmp-tempo.t-solici FORMAT "->>>,>>9.99"
        tmp-tempo.t-atendi FORMAT "->>>,>>9.99"
        tmp-tempo.t-pendie FORMAT "->>>,>>9.99"
        HEADER
        S-NOMCIA AT 10 FORMAT "X(45)" SKIP
        "( " + S-CODDIV + ")" AT 1 FORMAT "X(15)" 
        "COTIZACIONES POR ATENDER OFICINA" AT 43 FORMAT "X(35)"
        "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999")  FORMAT "X(12)"
        "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999") FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                   C    A    N    T    I    D    A    D             " SKIP
        " Codigos      Descripcion                   Marca          Pedidos                       U.M.    Stock   Comprometido  Solicitado   Atendido  Pendiente  " 
        "------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
/*                1         2         3         4         5         6         7         8         9        10        11        12        13        14
         1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
         123456 12345678980123456789801234567898012345 1234567890 123456789012345678901234567890 1234 ->>>,>>9.99 ->>>,>>9.99 ->>>,>>9.99 ->>>,>>9.99 ->>>,>>9.99 
*/         

        WITH WIDTH 200 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

    FOR EACH TMP-TEMPO BREAK
                     BY tmp-tempo.t-codcli
                     BY tmp-tempo.t-codmat:     
     
     DISPLAY STREAM REPORT WITH FRAME F-CAB.
    

     IF FIRST-OF(tmp-tempo.t-Codcli) THEN DO:
       PUT STREAM REPORT "CLIENTE  : "  tmp-tempo.t-Codcli  "  " tmp-tempo.t-NomCli SKIP.
       PUT STREAM REPORT '------------------------------------------' SKIP.
     END.     

     FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmate.CodAlm = tmp-tempo.t-CodAlm AND
                         Almmmate.CodmAT = tmp-tempo.t-CodMat
                         NO-LOCK NO-ERROR. 
     X-STOCK = 0.
     If Available Almmmate Then X-STOCK = Almmmate.StkAct.

     ACCUM  t-totsol  (SUB-TOTAL BY t-codcli) .
     ACCUM  t-totdol  (SUB-TOTAL BY t-codcli) .

     DISPLAY STREAM REPORT 
        tmp-tempo.t-codmat
        tmp-tempo.t-Desmat
        tmp-tempo.t-Desmar
        tmp-tempo.t-Glosa
        tmp-tempo.t-UndBas
        X-Stock 
        tmp-tempo.t-solici
        tmp-tempo.t-compro
        tmp-tempo.t-atendi
        tmp-tempo.t-pendie

        WITH FRAME F-Cab.
        
     IF LAST-OF(tmp-tempo.t-Codcli) THEN DO:
       PUT STREAM REPORT ' ' SKIP.
       PUT STREAM REPORT  "TOTAL SOLES   : " AT 40. 
       PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-codcli t-totsol) AT 60 .
       PUT STREAM REPORT  "TOTAL DOLARES : " AT 90. 
       PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-codcli t-totdol) AT 110  SKIP.

     END.

 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Proveedor W-Win 
PROCEDURE Proveedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR W-TOTBRU AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTDSC AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVAL AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.  
 DEFINE VAR W-TOTIGV AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR W-TOTVEN AS DECIMAL FORMAT "->,>>>,>>9.99" EXTENT 6 INIT 0.
 DEFINE VAR X-PENDIENTE AS DECIMAL INIT 0.   
 DEFINE VAR X-STOCK     AS DECIMAL INIT 0.   
 DEFINE VAR F-FACTOR    AS DECIMAL INIT 0.   
 
 RUN CARGA-TEMPORAL-PROVE.
 
 DEFINE FRAME f-cab
        tmp-tempo.t-codmat 
        tmp-tempo.t-DesMat FORMAT "X(35)"
        tmp-tempo.t-DesMar FORMAT "X(10)"
        tmp-tempo.t-glosa  FORMAT "X(30)"
        tmp-tempo.t-undbas FORMAT "X(4)"
        x-stock            FORMAT "->>>,>>9.99"
        tmp-tempo.t-solici FORMAT "->>>,>>9.99"
        tmp-tempo.t-atendi FORMAT "->>>,>>9.99"
        tmp-tempo.t-pendie FORMAT "->>>,>>9.99"
        HEADER
        S-NOMCIA AT 10 FORMAT "X(45)" SKIP
        "( " + S-CODDIV + ")" AT 1 FORMAT "X(15)"
        "COTIZACIONES POR ATENDER OFICINA"  AT 43 FORMAT "X(35)"
        "Pag.  : " AT 92 FORMAT "X(10)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        "Desde : " AT 50 FORMAT "X(10)" STRING(F-DESDE,"99/99/9999") FORMAT "X(10)" "Al" STRING(F-HASTA,"99/99/9999") FORMAT "X(12)"
        "Fecha : " AT 105 FORMAT "X(10)" STRING(TODAY,"99/99/9999")  FORMAT "X(12)" 
        T-VENDE AT 1 FORMAT "X(45)" T-CLIEN AT 60 FORMAT "X(20)" "Hora  : " AT 119 STRING(TIME,"HH:MM:SS") SKIP
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                                                 C    A    N    T    I    D    A    D   " SKIP
        " Codigos      Descripcion              Marca          Pedidos                         U.M.    Stock   Solicitado   Atendido  Pendiente  " 
        "----------------------------------------------------------------------------------------------------------------------------------------" SKIP
         
         /*WITH WIDTH 165 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.*/
        WITH WIDTH 250 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.
 
    PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .

    FOR EACH TMP-TEMPO BREAK
                     BY tmp-tempo.t-codpro
                     BY tmp-tempo.t-codmat:
    /*
     {&new-page}.
     */
     DISPLAY STREAM REPORT WITH FRAME F-CAB.
    

     IF FIRST-OF(tmp-tempo.t-Codpro) THEN DO:
       PUT STREAM REPORT "PROVEEDOR  : "  tmp-tempo.t-Codpro  "  " tmp-tempo.t-Nompro SKIP.
       PUT STREAM REPORT '------------------------------------------' SKIP.
     END.

     FIND Almmmate WHERE Almmmate.CodCia = S-CODCIA AND
                         Almmmate.CodAlm = tmp-tempo.t-CodAlm AND
                         Almmmate.CodmAT = tmp-tempo.t-CodMat
                         NO-LOCK NO-ERROR. 
     X-STOCK = 0.
     If Available Almmmate Then X-STOCK = Almmmate.StkAct.

     ACCUM  t-totsol  (SUB-TOTAL BY t-codpro) .
     ACCUM  t-totdol  (SUB-TOTAL BY t-codpro) .

     DISPLAY STREAM REPORT 
        tmp-tempo.t-codmat
        tmp-tempo.t-Desmat
        tmp-tempo.t-Desmar
        tmp-tempo.t-Glosa
        tmp-tempo.t-UndBas
        X-Stock 
        tmp-tempo.t-solici
        tmp-tempo.t-atendi
        tmp-tempo.t-pendie

        WITH FRAME F-Cab.
        
     IF LAST-OF(tmp-tempo.t-Codpro) THEN DO:
       PUT STREAM REPORT ' ' SKIP.
       PUT STREAM REPORT  "TOTAL SOLES   : " AT 40. 
       PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-codpro t-totsol) FORMAT '>>>,>>>,>>>,>>>.99' AT 60 .
       PUT STREAM REPORT  "TOTAL DOLARES : " AT 90. 
       PUT STREAM REPORT (ACCUM SUB-TOTAL BY t-codpro t-totdol) FORMAT '>>>,>>>,>>>,>>>.99' AT 110  SKIP.

     END.

 END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Stock-Comprometido W-Win 
PROCEDURE Stock-Comprometido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER s-CodMat AS CHAR.
  DEF OUTPUT PARAMETER x-CanPed AS DEC.

  DEF VAR x-PedCon AS DEC INIT 0 NO-UNDO.
  
        /****/
        FOR EACH FacDPedi WHERE FacDPedi.CodCia = s-codcia 
                           AND  FacDPedi.almdes = s-codalm
                           AND  FacDPedi.codmat = s-codmat 
                           AND  LOOKUP(FacDPedi.CodDoc,'PED') > 0 
                           AND  LOOKUP(FacDPedi.FlgEst, 'P,X,') > 0:
            FIND FIRST FacCPedi OF FacDPedi WHERE FacCPedi.codcia = FacDPedi.CodCia
                                             AND  FacCPedi.CodAlm = FacDPedi.almdes
                                             AND  Faccpedi.FlgEst = "P"
                                             AND  Faccpedi.TpoPed = "1"
                                            NO-LOCK NO-ERROR.
            IF NOT AVAIL Faccpedi THEN NEXT.
        
            X-CanPed = X-CanPed + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).
        END.
        
        /*********   Barremos las O/D que son parciales y totales    ****************/
        FOR EACH FacDPedi WHERE FacDPedi.CodCia = s-codcia
                           AND  FacDPedi.almdes = s-codalm
                           AND  FacDPedi.codmat = s-codmat 
                           AND  LOOKUP(FacDPedi.CodDoc,'O/D') > 0 
                           AND  LOOKUP(FacDPedi.FlgEst, 'P,X,') > 0:
            FIND FIRST FacCPedi OF FacDPedi WHERE FacCPedi.codcia = FacDPedi.CodCia
                                             AND  FacCPedi.CodAlm = s-codalm 
                                             AND  Faccpedi.FlgEst = "P"
                                            NO-LOCK NO-ERROR.
            IF NOT AVAIL FacCPedi THEN NEXT.
            X-CanPed = X-CanPed + FacDPedi.Factor * (FacDPedi.CanPed - FacDPedi.canate ).
        END.
        
        /*******************************************************/
        
        /* Segundo barremos los pedidos de mostrador de acuerdo a la vigencia */
        DEF VAR TimeOut AS INTEGER NO-UNDO.
        DEF VAR TimeNow AS INTEGER NO-UNDO.
        FIND FacCfgGn WHERE faccfggn.codcia = s-codcia NO-LOCK.
        TimeOut = (FacCfgGn.Dias-Res * 24 * 3600) +
                  (FacCfgGn.Hora-Res * 3600) + 
                  (FacCfgGn.Minu-Res * 60).
        FOR EACH Facdpedm WHERE Facdpedm.CodCia = s-codcia 
                           AND  Facdpedm.AlmDes = S-CODALM
                           AND  Facdpedm.codmat = s-codmat 
                           AND  Facdpedm.FlgEst = "P" :
            FIND FIRST Faccpedm OF Facdpedm WHERE Faccpedm.CodCia = Facdpedm.CodCia 
                                             AND  Faccpedm.CodAlm = s-codalm 
                                             AND  Faccpedm.FlgEst = "P"  
                                            NO-LOCK NO-ERROR. 
            IF NOT AVAIL Faccpedm THEN NEXT.
            
            TimeNow = (TODAY - FacCPedm.FchPed) * 24 * 3600.
            TimeNow = TimeNow + TIME - ( (INTEGER(SUBSTRING(FacCPedm.Hora, 1, 2)) * 3600) +
                      (INTEGER(SUBSTRING(FacCPedm.Hora, 4, 2)) * 60) ).
            IF TimeOut > 0 THEN DO:
                IF TimeNow <= TimeOut   /* Dentro de la valides */
                THEN DO:
                    /* cantidad en reservacion */
                    X-CanPed = X-CanPed + FacDPedm.Factor * FacDPedm.CanPed.
                END.
            END.
        END.
        X-PedCon = X-CanPed.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

