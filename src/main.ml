open Name
open Term;;

let test_term = Term.Output(Name.Name("x"), [Name.Name("y")])
in
    Term.print test_term;
    print_endline ""
