#lang racket

(require rackunit
         pity)

;; string->setof-name : string -> setof name
;; Make a set of names out of a comma-separated list of names
(define (string->setof-name str)
  (let ([names (set)])
    (map (lambda (x)
           (unless (equal? x "")
             (set! names (set-add names (name x)))))
         (regexp-split "," str))
   names))

(define names-tests
  (test-suite
    "Tests for free names and bound names"

    (test-case
      "Free and bound names in the nil term"
      (let ([term (string->term "0")]
            [free (string->setof-name "")]
            [bound (string->setof-name "")]
            [all (string->setof-name "")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))

    (test-case
      "Free and bound names in an input action"
      (let ([term (string->term "x(y)")]
            [free (string->setof-name "x")]
            [bound (string->setof-name "y")]
            [all (string->setof-name "x,y")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))

    (test-case
      "Free and bound names in an output action"
      (let ([term (string->term "x<y>")]
            [free (string->setof-name "x,y")]
            [bound (string->setof-name "")]
            [all (string->setof-name "x,y")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))

    (test-case
      "Free and bound names under a restriction (input to private name)"
      (let ([term (string->term "(x)y(x)")]
            [free (string->setof-name "y")]
            [bound (string->setof-name "x")]
            [all (string->setof-name "x,y")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))

    (test-case
      "Free and bound names under a restriction (input on private name)"
      (let ([term (string->term "(x)x(y)")]
            [free (string->setof-name "")]
            [bound (string->setof-name "x,y")]
            [all (string->setof-name "x,y")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))

    (test-case
      "Free and bound names under a restriction (output to private name)"
      (let ([term (string->term "(x)y<x>")]
            [free (string->setof-name "y")]
            [bound (string->setof-name "x")]
            [all (string->setof-name "x,y")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))

    (test-case
      "Free and bound names under a restriction (output on private name)"
      (let ([term (string->term "(x)x<y>")]
            [free (string->setof-name "y")]
            [bound (string->setof-name "x")]
            [all (string->setof-name "x,y")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))

    (test-case
      "Free and bound names in a composition (nil terms)"
      (let ([term (string->term "0|0")]
            [free (string->setof-name "")]
            [bound (string->setof-name "")]
            [all (string->setof-name "")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))

    (test-case
      "Free and bound names in a composition (input and output)"
      (let ([term (string->term "x(y)|x<z>")]
            [free (string->setof-name "x,z")]
            [bound (string->setof-name "y")]
            [all (string->setof-name "x,y,z")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))

    (test-case
      "Free and bound names in a composition (output and input)"
      (let ([term (string->term "x<y>|x(z)")]
            [free (string->setof-name "x,y")]
            [bound (string->setof-name "z")]
            [all (string->setof-name "x,y,z")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))

    (test-case
      "Free and bound names in a composition (output and input)"
      (let ([term (string->term "y<x>|z(x)")]
            [free (string->setof-name "x,y,z")]
            [bound (string->setof-name "x")]
            [all (string->setof-name "x,y,z")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))

    (test-case
      "Free and bound names in a prefix (two nil terms)"
      (let ([term (string->term "0.0")]
            [free (string->setof-name "")]
            [bound (string->setof-name "")]
            [all (string->setof-name "")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))

    (test-case
      "Free and bound names in a prefix (output, then input)"
      (let ([term (string->term "x<y>.x(y)")]
            [free (string->setof-name "x,y")]
            [bound (string->setof-name "y")]
            [all (string->setof-name "x,y")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))

    (test-case
      "Free and bound names in a prefix (output, then input)"
      (let ([term (string->term "x<y>.y(z)")]
            [free (string->setof-name "x,y")]
            [bound (string->setof-name "z")]
            [all (string->setof-name  "x,y,z")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))

    (test-case
      "Free and bound names in a prefix (input, then output)"
      (let ([term (string->term "x(y).x<y>")]
            [free (string->setof-name "x")]
            [bound (string->setof-name "y")]
            [all (string->setof-name "x,y")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))

    (test-case
      "Free and bound names in a prefix (input, then output)"
      (let ([term (string->term "x(y).y<z>")]
            [free (string->setof-name "x,z")]
            [bound (string->setof-name "y")]
            [all (string->setof-name "x,y,z")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))

    (test-case
      "Free and bound names in a replication (nil term)"
      (let ([term (string->term "!0")]
            [free (string->setof-name "")]
            [bound (string->setof-name "")]
            [all (string->setof-name "")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))

    (test-case
      "Free and bound names in a replication (input)"
      (let ([term (string->term "!x(y)")]
            [free (string->setof-name "x")]
            [bound (string->setof-name "y")]
            [all (string->setof-name "x,y")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))

    (test-case
      "Free and bound names in a replication (output)"
      (let ([term (string->term "!x<y>")]
            [free (string->setof-name "x,y")]
            [bound (string->setof-name "")]
            [all (string->setof-name "x,y")])
        (check-equal? (free-names term) free)
        (check-equal? (bound-names term) bound)
        (check-equal? (names term) all)))))

(provide names-tests)
