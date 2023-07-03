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
head' :: Num a => [a] -> a
head' = foldr (<<) 1  where x << y = x
-- >>> head' [1..]
-- The evaluation of foldr (<<), conceptually from right to left,
-- is abandoned after the first element encountered.
-- What does lazy evaluation do here?

-- Which is a more efficient way?
-- concat1 = foldr (++) []
-- concat2 = foldl (++) []




-- Inductive definition
perms1 :: [a] -> [[a]]
perms1 [] = [[]]
perms1 (x:xs) = [zs | ys <- perms1 xs, zs <- inserts x ys]

inserts :: a -> [a] -> [[a]]
inserts x [] = [[x]]
inserts x (y:ys) = (x:y:ys):map (y:) (inserts x ys)
-- inserts 1 [2,3] - [[1,2,3],[2,1,3],[2,3,1]]

perms1' :: [a] -> [[a]]
perms1' = foldr step [[]]
  where step x xss = concatMap (inserts x) xss
