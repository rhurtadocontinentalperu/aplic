&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER X-ROWID AS ROWID.

DEFINE SHARED VAR S-CODCIA  AS INTEGER.
DEFINE SHARED VAR PV-CODCIA  AS INTEGER.
DEFINE SHARED VAR S-NOMCIA  AS CHARACTER.
DEFINE SHARED VAR S-USER-ID AS CHARACTER.

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



DEFINE STREAM Reporte.

FIND PR-LIQC WHERE ROWID(PR-LIQC) = X-ROWID NO-LOCK NO-ERROR.
IF NOT AVAILABLE PR-LIQC THEN RETURN.

X-UNIMAT = PR-LIQC.CtoMat / PR-LIQC.CanFin.
X-UNIFAB = PR-LIQC.CtoFab / PR-LIQC.CanFin.
X-UNISER = PR-LIQC.CtoGas / PR-LIQC.CanFin.
X-UNIHOR = PR-LIQC.CtoHor / PR-LIQC.CanFin.


/*
FIND gn-prov WHERE gn-prov.CodCia = S-CODCIA AND  
                   gn-prov.CodPro = PR-LIQC.Codpro NO-LOCK NO-ERROR.
IF AVAILABLE gn-prov THEN X-DESPRO = gn-prov.NomPro .
ELSE DO:
  FIND gn-prov WHERE gn-prov.CodCia = 0 AND  
                     gn-prov.CodPro = PR-LIQC.CodPro NO-LOCK NO-ERROR.
  IF AVAILABLE gn-prov THEN X-DESPRO = gn-prov.NomPro .
END.  
*/
FIND Almmmatg WHERE Almmmatg.CodCia = PR-LIQC.CodCia AND
                    Almmmatg.CodMat = PR-LIQC.CodArt NO-LOCK NO-ERROR.
IF AVAILABLE Almmmatg THEN X-DESART = Almmmatg.DesMat.

X-CODMON = IF PR-LIQC.CodMon = 1 THEN "S/." ELSE "US$".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 1.35
         WIDTH              = 34.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/bin/_prns.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

    DEFINE VARIABLE c-Copias AS INTEGER NO-UNDO.

    RUN lib/Imprimir2.
    IF s-salida-impresion = 0 THEN RETURN.

    IF s-salida-impresion = 1 THEN 
        s-print-file = SESSION:TEMP-DIRECTORY +
        STRING(NEXT-VALUE(sec-arc,integral)) + ".prn".

    DO c-Copias = 1 TO s-nro-copias ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE:
        CASE s-salida-impresion:
            WHEN 1 OR WHEN 3 THEN
                OUTPUT STREAM report TO VALUE(s-print-file) PAGED PAGE-SIZE 62.
            WHEN 2 THEN
                OUTPUT STREAM report TO PRINTER PAGED PAGE-SIZE 62. /* Impresora */
        END CASE.
        PUT STREAM REPORT CONTROL {&PRN0} + {&PRN5A} + CHR(66) + {&PRN3}.
        RUN Imprimir.
        PAGE STREAM report.
        OUTPUT STREAM report CLOSE.
    END.
    OUTPUT STREAM report CLOSE.

    CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN DO:
            RUN LIB/D-README.R(s-print-file).
            IF s-salida-impresion = 1 THEN OS-DELETE VALUE(s-print-file).
        END.
    END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-imprimir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir Procedure 
