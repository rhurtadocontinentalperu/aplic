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
DEFINE {&NEW} SHARED VARIABLE s-user-id AS CHAR.
DEFINE {&NEW} SHARED VARIABLE  s-codcia AS INTEGER.
DEFINE VARIABLE pv-codcia AS INTEGER INITIAL 0.
DEFINE SHARED VARIABLE lh_Handle  AS HANDLE.

FIND Empresas WHERE Empresas.CodCia = s-codcia.
IF NOT Empresas.Campo-CodPro THEN pv-codcia = s-codcia.

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
&Scoped-define EXTERNAL-TABLES gn-prov
&Scoped-define FIRST-EXTERNAL-TABLE gn-prov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gn-prov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gn-prov.Libre_c05 gn-prov.TpoPro ~
gn-prov.Persona gn-prov.CodPro gn-prov.RepLegal gn-prov.NomPro ~
gn-prov.ApePat gn-prov.ApeMat gn-prov.Nombre gn-prov.DirPro gn-prov.CodPais ~
gn-prov.CodDept gn-prov.CodProv gn-prov.CodDist gn-prov.Codpos gn-prov.Ruc ~
gn-prov.TpoEnt gn-prov.Fching gn-prov.FchAct gn-prov.Telfnos[1] ~
gn-prov.Telfnos[2] gn-prov.FaxPro gn-prov.E-Mail gn-prov.Girpro ~
gn-prov.CndCmp gn-prov.clfpro gn-prov.Flgsit gn-prov.PrioridadPago ~
gn-prov.Referencias gn-prov.Telfnos[3] gn-prov.Contactos[1] ~
gn-prov.Contactos[2] gn-prov.Contactos[3] gn-prov.Contactos[4] ~
gn-prov.StkMin gn-prov.StkMax 
&Scoped-define ENABLED-TABLES gn-prov
&Scoped-define FIRST-ENABLED-TABLE gn-prov
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-4 RECT-3 RECT-6 
&Scoped-Define DISPLAYED-FIELDS gn-prov.Libre_c05 gn-prov.Libre_c03 ~
gn-prov.TpoPro gn-prov.Persona gn-prov.CodPro gn-prov.RepLegal ~
gn-prov.NomPro gn-prov.ApePat gn-prov.ApeMat gn-prov.Nombre gn-prov.DirPro ~
gn-prov.CodPais gn-prov.CodDept gn-prov.CodProv gn-prov.CodDist ~
gn-prov.Codpos gn-prov.Libre_c01 gn-prov.Libre_c02 gn-prov.Ruc ~
gn-prov.TpoEnt gn-prov.Fching gn-prov.FchAct gn-prov.Telfnos[1] ~
gn-prov.Telfnos[2] gn-prov.FaxPro gn-prov.E-Mail gn-prov.Girpro ~
gn-prov.CndCmp gn-prov.clfpro gn-prov.Flgsit gn-prov.PrioridadPago ~
gn-prov.Referencias gn-prov.Telfnos[3] gn-prov.Contactos[1] ~
gn-prov.Contactos[2] gn-prov.Contactos[3] gn-prov.Contactos[4] ~
gn-prov.StkMin gn-prov.StkMax 
&Scoped-define DISPLAYED-TABLES gn-prov
&Scoped-define FIRST-DISPLAYED-TABLE gn-prov
&Scoped-Define DISPLAYED-OBJECTS F-Pais F-Depa F-Prov F-Dist F-post F-Giro ~
F-DesCnd x-DesPri 

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
DEFINE VARIABLE F-Depa AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .69 NO-UNDO.

DEFINE VARIABLE F-DesCnd AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .69 NO-UNDO.

DEFINE VARIABLE F-Dist AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .69 NO-UNDO.

DEFINE VARIABLE F-Giro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .69 NO-UNDO.

DEFINE VARIABLE F-Pais AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .69 NO-UNDO.

DEFINE VARIABLE F-post AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .69 NO-UNDO.

