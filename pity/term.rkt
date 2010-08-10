#lang racket

(require "name.rkt")

(define-struct nil         () #:transparent)
(define-struct replication (p) #:transparent)
(define-struct input       (x y) #:transparent)
(define-struct output      (x y) #:transparent)
(define-struct restriction (x p) #:transparent)
(define-struct composition (p q) #:transparent)
(define-struct prefix      (p q) #:transparent)


;; Routines to get names, free names and bound names in a term
;; -----------------------------------------------------------
;;
;;  The procedures are split into a glue procedure, which is exported,
;;  and several smaller procedures which calculate the free and bound
;;  names for a single type of term.

;; Find the names that have free occurences in a term
(define (free-names term)
  (match term
    [(nil)             (free-names/nil)]
    [(replication p)   (free-names/replication p)]
    [(input x y)       (free-names/input x y)]
    [(output x y)      (free-names/output x y)]
    [(restriction x p) (free-names/restriction x p)]
    [(composition p q) (free-names/composition p q)]
    [(prefix p q)      (free-names/prefix p q)]))
(provide free-names)

;; Find the names that have bound occurences in a term
(define (bound-names term)
  (match term
    [(nil)             (bound-names/nil)]
    [(replication p)   (bound-names/replication p)]
    [(input x y)       (bound-names/input x y)]
    [(output x y)      (bound-names/output x y)]
    [(restriction x p) (bound-names/restriction x p)]
    [(composition p q) (bound-names/composition p q)]
    [(prefix p q)      (bound-names/prefix p q)]))
(provide bound-names)

;; Find all the names occurring in a term
(define (names term)
  (match term
    [(nil)             (names/nil)]
    [(replication p)   (names/replication p)]
    [(input x y)       (names/input x y)]
    [(output x y)      (names/output x y)]
    [(restriction x p) (names/restriction x p)]
    [(composition p q) (names/composition p q)]
    [(prefix p q)      (names/prefix p q)]))
(provide names)

;; Names, free names and bound names in a nil term

(define (free-names/nil)
  (set))

(define (bound-names/nil)
  (set))

(define (names/nil)
  (set))

;; Names, free names and bound names in a replication

(define (free-names/replication p)
  (free-names p))

(define (bound-names/replication p)
  (bound-names p))

(define (names/replication p)
  (names p))

;; Names, free names and bound names in an input action

(define (free-names/input x y)
  (set x))

(define (bound-names/input x y)
  (list->set y))

(define (names/input x y)
  (set-union (set x)
             (list->set y)))

;; Names, free names and bound names in an output action

(define (free-names/output x y)
  (set-union (set x)
             (list->set y)))

(define (bound-names/output x y)
  (set))

(define (names/output x y)
  (set-union (set x)
             (list->set y)))

;; Names, free names and bound names under a restriction

(define (free-names/restriction x p)
  (set-remove (free-names p) x))

(define (bound-names/restriction x p)
  (set-union (set x)
             (bound-names p)))

(define (names/restriction x p)
  (set-union (set x)
             (names p)))

;; Names, free names and bound names in a composition

(define (free-names/composition p q)
  (set-union (free-names p)
             (free-names q)))

(define (bound-names/composition p q)
  (set-union (bound-names p)
             (bound-names q)))

(define (names/composition p q)
  (set-union (names p)
             (names q)))

;; Names, free names and bound names under a prefix

(define (free-names/prefix p q)
  (set-subtract
    (set-union (free-names p)
               (free-names q))
    (bound-names p)))

(define (bound-names/prefix p q)
  (set-union (bound-names p)
             (bound-names q)))

(define (names/prefix p q)
  (set-union (names p)
             (names q)))


(define (term->string term)
  (match term
    [(nil)             "0"]
    [(replication p)   (replication->string term)]
    [(input x y)       (input->string term)]
    [(output x y)      (output->string term)]
    [(restriction x p) (restriction->string term)]
    [(composition p q) (composition->string term)]
    [(prefix p q)      (prefix->string term)]))

; replication->string : replication -> string
(define (replication->string term)
  (match-let ([(replication p) term])
    (string-append "!"
                   (if (contains-composition? p)
                       (enclose (term->string p))
                       (term->string p)))))

; input->string : output -> string
(define (input->string term)
  (match-let ([(input x y) term])
    (string-append (name->string x) "("
                   (name-list->string y) ")")))

; output->string : output -> string
(define (output->string term)
  (match-let ([(output x y) term])
    (string-append (name->string x) "<"
                   (name-list->string y) ">")))

; restriction->string : restriction -> string
(define (restriction->string term)
  (match-let ([(restriction x p) term])
    (string-append (enclose (name->string x))
                   (if (contains-composition? p)
                       (enclose (term->string p))
                       (term->string p)))))

; composition->string : composition -> string
(define (composition->string term)
  (match-let ([(composition p q) term])
    (string-append (term->string p)
                   "|"
                   (term->string q))))

; prefix->string : prefix -> string
(define (prefix->string term)
  (match-let ([(prefix p q) term])
    (string-append (if (contains-composition? p)
                       (enclose (term->string p))
                       (term->string p))
                   "."
                   (if (contains-composition? q)
                       (enclose (term->string q))
                       (term->string q)))))


;; Utility functions
;; -----------------

;; Convert a list to a set
(define (list->set lst)
  (foldl (lambda (i acc) (set-add acc i)) (set) lst))

;; Enclose a string between matching parentheses
(define (enclose stuff)
  (string-append "(" stuff ")"))

;; Checks whether a term contains a composition.
;; Terms containing compositions will need to be enclosed
(define (contains-composition? term)
  (match term
    [(nil)             #f]
    [(replication p)   (contains-composition? p)]
    [(input x y)       #f]
    [(output x y)      #f]
    [(restriction x p) (contains-composition? p)]
    [(composition p q) #t]
    [(prefix p q)      (or (contains-composition? p)
                           (contains-composition? q))]))


(provide nil nil?
         replication replication?
         input input?
         output output?
         restriction restriction?
         composition composition?
         prefix prefix?
         term->string)
