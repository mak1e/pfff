open Common 

(* Yoann Padioleau
 *
 * Copyright (C) 2010 Facebook
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation, with the
 * special exception on linking described in file license.txt.
 * 
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
 * license.txt for more details.
 *)

(*****************************************************************************)
(* Prelude *)
(*****************************************************************************)

(*****************************************************************************)
(* Types *)
(*****************************************************************************)

(* see also dircolors.el and LFS *)
type file_type = 
  | PL of pl_type
  | Obj  of string (* .o, .a, .aux, .bak, etc *)
  | Binary of string
  | Text of string (* tex, txt, readme, noweb, org, etc *)
  | Doc  of string (* ps, pdf *)
  | Media of media_type
  | Archive of string (* tgz, rpm, etc *)
  | Other of string

 and pl_type = 
  | ML of string  (* mli, ml, mly, mll *)
  | Haskell of string
  | Makefile
  | Script of string (* sh, csh, awk, sed, etc *)
  | C | Cplusplus | Java | Csharp
  | Elisp
  | Perl | Python | Ruby
  | Erlang
  | Web of webpl_type
  | Asm
  | Thrift

    and webpl_type = 
      | Php of string (* php or phpt or script *)
      | Js
      | Css
      | Html | Xml | Json
      | Sql

 and media_type =
   | Sound of string
   | Picture of string
   | Video of string

(*****************************************************************************)
(* Main entry point *)
(*****************************************************************************)

let file_type_of_file2 file = 
  let (d,b,e) = Common.dbe_of_filename_noext_ok file in
  match e with

(* expensive ? *)
(* todo:
  | _ when b =~ ".md5sum_.*" -> Obj ("syncweb")
  | _ when b =~ "Makefile.*" -> PL Makefile
*)

  | "ml" | "mli" 
  | "mly" | "mll" 
      -> PL (ML e)
  | "mlp" (* used in emacs source *)
      -> PL (ML e)

  | "lml" (* linear ML *)
      -> PL (ML e)

  | "hs" | "lhs" -> PL (Haskell e)
  | "erl" -> PL Erlang

  (* todo detect false C file, look for "Mode: Objective-C++" string in file ?
   * can also be a c++, use Parser_cplusplus.is_problably_cplusplus_file 
   *)
  | "c" -> PL C
  | "h" -> PL C
  (* todo? have a PL of xxx_kind * pl_kind ?  *)
  | "y" | "l" -> PL C 

  | "hpp" -> PL Cplusplus | "hxx" -> PL Cplusplus | "hh" -> PL Cplusplus
  | "cpp" -> PL Cplusplus | "C" -> PL Cplusplus
  | "cc" -> PL Cplusplus  | "cxx" -> PL Cplusplus

  | "java" -> PL Java
  | "cs" -> PL Csharp

  | "thrift" -> PL Thrift

  | "el" -> PL Elisp
  | "pl" | "perl" -> PL Perl (* could be prolog too *)
  | "py" -> PL Python
  | "rb" -> PL Ruby
 

  | "s" | "S" | "asm" -> PL Asm

  | "sh" -> PL (Script e)

  | "php" | "phpt" -> PL (Web (Php e))
  | "css" -> PL (Web Css)
  | "js" -> PL (Web Js)
  | "html" | "htm" -> PL (Web Html)
  | "xml" -> PL (Web Xml)
  | "json" -> PL (Web Json)
  | "sql" -> PL (Web Sql)
  | "sqlite" -> PL (Web Sql)

  (* facebook: sqlshim files *)
  | "sql3" -> PL (Web Sql)

  | "png" | "jpg" | "JPG" | "gif" | "tiff" -> Media (Picture e)
  | "xcf" | "xpm" -> Media (Picture e)
  | "icns" | "icon" | "ico" -> Media (Picture e)
  | "ttf" | "font"  -> Media (Picture e)

  | "swf" -> Media (Picture e)


  | "ps" | "pdf" -> Doc e
  | "ppt" -> Doc e

  | "tex" | "texi" -> Text e
  | "txt" | "doc" -> Text e
  | "nw" | "web" -> Text e

  | "org" 
  | "md" 
    -> Text e

  | "rtf" -> Text e

  | "cmi" | "cmo" | "cmx" | "cma" | "cmxa" 
  | "annot"
  | "o" | "a"
  | "pyc" 
  | "log"
  | "toc" | "brf"  
  | "out" | "output"
      -> Obj e

  | "msi" 
      -> Obj e

  | "po"  | "pot"
  | "gmo"
      -> Obj e

  (* facebook fbcode stuff *)
  | "apcarc"  | "serialized" | "wsdl" | "dat"  | "train"
     ->
      Obj e


  (* pad specific, cached git blame info *)
  | "git_annot" ->
      Obj e 

  | "byte" | "top" -> Binary e

  | "tar" -> Archive e
  | "tgz" -> Archive e
  | "jar" -> Archive e

  | "bz2" -> Archive e
  | "gz" -> Archive e
  | "rar" -> Archive e
  | "zip" -> Archive e


  | "exe" -> Binary e

  | "mk" -> PL Makefile

  | _ when Common.is_executable file -> Binary e

  | _ when b = "Makefile" -> PL Makefile

  (* facebook *)
  | _ when b = "TAGS" -> Binary e

  | _ when b = "TARGETS" -> PL Makefile
  | _ when b = ".depend" -> Obj "depend"

  | _ when Common.filesize file > 300_000 ->
      Obj e
  | _ -> Other e

let file_type_of_file a = 
  Common.profile_code "file_type_of_file" (fun () -> file_type_of_file2 a)



(*****************************************************************************)
(* Misc *)
(*****************************************************************************)

let is_textual_file file =
  match file_type_of_file file with
  (* if this contains weird code then pfff_visual crash *)
  | PL (Web Sql) -> false

  | PL _ 
  | Text _ -> true
  | _ -> false

let webpl_type_of_file file = 
  match file_type_of_file file with
  | PL (Web x) -> Some x
  | _ -> None


let detect_pl_of_file file = 
  raise Todo

 

let string_of_pl x = 
  raise Todo
(*
  | C -> "c"
  | Cplusplus -> "c++"
  | Java -> "java"

  | Web _ -> raise Todo
*)

