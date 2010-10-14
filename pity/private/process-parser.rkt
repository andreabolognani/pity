#lang racket

; Pity: Pi-Calculus Type Checking
; Copyright (C) 2010  Andrea Bolognani <andrea.bolognani@roundhousecode.com>
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License along
; with this program; if not, write to the Free Software Foundation, Inc.,
; 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


(require parser-tools/yacc
         "../name.rkt"
         "../process.rkt"
         "common-lexer.rkt")


(define process-parser
  (parser

    (start  process)
    (end    EOF)
    (tokens common-symbols common-values)
    (error  (lambda (a b c) (void)))

    (grammar

      (process
        [(subprocess)              $1]
        [(subprocess PIPE process) (composition $1 $3)])

      (subprocess
        [(part)                    $1]
        [(BANG subprocess)         (replication $2)])

      (part
        [(term)                    $1]
        [(LP name RP part)         (restriction $2 $4)])

      (term
        [(action)                  $1]
        [(action DOT term)         (prefix $1 $3)])

      (action
        [(NIL)                     (nil)]
        [(name LP names RP)        (input $1 $3)]
        [(name LAB names RAB)      (output $1 $3)]
        [(LP process RP)           $2])

      (names
        [(name)                    (list $1)]
        [(name COMMA names)        (list* $1 $3)])

      (name
        [(ID)                      (name $1)]))))


; Export public symbols
(provide process-parser)