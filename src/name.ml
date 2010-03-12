open Printf;;

module Name = struct

    type name =
          Name of string
    ;;

    let print_name = function
          Name(str) -> printf "%s" str
    ;;

    let rec print_name_list = function
          [] -> ()
        | name::rest -> print_name name; print_name_list rest

end;;
