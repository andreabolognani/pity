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
      (let* ([str "x"]
             [name (name str)])
        (check-equal? (name->string name) str)))

    (test-case
      "Print an empty name list"
      (let* ([str ""]
             [names (string->name-list str)])
        (check-equal? (name-list->string names) str)))

    (test-case
      "Print a list containing a single name"
      (let* ([str "x"]
             [names (string->name-list str)])
        (check-equal? (name-list->string names) str)))

    (test-case
      "Print a list containing two names"
      (let* ([str "x,y"]
             [names (string->name-list str)])
        (check-equal? (name-list->string names) str)))

    (test-case
      "Print a nil process"
      (let* ([str "0"]
             [process (string->process str)])
        (check-equal? (process->string process) str)))

    (test-case
      "Print a replicated nil process"
      (let* ([str "!0"]
             [process (string->process str)])
        (check-equal? (process->string process) str)))

    (test-case
      "Print an input action to a single name"
      (let* ([str "x(y).0"]
             [process (string->process str)])
        (check-equal? (process->string process) str)))

    (test-case
      "Print an input action to two names"
      (let* ([str "x(y,z).0"]
             [process (string->process str)])
        (check-equal? (process->string process) str)))

    (test-case
      "Print an output action of a single name"
      (let* ([str "x<y>.0"]
             [process (string->process str)])
        (check-equal? (process->string process) str)))

    (test-case
      "Print an output action of two names"
      (let* ([str "x<y,z>.0"]
             [process (string->process str)])
        (check-equal? (process->string process) str)))

    (test-case
      "Print the restriction over a name"
      (let* ([str "(x)x(y).0"]
             [process (string->process str)])
        (check-equal? (process->string process) str)))

    (test-case
      "Print the restriction over a restriction over a name"
      (let* ([str "(x)(y)x<y>.0"]
             [process (string->process str)])
        (check-equal? (process->string process) str)))

    (test-case
      "Print the replication of a restriction over a name"
      (let* ([str "!(x)x<y>.0"]
             [process (string->process str)])
        (check-equal? (process->string process) str)))

    (test-case
      "Print a composition"
      (let* ([str "0|0"]
             [process (string->process str)])
        (check-equal? (process->string process) str)))

    (test-case
      "Print a composition with a restriction and a replication"
      (let* ([str "(y)x<y>.0|!x(z).0"]
             [process (string->process str)])
        (check-equal? (process->string process) str)))

    (test-case
      "Print a composition under restriction"
      (let* ([str "(x)(x<y>.0|x(z).0)"]
             [process (string->process str)])
        (check-equal? (process->string process) str)))

    (test-case
      "Print a replicated composition"
      (let* ([str "!(x<y>.0|x(z).0)"]
             [process (string->process str)])
        (check-equal? (process->string process) str)))

    (test-case
      "Print a prefix"
      (let* ([str "x<y>.x<z>.0"]
             [process (string->process str)])
        (check-equal? (process->string process) str)))

    (test-case
      "Print a replicated prefix"
      (let* ([str "!x<y>.0"]
             [process (string->process str)])
        (check-equal? (process->string process) str)))

    (test-case
      "Print an empty sorting"
      (let* ([str ""]
             [sorting (string->sorting str)])
        (check-equal? (sorting->string sorting) str)))

    (test-case
      "Print a simple sorting (one object sort)"
      (let* ([str "s=(r)"]
             [sorting (string->sorting str)])
        (check-equal? (sorting->string sorting) str)))

    (test-case
      "Print a simple sorting (two object sorts)"
      (let* ([str "s=(r,t)"]
             [sorting (string->sorting str)])
        (check-equal? (sorting->string sorting) str)))

    (test-case
      "Print a sorting on two subjects"
      (let* ([str "s=(r,t);t=(s)"]
             [sorting (string->sorting str)])
        (check-equal? (sorting->string sorting) str)))

    (test-case
      "Print a sorting with two cases on the same subject"
      (let* ([original "s=(r);s=(t)"]
             [canonical "s=(t)"]
             [sorting (string->sorting original)])
        (check-equal? (sorting->string sorting) canonical)))))


; Export public symbols
(provide print-tests)
