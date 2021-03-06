(*s: flag_parsing_php.ml *)
let verbose_parsing = ref true
let verbose_lexing = ref true
let verbose_visit = ref true
(*x: flag_parsing_php.ml *)
let cmdline_flags_verbose () = [
  "-no_verbose_parsing", Arg.Clear verbose_parsing , "  ";
  "-no_verbose_lexing", Arg.Clear verbose_lexing , "  ";
  "-no_verbose_visit", Arg.Clear verbose_visit , "  ";
]
(*x: flag_parsing_php.ml *)
let debug_lexer   = ref false
(*x: flag_parsing_php.ml *)
let cmdline_flags_debugging () = [
  "-debug_lexer",        Arg.Set  debug_lexer , " ";
]
(*x: flag_parsing_php.ml *)
let show_parsing_error = ref true
(*x: flag_parsing_php.ml *)
let short_open_tag = ref true
(*x: flag_parsing_php.ml *)
(*s: flag_parsing_php.ml pp related flags *)
let verbose_pp = ref false

let caching_parsing = ref false

(* in facebook context, we want xhp support by default *)
let xhp_builtin = ref true

(* Alternative way to get xhp by calling xhpize as a preprocessor.
 * Slower than builtin_xhp and have some issues where the comments
 * are removed, unless you use the experimental_merge_tokens_xhp
 * but which has some issues itself. 
 *)
let pp_default = ref (None: string option)
let xhp_command = "xhpize" 
let obsolete_merge_tokens_xhp = ref false


let cmdline_flags_pp () = [
  "-pp", Arg.String (fun s -> pp_default := Some s),
  " <cmd> optional preprocessor (e.g. xhpize)";
  "-verbose_pp", Arg.Set verbose_pp, 
  " ";
  (*s: other cmdline_flags_pp *)
  "-xhp", Arg.Set xhp_builtin,
  " parsing XHP constructs (default)";
  "-xhp_with_xhpize", Arg.Unit (fun () -> 
    xhp_builtin := false;
    pp_default := Some xhp_command),
  "  parsing XHP using xhpize as a preprocessor";
  "-no_xhp", Arg.Clear xhp_builtin,
  " ";
  (*e: other cmdline_flags_pp *)
]
(*e: flag_parsing_php.ml pp related flags *)
(*e: flag_parsing_php.ml *)
