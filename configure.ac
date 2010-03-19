AC_INIT([pity],[0.1.0])
AM_INIT_AUTOMAKE

AC_PROG_OCAML
if test "$OCAMLC" = "no"; then
	AC_MSG_ERROR([You must install the OCaml compiler])
fi

AC_PROG_OCAMLYACC
if test "$OCAMLYACC" = "no"; then
	AC_MSG_ERROR([You must install the OCaml parser generator])
fi

AC_PROG_OCAMLLEX
if test "$OCAMLLEX" = "no"; then
	AC_MSG_ERROR([You must install the OCaml lexer generator])
fi

AC_PROG_FINDLIB
if test "$OCAMLFIND" = "no"; then
	AC_MSG_ERROR([You must install the OCaml findlib])
fi

AC_CONFIG_FILES([Makefile
                 pity/META.pity
                 pity/Makefile
                 tests/Makefile
                 src/Makefile])
AC_OUTPUT
