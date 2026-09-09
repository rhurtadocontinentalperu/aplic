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

/* Parameters Definitions ---  */                                       
DEF INPUT PARAMETER pCodCia AS INT.
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pCodTransportista AS CHAR.
DEFINE OUTPUT PARAMETER pNomTransportista AS CHAR.
DEFINE OUTPUT PARAMETER pRUC AS CHAR.
DEFINE OUTPUT PARAMETER pLicConducir AS CHAR.
DEFINE OUTPUT PARAMETER pCertInscripcion AS CHAR.
DEFINE OUTPUT PARAMETER pVehiculoMarca AS CHAR.
DEFINE OUTPUT PARAMETER pPlaca AS CHAR.
DEFINE OUTPUT PARAMETER pInicioTraslado AS DATE.
DEFINE OUTPUT PARAMETER pChofer AS CHAR.
DEFINE OUTPUT PARAMETER pCarreta AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE PV-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VAR s-codcia AS INT.

pCodTransportista = "".
pNomTransportista = "".
pRUC = "".
pLicConducir = "".
pCertInscripcion = "".
pVehiculoMarca = "".
pPlaca = "".
pChofer = "".
pCarreta = "".

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
&Scoped-Define ENABLED-OBJECTS RECT-65 Btn_OK f-NroLicencia ~
F-cert-inscripcion Btn_Cancel f-Placa f-Traslado f-carreta 
&Scoped-Define DISPLAYED-OBJECTS f-CodAge f-RucAge f-NroLicencia ~
F-cert-inscripcion f-Chofer f-NomTra f-Placa f-Marca f-Traslado f-carreta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 11 BY 1.08.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 11 BY 1.08.

DEFINE VARIABLE f-carreta AS CHARACTER FORMAT "X(10)":U 
     LABEL "Carreta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-cert-inscripcion AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cert.Inscripcion" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE f-Chofer AS CHARACTER FORMAT "X(50)":U 
     LABEL "Chofer" 
     VIEW-AS FILL-IN 
     SIZE 62 BY .81 NO-UNDO.

DEFINE VARIABLE f-CodAge AS CHARACTER FORMAT "X(11)":U 
     LABEL "Transportista" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .81 NO-UNDO.

DEFINE VARIABLE f-Marca AS CHARACTER FORMAT "X(20)":U 
     LABEL "Vehículo Marca" 
     VIEW-AS FILL-IN 
     SIZE 24 BY .81 NO-UNDO.

DEFINE VARIABLE f-NomTra AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY .81 NO-UNDO.

DEFINE VARIABLE f-NroLicencia AS CHARACTER FORMAT "X(10)":U 
     LABEL "Nº de Licencia" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE f-Placa AS CHARACTER FORMAT "X(10)":U 
     LABEL "Nº Placa" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE f-RucAge AS CHARACTER FORMAT "x(11)":U 
     LABEL "RUC" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE VARIABLE f-Traslado AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Traslado" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-65
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 6.19.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     Btn_OK AT ROW 7.92 COL 3 WIDGET-ID 18
     f-CodAge AT ROW 2.31 COL 12 COLON-ALIGNED WIDGET-ID 40
     f-RucAge AT ROW 3.27 COL 12 COLON-ALIGNED WIDGET-ID 42
     f-NroLicencia AT ROW 4.23 COL 12 COLON-ALIGNED WIDGET-ID 54
     F-cert-inscripcion AT ROW 5.19 COL 12 COLON-ALIGNED WIDGET-ID 36
     f-Chofer AT ROW 6.15 COL 12 COLON-ALIGNED WIDGET-ID 56
     Btn_Cancel AT ROW 7.92 COL 16.43 WIDGET-ID 16
     f-NomTra AT ROW 2.31 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     f-Placa AT ROW 3.27 COL 51 COLON-ALIGNED WIDGET-ID 46
     f-Marca AT ROW 4.23 COL 51 COLON-ALIGNED WIDGET-ID 48
     f-Traslado AT ROW 5.19 COL 51 COLON-ALIGNED WIDGET-ID 50
     f-carreta AT ROW 3.27 COL 67.72 COLON-ALIGNED WIDGET-ID 58
     "DATOS DEL TRANSPORTISTA / CONDUCTOR" VIEW-AS TEXT
          SIZE 35 BY .5 AT ROW 1.27 COL 3 WIDGET-ID 38
     RECT-65 AT ROW 1.54 COL 2 WIDGET-ID 52
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 82 BY 16.35
         FONT 4 WIDGET-ID 100.


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
         TITLE              = "AGENCIA DE TRANSPORTES"
         HEIGHT             = 8.42
         WIDTH              = 82
         MAX-HEIGHT         = 31.35
         MAX-WIDTH          = 164.57
         VIRTUAL-HEIGHT     = 31.35
         VIRTUAL-WIDTH      = 164.57
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
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME L-To-R,COLUMNS                                            */
ASSIGN 
       FRAME F-Main:HIDDEN           = TRUE
       FRAME F-Main:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN f-Chofer IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-CodAge IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-Marca IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-NomTra IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-RucAge IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* AGENCIA DE TRANSPORTES */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* AGENCIA DE TRANSPORTES */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK W-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* OK */
