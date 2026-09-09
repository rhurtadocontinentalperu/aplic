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
DEF SHARED VAR s-codcia AS INTE.

/* Local Variable Definitions ---                                       */



DEF VAR s-adm-new-record AS CHAR INIT 'NO' NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Global-define DATA-LOGIC-PROCEDURE .p

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
&Scoped-Define ENABLED-FIELDS  CodAlm Descripcion AutMov TdoArt CorrIng CorrSal Clave flgrep CodCia AlmCsg~
 Campo-C1 Campo-C2 Campo-C3 Campo-C4 Campo-C5 Campo-C6 Campo-C7 Campo-C8~
 Campo-C9 Campo-C10 CodCli CodDiv DirAlm EncAlm HorRec TelAlm TpoCsg~
 Campo-Log1
&Scoped-define ENABLED-FIELDS-IN-Almacen CodAlm Descripcion AutMov TdoArt ~
CorrIng CorrSal Clave flgrep CodCia AlmCsg Campo-C1 Campo-C2 Campo-C3 ~
Campo-C4 Campo-C5 Campo-C6 Campo-C7 Campo-C8 Campo-C9 Campo-C10 CodCli ~
CodDiv DirAlm EncAlm HorRec TelAlm TpoCsg Campo-Log1 
&Scoped-Define DATA-FIELDS  CodAlm Descripcion AutMov TdoArt CorrIng CorrSal Clave flgrep CodCia AlmCsg~
 Campo-C1 Campo-C2 Campo-C3 Campo-C4 Campo-C5 Campo-C6 Campo-C7 Campo-C8~
 Campo-C9 Campo-C10 CodCli CodDiv DirAlm EncAlm HorRec TelAlm TpoCsg~
 Campo-Log1
&Scoped-define DATA-FIELDS-IN-Almacen CodAlm Descripcion AutMov TdoArt ~
CorrIng CorrSal Clave flgrep CodCia AlmCsg Campo-C1 Campo-C2 Campo-C3 ~
Campo-C4 Campo-C5 Campo-C6 Campo-C7 Campo-C8 Campo-C9 Campo-C10 CodCli ~
CodDiv DirAlm EncAlm HorRec TelAlm TpoCsg Campo-Log1 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST   rowObject.Campo-C1 = Almacen.Campo-C[1]~
  rowObject.Campo-C2 = Almacen.Campo-C[2]~
  rowObject.Campo-C3 = Almacen.Campo-C[3]~
  rowObject.Campo-C4 = Almacen.Campo-C[4]~
  rowObject.Campo-C5 = Almacen.Campo-C[5]~
  rowObject.Campo-C6 = Almacen.Campo-C[6]~
  rowObject.Campo-C7 = Almacen.Campo-C[7]~
  rowObject.Campo-C8 = Almacen.Campo-C[8]~
  rowObject.Campo-C9 = Almacen.Campo-C[9]~
  rowObject.Campo-C10 = Almacen.Campo-C[10]~
  rowObject.Campo-Log1 = Almacen.Campo-Log[1]
&Scoped-Define DATA-FIELD-DEFS "ALM/dalmacen.i"
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
     _FldNameList[1]   > INTEGRAL.Almacen.CodAlm
"CodAlm" "CodAlm" ? ? "character" ? ? ? ? ? ? yes ? no 7.57 yes ?
     _FldNameList[2]   > INTEGRAL.Almacen.Descripcion
"Descripcion" "Descripcion" ? ? "character" ? ? ? ? ? ? yes ? no 40 yes ?
     _FldNameList[3]   > INTEGRAL.Almacen.AutMov
"AutMov" "AutMov" ? ? "logical" ? ? ? ? ? ? yes ? no 24.43 yes ?
     _FldNameList[4]   > INTEGRAL.Almacen.TdoArt
"TdoArt" "TdoArt" ? ? "logical" ? ? ? ? ? ? yes ? no 16.43 yes ?
     _FldNameList[5]   > INTEGRAL.Almacen.CorrIng
