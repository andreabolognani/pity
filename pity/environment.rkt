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


(require "name.rkt"
         "sort.rkt"
         "contracts.rkt"
         "misc.rkt")


(define-struct environment (mappings) #:transparent)


; Empty environment, to be used as a starting point
(define (empty-environment)
  (environment (hash)))


; Get sort for a name
(define (environment-ref self n)
  (let ([mappings (environment-mappings self)])
    (hash-ref mappings n #f)))


; Add a single mapping to an environment
(define (environment-set self n s)
  (let ([mappings (environment-mappings self)])
    (environment (hash-set mappings n s))))


; Add multiple mappings to an environment
(define (environment-set-multiple self n s)
  (if (or (empty? n) (empty? s))
    self
    (environment-set-multiple (environment-set self (car n) (car s))
                              (cdr n)
                              (cdr s))))


; Remove a single mapping from an environment
(define (environment-remove self n)
  (let ([mappings (environment-mappings self)])
    (environment (hash-remove mappings n))))


; Remove multiple mappings from an environment
(define (environment-remove-multiple self n)
  (foldl (flip environment-remove) self n))


; Get domain for an environment
(define (environment-domain self)
  (let ([mappings (environment-mappings self)])
    (list->set (hash-map mappings (lambda (n s) n)))))


; Check environment compatibility
(define (environment-compatible? self n s)
  (let ([r (environment-ref self n)])
    (or (not r)
        (equal? r s))))


; Conversion functions
; --------------------


; Convert an environment to a string
(define (environment->string self)
  (let ([mappings (environment-mappings self)])
    (string-join (hash-map mappings mapping->string) ",")))


; Internal functions
; ------------------


; Convert an environment mapping to a string.
(define (mapping->string n s)
  (string-append (name->string n) ":" (sort->string s)))


; Export public symbols
(provide/contract
  [rename empty-environment
   environment                 (                                             ->   environment?)]
  [environment?                (any/c                                      . -> . boolean?)]
  [environment-ref             (environment? name?                         . -> . (or/c sort? #f))]
  [environment-set             (environment? name? sort?                   . -> . environment?)]
  [environment-set-multiple    (environment? (listof name?) (listof sort?) . -> . environment?)]
  [environment-remove          (environment? name?                         . -> . environment?)]
  [environment-remove-multiple (environment (listof name?)                 . -> . environment?)]
  [environment-domain          (environment?                               . -> . (setof name?))]
  [environment-compatible?     (environment? name? sort?                   . -> . boolean?)]
  [environment->string      (environment?                               . -> . string?)])