open Printf
open Name

module Term = struct

    type term =
          Nil
        | Input of Name.name * Name.name list
        | Output of Name.name * Name.name list
        | Restriction of Name.name * term
        | Composition of term * term
        | Prefix of term * term

    let rec print = function
          Nil -> (
              printf "0"
          )
        | Input(x, y) -> (
              Name.print x;
              printf "%s" "(";
              Name.print_list y;
              printf "%s" ")"
          )
        | Output(x, y) -> (
              printf "%s" "!";
              Name.print x;
              printf "%s" "<";
              Name.print_list y;
              printf "%s" ">"
          )
        | Restriction(x, p) -> (
              printf "%s" "(v";
              Name.print x;
              printf "%s" ")(";
              print p;
              printf "%s" ")"
          )
        | Composition(p, q) -> (
              print p;
              printf "%s" "|";
              print q
          )
        | Prefix(p, q) -> (
              print p;
              printf "%s" ".";
              print q
          )

end
