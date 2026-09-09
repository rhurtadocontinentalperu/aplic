&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM LIKE FacDPedi.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS F-Frame-Win 
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

  Description: from cntnrfrm.w - ADM SmartFrame Template

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
&SCOPED-DEFINE precio-venta-general web/PrecioFinalContadoMayorista.p

/* Parameters Definitions ---                                           */
DEF SHARED VAR s-codcia AS INTE.

/* Local Variable Definitions ---                                       */

DEF VAR pMensaje AS CHAR NO-UNDO.

DEFINE VARIABLE S-UNDBAS AS CHAR NO-UNDO.
DEFINE VARIABLE S-UNDVTA AS CHAR NO-UNDO.
DEFINE VARIABLE F-FACTOR AS DECI NO-UNDO.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE X-CANPED AS DECI NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE I-NroItm AS INTE NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE x-TipDto AS CHAR NO-UNDO.
DEFINE VARIABLE pCodAlm  AS CHAR NO-UNDO.
DEFINE VARIABLE x-DesMat AS CHAR NO-UNDO.
DEFINE VARIABLE x-DesMar AS CHAR NO-UNDO.
DEFINE VARIABLE f-FleteUnitario AS DECI NO-UNDO.
DEFINE VARIABLE x-ImpDto AS DEC NO-UNDO.
DEFINE VARIABLE x-ImpIgv AS DEC NO-UNDO.
DEFINE VARIABLE x-ImpIsc AS DEC NO-UNDO.

DEFINE SHARED VARIABLE s-nrodec AS INTE.
DEFINE SHARED VARIABLE s-PorIgv LIKE Ccbcdocu.PorIgv.
DEFINE SHARED VARIABLE S-CODALM  AS CHAR.
DEFINE SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE SHARED VARIABLE S-CODCLI  AS CHAR.
DEFINE SHARED VARIABLE S-CODMON  AS INTEGER.
DEFINE SHARED VARIABLE S-TPOCMB  AS DEC.
DEFINE SHARED VARIABLE s-FlgSit AS CHAR.
DEFINE SHARED VARIABLE s-adm-new-record AS CHAR.
DEFINE SHARED VARIABLE S-CODDOC  AS CHAR.
DEFINE SHARED VARIABLE s-NroPed AS CHAR.
DEFINE SHARED VARIABLE s-TpoPed   AS CHAR.
DEFINE SHARED VARIABLE S-CNDVTA  AS CHAR.

DEFINE VAR x-AlmDes AS CHAR NO-UNDO.

x-AlmDes = ENTRY(1,s-CodAlm).

/* archivo de texto */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartFrame
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 IMAGE-Up IMAGE-Down RECT-3 ~
IMAGE-Reset FILL-IN-CodMat FILL-IN-CanPed 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodMat FILL-IN_DesMat-1 ~
FILL-IN_DesMat-2 FILL-IN_DesMat-3 FILL-IN_DesMar FILL-IN-CanPed ~
FILL-IN-ValorAnterior FILL-IN-UndVta FILL-IN-Libre_d02 FILL-IN-PorDsctos2 ~
FILL-IN-PreUni FILL-IN-PorDsctos3 FILL-IN-ImpLin FILL-IN_ImpTot ~
FILL-IN-CodMat-2 FILL-IN-CanPed-2 FILL-IN-UndVta-2 FILL-IN-ImpLin-2 ~
EDITOR-DesMat-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE EDITOR-DesMat-2 AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 45 BY 2
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-CanPed AS DECIMAL FORMAT ">,>>9":U INITIAL 0 
     LABEL "Cantidad" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-CanPed-2 AS DECIMAL FORMAT ">,>>9":U INITIAL 1 
     LABEL "Cantidad" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMat AS CHARACTER FORMAT "x(15)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1
     BGCOLOR 11 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN-CodMat-2 AS CHARACTER FORMAT "x(15)":U 
     LABEL "Artículo" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpLin AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "Importe" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-ImpLin-2 AS DECIMAL FORMAT ">,>>>,>>9.99":U INITIAL 0 
     LABEL "Importe" 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-Libre_d02 AS DECIMAL FORMAT "->>>,>>9.9999":U INITIAL 0 
     LABEL "Flete Unitario" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-PorDsctos2 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "Descuento #1" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-PorDsctos3 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "Descuento #2" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-PreUni AS DECIMAL FORMAT ">>,>>9.999999":U INITIAL 0 
     LABEL "Precio Unitario" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-UndVta AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unidad" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-UndVta-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unidad" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-ValorAnterior AS DECIMAL FORMAT ">,>>9":U INITIAL 0 
     LABEL "Valor Anterior" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1
     BGCOLOR 8 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE FILL-IN_DesMar AS CHARACTER FORMAT "X(45)":U 
     LABEL "Marca" 
     VIEW-AS FILL-IN 
     SIZE 45 BY 1
     BGCOLOR 7 FGCOLOR 15  NO-UNDO.

DEFINE VARIABLE FILL-IN_DesMat-1 AS CHARACTER FORMAT "X(45)":U 
     LABEL "Descripción" 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_DesMat-2 AS CHARACTER FORMAT "X(45)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_DesMat-3 AS CHARACTER FORMAT "X(45)":U 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN_ImpTot AS DECIMAL FORMAT ">>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.62
     BGCOLOR 14 FGCOLOR 0 FONT 8 NO-UNDO.

