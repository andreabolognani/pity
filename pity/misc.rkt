#lang at-exp racket

(require scribble/srcdoc
         "contracts.rkt")

(provide/doc
  (proc-doc list->set
            (([lst (listof any/c)]) () . ->d . [_ (setof any/c)])
            @{Returns a set containing all the items in @scheme[lst],
              minus the duplicates.}))
(define (list->set lst)
  (foldl (lambda (i acc) (set-add acc i)) (set) lst))
