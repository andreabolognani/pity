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


(define process-tests
  (test-suite
    "Tests for processes"

    (test-case
      "Test whether process? works correctly"
      (check-true (process? (string->process "0")))
      (check-true (process? (string->process "!0")))
      (check-true (process? (string->process "x(y)"))))
      (check-true (process? (string->process "x<y>")))
      (check-true (process? (string->process "(x)0")))
      (check-true (process? (string->process "0|0")))
      (check-true (process? (string->process "0.0")))
      (check-false (process? "x<y>|x(z)"))
      (check-false (process? (name "x")))
      (check-false (process? 42))))


; Export public symbols
(provide process-tests)
