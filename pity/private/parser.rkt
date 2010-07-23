(module private-parser scheme

 (require parser-tools/yacc
          "../name.rkt"
          "../term.rkt"
          "lexer.rkt")

 (define private-parser
  (parser

   (start  process)
   (end    EOF)
   (tokens value-tokens op-tokens)
   (error  (lambda (a b c) (void)))
   
   (grammar
	
    (process    [(subprocess)                         $1]
                [(subprocess PIPE process)            (composition $1 $3)])

    (subprocess [(part)                               $1]
                [(BANG subprocess)                    (replication $2)])

    (part       [(term)                               $1]
                [(L_PAREN name R_PAREN part)          (restriction $2 $4)])

    (term       [(action)                             $1]
                [(action DOT term)                    (prefix $1 $3)])

    (action     [(NIL)                                (nil)]
                [(name L_PAREN name_list R_PAREN)     (input $1 $3)]
                [(name L_BRACKET name_list R_BRACKET) (output $1 $3)]
                [(L_PAREN process R_PAREN)            $2])

    (name_list  [(name)                               (list $1)]
                [(name COMMA name_list)               (list* $1 $3)])

    (name       [(NAME)                               (name $1)]))))
 
 (provide private-parser))
