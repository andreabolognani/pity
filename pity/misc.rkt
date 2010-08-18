#lang racket

(require "contracts.rkt")


(define (list->set lst)
  (foldl (lambda (i acc) (set-add acc i)) (set) lst))


;; Export public symbols
(provide/contract
  [list->set (list? . -> . set?)])
