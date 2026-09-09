&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM NO-UNDO LIKE FacDPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
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

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
&SCOPED-DEFINE precio-venta-general pri/PrecioVentaMayorContadoFlash.p

/* Parameters Definitions ---                                           */
DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-codcli AS CHAR.
DEF SHARED VAR s-codmon AS INTE.
DEF SHARED VAR s-tpocmb AS DECI.
DEF SHARED VAR s-flgsit AS CHAR.
DEF SHARED VAR s-nrodec AS INTE.
DEF SHARED VAR s-porigv AS DECI.

/* Local Variable Definitions ---                                       */

DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER x-CodAlm AS CHAR.
DEF INPUT-OUTPUT PARAMETER TABLE FOR ITEM.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND
    Almmmatg.codmat = pCodMat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.

/* Variables para el cálculo del precio */
DEF VAR f-Factor LIKE Facdpedi.factor NO-UNDO.
DEF VAR f-CanPed LIKE Facdpedi.canped NO-UNDO.
DEF VAR f-PreBas AS DECI NO-UNDO.
DEF VAR f-PreVta AS DECI NO-UNDO.
DEF VAR f-Dsctos AS DECI NO-UNDO.
DEF VAR y-Dsctos AS DECI NO-UNDO.
DEF VAR x-TipDto AS CHAR NO-UNDO.
DEF VAR f-FleteUnitario AS DECI NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.
DEF VAR s-UndVta AS CHAR NO-UNDO.
DEF VAR x-Factor AS DECI NO-UNDO.

DEF VAR cCanPed AS CHAR NO-UNDO.    /* OJO: se una al momento de cambiar la cantidad */

DEF VAR s-StkDis AS DECI NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almmmatg

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define FIELDS-IN-QUERY-D-Dialog Almmmatg.codmat Almmmatg.DesMat ~
Almmmatg.DesMar 
&Scoped-define QUERY-STRING-D-Dialog FOR EACH Almmmatg SHARE-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH Almmmatg SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog Almmmatg
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog Almmmatg


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN-CanPed COMBO-BOX-UndVta BUTTON-Menos ~
BUTTON-Mas IMAGE_Producto 
&Scoped-Define DISPLAYED-FIELDS Almmmatg.codmat Almmmatg.DesMat ~
Almmmatg.DesMar 
&Scoped-define DISPLAYED-TABLES Almmmatg
&Scoped-define FIRST-DISPLAYED-TABLE Almmmatg
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CanPed FILL-IN_UndA ~
FILL-IN_PreUniA FILL-IN_UndB FILL-IN_PreUniB FILL-IN_UndC FILL-IN_PreUniC ~
COMBO-BOX-UndVta FILL-IN-Disponible FILL-IN_ImpTot 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-Mas 
     LABEL "+" 
     SIZE 6 BY 1.38
     FONT 8.

DEFINE BUTTON BUTTON-Menos 
     LABEL "-" 
     SIZE 6 BY 1.38
     FONT 8.

DEFINE VARIABLE COMBO-BOX-UndVta AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 14 BY 1
     FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-CanPed AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY 1.35
     FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN-Disponible AS CHARACTER FORMAT "X(256)":U 
     LABEL "Stock Disponible" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1.08
     BGCOLOR 14 FGCOLOR 0 FONT 9 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpTot AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY 1.35
     FONT 8 NO-UNDO.

DEFINE VARIABLE FILL-IN_PreUniA AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Precio Unitario" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_PreUniB AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Precio Unitario" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_PreUniC AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Precio Unitario" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_UndA AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unidad" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_UndB AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unidad" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN_UndC AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unidad" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81
     FONT 6 NO-UNDO.

