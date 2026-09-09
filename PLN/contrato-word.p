DO:
DEF VAR s-codcia AS INTEGER INIT 1.

DEF VAR Word AS COM-HANDLE.
DEF VAR x_archivo AS CHAR.
DEF VAR x_edad AS INTEGER.
DEF VAR x_codmov AS INTEGER INIT 101.
DEF VAR x-enletras AS CHAR.
DEF VAR x_codmon AS INTEGER INIT 1.
DEF VAR x-fecini AS DATE INIT 01/01/2003.
DEF VAR x-fecfin AS DATE INIT 12/31/2003.
DEF VAR x_vigcon AS CHAR .
DEF VAR x_fecini AS CHAR .
DEF VAR x_fecfin AS CHAR .
DEF VAR x_fecemi AS CHAR .
DEF VAR x_sueper AS CHAR .

DEF VAR x_meses AS CHAR INIT "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".

CREATE "Word.Application" Word.
Word:Visible = True.

FIND Pl-pers WHERE Pl-Pers.Codper = "000128"
     NO-LOCK NO-ERROR.
FIND LAST PL-flg-mes WHERE pl-flg-mes.codcia = s-codcia AND
                           pl-flg-mes.codper = pl-pers.codper
                           NO-LOCK NO-ERROR.
                           
FIND LAST pl-mov-mes WHERE pl-mov-mes.codcia = s-codcia AND
                           pl-mov-mes.codper = pl-pers.codper AND
                           pl-mov-mes.CodMov = x_codmov
                           NO-LOCK No-ERROR.
                            
RUN bin/_numero(pl-mov-mes.valcal, 2, 1, OUTPUT X-EnLetras).
X-EnLetras = X-EnLetras + (IF x_codmon = 1 THEN " NUEVOS SOLES" ELSE " DOLARES AMERICANOS").

/*x_fecini = STRING(DAY(pl-flg-mes.fecing)) + " de " + ENTRY(MONTH(pl-flg-mes.fecing),x_meses) + " del " + STRING(YEAR(pl-flg-mes.fecing)).*/

x_edad = INTEGER((TODAY - pl-pers.FecNac) / 365).
x_fecini = STRING(DAY(x-fecini)) + " de " + ENTRY(MONTH(x-fecini),x_meses) + " del " + STRING(YEAR(x-fecini)).
x_fecfin = STRING(DAY(x-fecfin)) + " de " + ENTRY(MONTH(x-fecfin),x_meses) + " del " + STRING(YEAR(x-fecfin)).
x_fecemi = STRING(DAY(x-fecini)) + " dias del mes de " + ENTRY(MONTH(x-fecini),x_meses) + " del " + STRING(YEAR(x-fecini)).
x_vigcon = STRING(ROUND((x-fecfin - x-fecini) / 30 ,0),"99") + "meses". 
x_sueper = STRING(Pl-mov-mes.valcal) + "(" + x-enletras + ")".
Word:Documents:Add("contrato_01").

RUN Remplazo(INPUT "NOMPER", INPUT (trim(pl-pers.nomper) + " " + trim(pl-pers.patper) + " " + trim(pl-pers.matper)), INPUT 1).     
RUN Remplazo(INPUT "SEXPER", INPUT (pl-pers.sexper), INPUT 0).
RUN Remplazo(INPUT "DIRPER", INPUT (trim(pl-pers.dirper) + " " + trim(pl-pers.distri)), INPUT 0).
RUN Remplazo(INPUT "DNIPER", INPUT (pl-pers.lelect), INPUT 0).
RUN Remplazo(INPUT "EDAPER", INPUT (x_edad), INPUT 0).
RUN Remplazo(INPUT "CARPER01" ,INPUT (Pl-flg-mes.cargos), INPUT 0).
RUN Remplazo(INPUT "CARPER02" ,INPUT (Pl-flg-mes.cargos), INPUT 0).
RUN Remplazo(INPUT "SECPER01" ,INPUT (Pl-flg-mes.seccion), INPUT 0).
RUN Remplazo(INPUT "SECPER02" ,INPUT (Pl-flg-mes.seccion), INPUT 0).
RUN Remplazo(INPUT "SECPER03" ,INPUT (Pl-flg-mes.seccion), INPUT 0).
RUN Remplazo(INPUT "SUEPER" ,INPUT (x_sueper), INPUT 0).
RUN Remplazo(INPUT "FECINI" ,INPUT (x_fecini), INPUT 0).
RUN Remplazo(INPUT "FECFIN" ,INPUT (x_fecfin), INPUT 0).
RUN Remplazo(INPUT "FECEMI" ,INPUT (x_fecemi), INPUT 0).
RUN Remplazo(INPUT "VIGCON" ,INPUT (x_vigcon), INPUT 0).

/*
Word:Selection:Goto(1).
Word:ActiveDocument:CheckSpelling().
Word:ActiveDocument:PrintOut().
*/
x_archivo = "contrato" + pl-pers.codper.
Word:ChangeFileOpenDirectory("c:\").
Word:ActiveDocument:SaveAs(x_archivo).
Word:Quit().

RELEASE OBJECT Word NO-ERROR.

END.

PROCEDURE Remplazo.
DEFINE INPUT PARAMETER campo AS CHARACTER.
DEFINE INPUT PARAMETER registro AS CHARACTER.
DEFINE INPUT PARAMETER mayuscula AS LOGICAL.
DEFINE VAR buffer AS CHARACTER.

Word:Selection:Goto(-1 BY-VARIANT-POINTER,,,campo BY-VARIANT-POINTER).
Word:Selection:Select().
IF mayuscula = TRUE THEN buffer = CAPS(registro).
ELSE buffer = registro.
Word:Selection:Typetext(buffer).
END.
