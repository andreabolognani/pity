#lang scribble/doc

@; Pity: Pi-Calculus Type Checking
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

@title[#:tag "sorts-and-sortings"]{Sorts and sortings}

@declare-exporting[pity]

Procedures to create and modify sorts and sortings.

@section{Sorts}

@defproc[(sort [s string?]) sort?]{

Returns a new sort.}

@defproc[(sort? [v any/c]) boolean?]{

Returns @racket[#t] if @racket[v] is a sort, @racket[#f] otherwise.
}

@defproc[(sort->string [s sort?]) string?]{

Returns a string @racket[equal?] to the one passed in when @racket[s]
was created.
}

@section{Sortings}

@defproc[(sorting) sorting?]{

Returns an empty sorting.

All sortings are derived by adding mappings to the empty sorting.
}

@defproc[(sorting? [v any/c]) boolean?]{

Returns @racket[#t] if @racket[v] is a sorting, @racket[#f] otherwise.
}

@defproc[(sorting-get [s sorting?]
                      [subj sort?])
         (or/c (listof sort?) #f)]{

Returns the object sorting for @racket[subj], or @racket[#f] if
@racket[subj] has no object sorting in @racket[s].
}

@defproc[(sorting-add [s sorting?]
                      [subj sort?]
                      [obj (listof sort?)])
         sorting?]{

Returns a new sorting which behaves as @racket[s], but maps @racket[subj]
to @racket[obj].

If a mapping for @racket[subj] is already present in @racket[s], it is
replaced by the new one.
}

@defproc[(sorting-remove [s sorting?]
                         [subj sort?])
         sorting?]{
		 
Returns a new sorting which behaves as @racket[s], except that any mapping
of @racket[subj] is removed.
}

@defproc[(string->sorting [str string?]) sorting?]{

Returns the sorting obtained by parsing @racket[str].

Raises @racket[exn:fail:read] if @racket[str] cannot be parsed
correctly.
}
