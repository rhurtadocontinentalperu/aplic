&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          cissac           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
{adecomm/appserv.i}


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE T-GUIAS NO-UNDO LIKE cissac.CcbCDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM2 SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEF INPUT PARAMETER pRowid AS ROWID.

/* Local Variable Definitions ---                                       */

{src/adm2/widgetprto.i}

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-codalm AS CHAR NO-UNDO.
DEF VAR s-coddoc AS CHAR NO-UNDO.
DEF VAR s-coddiv AS CHAR NO-UNDO.
DEF VAR s-porigv LIKE integral.ccbcdocu.porigv NO-UNDO.
DEF VAR I-NITEM  AS INT NO-UNDO.
DEF VAR F-FACTOR AS DEC NO-UNDO.
DEF VAR F-IGV    AS DEC NO-UNDO.
DEF VAR F-ISC    AS DEC NO-UNDO.
DEF VAR x-NroCot AS ROWID NO-UNDO.
DEF VAR x-NroPed AS ROWID NO-UNDO.
DEF VAR x-NroOD  AS ROWID NO-UNDO.
DEF VAR x-NroRf2 AS CHAR NO-UNDO.
DEF VAR x-NroRf3 AS CHAR NO-UNDO.

FIND integral.FacCfgGn WHERE integral.FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
s-PorIgv = FacCfgGn.PorIgv.

DEF BUFFER CCOT FOR cissac.Faccpedi.
DEF BUFFER DCOT FOR cissac.Facdpedi.
DEF BUFFER CPED FOR cissac.Faccpedi.
DEF BUFFER DPED FOR cissac.Facdpedi.

FIND integral.Lg-cocmp WHERE ROWID(integral.Lg-cocmp) = pRowid NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-NroSerCot COMBO-BOX-NroSerPed ~
COMBO-BOX-NroSerOD COMBO-BOX-NroSerGR COMBO-BOX-NroSerFac Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodAlm COMBO-BOX-NroSerCot ~
FILL-IN-NroCot COMBO-BOX-NroSerPed FILL-IN-NroPed COMBO-BOX-NroSerOD ~
FILL-IN-NroOD COMBO-BOX-NroSerGR FILL-IN-NroGR COMBO-BOX-NroSerFac ~
FILL-IN-NroFac FILL-IN-AlmIng 

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
     SIZE 15 BY 1.73.

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "OK" 
     SIZE 15 BY 1.73.

DEFINE VARIABLE COMBO-BOX-NroSerCot AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Cotización N°" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-NroSerFac AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "FAC N°" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-NroSerGR AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "G/R N°" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-NroSerOD AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Orden N°" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-NroSerPed AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Pedido N°" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-AlmIng AS CHARACTER FORMAT "X(256)":U 
     LABEL "Almacén de Ingreso" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodAlm AS CHARACTER FORMAT "X(256)":U INITIAL "21" 
     LABEL "Almacén de descarga" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroCot AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroFac AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroGR AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroOD AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-NroPed AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .81 NO-UNDO.

DEFINE VARIABLE OK-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 10 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE OK-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 10 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE OK-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 10 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE OK-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 10 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE OK-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 10 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE OK-6 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .81
     BGCOLOR 10 FGCOLOR 0 FONT 6 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     FILL-IN-CodAlm AT ROW 1.19 COL 19 COLON-ALIGNED WIDGET-ID 4
     COMBO-BOX-NroSerCot AT ROW 2.15 COL 19 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-NroCot AT ROW 2.15 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     OK-1 AT ROW 2.15 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 44
     COMBO-BOX-NroSerPed AT ROW 3.12 COL 19 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-NroPed AT ROW 3.12 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     OK-2 AT ROW 3.12 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 56
     COMBO-BOX-NroSerOD AT ROW 4.08 COL 19 COLON-ALIGNED WIDGET-ID 24
     FILL-IN-NroOD AT ROW 4.08 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     OK-3 AT ROW 4.08 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 58
     COMBO-BOX-NroSerGR AT ROW 5.04 COL 19 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-NroGR AT ROW 5.04 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     OK-4 AT ROW 5.04 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     COMBO-BOX-NroSerFac AT ROW 6 COL 19 COLON-ALIGNED WIDGET-ID 20
     FILL-IN-NroFac AT ROW 6 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     OK-5 AT ROW 6 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     FILL-IN-AlmIng AT ROW 6.96 COL 19 COLON-ALIGNED WIDGET-ID 28
     OK-6 AT ROW 6.96 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 64
     Btn_OK AT ROW 8.31 COL 4
     Btn_Cancel AT ROW 8.31 COL 19
     SPACE(31.13) SKIP(0.68)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "PARAMETROS PARA LA GENERACION DE COMPROBANTES"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE APPSERVER
   Temp-Tables and Buffers:
      TABLE: T-GUIAS T "?" NO-UNDO cissac CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   FRAME-NAME                                                           */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-AlmIng IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodAlm IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroCot IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroFac IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroGR IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroOD IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NroPed IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN OK-1 IN FRAME gDialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       OK-1:HIDDEN IN FRAME gDialog           = TRUE.

/* SETTINGS FOR FILL-IN OK-2 IN FRAME gDialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       OK-2:HIDDEN IN FRAME gDialog           = TRUE.

/* SETTINGS FOR FILL-IN OK-3 IN FRAME gDialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       OK-3:HIDDEN IN FRAME gDialog           = TRUE.

/* SETTINGS FOR FILL-IN OK-4 IN FRAME gDialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       OK-4:HIDDEN IN FRAME gDialog           = TRUE.

/* SETTINGS FOR FILL-IN OK-5 IN FRAME gDialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       OK-5:HIDDEN IN FRAME gDialog           = TRUE.

/* SETTINGS FOR FILL-IN OK-6 IN FRAME gDialog
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       OK-6:HIDDEN IN FRAME gDialog           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* PARAMETROS PARA LA GENERACION DE COMPROBANTES */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* OK */
DO:
  ASSIGN
      COMBO-BOX-NroSerCot 
      COMBO-BOX-NroSerFac 
      COMBO-BOX-NroSerGR 
      COMBO-BOX-NroSerOD 
      COMBO-BOX-NroSerPed 
      FILL-IN-CodAlm
      FILL-IN-AlmIng.
   RUN Genera-Venta-Cissac-Conti.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-NroSerCot
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-NroSerCot gDialog
ON VALUE-CHANGED OF COMBO-BOX-NroSerCot IN FRAME gDialog /* Cotización N° */
DO:
    ASSIGN {&self-name}.
    FIND cissac.Almacen WHERE cissac.Almacen.codcia = s-codcia
        AND cissac.Almacen.codalm = FILL-IN-CodAlm
        NO-LOCK NO-ERROR.
    FIND cissac.FacCorre WHERE cissac.FacCorre.CodCia = s-CodCia 
        AND cissac.FacCorre.CodDoc = "COT" 
        AND cissac.FacCorre.NroSer = {&self-name}
        NO-LOCK NO-ERROR.
    FILL-IN-NroCot = cissac.FacCorre.Correlativo.
    DISPLAY FILL-IN-NroCot WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-NroSerFac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-NroSerFac gDialog
ON VALUE-CHANGED OF COMBO-BOX-NroSerFac IN FRAME gDialog /* FAC N° */
DO:
    ASSIGN {&self-name}.
    FIND cissac.Almacen WHERE cissac.Almacen.codcia = s-codcia
        AND cissac.Almacen.codalm = FILL-IN-CodAlm
        NO-LOCK NO-ERROR.
    FIND cissac.FacCorre WHERE cissac.FacCorre.CodCia = s-CodCia 
        AND cissac.FacCorre.CodDoc = "FAC" 
        AND cissac.FacCorre.NroSer = {&self-name}
        NO-LOCK NO-ERROR.
    FILL-IN-NroFAC = cissac.FacCorre.Correlativo.
    DISPLAY FILL-IN-NroFAC WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-NroSerGR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-NroSerGR gDialog
ON VALUE-CHANGED OF COMBO-BOX-NroSerGR IN FRAME gDialog /* G/R N° */
DO:
    ASSIGN {&self-name}.
    FIND cissac.Almacen WHERE cissac.Almacen.codcia = s-codcia
        AND cissac.Almacen.codalm = FILL-IN-CodAlm
        NO-LOCK NO-ERROR.
    FIND cissac.FacCorre WHERE cissac.FacCorre.CodCia = s-CodCia 
        AND cissac.FacCorre.CodDoc = "G/R" 
        AND cissac.FacCorre.NroSer = {&self-name}
        NO-LOCK NO-ERROR.
    FILL-IN-NroGR = cissac.FacCorre.Correlativo.
    DISPLAY FILL-IN-NroGR WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-NroSerOD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-NroSerOD gDialog
ON VALUE-CHANGED OF COMBO-BOX-NroSerOD IN FRAME gDialog /* Orden N° */
DO:
    ASSIGN {&self-name}.
    FIND cissac.Almacen WHERE cissac.Almacen.codcia = s-codcia
        AND cissac.Almacen.codalm = FILL-IN-CodAlm
        NO-LOCK NO-ERROR.
    FIND cissac.FacCorre WHERE cissac.FacCorre.CodCia = s-CodCia 
        AND cissac.FacCorre.CodDoc = "O/D" 
        AND cissac.FacCorre.NroSer = {&self-name}
        NO-LOCK NO-ERROR.
    FILL-IN-NroOD = cissac.FacCorre.Correlativo.
    DISPLAY FILL-IN-NroOD WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-NroSerPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-NroSerPed gDialog
