#lang at-exp racket

(require scribble/srcdoc)

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

;; Apply a contract.
;; Works with procedures, regexps and simple values.
(define (contract-apply c)
  (cond [(procedure? c) c]
        [(regexp? c) (lambda (x) (and (string? x) (regexp-match c x)))]
        [else (curry equal? c)]))

(provide/doc
  (proc-doc setof
            (([c contract?]) () . ->d . [_ contract?])
            @{Returns a contract that recognizes a set whose every
              element matches the contract @scheme[c].}))
(define (setof c)
  (flat-named-contract
    (string-append "(setof " (contract-name c) ")")
    (lambda (x)
      (and (set? x)
           (foldl (lambda (x y) (and x y)) ; Binary and wrapper
                  #t
                  (set-map x (contract-apply c)))))))

(provide/doc
  (proc-doc non-empty-setof
            (([c contract?]) () . ->d . [_ contract?])
            @{Returns a contract that recognizes non-empty sets whose
              every element matches the contract @scheme[c].}))
(define (non-empty-setof c)
  (flat-named-contract
    (string-append "(non-empty-setof " (contract-name c) ")")
    (and/c (setof c)
           (not/c set-empty?))))

(provide/doc
  (proc-doc non-empty-string?
            (([v any/c]) () . ->d . [_ boolean?])
            @{Returns @scheme[#t] if @scheme[v] is a non-empty
              string, @scheme[#f] otherwise.}))
(define (non-empty-string? x)
  (and (string? x)
       (not (= (string-length x) 0))))