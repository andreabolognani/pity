#lang racket/base

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


(require racket/contract
         racket/function
         racket/set
         racket/match
         parser-tools/yacc
         "private/common-lexer.rkt"
         "name.rkt"
         "sort.rkt"
         "sorting.rkt"
         "environment.rkt"
         "contracts.rkt"
         "misc.rkt")



; Constructors guards
; -------------------
;
;  Guards are called whenever an instance of a struct is created, and
;  can be used to alter the data before it is encapsulated in the
;  structure, or to prevent its creation altogether.
;
;  These routines are attached to their respective structs and, after
;  checking the structure contract is respected, perform any action
;  that might be needed to ensure no name capture occurrs.


; Guard for actions
(define (action-guard x y type-name)
  (when (not (name? x))
        (error type-name
               (format "expected <name?>, given: ~a" x)))
  (when (not ((non-empty-listof-distinct name?) y))
        (error type-name
               (format "expected <(non-empty-listof-distinct name?)>, given: ~a" y)))
  (values x y))


; Guard for prefix.
;
; If the action a is about to bind a name which is already bound in
; p, the name is refreshed in p to avoid name capture.
(define (prefix-guard a p type-name)
  (when (not (action? a))
        (error type-name
               (format "expected <action?>, given: ~a" a)))
  (when (not (process? p))
        (error type-name
               (format "expected <process?>, given: ~a" p)))
  (let* ([bound-a (bound-names/action a)]
         [bound-p (process-bound-names p)]
         [bound (set-intersect bound-a bound-p)]
         [bound (set->list bound)])
    (values a
            (foldl (flip process-refresh-name) p bound))))


; Guard for restriction.
;
; If the name x is bound in p, it is refreshed in p to avoid capture.
(define (restriction-guard x p type-name)
  (when (not (name? x))
        (error type-name
               (format "expected <name?>, given: ~a" x)))
  (when (not (process? p))
        (error type-name
               (format "expected <process?>, given: ~a" p)))
  (let ([bound (process-bound-names p)])
    (values x
            (if (set-member? bound x)
                (process-refresh-name p x)
                p))))


; Guard for replication
(define (replication-guard p type-name)
  (when (not (process? p))
        (error type-name
               (format "expected <process?>, given: ~a" p)))
  (values p))


; Guard for composition.
;
; Any name which is bound in p and either free or bound in q is an error;
; to fix it, offending names are refreshed in q.
;
; Additional care is taken not to capture any name in either p or q
; when refreshing.
(define (composition-guard p q type-name)
  (when (not (process? p))
        (error type-name
               (format "expected <process?>, given: ~a" p)))
  (when (not (process? q))
        (error type-name
               (format "expected <process?>, given: ~a" q)))
  (letrec ([fix (lambda (procs)
                  (let* ([p (car procs)]
                         [q (cdr procs)]
                         [bound (process-bound-names p)]
                         [all (process-names q)]
                         [err (set-intersect bound all)]
                         [bound (process-bound-names q)]
                         [all (process-names p)]
                         [err (set-union err (set-intersect bound all))]
                         [err (set->list err)])
                    (if (null? err)
                        (cons p q)
                        (let* ([n (car err)]
                               [np (fresh-name p n)]
                               [nq (fresh-name q n)]
                               [nn (name-max np nq)])
                          (fix (cons p
                                    (replace-name q n nn)))))))]
           [procs (fix (cons p q))])
    (values (car procs)
            (cdr procs))))



; Structures definition
; ---------------------


