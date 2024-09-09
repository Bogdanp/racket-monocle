#lang racket/base

(require data/monocle
         rackunit)

(define monocle-suite
  (test-suite
   "monocle"

   (test-suite
    "pair"

    (check-equal? (&car '(a . b)) 'a)
    (check-equal? (&cdr '(a . b)) 'b)
    (check-equal? ((lens-compose &car &cdr) '(a . (b . c))) 'b)
    (check-equal? ((lens-compose &car &cdr &cdr) '(a . (b . (c . d))) 'e)
                  '(a . (b . (e . d)))))

   (test-suite
    "list"

    (check-equal? ((&list-ref 2) '(1 2 3 4)) 3)
    (check-equal?
     ((lens-compose &car (&list-ref 1))
      '((a . b)
        (c . d)
        (e . f))
      'g)
     '((a . b)
       (g . d)
       (e . f))))

   (test-suite
    "hash"

    (check-equal?
     ((&hash-ref 'x)
      (hasheq 'a 10 'b 32 'x 64))
     64)

    (check-equal?
     ((lens-compose &car (&hash-ref 'x) &cdr)
      `(1 . ,(hasheq 'x `(1 . 2)))
      3)
     `(1 . ,(hasheq 'x `(3 . 2))))

    (check-equal?
     ((&hash-ref* 'a 'b 'c)
      (hasheq 'a (hasheq 'b (hasheq 'c 42))))
     42)

    (check-equal?
     (lens-update
      (&hash-ref* 'a 'b 'c)
      (hasheq 'a (hasheq 'b (hasheq 'c 42)))
      add1)
     (hasheq 'a (hasheq 'b (hasheq 'c 43)))))

   (test-suite
    "struct"

    (let ()
      (struct foo (x y)
        #:transparent)
      (define-struct-lenses foo)
      (check-equal? (&foo-x (foo 1 2)) 1)
      (check-equal? (&foo-y (foo 1 2)) 2)
      (check-equal?
       (&foo-x (foo 1 2) 3)
       (foo 3 2))
      (check-equal?
       ((lens-compose &car &foo-y)
        (foo 1 (cons 2 3))
        4)
       (foo 1 (cons 4 3)))))))

(module+ test
  (require rackunit/text-ui)
  (run-tests monocle-suite))
