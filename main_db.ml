open Common

open Ast_php

module Ast = Ast_php
module Db = Database_php
module V = Visitor_php

(*****************************************************************************)
(* Purpose *)
(*****************************************************************************)

(*****************************************************************************)
(* Flags *)
(*****************************************************************************)

(* In addition to flags that can be tweaked via -xxx options (cf the
 * full list of options in the "the options" section below), this 
 * program also depends on external files ?
 *)

let metapath = ref "/tmp/pfff_db"


(* for build_db *)
let phase = ref Database_php_build.max_phase

(* action mode *)
let action = ref ""

(*****************************************************************************)
(* Some  debugging functions *)
(*****************************************************************************)

(*****************************************************************************)
(* Helpers *)
(*****************************************************************************)

(*****************************************************************************)
(* Main action, build the database *)
(*****************************************************************************)

let main_action xs = 
  match xs with
  | [dir] -> 

      let dir = Common.realpath dir |> Common.chop_dirsymbol in
      let prj = Database_php.Project (dir, None) in
      let prj = Database_php.normalize_project prj in 

      let db = 
        Database_php_build.create_db
          ~db_support:(Database_php.Disk !metapath)
          ~phase:!phase
          prj 
      in
      Database_php_build.index_db_method db;

      Database_php.close_db db;
      ()
  | x::y::ys ->
      raise Todo

  | [] -> raise Impossible




(*****************************************************************************)
(* Extra actions *)
(*****************************************************************************)

let pfff_extra_actions () = [

]

(*****************************************************************************)
(* The options *)
(*****************************************************************************)

let all_actions () = 
  pfff_extra_actions() ++
  Database_php_build.actions() ++
  []

let options () = 
  [
    "-metapath", Arg.Set_string metapath, 
    "<dir> (default=" ^ !metapath ^ ")";
    "-phase", Arg.Set_int phase,
    " <phase number>";
  ] ++
  Flag_parsing_php.cmdline_flags_pp () ++
  Common.options_of_actions action (all_actions()) ++
  Flag_parsing_php.cmdline_flags_verbose () ++
  Flag_parsing_php.cmdline_flags_debugging () ++
  Common.cmdline_flags_devel () ++
  Common.cmdline_flags_verbose () ++
  Common.cmdline_flags_other () ++
  [
    "-version",   Arg.Unit (fun () -> 
      pr2 (spf "pfff db (console) version: %s" Config.version);
      exit 0;
    ), 
    "  guess what";

    (* this can not be factorized in Common *)
    "-date",   Arg.Unit (fun () -> 
      pr2 "version: $Date: 2008/10/26 00:44:57 $";
      raise (Common.UnixExit 0)
    ), 
    "   guess what";
  ] ++
  []

(*****************************************************************************)
(* Main entry point *)
(*****************************************************************************)

let main () = 

  Common_extra.set_link();
  (* let argv = Features.Distribution.mpi_adjust_argv Sys.argv in *)
  Database_php_storage.set_link();

  let usage_msg = 
    "Usage: " ^ basename Sys.argv.(0) ^ 
      " [options] <file or dir> " ^ "\n" ^ "Options are:"
  in
  (* does side effect on many global flags *)
  let args = Common.parse_options (options()) usage_msg Sys.argv in

  (* must be done after Arg.parse, because Common.profile is set by it *)
  Common.profile_code "Main total" (fun () -> 
    
    (match args with
    
    (* --------------------------------------------------------- *)
    (* actions, useful to debug subpart *)
    (* --------------------------------------------------------- *)
    | xs when List.mem !action (Common.action_list (all_actions())) -> 
        Common.do_action !action xs (all_actions())

    | _ when not (Common.null_string !action) -> 
        failwith ("unrecognized action or wrong params: " ^ !action)

    (* --------------------------------------------------------- *)
    (* main entry *)
    (* --------------------------------------------------------- *)
    | x::xs -> 
        main_action (x::xs)

    (* --------------------------------------------------------- *)
    (* empty entry *)
    (* --------------------------------------------------------- *)
    | [] -> 
        Common.usage usage_msg (options()); 
        failwith "too few arguments"
    )
  )

(*****************************************************************************)
let _ =
  Common.main_boilerplate (fun () -> 
    main ();
  )
