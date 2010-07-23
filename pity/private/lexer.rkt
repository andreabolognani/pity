(module private-lexer racket

 (require parser-tools/lex)

 (define-empty-tokens op-tokens (EOF NIL DOT COMMA PIPE BANG
                                 L_PAREN R_PAREN L_BRACKET R_BRACKET))
 (define-tokens value-tokens (NAME))

 (define-lex-abbrevs
  (letter (union (char-range "a" "z") (char-range "A" "Z")))
  (digit (char-range "0" "9"))
  (name (concatenation letter (repetition 0 +inf.0 (union letter digit)))))

 (define private-lexer
  (lexer
   [name   (token-NAME lexeme)]
   ["0"    (token-NIL)]
   ["."    (token-DOT)]
   [","    (token-COMMA)]
   ["|"    (token-PIPE)]
   ["!"    (token-BANG)]
   ["("    (token-L_PAREN)]
   [")"    (token-R_PAREN)]
   ["<"    (token-L_BRACKET)]
   [">"    (token-R_BRACKET)]
   [(eof)  (token-EOF)]))

 (provide op-tokens value-tokens private-lexer))
