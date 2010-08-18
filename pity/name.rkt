#lang racket

(require "contracts.rkt")

(define-struct name (n) #:transparent)
(provide/contract [name (non-empty-string? . -> . name?)]
                  [name? (any/c . -> . boolean?)])


(define (name->string n)
  (name-n n))
(provide/contract [name->string (name? . -> . string?)])


(define (name-list->string lst)
  (string-join (map name->string lst) ","))
(provide/contract [name-list->string ((listof name?) . -> . string?)])
