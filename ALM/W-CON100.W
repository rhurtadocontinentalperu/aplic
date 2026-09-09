&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
DEFINE     SHARED VARIABLE S-CODCIA  AS INTEGER.
DEFINE     SHARED VARIABLE S-CODALM  AS CHAR.
DEFINE     SHARED VARIABLE S-CODDIV  AS CHAR.
DEFINE     SHARED VARIABLE S-USER-ID AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE  VAR w-perio AS INT NO-UNDO.
DEFINE  VAR w-mes   AS INT NO-UNDO.
DEFINE  VAR w-dia   AS INT NO-UNDO.
DEFINE  VAR wtipcam AS DEC NO-UNDO.
DEFINE  VAR I       AS INT.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.
wtipcam = FacCfgGn.Tpocmb[1] .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 BUTTON-12 COMBO-BOX-1 W-FECHA ~
BUTTON-13 BUTTON-14 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-2 FILL-IN-1 COMBO-BOX-1 W-FECHA 

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

DEFINE BUTTON BUTTON-13 AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "&Cancelar" 
     SIZE 12.43 BY 1.54.

DEFINE BUTTON BUTTON-14 
     IMAGE-UP FILE "img\b-ayuda":U
     LABEL "help" 
     SIZE 12.43 BY 1.54.

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(256)":U INITIAL "A¤o" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "A¤o","Mes" 
     SIZE 80 BY 1 NO-UNDO.

DEFINE VARIABLE EDITOR-2 AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 46.72 BY 4.23
     BGCOLOR 11 FGCOLOR 0 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.86 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE W-FECHA AS DATE FORMAT "99/99/9999":U 
     LABEL "Fecha Consolidado" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48.43 BY 9.08.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.86 BY 1.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     EDITOR-2 AT ROW 1.23 COL 2.14 NO-LABEL
     FILL-IN-1 AT ROW 7.12 COL 2 NO-LABEL
     BUTTON-12 AT ROW 8.31 COL 3.57
     COMBO-BOX-1 AT ROW 16.92 COL 1 NO-LABEL
     W-FECHA AT ROW 5.77 COL 15.86 COLON-ALIGNED
     BUTTON-13 AT ROW 8.31 COL 18.43
     BUTTON-14 AT ROW 8.31 COL 33.72
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 5.5 COL 2
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
         TITLE              = "Consolidado Stocks"
         HEIGHT             = 9.12
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

IF NOT W-Win:LOAD-ICON("img\tbldef":U) THEN
    MESSAGE "Unable to load icon: img\tbldef"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
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
ON END-ERROR OF W-Win /* Consolidado Stocks */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Consolidado Stocks */
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
        w-fecha.
        w-perio  = YEAR(w-fecha).
        w-mes    = MONTH(w-fecha).
        w-dia    = DAY(w-fecha).
        
  MESSAGE " Esta seguro de Consolidar " VIEW-AS ALERT-BOX QUESTION 
  BUTTONS yes-no
  UPDATE wresp AS LOGICAL.
  CASE wresp:
       WHEN yes THEN DO:
            IF w-fecha = ? then DO:
               MESSAGE " DIGITE LA FECHA A CONSOLIDAR " VIEW-AS ALERT-BOX ERROR.
               APPLY "ENTRY" TO w-fecha.
               return NO-APPLY.  
            END.   
            if session:set-wait-state("GENERAL") then.
            RUN Captura_Almacen.
            RUN Consolidados.
            RUN Consolida-marca.    
            if session:set-wait-state(" ") then.
            MESSAGE " Consolidado Terminado " VIEW-AS ALERT-BOX INFORMATION. 
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
ASSIGN W-WIN:TITLE = "Consolida Stock Almacen : " + S-CODALM.
IF NOT CONNECTED("thgerenc") THEN DO:
   MESSAGE "LLEGO".
   CONNECT -pf thgerenc.pf.
END.   
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BACKUP W-Win 
PROCEDURE BACKUP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR wprecos AS DECIMAL NO-UNDO.
DEFINE VAR wtotsto AS DECIMAL NO-UNDO.
DEFINE VAR J       AS INTEGER NO-UNDO.

