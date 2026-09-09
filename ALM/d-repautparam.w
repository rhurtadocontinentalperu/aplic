&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF INPUT PARAMETER pDia AS INT.
DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pError AS LOG.

/* NOTA:
Si pRowid = ? entonces es un NUEVO registro 
*/

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR pv-codcia AS INT.

pError = YES.   /* Valor por defecto */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN_Orden TOGGLE-Aprobar FILL-IN_CodAlm ~
FILL-IN_AlmPed EDITOR_Lineas BUTTON-999 EDITOR_SubLineas BUTTON-1000 ~
EDITOR_Marcas BUTTON-1001 EDITOR_Proveedores BUTTON-1002 FILL-IN_PorRep ~
COMBO-BOX_Tipo SELECTION-LIST_Clasificacion FILL-IN_PorStkMax ~
COMBO-BOX_Motivo FILL-IN_Glosa EDITOR_Sector BUTTON-1004 Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_Orden TOGGLE-Aprobar ~
FILL-IN_CodAlm FILL-IN-NomAlm FILL-IN_AlmPed FILL-IN-NomPed EDITOR_Lineas ~
EDITOR_SubLineas EDITOR_Marcas EDITOR_Proveedores FILL-IN_PorRep ~
COMBO-BOX_Tipo SELECTION-LIST_Clasificacion FILL-IN_PorStkMax ~
COMBO-BOX_Motivo FILL-IN_Glosa EDITOR_Sector 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Cancel" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.62
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-1000 
     IMAGE-UP FILE "img/find.bmp":U
     LABEL "" 
     SIZE 4 BY 1.08.

DEFINE BUTTON BUTTON-1001 
     IMAGE-UP FILE "img/find.bmp":U
     LABEL "" 
     SIZE 4 BY 1.08.

DEFINE BUTTON BUTTON-1002 
     IMAGE-UP FILE "img/find.bmp":U
     LABEL "" 
     SIZE 4 BY 1.08.

DEFINE BUTTON BUTTON-1004 
     IMAGE-UP FILE "img/find.bmp":U
     LABEL "" 
     SIZE 4 BY 1.08.

DEFINE BUTTON BUTTON-999 
     IMAGE-UP FILE "img/find.bmp":U
     LABEL "" 
     SIZE 4 BY 1.08.

DEFINE VARIABLE COMBO-BOX_Motivo AS CHARACTER FORMAT "x(8)" INITIAL "Seleccione un motivo" 
     LABEL "Motivo" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEM-PAIRS "Seleccione un motivo","Seleccione un motivo"
     DROP-DOWN-LIST
     SIZE 53 BY 1.

DEFINE VARIABLE COMBO-BOX_Tipo AS CHARACTER FORMAT "x(20)" INITIAL "General" 
     LABEL "Clasificación" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "General","Mayorista","Utilex" 
     DROP-DOWN-LIST
     SIZE 16 BY 1.

DEFINE VARIABLE EDITOR_Lineas AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 30 BY 2.42.

DEFINE VARIABLE EDITOR_Marcas AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 30 BY 2.42.

DEFINE VARIABLE EDITOR_Proveedores AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 30 BY 2.42.

DEFINE VARIABLE EDITOR_Sector AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 30 BY 2.42.

DEFINE VARIABLE EDITOR_SubLineas AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 30 BY 2.42.

DEFINE VARIABLE FILL-IN-NomAlm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPed AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN_AlmPed AS CHARACTER FORMAT "x(8)" 
     LABEL "Almacén Despacho" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .81.

DEFINE VARIABLE FILL-IN_CodAlm AS CHARACTER FORMAT "x(8)" 
     LABEL "Almacén Solicitante" 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .81.

DEFINE VARIABLE FILL-IN_Glosa AS CHARACTER FORMAT "x(60)" 
     LABEL "Glosa" 
     VIEW-AS FILL-IN 
     SIZE 53 BY .81.

DEFINE VARIABLE FILL-IN_Orden AS INTEGER FORMAT ">,>>9" INITIAL 0 
     LABEL "Orden" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .81.

DEFINE VARIABLE FILL-IN_PorRep AS DECIMAL FORMAT ">>9.99" INITIAL 100 
     LABEL "% de Reposición" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .81.

