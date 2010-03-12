open Printf;;

module Name = struct

    type name =
          Name of string
    ;;

    let print = function
          Name(str) -> printf "%s" str
    ;;

    let rec print_list = function
          [] -> ()
        | name::rest -> print name; print_list rest

end;;
