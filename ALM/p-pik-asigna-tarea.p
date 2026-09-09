&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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

  DEF INPUT PARAMETER pCodDiv AS CHAR.
  DEF INPUT PARAMETER pPicador AS CHAR.
  DEF INPUT PARAMETER pPedidos AS CHAR.     /* Ej. O/D|0021023546-04,OTR|124568792-02 */
  DEF INPUT PARAMETER pPrioridad AS CHAR.

  DEF SHARED VAR s-codcia AS INT.
  DEF SHARED VAR s-user-id AS CHAR.

  DEF VAR pCodPed AS CHAR NO-UNDO.
  DEF VAR pNroPed AS CHAR NO-UNDO.
  DEF VAR LocalItem AS INT NO-UNDO.
  DEF VAR x-ordenes-ori AS CHAR NO-UNDO.
  DEF VAR x-codori AS CHAR NO-UNDO.
  DEF VAR x-nroori AS CHAR NO-UNDO.
  DEF VAR x-sec AS INT NO-UNDO.
  DEF VAR lItems AS INT NO-UNDO.
  DEF VAR lImporte AS DEC NO-UNDO.
  DEF VAR lPeso AS DEC NO-UNDO.
  DEF VAR lVolumen AS DEC NO-UNDO.

  DEF BUFFER x-vtacdocu FOR Vtacdocu.

  CICLO:
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      {lib/lock-genericov3.i 
          &Tabla="PikSacadores"
          &Alcance="FIRST"
          &Condicion="PikSacadores.CodCia = s-codcia
          AND PikSacadores.CodDiv = pCodDiv
          AND PikSacadores.CodPer = pPicador
          AND pikSacadores.FlgEst = 'A'"
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
          &Accion="RETRY"
          &Mensaje="YES"
          &TipoError="UNDO, RETURN 'ADM-ERROR'"
          }
      
      DO LocalItem = 1 TO NUM-ENTRIES(pPedidos) 
          ON ERROR UNDO CICLO, RETURN 'ADM-ERROR' ON STOP UNDO CICLO, RETURN 'ADM-ERROR':
          pCodPed = ENTRY(1,ENTRY(LocalItem,pPedidos),'|').
          pNroPed = ENTRY(2,ENTRY(LocalItem,pPedidos),'|').
          
          FOR EACH Vtacdocu EXCLUSIVE-LOCK WHERE Vtacdocu.codcia = s-codcia
              AND Vtacdocu.divdes = pCodDiv
              AND Vtacdocu.codped = pCodPed
              AND Vtacdocu.nroped = pNroPed:
              MESSAGE 'dentro'.
              /* Volvemos a chequear las condiciones */
