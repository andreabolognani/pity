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


(require parser-tools/lex)


(define-empty-tokens process-symbols (EOF NIL DOT COMMA PIPE BANG
                                      L_PAREN R_PAREN L_BRACKET R_BRACKET))
(define-tokens       process-values  (NAME))


(define-lex-abbrevs
  (letter (union (char-range "a" "z") (char-range "A" "Z")))
  (digit (char-range "0" "9"))
  (name (concatenation letter (repetition 0 +inf.0 (union letter digit)))))


(define process-lexer
  (lexer
    [name   (token-NAME lexeme)]
    ["0"    (token-NIL)]
    ["."    (token-DOT)]
    [","    (token-COMMA)]
    ["|"    (token-PIPE)]
    ["!"    (token-BANG)]
    ["("    (token-L_PAREN)]
    [")"    (token-R_PAREN)]
    ["<"    (token-L_BRACKET)]
    [">"    (token-R_BRACKET)]
    [(eof)  (token-EOF)]))


; Export public symbols
(provide
  process-symbols
  process-values
  process-lexer)
