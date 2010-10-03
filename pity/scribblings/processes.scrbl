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

@title[#:tag "processes"]{Processes}

@declare-exporting[pity]

Procedures to create and manipulate processes.

@defproc[(nil) nil?]{

Returns a nil process.
}

@defproc[(nil? [v any/c]) boolean?]{

Returns @racket[#t] if @racket[v] is a @racket[nil] process, @racket[#f] otherwise.
}

@defproc[(replication [p process?]) replication?]{

Returns the replication of the process @racket[p].
}

@defproc[(replication? [v any/c]) boolean?]{

Returns @racket[#t] if @racket[v] is a replication, @racket[#f] otherwise.
}

@defproc[(input [x name?] [y (non-empty-listof name?)]) input?]{

Returns an input over the channel @racket[x] to the names contained
in @racket[y].
}

@defproc[(input? [v any/c]) boolean?]{

Returns @racket[#t] if @racket[v] is an input, @racket[#f] otherwise.
}

@defproc[(output [x name?] [y (non-empty-listof name?)]) output?]{

Returns an output over the channel @racket[x] of the names contained
in @racket[y].
}

@defproc[(output? [v any/c]) boolean?]{

Returns @racket[#t] if @racket[v] is an output, @racket[#f] otherwise.
}

@defproc[(restriction [x name?] [p process?]) restriction?]{

Returns the restriction of the name @racket[x] over the process
@racket[p].
}

@defproc[(restriction? [v any/c]) boolean?]{

Returns @racket[#t] if @racket[v] is a restriction, @racket[#f]
otherwise.
}

@defproc[(composition [p process?] [q process?]) composition?]{

Returns the parallel composition of processes @racket[p] and
@racket[q].
}

@defproc[(composition? [v any/c]) boolean?]{

Returns @racket[#t] if @racket[v] is a composition, @racket[#f]
otherwise.
}

@defproc[(prefix [p process?] [q process?]) prefix?]{

Returns a process which has @racket[p] as prefix and @racket[q]
as continuation.
}

@defproc[(prefix? [v any/c]) boolean?]{

Returns @racket[#t] if @racket[v] is a prefix, @racket[#f] otherwise.
}

@defproc[(process? [v any/c]) boolean?]{

Returns @racket[#t] if @racket[v] is a process, @racket[#f] otherwise.
}

@defproc[(process-free-names [p process?]) (setof name?)]{

Returns a @racket[set] containing all the names that have a free
occurence in @racket[p].
}

@defproc[(process-bound-names [p process?]) (setof name?)]{

Returns a @racket[set] containing all the names that have a bound
occurence in @racket[p].
}

@defproc[(process-names [p process?]) (setof name?)]{

Returns a @racket[set] containing all the names that have an
occurence in @racket[p].
}

@defproc[(process-environments [p process?]
                               [srt sorting?])
         (setof environment?)]{

Returns a set containing all the environments where @racket[p] has a
chance of respecting @racket[srt].
}

@defproc[(process-respects? [p process?]
                            [srt sorting?])
         (or/c (non-empty-setof environment?) #f)]{

Returns @racket[#f] if @racket[p] doesn't respect @racket[srt], or a set
of valid environments if it does.
}

@defproc[(string->process [str string?]) process?]{

Returns the process obtained by parsing @racket[str].

Raises @racket[exn:fail:read] if @racket[str] cannot be parsed
correctly.
}

@defproc[(process->string [p process?]) string?]{

Returns a string representation of @racket[p].

The returned string can be passed to @racket[string->process] to
obtain a process which is @racket[equal?] to @racket[p].
}
