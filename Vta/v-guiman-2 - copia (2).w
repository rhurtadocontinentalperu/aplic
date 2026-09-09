&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE T-RDOC LIKE CcbRdocu.



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
DEFINE SHARED VAR s-acceso-total  AS LOG.

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE SHARED VARIABLE pv-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE cl-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE cb-CODCIA  AS INTEGER.
DEFINE SHARED VARIABLE S-NOMCIA   AS CHAR.
DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC   AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE SHARED VARIABLE S-CODALM   AS CHAR.
DEFINE SHARED VARIABLE S-DESALM   AS CHAR.
DEFINE SHARED VARIABLE S-NROSER   AS INTEGER.
DEFINE SHARED VARIABLE s-TpoFac AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE I-NROSER       AS INTEGER   NO-UNDO.
DEFINE VARIABLE I-NRODOC       AS INTEGER   NO-UNDO.
DEFINE VARIABLE S-PRINTER-NAME AS CHARACTER NO-UNDO.
DEFINE VARIABLE R-ROWID        AS ROWID     NO-UNDO. 

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV AND
     FacCorre.NroSer = S-NROSER NO-LOCK NO-ERROR.
IF AVAILABLE FacCorre THEN 
   ASSIGN I-NroSer = FacCorre.NroSer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

/* GRE */
DEFINE VAR lGRE_ONLINE AS LOG.

RUN gn/gre-online.r(OUTPUT lGRE_ONLINE).

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
&Scoped-define EXTERNAL-TABLES CcbCDocu
&Scoped-define FIRST-EXTERNAL-TABLE CcbCDocu


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR CcbCDocu.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodPed CcbCDocu.CodAlm CcbCDocu.LugEnt CcbCDocu.DirCli ~
CcbCDocu.CodAnt CcbCDocu.CodCli CcbCDocu.NomCli CcbCDocu.RucCli ~
CcbCDocu.LugEnt2 CcbCDocu.CodAge CcbCDocu.NroRef CcbCDocu.Glosa 
&Scoped-define ENABLED-TABLES CcbCDocu
&Scoped-define FIRST-ENABLED-TABLE CcbCDocu
&Scoped-Define ENABLED-OBJECTS BUTTON-1 
&Scoped-Define DISPLAYED-FIELDS CcbCDocu.NroDoc CcbCDocu.FchDoc ~
CcbCDocu.CodPed CcbCDocu.CodAlm CcbCDocu.LugEnt CcbCDocu.DirCli ~
CcbCDocu.usuario CcbCDocu.CodAnt CcbCDocu.CodCli CcbCDocu.NomCli ~
CcbCDocu.RucCli CcbCDocu.LugEnt2 CcbCDocu.CodAge CcbCDocu.NroRef ~
CcbCDocu.Glosa 
&Scoped-define DISPLAYED-TABLES CcbCDocu
&Scoped-define FIRST-DISPLAYED-TABLE CcbCDocu
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-Estado F-NomTra 

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
DEFINE BUTTON BUTTON-1 
     LABEL "Aceptar" 
     SIZE 9 BY .77.

