&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
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
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR pv-codcia AS INT.
DEF SHARED VAR s-clave AS CHAR.
DEF SHARED VAR s-codigo AS CHAR.

RUN Crea-Registro.


DEFINE TEMP-TABLE tt-qstock
    FIELDS almgrpo   AS CHAR FORMAT 'x(20)' COLUMN-LABEL "Grupo" INIT ""    /*x*/
    FIELDS codalm    AS CHAR FORMAT 'x(3)' COLUMN-LABEL "Cod.Alm"
    FIELDS desalm    AS CHAR FORMAT 'x(50)' COLUMN-LABEL "Almacen"
    FIELDS proveedor AS CHAR FORMAT 'x(80)' COLUMN-LABEL "Proveedor"
    FIELDS linea     AS CHAR FORMAT 'x(60)' COLUMN-LABEL "Linea"
    FIELDS sublinea  AS CHAR FORMAT 'x(60)' COLUMN-LABEL "Sub Linea"
    FIELDS corigen   AS CHAR FORMAT 'x(25)' COLUMN-LABEL "Propio/Tercero" INIT ""
    FIELDS codmat    AS CHAR FORMAT 'x(6)' COLUMN-LABEL "Cod.Articulo"
    FIELDS desmat    AS CHAR FORMAT 'x(50)' COLUMN-LABEL "Descripcion"
    FIELDS marca     AS CHAR FORMAT 'x(50)' COLUMN-LABEL "Marca"
    FIELDS umed      AS CHAR FORMAT 'x(7)' COLUMN-LABEL "U.Medida"
    FIELDS cgrlc     AS CHAR FORMAT 'x(2)' COLUMN-LABEL "Clsf Gral Campaña"           
    FIELDS cmayc     AS CHAR FORMAT 'x(2)' COLUMN-LABEL "Clsf Mayorista Campaña"      
    FIELDS cutxc     AS CHAR FORMAT 'x(2)' COLUMN-LABEL "Clsf Utilex Campaña"         
    FIELDS cgrlnc    AS CHAR FORMAT 'x(2)' COLUMN-LABEL "Clsf Gral NoCampaña"         
    FIELDS cmaync    AS CHAR FORMAT 'x(2)' COLUMN-LABEL "Clsf Mayorista NoCampaña"    
    FIELDS cutxnc    AS CHAR FORMAT 'x(2)' COLUMN-LABEL "Clsf Utilex NoCampaña"       
    FIELDS costrepo  AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Costo Reposicion S/ (G)"  
    FIELDS peso      AS DEC FORMAT '->>,>>9.9999'   COLUMN-LABEL "Peso Kg" INIT 0  /*x*/
    FIELDS volumen   AS DEC FORMAT '->>,>>9.9999'   COLUMN-LABEL "m3"   INIT 0       /*x*/
    FIELDS stkmax    AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Maximo (E)"
    FIELDS stkseg    AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Seguridad (Z)"
    FIELDS emprep    AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Empaque Reposicion"
    FIELDS stkfisico AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Fisico (A)"
    FIELDS stkreser  AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Reservado (B)"
    FIELDS stkdispo  AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock a disponer D = (A - B)"
    FIELDS stktrftra AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Trans en Transito (C)"    
    FIELDS cmptra    AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Compras en Transito (Y)"        
    FIELDS stkfalta  AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Faltante F = (E - D - C - Y)"      
    FIELDS stkfalta2 AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Faltante XX = (E - Z - D - C - Y)" INIT 0    /*x*/
    FIELDS stkt11    AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Disp 11"
    FIELDS stkt11max AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Maximo 11"  
    FIELDS stkt11seg AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Seguridad 11"  
    FIELDS stkt35    AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Disp 35"
    FIELDS stkt35max AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Maximo 35" 
    FIELDS stkt35seg AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Seguridad 35" 
    FIELDS stkt14    AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Disp 14"        
    FIELDS stkt14f   AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Disp 14F"       
    FIELDS stkt21    AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Stock Disp 21"
    FIELDS vstkmax   AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Valorizado Stk Maximo (G * E)"
    FIELDS vsfisico  AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Valorizado Stk Fisico (G * A)"
    FIELDS vsdispo   AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Valorizado Stk Disponible (G * D)"     
    FIELDS vstrans   AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Valorizado Stk Transito (G * C)"     
    FIELDS costfalta AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Valorizado Faltantes (-) S/ H = (G * F)"
    FIELDS costfalta1 AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Valorizado Faltantes (+) S/ H = (G * F)" INIT 0
    FIELDS costfalta3 AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Valorizado Faltantes (-) S/ H = (G * XX)" INIT 0    /*x*/
    FIELDS costfalta31 AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Valorizado Faltantes (+) S/ H = (G * XX)" INIT 0    /*x*/
    FIELDS vta15dant AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 15 atras"          
    FIELDS vta30dant AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 30 atras"          
    FIELDS vta45dant AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 45 atras"          
    FIELDS v30daante AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 30 atras Año anterior"          
    FIELDS vta30dap  AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 30 dias adelante año pasado" INIT 0 /*x*/
    FIELDS vta60dap  AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 60 dias adelante año pasado" INIT 0 /*x*/
    FIELDS vta90dap  AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 90 dias adelante año pasado" INIT 0 /*x*/
    FIELDS fv30_max  AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 30 dias Atras/Maximo"          
    FIELDS fv30p_max AS DEC FORMAT "->>,>>>,>>9.99" COLUMN-LABEL "Vta 30 dias Año pasado/Maximo"
    INDEX idx01 almgrpo codalm codmat.

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
&Scoped-define EXTERNAL-TABLES TabGener
&Scoped-define FIRST-EXTERNAL-TABLE TabGener


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR TabGener.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TabGener.Libre_c01 TabGener.Libre_c02 ~
TabGener.Libre_c03 TabGener.Libre_c04 
&Scoped-define ENABLED-TABLES TabGener
&Scoped-define FIRST-ENABLED-TABLE TabGener
&Scoped-Define ENABLED-OBJECTS RECT-9 RECT-10 
&Scoped-Define DISPLAYED-FIELDS TabGener.Libre_c01 TabGener.Libre_c02 ~
TabGener.Libre_c03 TabGener.Libre_c04 TabGener.Libre_d01 TabGener.LlaveIni ~
TabGener.LlaveFin 
&Scoped-define DISPLAYED-TABLES TabGener
&Scoped-define FIRST-DISPLAYED-TABLE TabGener
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-NomPro 

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
DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/search.ico":U
     LABEL "Button 3" 
     SIZE 7 BY 1.62.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/search.ico":U
     LABEL "Button 4" 
     SIZE 7 BY 1.62.

