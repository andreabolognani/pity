#lang scheme

(require rackunit
         rackunit/text-ui
         "name-tests.ss")

(define pity-tests
 (test-suite
  "Tests for pity"
  name-tests))

(exit (run-tests pity-tests))
