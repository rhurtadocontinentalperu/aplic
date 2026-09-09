  
                    AND  CcbCDocu.flgest = "P"          
                    AND  CcbCDocu.FchVto <= TODAY
                    AND  CcbCDocu.CodDiv BEGINS F-Division
                    AND  CcbCDocu.CodMon = x-moneda
                BREAK BY CcbCDocu.CodCia
                      BY CcbCDocu.CodCli
                      BY CcbCDocu.coddoc
                      BY CcbCDocu.nrodoc:
     VIEW STREAM REPORT FRAME F-Titulo.
     IF FIRST-OF(CcbCDocu.CodCli) THEN DO:
        PUT STREAM REPORT 
            SKIP(1)
            {&PRN6A} + "Cliente : " AT 1 FORMAT "X(15)" CcbCDocu.codcli FORMAT "X(12)" CcbCDocu.NomCli + {&PRN6B} FORMAT "X(60)" SKIP(1).
     END.
     F-Impor = CcbCDocu.ImpTot.
     F-Saldo = CcbCDocu.SdoAct.
     
     
     FIND FacDocum WHERE FacDocum.codcia = S-CODCIA AND
          FacDocum.CodDoc = CcbCDocu.coddoc NO-LOCK NO-ERROR.
     IF AVAILABLE FacDocum AND NOT FacDocum.TpoDoc THEN
        ASSIGN F-Impor = F-Impor * -1
               F-Saldo = F-Saldo * -1.
     F-Rango[1] = 0.
     F-Rango[2] = 0.
     F-Rango[3] = 0.
     F-Rango[4] = 0.
     F-Rango[5] = 0.
     F-Rango[6] = 0.
     F-Rango[7] = 0.
     F-Rango[8] = 0.
     IF CcbCDocu.FchVto > TODAY THEN F-Rango[1] = F-Impor.
     ELSE DO:
         F-DIAS = TODAY - CcbCDocu.FchVto.
         IF F-DIAS > 120 THEN                  F-Rango[8] = F-Saldo. /* 120-mas */
         IF F-DIAS > 90 AND F-DIAS <= 120 THEN F-Rango[7] = F-Saldo. /*91-120 */
         IF F-DIAS > 60 AND F-DIAS <= 90  THEN F-Rango[6] = F-Saldo. /*61-90 */

         IF F-DIAS > 30 AND F-DIAS < 60 THEN F-Rango[5] = F-Saldo. /* 31-60  */
         IF F-DIAS > 15 AND F-DIAS < 30 THEN F-Rango[4] = F-Saldo. /* 61-90  */
         IF F-DIAS > 8  AND F-DIAS < 15 THEN F-Rango[3] = F-Saldo. /* 31-60  */
         IF F-DIAS >= 0 AND F-DIAS < 8  THEN F-Rango[2] = F-Saldo. /* 15-30  */
         
     END.
     DISPLAY STREAM REPORT 
             CcbCDocu.CodDoc
             CcbCDocu.NroDoc
             CcbCDocu.FchDoc
             CcbCDocu.FchVto
