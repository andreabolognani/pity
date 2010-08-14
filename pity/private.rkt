#lang racket

(require "private/lexer.rkt"
         "private/parser.rkt")

(define (string->process str)
  (let ([ip (open-input-string str)])
    (private-parser (lambda () (private-lexer ip)))))

(provide string->process)
