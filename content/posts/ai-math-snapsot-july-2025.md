+++
title = "AI for Mathematics: A Snapshot (July 2025)"
date = 2025-07-19T04:15:41Z
draft = true
tags = []
categories = []
+++

Artificial Intelligence in Mathematics has advanced at such a rapid pace that anything we say becomes obsolete soon (see the note below for this happening with this post :smile:). But it is useful to take snapshots. This is one based on my knowledge, understanding, and opinions (though opinions that I hope are empirically grounded).

A good starting point to understand the capabilities of Artificial Intelligence systems in doing mathematics is the International Mathematical Olympiad 2025, for which *MathArena* did an independent assessment. Their assessment was for publicly available LLMs, not mathematics specialized systems like *AlphaProof* from Google-DeepMind. Their verdict: ["Not Even Bronze"](https://matharena.ai/imo/). 

That may sound like a defeat for LLMs, but the best LLM Gemini-2.5-Pro got a score of 31%. So I would add -- not even a Bronze Medalist, but clearly smarter than me (and perhaps most working mathematicians). Further, the IMO problem setters will ensure that these problems are not already online, so clearly LLMs are doing more than searching on the internet and copying. That LLMs can solve problems they have not seen has been obvious for a while for any of us who have spent even a modest amount of time with LLMs (and are not highly prejudiced). On the other hand, it is  clear while Terry Tao is not that impressed by LLMs -- he got a bronze medal at age 10:smile:.

**Note:** As I wrote this, there was an [announcement](https://x.com/polynoamial/status/1946478249187377206) from OpenAI that an experimental reasoning model had obtained a Gold Medal level score, working with the same conditions and time limits as human participants.

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

## Tests for Research Problems