DEFINE VARIABLE F-NomTra AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-Estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .81
     BGCOLOR 15 FGCOLOR 12  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CcbCDocu.NroDoc AT ROW 1 COL 12 COLON-ALIGNED FORMAT "XXX-XXXXXX"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     FILL-IN-Estado AT ROW 1 COL 43 COLON-ALIGNED
     CcbCDocu.FchDoc AT ROW 1 COL 80 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     CcbCDocu.CodPed AT ROW 1.77 COL 12 COLON-ALIGNED
          LABEL "Punto de partida" FORMAT "x(10)"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "Almacen","Cliente","Proveedor" 
          DROP-DOWN-LIST
          SIZE 12 BY 1
     CcbCDocu.CodAlm AT ROW 1.77 COL 24 COLON-ALIGNED NO-LABEL FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCDocu.LugEnt AT ROW 1.77 COL 35 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 49 BY .81
     CcbCDocu.DirCli AT ROW 2.54 COL 12 COLON-ALIGNED
          LABEL "Direccion partida"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
     CcbCDocu.usuario AT ROW 2.54 COL 80 COLON-ALIGNED
          LABEL "Usuario"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCDocu.CodAnt AT ROW 3.31 COL 12 COLON-ALIGNED
          LABEL "Punto de Llegada" FORMAT "X(10)"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "Almacen","Cliente","Proveedor" 
          DROP-DOWN-LIST
          SIZE 12 BY 1
     CcbCDocu.CodCli AT ROW 3.31 COL 24 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     CcbCDocu.NomCli AT ROW 3.31 COL 35 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 49 BY .81
     CcbCDocu.RucCli AT ROW 4.08 COL 12 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .81
     CcbCDocu.LugEnt2 AT ROW 4.85 COL 12 COLON-ALIGNED
          LABEL "Direccion llegada"
          VIEW-AS FILL-IN 
          SIZE 60 BY .81
     CcbCDocu.CodAge AT ROW 5.62 COL 12 COLON-ALIGNED
          LABEL "Transportista" FORMAT "X(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .81
     F-NomTra AT ROW 5.62 COL 23 COLON-ALIGNED NO-LABEL
     CcbCDocu.NroRef AT ROW 6.42 COL 81 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 15 BY .81
     CcbCDocu.Glosa AT ROW 6.58 COL 14 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 120
          SIZE 60 BY 1.62
     BUTTON-1 AT ROW 7.31 COL 85.72 WIDGET-ID 8
     "Desde una FAC - creada por FAI" VIEW-AS TEXT
          SIZE 27 BY .5 AT ROW 5.81 COL 73.86 WIDGET-ID 2
          FGCOLOR 4 FONT 6
     "Observaciones:" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 6.58 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.CcbCDocu
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: T-RDOC T "SHARED" ? INTEGRAL CcbRdocu
   END-TABLES.
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
         HEIGHT             = 8.5
         WIDTH              = 101.14.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN CcbCDocu.CodAge IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.CodAlm IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR COMBO-BOX CcbCDocu.CodAnt IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR COMBO-BOX CcbCDocu.CodPed IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN CcbCDocu.DirCli IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-NomTra IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Estado IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.LugEnt2 IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN CcbCDocu.NroDoc IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN CcbCDocu.usuario IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
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

&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 V-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME F-Main /* Aceptar */
DO:
  
  DEFINE VAR x-nrofac AS CHAR INIT ''.
  DEFINE VAR x-ptollegada AS CHAR INIT ''.
  DEFINE VAR x-codcli AS CHAR INIT ''.
  DEFINE VAR x-retval AS CHAR INIT ''.

  x-nrofac = ccbcdocu.NroRef:SCREEN-VALUE.
  x-ptollegada = ccbcdocu.CodAnt:SCREEN-VALUE.
  x-codcli = ccbcdocu.codcli:SCREEN-VALUE.

  IF x-ptollegada = 'Cliente' and x-codcli <> '' AND x-nrofac <> '' THEN DO:
      RUN ue-desde-fac-fai IN lh_Handle(INPUT x-nrofac, INPUT x-codcli, OUTPUT x-retval).

      IF x-retval = "OK"  THEN DO:
          DISABLE ccbcdocu.codant WITH FRAME {&FRAME-NAME}.
          DISABLE ccbcdocu.codcli WITH FRAME {&FRAME-NAME}.
          DISABLE ccbcdocu.ruccli WITH FRAME {&FRAME-NAME}.
          DISABLE ccbcdocu.nomcli WITH FRAME {&FRAME-NAME}.
          DISABLE ccbcdocu.nroref WITH FRAME {&FRAME-NAME}.
          DISABLE BUTTON-1 WITH FRAME {&FRAME-NAME}.
      END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodAge
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodAge V-table-Win
ON LEAVE OF CcbCDocu.CodAge IN FRAME F-Main /* Transportista */
DO:
  F-NomTra = "".
  IF CcbcDocu.CodAge:SCREEN-VALUE <> "" THEN DO: 
     FIND GN-PROV WHERE GN-PROV.codpro = CcbcDocu.CodAge:screen-value NO-LOCK NO-ERROR.
     IF AVAILABLE gn-prov THEN F-NomTra = gn-prov.Nompro.
  END.
  DISPLAY F-NomTra WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodAlm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodAlm V-table-Win
