module Kata.Ch1Ex where

-- Ex 1.1 Here are some other basic list-porcessing functions we will need.
-- To check your understanding, just give appropriate types.
-- maximum, minimum ::
-- take, drop ::
-- takeWhile, dropWhile ::
-- inits, tails ::
-- splitAt ::
-- span ::
-- null ::
-- all ::
-- elem ::
-- (!!) ::
-- zipWith ::


-- Ex 1.2 Trawling through Data.List we discovered the function
-- uncons :: [a] -> Maybe (a, [a])
-- of whose existence we were quite unconscious.
-- Guess the definition of uncons.

uncons' :: [a] -> Maybe (a,[a])
uncons' = undefined


-- Ex 1.3 The library Data.List does not provide functions
-- wrap :: a -> [a]
-- unwrap :: [a] -> a
-- single :: [a] -> Bool
-- for wrapping a value into a singleton list,
-- unwrapping a singleton list into its sole occupant,
-- and testing a list for being a singleton.
-- This is a pity, for the three functions can be very useful
-- on occations and will appear a number of times in the rest of this book.
-- Give appropriate definitions.

wrap :: a -> [a]
wrap = undefined

unwrap :: [a] -> a
unwrap = undefined

single :: [a] -> Bool
single = undefined


-- Ex 1.4 Write down a definition of 'reverse' that takes linear time.
-- One possibility is to use a 'foldl'

reverse' :: [a] -> [a]
reverse' = undefined


-- Ex 1.5 Express both 'map' and 'filter' as an instance of 'foldr'

map' :: (a -> b) -> [a] -> [b]
map' = undefined

filter' :: (a -> Bool) -> [a] -> [a]
filter' = undefined


-- Ex 1.6 Express 'foldr f e . filter p' as an instance of 'foldr'


-- Ex 1.7 The function 'takeWhile' returns the longest initial segment of a list
-- all of whose elements satisfy a given test.
-- Moreover, its running time is proportional to the length of the result,
-- not the length of the input.
-- Express the 'takeWhile' as an instance of 'foldr',
-- thereby demonstrating once again that a 'foldr' need not process
-- the whole of its argument before terminating.

takeWhile' :: (a -> Bool) -> [a] -> [a]
takeWhile' = undefined


-- Ex 1.8 The Data.List library contains a function 'dropWhileEnd
-- which drops the longest suffix of a list all of whose elements
-- satisfy a given Boolean test. For example,
-- dropWhileEnd even [1,4,3,6,2,4] = [1,4,3]
-- Define 'dropWhileEnd' as an instance of 'foldr'

dropWhileEnd' :: (a -> Bool) -> [a] -> [a]
dropWhileEnd' = undefined
