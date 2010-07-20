#lang scheme

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
   (check-equal? (name-list->string (list (name "x") (name "y") (name "z"))) "x,y,z"))))

(exit (run-tests name-tests))
