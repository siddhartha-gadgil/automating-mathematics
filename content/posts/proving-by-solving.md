+++
title = "Knot so easy: Mathematical Proofs from High-performance Solvers?"
date = 2021-04-14T12:24:23+05:30
draft = true
tags = []
categories = []
+++

While computers are able to handle an increasing range of tasks, there are some known, and other conjectures, fundamental limitations. The first class of these follow from the results of G&ouml;del, Turing, Church and others. These show that, for instance, there is no computer program that given a mathematical statement as input, either gives a proof or (correctly) says that the statement is false. 

Indeed this is not even possible for a seemingly simple class of problems: deciding whether a so called [Diophantine Equation](https://en.wikipedia.org/wiki/Diophantine_equation), has a solution. A Diophantine equation is a polynomial equation with integer coefficients, such as `$3n^2 + 7m^2 = r^3$`, and we say this has a solution if there are _integers_ corresponding to the variables ($n$, $m$ and $r$ in the example) which satisfy the equation. As a result of combined work of Martin Davis, Yuri Matiyasevich, Hilary Putnam and Julia Robinson, there is no algorithm (i.e., computer program) to which we can input the coefficients of a Diophantine equation and which will tell us (correctly) whether the equation has integral solutions.

Yet, the above results should not be over-interpreted to say that proofs cannot be found by programs. Indeed if we turn from numbers to the other classical source of mathematics - Euclidean geometry, the situation is different. Roughly at the same time that the unsolvability of Diophantine equations were shown, Tarski proved that whether similar equations have solutions that are real numbers __is__ decidable. Using coordinate geometry, statements in Euclidean geometry can be translated to such problems, and so are algorithmically decidable.

Tarski's algorithm has been greatly improved, and algorithms of a more algebraic nature have also been developed, improved and implemented. Yet they remain slow. This post is prompted by my experiments to use (as an amateur) state-of-the-art solvers to try in practice to prove such results, and also use similar methods to implement an algorithm to decide _knotting_ (building on deep mathematics).
