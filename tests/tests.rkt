#lang racket

(require rackunit
         rackunit/text-ui
         "contracts-tests.rkt"
         "print-tests.rkt"
         "parser-tests.rkt"
         "process-tests.rkt"
         "names-tests.rkt")

(define pity-tests
  (test-suite
    "Tests for pity"

    contracts-tests
    print-tests
    parser-tests
    process-tests
    names-tests))

(exit (run-tests pity-tests))
