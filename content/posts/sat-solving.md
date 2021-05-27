+++
title = "Sat Solving"
date = 2021-05-18T08:53:42+05:30
draft = true
tags = []
categories = []
+++

To better understand the `SAT` (i.e., _boolean satisfiability_) problem and `SAT` solvers, I decided to implement a basic one. I was pleasantly surprised that wikipedia has enough details to implement the so called __DLPP__ algorithm quite easily, with even some improvements described in wikipedia. Even better, in the case when there was no solution, the same algorithm gives a proof that there is no solution. The proof that there is no solution was based on _resolution_ due to Davis-Putnam &mdash; so the algorithm gives as a bonus a proof that resolution is refutation complete for propositional calculus.
<!--more-->

## The `SAT` (Boolean satisfiability) problem

Suppose we are given finitely many variables `$P$`, `$Q$`, ... which are _boolean_, i.e. represent whether a statement is true or false, and finitely many relations among them. The relations are logical statements built from the variables using logical operators such as `$\neg$` (_not_), `$\vee$`(_or_), `$\wedge$`(_and_), `$\Rightarrow$`(_implies_) and `$\Leftrightarrow$` (_equivalent_). The  `SAT` (_boolean satisfiability_) problem  asks whether we can assign truth values to these (i.e., declare each of `$P$`, `$Q$` , ... to be `true` or `false`) so that all the relations are satisfied.

In the sequel, we shall use the standard logic terminology. Logical statements are called _Propositions_ (these can be either true or false, unlike the standard meaning of the word proposition in mathematics). Statements built from logical variables by logical operators are called _formulas_. All the variables we consider are boolean. Note that a boolean variable is itself a formula.

## CNF

If `$P$` is a (boolean) variable, the formulas `$P$` and `$\neg P$` are called _literals_. A _clause_ is a formula of the form `$l_1\vee l_2\vee\dots\vee l_n$` with each `$l_i$` a literal. A formula in __CNF__ is a formula of the form `$C_1\wedge C_2\wedge\dots\wedge C_m$` such that each `$CJ$` is a clause. Observe that `$C_1\wedge C_2\wedge\dots\wedge C_m$` is satisfied if and only if all the formulas `$C-j$` are satisfied. Hence we can (and will) view a formula in `$CNF$` as a collection of clauses, all of which are required to be satisfied.

Any formula can be rewritten as a CNF formula to which is is equivalent. Namely, we first rewrite all instances of `$A\Rightarrow B$` as `$\neg B\vee A$` and `$A\Leftrightarrow B$` as `$(\neg A\wedge \neg B)\vee (A\wedge B)$` to eliminate operators other than `$\vee$`, `$\wedge$` and `$\neg$`. Next we use `$\neg(A \vee B) = \neg A \wedge \neg B$` and `$\neg(A \wedge B) = \neg A \vee \neg B$` recursively to rewrite the formula as combinations of literals using `$\vee$` and `$\wedge$` only. Finally, using the distributivity property `$A \vee (B\wedge C)= (A\vee B)\wedge (A \vee C)$` recursively we get a formula in CNF.

### Tautologies and Contradictions

Since `$l\vee l = l$`, we can assume that no literal appears more than once in a clause. Further, if a clause contains both `$P$` and `$\neg P$` for some variable `$P$`, then this clause is always true, i.e., is a _tautology_. We can drop such clauses. We henceforth assume both these simplifications have been made.

On the other hand, an empty clause can never be satisfied (as _some_ literal in the clause must be true for it to be satisfied). Thus, an empty clause is a _contradiction_. In particular, the formula in CNF has an empty clause, then it cannot be satisfied. This will rarely happen, but we shall see how to deduce new clauses in such a way as to get an empty clause for unsatisfiable formulas.

### Resolution

Given two clauses of the form `$C = P\vee l_1\vee l_2\vee \dots\vee l_n$` and `$C' = P\vee l'_1\vee l'_2\vee \dots\vee l'_{n'}$` (after possibly reordering literals), we can deduce the clause `$l_1\vee l_2\vee \dots\vee l_n\vee l'_1\vee l'_2\vee \dots\vee l'_{n'}$`. Namely, if `$P$` is false then as `$C$` is true we must have `$l_1\vee l_2\vee \dots\vee l_n$`. On the other hand if `$P$` is true, as `$C'$` is true we must have `$l'_1\vee l'_2\vee \dots\vee l'_{n'}$`. Either way, we see that `$l_1\vee l_2\vee \dots\vee l_n\vee l'_1\vee l'_2\vee \dots\vee l'_{n'}$` holds.

The clause `$l_1\vee\l_2\vee \dots\vee l_n\vee l'_1\vee\l'_2\vee \dots\vee l'_{n'}$` is said to be obtained by _resolution_ from `$C$` and `$C'$`. A theorem of Martin Davis and Hilary Putnam says that resolution is _refutation complete_ not just for `SAT` but in a more general context, namely first-order logic. This means that if a collection of clauses is not satisfiable, then we can deduce the empty clause by (repeated) resolution starting with the given clauses. Note that the final step will be resolving (singleton) clauses of the form `$P$` and `$\neg P$` to get an empty clause.

