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

@title[#:tag "names"]{Names}

@defmodule[pity/name]{

Procedures to create and manipulate names.
}

@defproc[(name [v id-string?]) name?]{

Returns a new name for the non-empty string @racket[v].
}

@defproc[(name? [v any/c]) boolean?]{

Returns @racket[#t] if @racket[v] is a name, @racket[#f] otherwise.
}

@defproc[(name-max [n1 name?] [n2 name?]) name?]{

Returns the freshest name between @racket[n1] and @racket[n2].
}

@defproc[(name-refresh [n name?]) name?]{

Returns a new name which is a refreshed version of @racket[n].

A name is refreshed by increasing its numeric part; if the @racket[n]
has no numeric part, it is added.
}

@defproc[(name->string [n name?]) string?]{

Returns a string @racket[equal?] to the one passed in when @racket[n]
was created.
}

@defproc[(name-list->string [lst (listof name?)]) string?]{

Returns a string representation of @racket[lst], where names are
comma-separated.
}

@defproc[(string->name-list [str string?]) (listof name?)]{

Returns a list containing all the comma-separated elements of
@racket[str] as names.
}
