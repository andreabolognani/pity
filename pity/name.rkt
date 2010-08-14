#lang at-exp racket

(require scribble/srcdoc
         "contracts.rkt")

(provide/doc
  (proc-doc name
            (([v non-empty-string?]) () . ->d . [_ name?])
            @{Returns a new name for the non-empty string @scheme[v].})
  (proc-doc name?
            (([v any/c]) () . ->d . [_ boolean?])
            @{Returns @scheme[#t] if @scheme[v] is a name,
              @scheme[#f] otherwise.}))
(define-struct name (s) #:transparent)

(provide/doc
  (proc-doc name->string
            (([n name?]) () . ->d . [_ string?])
            @{Returns a string @scheme[equal?] to the one passed in
              when @scheme[n] was created.}))
(define (name->string n)
  (name-s n))

(provide/doc
  (proc-doc name-list->string
            (([lst (listof name?)]) () . ->d . [_ string?])
            @{Returns a string representation of @scheme[lst], where
              names are comma-separated.}))
(define (name-list->string lst)
  (string-join (map name->string lst) ","))
