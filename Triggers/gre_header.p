TRIGGER PROCEDURE FOR WRITE OF gre_header OLD BUFFER Oldgre_header.

if NEW gre_header OR Oldgre_header.m_rspta_sunat <> gre_header.m_rspta_sunat then do:
   define var cReservaStock as char init 'SI'.
   define buffer b-gre_detail for gre_detail.    

   /* Guia remision x vta o por OTR no reserva stock */
   IF gre_header.m_coddoc = 'OTR' OR gre_header.m_tpomov = 'GRVTA' THEN cReservaStock = 'NO'.

   IF cReservaStock <> 'NO' THEN DO:
       if NEW gre_header THEN DO:
           /* El codigo de movimiento determina si reserva stock */
           FIND FIRST almtmov WHERE almtmov.codcia = 1 AND almtmov.tipmov = 'S' AND
                                    almtmov.codmov = gre_header.m_codmov NO-LOCK NO-ERROR.
           IF AVAILABLE almtmov AND almtmov.movVal = NO  THEN cReservaStock = 'NO'.
       END.
       ELSE DO:
           /*
           IF (old.gre_header.m_rspta_sunat <> "ANULADO" AND gre_header.m_rspta_sunat = 'ANULADO') OR 
               (old.gre_header.m_rspta_sunat <> "ACEPTADO POR SUNAT" AND gre_header.m_rspta_sunat = 'ACEPTADO POR SUNAT') THEN DO:
                cReservaStock = 'NO'.
           END.
           */           
           IF gre_header.m_rspta_sunat = 'ANULADO' OR 
               gre_header.m_rspta_sunat = 'ACEPTADO POR SUNAT' OR               
               gre_header.m_rspta_sunat = 'RECHAZADO POR SUNAT' OR
               gre_header.m_rspta_sunat = 'BAJA EN SUNAT' THEN cReservaStock = 'NO'.
       END.
   END.

   for each gre_detail where gre_detail.ncorrelativo = gre_header.ncorrelatio no-lock:
      find first b-gre_detail where rowid(gre_detail) = rowid(b-gre_detail) exclusive-lock NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR THEN DO:
        /*RETURN ERROR.*/
    END.
      if available b-gre_detail then do:
         assign b-gre_detail.reserva_stock = cReservaStock.
      end.
      release b-gre_detail.
   end.
   
end. 


