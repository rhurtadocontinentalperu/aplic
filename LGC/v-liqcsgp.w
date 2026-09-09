&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
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

DEFINE SHARED VAR lh_Handle AS HANDLE.
DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VARIABLE PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODALM AS CHAR.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-TIPO    AS CHAR.
DEFINE SHARED VAR S-NROSER  AS INTEGER.
DEFINE SHARED VAR S-CODMON  AS INTEGER .

DEFINE        VAR I-CODMON AS INTEGER NO-UNDO.
DEFINE        VAR R-ROWID  AS ROWID   NO-UNDO.
DEFINE        VAR L-CREA   AS LOGICAL NO-UNDO.
DEFINE        VAR F-ESTADO AS CHAR NO-UNDO.
DEFINE VAR DESDEF AS DATE.
DEFINE VAR HASTAF AS DATE.
DEFINE VAR X-INGMOV AS CHAR.
DEFINE VAR X-DEVMOV AS CHAR.



DEFINE BUFFER CMOV  FOR Almcmov.
DEFINE BUFFER CLIQ  FOR lg-liqcsg.
DEFINE SHARED TEMP-TABLE ITEM2 LIKE Lg-liqcsgd.
DEFINE VAR I AS INTEGER.
DEFINE VAR II AS INTEGER .
DEFINE VAR x-codmov as char .
DEFINE VAR x-tipmov as char INIT "I,S".
DEFINE VAR X-FACTOR AS INTEGER .
DEFINE VAR X-STOCK  AS DECI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES lg-liqcsg
&Scoped-define FIRST-EXTERNAL-TABLE lg-liqcsg


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR lg-liqcsg.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS lg-liqcsg.CodPro lg-liqcsg.Observ ~
lg-liqcsg.FchFin lg-liqcsg.CodMon lg-liqcsg.FlgSit 
&Scoped-define ENABLED-TABLES lg-liqcsg
&Scoped-define FIRST-ENABLED-TABLE lg-liqcsg
&Scoped-Define DISPLAYED-FIELDS lg-liqcsg.CodPro lg-liqcsg.FchDoc ~
lg-liqcsg.Observ lg-liqcsg.FchIni lg-liqcsg.NroRf2 lg-liqcsg.FchFin ~
lg-liqcsg.CodMon lg-liqcsg.FlgSit lg-liqcsg.NroRf1 
&Scoped-define DISPLAYED-TABLES lg-liqcsg
&Scoped-define FIRST-DISPLAYED-TABLE lg-liqcsg
&Scoped-Define DISPLAYED-OBJECTS F-Desliq FILL-IN_NroDoc F-STATUS ~
FILL-IN-NomPro 

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
DEFINE VARIABLE F-Desliq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.57 BY .69
     BGCOLOR 15 FGCOLOR 9  NO-UNDO.

DEFINE VARIABLE F-STATUS AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14.29 BY .69
     FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.57 BY .69 NO-UNDO.

DEFINE VARIABLE FILL-IN_NroDoc AS CHARACTER FORMAT "XXX-XXXXXX" 
     LABEL "No. documento" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .69
     FONT 0.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-Desliq AT ROW 1.19 COL 33 COLON-ALIGNED NO-LABEL
     FILL-IN_NroDoc AT ROW 1.23 COL 12.72 COLON-ALIGNED
     F-STATUS AT ROW 1.23 COL 71.57 COLON-ALIGNED NO-LABEL
     lg-liqcsg.CodPro AT ROW 1.96 COL 12.72 COLON-ALIGNED
          LABEL "Proveedor" FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     FILL-IN-NomPro AT ROW 1.96 COL 24.14 COLON-ALIGNED NO-LABEL
     lg-liqcsg.FchDoc AT ROW 2 COL 75 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
     lg-liqcsg.Observ AT ROW 2.69 COL 12.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 45.86 BY .69
     lg-liqcsg.FchIni AT ROW 2.73 COL 75.14 COLON-ALIGNED
          LABEL "Del"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
     lg-liqcsg.NroRf2 AT ROW 3.46 COL 5.29
          LABEL "Ingresos Alm" FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 46 BY .69
     lg-liqcsg.FchFin AT ROW 3.5 COL 75.14 COLON-ALIGNED
          LABEL "A"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
     lg-liqcsg.CodMon AT ROW 4.31 COL 73.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "S/.", 1,
"US$", 2
          SIZE 14.72 BY .69
     lg-liqcsg.FlgSit AT ROW 4.35 COL 53.43 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Parcial", "P":U,
"Total", "T":U
          SIZE 18.29 BY .69
     lg-liqcsg.NroRf1 AT ROW 4.38 COL 4.58
          LABEL "Devoluciones" FORMAT "x(256)"
          VIEW-AS FILL-IN 
          SIZE 37.14 BY .69
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.lg-liqcsg
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 4.19
         WIDTH              = 88.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN lg-liqcsg.CodPro IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN F-Desliq IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-STATUS IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lg-liqcsg.FchDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lg-liqcsg.FchFin IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN lg-liqcsg.FchIni IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_NroDoc IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lg-liqcsg.NroRf1 IN FRAME F-Main
   NO-ENABLE ALIGN-L EXP-LABEL EXP-FORMAT                               */
/* SETTINGS FOR FILL-IN lg-liqcsg.NroRf2 IN FRAME F-Main
   NO-ENABLE ALIGN-L EXP-LABEL EXP-FORMAT                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME lg-liqcsg.CodMon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lg-liqcsg.CodMon V-table-Win
ON VALUE-CHANGED OF lg-liqcsg.CodMon IN FRAME F-Main /* Cod!mon */
DO:
  S-CODMON = INTEGER(Lg-Liqcsg.CodMon:SCREEN-VALUE).
/*  RUN Procesa-Handle IN lh_Handle ('Recalculo').*/
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lg-liqcsg.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lg-liqcsg.CodPro V-table-Win
ON LEAVE OF lg-liqcsg.CodPro IN FRAME F-Main /* Proveedor */
DO:
  DO WITH FRAME {&FRAME-NAME}:
     IF SELF:SCREEN-VALUE = "" THEN RETURN NO-APPLY.
     
     FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA AND 
                        gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-prov THEN 
        FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA AND 
             gn-prov.CodPro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN 
        DISPLAY gn-prov.NomPro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}.
     ELSE DO:
         MESSAGE "Codigo de Proveedor No existe..."
                 VIEW-AS ALERT-BOX ERROR.
                 RETURN NO-APPLY.
     
     END.

    FIND LAST Lg-cfgliqp WHERE Lg-cfgliqp.Codcia = S-CODCIA AND
                               Lg-cfgliqp.Tpoliq = S-NROSER AND
                               Lg-cfgliqp.CodPro = lg-liqcsg.CodPro:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                               NO-LOCK NO-ERROR.
    
    IF NOT AVAILABLE Lg-cfgliqp THEN DO:
       MESSAGE "Proveedor No Configurado para Consignaciones.."
               VIEW-AS ALERT-BOX ERROR.
               RETURN NO-APPLY.

    END.

    IF AVAILABLE Lg-Cfgliqp THEN DO:
       DESDEF = Lg-cfgliqp.FchIni.
       HASTAF = TODAY.
    END.   
    
    DISPLAY DESDEF @ Lg-Liqcsg.FchIni
            HASTAF @ Lg-Liqcsg.FchFin.

    IF HASTAF > Lg-cfgliqp.FchFin THEN DO:
        MESSAGE "Fecha de Liquidacion excede el Periodo Asignado " SKIP
                "Fecha Inicio : " + STRING(Lg-cfgliqp.FchIni,"99/99/9999") SKIP
                "Fecha Fin    : " + STRING(Lg-cfgliqp.FchFin,"99/99/9999") SKIP
                "No se puede realizar Liquidacion "
        VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
  END.
    
            
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lg-liqcsg.FchFin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lg-liqcsg.FchFin V-table-Win
ON LEAVE OF lg-liqcsg.FchFin IN FRAME F-Main /* A */
DO:
 DO WITH FRAME {&FRAME-NAME}:
   ASSIGN 
   HASTAF = DATE(SELF:SCREEN-VALUE).
/*   IF HASTAF >= TODAY THEN DO:
 *       MESSAGE "Fecha de Corte debe de ser menor al dia actual..."
 *               VIEW-AS ALERT-BOX ERROR.
 *               RETURN NO-APPLY.
 * 
 *    END.*/
   
 END.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lg-liqcsg.FlgSit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lg-liqcsg.FlgSit V-table-Win