DEFINE VARIABLE FILL-IN_PorStkMax AS DECIMAL FORMAT ">>9.99" INITIAL 100 
     LABEL "% de Stock Máximo" 
     VIEW-AS FILL-IN 
     SIZE 8.57 BY .81.

DEFINE VARIABLE SELECTION-LIST_Clasificacion AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE 
     LIST-ITEM-PAIRS "Sin Clasificacion","",
                     "A","A",
                     "B","B",
                     "C","C",
                     "D","D",
                     "E","E",
                     "F","F",
                     "N","N" 
     SIZE 13 BY 4.31.

DEFINE VARIABLE TOGGLE-Aprobar AS LOGICAL INITIAL no 
     LABEL "Generar Automáticamente OTR" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .77
     BGCOLOR 14 FGCOLOR 0 FONT 6 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN_Orden AT ROW 1.27 COL 16 COLON-ALIGNED WIDGET-ID 40
     TOGGLE-Aprobar AT ROW 1.27 COL 31 WIDGET-ID 126
     FILL-IN_CodAlm AT ROW 2.08 COL 16 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-NomAlm AT ROW 2.08 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 122
     FILL-IN_AlmPed AT ROW 2.88 COL 16 COLON-ALIGNED WIDGET-ID 4
     FILL-IN-NomPed AT ROW 2.88 COL 24 COLON-ALIGNED NO-LABEL WIDGET-ID 124
     EDITOR_Lineas AT ROW 3.69 COL 18 NO-LABEL WIDGET-ID 56
     BUTTON-999 AT ROW 3.69 COL 48 WIDGET-ID 82
     EDITOR_SubLineas AT ROW 3.69 COL 66 NO-LABEL WIDGET-ID 60
     BUTTON-1000 AT ROW 3.69 COL 96 WIDGET-ID 84
     EDITOR_Marcas AT ROW 6.12 COL 18 NO-LABEL WIDGET-ID 64
     BUTTON-1001 AT ROW 6.12 COL 48 WIDGET-ID 86
     EDITOR_Proveedores AT ROW 6.12 COL 66 NO-LABEL WIDGET-ID 68
     BUTTON-1002 AT ROW 6.12 COL 96 WIDGET-ID 88
     FILL-IN_PorRep AT ROW 8.54 COL 16 COLON-ALIGNED WIDGET-ID 42
     COMBO-BOX_Tipo AT ROW 8.54 COL 64 COLON-ALIGNED WIDGET-ID 72
     SELECTION-LIST_Clasificacion AT ROW 8.54 COL 83 NO-LABEL WIDGET-ID 114
     FILL-IN_PorStkMax AT ROW 9.35 COL 16 COLON-ALIGNED WIDGET-ID 44
     COMBO-BOX_Motivo AT ROW 10.15 COL 16 COLON-ALIGNED WIDGET-ID 74
     FILL-IN_Glosa AT ROW 10.96 COL 16 COLON-ALIGNED WIDGET-ID 116
     EDITOR_Sector AT ROW 11.77 COL 18 NO-LABEL WIDGET-ID 78
     BUTTON-1004 AT ROW 11.77 COL 48 WIDGET-ID 118
     Btn_OK AT ROW 15 COL 5
     Btn_Cancel AT ROW 15 COL 20
     "SubLíneas:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 3.69 COL 58 WIDGET-ID 62
     "Marcas:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 6.12 COL 12 WIDGET-ID 66
     "Proveedores:" VIEW-AS TEXT
          SIZE 10 BY .5 AT ROW 6.12 COL 56 WIDGET-ID 70
     "Sector:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 11.77 COL 12 WIDGET-ID 80
     "Líneas:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 3.69 COL 12 WIDGET-ID 58
     SPACE(86.42) SKIP(12.80)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "PARAMETROS"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
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
   FRAME-NAME                                                           */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-NomAlm IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPed IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* PARAMETROS */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel D-Dialog
ON CHOOSE OF Btn_Cancel IN FRAME D-Dialog /* Cancel */
DO:
  pError = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* OK */
