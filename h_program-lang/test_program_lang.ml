open Common

module Db = Database_code

(*****************************************************************************)
(* Helpers *)
(*****************************************************************************)

(*****************************************************************************)
(* Subsystem testing *)
(*****************************************************************************)

let test_load_light_db file = 
  let _db = Db.load_database file in
  ()

let test_big_grep file =
  let db = Db.load_database file in
  let entities = 
    Db.files_and_dirs_and_sorted_entities_for_completion 
      ~threshold_too_many_entities:300000
      db in
  let idx = Big_grep.build_index entities in
  let query = "old_le" in
  let top_n = 10 in

  let xs = Big_grep.top_n_search ~top_n ~query idx in
  xs +> List.iter (fun e ->
    let json = Db.json_of_entity e in
    let s = Json_io.string_of_json json in
    pr2 s
  );

  (* naive search *)
  let xs = Big_grep.naive_top_n_search ~top_n ~query entities in
  xs +> List.iter (fun e ->
    let json = Db.json_of_entity e in
    let s = Json_io.string_of_json json in
    pr2 s
  );

  ()



(*****************************************************************************)
(* Main entry for Arg *)
(*****************************************************************************)

let actions () = [
    "-test_load_db",  " <file>",
    Common.mk_action_1_arg test_load_light_db;

  "-test_big_grep", " <file>",
    Common.mk_action_1_arg test_big_grep;

]