J = 0.

FOR EACH Almmmate WHERE Almmmate.CodCia = s-codcia AND Almmmate.CodAlm = s-codalm,
    EACH Almmmatg OF Almmmate NO-LOCK:
    ASSIGN
          fill-in-1 = Almmmate.CodMat + "-" + Almmmatg.Desmat. 
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
    IF integral.Almmmatg.MonVta = 1 THEN wprecos = (integral.Almmmatg.CtoLis / wtipcam).
    ELSE wprecos = integral.Almmmatg.CtoLis.
    FIND THGERENC.TlgCinv0 WHERE THGERENC.TlgCinv0.Codcia = S-CODCIA 
         AND thgerenc.TLGCINV0.Codigo = Almmmate.CodMat NO-ERROR.
            IF AVAILABLE THGERENC.TlgCinv0 THEN DO:
               ASSIGN 
                   thgerenc.TLGCINV0.TipArt   = integral.Almmmatg.TipArt
                   thgerenc.TLGCINV0.PreCos   = wprecos
                   thgerenc.TLGCINV0.Unidad   = integral.Almmmatg.UndStk
                   thgerenc.TLGCINV0.Stock[I] = integral.Almmmate.StkAct.
            END.
            ELSE DO:
               CREATE THGERENC.TlgCinv0.
               ASSIGN  
                   THGERENC.TLGCINV0.CodCia   = integral.Almmmatg.CodCia 
                   THGERENC.TLGCINV0.Codigo   = integral.Almmmate.CodMat 
                   THGERENC.TLGCINV0.CodMar   = integral.Almmmatg.CodMar 
                   THGERENC.TLGCINV0.CodPro   = integral.Almmmatg.CodPr1
                   THGERENC.TLGCINV0.CodFam   = integral.Almmmatg.CodFam
                   THGERENC.TLGCINV0.CodSub   = integral.Almmmatg.subfam
                   THGERENC.TLGCINV0.TipArt   = integral.Almmmatg.TipArt
                   THGERENC.TLGCINV0.PreCos   = wprecos
                   THGERENC.TLGCINV0.Unidad   = integral.Almmmatg.UndStk
                   THGERENC.TLGCINV0.Marca    = integral.Almmmatg.DesMar 
                   THGERENC.TLGCINV0.Unidad   = integral.Almmmatg.UndStk
                   THGERENC.TLGCINV0.NomArt   = integral.Almmmatg.DesMat
                   THGERENC.TLGCINV0.Stock[I] = integral.Almmmate.StkAct.   
            END.                 
    END.

/*   ACTUALIZA TOTALES POR ARTICULOS  */
wtotsto = 0.
FOR EACH THGERENC.TlgCinv0 WHERE THGERENC.TlgCinv0.CodCia = s-codcia EXCLUSIVE:
    ASSIGN
       fill-in-1 = THGERENC.TlgCinv0.Codigo + "-" + thgerenc.TlgCinv0.NomArt. 
       DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
    wtotsto = 0.
    DO J = 1 TO 15: 
       wtotsto = wtotsto + THGERENC.TLGCINV0.Stock[J].
    END.
    ASSIGN
       thgerenc.TLGCINV0.StkTot = wtotsto
       thgerenc.TLGCINV0.TotVal = ROUND(thgerenc.TLGCINV0.StkTot * thgerenc.TLGCINV0.PreCos,2). 
END.

