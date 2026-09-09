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


  FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia AND FacTabla.tabla = 'TIPDTOPED' 
      BY FacTabla.Valor[1]:
      {&Condicion}
      CASE FacTabla.Codigo:
          WHEN "DVXDSF" THEN DO:
              RUN DCTO_VOL_LINEA IN hProc (INPUT ROWID(Faccpedi),
                                           INPUT s-TpoPed,
                                           INPUT s-CodDiv,
                                           OUTPUT pMensaje).
              IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
          END.
          WHEN "DVXSALDOC" THEN DO:
              RUN DCTO_VOL_SALDO IN hProc (INPUT ROWID(Faccpedi),
                                           INPUT s-TpoPed,
                                           INPUT s-CodDiv,
                                           OUTPUT pMensaje).
              IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
          END.
          WHEN "EDVXSALDOC" THEN DO:
              RUN DCTO_VOL_SALDO_EVENTO IN hProc (INPUT ROWID(Faccpedi),
                                                  INPUT s-TpoPed,
                                                  INPUT s-CodDiv,
                                                  OUTPUT pMensaje).
              IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
          END.
          WHEN "COT_DCTO_DESPACHO" THEN DO:
              RUN DCTO_PRONTO_DESPACHO IN hProc (INPUT ROWID(Faccpedi),
                                                 INPUT s-CodDiv,
                                                 OUTPUT pMensaje).
              IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
          END.
          WHEN "DXIMPACUM" THEN DO:
              RUN DCTO_IMP_ACUM IN hProc (INPUT ROWID(Faccpedi),
                                          INPUT s-CodDiv,
                                          OUTPUT pMensaje).
              IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
          END.
          WHEN "DXVACUMTIME" THEN DO:
              RUN DCTO_VOL_ACUM_TIME IN hProc (INPUT ROWID(Faccpedi),
                                               INPUT s-CodDiv,
                                               INPUT Faccpedi.CodCli,
                                               OUTPUT pMensaje).
              IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
          END.
          WHEN "DMASXMENOS" THEN DO:
              RUN DCTO_MAS_POR_MENOS IN hProc (INPUT ROWID(Faccpedi),
                                               INPUT s-CodDiv,
                                               OUTPUT pMensaje).
              IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
          END.
      END CASE.
  END.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


