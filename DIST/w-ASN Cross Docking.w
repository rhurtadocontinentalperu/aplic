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

DEFINE SHARED VAR s-codcia AS INT.

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
&Scoped-Define ENABLED-OBJECTS txtOrdenCompra BtnGenerar 
&Scoped-Define DISPLAYED-OBJECTS txtOrdenCompra 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnGenerar 
     LABEL "Generar" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE txtOrdenCompra AS CHARACTER FORMAT "X(200)":U 
     VIEW-AS FILL-IN 
     SIZE 73 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txtOrdenCompra AT ROW 3.5 COL 1.43 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     BtnGenerar AT ROW 5.04 COL 57 WIDGET-ID 12
     "Generacion ASN Cross Docking" VIEW-AS TEXT
          SIZE 46 BY .96 AT ROW 1.58 COL 17 WIDGET-ID 2
          FGCOLOR 9 FONT 11
     "Ordenes de Compras" VIEW-AS TEXT
          SIZE 19.57 BY .62 AT ROW 2.73 COL 29.43 WIDGET-ID 8
     "(Ejm 9999999, 9999999,99999)" VIEW-AS TEXT
          SIZE 26 BY .62 AT ROW 4.69 COL 25.43 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.86 BY 5.81 WIDGET-ID 100.


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
         TITLE              = "Generacion ASN Cross"
         HEIGHT             = 5.81
         WIDTH              = 80.86
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80.86
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80.86
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
ON END-ERROR OF W-Win /* Generacion ASN Cross */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Generacion ASN Cross */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnGenerar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnGenerar W-Win
ON CHOOSE OF BtnGenerar IN FRAME F-Main /* Generar */
DO:
    ASSIGN txtOrdenCompra.

    IF txtOrdenCompra = '' THEN DO:
        MESSAGE "Ingrese Orden(es) Compra(s)".
    END.
    ELSE DO:
        RUN ue-procesar.
    END.
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
  DISPLAY txtOrdenCompra 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txtOrdenCompra BtnGenerar 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-procesar W-Win 
PROCEDURE ue-procesar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR lOrdenCompra AS CHAR.
DEFINE VAR lSec AS INT.
DEFINE VAR lped AS CHAR.
DEFINE VAR lCot AS CHAR.
DEFINE VAR lTda AS CHAR.
DEFINE VAR lDesTda AS CHAR.
DEFINE VAR ldiv AS CHAR.
DEFINE VAR lprecio AS DEC.

txtOrdenCompra = TRIM(txtOrdenCompra).

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.


lFileXls = "".          /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = YES.       /* YES : Si va crear un nuevo archivo o abrir */


{lib\excel-open-file.i}

SESSION:SET-WAIT-STATE('GENERAL').

chExcelApplication:Visible = FALSE.

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = NO. /* Si permanece abierto el Excel luego de concluir el proceso */

chWorkSheet = chExcelApplication:Sheets:Item(1).  

iColumn = 1.
cColumn = STRING(iColumn).
cRange = "A" + cColumn.
chWorkSheet:Range(cRange):Value = "No.OC".
cRange = "B" + cColumn.
chWorkSheet:Range(cRange):Value = "No Fact.".
cRange = "C" + cColumn.
chWorkSheet:Range(cRange):Value = "LPN".
cRange = "D" + cColumn.
chWorkSheet:Range(cRange):Value = "Local Destino".
cRange = "E" + cColumn.
chWorkSheet:Range(cRange):Value = "SKU".
cRange = "F" + cColumn.
chWorkSheet:Range(cRange):Value = "Cantidad".
cRange = "G" + cColumn.
chWorkSheet:Range(cRange):Value = "Lote".
cRange = "H" + cColumn.
chWorkSheet:Range(cRange):Value = "Fecha Vto".
cRange = "I" + cColumn.
chWorkSheet:Range(cRange):Value = "Costo".

