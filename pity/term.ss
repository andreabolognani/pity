(module term scheme

 (require scheme/match
          "name.ss")

 (define-struct nil    ())
 (define-struct input  (channel name-list))
 (define-struct prefix (action term))

 (define (term->string term)
  (match term
   [(nil) "0"]
   [(input c l) (string-join (list (name->string c) "(" (name-list->string l) ")") "")]
   [(prefix a t) (string-join (list (term->string a) (term->string t)) ".")]))

 (provide nil nil?
          input input?
          prefix prefix?
          term->string))
