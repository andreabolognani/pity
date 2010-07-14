{

open Printf
open Lexing
open Parser

exception UnknownSymbol of string

}

let letter = ['a'-'z' 'A'-'Z']
let digit  = ['0'-'9']
let name   = letter (letter | digit)*

rule token = parse
      name   { NAME(Lexing.lexeme lexbuf) }
    | "0"    { NIL }
    | "."    { DOT }
    | ","    { COMMA }
    | "|"    { PIPE }
    | "!"    { BANG }
    | "("    { L_PAREN }
    | ")"    { R_PAREN }
    | "<"    { L_BRACKET }
    | ">"    { R_BRACKET }
    | "\n"   { EOF }
    | eof    { EOF }
    | _      { raise (UnknownSymbol(Lexing.lexeme lexbuf)) }
