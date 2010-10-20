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


(define sortings-tests
  (test-suite
    "Tests for sortings"

    (test-case
      "Get object sort for a non existing subject sort"
      (let ([srt (string->sorting "s=(r,t)")]
            [subj (sort "r")]
            [obj #f])
        (check-equal? (sorting-ref srt subj) obj)))

    (test-case
      "Get object sort for an existing subject sort"
      (let ([srt (string->sorting "s=(r,t)")]
            [subj (sort "s")]
            [obj (list (sort "r") (sort "t"))])
        (check-equal? (sorting-ref srt subj) obj)))

    (test-case
      "Add a new mapping to a sorting"
      (let* ([srt (sorting)]
             [subj (sort "s")]
             [obj (list (sort "r") (sort "t"))]
             [srt (sorting-set srt subj obj)])
        (check-equal? (sorting-ref srt subj) obj)))

    (test-case
      "Order in adding mappings to a sorting doesn't matter"
      (let* ([srt (sorting)]
             [subj1 (sort "s")]
             [obj1 (list (sort "r") (sort "t"))]
             [subj2 (sort "t")]
             [obj2 (list (sort "s"))]
             [srt1 (sorting-set srt subj1 obj1)]
             [srt1 (sorting-set srt1 subj2 obj2)]
             [srt2 (sorting-set srt subj2 obj2)]
             [srt2 (sorting-set srt2 subj1 obj1)])
        (check-equal? srt1 srt2)))

    (test-case
      "Remove an existing mapping from a sorting"
      (let* ([srt1 (string->sorting "s=(r,t)")]
             [subj1 (sort "s")]
             [obj1 (list (sort "r") (sort "t"))]
             [srt2 (sorting-remove srt1 subj1)]
             [subj2 subj1]
             [obj2 #f])
        (check-equal? (sorting-ref srt1 subj1) obj1)
        (check-equal? (sorting-ref srt2 subj2) obj2)))

    (test-case
      "Remove a non existing mapping from a sorting"
      (let* ([srt1 (string->sorting "s=(r,t)")]
             [subj1 (sort "r")]
             [obj1 #f]
             [srt2 (sorting-remove srt1 subj1)]
             [subj2 subj1]
             [obj2 obj1])
        (check-equal? (sorting-ref srt1 subj1) obj1)
        (check-equal? (sorting-ref srt2 subj2) obj2)))

    (test-case
      "Check domain of the empty sorting"
      (let ([srt (string->sorting "")]
            [dom (set)])
        (check-equal? (sorting-domain srt) dom)))

    (test-case
      "Check domain of a non empty sort (one mapping)"
      (let ([srt (string->sorting "s=(r,t)")]
            [dom (set (sort "s"))])
        (check-equal? (sorting-domain srt) dom)))

    (test-case
      "Check domain of a non empty sort (two mappings)"
      (let ([srt (string->sorting "s=(r,t);r=(t)")]
            [dom (set (sort "s") (sort "r"))])
        (check-equal? (sorting-domain srt) dom)))))


; Export public symbols
(provide sortings-tests)
