#lang scheme

(require pity/name
         pity/term
         pity/lex
         pity/parse
         pity/repl)

(define (action line)
 (let ([ip (open-input-string line)])
 (printf "~a~n" (term->string (parse (lambda () (lex ip)))))))

(repl action)
