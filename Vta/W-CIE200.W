&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
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
DEFINE     SHARED VARIABLE S-CODCIA   AS INTEGER.
DEFINE     SHARED VARIABLE S-CODDIV   AS CHAR.
DEFINE     SHARED VARIABLE S-CODVEN   AS CHAR.
DEFINE     SHARED VARIABLE S-USER-ID  AS CHAR.

/* Local Variable Definitions ---                                       */
DEF VAR wtotsol AS DEC NO-UNDO.
DEF VAR wtotdol AS DEC NO-UNDO.
DEF VAR wtotcts AS DEC NO-UNDO.
DEF VAR wtotctd AS DEC NO-UNDO.
DEF VAR wtotcrs AS DEC NO-UNDO.
DEF VAR wtotcrd AS DEC NO-UNDO.

DEF VAR wfactor AS DECIMAL NO-UNDO.
DEF VAR I       AS INT NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 W-PERIODO W-MES BUTTON-12 ~
BUTTON-13 BUTTON-14 COMBO-BOX-1 
&Scoped-Define DISPLAYED-OBJECTS W-PERIODO W-MES COMBO-BOX-1 FILL-IN-1 ~
EDITOR-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-12 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "&Cerrar" 
     SIZE 12.43 BY 1.54.

DEFINE BUTTON BUTTON-13 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 12.43 BY 1.58.

DEFINE BUTTON BUTTON-14 
     IMAGE-UP FILE "img\ayuda":U
     LABEL "help" 
     SIZE 12.43 BY 1.54.

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "A¤o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "A¤o","Mes" 
     SIZE 80 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR-2 AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 47.43 BY 4.23
     BGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.29 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE W-MES AS INTEGER FORMAT "99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 4 BY .81 NO-UNDO.

DEFINE VARIABLE W-PERIODO AS INTEGER FORMAT "9,999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5.57 BY .73 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48.43 BY 9.92.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.29 BY 1.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     W-PERIODO AT ROW 5.85 COL 14.14 COLON-ALIGNED NO-LABEL
     W-MES AT ROW 5.85 COL 29.29 COLON-ALIGNED NO-LABEL
     BUTTON-12 AT ROW 8.81 COL 3.57
     BUTTON-13 AT ROW 8.81 COL 18.43
     BUTTON-14 AT ROW 8.81 COL 33.43
     COMBO-BOX-1 AT ROW 16.92 COL 1 NO-LABEL
     FILL-IN-1 AT ROW 7.12 COL 2.14 NO-LABEL
     EDITOR-2 AT ROW 1.15 COL 1.72 NO-LABEL
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 5.5 COL 2
     "Periodo" VIEW-AS TEXT
          SIZE 8.57 BY .65 AT ROW 5.85 COL 6.86
          FONT 0
     "Mes" VIEW-AS TEXT
          SIZE 5.14 BY .65 AT ROW 5.85 COL 25.86
          FONT 0
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17
         FONT 4.

 

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
         TITLE              = "Cierre Mensual"
         HEIGHT             = 10.15
         WIDTH              = 48.43
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 91.43
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

IF NOT W-Win:LOAD-ICON("img\i-cie100":U) THEN
    MESSAGE "Unable to load icon: img\i-cie100"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   Custom                                                               */
/* SETTINGS FOR COMBO-BOX COMBO-BOX-1 IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR EDITOR EDITOR-2 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       EDITOR-2:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Cierre Mensual */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Cierre Mensual */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 W-Win
ON CHOOSE OF BUTTON-12 IN FRAME F-Main /* Cerrar */
DO:
  ASSIGN
        w-periodo
        w-mes.
      
  MESSAGE " Esta seguro de cerrar " VIEW-AS ALERT-BOX QUESTION 
  BUTTONS yes-no
  UPDATE wresp AS LOGICAL.
  CASE wresp:
       WHEN yes THEN DO:
            IF w-mes = 0 then DO:
               MESSAGE " DIGITE EL MES A CERRAR " VIEW-AS ALERT-BOX ERROR.
               APPLY "ENTRY" TO w-mes.
               return NO-APPLY.  
            END.   
            if session:set-wait-state("GENERAL") then.
            RUN Cierre-Division.
            RUN Cierre-Clientes.   
            RUN Cierre-Vendedores. 
            RUN Cierre-Articulos.  
/*          RUN Relacion-Cliente-Articulo.  */
            if session:set-wait-state(" ") then.
            MESSAGE " Proceso Terminado " VIEW-AS ALERT-BOX INFORMATION. 
            END.  
       WHEN no  THEN 
            RETURN.
  END CASE.
/*  slider-3 = slider-3  + 1.
    display slider-3 with frame f-main.  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-12 W-Win
ON ENTRY OF BUTTON-12 IN FRAME F-Main /* Cerrar */
DO:
   IF BUTTON-12:LOAD-MOUSE-POINTER("GLOVE") THEN . 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 W-Win
ON CHOOSE OF BUTTON-13 IN FRAME F-Main /* Cancelar */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-13 W-Win
ON ENTRY OF BUTTON-13 IN FRAME F-Main /* Cancelar */
DO:
  IF BUTTON-13:LOAD-MOUSE-POINTER("GLOVE") THEN . 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-14 W-Win
ON ENTRY OF BUTTON-14 IN FRAME F-Main /* help */
DO:
  IF BUTTON-14:LOAD-MOUSE-POINTER("GLOVE") THEN. 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-Articulos W-Win 
PROCEDURE Cierre-Articulos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: Cierre Mensual Articulos x Division 
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-tpocm1 AS DECIMAL NO-UNDO.
DEFINE VAR x-tpocm2 AS DECIMAL NO-UNDO.
DEFINE VAR wcansol  AS DECIMAL NO-UNDO.
DEFINE VAR wcandol  AS DECIMAL NO-UNDO.
DEFINE VAR wtovtso  AS DECIMAL NO-UNDO.
DEFINE VAR wtovtdo  AS DECIMAL NO-UNDO.
DEFINE VAR wtotgen  AS DECIMAL NO-UNDO.
DEFINE VAR wcanper  AS DECIMAL NO-UNDO.
DEFINE VAR wimpper  AS DECIMAL NO-UNDO.
DEFINE VAR wcancts  AS DECIMAL NO-UNDO. 
DEFINE VAR wcancrs  AS DECIMAL NO-UNDO. 
DEFINE VAR wcanctd  AS DECIMAL NO-UNDO. 
DEFINE VAR wcancrd  AS DECIMAL NO-UNDO.
DEFINE VAR wimpcts  AS DECIMAL NO-UNDO. 
DEFINE VAR wimpcrs  AS DECIMAL NO-UNDO. 
DEFINE VAR wimpctd  AS DECIMAL NO-UNDO. 
DEFINE VAR wimpcrd  AS DECIMAL NO-UNDO.
         