ON VALUE-CHANGED OF COMBO-BOX-NroSerPed IN FRAME gDialog /* Pedido N° */
DO:
    ASSIGN {&self-name}.
    FIND cissac.Almacen WHERE cissac.Almacen.codcia = s-codcia
        AND cissac.Almacen.codalm = FILL-IN-CodAlm
        NO-LOCK NO-ERROR.
    FIND cissac.FacCorre WHERE cissac.FacCorre.CodCia = s-CodCia 
        AND cissac.FacCorre.CodDoc = "PED" 
        AND cissac.FacCorre.NroSer = {&self-name}
        NO-LOCK NO-ERROR.
    FILL-IN-NroPed = cissac.FacCorre.Correlativo.
    DISPLAY FILL-IN-NroPed WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE act_alm gDialog 
PROCEDURE act_alm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER X-ROWID AS ROWID.

/* DEF SHARED VAR s-codcia  AS INT.  */
/* DEF SHARED VAR s-user-id AS CHAR. */
/* DEF SHARED VAR s-codalm  AS CHAR. */
/* DEF SHARED VAR s-coddiv  AS CHAR. */

DEF VAR c-codalm AS CHAR.

FIND cissac.ccbcdocu WHERE ROWID(cissac.ccbcdocu) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE cissac.ccbcdocu THEN RETURN 'OK'.

c-codalm = cissac.ccbcdocu.codalm.

DEF VAR i AS INTEGER INITIAL 1 NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
   /* Correlativo de Salida */
   FIND CURRENT cissac.ccbcdocu EXCLUSIVE-LOCK NO-ERROR.
   IF ERROR-STATUS:ERROR THEN RETURN 'ADM-ERROR'.
   FIND cissac.Almacen WHERE 
        cissac.Almacen.CodCia = s-codcia AND
        /*cissac.Almacen.CodAlm = s-codalm */
        cissac.Almacen.CodAlm = c-codalm       /* OJO */
        EXCLUSIVE-LOCK NO-ERROR.
   IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
   CREATE cissac.almcmov.
   ASSIGN cissac.almcmov.CodCia  = cissac.ccbcdocu.CodCia 
          cissac.almcmov.CodAlm  = cissac.ccbcdocu.CodAlm 
          cissac.almcmov.TipMov  = "S"
          cissac.almcmov.CodMov  = cissac.ccbcdocu.CodMov
          cissac.almcmov.NroSer  = 0 /* INTEGER(SUBSTRING(cissac.ccbcdocu.NroDoc,1,3)) */
          cissac.almcmov.NroDoc  = cissac.Almacen.CorrSal 
          cissac.Almacen.CorrSal = cissac.Almacen.CorrSal + 1
          cissac.almcmov.FchDoc  = cissac.ccbcdocu.FchDoc
          cissac.almcmov.HorSal  = STRING(TIME, "HH:MM:SS")
          cissac.almcmov.CodVen  = cissac.ccbcdocu.CodVen
          cissac.almcmov.CodCli  = cissac.ccbcdocu.CodCli
          cissac.almcmov.Nomref  = cissac.ccbcdocu.NomCli
          cissac.almcmov.CodRef  = cissac.ccbcdocu.CodDoc
          cissac.almcmov.NroRef  = cissac.ccbcdocu.nrodoc
          cissac.almcmov.NroRf1  = SUBSTRING(cissac.ccbcdocu.CodDoc,1,1) + cissac.ccbcdocu.NroDoc
          cissac.almcmov.NroRf2  = cissac.ccbcdocu.NroPed
          cissac.almcmov.usuario = s-user-id
          cissac.ccbcdocu.NroSal = STRING(cissac.almcmov.NroDoc).
   
   DETALLE:
   FOR EACH cissac.ccbddocu OF cissac.ccbcdocu NO-LOCK:
        /* RHC 22.10.08 FACTURAS ADELANTADAS */            
        IF cissac.ccbddocu.implin < 0 THEN NEXT DETALLE.
        
       CREATE cissac.Almdmov.
       ASSIGN cissac.Almdmov.CodCia = cissac.almcmov.CodCia
              cissac.Almdmov.CodAlm = cissac.almcmov.CodAlm
              cissac.Almdmov.CodMov = cissac.almcmov.CodMov 
              cissac.Almdmov.NroSer = cissac.almcmov.nroser
              cissac.Almdmov.NroDoc = cissac.almcmov.nrodoc
              cissac.Almdmov.AftIgv = cissac.ccbddocu.aftigv
              cissac.Almdmov.AftIsc = cissac.ccbddocu.aftisc
              cissac.Almdmov.CanDes = cissac.ccbddocu.candes
              cissac.Almdmov.codmat = cissac.ccbddocu.codmat
              cissac.Almdmov.CodMon = cissac.ccbcdocu.codmon
              cissac.Almdmov.CodUnd = cissac.ccbddocu.undvta
              cissac.Almdmov.Factor = cissac.ccbddocu.factor
              cissac.Almdmov.FchDoc = cissac.ccbcdocu.FchDoc
              cissac.Almdmov.ImpDto = cissac.ccbddocu.impdto
              cissac.Almdmov.ImpIgv = cissac.ccbddocu.impigv
              cissac.Almdmov.ImpIsc = cissac.ccbddocu.impisc
              cissac.Almdmov.ImpLin = cissac.ccbddocu.implin
              cissac.Almdmov.NroItm = i
              cissac.Almdmov.PorDto = cissac.ccbddocu.pordto
              cissac.Almdmov.PreBas = cissac.ccbddocu.prebas
              cissac.Almdmov.PreUni = cissac.ccbddocu.preuni
              cissac.Almdmov.TipMov = "S"
              cissac.Almdmov.TpoCmb = cissac.ccbcdocu.tpocmb
              cissac.almcmov.TotItm = i
              cissac.Almdmov.HraDoc = cissac.almcmov.HorSal
              i = i + 1.
       RUN almdcstk (ROWID(cissac.Almdmov)).
       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
       /* RHC 05.04.04 ACTIVAMOS KARDEX POR cissac.Almacen */
       RUN almacpr1 (ROWID(cissac.Almdmov), 'U').
       IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
   END.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE almacpr1 gDialog 
PROCEDURE almacpr1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER R-DMov AS ROWID.
DEFINE INPUT PARAMETER C-UD   AS CHAR.
DEFINE VARIABLE I-CODMAT   AS CHAR NO-UNDO.
DEFINE VARIABLE C-CODALM   AS CHAR NO-UNDO.
DEFINE VARIABLE F-CANDES   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-IMPCTO   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-STKSUB   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-STKACT   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-VCTOMN   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-VCTOME   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-TCTOMN   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-TCTOME   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PCTOMN   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PCTOME   AS DECIMAL NO-UNDO.
DEFINE VARIABLE L-INGRESO  AS LOGICAL NO-UNDO.

/* Ubicamos el detalle a Actualizar */
FIND cissac.AlmDMov WHERE ROWID(cissac.AlmDMov) = R-DMov NO-LOCK NO-ERROR.
IF NOT AVAILABLE cissac.AlmDMov THEN RETURN.
/* Inicio de Transaccion */
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
    /* ************** RHC 30.03.04 ******************* */
    FIND cissac.AlmDMov WHERE ROWID(cissac.AlmDMov) = r-dmov NO-LOCK NO-ERROR.
    ASSIGN I-CODMAT = cissac.AlmDMov.CodMaT
           C-CODALM = cissac.AlmDMov.CodAlm
           F-CANDES = cissac.AlmDMov.CanDes
           F-IMPCTO = cissac.AlmDMov.ImpCto.
    IF cissac.AlmDMov.Factor > 0 THEN ASSIGN F-CANDES = cissac.AlmDMov.CanDes * cissac.AlmDMov.Factor.
    /* Buscamos el stock inicial */
    FIND PREV cissac.AlmDMov USE-INDEX ALMD02 WHERE cissac.AlmDMov.codcia = s-codcia
        AND cissac.AlmDMov.codmat = i-codmat
        AND cissac.AlmDMov.codalm = c-codalm
        NO-LOCK NO-ERROR.
    IF AVAILABLE cissac.AlmDMov
    THEN f-StkSub = cissac.AlmDMov.stksub.
    ELSE f-StkSub = 0.
    /* actualizamos el kardex por almacen */
    FIND cissac.AlmDMov WHERE ROWID(cissac.AlmDMov) = r-dmov EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    IF C-UD = 'D'       /* Eliminar */
    THEN cissac.AlmDMov.candes = 0.        /* OJO */
    REPEAT WHILE AVAILABLE cissac.AlmDMov:
        L-INGRESO = LOOKUP(cissac.AlmDMov.TipMov,"I,U") <> 0.
        F-CANDES = cissac.AlmDMov.CanDes.
        IF cissac.AlmDMov.Factor > 0 THEN F-CANDES = cissac.AlmDMov.CanDes * cissac.AlmDMov.Factor.
        IF L-INGRESO 
        THEN F-STKSUB = F-STKSUB + F-CANDES.
        ELSE F-STKSUB = F-STKSUB - F-CANDES.
        cissac.AlmDMov.StkSub = F-STKSUB.      /* OJO */
        FIND NEXT cissac.AlmDMov USE-INDEX ALMD02 WHERE cissac.AlmDMov.codcia = s-codcia
            AND cissac.AlmDMov.codmat = i-codmat
            AND cissac.AlmDMov.codalm = c-codalm
            NO-LOCK NO-ERROR.
        IF AVAILABLE cissac.AlmDMov
        THEN DO:
            FIND CURRENT cissac.AlmDMov EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO, RETURN "ADM-ERROR".
        END.
    END.
