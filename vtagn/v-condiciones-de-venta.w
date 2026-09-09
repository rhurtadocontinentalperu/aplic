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
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE s-codcia AS INT.
DEFINE SHARED VARIABLE s-user-id AS CHAR.

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
&Scoped-define EXTERNAL-TABLES gn-ConVt
&Scoped-define FIRST-EXTERNAL-TABLE gn-ConVt


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gn-ConVt.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gn-ConVt.Codig gn-ConVt.Estado gn-ConVt.Nombr ~
gn-ConVt.Vencmtos gn-ConVt.TotDias gn-ConVt.TipVta gn-ConVt.Libre_d01 ~
gn-ConVt.Libre_f01 gn-ConVt.Libre_l01 gn-ConVt.Libre_l02 gn-ConVt.Libre_l03 
&Scoped-define ENABLED-TABLES gn-ConVt
&Scoped-define FIRST-ENABLED-TABLE gn-ConVt
&Scoped-Define ENABLED-OBJECTS RECT-27 RECT-28 TOGGLE-fecha-vcto 
&Scoped-Define DISPLAYED-FIELDS gn-ConVt.Codig gn-ConVt.Estado ~
gn-ConVt.Nombr gn-ConVt.Vencmtos gn-ConVt.TotDias gn-ConVt.TipVta ~
gn-ConVt.Libre_d01 gn-ConVt.Libre_f01 gn-ConVt.Libre_l01 gn-ConVt.Libre_l02 ~
gn-ConVt.Libre_l03 
&Scoped-define DISPLAYED-TABLES gn-ConVt
&Scoped-define FIRST-DISPLAYED-TABLE gn-ConVt
&Scoped-Define DISPLAYED-OBJECTS TOGGLE-fecha-vcto 

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
DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 5.38.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 2.96.

DEFINE VARIABLE TOGGLE-fecha-vcto AS LOGICAL INITIAL no 
     LABEL "Sin fecha de Vcto" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .77
     FGCOLOR 4 FONT 6 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     gn-ConVt.Codig AT ROW 1.27 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .81
     gn-ConVt.Estado AT ROW 1.31 COL 23 NO-LABEL WIDGET-ID 6
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Activo", "A":U,
"Inactivo", "I":U
          SIZE 18 BY .69
     gn-ConVt.Nombr AT ROW 2.08 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
     gn-ConVt.Vencmtos AT ROW 2.88 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44.29 BY .81
     gn-ConVt.TotDias AT ROW 3.69 COL 14 COLON-ALIGNED FORMAT "ZZ9"
          VIEW-AS FILL-IN 
          SIZE 4 BY .81
     gn-ConVt.TipVta AT ROW 3.69 COL 24 NO-LABEL WIDGET-ID 2
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Contado", "1":U,
"Credito", "2":U,
"¿?", ""
          SIZE 30 BY .77
     gn-ConVt.Libre_d01 AT ROW 4.5 COL 14 COLON-ALIGNED WIDGET-ID 24
          LABEL "Cantidad de Letras" FORMAT "->>,>>9"
          VIEW-AS FILL-IN 
          SIZE 4 BY .81
     gn-ConVt.Libre_f01 AT ROW 5.31 COL 20 COLON-ALIGNED WIDGET-ID 18
          LABEL "Fecha Vcto FACTURACION"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     TOGGLE-fecha-vcto AT ROW 5.31 COL 33 WIDGET-ID 22
     gn-ConVt.Libre_l01 AT ROW 6.65 COL 11 WIDGET-ID 10
          LABEL "Acepta Fact. Interna (FAI)"
          VIEW-AS TOGGLE-BOX
          SIZE 25 BY .77
     gn-ConVt.Libre_l02 AT ROW 7.46 COL 11 WIDGET-ID 12
          LABEL "Condición de Venta Unica CAMPAÑA"
          VIEW-AS TOGGLE-BOX
          SIZE 29 BY .77
     gn-ConVt.Libre_l03 AT ROW 8.27 COL 11 WIDGET-ID 16
          LABEL "Anticipo de Campaña"
          VIEW-AS TOGGLE-BOX
          SIZE 23 BY .77
     "( Valida con Stock de Letras )" VIEW-AS TEXT
          SIZE 28 BY .5 AT ROW 4.77 COL 21 WIDGET-ID 26
          FGCOLOR 9 FONT 6
     RECT-27 AT ROW 1 COL 1 WIDGET-ID 30
     RECT-28 AT ROW 6.38 COL 1 WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.gn-ConVt
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
         HEIGHT             = 8.69
         WIDTH              = 71.72.
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

