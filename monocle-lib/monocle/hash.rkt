#lang racket/base

(require "lens.rkt")

(provide
 &hash-ref
 &hash-ref*
 current-hash-maker
 &opt-hash-ref
 &opt-hash-ref*)

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

(define current-hash-maker
  (make-parameter hasheq))

(define (&opt-hash-ref k)
  (lens
   (λ (s)
     (and s (hash-ref s k #f)))
   (λ (s v)
     (hash-set (or s ((current-hash-maker))) k v))))

(define &opt-hash-ref*
  (case-lambda
    [(k) (&opt-hash-ref k)]
    [(k1 k2 . args)
     (lens-thread
      (&opt-hash-ref k1)
      (apply &opt-hash-ref* k2 args))]))
