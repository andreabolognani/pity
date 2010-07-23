(module term scheme

 (require scheme/match
          "name.rkt")

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
   [(replication p)   (string-append "!("
                                     (term->string p)
                                     ")")]
   [(input x y)       (string-append (name->string x)
                                     "("
                                     (name-list->string y)
                                     ")")]
   [(output x y)      (string-append (name->string x)
                                     "<"
                                     (name-list->string y)
                                     ">")]
   [(restriction x p) (string-append "("
                                     (name->string x)
                                     ")("
                                     (term->string p)
                                     ")")]
   [(composition p q) (string-append "("
                                     (term->string p)
                                     ")|("
                                     (term->string q)
                                     ")")]
   [(prefix p q)      (string-append "("
                                     (term->string p)
                                     ").("
                                     (term->string q)
                                     ")")]))

 (provide nil nil?
          replication replication?
          input input?
          output output?
          restriction restriction?
          composition composition?
          prefix prefix?
          term->string))