x-tpocm1 = 1.
x-tpocm2 = 1.
ASSIGN
    fill-in-1 = "CIERRE MES X ARTICULOS : " + s-coddiv.
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
         
FOR EACH CcbCdocu NO-LOCK WHERE
         CcbCDocu.CodCia = s-codcia AND
         CcbCDocu.CodDiv = s-coddiv AND 
         YEAR(CcbCDocu.FchDoc)  = w-periodo AND 
         MONTH(CcbCDocu.FchDoc) = w-mes AND
         (CcbCDocu.CodDoc = "FAC" OR CcbCDocu.CodDoc = "BOL") AND
         CcbCDocu.FlgEst <> "A" , EACH CcbDdocu OF ccbCdocu , FIRST Almmmatg OF CcbDdocu NO-LOCK
         BREAK BY ccbDdocu.CodMat:

/*  Captura Tipo Cambio */
FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= CcbCDocu.Fchdoc NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN 
        ASSIGN
           x-tpocm2 = gn-tcmb.compra
           x-tpocm1 = gn-tcmb.venta.
    
/*  Totales por Articulo */
    IF FIRST-OF(ccbDdocu.CodMat) THEN DO:
       wcansol = 0.
       wcandol = 0.
       wcancts = 0.
       wcanctd = 0.
       wcancrs = 0.
       wcancrd = 0.
       wimpcts = 0.
       wimpctd = 0.
       wimpcrs = 0.
       wimpcrd = 0.
    END.  
        
    IF ccbCdocu.CodMon = 1 THEN wcansol = wcansol + ccbDdocu.ImpLin.
    IF ccbCdocu.CodMon = 2 THEN wcandol = wcandol + ccbDdocu.ImpLin.
    
    IF ccbCdocu.TipVta = "1" AND ccbCdocu.CodMon = 1 THEN DO:
       wcancts = wcancts + (CcbDDocu.CanDes * CcbDDocu.Factor).
       wimpcts = wimpcts + (ccbDdocu.ImpLin / x-tpocm1).
    END.   
    IF ccbCdocu.TipVta = "1" AND ccbCdocu.CodMon = 2 THEN DO:
       wcanctd = wcanctd + (CcbDDocu.CanDes * CcbDDocu.Factor).
       wimpctd = wimpctd + ccbDdocu.ImpLin.
    END.   
    IF ccbCdocu.TipVta = "2" AND ccbCdocu.CodMon = 1 THEN DO:
       wcancrs = wcancrs + (CcbDDocu.CanDes * CcbDDocu.Factor).
       wimpcrs = wimpcrs + (ccbDdocu.ImpLin / x-tpocm1).
    END.   
    IF ccbCdocu.TipVta = "2" AND ccbCdocu.CodMon = 2 THEN DO:
       wcancrd = wcancrd + (CcbDDocu.CanDes * CcbDDocu.Factor).
       wimpcrd = wimpcrd + ccbDdocu.ImpLin.
    END.   
        
    ASSIGN
          fill-in-1 = CcbDdocu.CodMat + "-" + Almmmatg.DesMat. 
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
    
/*    IF ccbDdocu.CodMat = "010026" then DO:
       MESSAGE ccbDdocu.ImpLin CODMON ccbDdocu.CODMAT x-tpocm1 wimpcts wimpctd wimpcrs wimpcrd.
    END.   */
    
    IF LAST-OF(ccbDdocu.CodMat) THEN DO:
       FIND TmsVart0 WHERE TmsVart0.CodCia = s-codcia AND
            TmsVart0.CodDiv = s-coddiv  AND
            TmsVart0.Period = w-periodo AND
            TmsVart0.CodArt = ccbDdocu.codMat USE-INDEX TmsVart1 EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE TmsVart0 THEN DO:
               ASSIGN 
                      TmsVart0.DesArt        = Almmmatg.DesMat
                      TmsVart0.Unidad        = Almmmatg.UndStk 
                      TmsVart0.DesMar        = Almmmatg.DesMar
                      TmsVart0.CodFam        = Almmmatg.CodFam 
                      TmsVart0.CodSub        = Almmmatg.subfam 
                      TmsVart0.CodPro        = Almmmatg.CodPr1
                      TmsVart0.CanCon[w-mes] = wcancts + wcanctd
                      TmsVart0.CanCre[w-mes] = wcancrs + wcancrd
                      TmsVart0.CanMes[w-mes] = (wcancts + wcanctd) + (wcancrs + wcancrd) 
                      TmsVart0.ImpCon[w-mes] = wimpcts + wimpctd
                      TmsVart0.ImpCre[w-mes] = wimpcrs + wimpcrd
                      TmsVart0.ImpMes[w-mes] = (wimpcts + wimpctd) + (wimpcrs + wimpcrd).
            END. 
            ELSE DO:
               CREATE TmsVart0.
               ASSIGN TmsVart0.CodCia        = s-codcia
                      TmsVart0.CodDiv        = s-coddiv
                      TmsVart0.Period        = w-periodo
                      TmsVart0.CodArt        = ccbDdocu.CodMat
                      TmsVart0.DesArt        = Almmmatg.DesMat
                      TmsVart0.Unidad        = Almmmatg.UndStk 
                      TmsVart0.DesMar        = Almmmatg.DesMar
                      TmsVart0.CodFam        = Almmmatg.CodFam 
                      TmsVart0.CodSub        = Almmmatg.subfam 
                      TmsVart0.CodPro        = Almmmatg.CodPr1
                      TmsVart0.CanCon[w-mes] = wcancts + wcanctd
                      TmsVart0.CanCre[w-mes] = wcancrs + wcancrd
                      TmsVart0.CanMes[w-mes] = (wcancts + wcanctd) + (wcancrs + wcancrd) 
                      TmsVart0.ImpCon[w-mes] = wimpcts + wimpctd
                      TmsVart0.ImpCre[w-mes] = wimpcrs + wimpcrd
                      TmsVart0.ImpMes[w-mes] = (wimpcts + wimpctd) + (wimpcrs + wimpcrd).
            END.         
            Release TmsVart0.
    END.
