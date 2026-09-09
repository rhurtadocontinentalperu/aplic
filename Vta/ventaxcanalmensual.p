output to c:\2002.txt.
define var f-canal as char .
DEFINE SHARED VAR CL-CODCIA AS INTEGER.
DEFINE TEMP-TABLE tempo 
FIELD Canal LIKE Gn-clie.Canal
FIELD NomCan LIKE Gn-Clie.Nomcli
FIELD impusa AS DECI EXTENT 12.

for each evtclie where codcia = 1 and
                       coddiv = "00000" and
                       nrofch >= 200201 and
                       nrofch <= 200204 
                       use-index llave02:
   FIND Gn-clie WHERE Gn-clie.Codcia = cl-codcia AND
                      Gn-Clie.Codcli = Evtclie.Codcli
                      NO-LOCK NO-ERROR.
   f-canal = "".
   IF AVAILABLE Gn-Clie THEN DO:                    
        FIND almtabla WHERE almtabla.Tabla = 'CN' AND 
                            almtabla.Codigo = gn-clie.Canal
                            NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN F-Canal = almtabla.nombre.
        find tempo where tempo.canal = gn-clie.canal 
             no-error.
        if not available tempo then do:
           create tempo.
           assign 
           tempo.canal = gn-clie.canal
           tempo.nomcan = f-canal.
        end.
        tempo.impusa[codmes] = tempo.impusa[codmes] + vtaxmesme.
   END.                       
        
  
end.

for each tempo break by tempo.canal:
  display tempo.canal 
          tempo.nomcan 
          tempo.impusa[1]
          tempo.impusa[2]
          tempo.impusa[3]
          tempo.impusa[4]
          tempo.impusa[5]
          tempo.impusa[6]
          tempo.impusa[7]
          tempo.impusa[8]
          tempo.impusa[9]
          tempo.impusa[10]
          tempo.impusa[11]
          tempo.impusa[12]
          with width 350.
end.
output close.
                       
                       
