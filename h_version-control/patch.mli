open Common

type patch_raw = string list

(* parsing patch related *)
type patchinfo = (filename, fileinfo) Common.assoc
  and fileinfo = ((int * int) * hunk) list
  and hunk = string list 

(* the strings are without the mark *)
type patchline = 
  | Context of string
  | Minus of string
  | Plus of string

type stat = {
  mutable nb_minus: int;
  mutable nb_plus: int
}
  
val parse_patch: string list -> patchinfo
val parse_hunk: string list -> patchline list

val diffstat: patchinfo -> (Common.filename * stat) list
val diffstat_file: fileinfo -> stat

val string_of_stat: stat -> string

val relevant_part : filename * (int * int) -> patchinfo -> string
val filter_driver_sound : string list -> string list


val hunk_containing_string: string -> patchinfo -> hunk
val hunks_containing_string: string -> patchinfo -> hunk list

(* all minus lines involved in a patch *)
val modified_lines: fileinfo -> int list

(* generating patch *)
type edition_cmd = 
  | RemoveLines of int list
  | PreAddAt of int * string list
  | PostAddAt of int * string list

val generate_patch: 
  edition_cmd list -> filename_in_project:string -> Common.filename ->
  string list

(* debugging, using sexp *)
val string_of_patchinfo: patchinfo -> string
