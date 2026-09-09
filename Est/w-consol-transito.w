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
DEF SHARED VAR s-codcia AS INT.

/* Local Variable Definitions ---                                       */
DEFINE TEMP-TABLE T-Ordenes
    FIELD FchDoc LIKE LG-COCmp.Fchdoc 
    FIELD CodAlm LIKE LG-COCmp.CodAlm       COLUMN-LABEL "Almacén Destino"
    FIELD NroDoc LIKE LG-COCmp.NroDoc
    FIELD CodPro LIKE LG-COCmp.CodPro 
    FIELD NomPro LIKE LG-COCmp.NomPro 
    FIELD CodMat LIKE LG-DOCmp.Codmat 
    FIELD DesMat LIKE Almmmatg.DesMat 
    FIELD CodFam LIKE Almmmatg.CodFam 
    FIELD SubFam LIKE Almmmatg.SubFam
    FIELD CanPedi LIKE LG-DOCmp.CanPedi     COLUMN-LABEL "Solicitado"
    FIELD CanAten LIKE LG-DOCmp.CanAten     COLUMN-LABEL "Recibido"
    FIELD Saldo AS DEC                      COLUMN-LABEL "x Recibir"
    FIELD UndCmp LIKE LG-DOCmp.UndCmp.
DEFINE TEMP-TABLE t-Transferencias
    FIELD CodAlm LIKE Almcmov.CodAlm        COLUMN-LABEL "Almacén Origen"
    FIELD NroSer LIKE Almcmov.Nroser
    FIELD NroDoc LIKE Almcmov.Nrodoc
    FIELD FchDoc LIKE Almcmov.FchDoc
    FIELD AlmDes LIKE Almcmov.AlmDes        COLUMN-LABEL "Almacén Destino"
    FIELD CodMat LIKE Almdmov.codmat
    FIELD DesMat LIKE Almmmatg.desmat
    FIELD CodUnd LIKE Almdmov.CodUnd
    FIELD CodFam LIKE Almmmatg.codfam
    FIELD SubFam LIKE Almmmatg.subfam
    FIELD CanDes LIKE Almdmov.candes.


DEF VAR pOptions AS CHAR.
DEF VAR pArchivo AS CHAR.
DEF VAR lOptions AS CHAR.
DEF VAR cArchivo AS CHAR.

DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE t-Column                AS INTEGER.

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
&Scoped-Define ENABLED-OBJECTS BUTTON-2 BtnDone TOGGLE-TRF TOGGLE-OC 
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-TRF TOGGLE-OC FILL-IN-Mensaje 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnDone DEFAULT 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "&Done" 
     SIZE 7 BY 1.54
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-2 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 2" 
     SIZE 7 BY 1.54.

DEFINE VARIABLE FILL-IN-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 67 BY 1 NO-UNDO.

DEFINE VARIABLE TOGGLE-OC AS LOGICAL INITIAL yes 
     LABEL "Ordenes de Compra en Tránsito" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .77 NO-UNDO.

DEFINE VARIABLE TOGGLE-TRF AS LOGICAL INITIAL yes 
     LABEL "Transferencias en Tránsito" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-2 AT ROW 1.19 COL 62 WIDGET-ID 8
     BtnDone AT ROW 1.19 COL 70 WIDGET-ID 6
     TOGGLE-TRF AT ROW 1.38 COL 21 WIDGET-ID 2
     TOGGLE-OC AT ROW 2.35 COL 21 WIDGET-ID 4
     FILL-IN-Mensaje AT ROW 4.08 COL 7 COLON-ALIGNED NO-LABEL WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 4.46 WIDGET-ID 100.


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
         TITLE              = "CONSOLIDADO DE TRANSFERENCIAS Y ORDENES DE COMPRA"
         HEIGHT             = 4.46
         WIDTH              = 80
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartWindowCues" W-Win _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartWindow,ab,49271
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
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
/* SETTINGS FOR FILL-IN FILL-IN-Mensaje IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CONSOLIDADO DE TRANSFERENCIAS Y ORDENES DE COMPRA */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CONSOLIDADO DE TRANSFERENCIAS Y ORDENES DE COMPRA */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnDone
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnDone W-Win
ON CHOOSE OF BtnDone IN FRAME F-Main /* Done */
DO:
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



