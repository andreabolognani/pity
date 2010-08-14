#lang racket

(require rackunit
         pity)

(define parser-tests
  (test-suite
    "Tests for the parser"

    (test-case
      "Parse an empty string"
      (check-exn exn:fail:read?
        (lambda () (string->process ""))))

    (test-case
      "Parse a name containing illegal symbols"
      (check-exn exn:fail:read?
        (lambda () (string->process "a_b(c)"))))

    (test-case
      "Parse an input action with no closing paren"
      (check-exn exn:fail:read?
        (lambda () (string->process "a(b"))))

    (test-case
      "Parse an input action with no opening paren"
      (check-exn exn:fail:read?
        (lambda () (string->process "ab)"))))

    (test-case
      "Parse an output action with no closing paren"
      (check-exn exn:fail:read?
        (lambda () (string->process "a<b"))))

    (test-case
      "Parse an output action with no opening paren"
      (check-exn exn:fail:read?
        (lambda () (string->process "ab>"))))

    (test-case
      "Parse an input action with no parameters"
      (check-exn exn:fail:read?
        (lambda () (string->process "a()"))))

    (test-case
      "Parse an output action with no parameters"
      (check-exn exn:fail:read?
        (lambda () (string->process "a<>"))))

    (test-case
      "Parse the nil process"
      (check-pred nil? (string->process "0")))

    (test-case
      "Parse an input action with a single parameter"
      (let* ([string "a(b)"]
             [params (list (name "b"))]
             [process (input (name "a") params)])
        (check-equal? (string->process string) process)))

    (test-case
      "Parse an input action with two parameters"
      (let* ([string "a(b,c)"]
             [params (list (name "b") (name "c"))]
             [process (input (name "a") params)])
        (check-equal? (string->process string) process)))

    (test-case
      "Parse an input action with three parameters"
      (let* ([string "a(b,c,d)"]
             [params (list (name "b") (name "c") (name "d"))]
             [process (input (name "a") params)])
        (check-equal? (string->process string) process)))

    (test-case
      "Parse an output action with a single parameter"
      (let* ([string "a<b>"]
             [params (list (name "b"))]
             [process (output (name "a") params)])
        (check-equal? (string->process string) process)))

    (test-case
      "Parse an output action with two parameters"
      (let* ([string "a<b,c>"]
             [params (list (name "b") (name "c"))]
             [process (output (name "a") params)])
        (check-equal? (string->process string) process)))

    (test-case
      "Parse an output action with three parameters"
      (let* ([string "a<b,c,d>"]
             [params (list (name "b") (name "c") (name "d"))]
             [process (output (name "a") params)])
        (check-equal? (string->process string) process)))

    (test-case
      "Parse the composition of two nil processes"
      (let ([string "0|0"]
            [process (composition (nil) (nil))])
        (check-equal? (string->process string) process)))

    (test-case
      "Parse the replication of a nil process"
      (let ([string "!0"]
            [process (replication (nil))])
        (check-equal? (string->process string) process)))

    (test-case
      "Parse an input prefix"
      (let* ([string "a(b).0"]
             [params (list (name "b"))]
             [process (prefix (input (name "a") params) (nil))])
        (check-equal? (string->process string) process)))

    (test-case
      "Parse an output prefix"
      (let* ([string "a<b>.0"]
             [params (list (name "b"))]
             [process (prefix (output (name "a") params) (nil))])
        (check-equal? (string->process string) process)))

    (test-case
      "Parse a restriction"
      (let ([string "(x)0"]
            [process (restriction (name "x") (nil))])
        (check-equal? (string->process string) process)))

    (test-case
      "Parse a process containing both a prefix and a composition"
      (let ([string "0.0|0"]
            [process (composition (prefix (nil) (nil)) (nil))])
        (check-equal? (string->process string) process)))

    (test-case
      "Parse a process containing two compositions"
      (let* ([string "0|x(y)|0"]
             [action (input (name "x") (list (name "y")))]
             [process (composition (nil) (composition action (nil)))])
        (check-equal? (string->process string) process)))

    (test-case
      "Parse a double composition with parentheses first"
      (let* ([string "(0|x(y))|0"]
             [action (input (name "x") (list (name "y")))]
             [process (composition (composition (nil) action) (nil))])
        (check-equal? (string->process string) process)))

    (test-case
      "Parse a double composition with parentheses last"
      (let* ([string "0|(x(y)|0)"]
             [action (input (name "x") (list (name "y")))]
             [process (composition (nil) (composition action (nil)))])
        (check-equal? (string->process string) process)))

    (test-case
      "Parse a restriction over the first part of a composition"
      (let ([string "(x)0|0"]
            [process (composition (restriction (name "x") (nil)) (nil))])
        (check-equal? (string->process string) process)))

    (test-case
      "Parse a restriction over the last part of a composition"
      (let ([string "0|(x)0"]
            [process (composition (nil) (restriction (name "x") (nil)))])
        (check-equal? (string->process string) process)))

    (test-case
      "Parse a restriction over both parts of a composition"
      (let ([string "(x)(0|0)"]
            [process (restriction (name "x") (composition (nil) (nil)))])
        (check-equal? (string->process string) process)))))

(provide parser-tests)