DEFINE BUTTON BUTTON-5 
     IMAGE-UP FILE "img/search.ico":U
     LABEL "Button 5" 
     SIZE 7 BY 1.62.

DEFINE VARIABLE FILL-IN-NomPro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 44 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 2.42.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 14.81.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     TabGener.Libre_c01 AT ROW 2.08 COL 16 NO-LABEL WIDGET-ID 8
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 30 BY 4
     BUTTON-3 AT ROW 2.08 COL 47 WIDGET-ID 22
     TabGener.Libre_c02 AT ROW 6.12 COL 16 NO-LABEL WIDGET-ID 12
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 30 BY 4
     BUTTON-4 AT ROW 6.12 COL 47 WIDGET-ID 24
     TabGener.Libre_c03 AT ROW 10.15 COL 16 NO-LABEL WIDGET-ID 16
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 30 BY 4
     BUTTON-5 AT ROW 10.15 COL 47 WIDGET-ID 26
     TabGener.Libre_c04 AT ROW 14.19 COL 14 COLON-ALIGNED WIDGET-ID 2
          LABEL "Proveedor" FORMAT "x(8)"
          VIEW-AS FILL-IN 
          SIZE 10 BY .81
     FILL-IN-NomPro AT ROW 14.19 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 30
     TabGener.Libre_d01 AT ROW 15 COL 14 COLON-ALIGNED WIDGET-ID 20
          LABEL "% Evaluación" FORMAT ">>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 8.57 BY .81
     TabGener.LlaveIni AT ROW 16.88 COL 13 COLON-ALIGNED WIDGET-ID 38
          LABEL "Inició"
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     TabGener.LlaveFin AT ROW 17.69 COL 13 COLON-ALIGNED WIDGET-ID 36
          LABEL "Terminó"
          VIEW-AS FILL-IN 
          SIZE 16 BY .81
     "Información de la generación del reporte" VIEW-AS TEXT
          SIZE 28 BY .5 AT ROW 16.08 COL 3 WIDGET-ID 40
          BGCOLOR 9 FGCOLOR 15 
     "Almacenes:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 2.08 COL 7 WIDGET-ID 10
     "Familias:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 6.12 COL 7 WIDGET-ID 14
     "Marcas:" VIEW-AS TEXT
          SIZE 8 BY .5 AT ROW 10.15 COL 7 WIDGET-ID 18
     "Parámetros para generar el reporte en el proceso nocturno" VIEW-AS TEXT
          SIZE 40 BY .5 AT ROW 1.27 COL 3 WIDGET-ID 32
          BGCOLOR 9 FGCOLOR 15 
     RECT-9 AT ROW 1.54 COL 2 WIDGET-ID 34
     RECT-10 AT ROW 16.35 COL 2 WIDGET-ID 42
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: INTEGRAL.TabGener
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
         HEIGHT             = 19.12
         WIDTH              = 78.43.
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

