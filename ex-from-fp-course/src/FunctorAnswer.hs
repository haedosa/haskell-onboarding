{-# LANGUAGE DeriveFoldable #-}

module FunctorAnswer where

import ExactlyOne

class Functor' k where
  fmap' :: (a -> b) -> k a -> k b

(<$$>) :: Functor' k => (a -> b) -> k a -> k b
(<$$>) = fmap'

infixl 4 <$$>

instance Functor' Maybe where
  fmap' _ Nothing = Nothing
  fmap' f (Just a) = Just (f a)


-- | 1. Maps a function on the ExactlyOne functor
--
-- >>> (+1) <$$> ExactlyOne 2
-- ExactlyOne 3
instance Functor' ExactlyOne where
  -- fmap' :: (a -> b) -> ExactlyOne a -> ExactlyOne b
  fmap' f (ExactlyOne a) = ExactlyOne (f a)

data List a = Nil | Cons a (List a) deriving (Show, Foldable)


-- | 2. Maps a function on the List functor
--
-- >>> (+1) <$$> []
-- []
-- >>> (+1) <$$> [1,2,3]
-- [2,3,4]

instance Functor' [] where
  -- fmap' _ [] = []
  -- fmap' f (x:xs) = f x : fmap' f xs
  fmap' f = foldr ((:) . f) []


-- newtype Reader r a = Reader { runReader :: r -> a }

-- | 3. Maps a function on the reader ((->) r) functor
--
-- >>> ((+1) <$$> (*2)) 8
-- 17
instance Functor' ((->) r) where
  -- fmap' :: (a -> b) -> (->) r a -> (->) r b
  -- fmap' :: (a -> b) -> (r -> a) -> (r -> b)
  fmap' f g = f . g



-- | 4. Anonymous map. Maps a constant value on a functor
--
-- >>> 7 <$$ [1,2,3]
-- [7,7,7]
-- >>> 3 <$$ Just 2
-- Just 3
(<$$) :: Functor' k => a -> k b -> k a
-- (<$$) x = fmap' (const x)
(<$$) = fmap' . const


-- | 5. Apply a value to a functor-of-functions.
--
-- NOTE: The second argumnet is a bare 'a', not a 'k a'.
-- You need a more powerful typeclass, 'Applicative', if you
-- want both the functions and arguments to be
-- "inside" the Functor:
-- (<*>) :: Applicative k => k (a -> b) -> k a -> k b
--
-- >>> (*2) : (+1) : const 99 : [] ??? 8
-- [16, 9, 99]
--
-- >>> Nothing ??? 2
-- Nothing
(???) :: Applicative k => k (a -> b) -> a -> k b
(???) ff a = ff <*> pure a
infixl 1 ???


-- | 6. Anonymous map producing unit value
--
-- >>> void [1,2,3]
-- [(),(),()]
--
-- >>> void (Just 7)
-- Just ()
--
-- >>> void Nothing
-- >>> Nothing
--
-- >>> void (+10) 5
-- ()
void :: Functor' k => k a -> k ()
void = (<$$) ()
