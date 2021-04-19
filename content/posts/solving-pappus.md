+++
title = "Solving (but not proving?) Pappus"
date = 2021-04-19T06:53:09+05:30
draft = true
tags = []
categories = []
+++

Thanks to some nice work done by Anand Tadipatri after he read the [previous post]({{< ref "/posts/proving-by-solving.md" >}}) on proving theorems using SMT solvers, we find that in a sense the theorem of Pappus can be _solved_ (but (so far) in some sense not _proved_) by __Z3__  &mdash; a happier conclusion than last time. I make this precise below, assuming the reader is familiar with the [previous post]({{< ref "/posts/proving-by-solving.md" >}}).

Anand Tadipatri formulated [Menelaus's Theorem](https://en.wikipedia.org/wiki/Menelaus%27s_theorem), a basic Euclidean geometry result, in Z3, which almost instantly proved the result. He shared his code, which I checked ran instantly, and I am sure is correct.

But there was a twist to the tale. When I used the same setup in my code, Z3 failed to prove this (when running for about 10 minutes). Some experimentation revealed the crucial difference between the two programs &mdash; I was asking for a proof.

## Speed versus certainty

High-performance solvers use a huge collection of algorithms, which they choose and mix using complex heuristics to decide whether a collection of constraints is satisfiable. In addition, they can be asked for a _proof_ in case a problem is not satisfiable (of the claim that it is not satisfiable) or a _model_ &mdash; values for variables that satisfy the constraint &mdash; in case the problem is satisfiable.

Experiments showed that when asked for a proof, the choice of algorithms was different, either taking much longer (effectively not terminating), or explicitly giving up &mdash; in addition to `sat` (satisfiable) and `unsat` (not satisfiable), SMT solvers can give the outcome `unknown` (due to failure or timeout of the available algorithms).

Indeed, when the code for Menelaus's theorem was modified to ask for a proof, Z3 ran for a few seconds and returned `unknown` &mdash; presumably the system was forced to use an algorithm that returned a proof when the problem was not satisfiable, and this found the problem too hard.

## Pappus revisited

Based on the above, it was natural to try to ask Z3 whether the constraints corresponding to the Pappus theorem were satisfiable, without asking for a proof. Another change made, again based on the above experiments, was to not specify the _logic_ to be used.

When run in this way, Z3 solved the problem instantly (in 0.02 seconds). Thus, to the extent that Z3 can be trusted, we can readily check if problems of this complexity from Euclidean geometry, and presumably many other areas, are correct. Even without getting a proof this is valuable, at the least stopping time and effort being spent on what is true, and identifying related statements that are true.

## Still knot easy 

The unknotting problem, however, remained intractable. The translation of this problem has very large degree, so this is not surprising.

## Formulating problems in SMT

Here is the code

```scheme
(declare-fun u() Real)
(declare-fun v() Real)
(declare-fun Ax() Real)
(declare-fun Ay() Real)
(declare-fun U() Real)
(declare-fun V() Real)
(declare-fun Px() Real)
(declare-fun Py() Real)
(declare-fun Qx() Real)
(declare-fun Qy() Real)
(declare-fun Rx() Real)
(declare-fun Ry() Real)
(assert (= (* (- Py 0.0) (- (* Ax (+ U 1.0)) 1.0)) (* (- (* Ay (+ U 1.0)) 0.0) (- Px 1.0))))
(assert (= (* (- Py Ay) (- (+ 1.0 u) Ax)) (* (- 0.0 Ay) (- Px Ax))))
(assert (= (* (- Qy 0.0) (- (* Ax (+ (+ U V) 1.0)) 1.0)) (* (- (* Ay (+ (+ U V) 1.0)) 0.0) (- Qx 1.0))))
(assert (= (* (- Qy Ay) (- (+ (+ 1.0 u) v) Ax)) (* (- 0.0 Ay) (- Qx Ax))))
(assert (= (* (- Ry 0.0) (- (* Ax (+ (+ U V) 1.0)) (+ 1.0 u))) (* (- (* Ay (+ (+ U V) 1.0)) 0.0) (- Rx (+ 1.0 u)))))
(assert (= (* (- Ry (* Ay (+ U 1.0))) (- (+ (+ 1.0 u) v) (* Ax (+ U 1.0)))) (* (- 0.0 (* Ay (+ U 1.0))) (- Rx (* Ax (+ U 1.0))))))
(assert (> u 0.0))
(assert (> v 0.0))
(assert (> Ay 0.0))
(assert (> U 0.0))
(assert (> V 0.0))
(assert (not (= (* (- Qy Py) (- Rx Px)) (* (- Ry Py) (- Qx Px)))))
(check-sat)
```