"CorrIng" "CorrIng" ? "9999999" "integer" ? ? ? ? ? ? yes ? no 16.14 yes ?
     _FldNameList[6]   > INTEGRAL.Almacen.CorrSal
"CorrSal" "CorrSal" ? "9999999" "integer" ? ? ? ? ? ? yes ? no 15.29 yes ?
     _FldNameList[7]   > INTEGRAL.Almacen.Clave
"Clave" "Clave" ? ? "character" ? ? ? ? ? ? yes ? no 19 yes ?
     _FldNameList[8]   > INTEGRAL.Almacen.flgrep
"flgrep" "flgrep" ? ? "logical" ? ? ? ? ? ? yes ? no 4.86 yes ?
     _FldNameList[9]   > INTEGRAL.Almacen.CodCia
"CodCia" "CodCia" ? ? "integer" ? ? ? ? ? ? yes ? no 3 yes ?
     _FldNameList[10]   > INTEGRAL.Almacen.AlmCsg
"AlmCsg" "AlmCsg" "Almacén de Consignación" ? "logical" ? ? ? ? ? ? yes ? no 6.72 yes ?
     _FldNameList[11]   > INTEGRAL.Almacen.Campo-C[1]
"Campo-C[1]" "Campo-C1" "Clasificación" ? "character" ? ? ? ? ? ? yes ? no 10 yes ?
     _FldNameList[12]   > INTEGRAL.Almacen.Campo-C[2]
"Campo-C[2]" "Campo-C2" ? ? "character" ? ? ? ? ? ? yes ? no 10 yes ?
     _FldNameList[13]   > INTEGRAL.Almacen.Campo-C[3]
"Campo-C[3]" "Campo-C3" ? ? "character" ? ? ? ? ? ? yes ? no 10 yes ?
     _FldNameList[14]   > INTEGRAL.Almacen.Campo-C[4]
"Campo-C[4]" "Campo-C4" ? ? "character" ? ? ? ? ? ? yes ? no 10 yes ?
     _FldNameList[15]   > INTEGRAL.Almacen.Campo-C[5]
"Campo-C[5]" "Campo-C5" "Localización" ? "character" ? ? ? ? ? ? yes ? no 10 yes ?
     _FldNameList[16]   > INTEGRAL.Almacen.Campo-C[6]
"Campo-C[6]" "Campo-C6" ? ? "character" ? ? ? ? ? ? yes ? no 10 yes ?
     _FldNameList[17]   > INTEGRAL.Almacen.Campo-C[7]
"Campo-C[7]" "Campo-C7" ? ? "character" ? ? ? ? ? ? yes ? no 10 yes ?
     _FldNameList[18]   > INTEGRAL.Almacen.Campo-C[8]
"Campo-C[8]" "Campo-C8" ? ? "character" ? ? ? ? ? ? yes ? no 10 yes ?
     _FldNameList[19]   > INTEGRAL.Almacen.Campo-C[9]
"Campo-C[9]" "Campo-C9" ? ? "character" ? ? ? ? ? ? yes ? no 10 yes ?
     _FldNameList[20]   > INTEGRAL.Almacen.Campo-C[10]
"Campo-C[10]" "Campo-C10" "Tpo Servicio" ? "character" ? ? ? ? ? ? yes ? no 10 yes ?
     _FldNameList[21]   > INTEGRAL.Almacen.CodCli
"CodCli" "CodCli" "RUC" ? "character" ? ? ? ? ? ? yes ? no 11 yes ?
     _FldNameList[22]   > INTEGRAL.Almacen.CodDiv
"CodDiv" "CodDiv" "Local" "x(5)" "character" ? ? ? ? ? ? yes ? no 5 yes ?
     _FldNameList[23]   > INTEGRAL.Almacen.DirAlm
"DirAlm" "DirAlm" ? ? "character" ? ? ? ? ? ? yes ? no 60 yes ?
     _FldNameList[24]   > INTEGRAL.Almacen.EncAlm
"EncAlm" "EncAlm" "Encargado" ? "character" ? ? ? ? ? ? yes ? no 30 yes ?
     _FldNameList[25]   > INTEGRAL.Almacen.HorRec
