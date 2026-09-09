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

def var s-codcia as inte init 1.
def var s-nomcia as char init ''.
def var f-stkact as deci no-undo.
def var f-stkactcbd as deci no-undo.
def var f-stkgen as deci no-undo.
def var f-stkgencbd as deci no-undo.
def var f-vctomn as deci no-undo.
def var f-vctomncbd as deci no-undo.
def var f-vctome as deci no-undo.
def var f-vctomecbd as deci no-undo.
def var f-tctomn as deci no-undo.
def var f-tctome as deci no-undo.
def var f-pctomn as deci no-undo.
def var f-pctome as deci no-undo.

def buffer almdmov2 for almdmov.
def buffer almacen2 for almacen.
def buffer almcmov2 for almcmov.
def buffer ccbcdocu2 for ccbcdocu.

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
&Scoped-Define ENABLED-OBJECTS RECT-21 RECT-11 RECT-14 RECT-16 RECT-15 ~
DesdeC HastaC Btn_OK Btn_Cancel 
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
     RECT-11 AT ROW 1.54 COL 2.14
     "Articulo :" VIEW-AS TEXT
          SIZE 12.29 BY .5 AT ROW 3.54 COL 3.29
          FGCOLOR 9 FONT 0
     RECT-14 AT ROW 3.77 COL 2.29
     RECT-16 AT ROW 7.69 COL 1.86
     "Estado :":50 VIEW-AS TEXT
          SIZE 10.29 BY .5 AT ROW 7.5 COL 2.86
          FGCOLOR 9 FONT 0
     RECT-15 AT ROW 5.81 COL 2.14
     "Fecha:":40 VIEW-AS TEXT
          SIZE 8.72 BY .5 AT ROW 5.54 COL 3.14
          FGCOLOR 9 FONT 0
     "Compañia :":40 VIEW-AS TEXT
          SIZE 12.29 BY .5 AT ROW 1.35 COL 3.14
          FGCOLOR 9 FONT 0
     SPACE(48.14) SKIP(7.99)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Regeneracion de Costo y Stock por Compañia".


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
/* SETTINGS FOR FILL-IN i-fchdoc IN FRAME D-Dialog
   NO-ENABLE                                                            */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Regeneracion de Costo y Stock por Compañia */
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

  RUN Calculo_Costo_Promedio.
  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo_Costo_Promedio D-Dialog 
PROCEDURE Calculo_Costo_Promedio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
disable triggers for load of almcmov.
disable triggers for load of almdmov.
disable triggers for load of almmmate.


