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
DEFINE VAR p-lfilexls AS CHAR INIT "".

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
&Scoped-Define ENABLED-OBJECTS BtnExcel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnExcel 
     LABEL "Excel" 
     SIZE 15 BY 1.12.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BtnExcel AT ROW 3.69 COL 42 WIDGET-ID 2
     " Genera EXCEL con PRECIOS de articulos" VIEW-AS TEXT
          SIZE 70.57 BY 1.35 AT ROW 1.58 COL 3 WIDGET-ID 4
          BGCOLOR 9 FGCOLOR 15 FONT 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 74.14 BY 5.92 WIDGET-ID 100.


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
         TITLE              = "Excel variacion Precios"
         HEIGHT             = 5.92
         WIDTH              = 74.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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
ON END-ERROR OF W-Win /* Excel variacion Precios */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Excel variacion Precios */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnExcel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnExcel W-Win
ON CHOOSE OF BtnExcel IN FRAME F-Main /* Excel */
DO:
  SESSION:SET-WAIT-STATE('GENERAL').
  RUN ue-gen-excel.
  SESSION:SET-WAIT-STATE('').
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
  ENABLE BtnExcel 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-gen-excel W-Win 
PROCEDURE ue-gen-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE lFileXls                 AS CHARACTER.
DEFINE VARIABLE lNuevoFile               AS LOG.

DEFINE VAR CeldaPrecioOficina AS CHAR.
DEFINE VAR CeldaPrecioLista AS CHAR.
DEFINE VAR CeldaPrecioBase AS CHAR.
DEFINE VAR CeldaDsctoCtgCliente AS CHAR.
DEFINE VAR ExisteDsctoxVol AS LOG.

DEFINE VAR lFiler AS CHAR.

DEF var x-Plantilla AS CHAR NO-UNDO.

GET-KEY-VALUE SECTION 'Plantillas' KEY 'Carpeta' VALUE x-Plantilla .
x-Plantilla = x-Plantilla + "plantilla_mov_precios.xlsx".

lFileXls = x-Plantilla.         /* Nombre el archivo a abrir o crear, vacio es valido solo para nuevos */
lNuevoFile = NO.        /* YES : Si va crear un nuevo archivo o abrir */

{lib\excel-open-file.i}

chExcelApplication:Visible = FALSE.

lMensajeAlTerminar = NO. /*  */
lCerrarAlTerminar = NO. /* Si permanece abierto el Excel luego de concluir el proceso */

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

CeldaPrecioOficina  = "J".
CeldaPrecioLista    = "K".
CeldaPrecioBase     = "L".
CeldaDsctoCtgCliente= "I".

