+++
title = "Knot so easy: Mathematical Proofs from High-performance Solvers?"
date = 2021-04-14T12:24:23+05:30
draft = false
tags = []
categories = []
+++

While computers are able to handle an increasing range of tasks, there are some known, and other conjectures, fundamental limitations. The first class of these follow from the results of G&ouml;del, Turing, Church and others. These show that, for instance, there is no computer program that given a mathematical statement as input, either gives a proof or (correctly) says that the statement is false. The second (conjectured) limitation is from the P/NP problem, which we turn too in the next section.

Indeed, limits of algorithms apply even for a seemingly simple class of problems: deciding whether a so called [Diophantine Equation](https://en.wikipedia.org/wiki/Diophantine_equation), has a solution. A Diophantine equation is a polynomial equation with integer coefficients, such as `$3n^2 + 7m^2 = r^3$`, and we say this has a solution if there are _integers_ corresponding to the variables ($n$, $m$ and $r$ in the example) which satisfy the equation. As a result of combined work of Martin Davis, Yuri Matiyasevich, Hilary Putnam and Julia Robinson, there is no algorithm (i.e., computer program) to which we can input the coefficients of a Diophantine equation and which will tell us (correctly) whether the equation has integral solutions.

Yet, the above results should not be over-interpreted to say that proofs cannot be found by programs. Indeed if we turn from numbers to the other classical source of mathematics - Euclidean geometry, the situation is different. Roughly at the same time that the unsolvability of Diophantine equations were shown, Tarski proved that whether similar equations have solutions that are real numbers __is__ decidable. Using coordinate geometry, statements in Euclidean geometry can be translated to such problems, and so are algorithmically decidable. Tarski's algorithm has been greatly improved, and algorithms of a more algebraic nature have also been developed, improved and implemented. Yet they remain slow.

This post is about by my experiments to use (as an amateur) state-of-the-art solvers to try in practice to prove such results and other related stuff. I started these experiments prompted by a lecture to undergraduate students, for which I again used __Z3__, a high-performance solver from Microsoft, to solve a Sudoku problem (a standard demo for this technology), which was duly solved instantly (you can see this [online](https://rise4fun.com/Z3/Cs7p), but the online version is slow). I looked around for examples of geometric theorems proved using __Z3__ or its friends, but found none. So I decided to try my hands at proving this. Some years ago I had experimented with using __Z3__ for an for recognizing _knotting_, which follows essentially immediately from a result of Kronheimer-Morwka, and I redid similar experiments.

Unfortunately, at least in the way I used them neither __Z3__ nor __CVC4__ (another similar system) failed to prove the geometric result I sought. Yet, especially as these systems are vastly improving, it seems worthwhile to write about how such systems can be used at least in principle, especially since this does not seem to be widely known.

## P versus NP and SAT/SMT solvers

Some problems, such as solving a system of linear equations, are not difficult at least once one knows a method to solve them. The thumb rule used is that if we can solve a problem with the number of steps being at most a polynomial in the size of the problem (for instance, the total number of digits in the coefficients of equations), then we consider the problem to be easy enough. The class of these problems is called __P__ (i.e., Polynomial time).

A more interesting class of problems is once for which we can _check_ that a solution is correct reasonably easily, but it is not clear how to find a solution in an easy manner. This is typically the case with puzzles like Jigsaws and Sudoku &mdash; indeed the appeal of puzzles perhaps lies in this feature. Such problems are called __NP__ problems (or problems in the class __NP__). While it appears that many such problems do not have easy (i.e., polynomial time) solutions, there is no proof of this. Whether every problem whose solution is easy to check has a solution that is easy to find is the __P__ versus __NP__ problem.

What makes this problem specially interesting and fruitful is the Cook-Levine theorem from the early 1970s. This says that if one specific problem in NP, called the _Boolean satisfiability problem_ (called SAT) has a polynomial time solution, then _every_ problem that is in __NP__ can be solved in polynomial time. It follows that there are many other problems with the same property. Such problems are called __NP__-complete.

While the theoretical __P__ vs __NP__ problem remains mysterious, the Cook-Levine theorem has had some remarkable practical uses. Since so many classes of problems can be reduced to solving one class of problems, namely __SAT__, a powerful approach has been to develop various clever ways and powerful programs incorporating them, called _SAT solvers_, to solve __SAT__ problems better, and then using these to solve other problems. An extension of SAT solvers are programs called SMT-solvers (for _Satisfiability Modulo Theories_).

The Boolean satisfiability problem (SAT) asks whether a set of equations involving variables that are either `true` ro `false`, so called _Boolean_ variables, has a solution. More precisely, we have finitely many variables `P`, `Q`, ... each of which can be either true or false. From these we build statements using the logical operations _and_, _or_ and _not_. For example, we may require than `P` is `true` and `Q` is false (i.e., not `Q` is true). Given a finite list of such conditions, we may or may not have a solution &mdash; for example `P` being true and `P` being false cannot both be satisfied. Determining whether there is a solution is the problem SAT. Clearly given a solution it is easy to check that it is correct, so SAT is in __NP__.

While it appears that no program can solve all SAT problems reasonably fast (i.e., in polynomial time), high-performance SAT solvers try to solve SAT problems as quickly as possible in practice. Indeed in many cases SAT problems are not that hard &mdash; for example if there are either so many solutions that one can readily find one or so many constraints that one can readily show that there are none.

SMT solvers extend these ideas to handle problems that involve not just Booleans, but also integers and real numbers, with problems built up using also equality, less than, greater than and arithmetic operations. Again many instances of these problems are hard, and now include even ones with no algorithmic solution. Nevertheless the approach taken is to solve as large a class of problems as efficiently as possible.

## Pappus hexagon theorem: attempting geometry

In principle SMT solvers can be used to solve problems in Euclidean geometry. I attempted to prove the _Pappus hexagon theorem_, which I next describe. In addition to being a typical geometry result, this has a deeper mathematical meaning (corresponding to commutativity for affine geometries over division rings).

Suppose we are given two lines, with points $a$, $b$ and $c$ on the first and $A$, $B$ and $C$ on the second as in the figure below. We consider the general case, where no pair of lines involving these points are parallel. Let $P$ be the intersection of the lines $Ab$ and $aB$, $Q$ the intersection of $Ac$ and $aC$, and $R$ the intersection of $Bc$ and $bC$. The Pappus hexagon theorem is the result that $P$, $Q$ and $R$ are _collinear_, i.e., contained in the same line.

![Pappus Theorem](/Pappus.png)

### Equations for collinearity

We shall translate this into a problem of deciding whether a collection of polynomial equalities and inequalities over reals has a solution, which as Tarski showed is decidable. First, we recall that collinearity can be expressed as a polynomial equality. Namely,
points with coordinates `$(x_1, y_1)$`, `$(x_2, y_2)$` and `$(x_3, y_3)$`, which we assume to be distinct, are collinear if and only if
`$$\frac{y_2 - y_1}{x_2 - x_1} = \frac{y_3 - y_1}{x_3 - x_1}$$`
which is equivalent to `$$(y_2 - y_1)(x_3 - x_1) = (y_3 - y_1)(x_2 - x_1)$$.`

### A simple problem

As a warmup and sanity check, I set up the problem of showing that for an arbitrary point $P = (x, y)$, the three points $P=(x, y)$, $O=(0, 0)$ and $-P(-x, -y)$ are collinear. We prove results using SAT/SMT solvers by contradiction. In this case, we take $x$ and $y$ to be collinear, and impose the condition that the points $P$, $O$ and $-P$ are _not_ collinear. If the solver shows that this cannot be satisfied, then it follows that the points are always collinear. Observe that the condition of not being collinear just means that equality in the above equation is replaced by inequality.

Indeed the solvers __Z3__ and __cvc4__ prove this result instantly.

### Choosing coordinates

While one can (and I initially did) take arbitrary coordinates for the $6$ points $a$, $b$, $c$, $A$, $B$ and $C$ and add equations for their being collinear, we consider a simpler variant where we choose coordinates and parametrize the points. Namely, we can take $a$, $b$ and $c$ on the x-axis with $a = (1, 0)$. Then we have $b = (1 + u, 0)$ and $c = (1 + u + v, 0)$ with $u>0$ and $v>0$. Similarly, if we let `$A = (x_A, y_A)$`, then we can assume that `$B = (x_A(1+ U), y_A(1 + U))$` for some $U > 0$ and `$C = (x_A(1+ U + V), y_A(1 + U + V))$` for some $V > 0$. Further, we can assume that $y_A > 0$.

We take the points `$P= (x_P, y_p)$`, `$Q = (x_Q, y_Q)$` and `$R= (x_R, y_R)$` to have arbitrary coordinates. We then add equations corresponding to their being intersection points as we see below. Thus, we have $12$ variables in all, $6$ of them the parameters $u$, $v$, $x_A$, $y_A$, $U$ and $V$ for the problem and $6$ more coordinates of the intersection points. Further, we have inequalities $u >0$, $v >0$, `$y_A >0$`, $U > 0$ and $V >0$.

### Formulating using polynomial equations and inequations

We reformulate the Pappus hexagon theorem. Observe that $P$ being the intersection point of $Ab$ and $aC$ is equivalent to both the triples of points $(A, P, b)$ and $(a, P, B)$ being collinear. We have similar conditions for $Q$ and $R$. Thus, the hypothesis can be formulated in terms of collinearity (and distinctness) of various triples of points.

Finally, the conclusion is that $P$, $Q$ and $R$ are collinear. We seek to prove this by contradiction, namely we add the condition that they are not collinear, and show that the resulting system cannot be satisfied. Again, the condition that the points are not collinear gives an inequality.