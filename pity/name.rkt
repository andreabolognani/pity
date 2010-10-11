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


(define-struct/contract name ([n id-string?])
                             #:transparent)


; Return the freshest between two names
(define (name-max a b)
  (let ([na (name-n a)]
        [nb (name-n b)])
    (if (string>=? na nb)
        a
        b)))


; Refresh the name by increasing the number part, adding it if
; it's not already present
(define (name-refresh self)
  (let* ([n (name-n self)]
         [parts (regexp-match #rx"^([a-zA-Z]+)([0-9]*)$" n)]
         [str (cadr parts)]
         [num (caddr parts)]
         [num (if (string=? num "") 0 (string->number num))]
         [num (+ num 1)]
         [n (string-append str (number->string num))])
    (name n)))


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
  [name-max          (name? name?    . -> . name?)]
  [name-refresh      (name?          . -> . name?)]
  [name->string      (name?          . -> . string?)]
  [name-list->string ((listof name?) . -> . string?)]
  [string->name-list (string?        . -> . (listof name?))])
