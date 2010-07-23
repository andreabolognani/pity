#lang scheme

(require pity/name
         pity/term
         pity/private
         pity/repl)

;(define (action line)
; (let ([ip (open-input-string line)])
; (printf "~a~n" (term->string (parse (lambda () (lex ip)))))))

(define (action line)
 (printf "~a~n" (term->string (string->term line))))

(repl action "> ")