for each almmmatg where almmmatg.codcia = s-codcia
                    and almmmatg.codmat >= desdec
                    and almmmatg.codmat <= hastac
                    use-index matg01
                    no-lock:

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
                     
    for each almmmate where almmmate.codcia = s-codcia
                      and almmmate.codmat = almmmatg.codmat
                      use-index mate03:
        almmmate.stkact = 0.
    end.                  

    assign
        f-stkgen = 0
        f-stkgencbd = 0
        f-vctomn = 0
        f-vctomncbd = 0
        f-vctome = 0
        f-vctomecbd = 0.
        
    find last almstk where almstk.codcia = s-codcia
                       and almstk.codmat = almmmatg.codmat
                       and almstk.fchdoc  < i-fchdoc
                       use-index idx01
                       no-lock no-error.
    
    if avail almstk then
        assign
            f-stkgen = almstk.stkact
            f-stkgencbd = almstk.stkactcbd
            f-vctomn = almstk.vctomn1
            f-vctomncbd = almstk.vctomn1cbd
            f-vctome = almstk.vctomn2
            f-vctomecbd = almstk.vctomn2cbd.

    /***************Inicia Almdmov*************/         
    for each almdmov where almdmov.codcia = s-codcia
                       and almdmov.codmat = almmmatg.codmat
                       and almdmov.fchdoc >= i-fchdoc
                       use-index almd02: 
       display string(time,'hh:mm:ss') + ' ' + string(Almdmov.CodMat,'x(6)') + ' ' + string(Almdmov.fchdoc,'99/99/99') + ' ' + string(Almdmov.CodAlm,'x(3)') + ' ' + string(Almdmov.Tipmov,'x(1)') + ' ' + string(Almdmov.codmov,'99') + ' ' + string(Almdmov.nroser,'999') + '-' + string(Almdmov.nrodoc,'999999') @ FILL-IN-Proceso WITH FRAME {&FRAME-NAME}.
                
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

       if almdmov.fchdoc >= 12/22/2001 then do: 
           find almtconv where almtconv.codunid = almmmatg.undbas
                          and almtconv.codalter = almdmov.codund
                          no-lock no-error.
           if avail almtconv and almdmov.factor <> almtconv.equival then
                         almdmov.factor = almtconv.equival.
           if not avail almtconv then almdmov.factor = 1.
       end.                           

       if almdmov.tpocmb = 0 then do:
            find last gn-tcmb where  gn-tcmb.fecha <= almdmov.fchdoc
                              use-index cmb01 no-lock no-error.
            if avail gn-tcmb then do:
                if almdmov.tipmov = "i" then almdmov.tpocmb = gn-tcmb.venta.
                if almdmov.tipmov = "s" then almdmov.tpocmb = gn-tcmb.compra. 
            end.
       end.
                                
       f-candes = almdmov.candes * almdmov.factor.

       assign
           f-stkact = almsub.stksub
           f-stkactcbd = almsub.stksubcbd
           f-pctome = 0
           f-pctomn = 0
           f-tctomn = 0
           f-tctome = 0.

       find first almtmov of almdmov use-index mov01 no-lock no-error.

       /**********Inicia Bloque**********/
       if available almtmov and almtmov.tipmov = "I" then do:

            if almtmov.MovTrf then x-next = 0.

            if (almtmov.TpoCto = 0 OR almtmov.TpoCto = 1) then do:
                    if not almdmov.impcto > 0 and almdmov.preuni > 0 and almdmov.candes >= 0 then
                        almdmov.impcto = round(almdmov.preuni * almdmov.candes,m).
    
                    case almdmov.codmon:
                         when 1 then do:
                           if f-candes > 0 then f-pctomn = round(almdmov.impcto / f-candes,m).
                           if almdmov.tpocmb > 0 then f-pctome = round(f-pctomn / almdmov.tpocmb,m).
                         end.
                         when 2 then do:
                           if f-candes > 0 then f-pctome = round(almdmov.impcto / f-candes,m).
                           if almdmov.tpocmb > 0 then f-pctomn = round(f-pctome * almdmov.tpocmb,m).
                         end.
                    end.     
            end.


            if almtmov.TpoCto = 2 then do:
                assign
                almdmov.preuni = 0
                almdmov.impcto = 0.
    
                /***********inicia case********/
                case almdmov.codmov:    
        
                    when 09 then do:
                            find first almcmov2 of almdmov no-lock no-error.
                            find first almacen2 where almacen2.codcia = almcmov2.codcia 
                                                  and almacen2.codalm = almcmov2.codalm
                                                  no-lock no-error.
                            if avail almacen2 then find first ccbcdocu2 where ccbcdocu2.codcia = almcmov2.codcia
                                                                        and ccbcdocu2.coddiv = almacen2.coddiv
                                                                        and ccbcdocu2.coddoc = almcmov2.codref
                                                                        and ccbcdocu2.nrodoc = almcmov2.nroref
                                                                        use-index llave00 no-lock no-error.
                            if avail ccbcdocu2 then find first almdmov2 where almdmov2.codcia = ccbcdocu2.codcia
                                                                        and almdmov2.codalm = ccbcdocu2.codalm
                                                                        and almdmov2.tipmov = "s"
                                                                        and almdmov2.codmov = 02
                                                                        and almdmov2.nrodoc = integer(ccbcdocu2.nrosal)
                                                                        and almdmov2.codmat = almdmov.codmat
                                                                        use-index almd01 no-lock no-error.
                            if not avail ccbcdocu2 or  not avail almdmov2 or not avail almacen or (avail almdmov2 and almacen2.flgrep and almdmov2.vctomn1cbd * almdmov2.stkactcbd * almdmov2.vctomn2cbd > 0 ) then do:
                                find almdmov2 where rowid(almdmov2) = rowid(almdmov) no-lock no-error.
                                repeat: 
                                  find prev almdmov2 where almdmov2.codcia = almdmov.codcia
                                                     and almdmov2.codmat = almdmov.codmat
                                                     and almdmov2.fchdoc <= almdmov.fchdoc 
                                                     use-index almd02 no-lock no-error.
                                  if error-status:error then leave. 
                                  find first almacen2 of almdmov2 no-lock no-error.
                                  if error-status:error then next. 
                                  if almacen2.flgrep and almdmov2.vctomn1cbd * almdmov2.stkactcbd * almdmov2.vctomn2cbd > 0  then leave.
                               end.
                            end.   
                            if avail almdmov2 then
                                assign
                                f-pctomn = round(almdmov2.vctomn1cbd / almdmov2.stkactcbd,m)
                                f-pctome = round(almdmov2.vctomn2cbd / almdmov2.stkactcbd,m).
                    end.
            
                    when 10 then do:
                            find almdmov2 where rowid(almdmov2) = rowid(almdmov) 
                            no-lock no-error.
                            repeat: 
                                find prev almdmov2 where almdmov2.codcia = almdmov.codcia 
                                                   and almdmov2.codmat = almdmov.codmat
                                                   and almdmov2.fchdoc <= almdmov.fchdoc
                                                   and almdmov2.tipmov = "s"
                                                   and almdmov2.codmov = 10
                                                   use-index almd02 no-lock no-error.
                                if error-status:error then leave.
                                find first almacen2 of almdmov2 no-lock no-error.
                                if error-status:error then next.
                                if almacen2.flgrep and almdmov2.vctomn1cbd * almdmov2.stkactcbd * almdmov2.vctomn2cbd > 0 then leave.
                            end.
                            if not avail almdmov2 then do:
                                find almdmov2 where rowid(almdmov2) = rowid(almdmov) no-lock no-error.
                                repeat: 
                                find prev almdmov2 where almdmov2.codcia = almdmov.codcia
                                                   and almdmov2.codmat = almdmov.codmat
                                                   and almdmov2.fchdoc <= almdmov.fchdoc
                                                   use-index almd02 no-lock no-error.
                                  if error-status:error then leave.
                                  find first almacen2 of almdmov2 no-lock no-error.
                                  if error-status:error then next.
                                  if almacen2.flgrep and almdmov2.vctomn1cbd * almdmov2.stkactcbd * almdmov2.vctomn2cbd > 0  then leave.
                                end.
                            end.
                            if avail almdmov2 then
                                assign
                                f-pctomn = round(almdmov2.vctomn1cbd / almdmov2.stkactcbd,m)
                                f-pctome = round(almdmov2.vctomn2cbd / almdmov2.stkactcbd,m).
                    end.
                    otherwise 
                        do:
                                find almdmov2 where rowid(almdmov2) = rowid(almdmov) no-lock no-error.
                                repeat:
                                    find prev almdmov2 where almdmov2.codcia = almdmov.codcia
                                                       and almdmov2.codmat = almdmov.codmat
                                                       and almdmov2.fchdoc <= almdmov.fchdoc 
                                                       use-index almd02 no-lock no-error.
                                    if error-status:error then leave. 
                                    find first almacen2 of almdmov2 no-lock no-error.
                                    if error-status:error then next.
                                    if almacen2.flgrep and almdmov2.vctomn1cbd * almdmov2.stkactcbd * almdmov2.vctomn2cbd > 0 then leave.
                                end.
                                if avail almdmov2 then
                                    assign
                                    f-pctomn = round (almdmov2.vctomn1cbd / almdmov2.stkactcbd,m)
                                    f-pctome = round (almdmov2.vctomn2cbd / almdmov2.stkactcbd,m).
                        end.             
                end.        
                /*************fin case***************/  
                case almdmov.codmon:
                     when 1 then do:
                       almdmov.impcto = round(f-pctomn * f-candes ,m) .
                       almdmov.preuni = round(almdmov.impcto / almdmov.candes,m).
                     end.   
                     when 2 then do:
                       almdmov.impcto = round(f-pctome * f-candes ,m) .
                       almdmov.preuni = round(almdmov.impcto / almdmov.candes,m).
                     end.   
                end.     

            end.
        
       end.
       /*********Fin Bloque***********/
       
       if available almtmov and almtmov.TipMov = "S" then do:
            if almtmov.MovTrf then x-next = 0.       
                find almdmov2 where rowid(almdmov2) = rowid(almdmov) 
                no-lock no-error.
                repeat: 
                    find prev almdmov2 where almdmov2.codcia = almdmov.codcia 
                                       and almdmov2.codmat = almdmov.codmat
                                       and almdmov2.fchdoc <= almdmov.fchdoc
                                       use-index almd02 no-lock no-error.
                    if error-status:error then leave.
                    find first almacen2 of almdmov2 no-lock no-error.
                    if error-status:error then next.
                    if almacen2.flgrep and almdmov2.vctomn1cbd * almdmov2.stkactcbd * almdmov2.vctomn2cbd > 0 then leave.
                end.
                if avail almdmov2 then
                    assign
                    f-pctomn = round(almdmov2.vctomn1cbd / almdmov2.stkactcbd,m)
                    f-pctome = round(almdmov2.vctomn2cbd / almdmov2.stkactcbd,m).
       
        end.
        
        if almdmov.tipmov = "i" then x-indi = 1. 
                                else x-indi = -1.

        assign
        f-tctomn = f-pctomn * f-candes
        f-tctome = f-pctome * f-candes.
