DEFINE BUFFER MATG FOR Almmmatg.

DEFINE SHARED VAR S-CODCIA AS INTEGER.
DEFINE SHARED VAR S-NOMCIA AS CHARACTER.
DEFINE SHARED VAR S-CODALM AS CHARACTER.
DEFINE SHARED VAR S-DESALM AS CHARACTER.

DEFINE VAR I-CODMAT AS CHAR    NO-UNDO.
DEFINE VAR F-STKACT AS DECIMAL NO-UNDO.
DEFINE VAR F-VCTOMN AS DECIMAL NO-UNDO.
DEFINE VAR F-VCTOME AS DECIMAL NO-UNDO.
DEFINE VAR F-PMAXMN AS DECIMAL NO-UNDO.
DEFINE VAR F-PMAXME AS DECIMAL NO-UNDO.
DEFINE VAR F-PULTMN AS DECIMAL NO-UNDO.
DEFINE VAR F-PULTME AS DECIMAL NO-UNDO.
DEFINE VAR F-STKGEN AS DECIMAL NO-UNDO.
DEFINE VAR F-PREUMN AS DECIMAL NO-UNDO.
DEFINE VAR F-PREUME AS DECIMAL NO-UNDO.
DEFINE VAR F-CANDES AS DECIMAL NO-UNDO.
DEFINE VAR F-PREUNI AS DECIMAL NO-UNDO.
DEFINE VAR F-TCTOMN AS DECIMAL NO-UNDO.
DEFINE VAR F-TCTOME AS DECIMAL NO-UNDO.
DEFINE VAR F-PCTOMN AS DECIMAL NO-UNDO.
DEFINE VAR F-PCTOME AS DECIMAL NO-UNDO.
DEFINE VAR D-ULTCMP AS DATE NO-UNDO.
DEFINE VAR L-REPASA AS LOGICAL NO-UNDO.
DEFINE VAR DesdeC AS CHAR    NO-UNDO.
DEFINE VAR HastaC AS CHAR    NO-UNDO.


DEFINE IMAGE IMAGE-1 FILENAME "IMG\Auxiliar" SIZE 5 BY 1.5.
DEF VAR FI-MENSAJE AS CHAR FORMAT "X(40)" .

DEFINE FRAME F-Proceso
     IMAGE-1 AT ROW 1.5 COL 5
     "Espere un momento" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 1.5 COL 16 FONT 6
     "por favor ...." VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 2.5 COL 19 FONT 6
          SKIP
     Fi-Mensaje NO-LABEL FONT 6
     SKIP     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE 
         BGCOLOR 15 FGCOLOR 0 
         TITLE "Procesando ..." FONT 7.










update DesdeC HastaC. 

IF HastaC = "" THEN HastaC = "999999".

FIND FIRST Almmmatg WHERE Almmmatg.CodCia = S-CODCIA
    AND Almmmatg.CodMat >= DesdeC 
    USE-INDEX Matg01
    NO-LOCK NO-ERROR.