cRange = "K" + cColumn.
chWorkSheet:Range(cRange):Value = "CodArticulo".
cRange = "L" + cColumn.
chWorkSheet:Range(cRange):Value = "Descripcion".
cRange = "M" + cColumn.
chWorkSheet:Range(cRange):Value = "Tienda".
cRange = "N" + cColumn.
chWorkSheet:Range(cRange):Value = "Cotizacion".
cRange = "O" + cColumn.
chWorkSheet:Range(cRange):Value = "Pedido".
cRange = "P" + cColumn.
chWorkSheet:Range(cRange):Value = "O/D".

 DO lSec = 1 TO NUM-ENTRIES(txtOrdenCompra):
    lOrdenCompra = ENTRY(lSec,txtOrdenCompra,",").

    FOR EACH ControlOD WHERE controlOD.codcia = s-codcia AND 
                    controlOD.ordcmp = lOrdenCompra NO-LOCK.
        FOR EACH vtaddoc WHERE vtaddoc.codcia = s-codcia AND
                vtaddoc.coddiv = controlOD.Coddiv AND 
                vtaddoc.codped = controlOD.coddoc AND 
                vtaddoc.nroped = controlOD.Nrodoc AND 
                vtaddoc.libre_c01 = controlOD.nroetq NO-LOCK:

                /* El Local */

                lDesTda = "".
                lTda = "".
                lPed = "".
                lCot = ''.
                /* Ubico la orden de despacho para ver el PEDIDO*/
                FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                        faccpedi.coddoc = 'O/D' AND 
                                        faccpedi.nroped = controlOD.Nrodoc NO-LOCK NO-ERROR.
                IF AVAILABLE faccpedi THEN do:                    
                    lPED = faccpedi.nroref.
                END.
                RELEASE faccpedi.
                /* Busco el PEDIDO  */
                FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                        faccpedi.coddoc = 'PED' AND 
                                        faccpedi.nroped = lPED NO-LOCK NO-ERROR.
                IF AVAILABLE faccpedi THEN do:
                    lCOT = faccpedi.nroref.
                    lDiv = faccpedi.coddiv.
                END.
                RELEASE faccpedi.
                /* COTIZACION */
                FIND FIRST faccpedi WHERE faccpedi.codcia = s-codcia AND
                                        faccpedi.coddoc = 'COT' AND                                     
                                        faccpedi.nroped = lCOT AND
                                        faccpedi.coddiv = ldiv NO-LOCK NO-ERROR.
                IF AVAILABLE faccpedi THEN do:
                    lDesTda = faccpedi.ubigeo[1].
                    lTda = Substring(faccpedi.ubigeo[1],1,4).
                    /*lTda = faccpedi.ubigeo[1].*/
                END.            
                RELEASE faccpedi.

                /**/
                FIND FIRST facdpedi WHERE facdpedi.codcia = s-codcia AND 
                                        facdpedi.coddoc = 'O/D' AND 
                                        facdpedi.nroped = controlOD.Nrodoc AND
                                        facdpedi.codmat = vtaddoc.codmat 
                                        NO-LOCK NO-ERROR.
                lprecio = 0.
                IF AVAILABLE facdpedi THEN lprecio = facdpedi.preuni.

                    FIND FIRST supmmatg WHERE supmmatg.codcia = s-codcia AND 
                                            supmmatg.codcli = faccpedi.codcli AND 
                                            supmmatg.codmat = vtaddoc.codmat NO-LOCK NO-ERROR.
                    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                            almmmatg.codmat = vtaddoc.codmat NO-LOCK NO-ERROR.                

                     iColumn = iColumn + 1.
                     cColumn = STRING(iColumn).
                     cRange = "A" + cColumn.
                     chWorkSheet:Range(cRange):Value = "'" + controlOD.ordcmp.
                     cRange = "B" + cColumn.
                     chWorkSheet:Range(cRange):Value = "'" + controlOD.nrofac.
                     cRange = "C" + cColumn.
                     chWorkSheet:Range(cRange):Value = "'" + controlOD.LPN.
                     cRange = "D" + cColumn.
                     chWorkSheet:Range(cRange):Value = "'" + lTda.
                     IF AVAILABLE supmmatg THEN DO:
                         cRange = "E" + cColumn.
                         chWorkSheet:Range(cRange):Value = "'" +  supmmatg.codartcli.
                     END.
                     cRange = "F" + cColumn.
                     chWorkSheet:Range(cRange):Value = vtaddoc.canped.
                     cRange = "G" + cColumn.
                     chWorkSheet:Range(cRange):Value = 1.
                     cRange = "H" + cColumn.
                     chWorkSheet:Range(cRange):Value = "31/12/2016".
                     cRange = "I" + cColumn.
                     chWorkSheet:Range(cRange):Value = lPrecio.

                     cRange = "K" + cColumn.
                     chWorkSheet:Range(cRange):Value = "'" +  vtaddoc.codmat.
                     IF AVAILABLE almmmatg THEN DO:
                         cRange = "L" + cColumn.
                         chWorkSheet:Range(cRange):Value = "'" +  almmmatg.desmat.
                     END.
                     cRange = "M" + cColumn.
                     chWorkSheet:Range(cRange):Value = "'" +  lDesTda.
                     cRange = "N" + cColumn.
                     chWorkSheet:Range(cRange):Value = "'" +  lCot.
                     cRange = "O" + cColumn.
                     chWorkSheet:Range(cRange):Value = "'" +  lPed.
                     cRange = "P" + cColumn.
                     chWorkSheet:Range(cRange):Value = "'" +  controlOD.Nrodoc.                      
        END.
        
    END. 

 END.

 SESSION:SET-WAIT-STATE('').

{lib\excel-close-file.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