/*
        if almmmatg.catconta[1] = "CR" then
            assign
            f-tctomn = 0
            f-tctome = 0.
*/            

        assign
        f-stkgen = f-stkgen + x-indi * f-candes
        f-stkgencbd = f-stkgencbd + x-indi * x-next * f-candes
        f-stkact = f-stkact + x-indi * f-candes
        f-stkactcbd = f-stkactcbd + x-indi * x-next * f-candes
        f-vctomn = f-vctomn + x-indi * f-tctomn
        f-vctomncbd = f-vctomncbd + x-indi * x-next * f-tctomn
        f-vctome = f-vctome + x-indi * f-tctome
        f-vctomecbd = f-vctomecbd + x-indi * x-next * f-tctome.
             
        assign
        almdmov.stksub = f-stkact
        almdmov.stksubcbd = f-stkactcbd
        almdmov.stkact = f-stkgen
        almdmov.stkactcbd = f-stkgencbd
        almdmov.impmn1 = f-tctomn
        almdmov.impmn2 = f-tctome
        almdmov.vctomn1 = f-vctomn
        almdmov.vctomn1cbd = f-vctomncbd
        almdmov.vctomn2 = f-vctome
        almdmov.vctomn2cbd = f-vctomecbd.
        
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
        almsub.stkact = f-stkgen
        almsub.stkactcbd = f-stkgencbd
        almsub.vctomn1 = f-vctomn
        almsub.vctomn1cbd = f-vctomncbd
        almsub.vctomn2 = f-vctome
        almsub.vctomn2cbd = f-vctomecbd
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
        almstk.vctomn1 = f-vctomn
        almstk.vctomn1cbd = f-vctomncbd
        almstk.vctomn2 = f-vctome
        almstk.vctomn2cbd = f-vctomecbd
        almstk.inffch = today
        almstk.infhra = time
        almstk.infusr = string(userid("integral")).
    end.

    /*****************Fin Almdmov**************/

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
        
    pause 0.

