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


; Act like (format "~a" lst), but use display-list instead of
; plain display for list pretty-printing
(define (format~a/list lst)
  (let ([out (open-output-string)])
    (display-list lst out #:separator ",")
	(get-output-string out)))


; Wrappers around format
(define (format~a x)
  (if (list? x)
      (format~a/list x)
      (format "~a" x)))
(define format~s (curry format "~s"))
(define format~v (curry format "~v"))


(define print-tests
  (test-suite
    "Tests for print functionality"

    (test-case
      "Print a name"
      (let ([n (name "x")])
        (check-equal? (name->string n) "x")
        (check-equal? (format~a n) "x")
        (check-equal? (format~s n) "(name \"x\")")
        (check-equal? (format~v n) "(name \"x\")")))

    (test-case
      "Print an empty name list"
      (let ([nlst '()])
        (check-equal? (name-list->string nlst) "")
        (check-equal? (format~a nlst) "")
        (check-equal? (format~s nlst) "()")
        (check-equal? (format~v nlst) "'()")))

    (test-case
      "Print a list containing a single name"
      (let ([nlst (list (name "x"))])
        (check-equal? (name-list->string nlst) "x")
        (check-equal? (format~a nlst) "x")
        (check-equal? (format~s nlst) "((name \"x\"))")
        (check-equal? (format~v nlst) "'((name \"x\"))")))

    (test-case
      "Print a list containing two names"
      (let ([nlst (list (name "x") (name "y"))])
        (check-equal? (name-list->string nlst) "x,y")
        (check-equal? (format~a nlst) "x,y")
        (check-equal? (format~s nlst) "((name \"x\") (name \"y\"))")
        (check-equal? (format~v nlst) "'((name \"x\") (name \"y\"))")))

    (test-case
      "Print a list containing three names"
      (let ([nlst (list (name "x") (name "y") (name "z"))])
        (check-equal? (name-list->string nlst) "x,y,z")
        (check-equal? (format~a nlst) "x,y,z")
        (check-equal? (format~s nlst) "((name \"x\") (name \"y\") (name \"z\"))")
        (check-equal? (format~v nlst) "'((name \"x\") (name \"y\") (name \"z\"))")))))


; Export public symbols
(provide print-tests)
