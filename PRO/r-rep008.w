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

{src/bin/_prns.i}   /* Para la impresion */

/* Parameters Definitions ---                                           */
DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR pv-CODCIA  AS INTEGER.
DEFINE SHARED VAR S-NOMCIA  AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHARACTER.
DEFINE STREAM Reporte.
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE X-DESPRO AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE X-DESART AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE X-DESPER AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE X-NOMPRO AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE X-NOMGAS AS CHARACTER FORMAT "X(50)".
DEFINE VARIABLE X-TOTAL AS DECI INIT 0.
DEFINE VARIABLE X-CODMON AS CHAR .

DEFINE VARIABLE X-UNIMAT AS DECI FORMAT "->>>>>>9.9999".
DEFINE VARIABLE X-UNIHOR AS DECI FORMAT "->>>>>>9.9999".
DEFINE VARIABLE X-UNISER AS DECI FORMAT "->>>>>>9.9999".
DEFINE VARIABLE X-UNIFAB AS DECI FORMAT "->>>>>>9.9999".

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
&Scoped-Define ENABLED-OBJECTS txt-desde txt-hasta BUTTON-7 BUTTON-8 
&Scoped-Define DISPLAYED-OBJECTS txt-desde txt-hasta 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-7 
     IMAGE-UP FILE "img/print (2).ico":U
     LABEL "Button 7" 
     SIZE 9 BY 1.62.

DEFINE BUTTON BUTTON-8 
     IMAGE-UP FILE "img/exit.ico":U
     LABEL "Button 8" 
     SIZE 9 BY 1.62.

DEFINE VARIABLE txt-desde AS CHARACTER FORMAT "X(6)":U 
     LABEL "Nro. Liquidacion (desde)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE txt-hasta AS CHARACTER FORMAT "X(6)":U 
     LABEL "Nro. Liquidacion (Hasta)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     txt-desde AT ROW 2.08 COL 26 COLON-ALIGNED WIDGET-ID 2
     txt-hasta AT ROW 3.15 COL 26 COLON-ALIGNED WIDGET-ID 4
     BUTTON-7 AT ROW 4.5 COL 45 WIDGET-ID 6
     BUTTON-8 AT ROW 4.5 COL 55 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 65.72 BY 5.92 WIDGET-ID 100.


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
         TITLE              = "Impresion de Liquidaciones"
         HEIGHT             = 5.92
         WIDTH              = 65.72
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 80
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartWindowCues" W-Win _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartWindow,ab,49271
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Impresion de Liquidaciones */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Impresion de Liquidaciones */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-Main
&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 W-Win
ON CHOOSE OF BUTTON-7 IN FRAME F-Main /* Button 7 */
DO:
  
    ASSIGN txt-desde txt-hasta.
    RUN imprimir.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-8 W-Win
ON CHOOSE OF BUTTON-8 IN FRAME F-Main /* Button 8 */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
  
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
  DISPLAY txt-desde txt-hasta 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE txt-desde txt-hasta BUTTON-7 BUTTON-8 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Formato W-Win 
