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
     (check-equal? (string->term as-string) as-term)))

   (test-case
    "Parse the replication of a nil term"
    (let ([as-string "!0"]
          [as-term (replication (nil))])
     (check-equal? (string->term as-string) as-term)))

   (test-case
    "Parse an input prefix"
    (let* ([as-string "a(b).0"]
           [params (list (name "b"))]
           [as-term (prefix (input (name "a") params) (nil))])
     (check-equal? (string->term as-string) as-term)))

   (test-case
    "Parse an output prefix"
    (let* ([as-string "a<b>.0"]
           [params (list (name "b"))]
           [as-term (prefix (output (name "a") params) (nil))])
     (check-equal? (string->term as-string) as-term)))

   (test-case
    "Parse a restriction"
    (let ([as-string "(x)0"]
          [as-term (restriction (name "x") (nil))])
     (check-equal? (string->term as-string) as-term)))

   (test-case
    "Parse a term containing both a prefix and a composition"
    (let ([as-string "0.0|0"]
          [as-term (composition (prefix (nil) (nil)) (nil))])
     (check-equal? (string->term as-string) as-term)))

   (test-case
    "Parse a term containing two compositions"
    (let* ([as-string "0|x(y)|0"]
           [action (input (name "x") (list (name "y")))]
           [as-term (composition (nil) (composition action (nil)))])
     (check-equal? (string->term as-string) as-term)))

   (test-case
    "Parse a double composition with parentheses first"
    (let* ([as-string "(0|x(y))|0"]
           [action (input (name "x") (list (name "y")))]
           [as-term (composition (composition (nil) action) (nil))])
     (check-equal? (string->term as-string) as-term)))

   (test-case
    "Parse a double composition with parentheses last"
    (let* ([as-string "0|(x(y)|0)"]
           [action (input (name "x") (list (name "y")))]
           [as-term (composition (nil) (composition action (nil)))])
     (check-equal? (string->term as-string) as-term)))

   (test-case
    "Parse a restriction over the first term of a composition"
    (let ([as-string "(x)0|0"]
          [as-term (composition (restriction (name "x") (nil)) (nil))])
     (check-equal? (string->term as-string) as-term)))

   (test-case
    "Parse a restriction over the last term of a composition"
    (let ([as-string "0|(x)0"]
          [as-term (composition (nil) (restriction (name "x") (nil)))])
     (check-equal? (string->term as-string) as-term)))

   (test-case
    "Parse a restriction over both terms of a composition"
    (let ([as-string "(x)(0|0)"]
          [as-term (restriction (name "x") (composition (nil) (nil)))])
     (check-equal? (string->term as-string) as-term)))))
  
 (provide parser-tests))
