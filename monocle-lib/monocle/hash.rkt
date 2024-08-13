#lang racket/base

(require "lens.rkt")

(provide
 &hash-ref
 &hash-ref*)

(define (&hash-ref k)
  (lens
   (λ (s)
     (hash-ref s k))
   (λ (s v)
     (hash-set s k v))))

(define &hash-ref*
  (case-lambda
    [(k) (&hash-ref k)]
    [(k1 k2 . args)
     (lens-thread
      (&hash-ref k1)
      (apply &hash-ref* k2 args))]))
