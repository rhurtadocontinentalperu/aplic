&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library     : 
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
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

FOR EACH Gn-Divi WHERE Gn-Divi.Codcia = S-CodCia
        use-index Idx01 
        no-lock :
   
        FOR EACH CcbCdocu WHERE CcbCdocu.CodCia = S-CODCIA 
                            AND CcbCdocu.CodDiv = Gn-Divi.CodDiv
                            AND CcbCdocu.FchDoc >= x-CodFchI
                            AND CcbCdocu.FchDoc <= x-CodFchF
                            USE-INDEX llave10
                            BREAK BY CcbCdocu.CodCia
                                  BY CcbCdocu.CodDiv
                                  BY CcbCdocu.FchDoc:
            /* ***************** FILTROS ********************************** */
            IF Lookup(CcbCDocu.CodDoc,"TCK,FAC,BOL,N/C,N/D") = 0 THEN NEXT.
            IF CcbCDocu.FlgEst = "A"  THEN NEXT.
            IF CcbCDocu.ImpCto = ? THEN DO:
                CcbCDocu.ImpCto = 0.
            END.
            IF DAY(CcbCDocu.FchDoc) = 0 OR DAY(CcbCDocu.FchDoc) = ?
            THEN NEXT.
            /* *********************************************************** */
            x-signo1 = IF CcbCdocu.Coddoc = "N/C" THEN -1 ELSE 1.
            DISPLAY CcbCdocu.Codcia
                    CcbCdocu.Coddiv
                    CcbCdocu.FchDoc 
                    CcbCdocu.CodDoc
                    CcbCdocu.NroDoc
                    STRING(TIME,'HH:MM')
                    TODAY .
            PAUSE 0.
     
            ASSIGN
                x-Day   = DAY(CcbCdocu.FchDoc)
                x-Month = MONTH(CcbCdocu.FchDoc)
                x-Year  = YEAR(CcbCdocu.FchDoc).
                FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= CcbCdocu.FchDoc
                                  USE-INDEX Cmb01
                                  NO-LOCK NO-ERROR.
                IF NOT AVAIL Gn-Tcmb THEN 
                    FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= CcbCdocu.FchDoc
                                       USE-INDEX Cmb01
                                       NO-LOCK NO-ERROR.
                IF AVAIL Gn-Tcmb THEN 
                    ASSIGN
                    x-TpoCmbCmp = Gn-Tcmb.Compra
                    x-TpoCmbVta = Gn-Tcmb.Venta.
            
            IF Ccbcdocu.CodMon = 1 THEN 
                ASSIGN
                    EvtDivi.VtaxMesMn = EvtDivi.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot
                    EvtDivi.VtaxMesMe = EvtDivi.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot / x-TpoCmbCmp.
            IF Ccbcdocu.CodMon = 2 THEN 
                ASSIGN
                    EvtDivi.VtaxMesMn = EvtDivi.VtaxMesMn + x-signo1 * CcbCdocu.ImpTot * x-TpoCmbVta
                    EvtDivi.VtaxMesMe = EvtDivi.VtaxMesMe + x-signo1 * CcbCdocu.ImpTot.


           IF CcbCdocu.Coddoc = "N/C" AND CcbCdocu.CndCre = "N" THEN RUN PROCESA-NOTA.

           FOR EACH CcbDdocu OF CcbCdocu NO-LOCK:
               
               FIND Almmmatg WHERE Almmmatg.Codcia = CcbDdocu.Codcia AND
                                   Almmmatg.CodMat = CcbDdocu.CodMat NO-LOCK NO-ERROR.
               IF NOT AVAILABLE Almmmatg THEN NEXT.
               FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND  
                                   Almtconv.Codalter = Ccbddocu.UndVta
                                   NO-LOCK NO-ERROR.
               F-FACTOR  = 1. 
               IF AVAILABLE Almtconv THEN DO:
                  F-FACTOR = Almtconv.Equival.
                  IF Almmmatg.FacEqu <> 0 THEN F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
               END.
               
               IF Ccbcdocu.CodMon = 1 THEN 
                    ASSIGN
                        EvtArti.VtaxMesMn = EvtArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin
                        EvtArti.VtaxMesMe = EvtArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin / x-TpoCmbCmp.
               IF Ccbcdocu.CodMon = 2 THEN 
                    ASSIGN
                        EvtArti.VtaxMesMn = EvtArti.VtaxMesMn + x-signo1 * CcbDdocu.ImpLin * x-TpoCmbVta
                        EvtArti.VtaxMesMe = EvtArti.VtaxMesMe + x-signo1 * CcbDdocu.ImpLin.
               ASSIGN            
               EvtArti.CanxMes = EvtArti.CanxMes + ( x-signo1 * CcbDdocu.CanDes * F-FACTOR ).

           END.  
        END.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