The algorithm we implement gives either a solution to a collection of clauses or a deduction using resolution of the empty clause. Thus, this is in particular a proof that resolution is refutation complete in the context of `SAT`.

## An example: the N-Queens problem

Before we sketch our algorithm, we consider a class of examples, namely the N-Queens problem. This asks whether we can place `$N$` queens on an `$N\times N$` chessboard with no two queens attacking each other.

To formulate this in terms of `SAT`, we consider a collection of `$N^2$` boolean variables `QueenAt(i, j)` for `$0 \leq i, j < N$` representing whether a queen is present at the corresponding square on the grid (as is common with programs the indices begin at `$0$`). As is usual, instead of using (the clumsy) equation for their being (at least) `$N$` queens on the board, we use `$N$` equations saying that each row has a queen. We also have a bunch of equation for queens not attacking each other horizontally, vertically and along diagonals. These equations are generated (programmatically) as clauses.

### Solution to 8-Queens

The classical 8-Queens problem is solved instantly. A little scripting lets us display the solution in a table (using a unicode character for the queen).

|||||||||
|--- |--- |--- |--- |--- |--- |--- |--- |
||||♕|||||
||||||||♕|
|♕||||||||
|||♕||||||
||||||♕|||
||♕|||||||
|||||||♕||
|||||♕||||

### No solution for 3-Queens

On the other hand, the 3-Queens problem has no solutions. Indeed, our program gives a proof of this by deducing a contradiction using resolution, starting with the __assumptions__. A little scripting lets us write this solution as nested lists, with resolutions written in terms of the final clause being deduced from the given clauses. This gives a tree-like structure, with the root a contradiction and the leaves the given assumptions.

