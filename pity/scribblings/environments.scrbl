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

@title[#:tag "environments"]{Environments}

@declare-exporting[pity]

Procedures to create and modify environments.

An environment is used to hold mappings from names to sorts when
typing a process.

@defproc[(environment) environment?]{

Returns an empty environment.

All environments are derived by adding mappings to the empty
environment.
}

@defproc[(environment? [v any/c]) boolean?]{

Returns @racket[#t] if @racket[v] is an environment, @racket[#f]
otherwise.
}

@defproc[(environment-ref [env environment?]
                          [n name?])
         (or/c sort? #f)]{

Returns the sort for @racket[n], or @racket[#f] if @racket[n] has no
sort in @racket[env].
}

@defproc[(environment-ref-multiple [env environment?]
                                   [n (listof name?)])
         (listof (or/c sort? #f))]{

Like @racket[environment-ref], but returns the sorts for all elements
of @racket[n].
}

@defproc[(environment-set [env environment?]
                          [n name?]
                          [s sort?])
         environment?]{

Returns a new environment which behaves as @racket[env], but maps
@racket[n] to @racket[s].

If a mapping for @racket[n] is already present in @racket[env], it is
replaced by the new one.
}

@defproc[(environment-set-multiple [env environment?]
                                   [n (listof name?)]
                                   [s (listof sort?)])
         environment?]{

Like @racket[environment-set], but the mappings to be added to @racket[env]
are taken from two lists.

If the lenghts of the lists don't match, the tail of the longest list is
ignored.
}

@defproc[(environment-remove [env environment?]
                             [n name?])
         environment?]{

Returns a new environment which behaves as @racket[env], except that any
mapping of @racket[n] is removed.
}

@defproc[(environment-remove-multiple [env environment?]
                                      [n (listof name?)])
         environment?]{

Like @racket[environment-remove], but removes the mappings to all
elements of @racket[n].
}

@defproc[(environment-domain [env environment?]) (setof name?)]{

Returns the set of names which have a mapping in @racket[env].
}

@defproc[(environment-compatible? [env environment?]
                                  [n name?]
                                  [s sort?])
         boolean?]{

Returns @racket[#t] if the mapping from @racket[n] to @racket[s] is
compatible with the mappings in @racket[env].}

@defproc[(string->environment [str string?]) environment?]{

Returns the environment obtained by parsing @racket[str].

Raises @racket[exn:fail] if @racket[str] cannot be parsed correctly.
}

@defproc[(environment->string [env environment?]) string?]{

Returns a string representation of @racket[env].
}
