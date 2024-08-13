#lang info

(define license 'BSD-3-Clause)
(define collection "data")
(define deps
  '("base"
    "review"))
(define review-exts
  '((data/monocle/review should-review-syntax? review-syntax)))
