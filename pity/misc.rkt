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
         racket/set
         "contracts.rkt")


; Make a procedure which accepts the same
; arguments as proc, only in reverse order
(define (flip proc)
  (lambda rest (apply proc (reverse rest))))


; Replace all matching elements with a new value
(define (list-replace lst a b)
  (if (null? lst)
    lst
    (if (equal? (car lst) a)
        (cons b (list-replace (cdr lst) a b))
        (cons (car lst) (list-replace (cdr lst) a b)))))


; Convert a list to a set
(define (list->set lst)
  (foldl (flip set-add) (set) lst))


; Convert a set to a list
(define (set->list s)
  (set-map s (lambda (x) x)))


; Checks if any of a list of elements is in a set
(define (set-member-any? s lst)
  (not (set-empty? (set-intersect s (list->set lst)))))


(define (display-list lst
                      [out (current-output-port)]
                      #:separator [separator #\newline])
  (unless (null? lst)
    (display (car lst) out)
    (unless (null? (cdr lst))
      (display separator out)
      (display-list (cdr lst) out #:separator separator))))


; Export public symbols
(provide/contract
  [flip            (procedure?                               . ->  . procedure?)]
  [list-replace    (list? any/c any/c                        . ->  . list?)]
  [list->set       (list?                                    . ->  . set?)]
  [set->list       (set?                                     . ->  . list?)]
  [set-member-any? (set? list?                               . ->  . boolean?)]
  [display-list    ((list?) (output-port? #:separator any/c) . ->* . void?)])
