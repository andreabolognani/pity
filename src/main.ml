open Name
open Term
open Lexer
open Parser
open Lexing;;

let dump p = match p with
      _ -> print_string (Term.to_string p)

let rec repl () =
    try
        let lexbuf = (Lexing.from_channel stdin) in
            let result = (Parser.process Lexer.token lexbuf) in
                dump result;
                print_endline "";
                repl ()
    with
          Lexer.UnknownSymbol(sym) -> (
              print_endline ("ERR: Unknown symbol " ^ sym);
              repl ()
          )
        | Parsing.Parse_error -> (
              print_endline "ERR: Syntax error";
              repl ()
          )
        | Lexer.EndOfInput -> ()

let _ =
    repl ()
