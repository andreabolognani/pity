#lang racket/base

; Pity: Pi-Calculus Type Inference
; Copyright (C) 2010  Andrea Bolognani <andrea.bolognani@roundhousecode.com>
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License along
; with this program; if not, write to the Free Software Foundation, Inc.,
; 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


(require rackunit
         pity)


(define parsers-tests
  (test-suite
    "Tests for the parsers"

    (test-case
      "Parse an empty string"
      (check-exn exn:fail?
        (lambda () (string->process ""))))

    (test-case
      "Parse an input action not in prefix position"
      (check-exn exn:fail?
        (lambda () (string->process "a(b)"))))

    (test-case
      "Parse an output action not in prefix position"
      (check-exn exn:fail?
        (lambda () (string->process "a<b>"))))

    (test-case
      "Parse a name containing illegal symbols"
      (check-exn exn:fail?
        (lambda () (string->process "a_b(c).0"))))

    (test-case
      "Parse an input action with no closing paren"
      (check-exn exn:fail?
        (lambda () (string->process "a(b.0"))))

    (test-case
      "Parse an input action with no opening paren"
      (check-exn exn:fail?
        (lambda () (string->process "ab).0"))))

    (test-case
      "Parse an output action with no closing paren"
      (check-exn exn:fail?
        (lambda () (string->process "a<b.0"))))

    (test-case
      "Parse an output action with no opening paren"
      (check-exn exn:fail?
        (lambda () (string->process "ab>.0"))))

    (test-case
      "Parse an input action with no parameters"
      (check-exn exn:fail?
        (lambda () (string->process "a().0"))))

    (test-case
      "Parse an output action with no parameters"
      (check-exn exn:fail?
        (lambda () (string->process "a<>.0"))))

    (test-case
      "Parse an input action with duplicated names"
      (check-exn exn:fail?
        (lambda () (string->process "a(b,b).0"))))

    (test-case
      "Parse an output action with duplicated names"
      (check-exn exn:fail?
        (lambda () (string->process "a<b,b>.0"))))

    (test-case
      "Parse a nil process in prefix position"
      (check-exn exn:fail?
        (lambda () (string->process "0.0"))))

    (test-case
      "Parse the nil process"
      (check-pred nil? (string->process "0")))

    (test-case
      "Parse an input action with a single parameter"
      (let* ([str "a(b).0"]
             [params (list (name "b"))]
             [action (input (name "a") params)]
             [process (prefix action (nil))])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse an input action with a single parameter (same as channel)"
      (let* ([str "a(a).0"]
             [params (list (name "a1"))]
             [action (input (name "a") params)]
             [process (prefix action (nil))])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse an input action with two parameters"
      (let* ([str "a(b,c).0"]
             [params (list (name "b") (name "c"))]
             [action (input (name "a") params)]
             [process (prefix action (nil))])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse an input action with three parameters"
      (let* ([str "a(b,c,d).0"]
             [params (list (name "b") (name "c") (name "d"))]
             [action (input (name "a") params)]
             [process (prefix action (nil))])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse an output action with a single parameter"
      (let* ([str "a<b>.0"]
             [params (list (name "b"))]
             [action (output (name "a") params)]
             [process (prefix action (nil))])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse an output action with a single parameter (same as channel)"
      (let* ([str "a<a>.0"]
             [params (list (name "a"))]
             [action (output (name "a") params)]
             [process (prefix action (nil))])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse an output action with two parameters"
      (let* ([str "a<b,c>.0"]
             [params (list (name "b") (name "c"))]
             [action (output (name "a") params)]
             [process (prefix action (nil))])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse an output action with three parameters"
      (let* ([str "a<b,c,d>.0"]
             [params (list (name "b") (name "c") (name "d"))]
             [action (output (name "a") params)]
             [process (prefix action (nil))])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse an input action followed by an output action"
      (let* ([str "a(b).a<c>.0"]
             [params (list (name "c"))]
             [action (output (name "a") params)]
             [process (prefix action (nil))]
             [params (list (name "b"))]
             [action (input (name "a") params)]
             [process (prefix action process)])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse an output followed by a composition"
      (let* ([str "a<b>.(0|a(c).0)"]
             [params (list (name "c"))]
             [action (input (name "a") params)]
             [process (prefix action (nil))]
             [process (composition (nil) process)]
             [params (list (name "b"))]
             [action (output (name "a") params)]
             [process (prefix action process)])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse the composition of two nil processes"
      (let ([str "0|0"]
            [process (composition (nil) (nil))])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse the replication of a nil process"
      (let ([str "!0"]
            [process (replication (nil))])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse the replication of a simple prefix"
      (let* ([str "!a(b,c).0"]
             [params (list (name "b") (name "c"))]
             [action (input (name "a") params)]
             [process (prefix action (nil))]
             [process (replication process)])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse a restriction"
      (let ([str "(x)0"]
            [process (restriction (name "x") (nil))])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse a process containing both a prefix and a composition"
      (let* ([str "a(b).0|0"]
             [params (list (name "b"))]
             [action (input (name "a") params)]
             [process (prefix action (nil))]
             [process (composition process (nil))])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse a process containing two compositions"
      (let* ([str "0|a(b,c).0|0"]
             [params (list (name "b") (name "c"))]
             [action (input (name "a") params)]
             [process (prefix action (nil))]
             [process (composition process (nil))]
             [process (composition (nil) process)])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse a double composition with parentheses first"
      (let* ([str "(0|a<b,c>.0)|0"]
             [params (list (name "b") (name "c"))]
             [action (output (name "a") params)]
             [process (prefix action (nil))]
             [process (composition (nil) process)]
             [process (composition process (nil))])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse a double composition with parentheses last"
      (let* ([str "0|(a(b).0|0)"]
             [params (list (name "b"))]
             [action (input (name "a") params)]
             [process (prefix action (nil))]
             [process (composition process (nil))]
             [process (composition (nil) process)])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse a restriction over the first part of a composition"
      (let* ([str "(x)0|a<b>.0"]
             [params (list (name "b"))]
             [action (output (name "a") params)]
             [process (restriction (name "x") (nil))]
             [process (composition process (prefix action (nil)))])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse a restriction over the last part of a composition"
      (let* ([str "0|(x)a<b>.0"]
             [params (list (name "b"))]
             [action (output (name "a") params)]
             [process (prefix action (nil))]
             [process (restriction (name "x") process)]
             [process (composition (nil) process)])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse a restriction over both parts of a composition"
      (let* ([str "(x)(0|a<b>.0)"]
             [params (list (name "b"))]
             [action (output (name "a") params)]
             [process (prefix action (nil))]
             [process (composition (nil) process)]
             [process (restriction (name "x") process)])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse a complex process"
      (let* ([str "!(a)(a<b,c>.0|a(u,v).0)"]
             [params (list (name "b") (name "c"))]
             [action1 (output (name "a") params)]
             [process1 (prefix action1 (nil))]
             [params (list (name "u") (name "v"))]
             [action2 (input (name "a") params)]
             [process2 (prefix action2 (nil))]
             [process (composition process1 process2)]
             [process (restriction (name "a") process)]
             [process (replication process)])
        (check-equal? (string->process str) process)))

    (test-case
      "Parse a sorting containing an illegal symbol"
      (check-exn exn:fail?
        (lambda () (string->sorting "s=(r_,t)"))))

    (test-case
      "Parse a sorting with no opening parenthesis"
      (check-exn exn:fail?
        (lambda () (string->sorting "s=r,t)"))))

    (test-case
      "Parse a sorting with no closing parenthesis"
      (check-exn exn:fail?
        (lambda () (string->sorting "s=(r,t"))))

    (test-case
      "Parse a sorting with an extra comma in the object sort"
      (check-exn exn:fail?
        (lambda () (string->sorting "s=(r,)"))))

    (test-case
      "Parse a sorting with an object sort in subject position"
      (check-exn exn:fail?
        (lambda () (string->sorting "(s,r)=(t)"))))

    (test-case
      "Parse a sorting with a subject sort in object position"
      (check-exn exn:fail?
        (lambda () (string->sorting "s=r"))))

    (test-case
      "Parse a sorting with an object sort in subject position"
      (check-exn exn:fail?
        (lambda () (string->sorting "(s,r)=(t)"))))

    (test-case
      "Parse a sorting with an empty object sort"
      (check-exn exn:fail?
        (lambda () (string->sorting "s=()"))))

    (test-case
      "Parse an empty sorting"
      (let ([str ""]
            [srt (sorting)])
        (check-equal? (string->sorting str) srt)))

    (test-case
      "Parse a sorting with a single case (one object sort)"
      (let* ([str "s=(r)"]
             [subj (sort "s")]
             [obj (list (sort "r"))]
             [srt (sorting-set (sorting) subj obj)])
        (check-equal? (string->sorting str) srt)))

    (test-case
      "Parse a sorting with a single case (two object sorts)"
      (let* ([str "s=(r,t)"]
             [subj (sort "s")]
             [obj (list (sort "r") (sort "t"))]
             [srt (sorting-set (sorting) subj obj)])
        (check-equal? (string->sorting str) srt)))

    (test-case
      "Parse a sorting with two cases (different subjects)"
      (let* ([str "s=(r);r=(t)"]
             [subj (sort "s")]
             [obj (list (sort "r"))]
             [srt (sorting-set (sorting) subj obj)]
             [subj (sort "r")]
             [obj (list (sort "t"))]
             [srt (sorting-set srt subj obj)])
        (check-equal? (string->sorting str) srt)))

    (test-case
      "Parse a sorting with two cases (same subject)"
      (let* ([str "s=(r);s=(t)"]
             [subj (sort "s")]
             [obj (list (sort "r"))]
             [srt (sorting-set (sorting) subj obj)]
             [obj (list (sort "t"))]
             [srt (sorting-set srt subj obj)])
        (check-equal? (string->sorting str) srt)))

    (test-case
      "Parse the empty string as an environment"
      (check-exn exn:fail?
        (lambda () (string->environment ""))))

    (test-case
      "Parse an environment with no sort for a name"
      (check-exn exn:fail?
        (lambda () (string->environment "{x:,y:t}"))))

    (test-case
      "Parse an environment with no name for a sort"
      (check-exn exn:fail?
        (lambda () (string->environment "{x:s,:t}"))))

    (test-case
      "Parse an environment with a leading comma"
      (check-exn exn:fail?
        (lambda () (string->environment "{x:s,}"))))

    (test-case
      "Parse an environment with an invalid character"
      (check-exn exn:fail?
        (lambda () (string->environment "{x=s}"))))

    (test-case
      "Parse an empty environment"
      (let ([str "{}"]
            [env (environment)])
        (check-equal? (string->environment str) env)))

    (test-case
      "Parse an environment with a single binding"
      (let* ([str "{x:s}"]
             [env (environment)]
             [env (environment-set env (name "x") (sort "s"))])
        (check-equal? (string->environment str) env)))

    (test-case
      "Parse an environment with two bindings"
      (let* ([str "{x:s,y:t}"]
             [env (environment)]
             [env (environment-set env (name "x") (sort "s"))]
             [env (environment-set env (name "y") (sort "t"))])
        (check-equal? (string->environment str) env)))

    (test-case
      "Parse an environment with repeated bindings"
      (let* ([str "{x:s,y:t,x:r}"]
             [env (environment)]
             [env (environment-set env (name "x") (sort "r"))]
             [env (environment-set env (name "y") (sort "t"))])
        (check-equal? (string->environment str) env)))))


; Export public symbols
(provide parsers-tests)
