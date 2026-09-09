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
DEF VAR wtipcam AS DEC NO-UNDO.

DEF VAR wfactor AS DECIMAL NO-UNDO.
DEF VAR I       AS INT NO-UNDO.

DEF VAR w-perio AS INT NO-UNDO.
DEF VAR w-mes   AS INT NO-UNDO.
DEF VAR w-dia   AS INT NO-UNDO.

DEF VAR w-perio-2 AS INT NO-UNDO.
DEF VAR w-mes-2   AS INT NO-UNDO.
DEF VAR w-dia-2   AS INT NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 COMBO-BOX-1 W-FECHA W-FECHA-2 ~
BUTTON-12 BUTTON-13 BUTTON-14 
&Scoped-Define DISPLAYED-OBJECTS EDITOR-2 FILL-IN-1 COMBO-BOX-1 W-FECHA ~
W-FECHA-2 

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
     SIZE 33.14 BY 4.23
     BGCOLOR 15 FONT 6 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.29 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE W-FECHA AS DATE FORMAT "99/99/9999":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE VARIABLE W-FECHA-2 AS DATE FORMAT "99/99/9999":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48.43 BY 7.54.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 33.14 BY 1.35.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     EDITOR-2 AT ROW 1.19 COL 2 NO-LABEL
     FILL-IN-1 AT ROW 7.12 COL 2.14 NO-LABEL
     COMBO-BOX-1 AT ROW 16.92 COL 1 NO-LABEL
     W-FECHA AT ROW 5.73 COL 5.72 COLON-ALIGNED
     W-FECHA-2 AT ROW 5.65 COL 22.29 COLON-ALIGNED
     BUTTON-12 AT ROW 1.46 COL 36
     BUTTON-13 AT ROW 3.38 COL 36
     BUTTON-14 AT ROW 5.31 COL 36
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
         TITLE              = "Regeneracion de Estadisticas"
         HEIGHT             = 7.5
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

IF NOT W-Win:LOAD-ICON("img\db":U) THEN
    MESSAGE "Unable to load icon: img\db"
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
ON END-ERROR OF W-Win /* Regeneracion de Estadisticas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Regeneracion de Estadisticas */
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
        w-fecha-2.
        w-perio    = YEAR(w-fecha).
        w-mes      = MONTH(w-fecha).
        w-dia      = DAY(w-fecha).
        w-perio-2  = YEAR(w-fecha-2).
        w-mes-2    = MONTH(w-fecha-2).
        w-dia-2    = DAY(w-fecha-2).

  MESSAGE " Esta seguro de Efectuar operacion " VIEW-AS ALERT-BOX QUESTION 
  BUTTONS yes-no
  UPDATE wresp AS LOGICAL.
  CASE wresp:
       WHEN yes THEN DO:
            IF w-fecha = ? then DO:
               MESSAGE " DIGITE LA FECHA  " VIEW-AS ALERT-BOX ERROR.
               APPLY "ENTRY" TO w-fecha.
               return NO-APPLY.  
            END.   
            IF w-fecha-2 = ? then DO:
               MESSAGE " DIGITE LA FECHA  " VIEW-AS ALERT-BOX ERROR.
               APPLY "ENTRY" TO w-fecha-2.
               return NO-APPLY.  
            END.   

            IF session:set-wait-state("GENERAL") THEN.
            RUN EvtDivi.
            RUN EvtClie.
            RUN EvtArti.
            RUN EvtFpgo.
      
           IF session:set-wait-state(" ") then.
            MESSAGE " Proceso Terminado " VIEW-AS ALERT-BOX INFORMATION. 
         END.  
       WHEN no  THEN 
            RETURN.
  END CASE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Flag-Cierre W-Win 
PROCEDURE Actualiza-Flag-Cierre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /****   Tabla de Cierre Diarios     ****/
 FIND TadtCie0 WHERE TadtCie0.ciecia = S-CODCIA 
                AND  TadtCie0.ciediv = S-CODDIV 
               EXCLUSIVE-LOCK NO-ERROR.
 IF NOT AVAILABLE tadtcie0 THEN DO:
        CREATE TadtCie0.
         ASSIGN TadtCie0.ciecia   = S-CODCIA
                TadtCie0.ciediv   = S-CODDIV.
 END.
 ASSIGN TadtCie0.cieperio = YEAR(w-fecha)
        TadtCie0.ciemes   = MONTH(w-fecha)
        TadtCie0.ciefecha = w-fecha
        TadtCie0.cieflagc[w-dia] = 'X'.
 RELEASE TadtCie0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cieartic W-Win 
PROCEDURE cieartic :
/*------------------------------------------------------------------------------
  Purpose:     CIERRE DE VENTAS DE ARTICULOS
  Parameters:  FECHA DE CIERRE 
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR wtotgen AS DECIMAL NO-UNDO.
DEFINE VAR wtotsol AS DECIMAL NO-UNDO.
DEFINE VAR wtotdol AS DECIMAL NO-UNDO.
DEFINE VAR wtovtso AS DECIMAL NO-UNDO.
DEFINE VAR wtovtdo AS DECIMAL NO-UNDO.
DEFINE VAR wcanto1 AS DECIMAL NO-UNDO.
DEFINE VAR wcanto2 AS DECIMAL NO-UNDO.
DEFINE VAR wcantot AS DECIMAL NO-UNDO.


/* FOR EACH CcbDdocu NO-LOCK, FIRST CcbCdocu OF CcbDdocu NO-LOCK WHERE CcbCDocu.CodCia = S-CODCIA
     AND CcbCDocu.CodDiv = S-CODDIV AND CcbCdocu.FchDoc = w-fecha AND
         CcbCDocu.FlgEst <> "A" 
         BREAK BY ccbDdocu.CodMat:   */
         
   FOR EACH CcbCdocu NO-LOCK WHERE CcbCDocu.CodCia = S-CODCIA 
                              AND  CcbCDocu.CodDiv = S-CODDIV 
                              AND  CcbCdocu.FchDoc = w-fecha 
                              AND  CcbCDocu.FlgEst <> "A" , 
       EACH CcbDdocu OF ccbCdocu NO-LOCK
                             BREAK BY ccbDdocu.CodMat:   
   
