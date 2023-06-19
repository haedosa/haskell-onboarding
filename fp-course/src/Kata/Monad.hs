module Kata.Monad where

import Kata.ExactlyOne

-- | Three Monad laws.
-- These laws are not checked by the compiler.
--
-- * Left identity: return a >>= h = h a
-- * Right identity: m >>= return = m
-- * Associativity: (m >>= g) >>= h = m >>= (\x -> g x >>= h)
class Applicative k => Monad' k where
  -- Pronounced, bind.
  (>>==) :: k a -> (a -> k b) -> k b

  infixl 1 >>==


-- | 1. Binds a function on the ExactlyOne monad.
--
-- >>> ExactlyOne 2 >>== (\x -> ExactlyOne (x + 1))
-- ExactlyOne 3
instance Monad' ExactlyOne where
  -- (==<<) :: ExactlyOne a -> (a -> ExactlyOne b) -> ExactlyOne b
  (>>==) = undefined


-- | 2. Binds a function on a List.
--
-- >>> [1,2,3] >>== (\n -> [n,n])
-- [1,1,2,2,3,3]
instance Monad' [] where
  -- (>>==) :: [a] -> (a -> [b]) -> [b]
  (>>==) = undefined


-- | 3. Binds a function on a Maybe.
--
-- >>> Just 7 >>== (\n -> Just (n + n))
-- Just 14
instance Monad' Maybe where
  -- (>>==) :: Maybe a -> (a -> Maybe b) -> Maybe b
  (>>==) = undefined


-- | 4. Binds a function on a function.
--
-- >>> ((+ 10) >>== (*)) 7
-- 119
instance Monad' ((->) t) where
  -- (>>==) :: ((->) t a) -> (a -> ((->) t b)) -> ((->) t b)
  -- (>>==) :: (t -> a) -> (a -> (t -> b)) -> (t -> b)
  (>>==) = undefined


-- | 5. Witness that all thins with (>>=) and (<$>) also have (<*>)
--
-- >>> [1,2,3] <***> [(+ 1),(* 2)]
-- [2,3,4,2,4,6]
--
-- >>> Just 7 <***> Just (+ 8)
-- Just 15
--
-- >>> Just 7 <***> Nothing
-- Nothing
--
-- >>> Nothing <***> Just (+ 8)
-- Nothing
--
-- >>> ((+ 5) <***> (+)) 1
-- 7
--
-- >>> ((+ 10) <***> (*)) 3
-- 39
(<***>) :: Monad m => m a -> m (a -> b) -> m b
(<***>) = undefined

infixl 4 <***>


-- | 6. Flattens a combined structure to a single structure
--
-- >>> join [[1,2,3], [1,2]]
-- [1,2,3,1,2]
--
-- >>> join (Just Nothing)
-- Nothing
--
-- >>> join (Just (Just 7))
-- Just 7
--
-- >>> join (+) 7
-- 14
join :: Monad m => m (m a) -> m a
join = undefined


-- | 7. Implement a flipped version of (>>=), however, use only
-- 'join' and '<$>'.
-- Pronounced, bind flipped.
--
-- >>> ((*) ==<< (+ 10)) 7
-- 119
(==<<) :: Monad m => (a -> m b) -> m a -> m b
(==<<) = undefined

infixr 1 ==<<


-- | 9. Implement composition within the Monad environment.
-- Pronounced, Kleisli composition.
--
-- >>> ((\n -> [n,n]) <==< (\n -> [n + 1,n + 2])) 1
-- [2,2,3,3]
(<==<) :: Monad m => (b -> m c) -> (a -> m b) -> a -> m c
(<==<) = undefined