PROCEDURE imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE FRAME F-Deta
         LPRDLPRO.CodMat   COLUMN-LABEL "Articulo"
         Almmmatg.DesMat   FORMAT "X(45)" COLUMN-LABEL "Descripcion"
         LPRDLPRO.UndBas   FORMAT "X(6)"  COLUMN-LABEL "Unidad"
         LPRDLPRO.CanDes   COLUMN-LABEL "Cantidad!Procesada"
         WITH NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.     
         
  DEFINE FRAME F-Deta1
         LPRDLPRO.CodMat   COLUMN-LABEL "Articulo"
         Almmmatg.DesMat   FORMAT "X(45)" COLUMN-LABEL "Descripcion"
         LPRDLPRO.UndBas   FORMAT "X(6)"  COLUMN-LABEL "Unidad"
         LPRDLPRO.CanDes   COLUMN-LABEL "Cantidad!Procesada"
         WITH NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.     

  DEFINE FRAME F-Deta2
         LPRDBOB.CodMat    COLUMN-LABEL "Cód. Bobina"
         Almmmatg.DesMat   COLUMN-LABEL "Descripción"
         /*LPRDBOB.UndBas    COLUMN-LABEL "Unidad Base"*/
         LPRDBOB.CanDes    COLUMN-LABEL "Cantidad"
         WITH NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  DEFINE FRAME F-Deta3
         LPRDSERV.CodPro   COLUMN-LABEL "Código Prov."
         Gn-prov.NomPro    COLUMN-LABEL "Nombre Proveedor"
         LPRDSERV.CodGas   COLUMN-LABEL "Código Gasto"
         PR-GASTOS.Desgas  COLUMN-LABEL "Descripción Gasto"
         LPRDSERV.ImpTot   COLUMN-LABEL "Importe Total"
         WITH  NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.
         
  DEFINE FRAME F-Deta4
         LPRDMERM.CodMat   COLUMN-LABEL  "Código Articulo"
         Almmmatg.DesMat   COLUMN-LABEL  "Descripción Articulo" FORMAT "X(50)" 
         LPRDMERM.CanMat   COLUMN-LABEL  "Cantidad"
         /*LPRDMERM.Peso     COLUMN-LABEL  "Peso"         */
         WITH NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         

  DEFINE FRAME F-Deta5
         LPRDHRHM.CodPer   COLUMN-LABEL  "Código Personal"
         X-DESPER          FORMAT "X(50)"
         LPRDHRHM.HoraI    COLUMN-LABEL  "Hora Inicio"
         LPRDHRHM.HoraF    COLUMN-LABEL  "Hora Fin"
         LPRDHRHM.HoraT    COLUMN-LABEL  "Horas Totales"      
         WITH NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.  

  DEFINE FRAME F-Orden
         HEADER
         S-NOMCIA FORMAT "X(25)" 
         "LINEAS DE ORDEN DE PRODUCCION" AT 30 FORMAT "X(45)"
         "LOTE No. : " AT 80 LPRCLPRO.CodMaq + LPRCLPRO.NroDoc AT 100 SKIP
         "MAQUINA No. : " AT 80 LPRCLPRO.CodMaq AT 100 SKIP
         "ORDEN   No. : " AT 80 LPRCLPRO.Numord AT 100 SKIP
         "Contometro Inicial : " AT 80 LPRCLPRO.ConmtroI AT 100 SKIP
         "Contometro Final : " AT 80 LPRCLPRO.ConmtroF AT 100 SKIP