/*  Totales por Articulo */
    IF FIRST-OF(ccbDdocu.CodMat) THEN DO:
       wtotsol = 0.
       wtotdol = 0.
       wtotcts = 0.
       wtotctd = 0.
       wtotcrs = 0.
       wtotcrd = 0.
    END.  
        
    IF ccbCdocu.CodMon = 1 THEN wtotsol = wtotsol + ccbDdocu.ImpLin.
    IF ccbCdocu.CodMon = 2 THEN wtotdol = wtotdol + ccbDdocu.ImpLin.
    
    IF ccbCdocu.Tipo = "1" AND ccbCdocu.CodMon = 1 THEN
       wtotcts = wtotcts + (CcbDDocu.CanDes * CcbDDocu.Factor).
    IF ccbCdocu.Tipo = "1" AND ccbCdocu.CodMon = 2 THEN
       wtotctd = wtotctd + (CcbDDocu.CanDes * CcbDDocu.Factor).
    IF ccbCdocu.Tipo = "2" AND ccbCdocu.CodMon = 1 THEN 
       wtotcrs = wtotcrs + (CcbDDocu.CanDes * CcbDDocu.Factor).
    IF ccbCdocu.Tipo = "2" AND ccbCdocu.CodMon = 2 THEN
       wtotcrd = wtotcrd + (CcbDDocu.CanDes * CcbDDocu.Factor).
        
    ASSIGN
          fill-in-1 = CcbDdocu.CodMat. 
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
    
    IF LAST-OF(ccbDdocu.CodMat) THEN DO:
       /****    Resumen de Ventas Articulos x Dia   ****/
       FIND tvtvart0 WHERE tvtvart0.ArtCia = S-CODCIA 
                      AND  tvtvart0.ArtDiv = S-CODDIV 
                      AND  tvtvart0.ArtCodig = ccbDdocu.codMat 
                     EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE tvtvart0 THEN DO:
               ASSIGN 
                     TvtVart0.ArtFecha        = w-fecha
                     TvtVart0.ArtHora         = STRING(TIME,"HH:MM")
                     TvtVart0.ArtUser         = S-USER-ID 
                     TvtVart0.ArtCacts[w-dia] = wtotcts
                     TvtVart0.ArtCactd[w-dia] = wtotctd
                     TvtVart0.ArtCacrs[w-dia] = wtotcrs
                     TvtVart0.ArtCacrd[w-dia] = wtotcrd
                     TvtvArt0.ArtTodol        = TvtvArt0.ArtTodol + wtotdol
                     TvtvArt0.ArtToSol        = TvtvArt0.ArtTosol + wtotsol.
       END.
       ELSE DO:
               CREATE TvtVart0.
               ASSIGN TvtVart0.ArtCia          = S-CODCIA
                      TvtVart0.ArtDiv          = S-CODDIV
                      TvtVart0.ArtCodig        = ccbDdocu.CodMat
                      TvtVart0.ArtFecha        = w-fecha
                      TvtVart0.ArtHora         = STRING(TIME,"HH:MM")
                      TvtVart0.ArtUser         = S-USER-ID 
                      TvtVart0.ArtCacts[w-dia] = wtotcts
                      TvtVart0.ArtCactd[w-dia] = wtotctd
                      TvtVart0.ArtCacrs[w-dia] = wtotcrs
                      TvtVart0.ArtCacrd[w-dia] = wtotcrd
                      TvtvArt0.ArtTodol        = TvtvArt0.ArtTodol + wtotdol
                      TvtvArt0.ArtToSol        = TvtvArt0.ArtTosol + wtotsol.
                      
       END.
       RELEASE Tvtvart0.
    END.
END.

/*  ACTUALIZA CANTIDADES POR ARTICULOS */
wtotgen = 0.
FOR EACH TvtVart0 WHERE TvtVart0.ArtCia = S-CODCIA 
                   AND  TvtVart0.ArtDiv = S-CODDIV 
                  EXCLUSIVE-LOCK:
    wtotgen = 0.
    wcanto1 = 0.
    wcanto2 = 0.
    
    DO I = 1 TO 31: 
       wcanto1 = wcanto1 + (TvtVart0.ArtCacts[i] + TvtVart0.ArtCacrs[i]). 
       wcanto2 = wcanto2 + (TvtVart0.ArtCactd[i] + TvtVart0.ArtCacrd[i]).
       wcantot = (wcanto1 + wcanto2).
    END.
    wtotdol = wtovtdo + (wtovtso / wtipcam).
    wtotsol = wtovtso + (wtovtdo * wtipcam).
    ASSIGN
         TvtVart0.Artcanto = wcantot             
      /*   TvtVart0.Arttosol = wtovtso             
           TvtVart0.Arttodol = wtovtdo              */
         TvtVart0.ArtVtsol = wtotsol             
         TvtVart0.ArtVtdol = wtotdol.             
    wtotgen = wtotgen + wtotdol.
