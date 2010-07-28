(module print-tests racket

 (require rackunit
          rackunit/text-ui
          pity)

 (define print-tests
  (test-suite
   "Tests for print functionality"

   (test-case
    "Print a name"
    (let ([name (name "x")])
     (check-equal? (name->string name) "x")))

   (test-case
    "Print an empty name list"
    (let ([name-list '()])
     (check-equal? (name-list->string name-list) "")))

   (test-case
    "Print a list containing a single name"
    (let ([name-list (list (name "x"))])
     (check-equal? (name-list->string name-list) "x")))

   (test-case
    "Print a list containing two names"
    (let ([name-list (list (name "x") (name "y"))])
     (check-equal? (name-list->string name-list) "x,y")))

   (test-case
    "Print a list containing three names"
    (let ([name-list (list (name "x") (name "y") (name "z"))])
     (check-equal? (name-list->string name-list) "x,y,z")))))

 (provide print-tests))
