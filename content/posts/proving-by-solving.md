+++
title = "Knot so easy: Mathematical Proofs from High-performance Solvers?"
date = 2021-04-14T12:24:23+05:30
draft = false
tags = []
categories = []
+++

Computers are able to solve an increasing range of problems, many of which were believed not long ago to require human intelligence. Yet
there are fundamental limitations to what problems can be solved algorithmically, some known and other conjectured. By results of G&ouml;del, Turing, Church and others we know, for instance, there is no computer program that given a mathematical statement as input, either gives a proof or (correctly) says that the statement is false.

Indeed, we cannot algorithmically solve even a seemingly simple class of problems: deciding whether a so called [Diophantine Equation](https://en.wikipedia.org/wiki/Diophantine_equation), has a solution. A Diophantine equation is a polynomial equation with integer coefficients, such as `$3n^2 + 7m^2 = r^3$`, with solutions being _integers_ corresponding to the variables ($n$, $m$ and $r$ in the example) which satisfy the equation. For instance the Diophantine equation `$n^2 = 2$` has no solution even though as an equation over real numbers it has the solution `$n= \sqrt{2}$`. As a result of combined work of Martin Davis, Yuri Matiyasevich, Hilary Putnam and Julia Robinson during the 1950s and 1960s, there is no algorithm (i.e., computer program) to which we can input the coefficients of a Diophantine equation and which will tell us (correctly) whether the equation has integral solutions.

Yet, the above results should not be over-interpreted to say that proofs cannot be found by programs. Indeed if we turn from numbers to the other classical source of mathematics &ndash; Euclidean geometry, the situation is different. In the 1950s, Tarski proved that whether polynomial equations (and inequations) have solutions that are real numbers __is__ decidable. Using coordinate geometry, statements in Euclidean geometry can be translated to such problems, and so are algorithmically decidable. Tarski's algorithm has been greatly improved, and algorithms of a more algebraic nature have also been developed, improved and implemented. Yet they remain slow.

This post is about by my experiments to use (as an amateur) state-of-the-art solvers to try in practice to prove such results and other related stuff. I started these experiments prompted by a lecture to undergraduate students, during which I used __Z3__, a high-performance solver from Microsoft, to solve a Sudoku problem (a standard demo for this technology), which was duly solved instantly. You can see such a demo [online](https://rise4fun.com/Z3/Cs7p), but the online version is slow. I looked around for examples of geometric theorems proved using __Z3__ or its friends, but found none. So I decided to try my hands at proving this. Some years ago I had experimented with using __Z3__ for an for recognizing _knotting_, which follows essentially immediately from a result of Kronheimer-Morwka, and I redid similar experiments.

Unfortunately, at least in the way I used them neither __Z3__ nor __CVC4__ (another similar system, and the champion in the latest competition) failed to prove the geometric result I sought. Yet, especially as these systems are vastly improving, it seems worthwhile to write about how such systems can be used at least in principle, especially since this does not seem to be widely known.

## P versus NP and SAT/SMT solvers

Some problems, such as solving a system of linear equations, are not difficult at least once one knows a method to solve them. The thumb rule used is that if we can solve a problem with the number of steps being at most a polynomial in the size of the problem (for instance, the total number of digits in the coefficients of equations), then we consider the problem to be easy enough. The class of these problems is called __P__ (i.e., Polynomial time).

A more interesting class of problems is once for which we can _check_ that a solution is correct reasonably easily, but it is not clear how to find a solution in an easy manner. This is typically the case with puzzles like Jigsaws and Sudoku &mdash; indeed the appeal of puzzles perhaps lies in this feature. Such problems are called __NP__ problems (or problems in the class __NP__). While it appears that many such problems do not have easy (i.e., polynomial time) solutions, there is no proof of this. Whether every problem whose solution is easy to check has a solution that is easy to find is the __P__ versus __NP__ problem.

What makes this problem specially interesting and fruitful is the Cook-Levine theorem from the early 1970s. This says that if one specific problem in NP, called the _Boolean satisfiability problem_ (called SAT) has a polynomial time solution, then _every_ problem that is in __NP__ can be solved in polynomial time. It can be deduced that there are many other problems with the same property. Such problems are called __NP__-complete.

While the theoretical __P__ vs __NP__ problem remains mysterious, the Cook-Levine theorem has had some remarkable practical uses. Since so many classes of problems can be reduced to solving one class of problems, namely __SAT__, a powerful approach has been to develop various clever ways and powerful programs incorporating them, called _SAT solvers_, to solve __SAT__ problems better, and then using these to solve other problems. An extension of SAT solvers are programs called SMT-solvers (for _Satisfiability Modulo Theories_).

The Boolean satisfiability problem (SAT), like the solvability of Diophantine equations, asks whether a set of equations has a solution (sets of equations having solutions are said to be _satisfiable_). However these are equations with variables representing not integers or reals but so called _Booleans_, i.e., which can be either `true` or `false`. From such variables we build statements using the logical operations _and_, _or_ and _not_. For example, for Boolean variables `P` and `Q` we may require than `P` is `true` and `Q` is false (i.e., `not Q` is true). Given a finite list of such conditions, we may or may not have a solution &mdash; for example `P` being true and `P` being false cannot both be satisfied. Determining whether there is a solution is the problem SAT. Clearly given a solution it is easy to check that it is correct, so SAT is in __NP__.

While it appears that no program can solve all SAT problems reasonably fast (i.e., in polynomial time), high-performance SAT solvers try to solve SAT problems as quickly as possible in practice. Indeed in many cases SAT problems are not that hard &mdash; for example if there are either so many solutions that one can readily find one or so many constraints that one can readily show that there are none.

SMT solvers extend these ideas to handle problems that involve not just Booleans, but also integers and real numbers. Thus, we can require that a collection of equations are satisfied, or a mixture of equations and inequations (such as `$x^2 < 3$`, `$y^2 + z^2 \neq 1$`) or even a logical combination of these (e.g. `($x^2 < 3)\vee(y^2 + z^2 \neq 1)$`, where `$\vee$` is the logical _or_). Again many instances of these problems are hard, and now include even ones with no algorithmic solution. Nevertheless the approach taken is to solve as large a class of problems as efficiently as possible.

## Pappus hexagon theorem: attempting geometry

In principle SMT solvers can be used to solve problems in Euclidean geometry. I attempted to prove the _Pappus hexagon theorem_, which I next describe. In addition to being a typical geometry result, this has a deeper mathematical meaning (corresponding to commutativity for affine geometries over division rings).

Suppose we are given two lines, with points $a$, $b$ and $c$ on the first line and $A$, $B$ and $C$ on the second line as in the figure below. We consider the general case, where no pair of lines involving these points are parallel. Let $P$ be the intersection of the lines $Ab$ and $aB$, $Q$ the intersection of $Ac$ and $aC$, and $R$ the intersection of $Bc$ and $bC$. The Pappus hexagon theorem is the result that $P$, $Q$ and $R$ are _collinear_, i.e., there is a line containing all three of these points.

![Pappus Theorem](/Pappus.png)

### Equations for collinearity

We shall translate this into a problem of deciding whether a collection of polynomial equation and inequations over reals has a solution, which as Tarski showed is decidable. First, we recall that collinearity can be expressed as a polynomial equality. Namely,
points with coordinates `$(x_1, y_1)$`, `$(x_2, y_2)$` and `$(x_3, y_3)$`, which we assume to be distinct, are collinear if and only if
`$$\frac{y_2 - y_1}{x_2 - x_1} = \frac{y_3 - y_1}{x_3 - x_1}$$`
which is equivalent to `$$(y_2 - y_1)(x_3 - x_1) = (y_3 - y_1)(x_2 - x_1).$$`

### A simple problem

As a warmup and sanity check, I set up the problem of showing that for an arbitrary point $P = (x, y)$, the three points $P=(x, y)$, $O=(0, 0)$ and $-P=(-x, -y)$ are collinear.

We prove such results using SAT/SMT solvers by contradiction. In this case, for variables $x$ and $y$, we impose the condition that the points $P$, $O$ and $-P$ are _not_ collinear. If the solver shows that this cannot be satisfied, then it follows that the points are always collinear. Observe that the condition of not being collinear just means that equation in the above equation is replaced by the inequation `$(y_2 - y_1)(x_3 - x_1) \neq (y_3 - y_1)(x_2 - x_1)$`.

Indeed the solvers __Z3__ and __cvc4__ prove this result instantly &mdash; more precisely, __Z3__ took $0.012$ seconds and __CVC4__ took $0.094$ seconds.

### Choosing coordinates

While one can (and I initially did) take arbitrary coordinates for the $6$ points $a$, $b$, $c$, $A$, $B$ and $C$ and add equations for their being collinear, we consider a simpler variant where we choose coordinates and parametrize the points. Namely, we can take $a$, $b$ and $c$ on the x-axis with $a = (1, 0)$. Then we have $b = (1 + u, 0)$ and $c = (1 + u + v, 0)$ with $u>0$ and $v>0$. Similarly, if we let `$A = (x_A, y_A)$`, then we can assume that `$B = (x_A(1+ U), y_A(1 + U))$` for some $U > 0$ and `$C = (x_A(1+ U + V), y_A(1 + U + V))$` for some $V > 0$. Further, we can assume that $y_A > 0$.

We take the points `$P= (x_P, y_p)$`, `$Q = (x_Q, y_Q)$` and `$R= (x_R, y_R)$` to have arbitrary coordinates. We then add equations corresponding to their being intersection points as we see below. Thus, we have $12$ variables in all, $6$ of them the parameters $u$, $v$, $x_A$, $y_A$, $U$ and $V$ for the problem and $6$ more coordinates of the intersection points. Further, we have inequalities $u >0$, $v >0$, `$y_A >0$`, $U > 0$ and $V >0$.

### Formulating using polynomial equations and inequations

We reformulate the Pappus hexagon theorem in terms of collinearity. Observe that $P$ being the intersection point of $Ab$ and $aC$ is equivalent to both the triples of points $(A, P, b)$ and $(a, P, B)$ being collinear. We have similar conditions for $Q$ and $R$. Thus, the hypothesis can be formulated in terms of collinearity (and distinctness) of various triples of points.

Finally, the conclusion is that $P$, $Q$ and $R$ are collinear. We seek to prove this by contradiction, namely we add the condition that they are not collinear, and show that the resulting system cannot be satisfied. Again, the condition that the points are not collinear gives an inequation.

In summary, we have a problem asking whether a set of algebraic equations and inequations has a solution over reals. This system has `$12$` variables, with `$6$` equations corresponding to collinearity, `$5$` inequations stating that variables are positive and an inequation (to contradict) stating that three points are not collinear.

### Running SMT solvers

As mentioned in the introduction, neither of the SMT solvers was able to prove the Pappus hexagon theorem. This is in spite of my (undoubtedly amateur) attempts at changing their parameters to raise various limits.

To try to assess how far they were from proving the theorem, I attempted a simpler variant. Instead of having all six of $u$, $v$, $x_A$, $y_A$, $U$ and $V$ as variables (so proving the result for all values of these), I added additional equations fixing some of them. Since all but $x_A$ were known to be positive, for convenience conditions could only be added by choosing random positive numbers corresponding to some of the five variables $u$, $v$, $y_A$, $U$ and $V$ and adding corresponding equations &mdash; for example, the program could pick `$c > 0$` at random and add the equation `u = c`. 

When all $5$ of the variables were fixed (leaving only $x_A$ to vary), __Z3__ solved the problem instantly. When $4$ of the $5$ were fixed, the theorem was proved in about 6 seconds. However, when only $3$ were fixed I could not get either solver to prover the result, in spite of changing parameters.

## Knot so easy

A basic decision problem in topology is the _unknotting problem_, which is deciding whether a smooth embedding $K$ of the circle into `$\R^3$` is the boundary of a smooth embedding of a disc. We say $K$ is unknotted if it bounds a smoothly embedded disc. This was solved in the 1950s by Haken. However, Haken's algorithm was doubly exponential, and so not practical.

As had been independently observed by many people, there is another kind of algorithm that follows immediately from some deep work of Kronheimer-Mrowka where they proved what was called _Property P_, a baby version of the Poincar&eacute; conjecture (Perelman proved the Poincar&eacute; conjecture itself some years after this work of Kronheimer-Mrowka). 

It has been known from the 1950s that the knotting problem is equivalent to whether the so called _Knot Group_ `$G_K$` associated to a knot `$K$` is isomorphic to the integers. However deciding whether groups are isomorphic, or even whether a group is non-trivial, are algorithmically undecidable. What Kronheimer-Mrowka showed was that a certain quotient `$\bar{G}_K$` of `$G_K$` (the fundamental group of the manifold obtained by $+1$ surgery about the knot) is the trivial group if and only if $K$ is unknotted.

As mentioned above, this criterion does not give an algorithm as we cannot decide whether a group is trivial. However, Kronheimer-Mrowka proved more, namely if $K$ is not unknotted, then `$\bar{G}_K$` has a non-trivial homomorphism into `$SU(2)$`, the group of unit quaternions. Such representations are given in terms of algebraic equations, and inequations can be used to characterize non-triviality. Thus, unknotting is a special case of a problem solvable in principle &mdash; that of determining whether a group (given by a presentation) has a non-trivial homomorphism into unit quaternions.

I implemented the translation of the group theoretic problem to SMT problems, and attempted this for a few presentations of groups. Once more, my success was limited. For simple presentations I easily obtained either non-trivial homomorphisms or a proof of non-existence of these. However the solvers quickly reached their limits.

I must mention that now there is now a practical solution of the unknotting problem, again due to Kronheimer-Mrowka, based on a characterization in terms of _Khovanov homology_.