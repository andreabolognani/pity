(module parser-tests racket

 (require rackunit
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
    (let* ([as-string "a(b)"]
           [params (list (name "b"))]
           [as-term (input (name "a") params)])
     (check-equal? (string->term as-string) as-term)))
   
   (test-case
    "Parse an input action with two parameters"
    (let* ([as-string "a(b,c)"]
           [params (list (name "b") (name "c"))]
           [as-term (input (name "a") params)])
     (check-equal? (string->term as-string) as-term)))
   
   (test-case
    "Parse an input action with three parameters"
    (let* ([as-string "a(b,c,d)"]
           [params (list (name "b") (name "c") (name "d"))]
           [as-term (input (name "a") params)])
     (check-equal? (string->term as-string) as-term)))

   (test-case
    "Parse an output action with a single parameter"
    (let* ([as-string "a<b>"]
           [params (list (name "b"))]
           [as-term (output (name "a") params)])
     (check-equal? (string->term as-string) as-term)))
   
   (test-case
    "Parse an output action with two parameters"
    (let* ([as-string "a<b,c>"]
           [params (list (name "b") (name "c"))]
           [as-term (output (name "a") params)])
     (check-equal? (string->term as-string) as-term)))
   
   (test-case
    "Parse an output action with three parameters"
    (let* ([as-string "a<b,c,d>"]
           [params (list (name "b") (name "c") (name "d"))]
           [as-term (output (name "a") params)])
     (check-equal? (string->term as-string) as-term)))
   
   (test-case
    "Parse the composition of two nil terms"
    (let ([as-string "0|0"]
          [as-term (composition (nil) (nil))])
     (check-equal? (string->term as-string) as-term)))))
  
 (provide parser-tests))
