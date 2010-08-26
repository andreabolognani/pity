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


(define conversion-tests
  (test-suite
    "Tests for conversion routines"

    (test-case
      "Make a list of names out of an empty string"
      (let ([str ""]
            [lst '()])
        (check-equal? (string->name-list str) lst)))

    (test-case
      "Make a list of names out of a single name"
      (let ([str "x"]
            [lst (list (name "x"))])
        (check-equal? (string->name-list str) lst)))

    (test-case
      "Make a list of names out of a string"
      (let ([str "x,y"]
            [lst (list (name "x") (name "y"))])
        (check-equal? (string->name-list str) lst)))))


; Export public symbols
(provide conversion-tests)
