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


(require "contracts.rkt")


; Custom write handler
(define (name-custom-write n out mode)
  (when mode (write-string "(name " out))
  (if (not mode)
      (display (name-n n) out)
      (write (name-n n) out))
  (when mode (write-string ")" out)))


(define-struct name (n) #:transparent
                        #:property prop:custom-write name-custom-write)


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


;; Export public symbols
(provide/contract
  [name              (non-empty-string? . -> . name?)]
  [name?             (any/c             . -> . boolean?)]
  [name->string      (name?             . -> . string?)]
  [name-list->string ((listof name?)    . -> . string?)]
  [string->name-list (string?           . -> . (listof name?))])
