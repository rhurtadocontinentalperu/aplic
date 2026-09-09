&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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
DEFINE NEW SHARED VARIABLE lh_Handle  AS HANDLE.

/*DEFINE SHARED VAR S-CODCIA AS INTEGER.
 * DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
 * DEFINE SHARED VAR S-CODALM AS CHARACTER.
 * DEFINE SHARED VAR S-DESALM AS CHARACTER.
 * DEFINE VAR F-STKACT AS DECIMAL NO-UNDO.
 * DEFINE VAR F-CANDES AS DECIMAL NO-UNDO.
 * DEFINE BUFFER MATE FOR Almmmate.*/

def shared var s-codcia as inte.
def shared var s-nomcia as char.
def shared var s-codalm as char.
def shared var s-desalm as char.

def var f-stkact as deci no-undo.
def var f-stkgen as deci no-undo.
def var f-stkactcbd as deci no-undo.
def var f-stkgencbd as deci no-undo.
def var f-candes as deci no-undo.
def var x-next as inte init 1.
def var x-indi as deci no-undo.
def var m as integer init 5.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-21 RECT-11 RECT-14 RECT-15 RECT-16 ~
DesdeC i-fchdoc HastaC Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-CodAlm FILL-IN-Proceso ~
FILL-IN-DesAlm DesdeC i-fchdoc HastaC 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     IMAGE-UP FILE "img\b-cancel":U
     LABEL "Cancelar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     IMAGE-UP FILE "img\b-ok":U
     LABEL "Aceptar" 
     SIZE 11 BY 1.5
     BGCOLOR 8 .

DEFINE VARIABLE DesdeC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Desde" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE FILL-IN-CodAlm AS CHARACTER FORMAT "X(3)":U 
     VIEW-AS FILL-IN 
     SIZE 6 BY .81
     FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-DesAlm AS CHARACTER FORMAT "X(300)":U 
     VIEW-AS FILL-IN 
     SIZE 37.29 BY .81
     FGCOLOR 12 FONT 0 NO-UNDO.

DEFINE VARIABLE FILL-IN-Proceso AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58.86 BY .92
     BGCOLOR 9 FGCOLOR 15 FONT 0 NO-UNDO.

DEFINE VARIABLE HastaC AS CHARACTER FORMAT "X(6)":U 
     LABEL "Hasta" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .81 NO-UNDO.