DEFINE IMAGE IMAGE_Producto
     FILENAME "productos/002906.jpg":U
     STRETCH-TO-FIT
     SIZE 53 BY 12.38.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      Almmmatg SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-CanPed AT ROW 16.62 COL 19 COLON-ALIGNED NO-LABEL WIDGET-ID 188
     Almmmatg.codmat AT ROW 2.08 COL 57 COLON-ALIGNED NO-LABEL WIDGET-ID 200 FORMAT "X(15)"
          VIEW-AS FILL-IN 
          SIZE 17 BY 1.35
          FONT 8
     Almmmatg.DesMat AT ROW 3.69 COL 57 COLON-ALIGNED NO-LABEL WIDGET-ID 198 FORMAT "X(60)"
          VIEW-AS FILL-IN 
          SIZE 76 BY 1.35
          FONT 9
     Almmmatg.DesMar AT ROW 5.31 COL 57 COLON-ALIGNED NO-LABEL WIDGET-ID 196
          VIEW-AS FILL-IN 
          SIZE 22.86 BY 1.08
          FONT 9
     FILL-IN_UndA AT ROW 10.69 COL 62 COLON-ALIGNED WIDGET-ID 176
     FILL-IN_PreUniA AT ROW 10.69 COL 84 COLON-ALIGNED WIDGET-ID 170
     FILL-IN_UndB AT ROW 11.77 COL 62 COLON-ALIGNED WIDGET-ID 178
     FILL-IN_PreUniB AT ROW 11.77 COL 84 COLON-ALIGNED WIDGET-ID 172
     FILL-IN_UndC AT ROW 12.85 COL 62 COLON-ALIGNED WIDGET-ID 180
     FILL-IN_PreUniC AT ROW 12.85 COL 84 COLON-ALIGNED WIDGET-ID 174
     COMBO-BOX-UndVta AT ROW 15 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 190
     BUTTON-Menos AT ROW 16.62 COL 14 WIDGET-ID 192
     BUTTON-Mas AT ROW 16.62 COL 34 WIDGET-ID 194
     FILL-IN-Disponible AT ROW 16.88 COL 59 COLON-ALIGNED WIDGET-ID 208
     FILL-IN_ImpTot AT ROW 18.5 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 168
     "Presentación:" VIEW-AS TEXT
          SIZE 23 BY 1.35 AT ROW 15 COL 8 WIDGET-ID 202
          FONT 8
     "TOTAL S/:" VIEW-AS TEXT
          SIZE 17 BY 1.35 AT ROW 18.5 COL 8 WIDGET-ID 186
          FONT 8
     IMAGE_Producto AT ROW 1.27 COL 2 WIDGET-ID 182
     SPACE(81.42) SKIP(7.88)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 6
         TITLE "<insert SmartDialog title>" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "?" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   NOT-VISIBLE FRAME-NAME Custom                                        */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE
       FRAME D-Dialog:PRIVATE-DATA     = 
                "sdfsdfsdfsdfsdf".

/* SETTINGS FOR FILL-IN Almmmatg.codmat IN FRAME D-Dialog
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN Almmmatg.DesMar IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Almmmatg.DesMat IN FRAME D-Dialog
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-Disponible IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpTot IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_PreUniA IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_PreUniB IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_PreUniC IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_UndA IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_UndB IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_UndC IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "INTEGRAL.Almmmatg"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* <insert SmartDialog title> */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Mas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Mas D-Dialog
ON CHOOSE OF BUTTON-Mas IN FRAME D-Dialog /* + */
DO:

  RUN Verifica-Stock-Mas.
  IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN NO-APPLY.

  ASSIGN 
      FILL-IN-CanPed:SCREEN-VALUE = STRING(DECIMAL(FILL-IN-CanPed:SCREEN-VALUE) + 1) NO-ERROR.
  RUN Graba-Anula-Item.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Menos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Menos D-Dialog
ON CHOOSE OF BUTTON-Menos IN FRAME D-Dialog /* - */
DO:
  DEF VAR X AS DECI NO-UNDO.
  ASSIGN X = DECIMAL(FILL-IN-CanPed:SCREEN-VALUE) - 1 NO-ERROR.
  IF X >= 0 THEN DO:
      FILL-IN-CanPed:SCREEN-VALUE = STRING(X).
      RUN Graba-Anula-Item.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-UndVta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-UndVta D-Dialog
ON VALUE-CHANGED OF COMBO-BOX-UndVta IN FRAME D-Dialog
DO:
  DEF VAR cUndVta AS CHAR NO-UNDO.
  cUndVta = SELF:SCREEN-VALUE.
  RUN Verifica-Stock.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      SELF:SCREEN-VALUE = s-UndVta.
      RETURN NO-APPLY.
  END.
  RUN Graba-Anula-Item.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CanPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CanPed D-Dialog