DO:
    ASSIGN
        COMBO-BOX_Motivo 
        COMBO-BOX_Tipo 
        EDITOR_Lineas 
        EDITOR_Marcas 
        EDITOR_Proveedores 
        EDITOR_Sector 
        EDITOR_SubLineas 
        FILL-IN_AlmPed 
        FILL-IN_CodAlm 
        FILL-IN_Glosa 
        FILL-IN_Orden 
        FILL-IN_PorRep 
        FILL-IN_PorStkMax 
        SELECTION-LIST_Clasificacion
        TOGGLE-Aprobar
        .

    /* Consistencia */
    IF NOT CAN-FIND(FIRST Almacen WHERE Almacen.codcia = s-codcia
                    AND Almacen.codalm = FILL-IN_CodAlm NO-LOCK)
        THEN DO:
        MESSAGE 'Almacén Solicitante NO registrado' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO FILL-IN_CodAlm.
        RETURN NO-APPLY.
    END.
    IF NOT CAN-FIND(FIRST Almacen WHERE Almacen.codcia = s-codcia
                    AND Almacen.codalm = FILL-IN_AlmPed 
                    AND Almacen.AlmDespacho = YES NO-LOCK)
        THEN DO:
        MESSAGE 'Almacén Despacho NO registrado' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO FILL-IN_AlmPed.
        RETURN NO-APPLY.
    END.
    DEF VAR k AS INT NO-UNDO.
    DO k = 1 TO NUM-ENTRIES(EDITOR_Lineas):
        IF NOT CAN-FIND(FIRST Almtfami WHERE Almtfami.codcia = s-codcia
                        AND Almtfami.codfam = ENTRY(k,EDITOR_Lineas)
                        NO-LOCK) THEN
        DO:
            MESSAGE 'Línea' ENTRY(k,EDITOR_Lineas) 'NO registrado' VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO EDITOR_Lineas.
            RETURN NO-APPLY.
        END.
    END.
    DO k = 1 TO NUM-ENTRIES(EDITOR_SubLineas):
        IF NOT CAN-FIND(FIRST Almsfami WHERE Almsfami.codcia = s-codcia
                        AND Almsfami.codfam = EDITOR_Lineas
                        AND Almsfami.subfam = ENTRY(k,EDITOR_SubLineas)
                        NO-LOCK) THEN
        DO:
            MESSAGE 'SubLínea' ENTRY(k,EDITOR_SubLineas) 'NO registrado' VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO EDITOR_SubLineas.
            RETURN NO-APPLY.
        END.
    END.
    DO k = 1 TO NUM-ENTRIES(EDITOR_Marcas):
        IF NOT CAN-FIND(FIRST Almtabla WHERE Almtabla.Tabla = "MK"
                        AND Almtabla.nombre = ENTRY(k,EDITOR_Marcas)
                        NO-LOCK) THEN
        DO:
            MESSAGE 'Marca' ENTRY(k,EDITOR_Marcas) 'NO registrado' VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO EDITOR_Marcas.
            RETURN NO-APPLY.
        END.
    END.
    DO k = 1 TO NUM-ENTRIES(EDITOR_Proveedores):
        IF NOT CAN-FIND(FIRST gn-prov WHERE gn-prov.codcia = pv-codcia
                        AND gn-prov.codpro = ENTRY(k,EDITOR_Proveedores)
                        NO-LOCK) THEN
        DO:
            MESSAGE 'Proveedor' ENTRY(k,EDITOR_Proveedores) 'NO registrado' VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO EDITOR_Proveedores.
            RETURN NO-APPLY.
        END.
    END.
    IF COMBO-BOX_Motivo BEGINS 'Seleccione' THEN DO:
        MESSAGE 'Seleccione un motivo' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO COMBO-BOX_Motivo.
        RETURN NO-APPLY.
    END.
    DO k = 1 TO NUM-ENTRIES(EDITOR_Sector):
        IF NOT CAN-FIND(FIRST Almtzona WHERE Almtzona.codcia = s-codcia 
                        AND Almtzona.codalm = FILL-IN_AlmPed
                        AND Almtzona.codzona = ENTRY(k,EDITOR_Sector)
                        NO-LOCK) THEN DO:
            MESSAGE 'Sector' ENTRY(k,EDITOR_Sector) 'NO registrado' VIEW-AS ALERT-BOX WARNING.
            APPLY 'ENTRY':U TO EDITOR_Sector.
            RETURN NO-APPLY.
        END.
    END.

    IF TRUE <> (SELECTION-LIST_Clasificacion > '') THEN DO:
        MESSAGE 'Seleccione al menos una clasificación' VIEW-AS ALERT-BOX WARNING.
        APPLY 'ENTRY':U TO SELECTION-LIST_Clasificacion.
        RETURN NO-APPLY.
    END.

    IF pRowid = ? THEN DO:
        CREATE RepAutomParam.
        ASSIGN 
           RepAutomParam.CodCia = s-CodCia
           RepAutomParam.Dia = pDia.
    END.
    ELSE DO:
        {lib/lock-genericov3.i
            &Tabla="RepAutomParam"
            &Condicion="ROWID(RepAutomParam) = pRowid"
            &Bloqueo="EXCLUSIVE-LOCK"
            &Accion="RETRY"
            &Mensaje ="YES"
            &TipoError="UNDO, RETURN NO-APPLY"
            }
    END.
    ASSIGN
        RepAutomParam.AlmPed = FILL-IN_AlmPed 
        RepAutomParam.Clasificacion = SELECTION-LIST_Clasificacion
        RepAutomParam.CodAlm = FILL-IN_CodAlm 
        RepAutomParam.Glosa = FILL-IN_Glosa 
        RepAutomParam.Lineas = EDITOR_Lineas 
        RepAutomParam.Marcas = EDITOR_Marcas 
        RepAutomParam.Motivo = COMBO-BOX_Motivo 
        RepAutomParam.Orden = FILL-IN_Orden 
        RepAutomParam.PorRep = FILL-IN_PorRep 
        RepAutomParam.PorStkMax = FILL-IN_PorStkMax 
        RepAutomParam.Proveedores = EDITOR_Proveedores 
        RepAutomParam.Sector = EDITOR_Sector 
        RepAutomParam.SubLineas = EDITOR_SubLineas 
        RepAutomParam.Tipo = COMBO-BOX_Tipo 
        RepAutomParam.Aprobar = TOGGLE-Aprobar
        .
    RELEASE RepAutomParam.
    pError = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1000
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1000 D-Dialog
ON CHOOSE OF BUTTON-1000 IN FRAME D-Dialog
DO:
    DEF VAR pSubFamilias AS CHAR NO-UNDO.

    IF NUM-ENTRIES(EDITOR_Lineas:SCREEN-VALUE) > 1 THEN RETURN NO-APPLY.
    pSubFamilias = EDITOR_SubLineas:SCREEN-VALUE.
    RUN alm/d-subfamilias.w (INPUT EDITOR_Lineas:SCREEN-VALUE, INPUT-OUTPUT pSubFamilias).
    IF EDITOR_SubLineas:SCREEN-VALUE <> pSubFamilias THEN DO:
        EDITOR_SubLineas:SCREEN-VALUE =''.
    END.
    EDITOR_SubLineas:SCREEN-VALUE = pSubFamilias.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1001
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1001 D-Dialog
ON CHOOSE OF BUTTON-1001 IN FRAME D-Dialog
DO:
    DEF VAR pMarcas AS CHAR NO-UNDO.

    pMarcas = EDITOR_Marcas:SCREEN-VALUE.
    RUN alm/d-marcas-nom.w (INPUT-OUTPUT pMarcas).
    IF EDITOR_Marcas:SCREEN-VALUE <> pMarcas THEN DO:
        EDITOR_Marcas:SCREEN-VALUE =''.
    END.
    EDITOR_Marcas:SCREEN-VALUE = pMarcas.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1004
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1004 D-Dialog
ON CHOOSE OF BUTTON-1004 IN FRAME D-Dialog
DO:
    DEF VAR pSectores AS CHAR NO-UNDO.

    pSectores = EDITOR_Sector:SCREEN-VALUE.
    RUN alm/d-zonas.w (INPUT FILL-IN_AlmPed:SCREEN-VALUE, INPUT-OUTPUT pSectores).
    EDITOR_Sector:SCREEN-VALUE = pSectores.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-999
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-999 D-Dialog
ON CHOOSE OF BUTTON-999 IN FRAME D-Dialog
DO:
  DEF VAR pFamilias AS CHAR NO-UNDO.

  pFamilias = EDITOR_Lineas:SCREEN-VALUE.
  RUN alm/d-familias.w (INPUT-OUTPUT pFamilias).
  IF EDITOR_Lineas:SCREEN-VALUE <> pFamilias THEN DO:
      EDITOR_SubLineas:SCREEN-VALUE =''.
  END.
  EDITOR_Lineas:SCREEN-VALUE = pFamilias.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME EDITOR_Marcas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EDITOR_Marcas D-Dialog
