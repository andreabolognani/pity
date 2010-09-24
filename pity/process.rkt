#lang racket

; Pity: Pi-Calculus Type Checking
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


(require "name.rkt"
         "sort.rkt"
         "sorting.rkt"
         "environment.rkt"
         "contracts.rkt"
         "misc.rkt")


(define-struct nil         ()    #:transparent)
(define-struct replication (p)   #:transparent)
(define-struct input       (x y) #:transparent)
(define-struct output      (x y) #:transparent)
(define-struct restriction (x p) #:transparent)
(define-struct composition (p q) #:transparent)
(define-struct prefix      (p q) #:transparent)


; Recognize any kind of process
(define (process? v)
  (or
    (nil? v)
    (replication? v)
    (input? v)
    (output? v)
    (restriction? v)
    (composition? v)
    (prefix? v)))


; Routines to get names, free names and bound names in a process
; --------------------------------------------------------------
;
;  The procedures are split into a glue procedure, which is exported,
;  and several smaller procedures which calculate the free and bound
;  names for a single type of process.


; Find the names that have free occurences in a process
(define (free-names process)
  (match process
    [(nil)             (free-names/nil)]
    [(replication p)   (free-names/replication p)]
    [(input x y)       (free-names/input x y)]
    [(output x y)      (free-names/output x y)]
    [(restriction x p) (free-names/restriction x p)]
    [(composition p q) (free-names/composition p q)]
    [(prefix p q)      (free-names/prefix p q)]))


; Find the names that have bound occurences in a process
(define (bound-names process)
  (match process
    [(nil)             (bound-names/nil)]
    [(replication p)   (bound-names/replication p)]
    [(input x y)       (bound-names/input x y)]
    [(output x y)      (bound-names/output x y)]
    [(restriction x p) (bound-names/restriction x p)]
    [(composition p q) (bound-names/composition p q)]
    [(prefix p q)      (bound-names/prefix p q)]))


; Find all the names occurring in a process
(define (names process)
  (match process
    [(nil)             (names/nil)]
    [(replication p)   (names/replication p)]
    [(input x y)       (names/input x y)]
    [(output x y)      (names/output x y)]
    [(restriction x p) (names/restriction x p)]
    [(composition p q) (names/composition p q)]
    [(prefix p q)      (names/prefix p q)]))


; Names, free names and bound names in the nil process

(define (free-names/nil)
  (set))

(define (bound-names/nil)
  (set))

(define (names/nil)
  (set))


; Names, free names and bound names in a replication

(define (free-names/replication p)
  (free-names p))

(define (bound-names/replication p)
  (bound-names p))

(define (names/replication p)
  (names p))


; Names, free names and bound names in an input action

(define (free-names/input x y)
  (set x))

(define (bound-names/input x y)
  (list->set y))

(define (names/input x y)
  (set-union (set x)
             (list->set y)))


; Names, free names and bound names in an output action

(define (free-names/output x y)
  (set-union (set x)
             (list->set y)))

(define (bound-names/output x y)
  (set))

(define (names/output x y)
  (set-union (set x)
             (list->set y)))


; Names, free names and bound names under a restriction

(define (free-names/restriction x p)
  (set-remove (free-names p) x))

(define (bound-names/restriction x p)
  (set-union (set x)
             (bound-names p)))

(define (names/restriction x p)
  (set-union (set x)
             (names p)))


; Names, free names and bound names in a composition

(define (free-names/composition p q)
  (set-union (free-names p)
             (free-names q)))

(define (bound-names/composition p q)
  (set-union (bound-names p)
             (bound-names q)))

(define (names/composition p q)
  (set-union (names p)
             (names q)))


; Names, free names and bound names under a prefix

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


; Process pretty-printing
; -----------------------
;
;  When a process is converted to a string, only strictly needed
;  parentheses should be present.
;
;  More importantly, it must be possible to parse the returned string
;  and obtain the same process once again.


; Convert a process to a string
(define (process->string process)
  (match process
    [(nil)             "0"]
    [(replication p)   (process->string/replication p)]
    [(input x y)       (process->string/input x y)]
    [(output x y)      (process->string/output x y)]
    [(restriction x p) (process->string/restriction x p)]
    [(composition p q) (process->string/composition p q)]
    [(prefix p q)      (process->string/prefix p q)]))


; Convert a replication to a string
(define (process->string/replication p)
  (string-append "!"
                 (if (contains-composition? p)
                     (enclose (process->string p))
                     (process->string p))))


; Convert an input to a string
(define (process->string/input x y)
  (string-append (name->string x) "("
                 (name-list->string y) ")"))


; Convert an output to a string
(define (process->string/output x y)
  (string-append (name->string x) "<"
                 (name-list->string y) ">"))


; Convert a restriction to a string
(define (process->string/restriction x p)
  (string-append (enclose (name->string x))
                 (if (contains-composition? p)
                     (enclose (process->string p))
                     (process->string p))))


; Convert a composition to a string
(define (process->string/composition p q)
  (string-append (process->string p)
                 "|"
                 (process->string q)))


; Convert a prefix to a string
(define (process->string/prefix p q)
  (string-append (if (contains-composition? p)
                     (enclose (process->string p))
                     (process->string p))
                 "."
                 (if (contains-composition? q)
                     (enclose (process->string q))
                     (process->string q))))


; Environments creation
; ---------------------
;
;  The following procedures are used to calculate all the possible
;  environments, given a process and a sorting.


(define (process-environments p srt)
  (let ([names (set->list (free-names p))]
        [sorts (set->list (sorting-domain srt))])
    (process-environments-real names sorts)))


; Build all the possible environments.
;
; If the list of free names is empty, there are no environments;
; otherwise, take the first name, fold over all the sorts, and for
; each sort fold over all the environments obtained by recurring
; with all the names except for the first.
;
; In the inner fold call, you have a name, a sort and an environment:
; add the mapping from the name to the sort to the environment, and
; collect all the environments obtained this way. In the outer fold
; call, perform the union of all the sets obtained with the inner fold.
(define (process-environments-real names sorts)
  (let ([collect (lambda (n envs)
                   (foldl (lambda (s acc)
                            (set-union
                              acc
                              (foldl (lambda (env int-acc)
                                       (set-add
                                         int-acc
                                         (environment-set env n s)))
                                     (set)
                                     envs)))
                          (set)
                          sorts))])
  (cond
    [(empty? names) (set)]
    [(empty? (cdr names)) (collect (car names) (list (environment)))]
    [else (collect (car names)
                   (set->list (process-environments-real (cdr names) sorts)))])))


; Process typing
; --------------
;
;  The following procedures are used to check that a process respects
;  a given sorting. As usual, the main procedure acts as a glue for
;  the smaller functions implementing the actual type checking.


; Check whether a process respects a given sorting
(define (process-respects? p srt env)
  (if (check-typing p srt env)
      env
      #f))


; Glue procedure
(define (check-typing process srt env)
  (match process
    [(nil)                   #t]
    [(replication p)         (check-typing p srt env)]
    [(prefix (input x y) p)  (check-typing/input x y p srt env)]
    [(prefix (output x y) p) (check-typing/output x y p srt env)]
    [(restriction x p)       (check-typing/restriction x p srt env)]
    [(composition p q)       (check-typing/composition p q srt env)]))


; Check typing for an input action
(define (check-typing/input x y p srt env)
  (let* ([names (environment-domain env)]
         [s (environment-ref env x)]
         [obj-srt (if (not s) #f (sorting-ref srt s))]
         [newenv (environment-remove env x)])
    (if (or (set-member-any? names y) (not obj-srt))
        #f
        (check-typing p srt (environment-set-multiple newenv y obj-srt)))))


; Check typing for an output action
(define (check-typing/output x y p srt env)
  (let* ([s (environment-ref env x)]
         [sorts (map (curry environment-ref env) y)]
         [obj-srt (if (not s) #f (sorting-ref srt s))])
    (if (or (not obj-srt) (not (equal? sorts obj-srt)))
        #f
        (check-typing p srt (environment-remove-multiple env (cons x y))))))


; Check typing for a restriction
(define (check-typing/restriction x p srt env)
  (let ([names (environment-domain env)]
        [sorts (sorting-domain srt)]
        [bor (lambda (x y) (or x y))] ; Binary or wrapper
        [recur (lambda (s)
                 (if (environment-compatible? env x s)
                     (check-typing p srt (environment-set env x s))
                     #f))])
    (if (set-member? names x)
        #f
        (foldl bor #f (set-map sorts recur)))))


; Check typing for a composition
(define (check-typing/composition p q srt env)
  (and (check-typing p srt env)
       (check-typing q srt env)))


; Utility functions
; -----------------


; Enclose a string between matching parentheses
(define (enclose stuff)
  (string-append "(" stuff ")"))


; Checks whether a process contains a composition.
; Processes containing compositions will need to be enclosed
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


; Export public symbols
(provide/contract
  [nil                  (                                 ->   nil?)]
  [nil?                 (any/c                          . -> . boolean?)]
  [replication          (process?                       . -> . replication?)]
  [replication?         (any/c                          . -> . boolean?)]
  [input                (name? (non-empty-listof name?) . -> . input?)]
  [input?               (any/c                          . -> . boolean?)]
  [output               (name? (non-empty-listof name?) . -> . output?)]
  [output?              (any/c                          . -> . boolean?)]
  [restriction          (name? process?                 . -> . restriction?)]
  [restriction?         (any/c                          . -> . boolean?)]
  [composition          (process? process?              . -> . composition?)]
  [composition?         (any/c                          . -> . boolean?)]
  [prefix               (process? process?              . -> . prefix?)]
  [prefix?              (any/c                          . -> . boolean?)]
  [process?             (any/c                          . -> . boolean?)]
  [free-names           (process?                       . -> . (setof name?))]
  [bound-names          (process?                       . -> . (setof name?))]
  [names                (process?                       . -> . (setof name?))]
  [process-environments (process? sorting?              . -> . (setof environment?))]
  [process-respects?    (process? sorting? environment? . -> . (or/c environment? #f))]
  [process->string      (process?                       . -> . string?)])
