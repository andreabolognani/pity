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
      "Check compatibility between incompatible names (no numeric part)"
      (let ([n1 (name "a")]
            [n2 (name "b")])
        (check-false (name-compatible? n1 n2))))

    (test-case
      "Check compatibility between incompatible names (numeric part)"
      (let ([n1 (name "a5")]
            [n2 (name "b87")])
        (check-false (name-compatible? n1 n2))))

    (test-case
      "Check compatibility between compatible names (no numeric part)"
      (let ([n1 (name "a")]
            [n2 (name "a")])
        (check-true (name-compatible? n1 n2))))

    (test-case
      "Check compatibility between compatible names (numeric part)"
      (let ([n1 (name "a5")]
            [n2 (name "a73")])
        (check-true (name-compatible? n1 n2))))

    (test-case
      "Find max name between name with no number and name with number"
      (let ([n1 (name "a")]
            [n2 (name "a1")])
        (check-equal? (name-max n1 n2) n2)))

    (test-case
      "Find max name between two names with number"
      (let ([n1 (name "a12")]
            [n2 (name "a30")])
        (check-equal? (name-max n1 n2) n2)))

    (test-case
      "Find max name between names with different bases"
      (let ([n1 (name "a5")]
            [n2 (name "b1")])
        (check-equal? (name-max n1 n2) n2)))

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
      (let ([process (string->process "(x1)y(x1).0")]
            [free (string->name-set "y")]
            [bound (string->name-set "x1,x2")]
            [all (string->name-set "x1,x2,y")])
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
      "Free and bound names in a composition (input and output, different names)"
      (let ([process (string->process "x(y).0|x<z>.0")]
            [free (string->name-set "x,z")]
            [bound (string->name-set "y")]
            [all (string->name-set "x,y,z")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in a composition (input and output, same name)"
      (let ([process (string->process "x(y).0|x<y>.0")]
            [free (string->name-set "x,y1")]
            [bound (string->name-set "y")]
            [all (string->name-set "x,y,y1")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in a composition (output and input, different names)"
      (let ([process (string->process "x<y>.0|x(z).0")]
            [free (string->name-set "x,y")]
            [bound (string->name-set "z")]
            [all (string->name-set "x,y,z")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in a composition (output and input, same name)"
      (let ([process (string->process "y<x>.0|z(x).0")]
            [free (string->name-set "x,y,z")]
            [bound (string->name-set "x1")]
            [all (string->name-set "x,x1,y,z")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in a prefix (output then input, same name)"
      (let ([process (string->process "x<y>.x(y).0")]
            [free (string->name-set "x,y")]
            [bound (string->name-set "y")]
            [all (string->name-set "x,y")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in a prefix (output then input, different names)"
      (let ([process (string->process "x<y>.y(z).0")]
            [free (string->name-set "x,y")]
            [bound (string->name-set "z")]
            [all (string->name-set  "x,y,z")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in a prefix (input then output, same name)"
      (let ([process (string->process "x(y).x<y>.0")]
            [free (string->name-set "x")]
            [bound (string->name-set "y")]
            [all (string->name-set "x,y")])
        (check-equal? (process-free-names process) free)
        (check-equal? (process-bound-names process) bound)
        (check-equal? (process-names process) all)))

    (test-case
      "Free and bound names in a prefix (input then output, different names)"
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
        (check-equal? (process-names process) all)))

    (test-case
      "Refresh a name not present in a process"
      (let* ([p-str "0"]
             [p (string->process p-str)]
             [p-fn (string->name-set "")]
             [p-bn (string->name-set "")]
             [p-n (string->name-set "")]
             [q-str "0"]
             [q (process-refresh-name p (name "a"))]
             [q-fn (string->name-set "")]
             [q-bn (string->name-set "")]
             [q-n (string->name-set "")])
        (check-equal? (process-free-names p) p-fn)
        (check-equal? (process-bound-names p) p-bn)
        (check-equal? (process-names p) p-n)
        (check-equal? (string->process q-str) q)
        (check-equal? (process-free-names q) q-fn)
        (check-equal? (process-bound-names q) q-bn)
        (check-equal? (process-names q) q-n)))

    (test-case
      "Refresh a free name"
      (let* ([p-str "a<b>.0"]
             [p (string->process p-str)]
             [p-fn (string->name-set "a,b")]
             [p-bn (string->name-set "")]
             [p-n (string->name-set "a,b")]
             [q-str "a1<b>.0"]
             [q (process-refresh-name p (name "a"))]
             [q-fn (string->name-set "a1,b")]
             [q-bn (string->name-set "")]
             [q-n (string->name-set "a1,b")])
        (check-equal? (process-free-names p) p-fn)
        (check-equal? (process-bound-names p) p-bn)
        (check-equal? (process-names p) p-n)
        (check-equal? (string->process q-str) q)
        (check-equal? (process-free-names q) q-fn)
        (check-equal? (process-bound-names q) q-bn)
        (check-equal? (process-names q) q-n)))

    (test-case
      "Refresh a bound name"
      (let* ([p-str "a(b).0"]
             [p (string->process p-str)]
             [p-fn (string->name-set "a")]
             [p-bn (string->name-set "b")]
             [p-n (string->name-set "a,b")]
             [q-str "a(b1).0"]
             [q (process-refresh-name p (name "b"))]
             [q-fn (string->name-set "a")]
             [q-bn (string->name-set "b1")]
             [q-n (string->name-set "a,b1")])
        (check-equal? (process-free-names p) p-fn)
        (check-equal? (process-bound-names p) p-bn)
        (check-equal? (process-names p) p-n)
        (check-equal? (string->process q-str) q)
        (check-equal? (process-free-names q) q-fn)
        (check-equal? (process-bound-names q) q-bn)
        (check-equal? (process-names q) q-n)))

    (test-case
      "Refresh a bound name, avoiding free name capture"
      (let* ([p-str "a2(a1).0"]
             [p (string->process p-str)]
             [p-fn (string->name-set "a2")]
             [p-bn (string->name-set "a1")]
             [p-n (string->name-set "a1,a2")]
             [q-str "a2(a3).0"]
             [q (process-refresh-name p (name "a1"))]
             [q-fn (string->name-set "a2")]
             [q-bn (string->name-set "a3")]
             [q-n (string->name-set "a2,a3")])
        (check-equal? (process-free-names p) p-fn)
        (check-equal? (process-bound-names p) p-bn)
        (check-equal? (process-names p) p-n)
        (check-equal? (string->process q-str) q)
        (check-equal? (process-free-names q) q-fn)
        (check-equal? (process-bound-names q) q-bn)
        (check-equal? (process-names q) q-n)))

    (test-case
      "Refresh a bound name, avoiding existing bound names"
      (let* ([p-str "(b1)a(b2).0"]
             [p (string->process p-str)]
             [p-fn (string->name-set "a")]
             [p-bn (string->name-set "b1,b2")]
             [p-n (string->name-set "a,b1,b2")]
             [q-str "(b3)a(b2).0"]
             [q (process-refresh-name p (name "b1"))]
             [q-fn (string->name-set "a")]
             [q-bn (string->name-set "b2,b3")]
             [q-n (string->name-set "a,b2,b3")])
        (check-equal? (process-free-names p) p-fn)
        (check-equal? (process-bound-names p) p-bn)
        (check-equal? (process-names p) p-n)
        (check-equal? (string->process q-str) q)
        (check-equal? (process-free-names q) q-fn)
        (check-equal? (process-bound-names q) q-bn)
        (check-equal? (process-names q) q-n)))

    (test-case
      "Refresh a name in a composition"
      (let* ([p-str "(a1)(a1<a3>.0|a1(a2).0)"]
             [p (string->process p-str)]
             [p-fn (string->name-set "a3")]
             [p-bn (string->name-set "a1,a2")]
             [p-n (string->name-set "a1,a2,a3")]
             [q-str "(a4)(a4<a3>.0|a4(a2).0)"]
             [q (process-refresh-name p (name "a1"))]
             [q-fn (string->name-set "a3")]
             [q-bn (string->name-set "a2,a4")]
             [q-n (string->name-set "a2,a3,a4")])
        (check-equal? (process-free-names p) p-fn)
        (check-equal? (process-bound-names p) p-bn)
        (check-equal? (process-names p) p-n)
        (check-equal? (string->process q-str) q)
        (check-equal? (process-free-names q) q-fn)
        (check-equal? (process-bound-names q) q-bn)
        (check-equal? (process-names q) q-n)))

    (test-case
      "Prevent bound name capture under a prefix"
      (let* ([str "a(b,c).a(c,d).0"]
             [canonical-str "a(b,c).a(c1,d).0"]
             [canonical (string->process canonical-str)])
        (check-equal? (string->process str) canonical)))

    (test-case
      "Prevent bound name capture under a restriction"
      (let* ([str "(b)a(b).0"]
             [canonical-str "(b)a(b1).0"]
             [canonical (string->process canonical-str)])
        (check-equal? (string->process str) canonical)))

    (test-case
      "Prevent name capture in a composition"
      (let* ([str "a2(a1,b1).0|b2(a1,b3).0"]
             [canonical-str "a2(a1,b1).0|b2(a3,b3).0"]
             [canonical (string->process canonical-str)])
        (check-equal? (string->process str) canonical)))

    (test-case
      "Prevent ambiguity in a composition"
      (let* ([str "a(b).0|b<c>.0"]
             [canonical-str "a(b).0|b1<c>.0"]
             [canonical (string->process canonical-str)])
        (check-equal? (string->process str) canonical)))

    (test-case
      "Prevent ambiguity in a composition (reverse)"
      (let* ([str "b<c>.0|a(b).0"]
             [canonical-str "b<c>.0|a(b1).0"]
             [canonical (string->process canonical-str)])
        (check-equal? (string->process str) canonical)))

    (test-case
      "Prevent ambiguity in a composition (complex)"
      (let* ([str "(a1)(a2<a5>.0|a2(a1).0)|a1<a4>.0"]
             [canonical-str "(a1)(a2<a5>.0|a2(a6).0)|a7<a4>.0"]
             [canonical (string->process canonical-str)])
        (check-equal? (string->process str) canonical)))))


; Export public symbols
(provide names-tests)
