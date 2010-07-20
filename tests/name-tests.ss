(module name-tests scheme

 (require rackunit
          rackunit/text-ui
          pity/name)

 (define name-tests
  (test-suite
   "Tests for the pity/name module"

   (test-case
    "name->string"
    (check-equal? (name->string (name "x")) "x"))
  
   (test-case
    "name-list->string with empty name list"
    (check-equal? (name-list->string '()) ""))
  
   (test-case
    "name-list->string with a single name"
    (check-equal? (name-list->string (list (name "x"))) "x"))

   (test-case
    "name-list->string with three names"
    (let ([name-list (list (name "x") (name "y") (name "z"))])
     (check-equal? (name-list->string name-list) "x,y,z")))))

 (provide name-tests))
