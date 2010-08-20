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


(require "private/lexer.rkt"
         "private/parser.rkt"
         "contracts.rkt"
         "process.rkt")


; This really belongs to the process module, and is documented as
; such, but putting it there causes a require cycle.
;
; Another way to work around the cycle would be to embed the parser
; into the process module. I might end up doing that.
(define (string->process str)
  (let ([ip (open-input-string str)])
    (private-parser (lambda () (private-lexer ip)))))


; Export public symbols
(provide/contract
  [string->process (string? . -> . process?)])