DO:

        MESSAGE 'Seguro de GUARDAR el transportista?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.


   RUN Graba-datos.
   IF RETURN-VALUE = "ADM-ERROR" THEN RETURN NO-APPLY.
   
   &IF "{&PROCEDURE-TYPE}" EQ "SmartPanel" &THEN
    &IF "{&ADM-VERSION}" EQ "ADM1.1" &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
    &ELSE
      RUN exitObject.
    &ENDIF
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-carreta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-carreta W-Win
ON LEAVE OF f-carreta IN FRAME F-Main /* Carreta */
DO:
/*
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND gn-vehic WHERE gn-vehic.codcia = s-codcia
      AND gn-vehic.placa = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-vehic THEN DO:
      MESSAGE 'Placa NO registrada' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.

  IF f-codage:SCREEN-VALUE = ""  THEN DO:

      FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                        vtatabla.tabla = 'VEHICULO' AND 
                        vtatabla.llave_c2 = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF NOT AVAILABLE vtatabla THEN DO:
          MESSAGE 'Vehiculo aun no tiene proveedor asignado' VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.

      FIND FIRST gn-prov WHERE 
           gn-prov.CodCia  = PV-CODCIA AND
           gn-prov.CodPro  = vtatabla.llave_c1 NO-LOCK NO-ERROR .
      IF AVAILABLE gn-prov THEN DO:
         DISPLAY gn-prov.NomPro      @ F-NomTra
                 gn-prov.Ruc         @ F-RucAge
                 vtatabla.llave_c1   @ f-codage
                 gn-vehic.marca      @ f-marca
                 WITH FRAME {&FRAME-NAME}.
      END.
      ELSE DO:
          MESSAGE 'El proveedor del vehiculo NO EXISTE' VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.

  END.
  ELSE DO:

      FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND 
                        vtatabla.tabla = 'VEHICULO' AND 
                        vtatabla.llave_c1 = f-CodAge:SCREEN-VALUE AND
                        vtatabla.llave_c2 = SELF:SCREEN-VALUE                        
                        NO-LOCK NO-ERROR.
      IF NOT AVAILABLE vtatabla THEN DO:
          MESSAGE 'Vehiculo aun no tiene proveedor asignado' VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
      /*
      FIND gn-vehic WHERE gn-vehic.codcia = s-codcia
          AND gn-vehic.placa = SELF:SCREEN-VALUE
          AND gn-vehic.codpro = f-CodAge:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-vehic THEN DO:
          MESSAGE 'Placa NO pertece al tranportista' VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.
      */
      ASSIGN
          /*f-CodAge:SCREEN-VALUE = gn-vehic.codpro*/
          f-Marca:SCREEN-VALUE = gn-vehic.marca.
            /*APPLY 'LEAVE':U TO f-CodAge.*/
  END.
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-carreta W-Win
ON LEFT-MOUSE-DBLCLICK OF f-carreta IN FRAME F-Main /* Carreta */
OR F8 OF f-Placa
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN lkup/c-vehic-v2 ('Vehiculo').
    IF output-var-1 <> ? THEN SELF:SCREEN-VALUE = output-var-2.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-CodAge
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-CodAge W-Win
ON LEAVE OF f-CodAge IN FRAME F-Main /* Transportista */
DO:
    DEF VAR dist AS CHARACTER.
    IF SELF:SCREEN-VALUE = "" THEN RETURN "ADM-ERROR".
    FIND FIRST gn-prov WHERE 
         gn-prov.CodCia  = PV-CODCIA AND
         gn-prov.CodPro  = F-CodAge:SCREEN-VALUE NO-LOCK NO-ERROR .
    IF AVAILABLE gn-prov THEN DO:
       DISPLAY gn-prov.NomPro      @ F-NomTra
               gn-prov.Ruc         @ F-RucAge
               WITH FRAME {&FRAME-NAME}.
    END.
    ELSE DO:
       MESSAGE "Transportista no Registrado..." VIEW-AS ALERT-BOX.
       RETURN NO-APPLY.
    END.
    IF gn-prov.flgsit = 'C' THEN DO:
       MESSAGE 'Transportista CESADO' VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-NroLicencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-NroLicencia W-Win