end.

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
  ENABLE RECT-21 RECT-11 RECT-14 RECT-16 RECT-15 DesdeC HastaC Btn_OK 
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
  
  MESSAGE 'Al ejecutar este proceso tenga presente lo siguiente:' skip
          '1. Este proceso causa excesiva congestión al SIE' skip
          '2. Ejecutesé sobre algunos articulos, no todos.' skip
          '3. La interrupcion de este proceso puede causar daños en los stocks.' skip
          '4. Si requiere procesar todos los articulos, solicitelo a Informática.' skip
          '5. Los usuarios que incumplan estas observaciones seran reportados a las áreas afectadas.' skip
          skip
          '                                                               INFORMATICA'
          view-as alert-box information  
          title 'IMPORTANTE. LEASÉ ANTES DE CONTINUAR'.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  find first gn-cias where GN-CIAS.CodCia = S-CodCia
                       no-lock no-error.
  if avail gn-cias then s-nomcia = GN-CIAS.NomCia.                     

 /* FIND LAST Almcierr WHERE Almcierr.Codcia = S-CODCIA AND
                           Almcierr.FlgCie
                           NO-LOCK NO-ERROR.
                      
  IF AVAILABLE Almcierr THEN i-fchdoc = Almcierr.FchCie + 1.   */

  IF i-fchdoc = ? THEN i-fchdoc = DATE(01,01,YEAR(TODAY)).
    
  DISPLAY S-CODCIA @ FILL-IN-CodAlm  
          S-NOMCIA @ FILL-IN-DesAlm 
          i-fchdoc @ i-fchdoc 
           WITH FRAME {&FRAME-NAME}.


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


