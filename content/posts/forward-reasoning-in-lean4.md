+++
title = "Forward Reasoning in Lean 4"
date = 2022-03-10T19:20:21+05:30
draft = true
tags = []
categories = []
+++

I describe here my experiments with _forward reasoning_ (reasoning from the premises), as well as _mixed reasoning_ (reasoning both from the premises and from the conclusion) in Lean 4. The code for this is in the [Lean Loris](https://github.com/siddhartha-gadgil/lean-loris) repository. This code (and especially the ideas in it) is a successor to my scala code in [ProvingGround](https://github.com/siddhartha-gadgil/ProvingGround).

Lean has a very powerful collection of _tactics_ to perform backward reasoning, i.e., reasoning starting from the conclusion. One hopes that the forward reasoning capabilities can complement these. In particular, forward reasoning can be open-ended, exploring consequences of the premises.

<!--more-->

# First Example: purely forward reasoning

The main example on which I focussed while developing this code (as also part of my earlier code) was a problem from a Czech-Slovak Olympiad (the first experiments with this in ProvingGround were done by Achal Kumar, an undergraduate at IISc). 

## The Problem and a Proof

Let `$M$` be a set with a binary operation `$*$`. Suppose we have the axioms
* `$\forall a, b \in M, (a * b) * b = a$`,
* `$\forall a, b \in M, a * (a * b) = b$`,

then `$\forall m, n\in M$, $m * n = n * m$`.

To begin with, here is a _lean_ proof of this theorem (a mathematical sketch follows).

```lean
theorem CzSlOly : (∀ a b : M, (a * b) * b = a) → 
    (∀ a b : M, a * (a * b) = b) → (m n: M) → m * n = n * m := by
        intros ax1 ax2 m n
        have lem1 : (m * n) * n = m := ax1 m n
        have lem2 : (m * n) * ((m * n) * n) = n := ax2 (m * n) n
        have lem3 : ((m * n) * m) * m = m * n  := ax1 (m * n) m
        have lem4 : (m * n) * ((m * n) * n) = (m * n) * m := 
            congrArg (fun x => (m * n) * x) lem1              
        have lem5 : (m * n) * m = n := by
            rw [lem4] at lem2
            assumption
        have lem6 : ((m * n) * m) * m = n * m  := 
            congrArg (fun x => x * m) lem5 
        rw [lem3] at lem6
        assumption 
```

Fix elements `$m$` and `$n$` in `$M$`. We obtain the first 3 lemmas that are obtained by substituting various elements of $M$ in the axioms. Thus, we have

* Lemma 1: `$(m * n) * n = m$`
* Lemma 2: `$(m * n) * ((m * n) * n) = n$`
* Lemma 3: `$((m * n) * m) * m = m * n$`

The next lemma is obtained by multiplying both sides of Lemma 1 on the left by `$m * n$`. This uses the property that given an equality `$x = y$`, with `$x, y\in\S$` and a function `$f: S \to T`, we can deduce the equality `$f (x) = f (y)$`. This is called `congrArg` in lean. Thus, we deduce:

* Lemma 4: `$(m * n) * ((m * n) * n) = (m * n) * m$`

So far the statements deduced have been getting successively more complicated. Crucially, in the next step we deduce a lemma whose statement is simpler than the previous ones. Using Lemmas 2 and 4 and the symmetry and transitivity of equality, we deduce

* Lemma 5: `$(m * n) * m = n$`

We now multiply both sides of this equation by `$m$` and obtain

* Lemma 6: `$((m * n) * m) * m = n * m$`

And finally Lemmas 3 and 6 give

* Theorem : `$m * n = n * m$`
