#lang racket/base

(require "lens.rkt")

(provide
 &car
 &cdr)

(define &car (lens car (λ (s v) (cons v (cdr s)))))
(define &cdr (lens cdr (λ (s v) (cons (car s) v))))
