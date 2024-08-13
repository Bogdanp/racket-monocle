#lang racket/base

(define-syntax-rule (reprovide mod ...)
  (begin
    (require mod ...)
    (provide (all-from-out mod ...))))

(reprovide
 "monocle/hash.rkt"
 "monocle/lens.rkt"
 "monocle/list.rkt"
 "monocle/pair.rkt"
 "monocle/struct.rkt")
