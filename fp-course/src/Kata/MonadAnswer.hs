module Kata.MonadAnswer where

import Kata.ExactlyOne

-- | All instances of the 'Monad' type-class must satisfy one law.
-- This law is not checked by the compiler. This law is given as:
--
-- * The law of associativity
-- For all f g x. g =<< (f =<< x) = ((g =<<) . f) =<< x
class Applicative k => Monad' k where
  -- Pronounced, bind.
  (==<<) :: (a -> k b) -> k a -> k b

  infixr 1 ==<<


-- | 1. Binds a function on the ExactlyOne monad.
--
-- >>> (\x -> ExactlyOne (x + 1)) ==<< ExactlyOne 2
-- ExactlyOne 3
instance Monad' ExactlyOne where
  -- (==<<) :: (a -> ExactlyOne b) -> ExactlyOne a -> ExactlyOne b
  (==<<) = undefined


-- | 2. Binds a function on a List.
--
-- >>> (\n -> [n,n]) ==<< [1,2,3]
-- [1,1,2,2,3,3]
instance Monad' [] where
  -- (==<<) :: (a -> [b]) -> [a] -> [b]
  (==<<) = undefined


-- | 3. Binds a function on a Maybe.
--
-- >>> (\n -> Just (n + n)) ==<< Just 7
-- Just 14
instance Monad' Maybe where
  -- (==<<) :: (a -> Maybe b) -> Maybe a -> Maybe b
  (==<<) = undefined


-- | 4. Binds a function on a function.
--
-- >>> ((*) ==<< (+10)) 7
-- 119
instance Monad' ((->) t) where
  -- (==<<) :: (a -> ((->) t b)) -> ((->) t a) -> ((->) t b)
  -- (==<<) :: (a -> (t -> b)) -> (t -> a) -> (t -> b)
  (==<<) = undefined


-- | 5. Witness that all thins with (=<<) and (<$>) also have (<*>)
--
-- >>> ExactlyOne (+10) <***> ExactlyOne 8
-- ExactlyOne 18
--
-- >>> [(+1),(*2)] <***> [1,2,3]
-- [2,3,4,2,4,6]
--
-- >>> Just (+8) <***> Just 7
-- Just 15
--
-- >>> Nothing <***> Just 7
-- Nothing
--
-- >>> Just (+8) <***> Nothing
-- Nothing
--
-- >>> ((+) <***> (+5)) 1
-- 7
--
-- >>> ((*) <***> (+10)) 3
-- 39
(<***>) :: Monad m => m (a -> b) -> m a -> m b
(<***>) = undefined

infixl 4 <***>


-- | 6. Flattens a combined structure to a single structure
--
-- >>> join [[1,2,3], [1,2]]
-- [1,2,3,1,2]
--
-- >>> join (Just [])
-- []
--
-- >>> join (Just (Just 7))
-- Just 7
--
-- >>> join (+) 7
-- 14
join :: Monad m => m (m a) -> m a
join = undefined


-- | 7. Implement a flipped version of (=<<), however, use only
-- 'join' and '<$>'.
-- Pronounced, bind flipped.
--
-- >>> ((+10) >>== (*)) 7
-- 119
(>>==) :: Monad m => m a -> (a -> m b) -> m b
(>>==) = undefined

infixl 1 >>==


-- | 9. Implement composition within the Monad environment.
-- Pronounced, Kleisli composition.
--
-- >>> ((\n -> [n,n])) <==< (\n -> [n+1,n+2]) 1
-- [2,2,3,3]
(<==<) :: Monad m => (b -> m c) -> (a -> m b) -> a -> m c
(<==<) = undefined
