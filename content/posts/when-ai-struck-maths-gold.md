+++
title = "When AI struck Gold at the Maths Olympiad"
date = 2025-10-09T08:50:40Z
draft = false
tags = []
categories = []
+++

The International Mathematical Olympiad (IMO) is arguably the leading mathematical problem solving competition. Every year, high school students from around the world attempt 6 problems over the span of 3 hours. Students whose scores cross a threshold, roughly corresponding to solving 5 of the 6 problems, obtain Gold medals, with Silver and Bronze medals for those crossing other thresholds. The problems do not require advanced mathematical knowledge, instead testing for mathematical creativity. The problems are new and it is ensured that no similar problems are online or in the literature.

IMO 2025 had some unusual participants. Even before the olympiad closed, OpenAI, the maker of ChatGPT, announced that an experimental reasoning model of theirs had answered the Olympiad at the Gold medal level, following the same time limits as the human participants. Remarkably, this was not a model specifically trained or designed for the IMO, but a general-purpose reasoning model with reasoning powers good enough for an IMO Gold.

The OpenAI announcement raised some issues. Many felt that announcing an AI result while the IMO had not concluded overshadowed the achievements of the human participants. Also, the Gold medal score was the result of grading by former IMO medalists hired by OpenAI, and some disputed whether the grading was correct. A couple of days later, however, another announcement came.

Google-DeepMind attempted the IMO officially, with an advanced version of Gemini Deep Think. Three days after the Olympiad, with the permission of the IMO organisers, they announced that they had obtained a score at the level of a Gold medal. Indeed, the IMO president Prof. Gregor Dolinar announced : “We can confirm that Google DeepMind has reached the much-desired milestone, earning 35 out of a possible 42 points — a gold medal score. Their solutions were astonishing in many respects. IMO graders found them to be clear, precise and most of them easy to follow.”

Over the next few days, some more AI systems announced their successes. While not as powerful, these systems were significant in other ways as we see below.

My goal here is to assess the significance of this achievement for Mathematical (research level) discovery. To do this, I take a broader look at advances in AI over time. My central claim is that there is essentially one last barrier before AI reaches research level - reasoning at scale. Further, it is quite plausible that overcoming this barrier is only a matter of enough engineering.

## Barriers of AI

Before going back in time, we take a look at the last phase in the evolution of AI to date - the phase between the launch of ChatGPT (powered by GPT 3.5) and the IMO Gold.

### What about Hallucinations?

Even as it became a popular sensation, ChatGPT became infamous both for *hallucinations* (making up stuff) and for simple arithmetic mistakes. Both these would make solving even modest mathematical problems correctly impossible.

The first advance that greatly reduced these errors, which came a few  months after the launch of ChatGPT, was the use of so-called *agents*. Specifically, models are able to use *Web Searches* to gather accurate information, and *Python Interpreters* to run programs to perform calculations and also check reasoning using numerical experiments. These made models dramatically more accurate, and good enough to solve moderately hard mathematical problems. However, as a single error in a mathematical solution makes the solution invalid, these were not yet accurate enough to reach IMO (or research) level.

Greater accuracy can be obtained by pairing language models with *Formal Proof Systems* like the *Lean Prover* - computer software that can understand and can check proofs. Indeed, for IMO 2024 such a system from Google-DeepMind called *AlphaProof* obtained a silver medal score (but it ran for 2 days).

But the breakthrough came with so-called *reasoning models*, such as `o3` from OpenAI and Google-DeepMind’s `Gemini-2.5-pro`. These models are perhaps better described as *internal monologue* models. Before answering a complex question, they generate a monologue considering approaches, carrying them out, revisiting their proposed solutions, sometimes dithering and starting all over again, before finally giving a solution with which they are satisfied. It was such models, with some additional advances, that got Olympiad Gold medal scores.

Two other systems did follow the formal proof approach using the Lean Prover. Harmonic's system Aristotle also reached Gold medal level. Another system Seed prover from ByteDance reached Silver medal level on running for three days, and with extended time reached gold medal level.

A different successful approach was taken by Yichen Huang and Lin Yang, who built a pipeline with models sketching proofs in stages, then running through a loop with the model checking its own proof and pointing out errors. This was repeated till the model accepted a proof without asking for fixes five times in a row. Running this with each of Gemini 2.5 Pro, GPT 5 and Grok 4 solved 5 out of 6 problems, i.e., a Gold medal score. These are publicly available models.

### Symbolic AI : AI from Algorithms and Data Structures

