module Kata.TypeClass where

import Kata.ExprT
import Kata.Parser

-- class Eq a where
--   (==), (/=) :: a -> a -> Bool
--   x /= y = not (x == y)
--   x == y = not (x /= y)

data Foo = F Int | G Char


class Listable a where
  toList :: a -> [Int]


instance Listable Int where


instance Listable Bool where


instance Listable [Int] where


data Tree a = Empty | Node a (Tree a) (Tree a)

instance Listable (Tree Int) where


instance (Listable a, Listable b) => Listable (a, b) where