END.        


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ALMACPR1-ING gDialog 
PROCEDURE ALMACPR1-ING :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEFINE INPUT PARAMETER R-DMov AS ROWID.
DEFINE INPUT PARAMETER C-UD   AS CHAR.
DEFINE VARIABLE I-CODMAT   AS CHAR NO-UNDO.
DEFINE VARIABLE C-CODALM   AS CHAR NO-UNDO.
DEFINE VARIABLE F-CANDES   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-IMPCTO   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-STKSUB   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-STKACT   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-VCTOMN   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-VCTOME   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-TCTOMN   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-TCTOME   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PCTOMN   AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PCTOME   AS DECIMAL NO-UNDO.
DEFINE VARIABLE L-INGRESO  AS LOGICAL NO-UNDO.

/* Ubicamos el detalle a Actualizar */
FIND integral.AlmDMov WHERE ROWID(integral.AlmDMov) = R-DMov NO-LOCK NO-ERROR.
IF NOT AVAILABLE integral.AlmDMov THEN RETURN 'OK'.
/* Inicio de Transaccion */
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
    /* ************** RHC 30.03.04 ******************* */
    FIND integral.AlmDMov WHERE ROWID(integral.AlmDMov) = r-dmov NO-LOCK NO-ERROR.
    ASSIGN I-CODMAT = integral.AlmDMov.CodMaT
           C-CODALM = integral.AlmDMov.CodAlm
           F-CANDES = integral.AlmDMov.CanDes
           F-IMPCTO = integral.AlmDMov.ImpCto.
    IF integral.AlmDMov.Factor > 0 THEN ASSIGN F-CANDES = integral.AlmDMov.CanDes * integral.AlmDMov.Factor.
    /* Buscamos el stock inicial */
    FIND PREV integral.AlmDMov USE-INDEX ALMD03 WHERE integral.AlmDMov.codcia = s-codcia
        AND integral.AlmDMov.codmat = i-codmat
        AND integral.AlmDMov.codalm = c-codalm
        NO-LOCK NO-ERROR.
    IF AVAILABLE integral.AlmDMov
    THEN f-StkSub = integral.AlmDMov.stksub.
    ELSE f-StkSub = 0.
    /* actualizamos el kardex por almacen */
    FIND integral.AlmDMov WHERE ROWID(integral.AlmDMov) = r-dmov EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
    IF C-UD = 'D'       /* Eliminar */
    THEN integral.AlmDMov.candes = 0.        /* OJO */
    REPEAT WHILE AVAILABLE integral.AlmDMov:
        L-INGRESO = LOOKUP(integral.AlmDMov.TipMov,"I,U") <> 0.
        F-CANDES = integral.AlmDMov.CanDes.
        IF integral.AlmDMov.Factor > 0 THEN F-CANDES = integral.AlmDMov.CanDes * integral.AlmDMov.Factor.
        IF L-INGRESO 
        THEN F-STKSUB = F-STKSUB + F-CANDES.
        ELSE F-STKSUB = F-STKSUB - F-CANDES.
        integral.AlmDMov.StkSub = F-STKSUB.      /* OJO */
        FIND NEXT integral.AlmDMov USE-INDEX ALMD03 WHERE integral.AlmDMov.codcia = s-codcia
            AND integral.AlmDMov.codmat = i-codmat
            AND integral.AlmDMov.codalm = c-codalm
            NO-LOCK NO-ERROR.
        IF AVAILABLE integral.AlmDMov
        THEN DO:
            FIND CURRENT integral.AlmDMov EXCLUSIVE-LOCK NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO, RETURN "ADM-ERROR".
        END.
    END.
END.        
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ALMACSTK gDialog 
PROCEDURE ALMACSTK :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER R-DMov AS ROWID.
DEFINE VARIABLE I-CODMAT AS CHAR NO-UNDO.
DEFINE VARIABLE C-CODALM AS CHAR NO-UNDO.
DEFINE VARIABLE F-CANDES AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUNI AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUMN AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUME AS DECIMAL NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Ubicamos el detalle a Actualizar */
    FIND integral.AlmDMov WHERE ROWID(integral.AlmDMov) = R-DMov NO-LOCK NO-ERROR.
    IF NOT AVAILABLE integral.AlmDMov THEN RETURN.

    ASSIGN I-CODMAT = integral.AlmDMov.CodMaT
           C-CODALM = integral.AlmDMov.CodAlm
           F-CANDES = integral.AlmDMov.CanDes
           F-PREUNI = integral.AlmDMov.PreUni.
    IF integral.AlmDMov.CodMon = 1 
    THEN DO:
         F-PREUMN = integral.AlmDMov.PreUni.
         IF integral.AlmDMov.TpoCmb > 0 
         THEN F-PREUME = ROUND(integral.AlmDMov.PreUni / integral.AlmDMov.TpoCmb,4).
         ELSE F-PREUME = 0.
    END.
    ELSE ASSIGN F-PREUMN = ROUND(integral.AlmDMov.PreUni * integral.AlmDMov.TpoCmb,4)
                F-PREUME = integral.AlmDMov.PreUni.
    IF integral.AlmDMov.Factor > 0 THEN ASSIGN F-CANDES = integral.AlmDMov.CanDes * integral.AlmDMov.Factor
                                      F-PREUNI = integral.AlmDMov.PreUni / integral.AlmDMov.Factor
                                      F-PREUMN = F-PREUMN / integral.AlmDMov.Factor
                                      F-PREUME = F-PREUME / integral.AlmDMov.Factor.

    /* Actualizamos a los Materiales por Almacen */
    FIND integral.Almmmate WHERE integral.Almmmate.CodCia = S-CODCIA AND
         integral.Almmmate.CodAlm = C-CODALM AND 
         integral.Almmmate.CodMat = I-CODMAT EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.

    ASSIGN integral.Almmmate.StkAct = integral.Almmmate.StkAct + F-CANDES.
END.

RETURN 'OK'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE almdcstk gDialog 
PROCEDURE almdcstk :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER R-DMov AS ROWID.

DEFINE VARIABLE I-CODMAT AS CHAR NO-UNDO.
DEFINE VARIABLE C-CODALM AS CHAR NO-UNDO.
DEFINE VARIABLE F-CANDES AS DECIMAL NO-UNDO.
DEFINE VARIABLE F-PREUNI AS DECIMAL NO-UNDO.
/* DEFINE SHARED VAR S-CODCIA AS INTEGER. */

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Ubicamos el detalle a Actualizar */
    FIND cissac.Almdmov WHERE ROWID(cissac.Almdmov) = R-DMov NO-LOCK NO-ERROR.
    IF NOT AVAILABLE cissac.Almdmov THEN RETURN.
    ASSIGN 
      I-CODMAT = cissac.Almdmov.CodMaT
      C-CODALM = cissac.Almdmov.CodAlm
      F-CANDES = cissac.Almdmov.CanDes
      F-PREUNI = cissac.Almdmov.PreUni.
    IF cissac.Almdmov.Factor > 0 
    THEN ASSIGN 
              F-CANDES = cissac.Almdmov.CanDes * cissac.Almdmov.Factor
              F-PREUNI = cissac.Almdmov.PreUni / cissac.Almdmov.Factor.
    /* Des-Actualizamos a los Materiales por Almacen */
    FIND cissac.Almmmate WHERE cissac.Almmmate.CodCia = S-CODCIA AND
          cissac.Almmmate.CodAlm = C-CODALM AND 
          cissac.Almmmate.CodMat = I-CODMAT EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE cissac.Almmmate THEN DO:
        MESSAGE 'Codigo' i-codmat 'NO asignado en el almacen' c-codalm
            VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
    cissac.Almmmate.StkAct = cissac.Almmmate.StkAct - F-CANDES.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-CodAlm COMBO-BOX-NroSerCot FILL-IN-NroCot COMBO-BOX-NroSerPed 
          FILL-IN-NroPed COMBO-BOX-NroSerOD FILL-IN-NroOD COMBO-BOX-NroSerGR 
          FILL-IN-NroGR COMBO-BOX-NroSerFac FILL-IN-NroFac FILL-IN-AlmIng 
      WITH FRAME gDialog.
  ENABLE COMBO-BOX-NroSerCot COMBO-BOX-NroSerPed COMBO-BOX-NroSerOD 
         COMBO-BOX-NroSerGR COMBO-BOX-NroSerFac Btn_OK Btn_Cancel 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Cotizacion gDialog 
