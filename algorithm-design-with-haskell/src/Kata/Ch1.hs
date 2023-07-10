module Kata.Ch1 where

-- 1.1 Basic types and functions

type Nat = Int

-- >>> map' (+ 1) [1,2,3]
-- [2,3,4]
-- define map using recursion
map' = undefined


-- >>> filter' odd [1,2,3]
-- [1,3]
-- define filter using recursion
filter' = undefined


-- >>> foldr'' (+) 0 [1,2,3]
-- 6
-- >>> foldr'' (:) [] [1,2,3]
-- [1,2,3]
-- define foldr using recursion
foldr'' = undefined



-- define length using foldr''
length' :: [a] -> Nat
length' = undefined



-- >>> foldl'' (+) 0 [1,2,3]
-- 6
-- >>> foldl'' (:) [] [1,2,3]
-- ?
-- define foldl using recursion
foldl'' = undefined


-- define length using foldl''
length'' :: [a] -> Nat
length'' = undefined



-- foldl returns a well-defined value only on finite list
-- define any function using foldr
any1 :: (a -> Bool) -> [a] -> Bool
any1 = undefined
-- define any function using foldl
any2 :: (a -> Bool) -> [a] -> Bool
any2 = undefined
-- test:
-- >>> any even [1..]

-- define foldl using foldr
-- hint: use flip and reverse
foldl''' = undefined

-- define any using foldl'''
any3 :: (a -> Bool) -> [a] -> Bool
any3 = undefined
-- test:
-- >>> any3 even [1..]








-- 1.2 Processing lists

-- foldr and foldl
-- Which is a more natural way?
-- We read an English sentence from left to right
-- "a lovely little old French silver butter knife"
-- the adjectives applied from right to left
-- Mathematical expressions: h . g . f
head' :: [a] -> a
head' = foldr (<<) undefined  where x << y = x
-- >>> head' [1..]
-- The evaluation of foldr (<<), conceptually from right to left,
-- is abandoned after the first element encountered.
-- What does lazy evaluation do here?

-- Which is a more efficient way?
-- concat1 = foldr (++) []
-- concat2 = foldl (++) []

-- online algorithm
scanl'' :: (b -> a -> b) -> b -> [a] -> [b]
scanl'' f e [] = [e]
scanl'' f e (x:xs) = e:scanl'' f (f e x) xs
-- scanl (@) e [x,y,z,...] = [e, e @ x, (e @ x) @ y, ((e @ x) @ y) @ z,...]




-- 1.3 Inductive and recursive definitions
-- Inductive definition
perms1 :: [a] -> [[a]]
perms1 = undefined

inserts :: a -> [a] -> [[a]]
inserts = undefined
-- inserts 1 [2,3] - [[1,2,3],[2,1,3],[2,3,1]]

perms1' :: [a] -> [[a]]
perms1' = undefined


perms1'' :: [a] -> [[a]]
perms1'' = foldr (concatMap . inserts) [[]]



-- Recursive definition
perms2 :: [a] -> [[a]]
perms2 = undefined

-- function 'picks' picks an arbitrary element from a list in all possible ways
-- returning both the element and what remains.
-- >>> picks [1,2,3]
-- [(1,[2,3]),(2,[1,3]),(3,[1,2])]
picks :: [a] -> [(a,[a])]
picks = undefined



perms2' :: [a] -> [[a]]
perms2' = undefined
-- Expressing 'perm2' in this way rather than by a list comprehension
-- helps with equational reasoning, and also with the analysis of its running time.

-- divide-and-conquer algorithms are usually recursive
-- greedy and thinning algorithms are usually inductive

-- inductive definition of perms1 leads to Insertion sort
-- recursive definitino of perms2 leads to Section sort

-- while and until loops in imperative programming

until' :: (a -> Bool) -> (a -> a) -> a -> a
until' p f x = if p x then x else until p f (f x)

while :: (a -> Bool) -> (a -> a) -> a -> a
while p = until (not . p)







-- 1.4 Fusion

-- 'fuse' two computations together into one computations
-- map f . map g = map (f . g)
-- concatMap f . map g = concatMap (f . g)
-- foldr f e . map g = foldr (f . g) e

-- foldr f e . concat = ????
-- foldr f e (xs ++ ys) = ????


-- The master fusion rule is the fusion law of foldr
-- h (f x y) = g x (h y) (fusion condition)
-- =>
-- h (foldr f e xs) = foldr g (h e) xs
--
-- Proof by induction
-- Base case
--
-- Induction step


-- The answer to 'foldr f e (xs ++ ys)' is
-- foldr f e (xs ++ ys) = foldr f (foldr f e ys) xs


-- foldr f e . concat = ????
