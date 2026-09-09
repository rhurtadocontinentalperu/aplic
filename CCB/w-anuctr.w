ME-NAME}:     
           DISPLAY FILL-IN_Saldo
                   FILL-IN_ImpNac5
                   FILL-IN_ImpUsa5
                   FILL-IN_ImpUsa1.
        END.
        FIND cb-tabl WHERE cb-tabl.Tabla = "04" 
                      AND  cb-tabl.codigo = CcbBolDep.CodBco
                     NO-LOCK NO-ERROR.
        IF AVAILABLE cb-tabl THEN 
            ASSIGN 
                FILL-IN_CodBco5:SCREEN-VALUE = cb-tabl.codigo
                FILL-IN-5:SCREEN-VALUE = cb-tabl.Nombre.
        ELSE 
            ASSIGN
                FILL-IN_CodBco5:SCREEN-VALUE = ""
                FILL-IN-5:SCREEN-VALUE = "".  
   END.
   ELSE DO:
       MESSAGE "Nro. de Documento no Registrado" skip
               "o no pertenece al Cliente Seleccionado" VIEW-AS ALERT-BOX ERROR.
       RETURN NO-APPLY.
   END.
   
   RUN _habilita.
   RUN Calculo.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_Voucher6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_Voucher6 D-Dialog
ON LEAVE OF FILL-IN_Voucher6 IN FRAME D-Dialog
DO:
  ASSIGN
     FILL-IN_Voucher6.
  IF FILL-IN_Voucher6 <> ' ' THEN DO:
     FIND CcbCDocu WHERE CcbCDocu.CodCia = s-codcia AND
          CcbCDocu.CodDoc = 'N/C' AND CcbCDocu.NroDoc = FILL-IN_Voucher6 NO-LOCK NO-ERROR.
     IF NOT AVAILABLE CcbCDocu THEN DO:
        MESSAGE 'Nota de Credito no existe' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.
