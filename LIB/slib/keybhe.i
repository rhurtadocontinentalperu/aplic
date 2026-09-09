
/**
 * keybhe.i -
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

{slib/slibbidi.i}



&if defined( xKeybhe ) = 0 &then

    {slib/start-slib.i "'slib/keybhe.p'"}

    &global xKeybhe defined



    /* note that the triggers are scoped the procedure they're included in and not the entire session */

    on "ctrl-f10" anywhere do:

        run keybhe_onHebrewMode. return no-apply.

    end. /* f17 */



    on "any-printable" anywhere do:

        if self:type = "fill-in" and self:data-type = "character" then do:

            run keybhe_onAnyPrintable. return no-apply.

        end.

    end. /* any-printable */

    on "insert-mode" anywhere do:

        if self:type = "fill-in" and self:data-type = "character" then do:

            run keybhe_onInsertMode.

        end.

    end. /* insert-mode */

    on "backspace" anywhere do:

        if self:type = "fill-in" and self:data-type = "character" then do:

            run keybhe_onBackspace. return no-apply.

        end.

    end. /* backspace */

    on "delete" anywhere do:

        if self:type = "fill-in" and self:data-type = "character" then do:

            run keybhe_onDelete. return no-apply.

        end.

    end. /* delete */



    on "home" anywhere do:

        if self:type = "fill-in" and self:data-type = "character" then do:

            run keybhe_onHome. return no-apply.

        end.

    end. /* backspace */

    on "end" anywhere do:

        if self:type = "fill-in" and self:data-type = "character" then do:

            run keybhe_onEnd. return no-apply.

        end.

    end. /* delete */

&endif /* defined = 0 */