END.

FOR EACH TvtVart0 WHERE TvtVart0.ArtCia = S-CODCIA
                   AND  TvtVart0.ArtDiv = S-CODDIV 
                  EXCLUSIVE-LOCK:
    wfactor = ROUND((TvtVart0.ArtVtdol / wtotgen) * 100 ,2).
    ASSIGN
         TvtVart0.ArtFACPA = wfactor.    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ciecli W-Win 
PROCEDURE ciecli :
/*------------------------------------------------------------------------------
  Purpose:     RESUMEN VENTA DE CLIENTES 
  Parameters:  FECHA CIERRE 
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR wtotgen  AS DECIMAL NO-UNDO.
DEF VAR wtovtso  AS DECIMAL NO-UNDO.
DEF VAR wtovtdo  AS DECIMAL NO-UNDO.

FOR EACH ccbCdocu WHERE ccbCdocu.CodCia = S-CODCIA 
                   AND  ccbCdocu.CodDiv = S-CODDIV 
                   AND  CcbCDocu.FchDoc = w-fecha 
                   AND  (CcbCDocu.CodDoc = "FAC" OR CcbCDocu.CodDoc = "BOL") 
                   AND  CcbCDocu.FlgEst <> "A" 
                  BREAK BY ccbCdocu.CodCia 
                        BY ccbCdocu.CodCli: 
    
/*  Totales por Cliente  */
    IF FIRST-OF(ccbCdocu.CodCli) THEN DO:
       wtotsol = 0.
       wtotdol = 0.
       wtotcts = 0.
       wtotcrs = 0.
       wtotctd = 0.
       wtotcrd = 0.
    END.
    IF ccbCdocu.CodMon = 1 THEN wtotsol = wtotsol + ccbCdocu.ImpTot.
    IF ccbCdocu.CodMon = 2 THEN wtotdol = wtotdol + ccbCdocu.ImpTot.
    
    IF ccbCdocu.TipVta = "1" AND ccbCdocu.CodMon = 1 THEN
       wtotcts = wtotcts + ccbCdocu.ImpTot.
    IF ccbCdocu.TipVta = "1" AND ccbCdocu.CodMon = 2 THEN
       wtotctd = wtotctd + ccbCdocu.ImpTot.
    IF ccbCdocu.TipVta = "2" AND ccbCdocu.CodMon = 1 THEN 
       wtotcrs = wtotcrs + ccbCdocu.ImpTot.
    IF ccbCdocu.TipVta = "2" AND ccbCdocu.CodMon = 2 THEN
       wtotcrd = wtotcrd + ccbCdocu.ImpTot.
        
    ASSIGN
          fill-in-1 = CcbCDocu.CodCli + "-" + CcbCDocu.NomCli.
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
    
    IF LAST-OF(ccbCdocu.codCli) THEN DO:
       /****    Resumen de Ventas Clientes x Dia    ****/
       FIND tvtvcli0 WHERE tvtvcli0.CliCia = S-CODCIA 
                      AND  tvtvcli0.CliDiv = S-CODDIV 
                      AND  tvtvcli0.CliCodig = ccbCdocu.codCli 
                     EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE tvtvcli0 THEN DO:
               ASSIGN  
                     Tvtvcli0.cliFecha        = w-fecha
                     Tvtvcli0.cliHora         = STRING(TIME,"HH:MM")
                     Tvtvcli0.cliUser         = S-USER-ID 
                     Tvtvcli0.clivtcts[w-dia] = wtotcts
                     Tvtvcli0.clivtctd[w-dia] = wtotctd
                     Tvtvcli0.clivtcrs[w-dia] = wtotcrs
                     Tvtvcli0.clivtcrd[w-dia] = wtotcrd.
       END.
       ELSE DO:
               CREATE Tvtvcli0.
               ASSIGN Tvtvcli0.cliCia          = S-CODCIA
                      Tvtvcli0.cliDiv          = S-CODDIV
                      Tvtvcli0.clicodig        = ccbCdocu.codCli
                      Tvtvcli0.cliNombre       = ccbCdocu.NomCli
                      Tvtvcli0.cliFecha        = w-fecha
                      Tvtvcli0.cliHora         = STRING(TIME,"HH:MM")
                      Tvtvcli0.cliUser         = S-USER-ID 
                      Tvtvcli0.clivtcts[w-dia] = wtotcts
                      Tvtvcli0.clivtctd[w-dia] = wtotctd
                      Tvtvcli0.clivtcrs[w-dia] = wtotcrs
                      Tvtvcli0.clivtcrd[w-dia] = wtotcrd.
       END.
       RELEASE Tvtvcli0.
    END.
END.

/* ACTUALIZA TOTALES POR CLIENTES */

wtotgen = 0.
FOR EACH tvtvcli0 WHERE tvtvcli0.CliCia = S-CODCIA 
                   AND  tvtvcli0.CliDiv = S-CODDIV:
    wtovtso = 0.
    wtovtdo = 0.
    DO I = 1 TO 31: 
       wtovtso = wtovtso + (tvtvcli0.CliVtcts[i] + tvtvcli0.CliVtcrs[i]).
       wtovtdo = wtovtdo + (tvtvcli0.CliVtctd[i] + tvtvcli0.CliVtcrd[i]).
    END.
    wtotdol = wtovtdo + (wtovtso / wtipcam).
    wtotsol = wtovtso + (wtovtdo * wtipcam).
    ASSIGN
         tvtvcli0.Clitosol = wtovtso.
         tvtvcli0.Clitodol = wtovtdo.
         tvtvcli0.CliVtsol = wtotsol.
         tvtvcli0.CliVtdol = wtotdol.
    wtotgen = wtotgen + wtotdol.
