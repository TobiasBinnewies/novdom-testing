import jsdom from "jsdom"
import fs from "fs"
import { get } from "http"

if (typeof window === "undefined") {
  const html = fs.readFileSync("build/.novdom/index.html", "utf8")
  const dom = new jsdom.JSDOM(html)
  global.window = dom.window
  global.document = dom.window.document
  global.callees = new Map() // id: String --> count: Int
}

function create_id() {
  return Date.now().toString(36) + Math.random().toString(36).substring(2, 12).padStart(12, 0)
}

function app_element() {
  return document.getElementById("_app_")
}

function get_element(comp_id) {
  const elem = app_element().querySelector("#" + comp_id)
  if (!elem) {
    throw new Error("Component not found: " + comp_id)
  }
  return elem
}

export function component_in_document(comp_id) {
  const elem = get_element(comp_id)
  return !!elem && elem.hidden === false
}

export function trigger_event(comp_id, event_name) {
  get_element(comp_id).dispatchEvent(new window.Event(event_name))
}

export function create_callee() {
  const id = create_id()
  callees.set(id, 0)
  return id
}

export function call_callee(id) {
  const count = callees.get(id)
  callees.set(id, count + 1)
}

export function callee_count(id) {
  return callees.get(id)
}