module Pulse2Rust.Rust.Syntax

open FStar.Compiler.Effect

type lit_int_width =
  | I8
  | I16
  | I32
  | I64

type lit_int = {
  lit_int_val : string;
  lit_int_signed : option bool;
  lit_int_width : option lit_int_width;
}

type lit =
  | Lit_int of lit_int
  | Lit_bool of bool
  | Lit_unit
  | Lit_string of string

type binop =
  | Add
  | Sub
  | Ne
  | Eq
  | Lt
  | Le
  | Gt
  | Ge

type unop =
  | Deref

type pat_ident = {
  pat_name : string;
  by_ref : bool;
  is_mut : bool;
}

type pat_tuple_struct = {
  pat_ts_path : string;
  pat_ts_elems : list pat;
}

and field_pat = {
  field_pat_name : string;
  field_pat_pat : pat;
}

and pat_struct = {
  pat_struct_path : string;
  pat_struct_fields : list field_pat;
}

and pat =
  | Pat_ident of pat_ident
  | Pat_tuple_struct of pat_tuple_struct
  | Pat_wild
  | Pat_lit of lit
  | Pat_struct of pat_struct

type expr =
  | Expr_binop of expr_bin
  | Expr_path of list string
  | Expr_call of expr_call
  | Expr_unary of expr_unary
  | Expr_assign of expr_assignment
  | Expr_block of list stmt
  | Expr_lit of lit
  | Expr_if of expr_if
  | Expr_while of expr_while
  | Expr_index of expr_index
  | Expr_repeat of expr_repeat
  | Expr_reference of expr_reference
  | Expr_match of expr_match
  | Expr_field of expr_field
  | Expr_struct of expr_struct

and expr_bin = {
  expr_bin_left : expr;
  expr_bin_op : binop;
  expr_bin_right : expr
}

and expr_unary = {
  expr_unary_op : unop;
  expr_unary_expr : expr
}

and expr_call = {
  expr_call_fn : expr;
  expr_call_args : list expr;
}

and expr_index = {
  expr_index_base : expr;
  expr_index_index : expr;
}

and expr_assignment = {
  expr_assignment_l : expr;
  expr_assignment_r : expr;
}

and expr_if = {
  expr_if_cond : expr;
  expr_if_then : list stmt;
  expr_if_else : option expr;  // only EBlock or Expr_if, if set
}

and expr_while = {
  expr_while_cond : expr;
  expr_while_body : list stmt;
}

and expr_repeat = {
  expr_repeat_elem : expr;
  expr_repeat_len : expr;
}

and expr_reference = {
  expr_reference_is_mut : bool;
  expr_reference_expr : expr
}

and arm = {
  arm_pat : pat;
  arm_body : expr
}

and expr_match = {
  expr_match_expr : expr;
  expr_match_arms : list arm;
}

and expr_field = {
  expr_field_base : expr;
  expr_field_member : string;
}

and expr_struct = {
  expr_struct_path : list string;
  expr_struct_fields : list field_val;
}

and field_val = {
  field_val_name : string;
  field_val_expr : expr;
}

and local_stmt = {
  local_stmt_pat : option pat;
  local_stmt_init : option expr;
}

and stmt =
  | Stmt_local of local_stmt
  | Stmt_expr of expr

type typ =
  | Typ_path of list typ_path_segment
  | Typ_reference of typ_reference
  | Typ_slice of typ
  | Typ_array of typ_array
  | Typ_unit
  | Typ_infer

and typ_reference = {
  typ_ref_mut : bool;
  typ_ref_typ : typ;
}

and typ_path_segment = {
  typ_path_segment_name : string;
  typ_path_segment_generic_args : list typ;
}

and typ_array = {
  typ_array_elem : typ;
  typ_array_len : expr;
}

type pat_typ = {
  pat_typ_pat : pat;
  pat_typ_typ : typ
}

