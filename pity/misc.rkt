#lang at-exp racket

(require scribble/srcdoc
         "private/lexer.rkt"
         "private/parser.rkt")

(define (string->term str)
  (let ([ip (open-input-string str)])
    (private-parser (lambda () (private-lexer ip)))))


;; Contracts
;; ---------
;;
;;  Pretty generic contracts one would expect to find built-in.

(provide/doc
  (proc-doc setof
            (([c contract?]) () . ->d . [_ contract?])
            @{Returns a contract that recognizes a set whose every
              element matches the contract @scheme[c].}))
(define (setof c)
  (let* ([band (lambda (a b) (and a b))] ; Binary and wrapper
         [name (object-name c)]
         [name (if (false? name) (format "~a" c) (symbol->string name))]
         [name (string-append "(setof " name ")")])
    (flat-named-contract
       name
       (lambda (x)
         (and (set? x)
              (foldl band
                     #t
                     (set-map x (cond
                                  [(procedure? c) c]
                                  [else (lambda (i) (equal? i c))]))))))))

(provide/doc
  (proc-doc non-empty-setof
            (([c contract?]) () . ->d . [_ contract?])
            @{Returns a contract that recognizes non-empty sets whose
              every element matches the contract @scheme[c].}))
(define (non-empty-setof c)
  (let ([c-name (symbol->string (object-name c))])
    (flat-named-contract
      (string-append "(non-empty-setof " c-name ")")
      (and/c (setof c) (not/c set-empty?)))))

(provide/doc
  (proc-doc non-empty-string?
            (([v any/c]) () . ->d . [_ boolean?])
            @{Returns @scheme[#t] if @scheme[v] is a non-empty
              string, @scheme[#f] otherwise.}))
(define (non-empty-string? x)
  (and (string? x)
       (not (= (string-length x) 0))))

(provide string->term)
