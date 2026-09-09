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

        CASE (PL-MOV-MES.CodMov):
            WHEN 100 THEN ASSIGN t-totvvv[15] = PL-MOV-MES.valcal-mes.
            WHEN 101 THEN ASSIGN t-totvvv[16] = PL-MOV-MES.valcal-mes.
            WHEN 103 THEN ASSIGN t-totvvv[17] = PL-MOV-MES.valcal-mes.
            WHEN 134 THEN ASSIGN t-totvvv[19] = PL-MOV-MES.valcal-mes.
            WHEN 209 THEN ASSIGN t-totvvv[20] = PL-MOV-MES.valcal-mes.
            WHEN 202 THEN ASSIGN t-totvvv[21] = PL-MOV-MES.valcal-mes.
            WHEN 206 THEN ASSIGN t-totvvv[22] = PL-MOV-MES.valcal-mes.
            WHEN 205 OR WHEN 207 OR WHEN 208 OR WHEN 211 OR WHEN 227
                THEN ASSIGN t-totvvv[23] = t-totvvv[23] + PL-MOV-MES.valcal-mes.
            WHEN 215 THEN ASSIGN t-totvvv[24] = PL-MOV-MES.valcal-mes.
            WHEN 221 OR WHEN 222 OR WHEN 223 OR WHEN 225 
                THEN ASSIGN t-totvvv[25] = t-totvvv[25] + PL-MOV-MES.valcal-mes.
            WHEN 204 THEN ASSIGN t-totvvv[26] = PL-MOV-MES.valcal-mes.
            WHEN 401 THEN ASSIGN t-totvvv[27] = PL-MOV-MES.valcal-mes.
            WHEN 402 THEN ASSIGN t-totvvv[28] = PL-MOV-MES.valcal-mes.
            WHEN 403 THEN ASSIGN t-totvvv[29] = PL-MOV-MES.valcal-mes.
            WHEN 301 THEN ASSIGN t-totvvv[30] = PL-MOV-MES.valcal-mes.
            WHEN 306 THEN ASSIGN t-totvvv[31] = PL-MOV-MES.valcal-mes.
            WHEN 508 THEN ASSIGN t-totvvv[32] = PL-MOV-MES.valcal-mes.
            WHEN 509 THEN ASSIGN t-totvvv[33] = PL-MOV-MES.valcal-mes.
            WHEN 510 THEN ASSIGN t-totvvv[34] = PL-MOV-MES.valcal-mes.
            WHEN 228 THEN ASSIGN t-totvvv[35] = PL-MOV-MES.valcal-mes.
            WHEN 220 THEN ASSIGN t-totvvv[36] = PL-MOV-MES.valcal-mes.
            /* 15/01/2025 Alex Quiroz, datos adicionales, dias inasistencias */
            WHEN 501 OR WHEN 502 THEN ASSIGN t-totvvv[37] = t-totvvv[37] + PL-MOV-MES.valcal-mes.

            WHEN 104 THEN t-totvvo[01] = t-totvvo[01] + PL-MOV-MES.valcal-mes.
            WHEN 106 THEN t-totvvo[02] = t-totvvo[02] + PL-MOV-MES.valcal-mes.
            WHEN 107 THEN t-totvvo[03] = t-totvvo[03] + PL-MOV-MES.valcal-mes.
            WHEN 108 THEN t-totvvo[04] = t-totvvo[04] + PL-MOV-MES.valcal-mes.
            WHEN 109 THEN t-totvvo[05] = t-totvvo[05] + PL-MOV-MES.valcal-mes.
            WHEN 111 THEN t-totvvo[06] = t-totvvo[06] + PL-MOV-MES.valcal-mes.
            WHEN 112 THEN t-totvvo[07] = t-totvvo[07] + PL-MOV-MES.valcal-mes.
            WHEN 113 THEN t-totvvo[08] = t-totvvo[08] + PL-MOV-MES.valcal-mes.
            WHEN 115 THEN t-totvvo[09] = t-totvvo[09] + PL-MOV-MES.valcal-mes.
            WHEN 116 THEN t-totvvo[10] = t-totvvo[10] + PL-MOV-MES.valcal-mes.
            WHEN 117 THEN t-totvvo[11] = t-totvvo[11] + PL-MOV-MES.valcal-mes.
            WHEN 118 THEN t-totvvo[12] = t-totvvo[12] + PL-MOV-MES.valcal-mes.
            WHEN 119 THEN t-totvvo[13] = t-totvvo[13] + PL-MOV-MES.valcal-mes.
            WHEN 125 THEN t-totvvo[14] = t-totvvo[14] + PL-MOV-MES.valcal-mes.
            WHEN 126 THEN t-totvvo[15] = t-totvvo[15] + PL-MOV-MES.valcal-mes.
            WHEN 127 THEN t-totvvo[16] = t-totvvo[16] + PL-MOV-MES.valcal-mes.
            WHEN 130 THEN t-totvvo[17] = t-totvvo[17] + PL-MOV-MES.valcal-mes.
            WHEN 131 THEN t-totvvo[18] = t-totvvo[18] + PL-MOV-MES.valcal-mes.
            WHEN 135 THEN t-totvvo[19] = t-totvvo[19] + PL-MOV-MES.valcal-mes.
            WHEN 136 THEN t-totvvo[20] = t-totvvo[20] + PL-MOV-MES.valcal-mes.
            WHEN 137 THEN t-totvvo[21] = t-totvvo[21] + PL-MOV-MES.valcal-mes.
            WHEN 138 THEN t-totvvo[22] = t-totvvo[22] + PL-MOV-MES.valcal-mes.
            WHEN 139 THEN t-totvvo[23] = t-totvvo[23] + PL-MOV-MES.valcal-mes.
            WHEN 140 THEN t-totvvo[24] = t-totvvo[24] + PL-MOV-MES.valcal-mes.
            WHEN 141 THEN t-totvvo[25] = t-totvvo[25] + PL-MOV-MES.valcal-mes.
            WHEN 146 THEN t-totvvo[26] = t-totvvo[26] + PL-MOV-MES.valcal-mes.
            WHEN 612 THEN t-totvvo[27] = t-totvvo[27] + PL-MOV-MES.valcal-mes.
            WHEN 801 THEN t-totvvo[28] = t-totvvo[28] + PL-MOV-MES.valcal-mes.
            WHEN 802 THEN t-totvvo[29] = t-totvvo[29] + PL-MOV-MES.valcal-mes.
            WHEN 803 THEN t-totvvo[30] = t-totvvo[30] + PL-MOV-MES.valcal-mes.
            WHEN 218 THEN t-totvvo[31] = t-totvvo[31] + PL-MOV-MES.valcal-mes.
            WHEN 153 THEN t-totvvo[32] = t-totvvo[32] + PL-MOV-MES.valcal-mes.
        END CASE.

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
         HEIGHT             = 3.35
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