PROCEDURE Genera-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND cissac.FacCorre WHERE cissac.FacCorre.CodCia = S-CODCIA 
        AND cissac.FacCorre.CodDoc = s-coddoc
        AND cissac.FacCorre.NroSer = COMBO-BOX-NroSerCot
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
    CREATE cissac.FacCPedi.
    ASSIGN 
        cissac.FacCPedi.CodCia = S-CODCIA
        cissac.FacCPedi.CodDiv = S-CODDIV
        cissac.FacCPedi.CodDoc = s-coddoc 
        cissac.FacCPedi.FchPed = TODAY 
        cissac.FacCPedi.FchVen = (TODAY + 7)
        cissac.FacCPedi.CodAlm = S-CODALM
        cissac.FacCPedi.PorIgv = s-PorIgv 
        cissac.FacCPedi.NroPed = STRING(cissac.FacCorre.NroSer,"999") + STRING(cissac.FacCorre.Correlativo,"999999")
        cissac.FacCPedi.TpoPed = ""
        cissac.FacCPedi.Hora = STRING(TIME,"HH:MM")
        cissac.FacCPedi.FlgImpOD = YES
        cissac.FacCPedi.CodCli = cissac.gn-clie.codcli
        cissac.FacCPedi.NomCli = cissac.gn-clie.nomcli
        cissac.FacCPedi.DirCli = cissac.gn-clie.dircli
        cissac.FacCPedi.RucCli = cissac.gn-clie.ruc
        cissac.FacCPedi.CodVen = cissac.gn-clie.CodVen
        cissac.Faccpedi.fmapgo = ENTRY(1, gn-clie.cndvta)
        cissac.FacCPedi.CodMon = integral.Lg-cocmp.codmon
        cissac.FacCPedi.FlgIgv =  YES
        cissac.FacCPedi.Usuario = S-USER-ID
        cissac.FacCPedi.TipVta  = "1"
        cissac.FacCPedi.FlgEst  = "C".      /* CERRADO */
    /* REFERENCIA EN CASO DE EXTORNAR MOVIMIENTOS */
    ASSIGN
        cissac.FacCPedi.ordcmp = STRING(integral.Lg-cocmp.nrodoc, "9999999").
    /* ****************************************** */
    i-nItem = 0.
    FOR EACH integral.Lg-docmp OF integral.Lg-cocmp, 
        FIRST cissac.Almmmatg OF integral.Lg-docmp NO-LOCK:
        f-Factor = 1.
        FIND cissac.Almtconv WHERE cissac.Almtconv.CodUnid = cissac.Almmmatg.UndBas 
            AND  cissac.Almtconv.Codalter = integral.Lg-docmp.UndCmp
            NO-LOCK NO-ERROR.
        IF AVAILABLE cissac.Almtconv THEN F-FACTOR = cissac.Almtconv.Equival.
        I-NITEM = I-NITEM + 1.
        CREATE cissac.FacDPedi.
        ASSIGN 
            cissac.FacDPedi.CodCia = cissac.FacCPedi.CodCia
            cissac.FacDPedi.CodDiv = cissac.FacCPedi.CodDiv
            cissac.FacDPedi.coddoc = cissac.FacCPedi.coddoc
            cissac.FacDPedi.NroPed = cissac.FacCPedi.NroPed
            cissac.FacDPedi.FchPed = cissac.FacCPedi.FchPed
            cissac.FacDPedi.Hora   = cissac.FacCPedi.Hora 
            cissac.FacDPedi.FlgEst = cissac.FacCPedi.FlgEst
            cissac.FacDPedi.codmat = integral.Lg-docmp.codmat 
            cissac.FacDPedi.Factor = f-Factor
            cissac.FacDPedi.CanPed = integral.Lg-docmp.CanPed 
            cissac.FacDPedi.CanAte = integral.Lg-docmp.CanPed       /* OJO */
            cissac.FacDPedi.ImpLin = ROUND( (integral.Lg-docmp.CanPed * integral.Lg-docmp.PreUni) * 
                                            (1 - (integral.Lg-docmp.Dsctos[1] / 100)) *
                                            (1 - (integral.Lg-docmp.Dsctos[2] / 100)) *
                                            (1 - (integral.Lg-docmp.Dsctos[3] / 100)) *
                                            (1 + (INTEGRAL.LG-DOCmp.IgvMat / 100)), 2)
            cissac.FacDPedi.NroItm = I-NITEM 
            cissac.FacDPedi.PreUni = integral.Lg-docmp.PreUni * ( 1 + (INTEGRAL.LG-DOCmp.IgvMat / 100) )
            cissac.FacDPedi.UndVta = integral.Lg-docmp.UndCmp
            cissac.FacDPedi.AftIgv = (IF INTEGRAL.LG-DOCmp.IgvMat > 0 THEN YES ELSE NO)
            cissac.FacDPedi.AftIsc = NO
            cissac.FacDPedi.ImpIgv = cissac.FacDPedi.ImpLin - 
                                    ROUND(cissac.FacDPedi.ImpLin  / (1 + (INTEGRAL.LG-DOCmp.IgvMat / 100)),4)
            cissac.FacDPedi.ImpDto = (integral.Lg-docmp.CanPed * integral.Lg-docmp.PreUni) - 
                                        cissac.FacDPedi.ImpLin
            /*cissac.FacDPedi.ImpIsc = integral.Lg-docmp.ImpIsc */
            cissac.FacDPedi.PreBas = integral.Lg-docmp.PreUni 
            cissac.FacDPedi.Por_DSCTOS[1] = ( 1 - ( (1 - integral.Lg-docmp.Dsctos[1] / 100) *
                                             (1 - integral.Lg-docmp.Dsctos[2] / 100) *
                                             (1 - integral.Lg-docmp.Dsctos[3] / 100) )
                                       ) * 100.
            /*cissac.FacDPedi.CodAux = integral.Lg-docmp.CodAux */
            /*cissac.FacDPedi.Por_Dsctos[1] = integral.Lg-docmp.Dsctos[1]*/
            /*cissac.FacDPedi.Por_Dsctos[2] = integral.Lg-docmp.Dsctos[2]*/
            /*cissac.FacDPedi.Por_Dsctos[3] = integral.Lg-docmp.Dsctos[3]*/
            /*cissac.FacDPedi.PesMat = integral.Lg-docmp.PesMat*/
        IF cissac.FacDPedi.ImpDto <= 0.1 THEN cissac.FacDPedi.ImpDto = 0.
        ASSIGN
            INTEGRAL.LG-DOCmp.CanAten = INTEGRAL.LG-DOCmp.CanPed.
    END.
    ASSIGN 
        cissac.FacCorre.Correlativo = cissac.FacCorre.Correlativo + 1.
    ASSIGN
        cissac.FacCPedi.ImpDto = 0
        cissac.FacCPedi.ImpIgv = 0
        cissac.FacCPedi.ImpIsc = 0
        cissac.FacCPedi.ImpTot = 0
        cissac.FacCPedi.ImpExo = 0
        F-Igv = 0
        F-Isc = 0.
    FOR EACH cissac.FacDPedi OF cissac.FacCPedi NO-LOCK:
        F-Igv = F-Igv + cissac.FacDPedi.ImpIgv.
        F-Isc = F-Isc + cissac.FacDPedi.ImpIsc.
        cissac.FacCPedi.ImpTot = cissac.FacCPedi.ImpTot + cissac.FacDPedi.ImpLin.
        IF NOT cissac.FacDPedi.AftIgv THEN cissac.FacCPedi.ImpExo = cissac.FacCPedi.ImpExo + cissac.FacDPedi.ImpLin.
        IF cissac.FacDPedi.AftIgv = YES
            THEN cissac.FacCPedi.ImpDto = cissac.FacCPedi.ImpDto + ROUND(cissac.FacDPedi.ImpDto / (1 + cissac.FacCPedi.PorIgv / 100), 2).
        ELSE cissac.FacCPedi.ImpDto = cissac.FacCPedi.ImpDto + cissac.FacDPedi.ImpDto.
    END.
    ASSIGN
        cissac.FacCPedi.ImpIgv = ROUND(F-IGV,2)
        cissac.FacCPedi.ImpIsc = ROUND(F-ISC,2)
        cissac.FacCPedi.ImpVta = cissac.FacCPedi.ImpTot - cissac.FacCPedi.ImpExo - cissac.FacCPedi.ImpIgv
        cissac.FacCPedi.ImpBrt = cissac.FacCPedi.ImpVta + cissac.FacCPedi.ImpIsc + cissac.FacCPedi.ImpDto + cissac.FacCPedi.ImpExo.
    x-NroCot = ROWID(cissac.FacCPedi).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Facturas gDialog 
PROCEDURE Genera-Facturas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE C-NROPED       AS CHAR      NO-UNDO.

DEFINE BUFFER BDDOCU FOR cissac.CcbDDocu.

DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND cissac.FacCorre WHERE cissac.FacCorre.CodCia = S-CODCIA 
        AND cissac.FacCorre.CodDoc = S-CODDOC 
        AND cissac.FacCorre.NroSer = COMBO-BOX-NroSerFac EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'Correlativo de' s-coddoc ':' COMBO-BOX-NroSerFac SKIP
            'NO se pudo bloquear' VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN ERROR.
    END.
    FOR EACH T-GUIAS NO-LOCK:
        FIND cissac.FacCPedi WHERE cissac.FacCPedi.CODCIA = S-CODCIA 
            AND cissac.FacCPedi.CODDOC = T-GUIAS.CodPed
            AND cissac.FacCPedi.NROPED = T-GUIAS.NroPed
            NO-LOCK NO-ERROR.
        IF AVAILABLE cissac.FacCPedi THEN C-NROPED = cissac.FacCPedi.NROREF.
        CREATE cissac.CcbCDocu.
        BUFFER-COPY T-GUIAS
            TO cissac.CcbCDocu
            ASSIGN 
            cissac.CcbCDocu.CodCia = S-CODCIA
            cissac.CcbCDocu.CodDiv = S-CODDIV
            cissac.CcbCDocu.CodDoc = S-CODDOC
            cissac.CcbCDocu.NroDoc = STRING(cissac.FacCorre.NroSer,"999") + STRING(cissac.FacCorre.Correlativo,"999999")
            cissac.FacCorre.Correlativo = cissac.FacCorre.Correlativo + 1
            cissac.CcbCDocu.CodAlm = S-CODALM
            cissac.CcbCDocu.CodMov = 02
            cissac.CcbCDocu.FchDoc = TODAY
            cissac.CcbCDocu.FchAte = TODAY
            cissac.CcbCDocu.FlgEst = "P"
            cissac.CcbCDocu.FlgAte = "P"
            cissac.CcbCDocu.CodPed = "PED"
            cissac.CcbCDocu.NroPed = C-NROPED
            cissac.CcbCDocu.CodRef = "G/R"
            cissac.CcbCDocu.NroRef = T-GUIAS.NroDoc
            cissac.CcbCDocu.Tipo   = "OFICINA"
            cissac.CcbCDocu.TipVta = "2"
            cissac.CcbCDocu.TpoFac = "R"
            cissac.CcbCDocu.FlgAte = 'D'
            cissac.CcbCDocu.usuario = S-USER-ID
            cissac.CcbCDocu.TipBon[1] = cissac.FacCPedi.TipBon[1]
            cissac.CcbCDocu.HorCie = STRING(TIME, 'HH:MM').
        FIND cissac.gn-clie WHERE cissac.gn-clie.CodCia = cl-codcia 
            AND cissac.gn-clie.CodCli = cissac.CcbCDocu.CodCli NO-LOCK NO-ERROR.
        IF AVAILABLE cissac.gn-clie THEN DO:
           ASSIGN cissac.CcbCDocu.CodDpto = cissac.gn-clie.CodDept 
                  cissac.CcbCDocu.CodProv = cissac.gn-clie.CodProv 
                  cissac.CcbCDocu.CodDist = cissac.gn-clie.CodDist.
        END.
        /* ACTUALIZAR EL CENTRO DE COSTO 22.07.04 CY */
        FIND cissac.gn-ven WHERE cissac.gn-ven.codcia = s-codcia
           AND cissac.gn-ven.codven = cissac.CcbCDocu.codven
           NO-LOCK NO-ERROR.
        IF AVAILABLE cissac.gn-ven THEN cissac.CcbCDocu.cco = cissac.gn-ven.cco.

        FOR EACH BDDOCU OF T-GUIAS NO-LOCK:
            CREATE cissac.CcbDDocu.
            BUFFER-COPY BDDOCU
                TO cissac.CcbDDocu
                ASSIGN 
                cissac.CcbDDocu.CodCia = cissac.CcbCDocu.CodCia 
                cissac.CcbDDocu.CodDoc = cissac.CcbCDocu.CodDoc 
                cissac.CcbDDocu.NroDoc = cissac.CcbCDocu.NroDoc
                cissac.CcbDDocu.FchDoc = cissac.CcbCDocu.FchDoc
                cissac.CcbDDocu.CodDiv = cissac.CcbCDocu.CodDiv.
        END.
        ASSIGN
            cissac.CcbCDocu.SdoAct  = cissac.CcbCDocu.ImpTot
            cissac.CcbCDocu.Imptot2 = cissac.CcbCDocu.ImpTot.
        /* Control de Facturas */
        /*MESSAGE cissac.ccbcdocu.coddoc cissac.ccbcdocu.nrodoc.*/
        x-NroRf2 = x-NroRf2 + (IF x-NroRf2 = '' THEN '' ELSE ',') + cissac.CcbCDocu.NroDoc.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Guias gDialog 
PROCEDURE Genera-Guias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE iCountItem AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE lCreaHeader AS LOGICAL NO-UNDO.
DEFINE VARIABLE iCountGuide AS INTEGER NO-UNDO.
DEFINE VARIABLE lItemOk AS LOGICAL NO-UNDO.
DEFINE VARIABLE FILL-IN-items AS INTEGER NO-UNDO.

FIND cissac.FacCfgGn WHERE cissac.FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
FILL-IN-items = cissac.FacCfgGn.Items_Guias.

EMPTY TEMP-TABLE T-GUIAS.

trloop:
DO TRANSACTION ON ERROR UNDO trloop, RETURN ERROR ON STOP UNDO trloop, RETURN ERROR:
    FIND cissac.FacCorre WHERE cissac.FacCorre.CodCia = S-CODCIA 
        AND cissac.FacCorre.CodDoc = s-coddoc
        AND cissac.FacCorre.NroSer = COMBO-BOX-NroSerGR
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO trloop, RETURN ERROR.
    FIND cissac.FacCPedi WHERE ROWID(cissac.FacCPedi) = x-NroOD NO-LOCK.

    ASSIGN
        iCountGuide = 0
        lCreaHeader = TRUE
        lItemOk = FALSE.
    FOR EACH cissac.FacDPedi OF cissac.FacCPedi NO-LOCK,
        FIRST cissac.Almmmate WHERE cissac.Almmmate.CodCia = cissac.FacCPedi.CodCia 
        AND cissac.Almmmate.CodAlm = cissac.FacCPedi.CodAlm 
        AND cissac.Almmmate.CodMat = cissac.FacDPedi.CodMat
        BREAK BY cissac.Almmmate.CodUbi BY cissac.FacDPedi.CodMat:
        IF cissac.FacDPedi.CanPed > 0 THEN DO:
            /* Crea Cabecera */
            IF lCreaHeader THEN DO:
                /* Cabecera de Guía */
                CREATE cissac.CcbCDocu.
                ASSIGN
                    cissac.CcbCDocu.CodCia = s-CodCia
                    cissac.CcbCDocu.CodDiv = s-CodDiv
                    cissac.CcbCDocu.CodDoc = s-CodDoc
                    cissac.CcbCDocu.NroDoc = STRING(cissac.FacCorre.NroSer,"999") + STRING(cissac.FacCorre.Correlativo,"999999") 
                    cissac.CcbCDocu.FchDoc = TODAY
                    cissac.CcbCDocu.CodMov = 02     /* Salida por Ventas */
                    cissac.CcbCDocu.CodAlm = s-CodAlm
                    cissac.CcbCDocu.CodPed = cissac.FacCPedi.CodDoc 
                    cissac.CcbCDocu.NroPed = cissac.FacCPedi.NroPed
                    cissac.CcbCDocu.Tipo   = "OFICINA"
                    cissac.CcbCDocu.FchVto = TODAY
                    cissac.CcbCDocu.CodCli = cissac.FacCPedi.CodCli
                    cissac.CcbCDocu.NomCli = cissac.FacCPedi.NomCli
                    cissac.CcbCDocu.RucCli = cissac.FacCPedi.RucCli
                    cissac.CcbCDocu.DirCli = cissac.FacCPedi.DirCli
                    cissac.CcbCDocu.CodVen = cissac.FacCPedi.CodVen
                    cissac.CcbCDocu.TipVta = "2"
                    cissac.CcbCDocu.TpoFac = "R"       /* GUIA VENTA AUTOMATICA */
                    cissac.CcbCDocu.FmaPgo = cissac.FacCPedi.FmaPgo
                    cissac.CcbCDocu.CodMon = cissac.FacCPedi.CodMon
                    cissac.CcbCDocu.TpoCmb = cissac.FacCPedi.TpoCmb
                    cissac.CcbCDocu.PorIgv = cissac.FacCPedi.porIgv
                    cissac.CcbCDocu.NroOrd = cissac.FacCPedi.ordcmp
                    cissac.CcbCDocu.FlgEst = "F"       /* FACTURADO */
                    cissac.CcbCDocu.FlgSit = "P"
                    cissac.CcbCDocu.usuario = S-USER-ID
                    cissac.CcbCDocu.HorCie = STRING(TIME,'hh:mm')
                    cissac.CcbCDocu.FlgEnv = (cissac.FacCPedi.TpoPed = 'M')
                    /*cissac.CcbCDocu.CodAge = FILL-IN-CodAge
                    cissac.CcbCDocu.LugEnt = FILL-IN-LugEnt
                    cissac.CcbCDocu.Glosa = FILL-IN-Glosa*/
                    cissac.FacCorre.Correlativo = cissac.FacCorre.Correlativo + 1
                    iCountGuide = iCountGuide + 1
                    lCreaHeader = FALSE.
                /* ****************************************** */
                FIND cissac.gn-convt WHERE cissac.gn-convt.Codig = cissac.CcbCDocu.FmaPgo NO-LOCK NO-ERROR.
                IF AVAILABLE cissac.gn-convt THEN DO:
                    cissac.CcbCDocu.TipVta = IF cissac.gn-convt.TotDias = 0 THEN "1" ELSE "2".
                    cissac.CcbCDocu.FchVto = cissac.CcbCDocu.FchDoc + INTEGER(ENTRY(NUM-ENTRIES(cissac.gn-convt.Vencmtos),cissac.gn-convt.Vencmtos)).
                END.
                FIND cissac.gn-clie WHERE 
                    cissac.gn-clie.CodCia = cl-codcia AND
                    cissac.gn-clie.CodCli = cissac.CcbCDocu.CodCli 
                    NO-LOCK NO-ERROR.
                IF AVAILABLE cissac.gn-clie  THEN DO:
                    ASSIGN
                        cissac.CcbCDocu.CodDpto = cissac.gn-clie.CodDept 
                        cissac.CcbCDocu.CodProv = cissac.gn-clie.CodProv 
                        cissac.CcbCDocu.CodDist = cissac.gn-clie.CodDist.
                END.
            END.
            /* Crea Detalle */
            CREATE cissac.CcbDDocu.
            BUFFER-COPY cissac.FacDPedi 
                TO cissac.CcbDDocu
                ASSIGN
                cissac.CcbDDocu.CodCia = cissac.CcbCDocu.CodCia
                cissac.CcbDDocu.CodDiv = cissac.CcbCDocu.CodDiv
                cissac.CcbDDocu.Coddoc = cissac.CcbCDocu.Coddoc
                cissac.CcbDDocu.NroDoc = cissac.CcbCDocu.NroDoc 
                cissac.CcbDDocu.FchDoc = cissac.CcbCDocu.FchDoc
                cissac.CcbDDocu.AlmDes = cissac.CcbCDocu.CodAlm    /* OJO */
                cissac.CcbDDocu.CanDes = cissac.FacDPedi.CanPed.
            lItemOk = TRUE.
        END.
        iCountItem = iCountItem + 1.
        IF (iCountItem > FILL-IN-items OR LAST(cissac.FacDPedi.CodMat)) AND lItemOk THEN DO:
            RUN proc_GrabaTotales.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN ERROR.
            /* Descarga de Almacen */
            /* Para no perder la variable s-codalm */
            RUN act_alm (ROWID(cissac.CcbCDocu)).
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN ERROR.
            /* Control de Guias de Remision */
            x-NroRf3 = x-NroRf3 + (IF x-NroRf3 = '' THEN '' ELSE ',') + cissac.CcbCDocu.NroDoc.
        END.
        IF iCountItem > FILL-IN-items THEN DO:
            iCountItem = 1.
            lCreaHeader = TRUE.
            lItemOk = FALSE.
        END.
    END. /* FOR EACH cissac.FacDPedi... */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Ingreso-Almacen gDialog 
