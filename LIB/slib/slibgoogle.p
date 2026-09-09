
/**
 * slibgoogle.p -
 *
 * (c) Copyright ABC Alon Blich Consulting Tech, Ltd.
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 *  Contact information
 *  Email: alonblich@gmail.com
 *  Phone: +263-77-7600818
 */

{slib/slibgoogleprop.i}

{slib/slibhttp.i}

{slib/slibxml.i}

{slib/sliberr.i}



on "close" of this-procedure do:

    delete procedure this-procedure.

end. /* close */

procedure initializeProc:

    &if {&google_xAcctKey} = "" &then

        message "Please fill your Google account key in slib/slibgoogleprop.i first " view-as alert-box.
        quit.

    &endif

end procedure. /* initializeProc */



/*
Language                Language code
--------                -------------
Afrikaans               af
Albanian                sq
Arabic 	                ar
Belarusian 	            be
Bulgarian               bg
Catalan                 ca
Chinese Simplified      zh-CN
Chinese Traditional     zh-TW
Croatian                hr
Czech                   cs
Danish                  da
Dutch                   nl
English                 en
Estonian                et
Filipino                tl
Finnish                 fi
French                  fr
Galician                gl
German                  de
Greek                   el
Haitian Creole          ht
Hebrew                  iw
Hindi                   hi
Hungarian               hu
Icelandic               is
Indonesian              id
Irish                   ga
Italian                 it
Japanese                ja
Latvian                 lv
Lithuanian              lt
Macedonian              mk
Malay                   ms
Maltese                 mt
Norwegian               no
Persian                 fa
Polish                  pl
Portuguese              pt
Romanian                ro
Russian                 ru
Serbian                 sr
Slovak                  sk
Slovenian               sl
Spanish                 es
Swahili                 sw
Swedish                 sv
Thai                    th
Turkish                 tr
Ukrainian               uk
Vietnamese              vi
Welsh                   cy
Yiddish                 yi
*/

procedure google_translate:

    define input    param pcSourceLang  as char no-undo.
    define input    param pcSourceText  as char no-undo.
    define input    param pcTargetLang  as char no-undo.
    define output   param pcTargetText  as char no-undo.

    define var cReqHeaderLines  as char no-undo.
    define var cReqBody         as char no-undo.
    define var pReqBody         as memptr no-undo.

    define var cResStatusLine   as char no-undo.
    define var cResHeaderLines  as char no-undo.
    define var pResBody         as memptr no-undo.

    define var i                as int no-undo.
    define var j                as int no-undo.

    {slib/err_try}:

        assign
            cReqHeaderLines = "X-HTTP-Method-Override: GET"
            cReqBody        =

                   "q="         + http_encodeUrl( pcSourceText,         "post" )
                + "&source="    + http_encodeUrl( pcSourceLang,         "post" )
                + "&target="    + http_encodeUrl( pcTargetLang,         "post" )
                + "&key="       + http_encodeUrl( {&google_xAcctKey},   "post" ).

        set-size( pReqBody ) = length( cReqBody ).

        put-string( pReqBody, 1, length( cReqBody ) ) = cReqBody.

        run http_post(
            input   "https://www.googleapis.com/language/translate/v2",
            input   ?,

            input   cReqHeaderLines,
            input   pReqBody,

            output  cResStatusLine,
            output  cResHeaderLines,
            output  pResBody ).

        if not cResStatusLine matches "*200*OK*" then
            {slib/err_throw "'error'"}.

        if get-size( pResBody ) = 0 then
            {slib/err_throw "'error'"}.



        pcTargetText = get-string( pResBody, 1 ).

        i = index( pcTargetText, 'translatedText' ).
        if i = 0 then {slib/err_throw "'error'"}.

        i = index( pcTargetText, ':', i ).
        if i = 0 then {slib/err_throw "'error'"}.

        i = index( pcTargetText, '"', i ).
        if i = 0 then {slib/err_throw "'error'"}.

        j = index( pcTargetText, '"', i + 1 ).
        if i = 0 then {slib/err_throw "'error'"}.

        pcTargetText = xml_decodeXml( substr( pcTargetText, i + 1, ( j - 1 ) - ( i + 1 ) + 1 ) ).

    {slib/err_catch}:

        pcTargetText = ?.

    {slib/err_finally}:

        set-size( pReqBody ) = 0.
        set-size( pResBody ) = 0.

    {slib/err_end}.

end procedure. /* google_translate */
