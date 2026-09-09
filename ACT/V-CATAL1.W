&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          integral          PROGRESS
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

DEFINE SHARED VAR s-CodCia AS INTEGER.

DEFINE VAR P-LISTA AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES AC-PARTI
&Scoped-define FIRST-EXTERNAL-TABLE AC-PARTI


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR AC-PARTI.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS AC-PARTI.CodFam AC-PARTI.Codcta ~
AC-PARTI.CodPar AC-PARTI.Ccosto AC-PARTI.ValCmpMn1 AC-PARTI.ValCmpMn2 ~
AC-PARTI.Marca AC-PARTI.Serie AC-PARTI.CodPro AC-PARTI.DesPar ~
AC-PARTI.CodDiv AC-PARTI.FchComp AC-PARTI.ubicacion AC-PARTI.CodMov ~
AC-PARTI.NroFacCmp AC-PARTI.Modelo AC-PARTI.MonCmp AC-PARTI.FchIngr 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}CodFam ~{&FP2}CodFam ~{&FP3}~
 ~{&FP1}Codcta ~{&FP2}Codcta ~{&FP3}~
 ~{&FP1}CodPar ~{&FP2}CodPar ~{&FP3}~
 ~{&FP1}Ccosto ~{&FP2}Ccosto ~{&FP3}~
 ~{&FP1}ValCmpMn1 ~{&FP2}ValCmpMn1 ~{&FP3}~
 ~{&FP1}ValCmpMn2 ~{&FP2}ValCmpMn2 ~{&FP3}~
 ~{&FP1}Marca ~{&FP2}Marca ~{&FP3}~
 ~{&FP1}Serie ~{&FP2}Serie ~{&FP3}~
 ~{&FP1}CodPro ~{&FP2}CodPro ~{&FP3}~
 ~{&FP1}DesPar ~{&FP2}DesPar ~{&FP3}~
 ~{&FP1}CodDiv ~{&FP2}CodDiv ~{&FP3}~
 ~{&FP1}FchComp ~{&FP2}FchComp ~{&FP3}~
 ~{&FP1}CodMov ~{&FP2}CodMov ~{&FP3}~
 ~{&FP1}NroFacCmp ~{&FP2}NroFacCmp ~{&FP3}~
 ~{&FP1}Modelo ~{&FP2}Modelo ~{&FP3}~
 ~{&FP1}FchIngr ~{&FP2}FchIngr ~{&FP3}
&Scoped-define ENABLED-TABLES AC-PARTI
&Scoped-define FIRST-ENABLED-TABLE AC-PARTI
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-2 
&Scoped-Define DISPLAYED-FIELDS AC-PARTI.CodFam AC-PARTI.Codcta ~
AC-PARTI.CodPar AC-PARTI.Ccosto AC-PARTI.ValCmpMn1 AC-PARTI.ValCmpMn2 ~
AC-PARTI.Marca AC-PARTI.Serie AC-PARTI.CodPro AC-PARTI.DesPar ~
AC-PARTI.CodDiv AC-PARTI.FchComp AC-PARTI.ubicacion AC-PARTI.CodMov ~
AC-PARTI.NroFacCmp AC-PARTI.Modelo AC-PARTI.MonCmp AC-PARTI.FchIngr 
&Scoped-Define DISPLAYED-OBJECTS F-DesCta F-NomPro 

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
DEFINE VARIABLE F-DesCta AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 55.72 BY .69
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE F-NomPro AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 75 BY 6.15.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 75 BY 4.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     AC-PARTI.CodFam AT ROW 1.38 COL 6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .69
     AC-PARTI.Codcta AT ROW 2.35 COL 6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .69
     AC-PARTI.CodPar AT ROW 3.31 COL 6 COLON-ALIGNED FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
     AC-PARTI.Ccosto AT ROW 4.27 COL 13.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .69
     AC-PARTI.ValCmpMn1 AT ROW 6.96 COL 9.72 COLON-ALIGNED
          LABEL "Compra S/." FORMAT "-z,zzz,zz9.99"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
     AC-PARTI.ValCmpMn2 AT ROW 7.73 COL 9.72 COLON-ALIGNED
          LABEL "Compra US$" FORMAT "-z,zzz,zz9.99"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
     AC-PARTI.Marca AT ROW 8.5 COL 6.58
          VIEW-AS FILL-IN 
          SIZE 25.72 BY .69
     AC-PARTI.Serie AT ROW 9.46 COL 9.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25 BY .69
     AC-PARTI.CodPro AT ROW 10.42 COL 9.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.29 BY .69
     F-DesCta AT ROW 2.35 COL 14.57 COLON-ALIGNED NO-LABEL
     AC-PARTI.DesPar AT ROW 3.31 COL 16.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 53.57 BY .69
          FGCOLOR 4 
     AC-PARTI.CodDiv AT ROW 1.38 COL 21.72 COLON-ALIGNED
          LABEL "Division"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .69
     F-NomPro AT ROW 10.42 COL 19 COLON-ALIGNED NO-LABEL
     AC-PARTI.FchComp AT ROW 5.81 COL 27.57 COLON-ALIGNED FORMAT "99/99/9999"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     AC-PARTI.ubicacion AT ROW 4.27 COL 24.28
          LABEL "Ubicaci¢n"
          VIEW-AS COMBO-BOX SORT 
          LIST-ITEMS " "
          SIZE 40.72 BY .88
     AC-PARTI.CodMov AT ROW 1.38 COL 37.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .69
     AC-PARTI.NroFacCmp AT ROW 6.96 COL 39.72 COLON-ALIGNED FORMAT "X(10)"
          VIEW-AS FILL-IN 
          SIZE 10.72 BY .69
     AC-PARTI.Modelo AT ROW 8.5 COL 40.86
          VIEW-AS FILL-IN 
          SIZE 25 BY .69
     AC-PARTI.MonCmp AT ROW 5.81 COL 51.72 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Soles", 1,
