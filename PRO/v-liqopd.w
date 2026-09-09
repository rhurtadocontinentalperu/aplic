&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-USER-ID AS CHAR. 
DEFINE SHARED VAR S-CODALM  AS CHAR.
DEFINE SHARED VAR S-DESALM  AS CHAR.


DEFINE BUFFER B-LIQC FOR PR-LIQC.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES PR-LIQC
&Scoped-define FIRST-EXTERNAL-TABLE PR-LIQC


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR PR-LIQC.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS PR-LIQC.Numliq PR-LIQC.codart PR-LIQC.CodFor ~
PR-LIQC.CtoMat PR-LIQC.CtoHor PR-LIQC.CtoGas PR-LIQC.CtoFab PR-LIQC.Ctotot ~
PR-LIQC.CodUnd PR-LIQC.NumOrd PR-LIQC.Factor PR-LIQC.FecIni PR-LIQC.FecFin ~
PR-LIQC.CanFin PR-LIQC.PreUni PR-LIQC.CodMon PR-LIQC.FchLiq PR-LIQC.FchCie ~
PR-LIQC.TpoCmb PR-LIQC.Usuario 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}Numliq ~{&FP2}Numliq ~{&FP3}~
 ~{&FP1}codart ~{&FP2}codart ~{&FP3}~
 ~{&FP1}CodFor ~{&FP2}CodFor ~{&FP3}~
 ~{&FP1}CtoMat ~{&FP2}CtoMat ~{&FP3}~
 ~{&FP1}CtoHor ~{&FP2}CtoHor ~{&FP3}~
 ~{&FP1}CtoGas ~{&FP2}CtoGas ~{&FP3}~
 ~{&FP1}CtoFab ~{&FP2}CtoFab ~{&FP3}~
 ~{&FP1}Ctotot ~{&FP2}Ctotot ~{&FP3}~
 ~{&FP1}CodUnd ~{&FP2}CodUnd ~{&FP3}~
 ~{&FP1}NumOrd ~{&FP2}NumOrd ~{&FP3}~
 ~{&FP1}Factor ~{&FP2}Factor ~{&FP3}~
 ~{&FP1}FecIni ~{&FP2}FecIni ~{&FP3}~
 ~{&FP1}FecFin ~{&FP2}FecFin ~{&FP3}~
 ~{&FP1}CanFin ~{&FP2}CanFin ~{&FP3}~
 ~{&FP1}PreUni ~{&FP2}PreUni ~{&FP3}~
 ~{&FP1}FchLiq ~{&FP2}FchLiq ~{&FP3}~
 ~{&FP1}FchCie ~{&FP2}FchCie ~{&FP3}~
 ~{&FP1}TpoCmb ~{&FP2}TpoCmb ~{&FP3}~
 ~{&FP1}Usuario ~{&FP2}Usuario ~{&FP3}
