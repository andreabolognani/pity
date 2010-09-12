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


(require "sort.rkt")


(define-struct sorting (function) #:transparent)


; Empty sorting, to be used as a starting point
(define empty-sorting
  (sorting (lambda (s) #f)))


; Get object sort for a subject sort
(define (sorting-get self subj)
  (let ([fun (sorting-function self)])
    (fun subj)))


; Add mappings to a sorting
(define (sorting-add self subj obj)
  (let* ([fun     (sorting-function self)]
         [newfun  (lambda (s) (if (equal? s subj) obj (fun s)))])
    (sorting newfun)))


; Remove mappings from a sorting
(define (sorting-remove self subj)
  (let* ([fun     (sorting-function self)]
         [newfun  (lambda (s) (if (equal? s subj) #f (fun s)))])
    (sorting newfun)))


(provide/contract
  [empty-sorting  sorting?]
  [sorting?       (any/c                         . -> . boolean?)]
  [sorting-get    (sorting? sort?                . -> . (or/c (listof sort?) #f))]
  [sorting-add    (sorting? sort? (listof sort?) . -> . sorting?)]
  [sorting-remove (sorting? sort?                . -> . sorting?)])
