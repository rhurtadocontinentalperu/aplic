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

DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR pv-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.
DEFINE SHARED VAR s-tpodoc AS CHAR INIT "N".

/* Local Variable Definitions ---                                       */

DEF VAR cotfile AS CHAR INIT "".
DEF VAR x-file  AS CHAR INIT "". 
DEF VAR Rpta-1 AS LOG NO-UNDO.
DEFINE STREAM Reporte.

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
&Scoped-Define ENABLED-OBJECTS txt-codpro txt-desde txt-hasta Btn-Asigna-3 
&Scoped-Define DISPLAYED-OBJECTS txt-codpro txt-desde txt-hasta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-Asigna-3 
     LABEL "Txt" 
     SIZE 7.14 BY 1.35
     FONT 6.

DEFINE VARIABLE txt-codpro AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-desde AS CHARACTER FORMAT "X(256)":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-hasta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-codpro AT ROW 1.88 COL 17 COLON-ALIGNED WIDGET-ID 6
     txt-desde AT ROW 3 COL 17 COLON-ALIGNED WIDGET-ID 2
     txt-hasta AT ROW 3 COL 42 COLON-ALIGNED WIDGET-ID 4
     Btn-Asigna-3 AT ROW 5.04 COL 56 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.86 BY 6.23 WIDGET-ID 100.


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
         TITLE              = "<insert SmartWindow title>"
         HEIGHT             = 6.23
         WIDTH              = 77.86
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* <insert SmartWindow title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* <insert SmartWindow title> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Asigna-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Asigna-3 W-Win
ON CHOOSE OF Btn-Asigna-3 IN FRAME F-Main /* Txt */
DO:
    ASSIGN txt-codpro txt-desde txt-hasta.

    SYSTEM-DIALOG GET-FILE x-File FILTERS '*.txt' '*.txt' 
        INITIAL-FILTER 1 ASK-OVERWRITE CREATE-TEST-FILE 
        DEFAULT-EXTENSION 'txt' 
        RETURN-TO-START-DIR SAVE-AS 
        TITLE 'Guardar en' USE-FILENAME
        UPDATE Rpta-1.
    
    IF Rpta-1 = NO THEN RETURN.

    RUN Imprime-Text.

    MESSAGE SKIP
        "Orden de Compra ha sido guardado en" x-File
        view-as alert-box information 
        title cotfile.

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
  DISPLAY txt-codpro txt-desde txt-hasta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txt-codpro txt-desde txt-hasta Btn-Asigna-3 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Text W-Win 