ON VALUE-CHANGED OF lg-liqcsg.FlgSit IN FRAME F-Main /* Sit.Transf. */
DO:
 DO WITH FRAME {&FRAME-NAME}:
  CASE SELF:SCREEN-VALUE:
       WHEN "P" THEN DO:
          Lg-liqcsg.FchFin:SENSITIVE = YES.
          S-TIPO = "P".   
       END.
       WHEN "T" THEN DO:
          HASTAF = TODAY.

          DISPLAY HASTAF @ Lg-liqcsg.FchFin.
          
          Lg-liqcsg.FchFin:SENSITIVE = NO.
          
          S-TIPO = "T".
          
       END.
       
  END.
 END.  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Detalle-Ingreso V-table-Win 
PROCEDURE Actualiza-Detalle-Ingreso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
  DEFINE INPUT PARAMETER I-Factor AS INTEGER.
  FOR EACH lg-liqcsgd OF lg-liqcsg NO-LOCK 
      ON ERROR UNDO, RETURN "ADM-ERROR":
      FIND Almdmov WHERE 
           Almdmov.CodCia = lg-liqcsgd.CodCia AND
           Almdmov.CodAlm = lg-liqcsgd.codAlm AND
           Almdmov.TipMov = "I" AND
           Almdmov.Codmov = lg-liqcsgd.Codmov AND
           Almdmov.NroDoc = INTEGER(SUBSTR(lg-liqcsg.Nrorf2,4,6)) AND
           Almdmov.CodMat = lg-liqcsgd.CodMat
           EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE Almdmov THEN 
         Almdmov.CanDev = Almdmov.Candev + (lg-liqcsgd.Candes * I-Factor).
      RELEASE Almdmov.
  END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-item V-table-Win 
PROCEDURE Actualiza-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH ITEM2:
    DELETE ITEM2.
END.
IF NOT L-CREA THEN DO:

   FOR EACH lg-liqcsgd OF lg-liqcsg NO-LOCK :
       CREATE ITEM2.
       ASSIGN ITEM2.CodCia    = lg-liqcsgd.CodCia 
              ITEM2.codmat    = lg-liqcsgd.codmat 
              ITEM2.PreUni    = lg-liqcsgd.PreUni 
              ITEM2.CanDes    = lg-liqcsgd.CanDes 
              ITEM2.CanLiq    = lg-liqcsgd.CanLiq 
              ITEM2.CanIng    = lg-liqcsgd.CanIng 
              ITEM2.CanVen    = lg-liqcsgd.CanVen 
              ITEM2.CanDev    = lg-liqcsgd.CanDev 
              ITEM2.Factor    = lg-liqcsgd.Factor 
              ITEM2.CodUnd    = lg-liqcsgd.CodUnd 
              ITEM2.ImpCto    = lg-liqcsgd.ImpCto 
              ITEM2.PreLis    = lg-liqcsgd.PreLis 
              ITEM2.Dsctos[1] = lg-liqcsgd.Dsctos[1] 
              ITEM2.Dsctos[2] = lg-liqcsgd.Dsctos[2] 
              ITEM2.Dsctos[3] = lg-liqcsgd.Dsctos[3] 
              ITEM2.IgvMat    = lg-liqcsgd.IgvMat.
   END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "lg-liqcsg"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "lg-liqcsg"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Asigna-Consignacion V-table-Win 
PROCEDURE Asigna-Consignacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.

input-var-1 = lg-cfgliq.codAlm.
input-var-2 = "I".
input-var-3 = string(lg-cfgliq.CodMov).

RUN LKUP\C-MOVCSG("Ingresos x Consignacion").

IF output-var-1 = ? THEN RETURN.

OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH ITEM2:
    DELETE ITEM2.
END.

FIND Almcmov WHERE ROWID(Almcmov) = output-var-1 NO-LOCK NO-ERROR.

IF AVAILABLE Almcmov THEN DO WITH FRAME {&FRAME-NAME}:
   FIND gn-prov WHERE gn-prov.CodCia = 0 AND 
                      gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
   IF NOT AVAILABLE gn-prov THEN 
      FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA AND 
           gn-prov.CodPro = Almcmov.CodPro NO-LOCK NO-ERROR.
   IF AVAILABLE gn-prov THEN 
   DISPLAY gn-prov.NomPro @ FILL-IN-NomPro .

   DISPLAY STRING(Almcmov.NroSer,"999") +  STRING(Almcmov.NroDoc,"999999")  @ Lg-liqcsg.NroRf2
           Almcmov.Nrorf1 @ Lg-liqcsg.NroRf1 
           Almcmov.CodPro @ Lg-liqcsg.CodPro .
           
           Lg-liqcsg.CodMon:SCREEN-VALUE = STRING(Almcmov.Codmon).
   
   FOR EACH Almdmov OF Almcmov NO-LOCK WHERE /*Almdmov.CodCia = Almcmov.CodCia 
                              AND Almdmov.CodAlm = Almcmov.CodAlm
                              AND Almdmov.TipMov = Almcmov.TipMov
                              AND Almdmov.Codmov = Almdmov.CodMov  
                              AND Almdmov.NroSer = Almcmov.NroSer 
                              AND Almcmov.NroDoc = Almcmov.NroDoc 
                              AND*/  (Almdmov.CanDes - Almdmov.CanDev) > 0:
       CREATE ITEM2.
       ASSIGN
              ITEM2.CodCia = S-CODCIA
              ITEM2.CodAlm = S-CODALM
              ITEM2.Codmat = Almdmov.Codmat 
              ITEM2.CodUnd = Almdmov.CodUnd
              ITEM2.CanDes = Almdmov.CanDes
              ITEM2.CanDev = Almdmov.CanDev
              ITEM2.StkSub = Almdmov.CanDes - Almdmov.CanDev
              ITEM2.PreLis = Almdmov.PreLis
              ITEM2.Dsctos[1] = Almdmov.Dsctos[1]
              ITEM2.Dsctos[2] = Almdmov.Dsctos[2]
              ITEM2.Dsctos[3] = Almdmov.Dsctos[3]
              ITEM2.IgvMat = Almdmov.IgvMat
              ITEM2.PreUni = Almdmov.PreUni 
              ITEM2.ImpCto = ROUND(ITEM2.StkSub * ITEM2.PreUni,2).
       FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                      AND  Almmmatg.codmat = ITEM2.codmat  
                     NO-LOCK NO-ERROR.
         
       FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
                      AND  Almtconv.Codalter = ITEM2.CodUnd 
                     NO-LOCK NO-ERROR.
       ITEM2.Factor = Almtconv.Equival / Almmmatg.FacEqu.
   END.
   RUN Procesa-Handle IN lh_Handle ('browse').
END.

OK-WAIT-STATE = SESSION:SET-WAIT-STATE("") .

RUN Estadistica-Venta.
RUN Procesa-Liquidacion.

RUN Procesa-Handle IN lh_Handle ('browse').


*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Detalle V-table-Win 
PROCEDURE Borra-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH lg-liqcsgd OF lg-liqcsg EXCLUSIVE-LOCK
      ON ERROR UNDO, RETURN "ADM-ERROR":
           ASSIGN R-ROWID = ROWID(lg-liqcsgd).
      DELETE lg-liqcsgd.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculos V-table-Win 
