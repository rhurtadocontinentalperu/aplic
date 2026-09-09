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
DEFINE SHARED VAR pv-CODCIA  AS INTEGER.
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
            RUN LIB/W-README.R(s-print-file).
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
 
 
  VIEW STREAM REPORT FRAME F-ORDEN.

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
           Gn-Prov.CodPro = PR-LIQD3.CodPro         
           NO-LOCK NO-ERROR.
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

