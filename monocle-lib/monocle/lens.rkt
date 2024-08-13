#lang racket/base

(require racket/contract/base)

(provide
 (contract-out
  [lens-compose (-> lens? lens? lens? ... lens?)]
  [lens-thread (-> lens? lens? lens? ... lens?)]
  [lens-set (-> lens? any/c any/c any/c)]
  [lens-update (-> lens? any/c (-> any/c any/c) any/c)]
  [struct lens
    ([getter (procedure-arity-includes/c 1)]
     [setter (procedure-arity-includes/c 2)])]))

(struct lens (getter setter)
  #:property prop:procedure
  (struct-field-index getter))

(define lens-compose
  (case-lambda
    [(a b)
     (lens
      (λ (v) (a (b v)))
      (λ (s v) (lens-set b s (lens-set a (b s) v))))]
    [(a b . args)
     (lens-compose a (apply lens-compose b args))]))

(define lens-thread
  (case-lambda
    [(a b)
     (lens
      (λ (v) (b (a v)))
      (λ (s v) (lens-set a s (lens-set b (a s) v))))]
    [(a b . args)
     (lens-thread a (apply lens-thread b args))]))

(define (lens-set l s v)
  ((lens-setter l) s v))

(define (lens-update l s proc)
  (lens-set l s (proc (l s))))
