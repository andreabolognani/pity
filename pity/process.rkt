#lang racket

(require "name.rkt"
         "contracts.rkt"
         "misc.rkt")


(define-struct nil         ()    #:transparent)
(define-struct replication (p)   #:transparent)
(define-struct input       (x y) #:transparent)
(define-struct output      (x y) #:transparent)
(define-struct restriction (x p) #:transparent)
(define-struct composition (p q) #:transparent)
(define-struct prefix      (p q) #:transparent)


;; Recognize any kind of process
(define (process? v)
  (or
    (nil? v)
    (replication? v)
    (input? v)
    (output? v)
    (restriction? v)
    (composition? v)
    (prefix? v)))


;; Routines to get names, free names and bound names in a process
;; --------------------------------------------------------------
;;
;;  The procedures are split into a glue procedure, which is exported,
;;  and several smaller procedures which calculate the free and bound
;;  names for a single type of process.


;; Find the names that have free occurences in a process
(define (free-names process)
  (match process
    [(nil)             (free-names/nil)]
    [(replication p)   (free-names/replication p)]
    [(input x y)       (free-names/input x y)]
    [(output x y)      (free-names/output x y)]
    [(restriction x p) (free-names/restriction x p)]
    [(composition p q) (free-names/composition p q)]
    [(prefix p q)      (free-names/prefix p q)]))


;; Find the names that have bound occurences in a process
(define (bound-names process)
  (match process
    [(nil)             (bound-names/nil)]
    [(replication p)   (bound-names/replication p)]
    [(input x y)       (bound-names/input x y)]
    [(output x y)      (bound-names/output x y)]
    [(restriction x p) (bound-names/restriction x p)]
    [(composition p q) (bound-names/composition p q)]
    [(prefix p q)      (bound-names/prefix p q)]))


;; Find all the names occurring in a process
(define (names process)
  (match process
    [(nil)             (names/nil)]
    [(replication p)   (names/replication p)]
    [(input x y)       (names/input x y)]
    [(output x y)      (names/output x y)]
    [(restriction x p) (names/restriction x p)]
    [(composition p q) (names/composition p q)]
    [(prefix p q)      (names/prefix p q)]))


;; Names, free names and bound names in the nil process

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


;; Process pretty-printing
;; -----------------------
;;
;;  When a process is converted to a string, only strictly needed
;;  parentheses should be present.
;;
;;  More importantly, it must be possible to parse the returned string
;;  and obtain the same process once again.


;; Convert a process to a string
(define (process->string process)
  (match process
    [(nil)             "0"]
    [(replication p)   (process->string/replication p)]
    [(input x y)       (process->string/input x y)]
    [(output x y)      (process->string/output x y)]
    [(restriction x p) (process->string/restriction x p)]
    [(composition p q) (process->string/composition p q)]
    [(prefix p q)      (process->string/prefix p q)]))


;; Convert a replication to a string
(define (process->string/replication p)
  (string-append "!"
                 (if (contains-composition? p)
                     (enclose (process->string p))
                     (process->string p))))


;; Convert an input to a string
(define (process->string/input x y)
  (string-append (name->string x) "("
                 (name-list->string y) ")"))


;; Convert an output to a string
(define (process->string/output x y)
  (string-append (name->string x) "<"
                 (name-list->string y) ">"))


;; Convert a restriction to a string
(define (process->string/restriction x p)
  (string-append (enclose (name->string x))
                 (if (contains-composition? p)
                     (enclose (process->string p))
                     (process->string p))))


;; Convert a composition to a string
(define (process->string/composition p q)
  (string-append (process->string p)
                 "|"
                 (process->string q)))


;; Convert a prefix to a string
(define (process->string/prefix p q)
  (string-append (if (contains-composition? p)
                     (enclose (process->string p))
                     (process->string p))
                 "."
                 (if (contains-composition? q)
                     (enclose (process->string q))
                     (process->string q))))


;; Utility functions
;; -----------------


;; Enclose a string between matching parentheses
(define (enclose stuff)
  (string-append "(" stuff ")"))


;; Checks whether a process contains a composition.
;; Processes containing compositions will need to be enclosed
(define (contains-composition? process)
  (match process
    [(nil)             #f]
    [(replication p)   (contains-composition? p)]
    [(input x y)       #f]
    [(output x y)      #f]
    [(restriction x p) (contains-composition? p)]
    [(composition p q) #t]
    [(prefix p q)      (or (contains-composition? p)
                           (contains-composition? q))]))


;; Export public symbols
(provide/contract
  [nil             (                       ->   nil?)]
  [nil?            (any/c                . -> . boolean?)]
  [replication     (process?             . -> . replication?)]
  [replication?    (any/c                . -> . boolean?)]
  [input           (name? (listof name?) . -> . input?)]
  [input?          (any/c                . -> . boolean?)]
  [output          (name? (listof name?) . -> . output?)]
  [output?         (any/c                . -> . boolean?)]
  [restriction     (name? process?       . -> . restriction?)]
  [restriction?    (any/c                . -> . boolean?)]
  [composition     (process? process?    . -> . composition?)]
  [composition?    (any/c                . -> . boolean?)]
  [prefix          (process? process?    . -> . prefix?)]
  [prefix?         (any/c                . -> . boolean?)]
  [process?        (any/c                . -> . boolean?)]
  [free-names      (process?             . -> . (setof name?))]
  [bound-names     (process?             . -> . (setof name?))]
  [names           (process?             . -> . (setof name?))]
  [process->string (process?             . -> . string?)])