ON ENTRY OF FILL-IN-CanPed IN FRAME D-Dialog
DO:
  cCanPed = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CanPed D-Dialog
ON LEAVE OF FILL-IN-CanPed IN FRAME D-Dialog
OR RETURN OF FILL-IN-CanPed DO:
  RUN Verifica-Stock.
  IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
      SELF:SCREEN-VALUE = cCanPed.
      RETURN NO-APPLY.
  END.

  RUN Graba-Anula-Item.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME IMAGE_Producto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL IMAGE_Producto D-Dialog
ON MOUSE-SELECT-CLICK OF IMAGE_Producto IN FRAME D-Dialog
DO:
  FOR EACH ITEM:
      MESSAGE codcia codmat canped factor undvta preuni implin s-porigv.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */
ON END-ERROR ANYWHERE DO:
  /* Aprovechamos para verificar las unidades */
    DO WITH FRAME {&FRAME-NAME}:
        DEFINE VAR pCanPed AS DEC NO-UNDO.
        DEFINE VAR pMensaje AS CHAR NO-UNDO.
        DEFINE VAR hProc AS HANDLE NO-UNDO.

        RUN vtagn/ventas-library PERSISTENT SET hProc.
        pCanPed = DECIMAL(FILL-IN-CanPed:SCREEN-VALUE).
        RUN VTA_Valida-Cantidad IN hProc (INPUT Almmmatg.CodMat,
                                          INPUT COMBO-BOX-UndVta:SCREEN-VALUE,
                                          INPUT-OUTPUT pCanPed,
                                          OUTPUT pMensaje).
        DELETE PROCEDURE hProc.
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            FILL-IN-CanPed:SCREEN-VALUE = STRING(pCanPed).
            RUN Graba-Anula-Item.
        END.
    END.
END.

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-CanPed FILL-IN_UndA FILL-IN_PreUniA FILL-IN_UndB 
          FILL-IN_PreUniB FILL-IN_UndC FILL-IN_PreUniC COMBO-BOX-UndVta 
          FILL-IN-Disponible FILL-IN_ImpTot 
      WITH FRAME D-Dialog.
  IF AVAILABLE Almmmatg THEN 
    DISPLAY Almmmatg.codmat Almmmatg.DesMat Almmmatg.DesMar 
      WITH FRAME D-Dialog.
  ENABLE FILL-IN-CanPed COMBO-BOX-UndVta BUTTON-Menos BUTTON-Mas IMAGE_Producto 
      WITH FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Anula-Item D-Dialog 
