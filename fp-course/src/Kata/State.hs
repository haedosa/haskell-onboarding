module Kata.State where

type Stack = [Int]

pop' :: Stack -> (Int, Stack)
pop' = undefined

-- data () = ()
-- The unit datatype () has one non-undefined member, the nullary constructor ().

push' :: Int -> Stack -> ((), Stack)
push' = undefined


-- >>> stackManip' [5,8,2,1]
-- (5, [8,2,1])
stackManip' :: Stack -> (Int, Stack)
stackManip' stack =
  let
    ((), newStack1) = push' 3 stack
    (_, newStack2) = pop' newStack1
  in pop' newStack2

-- Record syntax for type definition
-- data Person = Person String String Int
data Person = Person
-- >>> :t firstName
-- firstName :: Person -> String
-- faker = Person { firstName = "SH", lastName = "Lee", age = 27 }
-- firstName faker
-- "SH"


-- import Control.Monad.State
-- A 'State' is a function from a state value 's' to (a produced value 'a', and a resulting state 's')
newtype State s a = State { runState :: s -> (a, s) }
-- >>> :t State
-- State :: (s -> (a, s)) -> State s a
-- >>> :t runState
-- runState :: State s a -> s -> (a, s)


-- | Run the 'State' seeded with 's' and retrieve the resulting state.
-- >>> exec (State (\s -> (9, s * 2))) 3
-- 6
exec :: State s a -> s -> s
exec = undefined


-- | Run the 'State' seeded with 's' and retrieve the resulting value.
-- >>> eval (State (\s -> (9, s * 2))) 3
-- 9
eval :: State s a -> s -> a
eval = undefined


-- | A 'State' where the state also distributes into the produced value.
-- >>> runState get 0
-- (0, 0)
get :: State s s
get = undefined
-- >>> :t runState get
-- runState get :: a -> (a, a)


-- | A 'State' where the resulting state is seeded with the given value.
-- >>> runState (put 1) 0
-- ((), 1)
-- >>> runState (put 1) 10
-- ((), 1)
put :: s -> State s ()
put = undefined
-- >>> :t runState (put 1)
-- runState (put 1) :: Num s => s -> ((), s)

-- (,) :: a -> b -> (a, b)
-- (,) () :: b -> ((), b)
-- domain of put => s
-- domain of (,) () => s
-- (,) () :: s -> ((), s)
-- range of (,) () => ((), s)
-- domain of State => s -> ((), s)
-- const :: a -> b -> a
-- >>> const 42 "hello"
-- 42
-- const . (,) ()
-- range of (,) () = domain of const
-- range of (,) () => ((), s)
-- domain of const => ((), s)
-- const :: ((), s) -> b -> ((), s)
-- State . const . (,) ()
-- range of const = domain of State
-- range of const => b -> ((), s)
-- domain of State => b -> ((), s)
-- State :: (s -> (a, s)) -> State s a
-- domain of State => s -> ((), s)
-- State :: (s -> ((), s)) -> State s ()


-- class Functor f where
--   fmap :: (a -> b) -> f a -> f b
-- f is not a concrete type but a type constructor that takes one type parameter
-- Maybe Int is a concrete type
-- Maybe is a type constructor
-- instance Functor Maybe where....
-- not instance Functor (Maybe a) where
-- Functor law
-- 1: fmap id = id
-- 2: fmap (f . g) = fmap f . fmap g

-- | Implement the 'Functor' instance for 'State s'.
-- >>> runState ((+1) <$> State (\s -> (9, s * 2))) 3
-- (10, 6)
instance Functor (State s) where
  fmap f (State rs) = undefined


-- class (Functor f) => Applicative f where
--   pure :: a -> f a
--   (<*>) :: f (a -> b) -> f a -> f b
-- >>> (+) <$> Just 1 <*> Just 2
-- 3
-- (+) <$> Just 1 <*> Just 2 = Just 3
-- (+) 1 2 = 3
-- (+) <$> (+ 3) <*> (* 100) ?????
-- intance Applicative ((->) r) where
--   pure x = (\_ -> x)
--   f <*> g = \x -> f x (g x)
-- >>> pure 3 "blah"
-- ????
-- >>> (+) <$> (+ 3) <*> (* 100) $ 5
-- ????
-- >>> (\x y z -> [x, y, z]) <$> (+ 3) <*> (* 2) <*> (/ 2) $ 5
-- | Implement the 'Applicative' instance for'State s'.
-- >>> runState (pure 2) 0
-- (2,0)
--
-- >>> runState (pure (+1) <*> pure 0) 0
-- (1,0)
--
-- >>> runState (State (\s -> ((+ 3), s ++ ["apple"])) <*> State (\s -> (7, s ++ ["banana"]))) []
-- (10, ["apple","banana"])
instance Applicative (State s) where
  pure a = undefined
  State f <*> State rs = undefined



-- | Implement the 'Monad' instance for 'State s'.
-- >>> let modify f = State (\s -> ((), f s)) in runState (modify (+ 1) >>= \() -> modify (* 2)) 7
-- ((), 16)
--
-- >>> runState ((const $ put 2) =<< put 1) 0
-- ((),2)
instance Monad (State s) where
  return = pure
  (State h) >>= f = undefined


pop :: State Stack Int
pop = undefined

push :: Int -> State Stack ()
push a = undefined

stackManip :: State Stack Int
stackManip = undefined
