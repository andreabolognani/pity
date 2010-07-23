(module main racket

 (require "name.rkt"
          "term.rkt"
          "private.rkt")

 (provide (all-from-out "name.rkt"
                        "term.rkt"
                        "private.rkt")))
