
module Applicative where

import ExactlyOne (ExactlyOne)

class Functor k => Applicative' k where
  pure :: a -> k a
  (<**>) :: k (a -> b) -> k a -> k b
  infixl 4 <**>

-- | 1. Insert into ExactlyOne
-- >>> ExactlyOne (+10) <**> ExactlyOne 8
-- ExactlyOne 18
instance Applicative' ExactlyOne where
  pure = undefined
  (<**>) = undefined

-- | 2. Insert into a List
-- >>> [(+1), (*2)] <*> [1,2,3]
-- [2,3,4,2,4,6]
instance Applicative' [] where
  pure = undefined
  (<**>) = undefined

-- | 3. Insert into a Maybe
-- >>> Just (+8) <**> Jut 7
-- Just 15
--
-- >>> Nothing <*> Just 7
-- Nothing
--
-- >>> Just (+8) <*> Nothing
-- Nothing
instance Applicative' Maybe where
  pure = undefined
  (<**>) = undefined

-- | 4. Insert into a constant function
-- >>> ((+) <**> (+10)) 3
-- 16
--
-- >>> ((+) <**> (+5)) 3
-- 11
--
-- >>> ((*) <**> (+10)) 3
-- 39
--
-- >>> ((*) <**> (+2)) 3
-- 15
instance Applicative' ((->) t) where
  pure = undefined
  (<**>) = undefined

-- | 5. Apply a binary function in the environment
-- >>> lift2 (+) (Just 7) (Just 8)
-- Just 15
--
-- >>> lift2 (+) (Just 7) Nothing
-- Nothing
--
-- >>> lift2 (+) Nothing (Just 8)
-- Nothing
--
-- >>> lift2 (+) length sum [4,5,6]
-- 18
lift2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
lift2 = undefined

-- | 6. Apply a ternary function in the environment.
-- /can be written using `lift2` and `(<*>)`./
-- >>> lift3 (\a b c -> a + b + c) (ExactlyOne 7) (ExactlyOne 8) (ExactlyOne 9)
-- ExactlyOne 24
--
-- >>> lift3 (\a b c -> a + b + c) [1,2,3] [4,5,6] [6,7,8]
-- [11,12,13,12,13,14,12,13,14,13,14,15,13,14,15,14,15,16]
--
-- >>> lift3 (\a b c -> a + b + c) (Just 7) (Just 8) (Just 9)
-- Just 24
--
-- >>> lift3 (\a b c -> a + b + c) (Just 7) (Just 8) Nothing
-- Nothing
--
-- >>> lift3 (\a b c -> a + b + c) Nothing (Just 8) (Just 9)
-- Nothing
--
-- >>> lift3 (\a b c -> a + b + c) Nothing Nothing (Just 9)
-- Nothing
--
-- >>> lift3 (\a b c -> a + b + c) length sum product [4,5,6]
-- 138
lift3 :: Applicative f => (a -> b -> c -> d) -> f a -> f b -> f c -> f d
lift3 = undefined

-- | 7. Apply a quaternary function in the environment.
-- /can be written using `lift3` and `(<*>)`./
-- >>>