(struct nil         ()
                    #:transparent)
(struct input       (x y)
                    #:guard action-guard
                    #:transparent)
(struct output      (x y)
                    #:guard action-guard
                    #:transparent)
(struct prefix      (a p)
                    #:guard prefix-guard
                    #:transparent)
(struct restriction (x p)
                    #:guard restriction-guard
                    #:transparent)
(struct replication (p)
                    #:guard replication-guard
                    #:transparent)
(struct composition (p q)
                    #:guard composition-guard
                    #:transparent)


; Recognize any kind of process
(define (process? v)
  (or
    (nil? v)
    (prefix? v)
    (restriction? v)
    (replication? v)
    (composition? v)))


; Recognize an action
(define (action? v)
  (or
    (input? v)
    (output? v)))



; Routines to get names, free names and bound names in a process
; --------------------------------------------------------------
;
;  The procedures are split into a glue procedure, which is exported,
;  and several smaller procedures which calculate the free and bound
;  names for a single type of process.


; Find the names that have free occurences in a process
(define (process-free-names process)
  (match process
    [(nil)             (free-names/nil)]
    [(prefix a p)      (free-names/prefix a p)]
    [(restriction x p) (free-names/restriction x p)]
    [(replication p)   (free-names/replication p)]
    [(composition p q) (free-names/composition p q)]))


; Find the names that have bound occurences in a process
(define (process-bound-names process)
  (match process
    [(nil)             (bound-names/nil)]
    [(prefix a p)      (bound-names/prefix a p)]
    [(restriction x p) (bound-names/restriction x p)]
    [(replication p)   (bound-names/replication p)]
    [(composition p q) (bound-names/composition p q)]))


; Find all the names occurring in a process
(define (process-names process)
  (match process
    [(nil)             (names/nil)]
    [(prefix a p)      (names/prefix a p)]
    [(restriction x p) (names/restriction x p)]
    [(replication p)   (names/replication p)]
    [(composition p q) (names/composition p q)]))


; Names, free names and bound names in the nil process

(define (free-names/nil)
  (set))

(define (bound-names/nil)
  (set))

(define (names/nil)
  (set))


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


; Names, free names and bound names in an action

(define (free-names/action a)
  (match a
    [(input x y)  (free-names/input x y)]
    [(output x y) (free-names/output x y)]))

(define (bound-names/action a)
  (match a
    [(input x y)  (bound-names/input x y)]
    [(output x y) (bound-names/output x y)]))

(define (names/action a)
  (match a
    [(input x y)  (names/input x y)]
    [(output x y) (names/output x y)]))


; Names, free names and bound names under a prefix

(define (free-names/prefix a p)
  (set-subtract
    (set-union (free-names/action a)
               (process-free-names p))
    (bound-names/action a)))

(define (bound-names/prefix a p)
  (set-union (bound-names/action a)
             (process-bound-names p)))

(define (names/prefix a p)
  (set-union (names/action a)
             (process-names p)))


; Names, free names and bound names under a restriction

(define (free-names/restriction x p)
  (set-remove (process-free-names p) x))

(define (bound-names/restriction x p)
  (set-union (set x)
             (process-bound-names p)))

(define (names/restriction x p)
  (set-union (set x)
             (process-names p)))


; Names, free names and bound names in a replication

(define (free-names/replication p)
  (process-free-names p))

(define (bound-names/replication p)
  (process-bound-names p))

(define (names/replication p)
  (process-names p))


; Names, free names and bound names in a composition

(define (free-names/composition p q)
  (set-union (process-free-names p)
             (process-free-names q)))

(define (bound-names/composition p q)
  (set-union (process-bound-names p)
             (process-bound-names q)))

(define (names/composition p q)
  (set-union (process-names p)
             (process-names q)))



; Name changing routines
; ----------------------
;
;  Bound names must be chosen fresh; the following routines help
;  coping with cases when this rule is not respected.


; Obtain a name that is guaranteed to be fresh in a process
(define (fresh-name p n)
  (let* ([names (process-names p)]
         [m (name-refresh n)]
         [cmp (lambda (x)
                (or (not (name-compatible? x m))
                    (equal? (name-max x m) m)))]
         [res (set-map names cmp)]
         [band (lambda (x y) (and x y))] ; Binary and wrapper
         [fresh? (foldl band #t res)])
    (if (and fresh? (not (set-member? names m)))
        m
        (fresh-name p m))))


; Refresh a name in a process
(define (process-refresh-name self n)
  (replace-name self n (fresh-name self n)))


; Replace a name in a process with another name.
;
; No checks are made on the freshness of the new name, so it's a
; really good idea to obtain a guaranteed fresh name first.
(define (replace-name self n m)
  (match self
    [(nil)             (nil)]
    [(prefix a p)      (replace-name/prefix a p n m)]
    [(restriction x p) (replace-name/restriction x p n m)]
    [(replication p)   (replace-name/replication p n m)]
    [(composition p q) (replace-name/composition p q n m)]))


; Replace a name in an input action
(define (replace-name/input x y n m)
  (let ([x1 (if (equal? x n) m x)]
        [y1 (list-replace y n m)])
    (input x1 y1)))


; Replace a name in an output action
(define (replace-name/output x y n m)
  (let ([x1 (if (equal? x n) m x)]
        [y1 (list-replace y n m)])
    (output x1 y1)))


; Replace a name in an action
(define (replace-name/action a n m)
  (match a
    [(input x y)  (replace-name/input x y n m)]
    [(output x y) (replace-name/output x y n m)]))


; Replace a name in a prefix
(define (replace-name/prefix a p n m)
  (prefix (replace-name/action a n m)
          (replace-name p n m)))


; Replace a name in a restriction
(define (replace-name/restriction x p n m)
  (let ([x1 (if (equal? x n) m x)])
    (restriction x1 (replace-name p n m))))


; Replace a name in a replication
(define (replace-name/replication p n m)
  (replication (replace-name p n m)))


; Replace a name in a composition
(define (replace-name/composition p q n m)
  (composition (replace-name p n m)
               (replace-name q n m)))



; Environments creation
; ---------------------
;
;  The following procedures are used to calculate all the possible
;  environments, given a process and a sorting.


; Wrapper to avoid extracting names and sorts over and over again
(define (process-environments p srt)
  (let ([names (set->list (process-free-names p))]
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
    [(null? names) (set)]
    [(null? (cdr names)) (collect (car names) (list (environment)))]
    [else (collect (car names)
                   (set->list (process-environments-real (cdr names) sorts)))])))



; Process typing
; --------------
;
;  The following procedures are used to check that a process respects
;  a given sorting. As usual, the main procedure acts as a glue for
;  the smaller functions implementing the actual type checking.


; Check whether a process respects a given sorting
(define (process-respects? p srt)
  (let* ([envs (process-environments p srt)]
         [collect (lambda (env) (if (check-typing p srt env) env #f))]
         [res (filter (lambda (x) x) (set-map envs collect))])
    (if (null? res) #f (list->set res))))


; Glue procedure
(define (check-typing process srt env)
  (match process
    [(nil)                   #t]
    [(prefix (input x y) p)  (check-typing/input x y p srt env)]
    [(prefix (output x y) p) (check-typing/output x y p srt env)]
    [(restriction x p)       (check-typing/restriction x p srt env)]
    [(replication p)         (check-typing p srt env)]
    [(composition p q)       (check-typing/composition p q srt env)]))


; Check typing for an input action
(define (check-typing/input x y p srt env)
  (let* ([names (environment-domain env)]
         [s (environment-ref env x)]
         [obj-srt (if (not s) #f (sorting-ref srt s))]
         [newenv (environment-remove env x)]
         [arity-ok (and obj-srt (= (length y) (length obj-srt)))])
    (if (or (set-member-any? names y) (not obj-srt) (not arity-ok))
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
    [(prefix a p)      (process->string/prefix a p)]
    [(restriction x p) (process->string/restriction x p)]
    [(replication p)   (process->string/replication p)]
    [(composition p q) (process->string/composition p q)]))


; Convert an action to a string
(define (process->string/action a)
  (match a
    [(input x y)  (process->string/input x y)]
    [(output x y) (process->string/output x y)]))


; Convert an input to a string
(define (process->string/input x y)
  (string-append (name->string x) "("
                 (name-list->string y) ")"))


; Convert an output to a string
(define (process->string/output x y)
  (string-append (name->string x) "<"
                 (name-list->string y) ">"))


; Convert a prefix to a string
(define (process->string/prefix a p)
  (string-append (process->string/action a)
                 "."
                 (if (composition? p)
                     (enclose (process->string p))
                     (process->string p))))


; Convert a restriction to a string
(define (process->string/restriction x p)
  (string-append (enclose (name->string x))
                 (if (composition? p)
                     (enclose (process->string p))
                     (process->string p))))


; Convert a replication to a string
(define (process->string/replication p)
  (string-append "!"
                 (if (composition? p)
                     (enclose (process->string p))
                     (process->string p))))


; Convert a composition to a string
(define (process->string/composition p q)
  (string-append (process->string p)
                 "|"
                 (process->string q)))


; Convert a string to a process
(define (string->process str)
  (with-handlers ([exn:fail?
                   (lambda (e)
                     (raise (exn:fail "Error while parsing process"
                                      (exn-continuation-marks e))))])
    (let ([ip (open-input-string str)])
      (process-parser (lambda () (common-lexer ip))))))


; Parser for processes
(define process-parser
  (parser

    (start  process)
    (end    EOF)
    (tokens common-symbols common-values)
    (error  (lambda (a b c) (void)))

    (grammar

      (process
        [(subprocess)              $1]
        [(subprocess PIPE process) (composition $1 $3)])

      (subprocess
        [(part)                    $1]
        [(BANG subprocess)         (replication $2)])

      (part
        [(agent)                   $1]
        [(LP name RP part)         (restriction $2 $4)])

      (agent
        [(NIL)                     (nil)]
        [(action DOT agent)        (prefix $1 $3)]
        [(LP process RP)           $2])

      (action
        [(name LP names RP)        (input $1 $3)]
        [(name LAB names RAB)      (output $1 $3)])

      (names
        [(name)                    (list $1)]
        [(name COMMA names)        (list* $1 $3)])

      (name
        [(ID)                      (name $1)]))))



; Utility functions
; -----------------


; Enclose a string between matching parentheses
(define (enclose stuff)
  (string-append "(" stuff ")"))



; Export public symbols
; ---------------------

(provide
  (struct-out nil)
  (struct-out input)
  (struct-out output)
  (struct-out prefix)
  (struct-out restriction)
  (struct-out replication)
  (struct-out composition))
(provide/contract
  [process?             (any/c             . -> . boolean?)]
  [action?              (any/c             . -> . boolean?)]
  [process-free-names   (process?          . -> . (setof name?))]
  [process-bound-names  (process?          . -> . (setof name?))]
  [process-names        (process?          . -> . (setof name?))]
  [process-refresh-name (process? name?    . -> . process?)]
  [process-environments (process? sorting? . -> . (setof environment?))]
  [process-respects?    (process? sorting? . -> . (or/c (non-empty-setof environment?) #f))]
  [process->string      (process?          . -> . string?)]
  [string->process      (string?           . -> . process?)])