END.

/* ACTUALIZA CANTIDADES POR ARTICULOS */
        
   ASSIGN
      fill-in-1 = "   ACTUALIZA TOTALES POR ARTICULOS   ". 
      DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 

wtotgen = 0.
FOR EACH TmsVart0 WHERE TmsVart0.CodCia = s-codcia AND
    TmsVart0.CodDiv = s-coddiv AND
    TmsVart0.Period = w-periodo EXCLUSIVE-LOCK:
    wcanper = 0.
    wimpper = 0.
    DO I = 1 TO 12: 
       wcanper = wcanper + (TmsVart0.CanMes[i]).     
       wimpper = wimpper + (TmsVart0.ImpMes[i]).     
    END.
    ASSIGN
         TmsVart0.CanPeri = wcanper
         TmsVart0.ImpPeri = wimpper.             
         wtotgen = wtotgen + wimpper. 
END.

/* Actualiza Factores x Periodo */
FOR EACH TmsVart0 WHERE TmsVart0.CodCia = s-codcia AND
    TmsVart0.CodDiv = s-coddiv AND
    TmsVart0.Period = w-periodo EXCLUSIVE-LOCK:
    wfactor = ROUND((TmsVart0.ImpPeri / wtotgen) * 100 ,2).
    ASSIGN
         TmsVart0.Factor = wfactor.    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-Clientes W-Win 
PROCEDURE Cierre-Clientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  Cierre Clientes
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-tpocm1 AS DECIMAL NO-UNDO.
DEFINE VAR x-tpocm2 AS DECIMAL NO-UNDO.
DEFINE VAR wtotgen  AS DECIMAL NO-UNDO.
DEFINE VAR wimpper  AS DECIMAL NO-UNDO.
DEFINE VAR wimpsol  AS DECIMAL NO-UNDO.
DEFINE VAR wimpdol  AS DECIMAL NO-UNDO.
DEFINE VAR wimpcts  AS DECIMAL NO-UNDO. 
DEFINE VAR wimpcrs  AS DECIMAL NO-UNDO. 
DEFINE VAR wimpctd  AS DECIMAL NO-UNDO. 
DEFINE VAR wimpcrd  AS DECIMAL NO-UNDO.
DEFINE VAR wnomcli  AS CHAR.

FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia.
x-tpocm1 = 1. 
x-tpocm2 = 1. 
ASSIGN
    fill-in-1 = "CIERRE MES X CLIENTES : " + s-coddiv.
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 

FOR EACH CcbCdocu NO-LOCK WHERE 
         CcbCdocu.CodCia = s-codcia AND 
         CcbCdocu.CodDiv = s-coddiv AND
         YEAR(CcbCdocu.FchDoc)  = w-periodo AND 
         MONTH(CcbCdocu.FchDoc) = w-mes AND
         (CcbCdocu.CodDoc = "FAC" OR CcbCdocu.CodDoc = "BOL") AND
         CcbCdocu.FlgEst <> "A" USE-INDEX LLAVE10
         BREAK BY CcbCdocu.CodCia BY CcbCdocu.CodCli: 
 
/*  Captura Tipo Cambio */
FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= CcbCdocu.Fchdoc NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN 
        ASSIGN
           x-tpocm2 = gn-tcmb.compra
           x-tpocm1 = gn-tcmb.venta.
    
/*  impales por Cliente  */
    IF FIRST-OF(CcbCdocu.CodCli) THEN DO:
       wimpsol = 0.
       wimpdol = 0.
       wimpcts = 0.   
       wimpcrs = 0.
       wimpctd = 0.   
       wimpcrd = 0.
    END.  
    IF CcbCdocu.CodMon = 1 THEN wimpsol = wimpsol + CcbCdocu.ImpTot.
    IF CcbCdocu.CodMon = 2 THEN wimpdol = wimpdol + CcbCdocu.ImpTot.
    
    IF CcbCdocu.TipVta = "1" AND CcbCdocu.CodMon = 1 THEN
       wimpcts = wimpcts + (CcbCdocu.ImpTot / x-tpocm1).
    IF CcbCdocu.TipVta = "1" AND CcbCdocu.CodMon = 2 THEN
       wimpctd = wimpctd + CcbCdocu.ImpTot.
    IF CcbCdocu.TipVta = "2" AND CcbCdocu.CodMon = 1 THEN 
       wimpcrs = wimpcrs + (CcbCdocu.ImpTot / x-tpocm1).   
    IF CcbCdocu.TipVta = "2" AND CcbCdocu.CodMon = 2 THEN
       wimpcrd = wimpcrd + CcbCdocu.ImpTot.
        
    ASSIGN
          fill-in-1 = CcbCdocu.NroDoc + "-" + CcbCdocu.CodCli + "-" + CcbCdocu.NomCli.
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
    
    IF LAST-OF(CcbCdocu.CodCli) THEN DO:
       IF CcbCdocu.CodCli = FacCfgGn.CliVar THEN WNOMCLI = "CLIENTES MOSTRADOR".  
       ELSE WNOMCLI = CcbCdocu.NomCli. 
       FIND TmsVvar0 WHERE TmsVvar0.CodCia = s-codcia AND
            TmsVvar0.TipTabla = "CLI"   AND 
            TmsVvar0.CodDiv = s-coddiv  AND 
            TmsVvar0.Period = w-periodo AND 
            TmsVvar0.CodVar = CcbCdocu.CodCli EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE TmsVvar0 THEN DO:
               ASSIGN 
                      TmsVvar0.Nombre        = wnomcli
                      TmsVvar0.TotCon[w-mes] = wimpcts + wimpctd
                      TmsVvar0.TotCre[w-mes] = wimpcrs + wimpcrd
                      TmsVvar0.TotMes[w-mes] = (wimpcts + wimpctd) + (wimpcrs + wimpcrd). .
            END.
            ELSE DO:
               CREATE TmsVvar0.
               ASSIGN TmsVvar0.CodCia        = s-codcia
                      TmsVvar0.TipTabla      = "CLI"
                      TmsVvar0.CodDiv        = s-coddiv
                      TmsVvar0.Periodo       = w-periodo
                      TmsVvar0.CodVar        = CcbCdocu.CodCli
                      TmsVvar0.Nombre        = wnomcli 
                      TmsVvar0.TotCon[w-mes] = wimpcts + wimpctd
                      TmsVvar0.TotCre[w-mes] = wimpcrs + wimpcrd
                      TmsVvar0.TotMes[w-mes] = (wimpcts + wimpctd) + (wimpcrs + wimpcrd).
                     
            END.         
            Release TmsVvar0.
    END.
