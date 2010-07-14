%{

open Name
open Term

%}

%token<string>   NAME
%token           NIL DOT COMMA PIPE BANG
%token           L_PAREN R_PAREN L_BRACKET R_BRACKET
%token           EOF

%start process
%type<Term.term> process

%%

process
    : subprocess_list                          { Term.Composition($1) }
    ;

subprocess_list
    : subprocess                               { [$1] }
    | subprocess PIPE subprocess_list          { $1::$3 }
    ;

subprocess
    : part                                     { $1 }
    | BANG subprocess                          { Term.Replication($2) }
    ;

part
    :
    | term                                     { $1 }
    | L_PAREN name R_PAREN part                { Term.Restriction($2, $4) }
    ;

term
    : action                                   { $1 }
    | action DOT term                          { Term.Prefix($1, $3) }
    ;

action
    : NIL                                      { Term.Nil }
    | name L_PAREN name_list R_PAREN           { Term.Input($1, $3) }
    | name L_BRACKET name_list R_BRACKET       { Term.Output($1, $3) }
    | L_PAREN process R_PAREN                  { $2 }
    ;

name_list
    : name                  { [$1] }
    | name COMMA name_list  { $1::$3 }
    ;

name
    : NAME  { Name.Name($1) }
    ;

%%
