&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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


Def var s-codcia    as inte init 1.
Def var x-signo1    as inte init 1.
Def var x-fin       as inte init 0.
Def var f-factor    as deci init 0.
Def var x-NroFchI   as inte init 0.
Def var x-NroFchF   as inte init 0.
Def var x-CodFchI   as date format '99/99/9999' init TODAY.
Def var x-CodFchF   as date format '99/99/9999' init TODAY.
Def var i           as inte init 0.
Def var x-TpoCmbCmp as deci init 1.
Def var x-TpoCmbVta as deci init 1.
Def var x-Day       as inte format '99'   init 1.
Def var x-Month     as inte format '99'   init 1.
Def var x-Year      as inte format '9999' init 1.
Def var x-coe       as deci init 0.
Def var x-can       as deci init 0.
def var x-fmapgo    as char.
def var x-canal     as char.


Def BUFFER B-CDOCU FOR CcbCdocu.

DEF TEMP-TABLE T-detalle
        FIELDS canal LIKE AlmTabla.codigo 
        FIELDS vendedor LIKE AlmTabla.codigo
        FIELDS cliente LIKE AlmTabla.codigo
        FIELDS familia LIKE AlmTabla.codigo
        FIELDS mes AS CHAR EXTENT 12.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-61 FILL-IN-periodo F-DIVISION F-CodFam ~
F-Canal Btn_OK DesdeF Btn_Cancel HastaF 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-periodo F-DIVISION F-CodFam ~
F-Canal DesdeF HastaF 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE DesdeF AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE VARIABLE F-Canal AS CHARACTER FORMAT "X(4)":U 
     LABEL "Canal" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-CodFam AS CHARACTER FORMAT "X(3)":U 
     LABEL "Linea" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-DIVISION AS CHARACTER FORMAT "X(5)":U 
     LABEL "Division" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-periodo AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "Periodo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .81 NO-UNDO.

DEFINE VARIABLE HastaF AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-61
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45 BY 9.65
     BGCOLOR 3 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-periodo AT ROW 3.35 COL 8.57 COLON-ALIGNED
     F-DIVISION AT ROW 4.31 COL 8.57 COLON-ALIGNED
     F-CodFam AT ROW 5.27 COL 8.57 COLON-ALIGNED
     F-Canal AT ROW 6.23 COL 8.57 COLON-ALIGNED
     Btn_OK AT ROW 11.58 COL 7
     DesdeF AT ROW 8.38 COL 11.14 COLON-ALIGNED
     Btn_Cancel AT ROW 11.58 COL 29
     HastaF AT ROW 8.46 COL 32.86 COLON-ALIGNED
     RECT-61 AT ROW 1.58 COL 2
     " Criterio de Selección" VIEW-AS TEXT
          SIZE 18.57 BY .5 AT ROW 2.15 COL 4
          FONT 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 12.23
         WIDTH              = 47.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel V-table-Win
ON CHOOSE OF Btn_Cancel IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK V-table-Win
ON CHOOSE OF Btn_OK IN FRAME F-Main /* Aceptar */
DO:
  RUN Asigna-Variables.
  RUN Valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". 
 /* RUN Inhabilita.*/
  RUN Imprime.
 /* RUN Habilita.*/
  RUN Inicializa-Variables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Canal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Canal V-table-Win
ON LEAVE OF F-Canal IN FRAME F-Main /* Canal */
DO:
   ASSIGN F-Canal.
   IF SELF:SCREEN-VALUE = "" THEN RETURN.
   IF F-Canal = "" THEN DO:
      SELF:SCREEN-VALUE = "".
      RETURN.
   END.
   FIND AlmTabla WHERE AlmTabla.Tabla = 'CN' 
                 AND  AlmTabla.Codigo = SELF:SCREEN-VALUE 
                 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE AlmTabla THEN DO:
      MESSAGE "Codigo de Canal no Existe" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-CodFam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-CodFam V-table-Win
