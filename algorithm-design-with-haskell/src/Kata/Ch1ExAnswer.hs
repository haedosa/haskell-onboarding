module Kata.Ch1ExAnswer where

type Nat = Int


-- Ex 1.1 Here are some other basic list-porcessing functions we will need.
-- To check your understanding, just give appropriate types.
-- maximum, minimum :: Ord a => [a] -> a
-- take, drop :: Int -> [a] -> [a]
-- takeWhile, dropWhile :: (a -> Bool) -> [a] -> [a]
-- inits, tails :: [a] -> [[a]]
-- splitAt :: Int -> [a] -> ([a], [a])
-- span :: (a -> Bool) -> [a] -> ([a], [a])
-- null :: [a] -> Bool
-- all :: (a -> Bool) -> [a] -> Bool
-- elem :: Eq a => a -> [a] -> Bool
-- (!!) :: [a] -> Int -> a
-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]


-- Ex 1.2 Trawling through Data.List we discovered the function
-- uncons :: [a] -> Maybe (a, [a])
-- of whose existence we were quite unconscious.
-- Guess the definition of uncons.

uncons' :: [a] -> Maybe (a,[a])
uncons' [] = Nothing
uncons' (x:xs) = Just (x, xs)


-- Ex 1.3 The library Data.List does not provide functions
-- wrap :: a -> [a]
-- unwrap :: [a] -> a
-- single :: [a] -> Bool
-- for wrapping a value into a singleton list,
-- unwrapping a singleton list into its sole occupant,
-- and testing a list for being a singleton.
-- This is a pity, for the three functions can be very useful
-- on occations and will appear a number of times in the rest of this book.
-- Give appropriate definitions.

wrap :: a -> [a]
wrap x = [x]

unwrap :: [a] -> a
unwrap [x] = x
unwrap _ = error "unwrap: not a singleton"

single :: [a] -> Bool
single [x] = True
single _ = False


-- Ex 1.4 Write down a definition of 'reverse' that takes linear time.
-- One possibility is to use a 'foldl'

reverse' :: [a] -> [a]
reverse'  = foldl (flip (:)) []


-- Ex 1.5 Express both 'map' and 'filter' as an instance of 'foldr'

map' :: (a -> b) -> [a] -> [b]
map' f = foldr op []
  where op x acc = f x:acc

filter' :: (a -> Bool) -> [a] -> [a]
filter' p = foldr op []
  where op x acc = if p x then x:acc else acc


-- Ex 1.6 Express 'foldr f e . filter p' as an instance of 'foldr'
-- foldr f e . filter p = foldr op e where op x acc = if p x then f x acc else acc


-- Ex 1.7 The function 'takeWhile' returns the longest initial segment of a list
-- all of whose elements satisfy a given test.
-- Moreover, its running time is proportional to the length of the result,
-- not the length of the input.
-- Express the 'takeWhile' as an instance of 'foldr',
-- thereby demonstrating once again that a 'foldr' need not process
-- the whole of its argument before terminating.

takeWhile' :: (a -> Bool) -> [a] -> [a]
takeWhile' p = foldr op []
  where op x acc = if p x then x:acc else []
-- takeWhile even [2,3,4,5]
-- = op 2 (takeWhile even [3,4,5])
-- = 2:takeWhile even [3,4,5]
-- = 2:op 3 (takeWhile even [4,5])
-- = 2:[]
-- = [2]


-- Ex 1.8 The Data.List library contains a function 'dropWhileEnd
-- which drops the longest suffix of a list all of whose elements
-- satisfy a given Boolean test. For example,
-- dropWhileEnd even [1,4,3,6,2,4] = [1,4,3]
-- Define 'dropWhileEnd' as an instance of 'foldr'

dropWhileEnd' :: (a -> Bool) -> [a] -> [a]
dropWhileEnd' p = foldr op []
  where op x acc = if p x && null acc then [] else x:acc
-- dropWhileEnd even [1,4,3,6,2,4]
-- = op 1 (dropWhileEnd even [4,3,6,2,4])
-- = 1:(op 4 (dropWhileEnd even [3,6,2,4]))
-- = 1:(op 4 (op 3 (dropWhileEnd even [6,2,4])))
-- = 1:(op 4 3:(op 6 (dropWhileEnd even [2,4])))
-- = 1:(op 4 3:(op 6 (2 (dropWhileEnd even [4]))))
-- = 1:(op 4 3:(op 6 (2 (op 4 (dropWhileEnd even [])))))   { foldr _ e [] = e }
-- = 1:(op 4 3:(op 6 (2 (op 4 []))))
-- = 1:(op 4 3:(op 6 (2 [])))
-- = 1:(op 4 3:(op 6 []))
-- = 1:(op 4 3:[])
-- = 1:(op 4 [3])
-- = 1:(4:[3])
-- = 1:[4,3]
-- = [1,4,3]


