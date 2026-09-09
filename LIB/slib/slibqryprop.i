
/**
 * slibqryprop.i -
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



define temp-table qry_ttQuery no-undo

    field cQuery                as char /* for/preselect */
    field cQueryTuning          as char
    field lBreak                as log
    field cByExpList            as char
    field cByDescendList        as char
    field lIndexedReposition    as log
    field cMaxRows              as char.

define temp-table qry_ttRecordPhrase no-undo

    field iRecordPhraseNum      as int
    field cRecordPhrase         as char /* each/first/last */
    field cDbName               as char
    field cBufferName           as char
    field cFields               as char
    field cExcept               as char
    field lLeft                 as log
    field iWhereId              as int
    field lOuterJoin            as log
    field cUseIndex             as char
    field cLock                 as char
    field lNoPrefetch           as log

    index iRecordPhraseNum is primary unique
          iRecordPhraseNum.

define temp-table qry_ttBuffer no-undo

    field cDbName               as char
    field cTableName            as char
    field cBufferName           as char

    index BufferDb is primary unique
          cBufferName
          cDbName.

define temp-table qry_ttWhereTree no-undo

    field iParenthesisId        as int
    field iPredicateId          as int

    field iPredicateSeq         as int
    field cPredicateType        as char /* (exp)ression, (par)enthesis, literal, simple, simple2 */
    field cPredicateExp         as char /* string, buffer-field handle chr(1) delimiter list-item-pairs. the buffer-field can also have an extent number with a chr(2) delimiter. */

    field cParenthesisType      as char /* and, or, single */
    field lParenthesisNot       as log
    field iPredicateCnt         as int

    field lLiteralValue         as log

    field cSimpleDbName         as char
    field cSimpleBufferName     as char
    field cSimpleFieldName      as char
    field iSimpleExtent         as int

    field cSimpleOperator       as char

    field cSimpleDbName2        as char
    field cSimpleBufferName2    as char
    field cSimpleFieldName2     as char
    field iSimpleExtent2        as int

    index iPredicateId is primary unique
          iPredicateId

    index WhereTree is unique
          iParenthesisId
          iPredicateSeq.

define temp-table qry_ttEquiJoinField no-undo

    field cDbName               as char
    field cBufferName           as char
    field cFieldName            as char
    field iFieldExtent          as int

    field iJoinId               as int /* the shared or grouping id */
    field iPredicateId          as int
    field iPredicateSeq         as int
    field cDataType             as char

    index DbBufferField is primary unique
          cDbName
          cBufferName
          cFieldName
          iFieldExtent

    index JoinBufferDb
          iJoinId
          cBufferName
          cDbName

    index DbBufferJoin is unique
          cDbName
          cBufferName
          iPredicateSeq

    index iPredicateId is unique
          iPredicateId.

define temp-table qry_ttLiteral no-undo

    field iBufferId             as int
    field iParenthesisId        as int
    field iPredicateId          as int

    field lLiteralValue         as log

    index WhereTree is primary unique
          iBufferId
          iParenthesisId
          iPredicateId.
