#lang racket/base

; Pity: Pi-Calculus Type Inference
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



; Tokens
; ------


(define-empty-tokens common-symbols (EOF NIL DOT COMMA PIPE BANG
                                     COLON SEMICOLON EQ
                                     LP RP LAB RAB LCB RCB))
(define-tokens       common-values  (ID))



; Lexer abbreviations
; -------------------


(define-lex-abbrevs
  (letter (union (char-range #\a #\z)
                 (char-range #\A #\Z)))
  (digit  (char-range #\0 #\9))
  (space  (union #\tab
                 #\space))
  (id     (concatenation (repetition 1 +inf.0 letter)
                         (repetition 0 +inf.0 digit))))



; Lexer
; -----


(define common-lexer
  (lexer
    [id     (token-ID lexeme)]
    ["0"    (token-NIL)]
    ["."    (token-DOT)]
    [","    (token-COMMA)]
    ["|"    (token-PIPE)]
    ["!"    (token-BANG)]
    [":"    (token-COLON)]
    [";"    (token-SEMICOLON)]
    ["="    (token-EQ)]
    ["("    (token-LP)]
    [")"    (token-RP)]
    ["<"    (token-LAB)]
    [">"    (token-RAB)]
    ["{"    (token-LCB)]
    ["}"    (token-RCB)]
    [space  (common-lexer input-port)] ; Skip whitespace
    [(eof)  (token-EOF)]))



; Export public symbols
; ---------------------

(provide
  common-symbols
  common-values
  common-lexer)
