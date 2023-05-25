
module Functor where

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
  fmap' =
    error "todo"

-- | 2. Maps a function on the List functor
--
-- >>> (+1) <$$> []
-- []
-- >>> (+1) <$$> [1,2,3]
-- [2,3,4]

instance Functor' [] where
  fmap' =
    error "todo"


-- | 3. Maps a function on the function functor
--
-- >>> ((+1) <$$> (*2)) 8 (== (+1) <$$> (*2) $ 8)
-- 17
instance Functor' ((->) r) where
  fmap' =
    error "todo"

-- Some from Learn you a haskell
-- What is (->) r ?
-- The function type r -> a can be rewritten as (->) r a
-- (->) is a type constructor that takes two type parameters
-- To be a Functor instance, the type constructor has to take exactly one type parameter
-- (->) r can be a Functor instance
-- instance Functor ((->) r) where
--   fmap f g = (\x -> f (g x))
-- instance Functor (r ->) is not an allowed syntax
-- fmap :: (a -> b) -> ((->) r a) -> ((->) r b)
-- fmap :: (a -> b) -> (r -> a) -> (r -> b)
-- We pipe the output of r -> a into input of a -> b to get a function r -> b
-- What does it do?

-- The fact that fmap is function composition when used on functions
-- bends our minds a bit and let us see how things that
-- act more like computations than boxes (IO and (->) r) can be functors.
-- The function being mapped over a computation results in the same computation
-- but the result of that computation is modified with the function.


-- | 4. Anonymous map. Maps a constant value on a functor
--
-- >>> 7 <$$ [1,2,3]
-- [7,7,7]
-- >>> 3 <$$ Just 2
-- Just 3
(<$$) :: Functor f => a -> f b -> f a
(<$$) =
  error "todo"


-- | 5. Apply a value to a functor-of-functions.
--
-- NOTE: The second argumnet is a bare 'a', not a 'k a'.
-- You need a more powerful typeclass, 'Applicative', if you
-- want both the functions and arguments to be
-- "inside" the Functor:
-- (<*>) :: Applicative k => k (a -> b) -> k a -> k b
--
-- >>> [(*2), (+1), const 99] ??? 8
-- [16, 9, 99]
--
-- >>> Nothing ??? 2
-- Nothing
(???) :: Functor f => f (a -> b) -> a -> f b
(???) ff a =
  error "todo"
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
void :: Functor f => f a -> f ()
void =
  error "todo"
