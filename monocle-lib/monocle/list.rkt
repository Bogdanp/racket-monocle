#lang racket/base

(require racket/list
         "lens.rkt")

(provide
 &list-ref
 &findf)

(define (&list-ref idx)
  (lens
   (λ (s)
     (list-ref s idx))
   (λ (s v)
     (append
      (take s idx)
      (list v)
      (drop s (add1 idx))))))

(define (&findf proc)
  (lens
   (λ (s) (findf proc s))
   (λ (s v)
     (for/fold ([xs null]
                [replaced? #f]
                #:result (reverse xs))
               ([x (in-list s)])
       (if (and (not replaced?) (proc x))
           (values (cons v xs) #t)
           (values (cons x xs) replaced?))))))
