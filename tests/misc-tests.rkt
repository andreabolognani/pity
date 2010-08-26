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


(require rackunit
         pity)


(define misc-tests
  (test-suite
    "Tests for miscellaneous procedures"

    (test-case
      "Make a set out of an empty list"
      (check-equal? (list->set '()) (set)))

    (test-case
      "Make a set out of a list containing no duplicates"
      (check-equal? (list->set '(1 2 3)) (set 1 2 3)))

    (test-case
      "Make a set out of a list containing duplicates"
      (check-equal? (list->set '(1 2 1 3 2)) (set 1 2 3)))))


; Export public symbols
(provide misc-tests)