/*
FOR EACH thgerenc.TLGCINV0 WHERE thgerenc.TLGCINV0.CodCia = S-CODCIA 
     AND thgerenc.TLGCINV0.CodCia = S-CODDIV:
     
    wfactor = ROUND((TvtVart0.ArtVtdol / wtotgen) * 100 ,2).
    ASSIGN
         TvtVart0.ArtFACPA = wfactor.    
END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Captura_Almacen W-Win 
PROCEDURE Captura_Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

CASE s-codalm:
     WHEN "T01" THEN i = 1.
     WHEN "T02" THEN i = 2.
     WHEN "T03" THEN i = 3.
     WHEN "T04" THEN i = 4.
     WHEN "T05" THEN i = 5.
     WHEN "T06" THEN i = 6.
     WHEN "T07" THEN i = 7.
     WHEN "T08" THEN i = 8.
     WHEN "T09" THEN i = 9.
     WHEN "T10" THEN i = 10.
     WHEN "A01" THEN i = 11.
     WHEN "A02" THEN i = 12.
END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consolida-marca W-Win 
PROCEDURE consolida-marca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR T-ACUM-MAR AS DECIMAL INITIAL 0.

FOR EACH THGERENC.TlgCinv0 WHERE THGERENC.TlgCinv0.CodCia = s-codcia 
                           BREAK BY THGERENC.TlgCinv0.Marca:

    T-ACUM-MAR = T-ACUM-MAR + TLGCINV0.TotVal.

    ASSIGN
          fill-in-1 = "Marca :  " + THGERENC.TlgCinv0.Marca . 
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 

    IF LAST-OF(TlgCinv0.Marca) THEN DO :
       FIND FIRST THGERENC.TGECINV0 WHERE THGERENC.TGECINV0.CODCIA   = S-CODCIA  AND
                                          THGERENC.TGECINV0.TIPTABLA = "MAR"     AND
                                          THGERENC.TGECINV0.CODFAM   = TlgCinv0.marca NO-ERROR.
                                          
            IF AVAILABLE THGERENC.TGECINV0 THEN DO:
               ASSIGN
                 THGERENC.TGECINV0.VALDOL   = T-ACUM-MAR
                 THGERENC.TGECINV0.FCHACT   = TODAY
                 THGERENC.TGECINV0.HORAACT  = STRING(TIME,"HH:MM").
            END.
            ELSE DO:
               CREATE THGERENC.TGECINV0.
               ASSIGN
                 THGERENC.TGECINV0.CODCIA   = S-CODCIA
                 THGERENC.TGECINV0.TIPTABLA = "MAR"
                 THGERENC.TGECINV0.CODFAM   = TlgCinv0.Marca
                 THGERENC.TGECINV0.VALDOL   = T-ACUM-MAR
                 THGERENC.TGECINV0.FCHACT   = TODAY
                 THGERENC.TGECINV0.HORAACT  = STRING(TIME,"hh:mm").                                                                                                                                        
            END.
        T-ACUM-MAR = 0.            
     END. 



END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Consolidados W-Win 
PROCEDURE Consolidados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR wprecos AS DECIMAL NO-UNDO.
DEFINE VAR wtotsto AS DECIMAL NO-UNDO.
DEFINE VAR J       AS INTEGER NO-UNDO.

DEFINE VARIABLE F-DESFAM   AS CHAR INIT "".
DEFINE VARIABLE T-ACUM-ALM AS DECIMAL INIT 0.
DEFINE VARIABLE T-ACUM-FAM AS DECIMAL INIT 0.
DEFINE VARIABLE T-ACUM-SUB AS DECIMAL INIT 0.

J = 0.

FOR EACH Almmmate NO-LOCK WHERE Almmmate.CodCia = s-codcia AND Almmmate.CodAlm = s-codalm,
    EACH Almmmatg OF Almmmate NO-LOCK 
    BREAK BY Almmmate.CODALM
          BY Almmmatg.CODFAM 
          BY Almmmatg.SUBFAM :

    ASSIGN
          fill-in-1 = Almmmate.CodMat + "-" + Almmmatg.Desmat. 
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
    IF integral.Almmmatg.MonVta = 1 THEN wprecos = (integral.Almmmatg.CtoLis / wtipcam).
    ELSE wprecos = integral.Almmmatg.CtoLis.

    T-ACUM-ALM = T-ACUM-ALM + ( integral.Almmmate.StkAct * WPRECOS ).
    T-ACUM-FAM = T-ACUM-FAM + ( integral.Almmmate.StkAct * WPRECOS ).

/***T-ACUM-SUB = T-ACUM-SUB + ( integral.Almmmate.StkAct * WPRECOS ).****/
        
    FIND THGERENC.TlgCinv0 WHERE THGERENC.TlgCinv0.Codcia = S-CODCIA 
         AND thgerenc.TLGCINV0.Codigo = Almmmate.CodMat NO-ERROR.
            IF AVAILABLE THGERENC.TlgCinv0 THEN DO:
               ASSIGN 
                   thgerenc.TLGCINV0.TipArt   = integral.Almmmatg.TipArt
                   thgerenc.TLGCINV0.PreCos   = wprecos
                   thgerenc.TLGCINV0.Unidad   = integral.Almmmatg.UndStk
                   thgerenc.TLGCINV0.Stock[I] = integral.Almmmate.StkAct.
            END.
            ELSE DO:
               CREATE THGERENC.TlgCinv0.
               ASSIGN  
                   THGERENC.TLGCINV0.CodCia   = integral.Almmmatg.CodCia 
                   THGERENC.TLGCINV0.Codigo   = integral.Almmmate.CodMat 
                   THGERENC.TLGCINV0.CodMar   = integral.Almmmatg.CodMar 
                   THGERENC.TLGCINV0.CodPro   = integral.Almmmatg.CodPr1
                   THGERENC.TLGCINV0.CodFam   = integral.Almmmatg.CodFam
                   THGERENC.TLGCINV0.CodSub   = integral.Almmmatg.subfam
                   THGERENC.TLGCINV0.TipArt   = integral.Almmmatg.TipArt
                   THGERENC.TLGCINV0.PreCos   = wprecos
                   THGERENC.TLGCINV0.Unidad   = integral.Almmmatg.UndStk
                   THGERENC.TLGCINV0.Marca    = integral.Almmmatg.DesMar 
                   THGERENC.TLGCINV0.Unidad   = integral.Almmmatg.UndStk
                   THGERENC.TLGCINV0.NomArt   = integral.Almmmatg.DesMat
                   THGERENC.TLGCINV0.Stock[I] = integral.Almmmate.StkAct.   
            END.
            
    IF LAST-OF(Almmmatg.CODFAM) THEN DO :
       FIND FIRST THGERENC.TGECINV0 WHERE THGERENC.TGECINV0.CODCIA   = S-CODCIA  AND
                                          THGERENC.TGECINV0.TIPTABLA = "FAM"     AND
                                          THGERENC.TGECINV0.CODALM   = S-CODALM  AND 
                                          THGERENC.TGECINV0.CODFAM   = Almmmatg.CODFAM NO-ERROR.
                                          
            IF AVAILABLE THGERENC.TGECINV0 THEN DO:
               ASSIGN
                 THGERENC.TGECINV0.VALSOL   = T-ACUM-FAM * wtipcam
                 THGERENC.TGECINV0.VALDOL   = T-ACUM-FAM
                 THGERENC.TGECINV0.FCHACT   = TODAY
                 THGERENC.TGECINV0.HORAACT  = STRING(TIME,"HH:MM").
            END.
            ELSE DO:
               FIND FIRST AlmtFami WHERE Almtfami.CodCia = S-CODCIA AND
                                         Almtfami.codfam = Almmmatg.CODFAM NO-LOCK NO-ERROR.
               IF AVAILABLE AlmtFami THEN F-DESFAM = Almtfami.desfam.
                  ELSE F-DESFAM = "".
               CREATE THGERENC.TGECINV0.
               ASSIGN
                 THGERENC.TGECINV0.CODCIA   = S-CODCIA
                 THGERENC.TGECINV0.TIPTABLA = "FAM"
                 THGERENC.TGECINV0.CODALM   = S-CODALM
                 THGERENC.TGECINV0.CODFAM   = Almmmatg.CODFAM
                 THGERENC.TGECINV0.DESFAM   = F-DESFAM
                 THGERENC.TGECINV0.VALSOL   = T-ACUM-FAM * wtipcam
                 THGERENC.TGECINV0.VALDOL   = T-ACUM-FAM
                 THGERENC.TGECINV0.FCHACT   = TODAY
                 THGERENC.TGECINV0.HORAACT  = STRING(TIME,"hh:mm").                                                                                                                                        
            END.

       T-ACUM-FAM = 0.         
    END.

    IF LAST-OF(Almmmate.CODALM) THEN DO :
       FIND FIRST THGERENC.TGECINV0 WHERE THGERENC.TGECINV0.CODCIA   = S-CODCIA  AND
                                          THGERENC.TGECINV0.TIPTABLA = "ALM"     AND
                                          THGERENC.TGECINV0.CODALM   = S-CODALM  NO-ERROR. 
            IF AVAILABLE THGERENC.TGECINV0 THEN DO:
               ASSIGN
                 THGERENC.TGECINV0.VALSOL   = T-ACUM-ALM * wtipcam
                 THGERENC.TGECINV0.VALDOL   = T-ACUM-ALM
                 THGERENC.TGECINV0.FCHACT   = TODAY
                 THGERENC.TGECINV0.HORAACT  = STRING(TIME,"HH:MM").
            END.
            ELSE DO:
               CREATE THGERENC.TGECINV0.
               ASSIGN
                 THGERENC.TGECINV0.CODCIA   = S-CODCIA
                 THGERENC.TGECINV0.TIPTABLA = "ALM"
                 THGERENC.TGECINV0.CODALM   = S-CODALM
                 THGERENC.TGECINV0.VALSOL   = T-ACUM-ALM * wtipcam
                 THGERENC.TGECINV0.VALDOL   = T-ACUM-ALM
                 THGERENC.TGECINV0.FCHACT   = TODAY
                 THGERENC.TGECINV0.HORAACT  = STRING(TIME,"hh:mm").                                                                                                                                        
            END.
    
       T-ACUM-ALM = 0.         
    END.

