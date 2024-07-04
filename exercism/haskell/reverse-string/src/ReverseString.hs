module ReverseString (reverseString) where

reverseString :: String -> String
reverseString = foldr (\c acc -> acc ++ [c]) ""
-- reverseString = reverse

-- >>> reverseString "haedosa"
-- "asodeah"