DEFINE VARIABLE F-Prov AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .69 NO-UNDO.

DEFINE VARIABLE x-DesPri AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .69 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 12.29 BY 1.73.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 7.54.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 3.77.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 11.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     gn-prov.Libre_c05 AT ROW 5.42 COL 66 COLON-ALIGNED HELP
          "" WIDGET-ID 24
          LABEL "Codigo EAN" FORMAT "x(13)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .81
     gn-prov.Libre_c03 AT ROW 2.88 COL 68 NO-LABEL WIDGET-ID 14
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", "Si":U,
"No", "No":U
          SIZE 11 BY .58
     gn-prov.TpoPro AT ROW 1.27 COL 13 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Nacional", "N":U,
"Extranjero", "E":U
          SIZE 20.86 BY .58
     gn-prov.Persona AT ROW 2.08 COL 13 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Jurídica", "J":U,
"Natural", "N":U
          SIZE 20 BY .58
     gn-prov.CodPro AT ROW 2.88 COL 11 COLON-ALIGNED
          LABEL "Código" FORMAT "x(9)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     gn-prov.RepLegal AT ROW 2.73 COL 33 COLON-ALIGNED WIDGET-ID 26
          LABEL "Agrupador" FORMAT "x(9)"
          VIEW-AS FILL-IN 
          SIZE 14 BY .81
     gn-prov.NomPro AT ROW 3.69 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 40 BY .69
     gn-prov.ApePat AT ROW 4.5 COL 11 COLON-ALIGNED
          LABEL "Ap. Paterno"
          VIEW-AS FILL-IN 
          SIZE 22 BY .69
     gn-prov.ApeMat AT ROW 5.31 COL 11 COLON-ALIGNED
          LABEL "Ap. Materno"
          VIEW-AS FILL-IN 
          SIZE 22 BY .69
     gn-prov.Nombre AT ROW 6.12 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .69
     gn-prov.DirPro AT ROW 7.19 COL 11 COLON-ALIGNED
          LABEL "Dirección"
          VIEW-AS FILL-IN 
          SIZE 40 BY .69
     gn-prov.CodPais AT ROW 8 COL 11 COLON-ALIGNED
          LABEL "País" FORMAT "X(2)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     F-Pais AT ROW 8 COL 17 COLON-ALIGNED NO-LABEL
     gn-prov.CodDept AT ROW 8.81 COL 11 COLON-ALIGNED FORMAT "X(2)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     F-Depa AT ROW 8.81 COL 17 COLON-ALIGNED NO-LABEL
     gn-prov.CodProv AT ROW 9.58 COL 11 COLON-ALIGNED FORMAT "X(2)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     F-Prov AT ROW 9.62 COL 17 COLON-ALIGNED NO-LABEL
     gn-prov.CodDist AT ROW 10.42 COL 11 COLON-ALIGNED FORMAT "X(2)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     F-Dist AT ROW 10.42 COL 17 COLON-ALIGNED NO-LABEL
     gn-prov.Codpos AT ROW 11.23 COL 11 COLON-ALIGNED FORMAT "x(3)"
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .69
     F-post AT ROW 11.23 COL 17 COLON-ALIGNED NO-LABEL
     gn-prov.Libre_c01 AT ROW 1.27 COL 68 NO-LABEL WIDGET-ID 2
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", "Si":U,
"No", "No":U
          SIZE 11 BY .58
     gn-prov.Libre_c02 AT ROW 2.08 COL 68 NO-LABEL WIDGET-ID 6
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Si", "Si":U,
"No", "No":U
          SIZE 11 BY .58
     gn-prov.Ruc AT ROW 3.69 COL 66 COLON-ALIGNED
          LABEL "R.U.C." FORMAT "x(11)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .69
     gn-prov.TpoEnt AT ROW 4.5 COL 66 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.57 BY .81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     gn-prov.Fching AT ROW 7.19 COL 66 COLON-ALIGNED
          LABEL "Fecha Ingreso"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     gn-prov.FchAct AT ROW 8 COL 66 COLON-ALIGNED
          LABEL "Actualización"
          VIEW-AS FILL-IN 
          SIZE 10 BY .69
     gn-prov.Telfnos[1] AT ROW 8.81 COL 52 COLON-ALIGNED
          LABEL "Teléfono[1]"
          VIEW-AS FILL-IN 
          SIZE 13 BY .69
     gn-prov.Telfnos[2] AT ROW 9.62 COL 52 COLON-ALIGNED
          LABEL "Teléfono[2]"
          VIEW-AS FILL-IN 
          SIZE 13 BY .69
     gn-prov.FaxPro AT ROW 10.42 COL 52 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .69
     gn-prov.E-Mail AT ROW 11.23 COL 52 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 26.14 BY .69
     gn-prov.Girpro AT ROW 12.58 COL 11 COLON-ALIGNED FORMAT "X(4)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     F-Giro AT ROW 12.58 COL 18 COLON-ALIGNED NO-LABEL
     gn-prov.CndCmp AT ROW 13.35 COL 11 COLON-ALIGNED
          LABEL "Cond. Compra"
          VIEW-AS FILL-IN 
          SIZE 5 BY .69
     F-DesCnd AT ROW 13.35 COL 18 COLON-ALIGNED NO-LABEL
     gn-prov.clfpro AT ROW 14.19 COL 11 COLON-ALIGNED
          LABEL "Clasificacion"
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "A","B","C" 
          DROP-DOWN-LIST
          SIZE 5.29 BY 1
     gn-prov.Flgsit AT ROW 15.54 COL 14 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Activo", "A":U,
