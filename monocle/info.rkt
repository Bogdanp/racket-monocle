#lang info

(define collection "data")
(define deps
  '("base"
    "monocle-lib"))
(define build-deps
  '("racket-doc"
    "sandbox-lib"
    "scribble-lib"))
(define implies
  '("monocle-lib"))
(define scribblings
  '(("monocle/scribblings/monocle.scrbl")))
