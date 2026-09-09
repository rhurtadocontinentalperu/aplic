     DEFINE TEMP-TABLE ttAlmacen
   FIELD CodCia AS INTEGER LABEL "Cia" FORMAT "999" INITIAL "0"
   FIELD CodAlm AS CHARACTER LABEL "Almacén" FORMAT "x(3)"
   FIELD Descripcion AS CHARACTER LABEL "Descripción" FORMAT "X(40)"
   FIELD TdoArt AS LOGICAL LABEL "Todos los Articulos" FORMAT "Si/No" INITIAL "Si"
   FIELD AutMov AS LOGICAL LABEL "Autorizacion de Movimientos" FORMAT "Si/No" INITIAL "Si"
   FIELD DirAlm AS CHARACTER LABEL "Direccion" FORMAT "X(60)"
   FIELD HorRec AS CHARACTER LABEL "Horario de Recepcion" FORMAT "X(40)"
   FIELD EncAlm AS CHARACTER LABEL "Encargado del Almacen" FORMAT "X(30)"
   FIELD TelAlm AS CHARACTER LABEL "Telefono Almacen" FORMAT "X(13)"
   FIELD CorrSal AS INTEGER LABEL "Correlativo Salida" FORMAT "999999" INITIAL "0"
   FIELD CorrIng AS INTEGER LABEL "Correlativo Ingreso" FORMAT "999999" INITIAL "0"
   FIELD CorrTrf AS INTEGER LABEL "Correlativo Transferencia" FORMAT "999999" INITIAL "0"
   FIELD CodDiv AS CHARACTER LABEL "Divisionaria" FORMAT "XX-XXX" INITIAL "00000"
   FIELD Clave AS CHARACTER LABEL "Clave de Modificacion" FORMAT "X(8)"
   FIELD AlmCsg AS LOGICAL LABEL "AlmCsg" FORMAT "yes/no" INITIAL "no"
   FIELD TpoCsg AS CHARACTER LABEL "TpoCsg" FORMAT "X(1)"
   FIELD CodCli AS CHARACTER LABEL "CodCli" FORMAT "x(11)"
   FIELD flgrep AS LOGICAL FORMAT "yes/no" INITIAL "no"
   FIELD Campo-C AS CHARACTER FORMAT "X(10)" EXTENT 10
      INDEX alm01 IS PRIMARY UNIQUE 
        CodCia
        CodAlm
      .