END.

/* ACTUALIZA TOTALES POR CLIENTES */
        
   ASSIGN
      fill-in-1 = "   ACTUALIZA TOTALES POR CLIENTES  ". 
      DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 

wtotgen = 0.
FOR EACH TmsVvar0 WHERE TmsVvar0.CodCia = s-codcia AND
    TmsVvar0.TipTabla = "CLI" AND
    TmsVvar0.CodDiv = s-coddiv AND
    TmsVvar0.Period = w-periodo EXCLUSIVE-LOCK:
    wimpper = 0.
    DO I = 1 TO 12: 
       wimpper = wimpper + (TmsVvar0.TotMes[i]).
    END.
    ASSIGN
         TmsVvar0.TotPeri = wimpper.             
         wtotgen = wtotgen + wimpper. 
END.

ASSIGN
    fill-in-1 = "   ACTUALIZA FACTORES PARTICIPACION POR CLIENTES  ". 
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 

FOR EACH TmsVvar0 WHERE TmsVvar0.CodCia = S-CODCIA AND
    TmsVvar0.TipTabla = "CLI"  AND
    TmsVvar0.CodDiv = S-CODDIV AND
    TmsVvar0.Period = w-periodo:
    wfactor = ROUND((TmsVvar0.TotPer / wtotgen) * 100 ,2).
    ASSIGN
         TmsVvar0.Factor = wfactor.    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-Division W-Win 
PROCEDURE Cierre-Division :
/*------------------------------------------------------------------------------
  Purpose:     Cierre Mensual x Division
  Parameters:  Cia, Division, Periodo, Mes
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-tpocm1 AS DECIMAL NO-UNDO.
DEFINE VAR x-tpocm2 AS DECIMAL NO-UNDO.
DEFINE VAR wtotgen  AS DECIMAL NO-UNDO.
DEFINE VAR wtovtso  AS DECIMAL NO-UNDO.
DEFINE VAR wtovtdo  AS DECIMAL NO-UNDO.

DEFINE VAR wbimcts  AS DECIMAL NO-UNDO.
DEFINE VAR wbimctd  AS DECIMAL NO-UNDO.
DEFINE VAR wbimcrs  AS DECIMAL NO-UNDO.
DEFINE VAR wbimcrd  AS DECIMAL NO-UNDO.

DEFINE VAR w-vtcts  AS DECIMAL NO-UNDO.
DEFINE VAR w-vtcrs  AS DECIMAL NO-UNDO.
DEFINE VAR w-vtctd  AS DECIMAL NO-UNDO.
DEFINE VAR w-vtcrd  AS DECIMAL NO-UNDO.

DEFINE VAR w-vtsol  AS DECIMAL NO-UNDO.
DEFINE VAR w-vtdol  AS DECIMAL NO-UNDO.
DEF VAR wnrofac     AS INTEGER NO-UNDO.
DEF VAR wnrobol     AS INTEGER NO-UNDO.
 

wtotcts = 0.
wtotcrs = 0.

x-tpocm1 = 1.
x-tpocm2 = 1.

ASSIGN
    fill-in-1 = "CIERRE MES X DIVISION : " + s-coddiv.
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
 
FOR EACH ccbCdocu NO-LOCK WHERE 
         ccbCdocu.CodCia = S-CODCIA AND 
         ccbCdocu.CodDiv = S-CODDIV AND 
         YEAR(CcbCDocu.FchDoc)  = w-periodo AND 
         MONTH(CcbCDocu.FchDoc) = w-mes AND
         (CcbCDocu.CodDoc = "FAC" OR CcbCDocu.CodDoc = "BOL") AND
         CcbCDocu.FlgEst <> "A" USE-INDEX LLAVE10 
         BREAK BY CcbCDocu.FchDoc:
         
/*  Captura Tipo Cambio */
FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= CcbCDocu.Fchdoc NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN 
        ASSIGN
           x-tpocm2 = gn-tcmb.compra
           x-tpocm1 = gn-tcmb.venta.
         