PROCEDURE Graba-Anula-Item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    CASE TRUE:
        WHEN DECIMAL(FILL-IN-CanPed:SCREEN-VALUE) <= 0 THEN DO:
            FIND FIRST ITEM WHERE ITEM.codmat = Almmmatg.codmat NO-ERROR.
            IF AVAILABLE ITEM THEN DELETE ITEM.
            DISPLAY 0 @ FILL-IN_ImpTot. 
        END.
        OTHERWISE DO:
            FIND FIRST ITEM WHERE ITEM.codmat = Almmmatg.codmat EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE ITEM THEN CREATE ITEM.
            ASSIGN
                ITEM.CodCia = Almmmatg.codcia
                ITEM.codmat = Almmmatg.codmat
                ITEM.CanPed = DECIMAL(FILL-IN-CanPed:SCREEN-VALUE)
                ITEM.Factor = 1
                ITEM.UndVta = COMBO-BOX-UndVta:SCREEN-VALUE
                ITEM.AlmDes = x-CodAlm.
            FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.undbas AND
                Almtconv.Codalter = ITEM.UndVta NO-LOCK NO-ERROR.
            IF AVAILABLE Almtconv THEN ITEM.Factor = Almtconv.Equival.
            /* Calculamos importes */
            RUN {&precio-venta-general} (s-CodCia,
                                         s-CodDiv,
                                         s-CodCli,
                                         s-CodMon,
                                         s-TpoCmb,
                                         OUTPUT f-Factor,
                                         Almmmatg.codmat,
                                         s-FlgSit,
                                         COMBO-BOX-UndVta:SCREEN-VALUE,
                                         f-CanPed,
                                         s-NroDec,
                                         x-CodAlm,
                                         OUTPUT f-PreBas,
                                         OUTPUT f-PreVta,
                                         OUTPUT f-Dsctos,
                                         OUTPUT y-Dsctos,
                                         OUTPUT x-TipDto,
                                         OUTPUT f-FleteUnitario,
                                         OUTPUT pMensaje
                                         ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
            s-UndVta = COMBO-BOX-UndVta:SCREEN-VALUE.
            ASSIGN 
                ITEM.Factor = F-FACTOR
                ITEM.PorDto = f-Dsctos
                ITEM.PreBas = F-PreBas 
                ITEM.PreVta[1] = F-PreVta     /* CONTROL DE PRECIO DE LISTA */
                ITEM.AftIgv = Almmmatg.AftIgv
                ITEM.AftIsc = Almmmatg.AftIsc
                ITEM.Libre_c04 = x-TipDto.
            ASSIGN 
                ITEM.PreUni = f-PreVta
                ITEM.Por_Dsctos[1] = 0
                ITEM.Por_Dsctos[2] = 0
                ITEM.Por_Dsctos[3] = y-Dsctos
                ITEM.Libre_d02     = f-FleteUnitario.
            ASSIGN
                ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                              ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                              ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                              ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
            IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
                THEN ITEM.ImpDto = 0.
            ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
            IF f-FleteUnitario > 0 THEN DO:
                /* El flete afecta el monto final */
                IF ITEM.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
                    ASSIGN
                        ITEM.PreUni = ROUND(f-PreVta + f-FleteUnitario, s-NroDec)  /* Incrementamos el PreUni */
                        ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni.
                END.
                ELSE DO:      /* CON descuento promocional o volumen */
                    /* El flete afecta al precio unitario resultante */
                    DEF VAR x-PreUniFin LIKE Facdpedi.PreUni NO-UNDO.
                    DEF VAR x-PreUniTeo LIKE Facdpedi.PreUni NO-UNDO.
                    
                    x-PreUniFin = ITEM.ImpLin / ITEM.CanPed.          /* Valor resultante */
                    x-PreUniFin = x-PreUniFin + f-FleteUnitario.      /* Unitario Afectado al Flete */
                    x-PreUniTeo = x-PreUniFin / ( ( 1 - ITEM.Por_Dsctos[1] / 100 ) * ( 1 - ITEM.Por_Dsctos[2] / 100 ) * ( 1 - ITEM.Por_Dsctos[3] / 100 ) ).
                    ASSIGN
                        ITEM.PreUni = ROUND(x-PreUniTeo, s-NroDec).
                END.
                ASSIGN
                    ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                                          ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                                          ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                                          ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
                IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
                    THEN ITEM.ImpDto = 0.
                ELSE ITEM.ImpDto = (ITEM.CanPed * ITEM.PreUni) - ITEM.ImpLin.
            END.
            /* ***************************************************************** */
            ASSIGN
                ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
                ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
            IF ITEM.AftIsc 
                THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
            ELSE ITEM.ImpIsc = 0.
            IF ITEM.AftIgv 
                THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
            ELSE ITEM.ImpIgv = 0.
            DISPLAY ITEM.ImpLin @ FILL-IN_ImpTot. 
        END.
    END CASE.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
      RUN Pinta_Precio_Unidades.
      COMBO-BOX-UndVta:DELIMITER = CHR(9).
      IF Almmmatg.UndA > '' THEN DO:
          COMBO-BOX-UndVta:ADD-LAST(Almmmatg.UndA).
          COMBO-BOX-UndVta = Almmmatg.UndA.
      END.
      IF Almmmatg.UndB > '' THEN COMBO-BOX-UndVta:ADD-LAST(Almmmatg.UndB).
      IF Almmmatg.UndC > '' THEN COMBO-BOX-UndVta:ADD-LAST(Almmmatg.UndC).

      FIND ITEM WHERE ITEM.codmat = pCodMat NO-LOCK NO-ERROR.
      IF AVAILABLE ITEM 
          THEN ASSIGN 
                COMBO-BOX-UndVta    = ITEM.undvta 
                FILL-IN-CanPed      = ITEM.canped
                s-UndVta            = ITEM.UndVta
                FILL-IN_ImpTot      = ITEM.ImpLin.
      /* *********************************************************************************** */
      /* STOCK COMPROMETIDO */
      /* *********************************************************************************** */
      DEF VAR s-StkComprometido AS DEC NO-UNDO.
      DEF VAR x-StkAct AS DEC NO-UNDO.
      DEF VAR x-CanPed AS DEC NO-UNDO.

      FIND Almmmate OF Almmmatg WHERE Almmmate.codalm = x-codalm NO-LOCK NO-ERROR.
      ASSIGN
          x-StkAct = Almmmate.StkAct.
      IF x-StkAct > 0 THEN DO:
          RUN gn/Stock-Comprometido-v2 (Almmmatg.CodMat, 
                                        x-CodAlm, 
                                        YES,    /* Tomar en cuenta venta contado */
                                        OUTPUT s-StkComprometido).
      END.
      s-StkDis = x-StkAct - s-StkComprometido.
      FILL-IN-Disponible = TRIM(STRING(s-StkDis, '->>>,>>>,>>9.99')) + ' ' + Almmmatg.UndBas.
      /* *********************************************************************************** */
      /* *********************************************************************************** */
      DEF VAR x-Imagen AS CHAR NO-UNDO.

      x-Imagen = "Productos\" + TRIM(Almmmatg.codmat) + ".jpg".

      IF SEARCH(x-Imagen) <> ? THEN IMAGE_Producto:LOAD-IMAGE(x-Imagen).
      ELSE DO:
          x-Imagen = "Productos\ProdImg.bmp".
          IF SEARCH(x-Imagen) <> ? THEN IMAGE_Producto:LOAD-IMAGE(x-Imagen).
      END.

  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta_Precio_Unidades D-Dialog 
PROCEDURE Pinta_Precio_Unidades :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        FILL-IN_PreUniA = 0
        FILL-IN_PreUniB = 0
        FILL-IN_PreUniC = 0
        FILL-IN_UndA = ''
        FILL-IN_UndB = ''
        FILL-IN_UndC = ''.
    DISPLAY FILL-IN_UndA FILL-IN_UndB FILL-IN_UndC.
    DISPLAY FILL-IN_PreUniA FILL-IN_PreUniB FILL-IN_PreUniC.
    ASSIGN
        FILL-IN_UndA = Almmmatg.UndA 
        FILL-IN_UndB = Almmmatg.UndB 
        FILL-IN_UndC = Almmmatg.UndC.
    /* Precios */
  /* ***************************************************************************************************************** */
  /* 22/05/2023 PRECIO UNITARIO */
  /* ***************************************************************************************************************** */
  /* Unidad A */
  f-CanPed = 1.
  IF Almmmatg.UndA > '' THEN DO:
      s-UndVta = Almmmatg.UndA.
      RUN {&precio-venta-general} (s-CodCia,
                                   s-CodDiv,
                                   s-CodCli,
                                   s-CodMon,
                                   s-TpoCmb,
                                   OUTPUT f-Factor,
                                   Almmmatg.codmat,
                                   s-FlgSit,
                                   s-UndVta,
                                   f-CanPed,
                                   s-NroDec,
                                   x-CodAlm,
                                   OUTPUT f-PreBas,
                                   OUTPUT f-PreVta,
                                   OUTPUT f-Dsctos,
                                   OUTPUT y-Dsctos,
                                   OUTPUT x-TipDto,
                                   OUTPUT f-FleteUnitario,
                                   OUTPUT pMensaje
                                   ).
      IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.
      x-Factor = f-Factor.
      IF f-PreVta > 0 THEN FILL-IN_PreUniA = f-PreVta.
      /* Unidad B */
      IF Almmmatg.UndB > '' THEN DO:
          FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas AND
              Almtconv.Codalter = Almmmatg.UndB NO-LOCK NO-ERROR.
          IF AVAILABLE Almtconv THEN DO:
              FILL-IN_PreUniB = f-PreVta / x-factor * Almtconv.Equival.
          END.
      END.
      /* Unidad C */
      IF Almmmatg.UndC > '' THEN DO:
          FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas AND
              Almtconv.Codalter = Almmmatg.UndC NO-LOCK NO-ERROR.
          IF AVAILABLE Almtconv THEN DO:
              FILL-IN_PreUniC = f-PreVta / x-factor * Almtconv.Equival.
          END.
      END.
  END.
  DISPLAY FILL-IN_UndA FILL-IN_UndB FILL-IN_UndC.
  DISPLAY FILL-IN_PreUniA FILL-IN_PreUniB FILL-IN_PreUniC.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "Almmmatg"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Stock D-Dialog 
PROCEDURE Verifica-Stock :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR f-CanPed AS DECI NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN 
          f-CanPed = DECIMAL(FILL-IN-CanPed:SCREEN-VALUE) NO-ERROR.
      IF ERROR-STATUS:ERROR = YES THEN RETURN 'ADM-ERROR'.

      f-Factor = 1.
      FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.undbas AND
          Almtconv.Codalter = COMBO-BOX-UndVta:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF AVAILABLE ALmtconv THEN  f-factor = Almtconv.Equival.

      /* *********************************************************************************** */
      /* STOCK COMPROMETIDO */
      /* *********************************************************************************** */
      DEF VAR x-CanPed AS DEC NO-UNDO.

      ASSIGN
          x-CanPed = f-CanPed * f-Factor.
      IF s-StkDis < x-CanPed
          THEN DO:
            MESSAGE "No hay STOCK suficiente" SKIP(1)
                    "   STOCK DISPONIBLE : " s-StkDis Almmmatg.undbas SKIP
                    VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Verifica-Stock-Mas D-Dialog 
PROCEDURE Verifica-Stock-Mas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR f-CanPed AS DECI NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN 
          f-CanPed = DECIMAL(FILL-IN-CanPed:SCREEN-VALUE) + 1 NO-ERROR.
      IF ERROR-STATUS:ERROR = YES THEN RETURN 'ADM-ERROR'.

      f-Factor = 1.
      FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.undbas AND
          Almtconv.Codalter = COMBO-BOX-UndVta:SCREEN-VALUE
          NO-LOCK NO-ERROR.
      IF AVAILABLE ALmtconv THEN  f-factor = Almtconv.Equival.

      /* *********************************************************************************** */
      /* STOCK COMPROMETIDO */
      /* *********************************************************************************** */
      DEF VAR x-CanPed AS DEC NO-UNDO.

      ASSIGN
          x-CanPed = f-CanPed * f-Factor.
      IF s-StkDis < x-CanPed
          THEN DO:
            MESSAGE "No hay STOCK suficiente" SKIP(1)
                    "   STOCK DISPONIBLE : " s-StkDis Almmmatg.undbas SKIP
                    VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
      END.

/*       DEF VAR s-StkComprometido AS DEC NO-UNDO.                                                  */
/*       DEF VAR x-StkAct AS DEC NO-UNDO.                                                           */
/*       DEF VAR x-CanPed AS DEC NO-UNDO.                                                           */
/*                                                                                                  */
/*       FIND Almmmate OF Almmmatg WHERE Almmmate.codalm = x-codalm NO-LOCK NO-ERROR.               */
/*       ASSIGN                                                                                     */
/*           x-StkAct = Almmmate.StkAct.                                                            */
/*       IF x-StkAct > 0 THEN DO:                                                                   */
/*           RUN gn/Stock-Comprometido-v2 (Almmmatg.CodMat,                                         */
/*                                         x-CodAlm,                                                */
/*                                         YES,    /* Tomar en cuenta venta contado */              */
/*                                         OUTPUT s-StkComprometido).                               */
/*       END.                                                                                       */
/*       ASSIGN                                                                                     */
/*           x-CanPed = f-CanPed * f-Factor.                                                        */
/*       IF (x-StkAct - s-StkComprometido) < x-CanPed                                               */
/*           THEN DO:                                                                               */
/*             MESSAGE "No hay STOCK suficiente" SKIP(1)                                            */
/*                     "       STOCK ACTUAL : " x-StkAct Almmmatg.undbas SKIP                       */
/*                     "  STOCK COMPROMETIDO: " s-StkComprometido Almmmatg.undbas SKIP              */
/*                     "   STOCK DISPONIBLE : " (x-StkAct - s-StkComprometido) Almmmatg.undbas SKIP */
/*                     VIEW-AS ALERT-BOX ERROR.                                                     */
/*             RETURN 'ADM-ERROR'.                                                                  */
/*       END.                                                                                       */
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