- *Contradiction* **from** (¬QueenAt(1,0)) **and** (QueenAt(1,0)),
    **using**
    - (¬QueenAt(1,0)) **from** (¬QueenAt(1,0) ∨ QueenAt(0,0)) **and**
        (¬QueenAt(0,0) ∨ ¬QueenAt(1,0)), **using**
        - (¬QueenAt(1,0) ∨ QueenAt(0,0)) **from** (¬QueenAt(1,0) ∨
            ¬QueenAt(0,2)) **and** (¬QueenAt(1,0) ∨ QueenAt(0,0) ∨
            QueenAt(0,2)), **using**
            - (¬QueenAt(1,0) ∨ ¬QueenAt(0,2)) **from** (¬QueenAt(1,0)
                ∨ QueenAt(2,2)) **and** (¬QueenAt(0,2) ∨ ¬QueenAt(2,2)),
                **using**
                - (¬QueenAt(1,0) ∨ QueenAt(2,2)) **from**
                    (¬QueenAt(2,1) ∨ ¬QueenAt(1,0)) **and**
                    (¬QueenAt(1,0) ∨ QueenAt(2,1) ∨ QueenAt(2,2)),
                    **using**
                    - (¬QueenAt(2,1) ∨ ¬QueenAt(1,0)) by assumption
                    - (¬QueenAt(1,0) ∨ QueenAt(2,1) ∨ QueenAt(2,2))
                        **from** (¬QueenAt(2,0) ∨ ¬QueenAt(1,0)) **and**
                        (QueenAt(2,1) ∨ QueenAt(2,2) ∨ QueenAt(2,0)),
                        **using**
                        - (¬QueenAt(2,0) ∨ ¬QueenAt(1,0)) by
                            assumption
                        - (QueenAt(2,1) ∨ QueenAt(2,2) ∨ QueenAt(2,0))
                            by assumption
                - (¬QueenAt(0,2) ∨ ¬QueenAt(2,2)) by assumption
            - (¬QueenAt(1,0) ∨ QueenAt(0,0) ∨ QueenAt(0,2)) **from**
                (¬QueenAt(0,1) ∨ ¬QueenAt(1,0)) **and** (QueenAt(0,0) ∨
                QueenAt(0,2) ∨ QueenAt(0,1)), **using**
                - (¬QueenAt(0,1) ∨ ¬QueenAt(1,0)) by assumption
                - (QueenAt(0,0) ∨ QueenAt(0,2) ∨ QueenAt(0,1)) by
                    assumption
        - (¬QueenAt(0,0) ∨ ¬QueenAt(1,0)) by assumption
    - (QueenAt(1,0)) **from** (QueenAt(1,0) ∨ QueenAt(2,1)) **and**
        (¬QueenAt(2,1) ∨ QueenAt(1,0)), **using**
        - (QueenAt(1,0) ∨ QueenAt(2,1)) **from** (QueenAt(1,2) ∨
            QueenAt(1,0) ∨ QueenAt(2,1)) **and** (¬QueenAt(1,2) ∨
            QueenAt(2,1)), **using**
            - (QueenAt(1,2) ∨ QueenAt(1,0) ∨ QueenAt(2,1)) **from**
                (QueenAt(1,2) ∨ QueenAt(1,0) ∨ ¬QueenAt(2,0)) **and**
                (QueenAt(1,2) ∨ QueenAt(1,0) ∨ QueenAt(2,0) ∨
                QueenAt(2,1)), **using**
                - (QueenAt(1,2) ∨ QueenAt(1,0) ∨ ¬QueenAt(2,0))
                    **from** (QueenAt(1,1) ∨ QueenAt(1,2) ∨
                    QueenAt(1,0)) **and** (¬QueenAt(2,0) ∨
                    ¬QueenAt(1,1)), **using**
                    - (QueenAt(1,1) ∨ QueenAt(1,2) ∨ QueenAt(1,0)) by
                        assumption
                    - (¬QueenAt(2,0) ∨ ¬QueenAt(1,1)) by assumption
                - (QueenAt(1,2) ∨ QueenAt(1,0) ∨ QueenAt(2,0) ∨
                    QueenAt(2,1)) **from** (QueenAt(1,2) ∨ QueenAt(1,0)
                    ∨ ¬QueenAt(2,2)) **and** (QueenAt(2,0) ∨
                    QueenAt(2,2) ∨ QueenAt(2,1)), **using**
                    - (QueenAt(1,2) ∨ QueenAt(1,0) ∨ ¬QueenAt(2,2))
                        **from** (QueenAt(1,1) ∨ QueenAt(1,2) ∨
                        QueenAt(1,0)) **and** (¬QueenAt(2,2) ∨
                        ¬QueenAt(1,1)), **using**
                        - (QueenAt(1,1) ∨ QueenAt(1,2) ∨ QueenAt(1,0))
                            by assumption
                        - (¬QueenAt(2,2) ∨ ¬QueenAt(1,1)) by
                            assumption
                    - (QueenAt(2,0) ∨ QueenAt(2,2) ∨ QueenAt(2,1)) by
                        assumption
            - (¬QueenAt(1,2) ∨ QueenAt(2,1)) **from** (¬QueenAt(1,2) ∨
                QueenAt(2,1) ∨ QueenAt(0,1)) **and** (¬QueenAt(0,1) ∨
                ¬QueenAt(1,2)), **using**
                - (¬QueenAt(1,2) ∨ QueenAt(2,1) ∨ QueenAt(0,1))
                    **from** (¬QueenAt(1,2) ∨ QueenAt(2,1) ∨
                    ¬QueenAt(0,0)) **and** (¬QueenAt(1,2) ∨ QueenAt(0,0)
                    ∨ QueenAt(0,1)), **using**
                    - (¬QueenAt(1,2) ∨ QueenAt(2,1) ∨ ¬QueenAt(0,0))
                        **from** (¬QueenAt(1,2) ∨ QueenAt(2,0) ∨
                        QueenAt(2,1)) **and** (¬QueenAt(0,0) ∨
                        ¬QueenAt(2,0)), **using**
                        - (¬QueenAt(1,2) ∨ QueenAt(2,0) ∨
                            QueenAt(2,1)) **from** (¬QueenAt(2,2) ∨
                            ¬QueenAt(1,2)) **and** (QueenAt(2,0) ∨
                            QueenAt(2,2) ∨ QueenAt(2,1)), **using**
                            - (¬QueenAt(2,2) ∨ ¬QueenAt(1,2)) by
                                assumption
                            - (QueenAt(2,0) ∨ QueenAt(2,2) ∨
                                QueenAt(2,1)) by assumption
                        - (¬QueenAt(0,0) ∨ ¬QueenAt(2,0)) by
                            assumption
                    - (¬QueenAt(1,2) ∨ QueenAt(0,0) ∨ QueenAt(0,1))
                        **from** (¬QueenAt(0,2) ∨ ¬QueenAt(1,2)) **and**
                        (QueenAt(0,0) ∨ QueenAt(0,1) ∨ QueenAt(0,2)),
                        **using**
                        - (¬QueenAt(0,2) ∨ ¬QueenAt(1,2)) by
                            assumption
                        - (QueenAt(0,0) ∨ QueenAt(0,1) ∨ QueenAt(0,2))
                            by assumption
                - (¬QueenAt(0,1) ∨ ¬QueenAt(1,2)) by assumption
        - (¬QueenAt(2,1) ∨ QueenAt(1,0)) **from** (¬QueenAt(2,1) ∨
            QueenAt(1,1) ∨ QueenAt(1,0)) **and** (¬QueenAt(1,1) ∨
            ¬QueenAt(2,1)), **using**
            - (¬QueenAt(2,1) ∨ QueenAt(1,1) ∨ QueenAt(1,0)) **from**
                (¬QueenAt(1,2) ∨ ¬QueenAt(2,1)) **and** (QueenAt(1,1) ∨
                QueenAt(1,2) ∨ QueenAt(1,0)), **using**
                - (¬QueenAt(1,2) ∨ ¬QueenAt(2,1)) by assumption
                - (QueenAt(1,1) ∨ QueenAt(1,2) ∨ QueenAt(1,0)) by
                    assumption
            - (¬QueenAt(1,1) ∨ ¬QueenAt(2,1)) by assumption

## Solving SAT


