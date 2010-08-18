#lang scribble/doc

@(require scribble/manual
          (for-label (except-in racket prefix) ; Avoid name clash
                     pity))

@title[#:tag "contracts"]{Contracts}

@defmodule[pity/contracts]

Pretty generic contracts one would expect to find built-in.

@defproc[(setof [c contract?]) contract?]{

Returns a contract that recognizes a set whose every element matches
the contract @racket[c].
}

@defproc[(non-empty-setof? [c contract?]) contract?]{

Returns a contract that recognizes a non-empty set whose every element
matches the contract @racket[c].
}

@defproc[(non-empty-string? [v any/c]) boolean?]{

Returns @racket[#t] if @racket[v] is a non-empty string, @racket[#f]
otherwise.
}
