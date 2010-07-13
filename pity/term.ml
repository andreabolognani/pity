open Name

type term =
      Nil
    | Input of Name.name * Name.name list
    | Output of Name.name * Name.name list
    | Restriction of Name.name * term
    | Composition of term * term
    | Prefix of term * term

let rec to_string = function
      Nil -> (
          "0"
      )
    | Input(x, y) -> (
          (Name.to_string x) ^
          "(" ^
          (Name.list_to_string y) ^
          ")"
      )
    | Output(x, y) -> (
          (Name.to_string x) ^
          "<" ^
          (Name.list_to_string y) ^
          ">"
      )
    | Restriction(x, p) -> (
          "(" ^
          (Name.to_string x) ^
          ")(" ^
          (to_string p) ^
          ")"
      )
    | Composition(p, q) -> (
          "(" ^
          (to_string p) ^
          ")|(" ^
          (to_string q) ^
          ")"
      )
    | Prefix(p, q) -> (
          "(" ^
          (to_string p) ^
          ").(" ^
          (to_string q) ^
          ")"
      )
