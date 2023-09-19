module Kata.Ch4 where

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

bound :: (Nat -> Nat) -> Nat -> (Integer, Nat)
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

smallest :: (Integer, Nat) -> (Nat -> Nat) -> Nat -> Nat
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


search2d4 :: ((Nat, Nat) -> Nat) -> Nat -> [(Nat, Nat)]
search2d4 f t = from (0, p) (q, 0) where
  p = undefined
  q = undefined
  from (x1, y1) (x2, y2)
    | x2 < x1 || y1 < y2 = []
    | y1 - y2 <= x2 - x1 = row x
    | otherwise = col y
    where
      x = undefined
      y = undefined
      c = undefined
      r = undefined
      row x' | z < t = undefined
             | z == t = undefined
             | otherwise = undefined
             where z = f (x', r)
      col y' | z < t = undefined
             | z == t = undefined
             | otherwise = undefined
             where z = f (c, y')



------------------ 4.3

data Tree' a


size :: Tree' a -> Nat
size = undefined


flatten' :: Tree' a -> [a]
flatten' = undefined

-- if flatten a tree returns a list of values in strictly increasing order,
-- the tree is a binary search tree

-- each record contains a key field unique to that record
-- the tree is ordered by key
-- useful for dictionaries
searchT :: Ord k => (a -> k) -> k -> Tree' a -> Maybe a
searchT = undefined


-- in the worst case, the search takes time proportional to the height of the tree
height' :: Tree' a -> Nat
height' = undefined

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


-- >> mkTree' [6, 4, 8, 2, 3, 5]
-- Node' (Node' (Node' Null' 2 (Node' Null' 3 Null')) 4 (Node' Null' 5 Null')) 6 (Node' Null' 8 Null')
mkTree' :: Ord a => [a] -> Tree' a
mkTree' = undefined


-- Modify the type Tree to store the height of tree
data Tree a = Null | Node Nat (Tree a) a (Tree a) deriving (Show)

height :: Tree a -> Nat
height = undefined

-- smart constructor
node :: Tree a -> a -> Tree a -> Tree a
node l x r = undefined


mkTree :: Ord a => [a] -> Tree a
mkTree = foldr insert Null

insert :: Ord a => a -> Tree a -> Tree a
insert = undefined

rotr :: Tree a -> Tree a
rotr = undefined

rotl :: Tree a -> Tree a
rotl = undefined

bias :: Tree a -> Integer
bias = undefined


balance :: Tree a -> a -> Tree a -> Tree a
balance l x r
  | abs (h1 - h2) <= 1 = undefined
  | h1 == h2 + 2 = undefined
  | h2 == h1 + 2 = undefined
  where
    h1 = height l
    h2 = height r
    rotateR l' x' r' = undefined
    rotateL l' x' r' = undefined

-- >> mkTree [6, 4, 8, 2, 3, 5]
-- Node 3 (Node 2 (Node 1 Null 2 Null) 3 (Node 1 Null 4 Null)) 5 (Node 2 (Node 1 Null 6 Null) 8 Null)

balanceR :: Tree a -> a -> Tree a -> Tree a
balanceR Null _ _ = error "balanceR: left subtree is Null"
balanceR (Node _ ll y rl) x r =
  if height rl >= height r + 2
  then undefined
  else undefined

balanceL :: Tree a -> a -> Tree a -> Tree a
balanceL _ _ Null = error "balanceL: right subtree is Null"
balanceL l x (Node _ lr y rr) =
  if height lr >= height l + 2
  then undefined
  else undefined

gbalance :: Tree a -> a -> Tree a -> Tree a
gbalance l x r
  | abs (h1 - h2) <= 2 = undefined
  | h1 > h2 + 2 = undefined
  | otherwise = undefined
  where
    h1 = height l
    h2 = height r

flatten :: Tree a -> [a]
flatten Null = []
flatten (Node _ l x r) = undefined

sort :: (Ord a) => [a] -> [a]
sort = undefined


-- for Tree of size n, n <= 2^h
-- Stirling's approximation: log2(n!) = Theta(nlog(n))


------------------ 4.3

type Set a = Tree a

member :: Ord a => a -> Set a -> Bool
member x Null = False
member x (Node _ l y r) = undefined

delete :: Ord a => a -> Set a -> Set a
delete x Null = Null
delete x (Node _ l y r) = undefined

combine :: Ord a => Set a -> Set a -> Set a
combine l Null = l
combine Null r = r
combine l r = undefined

deleteMin :: Ord a => Set a -> (a, Set a)
deleteMin Null = undefined
deleteMin (Node _ Null x r) = (x, r)
deleteMin (Node _ l x r) = undefined

split :: Ord a => a -> Set a -> (Set a, Set a)
split x t = sew (pieces x t)

data Piece a = LP (Set a) a | RP a (Set a) deriving (Show)

pieces :: Ord a => a -> Set a -> [Piece a]
pieces x t = addPiece t []
  where
    addPiece = undefined

-- >>> t = mkTree [6, 8, 9, 10, 14, 15, 20]
-- >>> t
-- Node 3 (Node 2 (Node 1 Null 6 Null) 8 (Node 1 Null 9 Null)) 10 (Node 2 (Node 1 Null 14 Null) 15 (Node 1 Null 20 Null))
-- >>> ps = pieces 9 t
-- >>> ps
-- [LP Null 9,LP (Node 1 Null 6 Null) 8,RP 10 (Node 2 (Node 1 Null 14 Null) 15 (Node 1 Null 20 Null))]

sew :: [Piece a] -> (Set a, Set a)
sew = undefined

-- >>> sew ps
-- (Node 2 (Node 1 Null 6 Null) 8 (Node 1 Null 9 Null),Node 3 (Node 2 Null 10 (Node 1 Null 14 Null)) 15 (Node 1 Null 20 Null))