&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 W-Win
ON CHOOSE OF BUTTON-2 IN FRAME F-Main /* Button 2 */
DO:
    ASSIGN  TOGGLE-OC TOGGLE-TRF.
    IF TOGGLE-OC = NO AND TOGGLE-TRF = NO THEN RETURN NO-APPLY.

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.
    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().
    IF TOGGLE-TRF = YES THEN RUN Excel-Transferencias.
    IF TOGGLE-OC  = YES THEN RUN Excel-Compras.

/*     ASSIGN                                                         */
/*         pOptions = "".                                             */
/*     RUN lib/tt-file-to-text-01 (OUTPUT pOptions, OUTPUT pArchivo). */
/*     IF pOptions = "" THEN RETURN NO-APPLY.                         */
/*                                                                    */
/*     IF TOGGLE-TRF = YES THEN RUN Excel-Transferencias.             */
/*     IF TOGGLE-OC  = YES THEN RUN Excel-Compras.                    */
/*     MESSAGE 'Proceso terminado' VIEW-AS ALERT-BOX INFORMATION.     */

    /* launch Excel so it is visible to the user */
    chExcelApplication:VISIBLE = TRUE.

    /* release com-handles */
    RELEASE OBJECT chExcelApplication.      
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.

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
  DISPLAY TOGGLE-TRF TOGGLE-OC FILL-IN-Mensaje 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-2 BtnDone TOGGLE-TRF TOGGLE-OC 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-Compras W-Win 
PROCEDURE Excel-Compras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(2).
chWorkSheet:NAME = "COMPRAS".

chWorkSheet:Range("A1"):VALUE = "COMPRAS PENDIENTES".
chWorkSheet:Range("A2"):VALUE = "Fecha".
chWorkSheet:Range("B2"):VALUE = "Destino".
chWorkSheet:Range("C2"):VALUE = "Documento".
chWorkSheet:Range("D2"):VALUE = "Proveedor".
chWorkSheet:Range("E2"):VALUE = "Nombre".
chWorkSheet:Range("F2"):VALUE = "Articulo".
chWorkSheet:Range("G2"):VALUE = "Descripcion".
chWorkSheet:Range("H2"):VALUE = "Unidad".
chWorkSheet:Range("I2"):VALUE = "Linea".
chWorkSheet:Range("J2"):VALUE = "SubLinea".
chWorkSheet:Range("K2"):VALUE = "Cantidad Pedida".
chWorkSheet:Range("L2"):VALUE = "Cantidad Atendida".
chWorkSheet:Range("M2"):VALUE = "Saldo".

chWorkSheet:COLUMNS("A"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:COLUMNS("D"):NumberFormat = "@".
chWorkSheet:COLUMNS("F"):NumberFormat = "@".
chWorkSheet:COLUMNS("H"):NumberFormat = "@".
chWorkSheet:COLUMNS("I"):NumberFormat = "@".
chWorkSheet:COLUMNS("J"):NumberFormat = "@".

DEF BUFFER B-Almacen FOR Almacen.
t-column = 2.
FOR EACH Lg-cocmp NO-LOCK WHERE LG-COCmp.CodCia = S-CODCIA 
    AND Lg-cocmp.coddiv = "00000"
    AND LG-COCmp.FchVto >= TODAY
    AND LG-COCmp.FlgSit = 'P' :
    FILL-IN-Mensaje:SCREEN-VALUE IN frame {&FRAME-NAME} =
        "O/C: " + STRING(lg-cocmp.fchdoc) + ' ' +
        lg-cocmp.codalm + ' ' + STRING(lg-cocmp.nrodoc).
    FOR EACH Lg-docmp OF Lg-cocmp NO-LOCK WHERE Lg-docmp.canpedi > Lg-docmp.canate,
        FIRST Almmmatg OF Lg-docmp NO-LOCK:
        t-column = t-column + 1.
        cColumn = STRING(t-Column).
        cRange = "A" + cColumn.
        chWorkSheet:Range(cRange):Value = Lg-cocmp.fchdoc.
        cRange = "B" + cColumn.
        chWorkSheet:Range(cRange):Value = Lg-cocmp.codalm.
        cRange = "C" + cColumn.
        chWorkSheet:Range(cRange):Value = Lg-cocmp.nrodoc.
        cRange = "D" + cColumn.
        chWorkSheet:Range(cRange):Value = Lg-cocmp.codpro.
        cRange = "E" + cColumn.
        chWorkSheet:Range(cRange):Value = Lg-cocmp.nompro.
        cRange = "F" + cColumn.
        chWorkSheet:Range(cRange):Value = Lg-docmp.codmat.
        cRange = "G" + cColumn.
        chWorkSheet:Range(cRange):Value = Almmmatg.desmat.
        cRange = "H" + cColumn.
        chWorkSheet:Range(cRange):Value = LG-DOCmp.UndCmp.
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = Almmmatg.codfam.
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = Almmmatg.subfam.
        cRange = "K" + cColumn.
        chWorkSheet:Range(cRange):Value = LG-DOCmp.CanPedi.
        cRange = "L" + cColumn.
        chWorkSheet:Range(cRange):Value = LG-DOCmp.CanAten.
        cRange = "M" + cColumn.
        chWorkSheet:Range(cRange):Value = LG-DOCmp.CanPedi - LG-DOCmp.CanAten.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Excel-Transferencias W-Win 
PROCEDURE Excel-Transferencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).
chWorkSheet:NAME = "TRANSFERENCIAS".