PROCEDURE Calculos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DO WITH FRAME {&FRAME-NAME}:
  FOR EACH ITEM2:
    CASE S-TIPO :
         WHEN "T" THEN DO:
             ITEM2.CanDes = ITEM2.CanIng - ITEM2.CanDev - ITEM2.CanLiq .
         END.
         WHEN "P" THEN DO:
             ITEM2.CanDes = ITEM2.CanVen - ITEM2.CanLiq .
         END.
    END.   

    ITEM2.ImpCto = ROUND(ITEM2.CanDes * ROUND(ITEM2.PreUni * (1 + (ITEM2.IgvMat / 100)) , 4),2).
    IF ITEM2.ImpCto = 0 THEN DELETE ITEM2.

  END.
  
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cerrar-Ingreso V-table-Win 
PROCEDURE Cerrar-Ingreso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
   DEFINE VAR I-NRO AS INTEGER INIT 0 NO-UNDO.
   FIND Almcmov WHERE 
        Almcmov.CodCia = lg-liqcsg.CodCia AND
        Almcmov.CodAlm = lg-liqcsg.codAlm AND
        Almcmov.TipMov = "I" AND
        Almcmov.Codmov = lg-liqcsg.Codmov AND
        Almcmov.NroDoc = INTEGER(SUBSTR(lg-liqcsg.Nrorf2,4,6)) 
        EXCLUSIVE-LOCK NO-ERROR.
           
   FOR EACH Almdmov OF Almcmov NO-LOCK :
       IF (Almdmov.Candes - Almdmov.CanDev) > 0 THEN DO:
          I-NRO = 1.
          LEAVE.
       END.
   END.

   IF AVAILABLE Almcmov THEN DO ON ERROR UNDO, RETURN "ADM-ERROR": 
      IF I-NRO = 0 THEN Almcmov.FlgSit = "L".
      ELSE              Almcmov.FlgSit = " ".
   END.
   RELEASE Almcmov.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle V-table-Win 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   FOR EACH ITEM2 WHERE ITEM2.codmat <> ""
       ON ERROR UNDO, RETURN "ADM-ERROR":
       CREATE lg-liqcsgd.
       ASSIGN lg-liqcsgd.CodCia = lg-liqcsg.CodCia 
              lg-liqcsgd.NroSer = lg-liqcsg.NroSer 
              lg-liqcsgd.NroDoc = lg-liqcsg.NroDoc 
              lg-liqcsgd.CodMon = lg-liqcsg.CodMon 
              lg-liqcsgd.FchDoc = lg-liqcsg.FchDoc 
              lg-liqcsgd.TpoCmb = lg-liqcsg.TpoCmb
              lg-liqcsgd.codmat = ITEM2.codmat
              lg-liqcsgd.CanDes = ITEM2.CanDes
              lg-liqcsgd.CanIng = ITEM2.CanIng
              lg-liqcsgd.CanLiq = ITEM2.CanLiq
              lg-liqcsgd.StkAct = ITEM2.StkAct
              lg-liqcsgd.CanVen = ITEM2.CanVen
              lg-liqcsgd.CanDev = ITEM2.CanDev
              lg-liqcsgd.CodUnd = ITEM2.CodUnd
              lg-liqcsgd.Factor = ITEM2.Factor
              lg-liqcsgd.Pesmat = ITEM2.Pesmat
              lg-liqcsgd.ImpCto = ITEM2.ImpCto
              lg-liqcsgd.PreLis = ITEM2.PreLis
              lg-liqcsgd.PreUni = ITEM2.PreUni
              lg-liqcsgd.Dsctos[1] = ITEM2.Dsctos[1]
              lg-liqcsgd.Dsctos[2] = ITEM2.Dsctos[2]
              lg-liqcsgd.Dsctos[3] = ITEM2.Dsctos[3]
              lg-liqcsgd.IgvMat = ITEM2.IgvMat
              lg-liqcsgd.HraDoc = lg-liqcsg.HorRcp
                     R-ROWID = ROWID(lg-liqcsgd).
       IF lg-liqcsg.codmon = 1 THEN DO:
          lg-liqcsgd.ImpMn1 = lg-liqcsgd.ImpCto.
       END.
       ELSE DO:
          lg-liqcsgd.ImpMn2 = lg-liqcsgd.ImpCto.
       END.

       FIND Almmmatg WHERE 
            Almmmatg.CodCia = lg-liqcsgd.CodCia AND
            Almmmatg.CodMat = lg-liqcsgd.codmat NO-LOCK NO-ERROR.
       IF AVAILABLE Almmmatg AND NOT Almmmatg.AftIgv THEN  lg-liqcsgd.IgvMat = 0.
        
       IF lg-liqcsg.codmon = 1 THEN DO:
          lg-liqcsg.ImpMn1 = lg-liqcsg.ImpMn1 + lg-liqcsgd.ImpMn1.
       END.
       ELSE DO:
          lg-liqcsg.ImpMn2 = lg-liqcsg.ImpMn2 + lg-liqcsgd.ImpMn2.
       END.

   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Almacen V-table-Win 
PROCEDURE Imprime-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 IF lg-liqcsg.FlgEst = "A" THEN  RETURN.

 RUN LGC\R-IMPLIQ2.R(ROWID(lg-liqcsg)).                     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Contabilidad V-table-Win 
PROCEDURE Imprime-Contabilidad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 IF lg-liqcsg.FlgEst = "A" THEN  RETURN.

 RUN LGC\R-IMPLIQ1.R(ROWID(lg-liqcsg)).                     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Detalle V-table-Win 
PROCEDURE Imprime-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 IF lg-liqcsg.FlgEst = "A" THEN  RETURN.

 RUN LGC\R-IMPLIQ4.R(ROWID(lg-liqcsg)).                     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprime-Proveedor V-table-Win 