ON LEAVE OF CcbCDocu.CodAlm IN FRAME F-Main /* Almacen */
DO:
  CcbCDocu.LugEnt:SCREEN-VALUE = ''.
  CcbCDocu.DirCli:SCREEN-VALUE = ''.
  CASE CcbCDocu.CodPed:SCREEN-VALUE:
    WHEN 'Almacen' THEN DO:
        FIND Almacen WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen
        THEN ASSIGN
                CcbCDocu.LugEnt:SCREEN-VALUE = Almacen.Descripcion
                CcbCDocu.DirCli:SCREEN-VALUE = Almacen.DirAlm.
    END.
    WHEN 'Cliente' THEN DO:
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie
        THEN ASSIGN
                CcbCDocu.LugEnt:SCREEN-VALUE = gn-clie.nomcli.
                CcbCDocu.DirCli:SCREEN-VALUE = gn-clie.dircli.
    END.
    WHEN 'Proveedor' THEN DO:
        FIND gn-prov WHERE gn-prov.codcia = pv-codcia
            AND gn-prov.codpro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov
        THEN ASSIGN
                CcbCDocu.LugEnt:SCREEN-VALUE = gn-prov.nompro.
                CcbCDocu.DirCli:SCREEN-VALUE = gn-prov.dirpro.
    END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodAlm V-table-Win
ON LEFT-MOUSE-DBLCLICK OF CcbCDocu.CodAlm IN FRAME F-Main /* Almacen */
OR F8 OF ccbcdocu.codalm
DO:
  CASE CcbCDocu.CodPed:SCREEN-VALUE:
    WHEN 'Almacen' THEN DO:
        ASSIGN
            input-var-1 = ''
            input-var-2 = ''
            input-var-3 = ''
            output-var-1 = ?
            output-var-2 = ''
            output-var-3 = ''.
        RUN lkup/c-almcen ('Almacenes').
        IF output-var-1 <> ?
        THEN DO:
            FIND Almacen WHERE ROWID(Almacen) = output-var-1 NO-LOCK NO-ERROR.
            ASSIGN
                SELF:SCREEN-VALUE = Almacen.codalm
                CcbCDocu.LugEnt:SCREEN-VALUE = Almacen.Descripcion.                
        END.
    END.
    WHEN 'Cliente' THEN DO:
        ASSIGN
            input-var-1 = ''
            input-var-2 = ''
            input-var-3 = ''
            output-var-1 = ?
            output-var-2 = ''
            output-var-3 = ''.
        RUN lkup/c-client ('Clientes').        
        IF output-var-1 <> ?
        THEN DO:
            FIND gn-clie WHERE ROWID(gn-clie) = output-var-1 NO-LOCK NO-ERROR.
            ASSIGN
                SELF:SCREEN-VALUE = gn-clie.CodCli
                CcbCDocu.LugEnt:SCREEN-VALUE = gn-clie.nomcli.
        END.            
    END.
    WHEN 'Proveedor' THEN DO:
        ASSIGN
            input-var-1 = ''
            input-var-2 = ''
            input-var-3 = ''
            output-var-1 = ?
            output-var-2 = ''
            output-var-3 = ''.
        RUN lkup/c-provee ('Proveedores').        
        IF output-var-1 <> ?
        THEN DO:
            FIND gn-prov WHERE ROWID(gn-prov) = output-var-1 NO-LOCK NO-ERROR.
            ASSIGN
                SELF:SCREEN-VALUE = gn-prov.CodPro
                CcbCDocu.LugEnt:SCREEN-VALUE = gn-prov.nompro.
        END.            
    END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CcbCDocu.CodCli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCli V-table-Win
