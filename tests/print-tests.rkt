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


; Make a list of names out of a string
(define (string->name-list str)
  (cond [(equal? str "") '()]
        [else (map name (regexp-split #rx", *" str))]))


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


; Reusable test body
(define (test-body v display-string read-string [eval-string read-string])
  (check-equal? (format~a v) display-string)
  (check-equal? (format~s v) read-string)
  (check-equal? (format~v v) eval-string))


(define print-tests
  (test-suite
    "Tests for print functionality"

    (test-case
      "Print a name"
      (let* ([display-string "x"]
             [read-string "(name \"x\")"]
             [name (name display-string)])
        (test-body name display-string read-string)))

    (test-case
      "Print an empty name list"
      (let* ([display-string ""]
             [read-string "()"]
             [eval-string (string-append "'" read-string)]
             [names (string->name-list display-string)])
        (test-body names display-string read-string eval-string)))

    (test-case
      "Print a list containing a single name"
      (let* ([display-string "x"]
             [read-string "((name \"x\"))"]
             [eval-string (string-append "'" read-string)]
             [names (string->name-list display-string)])
        (test-body names display-string read-string eval-string)))

    (test-case
      "Print a list containing two names"
      (let* ([display-string "x,y"]
             [read-string "((name \"x\") (name \"y\"))"]
             [eval-string (string-append "'" read-string)]
             [names (string->name-list display-string)])
        (test-body names display-string read-string eval-string)))

    (test-case
      "Print a list containing three names"
      (let* ([display-string "x,y,z"]
             [read-string "((name \"x\") (name \"y\") (name \"z\"))"]
             [eval-string (string-append "'" read-string)]
             [names (string->name-list display-string)])
        (test-body names display-string read-string eval-string)))

    (test-case
      "Print a nil process"
      (let* ([display-string "0"]
             [read-string "(nil)"]
             [process (string->process display-string)])
        (test-body process display-string read-string)))))


; Export public symbols
(provide print-tests)