END.

FOR EACH tvtvcli0 WHERE tvtvcli0.CliCia = S-CODCIA 
                   AND  tvtvcli0.CliDiv = S-CODDIV:
    wfactor = ROUND((tvtvcli0.CliVtdol / wtotgen) * 100 ,2).
    ASSIGN
         tvtvcli0.CliFACPA = wfactor.    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ciediv W-Win 
PROCEDURE ciediv :
/*------------------------------------------------------------------------------
  Purpose:     RESUMEN DE VENTAS POR DIVISION
  Parameters:  FECHA DEL DIA
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR wtotgen AS DECIMAL NO-UNDO.
DEFINE VAR wtovtso AS DECIMAL NO-UNDO.
DEFINE VAR wtovtdo AS DECIMAL NO-UNDO.

DEFINE VAR w-vtcts AS DECIMAL NO-UNDO.
DEFINE VAR w-vtcrs AS DECIMAL NO-UNDO.
DEFINE VAR w-vtctd AS DECIMAL NO-UNDO.
DEFINE VAR w-vtcrd AS DECIMAL NO-UNDO.

DEF VAR wnrofac  AS INTEGER NO-UNDO.
DEF VAR wnrobol  AS INTEGER NO-UNDO.
 

wtotcts = 0.
wtotcrs = 0.

FOR EACH ccbCdocu NO-LOCK WHERE ccbCdocu.CodCia = S-CODCIA 
                           AND  ccbCdocu.CodDiv = S-CODDIV 
                           AND  CcbCDocu.FchDoc = w-fecha 
                           AND  CcbCDocu.FlgEst <> "A" 
                           AND  (CcbCDocu.CodDoc = "FAC" OR CcbCDocu.CodDoc = "BOL")
                          BREAK BY CcbCDocu.FchDoc: 
         
/*  Totales por Division  */
    IF FIRST-OF(FchDoc) THEN DO:
       wtotsol = 0.
       wtotdol = 0.
       wnrofac = 0.
       wnrobol = 0.
    END.  
    IF CcbCDocu.CodDoc = "FAC" THEN wnrofac = wnrofac + 1.
    IF CcbCDocu.CodDoc = "BOL" THEN wnrobol = wnrobol + 1.

    IF ccbCdocu.CodMon = 1 THEN wtotsol = wtotsol + ccbCdocu.ImpTot.
    IF ccbCdocu.CodMon = 2 THEN wtotdol = wtotdol + ccbCdocu.ImpTot.
    
    IF ccbCdocu.TipVta = "1" AND ccbCdocu.CodMon = 1 THEN
       wtotcts = wtotcts + ccbCdocu.ImpTot.
    IF ccbCdocu.TipVta = "1" AND ccbCdocu.CodMon = 2 THEN
       wtotctd = wtotctd + ccbCdocu.ImpTot.
    IF ccbCdocu.TipVta = "2" AND ccbCdocu.CodMon = 1 THEN 
       wtotcrs = wtotcrs + ccbCdocu.ImpTot.
    IF ccbCdocu.TipVta = "2" AND ccbCdocu.CodMon = 2 THEN
       wtotcrd = wtotcrd + ccbCdocu.ImpTot.
        
    ASSIGN
          fill-in-1 = CcbCDocu.CodDoc + "-" + CcbCDocu.NroDoc.
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
     
    IF LAST-OF(FchDoc) THEN DO:
       /****    Resumen de Ventas x Division x Dia  ****/
       FIND tvtvdiv0 WHERE tvtvdiv0.DivCia = S-CODCIA 
                      AND  tvtvdiv0.Divcod = S-CODDIV 
                      AND  tvtvdiv0.DivFecha = w-fecha 
                     EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE tvtvdiv0 THEN DO:
               ASSIGN  
                     Tvtvdiv0.DivHora  = STRING(TIME,"HH:MM")
                     Tvtvdiv0.DivUser  = S-USER-ID
                     Tvtvdiv0.divvtcts = wtotcts
                     Tvtvdiv0.divvtctd = wtotctd
                     Tvtvdiv0.divvtcrs = wtotcrs
                     Tvtvdiv0.divvtcrd = wtotcrd
                     Tvtvdiv0.DivTodol  = wtotctd + wtotcrd
                     Tvtvdiv0.DivTosol  = wtotcts + wtotcrs
                     Tvtvdiv0.DivNrbol  = wnrobol
                     Tvtvdiv0.DivNrfac  = wnrofac.
       END.
       ELSE DO:
               CREATE tvtvdiv0.
               ASSIGN Tvtvdiv0.DivCia    = S-CODCIA
                      Tvtvdiv0.DivCod    = S-CODDIV
                      Tvtvdiv0.DivFecha  = w-fecha
                      Tvtvdiv0.DivHora   = STRING(TIME,"HH:MM")
                      Tvtvdiv0.DivUser   = S-USER-ID 
                      Tvtvdiv0.Divvtcts  = wtotcts
                      Tvtvdiv0.Divvtctd  = wtotctd
                      Tvtvdiv0.Divvtcrs  = wtotcrs
                      Tvtvdiv0.Divvtcrd  = wtotcrd
                      Tvtvdiv0.DivTodol  = wtotctd + wtotcrd
                      Tvtvdiv0.DivTosol  = wtotcts + wtotcrs
                      Tvtvdiv0.DivNrbol  = wnrobol
                      Tvtvdiv0.DivNrfac  = wnrofac.
       END.
       RELEASE Tvtvdiv0.         
    END.
