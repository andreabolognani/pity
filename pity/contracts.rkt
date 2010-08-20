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


;; Contracts
;; ---------
;;
;;  Pretty generic contracts one would expect to find built-in.


;; Get the name for a contract.
;; The name is the object-name of the contract if the contract has
;; one, or the same string that would be printed by display
(define (contract-name c)
  (let ([name (object-name c)])
    (cond [(false? name) (format "~a" c)]
          [(symbol? name) (symbol->string name)]
          [else name])))


;; Create a procedure which checks a contract.
;; Works with procedures, regexps and simple values.
(define (contract-procedure c)
  (cond [(procedure? c) c]
        [(regexp? c) (lambda (x) (and (string? x) (regexp-match c x)))]
        [else (curry equal? c)]))


(define (setof c)
  (flat-named-contract
    (string-append "(setof " (contract-name c) ")")
    (lambda (x)
      (and (set? x)
           (foldl (lambda (x y) (and x y)) ; Binary and wrapper
                  #t
                  (set-map x (contract-procedure c)))))))


(define (non-empty-setof c)
  (flat-named-contract
    (string-append "(non-empty-setof " (contract-name c) ")")
    (and/c (setof c)
           (not/c set-empty?))))


(define (non-empty-string? x)
  (and (string? x)
       (not (= (string-length x) 0))))


;; Export public symbols
(provide/contract
  [setof             (contract? . -> . contract?)]
  [non-empty-setof   (contract? . -> . contract?)]
  [non-empty-string? (any/c     . -> . boolean?)])
