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

@title[#:tag "misc"]{Miscellaneous}

@declare-exporting[pity]

Miscellaneous procedures.

@defproc[(list->set [lst list?]) set?]{

Returns a set containing all the items in @racket[lst].
}

@defproc[(display-list [lst list?]
                       [out output-port? (current-output-port)]
                       [#:separator separator any/c #\newline])
          void?]{

Like @racket[display-lines], except @racket[separator] is not printed
after the last element of @racket[lst].
}