/*  Totales por Division  */
    IF FIRST-OF(CcbCDocu.FchDoc) THEN DO:
       wnrofac = 0.
       wnrobol = 0.
       wtotcts = 0.
       wtotctd = 0.
       wtotcrs = 0.
       wtotcrd = 0.
       wbimcts = 0.
       wbimctd = 0.
       wbimcrs = 0.
       wbimcrd = 0.
    END.  
    IF CcbCDocu.CodDoc = "FAC" THEN wnrofac = wnrofac + 1.
    IF CcbCDocu.CodDoc = "BOL" THEN wnrobol = wnrobol + 1.
    
    IF ccbCdocu.TipVta = "1" AND ccbCdocu.CodMon = 1 THEN DO:
       wtotcts = wtotcts + ccbCdocu.ImpTot.
       wbimctd = wbimctd + (ccbCdocu.ImpTot / x-tpocm1).
    END.   
    IF ccbCdocu.TipVta = "1" AND ccbCdocu.CodMon = 2 THEN DO:
       wtotctd = wtotctd + ccbCdocu.ImpTot.
       wbimcts = wbimcts + (CcbCdocu.ImpTot * x-tpocm1).
    END.   
    IF ccbCdocu.TipVta = "2" AND ccbCdocu.CodMon = 1 THEN DO:
       wtotcrs = wtotcrs + ccbCdocu.ImpTot.
       wbimcrd = wbimcrd + (CcbCdocu.ImpTot / x-tpocm1).   
    END.
    IF ccbCdocu.TipVta = "2" AND ccbCdocu.CodMon = 2 THEN DO:
       wtotcrd = wtotcrd + ccbCdocu.ImpTot.
       wbimcrs = wbimcrs + (CcbCdocu.ImpTot * x-tpocm1).   
    END.    
    
    ASSIGN
          fill-in-1 = CcbCDocu.CodDoc + "-" + CcbCDocu.NroDoc + "  " + STRING(CcbCDocu.FchDoc) + " " + CcbCDocu.NomCli.
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
     
    IF LAST-OF(CcbCDocu.FchDoc) THEN DO:
       FIND tvtvdiv0 WHERE 
            tvtvdiv0.DivCia = s-codcia 
            AND tvtvdiv0.Divcod = s-coddiv 
            AND tvtvdiv0.DivFecha = CcbCDocu.FchDoc EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE tvtvdiv0 THEN DO:
               ASSIGN  
                     Tvtvdiv0.DivHora   = STRING(TIME,"HH:MM")
                     Tvtvdiv0.DivUser   = S-USER-ID
                     Tvtvdiv0.divvtcts  = wtotcts
                     Tvtvdiv0.divvtctd  = wtotctd
                     Tvtvdiv0.divvtcrs  = wtotcrs
                     Tvtvdiv0.divvtcrd  = wtotcrd
                     Tvtvdiv0.DivTodol  = wtotctd + wtotcrd
                     Tvtvdiv0.DivTosol  = wtotcts + wtotcrs
                     TvtvDiv0.DivVtdol  = (wbimctd + wbimcrd) + (wtotctd + wtotcrd)
                     TvtvDiv0.DivVtsol  = (wbimcts + wbimcrs) + (wtotcts + wtotcrs)
                     Tvtvdiv0.DivNrbol  = wnrobol
                     Tvtvdiv0.DivNrfac  = wnrofac.
            END.
            ELSE DO:
               CREATE tvtvdiv0.
               ASSIGN Tvtvdiv0.DivCia    = S-CODCIA
                      Tvtvdiv0.DivCod    = S-CODDIV
                      Tvtvdiv0.DivFecha  = CcbCDocu.FchDoc
                      Tvtvdiv0.DivHora   = STRING(TIME,"HH:MM")
                      Tvtvdiv0.DivUser   = S-USER-ID 
                      Tvtvdiv0.Divvtcts  = wtotcts
                      Tvtvdiv0.Divvtctd  = wtotctd
                      Tvtvdiv0.Divvtcrs  = wtotcrs
                      Tvtvdiv0.Divvtcrd  = wtotcrd
                      Tvtvdiv0.DivTodol  = wtotctd + wtotcrd
                      Tvtvdiv0.DivTosol  = wtotcts + wtotcrs
                      TvtvDiv0.DivVtdol  = (wbimctd + wbimcrd) + (wtotctd + wtotcrd)
                      TvtvDiv0.DivVtsol  = (wbimcts + wbimcrs) + (wtotcts + wtotcrs)
                      Tvtvdiv0.DivNrbol  = wnrobol
                      Tvtvdiv0.DivNrfac  = wnrofac.
            END.
            Release Tvtvdiv0.         
    END.
END.    
   
/* ACTUALIZA TOTALES POR DIVISION  */
wtotgen = 0.   
wtovtso = 0.
wtovtdo = 0.
w-vtcts = 0.
w-vtctd = 0.
w-vtcrs = 0.
w-vtcrd = 0.

/* Variables Acumulado Mensual */

FOR EACH tvtvdiv0 WHERE tvtvdiv0.DivCia = S-CODCIA AND
    tvtvdiv0.Divcod   = S-CODDIV AND
    YEAR (tvtvdiv0.DivFecha) = w-periodo AND
    MONTH (tvtvdiv0.DivFecha)= w-mes EXCLUSIVE: 
    w-vtcts = w-vtcts + Tvtvdiv0.Divvtcts.  
    w-vtctd = w-vtctd + Tvtvdiv0.Divvtctd. 
    w-vtcrs = w-vtcrs + Tvtvdiv0.Divvtcrs.  
    w-vtcrd = w-vtcrd + Tvtvdiv0.Divvtcrd. 
    w-vtsol = w-vtsol + Tvtvdiv0.DivVtsol.
    w-vtdol = w-vtdol + Tvtvdiv0.DivVtdol.                               
    wtotgen = wtotgen + Tvtvdiv0.DivVtdol.
END.

FOR EACH tvtvdiv0 WHERE tvtvdiv0.DivCia = S-CODCIA AND
    tvtvdiv0.Divcod = S-CODDIV AND 
    YEAR (tvtvdiv0.DivFecha) = w-periodo AND
    MONTH (tvtvdiv0.DivFecha)= w-mes EXCLUSIVE: 
    wfactor = ROUND((tvtvdiv0.DivVtdol / wtotgen) * 100 ,2).
    ASSIGN
          Tvtvdiv0.DivFacpa = wfactor.    
END. 

/* Actualiza Archivo Mensual */
FIND TmsvDiv0 WHERE 
     TmsvDiv0.DivCia = S-CODCIA  AND 
     TmsvDiv0.Divcod = S-CODDIV  AND 
     TmsvDiv0.DivPerio = w-periodo AND 
     TmsvDiv0.DivMes = w-mes EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE TmsvDiv0 THEN DO:
   ASSIGN  
         Tmsvdiv0.DivUser  = S-USER-ID
         Tmsvdiv0.Divvtcts = w-vtcts
         Tmsvdiv0.Divvtctd = w-vtctd
         Tmsvdiv0.Divvtcrs = w-vtcrs
         Tmsvdiv0.Divvtcrd = w-vtcrd
         Tmsvdiv0.DivVtdol = w-vtdol
         Tmsvdiv0.DivVtsol = w-vtsol.