/* SETTINGS FOR BUTTON BUTTON-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-4 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-5 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-NomPro IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN TabGener.Libre_c04 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN TabGener.Libre_d01 IN FRAME F-Main
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
ASSIGN 
       TabGener.Libre_d01:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN TabGener.LlaveFin IN FRAME F-Main
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN TabGener.LlaveIni IN FRAME F-Main
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

&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 V-table-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
  DEF VAR pAlmacenes AS CHAR NO-UNDO.
  pAlmacenes = TabGener.Libre_c01:SCREEN-VALUE.
  RUN alm/d-almacen (INPUT-OUTPUT pAlmacenes).
  TabGener.Libre_c01:SCREEN-VALUE = pAlmacenes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 V-table-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
    DEF VAR pFamilias AS CHAR NO-UNDO.
    pFamilias = TabGener.Libre_c02:SCREEN-VALUE.
    RUN alm/d-familias (INPUT-OUTPUT pFamilias).
    TabGener.Libre_c02:SCREEN-VALUE = pFamilias.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 V-table-Win
ON CHOOSE OF BUTTON-5 IN FRAME F-Main /* Button 5 */
DO:
    DEF VAR pMarcas AS CHAR NO-UNDO.
    pMarcas = TabGener.Libre_c03:SCREEN-VALUE.
    RUN alm/d-marcas (INPUT-OUTPUT pMarcas).
    TabGener.Libre_c03:SCREEN-VALUE = pMarcas.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TabGener.Libre_c04
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TabGener.Libre_c04 V-table-Win
ON LEAVE OF TabGener.Libre_c04 IN FRAME F-Main /* Proveedor */
DO:
  FIND gn-prov WHERE gn-prov.CodCia = pv-codcia
      AND gn-prov.CodPro = SELF:SCREEN-VALUE
      NO-LOCK NO-ERROR.
  FILL-IN-NomPro:SCREEN-VALUE = ''.
  IF AVAILABLE gn-prov THEN FILL-IN-NomPro:SCREEN-VALUE = gn-prov.NomPro.
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
  {src/adm/template/row-list.i "TabGener"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "TabGener"}

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

EMPTY TEMP-TABLE tt-qstock.

DEFINE VAR lStkFalta_xx AS DEC.
DEFINE VAR lStkFalta_xx_valorizado AS DEC.

