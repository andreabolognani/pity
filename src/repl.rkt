(module repl racket

 (define (repl action prompt)
  (printf "~a" prompt)
  (repl-real action prompt))

 (define (repl-real action prompt)
  (let ([line (read-line)])
   (unless (eq? line eof)
    (begin (action line) (repl action prompt)))))

 (provide repl))
