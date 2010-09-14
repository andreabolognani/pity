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


(require pity
         "repl.rkt")


; Pretty-print a set of names to a string
(define (pretty-set s)
  (let ([names (set-map s name->string)])
    (string-append "{" (string-join names ",") "}")))


; Try to parse the line as a process: if succesful, print the process
; followed by its free and bound names, otherwise try parsing the line
; as a sorting
(define (try-process-and-sorting line)
  (with-handlers ([exn:fail:read?
                   (lambda (e) (try-sorting line))])
    (let ([process (string->process line)])
      (printf "Process     : ~a~n" (process->string process))
      (printf "Free names  : ~a~n" (pretty-set (free-names process)))
      (printf "Bound names : ~a~n" (pretty-set (bound-names process))))))


; Try to parse the line as a sorting, and print an error message if
; the sorting cannot be parsed
(define (try-sorting line)
  (with-handlers ([exn:fail:read?
                   (lambda (e) (printf "ERR: Exception caught~n"))])
    (let ([sorting (string->sorting line)])
      (printf "Sorting : ~a~n" (sorting->string sorting)))))


; Start the evaluation loop
(repl try-process-and-sorting "pity> ")