ON LEAVE OF CcbCDocu.CodCli IN FRAME F-Main /* Cliente */
DO:
  CASE CcbCDocu.CodAnt:SCREEN-VALUE:
    WHEN 'Almacen' THEN DO:
        FIND Almacen WHERE Almacen.codcia = s-codcia
            AND Almacen.codalm = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE Almacen
        THEN ASSIGN
                CcbCDocu.NomCli:SCREEN-VALUE = Almacen.Descripcion
                CcbCDocu.LugEnt2:SCREEN-VALUE = Almacen.DirAlm.
    END.
    WHEN 'Cliente' THEN DO:
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie
        THEN ASSIGN
                CcbCDocu.NomCli:SCREEN-VALUE = gn-clie.nomcli
                CcbCDocu.LugEnt2:SCREEN-VALUE = gn-clie.dircli
                CcbCDocu.RucCli:SCREEN-VALUE = gn-clie.Ruc.
    END.
    WHEN 'Proveedor' THEN DO:
        FIND gn-prov WHERE gn-prov.codcia = pv-codcia
            AND gn-prov.codpro = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE gn-prov
        THEN ASSIGN
                CcbCDocu.NomCli:SCREEN-VALUE = gn-prov.nompro
                CcbCDocu.LugEnt2:SCREEN-VALUE = gn-prov.dirpro
                CcbCDocu.RucCli:SCREEN-VALUE = gn-prov.Ruc.
    END.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CcbCDocu.CodCli V-table-Win
