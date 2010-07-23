#lang racket

(require pity
         "repl.rkt")

(define (action line)
 (printf "~a~n" (term->string (string->term line))))

(repl action "> ")
