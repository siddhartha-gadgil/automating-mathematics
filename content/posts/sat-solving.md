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

We now describe the algorithm we implemented to solve `SAT` for a collection of clauses, giving either an assignment of truth values that satisfies all the clauses or a contradiction using resolution starting with the given clauses. We shall see this in stages.

### Recursive solving: the DP algorithm

We pick a variable `$P$` and look for solutions first when `$P$` is assigned the value true and then when it is assigned false (in our code we actually randomize the order of the branches). For solutions where `$P$` is true:

- Any clause containing `$P$` is true, so can be dropped.
- Any clause of the form `$\neg P\vee l_1\vee\dots\veel_n$` (up to reordering) is true if and only the clause `$C =l_1\vee\dots\veel_n$` obtained by dropping `$\neg P$` is true. We can thus replace `$\cnegP \vee C := \neg P\vee l_1\vee\dots\veel_n$` by `$C$` when considering solutions with `$P$` true.
- Finally, clauses `$C$` containing neither `$P$` nor `$\neg P$` are unaffected, and should be satisfied even after assigning `$P$`.

We thus get an instance of `SAT`, which we call the restricted problem, with fewer variables and in general fewer clauses. If the restricted problem has a solution then we get a solution to the original problem. Otherwise we look for a solution where `$P$` is false, once more obtaining a restricted `SAT` problem with fewer variables. If the latter problem has a solution so does the original one. If not, we know both the restricted problems have no solutions. Since `$P$` must be true or false, the original problem has no solution.

Thus, we can reduce the solution of a `SAT` problem to the solution of `SAT` problems with fewer variables. This gives a recursive algorithm once we solve in the base case, which is the case with no variables. But in this case the only clause is the empty clause. Thus there are only two `SAT` problems.

- The set of clauses is empty. Here every clause is satisfied, so there is a solution.
- The set of clauses is a singleton, the empty clause. This is not satisfiable as the empty clause cannot be satisfied.

Using the above, we get an algorithm for the `SAT` problem.

### DLPP algorithm

There are two ways in which the DP algorithm can be imdeduced, giving the DLPP algorithm. Firstly, if some clause is a _unit literal_, i.e., a literal `$l$` with `$l = P$` or `$l = \neg P$`, then `$P$` must be assigned the value that makes `$l$` true. On doing this, all clauses containing `$l$` are true and can be dropped, while a clause of the form `$\neg l\vee C$` can be replaced by the clause `$C$` obtained by deleting `$\neg l$`. On making such simplifications, new units may be created and this process repeated. For instance, if each clause has length 2 (so called `2-SAT`), this clearly gives a fast algorithm.

A second improvement is to use _pure literals_, literals `$l$` so that `$\neg l$` is not present in any clause. Then the `SAT` problem has a solution if and only if it has a solution with `$l$` true. Hence we can assign the value of the variable `$P$` with `$l = P$` or `$l = \neg P$` to make `$l$` true, and drop all the clauses containing `$l$`.

We have implemented this without further heuristics, except for some use of a _conflict driven_ approach to avoid full back-tracking, based on
keeping track of proofs. We next sketch how we keep track of proofs (the algorithmic improvement will be evident).

### Lifting proofs

Suppose the given `SAT` problem has no solution, as discovered by our recursive algorithm. We can enhance our algorithm to in this case give a proof using resolution of a contradiction starting with the given clauses. We sketch this here. The main step is the _lifting_ of a proof from a restricted problem.

To start with consider the base case where there is no variable. Here if the `SAT` problem is not satisfiable, we must have an empty clause. Thus a given clause is itself a contradiction.

Now consider the general case with `$n$` variables (that are not assigned), and assume that our algorithm gives either a solution or a contradiction using resolution whenever we have fewer than `$n$` variables (that are not assigned). Pick a variable `$P$` and assign a truth value to this, say true. As above, we get a restricted problem collection of clauses not involving the variable `$P$`.

Suppose the original problem has no solution, then the restricted problem does not either. Hence using resolution, we can deduce a contradiction starting with the clauses of the restricted problem. However note that some of the clauses `$C$` of the restricted problem are not clauses in the original problem &ndash; instead the clause `$\neg P\vee C$` is given in the original problem. Nevertheless we can lift the proof of a contradiction to something useful.

Namely, we claim that if any clause `$C$` is deduced using resolution in the restricted problem, then either `$\neg P\vee C$` or `$C$` itself can be deduced by resolution in the original problem. By construction this is true for all the initial clauses in the restricted problem. As none of the clauses in the restricted problem involves `$P$`, if the claim holds for a pair of clauses it holds for the result by resolution as well. By induction we see that this holds for all clauses that can be deduced by resolution in the restricted problem.

We apply the claim to the contradiction, i.e., the empty clause. Thus either a contradiction or `$\neg P$` can be deduced by resolution. If we have deduced a contradiction, we are done. Otherwise we have deduced `$\neg P$`. But we apply the same algorithm to the restricted problem when `$P$` is taken as false. In this case we deduce either a contradiction or `$P$`. Thus, we either have a contradiction or both `$P$` and `$\neg P$`. In the latter case resolution gives a contradiction.