iColumn = 4.
FOR EACH factabla WHERE codcia = s-codcia and tabla = '3PRV' NO-LOCK:
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                almmmatg.codmat = factabla.codigo NO-LOCK NO-ERROR. 
    FIND FIRST almtfam OF almmmatg NO-LOCK NO-ERROR.
    FIND FIRST almsfami OF almmmatg NO-LOCK NO-ERROR.
    FIND FIRST gn-prov WHERE gn-prov.codcia = 0 AND gn-prov.codpro = almmmatg.codpr1 NO-LOCK NO-ERROR.

    IF iColumn = 4 THEN DO:
        cRange = "B1".
        chWorkSheet:Range(cRange):Value = "'" + factabla.nombre.
    END.
    iColumn = iColumn + 1.
    cColumn = STRING(iColumn).

    ExisteDsctoxVol = NO.

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = factabla.campo-c[3].
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + almmmatg.codpr1.
    IF AVAILABLE gn-prov THEN DO:
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = gn-prov.nompro.
    END.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + factabla.codigo.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmat.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.undbas.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + almmmatg.codfam.
    IF AVAILABLE almtfam THEN DO:
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + almmmatg.codfam + " " + almtfam.desfam.        
    END.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.subfam.
    IF AVAILABLE almsfami THEN DO:
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = "'" + almmmatg.subfam + " " + almsfami.dessub.
    END.
    /* Precio Oficina */
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = factabla.valor[20].
    /* Precio Lista */
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = factabla.valor[1].
    /*Precio base  */
    cRange = "L" + cColumn.
    chWorksheet:Range(cRange):NumberFormat = '###,###,##0.0000'.
    chWorkSheet:Range(cRange):formula = "=+" + CeldaPrecioOficina + cColumn + " * (1 - " + CeldaDsctoCtgCliente + "2/100) * 0.96  " .
    /*
    lFiler = "=+Redondear(" + chWorkSheet:Range(cRange):Value + ",4)" .
    MESSAGE lFiler.
    chWorkSheet:Range(cRange):Value = "=+Redondear(" + chWorkSheet:Range(cRange):Value + ",4)"  + CHR(13) NO-ERROR .
    */
    /* Precios x Volumen */
    IF factabla.valor[4] > 0 THEN DO:
        ExisteDsctoxVol = YES.
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = factabla.valor[4].
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = factabla.valor[12].
        cRange = "R" + cColumn.
        chWorksheet:Range(cRange):NumberFormat = '###,###,##0.0000'.
        chWorkSheet:Range(cRange):Value = "=+" + CeldaPrecioLista + cColumn + " * (1 - Q" + cColumn + "/100)" .
    END.
    IF factabla.valor[5] > 0 THEN DO:
        ExisteDsctoxVol = YES.
        cRange = "S" + cColumn.
        chWorkSheet:Range(cRange):Value = factabla.valor[5].
        cRange = "T" + cColumn.
        chWorkSheet:Range(cRange):Value = factabla.valor[13].
        cRange = "U" + cColumn.
        chWorksheet:Range(cRange):NumberFormat = '###,###,##0.0000'.
        chWorkSheet:Range(cRange):Value = "=+" + CeldaPrecioLista + cColumn + " * (1 - T" + cColumn + "/100)".
    END.
    IF factabla.valor[6] > 0 THEN DO:
        ExisteDsctoxVol = YES.
        cRange = "V" + cColumn.
        chWorkSheet:Range(cRange):Value = factabla.valor[6].
        cRange = "W" + cColumn.
        chWorkSheet:Range(cRange):Value = factabla.valor[14].
        cRange = "X" + cColumn.
        chWorksheet:Range(cRange):NumberFormat = '###,###,##0.0000'.
        chWorkSheet:Range(cRange):Value = "=+" + CeldaPrecioLista + cColumn + " * (1 - W" + cColumn + "/100)".
    END.
    IF factabla.valor[7] > 0 THEN DO:
        ExisteDsctoxVol = YES.
        cRange = "Y" + cColumn.
        chWorkSheet:Range(cRange):Value = factabla.valor[7].
        cRange = "Z" + cColumn.
        chWorkSheet:Range(cRange):Value = factabla.valor[15].
        cRange = "AA" + cColumn.
        chWorksheet:Range(cRange):NumberFormat = '###,###,##0.0000'.
        chWorkSheet:Range(cRange):Value = "=+" + CeldaPrecioLista + cColumn + " * (1 - Z" + cColumn + "/100)".
    END.
    IF factabla.valor[8] > 0 THEN DO:
        ExisteDsctoxVol = YES.
        cRange = "AB" + cColumn.
        chWorkSheet:Range(cRange):Value = factabla.valor[8].
        cRange = "AC" + cColumn.
        chWorkSheet:Range(cRange):Value = factabla.valor[16].
        cRange = "AD" + cColumn.
        chWorksheet:Range(cRange):NumberFormat = '###,###,##0.0000'.
        chWorkSheet:Range(cRange):Value = "=+" + CeldaPrecioLista + cColumn + " * (1 - AC" + cColumn + "/100)".
    END.
    IF factabla.valor[9] > 0 THEN DO:
        ExisteDsctoxVol = YES.
        cRange = "AE" + cColumn.
        chWorkSheet:Range(cRange):Value = factabla.valor[9].
        cRange = "AF" + cColumn.
        chWorkSheet:Range(cRange):Value = factabla.valor[17].
        cRange = "AG" + cColumn.
        chWorksheet:Range(cRange):NumberFormat = '###,###,##0.0000'.
        chWorkSheet:Range(cRange):Value = "=+" + CeldaPrecioLista + cColumn + " * (1 - AF" + cColumn + "/100)".
    END.
    IF factabla.valor[10] > 0 THEN DO:
        ExisteDsctoxVol = YES.
        cRange = "AH" + cColumn.
        chWorkSheet:Range(cRange):Value = factabla.valor[10].
        cRange = "AI" + cColumn.
        chWorkSheet:Range(cRange):Value = factabla.valor[18].
        cRange = "AJ" + cColumn.
        chWorksheet:Range(cRange):NumberFormat = '###,###,##0.0000'.
        chWorkSheet:Range(cRange):Value = "=+" + CeldaPrecioLista + cColumn + " * (1 - AI" + cColumn + "/100)".
    END.
    IF factabla.valor[11] > 0 THEN DO:
        ExisteDsctoxVol = YES.
        cRange = "AK" + cColumn.
        chWorkSheet:Range(cRange):Value = factabla.valor[11].
        cRange = "AL" + cColumn.
        chWorkSheet:Range(cRange):Value = factabla.valor[19].
        cRange = "AM" + cColumn.
        chWorksheet:Range(cRange):NumberFormat = '###,###,##0.0000'.
        chWorkSheet:Range(cRange):Value = "=+" + CeldaPrecioLista + cColumn + " * (1 - AL" + cColumn + "/100)".
    END.
    /* Dscto Promo */
    IF factabla.valor[2] <> 0 AND ExisteDsctoxVol = NO THEN DO:
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = factabla.valor[2].
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = factabla.campo-c[1] + " AL " + factabla.campo-c[2].
        cRange = "O" + cColumn.
        chWorksheet:Range(cRange):NumberFormat = '###,###,##0.0000'.
        chWorkSheet:Range(cRange):Value = "=+" + CeldaPrecioLista + cColumn + " * (1 - M" + cColumn + "/100)".
    END.
    ELSE DO:
        cRange = "O" + cColumn.
        chWorksheet:Range(cRange):NumberFormat = '###,###,##0.0000'.
        chWorkSheet:Range(cRange):Value = "=+" + CeldaPrecioBase + cColumn .
    END.

    /*
    chWorkSheet:Range(cRange):VALUE = "=SUMA(" + x-suma-desde + ":" + x-suma-hasta + ") " + CHR(13) NO-ERROR.
    =+J5*(1-I2/100) * 0.96
    IF iColumn = 15 THEN LEAVE .
    */
    /*IF iColumn = 10 THEN LEAVE .*/
END.

{lib\excel-close-file.i}


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

