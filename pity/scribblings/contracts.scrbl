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

@title[#:tag "contracts"]{Contracts}

@defmodule[pity/contracts]{

Pretty generic contracts.
}

@defproc[(setof [c contract?]) contract?]{

Returns a contract that recognizes a set whose every element matches
the contract @racket[c].
}

@defproc[(non-empty-setof [c contract?]) contract?]{

Returns a contract that recognizes a non-empty set whose every element
matches the contract @racket[c].
}

@defproc[(listof-distinct [c contract?]) contract?]{

Returns a contract that recognizes a list with no duplicates whose
every element matches the contract @racket[c].
}

@defproc[(non-empty-listof-distinct [c contract?]) contract?]{

Returns a contract that recognizes a non-empty list with no duplicates
whose every element matches the contract @racket[c].
}

@defproc[(non-empty-string? [v any/c]) boolean?]{

Returns @racket[#t] if @racket[v] is a non-empty string, @racket[#f]
otherwise.
}

@defproc[(id-string? [v any/c]) boolean?]{

Returns @racket[#t] if @racket[v] is a string suitable for use as id,
@racket[#f] otherwise.

An id string must be non-empty, start with an alphabetic character,
and be made only of alphabetic characters and digits.
}