PROCEDURE Imprime-Proveedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 IF lg-liqcsg.FlgEst = "A" THEN  RETURN.

 RUN LGC\R-IMPLIQ3.R(ROWID(lg-liqcsg)).                     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  L-CREA = YES.
  S-CODMON = 1.
  S-TIPO  = "P".
  X-DEVMOV = "".
  X-INGMOV = "".  
  
  DO WITH FRAME {&FRAME-NAME}:

     FIND lg-cfgcpr WHERE lg-cfgcpr.CodCia = S-CODCIA AND
                          lg-cfgcpr.TpoLiq = S-NROSER
                          NO-LOCK NO-ERROR.
     IF AVAILABLE lg-cfgcpr THEN 
        FILL-IN_NroDoc:SCREEN-VALUE = STRING(S-NROSER,"999") +  STRING(lg-cfgcpr.Correlativo,"999999").
  
        DISPLAY TODAY @ lg-liqcsg.FchDoc
                TODAY @ lg-liqcsg.FchIni
                TODAY @ lg-liqcsg.FchFin.

     FIND LAST Gn-Tcmb NO-LOCK NO-ERROR.                        
                     
     Lg-liqcsg.NroRf1:SENSITIVE = NO.
     Lg-liqcsg.NroRf2:SENSITIVE = NO.
     Lg-liqcsg.CodMon:SENSITIVE = YES.
     Lg-liqcsg.FlgSit:SENSITIVE = YES.
     Lg-liqcsg.FchFin:SENSITIVE = YES.
     Lg-liqcsg.CodMon:SCREEN-VALUE = "1".
     Lg-Liqcsg.FlgSit:SCREEN-VALUE = "P".                       
  END.
  RUN Actualiza-item.
  RUN Procesa-Handle IN lh_Handle ('Pagina2').
  RUN Procesa-Handle IN lh_Handle ('browse').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

  IF L-CREA THEN DO:
     ASSIGN lg-liqcsg.CodCia  = S-CODCIA 
            lg-liqcsg.NroSer  = S-NROSER
            lg-liqcsg.NroRf1  = X-DEVMOV
            lg-liqcsg.NroRf2  = X-INGMOV
            lg-liqcsg.HorRcp  = STRING(TIME,"HH:MM:SS").            

     FIND lg-cfgcpr WHERE lg-cfgcpr.CodCia = S-CODCIA AND
                          lg-cfgcpr.TpoLiq = S-NROSER
                          EXCLUSIVE-LOCK NO-ERROR.
     IF AVAILABLE lg-cfgcpr THEN ASSIGN lg-liqcsg.NroDoc = lg-cfgcpr.Correlativo 
                                        lg-cfgcpr.Correlativo = lg-cfgcpr.Correlativo + 1.
      RELEASE lg-cfgcpr.
     /*********************************/
     lg-liqcsg.NomRef  = Fill-in-nompro:screen-value in frame {&FRAME-NAME}.
  END.
  ASSIGN lg-liqcsg.usuario = S-USER-ID
         lg-liqcsg.ImpIgv  = 0
         lg-liqcsg.ImpMn1  = 0
         lg-liqcsg.ImpMn2  = 0
         lg-liqcsg.FchIni  = DESDEF
         lg-liqcsg.FchFin  = HASTAF
         lg-liqcsg.Codpro  = lg-liqcsg.Codpro:SCREEN-VALUE IN FRAME {&FRAME-NAME}
         lg-liqcsg.TpoCmb  = Gn-Tcmb.Venta
         lg-liqcsg.Codmon  = Integer(lg-liqcsg.CodMon:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

   
  /* ELIMINAMOS EL DETALLE ANTERIOR */
  IF NOT L-CREA THEN DO:
     /*RUN Actualiza-Detalle-Ingreso(-1).*/
     RUN Borra-Detalle.
  END.
  
  /* GENERAMOS NUEVO DETALLE */
  RUN Genera-Detalle.

  IF lg-liqcsg.codmon = 1 THEN 
     ASSIGN lg-liqcsg.ImpMn2 = ROUND(lg-liqcsg.ImpMn1 / lg-liqcsg.tpocmb, 2)
          /*  lg-liqcsg.ExoMn2 = ROUND(lg-liqcsg.ExoMn1 / lg-liqcsg.tpocmb, 2) */.
  ELSE 
     ASSIGN lg-liqcsg.ImpMn1 = ROUND(lg-liqcsg.ImpMn2 * lg-liqcsg.tpocmb, 2)
           /* lg-liqcsg.ExoMn1 = ROUND(lg-liqcsg.ExoMn2 * lg-liqcsg.tpocmb, 2) */.
  

  /*RUN Actualiza-Detalle-Ingreso(1).*/
/*  RUN Cerrar-Ingreso.*/

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('Browse').


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  RUN valida-update.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN ERROR.
  /* Eliminamos el detalle */
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR":

/*     RUN Actualiza-Detalle-Ingreso(-1).*/
     RUN Borra-Detalle.
/*     RUN Cerrar-Ingreso.*/
     
     /* Solo marcamos el FlgEst como Anulado */
     FIND CLIQ WHERE 
          CLIQ.CodCia = lg-liqcsg.CodCia AND 
          CLIQ.NroSer = lg-liqcsg.NroSer AND 
          CLIQ.NroDoc = lg-liqcsg.NroDoc 
          EXCLUSIVE-LOCK NO-ERROR.
     ASSIGN CLIQ.FlgEst = 'A'
            CLIQ.Observ = "      A   N   U   L   A   D   O       "
            CLIQ.Usuario = S-USER-ID .
     RELEASE CLIQ.
  END.
  /* refrescamos los datos del viewer */
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  /* refrescamos los datos del browse */
  RUN Procesa-Handle IN lh_Handle ('browse').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF AVAILABLE lg-liqcsg THEN DO WITH FRAME {&FRAME-NAME}:
     FIND lg-cfgcpr WHERE lg-cfgcpr.Codcia = S-CODCIA AND
                          lg-cfgcpr.TpoLiq = S-NROSER
                          NO-LOCK NO-ERROR.
     F-Desliq:SCREEN-VALUE = lg-cfgcpr.descrip.                     
     
     FILL-IN_NroDoc:SCREEN-VALUE = STRING(lg-liqcsg.NroSer,"999") + STRING(lg-liqcsg.NroDoc,"999999").
     
     IF lg-liqcsg.FlgEst  = "A" THEN F-STATUS:SCREEN-VALUE = "  ANULADO   ".
     
     FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA AND 
                        gn-prov.CodPro = lg-liqcsg.codpro NO-LOCK NO-ERROR.
     
     IF NOT AVAILABLE gn-prov THEN 
        FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA AND 
             gn-prov.CodPro = lg-liqcsg.codpro NO-LOCK NO-ERROR.
     
     IF AVAILABLE gn-prov THEN 
        DISPLAY gn-prov.NomPro @ FILL-IN-NomPro WITH FRAME {&FRAME-NAME}.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-imprime V-table-Win 
PROCEDURE local-imprime :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  IF lg-liqcsg.FlgEst = "A" THEN  RETURN.

  MESSAGE "Imprime Detalle ?" 
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
                    TITLE "Tipo Impresion" UPDATE choice AS LOGICAL.
      CASE choice:
         WHEN TRUE THEN /* Yes */
          DO:
           RUN LGC\R-IMPLIQ1.R(ROWID(lg-liqcsg)).                     
          END.
         WHEN FALSE THEN /* No */
          DO:           
           RUN LGC\R-IMPLIQ1.R(ROWID(lg-liqcsg)).
          END.
         END CASE.   /* Code placed here will execute PRIOR to standard behavior. */


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").
  

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  RUN Procesa-Handle IN lh_Handle ('Pagina1').
  RUN Procesa-Handle IN lh_Handle ('browse').

  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Consignacion V-table-Win 
PROCEDURE Procesa-Consignacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.

OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH ITEM2:
    DELETE ITEM2.
END.

DO WITH FRAME {&FRAME-NAME}:
 
   Lg-liqcsg.CodMon:SENSITIVE = NO.
   Lg-liqcsg.CodPro:SENSITIVE = NO.
   Lg-liqcsg.FlgSit:SENSITIVE = NO.
   Lg-liqcsg.FchFin:SENSITIVE = NO.

END.

RUN Procesa-Ingresos.
RUN Procesa-Stock.
RUN Procesa-Devoluciones.
RUN Procesa-Liquidacion.
RUN Procesa-Operaciones.

RUN Calculos.


OK-WAIT-STATE = SESSION:SET-WAIT-STATE("") .

RUN Procesa-Handle IN lh_Handle ('browse').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Consignacion-Backup V-table-Win 
PROCEDURE Procesa-Consignacion-Backup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
DEFINE VAR x-codmov as char .
DEFINE VAR II AS INTEGER .

DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.

input-var-1 = lg-cfgcpr.Almacenes.
input-var-2 = "I".
input-var-3 = string(lg-cfgliq.CodMov).

DEFINE VAR I AS INTEGER.

OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

FOR EACH ITEM2:
    DELETE ITEM2.
END.

FIND LAST Lg-cfgliqp WHERE Lg-cfgliqp.Codcia = S-CODCIA AND
                           Lg-cfgliqp.Tpoliq  = Lg-cfgliq.Tpoliq AND
                           Lg-cfgliqp.CodPro  = lg-liqcsg.CodPro:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                           NO-LOCK NO-ERROR.

IF AVAILABLE Lg-Cfgliqp THEN DO:
   DESDEF = Lg-cfgliqp.FchIni.
   HASTAF = Lg-cfgliqp.FchFin.
END.   

IF TODAY > HASTAF THEN DO:
    MESSAGE "Fecha de Liquidacion excede el Periodo Asignado " SKIP
            "Fecha Inicio : " + STRING(DESDEF,"99/99/9999") SKIP
            "Fecha Fin    : " + STRING(HASTAF,"99/99/9999") SKIP
            "No se puede realizar Liquidacion "
    VIEW-AS ALERT-BOX ERROR.
    RETURN.

END.

DO WITH FRAME {&FRAME-NAME}:
 
   Lg-liqcsg.CodMon:SENSITIVE = NO.
   Lg-liqcsg.CodPro:SENSITIVE = NO.

   /********C************/
   DO I = 1 TO NUM-ENTRIES(input-var-1):

    /**********B**********/
    FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = S-CODCIA AND
                                   Almcmov.CodAlm = ENTRY(I,input-var-1) AND
                                   Almcmov.TipMov = input-var-2 AND
                                   Almcmov.CodMov = INTEGER(input-var-3) AND
                                   Almcmov.FlgEst <> "A" AND
                                   Almcmov.FchDoc >= DESDEF AND
                                   Almcmov.FchDoc <= HASTAF AND
                                   Almcmov.CodPro = lg-liqcsg.CodPro:SCREEN-VALUE :
  
        IF  Lg-liqcsg.CodMon:SCREEN-VALUE <> STRING(Almcmov.Codmon) THEN DO:
            MESSAGE "Documento de Ingreso con Moneda diferente" SKIP
                    "Ingreso no sera considerado " SKIP
                    "Almacen  : " + Almcmov.CodAlm SKIP
                    "Codigo   : " + "I" + STRING(Almcmov.Codmov,"99") SKIP
                    "Numero   : " + STRING(Almcmov.NroDoc,"999999") SKIP
                    "Fecha    : " + STRING(Almcmov.fchDoc,"99/99/9999") SKIP
                    "Ingreso de Almacen No sera considerado "
            VIEW-AS ALERT-BOX ERROR.
            NEXT.       
        END.
     
        FIND LG-COCMP  WHERE LG-COCMP.CODCIA = S-CODCIA AND
                             LG-COCMP.NRODOC = INTEGER(ALMCMOV.NRORF1) 
                             NO-LOCK NO-ERROR.
        IF NOT AVAILABLE LG-COCMP THEN DO:
           MESSAGE "No Existe Orden de Compra " + Almcmov.Nrorf1 SKIP
                   "Almacen : " + Almcmov.CodAlm SKIP
                   "Ingreso : " + Almcmov.Tipmov + STRING(Almcmov.Codmov,"99") + " " + STRING(Almcmov.NroDoc,"999999")
                   "Fecha Ingreso : " + STRING(Almcmov.FchDoc,"99/99/9999") SKIP
                   "Los Precios Unitarios tendran el valor cero" 
                   VIEW-AS ALERT-BOX.
        END.                                             

        IF LG-COCMP.CodMon <> Almcmov.CodMon THEN DO:
           MESSAGE "Ingreso de Almacen con Moneda Diferente a O/C "  SKIP
                   "Almacen : " + Almcmov.CodAlm SKIP
                   "Ingreso : " + Almcmov.Tipmov + STRING(Almcmov.Codmov,"99") + " " + STRING(Almcmov.NroDoc,"999999")
                   "Fecha Ingreso : " + STRING(Almcmov.FchDoc,"99/99/9999") SKIP
                   "Orden de Compra :" + STRING(LG-COCMP.NroDoc,"999999") SKIP
                   "Ingreso de Almacen No sera considerado "
                   VIEW-AS ALERT-BOX.
                   NEXT.
        END.                                             
        
       /*DISPLAY Lg-liqcsg.CodMon:SCREEN-VALUE = STRING(Almcmov.Codmon).*/
       /*******A*******/
       FOR EACH Almdmov OF Almcmov NO-LOCK WHERE 
                           Almdmov.CanDes > 0:
            FIND ITEM2 WHERE ITEM2.Codcia = Almdmov.Codcia AND
                            ITEM2.CodAlm = lg-cfgliq.codAlm  AND
                            ITEM2.CodMat = Almdmov.CodMat
                            EXCLUSIVE-LOCK NO-ERROR.

            IF NOT AVAILABLE ITEM2 THEN DO:                
                 CREATE ITEM2.
                 ASSIGN
                        ITEM2.CodCia = Almdmov.Codcia
                        ITEM2.CodAlm = lg-cfgliq.codAlm /*Almdmov.CodAlm*/
                        ITEM2.Codmat = Almdmov.Codmat 
                        ITEM2.CodUnd = Almdmov.CodUnd
                        ITEM2.IgvMat = Almdmov.IgvMat.
                 FIND LG-DOCMP  WHERE LG-DOCMP.CODCIA = S-CODCIA AND
                                      LG-DOCMP.NRODOC = INTEGER(ALMCMOV.NRORF1) AND
                                      LG-DOCMP.CODMAT = ALMDMOV.CODMAT
                                      NO-LOCK NO-ERROR.
                 IF AVAILABLE LG-DOCMP THEN DO:
                    ASSIGN 
                         ITEM2.PreLis = LG-DOCmp.PreUni
                         ITEM2.Dsctos[1] = LG-DOCmp.Dsctos[1]
                         ITEM2.Dsctos[2] = LG-DOCmp.Dsctos[2]
                         ITEM2.Dsctos[3] = LG-DOCmp.Dsctos[3]
                         ITEM2.IgvMat = LG-DOCmp.IgvMat
                         ITEM2.PreUni = ROUND(LG-DOCmp.PreUni * (1 - (LG-DOCmp.Dsctos[1] / 100)) * 
                                 (1 - (LG-DOCmp.Dsctos[2] / 100)) * 
                                 (1 - (LG-DOCmp.Dsctos[3] / 100)),4) .
                 END.
                 ELSE DO:        
                   ASSIGN
                        ITEM2.PreLis = Almdmov.PreLis
                        ITEM2.Dsctos[1] = Almdmov.Dsctos[1]
                        ITEM2.Dsctos[2] = Almdmov.Dsctos[2]
                        ITEM2.Dsctos[3] = Almdmov.Dsctos[3]
                        ITEM2.PreUni = Almdmov.PreUni
                        ITEM2.IgvMat = Almdmov.IgvMat.
                        
                 END.        
                 FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                                AND  Almmmatg.codmat = ITEM2.codmat  
                               NO-LOCK NO-ERROR.
                   
                 FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
                                AND  Almtconv.Codalter = ITEM2.CodUnd 
                               NO-LOCK NO-ERROR.
     
                 ITEM2.Factor = Almtconv.Equival / Almmmatg.FacEqu.
            END.
            ASSIGN
              ITEM2.CanIng = ITEM2.CanIng + Almdmov.CanDes
              ITEM2.CanDes = ITEM2.CanDes + Almdmov.CanDes 
              ITEM2.ImpCto = ROUND(ITEM2.CanDes * ROUND(ITEM2.PreUni * (1 + (ITEM2.IgvMat / 100)) , 4),2).
       END.  
       /*******A***********/
    END.
    /*********B*********/
  END.  
  /******C**********/



  /***********DEVOLUCIONES******************/
  /************D************/
  DO I = 1 TO NUM-ENTRIES(input-var-1):  
     x-codmov = "26,17,09".

     /**********C************/
     DO II = 1 TO NUM-ENTRIES(x-codmov): 
       /***********B************/ 
       FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = S-CODCIA AND
                                      Almcmov.CodAlm = ENTRY(I,input-var-1) AND
                                      Almcmov.TipMov = "S" AND
                                      Almcmov.CodMov = INTEGER(ENTRY(II,x-codmov)) AND 
                                      Almcmov.FlgEst <> "A" AND
                                      Almcmov.FchDoc >= DESDEF AND
                                      Almcmov.FchDoc <= HASTAF AND
                                      Almcmov.CodPro = lg-liqcsg.CodPro:SCREEN-VALUE :
         /*************A*************/
         FOR EACH Almdmov OF Almcmov :                                                          
             FIND ITEM2 WHERE ITEM2.Codcia = Almdmov.Codcia AND
                             ITEM2.CodAlm = lg-cfgliq.codAlm AND /*Almdmov.Codalm */
                             ITEM2.CodMat = Almdmov.CodMat
                             EXCLUSIVE-LOCK NO-ERROR.      
             IF NOT AVAILABLE ITEM2 THEN DO:                
                  CREATE ITEM2.
                  ASSIGN
                         ITEM2.CodCia = Almdmov.Codcia
                         ITEM2.CodAlm = lg-cfgliq.codAlm /*Almdmov.CodAlm*/
                         ITEM2.Codmat = Almdmov.Codmat 
                         ITEM2.CodUnd = Almdmov.CodUnd
                         ITEM2.IgvMat = Almdmov.IgvMat
                         ITEM2.PreLis = Almdmov.PreLis
                         ITEM2.Dsctos[1] = Almdmov.Dsctos[1]
                         ITEM2.Dsctos[2] = Almdmov.Dsctos[2]
                         ITEM2.Dsctos[3] = Almdmov.Dsctos[3]
                         ITEM2.PreUni = Almdmov.PreUni
                         ITEM2.IgvMat = Almdmov.IgvMat.                   
                  
                  FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                                 AND  Almmmatg.codmat = ITEM2.codmat  
                                NO-LOCK NO-ERROR.
                    
                  FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
                                 AND  Almtconv.Codalter = ITEM2.CodUnd 
                                NO-LOCK NO-ERROR.
      
                  ITEM2.Factor = Almtconv.Equival / Almmmatg.FacEqu.
             END.
             ASSIGN
              ITEM2.CanDev = ITEM2.Candev + Almdmov.CanDes
              ITEM2.CanDes = ITEM2.CanDes - Almdmov.CanDes 
              ITEM2.ImpCto = ROUND(ITEM2.CanDes * ROUND(ITEM2.PreUni * (1 + (ITEM2.IgvMat / 100)) , 4),2).
         END.
         /************A*************/
       END.
       /************B************/
     END.
     /***********C************/     
  END.
  /***********D***********/
  
END.

OK-WAIT-STATE = SESSION:SET-WAIT-STATE("") .

RUN Estadistica-Venta.
RUN Procesa-Liquidacion.
RUN Calculos.

RUN Procesa-Handle IN lh_Handle ('browse').
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Devoluciones V-table-Win 
PROCEDURE Procesa-Devoluciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
X-DEVMOV = "".

DO WITH FRAME {&FRAME-NAME}:

   DO I = 1 TO NUM-ENTRIES(LG-Cfgcpr.Almacenes):

    FOR EACH Almcmov NO-LOCK WHERE Almcmov.Codcia = S-CODCIA AND
                                   Almcmov.CodAlm = ENTRY(I,LG-Cfgcpr.Almacenes) AND
                                   Almcmov.TipMov = LG-Cfgcpr.TipMov[2] AND
                                   Almcmov.CodMov = LG-Cfgcpr.CodMov[2] AND
                                   Almcmov.FlgEst <> "A" AND
                                   Almcmov.FchDoc >= DESDEF AND
                                   Almcmov.FchDoc <= HASTAF AND
                                   Almcmov.CodPro = lg-liqcsg.CodPro:SCREEN-VALUE :
  
        IF  Lg-liqcsg.CodMon:SCREEN-VALUE <> STRING(Almcmov.Codmon) THEN DO:
            MESSAGE "Documento de Ingreso con Moneda diferente" SKIP
                    "Ingreso no sera considerado " SKIP
                    "Almacen  : " + Almcmov.CodAlm SKIP
                    "Codigo   : " + Almcmov.TipMov + STRING(Almcmov.Codmov,"99") SKIP
                    "Numero   : " + STRING(Almcmov.NroDoc,"999999") SKIP
                    "Fecha    : " + STRING(Almcmov.fchDoc,"99/99/9999") SKIP
                    "Ingreso de Almacen No sera considerado "
            VIEW-AS ALERT-BOX ERROR.
            NEXT.       
        END.
     
        FIND LG-COCMP  WHERE LG-COCMP.CODCIA = S-CODCIA AND
                             LG-COCMP.NRODOC = INTEGER(ALMCMOV.NRORF1) 
                             NO-LOCK NO-ERROR.
        IF NOT AVAILABLE LG-COCMP THEN DO:
           MESSAGE "No Existe Orden de Compra " + Almcmov.Nrorf1 SKIP
                   "Almacen : " + Almcmov.CodAlm SKIP
                   "Ingreso : " + Almcmov.Tipmov + STRING(Almcmov.Codmov,"99") + " " + STRING(Almcmov.NroDoc,"999999")
                   "Fecha Ingreso : " + STRING(Almcmov.FchDoc,"99/99/9999") SKIP
                   "Los Precios Unitarios tendran el valor cero" 
                   VIEW-AS ALERT-BOX.
        END.                                             

        IF LG-COCMP.CodMon <> Almcmov.CodMon THEN DO:
           MESSAGE "Ingreso de Almacen con Moneda Diferente a O/C "  SKIP
                   "Almacen : " + Almcmov.CodAlm SKIP
                   "Ingreso : " + Almcmov.Tipmov + STRING(Almcmov.Codmov,"99") + " " + STRING(Almcmov.NroDoc,"999999")
                   "Fecha Ingreso : " + STRING(Almcmov.FchDoc,"99/99/9999") SKIP
                   "Orden de Compra :" + STRING(LG-COCMP.NroDoc,"999999") SKIP
                   "Ingreso de Almacen No sera considerado "
                   VIEW-AS ALERT-BOX.
                   NEXT.
        END.                                             
        
       IF X-DEVMOV = "" THEN X-DEVMOV = Almcmov.CodAlm + "-" + Almcmov.Tipmov + STRING(Almcmov.Codmov,"99") + "-" + STRING(Almcmov.NroDoc,"999999").
       ELSE X-DEVMOV = X-DEVMOV + "," + Almcmov.CodAlm + "-" + Almcmov.Tipmov + STRING(Almcmov.Codmov,"99") + "-" + STRING(Almcmov.NroDoc,"999999").

       /*DISPLAY Lg-liqcsg.CodMon:SCREEN-VALUE = STRING(Almcmov.Codmon).*/
       /*******A*******/
       FOR EACH Almdmov OF Almcmov NO-LOCK WHERE 
                           Almdmov.CanDes > 0:
            FIND ITEM2 WHERE ITEM2.Codcia = Almdmov.Codcia AND
                             /*ITEM2.CodAlm = lg-cfgliq.codAlm  AND*/
                             ITEM2.CodMat = Almdmov.CodMat
                             EXCLUSIVE-LOCK NO-ERROR.

            IF NOT AVAILABLE ITEM2 THEN DO:                
                 CREATE ITEM2.
                 ASSIGN
                        ITEM2.CodCia = Almdmov.Codcia
                        /*ITEM2.CodAlm = lg-cfgliq.codAlm /*Almdmov.CodAlm*/*/
                        ITEM2.Codmat = Almdmov.Codmat 
                        ITEM2.CodUnd = Almdmov.CodUnd
                        ITEM2.IgvMat = Almdmov.IgvMat.
                 FIND LG-DOCMP  WHERE LG-DOCMP.CODCIA = S-CODCIA AND
                                      LG-DOCMP.NRODOC = INTEGER(ALMCMOV.NRORF1) AND
                                      LG-DOCMP.CODMAT = ALMDMOV.CODMAT
                                      NO-LOCK NO-ERROR.
                 IF AVAILABLE LG-DOCMP THEN DO:
                    ASSIGN 
                         ITEM2.PreLis = LG-DOCmp.PreUni
                         ITEM2.Dsctos[1] = LG-DOCmp.Dsctos[1]
                         ITEM2.Dsctos[2] = LG-DOCmp.Dsctos[2]
                         ITEM2.Dsctos[3] = LG-DOCmp.Dsctos[3]
                         ITEM2.IgvMat = LG-DOCmp.IgvMat
                         ITEM2.PreUni = ROUND(LG-DOCmp.PreUni * (1 - (LG-DOCmp.Dsctos[1] / 100)) * 
                                 (1 - (LG-DOCmp.Dsctos[2] / 100)) * 
                                 (1 - (LG-DOCmp.Dsctos[3] / 100)),4) .
                 END.
                 ELSE DO:        
                   ASSIGN
                        ITEM2.PreLis = Almdmov.PreLis
                        ITEM2.Dsctos[1] = Almdmov.Dsctos[1]
                        ITEM2.Dsctos[2] = Almdmov.Dsctos[2]
                        ITEM2.Dsctos[3] = Almdmov.Dsctos[3]
                        ITEM2.PreUni = Almdmov.PreUni
                        ITEM2.IgvMat = Almdmov.IgvMat.
                        
                 END.        
                 FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                                AND  Almmmatg.codmat = ITEM2.codmat  
                               NO-LOCK NO-ERROR.
                   
                 FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
                                AND  Almtconv.Codalter = ITEM2.CodUnd 
                               NO-LOCK NO-ERROR.
     
                 ITEM2.Factor = Almtconv.Equival / Almmmatg.FacEqu.
            END.
            ASSIGN
              ITEM2.CanDev = ITEM2.CanDev + Almdmov.CanDes.
       END.  
       /*******A***********/
    END.
    /*********B*********/
  END.  
  /******C**********/
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Ingresos V-table-Win 
PROCEDURE Procesa-Ingresos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
X-INGMOV = "".

DO WITH FRAME {&FRAME-NAME}:

   DO I = 1 TO NUM-ENTRIES(LG-Cfgcpr.Almacenes):

    FOR EACH Almcmov NO-LOCK WHERE Almcmov.Codcia = S-CODCIA AND
                                   Almcmov.CodAlm = ENTRY(I,LG-Cfgcpr.Almacenes) AND
                                   Almcmov.TipMov = LG-Cfgcpr.TipMov[1] AND
                                   Almcmov.CodMov = LG-Cfgcpr.CodMov[1] AND
                                   Almcmov.FlgEst <> "A" AND
                                   Almcmov.FchDoc >= DESDEF AND
                                   Almcmov.FchDoc <= HASTAF AND
                                   Almcmov.CodPro = lg-liqcsg.CodPro:SCREEN-VALUE :
        /*
        IF  Lg-liqcsg.CodMon:SCREEN-VALUE <> STRING(Almcmov.Codmon) THEN DO:
            MESSAGE "Documento de Ingreso con Moneda diferente" SKIP
                    "Ingreso no sera considerado " SKIP
                    "Almacen  : " + Almcmov.CodAlm SKIP
                    "Codigo   : " + Almcmov.TipMov + STRING(Almcmov.Codmov,"99") SKIP
                    "Numero   : " + STRING(Almcmov.NroDoc,"999999") SKIP
                    "Fecha    : " + STRING(Almcmov.fchDoc,"99/99/9999") SKIP
                    "Ingreso de Almacen No sera considerado "
            VIEW-AS ALERT-BOX ERROR.
            NEXT.       
        END.
        */
        FIND LG-COCMP  WHERE LG-COCMP.CODCIA = S-CODCIA AND
                             LG-COCMP.NRODOC = INTEGER(ALMCMOV.NRORF1) 
                             NO-LOCK NO-ERROR.
        IF NOT AVAILABLE LG-COCMP THEN DO:
           MESSAGE "No Existe Orden de Compra " + Almcmov.Nrorf1 SKIP
                   "Almacen : " + Almcmov.CodAlm SKIP
                   "Ingreso : " + Almcmov.Tipmov + STRING(Almcmov.Codmov,"99") + " " + STRING(Almcmov.NroDoc,"999999")
                   "Fecha Ingreso : " + STRING(Almcmov.FchDoc,"99/99/9999") SKIP
                   "Los Precios Unitarios tendran el valor cero" 
                   VIEW-AS ALERT-BOX.
        END.                                             

        IF LG-COCMP.CodMon <> Almcmov.CodMon THEN DO:
           MESSAGE "Ingreso de Almacen con Moneda Diferente a O/C "  SKIP
                   "Almacen : " + Almcmov.CodAlm SKIP
                   "Ingreso : " + Almcmov.Tipmov + STRING(Almcmov.Codmov,"99") + " " + STRING(Almcmov.NroDoc,"999999")
                   "Fecha Ingreso : " + STRING(Almcmov.FchDoc,"99/99/9999") SKIP
                   "Orden de Compra :" + STRING(LG-COCMP.NroDoc,"999999") SKIP
                   "Ingreso de Almacen No sera considerado "
                   VIEW-AS ALERT-BOX.
                   NEXT.
        END.                                             

       IF X-INGMOV = "" THEN X-INGMOV = Almcmov.CodAlm + "-" + Almcmov.Tipmov + STRING(Almcmov.Codmov,"99") + "-" + STRING(Almcmov.NroDoc,"999999").
       ELSE X-INGMOV = X-INGMOV + "," + Almcmov.CodAlm + "-" + Almcmov.Tipmov + STRING(Almcmov.Codmov,"99") + "-" + STRING(Almcmov.NroDoc,"999999").
   
       /*DISPLAY Lg-liqcsg.CodMon:SCREEN-VALUE = STRING(Almcmov.Codmon).*/
       /*******A*******/
       FOR EACH Almdmov OF Almcmov NO-LOCK WHERE 
                           Almdmov.CanDes > 0:
            FIND ITEM2 WHERE ITEM2.Codcia = Almdmov.Codcia AND
                             /*ITEM2.CodAlm = lg-cfgliq.codAlm  AND*/
                             ITEM2.CodMat = Almdmov.CodMat
                             EXCLUSIVE-LOCK NO-ERROR.

            IF NOT AVAILABLE ITEM2 THEN DO:                
                 CREATE ITEM2.
                 ASSIGN
                        ITEM2.CodCia = Almdmov.Codcia
                        /*ITEM2.CodAlm = lg-cfgliq.codAlm /*Almdmov.CodAlm*/*/
                        ITEM2.Codmat = Almdmov.Codmat 
                        ITEM2.CodUnd = Almdmov.CodUnd
                        ITEM2.IgvMat = Almdmov.IgvMat.
                 FIND LG-DOCMP  WHERE LG-DOCMP.CODCIA = S-CODCIA AND
                                      LG-DOCMP.NRODOC = INTEGER(ALMCMOV.NRORF1) AND
                                      LG-DOCMP.CODMAT = ALMDMOV.CODMAT
                                      NO-LOCK NO-ERROR.
                 IF AVAILABLE LG-DOCMP THEN DO:
                    ASSIGN 
                         ITEM2.PreLis = LG-DOCmp.PreUni
                         ITEM2.Dsctos[1] = LG-DOCmp.Dsctos[1]
                         ITEM2.Dsctos[2] = LG-DOCmp.Dsctos[2]
                         ITEM2.Dsctos[3] = LG-DOCmp.Dsctos[3]
                         ITEM2.IgvMat = LG-DOCmp.IgvMat
                         ITEM2.PreUni = ROUND(LG-DOCmp.PreUni * (1 - (LG-DOCmp.Dsctos[1] / 100)) * 
                                 (1 - (LG-DOCmp.Dsctos[2] / 100)) * 
                                 (1 - (LG-DOCmp.Dsctos[3] / 100)),4) .
                 END.
                 ELSE DO:        
                   ASSIGN
                        ITEM2.PreLis = Almdmov.PreLis
                        ITEM2.Dsctos[1] = Almdmov.Dsctos[1]
                        ITEM2.Dsctos[2] = Almdmov.Dsctos[2]
                        ITEM2.Dsctos[3] = Almdmov.Dsctos[3]
                        ITEM2.PreUni = Almdmov.PreUni
                        ITEM2.IgvMat = Almdmov.IgvMat.
                        
                 END.        
                 FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                                AND  Almmmatg.codmat = ITEM2.codmat  
                               NO-LOCK NO-ERROR.
                   
                 FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
                                AND  Almtconv.Codalter = ITEM2.CodUnd 
                               NO-LOCK NO-ERROR.
     
                 ITEM2.Factor = Almtconv.Equival / Almmmatg.FacEqu.
            END.
            ASSIGN
              ITEM2.CanIng = ITEM2.CanIng + Almdmov.CanDes.
       END.  
       /*******A***********/
    END.
    /*********B*********/
  END.  
  /******C**********/
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Liquidacion V-table-Win 
PROCEDURE Procesa-Liquidacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    FOR EACH Lg-Liqcsg WHERE Lg-Liqcsg.Codcia = S-CODCIA AND
                             Lg-Liqcsg.NroSer = Lg-cfgcpr.TpoLiq AND
                             Lg-Liqcsg.CodPro = lg-liqcsg.CodPro:SCREEN-VALUE AND
                             Lg-Liqcsg.FchDoc >= DESDEF AND
                             Lg-Liqcsg.FchDoc <= HASTAF AND
                             Lg-Liqcsg.FlgEst <> "A":
        FOR EACH Lg-Liqcsgd  OF Lg-Liqcsg :

            FIND ITEM2 WHERE ITEM2.Codcia = S-CODCIA AND
                             ITEM2.CodMat = Lg-Liqcsgd.CodMat
                             EXCLUSIVE-LOCK NO-ERROR.

            IF NOT AVAILABLE ITEM2 THEN DO:                
                 CREATE ITEM2.
                 ASSIGN
                        ITEM2.CodCia = Lg-Liqcsgd.Codcia
                        ITEM2.Codmat = Lg-Liqcsgd.Codmat 
                        ITEM2.CodUnd = Lg-Liqcsgd.CodUnd
                        ITEM2.IgvMat = Lg-Liqcsgd.IgvMat
                        ITEM2.PreLis = Lg-Liqcsgd.PreLis
                        ITEM2.Dsctos[1] = Lg-Liqcsgd.Dsctos[1]
                        ITEM2.Dsctos[2] = Lg-Liqcsgd.Dsctos[2]
                        ITEM2.Dsctos[3] = Lg-Liqcsgd.Dsctos[3]
                        ITEM2.PreUni = Lg-Liqcsgd.PreUni
                        ITEM2.IgvMat = Lg-Liqcsgd.IgvMat.
                        
                 FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                                AND  Almmmatg.codmat = ITEM2.codmat  
                               NO-LOCK NO-ERROR.
                   
                 FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
                                AND  Almtconv.Codalter = ITEM2.CodUnd 
                               NO-LOCK NO-ERROR.
     
                 ITEM2.Factor = Almtconv.Equival / Almmmatg.FacEqu.
            END.
            ASSIGN
              ITEM2.CanLiq = ITEM2.CanLiq + Lg-Liqcsgd.CanDes.        
        END.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Operaciones V-table-Win 
PROCEDURE Procesa-Operaciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
 FOR EACH ITEM2:
   X-STOCK = 0.
   DO I = 1 TO NUM-ENTRIES(LG-Cfgcpr.Almacenes):
 
    FIND LAST AlmSub WHERE AlmSub.Codcia = S-CODCIA AND
                           AlmSub.CodAlm = ENTRY(I,LG-Cfgcpr.Almacenes) AND
                           AlmSub.CodMat = ITEM2.CodMat AND
                           AlmSub.FchDoc <= HASTAF
                           NO-LOCK NO-ERROR.
    IF AVAILABLE AlmSub THEN DO:
       X-STOCK = X-STOCK + AlmSub.StkSub.
       ITEM2.StkAct = ITEM2.StkAct + AlmSub.StkSub.
    END.
                               
   END.  
   IF X-STOCK < ITEM2.CanIng - ITEM2.CanDev THEN DO:   
      ITEM2.CanVen = ITEM2.CanIng - ITEM2.CanDev - X-STOCK.
   END.
 END.
  /******C**********/
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Operaciones-Backup V-table-Win 
PROCEDURE Procesa-Operaciones-Backup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
 DO II = 1 TO NUM-ENTRIES(X-TIPMOV):
   FOR EACH Almtmovm WHERE Almtmovm.Codcia = S-CODCIA AND
                           Almtmovm.TipMov = ENTRY(II,X-TIPMOV):

   IF Almtmovm.MovTrf THEN NEXT.
   IF LG-Cfgcpr.TipMov[1] = Almtmovm.TipMov AND LG-Cfgcpr.CodMov[1] = Almtmovm.CodMov THEN NEXT.
   IF LG-Cfgcpr.TipMov[2] = Almtmovm.TipMov AND LG-Cfgcpr.CodMov[2] = Almtmovm.CodMov THEN NEXT.

   DO I = 1 TO NUM-ENTRIES(LG-Cfgcpr.Almacenes):

    FOR EACH Almcmov NO-LOCK WHERE Almcmov.Codcia = S-CODCIA AND
                                   Almcmov.CodAlm = ENTRY(I,LG-Cfgcpr.Almacenes) AND
                                   Almcmov.TipMov = Almtmovm.TipMov AND
                                   Almcmov.CodMov = Almtmovm.CodMov AND
                                   Almcmov.FlgEst <> "A" AND
                                   Almcmov.FchDoc >= DESDEF AND
                                   Almcmov.FchDoc <= HASTAF :
  
       X-FACTOR = IF Almcmov.TipMov = "I" THEN 1 ELSE -1.
               
       /*******A*******/
       FOR EACH Almdmov OF Almcmov NO-LOCK WHERE 
                           Almdmov.CanDes > 0:
            FIND ITEM2 WHERE ITEM2.Codcia = Almdmov.Codcia AND
                             /*ITEM2.CodAlm = lg-cfgliq.codAlm  AND*/
                             ITEM2.CodMat = Almdmov.CodMat
                             EXCLUSIVE-LOCK NO-ERROR.

            IF NOT AVAILABLE ITEM2 THEN DO:                
                 CREATE ITEM2.
                 ASSIGN
                        ITEM2.CodCia = Almdmov.Codcia
                        /*ITEM2.CodAlm = lg-cfgliq.codAlm /*Almdmov.CodAlm*/*/
                        ITEM2.Codmat = Almdmov.Codmat 
                        ITEM2.CodUnd = Almdmov.CodUnd
                        ITEM2.IgvMat = Almdmov.IgvMat.
                 FIND LG-DOCMP  WHERE LG-DOCMP.CODCIA = S-CODCIA AND
                                      LG-DOCMP.NRODOC = INTEGER(ALMCMOV.NRORF1) AND
                                      LG-DOCMP.CODMAT = ALMDMOV.CODMAT
                                      NO-LOCK NO-ERROR.
                 IF AVAILABLE LG-DOCMP THEN DO:
                    ASSIGN 
                         ITEM2.PreLis = LG-DOCmp.PreUni
                         ITEM2.Dsctos[1] = LG-DOCmp.Dsctos[1]
                         ITEM2.Dsctos[2] = LG-DOCmp.Dsctos[2]
                         ITEM2.Dsctos[3] = LG-DOCmp.Dsctos[3]
                         ITEM2.IgvMat = LG-DOCmp.IgvMat
                         ITEM2.PreUni = ROUND(LG-DOCmp.PreUni * (1 - (LG-DOCmp.Dsctos[1] / 100)) * 
                                 (1 - (LG-DOCmp.Dsctos[2] / 100)) * 
                                 (1 - (LG-DOCmp.Dsctos[3] / 100)),4) .
                 END.
                 ELSE DO:        
                   ASSIGN
                        ITEM2.PreLis = Almdmov.PreLis
                        ITEM2.Dsctos[1] = Almdmov.Dsctos[1]
                        ITEM2.Dsctos[2] = Almdmov.Dsctos[2]
                        ITEM2.Dsctos[3] = Almdmov.Dsctos[3]
                        ITEM2.PreUni = Almdmov.PreUni
                        ITEM2.IgvMat = Almdmov.IgvMat.
                        
                 END.        
                 FIND Almmmatg WHERE Almmmatg.CodCia = S-CODCIA 
                                AND  Almmmatg.codmat = ITEM2.codmat  
                               NO-LOCK NO-ERROR.
                   
                 FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
                                AND  Almtconv.Codalter = ITEM2.CodUnd 
                               NO-LOCK NO-ERROR.
     
                 ITEM2.Factor = Almtconv.Equival / Almmmatg.FacEqu.
            END.
            ASSIGN
              ITEM2.CanVen = ITEM2.CanVen + Almdmov.CanDes * X-FACTOR.
       END.  
       /*******A***********/
    END.
    /*********B*********/
   END.  
  END.  
 END.
  /******C**********/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Stock V-table-Win 
PROCEDURE Procesa-Stock :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH ITEM2:
    RUN ALM\AlmStock.r(ITEM2.Codmat).
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "lg-liqcsg"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

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

  IF p-state = 'update-begin':U THEN RUN valida-update.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN ERROR.
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  IF p-state = 'update-begin':U THEN DO WITH FRAME {&FRAME-NAME}:
     L-CREA = NO.
     X-DEVMOV = lg-liqcsg.NroRf1.
     X-INGMOV = lg-liqcsg.NroRf2.  
     RUN Actualiza-ITEM.
     RUN Procesa-Handle IN lh_Handle ('Pagina2').
     RUN Procesa-Handle IN lh_Handle ('browse').
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE F-CANT AS DECIMAL NO-UNDO.
DEFINE VARIABLE L-ASIG AS LOGICAL NO-UNDO.
DEFINE VARIABLE X-SIG  AS LOGICAL  NO-UNDO.

DO WITH FRAME {&FRAME-NAME} :
     FIND gn-prov WHERE gn-prov.CodCia = PV-CODCIA  AND
          gn-prov.CodPro = lg-liqcsg.CodPro:SCREEN-VALUE NO-LOCK NO-ERROR.
     IF NOT AVAILABLE gn-prov THEN DO:
        MESSAGE "Codigo de Proveedor no Existe" VIEW-AS ALERT-BOX ERROR.
        APPLY "ENTRY" TO lg-liqcsg.CodPro.
        RETURN "ADM-ERROR".   
     END.
/*   
   IF string(lg-liqcsg.TpoCmb:SCREEN-VALUE,"Z9.9999") = "0.0000" THEN DO:
      MESSAGE "Ingrese el Tipo de Cambio " VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO lg-liqcsg.TpoCmb.
      RETURN "ADM-ERROR".
   END.
*/   
   
   F-CANT = 0. 
   L-ASIG = YES.
   X-SIG  = NO.
   
   FOR EACH ITEM2:
       F-CANT = F-CANT + 1.
       FIND Almmmate WHERE
            Almmmate.CodCia = S-CODCIA AND
            Almmmate.CodAlm = S-CODALM AND
            Almmmate.codmat = ITEM2.CodMat NO-LOCK NO-ERROR.
       IF NOT AVAILABLE Almmmate THEN DO:
          L-ASIG = NO.
          LEAVE.
       END.
       
       IF S-TIPO = "T" THEN DO :       
          IF ITEM2.CanDes <> ITEM2.CanVen - ITEM2.CanLiq THEN DO:
            MESSAGE "Articulo " ITEM2.Codmat SKIP
                    "Cantidad a Liquidar No Correcta Por ser una Liquidacion Total" SKIP
                    "Cantidad Liquidar = Cant.Vend - Cant.Liq = " SKIP
                    "                    Cant.Ingr - Cant.Dev - Cant.Liq " 
            VIEW-AS ALERT-BOX ERROR.
            X-SIG = YES.
            LEAVE.
          END.          
       END.
       
    END.   

   IF F-CANT = 0 THEN DO:
      MESSAGE "No existen ITEM2S por Liquidar" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO lg-liqcsg.Observ.
     RETURN "ADM-ERROR".   
   END.

   IF X-SIG THEN DO:
      APPLY "ENTRY" TO lg-liqcsg.Observ.
      RETURN "ADM-ERROR".   
   END.
 


END.



RETURN "OK".
END PROCEDURE.

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

