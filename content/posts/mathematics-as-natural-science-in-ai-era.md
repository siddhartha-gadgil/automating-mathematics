+++
title = "Mathematics as Natural Science in the Era of AI"
date = 2026-01-12T06:57:32+05:30
draft = false
tags = []
categories = []
+++

What is mathematics? This is a question those working (or interested) in mathematics return to many times. While this is no doubt an interesting question, its answer has at most a modest effect on the practice of mathematics. However, as we move to an era of mathematics powered by Artificial Intelligence together with Formal Proof Systems (such as the Lean Prover), how one views mathematics becomes significant.

To me mathematics has always been part of *natural science*, both during the many years when I was primarily a mathematician, and in the last few years when I have focussed more on automating mathematics. By this I don't mean that the goal of mathematics is only to answer questions in say physics or biology. Rather, *natural science* is defined by theories that are (ultimately) *empirically* validated, and mathematics can be viewed in the same way. Over the years, my understanding of how to view mathematics within natural science has evolved (including, somewhat surprisingly, from my years immersed in software development).

This is by no means the unique view of mathematics and may not even be the most common one among mathematicians. An alternative view is one that can be roughly considered the *cultural* view of mathematics. Perhaps the most common view in practice is a combination of the natural science and cultural views. While one's view has not mattered much yet, it does so when adapting to a world with powerful AI. For those who take a natural science view the coming era of AI coupled with formal verification with the Lean Prover (or similar systems) is a great opportunity, though a lot of work will be needed to make the most of this. Others may view AI as a peril.

## Mathematics as Natural Science

Natural science is the body of knowledge that has been verified empirically, i.e., through experiments or observations. There are always subtleties -- even Newton's laws of motion do not hold precisely due to relativistic effects and Darwinian evolution is complicated by lateral transfer of genes in bacteria. Yet it is generally clear whether or not something meets the criteria of being natural science.

A lot of engineering also can be considered natural science, with a device that is built working as expected being a form of empirical verification. What is not natural science is any "knowledge" whose acceptance is based on authority -- whether that of an individual, a tradition, or a book.

Mathematics is apparently based on formal verification -- logical deduction from axioms. But in reality we do not consider random axioms or rules of deduction, but choose them carefully to model nature. Plenty of conclusions from mathematical reasoning go into predictions of experiments and observations as well as the making of devices, so each instance when observations are as expected and devices work as specified is an empirical test of the correctness of our rules for mathematical reasoning. So the foundations of mathematics have passed a mind-boggling number of tests.

While empirical tests can define what is accepted, not all that is correct is interesting or of value. In science we do not want simply a catalogue of observations but theories that can explain a large range of observations from basic principles. In engineering we don't merely want devices that work as specified, but ones that are of use. It is less obvious what we do or don't want in mathematics, and indeed this is to some extent subjective.

The view I take is that mathematics is the result of *abstraction* from natural science, and what is of value can be judged in this light. I emphasise that I do not mean that closeness to the empirical is the primary criterion we must use, but rather that the distance from the empirical should be compensated by depth and other measures of quality.

## Abstraction and Knowledge

Knowledge beyond a cataloguing of facts depends on *abstraction*. Abstraction is the hiding away of details that are not relevant to what we seek to understand and considering only the essential features. This is sometimes at the cost of simplifying, or taking an ideal model of, what we are studying.

Thus, Newton's laws of motion can be used to calculate the trajectory of a point-mass. When studying a point-mass we are ignoring a lot of irrelevant features, such as the colour, material and geographical location of the body. We are further ignoring the size and shape, which do affect the trajectory, as their effect is small.

In chemistry, we abstract less as the chemical composition, temperature and other factors are relevant. But we still ignore most things -- for instance the date and geographical location of the reaction and who performed an experiment.

Abstraction is done most explicitly in working with modular systems in engineering, for instance in software engineering. For example, when processing data we abstract the source as a *data stream*, hiding away whether this is loaded from a drive, streamed over the internet or input by the user. More sophisticated software goes further -- for instance we can *map* (i.e. transform elements of) a collection regardless of the nature of the collection.

In all these cases, we abstract by specifying the properties of our system that we are concerned with and studying the system (or its idealised version) in terms of those properties. This has many advantages -- what we deduce applies to all systems for which the abstraction is valid, and our attention is focussed on what matters for the questions at hand.

In mathematics, we turn things on their head and consider *fully abstracted* systems. Thus, rather than saying that we study systems in terms of the properties of their idealised, abstracted forms, we *define* our objects of study as those satisfying some properties (or *axioms*) and think of these as real objects.

