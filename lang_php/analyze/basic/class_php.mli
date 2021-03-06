
(* __construct *)
val constructor_name: string 

val static_new_or_extends_of_ast: 
  Ast_entity_php.id_ast -> Ast_php.name list

val get_public_or_protected_vars_of_class: 
  Ast_php.class_def -> Ast_php.dname list

val get_constructor:
  Ast_php.class_def -> Ast_php.method_def

val class_variables_reorder_first:
  Ast_php.class_def -> Ast_php.class_def

val is_static_method:
  Ast_php.method_def -> bool
