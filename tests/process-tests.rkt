#lang racket/base

; Pity: Pi-Calculus Type Inference
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


(require racket/set
         rackunit
         pity)


(define process-tests
  (test-suite
    "Tests for processes"

    (test-case
      "Test whether process? works correctly"
      (check-true (process? (string->process "0")))
      (check-true (process? (string->process "!a<b>.0")))
      (check-true (process? (string->process "x(y).0")))
      (check-true (process? (string->process "x<y>.0")))
      (check-true (process? (string->process "(x)0")))
      (check-true (process? (string->process "0|0")))
      (check-false (process? "x<y>.0|x(z).0"))
      (check-false (process? (name "x")))
      (check-false (process? 42)))

    (test-case
      "Test whether action? works correctly"
      (check-false (action? (string->process "0")))
      (check-false (action? (string->process "a(b).0")))
      (check-false (action? (string->process "a<b>.a<c>.0")))
      (check-true (action? (input (name "a") (list (name "b")))))
      (check-true (action? (output (name "a") (list (name "b"))))))

    (test-case
      "Find environments (no free names)"
      (let* ([p (string->process "0")]
             [srt (string->sorting "s=(r,t)")]
             [envs (set)])
        (check-equal? (process-environments p srt) envs)))

    (test-case
      "Find environments (empty sorting)"
      (let* ([p (string->process "x(y).0")]
             [srt (string->sorting "")]
             [envs (set)])
        (check-equal? (process-environments p srt) envs)))

    (test-case
      "Find environments (one free name)"
      (let* ([p (string->process "x(y).0")]
             [srt (string->sorting "s=(r,t);t=(r);r=(r)")]
             [envs (set)]
             [envs (set-add envs (string->environment "{x:s}"))]
             [envs (set-add envs (string->environment "{x:t}"))]
             [envs (set-add envs (string->environment "{x:r}"))])
        (check-equal? (process-environments p srt) envs)))

    (test-case
      "Find environments (three free names)"
      (let* ([p (string->process "x<y,z>.0")]
             [srt (string->sorting "s=(r,t);t=(r)")]
             [envs (set)]
             [envs (set-add envs (string->environment "{x:s,y:s,z:s}"))]
             [envs (set-add envs (string->environment "{x:s,y:s,z:t}"))]
             [envs (set-add envs (string->environment "{x:s,y:t,z:s}"))]
             [envs (set-add envs (string->environment "{x:s,y:t,z:t}"))]
             [envs (set-add envs (string->environment "{x:t,y:s,z:s}"))]
             [envs (set-add envs (string->environment "{x:t,y:s,z:t}"))]
             [envs (set-add envs (string->environment "{x:t,y:t,z:s}"))]
             [envs (set-add envs (string->environment "{x:t,y:t,z:t}"))])
        (check-equal? (process-environments p srt) envs)))

    (test-case
      "Check typing for a simple process"
      (let* ([p (string->process "!(a)(a<b,c>.0|a(u,v).0)")]
             [srt (string->sorting "s=(t,r);t=(s);r=(r)")]
             [envs (set)]
             [envs (set-add envs (string->environment "{b:t,c:r}"))])
        (check-equal? (process-respects? p srt) envs)))

    (test-case
      "Check typing for a process with arity mismatch"
      (let* ([p (string->process "a<b,c>.0|a(u).0")]
             [srt (string->sorting "s=(t,r);t=(s);r=(r)")]
             [envs #f])
        (check-equal? (process-respects? p srt) envs)))))


; Export public symbols
(provide process-tests)
