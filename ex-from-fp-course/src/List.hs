module List where

-- data [] a =

-- foldr :: (a -> b -> b) -> b -> [a] -> b
-- foldr f z []           == z
-- foldr f z [x1, x2, x3] == f x1 (f x2 (f x3 z))
-- foldr f z [x1, x2, x3] == f x1 (foldr f z [x2, x3])
--                        == f x1 (f x2 (foldr f z [x3]))
--                        == f x1 (f x2 (f x3 (foldr f z [])))
--                        == f x1 (f x2 (f x3 z))
-- foldr f z xs = ?

-- foldl :: (b -> a -> b) -> b -> [a] -> b
-- foldl f z []           == z
-- foldl f z [x1, x2, x3] == f (f (f z x1) x2) x3
-- foldl f z [x1, x2, x3] == foldl f (f z x1) [x2, x3]
--                        == foldl f (f (f z x1) x2) [x3]
--                        == foldl f (f (f (f z x1) x2) x3) []
--                        == f (f (f z x1) x2) x3
-- foldl f z xs = ?

-- | 1. Returns the head of the list or the given default.
--
-- ghci> headOr 3 [1,2]
-- 1
--
-- ghci> headOr 3 []
-- 3
--
-- ghci> 1 `headOr` [0..] == 0
--
-- hint: const :: a -> b -> a
-- ghci> const "first argument" "always ignores second argument"
-- "first argument"
-- headOr ::
headOr =
  error "todo: Course.List#headOr"



-- | 2. The product of the elements of a list.
--
-- ghci> product' []
-- 1
--
-- ghci> product' [1:2:3:[])
-- 6
--
-- product' ::
product' =
  error "todo: Course.List#product"



-- | 3. Sum the elements of the list.
--
-- ghci> sum' []
-- 0
--
-- ghci> sum' [1, 2, 3, 4]
-- 10
--
-- ghci> f3 xs = foldl (-) (sum' xs) xs
-- ghci> f3 [1,2,3] ?
-- sum' ::
sum' =
  error "todo: Course.List#sum"



-- | 4. Return the length of the list.
--
-- ghci> length' [1, 2, 3]
-- 3
-- length' ::
length' =
  error "todo: Course.List#length"



-- | 5. Map the given function on each element of the list.
--
-- ghci> map' (+10) [1, 2, 3]
-- [11, 12, 13]
--
-- ghci> f5 x = headOr x (map (+1) [0..])
-- ghci> f5 10 ?
-- map' ::
map' =
  error "todo: Course.List#map"



-- | 5. Return elements satisfying the given predicate.
--
-- ghci> filter' even [1, 2, 3, 4]
-- [2,4]
--
-- ghci> filter' (const True) [0, 1, 2] ?
-- ghci> filter' (const False) [0, 1, 2] ?
-- filter' ::
filter' =
  error "todo: Course.List#filter"



-- | 6. Append two lists to a new list.
--
-- ghci> [1, 2, 3] +++ (4:5:6:[])
-- [1,2,3,4,5,6]
--
-- ghci> [] ++ [1, 2, 3] ?
-- (+++) ::
(+++) =
  error "todo: Course.List#(+++)"

infixr 5 +++



-- | 7. Flatten a list of lists to a list.
--
-- ghci> flatten [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
-- [1,2,3,4,5,6,7,8,9]
--
-- ghci> f7 xss = sum' (map' length' xss)
-- ghci> f7 [[1,2,3],[3,2],[9]] ?
-- flatten ::
flatten =
  error "todo: Course.List#flatten"



-- | 8. Map a function then flatten to a list.
--
-- ghci> flatMap (\x -> x:x+1:x+2:[]) [1, 2, 3]
-- [1,2,3,2,3,4,3,4,5]
-- flatMap ::
flatMap =
  error "todo: Course.List#flatMap"



-- | 9. Flatten a list of lists to a list (again).
-- HOWEVER, this time use the /flatMap/ function that you just wrote.
-- flattenAgain ::
flattenAgain =
  error "todo: Course.List#flattenAgain"



-- | 10. Convert a list of Maybe values to a Maybe list of values.
--
-- * If the list contains all `Just` values,
-- then return `Just` list of values.
--
-- * If the list contains one or more `Nothing` values,
-- then return `Nothing`.
--
-- ghci> seqMaybe [Just 1, Just 10]
-- Just [1, 10]
--
-- ghci> seqMaybe []
-- Just []
--
-- ghci> seqMaybe [Just 1, Just 10, Nothing]
-- Nothing
--
-- ghci> seqMaybe (Nothing: map Just [0..])
-- Nothing
-- seqMaybe ::
seqMaybe =
  error "todo: Course.List#seqMaybe"



-- | 11. Find the first element in the list matching the predicate.
--
-- ghci> find even [1, 3, 5]
-- Nothing
--
-- ghci> find even []
-- Nothing
--
-- ghci> find even [1, 2, 3, 5]
-- Just 2
--
-- ghci> find even [1, 2, 3, 4, 5]
-- Just 2
--
-- ghci> find (const True) [0..]
-- Just 0
-- find ::
find =
  error "todo: Course.List#find"



-- | 12. Determine if the length of the given list is greater than 4.
--
-- ghci> lengthGT4 [1, 3, 5]
-- False
--
-- ghci> lengthGT4 [1, 2, 3, 4, 5]
-- True
--
-- ghci> lengthGT4 [0..]
-- True
-- lengthGT4 ::
lengthGT4 =
  error "todo: Course.List#lengthGT4"



-- | 13. Reverse a list.
--
-- ghci> reverse' []
-- []
--
-- ghci> reverse' [1, 2, 3]
-- [3, 2, 1]
-- reverse' ::
reverse' =
  error "todo: Course.List#reverse"



-- | 14. Produce an infinite `List` that seeds with the given value at its head,
-- then runs the given function for subsequent elements
--
-- ghci> take 4 $ produce (+1) 0
-- [0,1,2,3]
--
-- ghci> take 4 $ produce (*2) 1
-- [1,2,4,8]
-- produce ::
produce f x =
  error "todo: Course.List#produce"

---- End of list exercises