PROCEDURE Genera-Ingreso-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* UN INGRESO POR CADA GUIA DE REMISION */
DEF VAR k AS INT NO-UNDO.
DEF VAR F-PesUnd AS DECIMAL NO-UNDO.

s-CodAlm = FILL-IN-AlmIng.

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND integral.Almacen WHERE integral.Almacen.CodCia = S-CODCIA 
        AND integral.Almacen.CodAlm = s-CodAlm EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.        
    FIND integral.gn-prov WHERE integral.gn-prov.CodCia = pv-codcia 
        AND integral.gn-prov.Codpro = integral.Lg-cocmp.codpro
        NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.        
    FIND LAST integral.gn-tcmb NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.        

    DO k = 1 TO NUM-ENTRIES(x-NroRf3):
        CREATE integral.Almcmov.
        ASSIGN 
            integral.Almcmov.CodCia  = s-CodCia 
            integral.Almcmov.CodAlm  = s-CodAlm 
            integral.Almcmov.TipMov  = "I"
            integral.Almcmov.CodMov  = 02
            integral.Almcmov.NroSer  = 000
            integral.Almcmov.NroDoc = integral.Almacen.CorrIng
            integral.Almacen.CorrIng = integral.Almacen.CorrIng + 1
            integral.Almcmov.HorRcp  = STRING(TIME,"HH:MM:SS")
            integral.Almcmov.CodPro  = integral.Lg-cocmp.codpro
            integral.Almcmov.NomRef  = integral.gn-prov.nompro
            integral.Almcmov.CodMon  = integral.Lg-cocmp.codmon
            integral.Almcmov.TpoCmb  = integral.gn-tcmb.venta
            integral.Almcmov.NroRf1  = STRING(integral.LG-COCmp.NroDoc, '999999')
            integral.Almcmov.NroRf2  = ENTRY(k, x-NroRf2)
            integral.Almcmov.NroRf3  = ENTRY(k, x-NroRf3)
            integral.Almcmov.Observ  = integral.Lg-cocmp.Observaciones
            integral.Almcmov.ModAdq  = integral.Lg-cocmp.ModAdq.
        ASSIGN 
            integral.Almcmov.usuario = S-USER-ID
            integral.Almcmov.ImpIgv  = 0
            integral.Almcmov.ImpMn1  = 0
            integral.Almcmov.ImpMn2  = 0.

        FOR EACH integral.Lg-docmp OF integral.Lg-cocmp,
            FIRST cissac.Ccbddocu WHERE cissac.Ccbddocu.codcia = s-codcia
            AND cissac.Ccbddocu.coddoc = "G/R"
            AND cissac.Ccbddocu.nrodoc = integral.Almcmov.NroRf3
            AND cissac.Ccbddocu.codmat = integral.Lg-docmp.codmat:
            CREATE integral.Almdmov.
            ASSIGN
                integral.Almdmov.CodCia = S-CODCIA
                integral.Almdmov.CodAlm = S-CODALM
                integral.Almdmov.TipMov = integral.Almcmov.TipMov 
                integral.Almdmov.CodMov = integral.Almcmov.CodMov 
                integral.Almdmov.NroSer = integral.Almcmov.NroSer 
                integral.Almdmov.NroDoc = integral.Almcmov.NroDoc 
                integral.Almdmov.CodMon = integral.Almcmov.CodMon 
                integral.Almdmov.FchDoc = integral.Almcmov.FchDoc 
                integral.Almdmov.TpoCmb = integral.Almcmov.TpoCmb
                integral.Almdmov.Codmat = integral.LG-DOCmp.Codmat 
                integral.Almdmov.CodUnd = integral.LG-DOCmp.UndCmp
                integral.Almdmov.CanDes = integral.LG-DOCmp.CanPedi
                integral.Almdmov.CanDev = integral.LG-DOCmp.CanPedi
                integral.Almdmov.PreLis = integral.LG-DOCmp.PreUni
                integral.Almdmov.Dsctos[1] = integral.LG-DOCmp.Dsctos[1]
                integral.Almdmov.Dsctos[2] = integral.LG-DOCmp.Dsctos[2]
                integral.Almdmov.Dsctos[3] = integral.LG-DOCmp.Dsctos[3]
                integral.Almdmov.IgvMat = integral.LG-DOCmp.IgvMat
                integral.Almdmov.PreUni = ROUND(integral.LG-DOCmp.PreUni * (1 - (integral.LG-DOCmp.Dsctos[1] / 100)) * 
                                                (1 - (integral.LG-DOCmp.Dsctos[2] / 100)) * 
                                                (1 - (integral.LG-DOCmp.Dsctos[3] / 100)),4)
                integral.Almdmov.ImpCto = ROUND(integral.Almdmov.CanDes * integral.Almdmov.PreUni,2)
                integral.Almdmov.CodAjt = 'A'
                integral.Almdmov.HraDoc = integral.Almcmov.HorRcp.
            FIND integral.Almmmatg WHERE integral.Almmmatg.CodCia = S-CODCIA 
                AND integral.Almmmatg.codmat = integral.Almdmov.codmat  
                NO-LOCK NO-ERROR.
            FIND integral.Almtconv WHERE integral.Almtconv.CodUnid = integral.Almmmatg.UndBas 
                AND integral.Almtconv.Codalter = integral.Almdmov.CodUnd 
                NO-LOCK NO-ERROR.
            integral.Almdmov.Factor = integral.Almtconv.Equival / integral.Almmmatg.FacEqu.
            IF NOT integral.Almmmatg.AftIgv THEN integral.Almdmov.IgvMat = 0.
            IF integral.Almcmov.codmon = 1 
                THEN integral.Almcmov.ImpMn1 = integral.Almcmov.ImpMn1 + integral.Almdmov.ImpMn1.
            ELSE integral.Almcmov.ImpMn2 = integral.Almcmov.ImpMn2 + integral.Almdmov.ImpMn2.
            /* *** */
            RUN ALMACSTK (ROWID(integral.Almdmov)).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                MESSAGE 'Problemas al actualizar el código' integral.Almdmov.codmat
                    VIEW-AS ALERT-BOX ERROR.
                UNDO trloop, RETURN 'ADM-ERROR'.
            END.
            RUN ALMACPR1-ING (ROWID(integral.Almdmov), "U").
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                MESSAGE 'Problemas al actualizar el código' integral.Almdmov.codmat
                    VIEW-AS ALERT-BOX ERROR.
                UNDO trloop, RETURN 'ADM-ERROR'.
            END.
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Orden gDialog 
PROCEDURE Genera-Orden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND cissac.FacCorre WHERE cissac.FacCorre.CodCia = S-CODCIA 
        AND cissac.FacCorre.CodDoc = s-coddoc
        AND cissac.FacCorre.NroSer = COMBO-BOX-NroSerOD
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
    FIND CPED WHERE ROWID(CPED) = x-NroPed NO-LOCK.
    CREATE cissac.FacCPedi.
    BUFFER-COPY CPED
        TO cissac.FacCPedi
        ASSIGN 
        cissac.FacCPedi.CodDoc = s-coddoc 
        cissac.FacCPedi.NroPed = STRING(cissac.FacCorre.NroSer,"999") + STRING(cissac.FacCorre.Correlativo,"999999")
        cissac.FacCPedi.FlgEst = "C"    /* CERRADA */
        cissac.FacCPedi.TpoPed = ""
        cissac.FacCPedi.TpoLic = YES
        cissac.FaccPedi.CodRef = CPED.CodDoc
        cissac.FaccPedi.NroRef = CPED.NroPed
        cissac.FacCPedi.Tipvta = "CON IGV".
    /* REFERENCIA EN CASO DE EXTORNAR MOVIMIENTOS */
    ASSIGN
        cissac.FacCPedi.ordcmp = STRING(integral.Lg-cocmp.nrodoc, "9999999").
    /* ****************************************** */
    FOR EACH DPED OF CPED NO-LOCK:
        CREATE cissac.FacDPedi.
        BUFFER-COPY DPED
            TO cissac.FacDPedi
            ASSIGN 
            cissac.FacDPedi.CodCia = cissac.FacCPedi.CodCia
            cissac.FacDPedi.CodDiv = cissac.FacCPedi.CodDiv
            cissac.FacDPedi.coddoc = cissac.FacCPedi.coddoc
            cissac.FacDPedi.NroPed = cissac.FacCPedi.NroPed
            cissac.FacDPedi.FchPed = cissac.FacCPedi.FchPed
            cissac.FacDPedi.Hora   = cissac.FacCPedi.Hora 
            cissac.FacDPedi.FlgEst = cissac.FacCPedi.FlgEst.
        ASSIGN
            cissac.FacDPedi.CanAte  = cissac.FacDPedi.CanPed    /* OJO */
            cissac.FacDPedi.CanPick = cissac.FacDPedi.CanPed.
    END.
    ASSIGN 
        cissac.FacCorre.Correlativo = cissac.FacCorre.Correlativo + 1.
    x-NroOD = ROWID(cissac.FacCPedi).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido gDialog 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN ERROR ON STOP UNDO, RETURN ERROR:
    FIND cissac.FacCorre WHERE cissac.FacCorre.CodCia = S-CODCIA 
        AND cissac.FacCorre.CodDoc = s-coddoc
        AND cissac.FacCorre.NroSer = COMBO-BOX-NroSerPed
        EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.
    FIND CCOT WHERE ROWID(CCOT) = x-NroCot NO-LOCK.
    CREATE cissac.FacCPedi.
    BUFFER-COPY CCOT
        TO cissac.FacCPedi
        ASSIGN 
        cissac.FacCPedi.CodDoc = s-coddoc 
        cissac.FacCPedi.NroPed = STRING(cissac.FacCorre.NroSer,"999") + STRING(cissac.FacCorre.Correlativo,"999999")
        cissac.FacCPedi.FlgEst = "C"    /* Cerrada */
        cissac.FacCPedi.TpoPed = ""
        cissac.FaccPedi.CodRef = CCOT.CodDoc
        cissac.FaccPedi.NroRef = CCOT.NroPed.
    /* REFERENCIA EN CASO DE EXTORNAR MOVIMIENTOS */
    ASSIGN
        cissac.FacCPedi.ordcmp = STRING(integral.Lg-cocmp.nrodoc, "9999999").
    /* ****************************************** */
    FOR EACH DCOT OF CCOT NO-LOCK:
        CREATE cissac.FacDPedi.
        BUFFER-COPY DCOT
            TO cissac.FacDPedi
            ASSIGN 
            cissac.FacDPedi.CodCia = cissac.FacCPedi.CodCia
            cissac.FacDPedi.CodDiv = cissac.FacCPedi.CodDiv
            cissac.FacDPedi.coddoc = cissac.FacCPedi.coddoc
            cissac.FacDPedi.NroPed = cissac.FacCPedi.NroPed
            cissac.FacDPedi.FlgEst = cissac.FacCPedi.FlgEst.
        ASSIGN
            cissac.FacDPedi.CanAte = cissac.FacDPedi.CanPed.    /* OJO */
    END.
    ASSIGN 
        cissac.FacCorre.Correlativo = cissac.FacCorre.Correlativo + 1.
    x-NroPed = ROWID(cissac.FacCPedi).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Venta-Cissac-Conti gDialog 
