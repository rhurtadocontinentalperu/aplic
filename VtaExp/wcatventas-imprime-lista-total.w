&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
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
DEF SHARED VAR s-coddiv AS CHAR.

    /* Ic - Migracion a Cloud WIN  */
    DEFINE VAR cDBfisica AS CHAR NO-UNDO.
    DEFINE VAR cDBlogica AS CHAR NO-UNDO.
    DEFINE VAR cPuerto AS CHAR NO-UNDO.
    DEFINE VAR cIPOrigen AS CHAR NO-UNDO.
    DEFINE VAR cOtrosDatos AS CHAR NO-UNDO.
    DEFINE VAR cCadenaDeConexion AS CHAR NO-UNDO.

IF NOT connected('conti') THEN DO:

    /*CONNECT -db integral -ld conti -N TCP -S 65010 -H 192.168.100.210 NO-ERROR.*/

    cDBfisica = "integral".
    cDBlogica = "conti".
    cPuerto = "65010".
    cIPorigen = "192.168.100.210".
    cOtrosDatos = "".
    cCadenaDeConexion = "".

    /*pCadenaDeConexion = "-db " + pDBfisica + " -ld " + pDBlogica + " -N TCP -H " + cIPDestino + " -S " + pPuerto.*/
    RUN lib/migracion-win-cloud(cDBfisica, cDBlogica, cIpOrigen, cOtrosDatos, OUTPUT cCadenaDeConexion).
   
    CONNECT VALUE(cCadenaDeConexion) NO-ERROR.
END.
    
    
        IF ERROR-STATUS:ERROR THEN DO:
          MESSAGE 'NO se ha podido conectar la base de datos de CONTI' SKIP
              'NO podemos capturar el Precio'
              VIEW-AS ALERT-BOX WARNING.
      RETURN.
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
&Scoped-Define ENABLED-OBJECTS BUTTON-6 
&Scoped-Define DISPLAYED-OBJECTS txt-msg 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_bcatventa AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bcatvtac AS HANDLE NO-UNDO.
DEFINE VARIABLE h_bcatvtad AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 6" 
     SIZE 11 BY 1.35.

DEFINE VARIABLE txt-msg AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BUTTON-6 AT ROW 3.69 COL 81 WIDGET-ID 2
     txt-msg AT ROW 6.19 COL 75 COLON-ALIGNED NO-LABEL WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 118.86 BY 25.5 WIDGET-ID 100.


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
         TITLE              = "CATALOGO DE VENTAS POR PROVEEDOR"
         HEIGHT             = 25.5
         WIDTH              = 118.86
         MAX-HEIGHT         = 25.96
         MAX-WIDTH          = 134.72
         VIRTUAL-HEIGHT     = 25.96
         VIRTUAL-WIDTH      = 134.72
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
/* SETTINGS FOR FILL-IN txt-msg IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* CATALOGO DE VENTAS POR PROVEEDOR */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* CATALOGO DE VENTAS POR PROVEEDOR */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:
   /*RUN Genera_Excel IN h_bcatventa.*/    
    DISPLAY "" @ txt-msg WITH FRAME {&FRAME-NAME}.

   RUN imprime-articulos-todo.
   DISPLAY "" @ txt-msg WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

IF NOT connected('conti') THEN DO:

    /*CONNECT -db integral -ld conti -N TCP -S 65010 -H 192.168.100.210 NO-ERROR.*/

    cDBfisica = "integral".
    cDBlogica = "conti".
    cPuerto = "65010".
    cIPorigen = "192.168.100.210".
    cOtrosDatos = "".
    cCadenaDeConexion = "".

    /*pCadenaDeConexion = "-db " + pDBfisica + " -ld " + pDBlogica + " -N TCP -H " + cIPDestino + " -S " + pPuerto.*/
    RUN lib/migracion-win-cloud(cDBfisica, cDBlogica, cIpOrigen, cOtrosDatos, OUTPUT cCadenaDeConexion).
   
    CONNECT VALUE(cCadenaDeConexion) NO-ERROR.

