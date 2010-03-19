type name =
      Name of string

let to_string = function
      Name(x) -> x

let rec list_to_string = function
      [] -> (
          ""
      )
    | [x] -> (
          (to_string x)
      )
    | x::y -> (
          (to_string x) ^
          "," ^
          (list_to_string y)
      )
