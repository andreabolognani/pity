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


(define-struct/contract sort ([s id-string?])
                             #:transparent)


; Convert a sort to a string
(define (sort->string s)
  (sort-s s))


; Make a string out of a list of sorts
(define (sort-list->string lst)
  (string-join (map sort->string lst) ","))


; Export public symbols
(provide
  (struct-out sort))
(provide/contract
  [sort->string      (sort?          . -> . string?)]
  [sort-list->string ((listof sort?) . -> . string?)])