The dominant approach to Artificial Intelligence from 1950s to about 2012 was so called *Symbolic AI*. Symbolic AI involved encapsulating knowledge in precise rules or facts, encoding them to be efficient to lookup and combine, and efficient ways to deduce from given knowledge. In some sense, there is no clear line between Symbolic AI and *Data Structures and Algorithms* at the core of computer science.

Symbolic AI lead to powerful techniques such as Chess Engines that could beat the best human players and mathematical deduction systems like SAT solvers and Resolution theorem provers that could answer some mathematical questions beyond human reach. But not only did they fail at many tasks like playing Go and recognising images, even in the tasks for which they succeeded they had measurable limitations in contrast to humans. For instance, a chess Grandmaster can instantly judge whether a board position favours white or black, a task which (symbolic AI style) chess engines cannot do with much accuracy.

### Deep Learning: Breaking the tacit knowledge barrier

#### Tacit knowledge

Tacit knowledge (a term coined by Michael Polanyi) is knowledge that we possess but cannot fully articulate ("We know more than we can tell" to quote Polanyi). This is acquired through personal experience and interactions. This includes (or at least, apparently includes) many common skills, such as riding a bicycle and speaking a language (at the level of a native speaker).

In mathematical terms, a plausible explanation is that the functions ("algorithms") that describe these actions are defined by an enormous number of parameters, which are tuned through experience. Further, the function cannot be described (or even very well approximated) by a short program, i.e., has *high Kolmogorov complexity*. The capacity of speech or any other communication channel we use is tiny compared to the capacity of the brain and is inadequate to communicate all the parameters of the complicated function, even after compressing it as much as possible.

Symbolic AI was based on the idea that with efficient enough representation we can in fact encode all relevant knowledge, and that this is what the brain does (so tacit knowledge is only apparent). The failure of Symbolic AI at many tasks at which deep learning excels is empirical evidence that this is false. But some symbolic AI champions have re-branded as *AI sceptics* repeatedly claiming that AI has hit a wall (always a few metres beyond where it is just then) and only encoded human knowledge can let it make progress. Unfortunately such people are taken seriously and there is even an obligation to invite them to debates for *balance*, though by the criteria of science (the test of theory is observations) they should have long been condemned to oblivion.

#### Deep Neural Networks and Supervised learning

The Deep learning era began when a deep learning model performed at a classic image recognition benchmark called *MNIST* at a level far above what had been seen before, mostly with symbolic AI models. While this was remarkable and started a revolution, in some sense it was a glorified version of regression from Statistics powered by new rockets - GPUs.

A deep neural network is a composition of functions each of which is a linear function composed with a simple fixed nonlinear function (for example a sigmoid). The parameters are the coefficients of the linear functions - *weights* determining the matrices and a constant term the *bias*. Such a function can be *trained*, i.e., fit to data, efficiently using *backward propagation* - a consequence of the chain rule in Calculus.

Much as linear models in Statistics were heavily used last century because they were easy to fit and at the same time matched a lot of data and natural systems, deep neural networks are useful because of their generality as well as trainability. Of course they are much more general than linear models, and need much more compute to train. Hence it was only with the improvements of hardware, specifically the advent of GPUs, that this became practical.

### Breaking the Data & Narrowness Barriers: Reinforcement Learning, Representation Learning, Transfer Learning

The first successful deep learning networks were trained using *Supervised Learning* - fitting coefficients to data. This meant that they were limited:

* They could only be trained for tasks for which there was enough data.
* They could only perform one task well - the one for which they were trained.

#### Representation Learning

A major advance came with *Word2Vec*. Before Word2Vec words were treated as unit vectors, with the only relation being equality. This was part of the reason why neural networks performed more poorly in linguistic tasks as against those involving images - images had more meaningful representations attached to them.

In Word2Vec, words were mapped to vectors in a space with the intention that geometry captured meaning. This was done by trying to predict from the vector representing a word which words were its neighbours (using a classical linear algebra based method called *Support Vector Machines*). The vectors associated to words ("representations" of the words) were optimized to predict the neighbours. The map to the representations was taken as the first layer of tasks we actually wanted to solve - such as understanding the sentiment in a sentence.

At a higher level, the pattern followed by Word2Vec (after some generalisation) is:

* First learn a representation of the data that captures meaning.
* To do this, train for a task for which you can easily generate a lot of synthetic data, even if the actual task is of no value.
* For the actual task, use a neural network consisting of the already trained representation followed by another one which we train.

