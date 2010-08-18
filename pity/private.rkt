#lang racket

(require "private/lexer.rkt"
         "private/parser.rkt"
         "contracts.rkt"
         "process.rkt")


;; This really belongs to the process module, and is documented as
;; such, but putting it there causes a require cycle.
;;
;; Another way to work around the cycle would be to embed the parser
;; into the process module. I might end up doing that.

(define (string->process str)
  (let ([ip (open-input-string str)])
    (private-parser (lambda () (private-lexer ip)))))


;; Export public symbols
(provide/contract
  [string->process (string? . -> . process?)])
