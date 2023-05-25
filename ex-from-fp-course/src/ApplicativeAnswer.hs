
module Applicative where

import ExactlyOne

class Functor k => Applicative' k where
  pure' :: a -> k a
  -- Pronounced, apply.
  (<**>) :: k (a -> b) -> k a -> k b
  infixl 4 <**>

-- | 1. Insert into ExactlyOne
-- >>> ExactlyOne (+10) <**> ExactlyOne 8
-- ExactlyOne 18
instance Applicative' ExactlyOne where
  pure' = ExactlyOne
  (ExactlyOne f) <**> (ExactlyOne a) = ExactlyOne (f a)

-- | 2. Insert into a List
-- >>> [(+1), (*2)] <**> [1,2,3]
-- [2,3,4,2,4,6]
instance Applicative' [] where
  pure' a = [a]
  fs <**> as = [f a | f <- fs, a <- as]

-- | 3. Insert into a Maybe
-- >>> Just (+8) <**> Jut 7
-- Just 15
--
-- >>> Nothing <**> Just 7
-- Nothing
--
-- >>> Just (+8) <**> Nothing
-- Nothing
instance Applicative' Maybe where
  pure' = Just
  Nothing <**> _ = Nothing
  -- _ <**> Nothing = Nothing
  -- (Just f) <**> (Just a) = Just (f a)
  (Just f) <**> a = fmap f a

-- | 4. Insert into a function
-- >>> ((+) <**> (+10)) 3
-- 16
--
-- >>> (+) <**> (+5) $ 3
-- 11
--
-- >>> ((*) <**> (+10)) 3
-- 39
--
-- >>> (*) <**> (+2) $ 3
-- 15
--
-- >>> (+) <$> (+3) <**> (*100) $ 5
-- 508
instance Applicative' ((->) r) where
  -- pure' a = (\_ -> a)
  pure' = const
  f <**> g = \x -> f x (g x)

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
lift2 f fa fb = f <$> fa <*> fb

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
lift3 f fa fb fc = lift2 f fa fb <*> fc

-- | 7. Apply a quaternary function in the environment.
-- /can be written using `lift3` and `(<*>)`./
-- >>> lift4 (\a b c d -> a + b + c + d) (Just 7) (Just 8) (Just 9) (Just 10)
-- Just 34
--
-- >>> lift4 (\a b c d -> a + b + c + d) (Just 7) (Just 8) Nothing (Just 10)
-- Nothing
--
-- >>> lift4 (\a b c d -> a + b + c + d) [1,2,3] [4,5] [6,7,8] [9,10]
-- [20,21,21,22,22,23,21,22,22,23,23,24,21,22,22,23,23,24,22,23,23,24,24,25,22,23,23,24,24,25,23,24,24,25,25,26]
--
-- >>> lift4 (\a b c d -> a + b + c + d) length sum product (sum .filter even) [4,5,6]
-- 148
lift4 :: Applicative f => (a -> b -> c -> d -> e)
         -> f a -> f b -> f c -> f d -> f e
lift4 f fa fb fc fd = lift3 f fa fb fc <*> fd

-- | 8. Apply a nullary function in the environment
lift0 :: Applicative f => a -> f a
lift0 = undefined

-- | 9. Apply a unary function in the environment
-- /can be written using `lift0` and `(<*>)`./
--
-- >>> lift1 (+1) (Just 2)
-- Just 3
--
-- >>> lift1 (+1) []
-- []
-- >>> lift1 (+1) [1,2,3]
-- [2,3,4]
lift1 :: Applicative f => (a -> b) -> f a -> f b
lift1 = undefined

-- | 10. Apply, discarding the value of the first argument.
-- Pronounced, right apply.
--
-- >>> [1,2,3] **> [4,5,6]
-- [4,5,6,4,5,6,4,5,6]
--
-- >>> [1,2] **> [4,5,6]
-- [4,5,6,4,5,6]
--
-- >>> [1,2,3] **> [4,5]
-- [4,5,4,5,4,5]
--
-- >>> Just 7 **> Just 8
-- Just 8
(**>) :: Applicative f => f a -> f b -> f b
(**>) = undefined

-- | 11. Apply, discarding the value of the second argument.
-- Pronounced, left apply.
--
-- >>> [1,2,3] <** [4,5,6]
-- [1,1,1,2,2,2,3,3,3]
--
-- >>> [1,2] <** [4,5,6]
-- [1,1,1,2,2,2]
--
-- >>> [1,2,3] <** [4,5]
-- [1,1,2,2,3,3]
-- >>> Just 7 <** Just 8
-- Just 7
(<**) :: Applicative f => f a -> f b -> f a
(<**) = undefined

-- | 12. Sequences a list of structure to a structure of list.
--
-- >>> sequence' [ExactlyOne 7, ExactlyOne 8, ExactlyOne 9]
-- ExactlyOne [7,8,9]
--
-- >>> sequence' [[1,2,3],[1,2]]
-- [[1,1],[1,2],[2,1],[2,2],[3,1],[3,2]]
--
-- >>> sequence' [Just 7, Nothing]
-- Nothing
--
-- >>> sequence' [Just 7, Just 8]
-- Just [7,8]
--
-- >>> sequence' [(*10), (+2)] 6
-- [60, 8]
sequence' :: Applicative f => [f a] -> f [a]
sequence' = undefined

-- | 13. Replicate an effect a given number of times
--
-- /Tip:/ Use replicate function
-- >>> replicateA 4 (ExactlyOne "hi")
-- ExactlyOne ["hi","hi","hi","hi"]
--
-- >>> replcateA 4 (Just "hi")
-- Just ["hi","hi","hi","hi"]
--
-- >>> replicateA 4 Nothing
-- Nothing
--
-- >>> replicateA 4 (*2) 5
-- [10,10,10,10]
--
-- >>> replicateA 3 ['a','b','c']
-- ["aaa","aab","aac","aba","abb","abc","aca","acb","acc","baa","bab","bac","bba","bbb","bbc","bca","bcb","bcc","caa","cab","cac","cba","cbb","cbc","cca","ccb","ccc"]
replicateA :: Applicative f => Int -> f a -> f [a]
replicateA = undefined

-- | 14. Filter a list with a predicate that produces an effect.
--
-- >>> fitering (ExactlyOne . even) [4,5,6]
-- ExactlyOne [4,6]
--
-- >>> filtering (\a -> if a > 13 then Nothing else Just (a <= 7)) [4,5,6]
-- Just [4,5,6]
--
-- >>> filtering (\a -> if a > 13 then Nothing else Just (a <= 7)) [4,5,6,7,8,9]
-- Just [4,5,6,7]
--
-- >>> filtering (\a -> if a > 13 then Nothing else Just (a <= 7)) [4,5,6,13,14]
-- Nothing
--
-- >>> filtering (>) [4,5,6,7,8,9,10,11,12] 8
-- [9,10,11,12]
--
-- >>> filtering [const $ True,True] [1,2,3]
-- [[1,2,3],[1,2,3],[1,2,3],[1,2,3],[1,2,3],[1,2,3],[1,2,3],[1,2,3]]
filtering :: Applicative f => (a -> f Bool) -> [a] -> f [a]
filtering = undefined
