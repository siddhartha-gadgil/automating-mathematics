+++
title = "Solving (but not proving?) Pappus"
date = 2021-04-19T06:53:09+05:30
draft = false
tags = []
categories = []
+++

Thanks to some very nice work done by Anand Tadipatri after he read the [previous post]({{< ref "/posts/proving-by-solving.md" >}}) on proving theorems using SMT solvers, we find that in a sense the theorem of Pappus can be __solved__ (but, so far at least, in some sense not __proved__) by __Z3__  &mdash; a happier conclusion than last time. I make this precise below, assuming the reader is familiar with the [previous post]({{< ref "/posts/proving-by-solving.md" >}}).
<!--more-->

Anand Tadipatri formulated in Z3 [Menelaus's Theorem](https://en.wikipedia.org/wiki/Menelaus%27s_theorem), a basic Euclidean geometry result. As usual, this was formulated as a _satisfiability problem_ contradicting the statement, so `unsat` (not satisfiable) as the answer means the result is true. When run Z3 instantly solved the satisfiability problem with `unsat` as the answer. He shared his code, which I checked ran instantly, and I am confident is correct.

But there was a twist to the tale. When I used the same setup in my code, Z3 failed to solve the problem (when running for about 10 minutes). Some experimentation revealed the crucial difference between the two programs &mdash; I was asking for a proof, rather than just an answer.

## Speed versus certainty

High-performance solvers use a huge collection of algorithms, which they choose and mix using complex heuristics to decide whether a collection of constraints is satisfiable. In addition, they can be asked for a _proof_ in case a problem is not satisfiable (i.e., a proof that the problem has no solution) or a _model_ &mdash; values for variables that satisfy the constraint &mdash; in case the problem is satisfiable.

Experiments showed that when asked for a proof, the choice of algorithms was different, either taking much longer (effectively not terminating), or explicitly giving up &mdash; in addition to `sat` (satisfiable) and `unsat` (not satisfiable), SMT solvers can give the outcome `unknown` (due to failure or timeout of the available algorithms).

Indeed, when the code for Menelaus's theorem was modified to ask for a proof, Z3 ran for a few seconds and returned `unknown` &mdash; presumably the system was forced to use an algorithm that returned a proof when the problem was not satisfiable, and this algorithm found the problem too hard.

## Pappus revisited

Based on the above, it was natural to try to ask Z3 whether the constraints corresponding to the Pappus theorem were satisfiable, without asking for a proof. Another change made, again based on the above experiments, was to not specify the _logic_ to be used.

When run in this way, Z3 solved the problem instantly (in 0.02 seconds). Thus, to the extent that Z3 can be trusted, we can readily check if problems of this complexity from Euclidean geometry, and presumably many other areas, are correct. Even without getting a proof this is valuable &mdash; at the least avoiding time and effort being spent on what is not true, and identifying related statements that are true.

## Still knot easy 

The unknotting problem, however, remained intractable. The translation of this problem has very large degree, so this is not surprising.

## Formulating problems in SMT

SMT solvers such as Z3 can be run from many languages (in case of Z3 we can use Python, C++, Java and other JVM languages such as Scala). But one nice way to run these, and especially to examine the problems being solved, is to use a standard format called __SMT2__ which all SMT solvers support (this can be run interactively or as a file from the command line).

We give below the SMT2 code for the Pappus problem. This is a language with syntax (following LISP/Scheme) that is easy for both machines and people to read.
Each statement is a so called __S-expression__ (symbolic expression), which is a list enclosed in parenthesis. Operators and functions come in the beginning, so we write, for example, `(+ 2 3)` for $2 + 3$ and `(= (+ 2 3) (+ 3 2))` for `$2 + 3 = 3 + 2$`. In general, an S-expression is a list, enclosed in parenthesis with entries either other S-expression or __atoms__, with atoms being integers, reals, strings, functions, operators etc.

Specifically, most of our statements are of one of two forms &mdash; declaring a variable using `declare-fun` (which can more generally be used to declare functions), or asserting conditions using a statement `(assert <expression>)` for a Boolean expression.

Here is the code for contradicting the Pappus theorem.

``` scheme
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

Incidentally, I have run Z3 in a few ways &mdash; using Python, using Scala via the Java API and using Scala to generate code in the SMT2 language (like the above code) and using the Z3 command line either programmatically or in a terminal. The interfaces in high-level languages are also pleasant and human readable. For instance, an extract from the Python code is below.

```python
def are_collinear(p, q, r):
    return ((q[1]-p[1])*(r[0]-p[0])==(r[1]-p[1])*(q[0]-p[0]))

menelaus_theorem = Implies( And( Not(are_collinear(A, B, C)), 
   are_collinear(D, E, F) ), 
   d(A, D) * d(B, E) * d(C, F) == d(D, B) * d(E, C) * d(F, A) )
```

__Final note:__ So far I have e-mailed posts unsolicited. In the future, if you want to be alerted, please join the [google group]({{< ref "/automating-mathematics-india.md" >}}) I have created for this and related stuff.
