open Name
open Term
open Lexer
open Parser
open Lexing;;

let dump p = match p with
      _ -> print_string (Term.to_string p)

let _ =
    let lexbuf = (Lexing.from_channel stdin) in
        let result = (Parser.process Lexer.token lexbuf) in
            dump result;
            print_endline ""
