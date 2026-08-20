+++
title = "Lean Kernel Bugs and Junk Values"
date = 2026-08-20T08:47:27+05:30
draft = true
tags = []
categories = []
+++

As *vibe coding* and AI generated proofs have proliferated, the Lean Prover has become a common tool to verify correctness. While it is undoubtedly advanced technology, Lean is not magic and cannot perfectly guarantee correctness. What Lean can do is allow a high degree of confidence after a modest amount of verification.

This post is my reflections on how much confidence we can have in something verified by Lean, and what has to be verified to get this level of confidence. Roughly speaking our confidence depends on *trusting the kernel* and *verifying definitions and statements*. These reflections are motivated by recent events (in August 2026) and discussions at a conference in early August 2026, which suggest that both these aspects are more complicated than one would ideally like.

Thus, individuals will have to be more cautious than one would ideally like, at least at the present juncture, when trusting Lean proofs to what I would consider the ideal level. There is also work to be done to raise the level of trust. Fortunately, it appears that there is willingness to do the work.

## Trusted Kernels

If we trust a computer system to test a proof, how do we know the system itself is correct? This fundamental question was addressed by de Bruijn while building his pioneering system **AutoMath** in the 1960s.The idea that he came up with was to separate a **kernel**, which checks correctness of proofs, from the rest of the system: the parts that help find proofs, provide interfaces etc. An analogue of the kernel is the part of a chess engine that checks whether moves are legal and whether we have a checkmate - much less code than the part that actually makes smart moves.

The kernel has to be checked manually. However, if the kernel is relatively small, well-documented, and (these days) open sourced one can hope that it has been checked by many people. Having such a kernel is now called the *de Bruijn principle*.

### Expressiveness, Verification, Automation

Any formal system, for humans or computers, is based on a formal language and logical rules. In the case of the "official" foundations of mathematics, *First-Order Logic* (FOL) gives the language and rules for deduction, with the axioms of *Set Theory* as the starting point for mathematics.

For proof systems based on FOL a trusted kernel is indeed small - a few hours of work may be all it takes to write one. Simple logical systems also allow for powerful automation. However, writing even moderately complex mathematics in such a system requires an enormous amount of code.

More complex logical systems are more *expressive* - allowing us to write more complex mathematics (or programs) reasonably concisely. However, verification is no longer so easy (and automation is also harder). There is a range of possible logical systems, including FOL, Higher Order Logic (HOL), and Calculus of Inductive Constructions (CIC). 

Lean uses the Calculus of Inductive Constructions, which is expressive but complex. To make programming and proving easier (i.e., to increase expressivity), Lean adds features to CIC such as *proof irrelevance*, *mutual inductive types* and *nested inductive types*.

Fortunately, it has been proved that these differently foundational systems are essentially equivalent (essentially because consistency of Lean assumes some large-cardinal axioms). However, as a consequence, Lean's kernel is not that small and is fairly complex - amounting to a few thousand lines of code (to the best of my knowledge). This is of course much smaller than Lean as a whole, and so there is indeed an enormous gain in terms of what needs to be verified. But verification of Lean's kernel is far from trivial.

### Multiple kernels

Being aware of the danger of kernel bugs, Lean's creator Leo de Moura has long advocated for a way to strengthen the *de Bruijn principle* by having multiple independent kernels. There were three independent kernels for Lean 3 - one extracted from Lean, one written in Haskell, and one (trepplein) written in scala. With the advent of Lean 4 (the present version, and likely to be the version for many years to come) these no longer worked. So an independent kernel in Rust, Nanoda, was (commisioned and) implemented, along with documentation to write more kernels. Writing other kernels was facilitated with the *Lean kernel arena*.

In addition, an important effort was `lean4lean` an implementation of Lean in Lean due to Mario Carneiro. This included an independent kernel. An effort is ongoing to verify correctness of the kernel.

Thus, Lean code can be checked against multiple kernel. The hope is that this will not pass all of them if incorrect, as that will mean independent implementations have bugs in exactly the same place.

Unfortunately, the chance of coinciding bugs is not as small as one would like. Firstly, part of `lean4lean` is not really independent as it borrows code from Lean itself. There is no such danger with a Rust implementation. However, bugs are most likely to appear in the most subtle parts of the foundations, so the locations of bugs will still be correlated.

### Trepplein times

Trepplein is an independent type-checker for Lean 3 written by Gabriel Ebner in scala. Since I knew scala well and was also reasonably familiar with Lean-like foundations, I volunteered to try to port this to Lean 4. Unfortunately I did not finish this, but I learnt some things along the way. I should clarify that all this was some years ago, before we had AI chatbots, leave alone coding agents.

Lean has an export format which is easy to parse. The code in Lean is exported in this format and independent type-checkers parse this and check correctness. The core of porting trepplein to Lean 4 involved supporting those features in the foundations of Lean 4 that were not present in Lean 3.

After completing some relatively minor tasks, such as supporting *literals* for natural numbers and strings, I ran into a big challenge. Lean 4 had (as part of its foundations) *nested inductive types*, which were complex. Fortunately, over a long [Zulip Conversation](https://leanprover.zulipchat.com/#narrow/channel/270676-lean4/topic/Complicated.20induction.3A.20documentation.3F/with/396819352), Mario Carneiro explained these to me and cleared some of my other misunderstandings. Indeed it turned out that there was no documentation for these, and my best source was reading the code of `lean4lean`.

After managing to handle nested inductive types, at least to the extent of working with some code that used these, trepplein still failed to pass its tests. At the core of checking correctness of Lean programs is *type checking*, which in turn depends on checking for *definitional equality*. My port of trepplein failed to check a claimed type, which in turn was because it failed to accept a definitional equality.

To my surprise, I learnt that definitional equality and type checking were not *algorithmically decidable*. Roughly speaking, two terms (Lean objects) `x` and `y` are definitionally equal if we can make finitely many allowed substitutions of given forms (corresponding to "basic" definitional equalities) to transform `x` to `y`. We can naively keep making allowed substitutions starting from `x` and see if we reach `y`. There are only finitely many allowed substitutions at each stage, so if `x` and `y` are definitionally equal we will be able to show this eventually.

However, `x` and `y` may not be definitionally equal, so we have to stop our search at some stage. To get an algorithm we need to know how long we need to go on before giving up, or have a different half-algorithm to show inequality, or have some other conceptual approach. As proved in Mario Carneiro's thesis, there is no such algorithm.

In practice, this means that some additional criterion has to be introduced for giving up, and the behaviour of the type-checker depends on this. In the case of trepplein (as implemented by Gabriel Ebner) there were actually configurable timeout parameters. Perhaps changing these would have allowed me to proceed. But at that time I got overwhelmed by the complexity and did not understand things as clearly as I do now, and so abandoned my efforts.

I should emphasise tha this is not a soundness issue - we only need an algorithm for type checking so that if it is accepted that `x` has type `A`, then indeed it does. If `x` has type `A` but the checker things it does not, then we will fail to prove something, weakening the prover. We will, however, not prove a false statement.

### Kernel bugs

### Verified kernels and `lean4lean`

## Statements, Definitions and Junk Values

### Examples and Corollaries

### Junk values
