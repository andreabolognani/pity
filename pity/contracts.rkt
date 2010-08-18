#lang racket

;; Contracts
;; ---------
;;
;;  Pretty generic contracts one would expect to find built-in.


;; Get the name for a contract.
;; The name is the object-name of the contract if the contract has
;; one, or the same string that would be printed by display
(define (contract-name c)
  (let ([name (object-name c)])
    (cond [(false? name) (format "~a" c)]
          [(symbol? name) (symbol->string name)]
          [else name])))


;; Create a procedure which checks a contract.
;; Works with procedures, regexps and simple values.
(define (contract-procedure c)
  (cond [(procedure? c) c]
        [(regexp? c) (lambda (x) (and (string? x) (regexp-match c x)))]
        [else (curry equal? c)]))


(define (setof c)
  (flat-named-contract
    (string-append "(setof " (contract-name c) ")")
    (lambda (x)
      (and (set? x)
           (foldl (lambda (x y) (and x y)) ; Binary and wrapper
                  #t
                  (set-map x (contract-procedure c)))))))


(define (non-empty-setof c)
  (flat-named-contract
    (string-append "(non-empty-setof " (contract-name c) ")")
    (and/c (setof c)
           (not/c set-empty?))))


(define (non-empty-string? x)
  (and (string? x)
       (not (= (string-length x) 0))))

(provide/contract [setof (contract? . -> . contract?)]
                  [non-empty-setof (contract? . -> . contract?)]
                  [non-empty-string? (any/c . -> . boolean?)])