END.    
   
/* ACTUALIZA TOTALES POR DIVISION  */
wtotgen = 0.   
wtovtso = 0.
wtovtdo = 0.

/* Variables Acumulado Mensual */
w-vtcts = 0.
w-vtcrs = 0.
w-vtctd = 0.
w-vtcrd = 0.

FOR EACH tvtvdiv0 WHERE tvtvdiv0.DivCia = S-CODCIA 
                   AND  tvtvdiv0.Divcod = S-CODDIV 
                   AND  YEAR (tvtvdiv0.DivFecha) = w-perio 
                   AND  MONTH (tvtvdiv0.DivFecha)= w-mes 
                  EXCLUSIVE: 

    w-vtcts = w-vtcts + tvtvDiv0.DivVtcts.
    w-vtcrs = w-vtcrs + tvtvDiv0.DivVtcrs.
    w-vtctd = w-vtctd + tvtvDiv0.DivVtctd.
    w-vtcrd = w-vtcrd + tvtvDiv0.DivVtcrd.
        
    wtovtso = tvtvDiv0.DivVtcts + TvtvDiv0.DivVtcrs.
    wtovtdo = tvtvDiv0.DivVtctd + TvtvDiv0.DivVtcrd.
       
    wtotdol = wtovtdo + (wtovtso / wtipcam).
    wtotsol = wtovtso + (wtovtdo * wtipcam).
    ASSIGN
         tvtvDiv0.Divtosol = wtovtso.
         tvtvDiv0.Divtodol = wtovtdo.
         tvtvDiv0.DivVtsol = wtotsol.
         tvtvDiv0.DivVtdol = wtotdol.
        
    wtotgen = wtotgen + Tvtvdiv0.DivVtdol.
END.

FOR EACH tvtvdiv0 WHERE tvtvdiv0.DivCia = S-CODCIA 
                   AND  tvtvdiv0.Divcod = S-CODDIV 
                   AND  YEAR (tvtvdiv0.DivFecha) = w-perio 
                   AND  MONTH (tvtvdiv0.DivFecha)= w-mes 
                  EXCLUSIVE: 
    wfactor = ROUND((tvtvdiv0.DivVtdol / wtotgen) * 100 ,2).
    ASSIGN
          Tvtvdiv0.DivFacpa = wfactor.    
END. 

/* Actualiza Archivo Mensual */
/****   Movimiento Mensuales por Division   ****/
FIND TmsvDiv0 WHERE TmsvDiv0.DivCia = S-CODCIA  
               AND  TmsvDiv0.Divcod = S-CODDIV  
               AND  TmsvDiv0.DivPerio = w-perio 
               AND  TmsvDiv0.DivMes = w-mes 
              EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE TmsvDiv0 THEN DO:
   ASSIGN  
         Tmsvdiv0.DivUser  = S-USER-ID
         Tmsvdiv0.Divvtcts = w-vtcts
         Tmsvdiv0.Divvtctd = w-vtctd
         Tmsvdiv0.Divvtcrs = w-vtcrs
         Tmsvdiv0.Divvtcrd = w-vtcrd
         Tmsvdiv0.DivTodol = w-vtctd + w-vtcrd
         Tmsvdiv0.DivTosol = w-vtcts + w-vtcrs.
END.
ELSE DO:
   CREATE Tmsvdiv0.
   ASSIGN Tmsvdiv0.DivCia    = S-CODCIA
          Tmsvdiv0.DivCod    = S-CODDIV
          Tmsvdiv0.DivPerio  = w-perio
          Tmsvdiv0.DivMes    = w-mes
          Tmsvdiv0.DivUser   = S-USER-ID 
          Tmsvdiv0.Divvtcts  = w-vtcts
          Tmsvdiv0.Divvtctd  = w-vtctd
          Tmsvdiv0.Divvtcrs  = w-vtcrs
          Tmsvdiv0.Divvtcrd  = w-vtcrd
          Tmsvdiv0.DivTodol  = w-vtctd + w-vtcrd
          Tmsvdiv0.DivTosol  = w-vtcts + w-vtcrs.
END.
Release TmsvDiv0.         
             
wtotgen = 0.
FOR EACH Tmsvdiv0 WHERE Tmsvdiv0.DivCia = S-CODCIA 
                   AND  Tmsvdiv0.Divcod = S-CODDIV 
                  EXCLUSIVE: 

    wtovtso = TmsvDiv0.DivVtcts + TmsvDiv0.DivVtcrs.
    wtovtdo = TmsvDiv0.DivVtctd + TmsvDiv0.DivVtcrd.
       
    wtotdol = wtovtdo + (wtovtso / wtipcam).
    wtotsol = wtovtso + (wtovtdo * wtipcam).
    ASSIGN
         tmsvDiv0.Divtosol = wtovtso.
         tmsvDiv0.Divtodol = wtovtdo.
         tmsvDiv0.DivVtsol = wtotsol.
         tmsvDiv0.DivVtdol = wtotdol.
        
    wtotgen = wtotgen + Tmsvdiv0.DivVtdol.
    RELEASE Tmsvdiv0.
