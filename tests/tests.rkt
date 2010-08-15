#lang racket

(require rackunit
         rackunit/text-ui
         "contracts-tests.rkt"
         "print-tests.rkt"
         "parser-tests.rkt"
         "names-tests.rkt")

(define pity-tests
  (test-suite
    "Tests for pity"

    contracts-tests
    print-tests
    parser-tests
    names-tests))

(exit (run-tests pity-tests))