PROCEDURE Formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE FRAME F-Deta
         PR-LIQCX.CodArt  COLUMN-LABEL "Articulo"         
         Almmmatg.DesMat   FORMAT "X(45)" COLUMN-LABEL "Descripcion"
         Almmmatg.Desmar   FORMAT "X(15)" COLUMN-LABEL "Marca"
         PR-LIQCX.CodUnd   FORMAT "X(6)"  COLUMN-LABEL "Unidad"
         PR-LIQCX.CanFin   COLUMN-LABEL "Cantidad!Procesada"
         PR-LIQCX.PreUni   COLUMN-LABEL "Precio!Unitario"
         PR-LIQCX.CtoTot   COLUMN-LABEL "Importe!Total"
         WITH NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  DEFINE FRAME F-Deta1
         PR-LIQD1.codmat COLUMN-LABEL "Articulo"         
         Almmmatg.DesMat   FORMAT "X(45)" COLUMN-LABEL "Descripcion"
         Almmmatg.Desmar   FORMAT "X(15)" COLUMN-LABEL "Marca"
         PR-LIQD1.CodUnd   FORMAT "X(6)"  COLUMN-LABEL "Unidad"
         PR-LIQD1.CanDes   COLUMN-LABEL "Cantidad!Procesada"
         PR-LIQD1.PreUni   COLUMN-LABEL "Precio!Unitario"
         PR-LIQD1.ImpTot   COLUMN-LABEL "Importe!Total"
         WITH NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  DEFINE FRAME F-Deta2
         PR-LIQD2.codper  COLUMN-LABEL "Codigo"
         X-DESPER         COLUMN-LABEL "Nombre"
         PR-LIQD2.Horas   COLUMN-LABEL "Horas!Laboradas" FORMAT ">>>9.99"
         PR-LIQD2.HorVal  COLUMN-LABEL "Importe!Total"
         WITH  NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  DEFINE FRAME F-Deta3
         PR-LIQD3.codPro  COLUMN-LABEL "Codigo!Proveedor"
         X-NOMPRO         COLUMN-LABEL "Nombre o Razon Social"
         PR-LIQD3.CodGas  COLUMN-LABEL "Codigo!Gas/Ser"
         X-NOMGAS         COLUMN-LABEL "Descripcion"
         PR-LIQD3.ImpTot  COLUMN-LABEL "Importe!Total"
         WITH  NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  DEFINE FRAME F-Deta4
         PR-LIQD4.codmat COLUMN-LABEL "Articulo"         
         Almmmatg.DesMat   FORMAT "X(45)" COLUMN-LABEL "Descripcion"
         Almmmatg.Desmar   FORMAT "X(15)" COLUMN-LABEL "Marca"
         PR-LIQD4.CodUnd   FORMAT "X(6)"  COLUMN-LABEL "Unidad"
         PR-LIQD4.CanDes   COLUMN-LABEL "Cantidad!Obtenida"
         WITH NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  DEFINE FRAME F-Orden
         HEADER
         S-NOMCIA FORMAT "X(25)" 
         "LIQUIDACION DE ORDEN DE PRODUCCION" AT 30 FORMAT "X(45)"
         "LIQUIDACION No. : " AT 80 PR-LIQC.NumLiq AT 100 SKIP
         "ORDEN       No. : " AT 80 PR-LIQC.Numord AT 100 SKIP
         "Fecha Emision   : "   AT 80 PR-LIQC.FchLiq FORMAT "99/99/9999" AT 100 SKIP
         "Periodo Liquidado : "  PR-LIQC.FecIni FORMAT "99/99/9999" " Al " PR-LIQC.FecFin FORMAT "99/99/9999" 
         "Moneda          : " AT 80 X-CODMON AT 100 SKIP
         "Articulo      : " /*PR-LIQC.CodArt  X-DESART  */
         "Tipo/Cambio   : " AT 80 PR-LIQC.TpoCmb AT 100 SKIP
         "Cantidad      : " PR-LIQC.CanFin PR-LIQC.CodUnd SKIP
         "Costo Material: " PR-LIQC.CtoMat 
         "Costo Uni Material      : " AT 60 X-UNIMAT AT 90 SKIP
         "Mano/Obra Dire: " PR-LIQC.CtoHor 
         "Costo Uni Mano/Obra Dire: " AT 60 X-UNIHOR AT 90 SKIP        
         "Servicios     : " PR-LIQC.CtoGas 
         "Costo Uni Servicios     : " AT 60 X-UNISER AT 90 SKIP         
         "Gastos/Fabric.: " PR-LIQC.CtoFab                   
         "Costo Uni Gastos/Fabric.: " AT 60 X-UNIFAB AT 90 SKIP         
         "Factor Gas/Fab: " PR-LIQC.Factor FORMAT "->>9.99"        
         "Costo Unitario Producto : " AT 60 PR-LIQC.PreUni AT 90 SKIP
         "Observaciones : " SUBSTRING(PR-LIQC.Observ[1],1,60) FORMAT "X(60)"  
         "------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         
 
 
  

  FOR EACH pr-liqc WHERE pr-liqc.codcia = s-codcia
      AND PR-LIQC.Numliq >= txt-desde
      AND PR-LIQC.Numliq <= txt-hasta
      AND PR-LIQC.FlgEst <> "A" NO-LOCK:

      VIEW STREAM REPORT FRAME F-ORDEN.
        
      ASSIGN 
          X-UNIMAT = PR-LIQC.CtoMat / PR-LIQC.CanFin
          X-UNIFAB = PR-LIQC.CtoFab / PR-LIQC.CanFin
          X-UNISER = PR-LIQC.CtoGas / PR-LIQC.CanFin
          X-UNIHOR = PR-LIQC.CtoHor / PR-LIQC.CanFin.

      FIND Almmmatg WHERE Almmmatg.CodCia = PR-LIQC.CodCia AND
                          Almmmatg.CodMat = PR-LIQC.CodArt NO-LOCK NO-ERROR.
      IF AVAILABLE Almmmatg THEN X-DESART = Almmmatg.DesMat.

      X-CODMON = IF PR-LIQC.CodMon = 1 THEN "S/." ELSE "US$".
      
      FOR EACH PR-LIQCX OF PR-LIQC NO-LOCK BREAK BY PR-LIQCX.Codcia:
          FIND Almmmatg WHERE Almmmatg.CodCia = PR-LIQCX.CodCia AND
              Almmmatg.CodMat = PR-LIQCX.CodArt NO-LOCK NO-ERROR.
          IF FIRST-OF(PR-LIQCX.Codcia) THEN DO:
              PUT STREAM Report "P R O D U C T O    T E R M I N A D O " SKIP.
              PUT STREAM Report "-------------------------------------" SKIP.      
          END.

          DISPLAY STREAM Report
              PR-LIQCX.CodArt 
              Almmmatg.DesMat   FORMAT "X(50)"
              Almmmatg.Desmar   FORMAT "X(15)"
              PR-LIQCX.CodUnd 
              PR-LIQCX.CanFin 
              PR-LIQCX.PreUni
              PR-LIQCX.CtoTot 
              WITH FRAME F-Deta.
          DOWN STREAM Report WITH FRAME F-Deta.  

      END.

      FOR EACH PR-LIQD1 OF PR-LIQC NO-LOCK BREAK BY PR-LIQD1.Codcia:
          FIND Almmmatg WHERE Almmmatg.CodCia = PR-LIQD1.CodCia AND
              Almmmatg.CodMat = PR-LIQD1.CodMat NO-LOCK NO-ERROR.
          IF FIRST-OF(PR-LIQD1.Codcia) THEN DO:
              PUT STREAM Report "M A T E R I A L E S   D I R E C T O S" SKIP.
              PUT STREAM Report "-------------------------------------" SKIP.      
          END.
          
          ACCUM  PR-LIQD1.ImpTot ( TOTAL BY PR-LIQD1.CodCia) .      
          X-TOTAL = X-TOTAL + PR-LIQD1.ImpTot.
          
          DISPLAY STREAM Report 
              PR-LIQD1.codmat 
              Almmmatg.DesMat   FORMAT "X(50)"
              Almmmatg.Desmar   FORMAT "X(15)"
              PR-LIQD1.CodUnd 
              PR-LIQD1.CanDes 
              PR-LIQD1.PreUni
              PR-LIQD1.ImpTot 
              WITH FRAME F-Deta1.
          DOWN STREAM Report WITH FRAME F-Deta1.  

          IF LAST-OF(PR-LIQD1.Codcia) THEN DO:
              UNDERLINE STREAM REPORT 
                  PR-LIQD1.ImpTot            
                  WITH FRAME F-Deta1.
              DISPLAY STREAM REPORT 
                  ACCUM TOTAL BY PR-LIQD1.Codcia PR-LIQD1.ImpTot @ PR-LIQD1.ImpTot 
                  WITH FRAME F-Deta1.
          END.
      END.

      FOR EACH PR-LIQD3 OF PR-LIQC NO-LOCK BREAK BY PR-LIQD3.Codcia:
          FIND Gn-Prov WHERE 
              Gn-Prov.Codcia = pv-codcia AND  
              Gn-Prov.CodPro = PR-LIQD3.CodPro NO-LOCK NO-ERROR.
          IF AVAILABLE Gn-Prov THEN DO:
              X-NOMPRO = Gn-Prov.NomPro .
          END.

          FIND PR-Gastos WHERE 
              PR-Gastos.Codcia = S-CODCIA AND  
              PR-Gastos.CodGas = PR-LIQD3.CodGas         
              NO-LOCK NO-ERROR.
          IF AVAILABLE PR-Gastos THEN DO:
              X-NOMGAS = PR-Gastos.DesGas.
          END.

          IF FIRST-OF(PR-LIQD3.Codcia) THEN DO:
              PUT STREAM Report "S E R V I C I O   D E    T E R C E R O S" SKIP.
              PUT STREAM Report "----------------------------------------" SKIP.      
          END.

          ACCUM  PR-LIQD3.ImpTot ( TOTAL BY PR-LIQD3.CodCia) .      
          X-TOTAL = X-TOTAL + PR-LIQD3.ImpTot.
          
          DISPLAY STREAM Report 
              PR-LIQD3.codPro  
              X-NOMPRO         
              PR-LIQD3.CodGas  
              X-NOMGAS         
              PR-LIQD3.ImpTot 
              WITH FRAME F-Deta3.
          DOWN STREAM Report WITH FRAME F-Deta3.  

          IF LAST-OF(PR-LIQD3.Codcia) THEN DO:
              UNDERLINE STREAM REPORT 
                  PR-LIQD3.ImpTot            
                  WITH FRAME F-Deta3.

              DISPLAY STREAM REPORT 
                  ACCUM TOTAL BY PR-LIQD3.Codcia PR-LIQD3.ImpTot @ PR-LIQD3.ImpTot 
                  WITH FRAME F-Deta3.
          END.
      END.

      FOR EACH PR-LIQD2 OF PR-LIQC NO-LOCK BREAK BY PR-LIQD2.Codcia:
          FIND PL-PERS WHERE PL-PERS.CodCia = PR-LIQD2.CodCia AND
              PL-PERS.CodPer = PR-LIQD2.CodPer
              NO-LOCK NO-ERROR.
          X-DESPER = TRIM(PL-PERS.PatPer) + " " + TRIM(PL-PERS.MatPer) + " " + TRIM(PL-PERS.NomPer) .
          IF FIRST-OF(PR-LIQD2.Codcia) THEN DO:
              PUT STREAM Report "M A N O   D E   O B R A   D I R E C T A" SKIP.
              PUT STREAM Report "---------------------------------------" SKIP.      
          END.
          
          ACCUM  HorVal ( TOTAL BY PR-LIQD2.CodCia) .      
          X-TOTAL = X-TOTAL + HorVal.

          DISPLAY STREAM Report 
              PR-LIQD2.codper 
              X-DESPER FORMAT "X(50)"
              PR-LIQD2.Horas 
              PR-LIQD2.HorVal 
              WITH FRAME F-Deta2.
          DOWN STREAM Report WITH FRAME F-Deta2.  
          
          IF LAST-OF(PR-LIQD2.Codcia) THEN DO:
              UNDERLINE STREAM REPORT 
                  PR-LIQD2.HorVal            
                  WITH FRAME F-Deta2.
              
              DISPLAY STREAM REPORT 
                  ACCUM TOTAL BY PR-LIQD2.Codcia PR-LIQD2.HorVal @ PR-LIQD2.HorVal 
                  WITH FRAME F-Deta2.
          END.
      END.

      FOR EACH PR-LIQD4 OF PR-LIQC NO-LOCK BREAK BY PR-LIQD4.Codcia:
          FIND Almmmatg WHERE Almmmatg.CodCia = PR-LIQD4.CodCia AND
              Almmmatg.CodMat = PR-LIQD4.CodMat NO-LOCK NO-ERROR.
          IF FIRST-OF(PR-LIQD4.Codcia) THEN DO:
              PUT STREAM Report "M E R M A S" SKIP.
              PUT STREAM Report "-----------" SKIP.      
          END.

          DISPLAY STREAM Report 
              PR-LIQD4.codmat 
              Almmmatg.DesMat   FORMAT "X(50)"
              Almmmatg.Desmar   FORMAT "X(15)"
              PR-LIQD4.CodUnd 
              PR-LIQD4.CanDes 
              WITH FRAME F-Deta4.
          DOWN STREAM Report WITH FRAME F-Deta4.  
      END.

      PUT STREAM Report SKIP(4).
      PUT STREAM Report "              ---------------------                       ---------------------             "  AT 10 SKIP.
      PUT STREAM Report "                    Elaborado                                   Aprobado                    "  AT 10 SKIP.
      PUT STREAM Report  PR-LIQC.Usuario  SKIP.

      PAGE STREAM Report.
  END.


  



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

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM REPORT TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn4} .
        RUN formato.
        PAGE STREAM REPORT.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            FRAME {&FRAME-NAME}:SENSITIVE = FALSE.
            RUN LIB/W-README.R(s-print-file).
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE.
            IF s-salida-impresion = 1 THEN
                OS-DELETE VALUE(s-print-file).
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