-- Ex 1.9 An alternative definition of 'foldr' is
-- foldr f e xs = if null xs then e else f (head xs) (foldr f e (tail xs))
-- Dually, an alternative definition of 'foldl' is
-- foldl f e xs = if null xs then e else f (foldl f e (init xs)) (last xs)
-- where 'last' and 'init' are dual to 'head' and 'tail'.
-- What is the problem with this definition of 'foldl'?

-- While
-- head :: [a] -> a
-- head (x:xs) = x
-- tail :: [a] -> [a]
-- tail (x:xs) = xs
-- both take constant time, the dual functions
-- last :: [a] -> a
-- last [x] = [x]
-- last (x:xs) = last xs
-- init :: [a] -> [a]
-- init [x] = []
-- init (x:xs) = x:init xs
-- both take linear time because the whole list has to be traversed.
-- That makes the alternative definition of 'foldl' very inefficient.


-- Ex 1.10 Bearing the examples
-- foldr (@) e [x,y,z] = x @ (y @ (z @ e))
-- foldl (@) e [x,y,z] = ((e @ x) @ y) @ z
-- in mind, under what simple conditions on @ and 'e' do we have
-- foldr (@) e xs = foldl (@) e xs
-- for all finite lists xs?

-- One simple condition is that @ is associative operation with
-- identity element 'e'.
-- For example, addition is an associative operation with identity element 0,
-- so foldr (+) 0 xs = foldl (+) 0 xs for all finite lists xs.



-- Ex 1.11 Given a list of digits representing a natural number,
-- constructs a function 'integer' which converts the digits
-- into that number. For example,
-- integer [1,4,8,4,9,3] = 148493
-- Next, given a list of digits representing a real number r
-- in range 0 <= r < 1, construct a function 'fraction'
-- which converts the digits into the corresponding fraction.
-- For example,
-- fraction [1,4,8,4,9,3] = 0.148493

integer :: [Int] -> Int
integer = foldl shiftl 0
  where shiftl acc d = 10 * acc + d

fraction :: [Int] -> Double
fraction = foldr shiftr 0.0
  where shiftr d acc = (fromIntegral d + acc) / 10



-- Ex 1.12 Complete the right-hand sides of
-- map (foldl f e) . inits = scanl f e
-- map (foldr f e) . tails = scanr f e
-- Scan Lemma
-- very useful in text-processing algorithms



-- Ex 1.13 Define the function
-- apply :: Nat -> (a -> a) -> a -> a
-- that applies a function a specified number of times to a value
-- hint: apply 3 f x = (f . f . f) x

apply :: Nat -> (a -> a) -> a -> a
apply 0 f = id
apply n f = f . apply (n - 1) f

apply' :: Nat -> (a -> a) -> a -> a
apply' 0 f = id
apply' n f = apply' (n - 1) f . f



-- Ex 1.14 Can the function 'inserts' associated with the inductive definition
-- 'perms1' be expressed as an instance of foldr?
-- inserts :: a -> [a] -> [[a]]
-- inserts x [] = [[x]]
-- inserts x (y:ys) = (x:y:ys):map (y:) (inserts x ys)

inserts' :: a -> [a] -> [[a]]
inserts' x = foldr step [[x]]
  where
    step y yss = (x:y:ys):map (y:) yss
      where
        ys = tail (head yss)


-- Ex 1.15 Give a definition of 'remove' for which
-- perms3 [] = [[]]
-- perms3 xs = [x:ys | x <- xs, y <- perms3 (remove x xs)]
-- computes the permutations of a list.
-- Is the first clause necessary?
-- What is the type of 'perm3',
-- and can one generate the permutations of a list
-- of functions with this definition?
remove :: Eq a => a -> [a] -> [a]
remove _ [] = []
remove x (y:ys) = if x == y then ys else y:remove x ys
-- The first clause of 'perm3' is indeed necessary;
-- without it we have perm3 [] = [].
-- From this one can show that 'perm3' returns the
-- empty list for all arguments.
-- The type of perms3 is perms3 :: Eq a => [a] -> [[a]],
-- so, no, one cannot generate the permutations of
-- a list of functions using this definition since
-- functions cannot be tested for equality.
