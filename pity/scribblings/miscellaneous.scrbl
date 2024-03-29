#lang scribble/doc

@; Pity: Pi-Calculus Type Inference
@; Copyright (C) 2010  Andrea Bolognani <andrea.bolognani@roundhousecode.com>
@;
@; This program is free software; you can redistribute it and/or modify
@; it under the terms of the GNU General Public License as published by
@; the Free Software Foundation; either version 2 of the License, or
@; (at your option) any later version.
@;
@; This program is distributed in the hope that it will be useful,
@; but WITHOUT ANY WARRANTY; without even the implied warranty of
@; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
@; GNU General Public License for more details.
@;
@; You should have received a copy of the GNU General Public License along
@; with this program; if not, write to the Free Software Foundation, Inc.,
@; 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

@(require scribble/manual
          (for-label (except-in racket prefix sort) ; Avoid name clash
                     pity))

@title[#:tag "miscellaneous"]{Miscellaneous}

@defmodule[pity/misc]{

Miscellaneous procedures.
}

@defproc[(flip [proc procedure?]) procedure?]{

Returns a procedure which behaves like @racket[proc], but takes its
arguments in reverse order.

This is mainly useful when calling @racket[foldl] on a list with
a function like @racket[set-add] as argument.

Caveat: it doesn't work when keyword arguments are involved.
}

@defproc[(list-replace [lst list?] [a any/c] [b any/c]) list?]{

Returns all occurrences of @racket[a] in @racket[lst] with @racket[b].
}

@defproc[(list->set [lst list?]) set?]{

Returns a set containing all the items in @racket[lst].
}

@defproc[(set->list [s set?]) list?]{

Returns a list containing all the items in @racket[s], in unspecified
order.

The returned list is guaranteed to have no duplicate items, and to be
such that calling @racket[list->set] on it will return a set that is
@racket[equal?] to @racket[s].
}

@defproc[(set-member-any? [s set?] [lst list?]) boolean?]{

Returns @racket[#t] if any of the items in @racket[lst] is a
member of @racket[s], @racket[#f] otherwise.
}
