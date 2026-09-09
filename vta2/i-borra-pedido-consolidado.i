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

  DEFINE VARIABLE r-Rowid AS ROWID NO-UNDO.

  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      /* Bloqueamos Cabeceras */
      FIND PEDIDO WHERE PEDIDO.codcia = Faccpedi.codcia
          AND PEDIDO.coddoc = Faccpedi.codref
          AND PEDIDO.nroped = Faccpedi.nroref
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE PEDIDO THEN DO:
          pMensaje = "NO se pudo extornar el " + PEDIDO.codref + " " + PEDIDO.nroref.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      FIND FIRST COTIZACION WHERE COTIZACION.codcia = PEDIDO.codcia
          AND COTIZACION.coddiv = PEDIDO.coddiv
          AND COTIZACION.coddoc = PEDIDO.codref
          AND COTIZACION.nroped = PEDIDO.nroref
          EXCLUSIVE-LOCK NO-ERROR.
      IF ERROR-STATUS:ERROR = YES THEN DO:
          pMensaje = "NO se pudo extornar la " + COTIZACION.codref + " " + COTIZACION.nroref.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      /* Actualizamos saldo de cotización */
      FIND FIRST B-DPEDI WHERE B-DPEDI.codcia = COTIZACION.codcia
          AND B-DPEDI.coddiv = COTIZACION.coddiv
          AND B-DPEDI.coddoc = COTIZACION.coddoc
          AND B-DPEDI.nroped = COTIZACION.nroped
          AND B-DPEDI.codmat = PEDI.codmat
          AND B-DPEDI.libre_c05 = PEDI.libre_c05    /* Producto Promocional */
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-DPEDI THEN DO:
          pMensaje = "ERROR EN COTIZACION" + CHR(10) +
              "No se pudo extornar el artículo " + PEDI.codmat.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      ASSIGN
          B-DPEDI.canate = B-DPEDI.canate - PEDI.canped.
      ASSIGN
          COTIZACION.FlgEst = "P".
      /* Borramos detalles PEDIDO */
      FIND FIRST B-DPEDI WHERE B-DPEDI.codcia = PEDIDO.codcia
          AND B-DPEDI.coddiv = PEDIDO.coddiv
          AND B-DPEDI.coddoc = PEDIDO.coddoc
          AND B-DPEDI.nroped = PEDIDO.nroped
          AND B-DPEDI.codmat = PEDI.codmat
          AND B-DPEDI.libre_c05 = PEDI.libre_c05    /* Producto Promocional */
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-DPEDI THEN DO:
          pMensaje = "ERROR EN PEDIDO" + CHR(10) +
              "No se pudo extornar el artículo " + PEDI.codmat.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      DELETE B-DPEDI.
      /* Borramos detalle O/D */
      FIND FIRST B-DPEDI WHERE B-DPEDI.codcia = PEDI.codcia
          AND B-DPEDI.coddiv = PEDI.coddiv
          AND B-DPEDI.coddoc = PEDI.coddoc      /* O/D */
          AND B-DPEDI.nroped = PEDI.nroped
          AND B-DPEDI.codmat = PEDI.codmat
          AND B-DPEDI.libre_c05 = PEDI.libre_c05
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-DPEDI THEN DO:
          pMensaje = "ERROR EN O/D" + CHR(10) +
              "No se pudo extornar el artículo " + PEDI.codmat.
          UNDO, RETURN 'ADM-ERROR'.
      END.
      DELETE B-DPEDI.

      ASSIGN r-Rowid = ROWID(Faccpedi).
      RUN Recalcular-Pedido.
      FIND Faccpedi WHERE ROWID(Faccpedi) = r-Rowid.
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          pMensaje = "NO se pudo recalcular el " + PEDIDO.codref + " " + PEDIDO.nroref.
          UNDO, RETURN 'ADM-ERROR'.
      END.

  END.
  RETURN 'OK'.

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
         HEIGHT             = 4.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


