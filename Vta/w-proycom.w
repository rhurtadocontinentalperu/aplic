&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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

DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.
DEFINE STREAM report.
DEFINE NEW SHARED VARIABLE xTerm AS CHARACTER INITIAL "".
DEFINE NEW SHARED VARIABLE s-aplic-id LIKE Modulos.Modulo.
DEFINE NEW SHARED VARIABLE s-user-id  LIKE _user._userid.
 
def var l-immediate-display  AS LOGICAL.
DEFINE VARIABLE cb-codcia AS INTEGER INITIAL 0.
/* DEFINE VARIABLE pv-codcia AS INTEGER INITIAL 0. */
DEFINE VARIABLE cl-codcia AS INTEGER INITIAL 0.
DEFINE VARIABLE PTO       AS LOGICAL.

DEFINE VARIABLE F-TIPO   AS CHAR INIT "0".
DEFINE VARIABLE T-TITULO AS CHAR INIT "".
DEFINE VARIABLE T-TITUL1 AS CHAR INIT "".
DEFINE VARIABLE T-FAMILI AS CHAR INIT "".
DEFINE VARIABLE T-SUBFAM AS CHAR INIT "".
DEFINE VARIABLE X-MON    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE X-EST    AS CHAR FORMAT "X(3)".
DEFINE VARIABLE L-SALIR  AS LOGICAL INIT NO.

/*VARIABLES GLOBALES */
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR PV-CODCIA AS INTEGER.
DEFINE SHARED VAR S-CODDIV  AS CHAR.
DEFINE SHARED VAR S-NOMCIA  AS CHAR.
DEFINE SHARED VAR S-CODALM  AS CHAR.
DEFINE VARIABLE F-DIRDIV    AS CHAR.
DEFINE VARIABLE F-PUNTO     AS CHAR.
DEFINE VARIABLE X-PUNTO     AS CHAR.
DEFINE VARIABLE X-DIVI      AS CHAR INIT "00000".
DEFINE VARIABLE X-CODALM    AS CHAR INIT "".
DEFINE VARIABLE X-CODDIV    AS CHAR INIT "".


DEFINE TEMP-TABLE Temporal 
       FIELD CODCIA    LIKE CcbcDocu.Codcia
       FIELD PERIODO   AS  INTEGER FORMAT "9999"
       FIELD CODMAT    LIKE Almmmatg.Codmat
       FIELD DESMAT    LIKE Almmmatg.DesMat
       FIELD DESMAR    LIKE Almmmatg.DesMar
       FIELD UNIDAD    LIKE Almmmatg.UndStk
       FIELD CLASE     AS   CHAR FORMAT "X(1)"
       FIELD ENE       AS   DECI EXTENT 2
       FIELD FEB       AS   DECI EXTENT 2
       FIELD MAR       AS   DECI EXTENT 2
       FIELD ABR       AS   DECI EXTENT 2
       FIELD MAY       AS   DECI EXTENT 2
       FIELD JUN       AS   DECI EXTENT 2
       FIELD JUL       AS   DECI EXTENT 2
       FIELD AGO       AS   DECI EXTENT 2
       FIELD SEP       AS   DECI EXTENT 2
       FIELD OCT       AS   DECI EXTENT 2
       FIELD NOV       AS   DECI EXTENT 2
       FIELD DIC       AS   DECI EXTENT 2
       FIELD TOT       AS   DECI EXTENT 2
       FIELD STK       AS   DECI EXTENT 2
       FIELD CodPr1    LIKE Almmmatg.CodPr1
       FIELD Nompro    LIKE GN-PROV.Nompro
       FIELD Ctotot    LIKE Almmmatg.Ctotot
       INDEX LLAVE01 CODCIA CODMAT PERIODO .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-70 RECT-71 F-prov1 F-prov2 f-desde ~
f-hasta f-cate R-Orden R-Zona BUTTON-6 BUTTON-3 BUTTON-4 
&Scoped-Define DISPLAYED-OBJECTS F-prov1 F-prov2 f-desde f-hasta f-cate ~
R-Orden R-Zona txt-msj 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-3 
     IMAGE-UP FILE "img/excel.bmp":U
     LABEL "Button 3" 
     SIZE 9.29 BY 1.5.

DEFINE BUTTON BUTTON-4 
     IMAGE-UP FILE "img/b-cancel.bmp":U
     LABEL "Button 4" 
     SIZE 15 BY 1.5.

DEFINE BUTTON BUTTON-6 
     IMAGE-UP FILE "img/b-ok.bmp":U
     LABEL "Button 6" 
     SIZE 15 BY 1.5.

DEFINE VARIABLE f-cate AS CHARACTER FORMAT "X":U 
     LABEL "Categoria" 
     VIEW-AS FILL-IN 
     SIZE 3.72 BY .81 NO-UNDO.

DEFINE VARIABLE f-desde AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE f-hasta AS DATE FORMAT "99/99/9999":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-prov1 AS CHARACTER FORMAT "X(8)":U 
     LABEL "Proveedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE F-prov2 AS CHARACTER FORMAT "X(8)":U 
     LABEL "A" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE txt-msj AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 69 BY .81
     BGCOLOR 1 FGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE R-Orden AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Codigo", 1,
"Descripcion", 2
     SIZE 10.86 BY 1.69 NO-UNDO.

DEFINE VARIABLE R-Zona AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ate", 1,
"Lima", 2
     SIZE 8.57 BY 1.62 NO-UNDO.

DEFINE RECTANGLE RECT-70
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70.57 BY 7.58.

