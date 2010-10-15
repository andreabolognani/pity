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


(require racket/contract
         racket/function
         racket/list
         racket/set)



; Generic contracts
; -----------------
;
;  These contracts are generic enough that including them in the
;  Racket standard library would probably make sense.


; Recognize a set of items all matching the same contract
(define (setof c)
  (flat-named-contract
    (string-append "(setof " (contract->string c) ")")
    (lambda (x)
      (and (set? x)
           (foldl (lambda (x y) (and x y)) ; Binary and wrapper
                  #t
                  (set-map x (contract-procedure c)))))))


; Recognize a non empty set of items all matching the same contract
(define (non-empty-setof c)
  (flat-named-contract
    (string-append "(non-empty-setof " (contract->string c) ")")
    (and/c (setof c)
           (not/c set-empty?))))


; Recognize a list of items, all matching the same contract,
; containing no repetitions
(define (listof-distinct c)
  (flat-named-contract
    (string-append "(listof-distinct " (contract->string c) ")")
    (lambda (x)
      (and ((listof c) x)
           (= (length x) (length (remove-duplicates x)))))))


; Like listof-distinct, but requires the list not to be empty
(define (non-empty-listof-distinct c)
  (flat-named-contract
    (string-append "(non-empty-listof-distinct " (contract->string c) ")")
    (and/c (listof-distinct c)
           (not/c null?))))


; Recognize a non-empty string
(define (non-empty-string? x)
  (and (string? x)
       (not (= (string-length x) 0))))



; Specific contracts
; ------------------
;
;  Unlike the ones defined above, these contracts are tied to the
;  application, and would make little sense outside of it.


; Recognize a string suitable to be used as an identifier
(define (id-string? x)
  (and (string? x)
       (regexp-match? #rx"^[a-zA-Z]+[0-9]*$" x)))


; Utility functions
; -----------------


; Convert the contract name to a string
(define (contract->string c)
  (format "~a" (contract-name c)))


; Create a procedure which checks a contract.
;
; Works with procedures, regexps and simple values.
(define (contract-procedure c)
  (cond [(procedure? c) c]
        [(regexp? c) (lambda (x) (and (string? x) (regexp-match c x)))]
        [else (curry equal? c)]))



; Export public symbols
; ---------------------

(provide/contract
  [setof                     (contract? . -> . contract?)]
  [non-empty-setof           (contract? . -> . contract?)]
  [listof-distinct           (contract? . -> . contract?)]
  [non-empty-listof-distinct (contract? . -> . contract?)]
  [non-empty-string?         (any/c     . -> . boolean?)]
  [id-string?                (any/c     . -> . boolean?)])
