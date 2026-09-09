&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*------------------------------------------------------------------------

  File:  

  Description: from DATA.W - Template For SmartData objects in the ADM

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Modified:     February 24, 1999
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

/* Local Variable Definitions ---                                       */

&glob DATA-LOGIC-PROCEDURE .p

DEFINE SHARED VARIABLE s-codcia AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataObject
&Scoped-define DB-AWARE yes

&Scoped-define ADM-SUPPORTED-LINKS Data-Source,Data-Target,Navigation-Target,Update-Target,Commit-Target,Filter-Target


/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF


&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Almacen

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  CodCia CodAlm Descripcion
&Scoped-define ENABLED-FIELDS-IN-Almacen CodCia CodAlm Descripcion 
&Scoped-Define DATA-FIELDS  CodCia CodAlm Descripcion
&Scoped-define DATA-FIELDS-IN-Almacen CodCia CodAlm Descripcion 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "dalmacen_2.i"
&Scoped-Define DATA-TABLE-NO-UNDO NO-UNDO
&Scoped-define QUERY-STRING-Query-Main FOR EACH Almacen NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH Almacen NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main Almacen
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main Almacen


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      Almacen SCROLLING.
&ANALYZE-RESUME
{&DB-REQUIRED-END}


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataObject
   Allow: Query
   Frames: 0
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER DB-AWARE
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
  CREATE WINDOW dTables ASSIGN
         HEIGHT             = 1.62
         WIDTH              = 46.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB dTables 
/* ************************* Included-Libraries *********************** */

{src/adm2/data.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW dTables
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for SmartDataObject Query-Main
     _TblList          = "INTEGRAL.Almacen"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > INTEGRAL.Almacen.CodCia
"CodCia" "CodCia" ? ? "integer" ? ? ? ? ? ? yes ? no 3 yes ?
     _FldNameList[2]   > INTEGRAL.Almacen.CodAlm
"CodAlm" "CodAlm" ? "x(10)" "character" ? ? ? ? ? ? yes ? no 10 yes ?
     _FldNameList[3]   > INTEGRAL.Almacen.Descripcion
"Descripcion" "Descripcion" ? "X(100)" "character" ? ? ? ? ? ? yes ? no 100 yes ?
     _Design-Parent    is WINDOW dTables @ ( 1.15 , 2.57 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK dTables 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI dTables  _DEFAULT-DISABLE
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
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject dTables  _DB-REQUIRED
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
/* Declaración de la variable global compartida */

/*------------------------------------------------------------------------------
  Purpose: Filtrar automáticamente los registros por la compañía actual
------------------------------------------------------------------------------*/
  /* Seteamos el filtro dinámico ANTES de abrir la consulta */
  DYNAMIC-FUNCTION('setQueryWhere' IN THIS-PROCEDURE, 
      SUBSTITUTE("Almacen.CodCia = &1", s-codcia)).

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preTransactionValidate dTables  _DB-REQUIRED
PROCEDURE preTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  /*------------------------------------------------------------------------------
    Purpose: Validar que no se repita el código y forzar descripción a mayúsculas
  ------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cCodAlm AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowMod AS CHARACTER NO-UNDO.

  /* Obtenemos el buffer dinámico del RowObject */
  {get RowObjectBuffer hBuffer}.

  IF VALID-HANDLE(hBuffer) THEN DO:
      
      cRowMod = hBuffer:BUFFER-FIELD('RowMod'):BUFFER-VALUE.
      cCodAlm = hBuffer:BUFFER-FIELD('CodAlm'):BUFFER-VALUE.

      /* 1. Asignar la compañía global siempre */
      hBuffer:BUFFER-FIELD('CodCia'):BUFFER-VALUE = s-codcia.

      /* 2. Convertir la descripción siempre a MAYÚSCULAS */
      IF hBuffer:BUFFER-FIELD('DesAlm'):BUFFER-VALUE <> ? THEN
          hBuffer:BUFFER-FIELD('DesAlm'):BUFFER-VALUE = UPPER(hBuffer:BUFFER-FIELD('DesAlm'):BUFFER-VALUE).

      /* 3. Validar duplicidad de código de almacén (al crear nuevo registro) */
      IF cRowMod = 'A' OR cRowMod = 'C' THEN DO:
          
          /* Validar que no venga vacío */
          IF cCodAlm = "" OR cCodAlm = ? THEN
              RETURN "Debe ingresar el código de almacén.".

          /* Verificar existencia en la base de datos */
          IF CAN-FIND(FIRST Almacen NO-LOCK 
                        WHERE Almacen.CodCia = s-codcia 
                          AND Almacen.CodAlm = cCodAlm) THEN DO:
              RETURN SUBSTITUTE("El código de almacén '&1' ya se encuentra registrado.", cCodAlm).
          END.
      END.
  END.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

