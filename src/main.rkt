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
(define (cmd-set! vars n v lineno)
  (with-handlers ([exn:fail?
                   (lambda (e)
                     (cmd-set!/sorting vars n v lineno))])
    (hash-set vars n (string->process v))))


; Assign a value to a name, parsing it as a sorting.
; If parsing fails, print an error message.
(define (cmd-set!/sorting vars n v lineno)
  (with-handlers ([exn:fail?
                   (lambda (e)
                     (printf "~a: SET!: Invalid value~n" lineno)
                     vars)])
    (hash-set vars n (string->sorting v))))


; Display a value according to its type.
(define (cmd-display vars n)
  (let ([v (hash-ref vars n #f)])
    (cond
      [(process? v) (printf "~a~n" (process->string v))]
      [(sorting? v) (printf "~a~n" (sorting->string v))]
      [else (printf "")])))


; Check whether the process pointed to by n1 respects the sorting
; pointed to by n2. If it does, print all the valid environments.
(define (cmd-respects? vars n1 n2 lineno)
  (let ([p (hash-ref vars n1 #f)]
        [srt (hash-ref vars n2 #f)])
    (if (and (process? p) (sorting? srt))
        (let ([res (process-respects? p srt)])
          (when res
                (set-for-each
                  res
                  (lambda (env)
                    (printf "~a~n" (environment->string env))))))
        (printf "~a: RESPECTS?: Need a process and a sorting~n" lineno))))


; Display an help message
(define (cmd-help)
  (printf "Command     Arguments         Description ~n")
  (printf "  SET!        NAME VALUE        Assign VALUE to NAME~n")
  (printf "  DISPLAY     NAME              Show the value of NAME~n")
  (printf "  RESPECTS?   PROCESS SORTING   Show environments in which ~n")
  (printf "                                PROCESS respects SORTING~n")
  (printf "  HELP                          Show this help message~n")
  (printf "  QUIT                          Quit~n"))


; Parse the input and act accordingly
(define (action line lineno vars)
  (let* ([parts (regexp-split #rx" +" line)]
         [cmd (car parts)]
         [lop (if (< (length parts) 2) "" (cadr parts))]
         [rop (if (< (length parts) 3) "" (apply string-append (cddr parts)))])
    (cond
      [(string-ci=? cmd "SET!") (set! vars (cmd-set! vars lop rop lineno))]
      [(string-ci=? cmd "DISPLAY") (cmd-display vars lop)]
      [(string-ci=? cmd "RESPECTS?") (cmd-respects? vars lop rop lineno)]
      [(string-ci=? cmd "HELP") (cmd-help)]
      [(string-ci=? cmd "QUIT") (set! vars #f)]
      [else (printf "Unknown command ~a~n" cmd)])
    vars))


; Start the evaluation loop
(let ([ignored (repl action (hash) "pity> ")])
  (display ""))