DEFINE IMAGE IMAGE-Down
     FILENAME "img/chevron-left-regular-24.bmp":U
     SIZE 4 BY 1.08 TOOLTIP "+1".

DEFINE IMAGE IMAGE-Reset
     FILENAME "img/reset-regular-24.bmp":U
     SIZE 4 BY 1.08 TOOLTIP "Limpiar todo".

DEFINE IMAGE IMAGE-Up
     FILENAME "img/chevron-right-regular-24.bmp":U
     SIZE 4 BY 1.08 TOOLTIP "-1".

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 13.42.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 4.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     FILL-IN-CodMat AT ROW 1.54 COL 15 COLON-ALIGNED WIDGET-ID 2
     FILL-IN_DesMat-1 AT ROW 2.62 COL 15 COLON-ALIGNED WIDGET-ID 58
     FILL-IN_DesMat-2 AT ROW 3.69 COL 15 COLON-ALIGNED NO-LABEL WIDGET-ID 60
     FILL-IN_DesMat-3 AT ROW 4.77 COL 15 COLON-ALIGNED NO-LABEL WIDGET-ID 62
     FILL-IN_DesMar AT ROW 5.85 COL 15 COLON-ALIGNED WIDGET-ID 64
     FILL-IN-CanPed AT ROW 6.92 COL 15 COLON-ALIGNED WIDGET-ID 8
     FILL-IN-ValorAnterior AT ROW 6.92 COL 48 COLON-ALIGNED WIDGET-ID 34
     FILL-IN-UndVta AT ROW 8 COL 15 COLON-ALIGNED WIDGET-ID 10
     FILL-IN-Libre_d02 AT ROW 9.08 COL 15 COLON-ALIGNED WIDGET-ID 14
     FILL-IN-PorDsctos2 AT ROW 9.08 COL 47 COLON-ALIGNED WIDGET-ID 16
     FILL-IN-PreUni AT ROW 10.15 COL 15 COLON-ALIGNED WIDGET-ID 12
     FILL-IN-PorDsctos3 AT ROW 10.15 COL 47 COLON-ALIGNED WIDGET-ID 18
     FILL-IN-ImpLin AT ROW 11.23 COL 47 COLON-ALIGNED WIDGET-ID 20
     FILL-IN_ImpTot AT ROW 12.58 COL 33 COLON-ALIGNED NO-LABEL WIDGET-ID 52
     FILL-IN-CodMat-2 AT ROW 14.73 COL 16 COLON-ALIGNED WIDGET-ID 38
     FILL-IN-CanPed-2 AT ROW 15.81 COL 16 COLON-ALIGNED WIDGET-ID 36
     FILL-IN-UndVta-2 AT ROW 15.81 COL 32 COLON-ALIGNED WIDGET-ID 42
     FILL-IN-ImpLin-2 AT ROW 15.81 COL 49 COLON-ALIGNED WIDGET-ID 40
     EDITOR-DesMat-2 AT ROW 16.88 COL 18 NO-LABEL WIDGET-ID 44
     "TOTAL S/" VIEW-AS TEXT
          SIZE 16 BY 1.62 AT ROW 12.58 COL 19 WIDGET-ID 54
          FONT 8
     "Descripción:" VIEW-AS TEXT
          SIZE 12 BY .62 AT ROW 16.88 COL 6 WIDGET-ID 46
     "Ultimo artículo" VIEW-AS TEXT
          SIZE 15 BY .62 AT ROW 14.19 COL 2 WIDGET-ID 50
          BGCOLOR 9 FGCOLOR 15 
     RECT-1 AT ROW 1 COL 1 WIDGET-ID 22
     IMAGE-Up AT ROW 6.92 COL 29 WIDGET-ID 28
     IMAGE-Down AT ROW 6.92 COL 25 WIDGET-ID 32
     RECT-3 AT ROW 14.46 COL 1 WIDGET-ID 48
     IMAGE-Reset AT ROW 1.54 COL 35 WIDGET-ID 56
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 63.43 BY 18.15
         BGCOLOR 15 FGCOLOR 0 FONT 11 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartFrame
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: ITEM T "?" ? INTEGRAL FacDPedi
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
  CREATE WINDOW F-Frame-Win ASSIGN
         HEIGHT             = 18.65
         WIDTH              = 65.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB F-Frame-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW F-Frame-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR EDITOR EDITOR-DesMat-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CanPed-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-CodMat-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpLin IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ImpLin-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Libre_d02 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-PorDsctos2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-PorDsctos3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-PreUni IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-UndVta IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-UndVta-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-ValorAnterior IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DesMar IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DesMat-1 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DesMat-2 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_DesMat-3 IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_ImpTot IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = ""
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME FILL-IN-CanPed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CanPed F-Frame-Win
ON LEAVE OF FILL-IN-CanPed IN FRAME F-Main /* Cantidad */
DO:
    DEF VAR pRpta AS LOG NO-UNDO.

    /* *********************************************************************************** */
    /* PRECIO */
    /* *********************************************************************************** */
    RUN {&precio-venta-general} (s-CodCia,
                                 s-CodDiv,
                                 s-CodCli,
                                 s-CodMon,
                                 s-TpoCmb,
                                 OUTPUT f-Factor,
                                 FILL-IN-CodMat:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                 s-FlgSit,
                                 FILL-IN-UndVta:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                 DECIMAL(FILL-IN-CanPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                 s-NroDec,
                                 x-AlmDes,
                                 OUTPUT f-PreBas,
                                 OUTPUT f-PreVta,
                                 OUTPUT f-Dsctos,
                                 OUTPUT y-Dsctos,
                                 OUTPUT x-TipDto,
                                 OUTPUT f-FleteUnitario,
                                 OUTPUT pMensaje
                                 ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        RUN pda/d-message (pMensaje, "ERROR", "", OUTPUT pRpta).
        /*MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.*/
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    DISPLAY 
        F-PREVTA @ FILL-IN-PreUni 
        z-Dsctos @ FILL-IN-PorDsctos2
        y-Dsctos @ FILL-IN-PorDsctos3
        WITH FRAME {&FRAME-NAME}.

    RUN Importe-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CanPed-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CanPed-2 F-Frame-Win
ON LEAVE OF FILL-IN-CanPed-2 IN FRAME F-Main /* Cantidad */
DO:
  RUN Importe-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat F-Frame-Win
ON LEAVE OF FILL-IN-CodMat IN FRAME F-Main /* Artículo */
DO:
    IF SELF:SCREEN-VALUE = "" THEN RETURN.
    DEF VAR pRpta AS LOG NO-UNDO.

    DEF VAR pCodMat AS CHAR NO-UNDO.
    pCodMat = SELF:SCREEN-VALUE.
    RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, NO).
    IF TRUE <> (pCodMat > '') THEN DO:
        RUN pda/d-message ("Articulo NO válido", "ERROR", "", OUTPUT pRpta).
        ASSIGN SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.        

    SELF:SCREEN-VALUE = pCodMat.

    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = SELF:SCREEN-VALUE
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatg THEN DO:
        SELF:SCREEN-VALUE = ''.
        RETURN NO-APPLY.
    END.
    IF Almmmatg.Chr__01 = "" THEN DO:
       RUN pda/d-message ("Articulo " + pCodMat + " no tiene unidad de Oficina", "ERROR", "", OUTPUT pRpta).
       /*MESSAGE "Articulo " + pCodMat + " no tiene unidad de Oficina" VIEW-AS ALERT-BOX ERROR.*/
       ASSIGN SELF:SCREEN-VALUE = "".
       RETURN NO-APPLY.
    END.
    
    FILL-IN_DesMat-1:SCREEN-VALUE = SUBSTRING(Almmmatg.DesMat,1,35).
    FILL-IN_DesMat-2:SCREEN-VALUE = SUBSTRING(Almmmatg.DesMat,36,35).
    FILL-IN_DesMat-3:SCREEN-VALUE = SUBSTRING(Almmmatg.DesMat,71,35).
    FILL-IN_DesMar:SCREEN-VALUE = Almmmatg.DesMar.
    FILL-IN-UndVta:SCREEN-VALUE = Almmmatg.UndA.
    IF TRUE <> (Almmmatg.UndA > '') THEN FILL-IN-UndVta:SCREEN-VALUE = Almmmatg.UndSTk.


    /* ***************************************************************************************************************** */
    /* Buscamos si ya está registrado */
    /* ***************************************************************************************************************** */
    FILL-IN-ValorAnterior:SCREEN-VALUE = "0".
    FIND FIRST ITEM WHERE ITEM.codmat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF AVAILABLE ITEM THEN 
        ASSIGN 
        FILL-IN-CanPed:SCREEN-VALUE = STRING(ITEM.CanPed + 1)
        FILL-IN-ValorAnterior:SCREEN-VALUE = STRING(ITEM.CanPed).
    ELSE DO:
        DEF VAR pSugerido AS DECI NO-UNDO.
        DEF VAR pEmpaque AS DECI NO-UNDO.

        FILL-IN-CanPed:SCREEN-VALUE = "1".
        RUN vtagn/p-cantidad-sugerida-v2 (INPUT s-CodDiv,
                                        INPUT s-CodDiv,
                                        INPUT FILL-IN-CodMat:SCREEN-VALUE,
                                        INPUT 1,
                                        INPUT FILL-IN-UndVta:SCREEN-VALUE,
                                        INPUT s-CodCli,
                                        OUTPUT pSugerido,
                                        OUTPUT pEmpaque,
                                        OUTPUT pMensaje).
        IF pMensaje > '' AND pEmpaque > 1 THEN FILL-IN-CanPed:SCREEN-VALUE = STRING(pEmpaque).
    END.

    /* ***************************************************************************************************************** */

    /* *********************************************************************************** */
    /* PRECIO */
    /* *********************************************************************************** */
    RUN {&precio-venta-general} (s-CodCia,
                                 s-CodDiv,
                                 s-CodCli,
                                 s-CodMon,
                                 s-TpoCmb,
                                 OUTPUT f-Factor,
                                 FILL-IN-CodMat:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                 s-FlgSit,
                                 FILL-IN-UndVta:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                 DECIMAL(FILL-IN-CanPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                 s-NroDec,
                                 x-AlmDes,
                                 OUTPUT f-PreBas,
                                 OUTPUT f-PreVta,
                                 OUTPUT f-Dsctos,
                                 OUTPUT y-Dsctos,
                                 OUTPUT x-TipDto,
                                 OUTPUT f-FleteUnitario,
                                 OUTPUT pMensaje
                                 ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        RUN pda/d-message (pMensaje, "ERROR", "", OUTPUT pRpta).
        /*MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.*/
        SELF:SCREEN-VALUE = "".
        RETURN NO-APPLY.
    END.
    DISPLAY 
        F-PREVTA @ FILL-IN-PreUni 
        z-Dsctos @ FILL-IN-PorDsctos2
        y-Dsctos @ FILL-IN-PorDsctos3
        WITH FRAME {&FRAME-NAME}.

    RUN Importe-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-CodMat-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-CodMat-2 F-Frame-Win
ON LEAVE OF FILL-IN-CodMat-2 IN FRAME F-Main /* Artículo */
DO:
/*     IF SELF:SCREEN-VALUE = "" THEN RETURN.                                                                                  */
/*                                                                                                                             */
/*     DEF VAR pCodMat AS CHAR NO-UNDO.                                                                                        */
/*     pCodMat = SELF:SCREEN-VALUE.                                                                                            */
/*     RUN vta2/p-codigo-producto (INPUT-OUTPUT pCodMat, YES).                                                                 */
/*     IF TRUE <> (pCodMat > '') THEN DO:                                                                                      */
/*         ASSIGN SELF:SCREEN-VALUE = "".                                                                                      */
/*         RETURN NO-APPLY.                                                                                                    */
/*     END.                                                                                                                    */
/*                                                                                                                             */
/*     SELF:SCREEN-VALUE = pCodMat.                                                                                            */
/*                                                                                                                             */
/*     FIND Almmmatg WHERE Almmmatg.codcia = s-codcia                                                                          */
/*         AND Almmmatg.codmat = SELF:SCREEN-VALUE                                                                             */
/*         NO-LOCK.                                                                                                            */
/*     IF Almmmatg.Chr__01 = "" THEN DO:                                                                                       */
/*        MESSAGE "Articulo " + pCodMat + " no tiene unidad de Oficina" VIEW-AS ALERT-BOX ERROR.                               */
/*        ASSIGN SELF:SCREEN-VALUE = "".                                                                                       */
/*        RETURN NO-APPLY.                                                                                                     */
/*     END.                                                                                                                    */
/*                                                                                                                             */
/*     FILL-IN_DesMat-1:SCREEN-VALUE = SUBSTRING(Almmmatg.DesMat,1,45).                                                        */
/*     FILL-IN_DesMat-2:SCREEN-VALUE = SUBSTRING(Almmmatg.DesMat,46,45).                                                       */
/*     FILL-IN_DesMat-3:SCREEN-VALUE = SUBSTRING(Almmmatg.DesMat,91,45).                                                       */
/*     FILL-IN-UndVta:SCREEN-VALUE = Almmmatg.UndA.                                                                            */
/*     IF TRUE <> (Almmmatg.UndA > '') THEN FILL-IN-UndVta:SCREEN-VALUE = Almmmatg.UndSTk.                                     */
/*                                                                                                                             */
/*                                                                                                                             */
/*     /* ***************************************************************************************************************** */ */
/*     /* Buscamos si ya está registrado */                                                                                    */
/*     /* ***************************************************************************************************************** */ */
/*     FILL-IN-ValorAnterior:SCREEN-VALUE = "0".                                                                               */
/*     FIND FIRST ITEM WHERE ITEM.codmat = SELF:SCREEN-VALUE NO-LOCK NO-ERROR.                                                 */
/*     IF AVAILABLE ITEM THEN                                                                                                  */
/*         ASSIGN                                                                                                              */
/*         FILL-IN-CanPed:SCREEN-VALUE = STRING(ITEM.CanPed + 1)                                                               */
/*         FILL-IN-ValorAnterior:SCREEN-VALUE = STRING(ITEM.CanPed).                                                           */
/*                                                                                                                             */
/*     /* ***************************************************************************************************************** */ */
/*                                                                                                                             */
/*     /* *********************************************************************************** */                               */
/*     /* PRECIO */                                                                                                            */
/*     /* *********************************************************************************** */                               */
/*     RUN {&precio-venta-general} (s-CodCia,                                                                                  */
/*                                  s-CodDiv,                                                                                  */
/*                                  s-CodCli,                                                                                  */
/*                                  s-CodMon,                                                                                  */
/*                                  s-TpoCmb,                                                                                  */
/*                                  OUTPUT f-Factor,                                                                           */
/*                                  FILL-IN-CodMat:SCREEN-VALUE IN FRAME {&FRAME-NAME},                                        */
/*                                  s-FlgSit,                                                                                  */
/*                                  FILL-IN-UndVta:SCREEN-VALUE IN FRAME {&FRAME-NAME},                                        */
/*                                  DECIMAL(FILL-IN-CanPed:SCREEN-VALUE IN FRAME {&FRAME-NAME}),                               */
/*                                  s-NroDec,                                                                                  */
/*                                  x-AlmDes,                                                                                  */
/*                                  OUTPUT f-PreBas,                                                                           */
/*                                  OUTPUT f-PreVta,                                                                           */
/*                                  OUTPUT f-Dsctos,                                                                           */
/*                                  OUTPUT y-Dsctos,                                                                           */
/*                                  OUTPUT x-TipDto,                                                                           */
/*                                  OUTPUT f-FleteUnitario,                                                                    */
/*                                  OUTPUT pMensaje                                                                            */
/*                                  ).                                                                                         */
/*     IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                                                                  */
/*         MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.                                                                           */
/*         SELF:SCREEN-VALUE = "".                                                                                             */
/*         RETURN NO-APPLY.                                                                                                    */
/*     END.                                                                                                                    */
/*     DISPLAY                                                                                                                 */
/*         F-PREVTA @ FILL-IN-PreUni                                                                                           */
/*         z-Dsctos @ FILL-IN-PorDsctos2                                                                                       */
/*         y-Dsctos @ FILL-IN-PorDsctos3                                                                                       */
/*         WITH FRAME {&FRAME-NAME}.                                                                                           */
/*                                                                                                                             */
/*     RUN Importe-Total.                                                                                                      */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME IMAGE-Down
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL IMAGE-Down F-Frame-Win
ON MOUSE-SELECT-CLICK OF IMAGE-Down IN FRAME F-Main
DO:
    IF DECIMAL(FILL-IN-CanPed:SCREEN-VALUE) = 1 THEN RETURN.
    ASSIGN 
        FILL-IN-CanPed:SCREEN-VALUE = STRING(DECIMAL(FILL-IN-CanPed:SCREEN-VALUE) - 1) 
        NO-ERROR.
    RUN Importe-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME IMAGE-Reset
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL IMAGE-Reset F-Frame-Win
ON MOUSE-SELECT-CLICK OF IMAGE-Reset IN FRAME F-Main
DO:
  /* Limpiamos variables y solicitamos nuevo registro */
  ASSIGN
      FILL-IN_DesMat-1 = ''
      FILL-IN_DesMat-2 = ''
      FILL-IN_DesMat-3 = ''
      FILL-IN_DesMar  = ''
      FILL-IN-CanPed = 1
      FILL-IN-CodMat = ""
      FILL-IN-ImpLin = 0
      FILL-IN-Libre_d02 = 0
      FILL-IN-PorDsctos2 = 0
      FILL-IN-PorDsctos3 = 0
      FILL-IN-PreUni = 0
      FILL-IN-UndVta = "".
  DISPLAY FILL-IN-CanPed FILL-IN-CodMat FILL-IN-ImpLin 
      FILL-IN-Libre_d02 FILL-IN-PorDsctos2 FILL-IN-PorDsctos3 
      FILL-IN-PreUni FILL-IN-UndVta
      FILL-IN_DesMat-1 FILL-IN_DesMat-2 FILL-IN_DesMat-3 FILL-IN_DesMar
      WITH FRAME {&FRAME-NAME}.
  APPLY 'ENTRY':U TO FILL-IN-CodMat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME IMAGE-Up
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL IMAGE-Up F-Frame-Win
ON MOUSE-SELECT-CLICK OF IMAGE-Up IN FRAME F-Main
DO:
  ASSIGN 
      FILL-IN-CanPed:SCREEN-VALUE = STRING(DECIMAL(FILL-IN-CanPed:SCREEN-VALUE) + 1) 
      NO-ERROR.
  RUN Importe-Total.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK F-Frame-Win 


/* ***************************  Main Block  *************************** */

ON 'RETURN':U OF FILL-IN-CanPed, FILL-IN-CodMat DO:
    APPLY 'TAB':U.
    RETURN NO-APPLY.
END.

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
   /* Now enable the interface  if in test mode - otherwise this happens when
      the object is explicitly initialized from its container. */
   RUN dispatch IN THIS-PROCEDURE ('initialize':U).
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects F-Frame-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available F-Frame-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura-Temporal F-Frame-Win 
PROCEDURE Captura-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER TABLE FOR ITEM.

    ASSIGN
        FILL-IN_DesMat-1 = ''
        FILL-IN_DesMat-2 = ''
        FILL-IN_DesMat-3 = ''
        FILL-IN_DesMar = ''
        FILL-IN-CanPed = 1
        FILL-IN-CodMat = ""
        FILL-IN-ImpLin = 0
        FILL-IN-Libre_d02 = 0
        FILL-IN-PorDsctos2 = 0
        FILL-IN-PorDsctos3 = 0
        FILL-IN-PreUni = 0
        FILL-IN-UndVta = "".
DISPLAY FILL-IN-CanPed FILL-IN-CodMat FILL-IN-ImpLin 
    FILL-IN-Libre_d02 FILL-IN-PorDsctos2 FILL-IN-PorDsctos3 
    FILL-IN-PreUni FILL-IN-UndVta
    FILL-IN_DesMat-1 FILL-IN_DesMat-2 FILL-IN_DesMat-3 FILL-IN_DesMar
    WITH FRAME {&FRAME-NAME}.

RUN Pinta-Total-General.

APPLY 'ENTRY':U TO FILL-IN-CodMat IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Devuelve-Temporal F-Frame-Win 
PROCEDURE Devuelve-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER TABLE FOR ITEM.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI F-Frame-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI F-Frame-Win  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-CodMat FILL-IN_DesMat-1 FILL-IN_DesMat-2 FILL-IN_DesMat-3 
          FILL-IN_DesMar FILL-IN-CanPed FILL-IN-ValorAnterior FILL-IN-UndVta 
          FILL-IN-Libre_d02 FILL-IN-PorDsctos2 FILL-IN-PreUni FILL-IN-PorDsctos3 
          FILL-IN-ImpLin FILL-IN_ImpTot FILL-IN-CodMat-2 FILL-IN-CanPed-2 
          FILL-IN-UndVta-2 FILL-IN-ImpLin-2 EDITOR-DesMat-2 
      WITH FRAME F-Main.
  ENABLE RECT-1 IMAGE-Up IMAGE-Down RECT-3 IMAGE-Reset FILL-IN-CodMat 
         FILL-IN-CanPed 
      WITH FRAME F-Main.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Registro F-Frame-Win 
PROCEDURE Graba-Registro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Consistencia */
ASSIGN FRAME {&FRAME-NAME}
    FILL-IN-CanPed FILL-IN-CodMat FILL-IN-ImpLin FILL-IN-Libre_d02 
    FILL-IN-PorDsctos2 FILL-IN-PorDsctos3 FILL-IN-PreUni FILL-IN-UndVta.

IF TRUE <> (FILL-IN-CodMat > '') OR FILL-IN-CanPed <= 0 THEN RETURN 'ADM-ERROR'.

/* *********************************************************************************** */
/* STOCK COMPROMETIDO */
/* *********************************************************************************** */
DEF VAR s-StkComprometido AS DEC NO-UNDO.
DEF VAR x-StkAct AS DEC NO-UNDO.

FIND Almmmate WHERE Almmmate.codcia = s-codcia
    AND Almmmate.codalm = x-AlmDes
    AND Almmmate.codmat = FILL-IN-CodMat
    NO-LOCK NO-ERROR.
IF AVAILABLE Almmmate THEN x-StkAct = Almmmate.StkAct.
IF x-StkAct > 0 THEN DO:
  RUN gn/Stock-Comprometido-v2 (FILL-IN-CodMat, 
                                x-AlmDes, 
                                YES,    /* Tomar en cuenta venta contado */
                                OUTPUT s-StkComprometido).
END.
ASSIGN
  x-CanPed = FILL-IN-CanPed * f-Factor.

DEF VAR pRpta AS LOG NO-UNDO.
IF (x-StkAct - s-StkComprometido) < x-CanPed THEN DO:
    RUN pda/d-message ("No hay STOCK suficiente" + CHR(10) + CHR(10) +
                       "STOCK ACTUAL: " + STRING(x-StkAct) + " " + Almmmatg.undbas + CHR(10) +
                       "STOCK COMPROMETIDO: " + STRING(s-StkComprometido) + " " + Almmmatg.undbas + CHR(10) +
                       "STOCK DISPONIBLE: " + STRING(x-StkAct - s-StkComprometido) + " " + Almmmatg.undbas
                       , 
                       "ERROR", 
                       "", 
                       OUTPUT pRpta).
/*     MESSAGE "No hay STOCK suficiente" SKIP(1)                                            */
/*             "       STOCK ACTUAL : " x-StkAct Almmmatg.undbas SKIP                       */
/*             "  STOCK COMPROMETIDO: " s-StkComprometido Almmmatg.undbas SKIP              */
/*             "   STOCK DISPONIBLE : " (x-StkAct - s-StkComprometido) Almmmatg.undbas SKIP */
/*             VIEW-AS ALERT-BOX ERROR.                                                     */
    APPLY 'ENTRY':U TO FILL-IN-CanPed.
    RETURN "ADM-ERROR".
END.
/* *********************************************************************************** */
/* *********************************************************************************** */
/* EMPAQUE */
/* *********************************************************************************** */
DEF VAR pSugerido AS DEC NO-UNDO.
DEF VAR pEmpaque AS DEC NO-UNDO.
DEF VAR pCanPed AS DEC NO-UNDO.

pCanPed = FILL-IN-CanPed.
RUN vtagn/p-cantidad-sugerida-v2 (INPUT s-CodDiv,
                                INPUT s-CodDiv,
                                INPUT Almmmatg.codmat,
                                INPUT pCanPed,
                                INPUT FILL-IN-UndVta,
                                INPUT s-CodCli,
                                OUTPUT pSugerido,
                                OUTPUT pEmpaque,
                                OUTPUT pMensaje).
IF pMensaje > '' THEN DO:
    RUN pda/d-message (pMensaje, "ERROR", "", OUTPUT pRpta).
    /*MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.*/
    FILL-IN-CanPed:SCREEN-VALUE = STRING(pSugerido).
    APPLY 'ENTRY':U TO FILL-IN-CanPed.
    RETURN "ADM-ERROR".
END.
/* *********************************************************************************** */
/* *********************************************************************************** */
/* Buscamos si ya tiene registro */
FIND FIRST ITEM WHERE ITEM.codmat = FILL-IN-CodMat NO-LOCK NO-ERROR.
IF AVAILABLE ITEM THEN FIND CURRENT ITEM EXCLUSIVE-LOCK.
ELSE CREATE ITEM.

ASSIGN
    ITEM.CodCia = s-codcia
    ITEM.CodDiv = s-coddiv
    ITEM.CodDoc = s-coddoc
    ITEM.CodCli = s-codcli
    ITEM.codmat = FILL-IN-CodMat
    ITEM.AlmDes = x-AlmDes
    ITEM.CanPed = FILL-IN-CanPed
    ITEM.Factor = f-Factor
    ITEM.Libre_c04 = x-TipDto
    ITEM.PorDto = f-Dsctos
    ITEM.Por_Dsctos[1] = 0
    ITEM.Por_Dsctos[2] = FILL-IN-PorDsctos2
    ITEM.Por_Dsctos[3] = FILL-IN-PorDsctos3
    ITEM.PreBas = F-PreBas 
    ITEM.PreUni = FILL-IN-PreUni
    ITEM.PreVta[1] = F-PreVta
    ITEM.UndVta = FILL-IN-UndVta
    ITEM.AftIgv = Almmmatg.AftIgv
    ITEM.AftIsc = Almmmatg.AftIsc
    .

FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = ITEM.UndVta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    pMensaje = 'NO está configurado el factor de equivalencia para el producto ' + Almmmatg.codmat + CHR(10) +
        'Unidad de venta: ' + ITEM.UndVta + CHR(10) +
        'Grabación abortada'.
    RUN pda/d-message (pMensaje, "ERROR", "", OUTPUT pRpta).
    /*MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.*/
    UNDO, RETURN "ADM-ERROR".
END.

F-FACTOR = Almtconv.Equival.
ASSIGN 
  ITEM.CodCia = S-CODCIA
  ITEM.Factor = F-FACTOR
  ITEM.NroItm = I-NroItm
  ITEM.PorDto = f-Dsctos
  ITEM.PreBas = F-PreBas 
  ITEM.PreVta[1] = F-PreVta     /* CONTROL DE PRECIO DE LISTA */
  ITEM.AftIgv = Almmmatg.AftIgv
  ITEM.AftIsc = Almmmatg.AftIsc
  ITEM.Libre_c04 = x-TipDto.
ASSIGN 
  ITEM.PreUni = FILL-IN-PreUni
  ITEM.Por_Dsctos[1] = 0
  ITEM.Por_Dsctos[2] = FILL-IN-PorDsctos2
  ITEM.Por_Dsctos[3] = FILL-IN-PorDsctos3
  ITEM.Libre_d02     = f-FleteUnitario.
ASSIGN
  ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
  THEN ITEM.ImpDto = 0.
  ELSE ITEM.ImpDto = ITEM.CanPed * ITEM.PreUni - ITEM.ImpLin.
IF f-FleteUnitario > 0 THEN DO:
  /* El flete afecta el monto final */
  IF ITEM.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
      ASSIGN
          ITEM.PreUni = ROUND(f-PreVta + f-FleteUnitario, s-NroDec)  /* Incrementamos el PreUni */
          ITEM.ImpLin = ITEM.CanPed * ITEM.PreUni.
  END.
  ELSE DO:      /* CON descuento promocional o volumen */
      /* El flete afecta al precio unitario resultante */
      DEF VAR x-PreUniFin LIKE Facdpedi.PreUni NO-UNDO.
      DEF VAR x-PreUniTeo LIKE Facdpedi.PreUni NO-UNDO.

      x-PreUniFin = ITEM.ImpLin / ITEM.CanPed.          /* Valor resultante */
      x-PreUniFin = x-PreUniFin + f-FleteUnitario.      /* Unitario Afectado al Flete */

      x-PreUniTeo = x-PreUniFin / ( ( 1 - ITEM.Por_Dsctos[1] / 100 ) * ( 1 - ITEM.Por_Dsctos[2] / 100 ) * ( 1 - ITEM.Por_Dsctos[3] / 100 ) ).

      ASSIGN
          ITEM.PreUni = ROUND(x-PreUniTeo, s-NroDec).
  END.
  ASSIGN
      ITEM.ImpLin = ROUND ( ITEM.CanPed * ITEM.PreUni * 
                    ( 1 - ITEM.Por_Dsctos[1] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[2] / 100 ) *
                    ( 1 - ITEM.Por_Dsctos[3] / 100 ), 2 ).
  IF ITEM.Por_Dsctos[1] = 0 AND ITEM.Por_Dsctos[2] = 0 AND ITEM.Por_Dsctos[3] = 0 
      THEN ITEM.ImpDto = 0.
      ELSE ITEM.ImpDto = (ITEM.CanPed * ITEM.PreUni) - ITEM.ImpLin.
END.
/* ***************************************************************** */

ASSIGN
  ITEM.ImpLin = ROUND(ITEM.ImpLin, 2)
  ITEM.ImpDto = ROUND(ITEM.ImpDto, 2).
IF ITEM.AftIsc 
THEN ITEM.ImpIsc = ROUND(ITEM.PreBas * ITEM.CanPed * (Almmmatg.PorIsc / 100),4).
ELSE ITEM.ImpIsc = 0.
IF ITEM.AftIgv 
THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
ELSE ITEM.ImpIgv = 0.

/* Pintamos último dato grabado */
DISPLAY
    ITEM.CanPed @ FILL-IN-CanPed-2 
    ITEM.CodMat @ FILL-IN-CodMat-2 
    ITEM.UndVta @ FILL-IN-UndVta-2
    ITEM.ImpLin @ FILL-IN-ImpLin-2
    WITH FRAME {&FRAME-NAME}.
EDITOR-DesMat-2 :SCREEN-VALUE IN FRAME {&frame-name} = Almmmatg.DesMat.
/* Limpiamos variables y solicitamos nuevo registro */
    ASSIGN
        FILL-IN_DesMat-1 = ''
        FILL-IN_DesMat-2 = ''
        FILL-IN_DesMat-3 = ''
        FILL-IN_DesMar = ''
        FILL-IN-CanPed = 1
        FILL-IN-CodMat = ""
        FILL-IN-ImpLin = 0
        FILL-IN-Libre_d02 = 0
        FILL-IN-PorDsctos2 = 0
        FILL-IN-PorDsctos3 = 0
        FILL-IN-PreUni = 0
        FILL-IN-UndVta = "".
DISPLAY FILL-IN-CanPed FILL-IN-CodMat FILL-IN-ImpLin 
    FILL-IN-Libre_d02 FILL-IN-PorDsctos2 FILL-IN-PorDsctos3 
    FILL-IN-PreUni FILL-IN-UndVta
    FILL-IN_DesMat-1 FILL-IN_DesMat-2 FILL-IN_DesMat-3 FILL-IN_DesMar
    WITH FRAME {&FRAME-NAME}.

RELEASE ITEM.

RUN Pinta-Total-General.
APPLY 'ENTRY':U TO FILL-IN-CodMat IN FRAME {&FRAME-NAME}.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Importe-Total F-Frame-Win 
PROCEDURE Importe-Total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


  ASSIGN FRAME {&FRAME-NAME}
      FILL-IN-CanPed 
      FILL-IN-CodMat 
      FILL-IN-Libre_d02 
      FILL-IN-PorDsctos2 
      FILL-IN-PorDsctos3 
      FILL-IN-PreUni 
      FILL-IN-UndVta
      .

  ASSIGN
      FILL-IN-ImpLin = ROUND ( FILL-IN-CanPed * FILL-IN-PreUni * 
                    ( 1 - 0 / 100 ) *
                    ( 1 - FILL-IN-PorDsctos2 / 100 ) *
                    ( 1 - FILL-IN-PorDsctos3 / 100 ), 2 ).
  IF FILL-IN-PorDsctos2 = 0 AND FILL-IN-PorDsctos3 = 0 
      THEN x-ImpDto = 0.
      ELSE x-ImpDto = FILL-IN-CanPed * FILL-IN-PreUni - FILL-IN-ImpLin.
  IF f-FleteUnitario > 0 THEN DO:
      /* El flete afecta el monto final */
      IF x-ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
          ASSIGN
              FILL-IN-PreUni = ROUND(f-PreVta + f-FleteUnitario, s-NroDec)  /* Incrementamos el PreUni */
              FILL-IN-ImpLin = FILL-IN-CanPed * FILL-IN-PreUni.
      END.
      ELSE DO:      /* CON descuento promocional o volumen */
          /* El flete afecta al precio unitario resultante */
          DEF VAR x-PreUniFin LIKE Facdpedi.PreUni NO-UNDO.
          DEF VAR x-PreUniTeo LIKE Facdpedi.PreUni NO-UNDO.

          x-PreUniFin = FILL-IN-ImpLin / FILL-IN-CanPed.          /* Valor resultante */
          x-PreUniFin = x-PreUniFin + f-FleteUnitario.      /* Unitario Afectado al Flete */

          x-PreUniTeo = x-PreUniFin / ( ( 1 - 0 / 100 ) * ( 1 - FILL-IN-PorDsctos2 / 100 ) * ( 1 - FILL-IN-PorDsctos3 / 100 ) ).

          ASSIGN
              FILL-IN-PreUni = ROUND(x-PreUniTeo, s-NroDec).
      END.
      ASSIGN
          FILL-IN-ImpLin = ROUND ( FILL-IN-CanPed * FILL-IN-PreUni * 
                        ( 1 - 0 / 100 ) *
                        ( 1 - FILL-IN-PorDsctos2 / 100 ) *
                        ( 1 - FILL-IN-PorDsctos3 / 100 ), 2 ).
      IF FILL-IN-PorDsctos2 = 0 AND FILL-IN-PorDsctos3 = 0 
          THEN x-ImpDto = 0.
          ELSE x-ImpDto = (FILL-IN-CanPed * FILL-IN-PreUni) - FILL-IN-ImpLin.
  END.
  /* ***************************************************************** */

  ASSIGN
      FILL-IN-ImpLin = ROUND(FILL-IN-ImpLin, 2)
      x-ImpDto = ROUND(x-ImpDto, 2).

  FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = FILL-IN-CodMat NO-LOCK NO-ERROR.
  IF AVAILABLE Almmmatg THEN DO:
      IF Almmmatg.AftIsc 
      THEN x-ImpIsc = ROUND(FILL-IN-PreUni * FILL-IN-CanPed * (Almmmatg.PorIsc / 100),4).
      ELSE x-ImpIsc = 0.
      IF Almmmatg.AftIgv 
      THEN x-ImpIgv = FILL-IN-ImpLin - ROUND( FILL-IN-ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
      ELSE x-ImpIgv = 0.
  END.

  DISPLAY FILL-IN-ImpLin WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pinta-Total-General F-Frame-Win 
PROCEDURE Pinta-Total-General :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DEF BUFFER B-ITEM FOR ITEM.

    FILL-IN_ImpTot = 0.
    FOR EACH B-ITEM NO-LOCK:
        FILL-IN_ImpTot = FILL-IN_ImpTot + B-ITEM.ImpLin.
    END.
    DISPLAY FILL-IN_ImpTot WITH FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records F-Frame-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartFrame, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed F-Frame-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Update-SKU F-Frame-Win 
PROCEDURE Update-SKU :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pCodMat AS CHAR.

FIND FIRST ITEM WHERE ITEM.codmat = pCodMat NO-LOCK NO-ERROR.
IF NOT AVAILABLE ITEM THEN RETURN.

DO WITH FRAME {&FRAME-NAME}:
    FILL-IN-CodMat:SCREEN-VALUE = ITEM.CodMat.
    APPLY 'LEAVE':U TO FILL-IN-CodMat.
    APPLY 'ENTRY':U TO FILL-IN-CanPed.
    DISPLAY ITEM.CanPed @ FILL-IN-CanPed.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

