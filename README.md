Piano Game
========

Current system of game uses Guitar Hero/Rock band style of expecting you to play a note at an exact time. However with Piano music this is not a desired feature. First goal is to implement a system which allows for rubato.

Current plan is to put song midi notes and user input into strings and compare them using a string edit distance metric. Possible problems: Notes played at the same time may not be stored at the same time. Eg C#,A,B may be stored as A,B,C# this would give an error metric > 0 which is incorrect. Whereas c# then A then B should always be played in that order. So there is a need to separate notes played together from sequential notes.

Instead of strings use vector with each index holding notes played together. Sort each index so C#,A,B is always stored the same way. Note: Ensure vector equality works as expected.

Fork of Piano Game by Nicholas Piegdon et al.