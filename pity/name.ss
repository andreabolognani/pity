(module name scheme

 (require scheme/match)

 (define-struct name (s))

 (define (name->string value)
  (match value
   [(name a) a]))

 (define (name-list->string lst)
  (string-join (map (lambda (n) (name->string n)) lst) ","))

 (provide name name? name->string name-list->string))