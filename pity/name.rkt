#lang racket

(require "contracts.rkt")


(define-struct name (n) #:transparent)


(define (name->string n)
  (name-n n))


(define (name-list->string lst)
  (string-join (map name->string lst) ","))


;; Export public symbols
(provide/contract
  [name              (non-empty-string? . -> . name?)]
  [name?             (any/c             . -> . boolean?)]
  [name->string      (name?             . -> . string?)]
  [name-list->string ((listof name?)    . -> . string?)])
