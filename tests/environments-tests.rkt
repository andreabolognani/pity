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


(define environments-tests
  (test-suite
    "Tests for environments"

    (test-case
      "Get sort for a non existing name"
      (let ([env (string->environment "{x:s}")]
            [n (name "y")]
            [s #f])
        (check-equal? (environment-ref env n) s)))

    (test-case
      "Get sort for an existing name"
      (let ([env (string->environment "{x:s}")]
            [n (name "x")]
            [s (sort "s")])
        (check-equal? (environment-ref env n) s)))

    (test-case
      "Get sorts for two non existing names"
      (let ([env (string->environment "{}")]
            [n (list (name "x") (name "y"))]
            [s (list #f #f)])
        (check-equal? (environment-ref-multiple env n) s)))

    (test-case
      "Get sorts for one existing and one non existing names"
      (let ([env (string->environment "{x:s}")]
            [n (list (name "x") (name "y"))]
            [s (list (sort "s") #f)])
        (check-equal? (environment-ref-multiple env n) s)))

    (test-case
      "Get sorts for two existing names"
      (let ([env (string->environment "{x:s,y:t}")]
            [n (list (name "x") (name "y"))]
            [s (list (sort "s") (sort "t"))])
        (check-equal? (environment-ref-multiple env n) s)))

    (test-case
      "Add a new mapping to an environment"
      (let* ([env (string->environment "{}")]
             [n (name "x")]
             [s (sort "s")]
             [env (environment-set env n s)])
        (check-equal? (environment-ref env n) s)))

    (test-case
      "Replace a mapping in an environment"
      (let* ([env (string->environment "{}")]
             [n1 (name "x")]
             [s1 (sort "s")]
             [env1 (environment-set env n1 s1)]
             [n2 n1]
             [s2 (sort "t")]
             [env2 (environment-set env1 n2 s2)])
        (check-equal? (environment-ref env1 n1) s1)
        (check-equal? (environment-ref env2 n2) s2)))

    (test-case
      "Order doesn't matter when adding mappings"
      (let* ([env (string->environment "{}")]
             [n1 (name "x")]
             [s1 (sort "s")]
             [n2 (name "y")]
             [s2 (sort "t")]
             [env1 (environment-set env n1 s1)]
             [env1 (environment-set env1 n2 s2)]
             [env2 (environment-set env n2 s2)]
             [env2 (environment-set env2 n1 s1)])
        (check-equal? env1 env2)))

    (test-case
      "Add an empty list of mappings"
      (let* ([env (string->environment "{x:s,y:t}")]
             [n (list)]
             [s (list)]
             [env1 (environment-set-multiple env n s)])
        (check-equal? env env1)))

    (test-case
      "Add two mappings at the same time"
      (let* ([env (string->environment "{}")]
             [n (list (name "x") (name "y"))]
             [s (list (sort "s") (sort "t"))]
             [env1 (environment-set-multiple env n s)])
        (check-equal? (environment-ref-multiple env1 n) s)))

    (test-case
      "Order doesn't matter when adding multiple mappings"
      (let* ([env (string->environment "{}")]
             [n1 (list (name "x") (name "y"))]
             [s1 (list (sort "s") (sort "t"))]
             [env1 (environment-set-multiple env n1 s1)]
             [n2 (reverse n1)]
             [s2 (reverse s1)]
             [env2 (environment-set-multiple env n2 s2)])
        (check-equal? env1 env2)))

    (test-case
      "Add one name and two sorts"
      (let* ([env (string->environment "{}")]
             [n1 (list (name "x"))]
             [s1 (list (sort "s") (sort "t"))]
             [env1 (environment-set-multiple env n1 s1)]
             [n2 (list (name "x") (name "y"))]
             [s2 (list (sort "s") #f)])
        (check-equal? (environment-ref-multiple env1 n2) s2)))

    (test-case
      "Add one sort and two names"
      (let* ([env (string->environment "{}")]
             [n1 (list (name "x") (name "y"))]
             [s1 (list (sort "s"))]
             [env1 (environment-set-multiple env n1 s1)]
             [n2 (list (name "x") (name "y"))]
             [s2 (list (sort "s") #f)])
        (check-equal? (environment-ref-multiple env1 n2) s2)))

    (test-case
      "Remove an existing mapping from an environment"
      (let* ([env1 (string->environment "{x:s}")]
             [n1 (name "x")]
             [s1 (sort "s")]
             [env2 (environment-remove env1 n1)]
             [n2 n1]
             [s2 #f])
        (check-equal? (environment-ref env1 n1) s1)
        (check-equal? (environment-ref env2 n2) s2)))

    (test-case
      "Remove a non existing mapping from an environment"
      (let* ([env1 (string->environment "{x:s}")]
             [n (name "y")]
             [s #f]
             [env2 (environment-remove env1 n)])
        (check-equal? (environment-ref env1 n) s)
        (check-equal? (environment-ref env2 n) s)))

    (test-case
      "Remove no mappings from an environment"
      (let* ([env1 (string->environment "{x:s}")]
             [n (list)]
             [env2 (environment-remove-multiple env1 n)])
        (check-equal? env1 env2)))

    (test-case
      "Remove a non existing mapping from an environment"
      (let* ([env1 (string->environment "{x:s}")]
             [n (list (name "y"))]
             [env2 (environment-remove-multiple env1 n)])
        (check-equal? env1 env2)))

    (test-case
      "Remove an existing mapping from an environment"
      (let* ([env1 (string->environment "{x:s,y:t}")]
             [n (list (name "x"))]
             [env2 (environment-remove-multiple env1 n)]
             [s (list #f)])
        (check-equal? (environment-ref-multiple env2 n) s)))

    (test-case
      "Remove an existing and a non existing mapping"
      (let* ([env1 (string->environment "{x:s}")]
             [n (list (name "x") (name "y"))]
             [env2 (environment-remove-multiple env1 n)]
             [s (list #f #f)])
        (check-equal? (environment-ref-multiple env2 n) s)))

    (test-case
      "Check domain of the empty environment"
      (let ([env (string->environment "{}")]
            [dom (set)])
        (check-equal? (environment-domain env) dom)))

    (test-case
      "Check domain of an environment (one mapping)"
      (let ([env (string->environment "{x:s}")]
            [dom (set (name "x"))])
        (check-equal? (environment-domain env) dom)))

    (test-case
      "Check domain of an environment (two mappings)"
      (let ([env (string->environment "{x:s,y:t}")]
            [dom (set (name "x") (name "y"))])
        (check-equal? (environment-domain env) dom)))))


; Export public symbols
(provide environments-tests)
