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


(require rackunit
         pity)


; Make a set of names out of a comma-separated list of names
(define (string->name-set str)
  (list->set (string->name-list str)))


(define names-tests
  (test-suite
    "Tests for names"

    (test-case
      "Refresh name with no number"
      (let ([n1 (name "a")]
            [n2 (name "a1")])
        (check-equal? (name-refresh n1) n2)))

    (test-case
      "Refresh a name with a number"
      (let ([n1 (name "a0")]
            [n2 (name "a1")])
        (check-equal? (name-refresh n1) n2)))

    (test-case
      "Refresh a name with a number"
      (let ([n1 (name "a41")]
            [n2 (name "a42")])
        (check-equal? (name-refresh n1) n2)))

    (test-case
      "Free and bound names in the nil process"
      (let ([process (string->process "0")]
            [free (string->name-set "")]
            [bound (string->name-set "")]
            [all (string->name-set "")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in an input action"
      (let ([process (string->process "x(y).0")]
            [free (string->name-set "x")]
            [bound (string->name-set "y")]
            [all (string->name-set "x,y")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in an output action"
      (let ([process (string->process "x<y>.0")]
            [free (string->name-set "x,y")]
            [bound (string->name-set "")]
            [all (string->name-set "x,y")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names under a restriction (input to private name)"
      (let ([process (string->process "(x)y(x).0")]
            [free (string->name-set "y")]
            [bound (string->name-set "x")]
            [all (string->name-set "x,y")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names under a restriction (input on private name)"
      (let ([process (string->process "(x)x(y).0")]
            [free (string->name-set "")]
            [bound (string->name-set "x,y")]
            [all (string->name-set "x,y")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names under a restriction (output to private name)"
      (let ([process (string->process "(x)y<x>.0")]
            [free (string->name-set "y")]
            [bound (string->name-set "x")]
            [all (string->name-set "x,y")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names under a restriction (output on private name)"
      (let ([process (string->process "(x)x<y>.0")]
            [free (string->name-set "y")]
            [bound (string->name-set "x")]
            [all (string->name-set "x,y")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in a composition (nil processs)"
      (let ([process (string->process "0|0")]
            [free (string->name-set "")]
            [bound (string->name-set "")]
            [all (string->name-set "")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in a composition (input and output)"
      (let ([process (string->process "x(y).0|x<z>.0")]
            [free (string->name-set "x,z")]
            [bound (string->name-set "y")]
            [all (string->name-set "x,y,z")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in a composition (output and input)"
      (let ([process (string->process "x<y>.0|x(z).0")]
            [free (string->name-set "x,y")]
            [bound (string->name-set "z")]
            [all (string->name-set "x,y,z")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in a composition (output and input)"
      (let ([process (string->process "y<x>.0|z(x).0")]
            [free (string->name-set "x,y,z")]
            [bound (string->name-set "x")]
            [all (string->name-set "x,y,z")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in a prefix (output, then input)"
      (let ([process (string->process "x<y>.x(y).0")]
            [free (string->name-set "x,y")]
            [bound (string->name-set "y")]
            [all (string->name-set "x,y")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in a prefix (output, then input)"
      (let ([process (string->process "x<y>.y(z).0")]
            [free (string->name-set "x,y")]
            [bound (string->name-set "z")]
            [all (string->name-set  "x,y,z")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in a prefix (input, then output)"
      (let ([process (string->process "x(y).x<y>.0")]
            [free (string->name-set "x")]
            [bound (string->name-set "y")]
            [all (string->name-set "x,y")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in a prefix (input, then output)"
      (let ([process (string->process "x(y).y<z>.0")]
            [free (string->name-set "x,z")]
            [bound (string->name-set "y")]
            [all (string->name-set "x,y,z")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in a replication (nil process)"
      (let ([process (string->process "!0")]
            [free (string->name-set "")]
            [bound (string->name-set "")]
            [all (string->name-set "")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in a replication (input)"
      (let ([process (string->process "!x(y).0")]
            [free (string->name-set "x")]
            [bound (string->name-set "y")]
            [all (string->name-set "x,y")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in a replication (output)"
      (let ([process (string->process "!x<y>.0")]
            [free (string->name-set "x,y")]
            [bound (string->name-set "")]
            [all (string->name-set "x,y")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))))


; Export public symbols
(provide names-tests)
