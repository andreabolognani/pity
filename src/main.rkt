#lang racket

(require pity
         "repl.rkt")

(define (action line)
 (with-handlers ([(lambda (e) (exn:fail:read? e))
                  (lambda (e) (printf "ERR: Exception caught~n"))])
  (printf "~a~n" (term->string (string->term line)))))

(repl action "> ")