/*               IF NOT (Vtacdocu.flgest = 'P' AND Vtacdocu.flgsit = 'T') THEN DO:           */
/*                   MESSAGE  'ERROR en la Sub-Orden ' + pCodPed + ' ' + pNroPed + CHR(10) + */
/*                   'Ya NO está pendiente de Pickeo'.                                       */
/*                   UNDO CICLO, RETURN 'ADM-ERROR'.                                         */
/*               END.                                                                        */
              ASSIGN 
                  Vtacdocu.usrsac = PikSacadores.CodPer
                  Vtacdocu.fecsac = TODAY
                  Vtacdocu.horsac = STRING(TIME,'HH:MM:SS')
                  Vtacdocu.ubigeo[4] = PikSacadores.CodPer
                  Vtacdocu.usrsacasign   = s-user-id
                  Vtacdocu.fchinicio = NOW
                  Vtacdocu.usuarioinicio = s-user-id
                  Vtacdocu.FlgSit    = "P".     /* En Proceso de Picking (APOD) */
              ASSIGN
                  Vtacdocu.Libre_c02 = pPrioridad.
              ASSIGN 
                  Vtacdocu.items     = 0
                  Vtacdocu.peso      = 0
                  Vtacdocu.volumen   = 0.
              IF vtacdocu.codped = 'ODC' OR vtacdocu.codped = 'OTC' OR vtacdocu.codped = 'OTM' THEN DO:
                  /* Ordenes consolidadas */
                  x-ordenes-ori = TRIM(vtacdocu.nroori).
                  x-codori = TRIM(vtacdocu.codori).
                  REPEAT x-sec = 1 TO NUM-ENTRIES(x-ordenes-ori,","):
                      x-nroori = ENTRY(x-sec,x-ordenes-ori,",").
                      FIND FIRST x-vtacdocu WHERE x-vtacdocu.codcia = s-codcia AND 
                          x-vtacdocu.codped = x-codori AND 
                          x-vtacdocu.nroped = x-nroori NO-ERROR.
                      IF AVAILABLE x-vtacdocu THEN DO:
                          ASSIGN 
                              x-Vtacdocu.usrsac = Vtacdocu.usrsac
                              x-Vtacdocu.fecsac = Vtacdocu.fecsac
                              x-Vtacdocu.horsac = Vtacdocu.horsac
                              x-Vtacdocu.ubigeo[4] = Vtacdocu.ubigeo[4]
                              x-Vtacdocu.usrsacasign = Vtacdocu.usrsacasign
                              x-Vtacdocu.fchinicio = Vtacdocu.fchinicio
                              x-Vtacdocu.usuarioinicio = Vtacdocu.usuarioinicio
                              x-Vtacdocu.FlgSit    = Vtacdocu.FlgSit.     /* En Proceso de Picking (APOD) */
                          /* Importes */
                          RUN ue-get-cantidades(INPUT x-VtaCDocu.codped, INPUT x-VtaCDocu.nroped,
                                                OUTPUT lItems, OUTPUT lImporte,
                                                OUTPUT lPeso, OUTPUT lVolumen).

                          /* SubOrden */ 
                          ASSIGN  
                              x-Vtacdocu.items     = lItems
                              x-Vtacdocu.peso      = lPeso
                              x-Vtacdocu.volumen   = lVolumen.
                          /* Consolidada ??? */
                          ASSIGN  
                              Vtacdocu.items     = Vtacdocu.items + lItems
                              Vtacdocu.peso      = Vtacdocu.peso + lPeso
                              Vtacdocu.volumen   = Vtacdocu.volumen + lVolumen.
                          /* TRACKING */
                          RUN vtagn/pTracking-04 (s-CodCia,
                                                  pCodDiv,
                                                  x-Vtacdocu.CodRef,
                                                  x-Vtacdocu.NroRef,
                                                  s-User-Id,
                                                  'APOD',
                                                  'P',
                                                  DATETIME(TODAY, MTIME),
                                                  DATETIME(TODAY, MTIME),
                                                  x-Vtacdocu.CodPed,
                                                  x-Vtacdocu.NroPed,
                                                  x-Vtacdocu.CodPed,
                                                  ENTRY(1,x-Vtacdocu.NroPed,'-')).
                      END.
                  END.
              END.
              ELSE DO:
                  /* Importes */
                  RUN ue-get-cantidades(INPUT VtaCDocu.codped, INPUT VtaCDocu.nroped,
                                        OUTPUT lItems, OUTPUT lImporte,
                                        OUTPUT lPeso, OUTPUT lVolumen).
                  ASSIGN  
                      Vtacdocu.items     = lItems
                      Vtacdocu.peso      = lPeso
                      Vtacdocu.volumen   = lVolumen.
                  /* TRACKING */
                  RUN vtagn/pTracking-04 (s-CodCia,
                                          pCodDiv,
                                          Vtacdocu.CodRef,
                                          Vtacdocu.NroRef,
                                          s-User-Id,
                                          'APOD',
                                          'P',
                                          DATETIME(TODAY, MTIME),
                                          DATETIME(TODAY, MTIME),
                                          Vtacdocu.CodPed,
                                          Vtacdocu.NroPed,
                                          Vtacdocu.CodPed,
                                          ENTRY(1,Vtacdocu.NroPed,'-')).
              END.
              /* Pickeador ocupado */
              ASSIGN  
                  PikSacadores.FlgTarea = 'O'.    /* OCUPADO */
              
          END.
      END.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.58
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ue-get-cantidades) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-get-cantidades Procedure 
PROCEDURE ue-get-cantidades :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE OUTPUT PARAMETER pItems AS INT.
DEFINE OUTPUT PARAMETER pImporte AS DEC.
DEFINE OUTPUT PARAMETER pPeso AS DEC.
DEFINE OUTPUT PARAMETER pVolumen AS DEC.

pItems = 0.
pImporte = 0.
pPeso = 0.
pVolumen = 0.
FOR EACH VtaDDocu OF VtaCDocu NO-LOCK,
        FIRST almmmatg OF VtaDDocu NO-LOCK:
    pItems = pItems + 1.
    pImporte = pImporte + VtaDDocu.implin.
    pPeso = pPeso + ((VtaDDocu.canped * VtaDDocu.factor) * Almmmatg.pesmat).
    pVolumen = pVolumen + ((VtaDDocu.canped * VtaDDocu.factor) * Almmmatg.libre_d02).
END.
pVolumen = (pVolumen / 1000000).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