The first level of abstraction, as sketched above, does not truly take us to mathematics -- this is more likely to be considered, for instance, mathematical physics or mathematical biology. We can however, go much further than abstracting a single system and consider *common abstractions* across a range of (perhaps already abstract) systems. A simple example of this is addition of numbers -- the abstract fact $3 + 4 = 7$ applies to counting sheep as well as windmills. At a more subtle level, symmetries found in many contexts give rise to *group theory*, a *random variable* can represent the height of a tree or the temperature in Bangalore, and an *integral* can be the area of a region or the probability of an event.

In mathematics each new abstraction is thought of as giving real objects, and we build towers of abstractions. This is a powerful way of advancing knowledge. The obvious advantage of such abstraction is that any knowledge of the abstracted system applies to all the concrete systems of which it is an abstraction, or to all systems at one level of abstraction lower. But there are more interesting benefits. In many cases the intuition from one concrete case guides the constructions and statements we make in the abstract setting, which can then be applied to a different concrete case. Indeed there have been many waves of this kind of *transfer* from geometry to number theory. As a variant we can combine intuitions from many concrete settings.

Roughly speaking the word *deep* for a piece of mathematics is used for a result well below the surface (i.e., high level of abstraction) but that connects to a range of results closer to the ground (lower levels of abstraction). Saying a result is deep is perhaps the greatest complement one can give.

*Abstraction Boundaries* between mathematics and nature and across layers of mathematics are given by *definitions* and *theorems*. Thus definitions tell us when a collection of results is applicable -- for instance for independent random variables, while theorems let us use there conclusions so long as the hypothesis are satisfied. The proofs of the theorems and the many auxiliary constructions and lemmas are details that are hidden away.

## Evolution and Measures of Mathematics

The value of a theorem is greater if its statement is simple and general and if its proof is hard. A harder proof makes the theorem more valuable because an easy proof can be discovered as and when the theorem is needed. Further, a proof is more valuable if it is hard because of unexpected connections between areas rather than just length, and also if it has ideas that can be used to prove other theorems rather than ad hoc ideas that apply in only the specific case.

Simplicity and generality of a theorem makes it more likely that the theorem will apply in a given case, if only because there are fewer simple statements than complex ones. Further, even if the statement itself does not apply, the proof is more likely to lead to ideas for other proofs.

Besides such general principles, the value of a theorem depends on its subject and content, and their relation to the empirical. An ideal theorem is one that is about a common abstraction of many concrete cases, and is significant for many of them. An example of such a result is the Central limit theorem. However, such theorems are few and far between. Further, one has to judge the value in terms of not just known but potential applications. While we cannot predict potential applications, we can come up with general criteria as proxies. A working mathematician then simply works with these.

Introducing mathematical structures by abstracting from the empirical is only one way in which mathematics evolves. Indeed, once freed by abstraction of the constrained of the empirical mathematics has infinite room to grow. Even if one does not care about the empirical, just avoiding an uncontrolled explosion of mathematics compels us to measure the value of a piece of mathematics and to prune (or at least discourage) that of lower value.

When a mathematical structure or object is introduced by abstraction, important questions about the concrete object give important questions about the new abstract structure. Here and elsewhere, concrete only means one level lower in the tower of abstractions, and may still be far from the empirical.

In addition, there are basic *natural* questions we study concerning any mathematical structure, such as classification of such structures. These are considered important in mathematics. This is reasonable as answers to these natural questions are relevant in answering almost any other question.

The evolution of mathematics following these lines does not stray too far from the empirical. Each abstraction layer can be considered a move away, and hence questions about that layer are of diminished importance. On the other hand, each common abstraction, especially of superficially different systems, is of significant value, so knowledge of common abstractions can (sometimes) be considered of more value than that of the concrete systems. A balance, partly subjective, gives some measure of the value of a piece of mathematics.

However, much of the evolution of mathematics takes different steps. While addressing a question (which has been previously agreed as fundamental) we may end up with various situations. One of these is that we come up with a technique that applies in some special cases. Then we consider those objects where the technique applies as an interesting class in itself and split our questions into studying them given the condition and studying when the condition arises. A variant of this is that a technique works provided some other statement is true. Then understanding when that statement is true becomes a new goal.

As properties, questions and goals accumulate, the relations between different properties gives another set of goals. When the basic goals are too hard, we specialise to a class of objects for which they are easier. This then becomes a new class of mathematical objects to study. We can then abstract or generalise these in different directions, getting a new class of structures. We may even find common abstractions with structures that arose from a different context.

