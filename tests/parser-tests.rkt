(module parser-tests racket

 (require rackunit
          rackunit/text-ui
          pity)

 (define parser-tests
  (test-suite
   "Tests for the parser"
   
   (test-case
    "Parse an empty string"
    (check-exn exn:fail:read?
     (lambda () (string->term ""))))

   (test-case
    "Parse a name containing illegal symbols"
    (check-exn exn:fail:read?
     (lambda () (string->term "a_b(c)"))))

   (test-case
    "Parse an input action with no closing paren"
    (check-exn exn:fail:read?
     (lambda () (string->term "a(b"))))

   (test-case
    "Parse an input action with no opening paren"
    (check-exn exn:fail:read?
     (lambda () (string->term "ab)"))))

   (test-case
    "Parse an output action with no closing paren"
    (check-exn exn:fail:read?
     (lambda () (string->term "a<b"))))

   (test-case
    "Parse an output action with no opening paren"
    (check-exn exn:fail:read?
     (lambda () (string->term "ab>"))))

   (test-case
    "Parse an input action with no parameters"
    (check-exn exn:fail:read?
     (lambda () (string->term "a()"))))

   (test-case
    "Parse an output action with no parameters"
    (check-exn exn:fail:read?
     (lambda () (string->term "a<>"))))

   (test-case
    "Parse the nil term"
    (check-pred nil? (string->term "0")))

   (test-case
    "Parse an input action with a single parameter"
    (let ([term "a(b)"])
     (check-equal? (term->string (string->term term)) term)))
   
   (test-case
    "Parse an input action with two parameters"
    (let ([term "a(b,c)"])
     (check-equal? (term->string (string->term term)) term)))
   
   (test-case
    "Parse an input action with three parameters"
    (let ([term "a(b,c,d)"])
     (check-equal? (term->string (string->term term)) term)))

   (test-case
    "Parse an output action with a single parameter"
    (let ([term "a<b>"])
     (check-equal? (term->string (string->term term)) term)))
   
   (test-case
    "Parse an output action with two parameters"
    (let ([term "a<b,c>"])
     (check-equal? (term->string (string->term term)) term)))
   
   (test-case
    "Parse an output action with three parameters"
    (let ([term "a<b,c,d>"])
     (check-equal? (term->string (string->term term)) term)))
   
   (test-case
    "Parse the composition of two nil terms"
    (let ([term "0|0"])
     (check-equal? (term->string (string->term term)) term)))))
  
 (provide parser-tests))
