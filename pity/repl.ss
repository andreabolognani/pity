(module repl scheme

 (define (repl action)
  (repl-real action))

 (define (repl-real action)
  (let ([line (read-line)])
   (unless (eq? line eof)
	(begin (action line) (repl-real action)))))
 
 (provide repl))