type fn_arg =
  | Fn_arg_pat of pat_typ

type generic_param =
  | Generic_type_param of string

type fn_signature = {
  fn_name : string;
  fn_generics : list generic_param;
  fn_args : list fn_arg;
  fn_ret_t : typ;
}

type fn = {
  fn_sig : fn_signature;
  fn_body : list stmt;
}

type field_typ = {
  field_typ_name : string;
  field_typ_typ : typ;
}

type item_struct = {
  item_struct_name : string;
  item_struct_generics : list generic_param;
  item_struct_fields : list field_typ;
}

type item_type = {
  item_type_name : string;
  item_type_generics : list generic_param;
  item_type_typ : typ;
}

type enum_variant = {
  enum_variant_name : string;
  enum_variant_fields : list typ;
}

type item_enum = {
  item_enum_name : string;
  item_enum_generics : list generic_param;
  item_enum_variants : list enum_variant
}

type item_static = {
  item_static_name : string;
  item_static_typ  : typ;
  item_static_init : expr;
}

type item =
  | Item_fn of fn
  | Item_struct of item_struct
  | Item_type of item_type
  | Item_enum of item_enum
  | Item_static of item_static

type file = {
  file_name : string;
  file_items : list item;
}

val vec_new_fn : string
val panic_fn : string

val mk_scalar_typ (name:string) : typ
val mk_ref_typ (is_mut:bool) (t:typ) : typ
val mk_box_typ (t:typ) : typ
val mk_slice_typ (t:typ) : typ
val mk_vec_typ (t:typ) : typ
val mk_option_typ (t:typ) : typ
val mk_array_typ (t:typ) (len:expr) : typ
val mk_named_typ (s:string) (generic_args:list typ) : typ

val mk_expr_path_singl (s:string) : expr
val mk_expr_path (l:list string) : expr
val mk_lit_bool (b:bool) : expr
val mk_binop (e1:expr) (op:binop) (e2:expr) : expr
val mk_block_expr (l:list stmt) : expr
val mk_ref_read (r:expr) : expr
val mk_expr_index (base:expr) (index:expr) : expr
val mk_assign (l r:expr) : expr
val mk_ref_assign (l r:expr) : expr
val mk_call (head:expr) (args:list expr) : expr
val mk_if (cond:expr) (then_:list stmt) (else_:option expr) : expr  // else is Block or ExprIf
val mk_while (cond:expr) (body:list stmt) : expr
val mk_repeat (elem len:expr) : expr
val mk_reference_expr (is_mut:bool) (e:expr) : expr
val mk_pat_ident (path:string) : pat
val mk_pat_ts (path:string) (elems:list pat) : pat
val mk_pat_struct (path:string) (fields:list (string & pat)) : pat
val mk_arm (arm_pat:pat) (arm_body:expr) : arm
val mk_match (scrutinee:expr) (arms:list arm) : expr
val mk_expr_field (base:expr) (f:string) : expr
val mk_expr_struct (path:list string) (fields:list (string & expr)) : expr

val mk_local_stmt (name:option string) (is_mut:bool) (init:expr) : stmt
val mk_scalar_fn_arg (name:string) (t:typ) : fn_arg
val mk_ref_fn_arg (name:string) (is_mut:bool) (t:typ) : fn_arg
val mk_fn_signature (fn_name:string) (fn_generics:list string) (fn_args:list fn_arg) (fn_ret_t:typ) : fn_signature
val mk_fn (fn_sig:fn_signature) (fn_body:list stmt) : fn

val mk_item_struct (name:string) (generics:list string) (fields:list (string & typ))
  : item

val mk_item_type (name:string) (generics:list string) (t:typ) : item

val mk_item_enum (name:string) (generics:list string) (variants:list (string & list typ))
  : item

val mk_item_static (name:string) (t:typ) (init:expr) : item

val mk_file (name:string) (items:list item) : file