/*   IF CcbCDocu.Codcli <> wcodcli THEN DO:
        MESSAGE 'Nota de Credito no corresponde al cliente' VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.*/
     IF CcbCDocu.FlgEst = 'C' THEN DO:
        MESSAGE 'Documento se encuentra asignado ' + CcbCDocu.CodRef + '-' + CcbCDocu.NroRef
                VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
     END.
     IF CcbCDocu.Codmon = 1 THEN
        DO WITH FRAME {&FRAME-NAME}:
           DISPLAY CcbCDocu.SdoAct @ FILL-IN_ImpNac6.
           FILL-IN_ImpUsa6:SENSITIVE = FALSE.
        END.   
     ELSE
        DO WITH FRAME {&FRAME-NAME}:
           DISPLAY CcbCDocu.SdoAct @ FILL-IN_ImpUsa6.
           FILL-IN_ImpNac6:SENSITIVE = FALSE.
        END.  
     X-SdoNc  = CcbCDocu.SdoAct.      
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_VueNac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_VueNac D-Dialog
ON LEAVE OF FILL-IN_VueNac IN FRAME D-Dialog
DO:
  DEF VAR X-CAL AS DECI INIT 0.
  
  IF DECI(FILL-IN_VueNac:SCREEN-VALUE) =  FILL-IN_VueNac THEN RETURN .
  

  IF DECI(FILL-IN_VueNac:SCREEN-VALUE) > FILL-IN_VueNac AND FILL-IN_VueUsa = 0 THEN DO: /*RETURN.*/
       MESSAGE "Operacion Incorrecta, Vuelva a intentar " VIEW-AS ALERT-BOX ERROR.
       DO WITH FRAME {&FRAME-NAME}:
           DISPLAY FILL-IN_VueNac.  
       END.   
       RETURN NO-APPLY.
  END.
  IF DECI(FILL-IN_VueNac:SCREEN-VALUE) < FILL-IN_VueNac AND FILL-IN_ImpUsa1 = 0 THEN DO: /*RETURN.*/
       MESSAGE "Operacion Incorrecta, Vuelva a intentar " VIEW-AS ALERT-BOX ERROR.
       DO WITH FRAME {&FRAME-NAME}:
           DISPLAY FILL-IN_VueNac.  
       END.   
       RETURN NO-APPLY.
  END.
  X-CAL = FILL-IN_VueNac - DECI(FILL-IN_VueNac:SCREEN-VALUE).
  X-CAL = ROUND( X-CAL / FILL-IN_TpoCmb, 2 ).
  X-CAL = X-CAL + DECI(FILL-IN_VueUsa:SCREEN-VALUE).
  
  IF DECI(FILL-IN_ImpUsa1:SCREEN-VALUE) < X-CAL OR X-CAL <0 THEN DO: /*RETURN.*/
       MESSAGE "Operacion Incorrecta, Vuelva a intentar " VIEW-AS ALERT-BOX ERROR.
       DO WITH FRAME {&FRAME-NAME}:
           DISPLAY FILL-IN_VueNac.  
       END.   
       RETURN NO-APPLY.
  END.
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN FILL-IN_VueNac 
            FILL-IN_VueUsa = X-CAL.
     DISPLAY FILL-IN_VueNac FILL-IN_VueUsa.  
     
  END.   

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_VueUsa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_VueUsa D-Dialog
ON LEAVE OF FILL-IN_VueUsa IN FRAME D-Dialog
DO:
  DEF VAR X-CAL AS DECI INIT 0.
  
  IF DECI(FILL-IN_VueUsa:SCREEN-VALUE) =  FILL-IN_VueUsa THEN RETURN .
  

  IF DECI(FILL-IN_VueUsa:SCREEN-VALUE) > FILL-IN_ImpUsa1 OR DECI(FILL-IN_VueUsa:SCREEN-VALUE) < 0 THEN DO: /*RETURN.*/
       MESSAGE "Operacion Incorrecta, Vuelva a intentar " VIEW-AS ALERT-BOX ERROR.
       DO WITH FRAME {&FRAME-NAME}:
           DISPLAY FILL-IN_VueUsa.  
       END.   
       RETURN NO-APPLY.
  END.

  X-CAL = FILL-IN_VueUsa - DECI(FILL-IN_VueUsa:SCREEN-VALUE).
  X-CAL = ROUND( X-CAL * FILL-IN_TpoCmb, 2 ).
  X-CAL = X-CAL + DECI(FILL-IN_VueNac:SCREEN-VALUE).
  
  IF  X-CAL < 0 THEN DO: /*RETURN.*/
       MESSAGE "Operacion Incorrecta, Vuelva a intentar " VIEW-AS ALERT-BOX ERROR.
       DO WITH FRAME {&FRAME-NAME}:
           DISPLAY FILL-IN_VueUsa.  
       END.   
       RETURN NO-APPLY.
  END.
  
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN FILL-IN_VueUsa 
            FILL-IN_VueNac = X-CAL.
     DISPLAY FILL-IN_VueNac FILL-IN_VueUsa.  
     
  END.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-Codmon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-Codmon D-Dialog
ON VALUE-CHANGED OF R-Codmon IN FRAME D-Dialog
DO:
  /*
  ASSIGN R-Codmon.
  IF SELF:SCREEN-VALUE = "1" THEN DO:
     FILL-IN_VueNac = fSumSol + ROUND( fSumDol * FILL-IN_TpoCmb, 2 ) - X-SdoNac.
     FILL-IN_VueUsa = 0.
  END.
  ELSE DO :
     FILL-IN_VueUsa = fSumDol + ROUND( fSumSol / FILL-IN_TpoCmb, 2 ) - X-SdoUsa.
     FILL-IN_VueNac = 0.
  END.
  DISPLAY FILL-IN_VueNac FILL-IN_VueUsa WITH FRAME D-Dialog.
 */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME X-SdoAct
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL X-SdoAct D-Dialog
ON LEAVE OF X-SdoAct IN FRAME D-Dialog
DO:
  ASSIGN X-SdoAct.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo D-Dialog 
