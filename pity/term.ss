(module term scheme

 (require scheme/match
          "name.ss")

 (define-struct nil         ())
 (define-struct replication (p))
 (define-struct input       (x y))
 (define-struct output      (x y))
 (define-struct restriction (x p))
 (define-struct composition (p q))
 (define-struct prefix      (p q))

 (define (term->string term)
  (match term
   [(nil)             "0"]
   [(replication p)   (string-join (list "!("
                                         (term->string p)
                                         ")")
                                   "")]
   [(input x y)       (string-join (list (name->string x)
                                         "("
                                         (name-list->string y)
                                         ")")
                                    "")]
   [(output x y)      (string-join (list (name->string x)
                                         "<"
                                         (name-list->string y)
                                         ">")
                                   "")]
   [(restriction x p) (string-join (list "("
                                         (name->string x)
                                         ")("
                                         (term->string p)
                                         ")")
                                   "")]
   [(composition p q) (string-join (list "("
                                         (term->string p)
                                         ")|("
                                         (term->string q)
                                         ")")
                                   "")]
   [(prefix p q)      (string-join (list "("
                                         (term->string p)
                                         ").("
                                         (term->string q)
                                         ")")
                                   "")]))

 (provide nil nil?
          replication replication?
          input input?
          output output?
          restriction restriction?
          composition composition?
          prefix prefix?
          term->string))
