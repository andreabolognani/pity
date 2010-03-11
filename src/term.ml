open Printf;;
open Name;;

type term =
      Input of name * name list
    | Output of name * name list
    | Restriction of name * term
    | Parallelization of term * term
    | Concatenation of term * term
;;

let rec print_term = function
      Output(name, name_list) -> (
          printf "%s" "!";
          print_name name;
          printf "%s" "<";
          print_name_list name_list;
          printf "%s" ">";
      )
    | _ -> printf "%s" "NOT SUPPORTED YET"
;;
