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
         "../sort.rkt"
         "../environment.rkt"
         "common-lexer.rkt")


(define environment-parser
  (parser

    (start  environment)
    (end    EOF)
    (tokens common-symbols common-values)
    (error  (lambda (a b c) (void)))

    (grammar

      (environment
        [(LCB contents RCB)       $2])

      (contents
        [(binding)                (environment-set (environment) (car $1) (cdr $1))]
        [(contents COMMA binding) (environment-set $1 (car $3) (cdr $3))])

      (binding
        [(id COLON id)            (cons (name $1) (sort $3))])

      (id
        [(ID)                     $1]))))


; Export public symbols
(provide environment-parser)
