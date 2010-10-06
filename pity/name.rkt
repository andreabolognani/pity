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


(require racket/contract
         racket/string
         "contracts.rkt")


(define-struct/contract name ([n non-empty-string?])
                             #:transparent)


; Conversion routines
; -------------------
;
;  Convert names and lists of names to strings, and the other way around.


; Make a string out of a name
(define (name->string n)
  (name-n n))


; Make a string out of a list of names
(define (name-list->string lst)
  (string-join (map name->string lst) ","))


; Make a list of names out of a string
(define (string->name-list str)
  (cond [(equal? str "") '()]
        [else (map name (regexp-split #rx", *" str))]))


; Export public symbols
(provide
  (struct-out name))
(provide/contract
  [name->string      (name?          . -> . string?)]
  [name-list->string ((listof name?) . -> . string?)]
  [string->name-list (string?        . -> . (listof name?))])
