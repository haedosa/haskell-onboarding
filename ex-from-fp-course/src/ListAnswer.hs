module ListAnswer where

-- data [] a = [] | a:[a]

-- foldr :: (a -> b -> b) -> b -> [a] -> b
-- foldr f z []           == z
-- foldr f z [x1, x2, x3] == f x1 (f x2 (f x3 z))
-- foldr f z [x1, x2, x3] == f x1 (foldr f z [x2, x3])
--                        == f x1 (f x2 (foldr f z [x3]))
--                        == f x1 (f x2 (f x3 (foldr f z [])))
--                        == f x1 (f x2 (f x3 z))
-- foldr f z xs = ?
-- foldr _ b [] = b
-- foldr f b (x:xs) = f x (foldr f b xs)

-- foldl :: (b -> a -> b) -> b -> [a] -> b
-- foldl f z []           == z
-- foldl f z [x1, x2, x3] == f (f (f z x1) x2) x3
-- foldl f z [x1, x2, x3] == foldl f (f z x1) [x2, x3]
--                        == foldl f (f (f z x1) x2) [x3]
--                        == foldl f (f (f (f z x1) x2) x3) []
--                        == f (f (f z x1) x2) x3
-- foldl f z xs = ?
-- foldl _ z [] = z
-- foldl f z (x:xs) = foldl f (f z x) xs

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
headOr :: a -> [a] -> a
headOr = foldr const

headOr' :: a -> [a] -> a
headOr' x [] = x
headOr' _ (y:ys) = y

headOr'' :: a -> [a] -> a
headOr'' x y
  | null y = x
  | otherwise = head y



-- | 2. The product of the elements of a list.
--
-- ghci> product' []
-- 1
--
-- ghci> product' [1:2:3:[])
-- 6
--
product' :: Num a => [a] -> a
product' = foldl (*) 1
-- product' [] = 1
-- product' (x:xs) = x * product' xs



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
sum' :: Num a => [a] -> a
sum' = foldl (+) 0



-- | 4. Return the length of the list.
--
-- ghci> length' [1, 2, 3]
-- 3
length' :: [a] -> Int
-- length' xs = sum [1 | x <- xs]
length' = foldl (const . (+1)) 0



-- | 5. Map the given function on each element of the list.
--
-- ghci> map' (+10) [1, 2, 3]
-- [11, 12, 13]
--
-- ghci> f5 x = headOr x (map (+1) [0..])
-- ghci> f5 10 ?
map' :: (a -> b) -> [a] -> [b]
-- map' _ [] = []
-- map' f (x:xs) = f x : map' f xs
map' f = foldr (\x acc -> f x:acc) []



-- | 5. Return elements satisfying the given predicate.
--
-- ghci> filter' even [1, 2, 3, 4]
-- [2,4]
--
-- ghci> filter' (const True) [0, 1, 2] ?
-- ghci> filter' (const False) [0, 1, 2] ?
filter' :: (a -> Bool) -> [a] -> [a]
filter' p [] = []
filter' p (x:xs)
  | p x = x : filter' p xs
  | otherwise = filter' p xs

-- filter' f = foldr (\x acc -> if f x then x:acc else acc) []



-- | 6. Append two lists to a new list.
--
-- ghci> [1, 2, 3] +++ (4:5:6:[])
-- [1,2,3,4,5,6]
--
-- ghci> [] ++ [1, 2, 3] ?
(+++) :: [a] -> [a] -> [a]
-- (+++) [] ys = ys
-- (+++) (x:xs) ys = x:xs +++ ys
-- (+++) xs ys = foldr (:) ys xs
(+++) = flip (foldr (:))
infixr 5 +++



-- | 7. Flatten a list of lists to a list.
--
-- ghci> flatten [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
-- [1,2,3,4,5,6,7,8,9]
--
-- ghci> f7 xss = sum' (map' length' xss)
-- ghci> f7 [[1,2,3],[3,2],[9]] ?
flatten :: [[a]] -> [a]
flatten = foldl (+++) []
-- flatten = foldr (+++) []



-- | 8. Map a function then flatten to a list.
--
-- ghci> flatMap (\x -> x:x + 1:x + 2:[]) [1, 2, 3]
-- [1,2,3,2,3,4,3,4,5]
flatMap :: (a -> [b]) -> [a] -> [b]
-- flatMap f xs = flatten (map' f xs)
flatMap f = flatten . map' f



-- | 9. Flatten a list of lists to a list (again).
-- HOWEVER, this time use the /flatMap/ function that you just wrote.
flattenAgain :: [[a]] -> [a]
flattenAgain = flatMap id



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
seqMaybe :: [Maybe a] -> Maybe [a]
seqMaybe = foldr (twiceMaybe (:)) (Just [])

mapMaybe :: (a -> b) -> Maybe a -> Maybe b
mapMaybe _ Nothing = Nothing
mapMaybe f (Just a) = Just (f a)

bindMaybe :: (a -> Maybe b) -> Maybe a -> Maybe b
bindMaybe _ Nothing = Nothing
bindMaybe f (Just a) = f a

applyMaybe :: Maybe (a -> b) -> Maybe a -> Maybe b
applyMaybe f a = bindMaybe (\g -> mapMaybe g a) f

twiceMaybe :: (a -> b -> c) -> Maybe a -> Maybe b -> Maybe c
twiceMaybe f = applyMaybe . mapMaybe f

seqMaybe' :: [Maybe a] -> Maybe [a]
seqMaybe' = foldr ((<*>) . fmap (:)) (Just [])

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
find :: (a -> Bool) -> [a] -> Maybe a
-- find p [] = Nothing
-- find p (x:xs)
--   | p x = Just x
--   | otherwise = find p xs
find p xs = case filter' p xs of
  [] -> Nothing
  ys -> Just (head ys)



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
lengthGT4 :: [a] -> Bool
lengthGT4 (_:_:_:_:_) = True
lengthGT4 _ = False



-- | 13. Reverse a list.
--
-- ghci> reverse' []
-- []
--
-- ghci> reverse' [1, 2, 3]
-- [3, 2, 1]
reverse' :: [a] -> [a]
reverse' = foldl (flip (:)) []
-- reverse' = foldl (\acc x -> x:acc) []



-- | 14. Produce an infinite `List` that seeds with the given value at its head,
-- then runs the given function for subsequent elements
--
-- ghci> take 4 $ produce (+1) 0
-- [0,1,2,3]
--
-- ghci> take 4 $ produce (*2) 1
-- [1,2,4,8]
produce :: (a -> a) -> a -> [a]
produce f x = x : produce f (f x)

---- End of list exercises
