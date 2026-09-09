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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 2.01
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* KARDEX GENERAL CONTABLE */
  DEF STREAM REPORT.
  
  DEF VAR s-codcia AS INT INIT 001 NO-UNDO.
  DEF VAR DesdeF AS DATE NO-UNDO.
  DEF VAR HastaF AS DATE NO-UNDO.
  DEF VAR f-Ingreso AS DEC NO-UNDO.
  DEF VAR f-Salida AS DEC NO-UNDO.
  DEF VAR f-PreIng AS DEC NO-UNDO.
  DEF VAR f-Precio AS DEC NO-UNDO.
  DEF VAR f-Saldo AS DEC NO-UNDO.
  DEF VAR f-ValCto AS DEC NO-UNDO.  
  DEF VAR f-StkGen AS DEC NO-UNDO.
  DEF VAR f-TotIng AS DEC NO-UNDO.
  DEF VAR nCodMon AS INT INIT 1 NO-UNDO.  
  ASSIGN
    DesdeF = DATE(01,01,2003)
    HastaF = DATE(12,31,2003).
    
  DEFINE VARIABLE S-CODMOV AS CHAR NO-UNDO. 
  DEFINE VARIABLE x-codpro LIKE Almcmov.codpro NO-UNDO.
  DEFINE VARIABLE x-codcli LIKE Almcmov.codcli NO-UNDO.
  DEFINE VARIABLE x-nrorf1 LIKE Almcmov.nrorf1 NO-UNDO.
  DEFINE VARIABLE x-nrorf2 LIKE Almcmov.nrorf2 NO-UNDO.
  DEFINE VARIABLE x-codmov LIKE Almcmov.codmov NO-UNDO.

  DEFINE VARIABLE x-inggen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-salgen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-totgen LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-codmon LIKE Almdmov.candes NO-UNDO.
  DEFINE VARIABLE x-tpocmb LIKE Almdmov.candes NO-UNDO.

  DEFINE VARIABLE x-total AS DECIMAL.
  /* Tipo de movimiento de la salida por G/R */
  
  DEFINE FRAME F-REPORTE
    Almmmatg.codmat     COLUMN-LABEL "Articulo"
    Almmmatg.desmat     COLUMN-LABEL "Descripcion"
    Almmmatg.desmar     COLUMN-LABEL "Marca"
    Almmmatg.undstk     COLUMN-LABEL "Und"              FORMAT 'x(4)'
    Almdmov.CodAlm      COLUMN-LABEL "Cod!Alm"          FORMAT "X(3)"
    S-CODMOV            COLUMN-LABEL "Cod!Mov"          FORMAT "X(3)"
    Almdmov.NroDoc      COLUMN-LABEL "Numero!Docmto"    FORMAT ">>>>>>9"
    Almdmov.Almori      COLUMN-LABEL "Alm!Ori/Des"      FORMAT "X(3)" 
    x-CodPro            COLUMN-LABEL "Codigo!Proveedor" 
    x-CodCli            COLUMN-LABEL "Codigo!Cliente"   
    x-NroRf1            COLUMN-LABEL "Referencia"
    x-NroRf2            COLUMN-LABEL "Referencia"
    Almdmov.FchDoc      COLUMN-LABEL "Fecha!Documento"
    F-Ingreso           COLUMN-LABEL "Ingresos"         
    F-Salida            COLUMN-LABEL "Salidas"  
    F-PreIng            COLUMN-LABEL "Costo!Ingreso" 
    F-PRECIO            COLUMN-LABEL "Costo!Promedio" 
    F-SALDO             COLUMN-LABEL "Saldos"           FORMAT "->>>,>>>,>>9.99"
    F-VALCTO            COLUMN-LABEL "Costo!Total"      FORMAT "->>>,>>>,>>9.99"
  WITH WIDTH 320 NO-BOX NO-UNDERLINE STREAM-IO DOWN. 
                
  ASSIGN
     x-inggen = 0
     x-salgen = 0
     x-totgen = 0  
     x-total  = 0.
  FIND LAST gn-tcmb WHERE gn-tcmb.fecha <= DesdeF NO-LOCK NO-ERROR.

  OUTPUT STREAM REPORT TO c:\tmp\kardex2003.txt.
  FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.CodCia = S-CODCIA 
        AND LOOKUP(TRIM(Almmmatg.CatConta[1]), 'AF,SV,XX') = 0,
      EACH Almdmov NO-LOCK USE-INDEX ALMD02 WHERE Almdmov.CodCia = Almmmatg.CodCia 
                            AND  Almdmov.codmat = Almmmatg.CodMat 
                            AND  Almdmov.FchDoc >= DesdeF 
                            AND  Almdmov.FchDoc <= HastaF                             
                           BREAK BY Almmmatg.CodCia 
                                 BY Almmmatg.CodMat
                                 BY Almdmov.FchDoc:
      IF FIRST-OF(Almmmatg.CodMat) THEN DO:
         /* BUSCAMOS SI TIENE MOVIMEINTOS ANTERIORES A DesdeF */
         FIND LAST AlmStkGe WHERE AlmstkGe.Codcia = Almmmatg.Codcia AND
                                AlmstkGe.CodMat = Almmmatg.CodMat AND
                                AlmstkGe.Fecha < DesdeF
                                NO-LOCK NO-ERROR.
         F-STKGEN = 0.
         F-SALDO  = 0.
         F-PRECIO = 0.
         F-VALCTO = 0.
     
         IF AVAILABLE AlmStkGe THEN DO:
            F-STKGEN = AlmStkGe.StkAct.
            F-SALDO  = AlmStkGe.StkAct.
            F-PRECIO = AlmStkGe.CtoUni.
            F-VALCTO = F-STKGEN * F-PRECIO.
         END.
         DISPLAY STREAM REPORT
            Almmmatg.CodMat
            Almmmatg.DesMat 
            Almmmatg.DesMar        
            Almmmatg.UndStk 
            DesdeF @ almdmov.fchdoc       
            F-PRECIO        
            F-Saldo         
            F-VALCTO        
            WITH FRAME F-REPORTE.
      END.

      FIND Almtmovm WHERE Almtmovm.Codcia = Almdmov.Codcia AND
                          Almtmovm.TipMov = Almdmov.TipMov AND
                          Almtmovm.Codmov = Almdmov.Codmov
                          NO-LOCK NO-ERROR.

      IF AVAILABLE Almtmovm AND Almtmovm.Movtrf THEN NEXT.                          

      FIND Almacen WHERE Almacen.Codcia = S-CODCIA AND
                         Almacen.Codalm = Almdmov.Codalm 
                         NO-LOCK NO-ERROR.

      IF Almdmov.Codmov = 03 THEN NEXT.                   
      
      IF AVAILABLE Almacen and NOT Almacen.FlgRep  THEN NEXT.

      IF AVAILABLE Almacen and Almacen.AlmCsg  THEN NEXT.

      x-codpro = "".
      x-codcli = "".
      x-nrorf1 = "".
      x-nrorf2 = "".

      FIND Almcmov WHERE Almcmov.CodCia = Almdmov.codcia 
                    AND  Almcmov.CodAlm = Almdmov.codalm 
                    AND  Almcmov.TipMov = Almdmov.tipmov 
                    AND  Almcmov.CodMov = Almdmov.codmov 
                    AND  Almcmov.NroDoc = Almdmov.nrodoc 
                   NO-LOCK NO-ERROR.

      IF AVAILABLE Almcmov THEN DO:
         ASSIGN
            x-codpro = Almcmov.codpro
            x-codcli = Almcmov.codcli
            x-nrorf1 = Almcmov.nrorf1
            x-nrorf2 = Almcmov.nrorf2
            x-codmon = Almcmov.codmon
            x-tpocmb = Almcmov.tpocmb.
      END.
                  
      S-CODMOV  = Almdmov.TipMov + STRING(Almdmov.CodMov,"99"). 

      F-Ingreso = IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.
      F-PreIng  = 0.
      F-TotIng  = 0.

      IF nCodmon = x-Codmon THEN DO:
         IF Almdmov.Tipmov = 'I' THEN DO:
            F-PreIng  = Almdmov.PreUni / Almdmov.Factor.
            F-TotIng  = Almdmov.ImpCto.
         END.
         ELSE DO:
            F-PreIng  = 0.
            F-TotIng  = F-PreIng * F-Ingreso.
         END.
         END.
      ELSE DO:
         IF nCodmon = 1 THEN DO:
            IF Almdmov.Tipmov = 'I' THEN DO:
               F-PreIng  = ROUND(Almdmov.PreUni * Almdmov.Tpocmb / Almdmov.Factor, 4).
               F-TotIng  = (Almdmov.ImpCto * Almdmov.TpoCmb ).
            END.
            IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
               F-PreIng  = 0.
               F-TotIng  = F-PreIng * F-Ingreso.
            END.
            END.
         ELSE DO:
            IF Almdmov.Tipmov = 'I' THEN DO:
               F-PreIng  = ROUND(Almdmov.PreUni / Almdmov.TpoCmb / Almdmov.Factor, 4).
               F-TotIng  = ROUND(Almdmov.ImpCto / Almdmov.TpoCmb, 2).
            END.
            IF LOOKUP(Almdmov.Tipmov, 'U,R') > 0 THEN DO:
               F-PreIng  = 0.
               F-TotIng  = F-PreIng * F-Ingreso.
            END.
         END.
      END.

      F-Salida  = IF LOOKUP(Almdmov.TipMov,"S,T") > 0 THEN (Almdmov.CanDes * Almdmov.Factor) ELSE 0.

      F-Saldo   = Almdmov.StkAct.

      F-VALCTO = Almdmov.StkAct * Almdmov.VctoMn1.

      F-PRECIO = Almdmov.VctoMn1.
 
      ACCUMULATE F-Ingreso (TOTAL BY Almmmatg.CodMat).
      ACCUMULATE F-Salida  (TOTAL BY Almmmatg.CodMat).
      
      DISPLAY STREAM REPORT 
            Almmmatg.codmat     
            Almmmatg.desmat     
            Almmmatg.desmar     
            Almmmatg.undstk     
            Almdmov.CodAlm 
            S-CODMOV  
            Almdmov.NroDoc 
            Almdmov.Almori WHEN Almdmov.Codmov = 03
            x-CodPro
            x-CodCli 
            x-NroRf1 
            x-NroRf2 
            Almdmov.FchDoc 
            F-Ingreso   
            F-Salida    
            F-PreIng    WHEN Almdmov.TipMov = "I" AND (ALmtmovm.TpoCto = 0 OR ALmtmovm.TpoCto = 1) 
            F-PRECIO    
            F-SALDO     
            F-VALCTO    
            WITH FRAME F-REPORTE.
  END.    
  OUTPUT STREAM REPORT CLOSE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


