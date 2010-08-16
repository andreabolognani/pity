#lang racket

(require rackunit
         pity)

(define process-tests
  (test-suite
    "Tests for processes"

    (test-case
      "Test whether process? works correctly"
      (check-true (process? (string->process "0")))
      (check-true (process? (string->process "!0")))
      (check-true (process? (string->process "x(y)"))))
      (check-true (process? (string->process "x<y>")))
      (check-true (process? (string->process "(x)0")))
      (check-true (process? (string->process "0|0")))
      (check-true (process? (string->process "0.0")))
      (check-false (process? "x<y>|x(z)"))
      (check-false (process? (name "x")))
      (check-false (process? 42))))

(provide process-tests)
