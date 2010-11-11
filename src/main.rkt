#lang racket/base

; Pity: Pi-Calculus Inference
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


(require racket/set
         pity
         "repl.rkt")


; Assign a value to a name, parsing it as a process.
; If parsing as a process fails, try to parse it as a sorting.
(define (cmd-set! vars n v lineno port)
  (with-handlers ([exn:fail?
                   (lambda (e)
                     (cmd-set!/sorting vars n v lineno port))])
    (if (id-string? n)
        (hash-set vars n (string->process v))
        (begin
          (eprintf "~a:~a: SET!: Invalid name ~a~n"
                   (object-name port) lineno n)
          (if (terminal-port? port)
              vars
              #f)))))


; Assign a value to a name, parsing it as a sorting.
; If parsing fails, print an error message.
(define (cmd-set!/sorting vars n v lineno port)
  (with-handlers ([exn:fail?
                   (lambda (e)
                     (eprintf "~a:~a: SET!: Invalid value ~a~n"
                              (object-name port) lineno v)
                     (if (terminal-port? port)
                         vars
                         #f))])
    (hash-set vars n (string->sorting v))))


; Display a value according to its type.
(define (cmd-display vars n lineno port)
  (let ([v (hash-ref vars n #f)])
    (if v
        (begin
          (cond
            [(process? v) (printf "~a~n" (process->string v))]
            [(sorting? v) (printf "~a~n" (sorting->string v))])
          vars)
        (begin
          (eprintf "~a:~a: DISPLAY: Unknown name ~a~n"
                   (object-name port) lineno n)
          (if (terminal-port? port)
              vars
              #f)))))


; Check whether the process pointed to by n1 respects the sorting
; pointed to by n2. If it does, print all the valid environments.
(define (cmd-respects? vars n1 n2 lineno port)
  (let ([p (hash-ref vars n1 #f)]
        [srt (hash-ref vars n2 #f)])
    (if (and (process? p) (sorting? srt))
        (let ([res (process-respects? p srt)])
          (when res
                (set-for-each
                  res
                  (lambda (env)
                    (printf "~a~n" (environment->string env)))))
          vars)
        (begin
          (eprintf "~a:~a: RESPECTS?: Need a process and a sorting~n"
                   (object-name port) lineno)
          #f))))


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
(define (action line lineno port vars)
  (let* ([parts (regexp-split #rx" +" line)]
         [cmd (car parts)]
         [lop (if (< (length parts) 2) "" (cadr parts))]
         [rop (if (< (length parts) 3) "" (apply string-append (cddr parts)))])
    (cond
      [(string-ci=? cmd "SET!")      (set! vars (cmd-set! vars lop rop lineno port))]
      [(string-ci=? cmd "DISPLAY")   (set! vars (cmd-display vars lop lineno port))]
      [(string-ci=? cmd "RESPECTS?") (set! vars (cmd-respects? vars lop rop lineno port))]
      [(string-ci=? cmd "HELP")      (cmd-help)]
      [(string-ci=? cmd "QUIT")      (set! vars #f)]
      [else                          (eprintf "~a:~a: Unknown command ~a~n" (object-name port) lineno cmd)])
    vars))


; Start the evaluation loop
(let* ([args (current-command-line-arguments)]
       [infile (if (< (vector-length args) 1) #f (vector-ref args 0))]
       [port (if (not infile) (current-input-port) (open-input-file infile))])
  (when (terminal-port? port)
    (printf "Welcome to the Pity interactive toplevel!~n")
    (printf "Type HELP and hit Enter for an overview.~n~n"))
  (repl action (hash) "pity> " port)
  (if (terminal-port? port)
      (printf "Bye.~n")
      (printf ""))
  (unless (equal? (current-input-port) port)
          (close-input-port port)))
