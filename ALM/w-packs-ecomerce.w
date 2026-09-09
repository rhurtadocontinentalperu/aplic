&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE T-DTabla LIKE VtaDTabla.



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
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

DEFINE VAR x-Archivo AS CHAR.

DEFINE TEMP-TABLE ttHeader
    FIELDS  tCodKit AS  CHAR    FORMAT 'x(6)'
    FIELDS  tDesKit AS  CHAR    FORMAT 'x(60)'
    FIELDS  tqtykit AS  DEC     INIT 0
    FIELDS  tobskit AS  CHAR    FORMAT 'x(60)'
    INDEX idx01 IS PRIMARY tCodKit.

DEFINE TEMP-TABLE ttDetalle
    FIELDS  tCodKit AS  CHAR     FORMAT 'x(6)'
    FIELDS  tCodMat AS  CHAR     FORMAT 'x(6)'
    FIELDS  tqtydtl AS  DEC      INIT 0
    INDEX idx01 IS PRIMARY tCodKit tCodMat.

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
&Scoped-Define ENABLED-OBJECTS btnFromExcel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-navico AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv09 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-updv12 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q-packs-ecomerce AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-packs-ecomerce AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-packs-ecomerce-dtl-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v-packs-ecomerce-dtl-upd AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnFromExcel 
     LABEL "Desde Excel" 
     SIZE 20 BY 1.12.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     btnFromExcel AT ROW 7.15 COL 35 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.43 BY 22.85 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Design Page: 1
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: T-DTabla T "NEW SHARED" ? INTEGRAL VtaDTabla
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Mantenimiento PACKS-eCOMERCE"
         HEIGHT             = 22.85
         WIDTH              = 91.43
         MAX-HEIGHT         = 22.85
         MAX-WIDTH          = 118.57
         VIRTUAL-HEIGHT     = 22.85
         VIRTUAL-WIDTH      = 118.57
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

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Mantenimiento PACKS-eCOMERCE */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Mantenimiento PACKS-eCOMERCE */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnFromExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnFromExcel W-Win
ON CHOOSE OF btnFromExcel IN FRAME F-Main /* Desde Excel */
DO:
  
        MESSAGE 'Desea cargar informacion desde Excel?' VIEW-AS ALERT-BOX QUESTION
                BUTTONS YES-NO UPDATE rpta AS LOG.
        IF rpta = NO THEN RETURN NO-APPLY.

    RUN from-excel.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