/*             F-Impor    WHEN    F-Impor <> 0
 *              F-Saldo    WHEN    F-Saldo <> 0
 *              F-Rango[1] WHEN F-Rango[1] <> 0*/
             F-Rango[2] WHEN F-Rango[2] <> 0
             F-Rango[3] WHEN F-Rango[3] <> 0
             F-Rango[4] WHEN F-Rango[4] <> 0
             F-Rango[5] WHEN F-Rango[5] <> 0
             F-Rango[6] WHEN F-Rango[6] <> 0
             F-Rango[7] WHEN F-Rango[7] <> 0
             F-Rango[8] WHEN F-Rango[8] <> 0
             WITH FRAME F-Detalle.
            
     ACCUMULATE F-Impor    (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Saldo    (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[1] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[2] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[3] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[4] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[5] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[6] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[7] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Rango[8] (TOTAL BY CcbCDocu.CodCia).
     ACCUMULATE F-Impor    (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Saldo    (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[1] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[2] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[3] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[4] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[5] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[6] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[7] (SUB-TOTAL BY CcbCDocu.CodCli).
     ACCUMULATE F-Rango[8] (SUB-TOTAL BY CcbCDocu.CodCli).

     IF LAST-OF(CcbCDocu.CodCli) THEN DO:
        UNDERLINE STREAM REPORT 
/*                  F-Impor        
 *                   F-Saldo        
 *                   F-Rango[1]     */
                  F-Rango[2]     
                  F-Rango[3]     
                  F-Rango[4]     
                  F-Rango[5]       
                  F-Rango[6]
                  F-Rango[7]
                  F-Rango[8] WITH FRAME F-Detalle.
        DISPLAY STREAM REPORT 
                " TOTAL  >>"   @ CcbCDocu.FchVto    
/*                ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Impor    @ F-Impor 
 *                 ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Saldo    @ F-Saldo 
 *                 ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[1] @ F-Rango[1]*/
                ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[2] @ F-Rango[2]
                ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[3] @ F-Rango[3]
                ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[4] @ F-Rango[4]
                ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[5] @ F-Rango[5]
                ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[6] @ F-Rango[6]
                ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[7] @ F-Rango[7]
                ACCUM SUB-TOTAL BY (CcbCDocu.CodCli) F-Rango[8] @ F-Rango[8]
                WITH FRAME F-Detalle.
        DOWN STREAM REPORT WITH FRAME F-Detalle.
     END.
     IF LAST-OF(CcbCDocu.CodCia) THEN DO:
        UNDERLINE STREAM REPORT 
/*                  F-Impor        
 *                   F-Saldo        
 *                   F-Rango[1]     */
                  F-Rango[2]     
                  F-Rango[3]     
                  F-Rango[4]     
                  F-Rango[5]     
                  F-Rango[6]
                  F-Rango[7]
                  F-Rango[8] WITH FRAME F-Detalle.
        DISPLAY STREAM REPORT 
                "     TOTAL"   @ CcbCDocu.FchDoc
                "GENERAL >>"   @ CcbCDocu.FchVto
/*                ACCUM TOTAL BY (CcbCDocu.CodCia) F-Impor    @ F-Impor
 *                 ACCUM TOTAL BY (CcbCDocu.CodCia) F-Saldo    @ F-Saldo
 *                 ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[1] @ F-Rango[1]*/
                ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[2] @ F-Rango[2]
                ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[3] @ F-Rango[3]
                ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[4] @ F-Rango[4]
                ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[5] @ F-Rango[5]
                ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[6] @ F-Rango[6]
                ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[7] @ F-Rango[7]
                ACCUM TOTAL BY (CcbCDocu.CodCia) F-Rango[8] @ F-Rango[8]
                WITH FRAME F-Detalle.
        UNDERLINE STREAM REPORT 
/*                  F-Impor        
 *                   F-Saldo        
 *                   F-Rango[1]     */
                  F-Rango[2]     
                  F-Rango[3]     
                  F-Rango[4]     
                  F-Rango[5]     
                  F-Rango[6]     
                  F-Rango[7]     
                  F-Rango[8] WITH FRAME F-Detalle.
        DOWN STREAM REPORT 1 WITH FRAME F-Detalle.
     END.
 END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprimir D-Dialog 
PROCEDURE imprimir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF F-Division = "" THEN  subdiv = "".
   ELSE  subdiv = "Division : " + F-Division.
       
   IF X-Moneda = 1 THEN subtit = "(Documentos Soles )" .
   ELSE subtit = "(Documentos Dolares)" .

   RUN bin/_prnctr.p.
   IF s-salida-impresion = 0 THEN RETURN.
   
   /* Captura parametros de impresion */
   /* s-pagina-inicial,  s-pagina-final,  s-printer-name,  s-print-file,  s-nro-copias */
   
   RUN aderb/_prlist.p(
       OUTPUT s-printer-list,
       OUTPUT s-port-list,
       OUTPUT s-printer-count).
   s-port-name = ENTRY(LOOKUP(s-printer-name, s-printer-list), s-port-list).
   s-port-name = REPLACE(S-PORT-NAME, ":", "").
   /*
   IF s-salida-impresion = 1 THEN 
      s-print-file = SESSION:TEMP-DIRECTORY + STRING(NEXT-VALUE(sec-arc,integral)) + ".scr".
   */
   IF s-salida-impresion = 1 THEN 
     s-print-file = SESSION:TEMP-DIRECTORY + "report.prn".
 
  CASE s-salida-impresion:
        WHEN 1 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 60. /* Pantalla */
        WHEN 2 THEN OUTPUT STREAM REPORT TO VALUE(s-port-name)  PAGED PAGE-SIZE 60. /* Impresora */
        WHEN 3 THEN OUTPUT STREAM REPORT TO VALUE(s-print-file) PAGED PAGE-SIZE 60. /* Archivo */
  END CASE.
  
  PUT STREAM REPORT CONTROL {&Prn0} + {&Prn5A} + CHR(66) + {&Prn3} .

   
   RUN Formato.

   PAGE STREAM REPORT.
   OUTPUT STREAM REPORT CLOSE.
 
   CASE s-salida-impresion:
        WHEN 1 OR WHEN 3 THEN RUN LIB/D-README.R(s-print-file). 
   END CASE. 
   
   DELETE FROM W-REPORT WHERE w-report.Task-No = S-TASK-NO.

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
    DEF VAR xx as logical.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    
  /* Code placed here will execute AFTER standard behavior.    */
    
    FOR EACH facdocum with frame {&FRAME-NAME} :
         xx = x-docu:add-last(facdocum.coddoc).
    END.
    
    F-Division:screen-value = S-CODDIV.
    FIND GN-DIVI WHERE S-CODDIV = GN-DIVI.CodDiv AND S-CODCIA = GN-DIVI.CodCia.
    IF AVAILABLE GN-DIVI THEN F-DesDiv:screen-value = GN-DIVI.DesDiv.
    
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
        WHEN "" THEN ASSIGN input-var-1 = "".
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


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             	”ŒV≈ ∏:    ‡ 4              °                                v±      Ë  P)              ≤õ  Ëh$('      ƒ'  ) xP  ƒ  <Q  ƒ   R  ` `S  ‘  4T  L ÄU  ‘  TV  ƒ  W  ƒ  ‹W  Ñ	 `Y  ƒ 
 $Z  ƒ  ËZ  ( \   $]  X |^   ê_  8 »`   ‹a  Ë ƒe  ƒ  àf   åg  ¿ Li   Pj   Tk   Xl  ƒ  m  ƒ   ‡m  p! Pq  ‡" 0u  ê ' ¿u  î( Tz   ) tÄ  ∏ * ,Å  8+ dÇ  $, àÜ  ® - 0á  ÿ . à  ê / òà  – 0 hâ  ,1         îç  l  ?  ë  ≤
iSO8859-1                        †   à      Ë                T ƒ         \# '           h x ¡           0                                         PROGRESS                         ‡       ‘                                                     D                                                         Ñ     @                     ,®     x                                                      ´    §
   
                ê|     ‹                                            ´      
ÙC       O      [      g      $t        Å             INTEGRAL                         PROGRESS                         ∞ í0  í           «t–8      öS]              ‰ 0             5¥¨:      ØR              d 30  3           nªU:      ;M6                       REPORTE                          PROGRESS                         ò M	  M	           .Ü–8      V	%  )           Ã M	  M	           .Ü–8      V	%  )             M	  M	          .Ü–8      V	%              4 M	  ∏	 C          .Ü–8      ¬	%  ,              1
0  1
           «t–8      :
◊•                > ˇˇ å#F       > ˇˇ ‘#       ˇˇ                           ⁄      ˇˇˇˇ                     Ç
 à
 ê
 ñ
 ù
 §
 ñ
 ™
          h   Ë#H 8 #  ¯#             X      ¸yê  O ˇˇ    eË      O ˇˇ    R˜      O ˇˇ    ˆÂ    t        à { *          Ë $ + ú ˇˇˇ                        Ä ﬂ±  h @        X      å @        |        Ä ﬂ±  $ ´ ∏ ˇˇˇ        †    
            Ä ﬂ±  ,$ è¸ ˇˇˇ        `/	üD   LÃ           3 ˇˇ∞    X        3 ˇˇÿ 8 †l¨    4 ˇˇÏ         ¥          ˇÄ             °§       xuÑ   °t‘/¢Ã               3 ˇˇ $ ¢Ëˇˇˇ        $   
              Ä ﬂ±    /£   $P          3 ˇˇ0   0        3 ˇˇ\–$ ©Lˇˇˇ        t@        d       Ä ﬂ±  adm-apply-entry   h             