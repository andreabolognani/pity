#lang scheme

(require pity)

(define (action line)
 (printf "~a~n" (term->string (string->term line))))

(repl action "> ")