"HorRec" "HorRec" ? ? "character" ? ? ? ? ? ? yes ? no 40 yes ?
     _FldNameList[26]   > INTEGRAL.Almacen.TelAlm
"TelAlm" "TelAlm" "Teléfono" ? "character" ? ? ? ? ? ? yes ? no 15.72 yes ?
     _FldNameList[27]   > INTEGRAL.Almacen.TpoCsg
"TpoCsg" "TpoCsg" "Tipo Csg." ? "character" ? ? ? ? ? ? yes ? no 7 yes ?
     _FldNameList[28]   > INTEGRAL.Almacen.Campo-Log[1]
"Campo-Log[1]" "Campo-Log1" ? ? "logical" ? ? ? ? ? ? yes ? no 10.14 yes ?
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

  /* Code placed here will execute PRIOR to standard behavior. */
  DYNAMIC-FUNCTION('setQueryWhere' ,"Almacen.CodCia = " + STRING(s-CodCia)).

  /* QueryString:
  To begin with the QueryString property is the primary query property.  
  When opening the SDO query, QueryString is used.  
  If QueryString is blank, then the QueryWhere property is used, and if QueryWhere is blank the BaseQuery property is used.  
  The following is a list of API's that can be used to manipulate the dynamic SDO query. The SDO used in the examples below 
  has a design time base query of:
  
  FOR EACH Order NO-LOCK,
        EACH Customer OF Order NO-LOCK,
        EACH Salesrep OF Order NO-LOCK
        
  The API's are being executed from the super procedure of a dynamic viewer having obtained the handle of the source SDO. 
  But these could also be used in an InitializeObject override in the SDO Data Logic Procedure.
  */

  /* setQueryWhere:
  Updates the QueryWhere property. Passing in a blank parameter value to setQueryWhere results in assigning the property 
  equal to the baseQuery property.
  
  DYNAMIC-FUNCTION('setQueryWhere':U IN h_SDO,"Customer.Name BEGINS 'B'":U).
  
  Results in a QueryWhere property of:
  
  FOR EACH Order NO-LOCK,
        EACH Customer OF Order WHERE (Customer.name begins 'B') NO-LOCK,
        EACH Salesrep OF Order NO-LOCK
  */

  /* setBaseQuery:
  Updates the BaseQuery property.
  
  DYNAMIC-FUNCTION('setBaseQuery':U IN h_SDO,"FOR EACH order NO-LOCK":U).
  
  Results in a baseQuery property of: 
  
  'FOR EACH order NO-LOCK'.
  */

  /* addQueryWhere:
  Update QueryString and QueryWhere properties.  If the following two calls to addQueryWhere were made:
  
  DYNAMIC-FUNCTION('addQueryWhere' IN h_SDO,
                                     "customer.name begins 'B'",
                                     'customer',
                                      '').

  DYNAMIC-FUNCTION('addQueryWhere' IN h_SDO,
                                     "customer.name begins 'C'",
                                     'customer',
                                     'OR').
  
  Results in QueryString and QueryWhere properties of:
  
  FOR EACH Order NO-LOCK,
        EACH Customer OF Order WHERE
                  (customer.name begins 'B') OR (customer.name begins 'C') NO-LOCK,
        EACH Salesrep OF Order NO-LOCK
        
  The same result can also be achieved with:
  
  DYNAMIC-FUNCTION('addQueryWhere' IN h_SDO,
                 "Customer.name begins 'B' OR Customer.name begins 'C'","","").
  */

  /* setQuerySort:
  Updates the QueryString, QueryWhere and QuerySort properties.
  
  DYNAMIC-FUNCTION('setQuerySort' IN h_SDO,'Customer.Address':U).
  
  Results in QueryString and QueryWhere properties of:
  
  FOR EACH Order NO-LOCK,
        EACH Customer OF Order NO-LOCK,
        EACH Salesrep OF Order NO-LOCK BY Customer.Address
        and QuerySort property of 'Customer.Address'.
  */

  /* assignQuerySelection:
  Updates the QueryString, QueryWhere and QueryColumns properties.  If the following two calls to assignQuerySelection were made:
  DYNAMIC-FUNCTION('assignQuerySelection' IN h_SDO,
                 'customer.name,customer.custnum','B' + CHR(1) + '1473', 'BEGINS,=').

  DYNAMIC-FUNCTION('assignQuerySelection' IN h_SDO,
                 'customer.salesrep','BBB', '=').
                 
  Results in QueryString and QueryWhere properties of:
  
  FOR EACH Order NO-LOCK,
        EACH Customer OF Order WHERE
                  (customer.name BEGINS 'B' AND customer.custnum = '1473') AND
                  (customer.salesrep = 'BBB') NO-LOCK,
        EACH Salesrep OF Order NO-LOCK
        and a QueryColumns property of 'Customer:name.BEGINS,46,3,custnum.=,73,6,salesrep.=,106,5'.
  */

  /* removeQuerySelection:
  Is designed to remove query selection criteria added by assignQuerySelection. 
  Updates the QueryString, QueryWhere and QueryColumns properties.
  
  DYNAMIC-FUNCTION('removeQuerySelection' IN h_SDO,
                'Customer.name,customer.custnum,customer.salesrep', 'BEGINS,=,=').
                
  When applied to the above query modified by assignQuerySelection, results in QueryString and QueryWhere properties of:
  FOR EACH Order NO-LOCK,
        EACH Customer OF Order WHERE
        EACH Salesrep OF Order NO-LOCK
        and a blank QueryColumns property.    
                                             
  */

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

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Verificar que no esté duplicado */
  CASE s-adm-new-record:
      WHEN "YES" THEN DO:
          IF CAN-FIND(FIRST Almacen WHERE Almacen.codcia = s-codcia AND
                      Almacen.codalm = RowObjUpd.CodAlm NO-LOCK)
              THEN DO:
              RETURN "Registro duplicado".
          END.
      END.
  END CASE.

