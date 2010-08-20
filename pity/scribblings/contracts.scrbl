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
          (for-label (except-in racket prefix) ; Avoid name clash
                     pity))

@title[#:tag "contracts"]{Contracts}

@declare-exporting[pity]

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