chWorkSheet:Range("A1"):VALUE = "TRANSFERENCIAS POR RECEPCIONAR".
chWorkSheet:Range("A2"):VALUE = "Origen".
chWorkSheet:Range("B2"):VALUE = "Serie".
chWorkSheet:Range("C2"):VALUE = "Documento".
chWorkSheet:Range("D2"):VALUE = "Fecha".
chWorkSheet:Range("E2"):VALUE = "Destino".
chWorkSheet:Range("F2"):VALUE = "Articulo".
chWorkSheet:Range("G2"):VALUE = "Descripcion".
chWorkSheet:Range("H2"):VALUE = "Unidad".
chWorkSheet:Range("I2"):VALUE = "Linea".
chWorkSheet:Range("J2"):VALUE = "SubLinea".
chWorkSheet:Range("K2"):VALUE = "Cantidad".

chWorkSheet:COLUMNS("A"):NumberFormat = "@".
chWorkSheet:COLUMNS("B"):NumberFormat = "@".
chWorkSheet:COLUMNS("C"):NumberFormat = "@".
chWorkSheet:COLUMNS("D"):NumberFormat = "dd/mm/yyyy".
chWorkSheet:COLUMNS("E"):NumberFormat = "@".
chWorkSheet:COLUMNS("F"):NumberFormat = "@".
chWorkSheet:COLUMNS("I"):NumberFormat = "@".
chWorkSheet:COLUMNS("J"):NumberFormat = "@".

DEF BUFFER B-Almacen FOR Almacen.
t-column = 2.
FOR EACH B-Almacen WHERE B-Almacen.codcia = s-codcia ,
    EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = S-CODCIA 
    AND Almcmov.CodAlm = B-Almacen.codalm 
    AND Almcmov.TipMov = "S" AND Almcmov.CodMov = 03 
    AND Almcmov.flgest <> "A" AND Almcmov.flgsit = "T",
    FIRST Almacen NO-LOCK WHERE Almacen.codcia = Almcmov.codcia 
    AND Almacen.codalm = Almcmov.almdes,
    EACH almdmov OF almcmov NO-LOCK,
    FIRST Almmmatg OF Almdmov NO-LOCK:
    FILL-IN-Mensaje:SCREEN-VALUE IN frame {&FRAME-NAME} =
        "TRANSF: " + STRING(almcmov.fchdoc) + ' ' +
        almcmov.codalm + ' ' + STRING(almcmov.nroser) + '-' + STRING(almcmov.nrodoc).
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = Almcmov.CodAlm.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = Almcmov.Nroser.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = Almcmov.Nrodoc.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = Almcmov.FchDoc.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = Almcmov.AlmDes.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = Almdmov.codmat.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.desmat.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = Almdmov.CodUnd.
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.codfam.
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = Almmmatg.subfam.
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = Almdmov.candes.
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto-Excel-Compras W-Win 
PROCEDURE Texto-Excel-Compras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    SESSION:SET-WAIT-STATE('GENERAL').
    EMPTY TEMP-TABLE T-Ordenes.
    FOR EACH Lg-cocmp NO-LOCK WHERE LG-COCmp.CodCia = S-CODCIA 
        AND LG-COCmp.FlgSit = 'P' :
        FOR EACH Lg-docmp OF Lg-cocmp NO-LOCK, FIRST Almmmatg OF Lg-docmp NO-LOCK:
            CREATE T-Ordenes.
            BUFFER-COPY Lg-cocmp
                TO T-Ordenes
                ASSIGN
                T-Ordenes.CodMat = Lg-docmp.codmat
                T-Ordenes.desmat = Almmmatg.desmat
                T-Ordenes.codfam = Almmmatg.codfam
                T-Ordenes.subfam = Almmmatg.subfam
                T-Ordenes.canpedi = Lg-docmp.canpedi
                T-Ordenes.canaten = Lg-docmp.canaten
                T-Ordenes.saldo = T-Ordenes.canpedi - T-Ordenes.canaten
                T-Ordenes.undcmp = Lg-docmp.undcmp.
        END.
    END.
    SESSION:SET-WAIT-STATE('').

    /* Definimos los campos a mostrar */
