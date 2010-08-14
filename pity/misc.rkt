#lang racket

(require scribble/srcdoc
         "private/lexer.rkt"
         "private/parser.rkt")

(define (string->term str)
  (let ([ip (open-input-string str)])
    (private-parser (lambda () (private-lexer ip)))))

(provide string->term)