DEFINE VARIABLE i-fchdoc AS DATE FORMAT "99/99/9999":U 
     LABEL "Inicio" 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .81.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44.86 BY 1.73.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44.86 BY 1.62.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45 BY 1.46.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 61.14 BY 1.62.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 62.14 BY 8.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     FILL-IN-CodAlm AT ROW 2.08 COL 1.14 COLON-ALIGNED NO-LABEL
     FILL-IN-Proceso AT ROW 8.12 COL 3.43 NO-LABEL
     FILL-IN-DesAlm AT ROW 2.08 COL 7.14 COLON-ALIGNED NO-LABEL
     DesdeC AT ROW 4.27 COL 10.86 COLON-ALIGNED
     i-fchdoc AT ROW 6.12 COL 10.72 COLON-ALIGNED
     HastaC AT ROW 4.27 COL 27.57 COLON-ALIGNED
     Btn_OK AT ROW 2.15 COL 49
     Btn_Cancel AT ROW 4.96 COL 49.29
     RECT-21 AT ROW 1.23 COL 1.43
     "Compañia :":40 VIEW-AS TEXT
          SIZE 12.29 BY .5 AT ROW 1.35 COL 3.14
          FGCOLOR 9 FONT 0
     RECT-11 AT ROW 1.54 COL 2.14
     "Articulo :" VIEW-AS TEXT
          SIZE 12.29 BY .5 AT ROW 3.54 COL 3.29
          FGCOLOR 9 FONT 0
     RECT-14 AT ROW 3.77 COL 2.29
     "Fecha:":40 VIEW-AS TEXT
          SIZE 8.72 BY .5 AT ROW 5.54 COL 3.14
          FGCOLOR 9 FONT 0
     RECT-15 AT ROW 5.81 COL 2.14
     "Estado :":50 VIEW-AS TEXT
          SIZE 10.29 BY .5 AT ROW 7.5 COL 2.86
          FGCOLOR 9 FONT 0
     RECT-16 AT ROW 7.69 COL 1.86
     SPACE(0.57) SKIP(0.53)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Regeneracion de Estadisticas de Venta por Compañia".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
                                                                        */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-CodAlm IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-DesAlm IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-Proceso IN FRAME D-Dialog
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{src/adm-vm/method/vmviewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Regeneracion de Estadisticas de Venta por Compañia */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK D-Dialog
ON CHOOSE OF Btn_OK IN FRAME D-Dialog /* Aceptar */
DO:
  ASSIGN DesdeC HastaC i-fchdoc.
  RUN Calculo-por-Cia.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DesdeC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DesdeC D-Dialog
ON LEAVE OF DesdeC IN FRAME D-Dialog /* Desde */
do:
  if input desdec:screen-value = '' then do:
      find first almmmatg where almmmatg.codcia = s-codcia
                          use-index matg01
                          no-lock no-error.
      if avail almmmatg then desdec:screen-value = almmmatg.codmat.
  end.    
  desdec:screen-value = string(integer(desdec:screen-value),'999999').
  find first almmmatg where almmmatg.codcia = s-codcia
                        and almmmatg.codmat = desdec:screen-value
                        no-lock no-error.
  if not avail almmmatg then do:
      message "Artículo no existe en el catalogo" view-as alert-box error.
      return no-apply.
  end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME HastaC
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL HastaC D-Dialog
ON LEAVE OF HastaC IN FRAME D-Dialog /* Hasta */
do:
  if input hastac:screen-value = '' then do:
      find last almmmatg where almmmatg.codcia = s-codcia
                         use-index matg01
                         no-lock no-error.
      if avail almmmatg then hastac:screen-value = almmmatg.codmat.
  end.    
  hastac:screen-value = string(integer(hastac:screen-value),'999999').
  find first almmmatg where almmmatg.codcia = s-codcia
                        and almmmatg.codmat = hastac:screen-value
                        no-lock no-error.
  if not avail almmmatg then do:
      message "Artículo no existe en el catalogo" view-as alert-box error.
      return no-apply.
  end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-fchdoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-fchdoc D-Dialog
ON LEAVE OF i-fchdoc IN FRAME D-Dialog /* Inicio */
do:
  if input i-fchdoc:screen-value = '' or  input i-fchdoc:screen-value = ? then do:
    i-fchdoc:screen-value = string(today).
  end.  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo-por-Almacen D-Dialog 
PROCEDURE Calculo-por-Almacen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
for each almmmatg where almmmatg.codcia = s-codcia
                    and almmmatg.codmat >= desdec
                    and almmmatg.codmat <= hastac
                    use-index matg01
                    no-lock :
/* if not almmmatg.tpoart = 'a' then do:*/

    for each almstk where almstk.codcia = s-codcia
                      and almstk.codmat = almmmatg.codmat
                      and fchdoc >= i-fchdoc
                      use-index idx01:
        delete almstk.
    end.

    for each almsub where almsub.codcia = s-codcia
                      and almsub.codmat = almmmatg.codmat
                      and almsub.fchdoc >= i-fchdoc
                      use-index idx02:
        delete almsub.
    end.                  

    assign
        f-stkgen = 0
        f-stkgencbd = 0.
        
    find last almstk where almstk.codcia = s-codcia
                       and almstk.codmat = almmmatg.codmat
                       and almstk.fchdoc  < i-fchdoc
                       use-index idx01
                       no-lock no-error.
    
    if avail almstk then
        assign
            f-stkgen = almstk.stkact
            f-stkgencbd = almstk.stkactcbd.
             
    for each almdmov where almdmov.codcia = s-codcia
                       and almdmov.codmat = almmmatg.codmat
                       and almdmov.fchdoc >= i-fchdoc
                       use-index almd02:     
       display string(time,'hh:mm:ss') + ' ' + string(Almdmov.CodMat,'x(6)') + ' ' + string(Almdmov.fchdoc,'99/99/99') + ' ' + string(Almdmov.CodAlm,'x(3)') + ' ' + string(Almdmov.Tipmov,'x(1)') + ' ' + string(Almdmov.codmov,'99') + ' ' + string(Almdmov.nrodoc,'999999') @ FILL-IN-Proceso WITH FRAME {&FRAME-NAME}.

       x-next = 1.
       find first almacen where almacen.codcia = almdmov.codcia
                          and almacen.codalm = almdmov.codalm  
                          use-index alm01 no-lock no-error.
       if avail almacen and not almacen.flgrep then x-next = 0.
       find first almcmov of almdmov no-lock no-error.
       
       find last almsub where almsub.codcia = almdmov.codcia
                          and almsub.codalm = almdmov.codalm
                          and almsub.codmat = almdmov.codmat
                          and almsub.fchdoc <= almdmov.fchdoc
                          use-index idx01
                          no-lock no-error.
                           
       if not avail almsub then do:
            create almsub.
            assign
                almsub.codcia = almdmov.codcia
                almsub.codalm = almdmov.codalm
                almsub.codmat = almdmov.codmat
                almsub.fchdoc = almdmov.fchdoc
                almsub.stksub = 0
                almsub.stksubcbd = 0.
       end.
       
/*       find almtconv where almtconv.codunid = almmmatg.undbas
 *                      and almtconv.codalter = almdmov.codund
 *                      no-lock no-error.
 *        if avail almtconv and almdmov.factor <> almtconv.equival then
 *                     almdmov.factor = almtconv.equival.
 *        if not avail almtconv then almdmov.factor = 1. */

       if almdmov.tpocmb = 0 then do:
            find last gn-tcmb where  gn-tcmb.fecha <= almdmov.fchdoc
                              use-index cmb01 no-lock no-error.
            if avail gn-tcmb then do:
                if almdmov.tipmov = "i" then almdmov.tpocmb = gn-tcmb.venta.
                if almdmov.tipmov = "s" then almdmov.tpocmb = gn-tcmb.compra. 
            end.
       end.
                                
/*       if avail almcmov and almcmov.fchdoc <> almdmov.fchdoc then
 *             almdmov.fchdoc = almcmov.fchdoc.*/

/*       if not almdmov.candes >= 0 then almdmov.candes = 0.*/

       f-candes = almdmov.candes * almdmov.factor.

       assign
            f-stkact = almsub.stksub
            f-stkactcbd = almsub.stksubcbd.

       find first almtmov of almdmov use-index mov01 no-lock no-error.


        if almdmov.tipmov = "i" then x-indi = 1. 
                                else x-indi = -1.
                                
        assign
        f-stkgen = f-stkgen + x-indi * f-candes
        f-stkact = f-stkact + x-indi * f-candes
        f-stkgencbd = f-stkgencbd + x-indi * x-next * f-candes
        f-stkactcbd = f-stkactcbd + x-indi * x-next * f-candes.
             
        assign
        almdmov.stksub = f-stkact
        almdmov.stkact = f-stkgen
        almdmov.stksubcbd = f-stkactcbd
        almdmov.stkactcbd = f-stkgencbd.
        
        find first almsub where almsub.codcia = almdmov.codcia
                            and almsub.codalm = almdmov.codalm
                            and almsub.codmat = almdmov.codmat
                            and almsub.fchdoc = almdmov.fchdoc
                            no-error.
        if not avail almsub then do:
            create almsub.
            assign
            almsub.codcia = almdmov.codcia
            almsub.codalm = almdmov.codalm
            almsub.codmat = almdmov.codmat
            almsub.fchdoc = almdmov.fchdoc.
        end.
        
        assign
        almsub.stksub = f-stkact
        almsub.stksubcbd = f-stkactcbd
        almsub.inffch = today
        almsub.infhra = time
        almsub.infusr = string(userid("integral")).
        
        find first almstk where almstk.codcia = almdmov.codcia
                            and almstk.codmat = almdmov.codmat
                            and almstk.fchdoc = almdmov.fchdoc
                            no-error.
        
        if not avail almstk then do:
            create almstk.
            assign
            almstk.codcia = almdmov.codcia
            almstk.codmat = almdmov.codmat
            almstk.fchdoc = almdmov.fchdoc.
        end.
        
        assign
        almstk.stkact = f-stkgen
        almstk.stkactcbd = f-stkgencbd
        almstk.inffch = today
        almstk.infhra = time
        almstk.infusr = string(userid("integral")).
    end.
    
    for each almacen where almacen.codcia = s-codcia:
        find last almsub where almsub.codcia = almacen.codcia
                           and almsub.codalm = almacen.codalm
                           and almsub.codmat = almmmatg.codmat
                           use-index idx01
                           no-lock no-error.
        
        if avail almsub then do:
            find first almmmate where almmmate.codcia = almacen.codcia
                                  and almmmate.codalm = almacen.codalm
                                  and almmmate.codmat = almmmatg.codmat
                                  use-index mate01
                                  no-error.
            if not avail almmmate then do:
                create almmmate.
                assign
                almmmate.codcia = almacen.codcia
                almmmate.codalm = almacen.codalm
                almmmate.codmat = almmmatg.codmat
                almmmate.desmat = almmmatg.desmat
                almmmate.undvta = almmmatg.undstk
                almmmate.facequ = 1.
            end.
            assign
            almmmate.stkact = almsub.stksub
            almmmate.stkactcbd = almsub.stksubcbd.
        end.                   
    end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo-por-cia D-Dialog 
PROCEDURE Calculo-por-cia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   Define var x-signo1 as integer init 1.
   Define var x-fin    as integer init 0.
   Define var f-factor as deci    init 0.


   FOR EACH EvtDivi WHERE EvtDivi.Codcia = S-CODCIA :
       DELETE EvtDivi.
   END.
   FOR EACH EvtArti WHERE EvtArti.Codcia = S-CODCIA :
       DELETE EvtArti.
   END.

   FOR EACH EvtClie WHERE EvtClie.Codcia = S-CODCIA :
       DELETE EvtClie.
   END.

   FOR EACH EvtFpgo WHERE EvtFpgo.Codcia = S-CODCIA :
       DELETE EvtFpgo.
   END.

   FOR EACH EvtVend WHERE EvtVend.Codcia = S-CODCIA :
       DELETE EvtVend.
   END.

   FOR EACH CcbCdocu WHERE CcbCdocu.CodCia = S-CODCIA NO-LOCK:
     
       IF Lookup(CcbCDocu.CodDoc,"FAC,BOL,N/C,N/D") = 0 THEN NEXT.
       IF CcbCDocu.FlgEst = "A"  THEN NEXT.
       x-signo1 = IF Ccbcdocu.Coddoc = "N/C" THEN -1 ELSE 1.

      /**************** INICIA DIVISION *******************/
       FIND EvtDivi WHERE EvtDivi.Codcia = Ccbcdocu.Codcia AND
                          EvtDivi.CodDiv = Ccbcdocu.Coddiv AND
                          EvtDivi.CodAno = YEAR(Ccbcdocu.FchDoc) AND
                          EvtDivi.CodMes = MONTH(Ccbcdocu.FchDoc) NO-ERROR.
       IF NOT AVAILABLE EvtDivi THEN DO:
         CREATE EvtDivi.
         ASSIGN
         EvtDivi.Codcia = Ccbcdocu.Codcia 
         EvtDivi.CodDiv = Ccbcdocu.Coddiv 
         EvtDivi.CodAno = YEAR(Ccbcdocu.FchDoc) 
         EvtDivi.CodMes = MONTH(Ccbcdocu.FchDoc)
         EvtDivi.Nrofch = INTEGER(STRING(YEAR(Ccbcdocu.FchDoc),"9999") + STRING(MONTH(Ccbcdocu.FchDoc),"99"))  .
       END.                    
       IF Ccbcdocu.CodMon = 1 THEN EvtDivi.VtaxDiaMn[DAY(Ccbcdocu.FchDoc)] = EvtDivi.VtaxDiaMn[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpTot).
       IF Ccbcdocu.CodMon = 2 THEN EvtDivi.VtaxDiaMe[DAY(Ccbcdocu.FchDoc)] = EvtDivi.VtaxDiaMe[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpTot).
       IF Ccbcdocu.CodMon = 1 THEN EvtDivi.CtoxDiaMn[DAY(Ccbcdocu.FchDoc)] = EvtDivi.CtoxDiaMn[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpCto).
       IF Ccbcdocu.CodMon = 2 THEN EvtDivi.CtoxDiaMe[DAY(Ccbcdocu.FchDoc)] = EvtDivi.CtoxDiaMe[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpCto).
       /**************** FIN DIVISION *******************/

       /**************** INICIA CLIENTE  *******************/
       FIND EvtClie WHERE EvtClie.Codcia = Ccbcdocu.Codcia AND
                          EvtClie.CodDiv = Ccbcdocu.Coddiv AND
                          EvtClie.CodAno = YEAR(Ccbcdocu.FchDoc) AND
                          EvtClie.CodMes = MONTH(Ccbcdocu.FchDoc) AND
                          EvtClie.Codcli = Ccbcdocu.Codcli NO-ERROR.
   
       IF NOT AVAILABLE EvtClie THEN DO:
        CREATE EvtClie.
        ASSIGN
        EvtClie.Codcia = Ccbcdocu.Codcia 
        EvtClie.CodDiv = Ccbcdocu.Coddiv 
        EvtClie.CodAno = YEAR(Ccbcdocu.FchDoc) 
        EvtClie.CodMes = MONTH(Ccbcdocu.FchDoc)
        EvtClie.Codcli = Ccbcdocu.Codcli
        EvtClie.Nrofch = INTEGER(STRING(YEAR(Ccbcdocu.FchDoc),"9999") + STRING(MONTH(Ccbcdocu.FchDoc),"99"))  .
       END.                   
       IF Ccbcdocu.CodMon = 1 THEN EvtClie.VtaxDiaMn[DAY(Ccbcdocu.FchDoc)] = EvtClie.VtaxDiaMn[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpTot).
       IF Ccbcdocu.CodMon = 2 THEN EvtClie.VtaxDiaMe[DAY(Ccbcdocu.FchDoc)] = EvtClie.VtaxDiaMe[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpTot).
       IF Ccbcdocu.CodMon = 1 THEN EvtClie.CtoxDiaMn[DAY(Ccbcdocu.FchDoc)] = EvtClie.CtoxDiaMn[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpCto).
       IF Ccbcdocu.CodMon = 2 THEN EvtClie.CtoxDiaMe[DAY(Ccbcdocu.FchDoc)] = EvtClie.CtoxDiaMe[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpCto).
       /**************** FIN CLIENTE  *******************/
 
       /*********INICIA FORMA DE PAGO************/
        FIND EvtFpgo WHERE EvtFpgo.Codcia = Ccbcdocu.Codcia AND
                           EvtFpgo.CodDiv = Ccbcdocu.Coddiv AND
                           EvtFpgo.CodAno = YEAR(Ccbcdocu.FchDoc) AND
                           EvtFpgo.CodMes = MONTH(Ccbcdocu.FchDoc) AND
                           EvtFpgo.FmaPgo = Ccbcdocu.FmaPgo NO-ERROR.
   
       IF NOT AVAILABLE EvtFpgo THEN DO:
        CREATE EvtFpgo.
        ASSIGN
        EvtFpgo.Codcia = Ccbcdocu.Codcia 
        EvtFpgo.CodDiv = Ccbcdocu.Coddiv 
        EvtFpgo.CodAno = YEAR(Ccbcdocu.FchDoc) 
        EvtFpgo.CodMes = MONTH(Ccbcdocu.FchDoc)
        EvtFpgo.Nrofch = INTEGER(STRING(YEAR(Ccbcdocu.FchDoc),"9999") + STRING(MONTH(Ccbcdocu.FchDoc),"99"))
        EvtFpgo.FmaPgo = Ccbcdocu.FmaPgo.
       END.                    
       IF Ccbcdocu.CodMon = 1 THEN EvtFpgo.VtaxDiaMn[DAY(Ccbcdocu.FchDoc)] = EvtFpgo.VtaxDiaMn[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpTot).
       IF Ccbcdocu.CodMon = 2 THEN EvtFpgo.VtaxDiaMe[DAY(Ccbcdocu.FchDoc)] = EvtFpgo.VtaxDiaMe[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpTot).
       IF Ccbcdocu.CodMon = 1 THEN EvtFpgo.CtoxDiaMn[DAY(Ccbcdocu.FchDoc)] = EvtFpgo.CtoxDiaMn[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpCto).
       IF Ccbcdocu.CodMon = 2 THEN EvtFpgo.CtoxDiaMe[DAY(Ccbcdocu.FchDoc)] = EvtFpgo.CtoxDiaMe[DAY(Ccbcdocu.FchDoc)] + ( x-signo1 * Ccbcdocu.ImpCto).
       /*********FIN FORMA DE PAGO************/
 
 
 
 



      FOR EACH CcbDdocu OF CcbCdocu NO-LOCK:
          
          FIND Almmmatg WHERE Almmmatg.Codcia = CcbdDocu.Codcia AND
                              Almmmatg.CodMat = CcbdDocu.CodMat NO-LOCK NO-ERROR.

          IF NOT AVAILABLE Almmmatg THEN NEXT.

          FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                              Almtconv.Codalter = Ccbddocu.UndVta
                              NO-LOCK NO-ERROR.
  
          F-FACTOR  = 1. 
      
          IF AVAILABLE Almtconv THEN DO:
             F-FACTOR = Almtconv.Equival.
             IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
          END.
          
          

         /*********INICIA ARTICULOS************/          
          FIND EvtArti WHERE EvtArti.Codcia = CcbdDocu.Codcia AND
                             EvtArti.CodDiv = CcbdDocu.Coddiv AND
                             EvtArti.CodAno = YEAR(CcbdDocu.FchDoc) AND
                             EvtArti.CodMes = MONTH(CcbdDocu.FchDoc) AND
                             EvtArti.CodMat = CcbdDocu.CodMat NO-ERROR.     

          IF NOT AVAILABLE EvtArti THEN DO:
           CREATE EvtArti.
           ASSIGN
           EvtArti.Codcia = Ccbddocu.Codcia 
           EvtArti.CodDiv = Ccbddocu.Coddiv 
           EvtArti.CodAno = YEAR(Ccbddocu.FchDoc) 
           EvtArti.CodMes = MONTH(Ccbddocu.FchDoc)
           EvtArti.Nrofch = INTEGER(STRING(YEAR(Ccbddocu.FchDoc),"9999") + STRING(MONTH(Ccbddocu.FchDoc),"99")) 
           EvtArti.CodMat = Ccbddocu.CodMat.            
          END.                    
          IF Ccbcdocu.CodMon = 1 THEN EvtArti.VtaxDiaMn[DAY(CcbdDocu.FchDoc)] = EvtArti.VtaxDiaMn[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.ImpLin).
          IF Ccbcdocu.CodMon = 2 THEN EvtArti.VtaxDiaMe[DAY(CcbdDocu.FchDoc)] = EvtArti.VtaxDiaMe[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.ImpLin).
          IF Ccbcdocu.CodMon = 1 THEN EvtArti.CtoxDiaMn[DAY(CcbdDocu.FchDoc)] = EvtArti.CtoxDiaMn[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.ImpCto).
          IF Ccbcdocu.CodMon = 2 THEN EvtArti.CtoxDiaMe[DAY(CcbdDocu.FchDoc)] = EvtArti.CtoxDiaMe[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.ImpCto).
          EvtArti.CanxDia[DAY(CcbdDocu.FchDoc)] = EvtArti.CanxDia[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.CanDes * F-FACTOR ).
         /*********FIN ARTICULOS************/
          
         /*********Para Articulos Por Vendedor*************/
         FIND EvtVend WHERE EvtVend.Codcia = CcbdDocu.Codcia AND
                            EvtVend.CodDiv = CcbdDocu.Coddiv AND
                            EvtVend.CodAno = YEAR(CcbdDocu.FchDoc) AND
                            EvtVend.CodMes = MONTH(CcbdDocu.FchDoc) AND
                            EvtVend.CodVen = CcbcDocu.CodVen /*AND
                            EvtVend.CodMat = CcbdDocu.CodMat */ NO-ERROR.
     
         IF NOT AVAILABLE EvtVend THEN DO:
            CREATE EvtVend.
            ASSIGN
            EvtVend.Codcia = Ccbddocu.Codcia 
            EvtVend.CodDiv = Ccbddocu.Coddiv 
            EvtVend.CodAno = YEAR(Ccbddocu.FchDoc) 
            EvtVend.CodMes = MONTH(Ccbddocu.FchDoc)
            EvtVend.Nrofch = INTEGER(STRING(YEAR(Ccbddocu.FchDoc),"9999") + STRING(MONTH(Ccbddocu.FchDoc),"99")) 
            EvtVend.CodVen = Ccbcdocu.CodVen /*            
            EvtVend.CodMat = Ccbddocu.CodMat*/.            
         END.                    
         IF Ccbcdocu.CodMon = 1 THEN EvtVend.VtaxDiaMn[DAY(CcbdDocu.FchDoc)] = EvtVend.VtaxDiaMn[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.ImpLin).
         IF Ccbcdocu.CodMon = 2 THEN EvtVend.VtaxDiaMe[DAY(CcbdDocu.FchDoc)] = EvtVend.VtaxDiaMe[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.ImpLin).
         IF Ccbcdocu.CodMon = 1 THEN EvtVend.CtoxDiaMn[DAY(CcbdDocu.FchDoc)] = EvtVend.CtoxDiaMn[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.ImpCto).
         IF Ccbcdocu.CodMon = 2 THEN EvtVend.CtoxDiaMe[DAY(CcbdDocu.FchDoc)] = EvtVend.CtoxDiaMe[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.ImpCto).
     /*  EvtVend.CanxDia[DAY(CcbdDocu.FchDoc)] = EvtVend.CanxDia[DAY(CcbdDocu.FchDoc)] + ( x-signo1 * CcbdDocu.CanDes * F-FACTOR ).*/
         /*************************************************/
        

      END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-CodAlm FILL-IN-Proceso FILL-IN-DesAlm DesdeC i-fchdoc HastaC 
      WITH FRAME D-Dialog.
  ENABLE RECT-21 RECT-11 RECT-14 RECT-15 RECT-16 DesdeC i-fchdoc HastaC Btn_OK 
         Btn_Cancel 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  DISPLAY S-CODCIA @ FILL-IN-CodAlm  
          S-NOMCIA @ FILL-IN-DesAlm WITH FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Procesa-Parametros D-Dialog 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recoge-Parametros D-Dialog 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
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