FOR EACH almacen_quiebre NO-LOCK:
    CREATE tt-qstock.
    BUFFER-COPY Almacen_Quiebre TO tt-qstock.
    ASSIGN
        tt-qstock.stkt11    = almacen_quiebre.StkAlm[1] 
        tt-qstock.stkt11max = almacen_quiebre.StkAlmMax[1] 
        tt-qstock.stkt11seg = almacen_quiebre.StkAlmSeg[1] 
        tt-qstock.stkt35    = almacen_quiebre.StkAlm[2] 
        tt-qstock.stkt35max = almacen_quiebre.StkAlmMax[2] 
        tt-qstock.stkt35seg = almacen_quiebre.StkAlmSeg[2] 
        tt-qstock.stkt14    = almacen_quiebre.StkAlm[3] 
        tt-qstock.stkt14f   = almacen_quiebre.StkAlm[4] 
        tt-qstock.stkt21    = almacen_quiebre.StkAlm[5] .

    IF tt-qstock.costfalta > 0  THEN DO:
        /* Los Positivos */
        ASSIGN tt-qstock.costfalta1 = tt-qstock.costfalta
                tt-qstock.costfalta = 0.
    END.

    lStkFalta_xx = tt-qstock.stkmax - tt-qstock.stkseg - tt-qstock.stkdispo -
                    tt-qstock.stktrftra - tt-qstock.cmptra.
    ASSIGN tt-qstock.stkfalta2 = lStkFalta_xx.

    lStkFalta_xx_valorizado = lStkFalta_xx * tt-qstock.costrepo.
    ASSIGN tt-qstock.costfalta3 = lStkFalta_xx_valorizado.

    IF lStkFalta_xx_valorizado > 0 THEN DO:
        ASSIGN tt-qstock.costfalta31 = lStkFalta_xx_valorizado
                tt-qstock.costfalta3 = 0.
    END.

    ASSIGN tt-qstock.corigen = '??????'.
    FIND FIRST almmmatg WHERE almmmatg.codcia = s-codcia AND 
                                almmmatg.codmat = almacen_quiebre.codmat NO-LOCK NO-ERROR.
    IF AVAILABLE almmmatg THEN DO:
        ASSIGN tt-qstock.corigen = 'TERCERO'.
        IF almmmatg.CHR__02 = 'P' THEN ASSIGN tt-qstock.corigen = 'PROPIO'.
        ASSIGN tt-qstock.peso = almmmatg.pesmat
                tt-qstock.volumen = almmmatg.libre_d02.
    END.
    /* Grupo del Almacen */    
    FIND FIRST tabgener WHERE tabgener.codcia = s-codcia AND 
                                tabgener.clave = 'ZG' AND
                                tabgener.libre_c01 = tt-qstock.codalm NO-LOCK NO-ERROR.
    IF AVAILABLE tabgener THEN DO:
        ASSIGN tt-qstock.almgrpo = tabgener.codigo.
    END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Registro V-table-Win 