PROCEDURE Imprime-Text :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE INroSec AS INTEGER     NO-UNDO INIT 0.

    DEFINE VARIABLE cCodEmi AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cCodRec AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cNroSec AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cNroDoc AS CHARACTER   NO-UNDO.  
    DEFINE VARIABLE dFchDoc AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dFchMax AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dFchSol AS DECIMAL     NO-UNDO.    
    DEFINE VARIABLE cPtoCmp AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cCodFac AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dImpVta AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE cMonCmp AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cMonFac AS CHARACTER   NO-UNDO.    
    DEFINE VARIABLE dImpTot AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE iDiasFac AS INTEGER     NO-UNDO.
    DEFINE VARIABLE x-file02 AS CHARACTER   NO-UNDO.     

    /*Detalle*/
    DEFINE VARIABLE iNroLin AS INTEGER     NO-UNDO INIT 0.
    DEFINE VARIABLE dImpLin AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dPreBru AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dPreNet AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE cUndCmp AS CHARACTER   NO-UNDO.

    cotfile = "OC" + "-" + STRING(txt-desde, "999999") + " al " + 
        STRING(txt-hasta, "999999") + ".txt".
    /*OUTPUT STREAM Report TO VALUE(x-file) PAGED PAGE-SIZE 31.*/
    
    
    FOR EACH lg-cocmp WHERE lg-cocmp.codcia = s-codcia
        AND lg-cocmp.coddiv = s-coddiv
        AND lg-cocmp.tpodoc = s-tpodoc 
        AND lg-cocmp.codpro = txt-codpro
        AND lg-cocmp.nrodoc >= INT(txt-desde)
        AND lg-cocmp.nrodoc <= INT(txt-hasta)
        AND lg-cocmp.flgsit <> "A" NO-LOCK:

        iNroSec = iNroSec + 1.

        /*Código Emisor*/
        FIND FIRST gn-clied WHERE gn-clied.codcia = cl-codcia
            AND gn-clied.codcli = '20100038146' NO-LOCK NO-ERROR.
        IF AVAIL gn-clied THEN cCodEmi = gn-clied.libre_C01.


        /*Códigp Receptor*/
        FIND gn-prov WHERE gn-prov.codcia = pv-codcia
            AND gn-prov.codpro = lg-cocmp.codpro NO-LOCK NO-ERROR.
        IF AVAIL gn-prov THEN cCodRec = STRING(gn-prov.libre_c05,"X(13)").

        /*Número Doc*/
        cNroDoc = STRING(LG-COCmp.NroDoc, "999999").

        /*Fechas*/
        dFchDoc = ((YEAR(FchDoc) * 10000) + (MONTH(FchDoc) * 100) + DAY(FchDoc)) * 10000.
        dFchMax = ((YEAR(FchVto) * 10000) + (MONTH(FchVto) * 100) + DAY(FchVto)) * 10000.
        dFchSol = ((YEAR(FchEnt) * 10000) + (MONTH(FchEnt) * 100) + DAY(FchEnt)) * 10000.

        /*Punto Compra*/
        FIND almacen WHERE almacen.codcia = s-codcia 
            AND almacen.codalm = lg-cocmp.codalm NO-LOCK NO-ERROR.
        IF AVAIL almacen THEN cPtoCmp = Almacen.Campo-C[5] .

        /*Documentos*/
        cCodFac = cCodEmi.
        dImpVta = LG-COCmp.ImpIgv.
        IF LG-COCmp.Codmon = 1 THEN 
            ASSIGN 
                cMonCmp = 'PEN'
                cMonFac = 'PEN'.
        ELSE ASSIGN
                cMonCmp = 'USD'
                cMonFac = 'USD'.
        ASSIGN 
            dImpTot  = LG-COCmp.ImpNet
            cNroSec  = STRING(inrosec,"9999").

        /*Condición Pago*/
        FIND FIRST gn-concp WHERE Gn-ConCp.Codig = LG-COCmp.CndCmp NO-LOCK NO-ERROR.
        IF AVAIL gn-concp THEN iDiasFac = gn-concp.totdias.
        ELSE iDiasFac = 0.
        
        x-file02 = x-file.
        x-file02 = REPLACE(x-file02,".txt",cNroSec + ".txt").
        MESSAGE x-file02.
        OUTPUT STREAM Report TO VALUE(x-file02) PAGED PAGE-SIZE 31.

        /*Impresion Cabecera*/
        PUT STREAM REPORT 'ENC,'   + cCodEmi + ',' + cCodRec + ',' + cNroSec + ',' + '220' + ',' + '7750822220000' + cNroDoc + ',' + 'ORDERS' + ',' + '9' FORMAT "X(100)" SKIP.
        PUT STREAM REPORT 'DTM,'   + STRING(dFchDoc,'999999999999') + ',' + STRING(dFchMax,'999999999999') + ',' + ',' + STRING(dFchSol,'999999999999')  FORMAT "X(100)" SKIP.
        PUT STREAM REPORT 'BYOC,'  + cCodEmi + ',' + ',' + ',' + cPtoCmp            FORMAT "X(50)" SKIP.
        PUT STREAM REPORT 'SUSR,'  + cCodRec    FORMAT "X(50)" SKIP.
        PUT STREAM REPORT 'DPGR,'  + cPtoCmp    FORMAT "X(50)" SKIP.
        PUT STREAM REPORT 'IVAD,'  + cCodFac    FORMAT "X(50)" SKIP.
        PUT STREAM REPORT 'ITO,'   + cCodFac    FORMAT "X(50)" SKIP.
        PUT STREAM REPORT 'TAXMOA,' + STRING(dImpVta,'>>>>>>>>>>>>>>9.999')   FORMAT "X(50)" SKIP.
        PUT STREAM REPORT 'CUX,'    + cMonCmp + ',' + cMonFac  FORMAT "X(50)" SKIP.
        PUT STREAM REPORT 'PATPCD,' + '9' + ',' + STRING(iDiasFac,">>9")  FORMAT "X(50)" SKIP.
        PUT STREAM REPORT 'MOA,'    + STRING(dImptot)FORMAT "X(50)" SKIP.

        FOR EACH LG-DOCmp WHERE LG-DOCmp.CodCia = LG-COCmp.CodCia
            AND  LG-DOCmp.TpoDoc = LG-COCmp.TpoDoc
            AND  LG-DOCmp.NroDoc = LG-COCmp.NroDoc NO-LOCK,
            FIRST Almmmatg OF LG-DOCmp NO-LOCK
                BREAK BY LG-DOCmp.NroDoc
                    BY LG-DOCmp.ArtPro
                    BY Almmmatg.CodMat:

            cUndCmp = 'NAR'.

            dImpLin = LG-DOCmp.ImpTot / (1 + LG-DOCmp.IgvMat / 100).
        /*     dPreBru = LG-DOCmp.PreUni / (1 + LG-DOCmp.ImpTot / 100). */
            dPreBru = LG-DOCmp.PreUni .
            dPreNet = ( LG-DOCmp.ImpTot / LG-DOCmp.CanPedi) / (1 + LG-DOCmp.IgvMat / 100).

            iNroLin = iNroLin + 1.
            PUT STREAM REPORT 'LIN,'   + STRING(iNroLin) + ',' + STRING(Almmmatg.codbrr) + ',' + 'EN' + ',' + almmmatg.codmat FORMAT "X(100)" SKIP.
            PUT STREAM REPORT 'QTY,'   + STRING(LG-DOCmp.CanPedi,'>>>>>>>>>>>9.999') + ',' + cUndCmp    FORMAT "X(100)" SKIP.
            PUT STREAM REPORT 'MOA,'   + STRING(dImpLin,'>>>>>>>>>>>>>>9.999')                          FORMAT "X(50)" SKIP.
            PUT STREAM REPORT 'PRI,'   + STRING(dPreBru,'>>>>>>>>>>9.9999') + ',' + STRING(dPreNet,'>>>>>>>>>>9.9999')     FORMAT "X(50)" SKIP.

        END.
        OUTPUT STREAM Report CLOSE.
        
    END.

    /*OUTPUT STREAM Report CLOSE.*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Texto W-Win 
PROCEDURE Imprime-Texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE INroSec AS INTEGER     NO-UNDO INIT 0.

    FOR EACH lg-cocmp WHERE lg-cocmp.codcia = s-codcia
        AND lg-cocmp.coddiv = s-coddiv
        AND lg-cocmp.tpodoc = s-tpodoc 
        AND lg-cocmp.codpro = txt-codpro
        AND lg-cocmp.nrodoc >= INT(txt-desde)
        AND lg-cocmp.nrodoc <= INT(txt-hasta)
        AND lg-cocmp.flgsit <> "A" NO-LOCK :

        iNroSec = iNroSec + 1.

/*         RUN lgc\r-imptxt02(ROWID(LG-COCmp), iNroSec). */
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