Thus, we have a process of abstraction, techniques, auxiliary properties and questions and specialisation that leads to a steady drift away from the original question. Sometimes this leads to techniques or common abstractions that apply elsewhere, which is indeed valuable. Other steps should be considered a drift away from the empirical, and theorems further along this path should be considered of lesser value.

One may wonder whether it is worth going down this path at all, since it seldom happens that some advance far down the path travels all the way to the empirical. Yet, in the real world advances happen typically through many steps that form an *intellectual scaffolding* or *ecosystem of ideas*. Almost all of them will never be a component of something with an impact on the empirical, but the profound ideas, some with enormous impact, cannot arise in isolation. This is true not just of mathematics but innovation and product development in all areas. Thus, to quote Frank Tibolt, "Action always generates inspiration. Inspiration seldom generates action".

Yet, one must be a bit wary of drifting too far from the empirical, as Von Neumann famously warned. The nature of academia is that a path once taken acquires a momentum of its own that often keeps it alive far too long.

## Alternative views

A quick summary of my views above is that the value of mathematics lies in depth (and difficulty) and closeness to the empirical, and if depth (together with difficulty and other virtues) makes up for distance from the empirical one can argue that the result has value greater than many directly empirical result. However, a second *cultural* measure is often used in part to argue for the value of a result, namely the relation to questions studied by other mathematicians (sometimes even centuries ago).

That a question was previously asked, so is an *open problem*, is a good measure of difficulty. I have argued that difficult results are more valuable. Thus, cultural criteria are not too different from empirically derived ones. Further, almost nobody goes purely or even primarily by cultural criteria.

However, as we enter the era where proofs are generated by AI (with Lean), it has become common to claim that the role of mathematics is *human* understanding, rather than advancing scientific knowledge. Indeed this is often stated as if it is an axiom or law of nature, or at least that everyone agrees on this -- the former is absurd and, as for the latter, I at least disagree. As I said this is a subjective opinion and not something to be debated. I will instead continue discussing mathematics as a natural science and the potential of AI for this.

## Mathematics in the era of AI

There is growing evidence that AI systems with Lean Prover used for verification will soon solve problems harder than most mathematicians today can solve. This will create problems for credit attribution, which is central to how mathematics is organised today. Further, solving hard problems or open problems will lose its prestige.

A natural response to this is to move closer to the empirical, so that it is the value of what we solve that will matter more than who had what role in solving it. In my view this is the best response to AI across many fields -- raise ones ambition, accept that present measures of prestige are endangered, and focus instead on actual value.

To understand the impact of powerful mathematical tools, we look at the present relation of mathematics with the empirical. There are two ways in which the applicability of mathematics to natural sciences is limited. The first is that when we abstract a natural system to a mathematical structure, we make assumptions and approximations. The assumptions need to be empirically checked, and where approximations have been made conclusions should be used with care. Even in these cases, abstracting to mathematics has value, cleanly separating assumptions and empirical observations from deductions.

Perhaps somewhat surprisingly, in systems where a mathematical abstraction is an excellent approximation, the basic questions at times translate to mathematical questions that are too hard to solve. A famous instance of this is the Navier-Stokes equations governing fluids. Other examples are Ising models and Percolation from Statistical Physics -- progress on these has led to three fields medals, but only the simplest cases are fully understood.

When the limits of solving mathematics are reached progress continues through various other ways -- experiments, simulations, techniques to approximate or simplify the mathematical system etc. Mathematical proofs offer a level of certainty that these methods cannot, and also illuminate understanding in other ways such as making explicit the conditions for applicability.

Somewhat parallel to this is the situation in many aspects of engineering -- software, chip design, networking protocols etc. Here too we have a specification that can be given in mathematical terms, and often that the implementation meets the specification can be viewed as a mathematical statement. The proof of such statements is rarely deep but often tedious and time-consuming. As a result checking correctness is done by *testing*. However, in a growing number of cases *formal methods* -- mathematical proofs found with computer assistance and verified by a computer are being used. With developments in formal proof systems as well as help from AI, formal proofs are becoming easier. They are also becoming more important as *vibe coding* can lead to errors. Thus, we see a steady expansion of the frontier of formal methods, with hoping for the best with tests being replaced by a much greater certainty with proofs.

As AI and Lean allow mathematical proofs beyond our present levels, one can hope for an era where the frontier of mathematical proofs can advance, steadily leading to more complete mathematical theories across many fields, from protein folding to plasmas for fusion.