END.
ELSE DO:
   CREATE Tmsvdiv0.
   ASSIGN Tmsvdiv0.DivCia    = S-CODCIA
          Tmsvdiv0.DivCod    = S-CODDIV
          Tmsvdiv0.DivPerio  = w-periodo
          Tmsvdiv0.DivMes    = w-mes
          Tmsvdiv0.DivUser   = S-USER-ID 
          Tmsvdiv0.Divvtcts  = w-vtcts
          Tmsvdiv0.Divvtctd  = w-vtctd
          Tmsvdiv0.Divvtcrs  = w-vtcrs
          Tmsvdiv0.Divvtcrd  = w-vtcrd
          Tmsvdiv0.DivTodol  = w-vtctd + w-vtcrd
          Tmsvdiv0.DivTosol  = w-vtcts + w-vtcrs
          Tmsvdiv0.DivVtdol  = w-vtdol
          Tmsvdiv0.DivVtsol  = w-vtsol.
END.
Release TmsvDiv0.         
             
wtotgen = 0.
FOR EACH Tmsvdiv0 WHERE 
    Tmsvdiv0.DivCia = S-CODCIA AND  
    Tmsvdiv0.Divcod = S-CODDIV EXCLUSIVE: 
    wtotgen = wtotgen + Tmsvdiv0.DivVtdol.
    RELEASE Tmsvdiv0.    
END.
    
FOR EACH Tmsvdiv0 WHERE Tmsvdiv0.DivCia = S-CODCIA 
    AND  Tmsvdiv0.Divcod = S-CODDIV EXCLUSIVE:
    wfactor = ROUND((Tmsvdiv0.DivVtdol / wtotgen) * 100 ,2).
     
    ASSIGN
          Tmsvdiv0.DivFacpa = wfactor.    
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cierre-Vendedores W-Win 
PROCEDURE Cierre-Vendedores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-tpocm1 AS DECIMAL NO-UNDO.
DEFINE VAR x-tpocm2 AS DECIMAL NO-UNDO.
DEFINE VAR wtotgen  AS DECIMAL NO-UNDO.
DEFINE VAR wimpper  AS DECIMAL NO-UNDO.
DEFINE VAR wimpsol  AS DECIMAL NO-UNDO.
DEFINE VAR wimpdol  AS DECIMAL NO-UNDO.
DEFINE VAR wimpcts  AS DECIMAL NO-UNDO. 
DEFINE VAR wimpcrs  AS DECIMAL NO-UNDO. 
DEFINE VAR wimpctd  AS DECIMAL NO-UNDO. 
DEFINE VAR wimpcrd  AS DECIMAL NO-UNDO.

x-tpocm1 = 1. 
x-tpocm2 = 1. 
ASSIGN
   fill-in-1 = "CIERRE MES X VENDEDORES : " + s-coddiv.
   DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 

FOR EACH CcbCdocu NO-LOCK WHERE 
         CcbCdocu.CodCia = s-codcia AND 
         CcbCdocu.CodDiv = s-coddiv AND
         YEAR(CcbCdocu.FchDoc)  = w-periodo AND 
         MONTH(CcbCdocu.FchDoc) = w-mes AND
         (CcbCdocu.CodDoc = "FAC" OR CcbCdocu.CodDoc = "BOL") AND
         CcbCdocu.FlgEst <> "A" USE-INDEX LLAVE10 ,FIRST Gn-ven OF CcbCdocu 
         BREAK BY CcbCdocu.CodCia BY CcbCdocu.CodVen: 
 
/*  Captura Tipo Cambio */
FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= CcbCdocu.Fchdoc NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN 
        ASSIGN
           x-tpocm2 = gn-tcmb.compra
           x-tpocm1 = gn-tcmb.venta.
    
/*  Totales por Vendedor  */
    IF FIRST-OF(CcbCdocu.CodVen) THEN DO:
       wimpsol = 0.
       wimpdol = 0.
       wimpcts = 0.   
       wimpcrs = 0.
       wimpctd = 0.   
       wimpcrd = 0.
    END.  
    IF CcbCdocu.CodMon = 1 THEN wimpsol = wimpsol + CcbCdocu.ImpTot.
    IF CcbCdocu.CodMon = 2 THEN wimpdol = wimpdol + CcbCdocu.ImpTot.
    
    IF CcbCdocu.TipVta = "1" AND CcbCdocu.CodMon = 1 THEN
       wimpcts = wimpcts + (CcbCdocu.ImpTot / x-tpocm1).
    IF CcbCdocu.TipVta = "1" AND CcbCdocu.CodMon = 2 THEN
       wimpctd = wimpctd + CcbCdocu.ImpTot.
    IF CcbCdocu.TipVta = "2" AND CcbCdocu.CodMon = 1 THEN 
       wimpcrs = wimpcrs + (CcbCdocu.ImpTot / x-tpocm1).   
    IF CcbCdocu.TipVta = "2" AND CcbCdocu.CodMon = 2 THEN
       wimpcrd = wimpcrd + CcbCdocu.ImpTot.
        
    ASSIGN
          fill-in-1 = CcbCdocu.NroDoc + "-" + CcbCdocu.CodVen + "-" + Gn-Ven.NomVen.
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
    
    IF LAST-OF(CcbCdocu.CodVen) THEN DO:
       FIND TmsVvar0 WHERE TmsVvar0.CodCia = s-codcia AND
            TmsVvar0.TipTabla = "VEN"   AND
            TmsVvar0.CodDiv = s-coddiv  AND 
            TmsVvar0.Period = w-periodo AND 
            TmsVvar0.CodVar = CcbCdocu.CodVen EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE TmsVvar0 THEN DO:
               ASSIGN 
                      TmsVvar0.Nombre        = Gn-Ven.NomVen   
                      TmsVvar0.TotCon[w-mes] = wimpcts + wimpctd
                      TmsVvar0.TotCre[w-mes] = wimpcrs + wimpcrd
                      TmsVvar0.TotMes[w-mes] = (wimpcts + wimpctd) + (wimpcrs + wimpcrd). .
            END.
            ELSE DO:
               CREATE TmsVvar0.
               ASSIGN TmsVvar0.CodCia        = s-codcia
                      TmsVvar0.TipTabla      = "VEN"
                      TmsVvar0.CodDiv        = s-coddiv
                      TmsVvar0.Periodo       = w-periodo
                      TmsVvar0.CodVar        = CcbCdocu.CodVen 
                      TmsVvar0.Nombre        = Gn-Ven.NomVen
                      TmsVvar0.TotCon[w-mes] = wimpcts + wimpctd
                      TmsVvar0.TotCre[w-mes] = wimpcrs + wimpcrd
                      TmsVvar0.TotMes[w-mes] = (wimpcts + wimpctd) + (wimpcrs + wimpcrd).
                     
            END.         
            Release TmsVvar0.
    END.
