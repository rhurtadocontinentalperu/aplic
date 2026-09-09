&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
    FOR EACH cb-dmov NO-LOCK WHERE
             cb-dmov.codcia    =      s-codcia           AND
             cb-dmov.periodo   =      s-periodo          AND
             cb-dmov.coddiv   BEGINS  (x-div)            AND
             cb-dmov.codcta   >=      (x-cuenta)         AND
             cb-dmov.codcta   <=      (x-cuenta-2)       AND
             cb-dmov.codaux   BEGINS  (x-auxiliar)       AND
             cb-dmov.nromes   >=      x-mes1             AND
             cb-dmov.nromes   <=      x-mes2             AND
             (x-CodOpe = '' OR cb-dmov.codope = x-codope) AND
             cb-dmov.clfaux   BEGINS  (x-Clasificacion)  
            BREAK BY cb-dmov.codcia
                  BY cb-dmov.periodo 
                  BY cb-dmov.Codcta
                  BY cb-dmov.codaux
                  BY cb-dmov.coddoc
                  BY cb-dmov.nrodoc 
                  BY cb-dmov.nromes 
                  BY cb-dmov.fchdoc :     
        IF R-TipRep >= 2 THEN DO:     
           IF FIRST-OF(cb-dmov.codcta) then do:
              FIND cb-ctas WHERE cb-ctas.codcia = cb-codcia
                             AND cb-ctas.codcta = cb-dmov.codcta
                             NO-LOCK NO-ERROR.
              IF AVAILABLE cb-ctas THEN x-MoNcta = cb-ctas.codmon.
           END.
           if first-of(cb-dmov.nrodoc) then assign x-s1 = 0
                                                   x-s2 = 0.
           if cb-dmov.tpomov then assign x-s1 = x-s1 - cb-dmov.impmn1
                                         x-s2 = x-s2 - cb-dmov.impmn2.
                             else assign x-s1 = x-s1 + cb-dmov.impmn1
                                         x-s2 = x-s2 + cb-dmov.impmn2.
        END.         
        IF FIRST-OF(CB-DMOV.nrodoc) and FIRST-OF(CB-DMOV.FCHDOC) THEN 
           ASSIGN T-FECHA = CB-DMOV.FCHDOC
                  X-VOUCHER = cb-dmov.codope + cb-dmov.nroast.
        x-glodoc = cb-dmov.glodoc.
        IF x-glodoc = "" THEN DO:
           FIND cb-cmov WHERE cb-cmov.codcia   = cb-dmov.codcia
                            AND cb-cmov.periodo = cb-dmov.periodo 
                            AND cb-cmov.nromes  = cb-dmov.nromes
                            AND cb-cmov.codope  = cb-dmov.codope
                            AND cb-cmov.nroast  = cb-dmov.nroast
                        NO-LOCK NO-ERROR.
           IF AVAILABLE cb-cmov THEN
               x-glodoc = cb-cmov.notast.
        END.
        IF x-glodoc = "" THEN DO:
            find cb-ctas WHERE cb-ctas.codcta = cb-dmov.codcta
                                AND cb-ctas.CodCia = cb-codcia
                            NO-LOCK NO-ERROR.                      
                IF AVAILABLE cb-ctas THEN 
                    x-glodoc = cb-ctas.nomcta.
        END.
        IF NOT tpomov THEN 
            CASE x-codmon:
            WHEN 1 THEN DO:
                x-debe  = ImpMn1.
                x-haber = 0.
            END.
            WHEN 2 THEN DO:
                x-debe  = ImpMn2.
                x-haber = 0.
            END.
            END CASE.
       
        ELSE 
            CASE x-codmon:
            WHEN 1 THEN DO:
                x-debe  = 0.
                x-haber = ImpMn1.
            END.
            WHEN 2 THEN DO:
                x-debe  = 0.
                x-haber = ImpMn2.
            END.
            END CASE.            
       
        IF cb-dmov.codmon = x-codmon THEN 
            x-importe = 0.
        ELSE
            CASE cb-dmov.codmon:
            WHEN 1 THEN 
                x-importe = cb-dmov.ImpMn1.
            WHEN 2 THEN 
                x-importe = cb-dmov.ImpMn2.
            END CASE.
       
        CREATE T-REPORT.
        ASSIGN T-REPORT.CODCTA    = CB-DMOV.CODCTA
               T-REPORT.CLFAUX    = CB-DMOV.CLFAUX
               T-REPORT.CODAUX    = CB-DMOV.CODAUX
               T-REPORT.FCHDOC    = CB-DMOV.FCHDOC
               T-REPORT.CODDIV    = cb-dmov.coddiv
               T-REPORT.CCO       = cb-dmov.cco
               T-REPORT.NROAST    = cb-dmov.nroast
               T-REPORT.CODOPE    = cb-dmov.codope
               T-REPORT.NROMES    = cb-dmov.nromes
               T-REPORT.CODDOC    = cb-dmov.coddoc
               T-REPORT.NRODOC    = cb-dmov.nrodoc
               T-REPORT.NROREF    = cb-dmov.nroref
               T-REPORT.FCHVTO    = cb-dmov.fchvto
               T-REPORT.GLODOC    = x-glodoc
               T-REPORT.T-IMPORTE = x-importe
               T-REPORT.T-DEBE    = x-debe
               T-REPORT.T-HABER   = x-haber
               T-REPORT.FECHA-ID  = T-FECHA
               T-REPORT.VOUCHER   = X-VOUCHER.
        IF R-TipRep >= 2 AND 
           LAST-OF(CB-DMOV.NRODOC) THEN DO:
           case x-moncta :
                when 1 then if  x-s1 = 0 then run borra.
                when 2 then if  x-s2 = 0 then run borra.
                otherwise do:
                   case x-codmon :
                        when 1 then if  x-s1 = 0 then run borra.
                        when 2 then if  x-s2 = 0 then run borra.
                   end case .
                end.
           end case.
        END.   
    END. /* FIN DEL FOR EACH */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