ON LEAVE OF f-NroLicencia IN FRAME F-Main /* Nº de Licencia */
DO:
    f-chofer:SCREEN-VALUE = "".
    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'BREVETE' AND
        vtatabla.llave_c1 = f-nrolicencia:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE vtatabla THEN DO:
        f-chofer:SCREEN-VALUE = vtatabla.libre_C01 + " " + vtatabla.libre_C02 + " " + vtatabla.libre_C03.  
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-Placa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-Placa W-Win
ON LEAVE OF f-Placa IN FRAME F-Main /* Nº Placa */
DO:
  IF SELF:SCREEN-VALUE = '' THEN RETURN.
  FIND gn-vehic WHERE gn-vehic.codcia = s-codcia
      AND gn-vehic.placa = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE gn-vehic THEN DO:
      MESSAGE 'Placa NO registrada' VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.

  IF f-codage:SCREEN-VALUE = ""  THEN DO:
      FIND FIRST gn-prov WHERE 
           gn-prov.CodCia  = PV-CODCIA AND
           gn-prov.CodPro  = gn-vehic.CodPro NO-LOCK NO-ERROR .
      IF AVAILABLE gn-prov THEN DO:
         DISPLAY gn-prov.NomPro      @ F-NomTra
                 gn-prov.Ruc         @ F-RucAge
                 gn-prov.CodPro      @ f-codage
                 /*vtatabla.llave_c1   @ f-codage*/
                 gn-vehic.marca      @ f-marca
                 WITH FRAME {&FRAME-NAME}.
      END.
      ELSE DO:
          MESSAGE 'El proveedor del vehiculo NO EXISTE' VIEW-AS ALERT-BOX ERROR.
          RETURN NO-APPLY.
      END.

/*       FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND                        */
/*                         vtatabla.tabla = 'VEHICULO' AND                               */
/*                         vtatabla.llave_c2 = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.       */
/*       IF NOT AVAILABLE vtatabla THEN DO:                                              */
/*           MESSAGE 'Vehiculo aun no tiene proveedor asignado' VIEW-AS ALERT-BOX ERROR. */
/*           RETURN NO-APPLY.                                                            */
/*       END.                                                                            */
/*                                                                                       */
/*       FIND FIRST gn-prov WHERE                                                        */
/*            gn-prov.CodCia  = PV-CODCIA AND                                            */
/*            gn-prov.CodPro  = vtatabla.llave_c1 NO-LOCK NO-ERROR .                     */
/*       IF AVAILABLE gn-prov THEN DO:                                                   */
/*          DISPLAY gn-prov.NomPro      @ F-NomTra                                       */
/*                  gn-prov.Ruc         @ F-RucAge                                       */
/*                  vtatabla.llave_c1   @ f-codage                                       */
/*                  gn-vehic.marca      @ f-marca                                        */
/*                  WITH FRAME {&FRAME-NAME}.                                            */
/*       END.                                                                            */
/*       ELSE DO:                                                                        */
/*           MESSAGE 'El proveedor del vehiculo NO EXISTE' VIEW-AS ALERT-BOX ERROR.      */
/*           RETURN NO-APPLY.                                                            */
/*       END.                                                                            */

  END.
  ELSE DO:
/*       FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND                        */
/*                         vtatabla.tabla = 'VEHICULO' AND                               */
/*                         vtatabla.llave_c1 = f-CodAge:SCREEN-VALUE AND                 */
/*                         vtatabla.llave_c2 = SELF:SCREEN-VALUE                         */
/*                         NO-LOCK NO-ERROR.                                             */
/*       IF NOT AVAILABLE vtatabla THEN DO:                                              */
/*           MESSAGE 'Vehiculo aun no tiene proveedor asignado' VIEW-AS ALERT-BOX ERROR. */
/*           RETURN NO-APPLY.                                                            */
/*       END.                                                                            */
      ASSIGN
          f-Marca:SCREEN-VALUE = gn-vehic.marca.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-Placa W-Win
