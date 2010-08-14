#lang racket

(require pity
         "repl.rkt")

;; Pretty-print a set of names to a string
(define (pretty-set s)
  (let ([names (set-map s name->string)])
    (string-append "{" (string-join names ",") "}")))

;; Try to parse the line into a term.
;; If succesful, print the term followed by its free and bound names
(define (action line)
  (with-handlers ([(lambda (e) (exn:fail:read? e))
                   (lambda (e) (printf "ERR: Exception caught~n"))])
    (let ([process (string->process line)])
      (printf "Process     : ~a~n" (process->string process))
      (printf "Free names  : ~a~n" (pretty-set (free-names process)))
      (printf "Bound names : ~a~n" (pretty-set (bound-names process))))))

;; Start the evaluation loop
(repl action "pity> ")