END.

/* ACTUALIZA TOTALES POR Vendedores */
        
   ASSIGN
      fill-in-1 = "   ACTUALIZA TOTALES POR VENDEDORES  ". 
      DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 

wtotgen = 0.
FOR EACH TmsVvar0 WHERE TmsVvar0.CodCia = s-codcia AND
    TmsVvar0.TipTabla = "VEN"  AND
    TmsVvar0.CodDiv = s-coddiv AND
    TmsVvar0.Period = w-periodo EXCLUSIVE-LOCK:
    wimpper = 0.
    DO I = 1 TO 12: 
       wimpper = wimpper + (TmsVvar0.TotMes[i]).
    END.
    ASSIGN
         TmsVvar0.TotPeri = wimpper.             
         wtotgen = wtotgen + wimpper. 
END.

ASSIGN
    fill-in-1 = "   ACTUALIZA FACTORES PARTICIPACION POR VENDEDORES   ". 
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 

FOR EACH TmsVvar0 WHERE TmsVvar0.CodCia = S-CODCIA AND
    TmsVvar0.TipTabla = "VEN"  AND
    TmsVvar0.CodDiv = S-CODDIV AND
    TmsVvar0.Period = w-periodo:
    wfactor = ROUND((TmsVvar0.TotPer / wtotgen) * 100 ,2).
    ASSIGN
         TmsVvar0.Factor = wfactor.    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win _DEFAULT-ENABLE
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
  DISPLAY W-PERIODO W-MES COMBO-BOX-1 FILL-IN-1 EDITOR-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 W-PERIODO W-MES BUTTON-12 BUTTON-13 BUTTON-14 
         COMBO-BOX-1 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  editor-2 = "   Este proceso cierra todas las operaciones del Mes, 
  despues de haber efectuado esta operacion ya no podra Crear,Modificar y/o
  anular ningun documento. Antes de Aceptar Asegurese que todas las operaciones del
  mes esten procesados.".
  DISPLAY EDITOR-2 WITH FRAME {&FRAME-NAME}.
  ASSIGN
        w-periodo = YEAR(TODAY)
        w-mes     = MONTH(TODAY).
  DISPLAY w-periodo w-mes WITH FRAME {&FRAME-NAME}.                  
  /* Code placed here will execute AFTER standard behavior.    */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Relacion-Cliente-Articulo W-Win 
PROCEDURE Relacion-Cliente-Articulo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR x-tpocm1 AS DECIMAL NO-UNDO.
DEFINE VAR x-tpocm2 AS DECIMAL NO-UNDO.
DEFINE VAR wcansol  AS DECIMAL NO-UNDO.
DEFINE VAR wcandol  AS DECIMAL NO-UNDO.
DEFINE VAR wtovtso  AS DECIMAL NO-UNDO.
DEFINE VAR wtovtdo  AS DECIMAL NO-UNDO.
DEFINE VAR wtotgen  AS DECIMAL NO-UNDO.
DEFINE VAR wcanper  AS DECIMAL NO-UNDO.
DEFINE VAR wimpper  AS DECIMAL NO-UNDO.
DEFINE VAR wcancts  AS DECIMAL NO-UNDO. 
DEFINE VAR wcancrs  AS DECIMAL NO-UNDO. 
DEFINE VAR wcanctd  AS DECIMAL NO-UNDO. 
DEFINE VAR wcancrd  AS DECIMAL NO-UNDO.
DEFINE VAR wimpcts  AS DECIMAL NO-UNDO. 
DEFINE VAR wimpcrs  AS DECIMAL NO-UNDO. 
DEFINE VAR wimpctd  AS DECIMAL NO-UNDO. 
DEFINE VAR wimpcrd  AS DECIMAL NO-UNDO.
         
x-tpocm1 = 1.
x-tpocm2 = 1.
         
FOR EACH CcbCdocu NO-LOCK WHERE
         CcbCDocu.CodCia = s-codcia AND
         CcbCDocu.CodDiv = s-coddiv AND 
         YEAR(CcbCDocu.FchDoc)  = w-periodo AND 
         MONTH(CcbCDocu.FchDoc) = w-mes AND
         CcbCDocu.FlgEst <> "A" AND 
         (CcbCDocu.CodDoc = "FAC" OR CcbCDocu.CodDoc = "BOL") , EACH CcbDdocu OF ccbCdocu , FIRST Almmmatg OF CcbDdocu NO-LOCK
         BREAK BY CcbCdocu.CodCli BY ccbDdocu.CodMat:

/*  Captura Tipo Cambio */
FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= CcbCDocu.Fchdoc NO-LOCK NO-ERROR.
     IF AVAILABLE gn-tcmb THEN 
        ASSIGN
           x-tpocm2 = gn-tcmb.compra
           x-tpocm1 = gn-tcmb.venta.
    