END.
    
FOR EACH Tmsvdiv0 WHERE Tmsvdiv0.DivCia = S-CODCIA 
                   AND  Tmsvdiv0.Divcod = S-CODDIV
                  EXCLUSIVE:
    wfactor = ROUND((Tmsvdiv0.DivVtdol / wtotgen) * 100 ,2).
     
    ASSIGN
          Tmsvdiv0.DivFacpa = wfactor.    
END. 
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cieime W-Win 
PROCEDURE cieime :
/*------------------------------------------------------------------------------
  Purpose:     Cierre de Importadores x Exportador
  Parameters:  wano wmes
  Notes:       Detalle de Importadores que compran a un determinado Exportador
------------------------------------------------------------------------------*/
/*  FOR EACH timvimp0 WHERE YEAR(timvimp0.impfelle) = wano 
    and MONTH(timvimp0.impfelle) = wmes
    BREAK BY timvimp0.impcoexp + timvimp0.impcoimp:
   
/********* TOTALES POR EXPORTADO+IMPORTADOR EN UN PERIODO *********/
    IF FIRST-OF(impcoexp + impcoimp) THEN DO:
       wtotimp = 0.
    END.   
    /* AREA DE MENSAGES */
    ASSIGN
            fill-in-1 = 'EXPORTADOR -> ' + impcoexp + '-' + impcoimp.
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
    wtotimp = wtotimp + ROUND(timvimp0.IMPTOKIL / 1000,2). 
    IF LAST-OF(impcoexp + impcoimp) THEN DO:
       FIND tesvime0 WHERE tesvime0.expcodig = timvimp0.impcoexp
                      AND  tesvime0.impcodig = timvimp0.impcoimp
                      AND  tesvime0.impperio = WANO 
                     NO-ERROR.
                      
            IF AVAILABLE tesvime0 THEN DO:
               ASSIGN  
                      thimport.tesvime0.IMPTOMES[wmes] = wtotimp.
            END.
            ELSE DO:
               CREATE tesvime0.
                      thimport.tesvime0.IMPPERIO = wano.
                      thimport.tesvime0.EXPCODIG = timvimp0.impcoexp.
                      thimport.tesvime0.IMPCODIG = timvimp0.impcoimp.
                      thimport.tesvime0.IMPTOMES[wmes] = wtotimp.
            END.
    END.
END.
    
/* ACTUALIZA TOTALES Y FACTOR DE PARTICIPACION 
   POR IMPORTADORES                                  */
                                                 
FOR EACH tesvime0 WHERE tesvime0.IMPPERIO = wano :
    wtotimp = 0.
    DO I = 1 TO 12: 
       wtotimp = wtotimp + thimport.tesvime0.IMPTOMES[i].
    END.
    ASSIGN
         thimport.tesvime0.IMPTOTGE = wtotimp.             
END.

FOR EACH tesvime0 WHERE tesvime0.IMPPERIO = wano
    BREAK BY thimport.tesvime0.EXPCODIG:
    IF FIRST-OF(expcodig) THEN DO:
       wtotgen = 0.
    END.   
    wtotgen = wtotgen + tesvime0.IMPTOTGE. 
    IF LAST-OF(expcodig) THEN DO:
       FOR EACH tesvime1 WHERE tesvime1.IMPPERIO = wano
                          AND  tesvime1.expcodig = tesvime0.expcodig:
           wfactor = ROUND((thimport.tesvime1.IMPTOTGE / wtotgen) * 100 ,2).
           ASSIGN
                thimport.tesvime1.IMPFACTO = wfactor.    
       END. 
    END.
END.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cieimp W-Win 
PROCEDURE cieimp :
/*------------------------------------------------------------------------------
  Purpose:     Cierre Importadores x Productos
  Parameters:  A¤O Mes
  Notes:       Quiebre x CODIGO IMPORTADOR y CODIGO PRODUCTO
-------------------------------------------------------------------------------*/
/*
FOR EACH timvimp0 WHERE YEAR(timvimp0.impfelle) = wano 
    and MONTH(timvimp0.impfelle) = wmes
    BREAK BY timvimp0.impcoimp + timvimp0.impcopro:
   
/*********** TOTALES POR SUB-SECTOR **************/
    IF FIRST-OF(impcoimp + impcopro) THEN DO:
       wtotimp = 0.
    END.
       
    /* AREA DE MENSAGES */
    ASSIGN
            fill-in-1 = 'IMPORTADOR -> ' + impcoimp + ' PRODUCTO -> ' + impcopro.
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
    
    wtotimp = wtotimp + ROUND(timvimp0.IMPTOKIL / 1000,2). 
    IF LAST-OF(impcoimp + impcopro) THEN DO:
       FIND tesvimp0 WHERE tesvimp0.IMPCODIG = timvimp0.impcoimp
                      AND  tesvimp0.IMPCOPRO = timvimp0.IMPCOPRO
                      AND  tesvimp0.IMPPERIO = WANO NO-ERROR.
            IF AVAILABLE tesvimp0 THEN DO:
               ASSIGN  
                      thimport.tesvimp0.IMPTOMES[wmes] = wtotimp.
            END.
            ELSE DO:
               CREATE tesvimp0.
                      thimport.tesvimp0.IMPPERIO = wano.
                      thimport.tesvimp0.IMPCODIG = timvimp0.impcoimp.
                      thimport.tesvimp0.IMPCOPRO = timvimp0.impcopro.
                      thimport.tesvimp0.IMPSECTO = timvimp0.impsecto.
                      thimport.tesvimp0.IMPSUBSE = timvimp0.impsubse.
                      thimport.tesvimp0.IMPTOMES[wmes] = wtotimp.
            END.         
    END.
