#lang racket/base

(require review/ext
         syntax/parse/pre)

#|review: ignore|#

(provide
 should-review-syntax?
 review-syntax)

(define (should-review-syntax? stx)
  (syntax-case stx (define-struct-lenses)
    [(define-struct-lenses . _rest) #t]
    [_ #f]))

(define-syntax-class define-struct-lenses-form
  #:datum-literals (define-struct-lenses)
  (pattern (define-struct-lenses struct-id:id)))

(define (review-syntax stx)
  (syntax-parse stx
    [d:define-struct-lenses-form #'d]
    [_ (track-error stx "expected a data/monocle form")]))