ON LEAVE OF F-CodFam IN FRAME F-Main /* Linea */
DO:
   ASSIGN F-CodFam.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-DIVISION
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-DIVISION V-table-Win
ON LEAVE OF F-DIVISION IN FRAME F-Main /* Division */
DO:
 /*DO WITH FRAME {&FRAME-NAME}:
 * 
 *  ASSIGN F-DIVISION.
 *  IF F-DIVISION = "" AND ( LOOKUP(C-TIPO,"Resumen-Proveedor,Resumen-Sublinea") = 0 ) THEN DO:
 *      SELF:SCREEN-VALUE = "".
 *      ENABLE F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6.  
 *      F-DIVISION-1 = "00001" .
 *      F-DIVISION-2 = "00002" .
 *      F-DIVISION-3 = "00003" .
 *      F-DIVISION-4 = "00000" .
 *      F-DIVISION-5 = "00005" .
 *      F-DIVISION-6 = "00006" .
 *      DISPLAY F-DIVISION-1 F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6 .
 *      RUN local-initialize.
 *      RETURN.
 *  END.*/

 /*IF F-DIVISION <> "" THEN DO:
 *         
 *         FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
 *                            Gn-Divi.Coddiv = F-DIVISION NO-LOCK NO-ERROR.
 *         IF NOT AVAILABLE Gn-Divi THEN DO:
 *             MESSAGE "Division " + F-DIVISION + " No Existe " SKIP
 *                     "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
 *             APPLY "ENTRY" TO F-DIVISION IN FRAME {&FRAME-NAME}.
 *             RETURN NO-APPLY.
 *         END.    
 *         IF  LOOKUP(C-TIPO,"Resumen-Proveedor,Resumen-Sublinea") = 0  THEN DO:                         
 *             F-DIVISION-1 = F-DIVISION .
 *             F-NOMDIV-1 = Gn-Divi.DesDiv.           
 *             F-DIVISION-2 = "" .
 *             F-DIVISION-3 = "" .
 *             F-DIVISION-4 = "" .
 *             F-DIVISION-5 = "" .
 *             F-DIVISION-6 = "" .
 *             F-NOMDIV-2   = "".
 *             F-NOMDIV-3   = "".
 *             F-NOMDIV-4   = "".
 *             F-NOMDIV-5   = "".
 *             F-NOMDIV-6   = "".
 *             DISPLAY F-NOMDIV-1 F-NOMDIV-2 F-NOMDIV-3 F-NOMDIV-4 F-NOMDIV-5 F-NOMDIV-6 
 *                     F-DIVISION-1 F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6 
 *                     WITH FRAME {&FRAME-NAME}.
 *             DISABLE F-DIVISION-2 F-DIVISION-3 F-DIVISION-4 F-DIVISION-5 F-DIVISION-6.
 *         END.
 *       
 *   END.
 *  END.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Variables V-table-Win 
PROCEDURE Asigna-Variables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DO WITH FRAME {&FRAME-NAME}:
  ASSIGN 
         F-Division 
         F-CodFam 
         F-Canal 
         DesdeF 
         HastaF.
   
/*  S-SUBTIT =   "PERIODO      : " + STRING(DesdeF,"99/99/9999") + " al " + STRING(HastaF,"99/99/9999").*/

  IF DesdeF = ?  THEN DesdeF = 01/01/1900.
  IF HastaF = ?  THEN HastaF = 01/01/3000.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-temporal V-table-Win 
PROCEDURE Carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 x-CodFchI = TODAY - 3.
 x-CodFchF = 11/01/9999.

  x-CodFchI = x-CodFchI - DAY(x-CodFchI) + 1.

  DO WHILE MONTH(x-CodFchF + 1) = MONTH(x-CodFchF):
           x-CodFchF = x-CodFchF + 1. 
  END. 
 
  x-CodFchF = x-CodFchF + 1.
  
x-codfchi = DATE(MONTH(TODAY - 30), 01, YEAR(TODAY - 30)).
x-codfchf = TODAY - 1.

x-NroFchI = INTEGER(STRING(YEAR(x-CodFchI),"9999") + STRING(MONTH(x-CodFchI),"99")).      
x-NroFchF = INTEGER(STRING(YEAR(x-CodFchF),"9999") + STRING(MONTH(x-CodFchF),"99")).                           