PROCEDURE Genera-Venta-Cissac-Conti :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DISABLE TRIGGERS FOR LOAD OF cissac.ccbcdocu.
DISABLE TRIGGERS FOR LOAD OF cissac.ccbddocu.
DISABLE TRIGGERS FOR LOAD OF cissac.almacen.
DISABLE TRIGGERS FOR LOAD OF cissac.almcmov.
DISABLE TRIGGERS FOR LOAD OF cissac.almdmov.
DISABLE TRIGGERS FOR LOAD OF integral.almacen.
DISABLE TRIGGERS FOR LOAD OF integral.almcmov.
DISABLE TRIGGERS FOR LOAD OF integral.almdmov.
DISABLE TRIGGERS FOR LOAD OF cissac.faccpedi.
DISABLE TRIGGERS FOR LOAD OF cissac.facdpedi.
DISABLE TRIGGERS FOR LOAD OF cissac.almmmatg.
DISABLE TRIGGERS FOR LOAD OF cissac.almmmate.
DISABLE TRIGGERS FOR LOAD OF integral.almmmatg.
DISABLE TRIGGERS FOR LOAD OF integral.almmmate.
DISABLE TRIGGERS FOR LOAD OF cissac.faccorre.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    ASSIGN
        OK-1:VISIBLE IN FRAME {&FRAME-NAME} = YES
        OK-2:VISIBLE IN FRAME {&FRAME-NAME} = YES
        OK-3:VISIBLE IN FRAME {&FRAME-NAME} = YES
        OK-4:VISIBLE IN FRAME {&FRAME-NAME} = YES
        OK-5:VISIBLE IN FRAME {&FRAME-NAME} = YES
        OK-6:VISIBLE IN FRAME {&FRAME-NAME} = YES.

    FIND integral.Lg-cocmp WHERE ROWID(integral.Lg-cocmp) = pRowid EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se pudo bloquear la Orden de Compra'
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        integral.Lg-cocmp.flgsit = "T".
    FIND cissac.gn-clie WHERE cissac.gn-clie.CodCia = cl-codcia 
        AND cissac.gn-clie.CodCli = "20100038146"   /* Continental SAC */
        NO-LOCK NO-ERROR.
    /* 1ro. Generación de Cotización */
    OK-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Procesando...".
    s-coddoc = "COT".
    RUN Genera-Cotizacion NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se pudo generar la cotización' VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    OK-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "OK".
    /* 2do. Generación de Pedido */
    OK-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Procesando...".
    s-coddoc = "PED".
    RUN Genera-Pedido NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se pudo generar el pedido' VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    OK-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "OK".
    /* 3ro. Generación Orden de Despacho */
    OK-3:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Procesando...".
    s-coddoc = "O/D".
    RUN Genera-Orden NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se pudo generar la orden de despacho' VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    OK-3:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "OK".
    /* 4to. Generación Guias */
    OK-4:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Procesando...".
    s-coddoc = "G/R".
    RUN Genera-Guias NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se pudo generar la guia de remisión' VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    OK-4:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "OK".
    /* 5to. Generación Facturas */
    OK-5:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Procesando...".
    s-coddoc = "FAC".
    RUN Genera-Facturas NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se pudo generar la factura' VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    OK-5:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "OK".
    /* 6to. Ingreso al Almacén */
    OK-6:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Procesando...".
    RUN Genera-Ingreso-Almacen NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'NO se pudo generar el ingreso al almacén' VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    OK-6:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "OK".

    /* Cierre */
    IF AVAILABLE(cissac.FacCorre) THEN RELEASE cissac.FacCorre.
    IF AVAILABLE(cissac.FacCPedi) THEN RELEASE cissac.Faccpedi.
    IF AVAILABLE(cissac.FacDPedi) THEN RELEASE cissac.Facdpedi.
    IF AVAILABLE(cissac.Almacen)  THEN RELEASE cissac.Almacen.
    IF AVAILABLE(cissac.Almcmov) THEN RELEASE cissac.Almcmov.
    IF AVAILABLE(cissac.Almdmov) THEN RELEASE cissac.Almdmov.
    IF AVAILABLE(integral.Almacen)  THEN RELEASE integral.Almacen.
    IF AVAILABLE(integral.Almcmov) THEN RELEASE integral.Almcmov.
    IF AVAILABLE(integral.Almdmov) THEN RELEASE integral.Almdmov.