/*   IF RowObjUpd.Campo-C10 > "" THEN DO:                        */
/*       FIND almtabla WHERE almtabla.Tabla = "SV"               */
/*           AND almtabla.Codigo = RowObjUpd.Campo-c10           */
/*           NO-LOCK NO-ERROR.                                   */
/*       IF NOT AVAILABLE Almtabla THEN DO:                      */
/*           RETURN "Tipo de Servicio NO registrado".            */
/*       END.                                                    */
/*   END.                                                        */
/*   IF RowObjUpd.CodDiv > "" THEN DO:                           */
/*       FIND gn-divi WHERE gn-divi.CodCia = S-CODCIA AND        */
/*           gn-divi.CodDiv = RowObjUpd.CodDiv NO-LOCK NO-ERROR. */
/*       IF NOT AVAILABLE gn-divi THEN RETURN "Local NO existe". */
/*   END.                                                        */

  ASSIGN 
      RowObjUpd.CodCia = s-CodCia.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RowObjectValidate dTables  _DB-REQUIRED
PROCEDURE RowObjectValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF RowObject.Campo-C10 > "" THEN DO:
      FIND almtabla WHERE almtabla.Tabla = "SV"
          AND almtabla.Codigo = RowObject.Campo-c10
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almtabla THEN RETURN "Tipo de Servicio NO registrado".
  END.
  IF RowObject.CodDiv > "" THEN DO:
      FIND gn-divi WHERE gn-divi.CodCia = S-CODCIA AND
          gn-divi.CodDiv = RowObject.CodDiv NO-LOCK NO-ERROR.
      IF NOT AVAILABLE gn-divi THEN RETURN "Local NO existe".
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE submitCommit dTables  _DB-REQUIRED
PROCEDURE submitCommit :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcRowIdent AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER plReopen   AS LOGICAL NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  IF plReopen = YES THEN s-adm-new-record = "YES".
  ELSE s-adm-new-record = "NO".

  RUN SUPER( INPUT pcRowIdent, INPUT plReopen).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

