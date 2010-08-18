#lang racket

(require "private/lexer.rkt"
         "private/parser.rkt"
         "contracts.rkt"
         "process.rkt")

(define (string->process str)
  (let ([ip (open-input-string str)])
    (private-parser (lambda () (private-lexer ip)))))

(provide/contract [string->process (string? . -> . process?)])
