module Kata.TypeClass where


-- class Eq a where
--   (==), (/=) :: a -> a -> Bool
--   x /= y = not (x == y)
--   x == y = not (x /= y)

data Foo = F Int | G Char

instance Eq Foo where
  (F i1) == (F i2) = i1 == i2
  (G c1) == (G c2) = c1 == c2
  _ == _ = False
