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


(require racket/set
         rackunit
         pity)


(define misc-tests
  (test-suite
    "Tests for miscellaneous procedures"

    (test-case
      "Reverse arguments of +"
      (check-equal? ((flip +) 3 1) 4))

    (test-case
      "Reverse arguments of string-append"
      (check-equal? ((flip string-append) "a" "b" "c") "cba"))

    (test-case
      "Reverse arguments of string-append two times"
      (let ([dneppa-gnirts (flip string-append)])
        (check-equal? ((flip dneppa-gnirts) "a" "b" "c") "abc")))

    (test-case
      "Replace elements in an empty list"
      (let* ([lst (list)]
             [a 1]
             [b 2]
             [new-lst lst])
        (check-equal? (list-replace lst a b) new-lst)))

    (test-case
      "Replace non existing elements in a list"
      (let* ([lst (list (name "a") (name "b") (name "c"))]
             [a (name "d")]
             [b (name "e")]
             [new-lst lst])
        (check-equal? (list-replace lst a b) new-lst)))

    (test-case
      "Replace existing elements in a list"
      (let ([lst (list "a" "b" "c" "b" "d" "b")]
            [a "b"]
            [b "l"]
            [new-lst (list "a" "l" "c" "l" "d" "l")])
        (check-equal? (list-replace lst a b) new-lst)))

    (test-case
      "Replace elements in a list, then do the opposite"
      (let* ([lst1 (list 2 3 77 3 3 5)]
             [a 3]
             [b 77]
             [lst2 (list 2 77 77 77 77 5)]
             [lst3 (list 2 3 3 3 3 5)])
        (check-equal? (list-replace lst1 a b) lst2)
        (check-equal? (list-replace (list-replace lst1 a b) b a) lst3)))

    (test-case
      "Make a set out of an empty list"
      (check-equal? (list->set '()) (set)))

    (test-case
      "Make a set out of a list containing no duplicates"
      (check-equal? (list->set '(1 2 3)) (set 1 2 3)))

    (test-case
      "Make a set out of a list containing duplicates"
      (check-equal? (list->set '(1 2 1 3 2)) (set 1 2 3)))

    (test-case
      "Make a list out of an empty set"
      (check-equal? (set->list (set)) (list)))

    (test-case
      "Make a list out of a set"
      (let* ([s (set "c" "b" "a")]
             [lst (set->list s)])
        (check-equal? (list->set lst) s)))

    (test-case
      "Check no element of the empty list is member of an empty set"
      (let ([s (set)]
            [lst (list)])
        (check-false (set-member-any? s lst))))

    (test-case
      "Check no elment of the empty list is member of a set"
      (let ([s (set 1 2 3)]
            [lst (list)])
        (check-false (set-member-any? s lst))))

    (test-case
      "Check no element is member of the empty set"
      (let ([s (set)]
            [lst (list 1 2 3)])
        (check-false (set-member-any? s lst))))

    (test-case
      "Check members are reported correctly if none is found"
      (let ([s (set 1 2 3)]
            [lst (list 4 5 6)])
        (check-false (set-member-any? s lst))))

    (test-case
      "Check members are reported correctly if any is found"
      (let ([s (set 1 2 3)]
            [lst (list 2)])
        (check-true (set-member-any? s lst))))))


; Export public symbols
(provide misc-tests)
