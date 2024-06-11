# Raindrops

Welcome to Raindrops on Exercism's Haskell Track.
If you need help running the tests or submitting your code, check out `HELP.md`.

## Introduction

Raindrops is a slightly more complex version of the FizzBuzz challenge, a classic interview question.

## Instructions

Your task is to convert a number into its corresponding raindrop sounds.

If a given number:

- is divisible by 3, add "Pling" to the result.
- is divisible by 5, add "Plang" to the result.
- is divisible by 7, add "Plong" to the result.
- **is not** divisible by 3, 5, or 7, the result should be the number as a string.

## Examples

- 28 is divisible by 7, but not 3 or 5, so the result would be `"Plong"`.
- 30 is divisible by 3 and 5, but not 7, so the result would be `"PlingPlang"`.
- 34 is not divisible by 3, 5, or 7, so the result would be `"34"`.

~~~~exercism/note
A common way to test if one number is evenly divisible by another is to compare the [remainder][remainder] or [modulus][modulo] to zero.
Most languages provide operators or functions for one (or both) of these.

[remainder]: https://exercism.org/docs/programming/operators/remainder
[modulo]: https://en.wikipedia.org/wiki/Modulo_operation
~~~~

You need to implement the `convert` function that returns number converted to
raindrop sound. You can use the provided signature if you are unsure
about the types, but don't let it restrict your creativity:

```haskell
convert :: Int -> String
```

This exercise works with textual data. For historical reasons, Haskell's
`String` type is synonymous with `[Char]`, a list of characters. For more
efficient handling of textual data, the `Text` type can be used.

As an optional extension to this exercise, you can

- Read about [string types](https://haskell-lang.org/tutorial/string-types) in Haskell.
- Add `- text` to your list of dependencies in package.yaml.
- Import `Data.Text` in [the following way](https://hackernoon.com/4-steps-to-a-better-imports-list-in-haskell-43a3d868273c):

```haskell
import qualified Data.Text as T
import           Data.Text (Text)
```

- You can now write e.g. `convert :: Int -> Text` and refer to `Data.Text` combinators as e.g. `T.pack`.
- Look up the documentation for [`Data.Text`](https://hackage.haskell.org/package/text/docs/Data-Text.html),
- You can then replace all occurrences of `String` with `Text` in Raindrops.hs:

```haskell
convert :: Int -> Text
```

This part is entirely optional.

## Source

### Created by

- @etrepum

### Contributed to by

- @iHiD
- @kytrinyx
- @lpalma
- @petertseng
- @ppartarr
- @rbasso
- @sshine
- @tejasbubane
- @yawpitch

### Based on

A variation on FizzBuzz, a famous technical interview question that is intended to weed out potential candidates. That question is itself derived from Fizz Buzz, a popular children's game for teaching division. - https://en.wikipedia.org/wiki/Fizz_buzz