"Cesado", "C":U
          SIZE 9.14 BY 1.38
     gn-prov.PrioridadPago AT ROW 17.15 COL 11 COLON-ALIGNED
          LABEL "Prioridad Pago"
          VIEW-AS FILL-IN 
          SIZE 2.14 BY .69
     x-DesPri AT ROW 17.15 COL 14 COLON-ALIGNED NO-LABEL
     gn-prov.Referencias AT ROW 13.15 COL 41 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 40 BY 3.08
     gn-prov.Telfnos[3] AT ROW 17.15 COL 65 COLON-ALIGNED
          LABEL "Cuenta Banco de la Nación" FORMAT "X(11)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .69
     gn-prov.Contactos[1] AT ROW 20.12 COL 14 COLON-ALIGNED
          LABEL "Gerente General"
          VIEW-AS FILL-IN 
          SIZE 40 BY .69
     gn-prov.Contactos[2] AT ROW 20.92 COL 14 COLON-ALIGNED
          LABEL "Ejecutivo Ventas"
          VIEW-AS FILL-IN 
          SIZE 40 BY .69
     gn-prov.Contactos[3] AT ROW 21.73 COL 14 COLON-ALIGNED
          LABEL "Dep. Marketing"
          VIEW-AS FILL-IN 
          SIZE 40 BY .69
     gn-prov.Contactos[4] AT ROW 22.54 COL 14 COLON-ALIGNED
          LABEL "Créditos y Cobr."
          VIEW-AS FILL-IN 
          SIZE 40 BY .69
     gn-prov.StkMin AT ROW 17.96 COL 15 COLON-ALIGNED WIDGET-ID 22
          LABEL "Stock minimo (dias)" FORMAT "ZZ9"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
     gn-prov.StkMax AT ROW 18.77 COL 15 COLON-ALIGNED WIDGET-ID 20
          LABEL "Stock maximo (dias)" FORMAT "ZZ9"
          VIEW-AS FILL-IN 
          SIZE 7 BY .69
     "Buen Contribuyente:" VIEW-AS TEXT
          SIZE 14 BY .5 AT ROW 2.08 COL 53 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     "Agente de Retención:" VIEW-AS TEXT
          SIZE 15 BY .5 AT ROW 1.27 COL 52 WIDGET-ID 10
     "Persona:" VIEW-AS TEXT
          SIZE 6 BY .5 AT ROW 2.08 COL 6
     "Origen:" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 1.27 COL 7
     "Situación:" VIEW-AS TEXT
          SIZE 7 BY .5 AT ROW 15.88 COL 4.57
     "Observaciones" VIEW-AS TEXT
          SIZE 11 BY .5 AT ROW 12.58 COL 41.14
     "Agente de Percepción:" VIEW-AS TEXT
          SIZE 16 BY .5 AT ROW 2.88 COL 51 WIDGET-ID 18
     RECT-1 AT ROW 15.27 COL 13.14
     RECT-4 AT ROW 19.85 COL 1
     RECT-3 AT ROW 12.31 COL 1
     RECT-6 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: integral.gn-prov
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
         HEIGHT             = 23.12
         WIDTH              = 85.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN gn-prov.ApeMat IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-prov.ApePat IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX gn-prov.clfpro IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-prov.CndCmp IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-prov.CodDept IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN gn-prov.CodDist IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN gn-prov.CodPais IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-prov.Codpos IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN gn-prov.CodPro IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-prov.CodProv IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN gn-prov.Contactos[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-prov.Contactos[2] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-prov.Contactos[3] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-prov.Contactos[4] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-prov.DirPro IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN F-Depa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-DesCnd IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Dist IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Giro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Pais IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-post IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-Prov IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-prov.FchAct IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-prov.Fching IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-prov.Girpro IN FRAME F-Main
   EXP-FORMAT                                                           */
/* SETTINGS FOR RADIO-SET gn-prov.Libre_c01 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET gn-prov.Libre_c02 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET gn-prov.Libre_c03 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN gn-prov.Libre_c05 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN gn-prov.PrioridadPago IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-prov.RepLegal IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-prov.Ruc IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-prov.StkMax IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-prov.StkMin IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN gn-prov.Telfnos[1] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-prov.Telfnos[2] IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN gn-prov.Telfnos[3] IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN x-DesPri IN FRAME F-Main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME gn-prov.ApeMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.ApeMat V-table-Win
ON LEAVE OF gn-prov.ApeMat IN FRAME F-Main /* Ap. Materno */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  gn-prov.NomPro:SCREEN-VALUE = TRIM(gn-prov.ApePat:SCREEN-VALUE) + ' ' +
                                TRIM(gn-prov.ApeMat:SCREEN-VALUE) + ', ' +
                                gn-prov.Nombre:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-prov.ApePat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.ApePat V-table-Win
ON LEAVE OF gn-prov.ApePat IN FRAME F-Main /* Ap. Paterno */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  gn-prov.NomPro:SCREEN-VALUE = TRIM(gn-prov.ApePat:SCREEN-VALUE) + ' ' +
                                TRIM(gn-prov.ApeMat:SCREEN-VALUE) + ', ' +
                                gn-prov.Nombre:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-prov.CndCmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.CndCmp V-table-Win
ON LEAVE OF gn-prov.CndCmp IN FRAME F-Main /* Cond. Compra */
DO:
    IF gn-prov.CndCmp:SCREEN-VALUE <> "" THEN DO:
        FIND cb-tabl WHERE
            cb-tabl.Tabla = "20" AND
            cb-tabl.Codigo = gn-prov.CndCmp:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF AVAILABLE cb-tabl THEN 
            F-DesCnd:SCREEN-VALUE = cb-tabl.Nombre.
        ELSE
            F-DesCnd:SCREEN-VALUE = "".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-prov.CodDept
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.CodDept V-table-Win
ON LEAVE OF gn-prov.CodDept IN FRAME F-Main /* Departamento */
DO:

    IF gn-prov.coddept:SCREEN-VALUE <> "" THEN DO:
        FIND TabDepto WHERE
            TabDepto.CodDepto = gn-prov.CodDept:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF AVAILABLE TabDepto THEN
            F-depa:SCREEN-VALUE = TabDepto.NomDepto.
        ELSE 
            F-depa:SCREEN-VALUE = "".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-prov.CodDist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.CodDist V-table-Win
ON LEAVE OF gn-prov.CodDist IN FRAME F-Main /* Distrito */
DO:
    IF gn-prov.coddist:SCREEN-VALUE <> "" THEN DO:
        FIND Tabdistr WHERE
            Tabdistr.CodDepto = gn-prov.CodDept:SCREEN-VALUE AND
            Tabdistr.Codprovi = gn-prov.codprov:SCREEN-VALUE AND
            Tabdistr.Coddistr = gn-prov.coddist:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE Tabdistr THEN 
            F-dist:SCREEN-VALUE = Tabdistr.Nomdistr.
        ELSE
            F-dist:SCREEN-VALUE = "".
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-prov.CodPais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.CodPais V-table-Win
ON LEAVE OF gn-prov.CodPais IN FRAME F-Main /* País */
DO:

    IF gn-prov.CodPais:SCREEN-VALUE <> "" THEN DO:
        FIND almtabla WHERE
            almtabla.Tabla = 'PA' AND
            almtabla.Codigo = gn-prov.CodPais:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN 
            F-pais:SCREEN-VALUE = almtabla.nombre.
        ELSE 
            F-pais:SCREEN-VALUE = "".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-prov.Codpos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.Codpos V-table-Win
ON LEAVE OF gn-prov.Codpos IN FRAME F-Main /* Postal */
DO:

    IF gn-prov.CodPos:SCREEN-VALUE <> "" THEN DO:
        FIND almtabla WHERE
            almtabla.Tabla = 'CP' AND
            almtabla.Codigo = gn-prov.CodPos:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN 
            F-POST:SCREEN-VALUE = almtabla.nombre.
        ELSE 
            F-POST:SCREEN-VALUE = "".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-prov.CodPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.CodPro V-table-Win
ON LEAVE OF gn-prov.CodPro IN FRAME F-Main /* Código */
DO:
   FIND gn-prov WHERE gn-prov.Codpro = gn-prov.Codpro:SCREEN-VALUE NO-LOCK NO-ERROR.
   IF AVAILABLE gn-prov THEN DO:
      message "Código de Proveedor YA EXISTE" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-prov.CodProv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.CodProv V-table-Win
ON LEAVE OF gn-prov.CodProv IN FRAME F-Main /* Provincias */
DO:

    IF gn-prov.codprov:SCREEN-VALUE <> "" THEN DO:
        FIND Tabprovi WHERE
            Tabprovi.CodDepto = gn-prov.CodDept:SCREEN-VALUE AND
            Tabprovi.Codprovi = gn-prov.codprov:SCREEN-VALUE
            NO-LOCK NO-ERROR.
        IF AVAILABLE Tabprovi THEN 
            f-prov:SCREEN-VALUE = Tabprovi.Nomprovi.
        ELSE
            f-prov:SCREEN-VALUE = "".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-prov.Girpro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.Girpro V-table-Win
ON LEAVE OF gn-prov.Girpro IN FRAME F-Main /* Giro Empr. */
DO:
    IF gn-prov.girpro:SCREEN-VALUE <> "" THEN DO:
        FIND Almtabla WHERE
            Almtabla.Codigo = gn-prov.girpro:SCREEN-VALUE AND
            Almtabla.Tabla = "GN" NO-LOCK NO-ERROR.
        IF AVAILABLE Almtabla THEN 
            F-giro:SCREEN-VALUE = Almtabla.Nombre.
        ELSE
            F-giro:SCREEN-VALUE = "".
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-prov.Nombre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.Nombre V-table-Win
ON LEAVE OF gn-prov.Nombre IN FRAME F-Main /* Nombres */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
  gn-prov.NomPro:SCREEN-VALUE = TRIM(gn-prov.ApePat:SCREEN-VALUE) + ' ' +
                                TRIM(gn-prov.ApeMat:SCREEN-VALUE) + ', ' +
                                gn-prov.Nombre:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-prov.NomPro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.NomPro V-table-Win
ON LEAVE OF gn-prov.NomPro IN FRAME F-Main /* Nombre */
DO:
  SELF:SCREEN-VALUE = CAPS(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-prov.Persona
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.Persona V-table-Win
ON VALUE-CHANGED OF gn-prov.Persona IN FRAME F-Main /* Persona */
DO:
  CASE SELF:SCREEN-VALUE:
    WHEN 'J' 
        THEN ASSIGN
                gn-prov.ApeMat:SENSITIVE = NO
                gn-prov.ApePat:SENSITIVE = NO
                gn-prov.Nombre:SENSITIVE = NO
                gn-prov.NomPro:SENSITIVE = YES
                gn-prov.ApeMat:SCREEN-VALUE = ''
                gn-prov.ApePat:SCREEN-VALUE = ''
                gn-prov.Nombre:SCREEN-VALUE = ''.
    WHEN 'N' 
        THEN ASSIGN
                gn-prov.ApeMat:SENSITIVE = YES
                gn-prov.ApePat:SENSITIVE = YES
                gn-prov.Nombre:SENSITIVE = YES
                gn-prov.NomPro:SENSITIVE = NO
                gn-prov.NomPro:SCREEN-VALUE = TRIM(gn-prov.ApePat:SCREEN-VALUE) + ' ' +
                                            TRIM(gn-prov.ApeMat:SCREEN-VALUE) + ', ' +
                                            gn-prov.Nombre:SCREEN-VALUE.
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gn-prov.PrioridadPago
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gn-prov.PrioridadPago V-table-Win
ON LEAVE OF gn-prov.PrioridadPago IN FRAME F-Main /* Prioridad Pago */
DO:
  FIND FacTabla WHERE FacTabla.codcia = s-codcia
    AND FacTabla.Tabla = 'PP'
    AND FacTabla.Codigo = gn-prov.PrioridadPago:SCREEN-VALUE
    NO-LOCK NO-ERROR.
  IF AVAILABLE FacTabla 
  THEN x-DesPri:SCREEN-VALUE = FacTabla.Nombre.
  ELSE x-DesPri:SCREEN-VALUE = ''.
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
  {src/adm/template/row-list.i "gn-prov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gn-prov"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  DO WITH FRAME {&FRAME-NAME}:
      ENABLE gn-prov.Libre_c01
             gn-prov.Libre_c02
             gn-prov.Libre_c03.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  
  DEFINE VARIABLE Libre01 AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE Libre02 AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE Libre03 AS CHARACTER   NO-UNDO.

  Libre01 = gn-prov.Libre_C01:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  Libre02 = gn-prov.Libre_C02:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  Libre03 = gn-prov.Libre_C03:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  ASSIGN gn-prov.CodCia = PV-CODCIA
         gn-prov.usuario = S-USER-ID 
         gn-prov.Libre_c01 = Libre01
         gn-prov.Libre_c02 = Libre02
         gn-prov.Libre_c03 = Libre03.


  DO WITH FRAME {&FRAME-NAME}:
      DISABLE
          gn-prov.Libre_c01
          gn-prov.Libre_c02
          gn-prov.Libre_c03.
  END.

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
  DO WITH FRAME {&FRAME-NAME}:
      DISABLE
          gn-prov.Libre_c01
          gn-prov.Libre_c02
          gn-prov.Libre_c03.
  END.
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
  
  MESSAGE 'Acceso denegado' VIEW-AS ALERT-BOX WARNING.
  RETURN 'ADM-ERROR'.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  
    IF AVAILABLE gn-prov THEN DO WITH FRAME {&FRAME-NAME}:
        ASSIGN
            F-Depa = ""
            F-DesCnd = ""
            F-Dist = ""
            F-Giro = ""
            F-Pais = ""
            F-Prov = "".
        FIND almtabla WHERE
            almtabla.Tabla = "PA" AND
            almtabla.Codigo = gn-prov.CodPais
            NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN F-Pais = almtabla.Nombre.

        FIND TabDepto WHERE
            TabDepto.CodDepto = gn-prov.CodDept
            NO-LOCK NO-ERROR.
        IF AVAILABLE TabDepto THEN
            F-depa = TabDepto.NomDepto.

        FIND Tabprovi WHERE
            Tabprovi.CodDepto = gn-prov.CodDept AND
            Tabprovi.Codprovi = gn-prov.codprov
            NO-LOCK NO-ERROR.
        IF AVAILABLE Tabprovi THEN 
            f-prov = Tabprovi.Nomprovi.

        FIND Tabdistr WHERE
            Tabdistr.CodDepto = gn-prov.CodDept AND
            Tabdistr.Codprovi = gn-prov.codprov AND
            Tabdistr.Coddistr = gn-prov.coddist NO-LOCK NO-ERROR.
        IF AVAILABLE Tabdistr THEN 
            F-dist = Tabdistr.Nomdistr.

        FIND almtabla WHERE
            almtabla.Tabla = "GN" AND
            almtabla.Codigo = gn-prov.Girpro NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN F-Giro = almtabla.Nombre.

        FIND almtabla WHERE
            almtabla.Tabla = 'CP' AND 
            almtabla.Codigo = integral.gn-prov.CodPos NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN F-POST = almtabla.nombre.

        FIND cb-tabl WHERE
            cb-tabl.Tabla = "20" AND
            cb-tabl.Codigo = gn-prov.CndCmp NO-LOCK NO-ERROR.
        IF AVAILABLE cb-tabl THEN F-DesCnd = cb-tabl.Nombre.

        DISPLAY
            F-Depa
            F-DesCnd
            F-Dist
            F-Giro
            F-Pais
            F-Post
            F-Prov.

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
  DO WITH FRAME {&FRAME-NAME}:
  CASE gn-prov.persona:SCREEN-VALUE:
    WHEN 'J' 
        THEN ASSIGN
                gn-prov.ApeMat:SENSITIVE = NO
                gn-prov.ApePat:SENSITIVE = NO
                gn-prov.Nombre:SENSITIVE = NO
                gn-prov.NomPro:SENSITIVE = YES.
    WHEN 'N' 
        THEN ASSIGN
                gn-prov.ApeMat:SENSITIVE = YES
                gn-prov.ApePat:SENSITIVE = YES
                gn-prov.Nombre:SENSITIVE = YES
                gn-prov.NomPro:SENSITIVE = NO.
  END CASE.
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

/*MLR* 08/11/07 ***
  /* Code placed here will execute AFTER standard behavior.    */
    RUN ADM/D-prov.r .
* ***/

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

DO WITH FRAME {&FRAME-NAME}:
    CASE HANDLE-CAMPO:name:
        WHEN "CodDist" THEN ASSIGN input-var-1 = gn-prov.CodDept:SCREEN-VALUE
                                   input-var-2 = gn-prov.CodProv:SCREEN-VALUE.
        WHEN "CodPais" THEN ASSIGN input-var-1 = "PA". 
        WHEN "CodProv" THEN ASSIGN input-var-1 = gn-prov.CodDept:SCREEN-VALUE.
        WHEN "CndCmp"  THEN ASSIGN input-var-1 = "20".
        WHEN "Codpos"  THEN ASSIGN input-var-1 = "CP".
        WHEN "Girpro"  THEN ASSIGN input-var-1 = "GN".
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.
END.
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
  {src/adm/template/snd-list.i "gn-prov"}

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

  GN-PROV.CODPRO:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
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
DEFINE VAR x-ruc-valida AS CHAR.
    
    DO WITH FRAME {&FRAME-NAME}:
        /*Valida Codigo*/
        IF gn-prov.CodPro:SCREEN-VALUE = "" THEN DO:
            MESSAGE "Codigo Registro en Blanco"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            APPLY 'Entry':U TO gn-prov.codpro.
            RETURN 'ADM-ERROR'.            
        END.
        IF LENGTH(gn-prov.CodPro:SCREEN-VALUE) <> 8 THEN DO:
            MESSAGE "El codigo debe tener 8 digitos"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            APPLY 'Entry':U TO gn-prov.codpro.
            RETURN 'ADM-ERROR'.            
        END.

        IF gn-prov.PrioridadPago:SCREEN-VALUE <> '' THEN DO:
            FIND FacTabla WHERE FacTabla.codcia = s-codcia
                AND FacTabla.Tabla = 'PP'
                AND FacTabla.Codigo = gn-prov.PrioridadPago:SCREEN-VALUE
                NO-LOCK NO-ERROR.
            IF NOT AVAILABLE FacTabla THEN DO:
                MESSAGE 'Prioridad de Pago no registrado' VIEW-AS ALERT-BOX ERROR.
                RETURN 'ADM-ERROR'.
            END.
        END.
        IF gn-prov.tpopro:SCREEN-VALUE = 'N':U THEN DO:
            IF gn-prov.coddept:SCREEN-VALUE = '':U OR
                gn-prov.codprov:SCREEN-VALUE = '':U OR
                gn-prov.coddist:SCREEN-VALUE = '':U THEN DO:
                MESSAGE
                    "Proveedor Nacional debe regitrar Departamento, Provincia y Distrito"
                    VIEW-AS ALERT-BOX ERROR.
                APPLY 'Entry':U TO gn-prov.coddist.
                RETURN 'ADM-ERROR'.
            END.
            /* Valida Ubigeo */
            FIND FIRST tabdistr WHERE tabdistr.coddepto = gn-prov.coddept:SCREEN-VALUE AND 
                                        tabdistr.codprovi = gn-prov.codprov:SCREEN-VALUE AND 
                                        tabdistr.coddistr = gn-prov.coddist:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF NOT AVAILABLE tabdistr THEN DO:
                MESSAGE
                    "Codigo de UBIGEO no existe"
                    VIEW-AS ALERT-BOX ERROR.
                APPLY 'Entry':U TO gn-prov.coddept.
                RETURN 'ADM-ERROR'.
            END.
            IF LENGTH(gn-prov.ruc:SCREEN-VALUE) <> 11 THEN DO:
                MESSAGE
                    "Proveedor Nacional debe regitrar R.U.C. correcto"
                    VIEW-AS ALERT-BOX ERROR.
                APPLY 'Entry':U TO gn-prov.ruc.
                RETURN 'ADM-ERROR'.
            END.
            /* Validar estructura del RUC */            
            RUN lib/_valruc.r(gn-prov.ruc:SCREEN-VALUE, OUTPUT x-ruc-valida).

            IF x-ruc-valida = "ERROR" THEN DO:
                MESSAGE
                    "El R.U.C. no tiene la estructura CORRECTA"
                    VIEW-AS ALERT-BOX ERROR.
                APPLY 'Entry':U TO gn-prov.ruc.
                RETURN 'ADM-ERROR'.
            END.
        END.

        IF gn-prov.replegal:SCREEN-VALUE <> '' 
                AND gn-prov.replegal:SCREEN-VALUE <> gn-prov.codpro:SCREEN-VALUE  THEN DO:
            IF NOT CAN-FIND(FIRST gn-prov WHERE gn-prov.codcia = pv-codcia
                            AND gn-prov.codpro = gn-prov.replegal:SCREEN-VALUE NO-LOCK)
            THEN DO:
                MESSAGE 'Error en el Código AGRUPADOR' VIEW-AS ALERT-BOX ERROR.
                APPLY 'ENTRY':U TO gn-prov.replegal.
                RETURN 'ADM-ERROR'.
            END.
        END.
    END.
    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

