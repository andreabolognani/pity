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


(define print-tests
  (test-suite
    "Tests for print functionality"

    (test-case
      "Print a name"
      (let* ([display-string "x"]
             [name (name display-string)])
        (check-equal? (name->string name) display-string)))

    (test-case
      "Print an empty name list"
      (let* ([display-string ""]
             [names (string->name-list display-string)])
        (check-equal? (name-list->string names) display-string)))

    (test-case
      "Print a list containing a single name"
      (let* ([display-string "x"]
             [names (string->name-list display-string)])
        (check-equal? (name-list->string names) display-string)))

    (test-case
      "Print a list containing two names"
      (let* ([display-string "x,y"]
             [names (string->name-list display-string)])
        (check-equal? (name-list->string names) display-string)))

    (test-case
      "Print a nil process"
      (let* ([display-string "0"]
             [process (string->process display-string)])
        (check-equal? (process->string process) display-string)))

    (test-case
      "Print a replicated nil process"
      (let* ([display-string "!0"]
             [read-string "(replication (nil))"]
             [process (string->process display-string)])
        (check-equal? (process->string process) display-string)))

    (test-case
      "Print an input action to a single name"
      (let* ([display-string "x(y)"]
             [process (string->process display-string)])
        (check-equal? (process->string process) display-string)))

    (test-case
      "Print an input action to two names"
      (let* ([display-string "x(y,z)"]
             [process (string->process display-string)])
        (check-equal? (process->string process) display-string)))

    (test-case
      "Print an output action of a single name"
      (let* ([display-string "x<y>"]
             [process (string->process display-string)])
        (check-equal? (process->string process) display-string)))

    (test-case
      "Print an output action of two names"
      (let* ([display-string "x<y,z>"]
             [process (string->process display-string)])
        (check-equal? (process->string process) display-string)))

    (test-case
      "Print the restriction over a name"
      (let* ([display-string "(x)x(y)"]
             [process (string->process display-string)])
        (check-equal? (process->string process) display-string)))

    (test-case
      "Print the restriction over a restriction over a name"
      (let* ([display-string "(x)(y)x<y>"]
             [process (string->process display-string)])
        (check-equal? (process->string process) display-string)))

    (test-case
      "Print the replication of a restriction over a name"
      (let* ([display-string "!(x)x<y>"]
             [process (string->process display-string)])
        (check-equal? (process->string process) display-string)))

    (test-case
      "Print a composition"
      (let* ([display-string "0|0"]
             [process (string->process display-string)])
        (check-equal? (process->string process) display-string)))

    (test-case
      "Print a composition with a restriction and a replication"
      (let* ([display-string "(y)x<y>|!x(z)"]
             [process (string->process display-string)])
        (check-equal? (process->string process) display-string)))

    (test-case
      "Print a composition under restriction"
      (let* ([display-string "(x)(x<y>|x(z))"]
             [process (string->process display-string)])
        (check-equal? (process->string process) display-string)))

    (test-case
      "Print a replicated composition"
      (let* ([display-string "!(x<y>|x(z))"]
             [process (string->process display-string)])
        (check-equal? (process->string process) display-string)))

    (test-case
      "Print a prefix"
      (let* ([display-string "x<y>.x<z>"]
             [process (string->process display-string)])
        (check-equal? (process->string process) display-string)))

    (test-case
      "Print a replicated prefix"
      (let* ([display-string "!x<y>.0"]
             [process (string->process display-string)])
        (check-equal? (process->string process) display-string)))

    (test-case
      "Print an empty sorting"
      (let* ([display-string ""]
             [sorting (string->sorting display-string)])
        (check-equal? (sorting->string sorting) display-string)))

    (test-case
      "Print a simple sorting (one object sort)"
      (let* ([display-string "s=(r)"]
             [sorting (string->sorting display-string)])
        (check-equal? (sorting->string sorting) display-string)))

    (test-case
      "Print a simple sorting (two object sorts)"
      (let* ([display-string "s=(r,t)"]
             [sorting (string->sorting display-string)])
        (check-equal? (sorting->string sorting) display-string)))

    (test-case
      "Print a sorting on two subjects"
      (let* ([display-string "s=(r,t);t=(s)"]
             [sorting (string->sorting display-string)])
        (check-equal? (sorting->string sorting) display-string)))

    (test-case
      "Print a sorting with two cases on the same subject"
      (let* ([original "s=(r);s=(t)"]
             [canonical "s=(t)"]
             [sorting (string->sorting original)])
        (check-equal? (sorting->string sorting) canonical)))))


; Export public symbols
(provide print-tests)
