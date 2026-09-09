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
      FOR EACH T-REPORT NO-LOCK USE-INDEX IDX03
             BREAK  BY T-REPORT.CODAUX
                    BY T-REPORT.CODCTA
                    BY T-REPORT.VOUCHER
                    BY T-REPORT.FECHA-ID
                    BY T-REPORT.CODDOC
                    BY T-REPORT.NRODOC 
                    BY T-REPORT.CODOPE
                    BY T-REPORT.NROAST
                    BY T-REPORT.FCHDOC :
           K = K + 1.
           IF K = 1 THEN DO:
              hide frame f-auxiliar .
              VIEW FRAME F-Mensaje.   
              PAUSE 0.           
           END.          
           IF FIRST-OF (T-REPORT.nrodoc) THEN x-conreg = 0.
           IF FIRST-OF (T-REPORT.codaux) THEN DO:
              run T-nom-aux.
              x-nomaux = T-REPORT.codaux + " " + x-nomaux.
              {&NEW-PAGE}.            
              DISPLAY STREAM report WITH FRAME T-cab.
              PUT STREAM report CONTROL P-dobleon.
              PUT STREAM report x-nomaux.
              PUT STREAM report CONTROL P-dobleoff.
              DOWN STREAM REPORT WITH FRAME T-CAB.
              CON-CTA = CON-CTA + 1.
           END.
           IF FIRST-OF (T-REPORT.codcta) THEN DO:
              i = 0.
              x-condoc = 0.
              find cb-ctas WHERE cb-ctas.codcia = cb-codcia
                              AND cb-ctas.codcta = T-REPORT.codcta
                                NO-LOCK NO-ERROR.
              IF AVAILABLE cb-ctas THEN DO:
                 x-MoNcta = cb-ctas.codmon.
                 x-nomcta = T-REPORT.codcta + " " + cb-ctas.nomcta.
                 {&NEW-PAGE}.            
                 DISPLAY STREAM report WITH FRAME T-cab.
                 PUT STREAM report CONTROL P-dobleon.
                 PUT STREAM report x-nomcta.
                 PUT STREAM report CONTROL P-dobleoff.
                 DOWN STREAM REPORT WITH FRAME T-CAB.    
              END.
           END.
           ACCUMULATE T-debe  (SUB-TOTAL BY T-REPORT.nrodoc).
           ACCUMULATE T-haber (SUB-TOTAL BY T-REPORT.nrodoc).
           ACCUMULATE T-debe  (SUB-TOTAL BY T-REPORT.codcta).
           ACCUMULATE T-haber (SUB-TOTAL BY T-REPORT.codcta).
           ACCUMULATE T-debe  (SUB-TOTAL BY T-REPORT.codaux).
           ACCUMULATE T-haber (SUB-TOTAL BY T-REPORT.codaux).
           ACCUMULATE T-debe  (TOTAL) .
           ACCUMULATE T-haber (TOTAL) .
           X-CONREG = X-CONREG + 1. 
           IF LAST-OF(T-REPORT.NRODOC) AND X-CONREG > 0 THEN DO:
              Y-SALDO = (ACCUMULATE    SUB-TOTAL BY T-REPORT.NroDoc T-debe ) -
                        (ACCUMULATE    SUB-TOTAL BY T-REPORT.NroDoc T-haber) .
              {&NEW-PAGE}.
              DISPLAY STREAM REPORT 
                      T-REPORT.fchdoc 
                      T-REPORT.coddiv 
                      T-REPORT.cco    
                      T-REPORT.nroast 
                      T-REPORT.codope 
                      T-REPORT.nromes 
                      T-REPORT.coddoc 
                      T-REPORT.nrodoc 
                      T-REPORT.fchvto 
                      T-REPORT.NroRef
                      T-REPORT.glodoc 
                      T-REPORT.T-importe  WHEN T-IMPORTE <> 0
                      T-REPORT.T-debe     WHEN T-DEBE    <> 0 
                      T-REPORT.T-haber    WHEN T-HABER   <> 0
                      y-saldo @ t-saldo
                      WITH FRAME T-CAB.
              DOWN STREAM REPORT WITH FRAME T-CAB.
              UNDERLINE STREAM REPORT 
                        T-REPORT.fchdoc 
                        T-REPORT.coddiv 
                        T-REPORT.cco    
                        T-REPORT.nroast 
                        T-REPORT.codope 
                        T-REPORT.nromes 
                        T-REPORT.coddoc 
                        T-REPORT.nrodoc 
                        T-REPORT.fchvto 
                        T-REPORT.NroRef
                        T-REPORT.glodoc 
                        T-REPORT.T-importe  
                        T-REPORT.T-debe
                        T-REPORT.T-haber  
                        T-REPORT.T-saldo
                        WITH FRAME T-CAB.
              DOWN STREAM REPORT WITH FRAME T-CAB.    
              X-CONDOC = X-CONDOC + 1.
           END.
           ELSE DO:
                  {&NEW-PAGE}.
                  DISPLAY STREAM REPORT 
                          T-REPORT.fchdoc 
                          T-REPORT.coddiv 
                          T-REPORT.cco    
                          T-REPORT.nroast 
                          T-REPORT.codope 
                          T-REPORT.nromes 
                          T-REPORT.coddoc 
                          T-REPORT.nrodoc 
                          T-REPORT.fchvto 
                          T-REPORT.NroRef
                          T-REPORT.glodoc 
                          T-REPORT.T-importe  WHEN T-IMPORTE <> 0
                          T-REPORT.T-debe     WHEN T-DEBE    <> 0 
                          T-REPORT.T-haber    WHEN T-HABER   <> 0
                          WITH FRAME T-CAB.
                  DOWN STREAM REPORT WITH FRAME T-CAB.
           END.
           IF LAST-OF(T-REPORT.CODCTA)  THEN DO:
              Y-SALDO = (ACCUMULATE    SUB-TOTAL BY T-REPORT.CODCTA T-debe ) -
                        (ACCUMULATE    SUB-TOTAL BY T-REPORT.CODCTA T-haber) .
              DISPLAY STREAM REPORT
                      "T o t a l  C u e n t a"                          @ t-report.GloDoc
                      ACCUMULATE   SUB-TOTAL BY T-REPORT.CODCTA T-debe  @ t-debe 
                      ACCUMULATE   SUB-TOTAL BY T-REPORT.CODCTA T-haber @ t-haber
                      Y-SALDO                                           @ t-saldo
                      WITH FRAME T-CAB.
              DOWN STREAM REPORT WITH FRAME T-CAB.    
              UNDERLINE STREAM REPORT 
                        T-REPORT.fchdoc 
                        T-REPORT.coddiv 
                        T-REPORT.cco    
                        T-REPORT.nroast 
                        T-REPORT.codope 
                        T-REPORT.nromes 
                        T-REPORT.coddoc 
                        T-REPORT.nrodoc 
                        T-REPORT.fchvto 
                        T-REPORT.NroRef
                        T-REPORT.glodoc 
                        T-REPORT.T-importe  
                        T-REPORT.T-debe
                        T-REPORT.T-haber  
                        T-REPORT.T-saldo
                        WITH FRAME T-CAB.
              DOWN STREAM REPORT WITH WITH FRAME T-CAB.
           END.
           IF LAST-OF(T-REPORT.CODAUX) AND X-CONDOC > 0 THEN DO:
              Y-SALDO = (ACCUMULATE    SUB-TOTAL BY T-REPORT.CODAUX T-debe ) -
                        (ACCUMULATE    SUB-TOTAL BY T-REPORT.CODAUX T-haber) .
              DISPLAY STREAM REPORT
                      "Total   Auxiliar " @ T-REPORT.GLODOC
                      ACCUMULATE   SUB-TOTAL BY T-REPORT.CODAUX T-debe  @ t-debe 
                      ACCUMULATE   SUB-TOTAL BY T-REPORT.CODAUX T-haber @ t-haber
                      Y-SALDO                                           @ t-saldo
                      WITH FRAME T-CAB.
              DOWN STREAM REPORT WITH FRAME T-CAB.    
              UNDERLINE STREAM REPORT 
                        T-REPORT.fchdoc 
                        T-REPORT.coddiv 
                        T-REPORT.cco    
                        T-REPORT.nroast 
                        T-REPORT.codope 
                        T-REPORT.nromes 
                        T-REPORT.coddoc 
                        T-REPORT.nrodoc 
                        T-REPORT.fchvto 
                        T-REPORT.NroRef
                        T-REPORT.glodoc 
                        T-REPORT.T-importe  
                        T-REPORT.T-debe
                        T-REPORT.T-haber  
                        T-REPORT.T-saldo
                        WITH FRAME T-CAB.
              DOWN STREAM REPORT WITH WITH FRAME T-CAB.
           END.
       END.
       IF CON-CTA > 1 THEN DO:
          UNDERLINE STREAM REPORT 
                    T-REPORT.fchdoc 
                    T-REPORT.coddiv 
                    T-REPORT.cco    
                    T-REPORT.nroast 
                    T-REPORT.codope 
                    T-REPORT.nromes 
                    T-REPORT.coddoc 
                    T-REPORT.nrodoc 
                    T-REPORT.fchvto 
                    T-REPORT.NroRef
                    T-REPORT.glodoc 
                    T-REPORT.T-importe  
                    T-REPORT.T-debe
                    T-REPORT.T-haber  
                    T-REPORT.T-saldo
                    WITH FRAME T-CAB.
          DOWN STREAM REPORT WITH WITH FRAME T-CAB.
          Y-SALDO = (ACCUMULATE    TOTAL T-debe ) -
                    (ACCUMULATE    TOTAL T-haber) .
          DISPLAY STREAM REPORT
                  "T o t a l   G e n e r a l" @ t-report.glodoc
                  ACCUMULATE   TOTAL  T-debe  @ t-debe 
                  ACCUMULATE   TOTAL  T-haber @ t-haber
                  Y-SALDO                     @ t-saldo
                  WITH FRAME T-CAB.
          DOWN STREAM REPORT WITH FRAME T-CAB.    
       END. /* FIN DEL CON-CTA */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


