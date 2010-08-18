#lang scribble/doc

@(require scribble/manual
          (for-label (except-in racket prefix) ; Avoid name clash
                     pity))

@title[#:tag "misc"]{Miscellaneous}

@defmodule[pity/misc]

Miscellaneous procedures.

@defproc[(list->set [lst list?]) set?]{

Returns a set containing all the items in @racket[lst].
}
