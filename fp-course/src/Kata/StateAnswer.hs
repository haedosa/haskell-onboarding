module Kata.StateAnswer where

type Stack = [Int]

pop' :: Stack -> (Int, Stack)
pop' (x:xs) = (x, xs)

-- data () = ()
-- The unit datatype () has one non-undefined member, the nullary constructor ().

push' :: Int -> Stack -> ((), Stack)
push' x xs = ((), x:xs)


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
data Person = Person { firstName :: String
                     , lastName :: String
                     , age :: Int
                     } deriving (Show)
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
exec (State rs) = snd . rs


-- | Run the 'State' seeded with 's' and retrieve the resulting value.
-- >>> eval (State (\s -> (9, s * 2))) 3
-- 9
eval :: State s a -> s -> a
eval (State rs) = fst . rs


-- | A 'State' where the state also distributes into the produced value.
-- >>> runState get 0
-- (0, 0)
get :: State s s
get = State (\s -> (s, s))
-- >>> :t runState get
-- runState get :: a -> (a, a)


-- | A 'State' where the resulting state is seeded with the given value.
-- >>> runState (put 1) 0
-- ((), 1)
-- >>> runState (put 1) 10
-- ((), 1)
put :: s -> State s ()
put = State . const . (,) ()
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

-- >>> runState ((+1) <$> State (\s -> (9, s * 2))) 3
-- (10, 6)
instance Functor (State s) where
  fmap f (State rs) = State (\s' -> let (a, t) = rs s' in (f a, t))