END.
    
/* ACTUALIZA TOTALES Y FACTOR DE PARTICIPACION 
   POR IMPORTADORES                                                 */
FOR EACH tesvimp0 WHERE tesvimp0.IMPPERIO = wano :
    wtotimp = 0.
    DO I = 1 TO 12: 
       wtotimp = wtotimp + thimport.tesvimp0.IMPTOMES[i].
    END.
    ASSIGN
         thimport.tesvimp0.IMPTOTGE = wtotimp.             
END.

FOR EACH tesvimp1 WHERE tesvimp1.IMPPERIO = wano
    BREAK BY thimport.tesvimp0.IMPCOPRO:
    IF FIRST-OF(subcodig) THEN DO:
       wtotgen = 0.
    END.   
    wtotgen = wtotgen + tesvsub0.SUBTOTAL. 
    IF LAST-OF(subcodig) THEN DO:
       FOR EACH tesvimp1 WHERE tesvimp1.IMPPERIO = wano
                          AND  tesvsub1.subcodig = tesvsub0.subcodig:
           wfactor = ROUND((thimport.tesvsub1.SUBTOTAL / wtotgen) * 100 ,2).
           ASSIGN
                thimport.tesvimp1.SUBFACTO = wfactor.
       END. 
    END.
END.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cieven W-Win 
PROCEDURE cieven :
/*------------------------------------------------------------------------------
  Purpose:     CIERRE POR VENDEDORES 
  Parameters:  FECHA DEL CIERRE
  Notes:            
------------------------------------------------------------------------------*/
DEF VAR wtotgen  AS DECIMAL NO-UNDO.
DEF VAR wtovtso  AS DECIMAL NO-UNDO.
DEF VAR wtovtdo  AS DECIMAL NO-UNDO.

DEF VAR wnrofac  AS INTEGER NO-UNDO.
DEF VAR wnrobol  AS INTEGER NO-UNDO.
 
/* AREA DE MENSAGES */
ASSIGN
            fill-in-1 = "CIERRE VENDEDORES " + S-CODDIV.
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 

FOR EACH ccbCdocu WHERE ccbCdocu.CodCia = S-CODCIA 
                   AND  ccbCdocu.CodDiv = S-CODDIV 
                   AND  CcbCDocu.FchDoc = w-fecha 
                   AND  (CcbCDocu.CodDoc = "FAC" OR CcbCDocu.CodDoc = "BOL") 
                   AND  CcbCDocu.FlgEst <> "A" 
                  BREAK BY ccbcdocu.CodCia 
                        BY ccbcdocu.CodVen: 
    
/*  Totales por Vendedor  */
    IF FIRST-OF(CodVen) THEN DO:
       wtotsol = 0.
       wtotdol = 0.
       wtotcts = 0.
       wtotcrs = 0.
       wtotctd = 0.
       wtotcrd = 0.
       wnrofac = 0.
       wnrobol = 0.
    END.  
    IF CcbCDocu.CodDoc = "FAC" THEN wnrofac = wnrofac + 1.
    IF CcbCDocu.CodDoc = "BOL" THEN wnrobol = wnrobol + 1.
        
    IF ccbCdocu.CodMon = 1 THEN wtotsol = wtotsol + ccbCdocu.ImpTot.
    IF ccbCdocu.CodMon = 2 THEN wtotdol = wtotdol + ccbCdocu.ImpTot.
    
    IF ccbCdocu.TipVta = "1" AND ccbCdocu.CodMon = 1 THEN
       wtotcts = wtotcts + ccbCdocu.ImpTot.
    IF ccbCdocu.TipVta = "1" AND ccbCdocu.CodMon = 2 THEN
       wtotctd = wtotctd + ccbCdocu.ImpTot.
    IF ccbCdocu.TipVta = "2" AND ccbCdocu.CodMon = 1 THEN 
       wtotcrs = wtotcrs + ccbCdocu.ImpTot.
    IF ccbCdocu.TipVta = "2" AND ccbCdocu.CodMon = 2 THEN
       wtotcrd = wtotcrd + ccbCdocu.ImpTot.
        
    ASSIGN
          fill-in-1 = CcbCDocu.CodDoc + "-" + CcbCDocu.NroDoc.
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
    
    IF LAST-OF(codVen) THEN DO:
       /****    Resumen Ventas de Vendedores x Dia  ****/
       FIND tvtvven0 WHERE tvtvven0.VenCia = S-CODCIA 
                      AND  tvtvven0.VenDiv = S-CODDIV 
                      AND  tvtvven0.VenCodig = CcbCdocu.CodVen 
                     EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE tvtvven0 THEN DO:
               ASSIGN  
                     Tvtvven0.VenFecha        = w-fecha
                     Tvtvven0.VenHora         = STRING(TIME,"HH:MM")
                     Tvtvven0.Venvtcts[w-dia] = wtotcts
                     Tvtvven0.Venvtctd[w-dia] = wtotctd
                     Tvtvven0.Venvtcrs[w-dia] = wtotcrs
                     Tvtvven0.Venvtcrd[w-dia] = wtotcrd
                     TvtvVen0.VenNrbol        = wnrobol
                     TvtvVen0.VenNrfac        = wnrofac.
       END.
       ELSE DO:
               CREATE tvtvven0.
               ASSIGN Tvtvven0.VenCia          = S-CODCIA
                      Tvtvven0.VenDiv          = S-CODDIV
                      Tvtvven0.VenCodig        = CcbCdocu.CodVen
                      Tvtvven0.VenNombre       = CcbCdocu.NomCli
                      Tvtvven0.VenFecha        = w-fecha
                      Tvtvven0.VenHora         = STRING(TIME,"HH:MM")
                      Tvtvven0.VenUser         = S-USER-ID 
                      Tvtvven0.Venvtcts[w-dia] = wtotcts
                      Tvtvven0.Venvtctd[w-dia] = wtotctd
                      Tvtvven0.Venvtcrs[w-dia] = wtotcrs
                      Tvtvven0.Venvtcrd[w-dia] = wtotcrd
                      TvtvVen0.VenNrbol        = wnrobol
                      TvtvVen0.VenNrfac        = wnrofac.
       END.         
       Release TvtvVen0.
    END.
    