/********    
    IF LAST-OF(Almmmatg.SUBFAM) THEN DO :
    END.        
*********/    
             
END.


/*   ACTUALIZA TOTALES POR ARTICULOS  */
wtotsto = 0.
FOR EACH THGERENC.TlgCinv0 WHERE THGERENC.TlgCinv0.CodCia = s-codcia EXCLUSIVE:
    ASSIGN
       fill-in-1 = THGERENC.TlgCinv0.Codigo + "-" + thgerenc.TlgCinv0.NomArt. 
       DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
    wtotsto = 0.
    DO J = 1 TO 15: 
       wtotsto = wtotsto + THGERENC.TLGCINV0.Stock[J].
    END.
    ASSIGN
       thgerenc.TLGCINV0.StkTot = wtotsto
       thgerenc.TLGCINV0.TotVal = ROUND(thgerenc.TLGCINV0.StkTot * thgerenc.TLGCINV0.PreCos,2). 
END.

/*
FOR EACH thgerenc.TLGCINV0 WHERE thgerenc.TLGCINV0.CodCia = S-CODCIA 
     AND thgerenc.TLGCINV0.CodCia = S-CODDIV:
     
    wfactor = ROUND((TvtVart0.ArtVtdol / wtotgen) * 100 ,2).
    ASSIGN
         TvtVart0.ArtFACPA = wfactor.    
END.
*/


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
  DISPLAY EDITOR-2 FILL-IN-1 COMBO-BOX-1 W-FECHA 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 BUTTON-12 COMBO-BOX-1 W-FECHA BUTTON-13 BUTTON-14 
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
-------------------------------------------------------------------------------- */

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  editor-2 = " Este proceso consolida todos los productos
  de este Almacen al Area de Logistica Compras, efectue este proceso
  cuando tengas pocos trabajos activos. ".
  
  DISPLAY EDITOR-2 WITH FRAME {&FRAME-NAME}.
  ASSIGN
        w-fecha = today.
  DISPLAY w-fecha WITH FRAME {&FRAME-NAME}.                  
  /* Code placed here will execute AFTER standard behavior.    */
  
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