ON LEFT-MOUSE-DBLCLICK OF CcbCDocu.CodCli IN FRAME F-Main /* Cliente */
OR F8 OF ccbcdocu.codcli
DO:
  CASE CcbCDocu.CodAnt:SCREEN-VALUE:
    WHEN 'Almacen' THEN DO:
        ASSIGN
            input-var-1 = ''
            input-var-2 = ''
            input-var-3 = ''
            output-var-1 = ?
            output-var-2 = ''
            output-var-3 = ''.
        RUN lkup/c-almcen ('Almacenes').
        IF output-var-1 <> ?
        THEN DO:
            FIND Almacen WHERE ROWID(Almacen) = output-var-1 NO-LOCK NO-ERROR.
            ASSIGN
                SELF:SCREEN-VALUE = Almacen.codalm
                CcbCDocu.NomCli:SCREEN-VALUE = Almacen.Descripcion
                CcbCDocu.LugEnt2:SCREEN-VALUE = Almacen.DirAlm.
        END.
    END.
    WHEN 'Cliente' THEN DO:
        ASSIGN
            input-var-1 = ''
            input-var-2 = ''
            input-var-3 = ''
            output-var-1 = ?
            output-var-2 = ''
            output-var-3 = ''.
        RUN lkup/c-client ('Clientes').        
        IF output-var-1 <> ?
        THEN DO:
            FIND gn-clie WHERE ROWID(gn-clie) = output-var-1 NO-LOCK NO-ERROR.
            ASSIGN
                SELF:SCREEN-VALUE = gn-clie.CodCli
                CcbCDocu.NomCli:SCREEN-VALUE = gn-clie.nomcli
                CcbCDocu.LugEnt2:SCREEN-VALUE = gn-clie.dircli.
        END.            
    END.
    WHEN 'Proveedor' THEN DO:
        ASSIGN
            input-var-1 = ''
            input-var-2 = ''
            input-var-3 = ''
            output-var-1 = ?
            output-var-2 = ''
            output-var-3 = ''.
        RUN lkup/c-provee ('Proveedores').        
        IF output-var-1 <> ?
        THEN DO:
            FIND gn-prov WHERE ROWID(gn-prov) = output-var-1 NO-LOCK NO-ERROR.
            ASSIGN
                SELF:SCREEN-VALUE = gn-prov.CodPro
                CcbCDocu.NomCli:SCREEN-VALUE = gn-prov.nompro
                CcbCDocu.LugEnt2:SCREEN-VALUE = gn-prov.dirpro.
        END.            
    END.
  END CASE.
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
  {src/adm/template/row-list.i "CcbCDocu"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "CcbCDocu"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal V-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH T-RDOC:
    DELETE T-RDOC.
  END.
  IF AVAILABLE CcbCDocu
  THEN DO:
    FOR EACH ccbrdocu WHERE ccbrdocu.codcia = ccbcdocu.codcia
            AND ccbrdocu.coddoc = ccbcdocu.coddoc
            AND ccbrdocu.nrodoc = ccbcdocu.nrodoc NO-LOCK:
        CREATE T-RDOC.
        BUFFER-COPY ccbrdocu TO T-RDOC.
    END.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Guia V-table-Win 
PROCEDURE Genera-Guia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR x-Item AS INT INIT 0 NO-UNDO.
  
  FOR EACH T-RDOC NO-LOCK WHERE T-RDOC.CodMat <> "" BY T-RDOC.NroItm
        ON ERROR UNDO, RETURN "ADM-ERROR": 
    x-Item = x-Item + 1.
    CREATE CcbRDocu.
    BUFFER-COPY T-RDOC TO CcbRDocu
        ASSIGN 
            CcbRDocu.CodCia = CcbCDocu.CodCia 
            CcbRDocu.Coddoc = CcbCDocu.Coddoc
            CcbRDocu.NroDoc = CcbCDocu.NroDoc 
            CcbRDocu.NroItm = x-Item.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  IF lGRE_ONLINE = YES THEN DO:
        MESSAGE "Imposible adicionar, guia de remision electronica esta activa" 
            VIEW-AS ALERT-BOX INFORMATION.
        RETURN 'ADM-ERROR'.
  END.

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN Numero-de-Documento (FALSE).
  IF RETURN-VALUE = 'ADM-ERROR' 
  THEN DO:
    MESSAGE 'No esta configurado el correlativo para esta division'
        VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  /* VALORES EN PANTALLA */
  DO WITH FRAME {&FRAME-NAME}:
    /* Correlativo */
    RUN Numero-de-Documento(NO).
    DISPLAY 
        STRING(i-NroSer, '999') + STRING(i-NroDoc, '999999') @ CcbCDocu.NroDoc
        s-codalm    @ CcbCDocu.CodAlm
        s-desalm    @ CcbCDocu.LugEnt
        TODAY       @ CcbCDocu.FchDoc.
    ASSIGN
        CcbCDocu.CodAnt:SCREEN-VALUE = 'Almacen'
        CcbCDocu.CodPed:SCREEN-VALUE = 'Almacen'.
  END.
  RUN Carga-Temporal.
  RUN Procesa-Handle IN lh_handle ('Pagina2').
  RUN Procesa-Handle IN lh_handle ('browse').

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

  DEFINE VAR lSwFac AS LOG.

  lSwFac = NO.

  ASSIGN 
    CcbCDocu.usuario = S-USER-ID
    CcbCDocu.HorCie = string(time,'hh:mm:ss').

    /* Ic - 30Ene2017, la guia se genero desde una factura generada x FAI */
    IF ccbcdocu.codant = 'Cliente' AND CcbCDocu.nroref <> '' THEN DO :
        ASSIGN CcbCDocu.codref = 'FAC'.
        lSwFac = YES.
    END.
    ELSE DO :
        ASSIGN CcbCDocu.nroref = ''.
    END.

  RUN Genera-Guia.    /* Detalle de la Guia */ 

  /* Ic - 30Ene2017, si proviene de FAC actualizar */
  IF lSwFac = YES THEN DO:
    DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
    FIND FIRST b-ccbcdocu WHERE b-ccbcdocu.codcia = s-codcia AND 
                                b-ccbcdocu.coddoc = 'FAC' AND 
                                b-ccbcdocu.nrodoc = ccbcdocu.nroref 
                                EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b-ccbcdocu THEN DO:
        ASSIGN b-ccbcdocu.libre_c05 = 'G/R|' + TRIM(ccbcdocu.nroref).
    END.
    RELEASE b-ccbcdocu.
  END.
  
  IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
  RUN Procesa-Handle IN lh_handle ('Pagina1').
  
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
  RUN Procesa-Handle IN lh_handle ('Pagina1').
  RUN Procesa-Handle IN lh_handle ('browse').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN Numero-de-Documento (FALSE).
  IF RETURN-VALUE = 'ADM-ERROR' 
  THEN DO:
    MESSAGE 'No esta configurado el correlativo para esta division'
        VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    /* Correlativo */
    RUN Numero-de-Documento(NO).
    DISPLAY 
        STRING(i-NroSer, '999') + STRING(i-NroDoc, '999999') @ CcbCDocu.NroDoc
        s-codalm    @ CcbCDocu.CodAlm
        s-desalm    @ CcbCDocu.LugEnt
        TODAY       @ CcbCDocu.FchDoc.
    ASSIGN
        CcbCDocu.CodAnt:SCREEN-VALUE = 'Almacen'
        CcbCDocu.CodPed:SCREEN-VALUE = 'Almacen'.
  END.
  RUN Carga-Temporal.
  RUN Procesa-Handle IN lh_handle ('Pagina2').
  RUN Procesa-Handle IN lh_handle ('browse').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEF VAR pMensaje AS CHAR NO-UNDO.
  /* Correlativo */
  {lib\lock-genericov3.i &Tabla="FacCorre" ~
      &Condicion="FacCorre.CodCia = s-CodCia ~
      AND FacCorre.CodDiv = s-CodDiv ~
      AND FacCorre.CodDoc = s-CodDoc ~
      AND FacCorre.NroSer = s-NroSer ~
      AND FacCorre.CodAlm = s-CodAlm" ~
      &Bloqueo= "EXCLUSIVE-LOCK" ~
      &Accion="RETRY" ~
      &Mensaje="YES" ~
      &tMensaje="pMensaje" ~
      &TipoError="RETURN 'ADM-ERROR'" ~
      }

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
/*   RUN Numero-de-Documento(YES).                                */
/*   IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'. */
  ASSIGN 
    CcbCDocu.NroDoc = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999") 
    CcbCDocu.CodCia = S-CODCIA
    CcbCDocu.CodAlm = S-CODALM
    CcbCDocu.CodDiv = S-CODDIV
    CcbCDocu.CodDoc = S-CODDOC
    CcbCDocu.Tipo   = "OFICINA"
    CcbCDocu.TipVta = "2"
    CcbCDocu.TpoFac = s-TpoFac
    CcbCDocu.FlgEst = "F"
    CcbCDocu.FlgSit = "P".
  ASSIGN 
      FacCorre.Correlativo = FacCorre.Correlativo + 1.
  DISPLAY ccbcdocu.nrodoc WITH FRAME {&FRAME-NAME}.
  RELEASE FacCorre.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

/*
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
*/
  DEF VAR RPTA AS CHAR NO-UNDO.
  
  IF CcbCDocu.FlgEst = "A" THEN DO:
      MESSAGE 'El documento se encuentra anulado...' VIEW-AS ALERT-BOX.
      RETURN 'ADM-ERROR'.
  END.
   /* **************************************************************************** */
   /* RHC 30/&06/2020 F.O.V. NO anular la G/R si está en una H/R */
   /* **************************************************************************** */
   IF CcbCDocu.FchDoc <> TODAY THEN DO:
       MESSAGE 'Solo se puede anular guías del día de hoy'
           VIEW-AS ALERT-BOX ERROR.
       RETURN 'ADM-ERROR'.
   END.
  DEF VAR pHojRut   AS CHAR.
  DEF VAR pFlgEst-1 AS CHAR.
  DEF VAR pFlgEst-2 AS CHAR.
  DEF VAR pFchDoc   AS DATE.

  RUN dist/p-rut002 ( "GRM",
                      Ccbcdocu.coddoc,
                      Ccbcdocu.nrodoc,
                      "",
                      "",
                      "",
                      0,
                      0,
                      OUTPUT pHojRut,
                      OUTPUT pFlgEst-1,     /* de Di-RutaC */
                      OUTPUT pFlgEst-2,     /* de Di-RutaG */
                      OUTPUT pFchDoc).
  IF pHojRut > '' AND pFlgEst-1 <> 'A' THEN DO:
       MESSAGE "NO se puede anular" SKIP "Revisar la Hoja de Ruta:" pHojRut
           VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".
   END.
   /* **************************************************************************** */
   FIND Almacen WHERE 
         Almacen.CodCia = S-CODCIA AND
         Almacen.CodAlm = S-CODALM NO-LOCK NO-ERROR.
   RUN vta/g-CLAVE (Almacen.Clave,OUTPUT RPTA).
   IF RPTA = "ERROR" THEN RETURN "ADM-ERROR".
   /* consistencia de la fecha del cierre del sistema */
   DEF VAR dFchCie AS DATE.
   RUN gn/fecha-de-cierre (OUTPUT dFchCie).
   IF ccbcdocu.fchdoc <= dFchCie THEN DO:
       MESSAGE 'NO se puede anular ningun documento antes del' (dFchCie + 1)
           VIEW-AS ALERT-BOX WARNING.
       RETURN 'ADM-ERROR'.
   END.
   /* fin de consistencia */

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND CURRENT CcbCDocu EXCLUSIVE-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN 'ADM-ERROR'.
    FOR EACH CcbRDocu WHERE ccbrdocu.codcia = ccbcdocu.codcia
            AND ccbrdocu.coddoc = ccbcdocu.coddoc
            AND ccbrdocu.nrodoc = ccbcdocu.nrodoc EXCLUSIVE-LOCK:
        DELETE CcbRDocu.
    END.
    ASSIGN
        CcbCDocu.FlgEst = 'A'
        CcbCDocu.SdoAct = 0
        CcbCDocu.Glosa  = "A N U L A D O"
        CcbCDocu.FchAnu = TODAY
        CcbCDocu.Usuanu = S-USER-ID. 
    FIND CURRENT CcbCDocu NO-LOCK NO-ERROR.
  END.
  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
  RUN Procesa-Handle IN lh_handle ('browse').
  
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

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        BUTTON-1:SENSITIVE = NO.
END.

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
  IF AVAILABLE CcbCDocu THEN DO WITH FRAME {&FRAME-NAME}:
    CASE CcbCDocu.FlgEst:
        WHEN "A" THEN DISPLAY "ANULADO"   @ FILL-IN-Estado WITH FRAME {&FRAME-NAME}.
        WHEN "F" THEN DISPLAY "FACTURADO" @ FILL-IN-Estado WITH FRAME {&FRAME-NAME}.
        WHEN "P" THEN DISPLAY "PENDIENTE" @ FILL-IN-Estado WITH FRAME {&FRAME-NAME}.
        OTHERWISE DISPLAY "?" @ FILL-IN-Estado WITH FRAME {&FRAME-NAME}.
    END CASE.         
    FIND gn-prov WHERE gn-prov.CodCia = pv-codcia
        AND gn-prov.CODPRO = CcbCDocu.CodAge NO-LOCK NO-ERROR.
    IF AVAILABLE GN-PROV 
    THEN F-NomTra:SCREEN-VALUE = GN-PROV.NomPRO.
    ELSE F-NomTra:SCREEN-VALUE = ''.
  END.
  RUN Carga-Temporal.
/*  RUN Procesa-Handle IN lh_handle ('browse').*/

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
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        CcbCDocu.FchDoc:SENSITIVE = NO
        CcbCDocu.NroDoc:SENSITIVE = NO.
        BUTTON-1:SENSITIVE = YES.
/*        CcbCDocu.CodAlm:SENSITIVE = NO.*/
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
  IF ccbcdocu.flgest = 'A' THEN RETURN.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'imprime':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF CcbCDocu.FlgEst <> "A" THEN RUN vta/R-ImpGMA2a (ROWID(CcbCDocu)).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Numero-de-Documento V-table-Win 
PROCEDURE Numero-de-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER L-INCREMENTA AS LOGICAL.
  IF L-INCREMENTA 
  THEN
     FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER AND
          FacCorre.CodAlm = S-CODALM EXCLUSIVE-LOCK NO-ERROR.
  
  ELSE
     FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
          FacCorre.CodDoc = S-CODDOC AND
          FacCorre.CodDiv = S-CODDIV AND
          FacCorre.NroSer = S-NROSER AND
          FacCorre.CodAlm = S-CODALM NO-LOCK NO-ERROR.
     
  IF ERROR-STATUS:ERROR THEN RETURN 'ADM-ERROR'.
  ASSIGN I-NroDoc = FacCorre.Correlativo.
  IF L-INCREMENTA THEN ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
  I-NROSER = FacCorre.NroSer.
  RELEASE FacCorre.

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
  {src/adm/template/snd-list.i "CcbCDocu"}

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
  DEFINE VARIABLE X-ITEMS AS INTEGER INIT 0.
  DEFINE VARIABLE I-ITEMS AS DECIMAL NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    CASE CcbCDocu.CodPed:SCREEN-VALUE:
      WHEN 'Almacen' THEN DO:
          FIND Almacen WHERE Almacen.codcia = s-codcia
              AND Almacen.codalm = CcbCDocu.CodAlm:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Almacen THEN DO:
            MESSAGE 'Almacen destino no existe' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO Ccbcdocu.codcli.
            RETURN 'ADM-ERROR'.
          END.
      END.
      WHEN 'Cliente' THEN DO:
          FIND gn-clie WHERE gn-clie.codcia = cl-codcia
              AND gn-clie.codcli = CcbCDocu.CodAlm:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE gn-clie THEN DO:
            MESSAGE 'Cliente no existe' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO Ccbcdocu.codcli.
            RETURN 'ADM-ERROR'.
          END.
      END.
      WHEN 'Proveedor' THEN DO:
          FIND gn-prov WHERE gn-prov.codcia = pv-codcia
              AND gn-prov.codpro = CcbCDocu.CodAlm:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE gn-prov THEN DO:
            MESSAGE 'Proveedor no existe' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO Ccbcdocu.codcli.
            RETURN 'ADM-ERROR'.
          END.
      END.
    END CASE.
    CASE CcbCDocu.CodAnt:SCREEN-VALUE:
      WHEN 'Almacen' THEN DO:
          FIND Almacen WHERE Almacen.codcia = s-codcia
              AND Almacen.codalm = CcbCDocu.CodCli:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE Almacen THEN DO:
            MESSAGE 'Almacen destino no existe' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO Ccbcdocu.codcli.
            RETURN 'ADM-ERROR'.
          END.
      END.
      WHEN 'Cliente' THEN DO:
          FIND gn-clie WHERE gn-clie.codcia = cl-codcia
              AND gn-clie.codcli = CcbCDocu.CodCli:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE gn-clie THEN DO:
            MESSAGE 'Cliente no existe' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO Ccbcdocu.codcli.
            RETURN 'ADM-ERROR'.
          END.
      END.
      WHEN 'Proveedor' THEN DO:
          FIND gn-prov WHERE gn-prov.codcia = pv-codcia
              AND gn-prov.codpro = CcbCDocu.CodCli:SCREEN-VALUE NO-LOCK NO-ERROR.
          IF NOT AVAILABLE gn-prov THEN DO:
            MESSAGE 'Proveedor no existe' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO Ccbcdocu.codcli.
            RETURN 'ADM-ERROR'.
          END.
      END.
    END CASE.

    FIND GN-PROV WHERE GN-PROV.codcia = pv-codcia
        AND GN-PROV.CodPro = CcbcDocu.CodAge:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE GN-PROV THEN DO:
       MESSAGE "Codigo de transportista no existe" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO CcbCDocu.CodAge.
       RETURN "ADM-ERROR".   
    END.

    IF CcbCDocu.DirCli:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'Ingrese la direccion de partida' VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO CcbCDocu.DirCli.
       RETURN "ADM-ERROR".   
    END.

    IF CcbCDocu.LugEnt2:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'Ingrese la direccion de llegada' VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO CcbCDocu.LugEnt2.
       RETURN "ADM-ERROR".   
    END.

    X-ITEMS = 0.
    FOR EACH T-RDOC NO-LOCK:
        I-ITEMS = I-ITEMS + T-RDOC.CanDes.
        X-ITEMS = X-ITEMS + 1.
    END.
    IF I-ITEMS = 0 THEN DO:
       MESSAGE "No hay items por despachar" VIEW-AS ALERT-BOX ERROR.
       APPLY "ENTRY" TO CcbCDocu.CodAge.
       RETURN "ADM-ERROR".   
    END.
    IF X-ITEMS > FacCfgGn.Items_Guias THEN DO:
     MESSAGE "Numero de Items Mayor al Configurado para el Tipo de Documento " VIEW-AS ALERT-BOX INFORMATION.
     RETURN "ADM-ERROR".
    END. 

/*    FIND AlmCierr WHERE 
 *         AlmCierr.CodCia = S-CODCIA AND 
 *         AlmCierr.FchCie = INPUT CcbCDocu.FchDoc 
 *         NO-LOCK NO-ERROR.
 *     IF AVAILABLE AlmCierr 
 *         AND AlmCierr.FlgCie THEN DO:
 *       MESSAGE "Este dia " AlmCierr.FchCie " se encuentra cerrado" SKIP 
 *               "Consulte con Control Interno " VIEW-AS ALERT-BOX INFORMATION.
 *       RETURN "ADM-ERROR".
 *     END.*/

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
MESSAGE 'Acceso Denegado' VIEW-AS ALERT-BOX WARNING.
RETURN "ADM-ERROR".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

