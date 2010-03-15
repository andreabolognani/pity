open Printf
open Name
open Term;;

let test_term =
Term.Composition(
    Term.Restriction(
        Name.Name("z"),
        Term.Prefix(
            Term.Output(
                Name.Name("x"),
                [Name.Name("z")]
            ),
            Term.Prefix(
                Term.Input(
                    Name.Name("z"),
                    [Name.Name("a")]
                ),
                Term.Nil
            )
        )
    ),
    Term.Prefix(
        Term.Input(
            Name.Name("x"),
            [Name.Name("y")]
        ),
        Term.Prefix(
            Term.Output(
                Name.Name("y"),
                [Name.Name("b")]
            ),
            Term.Nil
        )
    )
)
in
    printf "%s" (Term.to_string test_term);
    print_endline ""
