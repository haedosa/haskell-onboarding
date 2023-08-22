module Kata.Ch4 where

type Nat = Int

------------------ 4.1


-- given a strictly increasing function
-- x < y => f x < f y
-- find x such that f x = t

-- x < f (x + 1) since f is strictly increasing
-- search can to confined to the interval 0 =< x =< t

-- linear search
-- (*2) x = 12
-- >> search (*2) 12
-- [6]
-- (*2) x = 1
-- >> search (*2) 1
-- []
search :: (Nat -> Nat) -> Nat -> [Nat]
search f t = undefined

-- make the search interval explicit
-- >> search2 (*2) 12
-- [6]
-- (*2) x = 1
search2 :: (Nat -> Nat) -> Nat -> [Nat]
search2 f t = seek (0, t)
  where
    seek (a, b) = undefined

-- binary search
-- find a better version of seek
-- for any number m in the range a <= m <= b
-- seek (a, b) = [x | x <- [a..m-1], f x == t] ++ [m | f m == t] ++ [x | x <- [m+1..b], f x == t]
-- >> search3 (*2) 12
-- [6]
-- (*2) x = 1
search3 :: (Nat -> Nat) -> Nat -> [Nat]
search3 f t = seek (0, t)
  where
    seek (a, b)
      | a > b = undefined
      | t < f m = undefined
      | t == f m = undefined
      | otherwise = undefined
      where m = undefined

-- definition of search3 is incorrect
-- >> search (2^) 1204
-- [10]
-- >> search3 (2^) 1204
-- []


-- find integers a and b such that f a < t <= f b
-- then search only the interval [a + 1..b]
-- we can find a and b by looking at the values of f
-- until a value p is found for which f (2^(p-1)) < t <= f (2^p)
-- If t <= f(0), then set (a,b) = (-1,0)

bound :: (Nat -> Nat) -> Nat -> (Int, Nat)
bound f t = undefined
  where b = undefined
        done b' = t <= f b'

search4 :: (Nat -> Nat) -> Nat -> [Nat]
search4 f t = [x | f x == t]
  where
    x = undefined
    smallest' (a,b) = undefined


-- smallest' uses linear search
-- if a + 1 < b, then for any m in the range a < m < b
-- smallest (a,b) = head ([x | x <- [a+1..m], t <= f x] ++ [x | x <- [m+1..b], t <= f x])

search5 :: (Nat -> Nat) -> Nat -> [Nat]
search5 f t = [x | f x == t]
  where
    x = smallest (bound f t) f t

smallest :: (Int, Nat) -> (Nat -> Nat) -> Nat -> Nat
smallest (a, b) f t
  | a + 1 == b = undefined
  | t <= f m = undefined
  | otherwise = undefined
  where m = (a + b) `div` 2


-- bound (2^) 1024
-- b = 1, f b = 2
-- b = 2, f b = 4
-- b = 4, f b = 16
-- b = 8, f b = 256
-- b = 16, f b = 65536

-- smallest (8, 16) (2^) 1024
-- m = 12
-- 1024 <= 2^12 ? true
-- smallest (8, 12) (2^) 1024
-- m = 10
-- 1024 <= 2^10 ? true
-- smallest (8, 10) (2^) 1024
-- m = 9
-- 1024 <= 2^9 ? false
-- smallest (9,10) (2^) 1024
-- 10

-- search (2^) 1024 = if 2^10 = 1024 then [10] else [0]


------------------ 4.2

search2d :: ((Nat, Nat) -> Nat) -> Nat -> [(Nat, Nat)]
search2d f t = undefined

-- first improvement: start at the top-left
search2d2 :: ((Nat, Nat) -> Nat) -> Nat -> [(Nat, Nat)]
search2d2 f t = undefined


-- make search interval explicit
-- searchIn (a,b) f t = [(x,y) | x <- [a..t], y <- [b,b-1..0], f (x,y) == t];

-- saddleback search
search2d3 :: ((Nat, Nat) -> Nat) -> Nat -> [(Nat, Nat)]
search2d3 f t = searchIn (0, t)
  where
    searchIn (x, y) = undefined
