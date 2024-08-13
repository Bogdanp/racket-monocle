#lang scribble/manual

@(require scribble/example
          (for-label data/monocle
                     racket/base
                     racket/contract/base))

@title{Monocle: a small lense library}
@author[(author+email "Bogdan Popa" "bogdan@defn.io")]

@(define lens-anchor
  (link "https://docs.racket-lang.org/lens/index.html" "the lens package"))

@(define ev
   (let ([ev (make-base-eval)])
     (begin0 ev
       (ev '(require data/monocle)))))

This package provides a lense implementation with minimal dependencies
and a focus on ergonomics. For a more full-featured implementation see
@|lens-anchor|.

By convention, lense ids are prefixed by an @tt{&} character.

@section{Reference}
@defmodule[data/monocle]

This module reprovides all the bindings defined in the modules
documented below.

@subsection{Operators}
@defmodule[data/monocle/lens]

@defstruct[lens ([getter (procedure-arity-includes/c 1)]
                 [setter (procedure-arity-includes/c 2)])]{

  The structure for lenses. Instances of this structure are applicable;
  applying a lens to a value is equivalent to applying its getter to
  that value.
}

@defproc[(lens-set [l lens?]
                   [s any/c]
                   [v any/c]) any/c]{

  Replaces the focus of @racket[l] in @racket[s] with @racket[v].

  @examples[
    #:eval ev
    (lens-set &car '(a . b) 'c)
  ]
}

@defproc[(lens-update [l lens?]
                      [s any/c]
                      [p (-> any/c any/c)]) any/c]{

  Replaces the focus of @racket[l] in @racket[s] by applying
  @racket[p] to the focused value.

  @examples[
    #:eval ev
    (lens-update &car '(1 . 2) add1)
  ]
}

@defproc[(lens-compose [a lens?]
                       [b lens?] ...+) lens?]{

  Composes two or more lenses from right to left.

  @examples[
    #:eval ev
    ((lens-compose &car &cdr) '(a b c))
    (lens-set (lens-compose &car &cdr) '(a b c) 'd)
  ]
}

@defproc[(lens-thread [a lens?]
                      [b lens?] ...+) lens?]{

  Composes two or more lenses from left to right.

  @examples[
    #:eval ev
    ((lens-thread &cdr &car) '(a b c))
    (lens-set (lens-thread &cdr &car) '(a b c) 'd)
  ]
}

@subsection{Lenses for Pairs}
@defmodule[data/monocle/pair]

@defthing[&car lens?]{
  A lens that focuses on the @racket[car] of a pair.
}

@defthing[&cdr lens?]{
  A lens that focuses on the @racket[cdr] of a pair.
}

@subsection{Lenses for Lists}
@defmodule[data/monocle/list]

@defproc[(&list-ref [idx exact-nonnegative-integer?]) lens?]{
  Returns a lens that focuses on the @racket[idx]th element of a list.
}

@defproc[(&findf [pred (-> any/c boolean?)]) lens?]{
  Returns a lens that focuses on the first element of a list that
  matches @racket[pred].
}

@subsection{Lenses for Hashes}
@defmodule[data/monocle/hash]

@defproc[(&hash-ref [k any/c]) lens?]{
  Returns a lens that focuses on the element at @racket[k] of a hash.
}

@defproc[(&hash-ref* [k any/c] ...+) lens?]{
  Returns a lens by threading a series of @racket[&hash-ref] lenses for
  every given @racket[k]. Use this lens factory to access and update
  deeply-nested hashes.

  @examples[
    #:eval ev
    ((&hash-ref* 'a 'b 'c)
     (hasheq 'a (hasheq 'b (hasheq 'c 42))))
    (lens-update
     (&hash-ref* 'a 'b 'c)
     (hasheq 'a (hasheq 'b (hasheq 'c 42)))
     add1)
  ]
}

@subsection{Lenses for Structs}
@defmodule[data/monocle/struct]

@defform[(define-struct-lenses struct-id)]{
  Defines a lens for every field belonging to @racket[struct-id] by
  prepending the field's accessor id with an @tt{&} character.

  @examples[
    #:eval ev
    (struct foo (x y) #:transparent)
    (define-struct-lenses foo)
    (&foo-x (foo 1 2))
    (lens-set &foo-x (foo 1 2) 3)
  ]
}
