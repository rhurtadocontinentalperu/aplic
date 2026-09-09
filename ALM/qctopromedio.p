def input parameter desdec as char.

def var s-codcia as int init 001.
def var i-fchdoc as date no-undo.
def var f-candes as dec  no-undo.

i-fchdoc = date(01,01,2002).

disable triggers for load of almcmov.
disable triggers for load of almdmov.
disable triggers for load of almmmate.

def buffer B-STKAL FOR AlmStkAl.
def buffer B-STKGE FOR AlmStkGe.
def buffer b-mov   FOR Almtmov.

def var x-signo  as deci no-undo.  
def var x-ctomed as deci no-undo.
def var x-stkgen as deci no-undo.
def var x-cto    as deci no-undo.
def var x-factor as inte no-undo.

FOR EACH Almmmatg NO-LOCK WHERE Almmmatg.codcia = S-CODCIA AND
                                Almmmatg.codmat = desdec 
                                USE-INDEX matg01 :
                                
    FOR EACH AlmStkAl WHERE AlmStkAl.Codcia = S-CODCIA AND
                            AlmStkAl.CodMat = Almmmatg.CodMat AND
                            AlmStkAl.Fecha >= I-FchDoc:
        DELETE AlmStkAl.
    END.                        

    FOR EACH AlmStkGe WHERE AlmStkGe.Codcia = S-CODCIA AND
                            AlmStkGe.CodMat = Almmmatg.CodMat AND
                            AlmStkGe.Fecha >= I-FchDoc:
        DELETE AlmStkGe.
    END.                        
                     
    FOR EACH Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                            Almmmate.CodMat = Almmmatg.CodMat 
                            USE-INDEX Mate03:
        Almmmate.StkAct = 0.
    END.
    
    ASSIGN
    x-stkgen = 0
    x-ctomed = 0.
    FIND LAST AlmStkGe WHERE AlmStkGe.Codcia = S-CODCIA AND
                             AlmStkGe.CodMat = Almmmatg.CodMat AND
                             AlmStkGe.Fecha  < I-Fchdoc
                             NO-LOCK NO-ERROR.
    IF AVAILABLE AlmStkGe THEN DO:
       ASSIGN
       x-stkgen = AlmStkGe.StkAct
       x-ctomed = AlmStkGe.CtoUni.
    END.                       

    /*************Ordenes Movimiento por Producto y Fecha *******************/     
    FOR EACH AlmDmov WHERE Almdmov.Codcia = S-CODCIA AND
                           Almdmov.CodMat = Almmmatg.CodMat AND
                           Almdmov.FchDoc >= I-FchDoc
                           USE-INDEX Almd02: 
          find first almacen where almacen.codcia = almdmov.codcia
                          and almacen.codalm = almdmov.codalm  
                          use-index alm01 no-lock no-error.
    /* RHC 21.05.04 ***********************************
       x-factor = if almdmov.codmov = 03 then 0 else 1.
    *************************************************** */       
    FIND Almtmovm WHERE almtmovm.codcia = almdmov.codcia
        AND almtmovm.tipmov = almdmov.tipmov
        AND almtmovm.codmov = almdmov.codmov
        NO-LOCK NO-ERROR.
    IF AVAILABLE almtmovm AND almtmovm.movtrf = YES
    THEN x-Factor = 0.
    ELSE x-Factor = 1.

       if avail almacen and not almacen.flgrep then next.

       if avail almacen and almacen.AlmCsg then next.

       if almdmov.tpocmb = 0 then do:
            find last gn-tcmb where  gn-tcmb.fecha <= almdmov.fchdoc
                              use-index cmb01 no-lock no-error.
            if avail gn-tcmb then do:
                if almdmov.tipmov = "i" then almdmov.tpocmb = gn-tcmb.venta.
                if almdmov.tipmov = "s" then almdmov.tpocmb = gn-tcmb.compra. 
            end.
       end.
                              

       f-candes = almdmov.candes * almdmov.factor.
       IF Almdmov.tipMov = "I" THEN x-signo = 1.
       IF Almdmov.tipMov = "S" THEN x-signo = -1.
       
       /***********Inicia Stock x Almacen********************/
       FIND AlmStkAl WHERE AlmStkAl.Codcia = S-CODCIA AND
                           AlmStkAl.CodAlm = Almdmov.CodAlm AND
                           AlmStkAl.CodMat = Almdmov.CodMat AND
                           AlmstkAl.Fecha  = Almdmov.FchDoc
                           NO-ERROR.

       IF NOT AVAILABLE AlmStkAl THEN DO:      
          CREATE AlmStkAl.
          ASSIGN
          AlmStkAl.Codcia = S-CODCIA 
          AlmStkAl.CodAlm = Almdmov.CodAlm
          AlmStkAl.CodMat = Almdmov.CodMat
          AlmStkAl.Fecha  = Almdmov.FchDoc.
                               
          FIND LAST B-STKAL WHERE B-STKAL.Codcia = S-CODCIA AND
                                  B-STKAL.CodAlm = Almdmov.CodAlm AND
                                  B-STKAL.CodMat = Almdmov.CodMat AND
                                  B-STKAL.Fecha  < Almdmov.FchDoc
                                  NO-ERROR.
          IF AVAILABLE B-STKAL THEN AlmStkAl.StkAct = AlmStkAl.StkAct + B-STKAL.StkAct.                         

       END.
       ASSIGN
       AlmStkAl.StkAct = AlmStkAl.StkAct + f-candes * x-signo.
       /***********Fin Stock x Almacen********************/

       find first almtmov of almdmov use-index mov01 no-lock no-error.
       /***********Inicia Stock x Compañia********************/       
       FIND AlmStkGe WHERE AlmStkGe.Codcia = S-CODCIA AND
                           AlmStkGe.CodMat = Almdmov.CodMat AND
                           AlmstkGe.Fecha  = Almdmov.FchDoc
                           NO-ERROR.

       IF NOT AVAILABLE AlmStkGe THEN DO:      
          CREATE AlmStkGe.
          ASSIGN
          AlmStkGe.Codcia = S-CODCIA 
          AlmStkGe.CodMat = Almdmov.CodMat
          AlmStkGe.Fecha  = Almdmov.FchDoc.
                               
          FIND LAST B-STKGE WHERE B-STKGE.Codcia = S-CODCIA AND
                                  B-STKGE.CodMat = Almdmov.CodMat AND
                                  B-STKGE.Fecha  < Almdmov.FchDoc
                                  NO-ERROR.
          IF AVAILABLE B-STKGE THEN AlmStkGe.StkAct = AlmStkGe.StkAct + B-STKGE.StkAct.                         

       END.
       ASSIGN
       AlmStkGe.StkAct = AlmStkGe.StkAct + f-candes * x-signo * x-factor.
       /***********Fin Stock x Compañia********************/       


       /***********Inicia Calculo del Costo Promedio********************/       
       IF AVAILABLE AlmtMov THEN DO:
          IF Almtmov.TipMov = "I"  
             THEN DO:
             x-cto = 0.
             IF Almtmov.TpoCto = 0 OR Almtmov.TpoCto = 1 THEN DO:
                if almdmov.codmon = 1 then x-cto = Almdmov.Preuni.
                if almdmov.codmon = 2 then x-cto = Almdmov.Preuni * Almdmov.TpoCmb.
                x-ctomed = ((x-cto * f-candes) + (x-ctomed * (AlmStkGe.StkAct - f-candes * x-signo))) / ( AlmStkGe.StkAct).
                if x-ctomed < 0 then x-ctomed = x-cto.
                if AlmStkGe.StkAct < f-candes and AlmStkGe.StkAct >= 0 then x-ctomed = x-cto.
             END.
             ELSE DO:
                
             END.
          END.
          Almdmov.VctoMn1 = x-ctomed.
          Almdmov.StkSub  = AlmStkAl.StkAct.
          Almdmov.StkAct  = AlmStkGe.StkAct.
          AlmStkGe.CtoUni = x-ctomed.
          AlmStkAl.CtoUni = x-ctomed.
       END.
       ELSE DO:
          Almdmov.VctoMn1 = 0.
       END.
       /***********Fin    Calculo del Costo Promedio********************/       
       

     END.
    /*************                            *******************/     

     FOR EACH Almacen WHERE Almacen.Codcia = S-CODCIA:
         FIND LAST AlmStkAl WHERE AlmStkAl.Codcia = Almacen.Codcia AND
                                  AlmStkAl.CodAlm = Almacen.CodAlm AND
                                  AlmStkAl.CodMat = Almmmatg.CodMat
                                  NO-ERROR. 
         IF AVAILABLE AlmStkAl THEN DO:
            FIND FIRST Almmmate WHERE Almmmate.Codcia = S-CODCIA AND
                                      Almmmate.CodAlm = Almacen.CodAlm AND
                                      Almmmate.CodMat = Almmmatg.CodMat
                                      NO-ERROR.
            IF NOT AVAILABLE Almmmate THEN DO:
                CREATE Almmmate.
                ASSIGN
                almmmate.codcia = S-CODCIA
                almmmate.codalm = almacen.codalm
                almmmate.codmat = almmmatg.codmat
                almmmate.desmat = almmmatg.desmat
                almmmate.undvta = almmmatg.undstk
                almmmate.facequ = 1.
            END.
            Almmmate.Stkact = AlmStkAl.StkAct.  
                                      
         END.
                     
     END.
END.
