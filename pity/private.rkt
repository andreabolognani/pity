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


(require "private/common-lexer.rkt"
         "private/process-parser.rkt"
         "private/sorting-parser.rkt"
         "private/environment-parser.rkt"
         "process.rkt"
         "sorting.rkt"
         "environment.rkt"
         "contracts.rkt")


; These really belong to the corresponding modules, and are
; documented as such, but putting it there causes a require cycle.
;
; Another way to work around the cycle would be to embed the parsers
; into the respective modules. I might end up doing that.

(define (string->process str)
  (with-handlers ([exn:fail?
                   (lambda (e)
                     (raise (exn:fail "Error while parsing process"
                                      (exn-continuation-marks e))))])
    (let ([ip (open-input-string str)])
      (process-parser (lambda () (common-lexer ip))))))


(define (string->sorting str)
  (if (not (equal? str ""))
    (with-handlers ([exn:fail?
                     (lambda (e)
                       (raise (exn:fail "Error while parsing sorting"
                                        (exn-continuation-marks e))))])
      (let ([ip (open-input-string str)])
        (sorting-parser (lambda () (common-lexer ip)))))
    (sorting)))


(define (string->environment str)
  (if (not (equal? str ""))
    (with-handlers ([exn:fail?
                     (lambda (e)
                       (raise (exn:fail "Error while parsing environment"
                                        (exn-continuation-marks e))))])
      (let ([ip (open-input-string str)])
        (environment-parser (lambda () (common-lexer ip)))))
    (environment)))


; Export public symbols
(provide/contract
  [string->process     (string? . -> . process?)]
  [string->sorting     (string? . -> . sorting?)]
  [string->environment (string? . -> . environment?)])
