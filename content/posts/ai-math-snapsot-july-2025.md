+++
title = "AI for Mathematics: A Snapshot (July 2025)"
date = 2025-07-19T04:15:41Z
draft = false
tags = []
categories = []
+++

Artificial Intelligence in Mathematics has advanced at such a rapid pace that anything we say becomes obsolete soon (see the note below for this happening with this post :smile:). But it is useful to take snapshots. This is one based on my knowledge, understanding, and opinions (though opinions that I hope are empirically grounded).

A good starting point to understand the capabilities of Artificial Intelligence systems in doing mathematics is the International Mathematical Olympiad 2025, for which *MathArena* did an independent assessment. Their assessment was for publicly available LLMs, not mathematics specialized systems like *AlphaProof* from Google-DeepMind. Their verdict: ["Not Even Bronze"](https://matharena.ai/imo/). 

That may sound like a defeat for LLMs, but the best LLM Gemini-2.5-Pro got a score of 31%. So I would add -- not even a Bronze Medalist, but clearly smarter than me (and perhaps most working mathematicians). Further, the IMO problem setters will ensure that these problems are not already online, so clearly LLMs are doing more than searching on the internet and copying. That LLMs can solve problems they have not seen has been obvious for a while for any of us who have spent even a modest amount of time with LLMs (and are not highly prejudiced). On the other hand, it is  clear while Terry Tao is not that impressed by LLMs -- he got a bronze medal at age 10:smile:.

**Note:** As I wrote this, there was an [announcement](https://x.com/polynoamial/status/1946478249187377206) from OpenAI that an experimental reasoning model had obtained a Gold Medal level score, working with the same conditions and time limits as human participants. There are rumours that a second system also got a gold.

However, the important questions as far as I am concerned are whether, and how, AI can help with (or autonomously produce) *Mathematical research*. LLMs are in some sense *purely intuitive* systems, so most people expect that AI systems for mathematics will have components other than LLMs, such as *Formal Proof Systems* like Lean. Indeed many of the best systems around today are hybrid systems in this sense.

## Research versus Problem Solving

Mathematical research is of course different from Olympiad style problems. In one sense this favours LLMs, as *knowledge* is a key component for research, besides problem solving abilities. Not only do LLMs have vast stores of knowledge, modern *agentic* AI systems are also good at searching the web and using the knowledge they find on the fly. They also can (and do) use Python interpreters to run with numerical computations to verify their reasoning.

On the other hand, research is typically not a *one shot* attempt that goes straight to the solution, but an accumulation of knowledge and progress, with many failed attempts and dead-ends. To some extent one can simply orchestrate AI to keep working on a problem, judge their own progress (or judge each others progress), choose on what to follow up, when to switch approaches etc. However, this may involve different capabilities such as judging partial progress, which AI systems may or may not have -- as of now there is not enough experience to say whether these capabilities will be automatic or need to built.

## Experiences

Many groups and people are working on building AI systems for mathematics, and many mathematicians experiment with using LLMs to aid their research. Here are some examples and experiences from those whom I have come to trust as being empirically grounded, thoughtful and honest (to those quoted here I should add Ethan Mollick as someone I follow closely -- he has not been quoted as his field is far from mathematics).

The mathematical capabilities vary by field of mathematics. As AI systems are essentially single-shot solvers, in particular one expects them to find fields where the knowledge is highly cumulative, such as Algebraic Geometry, to be the hardest. One mathematician in such a field whose experiments I follow is [Daniel Litt](https://www.daniellitt.com/). After a long thread about his experiments with `o3` and `o4-mini`, this was his tweet.

> Maybe worth stressing, since I think it may have been lost in the somewhat long thread below—I think the latest OpenAI and Google models (o3/o4-mini/Gemini 2.5 pro) are genuinely useful for some math research tasks.

As with my experience and those of colleagues, indeed across mathematics AI systems have become useful in mathematics. I will share an experience and thoughts on their becoming more useful below. But given that the debate gets polarized, for perspective I quote again Daniel Litt:

> I’ve been told recently that I’ve been softening my “brand” of AI skepticism. Pretty extreme misunderstanding IMO—I’ve stayed the same, and the models have improved. Still plenty to be skeptical of but that’s just common sense.

My own response to Litt's quote was to quote John Maynard Keynes: 
> When the facts change, I change my mind. What do you do, sir?.

I hope the readers join me in being willing to change their mind when the facts change, unlike some celebrated "sceptics" (as they call themselves).

A mathematician who has experimented extensively on using AI, and whose area is more amenable to the use of AI is [Robert Ghirst](https://www2.math.upenn.edu/~ghrist/), who works on Applied Algebraic Topology. He narrates an instance when he proved a theorem using a new technique, and asked a leading LLM whether there are other areas to which this applies and how. The LLM suggested three areas, two of which he knew about, but the third was new to him. And an LLM was able to write a paper applying his techniques to the third area. This is one of many ways in which he has used LLMs for mathematics. In his view they are especially good at applied mathematics as they spot connections very well.

An experience of another mathematician: [Francesco Orabona](https://francesco.orabona.com/) "proved a complex math result useful for my research using an LLM", and has shared the [preprint](https://t.co/z7kms9mWnR).

I have started using Gemini-2.5-Pro to help with mathematical research. One example where it was helpful, and impressive, was in some work I was doing with a research student. I had naively made a conjecture and hoped to take the approach of trying to prove it and then use it. The reason for this conjecture was that it held in both extreme cases for different reasons, so one could hope that a combination of the reasons held in general. Concretely, (for those who know some Geometric group theory), I had conjectured that any bounded harmonic function had a limit along almost any quasi-geodesic in spaces with non-positive curvature, which was true for very different reasons in the Gromov-hyperbolic and the Euclidean cases.

When asked Gemini said this was false. When asked for a counterexample, it came up with one that had errors. But once the error was pointed out, it came up with a completely correct counterexample, and one which was illuminating.

## Tests for Research Problems

Research level problems are not present in Olympiad style competitions. There are of course qualifier examinations, course examinations and entrance examinations, but the problems asked in these are often solved somewhere on the internet. This is fine for testing students, but not for LLMs.

The solution adopted by some companies like Epoch AI is to pay mathematicians to come up with problems which are verified to not be present on the internet. Then other mathematicians and mathematics students attempt these to set a benchmark, with LLMs tested for these problems and judged against the benchmarks. In such a [test](https://epoch.ai/gradient-updates/is-ai-already-superhuman-on-frontiermath), the model `o4-mini-medium` did better than the average human team but worse than all teams combined.

A meeting for the setting of such problems revealed the strengths of the LLMs, as described in an article in [Scientific American](https://www.scientificamerican.com/article/inside-the-secret-meeting-where-mathematicians-struggled-to-outsmart-ai/).

## Challenges: Accuracy, Autonomy, Scalability

Early versions of ChatGPT were infamous for *hallucinations* and errors, sometimes making errors for simple problems. With tools like web search and Python interpreters and the development of reasoning models, the errors are much less frequent. However, even the best models make errors in some fraction of the cases (especially when asked somewhat hard questions).

This limits *autonomy* of the models for mathematical reasoning, as errors cascade and a small probability of error in a step accumulates to high likelihood of error in a complex and hierarchical piece of reasoning. This becomes a barrier to *scalability*, as human verification is needed.

A solution to accuracy, hence to autonomy and scalability is to have *independent verification* and *independent evaluation*. To ensure correctness we can use a formal proof system like the *Lean Prover*, either by having the output of the LLM in Lean or by translation from natural language. Both these approaches are used in systems under developed. For specific problems verification and evaluation may be much easier -- for instance if the expected answer is a special function then a symbolic algebra system suffices.

## Originality

With their ability to use *analogy* and *composition* together, LLMs can show a certain level of originality, combining "ideas" from different places adapted to fit together. However, this is not sufficient for truly "out of distribution" originality. 

Artificial Intelligence systems like *AlphaGo* and *AlphaZero* did show true originality by training with *Reinforcement Learning*. These were systems that played games like Go and Chess, trained by playing against (versions of) themselves. This meant that they *saw*, and *learnt from* far more games than humans have played. Indeed, *AlphaZero* started with just the rules of the games and learnt entirely by playing against itself.

With independent verification and evaluation, similar methods can be, and have been, applied to mathematics. We can *train* using feedback from evaluation, *search* among the candidates generated using LLMs, or generate *synthetic data* by selecting good candidates and possibly masking some of the information. A variant of this is generation of synthetic data for inverse problems -- for instance *differentiating* random functions can be used to obtain data for *integration*.

Artificial Intelligence for Mathematical Reasoning has already reached a high level, is rapidly improving, and there are many ideas to go further.