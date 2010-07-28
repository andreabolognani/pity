#lang racket

(require rackunit
         rackunit/text-ui
         "print-tests.rkt"
         "parser-tests.rkt")

(define pity-tests
 (test-suite
  "Tests for pity"

  print-tests
  parser-tests))

(exit (run-tests pity-tests))
