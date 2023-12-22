module Kata.FunctorEx where

-- instance Functor [] where
--   fmap = map

-- instance Applicative [] where
--   pure x = [x]

--   fs <*> xs = [f x | f <- fs, x <- xs]

--   liftA2 f xs ys = [f x y | x <- xs, y <- ys]



-- map :: (a -> b) -> [a] -> [b]
-- map _ [] = []
-- map f (x:xs) = f x : map f xs

-- By map, the elements changes, but the data type storing them ([]) remains the same
-- this unchaning type -> context

-- transforming values inside fixed contexts

-- data type Maybe provides a context of a possibly failed computation

map' :: (a -> b) -> Maybe a -> Maybe b
map' f (Just x) = Just (f x)
map' f Nothing = Nothing

-- how to generalize map?

-- fmap :: Functor f => (a -> b) -> f a -> f b

-- 'a' wrapped in any context 'f'
-- value change (a -> b), but the context remains the same.

-- reverse :: String -> String
-- >> xs = ["abc", "def"]
-- >> :t xs
-- >> fmap reverse xs
-- (+ 1) :: Int -> Int
-- >> fmap (+ 1) (Just 1)
-- >> fmap (+ 1) Nothing
-- >> (> 0) :: Int -> Bool
-- >> fmap (> 0) $ Just (-1)
-- >> fmap (> 0) $ Just 1
-- >> fmap (> 0) Nothing
-- >> import Data.Char
-- chr :: Int -> Char
-- >> fmap chr (65, 65)

-- To use fmap on a data type, that type needs to to have an instance of the Functor typeclass
-- >> :i Functor

-- To implement a Functor instance for a data type,
-- you need to provide a type-specific implementation of fmap

data Option a = Some a | None

-- What can be a functor?
-- kind of Functor is (* -> *) -> Constraint
-- we can implement Functor for types whose kind is * -> *
-- types that have one unapplied type variable

-- >>:k Maybe
-- >>:k []
-- >>:k Int

-- data Either a b = Left a | Right b
-- >>:k Either
-- >>:k Either String

-- Functor law
-- 1. Identity
-- fmap id x == id x
-- >> fmap id (Just 1)
-- >> id (Just 1)
-- 2. Composition
-- fmap f (fmap g x) == fmap (f . g) x
-- >> fmap (+ 1) (fmap (+ 2) (Just 1))
-- >> fmap ((+ 1) . (+ 2)) (Just 1)

-- (<$) :: a -> f b -> f a
-- >> "abc" <$ Just 123
-- >> Just "abc"
-- >> "abc" <$ Nothing
-- >> Nothing
-- >> 1 <$ []
-- >> []
-- >> 1 <$ [0]
-- >> [1]
-- >> [1..5]
-- >> 1 <$ [1..5]
-- >> [1,1,1,1,1]

-- Implementing a Functor instance
-- import Data.List.NonEmpty
data NonEmpty' a = NonEmpty'
  { neHead :: a
  , neTail :: [a]
  }

-- we define fmap by pattern matching on the head and tail of the non-empty list
instance Functor NonEmpty' where
  fmap f (NonEmpty' x xs) = NonEmpty' (f x) (fmap f xs)


-- Functor is not always a container
-- Functions are Functors
-- >>:i (->)
-- (->) r
-- Int -> a
-- String -> a
-- [Int] -> a
-- what does it mean to fmap a function?
-- it's about chaning the function
-- what is the fixed context?
-- fmap :: (a -> b) -> f a -> f b
-- fmap :: (a -> b) -> (->) r a -> (->) r b
-- fmap :: (a -> b) -> (r -> a) -> (r -> b)
-- fmap for function transforms what the function returns
-- while keeping the input unchanged
-- fmap for function is the composition of functions
-- instance Functor ((->) r) where
--   fmap = (.)
-- >> fmap (+ 1) (* 2) 2

-- enable transformations on the wrapped type without knowing anything about the wrapper
-- a solid basis of the Applicative typeclass, which further leads to Monad


-- Ex: Implement functor for binary search trees
data BSTree a = Branch (BSTree a) a (BSTree a) | Leaf deriving (Show)
-- >> bst = Branch (Branch (Branch Leaf 1 Leaf) 2 (Branch Leaf 3 Leaf)) 4 Leaf
-- >> (+ 1) <$> bst
-- Branch (Branch (Branch Leaf 2 Leaf) 3 (Branch Leaf 4 Leaf)) 5 Leaf

instance Functor BSTree where
  fmap _ Leaf = Leaf
  fmap f (Branch left node right) = Branch (fmap f left) (f node) (fmap f right)