DEFINE RECTANGLE RECT-71
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70.43 BY 2.15.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     F-prov1 AT ROW 1.69 COL 9.29 COLON-ALIGNED WIDGET-ID 82
     F-prov2 AT ROW 1.69 COL 23.43 COLON-ALIGNED WIDGET-ID 84
     f-desde AT ROW 2.77 COL 9.29 COLON-ALIGNED WIDGET-ID 78
     f-hasta AT ROW 2.77 COL 23.57 COLON-ALIGNED WIDGET-ID 80
     f-cate AT ROW 3.85 COL 9.29 COLON-ALIGNED WIDGET-ID 76
     R-Orden AT ROW 5.15 COL 29.14 NO-LABEL WIDGET-ID 86
     R-Zona AT ROW 5.23 COL 11.29 NO-LABEL WIDGET-ID 90
     txt-msj AT ROW 7.73 COL 2 NO-LABEL WIDGET-ID 30
     BUTTON-6 AT ROW 9.19 COL 31.14 WIDGET-ID 98
     BUTTON-3 AT ROW 9.19 COL 46.72 WIDGET-ID 24
     BUTTON-4 AT ROW 9.19 COL 56.57 WIDGET-ID 26
     "Zona" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 5.46 COL 5 WIDGET-ID 96
          FONT 1
     "Orden" VIEW-AS TEXT
          SIZE 5 BY .5 AT ROW 5.5 COL 22 WIDGET-ID 94
          FONT 1
     RECT-70 AT ROW 1.23 COL 1.57 WIDGET-ID 20
     RECT-71 AT ROW 8.81 COL 2 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72.72 BY 10.35
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Reporte de Ventas(Proyeccion de Compras)"
         HEIGHT             = 10.35
         WIDTH              = 72.72
         MAX-HEIGHT         = 10.35
         MAX-WIDTH          = 72.75
         VIRTUAL-HEIGHT     = 10.35
         VIRTUAL-WIDTH      = 72.75
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}
{src/adm-vm/method/vmviewer.i}
{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN txt-msj IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Reporte de Ventas(Proyeccion de Compras) */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Reporte de Ventas(Proyeccion de Compras) */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 W-Win
ON CHOOSE OF BUTTON-3 IN FRAME F-Main /* Button 3 */
DO:
    ASSIGN f-prov1 f-prov2 f-cate R-zona f-desde f-hasta R-Orden.

    IF F-prov2 = "" THEN F-prov2 = "ZZZZZZZZZZZZZ".

    RUN Carga-Tabla.

    DISPLAY "Cargando Información..." @ txt-msj WITH FRAME {&FRAME-NAME}.
    CASE R-Orden :
       WHEN 1 THEN RUN Exporta.
       WHEN 2 THEN RUN Exporta2.
    END.
    DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 W-Win
ON CHOOSE OF BUTTON-4 IN FRAME F-Main /* Button 4 */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 W-Win
ON CHOOSE OF BUTTON-6 IN FRAME F-Main /* Button 6 */
DO:

    ASSIGN f-prov1 f-prov2 f-cate R-zona f-desde f-hasta R-Orden.
  
    IF F-prov2 = "" THEN F-prov2 = "ZZZZZZZZZZZZZ".


    IF MONTH(F-DESDE) > 5 OR MONTH(F-HASTA) > 5 THEN DO:
        MESSAGE "Solo Meses menores o iguales a Mayo " SKIP
                "Si quiere trabajar con todos los Meses " SKIP
                "Elija la Opcion por Excel    "  VIEW-AS ALERT-BOX ERROR.
        
        RETURN NO-APPLY.
    END.

    IF YEAR(F-DESDE) <> YEAR(F-HASTA) THEN DO:
        MESSAGE "Solo Para Fechas dentro del mismo Año " SKIP
                "Si quiere trabajar con Fechas en diferentes Años " SKIP
                "Elija la Opcion por Excel    "  VIEW-AS ALERT-BOX ERROR.
        
        RETURN NO-APPLY.
    END.


    DISPLAY "Cargando Información..." @ txt-msj WITH FRAME {&FRAME-NAME}.
    RUN Imprimir.
    DISPLAY "" @ txt-msj WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-cate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cate W-Win
ON LEAVE OF f-cate IN FRAME F-Main /* Categoria */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND PORCOMI WHERE PORCOMI.CODCIA = S-CODCIA 
                AND  PORCOMI.CATEGO = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE PORCOMI THEN DO:
    MESSAGE "Categoria no Existe " VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO F-cate.
    RETURN NO-APPLY.
  END.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-prov1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-prov1 W-Win
ON LEAVE OF F-prov1 IN FRAME F-Main /* Proveedor */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia 
                AND  GN-PROV.CODPRO = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE GN-PROV THEN DO:
    MESSAGE "Codigo de proveedor no existe" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO F-prov1.
    RETURN NO-APPLY.
  END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-prov2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-prov2 W-Win
ON LEAVE OF F-prov2 IN FRAME F-Main /* A */
DO:
  IF SELF:SCREEN-VALUE = "" THEN RETURN.
  FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia 
                AND  GN-PROV.CODPRO = SELF:SCREEN-VALUE 
               NO-LOCK NO-ERROR.
  IF NOT AVAILABLE GN-PROV THEN DO:
    MESSAGE "Codigo de proveedor no existe" VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY":U TO F-prov2.
    RETURN NO-APPLY.
  END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-tabla W-Win 
PROCEDURE carga-tabla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR F-FACTOR AS INTEGER .
DEFINE VAR X-TIPO AS INTEGER INIT 1.
DEF VAR j AS INTEGER INIT 0.

X-CODALM = "".
X-CODDIV = "".

FOR EACH Almacen WHERE Almacen.Codcia = S-CODCIA :
    IF R-Zona = 1 THEN DO:
     IF Almacen.Coddiv <> X-DIVI THEN NEXT.
    END. 
    ELSE DO:
     IF Almacen.Coddiv  = X-DIVI THEN NEXT.
    END.
    X-CODALM = X-CODALM + Almacen.CodAlm + "/" .
END.


FOR EACH Gn-Divi NO-LOCK WHERE Gn-Divi.Codcia = S-CODCIA:

 IF R-Zona = 1 THEN DO:
  IF Gn-Divi.Coddiv <> X-DIVI THEN NEXT.
 END. 
 ELSE DO:
  IF Gn-Divi.Coddiv  = X-DIVI THEN NEXT.
 END.
 
 X-CODDIV = X-CODDIV + Gn-Divi.Coddiv + "/" .
 
 FOR EACH CcbCdocu NO-LOCK WHERE NOT L-SALIR 
     AND CcbCdocu.CodCia = S-CODCIA 
     AND CcbCdocu.CodDiv = Gn-Divi.CodDiv 
     AND CCbCdocu.FchDoc >= f-desde 
     AND CcbCdocu.FchDoc <= f-hasta 
     AND LOOKUP(CcbCdocu.CodDoc,"FAC,BOL,N/C") > 0 
     AND CcbCDocu.FlgEst <> "A" USE-INDEX LLAVE10 , 
     EACH CcbDdocu OF ccbCdocu NO-LOCK , 
     FIRST Almmmatg OF CcbDdocu NO-LOCK :
     IF NOT AVAILABLE Almmmatg THEN NEXT .
     IF (Almmmatg.CodPr1 > F-prov2 OR 
         Almmmatg.CodPr1 < F-prov1) THEN NEXT.
     IF TRIM(F-Cate) <> "" THEN DO:
         IF Almmmatg.tipart <> F-Cate THEN NEXT .
     END.
     IF Almmmatg.CodFam <> "001" THEN NEXT.
     F-FACTOR  = 1.
     X-TIPO    = IF LOOKUP(CcbdDocu.Coddoc,"N/C") > 0 THEN -1 ELSE 1.          

     /*RD01*/ DISPLAY " " + CcbDdocu.CodMat + " " + Almmmatg.DesMat @ txt-msj WITH FRAME {&FRAME-NAME}.

/*RD01*****
     ASSIGN 
         FILL-IN-1 = CcbDdocu.CodMat + " " + Almmmatg.DesMat.
     DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}.
**********/     

     FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
         AND Almtconv.Codalter = Ccbddocu.UndVta NO-LOCK NO-ERROR.

     IF AVAILABLE Almtconv THEN DO:
         F-FACTOR = Almtconv.Equival.
         IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
     END.

     FIND Temporal WHERE 
         Temporal.Codcia  = S-CODCIA AND
         Temporal.Codmat  = CcbDDocu.CodMat AND
         Temporal.Periodo = YEAR(CcbdDocu.FchDoc) NO-ERROR .
     IF NOT AVAILABLE Temporal THEN DO:
         CREATE Temporal.
         ASSIGN 
             Temporal.Codcia   = S-CODCIA
             Temporal.clase    = Almmmatg.tipart 
             Temporal.Periodo  = YEAR(CcbdDocu.FchDoc)
             Temporal.CodMat   = Almmmatg.Codmat
             Temporal.DesMat   = Almmmatg.DesMat
             Temporal.DesMar   = Almmmatg.DesMar
             Temporal.Unidad   = Almmmatg.UndStk
             Temporal.CodPr1   = Almmmatg.CodPr1
             Temporal.Ctotot   = Almmmatg.Ctotot.
         FIND GN-PROV WHERE GN-PROV.CODCIA = pv-codcia 
             AND  GN-PROV.CODPRO = Almmmatg.CodPr1 NO-LOCK NO-ERROR.
         IF AVAILABLE GN-PROV THEN Temporal.Nompro  = GN-PROV.Nompro.
         FOR EACH Almacen WHERE Almacen.Codcia = S-CODCIA :
             IF R-Zona = 1 THEN DO:
                 IF Almacen.Coddiv <> X-DIVI THEN NEXT.
             END. 
             ELSE DO:
                 IF Almacen.Coddiv  = X-DIVI THEN NEXT.
             END.

             FIND FIRST Almmmate WHERE Almmmate.CodCia = S-CODCIA 
                 AND Almmmate.CodAlm = Almacen.CodAlm  
                 AND Almmmate.CodMat = Almmmatg.CodMat NO-LOCK NO-ERROR.
             IF AVAILABLE Almmmate THEN 
                 ASSIGN
                 Temporal.Stk[1]  = Temporal.Stk[1] + Almmmate.StkAct
                 Temporal.Stk[2]  = Temporal.Stk[2] + ( Almmmate.StkAct * Almmmatg.Ctotot ) / (If Almmmatg.MonVta = 2 THEN 1 ELSE Almmmatg.Tpocmb).
             END.   
         END.       
         
         CASE MONTH(CcbdDocu.FchDoc) :
             WHEN 01 THEN ASSIGN
                Temporal.ENE[1] = Temporal.ENE[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
                Temporal.ENE[2] = Temporal.ENE[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
             WHEN 02 THEN ASSIGN
                Temporal.FEB[1] = Temporal.FEB[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
                Temporal.FEB[2] = Temporal.FEB[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
             WHEN 03 THEN ASSIGN
                Temporal.MAR[1] = Temporal.MAR[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
                Temporal.MAR[2] = Temporal.MAR[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
             WHEN 04 THEN ASSIGN
                Temporal.ABR[1] = Temporal.ABR[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
                Temporal.ABR[2] = Temporal.ABR[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
             WHEN 05 THEN ASSIGN
                Temporal.MAY[1] = Temporal.MAY[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
                Temporal.MAY[2] = Temporal.MAY[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
             WHEN 06 THEN ASSIGN
                Temporal.JUN[1] = Temporal.JUN[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
                Temporal.JUN[2] = Temporal.JUN[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
             WHEN 07 THEN ASSIGN
                Temporal.JUL[1] = Temporal.JUL[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
                Temporal.JUL[2] = Temporal.JUL[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
             WHEN 08 THEN ASSIGN
                Temporal.AGO[1] = Temporal.AGO[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
                Temporal.AGO[2] = Temporal.AGO[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
             WHEN 09 THEN ASSIGN
                Temporal.SEP[1] = Temporal.SEP[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
                Temporal.SEP[2] = Temporal.SEP[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
             WHEN 10 THEN ASSIGN
                Temporal.OCT[1] = Temporal.OCT[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
                Temporal.OCT[2] = Temporal.OCT[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
             WHEN 11 THEN ASSIGN
                Temporal.NOV[1] = Temporal.NOV[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
                Temporal.NOV[2] = Temporal.NOV[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
             WHEN 12 THEN ASSIGN
                Temporal.DIC[1] = Temporal.DIC[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
                Temporal.DIC[2] = Temporal.DIC[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
         END.
         ASSIGN 
             Temporal.TOT[1] = Temporal.TOT[1] +  X-TIPO * ( CcbDdocu.CanDes * F-FACTOR )
             Temporal.TOT[2] = Temporal.TOT[2] +  X-TIPO * ( Ccbddocu.ImpLin ) / (If CcbcDocu.codmon = 2 THEN 1 ELSE Ccbcdocu.Tpocmb).
         PROCESS EVENTS.
    END.      
END.                                       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY F-prov1 F-prov2 f-desde f-hasta f-cate R-Orden R-Zona txt-msj 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-70 RECT-71 F-prov1 F-prov2 f-desde f-hasta f-cate R-Orden R-Zona 
         BUTTON-6 BUTTON-3 BUTTON-4 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta W-Win 
PROCEDURE Exporta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iTotalNumberOfOrders    AS INTEGER.
DEFINE VARIABLE iMonth                  AS INTEGER.
DEFINE VARIABLE dAnnualQuota            AS DECIMAL.
DEFINE VARIABLE dTotalSalesAmount       AS DECIMAL.
DEFINE VARIABLE t-Column                AS INTEGER INITIAL 5.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE f-Column                AS char INITIAL "".
DEFINE VARIABLE x-valor                 AS DECIMAL init 0.
DEFINE VARIABLE f-estado                AS char init "".


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */

chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 6.
chWorkSheet:Columns("C"):ColumnWidth = 30.
chWorkSheet:Columns("D"):ColumnWidth = 10.
chWorkSheet:Columns("E"):ColumnWidth = 5.
chWorkSheet:Columns("F"):ColumnWidth = 2.

chWorkSheet:Columns("B"):NumberFormat = "@".
chWorkSheet:Columns("AG"):NumberFormat = "@".
chWorkSheet:Columns("G:AF"):NumberFormat = "#,##0.00".
chWorkSheet:Columns("AH"):NumberFormat = "#,##0.0000".

chWorkSheet:Range("A1:AE5"):Font:Bold = TRUE.
chWorkSheet:Cells:Font:Size = 8.
chWorkSheet:Range("A3"):Font:Size = 14.
chWorkSheet:Range("A1"):Value = "Almacenes Evaluados   :" + X-CODALM .
chWorkSheet:Range("A2"):Value = "Divisiones Evaluadas  :" + X-CODDIV .
chWorkSheet:Range("A3"):Value = "Proyeccion de Compras"  .
chWorkSheet:Range("G4"):Value = "Enero".
chWorkSheet:Range("I4"):Value = "Febrero".
chWorkSheet:Range("K4"):Value = "Marzo".
chWorkSheet:Range("M4"):Value = "Abril".
chWorkSheet:Range("O4"):Value = "Mayo".
chWorkSheet:Range("Q4"):Value = "Junio".
chWorkSheet:Range("S4"):Value = "Julio".
chWorkSheet:Range("U4"):Value = "Agosto".
chWorkSheet:Range("W4"):Value = "Septiembre".
chWorkSheet:Range("Y4"):Value = "Octubre".
chWorkSheet:Range("AA4"):Value = "Noviembre".
chWorkSheet:Range("AC4"):Value = "Diciembre".
chWorkSheet:Range("AE4"):Value = "Stock".
chWorkSheet:Range("A5"):Value = "Periodo".
chWorkSheet:Range("B5"):Value = "Codigo".
chWorkSheet:Range("C5"):Value = "Descripcion".
chWorkSheet:Range("D5"):Value = "Marca".
chWorkSheet:Range("E5"):Value = "U.M".
chWorkSheet:Range("F5"):Value = "Cate".
chWorkSheet:Range("G5"):Value = "Cant".
chWorkSheet:Range("H5"):Value = "Dolares".
chWorkSheet:Range("I5"):Value = "Cant".
chWorkSheet:Range("J5"):Value = "Dolares".
chWorkSheet:Range("K5"):Value = "Cant".
chWorkSheet:Range("L5"):Value = "Dolares".
chWorkSheet:Range("M5"):Value = "Cant".
chWorkSheet:Range("N5"):Value = "Dolares".
chWorkSheet:Range("O5"):Value = "Cant".
chWorkSheet:Range("P5"):Value = "Dolares".
chWorkSheet:Range("Q5"):Value = "Cant".
chWorkSheet:Range("R5"):Value = "Dolares".
chWorkSheet:Range("S5"):Value = "Cant".
chWorkSheet:Range("T5"):Value = "Dolares".
chWorkSheet:Range("U5"):Value = "Cant".
chWorkSheet:Range("V5"):Value = "Dolares".
chWorkSheet:Range("W5"):Value = "Cant".
chWorkSheet:Range("X5"):Value = "Dolares".
chWorkSheet:Range("Y5"):Value = "Cant".
chWorkSheet:Range("Z5"):Value = "Dolares".
chWorkSheet:Range("AA5"):Value = "Cant".
chWorkSheet:Range("AB5"):Value = "Dolares".
chWorkSheet:Range("AC5"):Value = "Cant".
chWorkSheet:Range("AD5"):Value = "Dolares".
chWorkSheet:Range("AE5"):Value = "Cant".
chWorkSheet:Range("AF5"):Value = "Dolares".
chWorkSheet:Range("AG5"):Value = "Proveedor".
chWorkSheet:Range("AH5"):Value = "Costo".


chWorkSheet = chExcelApplication:Sheets:Item(1).

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */


for each temporal break by Codcia
                        by CodPr1
                        by Clase
                        by Codmat
                        by Periodo:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = periodo.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = codmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = desmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = desmar.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = unidad.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = clase.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = ENE[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = ENE[2].
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = FEB[1].
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = FEB[2].

    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = MAR[1].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = MAR[2].
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = ABR[1].
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = ABR[2].
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = MAY[1].
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = MAY[2].
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = JUN[1].
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = JUN[2].
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = JUL[1].
    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Value = JUL[2].
    cRange = "U" + cColumn.
    chWorkSheet:Range(cRange):Value = AGO[1].
    cRange = "V" + cColumn.
    chWorkSheet:Range(cRange):Value = AGO[2].
    cRange = "W" + cColumn.
    chWorkSheet:Range(cRange):Value = SEP[1].
    cRange = "X" + cColumn.
    chWorkSheet:Range(cRange):Value = SEP[2].
    cRange = "Y" + cColumn.
    chWorkSheet:Range(cRange):Value = OCT[1].
    cRange = "Z" + cColumn.
    chWorkSheet:Range(cRange):Value = OCT[2].
    cRange = "AA" + cColumn.
    chWorkSheet:Range(cRange):Value = NOV[1].
    cRange = "AB" + cColumn.
    chWorkSheet:Range(cRange):Value = NOV[2].
    cRange = "AC" + cColumn.
    chWorkSheet:Range(cRange):Value = DIC[1].
    cRange = "AD" + cColumn.
    chWorkSheet:Range(cRange):Value = DIC[2].
    cRange = "AE" + cColumn.
    chWorkSheet:Range(cRange):Value = stk[1].
    cRange = "AF" + cColumn.
    chWorkSheet:Range(cRange):Value = stk[2].
    cRange = "AG" + cColumn.
    chWorkSheet:Range(cRange):Value = CodPr1.
    cRange = "AH" + cColumn.
    chWorkSheet:Range(cRange):Value = Ctotot.

END.

/*
f-Column = "H" + string(t-Column).
chWorkSheet:Range("A1:" + f-column):Select().
*/
/*chExcelApplication:Selection:Style = "Currency".*/

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
/*RELEASE OBJECT chWorksheetRange. */

FOR EACH temporal:
 DELETE temporal.
END.
HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Exporta2 W-Win 
PROCEDURE Exporta2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.
DEFINE VARIABLE chChart                 AS COM-HANDLE.
DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.
DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iTotalNumberOfOrders    AS INTEGER.
DEFINE VARIABLE iMonth                  AS INTEGER.
DEFINE VARIABLE dAnnualQuota            AS DECIMAL.
DEFINE VARIABLE dTotalSalesAmount       AS DECIMAL.
DEFINE VARIABLE t-Column                AS INTEGER INITIAL 5.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.
DEFINE VARIABLE f-Column                AS char INITIAL "".
DEFINE VARIABLE x-valor                 AS DECIMAL init 0.
DEFINE VARIABLE f-estado                AS char init "".


/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = TRUE.

/* create a new Workbook */
chWorkbook = chExcelApplication:Workbooks:Add().

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/* set the column names for the Worksheet */

chWorkSheet:Columns("A"):ColumnWidth = 4.
chWorkSheet:Columns("B"):ColumnWidth = 6.
chWorkSheet:Columns("C"):ColumnWidth = 30.
chWorkSheet:Columns("D"):ColumnWidth = 10.
chWorkSheet:Columns("E"):ColumnWidth = 5.
chWorkSheet:Columns("F"):ColumnWidth = 2.

chWorkSheet:Columns("B"):NumberFormat = "@".
chWorkSheet:Columns("AG"):NumberFormat = "@".
chWorkSheet:Columns("G:AF"):NumberFormat = "#,##0.00".
chWorkSheet:Columns("AH"):NumberFormat = "#,##0.0000".

chWorkSheet:Range("A1:AE5"):Font:Bold = TRUE.
chWorkSheet:Cells:Font:Size = 8.
chWorkSheet:Range("A3"):Font:Size = 14.
chWorkSheet:Range("A1"):Value = "Almacenes Evaluados   :" + X-CODALM .
chWorkSheet:Range("A2"):Value = "Divisiones Evaluadas  :" + X-CODDIV .
chWorkSheet:Range("A3"):Value = "Proyeccion de Compras"  .
chWorkSheet:Range("G4"):Value = "Enero".
chWorkSheet:Range("I4"):Value = "Febrero".
chWorkSheet:Range("K4"):Value = "Marzo".
chWorkSheet:Range("M4"):Value = "Abril".
chWorkSheet:Range("O4"):Value = "Mayo".
chWorkSheet:Range("Q4"):Value = "Junio".
chWorkSheet:Range("S4"):Value = "Julio".
chWorkSheet:Range("U4"):Value = "Agosto".
chWorkSheet:Range("W4"):Value = "Septiembre".
chWorkSheet:Range("Y4"):Value = "Octubre".
chWorkSheet:Range("AA4"):Value = "Noviembre".
chWorkSheet:Range("AC4"):Value = "Diciembre".
chWorkSheet:Range("AE4"):Value = "Stock".
chWorkSheet:Range("A5"):Value = "Periodo".
chWorkSheet:Range("B5"):Value = "Codigo".
chWorkSheet:Range("C5"):Value = "Descripcion".
chWorkSheet:Range("D5"):Value = "Marca".
chWorkSheet:Range("E5"):Value = "U.M".
chWorkSheet:Range("F5"):Value = "Cate".
chWorkSheet:Range("G5"):Value = "Cant".
chWorkSheet:Range("H5"):Value = "Dolares".
chWorkSheet:Range("I5"):Value = "Cant".
chWorkSheet:Range("J5"):Value = "Dolares".
chWorkSheet:Range("K5"):Value = "Cant".
chWorkSheet:Range("L5"):Value = "Dolares".
chWorkSheet:Range("M5"):Value = "Cant".
chWorkSheet:Range("N5"):Value = "Dolares".
chWorkSheet:Range("O5"):Value = "Cant".
chWorkSheet:Range("P5"):Value = "Dolares".
chWorkSheet:Range("Q5"):Value = "Cant".
chWorkSheet:Range("R5"):Value = "Dolares".
chWorkSheet:Range("S5"):Value = "Cant".
chWorkSheet:Range("T5"):Value = "Dolares".
chWorkSheet:Range("U5"):Value = "Cant".
chWorkSheet:Range("V5"):Value = "Dolares".
chWorkSheet:Range("W5"):Value = "Cant".
chWorkSheet:Range("X5"):Value = "Dolares".
chWorkSheet:Range("Y5"):Value = "Cant".
chWorkSheet:Range("Z5"):Value = "Dolares".
chWorkSheet:Range("AA5"):Value = "Cant".
chWorkSheet:Range("AB5"):Value = "Dolares".
chWorkSheet:Range("AC5"):Value = "Cant".
chWorkSheet:Range("AD5"):Value = "Dolares".
chWorkSheet:Range("AE5"):Value = "Cant".
chWorkSheet:Range("AF5"):Value = "Dolares".
chWorkSheet:Range("AG5"):Value = "Proveedor".
chWorkSheet:Range("AH5"):Value = "Costo".


chWorkSheet = chExcelApplication:Sheets:Item(1).

/* Iterate through the salesrep table and populate
   the Worksheet appropriately */


for each temporal break by Codcia
                        by CodPr1
                        by Clase
                        by DesMat
                        by Periodo:
    t-column = t-column + 1.
    cColumn = STRING(t-Column).
    cRange = "A" + cColumn.
    chWorkSheet:Range(cRange):Value = periodo.
    cRange = "B" + cColumn.
    chWorkSheet:Range(cRange):Value = codmat.
    cRange = "C" + cColumn.
    chWorkSheet:Range(cRange):Value = desmat.
    cRange = "D" + cColumn.
    chWorkSheet:Range(cRange):Value = desmar.
    cRange = "E" + cColumn.
    chWorkSheet:Range(cRange):Value = unidad.
    cRange = "F" + cColumn.
    chWorkSheet:Range(cRange):Value = clase.
    cRange = "G" + cColumn.
    chWorkSheet:Range(cRange):Value = ENE[1].
    cRange = "H" + cColumn.
    chWorkSheet:Range(cRange):Value = ENE[2].
    cRange = "I" + cColumn.
    chWorkSheet:Range(cRange):Value = FEB[1].
    cRange = "J" + cColumn.
    chWorkSheet:Range(cRange):Value = FEB[2].

    cRange = "K" + cColumn.
    chWorkSheet:Range(cRange):Value = MAR[1].
    cRange = "L" + cColumn.
    chWorkSheet:Range(cRange):Value = MAR[2].
    cRange = "M" + cColumn.
    chWorkSheet:Range(cRange):Value = ABR[1].
    cRange = "N" + cColumn.
    chWorkSheet:Range(cRange):Value = ABR[2].
    cRange = "O" + cColumn.
    chWorkSheet:Range(cRange):Value = MAY[1].
    cRange = "P" + cColumn.
    chWorkSheet:Range(cRange):Value = MAY[2].
    cRange = "Q" + cColumn.
    chWorkSheet:Range(cRange):Value = JUN[1].
    cRange = "R" + cColumn.
    chWorkSheet:Range(cRange):Value = JUN[2].
    cRange = "S" + cColumn.
    chWorkSheet:Range(cRange):Value = JUL[1].
    cRange = "T" + cColumn.
    chWorkSheet:Range(cRange):Value = JUL[2].
    cRange = "U" + cColumn.
    chWorkSheet:Range(cRange):Value = AGO[1].
    cRange = "V" + cColumn.
    chWorkSheet:Range(cRange):Value = AGO[2].
    cRange = "W" + cColumn.
    chWorkSheet:Range(cRange):Value = SEP[1].
    cRange = "X" + cColumn.
    chWorkSheet:Range(cRange):Value = SEP[2].
    cRange = "Y" + cColumn.
    chWorkSheet:Range(cRange):Value = OCT[1].
    cRange = "Z" + cColumn.
    chWorkSheet:Range(cRange):Value = OCT[2].
    cRange = "AA" + cColumn.
    chWorkSheet:Range(cRange):Value = NOV[1].
    cRange = "AB" + cColumn.
    chWorkSheet:Range(cRange):Value = NOV[2].
    cRange = "AC" + cColumn.
    chWorkSheet:Range(cRange):Value = DIC[1].
    cRange = "AD" + cColumn.
    chWorkSheet:Range(cRange):Value = DIC[2].
    cRange = "AE" + cColumn.
    chWorkSheet:Range(cRange):Value = stk[1].
    cRange = "AF" + cColumn.
    chWorkSheet:Range(cRange):Value = stk[2].
    cRange = "AG" + cColumn.
    chWorkSheet:Range(cRange):Value = CodPr1.
    cRange = "AH" + cColumn.
    chWorkSheet:Range(cRange):Value = Ctotot.

END.

/*
f-Column = "H" + string(t-Column).
chWorkSheet:Range("A1:" + f-column):Select().
*/
/*chExcelApplication:Selection:Style = "Currency".*/

/* release com-handles */
RELEASE OBJECT chExcelApplication.      
RELEASE OBJECT chWorkbook.
RELEASE OBJECT chWorksheet.
/*RELEASE OBJECT chWorksheetRange. */

FOR EACH temporal:
 DELETE temporal.
END.
HIDE FRAME F-PROCESO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Imprimir W-Win 
PROCEDURE Imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.
   
    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".    

    RUN Carga-Tabla.

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.        
        CASE R-Orden :
            WHEN 1 THEN RUN XReporte.
            WHEN 2 THEN RUN XReporte2.
        END.

        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/W-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN 
          f-punto = S-CODDIV
          f-desde = TODAY - DAY(TODAY) + 1
          f-hasta = TODAY.
      DISPLAY f-desde f-hasta.        
  END.



  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros W-Win 
PROCEDURE Procesa-Parametros :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros W-Win 
PROCEDURE Recoge-Parametros :
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE XReporte W-Win 
PROCEDURE XReporte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR L-SW AS LOGICAL INIT NO.
 DEFINE VAR X-TITU AS CHAR.
 X-TITU = "REPORTE DE VENTAS - PROYECCION DE COMPRA".
 DEFINE FRAME f-cab
        Temporal.CodMat  FORMAT "x(6)"  
        Temporal.DesMat  FORMAT "x(35)"   
        Temporal.DesMar  FORMAT "x(10)"   
        Temporal.Unidad  FORMAT "x(5)"   
        Temporal.Ctotot  FORMAT "->>>>>9.9999"
        Temporal.ENE[1]  FORMAT "->>>>>9.99"
        Temporal.ENE[2]  FORMAT "->>>>>9.99"
        Temporal.FEB[1]  FORMAT "->>>>>9.99"
        Temporal.FEB[2]  FORMAT "->>>>>9.99"
        Temporal.MAR[1]  FORMAT "->>>>>9.99"
        Temporal.MAR[2]  FORMAT "->>>>>9.99"
        Temporal.ABR[1]  FORMAT "->>>>>9.99"
        Temporal.ABR[2]  FORMAT "->>>>>9.99"
        Temporal.MAY[1]  FORMAT "->>>>>9.99"
        Temporal.MAY[2]  FORMAT "->>>>>9.99"
        Temporal.TOT[1]  FORMAT "->>>>>9.99"
        Temporal.TOT[2]  FORMAT "->>>>>9.99"
        Temporal.Stk[1]  FORMAT "->>>>>9.99"
        Temporal.Stk[2]  FORMAT "->>>>>9.99"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 40 FORMAT "X(60)" SKIP
        {&PRN3} + {&PRN6B} + "Pagina: " AT 150 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN3} + {&PRN6B} + "Fecha : " AT 120 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN2} + {&PRN6A} + "MONEDA   : DOLARES AMERICANOS" At 1 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 120 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
        {&PRN2} + {&PRN6A} + "ALMACENES EVALUADOS   : " + X-CODALM  At 1 FORMAT "X(150)"  SKIP
        {&PRN2} + {&PRN6A} + "DIVISIONES EVALUADAS  : " + X-CODDIV  + {&PRN4} + {&PRN6B} At 1 FORMAT "X(150)" SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                              Enero               Febrero                Marzo                  Abril                  Mayo                 Total                   Stock      " SKIP             
        " Articulo        Descripcion                Marca     U.M.       Costo    Cant.   Dolares       Cant.   Dolares       Cant.   Dolares       Cant.   Dolares       Cant.   Dolares       Cant.   Dolares        Cant.   Dolares " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 350 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH Temporal NO-LOCK
          BREAK BY Temporal.Codcia
                BY Temporal.CodPr1
                BY Temporal.Clase 
                BY Temporal.Codmat :
                                 
     /*{&NEW-PAGE}.*/
     DISPLAY STREAM REPORT WITH FRAME F-CAB.
          
     IF FIRST-OF ( Temporal.CodPr1) THEN DO:
        PUT STREAM REPORT 
        {&PRN2} + {&PRN6A} +  "PROVEEDOR : "  + Temporal.CodPr1 + " " + Temporal.NomPro + {&PRN4} + {&PRN6B} AT 1 FORMAT "X(100)" SKIP(2).
     END.

     
     IF FIRST-OF ( Temporal.Clase) THEN DO:
      PUT STREAM REPORT 
      {&PRN6A} + "Categoria  : " + Temporal.Clase + {&PRN6B}  AT 10  FORMAT "X(30)" SKIP.
     END.
         
      
      DISPLAY STREAM REPORT 
        Temporal.CodMat  FORMAT "X(6)"
        Temporal.DesMat  FORMAT "X(35)"
        Temporal.DesMar  FORMAT "X(10)"
        Temporal.Unidad  FORMAT "X(5)"
        Temporal.Ctotot  FORMAT "->>>>>9.9999"
        Temporal.ENE[1]  FORMAT "->>>>>9.99"
        Temporal.ENE[2]  FORMAT "->>>>>9.99"
        Temporal.FEB[1]  FORMAT "->>>>>9.99"
        Temporal.FEB[2]  FORMAT "->>>>>9.99"
        Temporal.MAR[1]  FORMAT "->>>>>9.99"
        Temporal.MAR[2]  FORMAT "->>>>>9.99"
        Temporal.ABR[1]  FORMAT "->>>>>9.99"
        Temporal.ABR[2]  FORMAT "->>>>>9.99"
        Temporal.MAY[1]  FORMAT "->>>>>9.99"
        Temporal.MAY[2]  FORMAT "->>>>>9.99"
        Temporal.TOT[1]  FORMAT "->>>>>9.99"
        Temporal.TOT[2]  FORMAT "->>>>>9.99"
        Temporal.Stk[1]  FORMAT "->>>>>9.99"
        Temporal.Stk[2]  FORMAT "->>>>>9.99"    
        WITH FRAME F-Cab.
              
        ACCUMULATE Temporal.ENE[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.ENE[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.ENE[2] ( TOTAL     BY Temporal.Codcia ). 
        
        ACCUMULATE Temporal.FEB[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.FEB[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.FEB[2] ( TOTAL     BY Temporal.Codcia ). 

        ACCUMULATE Temporal.MAR[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.MAR[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.MAR[2] ( TOTAL     BY Temporal.Codcia ). 
        
        ACCUMULATE Temporal.ABR[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.ABR[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.ABR[2] ( TOTAL     BY Temporal.Codcia ). 
        
        ACCUMULATE Temporal.MAY[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.MAY[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.MAY[2] ( TOTAL     BY Temporal.Codcia ). 
        
                
        ACCUMULATE Temporal.TOT[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.TOT[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.TOT[2] ( TOTAL     BY Temporal.Codcia ). 
 
        ACCUMULATE Temporal.STK[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.STK[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.STK[2] ( TOTAL     BY Temporal.Codcia ). 
                
        IF LAST-OF (Temporal.Clase) THEN DO:
           
           UNDERLINE STREAM REPORT Temporal.ENE[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.FEB[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.ABR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAY[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.TOT[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.STK[2] WITH FRAME F-CAB.
           
           DISPLAY STREAM REPORT
                   {&PRN6A} + "Total Categoria : " + Temporal.Clase + {&PRN6B}  @ Temporal.Desmat            
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.ENE[2] @ Temporal.ENE[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.FEB[2] @ Temporal.FEB[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.MAR[2] @ Temporal.MAR[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.ABR[2] @ Temporal.ABR[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.MAY[2] @ Temporal.MAY[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.TOT[2] @ Temporal.TOT[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.STK[2] @ Temporal.STK[2] 
                   WITH FRAME F-CAB.               
           DOWN STREAM REPORT 1 WITH FRAME F-CAB.        
        END.

        IF LAST-OF (Temporal.CodPr1) THEN DO:
           
           UNDERLINE STREAM REPORT Temporal.ENE[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.FEB[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.ABR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAY[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.TOT[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.STK[2] WITH FRAME F-CAB. 
           
           DISPLAY STREAM REPORT
                   {&PRN6A} + "Total Proveedor : " + Temporal.CodPr1 + {&PRN6B} @ Temporal.Desmat            
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.ENE[2] @ Temporal.ENE[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.FEB[2] @ Temporal.FEB[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.MAR[2] @ Temporal.MAR[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.ABR[2] @ Temporal.ABR[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.MAY[2] @ Temporal.MAY[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.TOT[2] @ Temporal.TOT[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.STK[2] @ Temporal.STK[2] 
                   WITH FRAME F-CAB.               
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
        END.

        
        IF LAST-OF (Temporal.Codcia) THEN DO:
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
           UNDERLINE STREAM REPORT Temporal.ENE[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.FEB[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.ABR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAY[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.TOT[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.STK[2] WITH FRAME F-CAB. 
           
           DISPLAY STREAM REPORT
                   {&PRN6A} + "TOTAL GENERAL   :  " + {&PRN6B} @ Temporal.DESMAT
                   ACCUM TOTAL BY Temporal.Codcia Temporal.ENE[2] @ Temporal.ENE[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.FEB[2] @ Temporal.FEB[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.MAR[2] @ Temporal.MAR[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.ABR[2] @ Temporal.ABR[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.MAY[2] @ Temporal.MAY[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.TOT[2] @ Temporal.TOT[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.STK[2] @ Temporal.STK[2] 
                   WITH FRAME F-CAB.


        END.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE XReporte2 W-Win 
PROCEDURE XReporte2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR L-SW AS LOGICAL INIT NO.
 DEFINE VAR X-TITU AS CHAR.
 X-TITU = "REPORTE DE VENTAS - PROYECCION DE COMPRA".
 DEFINE FRAME f-cab
        Temporal.CodMat  FORMAT "x(6)"  
        Temporal.DesMat  FORMAT "x(35)"   
        Temporal.DesMar  FORMAT "x(10)"   
        Temporal.Unidad  FORMAT "x(5)"   
        Temporal.Ctotot  FORMAT "->>>>>9.9999"
        Temporal.ENE[1]  FORMAT "->>>>>9.99"
        Temporal.ENE[2]  FORMAT "->>>>>9.99"
        Temporal.FEB[1]  FORMAT "->>>>>9.99"
        Temporal.FEB[2]  FORMAT "->>>>>9.99"
        Temporal.MAR[1]  FORMAT "->>>>>9.99"
        Temporal.MAR[2]  FORMAT "->>>>>9.99"
        Temporal.ABR[1]  FORMAT "->>>>>9.99"
        Temporal.ABR[2]  FORMAT "->>>>>9.99"
        Temporal.MAY[1]  FORMAT "->>>>>9.99"
        Temporal.MAY[2]  FORMAT "->>>>>9.99"
        Temporal.TOT[1]  FORMAT "->>>>>9.99"
        Temporal.TOT[2]  FORMAT "->>>>>9.99"
        Temporal.Stk[1]  FORMAT "->>>>>9.99"
        Temporal.Stk[2]  FORMAT "->>>>>9.99"
        HEADER
        {&PRN2} + {&PRN7A} + {&PRN6A} + S-NOMCIA + {&PRN6B} + {&PRN7B} + {&PRN3} FORMAT "X(45)" SKIP(2)
        {&PRN2} + {&PRN6A} + X-TITU + {&PRN6B} + {&PRN3} AT 40 FORMAT "X(60)" SKIP
        {&PRN3} + {&PRN6B} + "Pagina: " AT 150 FORMAT "X(15)" PAGE-NUMBER(REPORT) FORMAT "ZZ9" SKIP
        {&PRN2} + {&PRN6A} + "DESDE    : " + STRING(f-desde,"99/99/9999") + " HASTA :" + STRING(f-hasta,"99/99/9999") FORMAT "X(50)"
        {&PRN3} + {&PRN6B} + "Fecha : " AT 120 FORMAT "X(15)" STRING(TODAY,"99/99/9999") FORMAT "X(12)"
        {&PRN2} + {&PRN6A} + "MONEDA   : DOLARES AMERICANOS" At 1 FORMAT "X(35)"
        {&PRN3} + {&PRN6B} + "Hora  : " AT 120 FORMAT "X(15)" STRING(TIME,"HH:MM:SS") + {&PRN6B} + {&PRND} SKIP
        {&PRN2} + {&PRN6A} + "ALMACENES EVALUADOS   : " + X-CODALM  At 1 FORMAT "X(150)"  SKIP
        {&PRN2} + {&PRN6A} + "DIVISIONES EVALUADAS  : " + X-CODDIV  + {&PRN4} + {&PRN6B} At 1 FORMAT "X(150)" SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
        "                                                                              Enero               Febrero                Marzo                  Abril                  Mayo                 Total                   Stock      " SKIP             
        " Articulo        Descripcion                Marca     U.M.        Costo   Cant.   Dolares       Cant.   Dolares       Cant.   Dolares       Cant.   Dolares       Cant.   Dolares       Cant.   Dolares        Cant.   Dolares " SKIP
        "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH WIDTH 350 NO-BOX NO-LABELS NO-UNDERLINE STREAM-IO DOWN.

  FOR EACH Temporal NO-LOCK
          BREAK BY Temporal.Codcia
                BY Temporal.CodPr1
                BY Temporal.Clase 
                BY Temporal.Desmat :
                                 
     /*{&NEW-PAGE}.*/
     DISPLAY STREAM REPORT WITH FRAME F-CAB.
          
     IF FIRST-OF ( Temporal.CodPr1) THEN DO:
        PUT STREAM REPORT 
        {&PRN2} + {&PRN6A} +  "PROVEEDOR : "  + Temporal.CodPr1 + " " + Temporal.NomPro + {&PRN4} + {&PRN6B} AT 1 FORMAT "X(100)" SKIP(2).
     END.

     
     IF FIRST-OF ( Temporal.Clase) THEN DO:
      PUT STREAM REPORT 
      {&PRN6A} + "Categoria  : " + Temporal.Clase + {&PRN6B}  AT 10  FORMAT "X(30)" SKIP.
     END.
     
      
      
      DISPLAY STREAM REPORT 
        Temporal.CodMat  FORMAT "X(6)"
        Temporal.DesMat  FORMAT "X(35)"
        Temporal.DesMar  FORMAT "X(10)"
        Temporal.Unidad  FORMAT "X(5)"
        Temporal.Ctotot  FORMAT "->>>>>9.9999"
        Temporal.ENE[1]  FORMAT "->>>>>9.99"
        Temporal.ENE[2]  FORMAT "->>>>>9.99"
        Temporal.FEB[1]  FORMAT "->>>>>9.99"
        Temporal.FEB[2]  FORMAT "->>>>>9.99"
        Temporal.MAR[1]  FORMAT "->>>>>9.99"
        Temporal.MAR[2]  FORMAT "->>>>>9.99"
        Temporal.ABR[1]  FORMAT "->>>>>9.99"
        Temporal.ABR[2]  FORMAT "->>>>>9.99"
        Temporal.MAY[1]  FORMAT "->>>>>9.99"
        Temporal.MAY[2]  FORMAT "->>>>>9.99"
        Temporal.TOT[1]  FORMAT "->>>>>9.99"
        Temporal.TOT[2]  FORMAT "->>>>>9.99"
        Temporal.Stk[1]  FORMAT "->>>>>9.99"
        Temporal.Stk[2]  FORMAT "->>>>>9.99"    
        WITH FRAME F-Cab.
              
        ACCUMULATE Temporal.ENE[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.ENE[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.ENE[2] ( TOTAL     BY Temporal.Codcia ). 
        
        ACCUMULATE Temporal.FEB[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.FEB[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.FEB[2] ( TOTAL     BY Temporal.Codcia ). 

        ACCUMULATE Temporal.MAR[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.MAR[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.MAR[2] ( TOTAL     BY Temporal.Codcia ). 
        
        ACCUMULATE Temporal.ABR[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.ABR[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.ABR[2] ( TOTAL     BY Temporal.Codcia ). 
        
        ACCUMULATE Temporal.MAY[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.MAY[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.MAY[2] ( TOTAL     BY Temporal.Codcia ). 
        
                
        ACCUMULATE Temporal.TOT[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.TOT[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.TOT[2] ( TOTAL     BY Temporal.Codcia ). 
 
        ACCUMULATE Temporal.STK[2] ( SUB-TOTAL BY Temporal.CodPr1 ).
        ACCUMULATE Temporal.STK[2] ( SUB-TOTAL BY Temporal.Clase  ).
        ACCUMULATE Temporal.STK[2] ( TOTAL     BY Temporal.Codcia ). 
                
        IF LAST-OF (Temporal.Clase) THEN DO:
           
           UNDERLINE STREAM REPORT Temporal.ENE[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.FEB[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.ABR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAY[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.TOT[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.STK[2] WITH FRAME F-CAB.
           
           DISPLAY STREAM REPORT
                   {&PRN6A} + "Total Categoria : " + Temporal.Clase + {&PRN6B}  @ Temporal.Desmat            
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.ENE[2] @ Temporal.ENE[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.FEB[2] @ Temporal.FEB[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.MAR[2] @ Temporal.MAR[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.ABR[2] @ Temporal.ABR[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.MAY[2] @ Temporal.MAY[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.TOT[2] @ Temporal.TOT[2] 
                   ACCUM SUB-TOTAL BY Temporal.Clase Temporal.STK[2] @ Temporal.STK[2] 
                   WITH FRAME F-CAB.               
           DOWN STREAM REPORT 1 WITH FRAME F-CAB.        
        END.

        IF LAST-OF (Temporal.CodPr1) THEN DO:
           
           UNDERLINE STREAM REPORT Temporal.ENE[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.FEB[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.ABR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAY[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.TOT[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.STK[2] WITH FRAME F-CAB. 
           
           DISPLAY STREAM REPORT
                   {&PRN6A} + "Total Proveedor : " + Temporal.CodPr1 + {&PRN6B} @ Temporal.Desmat            
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.ENE[2] @ Temporal.ENE[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.FEB[2] @ Temporal.FEB[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.MAR[2] @ Temporal.MAR[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.ABR[2] @ Temporal.ABR[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.MAY[2] @ Temporal.MAY[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.TOT[2] @ Temporal.TOT[2] 
                   ACCUM SUB-TOTAL BY Temporal.CodPr1 Temporal.STK[2] @ Temporal.STK[2] 
                   WITH FRAME F-CAB.               
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
        END.

        
        IF LAST-OF (Temporal.Codcia) THEN DO:
           DOWN STREAM REPORT 2 WITH FRAME F-CAB.        
           UNDERLINE STREAM REPORT Temporal.ENE[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.FEB[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.ABR[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.MAY[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.TOT[2] WITH FRAME F-CAB. 
           UNDERLINE STREAM REPORT Temporal.STK[2] WITH FRAME F-CAB. 
           
           DISPLAY STREAM REPORT
                   {&PRN6A} + "TOTAL GENERAL   :  " + {&PRN6B} @ Temporal.DESMAT
                   ACCUM TOTAL BY Temporal.Codcia Temporal.ENE[2] @ Temporal.ENE[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.FEB[2] @ Temporal.FEB[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.MAR[2] @ Temporal.MAR[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.ABR[2] @ Temporal.ABR[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.MAY[2] @ Temporal.MAY[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.TOT[2] @ Temporal.TOT[2] 
                   ACCUM TOTAL BY Temporal.Codcia Temporal.STK[2] @ Temporal.STK[2] 
                   WITH FRAME F-CAB.


        END.
 END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

