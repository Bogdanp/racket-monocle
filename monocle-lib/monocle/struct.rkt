#lang racket/base

(require (for-syntax racket/base
                     racket/match
                     racket/struct-info
                     racket/syntax
                     syntax/parse/pre)
         "lens.rkt")

(provide
 define-struct-lenses)

(define-syntax (define-struct-lenses stx)
  (syntax-parse stx
    [(_ struct-id:id)
     (match-define `(,_struct-type ,_constructor ,_predicate ,accessors ,_setters ,_)
       (extract-struct-info (syntax-local-value #'struct-id)))
     (define field-ids
       (struct-field-info-list (syntax-local-value #'struct-id)))
     (with-syntax ([(accessor ...) accessors]
                   [(field-id ...)
                    (for/list ([id (in-list field-ids)])
                      (format-id #'struct-id "~a" id))]
                   [(lens-id ...)
                    (for/list ([accessor-stx (in-list accessors)])
                      (format-id stx "&~a" accessor-stx))])
       #'(begin
           (define lens-id
             (lens
              accessor
              (λ (s v)
                (struct-copy struct-id s [field-id v])))) ...))]))