PROCEDURE Crea-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST TabGener WHERE TabGener.CodCia = s-codcia
    AND TabGener.Clave = s-clave
    AND TabGener.Codigo = s-codigo
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE TabGener THEN DO:
    CREATE TabGener.
    ASSIGN
        TabGener.CodCia = s-codcia
        TabGener.Clave = s-clave
        TabGener.Codigo = s-codigo.
    RELEASE TabGener.
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
      DISABLE BUTTON-3 BUTTON-4 BUTTON-5 WITH FRAME {&FRAME-NAME}.
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
      ENABLE BUTTON-3 BUTTON-4 BUTTON-5 WITH FRAME {&FRAME-NAME}.
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
  {src/adm/template/snd-list.i "TabGener"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-excel V-table-Win 
PROCEDURE ue-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR rpta AS LOG.
DEFINE VAR lxFile AS CHAR.

SYSTEM-DIALOG GET-FILE lxFile
    FILTERS 'Excel (*.xlsx)' '*.xlsx'
    ASK-OVERWRITE
    CREATE-TEST-FILE
    DEFAULT-EXTENSION '.xlsx'
    RETURN-TO-START-DIR
    SAVE-AS
    TITLE 'Exportar a Excel'
    UPDATE rpta.
IF rpta = NO OR lxFile = '' THEN RETURN.

SESSION:SET-WAIT-STATE('GENERAL').
RUN Carga-Temporal.

FIND FIRST tt-qstock NO-ERROR.

IF NOT AVAILABLE tt-qstock THEN DO:
    SESSION:SET-WAIT-STATE('').
    MESSAGE "No  existe data".
    RETURN.
END.

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN lib\Tools-to-excel PERSISTENT SET hProc.

def var c-csv-file as char no-undo.
def var c-xls-file as char no-undo. /* will contain the XLS file path created */

c-xls-file = lxFile.

run pi-crea-archivo-csv IN hProc (input  buffer tt-qstock:handle,
                        /*input  session:temp-directory + "file"*/ c-xls-file,
                        output c-csv-file) .

run pi-crea-archivo-xls  IN hProc (input  buffer tt-qstock:handle,
                        input  c-csv-file,
                        output c-xls-file) .

DELETE PROCEDURE hProc.
SESSION:SET-WAIT-STATE('').

MESSAGE "Proceso Concluido".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida V-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INT NO-UNDO.
DO WITH FRAME {&FRAME-NAME} :
    DO k = 1 TO NUM-ENTRIES(TabGener.Libre_c01:SCREEN-VALUE):
        FIND Almacen WHERE Almacen.CodCia = s-codcia
            AND Almacen.CodAlm = ENTRY(k,TabGener.Libre_c01:SCREEN-VALUE)
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almacen THEN DO:
            MESSAGE 'Almacén =' ENTRY(k,TabGener.Libre_c01:SCREEN-VALUE) 'NO existe' SKIP
                'Proceda a corregir el dato' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO TabGener.Libre_c01.
            RETURN 'ADM-ERROR'.
        END.
    END.
    DO k = 1 TO NUM-ENTRIES(TabGener.Libre_c02:SCREEN-VALUE):
        FIND Almtfami WHERE Almtfami.CodCia = s-codcia
            AND Almtfami.CodFam = ENTRY(k,TabGener.Libre_c02:SCREEN-VALUE)
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtfami THEN DO:
            MESSAGE 'Familia =' ENTRY(k,TabGener.Libre_c02:SCREEN-VALUE) 'NO existe' SKIP
                'Proceda a corregir el dato' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO TabGener.Libre_c02.
            RETURN 'ADM-ERROR'.
        END.
    END.
    DO k = 1 TO NUM-ENTRIES(TabGener.Libre_c03:SCREEN-VALUE):
        FIND Almtabla WHERE almtabla.Tabla = "MK"
            AND almtabla.Codigo = ENTRY(k,TabGener.Libre_c03:SCREEN-VALUE)
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtabla THEN DO:
            MESSAGE 'Marca =' ENTRY(k,TabGener.Libre_c03:SCREEN-VALUE) 'NO existe' SKIP
                'Proceda a corregir el dato' VIEW-AS ALERT-BOX ERROR.
            APPLY 'ENTRY':U TO TabGener.Libre_c03.
            RETURN 'ADM-ERROR'.
        END.
    END.
    FIND gn-prov WHERE gn-prov.CodCia = pv-codcia
        AND gn-prov.CodPro = TabGener.Libre_c04:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF TabGener.Libre_c04:SCREEN-VALUE > '' AND NOT AVAILABLE gn-prov THEN DO:
        MESSAGE 'Proveedor NO registrado' SKIP 'Proceda a corregir el dato'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO TabGener.Libre_c04.
        RETURN 'ADM-ERROR'.
    END.
    /*
        Ic - 23Ago2017, Max Ramos
    IF DECIMAL(TabGener.Libre_d01:SCREEN-VALUE) <= 0 THEN DO:
        MESSAGE '% de Evaluación no puede ser cero' SKIP 'Proceda a corregir el dato'
            VIEW-AS ALERT-BOX ERROR.
        APPLY 'ENTRY':U TO TabGener.Libre_d01.
        RETURN 'ADM-ERROR'.
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
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

