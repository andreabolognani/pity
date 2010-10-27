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


(require racket/contract
         racket/string
         parser-tools/yacc
         "private/common-lexer.rkt"
         "sort.rkt"
         "contracts.rkt"
         "misc.rkt")



; Structure definition
; --------------------


(struct sorting (mappings)
                #:transparent)


; Empty sorting, to be used as a starting point.
;
; This procedure is renamed to sorting when exporting; inside this
; module, sorting is the actual constructor.
(define (empty-sorting)
  (sorting (hash)))



; Manipulation routines
; ---------------------
;
;  These procedures are used to manipulate sortings by adding
;  mappings, removing mappings, and getting the object sort for a
;  subject sort.


; Get object sort for a subject sort
(define (sorting-ref self subj)
  (let ([mappings (sorting-mappings self)])
    (hash-ref mappings subj #f)))


; Add mappings to a sorting
(define (sorting-set self subj obj)
  (let ([mappings (sorting-mappings self)])
    (sorting (hash-set mappings subj obj))))


; Remove mappings from a sorting
(define (sorting-remove self subj)
  (let ([mappings (sorting-mappings self)])
    (sorting (hash-remove mappings subj))))


; Get domain for a sorting
(define (sorting-domain self)
  (let ([mappings (sorting-mappings self)])
    (list->set (hash-map mappings (lambda (s o) s)))))



; Conversion routines
; -------------------
;
;  Convert strings to environments, and the other way around.


; Convert a sorting to a string
(define (sorting->string self)
  (let ([mappings (sorting-mappings self)])
    (string-join (hash-map mappings mapping->string) ";")))


; Convert a sorting to a string
(define (string->sorting str)
  (if (not (equal? str ""))
    (with-handlers ([exn:fail?
                     (lambda (e)
                       (raise (exn:fail "Error while parsing sorting"
                                        (exn-continuation-marks e))))])
      (let ([ip (open-input-string str)])
        (sorting-parser (lambda () (common-lexer ip)))))
    (empty-sorting)))


; Parser for sortings
(define sorting-parser
  (parser

    (start  sorting)
    (end    EOF)
    (tokens common-symbols common-values)
    (error  (lambda (a b c) (void)))

    (grammar

      (sorting
        [(part)                   (sorting-set (empty-sorting) (car $1) (cdr $1))]
        [(sorting SEMICOLON part) (sorting-set $1 (car $3) (cdr $3))])

      (part
        [(sort EQ LP sorts RP)    (cons $1 $4)])

      (sorts
        [(sort)                   (list $1)]
        [(sort COMMA sorts)       (list* $1 $3)])

      (sort
        [(ID)                     (sort $1)]))))



; Utility functions
; -----------------


; Convert a single mapping to its string representation
(define (mapping->string key value)
  (string-append (sort->string key) "=("
                 (sort-list->string value) ")"))



; Export public symbols
; ---------------------

(provide/contract
  [rename empty-sorting
   sorting         (                                          ->   sorting?)]
  [sorting?        (any/c                                   . -> . boolean?)]
  [sorting-ref     (sorting? sort?                          . -> . (or/c (non-empty-listof sort?) #f))]
  [sorting-set     (sorting? sort? (non-empty-listof sort?) . -> . sorting?)]
  [sorting-remove  (sorting? sort?                          . -> . sorting?)]
  [sorting-domain  (sorting?                                . -> . (setof sort?))]
  [sorting->string (sorting?                                . -> . string?)]
  [string->sorting (string?                                 . -> . sorting?)])
