(module repl scheme

 (define (repl action)
  (read-line) ; The first line is always empty, skip it
  (repl-real action))

 (define (repl-real action)
  (let ([line (read-line)])
   (unless (eq? line eof)
	(begin (action line) (repl-real action)))))
 
 (provide repl))
