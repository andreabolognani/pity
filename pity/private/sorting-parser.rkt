#lang racket/base

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
         "../sort.rkt"
         "../sorting.rkt"
         "common-lexer.rkt")


(define sorting-parser
  (parser

    (start  sorting)
    (end    EOF)
    (tokens common-symbols common-values)
    (error  (lambda (a b c) (void)))

    (grammar

      (sorting
        [(part)                   (sorting-set (sorting) (car $1) (cdr $1))]
        [(sorting SEMICOLON part) (sorting-set $1 (car $3) (cdr $3))])

      (part
        [(sort EQ LP sorts RP)    (cons $1 $4)])

      (sorts
        [(sort)                   (list $1)]
        [(sort COMMA sorts)       (list* $1 $3)])

      (sort
        [(ID)                     (sort $1)]))))


; Export public symbols
(provide sorting-parser)
