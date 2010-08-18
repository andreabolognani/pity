#lang racket

(require "contracts.rkt")

(define (list->set lst)
  (foldl (lambda (i acc) (set-add acc i)) (set) lst))

(provide/contract [list->set (list? . -> . set?)])