/*  Totales por Articulo */
    IF FIRST-OF(CcbCdocu.CodCli) AND FIRST-OF (CcbDdocu.CodMat) THEN DO:
       wcansol = 0.
       wcandol = 0.
       wcancts = 0.
       wcanctd = 0.
       wcancrs = 0.
       wcancrd = 0.
       wimpcts = 0.
       wimpctd = 0.
       wimpcrs = 0.
       wimpcrd = 0.
    END.  
        
    IF ccbCdocu.CodMon = 1 THEN wcansol = wcansol + ccbDdocu.ImpLin.
    IF ccbCdocu.CodMon = 2 THEN wcandol = wcandol + ccbDdocu.ImpLin.
    
    IF ccbCdocu.TipVta = "1" AND ccbCdocu.CodMon = 1 THEN DO:
       wcancts = wcancts + (CcbDDocu.CanDes * CcbDDocu.Factor).
       wimpcts = wimpcts + (ccbDdocu.ImpLin / x-tpocm1).
    END.   
    IF ccbCdocu.TipVta = "1" AND ccbCdocu.CodMon = 2 THEN DO:
       wcanctd = wcanctd + (CcbDDocu.CanDes * CcbDDocu.Factor).
       wimpctd = wimpctd + ccbDdocu.ImpLin.
    END.   
    IF ccbCdocu.TipVta = "2" AND ccbCdocu.CodMon = 1 THEN DO:
       wcancrs = wcancrs + (CcbDDocu.CanDes * CcbDDocu.Factor).
       wimpcrs = wimpcrs + (ccbDdocu.ImpLin / x-tpocm1).
    END.   
    IF ccbCdocu.TipVta = "2" AND ccbCdocu.CodMon = 2 THEN DO:
       wcancrd = wcancrd + (CcbDDocu.CanDes * CcbDDocu.Factor).
       wimpcrd = wimpcrd + ccbDdocu.ImpLin.
    END.   
        
    ASSIGN
          fill-in-1 = CcbCdocu.CodCli + "-" + CcbDdocu.CodMat + "-" + Almmmatg.DesMat. 
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
    
    IF LAST-OF (CcbCdocu.CodCli) or LAST-OF (CcbDdocu.CodMat) THEN DO:
       FIND TmsVrel0 WHERE TmsVrel0.CodCia = s-codcia AND
            TmsVrel0.TipTabla = "CLI"   AND
            TmsVrel0.CodDiv = s-coddiv  AND
            TmsVrel0.Period = w-periodo AND
            TmsVrel0.CodVar = CcbCdocu.CodCli AND
            TmsVrel0.CodArt = CcbDdocu.codMat EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE TmsVrel0 THEN DO:
               ASSIGN 
                      TmsVrel0.DesArt        = Almmmatg.DesMat
                      TmsVrel0.DesMar        = Almmmatg.DesMar
                      TmsVrel0.CodFam        = Almmmatg.CodFam 
                      TmsVrel0.CodSub        = Almmmatg.subfam 
                      TmsVrel0.CodPro        = Almmmatg.CodPr1
                      TmsVrel0.CanCon[w-mes] = wcancts + wcanctd
                      TmsVrel0.CanCre[w-mes] = wcancrs + wcancrd
                      TmsVrel0.CanMes[w-mes] = (wcancts + wcanctd) + (wcancrs + wcancrd) 
                      TmsVrel0.ImpCon[w-mes] = wimpcts + wimpctd
                      TmsVrel0.ImpCre[w-mes] = wimpcrs + wimpcrd
                      TmsVrel0.ImpMes[w-mes] = (wimpcts + wimpctd) + (wimpcrs + wimpcrd).
            END. 
            ELSE DO:
               CREATE TmsVrel0.
               ASSIGN TmsVrel0.CodCia        = s-codcia
                      TmsVrel0.TipTabla      = "CLI"        
                      TmsVrel0.CodDiv        = s-coddiv
                      TmsVrel0.Period        = w-periodo
                      TmsVrel0.CodVar        = CcbCdocu.CodCli
                      TmsVrel0.CodArt        = CcbDdocu.CodMat
                      TmsVrel0.Nombre        = CcbCdocu.NomCli
                      TmsVrel0.DesArt        = Almmmatg.DesMat
                      TmsVrel0.DesMar        = Almmmatg.DesMar
                      TmsVrel0.CodFam        = Almmmatg.CodFam 
                      TmsVrel0.CodSub        = Almmmatg.subfam 
                      TmsVrel0.CodPro        = Almmmatg.CodPr1
                      TmsVrel0.CanCon[w-mes] = wcancts + wcanctd
                      TmsVrel0.CanCre[w-mes] = wcancrs + wcancrd
                      TmsVrel0.CanMes[w-mes] = (wcancts + wcanctd) + (wcancrs + wcancrd) 
                      TmsVrel0.ImpCon[w-mes] = wimpcts + wimpctd
                      TmsVrel0.ImpCre[w-mes] = wimpcrs + wimpcrd
                      TmsVrel0.ImpMes[w-mes] = (wimpcts + wimpctd) + (wimpcrs + wimpcrd).
            END.         
            Release TmsVrel0.
    END.
END.

/* ACTUALIZA CANTIDADES POR ARTICULOS */
        
   ASSIGN
      fill-in-1 = "   ACTUALIZA TOTALES POR ARTICULOS   ". 
      DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 

wtotgen = 0.
FOR EACH TmsVrel0 WHERE TmsVrel0.CodCia = s-codcia AND
    TmsVrel0.TipTabla = "CLI" AND
    TmsVrel0.CodDiv   = s-coddiv AND
    TmsVrel0.Period   = w-periodo EXCLUSIVE-LOCK:
    wcanper = 0.
    wimpper = 0.
    DO I = 1 TO 12: 
       wcanper = wcanper + (TmsVrel0.CanMes[i]). 
       wimpper = wimpper + (TmsVrel0.ImpMes[i]).
    END.
    ASSIGN
         TmsVrel0.CanPeri = wcanper
         TmsVrel0.ImpPeri = wimpper.             
         wtotgen = wtotgen + wimpper. 
END.

/*
FOR EACH TmsVrel0 WHERE TmsVrel0.CodCia = s-codcia AND
    TmsVrel0.TipTabla = "CLI"   AND
    TmsVrel0.CodDiv   = s-coddiv AND
    TmsVrel0.Period   = w-periodo EXCLUSIVE-LOCK:
    wfactor = ROUND((TmsVrel0.ArtVtdol / wcangen) * 100 ,2).
    ASSIGN
         TmsVrel0.FACtor = wfactor.    
END.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win _ADM-SEND-RECORDS
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