END.
MESSAGE 'Proceso concluido con éxito' VIEW-AS ALERT-BOX INFORMATION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Inicializa-Parametros gDialog 
PROCEDURE Inicializa-Parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cListItems AS CHARACTER NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN
           FILL-IN-CodAlm = INTEGRAL.LG-COCmp.CodAlm.
      FIND cissac.Almacen WHERE cissac.Almacen.codcia = s-codcia
          AND cissac.Almacen.codalm = FILL-IN-CodAlm
          NO-LOCK NO-ERROR.
      ASSIGN
          s-codalm = cissac.Almacen.codalm
          s-coddiv = cissac.Almacen.coddiv.
      /* COTIZACIONES */
      cListItems = "".
      FOR EACH cissac.FacCorre NO-LOCK WHERE cissac.FacCorre.CodCia = s-CodCia 
          AND cissac.FacCorre.CodDoc = "COT" 
          AND cissac.FacCorre.CodDiv = cissac.Almacen.coddiv
          AND cissac.FacCorre.flgest = YES:
          IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
          ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
      END.
      COMBO-BOX-NroSerCot:LIST-ITEMS = cListItems.
      COMBO-BOX-NroSerCot = INTEGER(ENTRY(1,COMBO-BOX-NroSerCot:LIST-ITEMS)).
      /* PEDIDOS */
      cListItems = "".
      FOR EACH cissac.FacCorre NO-LOCK WHERE cissac.FacCorre.CodCia = s-CodCia 
          AND cissac.FacCorre.CodDoc = "PED" 
          AND cissac.FacCorre.CodDiv = cissac.Almacen.coddiv
          AND cissac.FacCorre.flgest = YES:
          IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
          ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
      END.
      COMBO-BOX-NroSerPed:LIST-ITEMS = cListItems.
      COMBO-BOX-NroSerPed = INTEGER(ENTRY(1,COMBO-BOX-NroSerPed:LIST-ITEMS)).
      /* O/D */
      cListItems = "".
      FOR EACH cissac.FacCorre NO-LOCK WHERE cissac.FacCorre.CodCia = s-CodCia 
          AND cissac.FacCorre.CodDoc = "O/D" 
          AND cissac.FacCorre.CodDiv = cissac.Almacen.coddiv
          AND cissac.FacCorre.flgest = YES:
          IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
          ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
      END.
      COMBO-BOX-NroSerOD:LIST-ITEMS = cListItems.
      COMBO-BOX-NroSerOD = INTEGER(ENTRY(1,COMBO-BOX-NroSerOD:LIST-ITEMS)).
      /* G/R */
      cListItems = "".
      FOR EACH cissac.FacCorre NO-LOCK WHERE cissac.FacCorre.CodCia = s-CodCia 
          AND cissac.FacCorre.CodDoc = "G/R" 
          AND cissac.FacCorre.CodDiv = cissac.Almacen.coddiv
          AND cissac.FacCorre.flgest = YES:
          IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
          ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
      END.
      COMBO-BOX-NroSerGR:LIST-ITEMS = cListItems.
      COMBO-BOX-NroSerGR = INTEGER(ENTRY(1,COMBO-BOX-NroSerGR:LIST-ITEMS)).
      /* FAC */
      cListItems = "".
      FOR EACH cissac.FacCorre NO-LOCK WHERE cissac.FacCorre.CodCia = s-CodCia 
          AND cissac.FacCorre.CodDoc = "FAC" 
          AND cissac.FacCorre.CodDiv = cissac.Almacen.coddiv
          AND cissac.FacCorre.flgest = YES:
          IF cListItems = "" THEN cListItems = STRING(FacCorre.NroSer,"999").
          ELSE cListItems = cListItems + "," + STRING(FacCorre.NroSer,"999").
      END.
      COMBO-BOX-NroSerFac:LIST-ITEMS = cListItems.
      COMBO-BOX-NroSerFac = INTEGER(ENTRY(1,COMBO-BOX-NroSerFac:LIST-ITEMS)).
      /* RHC 29/10/2013 FIJAMOS LAS SERIES */
      CASE cissac.Almacen.CodDiv:
          WHEN "00000" THEN ASSIGN
              COMBO-BOX-NroSerGR  = 002
              COMBO-BOX-NroSerFAC = 002.
          WHEN "00021" THEN ASSIGN
              COMBO-BOX-NroSerGR  = 110
              COMBO-BOX-NroSerFAC = 110.
      END CASE.
      /* REPINTAR CORRELATIVOS */
/*       APPLY "VALUE-CHANGED" TO COMBO-BOX-NroSerCot. */
/*       APPLY "VALUE-CHANGED" TO COMBO-BOX-NroSerPed. */
/*       APPLY "VALUE-CHANGED" TO COMBO-BOX-NroSerOD.  */
/*       APPLY "VALUE-CHANGED" TO COMBO-BOX-NroSerGR.  */
/*       APPLY "VALUE-CHANGED" TO COMBO-BOX-NroSerFAC. */
      /* ALMACEN INGRESO */
      FILL-IN-AlmIng = INTEGRAL.LG-COCmp.CodAlm.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Inicializa-Parametros.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
      APPLY "VALUE-CHANGED" TO COMBO-BOX-NroSerCot.
      APPLY "VALUE-CHANGED" TO COMBO-BOX-NroSerPed.
      APPLY "VALUE-CHANGED" TO COMBO-BOX-NroSerOD.
      APPLY "VALUE-CHANGED" TO COMBO-BOX-NroSerGR.
      APPLY "VALUE-CHANGED" TO COMBO-BOX-NroSerFAC.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_GrabaTotales gDialog 
PROCEDURE proc_GrabaTotales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dIGV AS DECIMAL NO-UNDO.
    DEFINE VARIABLE dISC AS DECIMAL NO-UNDO.

    DEFINE BUFFER b-CDocu FOR cissac.CcbCDocu.
    DEFINE BUFFER b-DDocu FOR cissac.CcbDDocu.

    DO ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN 'ADM-ERROR':
        FIND b-CDocu WHERE ROWID(b-CDocu) = ROWID(cissac.CcbCDocu) EXCLUSIVE-LOCK NO-ERROR.
        b-CDocu.ImpDto = 0.
        b-CDocu.ImpIgv = 0.
        b-CDocu.ImpIsc = 0.
        b-CDocu.ImpTot = 0.
        b-CDocu.ImpExo = 0.
        FOR EACH b-DDocu OF b-CDocu NO-LOCK:
            dIGV = dIGV + b-DDocu.ImpIgv.
            dISC = dISC + b-DDocu.ImpIsc.
            b-CDocu.ImpTot = b-CDocu.ImpTot + b-DDocu.ImpLin.
            IF NOT b-DDocu.AftIgv THEN b-CDocu.ImpExo = b-CDocu.ImpExo + b-DDocu.ImpLin.
            IF b-DDocu.AftIgv THEN
                b-CDocu.ImpDto = b-CDocu.ImpDto +
                    ROUND(b-DDocu.ImpDto / (1 + b-CDocu.PorIgv / 100),2).
            ELSE b-CDocu.ImpDto = b-CDocu.ImpDto + b-DDocu.ImpDto.
        END.
        b-CDocu.ImpIgv = ROUND(dIGV,2).
        b-CDocu.ImpIsc = ROUND(dISC,2).
        b-CDocu.ImpVta = b-CDocu.ImpTot - b-CDocu.ImpExo - b-CDocu.ImpIgv.
        IF b-CDocu.PorDto > 0 THEN DO:
            b-CDocu.ImpDto = b-CDocu.ImpDto +
                ROUND((b-CDocu.ImpVta + b-CDocu.ImpExo) * b-CDocu.PorDto / 100,2).
            b-CDocu.ImpTot = ROUND(b-CDocu.ImpTot * (1 - b-CDocu.PorDto / 100),2).
            b-CDocu.ImpVta = ROUND(b-CDocu.ImpVta * (1 - b-CDocu.PorDto / 100),2).
            b-CDocu.ImpExo = ROUND(b-CDocu.ImpExo * (1 - b-CDocu.PorDto / 100),2).
            b-CDocu.ImpIgv = b-CDocu.ImpTot - b-CDocu.ImpExo - b-CDocu.ImpVta.
        END.
        b-CDocu.ImpBrt = b-CDocu.ImpVta + b-CDocu.ImpIsc + b-CDocu.ImpDto + b-CDocu.ImpExo.
        b-CDocu.SdoAct = b-CDocu.ImpTot.
        CREATE T-GUIAS.
        BUFFER-COPY b-CDocu TO T-GUIAS.
        /*MESSAGE t-guias.coddoc t-guias.nrodoc.*/
        RELEASE b-CDocu.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