/*         "Fecha  : "   AT 80 LPRCLPRO.FchDoc FORMAT "99/99/9999" AT 100 SKIP
 *          "Hora   : "   AT 80 LPRCLPRO.HorDoc FORMAT "99/99/9999" AT 100 SKIP
 *          "Horas Máquina : "   AT 80 LPRCLPRO.HrsMaq FORMAT "99/99/9999" AT 100 SKIP*/
         
       /*  "Periodo Liquidado : "  PR-LIQC.FecIni FORMAT "99/99/9999" " Al " PR-LIQC.FecFin FORMAT "99/99/9999" 
 *          "Moneda          : " AT 80 X-CODMON AT 100 SKIP
 *          "Articulo      : " /*PR-LIQC.CodArt  X-DESART  */
 *          "Tipo/Cambio   : " AT 80 PR-LIQC.TpoCmb AT 100 SKIP
 *          "Cantidad      : " PR-LIQC.CanFin PR-LIQC.CodUnd SKIP
 *          "Costo Material: " PR-LIQC.CtoMat 
 *          "Costo Uni Material      : " AT 60 X-UNIMAT AT 90 SKIP
 *          "Mano/Obra Dire: " PR-LIQC.CtoHor 
 *          "Costo Uni Mano/Obra Dire: " AT 60 X-UNIHOR AT 90 SKIP        
 *          "Servicios     : " PR-LIQC.CtoGas 
 *          "Costo Uni Servicios     : " AT 60 X-UNISER AT 90 SKIP         
 *          "Gastos/Fabric.: " PR-LIQC.CtoFab                   
 *          "Costo Uni Gastos/Fabric.: " AT 60 X-UNIFAB AT 90 SKIP         
 *          "Factor Gas/Fab: " PR-LIQC.Factor FORMAT "->>9.99"        
 *          "Costo Unitario Producto : " AT 60 PR-LIQC.PreUni AT 90 SKIP
 *          "Observaciones : " SUBSTRING(PR-LIQC.Observ[1],1,60) FORMAT "X(60)"  */
 
         "------------------------------------------------------------------------------------------------------------------------------" SKIP
         WITH NO-LABEL NO-UNDERLINE NO-BOX WIDTH 145 STREAM-IO DOWN.         
 
 
  VIEW STREAM REPORT FRAME F-ORDEN.

  FOR EACH LPRDLPRO OF LPRCLPRO NO-LOCK WHERE LPRDLPRO.TpoMat = "PT"
      BREAK BY LPRDLPRO.CodCia:
      FIND Almmmatg WHERE Almmmatg.CodCia = LPRCLPRO.CodCia AND
                          Almmmatg.CodMat = LPRDLPRO.CodMat NO-LOCK NO-ERROR.
      IF FIRST-OF(LPRDLPRO.CodCia) THEN DO:
         PUT STREAM Report "P R O D U C T O    T E R M I N A D O " SKIP.
         PUT STREAM Report "-------------------------------------" SKIP.
      END.   
      
      DISPLAY STREAM Report
         LPRDLPRO.CodMat
         Almmmatg.DesMat  FORMAT "X(50)"
         LPRDLPRO.UndBas
         LPRDLPRO.CanDes
      WITH FRAME F-Deta.
      DOWN STREAM Report WITH FRAME F-Deta.
  END.
  
  FOR EACH LPRDLPRO OF LPRCLPRO NO-LOCK WHERE LPRDLPRO.TpoMat = "MP"
      BREAK BY LPRDLPRO.CodCia:
      FIND Almmmatg WHERE Almmmatg.CodCia = LPRCLPRO.CodCia AND
                          Almmmatg.CodMat = LPRDLPRO.CodMat NO-LOCK NO-ERROR.
      IF FIRST-OF(LPRDLPRO.CodCia) THEN DO:
         PUT STREAM Report "    M A T E R I A      P R I M A     " SKIP.
         PUT STREAM Report "-------------------------------------" SKIP.
      END.   
      
      DISPLAY STREAM Report
         LPRDLPRO.CodMat
         Almmmatg.DesMat  FORMAT "X(50)"
         LPRDLPRO.UndBas
         LPRDLPRO.CanDes
      WITH FRAME F-Deta1.
      DOWN STREAM Report WITH FRAME F-Deta1.
  END.


  FOR EACH LPRDBOB OF LPRCLPRO NO-LOCK BREAK BY LPRDBOB.CodCia:
      FIND Almmmatg WHERE Almmmatg.CodCia = LPRDBOB.CodCia AND
                          Almmmatg.CodMat = LPRDBOB.CodMat NO-LOCK NO-ERROR.
      IF FIRST-OF(LPRDBOB.CodCia) THEN DO:
         PUT STREAM Report "             B O B I N A S           " SKIP.
         PUT STREAM Report "-------------------------------------" SKIP.
      END.
      DISPLAY STREAM Report
         LPRDBOB.CodMat   
         Almmmatg.DesMat   FORMAT "X(50)"
         LPRDBOB.CanDes
      WITH FRAME F-Deta2.
      DOWN STREAM Report WITH FRAME F-Deta2.   
    
  END.  
    
  FOR EACH LPRDSERV OF LPRCLPRO NO-LOCK BREAK BY LPRDSERV.Codcia:
      FIND Gn-Prov WHERE 
           Gn-Prov.Codcia = pv-codcia AND  
           Gn-Prov.CodPro = LPRDSERV.CodPro         
           NO-LOCK NO-ERROR.
      IF AVAILABLE Gn-Prov THEN DO:
         X-NOMPRO = Gn-Prov.NomPro .
      END.

      FIND PR-Gastos WHERE 
           PR-Gastos.Codcia = S-CODCIA AND  
           PR-Gastos.CodGas = LPRDSERV.CodGas         
           NO-LOCK NO-ERROR.
      IF AVAILABLE PR-Gastos THEN DO:
         X-NOMGAS = PR-Gastos.DesGas.
      END.

      IF FIRST-OF(LPRDSERV.Codcia) THEN DO:
         PUT STREAM Report "S E R V I C I O   D E    T E R C E R O S" SKIP.
         PUT STREAM Report "----------------------------------------" SKIP.      
      END.

      ACCUM  LPRDSERV.ImpTot ( TOTAL BY LPRDSERV.CodCia) .      
      X-TOTAL = X-TOTAL + LPRDSERV.ImpTot.
      
      DISPLAY STREAM Report 
         LPRDSERV.CodPro 
         X-NOMPRO
         LPRDSERV.CodGas 
         X-NOMGAS 
         LPRDSERV.ImpTot                
      WITH FRAME F-Deta3.
      DOWN STREAM Report WITH FRAME F-Deta3.  

      IF LAST-OF(LPRDSERV.Codcia) THEN DO:
        UNDERLINE STREAM REPORT 
            LPRDSERV.ImpTot            
        WITH FRAME F-Deta3.
        
        DISPLAY STREAM REPORT 
            ACCUM TOTAL BY LPRDSERV.Codcia LPRDSERV.ImpTot @ LPRDSERV.ImpTot 
            WITH FRAME F-Deta3.
      END.
  END.
  
  FOR EACH LPRDHRHM OF LPRCLPRO NO-LOCK BREAK BY LPRCLPRO.CodCia:
      FIND PL-PERS WHERE PL-PERS.CodCia = LPRDHRHM.CodCia AND
                         PL-PERS.CodPer = LPRDHRHM.CodPer
                         NO-LOCK NO-ERROR.
      X-DESPER = TRIM(PL-PERS.PatPer) + " " + TRIM(PL-PERS.MatPer) + " " + TRIM(PL-PERS.NomPer) .
      IF FIRST-OF(LPRCLPRO.Codcia) THEN DO:
         PUT STREAM Report "M A N O   D E   O B R A   D I R E C T A" SKIP.
         PUT STREAM Report "---------------------------------------" SKIP.      
      END.

