(module term racket

 (require racket/match
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
   [(replication p)   (replication->string term)]
   [(input x y)       (input->string term)]
   [(output x y)      (output->string term)]
   [(restriction x p) (restriction->string term)]
   [(composition p q) (composition->string term)]
   [(prefix p q)      (prefix->string term)]))

 ; replication->string : replication -> string
 (define (replication->string term)
  (match-let ([(replication p) term])
   (string-append "!"
                  (if (contains-composition? p)
                      (enclose (term->string p))
                      (term->string p)))))

 ; input->string : output -> string
 (define (input->string term)
  (match-let ([(input x y) term])
   (string-append (name->string x) "("
                  (name-list->string y) ")")))

 ; output->string : output -> string
 (define (output->string term)
  (match-let ([(output x y) term])
   (string-append (name->string x) "<"
                  (name-list->string y) ">")))

 ; restriction->string : restriction -> string
 (define (restriction->string term)
  (match-let ([(restriction x p) term])
   (string-append (enclose (name->string x))
                  (if (contains-composition? p)
                      (enclose (term->string p))
                      (term->string p)))))

 ; composition->string : composition -> string
 (define (composition->string term)
  (match-let ([(composition p q) term])
   (string-append (term->string p)
                  "|"
                  (term->string q))))

 ; prefix->string : prefix -> string
 (define (prefix->string term)
  (match-let ([(prefix p q) term])
   (string-append (if (contains-composition? p)
                      (enclose (term->string p))
                      (term->string p))
                  "."
                  (if (contains-composition? q)
                      (enclose (term->string q))
                      (term->string q)))))

 ; enclose : string -> string
 (define (enclose stuff)
  (string-append "(" stuff ")"))

 (define (contains-composition? term)
  (match term
   [(nil)             #f]
   [(replication p)   (contains-composition? p)]
   [(input x y)       #f]
   [(output x y)      #f]
   [(restriction x p) (contains-composition? p)]
   [(composition p q) #t]
   [(prefix p q)      (or (contains-composition? p)
                          (contains-composition? q))]))

 (provide nil nil?
          replication replication?
          input input?
          output output?
          restriction restriction?
          composition composition?
          prefix prefix?
          term->string))
