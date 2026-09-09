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
         HEIGHT             = 5.27
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
/* GENERACION DE ASIENTO CONTABLE DE VENTAS */

/*ML01*/ cRuc = T-CDOC.RucCli.

    IF T-CDOC.Flgest = 'A' THEN DO:
       x-codcta = IF T-CDOC.Coddoc = "FAC" THEN "12122100" ELSE "12121140".
       RUN Graba-Documentos (x-codcbd, x-codcta, NOT x-tpodoc, 0, x-coddoc, 08, 01,x-detalle, x-cco).         
       NEXT.        
    END.        
    RUN Graba-Documentos (x-codcbd, x-codcta, NOT x-tpodoc, T-CDOC.ImpTot, x-coddoc, 08, T-CDOC.codmon,x-detalle, x-cco).

    /* CUENTA DE IGV */
    IF T-CDOC.ImpIgv > 0 THEN DO:
      x-codcta = x-ctaigv.
/*       IF T-CDOC.coddoc = 'BOL' THEN DO:   */
/*           MESSAGE "BOLETA IGV " x-ctaigv. */
/*       END.                                */

      RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, T-CDOC.ImpIgv, x-coddoc, 06, T-CDOC.codmon,x-detalle, x-cco).
    END.

   /* CUENTA DE ISC */
   IF T-CDOC.ImpIsc > 0 THEN DO:
      x-codcta = x-ctaisc.
      RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, T-CDOC.ImpIsc, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
   END.
 
   /* CUENTA DE ICBPER */
   IF T-CDOC.AcuBon[10] > 0 THEN DO:
      x-codcta = x-CtaICBPER.
      RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, T-CDOC.AcuBon[10], x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
   END.

   /* CUENTA 70   --   Detalle  */
   IF T-CDOC.ImpBrt > 0 THEN DO:
       CASE T-CDOC.TpoFac:
       WHEN 'S' THEN DO:
           x-codcta = cb-cfgg.codcta[9].
           FOR FIRST CcbDDocu FIELDS
               (CcbDDocu.CodCia CcbDDocu.CodDiv
               CcbDDocu.CodDoc CcbDDocu.NroDoc CcbDDocu.CodMat) WHERE
               CcbDDocu.CodCia = T-CDOC.CodCia AND
               CcbDDocu.CodDiv = T-CDOC.CodDiv AND
               CcbDDocu.CodDoc = T-CDOC.CodDoc AND
               CcbDDocu.NroDoc = T-CDOC.NroDoc AND
               CcbDDocu.CodMat >= "" NO-LOCK:
           END.
           IF AVAILABLE CcbDDocu THEN DO:
               FOR FIRST almmserv FIELDS
                   (almmserv.Codcia almmserv.codmat almmserv.catconta) WHERE
                   almmserv.Codcia = CcbDDocu.CodCia AND
                   almmserv.CodMat = CcbDDocu.CodMat NO-LOCK:
               END.
               IF AVAILABLE almmserv THEN x-codcta = almmserv.catconta.
           END.
       END.
       WHEN 'A' THEN DO:    /* Adelanto Campaña */
           x-codcta = cb-cfgg.codaux[10].
       END.
       OTHERWISE x-codcta = cb-cfgg.codcta[5].
     END.
     RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, T-CDOC.ImpBrt, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
   END.

   IF T-CDOC.ImpDto > 0 THEN DO:
      x-codcta = x-ctadto.
      RUN Graba-Documentos (x-codcbd, x-codcta, NOT x-tpodoc, T-CDOC.ImpDto, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
   END.

   IF T-CDOC.ImpExo > 0 THEN DO:
      x-codcta = cb-cfgg.codcta[6]. 
      RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, T-CDOC.ImpExo, x-coddoc, 02, T-CDOC.codmon,x-detalle, x-cco).
   END.
       
   CASE T-CDOC.TpoFac:
       WHEN 'T' THEN DO:
           IF T-CDOC.ImpVta > 0 THEN DO:
              x-codcta = cb-cfgg.codcta[5]. 
              RUN Graba-Documentos (x-codcbd, x-codcta, NOT x-tpodoc, T-CDOC.ImpVta, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
           END.  
           IF T-CDOC.ImpExo > 0 THEN DO:
              x-codcta = cb-cfgg.codcta[6]. 
              RUN Graba-Documentos (x-codcbd, x-codcta, NOT x-tpodoc, T-CDOC.ImpExo, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
           END.
           IF T-CDOC.ImpIgv > 0 THEN DO:
              x-codcta = cb-cfgg.codaux[3].
              RUN Graba-Documentos (x-codcbd, x-codcta, NOT x-tpodoc, T-CDOC.ImpIgv, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
           END.
           IF T-CDOC.ImpIsc > 0 THEN DO:
              x-codcta = cb-cfgg.codaux[3].
              RUN Graba-Documentos (x-codcbd, x-codcta, NOT x-tpodoc, T-CDOC.ImpIsc, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
           END.
           ASSIGN
               X-codcta = IF T-CDOC.codmon = 1 THEN X-codCta1 ELSE X-CodCta2
               X-codcta = IF X-codcta = '' THEN X-CodCta1 ELSE X-codcta.
           RUN Graba-Documentos (x-codcbd, x-codcta, x-tpodoc, T-CDOC.ImpTot, x-coddoc, 01, T-CDOC.codmon,x-detalle, x-cco).
       END.
   END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