/*      ACCUM  HorVal ( TOTAL BY LPRCLPRO.CodCia) .      
 *       X-TOTAL = X-TOTAL + HorVal.*/
      
      DISPLAY STREAM Report 
         LPRDHRHM.CodPer 
         X-DESPER FORMAT "X(50)"
         LPRDHRHM.HoraI 
         LPRDHRHM.HoraF 
         LPRDHRHM.HoraT        
      WITH FRAME F-Deta5.
      DOWN STREAM Report WITH FRAME F-Deta5.  
/*
 *       IF LAST-OF(PR-LIQD2.Codcia) THEN DO:
 *         UNDERLINE STREAM REPORT 
 *             PR-LIQD2.HorVal            
 *         WITH FRAME F-Deta2.
 *         
 *         DISPLAY STREAM REPORT 
 *             ACCUM TOTAL BY PR-LIQD2.Codcia PR-LIQD2.HorVal @ PR-LIQD2.HorVal 
 *             WITH FRAME F-Deta2.
 *       END.*/

  END.
  
  FOR EACH LPRDMERM OF LPRCLPRO NO-LOCK BREAK BY LPRDMERM.CodCia:
      FIND Almmmatg WHERE Almmmatg.CodCia = LPRDMERM.CodCia AND
                          Almmmatg.CodMat = LPRDMERM.CodMat NO-LOCK NO-ERROR.
      IF FIRST-OF(LPRDMERM.CodCia) THEN DO:
         PUT STREAM Report "             M E R M A S             " SKIP.
         PUT STREAM Report "-------------------------------------" SKIP.
      END.
      DISPLAY STREAM Report
      LPRDMERM.CodMat 
      Almmmatg.DesMat
      LPRDMERM.CanMat 
      WITH FRAME F-Deta4.
      DOWN STREAM Report WITH FRAME F-Deta4.
  END.
 

  PUT STREAM Report SKIP(4).
  PUT STREAM Report "    -----------------       -----------------       -----------------      -----------------"  AT 10 SKIP.
  PUT STREAM Report "        Operador                 Vo. Bo.                  Vo. Bo.               Vo. Bo.     "  AT 10 SKIP.
  PUT STREAM Report  PR-LIQC.Usuario  SKIP.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

