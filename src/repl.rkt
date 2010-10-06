#lang racket/base

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


; Stateful REPL.
;
; The action procedure is called until an EOF is read, or it returns #f.
; Every time it is called, it is passed the contents of the last line
; read, the progressive number of said line, and the current REPL state;
; its return value is the new REPL state.
(define (repl action initial-state prompt)
  (letrec ([recur (lambda (state lineno)
                    (printf "~a" prompt)
                    (let ([line (read-line)])
                      (if (eq? line eof)
                          state
                          (let ([new-state (action line lineno state)])
                            (if (not new-state)
                                state
                                (recur new-state (+ lineno 1)))))))])
    (recur initial-state 1)))


; Export public symbols
(provide repl)
