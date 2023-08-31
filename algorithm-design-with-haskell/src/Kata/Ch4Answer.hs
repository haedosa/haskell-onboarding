module Kata.Ch4Answer where

type Nat = Integer

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
search f t = [x | x <- [0..t], f x == t]

-- make the search interval explicit
-- >> search2 (*2) 12
-- [6]
-- (*2) x = 1
search2 :: (Nat -> Nat) -> Nat -> [Nat]
search2 f t = seek (0, t)
  where
    seek (a, b) = [x | x <- [a..b], f x == t]

-- binary search
-- find a better version of seek
-- for any number m in the range a <= m <= b
-- seek (a, b) = [x | x <- [a..m-1], f x == t] ++ [m | f m == t] ++ [x | x <- [m+1..b], f x == t]
-- >> search2 (*2) 12
-- [6]
-- (*2) x = 1
search3 :: (Nat -> Nat) -> Nat -> [Nat]
search3 f t = seek (0, t)
  where
    seek (a, b)
      | a > b = []
      | t < f m = seek (a, m - 1)
      | t == f m = [m]
      | otherwise = seek (m + 1, b)
      where m = (a + b) `div` 2

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

bound :: (Nat -> Nat) -> Nat -> (Integer, Nat)
bound f t = if t <= f 0 then (-1, 0) else (b `div` 2, b)
  where b = until done (*2) 1
        done b' = t <= f b'

search4 :: (Nat -> Nat) -> Nat -> [Nat]
search4 f t = [x | f x == t]
  where
    x = smallest' (bound f t)
    smallest' (a,b) = head [ x' | x' <- [a + 1..b], t <= f x' ]


-- smallest' uses linear search
-- if a + 1 < b, then for any m in the range a < m < b
-- smallest (a,b) = head ([x | x <- [a+1..m], t <= f x] ++ [x | x <- [m+1..b], t <= f x])

search5 :: (Nat -> Nat) -> Nat -> [Nat]
search5 f t = [x | f x == t]
  where
    x = smallest (bound f t) f t

smallest :: (Integer, Nat) -> (Nat -> Nat) -> Nat -> Nat
smallest (a, b) f t
  | a + 1 == b = b
  | t <= f m = smallest (a, m) f t
  | otherwise = smallest (m, b) f t
  where m = (a + b) `div` 2


------------------ 4.2

search2d :: ((Nat, Nat) -> Nat) -> Nat -> [(Nat, Nat)]
search2d f t = [(x,y) | x <- [0..t], y <- [0..t], f (x,y) == t];

-- first improvement: start at the top-left
search2d2 :: ((Nat, Nat) -> Nat) -> Nat -> [(Nat, Nat)]
search2d2 f t = [(x,y) | x <- [0..t], y <- [t,t-1..0], f (x,y) == t];


-- make search interval explicit
-- searchIn (a,b) f t = [(x,y) | x <- [a..t], y <- [b,b-1..0], f (x,y) == t];

search2d3 :: ((Nat, Nat) -> Nat) -> Nat -> [(Nat, Nat)]
search2d3 f t = searchIn (0, t)
  where
    searchIn (x, y)
      | x > t || y < 0 = []
      | f (x, y) < t = searchIn (x + 1, y)
      | f (x, y) == t = (x,y):searchIn (x + 1, y - 1)
      | f (x, y) > t = searchIn (x, y - 1)


search2d4 :: ((Nat, Nat) -> Nat) -> Nat -> [(Nat, Nat)]
search2d4 f t = from (0, p) (q, 0) where
  p = smallest (-1, t) (\y -> f(0, y)) t
  q = smallest (-1, t) (\x -> f(x, 0)) t
  from (x1, y1) (x2, y2)
    | x2 < x1 || y1 < y2 = []
    | y1 - y2 <= x2 - x1 = row x
    | otherwise = col y
    where
      x = smallest (x1 - 1, x2) (\x' -> f (x', r)) t
      y = smallest (y2 - 1, y1) (\y' -> f (c, y')) t
      c = (x1 + x2) `div` 2
      r = (y1 + y2) `div` 2
      row x' | z < t = from (x1, y1) (x2, r + 1)
             | z == t = (x', r):from (x1,y1) (x' - 2, r + 1) ++ from (x' + 1, r - 1) (x2, y2)
             | otherwise = from (x1, y1) (x' - 1, r + 1) ++ from (x', r - 1) (x2, y2)
             where z = f (x', r)
      col y' | z < t = from (c + 1, y1) (x2, y2)
             | z == t = (c, y'):from (x1, y1) (c - 1, y' + 1) ++ from (c + 1, y' - 1) (x2, y2)
             | otherwise = from (x1, y1) (c - 1, y') ++ from (c + 1, y' - 1) (x2, y2)
             where z = f (c, y')



------------------ 4.3

data Tree a = Null | Node (Tree a) a (Tree a) deriving (Show)


size :: Tree a -> Nat
size Null = 0
size (Node l x r) = 1 + size l + size r


flatten :: Tree a -> [a]
flatten Null = []
flatten (Node l x r) = flatten l ++ [x] ++ flatten r

-- if flatten a tree returns a list of values in strictly increasing order,
-- the tree is a binary search tree

-- each record contains a key field unique to that record
-- the tree is ordered by key
-- useful for dictionaries
searchT :: Ord k => (a -> k) -> k -> Tree a -> Maybe a
searchT key k Null = Nothing
searchT key k (Node l x r)
  | key x < k  = searchT key k r
  | key x == k = Just x
  | otherwise  = searchT key k l


-- in the worst case, the search takes time proportional to the height of the tree
height :: Tree a -> Nat
height Null = 0
height (Node l x r) = 1 + max (height l) (height r)

-- show that size t < 2^height t for all binary trees t
-- by structural induction

-- base case: size Null = 0, 2^height Null = 2^0 = 1
-- inductive step
-- suppose size t < 2^height t for left and right subtrees

-- for integer, a < b <=> a <= b - 1
-- size (node l x y)
-- = { def. of size }
-- size l + 1 + size r
-- <= { inductive hypothesis }
-- 2^height l - 1 + 1 + 2^height r - 1
-- = { 2^a, 2^b <= 2^max a b }
-- <= 2*2^max (height l) (height r) - 1
-- = { 2*2^a = 2^(1 + a) }
-- 2^(1 + max (height l) (height r)) - 1
-- = { def. of height }
-- 2^height t - 1

mkTree :: Ord a => [a] -> Tree a
mkTree [] = Null
mkTree (x:xs) = Node (mkTree ys) x (mkTree zs)
  where
    (ys, zs) = partition (< x) xs
    partition p xs' = (filter p xs', filter (not . p) xs')