REPEAT WHILE AVAILABLE Almmmatg 
    AND Almmmatg.CodCia = S-CODCIA AND
    Almmmatg.CodMat <= HastaC:
    
    I-CODMAT = Almmmatg.CodMat.
    DISPLAY Almmmatg.CodMat @ Fi-Mensaje LABEL "Codigo de Articulo "
            FORMAT "X(8)" WITH FRAME F-Proceso.

    FOR EACH Almmmate WHERE Almmmate.CodCia = S-CODCIA 
        AND Almmmate.CodMat = I-CODMAT 
        USE-INDEX Mate03:
        ASSIGN Almmmate.StkAct = 0.
    END.

    F-STKACT = 0.
    F-VCTOMN = 0.
    F-VCTOME = 0.
    F-PMAXMN = 0.
    F-PMAXME = 0.
    F-PULTMN = 0.
    F-PULTME = 0.
    F-STKGEN = 0.
    L-REPASA = NO.

    FOR EACH Almdmov WHERE Almdmov.CodCia = S-CODCIA 
        AND Almdmov.CodMat = I-CODMAT USE-INDEX Almd02:
        
        FIND Almcmov WHERE Almcmov.CodCia = Almdmov.CodCia 
            AND Almcmov.CodAlm = Almdmov.CodAlm 
            AND Almcmov.TipMov = Almdmov.TipMov 
            AND Almcmov.CodMov = Almdmov.CodMov 
            AND Almcmov.NroDoc = Almdmov.NroDoc NO-LOCK NO-ERROR.

        IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN DO:
           IF AVAILABLE Almcmov AND Almcmov.FchDoc <> Almdmov.FchDoc THEN DO:
              ASSIGN Almdmov.FchDoc = Almcmov.FchDoc  
              L-REPASA = YES.    
              LEAVE.
           END.
           release almcmov.
        END.

        IF Almdmov.CodMon = 1 THEN DO:
           F-PREUMN = Almdmov.PreUni.
           IF Almdmov.TpoCmb > 0 THEN F-PREUME = ROUND(Almdmov.PreUni / Almdmov.TpoCmb,4).
           ELSE F-PREUME = 0.
        END.      
        ELSE ASSIGN F-PREUMN = ROUND(Almdmov.PreUni * Almdmov.TpoCmb,4)
                    F-PREUME = Almdmov.PreUni.
        
        IF Almdmov.Factor > 0 THEN 
            ASSIGN 
            F-PREUMN = F-PREUMN / Almdmov.Factor
            F-PREUME = F-PREUME / Almdmov.Factor.
        
        F-CANDES = Almdmov.CanDes.
        F-PREUNI = Almdmov.PreUni.

        FIND Almtmovm WHERE Almtmovm.CodCia = Almdmov.CodCia AND
            Almtmovm.Tipmov = Almdmov.TipMov AND
            Almtmovm.Codmov = Almdmov.CodMov NO-LOCK NO-ERROR.

        IF AVAILABLE Almtmovm AND Almtmovm.ModCsm AND F-CANDES > 0 THEN DO:  
           IF Almdmov.FchDoc >= D-ULTCMP THEN 
              ASSIGN 
              D-ULTCMP = Almdmov.FchDoc
              F-PULTMN = F-PREUMN
              F-PULTME = F-PREUME
              F-PMAXMN = MAXIMUM(F-PMAXMN,F-PREUMN)
              F-PMAXME = MAXIMUM(F-PMAXME,F-PREUME).
        END.

        IF AVAILABLE Almtmovm AND Almtmovm.PidPco THEN ASSIGN Almdmov.CodAjt = "A".
        ELSE ASSIGN Almdmov.CodAjt = "".

        IF Almdmov.CodMon = 1 THEN DO:
           F-TCTOMN = Almdmov.ImpCto.
           IF Almdmov.TpoCmb > 0 THEN 
              F-TCTOME = ROUND(Almdmov.ImpCto / Almdmov.TpoCmb,4).
           ELSE F-TCTOME = 0.
           ASSIGN 
           Almdmov.ImpMn1 = F-TCTOMN
           Almdmov.ImpMn2 = F-TCTOME.
        END.
        ELSE DO:
           F-TCTOMN = ROUND(Almdmov.ImpCto * Almdmov.TpoCmb,4).
           F-TCTOME = Almdmov.ImpCto.
           ASSIGN Almdmov.ImpMn1 = F-TCTOMN
           Almdmov.ImpMn2 = F-TCTOME.
        END.
        
        IF Almdmov.Factor > 0 THEN  F-CANDES = Almdmov.CanDes * Almdmov.Factor.
        
        IF F-STKACT > 0 THEN 
            ASSIGN 
            F-PCTOMN = ROUND(F-VCTOMN / F-STKACT,4)
            F-PCTOME = ROUND(F-VCTOME / F-STKACT,4).
        ELSE 
            ASSIGN 
            F-PCTOMN = 0 
            F-PCTOME = 0.
        
        F-PCTOMN  = IF F-PCTOMN < 0 THEN 0 ELSE F-PCTOMN.
        F-PCTOME  = IF F-PCTOME < 0 THEN 0 ELSE F-PCTOME.
        IF Almdmov.CodAjt <> "A" THEN DO:
           F-TCTOMN = ROUND(F-PCTOMN * F-CANDES,4).
           F-TCTOME = ROUND(F-PCTOME * F-CANDES,4).
           ASSIGN 
           Almdmov.ImpMn1 = F-TCTOMN
           Almdmov.ImpMn2 = F-TCTOME.
        END.

        IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN 
           ASSIGN 
           F-VCTOMN = F-VCTOMN + Almdmov.ImpMn1
           F-VCTOME = F-VCTOME + Almdmov.ImpMn2.
        ELSE  
            ASSIGN 
            F-VCTOMN = F-VCTOMN - Almdmov.ImpMn1
            F-VCTOME = F-VCTOME - Almdmov.ImpMn2.
            F-VCTOMN = IF F-VCTOMN < 0 THEN 0 ELSE F-VCTOMN.
            F-VCTOME = IF F-VCTOME < 0 THEN 0 ELSE F-VCTOME.

        FIND Almmmate WHERE Almmmate.CodCia = Almdmov.CodCia
            AND Almmmate.CodAlm = Almdmov.CodAlm 
            AND Almmmate.CodMat = Almdmov.CodMat EXCLUSIVE-LOCK NO-ERROR.
        
        IF NOT AVAILABLE Almmmate THEN DO:
           CREATE Almmmate.
           ASSIGN 
           Almmmate.CodCia = Almdmov.CodCia
           Almmmate.CodAlm = Almdmov.CodAlm
           Almmmate.CodMat = Almdmov.CodMat
           Almmmate.Desmat = Almmmatg.desmat
           Almmmate.UndVta = Almmmatg.UndStk
           Almmmate.FacEqu = 1.
        END.

        IF LOOKUP(Almdmov.TipMov,"I,U,R") > 0 THEN DO:
            ASSIGN 
            Almmmate.StkAct = Almmmate.StkAct + F-CANDES.
            F-STKGEN = F-STKGEN + F-CANDES.
        END.
        ELSE DO:
            ASSIGN Almmmate.StkAct = Almmmate.StkAct - F-CANDES.
            IF Almmmatg.FchUSal < Almdmov.FchDoc AND Almdmov.TipMov = "S" THEN DO:
                FIND MATG WHERE ROWID(MATG) = ROWID(Almmmatg) EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN MATG.FchUSal = Almdmov.FchDoc.
                FIND MATG WHERE ROWID(MATG) = ROWID(Almmmatg) NO-LOCK NO-ERROR.
            END.
            F-STKGEN = F-STKGEN - F-CANDES.
        END.
        
        ASSIGN 
        Almdmov.VCtoMn1 = F-VCTOMN
        Almdmov.VCtoMn2 = F-VCTOME
        Almdmov.StkSub  = Almmmate.StkAct
        Almdmov.StkAct  = F-STKGEN.
        F-STKACT = Almdmov.StkAct.
        Release almmmate.
        
        FIND Almmmate WHERE Almmmate.CodCia = Almdmov.CodCia 
            AND Almmmate.CodAlm = Almdmov.CodAlm 
            AND Almmmate.CodMat = Almdmov.CodMat NO-LOCK NO-ERROR.
        
        release almdmov.
    END.
    
    IF NOT L-REPASA THEN DO:
       FIND MATG WHERE ROWID(MATG) = ROWID(Almmmatg) EXCLUSIVE-LOCK NO-ERROR.
       ASSIGN 
       MATG.PMaxMn1 = F-PMAXMN
       MATG.PMaxMn2 = F-PMAXME
       MATG.VCtMn1  = F-VCTOMN
       MATG.VCtMn2  = F-VCTOME
       MATG.PUltMn1 = F-PULTMN
       MATG.PUltMn2 = F-PULTME
       MATG.FchUCmp = D-ULTCMP.
       
       FIND MATG WHERE ROWID(MATG) = ROWID(Almmmatg) NO-LOCK NO-ERROR.
       FIND NEXT Almmmatg USE-INDEX Matg01.
       release matg.
       release almmmatg.
    END.
END.
HIDE FRAME F-Proceso.
END PROCEDURE.

