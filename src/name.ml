open Printf;;

type name =
      Name of string
;;

let print_name name = match name with
      Name(str) -> printf "%s" str
;;

let rec print_name_list name_list = match name_list with
      [] -> ()
    | name::rest -> print_name name; print_name_list rest
;;
