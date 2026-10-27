+++
title = "Plasmalean"
date = 2026-10-27T10:01:10+05:30
draft = false
tags = []
categories = []
+++

A few months ago (in January 2027) I wrote a blog post [Mathematics as Natural Science in the Era of AI](../mathematics-as-natural-science-in-ai-era/index.html) about using advances in AI to advance mathematics and science. Little did I know then that in a few months the capabilities of AI in mathematics would advance from good to extraordinary. It was time to put the ideas to the test, with a design powered by [LeanLang](https://lean-lang.org/) to allow a mix of autonomous use of AI with human guidance and ideas.

My first quest, in a project [PlasmaLean](https://siddhartha-gadgil.github.io/PlasmaLean/index.html) is to design a kind of fusion reactor called a [Stellarator](https://en.wikipedia.org/wiki/Stellarator). These are reactors with geometry that allows, one hopes, the plasma (fuel) to remain stable for reasonably long. The eventual goal is to prove results that show that plasma remains confined and hot for a certain (explicit) amount of time.

For AI to be able to advance mathematics and science rapidly, we must have a design that allows autonomy as well as high reliability. The design I use builds on ideas that are widespread in Lean verification. I call this design *Swiss Watch Verification*. My second goal with PlasmaLean is to experiment with and refine such designs.

## What is Mathematics?

When I wrote my blog post in January, I said that the question "What is mathematics?" had assumed new importance, and even practical relevance, in the age of AI. Little did I know that this was soon to become contentious, indeed a source of much debate and trolling. What I write in the rest of this post is based on *my* view of mathematics, and all I claim is that this is a coherent view. This has been my view for the three decades or so I have been in the business, though it differs from Mathematics™ as defined by the luminaries of the field.

First a disclaimer. In the rest of this section, I have freely copied and modified from my earlier posts on this blog.

My view of mathematics is as those components of *natural science* that have been *fully abstracted*. The real world is messy, and any such definition will have to common with caveats, so all my definitions are ideals as guidance.

Natural science is the body of knowledge that has been verified empirically, i.e., through experiments or observations. All knowledge beyond cataloguing of facts (so called "stamp collection") depends on *abstraction* - hiding away of details that are not relevant to what we seek to understand and considering only the essential features. This is sometimes at the cost of simplifying, or taking an ideal model of, what we are studying.

Thus, Newton’s laws of motion can be used to calculate the trajectory of a point-mass. When studying a point-mass we are ignoring a lot of irrelevant features, such as the colour, material and geographical location of the body. We are further ignoring the size and shape, which do affect the trajectory, as their effect is small.

Abstraction is done most explicitly in working with modular systems in engineering, for instance in software engineering. For example, when processing data we abstract the source as a *data stream*, hiding away whether this is loaded from a drive, streamed over the internet or input by the user.

In all these cases, we abstract by specifying the properties of our system that we are concerned with and studying the system (or its idealised version) in terms of those properties. This has many advantages -- what we deduce applies to all systems for which the abstraction is valid, and our attention is focussed on what matters for the questions at hand.

In mathematics, we turn things on their head and consider *fully abstracted* systems. Thus, rather than saying that we study systems in terms of the properties of their idealised, abstracted forms, we *define* our objects of study as those satisfying some properties (or *axioms*) and think of these as real objects.

The first level of abstraction, as sketched above, does not truly take us to mathematics -- this is more likely to be considered, for instance, mathematical physics or mathematical biology. We go further by thinking of each new abstraction as giving real objects. We make further abstractions as we study these new objects. These are based on things we discover about them as well as techniques we use to study them. This leads to a tower of abstractions.

This is a powerful way of advancing knowledge. The obvious advantage of such abstraction is that any knowledge of the abstracted system applies to all the concrete systems of which it is an abstraction, or to all systems at one level of abstraction lower. But there are more interesting benefits. In many cases the intuition from one concrete case guides the constructions and statements we make in the abstract setting, which can then be applied to a different concrete case. Indeed there have been many waves of this kind of *transfer* from geometry to number theory. As a variant we can combine intuitions from many concrete settings.

It is the mathematical component, in this broad sense, of science or engineering, that is very well suited to the use of AI guided by Lean verification.

## Lean, Kernels and Swiss-Watch Verification

Unlike mathematics, Science and Engineering are not self-contained. However, we can still have useful formal proofs as we build theories, designs and codebases. Our design for doing this is based on a few core principles.

### Proof Challenges and Stress Tests

A formal proof system can only check that proofs are correct for theorems as they are stated. We have to still ensure that the statement of the theorems and all the underlying definitions are correct. An approach is the comparator style used in Lean - to have an expert check the statements, with the statements using essentially only the standard definitions. This works well for major results in mathematics but is not efficient for (scientific) theory building that will involve many new definitions.

A widely used approach, complementary to the above, is to prove extra theorems that are designed to test the definitions. We can also prove consequences of theorems using a theorem - if the statement of the theorem is accidentally too weak the consequence will not follow.

In PlasmaLean we get the coding agent to generate a large number of such test theorems. We state and translate into Lean such *proof challenges*. These are based on specific instructions designed to stress-test the definitions. These include: proving well-known physical consequences of the basic equations; proving that the expected symmetries are present; proving correct behaviour in special cases; proving characterizing properties; showing non-degeneracy: properties are non-vacuous, invariants are non-constant; and various other properties.

### Small Kernels

If we trust a computer system to test a proof, how do we know the system itself is correct? This fundamental question was addressed by de Bruijn while building his pioneering system **AutoMath** in the 1960s.The idea that he came up with was to separate a **kernel**, which checks correctness of proofs, from the rest of the system: the parts that help find proofs, provide interfaces etc. An analogue of the kernel is the part of a chess engine that checks whether moves are legal and whether we have a checkmate - much less code than the part that actually makes smart moves.

The kernel has to be checked manually. However, if the kernel is relatively small, well-documented, and (these days) open sourced, one can hope that it has been checked by many people. Having such a kernel is now called the *de Bruijn principle*.

We adapt this principle to our scientific and engineering problem, separating the core governing equations into a kernel. In the case of PlasmaLean these are the equations of MagnetoHydroDynamics as well as the basic geometry of a stellarator. This is a modest amount of code (a few hundred lines) which in principle can be checked manually.

In practice, even checking a kernel manually needs expertise and work. While this needs to be done at some stage, during exploration and library building we check the definition by generating a large number of proof challenges.

### Swiss Watch Verification

In a mechanical movement of a swiss watch, power flows from the mainspring through a train of gears. If a single tooth on a single wheel is off by a few microns, the gear train jams completely. And if two gears have malformed teeth, they don't cancel out unless by an impossible miracle a burr on one tooth matches a corresponding notch on the mating tooth at the exact phase of rotation. So a watch ticking is a test that all its gears are correct to a high degree of accuracy.

Analogously, when we formalize in Lean 4, every lemma's output type must mesh tooth-for-tooth with the next theorem's input hypothesis. A single hallucinated sign or missing regularity assumption jams the movement immediately. Two errors can only cancel if they match exactly. Further, a definition or theorem is often used in many places, so it will be accepted only if we have matching errors in all of them.

Indeed, our level of verification is better than that suggested by the analogy. A swiss watch has only enough gears for its function. But by generating proof challenges we have more "gears" that are only there to jam the system in case of errors.

It is not enough that a swiss watch ticks - there are a bunch of additional tests needed to test the *escapement*. These are analogous to checking our kernel. Again, in Lean we have a situation that is better than the analogue - we can generate proof challenges to test the kernel - extra accessories that are added just to jam the escapement in the case of an error. Again, matching errors in the kernel and in the statement of all the relevant proof challenges are possible but very unlikely.

## PlasmaLean: Geometry of Stellarators for Fusion

[PlasmaLean](https://siddhartha-gadgil.github.io/PlasmaLean/index.html) is built by coding agents based on instructions in markdown (i.e., text) files together with some Lean code that I wrote as a sample. One of these is a file explaining the structure as I have done in the blog. Many others are notes and skills that were AI generated after explaining the philosophy and based on the literature. Lean code has been built from this.

The instructions from which the code is built were generated with some mathematical guidance. For instance, I realised that with PDEs getting rigorous numerical bounds with interval arithmetic cannot be done naively (as with say polynomials) but needs some theorems, for instance comparison theorems. When prompted AI sketched a few techniques from the literature and wrote implementation instructions for this. They got into the act.

When I first began this project (on October 10, 2026) I was ignorant of some basic facts about Stellarators. I asked for a design that made sure, with proofs, that Plasma remained confined. Fortunately a colleague Animesh Kuley from the Physics Department of IISc, who is an expert in fusion contacted me and shared some papers. From these I learnt that the plasma not only has to be confined but also has to remain hot enough, and *microturbulence* can cause it to cool down. Meanwhile my friend and colleague Vamsi Pingali, an expert at Geometric Analysis, gave me a whole host of ideas inspired by results and techniques from a range of fields from Navier-Stokes to General Relativity and many others. These were made into notes to be tossed into the witches brew.

As I post this my agents are brewing for a day or two a week. Fortunately my employer for my sabbatical year, Emergence Research, let me use their tokens for Claude (and Codex), but both me and Claude brew other things (of a broadly similar nature but more applied and less ambitious) on weekdays. Some stellarators have been designed but a practical one is some way off and a lot of the theory has to be digested and incorporated. But then, this project is only 15 days old.

Needless to say collaborations of all kind are most welcome to this open source, and open, project.