END.
    
IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE 'NO se ha podido conectar la base de datos de CONTI' SKIP
              'NO podemos capturar el Precio'
              VIEW-AS ALERT-BOX WARNING.
     RETURN.
END.

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
             INPUT  'aplic/vtaexp/bcatventa.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bcatventa ).
       RUN set-position IN h_bcatventa ( 1.19 , 4.00 ) NO-ERROR.
       RUN set-size IN h_bcatventa ( 8.04 , 68.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtaexp/bcatvtac.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bcatvtac ).
       RUN set-position IN h_bcatvtac ( 9.35 , 4.00 ) NO-ERROR.
       RUN set-size IN h_bcatvtac ( 6.19 , 71.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'aplic/vtaexp/bcatvtad.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_bcatvtad ).
       RUN set-position IN h_bcatvtad ( 15.54 , 4.00 ) NO-ERROR.
       RUN set-size IN h_bcatvtad ( 10.23 , 112.72 ) NO-ERROR.

       /* Links to SmartBrowser h_bcatvtac. */
       RUN add-link IN adm-broker-hdl ( h_bcatventa , 'Record':U , h_bcatvtac ).

       /* Links to SmartBrowser h_bcatvtad. */
       RUN add-link IN adm-broker-hdl ( h_bcatvtac , 'Record':U , h_bcatvtad ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcatventa ,
             BUTTON-6:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcatvtac ,
             txt-msg:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_bcatvtad ,
             h_bcatvtac , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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
  DISPLAY txt-msg 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE BUTTON-6 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-articulos-todo W-Win 
PROCEDURE imprime-articulos-todo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
IF NOT connected('conti')
            THEN CONNECT -db integral -ld conti -N TCP -S 65010 -H 192.168.100.210 NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
          MESSAGE 'NO se ha podido conectar la base de datos de CONTI' SKIP
              'NO podemos capturar el Precio'
              VIEW-AS ALERT-BOX WARNING.
      RETURN.
        END.
*/
    DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
    DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
    DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
    DEFINE VARIABLE chChart                 AS COM-HANDLE.
    DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
    DEFINE VARIABLE iCount                  AS INTEGER init 1.
    DEFINE VARIABLE iIndex                  AS INTEGER.
    DEFINE VARIABLE cColumn                 AS CHARACTER.
    DEFINE VARIABLE cRange                  AS CHARACTER.
    DEFINE VARIABLE t-Column                AS INTEGER INIT 5.
    DEFINE VARIABLE i-Column                AS INTEGER NO-UNDO.
    DEFINE VARIABLE j-Column                AS INTEGER NO-UNDO.
    DEFINE VAR s-codcia AS INT.
    /*DEFINE SHARED VARIABLE s-coddiv AS CHARACTER.*/

    /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication.

    /* create a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().

    /* get the active Worksheet */
    chWorkSheet = chExcelApplication:Sheets:Item(1).

    /*Header del Excel */
    cRange = "D" + '2'.
    chWorkSheet:Range('D2'):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "CATALOGO DE PRODUCTOS PARA EL PROVEEDOR " .
    cRange = "K" + '2'.
    chWorkSheet:Range(cRange):Value = TODAY.


    /*Formato*/
    chWorkSheet:Columns("A"):NumberFormat = "@".
    chWorkSheet:Columns("B"):NumberFormat = "@".
    chWorkSheet:Columns("C"):NumberFormat = "@".

    t-Column = 1.
    cColumn = STRING(t-Column).

    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "CodProv".
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Nombre Proveedor".
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Nro.Pag".
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Nro.Sec".
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Codigo".
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Descripción".
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Marca".
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Unidades".

    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Moneda".
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Tpo Cambio".
    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Precio SOLES".
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Vta.Min".
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Cajon".

    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "DIV".
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Del".
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Al".
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "%Dscto".

    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "PRE OFICINA SOLES".

    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Familia".

    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Font:Bold = TRUE.
    chWorkSheet:Range(cRange):Value = "Propio/Tercero".

s-codcia = 1.
/*s-coddiv = '10015'.*/

/*MESSAGE s-coddiv.*/

FOR EACH integral.AlmCatVtaD WHERE integral.AlmCatVtaD.codcia = s-codcia AND integral.AlmCatVtaD.coddiv = s-coddiv    
    BY codpro BY nropag  BY nrosec :
    FIND integral.almmmatg WHERE integral.almmmatg.codcia = s-codcia AND integral.almmmatg.codmat = almcatvtad.codmat NO-LOCK NO-ERROR .

    FIND FIRST integral.VtaListaMay WHERE integral.VtaListaMay.CodCia = s-codcia
        AND integral.VtaListaMay.CodDiv = s-coddiv
        AND integral.VtaListaMay.CodMat = almcatvtad.codmat 
        NO-LOCK NO-ERROR.

    FIND integral.gn-prov WHERE integral.gn-prov.codcia = 0 AND integral.gn-prov.codpro=integral.AlmCatVtaD.codpro NO-LOCK NO-ERROR.

    DISPLAY  almcatvtad.codmat @ txt-msg WITH FRAME {&FRAME-NAME}.

    t-Column = t-Column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + almcatvtad.codpro.
    cRange = "B" + cColumn.
    IF AVAILABLE integral.gn-prov THEN DO:
        chWorkSheet:Range(cRange):Value = integral.gn-prov.nompro.
    END.
    ELSE chWorkSheet:Range(cRange):Value = "< NO EXISTE EN PROVEEDOES >".


    cColumn = STRING(t-Column).
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(almcatvtad.nropag,'999').
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = STRING(almcatvtad.nrosec,'999').
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + almcatvtad.codmat.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = almcatvtad.DesMat.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.desmar.
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = almmmatg.undbas.
    IF AVAIL VtaListaMay THEN DO:
        cRange = "I" + cColumn.
        chWorkSheet:Range(cRange):Value = VtaListaMay.MonVta.    
        cRange = "J" + cColumn.
        chWorkSheet:Range(cRange):Value = VtaListaMay.TpoCmb.    
        cRange = "K" + cColumn.
        IF VtaListaMay.MonVta <> 1 THEN DO:
            chWorkSheet:Range(cRange):Value = VtaListaMay.PreOfi * VtaListaMay.TpoCmb.    
        END.
        ELSE chWorkSheet:Range(cRange):Value = VtaListaMay.PreOfi.    
    END.
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = AlmCatVtaD.libre_d02.
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = AlmCatVtaD.Libre_d03.                    

    IF AVAIL VtaListaMay THEN DO:
        cRange = "N" + cColumn.
        chWorkSheet:Range(cRange):Value = VtaListaMay.coddiv.    
        cRange = "O" + cColumn.
        chWorkSheet:Range(cRange):Value = VtaListaMay.promFchD.    
        cRange = "P" + cColumn.
        chWorkSheet:Range(cRange):Value = VtaListaMay.promFchH.    
        cRange = "Q" + cColumn.
        chWorkSheet:Range(cRange):Value = VtaListaMay.PromDto.    

    END.

    cRange = "R" + cColumn.
    IF integral.almmmatg.monvta <> 1 THEN DO:        
        chWorkSheet:Range(cRange):Value = integral.almmmatg.preofi * integral.almmmatg.tpocmb.
    END.
    ELSE chWorkSheet:Range(cRange):Value = integral.almmmatg.preofi.

    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = "'" + integral.almmmatg.codfam.

    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Value = integral.almmmatg.Chr__02.

END.


/*DISCONNECT conti NO-ERROR.*/

 chExcelApplication:Visible = TRUE.

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.

MESSAGE 'Proceso Concluidoo...' VIEW-AS ALERT-BOX WARNING.


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