/*     ASSIGN lOptions = "FieldList:".                                                             */
/*     lOptions = lOptions + "coddiv,libre_c01,nroped,fchped,fchven,fchent,nomcli," +              */
/*         "lincre,sdoant,codven,imptot,estado,avance,items,peso,cuota,atendido,pendiente,codalm". */
/*     pOptions = pOptions + CHR(1) + lOptions.                                                    */

    /* El archivo se va a generar en un archivo temporal de trabajo antes 
    de enviarlo a su directorio destino */
    cArchivo = LC(pArchivo).
    RUN lib/tt-filev2 (TEMP-TABLE T-Ordenes:HANDLE, cArchivo, pOptions).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Texto-Excel-Transferencias W-Win 
PROCEDURE Texto-Excel-Transferencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF BUFFER B-Almacen FOR Almacen.
    SESSION:SET-WAIT-STATE('GENERAL').
    EMPTY TEMP-TABLE T-Transferencias.
    FOR EACH B-Almacen WHERE B-Almacen.codcia = s-codcia ,
        EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = S-CODCIA 
        AND Almcmov.CodAlm = B-Almacen.codalm 
        AND Almcmov.TipMov = "S" 
        AND Almcmov.CodMov = 03 
        AND Almcmov.flgest <> "A"     
        AND Almcmov.flgsit = "T",
        FIRST Almacen NO-LOCK WHERE Almacen.codcia = Almcmov.codcia 
        AND Almacen.codalm = Almcmov.almdes,
        EACH almdmov OF almcmov NO-LOCK,
        FIRST Almmmatg OF Almdmov NO-LOCK:
        CREATE T-Transferencias.
        BUFFER-COPY Almcmov
            TO T-Transferencias
            ASSIGN
            T-Transferencias.codmat = Almdmov.codmat
            T-Transferencias.desmat = Almmmatg.desmat
            T-Transferencias.codund = Almdmov.codund
            T-Transferencias.codfam = Almmmatg.codfam
            T-Transferencias.subfam = Almmmatg.subfam
            T-Transferencias.candes = Almdmov.candes.
    END.
    SESSION:SET-WAIT-STATE('').

    /* Definimos los campos a mostrar */
/*     ASSIGN lOptions = "FieldList:".                                                             */
/*     lOptions = lOptions + "coddiv,libre_c01,nroped,fchped,fchven,fchent,nomcli," +              */
/*         "lincre,sdoant,codven,imptot,estado,avance,items,peso,cuota,atendido,pendiente,codalm". */
/*     pOptions = pOptions + CHR(1) + lOptions.                                                    */

    /* El archivo se va a generar en un archivo temporal de trabajo antes 
    de enviarlo a su directorio destino */
    cArchivo = LC(pArchivo).
    RUN lib/tt-filev2 (TEMP-TABLE T-Transferencias:HANDLE, cArchivo, pOptions).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