DISPLAY x-CodFchI x-CodFchF x-NroFchI x-NroFchF.
PAUSE 0.
    
    /*FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CodCia
 *         use-index Idx01 
 *         no-lock :
 *    
 *         FOR EACH CcbCdocu WHERE CcbCdocu.CodCia = S-CODCIA 
 *                             AND CcbCdocu.CodDiv = Gn-Divi.CodDiv
 *                             AND CcbCdocu.FchDoc >= x-CodFchI
 *                             AND CcbCdocu.FchDoc <= x-CodFchF
 *                             USE-INDEX llave10
 *                             BREAK BY CcbCdocu.CodCia
 *                                   BY CcbCdocu.CodDiv
 *                                   BY CcbCdocu.FchDoc:
 *             /* ***************** FILTROS ********************************** */
 *             IF Lookup(CcbCDocu.CodDoc,"TCK,FAC,BOL,N/C,N/D") = 0 THEN NEXT.
 *             IF CcbCDocu.FlgEst = "A"  THEN NEXT.
 *             IF CcbCDocu.ImpCto = ? THEN DO:
 *                 CcbCDocu.ImpCto = 0.
 *             END.
 *             IF DAY(CcbCDocu.FchDoc) = 0 OR DAY(CcbCDocu.FchDoc) = ?
 *             THEN NEXT.
 *             /* *********************************************************** */
 *             x-signo1 = IF CcbCdocu.Coddoc = "N/C" THEN -1 ELSE 1.
 *             DISPLAY CcbCdocu.Codcia
 *                     CcbCdocu.Coddiv
 *                     CcbCdocu.FchDoc 
 *                     CcbCdocu.CodDoc
 *                     CcbCdocu.NroDoc
 *                     STRING(TIME,'HH:MM')
 *                     TODAY .
 *             PAUSE 0.
 *      
 *             ASSIGN
 *                 x-Day   = DAY(CcbCdocu.FchDoc)
 *                 x-Month = MONTH(CcbCdocu.FchDoc)
 *                 x-Year  = YEAR(CcbCdocu.FchDoc).
 *                 FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
 *                                   USE-INDEX Cmb01
 *                                   NO-LOCK NO-ERROR.
 *                 IF NOT AVAIL Gn-Tcmb THEN 
 *                     FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
 *                                        USE-INDEX Cmb01
 *                                        NO-LOCK NO-ERROR.
 *                 IF AVAIL Gn-Tcmb THEN 
 *                     ASSIGN
 *                     x-TpoCmbCmp = Gn-Tcmb.Compra
 *                     x-TpoCmbVta = Gn-Tcmb.Venta.
 *             
 *             IF Ccbcdocu.CodMon = 1 THEN 
 *                 ASSIGN
 *                     EvtDivi.VtaxMesMn = EvtDivi.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot
 *                     EvtDivi.VtaxMesMe = EvtDivi.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot / x-TpoCmbCmp.
 *             IF Ccbcdocu.CodMon = 2 THEN 
 *                 ASSIGN
 *                     EvtDivi.VtaxMesMn = EvtDivi.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot * x-TpoCmbVta
 *                     EvtDivi.VtaxMesMe = EvtDivi.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot.
 * 
 * 
 *            IF CcbCdocu.Coddoc = "N/C" AND CcbCdocu.CndCre = "N" THEN RUN PROCESA-NOTA.
 * 
 *            FOR EACH CcbDdocu OF CcbCdocu NO-LOCK:
 *                
 *                FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia AND
 *                                    Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR.
 *                IF NOT AVAILABLE Almmmatg THEN NEXT.
 *                FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
 *                                    Almtconv.Codalter = Ccbddocu.UndVta
 *                                    NO-LOCK NO-ERROR.
 *                F-FACTOR  = 1. 
 *                IF AVAILABLE Almtconv THEN DO:
 *                   F-FACTOR = Almtconv.Equival.
 *                   IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
 *                END.
 *                
 *                IF Ccbcdocu.CodMon = 1 THEN 
 *                     ASSIGN
 *                         EvtArti.VtaxMesMn = EvtArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin
 *                         EvtArti.VtaxMesMe = EvtArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin / x-TpoCmbCmp.
 *                IF Ccbcdocu.CodMon = 2 THEN 
 *                     ASSIGN
 *                         EvtArti.VtaxMesMn = EvtArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta
 *                         EvtArti.VtaxMesMe = EvtArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin.
 *                ASSIGN            
 *                EvtArti.CanxMes = EvtArti.CanxMes + ( x-signo1 * CcbDdocu.CanDes * F-FACTOR ).
 * 
 *            END.  
 *         END.
 *     END.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato V-table-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime V-table-Win 
