#lang scribble/doc

@(require scribble/manual
          (for-label (except-in racket prefix) ; Avoid name clash
                     pity))

@title[#:tag "name"]{Names}

@defmodule[pity/name]

Procedures to create and manipulate names.

@defproc[(name [v non-empty-string?]) name?]{

Returns a new name for the non-empty string @racket[v].
}

@defproc[(name? [v any/c]) boolean?]{

Returns @racket[#t] if @racket[v] is a name, @racket[#f] otherwise.
}

@defproc[(name->string [n name?]) string?]{

Returns a string @racket[equal?] to the one passed in when @racket[n]
was created.
}

@defproc[(name-list->string [lst (listof name?)]) string?]{

Returns a string representation of @racket[lst], where names are
comma-separated.
}
