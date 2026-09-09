&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME W-Win


/* Temp-Table and Buffer definitions                                    */
DEFINE NEW SHARED TEMP-TABLE DATOS NO-UNDO LIKE AlmCatVtaD
       Fields ImpUnit AS DEC.
DEFINE SHARED TEMP-TABLE PEDI2 NO-UNDO LIKE VtaDDocu.



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

DEFINE SHARED VAR s-codcia  AS INT.
DEFINE SHARED VAR pv-codcia AS INT.
DEFINE SHARED VAR s-coddiv  AS CHAR.
DEFINE SHARED VAR cl-codcia AS INT.
DEFINE SHARED VAR s-nrocot  AS CHAR.
DEFINE SHARED VAR S-CODPRO  AS CHAR.
DEFINE SHARED VAR s-codcli  AS CHAR.
DEFINE SHARED VAR s-codmon  AS INT.
DEFINE SHARED VAR s-tpocmb  AS DEC.
DEFINE SHARED VAR s-cndvta  AS CHAR.
DEFINE SHARED VAR s-codalm  AS CHAR.

DEFINE NEW SHARED VAR s-task-no AS INT.

DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.


DEF NEW SHARED VAR s-FlgEmpaque AS LOG.
DEF NEW SHARED VAR s-FlgMinVenta AS LOG.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    MESSAGE 'División' s-coddiv 'NO configurada' VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.
ASSIGN
    s-FlgEmpaque = GN-DIVI.FlgEmpaque
    s-FlgMinVenta = GN-DIVI.FlgMinVenta.

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
&Scoped-Define ENABLED-OBJECTS RECT-70 
&Scoped-Define DISPLAYED-OBJECTS x-nomcli x-monlc-2 x-importe-2 x-monlc ~
x-importe 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b-detcatvta_prov AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-listaprov_prov AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b-pagcatvtas AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE x-importe AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1
     BGCOLOR 8 FONT 6 NO-UNDO.

DEFINE VARIABLE x-importe-2 AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1
     BGCOLOR 8 FONT 6 NO-UNDO.

DEFINE VARIABLE x-monlc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY 1
     BGCOLOR 8 FONT 6 NO-UNDO.

DEFINE VARIABLE x-monlc-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY 1
     BGCOLOR 8 FONT 6 NO-UNDO.

DEFINE VARIABLE x-nomcli AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55.29 BY 1
     BGCOLOR 8 FONT 6 NO-UNDO.