ON LEFT-MOUSE-DBLCLICK OF f-Placa IN FRAME F-Main /* Nº Placa */
OR F8 OF f-Placa
DO:
    ASSIGN
        input-var-1 = ''
        input-var-2 = ''
        input-var-3 = ''
        output-var-1 = ?.
    RUN lkup/c-vehic-v2 ('Vehiculo').
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
  DISPLAY f-CodAge f-RucAge f-NroLicencia F-cert-inscripcion f-Chofer f-NomTra 
          f-Placa f-Marca f-Traslado f-carreta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-65 Btn_OK f-NroLicencia F-cert-inscripcion Btn_Cancel f-Placa 
         f-Traslado f-carreta 
      WITH FRAME F-Main IN WINDOW W-Win.
  VIEW FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-datos W-Win 
PROCEDURE Graba-datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME} :
    IF f-CodAge:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Ingrese Codigo del Transportista".
        RETURN "ADM-ERROR".
    END.
    IF f-NomTra:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Ingrese Nombre del Transportista".
        RETURN "ADM-ERROR".
    END.
    IF f-RucAge:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Ingrese el Nro de RUC del transportista".
        RETURN "ADM-ERROR".
    END.
    IF f-NroLicencia:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Ingrese el Nro de Licencia del conductor".
        RETURN "ADM-ERROR".
    END.
    IF f-cert-inscripcion:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Ingrese el certificado de inscripcion".
        RETURN "ADM-ERROR".
    END.
    IF f-Marca:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Ingrese la MARCA del vehiculo".
        RETURN "ADM-ERROR".
    END.
    IF f-Placa:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Ingrese la PLACA del vehiculo".
        RETURN "ADM-ERROR".
    END.
    IF f-Chofer:SCREEN-VALUE = "" THEN DO:
        MESSAGE "Ingrese el nombre del conductor".
        RETURN "ADM-ERROR".
    END.
    IF INPUT f-Traslado > TODAY THEN DO:
        MESSAGE "Fecha de Traslado no debe ser mayor al dia de HOY".
        RETURN "ADM-ERROR".
    END.
    IF LENGTH(f-carreta:SCREEN-VALUE) < 7 THEN DO:
        MESSAGE "Nro de Placa incorrecta".
        RETURN "ADM-ERROR".
    END.

    FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'BREVETE' AND
        vtatabla.llave_c1 = f-nrolicencia:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE vtatabla THEN DO:
        MESSAGE "Nro de Licencia NO EXISTE".
        RETURN "ADM-ERROR".        
    END.

    FIND gn-vehic WHERE gn-vehic.codcia = s-codcia
        AND gn-vehic.placa = f-placa:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-vehic THEN DO:
        MESSAGE 'Placa NO registrada' VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

/*     FIND FIRST vtatabla WHERE vtatabla.codcia = s-codcia AND vtatabla.tabla = 'VEHICULO' AND */
/*         vtatabla.llave_c1 = f-codage:SCREEN-VALUE AND                                        */
/*         vtatabla.llave_c2 = f-placa:SCREEN-VALUE                                             */
/*         NO-LOCK NO-ERROR.                                                                    */
/*     IF NOT AVAILABLE vtatabla THEN DO:                                                       */
/*         MESSAGE "Vehiculo no tiene asignado Proveedor".                                      */
/*         RETURN "ADM-ERROR".                                                                  */
/*     END.                                                                                     */

    FIND FIRST gn-prov WHERE 
         gn-prov.CodCia  = PV-CODCIA AND
         gn-prov.CodPro  = F-CodAge:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-prov THEN DO:
        MESSAGE "Codigo de Transportista no EXISTE como PROVEEDOR".
        RETURN "ADM-ERROR".
    END.
    /*
    FIND gn-vehic WHERE gn-vehic.codcia = s-codcia
        AND gn-vehic.placa = f-placa:SCREEN-VALUE
        AND gn-vehic.codpro = f-CodAge:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-vehic THEN DO:
        MESSAGE 'Placa NO pertece al tranportista' VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    */
    pCodTransportista = f-CodAge:SCREEN-VALUE.
    pNomTransportista = f-NomTra:SCREEN-VALUE.
    pRUC = f-RucAge:SCREEN-VALUE.
    pLicConducir = f-NroLicencia:SCREEN-VALUE.
    pCertInscripcion = f-cert-inscripcion:SCREEN-VALUE.
    pVehiculoMarca = f-Marca:SCREEN-VALUE.
    pPlaca = f-Placa:SCREEN-VALUE.
    pInicioTraslado =  INPUT f-Traslado.
    pChofer = f-Chofer:SCREEN-VALUE.
    pCarreta = f-carreta:SCREEN-VALUE.

    RETURN "OK".