These ideas can be (and were) extended in many ways. For instance, to train for many tasks with the same input we use neural networks with the first few layers in common. Also, we have neural networks for some tasks with a middle layer having lower dimension, so that the network when optimized has to compress information, leading to the information being more semantic at that level.

All this can be viewed in the broader sense as separating *understanding* the data from *answering* for a specific task. The understanding part then can be common to many tasks, and can be acquired by *playing* - performing tasks which we don't actually need but are good for learning.

Needless to say, where I have used the word "understanding" many will object that neural networks do not "truly understand". Sure, and electrons do not truly orbit about the nucleus. This blog is written in the spirit of science and engineering - what matters is what we observe and what works. This is not to say that parts are not wrong - they may well be because of my ignorance. Just that "wrong" in any sense that is irrelevant to what we observe and what we build is of no significance to me.

#### Reinforcement Learning

For games such as Chess and Go, data can be generated simply by playing against oneself, in addition to the data that is available from games on the internet for instance. The first version of AlphaGo used both these forms of training. A network was initially trained to predict the next move that will be made by an expert player in a given situation. Note that any actual board situation is almost certainly new to the system, so prediction here means a good function interpolating the moves of the experts, including semantic representations of the state of the game.

After learning to imitate expert, AlphaGo played against versions of itself to the end. From which version won a *value* function, predicting how good a position was, was learnt. In addition a *policy function*, suggesting what moves are most promising, was learnt. These used a common representation (in the spirit of representation learning). The framework of policy and value is a useful way of thinking of mathematics too.

AlphaGo not only beat the best players in the world, but showed originality in a precise and objective sense. In its second game with Lee Sedol, its 37th move greatly surprised both Lee Sedol and the human commentators. Further, by AlphaGo's own calculations the probability that an expert would have made that move was 1/10000.

AlphaGo was succeeded (and beaten) by AlphaGo Zero and AlphaZero, which were trained with *zero data*, simply by playing against themselves. The latter could play other board games and became the best chess playing entity on the planet (the previous best being a program Stockfish, computers long having gone beyond the best humans). To quote Kasparov, Alphazero "has a dynamic, open style" and "prioritized piece activity over material, preferring positions that looked risky and aggressive."

### Transformers and Pre-training

AI was revolutionized by the *Transformer architecture*, which was motivated as a technical advance allowing training in parallel, hence at a much larger scale. As it turned out, this architecture also overcame another limitation - allowing long-range dependencies to be captured.

Pre-training with the transformer architecture can be taken as an extreme version of the idea of representation learning, spend a huge amount of effort in understanding everything and mapping it in your mind to capture meaning. Solving a given problem should then be straightforward. This sounds a bit like the Grothendieck philosophy that looking at any problem the correct way should make it trivial.

Indeed, this push to working at the understanding level was clearly too extreme, and a lot of the advances have come from *test time compute*, i.e., working for specific problems when you need to solve them.

### A Snapshot: Twin Peaks

If we look at AI in the middle of 2024 say, the most famous model was ChatGPT, by then running on the much improved GPT-4 and with agents. It still hallucinated. It could reason using analogy and composition together and flexibly, so its answers could be obtained by combining analogues of widely different sources seamlessly. This gave it some degree of originality, though there was some bound on its novelty. Also it still made mistakes.

On the other hand, AlphaZero and such systems based on Reinforcement learning were around. They were undoubtedly original, had deep understanding of a system, and did not generally make silly mistakes.

What was needed was a system that could do what Pretrained Transformers did along with what RL systems did. My own guess at that time was that each of these systems were trained to the limits of what was physically possible, and with very different kinds of training. Combining them would need a product of the resources, which would just not happen.

Evidently I was wrong. Some combination of better ideas and more resources allowed Reinforcement Learning for the giant Pretrained foundation models. Also other improvements such as test-time compute were added. With all this, we entered the era of the Olympiad models.

## From Olympiads to Research level Mathematical Discovery

Olympiad problems, for both humans and AIs, are not ends in themselves but tests of Mathematical problem-solving ability. There are other aspects of research besides problem solving.  Growing anecdotal experiences suggest that AI systems have excellent capabilities in many of these too, such as suggesting approaches and related problems. Indeed many of these are part of problem solving.

Further, research mathematics builds on knowledge much more than contest problems. But knowledge is something at which AI excels, so this difference actually favours AI.

However, the crucial difference between problem solving and research/development is scale. Research involves working for months or years without errors creeping in, and without wandering off in fruitless directions. We will return to this. Before that, we briefly look at some of the frivolous objections to AI systems doing research in Mathematics.

### Frivolous objections: "cannot imagine"s, "justaism" and moving goalposts