"D¢lares", 2
          SIZE 19.29 BY .69
     AC-PARTI.FchIngr AT ROW 1.38 COL 60.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     RECT-3 AT ROW 1 COL 1
     RECT-2 AT ROW 5.42 COL 1
     "Compra" VIEW-AS TEXT
          SIZE 9.29 BY .81 AT ROW 5.81 COL 3.14
          FONT 0
     "Moneda" VIEW-AS TEXT
          SIZE 7.14 BY .69 AT ROW 5.81 COL 44.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.AC-PARTI
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
         HEIGHT             = 10.58
         WIDTH              = 75.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Default                                      */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN AC-PARTI.CodDiv IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN AC-PARTI.CodPar IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN F-DesCta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN AC-PARTI.FchComp IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN AC-PARTI.Marca IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN AC-PARTI.Modelo IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN AC-PARTI.NroFacCmp IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR Combo-Box AC-PARTI.ubicacion IN FRAME F-Main
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN AC-PARTI.ValCmpMn1 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN AC-PARTI.ValCmpMn2 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
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




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME AC-PARTI.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL AC-PARTI.CodPro V-table-Win
ON LEAVE OF AC-PARTI.CodPro IN FRAME F-Main /* Proveedor */
DO:
  FIND GN-PROV WHERE GN-PROV.CodPro = AC-PARTI.CodPro:SCREEN-VALUE 
       NO-LOCK NO-ERROR.
  IF AVAILABLE GN-PRO THEN DO :
     F-NomPro:SCREEN-VALUE = GN-PRO.NomPro.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  P-LISTA = "Ninguno,".
  
  FOR EACH integral.AC-TABL NO-LOCK WHERE integral.AC-TABL.cTabla = "UBIC" :
      P-LISTA = P-LISTA + TRIM ( integral.AC-TABL.cDescri ) + ",".
  END.
  
  P-LISTA = SUBSTRING ( P-LISTA , 1, LENGTH(P-LISTA) - 1 ).
  
  integral.AC-PARTI.Ubicacion:LIST-ITEMS = P-LISTA.

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "AC-PARTI"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "AC-PARTI"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  AC-PARTI.CodCia = s-codCia.
  
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  
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
  
  IF AVAILABLE AC-PART THEN DO :
     DO WITH FRAME {&FRAME-NAME} :
        /* CUENTA */
        FIND CB-CTAS WHERE CB-CTAS.CodCta = AC-PARTI.Codcta:SCREEN-VALUE 
             NO-LOCK NO-ERROR.
        IF AVAILABLE CB-CTAS THEN DO :
           F-DesCta:SCREEN-VALUE = cb-ctas.Nomcta.
        END.       
        /* PROVEEDOR */
        FIND GN-PROV WHERE GN-PROV.CodPro = AC-PARTI.CodPro:SCREEN-VALUE 
             NO-LOCK NO-ERROR.
        IF AVAILABLE GN-PRO THEN DO :
           F-NomPro:SCREEN-VALUE = GN-PRO.NomPro.
        END.       
     END.
  END.
  
  
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
  {src/adm/template/snd-list.i "AC-PARTI"}

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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


