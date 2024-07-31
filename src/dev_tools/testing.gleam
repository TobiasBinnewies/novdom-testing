pub opaque type Callee {
    Callee(id: String)
}

pub fn create_callee() -> Callee {
    create_callee_js()
    |> Callee
}

pub fn call_callee(callee: Callee) {
    call_callee_js(callee.id)
}

pub fn callee_count(callee: Callee) -> Int {
    callee_count_js(callee.id)
}

@external(javascript, "../document_ffi.mjs", "component_in_document")
pub fn component_in_document(comp_id: String) -> Bool {
  panic as "Only available in JavaScript"
}

@external(javascript, "../document_ffi.mjs", "trigger_event")
pub fn trigger_event(comp_id: String, event: String) -> Nil {
  panic as "Only available in JavaScript"
}

@external(javascript, "../document_ffi.mjs", "create_callee")
fn create_callee_js() -> String {
  panic as "Only available in JavaScript"
}

@external(javascript, "../document_ffi.mjs", "call_callee")
fn call_callee_js(id: String) -> Nil {
  panic as "Only available in JavaScript"
}

@external(javascript, "../document_ffi.mjs", "callee_count")
fn callee_count_js(id: String) -> Int {
  panic as "Only available in JavaScript"
}