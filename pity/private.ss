(module private scheme

 (require "private/lexer.ss"
          "private/parser.ss")

 (define (string->term str)
  (let ([ip (open-input-string str)])
   (private-parser (lambda () (private-lexer ip)))))

 (provide string->term))
