disable triggers for load of almcmov.
disable triggers for load of almdmov.
disable triggers for load of almmmate.

def input parameter x-codmat as char.
def var s-codcia as inte init 1.
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

def var desdec as char init "" format "x(6)".
def var hastac as char init "" format "x(6)".

def var x-next as inte init 1.
define image image-1 filename "auxiliar" size 5 by 1.5.
def var fi-mensaje as char format "x(40)".
def var x-indi as deci no-undo.
def var m as integer init 5.
def var i-fchdoc as date format '99/99/9999' init ?.
def var x-trf as inte init 1.

if desdec = '' then desdec = x-codmat /*'000001'*/.
if hastac = '' then hastac = x-codmat /*'999999'*/.

i-fchdoc = today.

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
             
    for each almdmov where almdmov.codcia = s-codcia
                       and almdmov.codmat = almmmatg.codmat
                       and almdmov.fchdoc >= i-fchdoc
                       use-index almd02: 
       x-next = 1.
       
       find first almacen where almacen.codcia = almdmov.codcia
                          and almacen.codalm = almdmov.codalm  
                          use-index alm01 no-lock no-error.
                          
       if avail almacen and not almacen.flgrep then x-next = 0.

       if avail almacen and almacen.AlmCsg then x-next = 0.

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

       x-trf = 1.
 
       if almtmov.MovTrf then x-trf = 0.


/********************/
    if (avail almtmov and almtmov.tipmov = "I" and (almtmov.TpoCto = 0 OR Almtmov.Tpocto = 1)) or
                          (Almtmov.TipMov = "I" and Almdmov.CodMov = 02 ) then do:
            if  almdmov.preuni > 0 and almdmov.candes >= 0 then
                almdmov.impcto = round(almdmov.preuni * almdmov.candes,m).
           /* 
            if not almdmov.impcto > 0 and not almdmov.preuni > 0 and almdmov.factor > 0 then do:
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
                if avail almdmov2 then do:
                    if almdmov.codmon = 1 then 
                        almdmov.preuni = round (almdmov2.vctomn1cbd / almdmov2.stkactcbd * almdmov.factor ,m).
                    else 
                        almdmov.preuni = round (almdmov2.vctomn2cbd / almdmov2.stkactcbd * almdmov.factor ,m).
                    almdmov.impcto = round(almdmov.preuni * almdmov.candes,m).    
                end.
                if not avail almdmov2 then
                    assign
                    almdmov.preuni = 0
                    almdmov.impcto = 0.        
            end.
            */
            if almdmov.impcto > 0 and almdmov.candes > 0 and almdmov.preuni = 0 then
                almdmov.preuni = round(almdmov.impcto / almdmov.candes,m).           

            if almdmov.codmon = 1 then do:
                if f-candes > 0 then f-pctomn = round(almdmov.impcto / f-candes,m).
                if almdmov.tpocmb > 0 then f-pctome = round(f-pctomn / almdmov.tpocmb,m).
            end.
            else do:
                if f-candes > 0 then f-pctome = round(almdmov.impcto / f-candes,m).
                if almdmov.tpocmb > 0 then f-pctomn = round(f-pctome * almdmov.tpocmb,m).
            end.
    end.
    else do:
        assign
        almdmov.preuni = 0
        almdmov.impcto = 0.
        if almdmov.codmov = 01 or almdmov.codmov = 12 then do:
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


        if almdmov.tipmov = "i" and almdmov.codmov = 09 then do:
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

         if almdmov.tipmov = "i" and almdmov.codmov = 10 then do:
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
         if f-pctomn * f-pctome = 0 then do:
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
        end.
/********************/
        if almdmov.tipmov = "i" then x-indi = 1. 
                                else x-indi = -1.

        assign
        f-tctomn = f-pctomn * f-candes
        f-tctome = f-pctome * f-candes.

        if almmmatg.catconta[1] = "CR" then
            assign
            f-tctomn = 0
            f-tctome = 0.

        assign
        f-stkgen = f-stkgen + x-indi * f-candes
        f-stkgencbd = f-stkgencbd + x-indi * x-next * x-trf * f-candes
        f-stkact = f-stkact + x-indi * f-candes
        f-stkactcbd = f-stkactcbd + x-indi * x-next * x-trf * f-candes
        f-vctomn = f-vctomn + x-indi * f-tctomn
        f-vctomncbd = f-vctomncbd + x-indi * x-next * x-trf * f-tctomn
        f-vctome = f-vctome + x-indi * f-tctome
        f-vctomecbd = f-vctomecbd + x-indi * x-next * x-trf * f-tctome.
             
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





