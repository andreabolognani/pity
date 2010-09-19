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


(define (list->set lst)
  (foldl (lambda (i acc) (set-add acc i)) (set) lst))


; Checks if any of a list of elements is in a set
(define (set-member-any? s lst)
  (not (set-empty? (set-intersect s (list->set lst)))))


(define (display-list lst
                      [out (current-output-port)]
                      #:separator [separator #\newline])
  (unless (empty? lst)
    (display (car lst) out)
    (unless (empty? (cdr lst))
      (display separator out)
      (display-list (cdr lst) out #:separator separator))))


; Export public symbols
(provide/contract
  [list->set       (list?                                    . ->  . set?)]
  [set-member-any? (set? list?                               . ->  . boolean?)]
  [display-list    ((list?) (output-port? #:separator any/c) . ->* . void?)])