PROCEDURE Imprime :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    RUN Carga-temporal.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".
    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        RUN Formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-nota V-table-Win 
PROCEDURE Procesa-nota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH CcbDdocu OF CcbCdocu:
    x-can = IF CcbDdocu.CodMat = "00005" THEN 1 ELSE 0.
END.

FIND B-CDOCU WHERE B-CDOCU.Codcia = CcbCdocu.Codcia AND
                   B-CDOCU.CodDoc = CcbCdocu.Codref AND
                   B-CDOCU.NroDoc = CcbCdocu.Nroref 
                   NO-LOCK NO-ERROR.
IF AVAILABLE B-CDOCU THEN DO:
           x-coe = CcbCdocu.ImpTot / B-CDOCU.ImpTot.
           FOR EACH CcbDdocu OF B-CDOCU NO-LOCK:
               
               FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia AND
                                   Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR.
               IF NOT AVAILABLE Almmmatg THEN NEXT.
               FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                                   Almtconv.Codalter = Ccbddocu.UndVta
                                   NO-LOCK NO-ERROR.
               F-FACTOR  = 1. 
               IF AVAILABLE Almtconv THEN DO:
                  F-FACTOR = Almtconv.Equival.
                  IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
               END.
               
               IF Ccbcdocu.CodMon = 1 THEN 
                    ASSIGN
                       EvtArti.VtaxMesMn = EvtArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-coe
                       EvtArti.VtaxMesMe = EvtArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin * x-coe / x-TpoCmbCmp.
               IF Ccbcdocu.CodMon = 2 THEN 
                    ASSIGN
                        EvtArti.VtaxMesMn = EvtArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta * x-coe
                        EvtArti.VtaxMesMe = EvtArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin * x-coe.
               ASSIGN            
               EvtArti.CanxMes = EvtArti.CanxMes + ( x-signo1 * CcbDdocu.CanDes * F-FACTOR * x-can).

           END.  
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros V-table-Win 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros V-table-Win 
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
        WHEN "" THEN .
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Valida V-table-Win 
PROCEDURE Valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF F-DIVISION <> "" THEN DO:
        DO I = 1 TO NUM-ENTRIES(F-DIVISION):
          FIND Gn-Divi WHERE Gn-Divi.Codcia = S-CODCIA AND
                             Gn-Divi.Coddiv = ENTRY(I,F-DIVISION) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Gn-Divi THEN DO:
            MESSAGE "Division " + ENTRY(I,F-DIVISION) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-DIVISION IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
        END.
END.

IF F-CODFAM <> "" THEN DO:
        DO I = 1 TO NUM-ENTRIES(F-CODFAM):
          FIND AlmtFami WHERE AlmtFami.Codcia = S-CODCIA AND
                              AlmtFami.CodFam = ENTRY(I,F-CODFAM) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE AlmtFami THEN DO:
            MESSAGE "Familia " + ENTRY(I,F-CODFAM) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-CODFAM IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
        END.
END.


IF F-CANAL <> "" THEN DO:
        DO I = 1 TO NUM-ENTRIES(F-Canal):
          FIND AlmTabla WHERE AlmTabla.Tabla = 'CN' AND
                              AlmTabla.Codigo = ENTRY(I,F-Canal) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE AlmTabla THEN DO:
            MESSAGE "Canal " + ENTRY(I,F-Canal) + " No Existe " SKIP
                    "Verifique Por Favor ....."  VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO F-Canal IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR".
          END.                             
        END.
END.


RETURN "OK".
END PROCEDURE.


/*
 * DO WITH FRAME {&FRAME-NAME} :
 *    /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
 *          MESSAGE "Campo no debe ser blanco"
 *          VIEW-AS ALERT-BOX ERROR.
 *          APPLY "ENTRY" TO CAMPO.
 *          RETURN "ADM-ERROR".   
 *    
 *       END.
 *    */
 * 
 * END.
 * 
 * RETURN "OK".
 END PROCEDURE.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