PROCEDURE Calculo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME D-Dialog:
   ASSIGN
        FILL-IN_ImpNac1 FILL-IN_ImpNac2 FILL-IN_ImpNac4 FILL-IN_ImpNac5 
        FILL-IN_ImpNac6 
        FILL-IN_ImpUsa1 FILL-IN_ImpUsa2 FILL-IN_ImpUsa4 FILL-IN_ImpUsa5 
        FILL-IN_ImpUsa6 
        FILL-IN_CodBco2  FILL-IN_CodBco4
        FILL-IN_Voucher2 FILL-IN_Voucher4
        FILL-IN_TpoCmb  .
        
   fSumSol = (FILL-IN_ImpNac1 + FILL-IN_ImpNac2 + 
              FILL-IN_ImpNac4 + FILL-IN_ImpNac5 + 
              FILL-IN_ImpNac6 ). 
              
   fSumDol = (FILL-IN_ImpUsa1 + FILL-IN_ImpUsa2 + 
              FILL-IN_ImpUsa4 + FILL-IN_ImpUsa5 + 
              FILL-IN_ImpUsa6 ).
              
   FILL-IN_VueNac = 0.
   FILL-IN_VueUsa = 0.
   IF R-Codmon = 1 THEN
      FILL-IN_VueNac = ROUND(fSumSol + ROUND( fSumDol * FILL-IN_TpoCmb, 2 ) - X-SdoNac, 2).
   IF R-Codmon = 2 THEN
      FILL-IN_VueUsa = ROUND(fSumDol + ROUND( fSumSol / FILL-IN_TpoCmb, 2 ) - X-SdoUsa, 2).

   DISPLAY FILL-IN_VueNac FILL-IN_VueUsa WITH FRAME D-Dialog.
   

END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY R-Codmon F-cliente X-CodMon X-SdoAct FILL-IN_ImpNac1 FILL-IN_ImpNac2 
          FILL-IN_ImpNac4 FILL-IN_ImpNac5 FILL-IN_ImpNac6 FILL-IN_VueNac 
          FILL-IN_ImpUsa1 FILL-IN_ImpUsa2 FILL-IN_ImpUsa4 FILL-IN_ImpUsa5 
          FILL-IN_ImpUsa6 FILL-IN_VueUsa FILL-IN_Voucher2 C-tipdoc 
          FILL-IN_Voucher5 FILL-IN_Voucher6 FILL-IN_TpoCmb FILL-IN_Voucher4 
          FILL-IN_CodBco2 FILL-IN_CodBco4 FILL-IN_CodBco5 FILL-IN-3 FILL-IN-4 
          FILL-IN-5 F-NroRec F-Presen FILL-IN_Saldo F-TipCom F-Numfac 
      WITH FRAME D-Dialog.
  ENABLE RECT-6 RECT-32 RECT-5 RECT-9 RECT-7 RECT-4 RECT-10 RECT-8 Btn_OK 
         R-Codmon Btn_Cancel FILL-IN_ImpNac1 FILL-IN_ImpNac2 FILL-IN_ImpNac4 
         FILL-IN_ImpNac5 FILL-IN_ImpNac6 FILL-IN_VueNac FILL-IN_ImpUsa1 
         FILL-IN_ImpUsa2 FILL-IN_ImpUsa4 FILL-IN_ImpUsa5 FILL-IN_ImpUsa6 
         FILL-IN_VueUsa FILL-IN_Voucher2 C-tipdoc FILL-IN_Voucher5 
         FILL-IN_Voucher6 FILL-IN_Voucher4 FILL-IN_CodBco2 F-Presen 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*-----------------------------------------