     CASE T-CDOC.FlgEst :
          WHEN "P" THEN DO:
             X-EST = "PEN".
             IF T-CDOC.Codmon = 1 THEN DO:
                w-totbru [1] = w-totbru [1] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).   
                w-totdsc [1] = w-totdsc [1] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [1] = w-totexo [1] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [1] = w-totval [1] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [1] = w-totisc [1] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [1] = w-totigv [1] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [1] = w-totven [1] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).

                m-totbru [1] = m-totbru [1] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).   
                m-totdsc [1] = m-totdsc [1] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totexo [1] = m-totexo [1] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totval [1] = m-totval [1] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totisc [1] = m-totisc [1] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totigv [1] = m-totigv [1] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totven [1] = m-totven [1] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
             ELSE DO:  
                w-totbru [2] = w-totbru [2] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).   
                w-totdsc [2] = w-totdsc [2] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [2] = w-totexo [2] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [2] = w-totval [2] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [2] = w-totisc [2] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [2] = w-totigv [2] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [2] = w-totven [2] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).

                m-totbru [2] = m-totbru [2] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).   
                m-totdsc [2] = m-totdsc [2] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totexo [2] = m-totexo [2] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totval [2] = m-totval [2] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totisc [2] = m-totisc [2] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totigv [2] = m-totigv [2] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totven [2] = m-totven [2] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
             END.   
          END.   
          WHEN "C" THEN DO:
             X-EST = "CAN".
             IF T-CDOC.Codmon = 1 THEN DO:
                w-totbru [3] = w-totbru [3] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [3] = w-totdsc [3] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [3] = w-totexo [3] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [3] = w-totval [3] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [3] = w-totisc [3] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [3] = w-totigv [3] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [3] = w-totven [3] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).

                m-totbru [3] = m-totbru [3] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totdsc [3] = m-totdsc [3] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totexo [3] = m-totexo [3] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totval [3] = m-totval [3] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totisc [3] = m-totisc [3] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totigv [3] = m-totigv [3] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totven [3] = m-totven [3] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
             ELSE DO:  
                w-totbru [4] = w-totbru [4] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).   
                w-totdsc [4] = w-totdsc [4] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [4] = w-totexo [4] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [4] = w-totval [4] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [4] = w-totisc [4] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [4] = w-totigv [4] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [4] = w-totven [4] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).

                m-totbru [4] = m-totbru [4] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).   
                m-totdsc [4] = m-totdsc [4] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totexo [4] = m-totexo [4] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totval [4] = m-totval [4] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totisc [4] = m-totisc [4] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totigv [4] = m-totigv [4] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totven [4] = m-totven [4] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
             END.                
          END.   
          WHEN "A" THEN DO:
             X-EST = "ANU".       
             IF T-CDOC.Codmon = 1 THEN DO:
                w-totbru [5] = w-totbru [5] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [5] = w-totdsc [5] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [5] = w-totexo [5] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [5] = w-totval [5] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [5] = w-totisc [5] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [5] = w-totigv [5] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [5] = w-totven [5] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).

                m-totbru [5] = m-totbru [5] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totdsc [5] = m-totdsc [5] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totexo [5] = m-totexo [5] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totval [5] = m-totval [5] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totisc [5] = m-totisc [5] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totigv [5] = m-totigv [5] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totven [5] = m-totven [5] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                END.   
             ELSE DO:  
                w-totbru [6] = w-totbru [6] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totdsc [6] = w-totdsc [6] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totexo [6] = w-totexo [6] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totval [6] = w-totval [6] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totisc [6] = w-totisc [6] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totigv [6] = w-totigv [6] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                w-totven [6] = w-totven [6] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).

                m-totbru [6] = m-totbru [6] + T-CDOC.ImpBrt * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totdsc [6] = m-totdsc [6] + T-CDOC.ImpDto * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totexo [6] = m-totexo [6] + T-CDOC.ImpExo * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totval [6] = m-totval [6] + T-CDOC.ImpVta * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totisc [6] = m-totisc [6] + T-CDOC.ImpIsc * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totigv [6] = m-totigv [6] + T-CDOC.ImpIgv * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
                m-totven [6] = m-totven [6] + T-CDOC.ImpTot * (IF T-CDOC.CodDoc = "N/C" THEN -1 ELSE 1).
             END.                
          END.   
     END.        