/* SETTINGS FOR FILL-IN gn-ConVt.Libre_d01 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-ConVt.Libre_f01 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX gn-ConVt.Libre_l01 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX gn-ConVt.Libre_l02 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX gn-ConVt.Libre_l03 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-ConVt.TotDias IN FRAME F-Main
   EXP-FORMAT                                                           */
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

&Scoped-define SELF-NAME gn-ConVt.Codig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-ConVt.Codig V-table-Win
ON LEAVE OF gn-ConVt.Codig IN FRAME F-Main /* Codigo */
DO:
   FIND gn-ConVt WHERE Gn-ConVt.Codig = gn-ConVt.Codig:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF AVAILABLE GN-CONVT THEN DO:
      message "Condición de venta YA EXISTE" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-fecha-vcto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-fecha-vcto V-table-Win
ON VALUE-CHANGED OF TOGGLE-fecha-vcto IN FRAME F-Main /* Sin fecha de Vcto */
DO:
    DEFINE VAR x-fecha-vcto AS CHAR.
    
    x-fecha-vcto = toggle-fecha-vcto:SCREEN-VALUE IN FRAME {&FRAME-NAME}.  

    IF x-fecha-vcto = 'yes' THEN DO:
        gn-convt.libre_f01:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "?".
        DISABLE gn-convt.libre_f01 WITH FRAME {&FRAME-NAME}.
    END.
    ELSE DO:
        ENABLE gn-convt.libre_f01 WITH FRAME {&FRAME-NAME}.
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
  {src/adm/template/row-list.i "gn-ConVt"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gn-ConVt"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  DEFINE VAR x-fecha-vcto AS CHAR.

  x-fecha-vcto = toggle-fecha-vcto:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN GET-ATTRIBUTE('ADM-NEW-RECORD').
  IF RETURN-VALUE = "YES" THEN DO:
      gn-ConVt.FchCreacion = TODAY.
      gn-ConVt.UsrCreacion = s-user-id.
  END.
  ELSE DO:
      gn-ConVt.FchModificacion = TODAY.
      gn-ConVt.UsrModificacion = s-user-id.
  END.
  IF x-fecha-vcto = 'yes' THEN gn-ConVt.libre_f01 = ?.

  CREATE LogTabla.
  ASSIGN
    logtabla.codcia = s-codcia
    logtabla.Dia = TODAY
    logtabla.Evento = 'WRITE'
    logtabla.Hora = STRING(TIME, 'HH:MM')
    logtabla.Tabla = 'GN-CONVT'
    logtabla.Usuario = USERID("DICTDB")
    logtabla.ValorLlave = TRIM(gn-convt.codig) + '|' +
                            "CANT.LETRA :" + STRING(gn-convt.libre_d01) + '|' +
                            "COND.UNICA CAMPAÑA :" + STRING(gn-convt.libre_l02) + '|' +
                            "FAI :" + STRING(gn-convt.libre_l01) + '|' +
                            "ANTIC.CAMPAÑA :" + STRING(gn-convt.libre_l03).
                            .
 RELEASE LogTabla. 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF CAN-FIND(FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia
              AND ccbcdocu.fmapgo = gn-ConVt.Codig NO-LOCK) THEN DO:
      MESSAGE "NO se puede anular un código en uso" VIEW-AS ALERT-BOX ERROR.
      RETURN "ADM-ERROR".
  END.
  /* RHC 16/07/2021 Se anulan los descuentos relacionados */
  IF AVAILABLE gn-convt THEN DO:
      FOR EACH dsctos EXCLUSIVE-LOCK WHERE Dsctos.CndVta = gn-ConVt.Codig:
          DELETE dsctos.
      END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /*ENABLED toggle-fecha-vcto IN FRAME {&FRAME-NAME}.*/
  DISABLE toggle-fecha-vcto WITH FRAME {&FRAME-NAME}.
  RUN Procesa-Handle IN lh_handle ('enable-query').
  RUN Procesa-Handle IN lh_handle ('enable-browse').

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
    IF AVAIL gn-ConVt THEN DO:
/*     IF gn-ConVt.TipVta = "1" THEN FILL-IN-1:SCREEN-VALUE = "Contado". */
/*     ELSE FILL-IN-1:SCREEN-VALUE = "".                                 */
       IF gn-convt.libre_f01 = ? THEN DO:
           toggle-fecha-vcto:SCREEN-VALUE = 'yes'.
       END.
       ELSE DO:
           toggle-fecha-vcto:SCREEN-VALUE = 'no'.
       END.

       DISABLE toggle-fecha-vcto.
    END.    
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  ENABLE toggle-fecha-vcto WITH FRAME {&FRAME-NAME}.
  IF gn-convt.libre_f01 = ? THEN DO:
      DISABLE gn-convt.libre_f01 WITH FRAME {&FRAME-NAME}.
  END.
  ELSE DO:
      ENABLE gn-convt.libre_f01 WITH FRAME {&FRAME-NAME}.
  END.
  RUN Procesa-Handle IN lh_handle ('disable-query').
  RUN Procesa-Handle IN lh_handle ('disable-browse').

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
  {src/adm/template/snd-list.i "gn-ConVt"}

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

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.
 
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  
  integral.gn-ConVt.Codig:sensitive in frame {&FRAME-NAME} = no.
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

DEF VAR k AS INT.
DEF VAR j AS INT.

DEFINE VAR x-cuantas-letras AS INT.

DO WITH FRAME {&FRAME-NAME} :

    x-cuantas-letras = INTEGER(gn-ConVt.libre_d01:SCREEN-VALUE).

   IF gn-ConVt.Codig:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Codigo no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO gn-ConVt.Codig.
      RETURN "ADM-ERROR".   
   END.

   IF gn-ConVt.Nombr:SCREEN-VALUE = "" THEN DO:
      MESSAGE "Descripcion no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO gn-ConVt.Nombr.
      RETURN "ADM-ERROR".   
   END.

   IF NOT (gn-convt.tipvta:SCREEN-VALUE = '1' OR gn-convt.tipvta:SCREEN-VALUE = '2') THEN DO:
       MESSAGE "Debe elegir CONTADO o CREDITO" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO gn-ConVt.tipvta.
       RETURN "ADM-ERROR".   
   END.

   IF x-cuantas-letras < 0 THEN DO:
       MESSAGE "Cantidad de Letras esta errado" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO gn-ConVt.libre_d01.
       RETURN "ADM-ERROR".   
   END.

   /*IF gn-ConVt.Vencmtos:SCREEN-VALUE = "" THEN DO:*/
   IF TRUE <> (gn-convt.vencmtos:SCREEN-VALUE > "") THEN DO:
      MESSAGE "Vencimientos no debe ser blanco" VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO gn-ConVt.Vencmtos.
      RETURN "ADM-ERROR".   
   END.

   DEFINE VAR x-anterior AS INT.
   x-anterior = 0.

    DO k = 1 TO NUM-ENTRIES(gn-ConVt.Vencmtos:SCREEN-VALUE):
        ASSIGN
            j = INTEGER( ENTRY(k, gn-ConVt.Vencmtos:SCREEN-VALUE) ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR (j <= 0 AND gn-convt.tipvta:SCREEN-VALUE = '2') THEN DO:
            MESSAGE 'Error al ingresar los vencimientos' SKIP
                'Debe ser solo números separados por comas y mayores a cero' SKIP
                'Ejemplo: 30,40,60'
                VIEW-AS ALERT-BOX ERROR.
            APPLY "ENTRY" TO gn-ConVt.Vencmtos.
            RETURN "ADM-ERROR".   
        END.
        /* Solo para creditos */
        IF gn-convt.tipvta:SCREEN-VALUE = '2' THEN DO:
            IF j <= x-anterior THEN DO:
                MESSAGE 'Error al ingresar los vencimientos' SKIP
                    'Debe ser solo números separados por comas y de forma ascendente' SKIP
                    'Ejemplo: 30,40,60'
                    VIEW-AS ALERT-BOX ERROR.
                APPLY "ENTRY" TO gn-ConVt.Vencmtos.
                RETURN "ADM-ERROR".   
            END.
            x-anterior = j.
        END.
    END.

END.

RETURN "OK".
END PROCEDURE.

/*
        IF gn-convt.tipvta = '1' OR gn-convt.tipvta = '2' THEN DO:
            IF gn-convt.tipvta = '1' THEN DO:
                x-tipo-venta = "CONTADO".
            END.
            ELSE DO:
                IF TRUE <> (gn-convt.vencmtos > "") THEN DO:
                    pRetVal = b-ccbcdocu.fmapgo + " - Vencimientos de Cuotas no existe".
                    RETURN "ADM-ERROR".
                END.
                /* Cuotas */                
                x-vcmtos = TRIM(gn-convt.vencmtos).
                x-cuotas = NUM-ENTRIES(x-vcmtos,",").
                x-cuota-anterior = 0.
                x-suma-factores = 0.
                REPEAT x-sec = 1 TO x-cuotas:
                    IF TRUE <> (ENTRY(x-sec,x-vcmtos,",") > "") THEN DO:
                        pRetVal = b-ccbcdocu.fmapgo + " - Vencimientos de Cuota " + STRING(x-sec) + " esta errado".
                        RETURN "ADM-ERROR".
                    END.
                    x-cuota-actual = INTEGER(TRIM(ENTRY(x-sec,x-vcmtos,","))) NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN DO:
                        pRetVal = b-ccbcdocu.fmapgo + " - Vencimientos de Cuota " + STRING(x-sec) + " debe ser valor numerico".
                        RETURN "ADM-ERROR".
                    END.
                    IF x-cuota-actual <= 0 THEN DO:
                        pRetVal = b-ccbcdocu.fmapgo + " - Vencimientos de Cuota " + STRING(x-sec) + " debe ser mayor que CERO".
                        RETURN "ADM-ERROR".
                    END.
                    IF x-cuota-actual <= 0 THEN DO:
                        pRetVal = b-ccbcdocu.fmapgo + " - Vencimientos de Cuota " + STRING(x-sec) + " debe ser mayor que CERO".
                        RETURN "ADM-ERROR".
                    END.
                    IF x-cuota-actual <= x-cuota-anterior THEN DO:
                        pRetVal = b-ccbcdocu.fmapgo + " - Vencimientos de Cuota " + STRING(x-sec) + " debe ser mayor a la cuota anterior".
                        RETURN "ADM-ERROR".
                    END.
                    /* Cargo los valores */
                    IF x-cuotas = 1 THEN DO:
                        x-cuotas-factor[x-sec] = 100.
                    END.
                    ELSE DO:
                        IF x-sec = x-cuotas THEN DO:
                            x-cuotas-factor[x-sec] = 100 - x-suma-factores.
                        END.
                        ELSE DO:
                            x-cuotas-factor[x-sec] = 100 / x-cuotas.
                            x-suma-factores = x-suma-factores + 100 / x-cuotas.
                        END.
                    END.
                    x-tipo-venta = "CREDITO".
                    x-cuotas-vcto[x-sec] = b-ccbcdocu.fchdoc + x-cuota-actual.
                    x-cuota-anterior = x-cuota-actual.
                END.
            END.            
        END.
        ELSE DO:
            pRetVal = b-ccbcdocu.fmapgo + " - CONDICION NO INDICA SI LA VENTA 'CREDITO o CONTADO'".
        END.

*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update V-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     Rutina de validacion en caso de modificacion
  Parameters:  Regresar "ADM-ERROR" si no se quiere modificar
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE Gn-ConVt THEN RETURN "ADM-ERROR".
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

