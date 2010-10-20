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


(define contracts-tests
  (test-suite
    "Tests for generic contracts"

    (test-case
      "Test non-empty-string? on a non-empty string"
      (check-true (non-empty-string? "a")))

    (test-case
      "Test non-empty-string? on an empty string"
      (check-false (non-empty-string? "")))

    (test-case
      "Test non-empty-string? on a number"
      (check-false (non-empty-string? 42)))

    (test-case
      "Test non-empty-string? on a name"
      (check-false (non-empty-string? (name "x"))))

    (test-case
      "Test id-string? on a number"
      (check-false (id-string? 42)))

    (test-case
      "Test id-string? on an empty string"
      (check-false (id-string? "")))

	(test-case
      "Test id-string? on a string starting with a digit"
      (check-false (id-string? "1a")))

    (test-case
      "Test id-string? on a string containing illegal symbols"
      (check-false (id-string? "a_b")))

    (test-case
      "Test id-string? on a string containing digits not in tail position"
      (check-false (id-string? "r2d2")))

    (test-case
      "Test id-string? on a suitable string (one character)"
      (check-true (id-string? "a")))

    (test-case
      "Test id-string? on a suitable string (many characters)"
      (check-true (id-string? "LaTeX")))

    (test-case
      "Test id-string? on a suitable string"
      (check-true (id-string? "plan9"))
      (check-true (id-string? "Python3000")))

    (test-case
      "Test (setof string?) on a set of strings"
      (check-true ((setof string?) (set "a" "b")))
      (check-true ((non-empty-setof string?) (set "a" "b"))))

    (test-case
      "Test (setof string?) on an empty set"
      (check-true ((setof string?) (set)))
      (check-false ((non-empty-setof string?) (set))))

    (test-case
      "Test (setof string?) on a set containing a number"
      (check-false ((setof string?) (set "a" 42 "b")))
      (check-false ((non-empty-setof string?) (set "a" 42 "b"))))

    (test-case
      "Test (setof string?) on a list of strings"
      (check-false ((setof string?) (list "a" "b")))
      (check-false ((non-empty-setof string?) (list "a" "b"))))

    (test-case
      "Test (setof string?) on a single string"
      (check-false ((setof string?) "a"))
      (check-false ((non-empty-setof string?) "a")))

    (test-case
      "Test (setof 42) on a set of 42s"
      (check-true ((setof 42) (set 42)))
      (check-true ((non-empty-setof 42) (set 42))))

    (test-case
      "Test (setof 42) on an empty set"
      (check-true ((setof 42) (set)))
      (check-false ((non-empty-setof 42) (set))))

    (test-case
      "Test (setof 42) on a set containing a different number"
      (check-false ((setof 42) (set 42 3)))
      (check-false ((non-empty-setof 42) (set 42 3))))

    (test-case
      "Test (setof 24) on a set containing a symbol"
      (check-false ((setof 42) (set 42 'a)))
      (check-false ((non-empty-setof 42) (set 42 'a))))

    (test-case
      "Test (setof 42) on a list of 42s"
      (check-false ((setof 42) (list 42 42)))
      (check-false ((non-empty-setof 42) (list 42 42))))

    (test-case
      "Test (setof 42) on a single 42"
      (check-false ((setof 42) 42))
      (check-false ((non-empty-setof 42) 42)))

    (test-case
      "Test (setof #rx\"a|b\") on a set of matching strings"
      (check-true ((setof #rx"a|b") (set "a" "b")))
      (check-true ((non-empty-setof #rx"a|b") (set "a" "b"))))

    (test-case
      "Test (setof #rx\"a|b\") on an empty set"
      (check-true ((setof #rx"a|b") (set)))
      (check-false ((non-empty-setof #rx"a|b") (set))))

    (test-case
      "Test (setof #rx\"a|b\") on a set containing a non-matching string"
      (check-false ((setof #rx"a|b") (set "a" "c")))
      (check-false ((non-empty-setof #rx"a|b") (set "a" "c"))))

    (test-case
      "Test (setof #rx\"a|b\") on a set containing a number"
      (check-false ((setof #rx"a|b") (set "a" 42)))
      (check-false ((non-empty-setof #rx"a|b") (set "b" 42))))

    (test-case
      "Test (setof #rx\"a|b\") on a list of matching strings"
      (check-false ((setof #rx"a|b") (list "a" "b")))
      (check-false ((non-empty-setof #rx"a|b") (list "a" "b"))))

    (test-case
      "Test (setof #rx\"a|b\") on a single matching string"
      (check-false ((setof #rx"a|b") "a"))
      (check-false ((non-empty-setof #rx"a|b") "a")))

    (test-case
      "Test (listof-distinct string?) on the empty list"
      (check-true ((listof-distinct string?) (list)))
      (check-false ((non-empty-listof-distinct string?) (list))))

    (test-case
      "Test (listof-distinct string?) on a list of string with duplicates"
      (check-false ((listof-distinct string?) (list "a" "a")))
      (check-false ((non-empty-listof-distinct string?) (list "a" "a"))))

    (test-case
      "Test (listof-distinct string?) on a list of strings"
      (check-true ((listof-distinct string?) (list "g" "a")))
      (check-true ((non-empty-listof-distinct string?) (list "g" "a"))))))


; Export public symbols
(provide contracts-tests)