ASSIGN lh_Handle = THIS-PROCEDURE.

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
             INPUT  'src/adm/objects/p-navico.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navico ).
       RUN set-position IN h_p-navico ( 1.00 , 6.00 ) NO-ERROR.
       RUN set-size IN h_p-navico ( 1.54 , 23.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv09.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv09 ).
       RUN set-position IN h_p-updv09 ( 1.00 , 30.00 ) NO-ERROR.
       RUN set-size IN h_p-updv09 ( 1.42 , 49.86 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/v-packs-ecomerce.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-packs-ecomerce ).
       RUN set-position IN h_v-packs-ecomerce ( 2.54 , 5.00 ) NO-ERROR.
       /* Size in UIB:  ( 4.38 , 85.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/q-packs-ecomerce.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_q-packs-ecomerce ).
       RUN set-position IN h_q-packs-ecomerce ( 7.35 , 74.00 ) NO-ERROR.
       /* Size in UIB:  ( 0.88 , 17.57 ) */

       /* Links to SmartViewer h_v-packs-ecomerce. */
       RUN add-link IN adm-broker-hdl ( h_p-updv09 , 'TableIO':U , h_v-packs-ecomerce ).
       RUN add-link IN adm-broker-hdl ( h_q-packs-ecomerce , 'Record':U , h_v-packs-ecomerce ).

       /* Links to SmartQuery h_q-packs-ecomerce. */
       RUN add-link IN adm-broker-hdl ( h_p-navico , 'Navigation':U , h_q-packs-ecomerce ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navico ,
             btnFromExcel:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv09 ,
             h_p-navico , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-packs-ecomerce ,
             h_p-updv09 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_q-packs-ecomerce ,
             btnFromExcel:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */
    WHEN 1 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/v-packs-ecomerce-dtl.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v-packs-ecomerce-dtl-2 ).
       RUN set-position IN h_v-packs-ecomerce-dtl-2 ( 8.50 , 4.00 ) NO-ERROR.
       RUN set-size IN h_v-packs-ecomerce-dtl-2 ( 12.69 , 85.00 ) NO-ERROR.

       /* Links to SmartBrowser h_v-packs-ecomerce-dtl-2. */
       RUN add-link IN adm-broker-hdl ( h_q-packs-ecomerce , 'Record':U , h_v-packs-ecomerce-dtl-2 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_v-packs-ecomerce-dtl-2 ,
             btnFromExcel:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 1 */
    WHEN 2 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/alm/v-packs-ecomerce-dtl-upd.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  '':U ,
             OUTPUT h_v-packs-ecomerce-dtl-upd ).
       /* Position in AB:  ( 8.35 , 4.00 ) */
       /* Size in UIB:  ( 12.69 , 85.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'src/adm-vm/objects/p-updv12.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-updv12 ).
       RUN set-position IN h_p-updv12 ( 21.38 , 19.00 ) NO-ERROR.
       RUN set-size IN h_p-updv12 ( 1.42 , 34.14 ) NO-ERROR.

       /* Links to  h_v-packs-ecomerce-dtl-upd. */
       RUN add-link IN adm-broker-hdl ( h_p-updv12 , 'TableIO':U , h_v-packs-ecomerce-dtl-upd ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-updv12 ,
             btnFromExcel:HANDLE IN FRAME F-Main , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-excel-a-temporal W-Win 
PROCEDURE cargar-excel-a-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

DEFINE VAR cValor AS CHAR.
DEFINE VAR cCodKit AS CHAR.
DEFINE VAR cCodMat AS CHAR.
DEFINE VAR iValor AS INT.
DEFINE VAR dValor AS DEC.
DEFINE VAR x-paso AS LOG.

DEFINE VAR x-despack AS CHAR.

lFileXls = x-archivo.           /* Nombre el archivo a abrir o crear, vacio solo para nuevos */
lNuevoFile = NO.                            /* Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = NO. /* Si permanece abierto el Excel luego de concluir el proceso */

iColumn = 1.

/* Verificar Estructura */
x-paso = YES.
REPEAT iColumn = 1 TO 1 :
    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    cValor = CAPS(TRIM(chWorkSheet:Range(cRange):TEXT)).
    IF cValor <> 'KIT' THEN x-paso = NO.

    cRange = "D" + cColumn.
    cValor = CAPS(TRIM(chWorkSheet:Range(cRange):TEXT)).
    IF cValor <> 'RELACIONADO' THEN x-paso = NO.

    cRange = "G" + cColumn.
    cValor = CAPS(TRIM(chWorkSheet:Range(cRange):TEXT)).
    IF cValor <> 'CANTIDAD' THEN x-paso = NO.

END.

IF x-paso = NO THEN DO:
    MESSAGE "La plantilla del Excel no es la correcta".
    RETURN.
END.

SESSION:SET-WAIT-STATE('GENERAL').

EMPTY TEMP-TABLE ttHeader.
EMPTY TEMP-TABLE ttDetalle.

/* Cargamos en Archivo temporal */
REPEAT iColumn = 2 TO 65000 :
    
    /* Codigo del PACK */
    cColumn = STRING(iColumn).
    cRange = "A" + cColumn.
    cValor = CAPS(TRIM(chWorkSheet:Range(cRange):TEXT)) NO-ERROR.

    IF cValor = "" OR cValor = ? THEN LEAVE.    /* FIN DE DATOS */

    cRange = "G" + cColumn.
    dValor = chWorkSheet:Range(cRange):VALUE.

    /* Solo para mayores que CERO */
    IF dValor <= 0 THEN NEXT.

    
    /* Reacomodamos el Codigo */
    iValor = INTEGER(cValor).
    cCodKit = STRING(iValor,"999999").

    /* Verificamos que el Codigo del PACK se encuentre en el maestro de Articulos */
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                almmmatg.codmat = cCodKit NO-LOCK NO-ERROR.

    IF NOT AVAILABLE almmmatg THEN NEXT.

    x-despack = almmmatg.desmat.

    /* Codigo del Articulo */
    
    cRange = "D" + cColumn.
    cValor = CAPS(TRIM(chWorkSheet:Range(cRange):TEXT)).
    /* Reacomodamos el Codigo */
    
    iValor = INTEGER(cValor).
    cCodMat = STRING(iValor,"999999").
    

    /* Verificamos que el Codigo del ARTICULO se encuentre en el maestro de Articulos */
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                almmmatg.codmat = cCodMat NO-LOCK NO-ERROR.

    IF NOT AVAILABLE almmmatg THEN NEXT.

    /* Cargamos el temporal */
    FIND FIRST ttHeader WHERE ttHeader.tCodKit = cCodKit NO-ERROR.

    IF NOT AVAILABLE ttHeader THEN DO:
        CREATE ttHeader.

        ASSIGN ttHeader.tCodKit = cCodKit
                ttHeader.tDeskit = x-despack
                ttHeader.tQtykit = 0
                ttHeader.tObsKit = "Desde Excel".
    END.

    FIND FIRST ttDetalle WHERE ttDetalle.tCodkit = ttHeader.tCodKit AND
                                ttDetalle.tCodMat = cCodMat NO-ERROR.
    IF NOT AVAILABLE ttDetalle THEN DO:
        CREATE ttDetalle.
            ASSIGN ttDetalle.tCodKit = ttHeader.tCodKit
                    ttDetalle.tCodMat = cCodMat
                    ttDetalle.tQtyDtl = dValor.
    END.

END.

{lib\excel-close-file.i}

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/*
DEFINE TEMP-TABLE ttHeader
    FIELDS  tCodKit AS  CHAR    FORMAT 'x(6)'
    FIELDS  tDesKit AS  CHAR    FORMAT 'x(60)'
    FIELDS  tqtykit AS  DEC     INIT 0
    FIELDS  tobskit AS  CHAR    FORMAT 'x(60)'.

DEFINE TEMP-TABLE ttDetalle
    FIELDS  tCodKit AS  CHAR     FORMAT 'x(6)'
    FIELDS  tCodMat AS  CHAR     FORMAT 'x(6)'
    FIELDS  tqtydtl AS  DEC      INIT 0.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-temporal-a-bd W-Win 
PROCEDURE cargar-temporal-a-bd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST ttHeader NO-ERROR.

IF NOT AVAILABLE ttHeader THEN DO:
    MESSAGE "No existe informacion a cargar".
    RETURN.
END.

DEFINE VAR x-header AS LOG.

SESSION:SET-WAIT-STATE('GENERAL').

FOR EACH ttHeader :
    FIND FIRST vtactabla WHERE vtactabla.codcia = s-codcia AND 
                                vtactabla.tabla = 'PACKS-ECOMERCE' AND 
                                vtactabla.llave = ttHeader.tCodkit NO-ERROR.
    IF AVAILABLE vtactabla THEN DO:
        ASSIGN vtactabla.libre_d01 = 0.
    END.
END.

/* - */
tPrincipal:
FOR EACH ttHeader NO-LOCK TRANSACTION ON ERROR UNDO, NEXT ON STOP UNDO, NEXT :
    /* Grabar la CABECERA */
    /* Verificar si ya existe */
    FIND FIRST vtactabla WHERE vtactabla.codcia = s-codcia AND 
                                vtactabla.tabla = 'PACKS-ECOMERCE' AND 
                                vtactabla.llave = ttHeader.tCodkit NO-ERROR.
    IF NOT AVAILABLE vtactabla THEN DO:
        CREATE vtactabla.
        ASSIGN vtactabla.codcia = s-codcia
              vtactabla.tabla = 'PACKS-ECOMERCE'
              vtactabla.llave = ttHeader.tCodkit
              vtactabla.libre_d01 = 0
              vtactabla.fchcreacion = TODAY
              vtactabla.usrcreacion = s-user-id NO-ERROR.
    END.
    
    ASSIGN
          vtactabla.descripcion = ttHeader.tDesKit          
          vtactabla.libre_c01 = 'Desde Excel'
          vtactabla.fchcreacion = TODAY
          vtactabla.usrcreacion = s-user-id NO-ERROR.

    RUN cargar-temporal-detalle(INPUT ttHeader.tCodKit).

    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        UNDO tPrincipal, NEXT tPrincipal.
    END.

END.


SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-temporal-detalle W-Win 
PROCEDURE cargar-temporal-detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodKit AS CHAR.

DEFINE BUFFER b-vtadtabla FOR vtadtabla.
DEFINE VAR x-rowid AS ROWID.

tDetalle:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":    

    /* Eliminar los anteriores */
    FOR EACH vtadtabla WHERE vtadtabla.codcia = s-codcia AND 
                            vtadtabla.tabla = 'PACKS-ECOMERCE' AND 
                            vtadtabla.llave = pCodKit NO-LOCK:
        x-rowid = ROWID(vtadtabla).
        FIND FIRST b-vtadtabla WHERE ROWID(b-vtadtabla) = x-rowid NO-ERROR.
        IF AVAILABLE b-vtadtabla THEN DO:
            DELETE b-vtadtabla NO-ERROR.
            If ERROR-STATUS:ERROR = YES THEN DO:
                UNDO tDetalle, RETURN 'ADM-ERROR'.
            END.
        END.
    END.

    FOR EACH ttDetalle WHERE ttDetalle.tcodkit = ttHeader.tcodkit NO-LOCK:
        /* Grabar la DETALLE */
        CREATE vtadtabla.
    
        ASSIGN vtadtabla.codcia = s-codcia
              vtadtabla.tabla = 'PACKS-ECOMERCE'
              vtadtabla.llave = ttHeader.tCodkit
              vtadtabla.llavedetalle = ttDetalle.tCodMat
              vtadtabla.libre_d01 = ttDetalle.tQtyDtl NO-ERROR.
        If ERROR-STATUS:ERROR = YES THEN DO:
            UNDO tDetalle, RETURN 'ADM-ERROR'.
        END.
    
        ASSIGN vtactabla.libre_d01 = vtactabla.libre_d01 + ttDetalle.tQtyDtl.
            
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
  ENABLE btnFromExcel 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE from-excel W-Win 
PROCEDURE from-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR OkPressed AS LOG.           
           
SYSTEM-DIALOG GET-FILE x-Archivo
    FILTERS "Archivo (*.xlsx)" "*.xlsx"
    MUST-EXIST
    TITLE "Seleccione archivo..."
    UPDATE OKpressed.   
IF OKpressed = NO THEN RETURN.

RUN cargar-excel-a-temporal.
RUN cargar-temporal-a-bd.

RUN dispatch IN h_q-packs-ecomerce('open-query':U ).

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

   RUN Procesa-Handle IN lh_Handle ('Pagina1') NO-ERROR.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-handle W-Win 
PROCEDURE procesa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER lh_signal AS CHAR NO-UNDO.

CASE lh_signal: 
    WHEN "Pagina1"  THEN DO WITH FRAME {&FRAME-NAME}:
        btnFromExcel:VISIBLE = YES.
        RUN select-page(1).
        RUN dispatch IN h_v-packs-ecomerce-dtl-2 ('open-query':U).
    END.
    WHEN "Pagina2"  THEN DO WITH FRAME {&FRAME-NAME}:
       RUN select-page(2).
       btnFromExcel:VISIBLE = NO.
    END.
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

