&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

  RUN Procesa-Handle IN lh_handle ('pagina2').
  DO WITH FRAME {&FRAME-NAME}:
      /* CORRELATIVO */
      FIND Vtacordiv WHERE Vtacordiv.codcia = s-codcia
          AND Vtacordiv.coddiv = s-coddiv
          AND Vtacordiv.coddoc = s-codped
          AND Vtacordiv.nroser = s-nroser
          NO-LOCK NO-ERROR.
      /* *********** */
      s-codmon = 1.
      s-flgigv = YES.
      s-porigv = FacCfgGn.PorIgv.
      FIND TcmbCot WHERE TcmbCot.Codcia = cb-codcia AND  
          (TcmbCot.Rango1 <= TODAY - TODAY + 1 AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
          NO-LOCK NO-ERROR.
      IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  
      /* Fechas */
      DISPLAY
          STRING(VtaCorDiv.NroSer, '999') + STRING(VtaCorDiv.NroCor, '999999') @ Vtacdocu.nroped
          TODAY @ Vtacdocu.fchped
          TODAY + s-DiasVtoCot @ Vtacdocu.fchven
          TODAY + s-DiasVtoCot @ Vtacdocu.fchent
          s-tpocmb @ Vtacdocu.tpocmb.
      ASSIGN
          Vtacdocu.flgigv:SCREEN-VALUE = STRING(s-flgigv)
          Vtacdocu.codmon:SCREEN-VALUE = STRING(s-codmon).

      /* Vendedor */
      FIND facusers WHERE facusers.codcia = s-codcia
          AND FacUsers.Usuario = s-user-id
          NO-LOCK NO-ERROR.
      FIND gn-ven WHERE gn-ven.codcia = s-codcia
          AND gn-ven.codven = facusers.codven
          NO-LOCK NO-ERROR.
      DISPLAY
          FacUsers.codven @ Vtacdocu.codven
          ( IF AVAILABLE gn-ven THEN gn-ven.nomven ELSE '') @ f-NomVen.
      IF AVAILABLE gn-ven
      THEN Vtacdocu.codven:SENSITIVE = YES.
      ELSE Vtacdocu.codven:SENSITIVE = NO.
      /* Botones de consultas */
      ASSIGN
          VtaCDocu.CodCli:SENSITIVE = YES.
      IF NOT AVAILABLE gn-ven 
      THEN ASSIGN
                VtaCDocu.CodVen:SENSITIVE = YES.
      ELSE ASSIGN
                VtaCDocu.CodVen:SENSITIVE = NO.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