END.

/* ACTUALIZA TOTALES POR VENDEDORES */

wtotgen = 0.
FOR EACH tvtvven0 WHERE tvtvven0.VenCia = S-CODCIA 
                   AND  tvtvven0.VenDiv = S-CODDIV 
                  EXCLUSIVE-LOCK:
    wtovtso = 0.
    wtovtdo = 0.
    
    DO I = 1 TO 31: 
       wtovtso = wtovtso + (TvtVven0.VenVtcts[i] + tvtvven0.VenVtcrs[i]).
       wtovtdo = wtovtdo + (TvtVven0.VenVtctd[i] + tvtvven0.VenVtcrd[i]).
    END.
    wtotdol = wtovtdo + (wtovtso / wtipcam).
    wtotsol = wtovtso + (wtovtdo * wtipcam).
    ASSIGN
         TvtVven0.Ventosol = wtovtso.             
         TvtVven0.Ventodol = wtovtdo.             
         TvtVven0.VenVtsol = wtotsol.             
         TvtVven0.VenVtdol = wtotdol.             
    wtotgen = wtotgen + wtotdol.
END.

FOR EACH tvtvven0 WHERE tvtvven0.VenCia = S-CODCIA 
                   AND  tvtvven0.VenDiv = S-CODDIV 
                  EXCLUSIVE-LOCK:
    wfactor = ROUND((TvtVven0.VenVtdol / wtotgen) * 100 ,2).
    ASSIGN
         TvtVven0.VENFACPA = wfactor.    
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Elimina-PedidosMostrador W-Win 
PROCEDURE Elimina-PedidosMostrador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Elimina Cabecera y Detalle Pedidos Mostrador */

FOR EACH Faccpedm WHERE Faccpedm.CodCia = S-CODCIA 
                   AND  Faccpedm.CodDiv = S-CODDIV 
                   AND  Faccpedm.FchPed = w-fecha 
                  EXCLUSIVE-LOCK:
    fill-in-1 = "Eliminando Pedido : " + Faccpedm.NroPed.
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
    FOR EACH Facdpedm OF Faccpedm EXCLUSIVE-LOCK:
        DELETE  Facdpedm.
    END.
    DELETE  FacCpedm.
END.

/* Elimina Cabecera y Detalle Pedidos Oficina */

FOR EACH Faccpedi WHERE Faccpedi.CodCia = S-CODCIA 
                   AND  Faccpedi.CodDiv = S-CODDIV 
                   AND  Faccpedi.FchVen <= w-fecha 
                   AND  FaccPedi.FlgEst = "P" 
                  EXCLUSIVE-LOCK:
    fill-in-1 = "Eliminando Pedido : " + Faccpedi.NroPed.
    DISPLAY fill-in-1 WITH FRAME {&FRAME-NAME}. 
    FOR EACH Facdpedi OF Faccpedi EXCLUSIVE-LOCK:
        ASSIGN FacdPedi.FlgEst = "A".
    END.
    ASSIGN FacCPedi.FlgEst = "A" 
           FacCPedi.Glosa  = "ANULADO POR FECHA VIGENCIA VENCIDA".
END.

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
  DISPLAY EDITOR-2 FILL-IN-1 COMBO-BOX-1 W-FECHA W-FECHA-2 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE RECT-1 RECT-2 COMBO-BOX-1 W-FECHA W-FECHA-2 BUTTON-12 BUTTON-13 
         BUTTON-14 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EvtArti W-Win 
PROCEDURE EvtArti :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EvtClie W-Win 
PROCEDURE EvtClie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EvtDivi W-Win 
PROCEDURE EvtDivi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH EvtDivi WHERE EvtDivi.Codcia = S-CODCIA AND
                       EvtDivi.CodAno >=  w-perio AND
                       EvtDivi.CodAno <=  w-perio-2 AND
                       EvtDivi.CodMes >=  w-mes AND
                       EvtDivi.CodMes <=  w-mes-2 :
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EvtFpgo W-Win 
PROCEDURE EvtFpgo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
  editor-2 = "   Este proceso regenera las estadisticas de Venta en el  
  periodo establecido , Solo proceda cuando las estadisticas generadas 
  no son correctas.Antes de Aceptar Asegurese que todas las operaciones
  esten correctamente generados.".
  DISPLAY EDITOR-2 WITH FRAME {&FRAME-NAME}.
  ASSIGN
        w-fecha = today
        w-fecha-2 = Today.
  DISPLAY w-fecha w-fecha-2 WITH FRAME {&FRAME-NAME}.                  
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


