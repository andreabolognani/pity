open Printf
open Name

module Term = struct

    type term =
          Input of Name.name * Name.name list
        | Output of Name.name * Name.name list
        | Restriction of Name.name * term
        | Parallelization of term * term
        | Concatenation of term * term

    let rec print = function
          Output(name, name_list) -> (
              printf "%s" "!";
              Name.print name;
              printf "%s" "<";
              Name.print_list name_list;
              printf "%s" ">";
          )
        | _ -> printf "%s" "NOT SUPPORTED YET"

end
