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


(require rackunit
         pity)


(define print-tests
  (test-suite
    "Tests for print functionality"

    (test-case
      "Print a name"
      (let ([name (name "x")])
        (check-equal? (name->string name) "x")))

    (test-case
      "Print an empty name list"
      (let ([name-list '()])
        (check-equal? (name-list->string name-list) "")))

    (test-case
      "Print a list containing a single name"
      (let ([name-list (list (name "x"))])
        (check-equal? (name-list->string name-list) "x")))

    (test-case
      "Print a list containing two names"
      (let ([name-list (list (name "x") (name "y"))])
        (check-equal? (name-list->string name-list) "x,y")))

    (test-case
      "Print a list containing three names"
      (let ([name-list (list (name "x") (name "y") (name "z"))])
        (check-equal? (name-list->string name-list) "x,y,z")))))


; Export public symbols
(provide print-tests)
