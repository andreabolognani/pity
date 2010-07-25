#lang racket

(require rackunit
         rackunit/text-ui
         "name-tests.rkt"
         "parser-tests.rkt")

(define pity-tests
 (test-suite
  "Tests for pity"

  name-tests
  parser-tests))

(exit (run-tests pity-tests))
