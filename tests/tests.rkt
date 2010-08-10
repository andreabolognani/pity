#lang racket

(require rackunit
         rackunit/text-ui
         "print-tests.rkt"
         "parser-tests.rkt"
         "names-tests.rkt")

(define pity-tests
  (test-suite
    "Tests for pity"

    print-tests
    parser-tests
    names-tests))

(exit (run-tests pity-tests))