&Scoped-define ENABLED-TABLES PR-LIQC
&Scoped-define FIRST-ENABLED-TABLE PR-LIQC
&Scoped-Define ENABLED-OBJECTS RECT-24 RECT-25 
&Scoped-Define DISPLAYED-FIELDS PR-LIQC.Numliq PR-LIQC.codart ~
PR-LIQC.CodFor PR-LIQC.CtoMat PR-LIQC.CtoHor PR-LIQC.CtoGas PR-LIQC.CtoFab ~
PR-LIQC.Ctotot PR-LIQC.CodUnd PR-LIQC.NumOrd PR-LIQC.Factor PR-LIQC.FecIni ~
PR-LIQC.FecFin PR-LIQC.CanFin PR-LIQC.PreUni PR-LIQC.CodMon PR-LIQC.FchLiq ~
PR-LIQC.FchCie PR-LIQC.TpoCmb PR-LIQC.Usuario 
&Scoped-Define DISPLAYED-OBJECTS F-Desart F-ESTADO 

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
DEFINE VARIABLE F-Desart AS CHARACTER FORMAT "X(45)":U 
     VIEW-AS FILL-IN 
     SIZE 47.29 BY .69
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE F-ESTADO AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14.57 BY .69
     FONT 0 NO-UNDO.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 93.14 BY 6.31.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 18.14 BY .96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     PR-LIQC.Numliq AT ROW 1.23 COL 9.57 COLON-ALIGNED
          LABEL "Liquidacion"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
          BGCOLOR 15 
     PR-LIQC.codart AT ROW 1.96 COL 9.57 COLON-ALIGNED
          LABEL "Articulo"
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .69
          BGCOLOR 15 
     PR-LIQC.CodFor AT ROW 2.73 COL 9.57 COLON-ALIGNED
          LABEL "Formula"
          VIEW-AS FILL-IN 
          SIZE 4.43 BY .69
          BGCOLOR 15 
     PR-LIQC.CtoMat AT ROW 3.54 COL 21.29 RIGHT-ALIGNED
          LABEL "Materiales"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
          BGCOLOR 15 FGCOLOR 1 
     PR-LIQC.CtoHor AT ROW 4.31 COL 21.29 RIGHT-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
          BGCOLOR 15 FGCOLOR 1 
     PR-LIQC.CtoGas AT ROW 5 COL 21.29 RIGHT-ALIGNED
          LABEL "Servicios"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
          BGCOLOR 15 FGCOLOR 1 
     PR-LIQC.CtoFab AT ROW 5.69 COL 9.57 COLON-ALIGNED
          LABEL "Fabricacion"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
          BGCOLOR 15 FGCOLOR 1 
     PR-LIQC.Ctotot AT ROW 6.46 COL 26.29 RIGHT-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .69
          BGCOLOR 15 FGCOLOR 1 
     F-Desart AT ROW 1.96 COL 19.14 COLON-ALIGNED NO-LABEL
     PR-LIQC.CodUnd AT ROW 2.73 COL 19.72 COLON-ALIGNED
          LABEL "U.M"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
          BGCOLOR 15 
     PR-LIQC.NumOrd AT ROW 1.19 COL 37.72 COLON-ALIGNED
          LABEL "Orden Produccion"
          VIEW-AS FILL-IN 
          SIZE 9.86 BY .69
          BGCOLOR 15 
     PR-LIQC.Factor AT ROW 5.69 COL 35.29 COLON-ALIGNED
          LABEL "Factor/Fabricacion"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .69
          BGCOLOR 15 FGCOLOR 1 
     PR-LIQC.FecIni AT ROW 2.77 COL 56.14 COLON-ALIGNED
          LABEL "Del"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
          BGCOLOR 15 
     PR-LIQC.FecFin AT ROW 3.58 COL 56.14 COLON-ALIGNED
          LABEL "A"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
          BGCOLOR 15 
     PR-LIQC.CanFin AT ROW 4.96 COL 67.86 RIGHT-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .69
          BGCOLOR 15 FGCOLOR 1 
     PR-LIQC.PreUni AT ROW 5.69 COL 67.86 RIGHT-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.29 BY .69
          BGCOLOR 15 FGCOLOR 1 
     F-ESTADO AT ROW 1.23 COL 76.43 COLON-ALIGNED NO-LABEL
     PR-LIQC.CodMon AT ROW 3.77 COL 76.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"Dolares", 2
          SIZE 16.43 BY .69
     PR-LIQC.FchLiq AT ROW 2.04 COL 81 COLON-ALIGNED
          LABEL "Fecha Liquidacion"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
          BGCOLOR 15 
     PR-LIQC.FchCie AT ROW 2.81 COL 81.29 COLON-ALIGNED
          LABEL "Fecha Cierre"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
          BGCOLOR 15 
     PR-LIQC.TpoCmb AT ROW 5 COL 82.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     PR-LIQC.Usuario AT ROW 5.77 COL 81.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
          BGCOLOR 15 FGCOLOR 1 
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     RECT-24 AT ROW 1.04 COL 1.14
     RECT-25 AT ROW 3.62 COL 75.29
     "Periodo Liquidado" VIEW-AS TEXT
          SIZE 14.43 BY .5 AT ROW 3.38 COL 40.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.PR-LIQC
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
         HEIGHT             = 6.5
         WIDTH              = 93.29.
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