ON LEAVE OF EDITOR_Marcas IN FRAME D-Dialog
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

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
  DISPLAY FILL-IN_Orden TOGGLE-Aprobar FILL-IN_CodAlm FILL-IN-NomAlm 
          FILL-IN_AlmPed FILL-IN-NomPed EDITOR_Lineas EDITOR_SubLineas 
          EDITOR_Marcas EDITOR_Proveedores FILL-IN_PorRep COMBO-BOX_Tipo 
          SELECTION-LIST_Clasificacion FILL-IN_PorStkMax COMBO-BOX_Motivo 
          FILL-IN_Glosa EDITOR_Sector 
      WITH FRAME D-Dialog.
  ENABLE FILL-IN_Orden TOGGLE-Aprobar FILL-IN_CodAlm FILL-IN_AlmPed 
         EDITOR_Lineas BUTTON-999 EDITOR_SubLineas BUTTON-1000 EDITOR_Marcas 
         BUTTON-1001 EDITOR_Proveedores BUTTON-1002 FILL-IN_PorRep 
         COMBO-BOX_Tipo SELECTION-LIST_Clasificacion FILL-IN_PorStkMax 
         COMBO-BOX_Motivo FILL-IN_Glosa EDITOR_Sector BUTTON-1004 Btn_OK 
         Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
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
      COMBO-BOX_Motivo:DELIMITER = '|'.
      FOR EACH FacTabla NO-LOCK WHERE FacTabla.CodCia = s-codcia
          AND FacTabla.Tabla = 'REPOMOTIVO':
          COMBO-BOX_Motivo:ADD-LAST(FacTabla.Nombre, FacTabla.Codigo).
      END.
      IF pRowid <> ? THEN DO:
          FIND RepAutomParam WHERE ROWID(RepAutomParam) = pRowid NO-LOCK.
          ASSIGN
              FILL-IN_Orden = RepAutomParam.Orden 
              FILL-IN_CodAlm = RepAutomParam.CodAlm 
              FILL-IN_AlmPed = RepAutomParam.AlmPed 
              EDITOR_Lineas = RepAutomParam.Lineas 
              EDITOR_SubLineas = RepAutomParam.SubLineas 
              EDITOR_Marcas = RepAutomParam.Marcas 
              EDITOR_Proveedores = RepAutomParam.Proveedores 
              FILL-IN_PorRep = RepAutomParam.PorRep 
              FILL-IN_PorStkMax = RepAutomParam.PorStkMax
              COMBO-BOX_Tipo = RepAutomParam.Tipo 
              SELECTION-LIST_Clasificacion = RepAutomParam.Clasificacion 
              COMBO-BOX_Motivo = RepAutomParam.Motivo 
              FILL-IN_Glosa = RepAutomParam.Glosa 
              EDITOR_Sector = RepAutomParam.Sector 
              TOGGLE-Aprobar = RepAutomParam.Aprobar
              .
      END.
      FIND Almacen WHERE Almacen.codcia = s-codcia
          AND Almacen.codalm = FILL-IN_CodAlm
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen THEN FILL-IN-NomAlm =  Almacen.Descripcion.
      FIND Almacen WHERE Almacen.codcia = s-codcia
          AND Almacen.codalm = FILL-IN_AlmPed
          NO-LOCK NO-ERROR.
      IF AVAILABLE Almacen THEN FILL-IN-NomPed =  Almacen.Descripcion.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