Many of the objections to AI's doing mathematics are based on what people "cannot imagine", that LLMs are "just a next token predictor", and through constantly shifting goalposts when AI accomplishes a task and declaring that it is irrelevant. Scott Aaronson has coined the term "justaism", and I cannot do better than quote him.

> GPT doesn’t interpret sentences, it only seems-to-interpret them.  It doesn’t learn, it only seems-to-learn.  It doesn’t judge moral questions, it only seems-to-judge. I replied: that’s great, and it won’t change civilization, it’ll only seem-to-change it!

An interesting sidelight: in the same blog post I quote, Scott Aaronson mentions betting against his friend that an AI system will get an Olympiad Gold Medal by 2026 (the post was a year ago). He was right and with a margin of an year!

What we can imagine depends on our experience and how much we are willing to allow for things going beyond it. Indeed, that random variation and natural selection can lead to evolution from single-celled organisms to dolphins is hard to imagine, and indeed was opposed by many on the "cannot imagine" and ("just ...") grounds. The scale of evolution is enormous and truly so much beyond our experience that one can have sympathy with this view, though we of course accept evolution in spite of it.

While a major result like Perelman's proof of Geometrization, or a major theory like Thurston's conjecturing geometrization, is on a much larger scale than a problem, these arose through a large number of steps each of which was of modest size. As an example (sorry for the mathematics which most readers can read just for flavour), when Thurston conjectured geometrization a bunch of stuff was known that could suggest (at least could suggest to a mathematical genius) such a statement: Waldhausen's rigidity and the closely parallel Mostow rigidity had been recently proved, what became the geometric decomposition is almost identical to the JSJ splitting that had been introduced and shown to be important, the "interesting pieces" had only peripheral tori, which is the case for geometric manifolds etc. And indeed some mathematicians like Peter Shalen had already floated the idea that three-manifolds had geometric structures.

My point is that mathematical discovery is built from many steps, and each step is not so different from problem solving. This does raise legitimate questions of scaling, but claims about discovery involving "true creativity" while problem solving does not don't deserve to be taken seriously.

### The Challenge of Scale

There is no doubt one sense in which an AI system discovering mathematics is fundamentally different from solving problems - it needs to be able to keep working on a much larger timescale while remaining accurate and not drifting too often. Indeed the process of discovery does involve many wrong directions. We need a *policy* - what to try, and a *value* - does the situation look promising, to make sure we do at least some of the time travel in fruitful directions. I would guess that deciding a policy and value is not fundamentally different from problem solving, especially when we know quite explicitly many aspects of mathematical workflow. I return to this after considering accuracy.

At the time of IMO 2024, most people in the business (including me) believed that even scaling to the level of an IMO problem accurately will not be possible without using help from a formal proof system like Lean. This did not turn out to be the case. So at this point I would say that it is possible the AI foundation models will just scale as informal models to research level. I would guess this is unlikely, and in any case a long and complex AI generated informal proof is much less likely to be checked and accepted by human mathematicians.

However, generating a proof, translating it into Lean (Autoformalization) and checking this is something that many groups are working on (including myself) and some like Harmonic AI and Math Inc have shown great success. Indeed, I would conjecture that this will happen, and it is only a matter of enough engineering.

## Conclusion

In my view, with AI systems having reached Olympiad Gold medal level in a robust way, there is only one real challenge to their doing research mathematics, which is working autonomously on a larger scale. The only conclusive proof of this is of course an AI system that is doing research mathematics. But I believe this is largely a matter of Engineering.

### Coda : Do I move goalposts?

As I have given many talks over the years, and said various things about AI for mathematics, honesty demands that I check whether I was also doing the equivalent in the other direction of goalpost-moving, i.e., having the same conclusion with each development supposed to prove this. Here are some conclusions over time (picked from public talks).

* In 2020 (pre ChatGPT when AlphaGo was the best AI): I ended a talk with "Automating mathematics? It appears that there are clear approaches and no evident barriers". A bit optimistic for that time but roughly what I would say about fusion now.
* In 2023, the "twin peak era" - I concluded that there are many complementary approaches to Automating mathematics, and the main goal is to get them to work together, and work together with us.
* In 2024 and early 2025, after `o3` and `Gemini 2.5 Pro`: I suggested the scenario (did not explicitly predict but believed it) that AI would do mathematics at the level of 90% of the mathematics done by 90% of the mathematicians - excluding all top mathematicians and the best work of everyone else.

So I can claim to pass my own test - the strong statements I make here are only after the IMO Gold.
