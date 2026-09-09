DEFINE VARIABLE chExcelApplication      AS COM-HANDLE.
DEFINE VARIABLE chWorkbook              AS COM-HANDLE.
DEFINE VARIABLE chWorksheet             AS COM-HANDLE.

DEFINE VARIABLE chWorksheetRange        AS COM-HANDLE.

DEFINE VARIABLE iCount                  AS INTEGER init 1.
DEFINE VARIABLE iIndex                  AS INTEGER.
DEFINE VARIABLE iColumn                 AS INTEGER INITIAL 1.
DEFINE VARIABLE iRow                    AS INTEGER INITIAL 1.
DEFINE VARIABLE cColumn                 AS CHARACTER.
DEFINE VARIABLE cRange                  AS CHARACTER.

DEFINE VARIABLE lCerrarAlTerminar        AS LOG.
DEFINE VARIABLE lMensajeAlTerminar      AS LOG.

DEFINE VARIABLE cColList AS LONGCHAR.

/* create a new Excel Application object */
CREATE "Excel.Application" chExcelApplication.

/* launch Excel so it is visible to the user */
chExcelApplication:Visible = FALSE.

/* Acelera la descargar a Excel */
chExcelApplication:ScreenUpdating = NO.

/* En caso tengas fórmulas 
chExcelApplication:calculation = 3. /*to set to manual*/
    (... exporting data ...) 
chExcelApplication:calculation = 1. /*to set to automatic */
*/

IF lNuevoFile = YES THEN DO:
    /* Para crear a new Workbook */
    chWorkbook = chExcelApplication:Workbooks:Add().
END.
ELSE DO:
    /* OPEN XLS */
    chWorkbook = chExcelApplication:Workbooks:OPEN(lFIleXls).
END.

/* get the active Worksheet */
chWorkSheet = chExcelApplication:Sheets:Item(1).

/*  */
lCerrarAlTerminar = NO.	  /* Si permanece abierto el Excel luego de concluir el proceso */
lMensajeAlTerminar = YES. /* Muestra el mensaje de "proceso terminado" al finalizar */

/* Celdas */
ASSIGN cColList = 'A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z'
              + ',AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM'
              + ',AN,AO,AP,AQ,AR,AS,AT,AU,AV,AW,AX,AY,AZ'
              + ',BA,BB,BC,BD,BE,BF,BG,BH,BI,BJ,BK,BL,BM'
              + ',BN,BO,BP,BQ,BR,BS,BT,BU,BV,BW,BX,BY,BZ'
              + ',CA,CB,CC,CD,CE,CF,CG,CH,CI,CJ,CK,CL,CM'
              + ',CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ'
              + ',DA,DB,DC,DD,DE,DF,DG,DH,DI,DJ,DK,DL,DM'
              + ',DN,DO,DP,DQ,DR,DS,DT,DU,DV,DW,DX,DY,DZ'
              + ',EA,EB,EC,ED,EE,EF,EG,EH,EI,EJ,EK,EL,EM'
              + ',EN,EO,EP,EQ,ER,ES,ET,EU,EV,EW,EX,EY,EZ'
              + ',FA,FB,FC,FD,FE,FF,FG,FH,FI,FJ,FK,FL,FM'
              + ',FN,FO,FP,FQ,FR,FS,FT,FU,FV,FW,FX,FY,FZ'
              + ',GA,GB,GC,GD,GE,GF,GG,GH,GI,GJ,GK,GL,GM'
              + ',GN,GO,GP,GQ,GR,GS,GT,GU,GV,GW,GX,GY,GZ'
              + ',HA,HB,HC,HD,HE,HF,HG,HH,HI,HJ,HK,HL,HM'
              + ',HN,HO,HP,HQ,HR,HS,HT,HU,HV,HW,HX,HY,HZ'
              + ',IA,IB,IC,ID,IE,IF,IG,IH,II,IJ,IK,IL,IM'
              + ',IN,IO,IP,IQ,IR,IS,IT,IU,IV,IW,IX,IY,IZ'
              + ',JA,JB,JC,JD,JE,JF,JG,JH,JI,JJ,JK,JL,JM'
              + ',JN,JO,JP,JQ,JR,JS,JT,JU,JV,JW,JX,JY,JZ'
              + ',KA,KB,KC,KD,KE,KF,KG,KH,KI,KJ,KK,KL,KM'
              + ',KN,KO,KP,KQ,KR,KS,KT,KU,KV,KW,KX,KY,KZ'
              + ',LA,LB,LC,LD,LE,LF,LG,LH,LI,LJ,LK,LL,LM'
              + ',LN,LO,LP,LQ,LR,LS,LT,LU,LV,LW,LX,LY,LZ'
              + ',MA,MB,MC,MD,ME,MF,MG,MH,MI,MJ,MK,ML,MM'
              + ',MN,MO,MP,MQ,MR,MS,MT,MU,MV,MW,MX,MY,MZ'
              + ',NA,NB,NC,ND,NE,NF,NG,NH,NI,NJ,NK,NL,NM'
              + ',NN,NO,NP,NQ,NR,NS,NT,NU,NV,NW,NX,NY,NZ'.
              
