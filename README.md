# Code Reference

Examples of little ideas that I play with in various languages

- The Dragon Fractal is a little project that I like to reimplement in new languages to try out syntax and features of languages.



## Dragon Fractal

As a simple introduction, take a strip of paper and fold it in half. Fold it in half again in the same direction. Again, again, and again.

If you opened all the folds, and made each one a right angle, what shape would you get after folding it X times?

[Vi Hart's exploration](https://www.youtube.com/watch?v=EdyociU35u8)

Continues from [previous project](https://github.com/dotHTM/dragon)

### Turn lists

The first thing I looked when I discovered this puzzle as a kid was to look at weather the paper turns left or right at a given crease.

Every time you fold the strip, it doubles all the existing folds while inverting them and adds a single fold to the middle. The nature of the folding makes the whole thing an inverted palandrome. 

First iteration is just a single Left.
Second iteration is Left, left, right.

3rd: llr l lrr
4th: llrllrr l llrrlrr
5th: llrllrrlllrrlrr l llrllrrrllrrlrr
... etc

Notice, every next iteration contains the previous, so perhaps an optimiation in the calculation would be to store just the new portion in a list of lists.

1st: l
2nd: l r
3rd: l lrr
4th: l llrrlrr
5th: l llrllrrrllrrlrr

Since this gets larger exponentially, it'll more often be faster to read from memory than to recalcuate higher iteration levels. Writing to disk gives good opertunities to sanity test previous runs, overwrite mistakes, or pickup from last run.

### Plotting the folds

Next you get to do a little trigonometry on your array of turns.

    x = R * cos ( theta )
    y = R * sin ( theta )