END.

/*
  DO TRANSACTION WITH FRAME {&FRAME-NAME} ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND Ccbadocu WHERE Ccbadocu.codcia = pcodcia
          AND Ccbadocu.coddiv = pcoddiv
          AND Ccbadocu.coddoc = pcoddoc
          AND Ccbadocu.nrodoc = pnrodoc
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE Ccbadocu THEN CREATE Ccbadocu.
      ASSIGN
          Ccbadocu.codcia = pcodcia
          Ccbadocu.coddoc = pcoddoc
          Ccbadocu.nrodoc = pnrodoc
          Ccbadocu.coddiv = pcoddiv.
      ASSIGN
          CcbADocu.Libre_C[1] = f-Placa:SCREEN-VALUE 
          CcbADocu.Libre_C[2] = f-Marca:SCREEN-VALUE 
          CcbADocu.Libre_C[3] = f-CodAge:SCREEN-VALUE 
          CcbADocu.Libre_C[4] = f-NomTra:SCREEN-VALUE 
          CcbADocu.Libre_C[5] = f-RucAge:SCREEN-VALUE 
          CcbADocu.Libre_C[6] = f-NroLicencia:SCREEN-VALUE 
          CcbADocu.Libre_C[7] = f-Chofer:SCREEN-VALUE 
          CcbADocu.Libre_C[8] = f-NroLicencia:SCREEN-VALUE 
          CcbADocu.Libre_F[1] = INPUT f-Traslado
          CcbADocu.Libre_C[11] = f-Ruc:SCREEN-VALUE
          CcbADocu.Libre_C[17] = f-cert-inscripcion:SCREEN-VALUE
          /*
          CcbADocu.Libre_C[9] = f-CodTran:SCREEN-VALUE 
          CcbADocu.Libre_C[10] = f-Nombre:SCREEN-VALUE 
          CcbADocu.Libre_C[11] = f-Ruc:SCREEN-VALUE 
          CcbADocu.Libre_C[12] = f-Direccion:SCREEN-VALUE 
          CcbADocu.Libre_C[13] = f-Lugar:SCREEN-VALUE 
          CcbADocu.Libre_C[14] = f-Contacto:SCREEN-VALUE 
          CcbADocu.Libre_C[15] = f-Horario:SCREEN-VALUE 
          CcbADocu.Libre_C[16] = f-Observ:SCREEN-VALUE           
          CcbADocu.Libre_F[2] = INPUT f-Fecha.
          */
      RELEASE Ccbadocu.
  END.
  */
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
  FIND Ccbadocu WHERE Ccbadocu.codcia = pcodcia
      AND Ccbadocu.coddiv = pcoddiv
      AND Ccbadocu.coddoc = pcoddoc
      AND Ccbadocu.nrodoc = pnrodoc
      NO-LOCK NO-ERROR.
  IF AVAILABLE Ccbadocu THEN DO:
      ASSIGN
          f-CodAge = CcbADocu.Libre_C[3] 
          f-NomTra = CcbADocu.Libre_C[4] 
          f-RucAge = CcbADocu.Libre_C[5] 
          f-NroLicencia = CcbADocu.Libre_C[6] 
          f-cert-inscripcion = CcbADocu.Libre_C[17] 
          f-Marca = CcbADocu.Libre_C[2] 
          f-Placa = CcbADocu.Libre_C[1]          
          f-Traslado = CcbADocu.Libre_F[1]
          f-Chofer = CcbADocu.Libre_C[7].           
  END.
  ELSE DO: 
      /*f-Traslado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999") .*/
  END.
      

  /* Dispatch standard ADM method.                             */
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  IF NOT AVAILABLE Ccbadocu THEN DO:
      f-Traslado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(TODAY,"99/99/9999") .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros W-Win 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros W-Win 
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
    input-var-1 = "".
    CASE HANDLE-CAMPO:name:
        WHEN "CndCmp" THEN ASSIGN input-var-1 = "" /*"20"*/.
        

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