DEFINE RECTANGLE RECT-70
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 156.86 BY 1.62
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     x-nomcli AT ROW 1.38 COL 8.72 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     x-monlc-2 AT ROW 1.38 COL 83.43 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     x-importe-2 AT ROW 1.38 COL 89.43 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     x-monlc AT ROW 1.38 COL 128.57 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     x-importe AT ROW 1.38 COL 134.57 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     "L.C Disponible:" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 1.54 COL 117 WIDGET-ID 24
          BGCOLOR 8 
     "Nota: Debe seleccionar el proveedor antes de importar archivo." VIEW-AS TEXT
          SIZE 54 BY .62 AT ROW 11.04 COL 78 WIDGET-ID 22
     "Cliente:" VIEW-AS TEXT
          SIZE 7 BY .62 AT ROW 1.54 COL 3.57 WIDGET-ID 8
          BGCOLOR 8 
     "Línea Crédito:" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 1.54 COL 72 WIDGET-ID 10
          BGCOLOR 8 
     RECT-70 AT ROW 1.12 COL 2.14 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 158.14 BY 25.5 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: DATOS T "NEW SHARED" NO-UNDO INTEGRAL AlmCatVtaD
      ADDITIONAL-FIELDS:
          Fields ImpUnit AS DEC
      END-FIELDS.
      TABLE: PEDI2 T "SHARED" NO-UNDO INTEGRAL VtaDDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Primer Registro de Articulos"
         HEIGHT             = 25.5
         WIDTH              = 158.14
         MAX-HEIGHT         = 25.5
         MAX-WIDTH          = 158.14
         VIRTUAL-HEIGHT     = 25.5
         VIRTUAL-WIDTH      = 158.14
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT W-Win:LOAD-ICON("adeicon/admin%.ico":U) THEN
    MESSAGE "Unable to load icon: adeicon/admin%.ico"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
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
/* SETTINGS FOR FILL-IN x-importe IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-importe-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-monlc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-monlc-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN x-nomcli IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Primer Registro de Articulos */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Primer Registro de Articulos */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */
lh_handle = THIS-PROCEDURE.
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
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vtaexp/b-listaprov_prov.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-listaprov_prov ).
       RUN set-position IN h_b-listaprov_prov ( 2.81 , 2.14 ) NO-ERROR.
       RUN set-size IN h_b-listaprov_prov ( 8.15 , 74.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vtaexp/b-pagcatvtas.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-pagcatvtas ).
       RUN set-position IN h_b-pagcatvtas ( 2.81 , 77.00 ) NO-ERROR.
       RUN set-size IN h_b-pagcatvtas ( 8.08 , 55.00 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'vtaexp/b-detcatvta_prov.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b-detcatvta_prov ).
       RUN set-position IN h_b-detcatvta_prov ( 12.04 , 1.00 ) NO-ERROR.
       RUN set-size IN h_b-detcatvta_prov ( 14.00 , 156.00 ) NO-ERROR.

       /* Links to SmartBrowser h_b-pagcatvtas. */
       RUN add-link IN adm-broker-hdl ( h_b-listaprov_prov , 'Record':U , h_b-pagcatvtas ).

       /* Links to SmartBrowser h_b-detcatvta_prov. */
       RUN add-link IN adm-broker-hdl ( h_b-pagcatvtas , 'Record':U , h_b-detcatvta_prov ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-listaprov_prov ,
             x-importe:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-pagcatvtas ,
             h_b-listaprov_prov , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b-detcatvta_prov ,
             h_b-pagcatvtas , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Datos W-Win 
PROCEDURE Borra-Datos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH w-report WHERE w-report.task-no = s-task-no :
        DELETE w-report.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calcula-Linea-de-Credito W-Win 
PROCEDURE Calcula-Linea-de-Credito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VAR w-cambio AS DEC NO-UNDO.
    DEFINE VAR x-Signo  AS INT NO-UNDO.
    DEFINE VAR f-TotSol AS DEC NO-UNDO.
    DEFINE VAR f-TotDol AS DEC NO-UNDO.
    DEFINE VAR f-CreUsa AS DEC NO-UNDO.
    DEFINE VAR dImpLCred AS DECIMAL NO-UNDO.
    DEFINE VARIABLE f-CreDis AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE f-LinCre AS DECIMAL     NO-UNDO.

    DEFINE FRAME F-Mensaje
        " Procesando informacion " SKIP
        " Espere un momento por favor..." SKIP
        WITH VIEW-AS DIALOG-BOX CENTERED OVERLAY WIDTH 40 TITLE 'Mensaje'.

    ASSIGN 
        F-TotDol = 0 
        F-TotSol = 0.

    FIND FIRST FacCfgGn NO-LOCK NO-ERROR.
    IF AVAILABLE FacCfgGn THEN 
        w-cambio = FacCfgGn.Tpocmb[1].
    ELSE  w-cambio = 0.     
    VIEW FRAME F-Mensaje.

    FOR EACH CcbCDocu NO-LOCK WHERE CcbCDocu.CodCia = s-CodCia
        AND CcbCDocu.CodCli = gn-clie.CodCli
        AND CcbCDocu.FlgEst = 'P',
        FIRST FacDocum OF CcbCDocu NO-LOCK WHERE FacDocum.TpoDoc <> ?:
        /* DOCUMENTOS QUE NO DEBEN APARECER EN LA LINEA DE CREDITO */
        IF LOOKUP(Ccbcdocu.coddoc, 'A/R,BD') > 0 THEN NEXT.
        /* ******************************************************* */
        /* RHC 23.11.08 LETRAS ADELANTADAS */
        /*     IF Ccbcdocu.coddoc = 'LET' AND Ccbcdocu.codref = 'CLA' THEN NEXT. */
        
        x-Signo = IF FacDocum.TpoDoc = YES THEN 1 ELSE -1.
        CASE CcbCDocu.CodMon :           
            WHEN 1 THEN F-TotSol = F-TotSol + CcbCDocu.SdoAct * x-Signo.
            WHEN 2 THEN F-TotDol = F-TotDol + CcbCDocu.SdoAct * x-Signo.
        END CASE .
    END.

    /*Calcula SdoAct*/
    DEF VAR f-Total  AS DEC NO-UNDO.
    DEF VAR x-ImpLin AS DEC NO-UNDO.

    
    /* POR PEDIDOS PENDIENTES DE ATENCION */
    FOR EACH FacCPedi NO-LOCK WHERE FacCPedi.CodCia = S-CODCIA
        /*AND integral.FacCPedi.CodDiv = S-CODDIV*/
        AND FacCPedi.CodDoc = 'PED'
        AND FacCPedi.CodCli = GN-CLIE.CODCLI
        AND FacCPedi.FlgEst = "P" 
        AND LOOKUP(TRIM(Faccpedi.fmapgo), '001,002') = 0:   /* NO contraentrega ni anticipado */

        f-Total = 0.
        FOR EACH Facdpedi OF Faccpedi NO-LOCK:
            x-ImpLin = (FacDPedi.CanPed - FacDPedi.CanAte) * FacDPedi.ImpLin / FacDPedi.CanPed.
            IF x-ImpLin > 0 THEN f-Total = f-Total + x-ImpLin.
        END. 

        IF Faccpedi.codmon = 1
            THEN F-TotSol = F-TotSol + f-total.
        ELSE F-TotDol = F-TotDol + f-total.
    END.
    /* ********************************** */
    HIDE FRAME F-Mensaje.

    CASE gn-clie.MonLC:  
        WHEN 1 THEN F-CreUsa = ( F-TotDol * w-cambio ) + F-TotSol.
        WHEN 2 THEN F-CreUsa = ( F-TotSol / w-cambio ) + F-TotDol.
        WHEN 0 THEN F-CreUsa = ( F-TotSol / w-cambio ) + F-TotDol.
    END CASE.           

    RUN ccb/p-implc (gn-clie.codcia, gn-clie.codcli, OUTPUT dImpLCred).
    F-CreDis = dImpLCred - F-CreUsa.
    F-LinCre = dImpLCred.  
    DISPLAY F-CreDis @ x-importe WITH FRAME {&FRAME-NAME}.

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
  DISPLAY x-nomcli x-monlc-2 x-importe-2 x-monlc x-importe 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-70 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy W-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  RUN Borra-Datos.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  DEFINE VARIABLE t-Resultado AS DEC NO-UNDO.      
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /*Hallar Cliente*/


  FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
      AND gn-clie.codcli = s-codcli NO-LOCK NO-ERROR.
  IF AVAIL gn-clie THEN DO:
      DISPLAY 
        gn-clie.nomcli @ x-nomcli 
        IF (gn-clie.monlc = 1 ) THEN 'S/.'  
            ELSE 'USD $' @ x-monlc 
        IF (gn-clie.monlc = 1 ) THEN 'S/.'  
            ELSE 'USD $' @ x-monlc-2 
        gn-clie.implc @ x-importe-2
        WITH FRAME {&FRAME-NAME}.
      FIND FIRST gn-cliel WHERE gn-cliel.codcia = cl-codcia
          AND gn-cliel.codcli = gn-clie.codcli
          AND Gn-ClieL.FchIni <= TODAY
          AND Gn-ClieL.FchFin >= TODAY NO-LOCK NO-ERROR.
      IF AVAIL gn-cliel THEN 
          DISPLAY
            Gn-ClieL.ImpLC @ x-importe-2
            WITH FRAME {&FRAME-NAME}.      
  END.

  RUN vtagn/p-linea-de-credito01 ( s-CodCli, OUTPUT t-Resultado).
  DISPLAY t-resultado @ x-importe WITH FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Handle W-Win 
PROCEDURE Procesa-Handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER pParameter AS CHAR.
    CASE pParameter:
        WHEN 'Open-Query' THEN DO:
            /*RUN dispatch IN h_b-prov02 ('row-changed').*/
        END.
        WHEN 'Open-Query-2' THEN DO:
            /*RUN dispatch IN h_b-prov ('open-query').*/
        END.
        WHEN 'Open-Query-3' THEN DO:
            RUN dispatch IN h_b-detcatvta_prov ('open-query').
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

