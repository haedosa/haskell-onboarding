module Pangram (isPangram) where
import Data.Char (toLower)

isPangram :: String -> Bool
isPangram [] = False
isPangram str = foldr (\b acc -> (b `elem` map toLower str) && acc) True ['a' .. 'z']