/* SETTINGS FOR FILL-IN PR-LIQC.CanFin IN FRAME F-Main
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN PR-LIQC.codart IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PR-LIQC.CodFor IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PR-LIQC.CodUnd IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PR-LIQC.CtoFab IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PR-LIQC.CtoGas IN FRAME F-Main
   ALIGN-R EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN PR-LIQC.CtoHor IN FRAME F-Main
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN PR-LIQC.CtoMat IN FRAME F-Main
   ALIGN-R EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN PR-LIQC.Ctotot IN FRAME F-Main
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN F-Desart IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ESTADO IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN PR-LIQC.Factor IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PR-LIQC.FchCie IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PR-LIQC.FchLiq IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PR-LIQC.FecFin IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PR-LIQC.FecIni IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PR-LIQC.Numliq IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PR-LIQC.NumOrd IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN PR-LIQC.PreUni IN FRAME F-Main
   ALIGN-R                                                              */
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

{src/adm-vm/method/vmviewer.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualizar-Costos V-table-Win 
PROCEDURE Actualizar-Costos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR F-INGRESO AS CHAR INIT "50".
DEFINE VAR I AS INTEGER.

IF NOT AVAILABLE PR-LIQC OR PR-LIQC.FlgEst = "A" THEN RETURN.


MESSAGE "Se actualizará el Costo de todos" SKIP
        "los Ingresos de Producto Terminado" SKIP
        "Esta Seguro de realizar la operacion"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE X-OK AS LOGICAL.

IF NOT X-OK THEN RETURN.

   
DO:
    FIND PR-ODPC WHERE PR-ODPC.Codcia = PR-LIQC.Codcia AND
                       PR-ODPC.NumOrd = PR-LIQC.NumOrd
                       NO-LOCK NO-ERROR.
    IF AVAILABLE PR-ODPC THEN DO:                   
        DO I = 1 TO NUM-ENTRIES(F-Ingreso):
          FOR EACH Almcmov WHERE Almcmov.Codcia = S-CODCIA AND
                                 Almcmov.CodAlm = PR-ODPC.CodAlm AND
                                 Almcmov.TipMov = "I" AND
                                 Almcmov.Codmov = INTEGER(ENTRY(I,F-Ingreso)) AND
                                 Almcmov.CodRef = "OP" AND
                                 Almcmov.Nroref = PR-ODPC.NumOrd:                              
           Almcmov.ImpMn1 = 0.
           Almcmov.ImpMn2 = 0.
           Almcmov.CodMon = 1.
           
           FOR EACH Almdmov OF Almcmov:
              IF Almdmov.CodMat = PR-LIQC.CodArt THEN DO:
                ASSIGN
                Almdmov.Codmon = Almcmov.CodMon
                Almdmov.ImpCto = PR-LIQC.PreUni * Almdmov.CanDes
                Almdmov.PreLis = PR-LIQC.PreUni
                Almdmov.PreUni = PR-LIQC.PreUni
                Almdmov.Dsctos[1] = 0
                Almdmov.Dsctos[2] = 0
                Almdmov.Dsctos[3] = 0           
                Almdmov.ImpMn1    = PR-LIQC.PreUni * Almdmov.CanDes
                Almdmov.ImpMn2    = PR-LIQC.PreUni * Almdmov.CanDes / Almcmov.TpoCmb.              
  
                IF Almcmov.codmon = 1 THEN DO:
                   Almcmov.ImpMn1 = Almcmov.ImpMn1 + Almdmov.ImpMn1.
                END.
                ELSE DO:
                   Almcmov.ImpMn2 = Almcmov.ImpMn2 + Almdmov.ImpMn2.
                END.        
              END.
           END.        
           
          END.
        END.  
    END.
END.

MESSAGE "Costos Actualizados "
         VIEW-AS ALERT-BOX INFORMATION TITLE "Proceso Concluido".  

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "PR-LIQC"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "PR-LIQC"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
   RETURN "ADM-ERROR".
   
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

 RUN Valida-Update.
 IF RETURN-VALUE = "ADM-ERROR" THEN  RETURN ERROR.

 DO:
    IF AVAILABLE PR-LIQC THEN DO:
       
       /******Actualiza Horas X Orden**********/
       FOR EACH PR-MOV-MES WHERE PR-MOV-MES.CodCia = PR-LIQC.Codcia  AND  
                                 PR-MOV-MES.NumOrd = PR-LIQC.NumOrd  AND
                                 PR-MOV-MES.FchReg >= PR-LIQC.FECINI  AND  
                                 PR-MOV-MES.FchReg <= PR-LIQC.FECFIN:
          PR-MOV-MES.Numliq = "".
       END.  
       /*****************************************/

       FOR EACH PR-LIQD1 OF PR-LIQC:
           DELETE PR-LIQD1.
       END.
       FOR EACH PR-LIQD2 OF PR-LIQC:
           DELETE PR-LIQD2.
       END.
       FOR EACH PR-LIQD3 OF PR-LIQC:
           DELETE PR-LIQD3.
       END.
       FOR EACH PR-LIQD4 OF PR-LIQC:
           DELETE PR-LIQD4.
       END.

       FIND B-LIQC WHERE B-LIQC.Codcia = PR-LIQC.Codcia AND
                         B-LIQC.NumLiq = PR-LIQC.NumLiq
                         EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE B-LIQC THEN DO:                  
          ASSIGN
          B-LIQC.Usuario = S-USER-ID
          B-LIQC.FlgEst = "A" .
       END.

       
    END.
 
 END.

 RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
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
  DO WITH FRAME {&FRAME-NAME}:
    IF AVAILABLE PR-LIQC THEN DO:
       FIND Almmmatg WHERE Almmmatg.Codcia = PR-LIQC.Codcia AND
                           Almmmatg.CodMat = PR-LIQC.CodArt
                           NO-LOCK NO-ERROR.
       IF AVAILABLE Almmmatg THEN DO:
          DISPLAY Almmmatg.DesMat @ F-Desart.
       END.   
       IF PR-LIQC.FlgEst  = "A" THEN F-Estado:SCREEN-VALUE = "ANULADO ".
       IF PR-LIQC.FlgEst  = " " THEN F-Estado:SCREEN-VALUE = "        ".
                         
    END.
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF AVAILABLE PR-LIQC AND 
     PR-LIQC.FlgEst <> "A" THEN RUN PRO\R-IMPLIQOP.R(ROWID(PR-LIQC)).

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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "PR-LIQC"}

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
  RETURN "ADM-ERROR".
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     Validacion de datos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME} :
   /* IF CAMPO:SCREEN-VALUE = "" THEN DO:
         MESSAGE "Campo no debe ser blanco"
         VIEW-AS ALERT-BOX ERROR.
         APPLY "ENTRY" TO CAMPO.
         RETURN "ADM-ERROR".   
   
      END.
   */

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

IF NOT AVAILABLE PR-LIQC THEN DO:
   MESSAGE "No existe registros" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.

IF PR-LIQC.FlgEst = 'A' THEN DO:
   MESSAGE "Liquidacion Anulado" VIEW-AS ALERT-BOX ERROR.
   RETURN "ADM-ERROR".
END.

    RUN alm/p-ciealm-01 (PR-LIQC.FchLiq, s-CodAlm).
    IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN "ADM-ERROR".

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


