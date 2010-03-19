%{

open Name
open Term

%}

%token<string>   NAME
%token           NIL VU DOT COMMA PIPE BANG
%token           L_PAREN R_PAREN L_BRACKET R_BRACKET
%token           EOF

%start term
%type<Term.term> term

%%

term
    : NIL                                      { Term.Nil }
    | L_PAREN term R_PAREN                     { $2 }
    | name L_PAREN name_list R_PAREN           { Term.Input($1, $3) }
    | BANG name L_BRACKET name_list R_BRACKET  { Term.Output($2, $4) }
    | L_PAREN VU name R_PAREN term             { Term.Restriction($3, $5) }
    ;

name_list
    : name                  { [$1] }
    | name COMMA name_list  { $1::$3 }
    ;

name
    : NAME  { Name.Name($1) }
    ;

%%
