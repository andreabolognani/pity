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


; Assign a value to a name, parsing it as a process.
; If parsing as a process fails, try to parse it as a sorting.
(define (op-set! vars n v)
  (with-handlers ([exn:fail:read?
                   (lambda (e) (op-set!/sorting vars n v))])
    (hash-set vars n (string->process v))))


; Assign a value to a name, parsing it as a sorting.
; If parsing fails, print an error message.
(define (op-set!/sorting vars n v)
  (with-handlers ([exn:fail:read?
                   (lambda (e) (printf "SET!: Invalid value~n") vars)])
    (hash-set vars n (string->sorting v))))


; Display a value according to its type.
(define (op-display vars n)
  (let ([v (hash-ref vars n #f)])
    (cond
      [(process? v) (printf "~a~n" (process->string v))]
      [(sorting? v) (printf "~a~n" (sorting->string v))]
      [else (printf "")])))


; Check whether the process pointed to by n1 respects the sorting
; pointed to by n2. If it does, print all the valid environments.
(define (op-respects? vars n1 n2)
  (let ([p (hash-ref vars n1 #f)]
        [srt (hash-ref vars n2 #f)])
    (if (and (process? p) (sorting? srt))
        (let ([res (process-respects? p srt)])
          (when res
                (set-for-each
                  res
                  (lambda (env)
                    (printf "~a~n" (environment->string env))))))
        (printf "RESPECTS?: Need a process and a sorting~n"))))


; Display an help message
(define (op-help)
  (printf "Operation   Arguments         Description ~n")
  (printf "  SET!        NAME VALUE        Assign VALUE to NAME~n")
  (printf "  DISPLAY     NAME              Show the value of NAME~n")
  (printf "  RESPECTS?   PROCESS SORTING   Show environments in which ~n")
  (printf "                                PROCESS respects SORTING~n")
  (printf "  HELP                          Show this help message~n"))


; Allow the procedure called by the REPL to maintain some state.
;
; The action-with-state procedure is called with two additional
; arguments: the line number, and a hash table containing mappings
; from variable names to values. The value returned by the procedure
; is the updated hash table.
(define action #f)
(let ([lineno 0]
      [vars (hash)])
  (set! action (lambda (line)
                 (set! vars (action-with-state line lineno vars))
                 (set! lineno (+ lineno 1)))))


; Parse the input and act accordingly
(define (action-with-state line lineno vars)
  (let* ([parts (regexp-split #rx" +" line)]
         [op (car parts)]
         [lop (if (< (length parts) 2) "" (cadr parts))]
         [rop (if (< (length parts) 3) "" (apply string-append (cddr parts)))])
    (cond
      [(string-ci=? op "SET!") (set! vars (op-set! vars lop rop))]
      [(string-ci=? op "DISPLAY") (op-display vars lop)]
      [(string-ci=? op "RESPECTS?") (op-respects? vars lop rop)]
      [(string-ci=? op "HELP") (op-help)]
      [else (printf "Operation not supported ~a~n" op)])
    vars))


; Start the evaluation loop
(repl action "pity> ")
